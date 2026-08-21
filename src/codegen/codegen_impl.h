#pragma once

// The code generator's private implementation: `CodeGenerator::Impl` and the small types it is
// built out of.
//
// THIS IS A HEADER SO THE CLASS CAN BE SPLIT ACROSS TRANSLATION UNITS. `codegen.cpp` was 19 429
// lines and 19 315 of them were this one struct, which cannot be divided while its members are
// defined inline: a member definition has to be able to name its class, and only a declaration in a
// header lets a second file do that. So the struct moved here and its members moved out, into eight
// files that are now the code generator:
//
//   codegen.cpp          the public facade over this class, and the optimisation pipeline
//   codegen_types.cpp    `typeName`: what type is this expression, for codegen's purposes
//   codegen_expr.cpp     `emitExpr`, `emitBinary`, `emitNew`
//   codegen_call.cpp     `emitCall` -- 2 540 lines on its own, the largest member there was
//   codegen_stmt.cpp     `emitStatement`
//   codegen_layout.cpp   class layout, vtables, regions, the machinery underneath emission
//   codegen_emit.cpp     the rest of expression/statement emission
//   codegen_module.cpp   module-level declaration: classes, functions, statics, thunks
//   codegen_entry.cpp    entry points, generators, async state machines, the [Test] runner
//
// What is still defined INLINE below is what could not move: `static` members, the constructor, and
// anything with a default argument (which may be written once, in the declaration). Everything else
// is a declaration, and its definition is in one of the files above.
//
// Two things bite when moving a member out, both caught by the compiler rather than by review: a
// return type that is a NESTED type of the class needs qualifying (`CodeGenerator::Impl::SpillToken`,
// because the return type is written before the scope is entered), and a default argument must not be
// repeated on the definition.

#include "llvm/IR/MDBuilder.h"
#include "codegen/codegen.h"
#include "codegen/cgutil.h"   // the pure helpers this file used to carry at its top

#include <llvm/ADT/ScopeExit.h>
#include <llvm/BinaryFormat/Dwarf.h>
#include <llvm/IR/Attributes.h>   // Attribute::getWithCaptureInfo on LLVM 21+ (see markGuardHelper)
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DIBuilder.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InlineAsm.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/PassManager.h>
#include <llvm/TargetParser/Triple.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Passes/OptimizationLevel.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/IPO/GlobalDCE.h>
#include <llvm/Transforms/IPO/Internalize.h>
#include <llvm/Transforms/Utils/Cloning.h>

#include <algorithm>
#include <chrono>
#include <functional>
#include <cctype>
#include <cstddef>
#include <cstdint>
#include <filesystem>  // embed("path"): resolve the path relative to the source file
#include <fstream>     // embed("path"): read the bytes at compile time
#include <iterator>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "parser/ast.h"
#include "parser/monomorphize.h"  // cloneExprDeep, to reroute an unqualified self-call through the member path
#include "semantic/comptime.h"
#include "semantic/layouts.h"

namespace polaron {

// These four were in an ANONYMOUS namespace while this was one file. A header cannot keep them
// there: an anonymous namespace in a header gives every translation unit its own copy of each
// type and function, so `ClassLayout` in codegen.cpp and `ClassLayout` in codegen_regions.cpp
// would be different types with the same name -- an ODR violation the linker is free not to
// notice. Named, with the functions `inline`, they are one entity again.

// The module's target triple as a string. LLVM 21 changed Module::get/setTargetTriple to traffic in a
// llvm::Triple object instead of a std::string; older LLVM (the Windows build targets 17/18) uses strings.
// This keeps the call sites version-agnostic.
inline std::string moduleTripleStr(const llvm::Module& m) {
#if LLVM_VERSION_MAJOR >= 21
    return m.getTargetTriple().str();
#else
    return m.getTargetTriple();
#endif
}

// A pointer to a private, null-terminated constant string. LLVM 21 removed IRBuilder::CreateGlobalStringPtr
// and made CreateGlobalString return the pointer directly; older LLVM (17/18, the Windows build) keeps the
// *Ptr spelling (there CreateGlobalString returns a GlobalVariable*, not a usable pointer). Templated on the
// builder type so it works with any IRBuilder folder/inserter.
template <typename B>
llvm::Value* createGlobalStringPtr(B& b, llvm::StringRef s, const llvm::Twine& name = "") {
#if LLVM_VERSION_MAJOR >= 21
    return b.CreateGlobalString(s, name);
#else
    return b.CreateGlobalStringPtr(s, name);
#endif
}

// The pure helpers (type-name questions, AST walks, literal decoding) now live in cgutil.{h,cpp}:
// 543 lines that never mention llvm, and were being recompiled behind the whole backend. Pulled in
// unqualified so every call site below reads exactly as it did.
using namespace cgutil;   // NOLINT(google-build-using-namespace): a deliberate re-export of what was here


// Layout of a class: its LLVM struct, field indices/types, and method returns.
// Polymorphic classes (in a hierarchy) carry a vtable pointer at field 0.
struct ClassLayout {
    const ast::ClassDecl* decl = nullptr;  // source declaration (members in order)
    llvm::StructType* type = nullptr;
    std::unordered_map<std::string, unsigned> fieldIndex;  // includes inherited fields
    std::unordered_map<std::string, std::string> fieldType;  // Polaron type name per field
    std::unordered_map<std::string, int> bitFieldWidth;  // field -> bit-field width (spec 11.1)
    // Physical packing (spec 11.1). Consecutive bit-fields share ONE storage unit: `fieldIndex` gives
    // them all the same LLVM element, and these say where each one sits inside it. A packed field has
    // no address of its own, which is why `&s.f` on one is rejected rather than quietly handed the
    // unit's address.
    std::unordered_map<std::string, unsigned> bitFieldOffset;  // field -> bit offset within its unit
    std::unordered_map<std::string, unsigned> bitFieldUnitBits;  // field -> width of that unit in bits
    std::unordered_map<std::string, std::string> propertySetters;  // field -> setter method (spec 8.4)
    std::unordered_set<std::string> volatileFields;  // fields whose accesses are volatile (spec 37.5)
    std::unordered_set<std::string> externalFields;  // `external` fields: associations, not owned (spec 37.1)
    std::unordered_set<std::string> uniqueFields;  // `unique T*` fields: single-owner, so cascade-safe forest edges
    std::unordered_set<std::string> weakFields;  // `weak T*` fields: non-owning, laid out as a 3-ptr WeakSlot
                                                 // {ptr, prev, next}, intrusively linked into the pointee's
                                                 // weak-list and auto-nulled when the pointee is destroyed
    bool needsWeakHead = false;   // this class is targeted by some `weak T*` -> carries a weak-list head
    unsigned weakHeadIdx = 0;     // struct index of the appended weak-list head (a ptr), when needsWeakHead
    std::unordered_set<std::string> transientFields;  // `transient` fields: derived/scratch, reset (not copied) on a value copy
    // Lazy class-typed fields (spec 28.4): field name -> deferred initializer. Null in the
    // field means "not yet initialized" (the sentinel), so no extra flag is needed.
    std::unordered_map<std::string, const ast::Expr*> lazyFieldInit;
    std::unordered_map<std::string, std::string> methodReturnType;  // own methods only
    std::unordered_map<std::string, const ast::MethodDecl*> ownMethods;  // own methods, by name
    std::string superclass;
    std::vector<std::string> interfaces;
    std::vector<std::pair<std::string, std::string>> ownFields;  // (name, type), declaration order
    // spec 32.9: affinity of each own field ("hot"/"cold"; absent = neutral). Only the object's layout
    // is affected -- ownFields stays in declaration order, which is what positional patterns key on.
    std::map<std::string, std::string> fieldAffinity;
    bool isAbstract = false;
    bool isInterface = false;
    bool isUnion = false;  // fields overlap one storage (C-style union)
    bool isStruct = false;  // a value-type struct (spec 11): passed by value across FFI
    bool isMovable = false;
    bool isUnique = false;
    bool hasVtable = false;
    bool hasDestructor = false;
    bool imported = false;  // from a depended-on .polb: allocate/destroy via the bundle's exported
                            // Class.__new / Class.__delete (the layout here is the public API only)
    bool dynamic = false;   // imported via --use-dynamic: its functions are runtime-resolved thunks
    std::string bundleName; // owning bundle (for dynamic classes: which .polb to load)
    std::vector<std::string> vtslots;          // virtual method names, in slot order
    llvm::GlobalVariable* vtable = nullptr;     // emitted vtable global (concrete classes)
    // Persistent instance fields (spec 18): they live in a per-variable disk-backed block,
    // not in the object. The object carries a pointer to its block at persistPtrIdx.
    llvm::StructType* persistBlock = nullptr;
    unsigned persistPtrIdx = 0;                 // struct index of the __persist pointer (0 = none)
    std::vector<std::string> persistOrder;      // persistent field names, in block order
};

// A local variable / parameter: its storage (an alloca) and Polaron type name.
struct LocalSlot {
    llvm::Value* storage = nullptr;
    std::string type;
    bool isVolatile = false;  // spec 37.5: loads/stores of this local are volatile
    // Lazy locals (spec 37.3): the initializer runs on first access. `lazyFlag` is a
    // bool alloca (false until initialized); `lazyInit` is the deferred initializer.
    llvm::Value* lazyFlag = nullptr;
    const ast::Expr* lazyInit = nullptr;
};

// A stack object with a destructor, pending end-of-scope cleanup (RAII).
struct ScopeObject {
    llvm::Value* slot = nullptr;  // the variable's slot (holds a pointer to the struct)
    std::string className;
    std::string region;  // owning region variable name; "" for a plain stack object
};

struct CodeGenerator::Impl {
    const ast::Program& program;
    const EntryPoint& entry;
    bool libraryMode = false;  // compiling a bundle to a .polb: no entry point / `main` wrapper
    // How to read a line of the compiled source, for quoting a contract clause in its failure
    // message. Empty when the driver did not supply one.
    std::function<std::string(std::string_view, int)> sourceLookup;
    bool testMode = false;     // `polc --test`: the entry is a synthetic [Test] runner
    // One discovered [Test] method (spec 32.11), in declaration order.
    struct TestCase {
        std::string sym;      // "Class.method" -- the key into `functions`
        std::string display;  // what the runner prints, and what --filter matches against
        std::string cls;      // owning class, to find its lifecycle hooks
        bool isVoid = false;  // verdict comes from Test.assert* rather than a returned boolean
        bool ignored = false;         // [Ignore(...)]: reported as SKIP, never run
        std::string ignoreReason;
        std::string tags;             // [Tag(name:)] entries, comma-joined, for --tag/--exclude-tag
        // [Cases(source: "m")]: the test takes one parameter and runs once per element of the array
        // that `m` returns. Empty when the test takes no parameters.
        std::string casesSym;         // "Class.m"
        std::string paramType;        // the element type, for the load out of the array block
        int repeat = 1;               // [Repeat(times:)]: all runs must pass
        bool expectedToFail = false;  // [ExpectedToFail]: the verdict is inverted
        long long maxTimeNs = 0;      // [MaxTime(ms:)]: a pass that overran becomes a failure
    };
    std::vector<TestCase> testMethods;
    // [Benchmark] methods: timed loops rather than verdicts, run only under --bench.
    struct BenchCase {
        std::string sym;
        std::string display;
        long long iterations = 1000;
        long long warmup = 100;
    };
    std::vector<BenchCase> benchMethods;
    // Per-class lifecycle hooks. [Setup]/[Teardown] run around EACH test of the class; [BeforeAll]/
    // [AfterAll] run ONCE around the whole class, so an expensive fixture is built one time.
    struct TestHooks {
        std::string beforeAll, afterAll, setup, teardown;
    };
    std::map<std::string, TestHooks> testHooks_;
    std::vector<CodegenError>& errors;
    llvm::LLVMContext context;
    llvm::Module module;
    llvm::IRBuilder<> builder;

    // --- debug info (-g): DWARF metadata so the compiled program is debuggable by @@LOW@@UPPLINGB@@@@ / the Forge
    // debugger. dib is null unless -g is set. diCU is the compile unit; diFiles caches a DIFile per source
    // path; diCurrentSP is the DISubprogram of the function being emitted (the scope for line locations).
    bool debugInfo = false;
    // --verify-stack. See codegen.h for the fault that made this necessary. `entrySp` is the stack
    // pointer this method was entered on, read once after its prologue and compared against a fresh
    // read before each return; null when the flag is off or the method is `naked` (which owns its whole
    // frame, so there is no compiler-established value to compare against).
    bool verifyStack = false;
    llvm::Value* entrySp = nullptr;
    std::unique_ptr<llvm::DIBuilder> dib;
    llvm::DICompileUnit* diCU = nullptr;
    std::unordered_map<std::string, llvm::DIFile*> diFiles;
    llvm::DISubprogram* diCurrentSP = nullptr;
    llvm::DIType* diIntTy = nullptr;   // a cached generic type for a minimal DISubroutineType

    // The DIFile for a source path (cached). Splits into directory + filename as DWARF expects.
    llvm::DIFile* diFileFor(std::string_view path);

    // Set up the DIBuilder, compile unit and module flags. Called once at the start of generate() when -g
    // is on, before any function is emitted.
    void initDebugInfo();
    void finalizeDebugInfo();
    // A minimal DISubroutineType (return + no typed params). Enough for line-level breakpoints and stepping;
    // richer parameter types come with variable inspection.
    llvm::DISubroutineType* diMinimalFnType(llvm::DIFile* file);
    // Create and attach a DISubprogram for `fn`, using `loc` for its file/line, and make it the current
    // debug scope. Returns the subprogram (or null when -g is off).
    llvm::DISubprogram* beginDebugFunction(llvm::Function* fn, SourceLocation loc);
    // The statement being emitted, for naming the place in a runtime guard's message.
    SourceLocation hereLoc;

    // Set the current debug location to (loc.line, loc.col) within the current function's scope. A no-op
    // when -g is off or there is no active subprogram.
    void setDebugLoc(SourceLocation loc);

    // --- Local/parameter variable debug info (llvm.dbg.declare) ---
    std::unordered_map<std::string, llvm::DIType*> diTypeCache;
    llvm::DIType* diPtrTy_ = nullptr;
    llvm::DIType* diCachedBasic(const std::string& name, unsigned bits, unsigned enc);
    llvm::DIType* diPtrTy();
    // The DIType for a variable. The bit-width/encoding follow the *actual* LLVM storage type so the
    // debugger reads the right number of bytes; the Polaron type name (int, char, MyClass...) supplies a
    // readable label. Pointers/objects/arrays show as an address.
    llvm::DIType* diTypeFor(const std::string& tyName, llvm::Type* storage);
    // Attach a DILocalVariable + llvm.dbg.declare to a stack slot so the debugger can name and read it.
    // argNo > 0 marks a function parameter (1-based); 0 is an ordinary local. No-op unless -g is on and the
    // slot is a plain alloca in the current function.
    void declareLocalDebug(llvm::Value* slot, const std::string& name, const std::string& tyName,
                           SourceLocation loc, unsigned argNo = 0) {
        if (!debugInfo || diCurrentSP == nullptr || dib == nullptr || name.empty()) {
            return;
        }
        auto* alloca = llvm::dyn_cast<llvm::AllocaInst>(slot);
        if (alloca == nullptr) {
            return;  // dbg.declare needs a stack address
        }
        llvm::DIFile* file = diCurrentSP->getFile();
        unsigned line = loc.line > 0 ? static_cast<unsigned>(loc.line) : diCurrentSP->getLine();
        llvm::DIType* dt = diTypeFor(tyName, alloca->getAllocatedType());
        llvm::DILocalVariable* v =
            argNo > 0
                ? dib->createParameterVariable(diCurrentSP, name, argNo, file, line, dt, true)
                : dib->createAutoVariable(diCurrentSP, name, file, line, dt, true);
        llvm::DILocation* dl = llvm::DILocation::get(
            context, line, loc.col > 0 ? static_cast<unsigned>(loc.col) : 1, diCurrentSP);
        dib->insertDeclare(alloca, v, dib->createExpression(), dl, builder.GetInsertBlock());
    }

    std::unordered_map<std::string, ClassLayout> classes;
    // WHERE EACH CLASS LIVES. Codegen walked bundles and namespaces and kept neither, so it had no way
    // to tell two same-named types apart -- which is the reason the renaming pass has to make them
    // different upstream, and the reason every gap in that rewrite surfaced here as a failure about a
    // class the author never wrote (`Color.__unimportedCall`, a memcpy handed an i32).
    //
    // Recorded at registration, from the loop that was already walking them. It is a fact about the
    // class, not about where the emitter happens to be, so it does not need threading through.
    std::unordered_map<std::string, std::string> classNamespace;
    std::unordered_map<std::string, std::string> classBundle;
    // The full path of a class, for the day two of them share a name here as they already can in the
    // analyzer: `Bundle.Namespace.Name`, the same spelling the type table uses.
    std::string classPath(const std::string& name) const {
        auto b = classBundle.find(name);
        auto n = classNamespace.find(name);
        if (b == classBundle.end() || n == classNamespace.end()) {
            return name;
        }
        return b->second + "." + n->second + "." + name;
    }

    // WHICH `Scanner` THIS CODE MEANS -- codegen's half of the same question the analyzer answers.
    //
    // The analyzer resolved it correctly and codegen did not, because codegen looked the bare name up
    // in one map and took whatever was there. That surfaced as `no such field 'src'` inside the
    // standard library's own Scanner constructor, on a program whose author had merely declared a
    // class of the same name.
    //
    // The key a shared name is stored under: the first declaration keeps the bare name, the rest go
    // under their path. Resolution walks the same order the analyzer uses -- the namespace being
    // emitted, then the bundle, then whatever is left.
    std::unordered_set<std::string> sharedClassNames;
    std::string currentNamespace;   // set by every loop that walks namespaces
    std::string currentBundleName;
    // The KEY of the class whose members are being emitted, announced by the walk that knows it --
    // `Bundle.Namespace.Name` for the one that did not get the bare key. Empty when a body is reached
    // from a worklist instead, which is how emitBody tells the two apart.
    std::string emittingClassKey;

    // ONE RULE, NO CASES. A shared name is stored by path for every type that answers to it, so
    // resolving is composing the path of whoever is asking -- there is no "unless it was declared
    // first" branch for a later pass to get wrong.
    std::string resolveClassKey(const std::string& name) const {
        if (sharedClassNames.empty() || sharedClassNames.count(name) == 0) {
            return name;   // the ordinary case: one type, one key, no work at all
        }
        const std::string here = currentBundleName + "." + currentNamespace + "." + name;
        if (classes.count(here) > 0) {
            return here;
        }
        // AN IMPORT NAMING THE PATH SETTLES IT -- the same order the analyzer resolves in, and it has
        // to be the same or a program type-checks against one class and calls another.
        if (auto b = bundleImportKey.find(currentBundleName); b != bundleImportKey.end()) {
            if (auto i = b->second.find(name); i != b->second.end() && classes.count(i->second) > 0) {
                return i->second;
            }
        }
        // Not ours: the FIRST DECLARED one, recorded during the scan.
        //
        // Deterministic on purpose. The first version searched `classNamespace` for any key ending in
        // this name -- and that is an unordered_map, so with two candidates the answer depended on the
        // hash order and CHANGED BETWEEN RUNS. It compiled, then segfaulted, then compiled, on the
        // same input. A fallback that has to pick must pick the same thing every time, or the bug it
        // creates is one nobody can reproduce.
        auto first = firstOwnerKey.find(name);
        if (first != firstOwnerKey.end() && classes.count(first->second) > 0) {
            return first->second;
        }
        return name;
    }
    // A CONSTRUCTOR'S AND DESTRUCTOR'S SYMBOL, FROM A CLASS KEY.
    //
    // The convention is `<key>.<simple name>`: `Scanner.Scanner` for an ordinary class, and
    // `Own.World.Scanner.Scanner` for one whose name is shared. Composing it by hand as `k + "." + k`
    // -- which was right while every key WAS the simple name -- produces
    // `Own.World.Scanner.Own.World.Scanner` for a shared name, so the constructor is never found and
    // the object is malloc'd and left uninitialised, with no diagnostic anywhere.
    std::string simpleOf(const std::string& key) const {
        const auto p = key.rfind('.');
        return p == std::string::npos ? key : key.substr(p + 1);
    }
    std::string ctorSym(const std::string& key) const { return key + "." + simpleOf(key); }
    std::string dtorSym(const std::string& key) const { return key + ".~" + simpleOf(key); }
    // THE FUNCTION A BODY IS ABOUT TO BE WRITTEN INTO, or a sentence saying which one is missing.
    //
    // `functions[sym]` on an absent key inserts a null and hands it back, and the emitter walks
    // straight into it: the compiler dies with an access violation and no output at all, which says
    // nothing about which symbol was not declared. Every such crash so far has been a declaration
    // pass and an emission pass naming the same method differently -- exactly the kind of mismatch a
    // name in the message identifies in one reading.
    llvm::Function* needFn(const std::string& sym) {
        auto it = functions.find(sym);
        if (it == functions.end() || it->second == nullptr) {
            error("internal: no function was declared for '" + sym +
                      "' -- the declaration and emission passes disagree about its name",
                  {});
            return nullptr;
        }
        return it->second;
    }
    // The key of the first-declared type for each shared name -- the deterministic fallback above.
    std::unordered_map<std::string, std::string> firstOwnerKey;
    // Per bundle, what each imported simple name resolves to: "Own" -> { "Paths" -> "Own.World.Paths" }.
    // Filled in the pre-scan; read by resolveClassKey so an import decides here as it does in sema.
    std::unordered_map<std::string, std::unordered_map<std::string, std::string>> bundleImportKey;
    // WHICH CLASS MENTIONS WHICH, from the analyzer (see SemanticAnalyzer::noteClassRef), and the
    // closure computed from it: the classes whose bodies this program can actually reach.
    std::map<std::string, std::set<std::string>> classRefs_;
    std::set<std::string> demandOwners_;   // never pruned: a `demand` is settled at build time
    std::set<std::string> reachableClasses_;
    bool reachabilityOn_ = false;   // false = emit everything, as before
    void computeReachableClasses();
    // `newtype Name = Underlying;` (spec 24): a distinct type that shares the underlying's
    // representation, so codegen lowers it exactly like the underlying type.
    std::unordered_map<std::string, std::string> newtypes_;
    std::unordered_map<std::string, llvm::StructType*> tupleTypes;  // "(int,int)" -> { i32, i32 }
    // `weak T*` support: classes targeted by some weak pointer (so they carry a weak-list head), and the
    // shared 2-pointer WeakSlot layout {ptr, next} that a weak field occupies (intrusive singly-linked,
    // no alloc -- the node lives in the field itself; unlink is an O(n) scan, link/nullify are O(1)/O(list)).
    std::unordered_set<std::string> weaklyReferenced_;
    llvm::StructType* weakSlotTy_ = nullptr;
    llvm::StructType* weakSlotType() {  // {ptr -> pointee, next -> next slot in the pointee's weak-list}
        if (weakSlotTy_ == nullptr) {
            weakSlotTy_ = llvm::StructType::create(
                context, {builder.getPtrTy(), builder.getPtrTy()}, "WeakSlot");
        }
        return weakSlotTy_;
    }
    // True if `fname` is a `weak` field of `cls` or any ancestor.
    bool fieldIsWeak(const std::string& cls, const std::string& fname);
    // ---- `weak T*` runtime: intrusive singly-linked list of WeakSlots hung off each pointee's weak-list
    // head. Emitted once as internal IR functions; the codegen just calls them. slot = a WeakSlot* {ptr,
    // next}; headOff = the byte offset of the pointee's weak-list head field. ----
    llvm::Function* weakLinkFn() {  // link slot into (target + headOff)'s list, recording slot.ptr = target
        if (auto* f = module.getFunction("__polaron_weak_link")) {
            return f;
        }
        llvm::Type* p = builder.getPtrTy();
        auto* f = llvm::Function::Create(
            llvm::FunctionType::get(builder.getVoidTy(), {p, p, builder.getInt64Ty()}, false),
            llvm::Function::InternalLinkage, "__polaron_weak_link", module);
        auto ip = builder.saveIP();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
        auto a = f->arg_begin();
        llvm::Value* slot = &*a++; llvm::Value* target = &*a++; llvm::Value* off = &*a++;
        builder.CreateStore(target, builder.CreateStructGEP(weakSlotType(), slot, 0));   // slot.ptr = target
        llvm::Value* head = builder.CreateGEP(builder.getInt8Ty(), target, off);         // &target.weakHead
        builder.CreateStore(builder.CreateLoad(p, head),
                            builder.CreateStructGEP(weakSlotType(), slot, 1));           // slot.next = *head
        builder.CreateStore(slot, head);                                                // *head = slot
        builder.CreateRetVoid();
        builder.restoreIP(ip);
        return f;
    }
    llvm::Function* weakNullifyFn() {  // walk (*headAddr) list, null each slot's ptr+next; then *headAddr=null
        if (auto* f = module.getFunction("__polaron_weak_nullify")) {
            return f;
        }
        llvm::Type* p = builder.getPtrTy();
        llvm::Value* nul = llvm::ConstantPointerNull::get(builder.getPtrTy());
        auto* f = llvm::Function::Create(llvm::FunctionType::get(builder.getVoidTy(), {p}, false),
                                         llvm::Function::InternalLinkage, "__polaron_weak_nullify", module);
        auto ip = builder.saveIP();
        llvm::Value* headAddr = &*f->arg_begin();
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* loop = llvm::BasicBlock::Create(context, "loop", f);
        auto* body = llvm::BasicBlock::Create(context, "body", f);
        auto* done = llvm::BasicBlock::Create(context, "done", f);
        builder.SetInsertPoint(entry);
        llvm::Value* first = builder.CreateLoad(p, headAddr);
        builder.CreateBr(loop);
        builder.SetInsertPoint(loop);
        auto* n = builder.CreatePHI(p, 2);
        n->addIncoming(first, entry);
        builder.CreateCondBr(builder.CreateICmpEQ(n, nul), done, body);
        builder.SetInsertPoint(body);
        llvm::Value* next = builder.CreateLoad(p, builder.CreateStructGEP(weakSlotType(), n, 1));
        builder.CreateStore(nul, builder.CreateStructGEP(weakSlotType(), n, 0));
        builder.CreateStore(nul, builder.CreateStructGEP(weakSlotType(), n, 1));
        n->addIncoming(next, body);
        builder.CreateBr(loop);
        builder.SetInsertPoint(done);
        builder.CreateStore(nul, headAddr);
        builder.CreateRetVoid();
        builder.restoreIP(ip);
        return f;
    }
    llvm::Function* weakUnlinkFn() {  // remove slot from (slot.ptr + headOff)'s list; clear slot
        if (auto* f = module.getFunction("__polaron_weak_unlink")) {
            return f;
        }
        llvm::Type* p = builder.getPtrTy();
        llvm::Value* nul = llvm::ConstantPointerNull::get(builder.getPtrTy());
        auto* f = llvm::Function::Create(
            llvm::FunctionType::get(builder.getVoidTy(), {p, builder.getInt64Ty()}, false),
            llvm::Function::InternalLinkage, "__polaron_weak_unlink", module);
        auto ip = builder.saveIP();
        auto a = f->arg_begin();
        llvm::Value* slot = &*a++; llvm::Value* off = &*a++;
        auto* entry = llvm::BasicBlock::Create(context, "entry", f);
        auto* has = llvm::BasicBlock::Create(context, "has", f);
        auto* first_is = llvm::BasicBlock::Create(context, "first", f);
        auto* scan = llvm::BasicBlock::Create(context, "scan", f);
        auto* found = llvm::BasicBlock::Create(context, "found", f);
        auto* advance = llvm::BasicBlock::Create(context, "advance", f);
        auto* clear = llvm::BasicBlock::Create(context, "clear", f);
        auto* done = llvm::BasicBlock::Create(context, "done", f);
        builder.SetInsertPoint(entry);
        llvm::Value* slotNext = builder.CreateLoad(p, builder.CreateStructGEP(weakSlotType(), slot, 1));
        llvm::Value* target = builder.CreateLoad(p, builder.CreateStructGEP(weakSlotType(), slot, 0));
        builder.CreateCondBr(builder.CreateICmpEQ(target, nul), clear, has);
        builder.SetInsertPoint(has);
        llvm::Value* head = builder.CreateGEP(builder.getInt8Ty(), target, off);
        llvm::Value* firstV = builder.CreateLoad(p, head);
        builder.CreateCondBr(builder.CreateICmpEQ(firstV, slot), first_is, scan);
        builder.SetInsertPoint(first_is);
        builder.CreateStore(slotNext, head);                       // *head = slot.next
        builder.CreateBr(clear);
        builder.SetInsertPoint(scan);
        auto* n = builder.CreatePHI(p, 2);
        n->addIncoming(firstV, has);
        llvm::Value* nNext = builder.CreateLoad(p, builder.CreateStructGEP(weakSlotType(), n, 1));
        builder.CreateCondBr(builder.CreateICmpEQ(nNext, nul), clear, advance);   // not found -> defensive
        builder.SetInsertPoint(advance);
        builder.CreateCondBr(builder.CreateICmpEQ(nNext, slot), found, scan);
        n->addIncoming(nNext, advance);
        builder.SetInsertPoint(found);
        builder.CreateStore(slotNext, builder.CreateStructGEP(weakSlotType(), n, 1));  // n.next = slot.next
        builder.CreateBr(clear);
        builder.SetInsertPoint(clear);
        builder.CreateStore(nul, builder.CreateStructGEP(weakSlotType(), slot, 0));
        builder.CreateStore(nul, builder.CreateStructGEP(weakSlotType(), slot, 1));
        builder.CreateBr(done);
        builder.SetInsertPoint(done);
        builder.CreateRetVoid();
        builder.restoreIP(ip);
        return f;
    }
    // The byte offset of `cls`'s weak-list head field, for the runtime helpers.
    llvm::Value* weakHeadOffset(const std::string& cls);
    // Zero the intrusive weak state of a freshly allocated `cn` instance BEFORE its constructor runs: each
    // `weak T*` field's WeakSlot ({ptr,next} = null, so the first assignment's unlink is a no-op and an
    // unassigned weak field reads null), and the weak-list head (empty list) if `cn` is itself a weak
    // target. Objects are malloc'd, not zeroed, so without this the very first weak op walks garbage.
    void initWeakState(llvm::Value* objPtr, const std::string& cn);
    // True if `cn` has any `weak T*` field (own or inherited) -- gates the init/cleanup fast path.
    bool anyWeakField(const std::string& cn);
    // True if `cn`'s death must run emitWeakCleanup: it holds a weak field (its slot must unlink from the
    // target's list) or is itself a weak target (its weak-list must be nulled). Zero cost for other classes
    // -- the death paths skip emitWeakCleanup entirely, so `weak T*` adds nothing to non-weak teardown.
    bool weakRelevant(const std::string& cn);
    // At object death (after the destructor, before the block is freed): if `cn` is a weak target, null
    // every weak pointer aimed at it (auto-deregistration -- this is exactly what lets `weak T*` observe
    // liveness at zero per-access cost); and for each of `cn`'s `weak T*` fields, unlink its slot from the
    // (still-live) target's list, so a later target death never writes through this about-to-be-freed slot.
    void emitWeakCleanup(llvm::Value* objPtr, const std::string& cn);
    // The single function to register with a region's destructor registry for an object of class `cn`.
    //
    // Usually that is just the destructor. A class with weak state needs more: when it dies its weak
    // pointers must be nulled and its own weak slots unlinked, and the registry holds ONE function
    // pointer -- so the two are wrapped into a thunk, built once per class. Without this, a weak
    // reference into a region would still be pointing at the arena after the arena was released.
    llvm::Function* regionDtorFn(const std::string& cn);

    // Global per-method-name vtable slots. Every distinct virtual method name gets
    // one stable index, and every polymorphic class's vtable is laid out by these
    // indices. Because Polaron has no method overloading (unique name per method), a
    // call through a class OR any interface resolves to the same global slot, so a
    // class implementing several interfaces dispatches each one correctly.
    std::unordered_map<std::string, int> methodSlots;  // virtual method name -> global slot
    std::vector<std::string> methodSlotNames;          // global slot -> method name
    // spec 32.8: classes whose dispatch table is patched at runtime (from the analyzer). They always get
    // a vtable, are never devirtualized, and their vtable global is writable.
    std::set<std::string> patchedClasses_;
    // [unknown-abi] Mangled names of methods declared `unknown <world>`: entry points a foreign world
    // calls into, so they keep external linkage through internalization/DCE (see stripDeadCode).
    std::set<std::string> foreignEntryPoints_;
    int patchCounter_ = 0;
    std::vector<std::string> seededSlots;              // slot layout adopted from imported bundles
    std::unordered_set<std::string> subclassed_;       // classes/interfaces that something extends or
                                                       // implements; a type NOT here has no subtype, so
                                                       // a call on it devirtualizes to a direct call
    // Dynamic bundles (--use-dynamic), keyed by AST bundle name: the .polb path and the ABI
    // fingerprint the program compiled against. Their functions become runtime-resolving thunks.
    std::unordered_map<std::string, std::pair<std::string, std::array<std::uint8_t, 32>>> dynamicBundles;
    std::unordered_map<std::string, llvm::GlobalVariable*> dynBundleHandle;  // per-bundle cached handle
    std::unordered_set<std::string> preludeClasses;  // classes from the embedded prelude, by short name
    // ...and by KEY, which is what a symbol carries: `ArrayList` for most, `System.Net.Tls.ByteWriter`
    // for one whose short name is shared. Weakening a .polb's prelude copies needs the key.
    std::unordered_set<std::string> preludeClassKeys;
    std::unordered_map<std::string, std::vector<std::string>> enums;  // name -> constants (ordinals)
    std::unordered_map<std::string, const ast::EnumDecl*> javaEnums;  // java-style enum decls
    // Catalog-implementing enums kept as enums (int-style ordinals) but carrying
    // method impls: name -> decl. Methods lower as `Enum.method(i32 this, ...)`.
    std::unordered_map<std::string, const ast::EnumDecl*> enumMethodDecls;
    std::unordered_set<std::string> catalogNames;  // declared `catalog` type names (spec 12.4)
    // Stable per-enum type id for the runtime tag on a catalog value (spec 12.4 multi-implementer
    // dispatch): a catalog value is packed as (enumTypeId << 32 | ordinal) so dispatch can pick the
    // implementing enum. Assigned in declaration order in declareClasses pass 0.
    std::unordered_map<std::string, int> enumTypeId;
    std::unordered_map<std::string, llvm::Function*> functions;  // mangled -> fn
    // The type names a function's parameters were DECLARED with, in the same index space as its
    // LLVM arguments (an implicit `this` holds an empty slot). An LLVM type does not always say
    // what the language meant: a tagged catalog lowers to i64, exactly like `long`, so an argument
    // widened to the LLVM shape alone reaches it UNTAGGED and dispatches as whichever enum owns
    // tag 0 -- a wrong answer with nothing anywhere to report it.
    std::unordered_map<const llvm::Function*, std::vector<std::string>> paramTypeNames;
    std::unordered_map<std::string, llvm::GlobalVariable*> staticGlobals;  // "Class.field" -> global
    std::unordered_map<std::string, std::string> staticFieldType;  // "Class.field" -> Polaron type
    // class -> its persistent instance field names (spec 18: object reattach via per-variable globals)
    std::unordered_map<std::string, std::unordered_set<std::string>> persistentInstanceFields;
    // set by a var-decl just before emitNew so the new object can wire up its persistent block
    std::string pendingPersistKey;
    // set for `arr[i] = new T()` (spec 18.5): the runtime index that, with pendingPersistKey (the array
    // identity), keys the object's persistent block so it reattaches by slot across a delete
    llvm::Value* pendingPersistIndex = nullptr;
    int lambdaCounter = 0;  // unique names for lowered lambda functions
    // The lambda whose body is being emitted right now, so `itself(...)` inside it resolves to a direct
    // call. Saved and restored around each body, because a lambda can be written inside a lambda.
    llvm::Function* currentLambdaFn_ = nullptr;
    bool currentLambdaHasEnv_ = false;  // closures take an environment as arg 0; C callbacks do not
    std::unordered_map<std::string, std::string> literalReturnType;  // mangled suffix (name$param) -> return type
    std::unordered_map<std::string, std::vector<std::string>> literalSuffixParams;  // suffix name -> param types
    std::unordered_map<std::string, std::string> externReturnType;   // extern C fn -> return type
    // Methods that return a value struct by value use an sret parameter: the caller passes the result
    // slot as the trailing argument and the callee constructs into it (no dangling/leaking copy).
    std::unordered_set<llvm::Function*> sretFns_;
    std::unordered_map<llvm::Function*, llvm::Type*> sretStructType_;  // fn -> its result struct type
    llvm::Value* currentSretSlot_ = nullptr;  // the active function's sret slot (null if not sret)
    // Namespace-level compile-time constants (spec 28.1), folded once up front.
    std::unordered_map<std::string, std::string> namespaceConstTypes;  // const name -> Polaron type
    std::unordered_map<std::string, long long> constIntVals;           // int/bool/char value
    std::unordered_map<std::string, double> constDblVals;              // float/double value
    std::unordered_map<std::string, const ast::MethodDecl*> comptimeMethods;  // spec 28.3, by name
    std::unordered_map<std::string, LocalSlot> locals;
    std::vector<ScopeObject> scopeObjects;  // stack objects awaiting destructor calls
    // Every local slot holding a `new ... on stack` object. Separate from scopeObjects because that one
    // answers "what must be destructed" and this one answers "is this address on the stack" -- and only
    // the second question keeps `delete` from handing a frame address to free().
    std::set<llvm::Value*> stackObjectSlots_;
    // Region locals (spec 17.7): freed at the end of their lexical block unless
    // `eternal` or already released. Mirrors scopeObjects.
    struct RegionLocal { llvm::Value* slot; bool isEternal; std::string name; };
    std::vector<RegionLocal> scopeRegions;
    // A pending scope-exit action, run in LIFO order at every exit (structured and unwind). Either a
    // `defer` block, or a `using` resource's disposal (destructor if any, then free if heap). Unifying
    // them lets both fire on the exception-unwind path, not only on structured exits (spec 23.1).
    struct Cleanup {
        const ast::Block* block = nullptr;  // a defer block (null => a using disposal)
        llvm::Value* slot = nullptr;        // using: the resource's storage slot
        std::string className;              // using: its class (for the destructor)
        bool heap = false;                  // using: free it (a heap resource)
        bool consumed = false;              // using: an explicit `delete r` already disposed it
        llvm::Value* lockRelease = nullptr; // synchronized: release this Mutex lock (block-scoped)
        // A `foreach` iterator the loop itself minted (spec 9.2 / 22.6): dispose it through its vtable,
        // since its static type is usually the Iterator<T> interface and the concrete class (a
        // generator's, say) is the one whose destructor releases the sequence's state.
        bool virtualDelete = false;
        // spec 32.10: `defer within <duration>` -- an i64 millisecond budget for this defer block. Null
        // for a plain defer. Exceeding it reports an overrun (an alert, not a thrown exception, so a
        // soft-real-time cleanup still completes).
        llvm::Value* budgetMs = nullptr;
    };
    std::vector<Cleanup> deferred;  // defer blocks + using disposals, run at scope end (LIFO)
    // Locals returned from the current body: a class value copied into such a local escapes the frame,
    // so its deep copy must live on the heap, not a stack alloca that dangles once the function returns.
    std::set<std::string> escapingLocals_;
    // Scope-based RAII for String. String is a builtin ptr -> {i64 len, ptr data, i64 hash}, both blocks
    // __polaron_malloc'd, previously never freed. Scheme: every STORE of a String deep-copies it, so nothing
    // live is aliased; then every OWNED temporary (a fresh malloc from concat/substring/interp/toString/...)
    // is freed at its statement boundary and String LOCALS at scope exit, and a returned String is copied
    // out. stringTemps: owned temporaries + creating block (only ones in the current block are freed at the
    // boundary; a conditional-arm temp is dropped). scopeStrings: String local SLOTS, freed at scope exit.
    std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> stringTemps;
    std::vector<llvm::Value*> scopeStrings;
    // A value struct heap-promoted into the async/generator coroutine state object (its stack home is
    // gone once an await suspends) is owned by the coroutine but has no destructor, so nothing else frees
    // it. Track each such local's slot + type; free its owned fields and block at scope/coroutine exit,
    // mirroring scopeStrings. Only the async/gen var-decl path populates this (a sync value struct lives
    // on the frame stack -- no heap block to free).
    std::vector<std::pair<llvm::Value*, std::string>> scopeValueStructs;
    bool checkedArith_ = false;
    // spec 36.4: `[[no_bounds_check]]` on a method -- its array indexing drops the runtime bounds check.
    // An EXPLICIT, named opt-out for a hot path: Polaron has no implicit UB, but it does hand you the cannon.
    bool noBoundsCheck_ = false;      // inside checked(...): signed +/-/* trap on overflow (spec 3.6)
    // Function specialization over no-capture lambda arguments (perf). When a method that takes a
    // function<> parameter is called with a known constant lambda, a specialized copy of the method is
    // emitted whose calls to that parameter are DIRECT (so LLVM inlines the lambda instead of an indirect
    // call). This is monomorphization-over-lambdas -- what C++ templates / Rust generics do for a
    // comparator. `boundLambdas_` maps a bound parameter name to its lambda function during a specialized
    // body's codegen; the worklist defers body generation to after the main pass (no re-entrant codegen);
    // the cache de-duplicates and terminates the recursive/transitive case.
    struct Specialization {
        llvm::Function* fn;
        const ast::MethodDecl* decl;
        std::string owner;                              // "" for a static method
        std::string returnType;
        std::unordered_map<std::string, llvm::Function*> bound;
    };
    std::unordered_map<std::string, llvm::Function*> boundLambdas_;
    std::unordered_map<std::string, llvm::Function*> specCache_;
    std::vector<Specialization> specWorklist_;
    std::string currentClass;        // "" inside a static method / the entry point
    std::string currentDtorChain;    // base destructor to chain to (set only in a destructor body)
    llvm::Value* currentThis = nullptr;
    llvm::Function* currentFn = nullptr;
    llvm::Type* currentRetType = nullptr;
    std::string currentRetTypeName_;  // the current function's DECLARED return type name (String RAII:
                                      // a `returns String` method copy-on-returns even a literal/`string`)
    // While re-emitting a `?.` node as a plain access inside its non-null branch, this points at
    // that node so its safe-navigation guard is skipped exactly once (nested ?. still guard).
    const ast::Expr* safeGuardNode_ = nullptr;
    // When emitting an async method's resume function, this is the polaron_task* (the function's
    // state arg); `return X` completes that task instead of returning X (spec 20.2).
    llvm::Value* currentAsyncState = nullptr;
    // Async state-machine lowering (spec 20.2): while emitting an async body whose code may
    // suspend, `await` lowers to a suspend/resume split anywhere it appears (incl. inside loops).
    bool asyncSM = false;
    llvm::StructType* asyncSMState = nullptr;  // the heap state struct type
    llvm::Value* asyncSMStatePtr = nullptr;    // the resume function's `st` argument
    llvm::Function* asyncSMResume = nullptr;   // the resume function (continuation)
    unsigned asyncSMAwaitBase = 0;             // field index of the first await-handle slot
    int asyncSMAwaitIdx = 0;                   // next await's index / state number
    llvm::BasicBlock* asyncSMSuspend = nullptr;
    std::vector<std::pair<int, llvm::BasicBlock*>> asyncSMCases;  // (state index -> resume block)
    // Scratch slots in the state object for spilling expression temporaries across an await: a
    // value computed before a suspend would otherwise not dominate its use in the resume block.
    unsigned asyncSMScratchBase = 0;           // field index of the first scratch slot
    int asyncSpillTop_ = 0;                     // next free scratch slot (used LIFO)
    static constexpr int kAsyncScratchSlots = 64;
    struct SpillToken { bool active = false; unsigned slot = 0; llvm::Type* ty = nullptr; };
    // Generator state-machine lowering (spec 22.6), the same shape as the async one: while emitting a
    // generator's parked body, every local lives in the heap state object and each `yield` splits its
    // block into a return-to-caller / resume-here pair.
    bool genSM = false;
    llvm::StructType* genSMState = nullptr;  // {i32 state, T current, self?, params..., locals...}
    llvm::Value* genSMStatePtr = nullptr;    // the resume function's `st` argument
    std::string genSMElem;                   // the element type T
    int genSMIdx = 0;                        // next yield's index / state number (1-based; 0 = start)
    std::vector<std::pair<int, llvm::BasicBlock*>> genSMCases;  // (state index -> resume block)
    // Inside an `expecting { ... }` block (spec 30.18): a `return` stores into this slot and branches
    // to expectingEnd_ (the block is an expression, not a method return).
    llvm::Value* expectingSlot_ = nullptr;
    llvm::BasicBlock* expectingEnd_ = nullptr;
    // Inside a match-expression block arm (spec 16.2): `yield expr;` stores into this slot and
    // branches to yieldEnd_ (the arm's continuation).
    llvm::Value* yieldSlot_ = nullptr;
    llvm::BasicBlock* yieldEnd_ = nullptr;
    std::string yieldType_;
    const std::vector<ast::ExprPtr>* currentEnsures = nullptr;  // contracts: postconditions
    // contracts: `result` inside an ensures clause -- the value the return being emitted hands back.
    // Non-null only while the postconditions of a value-returning `return` are being emitted.
    llvm::Value* currentResultValue_ = nullptr;
    const std::vector<const ast::Expr*>* currentInvariants = nullptr;  // contracts: the ones to CHECK at exit
    // The ones to ASSUME at entry: ALL of the class's invariants, not the narrowed check set. See the
    // comment where this is assigned for why the two must not be the same list.
    const std::vector<const ast::Expr*>* currentInvariantsToAssume = nullptr;
    // contracts: each old(e) in an ensures clause -> an entry-captured slot (spec 29).
    std::unordered_map<const ast::OldExpr*, llvm::Value*> oldValues_;
    struct LoopTargets {
        llvm::BasicBlock* brk;
        llvm::BasicBlock* cont;
        std::string label;
        std::size_t finallyDepth = 0;  // finallyStack size at loop entry (break/continue run the rest)
        // Scope-teardown bases at loop entry: break/continue run destructors / defers / region
        // frees for everything declared inside the loop since here, before branching out.
        std::size_t soBase = 0;
        std::size_t dfBase = 0;
        std::size_t regBase = 0;
    };
    std::vector<LoopTargets> loopStack;  // (break, continue, label) per active loop / switch
    std::string pendingLoopLabel;        // label to attach to the next loop (from a LabeledStmt)
    // Active try `finally` blocks (innermost last). An exit that leaves a try region
    // (return / break / continue / try?) emits the pending finallys before branching.
    std::vector<const ast::Block*> finallyStack;
    llvm::StructType* stringStructTy = nullptr;  // String layout: { i64 length, ptr data } (spec 4)
    llvm::StructType* boxStructTy_ = nullptr;    // boxed primitive: { ptr vtable, i64 value }
    llvm::StructType* typeStructTy = nullptr;     // reflection Type layout (spec 31)
    llvm::StructType* methodStructTy = nullptr;   // reflection Method layout { ptr name, ptr fn }
    llvm::StructType* fieldStructTy = nullptr;    // reflection Field layout { ptr name }
    llvm::StructType* annotationStructTy = nullptr;  // reflection Annotation layout { ptr name }
    std::unordered_map<std::string, llvm::GlobalVariable*> typeGlobals;  // class name -> its Type global
    std::unordered_map<std::string, llvm::BasicBlock*> labelBlocks;  // `label name;` targets (comefrom)
    // For `goto` (spec 7.9): a goto that jumps out of one or more lexical blocks must run those blocks'
    // defers + stack-object destructors (+ region/String cleanup) first, exactly as a structured exit
    // does -- otherwise the skipped scopes leak. `labelBlock_` maps each label to the block it is declared
    // in (pre-scanned per function body); `blockScopes` is the stack of currently-open blocks with the
    // cleanup bases captured at each one's entry. At a goto we clean every scope nested inside the target
    // label's scope, from innermost out, then branch.
    struct BlockScope { const ast::Block* block; std::size_t so, df, rg, st, vs; };
    std::vector<BlockScope> blockScopes;
    std::unordered_map<std::string, const ast::Block*> labelBlock_;
    std::unordered_map<std::string, const ast::Block*> comefromBlock_;  // where each comefrom sits
    std::unordered_set<std::string> comefromTargets_;  // labels some comefrom hijacks
    std::unordered_map<std::string, llvm::BasicBlock*> comefromBlocks;  // the landing blocks
    std::unordered_set<std::string> abstainedLabels;  // qualified labels named by some `abstainfrom`
    std::unordered_map<std::string, llvm::GlobalVariable*> abstainCounters;  // qualified label -> counter
    // The next top-level label after each one (spec 7.11): an abstained region ends at the next label,
    // not the method end. Key = "class.method.label"; value = the next label's short name.
    std::unordered_map<std::string, std::string> nextAbstainLabel_;
    std::string scanClass_;   // (class, method) context while scanning for abstained labels, so the
    std::string scanMethod_;  // scan can build the same qualified "class.method.label" key as codegen
    std::string enclosingClass_;   // (class, method) of the function being emitted; set even for a
    std::string enclosingMethod_;  // static method (currentClass is "" there). For qualified labels.
    std::unordered_map<std::string, llvm::GlobalVariable*> instanceCounters;  // class -> live-instance count
    std::unordered_set<std::string> unimportableClasses;  // classes named by unimport/reimport (spec 30)
    // Classes that need a live-instance counter WITHOUT needing the rest of unimport.
    //
    // `release region <RegionClass>` needs the same proof `unimport` needs -- nothing alive -- but
    // none of its machinery. Putting those classes in `unimportableClasses` would have worked and
    // would also have emitted the whole code-address table, which anchors every function in the
    // program and, by its own comment, defeats dead-code elimination. A program that releases a
    // phase arena should not pay for a feature it never used.
    std::unordered_set<std::string> countedClasses;
    std::unordered_map<std::string, llvm::GlobalVariable*> aliveFlags;  // class -> i32 alive flag (1=alive)
    // The addresses of everything Polaron emitted as code -- methods, constructors, destructors,
    // interrupts, procedures, lambdas -- so physical unload can bound each overwrite by the next
    // one. Both are filled AFTER the bodies exist; see declareCodeTable/fillCodeTable.
    llvm::GlobalVariable* codeTableBase = nullptr;
    llvm::GlobalVariable* codeTableCount = nullptr;
    // Unimportable classes that wrote no destructor and were given one, so it only decrements.
    std::set<std::string> synthesizedDtors_;
    std::vector<llvm::BasicBlock*> ehPadStack;   // active try landing pads (catchswitch blocks)
    // Parallel to ehPadStack: the cleanup bases (scopeObjects/deferred/scopeRegions sizes) captured when
    // each active try's body began. When a throw inside a try body unwinds to that try's handler, the
    // block-scoped teardown declared since these bases must run first (spec 23.1) -- so `defer`/`using`/
    // destructors in the try body are honoured on the caught path, not just the normal-exit path.
    // The try-body scope bases at the point a try opened, so a throw inside the body runs the block-scoped
    // teardown declared since (spec 23.1) before reaching the handler. On Itanium the handler is not a
    // funclet but ordinary code, so we also carry where a cleanup landing pad should feed after running the
    // teardown: `itDispatch` (the clause-matching block) and `itCarrier` (the slot holding the caught
    // carrier). Both stay null for WinEH tries and for the async-guard sentinel frames.
    struct EhBase {
        std::size_t so, df, rg;
        llvm::BasicBlock* itDispatch = nullptr;
        llvm::Value* itCarrier = nullptr;
    };
    std::vector<EhBase> ehBaseStack;
    llvm::Constant* ehThrowInfoCache = nullptr;  // shared carrier-ptr ThrowInfo (_TI1PEAX), lazy
    llvm::Constant* ehTypeDescCache = nullptr;   // shared carrier-ptr type descriptor, lazy

    Impl(const ast::Program& p, const EntryPoint& e, std::string_view name,
         std::vector<CodegenError>& errs)
        : program(p), entry(e), errors(errs), module(std::string(name), context), builder(context) {
        // newtypes (spec 24) lower to their underlying representation; index them up front so
        // llvmType resolves a newtype name to its underlying type everywhere.
        for (const ast::Bundle& b : program.bundles) {
            for (const ast::Namespace& ns : b.namespaces) {
                for (const ast::TypeAliasDecl& a : ns.typeAliases) {
                    if (a.isNewtype) {
                        newtypes_[a.name] = typeRefName(a.target);
                    }
                }
            }
        }
    }

    void error(std::string message, SourceLocation loc);

    // Anonymous LLVM struct for a tuple type "(T0,T1,...)", cached so the same
    // tuple type always maps to the same struct (LLVM identifies them by shape).
    llvm::StructType* tupleStructType(const std::string& t);

    // The shared LLVM type of a *value* Result/Option (spec 21, value form): { i32 tag, i64 payload }.
    // tag 0 = Ok/Some, 1 = Err/None. Slice 1 packs any scalar/pointer/float payload (<= 64 bits) into the
    // i64 slot; larger value-struct payloads (sret) come in slice 2. One struct type serves every instance.
    llvm::StructType* variantStructTy_ = nullptr;
    llvm::StructType* variantStructType();
    // Pack a scalar/pointer/float payload into the i64 slot (zero-extended / bitcast); None passes null.
    llvm::Value* variantEncode(llvm::Value* v);
    // Reverse of variantEncode: recover the payload as `ty` (truncate / bitcast / inttoptr).
    llvm::Value* variantDecode(llvm::Value* payload, llvm::Type* ty);
    // A RECEIVER FOR A METHOD CALLED ON THE VALUE FORM of Option/Result. The value is a
    // { tag, payload } pair and not an object, so `opt.isSome()` used to load a POINTER out of the
    // tag slot and dispatch through it -- address 1, an access violation on the most ordinary use of
    // the library there is (`list.find(...).isSome()`). This builds the case object the tag names, on
    // the stack, with its vtable and its payload field, so the existing virtual dispatch works
    // unchanged. Null when `sumKey` is not a value sum.
    llvm::Value* valueSumReceiver(const ast::Expr& subject, const std::string& sumKey);

    // Resolve a `newtype` name (spec 24) to its underlying representation type, recursively. Other
    // types pass through unchanged. Used where the physical representation matters (casts, coercion)
    // but the free-function type predicates (intBits/isUnsigned/isFloatType) can't see newtypes_.
    std::string repType(const std::string& t);

    // float/float32 -> f32, double/float64 -> f64; class/array/pointer/ref ->
    // opaque pointer; int/boolean/char/enum -> iN; tuple -> anonymous struct.
    llvm::Type* llvmType(const std::string& t);

    // Adjusts a value to the target type: int->float widening, or integer
    // sign/zero-extend / truncate to the target bit width. Unsigned sources
    // zero-extend and use the unsigned int->float opcode.
    llvm::Value* coerce(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw);

    // A primitive value type that boxes into an Object: it lowers to an integer or float (a class or
    // pointer lowers to a pointer instead).
    bool isBoxablePrimitive(const std::string& t);
    llvm::StructType* boxStructTy();
    // Boxes a primitive into a heap Object: { Object vtable, the value widened to i64 }. The vtable
    // makes it a valid Object (equals/hashCode dispatch); the value round-trips through unboxing.
    llvm::Value* emitBox(llvm::Value* v, const std::string& from);
    // Unboxes an Object back to a primitive: reads the stored value and converts it to `to`.
    llvm::Value* emitUnbox(llvm::Value* box, const std::string& to);

    // Sign-extends or truncates an integer value to `bits`.
    llvm::Value* fitInt(llvm::Value* v, unsigned bits, bool uns = false) {
        const unsigned have = v->getType()->getIntegerBitWidth();
        if (have < bits) {
            return uns ? builder.CreateZExt(v, builder.getIntNTy(bits))
                       : builder.CreateSExt(v, builder.getIntNTy(bits));
        }
        if (have > bits) {
            return builder.CreateTrunc(v, builder.getIntNTy(bits));
        }
        return v;
    }

    // Terminates deterministically with a message (Polaron has no UB): used by runtime checks
    // such as division by zero or out-of-bounds. Ends the current block.
    // `  --> file:line:col  in Class.method`, the same second line a contract violation carries and
    // the same shape as a compile-time diagnostic. Empty when nothing is known, which is better than
    // a confident lie about the location.
    std::string whereLine() const;

    // A guard that fired: stop, and say where and with what.
    //
    // Every one of these printed a bare noun -- "array index out of bounds" -- and nothing else. In a
    // program of any size that names the KIND of accident and withholds everything needed to find it:
    // not the line, not the method, and above all not the index and the length, which between them
    // usually make the mistake obvious on sight.
    //
    // The cost is nothing on the path that matters. The message is a constant, and the two values are
    // moved only inside the block that ends the program -- a block that, in a correct run, is never
    // entered.
    // A GUARD THAT FIRES NEVER COMES BACK, and LLVM has to be told so.
    //
    // `__polaron_fail` and `__polaron_panic` were declared with no attributes at all. Every call to
    // them therefore looked like a call that RETURNS and may write to any memory -- and the calls sit
    // in the failure blocks of bounds checks, which are inside the loop being checked. So LICM could
    // not hoist a single load out of a probe loop: after the guard "returned", `this.keys` might hold
    // something else.
    //
    // Read out of the emitted machine code for `HashMap.slotFor`, against the identical algorithm in
    // C++ -- 12 instructions per probe against 6:
    //
    //     movq  8(%rdi), %r11      <- the `keys` FIELD, reloaded every iteration
    //     movq  (%r11), %r10       <- and its length header, likewise
    //
    // The C++ twin keeps both bases in registers across the whole loop. Two of our six extra
    // instructions are those reloads, and they exist only because a `noreturn` was never declared.
    //
    // `cold` as well: these blocks are the ones a program never executes, and saying so keeps them
    // out of the hot path's cache lines.
    // `noreturn` alone was NOT enough, and the reason is worth keeping. A call with no memory
    // description defaults to reading and writing everything, so LICM had to assume the guard could
    // change `this.keys` -- and a load it cannot prove invariant is a load it will not lift. The loop
    // still reloaded the field after `noreturn` was added; the emitted code said so.
    //
    // What is TRUE of these helpers is narrower and can be stated exactly: they read the strings
    // handed to them, and they touch the console -- memory the caller cannot reach. They do not touch
    // the object. `setOnlyAccessesInaccessibleMemOrArgMem` is precisely that claim, and it is a claim
    // about what the runtime does rather than a convenience: `memory(none)` would also unblock the
    // optimiser and would be a LIE, because printing is a write.
    void markGuardHelper(llvm::FunctionCallee fc) {
        if (auto* f = llvm::dyn_cast<llvm::Function>(fc.getCallee())) {
            f->addFnAttr(llvm::Attribute::NoReturn);
            f->addFnAttr(llvm::Attribute::NoUnwind);
            f->addFnAttr(llvm::Attribute::Cold);
            f->setOnlyAccessesInaccessibleMemOrArgMem();
            // AND ARGMEM IS READ-ONLY. "Inaccessible-or-arg memory" still permits WRITING through the
            // pointer arguments, so the optimiser had to assume a guard could store through the
            // message strings -- and it cannot prove those do not alias the object being probed. The
            // truth is narrower: the guard reads the strings, keeps neither, and writes to neither.
            //
            // `nocapture` STOPPED BEING A FLAG IN LLVM 21. It became `captures(...)`, a richer
            // statement about which components of a pointer escape and how -- so the enumerator this
            // asked for simply does not exist there, and the first Linux build of this compiler could
            // not get past it. The claim is unchanged; only its spelling is.
            for (llvm::Argument& a : f->args()) {
                if (a.getType()->isPointerTy()) {
                    a.addAttr(llvm::Attribute::ReadOnly);
#if LLVM_VERSION_MAJOR >= 21
                    a.addAttr(llvm::Attribute::getWithCaptureInfo(f->getContext(),
                                                                  llvm::CaptureInfo::none()));
#else
                    a.addAttr(llvm::Attribute::NoCapture);
#endif
                }
            }
        }
    }

    void emitGuardFail(const std::string& headline, const char* aLabel, llvm::Value* aVal,
                       const char* bLabel, llvm::Value* bVal, int code) {
        // Freestanding's `__polaron_panic` prints its own `polaron panic: ` tag, so the headline must not
        // arrive carrying a second one; hosted has no tag and says it itself.
        const std::string msg = (program.isFreestanding ? std::string() : std::string("Polaron panic: ")) +
                                headline + "\n" + whereLine();
        if (aVal == nullptr || bVal == nullptr) {
            // A guard with nothing to show has nothing to gain from the wider path.
            emitPanic(msg);
            return;
        }
        llvm::FunctionType* ft = llvm::FunctionType::get(
            builder.getVoidTy(),
            {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(),
             builder.getInt64Ty(), builder.getInt32Ty()},
            false);
        markGuardHelper(module.getOrInsertFunction("__polaron_fail", ft));
        builder.CreateCall(
            module.getOrInsertFunction("__polaron_fail", ft),
            {createGlobalStringPtr(builder, msg, ".fail"),
             createGlobalStringPtr(builder, aLabel, ".faila"),
             builder.CreateSExt(aVal, builder.getInt64Ty(), "fail.a"),
             createGlobalStringPtr(builder, bLabel, ".failb"),
             builder.CreateSExt(bVal, builder.getInt64Ty(), "fail.b"), builder.getInt32(code)});
        builder.CreateUnreachable();
    }

    void emitPanic(const std::string& msg);

    // Hand the class's declared invariants to the optimiser at method entry, as facts it may use.
    // Sound because every exit already checks them -- see the definition.
    void emitInvariantAssumes();

    // The subset of `all` this method can actually break: those naming a field it assigns. See the
    // definition for why a call is not a hole.
    const std::vector<const ast::Expr*>* invariantsToCheck(
        llvm::Function* fn, const std::vector<const ast::Expr*>* all, const ast::Block& body);
    std::unordered_map<llvm::Function*, std::vector<const ast::Expr*>> invariantCheckCache_;

    // Integer division/remainder with a defined result: division by zero (and the signed
    // INT_MIN / -1 overflow) panic instead of being UB.
    llvm::Value* emitIntDivRem(llvm::Value* l, llvm::Value* r, bool uns, bool rem);

    // An arithmetic fault, reported the way the target can afford. A hosted program THROWS, so a caller
    // can decide what a zero divisor means for it; freestanding has no exception machinery (spec 36.3),
    // so the same fault terminates through `__polaron_panic`. The failure is identical either way -- only
    // the reporting differs, exactly as it already did for a bad downcast. Both forms terminate the
    // current block, so every caller can carry straight on with its `ok` block.
    void emitArithFault(const std::string& exceptionClass, const std::string& panicMsg);

    // Defined float->int conversion (Polaron has no undefined behaviour): saturating, so an
    // out-of-range value clamps to the integer min/max and NaN becomes 0, instead of the
    // poison `fptosi`/`fptoui` would produce. Hardware-supported -- no runtime cost.
    llvm::Value* fpToInt(llvm::Value* v, llvm::Type* intTy, bool uns);

    // Explicit numeric conversion for cast<T>(expr): covers every direction,
    // including the narrowing ones the implicit `coerce` refuses (long->int,
    // float->int, f64->f32). Unsigned source/target selects zero-extension and
    // the unsigned int<->float opcodes.
    llvm::Value* emitCast(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw);

    // Coerce a value to a target LLVM type (numeric widen/narrow), e.g. when an
    // argument's static type is a subtype of the parameter type.
    llvm::Value* coerceToType(llvm::Value* v, llvm::Type* ty);

    // Coerces a call argument to what the callee DECLARED, falling back to its LLVM shape.
    //
    // The two part company at a catalog. A catalog-typed value is a TAGGED ordinal
    // (typeId << 32 | ordinal) and lowers to i64 -- the same LLVM type as `long` -- so widening an
    // implementer's ordinal to the parameter's shape produces a number that is a valid i64 and a
    // meaningless catalog value: the tag reads 0, and every call dispatches to whichever enum
    // happens to own tag 0. That is the silent-wrong-answer shape this compiler refuses to have.
    // The language-level coercion knows how to pack the tag, for an ordinal implementer and for a
    // java-style one (whose value is a singleton pointer), so ask it whenever the declaration says
    // the parameter is a catalog.
    llvm::Value* coerceArg(llvm::Value* v, const std::string& fromType, const llvm::Function* fn,
                           std::size_t argIndex) {
        if (v == nullptr || fn == nullptr) {
            return v;
        }
        if (auto it = paramTypeNames.find(fn); it != paramTypeNames.end() &&
                                               argIndex < it->second.size() && !fromType.empty()) {
            const std::string& want = it->second[argIndex];
            if (!want.empty() && want != fromType && isTaggedCatalog(want)) {
                return coerce(v, fromType, want);
            }
        }
        if (argIndex < fn->arg_size()) {
            return coerceToType(v, fn->getArg(argIndex)->getType());
        }
        return v;
    }

    // The class-table key for a type name. A generic instance can end in '*' as part of a type
    // argument (e.g. HashMap$int$Node* is HashMap<int,Node*>), so try the exact name first; only if it
    // is not a registered class do we strip an outer pointer/reference marker (Dog* -> Dog).
    std::string clsKey(const std::string& t) const;

    // IS THERE A C RUNTIME TO CALL `main`, and therefore an argv to marshal?
    //
    // Asked in two places -- where the entry function is DECLARED and where its body is EMITTED -- and
    // they must agree or the signature and the body disagree about how many arguments there are. They
    // were separate copies of `triple.find("none")`, and changing one crashed polc outright.
    //
    // `-none-` is bare metal. A bare WebAssembly module is the same answer reached differently: no
    // libc, no argv, and nothing to call `main` -- but its triple is `wasm32-unknown-unknown` and
    // contains no "none", so it took the hosted path and a module that should have been self-contained
    // imported `__polaron_malloc` and `strlen` to marshal an argv that does not exist. `wasm32-wasi`
    // is excluded: WASI supplies both.
    bool entryHasCRuntime() const {
        const std::string triple = moduleTripleStr(module);
        if (triple.find("none") != std::string::npos) {
            return false;
        }
        if (triple.rfind("wasm", 0) == 0 && triple.find("wasi") == std::string::npos) {
            return false;
        }
        return true;
    }

    // Masks a value to a member's bit-field width (spec 11.1): only the low N bits
    // are kept, so `f : 4 = 20` stores 4. No-op for a non-bit-field member. (Value
    // masking; physical bit-packing of the struct layout is a later refinement.)
    llvm::Value* maskBitField(llvm::Value* v, const std::string& className,
                              const std::string& field) {
        if (v == nullptr || !v->getType()->isIntegerTy()) {
            return v;
        }
        auto cit = classes.find(clsKey(className));
        if (cit == classes.end()) {
            return v;
        }
        auto bit = cit->second.bitFieldWidth.find(field);
        if (bit == cit->second.bitFieldWidth.end()) {
            return v;
        }
        const unsigned w = static_cast<unsigned>(bit->second);
        const unsigned bits = v->getType()->getIntegerBitWidth();
        if (w == 0 || w >= bits) {
            return v;  // covers the whole type -> nothing to mask
        }
        return builder.CreateAnd(
            v, llvm::ConstantInt::get(v->getType(), llvm::APInt::getLowBitsSet(bits, w)),
            "bitfield");
    }

    // ---- the narrow `A*`: a 32-bit offset where a pointer would be ----
    //
    // A region class's instances all live in ONE contiguous arena (see classRegionBlock), so a pointer
    // to one is fully described by its offset from that arena's base -- and an offset fits in 32 bits.
    // A tree node `{int key, int value, Node* left, Node* right}` is 8 bytes of data and 16 of
    // pointers; halving the pointers nearly halves the node, which doubles the nodes per cache line.
    // Pointer-chasing structures are bounded by cache misses rather than arithmetic, so that is a step
    // change and not a percentage.
    //
    // NARROWED IN FIELDS ONLY, and deliberately. The win is entirely about how much of a structure
    // fits in a cache line; a local or an argument lives in a register, where 32 bits buy nothing and
    // the widening arithmetic would be pure cost. So an `A*` in a field is stored as `i32` and every
    // other `A*` stays an ordinary pointer -- one representation change, at the one place it pays.
    //
    // Like a bit field, such a field's storage type is not its declared type, so neither a plain load
    // nor a plain store is correct for one: the two helpers below are the only way to read or write it.
    // Offset 0 is null, which is why the arena never hands out offset 0.

    // Is this field an `A*` whose A is a region class? `weak` slots and bit fields are excluded: they
    // already own their storage shape, and two rewrites of one field would fight.
    bool isNarrowField(const std::string& className, const std::string& field) const {
        auto cit = classes.find(clsKey(className));
        if (cit == classes.end()) {
            return false;
        }
        auto tyIt = cit->second.fieldType.find(field);
        if (tyIt == cit->second.fieldType.end()) {
            return false;
        }
        if (cit->second.bitFieldWidth.count(field) > 0) {
            return false;
        }
        return narrowTargetClass(tyIt->second).empty() ? false : true;
    }

    // The region class a field's declared type points at, or "" if the field is not a narrow pointer.
    // Exactly `A*` -- one level of pointer, no array, no reference -- because anything else is either
    // not a single object or not addressed from the arena's base.
    std::string narrowTargetClass(const std::string& declaredType) const {
        if (declaredType.size() < 2 || declaredType.back() != '*') {
            return "";
        }
        std::string base = declaredType.substr(0, declaredType.size() - 1);
        if (base.find('*') != std::string::npos || base.find('[') != std::string::npos) {
            return "";
        }
        // THE NAME RETURNED HERE BECOMES THE ARENA'S GLOBAL, so it must be the class's own name and
        // not the type as written. A tree's children are `nullable Node*`, and returning
        // "nullable Node" gave them an arena global called `nullable Node.region` -- a second, empty
        // reservation that `new Node()` never allocated from, so every child read back as an offset
        // into the wrong base. It linked and ran and died on the first walk.
        base = clsKey(base);
        auto cit = classes.find(base);
        if (cit == classes.end() || cit->second.decl == nullptr ||
            !cit->second.decl->isRegionClass) {
            return "";
        }
        // An interface- or abstract-typed reference can point into a DIFFERENT family's arena, and an
        // offset is only meaningful against one base. Those keep 64 bits.
        if (cit->second.isInterface || cit->second.isAbstract) {
            return "";
        }
        return base;
    }

    // Read a narrow field: `off == 0 ? null : arenaBase + off`.
    llvm::Value* emitNarrowLoad(llvm::Value* addr, const std::string& target, bool isVolatile,
                                const std::string& name) {
        llvm::Value* off = builder.CreateLoad(builder.getInt32Ty(), addr, isVolatile, name + ".off");
        llvm::Value* base = classArenaBase(target);
        llvm::Value* wide = builder.CreateGEP(builder.getInt8Ty(), base,
                                              builder.CreateZExt(off, builder.getInt64Ty()), name);
        return builder.CreateSelect(
            builder.CreateICmpEQ(off, builder.getInt32(0), name + ".isnull"),
            llvm::ConstantPointerNull::get(builder.getPtrTy()), wide, name);
    }

    // Write a narrow field: `p == null ? 0 : (i32)(p - arenaBase)`.
    void emitNarrowStore(llvm::Value* addr, llvm::Value* value, const std::string& target,
                         bool isVolatile) {
        llvm::Value* base = classArenaBase(target);
        llvm::Value* delta = builder.CreateSub(builder.CreatePtrToInt(value, builder.getInt64Ty()),
                                               builder.CreatePtrToInt(base, builder.getInt64Ty()),
                                               "narrow.delta");
        llvm::Value* off = builder.CreateTrunc(delta, builder.getInt32Ty(), "narrow.off");
        llvm::Value* stored = builder.CreateSelect(builder.CreateIsNull(value, "narrow.isnull"),
                                                   builder.getInt32(0), off, "narrow.store");
        builder.CreateStore(stored, addr, isVolatile);
    }

    // ---- packed bit fields (spec 11.1) ----
    // A bit field has no storage of its own: it lives in bits of a shared unit, and `fieldIndex` gives
    // the UNIT's address. So neither a plain load nor a plain store is correct for one, and the two
    // helpers below are the only way its value may be read or written.

    bool isBitFieldMember(const std::string& className, const std::string& field) const;

    // Reads the field out of its unit, in the field's own declared type.
    llvm::Value* emitBitFieldLoad(llvm::Value* unitAddr, const std::string& className,
                                  const std::string& field, bool isVolatile) {
        const ClassLayout& L = classes.at(clsKey(className));
        const unsigned unitBits = L.bitFieldUnitBits.at(field);
        const unsigned off = L.bitFieldOffset.at(field);
        const unsigned w = static_cast<unsigned>(L.bitFieldWidth.at(field));
        const std::string ft = L.fieldType.at(field);
        llvm::Type* unitTy = builder.getIntNTy(unitBits);
        llvm::Value* unit = builder.CreateLoad(unitTy, unitAddr, isVolatile, field + ".unit");
        // Left-justify, then shift back down. One shape for both signednesses, and the arithmetic shift
        // is what makes a signed 4-bit field holding 0b1111 read as -1 rather than 15 -- the declared
        // width is part of the type, so the value has to come back the way that type would hold it.
        llvm::Value* v = builder.CreateShl(unit, unitBits - off - w, field + ".hi");
        v = isUnsigned(ft) ? builder.CreateLShr(v, unitBits - w, field)
                           : builder.CreateAShr(v, unitBits - w, field);
        llvm::Type* want = llvmType(ft);
        if (want->getIntegerBitWidth() == unitBits) {
            return v;
        }
        return isUnsigned(ft) ? builder.CreateZExtOrTrunc(v, want, field)
                              : builder.CreateSExtOrTrunc(v, want, field);
    }

    // Writes the field back into its unit, leaving every other field in that unit untouched.
    // Read-modify-write, and deliberately ONE access of the unit's natural size in each direction:
    // an MMIO register packed as bit fields must be touched as the register, not byte by byte.
    void emitBitFieldStore(llvm::Value* unitAddr, const std::string& className,
                           const std::string& field, llvm::Value* v, bool isVolatile) {
        const ClassLayout& L = classes.at(clsKey(className));
        const unsigned unitBits = L.bitFieldUnitBits.at(field);
        const unsigned off = L.bitFieldOffset.at(field);
        const unsigned w = static_cast<unsigned>(L.bitFieldWidth.at(field));
        llvm::Type* unitTy = builder.getIntNTy(unitBits);
        const llvm::APInt low = llvm::APInt::getLowBitsSet(unitBits, w);
        // Zero-extend rather than sign-extend: the mask keeps only w bits, and for a value already at
        // least w bits wide the low w bits are the same either way -- so this cannot smear a negative
        // value into a neighbour's bits.
        llvm::Value* wide = builder.CreateZExtOrTrunc(v, unitTy);
        wide = builder.CreateAnd(wide, llvm::ConstantInt::get(unitTy, low), field + ".bits");
        if (off != 0) {
            wide = builder.CreateShl(wide, off);
        }
        llvm::Value* unit = builder.CreateLoad(unitTy, unitAddr, isVolatile, field + ".unit");
        unit = builder.CreateAnd(unit, llvm::ConstantInt::get(unitTy, ~low.shl(off)), field + ".keep");
        builder.CreateStore(builder.CreateOr(unit, wide, field + ".set"), unitAddr, isVolatile);
    }

    // The class a member access names, or "" -- for deciding whether a member IS a bit field.
    std::string bitFieldOwner(const ast::MemberExpr& mem);

    // True if the lvalue denotes a `volatile` local or field (spec 37.5), so its
    // load/store must not be optimized away. Walks T*/T& field access too.
    bool isVolatileAccess(const ast::Expr& expr);

    // The deferred initializer of lazy field `field` declared in `className` or one of
    // its superclasses (spec 28.4), or null if `field` is not a lazy field.
    const ast::Expr* lazyFieldInitOf(const std::string& className, const std::string& field);

    // Runs a heap object's destructor (virtually, if the class is polymorphic) and
    // frees it. The single lowering used by both `delete` and `cascade delete`.
    // Release the object's String fields before its block goes away. Copy-on-store gave each field its
    // own buffer that nothing else can reclaim, so without this every class holding a String leaked it
    // on destruction (a TreeMap<String,int> kept climbing even after the map itself freed its nodes).
    // Skipped for unions, whose fields share one storage, and for `external` fields, which are
    // associations the object does not own.
    void freeStringFields(llvm::Value* objPtr, const std::string& cn);

    void emitDeleteObject(llvm::Value* objPtr, const std::string& cn);

    // A `new T() on heap` value-class rvalue passed as an argument to a by-value copy-discipline parameter
    // is deep-copied by the callee at entry (see emitBody's parameter copy) and never retained, so the
    // caller's fresh heap temporary would leak -- the pervasive `list.add(new T() on heap)` idiom leaked one
    // object per call. This mirrors the String owned-temporary model. Returns the class to destruct after
    // the call (via emitDeleteObject), or "" if the argument is not such an owned temporary. Gated on the
    // parameter being a by-value copy-discipline class, exactly the condition under which the callee copies:
    // a T*/T& or interface/abstract parameter borrows/shares the pointer, so it must NOT be freed here; a
    // movable/unique parameter transfers ownership to the callee, which frees it. A `new ... on stack`
    // argument (an alloca in this frame) is left alone -- freeing it would be a stack free.
    std::string ownedHeapNewArg(const ast::Expr& argExpr, const std::string& paramType);

    // spec 32.8: `Dog.methods.replace("bark", <function value>)` -- install a replacement in the class's
    // vtable slot, so every Dog (already alive or not yet born) dispatches to it. Genuine AOP, mocking
    // without a framework, localized hot patching.
    //
    // A function value in Polaron is a closure pair {code, env} and its code takes the environment as arg 0,
    // while a vtable slot is called as (this, args...). The two are bridged by a thunk emitted per patch
    // site: it has the method's exact signature, reads the closure from a global the patch stores it into,
    // and calls code(env, this, args...). Going through the global (instead of baking the closure in) is
    // what lets the replacement capture, and what lets the same site install a different closure each time
    // it runs. The analyzer already checked the signature, so no dynamic check is needed here.
    llvm::Value* emitMethodPatch(const std::string& cls, const ast::CallExpr& call);

    // Is `sub` a (transitive) subclass of `base`?
    bool derivesFrom(const std::string& sub, const std::string& base);

    // spec 36.4: does this method carry the `[[<name>]]` compiler attribute?
    static bool hasAttribute(const ast::MethodDecl& m, const std::string& name) {
        for (const ast::AnnotationUse& a : m.annotations) {
            if (a.name == name) {
                return true;
            }
        }
        return false;
    }

    // The `cascade` universal prefix (spec 37.1): an operation propagated through an object's
    // owned graph. delete frees, println calls describe() on each node, validate checks invariants.
    enum class CascadeOp { Delete, Println, Validate };

    // Memoized per-(callsite, op, type) cascade helper functions, keyed "op|csid|Type". A fresh
    // family per call site lets each site bake in its own depth/types/except filters.
    std::unordered_map<std::string, llvm::Function*> cascadeFns_;
    std::unordered_map<std::string, llvm::Function*> cloneFns_;  // `cascade clone` helpers, keyed "csid|Type"
    int cascadeCsid_ = 0;  // unique id per cascade call site, so per-site filters never collide
    std::unordered_set<int> forestCsids_;  // cascade sites whose owned graph is provably a forest (skip the visited-set)
    // `lazy region` (spec 37.3): the backing block is allocated on first object insertion, not at
    // the declaration. The slot holds null until then; the size/address expr is replayed on demand.
    std::unordered_set<std::string> lazyRegions_;
    std::unordered_map<std::string, const ast::Expr*> lazyRegionSize_;
    std::unordered_map<std::string, const ast::Expr*> lazyRegionAt_;
    // `itself.atMultiple({...})` (spec 17.4): a multi-range region. Per region variable, its ranges
    // (fixed address + accepts/rejects, from the AST) and one bump used-counter alloca per range.
    // `new T in R` routes to the range whose accepts/rejects matches T (compile-time).
    std::unordered_map<std::string, const std::vector<ast::RegionInitExpr::Range>*> multiRegionRanges_;
    std::unordered_map<std::string, std::vector<llvm::Value*>> multiRegionUsed_;
    // Owned local regions keep their bump cursor in a local i64 alloca (not the block's write-only
    // `used` header field) so mem2reg promotes it to a loop-carried register -- an allocation loop then
    // bumps in a register like a hand-written arena instead of round-tripping the cursor through memory.
    // Keyed by region local name; reset per function. `ownedRegions_` names the locals eligible for it
    // (owned == not `at address`, not multi-range, not a field): their block data begins at block+24 and
    // their `used` header is write-only, so the cursor can live entirely in the alloca.
    std::unordered_map<std::string, llvm::Value*> regionCursorSlot_;
    std::unordered_set<std::string> ownedRegions_;
    // Region flavor (spec 17, flavors expansion): the reclaim strategy of each region local, keyed by
    // name; absent/"" == bump (the untouched fast path). "pool"/"fixedslot" allocate slots via the
    // runtime free-list; "stack" is bump plus mark/rollback; "ring" is a circular buffer. `growable`
    // regions chain a new block on overflow. Reset per function alongside the other region maps.
    std::unordered_map<std::string, std::string> regionFlavor_;
    std::unordered_set<std::string> growableRegions_;
    // Regions whose block was carved out of another region: releasing one runs what it owns and
    // leaves the memory to its parent, because the block was never the allocator's to take back.
    std::unordered_set<std::string> subRegions_;
    // `volatile region` (spec 37.5, MMIO): region locals whose objects must be accessed volatilely,
    // and the object locals bound from `new ... in` such a region (their field accesses are volatile).
    std::unordered_set<std::string> volatileRegions_;
    std::unordered_set<std::string> volatileObjects_;
    // `lazy import` (spec 37.3): per-class "already loaded" flags; the class's onClassLoad runs on
    // the first instance instead of at boot.
    std::unordered_map<std::string, llvm::GlobalVariable*> lazyLoadFlags_;

    // True if class `cn` was brought in by `lazy import` (anywhere in the program).
    bool isLazyImport(const std::string& cn);
    llvm::GlobalVariable* lazyLoadFlag(const std::string& cn);

    // True when the owned graph a `cascade` at this type/filters would traverse is provably a FOREST --
    // every followed edge is single-owner, so no node is reached twice. That makes the runtime visited-set
    // (which exists only to dedup shared/cyclic graphs, spec 37.1 rule 2) pure overhead, and we skip it. An
    // edge is single-owner when it is a value-typed (embedded) class field, a `unique` pointer field, or a
    // pointer to a `unique class`; a plain aliasable class pointer is not, and keeps the set. Uses the exact
    // same field filter as cascadeHelper. `seen` breaks recursive types (the conjunction still holds: every
    // type is fully checked at its first entry). Sound because unique ownership forbids two owners of one
    // object, so an all-single-owner reachable graph cannot share a node or close a cycle.
    bool cascadeIsForest(const std::string& cn, const ast::CascadeParams& params,
                         std::unordered_set<std::string>& seen) {
        if (!seen.insert(cn).second) {
            return true;
        }
        std::unordered_set<std::string> shadowed;
        for (std::string cur = cn; !cur.empty();) {
            auto cc = classes.find(cur);
            if (cc == classes.end()) {
                break;
            }
            for (const auto& [fname, ftype] : cc->second.ownFields) {
                if (!shadowed.insert(fname).second) {
                    continue;
                }
                if (ftype.find('&') != std::string::npos || isArrayType(ftype)) {
                    continue;  // association
                }
                const bool isPtr = ftype.find('*') != std::string::npos;
                if (isPtr && cc->second.externalFields.count(fname) > 0) {
                    continue;  // association
                }
                const std::string fcn = baseType(ftype);
                auto fit = classes.find(fcn);
                if (fit == classes.end()) {
                    continue;  // not a class field
                }
                if (!params.onlyTypes.empty() && std::find(params.onlyTypes.begin(), params.onlyTypes.end(),
                                                           fcn) == params.onlyTypes.end()) {
                    continue;
                }
                if (std::find(params.exceptTypes.begin(), params.exceptTypes.end(), fcn) !=
                    params.exceptTypes.end()) {
                    continue;
                }
                // A followed edge: forest-safe iff embedded value, a unique field, or a unique class.
                if (isPtr && cc->second.uniqueFields.count(fname) == 0 && !fit->second.isUnique) {
                    return false;
                }
                if (!cascadeIsForest(fcn, params, seen)) {
                    return false;
                }
            }
            cur = cc->second.superclass;
        }
        return true;
    }
    bool cascadeIsForest(const std::string& cn, const ast::CascadeParams& params);

    // Emits (or returns the memoized) recursive helper `void(ptr obj, ptr visited, i32 depth)` that
    // applies `op` to one object and propagates through its owned children. The runtime visited-set
    // makes the walk safe on cyclic/shared graphs (spec 37.1 rule 2). Owned children are value-typed
    // class fields and non-`external` class pointers (rule 1); references, arrays and `external`
    // pointers are associations and skipped. depth: -1 = unlimited, 0 = stop, else decremented.
    // When the site is a proven forest (forestCsids_), the visited-set is null and its check is skipped.
    llvm::Function* cascadeHelper(CascadeOp op, int csid, const std::string& cn,
                                  const ast::CascadeParams& params) {
        const std::string key =
            std::to_string(static_cast<int>(op)) + "|" + std::to_string(csid) + "|" + cn;
        if (auto it = cascadeFns_.find(key); it != cascadeFns_.end()) {
            return it->second;
        }

        llvm::FunctionType* fty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt32Ty()},
            false);
        llvm::Function* fn = llvm::Function::Create(
            fty, llvm::Function::InternalLinkage,
            "__cascade." + std::to_string(static_cast<int>(op)) + "." + std::to_string(csid) + "." +
                cn,
            module);
        cascadeFns_[key] = fn;  // memoize before the body so recursive/cyclic types resolve

        const llvm::IRBuilderBase::InsertPoint savedIP = builder.saveIP();
        llvm::Function* savedFn = currentFn;
        currentFn = fn;

        llvm::Argument* objArg = fn->getArg(0);
        llvm::Argument* setArg = fn->getArg(1);
        llvm::Argument* depthArg = fn->getArg(2);

        llvm::BasicBlock* entry = llvm::BasicBlock::Create(context, "entry", fn);
        llvm::BasicBlock* liveBB = llvm::BasicBlock::Create(context, "live", fn);
        llvm::BasicBlock* retBB = llvm::BasicBlock::Create(context, "ret", fn);
        builder.SetInsertPoint(entry);
        builder.CreateCondBr(  // null object: nothing to do
            builder.CreateICmpNE(objArg, llvm::ConstantPointerNull::get(builder.getPtrTy())), liveBB,
            retBB);
        builder.SetInsertPoint(liveBB);
        llvm::BasicBlock* freshBB = llvm::BasicBlock::Create(context, "fresh", fn);
        if (forestCsids_.count(csid) > 0) {
            builder.CreateBr(freshBB);  // proven forest: every node is reached once, no dedup needed
        } else {
            llvm::Value* fresh = builder.CreateCall(ptrsetAddFn(), {setArg, objArg});
            builder.CreateCondBr(  // already visited (cycle / shared): stop
                builder.CreateICmpNE(fresh, builder.getInt32(0)), freshBB, retBB);
        }
        builder.SetInsertPoint(freshBB);

        // Read the owned child pointers BEFORE applying the op, since delete frees this node.
        // Owned = value-typed class field, or a non-`external` class pointer (spec 37.1 rule 1);
        // references, arrays and `external` pointers are associations and are skipped. The
        // type filters (`types:`/`except:`) prune which children we follow, by static type.
        std::vector<std::pair<llvm::Value*, std::string>> children;
        auto cit = classes.find(cn);
        if (cit != classes.end()) {
            std::unordered_set<std::string> seen;  // a shadowed name resolves to the most-derived
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
                        continue;  // assoc
                    }
                    const std::string fcn = baseType(ftype);
                    if (classes.find(fcn) == classes.end()) {
                        continue;  // not a class field
                    }
                    if (!params.onlyTypes.empty() &&
                        std::find(params.onlyTypes.begin(), params.onlyTypes.end(), fcn) ==
                            params.onlyTypes.end()) {
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
                    llvm::Value* childPtr = builder.CreateLoad(
                        builder.getPtrTy(),
                        builder.CreateStructGEP(cit->second.type, objArg, idxIt->second, fname),
                        fname);
                    children.emplace_back(childPtr, fcn);
                }
                cur = cc->second.superclass;
            }
        }

        // Apply the operation to this node, owner before owned (matches destructor order).
        if (op == CascadeOp::Delete) {
            emitDeleteObject(objArg, cn);
        } else if (op == CascadeOp::Println) {
            emitCascadePrintln(objArg, cn);
        } else if (op == CascadeOp::Validate) {
            emitCascadeValidate(objArg, cn);
        }

        // Recurse into the owned children when depth allows (0 = stop, -1 = unlimited).
        llvm::BasicBlock* recBB = llvm::BasicBlock::Create(context, "recurse", fn);
        llvm::BasicBlock* afterBB = llvm::BasicBlock::Create(context, "after", fn);
        builder.CreateCondBr(builder.CreateICmpNE(depthArg, builder.getInt32(0)), recBB, afterBB);
        builder.SetInsertPoint(recBB);
        llvm::Value* unlimited = builder.CreateICmpSLT(depthArg, builder.getInt32(0));
        llvm::Value* nextDepth = builder.CreateSelect(
            unlimited, depthArg, builder.CreateSub(depthArg, builder.getInt32(1)));
        for (const auto& [childPtr, fcn] : children) {
            builder.CreateCall(cascadeHelper(op, csid, fcn, params), {childPtr, setArg, nextDepth});
        }
        builder.CreateBr(afterBB);
        builder.SetInsertPoint(afterBB);
        builder.CreateBr(retBB);
        builder.SetInsertPoint(retBB);
        builder.CreateRetVoid();

        currentFn = savedFn;
        builder.restoreIP(savedIP);
        return fn;
    }

    // Top-level entry for a `cascade` statement: allocate a visited-set, run the walk from `root`,
    // then free the set. `csid` uniquely identifies this call site so its filters do not collide.
    void emitCascade(CascadeOp op, llvm::Value* root, const std::string& cn, int csid,
                     const ast::CascadeParams& params) {
        // Skip the visited-set entirely when the owned graph is provably a forest (all single-owner edges):
        // it can never dedup, so it is pure overhead. Behaviour is identical -- on a forest the set always
        // reports "fresh" -- only faster (no per-node hash insert, no growing table spilling cache).
        const bool forest = cascadeIsForest(cn, params);
        if (forest) {
            forestCsids_.insert(csid);
        }
        llvm::Value* set = forest ? static_cast<llvm::Value*>(
                                        llvm::ConstantPointerNull::get(builder.getPtrTy()))
                                  : static_cast<llvm::Value*>(builder.CreateCall(ptrsetNewFn(), {}));
        builder.CreateCall(cascadeHelper(op, csid, cn, params),
                           {root, set, builder.getInt32(params.depth)});
        if (!forest) {
            builder.CreateCall(ptrsetFreeFn(), {set});
        }
    }

    // `cascade println` (spec 37.1): call the node's describe() to print it. Virtual when the class
    // is polymorphic, else a direct call. The analyzer requires a describe() on the root type.
    void emitCascadePrintln(llvm::Value* objPtr, const std::string& cn);

    std::unordered_map<std::string, std::vector<const ast::Expr*>> mergedInvariants_;
    // Invariants a class must satisfy: its own plus every ancestor's (spec 29). A subclass is bound
    // by the contracts of its base classes, so method/constructor exits check the full chain.
    const std::vector<const ast::Expr*>& classInvariants(const std::string& clsName);

    // `cascade validate` (spec 37.1): check the node's invariants (and inherited ones). The
    // invariant expressions reference `this`, so point currentThis/currentClass at this node.
    void emitCascadeValidate(llvm::Value* objPtr, const std::string& cn);

    // `cascade clone` (spec 37.1): emits (or returns the memoized) helper `ptr(ptr src, ptr map,
    // i32 depth)` that deep-clones `src` and its owned graph. The original-to-clone map makes a
    // shared/cyclic graph clone once and keeps the same sharing. Owned children (value class fields
    // and non-`external` class pointers) are cloned and repointed; everything else (primitives,
    // arrays, `external` pointers) is left as the shallow memcpy copied it.
    llvm::Function* cloneHelper(int csid, const std::string& cn, const ast::CascadeParams& params);

    // Top-level `cascade clone X into dest`: clone X's owned graph and store the new root in dest.
    void emitCascadeClone(llvm::Value* src, const std::string& cn, llvm::Value* destSlot, int csid,
                          const ast::CascadeParams& params) {
        llvm::Value* map = builder.CreateCall(ptrmapNewFn(), {});
        llvm::Value* clone = builder.CreateCall(cloneHelper(csid, cn, params),
                                                {src, map, builder.getInt32(params.depth)});
        builder.CreateCall(ptrmapFreeFn(), {map});
        if (destSlot != nullptr) {
            builder.CreateStore(clone, destSlot);
        }
    }

    // `cascade move` (spec 19.8): copy `src` (a `cn` object) into `region` (bump-
    // allocated), then recursively move the objects it owns by value composition,
    // repointing the copy's field pointers. Returns the moved object's new address.
    // The old objects are reclaimed when their source region is released.
    llvm::Value* emitCascadeMove(llvm::Value* src, const std::string& cn, const std::string& region,
                                 SourceLocation loc) {
        auto cit = classes.find(cn);
        if (cit == classes.end()) {
            return src;  // not a class: leave the value as-is
        }
        llvm::Value* dst = emitRegionAlloc(region, cit->second.type, loc);
        if (dst == nullptr) {
            return src;
        }
        emitMemcpy(dst, src, sizeOf(cit->second.type));
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
                if (ftype.find('*') != std::string::npos || ftype.find('&') != std::string::npos ||
                    isArrayType(ftype)) {
                    continue;  // an association: not moved (shared)
                }
                const std::string fcn = baseType(ftype);
                if (classes.find(fcn) == classes.end()) {
                    continue;
                }
                auto idxIt = cit->second.fieldIndex.find(fname);
                if (idxIt == cit->second.fieldIndex.end()) {
                    continue;
                }
                llvm::Value* fieldPtr =
                    builder.CreateStructGEP(cit->second.type, dst, idxIt->second, fname);
                llvm::Value* child = builder.CreateLoad(builder.getPtrTy(), fieldPtr, fname);
                llvm::Function* fn = currentFn;
                llvm::BasicBlock* doBB = llvm::BasicBlock::Create(context, "cmove.do", fn);
                llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "cmove.cont", fn);
                builder.CreateCondBr(
                    builder.CreateICmpNE(child, llvm::ConstantPointerNull::get(builder.getPtrTy())),
                    doBB, contBB);
                builder.SetInsertPoint(doBB);
                builder.CreateStore(emitCascadeMove(child, fcn, region, loc), fieldPtr);
                builder.CreateBr(contBB);
                builder.SetInsertPoint(contBB);
            }
            cur = cc->second.superclass;
        }
        return dst;
    }

    // If a constructor body opens with `super(...)`, returns that call so the
    // prologue can forward its arguments to the base constructor.
    static const ast::CallExpr* explicitSuperCall(const ast::Block& body) {
        if (body.statements.empty()) {
            return nullptr;
        }
        const auto* es = dynamic_cast<const ast::ExprStmt*>(body.statements.front().get());
        if (es == nullptr) {
            return nullptr;
        }
        const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get());
        if (call != nullptr && dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
            return call;
        }
        return nullptr;
    }

    std::string flattenCallee(const ast::Expr& expr);

    // The class that defines `method`, searching up the superclass chain ("" if none).
    std::string methodOwner(const std::string& className, const std::string& method);

    // The `name$set` setter for property `member` on `className` or any ancestor, or "" if none.
    // Walks the superclass chain so an inherited property's setter is found through the derived type,
    // matching findMethodDecl on the read path (spec 8.4/32).
    std::string propertySetterName(const std::string& className, const std::string& member);

    // Fields in layout order: inherited (base-first, in the base's own layout order, so a subclass's
    // object still starts with exactly the base's prefix), then own.
    //
    // Own fields are grouped by affinity (spec 32.9): hot first, then the unmarked ones, then cold --
    // stably, so declaration order is preserved within each group. Packing the hot fields together at
    // the front means a loop that touches only them touches fewer cache lines. Applying this per class
    // (rather than to the flattened list) is what keeps the base prefix intact.
    std::vector<std::pair<std::string, std::string>> collectFields(const std::string& className);

    // IMPLEMENTING A LAYOUT AUTHORIZES THE COMPILER TO ORDER THE FIELDS, and that authorization is
    // the whole point of the feature. A check that only refuses is a guard against a problem that
    // could have been solved -- and here it can be: every size and alignment is known, Polaron exposes
    // no offsets, so nothing observable depends on the order fields were written in.
    //
    // Widest alignment first, stably, which is what removes the padding a declaration order pays for.
    // Called from inside collectFields so that every reader of the field order -- the bit-field
    // runs, the struct body, reflection -- sees the same one; two orders here would be two layouts.
    //
    // Left alone entirely if any field's alignment cannot be measured yet (its own struct is still
    // being built): a half-sorted order is worse than the written one, because it is neither.
    void orderForLayout(const ClassLayout& l,
                        std::vector<std::pair<std::string, std::string>>& fields) {
        if (l.decl == nullptr || l.decl->layouts.empty() || fields.size() < 2) {
            return;
        }
        std::vector<unsigned> align(fields.size());
        for (std::size_t i = 0; i < fields.size(); ++i) {
            align[i] = alignOfTypeName(fields[i].second);
            if (align[i] == 0) {
                return;
            }
        }
        std::vector<std::size_t> order(fields.size());
        for (std::size_t i = 0; i < order.size(); ++i) {
            order[i] = i;
        }
        std::stable_sort(order.begin(), order.end(),
                         [&](std::size_t a, std::size_t b) { return align[a] > align[b]; });
        std::vector<std::pair<std::string, std::string>> sorted;
        sorted.reserve(fields.size());
        for (std::size_t i : order) {
            sorted.push_back(fields[i]);
        }
        fields = std::move(sorted);
    }

    // Every virtual method name this class participates in: its own instance
    // methods plus everything inherited from its superclass and interfaces.
    // Order is irrelevant now that slots are global; we just need the set.
    void collectVirtualNames(const std::string& className, std::vector<std::string>& out);

    // The class's vtable laid out by global slot: vtslots[g] is the method name the
    // class provides at global slot g, or "" for slots it does not implement (those
    // become a null entry in the emitted vtable). Sized so an indirect call's GEP is
    // valid for every polymorphic class regardless of which methods it has.
    std::vector<std::string> computeSlots(const std::string& className);

    // Mangled name of the most-derived concrete implementation of `method` at or
    // above `className` ("" if the slot is still abstract).
    std::string vtableImpl(const std::string& className, const std::string& method);

    // Mangled name of a non-abstract default method `method` reachable through the interfaces of
    // `className` or its ancestors (spec 9), searched transitively. "" if none provides a default.
    std::string interfaceDefaultImpl(const std::string& className, const std::string& method);

    // Mangled name of the most-derived declared destructor at or above `className`
    // ("" if no class in the hierarchy declares one). Used both for the virtual
    // destructor vtable slot and for derived->base destructor chaining.
    std::string dtorImpl(const std::string& className);

    // The MethodDecl for `method` visible from `className` (for its signature).
    const ast::MethodDecl* findMethodDecl(const std::string& className, const std::string& method);

    // Call `method` on `recv` (a class/interface object), dispatching through the vtable when the class is
    // polymorphic and directly otherwise. `cls` is the receiver's class (or interface) name, `fty` the
    // signature (receiver first). Used by the Iterable foreach lowering (spec 9.2), where the receiver may
    // be an interface reference whose concrete type is only known at run time.
    llvm::Value* emitDynCall(const std::string& cls, const std::string& method, llvm::FunctionType* fty,
                             llvm::Value* recv, const std::vector<llvm::Value*>& extra = {}) {
        std::vector<llvm::Value*> args{recv};
        args.insert(args.end(), extra.begin(), extra.end());
        auto cit = classes.find(clsKey(cls));
        if (cit != classes.end() && cit->second.hasVtable) {
            const int slot = slotIndex(cls, method);
            if (slot >= 0) {
                llvm::Value* vtblField =
                    builder.CreateStructGEP(cit->second.type, recv, 0, "it.vtbl.addr");
                llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "it.vtbl");
                llvm::Type* vtArrTy =
                    llvm::ArrayType::get(builder.getPtrTy(), cit->second.vtslots.size());
                llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                    vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "it.slot");
                llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "it.fn");
                return builder.CreateCall(fty, fnPtr, args);
            }
        }
        const std::string owner = methodOwner(clsKey(cls), method);
        auto fnit = functions.find(owner + "." + method);
        if (owner.empty() || fnit == functions.end()) {
            return nullptr;
        }
        return builder.CreateCall(fnit->second, args);
    }

    // At most this many implementations get a guarded direct call before we give up and just do the
    // indirect one. Two is what GCC settles on for the same transform, and the reason is the same:
    // each guard is a compare and a predictable branch, and past a couple of them the chain costs
    // more than the indirect call it is replacing.
    static constexpr std::size_t kMaxSpeculatedTargets = 2;

    // SPECULATIVE DEVIRTUALIZATION (a polymorphic inline cache, built at compile time).
    //
    // A vtable call is three instructions and looks cheap, but the indirect branch is the expensive
    // part: when the receiver's type alternates, the predictor misses every time, and the call
    // cannot be inlined so the body never fuses with its caller. Measured against g++ on
    // `performance tests/virtualcall.pol` -- an interface with two implementations, alternating --
    // we were 2.8x slower doing exactly the textbook thing.
    //
    // What g++ does instead, and what this emits: compare the loaded slot against the handful of
    // implementations the program actually contains, call those DIRECTLY when they match (so the
    // inliner can then swallow them), and keep the indirect call only as the fallback.
    //
    // The transform is unconditionally safe and needs no type analysis to justify it: the guard
    // compares the function POINTER, so a wrong guess simply falls through to the same indirect call
    // that would have happened anyway. The only requirement is that a candidate's signature matches
    // the call, which is checked here rather than assumed.
    //
    // Returns null when speculation is not worth it, and the caller emits its ordinary indirect call.
    llvm::Value* emitSpeculatedCall(llvm::Value* fnPtr, llvm::FunctionType* fty,
                                    const std::string& method,
                                    const std::vector<llvm::Value*>& args) {
        // `unimport` POISONS vtable slots at run time so a call into a removed type traps. A guarded
        // direct call would sail straight past that, which is a correctness hole, not a slow path --
        // so a program that unimports anything gets no speculation at all.
        // `POLARON_DV_TRACE=1` says, per call site, why speculation did or did not happen. A transform
        // that silently declines is indistinguishable from one that is not wired in at all.
        static const bool trace = std::getenv("POLARON_DV_TRACE") != nullptr;
        if (!unimportableClasses.empty()) {
            if (trace) {
                std::fprintf(stderr, "devirt: %s skipped -- program uses unimport\n", method.c_str());
            }
            return nullptr;
        }
        std::vector<llvm::Function*> cands;
        for (auto& [cname, cl] : classes) {
            if (cl.vtable == nullptr) {
                continue;  // abstract/interface/imported: nothing to speculate
            }
            // vtableImpl returns the FULL function name ("Square.area"), not the owning class.
            const std::string implName = vtableImpl(cname, method);
            if (implName.empty()) {
                continue;
            }
            auto fit = functions.find(implName);
            if (fit == functions.end() || fit->second == nullptr) {
                if (trace) {
                    std::fprintf(stderr, "devirt:   %s -> no function '%s'\n", cname.c_str(),
                                 implName.c_str());
                }
                continue;
            }
            llvm::Function* impl = fit->second;
            if (impl->getFunctionType() != fty) {  // signature must match to call it directly
                if (trace) {
                    std::fprintf(stderr, "devirt:   %s -> '%s': signature differs\n", cname.c_str(),
                                 implName.c_str());
                }
                continue;
            }
            if (std::find(cands.begin(), cands.end(), impl) != cands.end()) {
                continue;
            }
            cands.push_back(impl);
            if (cands.size() > kMaxSpeculatedTargets) {
                if (trace) {
                    std::fprintf(stderr, "devirt: %s skipped -- more than %zu implementations\n",
                                 method.c_str(), kMaxSpeculatedTargets);
                }
                return nullptr;
            }
        }
        if (cands.empty()) {
            if (trace) {
                std::fprintf(stderr, "devirt: %s skipped -- no candidate matched the signature\n",
                             method.c_str());
            }
            return nullptr;
        }
        if (trace) {
            std::fprintf(stderr, "devirt: %s speculated over %zu implementation(s)\n", method.c_str(),
                         cands.size());
        }

        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        const bool isVoid = fty->getReturnType()->isVoidTy();
        auto* joinBB = llvm::BasicBlock::Create(context, "dv.join", fn);
        std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> incoming;
        for (llvm::Function* c : cands) {
            auto* hitBB = llvm::BasicBlock::Create(context, "dv.hit", fn);
            auto* missBB = llvm::BasicBlock::Create(context, "dv.miss", fn);
            builder.CreateCondBr(builder.CreateICmpEQ(fnPtr, c, "dv.is"), hitBB, missBB);
            builder.SetInsertPoint(hitBB);
            // emitMaybeInvoke, not CreateCall: inside a `try` these must be invokes like any other
            // call, or an exception thrown through a speculated target would miss the landing pad.
            // It leaves the builder at the continuation block, which is what the phi must name.
            llvm::Value* r = emitMaybeInvoke(fty, c, args);
            if (!isVoid) {
                incoming.push_back({r, builder.GetInsertBlock()});
            }
            builder.CreateBr(joinBB);
            builder.SetInsertPoint(missBB);
        }
        llvm::Value* r = emitMaybeInvoke(fty, fnPtr, args);  // fallback: the original indirect call
        if (!isVoid) {
            incoming.push_back({r, builder.GetInsertBlock()});
        }
        builder.CreateBr(joinBB);
        builder.SetInsertPoint(joinBB);
        if (isVoid) {
            return llvm::UndefValue::get(builder.getInt32Ty());  // caller ignores it
        }
        llvm::PHINode* phi = builder.CreatePHI(fty->getReturnType(), incoming.size(), "dv.r");
        for (auto& [v, bb] : incoming) {
            phi->addIncoming(v, bb);
        }
        return phi;
    }

    // The vtable slot for `method`. Slots are global per method name, so this is the
    // same whether the call goes through the class or any interface it implements.
    // The staticType is kept for the signature but no longer affects the index.
    int slotIndex(const std::string& staticType, const std::string& method);

    // True when `rt` names a value struct (not a pointer): such a return uses the sret convention.
    bool returnsValueStruct(const std::string& rt);

    // Signature of an instance method as called through a vtable: (this, params) -> ret. A value
    // struct return becomes a trailing sret pointer with a void return (spec 11 value semantics).
    llvm::FunctionType* methodFnType(const ast::MethodDecl* m);

    // The type of `c ? a : b` comes from BOTH arms. Taking it from the then-arm alone -- which both this
    // phase and the analyzer used to do -- silently truncated the other one: `long r = c ? 7 : big;` typed
    // the whole ternary `int` from the literal `7`, emitted `trunc i64 %big to i32`, and the assignment to
    // `long` then looked like an ordinary widening, so nothing anywhere reported it. The two phases agreed,
    // which is exactly why no test caught it: they were consistently wrong.
    std::string ternaryType(const ast::TernaryExpr& t);

    // Type name of an expression. Assumes a valid AST (semantic analysis ran).
    std::string typeName(const ast::Expr& expr);  // out of line in codegen_types.cpp
    std::string typeNameUncached(const ast::Expr& expr);   // the body; typeName memoises around it
    // Live only for the duration of one top-level typeName question -- see the note there. Without
    // it a chain of method calls costs 2^depth, because several branches ask a child's type twice.
    std::unordered_map<const ast::Expr*, std::string> typeNameMemo_;
    int typeNameDepth_ = 0;

    llvm::FunctionCallee printf();

    llvm::FunctionCallee scanf();

    llvm::FunctionCallee exitFn();

    // Contracts (spec 29): if the boolean condition is false at runtime, report and exit(1).
    // Collects every old(...) occurrence inside a contract expression so the entry-time values can
    // be captured before the body runs (spec 29).
    void collectOld(const ast::Expr* e, std::vector<const ast::OldExpr*>& out);

    // Whether re-evaluating this expression in the failure path is free of consequences.
    //
    // A contract that fails is about to stop the program, and the most useful thing it can say is
    // what the two sides actually were -- but reading them means running the expression a second
    // time. That is only honest for expressions that do nothing but read: a call could log, mutate
    // or allocate, and a diagnostic that changes the state it is diagnosing is worse than no
    // diagnostic. Anything not on this list simply goes unquoted.
    static bool isPureToReread(const ast::Expr* e) {
        if (e == nullptr) {
            return false;
        }
        if (dynamic_cast<const ast::IdentifierExpr*>(e) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::IntLiteralExpr*>(e) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::BoolLiteralExpr*>(e) != nullptr) {
            return true;
        }
        if (dynamic_cast<const ast::CharLiteralExpr*>(e) != nullptr) {
            return true;
        }
        if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
            return m->object == nullptr || isPureToReread(m->object.get());
        }
        if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
            return u->op != "++" && u->op != "--" && isPureToReread(u->operand.get());
        }
        if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
            return isPureToReread(ca->operand.get());
        }
        // Arithmetic over pure operands is itself pure: assignment is not an expression in Polaron, so a
        // BinaryExpr computes and does nothing else. Without this a clause like
        // `offset + 4 <= this.size` printed its text and then no numbers -- and the numbers are the
        // half that says which call went wrong.
        if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
            return isPureToReread(b->lhs.get()) && isPureToReread(b->rhs.get());
        }
        return false;
    }

    // The clause as it reads in the source, trimmed, or "" when the source is not to hand.
    //
    // Taken as the WHOLE LINE rather than reconstructed from the tree: Polaron puts one clause on one
    // line, so the line is the clause, and it comes back with the spacing and spelling the author
    // wrote instead of a pretty-printer guessing at them.
    std::string clauseText(const SourceLocation& loc) const;

    void emitContractCheck(const ast::Expr& cond, const char* kind);

    llvm::FunctionCallee mallocFn();
    llvm::FunctionCallee reallocFn() {  // realloc(ptr, size) -> ptr (for array resize, spec 25)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_realloc", ty);  // pooled (runtime)
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
            f->addRetAttr(llvm::Attribute::NoAlias);
        }
        return c;
    }
    // __polaron_persist_slot(key, index, size) -> block: the in-process registry for index-keyed
    // persistent reattach (spec 18.5). Returns the surviving block for (key, index) or a fresh zeroed
    // one, so `delete arr[i]; arr[i] = new T()` reattaches by slot within a run.
    llvm::FunctionCallee persistSlotFn();
    // Keyed lookup. Takes the INITIAL bytes rather than an "is this new?" flag: the registry copies them
    // only when it creates the block, so a first attach starts from what the constructor wrote and a
    // reattach keeps what accumulated -- one call, and no branch in the emitted code.
    llvm::FunctionCallee persistSlotKeyedFn();
    llvm::FunctionCallee persistReleaseKeyedFn();
    llvm::FunctionCallee persistReleaseAllFn();

    llvm::FunctionCallee freeFn();
    llvm::FunctionCallee checkLiveFn() {  // panics on a delete of an already-freed block (runtime)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_check_live", ty);
    }

    // Region backing-memory acquire/release (spec 17). Routes through the runtime's region cache instead
    // of raw malloc/free so a hot `allocate ... release` arena loop reuses the block on this thread rather
    // than round-tripping a multi-megabyte allocation through the OS (mmap/munmap + page zeroing) every
    // iteration -- the dominant cost, since the bump allocation itself is nearly free.
    // A region class's arena: one contiguous reservation, committed as it fills, so a narrow `A*` has
    // exactly one base to be an offset from. See codegen_layout.cpp.
    llvm::FunctionCallee arenaReserveFn();
    llvm::FunctionCallee arenaAllocFn();
    llvm::FunctionCallee arenaBaseFn();
    llvm::FunctionCallee arenaFreeFn();
    llvm::FunctionCallee regionAcquireFn();
    llvm::FunctionCallee regionReleaseFn();
    // Flavored-region allocator (spec 17, flavors expansion). init sets up a pool/fixedslot/ring block's
    // descriptor; new pops/bumps a slot; free returns a slot to the region's free-list. Bump/stack never
    // call these -- they keep the inline bump fast path.
    llvm::FunctionCallee regionInitFn() {  // (block, flavor, cap, growable) -> void
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(),
            {builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__polaron_region_init", ty);
    }
    llvm::FunctionCallee regionFreeChainFn() {  // (block) -> void  (free a growable region's block chain)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_free_chain", ty);
    }
    llvm::FunctionCallee regionNewFn() {  // (block, size) -> ptr
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_region_new", ty);
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
            f->addRetAttr(llvm::Attribute::NoAlias);
        }
        return c;
    }
    llvm::FunctionCallee regionFreeFn() {  // (block, ptr, size) -> void
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__polaron_region_free", ty);
    }
    llvm::FunctionCallee regionTrackFn() {  // (block, ptr, dtor) -> void  (record for release/rollback)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_track", ty);
    }
    llvm::FunctionCallee regionUntrackFn() {  // (block, ptr) -> void  (destructed by hand; forget it)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_untrack", ty);
    }
    // ---- region snapshots (spec 32.2) ----
    llvm::FunctionCallee regionSnapshotSizeFn() {  // (block) -> bytes needed to hold a snapshot
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_snapshot_size", ty);
    }
    llvm::FunctionCallee regionSnapshotFn() {  // (block, into, room) -> void
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty()},
            false);
        return module.getOrInsertFunction("__polaron_region_snapshot", ty);
    }
    llvm::FunctionCallee regionRestoreFn() {  // (block, from) -> void; runs destructors first
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_restore", ty);
    }
    llvm::FunctionCallee regionSlotSizeFn() {  // (ptr) -> the payload size of that region slot
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_slot_size", ty);
    }
    llvm::FunctionCallee regionRollbackFn() {  // (block, mark) -> void  (stack: destruct + reset cursor)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__polaron_region_rollback", ty);
    }
    llvm::FunctionCallee regionTeardownFn() {  // (block) -> void  (stack: run all dtors + free registry)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_region_teardown", ty);
    }
    llvm::FunctionCallee ringNewFn() {  // (block, size) -> ptr  (circular; evicts oldest when full)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__polaron_ring_new", ty);
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee())) {
            f->addRetAttr(llvm::Attribute::NoAlias);
        }
        return c;
    }
    llvm::FunctionCallee ringSetDtorFn() {  // (block, dtor) -> void  (the ring's single element dtor)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_ring_set_dtor", ty);
    }
    llvm::FunctionCallee ringTeardownFn() {  // (block) -> void  (destruct live entries before free)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__polaron_ring_teardown", ty);
    }
    // Region flavor classification. bump ("") uses the inline cursor fast path. pool/fixedslot/stack use
    // the runtime PolaronRegionDesc: pool/fixedslot allocate reclaimable slots from a free-list, stack bumps
    // with mark/rollback. (ring joins usesRuntimeDesc in a later wave.)
    static bool isPoolLikeFlavor(const std::string& f) { return f == "pool" || f == "fixedslot"; }
    static bool isStackFlavor(const std::string& f) { return f == "stack"; }
    static bool isRingFlavor(const std::string& f) { return f == "ring"; }
    // A runtime-desc flavor uses the PolaronRegionDesc header (not the inline bump cursor): everything but bump.
    static bool usesRuntimeDesc(const std::string& f) {
        return f == "pool" || f == "fixedslot" || f == "stack" || f == "ring";
    }
    // The declared flavor of a region referenced by `name`: a local (regionFlavor_) or a `this.field`
    // region (looked up on the current class's field). "" == bump.
    const ast::FieldDecl* regionFieldDecl(const std::string& name);
    std::string flavorOfRegion(const std::string& name);
    bool growableOfRegion(const std::string& name);
    // `region` fields that own their block, keyed "Class.field" (filled by collectFieldRegionKinds).
    std::set<std::string> ownedFieldRegions_;
    // Does this region carry a RUNTIME destructor registry -- i.e. must its objects be recorded with
    // __polaron_region_track rather than in the compiler's scopeObjects?
    //
    // Field regions must. A field region lives as long as the object owning it, so objects enter it from
    // any method, and the compiler only ever sees the ones written in the block that releases it. A parse
    // tree assembled across method calls had NO destructor run at all -- silently, because everything the
    // compiler could see was handled. The registry is the only thing that can know.
    //
    // Local regions must not, and that is not a compromise: a local region cannot outlive the function
    // that declares it and cannot be passed anywhere, so every object that enters it is written in that
    // one function and scopeObjects already sees all of them. Tracking them at run time would buy nothing
    // and cost a call per object.
    //
    // A `stack` region always has one (mark/rollback is built on it); a `ring` never does (its entries
    // all share one destructor, which the ring teardown runs). bump/pool/fixedslot get one iff they are
    // a field.
    bool regionHasRegistry(const std::string& name);
    bool isOwnedFieldRegion(const std::string& name);
    // The flavored-region data offset -- MUST match POLARON_REGION_HDR in runtime/polaron_rt.cpp.
    static constexpr unsigned kRegionHdr = 448u;
    // The descriptor flavor code stored at block+24 (matches the runtime's reading).
    static unsigned flavorCode(const std::string& f) {
        if (f == "pool") {
            return 1;
        }
        if (f == "stack") {
            return 2;
        }
        if (f == "fixedslot") {
            return 3;
        }
        if (f == "ring") {
            return 4;
        }
        return 0;  // bump
    }
    // The flavor + growth threaded into emitRegionAllocate for an eager `<flavor> region r =
    // itself.allocate(...)` (the init expr itself does not carry them; the VarDecl does). Set around
    // emitExpr(init).
    std::string pendingRegionFlavor_;
    bool pendingRegionGrowable_ = false;
    // Set only around a `this.field = itself.allocate(...)`: that block gets the descriptor header so it
    // can carry a destructor registry (see regionHasRegistry).
    bool pendingRegionRegistry_ = false;

    // sizeof(type) in bytes, the target-portable way: gep null + 1, then
    // ptrtoint. The backend folds it to a constant using the real data layout.
    llvm::Value* sizeOf(llvm::Type* type);

    // Whether `t` NAMES A TYPE. `llvmType` is total -- it answers for anything, falling back to an
    // integer -- so `sizeof(x)` needs this first to tell "the type vec2" from "some expression named
    // vec2". Without it, sizeof(vec2) silently measured the fallback and reported 4 for an 8-byte
    // vector: a wrong number, which is worse than a rejected one.
    bool namesAType(const std::string& t);

    // The byte size of a named type, from the TARGET's DataLayout -- the single authority on layout,
    // which is why `static_assert(sizeof(T) <= N)` is folded here and not in the analyzer (spec 28.2,
    // issue #7). Returns false when `t` does not name a type.
    bool sizeOfTypeName(const std::string& t, long long& out);

    // The alignment a named type demands, from the same DataLayout. 0 when it cannot be measured yet
    // -- a field whose own struct is still being built. Callers treat that as "do not reorder", which
    // keeps a partly-known layout in declaration order instead of half-sorting it.
    unsigned alignOfTypeName(const std::string& t);

    // A value-type struct passed/returned across FFI by value (spec 26). True unless `t` is a
    // pointer/reference to the struct (those pass as a plain pointer).
    bool isFfiByValueStruct(const std::string& t);
    // FFI ABI (Win64): a by-value struct of 1/2/4/8 bytes travels in a register as an integer of
    // that size. Returns that integer type, or nullptr if `t` is not a register-sized by-value
    // struct (the type then passes as-is, e.g. a pointer).
    llvm::Type* ffiStructRegType(const std::string& t);

    // The target's `size_t`, from the TRIPLE rather than assumed. See its definition: read from the
    // data layout it silently answered 64 on every target that has no layout, which is five of the
    // 32-bit ones.
    llvm::Type* sizeTy();
    // Checks every C library function this module declares against what the TARGET says it is. Run
    // before the module is handed on; see its definition for why LLVM's own verifier cannot do this.
    bool auditLibcSignatures();
    // ...and THESE are how memset/memcpy are called, never `CreateCall(memsetFn(), ...)` directly.
    // Every length in this compiler is computed in 64 bits (a size, an element count, a string's
    // length), and on a 32-bit target the library function takes 32 -- so the adaptation belongs in
    // one place rather than at each of twenty call sites, where the twenty-first would be written
    // without it.
    llvm::CallInst* emitMemset(llvm::Value* dst, llvm::Value* byte, llvm::Value* len) {
        return builder.CreateCall(
            memsetFn(), {dst, byte, builder.CreateZExtOrTrunc(len, sizeTy(), "len")});
    }
    llvm::CallInst* emitMemcpy(llvm::Value* dst, llvm::Value* src, llvm::Value* len) {
        return builder.CreateCall(
            memcpyFn(), {dst, src, builder.CreateZExtOrTrunc(len, sizeTy(), "len")});
    }
    llvm::FunctionCallee memsetFn();

    // Whether the type wrote a constructor of its own. A struct that did is saying what its initial
    // values are; one that did not gets zeroed at `new` -- see `emitNew`.
    bool hasDeclaredConstructor(const std::string& cn) {
        auto it = classes.find(cn);
        if (it == classes.end() || it->second.decl == nullptr) {
            return false;
        }
        for (const ast::MemberPtr& m : it->second.decl->members) {
            if (dynamic_cast<const ast::ConstructorDecl*>(m.get()) != nullptr) {
                return true;
            }
        }
        return false;
    }

    llvm::FunctionCallee memcpyFn();

    // Cascade cycle-detection visited-set (spec 37.1, rule 2): new/add/free over object addresses.
    llvm::FunctionCallee ptrsetNewFn();
    llvm::FunctionCallee ptrsetFreeFn();
    llvm::FunctionCallee ptrsetAddFn() {  // returns 1 if newly added, 0 if already seen
        return module.getOrInsertFunction(
            "__polaron_ptrset_add", llvm::FunctionType::get(builder.getInt32Ty(),
                                                         {builder.getPtrTy(), builder.getPtrTy()},
                                                         false));
    }

    // Original-to-clone map for `cascade clone` (spec 37.1): new/free/get/put.
    llvm::FunctionCallee ptrmapNewFn();
    llvm::FunctionCallee ptrmapFreeFn();
    llvm::FunctionCallee ptrmapGetFn() {  // returns the clone, or null if not yet cloned
        return module.getOrInsertFunction(
            "__polaron_ptrmap_get", llvm::FunctionType::get(builder.getPtrTy(),
                                                         {builder.getPtrTy(), builder.getPtrTy()},
                                                         false));
    }
    llvm::FunctionCallee ptrmapPutFn();

    llvm::FunctionCallee strcmpFn();
    // Length-aware content equality of two String objects -> i32 (1 equal, 0 not). Correct even when the
    // data buffer is not NUL-terminated (unlike strcmp), and null-safe. Backs String `==`/`!=` (spec 4).
    llvm::FunctionCallee strEqFn();
    // Cached FNV-1a hash of a String object (runtime helper reads/fills the object's hash field), for
    // Hashable<String>. Takes the String object pointer so repeated hashing of the same immutable String
    // (the HashMap<String,...> hot path) is a single field read after the first call.
    llvm::FunctionCallee strHashFn();
    // itoa runtime helper (writes decimal digits to a buffer, returns length), for int.toString().
    llvm::FunctionCallee itoaFn();

    // ftoa runtime helper (writes %g text to a buffer, returns length), for float.toString().
    llvm::FunctionCallee ftoaFn();

    // Builds a String object on the heap from a length and a null-terminated byte buffer.
    llvm::Value* emitStringFromParts(llvm::Value* len, llvm::Value* data);
    // The Decimal scale (10^18) as an i128 constant.
    llvm::Value* decimalScale();
    // Formats a Decimal (i128 mantissa, scale 10^18) as a String: sign, integer part, '.', then the
    // 18 fraction digits (spec 34). The fraction fits an i64, so it prints with %018llu.
    llvm::Value* emitDecimalToString(llvm::Value* v);
    // Loads the i64 length field of a String object.
    llvm::Value* stringLen(llvm::Value* strObj);

    // A class value (not a pointer/ref, not an array, not a primitive/enum).
    bool isClassValue(const std::string& t);

    // Only the default discipline copies; movable/unique transfer the pointer.
    bool isCopyDiscipline(const std::string& t);

    // An existing object that a value copy must duplicate (vs. a fresh `new`). Reading an array element
    // (`arr[i]`) yields an existing object too, so it is copyable: without this, `dst[i] = src[i]` (e.g.
    // ArrayList's grow migration `bigger[i] = this.data[i]`) shallow-shared the boxed value-class element
    // between the two arrays -- a value-semantics violation, and a double-free once the source is freed.
    bool isCopyableLValue(const ast::Expr& e);

    // Duplicates an array block [ i64 length | elems... ] into a fresh heap block
    // so a value copy does not share the elements. Elements are 4 bytes in 0.1.
    // Types currently on the deep-copy / free chain, to break self-referential type cycles at codegen
    // time (e.g. Node holding an ArrayList<Node>): a cyclic sub-object is shared rather than recursed
    // into forever. Acyclic types get a full deep copy / free.
    std::unordered_set<std::string> copyChain_;

    llvm::Value* emitArrayDup(llvm::Value* srcBlock, const std::string& elemType);

    // Allocates a fresh struct and copies srcPtr into it (deep value copy): the
    // bytes are memcpy'd first, then each field that owns its storage -- arrays
    // and value sub-objects -- is duplicated so the two objects share nothing.
    // Pointer/reference fields are shared on purpose; primitives copy inline.
    llvm::Value* emitClassCopy(const std::string& className, llvm::Value* srcPtr, bool heap = false) {
        auto cit = classes.find(className);
        if (cit == classes.end()) {
            return srcPtr;
        }
        llvm::StructType* st = cit->second.type;
        // A REGION CLASS'S COPY IS IN ITS REGION TOO, and this is not a refinement -- it is the
        // guarantee. `A b = a;` allocates an A, and totality admits no exception for the allocation
        // the COMPILER makes rather than the one the author wrote: `emitNew` refuses `on heap` and
        // `in region other` for exactly this reason, and a copy on the stack (or the heap) walked
        // out through the door those refusals close.
        //
        // What made it a crash rather than a broken invariant: a narrow `A*` field stores
        // `(i32)(p - arenaBase)`. Given a stack copy, that subtraction is an arbitrary number
        // truncated to 32 bits, so the field pointed at neither the copy nor anything else in the
        // reservation. Measured before the fix, on a two-line program: access violation, no
        // diagnostic. Not "a copy in the wrong place" -- a wild pointer with a pointer's face on it.
        //
        // The price is the one the design already states for every other instance: a copy lives
        // until it is deleted or the region dies, not until the block exits.
        llvm::Value* dest = nullptr;
        if (cit->second.decl != nullptr && cit->second.decl->isRegionClass) {
            dest = classArenaAlloc(className, sizeOf(st));
        } else {
            // A copy bound to a field must outlive the current frame -> heap; a copy bound to a local
            // can live in the frame -> stack.
            dest = heap ? builder.CreateCall(mallocFn(), {sizeOf(st)}, className + ".copy")
                        : createEntryAlloca(className + ".copy", st);
        }
        emitMemcpy(dest, srcPtr, sizeOf(st));  // shallow copy first
        // A deep copy is a fresh object: it has no incoming `weak T*` refs and observes nothing through its
        // own weak fields, so reset the copied weak-list head and every weak slot to null. Otherwise the
        // memcpy would (a) duplicate the source's list-head, so a later target death walks a stale slot in
        // the copy, and (b) leave the copy's weak slots claiming to be linked into a list they aren't in.
        initWeakState(dest, className);
        // Break self-referential type cycles: if this class is already being copied up the call chain
        // (a field or array/collection element of its own type, directly or transitively), stop at the
        // shallow copy -- the cyclic sub-object is shared. Without this the codegen recurses on the type
        // forever (stack overflow). Acyclic types fall through to the full deep copy.
        if (!copyChain_.insert(className).second) {
            return dest;
        }
        for (const auto& [fname, ftype] : collectFields(className)) {
            const unsigned idx = cit->second.fieldIndex[fname];
            // A `transient` field is derived/scratch state, not part of the object's canonical value:
            // a copy begins clean and rebuilds it lazily, rather than inheriting the source's (which
            // for an owned pointer/String/array would also alias its storage). Reset to the type's
            // default (null/0), overwriting the shallow memcpy, and skip the deep copy.
            if (cit->second.transientFields.count(fname) > 0) {
                llvm::Type* et = st->getElementType(idx);
                builder.CreateStore(llvm::Constant::getNullValue(et),
                                    builder.CreateStructGEP(st, dest, idx));
                continue;
            }
            llvm::Value* deep = nullptr;
            if (isArrayType(ftype)) {
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitArrayDup(builder.CreateLoad(builder.getPtrTy(), srcSlot), elementOf(ftype));
            } else if (isClassValue(ftype) && isCopyDiscipline(ftype)) {
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitClassCopy(ftype, builder.CreateLoad(builder.getPtrTy(), srcSlot), heap);
            } else if (ftype == "String" || ftype == "string") {
                // A String / mutable string field is owned storage like an array is, so the copy needs its
                // own buffer. Sharing it made the two objects' lifetimes depend on each other: whichever
                // died first took the other's text with it (null-safe -- the helper passes null through).
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitStringCopy(builder.CreateLoad(builder.getPtrTy(), srcSlot));
            }
            if (deep != nullptr) {
                builder.CreateStore(deep, builder.CreateStructGEP(st, dest, idx));
            }
        }
        copyChain_.erase(className);
        return dest;
    }

    // Frees the storage a value object owns through its fields -- arrays and heap value sub-objects
    // (recursively) -- WITHOUT freeing the object itself. Used before overwriting an existing object in
    // a value-semantics reassignment (b = a), so the target's old owned copy does not leak. free(null)
    // is a no-op, so array fields need no guard; a value sub-object pointer is null-guarded before the
    // recursion so a not-yet-built field never dereferences null.
    void emitFreeOwnedFields(const std::string& className, llvm::Value* ptr);

    // Free a heap value-struct held in `slot` (a coroutine-state field): its owned fields, then the block
    // itself. Null-guarded, so an unreached declaration (a suspend before the store) frees nothing. Used
    // for the async/gen value-struct locals tracked in scopeValueStructs, which have no destructor.
    void emitFreeValueStructSlot(llvm::Value* slot, const std::string& type);

    // Array memory layout: one heap block [ i64 length | elem 0 | elem 1 | ... ].
    // The array value is a pointer to the length header (element count); elements
    // start `kArrayHeaderBytes` in and are sized by the element type.
    //
    // WHY 8, AND WHY 16 WAS TRIED AND REJECTED -- measured 2026-08-12, both directions.
    //
    // The header is 8 bytes, so elements begin at `malloc + 8`: 8-byte aligned where the allocator
    // had just handed us 16. That misalignment looked like free money. Measured on the competition
    // first: the identical C sieve, changed to allocate `calloc(n+8) + 8` so its data pointer matched
    // ours exactly, slowed GCC from 40.5 ms to 43.3 ms. Seven percent, apparently paid by every array
    // in the language.
    //
    // So the header was widened to 16 and the whole suite stayed green -- and the benchmarks said no:
    //
    //     matrixmul   29.0 ms -> 72.2 ms   (2.5x WORSE)
    //     primes      48.8 ms -> 49.6 ms   (no gain, the thing it was for)
    //     quicksort  224.7 ms -> 221.3 ms  (noise)
    //
    // Reverted. The C probe measured alignment in isolation; the real compiler has a vectorizer whose
    // decisions depend on the whole access pattern, and for matmul the 8-byte header is what it
    // wants. A microbenchmark of one variable predicted the wrong sign of a 2.5x effect -- which is
    // the reason this is a comment and not a commit.
    //
    // Every site that computes an array block's SIZE or its data OFFSET goes through this constant --
    // there are nine, and they are the whole contract, so changing it again is a one-line experiment.
    // Adding a tenth site that spells the number itself is not a red test, it is a silent
    // off-by-eight into somebody's elements.
    static constexpr std::uint64_t kArrayHeaderBytes = 8;
    llvm::Value* arrayData(llvm::Value* block);

    // A condition as the `i1` a branch actually wants, without the round trip through i32.
    //
    // A `boolean` in Polaron is an i32, so a comparison is emitted as `icmp` then `zext i1 to i32`, and
    // every branch then asks `!= 0`: THREE instructions where one would do, on every `if`, `while`
    // and `for` in the program. InstCombine folds it -- eventually -- but "eventually" means every
    // pass before it carries the extra pair, and compile time is half of what this language promises.
    // When the value is exactly that zext, the i1 underneath is already the answer.
    llvm::Value* asI1(llvm::Value* v);
    // A VALUE AGGREGATE stored in an array sits INLINE, at its own size and stride -- it is not a
    // reference. `classes.count(t) > 0` alone answers "user type", which for a class means a pointer
    // and for a `struct` means the struct itself; conflating the two allocated 8 bytes a slot, stored
    // nothing in them, and made the first field read dereference the null the zero-init left behind.
    // The fauna model is an array of value structs by design ("no allocation per animal, ever"), so
    // this is the difference between the language having that shape and only appearing to.
    llvm::StructType* inlineElemStructTy(const std::string& elemType);
    // A boolean array element occupies 1 byte (i8), though a boolean *value* stays i32. Every other
    // element stores at its natural width. The byte size (allocation/stride) and the LLVM storage type
    // (load/store) MUST agree or indexing corrupts memory. char stays i32 -- a 32-bit Unicode scalar.
    unsigned arrayElemBytes(const std::string& elemType);
    llvm::Type* arrayStorageTy(const std::string& elemType);

    llvm::Value* arrayElemPtr(llvm::Value* block, llvm::Value* index, llvm::Type* elemTy,
                              bool checked = true) {
        llvm::Value* idx = index->getType()->isIntegerTy(64)
                               ? index
                               : builder.CreateSExt(index, builder.getInt64Ty());
        // Bounds check (no UB): one unsigned compare catches both index < 0 and index >= length.
        // The length load and data base are loop-invariant, so LICM hoists them; LLVM elides the
        // compare itself where it can prove the index in range. `checked` is false only for accesses the
        // bounds-check hoisting pass has proven in-range under a guard it already emitted (loop
        // versioning), so the check is skipped without ever admitting an unchecked access to user code.
        if (checked) {
            // AN ARRAY ALWAYS HAS ITS HEADER, so the length load below cannot fault -- and saying so
            // is what lets LICM lift it out of a loop whose body is not guaranteed to execute.
            // "Loop-invariant" was never the missing half: in `HashMap.slotFor`'s probe loop the
            // length was reloaded every iteration, because the loop can exit before the body and a
            // load that might fault cannot be moved above the test.
            //
            // The claim goes on whatever produced the POINTER (`!dereferenceable` describes the value
            // a load yields, so it belongs on the field load, not on the i64 read from it). When the
            // block came from somewhere else -- an argument, a fresh allocation -- there is nothing
            // to annotate and nothing is lost.
            //
            // Deliberately NOT `!invariant.load`, which would be a stronger and unsafe claim:
            // `resize` reallocs an array and writes a new length. In LLVM's model realloc returns
            // fresh provenance, so it would probably be sound -- "probably" being exactly the wrong
            // word for a promise whose violation is silent bad code.
            if (auto* blockLoad = llvm::dyn_cast<llvm::LoadInst>(block)) {
                blockLoad->setMetadata(llvm::LLVMContext::MD_nonnull,
                                       llvm::MDNode::get(context, {}));
                blockLoad->setMetadata(
                    llvm::LLVMContext::MD_dereferenceable,
                    llvm::MDNode::get(context, llvm::ConstantAsMetadata::get(
                                                   builder.getInt64(kArrayHeaderBytes))));
            }
            llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), block, "arr.len");
            llvm::Value* oob = builder.CreateICmpUGE(idx, len, "arr.oob");
            llvm::Function* f = currentFn;
            auto* badBB = llvm::BasicBlock::Create(context, "idx.bad", f);
            auto* okBB = llvm::BasicBlock::Create(context, "idx.ok", f);
            builder.CreateCondBr(oob, badBB, okBB, coldBranchWeights());
            builder.SetInsertPoint(badBB);
            emitGuardFail("array index out of bounds", "index", idx, "length", len, 70);
            builder.SetInsertPoint(okBB);
        }
        // ONE GEP, not two: fold the header into the byte offset and index the block once, rather
        // than `arrayData(block)` (block + header) indexed again by `idx`.
        //
        // HONEST NOTE ON WHY, because this was written to fix something and did not. In
        // `performance tests/primes.pol` LLVM's loop-strength reduction folds the loop's STARTING
        // index into the base pointer and rebases the counter at zero, so every iteration pays a
        // `leaq` to reconstruct the index the exit test compares -- five instructions in the hot loop
        // where clang, given the same loop from C, emits four. The two-level GEP was the suspect.
        // Measured after the change: the `leaq` is STILL THERE, so that was not the cause. What the
        // single GEP did buy is small and real (primes 50.5 -> 48.6 ms, matmul and binarytrees
        // unchanged), so it stays -- but the 19% deficit against GCC on that benchmark is still
        // unexplained, and the next person should not re-suspect this line.
        // INBOUNDS, and it is earned rather than asserted: either the check above just proved the
        // index in range, or the bounds-check hoisting pass proved it under a guard it emitted. So
        // the address provably stays inside the block, which is exactly what `inbounds` promises.
        //
        // It is real information we were withholding: diffing our optimized module against clang's
        // for the same sieve loop, the ONLY difference in the hot block was this keyword -- clang
        // emits `getelementptr inbounds nuw`, we emitted a bare one.
        //
        // HONEST NOTE: that made it the prime suspect for the `leaq` that loop pays every iteration
        // (five instructions where clang emits four, the whole ~20% deficit against GCC on that
        // benchmark). Measured after the change: the `leaq` is STILL THERE. So `inbounds` was not the
        // cause. It stays because it is true and worth telling the optimizer, not because it fixed
        // that -- and the next person should not re-suspect this line.
        // Indexed FROM `arrayData(block)`, not from `block` with the header folded into the offset.
        // Both spell the same address, but only this one keeps `inbounds`: the array's zero-init
        // memset already computes `block + header` and names it, so GVN reuses that value as the
        // loop's base -- and a `block + (header + idx)` GEP gets REASSOCIATED into `(block+header) +
        // idx` to match it, dropping `inbounds` on the way. Emitting the same shape the memset does
        // means there is nothing to reassociate and the flag survives to the backend.
        //
        // VERIFIED: the optimized IR for the sieve's hot loop is now byte-for-byte the shape clang
        // produces from the equivalent C -- `getelementptr inbounds nuw i8`, same phi, same
        // `add nuw nsw`, same `icmp samesign`. The `leaq` that loop pays every iteration is STILL
        // there, so this was not its cause either (nor was the bounds-check versioning: ablated with
        // POLARON_NO_HOIST_BOUNDS=1, the `leaq` survives that too). Identical loop-body IR, different
        // assembly -- whatever LSR is reacting to lives outside this basic block. Kept because the
        // flag is true and worth telling the optimizer; do not re-suspect this line.
        return builder.CreateInBoundsGEP(elemTy, arrayData(block), idx, "arr.elem");
    }

    // String RAII: free every element of a String[] before its backing block is freed. Each element is
    // an owned copy (copy-on-store), so it must be released or it leaks; a null slot (new String[n]()
    // zero-init, or a hole past an ArrayList's size) is skipped by the null-safe __polaron_str_free. The
    // slot is nulled after freeing, so a re-delete of the same array finds nothing to free again. Loops
    // over the whole capacity (the array's i64 length header) -- copy-on-store keeps every live element
    // a distinct buffer, so no two slots alias and nothing is freed twice.
    void emitFreeOwnedArrayElements(llvm::Value* block, const std::string& elemType);
    bool arrayOwnsElements(const std::string& elemType);

    // Signed +/-/* with a trap on overflow (spec 3.6): the with.overflow intrinsic yields {result, ovf},
    // and a cold branch to a deterministic panic -- like the bounds and division checks, not a catchable
    // exception, so the hot path stays a single straight-line op and no invoke is introduced -- fires only
    // on overflow. LLVM elides the whole check where it can prove the operation cannot overflow (loop
    // counters, small constants). Unsigned arithmetic and freestanding mode never reach here (they wrap).
    llvm::Value* emitCheckedIntArith(const std::string& op, llvm::Value* l, llvm::Value* r,
                                     bool uns = false) {
        llvm::Value* res = nullptr;
        llvm::Value* ovf = nullptr;
        if (op == "*") {
            // Multiply: the intrinsic is the practical detector (a manual check needs a wider multiply).
            // Multiplies are rarer than add/sub in hot arithmetic, so the intrinsic's cost is localized.
            llvm::Value* pair = builder.CreateBinaryIntrinsic(
                uns ? llvm::Intrinsic::umul_with_overflow : llvm::Intrinsic::smul_with_overflow, l, r);
            res = builder.CreateExtractValue(pair, 0, "ovf.res");
            ovf = builder.CreateExtractValue(pair, 1, "ovf.bit");
        } else if (uns) {
            // Unsigned add/sub: overflow is a carry or a borrow, and each is one comparison against an
            // operand -- cheaper than the signed sign-juggling below and exactly as exact.
            if (op == "+") {
                res = builder.CreateAdd(l, r, "usum");
                ovf = builder.CreateICmpULT(res, l);      // wrapped past the top
            } else {
                res = builder.CreateSub(l, r, "udif");
                ovf = builder.CreateICmpULT(l, r);        // would go below zero
            }
        } else {
            // Add/sub: compute the plain wrapping result -- which inlines and vectorizes exactly like any
            // arithmetic (no intrinsic call to block the recursive-inline / loop optimizers) -- then read
            // overflow from the operand and result signs.
            llvm::Value* zero = llvm::ConstantInt::get(l->getType(), 0);
            if (op == "+") {
                res = builder.CreateAdd(l, r, "sum");  // overflow iff l,r share a sign that res lacks
                llvm::Value* t = builder.CreateAnd(builder.CreateXor(l, res), builder.CreateXor(r, res));
                ovf = builder.CreateICmpSLT(t, zero);
            } else {
                res = builder.CreateSub(l, r, "dif");  // overflow iff l,r differ in sign and res differs from l
                llvm::Value* t = builder.CreateAnd(builder.CreateXor(l, r), builder.CreateXor(l, res));
                ovf = builder.CreateICmpSLT(t, zero);
            }
        }
        llvm::Function* f = currentFn;
        auto* badBB = llvm::BasicBlock::Create(context, "ovf.bad", f);
        auto* okBB = llvm::BasicBlock::Create(context, "ovf.ok", f);
        builder.CreateCondBr(ovf, badBB, okBB, coldBranchWeights());
        builder.SetInsertPoint(badBB);
        emitArithFault("OverflowException", "integer overflow");
        builder.SetInsertPoint(okBB);
        return res;
    }

    // Saturating arithmetic (spec 3.6): clamp to the type's min/max on overflow instead of wrapping.
    // Add/sub have direct intrinsics; multiply detects overflow and clamps by the operand signs.
    llvm::Value* emitSaturatingArith(const std::string& m, llvm::Value* a, llvm::Value* b, bool uns);

    // Branch weights marking the true (panic) edge as cold, so the optimizer keeps the hot
    // path straight-line and the predictor assumes in-bounds.
    llvm::MDNode* coldBranchWeights();

    llvm::Value* emitNewArray(const ast::NewArrayExpr& na);

    // Builds the String[] handed to main(string[] args) from the process argv, skipping argv[0] (the
    // program name). Matches the array layout [i64 length][String* elements]; each String points at the
    // argv string (NUL-terminated, valid for the whole run).
    llvm::Value* emitArgvArray(llvm::Value* argc, llvm::Value* argv);

    // `[a, b, c]` (spec 25): allocate an array block of n elements and store each. Same layout as
    // emitNewArray ([i64 length][elements]); stores bypass the bounds check (indices are known).
    llvm::Value* emitArrayLiteral(const ast::ArrayLiteralExpr& al);

    llvm::Value* createEntryAlloca(const std::string& name, llvm::Type* type);
    // Null out a stack-object's pointer slot in the entry block, right after its alloca, so it dominates
    // every path. A construction that a runtime control-flow keyword skips (abstainfrom past the decl, or
    // a goto/comefrom into the middle of the block) then leaves the slot null instead of garbage, and the
    // null-guarded scope-exit destructor skips it -- no destructor on unconstructed memory (no-UB).
    void zeroStackObjectSlot(llvm::Value* slot);
    // Run a tracked stack object's destructor only if its slot is live (non-null). Paired with
    // zeroStackObjectSlot: a construction skipped by a control-flow keyword leaves the slot null, so the
    // scope-exit teardown must not destruct it. The optimizer folds the check away when the object is
    // provably constructed (the common case, no abstain/skip in the function).
    // dtor may be null (a class with no user destructor but weak state to tear down); weakClass, when
    // non-empty, runs emitWeakCleanup for it inside the same live branch (null every weak ref to a dying
    // stack/region target, unlink a dying holder's slots) -- so `weak T*` is nulled at RAII scope exit too,
    // not only on heap `delete`.
    void emitDtorIfLive(llvm::Value* objPtr, llvm::FunctionCallee dtor,
                        const std::string& weakClass = "") {
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* callBB = llvm::BasicBlock::Create(context, "dtor.live", fn);
        llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "dtor.done", fn);
        builder.CreateCondBr(
            builder.CreateICmpNE(objPtr, llvm::ConstantPointerNull::get(builder.getPtrTy())), callBB,
            contBB);
        builder.SetInsertPoint(callBB);
        if (dtor) {
            builder.CreateCall(dtor, {objPtr});
        }
        if (!weakClass.empty()) {
            emitWeakCleanup(objPtr, weakClass);
        }
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
    }

    // Pointer to the struct of an object expression (`this` or a class variable).
    // If `mem` is a static-field reference `ClassName.field` (the receiver names a
    // class, not a local), returns its mangled key "Class.field"; otherwise "".
    std::string staticFieldKey(const ast::MemberExpr& mem);

    // -- Keyed persistents (docs/design/persistent-keys.md) --------------------------------------------
    // A persistent belongs to the IDENTITY of the object that declares it, not to the source location
    // that happened to bind one. The identity is the class's key fields SERIALISED TO BYTES -- bytes
    // because the registry outlives the object that supplied the key, so anything holding a pointer
    // would dangle, and a stored copy would still dangle through its own pointer fields (a Polaron copy is
    // one level deep). The hash picks a bucket; the bytes decide the match, so two identities never merge.
    //
    // Cost lands entirely on ATTACH -- once per identity, at construction. Reading a persistent field
    // afterwards is a plain load through the block pointer, exactly as before.
    std::set<std::string> valueTypeNames_;
    bool valueTypeNamesBuilt_ = false;
    const std::set<std::string>& valueTypeNames();
    // A class's key fields in DECLARATION ORDER -- order is part of the encoding, which is what makes a
    // key stable and comparable at all. Persistent fields are excluded: a key cannot include the state it
    // keys. An empty result means the class has no identity to key on, so its persistents keep the older
    // (scope, name, region) form and nothing about them changes.
    std::vector<const ast::FieldDecl*> keyFieldsOf(const std::string& cn);
    // Byte width of a fixed-width key field, and 0 for a String (whose width is only known at runtime).
    unsigned keyScalarBytes(const std::string& t);
    // Running size of a class's key: the fixed part folded at compile time, plus 8 + length for each
    // String. Two String fields cannot be confused with one longer one, because each carries its length.
    llvm::Value* emitKeySize(const std::string& cn, llvm::Value* obj);
    llvm::Value* keyFieldPtr(const std::string& cn, llvm::Value* obj, const ast::FieldDecl* f);
    llvm::Value* loadKeyField(const std::string& cn, llvm::Value* obj, const ast::FieldDecl* f);
    // Writes the key into `buf` starting at `*offSlot`, advancing it. Recursive for nested value types.
    void emitKeyWrite(const std::string& cn, llvm::Value* obj, llvm::Value* buf, llvm::Value* offSlot);
    // The whole thing: {bytes, length}, in a stack buffer sized at runtime. Nothing reaches the heap on
    // this side -- the registry makes the single owned copy it keeps.
    std::pair<llvm::Value*, llvm::Value*> emitKeyBytes(const std::string& cn, llvm::Value* obj);

    // The in-process persistent block for an identity key (one per variable that binds a
    // persistent-bearing object). A private global, created lazily; survives delete within a run.
    llvm::GlobalVariable* getPersistBlock(const std::string& key, llvm::StructType* blockTy);

    // Object reattach (spec 18.2): address of a persistent instance field, reached through the
    // object's __persist pointer -- so this.field (in methods/ctor) and var.field both work, and
    // the field survives `delete` (it lives in the block, not the object). Null if `mem` is not
    // a persistent instance field access.
    llvm::Value* persistentFieldPtr(const ast::MemberExpr& mem);

    llvm::FunctionCallee lazyLockFn();
    llvm::FunctionCallee lazyUnlockFn();

    // Runs a lazy local's deferred initializer the first time it is read (spec 37.3). Thread-safe
    // by default via double-checked locking: the fast path is a plain flag read, and only the first
    // initialization takes the process-wide lazy lock and rechecks, so concurrent first-accesses
    // initialize exactly once. A no-op for non-lazy locals.
    void ensureLazy(llvm::Value* flag, const ast::Expr* init, llvm::Value* storage,
                    const std::string& type, const std::string& name) {
        if (flag == nullptr || init == nullptr) {
            return;
        }
        llvm::Function* fn = currentFn;
        llvm::BasicBlock* lockBB = llvm::BasicBlock::Create(context, name + ".lazy.lock", fn);
        llvm::BasicBlock* initBB = llvm::BasicBlock::Create(context, name + ".lazy.init", fn);
        llvm::BasicBlock* unlockBB = llvm::BasicBlock::Create(context, name + ".lazy.unlock", fn);
        llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, name + ".lazy.done", fn);
        // Fast path: already initialized -> skip the lock entirely.
        llvm::Value* done = builder.CreateLoad(builder.getInt1Ty(), flag, name + ".lazy.set");
        builder.CreateCondBr(done, doneBB, lockBB);
        // Slow path: take the lock and recheck the flag (another thread may have won the race).
        builder.SetInsertPoint(lockBB);
        builder.CreateCall(lazyLockFn(), {});
        llvm::Value* done2 = builder.CreateLoad(builder.getInt1Ty(), flag, name + ".lazy.set2");
        builder.CreateCondBr(done2, unlockBB, initBB);
        builder.SetInsertPoint(initBB);
        if (llvm::Value* initV = emitExpr(*init); initV != nullptr) {
            if (isClassValue(type) && isCopyDiscipline(type) && isCopyableLValue(*init)) {
                initV = emitClassCopy(type, initV);
            }
            initV = coerce(initV, typeName(*init), type);
            builder.CreateStore(initV, storage);
        }
        builder.CreateStore(builder.getInt1(true), flag);
        builder.CreateBr(unlockBB);
        builder.SetInsertPoint(unlockBB);
        builder.CreateCall(lazyUnlockFn(), {});
        builder.CreateBr(doneBB);
        builder.SetInsertPoint(doneBB);
    }

    // Resolves the receiver object pointer for a member/method access. When the receiver is a nullable
    // reference (spec 3.7) and the access actually dereferences it (field/method/assignment, i.e.
    // derefCheck), a null receiver traps deterministically with a message rather than segfaulting on a
    // read through address 0. `&x` (address-of) does not dereference, so it opts out. Non-nullable
    // receivers pay nothing -- the check is emitted only for a nullable reference type.
    llvm::Value* emitObjectPtr(const ast::Expr& expr, bool derefCheck = true) {
        llvm::Value* ptr = emitObjectPtrRaw(expr);
        if (ptr != nullptr && derefCheck) {
            const std::string t = typeName(expr);
            if (ast::typeIsNullable(t) && !isBoxablePrimitive(ast::stripNullable(t))) {
                emitNullReceiverCheck(ptr);
            }
        }
        return ptr;
    }
    void emitNullReceiverCheck(llvm::Value* ptr);
    llvm::Value* emitObjectPtrRaw(const ast::Expr& expr);

    // Address (pointer) of an assignable expression.
    llvm::Value* emitLValue(const ast::Expr& expr);

    // The String object layout: { i64 length, ptr data }. Lazily created.
    llvm::StructType* stringType();

    // Materializes an immutable String object as a private global { length, data },
    // where data points to a null-terminated byte array. Returns a ptr to the object.
    // b"...": the bytes themselves as a private constant, yielding `byte*`. NUL-terminated so C-shaped
    // consumers (and our own scanners) can find the end without carrying a length alongside.
    llvm::Value* emitBytesLiteral(const std::string& bytes);

    llvm::Value* emitStringObject(const std::string& bytes);

    // Loads the null-terminated byte pointer (data) of a String object, for libc interop.
    llvm::Value* stringData(llvm::Value* strObj);
    // Concatenates two String/string values into a fresh String: the basis of the + operator and the
    // concat method (spec 4).
    llvm::Value* emitStringConcat(llvm::Value* a, llvm::Value* b);
    // If `e` is a String/string value, lowers it to its libc byte pointer (for %s); else
    // returns the value unchanged.
    llvm::Value* asCStr(const ast::Expr& e, llvm::Value* v);

    // Runtime String RAII helpers (a single call, so codegen never splits a block to null-check).
    llvm::FunctionCallee strCopyFn();
    llvm::FunctionCallee strFreeFn();
    // Deep-copy a String into a fresh, fully-owned one (null-safe). Emitted on every String store so the
    // destination owns its own buffer and no live String is ever aliased.
    llvm::Value* emitStringCopy(llvm::Value* v);
    // Record a freshly-owned String temporary to free at the statement boundary.
    void trackStringTemp(llvm::Value* v);
    // Wrap a fresh-malloc String producer: track it as an owned temporary, then return it unchanged.
    llvm::Value* ownedStr(llvm::Value* v) { trackStringTemp(v); return v; }
    // At a statement boundary: free the owned temporaries created in the CURRENT block (they dominate the
    // free point) and clear the list. Temporaries from a conditional arm (a different block) are dropped,
    // never freed unsafely. A no-op when empty, so code without String temporaries pays nothing.
    void freeStringTemps();
    // Free the owned String temporaries created since `from` (a ternary/expression arm's own temps) that
    // live in the current block, and forget them. Used when an arm's value has just been copied into an
    // owned result, so the arm's producer temp (e.g. a substring in `cond ? a : b.substring()`) is freed
    // here rather than being dropped at the merge -- where freeStringTemps only sees the merge block.
    void releaseArmStringTemps(std::size_t from);
    // True if `slot` is a String local we own (tracked for scope-exit release) -- so reassigning it may
    // free the previous copy. A parameter slot or an untracked variable is left alone.
    bool isTrackedStringSlot(llvm::Value* slot);
    // String RAII stage 2: true iff this call resolves to a user-defined method (or enum/catalog
    // method) whose declared return type is String. Every user method copy-on-returns (see the return
    // path), so its result is a freshly-owned String -- safe to register as a temporary and free at the
    // statement boundary. Builtins never match here: their receiver is not a user class/enum, so the
    // borrowed-String builtins (`.toString()` identity on a String, Env/Net cstr wrappers) and the
    // self-tracking String producers (concat/substring/...) are excluded and never double-freed.
    bool callReturnsOwnedUserString(const ast::CallExpr& call);

    // The reflection Type token layout (spec 31): { ptr name, i64 methodCount,
    // ptr methodNames, ptr methodFns, i64 fieldCount, ptr fieldNames }. methodFns is a
    // parallel array of function pointers, one per method (for Method.invoke). The name
    // arrays are globals of String pointers. Lazily created.
    llvm::StructType* typeTokenType();
    // The reflection Annotation token layout: { ptr name }. Lazily created.
    llvm::StructType* annotationTokenType();
    // The reflection Method token layout: { ptr name, ptr fn, i64 annCount, ptr annNames(String[]),
    // i64 retTag }. retTag encodes the return type for invoke (see returnTag): 0=void, 1=i32, 2=i64,
    // 3=f64, 4=f32, 5=pointer. The annotation slots let a Method report its applied annotations (spec
    // 31). Lazily created.
    llvm::StructType* methodTokenType();
    // Encodes a method's return type as a tag for reflective invoke (Method token field 4). Distinct
    // widths get distinct tags so the call uses the correct ABI (no-UB): 0=void, 1=i32, 2=i64, 3=f64,
    // 4=f32, 5=pointer, 6=i8, 7=i16.
    long long returnTag(const std::string& rt);
    // The boxed-primitive type name for a return tag (for emitBox); "" means a pointer/void (no box).
    std::string tagBoxType(long long tag);
    // The LLVM return type for a return tag.
    llvm::Type* tagRetType(long long tag);
    // The reflection Field token layout: { ptr name, ptr getFn, ptr setFn }. The accessors box/unbox
    // the field value, so get/set work through Object (spec 31). Lazily created.
    llvm::StructType* fieldTokenType();
    // An applied annotation's arguments as text (`min=1,max=10`), for the reflection tokens.
    std::string renderAnnotationArgs(const ast::AnnotationUse& a);
    // Builds a global array of String pointers from a list of names; returns {count, arrayPtr}.
    std::pair<llvm::Constant*, llvm::Constant*> nameArray(const std::vector<std::string>& names,
                                                          const std::string& tag) {
        std::vector<llvm::Constant*> ptrs;
        for (const std::string& n : names) {
            ptrs.push_back(llvm::cast<llvm::Constant>(emitStringObject(n)));
        }
        llvm::ArrayType* arrTy = llvm::ArrayType::get(builder.getPtrTy(), ptrs.size());
        auto* arrG = new llvm::GlobalVariable(module, arrTy, /*isConstant=*/true,
                                              llvm::GlobalValue::PrivateLinkage,
                                              llvm::ConstantArray::get(arrTy, ptrs), tag);
        return {builder.getInt64(names.size()), arrG};
    }
    // AN `ArrayList<Annotation>` FROM {count, names, args}. Written once and used by both
    // `Method.annotations()` and `Field.annotations()`: the two differ only in which token slots the
    // three arrays come from, and a second copy of a loop that builds tokens is how one of them ends
    // up filling a slot the other forgot.
    llvm::Value* emitAnnotationList(llvm::Value* count, llvm::Value* names, llvm::Value* args,
                                    SourceLocation loc) {
        const std::string listCls = "ArrayList$Annotation";
        auto clsIt = classes.find(listCls);
        auto ctorIt = functions.find(ctorSym(listCls));
        auto addIt = functions.find(listCls + ".add");
        if (clsIt == classes.end() || ctorIt == functions.end() || addIt == functions.end()) {
            error("internal: ArrayList$Annotation not available for reflection", loc);
            return nullptr;
        }
        llvm::Value* list = builder.CreateCall(mallocFn(), {sizeOf(clsIt->second.type)}, "annlist");
        builder.CreateCall(ctorIt->second, {list});
        llvm::Function* curFn = currentFn;
        llvm::Value* iSlot = createEntryAlloca("ai", builder.getInt64Ty());
        builder.CreateStore(builder.getInt64(0), iSlot);
        auto* hdr = llvm::BasicBlock::Create(context, "ann.hdr", curFn);
        auto* body = llvm::BasicBlock::Create(context, "ann.body", curFn);
        auto* done = llvm::BasicBlock::Create(context, "ann.done", curFn);
        builder.CreateBr(hdr);
        builder.SetInsertPoint(hdr);
        llvm::Value* i = builder.CreateLoad(builder.getInt64Ty(), iSlot, "i");
        builder.CreateCondBr(builder.CreateICmpSLT(i, count), body, done);
        builder.SetInsertPoint(body);
        llvm::Value* nm = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), names, i), "nm");
        llvm::Value* tok = builder.CreateCall(mallocFn(), {sizeOf(annotationTokenType())}, "ann");
        builder.CreateStore(nm, builder.CreateStructGEP(annotationTokenType(), tok, 0));
        llvm::Value* ag = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), args, i), "ag");
        builder.CreateStore(ag, builder.CreateStructGEP(annotationTokenType(), tok, 1));
        builder.CreateCall(addIt->second, {list, tok});
        builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
        builder.CreateBr(hdr);
        builder.SetInsertPoint(done);
        return list;
    }

    // Generates a per-field accessor for reflection get/set (spec 31). The field type is known here,
    // so the getter boxes a primitive (or returns a reference) and the setter unboxes (or stores the
    // reference) with no runtime type dispatch. Returns a function pointer for the Field token.
    llvm::Constant* emitFieldAccessor(const std::string& className, const std::string& fieldName,
                                      bool setter) {
        auto cit = classes.find(className);
        llvm::Constant* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
        if (cit == classes.end()) {
            return nullp;
        }
        auto idxIt = cit->second.fieldIndex.find(fieldName);
        auto tyIt = cit->second.fieldType.find(fieldName);
        if (idxIt == cit->second.fieldIndex.end() || tyIt == cit->second.fieldType.end()) {
            return nullp;
        }
        const unsigned idx = idxIt->second;
        const std::string ft = tyIt->second;
        const bool prim = isBoxablePrimitive(ft);
        llvm::FunctionType* fnTy =
            setter ? llvm::FunctionType::get(builder.getVoidTy(),
                                             {builder.getPtrTy(), builder.getPtrTy()}, false)
                   : llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
        llvm::Function* f = llvm::Function::Create(
            fnTy, llvm::GlobalValue::PrivateLinkage,
            (setter ? "__fset." : "__fget.") + className + "." + fieldName, module);
        llvm::BasicBlock* saved = builder.GetInsertBlock();
        llvm::Function* savedFn = currentFn;
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
        currentFn = f;
        llvm::Value* addr = builder.CreateStructGEP(cit->second.type, f->getArg(0), idx, "f.addr");
        if (setter) {
            llvm::Value* v = f->getArg(1);  // a boxed Object (or a plain reference)
            builder.CreateStore(prim ? emitUnbox(v, ft) : v, addr);
            builder.CreateRetVoid();
        } else {
            llvm::Value* v = builder.CreateLoad(llvmType(ft), addr, "f.val");
            builder.CreateRet(prim ? emitBox(v, ft) : v);
        }
        currentFn = savedFn;
        if (saved != nullptr) {
            builder.SetInsertPoint(saved);
        }
        return f;
    }

    // The Type token for a class (spec 31), one shared global per class, holding its name
    // and its declared method and field names (in declaration order).
    llvm::Value* typeTokenFor(const std::string& className);

    // The enum that implements `catalog` and provides `method` (spec 12.4), or "" if none. The
    // analyzer guarantees a single implementer reaches here, so the first match is unambiguous.
    // A java-style implementer's methods live on its desugared twin class, but the functions
    // table keys them the same way (Enum.method), so both kinds resolve here.
    std::string catalogImplementerEnum(const std::string& catalog, const std::string& method);
    // Every method-carrying enum implementing `catalog`, in a deterministic order (by type id), for
    // multi-implementer dispatch (spec 12.4). Java-style implementers count: their methods are the
    // twin class's methods.
    std::vector<std::string> catalogImplEnums(const std::string& catalog);
    // A catalog is "tagged" (carries a runtime type id alongside its ordinal, lowering to i64) when at
    // least one method-carrying or java-style enum implements it -- i.e. dispatch through it is
    // meaningful, or the implementer's constants are singletons whose ordinal must survive the trip.
    // Value-only catalogs over ordinal enums stay a bare i32 ordinal so existing code is unaffected.
    bool isTaggedCatalog(const std::string& name);

    // Resolves an overloaded literal suffix (spec 17.10 rule 6) to its mangled function key
    // (name$paramType): an exact parameter-type match wins, otherwise the first overload.
    std::string chooseLiteralKey(const std::string& name, const std::string& argType);

    // Emits a capture-free lambda as a C-callable function (spec 26): no environment parameter, so
    // its signature is exactly R(Args) and its address is a raw C function pointer. A capturing
    // lambda is rejected (a C callback has nowhere to carry the environment).
    llvm::Function* emitCallbackFn(const ast::LambdaExpr& lam);

    // Constructs Some<Enum>(ordinal) or None<Enum>() for EnumName.parse() (spec 12.5). parse() is typed
    // as the value Option<Enum> (no star), so build the value form -- a { tag, ordinal } -- to match.
    // ordinal < 0 = None.
    llvm::Value* emitOptionVariant(const std::string& variant, const std::string& en, int ordinal);

    llvm::Value* emitExpr(const ast::Expr& expr);  // out of line in codegen_expr.cpp

    // Short-circuit && / ||: evaluate the right operand only when needed.
    // a && b -> if a then b else false;  a || b -> if a then true else b.
    llvm::Value* emitShortCircuit(const ast::BinaryExpr& bin);

    // cond ? a : b -- evaluates one branch and merges with a phi (spec 6).
    // `obj?.member` / `obj?.method(...)` (spec 3.7): when obj is null the whole access yields null,
    // otherwise the plain access runs. `node` is the member/call expression; `receiver` is obj.
    // The receiver is re-evaluated in the live branch (harmless for the usual variable/field
    // receivers; a call-valued receiver would run twice).
    llvm::Value* emitSafeNav(const ast::Expr& node, const ast::Expr& receiver);

    // `a ?? b` (spec 3.7): yields a when non-null, else b. b is only evaluated when a is null.
    // Operates on reference values (ptr), so the result is a pointer.
    llvm::Value* emitNullCoalesce(const ast::NullCoalesceExpr& nc);

    llvm::Value* emitTernary(const ast::TernaryExpr& t);

    // True when an expression is built ONLY from integer literals and arithmetic on them -- i.e. a
    // constant whose type an "untyped literals adapt to their context" rule could freely choose. It has to
    // be the whole EXPRESSION, not just a bare literal token: `at & (0 - 4096)` is the most common mask
    // idiom in the kernel, and `(0 - 4096)` is a BinaryExpr of two literals, so a rule that only exempted
    // single literals would break exactly the code it was meant to keep working.
    bool isLiteralOnlyExpr(const ast::Expr& e);

    llvm::Value* emitBinary(const ast::BinaryExpr& bin);  // out of line in codegen_expr.cpp

    // The storage slot (address holding the region block pointer) for a region named either by a
    // local or by a `this.field` reference (spec 17: region as a field). Null if unresolved.
    llvm::Value* regionStorageSlot(const std::string& name);

    // An owned region init is `itself.allocate(size)` -- a region we own end to end (data at block+24),
    // as opposed to `itself.at(addr, ...)` (external memory) or `itself.atMultiple({...})` (multi-range).
    static bool isOwnedRegionInit(const ast::Expr* e) {
        const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(e);
        return ri != nullptr && ri->atAddress.get() == nullptr && ri->ranges.empty();
    }

    // Mark `name` as an owned local region and (re)zero its register-promotable bump cursor. Called at
    // each acquire of the region's block (eager decl, lazy first-use, reassignment) so the cursor starts
    // at 0 for the fresh block. The alloca is created once (entry block) and reused across re-acquires.
    void setupOwnedRegionCursor(const std::string& name);

    // Allocate an `objType` object from region variable `name`, dispatching on its flavor (spec 17):
    // bump/stack use the inline bump cursor (a region block is [ i64 used | i64 cap | ptr dataBase | data ];
    // 8-aligned bump -- the untouched fast path); pool/fixedslot serve an individual slot from the runtime
    // free-list via __polaron_region_new so `delete`/`extract` can reclaim it.
    // An object of a known class: its size is the only thing the allocator ever needed.
    llvm::Value* emitRegionAlloc(const std::string& name, llvm::StructType* objType,
                                 SourceLocation loc) {
        return emitRegionAllocBytes(name, sizeOf(objType), loc);
    }

    // Reserve `size` bytes in a region's arena.
    //
    // A region is TYPED -- always, without exception; that is what separates it from a hand-rolled
    // arena, which takes bytes and forgets what they were. The type check does not happen HERE because
    // it has already happened: every path that reaches this has gone through `checkRegionAccepts` in the
    // analyzer, for an object's class or for an array's element type. By the time there is machine code
    // to emit, the only open question is how many bytes to bump, which is why this parameter is a size.
    //
    // Nothing may call this without having asked that question first.
    llvm::Value* emitRegionAllocBytes(const std::string& name, llvm::Value* size,
                                      SourceLocation loc) {
        llvm::Value* slot = regionStorageSlot(name);
        if (slot == nullptr) {
            error("unknown region '" + name + "'", loc);
            return nullptr;
        }
        const std::string flavor = flavorOfRegion(name);
        const bool growable = growableOfRegion(name);
        // An owned local region (not `at address`, not multi-range, not a field) is the hot arena case.
        // Its data begins at block+24 and its `used` header field is write-only (nothing -- runtime
        // release included -- reads it), so we keep the bump cursor in a local i64 alloca (created at the
        // region's acquire, see setupOwnedRegionCursor). mem2reg promotes that alloca to a loop-carried
        // register, so an allocation loop bumps the cursor in a register exactly like a hand-written
        // arena, rather than round-tripping it through the region block every object -- a heap location
        // LLVM cannot register-promote across loop iterations, no matter the aliasing metadata.
        llvm::Value* cursorSlot = nullptr;
        if (name.find('.') == std::string::npos && ownedRegions_.count(name) > 0) {
            auto it = regionCursorSlot_.find(name);
            if (it != regionCursorSlot_.end()) {
                cursorSlot = it->second;
            }
        }
        // `lazy region` (spec 37.3): allocate the backing block the first time an object enters.
        // (Lazy applies to local regions; a field region is allocated in the constructor.)
        if (name.find('.') == std::string::npos && lazyRegions_.count(name) > 0) {
            llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), slot, "lazyrgn");
            llvm::Function* fn = currentFn;
            auto* allocBB = llvm::BasicBlock::Create(context, "lazyrgn.alloc", fn);
            auto* contBB = llvm::BasicBlock::Create(context, "lazyrgn.cont", fn);
            builder.CreateCondBr(
                builder.CreateICmpEQ(cur, llvm::ConstantPointerNull::get(builder.getPtrTy())),
                allocBB, contBB);
            builder.SetInsertPoint(allocBB);
            llvm::Value* blk =
                emitRegionAllocate(lazyRegionSize_[name], lazyRegionAt_[name], flavor, growable);
            if (blk != nullptr) {
                builder.CreateStore(blk, slot);
            }
            if (cursorSlot != nullptr) {
                builder.CreateStore(builder.getInt64(0), cursorSlot);  // fresh block: used = 0
            }
            builder.CreateBr(contBB);
            builder.SetInsertPoint(contBB);
        }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
        // ring: a circular buffer -- the runtime allocates the next slot, evicting (and destructing) the
        // oldest when full. pool/fixedslot serve a reclaimable free-list slot; stack bumps a slot
        // (reclaimed via mark/rollback). All go through the runtime allocator. (After any lazy acquire so
        // the block exists; bump falls through to the inline fast path below.)
        if (isRingFlavor(flavor)) {
            return builder.CreateCall(ringNewFn(), {block, size}, "ring.slot");
        }
        // A growable bump region also serves through the runtime allocator (it chains blocks on overflow),
        // so it leaves the inline cursor fast path -- only fixed bump keeps the byte-identical hot path.
        if (usesRuntimeDesc(flavor) || growable) {
            return builder.CreateCall(regionNewFn(), {block, size}, "rgn.slot");
        }
        llvm::Value* used;
        llvm::Value* dataBase;
        if (cursorSlot != nullptr) {
            used = builder.CreateLoad(builder.getInt64Ty(), cursorSlot, "used");
            dataBase = builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 24, "rgn.data");
        } else {
            // `at address` / field region: the cursor lives in the block header (region+0) and the data
            // base is stored (region+16). Mark the base load invariant so it still hoists out of a loop.
            used = builder.CreateLoad(builder.getInt64Ty(), block, "used");
            auto* db = builder.CreateLoad(
                builder.getPtrTy(),
                builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 16, "rgn.dbase"), "rgn.data");
            db->setMetadata(llvm::LLVMContext::MD_invariant_load, llvm::MDNode::get(context, {}));
            dataBase = db;
        }
        llvm::Value* objPtr = builder.CreateGEP(builder.getInt8Ty(), dataBase, used, "rgn.obj");
        llvm::Value* aligned = builder.CreateAnd(builder.CreateAdd(size, builder.getInt64(7)),
                                                 builder.getInt64(~static_cast<std::uint64_t>(7)));
        llvm::Value* next = builder.CreateAdd(used, aligned, "rgn.next");
        // A FIXED region is full when the next object would end past its capacity, and saying so is not
        // optional. Without this compare, `itself.allocate(64)` accepted four thousand objects and wrote
        // past the block -- silently, exit status 0. That is undefined behaviour of the plainest kind in
        // a language whose whole claim is that it has none, and every other flavor already trapped here
        // (`__polaron_region_new` panics); only the inline bump path did not, because the inline path was
        // written to be fast and the check was never added back.
        //
        // The cost is a load the optimizer hoists (cap is invariant for the region's life), a compare
        // and a never-taken branch -- which is what a hand-written arena pays too, if it checks at all.
        // The alternative is not a faster region, it is a region that corrupts memory.
        auto* capPtr = builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "rgn.cap");
        auto* cap = builder.CreateLoad(builder.getInt64Ty(), capPtr, "cap");
        cap->setMetadata(llvm::LLVMContext::MD_invariant_load, llvm::MDNode::get(context, {}));
        llvm::Function* fn = currentFn;
        auto* fullBB = llvm::BasicBlock::Create(context, "rgn.full", fn);
        auto* okBB = llvm::BasicBlock::Create(context, "rgn.ok", fn);
        builder.CreateCondBr(builder.CreateICmpUGT(next, cap, "rgn.over"), fullBB, okBB);
        builder.SetInsertPoint(fullBB);
        emitPanic("region out of memory: this fixed region is full -- give itself.allocate a bigger "
                  "size, release it and take it again, or make it a `growable` region");
        builder.SetInsertPoint(okBB);
        builder.CreateStore(next, cursorSlot != nullptr ? cursorSlot : block);  // bump
        return objPtr;
    }

    // Allocate a `className` object in a multi-range region (spec 17.4): pick the range whose
    // accepts/rejects matches the type at compile time, then bump-allocate at that range's fixed
    // address using its per-range used-counter.
    llvm::Value* emitMultiRegionAlloc(const std::string& region, const std::string& className,
                                      llvm::StructType* objType, SourceLocation loc) {
        const std::vector<ast::RegionInitExpr::Range>& ranges = *multiRegionRanges_[region];
        const std::vector<llvm::Value*>& useds = multiRegionUsed_[region];
        int idx = -1;
        for (std::size_t i = 0; i < ranges.size(); ++i) {
            bool ok;
            if (!ranges[i].accepts.empty()) {  // accepts-list: T must be one of them (or a subtype)
                ok = false;
                for (const std::string& a : ranges[i].accepts) {
                    if (classIsSubtypeOf(className, baseType(a))) { ok = true; break; }
                }
            } else {  // rejects-only (or open): accept unless T is rejected
                ok = true;
                for (const std::string& rj : ranges[i].rejects) {
                    if (classIsSubtypeOf(className, baseType(rj))) { ok = false; break; }
                }
            }
            if (ok) { idx = static_cast<int>(i); break; }
        }
        if (idx < 0) {
            error("no range in this region accepts a '" + className + "' (spec 17.4)", loc);
            return nullptr;
        }
        llvm::Value* addr = emitExpr(*ranges[idx].address);
        if (addr == nullptr) {
            return nullptr;
        }
        llvm::Value* base = builder.CreateIntCast(addr, builder.getInt64Ty(), false);
        llvm::Value* used = builder.CreateLoad(builder.getInt64Ty(), useds[idx], "mr.used");
        llvm::Value* objAddr = builder.CreateAdd(base, used);
        llvm::Value* aligned = builder.CreateAnd(builder.CreateAdd(sizeOf(objType), builder.getInt64(7)),
                                                 builder.getInt64(~static_cast<std::uint64_t>(7)));
        builder.CreateStore(builder.CreateAdd(used, aligned), useds[idx]);  // bump this range
        return builder.CreateIntToPtr(objAddr, builder.getPtrTy(), "mr.obj");
    }

    // itself.allocate(size) / itself.at(addr, size): create a region. The block header is
    // [i64 used][i64 cap][ptr dataBase] (24 bytes). For allocate, dataBase points just past the
    // header in the same malloc'd block; for `at`, the header is malloc'd but dataBase is the fixed
    // address (spec 17.8 / 36.9). `size` is a ByteSize (read .bytes) or a raw byte count;
    // accepts/rejects are compile-time only, so codegen ignores them.
    llvm::Value* emitRegionAllocate(const ast::Expr* sizeExpr, const ast::Expr* atAddr = nullptr,
                                    const std::string& flavor = "", bool growable = false,
                                    bool wantRegistry = false,
                                    const std::string& parentRegion = std::string()) {
        llvm::Value* nbytes = builder.getInt64(0);
        if (sizeExpr != nullptr) {
            llvm::Value* arg = emitExpr(*sizeExpr);
            if (arg == nullptr) {
                return nullptr;
            }
            const std::string at = typeName(*sizeExpr);
            auto cit = classes.find(at);
            if (cit != classes.end() && cit->second.fieldIndex.count("bytes") > 0) {
                llvm::Value* f = builder.CreateStructGEP(cit->second.type, arg,
                                                         cit->second.fieldIndex["bytes"], "bs");
                nbytes = builder.CreateLoad(builder.getInt64Ty(), f, "bytes");
            } else {
                nbytes = fitInt(arg, 64);
            }
        }
        // A flavored (pool/fixedslot/stack/ring) OR growable region, or one that needs a destructor
        // registry: a larger block whose PolaronRegionDesc header (POLARON_REGION_HDR bytes) carries the
        // free-lists / registry / grow chain; the runtime init lays it out. `at address` cannot have any
        // of them -- its data belongs to somebody else, so all it owns is the lean 24-byte header.
        //
        // A plain bump region here (flavorCode 0) keeps the inline cursor: the descriptor's first three
        // fields ARE the lean header, so emitRegionAllocBytes bumps [used] at +0 over [dataBase] at +16
        // exactly as before, and objects still carry no per-slot header. The larger header buys the
        // registry and costs 424 bytes once per region -- not a byte or an instruction per object.
        // A SUB-REGION TAKES ITS BLOCK FROM ITS PARENT. Everything else about it is identical -- the
        // same header, the same init, the same allocation path for objects inside it -- so the only
        // difference is where the bytes come from, which is exactly what `in region outer` says.
        //
        // `__polaron_region_new` is the same primitive `snapshot region W in region B` already used
        // to place a capture inside a region, so nothing new is being asked of the runtime.
        //
        // THROUGH `emitRegionAllocBytes`, NOT through the runtime allocator directly. A plain bump
        // region's block carries the LEAN 24-byte header and is bumped by an inline cursor; only a
        // flavored or growable one has the 448-byte descriptor that `__polaron_region_new` reads.
        // Calling that on a bump parent read the wrong fields and handed back a pointer overlapping
        // live objects -- the durable Dog came back as 32. Asking the same function that serves every
        // `new T in region R` gets the right path for every flavor, and gets it right again the day a
        // new flavor is added.
        auto takeBlock = [&](llvm::Value* total, const char* name) -> llvm::Value* {
            if (parentRegion.empty()) {
                return builder.CreateCall(regionAcquireFn(), {total}, name);
            }
            return emitRegionAllocBytes(parentRegion, total, SourceLocation{});
        };
        if ((usesRuntimeDesc(flavor) || growable || wantRegistry) && atAddr == nullptr) {
            llvm::Value* block =
                takeBlock(builder.CreateAdd(builder.getInt64(kRegionHdr), nbytes), "region");
            if (block == nullptr) {
                return nullptr;
            }
            builder.CreateCall(regionInitFn(),
                               {block, builder.getInt64(flavorCode(flavor)), nbytes,
                                builder.getInt64(growable ? 1 : 0)});
            return block;
        }
        llvm::Value* block;
        llvm::Value* dataBase;
        if (atAddr != nullptr) {
            llvm::Value* addr = emitExpr(*atAddr);
            if (addr == nullptr) {
                return nullptr;
            }
            block = builder.CreateCall(mallocFn(), {builder.getInt64(24)}, "region");
            dataBase = builder.CreateIntToPtr(
                builder.CreateIntCast(addr, builder.getInt64Ty(), false), builder.getPtrTy());
        } else {
            block = takeBlock(builder.CreateAdd(builder.getInt64(24), nbytes), "region");
            if (block == nullptr) {
                return nullptr;
            }
            dataBase = builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 24, "rgn.databegin");
        }
        builder.CreateStore(builder.getInt64(0), block);  // used = 0
        builder.CreateStore(nbytes,
                            builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "rgn.cap"));
        builder.CreateStore(dataBase,
                            builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 16, "rgn.dbase"));
        return block;
    }

    // THE REGION OF A `region class`: one per program, created on first use, alive until exit.
    //
    // Every instance of the class comes from here and the region holds nothing else. That totality is
    // the feature -- it is what would let `unimport` answer "is any A alive?" by asking the region, let
    // every instance be walked linearly, and one day let an `A*` be a 32-bit offset. A single instance
    // born anywhere else closes all three, which is why `new A() on heap` and `new A() in region other`
    // are refused rather than tolerated.
    //
    // `growable pool`: pool because a class-homogeneous region wants a free list and O(1) reuse of a
    // freed slot; growable so the author is not asked to guess a capacity for a program-lifetime store.
    // Created lazily rather than in an initializer, because a bare-metal target runs no static ctors.
    // The FAMILY ROOT of a region class: the topmost class in its chain that is still a region class.
    //
    // `abstract region class AstNode` declares a region shared by everything beneath it, so `Ident` and
    // `Call` must reach the SAME block -- one arena, one lifetime, which is the phase-arena case a
    // single-type region cannot express. A pure region class is its own root.
    // Mark a method's `this` as nonnull + dereferenceable, so LLVM may speculate loads through it.
    // See the definition: this is what lets LICM hoist a field load out of a probe loop.
    void markReceiver(llvm::Function* fn, const std::string& cls, bool isStatic);
    // "Does this target have that feature?" -- reports and answers false when it does not.
    // See the definition for why this is one place rather than a check at each site.
    bool requireTargetFeature(const char* feature, const std::string& what,
                              const SourceLocation& loc);
    std::string regionFamilyRoot(const std::string& cls);

    // The body of an `extern syscall(N)` method: the machine's own instruction, not a call.
    //
    // Linux/x86-64: the number in rax, arguments in rdi, rsi, rdx, r10, r8, r9 (note r10, NOT rcx --
    // the `syscall` instruction destroys rcx and r11, which is why they are clobbered below and why
    // the kernel ABI differs from the ordinary C one at the fourth argument).
    void emitSyscallStub(const std::string& clsName, const ast::MethodDecl& m);
    llvm::Value* classRegionBlock(const std::string& cls);
    // Bump one instance out of the family's arena, as a pointer. `classArenaBase` is the base a narrow
    // `A*` is an offset from -- marked readonly so LLVM folds the repeated call away.
    llvm::Value* classArenaAlloc(const std::string& cls, llvm::Value* size);
    llvm::Value* classArenaBase(const std::string& cls);
    // Whether instances of this class live in the type's own arena. Asked wherever a decision is
    // keyed on WHERE an object is, because a region class takes the default placement ("stack") and
    // then ignores it -- so reading `NewExpr::location` alone answers the wrong question.
    bool livesInClassArena(const std::string& cls) const {
        auto it = classes.find(cls);
        return it != classes.end() && it->second.decl != nullptr && it->second.decl->isRegionClass;
    }
    // The same bump, wrapped in a callable with no arguments, so a caller that only learns the class
    // at RUNTIME can still reach its arena. Reflection's `Type.instantiate()` is that caller: the type
    // token is a value, and `malloc` there put an instance of a region class outside its own region.
    // Returns null for a class that has no arena, which is what the token then stores.
    llvm::Function* classArenaNewFn(const std::string& cls);
    std::unordered_map<std::string, llvm::Function*> arenaNewFns_;
    llvm::Value* emitNew(const ast::NewExpr& nw);  // out of line in codegen_expr.cpp

    // A java-style enum constant: materializes `new EnumName(args)` on the heap.
    // Not yet a true singleton -- each reference rebuilds it; identity is a later
    // refinement (would need a global + eager init).
    // A Java-style enum constant is a singleton (spec 12.2): the instance is built once into a
    // private global on first use and reused after, so `==`/`!=` are correct identity comparisons.
    // The private global caching a Java-style enum constant's singleton (null until first use).
    // Shared by constant materialization and ordinal recovery so both name the same slot.
    llvm::GlobalVariable* enumSingletonGlobal(const std::string& enumName, const std::string& constName);

    // The ordinal (declaration index) of a Java-style enum value at runtime. Each constant is a
    // cached singleton, so identity against each singleton recovers the index -- the basis for
    // ordering comparisons (spec 12.2: enum order is declaration order, like Java's compareTo).
    // Yields -1 for a value that matches no constant (e.g. null), which orders below every constant.
    llvm::Value* emitJavaEnumOrdinal(llvm::Value* v, const std::string& enumName);

    // The inverse of emitJavaEnumOrdinal: the singleton for a Java-style enum ordinal at runtime.
    // Materializes every constant (each is lazily cached behind its own global), then selects by
    // ordinal -- catalog dispatch uses this to turn a tagged ordinal back into the `this` the twin
    // class's method expects (spec 12.4).
    llvm::Value* emitJavaEnumFromOrdinal(const std::string& enumName, llvm::Value* ord);

    llvm::Value* emitEnumConstant(const ast::EnumDecl& en, const std::string& constName);

    // THE LITERAL TEXT OF AN INTERPOLATION IS NOT A FORMAT STRING.
    //
    // Interpolation lowers to printf, and the literal segments between the holes used to be pasted
    // into the format string RAW. A percent sign the programmer wrote as text therefore became a
    // conversion specifier and printf went looking for an argument nobody passed:
    //
    //     $"{a}.{b}% <- expected 1.2%"      printed `1.2<- expected 1.2`   (the "% " was eaten)
    //     $"about to try 100%success"       read a value nobody passed as a char* and FOLLOWED IT
    //                                       -- exit 0xC0000005, ACCESS_VIOLATION
    //
    // An arbitrary-pointer dereference reachable from ordinary source text, in a language whose whole
    // claim is that there is no exploitable undefined behaviour. Every literal segment is escaped, and
    // there is one after the last hole as well as between them.
    static std::string escapePercents(const std::string& s) {
        std::string out;
        out.reserve(s.size());
        for (char c : s) {
            out += c;
            if (c == '%') {
                out += '%';
            }
        }
        return out;
    }

    // Lowers $"lit {e0} lit {e1} ..." to a printf: builds a format string with a
    // specifier per expression (%c for char, %d otherwise) and passes the values.
    llvm::Value* emitInterp(const ast::InterpStringExpr& is, bool addNewline, bool asString = false) {
        std::string fmt;
        std::vector<llvm::Value*> values;
        for (std::size_t i = 0; i < is.exprs.size(); ++i) {
            fmt += escapePercents(resolveEscapes(is.literals[i]));
            // Through the newtype, because every test below is about the REPRESENTATION -- width,
            // signedness, float or not -- and none of those predicates can see a newtype name. Left
            // raw, an id fell to the final `else` and printed with %d whatever it was made of, so a
            // 64-bit one read the wrong half of itself and an unsigned one printed negative.
            const std::string et = repType(typeName(*is.exprs[i]));
            llvm::Value* v = emitExpr(*is.exprs[i]);
            if (v == nullptr) {
                return nullptr;
            }
            // Format specifier (spec 4.1): `{pi:0.00}` -> two decimals. The digits AFTER the dot fix the
            // precision; a specifier with no dot (e.g. `{n:5}`) sets a minimum field width.
            const std::string spec = i < is.formats.size() ? is.formats[i] : std::string();
            if (!spec.empty() && (isFloatType(et) || isIntName(et))) {
                const std::size_t dot = spec.find('.');
                if (dot != std::string::npos) {
                    const std::size_t prec = spec.size() - dot - 1;
                    fmt += "%." + std::to_string(prec) + "f";
                    v = coerce(v, et, "double");   // %f takes a double
                    values.push_back(v);
                    continue;
                }
                if (std::all_of(spec.begin(), spec.end(),
                                [](unsigned char ch) { return std::isdigit(ch) != 0; })) {
                    if (isFloatType(et)) {
                        fmt += "%" + spec + "g";
                        v = coerce(v, et, "double");
                    } else {
                        fmt += "%" + spec + "d";
                        if (v->getType()->isIntegerTy() && v->getType()->getIntegerBitWidth() < 32) {
                            v = builder.CreateSExt(v, builder.getInt32Ty());
                        }
                    }
                    values.push_back(v);
                    continue;
                }
            }
            if (isFloatType(et)) {
                fmt += "%g";
                v = coerce(v, et, "double");  // f64 for the %g vararg
            } else if (et == "boolean") {
                // A BOOLEAN INTERPOLATES AS ITS OWN TWO WORDS, which is the only spelling the
                // language has for it: the literals are `true` and `false`, and `toString()` on one
                // has always answered that way. Interpolation fell through to the integer case
                // below and printed 1 and 0, so the same value had two spellings depending on which
                // way it was printed, and the shorter one was the lossy default.
                //
                // The SELECT picks the text, so exactly one of the two globals is read and nothing
                // branches at runtime -- the same shape `boolean.toString()` lowers to.
                fmt += "%s";
                v = builder.CreateSelect(
                    builder.CreateICmpNE(v, llvm::ConstantInt::get(v->getType(), 0)),
                    emitBytesLiteral("true"), emitBytesLiteral("false"));
            } else if (et == "char") {
                fmt += "%c";
            } else if (et == "String" || et == "string") {
                fmt += "%s";
                v = stringData(v);  // interpolate the bytes, not the object pointer
            } else if (et == "Decimal") {
                fmt += "%s";
                v = stringData(emitDecimalToString(v));  // formatted fixed-point text
            } else if (isUnsigned(et)) {
                if (intBits(et) == 64) {
                    fmt += "%llu";
                } else {
                    fmt += "%u";
                    if (v->getType()->isIntegerTy() && v->getType()->getIntegerBitWidth() < 32) {
                        v = builder.CreateZExt(v, builder.getInt32Ty());  // varargs promotion
                    }
                }
            } else if (javaEnums.count(baseType(et)) > 0) {
                // A java-style enum value is a singleton pointer; print its ordinal so it matches
                // simple/ordinal enums (which already interpolate to their i32 ordinal) instead of
                // the raw pointer bits (spec 12.2/12.5).
                fmt += "%d";
                v = emitJavaEnumOrdinal(v, baseType(et));
            } else if (intBits(et) == 64) {
                fmt += "%lld";
            } else {
                fmt += "%d";
                if (v->getType()->isIntegerTy() && v->getType()->getIntegerBitWidth() < 32) {
                    v = builder.CreateSExt(v, builder.getInt32Ty());  // varargs promotion
                }
            }
            values.push_back(v);
        }
        fmt += escapePercents(resolveEscapes(is.literals.back()));  // the trailing segment too
        // As a String value (spec 4.1): snprintf measures the length, then formats into a fresh
        // buffer, producing a String object instead of printing.
        if (asString) {
            llvm::Value* fmtG = createGlobalStringPtr(builder,fmt, ".ifmt");
            llvm::FunctionType* snTy = llvm::FunctionType::get(
                builder.getInt32Ty(), {builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy()},
                /*isVarArg=*/true);
            llvm::FunctionCallee sn = module.getOrInsertFunction("snprintf", snTy);
            std::vector<llvm::Value*> measure = {
                llvm::ConstantPointerNull::get(builder.getPtrTy()), builder.getInt64(0), fmtG};
            for (llvm::Value* v : values) {
                measure.push_back(v);
            }
            llvm::Value* len = builder.CreateSExt(builder.CreateCall(sn, measure, "ilen"),
                                                  builder.getInt64Ty());
            llvm::Value* cap = builder.CreateAdd(len, builder.getInt64(1));
            llvm::Value* buf = builder.CreateCall(mallocFn(), {cap}, "ibuf");
            std::vector<llvm::Value*> format = {buf, cap, fmtG};
            for (llvm::Value* v : values) {
                format.push_back(v);
            }
            builder.CreateCall(sn, format);
            return ownedStr(emitStringFromParts(len, buf));
        }
        if (addNewline) {
            fmt += "\n";
        }
        std::vector<llvm::Value*> args;
        args.push_back(createGlobalStringPtr(builder,fmt, ".str"));
        for (llvm::Value* v : values) {
            args.push_back(v);
        }
        return builder.CreateCall(printf(), args);
    }

    // One arm of a Channel.select chain (spec 20.4): a `.receive(channel, lambda)` or, when
    // isTimeout, a `.timeout(ms, lambda)`.
    struct SelectCase {
        const ast::Expr* channel;
        const ast::Expr* lambda;
        const ast::Expr* ms;
        bool isTimeout;
    };
    // Walks a `Channel.select().receive(...)....` chain bottom-up, collecting its arms in source
    // order. Returns false if the chain is not a select (so a stray `.run()` is left alone).
    bool collectSelectChain(const ast::Expr* chain, std::vector<SelectCase>& cases);
    // Calls a function<void> / function<void, T> closure value (code+env pair) with an optional arg.
    void emitClosureCallVoid(llvm::Value* closPtr, const std::string& paramType, llvm::Value* arg);
    // SPLIT A TYPE LIST ON ITS TOP-LEVEL COMMAS, AND TRIM EACH PIECE.
    //
    // The trim is the whole reason this exists as one function instead of three copies. `function<double,
    // double>` is how every author and the whole standard library writes it, so the second piece came out
    // as " double" with a leading space -- and `llvmType` compares type names exactly, does not recognise
    // it, and falls through to the default. The parameter then had an INTEGER type in a signature whose
    // argument was a double, and the call site sign-extended a float to fit: `sext double to i32`, which
    // the module verifier refuses outright.
    //
    // It hid because this path is only taken where a `function<>` PARAMETER is called inside a method
    // that specialization did not fold away -- so one such call in a program was fine, and two lambdas of
    // the same shape in two different methods was what made it appear. That reads as a mysterious
    // interaction between unrelated code rather than as a missing trim, which is what it is.
    //
    // `angles` also counts '(' and ')' for funcptr's parameter lists; harmless for the others.
    static std::vector<std::string> splitTypeList(const std::string& inner, bool parens = false) {
        std::vector<std::string> parts;
        int depth = 0;
        std::size_t start = 0;
        for (std::size_t i = 0; i <= inner.size(); i++) {
            if (i == inner.size() || (inner[i] == ',' && depth == 0)) {
                std::string piece = inner.substr(start, i - start);
                const std::size_t a = piece.find_first_not_of(" \t");
                if (a == std::string::npos) {
                    parts.push_back(std::string());
                } else {
                    const std::size_t b = piece.find_last_not_of(" \t");
                    parts.push_back(piece.substr(a, b - a + 1));
                }
                start = i + 1;
            } else if (inner[i] == '<' || (parens && inner[i] == '(')) {
                depth++;
            } else if (inner[i] == '>' || (parens && inner[i] == ')')) {
                depth--;
            }
        }
        return parts;
    }

    // Calls a funcptr<Ret, Args...> value -- a bare C function pointer (dynamic FFI, e.g. a
    // wglGetProcAddress result) -- with the plain C ABI: no closure environment, args passed directly.
    llvm::Value* emitFuncptrCall(const std::string& ft, llvm::Value* fnPtr,
                                 const std::vector<ast::ExprPtr>& callArgs, SourceLocation loc) {
        const std::string raw = ft.substr(8, ft.size() - 9);  // strip "funcptr<" ... ">"
        const llvm::CallingConv::ID cc = worldToCallConv(ast::funcptrWorld(raw), loc);  // [unknown-abi]
        const std::string inner = ast::funcptrBody(raw);      // params/return, minus any leading $world
        std::vector<std::string> parts = splitTypeList(inner, /*parens=*/true);
        std::vector<llvm::Type*> pts;
        for (std::size_t i = 1; i < parts.size(); i++) {
            pts.push_back(llvmType(parts[i]));
        }
        llvm::Type* ret = parts.empty() ? builder.getVoidTy() : llvmType(parts[0]);
        llvm::FunctionType* fty = llvm::FunctionType::get(ret, pts, false);
        std::vector<llvm::Value*> args;
        for (std::size_t i = 0; i < callArgs.size(); ++i) {
            llvm::Value* v = emitExpr(*callArgs[i]);
            if (v == nullptr) {
                return nullptr;
            }
            const std::string pt = (i + 1 < parts.size()) ? parts[i + 1] : std::string();
            if (pt == "string" || pt == "String") {
                v = stringData(v);  // FFI: a String maps to its NUL-terminated C char* data (spec 26)
            } else if (i < pts.size()) {
                v = coerceToType(v, pts[i]);
            }
            args.push_back(v);
        }
        llvm::CallInst* ci = builder.CreateCall(fty, fnPtr, args);  // foreign call; no Polaron exception
        ci->setCallingConv(cc);  // [unknown-abi] the foreign world's ABI (default C for a plain funcptr)
        return ci;
    }
    // Emits a Channel.select as a poll loop: each iteration tries a non-blocking receive on every
    // channel (calling its handler with the value on success), then optionally fires the timeout.
    void emitSelect(const std::vector<SelectCase>& cases);

    // Sum the lanes of a <w x float> vector into a scalar float (used by dot/length).
    llvm::Value* horizontalAddVec(llvm::Value* v, int w);
    // The 3D cross product of two <3 x float> vectors.
    llvm::Value* emitCross3(llvm::Value* a, llvm::Value* b);

    // --- Function specialization over no-capture lambda arguments (see boundLambdas_) ---
    // If argExpr is a known constant lambda -- a no-capture lambda literal (its emitted value is a
    // constant global {code, null} closure) or a bound parameter forwarded transitively -- return its
    // underlying function; else null.
    llvm::Function* knownLambdaFor(const ast::Expr& argExpr, llvm::Value* argValue);
    // Get (or schedule) a specialized copy of `orig` in which the given function<> parameters are the
    // given lambdas. Same signature (the closures are still passed, just bypassed for the call); the body
    // is generated later from the worklist with boundLambdas_ set, so its calls to those params are direct.
    llvm::Function* specializeMethod(const ast::MethodDecl* decl, const std::string& definingClass,
                                     const std::string& method, llvm::Function* orig,
                                     const std::map<int, llvm::Function*>& specParams) {
        std::string key = definingClass + "." + method;
        for (const auto& [idx, fn] : specParams) {
            key += "#" + std::to_string(idx) + "=" + fn->getName().str();
        }
        if (auto it = specCache_.find(key); it != specCache_.end()) {
            return it->second;
        }
        auto* spec = llvm::Function::Create(orig->getFunctionType(), llvm::Function::InternalLinkage,
                                            key + "$fs", module);
        specCache_[key] = spec;
        Specialization req;
        req.fn = spec;
        req.decl = decl;
        req.owner = definingClass;
        req.returnType = typeRefName(decl->returnType);
        for (const auto& [idx, fn] : specParams) {
            if (idx >= 0 && idx < static_cast<int>(decl->params.size())) {
                req.bound[decl->params[idx].name] = fn;
            }
        }
        specWorklist_.push_back(std::move(req));
        return spec;
    }
    // Emit the deferred specialized bodies. Each may schedule more (transitive specialization); the cache
    // terminates the recursion. Run after the normal function pass, before dead-code stripping.
    void emitSpecializations();

    // A mat4 is a <16 x float> in row-major order: element (row, col) lives at index row*4 + col.
    llvm::Value* mat4Zero() { return llvm::ConstantAggregateZero::get(llvmType("mat4")); }
    llvm::Value* mat4Identity();
    llvm::Value* mat4Mul(llvm::Value* a, llvm::Value* b);
    llvm::Value* mat4Transform(llvm::Value* m, llvm::Value* v) {  // m * v -> vec4
        auto me = [&](int i) { return builder.CreateExtractElement(m, builder.getInt32(i)); };
        auto ve = [&](int i) { return builder.CreateExtractElement(v, builder.getInt32(i)); };
        llvm::Value* r = llvm::ConstantAggregateZero::get(llvmType("vec4"));
        for (int i = 0; i < 4; i++) {
            llvm::Value* sum = llvm::ConstantFP::get(builder.getFloatTy(), 0.0);
            for (int k = 0; k < 4; k++) {
                sum = builder.CreateFAdd(sum, builder.CreateFMul(me(i * 4 + k), ve(k)));
            }
            r = builder.CreateInsertElement(r, sum, builder.getInt32(i));
        }
        return r;
    }

    llvm::Value* emitCall(const ast::CallExpr& call);  // out of line in codegen_call.cpp

    // Calls the destructor of every live stack object, in reverse declaration
    // order. Emitted before each `return` and at the function's fall-through end.
    // M4 tracks objects at function scope; per-block RAII comes with nested
    // scopes in a later phase.
    // Runs one pending scope-exit action: a defer block, or a using resource's disposal.
    void emitCleanupAction(const Cleanup& c);
    void emitScopeCleanup();

    // The live-instance counter for a class (spec 32.5 onFirstInstance/onLastInstanceDestroyed),
    // a private global initialized to 0.
    llvm::GlobalVariable* instanceCounter(const std::string& name);

    // The address table the physical-unload helper uses to bound each overwrite by the address of
    // the NEXT piece of code (spec 30).
    //
    // What is in it is METHODS, constructors, destructors, interrupts, procedures and lambdas --
    // everything Polaron emitted as code. Not "functions": in Polaron `function` is a first-class value
    // TYPE, and behaviour lives in types. The `llvm::Function` below is LLVM's word for its own
    // object and stays.
    //
    // Split in two on purpose, and the split is the fix for a real defect: the table used to be
    // built right after `declareFunctions`, when every one of these is still a bodyless
    // declaration, so `!f->isDeclaration()` rejected all of them and the table shipped EMPTY --
    // `__polaron_unload_fn(..., i64 0)` at every call site.
    //
    // An empty table is not an empty effect. The runtime falls back to `len = 64`, a fixed guess,
    // so unimport over-writes 64 bytes of whatever follows: a method SHORTER than that has its
    // neighbour's code clobbered, and that neighbour is something nobody asked to unload. It looked
    // correct because the unimported entry does get its int3 -- the damage is past the end.
    //
    // So the handles are made first (the bodies reference them) and filled last (the addresses only
    // exist once the bodies do). The count travels as a global for the same reason: baking it as an
    // immediate at the call site would freeze the wrong value.
    void declareCodeTable();
    void fillCodeTable();

    // Dead-code elimination for executables: every class method is emitted with external linkage, so
    // the whole prelude (all non-generic stdlib classes) lands in every program's IR even when unused,
    // bloating the .ll and the clang parse. We internalize everything but the C entry point `main`, then
    // run LLVM's GlobalDCE, which reaches transitively from `main` (and from llvm.used, global_ctors, and
    // any address-taken function -- threads/async entries, reflection Method tokens, the unimport address
    // table) and drops the rest. Skipped in library mode, whose public API must stay exported. Generic
    // classes already cost nothing unless monomorphized; this reclaims the non-generic ones.
    // Type-based alias analysis metadata (spec: match C's ability to keep loads in registers). LLVM can't
    // tell that a store to `a.n` (i64 field of one class) doesn't alias a load of `b.field` (ptr field of
    // another) -- so it re-loads a field on every loop iteration and re-runs its null check, the E6 tax.
    // Clang solves this with TBAA; we emit the same, scalar (Clang-style root -> char -> per-type-category).
    // A normal typed class field is always accessed as one type, so two different-category accesses can't be
    // the same memory -- SOUND. We tag only loads/stores whose pointer is a GEP into a known, NON-union
    // class struct; `union` fields (which overlap) and cast/Memory/FFI accesses (raw pointer arithmetic, not
    // a class GEP) are left untagged = conservative. Runs once, after all IR is emitted.
    void attachTBAA();

    // `heap class X` (spec 36): bridge the allocator the program declared to the three symbols the rest of
    // codegen emits (`new ... on heap`, dynamic arrays, `delete`). Without this a freestanding program
    // COMPILES those constructs and then fails to LINK, because there is no libc to supply them -- the one
    // silent gap left in freestanding. The bridge is generated, so the kernel writes ordinary Polaron
    // (`allocate`/`release` on its own class) instead of hand-defining C symbols the compiler happens to
    // call. `checkLive` is optional: an allocator that does not track liveness just gets a no-op guard.
    // The String runtime, GENERATED for freestanding instead of linked.
    //
    // Measured first: a program using `String` needs `__polaron_str_copy`, `__polaron_str_free`,
    // `__polaron_str_index`, `__polaron_malloc` and `memcpy` -- and NOT ONE libc symbol. The hosted
    // implementations of those three are written purely in terms of malloc, free and memcpy, so
    // there is nothing in them a kernel could not have; what was missing was somebody writing them.
    // So codegen writes them, exactly as `emitHeapBridge` writes the allocator bridge from the
    // program's own `heap class`.
    //
    // That closes three things at once: `String` bare metal, the `Test` framework (whose gate was
    // this one wearing a different message), and a REAL BUG -- lowercase `string` was never gated,
    // so `string s = "hello";` compiled in a kernel and then failed at link on these very symbols.
    //
    // The object is { i64 len, ptr data, i64 hash }, which is the layout the hosted runtime uses.
    void emitStringBridge();

    void emitHeapBridge();

    void stripDeadCode();

    // Bare metal has no red zone. Marks every emitted method `noredzone` when the target has no OS.
    //
    // The red zone is the 128 bytes BELOW the stack pointer that the System V AMD64 ABI lets a leaf
    // method use without moving RSP. It is safe in a hosted program because the operating system
    // promises it: the kernel builds a signal frame clear of it. Nothing makes that promise to a
    // freestanding program, and worse, the hardware actively breaks it -- an interrupt taken with no
    // privilege change pushes RIP/CS/RFLAGS/RSP/SS starting AT the stack pointer and going down, which
    // is the red zone, byte for byte. The interrupt stub's own pushes then cover the rest of it.
    //
    // So on bare metal a leaf method's locals are destroyed by any interrupt that arrives while they
    // are live. What that looks like from the outside is not a crash. It is a method that returns a
    // wrong answer, rarely, with no memory anywhere having been written by anything that could be
    // blamed -- because the corrupted value need not be a value at all. In the kernel that found this,
    // the two things spilled below RSP were POINTERS: a `this` and a field address. The interrupt frame
    // replaced them with RFLAGS and the interrupted RSP, and the method then dereferenced those, so it
    // read its answer out of the saved stack and out of low memory. The object it was supposedly
    // reading was never touched. Every heap canary, every DMA redzone and every audit of the object
    // itself came back clean, correctly, for two days.
    //
    // This must be set HERE, on the function, and not by passing `-mno-red-zone` to the compiler that
    // consumes the IR. That flag is a front-end flag: clang applies it while lowering C or C++, by
    // attaching this exact attribute. Handed a .ll file the front end is bypassed, the flag reaches
    // nothing, and LLVM's x86 frame lowering asks only one question -- does the function carry
    // `noredzone`. It silently compiled the flag and silently ignored it. The kernel it produced had
    // 1668 accesses below RSP with the flag on the command line, and the assembly was byte-identical
    // with the flag removed. `-mgeneral-regs-only` on that same command line DOES work, because target
    // features fall back to the subtarget, which is exactly why the gap went unseen for so long.
    //
    // "No OS in the triple" is the condition rather than a build-mode flag, because it is the true one:
    // the red zone is a promise by an operating system, so a target that names none has nobody to make
    // it. A hosted program keeps the red zone and the optimisation it buys.
    void applyBareMetalAttrs();

    // Physically overwrites the machine code of a class's methods (and ctor/dtor) in RAM
    // with int3 traps, via the runtime helper (spec 30 aggressive unload). The code is
    // ripped from memory; the alive guard ensures we never branch into the traps.
    // Calls a runtime code op (__polaron_unload_fn / __polaron_reload_fn) on every method, the
    // constructor, and the destructor of a class -- physically overwriting (unimport) or
    // restoring from disk (reimport) their machine code (spec 30).
    void emitPhysicalCodeOp(const std::string& className, const char* runtimeFn);
    void emitPhysicalUnload(const std::string& cn) { emitPhysicalCodeOp(cn, "__polaron_unload_fn"); }
    void emitPhysicalReload(const std::string& cn) { emitPhysicalCodeOp(cn, "__polaron_reload_fn"); }

    // The trap every slot of an unimported class's table is pointed at: a method that reports the
    // call and stops, one per class so the report can NAME the class. Hosted it throws, so a program
    // can catch it; freestanding it panics, because there is no handler above a kernel to unwind to.
    //
    // It has to be a real method rather than null: a null slot faults at address 0 with nothing to
    // say, and "which class did this belong to" is precisely the question you have at that moment.
    llvm::Function* unimportedTrap(const std::string& cn);

    // Unimport one class (spec 30): run onClassUnload while the code still exists, mark it dead,
    // POISON ITS DISPATCH TABLE, then physically rip its code from RAM.
    //
    // The table is the part that was being left behind, and leaving it behind is not untidiness --
    // it is a hole in the guard. The alive check is emitted from the STATIC type at the call site,
    // so `Shape s = new Dog(); unimport Dog; s.area();` never asks about Dog: the receiver is a
    // Shape, and the call goes through the table straight into code that is now int3. The program
    // executes a breakpoint in the middle of a method instead of being told what it did.
    //
    // Pointing every slot at the class's own trap closes that: a virtual call through a stale object
    // lands somewhere that knows which class it was and says so. This is the "rip the binary out"
    // the feature was always for -- the code AND the table that reaches it.
    void emitUnimportClass(const std::string& cn);

    // The individual types named by an unimport (spec 30.1): the target itself for a plain type, or
    // every class/interface/enum in a namespace (granularity 1) or bundle (granularity 2).
    std::vector<std::string> unimportGroupTargets(const ast::UnimportStmt& u);

    // `cascade unimport X` (spec 37.1): X plus every subclass and every monomorphization (X$args).
    std::vector<std::string> cascadeUnimportTargets(const std::string& x);

    // Emits an `expecting { ... }` block (spec 30.18) inline as an expression: the value its
    // `return` produces is captured into a slot, and the block's end becomes the continuation.
    llvm::Value* emitExpectingValue(const ast::Block* block);

    // Bit-for-bit comparison of two validation values (spec 30.18 rule 4): compares the raw memory
    // representation rather than an operator== overload, to defeat a spoofed equals(). Scalars only;
    // struct/object validation values are a follow-up.
    llvm::Value* emitBitEqual(llvm::Value* a, llvm::Value* b);

    // Constructs and throws a System.Runtime.UnimportedTypeException (spec 30): used when
    // an unimported type is instantiated or its methods are called. Terminates the block.
    // Reaching an unimported type. Hosted this throws, so a program can catch it and carry on;
    // FREESTANDING IT PANICS, through the same `__polaron_panic` a kernel already overrides for
    // contracts and guards.
    //
    // Measured: this one branch was the ONLY thing tying `unimport` to the C++ unwinder. Everything
    // else it needs is ours -- `__polaron_unload_fn`, the allocator -- so routing it here is what makes
    // ripping a driver's code out of a running kernel expressible at all. The `__cxa_*` symbols a
    // kernel cannot link were never about unloading; they were about how the refusal was reported.
    //
    // A panic and not a throw is also the honest semantics bare metal: there is no handler above a
    // kernel to unwind to, and a driver whose code has been ripped is not a recoverable condition.
    void emitThrowUnimported();
    // Constructs and throws a named exception class (it must extend the catchable Exception base, so
    // its constructor installs a vtable that a catch clause can type-match). Used by dynamic-bundle
    // thunks to raise BundleNotLoadedException / BundleAbiMismatchException.
    void emitThrowNamed(const std::string& cn);
    // If `cn` is unimportable, throws UnimportedTypeException when its alive flag is 0,
    // continuing on a fresh block for the live path (spec 30).
    void emitAliveGuard(const std::string& cn);

    // The per-class "alive" flag for unimport (spec 30): a private global i32, 1 = alive.
    llvm::GlobalVariable* aliveFlag(const std::string& name);

    // The runtime reference counter for an abstainable label (spec 7.11), lazily
    // created as a private global initialized to 0 (enabled).
    llvm::GlobalVariable* abstainCounter(const std::string& name);

    // Pre-scan: collect every label named by an `abstainfrom`/`reinstate` anywhere in
    // the program, so only those labels get a runtime guard (spec 7.11).
    void scanAbstained(const ast::Stmt* st);
    // Registers any `unimport X expecting { ... }` validation expression (spec 30.18) reachable in
    // an expression as making X unimportable, so the alive guard is emitted for it.
    void scanExprForUnimport(const ast::Expr* e);
    // Chain top-level labels in source order so each label's abstain region ends at the NEXT top-level
    // label (spec 7.11), not the method end. Labels nested inside control-flow blocks are not chained --
    // their region conservatively runs to the method end (a forward branch into a nested block, past its
    // condition, would be unsafe).
    void scanLabelChainTopLevel(const ast::Block& body);
    // Which `region` fields own their block (and so can carry a destructor registry). Run before any
    // body is emitted -- see FieldRegionKinds for why the answer cannot be discovered while emitting.
    void collectFieldRegionKinds();
    // Every unimportable class is given a destructor if it wrote none, so `unimport`'s live-instance
    // count has a place to come down. Runs after the unimportable set is known; see the call site.
    void markUnimportableDestructors();

    void collectAbstainedLabels();

    // Exits the current function early with the default value for its return type,
    // running finallys and destructors (used by the abstainfrom skip path).
    void emitDefaultReturn();

    // Emits the `finally` blocks of the try regions being left, innermost-out, down to
    // (but not including) finallyStack index `downTo`. Each is a fresh copy because an
    // exit edge has its own predecessor. Used by return/break/continue/try? so finally
    // runs on every structured exit, not only the normal/caught fall-through.
    void emitPendingFinallys(std::size_t downTo);

    // Finds the loop targeted by break/continue: the named loop, or the innermost.
    const LoopTargets* findLoop(const std::string& label);

    // --- Exceptions (spec 21): Windows WinEH via __CxxFrameHandler3. Every Polaron exception is thrown
    // as one canonical carrier -- the object pointer typed void* (PEAX) -- so a single reusable set
    // of EH tables serves all types; catch clauses match on the Polaron runtime type, not on RTTI. ---
    void ensurePersonality();
    llvm::Constant* imageBaseSym();
    // 32-bit image-relative offset of x -- how MSVC EH tables reference their members.
    llvm::Constant* imageRel(llvm::Constant* x);
    void buildEhStructures();
    llvm::Constant* ehThrowInfo() { buildEhStructures(); return ehThrowInfoCache; }
    llvm::Constant* ehTypeDesc() { buildEhStructures(); return ehTypeDescCache; }
    llvm::FunctionCallee cxxThrowFn();

    // --- Itanium / DWARF exceptions (Linux and other ELF/Mach-O targets) ---
    // The same Polaron model as WinEH: one canonical carrier (the object pointer, thrown as void*) and
    // manual, subtype-aware type matching in the handler. On these targets the Windows funclet
    // primitives (catchswitch/catchpad/cleanuppad, image-relative EH tables) do not exist; instead a
    // faulting call is an `invoke` to a `landingpad`, throwing goes through __cxa_throw, and cleanups
    // end in `resume`. Because we match types ourselves, every throw uses one type (void* / _ZTIPv) and
    // every catch is `catch _ZTIPv`, so the C++ personality always routes a Polaron exception into the
    // handler where the real matching happens.
    bool isItaniumEH();
    // typeinfo for void* (_ZTIPv), supplied by the C++ runtime (libstdc++ / libc++abi).
    llvm::Constant* itaniumVoidPtrTypeInfo();
    llvm::FunctionCallee cxaAllocateException();
    llvm::FunctionCallee cxaThrowFn();
    llvm::FunctionCallee cxaBeginCatch();
    llvm::FunctionCallee cxaEndCatch();
    llvm::StructType* landingPadType();

    // Is there anything to run when an exception unwinds out of the current scope? -- a defer/using
    // block, a live region, or a stack object with a destructor. (Region objects are destructed when the
    // region frees, so they don't count on their own.)
    bool hasUnwindCleanup();
    // Like hasUnwindCleanup, but only for entries added since the given bases -- i.e. the teardown a throw
    // must run to unwind out to an enclosing try whose body started at these sizes.
    bool hasUnwindCleanupAbove(std::size_t soBase, std::size_t dfBase, std::size_t rgBase);
    // Runs the full scope teardown -- defer/using blocks (LIFO), then stack-object destructors (reverse
    // declaration order), then region frees -- as ordinary code, mirroring emitScopeCleanup. Used on the
    // unwind path so `defer`/`using`/regions are honoured when an exception propagates (spec 23.1), not
    // only on structured exits. The snapshots are passed in because the caller clears the live vectors
    // first, so a call inside a cleanup action never recursively targets this same cleanup.
    void emitUnwindCleanupBody(const std::vector<ScopeObject>& objs,
                               const std::vector<Cleanup>& defs,
                               const std::vector<RegionLocal>& regs) {
        for (auto it = defs.rbegin(); it != defs.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) {
                return;
            }
            emitCleanupAction(*it);
        }
        for (auto it = objs.rbegin(); it != objs.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) {
                return;
            }
            if (!it->region.empty()) {
                continue;  // destructed with the region
            }
            auto fnit = functions.find(it->className + ".~" + it->className);
            const bool weak = weakRelevant(it->className);
            if (fnit == functions.end() && !weak) {
                continue;
            }
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), it->slot);
            if (fnit != functions.end()) {
                builder.CreateCall(fnit->second, {objPtr});
            }
            if (weak) {
                emitWeakCleanup(objPtr, it->className);  // null/unlink weak refs on unwind too
            }
        }
        if (builder.GetInsertBlock()->getTerminator() == nullptr && !regs.empty()) {
            // freeRegionsFrom reads scopeRegions, and runRegionObjectDtors (which it calls) reads
            // scopeObjects to find each region's objects. On the unwind path both members were cleared
            // into the local snapshots, so restore them here -- otherwise a region's object destructors
            // were skipped while unwinding (they run only on the normal exit).
            std::vector<RegionLocal> savedR = scopeRegions;
            std::vector<ScopeObject> savedO = scopeObjects;
            scopeRegions = regs;
            scopeObjects = objs;
            freeRegionsFrom(0);
            scopeRegions = savedR;
            scopeObjects = savedO;
        }
    }
    // Itanium unwind cleanup: one `landingpad cleanup` block that runs the full scope teardown as
    // ordinary code, then `resume`s to keep unwinding toward the caller. Materialized lazily and mutually
    // exclusive with the normal-path emitScopeCleanup (a landing pad is only reached via unwind).
    llvm::BasicBlock* buildCleanupChainItanium(std::size_t soBase = 0, std::size_t dfBase = 0,
                                               std::size_t rgBase = 0) {
        soBase = std::min(soBase, scopeObjects.size());  // defensive: never form a past-the-end iterator
        dfBase = std::min(dfBase, deferred.size());
        rgBase = std::min(rgBase, scopeRegions.size());
        if (!hasUnwindCleanupAbove(soBase, dfBase, rgBase)) {
            return nullptr;
        }
        llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
        ensurePersonality();
        // Snapshot only the entries added since the bases (the scopes being unwound), and drop them from
        // the live vectors during emission so a cleanup action / re-raise never re-targets this same pad.
        std::vector<ScopeObject> objs(scopeObjects.begin() + soBase, scopeObjects.end());
        std::vector<Cleanup> defs(deferred.begin() + dfBase, deferred.end());
        std::vector<RegionLocal> regs(scopeRegions.begin() + rgBase, scopeRegions.end());
        scopeObjects.resize(soBase);
        deferred.resize(dfBase);
        scopeRegions.resize(rgBase);
        llvm::BasicBlock* pad = llvm::BasicBlock::Create(context, "cleanup", currentFn);
        builder.SetInsertPoint(pad);
        llvm::LandingPadInst* lp = builder.CreateLandingPad(landingPadType(), 0);
        lp->setCleanup(true);
        emitUnwindCleanupBody(objs, defs, regs);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            builder.CreateResume(lp);
        }
        scopeObjects.insert(scopeObjects.end(), objs.begin(), objs.end());  // restore for the normal path
        deferred.insert(deferred.end(), defs.begin(), defs.end());
        scopeRegions.insert(scopeRegions.end(), regs.begin(), regs.end());
        builder.restoreIP(saved);
        return pad;
    }
    // Itanium in-try cleanup (spec 23.1): a throw inside a try body must run the body's block-scoped
    // defers/destructors declared since the try opened, then be handled by that try's clauses -- not skip
    // straight to the handler. A landing pad catches the carrier, runs the bounded teardown as ordinary
    // code, stores the carrier, and branches to the try's clause-matching block (emitTryItanium split its
    // handler so both the direct pad and this cleanup pad feed the same dispatch). Only the entries since
    // the bases are torn down here; they are snapshotted and dropped from the live vectors during emission
    // so a teardown action never re-targets this same pad.
    llvm::BasicBlock* buildCleanupDispatchItanium(std::size_t soBase, std::size_t dfBase,
                                                  std::size_t rgBase, llvm::BasicBlock* dispatchBB,
                                                  llvm::Value* carrierSlot) {
        soBase = std::min(soBase, scopeObjects.size());
        dfBase = std::min(dfBase, deferred.size());
        rgBase = std::min(rgBase, scopeRegions.size());
        llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
        ensurePersonality();
        std::vector<ScopeObject> objs(scopeObjects.begin() + soBase, scopeObjects.end());
        std::vector<Cleanup> defs(deferred.begin() + dfBase, deferred.end());
        std::vector<RegionLocal> regs(scopeRegions.begin() + rgBase, scopeRegions.end());
        scopeObjects.resize(soBase);
        deferred.resize(dfBase);
        scopeRegions.resize(rgBase);
        llvm::BasicBlock* pad = llvm::BasicBlock::Create(context, "cleanup.catch", currentFn);
        builder.SetInsertPoint(pad);
        llvm::LandingPadInst* lp = builder.CreateLandingPad(landingPadType(), 1);
        lp->addClause(itaniumVoidPtrTypeInfo());
        llvm::Value* excPtr = builder.CreateExtractValue(lp, 0, "exc");
        llvm::Value* obj = builder.CreateCall(cxaBeginCatch(), {excPtr}, "caught");
        builder.CreateCall(cxaEndCatch(), {});
        emitUnwindCleanupBody(objs, defs, regs);  // block-scoped defers/dtors of the unwound scopes
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {  // teardown itself may have thrown
            builder.CreateStore(obj, carrierSlot);
            builder.CreateBr(dispatchBB);
        }
        scopeObjects.insert(scopeObjects.end(), objs.begin(), objs.end());  // restore for the normal path
        deferred.insert(deferred.end(), defs.begin(), defs.end());
        scopeRegions.insert(scopeRegions.end(), regs.begin(), regs.end());
        builder.restoreIP(saved);
        return pad;
    }
    // WinEH unwind cleanup. Pure stack-object destructors keep the original, tested cleanuppad-funclet
    // chain (pad_n -> ... -> pad_0 -> finalUnwind), each destructor running under its funclet bundle.
    // When defer/using blocks or live regions are also in scope -- arbitrary code that cannot easily run
    // inside a funclet -- a catch-all pad catches the exception, `catchret`s to ordinary code that runs
    // the full teardown, and re-throws the same carrier, exactly like the emitTry uncaught-with-finally
    // path. Materialized lazily; mutually exclusive with emitScopeCleanup.
    llvm::BasicBlock* buildCleanupChain(llvm::BasicBlock* finalUnwind, std::size_t soBase = 0,
                                        std::size_t dfBase = 0, std::size_t rgBase = 0) {
        if (isItaniumEH()) {
            return buildCleanupChainItanium(soBase, dfBase, rgBase);
        }
        soBase = std::min(soBase, scopeObjects.size());  // defensive: never form a past-the-end iterator
        dfBase = std::min(dfBase, deferred.size());
        rgBase = std::min(rgBase, scopeRegions.size());
        if (deferred.size() <= dfBase && scopeRegions.size() <= rgBase) {  // pure destructors: funclet chain
            llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
            llvm::BasicBlock* succ = finalUnwind;
            for (std::size_t i = soBase; i < scopeObjects.size(); ++i) {
                const ScopeObject& so = scopeObjects[i];
                auto fnit = functions.find(so.className + ".~" + so.className);
                if (fnit == functions.end()) {
                    continue;  // no destructor: not part of the chain
                }
                ensurePersonality();
                llvm::BasicBlock* pad =
                    llvm::BasicBlock::Create(context, "cleanup." + so.className, currentFn);
                builder.SetInsertPoint(pad);
                llvm::CleanupPadInst* cp =
                    builder.CreateCleanupPad(llvm::ConstantTokenNone::get(context), {});
                llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), so.slot);
                builder.CreateCall(
                    fnit->second, {objPtr},
                    {llvm::OperandBundleDef("funclet", llvm::ArrayRef<llvm::Value*>{cp})});
                builder.CreateCleanupRet(cp, succ);
                succ = pad;
            }
            builder.restoreIP(saved);
            return succ;
        }
        // Defer/using/regions present: catch-all -> run teardown in normal context -> re-throw. Snapshot
        // only the entries since the bases; drop them from the live vectors during emission so the
        // teardown and the re-raise don't re-target this same cleanup (and the re-raise reaches the
        // enclosing try's handler, not this pad again).
        llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
        ensurePersonality();
        std::vector<ScopeObject> objs(scopeObjects.begin() + soBase, scopeObjects.end());
        std::vector<Cleanup> defs(deferred.begin() + dfBase, deferred.end());
        std::vector<RegionLocal> regs(scopeRegions.begin() + rgBase, scopeRegions.end());
        scopeObjects.resize(soBase);
        deferred.resize(dfBase);
        scopeRegions.resize(rgBase);
        llvm::PointerType* ptrTy = builder.getPtrTy();
        llvm::BasicBlock* pad = llvm::BasicBlock::Create(context, "cleanup", currentFn);
        builder.SetInsertPoint(pad);
        llvm::Value* caughtSlot = createEntryAlloca("exc.cleanup", ptrTy);
        llvm::CatchSwitchInst* cs =
            builder.CreateCatchSwitch(llvm::ConstantTokenNone::get(context), nullptr, 1);  // unwind: caller
        llvm::BasicBlock* dispatchBB = llvm::BasicBlock::Create(context, "cleanup.dispatch", currentFn);
        cs->addHandler(dispatchBB);
        builder.SetInsertPoint(dispatchBB);
        llvm::CatchPadInst* cp =
            builder.CreateCatchPad(cs, {ehTypeDesc(), builder.getInt32(0), caughtSlot});
        llvm::BasicBlock* runBB = llvm::BasicBlock::Create(context, "cleanup.run", currentFn);
        builder.CreateCatchRet(cp, runBB);
        builder.SetInsertPoint(runBB);
        llvm::Value* carrier = builder.CreateLoad(ptrTy, caughtSlot, "cleanup.obj");
        emitUnwindCleanupBody(objs, defs, regs);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            emitThrowObject(carrier);
        }
        scopeObjects.insert(scopeObjects.end(), objs.begin(), objs.end());  // restore for the normal path
        deferred.insert(deferred.end(), defs.begin(), defs.end());
        scopeRegions.insert(scopeRegions.end(), regs.begin(), regs.end());
        builder.restoreIP(saved);
        return pad;
    }
    // Where a faulting call/throw at the current point must unwind to: the enclosing try's landing pad
    // if inside a try; else, if the scope has any teardown (defer/using, live region, or a stack object
    // with a destructor), a fresh cleanup pad that runs it before propagating to the caller; else null.
    // Inside a try, teardown declared in the try body (defer/using/destructors) must run on the
    // caught-exception path too, not only on the normal/return path (spec 23.1). So a faulting point runs
    // the block-scoped cleanup for the scopes opened since the try body began, then reaches the try's
    // handler -- on WinEH via a cleanup funclet chain into the try pad, on Itanium via a cleanup landing
    // pad that runs the teardown and branches into the try's clause dispatch (both validated on Linux).
    llvm::BasicBlock* computeUnwindDest();

    // A user call that may throw: when there is an active unwind target (an enclosing try, or live
    // stack objects to destruct), it becomes an invoke unwinding there; otherwise an ordinary call.
    // Builtins that cannot throw (printf/malloc/scanf/...) keep using CreateCall directly.
    llvm::Value* emitMaybeInvoke(llvm::FunctionType* fty, llvm::Value* callee,
                                 llvm::ArrayRef<llvm::Value*> args, const std::string& name = "") {
        // [unknown-abi] Mirror the callee's calling convention onto the call/invoke, so an `unknown
        // <world>` callee is called with that foreign world's ABI. Non-Function callees keep default C.
        llvm::CallingConv::ID cc = llvm::CallingConv::C;
        if (auto* cf = llvm::dyn_cast<llvm::Function>(callee->stripPointerCasts())) {
            cc = cf->getCallingConv();
        }
        llvm::BasicBlock* ud = computeUnwindDest();
        if (ud == nullptr) {
            llvm::CallInst* ci = builder.CreateCall(fty, callee, args, name);
            ci->setCallingConv(cc);
            return ci;
        }
        llvm::BasicBlock* cont = llvm::BasicBlock::Create(context, "invoke.cont", currentFn);
        llvm::InvokeInst* inv = builder.CreateInvoke(fty, callee, cont, ud, args, name);
        inv->setCallingConv(cc);
        builder.SetInsertPoint(cont);
        return inv;
    }
    llvm::Value* emitMaybeInvoke(llvm::FunctionCallee callee, llvm::ArrayRef<llvm::Value*> args,
                                 const std::string& name = "") {
        // A value-struct-returning callee uses sret: allocate the result slot, pass it as the
        // trailing argument, and yield the slot (the call itself returns void).
        if (auto* f = llvm::dyn_cast<llvm::Function>(callee.getCallee());
            f != nullptr && sretFns_.count(f) > 0) {
            llvm::Value* slot = createEntryAlloca("sret", sretStructType_[f]);
            std::vector<llvm::Value*> a(args.begin(), args.end());
            a.push_back(slot);
            emitMaybeInvoke(callee.getFunctionType(), callee.getCallee(), a, "");
            return slot;
        }
        return emitMaybeInvoke(callee.getFunctionType(), callee.getCallee(), args, name);
    }

    // Throws (or re-throws) the object `obj` as the canonical void* carrier, unwinding
    // through live destructors into an enclosing try (if any) or to the caller. Ends
    // the current block with unreachable. Shared by `throw` and the uncaught-rethrow path.
    void emitThrowObjectItanium(llvm::Value* obj);
    void emitThrowObject(llvm::Value* obj);

    // Vtables of every concrete class that is `t` or a subclass of `t` -- used to match a caught
    // exception's dynamic type against a catch clause (subtype-aware). Empty if `t` is not a
    // polymorphic class, in which case the clause is treated as a catch-all (preserves the carrier).
    std::vector<llvm::Constant*> subtypeVtables(const std::string& t);

    // True if class `cn` is `t`, or (transitively) extends or implements `t` -- the subtype relation
    // used for runtime `is`/`as`/`cast` checks (spec 6.3/6.4). Unlike subtypeVtables it also follows
    // interfaces, so `x is SomeInterface` works.
    bool classIsSubtypeOf(const std::string& cn, const std::string& t);
    // Vtables of every concrete class that is a subtype of `t` (extends or implements it).
    std::vector<llvm::Constant*> subtypeVtablesInc(const std::string& t);
    // Runtime is-a test (spec 6.4): true iff `objPtr` is non-null and its concrete type (identified by
    // the vtable pointer at field 0) is a subtype of `targetClass`. Null-safe: null yields false.
    llvm::Value* emitIsa(llvm::Value* objPtr, const std::string& targetClass);

    // try { body } catch (T e) { ... } ... [finally { ... }] (spec 21.1). One catchpad catches the
    // canonical carrier; the clauses are matched in order against the exception's Polaron runtime type
    // (subtype-aware via vtables). If none match, the current exception is rethrown. finally runs on
    // the normal and caught paths (the uncaught-propagation finally is a later slice).
    // Itanium counterpart of emitTry. Same Polaron semantics and the same subtype-aware vtable matching;
    // only the pad mechanics differ. The landing pad catches the single carrier type, copies the object
    // out (begin/end_catch), and then dispatches in ordinary context -- so handlers, finally and the
    // unmatched rethrow are all normal code, with none of WinEH's funclet restrictions.
    void emitTryItanium(const ast::TryStmt& s);

    void emitTry(const ast::TryStmt& s);

    void emitStatement(const ast::Stmt& stmt);  // out of line in codegen_stmt.cpp

    // Runs the deferred blocks and stack-object destructors registered since the
    // given marks (LIFO), without the function-level contracts. Used to tear down a
    // lexical block on its normal exit. Stops if a terminator appears.
    // Frees every region in scopeRegions at index >= base (load the block and free;
    // a released region's slot is null, so free(null) is a harmless no-op).
    // Run (and clear) the destructors of every tracked object allocated in region `name`, in
    // reverse declaration order. Cleared (className emptied) so a later region free or scope
    // cleanup never runs them again on freed memory.
    void runRegionObjectDtors(const std::string& name);

    // Does this class own any `region` FIELD? (spec 17: `private mutable region store;`)
    std::vector<std::string> ownedRegionFieldsOf(const std::string& cn);

    // Release the regions an object OWNS, when that object dies.
    //
    // This was missing, and it leaked every time. A local region is freed by `freeRegionsFrom` at scope
    // exit and an explicit `release region this.f` frees a field one -- but an object holding a region
    // field and simply going out of scope released NOTHING. The region's whole promise is that its
    // storage lives exactly as long as its owner; for a field that owner is the object, and nobody was
    // enforcing the second half of that sentence.
    //
    // Found from pico: ten thousand create/destroy cycles of a small object with one 4 KiB region field
    // exhausted memory and hung the kernel. It is the same leak that made a per-call `ArgumentBlock`
    // unusable there -- the shell died a third of the way through a session.
    //
    // Teardown before release, in that order and for the reason spec 17.7 gives: the objects living in
    // the region must be destructed while their storage is still valid.
    void emitOwnedRegionFieldRelease(llvm::Value* objPtr, const std::string& cn);

    void freeRegionsFrom(std::size_t base);

    void emitBlockCleanup(std::size_t soBase, std::size_t dfBase, std::size_t regBase,
                          std::size_t strBase = static_cast<std::size_t>(-1),
                          std::size_t vsBase = static_cast<std::size_t>(-1)) {
        for (std::size_t i = deferred.size(); i > dfBase; --i) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) {
                return;
            }
            emitCleanupAction(deferred[i - 1]);
        }
        for (std::size_t i = scopeObjects.size(); i > soBase; --i) {
            const ScopeObject& so = scopeObjects[i - 1];
            if (!so.region.empty()) {
                continue;  // region objects are destructed when the region frees
            }
            auto fnit = functions.find(so.className + ".~" + so.className);
            const bool weak = weakRelevant(so.className);
            // A class with a `region` FIELD needs cleanup even with no destructor and no weak refs:
            // the region it owns has to go when it does. Leaving it out of this condition is what
            // made a region field leak on every scope exit.
            const bool ownsRegion = !ownedRegionFieldsOf(so.className).empty();
            if (fnit == functions.end() && !weak && !ownsRegion) {
                continue;
            }
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), so.slot);
            if (fnit != functions.end() || weak) {
                emitDtorIfLive(objPtr,
                               fnit == functions.end() ? llvm::FunctionCallee() : fnit->second,
                               weak ? so.className : std::string());
            }
            // AFTER the user destructor: it may still touch what lives in the region.
            if (ownsRegion) {
                emitOwnedRegionFieldRelease(objPtr, so.className);
            }
        }
        // String RAII: free String locals declared in this block (LIFO). The sentinel base means "leave
        // them" -- break/continue pass it so the outer scope-exit / function return frees them, never us
        // double-freeing here.
        if (strBase != static_cast<std::size_t>(-1)) {
            for (std::size_t i = scopeStrings.size(); i > strBase; --i) {
                builder.CreateCall(strFreeFn(),
                                   {builder.CreateLoad(builder.getPtrTy(), scopeStrings[i - 1])});
            }
        }
        // Async/gen value structs declared in this block (LIFO); the -1 sentinel means "leave them" for
        // an outer/function exit to free (break/continue), never double-freeing here.
        if (vsBase != static_cast<std::size_t>(-1)) {
            for (std::size_t i = scopeValueStructs.size(); i > vsBase; --i) {
                emitFreeValueStructSlot(scopeValueStructs[i - 1].first, scopeValueStructs[i - 1].second);
            }
        }
        freeRegionsFrom(regBase);  // region RAII (spec 17.7)
    }

    // Emits a lexical block. When `newScope` (every nested block: if/loop/try/case/
    // etc.), stack objects and `defer`s declared inside are torn down at the block's
    // normal exit and dropped from tracking -- so a destructor only runs on a path
    // that actually ran the declaration (no dtor on uninitialized memory), runs once
    // per loop iteration (no leak), and a defer fires per iteration. The function
    // body passes newScope=false: emitBody owns that teardown (with contracts).
    // Pre-scan a function body so every `label name;` is mapped to the block it is declared in. A forward
    // `goto` (the common case) needs to know its target's scope before the label is emitted, so this runs
    // once, up front, over the whole body.
    void scanLabelBlocks(const ast::Block& b);
    void scanStmtLabels(const ast::Stmt* s, const ast::Block& owner);

    // Run the defers/destructors/regions/Strings for every open scope nested inside the target label's
    // scope, innermost first, before a `goto` branches there. No-op if the label is in the current scope
    // (nothing nested is being left) or is not on the open-scope stack.
    // The hijack leaves the label's scopes and lands in the comefrom's, so the same teardown `goto`
    // does has to happen -- just keyed on where control is GOING, which for a comefrom is the site
    // that declared it rather than the label that triggered it.
    void emitComefromCleanup(const std::string& name);

    void emitGotoScopeCleanup(const std::string& label);

    void emitBlock(const ast::Block& block, bool newScope = true) {
        const std::size_t soBase = scopeObjects.size();
        const std::size_t dfBase = deferred.size();
        const std::size_t regBase = scopeRegions.size();
        const std::size_t strBase = scopeStrings.size();
        const std::size_t vsBase = scopeValueStructs.size();
        if (blockScopes.empty()) { labelBlock_.clear(); comefromBlock_.clear(); comefromTargets_.clear(); scanLabelBlocks(block); }  // function-body entry
        blockScopes.push_back({&block, soBase, dfBase, regBase, strBase, vsBase});
        for (const auto& stmt : block.statements) {
            // Don't stop at a terminator: a later `label` (the target of a forward goto/comefrom)
            // must still be placed. emitStatement skips genuinely dead statements but always emits
            // labels, re-establishing a reachable block for the code that follows.
            emitStatement(*stmt);
        }
        if (newScope) {
            // Normal fall-through: tear down this block's objects/defers/regions/strings. On a
            // terminating exit (return runs full cleanup; break/continue branch out)
            // we skip emission but still drop the entries so they are not re-run or
            // run on a stale slot at an outer/function exit.
            if (builder.GetInsertBlock()->getTerminator() == nullptr) {
                emitBlockCleanup(soBase, dfBase, regBase, strBase, vsBase);
            }
            scopeObjects.resize(soBase);
            deferred.resize(dfBase);
            scopeRegions.resize(regBase);
            scopeStrings.resize(strBase);
            scopeValueStructs.resize(vsBase);
        }
        blockScopes.pop_back();
    }

    void emitIf(const ast::IfStmt& s);

    // match (subject) { case Type(binds) { ... } ... default { ... } } (spec 16):
    // a chain of vtable comparisons. Each case binds the case type's own fields
    // (positional) and runs its body.
    // match on a *value* Result/Option (spec 21, value form): dispatch on the i32 tag (Ok/Some = 0,
    // Err/None = 1) instead of a vtable, and bind the payload decoded to the case's declared binding type.
    void emitValueMatch(const ast::MatchStmt& s, llvm::Value* subj);

    // A match whose subject is an ENUM: the arms name constants, so the test is the ordinal and not
    // a vtable. Nothing is bound out of a constant -- it is a value, not a shape with fields.
    //
    // The arms are compared in the order they were written, which matters for nothing here (a value
    // equals exactly one constant) and keeps the emitted branch chain readable beside the source.
    void emitEnumMatch(const ast::MatchStmt& s, llvm::Value* subj,
                       const std::vector<std::string>& constants) {
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "match.end", fn);
        for (const ast::MatchCase& c : s.cases) {
            const auto at = std::find(constants.begin(), constants.end(), c.typeName);
            if (at == constants.end()) {
                continue;  // the analyzer has already refused this
            }
            const long long ord = std::distance(constants.begin(), at);
            llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "match.case", fn);
            llvm::BasicBlock* nextBB = llvm::BasicBlock::Create(context, "match.next", fn);
            llvm::Value* want = llvm::ConstantInt::get(subj->getType(), ord);
            builder.CreateCondBr(builder.CreateICmpEQ(subj, want, "is"), bodyBB, nextBB);
            builder.SetInsertPoint(bodyBB);
            emitBlock(c.body);
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

    void emitMatch(const ast::MatchStmt& s);

    // Expression form (spec 16.2): each arm yields a value; a phi at the join merges
    // them. Mirrors emitMatch's vtable dispatch + positional binding, but produces a
    // value. Sema guarantees exhaustiveness, so the no-match tail is unreachable.
    // Emits a match-expression block arm (spec 16.2): runs the block, where `yield expr;` stores the
    // arm's value into a slot; returns that value at the arm's continuation.
    llvm::Value* emitYieldBlock(const ast::Block& body, llvm::Type* rty, const std::string& rtype);

    // Expression form of a *value* Result/Option match: tag dispatch producing a phi (mirrors
    // emitMatchExpr's vtable path, but reads the { tag, payload } value).
    llvm::Value* emitValueMatchExpr(const ast::MatchExpr& s, llvm::Value* subj);

    llvm::Value* emitMatchExpr(const ast::MatchExpr& s);
    // The expression form over an enum: one arm per constant, a value from each, a phi over them.
    llvm::Value* emitEnumMatchExpr(const ast::MatchExpr& s, llvm::Value* subj,
                                   const std::vector<std::string>& constants);

    void emitWhile(const ast::WhileStmt& s);

    // do { body } while (cond); -- the body runs at least once (spec 7).
    void emitDoWhile(const ast::DoWhileStmt& s);

    void emitFor(const ast::ForStmt& s);

    // for (T v in array) { ... } -- iterate an array's elements (spec 7). Elements
    // are i32 (int/char/boolean) in the current array model.
    void emitForeach(const ast::ForeachStmt& s);

    // Lazy `foreach` over an Iterable/Iterator (spec 9.2). The subject is either an Iterator itself
    // (it declares hasNext/next) or an Iterable (it declares iterator(), whose result is the Iterator).
    // The loop calls hasNext()/next() one element at a time -- no snapshot -- so a lazy or unbounded
    // sequence works, and an interface-typed subject dispatches through its vtable. Returns false when the
    // type is not iterable this way, so the caller can fall back to the array/toArray paths.
    bool emitForeachIterable(const ast::ForeachStmt& s, const std::string& cbase);

    // `for (int i in start..end [step k])` (spec 7.5): a counting loop over an integer range. `..` is
    // exclusive of end, `..=` inclusive; the step defaults to 1. Ascending ranges.
    void emitForeachRange(const ast::ForeachStmt& s, const ast::RangeExpr& rng);

    // switch (x) { case C { ... } ... default { ... } } with C-style fall-through (spec 7.3).
    void emitSwitch(const ast::SwitchStmt& s);

    // The C-ABI signature of an extern declaration (spec 26): a small (1/2/4/8-byte) value struct is
    // passed/returned in a register; a larger one is an error. Shared by namespace-level externs and
    // class extern static methods.
    // `hasReceiver`: a NON-STATIC extern takes the object as its first argument.
    //
    // That is not an invention -- it is the hidden `this` of a C++ member function (so a C++ binding
    // needs it) and the classic object-oriented-C idiom, `void widget_draw(Widget* self)`. Before this,
    // `static` was not required by the front end but was ASSUMED here, so a non-static extern parsed,
    // type-checked, and died at the LLVM verifier with "Incorrect number of arguments passed to called
    // function" -- the call site was already passing the receiver that the declaration did not have.
    llvm::FunctionType* externFnType(const std::vector<ast::Param>& params,
                                     const ast::TypeRef& retType, bool variadic, SourceLocation loc,
                                     bool hasReceiver = false) {
        std::vector<llvm::Type*> pts;
        if (hasReceiver) {
            pts.push_back(builder.getPtrTy());
        }
        for (const auto& p : params) {
            const std::string pt = typeRefName(p.type);
            if (llvm::Type* reg = ffiStructRegType(pt)) {
                pts.push_back(reg);
            } else {
                if (isFfiByValueStruct(pt)) {
                    error("FFI by-value struct '" + baseType(pt) +
                              "' must be 1, 2, 4 or 8 bytes; pass larger structs by pointer (spec 26)",
                          loc);
                }
                pts.push_back(llvmType(pt));
            }
        }
        const std::string rt = typeRefName(retType);
        llvm::Type* retTy = ffiStructRegType(rt);
        if (retTy == nullptr) {
            if (isFfiByValueStruct(rt)) {
                error("FFI by-value struct return '" + baseType(rt) +
                          "' must be 1, 2, 4 or 8 bytes (spec 26)",
                      loc);
            }
            retTy = llvmType(rt);
        }
        return llvm::FunctionType::get(retTy, pts, variadic);
    }

    void declareClasses();

    // Every value aggregate that implements a layout, measured against what that layout asked for.
    // Runs once all struct bodies are set: a size is only real when every field's type is, and a
    // budget checked earlier would be checked against a type still under construction.
    //
    // The fields have already been ordered by then (see orderForLayout), so this refuses only what
    // could not be made to fit -- which is the difference between a layout and an assertion.
    void checkLayoutBudgets(const ast::Program& program);

    // Folds a simple literal initializer to an LLVM constant of `llvmType(type)`.
    // Returns nullptr when the expression is not a compile-time literal we handle
    // here (the caller then zero-initializes the global).
    // Folds a constant integer/boolean/char expression, resolving references to
    // namespace-level consts and `comptime` method calls (spec 28) via the shared
    // evaluator. Returns false if not a compile-time integer constant.
    comptime::Context comptimeCtx();
    bool foldConstInt(const ast::Expr& e, long long& out);
    // Folds a constant floating-point expression (int consts/literals/calls promote).
    bool foldConstDouble(const ast::Expr& e, double& out);

    // The materialized value of a namespace-level const, at its declared type.
    llvm::Constant* constLiteral(const std::string& name);

    // Folds every namespace-level const (in declaration order, so later consts may
    // reference earlier ones). Run before any function body is emitted.
    void emitNamespaceConsts();

    llvm::Constant* constFold(const ast::Expr& expr, const std::string& type);

    // Emits one zero-initialized (or literal-initialized) LLVM global per static
    // field, named "Class.field". Static fields are class-wide, not per instance.
    // Persistents (spec 18, in-process): a `static persistent` global keeps its constant initial
    // value at startup and whatever it accumulates for the lifetime of the run, like a static
    // field. Per-variable reattach within a run is via the persist blocks (see getPersistBlock).
    void emitStaticFields();

    // Static fields whose initializer MUST fold: the ones whose LLVM type carries a value rather
    // than a pointer. A `static String s = "x"` or a `static int[] a` is initialized by other means
    // (the string pool, an onClassLoad block) and a null global there is correct, not a mistake.
    bool isNumericStaticType(const std::string& t) const;

    // Prepares the .polb's symbols for both linking modes. The bundle's own functions are dll-exported
    // so a dynamic consumer resolves them by name (GetProcAddress). Prelude functions are made weak
    // (linkonce_odr): static linking deduplicates them against the program's own prelude, and a
    // dynamically built DLL is self-contained (every class extends the prelude's Object) -- unused
    // prelude functions are then dead-stripped when the DLL is built.
    void exportBundleSymbols();

    // Emits a runtime-resolving thunk for each function of a dynamically-loaded bundle (--use-dynamic).
    // The thunk lazily loads the .polb (cached in a per-bundle handle global), resolves the symbol, and
    // forwards the call. A missing bundle / unresolved symbol aborts via polaron_bundle_fail (spec 2.4).
    void emitDynamicThunks();

    // Emits one vtable global per concrete polymorphic class: an array of
    // function pointers, one per slot, pointing at the most-derived impl.
    void emitVtables();

    // [unknown-abi] Map a foreign-binary "world" to its LLVM calling convention. The stored
    // convention string is a foreign boundary only when it has the form "unknown:<world>" (the
    // world is REQUIRED at the syntax level and is never inferred -- kernel/NT interop is a minefield
    // and the origin must be stated consciously). Legacy cconv keywords / empty -> the target's
    // default C ABI (a no-op). Hybrid surface: binary FORMATS (pe/elf/macho, resolved per target)
    // OR raw ABIs (win64/sysv/aapcs). Adding a new world = one row here.
    // The architecture FAMILY a name belongs to, so that `x86_64` and `amd64` are one answer and
    // `aarch64`/`arm64` another. Comparing raw names would call a block written for `x86_64` wrong on a
    // target spelled `amd64`, which is the same machine.
    //
    // An unknown name returns "" and the caller does not judge: a target this compiler has never heard
    // of is not evidence that the author's assembly is wrong.
    static std::string archFamily(const std::string& name) {
        if (name == "x86_64" || name == "amd64" || name == "x64") {
            return "x86_64";
        }
        if (name == "x86" || name == "i386" || name == "i486" || name == "i586" || name == "i686") {
            return "x86";   // 32-bit x86 is NOT x86_64: the register file and the ABI differ
        }
        if (name == "aarch64" || name == "arm64") {
            return "aarch64";
        }
        if (name.rfind("armv", 0) == 0 || name == "arm" || name == "thumb") {
            return "arm";
        }
        if (name.rfind("riscv", 0) == 0) {
            return "riscv";
        }
        if (name.rfind("wasm", 0) == 0) {
            return "wasm";
        }
        if (name.rfind("ppc", 0) == 0 || name.rfind("powerpc", 0) == 0) {
            return "ppc";
        }
        if (name.rfind("mips", 0) == 0) {
            return "mips";
        }
        if (name == "sparc" || name == "sparcv9") {
            return "sparc";
        }
        return "";
    }
    llvm::CallingConv::ID worldToCallConv(const std::string& conv, SourceLocation loc);
    // `public interrupt(Trap t) returns void { }` needs TWO functions, and the split is the whole
    // design. The body is emitted as an ordinary method -- a receiver, a parameter, a normal ABI --
    // so everything inside it is plain Polaron. Beside it goes this entry point, carrying
    // `x86_intrcc`, which is what the hardware actually jumps to: LLVM writes the save of every
    // register the body clobbers, the `cld`, the pop of a pushed error code, and the `iretq`.
    //
    // The two are joined by one global holding the bound receiver. That global is the only reason
    // the entry can be a plain symbol the IDT stores while the handler is still a method with an
    // object -- an interrupt vector has room for an address and nothing else, so the receiver has
    // to be waiting somewhere when the CPU arrives.
    //
    // ONE SLOT PER CLASS, so binding a second instance of the same class replaces the first. That
    // is the `nameless` rule showing up in the machine code: one device, one handler.
    void declareInterruptEntry(const std::string& className, const ast::MethodDecl& m,
                               llvm::Function* impl) {
        const std::string entry = className + "$interrupt";
        // THE MEANING IS PORTABLE; ONLY THE LOWERING IS NOT -- the shape Polaron already uses for
        // `asm`, for regions over fixed memory, and for the bit-counted integer names.
        //
        //   freestanding -> `x86_intrcc`: LLVM writes the save of every register the body clobbers,
        //                   the `cld`, the pop of a pushed error code, and the `iretq`.
        //   hosted       -> `void(i32)` on the ordinary C ABI, which is exactly what `signal()`
        //                   takes on POSIX *and* through the Windows CRT. One shape that installs
        //                   on both, rather than an answer per operating system.
        //
        // The MODE decides this, not the target triple, and the difference is not pedantry: the
        // triple answers an ABI question (is there an OS to promise a red zone), while
        // `freestanding` answers a language one (is there a runtime at all). The analyzer knows
        // only the mode, so keying codegen off the triple would let the two disagree -- a `Trap`
        // accepted at the declaration and then never delivered, which is the exact silent gap this
        // feature exists to close.
        const bool bare = freestandingProgram();
        auto* self = new llvm::GlobalVariable(
            module, builder.getPtrTy(), /*isConstant=*/false, llvm::GlobalValue::InternalLinkage,
            llvm::ConstantPointerNull::get(builder.getPtrTy()), entry + "$self");
        llvm::Type* handedTy = bare ? static_cast<llvm::Type*>(builder.getPtrTy())
                                    : static_cast<llvm::Type*>(builder.getInt32Ty());
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {handedTy}, false);
        // External linkage on purpose: nothing in the program calls this, so internalization plus
        // DCE would delete the one symbol the declaration exists to produce.
        llvm::Function* fn =
            llvm::Function::Create(ty, llvm::Function::ExternalLinkage, entry, module);
        if (bare) {
            fn->setCallingConv(llvm::CallingConv::X86_INTR);
            // The frame the CPU pushed. `byval` is not decoration: it is how x86_intrcc is told how
            // much stack the frame occupies, and LLVM rejects the convention without it.
            llvm::Type* frameTy = nullptr;
            if (!m.params.empty()) {
                auto it = classes.find(baseType(typeRefName(m.params[0].type)));
                if (it != classes.end() && it->second.type != nullptr) {
                    frameTy = it->second.type;
                }
            }
            if (frameTy == nullptr) {
                // No declared trap, or one whose type is not a class we laid out: model the frame
                // the x86-64 hardware pushes -- rip, cs, rflags, rsp, ss -- so the size is right.
                frameTy = llvm::StructType::get(context, {builder.getInt64Ty(), builder.getInt64Ty(),
                                                          builder.getInt64Ty(), builder.getInt64Ty(),
                                                          builder.getInt64Ty()});
            }
            fn->addParamAttr(0, llvm::Attribute::getWithByValType(context, frameTy));
        }
        llvm::BasicBlock* bb = llvm::BasicBlock::Create(context, "entry", fn);
        llvm::IRBuilder<> b(bb);
        llvm::Value* recv = b.CreateLoad(builder.getPtrTy(), self, "self");
        std::vector<llvm::Value*> args{recv};
        if (!m.params.empty()) {
            llvm::Value* handed = fn->getArg(0);  // the frame bare metal, the code hosted
            if (!bare) {
                // Widen or narrow to whatever integer width the handler declared.
                llvm::Type* want = impl->getFunctionType()->getParamType(1);
                if (want->isIntegerTy() && want != handed->getType()) {
                    handed = b.CreateIntCast(handed, want, /*isSigned=*/true, "code");
                }
            }
            args.push_back(handed);
        }
        b.CreateCall(impl, args);
        b.CreateRetVoid();
        // The IDT stores this address; NOTHING in the program calls it. Without this line
        // internalization plus DCE deletes the one symbol the whole declaration exists to produce,
        // and the failure is silent -- a kernel that installs a vector pointing at nothing.
        foreignEntryPoints_.insert(entry);
        interruptEntries_[className] = {fn, self};
    }
    // spec 36: `freestanding` is declared on the program, on a bundle, or on both. Mirrors what the
    // analyzer does, so the two passes cannot disagree about which world they are compiling for.
    bool freestandingProgram() const;
    // Asked from `typeName`, which runs before the entries exist, so it reads the LAYOUT rather than
    // `interruptEntries_` -- the layout pass has already run by then and the answer is the same.
    bool declaresInterrupt(const std::string& className) const;
    // Per class: the x86_intrcc entry point and the global holding the receiver bound to it.
    struct InterruptEntry {
        llvm::Function* entry = nullptr;
        llvm::GlobalVariable* self = nullptr;
    };
    std::unordered_map<std::string, InterruptEntry> interruptEntries_;

    void declareFunctions();

    // Does this statement (recursively) whole-assign `this.<field>` -- i.e. a `this.field = ...`
    // that sets the field itself, not a member of it (`this.field.x = ...`)? Mirrors the block-walk
    // used elsewhere (scanAbstained). Used to decide whether a value-struct field needs a default
    // heap allocation so its members can be written before any whole-value assignment.
    bool stmtWholeAssignsField(const ast::Stmt* st, const std::string& field);
    // True when some constructor of `cls` assigns the whole field (`this.field = ...`), meaning it
    // will set the field itself and no default allocation is needed.
    bool anyCtorWholeAssignsField(const ast::ClassDecl& cls, const std::string& field);

    // Applies every inline field initializer to `thisPtr`, in declaration order.
    // Run at the start of each constructor, before its body (spec 940).
    void emitFieldInits(const ast::ClassDecl& cls, llvm::Value* thisPtr);

    // Completes the current async resume's task with `value` (spec 20.2): the task's result is
    // stored (as a 64-bit slot) and its continuation/waiters are scheduled by the runtime.
    void emitTaskComplete(llvm::Value* value);

    // Stores the exception carrier on the current async resume's task, so the awaiter re-throws it
    // (spec 21) rather than the exception escaping the resume function and crashing a worker thread.
    void emitTaskCompleteError(llvm::Value* carrier);

    // A catch-all landing pad for an async resume function: if the body throws, record the exception on
    // the task and return normally instead of letting it escape the worker thread. Pushed onto
    // ehPadStack around the body so any uncaught throw unwinds here (defers/using still run first, since
    // the cleanup pads chain into this one). Returns the pad to push.
    // On Itanium the guard also exposes a "record" block and a carrier slot (via the out-params): a
    // cleanup landing pad that runs pending defers/destructors on the throw path (computeUnwindDest, using
    // the guard's itDispatch/itCarrier) branches there after the teardown, so defers run on an uncaught
    // async throw too -- not just on WinEH (task B8). null out-params => WinEH, which needs neither.
    llvm::BasicBlock* buildAsyncGuardPad(llvm::BasicBlock** itDispatchOut = nullptr,
                                         llvm::Value** itCarrierOut = nullptr) {
        ensurePersonality();
        llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
        llvm::PointerType* ptrTy = builder.getPtrTy();
        llvm::BasicBlock* pad = llvm::BasicBlock::Create(context, "async.guard", currentFn);
        if (isItaniumEH()) {
            // The shared record block: complete the task with the carrier and return. Both the direct guard
            // pad and any cleanup-dispatch pad (which runs defers first) converge here.
            llvm::Value* carrierSlot = createEntryAlloca("async.err.slot", ptrTy);
            llvm::BasicBlock* recordBB = llvm::BasicBlock::Create(context, "async.record", currentFn);
            builder.SetInsertPoint(recordBB);
            emitTaskCompleteError(builder.CreateLoad(ptrTy, carrierSlot, "async.err.v"));
            builder.CreateRetVoid();
            // The direct pad (no pending cleanup): catch, stash the carrier, converge on the record block.
            builder.SetInsertPoint(pad);
            llvm::LandingPadInst* lp = builder.CreateLandingPad(landingPadType(), 1);
            lp->addClause(itaniumVoidPtrTypeInfo());
            llvm::Value* exc = builder.CreateExtractValue(lp, 0, "exc");
            llvm::Value* carrier = builder.CreateCall(cxaBeginCatch(), {exc}, "async.err");
            builder.CreateStore(carrier, carrierSlot);
            builder.CreateCall(cxaEndCatch(), {});
            builder.CreateBr(recordBB);
            if (itDispatchOut != nullptr) {
                *itDispatchOut = recordBB;
            }
            if (itCarrierOut != nullptr) {
                *itCarrierOut = carrierSlot;
            }
        } else {
            builder.SetInsertPoint(pad);
            llvm::Value* caughtSlot = createEntryAlloca("exc.async", ptrTy);
            llvm::CatchSwitchInst* cs =
                builder.CreateCatchSwitch(llvm::ConstantTokenNone::get(context), nullptr, 1);
            llvm::BasicBlock* dispatchBB = llvm::BasicBlock::Create(context, "async.dispatch", currentFn);
            cs->addHandler(dispatchBB);
            builder.SetInsertPoint(dispatchBB);
            llvm::CatchPadInst* cp =
                builder.CreateCatchPad(cs, {ehTypeDesc(), builder.getInt32(0), caughtSlot});
            llvm::BasicBlock* failBB = llvm::BasicBlock::Create(context, "async.fail", currentFn);
            builder.CreateCatchRet(cp, failBB);
            builder.SetInsertPoint(failBB);
            llvm::Value* carrier = builder.CreateLoad(ptrTy, caughtSlot, "async.err");
            emitTaskCompleteError(carrier);
            builder.CreateRetVoid();
        }
        builder.restoreIP(saved);
        return pad;
    }

    // At an await: if the awaited task failed, re-throw its exception here so it surfaces at the await
    // (spec 21). In an async awaiter the re-throw unwinds into that awaiter's own guard pad; in a
    // synchronous context it propagates to the caller.
    void emitAwaitRethrowCheck(llvm::Value* handle);

    // Escape analysis for returned locals (mirrors the direct `return new X()` promotion). An object
    // built on the stack and then returned by name -- `T v = new T(); ...; return v;` -- escapes the
    // frame, so its pointer would dangle. Collect every identifier returned anywhere in a body, then
    // promote any matching stack `new` local initializer to the heap. Conservative: over-promotion only
    // moves a would-be-stack object to the heap, which is always safe.
    void collectReturnedNames(const ast::Stmt* st, std::set<std::string>& out);
    void promoteEscapingNews(const ast::Stmt* st, const std::set<std::string>& returned);

    void emitBody(llvm::Function* fn, const ast::Block& body,
                  const std::vector<ast::Param>& params, const std::string& thisClass,
                  llvm::Type* retType, const ast::ClassDecl* ctorOf = nullptr,
                  const std::vector<ast::ExprPtr>* requiresClauses = nullptr,
                  const std::vector<ast::ExprPtr>* ensuresClauses = nullptr,
                  const std::vector<const ast::Expr*>* invariants = nullptr,
                  bool hasEnv = false, const std::vector<ast::Capture>* caps = nullptr,
                  const std::vector<std::string>* capTypes = nullptr,
                  const std::string& dtorChainBase = "", const ast::ClassDecl* dtorOf = nullptr,
                  bool asyncResume = false, bool argvEntry = false, const std::string& retTypeName = "") {
        // NO FUNCTION TO WRITE INTO. Every caller reaches `functions[sym]`, which inserts a null for a
        // symbol nobody declared and returns it -- so a naming disagreement between the declaration
        // pass and this one arrived as an access violation with no output whatsoever. A refusal here
        // is not a fix for that mismatch, but it turns a silent crash into a failure that can be
        // read, and the callers that know the symbol say which one (see needFn).
        if (fn == nullptr) {
            error("internal: a method body was reached with no declared function to emit it into",
                  body.loc);
            return;
        }
        // -g: a nested emitBody (a lambda emitted mid-method) must not leave its DISubprogram as the current
        // debug scope, or the enclosing method's later instructions get a mismatched scope (verifier error).
        llvm::DISubprogram* savedDiSP = diCurrentSP;
        auto diRestore = llvm::make_scope_exit([this, savedDiSP]() { diCurrentSP = savedDiSP; });
        // A nested emitBody (a lambda emitted mid-method) gets its own goto scope stack + label map, so it
        // does not clobber the enclosing method's; restored when this body finishes.
        std::vector<BlockScope> savedBS = std::move(blockScopes);
        std::unordered_map<std::string, const ast::Block*> savedLB = std::move(labelBlock_);
        blockScopes.clear();
        labelBlock_.clear();
        comefromBlock_.clear();
        comefromTargets_.clear();
        auto bsRestore = llvm::make_scope_exit([this, &savedBS, &savedLB]() {
            blockScopes = std::move(savedBS);
            labelBlock_ = std::move(savedLB);
        });
        currentFn = fn;
        currentClass = thisClass;
        // WHOSE CODE THIS IS, anchored to the class rather than to whichever namespace loop ran last.
        //
        // A body is emitted from a worklist long after the walk that declared it, so ambient state set
        // by that walk is stale here -- and with two classes of one name, resolving `this` against the
        // stale namespace picked the wrong one. That surfaced as `no such field 'src'` inside the
        // standard library's own constructor, in a program whose author had merely declared a class of
        // the same name.
        //
        // Restored on the way out, because a lambda emitted mid-method re-enters this function.
        const std::string savedNs = currentNamespace;
        const std::string savedBundleName = currentBundleName;
        auto nsRestore = llvm::make_scope_exit([this, &savedNs, &savedBundleName]() {
            currentNamespace = savedNs;
            currentBundleName = savedBundleName;
        });
        // TWO KINDS OF CALLER, and they need opposite things. A body emitted from the walk over
        // namespaces has the right ambient value already; one emitted from a WORKLIST -- a
        // specialization, a synthesized accessor -- is reached long after that walk and has whatever
        // it left behind. So the walk announces itself by setting `emittingClassKey`, and only when it
        // has not does this fall back to looking the class up by name.
        //
        // The distinction is not cosmetic: `classNamespace` is keyed by the bare name, which belongs
        // to whichever class was declared FIRST, so for a shared name the fallback answers with the
        // other class's namespace. Measured both ways -- overwriting the caller cost ten errors,
        // removing the fallback cost ten different ones.
        if (!emittingClassKey.empty()) {
            if (auto it = classNamespace.find(emittingClassKey); it != classNamespace.end()) {
                currentNamespace = it->second;
            }
            if (auto it = classBundle.find(emittingClassKey); it != classBundle.end()) {
                currentBundleName = it->second;
            }
        } else if (!thisClass.empty()) {
            if (auto it = classNamespace.find(thisClass); it != classNamespace.end()) {
                currentNamespace = it->second;
            }
            if (auto it = classBundle.find(thisClass); it != classBundle.end()) {
                currentBundleName = it->second;
            }
        }
        currentRetType = retType;
        currentRetTypeName_ = retTypeName;  // String RAII: drives copy-on-return for `returns String`
        // A value-struct return uses sret: the result slot is the trailing argument and the function
        // itself returns void, so `return X` copies X into the slot rather than returning a value.
        currentSretSlot_ = nullptr;
        if (sretFns_.count(fn) > 0) {
            currentSretSlot_ = fn->getArg(fn->arg_size() - 1);
            currentRetType = builder.getVoidTy();
        }
        currentEnsures = ensuresClauses;
        // A constructor and a destructor keep every check: one establishes the invariant and the other
        // dismantles the object, so "writes no field it mentions" does not describe either.
        currentInvariants = (ctorOf != nullptr || dtorOf != nullptr || !dtorChainBase.empty())
                                ? invariants
                                : invariantsToCheck(fn, invariants, body);
        // WHAT TO CHECK AT EXIT AND WHAT TO ASSUME AT ENTRY ARE NOT THE SAME LIST, and sharing one
        // handed the optimisation to precisely the methods that could not use it.
        //
        // `invariantsToCheck` narrows to the invariants THIS method might have broken -- correct, and
        // worth 3.5 ms. But `emitInvariantAssumes` was reading the same narrowed list, so a method that
        // assigns no field got an EMPTY one and no assumptions at all. Every invariant holds on entry
        // regardless of what the method goes on to do; a method that writes nothing is not a method
        // that knows nothing. Measured on `HashMap$int$int`: `slotFor`, `get`, `containsKey`,
        // `getOrDefault`, `keyArray` and `valueArray` had zero `llvm.assume` and kept every bounds
        // check, while `put`/`grow`/`merge`/`remove` -- which cannot benefit, they reassign the arrays
        // -- had five each. The probe the whole transform was written for was the one place it never
        // reached.
        currentInvariantsToAssume = invariants;
        currentDtorChain = dtorChainBase;  // a destructor calls its base destructor at each exit
        currentThis = nullptr;
        // An async resume's single argument is the polaron_task* state (spec 20.2); `return`
        // completes it (see the ReturnStmt codegen) rather than returning a value.
        currentAsyncState = asyncResume ? fn->getArg(0) : nullptr;
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
        subRegions_.clear();
        pendingRegionFlavor_.clear();
        volatileObjects_.clear();
        deferred.clear();
        escapingLocals_.clear();  // async bodies don't run the sync escape analysis; no stale carryover
        labelBlocks.clear(); comefromBlocks.clear();
        llvm::BasicBlock* block = llvm::BasicBlock::Create(context, "entry", fn);
        builder.SetInsertPoint(block);
        // --verify-stack: read the stack pointer this method was entered on. Compared against a fresh
        // read at every `return` (see the ReturnStmt handler). See codegen.h for the fault this exists
        // to locate; the short version is that a displaced stack pointer currently surfaces as wrong
        // DATA somewhere else entirely, and this turns it into a named method at the moment it happens.
        entrySp = nullptr;
        if (verifyStack) {
            llvm::Function* save = llvm::Intrinsic::getDeclaration(&module, llvm::Intrinsic::stacksave,
                                                    {llvm::PointerType::get(context, 0)});
            entrySp = builder.CreateCall(save, {}, "sp.entry");
        }
        // -g: attach a DISubprogram for this method and give the prologue (arg stores, super/field-init
        // calls) the method's opening line, so no instruction in a debug method lacks a location.
        beginDebugFunction(fn, body.loc);
        setDebugLoc(body.loc);

        // Identifiers returned anywhere in the body. Used both to promote returned stack `new`s and to
        // decide whether a copied class-value parameter must live on the heap (it escapes) or the frame.
        std::set<std::string> escaping;
        for (const auto& s : body.statements) {
            collectReturnedNames(s.get(), escaping);
        }
        // A value-struct return copies into the caller's sret slot, so a local it returns by name does
        // not escape as a pointer and must not be promoted -- same reason as the direct `return new X()`
        // case in the ReturnStmt codegen. `escaping` itself still stands: it also drives the class-value
        // parameter copies below, which do escape.
        if (!escaping.empty() && currentSretSlot_ == nullptr) {
            for (const auto& s : body.statements) {
                promoteEscapingNews(s.get(), escaping);
            }
        }
        escapingLocals_ = escaping;  // value-copy locals that escape (below) are copied onto the heap

        unsigned argIdx = 0;
        if (hasEnv) {
            argIdx = 1;  // arg 0 is the captured-environment pointer (a lambda)
        } else if (!thisClass.empty()) {
            currentThis = fn->getArg(0);
            argIdx = 1;
        }
        if (argvEntry && !params.empty()) {
            // int main(int argc, char** argv): build main's `string[] args` from the C argv.
            llvm::Value* arr = emitArgvArray(fn->getArg(0), fn->getArg(1));
            llvm::Value* slot = createEntryAlloca(params[0].name, builder.getPtrTy());
            builder.CreateStore(arr, slot);
            locals[params[0].name] = LocalSlot{slot, typeRefName(params[0].type)};
        } else {
            for (const ast::Param& p : params) {
                const std::string pt = typeRefName(p.type);
                llvm::Value* slot = createEntryAlloca(p.name, llvmType(pt));
                llvm::Value* incoming = fn->getArg(argIdx);
                // Value semantics (spec 3.4): a plain class parameter is an independent deep copy, like
                // assignment -- mutating it must not affect the caller's object. Pointer/reference (T*/T&),
                // interface and abstract parameters keep sharing (isClassValue excludes them). Copy onto
                // the heap when the parameter is returned (escapes the frame), otherwise onto the frame.
                if (incoming != nullptr && isClassValue(pt) && isCopyDiscipline(pt)) {
                    incoming = emitClassCopy(pt, incoming, /*heap=*/escaping.count(p.name) > 0);
                }
                builder.CreateStore(incoming, slot);
                locals[p.name] = LocalSlot{slot, pt};
                declareLocalDebug(slot, p.name, pt, p.loc, argIdx + 1);  // -g: parameter (1-based DWARF)
                ++argIdx;
            }
        }
        // Captured variables: env (arg 0) is an array of pointers, one per capture. Each slot
        // holds a pointer to the captured variable's storage (a private copy for byvalue, or the
        // original variable for byref); the lambda body reads/writes through it.
        if (caps != nullptr) {
            llvm::Value* envArg = fn->getArg(0);
            for (std::size_t i = 0; i < caps->size(); i++) {
                llvm::Value* slotPtr =
                    builder.CreateGEP(builder.getPtrTy(), envArg, builder.getInt32(i));
                llvm::Value* storage =
                    builder.CreateLoad(builder.getPtrTy(), slotPtr, (*caps)[i].name);
                locals[(*caps)[i].name] = LocalSlot{storage, (*capTypes)[i]};
            }
        }

        // A constructor first runs super() (base constructor) -- implicit, or
        // explicit `super(args)` to forward arguments -- then installs this
        // class's vtable, then field initializers, then its body.
        if (ctorOf != nullptr) {
            ClassLayout& cl = classes[ctorOf->name];
            const ast::CallExpr* superCall = explicitSuperCall(body);
            if (!cl.superclass.empty()) {
                auto sit = functions.find(cl.superclass + "." + cl.superclass);
                if (sit != functions.end()) {
                    std::vector<llvm::Value*> superArgs{currentThis};
                    if (superCall != nullptr) {
                        llvm::Function* basef = sit->second;
                        for (std::size_t i = 0; i < superCall->args.size(); ++i) {
                            llvm::Value* av = emitExpr(*superCall->args[i]);
                            if (i + 1 < basef->arg_size()) {
                                av = coerceToType(av, basef->getArg(i + 1)->getType());
                            }
                            superArgs.push_back(av);
                        }
                    }
                    builder.CreateCall(sit->second, superArgs);
                }
            }
            if (cl.hasVtable && cl.vtable != nullptr) {
                llvm::Value* vtblField =
                    builder.CreateStructGEP(cl.type, currentThis, 0, "vtbl.addr");
                builder.CreateStore(cl.vtable, vtblField);
            }
            emitFieldInits(*ctorOf, currentThis);
            // Instance lifecycle (spec 32.5): maintain a live-instance counter; run
            // onFirstInstance the first time the count goes from zero.
            if (ctorOf->onFirstInstance || ctorOf->onLastInstanceDestroyed ||
                unimportableClasses.count(ctorOf->name) > 0 ||
                countedClasses.count(ctorOf->name) > 0) {
                llvm::GlobalVariable* ctr = instanceCounter(ctorOf->name);
                llvm::Value* cur = builder.CreateLoad(builder.getInt32Ty(), ctr, "inst.n");
                if (ctorOf->onFirstInstance) {
                    llvm::Function* f = currentFn;
                    auto* doBB = llvm::BasicBlock::Create(context, "first.do", f);
                    auto* contBB = llvm::BasicBlock::Create(context, "first.cont", f);
                    builder.CreateCondBr(builder.CreateICmpEQ(cur, builder.getInt32(0)), doBB, contBB);
                    builder.SetInsertPoint(doBB);
                    if (llvm::Function* h = needFn(clsKey(ctorOf->name) + ".__onFirstInstance")) {
                        builder.CreateCall(h);
                    }
                    builder.CreateBr(contBB);
                    builder.SetInsertPoint(contBB);
                }
                builder.CreateStore(builder.CreateAdd(cur, builder.getInt32(1)), ctr);
            }
        }

        // Instance lifecycle (spec 32.5): a destructor decrements the live-instance count
        // and runs onLastInstanceDestroyed when it reaches zero.
        if (dtorOf != nullptr && (dtorOf->onLastInstanceDestroyed || dtorOf->onFirstInstance ||
                                  unimportableClasses.count(dtorOf->name) > 0 ||
                                  countedClasses.count(dtorOf->name) > 0)) {
            llvm::GlobalVariable* ctr = instanceCounter(dtorOf->name);
            llvm::Value* dec =
                builder.CreateSub(builder.CreateLoad(builder.getInt32Ty(), ctr, "inst.n"),
                                  builder.getInt32(1));
            builder.CreateStore(dec, ctr);
            if (dtorOf->onLastInstanceDestroyed) {
                llvm::Function* f = currentFn;
                auto* doBB = llvm::BasicBlock::Create(context, "last.do", f);
                auto* contBB = llvm::BasicBlock::Create(context, "last.cont", f);
                builder.CreateCondBr(builder.CreateICmpEQ(dec, builder.getInt32(0)), doBB, contBB);
                builder.SetInsertPoint(doBB);
                if (llvm::Function* h =
                        needFn(clsKey(dtorOf->name) + ".__onLastInstanceDestroyed")) {
                    builder.CreateCall(h);
                }
                builder.CreateBr(contBB);
                builder.SetInsertPoint(contBB);
            }
        }

        // Contracts: preconditions run after the prologue, before the body (spec 29).
        if (requiresClauses != nullptr) {
            for (const ast::ExprPtr& r : *requiresClauses) {
                emitContractCheck(*r, "requires");
            }
        }
        // NOT IN A CONSTRUCTOR. An invariant is established BY the constructor, not before it: at its
        // entry the fields hold whatever the allocation left there, so evaluating `this.data.length()`
        // dereferences garbage. Assuming it here crashed the map benchmark with an access violation
        // before printing a character -- the invariant is a promise about a finished object.
        //
        // `ctorOf` is what tells them apart; a destructor is left out for the same reason from the
        // other end, since a partially torn-down object need not satisfy it either.
        if (ctorOf == nullptr && dtorOf == nullptr && dtorChainBase.empty()) {
            emitInvariantAssumes();
        }
        // Capture each old(e) in the ensures clauses at entry, so the exit check compares against
        // the entry-time value (spec 29).
        oldValues_.clear();
        if (ensuresClauses != nullptr) {
            std::vector<const ast::OldExpr*> olds;
            for (const ast::ExprPtr& e : *ensuresClauses) {
                collectOld(e.get(), olds);
            }
            for (const ast::OldExpr* o : olds) {
                llvm::Value* v = emitExpr(*o->inner);
                if (v == nullptr) {
                    continue;
                }
                llvm::Value* slot = createEntryAlloca("old", v->getType());
                builder.CreateStore(v, slot);
                oldValues_[o] = slot;
            }
        }

        // Entry point: run every class's onClassLoad hook once, before main (spec 32.5).
        if (auto eit = functions.find("@entry"); eit != functions.end() && fn == eit->second) {
            emitClassLoadHooks();
        }

        emitBlock(body, /*newScope=*/false);  // emitBody owns function-level teardown (+ contracts)
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            emitScopeCleanup();
        }
        // emitScopeCleanup may itself terminate the block (a throwing defer), so re-check here.
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            if (currentAsyncState != nullptr) {
                emitTaskComplete(nullptr);  // async body fell through without an explicit return
                builder.CreateRetVoid();
            } else if (retType->isVoidTy()) {
                builder.CreateRetVoid();
            } else if (retType->isFloatingPointTy()) {
                builder.CreateRet(llvm::ConstantFP::get(retType, 0.0));
            } else if (retType->isPointerTy()) {
                // A class/pointer return: emit a null default. This fall-through is reached only when the
                // body never returns on this path (e.g. a method whose body ends in while(true)); the value
                // is never used, but it keeps the IR well-typed. The old i32-0 default produced an invalid
                // `ret i32 0` on a ptr-returning function.
                builder.CreateRet(llvm::ConstantPointerNull::get(llvm::cast<llvm::PointerType>(retType)));
            } else if (retType->isIntegerTy()) {
                builder.CreateRet(llvm::ConstantInt::get(retType, 0));  // right width (i8/i16/i32/i64)
            } else {
                builder.CreateRet(llvm::UndefValue::get(retType));  // struct (tuple) etc.: no implicit default
            }
        }
    }

    // The heap state object for an async method (spec 20.2): field 0 is the resume-point index,
    // field 1 is the task it produces, then one field per parameter. (Slice B will append the
    // body's locals + await temporaries here so they survive suspension.)
    llvm::StructType* asyncStateType(const ast::MethodDecl& m, const std::string& mangled);

    // Emits an async method (spec 20.2) as two functions: a resume function holding the body
    // (whose `return X` completes the task), and a wrapper that allocates the state object, copies
    // the arguments in, schedules the resume on the worker pool, and returns the Task immediately.
    void emitAsyncMethod(const ast::ClassDecl& cls, const ast::MethodDecl& m);

    // The wrapper foo(args): allocate the state object, copy arguments into it, schedule the
    // resume on the worker pool, and return a Task<T> immediately (spec 20.2).
    void emitAsyncWrapper(llvm::StructType* stateTy, const ast::MethodDecl& m,
                          const std::string& mangled) {
        llvm::Function* res = functions[mangled + "$resume"];
        llvm::Function* wrap = functions[mangled];
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", wrap));
        llvm::FunctionType* tnTy = llvm::FunctionType::get(builder.getInt64Ty(), false);
        llvm::Value* taskH =
            builder.CreateCall(module.getOrInsertFunction("__polaron_task_new", tnTy), {}, "task");
        llvm::Value* state = builder.CreateCall(mallocFn(), {sizeOf(stateTy)}, "state");
        builder.CreateStore(builder.getInt32(0), builder.CreateStructGEP(stateTy, state, 0));
        builder.CreateStore(builder.CreateIntToPtr(taskH, builder.getPtrTy()),
                            builder.CreateStructGEP(stateTy, state, 1));
        for (std::size_t i = 0; i < m.params.size(); ++i) {
            builder.CreateStore(wrap->getArg(i), builder.CreateStructGEP(stateTy, state, 2 + i));
        }
        llvm::FunctionType* schTy = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        builder.CreateCall(module.getOrInsertFunction("__polaron_schedule", schTy), {res, state});
        const std::string taskCls = ast::mangleGeneric("Task", {typeRefName(m.returnType)});
        llvm::Value* obj = llvm::ConstantPointerNull::get(builder.getPtrTy());
        if (auto cit = classes.find(taskCls); cit != classes.end()) {
            obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "task.obj");
            if (auto ctor = functions.find(taskCls + "." + taskCls); ctor != functions.end()) {
                builder.CreateCall(ctor->second, {obj});
            }
            if (auto hIt = cit->second.fieldIndex.find("h"); hIt != cit->second.fieldIndex.end()) {
                builder.CreateStore(taskH, builder.CreateStructGEP(cit->second.type, obj,
                                                                   hIt->second, "task.h.addr"));
            }
        }
        builder.CreateRet(obj);
    }

    // Widens a value to a 64-bit slot (for task results / channel elements): pointers and doubles
    // are reinterpreted, integers sign-extended.
    llvm::Value* valueToI64(llvm::Value* v);

    // Casts a 64-bit task-result slot back to the awaited type T.
    llvm::Value* castTaskResult(llvm::Value* res64, const std::string& t);

    // Collects every local declared anywhere in an async body (recursing into control flow), so
    // they can live in the state object and survive suspension.
    void scanAsyncLocals(const ast::Block& b, std::vector<std::pair<std::string, std::string>>& out);
    void scanAsyncLocalsS(const ast::Stmt* s, std::vector<std::pair<std::string, std::string>>& out);
    // Counts every await reachable in an async body (recursing into control flow + the await-
    // bearing expressions), so the state object can reserve a handle slot per await.
    int countAwaitsE(const ast::Expr* e);
    int countAsyncAwaitsS(const ast::Stmt* s);
    int countAsyncAwaits(const ast::Block& b);
    bool containsAwait(const ast::Expr& e) { return countAwaitsE(&e) > 0; }
    bool laterArgAwaits(const std::vector<ast::ExprPtr>& a, std::size_t i);
    bool anyArgAwaits(const std::vector<ast::ExprPtr>& a);
    // Saves a value into the async state object so it survives a later await's suspend/resume
    // split (otherwise it would not dominate its use in the resume block). reloadSpill reads it
    // back after the await. Spills/reloads nest LIFO within an expression.
    SpillToken spillAcrossAwait(llvm::Value* v);
    llvm::Value* reloadSpill(const SpillToken& t, llvm::Value* orig);

    // Emits a generator's parked body (spec 22.6) as the four raw functions the synthesized Iterator
    // class declared as externs:
    //
    //   <sym>$start(self?, args...) -> long   allocate the heap state, seed it with the arguments
    //   <sym>$resume(long st) -> boolean      run the body to the next `yield`; false when it ends
    //   <sym>$current(long st) -> T           the element the last resume yielded
    //   <sym>$free(long st) -> void           release the state
    //
    // $resume is a state machine built exactly like the async one: every local lives in the state
    // object (so it survives suspension), the body is emitted with its natural control flow, and each
    // `yield` -- anywhere, including inside loops -- returns to the caller after recording the block to
    // come back to. The entry switch jumps straight there on the next call.
    void emitGeneratorMethod(const ast::ClassDecl& cls, const ast::MethodDecl& m);

    // Emits an async method whose body awaits (spec 20.2) as a state machine, via coroutine
    // lowering: every local lives in the heap state object, the body is emitted with its natural
    // control flow, and each `await` (anywhere -- including inside loops/ifs) splits its block into
    // a suspend/resume pair. The entry switch jumps to the saved resume block; `await` in emitExpr
    // either reads an already-ready result or registers a continuation and returns (suspends).
    void emitAsyncStateMachine(const ast::ClassDecl& cls, const ast::MethodDecl& m);

    // Collect the test declarations of spec 32.11 from the user's own code, for the --test runner:
    // [Test] methods plus the per-class lifecycle hooks that bracket them.
    //
    // SemanticAnalyzer::validateTestDeclarations has already rejected every malformed shape on EVERY
    // compile (so the editor and `polaron build` report them too), which means the checks repeated here
    // cannot fire. They stay as a backstop: if sema ever grows a hole, the result should be an error,
    // never a test that silently does not run.
    void collectTests();

    // Record one [BeforeAll]/[AfterAll]/[Setup]/[Teardown] against its class, rejecting a second one:
    // two hooks of the same kind have no defined order, so the runner would silently pick one.
    void collectHook(const ast::ClassDecl& cls, const ast::MethodDecl& m, const std::string& kind);

    // The string value of one annotation argument, e.g. the "..." of [Ignore(reason: "...")].
    // Empty when absent or not a string literal.
    static std::string annotationStringArg(const ast::AnnotationUse& use, const std::string& name) {
        for (const ast::AnnotationArg& a : use.args) {
            if (a.name != name) {
                continue;
            }
            if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(a.value.get())) {
                return s->value;
            }
        }
        return "";
    }

    // The integer value of one annotation argument, e.g. the 500 of [MaxTime(ms: 500)].
    static long long annotationIntArg(const ast::AnnotationUse& use, const std::string& name,
                                      long long fallback) {
        for (const ast::AnnotationArg& a : use.args) {
            if (a.name != name) {
                continue;
            }
            if (const auto* i = dynamic_cast<const ast::IntLiteralExpr*>(a.value.get())) {
                try {
                    return std::stoll(i->text, nullptr, 0);
                } catch (const std::exception&) {
                    return fallback;
                }
            }
        }
        return fallback;
    }

    // Resolves [Cases(source: "m")] against the test's parameter list. A parametrized test takes
    // exactly one parameter and runs once per element of the array `m` returns; anything else is
    // rejected here rather than producing a test that quietly never runs. Returns false to drop the
    // test after reporting.
    bool collectCases(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                      const ast::AnnotationUse* cases, TestCase& tc) {
        if (cases == nullptr) {
            if (m.params.empty()) {
                return true;
            }
            errors.push_back(CodegenError{
                "[Test] method '" + tc.sym + "' takes parameters, so it needs a "
                "'[Cases(source: \"...\")]' naming the static method that supplies its rows",
                m.loc});
            return false;
        }
        if (m.params.size() != 1) {
            errors.push_back(CodegenError{
                "'[Cases]' test '" + tc.sym + "' must take exactly one parameter (it is called once "
                "per row); group several values into a record and take that",
                m.loc});
            return false;
        }
        const std::string source = annotationStringArg(*cases, "source");
        if (source.empty()) {
            errors.push_back(CodegenError{
                "'[Cases]' on '" + tc.sym + "' needs a source: [Cases(source: \"methodName\")]",
                cases->loc});
            return false;
        }
        const std::string want = typeRefName(m.params.front().type);
        const ast::MethodDecl* src = nullptr;
        for (const ast::MemberPtr& member : cls.members) {
            const auto* cand = dynamic_cast<const ast::MethodDecl*>(member.get());
            if (cand != nullptr && cand->name == source) { src = cand; break; }
        }
        if (src == nullptr) {
            errors.push_back(CodegenError{"'[Cases]' source '" + source + "' is not a method of class '" +
                                              cls.name + "'",
                                          cases->loc});
            return false;
        }
        const std::string got = typeRefName(src->returnType);
        if (!src->isStatic || got != want + "[]") {
            errors.push_back(CodegenError{
                "'[Cases]' source '" + cls.name + "." + source + "' must be a public static method "
                "returning '" + want + "[]' to match the parameter of '" + tc.sym + "' (it returns '" +
                    got + "')",
                src->loc});
            return false;
        }
        tc.casesSym = cls.name + "." + source;
        tc.paramType = want;
        return true;
    }

    // [Benchmark]: a timed loop, not a verdict. Kept out of the test list entirely so a benchmark can
    // never turn a suite red, and run only under --bench so it never slows an ordinary run.
    void collectBenchmark(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                          const ast::AnnotationUse& use, bool alsoTest) {
        const std::string sym = cls.name + "." + m.name;
        if (alsoTest) {
            errors.push_back(CodegenError{"'[Benchmark]' and '[Test]' cannot mark the same method '" +
                                              sym + "': a benchmark measures, a test judges",
                                          m.loc});
            return;
        }
        if (!m.isStatic || typeRefName(m.returnType) != "void" || !m.params.empty()) {
            errors.push_back(CodegenError{"'[Benchmark]' method '" + sym +
                                              "' must be a public static method taking no arguments "
                                              "and returning void",
                                          m.loc});
            return;
        }
        BenchCase bc;
        bc.sym = sym;
        bc.display = sym;
        bc.iterations = annotationIntArg(use, "iterations", 1000);
        bc.warmup = annotationIntArg(use, "warmup", 100);
        if (bc.iterations < 1) {
            errors.push_back(CodegenError{"'[Benchmark(iterations: ...)]' on '" + sym +
                                              "' needs at least 1 iteration",
                                          use.loc});
            return;
        }
        benchMethods.push_back(std::move(bc));
    }

    // Every class's onClassLoad hook, once, at the top of the entry point (spec 32.5). Called from
    // BOTH entry points -- the program's own `main` and the synthesized --test runner -- because a
    // test runs against a program whose classes must be as loaded as they are in a normal run. The
    // --test runner used to skip this, and the result was a suite that panicked in its first fixture
    // on a table its onClassLoad fills: every test in agents-exe failed for a reason none of them
    // were about.
    //
    // A FREESTANDING PROGRAM SKIPS THE PRELUDE'S HOOKS, and that is not a shortcut. The call is what
    // keeps the hook alive: it is emitted before dead-stripping, so a prelude class nobody touches
    // stops being dead the moment the entry calls it, and everything its body reaches comes with it.
    // The prelude's `Test` is the only class in it with an `onClassLoad`, its body assigns two
    // static `String`s, and a String store lowers to `__polaron_str_copy`/`__polaron_str_free` -- symbols
    // no bare-metal image has. So every freestanding program failed at LINK naming two symbols
    // nobody wrote, which is exactly what pico did.
    //
    // Precise rather than broad: the analyzer already refuses `Test` (and `String`) in freestanding,
    // so this skips a hook for a class such a program is not allowed to reference in the first
    // place. A prelude class it CAN use keeps its hook, because the guard is on the bundle, not on
    // the mode alone.
    void emitClassLoadHooks();

    // Emits `body()` guarded by `cond`, leaving the builder on the join block.
    void emitIfThen(llvm::Function* fn, llvm::Value* cond, const std::function<void()>& body);

    // Emit `int main(int argc, char** argv)` as the runner over the collected [Test] methods: it runs
    // each one bracketed by its class's lifecycle hooks, reports PASS/FAIL/SKIP, and returns non-zero
    // if anything failed. Called after emitFunctions so the bodies exist.
    //
    // Argument policy and report formatting are the runtime's (__polaron_test_*), so what is emitted here
    // stays about ORDER: when a fixture is built, when a test runs, when it is torn down.
    void emitTestRunner();

    // [Benchmark] methods: a warmup pass the timer ignores, then the measured loop. Reported as
    // ns/op, never as a verdict, and only when --bench asked for them.
    void emitBenchmarks(llvm::Function* mainFn);

    void emitFunctions();
};

}  // namespace polaron
