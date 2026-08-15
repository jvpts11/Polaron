#include "codegen/codegen_impl.h"

namespace polaron {

llvm::StructType* CodeGenerator::Impl::asyncStateType(const ast::MethodDecl& m, const std::string& mangled) {
    std::vector<llvm::Type*> fields = {builder.getInt32Ty(), builder.getPtrTy()};
    for (const auto& p : m.params) {
        fields.push_back(llvmType(typeRefName(p.type)));
    }
    return llvm::StructType::create(context, fields, mangled + "$state");
}

void CodeGenerator::Impl::emitAsyncMethod(const ast::ClassDecl& cls, const ast::MethodDecl& m) {
    if (countAsyncAwaits(m.body) > 0) { emitAsyncStateMachine(cls, m); return; }
    const std::string mangled = cls.name + "." + m.name;
    llvm::StructType* stateTy = asyncStateType(m, mangled);

    // --- resume(ptr st): bind args from the state, run the body, returns complete the task.
    llvm::Function* res = functions[mangled + "$resume"];
    currentFn = res;
    currentClass = "";  // slice B supports static async methods
    currentRetType = builder.getVoidTy();
    currentThis = nullptr;
    currentEnsures = nullptr;
    currentInvariants = nullptr;
    currentInvariantsToAssume = nullptr;
    currentDtorChain = "";
    locals.clear();
    scopeObjects.clear();
    stackObjectSlots_.clear();
    scopeRegions.clear();
    scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
    scopeValueStructs.clear();  // same, for coroutine-state value structs (B9)
    stringTemps.clear();
    lazyRegions_.clear();  // region/volatile tracking is keyed by local name; reset per function
    lazyRegionSize_.clear();
    lazyRegionAt_.clear();
    volatileRegions_.clear();
    regionCursorSlot_.clear();
    ownedRegions_.clear();
    regionFlavor_.clear();
    growableRegions_.clear();
    pendingRegionFlavor_.clear();
    volatileObjects_.clear();
    deferred.clear();
    escapingLocals_.clear();  // async bodies don't run the sync escape analysis; no stale carryover
    labelBlocks.clear(); comefromBlocks.clear();
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", res));
    llvm::Value* st = res->getArg(0);
    currentAsyncState = builder.CreateLoad(
        builder.getPtrTy(), builder.CreateStructGEP(stateTy, st, 1, "st.task.addr"), "st.task");
    for (std::size_t i = 0; i < m.params.size(); ++i) {
        locals[m.params[i].name] = LocalSlot{
            builder.CreateStructGEP(stateTy, st, 2 + i, m.params[i].name),
            typeRefName(m.params[i].type)};
    }
    // A throw completes the task with the error. On Itanium the guard also hands back a record block
    // and carrier slot so a cleanup pad can run pending defers/destructors first (B8).
    llvm::BasicBlock* guardDispatch = nullptr;
    llvm::Value* guardCarrier = nullptr;
    llvm::BasicBlock* guard = buildAsyncGuardPad(&guardDispatch, &guardCarrier);
    ehPadStack.push_back(guard);
    // Real (freshly-cleared) base sizes so a throw with a pending defer/using/region/stack-dtor chains
    // its cleanup before completing the Task with the error (spec 21). On WinEH the cleanup funclet
    // chain feeds the guard directly; on Itanium the guard's itDispatch/itCarrier let the cleanup
    // landing pad run the teardown, then branch to the record block. Adds cleanup only when something
    // is pending; otherwise the throw unwinds straight to the guard.
    ehBaseStack.push_back({scopeObjects.size(), deferred.size(), scopeRegions.size(),
                           guardDispatch, guardCarrier});
    emitBlock(m.body, /*newScope=*/false);
    ehPadStack.pop_back();
    ehBaseStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        emitTaskComplete(nullptr);
        builder.CreateRetVoid();
    }
    currentAsyncState = nullptr;
    emitAsyncWrapper(stateTy, m, mangled);
}

llvm::Value* CodeGenerator::Impl::valueToI64(llvm::Value* v) {
    if (v->getType()->isPointerTy()) {
        return builder.CreatePtrToInt(v, builder.getInt64Ty());
    }
    if (v->getType()->isDoubleTy()) {
        return builder.CreateBitCast(v, builder.getInt64Ty());
    }
    if (v->getType()->isIntegerTy()) {
        return builder.CreateIntCast(v, builder.getInt64Ty(), true);
    }
    if (v->getType()->isAggregateType()) {
        // A value struct -- a value Result/Option { i32 tag, i64 payload } returned from an async
        // method -- does not fit the 64-bit task slot, so box it: copy it to the heap and carry the
        // pointer. castTaskResult unboxes it on await. (An async return happens once per call, so
        // this is one small allocation per awaited value result.)
        llvm::Value* box = builder.CreateCall(mallocFn(), {sizeOf(v->getType())}, "task.box");
        builder.CreateStore(v, box);
        return builder.CreatePtrToInt(box, builder.getInt64Ty());
    }
    return v;
}

llvm::Value* CodeGenerator::Impl::castTaskResult(llvm::Value* res64, const std::string& t) {
    llvm::Type* tt = llvmType(t);
    if (tt->isPointerTy()) {
        return builder.CreateIntToPtr(res64, tt);
    }
    if (tt->isDoubleTy()) {
        return builder.CreateBitCast(res64, tt);
    }
    if (tt->isIntegerTy()) {
        return builder.CreateIntCast(res64, tt, true);
    }
    if (tt->isAggregateType()) {
        // Unbox the value struct (a value Result/Option) that the async return boxed into the slot.
        llvm::Value* box = builder.CreateIntToPtr(res64, builder.getPtrTy());
        return builder.CreateLoad(tt, box, "task.unbox");
    }
    return res64;
}

void CodeGenerator::Impl::scanAsyncLocals(const ast::Block& b, std::vector<std::pair<std::string, std::string>>& out) {
    for (const auto& sp : b.statements) {
        scanAsyncLocalsS(sp.get(), out);
    }
}

void CodeGenerator::Impl::scanAsyncLocalsS(const ast::Stmt* s, std::vector<std::pair<std::string, std::string>>& out) {
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        out.push_back({vd->name, vd->isVar ? typeName(*vd->init) : typeRefName(vd->type)});
    } else if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
        scanAsyncLocals(i->thenBlock, out);
        if (i->elseBlock) {
            scanAsyncLocals(*i->elseBlock, out);
        }
    } else if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) {
        scanAsyncLocals(w->body, out);
    } else if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) {
        scanAsyncLocals(d->body, out);
    } else if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) {
        if (f->init) {
            scanAsyncLocalsS(f->init.get(), out);
        }
        scanAsyncLocals(f->body, out);
    } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
        scanAsyncLocals(fe->body, out);
    }
}

int CodeGenerator::Impl::countAwaitsE(const ast::Expr* e) {
    if (e == nullptr) {
        return 0;
    }
    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(e)) {
        return 1 + countAwaitsE(aw->operand.get());
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        return countAwaitsE(b->lhs.get()) + countAwaitsE(b->rhs.get());
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        return countAwaitsE(u->operand.get());
    }
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        int n = 0;
        for (const auto& a : c->args) {
            n += countAwaitsE(a.get());
        }
        return n;
    }
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
        return countAwaitsE(ca->operand.get());
    }
    if (const auto* mx = dynamic_cast<const ast::MemberExpr*>(e)) {
        return countAwaitsE(mx->object.get());
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        return countAwaitsE(ix->array.get()) + countAwaitsE(ix->index.get());
    }
    return 0;
}

int CodeGenerator::Impl::countAsyncAwaitsS(const ast::Stmt* s) {
    int n = 0;
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        n += countAwaitsE(vd->init.get());
    } else if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) {
        n += countAwaitsE(es->expr.get());
    } else if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) {
        n += countAwaitsE(rs->value.get());
    } else if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        n += countAwaitsE(as->value.get());
    } else if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
        n += countAwaitsE(i->cond.get()) + countAsyncAwaits(i->thenBlock);
        if (i->elseBlock) {
            n += countAsyncAwaits(*i->elseBlock);
        }
    } else if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) {
        n += countAwaitsE(w->cond.get()) + countAsyncAwaits(w->body);
    } else if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) {
        n += countAsyncAwaits(d->body) + countAwaitsE(d->cond.get());
    } else if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) {
        if (f->init) {
            n += countAsyncAwaitsS(f->init.get());
        }
        n += countAwaitsE(f->cond.get()) + countAsyncAwaits(f->body);
    } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
        n += countAsyncAwaits(fe->body);
    }
    return n;
}

int CodeGenerator::Impl::countAsyncAwaits(const ast::Block& b) {
    int n = 0;
    for (const auto& sp : b.statements) {
        n += countAsyncAwaitsS(sp.get());
    }
    return n;
}

bool CodeGenerator::Impl::laterArgAwaits(const std::vector<ast::ExprPtr>& a, std::size_t i) {
    for (std::size_t j = i + 1; j < a.size(); ++j) {
        if (containsAwait(*a[j])) {
            return true;
        }
    }
    return false;
}

bool CodeGenerator::Impl::anyArgAwaits(const std::vector<ast::ExprPtr>& a) {
    for (const auto& x : a) {
        if (containsAwait(*x)) {
            return true;
        }
    }
    return false;
}

CodeGenerator::Impl::SpillToken CodeGenerator::Impl::spillAcrossAwait(llvm::Value* v) {
    SpillToken t;
    if (!asyncSM || v == nullptr || asyncSpillTop_ >= kAsyncScratchSlots) {
        return t;
    }
    t.active = true;
    t.slot = asyncSMScratchBase + static_cast<unsigned>(asyncSpillTop_++);
    t.ty = v->getType();
    builder.CreateStore(
        v, builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, t.slot, "spill"));
    return t;
}

llvm::Value* CodeGenerator::Impl::reloadSpill(const SpillToken& t, llvm::Value* orig) {
    if (!t.active) {
        return orig;
    }
    --asyncSpillTop_;
    return builder.CreateLoad(
        t.ty, builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, t.slot, "reload"),
        "spilled");
}

void CodeGenerator::Impl::emitGeneratorMethod(const ast::ClassDecl& cls, const ast::MethodDecl& m) {
    llvm::Function* startF = module.getFunction(m.genSym + "$start");
    llvm::Function* resumeF = module.getFunction(m.genSym + "$resume");
    llvm::Function* currentF = module.getFunction(m.genSym + "$current");
    llvm::Function* freeF = module.getFunction(m.genSym + "$free");
    if (startF == nullptr || resumeF == nullptr || currentF == nullptr || freeF == nullptr) {
        return;  // the synthesized class was dropped (e.g. an earlier error): nothing to emit
    }

    std::vector<std::pair<std::string, std::string>> tlocals;
    scanAsyncLocals(m.body, tlocals);  // same scan: every local must live in the state object

    // State layout: {i32 state, T current, self?, params..., locals...}.
    const bool hasSelf = !m.isStatic;
    std::vector<llvm::Type*> fields = {builder.getInt32Ty(), llvmType(m.genElem)};
    if (hasSelf) {
        fields.push_back(builder.getPtrTy());
    }
    const unsigned argBase = static_cast<unsigned>(fields.size());
    for (const auto& p : m.params) {
        fields.push_back(llvmType(typeRefName(p.type)));
    }
    const unsigned localBase = static_cast<unsigned>(fields.size());
    for (const auto& l : tlocals) {
        fields.push_back(llvmType(l.second));
    }
    llvm::StructType* stateTy =
        llvm::StructType::create(context, fields, m.genSym + "$genstate");

    // --- $start: malloc the state, store state=0 and the arguments, hand back the handle.
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", startF));
    llvm::Value* st = builder.CreateCall(mallocFn(), {sizeOf(stateTy)}, "gen.state");
    builder.CreateStore(builder.getInt32(0), builder.CreateStructGEP(stateTy, st, 0));
    for (unsigned i = 0; i < startF->arg_size(); ++i) {  // self (if any) then the arguments, in order
        builder.CreateStore(startF->getArg(i), builder.CreateStructGEP(stateTy, st, 2 + i));
    }
    builder.CreateRet(builder.CreatePtrToInt(st, builder.getInt64Ty()));

    // --- $current: read the buffered element.
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", currentF));
    llvm::Value* cst = builder.CreateIntToPtr(currentF->getArg(0), builder.getPtrTy(), "gen.st");
    builder.CreateRet(builder.CreateLoad(llvmType(m.genElem),
                                         builder.CreateStructGEP(stateTy, cst, 1), "gen.cur"));

    // --- $free: release the state.
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", freeF));
    builder.CreateCall(freeFn(), {builder.CreateIntToPtr(freeF->getArg(0), builder.getPtrTy())});
    builder.CreateRetVoid();

    // --- $resume: the body, as a state machine.
    currentFn = resumeF;
    currentClass = hasSelf ? cls.name : "";
    currentRetType = resumeF->getReturnType();
    currentThis = nullptr;
    currentEnsures = nullptr;
    currentInvariants = nullptr;
    currentInvariantsToAssume = nullptr;
    currentDtorChain = "";
    locals.clear();
    scopeObjects.clear();
    stackObjectSlots_.clear();
    scopeRegions.clear();
    scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
    scopeValueStructs.clear();  // same, for coroutine-state value structs (B9)
    stringTemps.clear();
    lazyRegions_.clear();
    lazyRegionSize_.clear();
    lazyRegionAt_.clear();
    volatileRegions_.clear();
    regionCursorSlot_.clear();
    ownedRegions_.clear();
    regionFlavor_.clear();
    growableRegions_.clear();
    pendingRegionFlavor_.clear();
    volatileObjects_.clear();
    deferred.clear();
    escapingLocals_.clear();
    labelBlocks.clear(); comefromBlocks.clear();
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", resumeF));
    llvm::Value* rst = builder.CreateIntToPtr(resumeF->getArg(0), builder.getPtrTy(), "gen.st");
    if (hasSelf) {
        currentThis = builder.CreateLoad(builder.getPtrTy(),
                                         builder.CreateStructGEP(stateTy, rst, 2, "gen.self.addr"),
                                         "gen.self");
    }
    for (std::size_t i = 0; i < m.params.size(); ++i) {
        locals[m.params[i].name] =
            LocalSlot{builder.CreateStructGEP(stateTy, rst, argBase + i, m.params[i].name),
                      typeRefName(m.params[i].type)};
    }
    for (std::size_t j = 0; j < tlocals.size(); ++j) {
        locals[tlocals[j].first] = LocalSlot{
            builder.CreateStructGEP(stateTy, rst, localBase + j, tlocals[j].first),
            tlocals[j].second};
    }

    llvm::BasicBlock* bodyStart = llvm::BasicBlock::Create(context, "gen.body", resumeF);
    llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "gen.done", resumeF);
    llvm::Value* stateVal = builder.CreateLoad(
        builder.getInt32Ty(), builder.CreateStructGEP(stateTy, rst, 0, "gen.st.addr"), "gen.state");
    llvm::SwitchInst* sw = builder.CreateSwitch(stateVal, doneBB, 2);
    sw->addCase(builder.getInt32(0), bodyStart);  // state 0: run from the top; -1: exhausted

    genSM = true;
    genSMState = stateTy;
    genSMStatePtr = rst;
    genSMElem = m.genElem;
    genSMIdx = 0;
    genSMCases.clear();

    builder.SetInsertPoint(bodyStart);
    emitBlock(m.body, /*newScope=*/false);  // natural control flow; yields split their blocks
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateStore(builder.getInt32(-1),
                            builder.CreateStructGEP(stateTy, rst, 0, "gen.st.addr"));
        builder.CreateBr(doneBB);  // ran off the end: the sequence is exhausted
    }
    builder.SetInsertPoint(doneBB);
    builder.CreateRet(llvm::ConstantInt::get(resumeF->getReturnType(), 0));
    for (const auto& [idx, blk] : genSMCases) {
        sw->addCase(builder.getInt32(idx), blk);
    }

    genSM = false;
    genSMState = nullptr;
    genSMStatePtr = nullptr;
}

void CodeGenerator::Impl::emitAsyncStateMachine(const ast::ClassDecl& cls, const ast::MethodDecl& m) {
    const std::string mangled = cls.name + "." + m.name;
    std::vector<std::pair<std::string, std::string>> tlocals;
    scanAsyncLocals(m.body, tlocals);
    const int awaitCount = countAsyncAwaits(m.body);

    // State layout: {i32 state, ptr task, args..., locals..., awaitHandles(i64)...}.
    std::vector<llvm::Type*> fields = {builder.getInt32Ty(), builder.getPtrTy()};
    const unsigned argBase = 2;
    for (const auto& p : m.params) {
        fields.push_back(llvmType(typeRefName(p.type)));
    }
    const unsigned localBase = static_cast<unsigned>(fields.size());
    for (const auto& l : tlocals) {
        fields.push_back(llvmType(l.second));
    }
    const unsigned awaitBase = static_cast<unsigned>(fields.size());
    for (int k = 0; k < awaitCount; ++k) {
        fields.push_back(builder.getInt64Ty());
    }
    const unsigned scratchBase = static_cast<unsigned>(fields.size());
    for (int k = 0; k < kAsyncScratchSlots; ++k) {
        fields.push_back(builder.getInt64Ty());
    }
    llvm::StructType* stateTy = llvm::StructType::create(context, fields, mangled + "$state");

    llvm::Function* res = functions[mangled + "$resume"];
    currentFn = res;
    currentClass = "";
    currentRetType = builder.getVoidTy();
    currentThis = nullptr;
    currentEnsures = nullptr;
    currentInvariants = nullptr;
    currentInvariantsToAssume = nullptr;
    currentDtorChain = "";
    locals.clear();
    scopeObjects.clear();
    stackObjectSlots_.clear();
    scopeRegions.clear();
    scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
    scopeValueStructs.clear();  // same, for coroutine-state value structs (B9)
    stringTemps.clear();
    lazyRegions_.clear();  // region/volatile tracking is keyed by local name; reset per function
    lazyRegionSize_.clear();
    lazyRegionAt_.clear();
    volatileRegions_.clear();
    regionCursorSlot_.clear();
    ownedRegions_.clear();
    regionFlavor_.clear();
    growableRegions_.clear();
    pendingRegionFlavor_.clear();
    volatileObjects_.clear();
    deferred.clear();
    escapingLocals_.clear();  // async bodies don't run the sync escape analysis; no stale carryover
    labelBlocks.clear(); comefromBlocks.clear();
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", res));
    llvm::Value* st = res->getArg(0);
    currentAsyncState = builder.CreateLoad(
        builder.getPtrTy(), builder.CreateStructGEP(stateTy, st, 1, "st.task.addr"), "st.task");
    for (std::size_t i = 0; i < m.params.size(); ++i) {
        locals[m.params[i].name] = LocalSlot{
            builder.CreateStructGEP(stateTy, st, argBase + i, m.params[i].name),
            typeRefName(m.params[i].type)};
    }
    for (std::size_t j = 0; j < tlocals.size(); ++j) {
        locals[tlocals[j].first] = LocalSlot{
            builder.CreateStructGEP(stateTy, st, localBase + j, tlocals[j].first),
            tlocals[j].second};
    }

    llvm::BasicBlock* bodyStart = llvm::BasicBlock::Create(context, "body", res);
    llvm::BasicBlock* suspendBlk = llvm::BasicBlock::Create(context, "suspend", res);
    llvm::Value* stateVal = builder.CreateLoad(
        builder.getInt32Ty(), builder.CreateStructGEP(stateTy, st, 0, "st.state.addr"), "st.state");
    llvm::SwitchInst* sw = builder.CreateSwitch(stateVal, bodyStart, awaitCount);

    // Enter state-machine mode: awaits in emitExpr now suspend/resume and record their cases.
    asyncSM = true;
    asyncSMState = stateTy;
    asyncSMStatePtr = st;
    asyncSMResume = res;
    asyncSMAwaitBase = awaitBase;
    asyncSMAwaitIdx = 0;
    asyncSMScratchBase = scratchBase;
    asyncSpillTop_ = 0;
    asyncSMSuspend = suspendBlk;
    asyncSMCases.clear();

    builder.SetInsertPoint(bodyStart);
    // A throw completes the task with the error. On Itanium the guard also hands back a record block
    // and carrier slot so a cleanup pad can run pending defers/destructors first (B8).
    llvm::BasicBlock* guardDispatch = nullptr;
    llvm::Value* guardCarrier = nullptr;
    llvm::BasicBlock* guard = buildAsyncGuardPad(&guardDispatch, &guardCarrier);
    ehPadStack.push_back(guard);
    // Real (freshly-cleared) base sizes so a throw with a pending defer/using/region/stack-dtor chains
    // its cleanup before completing the Task with the error (spec 21). On WinEH the cleanup funclet
    // chain feeds the guard directly; on Itanium the guard's itDispatch/itCarrier let the cleanup
    // landing pad run the teardown, then branch to the record block. Adds cleanup only when something
    // is pending; otherwise the throw unwinds straight to the guard.
    ehBaseStack.push_back({scopeObjects.size(), deferred.size(), scopeRegions.size(),
                           guardDispatch, guardCarrier});
    emitBlock(m.body, /*newScope=*/false);  // natural control flow; awaits split their blocks
    ehPadStack.pop_back();
    ehBaseStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        emitTaskComplete(nullptr);
        builder.CreateRetVoid();
    }
    builder.SetInsertPoint(suspendBlk);
    builder.CreateRetVoid();
    for (const auto& [idx, blk] : asyncSMCases) {
        sw->addCase(builder.getInt32(idx), blk);
    }

    asyncSM = false;
    currentAsyncState = nullptr;
    emitAsyncWrapper(stateTy, m, mangled);
}

void CodeGenerator::Impl::collectTests() {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported || bundle.isPrelude) {
            continue;
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) {
                        continue;
                    }
                    bool isTest = false;
                    const ast::AnnotationUse* ignore = nullptr;
                    const ast::AnnotationUse* cases = nullptr;
                    const ast::AnnotationUse* repeat = nullptr;
                    const ast::AnnotationUse* maxTime = nullptr;
                    const ast::AnnotationUse* bench = nullptr;
                    const ast::AnnotationUse* xfail = nullptr;
                    std::string tags;
                    const char* hook = nullptr;  // the lifecycle annotation this method carries
                    for (const ast::AnnotationUse& a : m->annotations) {
                        if (a.name == "Test") {
                            isTest = true;
                        } else if (a.name == "Ignore") {
                            ignore = &a;
                        } else if (a.name == "Cases") {
                            cases = &a;
                        } else if (a.name == "Repeat") {
                            repeat = &a;
                        } else if (a.name == "MaxTime") {
                            maxTime = &a;
                        } else if (a.name == "Benchmark") {
                            bench = &a;
                        } else if (a.name == "ExpectedToFail") {
                            xfail = &a;
                        } else if (a.name == "Tag") {
                            if (!tags.empty()) {
                                tags += ",";
                            }
                            tags += annotationStringArg(a, "name");
                        } else if (a.name == "BeforeAll" || a.name == "AfterAll" || a.name == "Setup" ||
                                   a.name == "Teardown") {
                            hook = a.name.c_str();
                        }
                    }
                    if (bench != nullptr) {
                        collectBenchmark(cls, *m, *bench, isTest);
                        continue;
                    }
                    if (hook != nullptr) {
                        collectHook(cls, *m, hook);
                        if (!isTest) {
                            continue;
                        }
                        errors.push_back(CodegenError{
                            std::string("'[") + hook + "]' and '[Test]' cannot mark the same method '" +
                                cls.name + "." + m->name + "': a hook runs around the tests, so it " +
                                "cannot be one of them",
                            m->loc});
                        continue;
                    }
                    if (!isTest) {
                        if (ignore != nullptr) {
                            errors.push_back(CodegenError{
                                "'[Ignore]' on '" + cls.name + "." + m->name +
                                    "' has no effect: it only applies to a '[Test]' method",
                                m->loc});
                        }
                        continue;
                    }
                    const std::string trt = typeRefName(m->returnType);
                    if (!m->isStatic || (trt != "boolean" && trt != "void")) {
                        errors.push_back(CodegenError{
                            "[Test] method '" + cls.name + "." + m->name +
                                "' must be a public static method returning boolean (the test's own "
                                "verdict) or void (the verdict comes from its Test.assert* calls)",
                            m->loc});
                        continue;
                    }
                    TestCase tc;
                    tc.sym = cls.name + "." + m->name;
                    tc.display = tc.sym;  // Class.method: what --filter matches and the report prints
                    tc.cls = cls.name;
                    tc.isVoid = trt == "void";  // spec 32.11: verdict is "no assertion failed"
                    tc.tags = tags;
                    if (ignore != nullptr) {
                        tc.ignored = true;
                        tc.ignoreReason = annotationStringArg(*ignore, "reason");
                    }
                    tc.expectedToFail = xfail != nullptr;
                    if (repeat != nullptr) {
                        tc.repeat = static_cast<int>(annotationIntArg(*repeat, "times", 1));
                        if (tc.repeat < 1) {
                            errors.push_back(CodegenError{
                                "'[Repeat(times: ...)]' on '" + tc.sym + "' needs a count of at "
                                "least 1", repeat->loc});
                            tc.repeat = 1;
                        }
                    }
                    if (maxTime != nullptr) {
                        tc.maxTimeNs = annotationIntArg(*maxTime, "ms", 0) * 1000000LL;
                    }
                    if (!collectCases(cls, *m, cases, tc)) {
                        continue;
                    }
                    testMethods.push_back(std::move(tc));
                }
            }
        }
    }
}

void CodeGenerator::Impl::collectHook(const ast::ClassDecl& cls, const ast::MethodDecl& m, const std::string& kind) {
    if (!m.isStatic || typeRefName(m.returnType) != "void") {
        errors.push_back(CodegenError{"'[" + kind + "]' method '" + cls.name + "." + m.name +
                                          "' must be a public static method returning void",
                                      m.loc});
        return;
    }
    TestHooks& h = testHooks_[cls.name];
    std::string& slot = kind == "BeforeAll" ? h.beforeAll
                      : kind == "AfterAll"  ? h.afterAll
                      : kind == "Setup"     ? h.setup
                                            : h.teardown;
    if (!slot.empty()) {
        errors.push_back(CodegenError{"class '" + cls.name + "' already has a '[" + kind +
                                          "]' method ('" + slot + "'); there may be only one, "
                                          "because two would have no defined order",
                                      m.loc});
        return;
    }
    slot = cls.name + "." + m.name;
}

void CodeGenerator::Impl::emitClassLoadHooks() {
    const bool bare = freestandingProgram();
    for (const ast::Bundle& b : program.bundles) {
        if (bare && b.isPrelude) {
            continue;
        }
        for (const ast::Namespace& n : b.namespaces) {
            for (const ast::ClassDecl& c : n.classes) {
                // `lazy import` defers a class's load to its first instance (spec 37.3).
                if (c.onClassLoad && !isLazyImport(c.name)) {
                    builder.CreateCall(functions[c.name + ".__onClassLoad"]);
                }
            }
        }
    }
}

void CodeGenerator::Impl::emitIfThen(llvm::Function* fn, llvm::Value* cond, const std::function<void()>& body) {
    llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "then", fn);
    llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "cont", fn);
    builder.CreateCondBr(cond, thenBB, contBB);
    builder.SetInsertPoint(thenBB);
    body();
    builder.CreateBr(contBB);
    builder.SetInsertPoint(contBB);
}

void CodeGenerator::Impl::emitTestRunner() {
    llvm::Type* i32 = builder.getInt32Ty();
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::Type* ptr = builder.getPtrTy();
    llvm::Type* v = builder.getVoidTy();

    llvm::FunctionType* mainTy = llvm::FunctionType::get(i32, {i32, ptr}, false);
    llvm::Function* mainFn =
        llvm::Function::Create(mainTy, llvm::Function::ExternalLinkage, "main", module);
    functions["@entry"] = mainFn;
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", mainFn));

    llvm::FunctionCallee beginFn = module.getOrInsertFunction(
        "__polaron_test_begin", llvm::FunctionType::get(v, {i32, ptr}, false));
    llvm::FunctionCallee shouldFn = module.getOrInsertFunction(
        "__polaron_test_should_run", llvm::FunctionType::get(i32, {ptr, ptr}, false));
    llvm::FunctionCallee startFn = module.getOrInsertFunction(
        "__polaron_test_start", llvm::FunctionType::get(v, {ptr, i32}, false));
    llvm::FunctionCallee recordFn = module.getOrInsertFunction(
        "__polaron_test_record", llvm::FunctionType::get(v, {ptr, i32, i64, ptr, i64}, false));
    llvm::FunctionCallee summaryFn =
        module.getOrInsertFunction("__polaron_test_summary", llvm::FunctionType::get(i32, {}, false));
    llvm::FunctionCallee nowFn =
        module.getOrInsertFunction("__polaron_now_ns", llvm::FunctionType::get(i64, {}, false));
    llvm::FunctionCallee cstrFn = module.getOrInsertFunction(
        "__polaron_str_cstr", llvm::FunctionType::get(ptr, {ptr}, false));
    llvm::FunctionCallee caseNameFn = module.getOrInsertFunction(
        "__polaron_test_case_name", llvm::FunctionType::get(ptr, {ptr, i64}, false));
    llvm::FunctionCallee repeatFailedFn = module.getOrInsertFunction(
        "__polaron_test_repeat_failed", llvm::FunctionType::get(v, {i64}, false));
    llvm::FunctionCallee abortedFn =
        module.getOrInsertFunction("__polaron_test_aborted", llvm::FunctionType::get(i32, {}, false));

    auto argIt = mainFn->arg_begin();
    llvm::Value* argc = &*argIt++;
    llvm::Value* argv = &*argIt;
    builder.CreateCall(beginFn, {argc, argv});
    emitClassLoadHooks();  // the program's classes load before its tests run, exactly as in main

    // A prelude static, by "Class.method". Absent only if the stdlib was not linked in.
    auto prelude = [&](const char* sym) -> llvm::Function* {
        const auto it = functions.find(sym);
        return it == functions.end() ? nullptr : it->second;
    };
    llvm::Function* resetFn = prelude("Test.reset");
    llvm::Function* failuresFn = prelude("Test.failures");
    llvm::Function* skippedFn = prelude("Test.wasSkipped");
    llvm::Function* reasonFn = prelude("Test.skipReason");
    auto callHook = [&](const std::string& sym) {
        if (sym.empty()) {
            return;
        }
        if (const auto it = functions.find(sym); it != functions.end()) {
            builder.CreateCall(it->second, {});
        }
    };

    // Group by class, keeping first-appearance order, so a class's [BeforeAll]/[AfterAll] bracket
    // exactly its own tests however they are interleaved in the source.
    std::vector<std::string> classOrder;
    std::map<std::string, std::vector<const TestCase*>> byClass;
    for (const TestCase& t : testMethods) {
        if (byClass.find(t.cls) == byClass.end()) {
            classOrder.push_back(t.cls);
        }
        byClass[t.cls].push_back(&t);
    }
    static const TestHooks kNoHooks;

    for (const std::string& cls : classOrder) {
        const auto hookIt = testHooks_.find(cls);
        const TestHooks& hooks = hookIt == testHooks_.end() ? kNoHooks : hookIt->second;
        const std::vector<const TestCase*>& cases = byClass[cls];

        // Ask the selection question for every test FIRST, then reuse the answers: the class's
        // expensive [BeforeAll] fixture must not be built when --filter selected none of them.
        std::vector<llvm::Value*> selected;
        llvm::Value* anySelected = builder.getInt1(false);
        for (const TestCase* t : cases) {
            llvm::Value* nameStr = createGlobalStringPtr(builder, t->display, ".test.name");
            llvm::Value* tagStr = createGlobalStringPtr(builder, t->tags, ".test.tags");
            llvm::Value* s = builder.CreateICmpNE(builder.CreateCall(shouldFn, {nameStr, tagStr}),
                                                  builder.getInt32(0), "sel");
            selected.push_back(s);
            anySelected = builder.CreateOr(anySelected, s, "any");
        }
        emitIfThen(mainFn, anySelected, [&] { callHook(hooks.beforeAll); });

        // Runs one test (or one row of a [Cases] test) under `caseName`, and reports it.
        auto runOne = [&](const TestCase& t, llvm::Value* caseName, llvm::Value* arg) {
            const auto fnIt = functions.find(t.sym);
            if (fnIt == functions.end()) {
                return;
            }
            // Name the test to the runtime BEFORE running it, so the first failing assertion can
            // print the "FAIL <name>" header itself and its details read underneath.
            builder.CreateCall(startFn,
                               {caseName, builder.getInt32(t.expectedToFail ? 1 : 0)});
            llvm::Value* started = builder.CreateCall(nowFn, {}, "t0");
            // [Repeat(times: N)] runs the whole thing N times and reports ONE verdict: a test
            // that fails 3 times in 100 is a flaky test, and 100 report lines would bury that.
            llvm::Value* failCount = builder.CreateAlloca(i32, nullptr, "failcount");
            builder.CreateStore(builder.getInt32(0), failCount);
            for (int rep = 0; rep < t.repeat; ++rep) {
                // Reset before EVERY run (not just the void ones): the failure count, the
                // Test.checking label and the skip flag must never bleed into the next.
                if (resetFn != nullptr) {
                    builder.CreateCall(resetFn, {});
                }
                callHook(hooks.setup);
                llvm::Value* failed = nullptr;
                llvm::SmallVector<llvm::Value*, 1> callArgs;
                if (arg != nullptr && fnIt->second->arg_size() >= 1) {
                    callArgs.push_back(coerceToType(arg, fnIt->second->getArg(0)->getType()));
                }
                if (t.isVoid) {
                    // spec 32.11: a void test passes when none of its Test.assert* calls failed.
                    builder.CreateCall(fnIt->second, callArgs);
                    llvm::Value* f = failuresFn != nullptr
                                         ? builder.CreateCall(failuresFn, {}, "fails")
                                         : llvm::cast<llvm::Value>(builder.getInt32(0));
                    failed = builder.CreateICmpNE(f, builder.getInt32(0), "failed");
                } else {
                    llvm::Value* r = builder.CreateCall(fnIt->second, callArgs, "verdict");
                    failed = builder.CreateICmpEQ(r, builder.getInt32(0), "failed");
                }
                // [Teardown] runs before the clock stops: releasing the fixture is part of the
                // test's cost, and a teardown that hangs should show up as a slow test.
                callHook(hooks.teardown);
                if (t.repeat > 1) {
                    const int iteration = rep + 1;
                    emitIfThen(mainFn, failed, [&] {
                        builder.CreateCall(repeatFailedFn, {builder.getInt64(iteration)});
                    });
                }
                builder.CreateStore(
                    builder.CreateAdd(builder.CreateLoad(i32, failCount),
                                      builder.CreateZExt(failed, i32)),
                    failCount);
            }
            llvm::Value* anyFailed = builder.CreateICmpNE(builder.CreateLoad(i32, failCount),
                                                          builder.getInt32(0), "anyfailed");
            llvm::Value* elapsed =
                builder.CreateSub(builder.CreateCall(nowFn, {}, "t1"), started, "ns");
            // Test.skip(why) at runtime outranks the pass/fail verdict: the test never reached
            // the point of having one.
            llvm::Value* skipped =
                skippedFn != nullptr
                    ? builder.CreateICmpNE(builder.CreateCall(skippedFn, {}, "skipped"),
                                           builder.getInt32(0))
                    : llvm::cast<llvm::Value>(builder.getInt1(false));
            llvm::Value* why =
                reasonFn != nullptr
                    ? builder.CreateCall(cstrFn, {builder.CreateCall(reasonFn, {}, "why")})
                    : llvm::cast<llvm::Value>(createGlobalStringPtr(builder, "", ".test.why"));
            // [ExpectedToFail] inverts the verdict: failing is the expected outcome (3), and
            // passing is itself a failure (4) -- the bug got fixed and the annotation is a lie.
            llvm::Value* pass = t.expectedToFail ? builder.getInt32(4) : builder.getInt32(0);
            llvm::Value* fail = t.expectedToFail ? builder.getInt32(3) : builder.getInt32(1);
            llvm::Value* verdict = builder.CreateSelect(
                skipped, builder.getInt32(2), builder.CreateSelect(anyFailed, fail, pass),
                "verdict");
            builder.CreateCall(recordFn,
                               {caseName, verdict, elapsed, why, builder.getInt64(t.maxTimeNs)});
        };

        for (std::size_t i = 0; i < cases.size(); ++i) {
            const TestCase& t = *cases[i];
            // --fail-fast is asked HERE, not in the selection above: selection is decided for the
            // whole class before anything runs, so at that point nothing has failed yet.
            llvm::Value* live = builder.CreateAnd(
                selected[i],
                builder.CreateICmpEQ(builder.CreateCall(abortedFn, {}, "aborted"),
                                     builder.getInt32(0)),
                "live");
            emitIfThen(mainFn, live, [&] {
                llvm::Value* nameStr = createGlobalStringPtr(builder, t.display, ".test.name");
                if (t.ignored) {
                    // [Ignore]: never run, reported as a skip carrying its reason, so a
                    // known-broken case stays visible instead of quietly disappearing.
                    builder.CreateCall(
                        recordFn,
                        {nameStr, builder.getInt32(2), builder.getInt64(0),
                         createGlobalStringPtr(builder, t.ignoreReason, ".test.why"),
                         builder.getInt64(0)});
                    return;
                }
                if (t.casesSym.empty()) {
                    runOne(t, nameStr, nullptr);
                    return;
                }
                // [Cases]: call the source once, then run the body over every row, each reported
                // as its own result under "Class.method[i]".
                const auto srcIt = functions.find(t.casesSym);
                if (srcIt == functions.end()) {
                    return;
                }
                llvm::Value* block = builder.CreateCall(srcIt->second, {}, "rows");
                llvm::Value* len = builder.CreateLoad(i64, block, "rows.len");
                llvm::Type* storageTy = arrayStorageTy(t.paramType);
                llvm::Value* iv = builder.CreateAlloca(i64, nullptr, "row");
                builder.CreateStore(builder.getInt64(0), iv);
                llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "rows.cond", mainFn);
                llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "rows.body", mainFn);
                llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "rows.done", mainFn);
                builder.CreateBr(condBB);
                builder.SetInsertPoint(condBB);
                llvm::Value* i0 = builder.CreateLoad(i64, iv, "i");
                builder.CreateCondBr(builder.CreateICmpULT(i0, len), bodyBB, doneBB);
                builder.SetInsertPoint(bodyBB);
                llvm::Value* i1 = builder.CreateLoad(i64, iv, "i");
                llvm::Value* elemPtr =
                    builder.CreateGEP(storageTy, arrayData(block), i1, "row.elem");
                llvm::Value* value = builder.CreateLoad(storageTy, elemPtr, "row.val");
                if (t.paramType == "boolean") {  // 1-byte storage, i32 value
                    value = builder.CreateZExt(value, i32);
                }
                llvm::Value* caseName = builder.CreateCall(caseNameFn, {nameStr, i1}, "casename");
                runOne(t, caseName, value);
                builder.CreateStore(builder.CreateAdd(i1, builder.getInt64(1)), iv);
                builder.CreateBr(condBB);
                builder.SetInsertPoint(doneBB);
            });
        }
        emitIfThen(mainFn, anySelected, [&] { callHook(hooks.afterAll); });
    }
    emitBenchmarks(mainFn);
    builder.CreateRet(builder.CreateCall(summaryFn, {}, "rc"));
}

void CodeGenerator::Impl::emitBenchmarks(llvm::Function* mainFn) {
    if (benchMethods.empty()) {
        return;
    }
    llvm::Type* i32 = builder.getInt32Ty();
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::Type* ptr = builder.getPtrTy();
    llvm::FunctionCallee shouldFn = module.getOrInsertFunction(
        "__polaron_bench_should_run", llvm::FunctionType::get(i32, {ptr}, false));
    llvm::FunctionCallee recordFn = module.getOrInsertFunction(
        "__polaron_bench_record",
        llvm::FunctionType::get(builder.getVoidTy(), {ptr, i64, i64}, false));
    llvm::FunctionCallee nowFn =
        module.getOrInsertFunction("__polaron_now_ns", llvm::FunctionType::get(i64, {}, false));

    for (const BenchCase& b : benchMethods) {
        const auto fnIt = functions.find(b.sym);
        if (fnIt == functions.end()) {
            continue;
        }
        llvm::Value* nameStr = createGlobalStringPtr(builder, b.display, ".bench.name");
        llvm::Value* sel = builder.CreateICmpNE(builder.CreateCall(shouldFn, {nameStr}),
                                                builder.getInt32(0), "bsel");
        emitIfThen(mainFn, sel, [&] {
            auto loop = [&](long long count, const char* tag) {
                if (count <= 0) {
                    return;
                }
                llvm::Value* iv = builder.CreateAlloca(i64, nullptr, tag);
                builder.CreateStore(builder.getInt64(0), iv);
                llvm::BasicBlock* c = llvm::BasicBlock::Create(context, "b.cond", mainFn);
                llvm::BasicBlock* bd = llvm::BasicBlock::Create(context, "b.body", mainFn);
                llvm::BasicBlock* d = llvm::BasicBlock::Create(context, "b.done", mainFn);
                builder.CreateBr(c);
                builder.SetInsertPoint(c);
                llvm::Value* i0 = builder.CreateLoad(i64, iv);
                builder.CreateCondBr(builder.CreateICmpULT(i0, builder.getInt64(count)), bd, d);
                builder.SetInsertPoint(bd);
                builder.CreateCall(fnIt->second, {});
                builder.CreateStore(builder.CreateAdd(builder.CreateLoad(i64, iv),
                                                      builder.getInt64(1)),
                                    iv);
                builder.CreateBr(c);
                builder.SetInsertPoint(d);
            };
            loop(b.warmup, "warm");  // untimed: let the caches and the branch predictor settle
            llvm::Value* t0 = builder.CreateCall(nowFn, {}, "b0");
            loop(b.iterations, "iter");
            llvm::Value* total =
                builder.CreateSub(builder.CreateCall(nowFn, {}, "b1"), t0, "bns");
            builder.CreateCall(recordFn, {nameStr, total, builder.getInt64(b.iterations)});
        });
    }
}

void CodeGenerator::Impl::emitFunctions() {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported) {
            continue;  // bodies live in the depended-on .polb (declared external)
        }
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                bool hasCtor = false;
                enclosingClass_ = cls.name;
                // Announce WHICH class this is, by key: the walk knows, and a body reached from a
                // worklist later does not. Cleared after the class so a worklist body does not
                // inherit it.
                {
                    const std::string byPath = bundle.name + "." + ns.name + "." + cls.name;
                    emittingClassKey = classes.count(byPath) > 0 ? byPath : cls.name;
                }
                // The same key the declarations were registered under (see declareFunctions): a
                // shared name's symbols carry the path, so a body must be attached to the function
                // that belongs to THIS class rather than to whichever one was declared first.
                const std::string ck = emittingClassKey;
                // POLARON_SHOW_BODIES=1: the class about to be emitted, printed BEFORE the work
                // starts. A crash inside a body otherwise leaves no trace of which one it was in,
                // and the phase timer only reports bodies that finish.
                if (std::getenv("POLARON_SHOW_BODIES") != nullptr) {
                    std::fprintf(stderr, "[body] %s\n", ck.c_str());
                }
                for (const ast::MemberPtr& member : cls.members) {
                    // POLARON_PHASE_TIMES=1: report any single body that takes real time, so "codegen is
                    // slow" becomes "THIS method is slow" -- which is how the 181 s PageFlags.hash
                    // (an exponential typeName recursion) was found. Off by default, and free then.
                    static const bool bodyTimes = std::getenv("POLARON_PHASE_TIMES") != nullptr;
                    const auto bodyStart = bodyTimes ? std::chrono::steady_clock::now()
                                                     : std::chrono::steady_clock::time_point{};
                    auto reportBody = [&]() {
                        if (!bodyTimes) {
                            return;
                        }
                        const auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
                            std::chrono::steady_clock::now() - bodyStart).count();
                        if (ms < 200) {
                            return;
                        }
                        const auto* md = dynamic_cast<const ast::MethodDecl*>(member.get());
                        const std::string bodyName =
                            cls.name + "." + (md != nullptr ? md->name : std::string("<ctor/dtor>"));
                        std::fprintf(stderr, "[body] %-40s %lld ms\n", bodyName.c_str(),
                                     (long long)ms);
                    };
                    struct Reporter { std::function<void()> f; ~Reporter(){ f(); } } rep{reportBody};
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        enclosingMethod_ = m->name;
                        noBoundsCheck_ = hasAttribute(*m, "no_bounds_check");  // spec 36.4
                        if (m == entry.method && !testMode) {
                            emitBody(functions["@entry"], m->body, m->params, "",
                                     builder.getInt32Ty(), nullptr, nullptr, nullptr, nullptr, false,
                                     nullptr, nullptr, "", nullptr, false,
                                     /*argvEntry=*/entryHasCRuntime());
                        } else if (m->isGeneratorBody) {
                            emitGeneratorMethod(cls, *m);  // spec 22.6: $start/$resume/$current/$free
                        } else if (m->isAsync && !m->isAbstract) {
                            emitAsyncMethod(cls, *m);
                        } else if (!m->isAbstract && !m->isExtern) {  // extern: no Polaron body
                            emitBody(functions[ck + "." + m->name], m->body, m->params,
                                     m->isStatic ? std::string() : cls.name,
                                     llvmType(typeRefName(m->returnType)), nullptr,
                                     &m->requiresClauses, &m->ensuresClauses,
                                     m->isStatic ? nullptr : &classInvariants(cls.name),
                                     false, nullptr, nullptr, "", nullptr, false, false,
                                     typeRefName(m->returnType));  // String RAII: copy-on-return key
                        }
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        hasCtor = true;
                        noBoundsCheck_ = false;
                        enclosingMethod_ = cls.name;  // ctor function is "class.class"
                        emitBody(functions[ck + "." + cls.name], c->body, c->params,
                                 cls.name, builder.getVoidTy(), &cls,
                                 &c->requiresClauses, &c->ensuresClauses,
                                 &classInvariants(cls.name));
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        // Chain to the nearest ancestor's destructor (derived-then-base).
                        enclosingMethod_ = "~" + cls.name;  // dtor function is "class.~class"
                        emitBody(functions[ck + ".~" + cls.name], d->body, {}, cls.name,
                                 builder.getVoidTy(), nullptr, nullptr, nullptr, nullptr, false,
                                 nullptr, nullptr, dtorImpl(cls.superclass), &cls);
                    }
                }
                // Emit the synthesized default constructor (sets the vtable +
                // field inits). Interfaces get none.
                if (!hasCtor && !cls.isInterface) {
                    const ast::Block emptyBody;
                    enclosingMethod_ = cls.name;
                    emitBody(functions[ck + "." + cls.name], emptyBody, {}, cls.name,
                             builder.getVoidTy(), &cls);
                }
                // ...and the synthesized destructor of an unimportable class that wrote none.
                // Its whole body is the decrement, which emitBody adds for it: the class is
                // unimportable, so the live-instance counter is maintained on both ends.
                if (synthesizedDtors_.count(cls.name) > 0) {
                    const ast::Block emptyBody;
                    enclosingMethod_ = "~" + cls.name;
                    emitBody(functions[ck + ".~" + cls.name], emptyBody, {}, cls.name,
                             builder.getVoidTy(), nullptr, nullptr, nullptr, nullptr, false,
                             nullptr, nullptr, dtorImpl(cls.superclass), &cls);
                }
                // spec 32.5: static-context hook bodies.
                auto emitHook = [&](const std::unique_ptr<ast::Block>& b, const char* suffix) {
                    if (b) {
                        emitBody(functions[ck + suffix], *b, {}, /*thisClass=*/"",
                                 builder.getVoidTy());
                    }
                };
                emitHook(cls.onClassLoad, ".__onClassLoad");
                emitHook(cls.onFirstInstance, ".__onFirstInstance");
                emitHook(cls.onLastInstanceDestroyed, ".__onLastInstanceDestroyed");
                emitHook(cls.onClassUnload, ".__onClassUnload");
                // F9 opaque bundles: bodies of the exported __new (malloc the real layout, run the
                // constructor) and __delete (destruct + free). Library mode only; a consumer just
                // calls these to create/destroy an instance it cannot lay out itself.
                if (libraryMode && !cls.isInterface && !cls.isAbstract &&
                    cls.visibility == "public" && needFn(ck + ".__new") != nullptr &&
                    needFn(ck + ".__delete") != nullptr) {
                    llvm::Function* nf = needFn(ck + ".__new");
                    currentFn = nf;
                    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", nf));
                    // A region class exported from a library is still total: the consumer cannot lay
                    // the object out, and it may not place it either. `__new` reaches the same arena
                    // `new A()` does, so a bundle boundary is not a way out of "there is nowhere
                    // else" -- which is the property the narrow `A*` in its fields is computed from.
                    llvm::Value* obj =
                        cls.isRegionClass
                            ? classArenaAlloc(cls.name, sizeOf(classes[cls.name].type))
                            : builder.CreateCall(mallocFn(), {sizeOf(classes[cls.name].type)},
                                                 cls.name + ".obj");
                    std::vector<llvm::Value*> cargs{obj};
                    for (auto& a : nf->args()) {
                        cargs.push_back(&a);
                    }
                    builder.CreateCall(functions[ck + "." + cls.name], cargs);
                    builder.CreateRet(obj);

                    llvm::Function* df = needFn(ck + ".__delete");
                    currentFn = df;
                    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", df));
                    emitDeleteObject(df->getArg(0), cls.name);
                    builder.CreateRetVoid();
                }
            }
            // Literal suffix bodies: emitted as static functions (no `this`), namespace-level
            // (legacy) and class/struct-owned.
            auto emitLiteralBody = [&](const ast::LiteralDecl& lit) {
                emitBody(functions[lit.name + "$" + typeRefName(lit.param.type)], lit.body,
                         {lit.param}, /*thisClass=*/"", llvmType(typeRefName(lit.returnType)));
            };
            for (const ast::LiteralDecl& lit : ns.literals) {
                emitLiteralBody(lit);
            }
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get())) {
                        emitLiteralBody(*lit);
                    }
                }
            }
            // Catalog-implementing enum method bodies (spec 12.4). For an instance
            // method, `this` is the enum value (an i32 ordinal), so thisClass is the
            // enum name (binds currentThis to arg 0) but there is no vtable/field init.
            for (const ast::EnumDecl& en : ns.enums) {
                if (en.isJavaStyle) {
                    continue;
                }
                for (const ast::MemberPtr& member : en.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isAbstract) {
                        continue;
                    }
                    emitBody(functions[en.name + "." + m->name], m->body, m->params,
                             m->isStatic ? std::string() : en.name,
                             llvmType(typeRefName(m->returnType)), nullptr,
                             &m->requiresClauses, &m->ensuresClauses,
                             nullptr, false, nullptr, nullptr, "", nullptr, false, false,
                             typeRefName(m->returnType));  // String RAII: copy-on-return key
                }
            }
        }
    }
}

}  // namespace polaron
