#include "codegen/codegen_impl.h"

namespace polaron {

llvm::Value* CodeGenerator::Impl::emitCall(const ast::CallExpr& call) {
    if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
        cm != nullptr && cm->safe && &call != safeGuardNode_) {  // obj?.method(...) (spec 3.7)
        return emitSafeNav(call, *cm->object);
    }
    const std::string name = flattenCallee(*call.callee);
    // `itself(...)`: a direct call to the lambda currently being emitted. Direct rather than through
    // the closure value, because the closure does not exist yet -- the body is emitted while the
    // value that will hold it is still being built. The environment pointer is this invocation's
    // own arg 0, so a recursive call sees the same captures.
    if (name == "itself" && currentLambdaFn_ != nullptr) {
        std::vector<llvm::Value*> args;
        if (currentLambdaHasEnv_) {
            args.push_back(currentFn->getArg(0));
        }
        for (std::size_t i = 0; i < call.args.size(); ++i) {
            llvm::Value* a = emitExpr(*call.args[i]);
            if (a == nullptr) {
                return nullptr;
            }
            const std::size_t pi = args.size();
            if (pi < currentLambdaFn_->arg_size()) {
                a = coerceToType(a, currentLambdaFn_->getArg(pi)->getType());
            }
            args.push_back(a);
        }
        return builder.CreateCall(currentLambdaFn_, args,
                                  currentLambdaFn_->getReturnType()->isVoidTy() ? "" : "itself.call");
    }
    // checked(expr) (spec 3.6): evaluate expr with signed +/-/* trapping on overflow instead of
    // wrapping. Opt-in, since the default is the zero-overhead wrap.
    if (name == "checked" && call.args.size() == 1) {
        const bool saved = checkedArith_;
        checkedArith_ = true;
        llvm::Value* v = emitExpr(*call.args[0]);
        checkedArith_ = saved;
        return v;
    }
    // mat4: a.multiply(b) -> mat4, a.transform(v) -> vec4, plus the mat4.identity() factory.
    if (const auto* mm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
        mm != nullptr && typeName(*mm->object) == "mat4") {
        if (mm->member == "multiply" && call.args.size() == 1) {
            llvm::Value* a = emitExpr(*mm->object);
            llvm::Value* b = emitExpr(*call.args[0]);
            return (a == nullptr || b == nullptr) ? nullptr : mat4Mul(a, b);
        }
        if (mm->member == "transform" && call.args.size() == 1) {
            llvm::Value* a = emitExpr(*mm->object);
            llvm::Value* v = emitExpr(*call.args[0]);
            return (a == nullptr || v == nullptr) ? nullptr : mat4Transform(a, v);
        }
    }
    if (name == "mat4.identity" && call.args.empty()) {
        return mat4Identity();
    }
    // Decimal.toString(): format the i128 fixed-point mantissa (scale 10^18) as a decimal String.
    if (const auto* dm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
        dm != nullptr && dm->member == "toString" && call.args.empty() &&
        typeName(*dm->object) == "Decimal") {
        llvm::Value* v = emitExpr(*dm->object);
        return v == nullptr ? nullptr : emitDecimalToString(v);
    }
    // SIMD vector methods (GLSL-style): v.dot(o)/v.length() -> float, v.normalize() -> vecN,
    // v.cross(o) -> vec3. The element-wise math lowers to plain vector instructions.
    if (const auto* vm = dynamic_cast<const ast::MemberExpr*>(call.callee.get())) {
        const int vw = vecWidth(typeName(*vm->object));
        if (vw > 0) {
            const std::string& m = vm->member;
            if (m == "dot" && call.args.size() == 1) {
                llvm::Value* a = emitExpr(*vm->object);
                llvm::Value* b = emitExpr(*call.args[0]);
                if (a == nullptr || b == nullptr) {
                    return nullptr;
                }
                return horizontalAddVec(builder.CreateFMul(a, b), vw);
            }
            if ((m == "length" || m == "normalize") && call.args.empty()) {
                llvm::Value* a = emitExpr(*vm->object);
                if (a == nullptr) {
                    return nullptr;
                }
                llvm::Value* len = builder.CreateUnaryIntrinsic(
                    llvm::Intrinsic::sqrt, horizontalAddVec(builder.CreateFMul(a, a), vw));
                if (m == "length") {
                    return len;
                }
                return builder.CreateFDiv(a, builder.CreateVectorSplat(vw, len));  // normalize
            }
            if (m == "cross" && call.args.size() == 1 && vw == 3) {
                llvm::Value* a = emitExpr(*vm->object);
                llvm::Value* b = emitExpr(*call.args[0]);
                if (a == nullptr || b == nullptr) {
                    return nullptr;
                }
                return emitCross3(a, b);
            }
        }
    }
    // `T.sizeof()` (spec issue #7): the type answers about itself -- the OOP spelling, and the one
    // to reach for when the thing measured has a name. `Memory.sizeof(x)` (below, with the rest of
    // the Memory API) is its companion, and the only way to ask about an expression.
    if (const auto* sm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
        sm != nullptr && sm->member == "sizeof" && call.args.empty()) {
        if (long long bytes = 0; sizeOfTypeName(flattenCallee(*sm->object), bytes)) {
            return builder.getInt32(static_cast<std::uint32_t>(bytes));
        }
    }
    // embed("path") (spec 36): read a file AT COMPILE TIME and materialize it as a `byte[]` constant
    // in the image. This is how a freestanding program carries data it must not load from a
    // filesystem it does not have -- a guest binary, a font, a firmware blob -- without dropping to an
    // assembly file just to write `.incbin`. The path is resolved relative to the source file that
    // wrote the call (like an include), so it moves with the code.
    if (name == "embed" && call.args.size() == 1) {
        const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(call.args[0].get());
        if (lit == nullptr) {
            error("embed(...) needs a literal path known at compile time", call.loc);
            return nullptr;
        }
        std::filesystem::path p(lit->value);
        if (p.is_relative()) {
            std::error_code ec;
            const std::filesystem::path base =
                std::filesystem::path(std::string(call.loc.file)).parent_path();
            if (!base.empty() && std::filesystem::exists(base / p, ec)) {
                p = base / p;
            }
        }
        std::ifstream f(p, std::ios::binary);
        if (!f) {
            error("embed(\"" + lit->value + "\"): cannot open the file", call.loc);
            return nullptr;
        }
        const std::string bytes((std::istreambuf_iterator<char>(f)),
                                std::istreambuf_iterator<char>());
        // Same layout every Polaron array has: [ i64 length | elements... ], so `.length` and indexing
        // work on the result with no special case anywhere else.
        llvm::Constant* len = builder.getInt64(bytes.size());
        llvm::Constant* data = llvm::ConstantDataArray::get(
            context, llvm::ArrayRef<std::uint8_t>(
                         reinterpret_cast<const std::uint8_t*>(bytes.data()), bytes.size()));
        llvm::StructType* blockTy =
            llvm::StructType::get(context, {builder.getInt64Ty(), data->getType()});
        auto* g = new llvm::GlobalVariable(
            module, blockTy, /*isConstant=*/true, llvm::GlobalValue::PrivateLinkage,
            llvm::ConstantStruct::get(blockTy, {len, data}),
            "embed." + p.filename().string());
        g->setAlignment(llvm::Align(8));
        return g;
    }
    // External C function call (spec 26): a bare call to an `extern` declaration.
    if (auto er = externReturnType.find(name); er != externReturnType.end()) {
        llvm::Function* fn = functions[name];
        std::vector<llvm::Value*> args;
        for (std::size_t i = 0; i < call.args.size(); ++i) {
            // A lambda argument to a C function is a callback: pass a raw C function pointer.
            if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(call.args[i].get())) {
                llvm::Function* cb = emitCallbackFn(*lam);
                if (cb == nullptr) {
                    return nullptr;
                }
                args.push_back(cb);
                continue;
            }
            const std::string at = typeName(*call.args[i]);
            // A by-value struct argument travels in a register: load its bytes as the ABI int.
            if (llvm::Type* reg = ffiStructRegType(at)) {
                llvm::Value* ptr = emitExpr(*call.args[i]);
                if (ptr == nullptr) {
                    return nullptr;
                }
                args.push_back(builder.CreateLoad(reg, ptr, "ffi.byval"));
                continue;
            }
            // A String maps to a C char*: pass the NUL-terminated data pointer (spec 26).
            if (at == "String" || at == "string") {
                llvm::Value* sv = emitExpr(*call.args[i]);
                if (sv == nullptr) {
                    return nullptr;
                }
                args.push_back(stringData(sv));
                continue;
            }
            llvm::Value* v = emitExpr(*call.args[i]);
            if (v == nullptr) {
                return nullptr;
            }
            if (i < fn->getFunctionType()->getNumParams()) {
                v = coerceToType(v, fn->getFunctionType()->getParamType(i));
            }
            args.push_back(v);
        }
        llvm::CallInst* rc = builder.CreateCall(fn, args);
        rc->setCallingConv(fn->getCallingConv());  // [unknown-abi] mirror foreign-world extern conv
        llvm::Value* r = rc;
        // A by-value struct return arrives in a register: store it into a fresh struct object.
        if (llvm::Type* rreg = ffiStructRegType(er->second)) {
            auto cit = classes.find(clsKey(er->second));
            llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "ffi.ret");
            builder.CreateStore(r, obj);
            (void)rreg;
            return obj;
        }
        return fn->getReturnType()->isVoidTy() ? nullptr : r;
    }
    // Channel.select()....run() (spec 20.4): a compile-time-static fluent chain, lowered to a
    // poll loop over the registered channels (with an optional timeout).
    if (const auto* runMem = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
        runMem != nullptr && runMem->member == "run" && call.args.empty()) {
        std::vector<SelectCase> cases;
        if (collectSelectChain(runMem->object.get(), cases)) {
            emitSelect(cases);
            return nullptr;
        }
    }
    // SIMD vector construction: vec4(x,y,z,w) etc. -> a <N x float> built component-wise.
    if (int w = vecWidth(name); w > 0 && static_cast<int>(call.args.size()) == w) {
        llvm::Type* vt = llvm::FixedVectorType::get(builder.getFloatTy(), static_cast<unsigned>(w));
        llvm::Value* vec = llvm::UndefValue::get(vt);
        for (int i = 0; i < w; i++) {
            llvm::Value* c = emitExpr(*call.args[i]);
            if (c == nullptr) {
                return nullptr;
            }
            vec = builder.CreateInsertElement(vec, coerceToType(c, builder.getFloatTy()),
                                              builder.getInt32(i));
        }
        return vec;
    }
    // mat4 construction: mat4(m0, ..., m15) -> a <16 x float> in row-major order.
    if (name == "mat4" && call.args.size() == 16) {
        llvm::Value* m = mat4Zero();
        for (int i = 0; i < 16; i++) {
            llvm::Value* c = emitExpr(*call.args[i]);
            if (c == nullptr) {
                return nullptr;
            }
            m = builder.CreateInsertElement(m, coerceToType(c, builder.getFloatTy()), builder.getInt32(i));
        }
        return m;
    }
    // Calling a funcptr<> value (a bare C function pointer): plain C indirect call, no environment.
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(call.callee.get())) {
        auto lit = locals.find(id->name);
        if (lit != locals.end() && lit->second.type.rfind("funcptr<", 0) == 0) {
            return emitFuncptrCall(lit->second.type,
                                   builder.CreateLoad(builder.getPtrTy(), lit->second.storage, id->name),
                                   call.args, call.loc);
        }
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get())) {
        const std::string ft = typeName(*mem);
        if (ft.rfind("funcptr<", 0) == 0) {
            return emitFuncptrCall(ft, emitExpr(*mem), call.args, call.loc);
        }
    }
    // Calling a function value: a local of type function<Ret, Params...> -> indirect call.
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(call.callee.get())) {
        auto lit = locals.find(id->name);
        if (lit != locals.end() && lit->second.type.rfind("function<", 0) == 0) {
            const std::string& ft = lit->second.type;
            const std::string inner = ft.substr(9, ft.size() - 10);  // strip "function<" ">"
            std::vector<std::string> parts = splitTypeList(inner);
            std::vector<llvm::Type*> pts;
            pts.push_back(builder.getPtrTy());  // arg 0: env
            for (std::size_t i = 1; i < parts.size(); i++) {
                pts.push_back(llvmType(parts[i]));
            }
            auto* fty = llvm::FunctionType::get(llvmType(parts[0]), pts, false);
            llvm::Value* closPtr =
                builder.CreateLoad(builder.getPtrTy(), lit->second.storage, id->name);
            // In a specialized copy this param is a known lambda: call it directly so LLVM inlines it.
            llvm::Value* fnPtr;
            if (auto bit = boundLambdas_.find(id->name); bit != boundLambdas_.end()) {
                fnPtr = bit->second;
            } else {
                fnPtr = builder.CreateLoad(builder.getPtrTy(), closPtr, "code");
            }
            llvm::Value* envSlot =
                builder.CreateGEP(builder.getPtrTy(), closPtr, builder.getInt32(1));
            llvm::Value* env = builder.CreateLoad(builder.getPtrTy(), envSlot, "env");
            std::vector<llvm::Value*> args;
            args.push_back(env);  // arg 0: env
            for (std::size_t i = 0; i < call.args.size(); ++i) {
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) {
                    return nullptr;
                }
                if (i + 1 < fty->getNumParams()) {
                    v = coerceToType(v, fty->getParamType(i + 1));
                }
                args.push_back(v);
            }
            return emitMaybeInvoke(fty, fnPtr, args);
        }
    }
    // A function-valued field/member: obj.f(args) -> indirect call through the loaded pointer.
    if (dynamic_cast<const ast::MemberExpr*>(call.callee.get()) != nullptr) {
        const std::string ft = typeName(*call.callee);
        if (ft.rfind("function<", 0) == 0) {
            const std::string inner = ft.substr(9, ft.size() - 10);
            std::vector<std::string> parts = splitTypeList(inner);
            std::vector<llvm::Type*> pts;
            pts.push_back(builder.getPtrTy());  // arg 0: env
            for (std::size_t i = 1; i < parts.size(); i++) {
                pts.push_back(llvmType(parts[i]));
            }
            auto* fty = llvm::FunctionType::get(llvmType(parts[0]), pts, false);
            llvm::Value* closPtr = emitExpr(*call.callee);  // the closure pointer
            llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), closPtr, "code");
            llvm::Value* envSlot =
                builder.CreateGEP(builder.getPtrTy(), closPtr, builder.getInt32(1));
            llvm::Value* env = builder.CreateLoad(builder.getPtrTy(), envSlot, "env");
            std::vector<llvm::Value*> args;
            args.push_back(env);  // arg 0: env
            for (std::size_t i = 0; i < call.args.size(); ++i) {
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) {
                    return nullptr;
                }
                if (i + 1 < fty->getNumParams()) {
                    v = coerceToType(v, fty->getParamType(i + 1));
                }
                args.push_back(v);
            }
            return emitMaybeInvoke(fty, fnPtr, args);
        }
    }
    // Low-level thread builtins (used by the System.Concurrency.Thread prelude class) ->
    // runtime CreateThread/WaitForSingleObject (runtime/polaron_rt.cpp).
    if (name == "System.Concurrency.__threadStart") {
        llvm::Value* clos = emitExpr(*call.args[0]);  // the function<void> closure pointer
        if (clos == nullptr) {
            return nullptr;
        }
        llvm::FunctionType* ft =
            llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
        return builder.CreateCall(module.getOrInsertFunction("__polaron_thread_spawn", ft), {clos},
                                  "thread.h");
    }
    if (name == "System.Concurrency.__threadJoin") {
        llvm::Value* h = emitExpr(*call.args[0]);  // the int64 handle
        if (h == nullptr) {
            return nullptr;
        }
        llvm::FunctionType* ft =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
        builder.CreateCall(module.getOrInsertFunction("__polaron_thread_join", ft), {h});
        return nullptr;
    }
    // GIVE UP THE REST OF THIS THREAD'S TURN. Distinct from the runtime's internal polling yield:
    // this one reaches SwitchToThread on Windows rather than Sleep(0), because Sleep(0) yields only
    // to threads of EQUAL priority and the case that deadlocks a spin is the lower-priority one.
    if (name == "System.Concurrency.__threadYield") {
        llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {}, false);
        builder.CreateCall(module.getOrInsertFunction("__polaron_thread_yield", ft), {});
        return nullptr;
    }
    // HOW MANY THREADS THIS MACHINE WILL RUN AT ONCE, to a program. The async pool has always asked
    // it; a program written in the language could not, which left every worker pool anybody writes
    // holding a number somebody guessed at their own desk.
    if (name == "System.OS.__machineThreads") {
        llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {}, false);
        return builder.CreateCall(module.getOrInsertFunction("__polaron_machine_threads", ft), {},
                                  "machine.threads");
    }
    // Mutex lock builtins (used by System.Concurrency.Mutex) -> runtime CRITICAL_SECTION.
    if (name == "System.Concurrency.__lockCreate") {
        llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {}, false);
        return builder.CreateCall(module.getOrInsertFunction("__polaron_lock_create", ft), {},
                                  "lock.h");
    }
    // Math (spec 34.6): static functions on double -> LLVM intrinsics.
    if (name.rfind("Math.", 0) == 0) {
        const std::string fn = name.substr(5);
        llvm::Intrinsic::ID id = llvm::Intrinsic::not_intrinsic;
        if (fn == "sqrt") {
            id = llvm::Intrinsic::sqrt;
        } else if (fn == "abs") {
            id = llvm::Intrinsic::fabs;
        } else if (fn == "floor") {
            id = llvm::Intrinsic::floor;
        } else if (fn == "ceil") {
            id = llvm::Intrinsic::ceil;
        } else if (fn == "round") {
            id = llvm::Intrinsic::round;
        } else if (fn == "trunc") {
            id = llvm::Intrinsic::trunc;
        } else if (fn == "sin") {
            id = llvm::Intrinsic::sin;
        } else if (fn == "cos") {
            id = llvm::Intrinsic::cos;
        } else if (fn == "exp") {
            id = llvm::Intrinsic::exp;
        } else if (fn == "log") {
            id = llvm::Intrinsic::log;
        } else if (fn == "log2") {
            id = llvm::Intrinsic::log2;
        } else if (fn == "log10") {
            id = llvm::Intrinsic::log10;
        } else if (fn == "pow") {
            id = llvm::Intrinsic::pow;
        } else if (fn == "min") {
            id = llvm::Intrinsic::minnum;
        } else if (fn == "max") {
            id = llvm::Intrinsic::maxnum;
        }
        const bool isLibm = fn == "tan" || fn == "asin" || fn == "acos" || fn == "atan" ||
                            fn == "sinh" || fn == "cosh" || fn == "tanh" || fn == "cbrt" ||
                            fn == "atan2" || fn == "hypot";
        const bool isClampLerp = fn == "clamp" || fn == "lerp";
        // Only intercept the known Math builtins; anything else (e.g. a user class named Math)
        // falls through to ordinary method resolution -- and we must not emit args until then.
        if (id != llvm::Intrinsic::not_intrinsic || isLibm || isClampLerp) {
            llvm::Type* d = builder.getDoubleTy();
            std::vector<llvm::Value*> args;
            for (const auto& a : call.args) {
                llvm::Value* v = emitExpr(*a);
                if (v == nullptr) {
                    return nullptr;
                }
                args.push_back(coerceToType(v, d));
            }
            if (id != llvm::Intrinsic::not_intrinsic) {
                return builder.CreateIntrinsic(d, id, args);
            }
            if (fn == "clamp") {  // max(lo, min(x, hi))
                llvm::Value* mn =
                    builder.CreateIntrinsic(d, llvm::Intrinsic::minnum, {args[0], args[2]});
                return builder.CreateIntrinsic(d, llvm::Intrinsic::maxnum, {args[1], mn});
            }
            if (fn == "lerp") {  // a + (b - a) * t
                llvm::Value* diff = builder.CreateFSub(args[1], args[0]);
                return builder.CreateFAdd(args[0], builder.CreateFMul(diff, args[2]));
            }
            llvm::FunctionType* ft =  // tan/asin/.../atan2/hypot -> libm
                llvm::FunctionType::get(d, std::vector<llvm::Type*>(args.size(), d), false);
            return builder.CreateCall(module.getOrInsertFunction(fn, ft), args);
        }
    }
    // Memory API (spec 17.8): low-level address-based access. `address` is an i64. Accept both the
    // qualified System.Memory.X and the short Memory.X (the semantic phase enforces the import).
    // Canonicalise the fully-qualified spelling to the short one: System.Memory.Raw.read -> Raw.read.
    const std::string memName =
        (name.rfind("System.Memory.", 0) == 0) ? name.substr(14) : name;
    // `Memory.sizeof(T)` (spec issue #7): the byte size of a type, or of an expression's type, as
    // an int. A static method on this class rather than a bare word the language reserves -- a
    // size is a question about memory, so it is asked of the type that owns memory. Folded here
    // and not emitted: it is a compile-time constant, which is what lets a `static_assert` hold a
    // struct to a byte budget.
    //
    // The argument is taken as a TYPE whenever it names one (including a primitive or a vec2,
    // which `llvmType` alone cannot tell from an expression), and only otherwise as an expression
    // whose static type is measured.
    if (memName == "Raw.sizeof" && call.args.size() == 1) {
        long long bytes = 0;
        if (sizeOfTypeName(flattenCallee(*call.args[0]), bytes) ||
            sizeOfTypeName(typeName(*call.args[0]), bytes)) {
            return builder.getInt32(static_cast<std::uint32_t>(bytes));
        }
        error("Raw.sizeof(...) needs a type or an expression with a known type", call.loc);
        return nullptr;
    }
    if (memName == "Allocator.alloc") {
        llvm::Value* n = emitExpr(*call.args[0]);
        if (n == nullptr) {
            return nullptr;
        }
        llvm::Value* p = builder.CreateCall(
            mallocFn(), {builder.CreateIntCast(n, builder.getInt64Ty(), false)}, "mem.alloc");
        return builder.CreatePtrToInt(p, builder.getInt64Ty());
    }
    if (memName == "Allocator.free") {
        llvm::Value* a = emitExpr(*call.args[0]);
        if (a == nullptr) {
            return nullptr;
        }
        builder.CreateCall(freeFn(), {builder.CreateIntToPtr(a, builder.getPtrTy())});
        return nullptr;
    }
    if (memName == "Raw.getMemory") {
        llvm::Value* p = emitLValue(*call.args[0]);  // the target's storage address
        if (p == nullptr) {
            return nullptr;
        }
        return builder.CreatePtrToInt(p, builder.getInt64Ty());
    }
    if (memName == "Raw.read") {
        llvm::Value* a = emitExpr(*call.args[0]);
        if (a == nullptr) {
            return nullptr;
        }
        llvm::Type* t = llvmType(call.typeArgs.empty() ? "int" : call.typeArgs[0]);
        return builder.CreateLoad(t, builder.CreateIntToPtr(a, builder.getPtrTy()), "mem.read");
    }
    if (memName == "Raw.write") {
        llvm::Value* a = emitExpr(*call.args[0]);
        llvm::Value* v = emitExpr(*call.args[1]);
        if (a == nullptr || v == nullptr) {
            return nullptr;
        }
        // Store as the declared <T>, not as the value's own type: Memory.write<float>(addr, 1.0)
        // must write 4 bytes, coercing the double literal down -- otherwise it writes 8 and runs
        // past the end of the buffer (heap corruption). Mirrors Memory.read<T>.
        llvm::Type* t = llvmType(call.typeArgs.empty() ? "int" : call.typeArgs[0]);
        v = coerceToType(v, t);
        builder.CreateStore(v, builder.CreateIntToPtr(a, builder.getPtrTy()));
        return nullptr;
    }
    // Time (spec 34): clock + sleep builtins lowering to runtime helpers.
    if (name.rfind("Time.", 0) == 0) {
        const std::string fn = name.substr(5);
        if (fn == "sleep") {
            llvm::Value* ms = fitInt(emitExpr(*call.args[0]), 64);
            if (ms == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
            builder.CreateCall(module.getOrInsertFunction("__polaron_sleep", ft), {ms});
            return nullptr;
        }
        if (fn == "millis" || fn == "nanos" || fn == "unixMillis") {
            const char* rfn = fn == "millis"  ? "__polaron_now_ms"
                              : fn == "nanos" ? "__polaron_now_ns"
                                              : "__polaron_unix_ms";
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {}, false);
            return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {});
        }
    }
    // Bits: reinterpret a double's IEEE-754 bits as a long and back (no conversion, no rounding).
    if (name == "Bits.doubleToLong" || name == "Bits.longToDouble") {
        llvm::Value* v = emitExpr(*call.args[0]);
        if (v == nullptr) {
            return nullptr;
        }
        return name == "Bits.doubleToLong"
                   ? builder.CreateBitCast(v, builder.getInt64Ty(), "bits.d2l")
                   : builder.CreateBitCast(fitInt(v, 64), builder.getDoubleTy(), "bits.l2d");
    }
    // Ipc (spec 2.8): the cross-program transport. listen/accept/connect deal in program NAMES;
    // send/recv deal in whole length-prefixed frames, so the Polaron side never reassembles a stream.
    if (name.rfind("Ipc.", 0) == 0) {
        const std::string fn = name.substr(4);
        llvm::Type* p = builder.getPtrTy();
        llvm::Type* i64 = builder.getInt64Ty();
        if (fn == "listen" || fn == "connect") {
            llvm::Value* nm = emitExpr(*call.args[0]);
            if (nm == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p}, false);
            return builder.CreateCall(
                module.getOrInsertFunction(fn == "listen" ? "__polaron_ipc_listen" : "__polaron_ipc_connect",
                                           ft),
                {stringData(nm)});
        }
        if (fn == "accept") {
            llvm::Value* srv = emitExpr(*call.args[0]);
            if (srv == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_ipc_accept", ft),
                                      {fitInt(srv, 64)});
        }
        if (fn == "send") {
            llvm::Value* conn = emitExpr(*call.args[0]);
            llvm::Value* data = emitExpr(*call.args[1]);
            if (conn == nullptr || data == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_ipc_send", ft),
                                      {fitInt(conn, 64), stringData(data), stringLen(data)});
        }
        if (fn == "recv") {
            llvm::Value* conn = emitExpr(*call.args[0]);
            if (conn == nullptr) {
                return nullptr;
            }
            llvm::Value* lenSlot = createEntryAlloca("ipc.len", i64);
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {i64, p}, false);
            llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction("__polaron_ipc_recv", ft),
                                                  {fitInt(conn, 64), lenSlot});
            llvm::Value* len = builder.CreateLoad(i64, lenSlot, "ipc.n");
            return ownedStr(emitStringFromParts(len, buf));
        }
        if (fn == "close") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
            builder.CreateCall(module.getOrInsertFunction("__polaron_ipc_close", ft), {fitInt(h, 64)});
            return nullptr;
        }
    }
    // Net (spec 34): TCP client builtins lowering to runtime winsock helpers.
    if (name.rfind("Net.", 0) == 0) {
        const std::string fn = name.substr(4);
        llvm::Type* p = builder.getPtrTy();
        llvm::Type* i64 = builder.getInt64Ty();
        if (fn == "connect") {
            llvm::Value* host = emitExpr(*call.args[0]);
            llvm::Value* port = emitExpr(*call.args[1]);
            if (host == nullptr || port == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, builder.getInt32Ty()}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_tcp_connect", ft),
                                      {stringData(host), fitInt(port, 32)});
        }
        if (fn == "send") {
            llvm::Value* sock = emitExpr(*call.args[0]);
            llvm::Value* data = emitExpr(*call.args[1]);
            if (sock == nullptr || data == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_tcp_send", ft),
                                      {fitInt(sock, 64), stringData(data), stringLen(data)});
        }
        if (fn == "recv") {
            llvm::Value* sock = emitExpr(*call.args[0]);
            llvm::Value* max = emitExpr(*call.args[1]);
            if (sock == nullptr || max == nullptr) {
                return nullptr;
            }
            llvm::Value* cap = fitInt(max, 64);
            llvm::Value* buf = builder.CreateCall(
                mallocFn(), {builder.CreateAdd(cap, builder.getInt64(1))}, "rc.buf");
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            llvm::Value* n = builder.CreateCall(module.getOrInsertFunction("__polaron_tcp_recv", ft),
                                                {fitInt(sock, 64), buf, cap});
            llvm::Value* len = builder.CreateSelect(
                builder.CreateICmpSLT(n, builder.getInt64(0)), builder.getInt64(0), n);
            builder.CreateStore(builder.getInt8(0),
                                builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
            return ownedStr(emitStringFromParts(len, buf));
        }
        if (fn == "close") {
            llvm::Value* sock = emitExpr(*call.args[0]);
            if (sock == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
            builder.CreateCall(module.getOrInsertFunction("__polaron_tcp_close", ft), {fitInt(sock, 64)});
            return nullptr;
        }
        if (fn == "listen") {  // (port) -> listening socket
            llvm::Value* port = emitExpr(*call.args[0]);
            if (port == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {builder.getInt32Ty()}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_tcp_listen", ft),
                                      {fitInt(port, 32)});
        }
        if (fn == "accept") {  // (server) -> connection socket
            llvm::Value* server = emitExpr(*call.args[0]);
            if (server == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_tcp_accept", ft),
                                      {fitInt(server, 64)});
        }
        if (fn == "udpOpen") {  // (port) -> UDP socket (port 0 = ephemeral)
            llvm::Value* port = emitExpr(*call.args[0]);
            if (port == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {builder.getInt32Ty()}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_udp_open", ft),
                                      {fitInt(port, 32)});
        }
        if (fn == "udpSend") {  // (sock, host, port, data) -> bytes sent
            llvm::Value* sock = emitExpr(*call.args[0]);
            llvm::Value* host = emitExpr(*call.args[1]);
            llvm::Value* port = emitExpr(*call.args[2]);
            llvm::Value* data = emitExpr(*call.args[3]);
            if (sock == nullptr || host == nullptr || port == nullptr || data == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft =
                llvm::FunctionType::get(i64, {i64, p, builder.getInt32Ty(), p, i64}, false);
            return builder.CreateCall(
                module.getOrInsertFunction("__polaron_udp_sendto", ft),
                {fitInt(sock, 64), stringData(host), fitInt(port, 32), stringData(data), stringLen(data)});
        }
        if (fn == "udpRecv") {  // (sock, max) -> datagram payload
            llvm::Value* sock = emitExpr(*call.args[0]);
            llvm::Value* max = emitExpr(*call.args[1]);
            if (sock == nullptr || max == nullptr) {
                return nullptr;
            }
            llvm::Value* cap = fitInt(max, 64);
            llvm::Value* buf = builder.CreateCall(
                mallocFn(), {builder.CreateAdd(cap, builder.getInt64(1))}, "urc.buf");
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            llvm::Value* n = builder.CreateCall(module.getOrInsertFunction("__polaron_udp_recvfrom", ft),
                                                {fitInt(sock, 64), buf, cap});
            llvm::Value* len = builder.CreateSelect(
                builder.CreateICmpSLT(n, builder.getInt64(0)), builder.getInt64(0), n);
            builder.CreateStore(builder.getInt8(0),
                                builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
            return ownedStr(emitStringFromParts(len, buf));
        }
        if (fn == "udpPeerHost") {  // () -> last datagram's sender IP
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {}, false);
            llvm::Value* cstr =
                builder.CreateCall(module.getOrInsertFunction("__polaron_udp_peer_host", ft), {});
            llvm::FunctionCallee strlenFn =
                module.getOrInsertFunction("strlen", llvm::FunctionType::get(i64, {p}, false));
            return emitStringFromParts(builder.CreateCall(strlenFn, {cstr}, "ph.len"), cstr);
        }
        if (fn == "udpPeerPort") {  // () -> last datagram's sender port
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_udp_peer_port", ft), {});
        }
        if (fn == "udpClose") {
            llvm::Value* sock = emitExpr(*call.args[0]);
            if (sock == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
            builder.CreateCall(module.getOrInsertFunction("__polaron_udp_close", ft), {fitInt(sock, 64)});
            return nullptr;
        }
    }
    // Process (spec 34): Process.run(cmd) runs the command through the shell, captures its stdout
    // and exit code, and returns a ProcessResult built from them.
    if (name == "Process.run") {
        llvm::Value* cmd = emitExpr(*call.args[0]);
        if (cmd == nullptr) {
            return nullptr;
        }
        llvm::Type* p = builder.getPtrTy();
        llvm::Value* lenSlot = createEntryAlloca("pr.len", builder.getInt64Ty());
        llvm::Value* exitSlot = createEntryAlloca("pr.exit", builder.getInt32Ty());
        llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p, p}, false);
        llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction("__polaron_process_run", ft),
                                              {stringData(cmd), lenSlot, exitSlot});
        llvm::Value* output = emitStringFromParts(
            builder.CreateLoad(builder.getInt64Ty(), lenSlot, "pr.n"), buf);
        llvm::Value* code = builder.CreateLoad(builder.getInt32Ty(), exitSlot, "pr.rc");
        auto cit = classes.find("ProcessResult");
        if (cit == classes.end()) { error("ProcessResult is unavailable", call.loc); return nullptr; }
        llvm::Function* ctorFn = functions["ProcessResult.ProcessResult"];
        llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "procres");
        builder.CreateCall(ctorFn, {obj, coerceToType(output, ctorFn->getArg(1)->getType()),
                                    coerceToType(code, ctorFn->getArg(2)->getType())});
        return obj;
    }
    // Persistent subprocess (debugger/LSP): low-level builtins behind the System.OS.Subprocess class.
    // The handle is a long (the runtime's heap pointer as i64). See runtime/polaron_rt.cpp __polaron_subproc_*.
    if (name.rfind("Subproc.", 0) == 0) {
        const std::string fn = name.substr(8);
        llvm::Type* p = builder.getPtrTy();
        llvm::Type* i64 = builder.getInt64Ty();
        llvm::Type* i32 = builder.getInt32Ty();
        if (fn == "spawn" || fn == "spawnCombined" || fn == "spawnVisible") {
            llvm::Value* cmd = emitExpr(*call.args[0]);
            if (cmd == nullptr) {
                return nullptr;
            }
            // spawnCombined: the child's stderr shares its stdout pipe, so one read() sees everything
            // it printed -- what a caller wants from a compiler, and what would corrupt a DAP stream.
            // spawnVisible: give the child its own console window (an interactive tool the user should
            // see); spawn/spawnCombined are windowless (a background tool piped to us).
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, i64, i64}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_subproc_spawn_ex", ft),
                                      {stringData(cmd),
                                       llvm::ConstantInt::get(i64, fn == "spawnCombined" ? 1 : 0),
                                       llvm::ConstantInt::get(i64, fn == "spawnVisible" ? 1 : 0)});
        }
        if (fn == "writeStr") {
            llvm::Value* h = emitExpr(*call.args[0]);
            llvm::Value* data = emitExpr(*call.args[1]);
            if (h == nullptr || data == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            llvm::Value* n = builder.CreateCall(
                module.getOrInsertFunction("__polaron_subproc_write", ft),
                {fitInt(h, 64), stringData(data), stringLen(data)});
            return builder.CreateTrunc(n, i32);
        }
        if (fn == "readChunk") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            llvm::Value* lenSlot = createEntryAlloca("sp.len", i64);
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {i64, p}, false);
            llvm::Value* buf = builder.CreateCall(
                module.getOrInsertFunction("__polaron_subproc_read", ft), {fitInt(h, 64), lenSlot});
            return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot, "sp.n"), buf));
        }
        if (fn == "isAlive" || fn == "canRead") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            const char* sym =
                fn == "canRead" ? "__polaron_subproc_can_read" : "__polaron_subproc_alive";
            llvm::FunctionType* ft = llvm::FunctionType::get(i32, {i64}, false);
            return builder.CreateCall(module.getOrInsertFunction(sym, ft), {fitInt(h, 64)});
        }
        if (fn == "closeStdin" || fn == "kill") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            const char* sym =
                fn == "closeStdin" ? "__polaron_subproc_close_stdin" : "__polaron_subproc_close";
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
            builder.CreateCall(module.getOrInsertFunction(sym, ft), {fitInt(h, 64)});
            return nullptr;
        }
    }
    // Pseudo-console for the integrated terminal: low-level builtins behind System.OS.Pty. Handle is a
    // long (the runtime's LdpPty pointer). See runtime/polaron_rt.cpp __polaron_conpty_*.
    if (name.rfind("Conpty.", 0) == 0) {
        const std::string fn = name.substr(7);
        llvm::Type* p = builder.getPtrTy();
        llvm::Type* i64 = builder.getInt64Ty();
        llvm::Type* i32 = builder.getInt32Ty();
        if (fn == "spawn") {
            llvm::Value* cmd = emitExpr(*call.args[0]);
            llvm::Value* cols = emitExpr(*call.args[1]);
            llvm::Value* rows = emitExpr(*call.args[2]);
            if (cmd == nullptr || cols == nullptr || rows == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, i32, i32}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_conpty_spawn", ft),
                                      {stringData(cmd), fitInt(cols, 32), fitInt(rows, 32)});
        }
        if (fn == "writeStr") {
            llvm::Value* h = emitExpr(*call.args[0]);
            llvm::Value* data = emitExpr(*call.args[1]);
            if (h == nullptr || data == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            llvm::Value* n = builder.CreateCall(
                module.getOrInsertFunction("__polaron_conpty_write", ft),
                {fitInt(h, 64), stringData(data), stringLen(data)});
            return builder.CreateTrunc(n, i32);
        }
        if (fn == "readChunk") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            llvm::Value* lenSlot = createEntryAlloca("pty.len", i64);
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {i64, p}, false);
            llvm::Value* buf = builder.CreateCall(
                module.getOrInsertFunction("__polaron_conpty_read", ft), {fitInt(h, 64), lenSlot});
            return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot, "pty.n"), buf));
        }
        if (fn == "isAlive" || fn == "canRead") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            const char* sym =
                fn == "canRead" ? "__polaron_conpty_can_read" : "__polaron_conpty_alive";
            llvm::FunctionType* ft = llvm::FunctionType::get(i32, {i64}, false);
            return builder.CreateCall(module.getOrInsertFunction(sym, ft), {fitInt(h, 64)});
        }
        if (fn == "resize") {
            llvm::Value* h = emitExpr(*call.args[0]);
            llvm::Value* cols = emitExpr(*call.args[1]);
            llvm::Value* rows = emitExpr(*call.args[2]);
            if (h == nullptr || cols == nullptr || rows == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getVoidTy(), {i64, i32, i32}, false);
            builder.CreateCall(module.getOrInsertFunction("__polaron_conpty_resize", ft),
                               {fitInt(h, 64), fitInt(cols, 32), fitInt(rows, 32)});
            return nullptr;
        }
        if (fn == "close") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
            builder.CreateCall(module.getOrInsertFunction("__polaron_conpty_close", ft), {fitInt(h, 64)});
            return nullptr;
        }
    }
    // Env (spec 34): environment variables.
    if (name == "Env.get") {
        llvm::Value* nm = emitExpr(*call.args[0]);
        if (nm == nullptr) {
            return nullptr;
        }
        llvm::Type* p = builder.getPtrTy();
        llvm::Value* lenSlot = createEntryAlloca("ev.len", builder.getInt64Ty());
        llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p}, false);
        llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction("__polaron_env_get", ft),
                                              {stringData(nm), lenSlot});
        return ownedStr(emitStringFromParts(builder.CreateLoad(builder.getInt64Ty(), lenSlot, "ev.n"), buf));
    }
    if (name == "Env.set") {
        llvm::Value* nm = emitExpr(*call.args[0]);
        llvm::Value* val = emitExpr(*call.args[1]);
        if (nm == nullptr || val == nullptr) {
            return nullptr;
        }
        llvm::Type* p = builder.getPtrTy();
        llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p, p}, false);
        return builder.CreateCall(module.getOrInsertFunction("__polaron_env_set", ft),
                                  {stringData(nm), stringData(val)});
    }
    // executablePath(): the running program's own path -- a heap char* from the runtime.
    if (name == "Env.executablePath") {
        llvm::Type* p = builder.getPtrTy();
        llvm::Type* i64 = builder.getInt64Ty();
        llvm::FunctionType* ft = llvm::FunctionType::get(p, {}, false);
        llvm::Value* cstr =
            builder.CreateCall(module.getOrInsertFunction("__polaron_executable_path", ft), {});
        llvm::FunctionCallee strlenFn =
            module.getOrInsertFunction("strlen", llvm::FunctionType::get(i64, {p}, false));
        return ownedStr(emitStringFromParts(builder.CreateCall(strlenFn, {cstr}, "exe.len"), cstr));
    }
    // File I/O (spec 34.4): static methods lowering to runtime stdio helpers.
    if (name.rfind("File.", 0) == 0) {
        const std::string fn = name.substr(5);
        llvm::Type* p = builder.getPtrTy();
        if (fn == "readAll") {
            llvm::Value* s = emitExpr(*call.args[0]);
            if (s == nullptr) {
                return nullptr;
            }
            llvm::Value* lenSlot = builder.CreateAlloca(builder.getInt64Ty(), nullptr, "fr.len");
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p}, false);
            llvm::Value* buf = builder.CreateCall(
                module.getOrInsertFunction("__polaron_file_read_all", ft), {stringData(s), lenSlot});
            llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), lenSlot, "fr.n");
            return ownedStr(emitStringFromParts(len, buf));
        }
        if (fn == "writeAll" || fn == "appendAll") {
            llvm::Value* path = emitExpr(*call.args[0]);
            llvm::Value* content = emitExpr(*call.args[1]);
            if (path == nullptr || content == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(
                builder.getInt32Ty(), {p, p, builder.getInt64Ty(), builder.getInt32Ty()}, false);
            return builder.CreateCall(
                module.getOrInsertFunction("__polaron_file_write_all", ft),
                {stringData(path), stringData(content), stringLen(content),
                 builder.getInt32(fn == "appendAll" ? 1 : 0)});
        }
        if (fn == "exists" || fn == "remove") {
            llvm::Value* path = emitExpr(*call.args[0]);
            if (path == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p}, false);
            const char* rfn = fn == "exists" ? "__polaron_file_exists" : "__polaron_file_delete";
            return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {stringData(path)});
        }
        // Directory / filesystem metadata (spec 34.4).
        if (fn == "list") {  // newline-separated directory entries
            llvm::Value* path = emitExpr(*call.args[0]);
            if (path == nullptr) {
                return nullptr;
            }
            llvm::Value* lenSlot = createEntryAlloca("dl.len", builder.getInt64Ty());
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p}, false);
            llvm::Value* buf = builder.CreateCall(
                module.getOrInsertFunction("__polaron_dir_list", ft), {stringData(path), lenSlot});
            return ownedStr(emitStringFromParts(builder.CreateLoad(builder.getInt64Ty(), lenSlot, "dl.n"), buf));
        }
        // Open files: the handle is a `long`, and the buffer crosses as an `address` (already 64 bits
        // on every target, by the rule in docs/design/porting.md), so nothing here has to know how wide
        // a pointer is on the machine it is compiled for.
        if (fn == "open") {
            llvm::Value* path = emitExpr(*call.args[0]);
            llvm::Value* mode = emitExpr(*call.args[1]);
            if (path == nullptr || mode == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {p, p}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_fopen", ft),
                                      {stringData(path), stringData(mode)});
        }
        if (fn == "readInto" || fn == "writeFrom") {
            llvm::Value* h = emitExpr(*call.args[0]);
            llvm::Value* addr = emitExpr(*call.args[1]);
            llvm::Value* n = emitExpr(*call.args[2]);
            if (h == nullptr || addr == nullptr || n == nullptr) {
                return nullptr;
            }
            llvm::Type* i64 = builder.getInt64Ty();
            llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
            const char* rfn = fn == "readInto" ? "__polaron_fread" : "__polaron_fwrite";
            return builder.CreateCall(
                module.getOrInsertFunction(rfn, ft),
                {builder.CreateIntCast(h, i64, true), builder.CreateIntToPtr(addr, p),
                 builder.CreateIntCast(n, i64, true)});
        }
        if (fn == "seek") {
            llvm::Value* h = emitExpr(*call.args[0]);
            llvm::Value* off = emitExpr(*call.args[1]);
            llvm::Value* whence = emitExpr(*call.args[2]);
            if (h == nullptr || off == nullptr || whence == nullptr) {
                return nullptr;
            }
            llvm::Type* i64 = builder.getInt64Ty();
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getInt32Ty(), {i64, i64, builder.getInt32Ty()}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_fseek", ft),
                                      {builder.CreateIntCast(h, i64, true),
                                       builder.CreateIntCast(off, i64, true),
                                       builder.CreateIntCast(whence, builder.getInt32Ty(), true)});
        }
        if (fn == "tell" || fn == "flush" || fn == "close" || fn == "atEnd") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) {
                return nullptr;
            }
            llvm::Type* i64 = builder.getInt64Ty();
            llvm::Type* ret = fn == "tell" ? i64 : static_cast<llvm::Type*>(builder.getInt32Ty());
            llvm::FunctionType* ft = llvm::FunctionType::get(ret, {i64}, false);
            const char* rfn = fn == "tell"    ? "__polaron_ftell"
                              : fn == "flush" ? "__polaron_fflush"
                              : fn == "close" ? "__polaron_fclose"
                                              : "__polaron_feof";
            return builder.CreateCall(module.getOrInsertFunction(rfn, ft),
                                      {builder.CreateIntCast(h, i64, true)});
        }
        if (fn == "size" || fn == "mtime") {
            llvm::Value* path = emitExpr(*call.args[0]);
            if (path == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {p}, false);
            const char* rfn = fn == "size" ? "__polaron_file_size" : "__polaron_file_mtime";
            return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {stringData(path)});
        }
        // `rmdir` is its own primitive because `remove` does not take a directory on Windows: the call
        // returned 0 and there was nothing else to reach for, so a recursive delete could not be
        // written at all. The library picks between them from `isDir`.
        if (fn == "mkdir" || fn == "isDir" || fn == "rmdir") {
            llvm::Value* path = emitExpr(*call.args[0]);
            if (path == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p}, false);
            const char* rfn = fn == "mkdir"   ? "__polaron_mkdir"
                              : fn == "rmdir" ? "__polaron_rmdir"
                                              : "__polaron_is_dir";
            return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {stringData(path)});
        }
        if (fn == "rename") {
            llvm::Value* from = emitExpr(*call.args[0]);
            llvm::Value* to = emitExpr(*call.args[1]);
            if (from == nullptr || to == nullptr) {
                return nullptr;
            }
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p, p}, false);
            return builder.CreateCall(module.getOrInsertFunction("__polaron_rename", ft),
                                      {stringData(from), stringData(to)});
        }
    }
    // Memory.writeString(address, src): bulk-copy src's bytes to a raw buffer via memcpy (used by
    // StringBuilder.append, replacing a byte-at-a-time charAt/write loop).
    if (memName == "Raw.writeString") {
        llvm::Value* dstAddr = emitExpr(*call.args[0]);
        llvm::Value* srcStr = emitExpr(*call.args[1]);
        if (dstAddr == nullptr || srcStr == nullptr) {
            return nullptr;
        }
        llvm::Value* dst = builder.CreateIntToPtr(dstAddr, builder.getPtrTy());
        emitMemcpy(dst, stringData(srcStr), stringLen(srcStr));
        return nullptr;
    }
    // Memory.copy(dst, src, n): raw memcpy of n bytes between two addresses.
    if (memName == "Allocator.copy") {
        llvm::Value* dstAddr = emitExpr(*call.args[0]);
        llvm::Value* srcAddr = emitExpr(*call.args[1]);
        llvm::Value* n = fitInt(emitExpr(*call.args[2]), 64);
        if (dstAddr == nullptr || srcAddr == nullptr || n == nullptr) {
            return nullptr;
        }
        emitMemcpy(builder.CreateIntToPtr(dstAddr, builder.getPtrTy()),
                   builder.CreateIntToPtr(srcAddr, builder.getPtrTy()), n);
        return nullptr;
    }
    // Memory.readString(address, len): build a String by copying `len` bytes from a raw buffer
    // (the new String owns its own copy). Used by StringBuilder.toString().
    if (memName == "Raw.readString") {
        llvm::Value* addr = emitExpr(*call.args[0]);
        llvm::Value* len = fitInt(emitExpr(*call.args[1]), 64);
        if (addr == nullptr || len == nullptr) {
            return nullptr;
        }
        llvm::Value* src = builder.CreateIntToPtr(addr, builder.getPtrTy());
        llvm::Value* buf = builder.CreateCall(
            mallocFn(), {builder.CreateAdd(len, builder.getInt64(1))}, "fb.buf");
        emitMemcpy(buf, src, len);
        builder.CreateStore(builder.getInt8(0),
                            builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
        // Owned like every other String producer: this allocation belongs to the expression that
        // built it, so it has to be tracked or the temporary is never released. StringBuilder
        // .toString() goes through here, which made every builder-built String leak.
        return ownedStr(emitStringFromParts(len, buf));
    }
    if (name == "System.Concurrency.__chanNew") {  // used by the Channel prelude class
        llvm::Value* cap = emitExpr(*call.args[0]);
        if (cap == nullptr) {
            return nullptr;
        }
        llvm::FunctionType* ft =
            llvm::FunctionType::get(builder.getInt64Ty(), {builder.getInt64Ty()}, false);
        return builder.CreateCall(module.getOrInsertFunction("__polaron_chan_new", ft), {cap},
                                  "chan.h");
    }
    if (name == "System.Concurrency.__lockAcquire" ||
        name == "System.Concurrency.__lockRelease") {
        llvm::Value* h = emitExpr(*call.args[0]);
        if (h == nullptr) {
            return nullptr;
        }
        llvm::FunctionType* ft =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
        const char* fn = name == "System.Concurrency.__lockAcquire" ? "__polaron_lock_acquire"
                                                                    : "__polaron_lock_release";
        builder.CreateCall(module.getOrInsertFunction(fn, ft), {h});
        return nullptr;
    }
    // Console I/O (spec 4): System.IO.Console.{printf,println,print,readInt}. The pre-F10
    // names (System.IO.printf/println/readInt, bare Console.*) are kept as aliases until
    // the samples are migrated.
    {
        const bool isRead = name == "System.IO.Console.read";
        const bool isPrintf = name == "System.IO.Console.printf";
        const bool isPrintln = name == "System.IO.Console.println";
        const bool isPrint = name == "System.IO.Console.print";
        if (isRead) {
            // read() reads a line from stdin and returns it as a String -- the one input
            // primitive (spec 4). Parse it (e.g. toInt) for other types.
            llvm::Value* lenSlot = createEntryAlloca("rlen", builder.getInt64Ty());
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
            llvm::Value* buf = builder.CreateCall(
                module.getOrInsertFunction("polaron_read_line", ft), {lenSlot}, "line");
            return ownedStr(emitStringFromParts(builder.CreateLoad(builder.getInt64Ty(), lenSlot), buf));
        }
        if (isPrintf || isPrintln || isPrint) {
            const bool nl = isPrintln;
            if (!call.args.empty()) {
                if (const auto* is =
                        dynamic_cast<const ast::InterpStringExpr*>(call.args.front().get())) {
                    return emitInterp(*is, nl);
                }
            }
            if (call.args.empty()) {
                if (nl) {
                    builder.CreateCall(printf(), {createGlobalStringPtr(builder,"\n", ".str")});
                }
                return nullptr;
            }
            std::vector<llvm::Value*> args;
            // A leading string literal WITH further arguments is a printf-style format; a lone
            // literal is text and is printed as text.
            //
            // Everything used to go down the format path, so `println("50% done")` handed `%` to
            // printf as a directive with no argument behind it -- undefined behaviour that
            // fail-fasts at run time, from a line containing no formatting and no arguments.
            // Nothing about `println("...")` suggests its content is a format string, and the
            // one character that makes it one is the ordinary way to write a percentage.
            if (const auto* lit =
                    dynamic_cast<const ast::StringLiteralExpr*>(call.args.front().get());
                lit != nullptr && call.args.size() > 1) {
                args.push_back(createGlobalStringPtr(builder,
                    resolveEscapes(lit->value) + (nl ? "\n" : ""), ".str"));
                for (std::size_t i = 1; i < call.args.size(); ++i) {
                    llvm::Value* v = emitExpr(*call.args[i]);
                    if (v == nullptr) {
                        return nullptr;
                    }
                    args.push_back(asCStr(*call.args[i], v));
                }
            } else if (const auto* only =
                           dynamic_cast<const ast::StringLiteralExpr*>(call.args.front().get())) {
                // A lone literal: its own text, through a "%s" format so no character in it can
                // be read as a directive.
                args.push_back(createGlobalStringPtr(builder, nl ? "%s\n" : "%s", ".str"));
                args.push_back(createGlobalStringPtr(builder, resolveEscapes(only->value), ".str"));
            } else {
                llvm::Value* s = emitExpr(*call.args.front());
                if (s == nullptr) {
                    return nullptr;
                }
                args.push_back(createGlobalStringPtr(builder,nl ? "%s\n" : "%s", ".str"));
                args.push_back(asCStr(*call.args.front(), s));
            }
            return builder.CreateCall(printf(), args);
        }
    }
    // reflect.typeOf<T>() (spec 31): returns the Type token for class T.
    if (name == "reflect.typeOf" && !call.typeArgs.empty()) {
        return typeTokenFor(ast::mangleGeneric(call.typeArgs[0], {}));
    }
    // Namespace-level literal suffix function: name(arg). Overloaded by the argument's type
    // (spec 17.10 rule 6). (comptime in the spec; for now it runs at runtime -- see Fase C.)
    if (literalSuffixParams.count(name) > 0 && call.args.size() == 1) {
        const std::string key = chooseLiteralKey(name, typeName(*call.args[0]));
        if (auto fnit = functions.find(key); fnit != functions.end()) {
            llvm::Value* v = emitExpr(*call.args[0]);
            if (v == nullptr) {
                return nullptr;
            }
            v = coerceToType(v, fnit->second->getArg(0)->getType());
            return emitMaybeInvoke(fnit->second, {v});
        }
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get())) {
        if (mem->member == "length" && isArrayType(typeName(*mem->object))) {
            // array.length(): read the i64 length header and truncate to int.
            if (call.args.empty()) {
                llvm::Value* block = emitExpr(*mem->object);
                if (block == nullptr) {
                    return nullptr;
                }
                llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), block, "len");
                return builder.CreateTrunc(len, builder.getInt32Ty());
            }
            // array.length(n): resize (spec 25). realloc the block, zero any grown region, and
            // store the (possibly moved) block back into the array's slot.
            llvm::Value* slot = emitLValue(*mem->object);
            if (slot == nullptr) {
                error("array resize target must be assignable", call.loc);
                return nullptr;
            }
            llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "arr.old");
            llvm::Value* oldLen = builder.CreateLoad(builder.getInt64Ty(), block, "arr.oldlen");
            llvm::Value* nArg = emitExpr(*call.args[0]);
            if (nArg == nullptr) {
                return nullptr;
            }
            llvm::Value* n64 = builder.CreateSExt(nArg, builder.getInt64Ty());
            const std::uint64_t esz = byteSizeOf(elementOf(typeName(*mem->object)));
            llvm::Value* total = builder.CreateAdd(
                builder.getInt64(kArrayHeaderBytes), builder.CreateMul(n64, builder.getInt64(esz)));
            llvm::Value* nb = builder.CreateCall(reallocFn(), {block, total}, "arr.new");
            builder.CreateStore(n64, nb);  // new length header
            // Zero only the grown region [oldLen, n): count is 0 when shrinking.
            llvm::Value* grew = builder.CreateICmpSGT(n64, oldLen);
            llvm::Value* cnt = builder.CreateSelect(
                grew, builder.CreateMul(builder.CreateSub(n64, oldLen), builder.getInt64(esz)),
                builder.getInt64(0));
            llvm::Value* dst = builder.CreateGEP(builder.getInt8Ty(), arrayData(nb),
                                                 builder.CreateMul(oldLen, builder.getInt64(esz)));
            emitMemset(dst, builder.getInt32(0), cnt);
            builder.CreateStore(nb, slot);  // realloc may move the block
            return nullptr;  // resize is void
        }
        // Channel<T> blocking operations (spec 20.3): send/receive a 64-bit slot via the
        // runtime queue (blocks while full / empty).
        if (const std::string ot = baseType(typeName(*mem->object)); ot.rfind("Channel$", 0) == 0) {
            llvm::Value* obj = emitObjectPtr(*mem->object);
            if (obj == nullptr) {
                return nullptr;
            }
            auto cit = classes.find(ot);
            llvm::Value* h = builder.CreateLoad(
                builder.getInt64Ty(),
                builder.CreateStructGEP(cit->second.type, obj, cit->second.fieldIndex["h"],
                                        "chan.h.addr"),
                "chan.h");
            if (mem->member == "send") {
                llvm::Value* v = emitExpr(*call.args[0]);
                if (v == nullptr) {
                    return nullptr;
                }
                llvm::FunctionType* ft = llvm::FunctionType::get(
                    builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
                builder.CreateCall(module.getOrInsertFunction("__polaron_chan_send", ft),
                                   {h, valueToI64(v)});
                return nullptr;
            }
            if (mem->member == "receive") {
                llvm::FunctionType* ft = llvm::FunctionType::get(
                    builder.getInt64Ty(), {builder.getInt64Ty()}, false);
                llvm::Value* r = builder.CreateCall(
                    module.getOrInsertFunction("__polaron_chan_receive", ft), {h}, "chan.recv");
                return castTaskResult(r, ot.substr(8));
            }
            return nullptr;
        }
        // atomic<T> operations (spec 20.6): lower to LLVM atomic instructions.
        if (const std::string ot = baseType(typeName(*mem->object)); ot.rfind("atomic$", 0) == 0) {
            llvm::Value* obj = emitObjectPtr(*mem->object);
            if (obj == nullptr) {
                return nullptr;
            }
            auto cit = classes.find(ot);
            llvm::Value* vp = builder.CreateStructGEP(
                cit->second.type, obj, cit->second.fieldIndex["value"], "atomic.value");
            llvm::Type* et = llvmType(ot.substr(7));
            llvm::Align al(et->getPrimitiveSizeInBits() / 8);
            const auto seqcst = llvm::AtomicOrdering::SequentiallyConsistent;
            if (mem->member == "get") {
                llvm::LoadInst* ld = builder.CreateLoad(et, vp, "atomic.get");
                ld->setAtomic(seqcst);
                ld->setAlignment(al);
                return ld;
            }
            if (mem->member == "set") {
                llvm::Value* n = emitExpr(*call.args[0]);
                if (n == nullptr) {
                    return nullptr;
                }
                llvm::StoreInst* st = builder.CreateStore(n, vp);
                st->setAtomic(seqcst);
                st->setAlignment(al);
                return nullptr;
            }
            if (mem->member == "add" || mem->member == "increment") {
                llvm::Value* n = mem->member == "increment" ? llvm::ConstantInt::get(et, 1)
                                                            : emitExpr(*call.args[0]);
                if (n == nullptr) {
                    return nullptr;
                }
                llvm::Value* old = builder.CreateAtomicRMW(llvm::AtomicRMWInst::Add, vp, n, al,
                                                          seqcst);
                return builder.CreateAdd(old, n, "atomic.new");  // return the new value
            }
            if (mem->member == "compareAndSet") {
                llvm::Value* exp = emitExpr(*call.args[0]);
                llvm::Value* des = emitExpr(*call.args[1]);
                if (exp == nullptr || des == nullptr) {
                    return nullptr;
                }
                llvm::AtomicCmpXchgInst* cx =
                    builder.CreateAtomicCmpXchg(vp, exp, des, al, seqcst, seqcst);
                return builder.CreateZExt(builder.CreateExtractValue(cx, 1, "cas.ok"),
                                          builder.getInt32Ty());
            }
            return nullptr;
        }
        // String methods (spec 4): length/charAt/isEmpty/equals/concat/substring.
        if (const std::string ot = typeName(*mem->object); ot == "String" || ot == "string") {
            llvm::Value* s = emitExpr(*mem->object);
            if (s == nullptr) {
                return nullptr;
            }
            if (mem->member == "length") {
                return builder.CreateTrunc(stringLen(s), builder.getInt32Ty());
            }
            if (mem->member == "isEmpty") {
                return builder.CreateZExt(
                    builder.CreateICmpEQ(stringLen(s), builder.getInt64(0)), builder.getInt32Ty());
            }
            if (mem->member == "charAt") {
                llvm::Value* i = emitExpr(*call.args[0]);
                if (i == nullptr) {
                    return nullptr;
                }
                llvm::Value* byte = builder.CreateLoad(
                    builder.getInt8Ty(),
                    builder.CreateGEP(builder.getInt8Ty(), stringData(s), fitInt(i, 64), "ch.addr"),
                    "ch");
                return builder.CreateZExt(byte, builder.getInt32Ty());  // char is i32
            }
            if (mem->member == "equals") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                llvm::Value* cmp = builder.CreateCall(strcmpFn(), {stringData(s), stringData(o)});
                return builder.CreateZExt(builder.CreateICmpEQ(cmp, builder.getInt32(0)),
                                          builder.getInt32Ty());
            }
            if (mem->member == "concat") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                return ownedStr(emitStringConcat(s, o));
            }
            // toInt(): parse the string as a base-10 integer (spec 4) -- the typical use of read().
            if (mem->member == "toInt") {
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, false);
                return builder.CreateCall(module.getOrInsertFunction("atoi", ft), {stringData(s)});
            }
            // toDouble(): parse the string as a double (spec 4) -- sign, fraction, and 'e'
            // exponent -- mirroring toInt(). Invalid input yields 0.0 (defined, no UB), as atoi.
            if (mem->member == "toDouble") {
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getDoubleTy(), {builder.getPtrTy()}, false);
                return builder.CreateCall(module.getOrInsertFunction("atof", ft), {stringData(s)});
            }
            // string.append(x): mutate the receiver in place by replacing its {length, data} with
            // the concatenation. The receiver must be a mutable `string` (its struct is on the
            // heap; see the value-copy in coerce). Returns the receiver for chaining (spec 4).
            if (mem->member == "append") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                llvm::Value* cat = emitStringConcat(s, o);
                builder.CreateStore(stringLen(cat), builder.CreateStructGEP(stringType(), s, 0));
                builder.CreateStore(stringData(cat), builder.CreateStructGEP(stringType(), s, 1));
                builder.CreateStore(builder.getInt64(0),
                                    builder.CreateStructGEP(stringType(), s, 2));  // content changed: drop cached hash
                return s;
            }
            if (mem->member == "substring") {
                llvm::Value* start = fitInt(emitExpr(*call.args[0]), 64);
                llvm::Value* end = fitInt(emitExpr(*call.args[1]), 64);
                llvm::Value* n = builder.CreateSub(end, start);
                llvm::Value* buf = builder.CreateCall(
                    mallocFn(), {builder.CreateAdd(n, builder.getInt64(1))}, "sub.buf");
                emitMemcpy(buf, builder.CreateGEP(builder.getInt8Ty(), stringData(s), start), n);
                builder.CreateStore(builder.getInt8(0),
                                    builder.CreateGEP(builder.getInt8Ty(), buf, n));  // NUL
                return ownedStr(emitStringFromParts(n, buf));
            }
            // Search / predicates (spec 34.5): indexOf / contains / startsWith / endsWith.
            if (mem->member == "indexOf" || mem->member == "contains" ||
                mem->member == "startsWith") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                llvm::Type* p = builder.getPtrTy();
                llvm::Type* i64 = builder.getInt64Ty();
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, i64, p, i64}, false);
                llvm::Value* idx = builder.CreateCall(
                    module.getOrInsertFunction("__polaron_str_index", ft),
                    {stringData(s), stringLen(s), stringData(o), stringLen(o)});
                if (mem->member == "indexOf") {
                    return builder.CreateTrunc(idx, builder.getInt32Ty());
                }
                llvm::Value* cmp = mem->member == "contains"
                                       ? builder.CreateICmpSGE(idx, builder.getInt64(0))
                                       : builder.CreateICmpEQ(idx, builder.getInt64(0));
                return builder.CreateZExt(cmp, builder.getInt32Ty());
            }
            if (mem->member == "endsWith") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                llvm::Type* p = builder.getPtrTy();
                llvm::Type* i64 = builder.getInt64Ty();
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getInt32Ty(), {p, i64, p, i64}, false);
                return builder.CreateCall(module.getOrInsertFunction("__polaron_str_ends", ft),
                                          {stringData(s), stringLen(s), stringData(o), stringLen(o)});
            }
            // Transforms (spec 34.5): toUpper / toLower / trim / repeat (new owned Strings).
            if (mem->member == "toUpper" || mem->member == "toLower") {
                llvm::Type* p = builder.getPtrTy();
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(p, {p, builder.getInt64Ty()}, false);
                const char* fn = mem->member == "toUpper" ? "__polaron_str_upper" : "__polaron_str_lower";
                llvm::Value* len = stringLen(s);
                llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction(fn, ft),
                                                      {stringData(s), len});
                return ownedStr(emitStringFromParts(len, buf));
            }
            if (mem->member == "trim") {
                llvm::Type* p = builder.getPtrTy();
                llvm::Type* i64 = builder.getInt64Ty();
                llvm::Value* lenSlot = builder.CreateAlloca(i64, nullptr, "trim.len");
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, i64, p}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("__polaron_str_trim", ft),
                    {stringData(s), stringLen(s), lenSlot});
                return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot), buf));
            }
            if (mem->member == "repeat") {
                llvm::Value* count = fitInt(emitExpr(*call.args[0]), 64);
                if (count == nullptr) {
                    return nullptr;
                }
                llvm::Type* p = builder.getPtrTy();
                llvm::Type* i64 = builder.getInt64Ty();
                llvm::Value* lenSlot = builder.CreateAlloca(i64, nullptr, "rep.len");
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, i64, i64, p}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("__polaron_str_repeat", ft),
                    {stringData(s), stringLen(s), count, lenSlot});
                return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot), buf));
            }
            if (mem->member == "toString") {
                return s;  // identity
            }
            // String satisfies Hashable<String>/Comparable<String> (collections).
            if (mem->member == "hash") {
                return builder.CreateCall(strHashFn(), {s});  // s is the String object; hash cached in it
            }
            if (mem->member == "equalsKey") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                llvm::Value* cmp = builder.CreateCall(strcmpFn(), {stringData(s), stringData(o)});
                return builder.CreateZExt(builder.CreateICmpEQ(cmp, builder.getInt32(0)),
                                          builder.getInt32Ty());
            }
            if (mem->member == "compareTo") {
                llvm::Value* o = emitExpr(*call.args[0]);
                if (o == nullptr) {
                    return nullptr;
                }
                return builder.CreateCall(strcmpFn(), {stringData(s), stringData(o)});  // sign matters
            }
        }
        // float.toString() / double.toString(): %g text, matching what string interpolation
        // prints for the same value. A record with a float field depends on this -- its
        // synthesized toString() calls toString() on every field.
        if (isFloatType(typeName(*mem->object)) && mem->member == "toString" &&
            call.args.empty()) {
            llvm::Value* a = emitExpr(*mem->object);
            if (a == nullptr) {
                return nullptr;
            }
            a = coerce(a, typeName(*mem->object), "double");
            llvm::Value* buf =
                builder.CreateCall(mallocFn(), {builder.getInt64(32)}, "ftoa.buf");
            llvm::Value* len = builder.CreateCall(ftoaFn(), {a, buf});
            return ownedStr(emitStringFromParts(len, buf));
        }
        // boolean.toString(): "true" or "false". The SELECT picks the spelling, so exactly one
        // String is built -- constructing both and choosing afterwards would leak the other.
        //
        // The bytes are COPIED into a fresh buffer rather than pointing at the constant array,
        // because the result is an owned String and scope exit frees its data: handing it a
        // private global would free a global. This is the same shape as the int and float paths
        // above for the same reason, and it is why they malloc a buffer before formatting.
        if (typeName(*mem->object) == "boolean" && mem->member == "toString" &&
            call.args.empty()) {
            llvm::Value* b = emitExpr(*mem->object);
            if (b == nullptr) {
                return nullptr;
            }
            llvm::Value* cond = builder.CreateICmpNE(
                b, llvm::ConstantInt::get(b->getType(), 0), "b.istrue");
            llvm::Value* text =
                builder.CreateSelect(cond, emitBytesLiteral("true"), emitBytesLiteral("false"));
            llvm::Value* len =
                builder.CreateSelect(cond, builder.getInt64(4), builder.getInt64(5));
            llvm::Value* buf =
                builder.CreateCall(mallocFn(), {builder.getInt64(6)}, "btoa.buf");
            builder.CreateMemCpy(buf, llvm::MaybeAlign(1), text, llvm::MaybeAlign(1),
                                 builder.CreateAdd(len, builder.getInt64(1)));  // with the NUL
            return ownedStr(emitStringFromParts(len, buf));
        }
        // Integer keys satisfy Hashable<T>/Comparable<T> via builtins (collections). Gate on the
        // builtin member names so this never intercepts ClassName.staticMethod() (whose receiver
        // typeName falls back to "int").
        // FLOATING-POINT: the same three, on the floating-point instructions. A list of measurements
        // is most of what a numeric program holds, and it did not compile.
        if (const std::string ft = typeName(*mem->object);
            isFloatType(ft) && (mem->member == "hash" || mem->member == "equalsKey" ||
                                mem->member == "compareTo")) {
            llvm::Value* a = emitExpr(*mem->object);
            if (a == nullptr) {
                return nullptr;
            }
            if (mem->member == "hash") {
                // The bit pattern, widened to 64. Equal doubles have equal bits (the one exception,
                // -0.0 against 0.0, is a distinction no map should be resolving anyway).
                llvm::Value* d = a->getType()->isDoubleTy()
                                     ? a
                                     : builder.CreateFPExt(a, builder.getDoubleTy());
                return builder.CreateBitCast(d, builder.getInt64Ty());
            }
            llvm::Value* b = emitExpr(*call.args[0]);
            if (b == nullptr) {
                return nullptr;
            }
            b = coerceToType(b, a->getType());
            if (mem->member == "equalsKey") {
                return builder.CreateZExt(builder.CreateFCmpOEQ(a, b), builder.getInt32Ty());
            }
            llvm::Value* gt = builder.CreateZExt(builder.CreateFCmpOGT(a, b), builder.getInt32Ty());
            llvm::Value* lt = builder.CreateZExt(builder.CreateFCmpOLT(a, b), builder.getInt32Ty());
            return builder.CreateSub(gt, lt);   // 1, 0 or -1
        }
        // `boolean` and `char` are in the list because a collection requires these of its ELEMENT or
        // KEY type: a list of booleans is an ordinary list, and counting how often each character
        // appears is the first program anybody writes over text. Both lower as an i32 like the rest,
        // so `equalsKey` and `compareTo` are the same comparison (for a boolean, false < true, the
        // only order there is).
        if (const std::string ot = typeName(*mem->object);
            (isIntName(ot) || ot == "boolean" || ot == "char") &&
            (mem->member == "hash" || mem->member == "toString" ||
             mem->member == "equalsKey" || mem->member == "compareTo" ||
             isIntOverflowMethod(mem->member))) {
            llvm::Value* a = emitExpr(*mem->object);
            if (a == nullptr) {
                return nullptr;
            }
            if (mem->member == "hash") {
                return fitInt(a, 64);
            }
            if (mem->member == "toString") {
                llvm::Value* buf =
                    builder.CreateCall(mallocFn(), {builder.getInt64(24)}, "itoa.buf");
                llvm::Value* len = builder.CreateCall(itoaFn(), {fitInt(a, 64), buf});
                return ownedStr(emitStringFromParts(len, buf));
            }
            llvm::Value* b = emitExpr(*call.args[0]);
            if (b == nullptr) {
                return nullptr;
            }
            b = builder.CreateSExtOrTrunc(b, a->getType());
            if (isIntOverflowMethod(mem->member)) {
                const std::string& mm = mem->member;
                if (mm == "wrappingAdd" || mm == "uncheckedAdd") {
                    return builder.CreateAdd(a, b);
                }
                if (mm == "wrappingSub" || mm == "uncheckedSub") {
                    return builder.CreateSub(a, b);
                }
                if (mm == "wrappingMul" || mm == "uncheckedMul") {
                    return builder.CreateMul(a, b);
                }
                // Division has exactly one overflow case: INT_MIN / -1, whose true quotient does not
                // fit. Wrapping it yields INT_MIN (the two's-complement wrap), which is what the
                // hardware would trap on -- so the divisor is folded to 1 in that case, and the
                // dividend (INT_MIN) comes back. A zero divisor still panics: that is not overflow,
                // it is undefined, and Polaron has no undefined behaviour to hand out (spec 3.6).
                if (mm == "wrappingDiv" || mm == "uncheckedDiv") {
                    {  // a zero divisor still panics -- that is not overflow, it is undefined
                        llvm::Value* zero =
                            builder.CreateICmpEQ(b, llvm::ConstantInt::get(b->getType(), 0));
                        auto* badBB = llvm::BasicBlock::Create(context, "div.bad", currentFn);
                        auto* okBB = llvm::BasicBlock::Create(context, "div.ok", currentFn);
                        builder.CreateCondBr(zero, badBB, okBB);
                        builder.SetInsertPoint(badBB);
                        emitGuardFail("integer division by zero", nullptr, nullptr, nullptr,
                                      nullptr, 70);
                        builder.SetInsertPoint(okBB);
                    }
                    if (isUnsigned(ot)) {
                        return builder.CreateUDiv(a, b);
                    }
                    llvm::Type* ity = a->getType();
                    const unsigned bits = ity->getIntegerBitWidth();
                    llvm::Value* minV = llvm::ConstantInt::get(
                        ity, llvm::APInt::getSignedMinValue(bits));
                    llvm::Value* isMin = builder.CreateICmpEQ(a, minV);
                    llvm::Value* isNeg1 =
                        builder.CreateICmpEQ(b, llvm::ConstantInt::getSigned(ity, -1));
                    llvm::Value* wraps = builder.CreateAnd(isMin, isNeg1, "div.wraps");
                    llvm::Value* safeB = builder.CreateSelect(
                        wraps, llvm::ConstantInt::get(ity, 1), b, "div.rhs");
                    return builder.CreateSDiv(a, safeB);
                }
                return emitSaturatingArith(mm, a, b, isUnsigned(ot));  // saturating add/sub/mul
            }
            if (mem->member == "equalsKey") {
                return builder.CreateZExt(builder.CreateICmpEQ(a, b), builder.getInt32Ty());
            }
            if (mem->member == "compareTo") {
                const bool u = isUnsigned(ot);
                llvm::Value* lt = u ? builder.CreateICmpULT(a, b) : builder.CreateICmpSLT(a, b);
                llvm::Value* gt = u ? builder.CreateICmpUGT(a, b) : builder.CreateICmpSGT(a, b);
                return builder.CreateSelect(
                    lt, builder.getInt32(-1),
                    builder.CreateSelect(gt, builder.getInt32(1), builder.getInt32(0)));
            }
        }
        // Reflection tokens (Method/Field/Annotation) satisfy Hashable by identity, so they can
        // live in a collection: equalsKey is pointer equality and hash is the pointer value.
        // `Type` is in the list for the same reason the other three are: a program that WIRES
        // objects together holds types in a collection -- a registry is `HashMap<String, Type>` or
        // `ArrayList<Type>` -- and without this, putting one in an ArrayList failed inside the
        // standard library, at `this.data[i].equalsKey(item)`, with `Type has no method 'equalsKey'`.
        // A type token is a global constant, so identity IS equality for it.
        if (const std::string ot = typeName(*mem->object);
            (ot == "Method" || ot == "Field" || ot == "Annotation" || ot == "Type") &&
            (mem->member == "equalsKey" || mem->member == "hash")) {
            llvm::Value* a = emitExpr(*mem->object);
            if (a == nullptr) {
                return nullptr;
            }
            if (mem->member == "hash") {
                return builder.CreatePtrToInt(a, builder.getInt64Ty());
            }
            llvm::Value* b = emitExpr(*call.args[0]);
            if (b == nullptr) {
                return nullptr;
            }
            return builder.CreateZExt(builder.CreateICmpEQ(a, b), builder.getInt32Ty());
        }
        // Type reflection (spec 31): name(), method/field enumeration.
        if (typeName(*mem->object) == "Type") {
            llvm::Value* t = emitExpr(*mem->object);
            if (t == nullptr) {
                return nullptr;
            }
            auto loadCount = [&](unsigned idx) {
                return builder.CreateTrunc(
                    builder.CreateLoad(builder.getInt64Ty(),
                                       builder.CreateStructGEP(typeTokenType(), t, idx), "cnt"),
                    builder.getInt32Ty());
            };
            auto loadNameAt = [&](unsigned arrIdx) -> llvm::Value* {
                llvm::Value* arr = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, arrIdx), "arr");
                llvm::Value* i = emitExpr(*call.args[0]);
                if (i == nullptr) {
                    return nullptr;
                }
                llvm::Value* slot = builder.CreateGEP(builder.getPtrTy(), arr, fitInt(i, 64), "slot");
                return builder.CreateLoad(builder.getPtrTy(), slot, "elem");
            };
            if (mem->member == "name") {
                return builder.CreateLoad(builder.getPtrTy(),
                                          builder.CreateStructGEP(typeTokenType(), t, 0), "name");
            }
            if (mem->member == "methodCount") {
                return loadCount(1);
            }
            if (mem->member == "methodName") {
                return loadNameAt(2);
            }
            if (mem->member == "fieldCount") {
                return loadCount(4);
            }
            if (mem->member == "fieldName") {
                return loadNameAt(5);
            }
            // Type.method(name): find a method by name; returns a Method token whose
            // fn is null if not found (spec 31).
            if (mem->member == "method") {
                llvm::Value* mcount = builder.CreateLoad(
                    builder.getInt64Ty(), builder.CreateStructGEP(typeTokenType(), t, 1));
                llvm::Value* mnamesArr = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 2));
                llvm::Value* mfnsArr = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 3));
                llvm::Value* mRetTagsArr = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 14));
                llvm::Value* want = stringData(emitExpr(*call.args[0]));
                llvm::Value* result =
                    builder.CreateCall(mallocFn(), {sizeOf(methodTokenType())}, "method");
                llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
                builder.CreateStore(nullp, builder.CreateStructGEP(methodTokenType(), result, 0));
                builder.CreateStore(nullp, builder.CreateStructGEP(methodTokenType(), result, 1));
                builder.CreateStore(builder.getInt64(0),
                                    builder.CreateStructGEP(methodTokenType(), result, 4));
                llvm::Function* fn = currentFn;
                llvm::Value* iSlot = createEntryAlloca("mi", builder.getInt64Ty());
                builder.CreateStore(builder.getInt64(0), iSlot);
                auto* hdr = llvm::BasicBlock::Create(context, "m.hdr", fn);
                auto* body = llvm::BasicBlock::Create(context, "m.body", fn);
                auto* hit = llvm::BasicBlock::Create(context, "m.hit", fn);
                auto* nxt = llvm::BasicBlock::Create(context, "m.next", fn);
                auto* end = llvm::BasicBlock::Create(context, "m.end", fn);
                auto* miss = llvm::BasicBlock::Create(context, "m.miss", fn);
                builder.CreateBr(hdr);
                builder.SetInsertPoint(hdr);
                llvm::Value* i = builder.CreateLoad(builder.getInt64Ty(), iSlot, "i");
                // No method with that name: fail deterministically (no-UB) instead of returning a
                // null-name/null-fn token that later derefs to garbage (spec 31 reflection).
                builder.CreateCondBr(builder.CreateICmpSLT(i, mcount), body, miss);
                builder.SetInsertPoint(body);
                llvm::Value* mn = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), mnamesArr, i), "mn");
                builder.CreateCondBr(
                    builder.CreateICmpEQ(builder.CreateCall(strcmpFn(), {stringData(mn), want}),
                                         builder.getInt32(0)),
                    hit, nxt);
                builder.SetInsertPoint(hit);
                builder.CreateStore(mn, builder.CreateStructGEP(methodTokenType(), result, 0));
                builder.CreateStore(
                    builder.CreateLoad(builder.getPtrTy(),
                                       builder.CreateGEP(builder.getPtrTy(), mfnsArr, i)),
                    builder.CreateStructGEP(methodTokenType(), result, 1));
                builder.CreateStore(
                    builder.CreateLoad(builder.getInt64Ty(),
                                       builder.CreateGEP(builder.getInt64Ty(), mRetTagsArr, i)),
                    builder.CreateStructGEP(methodTokenType(), result, 4));
                builder.CreateBr(end);
                builder.SetInsertPoint(nxt);
                builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
                builder.CreateBr(hdr);
                builder.SetInsertPoint(miss);
                emitPanic("reflection: Type.method(name) found no method with that name");
                builder.SetInsertPoint(end);
                return result;
            }
            // Type.instantiate(): allocate an instance and run its no-arg constructor,
            // returning it as Object (spec 31).
            if (mem->member == "instantiate") {
                llvm::Value* size = builder.CreateLoad(
                    builder.getInt64Ty(), builder.CreateStructGEP(typeTokenType(), t, 6), "size");
                llvm::Value* ctorFn = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 7), "ctor");
                // A REGION CLASS IS BUILT WHERE IT BELONGS, EVEN HERE. Every other allocation of an
                // A knows it is building an A and reaches A's arena; this one holds a token and used
                // to reach for `malloc`, which put an instance of a region class outside the only
                // region it is allowed to be in. The token now carries the arena's own `new`, so the
                // choice is the class's rather than this code's.
                llvm::Value* arenaNew = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 15), "arenanew");
                llvm::Value* hasArena =
                    builder.CreateICmpNE(arenaNew, llvm::ConstantPointerNull::get(builder.getPtrTy()));
                auto* arenaBB = llvm::BasicBlock::Create(context, "inst.arena", currentFn);
                auto* heapBB = llvm::BasicBlock::Create(context, "inst.heap", currentFn);
                auto* gotBB = llvm::BasicBlock::Create(context, "inst.got", currentFn);
                builder.CreateCondBr(hasArena, arenaBB, heapBB);
                builder.SetInsertPoint(arenaBB);
                llvm::Value* fromArena = builder.CreateCall(
                    llvm::FunctionType::get(builder.getPtrTy(), {}, false), arenaNew, {}, "inst.rgn");
                builder.CreateBr(gotBB);
                builder.SetInsertPoint(heapBB);
                llvm::Value* fromHeap = builder.CreateCall(mallocFn(), {size}, "inst.malloc");
                builder.CreateBr(gotBB);
                builder.SetInsertPoint(gotBB);
                llvm::PHINode* obj = builder.CreatePHI(builder.getPtrTy(), 2, "inst");
                obj->addIncoming(fromArena, arenaBB);
                obj->addIncoming(fromHeap, heapBB);
                // Forward the call's arguments to the constructor (spec 31), building the
                // function type from the argument values so a ctor with parameters runs.
                std::vector<llvm::Type*> pts = {builder.getPtrTy()};
                std::vector<llvm::Value*> cargs = {obj};
                for (const auto& a : call.args) {
                    llvm::Value* av = emitExpr(*a);
                    if (av == nullptr) {
                        return nullptr;
                    }
                    pts.push_back(av->getType());
                    cargs.push_back(av);
                }
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getVoidTy(), pts, false);
                builder.CreateCall(ft, ctorFn, cargs);
                return obj;
            }
            // Type.methods()/fields()/annotations() (spec 31): build an ArrayList of the member
            // tokens. A Method token is {name, fn}; a Field/Annotation token is {name}.
            if (mem->member == "methods" || mem->member == "fields" ||
                mem->member == "annotations") {
                const bool isMethods = (mem->member == "methods");
                const bool isAnnotations = (mem->member == "annotations");
                const std::string listCls = isMethods      ? "ArrayList$Method"
                                            : isAnnotations ? "ArrayList$Annotation"
                                                            : "ArrayList$Field";
                auto clsIt = classes.find(listCls);
                auto ctorIt = functions.find(listCls + "." + listCls);
                auto addIt = functions.find(listCls + ".add");
                if (clsIt == classes.end() || ctorIt == functions.end() ||
                    addIt == functions.end()) {
                    error("internal: " + listCls + " not available for reflection", mem->loc);
                    return nullptr;
                }
                llvm::StructType* tokTy = isMethods        ? methodTokenType()
                                          : isAnnotations  ? annotationTokenType()
                                                           : fieldTokenType();
                const unsigned countSlot = isMethods ? 1 : isAnnotations ? 8 : 4;
                const unsigned namesSlot = isMethods ? 2 : isAnnotations ? 9 : 5;
                llvm::Value* list =
                    builder.CreateCall(mallocFn(), {sizeOf(clsIt->second.type)}, "list");
                builder.CreateCall(ctorIt->second, {list});
                llvm::Value* count = builder.CreateLoad(
                    builder.getInt64Ty(), builder.CreateStructGEP(typeTokenType(), t, countSlot),
                    "n");
                llvm::Value* names = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, namesSlot),
                    "names");
                const bool isFields = !isMethods && !isAnnotations;
                llvm::Value* fns =
                    isMethods ? builder.CreateLoad(builder.getPtrTy(),
                                                   builder.CreateStructGEP(typeTokenType(), t, 3),
                                                   "fns")
                              : nullptr;
                // Per-method annotation arrays (Type token slots 12, 13), for Method.annotations().
                llvm::Value* mAnnCounts =
                    isMethods ? builder.CreateLoad(builder.getPtrTy(),
                                                   builder.CreateStructGEP(typeTokenType(), t, 12),
                                                   "manncounts")
                              : nullptr;
                llvm::Value* mAnnPtrs =
                    isMethods ? builder.CreateLoad(builder.getPtrTy(),
                                                   builder.CreateStructGEP(typeTokenType(), t, 13),
                                                   "mannptrs")
                              : nullptr;
                llvm::Value* fGet = isFields
                                        ? builder.CreateLoad(
                                              builder.getPtrTy(),
                                              builder.CreateStructGEP(typeTokenType(), t, 10), "fg")
                                        : nullptr;
                llvm::Value* fSet = isFields
                                        ? builder.CreateLoad(
                                              builder.getPtrTy(),
                                              builder.CreateStructGEP(typeTokenType(), t, 11), "fs")
                                        : nullptr;
                llvm::Function* curFn = currentFn;
                llvm::Value* iSlot = createEntryAlloca("li", builder.getInt64Ty());
                builder.CreateStore(builder.getInt64(0), iSlot);
                auto* hdr = llvm::BasicBlock::Create(context, "l.hdr", curFn);
                auto* body = llvm::BasicBlock::Create(context, "l.body", curFn);
                auto* done = llvm::BasicBlock::Create(context, "l.done", curFn);
                builder.CreateBr(hdr);
                builder.SetInsertPoint(hdr);
                llvm::Value* i = builder.CreateLoad(builder.getInt64Ty(), iSlot, "i");
                builder.CreateCondBr(builder.CreateICmpSLT(i, count), body, done);
                builder.SetInsertPoint(body);
                llvm::Value* nm = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), names, i), "nm");
                llvm::Value* tok = builder.CreateCall(mallocFn(), {sizeOf(tokTy)}, "tok");
                builder.CreateStore(nm, builder.CreateStructGEP(tokTy, tok, 0));
                if (isAnnotations) {
                    // The arguments as written (Type token slot 17), so `[Range(min: 1)]` and
                    // `[Range(min: 99)]` are not the same annotation to a reader.
                    llvm::Value* aArgs = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 17), "aargs");
                    builder.CreateStore(
                        builder.CreateLoad(builder.getPtrTy(),
                                           builder.CreateGEP(builder.getPtrTy(), aArgs, i), "aa"),
                        builder.CreateStructGEP(tokTy, tok, 1));
                }
                if (isMethods) {
                    llvm::Value* fn = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), fns, i), "fn");
                    builder.CreateStore(fn, builder.CreateStructGEP(tokTy, tok, 1));
                    // Method token slots 2 (annotation count), 3 (annotation String[]).
                    builder.CreateStore(
                        builder.CreateLoad(builder.getInt64Ty(),
                                           builder.CreateGEP(builder.getInt64Ty(), mAnnCounts, i),
                                           "mac"),
                        builder.CreateStructGEP(tokTy, tok, 2));
                    builder.CreateStore(
                        builder.CreateLoad(builder.getPtrTy(),
                                           builder.CreateGEP(builder.getPtrTy(), mAnnPtrs, i), "map"),
                        builder.CreateStructGEP(tokTy, tok, 3));
                    // ...and their arguments (Type token slot 21 -> Method token slot 5).
                    llvm::Value* mAnnArgs = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 21), "maa");
                    builder.CreateStore(
                        builder.CreateLoad(builder.getPtrTy(),
                                           builder.CreateGEP(builder.getPtrTy(), mAnnArgs, i), "maa1"),
                        builder.CreateStructGEP(tokTy, tok, 5));
                } else if (isFields) {  // the field's get/set accessors (Field token slots 1, 2)
                    builder.CreateStore(
                        builder.CreateLoad(builder.getPtrTy(),
                                           builder.CreateGEP(builder.getPtrTy(), fGet, i), "g"),
                        builder.CreateStructGEP(tokTy, tok, 1));
                    builder.CreateStore(
                        builder.CreateLoad(builder.getPtrTy(),
                                           builder.CreateGEP(builder.getPtrTy(), fSet, i), "s"),
                        builder.CreateStructGEP(tokTy, tok, 2));
                    // And the declared type's NAME (Field token slot 3), from the parallel array the
                    // Type token now carries -- what tells an int from a String from a nested object.
                    llvm::Value* fTypes = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 16), "ftn");
                    builder.CreateStore(
                        builder.CreateLoad(builder.getPtrTy(),
                                           builder.CreateGEP(builder.getPtrTy(), fTypes, i), "ft"),
                        builder.CreateStructGEP(tokTy, tok, 3));
                    // And the field's OWN annotations (Type token slots 18/19/20 -> Field slots
                    // 4/5/6): count, names and arguments. A rule about a field is written on the
                    // field, so a walk that cannot read them can only ever be a walk over types.
                    for (unsigned k = 0; k < 3; ++k) {
                        llvm::Type* elemTy = k == 0 ? (llvm::Type*)builder.getInt64Ty()
                                                    : (llvm::Type*)builder.getPtrTy();
                        llvm::Value* arr = builder.CreateLoad(
                            builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 18 + k),
                            "fann");
                        builder.CreateStore(
                            builder.CreateLoad(elemTy, builder.CreateGEP(elemTy, arr, i), "fa"),
                            builder.CreateStructGEP(tokTy, tok, 4 + k));
                    }
                }
                builder.CreateCall(addIt->second, {list, tok});
                builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
                builder.CreateBr(hdr);
                builder.SetInsertPoint(done);
                return list;
            }
        }
        // Field.annotations() (spec 31): the annotations written ON the field, which is where a
        // declarative rule about a field goes -- `[NotEmpty] String name;`. Same three arrays as a
        // method's, read from Field token slots 4/5/6.
        if (typeName(*mem->object) == "Field" && mem->member == "annotations") {
            llvm::Value* f = emitExpr(*mem->object);
            if (f == nullptr) {
                return nullptr;
            }
            llvm::Value* count = builder.CreateLoad(
                builder.getInt64Ty(), builder.CreateStructGEP(fieldTokenType(), f, 4), "fannc");
            llvm::Value* names = builder.CreateLoad(
                builder.getPtrTy(), builder.CreateStructGEP(fieldTokenType(), f, 5), "fannn");
            llvm::Value* args = builder.CreateLoad(
                builder.getPtrTy(), builder.CreateStructGEP(fieldTokenType(), f, 6), "fanna");
            return emitAnnotationList(count, names, args, mem->loc);
        }
        // Field reflection (spec 31): name() reads the field token's name.
        if (typeName(*mem->object) == "Field" &&
            (mem->member == "name" || mem->member == "typeName")) {
            llvm::Value* f = emitExpr(*mem->object);
            if (f == nullptr) {
                return nullptr;
            }
            const unsigned slot = mem->member == "name" ? 0 : 3;
            return builder.CreateLoad(builder.getPtrTy(),
                                      builder.CreateStructGEP(fieldTokenType(), f, slot), "f.name");
        }
        // Field.get(obj) / set(obj, value) (spec 31): call the field's boxing accessor stored in the
        // token. get returns the boxed field as an Object; set takes an Object (boxed primitive or
        // reference) and writes it back.
        if (typeName(*mem->object) == "Field" &&
            (mem->member == "get" || mem->member == "set")) {
            llvm::Value* f = emitExpr(*mem->object);
            if (f == nullptr) {
                return nullptr;
            }
            llvm::Value* obj = emitExpr(*call.args[0]);
            if (obj == nullptr) {
                return nullptr;
            }
            if (mem->member == "get") {
                llvm::Value* getFn = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(fieldTokenType(), f, 1), "f.get");
                llvm::FunctionType* gt =
                    llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
                return builder.CreateCall(gt, getFn, {obj});
            }
            llvm::Value* v = coerce(emitExpr(*call.args[1]), typeName(*call.args[1]), "Object");
            if (v == nullptr) {
                return nullptr;
            }
            llvm::Value* setFn = builder.CreateLoad(
                builder.getPtrTy(), builder.CreateStructGEP(fieldTokenType(), f, 2), "f.set");
            llvm::FunctionType* st = llvm::FunctionType::get(
                builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
            builder.CreateCall(st, setFn, {obj, v});
            return nullptr;
        }
        // Annotation reflection (spec 14.3, 31): name() reads the annotation token's name.
        if (typeName(*mem->object) == "Annotation" &&
            (mem->member == "name" || mem->member == "args")) {
            llvm::Value* a = emitExpr(*mem->object);
            if (a == nullptr) {
                return nullptr;
            }
            // `args` is the argument list as written -- `min=1,max=10` -- parsed by whoever reads it.
            const unsigned slot = mem->member == "name" ? 0 : 1;
            return builder.CreateLoad(
                builder.getPtrTy(), builder.CreateStructGEP(annotationTokenType(), a, slot),
                "a.name");
        }
        // Method reflection (spec 31): name() and invoke(receiver) for no-arg methods.
        if (typeName(*mem->object) == "Method") {
            llvm::Value* m = emitExpr(*mem->object);
            if (m == nullptr) {
                return nullptr;
            }
            if (mem->member == "name") {
                return builder.CreateLoad(builder.getPtrTy(),
                                          builder.CreateStructGEP(methodTokenType(), m, 0), "m.name");
            }
            // annotations(): the method's own applied annotations (spec 31), from token slots 2/3/5.
            if (mem->member == "annotations") {
                llvm::Value* count = builder.CreateLoad(
                    builder.getInt64Ty(), builder.CreateStructGEP(methodTokenType(), m, 2), "annc");
                llvm::Value* names = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(methodTokenType(), m, 3), "annn");
                llvm::Value* args = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(methodTokenType(), m, 5), "anna");
                return emitAnnotationList(count, names, args, mem->loc);
            }
            // firstByte(): the first machine-code byte of the method (0xCC = 204 after a
            // physical unimport), so the code overwrite is observable.
            if (mem->member == "firstByte") {
                llvm::Value* fnPtr = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(methodTokenType(), m, 1), "m.fn");
                return builder.CreateZExt(builder.CreateLoad(builder.getInt8Ty(), fnPtr, "byte"),
                                          builder.getInt32Ty());
            }
            if (mem->member == "invoke") {
                llvm::Value* fnPtr = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(methodTokenType(), m, 1), "m.fn");
                llvm::Value* tag = builder.CreateLoad(
                    builder.getInt64Ty(), builder.CreateStructGEP(methodTokenType(), m, 4), "m.tag");
                llvm::Value* recv = emitExpr(*call.args[0]);  // first arg is the receiver
                if (recv == nullptr) {
                    return nullptr;
                }
                // Forward the remaining arguments to the method (spec 31).
                std::vector<llvm::Type*> pts = {builder.getPtrTy()};
                std::vector<llvm::Value*> cargs = {recv};
                for (std::size_t i = 1; i < call.args.size(); ++i) {
                    llvm::Value* av = emitExpr(*call.args[i]);
                    if (av == nullptr) {
                        return nullptr;
                    }
                    pts.push_back(av->getType());
                    cargs.push_back(av);
                }
                // The result type is carried as a tag (Method token field 4). Switch on it so the
                // call uses the right ABI, then box the result to Object (a pointer return, or void,
                // passes through as-is / null). See returnTag/tagRetType/tagBoxType.
                llvm::Value* nullObj = llvm::ConstantPointerNull::get(builder.getPtrTy());
                llvm::Function* fn = currentFn;
                auto* defBB = llvm::BasicBlock::Create(context, "invoke.def", fn);
                auto* contBB = llvm::BasicBlock::Create(context, "invoke.cont", fn);
                llvm::SwitchInst* sw = builder.CreateSwitch(tag, defBB, 8);
                std::vector<std::pair<llvm::BasicBlock*, llvm::Value*>> incoming;
                for (long long tg = 0; tg <= 7; ++tg) {
                    auto* caseBB =
                        llvm::BasicBlock::Create(context, "invoke.t" + std::to_string(tg), fn);
                    sw->addCase(builder.getInt64(tg), caseBB);
                    builder.SetInsertPoint(caseBB);
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(tagRetType(tg), pts, false);
                    llvm::Value* res;
                    if (tg == 0) {  // void
                        builder.CreateCall(ft, fnPtr, cargs);
                        res = nullObj;
                    } else if (tg == 5) {  // a reference: already an Object pointer
                        res = builder.CreateCall(ft, fnPtr, cargs);
                    } else {  // a primitive: box it
                        res = emitBox(builder.CreateCall(ft, fnPtr, cargs), tagBoxType(tg));
                    }
                    incoming.emplace_back(builder.GetInsertBlock(), res);
                    builder.CreateBr(contBB);
                }
                builder.SetInsertPoint(defBB);
                builder.CreateBr(contBB);
                incoming.emplace_back(defBB, nullObj);
                builder.SetInsertPoint(contBB);
                llvm::PHINode* phi = builder.CreatePHI(builder.getPtrTy(), incoming.size(), "invoke.r");
                for (auto& [bb, v] : incoming) {
                    phi->addIncoming(v, bb);
                }
                return phi;
            }
        }
        // Enum built-ins (spec 12.5): EnumName.count() / EnumName.values().
        if (const auto* eid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            auto eit = enums.find(eid->name);
            if (eit != enums.end()) {
                const int n = static_cast<int>(eit->second.size());
                if (mem->member == "count") {
                    return builder.getInt32(n);
                }
                if (mem->member == "random" && n > 0) {  // a random ordinal in [0, n)
                    llvm::FunctionType* rt = llvm::FunctionType::get(builder.getInt32Ty(), false);
                    llvm::Value* r =
                        builder.CreateCall(module.getOrInsertFunction("rand", rt), {}, "rand");
                    llvm::Value* ord = builder.CreateSRem(r, builder.getInt32(n), "enum.random");
                    auto jit = javaEnums.find(eid->name);
                    if (jit == javaEnums.end()) {
                        return ord;  // int-style: the ordinal IS the value
                    }
                    // java-style: return the singleton at the chosen ordinal (a ptr), not the int.
                    llvm::Value* sel = llvm::ConstantPointerNull::get(builder.getPtrTy());
                    for (int i = 0; i < n; ++i) {
                        sel = builder.CreateSelect(
                            builder.CreateICmpEQ(ord, builder.getInt32(i)),
                            emitEnumConstant(*jit->second, eit->second[i]), sel);
                    }
                    return sel;
                }
                if (mem->member == "values") {
                    auto jit = javaEnums.find(eid->name);
                    if (jit != javaEnums.end()) {  // java-style: array of singleton ptrs (8-byte stride)
                        llvm::Value* total = builder.getInt64(kArrayHeaderBytes + static_cast<long long>(n) * 8);
                        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "enum.vals");
                        builder.CreateStore(builder.getInt64(n), block);  // length header
                        for (int i = 0; i < n; ++i) {
                            builder.CreateStore(
                                emitEnumConstant(*jit->second, eit->second[i]),
                                arrayElemPtr(block, builder.getInt32(i), builder.getPtrTy()));
                        }
                        return block;
                    }
                    // int-style: build an int[] of ordinals [0 .. n-1].
                    llvm::Value* total = builder.getInt64(kArrayHeaderBytes + static_cast<long long>(n) * 4);
                    llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "enum.vals");
                    builder.CreateStore(builder.getInt64(n), block);  // length header
                    for (int i = 0; i < n; ++i) {
                        builder.CreateStore(
                            builder.getInt32(i),
                            arrayElemPtr(block, builder.getInt32(i), builder.getInt32Ty()));
                    }
                    return block;
                }
                // EnumName.parse(s) -> Option<Enum> (spec 12.5): match s against each constant
                // name; Some(ordinal) on a hit, None otherwise.
                if (mem->member == "parse" && call.args.size() == 1) {
                    llvm::Value* s = emitExpr(*call.args[0]);
                    if (s == nullptr) {
                        return nullptr;
                    }
                    llvm::Value* sData = stringData(s);
                    // parse() yields the value Option<Enum> (a { tag, ordinal } struct), so the slot
                    // holds that value, not a boxed pointer.
                    llvm::Value* slot = createEntryAlloca("parse.opt", variantStructType());
                    llvm::Function* pf = currentFn;
                    llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "parse.done", pf);
                    // A Java-style enum is a reference type: its Option<Enum> payload must be the
                    // singleton pointer, not the ordinal, so `case Some(Planet p)` binds a usable
                    // reference. An int-style enum IS its ordinal, so the ordinal is the payload.
                    auto pJit = javaEnums.find(eid->name);
                    for (int i = 0; i < n; ++i) {
                        llvm::Value* nm = stringData(emitStringObject(eit->second[i]));
                        llvm::Value* cmp = builder.CreateCall(strcmpFn(), {sData, nm}, "parse.cmp");
                        llvm::Value* eq = builder.CreateICmpEQ(cmp, builder.getInt32(0));
                        auto* mb = llvm::BasicBlock::Create(context, "parse.some", pf);
                        auto* nb = llvm::BasicBlock::Create(context, "parse.next", pf);
                        builder.CreateCondBr(eq, mb, nb);
                        builder.SetInsertPoint(mb);
                        if (pJit != javaEnums.end()) {
                            llvm::Value* agg = llvm::UndefValue::get(variantStructType());
                            agg = builder.CreateInsertValue(agg, builder.getInt32(0), {0u}, "some.tag");
                            agg = builder.CreateInsertValue(
                                agg, variantEncode(emitEnumConstant(*pJit->second, eit->second[i])),
                                {1u}, "some.singleton");
                            builder.CreateStore(agg, slot);
                        } else {
                            builder.CreateStore(emitOptionVariant("Some", eid->name, i), slot);
                        }
                        builder.CreateBr(doneBB);
                        builder.SetInsertPoint(nb);
                    }
                    builder.CreateStore(emitOptionVariant("None", eid->name, -1), slot);
                    builder.CreateBr(doneBB);
                    builder.SetInsertPoint(doneBB);
                    return builder.CreateLoad(variantStructType(), slot, "parse.result");
                }
                // A STATIC method the enum declares itself. The function is already emitted with
                // no receiver parameter (see the declaration loop: `if (!m->isStatic)` is what
                // adds the ordinal `this`), so the only thing that was ever missing is this call
                // site -- which is why declaring one used to compile and calling it did not.
                //
                // Guarded on the declaration actually being static: an INSTANCE method shares the
                // same mangled name, and calling it on the type would pass the first argument
                // where the ordinal belongs.
                if (auto edit = enumMethodDecls.find(eid->name); edit != enumMethodDecls.end()) {
                    for (const ast::MemberPtr& member : edit->second->members) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m == nullptr || m->name != mem->member || !m->isStatic) {
                            continue;
                        }
                        auto sf = functions.find(eid->name + "." + mem->member);
                        if (sf == functions.end()) {
                            break;
                        }
                        std::vector<llvm::Value*> args;
                        for (std::size_t i = 0; i < call.args.size(); ++i) {
                            llvm::Value* a = emitExpr(*call.args[i]);
                            if (a == nullptr) {
                                return nullptr;
                            }
                            if (i < sf->second->arg_size()) {
                                a = coerceToType(
                                    a, sf->second->getArg(static_cast<unsigned>(i))->getType());
                            }
                            args.push_back(a);
                        }
                        return emitMaybeInvoke(sf->second, args);
                    }
                }
            }
        }
        // Static call: the receiver names a class, not a local/this.
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            // Through the funnel, like every other class reference: `Paths.join(...)` names whichever
            // Paths this namespace means, and its symbol carries that class's key.
            const std::string statKey = clsKey(objId->name);
            if (objId->name != "this" && locals.find(objId->name) == locals.end() &&
                classes.count(statKey) > 0) {
                auto fnit = functions.find(statKey + "." + mem->member);
                if (fnit == functions.end()) {
                    // Qualified literal suffix: Type.kib(64) (spec 17.10).
                    if (literalSuffixParams.count(mem->member) > 0 && call.args.size() == 1) {
                        const std::string key =
                            chooseLiteralKey(mem->member, typeName(*call.args[0]));
                        if (auto lf = functions.find(key); lf != functions.end()) {
                            llvm::Value* v = emitExpr(*call.args[0]);
                            if (v == nullptr) {
                                return nullptr;
                            }
                            v = coerceToType(v, lf->second->getArg(0)->getType());
                            return emitMaybeInvoke(lf->second, {v});
                        }
                    }
                    error("unknown static method '" + mem->member + "'", call.loc);
                    return nullptr;
                }
                const bool isExternCall =
                    externReturnType.count(statKey + "." + mem->member) > 0;
                std::vector<llvm::Value*> args;
                std::vector<SpillToken> atk(call.args.size());
                for (std::size_t i = 0; i < call.args.size(); ++i) {
                    if (isExternCall) {
                        // A lambda argument to a C function is a callback: pass a raw C fn ptr.
                        if (const auto* lam =
                                dynamic_cast<const ast::LambdaExpr*>(call.args[i].get())) {
                            llvm::Function* cb = emitCallbackFn(*lam);
                            if (cb == nullptr) {
                                return nullptr;
                            }
                            args.push_back(cb);
                            continue;
                        }
                        // A by-value struct travels in a register: load its bytes as the ABI int.
                        if (llvm::Type* reg = ffiStructRegType(typeName(*call.args[i]))) {
                            llvm::Value* ptr = emitExpr(*call.args[i]);
                            if (ptr == nullptr) {
                                return nullptr;
                            }
                            args.push_back(builder.CreateLoad(reg, ptr, "ffi.byval"));
                            continue;
                        }
                        // A String maps to a C char*: pass the NUL-terminated data pointer, not the
                        // {len,data} object (spec 26).
                        if (const std::string at = typeName(*call.args[i]);
                            at == "String" || at == "string") {
                            llvm::Value* sv = emitExpr(*call.args[i]);
                            if (sv == nullptr) {
                                return nullptr;
                            }
                            args.push_back(stringData(sv));
                            continue;
                        }
                    }
                    llvm::Value* v = emitExpr(*call.args[i]);
                    if (v == nullptr) {
                        return nullptr;
                    }
                    // static: no implicit `this`
                    v = coerceArg(v, typeName(*call.args[i]), fnit->second, i);
                    args.push_back(v);
                    if (asyncSM && laterArgAwaits(call.args, i)) {
                        atk[i] = spillAcrossAwait(v);
                    }
                }
                for (std::size_t i = call.args.size(); i-- > 0;) {
                    if (atk[i].active) {
                        args[i] = reloadSpill(atk[i], args[i]);
                    }
                }
                llvm::Value* r = emitMaybeInvoke(fnit->second, args);
                // A by-value struct return arrives in a register: store it into a fresh object.
                if (isExternCall) {
                    const std::string rt = externReturnType[objId->name + "." + mem->member];
                    if (ffiStructRegType(rt) != nullptr) {
                        auto cit = classes.find(clsKey(rt));
                        llvm::Value* obj = builder.CreateCall(
                            mallocFn(), {sizeOf(cit->second.type)}, "ffi.ret");
                        builder.CreateStore(r, obj);
                        return obj;
                    }
                }
                return r;
            }
        }
        // Enum/catalog instance method dispatch (spec 12.4). A direct enum receiver is an i32
        // ordinal dispatched statically. A catalog-typed receiver is the tagged i64 value: unpack
        // its ordinal (low 32) and enum type id (high 32) and dispatch to the implementing enum --
        // directly for one implementer, or via a switch on the type id for several.
        {
            const std::string est = baseType(typeName(*mem->object));
            if (enums.count(est) > 0) {
                auto fnit = functions.find(est + "." + mem->member);
                if (fnit != functions.end()) {
                    llvm::Value* recv = emitExpr(*mem->object);  // the ordinal (i32)
                    if (recv == nullptr) {
                        return nullptr;
                    }
                    std::vector<llvm::Value*> args;
                    args.push_back(recv);
                    for (std::size_t i = 0; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) {
                            return nullptr;
                        }
                        v = coerceArg(v, typeName(*call.args[i]), fnit->second, i + 1);
                        args.push_back(v);
                    }
                    return emitMaybeInvoke(fnit->second, args);
                }
                // Enum value built-in (spec 12.5): v.name() -- the declared identifier back
                // as a String, the fourth of the generated quartet (parse reads the names in;
                // name reads them out). The names are private String GLOBALS, so the select
                // chain allocates nothing. A java-style receiver is its singleton pointer;
                // identity recovers its ordinal first. A `name` method the enum declares
                // itself was found in `functions` above and won.
                if (mem->member == "name" && call.args.empty()) {
                    llvm::Value* recv = emitExpr(*mem->object);
                    if (recv == nullptr) {
                        return nullptr;
                    }
                    llvm::Value* ord = recv;
                    if (javaEnums.count(est) > 0) {
                        ord = emitJavaEnumOrdinal(recv, est);
                    }
                    const std::vector<std::string>& consts = enums[est];
                    llvm::Value* result = emitStringObject("");
                    for (std::size_t i = 0; i < consts.size(); ++i) {
                        llvm::Value* eq =
                            builder.CreateICmpEQ(ord, builder.getInt32(static_cast<int>(i)));
                        result = builder.CreateSelect(eq, emitStringObject(consts[i]), result,
                                                      "enum.name");
                    }
                    return result;
                }
            } else if (isTaggedCatalog(est)) {
                std::vector<std::string> impls;
                for (const std::string& e : catalogImplEnums(est)) {
                    if (functions.count(e + "." + mem->member) > 0) {
                        impls.push_back(e);
                    }
                }
                if (!impls.empty()) {
                    llvm::Value* tag = emitExpr(*mem->object);  // i64: enumId<<32 | ordinal
                    if (tag == nullptr) {
                        return nullptr;
                    }
                    llvm::Value* ord = builder.CreateTrunc(tag, builder.getInt32Ty(), "cat.ord");
                    std::vector<llvm::Value*> argVals;
                    for (std::size_t i = 0; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) {
                            return nullptr;
                        }
                        argVals.push_back(v);
                    }
                    auto callImpl = [&](const std::string& e) -> llvm::Value* {
                        auto fnit = functions.find(e + "." + mem->member);
                        std::vector<llvm::Value*> args;
                        // An ordinal implementer's method takes the ordinal as `this`; a
                        // java-style implementer's method lives on the twin class and takes
                        // the constant's singleton, recovered from the same ordinal.
                        if (javaEnums.count(e) > 0) {
                            args.push_back(emitJavaEnumFromOrdinal(e, ord));
                        } else {
                            args.push_back(ord);
                        }
                        for (std::size_t i = 0; i < argVals.size(); ++i) {
                            llvm::Value* v = argVals[i];
                            v = coerceArg(v, i < call.args.size() ? typeName(*call.args[i]) : "",
                                          fnit->second, i + 1);
                            args.push_back(v);
                        }
                        return builder.CreateCall(fnit->second, args);
                    };
                    if (impls.size() == 1) {
                        return callImpl(impls[0]);
                    }
                    llvm::Value* enumId = builder.CreateTrunc(
                        builder.CreateLShr(tag, builder.getInt64(32)), builder.getInt32Ty(), "cat.id");
                    llvm::Function* fn = currentFn;
                    llvm::Type* rt = functions[impls[0] + "." + mem->member]->getReturnType();
                    const bool isVoid = rt->isVoidTy();
                    llvm::Value* resSlot = isVoid ? nullptr : createEntryAlloca("cat.res", rt);
                    if (!isVoid) {
                        builder.CreateStore(llvm::Constant::getNullValue(rt), resSlot);
                    }
                    auto* contBB = llvm::BasicBlock::Create(context, "cat.cont", fn);
                    auto* defBB = llvm::BasicBlock::Create(context, "cat.default", fn);
                    llvm::SwitchInst* sw =
                        builder.CreateSwitch(enumId, defBB, static_cast<unsigned>(impls.size()));
                    for (const std::string& e : impls) {
                        auto* caseBB = llvm::BasicBlock::Create(context, "cat." + e, fn);
                        sw->addCase(builder.getInt32(enumTypeId[e]), caseBB);
                        builder.SetInsertPoint(caseBB);
                        llvm::Value* r = callImpl(e);
                        if (!isVoid) {
                            builder.CreateStore(r, resSlot);
                        }
                        builder.CreateBr(contBB);
                    }
                    builder.SetInsertPoint(defBB);
                    builder.CreateBr(contBB);  // a packed value always matches an arm
                    builder.SetInsertPoint(contBB);
                    if (isVoid) {
                        return nullptr;
                    }
                    return builder.CreateLoad(rt, resSlot, "cat.result");
                }
            }
        }
        // spec 30: calling a method on an unimported type throws (rather than branching
        // into the int3-overwritten code).
        emitAliveGuard(baseType(typeName(*mem->object)));
        // Virtual dispatch: if the static type is polymorphic and the method has a vtable slot, call
        // indirectly through the object's vtable. Devirtualize when the static type is a concrete
        // class that nothing extends/implements (not in `subclassed_`): its instances are exactly
        // that type, so the call is direct and inlinable -- a plain-class method call then costs
        // nothing over a free function (e.g. Bitset.set in a tight sieve loop).
        // THROUGH THE FUNNEL, not through `baseType`. A generic instantiated over a POINTER is named
        // `Box$Node*`, and that trailing `*` is part of the CLASS NAME rather than a pointer to it --
        // so stripping it, which is right for `Dog*`, produced `Box$Node`, which is no class at all.
        // The virtual dispatch below was then skipped and the call fell through to the direct path,
        // where an abstract method has no body: `unknown method 'full' on 'Box$Node*'`, reported
        // against a base method that merely calls its own abstract one.
        //
        // `clsKey` is the lookup that tries the exact name first and only then sees through `T*`,
        // which is the same fix already applied to the sixteen other `classes.find` sites.
        const std::string st = clsKey(typeName(*mem->object));
        auto stit = classes.find(st);
        // Keep the virtual call whenever the runtime type may differ from the static type: the type
        // is extended/implemented (`subclassed_`), is an interface or abstract class (the value is
        // always some concrete subtype -- including via generic variance, e.g. Producer<out T>), or
        // is imported from a dynamically-loaded bundle (the plugin supplies the body). Only a
        // concrete, un-subclassed, local class has instances of exactly its own type -> devirtualize.
        const bool mayBeSubtype = stit != classes.end() &&
                                  (subclassed_.count(st) > 0 || stit->second.isInterface ||
                                   stit->second.isAbstract || stit->second.imported);
        if (stit != classes.end() && stit->second.hasVtable && mayBeSubtype) {
            const int slot = slotIndex(st, mem->member);
            const ast::MethodDecl* mdecl = findMethodDecl(st, mem->member);
            if (slot >= 0 && mdecl != nullptr) {
                llvm::Value* recv = emitObjectPtr(*mem->object);
                if (recv == nullptr) {
                    return nullptr;
                }
                llvm::Value* vtblField =
                    builder.CreateStructGEP(stit->second.type, recv, 0, "vtbl.addr");
                llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
                llvm::Type* vtArrTy =
                    llvm::ArrayType::get(builder.getPtrTy(), stit->second.vtslots.size());
                llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                    vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "slot");
                llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "fn");
                llvm::FunctionType* fty = methodFnType(mdecl);
                std::vector<llvm::Value*> vargs;
                vargs.push_back(recv);
                SpillToken recvTk;
                if (asyncSM && anyArgAwaits(call.args)) {
                    recvTk = spillAcrossAwait(recv);
                }
                std::vector<SpillToken> atk(call.args.size());
                std::vector<std::pair<std::size_t, std::string>> freeAfter;  // owned `new` args
                for (std::size_t i = 0; i < call.args.size(); ++i) {
                    llvm::Value* v = emitExpr(*call.args[i]);
                    if (v == nullptr) {
                        return nullptr;
                    }
                    if (i + 1 < fty->getNumParams()) {
                        v = coerceToType(v, fty->getParamType(i + 1));
                    }
                    vargs.push_back(v);
                    if (i < mdecl->params.size()) {
                        if (std::string cn =
                                ownedHeapNewArg(*call.args[i], typeRefName(mdecl->params[i].type));
                            !cn.empty()) {
                            freeAfter.emplace_back(i + 1, cn);
                        }
                    }
                    if (asyncSM && laterArgAwaits(call.args, i)) {
                        atk[i] = spillAcrossAwait(v);
                    }
                }
                for (std::size_t i = call.args.size(); i-- > 0;) {
                    if (atk[i].active) {
                        vargs[1 + i] = reloadSpill(atk[i], vargs[1 + i]);
                    }
                }
                if (recvTk.active) {
                    vargs[0] = reloadSpill(recvTk, vargs[0]);
                }
                // A value-struct return through the vtable is sret too: pass the result slot.
                if (const std::string vrt = typeRefName(mdecl->returnType);
                    returnsValueStruct(vrt)) {
                    llvm::Value* slot = createEntryAlloca("sret", classes[baseType(vrt)].type);
                    vargs.push_back(slot);
                    emitMaybeInvoke(fty, fnPtr, vargs);
                    for (const auto& [idx, cn] : freeAfter) {
                        emitDeleteObject(vargs[idx], cn);
                    }
                    return slot;
                }
                // Try the guarded direct calls first; emitSpeculatedCall returns null when the
                // program has too many implementations for it to be worth the compares.
                llvm::Value* res = emitSpeculatedCall(fnPtr, fty, mem->member, vargs);
                if (res == nullptr) {
                    res = emitMaybeInvoke(fty, fnPtr, vargs);
                }
                for (const auto& [idx, cn] : freeAfter) {
                    emitDeleteObject(vargs[idx], cn);
                }
                return res;
            }
        }

        // Direct call: obj.method(this, args...). The implementation is on the
        // class that defines the method (which may be a superclass).
        llvm::Value* objPtr = emitObjectPtr(*mem->object);
        if (objPtr == nullptr) {
            return nullptr;
        }
        const std::string owner = methodOwner(typeName(*mem->object), mem->member);
        auto fnit = functions.find(owner + "." + mem->member);
        // IDENTITY IS A PROPERTY OF AN OBJECT, NOT OF ITS ROOT CLASS.
        //
        // `Object.equalsKey` is `this == other` and `hashCode` is nothing -- but a FREESTANDING
        // program has no Object at all (assignObjectRoot skips it: a kernel has no managed runtime),
        // so every class there lacked both, and the standard library's collections call `equalsKey`
        // on their element type. The result was that `ArrayList<SomeClass>` did not compile bare
        // metal, reported from inside the library at `this.data[i].equalsKey(item)` -- a line the
        // author of the list never saw.
        //
        // Answered here rather than by giving freestanding an Object: the answer needs no runtime,
        // no vtable and no allocation. It is a pointer comparison, which is what the hosted one
        // compiles to anyway.
        if ((owner.empty() || fnit == functions.end()) &&
            (mem->member == "equalsKey" || mem->member == "hash") &&
            classes.count(clsKey(baseType(typeName(*mem->object)))) > 0) {
            llvm::Value* a = emitObjectPtr(*mem->object);
            if (a == nullptr) {
                return nullptr;
            }
            if (mem->member == "hash") {
                return builder.CreatePtrToInt(a, builder.getInt64Ty());
            }
            llvm::Value* b = emitExpr(*call.args[0]);
            if (b == nullptr) {
                return nullptr;
            }
            return builder.CreateZExt(builder.CreateICmpEQ(a, b), builder.getInt32Ty());
        }
        if (owner.empty() || fnit == functions.end()) {
            // NAME THE RECEIVER, and by the key it resolved to. "unknown method 'one'" is true of
            // every class that does not have `one`, which is the wrong half of the fact: what a
            // reader needs is WHICH class the compiler decided the receiver was, because when two
            // types share a name that decision is the bug and the missing method is only its shadow.
            const std::string recv = typeName(*mem->object);
            error("unknown method '" + mem->member + "' on '" + clsKey(recv) + "'" +
                      (owner.empty() ? "" : " (found on '" + owner + "', which has no body here)"),
                  call.loc);
            return nullptr;
        }
        // TARGET FEATURE GATES, AT THE PROGRAM'S OWN CALL and not inside the prelude.
        //
        // The first version of this checked where `Thread.start()` reaches the runtime -- which is a
        // line in the prelude, emitted for every program whether or not it uses threads. So a wasm
        // module that never mentioned a thread was refused, and the caret pointed at a file the
        // author never opened. A check that refuses something correct is worse than no check: it is
        // the same failure the `asm` architecture check was written to avoid.
        //
        // Here the receiver's class and the caller are both known, so the refusal lands on the line
        // that asked for the feature, and the prelude compiling its own `Thread` costs nothing.
        if (preludeClasses.count(enclosingClass_) == 0 && owner == "Thread" && mem->member == "start" &&
            !requireTargetFeature("threads", "`Thread.start()`", call.loc)) {
            return nullptr;
        }
        const ast::MethodDecl* mdecl = findMethodDecl(owner, mem->member);
        std::vector<llvm::Value*> args;
        args.push_back(objPtr);
        SpillToken recvTk;
        if (asyncSM && anyArgAwaits(call.args)) {
            recvTk = spillAcrossAwait(objPtr);
        }
        std::vector<SpillToken> atk(call.args.size());
        std::vector<std::pair<std::size_t, std::string>> freeAfter;  // owned `new` args to destruct
        for (std::size_t i = 0; i < call.args.size(); ++i) {
            llvm::Value* v = emitExpr(*call.args[i]);
            if (v == nullptr) {
                return nullptr;
            }
            v = coerceArg(v, typeName(*call.args[i]), fnit->second, i + 1);
            args.push_back(v);
            if (mdecl != nullptr && i < mdecl->params.size()) {
                if (std::string cn = ownedHeapNewArg(*call.args[i], typeRefName(mdecl->params[i].type));
                    !cn.empty()) {
                    freeAfter.emplace_back(i + 1, cn);
                }
            }
            if (asyncSM && laterArgAwaits(call.args, i)) {
                atk[i] = spillAcrossAwait(v);
            }
        }
        for (std::size_t i = call.args.size(); i-- > 0;) {
            if (atk[i].active) {
                args[1 + i] = reloadSpill(atk[i], args[1 + i]);
            }
        }
        if (recvTk.active) {
            args[0] = reloadSpill(recvTk, args[0]);
        }
        // Function specialization: if a function<> parameter was given a known lambda (a no-capture
        // constant, or a bound param forwarded here), call a specialized copy whose calls to it are
        // direct so LLVM inlines the lambda -- what makes sortedBy/filter/map/reduce competitive.
        llvm::Function* callee = fnit->second;
        if (mdecl != nullptr) {
            std::map<int, llvm::Function*> specParams;
            for (std::size_t i = 0; i < call.args.size() && i < mdecl->params.size(); ++i) {
                if (typeRefName(mdecl->params[i].type).rfind("function<", 0) == 0) {
                    if (llvm::Function* lam = knownLambdaFor(*call.args[i], args[i + 1])) {
                        specParams[static_cast<int>(i)] = lam;
                    }
                }
            }
            if (!specParams.empty()) {
                callee = specializeMethod(mdecl, owner, mem->member, fnit->second, specParams);
            }
        }
        llvm::Value* res = emitMaybeInvoke(callee, args);
        for (const auto& [idx, cn] : freeAfter) {
            emitDeleteObject(args[idx], cn);
        }
        return res;
    }
    // Unqualified same-class call: Polaron has no free functions, and locals/lambdas were resolved above,
    // so a bare `name(...)` here names a method of the enclosing class written without its receiver.
    // The this./ClassName. qualifier is optional -- synthesize the receiver (`this` for an instance
    // method, the owning class for a static one) and re-emit through the normal member-call path, so
    // virtual dispatch, argument coercion and async spilling all still apply. (The analyzer has already
    // rejected the instance-from-static case, so a reachable call here always has a valid receiver.)
    if (!name.empty() && name.find('.') == std::string::npos && !enclosingClass_.empty()) {
        const std::string owner = methodOwner(enclosingClass_, name);
        if (!owner.empty() && functions.count(owner + "." + name) > 0) {
            const ast::MethodDecl* md = findMethodDecl(owner, name);
            const bool isStatic = md != nullptr && md->isStatic;
            if (isStatic || currentThis != nullptr) {
                auto recv = std::make_unique<ast::IdentifierExpr>();
                recv->name = isStatic ? owner : std::string("this");
                recv->loc = call.loc;
                auto callee = std::make_unique<ast::MemberExpr>();
                callee->object = std::move(recv);
                callee->member = name;
                callee->loc = call.loc;
                ast::CallExpr synth;
                synth.callee = std::move(callee);
                synth.loc = call.loc;
                synth.typeArgs = call.typeArgs;
                for (const auto& a : call.args) {
                    synth.args.push_back(cloneExprDeep(a.get()));
                }
                return emitCall(synth);
            }
        }
    }
    error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call.loc);
    return nullptr;
}

}  // namespace polaron
