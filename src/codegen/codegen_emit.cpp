#include "codegen/codegen_impl.h"

namespace polaron {

std::string CodeGenerator::Impl::catalogImplementerEnum(const std::string& catalog, const std::string& method) {
    for (const auto& [enumName, decl] : enumMethodDecls) {
        for (const std::string& c : decl->extendsCatalogs) {
            if (baseType(c) == catalog && functions.count(enumName + "." + method) > 0) {
                return enumName;
            }
        }
    }
    for (const auto& [enumName, decl] : javaEnums) {
        for (const std::string& c : decl->extendsCatalogs) {
            if (baseType(c) == catalog && functions.count(enumName + "." + method) > 0) {
                return enumName;
            }
        }
    }
    return "";
}

std::vector<std::string> CodeGenerator::Impl::catalogImplEnums(const std::string& catalog) {
    std::vector<std::string> out;
    for (const auto& [enumName, decl] : enumMethodDecls) {
        for (const std::string& c : decl->extendsCatalogs) {
            if (baseType(c) == catalog) { out.push_back(enumName); break; }
        }
    }
    for (const auto& [enumName, decl] : javaEnums) {
        for (const std::string& c : decl->extendsCatalogs) {
            if (baseType(c) == catalog) { out.push_back(enumName); break; }
        }
    }
    std::sort(out.begin(), out.end(), [&](const std::string& a, const std::string& b) {
        return enumTypeId[a] < enumTypeId[b];
    });
    return out;
}

bool CodeGenerator::Impl::isTaggedCatalog(const std::string& name) {
    if (catalogNames.count(name) == 0) {
        return false;
    }
    for (const auto& [enumName, decl] : enumMethodDecls) {
        for (const std::string& c : decl->extendsCatalogs) {
            if (baseType(c) == name) {
                return true;
            }
        }
    }
    for (const auto& [enumName, decl] : javaEnums) {
        for (const std::string& c : decl->extendsCatalogs) {
            if (baseType(c) == name) {
                return true;
            }
        }
    }
    return false;
}

std::string CodeGenerator::Impl::chooseLiteralKey(const std::string& name, const std::string& argType) {
    auto it = literalSuffixParams.find(name);
    if (it == literalSuffixParams.end() || it->second.empty()) {
        return "";
    }
    for (const std::string& p : it->second) {
        if (p == argType) {
            return name + "$" + p;
        }
    }
    return name + "$" + it->second[0];
}

llvm::Function* CodeGenerator::Impl::emitCallbackFn(const ast::LambdaExpr& lam) {
    if (!lam.captures.empty()) {
        error("a capturing lambda cannot be passed as a C callback; use a capture-free lambda "
              "(spec 26)",
              lam.loc);
        return nullptr;
    }
    std::vector<llvm::Type*> pts;
    for (const auto& p : lam.params) {
        pts.push_back(llvmType(typeRefName(p.type)));
    }
    llvm::Type* rt = llvmType(typeRefName(lam.returnType));
    llvm::Function* fn = llvm::Function::Create(
        llvm::FunctionType::get(rt, pts, false), llvm::Function::InternalLinkage,
        "__polaron_cb_" + std::to_string(lambdaCounter++), module);
    // emitBody clobbers function-local state -- save and restore it (mirrors the lambda path).
    auto sFn = currentFn; auto sCls = currentClass; auto sRet = currentRetType; auto sRetN = currentRetTypeName_;
    auto sEns = currentEnsures; auto sInv = currentInvariants; auto sThis = currentThis;
    auto sInvA = currentInvariantsToAssume;
    auto sLoc = locals; auto sScope = scopeObjects; auto sDef = deferred;
    auto sRegions = scopeRegions; auto sDtorChain = currentDtorChain; auto sOld = oldValues_;
    auto sStr = scopeStrings; auto sTmp = stringTemps;  // String RAII: nested body gets its own set
    auto sVals = scopeValueStructs;
    scopeStrings.clear(); stringTemps.clear(); scopeValueStructs.clear();
    auto sIP = builder.saveIP();
    auto sSelf = currentLambdaFn_; auto sSelfEnv = currentLambdaHasEnv_;
    currentLambdaFn_ = fn; currentLambdaHasEnv_ = false;   // a C callback takes no environment arg
    emitBody(fn, lam.body, lam.params, "", rt, nullptr, nullptr, nullptr, nullptr,
             /*hasEnv=*/false);
    currentLambdaFn_ = sSelf; currentLambdaHasEnv_ = sSelfEnv;
    currentFn = sFn; currentClass = sCls; currentRetType = sRet; currentRetTypeName_ = sRetN;
    currentEnsures = sEns; currentInvariants = sInv; currentThis = sThis;
    currentInvariantsToAssume = sInvA;
    currentDtorChain = sDtorChain; oldValues_ = sOld;
    locals = sLoc; scopeObjects = sScope; deferred = sDef; scopeRegions = sRegions;
    scopeStrings = sStr; stringTemps = sTmp; scopeValueStructs = sVals;
    builder.restoreIP(sIP);
    return fn;
}

llvm::Value* CodeGenerator::Impl::emitOptionVariant(const std::string& variant, const std::string& en, int ordinal) {
    ast::NewExpr nw;
    nw.className = variant;  // "Some" / "None"
    nw.typeArgs = {en};
    nw.location = "value";
    if (ordinal >= 0) {
        auto lit = std::make_unique<ast::IntLiteralExpr>();
        lit->text = std::to_string(ordinal);
        nw.args.push_back(std::move(lit));
    }
    return emitNew(nw);
}

llvm::Value* CodeGenerator::Impl::emitShortCircuit(const ast::BinaryExpr& bin) {
    llvm::Value* a = emitExpr(*bin.lhs);
    if (a == nullptr) {
        return nullptr;
    }
    // DELIBERATELY the full compare, NOT `asI1`. The left side of an `&&` is nearly always a
    // comparison arriving as `zext i1 to i32`, so stripping the zext here looks free -- and it is
    // not: tried 2026-08-12, it took the mandelbrot benchmark from 717.9 ms to 804.4 ms, a 12%
    // REGRESSION, while the suite stayed 714/714. Short-circuit lowering feeds a phi at `sc.end`,
    // and the i32 form is what the backend wants there. `asI1` is right for a branch condition
    // (see the `if`/`while`/`for` sites); it is wrong here.
    a = builder.CreateICmpNE(a, llvm::Constant::getNullValue(a->getType()), "sc.a");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* startBB = builder.GetInsertBlock();
    llvm::BasicBlock* rhsBB = llvm::BasicBlock::Create(context, "sc.rhs", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "sc.end", fn);
    const bool isAnd = (bin.op == "&&");
    builder.CreateCondBr(a, isAnd ? rhsBB : endBB, isAnd ? endBB : rhsBB);
    builder.SetInsertPoint(rhsBB);
    llvm::Value* b = emitExpr(*bin.rhs);
    if (b == nullptr) {
        return nullptr;
    }
    b = builder.CreateICmpNE(b, llvm::Constant::getNullValue(b->getType()), "sc.b");
    llvm::BasicBlock* rhsEnd = builder.GetInsertBlock();
    builder.CreateBr(endBB);
    builder.SetInsertPoint(endBB);
    llvm::PHINode* phi = builder.CreatePHI(builder.getInt1Ty(), 2, "sc");
    phi->addIncoming(builder.getInt1(!isAnd), startBB);  // && short-circuits to false, || to true
    phi->addIncoming(b, rhsEnd);
    return builder.CreateZExt(phi, builder.getInt32Ty());
}

llvm::Value* CodeGenerator::Impl::emitSafeNav(const ast::Expr& node, const ast::Expr& receiver) {
    llvm::Value* recv = emitExpr(receiver);
    if (recv == nullptr) {
        return nullptr;
    }
    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
    llvm::Function* fn = currentFn;
    llvm::BasicBlock* entryBB = builder.GetInsertBlock();
    auto* liveBB = llvm::BasicBlock::Create(context, "safe.live", fn);
    auto* contBB = llvm::BasicBlock::Create(context, "safe.cont", fn);
    builder.CreateCondBr(builder.CreateICmpNE(recv, nullp), liveBB, contBB);
    builder.SetInsertPoint(liveBB);
    const ast::Expr* prev = safeGuardNode_;
    safeGuardNode_ = &node;  // suppress this node's guard on the re-emit (nested ?. still guard)
    llvm::Value* val = emitExpr(node);
    safeGuardNode_ = prev;
    if (val == nullptr) {
        return nullptr;
    }
    if (!val->getType()->isPointerTy()) {
        val = nullp;  // ?. yields a reference value
    }
    llvm::BasicBlock* liveEnd = builder.GetInsertBlock();
    builder.CreateBr(contBB);
    builder.SetInsertPoint(contBB);
    llvm::PHINode* phi = builder.CreatePHI(builder.getPtrTy(), 2, "safe");
    phi->addIncoming(nullp, entryBB);
    phi->addIncoming(val, liveEnd);
    return phi;
}

llvm::Value* CodeGenerator::Impl::emitNullCoalesce(const ast::NullCoalesceExpr& nc) {
    // For a nullable primitive `x ?? d`, x is a boxed pointer: unbox it on the non-null branch and
    // yield the inner primitive (matching d's type). For a nullable reference, the value is the
    // pointer itself and passes through.
    const std::string lt = typeName(*nc.lhs);
    const bool nullablePrim =
        ast::typeIsNullable(lt) && isBoxablePrimitive(ast::stripNullable(lt));
    const std::string inner = nullablePrim ? ast::stripNullable(lt) : std::string();
    llvm::Value* a = emitExpr(*nc.lhs);
    if (a == nullptr) {
        return nullptr;
    }
    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
    llvm::Function* fn = currentFn;
    auto* thenBB = llvm::BasicBlock::Create(context, "coalesce.then", fn);
    auto* elseBB = llvm::BasicBlock::Create(context, "coalesce.else", fn);
    auto* contBB = llvm::BasicBlock::Create(context, "coalesce.cont", fn);
    builder.CreateCondBr(builder.CreateICmpNE(a, nullp), thenBB, elseBB);
    builder.SetInsertPoint(thenBB);
    llvm::Value* aVal = nullablePrim ? builder.CreateLoad(llvmType(inner), a, "nunbox") : a;
    llvm::BasicBlock* thenEnd = builder.GetInsertBlock();
    builder.CreateBr(contBB);
    builder.SetInsertPoint(elseBB);
    llvm::Value* b = emitExpr(*nc.rhs);
    if (b == nullptr) {
        b = nullp;
    }
    if (nullablePrim) {
        b = coerce(b, typeName(*nc.rhs), inner);
    }
    llvm::BasicBlock* elseEnd = builder.GetInsertBlock();
    builder.CreateBr(contBB);
    builder.SetInsertPoint(contBB);
    llvm::PHINode* phi =
        builder.CreatePHI(nullablePrim ? llvmType(inner) : builder.getPtrTy(), 2, "coalesce");
    phi->addIncoming(aVal, thenEnd);
    phi->addIncoming(b, elseEnd);
    return phi;
}

llvm::Value* CodeGenerator::Impl::emitTernary(const ast::TernaryExpr& t) {
    llvm::Value* c = emitExpr(*t.cond);
    if (c == nullptr) {
        return nullptr;
    }
    c = builder.CreateICmpNE(c, builder.getInt32(0), "tern.c");
    const std::string rt = ternaryType(t);
    llvm::Type* rty = llvmType(rt);
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "tern.then", fn);
    llvm::BasicBlock* elseBB = llvm::BasicBlock::Create(context, "tern.else", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "tern.end", fn);
    // A String-typed ternary: an owned producer in one arm (e.g. `cond ? path : path.substring(...)`)
    // is created in that arm's block, so the enclosing statement's freeStringTemps -- which only sees
    // the merge block -- would drop it and leak. Copy each arm to a fresh owned String and free the
    // arm's own producer temp there; the merge phi is then one uniformly-owned temp tracked in endBB.
    const bool ownedStr_ = (rt == "String");
    builder.CreateCondBr(c, thenBB, elseBB);
    builder.SetInsertPoint(thenBB);
    std::size_t tBefore = stringTemps.size();
    llvm::Value* tv = emitExpr(*t.thenExpr);
    if (tv != nullptr) {
        tv = coerce(tv, typeName(*t.thenExpr), rt);
    }
    if (ownedStr_ && tv != nullptr) {
        tv = emitStringCopy(tv);
        releaseArmStringTemps(tBefore);
    }
    llvm::BasicBlock* thenEnd = builder.GetInsertBlock();
    builder.CreateBr(endBB);
    builder.SetInsertPoint(elseBB);
    std::size_t eBefore = stringTemps.size();
    llvm::Value* ev = emitExpr(*t.elseExpr);
    if (ev != nullptr) {
        ev = coerce(ev, typeName(*t.elseExpr), rt);
    }
    if (ownedStr_ && ev != nullptr) {
        ev = emitStringCopy(ev);
        releaseArmStringTemps(eBefore);
    }
    llvm::BasicBlock* elseEnd = builder.GetInsertBlock();
    builder.CreateBr(endBB);
    builder.SetInsertPoint(endBB);
    if (tv == nullptr || ev == nullptr) {
        return tv != nullptr ? tv : ev;
    }
    llvm::PHINode* phi = builder.CreatePHI(rty, 2, "tern");
    phi->addIncoming(tv, thenEnd);
    phi->addIncoming(ev, elseEnd);
    return ownedStr_ ? ownedStr(phi) : static_cast<llvm::Value*>(phi);
}

bool CodeGenerator::Impl::isLiteralOnlyExpr(const ast::Expr& e) {
    if (dynamic_cast<const ast::IntLiteralExpr*>(&e) != nullptr) {
        return true;
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        return isLiteralOnlyExpr(*u->operand);
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        return isLiteralOnlyExpr(*b->lhs) && isLiteralOnlyExpr(*b->rhs);
    }
    return false;
}

llvm::Value* CodeGenerator::Impl::regionStorageSlot(const std::string& name) {
    const auto dot = name.find('.');
    if (dot == std::string::npos) {
        auto it = locals.find(name);
        return it == locals.end() ? nullptr : it->second.storage;
    }
    // THE QUALIFIER IS READ, WHICH IT WAS NOT.
    //
    // This took `name.substr(dot + 1)` and looked it up on the CURRENT receiver, whatever stood before
    // the dot. `new X in region Other.arena` therefore emitted a GEP into `this` at the index of a
    // same-named field of the caller's own class -- a different region, or a different field
    // altogether, with no diagnostic. A qualifier that is parsed and then discarded is worse than one
    // that is refused.
    const std::string qualifier = name.substr(0, dot);
    const std::string field = name.substr(dot + 1);

    // `Class.field`: a STATIC region field, whose storage is the class's global. These parse and were
    // then unusable -- the analyzer reported `unknown region field` for every one of them -- so a
    // program-wide arena with an owner's name on it could be declared and never used.
    if (qualifier != "this") {
        const std::string key = qualifier + "." + field;
        auto sg = staticGlobals.find(key);
        if (sg == staticGlobals.end()) {
            return nullptr;
        }
        // AND IT IS BUILT ON FIRST USE. The global is a null pointer until something asks for the
        // region; nothing else would ever fill it, so before this the field parsed, type-checked (once
        // the qualifier bug above was fixed) and then faulted on the first allocation.
        //
        // Lazily, and not from a static constructor, for the same reason `classRegionBlock` is lazy:
        // bare metal runs none. The flavor and size match a region class's arena, which is the other
        // region in the language with no lexical owner -- a `growable pool`, so a shared arena chains
        // another block instead of trapping when the first one fills.
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        auto* initBB = llvm::BasicBlock::Create(context, "srgn.init", fn);
        auto* contBB = llvm::BasicBlock::Create(context, "srgn.ready", fn);
        llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), sg->second, "srgn.cur");
        builder.CreateCondBr(builder.CreateIsNull(cur, "srgn.absent"), initBB, contBB);
        builder.SetInsertPoint(initBB);
        llvm::Value* cap = builder.getInt64(64 * 1024);
        llvm::Value* block = builder.CreateCall(
            regionAcquireFn(), {builder.CreateAdd(builder.getInt64(kRegionHdr), cap)}, "srgn.block");
        builder.CreateCall(regionInitFn(),
                           {block, builder.getInt64(flavorCode("pool")), cap, builder.getInt64(1)});
        builder.CreateStore(block, sg->second);
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
        return sg->second;   // the global IS the storage, and now it holds a live region
    }
    if (currentThis == nullptr || currentClass.empty()) {
        return nullptr;
    }
    auto cit = classes.find(currentClass);
    if (cit == classes.end()) {
        return nullptr;
    }
    auto fi = cit->second.fieldIndex.find(field);
    if (fi == cit->second.fieldIndex.end()) {
        return nullptr;
    }
    return builder.CreateStructGEP(cit->second.type, currentThis, fi->second, "rgn.field");
}

void CodeGenerator::Impl::setupOwnedRegionCursor(const std::string& name) {
    ownedRegions_.insert(name);
    auto it = regionCursorSlot_.find(name);
    llvm::Value* cur;
    if (it != regionCursorSlot_.end()) {
        cur = it->second;
    } else {
        cur = createEntryAlloca(name + "#cursor", builder.getInt64Ty());
        regionCursorSlot_[name] = cur;
    }
    builder.CreateStore(builder.getInt64(0), cur);
}

void CodeGenerator::Impl::markReceiver(llvm::Function* fn, const std::string& cls, bool isStatic) {
    // `this` IS ALWAYS A LIVE OBJECT OF ITS CLASS, and saying so is worth real time.
    //
    // Without it LLVM cannot speculate a load through the receiver, and speculation is what LICM
    // needs to hoist one out of a loop: a load is only movable above a branch if the address is known
    // dereferenceable. Read out of `HashMap.slotFor`'s probe loop before this existed:
    //
    //     while.body:
    //       %keys6    = load ptr, ptr %keys      ; the FIELD, reloaded every iteration
    //       %arr.len8 = load i64, ptr %keys6     ; the array's length header, likewise
    //       %oob      = icmp ugt i64 %arr.len8, %5
    //       br i1 %oob, label %idx.ok11, label %idx.bad10
    //
    // Two loads and a branch per probe, which `std::unordered_map` does not pay. The `used` array's
    // length, loaded in the entry block, WAS hoisted -- because the entry block always executes. The
    // difference was never the loop; it was whether the load could be moved.
    //
    // Both facts are true by construction rather than by analysis: a method is reached through an
    // object, and the object is at least as large as its class. `nonnull` and `dereferenceable` are
    // therefore statements about the language, not guesses about the program.
    if (isStatic || fn == nullptr || fn->arg_size() == 0) {
        return;
    }
    auto cit = classes.find(cls);
    if (cit == classes.end() || cit->second.type == nullptr || !cit->second.type->isSized()) {
        return;
    }
    fn->addParamAttr(0, llvm::Attribute::NonNull);
    fn->addParamAttr(0, llvm::Attribute::getWithDereferenceableBytes(
                            context, module.getDataLayout().getTypeAllocSize(cit->second.type)));
    // AND ITS ALIGNMENT, which is the half that was missing.
    //
    // LICM will only speculate a load out of a block that is not guaranteed to execute when the
    // address is dereferenceable AND ALIGNED -- `isDereferenceableAndAlignedPointer`. `dereferenceable`
    // alone says nothing about alignment, so the probe loop's `load ptr, ptr %keys` stayed inside the
    // loop and was reloaded on every iteration, while the load in the loop HEADER (guaranteed to
    // execute, so no speculation needed) was hoisted. That asymmetry in the emitted assembly is what
    // pointed here.
    //
    // The value is the class's own ABI alignment, taken from the data layout rather than assumed:
    // every object comes from the allocator, which returns memory aligned for any type it holds.
    fn->addParamAttr(0, llvm::Attribute::getWithAlignment(
                            context, module.getDataLayout().getABITypeAlign(cit->second.type)));
}

bool CodeGenerator::Impl::requireTargetFeature(const char* feature, const std::string& what,
                                               const SourceLocation& loc) {
    // ONE PLACE THAT ANSWERS "does this machine have that", so a program built for an old or a small
    // target is told what it cannot have, at the line that asked, instead of finding out at link time
    // from a symbol nobody wrote -- or, worse, at run time from a module that traps.
    //
    // The port's whole premise is that a target may be missing something (see
    // docs/design/porting-architectures.md): a 1990s machine has no SSE, a bare wasm module has no
    // threads. Refusing with a sentence is the agreed answer, not a silent lowering to nothing.
    const llvm::Triple tt(moduleTripleStr(module));
    const std::string arch = archFamily(tt.getArchName().str());
    if (std::strcmp(feature, "interrupt") == 0) {
        // AN INTERRUPT HANDLER IS AN X86 CALLING CONVENTION. `interrupt` lowers to `x86_intrcc`,
        // which LLVM implements for x86 and x86-64 and nowhere else -- the CPU pushes a specific
        // frame and the handler returns with `iret`, and no other architecture does either.
        //
        // Left ungated, the IR was emitted happily and clang's BACKEND died on it:
        //
        //     fatal error: error in backend: unsupported calling convention
        //     PLEASE submit a bug report to https://github.com/llvm/llvm-project/issues/
        //
        // No source line, no method name, and an invitation to file a bug against LLVM for something
        // this compiler chose. That is the exact shape of failure the port's feature gates exist to
        // replace: AArch64 and RISC-V have interrupt handling, but it is a different mechanism with a
        // different frame, so this is not a lowering we are missing -- it is one that does not exist.
        if (arch != "x86_64" && arch != "x86") {
            error("`interrupt` is an x86 calling convention and this target is " + tt.str() +
                      ". A handler declared this way expects the frame an x86 CPU pushes and returns "
                      "with `iret`; " + what +
                      " cannot be built for another architecture, which handles interrupts by a "
                      "different mechanism entirely. Build for x86, or write the handler for this "
                      "machine as a `naked` method with its own entry sequence",
                  loc);
            return false;
        }
    }
    if (std::strcmp(feature, "threads") == 0) {
        // wasm32-unknown-unknown is a SINGLE-THREADED machine. Threads there need the atomics and
        // bulk-memory proposals AND a host that hands the module a shared memory and spawns the
        // workers -- none of which the bare target has. Without this the calls to
        // `__polaron_thread_spawn` are emitted and the module simply has no such import.
        if (arch == "wasm") {
            error("threads are not available on " + tt.str() + ": a bare WebAssembly module runs on "
                  "one thread, and spawning needs the atomics and bulk-memory proposals plus a host "
                  "that provides the shared memory and the workers. " + what +
                      " has no meaning on this target -- build for a threaded target, or restructure "
                      "the work to run on the one thread wasm gives you",
                  loc);
            return false;
        }
    }
    return true;
}

std::string CodeGenerator::Impl::regionFamilyRoot(const std::string& cls) {
    std::string root = cls;
    for (;;) {
        auto it = classes.find(root);
        if (it == classes.end() || it->second.decl == nullptr) {
            return root;
        }
        const std::string parent = it->second.decl->superclass;
        if (parent.empty()) {
            return root;
        }
        auto pit = classes.find(parent);
        if (pit == classes.end() || pit->second.decl == nullptr ||
            !pit->second.decl->isRegionClass) {
            return root;   // the chain leaves the family here
        }
        root = parent;
    }
}

void CodeGenerator::Impl::emitSyscallStub(const std::string& clsName, const ast::MethodDecl& m) {
    const llvm::Triple tt(module.getTargetTriple());
    const bool linuxX64 = tt.getArch() == llvm::Triple::x86_64 && tt.isOSLinux();
    if (!linuxX64) {
        error("`extern syscall(...)` is available on Linux/x86-64 and this target is " +
                  tt.str() +
                  ". A syscall is the machine's own instruction with its own register contract, so "
                  "there is nothing here to port automatically: Windows publishes no stable syscall "
                  "ABI at all, and another architecture numbers and passes them differently",
              m.loc);
        return;
    }
    // A SYSCALL HAS NO RECEIVER. The kernel contract is a number and up to six registers; there is
    // no `this` anywhere in it, so a non-static declaration describes something that cannot exist.
    // Left unchecked it produced an LLVM verifier failure ("Incorrect number of arguments passed to
    // called function") at the end of the pipeline instead of a sentence here.
    if (!m.isStatic) {
        error("`extern syscall(...)` has no receiver -- the kernel contract is a number and up to "
              "six registers, with no room for a `this`. Declare '" + m.name + "' static",
              m.loc);
        return;
    }
    const long long number = std::strtoll(m.externConvention.substr(8).c_str(), nullptr, 10);
    if (m.params.size() > 6) {
        error("a syscall takes at most six arguments; '" + m.name + "' declares " +
                  std::to_string(m.params.size()),
              m.loc);
        return;
    }
    std::vector<llvm::Type*> pts;
    for (const auto& p : m.params) {
        pts.push_back(llvmType(typeRefName(p.type)));
    }
    llvm::Type* retTy = llvmType(typeRefName(m.returnType));
    llvm::FunctionType* fty = llvm::FunctionType::get(retTy->isVoidTy() ? builder.getInt64Ty() : retTy,
                                                      pts, false);
    const std::string sym = clsName + "." + m.name;
    llvm::Function* fn = llvm::Function::Create(fty, llvm::Function::InternalLinkage, sym, module);
    functions[sym] = fn;
    externReturnType[sym] = typeRefName(m.returnType);

    llvm::BasicBlock* saveBlock = builder.GetInsertBlock();
    auto* entry = llvm::BasicBlock::Create(context, "entry", fn);
    builder.SetInsertPoint(entry);

    // Argument registers in kernel order, taken only as far as the method declares.
    static const char* kArgRegs[6] = {"{di}", "{si}", "{dx}", "{r10}", "{r8}", "{r9}"};
    std::string cons = "={ax},{ax}";
    std::vector<llvm::Type*> asmArgTys{builder.getInt64Ty()};
    std::vector<llvm::Value*> asmArgs{builder.getInt64(number)};
    for (std::size_t i = 0; i < m.params.size(); ++i) {
        cons += ",";
        cons += kArgRegs[i];
        llvm::Value* a = fn->getArg(static_cast<unsigned>(i));
        asmArgs.push_back(builder.CreateZExtOrTrunc(a, builder.getInt64Ty()));
        asmArgTys.push_back(builder.getInt64Ty());
    }
    cons += ",~{rcx},~{r11},~{memory}";
    llvm::FunctionType* asmTy = llvm::FunctionType::get(builder.getInt64Ty(), asmArgTys, false);
    llvm::InlineAsm* ia = llvm::InlineAsm::get(asmTy, "syscall", cons, /*hasSideEffects=*/true,
                                               /*isAlignStack=*/false, llvm::InlineAsm::AD_ATT);
    llvm::Value* r = builder.CreateCall(ia, asmArgs, "sys");
    if (retTy->isVoidTy()) {
        builder.CreateRet(r);
    } else {
        builder.CreateRet(builder.CreateZExtOrTrunc(r, retTy));
    }
    if (saveBlock != nullptr) {
        builder.SetInsertPoint(saveBlock);
    }
}

llvm::Value* CodeGenerator::Impl::classRegionBlock(const std::string& cls) {
    // ONE CONTIGUOUS RESERVATION, NOT A CHAIN OF BLOCKS.
    //
    // This was a `growable pool`: 64 KiB to start, chaining another block on overflow. Correct, and it
    // quietly closed the door the whole region-class design was built to keep open. A narrow `A*` is an
    // offset from the arena's base, and offsets are only unique while there is ONE base -- two objects
    // at the same offset in different chain links are the same 32-bit value. Chaining and narrow
    // pointers cannot both be true.
    //
    // A reservation costs address space rather than memory (measured: `malloc(256 MiB)` charges 257 MiB
    // of private commit on Windows, `VirtualAlloc(MEM_RESERVE)` charges nothing), so the arena is
    // declared far larger than any program will use and commits as it fills. It never traps and never
    // moves, which is what the chain was for and what the offset needs.
    const std::string gname = regionFamilyRoot(cls) + ".region";
    llvm::GlobalVariable* slot = module.getNamedGlobal(gname);
    if (slot == nullptr) {
        slot = new llvm::GlobalVariable(module, builder.getPtrTy(), /*isConstant=*/false,
                                        llvm::GlobalValue::InternalLinkage,
                                        llvm::ConstantPointerNull::get(builder.getPtrTy()), gname);
    }
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    auto* initBB = llvm::BasicBlock::Create(context, "rgncls.init", fn);
    auto* contBB = llvm::BasicBlock::Create(context, "rgncls.ready", fn);
    llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), slot, "rgncls.cur");
    builder.CreateCondBr(builder.CreateIsNull(cur, "rgncls.absent"), initBB, contBB);

    builder.SetInsertPoint(initBB);
    // Built on FIRST USE rather than by a static constructor, because bare metal runs none.
    llvm::Value* arena = builder.CreateCall(arenaReserveFn(), {}, "rgncls.arena");
    builder.CreateStore(arena, slot);
    builder.CreateBr(contBB);

    builder.SetInsertPoint(contBB);
    return builder.CreateLoad(builder.getPtrTy(), slot, "rgncls.arena");
}

llvm::Value* CodeGenerator::Impl::classArenaAlloc(const std::string& cls, llvm::Value* size) {
    // The runtime hands back an OFFSET; the object pointer is base + offset. Both are wanted here:
    // the pointer for everything that runs today, the offset for a narrow `A*` in a field.
    llvm::Value* arena = classRegionBlock(cls);
    llvm::Value* off = builder.CreateCall(arenaAllocFn(), {arena, size}, cls + ".off");
    llvm::Value* base = builder.CreateCall(arenaBaseFn(), {arena}, cls + ".base");
    return builder.CreateGEP(builder.getInt8Ty(), base, off, cls + ".obj");
}

llvm::Value* CodeGenerator::Impl::classArenaBase(const std::string& cls) {
    return builder.CreateCall(arenaBaseFn(), {classRegionBlock(cls)}, regionFamilyRoot(cls) + ".base");
}

llvm::Function* CodeGenerator::Impl::classArenaNewFn(const std::string& cls) {
    auto cit = classes.find(cls);
    if (cit == classes.end() || cit->second.decl == nullptr || !cit->second.decl->isRegionClass) {
        return nullptr;
    }
    if (auto it = arenaNewFns_.find(cls); it != arenaNewFns_.end()) {
        return it->second;
    }
    // Everything that allocates an A resolves A's arena at COMPILE time -- `emitNew`, a value copy, a
    // cascade clone -- because it knows which class it is building. Reflection does not: `instantiate`
    // holds a type token and a size, and reaching for `malloc` there was the last door left open in
    // the totality this feature is built on. A thunk closes it without teaching the reflection path
    // what a region is: the token carries "how to make one of me", and for a region class that is the
    // arena.
    llvm::Function* savedFn = currentFn;
    llvm::IRBuilderBase::InsertPointGuard savedIP(builder);
    llvm::Function* fn = llvm::Function::Create(
        llvm::FunctionType::get(builder.getPtrTy(), {}, false), llvm::Function::InternalLinkage,
        "__rgncls.new." + cls, module);
    arenaNewFns_[cls] = fn;
    currentFn = fn;
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", fn));
    builder.CreateRet(classArenaAlloc(cls, sizeOf(cit->second.type)));
    currentFn = savedFn;
    return fn;
}

llvm::GlobalVariable* CodeGenerator::Impl::enumSingletonGlobal(const std::string& enumName, const std::string& constName) {
    const std::string gname = enumName + "." + constName + ".__inst";
    if (staticGlobals.count(gname) == 0) {
        staticGlobals[gname] = new llvm::GlobalVariable(
            module, builder.getPtrTy(), /*isConstant=*/false,
            llvm::GlobalValue::PrivateLinkage,
            llvm::ConstantPointerNull::get(builder.getPtrTy()), gname);
    }
    return staticGlobals[gname];
}

llvm::Value* CodeGenerator::Impl::emitJavaEnumOrdinal(llvm::Value* v, const std::string& enumName) {
    llvm::Value* ord = builder.getInt32(-1);
    auto eit = enums.find(enumName);
    if (eit == enums.end()) {
        return ord;
    }
    for (std::size_t i = 0; i < eit->second.size(); ++i) {
        llvm::GlobalVariable* g = enumSingletonGlobal(enumName, eit->second[i]);
        llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), g, "enum.ord.cur");
        llvm::Value* eq = builder.CreateICmpEQ(v, cur);
        ord = builder.CreateSelect(eq, builder.getInt32(static_cast<int>(i)), ord, "enum.ord");
    }
    return ord;
}

llvm::Value* CodeGenerator::Impl::emitJavaEnumFromOrdinal(const std::string& enumName, llvm::Value* ord) {
    llvm::Value* result = llvm::ConstantPointerNull::get(builder.getPtrTy());
    auto jit = javaEnums.find(enumName);
    if (jit == javaEnums.end()) {
        return result;
    }
    const std::vector<std::string>& consts = jit->second->constants;
    for (std::size_t i = 0; i < consts.size(); ++i) {
        llvm::Value* p = emitEnumConstant(*jit->second, consts[i]);
        if (p == nullptr) {
            return result;
        }
        llvm::Value* eq = builder.CreateICmpEQ(ord, builder.getInt32(static_cast<int>(i)));
        result = builder.CreateSelect(eq, p, result, "enum.singleton");
    }
    return result;
}

llvm::Value* CodeGenerator::Impl::emitEnumConstant(const ast::EnumDecl& en, const std::string& constName) {
    auto pos = std::find(en.constants.begin(), en.constants.end(), constName);
    if (pos == en.constants.end()) {
        error("enum '" + en.name + "' has no constant '" + constName + "'", en.loc);
        return nullptr;
    }
    const std::size_t idx = static_cast<std::size_t>(pos - en.constants.begin());
    auto cit = classes.find(en.name);
    if (cit == classes.end()) {
        return nullptr;
    }
    llvm::GlobalVariable* g = enumSingletonGlobal(en.name, constName);
    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
    llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), g, "enum.cur");
    llvm::Function* fn = currentFn;
    auto* initBB = llvm::BasicBlock::Create(context, "enumc.init", fn);
    auto* doneBB = llvm::BasicBlock::Create(context, "enumc.done", fn);
    builder.CreateCondBr(builder.CreateICmpEQ(cur, nullp), initBB, doneBB);
    builder.SetInsertPoint(initBB);
    llvm::Value* objPtr = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, en.name);
    auto fnit = functions.find(en.name + "." + en.name);
    if (fnit != functions.end()) {
        std::vector<llvm::Value*> args;
        args.push_back(objPtr);
        const auto& cargs = en.constantArgs[idx];
        for (std::size_t i = 0; i < cargs.size(); ++i) {
            llvm::Value* v = emitExpr(*cargs[i]);
            if (v == nullptr) {
                return nullptr;
            }
            v = coerceArg(v, typeName(*cargs[i]), fnit->second, i + 1);
            args.push_back(v);
        }
        emitMaybeInvoke(fnit->second, args);
    }
    builder.CreateStore(objPtr, g);
    builder.CreateBr(doneBB);
    builder.SetInsertPoint(doneBB);
    return builder.CreateLoad(builder.getPtrTy(), g, en.name);
}

bool CodeGenerator::Impl::collectSelectChain(const ast::Expr* chain, std::vector<SelectCase>& cases) {
    const auto* call = dynamic_cast<const ast::CallExpr*>(chain);
    if (call == nullptr) {
        return false;
    }
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
    if (mem == nullptr) {
        return false;
    }
    if (mem->member == "select" && call->args.empty()) {
        const auto* base = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        return base != nullptr && base->name == "Channel";  // base: Channel.select()
    }
    if (!collectSelectChain(mem->object.get(), cases)) {
        return false;  // recurse to the base
    }
    if (mem->member == "receive" && call->args.size() == 2) {
        cases.push_back({call->args[0].get(), call->args[1].get(), nullptr, false});
    } else if (mem->member == "timeout" && call->args.size() == 2) {
        cases.push_back({nullptr, call->args[1].get(), call->args[0].get(), true});
    } else {
        return false;
    }
    return true;
}

void CodeGenerator::Impl::emitClosureCallVoid(llvm::Value* closPtr, const std::string& paramType, llvm::Value* arg) {
    std::vector<llvm::Type*> pts = {builder.getPtrTy()};
    if (arg != nullptr) {
        pts.push_back(llvmType(paramType));
    }
    llvm::FunctionType* fty = llvm::FunctionType::get(builder.getVoidTy(), pts, false);
    llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), closPtr, "code");
    llvm::Value* env = builder.CreateLoad(
        builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), closPtr, builder.getInt32(1)),
        "env");
    std::vector<llvm::Value*> args = {env};
    if (arg != nullptr) {
        args.push_back(coerceToType(arg, llvmType(paramType)));
    }
    builder.CreateCall(fty, fnPtr, args);
}

void CodeGenerator::Impl::emitSelect(const std::vector<SelectCase>& cases) {
    struct Recv {
        llvm::Value* h;
        llvm::Value* clos;
        std::string elem;
    };
    std::vector<Recv> recvs;
    llvm::Value* toClos = nullptr;
    llvm::Value* msVal = nullptr;
    llvm::Value* startMs = nullptr;
    llvm::FunctionType* nowTy = llvm::FunctionType::get(builder.getInt64Ty(), false);
    // Evaluate channel handles and handler closures once, before the loop.
    for (const auto& c : cases) {
        if (c.isTimeout) {
            msVal = builder.CreateIntCast(emitExpr(*c.ms), builder.getInt64Ty(), true);
            toClos = emitExpr(*c.lambda);
        } else {
            llvm::Value* obj = emitObjectPtr(*c.channel);
            const std::string ct = baseType(typeName(*c.channel));  // Channel$T
            auto cit = classes.find(ct);
            llvm::Value* h = builder.CreateLoad(
                builder.getInt64Ty(),
                builder.CreateStructGEP(cit->second.type, obj, cit->second.fieldIndex["h"]),
                "sel.h");
            recvs.push_back({h, emitExpr(*c.lambda), ct.substr(8)});
        }
    }
    if (msVal != nullptr) {
        startMs = builder.CreateCall(module.getOrInsertFunction("__polaron_now_ms", nowTy), {});
    }
    llvm::Value* tmp = createEntryAlloca("sel.tmp", builder.getInt64Ty());
    llvm::BasicBlock* loopBlk = llvm::BasicBlock::Create(context, "sel.loop", currentFn);
    llvm::BasicBlock* doneBlk = llvm::BasicBlock::Create(context, "sel.done", currentFn);
    builder.CreateBr(loopBlk);
    builder.SetInsertPoint(loopBlk);
    llvm::FunctionType* trTy = llvm::FunctionType::get(
        builder.getInt32Ty(), {builder.getInt64Ty(), builder.getPtrTy()}, false);
    for (const auto& r : recvs) {
        llvm::Value* got = builder.CreateCall(
            module.getOrInsertFunction("__polaron_chan_try_receive", trTy), {r.h, tmp}, "sel.got");
        llvm::BasicBlock* gotBlk = llvm::BasicBlock::Create(context, "sel.recv", currentFn);
        llvm::BasicBlock* nextBlk = llvm::BasicBlock::Create(context, "sel.next", currentFn);
        builder.CreateCondBr(builder.CreateICmpNE(got, builder.getInt32(0)), gotBlk, nextBlk);
        builder.SetInsertPoint(gotBlk);
        llvm::Value* v =
            castTaskResult(builder.CreateLoad(builder.getInt64Ty(), tmp, "sel.v"), r.elem);
        emitClosureCallVoid(r.clos, r.elem, v);
        builder.CreateBr(doneBlk);
        builder.SetInsertPoint(nextBlk);
    }
    if (toClos != nullptr) {
        llvm::Value* now = builder.CreateCall(module.getOrInsertFunction("__polaron_now_ms", nowTy), {});
        llvm::BasicBlock* toBlk = llvm::BasicBlock::Create(context, "sel.timeout", currentFn);
        llvm::BasicBlock* contBlk = llvm::BasicBlock::Create(context, "sel.cont", currentFn);
        builder.CreateCondBr(
            builder.CreateICmpSGE(builder.CreateSub(now, startMs), msVal), toBlk, contBlk);
        builder.SetInsertPoint(toBlk);
        emitClosureCallVoid(toClos, "", nullptr);
        builder.CreateBr(doneBlk);
        builder.SetInsertPoint(contBlk);
    }
    builder.CreateCall(
        module.getOrInsertFunction("__polaron_yield", llvm::FunctionType::get(builder.getVoidTy(), false)),
        {});
    builder.CreateBr(loopBlk);
    builder.SetInsertPoint(doneBlk);
}

llvm::Value* CodeGenerator::Impl::horizontalAddVec(llvm::Value* v, int w) {
    llvm::Value* sum = builder.CreateExtractElement(v, builder.getInt32(0));
    for (int i = 1; i < w; i++) {
        sum = builder.CreateFAdd(sum, builder.CreateExtractElement(v, builder.getInt32(i)));
    }
    return sum;
}

llvm::Value* CodeGenerator::Impl::emitCross3(llvm::Value* a, llvm::Value* b) {
    auto el = [&](llvm::Value* v, int i) { return builder.CreateExtractElement(v, builder.getInt32(i)); };
    llvm::Value* ax = el(a, 0); llvm::Value* ay = el(a, 1); llvm::Value* az = el(a, 2);
    llvm::Value* bx = el(b, 0); llvm::Value* by = el(b, 1); llvm::Value* bz = el(b, 2);
    llvm::Value* cx = builder.CreateFSub(builder.CreateFMul(ay, bz), builder.CreateFMul(az, by));
    llvm::Value* cy = builder.CreateFSub(builder.CreateFMul(az, bx), builder.CreateFMul(ax, bz));
    llvm::Value* cz = builder.CreateFSub(builder.CreateFMul(ax, by), builder.CreateFMul(ay, bx));
    llvm::Value* r = llvm::UndefValue::get(llvm::FixedVectorType::get(builder.getFloatTy(), 3));
    r = builder.CreateInsertElement(r, cx, builder.getInt32(0));
    r = builder.CreateInsertElement(r, cy, builder.getInt32(1));
    r = builder.CreateInsertElement(r, cz, builder.getInt32(2));
    return r;
}

llvm::Function* CodeGenerator::Impl::knownLambdaFor(const ast::Expr& argExpr, llvm::Value* argValue) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&argExpr)) {
        if (auto it = boundLambdas_.find(id->name); it != boundLambdas_.end()) {
            return it->second;
        }
    }
    if (auto* gv = llvm::dyn_cast_or_null<llvm::GlobalVariable>(argValue);
        gv != nullptr && gv->isConstant() && gv->hasInitializer()) {
        if (auto* init = llvm::dyn_cast<llvm::ConstantArray>(gv->getInitializer());
            init != nullptr && init->getNumOperands() >= 1) {
            return llvm::dyn_cast<llvm::Function>(init->getOperand(0));
        }
    }
    return nullptr;
}

void CodeGenerator::Impl::emitSpecializations() {
    while (!specWorklist_.empty()) {
        Specialization req = specWorklist_.back();
        specWorklist_.pop_back();
        boundLambdas_ = req.bound;
        const std::string thisClass = req.decl->isStatic ? std::string() : req.owner;
        emitBody(req.fn, req.decl->body, req.decl->params, thisClass, llvmType(req.returnType),
                 nullptr, &req.decl->requiresClauses, &req.decl->ensuresClauses,
                 req.decl->isStatic ? nullptr : &classInvariants(req.owner),
                 false, nullptr, nullptr, "", nullptr, false, false,
                 req.returnType);  // String RAII: copy-on-return key
        boundLambdas_.clear();
    }
}

llvm::Value* CodeGenerator::Impl::mat4Identity() {
    llvm::Value* m = mat4Zero();
    for (int i = 0; i < 4; i++) {  // 1.0 on the diagonal (indices 0, 5, 10, 15)
        m = builder.CreateInsertElement(m, llvm::ConstantFP::get(builder.getFloatTy(), 1.0),
                                        builder.getInt32(i * 5));
    }
    return m;
}

llvm::Value* CodeGenerator::Impl::mat4Mul(llvm::Value* a, llvm::Value* b) {
    auto el = [&](llvm::Value* m, int i) { return builder.CreateExtractElement(m, builder.getInt32(i)); };
    llvm::Value* r = mat4Zero();
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            llvm::Value* sum = llvm::ConstantFP::get(builder.getFloatTy(), 0.0);
            for (int k = 0; k < 4; k++) {
                sum = builder.CreateFAdd(sum, builder.CreateFMul(el(a, i * 4 + k), el(b, k * 4 + j)));
            }
            r = builder.CreateInsertElement(r, sum, builder.getInt32(i * 4 + j));
        }
    }
    return r;
}

void CodeGenerator::Impl::emitCleanupAction(const Cleanup& c) {
    if (c.lockRelease != nullptr) {  // synchronized: release the Mutex lock (on normal exit or unwind)
        llvm::FunctionType* lf =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
        builder.CreateCall(module.getOrInsertFunction("__polaron_lock_release", lf), {c.lockRelease});
        return;
    }
    if (c.block != nullptr) {
        if (c.budgetMs == nullptr) {
            emitBlock(*c.block);
            return;
        }
        // spec 32.10: time the cleanup and report an overrun of its budget.
        llvm::FunctionType* nowTy = llvm::FunctionType::get(builder.getInt64Ty(), {}, false);
        llvm::FunctionCallee now = module.getOrInsertFunction("__polaron_now_ns", nowTy);
        llvm::Value* t0 = builder.CreateCall(now, {}, "defer.t0");
        emitBlock(*c.block);
        llvm::Value* t1 = builder.CreateCall(now, {}, "defer.t1");
        llvm::Value* tookNs = builder.CreateSub(t1, t0, "defer.ns");
        llvm::Value* tookMs =
            builder.CreateSDiv(tookNs, builder.getInt64(1000000), "defer.ms");
        llvm::FunctionType* ovTy = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* overBB = llvm::BasicBlock::Create(context, "defer.over", fn);
        llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "defer.ok", fn);
        builder.CreateCondBr(builder.CreateICmpSGT(tookMs, c.budgetMs), overBB, okBB);
        builder.SetInsertPoint(overBB);
        builder.CreateCall(module.getOrInsertFunction("__polaron_defer_overrun", ovTy),
                           {c.budgetMs, tookMs});
        builder.CreateBr(okBB);
        builder.SetInsertPoint(okBB);
        return;
    }
    if (c.consumed) {
        return;  // an explicit `delete r` inside the using block already disposed it
    }
    llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), c.slot);
    if (c.virtualDelete) {  // destructor through the vtable, then free (see emitDeleteObject)
        emitDeleteObject(objPtr, c.className);
        return;
    }
    auto cit = classes.find(c.className);
    if (cit != classes.end() && cit->second.hasDestructor) {
        builder.CreateCall(functions[c.className + ".~" + c.className], {objPtr});
    }
    if (c.heap) {
        builder.CreateCall(freeFn(), {objPtr});  // a heap resource is freed too
    }
}

// The `this.<field>` names an expression mentions.
static void collectThisFields(const ast::Expr* e, std::set<std::string>& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        if (const auto* o = dynamic_cast<const ast::IdentifierExpr*>(m->object.get())) {
            if (o->name == "this") {
                out.insert(m->member);
            }
        }
        collectThisFields(m->object.get(), out);
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) { collectThisFields(b->lhs.get(), out); collectThisFields(b->rhs.get(), out); return; }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) { collectThisFields(u->operand.get(), out); return; }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) { collectThisFields(ix->array.get(), out); collectThisFields(ix->index.get(), out); return; }
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(e)) { collectThisFields(c->operand.get(), out); return; }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) { collectThisFields(t->cond.get(), out); collectThisFields(t->thenExpr.get(), out); collectThisFields(t->elseExpr.get(), out); return; }
    if (const auto* ca = dynamic_cast<const ast::CallExpr*>(e)) {
        collectThisFields(ca->callee.get(), out);
        for (const auto& a : ca->args) {
            collectThisFields(a.get(), out);
        }
        return;
    }
}

static bool blockAssignsThisField(const ast::Block& b, const std::set<std::string>& fields);

static bool stmtAssignsThisField(const ast::Stmt* s, const std::set<std::string>& fields) {
    if (s == nullptr) {
        return false;
    }
    auto targets = [&](const ast::Expr* t) {
        std::set<std::string> hit;
        collectThisFields(t, hit);
        for (const std::string& f : hit) {
            if (fields.count(f) > 0) {
                return true;
            }
        }
        return false;
    };
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) { return targets(as->target.get()); }
    if (const auto* idd = dynamic_cast<const ast::IncDecStmt*>(s)) { return targets(idd->target.get()); }
    if (const auto* blk = dynamic_cast<const ast::Block*>(s)) { return blockAssignsThisField(*blk, fields); }
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
        return blockAssignsThisField(i->thenBlock, fields) ||
               (i->elseBlock && blockAssignsThisField(*i->elseBlock, fields));
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) { return stmtAssignsThisField(f->init.get(), fields) || stmtAssignsThisField(f->update.get(), fields) || blockAssignsThisField(f->body, fields); }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) { return blockAssignsThisField(w->body, fields); }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) { return blockAssignsThisField(d->body, fields); }
    // Anything unrecognised is assumed to write, so the check stays.
    return !dynamic_cast<const ast::ExprStmt*>(s) && !dynamic_cast<const ast::VarDeclStmt*>(s) &&
           !dynamic_cast<const ast::ReturnStmt*>(s) && !dynamic_cast<const ast::BreakStmt*>(s) &&
           !dynamic_cast<const ast::ContinueStmt*>(s);
}

static bool blockAssignsThisField(const ast::Block& b, const std::set<std::string>& fields) {
    for (const auto& s : b.statements) {
        if (stmtAssignsThisField(s.get(), fields)) {
            return true;
        }
    }
    return false;
}

const std::vector<const ast::Expr*>* CodeGenerator::Impl::invariantsToCheck(
    llvm::Function* fn, const std::vector<const ast::Expr*>* all, const ast::Block& body) {
    // A METHOD THAT WRITES NOTHING THE INVARIANT MENTIONS CANNOT HAVE BROKEN IT.
    //
    // Every exit of every method re-checks every invariant of the class. On a `HashMap` that is five
    // checks on the way out of `get`, `slotFor`, `size`, `isEmpty` -- methods that assign no field at
    // all. The invariant held at entry (that is exactly what `emitInvariantAssumes` relies on), and a
    // method that changed none of its fields leaves it holding.
    //
    // A call is not a hole here: the callee checks the invariant at its own exit, so it is re-verified
    // there. What must not be skipped is a method that assigns one of the fields itself -- `put`,
    // `grow`, `remove` -- and those keep every check.
    //
    // This matters because enforcing the invariants at all was a REGRESSION until it existed: they had
    // never run on a generic class (monomorphize dropped them), and turning them on cost the map
    // benchmark 3.5 ms. Checking them where they can actually break costs almost nothing.
    if (all == nullptr) {
        return nullptr;
    }
    auto it = invariantCheckCache_.find(fn);
    if (it != invariantCheckCache_.end()) {
        return &it->second;
    }
    std::vector<const ast::Expr*> keep;
    for (const ast::Expr* inv : *all) {
        std::set<std::string> fields;
        collectThisFields(inv, fields);
        if (fields.empty() || blockAssignsThisField(body, fields)) {
            keep.push_back(inv);
        }
    }
    return &(invariantCheckCache_[fn] = std::move(keep));
}

void CodeGenerator::Impl::emitInvariantAssumes() {
    // A CONTRACT THAT PAYS FOR ITSELF: every declared `invariant` is handed to the optimiser at method
    // entry as a fact it may rely on.
    //
    // This is sound because of something the language already does: `emitScopeCleanup` CHECKS every
    // invariant at every exit of every method, and the constructor checks them too -- there is no
    // switch that turns contracts off. An object can therefore only be observed by a later method in a
    // state some earlier exit already verified. If an invariant were false, the program would have
    // panicked at the exit that broke it, before anything here could rely on it. So this assumes only
    // what is checked, and nothing is taken on trust.
    //
    // What it buys, on `HashMap`: the class declares `this.used.length() == this.cap` (and the same for
    // `keys`/`values`), plus `count >= 0` and `count < cap`. A probe indexes with `h & (cap - 1)`,
    // which lies in `[0, cap-1]`; with `length == cap` known, and `cap >= 1` following from the other
    // two, the bounds check on every probe is provably true and LLVM deletes it. That is the branch the
    // measurements kept pointing at -- removing those checks by hand took the map benchmark from
    // 38.3 ms to 32.4 -- and here it comes out of a contract the author wrote for correctness.
    //
    // Emitted as `llvm.assume` rather than as a new elision rule ON PURPOSE: there is no new place
    // where a bounds check can be dropped by mistake. LLVM removes a check only where it can prove the
    // index in range, exactly as it always has; this just stops hiding the facts from it.
    // ALL of the class's invariants, not the narrowed exit-check set: they hold on entry whatever this
    // method does next, and the read-only methods -- which the narrowed set leaves empty -- are exactly
    // the ones with something to gain.
    if (currentInvariantsToAssume == nullptr || currentThis == nullptr) {
        return;
    }
    for (const ast::Expr* inv : *currentInvariantsToAssume) {
        if (inv == nullptr) {
            continue;
        }
        llvm::Value* v = emitExpr(*inv);
        if (v == nullptr || !v->getType()->isIntegerTy()) {
            continue;   // an invariant this cannot evaluate is simply not handed over
        }
        if (!v->getType()->isIntegerTy(1)) {
            v = builder.CreateICmpNE(v, llvm::ConstantInt::get(v->getType(), 0), "inv.assume");
        }
        builder.CreateIntrinsic(builder.getVoidTy(), llvm::Intrinsic::assume, {v});
    }
}

void CodeGenerator::Impl::emitScopeCleanup() {
    // Contracts: postconditions run at each exit, before defers/destructors (spec 29).
    if (currentEnsures != nullptr) {
        for (const ast::ExprPtr& e : *currentEnsures) {
            emitContractCheck(*e, "ensures");
        }
    }
    if (currentInvariants != nullptr) {
        for (const ast::Expr* inv : *currentInvariants) {
            emitContractCheck(*inv, "invariant");
        }
    }
    // Deferred actions run first, in reverse (LIFO) order. Snapshot and clear the list while running
    // it: if a defer body throws, its own unwind must not re-run the defers (that double-ran them);
    // the still-live destructors/regions are cleaned by the unwind path instead. Restored after, so a
    // sibling exit path (another return in a different branch) still sees the defers.
    std::vector<Cleanup> savedDef = deferred;
    deferred.clear();
    for (auto it = savedDef.rbegin(); it != savedDef.rend(); ++it) {
        if (builder.GetInsertBlock()->getTerminator() != nullptr) {
            break;
        }
        emitCleanupAction(*it);
    }
    deferred = savedDef;
    // A defer/using body that itself threw already terminated the block and taken over control
    // (its exception propagates); the remaining teardown and the caller's return are unreachable.
    if (builder.GetInsertBlock()->getTerminator() != nullptr) {
        return;
    }
    for (auto it = scopeObjects.rbegin(); it != scopeObjects.rend(); ++it) {
        if (!it->region.empty()) {
            continue;  // region objects are destructed when the region frees
        }
        auto fnit = functions.find(it->className + ".~" + it->className);
        const bool weak = weakRelevant(it->className);
        if (fnit == functions.end() && !weak) {
            continue;
        }
        llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), it->slot);
        emitDtorIfLive(objPtr, fnit == functions.end() ? llvm::FunctionCallee() : fnit->second,
                       weak ? it->className : std::string());
    }
    // String RAII: release every live String local at this function exit (spec 4). Not cleared here
    // (like scopeObjects) -- the unwinding emitBlock calls resize away the tracking entries.
    for (auto it = scopeStrings.rbegin(); it != scopeStrings.rend(); ++it) {
        builder.CreateCall(strFreeFn(), {builder.CreateLoad(builder.getPtrTy(), *it)});
    }
    // Async/gen value-struct RAII: free every coroutine-state value struct at this exit (spec 11/20).
    for (auto it = scopeValueStructs.rbegin(); it != scopeValueStructs.rend(); ++it) {
        emitFreeValueStructSlot(it->first, it->second);
    }
    freeRegionsFrom(0);  // region RAII (spec 17.7): free every live region at this exit
    // Inside a destructor: chain to the base class destructor last (derived-then-base),
    // so the inherited part is torn down at every exit of this destructor.
    if (!currentDtorChain.empty()) {
        if (auto fit = functions.find(currentDtorChain); fit != functions.end() && currentThis) {
            builder.CreateCall(fit->second, {currentThis});
        }
    }
}

llvm::GlobalVariable* CodeGenerator::Impl::instanceCounter(const std::string& name) {
    auto it = instanceCounters.find(name);
    if (it != instanceCounters.end()) {
        return it->second;
    }
    auto* g = new llvm::GlobalVariable(module, builder.getInt32Ty(), /*isConstant=*/false,
                                       llvm::GlobalValue::PrivateLinkage, builder.getInt32(0),
                                       "instances." + name);
    instanceCounters[name] = g;
    return g;
}

void CodeGenerator::Impl::declareCodeTable() {
    codeTableBase = new llvm::GlobalVariable(
        module, builder.getPtrTy(), /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
        llvm::ConstantPointerNull::get(builder.getPtrTy()), "__polaron_code_base");
    codeTableCount = new llvm::GlobalVariable(
        module, builder.getInt64Ty(), /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
        builder.getInt64(0), "__polaron_code_count");
}

void CodeGenerator::Impl::fillCodeTable() {
    if (codeTableBase == nullptr) {
        return;
    }
    std::vector<llvm::Constant*> code;
    // WALK THE MODULE, not the `functions` map. This runs after dead-stripping, and anything the
    // strip deleted left a dangling `llvm::Function*` behind in that map -- reading it crashed
    // the compiler outright, with no diagnostic, which is how this line came to be written this
    // way. The module is the only thing that knows what is still here.
    for (llvm::Function& f : module) {
        if (!f.isDeclaration()) {
            code.push_back(&f);
        }
    }
    auto* arrTy = llvm::ArrayType::get(builder.getPtrTy(), code.size());
    auto* arr = new llvm::GlobalVariable(module, arrTy, /*isConstant=*/true,
                                         llvm::GlobalValue::PrivateLinkage,
                                         llvm::ConstantArray::get(arrTy, code), "__polaron_code");
    codeTableBase->setInitializer(arr);
    codeTableCount->setInitializer(builder.getInt64(code.size()));
}

void CodeGenerator::Impl::attachTBAA() {
    llvm::MDBuilder mdb(context);
    llvm::MDNode* root = mdb.createTBAARoot("polaron TBAA");
    llvm::MDNode* omni = mdb.createTBAAScalarTypeNode("polaron char", root);  // aliases everything
    std::unordered_map<std::string, llvm::MDNode*> cat;
    auto node = [&](const char* name) -> llvm::MDNode* {
        auto it = cat.find(name);
        if (it != cat.end()) {
            return it->second;
        }
        llvm::MDNode* n = mdb.createTBAAScalarTypeNode(name, omni);
        return cat[name] = n;
    };
    auto tagFor = [&](llvm::Type* t) -> llvm::MDNode* {
        llvm::MDNode* n = nullptr;
        if (t->isPointerTy()) {
            n = node("ptr");
        } else if (t->isDoubleTy()) {
            n = node("f64");
        } else if (t->isFloatTy()) {
            n = node("f32");
        } else if (t->isIntegerTy()) {
            switch (t->getIntegerBitWidth()) {
                case 1: n = node("i1"); break;      case 8: n = node("i8"); break;
                case 16: n = node("i16"); break;    case 32: n = node("i32"); break;
                case 64: n = node("i64"); break;    case 128: n = node("i128"); break;
                default: return nullptr;
            }
        } else {
            return nullptr;  // aggregate / vector / half: leave conservative
        }
        return mdb.createTBAAStructTagNode(n, n, 0);
    };
    std::unordered_set<llvm::Type*> okStruct;  // non-union class structs
    for (auto& [cn, ci] : classes) {
        if (ci.type != nullptr && !ci.isUnion) {
            okStruct.insert(ci.type);
        }
    }
    auto isClassField = [&](llvm::Value* ptr) -> bool {
        auto* gep = llvm::dyn_cast<llvm::GetElementPtrInst>(ptr);
        return gep != nullptr && okStruct.count(gep->getSourceElementType()) > 0;
    };
    for (llvm::Function& f : module) {
        for (llvm::BasicBlock& bb : f) {
            for (llvm::Instruction& inst : bb) {
                if (auto* L = llvm::dyn_cast<llvm::LoadInst>(&inst)) {
                    if (isClassField(L->getPointerOperand())) {
                        if (llvm::MDNode* tag = tagFor(L->getType())) {
                            L->setMetadata(llvm::LLVMContext::MD_tbaa, tag);
                        }
                    }
                } else if (auto* S = llvm::dyn_cast<llvm::StoreInst>(&inst)) {
                    if (isClassField(S->getPointerOperand())) {
                        if (llvm::MDNode* tag = tagFor(S->getValueOperand()->getType())) {
                            S->setMetadata(llvm::LLVMContext::MD_tbaa, tag);
                        }
                    }
                }
            }
        }
    }
}

void CodeGenerator::Impl::emitStringBridge() {
    if (!freestandingProgram()) {
        return;
    }
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::PointerType* p = builder.getPtrTy();
    llvm::StructType* strTy = llvm::StructType::get(context, {i64, p, i64});
    auto define = [&](const char* sym, llvm::Type* ret, llvm::ArrayRef<llvm::Type*> params)
        -> llvm::Function* {
        llvm::FunctionType* ty = llvm::FunctionType::get(ret, params, false);
        llvm::Function* f = module.getFunction(sym);
        if (f == nullptr) {
            f = llvm::Function::Create(ty, llvm::Function::ExternalLinkage, sym, module);
        }
        return f->empty() ? f : nullptr;   // already has a body: leave it alone
    };
    auto ip = builder.saveIP();
    llvm::Function* saved = currentFn;

    // __polaron_str_copy(src) -> a fresh String owning its own buffer. Null-safe.
    if (llvm::Function* f = define("__polaron_str_copy", p, {p})) {
        currentFn = f;
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* work = llvm::BasicBlock::Create(context, "copy", f);
        auto* null = llvm::BasicBlock::Create(context, "isnull", f);
        builder.SetInsertPoint(entry);
        llvm::Value* src = f->getArg(0);
        builder.CreateCondBr(
            builder.CreateICmpEQ(src, llvm::ConstantPointerNull::get(p)), null, work);
        builder.SetInsertPoint(null);
        builder.CreateRet(llvm::ConstantPointerNull::get(p));
        builder.SetInsertPoint(work);
        llvm::Value* len = builder.CreateLoad(
            i64, builder.CreateStructGEP(strTy, src, 0, "src.len.p"), "src.len");
        llvm::Value* data = builder.CreateLoad(
            p, builder.CreateStructGEP(strTy, src, 1, "src.data.p"), "src.data");
        llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(strTy)}, "str.obj");
        // len + 1: the buffer stays NUL-terminated, which is what lets a String be handed to
        // anything that expects a C string without copying it again.
        llvm::Value* buf = builder.CreateCall(
            mallocFn(), {builder.CreateAdd(len, builder.getInt64(1))}, "str.buf");
        builder.CreateMemCpy(buf, llvm::MaybeAlign(1), data, llvm::MaybeAlign(1), len);
        builder.CreateStore(builder.getInt8(0), builder.CreateGEP(builder.getInt8Ty(), buf, len));
        builder.CreateStore(len, builder.CreateStructGEP(strTy, obj, 0));
        builder.CreateStore(buf, builder.CreateStructGEP(strTy, obj, 1));
        builder.CreateStore(builder.getInt64(0), builder.CreateStructGEP(strTy, obj, 2));
        builder.CreateRet(obj);
    }

    // __polaron_str_free(s): the buffer, then the object. Null-safe.
    if (llvm::Function* f = define("__polaron_str_free", builder.getVoidTy(), {p})) {
        currentFn = f;
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* work = llvm::BasicBlock::Create(context, "free", f);
        auto* done = llvm::BasicBlock::Create(context, "done", f);
        builder.SetInsertPoint(entry);
        llvm::Value* s = f->getArg(0);
        builder.CreateCondBr(
            builder.CreateICmpEQ(s, llvm::ConstantPointerNull::get(p)), done, work);
        builder.SetInsertPoint(work);
        builder.CreateCall(freeFn(), {builder.CreateLoad(
                                         p, builder.CreateStructGEP(strTy, s, 1, "s.data.p"))});
        builder.CreateCall(freeFn(), {s});
        builder.CreateBr(done);
        builder.SetInsertPoint(done);
        builder.CreateRetVoid();
    }

    // __polaron_str_index(h, hl, n, nl) -> first index of n in h, or -1. Length-aware, so it is
    // correct where strstr would not be: neither buffer has to stop at a NUL.
    if (llvm::Function* f = define("__polaron_str_index", i64, {p, i64, p, i64})) {
        currentFn = f;
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* outer = llvm::BasicBlock::Create(context, "outer", f);
        auto* inner = llvm::BasicBlock::Create(context, "inner", f);
        auto* step = llvm::BasicBlock::Create(context, "step", f);
        auto* hit = llvm::BasicBlock::Create(context, "hit", f);
        auto* miss = llvm::BasicBlock::Create(context, "miss", f);
        builder.SetInsertPoint(entry);
        llvm::Value* h = f->getArg(0);
        llvm::Value* hl = f->getArg(1);
        llvm::Value* n = f->getArg(2);
        llvm::Value* nl = f->getArg(3);
        llvm::Value* iSlot = builder.CreateAlloca(i64, nullptr, "i");
        llvm::Value* jSlot = builder.CreateAlloca(i64, nullptr, "j");
        builder.CreateStore(builder.getInt64(0), iSlot);
        // An empty needle is found at 0; a needle longer than the haystack never is.
        auto* emptyBB = llvm::BasicBlock::Create(context, "empty", f);
        auto* sizedBB = llvm::BasicBlock::Create(context, "sized", f);
        builder.CreateCondBr(builder.CreateICmpEQ(nl, builder.getInt64(0)), emptyBB, sizedBB);
        builder.SetInsertPoint(emptyBB);
        builder.CreateRet(builder.getInt64(0));
        builder.SetInsertPoint(sizedBB);
        builder.CreateCondBr(builder.CreateICmpSGT(nl, hl), miss, outer);

        builder.SetInsertPoint(outer);
        llvm::Value* i = builder.CreateLoad(i64, iSlot, "i.v");
        builder.CreateCondBr(builder.CreateICmpSLE(builder.CreateAdd(i, nl), hl), inner, miss);

        builder.SetInsertPoint(inner);
        builder.CreateStore(builder.getInt64(0), jSlot);
        auto* cmp = llvm::BasicBlock::Create(context, "cmp", f);
        builder.CreateBr(cmp);
        builder.SetInsertPoint(cmp);
        llvm::Value* j = builder.CreateLoad(i64, jSlot, "j.v");
        auto* more = llvm::BasicBlock::Create(context, "more", f);
        builder.CreateCondBr(builder.CreateICmpSLT(j, nl), more, hit);
        builder.SetInsertPoint(more);
        llvm::Value* hc = builder.CreateLoad(
            builder.getInt8Ty(),
            builder.CreateGEP(builder.getInt8Ty(), h,
                              builder.CreateAdd(builder.CreateLoad(i64, iSlot), j)));
        llvm::Value* nc =
            builder.CreateLoad(builder.getInt8Ty(), builder.CreateGEP(builder.getInt8Ty(), n, j));
        builder.CreateStore(builder.CreateAdd(j, builder.getInt64(1)), jSlot);
        builder.CreateCondBr(builder.CreateICmpEQ(hc, nc), cmp, step);

        builder.SetInsertPoint(step);
        builder.CreateStore(builder.CreateAdd(builder.CreateLoad(i64, iSlot), builder.getInt64(1)),
                            iSlot);
        builder.CreateBr(outer);

        builder.SetInsertPoint(hit);
        builder.CreateRet(builder.CreateLoad(i64, iSlot));
        builder.SetInsertPoint(miss);
        builder.CreateRet(builder.getInt64(-1));
    }
    currentFn = saved;
    builder.restoreIP(ip);
}

void CodeGenerator::Impl::emitHeapBridge() {
    const ast::ClassDecl* heapCls = nullptr;
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& ns : b.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                if (c.isHeap) {
                    if (heapCls != nullptr) {
                        error("more than one `heap class` in the program (there is one heap): '" +
                                  heapCls->name + "' and '" + c.name + "'",
                              c.loc);
                    }
                    heapCls = &c;
                }
            }
        }
    }
    if (heapCls == nullptr) {
        return;
    }
    // Freestanding only. In hosted mode `on heap` is the idiomatic allocation and the runtime's
    // pooled allocator is the right one -- letting a program replace it would be a footgun with no
    // upside (the pool is what String/array/object lifetime accounting is built on). Bare metal is
    // the case where there IS no allocator until the program provides one.
    if (!program.isFreestanding) {
        error("`heap class` is only available in freestanding mode (spec 36); in a hosted program "
              "`on heap` already allocates from the runtime",
              heapCls->loc);
        return;
    }
    auto bridge = [&](const char* sym, const char* method, llvm::Type* ret,
                      llvm::ArrayRef<llvm::Type*> params, bool required) {
        auto it = functions.find(heapCls->name + "." + method);
        if (it == functions.end()) {
            if (required) {
                error("`heap class " + heapCls->name + "` must define `public static method " +
                          method + "` (the program's heap)",
                      heapCls->loc);
            }
            return;
        }
        // The rest of codegen already inserted a DECLARATION of this symbol (mallocFn/freeFn/
        // checkLiveFn use getOrInsertFunction). Give that declaration a body -- creating a second
        // function with the same name would just get renamed by LLVM, leaving the real call sites
        // pointing at an unresolved symbol.
        llvm::FunctionType* ty = llvm::FunctionType::get(ret, params, false);
        llvm::Function* f = module.getFunction(sym);
        if (f == nullptr) {
            f = llvm::Function::Create(ty, llvm::Function::ExternalLinkage, sym, module);
        }
        if (!f->empty()) {
            return;  // already bridged
        }
        auto ip = builder.saveIP();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
        // The allocator speaks Polaron types (`address` = i64) while these symbols speak the C shape
        // (`ptr`), so bridge each value across the two views of a machine word.
        llvm::Function* target = it->second;
        std::vector<llvm::Value*> args;
        unsigned pi = 0;
        for (auto& a : f->args()) {
            llvm::Value* v = &a;
            llvm::Type* want = target->getFunctionType()->getParamType(pi++);
            if (v->getType() != want) {
                v = want->isPointerTy() ? builder.CreateIntToPtr(v, want)
                                        : builder.CreatePtrToInt(v, want);
            }
            args.push_back(v);
        }
        llvm::Value* r = builder.CreateCall(it->second, args);
        if (ret->isVoidTy()) {
            builder.CreateRetVoid();
        } else {
            if (r->getType() != ret) {
                r = ret->isPointerTy() ? builder.CreateIntToPtr(r, ret)
                                       : builder.CreatePtrToInt(r, ret);
            }
            builder.CreateRet(r);
        }
        builder.restoreIP(ip);
        foreignEntryPoints_.insert(sym);  // reached only from generated code; never internalize away
    };
    bridge("__polaron_malloc", "allocate", builder.getPtrTy(), {builder.getInt64Ty()}, true);
    bridge("__polaron_free", "release", builder.getVoidTy(), {builder.getPtrTy()}, true);
    // No `checkLive`: emit the guard as a no-op so `delete` still links.
    if (functions.count(heapCls->name + ".checkLive") == 0) {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        llvm::Function* f = module.getFunction("__polaron_check_live");
        if (f == nullptr) {
            f = llvm::Function::Create(ty, llvm::Function::ExternalLinkage, "__polaron_check_live",
                                       module);
        }
        if (f->empty()) {
            auto ip = builder.saveIP();
            builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
            builder.CreateRetVoid();
            builder.restoreIP(ip);
        }
        foreignEntryPoints_.insert("__polaron_check_live");
    } else {
        bridge("__polaron_check_live", "checkLive", builder.getVoidTy(), {builder.getPtrTy()}, false);
    }
}

void CodeGenerator::Impl::stripDeadCode() {
    if (libraryMode) {
        return;
    }
    llvm::ModuleAnalysisManager mam;
    llvm::PassBuilder pb;
    pb.registerModuleAnalyses(mam);
    llvm::ModulePassManager mpm;
    // Keep the entry (kmain is the freestanding entry, spec 36) and every `unknown <world>` method --
    // those are declared entry points for a foreign world (asm, firmware, a foreign binary), so they
    // must keep their symbol; internalizing them would delete the boundary the declaration promised.
    const std::set<std::string>& keep = foreignEntryPoints_;
    mpm.addPass(llvm::InternalizePass([&keep](const llvm::GlobalValue& gv) {
        return gv.getName() == "main" || gv.getName() == "kmain" ||
               keep.count(gv.getName().str()) > 0;
    }));
    mpm.addPass(llvm::GlobalDCEPass());
    mpm.run(module, mam);
}

void CodeGenerator::Impl::applyBareMetalAttrs() {
    const llvm::Triple triple(moduleTripleStr(module));
    // An unset triple is the hosted default, and an unparseable arch is not a target we can reason
    // about -- neither is bare metal, so neither gets the attribute.
    if (triple.getArch() == llvm::Triple::UnknownArch) {
        return;
    }
    if (triple.getOS() != llvm::Triple::UnknownOS) {
        return;  // `...-none-elf` parses as no OS
    }
    for (llvm::Function& f : module) {
        if (!f.isDeclaration()) {
            f.addFnAttr(llvm::Attribute::NoRedZone);
        }
    }
}

void CodeGenerator::Impl::emitPhysicalCodeOp(const std::string& className, const char* runtimeFn) {
    if (codeTableBase == nullptr) {
        return;
    }
    auto cit = classes.find(className);
    if (cit == classes.end() || cit->second.decl == nullptr) {
        return;
    }
    llvm::FunctionType* ht = llvm::FunctionType::get(
        builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty()}, false);
    llvm::FunctionCallee helper = module.getOrInsertFunction(runtimeFn, ht);
    // Both loaded, never baked: the table and its size are only known once every body has been
    // emitted, which is long after this call site is written.
    auto op = [&](const std::string& codeName) {
        if (auto f = functions.find(codeName); f != functions.end()) {
            llvm::Value* base = builder.CreateLoad(builder.getPtrTy(), codeTableBase, "code.base");
            llvm::Value* n = builder.CreateLoad(builder.getInt64Ty(), codeTableCount, "code.n");
            builder.CreateCall(helper, {f->second, base, n});
        }
    };
    for (const ast::MemberPtr& m : cit->second.decl->members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get()); md && !md->isAbstract) {
            op(className + "." + md->name);
        }
    }
    op(className + "." + className);        // constructor
    op(className + ".~" + className);        // destructor
}

llvm::Function* CodeGenerator::Impl::unimportedTrap(const std::string& cn) {
    const std::string sym = cn + ".__unimportedCall";
    if (auto it = functions.find(sym); it != functions.end()) {
        return it->second;
    }
    auto* ty = llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
    auto* f = llvm::Function::Create(ty, llvm::Function::InternalLinkage, sym, module);
    auto ip = builder.saveIP();
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
    llvm::Function* saved = currentFn;
    currentFn = f;
    // The enclosing method's active `try` landing pads must NOT travel in here: this is a
    // different function, and a throw that unwinds to a pad belonging to another one is exactly
    // what the module verifier calls "referring to a basic block in another function". Nothing
    // catches inside the trap -- it is the end of the line.
    std::vector<llvm::BasicBlock*> savedPads;
    savedPads.swap(ehPadStack);
    if (freestandingProgram()) {
        emitPanic("call into unimported type '" + cn + "'");
    } else {
        emitThrowUnimported();
    }
    ehPadStack.swap(savedPads);
    currentFn = saved;
    builder.restoreIP(ip);
    functions[sym] = f;
    return f;
}

void CodeGenerator::Impl::emitUnimportClass(const std::string& cn) {
    // REFUSE WHILE ANYTHING IS STILL ALIVE. This is the precondition that makes the rest safe:
    // with no live instance there is no object whose vtable pointer, fields or destructor can
    // outlive the code being ripped, so poisoning the table and overwriting the methods cannot
    // strand anybody. Without it `unimport` is a promise the program cannot keep.
    //
    // Checked at run time and not at compile time on purpose -- how many instances exist is not
    // a question the compiler can answer, and the counter that does answer it already exists for
    // onFirstInstance/onLastInstanceDestroyed. Unimportable classes now keep it on both ends,
    // which is also why one of them gets a destructor even when it wrote none: without it there
    // is nowhere for the count to come down.
    {
        llvm::Value* live =
            builder.CreateLoad(builder.getInt32Ty(), instanceCounter(cn), "live.n");
        llvm::Function* f = currentFn;
        auto* badBB = llvm::BasicBlock::Create(context, "unimport.live", f);
        auto* okBB = llvm::BasicBlock::Create(context, "unimport.ok", f);
        builder.CreateCondBr(builder.CreateICmpNE(live, builder.getInt32(0)), badBB, okBB);
        builder.SetInsertPoint(badBB);
        if (freestandingProgram()) {
            emitPanic("cannot unimport '" + cn + "': instances of it are still alive");
        } else {
            emitThrowUnimported();
        }
        builder.SetInsertPoint(okBB);
    }
    if (auto f = functions.find(cn + ".__onClassUnload"); f != functions.end()) {
        builder.CreateCall(f->second);
    }
    builder.CreateStore(builder.getInt32(0), aliveFlag(cn));
    auto cit = classes.find(cn);
    if (cit != classes.end() && cit->second.vtable != nullptr) {
        llvm::Function* trap = unimportedTrap(cn);
        auto* vtTy = llvm::cast<llvm::ArrayType>(cit->second.vtable->getValueType());
        for (unsigned i = 0; i < vtTy->getNumElements(); ++i) {
            builder.CreateStore(trap, builder.CreateConstInBoundsGEP2_32(
                                          vtTy, cit->second.vtable, 0, i, "vt.slot"));
        }
    }
    // AND THE CLASS'S OWN STORAGE GOES. Its static fields are the memory that belonged to the
    // type rather than to any object, and with nothing alive there is nobody left who can read
    // them -- so leaving them holding their last values is leaving state behind for a type that
    // no longer exists. A later `reimport` gets the class back at its starting state, which is
    // what "loaded again" should mean.
    //
    // Only the class's OWN statics. Instances are not touched, and cannot be: the refusal above
    // already guarantees there are none, so there is nothing to free that is not already freed.
    for (const auto& [key, g] : staticGlobals) {
        const std::size_t dot = key.rfind('.');
        if (dot == std::string::npos || key.substr(0, dot) != cn) {
            continue;
        }
        builder.CreateStore(llvm::Constant::getNullValue(g->getValueType()), g);
    }
    emitPhysicalUnload(cn);
}

std::vector<std::string> CodeGenerator::Impl::unimportGroupTargets(const ast::UnimportStmt& u) {
    std::vector<std::string> out;
    if (u.granularity == 0) { out.push_back(baseType(u.target)); return out; }
    for (const ast::Bundle& b : program.bundles) {
        if (u.granularity == 2 && b.name != u.target) {
            continue;
        }
        for (const ast::Namespace& ns : b.namespaces) {
            if (u.granularity == 1 && ns.name != u.target) {
                continue;
            }
            for (const ast::ClassDecl& c : ns.classes) {
                out.push_back(c.name);
            }
            for (const ast::EnumDecl& e : ns.enums) {
                out.push_back(e.name);
            }
        }
    }
    return out;
}

std::vector<std::string> CodeGenerator::Impl::cascadeUnimportTargets(const std::string& x) {
    std::vector<std::string> out;
    for (const auto& [name, layout] : classes) {
        bool match = name == x || name.rfind(x + "$", 0) == 0;  // self or monomorphization
        for (std::string cur = layout.superclass; !match && !cur.empty();) {
            if (cur == x) { match = true; break; }
            auto it = classes.find(cur);
            if (it == classes.end()) {
                break;
            }
            cur = it->second.superclass;
        }
        if (match) {
            out.push_back(name);
        }
    }
    return out;
}

llvm::Value* CodeGenerator::Impl::emitExpectingValue(const ast::Block* block) {
    if (block == nullptr) {
        return builder.getInt32(0);
    }
    std::string vt = "int";
    for (const auto& s : block->statements) {
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s.get());
            rs != nullptr && rs->value != nullptr) {
            vt = typeName(*rs->value);
        }
    }
    llvm::Type* ty = llvmType(vt);
    llvm::Value* slot = builder.CreateAlloca(ty, nullptr, "expecting.val");
    builder.CreateStore(llvm::Constant::getNullValue(ty), slot);
    llvm::BasicBlock* end = llvm::BasicBlock::Create(context, "expecting.end", currentFn);
    llvm::Value* savedSlot = expectingSlot_;
    llvm::BasicBlock* savedEnd = expectingEnd_;
    expectingSlot_ = slot;
    expectingEnd_ = end;
    emitBlock(*block, /*newScope=*/true);
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(end);
    }
    expectingSlot_ = savedSlot;
    expectingEnd_ = savedEnd;
    builder.SetInsertPoint(end);
    return builder.CreateLoad(ty, slot, "expecting.result");
}

llvm::Value* CodeGenerator::Impl::emitBitEqual(llvm::Value* a, llvm::Value* b) {
    if (a == nullptr || b == nullptr) {
        return builder.getInt1(true);
    }
    llvm::Type* ta = a->getType();
    if (ta->isFloatingPointTy()) {
        llvm::Type* it = builder.getIntNTy(ta->getPrimitiveSizeInBits());
        return builder.CreateICmpEQ(builder.CreateBitCast(a, it), builder.CreateBitCast(b, it));
    }
    if (ta->isPointerTy()) {
        return builder.CreateICmpEQ(builder.CreatePtrToInt(a, builder.getInt64Ty()),
                                    builder.CreatePtrToInt(b, builder.getInt64Ty()));
    }
    if (ta->isIntegerTy()) {
        return builder.CreateICmpEQ(a, b);
    }
    return builder.getInt1(true);
}

void CodeGenerator::Impl::emitThrowUnimported() {
    if (freestandingProgram()) {
        emitPanic("use of an unimported type: its code was ripped from RAM by `unimport`");
        return;
    }
    auto cit = classes.find("UnimportedTypeException");
    if (cit == classes.end()) { builder.CreateUnreachable(); return; }
    llvm::Value* exc = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "unimp.exc");
    if (auto f = functions.find("UnimportedTypeException.UnimportedTypeException");
        f != functions.end()) {
        builder.CreateCall(f->second, {exc});  // sets the vtable, so catch can match the type
    }
    emitThrowObject(exc);
}

void CodeGenerator::Impl::emitThrowNamed(const std::string& cn) {
    auto cit = classes.find(cn);
    if (cit == classes.end()) {
        builder.CreateUnreachable();
        return;
    }
    llvm::Value* exc = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "exc");
    if (auto f = functions.find(cn + "." + cn); f != functions.end()) {
        builder.CreateCall(f->second, {exc});
    }
    emitThrowObject(exc);
}

void CodeGenerator::Impl::emitAliveGuard(const std::string& cn) {
    if (unimportableClasses.count(cn) == 0) {
        return;
    }
    llvm::Value* alive = builder.CreateLoad(builder.getInt32Ty(), aliveFlag(cn), "alive");
    llvm::Function* f = currentFn;
    auto* deadBB = llvm::BasicBlock::Create(context, "unimported", f);
    auto* okBB = llvm::BasicBlock::Create(context, "alive.ok", f);
    builder.CreateCondBr(builder.CreateICmpEQ(alive, builder.getInt32(0)), deadBB, okBB);
    builder.SetInsertPoint(deadBB);
    emitThrowUnimported();
    builder.SetInsertPoint(okBB);
}

llvm::GlobalVariable* CodeGenerator::Impl::aliveFlag(const std::string& name) {
    auto it = aliveFlags.find(name);
    if (it != aliveFlags.end()) {
        return it->second;
    }
    auto* g = new llvm::GlobalVariable(module, builder.getInt32Ty(), /*isConstant=*/false,
                                       llvm::GlobalValue::PrivateLinkage, builder.getInt32(1),
                                       "alive." + name);
    aliveFlags[name] = g;
    return g;
}

llvm::GlobalVariable* CodeGenerator::Impl::abstainCounter(const std::string& name) {
    auto it = abstainCounters.find(name);
    if (it != abstainCounters.end()) {
        return it->second;
    }
    auto* g = new llvm::GlobalVariable(module, builder.getInt32Ty(), /*isConstant=*/false,
                                       llvm::GlobalValue::PrivateLinkage, builder.getInt32(0),
                                       "abstain." + name);
    abstainCounters[name] = g;
    return g;
}

void CodeGenerator::Impl::scanAbstained(const ast::Stmt* st) {
    if (st == nullptr) {
        return;
    }
    if (const auto* a = dynamic_cast<const ast::AbstainfromStmt*>(st)) {
        // Intra-method: qualify by the containing method so the key matches the label guard's
        // "class.method.label" and same-named labels in different methods never collide (7.11).
        abstainedLabels.insert(scanClass_ + "." + scanMethod_ + "." + a->name);
        return;
    }
    if (const auto* u = dynamic_cast<const ast::UnimportStmt*>(st)) {
        for (const std::string& t : unimportGroupTargets(*u)) {
            unimportableClasses.insert(t);
        }
        return;
    }
    // `release region <RegionClass>` needs the SAME live-instance counter `unimport` needs, and for
    // the same reason: it may only free the family's arena when nothing in it is alive.
    //
    // Recorded here, in the pass that already walks every statement looking for exactly this kind of
    // "which classes need a counter" question. Counting unconditionally for every region class would
    // put an add and a store on every construction of every one of them, including the programs that
    // never release -- and a region class exists to make allocation cheap.
    if (const auto* rr = dynamic_cast<const ast::ReleaseStmt*>(st)) {
        if (!rr->region.empty()) {
            auto rcit = classes.find(rr->region);
            if (rcit != classes.end() && rcit->second.decl != nullptr &&
                rcit->second.decl->isRegionClass) {
                const std::string root = regionFamilyRoot(rr->region);
                for (const auto& [cn, ci] : classes) {
                    if (ci.decl != nullptr && ci.decl->isRegionClass &&
                        regionFamilyRoot(cn) == root) {
                        countedClasses.insert(cn);
                    }
                }
            }
        }
        return;
    }
    if (const auto* rv = dynamic_cast<const ast::ReimportValidateStmt*>(st)) {  // spec 30.18
        unimportableClasses.insert(baseType(rv->target));
        if (rv->expecting) {
            for (const auto& s : rv->expecting->statements) {
                scanAbstained(s.get());
            }
        }
        if (rv->onFailure) {
            for (const auto& s : rv->onFailure->statements) {
                scanAbstained(s.get());
            }
        }
        return;
    }
    if (const auto* c = dynamic_cast<const ast::CascadeStmt*>(st)) {  // cascade unimport: X + subtypes
        if (c->op == ast::CascadeOpKind::Unimport) {
            for (const std::string& t : cascadeUnimportTargets(c->typeName)) {
                unimportableClasses.insert(t);
            }
        }
        return;
    }
    // `unimport X expecting { ... }` (spec 30.18) appears in expression position (e.g. a var
    // initializer); scan the expression-bearing leaf statements for it.
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) { scanExprForUnimport(vd->init.get()); return; }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(st)) { scanExprForUnimport(es->expr.get()); return; }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(st)) { scanExprForUnimport(as->value.get()); return; }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(st)) { scanExprForUnimport(rs->value.get()); return; }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            scanAbstained(s.get());
        }
    };
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(st)) {
        blk(i->thenBlock);
        if (i->elseBlock) {
            blk(*i->elseBlock);
        }
        return;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) { blk(w->body); return; }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) { blk(d->body); return; }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) { blk(f->body); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) { blk(fe->body); return; }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
        for (auto& c : sw->cases) {
            blk(c.body);
        }
        if (sw->defaultBody) {
            blk(*sw->defaultBody);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
        for (auto& c : ms->cases) {
            blk(c.body);
        }
        if (ms->defaultBody) {
            blk(*ms->defaultBody);
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
        blk(tr->body);
        for (auto& c : tr->catches) {
            blk(c.body);
        }
        if (tr->finallyBlock) {
            blk(*tr->finallyBlock);
        }
        return;
    }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) { blk(df->body); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) { blk(us->body); return; }
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { scanAbstained(lb->stmt.get()); return; }
}

void CodeGenerator::Impl::scanExprForUnimport(const ast::Expr* e) {
    if (e == nullptr) {
        return;
    }
    if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(e)) {
        unimportableClasses.insert(baseType(ue->target));
        if (ue->expecting) {
            for (const auto& s : ue->expecting->statements) {
                scanAbstained(s.get());
            }
        }
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        scanExprForUnimport(b->lhs.get());
        scanExprForUnimport(b->rhs.get());
        return;
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        scanExprForUnimport(u->operand.get());
    }
}

void CodeGenerator::Impl::scanLabelChainTopLevel(const ast::Block& body) {
    std::string last;
    for (const auto& s : body.statements) {
        const ast::Stmt* st = s.get();
        if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) {
            st = lb->stmt.get();
        }
        if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(st)) {
            if (!last.empty()) {
                nextAbstainLabel_[last] = lm->name;
            }
            last = scanClass_ + "." + scanMethod_ + "." + lm->name;
        }
    }
}

void CodeGenerator::Impl::collectFieldRegionKinds() {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                FieldRegionKinds k;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        scanFieldRegions(m->body, cls.name, k);
                    } else if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        scanFieldRegions(c->body, cls.name, k);
                    } else if (const auto* d = dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        scanFieldRegions(d->body, cls.name, k);
                    }
                }
                for (const std::string& key : k.owned) {
                    if (k.external.count(key) == 0) {
                        ownedFieldRegions_.insert(key);
                    }
                }
            }
        }
    }
}

void CodeGenerator::Impl::markUnimportableDestructors() {
    // A counted class needs a destructor whether it wrote one or not: that is the only place its
    // live-instance count can come down. `countedClasses` is here for the same reason and not by
    // analogy -- a region class whose count only ever climbs would refuse every `release region`.
    for (const std::unordered_set<std::string>* set : {&unimportableClasses, &countedClasses}) {
        for (const std::string& cn : *set) {
            auto it = classes.find(cn);
            if (it != classes.end() && !it->second.isInterface) {
                it->second.hasDestructor = true;
            }
        }
    }
}

void CodeGenerator::Impl::collectAbstainedLabels() {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    scanClass_ = cls.name;
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        scanMethod_ = m->name;  // function name is "class.method"
                        for (const auto& s : m->body.statements) {
                            scanAbstained(s.get());
                        }
                        scanLabelChainTopLevel(m->body);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        scanMethod_ = cls.name;  // function name is "class.class"
                        for (const auto& s : c->body.statements) {
                            scanAbstained(s.get());
                        }
                        scanLabelChainTopLevel(c->body);
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        scanMethod_ = "~" + cls.name;  // function name is "class.~class"
                        for (const auto& s : d->body.statements) {
                            scanAbstained(s.get());
                        }
                        scanLabelChainTopLevel(d->body);
                    }
                }
            }
        }
    }
}

void CodeGenerator::Impl::emitDefaultReturn() {
    emitPendingFinallys(0);
    emitScopeCleanup();
    if (builder.GetInsertBlock()->getTerminator() != nullptr) {
        return;  // a throwing defer took over
    }
    if (currentRetType->isVoidTy()) {
        builder.CreateRetVoid();
    } else if (currentRetType->isDoubleTy() || currentRetType->isFloatTy()) {
        builder.CreateRet(llvm::ConstantFP::get(currentRetType, 0.0));
    } else if (currentRetType->isPointerTy()) {
        builder.CreateRet(llvm::ConstantPointerNull::get(builder.getPtrTy()));
    } else if (currentRetType->isStructTy()) {
        builder.CreateRet(llvm::UndefValue::get(currentRetType));
    } else {
        builder.CreateRet(llvm::ConstantInt::get(currentRetType, 0));
    }
}

void CodeGenerator::Impl::emitPendingFinallys(std::size_t downTo) {
    // While emitting a finally, mask it (and inner ones) off the stack: a `return`/exit INSIDE a
    // finally must run only the ENCLOSING finallys, not re-enter itself. Without this, a
    // `try { return; } finally { return; }` recursed forever (emitBlock -> return -> here -> ...)
    // and overflowed the stack. The full stack is restored for emitTry's own pop/normal-path emit.
    std::vector<const ast::Block*> saved = finallyStack;
    for (std::size_t i = saved.size(); i > downTo; --i) {
        if (builder.GetInsertBlock()->getTerminator() != nullptr) {
            break;
        }
        finallyStack.resize(i - 1);
        emitBlock(*saved[i - 1]);
    }
    finallyStack = saved;
}

const CodeGenerator::Impl::LoopTargets* CodeGenerator::Impl::findLoop(const std::string& label) {
    if (label.empty()) {
        return loopStack.empty() ? nullptr : &loopStack.back();
    }
    for (auto it = loopStack.rbegin(); it != loopStack.rend(); ++it) {
        if (it->label == label) {
            return &*it;
        }
    }
    return nullptr;
}

void CodeGenerator::Impl::ensurePersonality() {
    if (currentFn != nullptr && !currentFn->hasPersonalityFn()) {
        const char* name = isItaniumEH() ? "__gxx_personality_v0" : "__CxxFrameHandler3";
        llvm::FunctionCallee p =
            module.getOrInsertFunction(name, llvm::FunctionType::get(builder.getInt32Ty(), true));
        currentFn->setPersonalityFn(llvm::cast<llvm::Constant>(p.getCallee()));
    }
}

llvm::Constant* CodeGenerator::Impl::imageBaseSym() {
    llvm::GlobalVariable* g = module.getNamedGlobal("__ImageBase");
    if (g == nullptr) {
        g = new llvm::GlobalVariable(module, builder.getInt8Ty(), true,
                                     llvm::GlobalValue::ExternalLinkage, nullptr, "__ImageBase");
    }
    return g;
}

llvm::Constant* CodeGenerator::Impl::imageRel(llvm::Constant* x) {
    llvm::Type* i64 = builder.getInt64Ty();
    return llvm::ConstantExpr::getTrunc(
        llvm::ConstantExpr::getSub(llvm::ConstantExpr::getPtrToInt(x, i64),
                                   llvm::ConstantExpr::getPtrToInt(imageBaseSym(), i64)),
        builder.getInt32Ty());
}

void CodeGenerator::Impl::buildEhStructures() {
    if (ehThrowInfoCache != nullptr) {
        return;
    }
    llvm::Type* i32 = builder.getInt32Ty();
    llvm::PointerType* ptrTy = builder.getPtrTy();
    llvm::GlobalVariable* tiVt = module.getNamedGlobal("??_7type_info@@6B@");
    if (tiVt == nullptr) {
        tiVt = new llvm::GlobalVariable(module, ptrTy, true, llvm::GlobalValue::ExternalLinkage,
                                        nullptr, "??_7type_info@@6B@");
    }
    // Type descriptor for void* (PEAX): { type_info vtable, null, ".PEAX\0" }.
    llvm::Constant* nameStr = llvm::ConstantDataArray::getString(context, ".PEAX", true);
    llvm::StructType* tdTy = llvm::StructType::get(context, {ptrTy, ptrTy, nameStr->getType()});
    auto* td = new llvm::GlobalVariable(
        module, tdTy, false, llvm::GlobalValue::InternalLinkage,
        llvm::ConstantStruct::get(tdTy, {tiVt, llvm::ConstantPointerNull::get(ptrTy), nameStr}),
        "??_R0PEAX@8");
    // CatchableType { props=1, relTypeDesc, 0, -1, 0, size=8, copyfn=0 }.
    llvm::StructType* ctTy = llvm::StructType::get(context, {i32, i32, i32, i32, i32, i32, i32});
    auto* ct = new llvm::GlobalVariable(
        module, ctTy, true, llvm::GlobalValue::InternalLinkage,
        llvm::ConstantStruct::get(
            ctTy, {llvm::ConstantInt::get(i32, 1), imageRel(td), llvm::ConstantInt::get(i32, 0),
                   llvm::ConstantInt::get(i32, -1), llvm::ConstantInt::get(i32, 0),
                   llvm::ConstantInt::get(i32, 8), llvm::ConstantInt::get(i32, 0)}),
        "_CT??_R0PEAX@88");
    ct->setSection(".xdata");
    // CatchableTypeArray { count=1, [relCatchableType] }.
    llvm::ArrayType* arrTy = llvm::ArrayType::get(i32, 1);
    llvm::StructType* ctaTy = llvm::StructType::get(context, {i32, arrTy});
    auto* cta = new llvm::GlobalVariable(
        module, ctaTy, true, llvm::GlobalValue::InternalLinkage,
        llvm::ConstantStruct::get(ctaTy, {llvm::ConstantInt::get(i32, 1),
                                          llvm::ConstantArray::get(arrTy, {imageRel(ct)})}),
        "_CTA1PEAX");
    cta->setSection(".xdata");
    // ThrowInfo { attrs=0, dtor=0, fwd=0, relCatchableTypeArray }.
    llvm::StructType* tiTy = llvm::StructType::get(context, {i32, i32, i32, i32});
    auto* ti = new llvm::GlobalVariable(
        module, tiTy, true, llvm::GlobalValue::InternalLinkage,
        llvm::ConstantStruct::get(tiTy, {llvm::ConstantInt::get(i32, 0),
                                         llvm::ConstantInt::get(i32, 0),
                                         llvm::ConstantInt::get(i32, 0), imageRel(cta)}),
        "_TI1PEAX");
    ti->setSection(".xdata");
    ehTypeDescCache = td;
    ehThrowInfoCache = ti;
}

llvm::FunctionCallee CodeGenerator::Impl::cxxThrowFn() {
    return module.getOrInsertFunction(
        "_CxxThrowException",
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()},
                                false));
}

bool CodeGenerator::Impl::isItaniumEH() {
    const std::string t = moduleTripleStr(module);
    // An explicit target triple decides; an empty one (the common `polc foo.pol` with no --target)
    // means the native host, so fall back to which platform polc itself was built for. Without this,
    // a Windows build leaves the triple empty and would wrongly pick the Itanium path.
    if (!t.empty()) {
        return t.find("windows") == std::string::npos;
    }
#ifdef _WIN32
    return false;
#else
    return true;
#endif
}

llvm::Constant* CodeGenerator::Impl::itaniumVoidPtrTypeInfo() {
    llvm::GlobalVariable* g = module.getNamedGlobal("_ZTIPv");
    if (g == nullptr) {
        g = new llvm::GlobalVariable(module, builder.getPtrTy(), true,
                                     llvm::GlobalValue::ExternalLinkage, nullptr, "_ZTIPv");
    }
    return g;
}

llvm::FunctionCallee CodeGenerator::Impl::cxaAllocateException() {
    return module.getOrInsertFunction(
        "__cxa_allocate_exception",
        llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::cxaThrowFn() {
    return module.getOrInsertFunction(
        "__cxa_throw", llvm::FunctionType::get(
                           builder.getVoidTy(),
                           {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::cxaBeginCatch() {
    return module.getOrInsertFunction(
        "__cxa_begin_catch",
        llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::cxaEndCatch() {
    return module.getOrInsertFunction("__cxa_end_catch",
                                      llvm::FunctionType::get(builder.getVoidTy(), false));
}

llvm::StructType* CodeGenerator::Impl::landingPadType() {
    return llvm::StructType::get(context, {builder.getPtrTy(), builder.getInt32Ty()});
}

bool CodeGenerator::Impl::hasUnwindCleanup() {
    // Freestanding has no exceptions at all (sema rejects `throw` with Polaron-0901), so NOTHING can
    // unwind: a landing pad here is dead code whose only effect is an undefined `_Unwind_Resume` at
    // link time. Destructors still run on the normal paths -- this drops the unwind path only.
    if (program.isFreestanding) {
        return false;
    }
    if (!deferred.empty() || !scopeRegions.empty()) {
        return true;
    }
    for (const ScopeObject& so : scopeObjects) {
        if (so.region.empty() &&
            (functions.count(so.className + ".~" + so.className) > 0 || weakRelevant(so.className))) {
            return true;
        }
    }
    return false;
}

bool CodeGenerator::Impl::hasUnwindCleanupAbove(std::size_t soBase, std::size_t dfBase, std::size_t rgBase) {
    if (program.isFreestanding) {
        return false;  // see hasUnwindCleanup
    }
    if (deferred.size() > dfBase || scopeRegions.size() > rgBase) {
        return true;
    }
    for (std::size_t i = soBase; i < scopeObjects.size(); ++i) {
        if (scopeObjects[i].region.empty() &&
            (functions.count(scopeObjects[i].className + ".~" + scopeObjects[i].className) > 0 ||
             weakRelevant(scopeObjects[i].className))) {
            return true;
        }
    }
    return false;
}

llvm::BasicBlock* CodeGenerator::Impl::computeUnwindDest() {
    if (!ehPadStack.empty()) {
        if (!ehBaseStack.empty()) {
            const EhBase& b = ehBaseStack.back();
            if (hasUnwindCleanupAbove(b.so, b.df, b.rg)) {
                if (isItaniumEH()) {
                    if (b.itDispatch != nullptr) {
                        return buildCleanupDispatchItanium(b.so, b.df, b.rg, b.itDispatch, b.itCarrier);
                    }
                } else {
                    return buildCleanupChain(ehPadStack.back(), b.so, b.df, b.rg);
                }
            }
        }
        return ehPadStack.back();
    }
    if (!hasUnwindCleanup()) {
        return nullptr;
    }
    return buildCleanupChain(nullptr);
}

void CodeGenerator::Impl::emitThrowObjectItanium(llvm::Value* obj) {
    ensurePersonality();
    llvm::PointerType* ptrTy = builder.getPtrTy();
    // Allocate an exception whose 8-byte payload is the carrier (the object pointer), then throw it
    // typed as void*. Every Polaron throw uses this one type; matching happens in the handler.
    llvm::Value* exc = builder.CreateCall(cxaAllocateException(),
                                          {llvm::ConstantInt::get(builder.getInt64Ty(), 8)});
    builder.CreateStore(obj, exc);
    std::vector<llvm::Value*> args = {exc, itaniumVoidPtrTypeInfo(),
                                      llvm::ConstantPointerNull::get(ptrTy)};
    if (llvm::BasicBlock* ud = computeUnwindDest(); ud != nullptr) {
        llvm::BasicBlock* cont = llvm::BasicBlock::Create(context, "throw.cont", currentFn);
        builder.CreateInvoke(cxaThrowFn(), cont, ud, args);
        builder.SetInsertPoint(cont);
    } else {
        builder.CreateCall(cxaThrowFn(), args);  // propagates to the caller
    }
    builder.CreateUnreachable();  // __cxa_throw does not return
}

void CodeGenerator::Impl::emitThrowObject(llvm::Value* obj) {
    if (isItaniumEH()) {
        emitThrowObjectItanium(obj);
        return;
    }
    ensurePersonality();
    llvm::Value* slot = createEntryAlloca("exc.thrown", builder.getPtrTy());
    builder.CreateStore(obj, slot);  // carrier: the object pointer, thrown as void*
    std::vector<llvm::Value*> args = {slot, ehThrowInfo()};
    if (llvm::BasicBlock* ud = computeUnwindDest(); ud != nullptr) {
        llvm::BasicBlock* cont = llvm::BasicBlock::Create(context, "throw.cont", currentFn);
        builder.CreateInvoke(cxxThrowFn(), cont, ud, args);
        builder.SetInsertPoint(cont);
    } else {
        builder.CreateCall(cxxThrowFn(), args);  // propagates to the caller
    }
    builder.CreateUnreachable();  // _CxxThrowException does not return
}

std::vector<llvm::Constant*> CodeGenerator::Impl::subtypeVtables(const std::string& t) {
    std::vector<llvm::Constant*> out;
    for (const auto& [cn, cl] : classes) {
        if (cl.vtable == nullptr) {
            continue;
        }
        for (std::string c = cn; !c.empty();) {
            if (c == t) { out.push_back(cl.vtable); break; }
            auto it = classes.find(c);
            c = (it != classes.end()) ? it->second.superclass : std::string();
        }
    }
    return out;
}

bool CodeGenerator::Impl::classIsSubtypeOf(const std::string& cn, const std::string& t) {
    if (cn == t) {
        return true;
    }
    auto it = classes.find(cn);
    if (it == classes.end()) {
        return false;
    }
    if (!it->second.superclass.empty() && classIsSubtypeOf(it->second.superclass, t)) {
        return true;
    }
    for (const std::string& i : it->second.interfaces) {
        if (classIsSubtypeOf(i, t)) {
            return true;
        }
    }
    return false;
}

std::vector<llvm::Constant*> CodeGenerator::Impl::subtypeVtablesInc(const std::string& t) {
    std::vector<llvm::Constant*> out;
    for (const auto& [cn, cl] : classes) {
        if (cl.vtable != nullptr && classIsSubtypeOf(cn, t)) {
            out.push_back(cl.vtable);
        }
    }
    return out;
}

llvm::Value* CodeGenerator::Impl::emitIsa(llvm::Value* objPtr, const std::string& targetClass) {
    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
    llvm::Value* isNull = builder.CreateICmpEQ(objPtr, nullp, "isa.null");
    llvm::Function* fn = currentFn;
    llvm::BasicBlock* entryBB = builder.GetInsertBlock();
    auto* chkBB = llvm::BasicBlock::Create(context, "isa.chk", fn);
    auto* contBB = llvm::BasicBlock::Create(context, "isa.cont", fn);
    builder.CreateCondBr(isNull, contBB, chkBB);
    builder.SetInsertPoint(chkBB);
    llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), objPtr, "isa.vtbl");  // field 0
    llvm::Value* match = builder.getFalse();
    for (llvm::Constant* vt : subtypeVtablesInc(targetClass)) {
        match = builder.CreateOr(match, builder.CreateICmpEQ(vtbl, vt));
    }
    llvm::BasicBlock* chkEnd = builder.GetInsertBlock();
    builder.CreateBr(contBB);
    builder.SetInsertPoint(contBB);
    llvm::PHINode* phi = builder.CreatePHI(builder.getInt1Ty(), 2, "isa");
    phi->addIncoming(builder.getFalse(), entryBB);
    phi->addIncoming(match, chkEnd);
    return phi;
}

void CodeGenerator::Impl::emitTryItanium(const ast::TryStmt& s) {
    ensurePersonality();
    llvm::PointerType* ptrTy = builder.getPtrTy();
    llvm::BasicBlock* ehpad = llvm::BasicBlock::Create(context, "ehpad", currentFn);
    llvm::BasicBlock* dispatchBB = llvm::BasicBlock::Create(context, "try.dispatch", currentFn);
    llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "try.cont", currentFn);
    // The handler is split so both the direct landing pad and the in-try cleanup landing pads
    // (buildCleanupDispatchItanium, for throws nested in the body that must run block-scoped teardown
    // first) converge on one clause-matching block, reading the carrier from a shared slot.
    llvm::Value* carrierSlot = createEntryAlloca("exc.carrier", ptrTy);
    ehPadStack.push_back(ehpad);
    ehBaseStack.push_back(
        {scopeObjects.size(), deferred.size(), scopeRegions.size(), dispatchBB, carrierSlot});
    if (s.finallyBlock != nullptr) {
        finallyStack.push_back(s.finallyBlock.get());
    }
    emitBlock(s.body);
    ehPadStack.pop_back();
    ehBaseStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(contBB);
    }

    builder.SetInsertPoint(ehpad);
    llvm::LandingPadInst* lp = builder.CreateLandingPad(landingPadType(), 1);
    lp->addClause(itaniumVoidPtrTypeInfo());
    llvm::Value* excPtr = builder.CreateExtractValue(lp, 0, "exc");
    // __cxa_begin_catch on a pointer-typed exception (_ZTIPv) returns the thrown pointer value -- our
    // carrier -- directly, so it is used as-is with no extra load. end_catch then releases the
    // exception; the carrier points at the Polaron object, which lives on its own, so it stays valid.
    llvm::Value* caught = builder.CreateCall(cxaBeginCatch(), {excPtr}, "caught");
    builder.CreateCall(cxaEndCatch(), {});
    builder.CreateStore(caught, carrierSlot);
    builder.CreateBr(dispatchBB);

    // Clause matching, catch bodies, finally and the unmatched rethrow: ordinary code, reached from
    // the direct pad and from any in-try cleanup pad, with the carrier read once from the slot.
    builder.SetInsertPoint(dispatchBB);
    llvm::Value* obj = builder.CreateLoad(ptrTy, carrierSlot, "exc.obj");
    llvm::Value* objVtbl = builder.CreateLoad(ptrTy, obj, "exc.vtbl");  // field 0 (polymorphic)
    for (const ast::CatchClause& cc : s.catches) {
        const std::string cty = baseType(typeRefName(cc.type));
        llvm::Value* match = nullptr;
        for (llvm::Constant* vt : subtypeVtables(cty)) {
            llvm::Value* eq = builder.CreateICmpEQ(objVtbl, vt, "is");
            match = (match == nullptr) ? eq : builder.CreateOr(match, eq, "or");
        }
        if (match == nullptr) {
            match = builder.getInt1(true);  // non-polymorphic: catch-all
        }
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "catch.body", currentFn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "catch.next", currentFn);
        builder.CreateCondBr(match, bodyBB, nextBB);
        builder.SetInsertPoint(bodyBB);
        llvm::Value* eSlot = createEntryAlloca(cc.name, ptrTy);
        builder.CreateStore(obj, eSlot);
        const bool had = locals.count(cc.name) > 0;
        LocalSlot saved = had ? locals[cc.name] : LocalSlot{};
        locals[cc.name] = LocalSlot{eSlot, cty};
        emitBlock(cc.body);
        if (had) {
            locals[cc.name] = saved;
        } else {
            locals.erase(cc.name);
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(contBB);
        }
        builder.SetInsertPoint(nextBB);
    }
    // No clause matched: run finally (uncaught path) then re-raise the same carrier to the
    // enclosing try or the caller. A fresh throw avoids __cxa_rethrow's begin/end-catch bookkeeping.
    // If the finally itself threw, it already terminated the block, so skip the re-raise.
    if (s.finallyBlock != nullptr) {
        finallyStack.pop_back();
    }
    if (s.finallyBlock != nullptr) {
        emitBlock(*s.finallyBlock);
    }
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        emitThrowObject(obj);
    }
    // Normal / caught fall-through: the finally runs once here too.
    builder.SetInsertPoint(contBB);
    if (s.finallyBlock != nullptr) {
        emitBlock(*s.finallyBlock);
    }
}

void CodeGenerator::Impl::emitTry(const ast::TryStmt& s) {
    if (isItaniumEH()) {
        emitTryItanium(s);
        return;
    }
    ensurePersonality();
    llvm::PointerType* ptrTy = builder.getPtrTy();
    llvm::BasicBlock* ehpad = llvm::BasicBlock::Create(context, "ehpad", currentFn);
    llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "try.cont", currentFn);
    ehPadStack.push_back(ehpad);
    ehBaseStack.push_back({scopeObjects.size(), deferred.size(), scopeRegions.size()});
    // Pending finally for early exits (return/break/continue/try?) within the body
    // and catch handlers; popped before the normal-path finally at contBB.
    if (s.finallyBlock != nullptr) {
        finallyStack.push_back(s.finallyBlock.get());
    }
    emitBlock(s.body);
    ehPadStack.pop_back();
    ehBaseStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(contBB);
    }
    builder.SetInsertPoint(ehpad);
    llvm::Value* caughtSlot = createEntryAlloca("exc.caught", ptrTy);
    // An unmatched exception (the rethrow below) must reach the enclosing try if this try is
    // nested, else the caller -- so the catchswitch unwinds to the enclosing landing pad.
    llvm::BasicBlock* outerPad = ehPadStack.empty() ? nullptr : ehPadStack.back();
    llvm::CatchSwitchInst* cs =
        builder.CreateCatchSwitch(llvm::ConstantTokenNone::get(context), outerPad, 1);
    llvm::BasicBlock* dispatchBB =
        llvm::BasicBlock::Create(context, "catch.dispatch", currentFn);
    cs->addHandler(dispatchBB);
    builder.SetInsertPoint(dispatchBB);
    llvm::CatchPadInst* cp =
        builder.CreateCatchPad(cs, {ehTypeDesc(), builder.getInt32(0), caughtSlot});
    llvm::Value* obj = builder.CreateLoad(ptrTy, caughtSlot, "caught");
    llvm::Value* objVtbl = builder.CreateLoad(ptrTy, obj, "exc.vtbl");  // field 0 (polymorphic)
    for (const ast::CatchClause& cc : s.catches) {
        const std::string cty = baseType(typeRefName(cc.type));
        llvm::Value* match = nullptr;
        for (llvm::Constant* vt : subtypeVtables(cty)) {
            llvm::Value* eq = builder.CreateICmpEQ(objVtbl, vt, "is");
            match = (match == nullptr) ? eq : builder.CreateOr(match, eq, "or");
        }
        if (match == nullptr) {
            match = builder.getInt1(true);  // non-polymorphic: catch-all
        }
        llvm::BasicBlock* retBB = llvm::BasicBlock::Create(context, "catch.match", currentFn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "catch.next", currentFn);
        builder.CreateCondBr(match, retBB, nextBB);
        // Matched: bind e, leave the funclet, run the handler in normal context.
        builder.SetInsertPoint(retBB);
        llvm::Value* eSlot = createEntryAlloca(cc.name, ptrTy);
        builder.CreateStore(obj, eSlot);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "catch.body", currentFn);
        builder.CreateCatchRet(cp, bodyBB);
        builder.SetInsertPoint(bodyBB);
        const bool had = locals.count(cc.name) > 0;
        LocalSlot saved = had ? locals[cc.name] : LocalSlot{};
        locals[cc.name] = LocalSlot{eSlot, cty};
        emitBlock(cc.body);
        if (had) {
            locals[cc.name] = saved;
        } else {
            locals.erase(cc.name);
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(contBB);
        }
        builder.SetInsertPoint(nextBB);  // keep dispatching inside the funclet
    }
    // No clause matched: leave the funclet (catchret to normal context) so the
    // finally can run with ordinary calls, then re-throw the caught exception to
    // the enclosing try or the caller (spec 21.1: finally always runs).
    if (s.finallyBlock != nullptr) {
        finallyStack.pop_back();  // no longer pending for early exits
    }
    llvm::BasicBlock* rethrowBB = llvm::BasicBlock::Create(context, "rethrow", currentFn);
    builder.CreateCatchRet(cp, rethrowBB);
    builder.SetInsertPoint(rethrowBB);
    llvm::Value* rethrown = builder.CreateLoad(ptrTy, caughtSlot, "rethrow.obj");
    if (s.finallyBlock != nullptr) {
        emitBlock(*s.finallyBlock);  // uncaught path: finally runs
    }
    // A finally that itself threw already terminated the block, so skip the re-raise.
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        emitThrowObject(rethrown);
    }
    // Normal / caught fall-through: the finally runs once here too.
    builder.SetInsertPoint(contBB);
    if (s.finallyBlock != nullptr) {
        emitBlock(*s.finallyBlock);
    }
}

void CodeGenerator::Impl::runRegionObjectDtors(const std::string& name) {
    if (name.empty()) {
        return;
    }
    for (std::size_t i = scopeObjects.size(); i > 0; --i) {
        ScopeObject& so = scopeObjects[i - 1];
        if (so.region != name || so.className.empty()) {
            continue;
        }
        auto fnit = functions.find(so.className + ".~" + so.className);
        const bool weak = weakRelevant(so.className);
        if (fnit != functions.end() || weak) {
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), so.slot);
            if (fnit != functions.end()) {
                builder.CreateCall(fnit->second, {objPtr});
            }
            // A region target/holder dying with the arena: null every weak ref to it, unlink its own
            // weak slots -- before the block is released (17.7), so nothing dangles into freed arena.
            if (weak) {
                emitWeakCleanup(objPtr, so.className);
            }
        }
        so.className.clear();  // mark done
    }
}

std::vector<std::string> CodeGenerator::Impl::ownedRegionFieldsOf(const std::string& cn) {
    std::vector<std::string> out;
    auto cit = classes.find(clsKey(cn));
    if (cit == classes.end()) {
        return out;
    }
    // Keyed off `ownedFieldRegions_` rather than off the field's TYPE NAME: that set is exactly
    // "fields this class assigns `itself.allocate(...)` to, and never `itself.at(...)`", which IS
    // the definition of a region the object owns. A field pointed at MMIO with `at` is deliberately
    // not in it -- releasing a framebuffer aperture would be absurd.
    for (const auto& [fname, idx] : cit->second.fieldIndex) {
        if (ownedFieldRegions_.count(cn + "." + fname) > 0) {
            out.push_back(fname);
        }
    }
    return out;
}

void CodeGenerator::Impl::emitOwnedRegionFieldRelease(llvm::Value* objPtr, const std::string& cn) {
    auto cit = classes.find(clsKey(cn));
    if (cit == classes.end() || objPtr == nullptr) {
        return;
    }
    for (const std::string& fname : ownedRegionFieldsOf(cn)) {
        auto idx = cit->second.fieldIndex.find(fname);
        if (idx == cit->second.fieldIndex.end()) {
            continue;
        }
        llvm::Value* slot =
            builder.CreateStructGEP(cit->second.type, objPtr, idx->second, "rgnfield." + fname);
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "rgnfield.block");
        // A null block is a field never initialised (an early return in the constructor, say), and
        // the runtime's release already tolerates it -- but the teardown call does not, so guard.
        llvm::Function* f = currentFn;
        auto* liveBB = llvm::BasicBlock::Create(context, "rgnfield.live", f);
        auto* doneBB = llvm::BasicBlock::Create(context, "rgnfield.done", f);
        builder.CreateCondBr(
            builder.CreateICmpNE(block, llvm::ConstantPointerNull::get(builder.getPtrTy())),
            liveBB, doneBB);
        builder.SetInsertPoint(liveBB);
        // A field region always carries a registry (see `regionHasRegistry`), so its objects are
        // recorded at run time and torn down newest-first here.
        builder.CreateCall(regionTeardownFn(), {block});
        builder.CreateCall(regionReleaseFn(), {block});
        builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
        builder.CreateBr(doneBB);
        builder.SetInsertPoint(doneBB);
    }
}

void CodeGenerator::Impl::freeRegionsFrom(std::size_t base) {
    // Snapshot the objects' class names and restore them afterwards, exactly as `emitScopeCleanup`
    // does for `deferred` and for the same reason: this runs once per EXIT PATH, and
    // `runRegionObjectDtors` marks each object done by clearing its className -- a mutation of the
    // COMPILER's bookkeeping, not a runtime flag.
    //
    // Without restoring, the first `return` a function emits got the destructor calls and wiped the
    // names, and every later `return` saw an empty name and emitted nothing. A method with two
    // exits destructed its region objects on one of them and leaked on the other, silently, with
    // which one depending on source order. Adding an early return to a method -- turning a
    // `requires` into an `if (...) { return false; }`, say -- was enough to move which path got the
    // teardown.
    //
    // The clearing itself stays, and is still load-bearing for the OTHER caller: an explicit
    // `release region R` mid-function must stop the scope exit re-running those destructors on
    // memory it already freed.
    std::vector<std::string> savedNames;
    savedNames.reserve(scopeObjects.size());
    for (const ScopeObject& so : scopeObjects) {
        savedNames.push_back(so.className);
    }

    for (std::size_t i = scopeRegions.size(); i > base; --i) {
        const std::string& rname = scopeRegions[i - 1].name;
        runRegionObjectDtors(rname);  // destruct objects before freeing (17.7)
        llvm::Value* block =
            builder.CreateLoad(builder.getPtrTy(), scopeRegions[i - 1].slot, "region");
        // A region with a registry tears it down (every remaining destructor, newest-first, then the
        // registry itself); a ring destructs its live entries -- on scope exit and exception unwind
        // alike, so region objects are reclaimed either way (spec 17.7).
        const std::string rfl = flavorOfRegion(rname);
        if (regionHasRegistry(rname)) {
            builder.CreateCall(regionTeardownFn(), {block});
        } else if (isRingFlavor(rfl)) {
            builder.CreateCall(ringTeardownFn(), {block});
        }
        if (growableOfRegion(rname)) {
            builder.CreateCall(regionFreeChainFn(), {block});  // free the whole grown chain
        } else {
            builder.CreateCall(regionReleaseFn(), {block});  // cache the block for reuse (see runtime)
        }
    }
    for (std::size_t i = 0; i < scopeObjects.size() && i < savedNames.size(); ++i) {
        scopeObjects[i].className = savedNames[i];
    }
}

void CodeGenerator::Impl::scanLabelBlocks(const ast::Block& b) {
    for (const auto& sp : b.statements) {
        scanStmtLabels(sp.get(), b);
    }
}

void CodeGenerator::Impl::scanStmtLabels(const ast::Stmt* s, const ast::Block& owner) {
    if (s == nullptr) {
        return;
    }
    if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(s)) { labelBlock_[lm->name] = &owner; return; }
    // A comefrom may appear either side of its label in the text, so both directions have to be
    // known before either is emitted: the label needs to know it will be hijacked, and the hijack
    // needs the block that owns the landing site to tear scopes down correctly.
    if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(s)) {
        comefromTargets_.insert(cf->name);
        comefromBlock_[cf->name] = &owner;
        return;
    }
    if (const auto* is = dynamic_cast<const ast::IfStmt*>(s)) {
        scanLabelBlocks(is->thenBlock);
        if (is->elseBlock) {
            scanLabelBlocks(*is->elseBlock);
        }
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) { scanLabelBlocks(ws->body); return; }
    if (const auto* ds = dynamic_cast<const ast::DoWhileStmt*>(s)) { scanLabelBlocks(ds->body); return; }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) { scanLabelBlocks(fs->body); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) { scanLabelBlocks(fe->body); return; }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) { scanLabelBlocks(sy->body); return; }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(s)) { scanLabelBlocks(df->body); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(s)) { scanLabelBlocks(us->body); return; }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
        for (const auto& c : sw->cases) {
            scanLabelBlocks(c.body);
        }
        if (sw->defaultBody) {
            scanLabelBlocks(*sw->defaultBody);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
        for (const auto& c : ms->cases) {
            scanLabelBlocks(c.body);
        }
        if (ms->defaultBody) {
            scanLabelBlocks(*ms->defaultBody);
        }
        return;
    }
    if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) {
        scanLabelBlocks(ts->body);
        for (const auto& c : ts->catches) {
            scanLabelBlocks(c.body);
        }
        if (ts->finallyBlock) {
            scanLabelBlocks(*ts->finallyBlock);
        }
        return;
    }
    if (const auto* la = dynamic_cast<const ast::LabeledStmt*>(s)) { scanStmtLabels(la->stmt.get(), owner); return; }
}

void CodeGenerator::Impl::emitComefromCleanup(const std::string& name) {
    auto it = comefromBlock_.find(name);
    if (it == comefromBlock_.end()) {
        return;
    }
    const ast::Block* target = it->second;
    int fi = -1;
    for (int i = static_cast<int>(blockScopes.size()) - 1; i >= 0; --i) {
        if (blockScopes[i].block == target) { fi = i; break; }
    }
    if (fi < 0 || fi + 1 >= static_cast<int>(blockScopes.size())) {
        return;
    }
    const BlockScope& inner = blockScopes[fi + 1];
    emitBlockCleanup(inner.so, inner.df, inner.rg, inner.st, inner.vs);
}

void CodeGenerator::Impl::emitGotoScopeCleanup(const std::string& label) {
    auto lit = labelBlock_.find(label);
    if (lit == labelBlock_.end()) {
        return;
    }
    const ast::Block* target = lit->second;
    int fi = -1;
    for (int i = static_cast<int>(blockScopes.size()) - 1; i >= 0; --i) {
        if (blockScopes[i].block == target) { fi = i; break; }
    }
    if (fi < 0 || fi + 1 >= static_cast<int>(blockScopes.size())) {
        return;  // same scope / not open
    }
    const BlockScope& inner = blockScopes[fi + 1];  // first scope nested inside the label's scope
    emitBlockCleanup(inner.so, inner.df, inner.rg, inner.st, inner.vs);
}

void CodeGenerator::Impl::emitIf(const ast::IfStmt& s) {
    // `comptime if` (spec 37.4): fold the condition and emit only the taken branch;
    // the dead branch produces no code. The analyzer guaranteed the condition folds.
    if (s.isComptime) {
        long long c = 0;
        if (foldConstInt(*s.cond, c)) {
            if (c != 0) {
                emitBlock(s.thenBlock);
            } else if (s.elseBlock) {
                emitBlock(*s.elseBlock);
            }
            return;
        }
    }
    llvm::Value* condV = emitExpr(*s.cond);
    if (condV == nullptr) {
        return;
    }
    freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
    llvm::Value* condBool = asI1(condV);
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "if.then", fn);
    llvm::BasicBlock* elseBB =
        s.elseBlock ? llvm::BasicBlock::Create(context, "if.else", fn) : nullptr;
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "if.end", fn);
    builder.CreateCondBr(condBool, thenBB, elseBB != nullptr ? elseBB : endBB);

    builder.SetInsertPoint(thenBB);
    emitBlock(s.thenBlock);
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(endBB);
    }

    if (elseBB != nullptr) {
        builder.SetInsertPoint(elseBB);
        emitBlock(*s.elseBlock);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(endBB);
        }
    }
    builder.SetInsertPoint(endBB);
}

void CodeGenerator::Impl::emitValueMatch(const ast::MatchStmt& s, llvm::Value* subj) {
    llvm::Value* tag = builder.CreateExtractValue(subj, {0u}, "var.tag");
    llvm::Value* payload = builder.CreateExtractValue(subj, {1u}, "var.pl");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "match.end", fn);
    for (const ast::MatchCase& c : s.cases) {
        const int caseTag = (c.typeName == "Ok" || c.typeName == "Some") ? 0 : 1;
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "match.case", fn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "match.next", fn);
        builder.CreateCondBr(builder.CreateICmpEQ(tag, builder.getInt32(caseTag), "is"), bodyBB,
                             nextBB);
        builder.SetInsertPoint(bodyBB);
        std::string added;
        bool hadPrior = false;
        LocalSlot prior{};
        if (!c.bindings.empty()) {
            const std::string bt = typeRefName(c.bindings[0].type);
            llvm::Type* bty = llvmType(bt);
            llvm::Value* slot = createEntryAlloca(c.bindings[0].name, bty);
            builder.CreateStore(variantDecode(payload, bty), slot);
            if (auto pit = locals.find(c.bindings[0].name); pit != locals.end()) {
                hadPrior = true;
                prior = pit->second;
            }
            locals[c.bindings[0].name] = LocalSlot{slot, bt};
            added = c.bindings[0].name;
        }
        emitBlock(c.body);
        if (!added.empty()) {
            locals.erase(added);
            if (hadPrior) {
                locals[added] = prior;
            }
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(endBB);
        }
        builder.SetInsertPoint(nextBB);
    }
    if (s.defaultBody) {
        emitBlock(*s.defaultBody);
    }
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(endBB);
    }
    builder.SetInsertPoint(endBB);
}

void CodeGenerator::Impl::emitMatch(const ast::MatchStmt& s) {
    llvm::Value* subj = emitExpr(*s.subject);
    if (subj == nullptr) {
        return;
    }
    if (isValueVariant(typeName(*s.subject))) { emitValueMatch(s, subj); return; }
    if (auto en = enums.find(baseType(typeName(*s.subject))); en != enums.end()) {
        // The same repair as `emitMatchExpr`: an enum is matched on its ordinal, and a java-style
        // value is a singleton that has to be asked which one it is.
        llvm::Value* ord = subj->getType()->isIntegerTy()
                               ? subj
                               : emitJavaEnumOrdinal(subj, baseType(typeName(*s.subject)));
        emitEnumMatch(s, ord, en->second);
        return;
    }
    auto sit = classes.find(clsKey(typeName(*s.subject)));
    if (sit == classes.end() || !sit->second.hasVtable) {
        error("match subject must be a polymorphic class", s.loc);
        return;
    }
    llvm::Value* vtblAddr = builder.CreateStructGEP(sit->second.type, subj, 0, "vtbl.addr");
    llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblAddr, "vtbl");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "match.end", fn);
    const std::string mSubjBase = baseType(typeName(*s.subject));
    const auto mDollar = mSubjBase.find('$');  // map bare case name to the subject instantiation
    for (const ast::MatchCase& c : s.cases) {
        // Prefer the subject's instantiation (Ok -> Ok$int) but fall back to the bare name for a
        // non-generic concrete subclass of a generic base (Leaf extends Base<int>).
        std::string caseType = c.typeName;
        if (mDollar != std::string::npos && classes.count(c.typeName + mSubjBase.substr(mDollar)) > 0) {
            caseType = c.typeName + mSubjBase.substr(mDollar);
        }
        auto cit = classes.find(caseType);
        if (cit == classes.end() || cit->second.vtable == nullptr) {
            continue;
        }
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "match.case", fn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "match.next", fn);
        builder.CreateCondBr(builder.CreateICmpEQ(vtbl, cit->second.vtable, "is"), bodyBB, nextBB);
        builder.SetInsertPoint(bodyBB);
        // Bind positional fields: binding[i] <- the case type's own field[i].
        std::vector<std::string> added;
        std::vector<std::pair<std::string, LocalSlot>> prior;  // shadowed outer locals
        for (std::size_t i = 0; i < c.bindings.size() && i < cit->second.ownFields.size(); ++i) {
            const std::string& fname = cit->second.ownFields[i].first;
            const std::string ftype = cit->second.fieldType.count(fname) > 0
                                          ? cit->second.fieldType[fname]
                                          : cit->second.ownFields[i].second;
            llvm::Value* fptr =
                builder.CreateStructGEP(cit->second.type, subj, cit->second.fieldIndex[fname]);
            llvm::Value* val = builder.CreateLoad(llvmType(ftype), fptr, fname);
            llvm::Value* slot = createEntryAlloca(c.bindings[i].name, llvmType(ftype));
            builder.CreateStore(val, slot);
            if (auto pit = locals.find(c.bindings[i].name); pit != locals.end()) {
                prior.push_back({c.bindings[i].name, pit->second});
            }
            locals[c.bindings[i].name] = LocalSlot{slot, ftype};
            added.push_back(c.bindings[i].name);
        }
        emitBlock(c.body);
        for (const std::string& n : added) {
            locals.erase(n);  // bindings are case-scoped
        }
        for (const auto& [n, s] : prior) {
            locals[n] = s;  // restore shadowed outer locals
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(endBB);
        }
        builder.SetInsertPoint(nextBB);
    }
    if (s.defaultBody) {
        emitBlock(*s.defaultBody);
    }
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(endBB);
    }
    builder.SetInsertPoint(endBB);
}

llvm::Value* CodeGenerator::Impl::emitYieldBlock(const ast::Block& body, llvm::Type* rty, const std::string& rtype) {
    llvm::Value* slot = createEntryAlloca("matchx.arm", rty);
    builder.CreateStore(llvm::Constant::getNullValue(rty), slot);
    llvm::BasicBlock* armEnd = llvm::BasicBlock::Create(context, "matchx.arm.end", currentFn);
    llvm::Value* sSlot = yieldSlot_;
    llvm::BasicBlock* sEnd = yieldEnd_;
    std::string sTy = yieldType_;
    yieldSlot_ = slot;
    yieldEnd_ = armEnd;
    yieldType_ = rtype;
    emitBlock(body, /*newScope=*/true);
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(armEnd);
    }
    yieldSlot_ = sSlot;
    yieldEnd_ = sEnd;
    yieldType_ = sTy;
    builder.SetInsertPoint(armEnd);
    return builder.CreateLoad(rty, slot, "matchx.arm.val");
}

llvm::Value* CodeGenerator::Impl::emitValueMatchExpr(const ast::MatchExpr& s, llvm::Value* subj) {
    const std::string rtype = s.resultType.empty() ? std::string("int") : s.resultType;
    llvm::Type* rty = llvmType(rtype);
    llvm::Value* tag = builder.CreateExtractValue(subj, {0u}, "var.tag");
    llvm::Value* payload = builder.CreateExtractValue(subj, {1u}, "var.pl");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "matchx.end", fn);
    std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> incoming;
    for (const ast::MatchCase& c : s.cases) {
        const int caseTag = (c.typeName == "Ok" || c.typeName == "Some") ? 0 : 1;
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "matchx.case", fn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "matchx.next", fn);
        builder.CreateCondBr(builder.CreateICmpEQ(tag, builder.getInt32(caseTag), "is"), bodyBB,
                             nextBB);
        builder.SetInsertPoint(bodyBB);
        std::string added;
        bool hadPrior = false;
        LocalSlot prior{};
        if (!c.bindings.empty()) {
            const std::string bt = typeRefName(c.bindings[0].type);
            llvm::Type* bty = llvmType(bt);
            llvm::Value* slot = createEntryAlloca(c.bindings[0].name, bty);
            builder.CreateStore(variantDecode(payload, bty), slot);
            if (auto pit = locals.find(c.bindings[0].name); pit != locals.end()) {
                hadPrior = true;
                prior = pit->second;
            }
            locals[c.bindings[0].name] = LocalSlot{slot, bt};
            added = c.bindings[0].name;
        }
        llvm::Value* v;
        if (c.result) {
            v = emitExpr(*c.result);
            if (v != nullptr) {
                v = coerce(v, typeName(*c.result), rtype);
            }
        } else {
            v = emitYieldBlock(c.body, rty, rtype);
        }
        if (!added.empty()) {
            locals.erase(added);
            if (hadPrior) {
                locals[added] = prior;
            }
        }
        if (v == nullptr) {
            v = llvm::Constant::getNullValue(rty);
        }
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
        builder.SetInsertPoint(nextBB);
    }
    builder.CreateUnreachable();  // sema guarantees a sealed value match is exhaustive
    builder.SetInsertPoint(endBB);
    if (incoming.empty()) {
        return llvm::Constant::getNullValue(rty);
    }
    llvm::PHINode* phi = builder.CreatePHI(rty, static_cast<unsigned>(incoming.size()), "matchx");
    for (auto& in : incoming) {
        phi->addIncoming(in.first, in.second);
    }
    return phi;
}

// An enum subject, as an EXPRESSION: one arm per constant, each yielding a value, and a phi over
// them. The same comparison of ordinals the statement form does -- an enum value IS its ordinal --
// with the arms producing values instead of running blocks.
llvm::Value* CodeGenerator::Impl::emitEnumMatchExpr(const ast::MatchExpr& s, llvm::Value* subj,
                                                    const std::vector<std::string>& constants) {
    const std::string rtype = s.resultType.empty() ? std::string("int") : s.resultType;
    llvm::Type* rty = llvmType(rtype);
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "matchx.end", fn);
    std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> incoming;
    for (const ast::MatchCase& c : s.cases) {
        const auto at = std::find(constants.begin(), constants.end(), c.typeName);
        if (at == constants.end()) {
            continue;  // the analyzer has already refused this
        }
        const long long ord = std::distance(constants.begin(), at);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "matchx.case", fn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "matchx.next", fn);
        llvm::Value* want = llvm::ConstantInt::get(subj->getType(), ord);
        builder.CreateCondBr(builder.CreateICmpEQ(subj, want, "is"), bodyBB, nextBB);
        builder.SetInsertPoint(bodyBB);
        llvm::Value* v;
        if (c.result) {
            v = emitExpr(*c.result);
            if (v != nullptr) {
                v = coerce(v, typeName(*c.result), rtype);
            }
        } else {
            v = emitYieldBlock(c.body, rty, rtype);
        }
        if (v == nullptr) {
            v = llvm::Constant::getNullValue(rty);
        }
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
        builder.SetInsertPoint(nextBB);
    }
    if (s.defaultResult) {
        llvm::Value* v = emitExpr(*s.defaultResult);
        v = (v == nullptr) ? llvm::Constant::getNullValue(rty)
                           : coerce(v, typeName(*s.defaultResult), rtype);
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
    } else if (s.defaultBody) {
        llvm::Value* v = emitYieldBlock(*s.defaultBody, rty, rtype);
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
    } else {
        // Sema guarantees a sealed enum's match covers every constant, so the fall-through of the
        // last comparison is a place the program cannot reach.
        builder.CreateUnreachable();
    }
    builder.SetInsertPoint(endBB);
    if (incoming.empty()) {
        return llvm::Constant::getNullValue(rty);
    }
    llvm::PHINode* phi = builder.CreatePHI(rty, static_cast<unsigned>(incoming.size()), "matchx");
    for (auto& in : incoming) {
        phi->addIncoming(in.first, in.second);
    }
    return phi;
}

llvm::Value* CodeGenerator::Impl::emitMatchExpr(const ast::MatchExpr& s) {
    llvm::Value* subj = emitExpr(*s.subject);
    if (subj == nullptr) {
        return nullptr;
    }
    if (isValueVariant(typeName(*s.subject))) {
        return emitValueMatchExpr(s, subj);
    }
    if (auto en = enums.find(baseType(typeName(*s.subject))); en != enums.end()) {
        // AN ENUM SUBJECT IS MATCHED ON ITS ORDINAL, whichever kind of enum it is. An int-style
        // constant already IS the ordinal; a java-style one is a cached singleton, so ask which
        // singleton it is. Only the first was handled, and the second fell through to the
        // polymorphic-class path below -- which found the twin class, then skipped every arm,
        // because the case names are enum CONSTANTS and there is no class called `Slow`. Nothing
        // was reported: the match simply had no arm to land in, and the program trapped before it
        // printed a line. See `emitMatch` for the same repair.
        llvm::Value* ord = subj->getType()->isIntegerTy()
                               ? subj
                               : emitJavaEnumOrdinal(subj, baseType(typeName(*s.subject)));
        return emitEnumMatchExpr(s, ord, en->second);
    }
    auto sit = classes.find(clsKey(typeName(*s.subject)));
    if (sit == classes.end() || !sit->second.hasVtable) {
        error("match subject must be a polymorphic class", s.loc);
        return nullptr;
    }
    const std::string rtype = s.resultType.empty() ? std::string("int") : s.resultType;
    llvm::Type* rty = llvmType(rtype);
    llvm::Value* vtblAddr = builder.CreateStructGEP(sit->second.type, subj, 0, "vtbl.addr");
    llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblAddr, "vtbl");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "matchx.end", fn);
    std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> incoming;
    const std::string mSubjBase = baseType(typeName(*s.subject));
    const auto mDollar = mSubjBase.find('$');  // map bare case name to the subject instantiation
    for (const ast::MatchCase& c : s.cases) {
        // Prefer the subject's instantiation (Ok -> Ok$int), else the bare name (a non-generic
        // concrete subclass of a generic base).
        std::string caseType = c.typeName;
        if (mDollar != std::string::npos && classes.count(c.typeName + mSubjBase.substr(mDollar)) > 0) {
            caseType = c.typeName + mSubjBase.substr(mDollar);
        }
        auto cit = classes.find(caseType);
        if (cit == classes.end() || cit->second.vtable == nullptr) {
            continue;
        }
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "matchx.case", fn);
        llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "matchx.next", fn);
        builder.CreateCondBr(builder.CreateICmpEQ(vtbl, cit->second.vtable, "is"), bodyBB, nextBB);
        builder.SetInsertPoint(bodyBB);
        std::vector<std::string> added;
        std::vector<std::pair<std::string, LocalSlot>> prior;  // shadowed outer locals
        for (std::size_t i = 0; i < c.bindings.size() && i < cit->second.ownFields.size(); ++i) {
            const std::string& fname = cit->second.ownFields[i].first;
            const std::string ftype = cit->second.fieldType.count(fname) > 0
                                          ? cit->second.fieldType[fname]
                                          : cit->second.ownFields[i].second;
            llvm::Value* fptr =
                builder.CreateStructGEP(cit->second.type, subj, cit->second.fieldIndex[fname]);
            llvm::Value* val = builder.CreateLoad(llvmType(ftype), fptr, fname);
            llvm::Value* slot = createEntryAlloca(c.bindings[i].name, llvmType(ftype));
            builder.CreateStore(val, slot);
            if (auto pit = locals.find(c.bindings[i].name); pit != locals.end()) {
                prior.push_back({c.bindings[i].name, pit->second});
            }
            locals[c.bindings[i].name] = LocalSlot{slot, ftype};
            added.push_back(c.bindings[i].name);
        }
        llvm::Value* v;
        if (c.result) {
            v = emitExpr(*c.result);
            if (v != nullptr) {
                v = coerce(v, typeName(*c.result), rtype);  // typeName needs bindings
            }
        } else {
            v = emitYieldBlock(c.body, rty, rtype);  // `-> { ... yield ...; }` block arm
        }
        for (const std::string& n : added) {
            locals.erase(n);  // bindings are arm-scoped
        }
        for (const auto& [n, s] : prior) {
            locals[n] = s;  // restore shadowed outer locals
        }
        if (v == nullptr) {
            v = llvm::Constant::getNullValue(rty);  // error recovery
        }
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
        builder.SetInsertPoint(nextBB);
    }
    if (s.defaultResult) {
        llvm::Value* v = emitExpr(*s.defaultResult);
        v = (v == nullptr) ? llvm::Constant::getNullValue(rty)
                           : coerce(v, typeName(*s.defaultResult), rtype);
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
    } else if (s.defaultBody) {
        llvm::Value* v = emitYieldBlock(*s.defaultBody, rty, rtype);  // `default -> { yield }`
        incoming.push_back({v, builder.GetInsertBlock()});
        builder.CreateBr(endBB);
    } else {
        builder.CreateUnreachable();  // sema guarantees a sealed match is exhaustive
    }
    builder.SetInsertPoint(endBB);
    if (incoming.empty()) {
        return llvm::Constant::getNullValue(rty);
    }
    llvm::PHINode* phi = builder.CreatePHI(rty, static_cast<unsigned>(incoming.size()), "matchx");
    for (auto& in : incoming) {
        phi->addIncoming(in.first, in.second);
    }
    return phi;
}

}  // namespace polaron
