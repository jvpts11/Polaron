// The freestanding runtime bridges. See bridges.h for why they are here and not in a backend.
//
// Moved out of `CodeGenerator::Impl` as they stood, so a `git blame` on any line still lands on the
// change that wrote it. What changed in the move is only what had to: `module`/`context` are
// parameters, the builder is local, and `mallocFn`/`freeFn` are the two lines they always were.

#include "codegen/bridges.h"

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Type.h>

#include <cstdint>

namespace polaron {
namespace {

// The allocator a freestanding program provides for itself. Declared, never defined here: on bare
// metal it is the kernel's, and `heap class` is how a program says which one.
llvm::FunctionCallee mallocOf(llvm::LLVMContext& c, llvm::Module& m) {
    return m.getOrInsertFunction(
        "__polaron_malloc",
        llvm::FunctionType::get(llvm::PointerType::get(c, 0), {llvm::Type::getInt64Ty(c)}, false));
}

llvm::FunctionCallee freeOf(llvm::LLVMContext& c, llvm::Module& m) {
    return m.getOrInsertFunction(
        "__polaron_free",
        llvm::FunctionType::get(llvm::Type::getVoidTy(c), {llvm::PointerType::get(c, 0)}, false));
}

// The size of a type, as the module's own data layout measures it.
llvm::Value* sizeOfType(llvm::Module& m, llvm::IRBuilder<>& b, llvm::Type* t) {
    return b.getInt64(m.getDataLayout().getTypeAllocSize(t));
}

// Declare `sym`, and hand back the function ONLY if it still needs a body. A symbol the program
// already defines -- a kernel supplying its own -- is left exactly as it is.
llvm::Function* declareIfNew(llvm::Module& m, const char* sym, llvm::Type* ret,
                             llvm::ArrayRef<llvm::Type*> params) {
    llvm::FunctionType* ty = llvm::FunctionType::get(ret, params, false);
    llvm::Function* f = m.getFunction(sym);
    if (f == nullptr) {
        f = llvm::Function::Create(ty, llvm::Function::ExternalLinkage, sym, m);
    }
    return f->empty() ? f : nullptr;
}

}  // namespace

void emitStringBridge(llvm::LLVMContext& context, llvm::Module& module) {
    llvm::IRBuilder<> builder(context);
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::PointerType* p = builder.getPtrTy();
    llvm::StructType* strTy = llvm::StructType::get(context, {i64, p, i64});
    auto define = [&](const char* sym, llvm::Type* ret, llvm::ArrayRef<llvm::Type*> params) {
        return declareIfNew(module, sym, ret, params);
    };

    // __polaron_str_copy(src) -> a fresh String owning its own buffer. Null-safe.
    if (llvm::Function* f = define("__polaron_str_copy", p, {p})) {
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
        llvm::Value* obj =
            builder.CreateCall(mallocOf(context, module),
                               {sizeOfType(module, builder, strTy)}, "str.obj");
        // len + 1: the buffer stays NUL-terminated, which is what lets a String be handed to
        // anything that expects a C string without copying it again.
        llvm::Value* buf = builder.CreateCall(
            mallocOf(context, module), {builder.CreateAdd(len, builder.getInt64(1))}, "str.buf");
        builder.CreateMemCpy(buf, llvm::MaybeAlign(1), data, llvm::MaybeAlign(1), len);
        builder.CreateStore(builder.getInt8(0), builder.CreateGEP(builder.getInt8Ty(), buf, len));
        builder.CreateStore(len, builder.CreateStructGEP(strTy, obj, 0));
        builder.CreateStore(buf, builder.CreateStructGEP(strTy, obj, 1));
        builder.CreateStore(builder.getInt64(0), builder.CreateStructGEP(strTy, obj, 2));
        builder.CreateRet(obj);
    }

    // __polaron_str_free(s): the buffer, then the object. Null-safe.
    if (llvm::Function* f = define("__polaron_str_free", builder.getVoidTy(), {p})) {
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* work = llvm::BasicBlock::Create(context, "free", f);
        auto* done = llvm::BasicBlock::Create(context, "done", f);
        builder.SetInsertPoint(entry);
        llvm::Value* s = f->getArg(0);
        builder.CreateCondBr(
            builder.CreateICmpEQ(s, llvm::ConstantPointerNull::get(p)), done, work);
        builder.SetInsertPoint(work);
        builder.CreateCall(freeOf(context, module),
                           {builder.CreateLoad(p, builder.CreateStructGEP(strTy, s, 1, "s.data.p"))});
        builder.CreateCall(freeOf(context, module), {s});
        builder.CreateBr(done);
        builder.SetInsertPoint(done);
        builder.CreateRetVoid();
    }

    // __polaron_str_index(h, hl, n, nl) -> first index of n in h, or -1. Length-aware, so it is
    // correct where strstr would not be: neither buffer has to stop at a NUL.
    if (llvm::Function* f = define("__polaron_str_index", i64, {p, i64, p, i64})) {
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
}

void emitPointerSetBridge(llvm::LLVMContext& context, llvm::Module& module) {
    llvm::IRBuilder<> builder(context);
    llvm::Type* i64 = builder.getInt64Ty();
    llvm::Type* i32 = builder.getInt32Ty();
    llvm::PointerType* p = builder.getPtrTy();
    llvm::Constant* nullPtr = llvm::ConstantPointerNull::get(p);
    // { count, next, items[Slots] }
    const int slots = 62;
    llvm::StructType* blockTy = llvm::StructType::get(
        context, {i64, p, llvm::ArrayType::get(p, static_cast<std::uint64_t>(slots))});

    auto define = [&](const char* sym, llvm::Type* ret, llvm::ArrayRef<llvm::Type*> params) {
        return declareIfNew(module, sym, ret, params);
    };

    // A fresh block, empty. Shared by `new` and by `add` when the tail fills up.
    auto freshBlock = [&]() -> llvm::Value* {
        llvm::Value* b = builder.CreateCall(mallocOf(context, module),
                                            {sizeOfType(module, builder, blockTy)}, "set.block");
        builder.CreateStore(builder.getInt64(0), builder.CreateStructGEP(blockTy, b, 0));
        builder.CreateStore(nullPtr, builder.CreateStructGEP(blockTy, b, 1));
        return b;
    };

    // __polaron_ptrset_new() -> an empty set.
    if (llvm::Function* f = define("__polaron_ptrset_new", p, {})) {
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
        builder.CreateRet(freshBlock());
    }

    // __polaron_ptrset_add(set, obj) -> 1 if this is the first time `obj` is seen, 0 if not.
    //
    // The scan and the append are ONE walk: the loop that looks for `obj` ends standing on the last
    // block, which is where a new one goes. Two walks would read the chain twice for every node of
    // every cascade, and this runs inside a destructor.
    if (llvm::Function* f = define("__polaron_ptrset_add", i32, {p, p})) {
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* scan = llvm::BasicBlock::Create(context, "scan", f);       // scan one block
        auto* item = llvm::BasicBlock::Create(context, "item", f);       // ...one slot of it
        auto* next = llvm::BasicBlock::Create(context, "next", f);       // ...on to the next block
        auto* tail = llvm::BasicBlock::Create(context, "tail", f);       // the last block: append
        auto* here = llvm::BasicBlock::Create(context, "here", f);       // room in this one
        auto* grow = llvm::BasicBlock::Create(context, "grow", f);       // full: chain another
        auto* seen = llvm::BasicBlock::Create(context, "seen", f);
        auto* fresh = llvm::BasicBlock::Create(context, "fresh", f);

        builder.SetInsertPoint(entry);
        llvm::Value* set = f->getArg(0);
        llvm::Value* obj = f->getArg(1);
        llvm::Value* bSlot = builder.CreateAlloca(p, nullptr, "b");
        llvm::Value* iSlot = builder.CreateAlloca(i64, nullptr, "i");
        builder.CreateStore(set, bSlot);
        builder.CreateBr(scan);

        builder.SetInsertPoint(scan);
        builder.CreateStore(builder.getInt64(0), iSlot);
        builder.CreateBr(item);

        builder.SetInsertPoint(item);
        llvm::Value* b = builder.CreateLoad(p, bSlot, "b.v");
        llvm::Value* i = builder.CreateLoad(i64, iSlot, "i.v");
        llvm::Value* count =
            builder.CreateLoad(i64, builder.CreateStructGEP(blockTy, b, 0), "b.count");
        auto* look = llvm::BasicBlock::Create(context, "look", f);
        builder.CreateCondBr(builder.CreateICmpSLT(i, count), look, next);

        builder.SetInsertPoint(look);
        llvm::Value* slot = builder.CreateGEP(
            blockTy, b, {builder.getInt32(0), builder.getInt32(2), i}, "b.item.p");
        llvm::Value* have = builder.CreateLoad(p, slot, "b.item");
        builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
        builder.CreateCondBr(builder.CreateICmpEQ(have, obj), seen, item);

        builder.SetInsertPoint(next);
        llvm::Value* b2 = builder.CreateLoad(p, bSlot);
        llvm::Value* link = builder.CreateLoad(p, builder.CreateStructGEP(blockTy, b2, 1), "b.next");
        auto* walk = llvm::BasicBlock::Create(context, "walk", f);
        builder.CreateCondBr(builder.CreateICmpEQ(link, nullPtr), tail, walk);
        builder.SetInsertPoint(walk);
        builder.CreateStore(link, bSlot);
        builder.CreateBr(scan);

        builder.SetInsertPoint(tail);
        llvm::Value* last = builder.CreateLoad(p, bSlot);
        llvm::Value* n = builder.CreateLoad(i64, builder.CreateStructGEP(blockTy, last, 0), "n");
        builder.CreateCondBr(builder.CreateICmpSLT(n, builder.getInt64(slots)), here, grow);

        builder.SetInsertPoint(here);
        builder.CreateStore(obj, builder.CreateGEP(blockTy, last,
                                                   {builder.getInt32(0), builder.getInt32(2), n}));
        builder.CreateStore(builder.CreateAdd(n, builder.getInt64(1)),
                            builder.CreateStructGEP(blockTy, last, 0));
        builder.CreateBr(fresh);

        builder.SetInsertPoint(grow);
        llvm::Value* added = freshBlock();
        builder.CreateStore(obj, builder.CreateGEP(blockTy, added,
                                                   {builder.getInt32(0), builder.getInt32(2),
                                                    builder.getInt64(0)}));
        builder.CreateStore(builder.getInt64(1), builder.CreateStructGEP(blockTy, added, 0));
        builder.CreateStore(added, builder.CreateStructGEP(blockTy, last, 1));
        builder.CreateBr(fresh);

        builder.SetInsertPoint(seen);
        builder.CreateRet(builder.getInt32(0));
        builder.SetInsertPoint(fresh);
        builder.CreateRet(builder.getInt32(1));
    }

    // __polaron_ptrset_free(set): the whole chain. Null-safe, because a cascade over a forest passes
    // a null set on purpose (the cascade skips the allocation when it can never dedup).
    if (llvm::Function* f = define("__polaron_ptrset_free", builder.getVoidTy(), {p})) {
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* loop = llvm::BasicBlock::Create(context, "loop", f);
        auto* body = llvm::BasicBlock::Create(context, "body", f);
        auto* done = llvm::BasicBlock::Create(context, "done", f);
        builder.SetInsertPoint(entry);
        llvm::Value* bSlot = builder.CreateAlloca(p, nullptr, "b");
        builder.CreateStore(f->getArg(0), bSlot);
        builder.CreateBr(loop);
        builder.SetInsertPoint(loop);
        llvm::Value* b = builder.CreateLoad(p, bSlot, "b.v");
        builder.CreateCondBr(builder.CreateICmpEQ(b, nullPtr), done, body);
        builder.SetInsertPoint(body);
        llvm::Value* link = builder.CreateLoad(p, builder.CreateStructGEP(blockTy, b, 1));
        builder.CreateCall(freeOf(context, module), {b});
        builder.CreateStore(link, bSlot);
        builder.CreateBr(loop);
        builder.SetInsertPoint(done);
        builder.CreateRetVoid();
    }
}

}  // namespace polaron
