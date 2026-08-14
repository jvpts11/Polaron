#include "codegen/codegen_impl.h"

namespace polaron {

llvm::DIFile* CodeGenerator::Impl::diFileFor(std::string_view path) {
    std::string p(path);
    if (p.empty()) {
        p = module.getName().str();
    }
    auto it = diFiles.find(p);
    if (it != diFiles.end()) {
        return it->second;
    }
    std::string dir, name = p;
    std::size_t slash = p.find_last_of("/\\");
    if (slash != std::string::npos) {
        dir = p.substr(0, slash);
        name = p.substr(slash + 1);
    }
    llvm::DIFile* f = dib->createFile(name, dir);
    diFiles[p] = f;
    return f;
}

void CodeGenerator::Impl::initDebugInfo() {
    dib = std::make_unique<llvm::DIBuilder>(module);
    llvm::DIFile* mainFile = diFileFor(module.getName());
    diCU = dib->createCompileUnit(llvm::dwarf::DW_LANG_C, mainFile, "polc",
                                  /*isOptimized=*/false, /*flags=*/"", /*runtimeVersion=*/0);
    diIntTy = dib->createBasicType("int", 32, llvm::dwarf::DW_ATE_signed);
    module.addModuleFlag(llvm::Module::Warning, "Debug Info Version",
                         llvm::DEBUG_METADATA_VERSION);
    module.addModuleFlag(llvm::Module::Warning, "Dwarf Version", 4);
}

void CodeGenerator::Impl::finalizeDebugInfo() {
    if (dib) {
        dib->finalize();
    }
}

llvm::DISubroutineType* CodeGenerator::Impl::diMinimalFnType(llvm::DIFile* file) {
    llvm::SmallVector<llvm::Metadata*, 1> elts{diIntTy};
    return dib->createSubroutineType(dib->getOrCreateTypeArray(elts));
}

llvm::DISubprogram* CodeGenerator::Impl::beginDebugFunction(llvm::Function* fn, SourceLocation loc) {
    if (!debugInfo || !dib) { diCurrentSP = nullptr; return nullptr; }
    llvm::DIFile* file = diFileFor(loc.file);
    unsigned line = loc.line > 0 ? static_cast<unsigned>(loc.line) : 1;
    llvm::DISubprogram* sp = dib->createFunction(
        file, fn->getName(), fn->getName(), file, line, diMinimalFnType(file), line,
        llvm::DINode::FlagPrototyped, llvm::DISubprogram::SPFlagDefinition);
    fn->setSubprogram(sp);
    diCurrentSP = sp;
    return sp;
}

void CodeGenerator::Impl::setDebugLoc(SourceLocation loc) {
    // Remembered whatever -g says. A runtime guard that fires has to name the line it fired on,
    // and a program built without debug info is exactly the program whose crash you cannot walk
    // back in a debugger -- so it is the one that needs the line in the message most. Storing
    // three fields per statement costs nothing a compiler notices.
    if (loc.line > 0) {
        hereLoc = loc;
    }
    if (!debugInfo || diCurrentSP == nullptr) {
        return;
    }
    unsigned line = loc.line > 0 ? static_cast<unsigned>(loc.line) : diCurrentSP->getLine();
    unsigned col = loc.col > 0 ? static_cast<unsigned>(loc.col) : 1;
    builder.SetCurrentDebugLocation(llvm::DILocation::get(context, line, col, diCurrentSP));
}

llvm::DIType* CodeGenerator::Impl::diCachedBasic(const std::string& name, unsigned bits, unsigned enc) {
    std::string key = name + ':' + std::to_string(bits) + ':' + std::to_string(enc);
    auto it = diTypeCache.find(key);
    if (it != diTypeCache.end()) {
        return it->second;
    }
    llvm::DIType* t = dib->createBasicType(name, bits, enc);
    diTypeCache[key] = t;
    return t;
}

llvm::DIType* CodeGenerator::Impl::diPtrTy() {
    if (diPtrTy_ == nullptr) {
        diPtrTy_ = dib->createBasicType("ptr", 64, llvm::dwarf::DW_ATE_address);
    }
    return diPtrTy_;
}

llvm::DIType* CodeGenerator::Impl::diTypeFor(const std::string& tyName, llvm::Type* storage) {
    if (storage == nullptr) {
        return diIntTy;
    }
    if (storage->isPointerTy()) {
        return diPtrTy();
    }
    if (storage->isFloatTy()) {
        return diCachedBasic(tyName.empty() ? "smallfloat" : tyName, 32, llvm::dwarf::DW_ATE_float);
    }
    if (storage->isDoubleTy()) {
        return diCachedBasic(tyName.empty() ? "float" : tyName, 64, llvm::dwarf::DW_ATE_float);
    }
    if (auto* it = llvm::dyn_cast<llvm::IntegerType>(storage)) {
        unsigned bits = it->getBitWidth();
        if (bits == 1) {
            return diCachedBasic("boolean", 8, llvm::dwarf::DW_ATE_boolean);
        }
        bool uns = tyName.rfind("uint", 0) == 0 || tyName.rfind("ubyte", 0) == 0 ||
                   tyName.rfind("ushort", 0) == 0 || tyName.rfind("ulong", 0) == 0;
        unsigned enc = uns ? llvm::dwarf::DW_ATE_unsigned : llvm::dwarf::DW_ATE_signed;
        std::string nm = tyName.empty() ? ("int" + std::to_string(bits)) : tyName;
        return diCachedBasic(nm, bits, enc);
    }
    return diPtrTy();  // structs/arrays by value: at least surface the address
}

bool CodeGenerator::Impl::fieldIsWeak(const std::string& cls, const std::string& fname) {
    for (std::string cur = cls; !cur.empty();) {
        auto it = classes.find(cur);
        if (it == classes.end()) {
            return false;
        }
        if (it->second.weakFields.count(fname) > 0) {
            return true;
        }
        cur = baseType(it->second.superclass);
    }
    return false;
}

llvm::Value* CodeGenerator::Impl::weakHeadOffset(const std::string& cls) {
    auto it = classes.find(cls);
    const llvm::StructLayout* sl = module.getDataLayout().getStructLayout(it->second.type);
    return builder.getInt64(sl->getElementOffset(it->second.weakHeadIdx));
}

void CodeGenerator::Impl::initWeakState(llvm::Value* objPtr, const std::string& cn) {
    auto cit = classes.find(cn);
    if (cit == classes.end() || cit->second.type == nullptr) {
        return;
    }
    const ClassLayout& cl = cit->second;
    if (cl.weakFields.empty() && !cl.needsWeakHead && !anyWeakField(cn)) {
        return;
    }
    llvm::Value* nul = llvm::ConstantPointerNull::get(builder.getPtrTy());
    for (const auto& [fname, idx] : cl.fieldIndex) {
        if (!fieldIsWeak(cn, fname)) {
            continue;
        }
        llvm::Value* slot = builder.CreateStructGEP(cl.type, objPtr, idx, fname + ".winit");
        builder.CreateStore(nul, builder.CreateStructGEP(weakSlotType(), slot, 0));
        builder.CreateStore(nul, builder.CreateStructGEP(weakSlotType(), slot, 1));
    }
    if (cl.needsWeakHead) {
        builder.CreateStore(
            nul, builder.CreateStructGEP(cl.type, objPtr, cl.weakHeadIdx, "whead.winit"));
    }
}

bool CodeGenerator::Impl::anyWeakField(const std::string& cn) {
    for (std::string cur = cn; !cur.empty();) {
        auto it = classes.find(cur);
        if (it == classes.end()) {
            return false;
        }
        if (!it->second.weakFields.empty()) {
            return true;
        }
        cur = baseType(it->second.superclass);
    }
    return false;
}

bool CodeGenerator::Impl::weakRelevant(const std::string& cn) {
    auto cit = classes.find(cn);
    return anyWeakField(cn) || (cit != classes.end() && cit->second.needsWeakHead);
}

void CodeGenerator::Impl::emitWeakCleanup(llvm::Value* objPtr, const std::string& cn) {
    auto cit = classes.find(cn);
    if (cit == classes.end() || cit->second.type == nullptr || cit->second.imported) {
        return;
    }
    const ClassLayout& cl = cit->second;
    for (const auto& [fname, idx] : cl.fieldIndex) {
        if (!fieldIsWeak(cn, fname)) {
            continue;
        }
        llvm::Value* slot = builder.CreateStructGEP(cl.type, objPtr, idx, fname + ".wunlink");
        builder.CreateCall(weakUnlinkFn(), {slot, weakHeadOffset(baseType(cl.fieldType.at(fname)))});
    }
    if (cl.needsWeakHead) {
        llvm::Value* head = builder.CreateStructGEP(cl.type, objPtr, cl.weakHeadIdx, "whead");
        builder.CreateCall(weakNullifyFn(), {head});
    }
}

llvm::Function* CodeGenerator::Impl::regionDtorFn(const std::string& cn) {
    auto dit = functions.find(cn + ".~" + cn);
    const bool weak = weakRelevant(cn);
    if (!weak) {
        return dit == functions.end() ? nullptr : dit->second;
    }
    const std::string tname = cn + ".__rgndtor";
    if (auto tit = functions.find(tname); tit != functions.end()) {
        return tit->second;
    }
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
    auto* thunk = llvm::Function::Create(ty, llvm::Function::InternalLinkage, tname, module);
    auto ip = builder.saveIP();
    llvm::Function* savedFn = currentFn;
    currentFn = thunk;
    builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", thunk));
    llvm::Value* obj = thunk->getArg(0);
    if (dit != functions.end()) {
        builder.CreateCall(dit->second, {obj});
    }
    emitWeakCleanup(obj, cn);
    builder.CreateRetVoid();
    currentFn = savedFn;
    builder.restoreIP(ip);
    functions[tname] = thunk;
    return thunk;
}

void CodeGenerator::Impl::error(std::string message, SourceLocation loc) {
    errors.push_back(CodegenError{std::move(message), loc});
}

llvm::StructType* CodeGenerator::Impl::tupleStructType(const std::string& t) {
    auto it = tupleTypes.find(t);
    if (it != tupleTypes.end()) {
        return it->second;
    }
    std::vector<llvm::Type*> elems;
    for (const std::string& e : tupleElems(t)) {
        elems.push_back(llvmType(e));
    }
    llvm::StructType* st = llvm::StructType::get(context, elems);
    tupleTypes[t] = st;
    return st;
}

llvm::StructType* CodeGenerator::Impl::variantStructType() {
    if (variantStructTy_ == nullptr) {
        variantStructTy_ = llvm::StructType::create(
            context, {builder.getInt32Ty(), builder.getInt64Ty()}, "__polaron_variant");
    }
    return variantStructTy_;
}

llvm::Value* CodeGenerator::Impl::variantEncode(llvm::Value* v) {
    if (v == nullptr) {
        return builder.getInt64(0);
    }
    llvm::Type* ty = v->getType();
    if (ty->isPointerTy()) {
        return builder.CreatePtrToInt(v, builder.getInt64Ty(), "var.enc.p");
    }
    if (ty->isFloatingPointTy()) {
        llvm::Value* bits = builder.CreateBitCast(
            v, builder.getIntNTy(ty->getPrimitiveSizeInBits()), "var.enc.fb");
        return builder.CreateZExt(bits, builder.getInt64Ty(), "var.enc.f");
    }
    return builder.CreateZExtOrTrunc(v, builder.getInt64Ty(), "var.enc.i");
}

llvm::Value* CodeGenerator::Impl::variantDecode(llvm::Value* payload, llvm::Type* ty) {
    if (ty->isPointerTy()) {
        return builder.CreateIntToPtr(payload, ty, "var.dec.p");
    }
    if (ty->isFloatingPointTy()) {
        llvm::Value* bits = builder.CreateTrunc(
            payload, builder.getIntNTy(ty->getPrimitiveSizeInBits()), "var.dec.fb");
        return builder.CreateBitCast(bits, ty, "var.dec.f");
    }
    return builder.CreateZExtOrTrunc(payload, ty, "var.dec.i");
}

std::string CodeGenerator::Impl::repType(const std::string& t) {
    auto it = newtypes_.find(t);
    return it == newtypes_.end() ? t : repType(it->second);
}

llvm::Type* CodeGenerator::Impl::llvmType(const std::string& t) {
    if (t == "void") {
        return builder.getVoidTy();
    }
    // `nullable T` (spec 3.7): a nullable REFERENCE (class/String/array) already lowers to a
    // pointer, so the marker is a no-op there. A nullable PRIMITIVE has no in-band null, so it is
    // boxed as a null-capable pointer to a heap cell (null = the null pointer).
    if (ast::typeIsNullable(t)) {
        const std::string inner = ast::stripNullable(t);
        if (isBoxablePrimitive(inner)) {
            return builder.getPtrTy();
        }
        return llvmType(inner);
    }
    if (isTupleType(t)) {
        return tupleStructType(t);
    }
    if (isFloatType(t)) {
        switch (floatBits(t)) {
            case 16: return builder.getHalfTy();           // smallfloat
            case 128: return llvm::Type::getFP128Ty(context);  // quadruple
            case 64: return builder.getDoubleTy();         // double / float64
            default: return builder.getFloatTy();          // float / float32
        }
    }
    if (int w = vecWidth(t)) {  // SIMD vec2/3/4 -> <N x float>
        return llvm::FixedVectorType::get(builder.getFloatTy(), static_cast<unsigned>(w));
    }
    if (t == "mat4") {
        return llvm::FixedVectorType::get(builder.getFloatTy(), 16);  // SIMD 4x4 matrix
    }
    if (isArrayType(t) || isRefType(t)) {
        return builder.getPtrTy();
    }
    if (t == "region") {
        return builder.getPtrTy();  // pointer to the region block
    }
    if (t == "checkpoint") {
        return builder.getInt64Ty();  // spec 17 stack flavor: an opaque cursor value
    }
    if (t.rfind("function<", 0) == 0) {
        return builder.getPtrTy();  // a function value (pointer)
    }
    if (t.rfind("funcptr<", 0) == 0) {
        return builder.getPtrTy();  // a bare C function pointer
    }
    if (t == "String" || t == "string") {
        return builder.getPtrTy();  // ptr to {i64 len, ptr data}
    }
    if (t == "Type" || t == "Method" || t == "Field" || t == "Annotation") {
        return builder.getPtrTy();  // reflection tokens (spec 31)
    }
    if (t == "Object") {
        return builder.getPtrTy();  // root reference type (spec 3.4)
    }
    if (t == "Decimal") {
        return builder.getInt128Ty();  // fixed-point, scale 10^18 (spec 34)
    }
    if (isValueVariant(t)) {
        return variantStructType();  // value Result/Option: { i32 tag, i64 payload }
    }
    if (classes.count(t) > 0) {
        return builder.getPtrTy();
    }
    if (auto it = newtypes_.find(t); it != newtypes_.end()) {
        return llvmType(it->second);
    }
    // A method-carrying catalog value is tagged (enumTypeId << 32 | ordinal) for multi-implementer
    // dispatch (spec 12.4), so it lowers to i64 rather than a bare i32 ordinal.
    if (isTaggedCatalog(t)) {
        return builder.getInt64Ty();
    }
    return builder.getIntNTy(intBits(t));
}

llvm::Value* CodeGenerator::Impl::coerce(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw) {
    if (v == nullptr) {
        return v;
    }
    const std::string from = repType(fromRaw), to = repType(toRaw);  // newtype -> underlying
    // A primitive flowing to Object is boxed (spec 3.4): every value is an Object.
    if (to == "Object" && isBoxablePrimitive(from)) {
        return emitBox(v, from);
    }
    // String and mutable `string` share one representation ({len, data} pointer), so a coerce
    // between them is a no-op here. Ownership/isolation for a `string` (its own buffer, freed at
    // scope exit, no aliasing of the source) is applied at the STORE sites -- VarDecl, assignment,
    // and return -- exactly as for an immutable String (see declIsString / the String assign path).
    if (to == "string" && (from == "string" || from == "String")) {
        return v;
    }
    // Boxing a nullable primitive (spec 3.7): a primitive value flowing into `T?` is stored in a
    // heap cell so the pointer can be null. A null literal or an already-boxed nullable passes
    // through as the pointer. (Unboxing happens only via `??` / an explicit null check.)
    if (ast::typeIsNullable(to) && isBoxablePrimitive(ast::stripNullable(to))) {
        if (from == "null" || v->getType()->isPointerTy()) {
            return v;
        }
        const std::string inner = ast::stripNullable(to);
        llvm::Value* cell = builder.CreateCall(mallocFn(), {builder.getInt64(8)}, "nbox");
        builder.CreateStore(coerce(v, from, inner), cell);
        return cell;
    }
    // Catalog tag (spec 12.4 multi-implementer dispatch): pack an implementing enum's ordinal into a
    // tagged catalog value as (enumTypeId << 32 | ordinal). catalog->catalog is identity; the reverse
    // catalog->int is a plain truncation to the low 32 bits (the ordinal), handled by the integer
    // path below.
    // A java-style enum value converting to an integer is asking for its ORDINAL (spec 12.5),
    // not its pointer bits -- the same recovery interpolation and comparisons already use.
    // Before this branch existed the generic pointer path truncated the singleton's address,
    // which is a value that means nothing (found by the relayout's RL-3).
    if (isIntName(to) && javaEnums.count(baseType(from)) > 0 && v->getType()->isPointerTy()) {
        return coerce(emitJavaEnumOrdinal(v, baseType(from)), "int", to);
    }
    if (isTaggedCatalog(to)) {
        if (isTaggedCatalog(from)) {
            return v;
        }
        if (enums.count(from) > 0 && v->getType()->isIntegerTy()) {
            llvm::Value* ord = builder.CreateZExt(v, builder.getInt64Ty());
            return builder.CreateOr(
                ord, builder.getInt64(static_cast<std::int64_t>(enumTypeId[from]) << 32));
        }
        // A java-style enum value is its singleton pointer; recover the ordinal by identity
        // against the cached singletons, then pack it exactly like the ordinal case.
        if (javaEnums.count(baseType(from)) > 0 && v->getType()->isPointerTy()) {
            llvm::Value* ord = builder.CreateZExt(
                emitJavaEnumOrdinal(v, baseType(from)), builder.getInt64Ty());
            return builder.CreateOr(
                ord,
                builder.getInt64(static_cast<std::int64_t>(enumTypeId[baseType(from)]) << 32));
        }
    }
    if (isFloatType(to)) {
        llvm::Type* fty = llvmType(to);
        if (v->getType()->isIntegerTy()) {
            return isUnsigned(from) ? builder.CreateUIToFP(v, fty)
                                    : builder.CreateSIToFP(v, fty);
        }
        if (v->getType()->isFloatingPointTy() && v->getType() != fty) {
            return fty->getPrimitiveSizeInBits() > v->getType()->getPrimitiveSizeInBits()
                       ? builder.CreateFPExt(v, fty)     // widen (e.g. float -> double)
                       : builder.CreateFPTrunc(v, fty);  // narrow (e.g. double -> float)
        }
        return v;
    }
    if (v->getType()->isIntegerTy() && llvmType(to)->isIntegerTy()) {
        const unsigned want = llvmType(to)->getIntegerBitWidth();
        const unsigned have = v->getType()->getIntegerBitWidth();
        if (want > have) {
            return isUnsigned(from) ? builder.CreateZExt(v, llvmType(to))
                                    : builder.CreateSExt(v, llvmType(to));
        }
        if (want < have) {
            return builder.CreateTrunc(v, llvmType(to));
        }
    }
    return v;
}

bool CodeGenerator::Impl::isBoxablePrimitive(const std::string& t) {
    if (t == "Decimal") {
        return false;  // 128-bit; the box value field is only 64 bits
    }
    if (isFloatType(t)) {
        return true;
    }
    llvm::Type* lt = llvmType(repType(t));
    return lt != nullptr && lt->isIntegerTy();
}

llvm::StructType* CodeGenerator::Impl::boxStructTy() {
    if (boxStructTy_ == nullptr) {
        boxStructTy_ = llvm::StructType::create(
            context, {builder.getPtrTy(), builder.getInt64Ty()}, "__box");
    }
    return boxStructTy_;
}

llvm::Value* CodeGenerator::Impl::emitBox(llvm::Value* v, const std::string& from) {
    llvm::StructType* bt = boxStructTy();
    llvm::Value* box = builder.CreateCall(mallocFn(), {sizeOf(bt)}, "box");
    llvm::Value* vt = llvm::ConstantPointerNull::get(builder.getPtrTy());
    if (auto it = classes.find("Object"); it != classes.end() && it->second.vtable != nullptr) {
        vt = it->second.vtable;
    }
    builder.CreateStore(vt, builder.CreateStructGEP(bt, box, 0));
    llvm::Value* val64;
    if (v->getType()->isDoubleTy()) {
        val64 = builder.CreateBitCast(v, builder.getInt64Ty());
    } else if (v->getType()->isFloatingPointTy()) {  // float32
        val64 = builder.CreateZExt(builder.CreateBitCast(v, builder.getInt32Ty()),
                                   builder.getInt64Ty());
    } else {
        val64 = isUnsigned(from) ? builder.CreateZExt(v, builder.getInt64Ty())
                                 : builder.CreateSExt(v, builder.getInt64Ty());
    }
    builder.CreateStore(val64, builder.CreateStructGEP(bt, box, 1));
    return box;
}

llvm::Value* CodeGenerator::Impl::emitUnbox(llvm::Value* box, const std::string& to) {
    llvm::StructType* bt = boxStructTy();
    llvm::Value* val64 = builder.CreateLoad(
        builder.getInt64Ty(), builder.CreateStructGEP(bt, box, 1), "unbox");
    if (isFloatType(to)) {
        if (isF32(to)) {
            return builder.CreateBitCast(builder.CreateTrunc(val64, builder.getInt32Ty()),
                                         builder.getFloatTy());
        }
        return builder.CreateBitCast(val64, builder.getDoubleTy());
    }
    const unsigned w = llvmType(to)->getIntegerBitWidth();
    return w < 64 ? builder.CreateTrunc(val64, builder.getIntNTy(w)) : val64;
}

std::string CodeGenerator::Impl::whereLine() const {
    if (hereLoc.line <= 0) {
        return "";
    }
    std::string file = std::string(hereLoc.file);
    if (file.empty()) {
        file = "<prelude>";
    }
    std::string fnName;
    if (builder.GetInsertBlock() != nullptr && builder.GetInsertBlock()->getParent() != nullptr) {
        fnName = builder.GetInsertBlock()->getParent()->getName().str();
    }
    std::string out = "  --> " + file + ":" + std::to_string(hereLoc.line) + ":" +
                      std::to_string(hereLoc.col);
    if (!fnName.empty()) {
        out += "  in " + fnName;
    }
    return out + "\n";
}

void CodeGenerator::Impl::emitPanic(const std::string& msg) {
    llvm::FunctionType* ft =
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
    llvm::FunctionCallee panic = module.getOrInsertFunction("__polaron_panic", ft);
    markGuardHelper(panic);   // noreturn/nounwind/cold -- see markGuardHelper for what it bought
    builder.CreateCall(panic, {createGlobalStringPtr(builder, msg, ".panic")});
    builder.CreateUnreachable();
}

llvm::Value* CodeGenerator::Impl::emitIntDivRem(llvm::Value* l, llvm::Value* r, bool uns, bool rem) {
    llvm::Type* ty = r->getType();
    llvm::Value* bad = builder.CreateICmpEQ(r, llvm::ConstantInt::get(ty, 0));
    if (!uns) {
        llvm::Value* isMin = builder.CreateICmpEQ(
            l, llvm::ConstantInt::get(ty, llvm::APInt::getSignedMinValue(ty->getIntegerBitWidth())));
        llvm::Value* isNeg1 = builder.CreateICmpEQ(r, llvm::ConstantInt::getSigned(ty, -1));
        bad = builder.CreateOr(bad, builder.CreateAnd(isMin, isNeg1));
    }
    llvm::Function* f = currentFn;
    auto* badBB = llvm::BasicBlock::Create(context, "div.bad", f);
    auto* okBB = llvm::BasicBlock::Create(context, "div.ok", f);
    builder.CreateCondBr(bad, badBB, okBB);
    builder.SetInsertPoint(badBB);
    emitArithFault("DivideByZeroException", "integer division by zero or overflow");
    builder.SetInsertPoint(okBB);
    if (rem) {
        return uns ? builder.CreateURem(l, r) : builder.CreateSRem(l, r);
    }
    return uns ? builder.CreateUDiv(l, r) : builder.CreateSDiv(l, r);
}

void CodeGenerator::Impl::emitArithFault(const std::string& exceptionClass, const std::string& panicMsg) {
    // POLARON_ARITH_PANIC=1 forces the old always-panic form. It exists to A/B the COST of making these
    // faults throwable: the guard itself is unchanged, but a cold path that can UNWIND keeps a
    // function's unwind edges alive, which is the one way this could reach the hot path. Kept so the
    // question can be re-asked cheaply after any future EH work.
    static const bool forcePanic = std::getenv("POLARON_ARITH_PANIC") != nullptr;
    if (program.isFreestanding || forcePanic) {
        emitPanic(panicMsg);
    } else {
        emitThrowNamed(exceptionClass);
    }
}

llvm::Value* CodeGenerator::Impl::fpToInt(llvm::Value* v, llvm::Type* intTy, bool uns) {
    return builder.CreateIntrinsic(
        uns ? llvm::Intrinsic::fptoui_sat : llvm::Intrinsic::fptosi_sat,
        {intTy, v->getType()}, {v});
}

llvm::Value* CodeGenerator::Impl::emitCast(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw) {
    if (v == nullptr) {
        return v;
    }
    // A newtype shares its underlying's representation: cast by the underlying type (spec 24).
    const std::string from = repType(fromRaw);
    const std::string to = repType(toRaw);
    // Unbox: cast<primitive>(Object) reads the boxed value (spec 3.4). Must precede the
    // pointer<->int reinterpret below, which would otherwise treat the box pointer as an address.
    if (from == "Object" && isBoxablePrimitive(to) && v->getType()->isPointerTy()) {
        return emitUnbox(v, to);
    }
    // A java-style enum value casting to an integer asks for its ORDINAL (spec 12.5), not its
    // pointer bits -- the same recovery interpolation and comparisons already use. Before this
    // branch existed, the generic pointer<->int reinterpret below truncated the singleton's
    // ADDRESS, a value that means nothing (the relayout's RL-3 finding).
    if (javaEnums.count(baseType(from)) > 0 && v->getType()->isPointerTy() && isIntName(to)) {
        return emitCast(emitJavaEnumOrdinal(v, baseType(from)), "int", toRaw);
    }
    // Decimal conversions (spec 34): scale by 10^18 on the way in, descale on the way out. The
    // double paths are lossy (double keeps ~15-16 digits); int<->Decimal is exact.
    if (to == "Decimal" && from != "Decimal") {
        if (isFloatType(from)) {
            llvm::Value* d = v->getType()->isDoubleTy()
                                 ? v
                                 : builder.CreateFPExt(v, builder.getDoubleTy());
            llvm::Value* scaled =
                builder.CreateFMul(d, llvm::ConstantFP::get(builder.getDoubleTy(), 1e18));
            return fpToInt(scaled, builder.getInt128Ty(), /*uns=*/false);  // saturating: no fptosi UB
        }
        return builder.CreateMul(builder.CreateSExt(v, builder.getInt128Ty()), decimalScale());
    }
    if (from == "Decimal" && to != "Decimal") {
        if (isFloatType(to)) {
            llvm::Value* d = builder.CreateFDiv(
                builder.CreateSIToFP(v, builder.getDoubleTy()),
                llvm::ConstantFP::get(builder.getDoubleTy(), 1e18));
            return isF32(to) ? builder.CreateFPTrunc(d, builder.getFloatTy()) : d;
        }
        return builder.CreateTrunc(builder.CreateSDiv(v, decimalScale()), llvmType(to));
    }
    // Reference cast (class/Object/reflection token): a pointer reinterpret -- a no-op with opaque
    // pointers. A class DOWNCAST is checked at runtime (spec 6.3): if the object is non-null and not
    // actually the target type, throw ClassCastException instead of silently corrupting memory
    // (no-UB). Upcasts, identity and non-class reinterprets pass through unchecked.
    if (llvmType(to)->isPointerTy() && v->getType()->isPointerTy()) {
        const std::string bf = baseType(from), bt = baseType(to);
        if (classes.count(bf) > 0 && classes.count(bt) > 0 && bf != bt &&
            classIsSubtypeOf(bt, bf) && classes[bt].vtable != nullptr) {
            llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
            llvm::Value* notNull = builder.CreateICmpNE(v, nullp, "cast.nn");
            llvm::Value* bad = builder.CreateAnd(notNull, builder.CreateNot(emitIsa(v, bt)));
            llvm::Function* fn = currentFn;
            auto* badBB = llvm::BasicBlock::Create(context, "cast.bad", fn);
            auto* okBB = llvm::BasicBlock::Create(context, "cast.ok", fn);
            builder.CreateCondBr(bad, badBB, okBB);
            builder.SetInsertPoint(badBB);
            // A bad downcast is a hard error either way; only the REPORTING mechanism differs.
            // Freestanding has no exceptions (spec 36.3), so -- exactly like the div-by-zero,
            // overflow and bounds guards -- it terminates through `__polaron_panic` instead. Without
            // this, any checked downcast in a kernel dragged in the whole Itanium EH runtime
            // (`__cxa_allocate_exception`, `typeinfo for void*`) and failed to link.
            if (program.isFreestanding) {
                emitPanic("bad cast to " + bt);
            } else {
                emitThrowNamed("ClassCastException");  // terminates this block (throw)
            }
            builder.SetInsertPoint(okBB);
        }
        return v;
    }
    // Raw int/address <-> pointer (low-level / freestanding, spec 17.8): a `cast<T*>(addr)`
    // or `cast<address>(ptr)` reinterprets between an integer address and a pointer.
    if (llvmType(to)->isPointerTy() && v->getType()->isIntegerTy()) {
        return builder.CreateIntToPtr(v, llvmType(to));
    }
    if (llvmType(to)->isIntegerTy() && v->getType()->isPointerTy()) {
        return builder.CreatePtrToInt(v, llvmType(to));
    }
    const bool toFloat = isFloatType(to);
    const bool fromFloat = isFloatType(from);
    if (toFloat) {
        llvm::Type* fty = llvmType(to);
        if (fromFloat) {
            if (v->getType() == fty) {
                return v;
            }
            return fty->getPrimitiveSizeInBits() > v->getType()->getPrimitiveSizeInBits()
                       ? builder.CreateFPExt(v, fty)
                       : builder.CreateFPTrunc(v, fty);
        }
        return isUnsigned(from) ? builder.CreateUIToFP(v, fty)
                                : builder.CreateSIToFP(v, fty);
    }
    if (fromFloat) {
        return fpToInt(v, llvmType(to), isUnsigned(to));  // saturating, defined
    }
    return fitInt(v, intBits(to), isUnsigned(from));  // int -> int: zext/sext / trunc
}

llvm::Value* CodeGenerator::Impl::coerceToType(llvm::Value* v, llvm::Type* ty) {
    if (v == nullptr || ty == nullptr || v->getType() == ty) {
        return v;
    }
    llvm::Type* src = v->getType();
    if (ty->isFloatingPointTy()) {
        if (src->isIntegerTy()) {
            return builder.CreateSIToFP(v, ty);  // int -> f32/f64
        }
        if (src->isFloatingPointTy()) {
            return ty->getPrimitiveSizeInBits() > src->getPrimitiveSizeInBits()
                       ? builder.CreateFPExt(v, ty)     // widen
                       : builder.CreateFPTrunc(v, ty);  // narrow
        }
        return v;
    }
    if (ty->isIntegerTy()) {
        if (src->isIntegerTy()) {
            const unsigned want = ty->getIntegerBitWidth();
            const unsigned have = src->getIntegerBitWidth();
            if (want > have) {
                return builder.CreateSExt(v, ty);
            }
            if (want < have) {
                return builder.CreateTrunc(v, ty);
            }
            return v;
        }
        if (src->isFloatingPointTy()) {
            return fpToInt(v, ty, false);  // f -> int, saturating
        }
    }
    return v;
}

std::string CodeGenerator::Impl::clsKey(const std::string& t) const {
    if (classes.count(t) > 0) {
        return t;
    }
    return baseType(t);
}

bool CodeGenerator::Impl::isBitFieldMember(const std::string& className, const std::string& field) const {
    auto cit = classes.find(clsKey(className));
    return cit != classes.end() && cit->second.bitFieldUnitBits.count(field) > 0;
}

std::string CodeGenerator::Impl::bitFieldOwner(const ast::MemberExpr& mem) {
    const std::string cn = clsKey(typeName(*mem.object));
    return isBitFieldMember(cn, mem.member) ? cn : std::string();
}

bool CodeGenerator::Impl::isVolatileAccess(const ast::Expr& expr) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        auto it = locals.find(id->name);
        return it != locals.end() && it->second.isVolatile;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        // An object that lives in a `volatile region` (MMIO): every field access is volatile.
        if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (volatileObjects_.count(oid->name) > 0) {
                return true;
            }
        }
        auto cit = classes.find(clsKey(typeName(*mem->object)));
        return cit != classes.end() && cit->second.volatileFields.count(mem->member) > 0;
    }
    // Access THROUGH a volatile pointer (MMIO): `p[i]` is a volatile load/store whenever `p` itself is
    // a volatile lvalue. A `volatile` raw pointer names hardware (a device register, video memory), so
    // the access must not be reordered, fused, or elided. Recurse into the base pointer expression --
    // this reaches a `volatile` local, a `volatile` field, or an anonymous `cast<volatile T*>(...)`.
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        return isVolatileAccess(*ix->array);
    }
    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        return cst->targetVolatile;  // cast<volatile T*>(addr) -- an MMIO pointer even without a name
    }
    return false;
}

const ast::Expr* CodeGenerator::Impl::lazyFieldInitOf(const std::string& className, const std::string& field) {
    for (std::string cur = clsKey(className); !cur.empty();) {
        auto cit = classes.find(cur);
        if (cit == classes.end()) {
            break;
        }
        auto it = cit->second.lazyFieldInit.find(field);
        if (it != cit->second.lazyFieldInit.end()) {
            return it->second;
        }
        cur = cit->second.superclass;
    }
    return nullptr;
}

void CodeGenerator::Impl::freeStringFields(llvm::Value* objPtr, const std::string& cn) {
    auto cit = classes.find(cn);
    if (cit == classes.end()) {
        return;
    }
    const ClassLayout& cl = cit->second;
    if (cl.isUnion || cl.type == nullptr || cl.imported) {
        return;
    }
    for (const auto& [fname, ftype] : cl.fieldType) {
        if (ftype != "String" && ftype != "string") {
            continue;  // both own their buffer (spec 4)
        }
        if (cl.externalFields.count(fname) > 0) {
            continue;
        }
        auto idxIt = cl.fieldIndex.find(fname);
        if (idxIt == cl.fieldIndex.end()) {
            continue;
        }
        llvm::Value* slot =
            builder.CreateStructGEP(cl.type, objPtr, idxIt->second, fname + ".sfree");
        builder.CreateCall(strFreeFn(), {builder.CreateLoad(builder.getPtrTy(), slot)});
    }
}

void CodeGenerator::Impl::emitDeleteObject(llvm::Value* objPtr, const std::string& cn) {
    // No-UB double-delete guard: a freed pool block's field 0 (the vtable slot) has been overwritten
    // by the free-list link, so the destructor lookup below would call through garbage. Panic first
    // if the block is already freed (live/foreign pointers pass through untouched).
    builder.CreateCall(checkLiveFn(), {objPtr});
    // Regions this object OWNS go with it -- see `emitOwnedRegionFieldRelease`. Done up front
    // because everything below may free the object's storage, and the field holding the region's
    // block has to still be readable.
    emitOwnedRegionFieldRelease(objPtr, cn);
    auto cit = classes.find(cn);
    if (cit != classes.end() && cit->second.hasVtable) {
        llvm::Value* vtblField = builder.CreateStructGEP(cit->second.type, objPtr, 0, "vtbl.addr");
        llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
        const std::uint64_t dtorIdx = methodSlotNames.size();  // trailing slot
        llvm::Type* vtArrTy = llvm::ArrayType::get(builder.getPtrTy(), dtorIdx + 1);
        llvm::Value* slotPtr = builder.CreateConstGEP2_64(vtArrTy, vtbl, 0, dtorIdx, "dtor.slot");
        llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "dtor.fn");
        llvm::Function* fn = currentFn;
        llvm::BasicBlock* callBB = llvm::BasicBlock::Create(context, "dtor.call", fn);
        llvm::BasicBlock* freeBB = llvm::BasicBlock::Create(context, "dtor.free", fn);
        builder.CreateCondBr(
            builder.CreateICmpNE(fnPtr, llvm::ConstantPointerNull::get(builder.getPtrTy())),
            callBB, freeBB);
        builder.SetInsertPoint(callBB);
        llvm::FunctionType* dtorTy =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        builder.CreateCall(dtorTy, fnPtr, {objPtr});
        builder.CreateBr(freeBB);
        builder.SetInsertPoint(freeBB);
        emitWeakCleanup(objPtr, cn);
        freeStringFields(objPtr, cn);
        builder.CreateCall(freeFn(), {objPtr});
        return;
    }
    if (cit != classes.end() && cit->second.hasDestructor) {
        builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
    }
    emitWeakCleanup(objPtr, cn);
    freeStringFields(objPtr, cn);
    builder.CreateCall(freeFn(), {objPtr});
}

std::string CodeGenerator::Impl::ownedHeapNewArg(const ast::Expr& argExpr, const std::string& paramType) {
    const auto* nw = dynamic_cast<const ast::NewExpr*>(&argExpr);
    if (nw == nullptr || nw->location != "heap" || !nw->region.empty()) {
        return "";
    }
    if (!isClassValue(paramType) || !isCopyDiscipline(paramType)) {
        return "";
    }
    return ast::mangleGeneric(nw->className, nw->typeArgs);
}

llvm::Value* CodeGenerator::Impl::emitMethodPatch(const std::string& cls, const ast::CallExpr& call) {
    const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(call.args[0].get());
    auto cit = classes.find(cls);
    if (lit == nullptr || cit == classes.end()) {
        return nullptr;
    }
    const std::string& mname = lit->value;
    auto sit = methodSlots.find(mname);
    const std::string impl = vtableImpl(cls, mname);
    auto fit = functions.find(impl);
    if (sit == methodSlots.end() || impl.empty() || fit == functions.end()) {
        error("cannot replace '" + cls + "." + mname + "': it has no dispatch slot", call.loc);
        return nullptr;
    }
    llvm::FunctionType* mty = fit->second->getFunctionType();  // (ptr this, args...) -> R

    // The global the closure lives in, and the thunk that reads it.
    const int id = patchCounter_++;
    const std::string tag = cls + "." + mname + ".patch" + std::to_string(id);
    auto* slotGV = new llvm::GlobalVariable(
        module, builder.getPtrTy(), /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
        llvm::ConstantPointerNull::get(builder.getPtrTy()), tag + ".fn");
    llvm::Function* thunk = llvm::Function::Create(mty, llvm::Function::InternalLinkage,
                                                   tag + ".thunk", module);
    {
        auto sIP = builder.saveIP();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", thunk));
        llvm::Value* clos = builder.CreateLoad(builder.getPtrTy(), slotGV, "patch.clos");
        llvm::Value* code = builder.CreateLoad(builder.getPtrTy(), clos, "patch.code");
        llvm::Value* envP = builder.CreateConstGEP1_64(builder.getPtrTy(), clos, 1, "patch.env.addr");
        llvm::Value* env = builder.CreateLoad(builder.getPtrTy(), envP, "patch.env");
        std::vector<llvm::Type*> pts = {builder.getPtrTy()};  // arg 0: the closure environment
        std::vector<llvm::Value*> args = {env};
        for (auto& a : thunk->args()) {
            pts.push_back(a.getType());
            args.push_back(&a);
        }
        llvm::FunctionType* cty = llvm::FunctionType::get(mty->getReturnType(), pts, false);
        llvm::Value* r = builder.CreateCall(cty, code, args);
        if (mty->getReturnType()->isVoidTy()) {
            builder.CreateRetVoid();
        } else {
            builder.CreateRet(r);
        }
        builder.restoreIP(sIP);
    }

    // The patch itself: store the closure, then point the vtable slot at the thunk -- in this class
    // and in every subclass that INHERITS the same implementation. A Poodle is a Dog, so replacing
    // Dog.bark must reach the Poodles too; a subclass that overrides bark has its own behaviour and
    // is deliberately left alone.
    llvm::Value* fnVal = emitExpr(*call.args[1]);
    if (fnVal == nullptr) {
        return nullptr;
    }
    builder.CreateStore(fnVal, slotGV);
    for (auto& [cname, cl] : classes) {
        if (cl.vtable == nullptr) {
            continue;  // abstract/interface/imported: no table
        }
        if (cname != cls && !derivesFrom(cname, cls)) {
            continue;
        }
        if (vtableImpl(cname, mname) != impl) {
            continue;  // it overrides the method: keep its own
        }
        llvm::ArrayType* vtType =
            llvm::ArrayType::get(builder.getPtrTy(), cl.vtslots.size() + 1);
        llvm::Value* slotPtr = builder.CreateConstGEP2_64(
            vtType, cl.vtable, 0, static_cast<unsigned>(sit->second), "vt.slot");
        builder.CreateStore(thunk, slotPtr);
    }
    return nullptr;  // a statement, not a value
}

bool CodeGenerator::Impl::derivesFrom(const std::string& sub, const std::string& base) {
    for (auto it = classes.find(sub); it != classes.end() && !it->second.superclass.empty();
         it = classes.find(it->second.superclass)) {
        if (it->second.superclass == base) {
            return true;
        }
    }
    return false;
}

bool CodeGenerator::Impl::isLazyImport(const std::string& cn) {
    auto match = [&](const ast::ImportDecl& imp) {
        return imp.isLazy && !imp.path.empty() && imp.path.back() == cn;
    };
    for (const ast::ImportDecl& imp : program.imports) {
        if (match(imp)) {
            return true;
        }
    }
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::ImportDecl& imp : b.imports) {
            if (match(imp)) {
                return true;
            }
        }
    }
    return false;
}

llvm::GlobalVariable* CodeGenerator::Impl::lazyLoadFlag(const std::string& cn) {
    auto it = lazyLoadFlags_.find(cn);
    if (it != lazyLoadFlags_.end()) {
        return it->second;
    }
    auto* g = new llvm::GlobalVariable(module, builder.getInt1Ty(), /*isConstant=*/false,
                                       llvm::GlobalValue::PrivateLinkage, builder.getInt1(false),
                                       "loaded." + cn);
    lazyLoadFlags_[cn] = g;
    return g;
}

bool CodeGenerator::Impl::cascadeIsForest(const std::string& cn, const ast::CascadeParams& params) {
    std::unordered_set<std::string> seen;
    return cascadeIsForest(cn, params, seen);
}

void CodeGenerator::Impl::emitCascadePrintln(llvm::Value* objPtr, const std::string& cn) {
    const ast::MethodDecl* m = findMethodDecl(cn, "describe");
    if (m == nullptr) {
        return;  // no describe(): the analyzer already reported it
    }
    llvm::FunctionType* fty = methodFnType(m);
    auto cit = classes.find(cn);
    if (cit != classes.end() && cit->second.hasVtable) {
        const int slot = slotIndex(cn, "describe");
        if (slot >= 0) {
            llvm::Value* vtblField =
                builder.CreateStructGEP(cit->second.type, objPtr, 0, "vtbl.addr");
            llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
            llvm::Type* vtArrTy =
                llvm::ArrayType::get(builder.getPtrTy(), cit->second.vtslots.size());
            llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "slot");
            llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "fn");
            builder.CreateCall(fty, fnPtr, {objPtr});
            return;
        }
    }
    const std::string owner = methodOwner(cn, "describe");
    if (auto fnit = functions.find(owner + ".describe"); !owner.empty() && fnit != functions.end()) {
        builder.CreateCall(fnit->second, {objPtr});
    }
}

const std::vector<const ast::Expr*>& CodeGenerator::Impl::classInvariants(const std::string& clsName) {
    auto it = mergedInvariants_.find(clsName);
    if (it != mergedInvariants_.end()) {
        return it->second;
    }
    std::vector<const ast::Expr*> merged;
    for (std::string cur = clsName; !cur.empty();) {
        auto cc = classes.find(cur);
        if (cc == classes.end()) {
            break;
        }
        if (cc->second.decl != nullptr) {
            for (const ast::ExprPtr& inv : cc->second.decl->invariants) {
                merged.push_back(inv.get());
            }
        }
        cur = cc->second.superclass;
    }
    return mergedInvariants_[clsName] = std::move(merged);
}

void CodeGenerator::Impl::emitCascadeValidate(llvm::Value* objPtr, const std::string& cn) {
    llvm::Value* savedThis = currentThis;
    const std::string savedClass = currentClass;
    currentThis = objPtr;
    currentClass = cn;
    for (std::string cur = cn; !cur.empty();) {
        auto cc = classes.find(cur);
        if (cc == classes.end()) {
            break;
        }
        if (cc->second.decl != nullptr) {
            for (const ast::ExprPtr& inv : cc->second.decl->invariants) {
                emitContractCheck(*inv, "invariant");
            }
        }
        cur = cc->second.superclass;
    }
    currentThis = savedThis;
    currentClass = savedClass;
}

llvm::Function* CodeGenerator::Impl::cloneHelper(int csid, const std::string& cn, const ast::CascadeParams& params) {
    const std::string key = std::to_string(csid) + "|" + cn;
    if (auto it = cloneFns_.find(key); it != cloneFns_.end()) {
        return it->second;
    }

    llvm::FunctionType* fty = llvm::FunctionType::get(
        builder.getPtrTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt32Ty()},
        false);
    llvm::Function* fn = llvm::Function::Create(
        fty, llvm::Function::InternalLinkage, "__cascade.clone." + std::to_string(csid) + "." + cn,
        module);
    cloneFns_[key] = fn;  // memoize before the body so recursive/cyclic types resolve

    const llvm::IRBuilderBase::InsertPoint savedIP = builder.saveIP();
    llvm::Function* savedFn = currentFn;
    currentFn = fn;
    llvm::Argument* srcArg = fn->getArg(0);
    llvm::Argument* mapArg = fn->getArg(1);
    llvm::Argument* depthArg = fn->getArg(2);
    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());

    llvm::BasicBlock* entry = llvm::BasicBlock::Create(context, "entry", fn);
    llvm::BasicBlock* liveBB = llvm::BasicBlock::Create(context, "live", fn);
    llvm::BasicBlock* nullBB = llvm::BasicBlock::Create(context, "nullret", fn);
    builder.SetInsertPoint(entry);
    builder.CreateCondBr(builder.CreateICmpNE(srcArg, nullp), liveBB, nullBB);
    builder.SetInsertPoint(nullBB);
    builder.CreateRet(nullp);  // clone of null is null

    builder.SetInsertPoint(liveBB);
    llvm::Value* existing = builder.CreateCall(ptrmapGetFn(), {mapArg, srcArg});
    llvm::BasicBlock* existBB = llvm::BasicBlock::Create(context, "existret", fn);
    llvm::BasicBlock* freshBB = llvm::BasicBlock::Create(context, "fresh", fn);
    builder.CreateCondBr(builder.CreateICmpNE(existing, nullp), existBB, freshBB);
    builder.SetInsertPoint(existBB);
    builder.CreateRet(existing);  // already cloned (shared / cycle)

    builder.SetInsertPoint(freshBB);
    auto cit = classes.find(cn);
    if (cit == classes.end()) {
        builder.CreateRet(srcArg);  // not a class: share the original
        currentFn = savedFn;
        builder.restoreIP(savedIP);
        return fn;
    }
    llvm::Value* size = sizeOf(cit->second.type);
    llvm::Value* dst = builder.CreateCall(mallocFn(), {size});
    emitMemcpy(dst, srcArg, size);       // shallow copy
    builder.CreateCall(ptrmapPutFn(), {mapArg, srcArg, dst});  // register before recursing

    llvm::BasicBlock* recBB = llvm::BasicBlock::Create(context, "recurse", fn);
    llvm::BasicBlock* afterBB = llvm::BasicBlock::Create(context, "after", fn);
    builder.CreateCondBr(builder.CreateICmpNE(depthArg, builder.getInt32(0)), recBB, afterBB);
    builder.SetInsertPoint(recBB);
    llvm::Value* unlimited = builder.CreateICmpSLT(depthArg, builder.getInt32(0));
    llvm::Value* nextDepth = builder.CreateSelect(
        unlimited, depthArg, builder.CreateSub(depthArg, builder.getInt32(1)));
    std::unordered_set<std::string> seen;
    for (std::string cur = cn; !cur.empty();) {
        auto cc = classes.find(cur);
        if (cc == classes.end()) {
            break;
        }
        for (const auto& [fname, ftype] : cc->second.ownFields) {
            if (!seen.insert(fname).second) {
                continue;
            }
            if (ftype.find('&') != std::string::npos || isArrayType(ftype)) {
                continue;
            }
            const bool isPtr = ftype.find('*') != std::string::npos;
            if (isPtr && cc->second.externalFields.count(fname) > 0) {
                continue;  // association
            }
            const std::string fcn = baseType(ftype);
            if (classes.find(fcn) == classes.end()) {
                continue;
            }
            if (!params.onlyTypes.empty() && std::find(params.onlyTypes.begin(), params.onlyTypes.end(),
                                                       fcn) == params.onlyTypes.end()) {
                continue;
            }
            if (std::find(params.exceptTypes.begin(), params.exceptTypes.end(), fcn) !=
                params.exceptTypes.end()) {
                continue;
            }
            auto idxIt = cit->second.fieldIndex.find(fname);
            if (idxIt == cit->second.fieldIndex.end()) {
                continue;
            }
            llvm::Value* childSrc = builder.CreateLoad(
                builder.getPtrTy(),
                builder.CreateStructGEP(cit->second.type, srcArg, idxIt->second, fname), fname);
            llvm::Value* childClone =
                builder.CreateCall(cloneHelper(csid, fcn, params), {childSrc, mapArg, nextDepth});
            builder.CreateStore(
                childClone,
                builder.CreateStructGEP(cit->second.type, dst, idxIt->second, fname));
        }
        cur = cc->second.superclass;
    }
    builder.CreateBr(afterBB);
    builder.SetInsertPoint(afterBB);
    builder.CreateRet(dst);

    currentFn = savedFn;
    builder.restoreIP(savedIP);
    return fn;
}

std::string CodeGenerator::Impl::flattenCallee(const ast::Expr& expr) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        return id->name;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string base = flattenCallee(*mem->object);
        if (base.empty()) {
            return "";
        }
        return base + "." + mem->member;
    }
    return "";
}

std::string CodeGenerator::Impl::methodOwner(const std::string& className, const std::string& method) {
    std::string cn = clsKey(className);  // exact generic instance first, else see through T* / T&
    while (!cn.empty()) {
        auto it = classes.find(cn);
        if (it == classes.end()) {
            break;
        }
        if (it->second.methodReturnType.count(method) > 0) {
            return cn;
        }
        cn = it->second.superclass;
    }
    return "";
}

std::string CodeGenerator::Impl::propertySetterName(const std::string& className, const std::string& member) {
    std::string c = clsKey(className);
    while (!c.empty()) {
        auto it = classes.find(c);
        if (it == classes.end()) {
            break;
        }
        auto sit = it->second.propertySetters.find(member);
        if (sit != it->second.propertySetters.end()) {
            return sit->second;
        }
        c = it->second.superclass;
    }
    return "";
}

std::vector<std::pair<std::string, std::string>> CodeGenerator::Impl::collectFields(const std::string& className) {
    std::vector<std::pair<std::string, std::string>> result;
    auto it = classes.find(className);
    if (it == classes.end()) {
        return result;
    }
    if (!it->second.superclass.empty()) {
        result = collectFields(it->second.superclass);
    }
    const ClassLayout& l = it->second;
    if (l.fieldAffinity.empty()) {
        for (const auto& f : l.ownFields) {
            result.push_back(f);
        }
    } else {
        for (const char* group : {"hot", "", "cold"}) {
            for (const auto& f : l.ownFields) {
                auto a = l.fieldAffinity.find(f.first);
                const std::string aff = a == l.fieldAffinity.end() ? std::string() : a->second;
                if (aff == group) {
                    result.push_back(f);
                }
            }
        }
    }
    orderForLayout(l, result);
    return result;
}

void CodeGenerator::Impl::collectVirtualNames(const std::string& className, std::vector<std::string>& out) {
    auto it = classes.find(className);
    if (it == classes.end()) {
        return;
    }
    const ClassLayout& l = it->second;
    if (!l.superclass.empty()) {
        collectVirtualNames(l.superclass, out);
    }
    for (const std::string& iface : l.interfaces) {
        collectVirtualNames(iface, out);
    }
    if (l.decl != nullptr) {
        for (const ast::MemberPtr& member : l.decl->members) {
            const auto* md = dynamic_cast<const ast::MethodDecl*>(member.get());
            if (md == nullptr || md->isStatic) {
                continue;
            }
            if (std::find(out.begin(), out.end(), md->name) == out.end()) {
                out.push_back(md->name);
            }
        }
    }
}

std::vector<std::string> CodeGenerator::Impl::computeSlots(const std::string& className) {
    std::vector<std::string> own;
    collectVirtualNames(className, own);
    std::vector<std::string> slots(methodSlotNames.size());
    for (const std::string& name : own) {
        auto sit = methodSlots.find(name);
        if (sit != methodSlots.end()) {
            slots[sit->second] = name;
        }
    }
    return slots;
}

std::string CodeGenerator::Impl::vtableImpl(const std::string& className, const std::string& method) {
    std::string c = className;
    while (!c.empty()) {
        auto it = classes.find(c);
        if (it == classes.end()) {
            break;
        }
        auto mit = it->second.ownMethods.find(method);
        if (mit != it->second.ownMethods.end() && !mit->second->isAbstract) {
            return c + "." + method;
        }
        c = it->second.superclass;
    }
    // No class in the chain provides it: fall back to an interface default method (spec 9).
    return interfaceDefaultImpl(className, method);
}

std::string CodeGenerator::Impl::interfaceDefaultImpl(const std::string& className, const std::string& method) {
    for (std::string c = className; !c.empty();) {
        auto it = classes.find(c);
        if (it == classes.end()) {
            break;
        }
        for (const std::string& iface : it->second.interfaces) {
            auto iit = classes.find(iface);
            if (iit == classes.end()) {
                continue;
            }
            auto mit = iit->second.ownMethods.find(method);
            if (mit != iit->second.ownMethods.end() && !mit->second->isAbstract) {
                return iface + "." + method;
            }
            std::string deeper = interfaceDefaultImpl(iface, method);  // interface extends interface
            if (!deeper.empty()) {
                return deeper;
            }
        }
        c = it->second.superclass;
    }
    return "";
}

std::string CodeGenerator::Impl::dtorImpl(const std::string& className) {
    std::string c = className;
    while (!c.empty()) {
        auto it = classes.find(c);
        if (it == classes.end()) {
            break;
        }
        if (it->second.hasDestructor) {
            return c + ".~" + c;
        }
        c = it->second.superclass;
    }
    return "";
}

const ast::MethodDecl* CodeGenerator::Impl::findMethodDecl(const std::string& className, const std::string& method) {
    std::string c = className;
    while (!c.empty()) {
        auto it = classes.find(c);
        if (it == classes.end()) {
            break;
        }
        auto mit = it->second.ownMethods.find(method);
        if (mit != it->second.ownMethods.end()) {
            return mit->second;
        }
        for (const std::string& iface : it->second.interfaces) {
            const ast::MethodDecl* m = findMethodDecl(iface, method);
            if (m != nullptr) {
                return m;
            }
        }
        c = it->second.superclass;
    }
    // Every object is-a Object, so Object's universal methods (equals/hashCode/equalsKey/...) resolve
    // on any receiver, including an interface-typed one (which has no superclass chain to Object).
    // Mirrors the analyzer's findMethod fallback so dispatch agrees with type checking.
    if (baseType(className) != "Object") {
        if (auto it = classes.find("Object"); it != classes.end()) {
            auto mit = it->second.ownMethods.find(method);
            if (mit != it->second.ownMethods.end()) {
                return mit->second;
            }
        }
    }
    return nullptr;
}

int CodeGenerator::Impl::slotIndex(const std::string& staticType, const std::string& method) {
    (void)staticType;
    auto it = methodSlots.find(method);
    return it == methodSlots.end() ? -1 : it->second;
}

bool CodeGenerator::Impl::returnsValueStruct(const std::string& rt) {
    if (rt.find('*') != std::string::npos) {
        return false;  // a pointer is not a value struct
    }
    auto it = classes.find(clsKey(rt));
    return it != classes.end() && it->second.isStruct;
}

llvm::FunctionType* CodeGenerator::Impl::methodFnType(const ast::MethodDecl* m) {
    std::vector<llvm::Type*> ptypes;
    ptypes.push_back(builder.getPtrTy());  // this
    for (const auto& p : m->params) {
        ptypes.push_back(llvmType(typeRefName(p.type)));
    }
    const std::string rt = typeRefName(m->returnType);
    if (returnsValueStruct(rt)) {
        ptypes.push_back(builder.getPtrTy());  // sret result slot (trailing)
        return llvm::FunctionType::get(builder.getVoidTy(), ptypes, false);
    }
    return llvm::FunctionType::get(llvmType(rt), ptypes, false);
}

std::string CodeGenerator::Impl::ternaryType(const ast::TernaryExpr& t) {
    const std::string a = typeName(*t.thenExpr);
    const std::string b = typeName(*t.elseExpr);
    if (a == b || b.empty()) {
        return a;
    }
    if (a.empty()) {
        return b;
    }
    // Nullability is contagious: if either arm can be absent, so can the result. A `null` literal arm
    // contributes only its nullability, never its (absent) type.
    if (ast::typeIsNullable(a) || ast::typeIsNullable(b) || a == "null" || b == "null") {
        const std::string ba = ast::stripNullable(a), bb = ast::stripNullable(b);
        if (ba == "null") {
            return ast::makeNullable(bb);
        }
        if (bb == "null") {
            return ast::makeNullable(ba);
        }
        return ast::makeNullable(ba);
    }
    // Integers merge to the WIDER arm, so neither is truncated. Signedness disagreement is the
    // analyzer's to reject (spec: it needs an explicit conversion); by the time we are here the
    // program is valid, so widening is all that is left to do.
    if (isIntName(a) && isIntName(b)) {
        return intBits(a) >= intBits(b) ? a : b;
    }
    // Float beside integer, or a wider float: the float wins, again so nothing is truncated.
    if (a == "double" || b == "double") {
        return "double";
    }
    if (a == "float" || b == "float") {
        return "float";
    }
    return a;
}

llvm::FunctionCallee CodeGenerator::Impl::printf() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, /*isVarArg=*/true);
    return module.getOrInsertFunction("printf", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::scanf() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, /*isVarArg=*/true);
    return module.getOrInsertFunction("scanf", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::exitFn() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt32Ty()}, false);
    return module.getOrInsertFunction("exit", ty);
}

void CodeGenerator::Impl::collectOld(const ast::Expr* e, std::vector<const ast::OldExpr*>& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* o = dynamic_cast<const ast::OldExpr*>(e)) {
        out.push_back(o);
        collectOld(o->inner.get(), out);  // old(... old(x) ...) is odd but harmless
    } else if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        collectOld(b->lhs.get(), out);
        collectOld(b->rhs.get(), out);
    } else if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        collectOld(u->operand.get(), out);
    } else if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) {
        collectOld(t->cond.get(), out);
        collectOld(t->thenExpr.get(), out);
        collectOld(t->elseExpr.get(), out);
    } else if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        collectOld(m->object.get(), out);
    } else if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        collectOld(c->callee.get(), out);
        for (const auto& a : c->args) {
            collectOld(a.get(), out);
        }
    } else if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        collectOld(ix->array.get(), out);
        collectOld(ix->index.get(), out);
    } else if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
        collectOld(ca->operand.get(), out);
    }
}

std::string CodeGenerator::Impl::clauseText(const SourceLocation& loc) const {
    if (!sourceLookup) {
        return "";
    }
    const std::string line = sourceLookup(loc.file, loc.line);
    const std::size_t first = line.find_first_not_of(" \t");
    if (first == std::string::npos) {
        return "";
    }
    const std::size_t last = line.find_last_not_of(" \t\r");
    return line.substr(first, last - first + 1);
}

void CodeGenerator::Impl::emitContractCheck(const ast::Expr& cond, const char* kind) {
    llvm::Value* c = emitExpr(cond);
    if (c == nullptr) {
        return;
    }
    llvm::Value* ok = builder.CreateICmpNE(c, builder.getInt32(0), "contract.ok");
    llvm::Function* fn = builder.GetInsertBlock()->getParent();
    llvm::BasicBlock* failBB = llvm::BasicBlock::Create(context, "contract.fail", fn);
    llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "contract.cont", fn);
    builder.CreateCondBr(ok, contBB, failBB);
    builder.SetInsertPoint(failBB);

    // WHAT BROKE, WHERE, IN WHOSE METHOD, AND WITH WHICH VALUES.
    //
    // This printed `contract violated: requires` and nothing else. In a file with three
    // contracts that is a bisection; across a codebase it is a search. A contract exists
    // precisely to name a disagreement, so one that cannot say WHICH disagreement stops the
    // program and then declines to explain itself -- and it read as far worse than the
    // compile-time diagnostics beside it, which have carried a path, a caret and a code for a
    // long time.
    //
    // The place and the method are already here: the clause carries its own SourceLocation and
    // the LLVM function is the method being emitted. The clause TEXT is read back out of the
    // source. The VALUES are what turn "this was false" into "this was false because 1813 is
    // not 1817", and they are printed whenever the clause is a comparison whose two sides can
    // be read a second time without consequences.
    std::string where = std::string(cond.loc.file);
    if (where.empty()) {
        where = "<prelude>";
    }
    std::string msg = std::string("contract violated: ") + kind + "\n";
    msg += "  --> " + where + ":" + std::to_string(cond.loc.line) + ":" +
           std::to_string(cond.loc.col) + "  in " + fn->getName().str() + "\n";
    const std::string text = clauseText(cond.loc);
    if (!text.empty()) {
        msg += "   |  " + text + "\n";
    }

    std::vector<llvm::Value*> args;
    const auto* cmp = dynamic_cast<const ast::BinaryExpr*>(&cond);
    const bool comparison =
        cmp != nullptr && (cmp->op == "==" || cmp->op == "!=" || cmp->op == "<" ||
                           cmp->op == ">" || cmp->op == "<=" || cmp->op == ">=");
    if (comparison && isPureToReread(cmp->lhs.get()) && isPureToReread(cmp->rhs.get())) {
        llvm::Value* lv = emitExpr(*cmp->lhs);
        llvm::Value* rv = emitExpr(*cmp->rhs);
        if (lv != nullptr && rv != nullptr && lv->getType()->isIntegerTy() &&
            rv->getType()->isIntegerTy()) {
            args.push_back(builder.CreateSExt(lv, builder.getInt64Ty(), "contract.l"));
            args.push_back(builder.CreateSExt(rv, builder.getInt64Ty(), "contract.r"));
        }
    }

    // ONE call for both targets. `__polaron_fail` used to be the hosted path only -- freestanding
    // reported through `__polaron_panic`, which takes a finished string, so the values were the part
    // a kernel did without. They are now formatted bare metal too, by a generated reporter that
    // hands the composed message to that same `__polaron_panic` (src/driver/build.cpp). What differs
    // between the targets is where the message ends up, which was never codegen's business.
    llvm::FunctionType* ft = llvm::FunctionType::get(
        builder.getVoidTy(),
        {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(),
         builder.getInt64Ty(), builder.getInt32Ty()},
        false);
    llvm::Value* zero = builder.getInt64(0);
    llvm::Value* none = llvm::ConstantPointerNull::get(builder.getPtrTy());
    const bool has = !args.empty();
    builder.CreateCall(
        module.getOrInsertFunction("__polaron_fail", ft),
        {createGlobalStringPtr(builder, msg, ".contract"),
         has ? createGlobalStringPtr(builder, "left", ".cl") : none,
         has ? args[0] : zero,
         has ? createGlobalStringPtr(builder, "right", ".cr") : none,
         has ? args[1] : zero, builder.getInt32(1)});
    builder.CreateUnreachable();
    builder.SetInsertPoint(contBB);
}

llvm::FunctionCallee CodeGenerator::Impl::mallocFn() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false);
    llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_malloc", ty);  // pooled (runtime)
    // libc malloc carries `noalias` on its result; the pool also returns fresh non-aliasing memory,
    // and clang needs the attribute to prove distinct arrays don't alias -- without it, it will not
    // vectorize loops like matmul (c[j] += a_ik * b[j]). Restore the attribute the rename dropped.
    if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
        f->addRetAttr(llvm::Attribute::NoAlias);
    }
    return c;
}

llvm::FunctionCallee CodeGenerator::Impl::persistSlotFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getPtrTy(),
        {builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty()}, false);
    return module.getOrInsertFunction("__polaron_persist_slot", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::persistSlotKeyedFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getPtrTy(),
        {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty(),
         builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_persist_slot_keyed", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::persistReleaseKeyedFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getVoidTy(),
        {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty()}, false);
    return module.getOrInsertFunction("__polaron_persist_release_keyed", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::persistReleaseAllFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getVoidTy(),
        {builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty()}, false);
    return module.getOrInsertFunction("__polaron_persist_release_all", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::freeFn() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_free", ty);  // pooled allocator (runtime)
}

// ---- A region class's arena: one reservation, one base, committed as it fills ----
//
// Separate from the flavored-region allocator on purpose. A `growable` region CHAINS blocks, and a
// 32-bit object pointer cannot survive that: two objects at the same offset in different links are
// the same narrow value. These three calls back a region class with one contiguous reservation
// instead, so `base` never moves and an `A*` is an offset from it. See the block comment in
// runtime/polaron_rt.cpp for the measurement that rules malloc out.
llvm::FunctionCallee CodeGenerator::Impl::arenaReserveFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(builder.getPtrTy(), {}, false);
    llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_arena_reserve", ty);
    if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
        f->addRetAttr(llvm::Attribute::NoAlias);
    }
    return c;
}

// Returns the OFFSET, not a pointer -- that is the value a narrow `A*` holds, and having the runtime
// hand it back keeps the two sides from disagreeing about where zero is.
llvm::FunctionCallee CodeGenerator::Impl::arenaAllocFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getInt64Ty(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
    return module.getOrInsertFunction("__polaron_arena_alloc", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::arenaBaseFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
    llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_arena_base", ty);
    if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
        // The base never moves and reads nothing the program can write, so a repeated call folds away
        // -- which matters, because widening a narrow pointer needs it at every field read.
        f->setOnlyReadsMemory();
        f->setDoesNotThrow();
        f->addRetAttr(llvm::Attribute::NoAlias);
    }
    return c;
}

llvm::FunctionCallee CodeGenerator::Impl::arenaFreeFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_arena_free", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::regionAcquireFn() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false);
    llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_region_acquire", ty);
    if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
        f->addRetAttr(llvm::Attribute::NoAlias);
    }
    return c;
}

llvm::FunctionCallee CodeGenerator::Impl::regionReleaseFn() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_region_release", ty);
}

const ast::FieldDecl* CodeGenerator::Impl::regionFieldDecl(const std::string& name) {
    // BOTH SPELLINGS. A region field reaches here as `this.nodes` from some paths and as bare
    // `nodes` from others, and requiring the dot made the bare form resolve to nothing -- which
    // is not an error anywhere, it just silently reports "no flavor", and a
    // `delete X from region R` then falls through to the ORDINARY heap delete. That traps at run
    // time with `delete of a region object`, blaming the user's correct code. Found by moving
    // LinkedList's nodes into a pool region: the library had the right statement all along.
    const auto dot = name.find('.');
    if (currentClass.empty()) {
        return nullptr;
    }
    auto cit = classes.find(currentClass);
    if (cit == classes.end() || cit->second.decl == nullptr) {
        return nullptr;
    }
    const std::string fname = (dot == std::string::npos) ? name : name.substr(dot + 1);
    for (const ast::MemberPtr& m : cit->second.decl->members) {
        if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            if (fd->name == fname) {
                return fd;
            }
        }
    }
    return nullptr;
}

std::string CodeGenerator::Impl::flavorOfRegion(const std::string& name) {
    if (auto it = regionFlavor_.find(name); it != regionFlavor_.end()) {
        return it->second;
    }
    if (const ast::FieldDecl* fd = regionFieldDecl(name)) {
        return fd->regionFlavor;
    }
    return std::string();
}

bool CodeGenerator::Impl::growableOfRegion(const std::string& name) {
    if (growableRegions_.count(name) > 0) {
        return true;
    }
    if (const ast::FieldDecl* fd = regionFieldDecl(name)) {
        return fd->regionGrowable;
    }
    return false;
}

bool CodeGenerator::Impl::regionHasRegistry(const std::string& name) {
    const std::string flavor = flavorOfRegion(name);
    if (isStackFlavor(flavor)) {
        return true;
    }
    if (isRingFlavor(flavor)) {
        return false;
    }
    return isOwnedFieldRegion(name);
}

bool CodeGenerator::Impl::isOwnedFieldRegion(const std::string& name) {
    const auto dot = name.find('.');
    if (dot == std::string::npos || currentClass.empty()) {
        return false;
    }
    return ownedFieldRegions_.count(currentClass + "." + name.substr(dot + 1)) > 0;
}

llvm::Value* CodeGenerator::Impl::sizeOf(llvm::Type* type) {
    llvm::Value* gep = builder.CreateConstGEP1_64(
        type, llvm::ConstantPointerNull::get(builder.getPtrTy()), 1);
    return builder.CreatePtrToInt(gep, builder.getInt64Ty());
}

bool CodeGenerator::Impl::namesAType(const std::string& t) {
    if (t.empty() || t == "void") {
        return false;
    }
    if (ast::typeIsNullable(t)) {
        return namesAType(ast::stripNullable(t));
    }
    if (isArrayType(t)) {
        return namesAType(elementOf(t));
    }
    if (isRefType(t) || isTupleType(t) || isValueVariant(t)) {
        return true;
    }
    if (isFloatType(t) || isIntName(t) || vecWidth(t) != 0) {
        return true;
    }
    if (t == "boolean" || t == "char" || t == "mat4" || t == "region" || t == "checkpoint") {
        return true;
    }
    if (t == "String" || t == "string" || t == "Object" || t == "Decimal") {
        return true;
    }
    if (t == "Type" || t == "Method" || t == "Field" || t == "Annotation") {
        return true;
    }
    if (t.rfind("function<", 0) == 0 || t.rfind("funcptr<", 0) == 0) {
        return true;
    }
    if (classes.count(clsKey(t)) > 0 || classes.count(t) > 0) {
        return true;
    }
    if (enums.count(t) > 0 || newtypes_.count(t) > 0 || isTaggedCatalog(t)) {
        return true;
    }
    return false;
}

bool CodeGenerator::Impl::sizeOfTypeName(const std::string& t, long long& out) {
    if (!namesAType(t)) {
        return false;
    }
    if (auto cit = classes.find(clsKey(t)); cit != classes.end() && cit->second.type != nullptr) {
        out = static_cast<long long>(module.getDataLayout().getTypeAllocSize(cit->second.type));
        return true;
    }
    llvm::Type* lt = llvmType(t);
    if (lt == nullptr || !lt->isSized()) {
        return false;
    }
    out = static_cast<long long>(module.getDataLayout().getTypeAllocSize(lt));
    return true;
}

unsigned CodeGenerator::Impl::alignOfTypeName(const std::string& t) {
    if (!namesAType(t)) {
        return 0;
    }
    if (auto cit = classes.find(clsKey(t)); cit != classes.end() && cit->second.type != nullptr) {
        return cit->second.type->isSized()
                   ? module.getDataLayout().getABITypeAlign(cit->second.type).value()
                   : 0;
    }
    llvm::Type* lt = llvmType(t);
    if (lt == nullptr || !lt->isSized()) {
        return 0;
    }
    return module.getDataLayout().getABITypeAlign(lt).value();
}

bool CodeGenerator::Impl::isFfiByValueStruct(const std::string& t) {
    if (!t.empty() && (t.back() == '*' || t.back() == '&')) {
        return false;
    }
    auto cit = classes.find(clsKey(t));
    return cit != classes.end() && cit->second.isStruct;
}

llvm::Type* CodeGenerator::Impl::ffiStructRegType(const std::string& t) {
    if (!isFfiByValueStruct(t)) {
        return nullptr;
    }
    auto cit = classes.find(clsKey(t));
    if (cit->second.type == nullptr) {
        return nullptr;
    }
    const uint64_t sz = module.getDataLayout().getTypeAllocSize(cit->second.type);
    switch (sz) {
        case 1: return builder.getInt8Ty();
        case 2: return builder.getInt16Ty();
        case 4: return builder.getInt32Ty();
        case 8: return builder.getInt64Ty();
        default: return nullptr;  // 3/5/6/7/>8: not register-passable here
    }
}

// `size_t` IS NOT ALWAYS 64 BITS, and declaring these with a fixed i64 length was wrong on every
// 32-bit target this compiler can emit for.
//
// x86 hid it completely: the extra half of an over-wide argument is simply ignored by the calling
// convention, so a 32-bit x86 image called `memset` with a 64-bit length and worked. WebAssembly does
// not hide it -- a module's function signatures are CHECKED, and wasm-ld resolves the mismatch to a
// stub that traps. The symptom was `new byte[16]()` trapping with `unreachable` inside a browser while
// `new Box() on heap` beside it worked perfectly, and the linker had said so all along in a symbol
// nobody reads: `signature_mismatch:memset`.
//
// The length is therefore the TARGET's index width, taken from the data layout rather than assumed.
// One more reason every target must contribute its layout string (docs/design/porting.md): without one
// this question has no answer.
// FROM THE TRIPLE, NOT FROM THE DATA LAYOUT -- because a target may have no layout.
//
// `setTargetTriple` sets one for x86-64, AArch64, ARM, i686, wasm32 and RISC-V 64 and for nothing
// else, and the note beside it said an unlisted target "keeps the layout clang applies downstream:
// correct, just not visible to our own passes". That stopped being true the moment this function
// existed: a module with no layout answers `getIntPtrType` with LLVM's 64-bit default, so PowerPC,
// MIPS, RISC-V 32, m68k and SH4 -- every one of them 32-bit -- got a `memcpy` length of i64 again.
// The same bug wasm and i686 had, silently reinstated for every target nobody had listed.
//
// The triple always knows. `isArch32Bit` is not an inference about the machine, it is what the target
// string SAYS, and a target whose width the triple cannot name is one this compiler should not be
// emitting for at all.
llvm::Type* CodeGenerator::Impl::sizeTy() {
    const llvm::Triple tt(moduleTripleStr(module));
    if (tt.isArch16Bit()) {
        return builder.getInt16Ty();
    }
    if (tt.isArch32Bit()) {
        return builder.getInt32Ty();
    }
    return builder.getInt64Ty();
}

// THE AUDIT: every C library function this compiler declares, checked against the TARGET, on every
// build, on whatever machine is doing the building.
//
// Four times in one day the same mistake was made and shipped: `memcpy`, `memset`, a third `memcpy`
// call site, and `strlen` -- each declared with a fixed 64-bit length or result, each right on x86-64
// and wrong on every 32-bit target. Two of them were found by WebAssembly (which checks signatures and
// traps), one by i686, one by reading. That is a bad way to find a bug: it needs somebody to own the
// other machine, and it finds the instance rather than the class.
//
// LLVM's own verifier cannot help, because it checks a CALL against its DECLARATION and both were
// wrong together. What was missing is a statement of what these functions actually are, in terms of
// the target -- so here it is, and it runs before the module is handed on.
//
// Only functions whose signature DEPENDS ON THE TARGET are listed. `printf` is variadic and `exit`
// takes an `int` everywhere; neither can be got wrong this way, and a table that lists them invites
// the belief that it is exhaustive about something else.
bool CodeGenerator::Impl::auditLibcSignatures() {
    llvm::Type* const ptr = builder.getPtrTy();
    llvm::Type* const i32 = builder.getInt32Ty();
    llvm::Type* const sz = sizeTy();

    struct Expected {
        const char* name;
        llvm::FunctionType* type;
    };
    const Expected table[] = {
        {"memcpy",  llvm::FunctionType::get(ptr, {ptr, ptr, sz}, false)},
        {"memmove", llvm::FunctionType::get(ptr, {ptr, ptr, sz}, false)},
        {"memset",  llvm::FunctionType::get(ptr, {ptr, i32, sz}, false)},
        {"strlen",  llvm::FunctionType::get(sz, {ptr}, false)},
        {"strcmp",  llvm::FunctionType::get(i32, {ptr, ptr}, false)},
    };

    bool ok = true;
    for (const Expected& e : table) {
        llvm::Function* f = module.getFunction(e.name);
        if (f == nullptr) {
            continue;   // not used by this program
        }
        if (f->getFunctionType() == e.type) {
            continue;
        }
        std::string got;
        llvm::raw_string_ostream gs(got);
        f->getFunctionType()->print(gs);
        std::string want;
        llvm::raw_string_ostream ws(want);
        e.type->print(ws);
        gs.flush();
        ws.flush();
        // An internal error, deliberately: the program is correct and the compiler is not. Saying it
        // here, naming the target, is the difference between this and a trap on somebody's phone.
        error("internal: '" + std::string(e.name) + "' is declared " + got + " but on " +
                  moduleTripleStr(module) + " it is " + want +
                  ". A C library function's signature follows the TARGET -- see Impl::sizeTy",
              SourceLocation{});
        ok = false;
    }
    return ok;
}

llvm::FunctionCallee CodeGenerator::Impl::memsetFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getPtrTy(), {builder.getPtrTy(), builder.getInt32Ty(), sizeTy()}, false);
    return module.getOrInsertFunction("memset", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::memcpyFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getPtrTy(), {builder.getPtrTy(), builder.getPtrTy(), sizeTy()}, false);
    return module.getOrInsertFunction("memcpy", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::ptrsetNewFn() {
    return module.getOrInsertFunction(
        "__polaron_ptrset_new", llvm::FunctionType::get(builder.getPtrTy(), {}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::ptrsetFreeFn() {
    return module.getOrInsertFunction(
        "__polaron_ptrset_free",
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::ptrmapNewFn() {
    return module.getOrInsertFunction(
        "__polaron_ptrmap_new", llvm::FunctionType::get(builder.getPtrTy(), {}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::ptrmapFreeFn() {
    return module.getOrInsertFunction(
        "__polaron_ptrmap_free",
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::ptrmapPutFn() {
    return module.getOrInsertFunction(
        "__polaron_ptrmap_put",
        llvm::FunctionType::get(
            builder.getVoidTy(),
            {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::strcmpFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getInt32Ty(), {builder.getPtrTy(), builder.getPtrTy()}, false);
    return module.getOrInsertFunction("strcmp", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::strEqFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getInt32Ty(), {builder.getPtrTy(), builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_str_eq", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::strHashFn() {
    llvm::FunctionType* ty =
        llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_str_hash_obj", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::itoaFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getInt64Ty(), {builder.getInt64Ty(), builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_itoa", ty);
}

llvm::FunctionCallee CodeGenerator::Impl::ftoaFn() {
    llvm::FunctionType* ty = llvm::FunctionType::get(
        builder.getInt64Ty(), {builder.getDoubleTy(), builder.getPtrTy()}, false);
    return module.getOrInsertFunction("__polaron_ftoa", ty);
}

llvm::Value* CodeGenerator::Impl::emitStringFromParts(llvm::Value* len, llvm::Value* data) {
    llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(stringType())}, "newstr");
    builder.CreateStore(len, builder.CreateStructGEP(stringType(), obj, 0));
    builder.CreateStore(data, builder.CreateStructGEP(stringType(), obj, 1));
    builder.CreateStore(builder.getInt64(0), builder.CreateStructGEP(stringType(), obj, 2));  // hash uncomputed
    return obj;
}

llvm::Value* CodeGenerator::Impl::decimalScale() {
    return llvm::ConstantInt::get(context,
                                  llvm::APInt(128, "1" + std::string(DECIMAL_SCALE, '0'), 10));
}

llvm::Value* CodeGenerator::Impl::emitDecimalToString(llvm::Value* v) {
    llvm::Value* neg = builder.CreateICmpSLT(v, llvm::ConstantInt::get(builder.getInt128Ty(), 0));
    llvm::Value* absV = builder.CreateSelect(neg, builder.CreateNeg(v), v);
    llvm::Value* intPart =
        builder.CreateTrunc(builder.CreateSDiv(absV, decimalScale()), builder.getInt64Ty());
    llvm::Value* frac =
        builder.CreateTrunc(builder.CreateSRem(absV, decimalScale()), builder.getInt64Ty());
    // The 128-bit division is done here; the runtime helper (no __int128, so MSVC can compile it)
    // just assembles the digits and trims trailing fraction zeros into a fresh 64-byte buffer.
    llvm::Value* buf = builder.CreateCall(mallocFn(), {builder.getInt64(64)}, "dbuf");
    llvm::FunctionType* ft = llvm::FunctionType::get(
        builder.getInt64Ty(),
        {builder.getInt32Ty(), builder.getInt64Ty(), builder.getInt64Ty(), builder.getPtrTy()}, false);
    llvm::Value* len = builder.CreateCall(
        module.getOrInsertFunction("__polaron_decimal_str", ft),
        {builder.CreateZExt(neg, builder.getInt32Ty()), intPart, frac, buf});
    return ownedStr(emitStringFromParts(len, buf));
}

llvm::Value* CodeGenerator::Impl::stringLen(llvm::Value* strObj) {
    return builder.CreateLoad(builder.getInt64Ty(),
                              builder.CreateStructGEP(stringType(), strObj, 0, "str.len"), "len");
}

bool CodeGenerator::Impl::isClassValue(const std::string& t) {
    // A Java-style enum value is a reference to a shared singleton (spec 12.2), not a value to
    // be copied -- copying it would break identity (== / !=).
    // An interface- or abstract-typed value is a reference to a concrete object whose real type
    // (and size) is not statically known -- an interface/abstract class cannot be instantiated
    // directly, so the value is always a subclass instance. Deep-copying it by the base's own
    // (often field-less, minimal) size would truncate the object and read past its allocation on
    // a later virtual call. Interfaces and abstract classes are reference types.
    if (auto it = classes.find(t);
        it != classes.end() && (it->second.isInterface || it->second.isAbstract)) {
        return false;
    }
    // String is immutable (spec 4), so a copy is observationally identical to sharing the buffer --
    // skip the copy on assignment and parameter passing. (The mutable `string` still copies.)
    if (baseType(t) == "String") {
        return false;
    }
    return !isRefType(t) && !isArrayType(t) && classes.count(t) > 0 && javaEnums.count(t) == 0;
}

bool CodeGenerator::Impl::isCopyDiscipline(const std::string& t) {
    auto it = classes.find(clsKey(t));
    return it != classes.end() && !it->second.isMovable && !it->second.isUnique;
}

bool CodeGenerator::Impl::isCopyableLValue(const ast::Expr& e) {
    return dynamic_cast<const ast::IdentifierExpr*>(&e) != nullptr ||
           dynamic_cast<const ast::MemberExpr*>(&e) != nullptr ||
           dynamic_cast<const ast::IndexExpr*>(&e) != nullptr;
}

llvm::Value* CodeGenerator::Impl::emitArrayDup(llvm::Value* srcBlock, const std::string& elemType) {
    const long stride = arrayElemBytes(elemType);
    llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), srcBlock, "arr.len");
    llvm::Value* total = builder.CreateAdd(
        builder.getInt64(kArrayHeaderBytes), builder.CreateMul(len, builder.getInt64(stride)));
    llvm::Value* newBlock = builder.CreateCall(mallocFn(), {total}, "arr.copy");
    emitMemcpy(newBlock, srcBlock, total);
    // If the elements are concrete class values (not primitives, and not interface/abstract/enum/
    // String references, which are shared), the memcpy duplicated the element POINTERS but not the
    // objects they point to. Deep-copy each non-null element so the copy owns independent objects,
    // matching the value-copy discipline: assignment is a deep copy (spec 5).
    if (isClassValue(elemType) && isCopyDiscipline(elemType)) {
        llvm::Type* i64 = builder.getInt64Ty();
        auto* head = llvm::BasicBlock::Create(context, "arrdup.head", currentFn);
        auto* body = llvm::BasicBlock::Create(context, "arrdup.body", currentFn);
        auto* copy = llvm::BasicBlock::Create(context, "arrdup.copy", currentFn);
        auto* cont = llvm::BasicBlock::Create(context, "arrdup.cont", currentFn);
        auto* done = llvm::BasicBlock::Create(context, "arrdup.done", currentFn);
        llvm::BasicBlock* pre = builder.GetInsertBlock();
        builder.CreateBr(head);
        builder.SetInsertPoint(head);
        llvm::PHINode* i = builder.CreatePHI(i64, 2, "i");
        i->addIncoming(builder.getInt64(0), pre);
        builder.CreateCondBr(builder.CreateICmpSLT(i, len), body, done);
        builder.SetInsertPoint(body);
        llvm::Value* off = builder.CreateAdd(builder.getInt64(kArrayHeaderBytes), builder.CreateMul(i, builder.getInt64(stride)));
        llvm::Value* slot = builder.CreateGEP(builder.getInt8Ty(), newBlock, off);
        llvm::Value* elem = builder.CreateLoad(builder.getPtrTy(), slot, "elem");
        builder.CreateCondBr(
            builder.CreateICmpEQ(elem, llvm::ConstantPointerNull::get(builder.getPtrTy())), cont, copy);
        builder.SetInsertPoint(copy);
        builder.CreateStore(emitClassCopy(elemType, elem, /*heap=*/true), slot);
        builder.CreateBr(cont);
        builder.SetInsertPoint(cont);
        llvm::Value* next = builder.CreateAdd(i, builder.getInt64(1));
        i->addIncoming(next, cont);
        builder.CreateBr(head);
        builder.SetInsertPoint(done);
    }
    return newBlock;
}

void CodeGenerator::Impl::emitFreeOwnedFields(const std::string& className, llvm::Value* ptr) {
    auto cit = classes.find(className);
    if (cit == classes.end()) {
        return;
    }
    llvm::StructType* st = cit->second.type;
    for (const auto& [fname, ftype] : collectFields(className)) {
        const unsigned idx = cit->second.fieldIndex[fname];
        llvm::Value* slot = builder.CreateStructGEP(st, ptr, idx);
        if (isArrayType(ftype)) {
            builder.CreateCall(freeFn(), {builder.CreateLoad(builder.getPtrTy(), slot)});
        } else if (ftype == "String" || ftype == "string") {
            // Symmetric with emitClassCopy: the copy owns its String/string, so the overwrite releases it.
            builder.CreateCall(strFreeFn(), {builder.CreateLoad(builder.getPtrTy(), slot)});
        } else if (isClassValue(ftype) && isCopyDiscipline(ftype)) {
            llvm::Value* sub = builder.CreateLoad(builder.getPtrTy(), slot);
            llvm::Value* isNull = builder.CreateICmpEQ(
                sub, llvm::ConstantPointerNull::get(builder.getPtrTy()));
            auto* freeBB = llvm::BasicBlock::Create(context, "freefld", currentFn);
            auto* contBB = llvm::BasicBlock::Create(context, "freefld.cont", currentFn);
            builder.CreateCondBr(isNull, contBB, freeBB);
            builder.SetInsertPoint(freeBB);
            emitFreeOwnedFields(ftype, sub);
            builder.CreateCall(freeFn(), {sub});
            builder.CreateBr(contBB);
            builder.SetInsertPoint(contBB);
        }
    }
}

void CodeGenerator::Impl::emitFreeValueStructSlot(llvm::Value* slot, const std::string& type) {
    if (classes.find(type) == classes.end()) {
        return;
    }
    llvm::Value* obj = builder.CreateLoad(builder.getPtrTy(), slot);
    llvm::Value* isNull =
        builder.CreateICmpEQ(obj, llvm::ConstantPointerNull::get(builder.getPtrTy()));
    auto* freeBB = llvm::BasicBlock::Create(context, "freevs", currentFn);
    auto* contBB = llvm::BasicBlock::Create(context, "freevs.cont", currentFn);
    builder.CreateCondBr(isNull, contBB, freeBB);
    builder.SetInsertPoint(freeBB);
    emitFreeOwnedFields(type, obj);
    builder.CreateCall(freeFn(), {obj});
    builder.CreateBr(contBB);
    builder.SetInsertPoint(contBB);
}

llvm::Value* CodeGenerator::Impl::arrayData(llvm::Value* block) {
    return builder.CreateConstGEP1_64(builder.getInt8Ty(), block, kArrayHeaderBytes, "arr.data");
}

llvm::Value* CodeGenerator::Impl::asI1(llvm::Value* v) {
    if (v->getType()->isIntegerTy(1)) {
        return v;
    }
    if (auto* z = llvm::dyn_cast<llvm::ZExtInst>(v)) {
        if (z->getSrcTy()->isIntegerTy(1)) {
            return z->getOperand(0);
        }
    }
    // Null-value form rather than `getInt32(0)`: the same question is asked of pointers and of
    // other widths, and one helper that answers all of them is one place to keep honest.
    return builder.CreateICmpNE(v, llvm::Constant::getNullValue(v->getType()));
}

llvm::StructType* CodeGenerator::Impl::inlineElemStructTy(const std::string& elemType) {
    if (!isFfiByValueStruct(elemType)) {
        return nullptr;  // same predicate: a value struct, not a ref
    }
    auto cit = classes.find(clsKey(elemType));
    if (cit == classes.end() || cit->second.type == nullptr) {
        return nullptr;
    }
    if (!cit->second.type->isSized()) {
        return nullptr;  // body not laid out yet: fall back
    }
    return cit->second.type;
}

unsigned CodeGenerator::Impl::arrayElemBytes(const std::string& elemType) {
    if (elemType == "boolean") {
        return 1u;
    }
    if (llvm::StructType* st = inlineElemStructTy(elemType)) {
        return static_cast<unsigned>(module.getDataLayout().getTypeAllocSize(st));
    }
    return byteSizeOf(elemType);
}

llvm::Type* CodeGenerator::Impl::arrayStorageTy(const std::string& elemType) {
    if (elemType == "boolean") {
        return builder.getInt8Ty();
    }
    if (llvm::StructType* st = inlineElemStructTy(elemType)) {
        return st;
    }
    return llvmType(elemType);
}

void CodeGenerator::Impl::emitFreeOwnedArrayElements(llvm::Value* block, const std::string& elemType) {
    const bool isStr = (elemType == "String");
    llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), block, "ae.len");
    llvm::Value* base = arrayData(block);
    llvm::Value* iSlot = createEntryAlloca("ae.i", builder.getInt64Ty());
    builder.CreateStore(builder.getInt64(0), iSlot);
    llvm::Function* f = currentFn;
    auto* condBB = llvm::BasicBlock::Create(context, "ae.cond", f);
    auto* bodyBB = llvm::BasicBlock::Create(context, "ae.body", f);
    auto* freeBB = llvm::BasicBlock::Create(context, "ae.free", f);
    auto* nextBB = llvm::BasicBlock::Create(context, "ae.next", f);
    auto* endBB = llvm::BasicBlock::Create(context, "ae.end", f);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* i = builder.CreateLoad(builder.getInt64Ty(), iSlot, "ae.iv");
    builder.CreateCondBr(builder.CreateICmpULT(i, len), bodyBB, endBB);
    builder.SetInsertPoint(bodyBB);
    llvm::Value* ep = builder.CreateGEP(builder.getPtrTy(), base, i, "ae.ep");
    llvm::Value* elem = builder.CreateLoad(builder.getPtrTy(), ep, "ae.el");
    builder.CreateCondBr(
        builder.CreateICmpNE(elem, llvm::ConstantPointerNull::get(builder.getPtrTy())), freeBB, nextBB);
    builder.SetInsertPoint(freeBB);
    if (isStr) {
        builder.CreateCall(strFreeFn(), {elem});
    } else {
        emitDeleteObject(elem, clsKey(elemType));
    }
    builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), ep);
    builder.CreateBr(nextBB);
    builder.SetInsertPoint(nextBB);
    builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(endBB);
}

bool CodeGenerator::Impl::arrayOwnsElements(const std::string& elemType) {
    if (elemType == "String") {
        return true;
    }
    if (elemType == "string" || isArrayType(elemType)) {
        return false;
    }
    if (elemType.find('*') != std::string::npos) {
        return false;
    }
    // A Java-style enum array holds shared singletons -- the same constant may sit in many
    // slots -- so its elements are borrowed references, not owned objects. Freeing them on
    // `delete arr` would double-free the singleton the first duplicate slot already freed.
    if (javaEnums.count(baseType(elemType)) > 0 || javaEnums.count(clsKey(elemType)) > 0) {
        return false;
    }
    return classes.count(clsKey(elemType)) > 0 && arrayStorageTy(elemType)->isPointerTy();
}

llvm::Value* CodeGenerator::Impl::emitSaturatingArith(const std::string& m, llvm::Value* a, llvm::Value* b, bool uns) {
    if (m == "saturatingAdd") {
        return builder.CreateBinaryIntrinsic(
            uns ? llvm::Intrinsic::uadd_sat : llvm::Intrinsic::sadd_sat, a, b);
    }
    if (m == "saturatingSub") {
        return builder.CreateBinaryIntrinsic(
            uns ? llvm::Intrinsic::usub_sat : llvm::Intrinsic::ssub_sat, a, b);
    }
    const unsigned bits = a->getType()->getIntegerBitWidth();
    llvm::Value* pair = builder.CreateBinaryIntrinsic(
        uns ? llvm::Intrinsic::umul_with_overflow : llvm::Intrinsic::smul_with_overflow, a, b);
    llvm::Value* res = builder.CreateExtractValue(pair, 0);
    llvm::Value* ovf = builder.CreateExtractValue(pair, 1);
    llvm::Value* clamp;
    if (uns) {
        clamp = llvm::ConstantInt::get(a->getType(), llvm::APInt::getMaxValue(bits));
    } else {  // overflow clamps to MAX when the operands share a sign, MIN otherwise
        llvm::Value* zero = llvm::ConstantInt::get(a->getType(), 0);
        llvm::Value* sameSign = builder.CreateICmpSGE(builder.CreateXor(a, b), zero);
        clamp = builder.CreateSelect(
            sameSign, llvm::ConstantInt::get(a->getType(), llvm::APInt::getSignedMaxValue(bits)),
            llvm::ConstantInt::get(a->getType(), llvm::APInt::getSignedMinValue(bits)));
    }
    return builder.CreateSelect(ovf, clamp, res);
}

llvm::MDNode* CodeGenerator::Impl::coldBranchWeights() {
    llvm::MDBuilder mdb(context);
    return mdb.createBranchWeights(1, 1u << 20);
}

llvm::Value* CodeGenerator::Impl::emitNewArray(const ast::NewArrayExpr& na) {
    llvm::Value* n = emitExpr(*na.size);
    if (n == nullptr) {
        return nullptr;
    }
    llvm::Value* n64 = builder.CreateSExt(n, builder.getInt64Ty());
    const unsigned esz = arrayElemBytes(na.elementType);  // real element width (boolean=1, else 1/2/4/8)
    llvm::Value* elemBytes = builder.CreateMul(n64, builder.getInt64(esz));
    llvm::Value* total = builder.CreateAdd(builder.getInt64(kArrayHeaderBytes), elemBytes);
    // `in region R`: the block comes out of the region's arena, so it dies with the region and needs
    // no `delete`. The layout is identical either way -- [i64 length][elements] -- because where a
    // block came from is not a property the block carries.
    llvm::Value* block = na.region.empty()
                             ? builder.CreateCall(mallocFn(), {total}, "arr")
                             : emitRegionAllocBytes(na.region, total, na.loc);
    if (block == nullptr) {
        return nullptr;
    }
    builder.CreateStore(n64, block);  // length header (element count)
    emitMemset(arrayData(block), builder.getInt32(0), elemBytes);
    return block;
}

llvm::Value* CodeGenerator::Impl::emitArgvArray(llvm::Value* argc, llvm::Value* argv) {
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::Type* p = builder.getPtrTy();
    llvm::Value* n = builder.CreateSub(builder.CreateSExt(argc, i64), builder.getInt64(1));
    n = builder.CreateSelect(builder.CreateICmpSLT(n, builder.getInt64(0)), builder.getInt64(0), n);
    llvm::Value* total =
        builder.CreateAdd(builder.getInt64(kArrayHeaderBytes), builder.CreateMul(n, builder.getInt64(8)));
    llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "argv.arr");
    builder.CreateStore(n, block);
    llvm::Value* data = arrayData(block);
    // `strlen` RETURNS size_t, not i64. Declared as i64 it is the same mistake `memcpy` carried for
    // years: right on this machine, wrong on every 32-bit target, and invisible until one is run.
    // The fourth instance of it found in a day, which is what made the audit below worth writing.
    llvm::FunctionCallee strlenFn =
        module.getOrInsertFunction("strlen", llvm::FunctionType::get(sizeTy(), {p}, false));
    llvm::Value* iSlot = createEntryAlloca("argv.i", i64);
    builder.CreateStore(builder.getInt64(0), iSlot);
    llvm::Function* fn = currentFn;
    auto* condBB = llvm::BasicBlock::Create(context, "argv.cond", fn);
    auto* bodyBB = llvm::BasicBlock::Create(context, "argv.body", fn);
    auto* endBB = llvm::BasicBlock::Create(context, "argv.end", fn);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(condBB);
    llvm::Value* i = builder.CreateLoad(i64, iSlot, "argv.iv");
    builder.CreateCondBr(builder.CreateICmpSLT(i, n), bodyBB, endBB);
    builder.SetInsertPoint(bodyBB);
    llvm::Value* src = builder.CreateLoad(
        p, builder.CreateGEP(p, argv, builder.CreateAdd(i, builder.getInt64(1))), "argv.s");
    // Widened to the 64 bits a String's length field holds, because that field does NOT follow the
    // target -- a Polaron String is the same shape everywhere, which is the point of it.
    llvm::Value* rawLen = builder.CreateCall(strlenFn, {src}, "argv.rawlen");
    llvm::Value* str =
        emitStringFromParts(builder.CreateZExtOrTrunc(rawLen, i64, "argv.len"), src);
    builder.CreateStore(str, builder.CreateGEP(p, data, i));
    builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
    builder.CreateBr(condBB);
    builder.SetInsertPoint(endBB);
    return block;
}

llvm::Value* CodeGenerator::Impl::emitArrayLiteral(const ast::ArrayLiteralExpr& al) {
    const std::size_t n = al.elements.size();
    const std::string elemType = n > 0 ? typeName(*al.elements[0]) : "int";
    const unsigned esz = arrayElemBytes(elemType);
    llvm::Value* block = builder.CreateCall(
        mallocFn(), {builder.getInt64(kArrayHeaderBytes + static_cast<std::uint64_t>(n) * esz)}, "arrlit");
    builder.CreateStore(builder.getInt64(static_cast<std::uint64_t>(n)), block);  // length header
    llvm::Type* et = arrayStorageTy(elemType);
    llvm::Value* data = arrayData(block);
    for (std::size_t i = 0; i < n; ++i) {
        llvm::Value* v = emitExpr(*al.elements[i]);
        if (v == nullptr) {
            continue;
        }
        v = coerce(v, typeName(*al.elements[i]), elemType);  // widen/convert to element type
        if (elemType == "boolean") {
            v = builder.CreateTrunc(v, builder.getInt8Ty());  // 1-byte slot
        }
        builder.CreateStore(v, builder.CreateGEP(et, data, builder.getInt64(i)));
    }
    return block;
}

llvm::Value* CodeGenerator::Impl::createEntryAlloca(const std::string& name, llvm::Type* type) {
    llvm::BasicBlock& entryBB = currentFn->getEntryBlock();
    llvm::IRBuilder<> tmp(&entryBB, entryBB.begin());
    return tmp.CreateAlloca(type, nullptr, name);
}

void CodeGenerator::Impl::zeroStackObjectSlot(llvm::Value* slot) {
    auto* alloca = llvm::dyn_cast<llvm::AllocaInst>(slot);
    if (alloca == nullptr) {
        return;
    }
    llvm::IRBuilder<> tmp(alloca->getParent(), std::next(alloca->getIterator()));
    tmp.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
}

std::string CodeGenerator::Impl::staticFieldKey(const ast::MemberExpr& mem) {
    const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem.object.get());
    if (objId == nullptr || objId->name == "this") {
        return "";
    }
    if (locals.find(objId->name) != locals.end()) {
        return "";
    }
    const std::string key = objId->name + "." + mem.member;
    return staticGlobals.count(key) > 0 ? key : std::string();
}

const std::set<std::string>& CodeGenerator::Impl::valueTypeNames() {
    if (!valueTypeNamesBuilt_) {
        for (const auto& [n, lay] : classes) {
            if (lay.decl != nullptr && (lay.decl->isStruct || lay.decl->isRecord) && !lay.decl->isUnion) {
                valueTypeNames_.insert(n);
            }
        }
        valueTypeNamesBuilt_ = true;
    }
    return valueTypeNames_;
}

std::vector<const ast::FieldDecl*> CodeGenerator::Impl::keyFieldsOf(const std::string& cn) {
    std::vector<const ast::FieldDecl*> out;
    auto it = classes.find(cn);
    if (it == classes.end() || it->second.decl == nullptr) {
        return out;
    }
    for (const auto& m : it->second.decl->members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get());
        if (f == nullptr || f->isStatic || f->isPersistent) {
            continue;
        }
        if (ast::keyFieldKind(f->type, valueTypeNames()) != ast::KeyFieldKind::None) {
            out.push_back(f);
        }
    }
    return out;
}

unsigned CodeGenerator::Impl::keyScalarBytes(const std::string& t) {
    if (t == "boolean") {
        return 4;  // boolean is an i32 in this ABI
    }
    if (t == "double" || t == "quadruple") {
        return 8;
    }
    if (t == "float" || t == "smallfloat") {
        return 4;
    }
    if (t == "char") {
        return 4;
    }
    return intBits(t) / 8;
}

llvm::Value* CodeGenerator::Impl::emitKeySize(const std::string& cn, llvm::Value* obj) {
    std::uint64_t fixed = 0;
    std::vector<llvm::Value*> dyn;
    for (const ast::FieldDecl* f : keyFieldsOf(cn)) {
        switch (ast::keyFieldKind(f->type, valueTypeNames())) {
            case ast::KeyFieldKind::Scalar: fixed += keyScalarBytes(f->type.name); break;
            case ast::KeyFieldKind::Text: {
                fixed += 8;                              // the length prefix
                llvm::Value* s = loadKeyField(cn, obj, f);
                dyn.push_back(builder.CreateLoad(builder.getInt64Ty(),
                    builder.CreateStructGEP(stringType(), s, 0, "k.slen"), "klen"));
                break;
            }
            case ast::KeyFieldKind::Nested: {
                llvm::Value* sub = keyFieldPtr(cn, obj, f);
                dyn.push_back(emitKeySize(f->type.name, sub));
                break;
            }
            case ast::KeyFieldKind::None: break;
        }
    }
    llvm::Value* total = builder.getInt64(fixed);
    for (llvm::Value* d : dyn) {
        total = builder.CreateAdd(total, d, "k.size");
    }
    return total;
}

llvm::Value* CodeGenerator::Impl::keyFieldPtr(const std::string& cn, llvm::Value* obj, const ast::FieldDecl* f) {
    auto& lay = classes[cn];
    return builder.CreateStructGEP(lay.type, obj, lay.fieldIndex.at(f->name), "k." + f->name);
}

llvm::Value* CodeGenerator::Impl::loadKeyField(const std::string& cn, llvm::Value* obj, const ast::FieldDecl* f) {
    return builder.CreateLoad(llvmType(f->type.name), keyFieldPtr(cn, obj, f), "k.v");
}

void CodeGenerator::Impl::emitKeyWrite(const std::string& cn, llvm::Value* obj, llvm::Value* buf, llvm::Value* offSlot) {
    for (const ast::FieldDecl* f : keyFieldsOf(cn)) {
        llvm::Value* off = builder.CreateLoad(builder.getInt64Ty(), offSlot, "k.off");
        llvm::Value* at = builder.CreateGEP(builder.getInt8Ty(), buf, off, "k.at");
        switch (ast::keyFieldKind(f->type, valueTypeNames())) {
            case ast::KeyFieldKind::Scalar: {
                builder.CreateStore(loadKeyField(cn, obj, f), at);
                builder.CreateStore(
                    builder.CreateAdd(off, builder.getInt64(keyScalarBytes(f->type.name))), offSlot);
                break;
            }
            case ast::KeyFieldKind::Text: {
                llvm::Value* s = loadKeyField(cn, obj, f);
                llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(),
                    builder.CreateStructGEP(stringType(), s, 0, "k.slen"), "klen");
                builder.CreateStore(len, at);                        // length prefix, then contents
                llvm::Value* after = builder.CreateAdd(off, builder.getInt64(8));
                emitMemcpy(builder.CreateGEP(builder.getInt8Ty(), buf, after, "k.txt"),
                           stringData(s), len);
                builder.CreateStore(builder.CreateAdd(after, len), offSlot);
                break;
            }
            case ast::KeyFieldKind::Nested:
                emitKeyWrite(f->type.name, keyFieldPtr(cn, obj, f), buf, offSlot);
                break;
            case ast::KeyFieldKind::None: break;
        }
    }
}

std::pair<llvm::Value*, llvm::Value*> CodeGenerator::Impl::emitKeyBytes(const std::string& cn, llvm::Value* obj) {
    llvm::Value* size = emitKeySize(cn, obj);
    llvm::Value* buf = builder.CreateAlloca(builder.getInt8Ty(), size, "key.buf");
    llvm::Value* offSlot = builder.CreateAlloca(builder.getInt64Ty(), nullptr, "key.off");
    builder.CreateStore(builder.getInt64(0), offSlot);
    emitKeyWrite(cn, obj, buf, offSlot);
    return {buf, size};
}

llvm::GlobalVariable* CodeGenerator::Impl::getPersistBlock(const std::string& key, llvm::StructType* blockTy) {
    const std::string gname = key + ".__pblock";
    if (staticGlobals.count(gname) == 0) {
        staticGlobals[gname] = new llvm::GlobalVariable(
            module, blockTy, /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
            llvm::Constant::getNullValue(blockTy), gname);
    }
    return staticGlobals[gname];
}

llvm::Value* CodeGenerator::Impl::persistentFieldPtr(const ast::MemberExpr& mem) {
    const std::string cls = baseType(typeName(*mem.object));
    auto cit = classes.find(cls);
    if (cit == classes.end() || cit->second.persistPtrIdx == 0) {
        return nullptr;
    }
    const auto& order = cit->second.persistOrder;
    auto pos = std::find(order.begin(), order.end(), mem.member);
    if (pos == order.end()) {
        return nullptr;  // not a persistent field
    }
    llvm::Value* objPtr = emitObjectPtr(*mem.object);
    if (objPtr == nullptr) {
        return nullptr;
    }
    llvm::Value* slot = builder.CreateStructGEP(cit->second.type, objPtr,
                                                cit->second.persistPtrIdx, "__persist");
    llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "pblock");
    const auto fidx = static_cast<unsigned>(pos - order.begin());
    return builder.CreateStructGEP(cit->second.persistBlock, block, fidx, mem.member);
}

llvm::FunctionCallee CodeGenerator::Impl::lazyLockFn() {
    return module.getOrInsertFunction("__polaron_lazy_lock",
                                      llvm::FunctionType::get(builder.getVoidTy(), {}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::lazyUnlockFn() {
    return module.getOrInsertFunction("__polaron_lazy_unlock",
                                      llvm::FunctionType::get(builder.getVoidTy(), {}, false));
}

void CodeGenerator::Impl::emitNullReceiverCheck(llvm::Value* ptr) {
    llvm::Value* isNull =
        builder.CreateICmpEQ(ptr, llvm::ConstantPointerNull::get(builder.getPtrTy()));
    llvm::BasicBlock* trapBB = llvm::BasicBlock::Create(context, "nullrecv", currentFn);
    llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "nullrecv.ok", currentFn);
    builder.CreateCondBr(isNull, trapBB, okBB);
    builder.SetInsertPoint(trapBB);
    emitGuardFail("null reference dereference", nullptr, nullptr, nullptr, nullptr,
                  70);  // ends the block with unreachable
    builder.SetInsertPoint(okBB);
}

llvm::Value* CodeGenerator::Impl::emitObjectPtrRaw(const ast::Expr& expr) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        if (id->name == "this") {
            return currentThis;
        }
        auto it = locals.find(id->name);
        if (it == locals.end()) {
            error("use of undeclared variable '" + id->name + "'", id->loc);
            return nullptr;
        }
        llvm::Value* storage = it->second.storage;
        ensureLazy(it->second.lazyFlag, it->second.lazyInit, storage, it->second.type, id->name);
        return builder.CreateLoad(builder.getPtrTy(), storage, id->name);
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        // A java-style enum constant used as a receiver (Type.CONST.method()).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            auto jit = javaEnums.find(objId->name);
            if (jit != javaEnums.end() && locals.find(objId->name) == locals.end()) {
                return emitEnumConstant(*jit->second, mem->member);
            }
        }
        // Chained access (a.b.c): the receiver `a.b` is itself a member. Class/struct values,
        // pointers and refs are all stored as a pointer in the slot, so load it (emitExpr =
        // emitLValue + load) to get the object pointer in every case.
        return emitExpr(expr);
    }
    // Any other object-producing expression -- a method-call result (f().g(), box.get().m()),
    // a cast, etc. It yields an object pointer, so emit it directly. The analyzer already
    // verified the receiver is an object, so no extra check is needed here.
    return emitExpr(expr);
}

llvm::Value* CodeGenerator::Impl::emitLValue(const ast::Expr& expr) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        auto it = locals.find(id->name);
        if (it == locals.end()) {
            error("use of undeclared variable '" + id->name + "'", id->loc);
            return nullptr;
        }
        return it->second.storage;
    }
    // `*p` as an lvalue (`*out = v`): the storage address IS the pointer value p holds.
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        if (un->op == "*") {
            return emitExpr(*un->operand);
        }
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        if (const std::string key = staticFieldKey(*mem); !key.empty()) {
            return staticGlobals[key];  // the global itself is the address
        }
        if (llvm::Value* pp = persistentFieldPtr(*mem)) {
            return pp;  // persistent instance field: address inside the object's block
        }
        llvm::Value* objPtr = emitObjectPtr(*mem->object);
        if (objPtr == nullptr) {
            return nullptr;
        }
        auto cit = classes.find(clsKey(typeName(*mem->object)));  // see through T* / T&
        if (cit == classes.end()) {
            error("no such field '" + mem->member + "'", mem->loc);
            return nullptr;
        }
        auto fit = cit->second.fieldIndex.find(mem->member);
        if (fit == cit->second.fieldIndex.end()) {
            error("no such field '" + mem->member + "'", mem->loc);
            return nullptr;
        }
        return builder.CreateStructGEP(cit->second.type, objPtr, fit->second, mem->member);
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        llvm::Value* block = emitExpr(*ix->array);
        if (block == nullptr) {
            return nullptr;
        }
        llvm::Value* index = emitExpr(*ix->index);
        if (index == nullptr) {
            return nullptr;
        }
        const std::string at = typeName(*ix->array);
        // Raw pointer index p[i] (spec 17.8): unchecked GEP, no array header / bounds check.
        if (isRefType(at)) {
            llvm::Value* i = index->getType()->isIntegerTy(64)
                                 ? index
                                 : builder.CreateSExt(index, builder.getInt64Ty());
            return builder.CreateGEP(llvmType(baseType(at)), block, i, "ptr.elem");
        }
        return arrayElemPtr(block, index, arrayStorageTy(elementOf(at)),
                            /*checked=*/!ix->unchecked && !noBoundsCheck_);
    }
    error("invalid assignment target", expr.loc);
    return nullptr;
}

llvm::StructType* CodeGenerator::Impl::stringType() {
    if (stringStructTy == nullptr) {
        stringStructTy = llvm::StructType::create(
            context, {builder.getInt64Ty(), builder.getPtrTy(), builder.getInt64Ty()}, "String");
    }
        // Layout: { i64 length, ptr data, i64 hash }. The trailing hash is a lazily-cached FNV-1a of
        // the bytes (0 = not yet computed); a String being immutable, it is computed at most once.
    return stringStructTy;
}

llvm::Value* CodeGenerator::Impl::emitBytesLiteral(const std::string& bytes) {
    llvm::Constant* arr = llvm::ConstantDataArray::getString(context, bytes, /*AddNull=*/true);
    auto* g = new llvm::GlobalVariable(module, arr->getType(), /*isConstant=*/true,
                                       llvm::GlobalValue::PrivateLinkage, arr, ".bytes");
    return g;
}

llvm::Value* CodeGenerator::Impl::emitStringObject(const std::string& bytes) {
    llvm::Constant* dataArr = llvm::ConstantDataArray::getString(context, bytes, /*AddNull=*/true);
    auto* dataG = new llvm::GlobalVariable(module, dataArr->getType(), /*isConstant=*/true,
                                           llvm::GlobalValue::PrivateLinkage, dataArr, ".strdata");
    llvm::Constant* obj = llvm::ConstantStruct::get(
        stringType(), {builder.getInt64(bytes.size()), dataG, builder.getInt64(0)});
    // Not constant: the hash field (0) is filled in on first hash(). The bytes it points to stay const.
    auto* objG = new llvm::GlobalVariable(module, stringType(), /*isConstant=*/false,
                                          llvm::GlobalValue::PrivateLinkage, obj, ".strobj");
    return objG;
}

llvm::Value* CodeGenerator::Impl::stringData(llvm::Value* strObj) {
    return builder.CreateLoad(builder.getPtrTy(),
                              builder.CreateStructGEP(stringType(), strObj, 1, "str.data"), "data");
}

llvm::Value* CodeGenerator::Impl::emitStringConcat(llvm::Value* a, llvm::Value* b) {
    llvm::Value* la = stringLen(a);
    llvm::Value* lb = stringLen(b);
    llvm::Value* total = builder.CreateAdd(la, lb);
    llvm::Value* buf = builder.CreateCall(
        mallocFn(), {builder.CreateAdd(total, builder.getInt64(1))}, "cat.buf");
    emitMemcpy(buf, stringData(a), la);
    emitMemcpy(builder.CreateGEP(builder.getInt8Ty(), buf, la), stringData(b), lb);
    builder.CreateStore(builder.getInt8(0),
                        builder.CreateGEP(builder.getInt8Ty(), buf, total));  // NUL terminator
    return emitStringFromParts(total, buf);
}

llvm::Value* CodeGenerator::Impl::asCStr(const ast::Expr& e, llvm::Value* v) {
    const std::string t = typeName(e);
    if (t == "String" || t == "string") {
        return stringData(v);
    }
    // C varargs default argument promotions: an integer narrower than int is promoted to int,
    // and a float to double, so printf reads each argument at the width its conversion expects.
    if (v->getType()->isIntegerTy() && v->getType()->getIntegerBitWidth() < 32) {
        v = isUnsigned(t) ? builder.CreateZExt(v, builder.getInt32Ty())
                          : builder.CreateSExt(v, builder.getInt32Ty());
    } else if (v->getType()->isFloatTy()) {
        v = builder.CreateFPExt(v, builder.getDoubleTy());
    }
    return v;
}

llvm::FunctionCallee CodeGenerator::Impl::strCopyFn() {
    return module.getOrInsertFunction("__polaron_str_copy",
        llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false));
}

llvm::FunctionCallee CodeGenerator::Impl::strFreeFn() {
    return module.getOrInsertFunction("__polaron_str_free",
        llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false));
}

llvm::Value* CodeGenerator::Impl::emitStringCopy(llvm::Value* v) {
    if (v == nullptr) {
        return v;
    }
    return builder.CreateCall(strCopyFn(), {v}, "strcpy");
}

void CodeGenerator::Impl::trackStringTemp(llvm::Value* v) {
    if (v != nullptr) {
        stringTemps.emplace_back(v, builder.GetInsertBlock());
    }
}

void CodeGenerator::Impl::freeStringTemps() {
    if (stringTemps.empty()) {
        return;
    }
    llvm::BasicBlock* here = builder.GetInsertBlock();
    if (here != nullptr && here->getTerminator() == nullptr) {
        for (auto& tb : stringTemps) {
            if (tb.second == here) {
                builder.CreateCall(strFreeFn(), {tb.first});
            }
        }
    }
    stringTemps.clear();
}

void CodeGenerator::Impl::releaseArmStringTemps(std::size_t from) {
    llvm::BasicBlock* here = builder.GetInsertBlock();
    if (here != nullptr && here->getTerminator() == nullptr) {
        for (std::size_t i = from; i < stringTemps.size(); ++i) {
            if (stringTemps[i].second == here) {
                builder.CreateCall(strFreeFn(), {stringTemps[i].first});
            }
        }
    }
    if (from <= stringTemps.size()) {
        stringTemps.resize(from);
    }
}

bool CodeGenerator::Impl::isTrackedStringSlot(llvm::Value* slot) {
    return std::find(scopeStrings.begin(), scopeStrings.end(), slot) != scopeStrings.end();
}

bool CodeGenerator::Impl::callReturnsOwnedUserString(const ast::CallExpr& call) {
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
    if (mem == nullptr) {
        return false;
    }
    // Enum/catalog instance method (spec 12.4): resolve the (possibly catalog-implementing) enum.
    std::string enumRecv = baseType(typeName(*mem->object));
    if (enumMethodDecls.find(enumRecv) == enumMethodDecls.end()) {
        if (std::string impl = catalogImplementerEnum(enumRecv, mem->member); !impl.empty()) {
            enumRecv = impl;
        }
    }
    if (auto eit = enumMethodDecls.find(enumRecv); eit != enumMethodDecls.end()) {
        for (const ast::MemberPtr& member : eit->second->members) {
            const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
            if (m != nullptr && m->name == mem->member) {
                const std::string mrt = typeRefName(m->returnType);
                return mrt == "String" || mrt == "string";
            }
        }
        return false;
    }
    // A java-style implementer resolved through a catalog: its methods are the twin class's.
    if (javaEnums.count(enumRecv) > 0) {
        if (std::string owner = methodOwner(enumRecv, mem->member); !owner.empty()) {
            const std::string mrt = classes[owner].methodReturnType[mem->member];
            return mrt == "String" || mrt == "string";
        }
        return false;
    }
    // Instance: search the receiver's class hierarchy; static: the named class.
    std::string owner = methodOwner(typeName(*mem->object), mem->member);
    if (owner.empty() && classes.count(flattenCallee(*mem->object)) > 0) {
        owner = methodOwner(flattenCallee(*mem->object), mem->member);
    }
    if (owner.empty()) {
        return false;
    }
    // An async method yields a Task<...>, not an owned String; leave it alone.
    const ast::MethodDecl* md = findMethodDecl(owner, mem->member);
    if (md != nullptr && md->isAsync) {
        return false;
    }
    const std::string mrt = classes[owner].methodReturnType[mem->member];
    return mrt == "String" || mrt == "string";
}

llvm::StructType* CodeGenerator::Impl::typeTokenType() {
    if (typeStructTy == nullptr) {
        typeStructTy = llvm::StructType::create(
            context,
            {builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(), builder.getPtrTy(),
             builder.getInt64Ty(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(),
             builder.getInt64Ty(), builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy(),
             builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()},
            "ReflectType");  // ..., ptr fieldGetters, ptr fieldSetters, ptr methodAnnCounts(i64[]),
    }
                             // ptr methodAnnNames(ptr[] -> String[]), ptr methodRetTags(i64[])
    return typeStructTy;
}

llvm::StructType* CodeGenerator::Impl::annotationTokenType() {
    if (annotationStructTy == nullptr) {
        annotationStructTy =
            llvm::StructType::create(context, {builder.getPtrTy()}, "ReflectAnnotation");
    }
    return annotationStructTy;
}

llvm::StructType* CodeGenerator::Impl::methodTokenType() {
    if (methodStructTy == nullptr) {
        methodStructTy = llvm::StructType::create(
            context,
            {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(),
             builder.getInt64Ty()},
            "ReflectMethod");
    }
    return methodStructTy;
}

long long CodeGenerator::Impl::returnTag(const std::string& rt) {
    const std::string b = baseType(rt);
    if (b.empty() || b == "void") {
        return 0;
    }
    if (b == "long" || b == "int64" || b == "uint64" || b == "ulong") {
        return 2;
    }
    if (b == "double" || b == "float64") {
        return 3;
    }
    if (b == "float" || b == "float32" || b == "smallfloat") {
        return 4;
    }
    if (b == "byte" || b == "int8" || b == "ubyte" || b == "uint8") {
        return 6;
    }
    if (b == "short" || b == "int16" || b == "ushort" || b == "uint16") {
        return 7;
    }
    if (isBoxablePrimitive(b)) {
        return 1;  // int/boolean/char/int32/uint32 (i32)
    }
    return 5;  // a reference (class/String/array/enum/Object)
}

std::string CodeGenerator::Impl::tagBoxType(long long tag) {
    switch (tag) {
        case 1: return "int";
        case 2: return "long";
        case 3: return "double";
        case 4: return "float";
        case 6: return "byte";
        case 7: return "short";
        default: return "";  // 0 void, 5 pointer
    }
}

llvm::Type* CodeGenerator::Impl::tagRetType(long long tag) {
    switch (tag) {
        case 1: return builder.getInt32Ty();
        case 2: return builder.getInt64Ty();
        case 3: return builder.getDoubleTy();
        case 4: return builder.getFloatTy();
        case 6: return builder.getInt8Ty();
        case 7: return builder.getInt16Ty();
        case 5: return builder.getPtrTy();
        default: return builder.getVoidTy();  // 0
    }
}

llvm::StructType* CodeGenerator::Impl::fieldTokenType() {
    if (fieldStructTy == nullptr) {
        fieldStructTy = llvm::StructType::create(
            context, {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, "ReflectField");
    }
    return fieldStructTy;
}

llvm::Value* CodeGenerator::Impl::typeTokenFor(const std::string& className) {
    auto it = typeGlobals.find(className);
    if (it != typeGlobals.end()) {
        return it->second;
    }
    std::vector<std::string> methodNames, fieldNames, annotationNames;
    std::vector<llvm::Constant*> methodRetTags;      // parallel to methodNames (invoke, spec 31)
    std::vector<const ast::MethodDecl*> methodDecls; // parallel: for per-method annotations
    std::vector<std::string> methodOwners;           // parallel: class providing the impl
    // Enumerate methods across the whole inheritance chain, most-derived first so an override
    // shadows its base declaration -- reflection reports inherited methods too, each pointing at
    // its most-derived implementation (spec 31). Fields/annotations stay own-class.
    {
        std::unordered_set<std::string> seenMethods;
        for (std::string cn = className; !cn.empty();) {
            // Stop at the implicit universal root: reflection reports the type's own methods and
            // those inherited from USER base classes, not Object's equals/hashCode/equalsKey.
            if (cn == "Object" && cn != className) {
                break;
            }
            auto cit = classes.find(cn);
            if (cit == classes.end() || cit->second.decl == nullptr) {
                break;
            }
            for (const ast::MemberPtr& m : cit->second.decl->members) {
                if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                    if (!seenMethods.insert(md->name).second) {
                        continue;  // overridden in a subclass
                    }
                    methodNames.push_back(md->name);
                    methodRetTags.push_back(
                        builder.getInt64(returnTag(typeRefName(md->returnType))));
                    methodDecls.push_back(md);
                    methodOwners.push_back(cn);
                }
            }
            cn = cit->second.superclass;
        }
        // Fields: own + inherited (from user base classes), in the same physical order as the
        // object layout (collectFields drives fieldIndex too), so every per-field boxing accessor
        // lines up with its fieldIndex slot and Field.get/set read the right offset.
        for (const auto& [fname, ftype] : collectFields(className)) {
            (void)ftype;
            fieldNames.push_back(fname);
        }
        if (auto cit = classes.find(className); cit != classes.end() && cit->second.decl != nullptr) {
            for (const ast::AnnotationUse& a : cit->second.decl->annotations) {
                annotationNames.push_back(a.name);  // applied [Name(...)] annotations (spec 14.3, 31)
            }
        }
    }
    auto* nameStr = llvm::cast<llvm::Constant>(emitStringObject(className));
    auto [mcount, mnames] = nameArray(methodNames, "methods." + className);
    auto [fcount, fnames] = nameArray(fieldNames, "fields." + className);
    auto [acount, anames] = nameArray(annotationNames, "annotations." + className);
    // Parallel array of method function pointers (null where there is no body).
    std::vector<llvm::Constant*> fns;
    for (std::size_t mi = 0; mi < methodNames.size(); ++mi) {
        // Resolve each method's impl in its OWNING class so an override wins and an inherited
        // (non-overridden) method points at the base body.
        auto fit = functions.find(methodOwners[mi] + "." + methodNames[mi]);
        fns.push_back(fit != functions.end()
                          ? llvm::cast<llvm::Constant>(fit->second)
                          : llvm::ConstantPointerNull::get(builder.getPtrTy()));
    }
    llvm::ArrayType* fnArrTy = llvm::ArrayType::get(builder.getPtrTy(), fns.size());
    auto* fnsG = new llvm::GlobalVariable(module, fnArrTy, /*isConstant=*/true,
                                          llvm::GlobalValue::PrivateLinkage,
                                          llvm::ConstantArray::get(fnArrTy, fns),
                                          "methodfns." + className);
    // Parallel arrays of per-field get/set accessors (for Field.get/set, spec 31).
    std::vector<llvm::Constant*> getFns, setFns;
    for (const std::string& fn : fieldNames) {
        getFns.push_back(emitFieldAccessor(className, fn, /*setter=*/false));
        setFns.push_back(emitFieldAccessor(className, fn, /*setter=*/true));
    }
    auto fnArray = [&](std::vector<llvm::Constant*>& v, const std::string& tag) -> llvm::Constant* {
        llvm::ArrayType* at = llvm::ArrayType::get(builder.getPtrTy(), v.size());
        return new llvm::GlobalVariable(module, at, /*isConstant=*/true,
                                        llvm::GlobalValue::PrivateLinkage,
                                        llvm::ConstantArray::get(at, v), tag);
    };
    llvm::Constant* fGetG = fnArray(getFns, "fieldget." + className);
    llvm::Constant* fSetG = fnArray(setFns, "fieldset." + className);
    // Per-method annotation arrays (spec 31), parallel to methodNames: for each method, its own
    // applied annotations as {count, String[]}, so a Method token can report them.
    std::vector<llvm::Constant*> mAnnCounts, mAnnPtrs;
    for (std::size_t mi = 0; mi < methodDecls.size(); ++mi) {  // parallel to methodNames
        std::vector<std::string> anns;
        for (const ast::AnnotationUse& a : methodDecls[mi]->annotations) {
            anns.push_back(a.name);
        }
        auto [cnt, arr] = nameArray(anns, "methodann." + className + "." + std::to_string(mi));
        mAnnCounts.push_back(cnt);
        mAnnPtrs.push_back(arr);
    }
    llvm::ArrayType* mAnnCountArrTy = llvm::ArrayType::get(builder.getInt64Ty(), mAnnCounts.size());
    auto* mAnnCountsG = new llvm::GlobalVariable(
        module, mAnnCountArrTy, /*isConstant=*/true, llvm::GlobalValue::PrivateLinkage,
        llvm::ConstantArray::get(mAnnCountArrTy, mAnnCounts), "methodanncounts." + className);
    llvm::ArrayType* mAnnPtrArrTy = llvm::ArrayType::get(builder.getPtrTy(), mAnnPtrs.size());
    auto* mAnnPtrsG = new llvm::GlobalVariable(
        module, mAnnPtrArrTy, /*isConstant=*/true, llvm::GlobalValue::PrivateLinkage,
        llvm::ConstantArray::get(mAnnPtrArrTy, mAnnPtrs), "methodannptrs." + className);
    // Parallel array of method return-type tags, for reflective invoke (spec 31).
    llvm::ArrayType* retTagArrTy = llvm::ArrayType::get(builder.getInt64Ty(), methodRetTags.size());
    auto* retTagsG = new llvm::GlobalVariable(
        module, retTagArrTy, /*isConstant=*/true, llvm::GlobalValue::PrivateLinkage,
        llvm::ConstantArray::get(retTagArrTy, methodRetTags), "methodrettags." + className);
    // size of an instance + the (no-arg) constructor, for Type.instantiate().
    llvm::Constant* size = llvm::ConstantInt::get(builder.getInt64Ty(), 8);
    if (auto cit = classes.find(className); cit != classes.end()) {
        size = llvm::cast<llvm::Constant>(sizeOf(cit->second.type));
    }
    auto ctorIt = functions.find(className + "." + className);
    llvm::Constant* ctorFn = ctorIt != functions.end()
                                 ? llvm::cast<llvm::Constant>(ctorIt->second)
                                 : llvm::ConstantPointerNull::get(builder.getPtrTy());
    llvm::Constant* obj = llvm::ConstantStruct::get(
        typeTokenType(), {nameStr, mcount, mnames, fnsG, fcount, fnames, size, ctorFn, acount,
                          anames, fGetG, fSetG, mAnnCountsG, mAnnPtrsG, retTagsG});
    auto* g = new llvm::GlobalVariable(module, typeTokenType(), /*isConstant=*/true,
                                       llvm::GlobalValue::PrivateLinkage, obj, "type." + className);
    typeGlobals[className] = g;
    return g;
}

}  // namespace polaron
