#include "codegen/codegen_impl.h"

namespace polaron {

void CodeGenerator::Impl::emitStatement(const ast::Stmt& stmt) {
    // No code after a terminator (statements following break/continue/return are dead). The two
    // exceptions are the two LANDING points: `label name;` must place its block so a hijack can be
    // triggered there, and `comefrom name;` must place its block because control arrives from the
    // label -- not from the statement above it, which is exactly why an unreachable-looking position
    // is the normal place to write one.
    if (builder.GetInsertBlock()->getTerminator() != nullptr &&
        dynamic_cast<const ast::LabelMarkStmt*>(&stmt) == nullptr &&
        dynamic_cast<const ast::ComefromStmt*>(&stmt) == nullptr) {
        return;
    }
    setDebugLoc(stmt.loc);  // -g: this statement's line, so breakpoints/stepping map to source
    // static_assert is a compile-time check (spec 28.2); it emits no code. The analyzer already
    // checked every condition it could fold, and deferred exactly those mentioning `sizeof` --
    // a size is only knowable against the target's layout, which exists here and nowhere
    // earlier. Re-checking only the deferred ones keeps each assertion reported once.
    if (const auto* sa = dynamic_cast<const ast::DemandStmt*>(&stmt)) {
        if (comptime::mentionsSizeof(*sa->condition)) {
            if (long long v = 0; !foldConstInt(*sa->condition, v)) {
                error("a demand is settled while the program is built, so its condition has to "
                      "be known then -- this one is not constant", sa->loc);
            } else if (v == 0) {
                error("demand not met: " + sa->message, sa->loc);
            }
        }
        return;
    }
    if (const auto* br = dynamic_cast<const ast::BreakStmt*>(&stmt)) {
        if (const LoopTargets* t = findLoop(br->label)) {
            llvm::BasicBlock* target = t->brk;
            const std::size_t so = t->soBase, df = t->dfBase, rg = t->regBase;
            emitPendingFinallys(t->finallyDepth);  // run finallys of try regions left by break
            emitBlockCleanup(so, df, rg);  // run destructors/defers/region-frees of loop scopes
            if (builder.GetInsertBlock()->getTerminator() == nullptr) {
                builder.CreateBr(target);
            }
        }
        return;
    }
    if (const auto* co = dynamic_cast<const ast::ContinueStmt*>(&stmt)) {
        if (const LoopTargets* t = findLoop(co->label)) {
            llvm::BasicBlock* target = t->cont;
            const std::size_t so = t->soBase, df = t->dfBase, rg = t->regBase;
            emitPendingFinallys(t->finallyDepth);
            emitBlockCleanup(so, df, rg);  // tear down this iteration's loop-body scopes
            if (builder.GetInsertBlock()->getTerminator() == nullptr) {
                builder.CreateBr(target);
            }
        }
        return;
    }
    if (const auto* lbl = dynamic_cast<const ast::LabeledStmt*>(&stmt)) {
        pendingLoopLabel = lbl->label;
        emitStatement(*lbl->stmt);
        return;
    }
    // `label name;` -- place a target block; fall into it (spec 7.10). comefrom can jump here.
    if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(&stmt)) {
        llvm::BasicBlock*& bb = labelBlocks[lm->name];
        if (bb == nullptr) {
            bb = llvm::BasicBlock::Create(context, "label." + lm->name, currentFn);
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(bb);
        }
        builder.SetInsertPoint(bb);
        // `abstainfrom` (spec 7.11): if the label is ever abstained anywhere, guard
        // its block -- while the runtime counter is non-zero, skip the guarded code
        // (to the method's end). Labels never abstained get no guard (unchanged).
        const std::string akey =
            enclosingClass_ + "." + enclosingMethod_ + "." + lm->name;  // class.method.label
        if (abstainedLabels.count(akey) > 0) {
            // Atomic load pairs with the atomic abstain/reinstate RMW so a concurrent toggle
            // (e.g. from an ISR) is seen with the right ordering (spec 7.11 memory barrier).
            llvm::LoadInst* c =
                builder.CreateLoad(builder.getInt32Ty(), abstainCounter(akey), "abstain.c");
            c->setAlignment(llvm::Align(4));
            c->setAtomic(llvm::AtomicOrdering::SequentiallyConsistent);
            llvm::BasicBlock* body = llvm::BasicBlock::Create(context, "label.on", currentFn);
            llvm::BasicBlock* skip = llvm::BasicBlock::Create(context, "label.off", currentFn);
            builder.CreateCondBr(builder.CreateICmpNE(c, builder.getInt32(0)), skip, body);
            builder.SetInsertPoint(skip);
            // While abstained, skip the guarded region. Its end is the NEXT top-level label (spec
            // 7.11): branch there so control resumes at that label (whose own guard then runs). Only
            // if there is no next label does the region run to the method end (default return).
            if (auto nit = nextAbstainLabel_.find(akey); nit != nextAbstainLabel_.end()) {
                llvm::BasicBlock*& nb = labelBlocks[nit->second];
                if (nb == nullptr) {
                    nb = llvm::BasicBlock::Create(context, "label." + nit->second, currentFn);
                }
                builder.CreateBr(nb);
            } else {
                emitDefaultReturn();  // no next label: the region runs to the method end
            }
            builder.SetInsertPoint(body);
        }
        // THE HIJACK (spec 7.10). If some `comefrom name;` elsewhere in this method names this
        // label, then REACHING the label transfers control there -- and the statements that follow
        // the label never run. That inversion is the whole point of comefrom: the jump is written at
        // the destination, and the label site does not mention it. It reads as action at a distance
        // because it IS action at a distance.
        //
        // Emitted after the abstain guard, so abstaining a label also suspends its hijack: while the
        // section is off, reaching the label skips to the next one rather than being stolen.
        if (comefromTargets_.count(lm->name) > 0) {
            emitComefromCleanup(lm->name);
            llvm::BasicBlock*& cb = comefromBlocks[lm->name];
            if (cb == nullptr) {
                cb = llvm::BasicBlock::Create(context, "comefrom." + lm->name, currentFn);
            }
            builder.CreateBr(cb);
            // Anything after the label is unreachable on this path; give it a block so the code that
            // follows still verifies.
            builder.SetInsertPoint(
                llvm::BasicBlock::Create(context, "label.stolen." + lm->name, currentFn));
        }
        return;
    }
    // `comefrom name;` -- NOT a jump. It marks WHERE control lands when flow reaches `label name;`
    // (spec 7.10). Falling into it in the ordinary way is a no-op: execution simply continues, which
    // is what makes it a declaration about the label rather than a statement that does something.
    //
    // It used to emit `br label.name`, i.e. it was a goto spelled backwards -- the label was the
    // destination instead of the source. That is the opposite of what comefrom means.
    if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(&stmt)) {
        llvm::BasicBlock*& bb = comefromBlocks[cf->name];
        if (bb == nullptr) {
            bb = llvm::BasicBlock::Create(context, "comefrom." + cf->name, currentFn);
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(bb);
        }
        builder.SetInsertPoint(bb);
        return;
    }
    if (const auto* g = dynamic_cast<const ast::GotoStmt*>(&stmt)) {  // spec 7.9
        llvm::FunctionType* voidFn = llvm::FunctionType::get(builder.getVoidTy(), {}, false);
        if (g->address != nullptr) {  // `goto 0x1000` -- raw control transfer; does not return
            llvm::Value* a = emitExpr(*g->address);
            if (a == nullptr) {
                return;
            }
            llvm::Value* fp = builder.CreateIntToPtr(fitInt(a, 64), builder.getPtrTy());
            builder.CreateCall(voidFn, fp, {});
            builder.CreateUnreachable();
            return;
        }
        if (auto fit = functions.find(g->name); fit != functions.end()) {  // goto externFn (FFI)
            builder.CreateCall(voidFn, fit->second, {});  // call as void(); does not return
            builder.CreateUnreachable();
            return;
        }
        // `goto label;` -- branch to the label's block in the same method. First run the cleanup for
        // any scopes this jump leaves (defers + destructors), so goto-out-of-scope doesn't leak.
        emitGotoScopeCleanup(g->name);
        llvm::BasicBlock*& bb = labelBlocks[g->name];
        if (bb == nullptr) {
            bb = llvm::BasicBlock::Create(context, "label." + g->name, currentFn);
        }
        builder.CreateBr(bb);
        return;
    }
    if (const auto* ab = dynamic_cast<const ast::AbstainfromStmt*>(&stmt)) {  // spec 7.11
        // Adjust the label's runtime reference counter; the guard at `label name;` skips the
        // guarded code while the counter is non-zero. The key is the current method's
        // "class.method.label" (intra-method), so same-named labels in other methods are distinct.
        const std::string akey = enclosingClass_ + "." + enclosingMethod_ + "." + ab->name;
        llvm::GlobalVariable* ctr = abstainCounter(akey);
        // Atomic so multiple sources (incl. concurrent ones) stack correctly; compiles to a bare
        // atomic instruction (no runtime), so this is freestanding-safe (spec 7.11).
        builder.CreateAtomicRMW(
            ab->isReinstate ? llvm::AtomicRMWInst::Sub : llvm::AtomicRMWInst::Add, ctr,
            builder.getInt32(1), llvm::MaybeAlign(4),
            llvm::AtomicOrdering::SequentiallyConsistent);
        return;
    }
    if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(&stmt)) {  // throw expr; (spec 21.1)
        llvm::Value* obj = emitExpr(*th->value);
        if (obj == nullptr) {
            return;
        }
        emitThrowObject(obj);
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(&stmt)) {
        emitTry(*tr);
        return;
    }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(&stmt)) {
        emitIf(*ifs);
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(&stmt)) {
        emitMatch(*ms);
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(&stmt)) {
        emitWhile(*ws);
        return;
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&stmt)) {
        emitDoWhile(*dw);
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(&stmt)) {
        emitFor(*fs);
        return;
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(&stmt)) {
        emitForeach(*fe);
        return;
    }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(&stmt)) {
        emitSwitch(*sw);
        return;
    }
    if (const auto* td = dynamic_cast<const ast::TupleDeclStmt*>(&stmt)) {
        // Evaluate the tuple value once, then bind each component to a local.
        llvm::Value* agg = emitExpr(*td->init);
        if (agg == nullptr) {
            return;
        }
        const std::vector<std::string> comps = tupleElems(typeName(*td->init));
        for (std::size_t i = 0; i < td->bindings.size(); ++i) {
            const std::string bt = typeRefName(td->bindings[i].type);
            llvm::Value* v = builder.CreateExtractValue(agg, {static_cast<unsigned>(i)});
            if (i < comps.size()) {
                v = coerce(v, comps[i], bt);
            }
            llvm::Value* slot = createEntryAlloca(td->bindings[i].name, llvmType(bt));
            builder.CreateStore(v, slot);
            locals[td->bindings[i].name] = LocalSlot{slot, bt};
        }
        return;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
        // DECLARED WITHOUT A VALUE (`int x;`). The slot exists; nothing is stored into it, not even
        // a zero -- the *uninitialized* state is a real state, and materialising it as 0 would erase
        // the distinction the analyzer just spent its effort keeping (a zero is a value; this is the
        // absence of one). Writing no initializer costs no instruction, and it is SAFE precisely
        // because the analyzer proved no path reads the slot before something assigns to it.
        //
        // A class-typed slot is the one exception: it is left as a null pointer so that scope
        // teardown, which walks the live stack objects, finds nothing to destruct rather than a
        // garbage address. `region r;` keeps its own long-standing path further down.
        // `comptime T x = <constexpr>;` (spec 37.4): the value is computed during compilation and
        // embedded -- no code runs for it. This was parsed, recorded and then read by nobody, so
        // `comptime int a = Main.fib(10)` emitted a real `call @Main.fib(i32 10)` and stored the
        // result, which is the one thing the prefix promises will not happen. The analyzer has
        // already refused any initializer that does not fold, so a miss here can only be a scalar
        // shape this folder does not cover, and the ordinary path below is then right.
        if (vd->isComptime && vd->init != nullptr && !vd->isVar) {
            const std::string dt = typeRefName(vd->type);
            llvm::Type* lty = llvmType(dt);
            llvm::Constant* folded = nullptr;
            if (isFloatType(dt)) {
                double d = 0;
                if (foldConstDouble(*vd->init, d)) {
                    folded = llvm::ConstantFP::get(lty, d);
                }
            } else {
                long long v = 0;
                if (foldConstInt(*vd->init, v)) {
                    folded = llvm::ConstantInt::get(lty, static_cast<std::uint64_t>(v), true);
                }
            }
            if (folded != nullptr) {
                llvm::Value* slot = createEntryAlloca(vd->name, lty);
                builder.CreateStore(folded, slot);
                locals[vd->name] = LocalSlot{slot, dt};
                return;
            }
        }
        if (vd->init == nullptr && !vd->isVar && typeRefName(vd->type) != "region") {
            const std::string dt = typeRefName(vd->type);
            llvm::Type* lty = llvmType(dt);
            llvm::Value* slot = createEntryAlloca(vd->name, lty);
            if (lty->isPointerTy()) {
                builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
            }
            locals[vd->name] = LocalSlot{slot, dt};
            return;
        }
        const std::string declType = vd->isVar ? typeName(*vd->init) : typeRefName(vd->type);
        // Inside an async/generator state machine the local already lives in the heap state
        // object (pre-bound); just evaluate the initializer and store it, so it survives a suspend.
        if (asyncSM || genSM) {
            auto it = locals.find(vd->name);
            if (it != locals.end()) {
                // The async/gen fast-path pre-binds each local to a field in the coroutine state
                // object, but must still do the type-specific setup the sync path does, or region and
                // value-struct locals break across a suspend:
                //  - BUG 8: a `region` local needs its flavor/growable recorded and pending-flavor set
                //    so `itself.allocate` lays the right descriptor and its objects get tracked (else a
                //    later rollback runs no destructors).
                //  - BUG 7: a value-struct `new ... on stack` lives on THIS resume invocation's stack,
                //    which is gone once the await returns; heap-promote it (and deep-copy a copy-init)
                //    so the state field's pointer stays valid across the suspend/resume split.
                const bool isRegion = (it->second.type == "region");
                if (isRegion) {
                    if (!vd->regionFlavor.empty()) {
                        regionFlavor_[vd->name] = vd->regionFlavor;
                    }
                    if (vd->regionGrowable) {
                        growableRegions_.insert(vd->name);
                    }
                    pendingRegionFlavor_ = vd->regionFlavor;
                    pendingRegionGrowable_ = vd->regionGrowable;
                }
                if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
                    nw != nullptr && nw->location == "stack" && nw->region.empty() &&
                    isClassValue(it->second.type)) {
                    const_cast<ast::NewExpr*>(nw)->location = "heap";
                }
                llvm::Value* v = emitExpr(*vd->init);
                if (isRegion) { pendingRegionFlavor_.clear(); pendingRegionGrowable_ = false; }
                if (v != nullptr) {
                    if (isClassValue(it->second.type) && isCopyDiscipline(it->second.type) &&
                        isCopyableLValue(*vd->init)) {
                        v = emitClassCopy(it->second.type, v, /*heap=*/true);
                    }
                    builder.CreateStore(coerceToType(v, llvmType(it->second.type)),
                                        it->second.storage);
                    // A heap-owned value struct in the coroutine state has no destructor and nothing
                    // else frees it -- track it so the coroutine/scope exit reclaims its block and
                    // owned fields (B9). A region-targeted `new` is excluded (the region reclaims it);
                    // a call-returned struct is not owned here.
                    if (isClassValue(it->second.type) && isCopyDiscipline(it->second.type)) {
                        const auto* initNw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
                        const bool heapOwned = (initNw != nullptr && initNw->region.empty()) ||
                                               (initNw == nullptr && isCopyableLValue(*vd->init));
                        if (heapOwned) {
                            scopeValueStructs.push_back({it->second.storage, it->second.type});
                        }
                    }
                }
                if (isRegion && !vd->isEternal) {
                    scopeRegions.push_back(RegionLocal{it->second.storage, vd->isEternal, vd->name});
                }
                return;
            }
        }
        // Lazy local (spec 37.3): allocate storage now (a safe null/zero) plus an
        // "initialized" flag, but defer the initializer until the first read.
        // A lazy region defers its backing allocation, not an identifier read, so it is handled
        // below (the generic lazy-local read guard does not fire for `new ... in region`).
        if (vd->isLazy && declType != "region") {
            llvm::Type* lty = llvmType(declType);
            llvm::Value* storage = createEntryAlloca(vd->name, lty);
            builder.CreateStore(llvm::Constant::getNullValue(lty), storage);
            llvm::Value* flag = createEntryAlloca(vd->name + ".lazy", builder.getInt1Ty());
            builder.CreateStore(builder.getInt1(false), flag);
            LocalSlot slot;
            slot.storage = storage;
            slot.type = declType;
            slot.lazyFlag = flag;
            slot.lazyInit = vd->init.get();
            locals[vd->name] = slot;
            return;
        }
        // Persistent local (spec 18): lives in a disk-backed global keyed by function +
        // name, so it keeps its value across calls AND across runs. The initializer seeds
        // the global once; we never re-store it on entry -- that omission is the reattach.
        if (vd->isPersistent) {
            const std::string key =
                (currentFn != nullptr ? currentFn->getName().str() : std::string()) +
                "." + vd->name;
            llvm::Type* lty = llvmType(declType);
            if (staticGlobals.count(key) == 0) {
                llvm::Constant* init = constFold(*vd->init, declType);
                if (init == nullptr) {
                    init = llvm::Constant::getNullValue(lty);
                }
                staticGlobals[key] = new llvm::GlobalVariable(
                    module, lty, /*isConstant=*/false,
                    llvm::GlobalValue::PrivateLinkage, init, key);
            }
            locals[vd->name] = LocalSlot{staticGlobals[key], declType};
            return;
        }
        // An object with persistent fields bound to a named variable: pass the identity key
        // to emitNew so it wires the object's persistent block before the constructor runs.
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
            auto cit = classes.find(ast::mangleGeneric(nw->className, nw->typeArgs));
            if (cit != classes.end() && cit->second.persistPtrIdx != 0) {
                pendingPersistKey =
                    (currentFn != nullptr ? currentFn->getName().str() : std::string()) +
                    "." + vd->name;
            }
        }
        // Region flavor (spec 17, flavors expansion): record this region local's reclaim strategy so
        // new/delete/extract/release dispatch on it. pool/fixedslot serve reclaimable slots via the
        // runtime and do NOT get the inline bump cursor (that stays the bump/stack fast path).
        if (declType == "region" && !vd->regionFlavor.empty()) {
            regionFlavor_[vd->name] = vd->regionFlavor;
        }
        if (declType == "region" && vd->regionGrowable) {
            growableRegions_.insert(vd->name);
        }
        // atMultiple (spec 17.4): a multi-range region over fixed addresses. Record the ranges plus
        // one bump used-counter per range; there is no malloc'd block to free.
        //
        // OUTSIDE the `lazy` branch, which is where this used to live -- so a plain
        // `region r = itself.atMultiple(...)` registered no ranges at all, every `new T in region r`
        // fell through to the ordinary bump path, and the objects were written just past a 24-byte
        // header block. The routing this construct exists for simply did not happen, and nothing
        // said so: the test printed the right numbers while overrunning the heap. `lazy` has nothing
        // to do with it -- a multi-range region has no backing block, so there is nothing to defer.
        if (declType == "region") {
            if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                ri != nullptr && !ri->ranges.empty()) {
                llvm::Value* slot = createEntryAlloca(vd->name, builder.getPtrTy());
                builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
                locals[vd->name] = LocalSlot{slot, "region"};
                multiRegionRanges_[vd->name] = &ri->ranges;
                std::vector<llvm::Value*> useds;
                for (std::size_t i = 0; i < ri->ranges.size(); ++i) {
                    llvm::Value* u = createEntryAlloca(
                        vd->name + "#used" + std::to_string(i), builder.getInt64Ty());
                    builder.CreateStore(builder.getInt64(0), u);
                    useds.push_back(u);
                }
                multiRegionUsed_[vd->name] = std::move(useds);
                return;
            }
        }
        // `lazy region` (spec 37.3): defer the backing allocation until the first object
        // enters. Store null now and remember the size/address to replay on first use.
        if (declType == "region" && vd->isLazy) {
            if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get())) {
                llvm::Value* slot = createEntryAlloca(vd->name, builder.getPtrTy());
                builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
                locals[vd->name] = LocalSlot{slot, "region"};
                lazyRegions_.insert(vd->name);
                lazyRegionSize_[vd->name] = ri->size.get();
                lazyRegionAt_[vd->name] = ri->atAddress.get();
                if (vd->isVolatile) {
                    volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO)
                }
                // An owned lazy region keeps its bump cursor in a register-promotable alloca; the
                // lazy-acquire block re-zeros it each time the backing block is (re)allocated.
                if (ri->atAddress.get() == nullptr && !usesRuntimeDesc(vd->regionFlavor) &&
                    !vd->regionGrowable) {
                    setupOwnedRegionCursor(vd->name);
                }
                if (!vd->isEternal) {
                    scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
                }
                return;
            }
        }
        // Empty-state region (spec 17.2 form 3): `region r;` with no initializer declares an
        // unallocated region (null block) that a later `r = itself.allocate(...)` fills via the
        // ordinary assignment path. Unlike a lazy region there is no remembered size, so it is NOT
        // put in lazyRegions_; scope-end free(null) is harmless if it is never allocated.
        if (declType == "region" && vd->init == nullptr) {
            llvm::Value* slot = createEntryAlloca(vd->name, builder.getPtrTy());
            builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
            locals[vd->name] = LocalSlot{slot, "region", vd->isVolatile};
            if (vd->isVolatile) {
                volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO)
            }
            if (!vd->isEternal) {
                scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
            }
            return;
        }
        // Thread the region flavor into the init expr's RegionInitExpr (the flavor lives on the
        // VarDecl, not the init). Cleared right after so it never leaks into an unrelated allocate.
        if (declType == "region") {
            pendingRegionFlavor_ = vd->regionFlavor;
            pendingRegionGrowable_ = vd->regionGrowable;
        }
        llvm::Value* initV = emitExpr(*vd->init);
        pendingRegionFlavor_.clear();
        pendingRegionGrowable_ = false;
        pendingPersistKey.clear();
        if (initV == nullptr) {
            return;
        }
        // Value semantics: copying a class value from an existing object makes
        // an independent copy; binding a fresh `new`/pointer/`move` does not,
        // and movable/unique disciplines transfer instead of copying.
        if (isClassValue(declType) && isCopyDiscipline(declType) &&
            isCopyableLValue(*vd->init)) {
            // A copy bound to a local that is later returned escapes the frame, so it must live on
            // the heap; otherwise the frame's alloca is fine (escape analysis, mirrors the `new`
            // promotion). Over-promotion to the heap is always safe.
            initV = emitClassCopy(declType, initV,
                                  /*heap=*/escapingLocals_.count(vd->name) > 0);
        }
        initV = coerce(initV, typeName(*vd->init), declType);  // int -> float widening
        // String RAII (spec 4): a `String` or mutable `string` local owns its own buffer (deep-copy
        // on init, distinct from any source or freed-at-statement-end temporary) and is freed at scope
        // exit. Both share one representation, so both take this path -- unlike `String*`/`String&` (an
        // alias) or `String[]` (the array owns its elements). Copy-on-init also isolates a `string`
        // from its source so a later in-place append never aliases it. Reassignment frees the old
        // buffer first (the String assign path), so the copy here never double-frees.
        bool declIsString = (declType == "String" || declType == "string");
        if (declIsString) {
            initV = emitStringCopy(initV);
        }
        llvm::Value* slot = createEntryAlloca(vd->name, llvmType(declType));
        builder.CreateStore(initV, slot, vd->isVolatile);  // spec 37.5
        locals[vd->name] = LocalSlot{slot, declType, vd->isVolatile};
        if (declIsString) {
            scopeStrings.push_back(slot);
        }
        declareLocalDebug(slot, vd->name, declType, vd->loc);  // -g: name/read this local in the debugger
        // An eagerly-allocated owned region (`region r = itself.allocate(...)`): give it a
        // register-promotable bump cursor, zeroed now that its block is freshly acquired.
        // (pool/fixedslot/stack/ring and any growable region use the runtime allocator, not an inline
        // cursor -- no cursor for them.)
        if (declType == "region" && isOwnedRegionInit(vd->init.get()) &&
            !usesRuntimeDesc(vd->regionFlavor) && !vd->regionGrowable) {
            setupOwnedRegionCursor(vd->name);
        }
        // A ring region records its single element type's destructor (from `.accepts({T})`), so
        // eviction of the oldest entry and release can run it. Set once, here at the declaration.
        if (declType == "region" && isRingFlavor(vd->regionFlavor)) {
            llvm::Value* dtor = llvm::ConstantPointerNull::get(builder.getPtrTy());
            if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                ri != nullptr && !ri->accepts.empty()) {
                const std::string acn = baseType(ri->accepts[0]);
                if (auto cit = classes.find(acn); cit != classes.end() && cit->second.hasDestructor) {
                    dtor = functions[acn + ".~" + acn];
                }
            }
            llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
            builder.CreateCall(ringSetDtorFn(), {block, dtor});
        }
        // RAII: a freshly built `new ... on stack` object with a destructor gets cleaned up
        // when the function returns -- unless it is `eternal` (spec 37.2: lives for the whole
        // program, no cleanup).
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
            auto cit = classes.find(nw->className);
            // Every stack object, whether or not anything needs destructing. `delete` has to be able
            // to tell a stack address from a heap one, and it is the ONLY thing this set is for --
            // deriving that from the destructor list meant a class with no destructor was invisible
            // to `delete`, which then freed a stack pointer into libc.
            if (cit != classes.end() && nw->region.empty() && nw->location == "stack") {
                stackObjectSlots_.insert(slot);
            }
            // Track for scope-exit teardown if it has a destructor OR any weak state OR owns a
            // `region` field. The weak case: a dtor-less weak target must still null its weak refs
            // when its stack/region storage dies, and a dtor-less holder must unlink its weak slots,
            // or a `weak T*` to a stack object would dangle.
            //
            // The region case was the other half of the region-field leak. `emitBlockCleanup` asks
            // this question again and handles a dtor-less owner correctly -- but it only ever sees
            // objects that got REGISTERED here, and registration demanded a destructor. So the fix
            // there could not fire, and a class holding a region and no destructor leaked its whole
            // region on every scope exit. Silently, and precisely against the promise a region
            // makes: that its storage lives exactly as long as its owner. Neither half works alone.
            if (cit != classes.end() && !vd->isEternal &&
                (cit->second.hasDestructor || weakRelevant(nw->className) ||
                 !ownedRegionFieldsOf(nw->className).empty())) {
                // A region object's destructor runs when the region is released/freed (spec
                // 17.7); a plain stack object's runs at scope exit. A heap object is manual.
                // An object in a region with a REGISTRY, or in a ring, is NOT tracked here: the
                // runtime owns its teardown, so scopeObjects would destruct it a second time.
                const std::string rfl = flavorOfRegion(nw->region);
                if (!nw->region.empty() && !regionHasRegistry(nw->region) && !isRingFlavor(rfl)) {
                    scopeObjects.push_back(ScopeObject{slot, nw->className, nw->region});
                } else if (nw->region.empty() && nw->location == "stack") {
                    zeroStackObjectSlot(slot);  // abstain/skip past this decl -> null -> no dtor on uninit
                    scopeObjects.push_back(ScopeObject{slot, nw->className, ""});
                }
            }
            // An object placed in a `volatile region` (MMIO): its field accesses are volatile.
            if (!nw->region.empty() && volatileRegions_.count(nw->region) > 0) {
                volatileObjects_.insert(vd->name);
            }
        } else if (isClassValue(declType) && isCopyDiscipline(declType) &&
                   isCopyableLValue(*vd->init) && !vd->isEternal &&
                   escapingLocals_.count(vd->name) == 0) {
            // A copy-initialized local (T b = a;) is a deep copy this frame uniquely owns -- it lives
            // on the stack here (an escaping copy was promoted to the heap and is excluded). Register
            // it for scope-exit destruction so it does not leak, exactly like a `new ... on stack`
            // object; same ownership and same accepted this-escape risk as any stack object.
            const std::string cn = baseType(declType);
            if (auto cit = classes.find(cn);
                cit != classes.end() &&
                (cit->second.hasDestructor || weakRelevant(cn) || !ownedRegionFieldsOf(cn).empty())) {
                scopeObjects.push_back(ScopeObject{slot, cn, ""});
            }
        }
        // RAII for regions (spec 17.7): freed at the end of the lexical block
        // unless eternal. An explicit `release region` nulls the slot first, so
        // the scope-end free is a harmless free(null).
        if (declType == "region" && !vd->isEternal) {
            scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
        }
        if (declType == "region" && vd->isVolatile) {
            volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO): volatile object accesses
        }
        freeStringTemps();  // String RAII: the initializer's owned temporaries die here (slot holds a copy)
        return;
    }
    if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
        // `weak T*` field assignment: don't just overwrite the slot -- unlink it from the OLD pointee's
        // weak-list and link it into the NEW one, so the pointee auto-nulls this field when it dies. The
        // slot's first word IS the pointer, so plain reads still see the pointee.
        if (const auto* wt = dynamic_cast<const ast::MemberExpr*>(assign->target.get());
            wt != nullptr && fieldIsWeak(baseType(typeName(*wt->object)), wt->member)) {
            llvm::Value* slot = emitLValue(*wt);   // address of the field == the WeakSlot address
            llvm::Value* nv = emitExpr(*assign->value);
            if (nv != nullptr) {
                nv = coerce(nv, typeName(*assign->value), typeName(*wt));
            }
            llvm::Value* off = weakHeadOffset(baseType(typeName(*wt)));  // T's weak-list head offset
            builder.CreateCall(weakUnlinkFn(), {slot, off});
            if (nv != nullptr) {
                llvm::Value* nn = builder.CreateICmpNE(
                    nv, llvm::ConstantPointerNull::get(builder.getPtrTy()));
                llvm::Function* fn = currentFn;
                auto* linkBB = llvm::BasicBlock::Create(context, "weak.link", fn);
                auto* doneBB = llvm::BasicBlock::Create(context, "weak.done", fn);
                builder.CreateCondBr(nn, linkBB, doneBB);
                builder.SetInsertPoint(linkBB);
                builder.CreateCall(weakLinkFn(), {slot, nv, off});
                builder.CreateBr(doneBB);
                builder.SetInsertPoint(doneBB);
            }
            freeStringTemps();
            return;
        }
        // operator[]= overload: obj[i] = v -> obj.operator[]=(i, v) (spec 6.5).
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(assign->target.get())) {
            const std::string owner = methodOwner(baseType(typeName(*ix->array)), "operator[]=");
            auto fnit = owner.empty() ? functions.end()
                                      : functions.find(owner + ".operator[]=");
            if (fnit != functions.end()) {
                llvm::Value* recv = emitExpr(*ix->array);
                llvm::Value* idx = emitExpr(*ix->index);
                llvm::Value* val = emitExpr(*assign->value);
                if (recv == nullptr || idx == nullptr || val == nullptr) {
                    return;
                }
                if (fnit->second->arg_size() >= 3) {
                    idx = coerceToType(idx, fnit->second->getArg(1)->getType());
                    val = coerceToType(val, fnit->second->getArg(2)->getType());
                }
                emitMaybeInvoke(fnit->second, {recv, idx, val});
                return;
            }
        }
        // Property with a custom setter (spec 8.4): `obj.prop = v` routes through the setter
        // method, except inside the setter itself (which writes the backing field directly).
        if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
            const std::string oc = baseType(typeName(*mt->object));
            if (auto cit = classes.find(oc); cit != classes.end()) {
                const std::string setterName = propertySetterName(oc, mt->member);
                if (!setterName.empty()) {
                    const std::string owner = methodOwner(oc, setterName);
                    const std::string setterFn = owner + "." + setterName;
                    const bool inOwnSetter =
                        currentFn != nullptr && currentFn->getName().str() == setterFn;
                    if (!inOwnSetter) {
                        if (auto fnit = functions.find(setterFn); fnit != functions.end()) {
                            llvm::Value* recv = emitObjectPtr(*mt->object);
                            llvm::Value* val = emitExpr(*assign->value);
                            if (recv == nullptr || val == nullptr) {
                                return;
                            }
                            // Dispatch through the vtable when a subtype may override the setter --
                            // just like the getter and any method -- so `base.prop = v` runs the
                            // most-derived setter; a concrete un-subclassed receiver stays a direct
                            // call.
                            const ast::MethodDecl* sdecl = findMethodDecl(oc, setterName);
                            const bool mayBeSubtype =
                                subclassed_.count(oc) > 0 || cit->second.isInterface ||
                                cit->second.isAbstract || cit->second.imported;
                            const int slot = slotIndex(oc, setterName);
                            if (sdecl != nullptr && cit->second.hasVtable && mayBeSubtype && slot >= 0) {
                                llvm::Value* vtblField =
                                    builder.CreateStructGEP(cit->second.type, recv, 0, "vtbl.addr");
                                llvm::Value* vtbl =
                                    builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
                                llvm::Type* vtArrTy = llvm::ArrayType::get(
                                    builder.getPtrTy(), cit->second.vtslots.size());
                                llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                                    vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "slot");
                                llvm::Value* fnPtr =
                                    builder.CreateLoad(builder.getPtrTy(), slotPtr, "fn");
                                llvm::FunctionType* fty = methodFnType(sdecl);
                                if (fty->getNumParams() >= 2) {
                                    val = coerceToType(val, fty->getParamType(1));
                                }
                                builder.CreateCall(fty, fnPtr, {recv, val});
                                return;
                            }
                            if (fnit->second->arg_size() >= 2) {
                                val = coerceToType(val, fnit->second->getArg(1)->getType());
                            }
                            builder.CreateCall(fnit->second, {recv, val});
                            return;
                        }
                    }
                }
            }
        }
        const std::string targetType = typeName(*assign->target);
        // SIMD lane write: v[i] = x or v.x = 5 mutate one lane of a vector value in place -- load the
        // vector from its storage, insert the element at the lane, and store it back.
        {
            const ast::Expr* vecObj = nullptr;
            llvm::Value* laneIdx = nullptr;
            if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(assign->target.get())) {
                if (vecWidth(typeName(*ix->array)) > 0) {
                    vecObj = ix->array.get();
                    laneIdx = emitExpr(*ix->index);
                }
            } else if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
                if (int lane = vecLane(mt->member); vecWidth(typeName(*mt->object)) > 0 && lane >= 0) {
                    vecObj = mt->object.get();
                    laneIdx = builder.getInt32(lane);
                }
            }
            if (vecObj != nullptr && laneIdx != nullptr) {
                llvm::Value* slot = emitLValue(*vecObj);
                llvm::Value* val = emitExpr(*assign->value);
                if (slot == nullptr || val == nullptr) {
                    return;
                }
                llvm::Value* cur = builder.CreateLoad(llvmType(typeName(*vecObj)), slot, "vec.cur");
                val = coerceToType(val, builder.getFloatTy());
                laneIdx = builder.CreateSExtOrTrunc(laneIdx, builder.getInt32Ty());
                builder.CreateStore(builder.CreateInsertElement(cur, val, laneIdx), slot);
                return;
            }
        }
        // atomic<T> assignment (spec 20.6): `counter = counter +/- n` -> atomicrmw add/sub;
        // any other `counter = v` -> atomic store of the value cell. But binding the atomic object
        // itself (`field = new atomic<int>(n)`, or `a = b` between two atomics) is a plain reference
        // store, not a value write -- so only take this path when the value is NOT an atomic object.
        if (baseType(targetType).rfind("atomic$", 0) == 0 &&
            baseType(typeName(*assign->value)).rfind("atomic$", 0) != 0) {
            llvm::Value* obj = emitObjectPtr(*assign->target);
            if (obj == nullptr) {
                return;
            }
            auto cit = classes.find(clsKey(targetType));
            llvm::Value* vp = builder.CreateStructGEP(
                cit->second.type, obj, cit->second.fieldIndex["value"], "atomic.value");
            llvm::Type* et = llvmType(baseType(targetType).substr(7));
            llvm::Align al(et->getPrimitiveSizeInBits() / 8);
            const auto seqcst = llvm::AtomicOrdering::SequentiallyConsistent;
            // Recognise `counter +/- delta` where one side reads the same atomic target.
            const ast::Expr* delta = nullptr;
            bool sub = false;
            const auto* tId = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get());
            if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(assign->value.get());
                bin != nullptr && tId != nullptr) {
                auto same = [&](const ast::Expr* e) {
                    const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e);
                    return id != nullptr && id->name == tId->name;
                };
                if (bin->op == "+" && same(bin->lhs.get())) {
                    delta = bin->rhs.get();
                } else if (bin->op == "+" && same(bin->rhs.get())) {
                    delta = bin->lhs.get();
                } else if (bin->op == "-" && same(bin->lhs.get())) {
                    delta = bin->rhs.get();
                    sub = true;
                }
            }
            if (delta != nullptr) {
                llvm::Value* d = emitExpr(*delta);
                if (d == nullptr) {
                    return;
                }
                builder.CreateAtomicRMW(sub ? llvm::AtomicRMWInst::Sub : llvm::AtomicRMWInst::Add,
                                        vp, d, al, seqcst);
                return;
            }
            llvm::Value* v = emitExpr(*assign->value);
            if (v == nullptr) {
                return;
            }
            llvm::StoreInst* st = builder.CreateStore(v, vp);
            st->setAtomic(seqcst);
            st->setAlignment(al);
            return;
        }
        // Persistent reattach by array index (spec 18.5): `arr[i] = new T()` for a persistent-bearing
        // T keys the object's block by (array identity, runtime index) so the persistent fields
        // reattach across a delete at that slot, rather than getting a fresh anonymous block.
        pendingPersistIndex = nullptr;
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(assign->target.get())) {
            if (const auto* arrId = dynamic_cast<const ast::IdentifierExpr*>(ix->array.get())) {
                if (const auto* nw = dynamic_cast<const ast::NewExpr*>(assign->value.get())) {
                    auto pcit = classes.find(ast::mangleGeneric(nw->className, nw->typeArgs));
                    if (pcit != classes.end() && pcit->second.persistPtrIdx != 0) {
                        pendingPersistKey =
                            (currentFn != nullptr ? currentFn->getName().str() : std::string()) +
                            "." + arrId->name;
                        pendingPersistIndex = emitExpr(*ix->index);
                    }
                }
            }
        }
        // A value-struct / value-class field or array element is an owned heap child (spec 11 /
        // 37.1): its slot holds a pointer to a separately-allocated object. A plain `new X()`
        // defaults to the stack (parser default), so storing it into such a slot would leave the
        // field pointing at the constructor's reclaimed frame -> garbage / heap corruption. Promote
        // a directly-assigned stack `new X()` to the heap, exactly as a returned `new` is promoted
        // (see ReturnStmt), so the owned child stays live. Region-targeted news keep their region.
        if ((dynamic_cast<const ast::MemberExpr*>(assign->target.get()) != nullptr ||
             dynamic_cast<const ast::IndexExpr*>(assign->target.get()) != nullptr) &&
            isClassValue(targetType)) {
            if (const auto* anw = dynamic_cast<const ast::NewExpr*>(assign->value.get());
                anw != nullptr && anw->location == "stack" && anw->region.empty()) {
                const_cast<ast::NewExpr*>(anw)->location = "heap";
            }
        }
        llvm::Value* slot = emitLValue(*assign->target);
        if (slot == nullptr) {
            return;
        }
        // A `this.field = itself.allocate(...)` init of a flavored region field: thread the field's
        // flavor/growth into the RegionInitExpr RHS so it lays out the right header (spec 17 fields).
        if (targetType == "region") {
            if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
                if (const ast::FieldDecl* fd = regionFieldDecl("this." + mt->member)) {
                    pendingRegionFlavor_ = fd->regionFlavor;
                    pendingRegionGrowable_ = fd->regionGrowable;
                    pendingRegionRegistry_ = regionHasRegistry("this." + mt->member);
                }
            }
        }
        llvm::Value* v = emitExpr(*assign->value);
        pendingRegionFlavor_.clear();
        pendingRegionGrowable_ = false;
        pendingRegionRegistry_ = false;
        if (v == nullptr) {
            return;
        }
        pendingPersistIndex = nullptr;  // defensive: never leak into the next new
        // An array element that is a VALUE AGGREGATE is inline: the slot IS the bytes, not a
        // pointer to them. Copy the struct into place. Storing a pointer here -- which is what
        // every other field/element path does, correctly, because their slots hold references --
        // would write an address over the first eight bytes of the element and leave the rest of
        // it untouched, which reads back as garbage in the first two fields and stale in the rest.
        if (dynamic_cast<const ast::IndexExpr*>(assign->target.get()) != nullptr) {
            if (llvm::StructType* est = inlineElemStructTy(targetType)) {
                emitMemcpy(slot, v, sizeOf(est));
                // Owned children (arrays, Strings, nested value structs) are duplicated so the two
                // elements do not share them -- assignment is a copy, all the way down.
                for (const auto& [fname, ftype] : collectFields(targetType)) {
                    const unsigned idx = classes[targetType].fieldIndex[fname];
                    llvm::Value* deep = nullptr;
                    if (isArrayType(ftype)) {
                        deep = emitArrayDup(builder.CreateLoad(builder.getPtrTy(),
                                                               builder.CreateStructGEP(est, v, idx)),
                                            elementOf(ftype));
                    } else if (ftype == "String") {
                        deep = emitStringCopy(builder.CreateLoad(builder.getPtrTy(),
                                                                 builder.CreateStructGEP(est, v, idx)));
                    } else if (isClassValue(ftype) && isCopyDiscipline(ftype)) {
                        deep = emitClassCopy(ftype,
                                             builder.CreateLoad(builder.getPtrTy(),
                                                                builder.CreateStructGEP(est, v, idx)),
                                             /*heap=*/true);
                    }
                    if (deep != nullptr) {
                        builder.CreateStore(deep, builder.CreateStructGEP(est, slot, idx));
                    }
                }
                return;
            }
        }
        // Value semantics: assigning a class value makes the target an independent copy.
        const bool tgtFieldOrElem =
            dynamic_cast<const ast::MemberExpr*>(assign->target.get()) != nullptr ||
            dynamic_cast<const ast::IndexExpr*>(assign->target.get()) != nullptr;
        // A value struct produced by an rvalue (e.g. a method's or operator's sret return) lives in
        // a stack slot in this frame; storing it straight into a field/array element -- which
        // outlives the frame -- would dangle. Deep-copy such a struct rvalue into the owned heap
        // slot too. (A `new` RHS is already heap-promoted above; a copyable lvalue is handled by the
        // existing branch; a local target is same-frame, so it needs neither.)
        const bool structRvalueToSlot =
            tgtFieldOrElem && isClassValue(targetType) && isCopyDiscipline(targetType) &&
            classes.count(targetType) > 0 && classes[targetType].isStruct &&
            dynamic_cast<const ast::NewExpr*>(assign->value.get()) == nullptr;
        if (isClassValue(targetType) && isCopyDiscipline(targetType) &&
            (isCopyableLValue(*assign->value) || structRvalueToSlot)) {
            if (tgtFieldOrElem) {
                // A class-value field or array element is a pointer slot with no backing object
                // (a fresh array's elements are null), so deep-copy into a fresh heap object and
                // store the pointer rather than memcpy'ing into a (possibly null) existing object.
                // (Freeing the slot's previous value here is unsound without ownership tracking --
                // it may be shared or non-heap -- so the old value is left; see the M3 note.)
                builder.CreateStore(emitClassCopy(targetType, v, /*heap=*/true), slot);
            } else {
                // A local already has a backing object (from its declaration). Free the storage it
                // currently owns (its old copy dies -- value semantics), then deep-copy the source
                // directly into it: shallow-copy the bytes and duplicate the owned fields in place.
                // No temporary object is allocated, and the target's old owned arrays do not leak.
                llvm::Value* destStruct = builder.CreateLoad(builder.getPtrTy(), slot);
                // Self-assignment (b = b, or b = an alias of b) must be a no-op: freeing the target's
                // storage and then reading the source back would be a use-after-free. Only free +
                // deep-copy when the source and destination are distinct objects.
                llvm::Function* vfn = builder.GetInsertBlock()->getParent();
                llvm::BasicBlock* copyBB = llvm::BasicBlock::Create(context, "vcopy", vfn);
                llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "vcopy.done", vfn);
                builder.CreateCondBr(builder.CreateICmpEQ(v, destStruct), doneBB, copyBB);
                builder.SetInsertPoint(copyBB);
                emitFreeOwnedFields(targetType, destStruct);
                llvm::StructType* tst = classes[targetType].type;
                emitMemcpy(destStruct, v, sizeOf(tst));
                for (const auto& [fname, ftype] : collectFields(targetType)) {
                    const unsigned idx = classes[targetType].fieldIndex[fname];
                    llvm::Value* deep = nullptr;
                    if (isArrayType(ftype)) {
                        deep = emitArrayDup(builder.CreateLoad(builder.getPtrTy(),
                                                               builder.CreateStructGEP(tst, v, idx)),
                                            elementOf(ftype));
                    } else if (isClassValue(ftype) && isCopyDiscipline(ftype)) {
                        deep = emitClassCopy(ftype,
                                             builder.CreateLoad(builder.getPtrTy(),
                                                                builder.CreateStructGEP(tst, v, idx)),
                                             /*heap=*/true);
                    }
                    if (deep != nullptr) {
                        builder.CreateStore(deep, builder.CreateStructGEP(tst, destStruct, idx));
                    }
                }
                builder.CreateBr(doneBB);
                builder.SetInsertPoint(doneBB);
            }
        } else {
            llvm::Value* sv = coerce(v, typeName(*assign->value), targetType);
            // String RAII: assigning a `String` or mutable `string` deep-copies so the target owns an
            // independent buffer (value semantics; spec 4). For a tracked local we also free its
            // previous copy first -- sound because copy-on-store guarantees the slot owned a fresh,
            // unshared, heap buffer (null-safe; the fresh copy is distinct from the old value, so a
            // self-assign is fine too). The RHS producer temp is freed at the statement end below.
            if (targetType == "String" || targetType == "string") {
                sv = emitStringCopy(sv);
                const ast::Expr* tgt = assign->target.get();
                if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(tgt)) {
                    if (auto lit = locals.find(tid->name);
                        lit != locals.end() && isTrackedStringSlot(lit->second.storage)) {
                        builder.CreateCall(strFreeFn(),
                                           {builder.CreateLoad(builder.getPtrTy(), lit->second.storage)});
                    }
                } else if (dynamic_cast<const ast::MemberExpr*>(tgt) != nullptr ||
                           dynamic_cast<const ast::IndexExpr*>(tgt) != nullptr) {
                    // M3: a String field/element owns its buffer (copy-on-store), so free the previous
                    // one before overwriting -- otherwise reassignment leaks it (e.g. a per-frame
                    // `this.field = producer()`). Null-safe: owned String fields are null-defaulted and
                    // `new String[n]()` is zero-initialized, and the fresh copy above is distinct from
                    // the old value, so a self-assign `f = f` is still correct.
                    builder.CreateCall(strFreeFn(), {builder.CreateLoad(builder.getPtrTy(), slot)});
                }
            }
            if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
                // A packed bit field shares its storage unit with its neighbours, so writing it is
                // a read-modify-write of the unit, not a store. Doing this here rather than letting
                // the store below run is the whole difference between `version = 3` setting four
                // bits and it wiping the three fields sitting beside them.
                if (const std::string bfOwner = bitFieldOwner(*mt); !bfOwner.empty()) {
                    emitBitFieldStore(slot, bfOwner, mt->member, sv,
                                      isVolatileAccess(*assign->target));
                    return;
                }
                // A narrow `A*` field stores the offset, not the pointer -- for the same reason as
                // above: letting the plain store below run would write 8 bytes into a 4-byte slot and
                // take the next field with it.
                if (const std::string nt = narrowTargetClass(typeName(*mt)); !nt.empty()) {
                    emitNarrowStore(slot, sv, nt, isVolatileAccess(*assign->target));
                    return;
                }
                sv = maskBitField(sv, typeName(*mt->object), mt->member);  // bit-field (spec 11.1)
            }
            // A boolean array element occupies 1 byte; narrow the i32 boolean value before storing.
            if (targetType == "boolean") {
                if (const auto* tix = dynamic_cast<const ast::IndexExpr*>(assign->target.get())) {
                    if (!isRefType(typeName(*tix->array))) {
                        sv = builder.CreateTrunc(sv, builder.getInt8Ty());
                    }
                }
            }
            llvm::StoreInst* st =
                builder.CreateStore(sv, slot, isVolatileAccess(*assign->target));  // spec 37.5
            // A raw pointer `p[i] = v` may target ANY address (spec 17.8): store with `align 1` so a
            // misaligned write is defined, not UB (same single instruction on x86; volatile-safe).
            if (const auto* tix = dynamic_cast<const ast::IndexExpr*>(assign->target.get())) {
                if (isRefType(typeName(*tix->array))) {
                    st->setAlignment(llvm::Align(1));
                }
            }
            // Reassigning an owned region a fresh block (`r = itself.allocate(...)`, including filling
            // an empty-state region): (re)zero its register bump cursor so allocations restart at 0.
            if (targetType == "region") {
                if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
                    if (isOwnedRegionInit(assign->value.get())) {
                        setupOwnedRegionCursor(tid->name);
                    }
                }
            }
        }
        freeStringTemps();  // String RAII: release owned temporaries at the statement boundary
        return;
    }
    if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
        // atomic<T> ++ / -- lowers to a lock-free atomicrmw add/sub of 1 (spec 20.6).
        if (const std::string at = baseType(typeName(*incdec->target));
            at.rfind("atomic$", 0) == 0) {
            llvm::Value* obj = emitObjectPtr(*incdec->target);
            if (obj == nullptr) {
                return;
            }
            auto cit = classes.find(at);
            llvm::Value* vp = builder.CreateStructGEP(
                cit->second.type, obj, cit->second.fieldIndex["value"], "atomic.value");
            llvm::Type* et = llvmType(at.substr(7));
            builder.CreateAtomicRMW(
                incdec->isIncrement ? llvm::AtomicRMWInst::Add : llvm::AtomicRMWInst::Sub, vp,
                llvm::ConstantInt::get(et, 1), llvm::Align(et->getPrimitiveSizeInBits() / 8),
                llvm::AtomicOrdering::SequentiallyConsistent);
            return;
        }
        // operator ++ / -- overload (spec 6.5): the user's operator returns the new value; store it
        // back into the target. A unary operator takes only `this` (arg_size 1).
        {
            const std::string tt = baseType(typeName(*incdec->target));
            const std::string opName = incdec->isIncrement ? "operator++" : "operator--";
            const std::string owner = methodOwner(tt, opName);
            if (!owner.empty()) {
                auto fnit = functions.find(owner + "." + opName);
                const bool opSret = fnit != functions.end() && sretFns_.count(fnit->second) > 0;
                // No explicit params: arg count 1 (`this`), or 2 when the operator returns a value
                // struct (a trailing sret result slot is appended). The bare `== 1` skipped
                // struct-returning ++/-- overloads (spec 6.5/11) and fell through to the builtin path.
                if (fnit != functions.end() &&
                    fnit->second->arg_size() == (opSret ? 2u : 1u)) {
                    llvm::Value* recv = emitExpr(*incdec->target);
                    if (recv == nullptr) {
                        return;
                    }
                    llvm::Value* res = emitMaybeInvoke(fnit->second, {recv});
                    llvm::Value* dst = emitLValue(*incdec->target);
                    if (dst != nullptr) {
                        if (opSret) {
                            // `c++` == `c = c.operator++()`: the overload returns a fresh value struct
                            // in an sret temp. Move it into the target's backing storage (value
                            // semantics): free the target's old owned fields first -- otherwise an
                            // owned String/array/child-struct in the previous value leaks -- then
                            // memcpy the new bytes in. The temp is abandoned, so its owned fields
                            // transfer to the target with no deep copy and no double free.
                            llvm::Value* destStruct = builder.CreateLoad(builder.getPtrTy(), dst);
                            emitFreeOwnedFields(tt, destStruct);
                            emitMemcpy(destStruct, res, sizeOf(classes[tt].type));
                        } else {
                            builder.CreateStore(res, dst);
                        }
                    }
                    return;
                }
            }
        }
        const std::string itn = typeName(*incdec->target);
        llvm::Type* ty = llvmType(itn);
        llvm::Value* slot = emitLValue(*incdec->target);
        if (slot == nullptr) {
            return;
        }
        // A packed bit field: read it out of its unit, step it, put it back. Going through the plain
        // load/store below would read its neighbours' bits as part of the value and then overwrite
        // them -- `++` on one field silently editing the ones next to it.
        if (const auto* bfm = dynamic_cast<const ast::MemberExpr*>(incdec->target.get())) {
            if (const std::string bfOwner = bitFieldOwner(*bfm); !bfOwner.empty()) {
                const bool vol = isVolatileAccess(*incdec->target);
                llvm::Value* was = emitBitFieldLoad(slot, bfOwner, bfm->member, vol);
                llvm::Value* stepped =
                    incdec->isIncrement
                        ? builder.CreateAdd(was, llvm::ConstantInt::get(was->getType(), 1))
                        : builder.CreateSub(was, llvm::ConstantInt::get(was->getType(), 1));
                emitBitFieldStore(slot, bfOwner, bfm->member, stepped, vol);
                return;
            }
        }
        llvm::Value* cur = builder.CreateLoad(ty, slot);
        // Pointer arithmetic (spec 27): `p++` steps by one ELEMENT, not one byte -- an integer add
        // on a pointer value is not even valid IR. The analyzer already warned about doing this to a
        // pointer-to-class.
        if (isRefType(itn)) {
            // The element type matches what `p[i]` indexes by, so `p++; *p` and `p[1]` always agree.
            llvm::Value* res = builder.CreateGEP(
                llvmType(baseType(itn)), cur,
                {builder.getInt64(incdec->isIncrement ? 1 : -1)}, "ptr.step");
            builder.CreateStore(res, slot);
            return;
        }
        llvm::Value* one = llvm::ConstantInt::get(ty, 1);
        llvm::Value* res =
            incdec->isIncrement ? builder.CreateAdd(cur, one) : builder.CreateSub(cur, one);
        // A bit field keeps only its declared width, and `=` and `+=` both masked -- this path did
        // not, so `f.nibble++` on a 4-bit field holding 15 stored 16. The width is part of the
        // field's type; which statement wrote it cannot change what it can hold.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(incdec->target.get())) {
            res = maskBitField(res, baseType(typeName(*mem->object)), mem->member);
        }
        builder.CreateStore(res, slot);
        return;
    }
    if (const auto* um = dynamic_cast<const ast::UnimportStmt*>(&stmt)) {
        // A namespace/bundle target (spec 30.1) expands to every type it contains; an individual
        // target is just itself.
        for (const std::string& cn : unimportGroupTargets(*um)) {
            if (!um->isReimport) {
                emitUnimportClass(cn);
            } else {
                // reimport (spec 30.3): restore the ripped-out code from the .exe on disk,
                // then re-enable the class.
                emitPhysicalReload(cn);
                builder.CreateStore(builder.getInt32(1), aliveFlag(cn));
            }
        }
        return;
    }
    if (const auto* rv = dynamic_cast<const ast::ReimportValidateStmt*>(&stmt)) {
        // spec 30.18: reimport (reload the code from the on-disk .exe) and re-enable the class,
        // then run the expecting block in the new code and compare its value bit-for-bit with the
        // value the matching unimport produced; on mismatch run onFailure.
        const std::string cn = baseType(rv->target);
        emitPhysicalReload(cn);
        builder.CreateStore(builder.getInt32(1), aliveFlag(cn));
        llvm::Value* expected = rv->expected != nullptr ? emitExpr(*rv->expected) : nullptr;
        llvm::Value* produced = emitExpectingValue(rv->expecting.get());
        llvm::Value* eq = emitBitEqual(expected, produced);
        llvm::BasicBlock* failBB = llvm::BasicBlock::Create(context, "reimport.fail", currentFn);
        llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "reimport.ok", currentFn);
        builder.CreateCondBr(eq, okBB, failBB);
        builder.SetInsertPoint(failBB);
        if (rv->onFailure != nullptr) {
            emitBlock(*rv->onFailure, /*newScope=*/true);
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(okBB);
        }
        builder.SetInsertPoint(okBB);
        return;
    }
    if (const auto* cs = dynamic_cast<const ast::CascadeStmt*>(&stmt)) {
        // `cascade println(X)` / `cascade validate(X)` (spec 37.1): walk the owned graph from X
        // and describe / invariant-check each node, with cycle detection and the same filters.
        if (cs->op == ast::CascadeOpKind::Println ||
            cs->op == ast::CascadeOpKind::Validate) {
            const std::string cn = baseType(typeName(*cs->target));
            llvm::Value* root = emitObjectPtr(*cs->target);
            if (root == nullptr) {
                return;
            }
            const CascadeOp op = cs->op == ast::CascadeOpKind::Println ? CascadeOp::Println
                                                                       : CascadeOp::Validate;
            emitCascade(op, root, cn, cascadeCsid_++, cs->params);
        } else if (cs->op == ast::CascadeOpKind::Clone) {
            // `cascade clone X into Y`: deep-clone X's owned graph and store the root in Y.
            const std::string cn = baseType(typeName(*cs->target));
            llvm::Value* src = emitObjectPtr(*cs->target);
            llvm::Value* destSlot = emitLValue(*cs->dest);
            if (src == nullptr || destSlot == nullptr) {
                return;
            }
            emitCascadeClone(src, cn, destSlot, cascadeCsid_++, cs->params);
        } else if (cs->op == ast::CascadeOpKind::Unimport) {
            // `cascade unimport X`: unimport X and every subclass and monomorphization.
            for (const std::string& t : cascadeUnimportTargets(baseType(cs->typeName))) {
                emitUnimportClass(t);
            }
        }
        return;
    }
    if (const auto* cm = dynamic_cast<const ast::CascadeMoveStmt*>(&stmt)) {
        // Move the object graph into the destination region, then repoint the target.
        const std::string cn = baseType(typeName(*cm->target));
        llvm::Value* src = emitObjectPtr(*cm->target);
        if (src == nullptr) {
            return;
        }
        llvm::Value* dst = emitCascadeMove(src, cn, cm->toRegion, cm->loc);
        if (llvm::Value* slot = emitLValue(*cm->target)) {
            builder.CreateStore(dst, slot);
        }
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&stmt)) {
        // One delete; called for `del->target` and each of `del->moreTargets`. The placement
        // modifiers (from region / cascade) are shared and read from `del`.
        auto deleteOne = [&](const ast::Expr& target) {
            // Deleting a `using` resource by name explicitly disposes it now, so mark its pending
            // disposal consumed -- the using block must not destruct/free it a second time (that was
            // a double free, now a hard panic via the allocator guard).
            if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
                if (auto lit = locals.find(tid->name); lit != locals.end()) {
                    for (auto dit = deferred.rbegin(); dit != deferred.rend(); ++dit) {
                        if (dit->block == nullptr && dit->slot == lit->second.storage) {
                            dit->consumed = true;
                            break;
                        }
                    }
                }
            }
            const std::string t = typeName(target);
            if (isValueVariant(t)) {
                return;  // a value Result/Option is not heap-allocated: delete is a no-op
            }
            if (isArrayType(t)) {
                // An array is a single heap block. A String[] owns its elements (copy-on-store), so
                // free each before the block or they leak (this is the ArrayList<String> backing that
                // `delete this.data` reclaims); other element types own nothing here.
                llvm::Value* block = emitExpr(target);
                if (block != nullptr) {
                    if (arrayOwnsElements(elementOf(t))) {
                        emitFreeOwnedArrayElements(block, elementOf(t));
                    }
                    builder.CreateCall(freeFn(), {block});
                }
                return;
            }
            llvm::Value* objPtr = emitObjectPtr(target);
            if (objPtr == nullptr) {
                return;
            }
            const std::string cn = baseType(t);  // see through T*
            auto cit = classes.find(cn);
            // `delete X from region R` (spec 17.7): the region owns the memory and reclaims it on
            // release, so run the destructor now and drop the object from RAII tracking (so the
            // region release does not run it again), but never free() into the bump allocator.
            if (!del->fromRegion.empty()) {
                // On a pool/fixedslot/stack region the slot is reclaimable: guard against a double
                // delete-from-region (no UB), run the destructor, then hand the slot back to the runtime
                // (pool/fixedslot: free-list; stack: untrack + LIFO reclaim). A bump region reclaims
                // only on release.
                const std::string rflavor =
                    flavorOfRegion(del->fromRegion);
                const bool runtimeReclaim = usesRuntimeDesc(rflavor) && cit != classes.end();
                // `POLARON_RGN_TRACE=1` says which branch a `delete ... from region` takes. It is
                // kept because its SILENCE is what found the bug: the trace printed nothing at
                // all, which meant `fromRegion` was already empty by the time codegen saw it --
                // and that pointed at the clone, three passes earlier, rather than at any of the
                // conditions here that I had been guessing at.
                if (std::getenv("POLARON_RGN_TRACE") != nullptr) {
                    std::fprintf(stderr,
                                 "rgn: delete from '%s' in class '%s': flavor='%s' clsFound=%d "
                                 "runtimeReclaim=%d\n",
                                 del->fromRegion.c_str(), currentClass.c_str(), rflavor.c_str(),
                                 cit != classes.end() ? 1 : 0, runtimeReclaim ? 1 : 0);
                }
                const bool registry = regionHasRegistry(del->fromRegion);
                if (runtimeReclaim) {
                    builder.CreateCall(checkLiveFn(), {objPtr});
                }
                // Through the same thunk the registry would have used, so a weak target deleted by
                // hand nulls its weak pointers exactly as one destructed at release does.
                if (cit != classes.end() && (cit->second.hasDestructor || weakRelevant(cn))) {
                    if (llvm::Function* d =
                            registry
                                ? regionDtorFn(cn)
                                : (cit->second.hasDestructor ? functions[cn + ".~" + cn] : nullptr)) {
                        builder.CreateCall(d, {objPtr});
                    }
                }
                if (runtimeReclaim) {
                    llvm::Value* block = builder.CreateLoad(
                        builder.getPtrTy(), regionStorageSlot(del->fromRegion), "region");
                    builder.CreateCall(regionFreeFn(), {block, objPtr, sizeOf(cit->second.type)});
                } else if (registry) {
                    // A bump region reclaims only on release, but the registry must forget this object
                    // now -- otherwise release destructs it a second time, on memory whose destructor
                    // has already run.
                    llvm::Value* block = builder.CreateLoad(
                        builder.getPtrTy(), regionStorageSlot(del->fromRegion), "region");
                    builder.CreateCall(regionUntrackFn(), {block, objPtr});
                }
                if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
                    if (auto lit = locals.find(tid->name); lit != locals.end()) {
                        for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so) {
                            if (so->slot == lit->second.storage) { scopeObjects.erase(so); break; }
                        }
                    }
                }
                return;
            }
            // `cascade delete` (spec 37.1): delete the object and everything it owns
            // by composition. Heap-only (the spec's intent); no stack early-destruct.
            if (del->isCascade) {
                emitCascade(CascadeOp::Delete, objPtr, cn, cascadeCsid_++, del->cascade);
                return;
            }
            // A stack-allocated owned object: `delete` is an early destruct -- run the destructor
            // once and drop it from RAII tracking, but NEVER free() a stack pointer.
            //
            // The membership test is `stackObjectSlots_`, which holds every stack object, not
            // `scopeObjects`, which holds only the ones with a destructor or weak state. An object
            // with neither was in no list at all, so `delete` on it fell through to the heap path
            // and handed a stack address to free(). The header read 16 bytes below it is whatever
            // the frame happens to hold, so it is not one of our stamps, and the allocator forwards
            // the pointer to libc -- which corrupts the heap and reports it somewhere else entirely.
            // Nothing about this needed a destructor to go wrong; needing one to be NOTICED is what
            // kept it hidden.
            if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
                if (auto lit = locals.find(tid->name); lit != locals.end()) {
                    if (stackObjectSlots_.count(lit->second.storage) > 0) {
                        if (cit != classes.end() && cit->second.hasDestructor) {
                            builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
                        }
                        if (cit != classes.end() && weakRelevant(cn)) {
                            emitWeakCleanup(objPtr, cn);
                        }
                        for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so) {
                            if (so->slot == lit->second.storage) { scopeObjects.erase(so); break; }
                        }
                        return;
                    }
                }
            }
            // An imported class is destroyed opaquely through the bundle's exported __delete (which
            // runs the destructor and frees the real layout).
            if (cit != classes.end() && cit->second.imported) {
                builder.CreateCall(functions[cn + ".__delete"], {objPtr});
                return;
            }
            // Polymorphic delete dispatches the destructor through the vtable; a plain
            // class calls its destructor directly. Both then free (see emitDeleteObject).
            emitDeleteObject(objPtr, cn);
        };
        deleteOne(*del->target);
        for (const auto& mt : del->moreTargets) {
            deleteOne(*mt);
        }
        return;
    }
    if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
        if (rel->isPersistent) {
            // `release persistent obj.field` (spec 18.15). This was a no-op that satisfied the
            // static obligation and did nothing at all -- so a program could release a
            // persistent, read it back, and find every accumulated value still there. The
            // statement existed to be written, not to mean anything.
            //
            // What it means in an IN-PROCESS persistent model is that the accumulated state is
            // discarded: a later reattach starts from zero, exactly as the first attach of the
            // run did. The named block cannot be freed -- it is a global, and the whole point of
            // a named persistent is that its address is stable across reattach -- so releasing
            // is ZEROING it, which is the observable half and the honest one. The runtime frees
            // the storage at shutdown as it always has.
            if (rel->target != nullptr) {
                if (const auto* mem =
                        dynamic_cast<const ast::MemberExpr*>(rel->target.get())) {
                    // `release C.field all` -- every identity the field ever had. Without it a
                    // program could release only the identities it still happened to be holding,
                    // which is a leak with extra steps rather than a release.
                    if (rel->allKeys) {
                        // The receiver is a CLASS name here (`release Session.hits all`), not an
                        // object, so read the name rather than typing an expression that has no value.
                        std::string cls;
                        if (const auto* rid =
                                dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                            cls = rid->name;
                        } else {
                            cls = baseType(typeName(*mem->object));
                        }
                        if (auto cit = classes.find(cls);
                            cit != classes.end() && cit->second.persistPtrIdx != 0) {
                            // The field's byte offset and width, so the runtime clears exactly it
                            // and leaves its siblings in every block alone.
                            const auto& porder = cit->second.persistOrder;
                            auto pp = std::find(porder.begin(), porder.end(), mem->member);
                            if (pp == porder.end()) {
                                return;
                            }
                            const auto fidx = static_cast<unsigned>(pp - porder.begin());
                            const llvm::StructLayout* sl =
                                module.getDataLayout().getStructLayout(cit->second.persistBlock);
                            llvm::Type* ft = llvmType(cit->second.fieldType[mem->member]);
                            builder.CreateCall(
                                persistReleaseAllFn(),
                                {createGlobalStringPtr(builder, cls, "pcls"),
                                 builder.getInt64(sl->getElementOffset(fidx)),
                                 builder.getInt64(module.getDataLayout().getTypeStoreSize(ft))});
                        }
                        return;
                    }
                    const std::string cls = baseType(typeName(*mem->object));
                    auto cit = classes.find(cls);
                    if (cit != classes.end() && cit->second.persistPtrIdx != 0) {
                        llvm::Value* objPtr = emitObjectPtr(*mem->object);
                        if (objPtr != nullptr) {
                            llvm::Value* slot =
                                builder.CreateStructGEP(cit->second.type, objPtr,
                                                        cit->second.persistPtrIdx, "__persist");
                            llvm::Value* block =
                                builder.CreateLoad(builder.getPtrTy(), slot, "pblock");
                            // ONE field, not the whole block. Zeroing everything meant
                            // `release a.x` also wiped `a.y` and `a.z` -- a statement that names a
                            // field and then discards its siblings, silently.
                            const auto& porder = cit->second.persistOrder;
                            auto pp = std::find(porder.begin(), porder.end(), mem->member);
                            if (pp != porder.end()) {
                                const auto fidx = static_cast<unsigned>(pp - porder.begin());
                                llvm::Value* fp = builder.CreateStructGEP(
                                    cit->second.persistBlock, block, fidx, mem->member);
                                llvm::Type* ft =
                                    llvmType(cit->second.fieldType[mem->member]);
                                builder.CreateStore(llvm::Constant::getNullValue(ft), fp);
                            } else {
                                emitMemset(block, builder.getInt32(0),
                                           sizeOf(cit->second.persistBlock));
                            }
                        }
                    }
                }
            }
            return;
        }
        // Destruct every object in the region, then free the whole block (spec 17.7). Null the
        // slot so the scope-end region RAII frees null (no double free), and the objects are
        // cleared so they are not destructed again on the freed block.
        // `regionStorageSlot`, not `locals` -- a region may be a FIELD (spec 17: `this.f`), and
        // `new X() in region this.f` has always gone through that helper. Looking only in `locals`
        // here meant `release region this.f` matched nothing and fell out of the whole branch: no
        // destructors, no free, no null -- a silent no-op that leaked the block. The allocation side
        // and the release side of the same construct were asking two different questions about
        // where a region lives.
        // `release region AstNode` -- a REGION CLASS's arena, which belongs to the type rather than
        // to a method or an object (docs/design/region-classes.md).
        //
        // This is the case explicit release was designed for: a phase arena is worth having because
        // it dies at the end of the phase, and "released at program exit" would not solve the problem
        // that motivated it.
        //
        // GATED BY THE SAME LIVE-INSTANCE PROOF `unimport` PERFORMS, and reusing the same counter --
        // no new safety machinery. With nothing alive there is no object whose fields or destructor
        // can outlive the block; with something alive, freeing it hands every live reference a
        // dangling pointer, which is precisely the failure the language exists to make impossible.
        // Checked at RUN TIME for the same reason it is there: how many instances exist is not a
        // question the compiler can answer.
        if (auto rcit = classes.find(rel->region);
            rcit != classes.end() && rcit->second.decl != nullptr &&
            rcit->second.decl->isRegionClass) {
            const std::string root = regionFamilyRoot(rel->region);
            // Every class in the family shares the one block, so every one of them must be empty.
            // Releasing on the root's count alone would free an arena still holding `Ident`s.
            std::vector<std::string> family;
            for (const auto& [cn, ci] : classes) {
                if (ci.decl != nullptr && ci.decl->isRegionClass && regionFamilyRoot(cn) == root) {
                    family.push_back(cn);
                }
            }
            std::sort(family.begin(), family.end());  // deterministic IR, whatever the map's order
            llvm::Value* anyLive = builder.getInt1(false);
            for (const std::string& cn : family) {
                llvm::Value* n =
                    builder.CreateLoad(builder.getInt32Ty(), instanceCounter(cn), cn + ".live");
                anyLive = builder.CreateOr(
                    anyLive, builder.CreateICmpNE(n, builder.getInt32(0)), "rgncls.anylive");
            }
            llvm::Function* f = currentFn;
            auto* badBB = llvm::BasicBlock::Create(context, "rgncls.live", f);
            auto* okBB = llvm::BasicBlock::Create(context, "rgncls.free", f);
            builder.CreateCondBr(anyLive, badBB, okBB);
            builder.SetInsertPoint(badBB);
            emitPanic("cannot release the region of '" + root +
                      "': instances of it are still alive");
            builder.SetInsertPoint(okBB);
            // One reservation goes back in one call -- there is no chain to walk since the arena
            // became contiguous (see classRegionBlock for why it had to). Nulling the global is what
            // makes a later `new` rebuild it: `classRegionBlock` reserves on a null slot, which is
            // the same lazy path bare metal needs because it runs no static constructors.
            llvm::GlobalVariable* slot = module.getNamedGlobal(root + ".region");
            if (slot != nullptr) {
                llvm::Value* arena = builder.CreateLoad(builder.getPtrTy(), slot, "rgncls.arena");
                auto* haveBB = llvm::BasicBlock::Create(context, "rgncls.have", f);
                auto* doneBB = llvm::BasicBlock::Create(context, "rgncls.done", f);
                builder.CreateCondBr(builder.CreateIsNull(arena), doneBB, haveBB);
                builder.SetInsertPoint(haveBB);
                builder.CreateCall(arenaFreeFn(), {arena});
                builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
                builder.CreateBr(doneBB);
                builder.SetInsertPoint(doneBB);
            }
            return;
        }
        if (llvm::Value* rslot = regionStorageSlot(rel->region)) {
            runRegionObjectDtors(rel->region);
            llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), rslot);
            // A stack region tears down its registry (rollback-to-0 + free it); a ring region destructs
            // its live entries -- both before the block is freed. A growable region frees its whole
            // block chain (bump/pool/fixedslot only -- growable stack/ring are rejected in sema).
            const std::string relFlavor =
                flavorOfRegion(rel->region);
            if (regionHasRegistry(rel->region)) {
                builder.CreateCall(regionTeardownFn(), {block});
            } else if (isRingFlavor(relFlavor)) {
                builder.CreateCall(ringTeardownFn(), {block});
            }
            if (growableOfRegion(rel->region)) {
                builder.CreateCall(regionFreeChainFn(), {block});
            } else {
                builder.CreateCall(regionReleaseFn(), {block});
            }
            builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), rslot);
        }
        return;
    }
    // `snapshot region W into k;` (spec 32.2): re-capture into k's existing block. The room comes
    // from k's own slot header, so a region that grew since k was declared trips a named panic
    // instead of writing past the end of the very block whose job is to be a faithful copy.
    if (const auto* si = dynamic_cast<const ast::SnapshotIntoStmt*>(&stmt)) {
        llvm::Value* slot = regionStorageSlot(si->region);
        if (slot == nullptr) { error("unknown region '" + si->region + "'", si->loc); return; }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
        llvm::Value* into = si->into ? emitExpr(*si->into) : nullptr;
        if (into == nullptr) {
            return;
        }
        // A snapshot handle is an `address`, i.e. an integer here.
        if (into->getType()->isIntegerTy()) {
            into = builder.CreateIntToPtr(into, builder.getPtrTy(), "snap.p");
        }
        llvm::Value* room = builder.CreateCall(regionSlotSizeFn(), {into}, "snap.room");
        builder.CreateCall(regionSnapshotFn(), {block, into, room});
        return;
    }
    // `restore k into W;` -- the runtime runs the destructors of everything allocated since the
    // capture BEFORE it puts the bytes back. See runtime/polaron_region_core.hpp for why that order
    // is the whole feature and not a detail.
    if (const auto* rs = dynamic_cast<const ast::RestoreStmt*>(&stmt)) {
        llvm::Value* slot = regionStorageSlot(rs->region);
        if (slot == nullptr) { error("unknown region '" + rs->region + "'", rs->loc); return; }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
        llvm::Value* snap = rs->snapshot ? emitExpr(*rs->snapshot) : nullptr;
        if (snap == nullptr) {
            return;
        }
        if (snap->getType()->isIntegerTy()) {
            snap = builder.CreateIntToPtr(snap, builder.getPtrTy(), "snap.p");
        }
        builder.CreateCall(regionRestoreFn(), {block, snap});
        return;
    }
    if (const auto* rb = dynamic_cast<const ast::RollbackStmt*>(&stmt)) {
        // `rollback region R to m`: run destructors newest-first for everything allocated after the
        // checkpoint, then rewind the cursor (the runtime does both from the stack registry).
        llvm::Value* slot = regionStorageSlot(rb->region);
        if (slot == nullptr) { error("unknown region '" + rb->region + "'", rb->loc); return; }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
        llvm::Value* m =
            rb->checkpoint ? fitInt(emitExpr(*rb->checkpoint), 64) : builder.getInt64(0);
        if (m == nullptr) {
            return;
        }
        builder.CreateCall(regionRollbackFn(), {block, m});
        return;
    }
    if (const auto* def = dynamic_cast<const ast::DeferStmt*>(&stmt)) {
        // spec 32.10: `defer within <duration>` -- evaluate the budget HERE (where it is written), so
        // it reads the values in scope at that point, and carry it to the scope-exit cleanup.
        llvm::Value* budget = nullptr;
        if (def->within != nullptr) {
            llvm::Value* d = emitExpr(*def->within);
            if (d != nullptr) {
                const std::string dt = baseType(typeName(*def->within));
                if (dt == "Duration") {   // a Duration: ask it for its milliseconds
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
                    budget = emitDynCall("Duration", "toMillis", ft, d);
                } else if (d->getType()->isIntegerTy()) {   // a bare count of milliseconds
                    budget = builder.CreateSExtOrTrunc(d, builder.getInt64Ty());
                }
            }
        }
        Cleanup c{&def->body};
        c.budgetMs = budget;
        deferred.push_back(c);  // runs at scope end (see emitScopeCleanup)
        return;
    }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(&stmt)) {
        emitStatement(*us->decl);  // declare the resource
        // Register its disposal as a pending cleanup BEFORE the body, so it runs at every exit of the
        // using block -- normal, return/break, and exception unwind alike (spec 23.1) -- not just the
        // fall-through path. A stack resource is dropped from RAII tracking so the enclosing scope
        // does not destruct it a second time; a heap resource is freed by the disposal.
        auto it = locals.find(us->varName);
        llvm::Value* dslot = (it != locals.end()) ? it->second.storage : nullptr;
        if (dslot != nullptr) {
            const std::string cn = baseType(it->second.type);
            bool onStack = false;
            for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so) {
                if (so->slot == dslot) {
                    onStack = true;
                    scopeObjects.erase(so);
                    break;
                }
            }
            deferred.push_back(Cleanup{nullptr, dslot, cn, !onStack});
        }
        emitBlock(us->body);  // use it
        if (dslot != nullptr) {
            // Normal fall-through disposes here; a terminating exit already ran it via that path's
            // cleanup. Either way drop the pending action.
            if (builder.GetInsertBlock()->getTerminator() == nullptr) {
                emitCleanupAction(deferred.back());
            }
            deferred.pop_back();
        }
        return;
    }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(&stmt)) {
        llvm::Value* mptr = emitObjectPtr(*sy->mutex);  // the Mutex instance
        if (mptr == nullptr) {
            return;
        }
        auto cit = classes.find(clsKey(typeName(*sy->mutex)));
        if (cit == classes.end()) {
            return;
        }
        const ClassLayout& cl = cit->second;
        auto lockIt = cl.fieldIndex.find("lock");
        auto valIt = cl.fieldIndex.find("value");
        if (lockIt == cl.fieldIndex.end() || valIt == cl.fieldIndex.end()) {
            return;
        }
        llvm::FunctionType* lf =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
        // Acquire the lock for the duration of the block.
        llvm::Value* lockAddr =
            builder.CreateStructGEP(cl.type, mptr, lockIt->second, "mtx.lock.addr");
        llvm::Value* lock = builder.CreateLoad(builder.getInt64Ty(), lockAddr, "mtx.lock");
        builder.CreateCall(module.getOrInsertFunction("__polaron_lock_acquire", lf), {lock});
        // Register the release as a block-scoped cleanup so it runs on BOTH the normal exit and an
        // exception unwind out of the body -- a throw inside the block used to leave the mutex locked
        // forever, deadlocking the next acquirer (spec 23.1: releases run while unwinding too).
        std::size_t dfBase = deferred.size();
        deferred.push_back(Cleanup{});
        deferred.back().lockRelease = lock;
        // Bind the name to a reference to the protected value: the local's storage *is* the
        // address of the value field, so reads/writes of the binding hit the field directly.
        llvm::Value* valAddr =
            builder.CreateStructGEP(cl.type, mptr, valIt->second, "mtx.value.addr");
        const bool had = locals.count(sy->bindName) > 0;
        LocalSlot saved = had ? locals[sy->bindName] : LocalSlot{};
        locals[sy->bindName] = LocalSlot{valAddr, sy->bindType.name};
        emitBlock(sy->body);
        if (had) {
            locals[sy->bindName] = saved;
        } else {
            locals.erase(sy->bindName);
        }
        // Normal path: run the release we registered. The unwind path already ran it via the
        // cleanup chain (which snapshotted `deferred` when the body threw). Pop it either way.
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            for (std::size_t i = deferred.size(); i > dfBase; --i) {
                emitCleanupAction(deferred[i - 1]);
            }
        }
        deferred.resize(dfBase);
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
        emitExpr(*es->expr);
        freeStringTemps();  // String RAII: release owned temporaries at the statement boundary
        return;
    }
    if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(&stmt)) {
        if (genSM) {  // spec 22.6: hand the element to the caller and suspend right here
            llvm::Value* v = ys->value != nullptr ? emitExpr(*ys->value) : nullptr;
            if (v == nullptr) {
                return;
            }
            builder.CreateStore(coerce(v, typeName(*ys->value), genSMElem),
                                builder.CreateStructGEP(genSMState, genSMStatePtr, 1, "gen.cur"));
            const int idx = ++genSMIdx;  // the state to come back to, on the next resume
            builder.CreateStore(builder.getInt32(idx),
                                builder.CreateStructGEP(genSMState, genSMStatePtr, 0, "gen.st"));
            builder.CreateRet(llvm::ConstantInt::get(currentFn->getReturnType(), 1));  // yielded
            llvm::BasicBlock* resumeBB =
                llvm::BasicBlock::Create(context, "gen.resume" + std::to_string(idx), currentFn);
            genSMCases.push_back({idx, resumeBB});
            builder.SetInsertPoint(resumeBB);
            return;
        }
        // `yield expr;` in a match-expression block arm (spec 16.2): store the value and jump to
        // the arm's continuation.
        llvm::Value* v = ys->value != nullptr ? emitExpr(*ys->value) : nullptr;
        if (v != nullptr && yieldSlot_ != nullptr) {
            builder.CreateStore(coerce(v, typeName(*ys->value), yieldType_), yieldSlot_);
        }
        if (yieldEnd_ != nullptr) {
            builder.CreateBr(yieldEnd_);
        }
        return;
    }
    if (const auto* as = dynamic_cast<const ast::AsmStmt*>(&stmt)) {
        // Inline assembly (spec issue 1): the raw body as a side-effecting LLVM inline asm that also
        // clobbers memory (so it is never reordered or elided).
        //
        // `as->arch` NAMES THE ARCHITECTURE THE BLOCK IS WRITTEN FOR, and it is checked here against
        // the one being built for. It used to be an unchecked "intent tag", which meant an x86 block
        // compiled for ARM travelled all the way to clang's assembler and failed there:
        //     <inline asm>:1:3: error: too few operands for instruction
        //             hlt
        // -- a message about a line of assembly, in a file called `<inline asm>`, with no path back
        // to the Polaron source that wrote it or the target that made it wrong. A whole-program port
        // consists mostly of finding these, so the compiler says it itself, at the right place.
        if (!as->arch.empty() && as->arch != "arch") {  // "arch" is the docs' placeholder
            const llvm::Triple mt(module.getTargetTriple());
            const std::string want = archFamily(as->arch);
            const std::string have = archFamily(mt.getArchName().str());
            if (!want.empty() && !have.empty() && want != have) {
                error("this `asm` block is written for " + as->arch + ", and the target is " +
                          mt.getArchName().str() +
                          ". Assembly cannot be ported by the compiler, and there is as yet no way "
                          "to carry one block per architecture in a program -- so this block has to "
                          "be written for " + mt.getArchName().str() +
                          ", or the program built for " + as->arch,
                      as->loc);
                return;
            }
        }
        //
        // Operands: `out (lv, ...)` -> "=r", `in (e, ...)` -> "r", `clobber ("rax", ...)` -> "~{rax}".
        // In the body $0.. number the outputs first, then the inputs (GCC/LLVM order). With a single
        // output the asm returns that value; with several it returns a struct we unpack.
        std::vector<llvm::Type*> argTys;
        std::vector<llvm::Value*> args;
        std::string cons;
        std::vector<llvm::Type*> outTys;
        for (const ast::ExprPtr& o : as->outputs) {
            outTys.push_back(llvmType(typeName(*o)));
            cons += cons.empty() ? "=r" : ",=r";
        }
        for (const ast::ExprPtr& i : as->inputs) {
            llvm::Value* v = emitExpr(*i);
            if (v == nullptr) {
                return;
            }
            args.push_back(v);
            argTys.push_back(v->getType());
            cons += cons.empty() ? "r" : ",r";
        }
        for (const std::string& c : as->clobbers) {
            cons += (cons.empty() ? "" : ",") + ("~{" + c + "}");
        }
        cons += cons.empty() ? "~{memory}" : ",~{memory}";
        llvm::Type* retTy = outTys.empty()  ? builder.getVoidTy()
                            : outTys.size() == 1 ? outTys[0]
                                                 : llvm::StructType::get(context, outTys);
        // Dialect: `asm("x86_64", "att") { ... }` names it explicitly (to paste in a snippet written
        // the other way); with no second argument it follows the architecture. x86 defaults to INTEL,
        // because that is what a Polaron asm block is written in (the spec's own examples). Defaulting
        // to AT&T made every such block fail to ASSEMBLE -- the feature only looked like it worked
        // because the IR still emitted.
        const llvm::Triple tt(module.getTargetTriple());
        const bool isX86 =
            tt.getArch() == llvm::Triple::x86 || tt.getArch() == llvm::Triple::x86_64;
        llvm::InlineAsm::AsmDialect dialect = isX86 ? llvm::InlineAsm::AD_Intel
                                                    : llvm::InlineAsm::AD_ATT;
        if (as->dialect == "intel") {
            dialect = llvm::InlineAsm::AD_Intel;
        } else if (as->dialect == "att") {
            dialect = llvm::InlineAsm::AD_ATT;
        } else if (!as->dialect.empty()) {
            error("unknown assembly dialect '" + as->dialect + "' (expected \"intel\" or \"att\")",
                  as->loc);
        }
        llvm::FunctionType* aty = llvm::FunctionType::get(retTy, argTys, false);
        llvm::InlineAsm* ia =
            llvm::InlineAsm::get(aty, as->body, cons, /*hasSideEffects=*/true,
                                 /*isAlignStack=*/false, dialect);
        llvm::Value* res = builder.CreateCall(ia, args);
        for (std::size_t k = 0; k < as->outputs.size(); ++k) {
            llvm::Value* v = as->outputs.size() == 1
                                 ? res
                                 : builder.CreateExtractValue(res, static_cast<unsigned>(k));
            if (llvm::Value* slot = emitLValue(*as->outputs[k]); slot != nullptr) {
                builder.CreateStore(v, slot);
            }
        }
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
        // --verify-stack: does this method leave on the stack pointer it arrived on?
        //
        // Emitted BEFORE any of the return paths below, so it covers all of them. If the two differ,
        // something moved the stack under this method -- and the whole reason for spending compiler
        // work on it is that such a displacement is currently invisible until it surfaces as wrong
        // DATA in unrelated code, hours of bisection later.
        // `entrySp` belongs to ONE method. This handler also runs while emitting thunks, closures
        // and other bodies that get their own function, and referring to a Value from a different
        // function is invalid IR -- it segfaulted the compiler outright the first time. So the
        // check only fires where the entry read and this return are demonstrably the same one.
        auto* entryInst = llvm::dyn_cast_or_null<llvm::Instruction>(entrySp);
        if (verifyStack && entryInst != nullptr && currentFn != nullptr &&
            entryInst->getFunction() == currentFn && builder.GetInsertBlock() != nullptr &&
            builder.GetInsertBlock()->getParent() == currentFn) {
            llvm::Function* save =
                llvm::Intrinsic::getDeclaration(&module, llvm::Intrinsic::stacksave,
                                                {llvm::PointerType::get(context, 0)});
            llvm::Value* now = builder.CreateCall(save, {}, "sp.exit");
            llvm::Value* same = builder.CreateICmpEQ(now, entrySp, "sp.same");
            llvm::BasicBlock* bad = llvm::BasicBlock::Create(context, "sp.mismatch", currentFn);
            llvm::BasicBlock* ok = llvm::BasicBlock::Create(context, "sp.ok", currentFn);
            builder.CreateCondBr(same, ok, bad);
            builder.SetInsertPoint(bad);
            // A weak reporter, so a freestanding program can say it over whatever channel it has and
            // a hosted one gets a default. Named, because "the stack moved" without a name is the
            // same useless clue this instrument exists to replace.
            llvm::FunctionType* rt = llvm::FunctionType::get(
                llvm::Type::getVoidTy(context), {llvm::PointerType::get(context, 0)}, false);
            llvm::FunctionCallee reporter = module.getOrInsertFunction("__polaron_stack_mismatch", rt);
            builder.CreateCall(
                reporter, {builder.CreateGlobalStringPtr(currentFn->getName().str(), "sp.who")});
            builder.CreateBr(ok);
            builder.SetInsertPoint(ok);
        }
        if (genSM) {  // spec 22.6: a bare `return` ends the sequence -- the resume reports "done"
            emitScopeCleanup();
            builder.CreateStore(builder.getInt32(-1),
                                builder.CreateStructGEP(genSMState, genSMStatePtr, 0, "gen.st"));
            builder.CreateRet(llvm::ConstantInt::get(currentFn->getReturnType(), 0));
            return;
        }
        // Returning a stack-allocated object escapes the frame -- its pointer would dangle and the
        // caller reads freed memory. Promote a directly-returned plain `new X() [on stack]` to the
        // heap so the returned object stays live; a returned object is the caller's to own and free.
        // (Arrays already default to heap; region-targeted news keep their region.)
        //
        // NOT for a value struct (spec 11), which is what the `currentSretSlot_` guard says. Such a
        // return hands back no pointer at all: it memcpy's the object into the caller's result slot
        // a few lines below, so nothing of this frame outlives the frame and there is nothing to
        // promote. Doing it anyway malloc'd a temporary, constructed into it, copied it out and then
        // dropped the only pointer to it -- an allocation AND a leak on every `return new Point(x,
        // y)` from a struct method. Found from a freestanding program, where it was worse than a
        // leak: a value struct returned before the heap existed called the allocator anyway.
        if (const auto* cnw = dynamic_cast<const ast::NewExpr*>(rs->value.get());
            cnw != nullptr && cnw->location == "stack" && cnw->region.empty() &&
            currentSretSlot_ == nullptr) {
            const_cast<ast::NewExpr*>(cnw)->location = "heap";
        }
        // Inside an `expecting { ... }` block (spec 30.18), `return X` is the block's value:
        // store it and jump to the block's end, rather than returning from the method.
        if (expectingSlot_ != nullptr) {
            llvm::Value* v = rs->value != nullptr ? emitExpr(*rs->value) : nullptr;
            if (v != nullptr) {
                builder.CreateStore(v, expectingSlot_);
            }
            builder.CreateBr(expectingEnd_);
            return;
        }
        // Inside an async resume, `return X` completes the task with X (spec 20.2).
        if (currentAsyncState != nullptr) {
            llvm::Value* v = rs->value != nullptr ? emitExpr(*rs->value) : nullptr;
            emitPendingFinallys(0);
            emitScopeCleanup();
            if (builder.GetInsertBlock()->getTerminator() == nullptr) {
                emitTaskComplete(v);
                builder.CreateRetVoid();
            }
            return;
        }
        if (rs->value != nullptr) {
            llvm::Value* v = emitExpr(*rs->value);
            // Widen/convert the returned value to the declared return type, the same implicit numeric
            // coercion assignments and arguments already apply (e.g. `return 0;` from a `long` method,
            // or an int/float from a double method). Signedness of any integer widening follows the
            // returned value's type. sret functions have a void currentRetType and are handled below.
            if (v != nullptr && !currentRetType->isVoidTy() && currentRetType != v->getType()) {
                if (currentRetType->isFloatingPointTy() && v->getType()->isIntegerTy()) {
                    v = isUnsigned(typeName(*rs->value)) ? builder.CreateUIToFP(v, currentRetType)
                                                         : builder.CreateSIToFP(v, currentRetType);
                } else if (currentRetType->isFloatingPointTy() && v->getType()->isFloatingPointTy()) {
                    v = currentRetType->getPrimitiveSizeInBits() >
                                v->getType()->getPrimitiveSizeInBits()
                            ? builder.CreateFPExt(v, currentRetType)
                            : builder.CreateFPTrunc(v, currentRetType);
                } else if (currentRetType->isIntegerTy() && v->getType()->isIntegerTy()) {
                    unsigned want = currentRetType->getIntegerBitWidth();
                    unsigned have = v->getType()->getIntegerBitWidth();
                    if (want > have) {
                        v = isUnsigned(typeName(*rs->value)) ? builder.CreateZExt(v, currentRetType)
                                                             : builder.CreateSExt(v, currentRetType);
                    } else if (want < have) {
                        v = builder.CreateTrunc(v, currentRetType);
                    }
                }
            }
            // String RAII: copy-on-return so the caller receives an owned buffer that outlives this
            // frame's scope-exit release of the returned local (spec 4 value semantics). Do the copy
            // before freeing this statement's temporaries, then free them (the fresh copy survives).
            // Key on the DECLARED return type too: `return "literal"` (a `string`-typed expression)
            // from a `returns String` method must still hand back an owned copy, or the caller's
            // stage-2 free would free a string-literal global (heap corruption).
            if ((currentRetTypeName_ == "String" || currentRetTypeName_ == "string" ||
                 typeName(*rs->value) == "String" || typeName(*rs->value) == "string") &&
                v != nullptr) {
                v = emitStringCopy(v);
            }
            freeStringTemps();
            // A value struct returned by value uses sret: copy it into the caller-provided
            // result slot (the trailing argument) and return void. Each caller owns its result,
            // with no dangling stack pointer and no leaked copy (spec 11 value semantics).
            if (currentSretSlot_ != nullptr && v != nullptr) {
                auto cit = classes.find(clsKey(typeName(*rs->value)));
                if (cit != classes.end()) {
                    builder.CreateMemCpy(currentSretSlot_, llvm::MaybeAlign(8), v,
                                         llvm::MaybeAlign(8), sizeOf(cit->second.type));
                }
                emitPendingFinallys(0);
                emitScopeCleanup();
                if (builder.GetInsertBlock()->getTerminator() == nullptr) {
                    builder.CreateRetVoid();
                }
                return;
            }
            emitPendingFinallys(0);  // run every enclosing try's finally before leaving
            // `result` in an ensures clause (spec 29) is THIS value. The postconditions run inside
            // emitScopeCleanup, which is after the returned value has been computed and converted
            // -- so it is simply in hand here, and binding it costs nothing. Cleared straight
            // after: a sibling return path binds its own.
            currentResultValue_ = v;
            emitScopeCleanup();
            currentResultValue_ = nullptr;
            if (builder.GetInsertBlock()->getTerminator() == nullptr && v != nullptr) {
                builder.CreateRet(v);
            }
            return;
        }
        emitPendingFinallys(0);
        emitScopeCleanup();
        // A throwing defer during cleanup already terminated the block (it took over control), so
        // the return is unreachable -- emitting it would put a terminator after a terminator.
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            if (currentRetType->isVoidTy()) {
                builder.CreateRetVoid();
            } else if (currentRetType->isDoubleTy()) {
                builder.CreateRet(llvm::ConstantFP::get(currentRetType, 0.0));
            } else if (currentRetType->isStructTy()) {
                builder.CreateRet(llvm::UndefValue::get(currentRetType));  // tuple
            } else {
                builder.CreateRet(builder.getInt32(0));
            }
        }
        return;
    }
    error("unsupported statement in codegen", stmt.loc);
}

}  // namespace polaron
