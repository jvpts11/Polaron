#include "codegen/codegen_impl.h"

namespace polaron {

llvm::Value* CodeGenerator::Impl::emitExpr(const ast::Expr& expr) {
    if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(&expr)) {
        // b"...": a private constant array of the bytes, NUL-terminated, and the pointer to it.
        // No String object, so this works with no runtime -- the freestanding case.
        if (s->isBytes) {
            return emitBytesLiteral(resolveEscapes(s->value));
        }
        return emitStringObject(resolveEscapes(s->value));
    }
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) {
        return llvm::ConstantPointerNull::get(builder.getPtrTy());
    }
    if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
        // Lower to a top-level function, then wrap it in a heap closure {code, env}. The env
        // is null until captures fill it; a function value is always a pointer to this pair.
        std::vector<llvm::Type*> pts;
        pts.push_back(builder.getPtrTy());  // arg 0: captured-environment pointer
        for (const auto& p : lam->params) {
            pts.push_back(llvmType(typeRefName(p.type)));
        }
        llvm::Type* rt = llvmType(typeRefName(lam->returnType));
        llvm::Function* fn = llvm::Function::Create(
            llvm::FunctionType::get(rt, pts, false), llvm::Function::InternalLinkage,
            "__polaron_lambda_" + std::to_string(lambdaCounter++), module);
        // Effective captures = explicitly-declared captures plus auto-captured free variables: any
        // identifier the body references that resolves to an enclosing local (and isn't the lambda's
        // own param or an already-declared capture). Auto-captures are byvalue, which copies the value
        // (for a function value, the closure pointer) so an escaping lambda never dangles on a stack var.
        std::vector<ast::Capture> eff = lam->captures;
        {
            std::set<std::string> refs;
            collectRefs(lam->body, refs);
            std::set<std::string> excluded;
            for (const auto& p : lam->params) {
                excluded.insert(p.name);
            }
            for (const auto& cap : lam->captures) {
                excluded.insert(cap.name);
            }
            for (const auto& name : refs) {
                if (excluded.count(name)) {
                    continue;
                }
                if (locals.find(name) == locals.end()) {
                    continue;  // only enclosing locals
                }
                ast::Capture c;
                c.byRef = false;
                c.name = name;
                eff.push_back(c);
                excluded.insert(name);
            }
        }
        // Collect each captured variable's storage and type from the enclosing scope before
        // emitBody clears `locals`.
        std::vector<llvm::Value*> capStorages;
        std::vector<std::string> capTypes;
        for (const auto& cap : eff) {
            auto cit = locals.find(cap.name);
            capStorages.push_back(cit != locals.end() ? cit->second.storage : nullptr);
            capTypes.push_back(cit != locals.end() ? cit->second.type : std::string("int"));
        }
        // emitBody clobbers all function-local state -- save and restore it.
        auto sFn = currentFn; auto sCls = currentClass; auto sRet = currentRetType; auto sRetN = currentRetTypeName_;
        auto sEns = currentEnsures; auto sInv = currentInvariants; auto sThis = currentThis;
        auto sInvA = currentInvariantsToAssume;
        auto sLoc = locals; auto sScope = scopeObjects; auto sDef = deferred;
        auto sRegions = scopeRegions;
        auto sDtorChain = currentDtorChain;
        auto sOld = oldValues_;  // emitBody clears these; the enclosing method's old() slots must survive
        auto sStr = scopeStrings; auto sTmp = stringTemps;  // String RAII: nested body gets its own set
        auto sVals = scopeValueStructs;
        scopeStrings.clear(); stringTemps.clear(); scopeValueStructs.clear();
        auto sIP = builder.saveIP();
        // `itself(...)` in the body is a direct call to THIS function -- it has to be published
        // before the body is emitted, because that is when the recursive call site is reached.
        auto sSelf = currentLambdaFn_; auto sSelfEnv = currentLambdaHasEnv_;
        currentLambdaFn_ = fn; currentLambdaHasEnv_ = true;
        emitBody(fn, lam->body, lam->params, "", rt, nullptr, nullptr, nullptr, nullptr,
                 /*hasEnv=*/true, &eff, &capTypes);
        currentLambdaFn_ = sSelf; currentLambdaHasEnv_ = sSelfEnv;
        currentFn = sFn; currentClass = sCls; currentRetType = sRet; currentRetTypeName_ = sRetN;
        currentEnsures = sEns; currentInvariants = sInv; currentThis = sThis;
        currentInvariantsToAssume = sInvA;
        currentDtorChain = sDtorChain;
        oldValues_ = sOld;
        locals = sLoc; scopeObjects = sScope; deferred = sDef;
        scopeRegions = sRegions;
        scopeStrings = sStr; stringTemps = sTmp; scopeValueStructs = sVals;
        builder.restoreIP(sIP);
        // No captures: the closure {code, null} is a compile-time constant. Emit it as a private
        // unnamed constant global instead of a heap allocation. Two wins: a no-capture lambda never
        // allocates, and -- because the code pointer is now a constant the optimizer can see through --
        // LLVM (IPSCCP) can propagate this closure into the higher-order method that receives it,
        // turning the per-element indirect call through the function value into a direct, inlinable one.
        if (eff.empty()) {
            auto* pairTy = llvm::ArrayType::get(builder.getPtrTy(), 2);
            std::vector<llvm::Constant*> fields = {
                llvm::cast<llvm::Constant>(fn),
                llvm::ConstantPointerNull::get(builder.getPtrTy())};
            auto* gv = new llvm::GlobalVariable(
                module, pairTy, /*isConstant=*/true, llvm::GlobalValue::PrivateLinkage,
                llvm::ConstantArray::get(pairTy, fields), "__polaron_closure");
            gv->setUnnamedAddr(llvm::GlobalValue::UnnamedAddr::Global);
            return gv;
        }
        // Captures: build the environment (one pointer slot per capture; byvalue copies the value into
        // a fresh heap slot, byref shares the variable's own storage) and wrap {code, env} on the heap.
        llvm::Value* envPtr = builder.CreateCall(
            mallocFn(), {builder.getInt64(8 * (std::int64_t)eff.size())}, "env");
        for (std::size_t i = 0; i < eff.size(); i++) {
            llvm::Value* dst =
                builder.CreateGEP(builder.getPtrTy(), envPtr, builder.getInt32(i));
            if (eff[i].byRef) {
                builder.CreateStore(capStorages[i], dst);  // share the original storage
            } else {
                llvm::Type* vt = llvmType(capTypes[i]);
                llvm::Value* copy =
                    builder.CreateCall(mallocFn(), {builder.getInt64(8)}, "cap");
                // NOTE (2026-08-03): for a CLASS value the loaded "value" is the object's pointer,
                // so a `byvalue` capture SHARES the object rather than copying it -- the lambda sees
                // mutations made after it was created. That contradicts the capture list's own
                // description ("a copy is taken when the lambda is created"), but it is the
                // behaviour four samples deliberately rely on: atomic_counter, mutex_synchronized
                // and the two event tests all write `byvalue` over shared state and expect it to
                // stay shared. Deep-copying here made them read 0.
                //
                // So this is a language DECISION, not a defect to patch: either `byvalue` means a
                // copy and those samples want `byref`, or it means "the value slot, which for an
                // object is its reference" and the wording is what should change. Left as it is
                // until that is settled -- see ACHADOS.md.
                builder.CreateStore(builder.CreateLoad(vt, capStorages[i]), copy);
                builder.CreateStore(copy, dst);
            }
        }
        llvm::Value* clos = builder.CreateCall(mallocFn(), {builder.getInt64(16)}, "closure");
        builder.CreateStore(fn, clos);  // [0] = code pointer
        llvm::Value* envSlot = builder.CreateGEP(builder.getPtrTy(), clos, builder.getInt32(1));
        builder.CreateStore(envPtr, envSlot);  // [1] = env
        return clos;
    }
    if (const auto* old = dynamic_cast<const ast::OldExpr*>(&expr)) {
        // old(e): load the value captured at method entry (spec 29).
        auto it = oldValues_.find(old);
        if (it == oldValues_.end()) {
            error("'old(...)' is only valid inside an ensures clause", expr.loc);
            return nullptr;
        }
        auto* slot = llvm::cast<llvm::AllocaInst>(it->second);
        return builder.CreateLoad(slot->getAllocatedType(), slot, "old");
    }
    if (const auto* mr = dynamic_cast<const ast::MethodRefExpr*>(&expr)) {
        // methodref obj.method (spec 22.3): build a closure {thunk, env={receiver}}. The thunk
        // loads the receiver from its env and forwards to the method, dispatching virtually
        // when the static type is polymorphic so a base-typed receiver still calls the override.
        llvm::Value* recv = emitObjectPtr(*mr->object);
        if (recv == nullptr) {
            return nullptr;
        }
        const std::string st = baseType(typeName(*mr->object));
        const std::string owner = methodOwner(typeName(*mr->object), mr->method);
        auto fnit = functions.find(owner + "." + mr->method);
        if (owner.empty() || fnit == functions.end()) {
            error("unknown method '" + mr->method + "' for methodref", expr.loc);
            return nullptr;
        }
        llvm::Function* target = fnit->second;  // signature: (this, params...) -> Ret
        // The thunk's signature: Ret(env, params...) -- drop the receiver, prepend the env.
        std::vector<llvm::Type*> tpts;
        tpts.push_back(builder.getPtrTy());  // arg 0: env
        for (unsigned i = 1; i < target->arg_size(); i++) {
            tpts.push_back(target->getArg(i)->getType());
        }
        auto* thunkTy = llvm::FunctionType::get(target->getReturnType(), tpts, false);
        llvm::Function* thunk = llvm::Function::Create(
            thunkTy, llvm::Function::InternalLinkage,
            "__polaron_methodref_" + std::to_string(lambdaCounter++), module);
        auto sIP = builder.saveIP();
        auto* entry = llvm::BasicBlock::Create(context, "entry", thunk);
        builder.SetInsertPoint(entry);
        llvm::Value* recvIn = builder.CreateLoad(builder.getPtrTy(), thunk->getArg(0), "recv");
        std::vector<llvm::Value*> callArgs;
        callArgs.push_back(recvIn);
        for (unsigned i = 1; i < thunk->arg_size(); i++) {
            callArgs.push_back(thunk->getArg(i));
        }
        auto stit = classes.find(st);
        int slot = (stit != classes.end() && stit->second.hasVtable)
                       ? slotIndex(st, mr->method)
                       : -1;
        llvm::Value* result = nullptr;
        if (slot >= 0) {  // virtual dispatch through the receiver's vtable
            llvm::Value* vtblField =
                builder.CreateStructGEP(stit->second.type, recvIn, 0, "vtbl.addr");
            llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
            llvm::Type* vtArrTy =
                llvm::ArrayType::get(builder.getPtrTy(), stit->second.vtslots.size());
            llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "slot");
            llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "fn");
            result = builder.CreateCall(target->getFunctionType(), fnPtr, callArgs);
        } else {  // direct (static) call
            result = builder.CreateCall(target, callArgs);
        }
        if (target->getReturnType()->isVoidTy()) {
            builder.CreateRetVoid();
        } else {
            builder.CreateRet(result);
        }
        builder.restoreIP(sIP);
        // env = {receiver}; closure = {thunk, env}.
        llvm::Value* envPtr = builder.CreateCall(mallocFn(), {builder.getInt64(8)}, "mr.env");
        builder.CreateStore(recv, envPtr);
        llvm::Value* clos = builder.CreateCall(mallocFn(), {builder.getInt64(16)}, "mr.closure");
        builder.CreateStore(thunk, clos);  // [0] = code pointer
        llvm::Value* envSlot = builder.CreateGEP(builder.getPtrTy(), clos, builder.getInt32(1));
        builder.CreateStore(envPtr, envSlot);  // [1] = env
        return clos;
    }
    if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
        const std::int64_t v = parseIntLiteral(n->text);
        if (v >= INT32_MIN && v <= INT32_MAX && !ast::intLiteralNeeds64(n->text)) {
            return builder.getInt32(static_cast<std::uint32_t>(v));
        }
        return builder.getInt64(static_cast<std::uint64_t>(v));  // literal needs 64 bits
    }
    if (const auto* f = dynamic_cast<const ast::FloatLiteralExpr*>(&expr)) {
        if (f->isDecimal) {  // i128 mantissa scaled by 10^18 (spec 34)
            return llvm::ConstantInt::get(context,
                                          llvm::APInt(128, decimalScaledString(f->text), 10));
        }
        std::string s;
        for (char c : f->text) {
            if (c != '_' && c != 'f' && c != 'F') {
                s += c;
            }
        }
        double val = 0.0;
        try {
            val = std::stod(s);
        } catch (...) {
        }
        return llvm::ConstantFP::get(builder.getDoubleTy(), val);
    }
    if (const auto* c = dynamic_cast<const ast::CharLiteralExpr*>(&expr)) {
        const std::string bytes = resolveEscapes(c->value);
        const unsigned char value = bytes.empty() ? 0 : static_cast<unsigned char>(bytes[0]);
        return builder.getInt32(value);
    }
    if (const auto* b = dynamic_cast<const ast::BoolLiteralExpr*>(&expr)) {
        return builder.getInt32(b->value ? 1 : 0);
    }
    if (const auto* tup = dynamic_cast<const ast::TupleExpr*>(&expr)) {
        // Build the anonymous struct value component by component.
        const std::string tt = typeName(*tup);
        const std::vector<std::string> comps = tupleElems(tt);
        llvm::StructType* st = tupleStructType(tt);
        llvm::Value* agg = llvm::UndefValue::get(st);
        for (std::size_t i = 0; i < tup->elements.size(); ++i) {
            llvm::Value* v = emitExpr(*tup->elements[i]);
            if (v == nullptr) {
                return nullptr;
            }
            v = coerce(v, typeName(*tup->elements[i]), comps[i]);
            // A value-struct element is a bare `ptr`; storing it as-is captures a pointer into this
            // frame (a param/local copy) that dangles once the tuple is returned by value. Deep-copy
            // it onto the heap so the tuple owns an independent object outliving the frame (spec 11
            // value semantics), matching the field/array/param copy discipline.
            if (i < comps.size() && classes.count(comps[i]) > 0 && classes[comps[i]].isStruct &&
                isCopyDiscipline(comps[i])) {
                v = emitClassCopy(comps[i], v, /*heap=*/true);
            }
            agg = builder.CreateInsertValue(agg, v, {static_cast<unsigned>(i)});
        }
        return agg;
    }
    if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
        return emitMatchExpr(*me);
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        if (id->name == "this") {
            return currentThis;
        }
        // `result` inside an ensures clause (spec 29): the value this return hands back. Bound
        // only while postconditions are being emitted, so everywhere else the name is an ordinary
        // identifier -- a local called `result` still shadows nothing and means itself.
        if (id->name == "result" && currentResultValue_ != nullptr &&
            locals.find("result") == locals.end()) {
            return currentResultValue_;
        }
        auto it = locals.find(id->name);
        if (it == locals.end()) {
            // A namespace-level compile-time constant (spec 28.1).
            if (namespaceConstTypes.count(id->name) > 0) {
                return constLiteral(id->name);
            }
            // A bare enum constant inside one of that enum's own methods (spec 12.4).
            if (auto eit = enums.find(currentClass); eit != enums.end()) {
                const auto& cs = eit->second;
                auto cpos = std::find(cs.begin(), cs.end(), id->name);
                if (cpos != cs.end()) {
                    return builder.getInt32(static_cast<int>(cpos - cs.begin()));
                }
            }
            error("use of undeclared variable '" + id->name + "'", id->loc);
            return nullptr;
        }
        llvm::Value* storage = it->second.storage;
        ensureLazy(it->second.lazyFlag, it->second.lazyInit, storage, it->second.type, id->name);
        return builder.CreateLoad(llvmType(it->second.type), storage, it->second.isVolatile,
                                  id->name);
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        if (mem->safe && &expr != safeGuardNode_) {  // obj?.field (spec 3.7)
            return emitSafeNav(expr, *mem->object);
        }
        // `keyboard.interrupt` -- BIND this object to its handler and yield the entry point the
        // IDT wants. One expression because it is one act: an interrupt vector holds an address
        // and nothing else, so there is no way to obtain the address without saying whose
        // handler it is. What comes back is an `address`, not a callable, which is what keeps
        // "an interrupt cannot be called" true through the reference that installs it --
        // `keyboard.interrupt()` fails on its own, because an address is not a method.
        if (mem->member == "interrupt") {
            if (auto ie = interruptEntries_.find(baseType(typeName(*mem->object)));
                ie != interruptEntries_.end()) {
                llvm::Value* recv = emitExpr(*mem->object);
                if (recv == nullptr) {
                    return nullptr;
                }
                builder.CreateStore(recv, ie->second.self);
                return builder.CreatePtrToInt(ie->second.entry, builder.getInt64Ty(),
                                              "interrupt.entry");
            }
        }
        // SIMD vector lane read: v.x / v.y / v.z / v.w -> extractelement. Gate on the lane
        // name first so a class/enum-name receiver isn't type-probed here.
        if (int lane = vecLane(mem->member); lane >= 0) {
            if (int w = vecWidth(typeName(*mem->object)); lane < w) {
                llvm::Value* v = emitExpr(*mem->object);
                if (v == nullptr) {
                    return nullptr;
                }
                return builder.CreateExtractElement(v, builder.getInt32(lane), mem->member);
            }
        }
        if (const std::string key = staticFieldKey(*mem); !key.empty()) {
            return builder.CreateLoad(llvmType(staticFieldType[key]), staticGlobals[key],
                                      mem->member);
        }
        // A class-level const, read as Type.NAME (spec 28.1, OOP form): folded constant.
        if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (const std::string ck = oid->name + "." + mem->member; namespaceConstTypes.count(ck) > 0) {
                return constLiteral(ck);
            }
        }
        if (llvm::Value* pp = persistentFieldPtr(*mem)) {
            return builder.CreateLoad(llvmType(typeName(*mem)), pp, mem->member);
        }
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (locals.find(objId->name) == locals.end()) {
                // Java-style enum constant -> materialize the instance.
                //
                // ONLY IF IT REALLY IS ONE. An enum may also declare a `static fixed` of its own,
                // which lives on the twin class, and this branch claimed the name before anybody
                // asked whether the enum had a constant by it. In a binary expression that produced
                // a POINTER where an int was wanted -- `n >= Pace.BRISK` built an ICmp of an i32
                // against a singleton -- while the same read in a plain initializer took the static
                // path above and worked. Two spellings of one read, one of them silently a
                // different thing.
                auto jit = javaEnums.find(objId->name);
                if (jit != javaEnums.end() &&
                    std::find(jit->second->constants.begin(), jit->second->constants.end(),
                              mem->member) != jit->second->constants.end()) {
                    return emitEnumConstant(*jit->second, mem->member);
                }
                // Int-style enum constant -> its ordinal (i32).
                auto eit = enums.find(objId->name);
                if (eit != enums.end() &&
                    std::find(eit->second.begin(), eit->second.end(), mem->member) !=
                        eit->second.end()) {
                    // If the enum can be unimported (spec 30), guard the access: a use after
                    // `unimport enum X` throws UnimportedTypeException.
                    emitAliveGuard(objId->name);
                    auto pos = std::find(eit->second.begin(), eit->second.end(), mem->member);
                    const int ord = pos == eit->second.end()
                                        ? 0
                                        : static_cast<int>(pos - eit->second.begin());
                    return builder.getInt32(static_cast<std::uint32_t>(ord));
                }
            }
        }
        // Computed get-only property: obj.name calls the getter (no parens). Dispatch through the
        // vtable when a subtype may override the getter -- exactly like a method call -- so an
        // overridden property reads the most-derived value; a concrete, un-subclassed receiver
        // devirtualizes to a direct call.
        const std::string ot = baseType(typeName(*mem->object));
        if (const ast::MethodDecl* pm = findMethodDecl(ot, mem->member);
            pm != nullptr && pm->isProperty) {
            llvm::Value* recv = emitObjectPtr(*mem->object);
            if (recv == nullptr) {
                return nullptr;
            }
            auto otit = classes.find(ot);
            const bool mayBeSubtype =
                otit != classes.end() &&
                (subclassed_.count(ot) > 0 || otit->second.isInterface ||
                 otit->second.isAbstract || otit->second.imported);
            const int slot = slotIndex(ot, mem->member);
            if (otit != classes.end() && otit->second.hasVtable && mayBeSubtype && slot >= 0) {
                llvm::Value* vtblField =
                    builder.CreateStructGEP(otit->second.type, recv, 0, "vtbl.addr");
                llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
                llvm::Type* vtArrTy =
                    llvm::ArrayType::get(builder.getPtrTy(), otit->second.vtslots.size());
                llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                    vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "slot");
                llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "fn");
                // A value-struct property return goes through the vtable as an sret call too:
                // allocate the result slot and pass it as the trailing arg (spec 11/32).
                if (returnsValueStruct(typeName(*mem))) {
                    llvm::Value* sslot =
                        createEntryAlloca("sret", classes[baseType(typeName(*mem))].type);
                    builder.CreateCall(methodFnType(pm), fnPtr, {recv, sslot});
                    return sslot;
                }
                return builder.CreateCall(methodFnType(pm), fnPtr, {recv});
            }
            const std::string owner = methodOwner(ot, mem->member);
            auto fnit = functions.find(owner + "." + mem->member);
            // A value-struct getter is an sret function (trailing result-slot arg); emitMaybeInvoke
            // allocates and appends the slot, exactly as for a regular method call (spec 11/32).
            if (fnit != functions.end()) {
                return emitMaybeInvoke(fnit->second, {recv});
            }
        }
        llvm::Value* fieldPtr = emitLValue(*mem);
        if (fieldPtr == nullptr) {
            return nullptr;
        }
        // Lazy field (spec 28.4): a null pointer means "not initialized", so run the
        // deferred initializer on first read. Covers value reads, method receivers
        // and nested access, since those all route the field through here.
        if (const ast::Expr* init = lazyFieldInitOf(ot, mem->member); init != nullptr) {
            llvm::Type* fty = llvmType(typeName(*mem));
            if (fty->isPointerTy()) {
                llvm::Value* cur = builder.CreateLoad(fty, fieldPtr, mem->member);
                llvm::Function* fn = currentFn;
                llvm::BasicBlock* initBB = llvm::BasicBlock::Create(context, "lazyf.init", fn);
                llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "lazyf.done", fn);
                builder.CreateCondBr(
                    builder.CreateICmpEQ(cur, llvm::ConstantPointerNull::get(builder.getPtrTy())),
                    initBB, doneBB);
                builder.SetInsertPoint(initBB);
                if (llvm::Value* iv = emitExpr(*init); iv != nullptr) {
                    iv = coerce(iv, typeName(*init), typeName(*mem));
                    builder.CreateStore(iv, fieldPtr);
                }
                builder.CreateBr(doneBB);
                builder.SetInsertPoint(doneBB);
                return builder.CreateLoad(fty, fieldPtr, mem->member);
            }
        }
        // A packed bit field: `fieldPtr` is the address of the shared UNIT, so extract rather than
        // load (spec 11.1).
        if (const std::string bfOwner = bitFieldOwner(*mem); !bfOwner.empty()) {
            return emitBitFieldLoad(fieldPtr, bfOwner, mem->member, isVolatileAccess(*mem));
        }
        // A narrow `A*`: the field holds a 32-bit offset into A's arena, not a pointer. Widening here
        // rather than at every use is what keeps the representation change to the one place it pays.
        if (const std::string nt = narrowTargetClass(typeName(*mem)); !nt.empty()) {
            return emitNarrowLoad(fieldPtr, nt, isVolatileAccess(*mem), mem->member);
        }
        return builder.CreateLoad(llvmType(typeName(*mem)), fieldPtr, isVolatileAccess(*mem),
                                  mem->member);
    }
    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
        // await on a non-Task (a channel receive, spec 20.7) is a passthrough: the operand already
        // produces the value by blocking, so just evaluate it (the analyzer restricts this form).
        if (baseType(typeName(*aw->operand)).rfind("Task$", 0) != 0) {
            return emitExpr(*aw->operand);
        }
        llvm::Value* taskObj = emitExpr(*aw->operand);
        if (taskObj == nullptr) {
            return nullptr;
        }
        const std::string taskCls = baseType(typeName(*aw->operand));  // Task$X
        auto cit = classes.find(taskCls);
        if (cit == classes.end()) { error("await of a non-Task value", aw->loc); return nullptr; }
        llvm::Value* h = builder.CreateLoad(
            builder.getInt64Ty(),
            builder.CreateStructGEP(cit->second.type, taskObj,
                                    cit->second.fieldIndex["h"], "task.h.addr"),
            "task.h");
        const std::string elem =
            taskCls.rfind("Task$", 0) == 0 ? taskCls.substr(5) : taskCls;
        // Inside an async state machine: save the handle, advance the state, and await -- which
        // suspends (returns) if the task is not yet done, registering this resume block as the
        // continuation. The entry switch jumps back here when the awaited task completes.
        if (asyncSM) {
            const int k = asyncSMAwaitIdx++;
            llvm::Value* slot =
                builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, asyncSMAwaitBase + k);
            builder.CreateStore(h, slot);
            builder.CreateStore(builder.getInt32(k + 1),
                                builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, 0));
            llvm::FunctionType* awTy = llvm::FunctionType::get(
                builder.getInt32Ty(),
                {builder.getInt64Ty(), builder.getPtrTy(), builder.getPtrTy()}, false);
            llvm::Value* suspended = builder.CreateCall(
                module.getOrInsertFunction("__polaron_await", awTy),
                {h, asyncSMResume, asyncSMStatePtr}, "suspend?");
            llvm::BasicBlock* resumeBlk = llvm::BasicBlock::Create(
                context, "resume" + std::to_string(k + 1), currentFn);
            builder.CreateCondBr(builder.CreateICmpNE(suspended, builder.getInt32(0)),
                                 asyncSMSuspend, resumeBlk);
            asyncSMCases.push_back({k + 1, resumeBlk});
            builder.SetInsertPoint(resumeBlk);
            llvm::Value* savedH = builder.CreateLoad(
                builder.getInt64Ty(),
                builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, asyncSMAwaitBase + k),
                "aw.saved");
            emitAwaitRethrowCheck(savedH);  // re-throw here if the awaited task failed (spec 21)
            llvm::FunctionType* trTy = llvm::FunctionType::get(
                builder.getInt64Ty(), {builder.getInt64Ty()}, false);
            llvm::Value* r = builder.CreateCall(
                module.getOrInsertFunction("__polaron_task_result", trTy), {savedH}, "aw.result");
            return castTaskResult(r, elem);
        }
        // Non-async context (e.g. main): block until the task completes, then read its result.
        llvm::FunctionType* wtTy = llvm::FunctionType::get(
            builder.getInt64Ty(), {builder.getInt64Ty()}, false);
        llvm::Value* r = builder.CreateCall(
            module.getOrInsertFunction("__polaron_task_wait", wtTy), {h}, "await");
        emitAwaitRethrowCheck(h);  // re-throw here if the awaited task failed (spec 21)
        return castTaskResult(r, elem);
    }
    if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(&expr)) {
        // spec 30.18: run the expecting block in the old code (its return is the validation
        // value), then unimport the class. The expression evaluates to that value.
        llvm::Value* v = emitExpectingValue(ue->expecting.get());
        emitUnimportClass(baseType(ue->target));
        return v;
    }
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        if (un->op == "&") {
            // Address-of. For a class/struct value the variable's slot already holds the pointer to
            // the object -- its identity IS that pointer, so `&rex` is just `rex` (and address-of
            // does not dereference, so a null nullable is fine here). For anything else -- an int
            // local, an array element, a field -- the address is the address of its STORAGE, which
            // is what emitLValue yields. Taking emitObjectPtr for those loaded the VALUE and used it
            // as a pointer: `int* p = &xs[0]` used to produce garbage (a silent memory-safety hole).
            const std::string ot = typeName(*un->operand);
            // A pointer variable is NOT an object here: `&p` on a `T*` must yield the address of the
            // slot holding p (a `T**`, one level deeper), which is what emitLValue gives -- not the
            // object p points at.
            const bool isPtr = !ot.empty() && ot.back() == '*';
            const bool isObject = !isPtr && !ot.empty() && !isArrayType(ot) && !isRefType(ot) &&
                                  classes.count(baseType(ot)) > 0;
            if (isObject) {
                return emitObjectPtr(*un->operand, /*derefCheck=*/false);
            }
            return emitLValue(*un->operand);
        }
        if (un->op == "*") {
            // Pointer dereference: peel one '*'. Every pointer is an LLVM `ptr`, so a deref is one
            // load of the pointee's type. Exception: a depth-1 pointer to a class/struct value holds
            // the object pointer directly (`&v == the object ptr`), so `*p` is p itself, no load.
            const std::string ot = typeName(*un->operand);
            if (ot.empty() || ot.back() != '*') {
                error("cannot dereference '" + ot + "': it is not a pointer", un->loc);
                return nullptr;
            }
            llvm::Value* pv = emitExpr(*un->operand);
            if (pv == nullptr) {
                return nullptr;
            }
            const std::string rt = ot.substr(0, ot.size() - 1);  // one '*' removed
            const bool classValue = !rt.empty() && rt.back() != '*' && !isArrayType(rt) &&
                                    classes.count(baseType(rt)) > 0;
            if (classValue) {
                return pv;
            }
            return builder.CreateLoad(llvmType(rt), pv, "deref");
        }
        // Unary operator overload (spec 6.5): a.operator<op>() when a's class defines a no-arg
        // one. A unary overload takes only `this` (arg_size 1), which distinguishes it from the
        // binary form of the same symbol.
        {
            const std::string owner =
                methodOwner(baseType(typeName(*un->operand)), "operator" + un->op);
            if (!owner.empty()) {
                auto fnit = functions.find(owner + ".operator" + un->op);
                // A unary overload has no explicit params: LLVM arg count is 1 (`this`), or 2 when
                // the operator returns a value struct (a trailing sret result slot is appended).
                // The bare `== 1` check skipped struct-returning unary operators (spec 6.5/11).
                if (fnit != functions.end() &&
                    fnit->second->arg_size() == (sretFns_.count(fnit->second) > 0 ? 2u : 1u)) {
                    llvm::Value* recv = emitExpr(*un->operand);
                    if (recv == nullptr) {
                        return nullptr;
                    }
                    return emitMaybeInvoke(fnit->second, {recv});
                }
            }
        }
        llvm::Value* v = emitExpr(*un->operand);
        if (v == nullptr) {
            return nullptr;
        }
        if (un->op == "-") {
            return v->getType()->isFloatingPointTy() ? builder.CreateFNeg(v)
                                                      : builder.CreateNeg(v);
        }
        if (un->op == "!") {
            return builder.CreateZExt(builder.CreateICmpEQ(v, builder.getInt32(0)),
                                      builder.getInt32Ty());
        }
        if (un->op == "~") {
            return builder.CreateNot(v);  // bitwise not
        }
        error("unsupported unary operator '" + un->op + "'", un->loc);
        return nullptr;
    }
    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        return emitTernary(*tern);
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&expr)) {
        return emitNullCoalesce(*nc);
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        return emitBinary(*bin);
    }
    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
        return emitNew(*nw);
    }
    if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(&expr)) {
        // A first-class range value (spec 7.5): new Range(start, end, step, inclusive) on the heap.
        llvm::Value* startV = coerceToType(emitExpr(*rng->start), builder.getInt32Ty());
        llvm::Value* endV = coerceToType(emitExpr(*rng->end), builder.getInt32Ty());
        llvm::Value* stepV = rng->step ? coerceToType(emitExpr(*rng->step), builder.getInt32Ty())
                                       : builder.getInt32(1);
        llvm::Value* incV = builder.getInt32(rng->inclusive ? 1 : 0);
        auto cit = classes.find("Range");
        if (cit == classes.end()) { error("Range type is not available", rng->loc); return nullptr; }
        llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "range");
        builder.CreateCall(functions["Range.Range"], {obj, startV, endV, stepV, incV});
        return obj;
    }
    if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) {
        llvm::Value* src = emitExpr(*mv->operand);
        if (src == nullptr) {
            return nullptr;
        }
        // `move x into/to region R` (spec 19.3): physically relocate the object into R's arena
        // (bump-allocate + shallow copy) so it outlives the source region's release. The analyzer
        // invalidates the source, so the old storage is dead. Otherwise a move is a pointer transfer.
        if (!mv->toRegion.empty()) {
            const std::string cls = baseType(typeName(*mv->operand));
            if (auto cit = classes.find(cls); cit != classes.end() && cit->second.type != nullptr) {
                // Relocating into another region is what `new A() in region other` says, spelled as a
                // move -- and it is refused for the same reason and in the same words. A region class
                // has one arena; an A somewhere else is the one thing the feature is built on not
                // existing.
                if (cit->second.decl != nullptr && cit->second.decl->isRegionClass) {
                    error("`" + cls + "` is a `region class`, so `into region " + mv->toRegion +
                              "` would move it out of the only region its instances may be in -- the "
                              "same thing `in region` is refused for at `new`",
                          mv->loc);
                    return nullptr;
                }
                llvm::Value* dst = emitRegionAlloc(mv->toRegion, cit->second.type, mv->loc);
                if (dst != nullptr) {
                    emitMemcpy(dst, src, sizeOf(cit->second.type));
                    return dst;
                }
            }
        }
        return src;  // move transfers the pointer (no copy)
    }
    if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(&expr)) {
        // `extract X from region R` (spec 17): relocate X out of the region to a fresh heap block and
        // yield the owning pointer. This is a MOVE -- a shallow copy of the object's bytes, so owned
        // heap fields (String/array backings, whose pointers live in those bytes) travel with it; the
        // source is not destructed. The vacated slot is reclaimed on pool/fixedslot (dead until release
        // on bump). The source lvalue is nulled and dropped from region RAII so nothing double-frees it.
        const std::string cn = baseType(typeName(*ex->target));
        auto cit = classes.find(cn);
        if (cit == classes.end() || cit->second.type == nullptr) {
            error("extract requires a class object (spec 17)", ex->loc);
            return nullptr;
        }
        // `extract` IS the escape a region class forbids. Relocating an object out of a region to a
        // fresh heap block is the right answer for an owned region, whose point is that the region
        // dies and this one object should not; a region class has no such moment -- its arena is the
        // only place its instances may be, and an extracted A is an A that `on heap` would have been
        // refused for. Refused here rather than obeyed, for the same reason: obeying it ends the
        // totality that unimport's O(1) liveness, the linear walk and the narrow `A*` all read.
        if (cit->second.decl != nullptr && cit->second.decl->isRegionClass) {
            error("`" + cn + "` is a `region class`, so there is nowhere to extract it TO -- its "
                  "arena is the only place its instances may be, which is what `on heap` is refused "
                  "for as well. Copy the values you need out instead of relocating the object",
                  ex->loc);
            return nullptr;
        }
        llvm::Value* addr = emitLValue(*ex->target);       // where the source handle is stored
        llvm::Value* srcPtr = emitObjectPtr(*ex->target);  // the object's address in the region
        if (addr == nullptr || srcPtr == nullptr) {
            return nullptr;
        }
        llvm::Value* heap = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "extract.heap");
        emitMemcpy(heap, srcPtr, sizeOf(cit->second.type));  // shallow move-out
        // Drop the source object from region RAII tracking so release does not destruct the moved bytes.
        if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(ex->target.get())) {
            if (auto lit = locals.find(tid->name); lit != locals.end()) {
                for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so) {
                    if (so->slot == lit->second.storage) { scopeObjects.erase(so); break; }
                }
            }
        }
        // Reclaim/untrack the vacated slot on a pool/fixedslot/stack region (the runtime free untracks
        // a stack object so rollback/release never re-destructs the bytes that moved to the heap).
        const std::string rflavor =
            flavorOfRegion(ex->region);
        if (usesRuntimeDesc(rflavor)) {
            llvm::Value* block = builder.CreateLoad(
                builder.getPtrTy(), regionStorageSlot(ex->region), "region");
            builder.CreateCall(regionFreeFn(), {block, srcPtr, sizeOf(cit->second.type)});
        }
        // Null the source handle: a later read is then a clean null, not a dangling reused slot (the
        // analyzer already rejects use-after-extract of a plain variable at compile time).
        builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), addr);
        return heap;
    }
    if (const auto* mk = dynamic_cast<const ast::MarkExpr*>(&expr)) {
        // `mark of region R`: capture the stack region's cursor (desc->used at offset 0) as a checkpoint.
        llvm::Value* slot = regionStorageSlot(mk->region);
        if (slot == nullptr) { error("unknown region '" + mk->region + "'", mk->loc); return nullptr; }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
        return builder.CreateLoad(builder.getInt64Ty(), block, "mark");
    }
    if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
        // try? expr (spec 21.2): if Ok/Some, yield the inner value; if Err/None, early-return the
        // operand to the enclosing method's Result/Option (propagation).
        llvm::Value* val = emitExpr(*tx->operand);
        if (val == nullptr) {
            return nullptr;
        }
        const std::string opType = typeName(*tx->operand);
        const bool isValue = isValueVariant(opType);
        const std::string base = baseType(opType);  // Result$T$E / Option$T
        const auto p = base.find('$');
        const std::string variant = base.rfind("Option", 0) == 0 ? "Some" : "Ok";
        auto cit = classes.find(p == std::string::npos ? variant : variant + base.substr(p));
        if (cit == classes.end() || cit->second.fieldIndex.count("value") == 0 ||
            (!isValue && cit->second.vtable == nullptr)) {
            error("try? requires a Result or Option operand", tx->loc);
            return nullptr;
        }
        const std::string vt = cit->second.fieldType.at("value");  // T
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "try.ok", fn);
        llvm::BasicBlock* errBB = llvm::BasicBlock::Create(context, "try.err", fn);
        if (isValue) {  // value form: dispatch on the tag (0 = Ok/Some)
            llvm::Value* tag = builder.CreateExtractValue(val, {0u}, "try.tag");
            builder.CreateCondBr(builder.CreateICmpEQ(tag, builder.getInt32(0), "try.ok?"), okBB,
                                 errBB);
        } else {  // boxed form: dispatch on the vtable
            llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), val, "try.vtbl");
            builder.CreateCondBr(builder.CreateICmpEQ(vtbl, cit->second.vtable, "try.ok?"), okBB,
                                 errBB);
        }
        builder.SetInsertPoint(errBB);
        emitPendingFinallys(0);       // run enclosing finallys before propagating out
        emitScopeCleanup();           // run destructors/defers before propagating
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateRet(val);   // forward the Err/None (value struct or boxed ptr) unchanged
        }
        builder.SetInsertPoint(okBB);
        if (isValue) {  // decode the payload to T
            llvm::Value* payload = builder.CreateExtractValue(val, {1u}, "try.pl");
            return variantDecode(payload, llvmType(vt));
        }
        llvm::Value* vp = builder.CreateStructGEP(cit->second.type, val,
                                                  cit->second.fieldIndex.at("value"), "try.vp");
        return builder.CreateLoad(llvmType(vt), vp, "try.value");
    }
    if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
        return emitRegionAllocate(ri->size.get(), ri->atAddress.get(), pendingRegionFlavor_,
                                  pendingRegionGrowable_, pendingRegionRegistry_);
    }
    // `snapshot region W in region B` (spec 32.2): ask how much room the capture needs, take that
    // much from B, and fill it. The block is an ordinary region slot, which is what makes the
    // snapshot's memory visible to the ownership tree instead of sitting beside it -- and what
    // makes `release` the programmer's, by design.
    if (const auto* sn = dynamic_cast<const ast::SnapshotExpr*>(&expr)) {
        llvm::Value* srcSlot = regionStorageSlot(sn->region);
        if (srcSlot == nullptr) { error("unknown region '" + sn->region + "'", sn->loc); return nullptr; }
        llvm::Value* homeSlot = regionStorageSlot(sn->home);
        if (homeSlot == nullptr) { error("unknown region '" + sn->home + "'", sn->loc); return nullptr; }
        llvm::Value* src = builder.CreateLoad(builder.getPtrTy(), srcSlot, "snap.src");
        llvm::Value* home = builder.CreateLoad(builder.getPtrTy(), homeSlot, "snap.home");
        llvm::Value* size = builder.CreateCall(regionSnapshotSizeFn(), {src}, "snap.size");
        llvm::Value* into = builder.CreateCall(regionNewFn(), {home, size}, "snap.block");
        builder.CreateCall(regionSnapshotFn(), {src, into, size});
        // The handle's Polaron type is `address`, which is an integer here -- the block pointer has
        // to cross that boundary explicitly rather than by luck.
        return builder.CreatePtrToInt(into, llvmType("address"), "snap.handle");
    }
    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        // `x is T` (op 1) / `x as? T` (op 2), spec 6.4: a runtime is-a test on a class value.
        if (cst->op == 1 || cst->op == 2) {
            llvm::Value* obj = emitExpr(*cst->operand);
            if (obj == nullptr) {
                return nullptr;
            }
            llvm::Value* isa = emitIsa(obj, baseType(cst->targetType));  // i1, null-safe
            if (cst->op == 1) {
                return builder.CreateZExt(isa, builder.getInt32Ty());  // boolean = i32
            }
            return builder.CreateSelect(isa, obj,
                                        llvm::ConstantPointerNull::get(builder.getPtrTy()));
        }
        // User-defined conversion operator (spec 6.6): cast<T>(obj) where obj's class declares
        // `operator cast<T>` calls it instead of a primitive cast.
        const std::string srcCls = baseType(typeName(*cst->operand));
        if (classes.count(srcCls) > 0) {
            auto simple = [](const std::string& s) {
                auto p = s.rfind("__");
                return p == std::string::npos ? s : s.substr(p + 2);
            };
            const std::string opName = "operator cast$" + simple(baseType(cst->targetType));
            const std::string owner = methodOwner(srcCls, opName);
            if (!owner.empty()) {
                if (auto fnit = functions.find(owner + "." + opName); fnit != functions.end()) {
                    llvm::Value* recv = emitObjectPtr(*cst->operand);
                    if (recv == nullptr) {
                        return nullptr;
                    }
                    return builder.CreateCall(fnit->second, {recv});
                }
            }
        }
        // ASSERTING NON-NULL. `cast<T*>(p)` where `p` is `nullable T*` is the program stating that
        // it checked. It used to reinterpret with no check at all, so a wrong assertion produced an
        // access violation somewhere later with nothing pointing back at who promised what -- while
        // its sibling `cast<Dog>(animal)` verified and threw. Same syntax, opposite guarantees.
        //
        // Free where it does not apply: the condition is entirely static, so a cast between two
        // non-nullable types emits exactly what it emitted before. And with flow narrowing in place
        // these casts are the rare deliberate case rather than the price of every null check.
        {
            const std::string fromT = typeName(*cst->operand);
            const std::string toT = cst->targetType;
            if (cst->op == 0 && ast::typeIsNullable(fromT) && !ast::typeIsNullable(toT)) {
                llvm::Value* v = emitExpr(*cst->operand);
                if (v == nullptr) {
                    return nullptr;
                }
                if (v->getType()->isPointerTy()) {
                    llvm::Value* isNull = builder.CreateICmpEQ(
                        v, llvm::ConstantPointerNull::get(builder.getPtrTy()), "cast.isnull");
                    llvm::Function* f = currentFn;
                    auto* badBB = llvm::BasicBlock::Create(context, "cast.wasnull", f);
                    auto* okBB = llvm::BasicBlock::Create(context, "cast.ok", f);
                    builder.CreateCondBr(isNull, badBB, okBB, coldBranchWeights());
                    builder.SetInsertPoint(badBB);
                    emitArithFault("NullReferenceException",
                                   "cast asserted a value but found null");
                    builder.SetInsertPoint(okBB);
                }
                return emitCast(v, fromT, toT);
            }
        }
        // NUMBER -> int-style enum, RANGE CHECKED.
        //
        // An int-style enum IS its ordinal at runtime, so the conversion itself is free. What is
        // not free -- and what makes this safe to offer at all -- is proving the number names a
        // constant that exists. Without the check a program could manufacture a value outside the
        // declared set, and every `match` over that enum would then have a case it was promised
        // could not happen: exhaustiveness would become a guarantee the language cannot keep.
        //
        // Same shape as the asserting null cast above. A cast is the program STATING something,
        // and a statement that can be checked should be.
        if (cst->op == 0) {
            const std::string toE = baseType(cst->targetType);
            auto eit = enums.find(toE);
            if (eit != enums.end() && javaEnums.count(toE) == 0 &&
                enums.count(baseType(typeName(*cst->operand))) == 0) {
                llvm::Value* v = emitExpr(*cst->operand);
                if (v == nullptr) {
                    return nullptr;
                }
                if (v->getType()->isIntegerTy()) {
                    v = coerceToType(v, builder.getInt32Ty());
                    const int n = static_cast<int>(eit->second.size());
                    llvm::Value* bad = builder.CreateOr(
                        builder.CreateICmpSLT(v, builder.getInt32(0)),
                        builder.CreateICmpSGE(v, builder.getInt32(n)), "enum.outofrange");
                    llvm::Function* f = currentFn;
                    auto* badBB = llvm::BasicBlock::Create(context, "enum.bad", f);
                    auto* okBB = llvm::BasicBlock::Create(context, "enum.ok", f);
                    builder.CreateCondBr(bad, badBB, okBB, coldBranchWeights());
                    builder.SetInsertPoint(badBB);
                    emitArithFault("ArithmeticException",
                                   "cast to enum: value names no constant");
                    builder.SetInsertPoint(okBB);
                    return v;
                }
            }
        }
        return emitCast(emitExpr(*cst->operand), typeName(*cst->operand), cst->targetType);
    }
    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
        return emitNewArray(*na);
    }
    if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(&expr)) {
        return emitArrayLiteral(*al);
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        // operator[] overload (spec 6.5): obj[i] -> obj.operator[](i).
        const std::string at = typeName(*ix->array);
        const std::string owner = methodOwner(baseType(at), "operator[]");
        auto fnit = owner.empty() ? functions.end() : functions.find(owner + ".operator[]");
        if (fnit != functions.end()) {
            llvm::Value* recv = emitExpr(*ix->array);
            llvm::Value* idx = emitExpr(*ix->index);
            if (recv == nullptr || idx == nullptr) {
                return nullptr;
            }
            if (fnit->second->arg_size() >= 2) {
                idx = coerceToType(idx, fnit->second->getArg(1)->getType());
            }
            return emitMaybeInvoke(fnit->second, {recv, idx});
        }
        // SIMD vector/matrix index: v[i] / m[i] -> extractelement, bounds-checked (no UB).
        if (int w = (at == "mat4" ? 16 : vecWidth(at)); w > 0) {
            llvm::Value* v = emitExpr(*ix->array);
            llvm::Value* idx = emitExpr(*ix->index);
            if (v == nullptr || idx == nullptr) {
                return nullptr;
            }
            llvm::Value* oob = builder.CreateICmpUGE(
                builder.CreateSExt(idx, builder.getInt64Ty()), builder.getInt64(w));
            llvm::Function* f = currentFn;
            auto* badBB = llvm::BasicBlock::Create(context, "vidx.bad", f);
            auto* okBB = llvm::BasicBlock::Create(context, "vidx.ok", f);
            builder.CreateCondBr(oob, badBB, okBB, coldBranchWeights());
            builder.SetInsertPoint(badBB);
            emitPanic("vector index out of bounds");
            builder.SetInsertPoint(okBB);
            return builder.CreateExtractElement(v, idx, "vec.elem");
        }
        llvm::Value* elemPtr = emitLValue(*ix);
        if (elemPtr == nullptr) {
            return nullptr;
        }
        const std::string et = isRefType(at) ? baseType(at) : elementOf(at);  // T* -> T
        const bool vol = isVolatileAccess(*ix);  // spec 37.5: load through a volatile (MMIO) pointer
        if (!isRefType(at) && et == "boolean") {  // boolean array element: 1-byte storage, i32 value
            llvm::Value* raw = builder.CreateLoad(builder.getInt8Ty(), elemPtr, vol, "elem");
            return builder.CreateZExt(raw, builder.getInt32Ty());
        }
        // A value aggregate stored inline IS its storage: a struct value is represented by the
        // address of its bytes everywhere else in this backend, so the element pointer is already
        // the value. Loading here would read the first field as if the slot held a reference --
        // which is exactly what made `cells[0].a` dereference null.
        if (!isRefType(at) && inlineElemStructTy(et) != nullptr) {
            return elemPtr;
        }
        llvm::LoadInst* ld = builder.CreateLoad(llvmType(et), elemPtr, vol, "elem");
        // A raw pointer `p[i]` may target ANY address (spec 17.8): never assume the type's natural
        // alignment -- a misaligned load would be UB. `align 1` makes it total. On x86 this is the same
        // single instruction (unaligned loads are native) and volatile width is preserved; the backend
        // still uses wider alignment where it can prove it. Managed arrays are allocator-aligned -> keep
        // the natural alignment (vectorization, perf).
        if (isRefType(at)) {
            ld->setAlignment(llvm::Align(1));
        }
        return ld;
    }
    if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(&expr)) {
        return emitInterp(*is, /*addNewline=*/false, /*asString=*/true);  // $"..." -> String (4.1)
    }
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        // super(args) was already emitted in the constructor prologue.
        if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
            return nullptr;
        }
        // spec 32.8: `Dog.methods.replace("bark", fn)` rewrites the class's vtable slot.
        if (const auto* rp = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            rp != nullptr && rp->member == "replace" && call->args.size() == 2) {
            if (const auto* tbl = dynamic_cast<const ast::MemberExpr*>(rp->object.get());
                tbl != nullptr && tbl->member == "methods") {
                if (const auto* cn = dynamic_cast<const ast::IdentifierExpr*>(tbl->object.get());
                    cn != nullptr && classes.count(cn->name) > 0) {
                    return emitMethodPatch(cn->name, *call);
                }
            }
        }
        llvm::Value* r = emitCall(*call);
        // String RAII stage 2: a user method's String result is owned (copy-on-return). Register it
        // as a temporary so a discarded / consumed result is freed at the statement boundary instead
        // of leaking. Stores and returns copy first, so this never frees a still-referenced String.
        if (r != nullptr && callReturnsOwnedUserString(*call)) {
            return ownedStr(r);
        }
        return r;
    }
    error("unsupported expression in codegen", expr.loc);
    return nullptr;
}

llvm::Value* CodeGenerator::Impl::emitBinary(const ast::BinaryExpr& bin) {
    if (bin.op == "&&" || bin.op == "||") {
        return emitShortCircuit(bin);
    }
    const std::string lt = typeName(*bin.lhs);
    // Pointer arithmetic (spec 27): `p + n` / `p - n` step by whole ELEMENTS. Without this the
    // pointer would be fed to an integer add, which is not even valid IR. The distance between two
    // pointers (`q - p`) is an element count, like C. The analyzer warns when the pointee is a class.
    if ((bin.op == "+" || bin.op == "-") && isRefType(lt)) {
        const std::string rt = typeName(*bin.rhs);
        llvm::Value* base = emitExpr(*bin.lhs);
        llvm::Value* off = emitExpr(*bin.rhs);
        if (base == nullptr || off == nullptr) {
            return nullptr;
        }
        llvm::Type* elem = llvmType(baseType(lt));
        if (isRefType(rt)) {  // q - p: how many elements apart
            if (bin.op != "-") {
                error("two pointers cannot be added (spec 27)", bin.loc);
                return nullptr;
            }
            llvm::Value* a = builder.CreatePtrToInt(base, builder.getInt64Ty());
            llvm::Value* b = builder.CreatePtrToInt(off, builder.getInt64Ty());
            llvm::Value* bytes = builder.CreateSub(a, b, "ptr.diff.bytes");
            return builder.CreateSDiv(bytes, sizeOf(elem), "ptr.diff");
        }
        llvm::Value* n = builder.CreateSExtOrTrunc(off, builder.getInt64Ty());
        if (bin.op == "-") {
            n = builder.CreateNeg(n, "ptr.back");
        }
        return builder.CreateGEP(elem, base, {n}, "ptr.off");
    }
    // Operator overloading: a OP b -> a.operator OP(b) when a's class defines it.
    {
        const std::string owner = methodOwner(baseType(lt), "operator" + bin.op);
        auto fnit = owner.empty() ? functions.end()
                                  : functions.find(owner + ".operator" + bin.op);
        if (fnit != functions.end()) {
            llvm::Value* recv = emitExpr(*bin.lhs);
            SpillToken rtk;
            if (asyncSM && containsAwait(*bin.rhs)) {
                rtk = spillAcrossAwait(recv);
            }
            llvm::Value* arg = emitExpr(*bin.rhs);
            recv = reloadSpill(rtk, recv);
            if (recv == nullptr || arg == nullptr) {
                return nullptr;
            }
            if (fnit->second->arg_size() >= 2) {
                arg = coerceToType(arg, fnit->second->getArg(1)->getType());
            }
            // Route through the sret-aware wrapper: an operator returning a value struct is an
            // sret function (extra trailing result-slot argument), so a raw 2-arg call would have
            // the wrong signature and crash. emitMaybeInvoke handles both sret and plain returns.
            return emitMaybeInvoke(fnit->second, {recv, arg});
        }
    }
    const std::string rt = typeName(*bin.rhs);
    llvm::Value* l = emitExpr(*bin.lhs);
    SpillToken ltk;
    if (asyncSM && containsAwait(*bin.rhs)) {
        ltk = spillAcrossAwait(l);
    }
    llvm::Value* r = emitExpr(*bin.rhs);
    l = reloadSpill(ltk, l);
    if (l == nullptr || r == nullptr) {
        return nullptr;
    }
    const std::string& op = bin.op;
    // String concatenation: + on String/string operands builds a fresh String (spec 4).
    if (op == "+" && (lt == "String" || lt == "string") && (rt == "String" || rt == "string")) {
        return ownedStr(emitStringConcat(l, r));
    }
    // String equality (spec 4): ==/!= on String/string operands compares CONTENT (immutable value
    // semantics), lowering to strcmp -- the same runtime String.equals uses. Without this the string
    // operands would fall through to the integer comparison path below, which sign-extends the
    // string pointers to i32 (invalid IR: "SExt only operates on integer").
    if ((op == "==" || op == "!=") && (lt == "String" || lt == "string") &&
        (rt == "String" || rt == "string")) {
        llvm::Value* eq = builder.CreateCall(strEqFn(), {l, r});  // i32: 1 equal, 0 not
        if (op == "==") {
            return eq;
        }
        return builder.CreateZExt(builder.CreateICmpEQ(eq, builder.getInt32(0)),
                                  builder.getInt32Ty());
    }
    // Decimal fixed-point arithmetic (spec 34): i128 mantissa, scale 10^18. Multiply and divide
    // rescale through a 256-bit intermediate so the product does not overflow.
    if (lt == "Decimal" && rt == "Decimal") {
        if (op == "+") {
            return builder.CreateAdd(l, r);
        }
        if (op == "-") {
            return builder.CreateSub(l, r);
        }
        llvm::Type* i256 = builder.getIntNTy(256);
        llvm::Constant* scale256 = llvm::ConstantInt::get(
            context, llvm::APInt(256, "1" + std::string(DECIMAL_SCALE, '0'), 10));
        if (op == "*") {
            llvm::Value* p =
                builder.CreateMul(builder.CreateSExt(l, i256), builder.CreateSExt(r, i256));
            return builder.CreateTrunc(builder.CreateSDiv(p, scale256), builder.getInt128Ty());
        }
        if (op == "/") {
            llvm::Value* num = builder.CreateMul(builder.CreateSExt(l, i256), scale256);
            return builder.CreateTrunc(builder.CreateSDiv(num, builder.CreateSExt(r, i256)),
                                       builder.getInt128Ty());
        }
        llvm::Value* c = nullptr;
        if (op == "==") {
            c = builder.CreateICmpEQ(l, r);
        } else if (op == "!=") {
            c = builder.CreateICmpNE(l, r);
        } else if (op == "<") {
            c = builder.CreateICmpSLT(l, r);
        } else if (op == ">") {
            c = builder.CreateICmpSGT(l, r);
        } else if (op == "<=") {
            c = builder.CreateICmpSLE(l, r);
        } else if (op == ">=") {
            c = builder.CreateICmpSGE(l, r);
        }
        if (c != nullptr) {
            return builder.CreateZExt(c, builder.getInt32Ty());
        }
    }
    // SIMD vector path: element-wise + - * / on vecN; a scalar operand is broadcast.
    if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) {
        auto toVec = [&](llvm::Value* x, const std::string& xt) -> llvm::Value* {
            if (vecWidth(xt) > 0) {
                return x;  // already a vector
            }
            return builder.CreateVectorSplat(vw, coerceToType(x, builder.getFloatTy()));
        };
        l = toVec(l, lt);
        r = toVec(r, rt);
        if (op == "+") {
            return builder.CreateFAdd(l, r);
        }
        if (op == "-") {
            return builder.CreateFSub(l, r);
        }
        if (op == "*") {
            return builder.CreateFMul(l, r);
        }
        if (op == "/") {
            return builder.CreateFDiv(l, r);
        }
        error("unsupported vector operator '" + op + "'", bin.loc);
        return nullptr;
    }
    // Floating-point path: the result is f64 if either side is f64, else f32.
    if (isFloatType(lt) || isFloatType(rt)) {
        const bool f64 = (isFloatType(lt) && !isF32(lt)) || (isFloatType(rt) && !isF32(rt));
        const std::string ft = f64 ? "double" : "float";
        l = coerce(l, lt, ft);
        r = coerce(r, rt, ft);
        if (op == "+") {
            return builder.CreateFAdd(l, r);
        }
        if (op == "-") {
            return builder.CreateFSub(l, r);
        }
        if (op == "*") {
            return builder.CreateFMul(l, r);
        }
        if (op == "/") {
            return builder.CreateFDiv(l, r);
        }
        llvm::Value* fc = nullptr;
        if (op == "==") {
            fc = builder.CreateFCmpOEQ(l, r);
        } else if (op == "!=") {
            fc = builder.CreateFCmpONE(l, r);
        } else if (op == "<") {
            fc = builder.CreateFCmpOLT(l, r);
        } else if (op == ">") {
            fc = builder.CreateFCmpOGT(l, r);
        } else if (op == "<=") {
            fc = builder.CreateFCmpOLE(l, r);
        } else if (op == ">=") {
            fc = builder.CreateFCmpOGE(l, r);
        }
        if (fc != nullptr) {
            return builder.CreateZExt(fc, builder.getInt32Ty());
        }
        error("unsupported float operator '" + op + "'", bin.loc);
        return nullptr;
    }
    // Pointer path: == / != on pointers (incl. null) compares addresses directly,
    // skipping integer promotion (which would try to cast a pointer to int). A Java-style
    // enum value is a pointer to its singleton, so identity comparison is its equality.
    auto isPtrish = [this](const std::string& t) {
        // A class instance is a pointer in codegen, so == / != on class references is identity
        // comparison (the basis of Object.equals). Pointers, refs, null and java-enums too. A
        // nullable primitive is boxed as a pointer (spec 3.7), so it compares as a pointer as well
        // (this is what makes `nullable int x = ...; x == null` work).
        if (t == "null" || (!t.empty() && (t.back() == '*' || t.back() == '&'))) {
            return true;
        }
        if (ast::typeIsNullable(t) && isBoxablePrimitive(ast::stripNullable(t))) {
            return true;
        }
        // An array is a pointer to its heap block, so == / != is identity comparison (like any
        // reference). Without this it falls through to the integer path, which fitInt()s the block
        // pointer as an integer and crashes codegen.
        if (isArrayType(t)) {
            return true;
        }
        return javaEnums.count(baseType(t)) > 0 || classes.count(baseType(t)) > 0;
    };
    const bool javaEnumCmp = javaEnums.count(baseType(lt)) > 0 || javaEnums.count(baseType(rt)) > 0;
    if (javaEnumCmp && op != "==" && op != "!=") {
        // Order Java-style enums by ordinal (declaration order), matching Java's compareTo. Both
        // sides are the same enum for a well-typed program; recover each value's ordinal from its
        // singleton identity and compare those.
        const std::string en = javaEnums.count(baseType(lt)) > 0 ? baseType(lt) : baseType(rt);
        llvm::Value* oa = emitJavaEnumOrdinal(l, en);
        llvm::Value* ob = emitJavaEnumOrdinal(r, en);
        llvm::Value* cmp = nullptr;
        if (op == "<") {
            cmp = builder.CreateICmpSLT(oa, ob);
        } else if (op == ">") {
            cmp = builder.CreateICmpSGT(oa, ob);
        } else if (op == "<=") {
            cmp = builder.CreateICmpSLE(oa, ob);
        } else if (op == ">=") {
            cmp = builder.CreateICmpSGE(oa, ob);
        }
        if (cmp != nullptr) {
            return builder.CreateZExt(cmp, builder.getInt32Ty());
        }
        error("unsupported comparison '" + op + "' on Java-style enum values", bin.loc);
        return nullptr;
    }
    if ((op == "==" || op == "!=") && (isPtrish(lt) || isPtrish(rt))) {
        llvm::Value* cmp = (op == "==") ? builder.CreateICmpEQ(l, r)
                                        : builder.CreateICmpNE(l, r);
        return builder.CreateZExt(cmp, builder.getInt32Ty());
    }
    // Integer path: promote both operands to the wider bit width. If either side is unsigned the
    // OPERATION is unsigned (udiv/urem, unsigned comparisons) -- but each operand is widened by ITS
    // OWN signedness, which is a different question.
    //
    // Widening both by the result's signedness silently changed the VALUE of a narrower signed
    // operand: `someAddress & (0 - 4096)` zero-extended the int -4096 to 0x00000000FFFFF000, so a
    // 64-bit address mask quietly masked 32 bits and dropped everything above 4 GiB. That cost real
    // debugging time in the pico kernel, where a PE image at ImageBase 0x140000000 was mapped at
    // 0x40000000. Sign-extending a signed operand is the value-preserving conversion, and it is
    // already what the explicit-cast path does (see castInt, which uses isUnsigned(from)) -- so this
    // also removes a disagreement between `cast<address>(i)` and `addr & i` inside one compiler.
    // ---- MEASUREMENT PROBE (POLARON_MIXED_INT=1): how much would it cost to REQUIRE an explicit cast
    // when two DIFFERENT integer types meet? Reports every site that a rule change would break, split
    // by whether the narrower side is a constant expression built only from literals (which an
    // "untyped literals adapt to context" rule would keep legal) or a real value (which it would not).
    // Off by default and free then. Delete once the decision is made.
    if (isIntName(lt) && isIntName(rt) && lt != rt) {
        static const bool probe = std::getenv("POLARON_MIXED_INT") != nullptr;
        if (probe) {
            const bool lLit = isLiteralOnlyExpr(*bin.lhs);
            const bool rLit = isLiteralOnlyExpr(*bin.rhs);
            std::fprintf(stderr, "[mixed] %s %.*s:%d  %s %s %s\n",
                         (lLit || rLit) ? "LITERAL" : "VALUE  ",
                         static_cast<int>(bin.loc.file.size()), bin.loc.file.data(), bin.loc.line,
                         lt.c_str(), op.c_str(), rt.c_str());
        }
    }
    const unsigned w = std::max(intBits(lt), intBits(rt));
    const bool uns = isUnsigned(lt) || isUnsigned(rt);
    l = fitInt(l, w, isUnsigned(lt));
    r = fitInt(r, w, isUnsigned(rt));
    if (op == "+" || op == "-" || op == "*") {
        // Integer arithmetic wraps by default (modular, zero-overhead -- overflow checking inhibits
        // the recursive-inline and loop optimizers, ~10x on hot arithmetic). Opt into trap-on-overflow
        // per expression with `checked(...)`.
        //
        // `checked()` used to be dropped SILENTLY for unsigned operands and in freestanding mode --
        // so the one safety opt-in the language offers disappeared exactly where a kernel wants it,
        // and unsigned wrap-around went unchecked even when asked for. Neither exclusion was
        // necessary: unsigned overflow has its own detection (carry/borrow, umul) and freestanding
        // already has `__polaron_panic`, which is where contracts and checked downcasts land there.
        if (checkedArith_) {
            return emitCheckedIntArith(op, l, r, uns);
        }
        if (op == "+") {
            return builder.CreateAdd(l, r);
        }
        if (op == "-") {
            return builder.CreateSub(l, r);
        }
        return builder.CreateMul(l, r);
    }
    if (op == "/") {
        return emitIntDivRem(l, r, uns, /*rem=*/false);
    }
    if (op == "%") {
        return emitIntDivRem(l, r, uns, /*rem=*/true);
    }
    if (op == "&") {
        return builder.CreateAnd(l, r);
    }
    if (op == "|") {
        return builder.CreateOr(l, r);
    }
    if (op == "^") {
        return builder.CreateXor(l, r);
    }
    if (op == "<<" || op == ">>") {
        // Shifts are TOTAL in Polaron -- no UB, so no optimizer can ever exploit an "impossible" count.
        // A count >= the operand's bit width shifts every bit out: the result is 0 (left shift, or an
        // unsigned right shift) or the sign fill (a signed right shift). The shl/lshr/ashr these lower
        // to are poison when the count >= width, so we guard. The common case -- a constant, in-range
        // count -- emits a bare shift (zero overhead); only a runtime count pays for the range check.
        const bool left = (op == "<<");
        auto doShift = [&](llvm::Value* amt) -> llvm::Value* {
            if (left) {
                return builder.CreateShl(l, amt);
            }
            return uns ? builder.CreateLShr(l, amt) : builder.CreateAShr(l, amt);
        };
        llvm::Value* over = (left || uns)
            ? llvm::cast<llvm::Value>(llvm::ConstantInt::get(l->getType(), 0))
            : builder.CreateAShr(l, llvm::ConstantInt::get(l->getType(), w - 1));  // all sign bits
        if (auto* c = llvm::dyn_cast<llvm::ConstantInt>(r)) {
            return c->getValue().uge(w) ? over : doShift(r);
        }
        llvm::Value* inRange = builder.CreateICmpULT(r, llvm::ConstantInt::get(r->getType(), w));
        llvm::Value* safe =
            builder.CreateSelect(inRange, r, llvm::ConstantInt::get(r->getType(), 0));
        return builder.CreateSelect(inRange, doShift(safe), over);
    }

    llvm::Value* cmp = nullptr;
    if (op == "==") {
        cmp = builder.CreateICmpEQ(l, r);
    } else if (op == "!=") {
        cmp = builder.CreateICmpNE(l, r);
    } else if (op == "<") {
        cmp = uns ? builder.CreateICmpULT(l, r) : builder.CreateICmpSLT(l, r);
    } else if (op == ">") {
        cmp = uns ? builder.CreateICmpUGT(l, r) : builder.CreateICmpSGT(l, r);
    } else if (op == "<=") {
        cmp = uns ? builder.CreateICmpULE(l, r) : builder.CreateICmpSLE(l, r);
    } else if (op == ">=") {
        cmp = uns ? builder.CreateICmpUGE(l, r) : builder.CreateICmpSGE(l, r);
    }
    if (cmp != nullptr) {
        return builder.CreateZExt(cmp, builder.getInt32Ty());
    }

    error("unsupported binary operator '" + op + "'", bin.loc);
    return nullptr;
}

llvm::Value* CodeGenerator::Impl::emitNew(const ast::NewExpr& nw) {
    // Value Result/Option (spec 21, value form): Ok/Err/Some/None with location "value" build a
    // { i32 tag, i64 payload } directly -- no allocation, no class, no delete. tag 0 = Ok/Some,
    // 1 = Err/None. The payload is packed from the single arg (None carries none).
    if (nw.location == "value") {
        const int tag = (nw.className == "Ok" || nw.className == "Some") ? 0 : 1;
        llvm::Value* payload = builder.getInt64(0);
        if (!nw.args.empty()) {
            llvm::Value* a = emitExpr(*nw.args[0]);
            if (a == nullptr) {
                return nullptr;
            }
            // The value form packs the payload into 64 bits. Name-based detection keeps Decimal/tuple/
            // pointer payloads boxed upstream, but a value-`struct` payload can't be told apart by name,
            // so guard it here with a clear error rather than a silent truncation or a crash.
            if (a->getType()->isAggregateType() ||
                (a->getType()->isIntegerTy() && a->getType()->getIntegerBitWidth() > 64)) {
                error("a value Result/Option of this payload type is not supported yet; use the boxed "
                      "form (write the type with a '*')",
                      nw.loc);
                return nullptr;
            }
            payload = variantEncode(a);
        }
        llvm::Value* agg = llvm::UndefValue::get(variantStructType());
        agg = builder.CreateInsertValue(agg, builder.getInt32(tag), {0u}, "var.tag");
        agg = builder.CreateInsertValue(agg, payload, {1u}, "var.val");
        return agg;
    }
    // Box<int> -> Box$int, and then through the one funnel: `new Scanner()` in a program that also
    // has a standard-library Scanner has to build the one whose name the author's namespace and
    // imports point at, not whichever was declared first.
    const std::string cn = clsKey(ast::mangleGeneric(nw.className, nw.typeArgs));
    auto cit = classes.find(cn);
    if (cit == classes.end()) {
        error("unknown class '" + cn + "'", nw.loc);
        return nullptr;
    }
    // Opaque cross-bundle creation: an imported class's full layout is not known here, so the
    // bundle's exported __new mallocs the real size and runs the constructor (spec: F9 opaque).
    if (cit->second.imported) {
        llvm::Function* nf = functions.count(cn + ".__new") ? functions[cn + ".__new"] : nullptr;
        if (nf == nullptr) {
            error("cannot construct imported class '" + cn + "' (no exported constructor)", nw.loc);
            return nullptr;
        }
        if (nw.location == "stack") {
            error("an imported class is heap-only across a bundle boundary; use 'on heap'", nw.loc);
            return nullptr;
        }
        std::vector<llvm::Value*> args;
        for (std::size_t i = 0; i < nw.args.size(); ++i) {
            llvm::Value* v = emitExpr(*nw.args[i]);
            if (v == nullptr) {
                return nullptr;
            }
            if (i < nf->arg_size()) {
                v = coerceToType(v, nf->getArg(i)->getType());
            }
            args.push_back(v);
        }
        return builder.CreateCall(nf, args, cn + ".new");
    }
    emitAliveGuard(cn);  // spec 30: instantiating an unimported type throws
    // `lazy import` (spec 37.3): run the class's onClassLoad on its first instance, once.
    if (cit->second.decl != nullptr && cit->second.decl->onClassLoad && isLazyImport(cn)) {
        llvm::GlobalVariable* flag = lazyLoadFlag(cn);
        llvm::Function* fn = currentFn;
        auto* loadBB = llvm::BasicBlock::Create(context, "lazyload." + cn, fn);
        auto* contBB = llvm::BasicBlock::Create(context, "lazyload.cont", fn);
        llvm::Value* done = builder.CreateLoad(builder.getInt1Ty(), flag, "loaded");
        builder.CreateCondBr(done, contBB, loadBB);
        builder.SetInsertPoint(loadBB);
        builder.CreateCall(functions[cn + ".__onClassLoad"]);
        builder.CreateStore(builder.getInt1(true), flag);
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
    }
    llvm::Value* objPtr = nullptr;
    const bool regionClass = cit->second.decl != nullptr && cit->second.decl->isRegionClass;
    if (regionClass) {
        // A region class ignores the `on heap` / stack question entirely: there is exactly ONE
        // place its instances can be. Note this also takes the DEFAULT `new A()`, which for any
        // other class is a stack object with scope-exit destruction. A region class trades that
        // away, and that is the price of the guarantee rather than an oversight: one instance left
        // on the stack and an `A*` could point at it, which closes the narrow pointer for good.
        if (!nw.region.empty()) {
            error("`" + cn + "` is a `region class`, so every instance comes from its own region -- "
                  "`in region " + nw.region + "` would put one somewhere else, and the guarantee "
                  "that makes a region class worth having is that there is nowhere else",
                  nw.loc);
            return nullptr;
        }
        // `on heap` is REFUSED rather than ignored. Accepting it and quietly allocating from the
        // region anyway would be the worst of the three: the author wrote a placement, the compiler
        // did something else, and nothing said so. Obeying it would be worse still -- one instance
        // outside the region ends the totality that unimport's O(1) liveness, the linear walk over
        // every instance, and the eventual 32-bit `A*` all rest on.
        if (nw.location == "heap") {
            error("`" + cn + "` is a `region class`, so `on heap` has nowhere to put this -- every "
                  "instance comes from the type's own region, and that is the whole guarantee. "
                  "Write `new " + cn + "(...)` with no placement",
                  nw.loc);
            return nullptr;
        }
        // `on stack` gets the same refusal, and it has to be asked for separately because the DEFAULT
        // is "stack" -- silence and the written word arrive here identical unless the parser says
        // which it was. Letting the written one through would be the case this refusal exists to
        // prevent: the author states a placement, the compiler does something else, and nothing says
        // so. It is also the placement that would do the most damage, since a stack `A` is what makes
        // a narrow `A*` point outside the arena.
        if (nw.locationWritten) {
            error("`" + cn + "` is a `region class`, so `on " + nw.location + "` has nowhere to put "
                  "this -- every instance comes from the type's own region, and a region class is "
                  "worth having precisely because there is nowhere else. Write `new " + cn +
                  "(...)` with no placement",
                  nw.loc);
            return nullptr;
        }
        objPtr = classArenaAlloc(cn, sizeOf(cit->second.type));
    } else if (!nw.region.empty()) {
        objPtr = multiRegionRanges_.count(nw.region) > 0
                     ? emitMultiRegionAlloc(nw.region, cn, cit->second.type, nw.loc)
                     : emitRegionAlloc(nw.region, cit->second.type, nw.loc);
        if (objPtr == nullptr) {
            return nullptr;
        }
    } else if (nw.location == "stack") {
        objPtr = createEntryAlloca(cn + ".obj", cit->second.type);
    } else if (nw.location == "heap") {
        objPtr = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, cn + ".obj");
    } else {
        error("'new' location must be 'stack' or 'heap', got '" + nw.location + "'", nw.loc);
        return nullptr;
    }
    // A VALUE STRUCT WITH NO CONSTRUCTOR STARTS AT ZERO, and it did not before.
    //
    // A class is safe without this: the analyzer refuses a constructor that leaves a field
    // unassigned, so every field of a class is written before anything can read it. A struct with
    // no declared constructor has no constructor to hold to that promise -- so `new Mind()` handed
    // back whatever was on the stack, and a bitmask of conditions read as a person with eleven of
    // them. Found in the first slice that used one (agents-exe S2.1): a fresh `Belonging` claimed
    // nationalities nobody had given it.
    //
    // Reading uninitialized memory is the no-UB principle's own case, so the fix is the plain one:
    // zero the storage. Only for a struct, and only when nothing else is going to write those bytes
    // -- a declared constructor is the author saying what the initial values are.
    if (cit->second.isStruct && !hasDeclaredConstructor(cn)) {
        builder.CreateCall(memsetFn(), {objPtr, builder.getInt32(0), sizeOf(cit->second.type)});
    }
    // Null the weak intrusive state (WeakSlot fields + weak-list head) BEFORE the constructor runs, so
    // a ctor that assigns a `weak T*` field unlinks from an empty (null) slot rather than garbage.
    initWeakState(objPtr, cn);
    // Wire up the persistent block (if any) BEFORE the constructor, so the ctor can read
    // and write this.<persistent field>. Keyed by the binding variable's identity.
    llvm::Value* persistBlockRef = nullptr;
    // A class WITH an identity keys its persistents by that identity, and the identity is only
    // complete once the constructor has assigned it. So the block cannot be chosen here: the ctor
    // writes into a zeroed scratch, and after it returns those bytes become the INITIAL state of a
    // first attach (a reattach ignores them and keeps what accumulated). Reading a persistent inside
    // such a constructor is rejected by the analyzer, because there is no identity to read from yet.
    //
    // Two shapes keep the older form, and both for the same reason -- they need the block BEFORE the
    // constructor, which is the opposite order:
    //
    //   * a PARTIAL constructor (spec 18.9), whose omitted parameters take their values FROM the
    //     block, so it must already be attached when the ctor runs;
    //   * `arr[i] = new T()`, where the programmer named an explicit slot identity, which beats an
    //     implicit one derived from the fields.
    std::vector<const ast::FieldDecl*> keyFields;
    if (cit->second.persistPtrIdx != 0 && pendingPersistIndex == nullptr) {
        bool partialCapable = false;
        if (cit->second.decl != nullptr) {
            for (const ast::MemberPtr& m : cit->second.decl->members) {
                if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
                    for (const ast::Param& p : c->params) {
                        if (std::find(cit->second.persistOrder.begin(), cit->second.persistOrder.end(),
                                      p.name) != cit->second.persistOrder.end()) {
                            partialCapable = true;
                        }
                    }
                    break;
                }
            }
        }
        if (!partialCapable) {
            keyFields = keyFieldsOf(cn);
        }
    }
    llvm::Value* keyedScratch = nullptr;
    if (cit->second.persistPtrIdx != 0 && !keyFields.empty()) {
        llvm::Value* sz = sizeOf(cit->second.persistBlock);
        keyedScratch = builder.CreateAlloca(cit->second.persistBlock, nullptr, "__persist.init");
        emitMemset(keyedScratch, builder.getInt32(0), sz);
        builder.CreateStore(keyedScratch,
                            builder.CreateStructGEP(cit->second.type, objPtr,
                                                    cit->second.persistPtrIdx, "__persist"));
        pendingPersistKey.clear();
        pendingPersistIndex = nullptr;
    } else if (cit->second.persistPtrIdx != 0) {
        if (pendingPersistIndex != nullptr && !pendingPersistKey.empty()) {
            // Index-keyed reattach (spec 18.5): `arr[i] = new T()`. A runtime registry keyed by
            // (array identity, index) returns the same block for the same slot across a delete, so
            // the object's persistent fields survive delete+recreate at that index.
            llvm::Value* keyStr = createGlobalStringPtr(builder,pendingPersistKey, "pkey");
            llvm::Value* idx64 =
                builder.CreateSExtOrTrunc(pendingPersistIndex, builder.getInt64Ty(), "pidx");
            persistBlockRef = builder.CreateCall(
                persistSlotFn(), {keyStr, idx64, sizeOf(cit->second.persistBlock)},
                "__persist.slot");
        } else if (!pendingPersistKey.empty()) {
            persistBlockRef = getPersistBlock(pendingPersistKey, cit->second.persistBlock);
        } else {
            // No name binding (e.g. a temporary): give the object its own zeroed persistent block
            // so its persistent fields are usable instead of leaving the __persist pointer wild (a
            // segfault on first access). No reattach identity for a bare temporary.
            llvm::Value* sz = sizeOf(cit->second.persistBlock);
            persistBlockRef = builder.CreateCall(mallocFn(), {sz}, "__persist.anon");
            emitMemset(persistBlockRef, builder.getInt32(0), sz);
        }
        llvm::Value* slot = builder.CreateStructGEP(cit->second.type, objPtr,
                                                    cit->second.persistPtrIdx, "__persist");
        builder.CreateStore(persistBlockRef, slot);
        pendingPersistKey.clear();
        pendingPersistIndex = nullptr;
    }
    // A BOUND TARGET IS STORAGE, and no constructor of its own runs over it. That is the whole
    // difference between `entrusts` and ordinary construction: the type has handed the establishing
    // of its invariants to the procedure that binds it, and running its own constructor first would
    // mean the body was mutating a finished object instead of building one. Nothing is skipped
    // silently -- the analyzer proves every field is assigned before the body ends, which is the
    // same obligation a constructor carries and the reason this is safe.
    auto fnit = nw.blank ? functions.end() : functions.find(ctorSym(cn));
    if (fnit != functions.end()) {
        std::vector<llvm::Value*> args;
        args.push_back(objPtr);
        // Partial constructor (spec 18.9): when fewer args are given than the ctor has
        // parameters, the provided args fill the non-persistent parameters in order, and
        // each parameter whose name matches a persistent field takes its value from the
        // persistent block (the reattached value), rather than being passed in.
        const ast::ConstructorDecl* ctor = nullptr;
        if (cit->second.decl != nullptr) {
            for (const ast::MemberPtr& m : cit->second.decl->members) {
                if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) { ctor = c; break; }
            }
        }
        const auto& porder = cit->second.persistOrder;
        const bool partial =
            ctor != nullptr && persistBlockRef != nullptr && nw.args.size() < ctor->params.size();
        if (partial) {
            std::size_t provided = 0;
            for (std::size_t pi = 0; pi < ctor->params.size(); ++pi) {
                const std::string& pname = ctor->params[pi].name;
                auto pp = std::find(porder.begin(), porder.end(), pname);
                llvm::Value* v = nullptr;
                if (pp != porder.end()) {  // persistent-matching param: read from the block
                    const auto fidx = static_cast<unsigned>(pp - porder.begin());
                    llvm::Value* fp = builder.CreateStructGEP(cit->second.persistBlock,
                                                              persistBlockRef, fidx, pname);
                    v = builder.CreateLoad(llvmType(cit->second.fieldType[pname]), fp, pname);
                } else if (provided < nw.args.size()) {  // non-persistent: next provided arg
                    v = emitExpr(*nw.args[provided++]);
                } else {
                    v = llvm::Constant::getNullValue(fnit->second->getArg(pi + 1)->getType());
                }
                if (v == nullptr) {
                    return nullptr;
                }
                if (pi + 1 < fnit->second->arg_size()) {
                    v = coerceToType(v, fnit->second->getArg(pi + 1)->getType());
                }
                args.push_back(v);
            }
        }
        std::vector<std::pair<std::size_t, std::string>> freeAfter;  // owned `new` ctor args
        if (!partial) {
            for (std::size_t i = 0; i < nw.args.size(); ++i) {
                llvm::Value* v = emitExpr(*nw.args[i]);
                if (v == nullptr) {
                    return nullptr;
                }
                // to what the ctor DECLARED, not merely its param width
                v = coerceArg(v, typeName(*nw.args[i]), fnit->second, i + 1);
                args.push_back(v);
                if (ctor != nullptr && i < ctor->params.size()) {
                    if (std::string acn = ownedHeapNewArg(*nw.args[i], typeRefName(ctor->params[i].type));
                        !acn.empty()) {
                        freeAfter.emplace_back(i + 1, acn);
                    }
                }
            }
        }
        emitMaybeInvoke(fnit->second, args);
        for (const auto& [idx, acn] : freeAfter) {
            emitDeleteObject(args[idx], acn);
        }
    }
    // The identity is complete now, so the keyed block can be chosen. The scratch the constructor
    // wrote into is handed over as the INITIAL state: the registry copies it only when it creates
    // the block, so a first attach starts from it and a reattach keeps what it accumulated.
    if (keyedScratch != nullptr) {
        auto [kb, kn] = emitKeyBytes(cn, objPtr);
        llvm::Value* block = builder.CreateCall(
            persistSlotKeyedFn(),
            {createGlobalStringPtr(builder, cn, "pcls"), kb, kn,
             sizeOf(cit->second.persistBlock), keyedScratch},
            "__persist.keyed");
        builder.CreateStore(block, builder.CreateStructGEP(cit->second.type, objPtr,
                                                           cit->second.persistPtrIdx, "__persist"));
    }
    // A region with a registry records each constructed object that needs teardown, so
    // `rollback`/`release` can run it newest-first -- the runtime registry, not scopeObjects, owns
    // them. That is what makes teardown complete for a FIELD region, whose objects are put there by
    // methods the releasing scope never sees.
    if (!nw.region.empty() && (cit->second.hasDestructor || weakRelevant(cn)) &&
        regionHasRegistry(nw.region)) {
        if (llvm::Function* dtor = regionDtorFn(cn)) {
            llvm::Value* block =
                builder.CreateLoad(builder.getPtrTy(), regionStorageSlot(nw.region), "region");
            builder.CreateCall(regionTrackFn(), {block, objPtr, dtor});
        }
    }
    return objPtr;
}

}  // namespace polaron
