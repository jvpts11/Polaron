#include "codegen/codegen_impl.h"

namespace polaron {

void CodeGenerator::Impl::emitWhile(const ast::WhileStmt& s) {
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "while.cond", fn);
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "while.body", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "while.end", fn);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* condV = emitExpr(*s.cond);
    if (condV == nullptr) {
        return;
    }
    freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
    builder.CreateCondBr(asI1(condV), bodyBB, endBB);
    builder.SetInsertPoint(bodyBB);
    loopStack.push_back({endBB, condBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});  // break -> end, continue -> cond
    pendingLoopLabel.clear();
    emitBlock(s.body);
    loopStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(condBB);
    }
    builder.SetInsertPoint(endBB);
}

void CodeGenerator::Impl::emitDoWhile(const ast::DoWhileStmt& s) {
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "do.body", fn);
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "do.cond", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "do.end", fn);
    builder.CreateBr(bodyBB);
    builder.SetInsertPoint(bodyBB);
    loopStack.push_back({endBB, condBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});  // break -> end, continue -> cond
    pendingLoopLabel.clear();
    emitBlock(s.body);
    loopStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(condBB);
    }
    builder.SetInsertPoint(condBB);
    llvm::Value* condV = emitExpr(*s.cond);
    if (condV == nullptr) {
        return;
    }
    freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
    builder.CreateCondBr(asI1(condV), bodyBB, endBB);
    builder.SetInsertPoint(endBB);
}

void CodeGenerator::Impl::emitFor(const ast::ForStmt& s) {
    if (s.init) {
        emitStatement(*s.init);
    }
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "for.cond", fn);
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "for.body", fn);
    llvm::BasicBlock* updateBB = llvm::BasicBlock::Create(context, "for.update", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "for.end", fn);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* condV = emitExpr(*s.cond);
    if (condV == nullptr) {
        return;
    }
    freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
    builder.CreateCondBr(asI1(condV), bodyBB, endBB);
    builder.SetInsertPoint(bodyBB);
    loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});  // break -> end, continue -> update
    pendingLoopLabel.clear();
    emitBlock(s.body);
    loopStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(updateBB);
    }
    builder.SetInsertPoint(updateBB);
    if (s.update) {
        emitStatement(*s.update);
    }
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(condBB);
    }
    builder.SetInsertPoint(endBB);
}

void CodeGenerator::Impl::emitForeach(const ast::ForeachStmt& s) {
    if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(s.iterable.get())) {
        emitForeachRange(s, *rng);
        return;
    }
    const std::string at = typeName(*s.iterable);
    const std::string cbase = baseType(at);
    // foreach over a collection iterates a snapshot from its toArray() (spec 34): any class with a
    // toArray method is iterable. Arrays are iterated directly.
    const bool isCollection =
        classes.count(cbase) > 0 && functions.count(cbase + ".toArray") > 0;
    // Iterable / Iterator (spec 9.2): a class with no toArray but with `iterator()` (Iterable) or with
    // `hasNext()`/`next()` (Iterator itself) is iterated LAZILY, calling next() one element at a time --
    // no snapshot, so an infinite or expensive sequence works. Interface receivers dispatch virtually.
    if (!isCollection && classes.count(cbase) > 0 && emitForeachIterable(s, cbase)) {
        return;
    }
    llvm::Value* block;
    std::string et;
    if (isCollection) {
        llvm::Value* recv = emitExpr(*s.iterable);
        if (recv == nullptr) {
            return;
        }
        block = builder.CreateCall(functions[cbase + ".toArray"], {recv}, "fe.arr");
        const std::string ret = classes[cbase].methodReturnType.count("toArray") > 0
                                    ? classes[cbase].methodReturnType.at("toArray")
                                    : "";
        et = s.isVar ? (isArrayType(ret) ? ret.substr(0, ret.size() - 2) : ret)
                     : typeRefName(s.elemType);
    } else {
        block = emitExpr(*s.iterable);
        if (block == nullptr) {
            return;
        }
        et = s.isVar ? (isArrayType(at) ? at.substr(0, at.size() - 2) : at)
                     : typeRefName(s.elemType);
    }
    llvm::Value* len64 = builder.CreateLoad(builder.getInt64Ty(), block, "fe.len");
    llvm::Value* len = builder.CreateTrunc(len64, builder.getInt32Ty(), "fe.len32");
    llvm::Value* iSlot = createEntryAlloca("fe.i", builder.getInt32Ty());
    builder.CreateStore(builder.getInt32(0), iSlot);
    llvm::Value* vSlot = createEntryAlloca(s.varName, llvmType(et));
    locals[s.varName] = LocalSlot{vSlot, et};
    declareLocalDebug(vSlot, s.varName, et, s.loc);  // -g: inspect the loop element in the debugger
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "fe.cond", fn);
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "fe.body", fn);
    llvm::BasicBlock* updateBB = llvm::BasicBlock::Create(context, "fe.update", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "fe.end", fn);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* i = builder.CreateLoad(builder.getInt32Ty(), iSlot, "fe.iv");
    builder.CreateCondBr(builder.CreateICmpSLT(i, len), bodyBB, endBB);
    builder.SetInsertPoint(bodyBB);
    // The `index i` form (spec 7.6): expose the loop counter as an int local.
    if (!s.indexName.empty()) {
        locals[s.indexName] = LocalSlot{iSlot, "int"};
        declareLocalDebug(iSlot, s.indexName, "int", s.loc);  // -g
    }
    llvm::Type* feElemTy = arrayStorageTy(et);
    llvm::Value* elem =
        builder.CreateLoad(feElemTy, arrayElemPtr(block, i, feElemTy), "fe.el");
    if (et == "boolean") {
        elem = builder.CreateZExt(elem, builder.getInt32Ty());  // i8 slot -> i32 value
    }
    builder.CreateStore(elem, vSlot);
    loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});
    pendingLoopLabel.clear();
    emitBlock(s.body);
    loopStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(updateBB);
    }
    builder.SetInsertPoint(updateBB);
    llvm::Value* iv = builder.CreateLoad(builder.getInt32Ty(), iSlot);
    builder.CreateStore(builder.CreateAdd(iv, builder.getInt32(1)), iSlot);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(endBB);
    locals.erase(s.varName);
    if (!s.indexName.empty()) {
        locals.erase(s.indexName);
    }
}

bool CodeGenerator::Impl::emitForeachIterable(const ast::ForeachStmt& s, const std::string& cbase) {
    llvm::FunctionType* ptrToPtr =
        llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
    std::string itCls = cbase;
    llvm::Value* itObj = nullptr;
    // Who owns the iterator object? The loop does whenever it is fresh: either the loop called
    // iterator() itself, or the subject is a call that minted one (a generator, or an explicit
    // `list.iterator()`) -- a returned object is the caller's to own. A subject that is a variable
    // or a field is borrowed and must survive the loop, so it is left alone.
    bool ownsIterator = false;
    const bool selfIterator =
        !methodOwner(cbase, "hasNext").empty() && !methodOwner(cbase, "next").empty();
    if (selfIterator) {
        itObj = emitExpr(*s.iterable);       // the subject is the iterator
        ownsIterator = dynamic_cast<const ast::CallExpr*>(s.iterable.get()) != nullptr ||
                       dynamic_cast<const ast::NewExpr*>(s.iterable.get()) != nullptr;
    } else if (!methodOwner(cbase, "iterator").empty()) {
        llvm::Value* recv = emitExpr(*s.iterable);
        if (recv == nullptr) {
            return false;
        }
        const std::string owner = methodOwner(cbase, "iterator");
        const std::string ret = classes[clsKey(owner)].methodReturnType.at("iterator");
        itCls = baseType(ret);
        if (methodOwner(itCls, "hasNext").empty() || methodOwner(itCls, "next").empty()) {
            return false;
        }
        itObj = emitDynCall(cbase, "iterator", ptrToPtr, recv);
        ownsIterator = true;  // the loop minted it, so the loop disposes it
    } else {
        return false;
    }
    if (itObj == nullptr) {
        return false;
    }

    const std::string nextOwner = methodOwner(itCls, "next");
    const std::string retT = classes[clsKey(nextOwner)].methodReturnType.at("next");
    const std::string et = s.isVar ? retT : typeRefName(s.elemType);
    llvm::Type* elemTy = llvmType(et);
    llvm::FunctionType* hasNextTy =
        llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, false);
    llvm::FunctionType* nextTy =
        llvm::FunctionType::get(elemTy, {builder.getPtrTy()}, false);

    llvm::Value* itSlot = createEntryAlloca("fe.it", builder.getPtrTy());
    builder.CreateStore(itObj, itSlot);
    if (ownsIterator) {
        // Registered as a scope cleanup, not freed at the loop's end block: that way it is disposed
        // on every exit -- falling off the end, `break`, `return`, or an exception unwind.
        Cleanup c;
        c.slot = itSlot;
        c.className = itCls;
        c.heap = true;
        c.virtualDelete = true;
        deferred.push_back(c);
    }
    llvm::Value* vSlot = createEntryAlloca(s.varName, elemTy);
    locals[s.varName] = LocalSlot{vSlot, et};
    declareLocalDebug(vSlot, s.varName, et, s.loc);
    // The `index i` form (spec 7.6) still works: count the elements as they come.
    llvm::Value* iSlot = createEntryAlloca("fe.i", builder.getInt32Ty());
    builder.CreateStore(builder.getInt32(0), iSlot);

    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "fei.cond", fn);
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "fei.body", fn);
    llvm::BasicBlock* updateBB = llvm::BasicBlock::Create(context, "fei.update", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "fei.end", fn);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* it = builder.CreateLoad(builder.getPtrTy(), itSlot, "fei.itv");
    llvm::Value* more = emitDynCall(itCls, "hasNext", hasNextTy, it);
    if (more == nullptr) {
        return false;
    }
    builder.CreateCondBr(builder.CreateICmpNE(more, builder.getInt32(0)), bodyBB, endBB);

    builder.SetInsertPoint(bodyBB);
    if (!s.indexName.empty()) {
        locals[s.indexName] = LocalSlot{iSlot, "int"};
        declareLocalDebug(iSlot, s.indexName, "int", s.loc);
    }
    llvm::Value* it2 = builder.CreateLoad(builder.getPtrTy(), itSlot, "fei.itv2");
    llvm::Value* elem = emitDynCall(itCls, "next", nextTy, it2);
    if (elem == nullptr) {
        return false;
    }
    builder.CreateStore(elem, vSlot);
    loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(),
                         scopeObjects.size(), deferred.size(), scopeRegions.size()});
    pendingLoopLabel.clear();
    emitBlock(s.body);
    loopStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(updateBB);
    }
    builder.SetInsertPoint(updateBB);
    llvm::Value* iv = builder.CreateLoad(builder.getInt32Ty(), iSlot, "fei.iv");
    builder.CreateStore(builder.CreateAdd(iv, builder.getInt32(1)), iSlot);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(endBB);
    locals.erase(s.varName);
    if (!s.indexName.empty()) {
        locals.erase(s.indexName);
    }
    return true;
}

void CodeGenerator::Impl::emitForeachRange(const ast::ForeachStmt& s, const ast::RangeExpr& rng) {
    const std::string et = s.isVar ? typeName(*rng.start) : typeRefName(s.elemType);
    llvm::Type* ty = llvmType(et);
    if (!ty->isIntegerTy()) {
        ty = builder.getInt32Ty();
    }
    llvm::Value* start = coerceToType(emitExpr(*rng.start), ty);
    llvm::Value* end = coerceToType(emitExpr(*rng.end), ty);
    llvm::Value* step =
        rng.step ? coerceToType(emitExpr(*rng.step), ty) : llvm::ConstantInt::get(ty, 1);
    if (start == nullptr || end == nullptr || step == nullptr) {
        return;
    }
    llvm::Value* vSlot = createEntryAlloca(s.varName, ty);
    builder.CreateStore(start, vSlot);
    locals[s.varName] = LocalSlot{vSlot, et};
    declareLocalDebug(vSlot, s.varName, et, s.loc);  // -g: inspect the loop value in the debugger
    // The `index i` form (spec 7.6): a 0-based counter alongside the range value.
    llvm::Value* idxSlot = nullptr;
    if (!s.indexName.empty()) {
        idxSlot = createEntryAlloca(s.indexName, builder.getInt32Ty());
        builder.CreateStore(builder.getInt32(0), idxSlot);
        locals[s.indexName] = LocalSlot{idxSlot, "int"};
        declareLocalDebug(idxSlot, s.indexName, "int", s.loc);  // -g
    }
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "fr.cond", fn);
    llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "fr.body", fn);
    llvm::BasicBlock* updateBB = llvm::BasicBlock::Create(context, "fr.update", fn);
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "fr.end", fn);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* i = builder.CreateLoad(ty, vSlot, "fr.iv");
    llvm::Value* cont =
        rng.inclusive ? builder.CreateICmpSLE(i, end) : builder.CreateICmpSLT(i, end);
    builder.CreateCondBr(cont, bodyBB, endBB);
    builder.SetInsertPoint(bodyBB);
    loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(),
                         scopeObjects.size(), deferred.size(), scopeRegions.size()});
    pendingLoopLabel.clear();
    emitBlock(s.body);
    loopStack.pop_back();
    if (builder.GetInsertBlock()->getTerminator() == nullptr) {
        builder.CreateBr(updateBB);
    }
    builder.SetInsertPoint(updateBB);
    llvm::Value* iv = builder.CreateLoad(ty, vSlot);
    builder.CreateStore(builder.CreateAdd(iv, step), vSlot);
    if (idxSlot != nullptr) {
        llvm::Value* c = builder.CreateLoad(builder.getInt32Ty(), idxSlot);
        builder.CreateStore(builder.CreateAdd(c, builder.getInt32(1)), idxSlot);
    }
    builder.CreateBr(condBB);
    builder.SetInsertPoint(endBB);
    locals.erase(s.varName);
    if (!s.indexName.empty()) {
        locals.erase(s.indexName);
    }
}

void CodeGenerator::Impl::emitSwitch(const ast::SwitchStmt& s) {
    llvm::Value* subj = emitExpr(*s.subject);
    if (subj == nullptr) {
        return;
    }
    // A String subject compares by value (content), not by pointer identity, so a string case
    // literal actually matches (spec 7.3 extension). Other subjects compare as integers.
    const std::string subjType = typeName(*s.subject);
    const bool isStr = (subjType == "String" || subjType == "string");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "switch.end", fn);
    const std::size_t n = s.cases.size();
    std::vector<llvm::BasicBlock*> bodyBBs;
    for (std::size_t i = 0; i < n; ++i) {
        bodyBBs.push_back(llvm::BasicBlock::Create(context, "switch.case", fn));
    }
    llvm::BasicBlock* defaultBB =
        s.defaultBody ? llvm::BasicBlock::Create(context, "switch.default", fn) : endBB;
    // Dispatch chain: compare the subject against each case value.
    for (std::size_t i = 0; i < n; ++i) {
        llvm::Value* cv = emitExpr(*s.cases[i].value);
        llvm::Value* eq;
        if (isStr) {
            llvm::Value* cmp = builder.CreateCall(strcmpFn(), {stringData(subj), stringData(cv)});
            eq = builder.CreateICmpEQ(cmp, builder.getInt32(0), "switch.streq");
        } else {
            eq = builder.CreateICmpEQ(subj, cv, "switch.is");
        }
        llvm::BasicBlock* nextTest = llvm::BasicBlock::Create(context, "switch.test", fn);
        builder.CreateCondBr(eq, bodyBBs[i], nextTest);
        builder.SetInsertPoint(nextTest);
    }
    builder.CreateBr(defaultBB);  // nothing matched
    // break exits the switch; continue (if any) targets the enclosing loop.
    const LoopTargets brk = {endBB,
                             loopStack.empty() ? endBB : loopStack.back().cont,
                             pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()};
    pendingLoopLabel.clear();
    for (std::size_t i = 0; i < n; ++i) {
        builder.SetInsertPoint(bodyBBs[i]);
        loopStack.push_back(brk);
        emitBlock(s.cases[i].body);
        loopStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr((i + 1 < n) ? bodyBBs[i + 1] : defaultBB);  // fall-through
        }
    }
    if (s.defaultBody) {
        builder.SetInsertPoint(defaultBB);
        loopStack.push_back(brk);
        emitBlock(*s.defaultBody);
        loopStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateBr(endBB);
        }
    }
    builder.SetInsertPoint(endBB);
}

void CodeGenerator::Impl::declareClasses() {
    // Pass 0: register enums (int-style lowers to i32 ordinals; java-style
    // constants are singletons materialized as instances of a desugared class).
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::EnumDecl& en : ns.enums) {
                enums[en.name] = en.constants;
                // An enum's path, for the same reason a class's is recorded: a user enum and a stdlib
                // class of one name is the collision that started this, and codegen picked the wrong
                // one because it had nothing to pick by.
                classNamespace[en.name] = ns.name;
                classBundle[en.name] = bundle.name;
                enumTypeId[en.name] = static_cast<int>(enumTypeId.size());  // stable per-enum tag id
                if (en.isJavaStyle) {
                    javaEnums[en.name] = &en;
                } else if (!en.members.empty()) {
                    enumMethodDecls[en.name] = &en;  // catalog enum
                }
            }
            for (const ast::CatalogDecl& cat : ns.catalogs) {
                catalogNames.insert(cat.name);
            }
        }
    }
    // Pass 1: create struct types and record declaration, superclass,
    // WHICH NAMES ARE SHARED, BEFORE ANY OF THEM IS STORED.
    //
    // The first attempt let the first declaration keep the bare name and sent the rest to their path.
    // That is one rule with two cases, and every later pass had to know which case it was in -- the
    // layout walk, the field fill, the body emitter -- so they disagreed, and the standard library's
    // own `Scanner` ended up with the user's fields.
    //
    // One rule instead: a name that TWO types answer to is stored by path for BOTH of them, and a
    // unique name is stored bare exactly as before. Deciding it needs a look ahead, which is this
    // scan; it costs one walk over the declarations and removes the asymmetry entirely.
    //
    // Counted by NAMESPACE, not by occurrence. A java-style enum desugars into a class AND a light
    // enum of the same name in the same namespace -- so counting declarations marked every one of
    // them as colliding with itself, and every java enum in the program went down a path meant for
    // two different types.
    {
        std::unordered_map<std::string, std::string> firstNs;
        auto note = [&](const std::string& name, const std::string& where) {
            auto it = firstNs.find(name);
            if (it == firstNs.end()) {
                firstNs[name] = where;
                firstOwnerKey[name] = where + "." + name;   // the deterministic fallback
            } else if (it->second != where) {
                sharedClassNames.insert(name);   // two namespaces, two types, one name
            }
        };
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                const std::string where = bundle.name + "." + ns.name;
                for (const ast::ClassDecl& cls : ns.classes) {
                    note(cls.name, where);
                }
                for (const ast::EnumDecl& en : ns.enums) {
                    note(en.name, where);
                }
            }
            // AND WHAT EACH BUNDLE IMPORTED, because an import is the author saying which of two
            // same-named types they mean, and codegen has to reach the same conclusion the analyzer
            // did. Without it, code that passed type checking -- the analyzer honours the import --
            // resolved here by "first declared" instead, and a program that imports its own
            // `World.Paths` called the standard library's, reported as `unknown method 'one'`
            // against a method the author had just written.
            //
            // The import path IS the key: `import Own.World.Paths;` is `Own.World.Paths`, which is
            // exactly how a shared name is stored.
            // BOTH LISTS. An import is written before `program` (spec 2.7, file level) and lands in
            // `program.imports`; `bundle.imports` is the in-bundle form the standard library uses for
            // itself. Reading only the second saw every library import and none of the author's,
            // which is the half that matters here.
            auto take = [&](const ast::ImportDecl& imp) {
                if (imp.path.size() < 2) {
                    return;   // `import reflect;` and other bare, pathless imports
                }
                std::string key;
                for (const std::string& seg : imp.path) {
                    key += key.empty() ? seg : "." + seg;
                }
                bundleImportKey[bundle.name][imp.path.back()] = key;
            };
            for (const ast::ImportDecl& imp : program.imports) {
                take(imp);
            }
            for (const ast::ImportDecl& imp : bundle.imports) {
                take(imp);
            }
        }
    }
    // POLARON_SHOW_SHARED=1: which names two types answer to, and where each one lives. A collision
    // is resolved in four passes that must agree, so the first question when they do not is whether
    // this scan saw the collision at all.
    if (std::getenv("POLARON_SHOW_SHARED") != nullptr) {
        for (const std::string& n : sharedClassNames) {
            std::fprintf(stderr, "[shared] %s\n", n.c_str());
        }
    }
    // interfaces, flags and own members. All names registered first.
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                ClassLayout layout;
                layout.decl = &cls;
                layout.imported = bundle.isImported;  // bodies + full layout live in the .polb
                layout.dynamic = bundle.isDynamic;    // functions resolved at runtime via thunks
                layout.bundleName = bundle.name;
                if (bundle.isPrelude) {
                    preludeClasses.insert(cls.name);
                }
                layout.type = llvm::StructType::create(context, "class." + cls.name);
                layout.superclass = cls.superclass;
                layout.interfaces = cls.interfaces;
                layout.isAbstract = cls.isAbstract;
                layout.isInterface = cls.isInterface;
                layout.isUnion = cls.isUnion;
                layout.isStruct = cls.isStruct;
                layout.isMovable = cls.isMovable;
                layout.isUnique = cls.isUnique;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        // Mangle generic args (Node<int>* -> Node$int*) and keep the pointer/ref and
                        // nullable markers, so a `nullable int` field is boxed as a pointer.
                        const std::string ftype = typeRefName(f->type);
                        // Static fields live in a single LLVM global, not in each
                        // instance, so they are excluded from the struct layout.
                        if (f->isStatic) {
                            staticFieldType[cls.name + "." + f->name] = ftype;
                        } else {
                            layout.ownFields.emplace_back(f->name, ftype);
                            if (!f->affinity.empty()) {
                                layout.fieldAffinity[f->name] = f->affinity;
                            }
                            if (f->isPersistent) {
                                layout.persistOrder.push_back(f->name);
                            }
                            if (f->bitWidth > 0) {
                                layout.bitFieldWidth[f->name] = f->bitWidth;
                            }
                            if (!f->propertySetter.empty()) {
                                layout.propertySetters[f->name] = f->propertySetter;
                            }
                            if (f->isVolatile) {
                                layout.volatileFields.insert(f->name);
                            }
                            if (f->isExternal) {
                                layout.externalFields.insert(f->name);
                            }
                            if (f->isUnique) {
                                layout.uniqueFields.insert(f->name);
                            }
                            if (f->isWeak) {
                                layout.weakFields.insert(f->name);
                                weaklyReferenced_.insert(baseType(ftype));  // T is a weak target
                            }
                            if (f->isTransient) {
                                layout.transientFields.insert(f->name);
                            }
                            if (f->isLazy && f->init) {
                                layout.lazyFieldInit[f->name] = f->init.get();
                            }
                        }
                    } else if (const auto* m =
                                   dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        layout.methodReturnType[m->name] = ast::canonicalType(m->returnType);
                        layout.ownMethods[m->name] = m;
                        // A computed property with a custom setter routes `obj.name = v` here.
                        if (!m->propertySetter.empty()) {
                            layout.propertySetters[m->name] = m->propertySetter;
                        }
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) !=
                               nullptr) {
                        layout.hasDestructor = true;
                    }
                }
                // WHERE THIS CLASS LIVES, recorded as it is registered.
                //
                // Codegen walks bundles and namespaces already and kept neither, so it could not tell
                // two same-named types apart -- which is why the renaming pass had to make them
                // different before codegen ever saw them, and why every gap in that rewrite became a
                // codegen failure about a type the author never wrote.
                //
                // Written here rather than threaded through as context because a class's namespace is
                // a fact about the class, not about where it is being emitted from.
                // A SECOND CLASS OF THE SAME NAME NO LONGER ERASES THE FIRST -- the same rule the
                // analyzer now follows. The bare name keeps the first, so every existing lookup is
                // untouched and costs what it did; the rest go under their full path, where a lookup
                // that knows which one it wants can find them.
                //
                // Today the renaming pass makes this unreachable by making the names distinct
                // upstream. It is here so that removing that pass does not silently lose a type,
                // which is precisely what `classes[cls.name] = layout` did.
                // By path when the name is shared, bare when it is not -- decided by the scan above,
                // so both halves of a collision are treated alike and no pass has to remember which
                // of the two it is holding.
                const std::string key = sharedClassNames.count(cls.name) > 0
                                            ? bundle.name + "." + ns.name + "." + cls.name
                                            : cls.name;
                classNamespace[key] = ns.name;
                classBundle[key] = bundle.name;
                classes[key] = std::move(layout);
                if (sharedClassNames.count(cls.name) > 0 && classNamespace.count(cls.name) == 0) {
                    // Remember where the bare name will point; the copy itself waits until the fields
                    // exist (see the aliasing step after the layout passes).
                    classNamespace[cls.name] = ns.name;
                    classBundle[cls.name] = bundle.name;
                }
            }
        }
    }
    // Pass 1.5: vtable metadata. A class is polymorphic (carries a vtable
    // pointer) if it is in any inheritance/interface relationship.
    std::unordered_set<std::string> bases;
    for (const auto& [name, l] : classes) {
        if (!l.superclass.empty()) {
            bases.insert(l.superclass);
        }
        for (const std::string& i : l.interfaces) {
            bases.insert(i);
        }
    }
    // A BUNDLE IS COMPILED INTO AN OPEN WORLD, and "nothing extends this" is a whole-program answer.
    //
    // Devirtualization asks whether any type extends the receiver. Inside a program that question is
    // decidable; inside `polc --lib` it is not, because the classes that will extend a public class do
    // not exist yet. A library whose `Widget` nothing derives from LOCALLY had its own
    // `this.weight()` compiled to a direct call, so a consumer's override was walked straight past --
    // `total` returned 17 instead of 57 while the consumer's own `w.weight()` gave the right 5. Two
    // dispatches on one object disagreeing is the shape this bug takes, and it links silently.
    //
    // Visibility is the whole test. A class not published in the .polh cannot be named from outside,
    // so nothing outside can extend it; `final` says it directly; `sealed` closes the set to `permits`
    // types, which are in this bundle and so already reach `bases` above. Everything else public stays
    // virtual. This runs BEFORE hasVtable below, because such a class also needs the table -- a
    // consumer deriving from it lays its object out with a vtable pointer either way.
    if (libraryMode) {
        for (const auto& [name, l] : classes) {
            if (l.decl != nullptr && l.decl->visibility == "public" && !l.decl->isFinal &&
                !l.decl->isSealed && !l.isStruct && !l.isUnion) {
                bases.insert(name);
            }
        }
    }
    for (auto& [name, l] : classes) {
        l.hasVtable = !l.superclass.empty() || !l.interfaces.empty() || l.isAbstract ||
                      l.isInterface || bases.count(name) > 0 || patchedClasses_.count(name) > 0;
    }
    // A patched class (spec 32.8) must dispatch through its vtable even with no subtype: that slot is
    // exactly where the replacement lands, so a direct call would keep running the original. Its
    // subclasses too -- they inherit the patched method, and a devirtualized `poodle.bark()` would
    // walk straight past the replacement installed in Poodle's table.
    for (const std::string& p : patchedClasses_) {
        bases.insert(p);
        for (const auto& [cname, cl] : classes) {
            if (derivesFrom(cname, p)) {
                bases.insert(cname);
            }
        }
    }
    subclassed_ = bases;  // remember which types have a subtype, for devirtualization at call sites
    // Adopt the slot layout of imported bundles first, so a virtual call on an imported object
    // hits the slot its baked-in vtable (in the .polb) uses (spec 2.5 ABI). Fresh local methods
    // then take the slots after these.
    for (const std::string& name : seededSlots) {
        if (methodSlots.count(name) == 0) {
            methodSlots[name] = static_cast<int>(methodSlotNames.size());
            methodSlotNames.push_back(name);
        }
    }
    // Assign a stable global slot to every distinct virtual method name, walking
    // the AST in declaration order (deterministic, unlike the classes map). A
    // single global numbering shared by all classes/interfaces is what makes a
    // class with multiple interfaces dispatch each one to the correct slot.
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                auto cit = classes.find(cls.name);
                if (cit == classes.end() || !cit->second.hasVtable) {
                    continue;
                }
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* md = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (md == nullptr || md->isStatic) {
                        continue;
                    }
                    if (methodSlots.count(md->name) == 0) {
                        methodSlots[md->name] = static_cast<int>(methodSlotNames.size());
                        methodSlotNames.push_back(md->name);
                    }
                }
            }
        }
    }
    for (auto& [name, l] : classes) {
        if (l.hasVtable) {
            l.vtslots = computeSlots(name);
        }
    }
    // Pass 2: lay out fields (vtable pointer at slot 0 when polymorphic),
    // inherited fields first, then own.
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                // THE SAME CLASS THIS PASS IS LOOKING AT, not whoever holds the bare name. Fields are
                // filled in a second walk, and with two `Scanner`s in the program this wrote the
                // standard library's fields into the USER's layout -- so the library's own
                // constructor then failed with `no such field 'src'`.
                ClassLayout& layout = classes[resolveClassKey(cls.name)];
                if (layout.isUnion) {
                    // All fields overlap at offset 0; storage is the largest field.
                    std::string biggest;
                    unsigned maxBytes = 0;
                    for (const auto& [fname, ftype] : collectFields(resolveClassKey(cls.name))) {
                        layout.fieldIndex[fname] = 0;
                        layout.fieldType[fname] = ftype;
                        if (byteSizeOf(ftype) > maxBytes) {
                            maxBytes = byteSizeOf(ftype);
                            biggest = ftype;
                        }
                    }
                    std::vector<llvm::Type*> body;
                    if (!biggest.empty()) {
                        body.push_back(llvmType(biggest));
                    }
                    layout.type->setBody(body);
                    continue;
                }
                std::vector<llvm::Type*> fieldTypes;
                if (layout.hasVtable) {
                    fieldTypes.push_back(builder.getPtrTy());  // vtable ptr
                }
                unsigned idx = layout.hasVtable ? 1u : 0u;
                // BIT-FIELD PACKING (spec 11.1). The spec gives a `PacketHeader` and no semantics,
                // and for a language that points at hardware registers and wire formats there is only
                // one defensible reading: the bits are laid out PHYSICALLY, predictably, and it is
                // written down. Value masking alone -- what this used to do -- makes the example in
                // the spec a lie, because `uint8 version:4; uint8 type:4;` would occupy two bytes.
                //
                // The rule, in full:
                //   * consecutive bit-fields accumulate into one RUN, in declaration order;
                //   * within the run each field takes the next bits from the LEAST significant end
                //     (this is a little-endian target, so LSB-first is what makes bit 0 of the first
                //     field also bit 0 of the first byte -- the thing a register datasheet means);
                //   * a run ends at the first non-bit-field member, or when the next field would take
                //     it past 64 bits;
                //   * the run's storage unit is the next power-of-two byte size that holds it (1, 2,
                //     4 or 8 bytes), so a packed group is always readable and writable with ONE
                //     naturally sized access. That matters for MMIO, where a 32-bit register must be
                //     touched as a 32-bit access and not as four byte pokes.
                // A run wider than 64 bits is an ERROR, not a silent second unit: a header that does
                // not fit an integer needs the author to say where it splits.
                std::vector<std::pair<std::string, std::string>> ordered = collectFields(resolveClassKey(cls.name));
                std::size_t fi = 0;
                while (fi < ordered.size()) {
                    if (layout.bitFieldWidth.count(ordered[fi].first) == 0) { ++fi; continue; }
                    // Gather the run and total its bits.
                    std::size_t runEnd = fi;
                    unsigned bitsUsed = 0;
                    while (runEnd < ordered.size()) {
                        auto bw = layout.bitFieldWidth.find(ordered[runEnd].first);
                        if (bw == layout.bitFieldWidth.end()) {
                            break;
                        }
                        const unsigned w = static_cast<unsigned>(bw->second);
                        if (bitsUsed + w > 64u) {
                            break;
                        }
                        bitsUsed += w;
                        ++runEnd;
                    }
                    if (runEnd == fi) {
                        error("bit field '" + ordered[fi].first + "' of " + cls.name + " is wider "
                              "than 64 bits; a packed group must fit one storage unit -- split it "
                              "into named fields that each fit", cls.loc);
                        ++fi;
                        continue;
                    }
                    unsigned unitBits = 8;
                    while (unitBits < bitsUsed) {
                        unitBits *= 2;
                    }
                    unsigned off = 0;
                    for (std::size_t k = fi; k < runEnd; ++k) {
                        layout.bitFieldOffset[ordered[k].first] = off;
                        layout.bitFieldUnitBits[ordered[k].first] = unitBits;
                        off += static_cast<unsigned>(layout.bitFieldWidth[ordered[k].first]);
                    }
                    fi = runEnd;
                }
                // One element per field, EXCEPT that every field of a run shares the run's element.
                std::string runOwner;   // the field whose element the current run occupies
                for (const auto& [fname, ftype] : collectFields(resolveClassKey(cls.name))) {
                    if (auto ub = layout.bitFieldUnitBits.find(fname);
                        ub != layout.bitFieldUnitBits.end()) {
                        const bool startsRun =
                            runOwner.empty() || layout.bitFieldOffset[fname] == 0;
                        if (startsRun) {
                            runOwner = fname;
                            layout.fieldIndex[fname] = idx++;
                            fieldTypes.push_back(builder.getIntNTy(ub->second));
                        } else {
                            layout.fieldIndex[fname] = layout.fieldIndex[runOwner];
                        }
                        layout.fieldType[fname] = ftype;
                        continue;
                    }
                    runOwner.clear();
                    layout.fieldIndex[fname] = idx++;
                    layout.fieldType[fname] = ftype;
                    // a `weak T*` field is a 2-ptr WeakSlot {ptr, next}; an `A*` whose A is a region
                    // class is a 32-bit offset into that family's arena (see isNarrowField -- this is
                    // where the halved node comes from); every other field is its own type. (v1
                    // constraint: a weak TARGET should be a concrete/leaf class -- the weak-list head
                    // is appended per class, so a polymorphic base with a differently-laid subclass
                    // would place the head at a different offset.)
                    if (fieldIsWeak(cls.name, fname)) {
                        fieldTypes.push_back(weakSlotType());
                    } else if (!narrowTargetClass(ftype).empty()) {
                        fieldTypes.push_back(builder.getInt32Ty());
                    } else {
                        fieldTypes.push_back(llvmType(ftype));
                    }
                }
                // a class that is the target of some `weak T*` carries a weak-list head (one ptr).
                if (weaklyReferenced_.count(cls.name) > 0) {
                    layout.needsWeakHead = true;
                    layout.weakHeadIdx = idx++;
                    fieldTypes.push_back(builder.getPtrTy());
                }
                // Persistent instance fields also get an out-of-object block; the object
                // holds a pointer to it (set at construction) so this.f and var.f both work
                // and the field survives `delete` (it lives in the block, not the object).
                if (!layout.persistOrder.empty()) {
                    std::vector<llvm::Type*> blockTypes;
                    for (const auto& pf : layout.persistOrder) {
                        blockTypes.push_back(llvmType(layout.fieldType[pf]));
                    }
                    layout.persistBlock =
                        llvm::StructType::create(context, "persistblock." + cls.name);
                    layout.persistBlock->setBody(blockTypes);
                    layout.persistPtrIdx = idx;
                    fieldTypes.push_back(builder.getPtrTy());
                }
                layout.type->setBody(fieldTypes);
            }
        }
    }
    // THE BARE NAME GETS AN ALIAS, now that the layouts are complete.
    //
    // Every shared type is stored by its path, so a site that RESOLVES gets the right one. This is
    // for the sites that do not -- `classes[name]` with operator[], of which there are several --
    // because with the bare key absent those create an EMPTY layout with a null type and the compiler
    // segfaults on it. An alias makes an unresolved answer wrong-but-valid rather than fatal, which is
    // the difference between a diagnosable bug and a crash.
    //
    // AFTER the fills, and that ordering is the whole of it: the first attempt copied at registration,
    // when the layout had no fields yet, so the alias was permanently empty and every unresolved
    // lookup reported `no such field` on a class that plainly had one.
    for (const auto& [bare, key] : firstOwnerKey) {
        if (sharedClassNames.count(bare) > 0 && classes.count(bare) == 0 &&
            classes.count(key) > 0) {
            classes[bare] = classes[key];
        }
    }
    checkLayoutBudgets(program);
}

void CodeGenerator::Impl::checkLayoutBudgets(const ast::Program& program) {
    std::map<std::string, const ast::ClassDecl*> layoutDecls;
    for (const auto& b : program.bundles) {
        for (const auto& ns : b.namespaces) {
            for (const auto& c : ns.classes) {
                if (c.isLayout) {
                    layoutDecls[c.name] = &c;
                }
            }
        }
    }
    if (layoutDecls.empty()) {
        return;
    }
    for (const auto& b : program.bundles) {
        for (const auto& ns : b.namespaces) {
            for (const auto& c : ns.classes) {
                long long measured = 0;
                if (c.layouts.empty() || !sizeOfTypeName(c.name, measured)) {
                    continue;
                }
                for (const std::string& ln : c.layouts) {
                    auto lit = layoutDecls.find(ln);
                    if (lit == layoutDecls.end()) {
                        continue;
                    }
                    Arrangement want;
                    (void)readArrangement(*lit->second, want);  // already reported if malformed
                    if (want.maxBytes < 0 || measured <= want.maxBytes) {
                        continue;
                    }
                    std::string msg = "`" + c.name + "` is arranged by `" + ln + "`, which fits it within " +
                                      std::to_string(want.maxBytes) + " bytes -- it measures " +
                                      std::to_string(measured) +
                                      ". The fields were already ordered widest-first to make it "
                                      "fit, so reordering them by hand will not help: something "
                                      "has to be narrower, or leave";
                    if (!want.refuseMessage.empty()) {
                        msg += " (" + want.refuseMessage + ")";
                    }
                    error(msg, c.loc);
                }
            }
        }
    }
}

comptime::Context CodeGenerator::Impl::comptimeCtx() {
    comptime::Context ctx;
    ctx.consts = &constIntVals;
    ctx.dconsts = &constDblVals;
    ctx.methods = &comptimeMethods;
    // Only this stage may answer for layout, so this is where sizeof becomes a constant.
    ctx.sizeOfType = [this](const std::string& t, long long& out) { return sizeOfTypeName(t, out); };
    // An enum's size is known from its declaration alone, so this stage can answer for it too --
    // and must, so a `fixed` global folded here agrees with the demand the analyzer settled.
    ctx.enumCount = [this](const std::string& e, long long& out) {
        auto it = enums.find(e);
        if (it == enums.end()) {
            return false;
        }
        out = static_cast<long long>(it->second.size());
        return true;
    };
    return ctx;
}

bool CodeGenerator::Impl::foldConstInt(const ast::Expr& e, long long& out) {
    comptime::Context ctx = comptimeCtx();
    return comptime::evalInt(e, out, ctx);
}

bool CodeGenerator::Impl::foldConstDouble(const ast::Expr& e, double& out) {
    comptime::Context ctx = comptimeCtx();
    return comptime::evalDouble(e, out, ctx);
}

llvm::Constant* CodeGenerator::Impl::constLiteral(const std::string& name) {
    auto tit = namespaceConstTypes.find(name);
    if (tit == namespaceConstTypes.end()) {
        return nullptr;
    }
    llvm::Type* lty = llvmType(tit->second);
    if (isFloatType(tit->second)) {
        auto vit = constDblVals.find(name);
        return llvm::ConstantFP::get(lty, vit == constDblVals.end() ? 0.0 : vit->second);
    }
    auto vit = constIntVals.find(name);
    return llvm::ConstantInt::get(
        lty, static_cast<std::uint64_t>(vit == constIntVals.end() ? 0 : vit->second),
        /*isSigned=*/true);
}

void CodeGenerator::Impl::emitNamespaceConsts() {
    // Index `comptime` methods first, so const initializers can call them (spec 28.3).
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        m != nullptr && m->isComptime && !m->isAbstract) {
                        comptimeMethods.emplace(m->name, m);
                    }
                }
            }
        }
    }
    // TO A FIXED POINT, THE SAME WAY THE ANALYZER DOES IT, and it has to be both or neither.
    //
    // A constant defined in terms of one declared LATER folded fine in sema and reached here
    // unresolved -- so the program compiled clean and read back ZERO. Silent, and worse than the
    // error it replaced. Anything still unfolded once nothing moves has already been reported by
    // the analyzer, so this pass stays quiet and simply leaves it out.
    auto fold = [&](const ast::ConstDecl& c, const std::string& owner) -> bool {
        const std::string key = owner.empty() ? c.name : owner + "." + c.name;
        const std::string type = typeRefName(c.type);
        namespaceConstTypes[key] = type;
        if (c.init == nullptr) {
            return true;   // never going to resolve, and the reason is not order
        }
        if (isFloatType(type)) {
            double d;
            if (!foldConstDouble(*c.init, d)) {
                return false;
            }
            constDblVals[key] = d;
            return true;
        }
        long long v;
        if (!foldConstInt(*c.init, v)) {
            return false;
        }
        constIntVals[key] = v;
        return true;
    };
    std::vector<std::pair<const ast::ConstDecl*, std::string>> waiting;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ConstDecl& c : ns.consts) {
                waiting.push_back({&c, ""});
            }
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* c = dynamic_cast<const ast::ConstDecl*>(m.get())) {
                        waiting.push_back({c, cls.name});
                    }
                }
            }
        }
    }
    bool moved = true;
    while (moved) {
        moved = false;
        for (auto it = waiting.begin(); it != waiting.end();) {
            if (fold(*it->first, it->second)) {
                it = waiting.erase(it);
                moved = true;
            } else {
                ++it;
            }
        }
    }
}

llvm::Constant* CodeGenerator::Impl::constFold(const ast::Expr& expr, const std::string& type) {
    llvm::Type* lty = llvmType(type);
    if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
        if (isFloatType(type)) {
            return llvm::ConstantFP::get(lty, static_cast<double>(parseIntLiteral(n->text)));
        }
        return llvm::ConstantInt::get(lty, static_cast<std::uint64_t>(parseIntLiteral(n->text)),
                                      /*isSigned=*/true);
    }
    if (const auto* c = dynamic_cast<const ast::CharLiteralExpr*>(&expr)) {
        const std::string bytes = resolveEscapes(c->value);
        const unsigned char v = bytes.empty() ? 0 : static_cast<unsigned char>(bytes[0]);
        return llvm::ConstantInt::get(lty, v);
    }
    if (const auto* b = dynamic_cast<const ast::BoolLiteralExpr*>(&expr)) {
        return llvm::ConstantInt::get(lty, b->value ? 1 : 0);
    }
    if (const auto* f = dynamic_cast<const ast::FloatLiteralExpr*>(&expr)) {
        std::string s;
        for (char ch : f->text) {
            if (ch != '_' && ch != 'f' && ch != 'F') {
                s += ch;
            }
        }
        double val = 0.0;
        try {
            val = std::stod(s);
        } catch (...) {
        }
        return isFloatType(type) ? llvm::ConstantFP::get(lty, val) : nullptr;
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&expr); u != nullptr && u->op == "-") {
        if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(u->operand.get())) {
            const std::int64_t v = -parseIntLiteral(n->text);
            if (isFloatType(type)) {
                return llvm::ConstantFP::get(lty, static_cast<double>(v));
            }
            return llvm::ConstantInt::get(lty, static_cast<std::uint64_t>(v), /*isSigned=*/true);
        }
        if (const auto* fnode = dynamic_cast<const ast::FloatLiteralExpr*>(u->operand.get());
            fnode != nullptr && isFloatType(type)) {
            std::string s;
            for (char ch : fnode->text) {
                if (ch != '_' && ch != 'f' && ch != 'F') {
                    s += ch;
                }
            }
            double val = 0.0;
            try {
                val = std::stod(s);
            } catch (...) {
            }
            return llvm::ConstantFP::get(lty, -val);
        }
    }
    // A reference to a namespace-level const, or an expression folded from
    // consts/literals (spec 28.1) -- e.g. a static field initialized from a const.
    if (dynamic_cast<const ast::IdentifierExpr*>(&expr) != nullptr ||
        dynamic_cast<const ast::BinaryExpr*>(&expr) != nullptr) {
        if (isFloatType(type)) {
            double d;
            if (foldConstDouble(expr, d)) {
                return llvm::ConstantFP::get(lty, d);
            }
        } else {
            long long v;
            if (foldConstInt(expr, v)) {
                return llvm::ConstantInt::get(lty, static_cast<std::uint64_t>(v),
                                              /*isSigned=*/true);
            }
        }
    }
    return nullptr;
}

void CodeGenerator::Impl::emitStaticFields() {
    // Pass one: fold every static field whose initializer IS a compile-time constant into the
    // same maps the comptime evaluator reads, keyed "Class.field" -- the key it already uses for
    // a class-level const.
    //
    // Without this pass, `public static int HAMLET = Simulation.VILLAGE / 4;` -- with VILLAGE a
    // static int in the same class -- folded to nothing, and the global below was emitted as
    // `i32 0` with no diagnostic at all. In agents-exe that number was the minimum size of a
    // village founding party, so it was zero, so every lone wanderer founded a village and the
    // world produced thirteen thousand of them in one run. Four separate simulation rules were
    // rewritten chasing the symptom before anybody read the .ll.
    //
    // Iterated to a fixpoint rather than done in declaration order, so the rule is one sentence
    // and has no exceptions: a static may be written in terms of any other static, and the only
    // thing rejected is a CYCLE. Order-dependence would be a second rule to learn and a second
    // way to get a zero -- `A = B / 4;` above `B = 120;` would silently be `A = 0` again, which
    // is the very failure this is closing. Each round must add at least one value, so the loop
    // runs at most once per static field.
    std::vector<std::pair<std::string, const ast::FieldDecl*>> statics;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
                        f != nullptr && f->isStatic && f->init != nullptr) {
                        statics.emplace_back(cls.name + "." + f->name, f);
                    }
                }
            }
        }
    }
    for (std::size_t round = 0; round < statics.size(); ++round) {
        bool progressed = false;
        for (const auto& [key, f] : statics) {
            if (constIntVals.count(key) > 0 || constDblVals.count(key) > 0) {
                continue;
            }
            if (isFloatType(staticFieldType[key])) {
                double d;
                if (foldConstDouble(*f->init, d)) {
                    constDblVals[key] = d;
                    progressed = true;
                }
            } else {
                long long v;
                if (foldConstInt(*f->init, v)) {
                    constIntVals[key] = v;
                    progressed = true;
                }
            }
        }
        if (!progressed) {
            break;
        }
    }
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
                    if (f == nullptr) {
                        continue;
                    }
                    if (f->isPersistent && !f->isStatic) {
                        persistentInstanceFields[cls.name].insert(f->name);
                    }
                    if (!f->isStatic) {
                        continue;
                    }
                    const std::string key = cls.name + "." + f->name;
                    const std::string ftype = staticFieldType[key];
                    llvm::Type* lty = llvmType(ftype);
                    llvm::Constant* init =
                        f->init ? constFold(*f->init, ftype) : nullptr;
                    // `comptime` (spec 37.4) promises the initializer is evaluated during
                    // compilation -- but `constFold` does not know how to CALL a `comptime`
                    // method, and foldConstInt/foldConstDouble do. Two folders answering the same
                    // question differently is how `static mutable comptime int t = fib(10)` came
                    // to be refused by Polaron-0608 as unevaluable, one pass after the analyzer had
                    // evaluated it and got 55.
                    if (init == nullptr && f->init != nullptr && f->isComptime) {
                        if (isFloatType(ftype)) {
                            double d = 0;
                            if (foldConstDouble(*f->init, d)) {
                                init = llvm::ConstantFP::get(lty, d);
                            }
                        } else {
                            long long v = 0;
                            if (foldConstInt(*f->init, v)) {
                                init = llvm::ConstantInt::get(lty, static_cast<std::uint64_t>(v),
                                                              /*isSigned=*/true);
                            }
                        }
                    }
                    if (f->init != nullptr && init == nullptr) {
                        // An initializer that was written and cannot be evaluated is the failure
                        // this whole pass exists to stop being silent. Zeroing it is never what
                        // was meant, and the resulting program is wrong in a way no test of the
                        // program's OUTPUT can localise back to this line.
                        //
                        // THIS USED TO ASK `isNumericStaticType` FIRST, and so it covered half
                        // the types. The other half is the half that ALLOCATES: a `String` or a
                        // `new T[n]()` cannot be folded into a global, no error was raised, and
                        // the field was quietly zeroed -- a null pointer that reads as an empty
                        // array or crashes on first use, far from the line that caused it.
                        // `public static mutable String tag = "hello";` compiled clean and took
                        // the process down with an access violation.
                        const bool allocates = !isNumericStaticType(ftype);
                        error("the initializer for static field '" + key +
                                  "' cannot be evaluated before the program starts: it is "
                                  "neither a constant nor built from other static fields "
                                  "without a cycle" +
                                  (allocates ? ". A value that must be ALLOCATED cannot exist "
                                               "before the program runs -- give it a value in "
                                               "`onClassLoad`, which is where the standard "
                                               "library builds its own tables"
                                             : ""),
                              f->init->loc);
                    }
                    if (init == nullptr) {
                        init = llvm::Constant::getNullValue(lty);
                    }
                    staticGlobals[key] =
                        new llvm::GlobalVariable(module, lty, /*isConstant=*/false,
                                                 llvm::GlobalValue::PrivateLinkage, init, key);
                }
            }
        }
    }
}

bool CodeGenerator::Impl::isNumericStaticType(const std::string& t) const {
    return isIntName(t) || isFloatType(t) || t == "boolean" || t == "char";
}

void CodeGenerator::Impl::exportBundleSymbols() {
    for (llvm::Function& f : module.functions()) {
        if (f.isDeclaration()) {
            continue;
        }
        // Internal helpers such as __polaron_lambda_N (closure code) are private to the module: they never
        // collide across objects and must keep default storage class (LLVM forbids dllexport on local
        // linkage). Leave them untouched -- do not export or weaken them.
        if (f.hasLocalLinkage()) {
            continue;
        }
        const llvm::StringRef name = f.getName();
        const std::size_t dot = name.find('.');
        const std::string owner =
            dot != llvm::StringRef::npos ? name.substr(0, dot).str() : std::string();
        // Prelude functions and monomorphized generic instances (Box$int) are made weak. The latter
        // are ODR -- a library and its consumer both instantiate ArrayList<String> from the same
        // template, so identical definitions must dedupe at link time instead of colliding (LNK2005).
        const bool weak =
            name.starts_with("literal.") || preludeClasses.count(owner) > 0 ||
            owner.find('$') != std::string::npos;
        if (weak) {
            f.setLinkage(llvm::GlobalValue::LinkOnceODRLinkage);
            // A COMDAT keyed on the symbol makes clang emit a real COFF COMDAT (SELECT_ANY) that the
            // linker deduplicates across objects. Without it, linkonce_odr lowers to a per-object
            // ".weak.<name>.default.<tu>" symbol that collides when two dependency objects are linked.
            f.setComdat(module.getOrInsertComdat(f.getName()));
        } else {
            f.setDLLStorageClass(llvm::GlobalValue::DLLExportStorageClass);
        }
    }
}

void CodeGenerator::Impl::emitDynamicThunks() {
    if (dynamicBundles.empty()) {
        return;
    }
    ehPadStack.clear();    // thunks are standalone: no enclosing try / RAII scope
    ehBaseStack.clear();
    scopeObjects.clear();
    stackObjectSlots_.clear();
    llvm::PointerType* ptrTy = builder.getPtrTy();
    llvm::FunctionCallee loadFn = module.getOrInsertFunction(
        "polaron_bundle_load", llvm::FunctionType::get(ptrTy, {ptrTy, ptrTy, ptrTy}, false));
    llvm::FunctionCallee symFn = module.getOrInsertFunction(
        "polaron_bundle_sym", llvm::FunctionType::get(ptrTy, {ptrTy, ptrTy}, false));
    llvm::Constant* nullp = llvm::ConstantPointerNull::get(ptrTy);

    for (auto& [cn, cl] : classes) {
        if (!cl.dynamic) {
            continue;
        }
        auto dbit = dynamicBundles.find(cl.bundleName);
        if (dbit == dynamicBundles.end()) {
            continue;
        }
        const std::string& polbPath = dbit->second.first;
        const auto& fp = dbit->second.second;

        std::vector<std::string> names;  // symbols to thunk: methods + __new + __delete
        if (cl.decl != nullptr) {
            for (const ast::MemberPtr& m : cl.decl->members) {
                if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                    if (!md->isAbstract) {
                        names.push_back(cn + "." + md->name);
                    }
                }
            }
        }
        if (functions.count(cn + ".__new") != 0) {
            names.push_back(cn + ".__new");
        }
        if (functions.count(cn + ".__delete") != 0) {
            names.push_back(cn + ".__delete");
        }

        for (const std::string& name : names) {
            auto fit = functions.find(name);
            if (fit == functions.end() || !fit->second->isDeclaration()) {
                continue;
            }
            llvm::Function* f = fit->second;
            currentFn = f;
            builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
            llvm::Value* statusSlot = createEntryAlloca("status", builder.getInt32Ty());
            builder.CreateStore(builder.getInt32(0), statusSlot);  // 0 = ok (overwritten on load)

            llvm::GlobalVariable*& hg = dynBundleHandle[cl.bundleName];
            if (hg == nullptr) {
                hg = new llvm::GlobalVariable(module, ptrTy, false,
                                              llvm::GlobalValue::InternalLinkage, nullp,
                                              "__dynh_" + cl.bundleName);
            }
            llvm::Value* cur = builder.CreateLoad(ptrTy, hg, "h");
            llvm::BasicBlock* loadBB = llvm::BasicBlock::Create(context, "dyn.load", f);
            llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "dyn.cont", f);
            builder.CreateCondBr(builder.CreateICmpEQ(cur, nullp), loadBB, contBB);

            builder.SetInsertPoint(loadBB);
            llvm::Value* pathS = createGlobalStringPtr(builder,polbPath, ".dynpath");
            llvm::Constant* fpArr =
                llvm::ConstantDataArray::get(context, llvm::ArrayRef<std::uint8_t>(fp.data(), 32));
            auto* fpG = new llvm::GlobalVariable(module, fpArr->getType(), true,
                                                 llvm::GlobalValue::PrivateLinkage, fpArr, ".dynfp");
            llvm::Value* nh = builder.CreateCall(loadFn, {pathS, fpG, statusSlot}, "loaded");
            builder.CreateStore(nh, hg);
            builder.CreateBr(contBB);

            builder.SetInsertPoint(contBB);
            llvm::Value* h = builder.CreateLoad(ptrTy, hg, "bundle");
            llvm::Value* nameS = createGlobalStringPtr(builder,name, ".dynsym");
            llvm::Value* sym = builder.CreateCall(symFn, {h, nameS}, "sym");
            llvm::BasicBlock* failBB = llvm::BasicBlock::Create(context, "dyn.fail", f);
            llvm::BasicBlock* callBB = llvm::BasicBlock::Create(context, "dyn.call", f);
            builder.CreateCondBr(builder.CreateICmpEQ(sym, nullp), failBB, callBB);

            // On failure raise a catchable exception: an ABI mismatch (status 2) vs the bundle
            // being absent/unresolved. A program can wrap the use in try/catch (spec 2.4).
            builder.SetInsertPoint(failBB);
            llvm::Value* st = builder.CreateLoad(builder.getInt32Ty(), statusSlot, "status");
            llvm::BasicBlock* abiBB = llvm::BasicBlock::Create(context, "dyn.abi", f);
            llvm::BasicBlock* nlBB = llvm::BasicBlock::Create(context, "dyn.notloaded", f);
            builder.CreateCondBr(builder.CreateICmpEQ(st, builder.getInt32(2)), abiBB, nlBB);
            builder.SetInsertPoint(abiBB);
            emitThrowNamed("BundleAbiMismatchException");
            builder.SetInsertPoint(nlBB);
            emitThrowNamed("BundleNotLoadedException");

            builder.SetInsertPoint(callBB);
            std::vector<llvm::Value*> args;
            for (auto& a : f->args()) {
                args.push_back(&a);
            }
            llvm::Value* r = builder.CreateCall(f->getFunctionType(), sym, args);
            if (f->getReturnType()->isVoidTy()) {
                builder.CreateRetVoid();
            } else {
                builder.CreateRet(r);
            }
        }
    }
}

void CodeGenerator::Impl::emitVtables() {
    for (auto& [name, l] : classes) {
        if (!l.hasVtable || l.isAbstract || l.isInterface) {
            continue;  // concrete only
        }
        if (l.imported) {
            continue;  // the bundle baked its own vtable; we dispatch via the object
        }
        // A CLASS NOTHING REACHES GETS NO VTABLE EITHER, and this is not an optimisation but the
        // other half of not emitting its bodies: a vtable is a table of pointers TO those bodies, so
        // emitting one for a class whose methods were skipped asks the linker for symbols that do
        // not exist. It surfaced exactly that way -- `undefined symbol: IpcError.message,
        // referenced by .rdata`, the .rdata being the table.
        //
        // Nothing is lost: an unreached class cannot be instantiated, so no object can carry this
        // pointer, and GlobalDCE deleted the table in the old build for the same reason.
        if (reachabilityOn_ && reachableClasses_.count(name) == 0 &&
            reachableClasses_.count(simpleOf(name)) == 0) {
            continue;
        }
        std::vector<llvm::Constant*> entries;
        for (const std::string& slot : l.vtslots) {
            const std::string impl = vtableImpl(name, slot);
            llvm::Constant* slotFn = llvm::ConstantPointerNull::get(builder.getPtrTy());
            auto fit = functions.find(impl);
            if (!impl.empty() && fit != functions.end()) {
                slotFn = fit->second;  // Function*
            }
            entries.push_back(slotFn);
        }
        // Trailing slot: the most-derived destructor (for virtual `delete`), or null.
        llvm::Constant* dtorFn = llvm::ConstantPointerNull::get(builder.getPtrTy());
        if (const std::string di = dtorImpl(name); !di.empty()) {
            if (auto fit = functions.find(di); fit != functions.end()) {
                dtorFn = fit->second;
            }
        }
        entries.push_back(dtorFn);
        llvm::ArrayType* vtType = llvm::ArrayType::get(builder.getPtrTy(), entries.size());
        bool patched = patchedClasses_.count(name) > 0;  // spec 32.8: its slots are rewritten
        for (const std::string& p : patchedClasses_) {   // ...and so are its subclasses' (inherited)
            if (derivesFrom(name, p)) {
                patched = true;
            }
        }
        // ...and an UNIMPORTABLE class's table is rewritten too, by `unimport` itself, so it
        // cannot live in read-only memory either. See emitUnimportClass for why the table has to
        // go and not just the code.
        if (unimportableClasses.count(name) > 0) {
            patched = true;
        }
        l.vtable = new llvm::GlobalVariable(module, vtType, /*isConstant=*/!patched,
                                            llvm::GlobalValue::PrivateLinkage,
                                            llvm::ConstantArray::get(vtType, entries),
                                            name + ".vtable");
    }
}

llvm::CallingConv::ID CodeGenerator::Impl::worldToCallConv(const std::string& conv, SourceLocation loc) {
    if (conv.rfind("unknown:", 0) != 0) {
        return llvm::CallingConv::C;
    }
    const std::string world = conv.substr(8);
    // `c` -- THE TARGET'S OWN C ABI, and the only portable answer here.
    //
    // Every other world names a platform: `pe` is Windows, `elf` is Linux, `macho` is macOS, and the
    // raw three name a convention outright. A library that exports a C API wants none of those -- it
    // wants "whatever C means where this is being built", and there was no way to say it. The
    // consequence was not a diagnostic: `tests/samples/c_export_api.pol` said `unknown win64`, which
    // is right on Windows and, on Linux, emits functions the C++ caller invokes with the SysV
    // convention. It linked, ran, and printed `add=-1131965200`.
    if (world == "c") {
        return llvm::CallingConv::C;
    }
    // Raw-ABI escape hatches (explicit, architecture-independent):
    if (world == "win64") {
        return llvm::CallingConv::Win64;
    }
    if (world == "sysv") {
        return llvm::CallingConv::X86_64_SysV;
    }
    if (world == "aapcs") {
        return llvm::CallingConv::ARM_AAPCS;
    }
    // Binary-format worlds -> the ABI a binary of that format uses on the current target:
    if (world == "pe") {
        return llvm::CallingConv::Win64;  // Windows PE (x64; ARM64-Windows differs)
    }
    if (world == "elf" || world == "macho") {                // Linux ELF / macOS Mach-O (.dmg):
        return llvm::CallingConv::C;                         //   target-standard C ABI (SysV on x64, AAPCS64 on arm64)
    }
    error("unknown foreign world '" + world +
          "' after `unknown` (expected c for this target's own C ABI, pe/elf/macho for a platform's, "
          "or raw win64/sysv/aapcs)", loc);
    return llvm::CallingConv::C;
}

bool CodeGenerator::Impl::freestandingProgram() const {
    if (program.isFreestanding) {
        return true;
    }
    for (const ast::Bundle& b : program.bundles) {
        if (b.isFreestanding) {
            return true;
        }
    }
    return false;
}

bool CodeGenerator::Impl::declaresInterrupt(const std::string& className) const {
    auto c = classes.find(className);
    if (c == classes.end()) {
        return false;
    }
    auto m = c->second.ownMethods.find("interrupt");
    return m != c->second.ownMethods.end() && m->second != nullptr && m->second->isInterrupt;
}

void CodeGenerator::Impl::declareFunctions() {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace = ns.name;      // so resolveClassKey knows whose code this is
            currentBundleName = bundle.name;
            for (const ast::ExternDecl& ex : ns.externs) {  // external C functions (spec 26)
                llvm::FunctionType* ty =
                    externFnType(ex.params, ex.returnType, ex.isVariadic, ex.loc);
                functions[ex.name] =
                    llvm::Function::Create(ty, llvm::Function::ExternalLinkage, ex.name, module);
                functions[ex.name]->setCallingConv(worldToCallConv(ex.convention, ex.loc));  // [unknown-abi]
                externReturnType[ex.name] = typeRefName(ex.returnType);
            }
            for (const ast::ClassDecl& cls : ns.classes) {
                bool hasCtor = false;
                // A METHOD'S SYMBOL CARRIES ITS CLASS'S KEY, WHICH FOR A SHARED NAME IS ITS PATH.
                //
                // `Scanner.nextWord` is one symbol, and two classes called Scanner produced it twice:
                // the second registration replaced the first outright, so half the program called
                // methods belonging to a class it had never heard of -- and, since a call resolves
                // the receiver by path and then looked the symbol up by bare name, the other half
                // failed with `unknown method` against a method plainly written above it.
                //
                // This is also the whole of the "the standard library may not shadow itself"
                // limitation recorded as spec-divergences 9.5: it was never a rule about the library,
                // only about symbol names, and naming them by key ends it in both directions.
                //
                // Unique names -- every name in nearly every program -- keep the bare symbol they
                // always had, so nothing in an ordinary build changes at all.
                const std::string ck = clsKey(cls.name);
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        if (m == entry.method && !testMode) {
                            // A target with no C runtime is entered directly, not through `main`: emit
                            // `kmain(args)` that the caller invokes with null -- no argc/argv and no
                            // argv-array construction, so nothing needs libc. A freestanding program
                            // that DOES have a C runtime still gets the ordinary `main`, since that
                            // runtime is what calls it.
                            //
                            // ONE place answers this -- see `entryHasCRuntime` for which targets have
                            // none and why. The body emission asks the same question, and the two
                            // disagreeing is a crash rather than a diagnostic.
                            if (!entryHasCRuntime()) {
                                llvm::FunctionType* ty = llvm::FunctionType::get(
                                    builder.getInt32Ty(), {builder.getPtrTy()}, false);
                                functions["@entry"] = llvm::Function::Create(
                                    ty, llvm::Function::ExternalLinkage, "kmain", module);
                            } else {
                                // int main(int argc, char** argv): the real C entry, so main's
                                // `string[] args` can be filled from the command line.
                                llvm::FunctionType* ty = llvm::FunctionType::get(
                                    builder.getInt32Ty(),
                                    {builder.getInt32Ty(), builder.getPtrTy()}, false);
                                functions["@entry"] = llvm::Function::Create(
                                    ty, llvm::Function::ExternalLinkage, "main", module);
                            }
                            continue;
                        }
                        if (m->isAbstract) {
                            continue;  // no body to declare
                        }
                        // spec 22.6: a generator's parked body is not a method at all -- it becomes
                        // the four raw functions declared as externs by the synthesized class.
                        if (m->isGeneratorBody) {
                            continue;
                        }
                        // `extern syscall(N)`: not a call to a symbol at all, but the machine's
                        // own instruction with N in the number register. So it gets a BODY here
                        // rather than a declaration -- there is nothing to link against.
                        //
                        // And it is the clearest case for the architecture gate: the sequence below
                        // is Linux/x86-64 (rax=number, rdi/rsi/rdx/r10/r8/r9, `syscall`, clobbering
                        // rcx and r11). On Windows there is no stable syscall ABI at all, and on
                        // ARM the registers and the instruction are different. Emitting this
                        // anywhere else would produce a program that assembles and then does
                        // something arbitrary, which is the failure this compiler exists to refuse.
                        if (m->isExtern && m->externConvention.rfind("syscall:", 0) == 0) {
                            emitSyscallStub(cls.name, *m);
                            continue;
                        }
                        if (m->isExtern) {  // spec 26: links to a foreign symbol
                            // `symbol("...")` when the declaration gave one, the method's own name
                            // otherwise. The Polaron name and the linker name are separate things:
                            // without the clause, binding `SDL_CreateWindow` forced the method to
                            // be CALLED that, and foreign naming spread into Polaron source.
                            const std::string sym =
                                m->externSymbol.empty() ? m->name : m->externSymbol;
                            llvm::FunctionType* ety =
                                externFnType(m->params, m->returnType, m->isVariadic, m->loc,
                                             !m->isStatic);
                            llvm::Function* f = module.getFunction(sym);
                            if (f == nullptr) {
                                f = llvm::Function::Create(ety, llvm::Function::ExternalLinkage,
                                                           sym, module);
                            }
                            f->setCallingConv(worldToCallConv(m->externConvention, m->loc));  // [unknown-abi]
                            functions[ck + "." + m->name] = f;
                            functions[m->name] = f;  // also by bare C symbol, for goto (spec 7.9)
                            externReturnType[ck + "." + m->name] = typeRefName(m->returnType);
                            continue;
                        }
                        std::vector<llvm::Type*> ptypes;
                        std::vector<std::string> pnames;
                        if (!m->isStatic) {
                            ptypes.push_back(builder.getPtrTy());
                            pnames.emplace_back();  // `this` holds a slot so indices line up
                        }
                        for (const auto& p : m->params) {
                            ptypes.push_back(llvmType(typeRefName(p.type)));
                            pnames.push_back(typeRefName(p.type));
                        }
                        const std::string mangled = ck + "." + m->name;
                        if (m->isAsync) {
                            // Wrapper returns a Task<T> object (ptr); a separate resume
                            // function void(ptr state) runs the body (spec 20.2).
                            llvm::FunctionType* wty =
                                llvm::FunctionType::get(builder.getPtrTy(), ptypes, false);
                            functions[mangled] = llvm::Function::Create(
                                wty, llvm::Function::ExternalLinkage, mangled, module);
                            llvm::FunctionType* rty = llvm::FunctionType::get(
                                builder.getVoidTy(), {builder.getPtrTy()}, false);
                            functions[mangled + "$resume"] = llvm::Function::Create(
                                rty, llvm::Function::ExternalLinkage, mangled + "$resume", module);
                            continue;
                        }
                        const std::string mrt = typeRefName(m->returnType);
                        const bool mSret = returnsValueStruct(mrt);
                        llvm::FunctionType* ty;
                        if (mSret) {  // value struct return -> trailing sret slot, void return
                            std::vector<llvm::Type*> sp = ptypes;
                            sp.push_back(builder.getPtrTy());
                            ty = llvm::FunctionType::get(builder.getVoidTy(), sp, false);
                        } else {
                            ty = llvm::FunctionType::get(llvmType(mrt), ptypes, false);
                        }
                        // [unknown-abi] A method declared `unknown <world>` is a BOUNDARY THE FOREIGN
                        // WORLD CALLS INTO (the other direction from `unknown <world> funcptr`, which
                        // is us calling out). Two consequences, both required for the declaration to
                        // mean anything: it takes its BARE name as the linker symbol (the foreign world
                        // knows `syscall_entry`, not `Syscall.entry` -- it has no idea our classes
                        // exist), and it keeps external linkage through internalization/DCE, which
                        // would otherwise delete the very entry point the declaration promised. This is
                        // what lets a kernel define `_start`, an ISR, or `__polaron_malloc` in Polaron.
                        const bool foreignEntry = m->externConvention.rfind("unknown:", 0) == 0;
                        const std::string symbol = foreignEntry ? m->name : mangled;
                        llvm::Function* fn = llvm::Function::Create(
                            ty, llvm::Function::ExternalLinkage, symbol, module);
                        fn->setCallingConv(worldToCallConv(m->externConvention, m->loc));
                        if (foreignEntry) {
                            foreignEntryPoints_.insert(symbol);
                        }
                        // A `naked` method gets no prologue/epilogue: its body is raw assembly that owns
                        // the machine state exactly as the hardware handed it over (an entry point with
                        // no valid stack, or one running on the caller's). A compiler-emitted prologue
                        // would corrupt precisely what such a body exists to control.
                        if (m->isNaked) {
                            fn->addFnAttr(llvm::Attribute::Naked);
                            fn->addFnAttr(llvm::Attribute::NoInline);
                            fn->addFnAttr(llvm::Attribute::OptimizeNone);
                        }
                        if (mSret) {
                            sretFns_.insert(fn);
                            sretStructType_[fn] = classes[baseType(mrt)].type;
                        }
                        if (m->isVolatile) {  // spec 37.5: never inlined or optimized away
                            fn->addFnAttr(llvm::Attribute::NoInline);
                            fn->addFnAttr(llvm::Attribute::OptimizeNone);
                        }
                        markReceiver(fn, cls.name, m->isStatic);
                        functions[mangled] = fn;
                        paramTypeNames[fn] = pnames;
                        if (m->isInterrupt &&
                            requireTargetFeature("interrupt", "`" + cls.name + "." + m->name + "`",
                                                 m->loc)) {
                            declareInterruptEntry(cls.name, *m, fn);
                        }
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        hasCtor = true;
                        std::vector<llvm::Type*> ptypes;
                        std::vector<std::string> pnames;
                        ptypes.push_back(builder.getPtrTy());  // this
                        pnames.emplace_back();                 // ...and its empty slot
                        for (const auto& p : c->params) {
                            ptypes.push_back(llvmType(typeRefName(p.type)));
                            pnames.push_back(typeRefName(p.type));
                        }
                        llvm::FunctionType* ty =
                            llvm::FunctionType::get(builder.getVoidTy(), ptypes, false);
                        const std::string mangled = ck + "." + cls.name;
                        llvm::Function* cf = llvm::Function::Create(
                            ty, llvm::Function::ExternalLinkage, mangled, module);
                        functions[mangled] = cf;
                        paramTypeNames[cf] = pnames;
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) !=
                               nullptr) {
                        llvm::FunctionType* ty = llvm::FunctionType::get(
                            builder.getVoidTy(), {builder.getPtrTy()}, false);
                        const std::string mangled = ck + ".~" + cls.name;
                        functions[mangled] = llvm::Function::Create(
                            ty, llvm::Function::ExternalLinkage, mangled, module);
                    }
                }
                // Synthesize a default constructor so that `new X()` and inline
                // field initializers work for classes with no explicit ctor.
                // Interfaces are never instantiated, so they get none.
                if (!hasCtor && !cls.isInterface) {
                    llvm::FunctionType* ty = llvm::FunctionType::get(
                        builder.getVoidTy(), {builder.getPtrTy()}, false);
                    const std::string mangled = ck + "." + cls.name;
                    functions[mangled] = llvm::Function::Create(
                        ty, llvm::Function::ExternalLinkage, mangled, module);
                }
                // ...and a destructor for an unimportable class that wrote none, so the
                // live-instance count has somewhere to come down. Declared here; the body (the
                // decrement) is emitted with the other destructors.
                //
                // `countedClasses` for the same reason: a region class named by `release region` has
                // its count maintained and so needs the place where it comes down. Marking the class
                // as having a destructor WITHOUT declaring the function is a segfault rather than a
                // link error -- the delete path reads `functions[cn + ".~" + cn]`, and `operator[]`
                // on a missing key inserts a NULL, which then goes straight to CreateCall.
                if ((unimportableClasses.count(cls.name) > 0 ||
                     countedClasses.count(cls.name) > 0) &&
                    !cls.isInterface && functions.count(ck + ".~" + cls.name) == 0) {
                    llvm::FunctionType* ty = llvm::FunctionType::get(
                        builder.getVoidTy(), {builder.getPtrTy()}, false);
                    const std::string mangled = ck + ".~" + cls.name;
                    functions[mangled] = llvm::Function::Create(
                        ty, llvm::Function::ExternalLinkage, mangled, module);
                    synthesizedDtors_.insert(cls.name);
                }
                // spec 32.5 lifecycle hooks (void, no this).
                auto declHook = [&](const std::unique_ptr<ast::Block>& b, const char* suffix) {
                    if (!b) {
                        return;
                    }
                    llvm::FunctionType* ty = llvm::FunctionType::get(builder.getVoidTy(), false);
                    functions[ck + suffix] = llvm::Function::Create(
                        ty, llvm::Function::ExternalLinkage, ck + suffix, module);
                };
                declHook(cls.onClassLoad, ".__onClassLoad");
                declHook(cls.onFirstInstance, ".__onFirstInstance");
                declHook(cls.onLastInstanceDestroyed, ".__onLastInstanceDestroyed");
                declHook(cls.onClassUnload, ".__onClassUnload");
                // F9 opaque bundles: a public class exports an allocating constructor (__new) and
                // a destroying one (__delete). A consumer that imports the class cannot see its
                // full layout, so it creates/destroys instances through these. Defined in library
                // mode (its own classes); declared external for imported classes (call the .polb).
                if (!cls.isInterface && !cls.isAbstract && cls.visibility == "public" &&
                    (bundle.isImported || libraryMode)) {
                    std::vector<llvm::Type*> np;  // __new params = the constructor's params
                    for (const ast::MemberPtr& m : cls.members) {
                        if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
                            for (const auto& p : c->params) {
                                np.push_back(llvmType(typeRefName(p.type)));
                            }
                            break;
                        }
                    }
                    // By key, like every other symbol: `delete` on an imported class resolves the
                    // receiver through clsKey and then asks for `<key>.__delete`, so declaring it
                    // under the bare name left that lookup inserting a null Function* and calling
                    // through it -- an access violation with no diagnostic, in the consumer.
                    functions[ck + ".__new"] = llvm::Function::Create(
                        llvm::FunctionType::get(builder.getPtrTy(), np, false),
                        llvm::Function::ExternalLinkage, ck + ".__new", module);
                    functions[ck + ".__delete"] = llvm::Function::Create(
                        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false),
                        llvm::Function::ExternalLinkage, ck + ".__delete", module);
                }
            }
            // `comptime literal` suffix functions (spec 17.10): namespace-level (legacy) and the
            // class/struct-owned form. Both lower to a function keyed by name and parameter type.
            auto declLiteral = [&](const ast::LiteralDecl& lit) {
                const std::string pt = typeRefName(lit.param.type);
                const std::string key = lit.name + "$" + pt;  // overload by parameter type (17.10)
                llvm::FunctionType* ty = llvm::FunctionType::get(
                    llvmType(typeRefName(lit.returnType)), {llvmType(pt)}, false);
                functions[key] = llvm::Function::Create(
                    ty, llvm::Function::ExternalLinkage, "literal." + lit.name + "." + pt, module);
                literalReturnType[key] = typeRefName(lit.returnType);
                literalSuffixParams[lit.name].push_back(pt);
            };
            for (const ast::LiteralDecl& lit : ns.literals) {
                declLiteral(lit);
            }
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& m : cls.members) {
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get())) {
                        declLiteral(*lit);
                    }
                }
            }
            // Catalog-implementing enum methods (spec 12.4). An instance method
            // receives the enum value (its i32 ordinal) as `this`.
            for (const ast::EnumDecl& en : ns.enums) {
                if (en.isJavaStyle) {
                    continue;
                }
                for (const ast::MemberPtr& member : en.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isAbstract) {
                        continue;
                    }
                    std::vector<llvm::Type*> ptypes;
                    if (!m->isStatic) {
                        ptypes.push_back(builder.getInt32Ty());  // this = ordinal
                    }
                    for (const auto& p : m->params) {
                        ptypes.push_back(llvmType(typeRefName(p.type)));
                    }
                    llvm::FunctionType* ty = llvm::FunctionType::get(
                        llvmType(typeRefName(m->returnType)), ptypes, false);
                    const std::string mangled = en.name + "." + m->name;
                    functions[mangled] = llvm::Function::Create(
                        ty, llvm::Function::ExternalLinkage, mangled, module);
                }
            }
        }
    }
}

bool CodeGenerator::Impl::stmtWholeAssignsField(const ast::Stmt* st, const std::string& field) {
    if (st == nullptr) {
        return false;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(st)) {
        const auto* mt = dynamic_cast<const ast::MemberExpr*>(as->target.get());
        if (mt != nullptr && mt->member == field) {
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mt->object.get())) {
                return id->name == "this";
            }
        }
        return false;
    }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            if (stmtWholeAssignsField(s.get(), field)) {
                return true;
            }
        }
        return false;
    };
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(st)) {
        return blk(i->thenBlock) || (i->elseBlock && blk(*i->elseBlock));
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) {
        return blk(w->body);
    }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) {
        return blk(d->body);
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) {
        return blk(f->body);
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) {
        return blk(fe->body);
    }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
        for (const auto& c : sw->cases) {
            if (blk(c.body)) {
                return true;
            }
        }
        return sw->defaultBody && blk(*sw->defaultBody);
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
        for (const auto& c : ms->cases) {
            if (blk(c.body)) {
                return true;
            }
        }
        return ms->defaultBody && blk(*ms->defaultBody);
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
        if (blk(tr->body)) {
            return true;
        }
        for (const auto& c : tr->catches) {
            if (blk(c.body)) {
                return true;
            }
        }
        return tr->finallyBlock && blk(*tr->finallyBlock);
    }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) {
        return blk(df->body);
    }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) {
        return blk(us->body);
    }
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) {
        return stmtWholeAssignsField(lb->stmt.get(), field);
    }
    return false;
}

bool CodeGenerator::Impl::anyCtorWholeAssignsField(const ast::ClassDecl& cls, const std::string& field) {
    for (const auto& m : cls.members) {
        if (const auto* ctor = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
            for (const auto& s : ctor->body.statements) {
                if (stmtWholeAssignsField(s.get(), field)) {
                    return true;
                }
            }
        }
    }
    return false;
}

void CodeGenerator::Impl::emitFieldInits(const ast::ClassDecl& cls, llvm::Value* thisPtr) {
    // Resolved, for the same reason as the field-filling walk: with two classes of one name, the bare
    // key is whichever was declared first, and initialising the wrong one's fields is silent.
    ClassLayout& layout = classes[resolveClassKey(cls.name)];
    // Null-default owned-type fields (String, value class, array) that have no inline initializer,
    // before running the initializers/body. Heap objects come from malloc, which does not zero, so
    // such a field would otherwise hold garbage until first assigned -- and reassignment now frees
    // the previous owned value (M3), which on a garbage pointer would crash. A null default makes
    // that free null-safe (and reading an unset owned field yields null, not garbage). Borrowed
    // T*/T& fields are left alone (not freed on reassignment, and often perf-critical, e.g. tree
    // links); fields with an inline initializer are set by the loop below.
    for (const ast::MemberPtr& member : cls.members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
        if (f == nullptr || f->init || f->isStatic || f->isLazy) {
            continue;
        }
        const std::string ft = typeRefName(f->type);
        if (ft != "String" && !isClassValue(ft) && !isArrayType(ft)) {
            continue;
        }
        auto di = layout.fieldIndex.find(f->name);
        if (di == layout.fieldIndex.end()) {
            continue;
        }
        if (!llvmType(ft)->isPointerTy()) {
            continue;  // only pointer-stored owned fields
        }
        if (auto sit = classes.find(ft);
            sit != classes.end() && sit->second.isStruct &&
            !anyCtorWholeAssignsField(cls, f->name)) {
            // A value-struct field that no constructor sets as a whole (only its members are
            // written, e.g. `this.cap.x = ...`) needs backing storage up front, or that member
            // write would dereference a null slot and crash. Default it to a zeroed owned heap
            // instance (value types default to zero); it is freed with the object like any owned
            // field, and no whole-assignment overwrites it, so there is nothing to leak.
            llvm::Type* sty = sit->second.type;
            llvm::Value* inst = builder.CreateCall(mallocFn(), {sizeOf(sty)}, f->name + ".dflt");
            emitMemset(inst, builder.getInt32(0), sizeOf(sty));
            builder.CreateStore(
                inst, builder.CreateStructGEP(layout.type, thisPtr, di->second, f->name));
            continue;
        }
        builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()),
                            builder.CreateStructGEP(layout.type, thisPtr, di->second, f->name));
    }
    for (const ast::MemberPtr& member : cls.members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
        if (f == nullptr || !f->init || f->isStatic) {
            continue;
        }
        auto idx = layout.fieldIndex.find(f->name);
        // A lazy field (spec 28.4) is initialized on first access, not here -- but
        // its storage must start null so the null sentinel is valid (heap objects
        // come from malloc, which does not zero).
        if (f->isLazy) {
            if (idx == layout.fieldIndex.end()) {
                continue;
            }
            llvm::Type* fty = llvmType(typeRefName(f->type));
            if (fty->isPointerTy()) {
                builder.CreateStore(
                    llvm::ConstantPointerNull::get(builder.getPtrTy()),
                    builder.CreateStructGEP(layout.type, thisPtr, idx->second, f->name));
            }
            continue;
        }
        if (idx == layout.fieldIndex.end()) {
            continue;
        }
        llvm::Value* v = emitExpr(*f->init);
        if (v == nullptr) {
            continue;
        }
        v = maskBitField(v, cls.name, f->name);  // constrain a bit-field initializer (spec 11.1)
        llvm::Value* fp = builder.CreateStructGEP(layout.type, thisPtr, idx->second, f->name);
        builder.CreateStore(v, fp);
    }
}

void CodeGenerator::Impl::emitTaskComplete(llvm::Value* value) {
    llvm::FunctionType* ft = llvm::FunctionType::get(
        builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
    llvm::Value* h = builder.CreatePtrToInt(currentAsyncState, builder.getInt64Ty());
    // valueToI64 widens pointers/ints/doubles and boxes a value struct (a value Result/Option), so
    // an async method returning a value Result/Option completes correctly rather than losing it.
    llvm::Value* v = (value == nullptr) ? builder.getInt64(0) : valueToI64(value);
    builder.CreateCall(module.getOrInsertFunction("__polaron_task_complete", ft), {h, v});
}

void CodeGenerator::Impl::emitTaskCompleteError(llvm::Value* carrier) {
    llvm::FunctionType* ft = llvm::FunctionType::get(
        builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
    llvm::Value* h = builder.CreatePtrToInt(currentAsyncState, builder.getInt64Ty());
    llvm::Value* c = builder.CreatePtrToInt(carrier, builder.getInt64Ty());
    builder.CreateCall(module.getOrInsertFunction("__polaron_task_complete_error", ft), {h, c});
}

void CodeGenerator::Impl::emitAwaitRethrowCheck(llvm::Value* handle) {
    llvm::FunctionType* ety =
        llvm::FunctionType::get(builder.getInt64Ty(), {builder.getInt64Ty()}, false);
    llvm::Value* err = builder.CreateCall(
        module.getOrInsertFunction("__polaron_task_error", ety), {handle}, "aw.err");
    llvm::Value* hasErr = builder.CreateICmpNE(err, builder.getInt64(0));
    llvm::BasicBlock* throwBB = llvm::BasicBlock::Create(context, "await.throw", currentFn);
    llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "await.ok", currentFn);
    builder.CreateCondBr(hasErr, throwBB, okBB);
    builder.SetInsertPoint(throwBB);
    emitThrowObject(builder.CreateIntToPtr(err, builder.getPtrTy()));
    builder.SetInsertPoint(okBB);
}

void CodeGenerator::Impl::collectReturnedNames(const ast::Stmt* st, std::set<std::string>& out) {
    if (st == nullptr) {
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(st)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(rs->value.get())) {
            out.insert(id->name);
        }
        return;
    }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            collectReturnedNames(s.get(), out);
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
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { collectReturnedNames(lb->stmt.get(), out); return; }
}

void CodeGenerator::Impl::promoteEscapingNews(const ast::Stmt* st, const std::set<std::string>& returned) {
    if (st == nullptr) {
        return;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) {
        if (returned.count(vd->name) > 0) {
            if (const auto* cnw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                if (cnw->location == "stack" && cnw->region.empty()) {
                    const_cast<ast::NewExpr*>(cnw)->location = "heap";
                }
            }
        }
        return;
    }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            promoteEscapingNews(s.get(), returned);
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
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { promoteEscapingNews(lb->stmt.get(), returned); return; }
}

}  // namespace polaron
