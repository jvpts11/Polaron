#include "pir/tollvm.h"

#include <llvm/BinaryFormat/Dwarf.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DIBuilder.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InlineAsm.h>
#include <llvm/IR/Intrinsics.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/MDBuilder.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Support/raw_ostream.h>
// The assembly dialect follows the ARCHITECTURE when an `asm` block does not name one, and the
// triple is what says which architecture that is.
#include <llvm/TargetParser/Triple.h>

#include <cstdio>
#include <cstdlib>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// For `resolveEscapes`: how a literal is SPELLED is a fact about the language, not about a backend,
// and both backends have to read it the same way or the same source means two different things.
#include "codegen/cgutil.h"
#include "codegen/target.h"   // the one data layout: every size in this file is read off it
#include "codegen/bridges.h"  // what a program with no libc has to be given
// For `typeIsNullable`: whether a parameter may be absent is a fact about the DECLARATION, and the
// only honest source for it is the spelling the parameter carries.
#include "parser/ast.h"

namespace polaron::pir {

namespace {

// A `T[]` is eight bytes of length, then the elements. The same layout the trusted path allocates
// and the runtime hands back -- see the note on `TypeKind::Slice` in `build`.
constexpr uint64_t kArrayHeader = 8;

class Emitter {
public:
    Emitter(const Module& pir, llvm::LLVMContext& c, llvm::Module& m)
        : pir_(pir), ctx_(c), mod_(m), b_(c) {}

    ToLlvmResult run() {
        // `POLARON_PIR_TRACE=1` names each function as it is emitted. A backend that crashes in one
        // of nine hundred functions gives a segmentation fault and no stack worth reading; this
        // turns that into a name in one line of output, which is the difference between an
        // afternoon and a minute.
        const char* traceEnv = std::getenv("POLARON_PIR_TRACE");
        trace_ = traceEnv != nullptr && traceEnv[0] == '1';
        // THE TARGET FIRST, because every size below is read off it. A module with no data layout is
        // not "unset": LLVM's default aligns `i64` to FOUR bytes, so `struct { int; long; boolean }`
        // measures sixteen where the machine says twenty-four -- and this backend asks the layout
        // for every `sizeof`, every allocation size and every `memset` length. Zeroing a fresh
        // struct left its last field holding whatever was there, and an object was handed a block
        // its own constructor then wrote past the end of. Both silent; the second is a kernel that
        // fails differently on every boot.
        applyTarget(mod_, pir_.triple);
        // `-g`: the compile unit exists before any function does, because every subprogram is filed
        // under it.
        beginDebug();

        for (const Global& g : pir_.globals) {
            if (!g.initFns.empty()) {
                continue;   // a vtable names functions; those do not exist yet
            }
            if (trace_) std::fprintf(stderr, "pir->llvm: global @%s\n", g.name.c_str());
            emitGlobal(g);
        }
        for (const std::unique_ptr<Function>& f : pir_.functions) {
            if (trace_) std::fprintf(stderr, "pir->llvm: declare @%s\n", f->key.c_str());
            declare(*f);
        }
        // THE TABLES LAST OF THE DATA, because every entry in one is the address of a function and
        // the functions have only just been declared. Emitted with the rest and the slots came out
        // null, which is a table that dispatches every call to address zero.
        for (const Global& g : pir_.globals) {
            if (!g.initFns.empty()) {
                if (trace_) std::fprintf(stderr, "pir->llvm: vtable @%s\n", g.name.c_str());
                emitGlobal(g);
            }
        }
        // THE REFLECTIVE TOKENS AFTER THE DECLARATIONS AND BEFORE THE BODIES: a token names the
        // methods and accessors it points at, so those must exist as symbols; and a body that says
        // `typeOf<T>()` reads the token's address, so the global must exist before the body does.
        emitReflectTokens();
        for (const std::unique_ptr<Function>& f : pir_.functions) {
            if (!f->blocks.empty()) {
                if (trace_) std::fprintf(stderr, "pir->llvm: define @%s\n", f->key.c_str());
                define(*f);
            }
        }
        // THE MESSAGE, not just the verdict. `verifyModule(m, nullptr)` answers yes or no and
        // discards what is wrong, which is the least useful half.
        std::string why;
        llvm::raw_string_ostream os(why);
        emitEntry();
        fillCodeTable();
        internalizeProgram();
        // WHAT A PROGRAM WITH NO LIBC HAS TO BE GIVEN. `String` copies and frees itself and a
        // `cascade` over a non-forest needs a visited set; hosted, those are runtime calls, and on
        // bare metal there is no runtime to call. Emitted before the dead-declaration sweep so a
        // bridge nothing uses is still dropped, and after every body so a program that defines its
        // own is left alone. See `codegen/bridges.h`.
        if (pir_.freestanding) {
            emitStringBridge(ctx_, mod_);
            emitPointerSetBridge(ctx_, mod_);
        }
        // AFTER EVERY BODY EXISTS, because it walks instructions rather than lowering them.
        attachTBAA();
        dropUnusedDeclarations();
        // LAST, because it marks every function that EXISTS: a bare-metal target gets no red zone,
        // and the entry emitted just above is a function like any other. See `target.h` -- without
        // this the kernel booted its drivers, its network and its desktop and then span for ever
        // inside `Bytes.copy`, whose loop counter lived at `-0x20(%rsp)` where every timer tick
        // wrote the interrupt frame over it.
        applyBareMetalAttrs(mod_);
        // ...AND THE DEBUG METADATA IS CLOSED before the module is verified, or every temporary
        // node the builder made is still temporary and the verifier says so.
        endDebug();
        r_.ok = !llvm::verifyModule(mod_, &os);
        if (!r_.ok) {
            os.flush();
            r_.error = why;
        }
        return r_;
    }

private:
    // ---- what a program PUBLISHES ----
    //
    // Exactly one symbol: its entry. Everything else is an implementation detail of the executable,
    // and saying so is not an optimisation -- it is what keeps a program from colliding with the
    // libraries it links. A `.polb` built the ordinary way carries its own copy of the prelude and
    // of every generic it instantiated; a program that also published those met them at link time
    // as sixty `duplicate symbol: ArrayList$String.*`. Forge, an IDE that plugs in one library, was
    // the first program here big enough to have one.
    //
    // WHAT SURVIVES is the entry and the DECLARED foreign boundaries. An `unknown <world>` method
    // is a door the outside world knocks on -- `_start`, an ISR, `__polaron_malloc` written in
    // Polaron -- and internalizing one deletes the boundary its declaration promised. So is a
    // `cut` method, an interrupt handler, and anything the author gave a foreign `symbol`. The
    // trusted path keeps the same set for the same reasons (`stripDeadCode`).
    // §30: THE TABLE `unimport` READS TO FIND WHERE A METHOD'S CODE ENDS.
    //
    // There is no portable way to ask how long a function is, so the runtime is given every
    // function's address and finds the bounds of one by looking at the next. The lowering declares
    // the two globals when a program contains an `unimport` at all; filling them is this end's job,
    // because "every function in this module" is a question only the module can answer, and only
    // once every body has been emitted.
    //
    // WALK THE MODULE, not our own map: anything that ended up a declaration has no address to
    // record, and a null in the table is a bound of zero.
    void fillCodeTable() {
        llvm::GlobalVariable* base = mod_.getNamedGlobal("__polaron_code_base");
        llvm::GlobalVariable* count = mod_.getNamedGlobal("__polaron_code_count");
        if (base == nullptr || count == nullptr) {
            return;   // no `unimport` in this program, so no table was asked for
        }
        std::vector<llvm::Constant*> code;
        for (llvm::Function& f : mod_) {
            if (!f.isDeclaration()) {
                code.push_back(&f);
            }
        }
        auto* arrTy = llvm::ArrayType::get(llvm::PointerType::get(ctx_, 0), code.size());
        auto* arr = new llvm::GlobalVariable(mod_, arrTy, /*isConstant=*/true,
                                             llvm::GlobalValue::PrivateLinkage,
                                             llvm::ConstantArray::get(arrTy, code),
                                             "__polaron_code");
        base->setInitializer(arr);
        count->setInitializer(
            llvm::ConstantInt::get(llvm::Type::getInt64Ty(ctx_), code.size()));
    }

    void internalizeProgram() {
        if (pir_.library) {
            return;   // a library publishes its methods; that is what a library IS
        }
        std::set<std::string> keep{"main", "kmain"};
        for (const std::unique_ptr<Function>& f : pir_.functions) {
            // ...AND THE INTERRUPT ENTRY ITSELF, by its CONVENTION. `kind == Interrupt` marks the
            // handler's BODY; the `Class$interrupt` trampoline that the CPU actually vectors to is
            // a separate function, and nothing in the program calls it -- which is the point of it,
            // and also exactly what makes internalization plus DCE delete the one symbol the
            // declaration exists to produce.
            const bool boundary = f->conv == Conv::Unknown || f->conv == Conv::Naked ||
                                  f->conv == Conv::Interrupt || f->kind == FnKind::Interrupt ||
                                  f->cut;
            if (boundary || !f->symbol.empty()) {
                keep.insert(f->symbol.empty() ? f->key : f->symbol);
            }
        }
        for (llvm::Function& f : mod_.functions()) {
            if (f.isDeclaration() || f.hasLocalLinkage()) {
                continue;   // a declaration has nothing to publish; a local already publishes none
            }
            if (keep.count(f.getName().str()) == 0) {
                f.setLinkage(llvm::GlobalValue::InternalLinkage);
                ++r_.internalLinkage;
            }
        }
        for (llvm::GlobalVariable& g : mod_.globals()) {
            if (!g.isDeclaration() && !g.hasLocalLinkage()) {
                g.setLinkage(llvm::GlobalValue::InternalLinkage);
            }
        }
    }

    // ---- the C entry point ----
    //
    // A BACKEND CONCERN, not a lowering one. `Main.main` is a Polaron method like any other; `main`
    // is the symbol the operating system calls, with the C signature, and turning one into the other
    // is exactly the sort of thing a backend owns. The lowering has no business knowing that a
    // process starts at a function called `main` taking `argc` and `argv`.
    //
    // Without it the linker says "subsystem must be defined" -- an object with no entry point -- and
    // no program built through PIR could be run at all, which is the whole of what Stage 3's
    // differential has to do.
    void emitEntry() {
        if (mod_.getFunction("main") != nullptr) {
            return;
        }
        // A TARGET WITH NO C RUNTIME HAS NO `main(argc, argv)`. Nothing calls it -- the machine
        // jumps to whatever the linker script names, which for a kernel is its own `naked _start` --
        // and the shim built here does two things such an image cannot have: it asks the C library
        // for `strlen` to measure each argument, and it invents an entry nothing ever reaches. pico
        // linked against an undefined `strlen` for exactly that.
        //
        // FROM THE TRIPLE, never from the program's own word. A `freestanding` PROGRAM built for a
        // hosted machine still gets its `main`, because the CRT there is what calls it -- the suite
        // links a dozen such samples against a real one to run them, and deciding this from
        // `isFreestanding` left every one of them with no entry point.
        if (!hasCRuntime()) {
            return;
        }
        // `--test`: THE RUNNER IS THE ENTRY, and it is built after this backend finishes -- it can
        // only call functions that already exist. Emitting an ordinary `main` here would take the
        // name it needs, and would run the program instead of its tests.
        if (pir_.testRunnerEntry) {
            return;
        }
        llvm::Function* target = nullptr;
        for (const std::unique_ptr<Function>& f : pir_.functions) {
            if (f->key.size() > 5 && f->key.compare(f->key.size() - 5, 5, ".main") == 0 &&
                !f->blocks.empty()) {
                target = fns_.count(f->key) != 0 ? fns_[f->key] : nullptr;
                break;
            }
        }
        if (target == nullptr) {
            return;   // a library, not a program: nothing starts here
        }

        std::vector<llvm::Type*> argv{llvm::Type::getInt32Ty(ctx_), llvm::PointerType::get(ctx_, 0)};
        auto* mainTy = llvm::FunctionType::get(llvm::Type::getInt32Ty(ctx_), argv, false);
        auto* entry =
            llvm::Function::Create(mainTy, llvm::GlobalValue::ExternalLinkage, "main", mod_);
        auto* body = llvm::BasicBlock::Create(ctx_, "entry", entry);
        b_.SetInsertPoint(body);

        // The Polaron entry takes `string[] args`, and it gets the REAL ONES. Handing it a null
        // slice was a deliberate stand-in while the differential only compared programs that
        // ignore their arguments -- and `main_args`, which exists to prove they arrive, read its
        // length out of a null pointer and segfaulted before printing anything.
        // §32.5: EVERY CLASS'S `onClassLoad`, ONCE, BEFORE ANYTHING ELSE RUNS. The order is the
        // order the module recorded them in, which is declaration order -- a hook that depends on
        // another class's having run is a program that has to say so, not a program that gets to
        // rely on a walk order. Emitted here rather than in the lowering because "a process starts
        // at `main`" is exactly the kind of thing the backend owns.
        for (const Hook& h : pir_.init) {
            if (auto it = fns_.find(h.fnKey); it != fns_.end()) {
                b_.CreateCall(it->second);
            }
        }

        // ...BUT ONLY WHERE THERE IS AN ARGV TO MARSHAL. `main` exists because the triple says
        // something calls it; the array is built because the PROGRAM says something fills it, and
        // a `freestanding` one says the opposite. Built unconditionally, a static ELF with no libc
        // asked the linker for `__polaron_malloc` and `strlen` -- see `Module::freestanding`.
        const bool marshalsArgv = !pir_.freestanding;
        std::vector<llvm::Value*> args;
        for (unsigned i = 0; i < target->arg_size(); ++i) {
            llvm::Type* want = target->getArg(i)->getType();
            args.push_back(i == 0 && want->isPointerTy() && marshalsArgv
                               ? argvArray(entry->getArg(0), entry->getArg(1))
                               : llvm::Constant::getNullValue(want));
        }
        llvm::Value* got = b_.CreateCall(target, args);
        if (target->getReturnType()->isIntegerTy(32)) {
            b_.CreateRet(got);
        } else {
            b_.CreateRet(llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx_), 0));
        }
    }

    // `string[] args` OUT OF `int argc, char** argv`. One heap block whose first eight bytes are
    // the count, then one String object per argument -- the program's own name skipped, because
    // `args` is what was asked for and not what was typed. The same shape the trusted path builds,
    // because the program reading it is the same program.
    llvm::Value* argvArray(llvm::Value* argc, llvm::Value* argv) {
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        llvm::Type* ptr = llvm::PointerType::get(ctx_, 0);
        llvm::Function* fn = b_.GetInsertBlock()->getParent();

        llvm::Value* count = b_.CreateSub(b_.CreateSExt(argc, i64), llvm::ConstantInt::get(i64, 1));
        count = b_.CreateSelect(
            b_.CreateICmpSLT(count, llvm::ConstantInt::get(i64, 0)),
            llvm::ConstantInt::get(i64, 0), count);
        llvm::FunctionCallee alloc = mod_.getOrInsertFunction(
            "__polaron_malloc", llvm::FunctionType::get(ptr, {i64}, false));
        llvm::Value* total =
            b_.CreateAdd(llvm::ConstantInt::get(i64, kArrayHeader),
                         b_.CreateMul(count, llvm::ConstantInt::get(i64, 8)));
        llvm::Value* block = b_.CreateCall(alloc, {total}, "argv.arr");
        b_.CreateStore(count, block);
        llvm::Value* data = b_.CreateGEP(llvm::Type::getInt8Ty(ctx_), block,
                                         llvm::ConstantInt::get(i64, kArrayHeader));

        // `strlen` RETURNS size_t. On this target that is 64 bits and on a 32-bit one it is not, so
        // the result is widened rather than assumed -- a String's length field is 64 bits
        // everywhere, which is what makes the same String work on every target.
        llvm::FunctionCallee lengthOf = mod_.getOrInsertFunction(
            "strlen", llvm::FunctionType::get(i64, {ptr}, false));

        llvm::Value* at = b_.CreateAlloca(i64, nullptr, "argv.i");
        b_.CreateStore(llvm::ConstantInt::get(i64, 0), at);
        auto* test = llvm::BasicBlock::Create(ctx_, "argv.cond", fn);
        auto* copy = llvm::BasicBlock::Create(ctx_, "argv.body", fn);
        auto* done = llvm::BasicBlock::Create(ctx_, "argv.end", fn);
        b_.CreateBr(test);

        b_.SetInsertPoint(test);
        llvm::Value* i = b_.CreateLoad(i64, at, "argv.iv");
        b_.CreateCondBr(b_.CreateICmpSLT(i, count), copy, done);

        b_.SetInsertPoint(copy);
        llvm::Value* from = b_.CreateLoad(
            ptr, b_.CreateGEP(ptr, argv, b_.CreateAdd(i, llvm::ConstantInt::get(i64, 1))),
            "argv.s");
        llvm::Value* text = b_.CreateCall(alloc, {llvm::ConstantInt::get(i64, 24)}, "argv.str");
        b_.CreateStore(b_.CreateZExtOrTrunc(b_.CreateCall(lengthOf, {from}), i64), text);
        b_.CreateStore(from, b_.CreateGEP(llvm::Type::getInt8Ty(ctx_), text,
                                          llvm::ConstantInt::get(i64, 8)));
        b_.CreateStore(llvm::ConstantInt::get(i64, 0),
                       b_.CreateGEP(llvm::Type::getInt8Ty(ctx_), text,
                                    llvm::ConstantInt::get(i64, 16)));   // hash: not computed yet
        b_.CreateStore(text, b_.CreateGEP(ptr, data, i));
        b_.CreateStore(b_.CreateAdd(i, llvm::ConstantInt::get(i64, 1)), at);
        b_.CreateBr(test);

        b_.SetInsertPoint(done);
        return block;
    }

    // ---- types ----

    // `{ i32 tag, i64 payload }`, created once and reused. See `TypeKind::Variant`.
    llvm::StructType* variantStruct() {
        if (variant_ == nullptr) {
            variant_ = llvm::StructType::create(
                ctx_, {llvm::Type::getInt32Ty(ctx_), llvm::Type::getInt64Ty(ctx_)},
                "__polaron_variant");
        }
        return variant_;
    }
    llvm::StructType* variant_ = nullptr;

    // A PAYLOAD IS WIDENED TO A MACHINE WORD, whatever it was. Every case of a value variant
    // shares one slot, so the slot has to be the widest thing any of them puts there -- and what
    // the tag is FOR is knowing how to read it back. Pointers go through the integer, floats
    // through their bits; nothing is reinterpreted by accident because nothing is read without
    // first testing the tag.
    llvm::Value* variantEncode(llvm::Value* v) {
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        if (v == nullptr) {
            return llvm::ConstantInt::get(i64, 0);
        }
        llvm::Type* ty = v->getType();
        if (ty->isPointerTy()) {
            return b_.CreatePtrToInt(v, i64, "var.enc.p");
        }
        if (ty->isFloatingPointTy()) {
            llvm::Value* bits =
                b_.CreateBitCast(v, b_.getIntNTy(ty->getPrimitiveSizeInBits()), "var.enc.fb");
            return b_.CreateZExt(bits, i64, "var.enc.f");
        }
        return b_.CreateZExtOrTrunc(v, i64, "var.enc.i");
    }

    llvm::Value* variantDecode(llvm::Value* payload, llvm::Type* ty) {
        if (ty == nullptr || payload == nullptr) {
            return payload;
        }
        if (ty->isPointerTy()) {
            return b_.CreateIntToPtr(payload, ty, "var.dec.p");
        }
        if (ty->isFloatingPointTy()) {
            llvm::Value* bits =
                b_.CreateTrunc(payload, b_.getIntNTy(ty->getPrimitiveSizeInBits()), "var.dec.fb");
            return b_.CreateBitCast(bits, ty, "var.dec.f");
        }
        if (ty->isIntegerTy()) {
            return b_.CreateZExtOrTrunc(payload, ty, "var.dec.i");
        }
        return payload;
    }

    llvm::Type* llty(const Type* t) {
        if (t == nullptr) {
            return llvm::Type::getVoidTy(ctx_);
        }
        auto it = types_.find(t);
        if (it != types_.end()) {
            return it->second;
        }
        // A STRUCT IS REGISTERED BEFORE ITS BODY IS BUILT, and this is not a nicety.
        //
        // A class with a field of its own type -- a linked list node, a tree -- recurses forever if
        // the mapping is only made after `build` returns. It did: the first real program through
        // this backend segfaulted, and the stack was `build` -> `llty` -> `build` all the way down.
        // Creating the named struct empty, mapping it, then setting the body is the shape LLVM
        // provides `StructType::create` + `setBody` for, and it is the only one that terminates.
        if (t->kind == TypeKind::Struct) {
            auto* shell = llvm::StructType::create(ctx_, llvmNameFor(t));
            types_.emplace(t, shell);
            std::vector<llvm::Type*> parts;
            for (const Field& f : t->fields) {
                parts.push_back(llty(f.type));
            }
            if (parts.empty()) {
                // AN OPAQUE FORWARD REFERENCE, and pointer-sized rather than one byte. This was an
                // `i8` and cost nothing while `new T()` allocated a fixed eight bytes regardless;
                // the moment the allocation started asking the type how big it was, every class
                // whose fields this pass had not resolved shrank to a single byte and its
                // constructor wrote off the end. A class we cannot measure is at least a pointer.
                parts.push_back(llvm::PointerType::get(ctx_, 0));
            }
            shell->setBody(parts, t->packed);
            return shell;
        }
        llvm::Type* made = build(t);
        types_.emplace(t, made);
        return made;
    }

    llvm::Type* build(const Type* t) {
        switch (t->kind) {
            case TypeKind::Void:
                return llvm::Type::getVoidTy(ctx_);
            case TypeKind::Bool:
                return llvm::Type::getInt1Ty(ctx_);
            case TypeKind::Int:
                return llvm::Type::getIntNTy(ctx_, t->bits);
            case TypeKind::Addr:
                // AN ADDRESS IS A NUMBER, not a pointer, and PIR keeps them apart (§3.1). The
                // narrow forms are the point: `half address` is 32 bits of traffic per pointer
                // instead of 64, and that distinction is lost the moment both become `ptr`.
                return llvm::Type::getIntNTy(ctx_, t->bits);
            case TypeKind::Float:
                if (t->bits == 16) return llvm::Type::getHalfTy(ctx_);
                if (t->bits == 32) return llvm::Type::getFloatTy(ctx_);
                if (t->bits == 128) return llvm::Type::getFP128Ty(ctx_);
                return llvm::Type::getDoubleTy(ctx_);
            case TypeKind::Ptr:
            case TypeKind::Region:
            case TypeKind::Closure:
                return llvm::PointerType::get(ctx_, 0);
            case TypeKind::Array:
                // The INLINE form is the elements in place; the heap form is a pointer. §3.2 is the
                // whole reason these are two types rather than one with a flag somewhere else.
                if (t->storage == ArrayStorage::Inline) {
                    return llvm::ArrayType::get(llty(t->element), t->extent);
                }
                return llvm::PointerType::get(ctx_, 0);
            case TypeKind::Vector:
                // ONE REGISTER, N LANES. The whole reason `Vector` is a kind rather than a struct
                // of N floats is that this line can exist: the lane count is on the type, so the
                // translation is direct and the target's SIMD registers are reached without anyone
                // having to recognise a pattern.
                return llvm::FixedVectorType::get(llty(t->element), t->extent);
            case TypeKind::Slice:
                // A `T[]` IS A POINTER, not a {ptr,len} pair -- eight bytes of length header and
                // then the elements, which is exactly what the trusted path allocates and what the
                // runtime hands back. Representing it as a struct here made every array value a
                // different shape from the one the runtime produces, so nothing that crossed that
                // boundary worked: a program that filled an array and summed it printed nothing.
                //
                // The two representations HAD to agree; the trusted one is the one that already
                // does.
                return llvm::PointerType::get(ctx_, 0);
            case TypeKind::Struct: {
                std::vector<llvm::Type*> parts;
                for (const Field& f : t->fields) {
                    parts.push_back(llty(f.type));
                }
                if (parts.empty()) {
                    parts.push_back(llvm::Type::getInt8Ty(ctx_));   // an opaque forward reference
                }
                return llvm::StructType::create(ctx_, parts, llvmNameFor(t));
            }
            case TypeKind::Variant: {
                // ONE NAMED STRUCT FOR EVERY VALUE VARIANT, and it is named on purpose: a
                // `Result<int,int>` crosses between code compiled by both back ends, so the shape
                // has to be the one the other path spells -- `%__polaron_variant = { i32, i64 }`,
                // a tag and a payload widened to a machine word. An anonymous struct is the same
                // bytes with a different name, and a differential compares the text.
                return variantStruct();
            }
            case TypeKind::Fn: {
                std::vector<llvm::Type*> params;
                for (const Field& f : t->fields) {
                    params.push_back(llty(f.type));
                }
                return llvm::FunctionType::get(llty(t->element), params, false);
            }
        }
        return llvm::Type::getVoidTy(ctx_);
    }

    // ---- globals ----

    void emitGlobal(const Global& g) {
        // A VTABLE, when the global carries a function table: an array of pointers, one per
        // dispatch slot, null where the class provides no body for that slot. Emitted with the
        // other globals so `vtable.load` can name it -- which is what verifier rule 15 checks and
        // what stops "the table was never emitted" from being a link error.
        if (!g.initFns.empty()) {
            llvm::PointerType* p = llvm::PointerType::get(ctx_, 0);
            llvm::ArrayType* at = llvm::ArrayType::get(p, g.initFns.size());
            std::vector<llvm::Constant*> slots;
            slots.reserve(g.initFns.size());
            for (const std::string& key : g.initFns) {
                auto it = fns_.find(key);
                slots.push_back(key.empty() || it == fns_.end()
                                    ? llvm::Constant::getNullValue(p)
                                    : llvm::cast<llvm::Constant>(it->second));
            }
            // CONSTANT ONLY IF NOTHING WRITES IT. Almost every table is, and saying so is what lets
            // a devirtualisation read an entry straight out of it. A class whose method some
            // `methods.replace` rewrites (§32.8) is the exception, and the lowering clears the flag
            // for exactly those -- hardcoding `true` here put such a table in `.rdata`, where the
            // patch is a write to read-only memory and the program dies at the first replace.
            auto* table = new llvm::GlobalVariable(mod_, at, g.isConst,
                                                   llvm::GlobalValue::PrivateLinkage,
                                                   llvm::ConstantArray::get(at, slots), g.name);
            table->setAlignment(llvm::Align(8));
            ++r_.internalLinkage;
            return;
        }
        // A BLOCK OF BYTES from `embed("file")`: `[i64 length | bytes...]`, the layout every Polaron
        // array has, so the same `.length()` and the same indexing work on it. Emitted as its own
        // struct type rather than through `llty`, because the length word is part of the VALUE here
        // and not part of the declared element type.
        if (g.hasBytes) {
            llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
            llvm::Constant* data = llvm::ConstantDataArray::get(
                ctx_, llvm::ArrayRef<uint8_t>(g.initBytes.data(), g.initBytes.size()));
            llvm::StructType* blockTy = llvm::StructType::get(ctx_, {i64, data->getType()});
            auto* block = new llvm::GlobalVariable(
                mod_, blockTy, g.isConst, linkageOf(g.linkage),
                llvm::ConstantStruct::get(
                    blockTy, {llvm::ConstantInt::get(i64, g.initBytes.size()), data}),
                g.name);
            block->setAlignment(llvm::Align(8));
            ++r_.alignAttrs;
            if (g.linkage == Linkage::Internal || g.linkage == Linkage::Private) {
                ++r_.internalLinkage;
            }
            return;
        }
        llvm::Type* t = llty(g.type);
        // THE INITIAL VALUE, when there is one. Everything was zero-initialised, so `static fixed
        // int MAX = 100;` read back as 0 -- a constant whose value the compiler had and dropped.
        llvm::Constant* init = llvm::Constant::getNullValue(t);
        if (!g.zeroInit) {
            if (t->isIntegerTy()) {
                init = llvm::ConstantInt::get(t, g.initInt, true);
            } else if (t->isFloatingPointTy()) {
                init = llvm::ConstantFP::get(t, g.initFloat);
            }
        }
        auto* gv = new llvm::GlobalVariable(mod_, t, g.isConst, linkageOf(g.linkage), init, g.name);
        if (g.linkage == Linkage::Internal || g.linkage == Linkage::Private) {
            ++r_.internalLinkage;
        }
        gv->setAlignment(llvm::Align(g.type != nullptr ? std::max<uint32_t>(1, g.type->facts.align)
                                                       : 1));
        ++r_.alignAttrs;
    }

    static llvm::GlobalValue::LinkageTypes linkageOf(Linkage l) {
        switch (l) {
            case Linkage::Public:
            case Linkage::External:
                return llvm::GlobalValue::ExternalLinkage;
            case Linkage::Internal:
            case Linkage::Private:
                return llvm::GlobalValue::InternalLinkage;
        }
        return llvm::GlobalValue::ExternalLinkage;
    }

    // `stdcall` AND `fastcall` ARE REAL ON 32-BIT x86 AND NOWHERE ELSE. There the callee cleans the
    // stack and the symbol is decorated `@N`, or the first two integer arguments ride in ECX and
    // EDX -- which is how every Win32 entry point is called on i686. On x86-64 all three
    // conventions collapsed onto the one platform ABI long ago, so the word costs nothing there and
    // writing `x86_stdcallcc` on a 64-bit function states something untrue about it. The trusted
    // path gates on the architecture for the same reason (`worldToCallConv`), and this one did not:
    // `codegen_stdcall_is_nothing_on_x86_64` exists to say that the word is accepted everywhere and
    // has instructions to change in exactly one place.
    llvm::CallingConv::ID convOf(Conv c) const {
        const bool x86_32 = llvm::Triple(mod_.getTargetTriple()).getArch() == llvm::Triple::x86;
        switch (c) {
            case Conv::Stdcall:
                return x86_32 ? llvm::CallingConv::X86_StdCall : llvm::CallingConv::C;
            case Conv::Fastcall:
                return x86_32 ? llvm::CallingConv::X86_FastCall : llvm::CallingConv::C;
            // AN INTERRUPT HANDLER IS AN X86 CALLING CONVENTION, not a Polaron one. `x86_intrcc` is
            // what makes LLVM write the save of every register the body clobbers, the `cld`, the
            // pop of a pushed error code and the `iretq`. Mapped to `C` here, the entry the
            // declaration exists to produce was an ordinary function: it returned with `ret`, on a
            // stack the CPU had laid out for `iret`.
            case Conv::Interrupt: return llvm::CallingConv::X86_INTR;
            default:             return llvm::CallingConv::C;
        }
    }

    // An atomic access is aligned to its own width, which is what makes it atomic at all. Both
    // spellings are here because the store and the RMW know their operand's LLVM type while the
    // load knows only the PIR type it is producing.
    static llvm::Align atomicAlign(const Type* t) {
        const unsigned bytes = t != nullptr && t->bits > 0 ? t->bits / 8 : 8;
        return llvm::Align(bytes > 0 ? bytes : 1);
    }
    static llvm::Align atomicAlign(llvm::Type* t) {
        const unsigned bits = t != nullptr ? t->getPrimitiveSizeInBits() : 64;
        return llvm::Align(bits >= 8 ? bits / 8 : 8);
    }

    // ---- functions ----

    // `size_t` IS THE TARGET'S, AND ON WASM IT IS THIRTY-TWO BITS.
    //
    // The lowering spells a length `i64` because that is what a length is on the machines this was
    // written on. On `wasm32` the C runtime's `memset` takes `(i32, i32, i32)`, and the two
    // signatures do not merely differ in a way the optimiser can smooth over: WebAssembly CHECKS
    // signatures, so `wasm-ld` reconciled the mismatch by replacing the call with a trap. The
    // module then instantiated, ran, and answered `FAILED: unreachable` -- a page that fails at the
    // first `Screen.put` for reasons that appear nowhere except a link-time warning.
    //
    // Only the three byte-movers, because they are the only externals whose length parameter the
    // lowering names itself. Anything the program declares carries the type its author wrote.
    llvm::FunctionType* withTargetSize(const std::string& symbol, llvm::FunctionType* ft) const {
        const bool byteMover = symbol == "memcpy" || symbol == "memset" || symbol == "memmove";
        const unsigned bits = mod_.getDataLayout().getPointerSizeInBits(0);
        if (!byteMover || bits >= 64 || ft->getNumParams() != 3) {
            return ft;
        }
        std::vector<llvm::Type*> ps(ft->param_begin(), ft->param_end());
        if (!ps[2]->isIntegerTy()) {
            return ft;
        }
        ps[2] = llvm::Type::getIntNTy(ctx_, bits);
        return llvm::FunctionType::get(ft->getReturnType(), ps, ft->isVarArg());
    }

    void declare(const Function& f) {
        auto* ft = llvm::cast<llvm::FunctionType>(llty(f.signature));
        ft = withTargetSize(f.symbol.empty() ? f.key : f.symbol, ft);
        if (f.variadic) {
            // `printf(fmt, ...)`. The interned type cannot carry this -- variadicity is a property
            // of the CALL CONVENTION, not of the parameter list -- so it travels on the function.
            std::vector<llvm::Type*> ps(ft->param_begin(), ft->param_end());
            ft = llvm::FunctionType::get(ft->getReturnType(), ps, true);
        }
        // THE FOREIGN SYMBOL WINS. An `extern printf` is the C `printf`; emitting it under its
        // Polaron key produces an undefined symbol at link time named after something that was
        // never supposed to exist. §6 keeps the two apart precisely so this cannot be confused.
        const std::string emitted = f.symbol.empty() ? f.key : f.symbol;
        // TWO KEYS CAN NAME ONE SYMBOL, and only on this side of the boundary. `Sockets.close` and
        // `Files.close` may each bind the C `close`; the prelude declares `printf` as an extern
        // method while the console lowering asks for `printf` directly. `Function::Create` does not
        // refuse a name the module already carries -- it RENAMES, to `close.1`, and that binding
        // then links against a symbol no library defines. Looking first is the whole fix.
        llvm::Function* fn = mod_.getFunction(emitted);
        if (fn == nullptr) {
            fn = llvm::Function::Create(ft, linkageOf(f.linkage), emitted, mod_);
            fn->setCallingConv(convOf(f.conv));
            // ...AND `x86_intrcc` NEEDS `byval` ON THE FRAME. It is not decoration: it is how the
            // convention is told how much stack the CPU's frame occupies, and LLVM refuses the
            // convention without it. The frame is the handler's declared `Trap`; a handler that
            // declares none gets the five words x86-64 pushes -- rip, cs, rflags, rsp, ss -- so
            // the size is right either way.
            if (f.conv == Conv::Interrupt && fn->arg_size() >= 1 &&
                fn->getArg(0)->getType()->isPointerTy()) {
                llvm::Type* frame = nullptr;
                if (f.signature != nullptr && !f.signature->fields.empty()) {
                    const Type* declared = f.signature->fields.front().type;
                    if (declared != nullptr && declared->kind == TypeKind::Struct) {
                        frame = llty(declared);
                    } else if (!f.params.empty()) {
                        const Type* named = pir_.types.structNamed(
                            cgutil::baseType(ast::stripNullable(f.params.front().typeName)));
                        frame = named != nullptr ? llty(named) : nullptr;
                    }
                }
                if (frame == nullptr) {
                    llvm::Type* word = llvm::Type::getInt64Ty(ctx_);
                    frame = llvm::StructType::get(ctx_, {word, word, word, word, word});
                }
                fn->addParamAttr(0, llvm::Attribute::getWithByValType(ctx_, frame));
            }
        }
        fns_.emplace(f.key, fn);

        // ---- §12, the hand-off table, one row at a time ----
        //
        // Every one of these is a fact PIR already held and the old lowering threw away. None of
        // them is a guess: each reads a field that the front end decided and the verifier checked.
        if (f.linkage == Linkage::Internal || f.linkage == Linkage::Private) {
            ++r_.internalLinkage;   // ...which is what lets LLVM inline and devirtualise in-bundle
        }
        // A NAKED BODY IS RAW ASSEMBLY AND THE COMPILER KNOWS NOTHING ABOUT IT. `nounwind` is a
        // claim -- "control cannot leave this function by unwinding" -- and there is no body here
        // to have read: the instructions are whatever the programmer wrote, and they may well jump
        // into something that unwinds. The trusted path asserts nothing about a naked function for
        // the same reason, and `codegen_naked_has_no_prologue` pins the whole attribute set because
        // an attribute nobody asked for on a function nobody compiled is exactly the kind of claim
        // that is discovered by a machine behaving strangely rather than by a test.
        if (f.unwind == Unwind::Never && f.conv != Conv::Naked) {
            fn->addFnAttr(llvm::Attribute::NoUnwind);
            ++r_.nounwind;
        }
        if (f.pure) {
            // WRITES NOTHING is the fact; TOUCHES NOTHING is a second, stronger one, and only the
            // function that never loads has earned it. `speculatable` goes with the strong one for
            // the same reason: speculating a call that reads memory can fault on an address the
            // program would never have reached.
            if (f.readsMemory) {
                fn->setOnlyReadsMemory();
            } else {
                fn->setDoesNotAccessMemory();
                fn->addFnAttr(llvm::Attribute::Speculatable);
            }
            fn->addFnAttr(llvm::Attribute::WillReturn);
            ++r_.pureAttrs;
        }
        if (f.affinity == Affinity::Cold) {
            fn->addFnAttr(llvm::Attribute::Cold);
            ++r_.coldAttrs;
        }
        if (f.noReturn) {
            fn->addFnAttr(llvm::Attribute::NoReturn);
        }
        if (f.inlineAlways) {
            fn->addFnAttr(llvm::Attribute::AlwaysInline);
        }
        if (f.inlineNever) {
            fn->addFnAttr(llvm::Attribute::NoInline);
        }
        // `naked` IS NOT IN THIS LIST. A naked function emits no prologue at all, so it neither
        // uses the red zone nor can be made to; adding the attribute changed nothing about the
        // code and did change what the module SAYS, which is the thing the two backends are being
        // held to. Bare metal already gets it on every function -- see `applyBareMetalAttrs`, which
        // is where the rule actually belongs, because there it is a property of the TARGET.
        if (f.noRedZone || f.conv == Conv::Interrupt) {
            fn->addFnAttr(llvm::Attribute::NoRedZone);
        }
        if (f.conv == Conv::Naked) {
            fn->addFnAttr(llvm::Attribute::Naked);
            // ...AND IT IS NEVER INLINED AND NEVER TOUCHED. A naked body is raw assembly that owns
            // the machine state as the hardware handed it over; there is nothing in it for an
            // optimiser to be right about. Marked `naked` alone, the inliner was free to paste it
            // into its callers -- and pico's `resume_switched` carries a local label, so the
            // assembler saw `.Lresume_kernel` defined twice in one file and refused the kernel.
            // The trusted path has always added both, one line below the same comment.
            fn->addFnAttr(llvm::Attribute::NoInline);
            fn->addFnAttr(llvm::Attribute::OptimizeNone);
        }

        // THE RETURNED POINTER IS AN OBJECT TOO, and saying so is worth more than saying it about a
        // parameter: a parameter's promise helps the callee, while this one helps every CALLER.
        // `Grid.cellAt(x, y)` returns a `Cell`, the language says a non-nullable return is never
        // null, and without the attribute each caller re-tested the pointer it had just been handed
        // -- a compare and a branch per call, none of which can ever be taken.
        if (fn->getReturnType()->isPointerTy() && !f.returnTypeName.empty() &&
            !ast::typeIsNullable(f.returnTypeName)) {
            fn->addRetAttr(llvm::Attribute::NonNull);
            ++r_.nonnull;
            if (const Type* gives = pointeeOfParam(f.returnTypeName);
                gives != nullptr && gives->facts.size > 0) {
                fn->addRetAttr(
                    llvm::Attribute::getWithDereferenceableBytes(ctx_, gives->facts.size));
                ++r_.dereferenceable;
                fn->addRetAttr(llvm::Attribute::getWithAlignment(
                    ctx_, llvm::Align(std::max<uint32_t>(1, gives->facts.align))));
                ++r_.alignAttrs;
            }
        }

        // ...and the parameters. A pointer parameter whose type is unique never aliases; a
        // non-nullable one is never null; every one of them is dereferenceable and aligned by the
        // amount the type table already knows.
        //
        // (`pointeeOfParam` is below; the attributes it feeds are promises, so read its refusals
        // before adding a caller.)
        // ...BUT NOT ON AN INTERRUPT FRAME. The one parameter of an `x86_intrcc` entry is the stack
        // the CPU laid out, passed `byval`; it is not an object handed over by a caller, and there
        // is no caller. `nonnull dereferenceable align` on it says nothing true that `byval` does
        // not already say, and it made the entry read differently from the one the other backend
        // emits -- which two tests pin, because the shape of an interrupt entry is a promise to the
        // hardware and not an implementation detail.
        if (f.signature != nullptr && f.conv != Conv::Interrupt) {
            for (unsigned i = 0; i < f.signature->fields.size() && i < fn->arg_size(); ++i) {
                const Type* pt = f.signature->fields[i].type;
                if (pt == nullptr) {
                    continue;
                }
                // ONLY ON A POINTER. `noalias`, `nonnull`, `align` and `dereferenceable` are
                // statements about an ADDRESS; LLVM rejects them on a struct passed by value, and
                // it was right to -- the PIR kind says what the parameter IS, and the question here
                // is how it TRAVELS. Asking the emitted type is asking the right one.
                if (!fn->getArg(i)->getType()->isPointerTy()) {
                    continue;
                }
                // WHAT THE POINTER POINTS AT, recovered from the declaration.
                //
                // `pt` here is the one opaque `ptr` entry, shared by every pointer in the module,
                // and its facts are the facts of no class at all: size 0, align 1, not unique. Two
                // of §12's rows were being decided from it -- `noalias` asked `ptr->facts.isUnique`
                // and `dereferenceable` asked `ptr->kind == Struct` -- so both were structurally
                // incapable of firing, and the table printed `noalias=0 deref=0` for every program
                // ever compiled through this path. Not a missing implementation: a question asked
                // of the wrong type.
                //
                // The parameter's WRITTEN name is the way back to the class. It is stripped to a
                // bare name and looked up, and everything below then reads the class's own facts.
                const std::string written =
                    i < f.params.size() ? f.params[i].typeName : std::string();
                const Type* pointee = pointeeOfParam(written);
                // `unique` -- AT MOST ONE LIVE REFERENCE (spec 19.9), which is exactly what
                // `noalias` claims and the strongest single thing an alias analysis can be told.
                if (pointee != nullptr && pointee->facts.isUnique) {
                    fn->addParamAttr(i, llvm::Attribute::NoAlias);
                    ++r_.noalias;
                }
                // ...EXCEPT THE ONE THE LANGUAGE SAYS MAY BE ABSENT. The comment above says "a
                // non-nullable one is never null" and the code said it of every pointer, `nullable`
                // included -- so the optimiser was told a `nullable Desktop* shell` could not be
                // null and deleted the check the author wrote. An attribute is a PROMISE; one that
                // is not true is not an optimisation, it is a miscompile waiting for -O2.
                const bool mayBeAbsent =
                    i < f.params.size() && ast::typeIsNullable(f.params[i].typeName);
                if (!mayBeAbsent) {
                    fn->addParamAttr(i, llvm::Attribute::NonNull);
                    ++r_.nonnull;
                }
                // `dereferenceable(N)` IMPLIES NON-NULL, so it carries the same promise and the
                // same exemption: a pointer that may be absent is not N bytes of readable memory.
                //
                // It buys speculation. A load LLVM can prove is dereferenceable may be hoisted out
                // of a branch or a loop even when the branch is not known to be taken -- which is
                // what turns a field read inside an `if` into a read before it.
                if (!mayBeAbsent && pointee != nullptr && pointee->facts.size > 0) {
                    fn->addParamAttr(i, llvm::Attribute::getWithDereferenceableBytes(
                                            ctx_, pointee->facts.size));
                    ++r_.dereferenceable;
                }
                // THE CLASS'S ALIGNMENT WHEN THERE IS A CLASS, and the pointer's otherwise. Every
                // object of a class is allocated at that class's alignment, by every one of the
                // three storage branches; saying so lets a copy become wider moves.
                const uint32_t align = pointee != nullptr && pointee->facts.align > 0
                                           ? pointee->facts.align
                                           : pt->facts.align;
                fn->addParamAttr(i, llvm::Attribute::getWithAlignment(
                                        ctx_, llvm::Align(std::max<uint32_t>(1, align))));
                ++r_.alignAttrs;
            }
        }
    }

    // WHAT AN LLVM STRUCT FOR THIS PIR TYPE IS CALLED.
    //
    // A class is `class.<Name>`, which is the spelling the other backend has always used and which
    // several tests assert on -- `%class.RealModePointer = type { i16, i16 }` is how the narrow
    // address layout is pinned. Two paths that spell one class two ways are two paths that disagree
    // about their own output, and the disagreement surfaces the moment either becomes the default.
    //
    // Everything else keeps its own name: a tuple, a closure environment, `WeakSlot` -- shapes the
    // lowering built rather than shapes the author declared.
    std::string llvmNameFor(const Type* t) const {
        if (t == nullptr || t->name.empty()) {
            return "anon";
        }
        return pir_.classes.count(t->name) != 0 ? "class." + t->name : t->name;
    }

    // THE CLASS A PARAMETER'S POINTER POINTS AT, from the type as the author wrote it -- or null,
    // which is the answer whenever anything about the spelling makes the claim less than certain.
    //
    // Everything this returns becomes a PROMISE to the optimiser, so every refusal below is a case
    // where the promise would be false, not merely unproven:
    //
    //   `Box**`     -- the pointer points at a POINTER, eight bytes, not at a Box. Claiming
    //                  `dereferenceable(sizeof(Box))` on it says the callee may read a Box's worth
    //                  of memory from a slot that holds an address, and at -O2 that read happens.
    //   `Box[]`     -- an array parameter is a slice header, not an object.
    //   `int`, ...  -- a primitive that arrived as a pointer did so because it is `&`-taken or
    //                  out-parameterised; its size is not a class's size.
    //   generics    -- an uninstantiated `T` names nothing the table can measure.
    //
    // A trailing `&` is kept: `Box& b` is a reference to a Box and points at a whole one. A leading
    // `nullable ` is stripped here and handled by the caller, which needs to know about it anyway.
    const Type* pointeeOfParam(const std::string& written) const {
        if (written.empty()) {
            return nullptr;
        }
        std::string name = ast::stripNullable(written);
        if (!name.empty() && name.back() == '&') {
            name.pop_back();
        }
        // AT MOST ONE LEVEL OF INDIRECTION. `Box*` and `Box` both arrive as a pointer to a Box;
        // `Box**` does not.
        if (!name.empty() && name.back() == '*') {
            name.pop_back();
        }
        if (name.empty() || name.back() == '*' || name.back() == ']') {
            return nullptr;
        }
        const Type* pointee = pir_.types.structNamed(name);
        // A CLASS WITH NO MEASURED SIZE IS A CLASS THE LOWERING NEVER LAID OUT -- an interface, a
        // forward mention nothing completed. It has no facts to lend.
        if (pointee == nullptr || pointee->kind != TypeKind::Struct) {
            return nullptr;
        }
        return pointee;
    }

    // ---- `-g`: DWARF ----
    //
    // The metadata a debugger needs is four things, and PIR already carries the source of all four:
    // a compile unit for the module, a subprogram per function, a location per instruction, and a
    // local variable per named `alloca`. Assembled here rather than in the lowering because DWARF
    // is LLVM's vocabulary, not the language's -- the same reason the calling convention and the
    // exception model are decided at this end.
    //
    // MINIMAL TYPES, deliberately, and the trusted path does the same: every subprogram gets the
    // same one-element signature and every local the same `int`. A debugger that can stop on a line
    // and name the variable in scope is most of what `-g` is for, and inventing a full DWARF type
    // graph for a language with generics, regions and value classes is a project of its own that
    // neither backend has done. What is here is honest about being a line table.
    void beginDebug() {
        if (!pir_.debugInfo) {
            return;
        }
        dib_ = std::make_unique<llvm::DIBuilder>(mod_);
        llvm::DIFile* main = debugFile(mod_.getName().str());
        diCu_ = dib_->createCompileUnit(llvm::dwarf::DW_LANG_C, main, "polc",
                                        /*isOptimized=*/false, /*flags=*/"", /*runtimeVersion=*/0);
        diInt_ = dib_->createBasicType("int", 32, llvm::dwarf::DW_ATE_signed);
        mod_.addModuleFlag(llvm::Module::Warning, "Debug Info Version", llvm::DEBUG_METADATA_VERSION);
        mod_.addModuleFlag(llvm::Module::Warning, "Dwarf Version", 4);
    }

    void endDebug() {
        if (dib_) {
            // WITHOUT THIS THE METADATA IS UNFINISHED and LLVM refuses the module: every temporary
            // node the builder made stays temporary, which reads as corruption rather than as a
            // missing call.
            dib_->finalize();
        }
    }

    llvm::DIFile* debugFile(const std::string& path) {
        auto found = diFiles_.find(path);
        if (found != diFiles_.end()) {
            return found->second;
        }
        std::string dir;
        std::string name = path.empty() ? std::string("<polaron>") : path;
        if (const size_t cut = name.find_last_of("/\\"); cut != std::string::npos) {
            dir = name.substr(0, cut);
            name = name.substr(cut + 1);
        }
        llvm::DIFile* file = dib_->createFile(name, dir);
        diFiles_[path] = file;
        return file;
    }

    // The line a function starts on, which PIR does not record directly: the first instruction that
    // carries one is the closest true answer, and line 1 the fallback when none does.
    static unsigned firstLineOf(const Function& f) {
        for (const Block& b : f.blocks) {
            for (const Inst& in : b.insts) {
                if (in.loc.line > 0) {
                    return static_cast<unsigned>(in.loc.line);
                }
            }
        }
        return 1;
    }

    static std::string fileOf(const Function& f) {
        for (const Block& b : f.blocks) {
            for (const Inst& in : b.insts) {
                if (in.loc.line > 0 && !std::string(in.loc.file).empty()) {
                    return std::string(in.loc.file);
                }
            }
        }
        return {};
    }

    void beginDebugFunction(const Function& f, llvm::Function* fn) {
        diScope_ = nullptr;
        if (!dib_) {
            return;
        }
        llvm::DIFile* file = debugFile(fileOf(f));
        const unsigned line = firstLineOf(f);
        llvm::SmallVector<llvm::Metadata*, 1> elts{diInt_};
        llvm::DISubprogram* sp = dib_->createFunction(
            file, fn->getName(), fn->getName(), file, line,
            dib_->createSubroutineType(dib_->getOrCreateTypeArray(elts)), line,
            llvm::DINode::FlagPrototyped, llvm::DISubprogram::SPFlagDefinition);
        fn->setSubprogram(sp);
        diScope_ = sp;
    }

    // Every instruction that knows where it came from says so. An instruction that does NOT know
    // keeps the function's own line rather than none: LLVM requires that every instruction in a
    // function with a subprogram either has a location or is not `inlinable`, and a debugger
    // stepping through a gap with no line reports the previous one anyway.
    void setDebugLoc(const SourceLocation& loc) {
        if (diScope_ == nullptr) {
            return;
        }
        const unsigned line =
            loc.line > 0 ? static_cast<unsigned>(loc.line) : diScope_->getLine();
        const unsigned col = loc.col > 0 ? static_cast<unsigned>(loc.col) : 1;
        b_.SetCurrentDebugLocation(llvm::DILocation::get(ctx_, line, col, diScope_));
    }

    void clearDebugLoc() { b_.SetCurrentDebugLocation(llvm::DebugLoc()); }

    // A NAMED SLOT IS A VARIABLE THE DEBUGGER CAN PRINT. `llvm.dbg.declare` binds the name to the
    // storage; without it a debugger stopped on the right line has no idea what `count` is.
    void declareDebugLocal(const Inst& in, llvm::Value* slot) {
        if (diScope_ == nullptr || slot == nullptr || in.text.empty()) {
            return;
        }
        // The compiler's own temporaries are not the programmer's variables. They are spelled with
        // a dot, which no Polaron identifier may contain, so the test is exact rather than a guess.
        if (in.text.find('.') != std::string::npos || in.text.find('$') != std::string::npos) {
            return;
        }
        llvm::DIFile* file = diScope_->getFile();
        const unsigned line =
            in.loc.line > 0 ? static_cast<unsigned>(in.loc.line) : diScope_->getLine();
        llvm::DILocalVariable* var = dib_->createAutoVariable(diScope_, in.text, file, line, diInt_);
        dib_->insertDeclare(slot, var, dib_->createExpression(),
                            llvm::DILocation::get(ctx_, line, 1, diScope_),
                            b_.GetInsertBlock());
    }

    void define(const Function& f) {
        llvm::Function* fn = fns_[f.key];
        if (fn == nullptr) {
            return;
        }
        vals_.clear();
        fromSlot_.clear();
        blocks_.clear();
        beginDebugFunction(f, fn);

        for (const Block& b : f.blocks) {
            blocks_[b.id] = llvm::BasicBlock::Create(ctx_, b.label, fn);
        }

        // BLOCK ARGUMENTS BECOME PHI NODES, and this is the whole cost of §1.2's choice: one
        // mechanical translation, here, at the boundary. Everything above never has to keep a phi's
        // operand order in step with a predecessor list.
        std::unordered_map<ValueId, llvm::PHINode*> phis;
        for (const Block& b : f.blocks) {
            b_.SetInsertPoint(blocks_[b.id]);
            if (b.id == f.blocks.front().id) {
                // The entry block's parameters are the function's arguments, not phis.
                unsigned i = 0;
                for (ValueId p : b.params) {
                    if (i < fn->arg_size()) {
                        vals_[p] = fn->getArg(i);
                    }
                    ++i;
                }
                continue;
            }
            for (ValueId p : b.params) {
                const ValueDef* d = f.value(p);
                auto* phi = b_.CreatePHI(llty(d != nullptr ? d->type : nullptr), 0);
                phis[p] = phi;
                vals_[p] = phi;
            }
        }

        for (const Block& b : f.blocks) {
            llvm::BasicBlock* bb = blocks_[b.id];
            if (bb == nullptr) {
                continue;
            }
            // AT THE END, always. `getFirstNonPHI` on a block that is nothing but phis returns the
            // end iterator, and setting the insert point from it is a crash. Appending is correct
            // in every case: the phis are already there and everything else goes after them.
            b_.SetInsertPoint(bb);
            // ONE PIR BLOCK CAN BECOME SEVERAL LLVM BLOCKS. A guard splits it -- check, cold exit,
            // continuation -- so the block a branch LEAVES from is no longer the block it started
            // in. Everything downstream that names a predecessor has to name the tail, and the phi
            // wiring below did not: it used the head, and LLVM answered "PHI node entries do not
            // match predecessors". Recorded here, updated by whoever splits.
            tail_[b.id] = bb;
            emittingBlock_ = b.id;
            for (const Inst& in : b.insts) {
                // ONCE THE BLOCK HAS ENDED, IT HAS ENDED. An instruction after a terminator is
                // unreachable by definition, and emitting it puts a second terminator in the block
                // -- a module LLVM rejects outright, taking every function in it down with it.
                //
                // That is what happened to `await`: the lowering wrote `raise` and then a redundant
                // `unreachable`, the backend's own `unreachable` was already there, and every
                // `async` sample failed to build. This is a property of the CONTAINER rather than of
                // any one opcode, so it is checked here rather than trusted to each caller -- and
                // the two `raise` sites that had it wrong were not the same two that had it right.
                if (llvm::BasicBlock* at = tail_[b.id];
                    at != nullptr && at->getTerminator() != nullptr) {
                    break;
                }
                setDebugLoc(in.loc);
                emitInst(f, b, in);
            }
            clearDebugLoc();
            llvm::BasicBlock* endsAt = tail_[b.id];
            if (endsAt->getTerminator() == nullptr) {
                b_.SetInsertPoint(endsAt);
                b_.CreateUnreachable();
            }
        }

        // The phi incomings, once every block's values exist.
        for (const Block& b : f.blocks) {
            for (const Inst& in : b.insts) {
                for (const Edge& e : in.edges) {
                    const Block* target = f.block(e.target);
                    if (target == nullptr) {
                        continue;
                    }
                    for (size_t k = 0; k < e.args.size() && k < target->params.size(); ++k) {
                        auto it = phis.find(target->params[k]);
                        if (it == phis.end()) {
                            continue;
                        }
                        // COERCED TO THE PHI'S TYPE, like every other boundary in this backend. A
                        // block argument can arrive as an `i32` where the block declares a `bool`
                        // while the lowering's type propagation is still incomplete, and a phi whose
                        // operands disagree with its result is a module LLVM refuses outright.
                        // THE TAIL, not the head -- see `tail_`. A block a guard has split ends
                        // somewhere other than where it began, and a phi that names the wrong
                        // predecessor is a module LLVM refuses.
                        llvm::BasicBlock* from =
                            tail_.count(b.id) != 0 ? tail_[b.id] : blocks_[b.id];
                        b_.SetInsertPoint(from->getTerminator());
                        llvm::Value* v = coerce(valueOf(e.args[k]), it->second->getType());
                        it->second->addIncoming(v, from);
                    }
                }
            }
        }
    }

    llvm::Value* valueOf(ValueId v) {
        auto it = vals_.find(v);
        return it != vals_.end() ? it->second : nullptr;
    }

    llvm::Value* operand(const Inst& in, size_t i) {
        return i < in.operands.size() ? valueOf(in.operands[i]) : nullptr;
    }

    // LOOKED UP, NEVER `operator[]`. A map's `[]` inserts a null for a key it does not have, and a
    // null basic block handed to `CreateBr` is a crash rather than a diagnosis. The verifier already
    // refuses a branch to a block that does not exist (rule 3); this is the backend refusing to
    // trust that it ran.
    // TWO INTEGER OPERANDS OF THE SAME TYPE, or nothing.
    //
    // The IRBuilder asserts on a mismatch, and an assertion in a Release build is not a message --
    // it is undefined behaviour and then a segmentation fault with no stack worth reading. That is
    // exactly what the first real program through this backend produced.
    //
    // The lowering still has gaps (it says so, counted), so a value whose type it could not work
    // out reaches here as something this instruction cannot take. The backend's job is to notice
    // rather than to crash: the result becomes `undef`, the module still verifies, and the
    // difference shows up where Stage 2 is meant to show it -- in the differential test against the
    // old path.
    bool intPair(const Inst& in, llvm::Value** l, llvm::Value** r) {
        *l = operand(in, 0);
        *r = operand(in, 1);
        if (*l == nullptr || *r == nullptr) {
            return false;
        }
        // A MIXED PAIR IS BROUGHT TO ONE TYPE rather than refused. Refusing produced `undef`, which
        // is a well-formed module that computes nothing -- and the two commonest mixed pairs are
        // exactly the ones a program notices: comparing two POINTERS for identity (`a == b` over
        // arrays returned `undef`, so every branch on it was dead and the counter stayed 0), and
        // comparing a pointer against null.
        if ((*l)->getType() != (*r)->getType()) {
            if ((*l)->getType()->isPointerTy() || (*r)->getType()->isPointerTy()) {
                llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
                *l = coerce(*l, i64);
                *r = coerce(*r, i64);
            } else if ((*l)->getType()->isIntegerTy() && (*r)->getType()->isIntegerTy()) {
                llvm::Type* wide =
                    (*l)->getType()->getIntegerBitWidth() >= (*r)->getType()->getIntegerBitWidth()
                        ? (*l)->getType()
                        : (*r)->getType();
                *l = coerce(*l, wide);
                *r = coerce(*r, wide);
            } else {
                return false;
            }
        } else if ((*l)->getType()->isPointerTy()) {
            llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
            *l = b_.CreatePtrToInt(*l, i64);
            *r = b_.CreatePtrToInt(*r, i64);
        }
        return (*l)->getType()->isIntegerTy();
    }

    // Whether an equality compares FLOATS. Asked of the operands rather than of the instruction,
    // because the opcode deliberately does not say -- see `Op::CmpEq`.
    bool isFloatCompare(const Inst& in) {
        llvm::Value* l = operand(in, 0);
        llvm::Value* r = operand(in, 1);
        return l != nullptr && r != nullptr && l->getType()->getScalarType()->isFloatingPointTy() &&
               r->getType()->getScalarType()->isFloatingPointTy();
    }

    llvm::Value* intBinary(const Inst& in, llvm::Value* (Emitter::*make)(llvm::Value*, llvm::Value*)) {
        llvm::Value* l = nullptr;
        llvm::Value* r = nullptr;
        if (!intPair(in, &l, &r)) {
            return in.type != nullptr ? llvm::UndefValue::get(llty(in.type)) : nullptr;
        }
        return (this->*make)(l, r);
    }

    // The float twin of `intBinary`. Both sides are brought to the WIDER of the two, because a
    // `float` added to a `double` is two different LLVM types and the instruction takes one.
    llvm::Value* fpBinary(const Inst& in, llvm::Value* (Emitter::*make)(llvm::Value*, llvm::Value*)) {
        llvm::Value* l = operand(in, 0);
        llvm::Value* r = operand(in, 1);
        if (l == nullptr || r == nullptr) {
            return undefOf(in);
        }
        // A VECTOR OF FLOATS IS FLOATING POINT TOO, and this asked `isFloatingPointTy()`, which a
        // `<4 x float>` answers no to -- LLVM puts the lane count outside the scalar. So every
        // element-wise `a + b` over two vectors returned `undef` and `simd_vectors` printed
        // `c=0,0,0,0`. `getScalarType()` asks the question that was meant: what is IN the lanes.
        if (!l->getType()->getScalarType()->isFloatingPointTy() ||
            !r->getType()->getScalarType()->isFloatingPointTy()) {
            return undefOf(in);
        }
        if (l->getType() != r->getType()) {
            // Widening is a SCALAR question and applies only where both sides are scalars: two
            // vectors of different widths are not two numbers to promote, they are a mistake
            // upstream, and `fpext` between them is not what LLVM would accept anyway.
            if (l->getType()->isVectorTy() || r->getType()->isVectorTy()) {
                return undefOf(in);
            }
            llvm::Type* wide = l->getType()->isDoubleTy() ? l->getType() : r->getType();
            l = l->getType() == wide ? l : b_.CreateFPExt(l, wide);
            r = r->getType() == wide ? r : b_.CreateFPExt(r, wide);
        }
        return (this->*make)(l, r);
    }

    llvm::Value* mkFAdd(llvm::Value* a, llvm::Value* c) { return b_.CreateFAdd(a, c); }
    llvm::Value* mkFSub(llvm::Value* a, llvm::Value* c) { return b_.CreateFSub(a, c); }
    llvm::Value* mkFMul(llvm::Value* a, llvm::Value* c) { return b_.CreateFMul(a, c); }
    llvm::Value* mkFDiv(llvm::Value* a, llvm::Value* c) { return b_.CreateFDiv(a, c); }
    llvm::Value* mkFRem(llvm::Value* a, llvm::Value* c) { return b_.CreateFRem(a, c); }
    // ORDERED equality: NaN compares false against everything, including itself, which is what the
    // language means by `==` and what the trusted path emits.
    llvm::Value* mkFEq(llvm::Value* a, llvm::Value* c) { return b_.CreateFCmpOEQ(a, c); }
    llvm::Value* mkFNe(llvm::Value* a, llvm::Value* c) { return b_.CreateFCmpUNE(a, c); }
    llvm::Value* mkFLt(llvm::Value* a, llvm::Value* c) { return b_.CreateFCmpOLT(a, c); }
    llvm::Value* mkFLe(llvm::Value* a, llvm::Value* c) { return b_.CreateFCmpOLE(a, c); }
    llvm::Value* mkFGt(llvm::Value* a, llvm::Value* c) { return b_.CreateFCmpOGT(a, c); }
    llvm::Value* mkFGe(llvm::Value* a, llvm::Value* c) { return b_.CreateFCmpOGE(a, c); }

    llvm::Value* mkAdd(llvm::Value* a, llvm::Value* c) { return b_.CreateAdd(a, c); }
    llvm::Value* mkSub(llvm::Value* a, llvm::Value* c) { return b_.CreateSub(a, c); }
    llvm::Value* mkMul(llvm::Value* a, llvm::Value* c) { return b_.CreateMul(a, c); }
    // `{ i64 length, ptr data, i64 hash }`, the layout the runtime and the trusted path both hold.
    // Named so a dump of the module reads the same way theirs does.
    llvm::StructType* stringType() {
        if (llvm::StructType* had = llvm::StructType::getTypeByName(ctx_, "String")) {
            return had;
        }
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        return llvm::StructType::create(ctx_, {i64, llvm::PointerType::get(ctx_, 0), i64}, "String");
    }

    // ---- §31: THE REFLECTIVE TYPE TOKENS, AS CONSTANTS IN THE IMAGE ----
    //
    // `%ReflectType` is twenty-two machine words, and the four that hold counts are integers while
    // the rest are pointers. Spelled the same way the trusted path spells it, deliberately: the two
    // are read by the SAME runtime and by the same reflective methods, and a token whose slots are
    // in a different order is not a token.
    llvm::StructType* reflectType() {
        if (llvm::StructType* had = llvm::StructType::getTypeByName(ctx_, "ReflectType")) {
            return had;
        }
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        llvm::Type* ptr = llvm::PointerType::get(ctx_, 0);
        std::vector<llvm::Type*> slots(22, ptr);
        slots[1] = i64;   // how many methods
        slots[4] = i64;   // how many fields
        slots[6] = i64;   // how many bytes an instance takes
        slots[8] = i64;   // how many annotations on the class
        slots[12] = ptr;
        slots[14] = ptr;
        return llvm::StructType::create(ctx_, slots, "ReflectType");
    }

    // A `String` in the image. The same three words `Op::ConstStr` builds -- length, bytes, cached
    // hash -- because there is only one way to lay out a String and this is not a second one.
    llvm::Constant* stringConstant(const std::string& bytes) {
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        // The bytes as their own global, built by hand rather than through the IRBuilder: this runs
        // BEFORE any function body exists, and `CreateGlobalStringPtr` reaches for the insertion
        // point's module.
        llvm::Constant* chars = llvm::ConstantDataArray::getString(ctx_, bytes, /*AddNull=*/true);
        auto* data = new llvm::GlobalVariable(mod_, chars->getType(), /*isConstant=*/true,
                                              llvm::GlobalValue::PrivateLinkage, chars, ".str");
        data->setUnnamedAddr(llvm::GlobalValue::UnnamedAddr::Global);
        llvm::StructType* st = stringType();
        auto* obj = new llvm::GlobalVariable(
            mod_, st, /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
            llvm::ConstantStruct::get(st, {llvm::ConstantInt::get(i64, bytes.size()), data,
                                           llvm::ConstantInt::get(i64, 0)}),
            ".strobj");
        // NOT constant: the hash in the third word is written on first use, exactly as for a literal.
        obj->setAlignment(llvm::Align(8));
        return obj;
    }

    llvm::Constant* constantOf(const ConstNode& n) {
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        llvm::PointerType* ptr = llvm::PointerType::get(ctx_, 0);
        switch (n.kind) {
            case ConstNode::Kind::Int:
                return llvm::ConstantInt::get(i64, n.number);
            case ConstNode::Kind::Text:
                return stringConstant(n.text);
            case ConstNode::Kind::Fn: {
                auto found = fns_.find(n.text);
                return found != fns_.end() && found->second != nullptr
                           ? llvm::cast<llvm::Constant>(found->second)
                           : llvm::Constant::getNullValue(ptr);
            }
            case ConstNode::Kind::Array: {
                // A POLARON ARRAY IS `[i64 length | elements...]`, and the length is inside the
                // block. Every walk over one -- `Type.methodName(i)`, the runtime's own -- reads it
                // from there, so an array laid out any other way is a different type.
                llvm::Type* elem = n.wide ? static_cast<llvm::Type*>(i64) : ptr;
                std::vector<llvm::Constant*> items;
                items.reserve(n.items.size());
                for (const ConstNode& item : n.items) {
                    llvm::Constant* c = constantOf(item);
                    // A slot whose element came back the wrong shape gets a zero rather than a
                    // cast: a mismatch here means the description and the layout disagree, and
                    // reinterpreting one as the other would hand the reader a number to follow.
                    items.push_back(c->getType() == elem ? c
                                                         : llvm::Constant::getNullValue(elem));
                }
                llvm::ArrayType* at = llvm::ArrayType::get(elem, items.size());
                llvm::StructType* block = llvm::StructType::get(ctx_, {i64, at});
                auto* g = new llvm::GlobalVariable(
                    mod_, block, /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
                    llvm::ConstantStruct::get(
                        block, {llvm::ConstantInt::get(i64, items.size()),
                                llvm::ConstantArray::get(at, items)}),
                    ".reflarr");
                g->setAlignment(llvm::Align(8));
                return g;
            }
            case ConstNode::Kind::Zero:
            default:
                return llvm::Constant::getNullValue(ptr);
        }
    }

    void emitReflectTokens() {
        for (const ReflectToken& t : pir_.reflectTokens) {
            llvm::StructType* st = reflectType();
            std::vector<llvm::Constant*> slots;
            slots.reserve(st->getNumElements());
            for (unsigned i = 0; i < st->getNumElements(); ++i) {
                llvm::Constant* c =
                    i < t.slots.size() ? constantOf(t.slots[i])
                                       : llvm::Constant::getNullValue(st->getElementType(i));
                if (c->getType() != st->getElementType(i)) {
                    c = llvm::Constant::getNullValue(st->getElementType(i));
                }
                slots.push_back(c);
            }
            auto* g = new llvm::GlobalVariable(mod_, st, /*isConstant=*/true,
                                               llvm::GlobalValue::PrivateLinkage,
                                               llvm::ConstantStruct::get(st, slots),
                                               "type." + t.cls);
            g->setAlignment(llvm::Align(8));
        }
    }

    llvm::Value* mkSDiv(llvm::Value* a, llvm::Value* c) { return b_.CreateSDiv(a, c); }
    llvm::Value* mkSRem(llvm::Value* a, llvm::Value* c) { return b_.CreateSRem(a, c); }
    llvm::Value* mkUDiv(llvm::Value* a, llvm::Value* c) { return b_.CreateUDiv(a, c); }
    llvm::Value* mkURem(llvm::Value* a, llvm::Value* c) { return b_.CreateURem(a, c); }
    llvm::Value* mkAnd(llvm::Value* a, llvm::Value* c) { return b_.CreateAnd(a, c); }
    llvm::Value* mkOr(llvm::Value* a, llvm::Value* c) { return b_.CreateOr(a, c); }
    llvm::Value* mkXor(llvm::Value* a, llvm::Value* c) { return b_.CreateXor(a, c); }
    llvm::Value* mkShl(llvm::Value* a, llvm::Value* c) { return b_.CreateShl(a, c); }
    llvm::Value* mkAShr(llvm::Value* a, llvm::Value* c) { return b_.CreateAShr(a, c); }
    llvm::Value* mkLShr(llvm::Value* a, llvm::Value* c) { return b_.CreateLShr(a, c); }
    llvm::Value* mkEq(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpEQ(a, c); }
    llvm::Value* mkNe(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpNE(a, c); }
    llvm::Value* mkSLt(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpSLT(a, c); }
    llvm::Value* mkSLe(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpSLE(a, c); }
    llvm::Value* mkSGt(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpSGT(a, c); }
    llvm::Value* mkSGe(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpSGE(a, c); }
    llvm::Value* mkULt(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpULT(a, c); }
    llvm::Value* mkULe(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpULE(a, c); }
    llvm::Value* mkUGt(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpUGT(a, c); }
    llvm::Value* mkUGe(llvm::Value* a, llvm::Value* c) { return b_.CreateICmpUGE(a, c); }

    llvm::BasicBlock* blockOf(const Inst& in, size_t edge) {
        if (edge >= in.edges.size()) {
            return nullptr;
        }
        auto it = blocks_.find(in.edges[edge].target);
        return it != blocks_.end() ? it->second : nullptr;
    }

    void emitInst(const Function& f, const Block& b, const Inst& in) {
        llvm::Value* out = nullptr;
        switch (in.op) {
            case Op::ConstInt:
                // A CONSTANT WIDER THAN `imm`. `imm` is sixty-four bits and a `Decimal` literal is
                // a hundred and twenty-eight, so the digits travel as TEXT and are parsed at the
                // width the instruction states. Everything else still comes through `imm`.
                if (!in.text.empty() && in.type != nullptr && in.type->bits > 64) {
                    out = llvm::ConstantInt::get(ctx_, llvm::APInt(in.type->bits, in.text, 10));
                    break;
                }
                out = llvm::ConstantInt::get(llty(in.type), in.imm, true);
                break;
            case Op::ConstBool:
                out = llvm::ConstantInt::get(llvm::Type::getInt1Ty(ctx_), in.imm != 0);
                break;
            // ---- floating point, which this backend did not have at all ----
            //
            // Not "incompletely": there was no `const.float`, no `fadd`, no float comparison and no
            // conversion between the two worlds. The lowering emitted all of them and every one
            // fell through to the default, which produces `undef` -- so `double d = 2.5;` stored an
            // undefined value and `x=3.0 y=3.0` printed as `x=0.0 y=0.0`. The module verified and
            // linked; nothing anywhere said the arithmetic had gone missing.
            case Op::ConstFloat:
                out = llvm::ConstantFP::get(llty(in.type), in.fimm);
                break;
            // THE ADDRESS OF A NAMED MODULE-LEVEL THING -- a function, a static, a vtable. This was
            // not handled at all, so every one of them was `undef`: a method reference passed to a
            // lambda, a static read through its namespace, and now a class's dispatch table.
            case Op::ConstFn: {
                if (auto it = fns_.find(in.text); it != fns_.end()) {
                    out = it->second;
                    break;
                }
                out = mod_.getNamedGlobal(in.text);
                if (out == nullptr) {
                    out = mod_.getNamedValue(in.text);
                }
                if (out == nullptr) {
                    out = llvm::UndefValue::get(llvm::PointerType::get(ctx_, 0));
                }
                break;
            }
            // ONE INSTRUCTION, as §7.6 says: the object's table pointer is at offset zero, the slot
            // is an index into it, and what comes out is the body to call. Written as three steps
            // in the lowering it would be three things every pass has to recognise together.
            // AN INDIRECT CALL, which is what dispatch becomes and what a closure has always been.
            // It was not translated, so every one of them was `undef` -- and an `undef` where a
            // result is expected is a program that runs and answers nothing.
            case Op::CallIndirect: {
                llvm::Value* callee = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                std::vector<llvm::Value*> args;
                std::vector<llvm::Type*> types;
                for (size_t i = 1; i < in.operands.size(); ++i) {
                    llvm::Value* a = valueOf(in.operands[i]);
                    if (a == nullptr) {
                        continue;
                    }
                    args.push_back(a);
                    types.push_back(a->getType());
                }
                llvm::Type* ret = in.type != nullptr ? llty(in.type)
                                                     : llvm::Type::getVoidTy(ctx_);
                auto* ft = llvm::FunctionType::get(ret, types, false);
                // A CALL THROUGH A VTABLE SLOT GETS AN INLINE CACHE FIRST, when the program has few
                // enough implementations of it to make one worth building. Null means it was not
                // worth it, and the ordinary indirect call below is what happens.
                if (llvm::Value* fast = speculate(in, ft, callee, args); fast != nullptr) {
                    out = ret->isVoidTy() ? nullptr : fast;
                    break;
                }
                llvm::CallInst* call = b_.CreateCall(ft, callee, args);
                out = ret->isVoidTy() ? nullptr : call;
                break;
            }
            case Op::VtableLoad: {
                llvm::PointerType* p = llvm::PointerType::get(ctx_, 0);
                llvm::Value* obj = coerce(operand(in, 0), p);
                llvm::Value* table = b_.CreateLoad(p, obj, "vtable");
                llvm::Value* at = b_.CreateGEP(
                    p, table, llvm::ConstantInt::get(llvm::Type::getInt64Ty(ctx_), in.imm),
                    "vslot");
                out = b_.CreateLoad(p, at, "vfn");
                // WHICH SLOT THIS POINTER CAME OUT OF, remembered for the call that consumes it.
                // A slot number is a method: the numbering is global per method NAME, so every
                // implementation of `area` sits at the same index in every table that has one.
                // That is the whole key the inline cache below needs.
                if (in.result != kNoValue) {
                    fromSlot_[in.result] = in.imm;
                }
                break;
            }
            case Op::FAdd: out = fpBinary(in, &Emitter::mkFAdd); break;
            case Op::FSub: out = fpBinary(in, &Emitter::mkFSub); break;
            case Op::FMul: out = fpBinary(in, &Emitter::mkFMul); break;
            case Op::FDiv: out = fpBinary(in, &Emitter::mkFDiv); break;
            case Op::FRem: out = fpBinary(in, &Emitter::mkFRem); break;
            case Op::FNeg: {
                llvm::Value* v = operand(in, 0);
                out = v != nullptr && v->getType()->isFloatingPointTy() ? b_.CreateFNeg(v)
                                                                        : undefOf(in);
                break;
            }
            // ORDERED comparisons: a NaN compares false against everything, which is what the
            // language means by `<` and what the trusted path emits.
            case Op::CmpLtF: out = fpBinary(in, &Emitter::mkFLt); break;
            case Op::CmpLeF: out = fpBinary(in, &Emitter::mkFLe); break;
            case Op::CmpGtF: out = fpBinary(in, &Emitter::mkFGt); break;
            case Op::CmpGeF: out = fpBinary(in, &Emitter::mkFGe); break;
            case Op::FpTrunc: case Op::FpExtend: {
                llvm::Value* v = operand(in, 0);
                llvm::Type* to = llty(in.type);
                if (v == nullptr || !v->getType()->isFloatingPointTy() ||
                    !to->isFloatingPointTy()) {
                    out = undefOf(in);
                } else if (v->getType() == to) {
                    out = v;
                } else {
                    out = in.op == Op::FpTrunc ? b_.CreateFPTrunc(v, to) : b_.CreateFPExt(v, to);
                }
                break;
            }
            // `delete x` RUNS THE DESTRUCTOR AND RELEASES THE STORAGE, and this backend translated
            // neither -- `drop` fell through to the default and produced nothing at all. Every
            // destructor in every program through this path simply never ran, and every object was
            // leaked. `delete_multi` printed `done` where the program prints `~1`.
            case Op::Drop: case Op::DropCascade: {
                llvm::Value* obj = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                if (obj == nullptr) {
                    break;
                }
                // THROUGH THE TABLE when the class has one: `delete base` on an object that is
                // really a `Derived` runs `~Derived`, which is the only reason a destructor is
                // virtual at all. A class with no table has exactly one destructor and is called
                // by name.
                llvm::PointerType* p = llvm::PointerType::get(ctx_, 0);
                if (in.imm >= 0) {
                    llvm::Value* table = b_.CreateLoad(p, obj, "vtable");
                    llvm::Value* at = b_.CreateGEP(
                        p, table, llvm::ConstantInt::get(llvm::Type::getInt64Ty(ctx_), in.imm),
                        "dtor.slot");
                    llvm::Value* fnPtr = b_.CreateLoad(p, at, "dtor");
                    auto* ft = llvm::FunctionType::get(llvm::Type::getVoidTy(ctx_), {p}, false);
                    // AN EMPTY SLOT IS NOT A DESTRUCTOR. The slot number is global, so a class in
                    // a hierarchy where SOME class has a destructor carries that index whether it
                    // declares one or not -- and where it does not, the slot holds null. Jumping
                    // there is a call to address zero. The test costs one compare on a cold path
                    // and is what lets `delete` dispatch wherever it might need to.
                    llvm::Function* fn = b_.GetInsertBlock()->getParent();
                    auto* run = llvm::BasicBlock::Create(ctx_, "dtor.present", fn);
                    auto* skip = llvm::BasicBlock::Create(ctx_, "dtor.absent", fn);
                    b_.CreateCondBr(
                        b_.CreateICmpNE(fnPtr, llvm::ConstantPointerNull::get(p), "dtor.any"), run,
                        skip);
                    b_.SetInsertPoint(run);
                    b_.CreateCall(ft, fnPtr, {obj});
                    b_.CreateBr(skip);
                    b_.SetInsertPoint(skip);
                    tail_[b.id] = skip;
                } else if (!in.text.empty()) {
                    if (auto it = fns_.find(in.text + ".~" + in.text); it != fns_.end()) {
                        b_.CreateCall(it->second, {obj});
                    }
                }
                // §21: THE OBJECT'S STRING FIELDS GO BACK BEFORE ITS BLOCK DOES.
                //
                // A String field owns its buffer, so an object that dies owes it -- and this is the
                // one point between the user's destructor, which may still read the field, and the
                // free, after which the field's address is not the program's to read. Without it
                // every object with a String field leaked one buffer per lifetime; `test_string_
                // ownership`'s field probe is what finally counted them.
                if (in.aggregate != nullptr) {
                    llvm::Type* shape = llty(in.aggregate);
                    llvm::FunctionType* sf = llvm::FunctionType::get(
                        llvm::Type::getVoidTy(ctx_), {llvm::PointerType::get(ctx_, 0)}, false);
                    for (const std::string& note : in.extra) {
                        if (note.rfind("sfree:", 0) != 0) {
                            continue;
                        }
                        const unsigned idx =
                            static_cast<unsigned>(std::strtoul(note.c_str() + 6, nullptr, 10));
                        llvm::Value* at = b_.CreateStructGEP(shape, obj, idx, "sfree");
                        b_.CreateCall(mod_.getOrInsertFunction("__polaron_str_free", sf),
                                      {b_.CreateLoad(llvm::PointerType::get(ctx_, 0), at)});
                    }
                }
                // ONLY WHAT THE ALLOCATOR GAVE US. `new T()` is a frame slot by default, and handing
                // a stack address to `free` corrupts the heap -- the destructor runs either way,
                // which is the half that is always correct.
                if (std::find(in.extra.begin(), in.extra.end(), "heap") != in.extra.end()) {
                    llvm::FunctionType* ft = llvm::FunctionType::get(
                        llvm::Type::getVoidTy(ctx_), {llvm::PointerType::get(ctx_, 0)}, false);
                    b_.CreateCall(mod_.getOrInsertFunction("__polaron_free", ft), {obj});
                }
                break;
            }
            case Op::SizeOf: {
                const uint64_t bytes =
                    in.aggregate != nullptr
                        ? mod_.getDataLayout().getTypeAllocSize(llty(in.aggregate))
                        : 0;
                out = llvm::ConstantInt::get(llvm::Type::getInt64Ty(ctx_), bytes);
                break;
            }
            // OWNERSHIP IS A STATIC FACT, so at the machine level these three are the value itself.
            // `move` transfers who is responsible for destroying a thing; `forget` says nobody is;
            // `copy.deep` is the one that does work, and the lowering has already emitted that work
            // as an ordinary allocation and copy. None of them had a case here, so `move c` handed
            // the callee `undef` -- ownership transferred, the value did not.
            case Op::Move: case Op::Forget: case Op::CopyDeep:
                out = operand(in, 0);
                break;
            // LANES IN, LANES OUT. Nothing here has to recognise anything: the result type says how
            // many lanes there are and what each one is, and building one from N scalars is N
            // inserts into an undef vector -- which is the canonical shape and what LLVM's own
            // constant folder collapses to a single constant when the scalars are constants.
            case Op::VecBuild: {
                auto* vt = llvm::dyn_cast<llvm::FixedVectorType>(llty(in.type));
                if (vt == nullptr) {
                    out = undefOf(in);
                    break;
                }
                llvm::Value* v = llvm::UndefValue::get(vt);
                const unsigned lanes = vt->getNumElements();
                for (unsigned i = 0; i < lanes; ++i) {
                    // ONE operand broadcasts: `v * 2.0` scales every lane by the same scalar, and
                    // spelling that as "build a vector out of this one value" keeps the splat from
                    // being a second opcode that means the same thing.
                    const size_t which = in.operands.size() == 1 ? 0 : i;
                    llvm::Value* lane =
                        which < in.operands.size() ? operand(in, which) : nullptr;
                    if (lane == nullptr) {
                        continue;
                    }
                    v = b_.CreateInsertElement(
                        v, coerce(lane, vt->getElementType()),
                        llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx_), i), "vec.lane");
                }
                out = v;
                break;
            }
            case Op::VecExtract: {
                llvm::Value* v = operand(in, 0);
                llvm::Value* i = in.operands.size() > 1
                                     ? operand(in, 1)
                                     : llvm::ConstantInt::get(
                                           llvm::Type::getInt32Ty(ctx_), in.imm);
                if (v == nullptr || i == nullptr || !v->getType()->isVectorTy()) {
                    out = undefOf(in);
                    break;
                }
                out = b_.CreateExtractElement(v, coerce(i, llvm::Type::getInt32Ty(ctx_)), "vec.at");
                break;
            }
            case Op::VecInsert: {
                llvm::Value* v = operand(in, 0);
                llvm::Value* lane = operand(in, 1);
                llvm::Value* i = in.operands.size() > 2
                                     ? operand(in, 2)
                                     : llvm::ConstantInt::get(
                                           llvm::Type::getInt32Ty(ctx_), in.imm);
                if (v == nullptr || lane == nullptr || i == nullptr || !v->getType()->isVectorTy()) {
                    out = undefOf(in);
                    break;
                }
                out = b_.CreateInsertElement(v, coerce(lane, v->getType()->getScalarType()),
                                             coerce(i, llvm::Type::getInt32Ty(ctx_)), "vec.set");
                break;
            }
            // INLINE ASSEMBLY, with side effects and a memory clobber. The lowering already built
            // the constraint string -- that is the language's spelling of the operand list -- so
            // what is left here is the LLVM object and the write-back of the outputs.
            case Op::Asm: {
                const size_t inputs = static_cast<size_t>(in.imm);
                std::vector<llvm::Type*> argTys;
                std::vector<llvm::Value*> args;
                for (size_t i = 0; i < inputs && i < in.operands.size(); ++i) {
                    llvm::Value* v = operand(in, i);
                    if (v == nullptr) {
                        break;
                    }
                    args.push_back(v);
                    argTys.push_back(v->getType());
                }
                llvm::Type* retTy = llty(in.type);
                // THE DIALECT FOLLOWS THE ARCHITECTURE unless the block names one. x86 defaults to
                // INTEL, because that is what a Polaron `asm` block is written in -- defaulting to
                // AT&T makes every such block fail to ASSEMBLE while the IR still emits, which is
                // the shape of bug that looks like the feature working.
                // THE PIR MODULE'S TRIPLE, not the LLVM module's: nothing sets the latter here, so
                // asking it gives `UnknownArch` and the default falls to AT&T -- which makes every
                // Intel-syntax block fail to ASSEMBLE with a message about a mnemonic, three layers
                // below the line that wrote it. An empty triple is the host, which is x86 here.
                const bool isX86 = pir_.triple.empty() ||
                                   pir_.triple.find("x86") != std::string::npos ||
                                   pir_.triple.find("i686") != std::string::npos ||
                                   pir_.triple.find("i386") != std::string::npos;
                llvm::InlineAsm::AsmDialect dialect =
                    isX86 ? llvm::InlineAsm::AD_Intel : llvm::InlineAsm::AD_ATT;
                const std::string spelled = in.extra.size() > 1 ? in.extra[1] : std::string();
                if (spelled == "intel") {
                    dialect = llvm::InlineAsm::AD_Intel;
                } else if (spelled == "att") {
                    dialect = llvm::InlineAsm::AD_ATT;
                }
                auto* aty = llvm::FunctionType::get(retTy, argTys, false);
                llvm::InlineAsm* ia = llvm::InlineAsm::get(
                    aty, in.text, in.extra.empty() ? std::string("~{memory}") : in.extra[0],
                    /*hasSideEffects=*/true, /*isAlignStack=*/false, dialect);
                llvm::Value* res = b_.CreateCall(ia, args);
                // ...and the outputs go back into the addresses they came from, which the lowering
                // put after the inputs.
                const size_t outCount = in.operands.size() - inputs;
                for (size_t k = 0; k < outCount; ++k) {
                    llvm::Value* slot = operand(in, inputs + k);
                    if (slot == nullptr) {
                        continue;
                    }
                    llvm::Value* v =
                        outCount == 1 ? res : b_.CreateExtractValue(res, static_cast<unsigned>(k));
                    b_.CreateStore(v, slot);
                }
                break;
            }
            case Op::Select: {
                llvm::Value* cond = operand(in, 0);
                llvm::Value* yes = operand(in, 1);
                llvm::Value* no = operand(in, 2);
                if (cond == nullptr || yes == nullptr || no == nullptr ||
                    yes->getType() != no->getType()) {
                    out = undefOf(in);
                    break;
                }
                // The condition is an `i1` here; a comparison already produces one, and anything
                // wider makes LLVM refuse the select outright rather than truncate it quietly.
                if (!cond->getType()->isIntegerTy(1)) {
                    cond = b_.CreateICmpNE(cond, llvm::ConstantInt::get(cond->getType(), 0),
                                           "sel.c");
                }
                out = b_.CreateSelect(cond, yes, no);
                break;
            }
            case Op::Bitcast: {
                llvm::Value* v = operand(in, 0);
                llvm::Type* to = llty(in.type);
                out = v != nullptr && v->getType()->getPrimitiveSizeInBits() ==
                                          to->getPrimitiveSizeInBits()
                          ? b_.CreateBitCast(v, to)
                          : undefOf(in);
                break;
            }
            case Op::IntToFp: {
                llvm::Value* v = operand(in, 0);
                llvm::Type* to = llty(in.type);
                out = v != nullptr && v->getType()->isIntegerTy() && to->isFloatingPointTy()
                          ? b_.CreateSIToFP(v, to)
                          : undefOf(in);
                break;
            }
            case Op::FpToIntSaturate: case Op::FpToIntWrap: {
                llvm::Value* v = operand(in, 0);
                llvm::Type* to = llty(in.type);
                if (v == nullptr || !v->getType()->isFloatingPointTy() || !to->isIntegerTy()) {
                    out = undefOf(in);
                    break;
                }
                // SATURATING IS NOT `fptosi`. A double past the integer's range is UNDEFINED for
                // `fptosi` and LLVM takes it: `cast<int>(1e18)` came out INT_MIN, the same answer a
                // huge NEGATIVE double gives, so the two ends of the range were indistinguishable.
                // §3.5 says a narrowing conversion clamps, and `llvm.fptosi.sat` is that operation
                // -- the opcode's name has said so all along.
                out = in.op == Op::FpToIntSaturate
                          ? b_.CreateIntrinsic(llvm::Intrinsic::fptosi_sat, {to, v->getType()}, {v})
                          : b_.CreateFPToSI(v, to);
                break;
            }
            case Op::ConstNull:
                out = llvm::Constant::getNullValue(llty(in.type));
                break;
            case Op::Undef:
                out = llvm::UndefValue::get(llty(in.type));
                break;
            case Op::ConstStr: {
                // A LITERAL IS A `String` OBJECT, not a pointer to bytes.
                //
                // It was the bytes, and everything that only ever handed a literal to `printf` was
                // happy -- `printf` wants exactly that. The moment a literal reached a method that
                // treats it as a `String`, the method read its length from the first eight bytes of
                // the TEXT: `Digest.adler32("abc")` read the length `0x00636261` and walked six
                // million characters off the end. The escapes are resolved here, because the C
                // runtime reads the data and a literal `\n` in it is two characters on a terminal.
                const std::string bytes = unescape(in.text);
                llvm::Constant* data = b_.CreateGlobalStringPtr(bytes);
                // `b"..."` IS THE BYTES, AND ASKING THE WRAPPER FOR THEM NEEDS A RELOCATION.
                //
                // Reading the `data` field of a `String` global gives the same address by a route
                // that has to be fixed up at load time: the global holds a pointer, and in a
                // position-independent image whose relocations have not been applied yet that
                // pointer is still the link-time value. pico's `ld.so` is exactly that image -- it
                // is ET_DYN and it announces itself BEFORE relocating itself -- so
                // `Ld.say(b"pico ld: interpreter entered...", 46)` printed forty-six bytes from
                // wherever the unrelocated pointer landed. The array is addressed RIP-relative and
                // needs nothing applied, which is what a byte literal wanted all along.
                if (in.imm != 0) {
                    out = data;
                    break;
                }
                llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
                llvm::StructType* st = stringType();
                auto* obj = new llvm::GlobalVariable(
                    mod_, st, /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
                    llvm::ConstantStruct::get(
                        st, {llvm::ConstantInt::get(i64, bytes.size()), data,
                             llvm::ConstantInt::get(i64, 0)}),
                    ".strobj");
                // NOT constant: the cached hash in the third field is written on first use.
                obj->setAlignment(llvm::Align(8));
                out = obj;
                break;
            }

            case Op::AddChecked: case Op::SubChecked: case Op::MulChecked:
                out = checkedArith(in);
                break;
            case Op::AddWrap:  out = intBinary(in, &Emitter::mkAdd); break;
            case Op::SubWrap:  out = intBinary(in, &Emitter::mkSub); break;
            case Op::MulWrap:  out = intBinary(in, &Emitter::mkMul); break;
            // SATURATION IS A THIRD ANSWER, and it had no case here at all -- so `saturatingAdd`
            // fell through to the default and produced `undef`, or, once the lowering started
            // emitting it, nothing at all. LLVM has the intrinsics, which is the whole reason the
            // overflow rule lives on the opcode: `sadd.sat` is one instruction on most targets,
            // and open-coding the clamp would be several plus a branch the vectoriser refuses.
            case Op::AddSaturate: case Op::SubSaturate: case Op::MulSaturate:
                out = saturatingArith(in);
                break;
            // The SIGN rides on the instruction here rather than in the mnemonic -- see
            // `Inst::unsignedOp`. An `sdiv` over a `uint` is not a slower answer, it is another one.
            case Op::DivChecked: case Op::DivTrap:
                out = intBinary(in, in.unsignedOp ? &Emitter::mkUDiv : &Emitter::mkSDiv);
                break;
            case Op::RemChecked: case Op::RemTrap:
                out = intBinary(in, in.unsignedOp ? &Emitter::mkURem : &Emitter::mkSRem);
                break;
            case Op::And: out = intBinary(in, &Emitter::mkAnd); break;
            case Op::Or:  out = intBinary(in, &Emitter::mkOr); break;
            case Op::Xor: out = intBinary(in, &Emitter::mkXor); break;
            case Op::ShlChecked: case Op::ShlWrap: out = intBinary(in, &Emitter::mkShl); break;
            case Op::ShrA: out = intBinary(in, &Emitter::mkAShr); break;
            case Op::ShrL: out = intBinary(in, &Emitter::mkLShr); break;
            // EQUALITY IS ONE OPCODE FOR BOTH FAMILIES, unlike ordering -- §7.3 gives `cmp.lt.f` a
            // name of its own because the NaN rule differs, and gives equality none because it does
            // not. So the operands decide which instruction: `icmp eq` between two integers or two
            // pointers, `fcmp oeq` between two floats. Sent to `intBinary` unconditionally, a
            // comparison of two doubles produced `undef` -- `ArrayList<double>.indexOf(9.25)`
            // answered -1 for a value that was in the list, and nothing said so.
            case Op::CmpEq:
                out = isFloatCompare(in) ? fpBinary(in, &Emitter::mkFEq)
                                         : intBinary(in, &Emitter::mkEq);
                break;
            case Op::CmpNe:
                out = isFloatCompare(in) ? fpBinary(in, &Emitter::mkFNe)
                                         : intBinary(in, &Emitter::mkNe);
                break;
            case Op::CmpLtS:  out = intBinary(in, &Emitter::mkSLt); break;
            case Op::CmpLeS:  out = intBinary(in, &Emitter::mkSLe); break;
            case Op::CmpGtS:  out = intBinary(in, &Emitter::mkSGt); break;
            case Op::CmpGeS:  out = intBinary(in, &Emitter::mkSGe); break;
            // THE UNSIGNED HALF, which was not here at all. The lowering has emitted these since
            // the sign started travelling with the value, and every one of them fell through to the
            // default and became `undef` -- so `big > 1` over a `uint` branched on an undefined
            // condition and printed `false`. The signed four were present, which is exactly why it
            // went unnoticed: the common case worked.
            case Op::CmpLtU:  out = intBinary(in, &Emitter::mkULt); break;
            case Op::CmpLeU:  out = intBinary(in, &Emitter::mkULe); break;
            case Op::CmpGtU:  out = intBinary(in, &Emitter::mkUGt); break;
            case Op::CmpGeU:  out = intBinary(in, &Emitter::mkUGe); break;

            case Op::NegChecked: case Op::NegWrap: case Op::NegSaturate: {
                // A FLOAT NEGATES TOO. This refused anything that was not an integer and answered
                // `undef`, so `-2.0` became a hole -- the lowering now picks `fneg`, and this stays
                // as the second line of defence rather than a second place that says no.
                llvm::Value* v = operand(in, 0);
                out = v == nullptr                     ? undefOf(in)
                      : v->getType()->isIntegerTy()    ? b_.CreateNeg(v)
                      : v->getType()->isFloatingPointTy() ? b_.CreateFNeg(v)
                                                       : undefOf(in);
                break;
            }
            case Op::Not: {
                llvm::Value* v = operand(in, 0);
                out = (v != nullptr && v->getType()->isIntegerTy()) ? b_.CreateNot(v) : undefOf(in);
                break;
            }
            case Op::Trunc: case Op::ExtendS: case Op::ExtendU: {
                llvm::Value* v = operand(in, 0);
                llvm::Type* to = llty(in.type);
                if (v == nullptr || !v->getType()->isIntegerTy() || !to->isIntegerTy()) {
                    out = undefOf(in);
                } else if (v->getType()->getIntegerBitWidth() == to->getIntegerBitWidth()) {
                    out = v;
                } else if (in.op == Op::Trunc) {
                    // A `trunc` asked to WIDEN is a lowering that got the direction wrong; widen
                    // by zero from one bit, for the same reason as everywhere else.
                    out = v->getType()->getIntegerBitWidth() > to->getIntegerBitWidth()
                              ? b_.CreateTrunc(v, to)
                          : v->getType()->isIntegerTy(1) ? b_.CreateZExt(v, to)
                                                         : b_.CreateSExt(v, to);
                } else {
                    out = v->getType()->getIntegerBitWidth() < to->getIntegerBitWidth()
                              ? (in.op == Op::ExtendS ? b_.CreateSExt(v, to) : b_.CreateZExt(v, to))
                              : b_.CreateTrunc(v, to);
                }
                break;
            }
            // A NARROW ADDRESS IS STILL AN ADDRESS, and changing its width is arithmetic like any
            // other -- ZERO-extended, because an address is not a signed quantity and 0xFFFFFFFF is
            // four gigabytes rather than minus one. Missing entirely, both fell to the default and
            // became `undef`: pico's `address gdt = Gdt.TableAt;` -- a `half address` static widened
            // to a full one -- stored `undef`, and the kernel loaded a GDT from nowhere and
            // double-faulted on the first `mov ds, ax` after it.
            case Op::AddrWiden: case Op::AddrNarrow: {
                llvm::Value* v = operand(in, 0);
                llvm::Type* to = llty(in.type);
                if (v == nullptr || !v->getType()->isIntegerTy() || !to->isIntegerTy()) {
                    out = undefOf(in);
                } else if (v->getType()->getIntegerBitWidth() == to->getIntegerBitWidth()) {
                    out = v;
                } else {
                    out = b_.CreateZExtOrTrunc(v, to);
                }
                break;
            }
            case Op::PtrToAddr: {
                llvm::Value* v = operand(in, 0);
                out = (v != nullptr && v->getType()->isPointerTy())
                          ? b_.CreatePtrToInt(v, llty(in.type))
                          : undefOf(in);
                break;
            }
            case Op::AddrToPtr: {
                llvm::Value* v = operand(in, 0);
                out = (v != nullptr && v->getType()->isIntegerTy())
                          ? b_.CreateIntToPtr(v, llty(in.type))
                          : undefOf(in);
                break;
            }

            case Op::Alloca: {
                // A SECOND GUARD, deliberately. The lowering already refuses `void`; if a malformed
                // module reaches here anyway, an assertion inside LLVM is a crash with no message,
                // and a backend that dies on bad input teaches nothing about what was bad.
                llvm::Type* slot = llty(in.type);
                if (slot->isVoidTy() || !slot->isSized()) {
                    slot = llvm::PointerType::get(ctx_, 0);
                }
                // `on heap` IS A DIFFERENT ALLOCATION, and it was being ignored: the annotation
                // reached here and the emitter made a frame slot anyway, so every `new T() on heap`
                // handed back a pointer into a frame that was about to end. How BIG the object is
                // is a question only the data layout can answer, which is why the decision is here
                // and not in the lowering -- a second copy of the layout rules is a second thing to
                // get wrong, and it would have to agree with this one exactly.
                if (std::find(in.extra.begin(), in.extra.end(), "heap") != in.extra.end()) {
                    llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
                    llvm::FunctionCallee malloc = mod_.getOrInsertFunction(
                        "__polaron_malloc",
                        llvm::FunctionType::get(llvm::PointerType::get(ctx_, 0), {i64}, false));
                    const uint64_t bytes = mod_.getDataLayout().getTypeAllocSize(slot);
                    out = b_.CreateCall(malloc, {llvm::ConstantInt::get(i64, bytes)}, in.text);
                    break;
                }
                // IN THE ENTRY BLOCK, ALWAYS -- which is where the trusted backend puts it and is
                // the difference between a frame slot and a stack that grows.
                //
                // `CreateAlloca` at the current insert point puts the allocation wherever the
                // statement happens to be, and a statement can be inside a loop. `Node n = a[i];`
                // in a walk over a million nodes is one `alloca` per iteration -- the frame grows
                // until it runs out. That is presumably why the value-struct copy asked for `heap`
                // instead: it dodged the growth and paid a `__polaron_malloc` per iteration for it,
                // never freed. Twenty million allocations and 480 MB leaked on one AP-07 run, and
                // the walk cost twice what it should.
                //
                // Every alloca this language emits is a fixed-size slot whose lifetime is the
                // enclosing scope, so the entry block is where all of them belong: the storage is
                // reserved once and reused each time round, which is what the scope means and what
                // `mem2reg` expects to find. An object built on the stack inside a loop gets the
                // same slot every iteration, which is exactly the trusted backend's behaviour.
                llvm::Function* into = b_.GetInsertBlock()->getParent();
                llvm::BasicBlock& entry = into->getEntryBlock();
                llvm::IRBuilder<> front(&entry, entry.getFirstInsertionPt());
                auto* a = front.CreateAlloca(slot, nullptr, in.text);
                if (in.type != nullptr && in.type->facts.align > 0) {
                    // AT LEAST A WORD FOR AN OBJECT, because that is what every pointer parameter
                    // is told: `this` arrives with `align 8` on it, and an object the frame made
                    // four-byte aligned makes that a lie the optimiser is entitled to act on --
                    // widening a store, vectorising a copy. The allocator already gives sixteen;
                    // this is the frame agreeing with it, and it costs padding, not correctness.
                    const uint32_t least = in.type->kind == TypeKind::Struct
                                               ? std::max<uint32_t>(in.type->facts.align, 8)
                                               : in.type->facts.align;
                    a->setAlignment(llvm::Align(least));
                    ++r_.alignAttrs;
                }
                declareDebugLocal(in, a);   // `-g`: the name a debugger prints for this storage
                out = a;
                break;
            }
            // ---- §20.6, the atomics ----
            //
            // SEQUENTIALLY CONSISTENT, all of them. The language offers no ordering parameter, and
            // that is the point: the one ordering everybody reasons about correctly is the one it
            // gives. A weaker default would be faster and would make `atomic<int>` a footgun.
            // Alignment is the value's own width -- an atomic operation on a misaligned address is
            // not atomic on any machine here.
            case Op::AtomicLoad: {
                llvm::Value* p = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                auto* ld = b_.CreateLoad(llty(in.type), p, "atomic.get");
                ld->setAtomic(llvm::AtomicOrdering::SequentiallyConsistent);
                ld->setAlignment(atomicAlign(in.type));
                out = ld;
                break;
            }
            case Op::AtomicStore: {
                llvm::Value* v = operand(in, 0);
                llvm::Value* p = coerce(operand(in, 1), llvm::PointerType::get(ctx_, 0));
                if (v == nullptr || p == nullptr) {
                    break;
                }
                auto* st = b_.CreateStore(v, p);
                st->setAtomic(llvm::AtomicOrdering::SequentiallyConsistent);
                st->setAlignment(atomicAlign(v->getType()));
                break;
            }
            case Op::AtomicRmw: {
                llvm::Value* p = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                llvm::Value* n = operand(in, 1);
                if (p == nullptr || n == nullptr) {
                    out = undefOf(in);
                    break;
                }
                // THE ANSWER IS THE NEW VALUE, not the old one. `counter.increment()` reads as "add
                // one and tell me what it is now"; `atomicrmw` hands back what was there before, so
                // the addition is redone on the result -- which is free, and is what the trusted
                // path does for the same reason.
                llvm::Value* old = b_.CreateAtomicRMW(llvm::AtomicRMWInst::Add, p, n,
                                                      atomicAlign(n->getType()),
                                                      llvm::AtomicOrdering::SequentiallyConsistent);
                out = b_.CreateAdd(old, n, "atomic.new");
                break;
            }
            case Op::AtomicCmpXchg: {
                llvm::Value* p = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                llvm::Value* want = operand(in, 1);
                llvm::Value* next = operand(in, 2);
                if (p == nullptr || want == nullptr || next == nullptr) {
                    out = undefOf(in);
                    break;
                }
                llvm::AtomicCmpXchgInst* cx = b_.CreateAtomicCmpXchg(
                    p, want, next, atomicAlign(want->getType()),
                    llvm::AtomicOrdering::SequentiallyConsistent,
                    llvm::AtomicOrdering::SequentiallyConsistent);
                out = b_.CreateZExt(b_.CreateExtractValue(cx, 1, "cas.ok"), llty(in.type));
                break;
            }
            case Op::Load: {
                llvm::Value* p = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                auto* ld = b_.CreateLoad(llty(in.type), p);
                ld->setVolatile(in.isVolatile);
                if (in.type != nullptr && in.type->facts.align > 0) {
                    ld->setAlignment(llvm::Align(in.type->facts.align));
                    ++r_.alignAttrs;
                }
                out = ld;
                break;
            }
            case Op::Store: {
                llvm::Value* v = operand(in, 0);
                llvm::Value* p = coerce(operand(in, 1), llvm::PointerType::get(ctx_, 0));
                if (v != nullptr) {
                    auto* st = b_.CreateStore(v, p);
                    st->setVolatile(in.isVolatile);
                }
                break;
            }
            case Op::Gep: {
                // A GEP NEEDS A POINTER. The lowering can hand a slice or an integer here while its
                // type propagation is incomplete; forcing it is the same boundary decision as the
                // call arguments above -- a well-formed module, with the wrong value flagged by the
                // differential test rather than by LLVM's verifier.
                llvm::Value* base = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);

                // A FIELD, addressed through its aggregate. LLVM knows where the field is -- padding,
                // alignment and all -- and asking it is the only way this backend lands on the same
                // offsets the trusted path does. Computing them in the lowering would be a second
                // copy of the ABI, which is a second thing to keep right.
                // ONE OPERAND means a field: the member is named by `imm`. With two, the second IS
                // the index and this is an element access, which the branch below handles -- and
                // which also carries an `aggregate` now, so the two have to be told apart by the
                // operand count rather than by the annotation both of them use.
                if (in.aggregate != nullptr && in.operands.size() < 2) {
                    llvm::Type* agg = llty(in.aggregate);
                    if (agg->isStructTy() &&
                        in.imm < static_cast<int64_t>(agg->getStructNumElements())) {
                        out = b_.CreateStructGEP(agg, base, static_cast<unsigned>(in.imm),
                                                 in.text);
                        break;
                    }
                }

                // AN INDEX OPERAND IS AN INDEX, and ignoring it was why every indexed write went to
                // the same address: this used the constant `imm` and nothing else, so `xs[i] = v`
                // wrote to `xs[0]` for every `i`.
                if (in.operands.size() >= 2) {
                    llvm::Value* idx = operand(in, 1);
                    if (idx != nullptr && idx->getType()->isIntegerTy()) {
                        idx = b_.CreateSExtOrTrunc(idx, i64);
                        // A RAW POINTER IS NOT AN ARRAY: no length header, and its step comes from
                        // the pointee the lowering named. Adding the header to one walked every
                        // read of `p[i]` eight bytes past where it belonged.
                        //
                        // NEITHER IS AN INLINE ARRAY. `int[16]` states its extent in the type, so
                        // there is no header in front of it either -- element zero is at offset
                        // zero. Stepping over eight bytes of nothing put every read of `key[i]`
                        // two elements late and the last two past the end of the frame slot.
                        const bool raw = in.type != nullptr && in.type->kind == TypeKind::Ptr;
                        const bool inlineArray = in.type != nullptr &&
                                                 in.type->kind == TypeKind::Array &&
                                                 in.type->storage == ArrayStorage::Inline;
                        const Type* elem = raw ? in.aggregate
                                          : in.type != nullptr ? in.type->element
                                                               : nullptr;
                        const uint64_t stride =
                            elem != nullptr ? std::max<uint64_t>(1, elem->facts.size) : 4;
                        // Past the eight-byte length header, then `index * sizeof(element)`.
                        llvm::Value* off = b_.CreateMul(idx, llvm::ConstantInt::get(i64, stride));
                        if (!raw && !inlineArray) {
                            off = b_.CreateAdd(off, llvm::ConstantInt::get(i64, kArrayHeader));
                        }
                        out = b_.CreateGEP(llvm::Type::getInt8Ty(ctx_), base, off);
                        break;
                    }
                }
                if (in.text == "length") {
                    // The length lives at offset zero of the header.
                    out = base;
                    break;
                }
                out = b_.CreateGEP(llvm::Type::getInt8Ty(ctx_), base,
                                   llvm::ConstantInt::get(i64, in.imm));
                break;
            }

            case Op::Call: {
                llvm::Function* callee = fns_.count(in.text) != 0 ? fns_[in.text] : nullptr;
                if (callee == nullptr) {
                    break;
                }
                // EVERY ARGUMENT COERCED TO THE PARAMETER'S TYPE. The lowering's type propagation is
                // still incomplete -- it says so, counted -- so a value can arrive as a slice where
                // a pointer is declared. A backend that passes it anyway emits a module LLVM
                // refuses, and a module that does not verify tells you nothing about anything.
                // `undef` of the right type keeps the module well-formed, and Stage 2's differential
                // test against the old path is what reveals the value was wrong. That is the
                // division of labour: the verifier checks shape, the oracle checks meaning.
                // ...AND THE CALL CARRIES THE CALLEE'S CONVENTION. A `CallInst` defaults to `ccc`
                // whatever the function it names was declared with, and the two disagreeing is not
                // a cosmetic mismatch: on i686 `stdcall` means the CALLEE pops the arguments, so a
                // caller that thinks it is C pops them too and the stack unwinds by the argument
                // size on every call. `codegen_stdcall_is_real_on_i686` looks for exactly
                // `call x86_stdcallcc i32 @MessageBeep`, and it is looking at the caller for a
                // reason -- the declaration alone does not make the call site right.
                llvm::CallInst* direct = b_.CreateCall(callee, argumentsFor(callee, in));
                direct->setCallingConv(callee->getCallingConv());
                out = direct;
                break;
            }

            case Op::CallUnwind: {
                // `invoke` -- a call with two successors. The landing block is where the personality
                // routine resumes, and LLVM requires the function to declare one before any of this
                // is legal, which `personalityFor` installs on first use.
                llvm::Function* callee = fns_.count(in.text) != 0 ? fns_[in.text] : nullptr;
                llvm::BasicBlock* ok = blockOf(in, 0);
                llvm::BasicBlock* land = blockOf(in, 1);
                // NO LANDING BLOCK MEANS NO UNWINDING, NOT NO CALL.
                //
                // This used to `break` here, which emitted NOTHING -- the call disappeared and the
                // block was left with no terminator, so LLVM refused the whole module: "Basic Block
                // in function 'HttpClient.sendSecure' does not have terminator!". A freestanding
                // program is exactly the case: there is no unwinder under a kernel, so a `throw`
                // panics and the lowering has no landing block to offer.
                //
                // The right answer for a call that cannot unwind is an ORDINARY call, followed by
                // the edge the non-throwing path would have taken. It was invisible for as long as
                // it was because these three methods are unreachable in the programs that get built
                // and the reachability pass turned their bodies into declarations before the backend
                // ever saw them -- so the module verified, and three miscompiled methods sat in the
                // standard library waiting for the first program to call one.
                if (land == nullptr) {
                    llvm::Value* got = nullptr;
                    if (callee != nullptr) {
                        // The callee's convention, for the reason `Op::Call` gives.
                        llvm::CallInst* plain = b_.CreateCall(callee, argumentsFor(callee, in));
                        plain->setCallingConv(callee->getCallingConv());
                        got = plain;
                    } else if (llvm::Value* fp =
                                   coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0))) {
                        std::vector<llvm::Value*> args;
                        std::vector<llvm::Type*> types;
                        for (size_t i = 1; i < in.operands.size(); ++i) {
                            if (llvm::Value* a = valueOf(in.operands[i])) {
                                args.push_back(a);
                                types.push_back(a->getType());
                            }
                        }
                        llvm::Type* ret =
                            in.type != nullptr ? llty(in.type) : llvm::Type::getVoidTy(ctx_);
                        got = b_.CreateCall(llvm::FunctionType::get(ret, types, false), fp, args);
                    }
                    if (got != nullptr && !got->getType()->isVoidTy()) {
                        out = got;
                    }
                    if (ok != nullptr) {
                        b_.CreateBr(ok);
                    }
                    break;
                }
                if (ok == nullptr) {
                    break;
                }
                installPersonality(fns_[f.key]);
                if (callee != nullptr) {
                    // THE SAME ARGUMENTS AN ORDINARY CALL WOULD GET, and this used to build its
                    // own list -- one that stopped at `arg_size()` and so dropped every variadic
                    // argument. `printf("caught code=%d\n", code)` written inside a `try` became an
                    // `invoke` with the format string and nothing after it, and printed whatever
                    // was in the register. Two builders for one thing is how they came to differ.
                    llvm::InvokeInst* two =
                        b_.CreateInvoke(callee, ok, land, argumentsFor(callee, in));
                    two->setCallingConv(callee->getCallingConv());
                    out = two;
                    break;
                }
                // AN INDIRECT CALL UNWINDS TOO. Whatever a closure or a vtable slot points at can
                // throw -- that is the whole premise of `assertDoesNotThrow(action)` -- and leaving
                // it an ordinary call left the `catch` block with no edge into it: a `landing` that
                // is nobody's landing successor, which verifier rule 19 refuses and is right to.
                llvm::Value* fp = coerce(operand(in, 0), llvm::PointerType::get(ctx_, 0));
                std::vector<llvm::Value*> args;
                std::vector<llvm::Type*> types;
                for (size_t i = 1; i < in.operands.size(); ++i) {
                    if (llvm::Value* a = valueOf(in.operands[i])) {
                        args.push_back(a);
                        types.push_back(a->getType());
                    }
                }
                llvm::Type* ret =
                    in.type != nullptr ? llty(in.type) : llvm::Type::getVoidTy(ctx_);
                auto* ft = llvm::FunctionType::get(ret, types, false);
                llvm::InvokeInst* inv = b_.CreateInvoke(ft, fp, ok, land, args);
                out = ret->isVoidTy() ? nullptr : inv;
                break;
            }
            case Op::Raise: {
                installPersonality(fns_[f.key]);
                llvm::PointerType* ptrTy = llvm::PointerType::get(ctx_, 0);
                emitThrow(coerce(operand(in, 0), ptrTy),
                          in.edges.empty() ? nullptr : blockOf(in, 0));
                break;
            }
            case Op::Landing: {
                // A FUNCLET, AND AS LITTLE INSIDE IT AS POSSIBLE.
                //
                // MSVC unwinding is not `landingpad`: a handler is a FUNCLET, entered through a
                // `catchswitch`/`catchpad` pair, and every call made inside one has to carry a
                // `funclet` operand bundle naming the pad it belongs to. Emitting an Itanium
                // landing pad with `__CxxFrameHandler3` produced a module that either crashed the
                // X86 instruction selector or -- with the Itanium personality named instead --
                // linked and then terminated on the first `throw`, because a throw begun by
                // `_CxxThrowException` never finds an Itanium handler. Every sample with an
                // exception in it printed nothing at all.
                //
                // What keeps this small is the same trick the trusted path uses: the funclet does
                // NOTHING except receive the object and leave. The catch chain, the handler bodies
                // and the `finally` all run in ordinary context after a `catchret`, so none of
                // them needs a bundle and none of them has to be recognised as being inside a
                // funclet. The caught pointer travels out through a frame slot rather than as a
                // value, because a value defined in a funclet may not be used outside it.
                installPersonality(fns_[f.key]);
                llvm::PointerType* ptrTy = llvm::PointerType::get(ctx_, 0);
                llvm::Function* here = b_.GetInsertBlock()->getParent();
                llvm::IRBuilder<> atEntry(&here->getEntryBlock(),
                                          here->getEntryBlock().getFirstInsertionPt());
                llvm::Value* caught = atEntry.CreateAlloca(ptrTy, nullptr, "exc.caught");

                // THE DISPATCH BLOCK BELONGS TO ONE OF THE TWO MODELS, so it is created inside it.
                //
                // Made unconditionally, the Itanium path never used it: a landing pad goes in the
                // block that is already here and the object comes straight out of it, so
                // `catch.dispatch` was left empty with nothing to end it. LLVM refuses a module
                // containing one -- "Basic Block in function 'Test.assertDoesNotThrow' does not have
                // terminator!" -- and refusing the module takes every other function down with it.
                //
                // Only ELF targets were affected, which is why it went unseen: the corpus builds for
                // this machine, and this machine is Windows, where the block IS used. It surfaced on
                // the one program that is not hosted -- a kernel for `x86_64-unknown-none-elf`.
                auto* resumeBB = llvm::BasicBlock::Create(ctx_, "catch.chain", here);
                if (!msvcEh()) {
                    // Itanium: a landing pad, and the object comes straight out of it.
                    auto* pad = b_.CreateLandingPad(
                        llvm::StructType::get(ctx_, {ptrTy, llvm::Type::getInt32Ty(ctx_)}), 1);
                    pad->addClause(llvm::Constant::getNullValue(ptrTy));
                    b_.CreateStore(b_.CreateExtractValue(pad, 0), caught);
                    b_.CreateBr(resumeBB);
                } else {
                    auto* padBB = llvm::BasicBlock::Create(ctx_, "catch.dispatch", here);
                    llvm::CatchSwitchInst* cs = b_.CreateCatchSwitch(
                        llvm::ConstantTokenNone::get(ctx_), nullptr, 1);
                    cs->addHandler(padBB);
                    b_.SetInsertPoint(padBB);
                    llvm::CatchPadInst* pad = b_.CreateCatchPad(
                        cs, {ehTypeDescriptor(), llvm::ConstantInt::get(
                                                     llvm::Type::getInt32Ty(ctx_), 0),
                             caught});
                    b_.CreateCatchRet(pad, resumeBB);
                }
                b_.SetInsertPoint(resumeBB);
                tail_[b.id] = resumeBB;   // the rest of this PIR block lives here
                caughtSlot_[b.id] = caught;
                out = b_.CreateLoad(ptrTy, caught, "caught");
                break;
            }
            case Op::Resume: {
                // NOT `resume`: that is the Itanium instruction, and it needs a landing pad's
                // exception token, which a funclet does not produce. Re-raising is throwing the
                // same object again -- which is what the trusted path does -- and it lands in the
                // enclosing handler when there is one and leaves the function when there is not.
                installPersonality(fns_[f.key]);
                llvm::PointerType* ptrTy = llvm::PointerType::get(ctx_, 0);
                llvm::Value* exc = coerce(operand(in, 0), ptrTy);
                llvm::BasicBlock* outer = in.edges.empty() ? nullptr : blockOf(in, 0);
                emitThrow(exc, outer);
                break;
            }
            case Op::Br: {
                llvm::BasicBlock* to = blockOf(in, 0);
                if (to != nullptr) {
                    b_.CreateBr(to);
                }
                break;
            }
            case Op::BrCond: {
                llvm::BasicBlock* t = blockOf(in, 0);
                llvm::BasicBlock* e = blockOf(in, 1);
                if (t != nullptr && e != nullptr) {
                    llvm::Value* c = operand(in, 0);
                    if (c == nullptr) {
                        c = llvm::ConstantInt::getTrue(ctx_);
                    }
                    if (!c->getType()->isIntegerTy(1)) {
                        c = b_.CreateICmpNE(c, llvm::Constant::getNullValue(c->getType()));
                    }
                    b_.CreateCondBr(c, t, e);
                }
                break;
            }
            case Op::Ret: {
                llvm::Type* want = fns_[f.key]->getReturnType();
                if (want->isVoidTy()) {
                    b_.CreateRetVoid();
                } else {
                    b_.CreateRet(coerce(operand(in, 0), want));
                }
                break;
            }
            case Op::Unreachable:
                b_.CreateUnreachable();
                break;

            // ---- facts, LAST ----
            //
            // §11.10: `fact.*` becomes `llvm.assume` only after the guard eliminator has used it.
            // Here that means it is emitted, because by the time PIR reaches this backend the
            // passes have run.
            case Op::FactRequires:
            case Op::FactEnsures:
            case Op::FactInvariant: {
                llvm::Value* c = operand(in, 0);
                if (c != nullptr && c->getType()->isIntegerTy(1)) {
                    b_.CreateIntrinsic(llvm::Intrinsic::assume, {}, {c});
                    ++r_.assumes;
                }
                break;
            }

            // A GUARD THAT SURVIVED §11.3 IS A REAL CHECK -- and this said so and then emitted
            // nothing, so the PIR path had no bounds checking, no null check and no divisor check
            // at all. Two samples exist precisely to watch a program panic on an out-of-range
            // index; through here they read past the end instead and died with no message. A pass
            // whose whole job is deleting the guards it can PROVE redundant is worth nothing if the
            // ones it keeps are deleted too.
            case Op::GuardBounds: {
                llvm::Value* idx = operand(in, 0);
                llvm::Value* arr = operand(in, 1);
                if (idx == nullptr || arr == nullptr) {
                    break;
                }
                llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
                // A FIXED EXTENT IS IN THE TYPE. `int[16]` carries no length header, so reading
                // one gave the first two elements as a length -- which for a zeroed array is zero,
                // and the guard failed on index 0 of an array with sixteen slots in it.
                const Type* shape = in.aggregate;
                const bool inlineArray = shape != nullptr && shape->kind == TypeKind::Array &&
                                         shape->storage == ArrayStorage::Inline;
                llvm::Value* len = nullptr;
                if (inlineArray) {
                    len = llvm::ConstantInt::get(i64, shape->extent);
                } else {
                    auto* read = b_.CreateLoad(i64, coerce(arr, llvm::PointerType::get(ctx_, 0)),
                                               "arr.len");
                    // AN ARRAY'S LENGTH IS WRITTEN ONCE AND NEVER AGAIN. The header is filled by
                    // the allocation and there is no operation in the language that changes it --
                    // a collection that grows builds a NEW array and copies -- so a load of it
                    // returns the same value everywhere the array is alive.
                    //
                    // Saying so is what lets the check leave the loop. `matrixmul`'s inner loop
                    // stores a double into `c` on every iteration; without this, that store might
                    // have written the length of `a`, so the length had to be re-read, so the
                    // compare could not be hoisted, so a bounds check sat in the hottest loop in
                    // the benchmark. The trusted path folds the same length to a constant and its
                    // loop is clean: 27 ms against 64 ms, measured.
                    read->setMetadata(llvm::LLVMContext::MD_invariant_load,
                                      llvm::MDNode::get(ctx_, {}));
                    len = read;
                }
                // UNSIGNED, which catches a negative index in the same comparison: as an unsigned
                // quantity -1 is larger than any length there has ever been.
                emitGuard(b_.CreateICmpULT(coerce(idx, i64), len, "arr.inb"),
                          "array index out of bounds", "index", coerce(idx, i64), "length", len, 70,
                          /*tagged=*/true, in.loc);
                break;
            }
            case Op::GuardDivisor: {
                llvm::Value* d = operand(in, 0);
                if (d == nullptr || !d->getType()->isIntegerTy()) {
                    break;
                }
                llvm::Value* ok =
                    b_.CreateICmpNE(d, llvm::ConstantInt::get(d->getType(), 0), "div.ok");
                // THROWN WHERE THERE IS SOMETHING TO THROW. A hosted program can catch a bad
                // divisor and decide what it means; a freestanding one has no exception machinery
                // and the same failure is a panic (spec 36.3). Which one this is, is a property of
                // the module, and the class to raise came down with the guard.
                if (!in.text.empty() && in.aggregate != nullptr && hasUnwinder()) {
                    llvm::Function* fn = b_.GetInsertBlock()->getParent();
                    auto* bad = llvm::BasicBlock::Create(ctx_, "div.bad", fn);
                    auto* cont = llvm::BasicBlock::Create(ctx_, "div.ok", fn);
                    b_.CreateCondBr(ok, cont, bad);
                    b_.SetInsertPoint(bad);
                    emitThrow(newException(in.text, in.aggregate),
                              in.edges.empty() ? nullptr : blockOf(in, 0));
                    b_.SetInsertPoint(cont);
                    tail_[b.id] = cont;
                    break;
                }
                emitGuard(ok, "division by zero", nullptr, nullptr, nullptr, nullptr, 71,
                          /*tagged=*/true, in.loc);
                break;
            }
            // §21: THE VALUE FORM OF `Result`/`Option` IS A VALUE, and these three are all it needs.
            // `imm` carries the case index -- 0 is `Ok`/`Some` -- and the payload rides in one
            // 64-bit slot the tag says how to read.
            case Op::VariantMake: {
                llvm::StructType* vt = variantStruct();
                llvm::Value* agg = llvm::UndefValue::get(vt);
                agg = b_.CreateInsertValue(
                    agg,
                    llvm::ConstantInt::get(llvm::Type::getInt32Ty(ctx_),
                                           static_cast<uint64_t>(in.imm)),
                    {0u}, "var.tag");
                agg = b_.CreateInsertValue(
                    agg, variantEncode(in.operands.empty() ? nullptr : operand(in, 0)), {1u},
                    "var.val");
                out = agg;
                break;
            }
            case Op::VariantTag: {
                llvm::Value* v = operand(in, 0);
                if (v != nullptr && v->getType()->isStructTy()) {
                    out = b_.CreateExtractValue(v, {0u}, "var.tag");
                }
                break;
            }
            case Op::VariantPayload: {
                llvm::Value* v = operand(in, 0);
                if (v != nullptr && v->getType()->isStructTy()) {
                    out = variantDecode(b_.CreateExtractValue(v, {1u}, "var.pl"), llty(in.type));
                }
                break;
            }
            case Op::GuardNull: {
                llvm::Value* p = operand(in, 0);
                if (p == nullptr || !p->getType()->isPointerTy()) {
                    break;
                }
                llvm::Value* ok =
                    b_.CreateICmpNE(p, llvm::Constant::getNullValue(p->getType()), "nn");
                // A BROKEN PROMISE IS CATCHABLE IN A HOSTED PROGRAM. `cast<Dog*>(maybe)` is the
                // program saying "I checked this"; where it has not, a caller may still want to
                // decide what that means. Freestanding has no exception machinery and panics.
                if (!in.text.empty() && in.aggregate != nullptr && hasUnwinder()) {
                    llvm::Function* fn = b_.GetInsertBlock()->getParent();
                    auto* bad = llvm::BasicBlock::Create(ctx_, "null.bad", fn);
                    auto* cont = llvm::BasicBlock::Create(ctx_, "null.ok", fn);
                    b_.CreateCondBr(ok, cont, bad);
                    b_.SetInsertPoint(bad);
                    emitThrow(newException(in.text, in.aggregate),
                              in.edges.empty() ? nullptr : blockOf(in, 0));
                    b_.SetInsertPoint(cont);
                    tail_[b.id] = cont;
                    break;
                }
                // A DEREFERENCE AND A BROKEN CAST ARE DIFFERENT FAILURES and the other path spells
                // them differently -- `null reference dereference` at code 70 for reading through
                // something declared able to be null, `null reference` at 72 for a `cast<T*>` whose
                // promise did not hold. A differential compares the text.
                const bool deref =
                    std::find(in.extra.begin(), in.extra.end(), "dereference") != in.extra.end();
                emitGuard(ok, deref ? "null reference dereference" : "null reference", nullptr,
                          nullptr, nullptr, nullptr, deref ? 70 : 72, /*tagged=*/true, in.loc);
                break;
            }
            case Op::GuardContract: {
                llvm::Value* ok = operand(in, 0);
                if (ok == nullptr || !ok->getType()->isIntegerTy(1)) {
                    break;
                }
                // The message is the one the trusted path prints, word for word, because the
                // differential compares the text: a contract that reports itself differently is a
                // different program to anything reading the output.
                //
                // WHAT BROKE, WHERE, IN WHOSE METHOD, AND WITH WHICH VALUES. The lowering supplied
                // the clause kind, its text as written and the file it was written in; the line and
                // column are on the instruction; and the enclosing method's EMITTED name is knowable
                // only at this end, which is why the message is assembled here rather than handed
                // over finished. This printed `contract violated: requires` and stopped, which in a
                // file with three contracts is a bisection and across a codebase is a search.
                std::string where = in.extra.size() > 1 ? in.extra[1] : std::string();
                if (where.empty()) {
                    where = "<prelude>";
                }
                std::string msg = "contract violated: " + in.text + "\n";
                msg += "  --> " + where + ":" + std::to_string(in.loc.line) + ":" +
                       std::to_string(in.loc.col) + "  in " +
                       b_.GetInsertBlock()->getParent()->getName().str() + "\n";
                if (!in.extra.empty() && !in.extra[0].empty()) {
                    msg += "   |  " + in.extra[0] + "\n";
                }
                // The two sides, when the clause was a comparison the lowering judged safe to read a
                // second time. `emitGuard` prints the pair or neither, so it is both or nothing.
                llvm::Value* lv = in.operands.size() > 2 ? operand(in, 1) : nullptr;
                llvm::Value* rv = in.operands.size() > 2 ? operand(in, 2) : nullptr;
                if (lv == nullptr || rv == nullptr) {
                    lv = nullptr;
                    rv = nullptr;
                }
                // The trailing newline belongs to `emitGuard`, which adds exactly one.
                if (!msg.empty() && msg.back() == '\n') {
                    msg.pop_back();
                }
                // EXIT 1, WHICH IS WHAT A BROKEN CONTRACT MEANS. The panics beside it have codes of
                // their own -- 71 for a division by zero, 72 for a null reference -- and this had
                // been given 73 by the same reasoning. It is the wrong reasoning: a panic is the
                // language catching the program doing something impossible, and a contract is the
                // PROGRAM's own claim failing. The other backend exits 1, and a test whose whole
                // subject is that a violated invariant stops the program was reading the code:
                // `program exited with 73, expected 1`. Two compilers that stop the same program
                // with two different statuses is a difference a build script can see.
                emitGuard(ok, msg.c_str(), lv != nullptr ? "left" : nullptr, lv,
                          rv != nullptr ? "right" : nullptr, rv, 1, /*tagged=*/false);
                break;
            }
            case Op::GuardCast:
                break;

            default:
                // Anything the lowering can emit and this backend does not translate yet leaves the
                // value undefined rather than absent, so the module still verifies and the
                // difference shows up in the differential test rather than as a crash.
                if (producesValue(in.op) && in.type != nullptr) {
                    out = llvm::UndefValue::get(llty(in.type));
                }
                break;
        }
        (void)b;
        if (in.result != kNoValue && out != nullptr) {
            vals_[in.result] = out;
        }
    }

    // `add.checked` is not `add` plus a branch somebody wrote by hand: it is the fact that the
    // language checks, handed to LLVM as the intrinsic built for it. That is one of the fifteen
    // rows of §12 and it is the one the no-UB argument rests on.
    // A value forced to the type the position requires. Same type: unchanged. Two integers: the
    // ordinary narrowing or widening. Anything else: `undef`, which is what "this lowering has not
    // worked out the type yet" honestly is.
    llvm::Value* coerce(llvm::Value* v, llvm::Type* want) {
        if (want == nullptr) {
            return v;
        }
        if (v == nullptr) {
            return llvm::UndefValue::get(want);
        }
        if (v->getType() == want) {
            return v;
        }
        if (v->getType()->isIntegerTy() && want->isIntegerTy()) {
            if (v->getType()->getIntegerBitWidth() >= want->getIntegerBitWidth()) {
                return b_.CreateTrunc(v, want);
            }
            // A BOOLEAN WIDENS BY ZERO. `i1` has one bit and it is the sign bit, so sign-extending
            // `true` gives -1 -- which is what every predicate in the standard library returned the
            // moment its result reached an `int`. `vec=1 ecb=1 ctr=1` came out `vec=-1 ecb=-1
            // ctr=-1`: not a crash, not a wrong branch, just every true printed as minus one.
            return v->getType()->isIntegerTy(1) ? b_.CreateZExt(v, want) : b_.CreateSExt(v, want);
        }
        if (v->getType()->isPointerTy() && want->isPointerTy()) {
            return v;
        }
        // AN ADDRESS AND A POINTER ARE THE SAME BITS. Returning `undef` for the pair meant a value
        // the lowering had not yet managed to type became a hole rather than the number it already
        // was -- and a store through that hole is a wild write, not a diagnostic.
        if (v->getType()->isIntegerTy() && want->isPointerTy()) {
            return b_.CreateIntToPtr(b_.CreateZExtOrTrunc(v, llvm::Type::getInt64Ty(ctx_)), want);
        }
        if (v->getType()->isPointerTy() && want->isIntegerTy()) {
            return b_.CreateZExtOrTrunc(b_.CreatePtrToInt(v, llvm::Type::getInt64Ty(ctx_)), want);
        }
        return llvm::UndefValue::get(want);
    }

    // The escapes the front end leaves in a string literal, resolved -- BY THE LANGUAGE'S ONE
    // DECODER. This was a second copy of it, and a second copy of a rule is a copy that is missing
    // something: this one knew `\n \t \r \0 \\ \"` and not `\xNN`, so it dropped the backslash and
    // kept the letters. `b"\xe3\x61"`, whose whole purpose is raw bytes, became the six characters
    // `x`, `e`, `3`, `x`, `6`, `1`.
    //
    // The trusted decoder carries the same story in its own comment, from the same kernel: pico
    // wrote a user-mode trampoline as `b"\x48\x63\xC1\xC3"` and the guest executed `x`, `4`, `8`.
    // Here it came out as pico's console drawing no accents at all -- the CP437 lookup table is a
    // hundred `\xNN` bytes, and every index into it read a hex digit instead of a glyph number.
    static std::string unescape(const std::string& s) { return cgutil::resolveEscapes(s); }

    // A function that unwinds must name the personality routine that walks its frames. Installed on
    // first use rather than on every function, because a personality on a function that never
    // unwinds is a relocation to a symbol the program did not need.
    // ---- starting an unwind ----
    //
    // HOW A THROW BEGINS IS A TARGET QUESTION. On MSVC it is `_CxxThrowException` plus four
    // constant globals describing what is being thrown; elsewhere it is `__cxa_throw`. The shapes
    // below are the ones the trusted path builds, byte for byte, because the two have to be
    // catchable by the same runtime and a throw that describes itself differently is not caught,
    // it terminates.
    bool msvcEh() const {
        const std::string t = mod_.getTargetTriple();
        if (!t.empty()) {
            return t.find("windows") != std::string::npos || t.find("msvc") != std::string::npos;
        }
#ifdef _WIN32
        return true;
#else
        return false;
#endif
    }

    llvm::Constant* imageBaseSym() {
        if (llvm::GlobalVariable* g = mod_.getNamedGlobal("__ImageBase")) {
            return g;
        }
        return new llvm::GlobalVariable(mod_, llvm::Type::getInt8Ty(ctx_), true,
                                        llvm::GlobalValue::ExternalLinkage, nullptr, "__ImageBase");
    }

    // An image-relative 32-bit offset, which is how every pointer inside the MSVC EH tables is
    // written -- they live in read-only data and cannot carry a relocation to an absolute address.
    llvm::Constant* imageRel(llvm::Constant* x) {
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        return llvm::ConstantExpr::getTrunc(
            llvm::ConstantExpr::getSub(llvm::ConstantExpr::getPtrToInt(x, i64),
                                       llvm::ConstantExpr::getPtrToInt(imageBaseSym(), i64)),
            llvm::Type::getInt32Ty(ctx_));
    }

    // A FREESTANDING MODULE HAS NO EXCEPTION MACHINERY, and says so in its triple. The same
    // failure that a hosted program can catch is a panic there (spec 36.3).
    bool freestanding() const {
        return pir_.triple.find("none") != std::string::npos;
    }

    // Whether anything calls `main`. See `emitEntry`: this is a question about the TARGET, and it
    // is not the same question as `freestanding()` even though the common answer coincides.
    bool hasCRuntime() const {
        if (pir_.triple.find("none") != std::string::npos) {
            return false;
        }
        if (pir_.triple.rfind("wasm", 0) == 0 &&
            pir_.triple.find("wasi") == std::string::npos) {
            return false;
        }
        return true;
    }

    // WHETHER AN EXCEPTION HAS ANYWHERE TO GO, which is a THIRD question about the target and not
    // either of the two above.
    //
    // `freestanding()` reads the word "none" out of the triple, and that is right for a kernel and
    // wrong for `wasm32-unknown-unknown`: a WebAssembly module is not "none", has no libc++abi
    // under it either, and cannot IMPORT one -- an undefined `__cxa_throw` becomes an entry in the
    // module's import table, and the browser refuses to instantiate the whole thing before a line
    // of it runs. `Import #0 "env": module is not an object or function` was the page's entire
    // output, from a division guard inside `Screen.writeInt` that the program never asked to be
    // catchable and could not have caught.
    //
    // Wasm WITH wasi has a runtime and keeps its exceptions.
    bool hasUnwinder() const { return hasCRuntime(); }

    // ONE EXCEPTION OBJECT, built where it is thrown: allocate it and run its constructor. The
    // class is one the prelude declares, so its constructor is in the module under the usual key.
    llvm::Value* newException(const std::string& cls, const Type* shape) {
        llvm::PointerType* ptrTy = llvm::PointerType::get(ctx_, 0);
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        const uint64_t bytes = std::max<uint64_t>(
            8, mod_.getDataLayout().getTypeAllocSize(llty(shape)));
        llvm::FunctionCallee alloc = mod_.getOrInsertFunction(
            "__polaron_malloc", llvm::FunctionType::get(ptrTy, {i64}, false));
        llvm::Value* obj = b_.CreateCall(alloc, {llvm::ConstantInt::get(i64, bytes)}, "exc.obj");
        if (auto it = fns_.find(cls + "." + cls); it != fns_.end() && it->second != nullptr) {
            b_.CreateCall(it->second, {obj});
        }
        return obj;
    }

    // STARTING AN UNWIND, with somewhere for it to land.
    //
    // `_CxxThrowException` takes the ADDRESS of the thing being thrown, so the object pointer is
    // spilled to a frame slot first -- handing over the object itself throws whatever its first
    // word happens to be. When the throw sits inside a `try`, it is an INVOKE rather than a call:
    // that is the only thing that makes the enclosing handler reachable, and without it a `throw`
    // written inside the `try` that catches it left the function instead.
    void emitThrow(llvm::Value* obj, llvm::BasicBlock* unwindTo) {
        llvm::PointerType* ptrTy = llvm::PointerType::get(ctx_, 0);
        llvm::Type* voidTy = llvm::Type::getVoidTy(ctx_);
        llvm::FunctionCallee raiser;
        std::vector<llvm::Value*> args;
        if (msvcEh()) {
            llvm::Function* here = b_.GetInsertBlock()->getParent();
            llvm::IRBuilder<> atEntry(&here->getEntryBlock(),
                                      here->getEntryBlock().getFirstInsertionPt());
            llvm::Value* slot = atEntry.CreateAlloca(ptrTy, nullptr, "exc.thrown");
            b_.CreateStore(obj, slot);
            raiser = mod_.getOrInsertFunction(
                "_CxxThrowException", llvm::FunctionType::get(voidTy, {ptrTy, ptrTy}, false));
            args = {slot, throwInfo()};
        } else {
            raiser = mod_.getOrInsertFunction(
                "__cxa_throw", llvm::FunctionType::get(voidTy, {ptrTy, ptrTy, ptrTy}, false));
            args = {obj, llvm::ConstantPointerNull::get(ptrTy),
                    llvm::ConstantPointerNull::get(ptrTy)};
        }
        if (unwindTo != nullptr) {
            llvm::Function* here = b_.GetInsertBlock()->getParent();
            auto* gone = llvm::BasicBlock::Create(ctx_, "throw.gone", here);
            b_.CreateInvoke(raiser, gone, unwindTo, args);
            b_.SetInsertPoint(gone);
            b_.CreateUnreachable();   // the normal edge of a throw is never taken
            return;
        }
        b_.CreateCall(raiser, args);
        b_.CreateUnreachable();   // neither raiser returns
    }

    // The `void*` type descriptor a `catch` clause names. Everything Polaron throws is a pointer to
    // an object, and WHICH class it is gets decided by the vtable comparisons the lowering emitted
    // rather than by the personality -- one place decides, and it is the one that can see the
    // source. `throwInfo` builds the same descriptor for the throwing side; this hands back just
    // the descriptor, which is what a catch clause takes.
    llvm::Constant* ehTypeDescriptor() {
        throwInfo();   // builds `??_R0PEAX@8` on first use
        if (llvm::GlobalVariable* td = mod_.getNamedGlobal("??_R0PEAX@8")) {
            return td;
        }
        return llvm::ConstantPointerNull::get(llvm::PointerType::get(ctx_, 0));
    }

    llvm::Constant* throwInfo() {
        if (throwInfo_ != nullptr) {
            return throwInfo_;
        }
        llvm::Type* i32 = llvm::Type::getInt32Ty(ctx_);
        llvm::PointerType* ptrTy = llvm::PointerType::get(ctx_, 0);
        llvm::GlobalVariable* tiVt = mod_.getNamedGlobal("??_7type_info@@6B@");
        if (tiVt == nullptr) {
            tiVt = new llvm::GlobalVariable(mod_, ptrTy, true, llvm::GlobalValue::ExternalLinkage,
                                            nullptr, "??_7type_info@@6B@");
        }
        // The descriptor for `void*` (PEAX): everything Polaron throws is a pointer to an object,
        // and which class it is gets decided by the `catch` chain the lowering emitted rather than
        // by the personality -- one place decides, and it is the one that can see the source.
        llvm::Constant* nameStr = llvm::ConstantDataArray::getString(ctx_, ".PEAX", true);
        llvm::StructType* tdTy =
            llvm::StructType::get(ctx_, {ptrTy, ptrTy, nameStr->getType()});
        auto* td = new llvm::GlobalVariable(
            mod_, tdTy, false, llvm::GlobalValue::InternalLinkage,
            llvm::ConstantStruct::get(tdTy, {tiVt, llvm::ConstantPointerNull::get(ptrTy), nameStr}),
            "??_R0PEAX@8");

        llvm::StructType* ctTy =
            llvm::StructType::get(ctx_, {i32, i32, i32, i32, i32, i32, i32});
        auto* ct = new llvm::GlobalVariable(
            mod_, ctTy, true, llvm::GlobalValue::InternalLinkage,
            llvm::ConstantStruct::get(
                ctTy, {llvm::ConstantInt::get(i32, 1), imageRel(td), llvm::ConstantInt::get(i32, 0),
                       llvm::ConstantInt::get(i32, -1), llvm::ConstantInt::get(i32, 0),
                       llvm::ConstantInt::get(i32, 8), llvm::ConstantInt::get(i32, 0)}),
            "_CT??_R0PEAX@88");
        ct->setSection(".xdata");

        llvm::ArrayType* arrTy = llvm::ArrayType::get(i32, 1);
        llvm::StructType* ctaTy = llvm::StructType::get(ctx_, {i32, arrTy});
        auto* cta = new llvm::GlobalVariable(
            mod_, ctaTy, true, llvm::GlobalValue::InternalLinkage,
            llvm::ConstantStruct::get(ctaTy, {llvm::ConstantInt::get(i32, 1),
                                              llvm::ConstantArray::get(arrTy, {imageRel(ct)})}),
            "_CTA1PEAX");
        cta->setSection(".xdata");

        llvm::StructType* tiTy = llvm::StructType::get(ctx_, {i32, i32, i32, i32});
        auto* ti = new llvm::GlobalVariable(
            mod_, tiTy, true, llvm::GlobalValue::InternalLinkage,
            llvm::ConstantStruct::get(tiTy, {llvm::ConstantInt::get(i32, 0),
                                             llvm::ConstantInt::get(i32, 0),
                                             llvm::ConstantInt::get(i32, 0), imageRel(cta)}),
            "_TI1PEAX");
        ti->setSection(".xdata");
        throwInfo_ = ti;
        return ti;
    }

    // Past a couple of guards the compare chain costs more than the indirect branch it replaces.
    static constexpr size_t kMaxSpeculatedTargets = 2;

    // SPECULATIVE DEVIRTUALIZATION -- a polymorphic inline cache, built at compile time.
    //
    // A vtable call is three instructions and looks cheap. The indirect BRANCH is the expensive
    // part: when the receiver's type alternates, the predictor misses every time, and the call is
    // opaque to the inliner, so the body never fuses with its caller. `virtualcall.pol` -- one
    // interface, two implementations, alternating -- measured 288 ms through this backend against
    // 101 ms through the trusted one, which has done this since it was measured 2.8x behind g++.
    //
    // The transform: compare the loaded slot against the handful of implementations the program
    // actually contains, call those DIRECTLY on a match so the inliner can swallow them, and keep
    // the indirect call as the fallback.
    //
    // It needs no type analysis to justify it, and this is worth being precise about, because it
    // looks like it should. The guard compares the function POINTER against a specific
    // implementation's address. A wrong guess -- a subclass nobody knew about, a slot patched at
    // run time, a `unimport`ed type whose slot now holds a trap -- fails the compare and falls
    // through to exactly the indirect call that would have happened anyway. There is no reading of
    // the receiver's type anywhere in it, so there is nothing about the receiver to get wrong.
    //
    // Returns null when speculation is declined; the caller then emits its ordinary indirect call.
    llvm::Value* speculate(const Inst& in, llvm::FunctionType* ft, llvm::Value* callee,
                           const std::vector<llvm::Value*>& args) {
        if (in.operands.empty()) {
            return nullptr;
        }
        const auto slot = fromSlot_.find(in.operands[0]);
        if (slot == fromSlot_.end()) {
            return nullptr;   // an ordinary funcptr or closure call: no table, no candidates
        }
        std::vector<llvm::Function*> cands;
        for (const Global& g : pir_.globals) {
            if (slot->second < 0 ||
                static_cast<size_t>(slot->second) >= g.initFns.size()) {
                continue;
            }
            const std::string& key = g.initFns[static_cast<size_t>(slot->second)];
            if (key.empty()) {
                continue;
            }
            const auto had = fns_.find(key);
            if (had == fns_.end() || had->second == nullptr) {
                continue;
            }
            llvm::Function* impl = had->second;
            // THE SIGNATURE MUST MATCH TO CALL IT DIRECTLY. Checked, not assumed: a slot number is
            // shared by every method of that name, and two classes can spell one name differently.
            if (impl->getFunctionType() != ft) {
                continue;
            }
            if (std::find(cands.begin(), cands.end(), impl) != cands.end()) {
                continue;
            }
            cands.push_back(impl);
            if (cands.size() > kMaxSpeculatedTargets) {
                return nullptr;
            }
        }
        if (cands.empty()) {
            return nullptr;
        }

        llvm::Function* fn = b_.GetInsertBlock()->getParent();
        const bool isVoid = ft->getReturnType()->isVoidTy();
        auto* join = llvm::BasicBlock::Create(ctx_, "dv.join", fn);
        std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> incoming;
        for (llvm::Function* c : cands) {
            auto* hit = llvm::BasicBlock::Create(ctx_, "dv.hit", fn);
            auto* miss = llvm::BasicBlock::Create(ctx_, "dv.miss", fn);
            b_.CreateCondBr(b_.CreateICmpEQ(callee, c, "dv.is"), hit, miss);
            b_.SetInsertPoint(hit);
            llvm::Value* r = b_.CreateCall(ft, c, args);
            if (!isVoid) {
                incoming.push_back({r, b_.GetInsertBlock()});
            }
            b_.CreateBr(join);
            b_.SetInsertPoint(miss);
        }
        llvm::Value* fallback = b_.CreateCall(ft, callee, args);
        if (!isVoid) {
            incoming.push_back({fallback, b_.GetInsertBlock()});
        }
        b_.CreateBr(join);
        b_.SetInsertPoint(join);
        // THE PIR BLOCK NOW ENDS HERE, for the same reason a guard's does: the block this call was
        // written in no longer branches anywhere, and the block-argument wiring names the block a
        // value was produced in.
        tail_[emittingBlock_] = join;
        ++r_.speculated;
        if (isVoid) {
            return llvm::UndefValue::get(llvm::Type::getInt32Ty(ctx_));   // the caller ignores it
        }
        llvm::PHINode* phi = b_.CreatePHI(ft->getReturnType(), incoming.size(), "dv.r");
        for (auto& [v, bb] : incoming) {
            phi->addIncoming(v, bb);
        }
        return phi;
    }

    // A DECLARATION NOTHING CALLS IS NOT PART OF THE PROGRAM.
    //
    // Lowering declares a runtime helper the first time it might be needed, and several are
    // declared on a path that then does not use them. In a hosted build that costs nothing -- the
    // linker never looks for a symbol with no reference. In a FREESTANDING one it is a claim about
    // the program: three tests read the emitted IR and require that a bare-metal program which
    // touches no `String` carries no string runtime, and that one built entirely of value types
    // carries no allocator. `declare ptr @__polaron_str_copy(ptr)` with nobody calling it fails
    // them, and it is not wrong so much as untrue -- the program does not use it.
    //
    // Intrinsics are left alone: LLVM owns their declarations and erasing one is its business.
    void dropUnusedDeclarations() {
        // ...AND THE FREESTANDING BRIDGES NOBODY CALLS. These are emitted as DEFINITIONS, before
        // it is known whether the program uses them -- `emitStringBridge` cannot see the future --
        // so a bare-metal program that touches no `String` still carried the whole string runtime.
        // The other backend emits them the same way and lets its dead-code strip take them out;
        // this is that strip, for the same symbols. External linkage keeps LLVM's own DCE off them,
        // which is right for every other purpose and wrong for exactly this one.
        static const char* const kBridges[] = {
            "__polaron_str_copy",    "__polaron_str_free",   "__polaron_str_index",
            "__polaron_ptrset_new",  "__polaron_ptrset_add", "__polaron_ptrset_free",
        };
        for (const char* sym : kBridges) {
            llvm::Function* f = mod_.getFunction(sym);
            if (f == nullptr || f->isDeclaration()) {
                continue;
            }
            if (f->use_empty()) {
                f->eraseFromParent();
                continue;
            }
            // A BRIDGE STILL IN USE HERE MAY BE DEAD ONE PASS LATER, and external linkage means
            // nobody may say so. This strip runs while the program is still whole; the optimiser
            // then deletes the methods that called the bridge, and the definition survives them --
            // unreachable, unremovable, and a `duplicate symbol` the moment the object meets a real
            // string runtime. `address_discipline` and `unimport_freestanding` both failed to link
            // that way, with ZERO calls left in the module that defined the thing twice.
            //
            // Internal linkage hands the question to LLVM, which can ask it at every point this
            // code cannot reach. The bridge only ever serves calls from inside its own module -- it
            // exists because a freestanding program has no libc to call instead -- so nothing
            // outside was entitled to bind to it.
            f->setLinkage(llvm::GlobalValue::InternalLinkage);
        }
        std::vector<llvm::Function*> gone;
        for (llvm::Function& f : mod_.functions()) {
            if (f.isDeclaration() && f.use_empty() && !f.isIntrinsic()) {
                gone.push_back(&f);
            }
        }
        for (llvm::Function* f : gone) {
            f->eraseFromParent();
        }
    }

    // WHAT MAY ALIAS WHAT, said in the only vocabulary LLVM has for it.
    //
    // Without this the optimiser must assume every store reaches every load, and the cost is not
    // theoretical -- it is the difference between a bounds check that folds away and one that
    // stays. `virtualcall` reads `shapes[i]` in a loop whose trip count matches the array's own
    // length; the length lives in the array header and the loop before it calls the allocator two
    // thousand times. With nothing said about aliasing, the allocator "might" have written the
    // length field, so the length could not be forwarded to the compare, so `i < len` could not be
    // folded, so ten panic calls stayed in a hot loop the trusted path leaves empty. Measured
    // there: 288 ms against 101 ms, and this is the larger half of the gap.
    //
    // The tree is deliberately the SAME ONE the trusted path builds -- one root, an omnivorous
    // "polaron char" under it that aliases everything, and one scalar node per machine type. Two
    // paths through one language must not disagree about what aliases what, and a difference here
    // is not a difference of opinion, it is one of them being wrong at -O2 only.
    //
    // TAGGED BY MACHINE TYPE, NOT BY FIELD, and that is a real restraint. A per-field tree would
    // say `Rect.w` and `Rect.h` never alias, which is true, and would also have to prove it stays
    // true through every cast, union, `reinterpret`, region snapshot and hand-written `asm` block
    // in the language. By scalar type the claim is the one C has made for thirty years and the one
    // the runtime is already compiled under.
    void attachTBAA() {
        llvm::MDBuilder mdb(ctx_);
        llvm::MDNode* root = mdb.createTBAARoot("polaron TBAA");
        llvm::MDNode* omni = mdb.createTBAAScalarTypeNode("polaron char", root);
        std::unordered_map<std::string, llvm::MDNode*> cat;
        auto node = [&](const char* name) -> llvm::MDNode* {
            const auto it = cat.find(name);
            if (it != cat.end()) {
                return it->second;
            }
            return cat[name] = mdb.createTBAAScalarTypeNode(name, omni);
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
                return nullptr;   // aggregate, vector, half: left conservative
            }
            return mdb.createTBAAStructTagNode(n, n, 0);
        };
        // THE STRUCTS A TAG MAY BE PUT ON: every class this backend built a type for, less the
        // unions. A `gep` through one of these addresses a declared field, and a field has one
        // type for the life of the object.
        std::unordered_set<llvm::Type*> tellable;
        for (const auto& [pt, lt] : types_) {
            if (pt == nullptr || pt->kind != TypeKind::Struct || lt == nullptr) {
                continue;
            }
            const auto known = pir_.classes.find(pt->name);
            if (known != pir_.classes.end() && known->second.overlapping) {
                continue;
            }
            tellable.insert(lt);
        }
        auto addressesAField = [&](llvm::Value* p) {
            auto* gep = llvm::dyn_cast<llvm::GetElementPtrInst>(p);
            return gep != nullptr && tellable.count(gep->getSourceElementType()) > 0;
        };
        for (llvm::Function& f : mod_) {
            for (llvm::BasicBlock& bb : f) {
                for (llvm::Instruction& inst : bb) {
                    if (auto* load = llvm::dyn_cast<llvm::LoadInst>(&inst)) {
                        if (addressesAField(load->getPointerOperand())) {
                            if (llvm::MDNode* tag = tagFor(load->getType())) {
                                load->setMetadata(llvm::LLVMContext::MD_tbaa, tag);
                                ++r_.aliasTags;
                            }
                        }
                    } else if (auto* store = llvm::dyn_cast<llvm::StoreInst>(&inst)) {
                        if (addressesAField(store->getPointerOperand())) {
                            if (llvm::MDNode* tag = tagFor(store->getValueOperand()->getType())) {
                                store->setMetadata(llvm::LLVMContext::MD_tbaa, tag);
                                ++r_.aliasTags;
                            }
                        }
                    }
                }
            }
        }
    }

    // THE RUNTIME METHOD A FAILED CHECK CALLS, declared cold and non-returning.
    //
    // `unreachable` already follows every one of these calls, so `noreturn` claims nothing new --
    // it says the same thing one instruction earlier, where the INLINER can read it. `cold` is the
    // part that was missing entirely: without it a panic call is costed as ordinary code, and a
    // small method whose only bulk is its bounds check was judged too expensive to inline.
    llvm::FunctionCallee guardExit(const char* name, llvm::FunctionType* ft) {
        llvm::FunctionCallee c = mod_.getOrInsertFunction(name, ft);
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
            if (!f->hasFnAttribute(llvm::Attribute::Cold)) {
                f->addFnAttr(llvm::Attribute::Cold);
                f->addFnAttr(llvm::Attribute::NoReturn);
                ++r_.coldAttrs;   // once per method, not once per call site
            }
        }
        return c;
    }

    // A CHECK IS A BRANCH TO A COLD BLOCK THAT DOES NOT RETURN. `ok` is the condition under which
    // the program continues; the other edge calls the runtime, which prints what was wrong and with
    // which two numbers, and stops. The failing side is `unreachable` after the call, so nothing
    // downstream has to consider the possibility that it fell through.
    // `tagged` distinguishes the two families: a PANIC announces itself (`Polaron panic: array
    // index out of bounds`) and a CONTRACT does not (`contract violated: requires`). The trusted
    // path prints exactly these, and the differential compares the text -- so the tag is part of
    // the message, not decoration.
    // WHERE THE CHECK WAS WRITTEN, as the line the other backend prints under the headline:
    //
    //     Polaron panic: array index out of bounds
    //       --> <prelude>:379:21  in ArrayList$int.get
    //        |  index = 4, length = 4
    //
    // Without it a panic names the KIND of accident and withholds what finds it -- and this backend
    // withheld it on every guard in the language. Four samples in the corpus print exactly this and
    // the differential called them equal for months, because it discarded stderr and a panic goes
    // there. Two blindnesses, one of them mine, and neither visible from the other side.
    std::string whereLine(const SourceLocation& loc) const {
        if (loc.line <= 0) {
            return "";
        }
        std::string file(loc.file);
        if (file.empty()) {
            file = "<prelude>";
        }
        std::string out =
            "  --> " + file + ":" + std::to_string(loc.line) + ":" + std::to_string(loc.col);
        if (b_.GetInsertBlock() != nullptr && b_.GetInsertBlock()->getParent() != nullptr) {
            out += "  in " + b_.GetInsertBlock()->getParent()->getName().str();
        }
        return out + "\n";
    }

    void emitGuard(llvm::Value* ok, const char* headline, const char* aLabel, llvm::Value* aVal,
                   const char* bLabel, llvm::Value* bVal, int code, bool tagged = true,
                   // LINE ZERO MEANS "NO LOCATION", and it has to be written out: a default-built
                   // `SourceLocation` starts at line 1, so leaving this defaulted stamped every
                   // guard that did not ask for one with `--> <prelude>:1:1`. The contract guards
                   // carry their location inside the message already, and got two.
                   const SourceLocation& where = SourceLocation{{}, 0, 0}) {
        llvm::Function* fn = b_.GetInsertBlock()->getParent();
        auto* bad = llvm::BasicBlock::Create(ctx_, "guard.bad", fn);
        auto* cont = llvm::BasicBlock::Create(ctx_, "guard.ok", fn);
        llvm::BranchInst* br = b_.CreateCondBr(ok, cont, bad);
        // ...AND THE BLOCK IS TOLD TO BE COLD, which until now only the comment above said.
        //
        // A guard is a branch whose failing edge ends in `unreachable`, and LLVM will not infer
        // from that alone how to LAY THE FUNCTION OUT: with no weights it splits the difference and
        // is free to place the panic call between two halves of the hot path, so a method with a
        // bounds check in a loop got the loop body straddling a call nobody makes. The weights say
        // what the language means -- a check that fires stops the program -- and the block-placement
        // pass then sinks every `guard.bad` to the end of the function, leaving the arithmetic
        // contiguous. `checked=1653` of these in Forge alone.
        //
        // 2^20 to 1 rather than 1 to 0: a zero weight is a claim the edge is DEAD, and the edge is
        // not dead, it is rare. The distinction matters to the inliner, which drops a body it
        // believes unreachable and would take the panic call with it.
        llvm::MDBuilder md(ctx_);
        br->setMetadata(llvm::LLVMContext::MD_prof, md.createBranchWeights(1u << 20, 1));

        b_.SetInsertPoint(bad);
        llvm::Type* i32 = llvm::Type::getInt32Ty(ctx_);
        llvm::Type* i64 = llvm::Type::getInt64Ty(ctx_);
        llvm::PointerType* ptr = llvm::PointerType::get(ctx_, 0);
        if (aVal != nullptr && bVal != nullptr) {
            // `__polaron_fail` PRINTS THE HEADLINE VERBATIM, tag included; `__polaron_panic` adds
            // its own. Getting that backwards puts the tag in twice or leaves it out, and the
            // differential compares the text.
            llvm::FunctionType* ft = llvm::FunctionType::get(
                llvm::Type::getVoidTy(ctx_), {ptr, ptr, i64, ptr, i64, i32}, false);
            b_.CreateCall(guardExit("__polaron_fail", ft),
                          {b_.CreateGlobalStringPtr(
                               (tagged ? std::string("Polaron panic: ") : std::string()) +
                               headline + "\n" + whereLine(where)),
                           b_.CreateGlobalStringPtr(aLabel), coerce(aVal, i64),
                           b_.CreateGlobalStringPtr(bLabel), coerce(bVal, i64),
                           llvm::ConstantInt::get(i32, code)});
        } else if (tagged && !whereLine(where).empty()) {
            // A GUARD WITH NO VALUES TO REPORT STILL HAS A LINE, and the line is most of what makes
            // the diagnostic useful: `null reference dereference` alone says what happened and not
            // where, which on a program with fifty dereferences is a bisect rather than an answer.
            // `__polaron_panic` takes a headline and adds its own tag, with nowhere to put the
            // location; `__polaron_fail` prints VERBATIM, so the whole message is built here.
            llvm::FunctionType* ft = llvm::FunctionType::get(
                llvm::Type::getVoidTy(ctx_), {ptr, ptr, i64, ptr, i64, i32}, false);
            llvm::Constant* none = llvm::ConstantPointerNull::get(ptr);
            b_.CreateCall(guardExit("__polaron_fail", ft),
                          {b_.CreateGlobalStringPtr(std::string("Polaron panic: ") + headline +
                                                    "\n" + whereLine(where)),
                           none, llvm::ConstantInt::get(i64, 0), none,
                           llvm::ConstantInt::get(i64, 0), llvm::ConstantInt::get(i32, code)});
        } else if (tagged) {
            llvm::FunctionType* ft =
                llvm::FunctionType::get(llvm::Type::getVoidTy(ctx_), {ptr}, false);
            b_.CreateCall(guardExit("__polaron_panic", ft),
                          {b_.CreateGlobalStringPtr(headline)});
        } else {
            // `__polaron_fail` prints its headline VERBATIM, which is the only way to say a line
            // that does not begin with the panic tag.
            llvm::FunctionType* ft = llvm::FunctionType::get(
                llvm::Type::getVoidTy(ctx_), {ptr, ptr, i64, ptr, i64, i32}, false);
            llvm::Constant* none = llvm::ConstantPointerNull::get(ptr);
            b_.CreateCall(guardExit("__polaron_fail", ft),
                          {b_.CreateGlobalStringPtr(std::string(headline) + "\n"), none,
                           llvm::ConstantInt::get(i64, 0), none, llvm::ConstantInt::get(i64, 0),
                           llvm::ConstantInt::get(i32, code)});
        }
        b_.CreateUnreachable();
        b_.SetInsertPoint(cont);
        // THE PIR BLOCK NOW ENDS HERE. Without this the phi wiring names the block the guard was
        // written in, which no longer branches anywhere.
        tail_[emittingBlock_] = cont;
    }

    void installPersonality(llvm::Function* fn) {
        if (fn == nullptr || fn->hasPersonalityFn()) {
            return;
        }
        // THE PERSONALITY MUST MATCH THE PLATFORM'S UNWINDER. This installed the Itanium one
        // unconditionally, including on Windows, where the trusted path uses `__CxxFrameHandler3`;
        // the two describe frames differently, so a throw crossing such a frame is not caught, it
        // terminates.
        // AND NOW IT DOES MATCH. `Op::Landing` emits funclets -- `catchswitch`, `catchpad`,
        // `catchret` -- which is what `__CxxFrameHandler3` walks and what the trusted path has
        // always emitted. The Itanium pair stayed here for a while as the one that at least
        // COMPILED, and it cost every exception sample in the corpus: a throw begun by
        // `_CxxThrowException` never found an Itanium handler, so the program terminated with no
        // output at all rather than running its `catch`.
        auto* ty = llvm::FunctionType::get(llvm::Type::getInt32Ty(ctx_), true);
        fn->setPersonalityFn(llvm::cast<llvm::Constant>(
            mod_.getOrInsertFunction(msvcEh() ? "__CxxFrameHandler3" : "__gxx_personality_v0", ty)
                .getCallee()));
    }

    llvm::Value* undefOf(const Inst& in) {
        return in.type != nullptr ? llvm::UndefValue::get(llty(in.type)) : nullptr;
    }

    // EVERY ARGUMENT COERCED TO THE PARAMETER'S TYPE, and the variadic tail after it.
    //
    // The lowering's type propagation is still incomplete -- it says so, counted -- so a value can
    // arrive as a slice where a pointer is declared. A backend that passes it anyway emits a module
    // LLVM refuses, and a module that does not verify tells you nothing about anything. `undef` of
    // the right type keeps the module well-formed, and the differential test against the trusted
    // path is what reveals the value was wrong. That is the division of labour: the verifier checks
    // shape, the oracle checks meaning.
    std::vector<llvm::Value*> argumentsFor(llvm::Function* callee, const Inst& in) {
        std::vector<llvm::Value*> args;
        for (unsigned i = 0; i < callee->arg_size(); ++i) {
            llvm::Type* want = callee->getArg(i)->getType();
            llvm::Value* a = i < in.operands.size() ? valueOf(in.operands[i]) : nullptr;
            args.push_back(coerce(a, want));
        }
        // THE VARIADIC TAIL. `printf(fmt, 42)` declares one parameter and takes two; cutting the
        // arguments at `arg_size()` silently dropped everything after the format string, so a
        // program printed its literal and none of its values.
        if (!callee->isVarArg()) {
            return args;
        }
        for (size_t i = callee->arg_size(); i < in.operands.size(); ++i) {
            llvm::Value* a = valueOf(in.operands[i]);
            if (a == nullptr) {
                continue;
            }
            // C promotes anything narrower than `int` and any `float` to `double`.
            // A BOOLEAN PROMOTES BY ZERO: `i1`'s single bit is its sign bit, so sign-extending
            // `true` gives -1, and every predicate handed to `printf` printed `-1` where the
            // program said `1`. `vec=1 ecb=1 ctr=1` came out `vec=-1 ecb=-1 ctr=-1`: five wrong
            // answers and no other symptom.
            if (a->getType()->isIntegerTy() && a->getType()->getIntegerBitWidth() < 32) {
                a = a->getType()->isIntegerTy(1)
                        ? b_.CreateZExt(a, llvm::Type::getInt32Ty(ctx_))
                        : b_.CreateSExt(a, llvm::Type::getInt32Ty(ctx_));
            } else if (a->getType()->isFloatTy()) {
                a = b_.CreateFPExt(a, llvm::Type::getDoubleTy(ctx_));
            }
            args.push_back(a);
        }
        return args;
    }

    llvm::Value* checkedArith(const Inst& in) {
        llvm::Value* l = nullptr;
        llvm::Value* r = nullptr;
        if (!intPair(in, &l, &r)) {
            return undefOf(in);
        }
        // SIGNED OR UNSIGNED IS A PROPERTY OF THE OPERATION, not of the type (§3.1) -- `uint` and
        // `int` intern identically, and the instruction says which. Always asking the signed
        // intrinsic meant `checked(a - b)` over unsigned wrapped instead of trapping.
        const bool uns = in.unsignedOp;
        llvm::Intrinsic::ID id =
            in.op == Op::AddChecked
                ? (uns ? llvm::Intrinsic::uadd_with_overflow : llvm::Intrinsic::sadd_with_overflow)
            : in.op == Op::SubChecked
                ? (uns ? llvm::Intrinsic::usub_with_overflow : llvm::Intrinsic::ssub_with_overflow)
                : (uns ? llvm::Intrinsic::umul_with_overflow
                       : llvm::Intrinsic::smul_with_overflow);
        llvm::Value* pair = b_.CreateIntrinsic(id, {l->getType()}, {l, r});
        ++r_.checkedArith;
        llvm::Value* value = b_.CreateExtractValue(pair, 0);
        // AND THE OVERFLOW BIT IS READ. It was being computed and discarded, so `checked(a + b)`
        // -- the one construct the language offers for trapping on overflow -- produced the
        // wrapped value and no trap at all. In a hosted program the trap is an exception a caller
        // can handle; freestanding has no machinery for that and panics instead (spec 36.3).
        if (in.text.empty() || in.aggregate == nullptr || freestanding()) {
            return value;
        }
        llvm::Value* overflowed = b_.CreateExtractValue(pair, 1, "arith.over");
        llvm::Function* fn = b_.GetInsertBlock()->getParent();
        auto* bad = llvm::BasicBlock::Create(ctx_, "arith.bad", fn);
        auto* cont = llvm::BasicBlock::Create(ctx_, "arith.ok", fn);
        b_.CreateCondBr(overflowed, bad, cont);
        b_.SetInsertPoint(bad);
        emitThrow(newException(in.text, in.aggregate),
                  in.edges.empty() ? nullptr : blockOf(in, 0));
        b_.SetInsertPoint(cont);
        tail_[emittingBlock_] = cont;
        return value;
    }

    // THE VALUE CLAMPED TO THE TYPE'S RANGE instead of wrapping. LLVM has `sadd.sat` and `ssub.sat`
    // outright; there is no `smul.sat`, so a multiplication is done in double the width and then
    // clamped, which is what the trusted path does and is exact for every input.
    llvm::Value* saturatingArith(const Inst& in) {
        llvm::Value* l = nullptr;
        llvm::Value* r = nullptr;
        if (!intPair(in, &l, &r)) {
            return undefOf(in);
        }
        if (in.op != Op::MulSaturate) {
            const llvm::Intrinsic::ID id = in.op == Op::AddSaturate ? llvm::Intrinsic::sadd_sat
                                                                    : llvm::Intrinsic::ssub_sat;
            return b_.CreateIntrinsic(id, {l->getType()}, {l, r});
        }
        const unsigned bits = l->getType()->getIntegerBitWidth();
        llvm::Type* wide = llvm::Type::getIntNTy(ctx_, bits * 2);
        llvm::Value* product = b_.CreateMul(b_.CreateSExt(l, wide), b_.CreateSExt(r, wide));
        llvm::APInt high = llvm::APInt::getSignedMaxValue(bits).sext(bits * 2);
        llvm::APInt low = llvm::APInt::getSignedMinValue(bits).sext(bits * 2);
        llvm::Value* top = llvm::ConstantInt::get(ctx_, high);
        llvm::Value* bottom = llvm::ConstantInt::get(ctx_, low);
        llvm::Value* clamped =
            b_.CreateSelect(b_.CreateICmpSGT(product, top), top,
                            b_.CreateSelect(b_.CreateICmpSLT(product, bottom), bottom, product));
        return b_.CreateTrunc(clamped, l->getType());
    }

    const Module& pir_;
    llvm::LLVMContext& ctx_;
    llvm::Module& mod_;
    llvm::IRBuilder<> b_;
    std::unordered_map<const Type*, llvm::Type*> types_;
    std::unordered_map<std::string, llvm::Function*> fns_;
    // Built once per module: the MSVC throw-info tables are constants and duplicating them would
    // duplicate the type descriptor, which the runtime compares by ADDRESS.
    llvm::Constant* throwInfo_ = nullptr;
    // Where each PIR block ENDS in LLVM, which is not where it begins once a guard has split it.
    std::unordered_map<BlockId, llvm::BasicBlock*> tail_;
    // The frame slot a landing block's funclet copied the caught object into. A value produced
    // inside a funclet cannot be used outside it, so the object leaves through memory.
    std::unordered_map<BlockId, llvm::Value*> caughtSlot_;
    BlockId emittingBlock_ = kNoBlock;
    // The vtable slot each loaded function pointer came out of, so the call that consumes one can
    // find the implementations that could be sitting in it. Cleared with the rest per function.
    std::unordered_map<ValueId, int64_t> fromSlot_;
    std::unordered_map<ValueId, llvm::Value*> vals_;
    std::unordered_map<BlockId, llvm::BasicBlock*> blocks_;
    ToLlvmResult r_;
    bool trace_ = false;
    // `-g`. Null unless the driver asked, and every debug method above checks that first, so a
    // build without `-g` costs one pointer test per function and nothing else.
    std::unique_ptr<llvm::DIBuilder> dib_;
    llvm::DICompileUnit* diCu_ = nullptr;
    llvm::DIType* diInt_ = nullptr;
    llvm::DISubprogram* diScope_ = nullptr;   // the function being emitted
    std::unordered_map<std::string, llvm::DIFile*> diFiles_;
};

}  // namespace

ToLlvmResult toLlvm(const Module& pir, llvm::LLVMContext& context, llvm::Module& into) {
    return Emitter(pir, context, into).run();
}

std::string renderHandoff(const ToLlvmResult& r) {
    // The §12 table, counted. "We emit noalias now" is a claim; a number beside it is evidence, and
    // the whole project's acceptance criterion is that these stop being zero.
    std::string out = "pir->llvm handoff:";
    out += " noalias=" + std::to_string(r.noalias);
    out += " nonnull=" + std::to_string(r.nonnull);
    out += " align=" + std::to_string(r.alignAttrs);
    out += " deref=" + std::to_string(r.dereferenceable);
    out += " nounwind=" + std::to_string(r.nounwind);
    out += " pure=" + std::to_string(r.pureAttrs);
    out += " cold=" + std::to_string(r.coldAttrs);
    out += " internal=" + std::to_string(r.internalLinkage);
    out += " checked=" + std::to_string(r.checkedArith);
    out += " assume=" + std::to_string(r.assumes);
    out += " tbaa=" + std::to_string(r.aliasTags);
    out += " devirt=" + std::to_string(r.speculated);
    out += "\n";
    return out;
}

}  // namespace polaron::pir
