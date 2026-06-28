#include "llvm/IR/MDBuilder.h"
#include "codegen/codegen.h"

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/PassManager.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Passes/OptimizationLevel.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/Utils/Cloning.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "parser/ast.h"
#include "semantic/comptime.h"

namespace ldp3 {

namespace {

std::string resolveEscapes(const std::string& raw) {
    std::string out;
    for (std::size_t i = 0; i < raw.size(); ++i) {
        if (raw[i] == '\\' && i + 1 < raw.size()) {
            switch (raw[++i]) {
                case 'n': out += '\n'; break;
                case 't': out += '\t'; break;
                case 'r': out += '\r'; break;
                case '0': out += '\0'; break;
                case '\\': out += '\\'; break;
                case '\'': out += '\''; break;
                case '"': out += '"'; break;
                default: out += raw[i]; break;
            }
        } else {
            out += raw[i];
        }
    }
    return out;
}

std::int64_t parseIntLiteral(const std::string& lexeme) {
    std::string s;
    for (char c : lexeme) {
        if (c == '_' || c == 'L' || c == 'l') continue;
        s += c;
    }
    int base = 10;
    std::size_t start = 0;
    if (s.size() >= 2 && s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
        base = 16;
        start = 2;
    } else if (s.size() >= 2 && s[0] == '0' && (s[1] == 'b' || s[1] == 'B')) {
        base = 2;
        start = 2;
    }
    try {
        return static_cast<std::int64_t>(std::stoll(s.substr(start), nullptr, base));
    } catch (...) {
        // Beyond int64 range (e.g. a large uint64 literal): parse as unsigned
        // and keep the bit pattern.
        try {
            return static_cast<std::int64_t>(std::stoull(s.substr(start), nullptr, base));
        } catch (...) {
            return 0;
        }
    }
}

// Array types are spelled with a trailing "[]" (e.g. "int[]", "char[]").
bool isArrayType(const std::string& t) {
    return t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0;
}
// The element type of an array type ("int[]" -> "int"); identity if not an array.
std::string elementOf(const std::string& t) {
    return isArrayType(t) ? t.substr(0, t.size() - 2) : t;
}

// Floating-point types. `float`/`float32` lower to f32; `double`/`float64` to f64.
bool isFloatType(const std::string& t) {
    return t == "float" || t == "float32" || t == "double" || t == "float64" ||
           t == "smallfloat" || t == "quadruple";
}
bool isF32(const std::string& t) { return t == "float" || t == "float32"; }
// Bit width of a float type: smallfloat=16, float=32, double=64, quadruple=128.
unsigned floatBits(const std::string& t) {
    if (t == "smallfloat") return 16;
    if (t == "quadruple") return 128;
    if (t == "double" || t == "float64") return 64;
    return 32;  // float / float32
}

// Bit width of an integer-family type (int/char/boolean/enum default to 32).
unsigned intBits(const std::string& t) {
    if (t == "int8" || t == "uint8" || t == "byte" || t == "ubyte") return 8;
    if (t == "int16" || t == "uint16" || t == "short" || t == "ushort") return 16;
    if (t == "int64" || t == "uint64" || t == "long" || t == "address" || t == "ulong") return 64;
    return 32;
}

// Unsigned integer types. `byte` is int8 (signed) per spec 5.
bool isUnsigned(const std::string& t) {
    return t.rfind("uint", 0) == 0 || t == "address" || t == "ubyte" || t == "ushort" ||
           t == "ulong";
}

// Integer-family type names (matches the analyzer's isIntName).
bool isIntName(const std::string& t) {
    return t == "int" || t == "int8" || t == "int16" || t == "int32" || t == "int64" ||
           t == "uint8" || t == "uint16" || t == "uint32" || t == "uint64" || t == "short" ||
           t == "long" || t == "byte" || t == "address" || t == "ubyte" || t == "ushort" ||
           t == "uint" || t == "ulong";
}

// SIMD vector types vec2/vec3/vec4 (float32 elements). Returns the element count, or 0.
int vecWidth(const std::string& t) {
    if (t == "vec2") return 2;
    if (t == "vec3") return 3;
    if (t == "vec4") return 4;
    return 0;
}
// Named vector lane accessor: .x/.y/.z/.w (or .r/.g/.b/.a). Returns the index, or -1.
int vecLane(const std::string& m) {
    if (m == "x" || m == "r") return 0;
    if (m == "y" || m == "g") return 1;
    if (m == "z" || m == "b") return 2;
    if (m == "w" || m == "a") return 3;
    return -1;
}

// Approximate byte size of a type, used to size a union's shared storage.
// Pointers/refs/arrays/classes are pointer-sized.
unsigned byteSizeOf(const std::string& t) {
    if (isFloatType(t)) return floatBits(t) / 8;  // smallfloat=2 float=4 double=8 quadruple=16
    if (int w = vecWidth(t)) return static_cast<unsigned>(4 * w);  // vecN: N float32 elements
    if (!t.empty() && (t.back() == '*' || t.back() == '&' ||
                       (t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0)))
        return 8;  // pointer-sized (pointer / reference / array)
    if (isIntName(t)) return intBits(t) / 8;  // int family
    if (t == "char" || t == "boolean") return 4;  // i32-backed
    return 8;  // class / String / Object / reflection token -> array element is a pointer
}

// Pointer/reference types end with '*' or '&'; both lower to a plain pointer.
bool isRefType(const std::string& t) {
    return !t.empty() && (t.back() == '*' || t.back() == '&');
}

// Tuple types are spelled "(T0,T1,...)" (spec 22.5). They lower to an anonymous
// LLVM struct returned/passed by value.
bool isTupleType(const std::string& t) {
    return t.size() >= 2 && t.front() == '(' && t.back() == ')';
}
// Splits tuple components, honoring nested parentheses so commas inside a nested
// tuple don't split the outer one.
std::vector<std::string> tupleElems(const std::string& t) {
    std::vector<std::string> out;
    if (!isTupleType(t)) return out;
    int depth = 0;
    std::string cur;
    for (std::size_t i = 1; i + 1 < t.size(); ++i) {
        const char c = t[i];
        if (c == '(') ++depth;
        if (c == ')') --depth;
        if (c == ',' && depth == 0) {
            out.push_back(cur);
            cur.clear();
        } else {
            cur += c;
        }
    }
    if (!cur.empty()) out.push_back(cur);
    return out;
}
std::string baseType(const std::string& t) {
    std::string s = t;
    if (!s.empty() && s.back() == '?') s.pop_back();  // strip nullable marker (spec 3.7)
    if (!s.empty() && (s.back() == '*' || s.back() == '&')) s.pop_back();  // strip pointer/reference
    return s;
}

// The LDP3 type name of a declaration, including array / pointer / ref markers.
// Generic arguments are mangled into the name (Box<int> -> "Box$int").
std::string typeRefName(const ast::TypeRef& t) {
    return ast::mangleGeneric(t.name, t.typeArgs) + ast::arrayDimsSuffix(t.arrayDims) +
           (t.isPointer ? "*" : "") + (t.isRef ? "&" : "");
}

// Layout of a class: its LLVM struct, field indices/types, and method returns.
// Polymorphic classes (in a hierarchy) carry a vtable pointer at field 0.
struct ClassLayout {
    const ast::ClassDecl* decl = nullptr;  // source declaration (members in order)
    llvm::StructType* type = nullptr;
    std::unordered_map<std::string, unsigned> fieldIndex;  // includes inherited fields
    std::unordered_map<std::string, std::string> fieldType;  // LDP3 type name per field
    std::unordered_map<std::string, int> bitFieldWidth;  // field -> bit-field width (spec 11.1)
    std::unordered_set<std::string> volatileFields;  // fields whose accesses are volatile (spec 37.5)
    std::unordered_set<std::string> externalFields;  // `external` fields: associations, not owned (spec 37.1)
    // Lazy class-typed fields (spec 28.4): field name -> deferred initializer. Null in the
    // field means "not yet initialized" (the sentinel), so no extra flag is needed.
    std::unordered_map<std::string, const ast::Expr*> lazyFieldInit;
    std::unordered_map<std::string, std::string> methodReturnType;  // own methods only
    std::unordered_map<std::string, const ast::MethodDecl*> ownMethods;  // own methods, by name
    std::string superclass;
    std::vector<std::string> interfaces;
    std::vector<std::pair<std::string, std::string>> ownFields;  // (name, type), declaration order
    bool isAbstract = false;
    bool isInterface = false;
    bool isUnion = false;  // fields overlap one storage (C-style union)
    bool isMovable = false;
    bool isUnique = false;
    bool hasVtable = false;
    bool hasDestructor = false;
    std::vector<std::string> vtslots;          // virtual method names, in slot order
    llvm::GlobalVariable* vtable = nullptr;     // emitted vtable global (concrete classes)
    // Persistent instance fields (spec 18): they live in a per-variable disk-backed block,
    // not in the object. The object carries a pointer to its block at persistPtrIdx.
    llvm::StructType* persistBlock = nullptr;
    unsigned persistPtrIdx = 0;                 // struct index of the __persist pointer (0 = none)
    std::vector<std::string> persistOrder;      // persistent field names, in block order
};

// A local variable / parameter: its storage (an alloca) and LDP3 type name.
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

}  // namespace

struct CodeGenerator::Impl {
    const ast::Program& program;
    const EntryPoint& entry;
    std::vector<CodegenError>& errors;
    llvm::LLVMContext context;
    llvm::Module module;
    llvm::IRBuilder<> builder;

    std::unordered_map<std::string, ClassLayout> classes;
    // `newtype Name = Underlying;` (spec 24): a distinct type that shares the underlying's
    // representation, so codegen lowers it exactly like the underlying type.
    std::unordered_map<std::string, std::string> newtypes_;
    std::unordered_map<std::string, llvm::StructType*> tupleTypes;  // "(int,int)" -> { i32, i32 }
    // Global per-method-name vtable slots. Every distinct virtual method name gets
    // one stable index, and every polymorphic class's vtable is laid out by these
    // indices. Because LDP3 has no method overloading (unique name per method), a
    // call through a class OR any interface resolves to the same global slot, so a
    // class implementing several interfaces dispatches each one correctly.
    std::unordered_map<std::string, int> methodSlots;  // virtual method name -> global slot
    std::vector<std::string> methodSlotNames;          // global slot -> method name
    std::unordered_map<std::string, std::vector<std::string>> enums;  // name -> constants (ordinals)
    std::unordered_map<std::string, const ast::EnumDecl*> javaEnums;  // java-style enum decls
    // Catalog-implementing enums kept as enums (int-style ordinals) but carrying
    // method impls: name -> decl. Methods lower as `Enum.method(i32 this, ...)`.
    std::unordered_map<std::string, const ast::EnumDecl*> enumMethodDecls;
    std::unordered_map<std::string, llvm::Function*> functions;  // mangled -> fn
    std::unordered_map<std::string, llvm::GlobalVariable*> staticGlobals;  // "Class.field" -> global
    std::unordered_map<std::string, std::string> staticFieldType;  // "Class.field" -> LDP3 type
    // class -> its persistent instance field names (spec 18: object reattach via per-variable globals)
    std::unordered_map<std::string, std::unordered_set<std::string>> persistentInstanceFields;
    // set by a var-decl just before emitNew so the new object can wire up its persistent block
    std::string pendingPersistKey;
    int lambdaCounter = 0;  // unique names for lowered lambda functions
    std::unordered_map<std::string, std::string> literalReturnType;  // suffix -> return type
    std::unordered_map<std::string, std::string> externReturnType;   // extern C fn -> return type
    // Namespace-level compile-time constants (spec 28.1), folded once up front.
    std::unordered_map<std::string, std::string> namespaceConstTypes;  // const name -> LDP3 type
    std::unordered_map<std::string, long long> constIntVals;           // int/bool/char value
    std::unordered_map<std::string, double> constDblVals;              // float/double value
    std::unordered_map<std::string, const ast::MethodDecl*> comptimeMethods;  // spec 28.3, by name
    std::unordered_map<std::string, LocalSlot> locals;
    std::vector<ScopeObject> scopeObjects;  // stack objects awaiting destructor calls
    // Region locals (spec 17.7): freed at the end of their lexical block unless
    // `eternal` or already released. Mirrors scopeObjects.
    struct RegionLocal { llvm::Value* slot; bool isEternal; std::string name; };
    std::vector<RegionLocal> scopeRegions;
    std::vector<const ast::Block*> deferred;  // defer blocks, run at scope end (LIFO)
    std::string currentClass;        // "" inside a static method / the entry point
    std::string currentDtorChain;    // base destructor to chain to (set only in a destructor body)
    llvm::Value* currentThis = nullptr;
    llvm::Function* currentFn = nullptr;
    llvm::Type* currentRetType = nullptr;
    // While re-emitting a `?.` node as a plain access inside its non-null branch, this points at
    // that node so its safe-navigation guard is skipped exactly once (nested ?. still guard).
    const ast::Expr* safeGuardNode_ = nullptr;
    // When emitting an async method's resume function, this is the ldp3_task* (the function's
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
    // Inside an `expecting { ... }` block (spec 30.18): a `return` stores into this slot and branches
    // to expectingEnd_ (the block is an expression, not a method return).
    llvm::Value* expectingSlot_ = nullptr;
    llvm::BasicBlock* expectingEnd_ = nullptr;
    const std::vector<ast::ExprPtr>* currentEnsures = nullptr;  // contracts: postconditions
    const std::vector<const ast::Expr*>* currentInvariants = nullptr;  // contracts: class + inherited invariants
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
    llvm::StructType* typeStructTy = nullptr;     // reflection Type layout (spec 31)
    llvm::StructType* methodStructTy = nullptr;   // reflection Method layout { ptr name, ptr fn }
    std::unordered_map<std::string, llvm::GlobalVariable*> typeGlobals;  // class name -> its Type global
    std::unordered_map<std::string, llvm::BasicBlock*> labelBlocks;  // `label name;` targets (comefrom)
    std::unordered_set<std::string> abstainedLabels;  // qualified labels named by some `abstainfrom`
    std::unordered_map<std::string, llvm::GlobalVariable*> abstainCounters;  // qualified label -> counter
    std::string scanClass_;   // (class, method) context while scanning for abstained labels, so the
    std::string scanMethod_;  // scan can build the same qualified "class.method.label" key as codegen
    std::string enclosingClass_;   // (class, method) of the function being emitted; set even for a
    std::string enclosingMethod_;  // static method (currentClass is "" there). For qualified labels.
    std::unordered_map<std::string, llvm::GlobalVariable*> instanceCounters;  // class -> live-instance count
    std::unordered_set<std::string> unimportableClasses;  // classes named by unimport/reimport (spec 30)
    std::unordered_map<std::string, llvm::GlobalVariable*> aliveFlags;  // class -> i32 alive flag (1=alive)
    llvm::GlobalVariable* fnTableGlobal = nullptr;  // all function addresses (for physical unload)
    long long fnTableCount = 0;
    std::vector<llvm::BasicBlock*> ehPadStack;   // active try landing pads (catchswitch blocks)
    llvm::Constant* ehThrowInfoCache = nullptr;  // shared carrier-ptr ThrowInfo (_TI1PEAX), lazy
    llvm::Constant* ehTypeDescCache = nullptr;   // shared carrier-ptr type descriptor, lazy

    Impl(const ast::Program& p, const EntryPoint& e, std::string_view name,
         std::vector<CodegenError>& errs)
        : program(p), entry(e), errors(errs), module(std::string(name), context), builder(context) {
        // newtypes (spec 24) lower to their underlying representation; index them up front so
        // llvmType resolves a newtype name to its underlying type everywhere.
        for (const ast::Bundle& b : program.bundles)
            for (const ast::Namespace& ns : b.namespaces)
                for (const ast::TypeAliasDecl& a : ns.typeAliases)
                    if (a.isNewtype) newtypes_[a.name] = typeRefName(a.target);
    }

    void error(std::string message, SourceLocation loc) {
        errors.push_back(CodegenError{std::move(message), loc});
    }

    // Anonymous LLVM struct for a tuple type "(T0,T1,...)", cached so the same
    // tuple type always maps to the same struct (LLVM identifies them by shape).
    llvm::StructType* tupleStructType(const std::string& t) {
        auto it = tupleTypes.find(t);
        if (it != tupleTypes.end()) return it->second;
        std::vector<llvm::Type*> elems;
        for (const std::string& e : tupleElems(t)) elems.push_back(llvmType(e));
        llvm::StructType* st = llvm::StructType::get(context, elems);
        tupleTypes[t] = st;
        return st;
    }

    // Resolve a `newtype` name (spec 24) to its underlying representation type, recursively. Other
    // types pass through unchanged. Used where the physical representation matters (casts, coercion)
    // but the free-function type predicates (intBits/isUnsigned/isFloatType) can't see newtypes_.
    std::string repType(const std::string& t) {
        auto it = newtypes_.find(t);
        return it == newtypes_.end() ? t : repType(it->second);
    }

    // float/float32 -> f32, double/float64 -> f64; class/array/pointer/ref ->
    // opaque pointer; int/boolean/char/enum -> iN; tuple -> anonymous struct.
    llvm::Type* llvmType(const std::string& t) {
        if (t == "void") return builder.getVoidTy();
        // `nullable T` (spec 3.7) lowers exactly like T -- it is a compile-time-only marker.
        if (!t.empty() && t.back() == '?') return llvmType(t.substr(0, t.size() - 1));
        if (isTupleType(t)) return tupleStructType(t);
        if (isFloatType(t)) {
            switch (floatBits(t)) {
                case 16: return builder.getHalfTy();           // smallfloat
                case 128: return llvm::Type::getFP128Ty(context);  // quadruple
                case 64: return builder.getDoubleTy();         // double / float64
                default: return builder.getFloatTy();          // float / float32
            }
        }
        if (int w = vecWidth(t))  // SIMD vec2/3/4 -> <N x float>
            return llvm::FixedVectorType::get(builder.getFloatTy(), static_cast<unsigned>(w));
        if (isArrayType(t) || isRefType(t)) return builder.getPtrTy();
        if (t == "region") return builder.getPtrTy();  // pointer to the region block
        if (t.rfind("function<", 0) == 0) return builder.getPtrTy();  // a function value (pointer)
        if (t == "String" || t == "string") return builder.getPtrTy();  // ptr to {i64 len, ptr data}
        if (t == "Type" || t == "Method") return builder.getPtrTy();  // reflection tokens (spec 31)
        if (t == "Object") return builder.getPtrTy();  // root reference type (spec 3.4)
        if (classes.count(t) > 0) return builder.getPtrTy();
        if (auto it = newtypes_.find(t); it != newtypes_.end()) return llvmType(it->second);
        return builder.getIntNTy(intBits(t));
    }

    // Adjusts a value to the target type: int->float widening, or integer
    // sign/zero-extend / truncate to the target bit width. Unsigned sources
    // zero-extend and use the unsigned int->float opcode.
    llvm::Value* coerce(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw) {
        if (v == nullptr) return v;
        const std::string from = repType(fromRaw), to = repType(toRaw);  // newtype -> underlying
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
            if (want < have) return builder.CreateTrunc(v, llvmType(to));
        }
        return v;
    }

    // Sign-extends or truncates an integer value to `bits`.
    llvm::Value* fitInt(llvm::Value* v, unsigned bits, bool uns = false) {
        const unsigned have = v->getType()->getIntegerBitWidth();
        if (have < bits) {
            return uns ? builder.CreateZExt(v, builder.getIntNTy(bits))
                       : builder.CreateSExt(v, builder.getIntNTy(bits));
        }
        if (have > bits) return builder.CreateTrunc(v, builder.getIntNTy(bits));
        return v;
    }

    // Terminates deterministically with a message (LDP3 has no UB): used by runtime checks
    // such as division by zero or out-of-bounds. Ends the current block.
    void emitPanic(const std::string& msg) {
        llvm::FunctionType* ft =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        builder.CreateCall(module.getOrInsertFunction("__ldp3_panic", ft),
                           {builder.CreateGlobalStringPtr(msg, ".panic")});
        builder.CreateUnreachable();
    }

    // Integer division/remainder with a defined result: division by zero (and the signed
    // INT_MIN / -1 overflow) panic instead of being UB.
    llvm::Value* emitIntDivRem(llvm::Value* l, llvm::Value* r, bool uns, bool rem) {
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
        emitPanic("integer division by zero or overflow");
        builder.SetInsertPoint(okBB);
        if (rem) return uns ? builder.CreateURem(l, r) : builder.CreateSRem(l, r);
        return uns ? builder.CreateUDiv(l, r) : builder.CreateSDiv(l, r);
    }

    // Defined float->int conversion (LDP3 has no undefined behaviour): saturating, so an
    // out-of-range value clamps to the integer min/max and NaN becomes 0, instead of the
    // poison `fptosi`/`fptoui` would produce. Hardware-supported -- no runtime cost.
    llvm::Value* fpToInt(llvm::Value* v, llvm::Type* intTy, bool uns) {
        return builder.CreateIntrinsic(
            uns ? llvm::Intrinsic::fptoui_sat : llvm::Intrinsic::fptosi_sat,
            {intTy, v->getType()}, {v});
    }

    // Explicit numeric conversion for cast<T>(expr): covers every direction,
    // including the narrowing ones the implicit `coerce` refuses (long->int,
    // float->int, f64->f32). Unsigned source/target selects zero-extension and
    // the unsigned int<->float opcodes.
    llvm::Value* emitCast(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw) {
        if (v == nullptr) return v;
        // A newtype shares its underlying's representation: cast by the underlying type (spec 24).
        const std::string from = repType(fromRaw);
        const std::string to = repType(toRaw);
        // Reference cast (class/Object/reflection token): a pointer reinterpret -- a no-op
        // with opaque pointers. No runtime type check yet (spec 31 downcasts).
        if (llvmType(to)->isPointerTy() && v->getType()->isPointerTy()) return v;
        // Raw int/address <-> pointer (low-level / freestanding, spec 17.8): a `cast<T*>(addr)`
        // or `cast<address>(ptr)` reinterprets between an integer address and a pointer.
        if (llvmType(to)->isPointerTy() && v->getType()->isIntegerTy())
            return builder.CreateIntToPtr(v, llvmType(to));
        if (llvmType(to)->isIntegerTy() && v->getType()->isPointerTy())
            return builder.CreatePtrToInt(v, llvmType(to));
        const bool toFloat = isFloatType(to);
        const bool fromFloat = isFloatType(from);
        if (toFloat) {
            llvm::Type* fty = llvmType(to);
            if (fromFloat) {
                if (v->getType() == fty) return v;
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

    // Coerce a value to a target LLVM type (numeric widen/narrow), e.g. when an
    // argument's static type is a subtype of the parameter type.
    llvm::Value* coerceToType(llvm::Value* v, llvm::Type* ty) {
        if (v == nullptr || ty == nullptr || v->getType() == ty) return v;
        llvm::Type* src = v->getType();
        if (ty->isFloatingPointTy()) {
            if (src->isIntegerTy()) return builder.CreateSIToFP(v, ty);  // int -> f32/f64
            if (src->isFloatingPointTy())
                return ty->getPrimitiveSizeInBits() > src->getPrimitiveSizeInBits()
                           ? builder.CreateFPExt(v, ty)     // widen
                           : builder.CreateFPTrunc(v, ty);  // narrow
            return v;
        }
        if (ty->isIntegerTy()) {
            if (src->isIntegerTy()) {
                const unsigned want = ty->getIntegerBitWidth();
                const unsigned have = src->getIntegerBitWidth();
                if (want > have) return builder.CreateSExt(v, ty);
                if (want < have) return builder.CreateTrunc(v, ty);
                return v;
            }
            if (src->isFloatingPointTy()) return fpToInt(v, ty, false);  // f -> int, saturating
        }
        return v;
    }

    // Masks a value to a member's bit-field width (spec 11.1): only the low N bits
    // are kept, so `f : 4 = 20` stores 4. No-op for a non-bit-field member. (Value
    // masking; physical bit-packing of the struct layout is a later refinement.)
    llvm::Value* maskBitField(llvm::Value* v, const std::string& className,
                              const std::string& field) {
        if (v == nullptr || !v->getType()->isIntegerTy()) return v;
        auto cit = classes.find(baseType(className));
        if (cit == classes.end()) return v;
        auto bit = cit->second.bitFieldWidth.find(field);
        if (bit == cit->second.bitFieldWidth.end()) return v;
        const unsigned w = static_cast<unsigned>(bit->second);
        const unsigned bits = v->getType()->getIntegerBitWidth();
        if (w == 0 || w >= bits) return v;  // covers the whole type -> nothing to mask
        return builder.CreateAnd(
            v, llvm::ConstantInt::get(v->getType(), llvm::APInt::getLowBitsSet(bits, w)),
            "bitfield");
    }

    // True if the lvalue denotes a `volatile` local or field (spec 37.5), so its
    // load/store must not be optimized away. Walks T*/T& field access too.
    bool isVolatileAccess(const ast::Expr& expr) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            auto it = locals.find(id->name);
            return it != locals.end() && it->second.isVolatile;
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
            // An object that lives in a `volatile region` (MMIO): every field access is volatile.
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get()))
                if (volatileObjects_.count(oid->name) > 0) return true;
            auto cit = classes.find(baseType(typeName(*mem->object)));
            return cit != classes.end() && cit->second.volatileFields.count(mem->member) > 0;
        }
        return false;
    }

    // The deferred initializer of lazy field `field` declared in `className` or one of
    // its superclasses (spec 28.4), or null if `field` is not a lazy field.
    const ast::Expr* lazyFieldInitOf(const std::string& className, const std::string& field) {
        for (std::string cur = baseType(className); !cur.empty();) {
            auto cit = classes.find(cur);
            if (cit == classes.end()) break;
            auto it = cit->second.lazyFieldInit.find(field);
            if (it != cit->second.lazyFieldInit.end()) return it->second;
            cur = cit->second.superclass;
        }
        return nullptr;
    }

    // Runs a heap object's destructor (virtually, if the class is polymorphic) and
    // frees it. The single lowering used by both `delete` and `cascade delete`.
    void emitDeleteObject(llvm::Value* objPtr, const std::string& cn) {
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
            builder.CreateCall(freeFn(), {objPtr});
            return;
        }
        if (cit != classes.end() && cit->second.hasDestructor)
            builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
        builder.CreateCall(freeFn(), {objPtr});
    }

    // The `cascade` universal prefix (spec 37.1): an operation propagated through an object's
    // owned graph. delete frees, println calls describe() on each node, validate checks invariants.
    enum class CascadeOp { Delete, Println, Validate };

    // Memoized per-(callsite, op, type) cascade helper functions, keyed "op|csid|Type". A fresh
    // family per call site lets each site bake in its own depth/types/except filters.
    std::unordered_map<std::string, llvm::Function*> cascadeFns_;
    std::unordered_map<std::string, llvm::Function*> cloneFns_;  // `cascade clone` helpers, keyed "csid|Type"
    int cascadeCsid_ = 0;  // unique id per cascade call site, so per-site filters never collide
    // `lazy region` (spec 37.3): the backing block is allocated on first object insertion, not at
    // the declaration. The slot holds null until then; the size/address expr is replayed on demand.
    std::unordered_set<std::string> lazyRegions_;
    std::unordered_map<std::string, const ast::Expr*> lazyRegionSize_;
    std::unordered_map<std::string, const ast::Expr*> lazyRegionAt_;
    // `volatile region` (spec 37.5, MMIO): region locals whose objects must be accessed volatilely,
    // and the object locals bound from `new ... in` such a region (their field accesses are volatile).
    std::unordered_set<std::string> volatileRegions_;
    std::unordered_set<std::string> volatileObjects_;
    // `lazy import` (spec 37.3): per-class "already loaded" flags; the class's onClassLoad runs on
    // the first instance instead of at boot.
    std::unordered_map<std::string, llvm::GlobalVariable*> lazyLoadFlags_;

    // True if class `cn` was brought in by `lazy import` (anywhere in the program).
    bool isLazyImport(const std::string& cn) {
        auto match = [&](const ast::ImportDecl& imp) {
            return imp.isLazy && !imp.path.empty() && imp.path.back() == cn;
        };
        for (const ast::ImportDecl& imp : program.imports)
            if (match(imp)) return true;
        for (const ast::Bundle& b : program.bundles)
            for (const ast::ImportDecl& imp : b.imports)
                if (match(imp)) return true;
        return false;
    }
    llvm::GlobalVariable* lazyLoadFlag(const std::string& cn) {
        auto it = lazyLoadFlags_.find(cn);
        if (it != lazyLoadFlags_.end()) return it->second;
        auto* g = new llvm::GlobalVariable(module, builder.getInt1Ty(), /*isConstant=*/false,
                                           llvm::GlobalValue::PrivateLinkage, builder.getInt1(false),
                                           "loaded." + cn);
        lazyLoadFlags_[cn] = g;
        return g;
    }

    // Emits (or returns the memoized) recursive helper `void(ptr obj, ptr visited, i32 depth)` that
    // applies `op` to one object and propagates through its owned children. The runtime visited-set
    // makes the walk safe on cyclic/shared graphs (spec 37.1 rule 2). Owned children are value-typed
    // class fields and non-`external` class pointers (rule 1); references, arrays and `external`
    // pointers are associations and skipped. depth: -1 = unlimited, 0 = stop, else decremented.
    llvm::Function* cascadeHelper(CascadeOp op, int csid, const std::string& cn,
                                  const ast::CascadeParams& params) {
        const std::string key =
            std::to_string(static_cast<int>(op)) + "|" + std::to_string(csid) + "|" + cn;
        if (auto it = cascadeFns_.find(key); it != cascadeFns_.end()) return it->second;

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
        llvm::Value* fresh = builder.CreateCall(ptrsetAddFn(), {setArg, objArg});
        llvm::BasicBlock* freshBB = llvm::BasicBlock::Create(context, "fresh", fn);
        builder.CreateCondBr(  // already visited (cycle / shared): stop
            builder.CreateICmpNE(fresh, builder.getInt32(0)), freshBB, retBB);
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
                if (cc == classes.end()) break;
                for (const auto& [fname, ftype] : cc->second.ownFields) {
                    if (!seen.insert(fname).second) continue;
                    if (ftype.find('&') != std::string::npos || isArrayType(ftype)) continue;
                    const bool isPtr = ftype.find('*') != std::string::npos;
                    if (isPtr && cc->second.externalFields.count(fname) > 0) continue;  // assoc
                    const std::string fcn = baseType(ftype);
                    if (classes.find(fcn) == classes.end()) continue;  // not a class field
                    if (!params.onlyTypes.empty() &&
                        std::find(params.onlyTypes.begin(), params.onlyTypes.end(), fcn) ==
                            params.onlyTypes.end())
                        continue;
                    if (std::find(params.exceptTypes.begin(), params.exceptTypes.end(), fcn) !=
                        params.exceptTypes.end())
                        continue;
                    auto idxIt = cit->second.fieldIndex.find(fname);
                    if (idxIt == cit->second.fieldIndex.end()) continue;
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
        if (op == CascadeOp::Delete) emitDeleteObject(objArg, cn);
        else if (op == CascadeOp::Println) emitCascadePrintln(objArg, cn);
        else if (op == CascadeOp::Validate) emitCascadeValidate(objArg, cn);

        // Recurse into the owned children when depth allows (0 = stop, -1 = unlimited).
        llvm::BasicBlock* recBB = llvm::BasicBlock::Create(context, "recurse", fn);
        llvm::BasicBlock* afterBB = llvm::BasicBlock::Create(context, "after", fn);
        builder.CreateCondBr(builder.CreateICmpNE(depthArg, builder.getInt32(0)), recBB, afterBB);
        builder.SetInsertPoint(recBB);
        llvm::Value* unlimited = builder.CreateICmpSLT(depthArg, builder.getInt32(0));
        llvm::Value* nextDepth = builder.CreateSelect(
            unlimited, depthArg, builder.CreateSub(depthArg, builder.getInt32(1)));
        for (const auto& [childPtr, fcn] : children)
            builder.CreateCall(cascadeHelper(op, csid, fcn, params), {childPtr, setArg, nextDepth});
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
        llvm::Value* set = builder.CreateCall(ptrsetNewFn(), {});
        builder.CreateCall(cascadeHelper(op, csid, cn, params),
                           {root, set, builder.getInt32(params.depth)});
        builder.CreateCall(ptrsetFreeFn(), {set});
    }

    // `cascade println` (spec 37.1): call the node's describe() to print it. Virtual when the class
    // is polymorphic, else a direct call. The analyzer requires a describe() on the root type.
    void emitCascadePrintln(llvm::Value* objPtr, const std::string& cn) {
        const ast::MethodDecl* m = findMethodDecl(cn, "describe");
        if (m == nullptr) return;  // no describe(): the analyzer already reported it
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
        if (auto fnit = functions.find(owner + ".describe");
            !owner.empty() && fnit != functions.end())
            builder.CreateCall(fnit->second, {objPtr});
    }

    std::unordered_map<std::string, std::vector<const ast::Expr*>> mergedInvariants_;
    // Invariants a class must satisfy: its own plus every ancestor's (spec 29). A subclass is bound
    // by the contracts of its base classes, so method/constructor exits check the full chain.
    const std::vector<const ast::Expr*>& classInvariants(const std::string& clsName) {
        auto it = mergedInvariants_.find(clsName);
        if (it != mergedInvariants_.end()) return it->second;
        std::vector<const ast::Expr*> merged;
        for (std::string cur = clsName; !cur.empty();) {
            auto cc = classes.find(cur);
            if (cc == classes.end()) break;
            if (cc->second.decl != nullptr)
                for (const ast::ExprPtr& inv : cc->second.decl->invariants) merged.push_back(inv.get());
            cur = cc->second.superclass;
        }
        return mergedInvariants_[clsName] = std::move(merged);
    }

    // `cascade validate` (spec 37.1): check the node's invariants (and inherited ones). The
    // invariant expressions reference `this`, so point currentThis/currentClass at this node.
    void emitCascadeValidate(llvm::Value* objPtr, const std::string& cn) {
        llvm::Value* savedThis = currentThis;
        const std::string savedClass = currentClass;
        currentThis = objPtr;
        currentClass = cn;
        for (std::string cur = cn; !cur.empty();) {
            auto cc = classes.find(cur);
            if (cc == classes.end()) break;
            if (cc->second.decl != nullptr)
                for (const ast::ExprPtr& inv : cc->second.decl->invariants)
                    emitContractCheck(*inv, "invariant");
            cur = cc->second.superclass;
        }
        currentThis = savedThis;
        currentClass = savedClass;
    }

    // `cascade clone` (spec 37.1): emits (or returns the memoized) helper `ptr(ptr src, ptr map,
    // i32 depth)` that deep-clones `src` and its owned graph. The original-to-clone map makes a
    // shared/cyclic graph clone once and keeps the same sharing. Owned children (value class fields
    // and non-`external` class pointers) are cloned and repointed; everything else (primitives,
    // arrays, `external` pointers) is left as the shallow memcpy copied it.
    llvm::Function* cloneHelper(int csid, const std::string& cn, const ast::CascadeParams& params) {
        const std::string key = std::to_string(csid) + "|" + cn;
        if (auto it = cloneFns_.find(key); it != cloneFns_.end()) return it->second;

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
        builder.CreateCall(memcpyFn(), {dst, srcArg, size});       // shallow copy
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
            if (cc == classes.end()) break;
            for (const auto& [fname, ftype] : cc->second.ownFields) {
                if (!seen.insert(fname).second) continue;
                if (ftype.find('&') != std::string::npos || isArrayType(ftype)) continue;
                const bool isPtr = ftype.find('*') != std::string::npos;
                if (isPtr && cc->second.externalFields.count(fname) > 0) continue;  // association
                const std::string fcn = baseType(ftype);
                if (classes.find(fcn) == classes.end()) continue;
                if (!params.onlyTypes.empty() &&
                    std::find(params.onlyTypes.begin(), params.onlyTypes.end(), fcn) ==
                        params.onlyTypes.end())
                    continue;
                if (std::find(params.exceptTypes.begin(), params.exceptTypes.end(), fcn) !=
                    params.exceptTypes.end())
                    continue;
                auto idxIt = cit->second.fieldIndex.find(fname);
                if (idxIt == cit->second.fieldIndex.end()) continue;
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

    // Top-level `cascade clone X into dest`: clone X's owned graph and store the new root in dest.
    void emitCascadeClone(llvm::Value* src, const std::string& cn, llvm::Value* destSlot, int csid,
                          const ast::CascadeParams& params) {
        llvm::Value* map = builder.CreateCall(ptrmapNewFn(), {});
        llvm::Value* clone = builder.CreateCall(cloneHelper(csid, cn, params),
                                                {src, map, builder.getInt32(params.depth)});
        builder.CreateCall(ptrmapFreeFn(), {map});
        if (destSlot != nullptr) builder.CreateStore(clone, destSlot);
    }

    // `cascade move` (spec 19.8): copy `src` (a `cn` object) into `region` (bump-
    // allocated), then recursively move the objects it owns by value composition,
    // repointing the copy's field pointers. Returns the moved object's new address.
    // The old objects are reclaimed when their source region is released.
    llvm::Value* emitCascadeMove(llvm::Value* src, const std::string& cn, const std::string& region,
                                 SourceLocation loc) {
        auto cit = classes.find(cn);
        if (cit == classes.end()) return src;  // not a class: leave the value as-is
        llvm::Value* dst = emitRegionBumpAlloc(region, cit->second.type, loc);
        if (dst == nullptr) return src;
        builder.CreateCall(memcpyFn(), {dst, src, sizeOf(cit->second.type)});
        std::unordered_set<std::string> seen;
        for (std::string cur = cn; !cur.empty();) {
            auto cc = classes.find(cur);
            if (cc == classes.end()) break;
            for (const auto& [fname, ftype] : cc->second.ownFields) {
                if (!seen.insert(fname).second) continue;
                if (ftype.find('*') != std::string::npos || ftype.find('&') != std::string::npos ||
                    isArrayType(ftype))
                    continue;  // an association: not moved (shared)
                const std::string fcn = baseType(ftype);
                if (classes.find(fcn) == classes.end()) continue;
                auto idxIt = cit->second.fieldIndex.find(fname);
                if (idxIt == cit->second.fieldIndex.end()) continue;
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
        if (body.statements.empty()) return nullptr;
        const auto* es = dynamic_cast<const ast::ExprStmt*>(body.statements.front().get());
        if (es == nullptr) return nullptr;
        const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get());
        if (call != nullptr && dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
            return call;
        }
        return nullptr;
    }

    std::string flattenCallee(const ast::Expr& expr) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) return id->name;
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
            const std::string base = flattenCallee(*mem->object);
            if (base.empty()) return "";
            return base + "." + mem->member;
        }
        return "";
    }

    // The class that defines `method`, searching up the superclass chain ("" if none).
    std::string methodOwner(const std::string& className, const std::string& method) {
        std::string cn = baseType(className);  // see through T* / T&
        while (!cn.empty()) {
            auto it = classes.find(cn);
            if (it == classes.end()) break;
            if (it->second.methodReturnType.count(method) > 0) return cn;
            cn = it->second.superclass;
        }
        return "";
    }

    // Fields in layout order: inherited (base-first), then own.
    std::vector<std::pair<std::string, std::string>> collectFields(const std::string& className) {
        std::vector<std::pair<std::string, std::string>> result;
        auto it = classes.find(className);
        if (it == classes.end()) return result;
        if (!it->second.superclass.empty()) result = collectFields(it->second.superclass);
        for (const auto& f : it->second.ownFields) result.push_back(f);
        return result;
    }

    // Every virtual method name this class participates in: its own instance
    // methods plus everything inherited from its superclass and interfaces.
    // Order is irrelevant now that slots are global; we just need the set.
    void collectVirtualNames(const std::string& className, std::vector<std::string>& out) {
        auto it = classes.find(className);
        if (it == classes.end()) return;
        const ClassLayout& l = it->second;
        if (!l.superclass.empty()) collectVirtualNames(l.superclass, out);
        for (const std::string& iface : l.interfaces) collectVirtualNames(iface, out);
        if (l.decl != nullptr) {
            for (const ast::MemberPtr& member : l.decl->members) {
                const auto* md = dynamic_cast<const ast::MethodDecl*>(member.get());
                if (md == nullptr || md->isStatic) continue;
                if (std::find(out.begin(), out.end(), md->name) == out.end()) out.push_back(md->name);
            }
        }
    }

    // The class's vtable laid out by global slot: vtslots[g] is the method name the
    // class provides at global slot g, or "" for slots it does not implement (those
    // become a null entry in the emitted vtable). Sized so an indirect call's GEP is
    // valid for every polymorphic class regardless of which methods it has.
    std::vector<std::string> computeSlots(const std::string& className) {
        std::vector<std::string> own;
        collectVirtualNames(className, own);
        std::vector<std::string> slots(methodSlotNames.size());
        for (const std::string& name : own) {
            auto sit = methodSlots.find(name);
            if (sit != methodSlots.end()) slots[sit->second] = name;
        }
        return slots;
    }

    // Mangled name of the most-derived concrete implementation of `method` at or
    // above `className` ("" if the slot is still abstract).
    std::string vtableImpl(const std::string& className, const std::string& method) {
        std::string c = className;
        while (!c.empty()) {
            auto it = classes.find(c);
            if (it == classes.end()) break;
            auto mit = it->second.ownMethods.find(method);
            if (mit != it->second.ownMethods.end() && !mit->second->isAbstract) {
                return c + "." + method;
            }
            c = it->second.superclass;
        }
        // No class in the chain provides it: fall back to an interface default method (spec 9).
        return interfaceDefaultImpl(className, method);
    }

    // Mangled name of a non-abstract default method `method` reachable through the interfaces of
    // `className` or its ancestors (spec 9), searched transitively. "" if none provides a default.
    std::string interfaceDefaultImpl(const std::string& className, const std::string& method) {
        for (std::string c = className; !c.empty();) {
            auto it = classes.find(c);
            if (it == classes.end()) break;
            for (const std::string& iface : it->second.interfaces) {
                auto iit = classes.find(iface);
                if (iit == classes.end()) continue;
                auto mit = iit->second.ownMethods.find(method);
                if (mit != iit->second.ownMethods.end() && !mit->second->isAbstract)
                    return iface + "." + method;
                std::string deeper = interfaceDefaultImpl(iface, method);  // interface extends interface
                if (!deeper.empty()) return deeper;
            }
            c = it->second.superclass;
        }
        return "";
    }

    // Mangled name of the most-derived declared destructor at or above `className`
    // ("" if no class in the hierarchy declares one). Used both for the virtual
    // destructor vtable slot and for derived->base destructor chaining.
    std::string dtorImpl(const std::string& className) {
        std::string c = className;
        while (!c.empty()) {
            auto it = classes.find(c);
            if (it == classes.end()) break;
            if (it->second.hasDestructor) return c + ".~" + c;
            c = it->second.superclass;
        }
        return "";
    }

    // The MethodDecl for `method` visible from `className` (for its signature).
    const ast::MethodDecl* findMethodDecl(const std::string& className, const std::string& method) {
        std::string c = className;
        while (!c.empty()) {
            auto it = classes.find(c);
            if (it == classes.end()) break;
            auto mit = it->second.ownMethods.find(method);
            if (mit != it->second.ownMethods.end()) return mit->second;
            for (const std::string& iface : it->second.interfaces) {
                const ast::MethodDecl* m = findMethodDecl(iface, method);
                if (m != nullptr) return m;
            }
            c = it->second.superclass;
        }
        return nullptr;
    }

    // The vtable slot for `method`. Slots are global per method name, so this is the
    // same whether the call goes through the class or any interface it implements.
    // The staticType is kept for the signature but no longer affects the index.
    int slotIndex(const std::string& staticType, const std::string& method) {
        (void)staticType;
        auto it = methodSlots.find(method);
        return it == methodSlots.end() ? -1 : it->second;
    }

    // Signature of an instance method as called through a vtable: (this, params) -> ret.
    llvm::FunctionType* methodFnType(const ast::MethodDecl* m) {
        std::vector<llvm::Type*> ptypes;
        ptypes.push_back(builder.getPtrTy());  // this
        for (const auto& p : m->params) ptypes.push_back(llvmType(typeRefName(p.type)));
        return llvm::FunctionType::get(llvmType(typeRefName(m->returnType)), ptypes, false);
    }

    // Type name of an expression. Assumes a valid AST (semantic analysis ran).
    std::string typeName(const ast::Expr& expr) {
        if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
            const std::int64_t v = parseIntLiteral(n->text);
            return (v >= INT32_MIN && v <= INT32_MAX) ? "int" : "long";
        }
        if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) return "null";
        if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
            std::string s = "function<" + typeRefName(lam->returnType);
            for (const auto& p : lam->params) s += "," + typeRefName(p.type);
            return s + ">";
        }
        if (const auto* mr = dynamic_cast<const ast::MethodRefExpr*>(&expr)) {
            const std::string st = baseType(typeName(*mr->object));
            const ast::MethodDecl* md = findMethodDecl(st, mr->method);
            if (md == nullptr) return "function<void>";
            std::string s = "function<" + typeRefName(md->returnType);
            for (const auto& p : md->params) s += "," + typeRefName(p.type);
            return s + ">";
        }
        if (const auto* old = dynamic_cast<const ast::OldExpr*>(&expr))
            return typeName(*old->inner);  // old(e) has e's type (spec 29)
        if (const auto* tup = dynamic_cast<const ast::TupleExpr*>(&expr)) {
            std::string s = "(";
            for (std::size_t i = 0; i < tup->elements.size(); ++i)
                s += (i ? "," : "") + typeName(*tup->elements[i]);
            return s + ")";
        }
        if (dynamic_cast<const ast::FloatLiteralExpr*>(&expr) != nullptr) return "double";
        if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
        if (dynamic_cast<const ast::StringLiteralExpr*>(&expr) != nullptr) return "string";
        if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) return "boolean";
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            if (id->name == "this") return currentClass;
            auto it = locals.find(id->name);
            if (it != locals.end()) return it->second.type;
            if (auto cit = namespaceConstTypes.find(id->name); cit != namespaceConstTypes.end())
                return cit->second;
            return "int";
        }
        if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
            if (un->op == "&") return typeName(*un->operand) + "*";  // address-of
            if (un->op == "~") return typeName(*un->operand);  // bitwise not keeps the width
            return un->op == "!" ? "boolean" : "int";
        }
        if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
            const std::string t = baseType(typeName(*aw->operand));  // Task$X -> X
            return t.rfind("Task$", 0) == 0 ? t.substr(5) : t;
        }
        if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(&expr)) {
            // spec 30.18: the validation value's type is what the expecting block returns.
            if (ue->expecting != nullptr)
                for (const auto& s : ue->expecting->statements)
                    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s.get());
                        rs != nullptr && rs->value != nullptr)
                        return typeName(*rs->value);
            return "int";
        }
        if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
            // Value type is the arms' common type, computed by sema (bindings in scope).
            if (!me->resultType.empty()) return me->resultType;
            if (!me->cases.empty() && me->cases[0].result) return typeName(*me->cases[0].result);
            if (me->defaultResult) return typeName(*me->defaultResult);
            return "int";
        }
        if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
            return typeName(*tern->thenExpr);
        }
        if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&expr)) {  // a ?? b
            auto nullable = [](const std::string& s) { return !s.empty() && s.back() == '?'; };
            const std::string lt = typeName(*nc->lhs);
            const std::string base = nullable(lt) ? lt.substr(0, lt.size() - 1) : lt;
            return nullable(typeName(*nc->rhs)) ? base + "?" : base;
        }
        if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
            const std::string& op = bin->op;
            // Operator overloading: result type is the operator method's return type.
            const std::string oowner = methodOwner(baseType(typeName(*bin->lhs)), "operator" + op);
            if (!oowner.empty()) return classes[oowner].methodReturnType["operator" + op];
            if (op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=" ||
                op == "&&" || op == "||") {
                return "boolean";
            }
            const std::string lt = typeName(*bin->lhs);
            const std::string rt = typeName(*bin->rhs);
            if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) return "vec" + std::to_string(vw);
            if (isFloatType(lt) || isFloatType(rt)) {  // f32 only if both are f32
                const bool f64 = (isFloatType(lt) && !isF32(lt)) || (isFloatType(rt) && !isF32(rt));
                return f64 ? "double" : "float";
            }
            // Arithmetic result: the wider operand's width; unsigned is contagious.
            const unsigned w = std::max(intBits(lt), intBits(rt));
            const bool u = isUnsigned(lt) || isUnsigned(rt);
            if (w == 8) return u ? "uint8" : "int8";
            if (w == 16) return u ? "uint16" : "int16";
            if (w == 64) return u ? "ulong" : "long";
            return u ? "uint32" : "int";
        }
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
            return ast::mangleGeneric(nw->className, nw->typeArgs);
        }
        if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
            return na->elementType + "[]";
        }
        if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(&expr)) {  // [a,b,c] (spec 25)
            return (al->elements.empty() ? std::string("int") : typeName(*al->elements[0])) + "[]";
        }
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
            const std::string at = typeName(*ix->array);
            if (vecWidth(at) > 0) return "float";  // v[i] on a SIMD vector
            const std::string owner = methodOwner(baseType(at), "operator[]");
            if (!owner.empty()) return classes[owner].methodReturnType["operator[]"];
            if (isRefType(at)) return baseType(at);  // p[i] on a raw pointer T* -> T
            return isArrayType(at) ? at.substr(0, at.size() - 2) : std::string("int");
        }
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
            if (int w = vecWidth(flattenCallee(*call->callee)); w > 0)
                return flattenCallee(*call->callee);  // vec2/3/4 construction
            if (flattenCallee(*call->callee) == "reflect.typeOf") return "Type";  // spec 31
            if (flattenCallee(*call->callee) == "Memory.readString") return "String";  // StringBuilder
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Time.", 0) == 0) {
                if (fc == "Time.millis" || fc == "Time.nanos" || fc == "Time.unixMillis")
                    return "long";  // spec 34
                if (fc == "Time.sleep") return "void";
            }
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Net.", 0) == 0) {
                if (fc == "Net.recv") return "String";  // spec 34
                if (fc == "Net.connect" || fc == "Net.send") return "long";
                if (fc == "Net.close") return "void";
            }
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("File.", 0) == 0) {
                if (fc == "File.readAll") return "String";  // spec 34.4
                if (fc == "File.writeAll" || fc == "File.appendAll" || fc == "File.exists" ||
                    fc == "File.remove")
                    return "boolean";
            }
            if (const std::string mc = flattenCallee(*call->callee); mc.rfind("Math.", 0) == 0) {
                const std::string fn = mc.substr(5);  // only the builtin Math.* (spec 34.6) -> double
                if (fn == "sqrt" || fn == "abs" || fn == "floor" || fn == "ceil" || fn == "round" ||
                    fn == "trunc" || fn == "sin" || fn == "cos" || fn == "exp" || fn == "log" ||
                    fn == "pow" || fn == "min" || fn == "max" || fn == "tan" || fn == "asin" ||
                    fn == "acos" || fn == "atan" || fn == "sinh" || fn == "cosh" || fn == "tanh" ||
                    fn == "cbrt" || fn == "log2" || fn == "log10" || fn == "atan2" ||
                    fn == "hypot" || fn == "clamp" || fn == "lerp")
                    return "double";
            }
            if (auto er = externReturnType.find(flattenCallee(*call->callee));
                er != externReturnType.end())
                return er->second;  // external C function (spec 26)
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                if (mem->member == "length" && isArrayType(typeName(*mem->object))) return "int";
                if (const std::string ot = typeName(*mem->object); ot == "String" || ot == "string") {
                    if (mem->member == "length" || mem->member == "indexOf") return "int";
                    if (mem->member == "charAt") return "char";
                    if (mem->member == "isEmpty" || mem->member == "equals" ||
                        mem->member == "contains" || mem->member == "startsWith" ||
                        mem->member == "endsWith")
                        return "boolean";
                    if (mem->member == "concat" || mem->member == "substring" ||
                        mem->member == "toUpper" || mem->member == "toLower" ||
                        mem->member == "trim" || mem->member == "repeat" ||
                        mem->member == "toString")
                        return "String";
                    if (mem->member == "hash") return "long";
                    if (mem->member == "equalsKey") return "boolean";
                    if (mem->member == "compareTo") return "int";
                }
                // Integer keys: Hashable/Comparable builtins (collections) + toString (itoa).
                if (const std::string ot = typeName(*mem->object); isIntName(ot)) {
                    if (mem->member == "hash") return "long";
                    if (mem->member == "equalsKey") return "boolean";
                    if (mem->member == "compareTo") return "int";
                    if (mem->member == "toString") return "String";
                }
                if (typeName(*mem->object) == "Type") {
                    if (mem->member == "name" || mem->member == "methodName" ||
                        mem->member == "fieldName")
                        return "String";
                    if (mem->member == "methodCount" || mem->member == "fieldCount") return "int";
                    if (mem->member == "method") return "Method";
                    if (mem->member == "instantiate") return "Object";
                    if (mem->member == "methods" || mem->member == "fields") return "ArrayList$String";
                }
                if (typeName(*mem->object) == "Method") {
                    if (mem->member == "name") return "String";
                    if (mem->member == "invoke") return "void";
                    if (mem->member == "firstByte") return "int";
                }
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                    if (enums.count(oid->name) > 0) {
                        if (mem->member == "count") return "int";
                        if (mem->member == "values") return oid->name + "[]";
                    }
                }
                // Enum (catalog) instance method: m.pick() -> the method's return type.
                if (auto eit = enumMethodDecls.find(baseType(typeName(*mem->object)));
                    eit != enumMethodDecls.end()) {
                    for (const ast::MemberPtr& member : eit->second->members) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m != nullptr && m->name == mem->member) return typeRefName(m->returnType);
                    }
                }
                // instance: search the object's hierarchy; static: the named class.
                std::string owner = methodOwner(typeName(*mem->object), mem->member);
                if (owner.empty() && classes.count(flattenCallee(*mem->object)) > 0) {
                    owner = methodOwner(flattenCallee(*mem->object), mem->member);
                }
                if (!owner.empty()) {
                    const std::string rt = classes[owner].methodReturnType[mem->member];
                    // An async method call yields a Task<returnType> (spec 20.2).
                    const ast::MethodDecl* md = findMethodDecl(owner, mem->member);
                    if (md != nullptr && md->isAsync) return ast::mangleGeneric("Task", {rt});
                    return rt;
                }
            }
            // Namespace-level literal suffix function: name(arg).
            auto lit = literalReturnType.find(flattenCallee(*call->callee));
            if (lit != literalReturnType.end()) return lit->second;
            return "int";
        }
        if (dynamic_cast<const ast::RegionInitExpr*>(&expr) != nullptr) return "region";
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
            if (vecWidth(typeName(*mem->object)) > 0 && vecLane(mem->member) >= 0)
                return "float";  // v.x / v.y / v.z / v.w
            if (const std::string key = staticFieldKey(*mem); !key.empty()) {
                return staticFieldType[key];
            }
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (locals.find(objId->name) == locals.end() && enums.count(objId->name) > 0) {
                    return objId->name;  // EnumName.CONSTANT -> the enum type
                }
            }
            const std::string ot = baseType(typeName(*mem->object));
            auto cit = classes.find(ot);
            if (cit != classes.end()) {
                auto ft = cit->second.fieldType.find(mem->member);
                if (ft != cit->second.fieldType.end()) return ft->second;
            }
            // Computed get-only property read as obj.name -> the getter's return type.
            if (const ast::MethodDecl* pm = findMethodDecl(ot, mem->member);
                pm != nullptr && pm->isProperty) {
                const std::string owner = methodOwner(ot, mem->member);
                if (!owner.empty()) return classes[owner].methodReturnType[mem->member];
            }
            return "int";
        }
        if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) return cst->targetType;
        if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr))
            return mv->castType.empty() ? typeName(*mv->operand) : mv->castType;
        if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
            const std::string ot = baseType(typeName(*tx->operand));  // Result$T$E / Option$T
            const auto p = ot.find('$');
            if (p == std::string::npos) return "int";
            const std::string rest = ot.substr(p + 1);
            const auto q = rest.find('$');
            return q == std::string::npos ? rest : rest.substr(0, q);  // T (the value type)
        }
        return "int";
    }

    llvm::FunctionCallee printf() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, /*isVarArg=*/true);
        return module.getOrInsertFunction("printf", ty);
    }

    llvm::FunctionCallee scanf() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, /*isVarArg=*/true);
        return module.getOrInsertFunction("scanf", ty);
    }

    llvm::FunctionCallee exitFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt32Ty()}, false);
        return module.getOrInsertFunction("exit", ty);
    }

    // Contracts (spec 29): if the boolean condition is false at runtime, report and exit(1).
    // Collects every old(...) occurrence inside a contract expression so the entry-time values can
    // be captured before the body runs (spec 29).
    void collectOld(const ast::Expr* e, std::vector<const ast::OldExpr*>& out) {
        if (e == nullptr) return;
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
            for (const auto& a : c->args) collectOld(a.get(), out);
        } else if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
            collectOld(ix->array.get(), out);
            collectOld(ix->index.get(), out);
        } else if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
            collectOld(ca->operand.get(), out);
        }
    }

    void emitContractCheck(const ast::Expr& cond, const char* kind) {
        llvm::Value* c = emitExpr(cond);
        if (c == nullptr) return;
        llvm::Value* ok = builder.CreateICmpNE(c, builder.getInt32(0), "contract.ok");
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* failBB = llvm::BasicBlock::Create(context, "contract.fail", fn);
        llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "contract.cont", fn);
        builder.CreateCondBr(ok, contBB, failBB);
        builder.SetInsertPoint(failBB);
        const std::string msg = std::string("contract violated: ") + kind + "\n";
        builder.CreateCall(printf(), {builder.CreateGlobalStringPtr(msg, ".contract")});
        builder.CreateCall(exitFn(), {builder.getInt32(1)});
        builder.CreateUnreachable();
        builder.SetInsertPoint(contBB);
    }

    llvm::FunctionCallee mallocFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("malloc", ty);
    }
    llvm::FunctionCallee reallocFn() {  // realloc(ptr, size) -> ptr (for array resize, spec 25)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("realloc", ty);
    }

    llvm::FunctionCallee freeFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("free", ty);
    }

    // sizeof(type) in bytes, the target-portable way: gep null + 1, then
    // ptrtoint. The backend folds it to a constant using the real data layout.
    llvm::Value* sizeOf(llvm::Type* type) {
        llvm::Value* gep = builder.CreateConstGEP1_64(
            type, llvm::ConstantPointerNull::get(builder.getPtrTy()), 1);
        return builder.CreatePtrToInt(gep, builder.getInt64Ty());
    }

    llvm::FunctionCallee memsetFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt32Ty(), builder.getInt64Ty()},
            false);
        return module.getOrInsertFunction("memset", ty);
    }

    llvm::FunctionCallee memcpyFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty()},
            false);
        return module.getOrInsertFunction("memcpy", ty);
    }

    // Cascade cycle-detection visited-set (spec 37.1, rule 2): new/add/free over object addresses.
    llvm::FunctionCallee ptrsetNewFn() {
        return module.getOrInsertFunction(
            "__ldp3_ptrset_new", llvm::FunctionType::get(builder.getPtrTy(), {}, false));
    }
    llvm::FunctionCallee ptrsetFreeFn() {
        return module.getOrInsertFunction(
            "__ldp3_ptrset_free",
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false));
    }
    llvm::FunctionCallee ptrsetAddFn() {  // returns 1 if newly added, 0 if already seen
        return module.getOrInsertFunction(
            "__ldp3_ptrset_add", llvm::FunctionType::get(builder.getInt32Ty(),
                                                         {builder.getPtrTy(), builder.getPtrTy()},
                                                         false));
    }

    // Original-to-clone map for `cascade clone` (spec 37.1): new/free/get/put.
    llvm::FunctionCallee ptrmapNewFn() {
        return module.getOrInsertFunction(
            "__ldp3_ptrmap_new", llvm::FunctionType::get(builder.getPtrTy(), {}, false));
    }
    llvm::FunctionCallee ptrmapFreeFn() {
        return module.getOrInsertFunction(
            "__ldp3_ptrmap_free",
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false));
    }
    llvm::FunctionCallee ptrmapGetFn() {  // returns the clone, or null if not yet cloned
        return module.getOrInsertFunction(
            "__ldp3_ptrmap_get", llvm::FunctionType::get(builder.getPtrTy(),
                                                         {builder.getPtrTy(), builder.getPtrTy()},
                                                         false));
    }
    llvm::FunctionCallee ptrmapPutFn() {
        return module.getOrInsertFunction(
            "__ldp3_ptrmap_put",
            llvm::FunctionType::get(
                builder.getVoidTy(),
                {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, false));
    }

    llvm::FunctionCallee strcmpFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getInt32Ty(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("strcmp", ty);
    }
    // FNV-1a hash of a string's bytes (runtime helper), for Hashable<String>.
    llvm::FunctionCallee strHashFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getInt64Ty(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__ldp3_str_hash", ty);
    }
    // itoa runtime helper (writes decimal digits to a buffer, returns length), for int.toString().
    llvm::FunctionCallee itoaFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getInt64Ty(), {builder.getInt64Ty(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_itoa", ty);
    }

    // Builds a String object on the heap from a length and a null-terminated byte buffer.
    llvm::Value* emitStringFromParts(llvm::Value* len, llvm::Value* data) {
        llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(stringType())}, "newstr");
        builder.CreateStore(len, builder.CreateStructGEP(stringType(), obj, 0));
        builder.CreateStore(data, builder.CreateStructGEP(stringType(), obj, 1));
        return obj;
    }
    // Loads the i64 length field of a String object.
    llvm::Value* stringLen(llvm::Value* strObj) {
        return builder.CreateLoad(builder.getInt64Ty(),
                                  builder.CreateStructGEP(stringType(), strObj, 0, "str.len"), "len");
    }

    // A class value (not a pointer/ref, not an array, not a primitive/enum).
    bool isClassValue(const std::string& t) {
        // A Java-style enum value is a reference to a shared singleton (spec 12.2), not a value to
        // be copied -- copying it would break identity (== / !=).
        return !isRefType(t) && !isArrayType(t) && classes.count(t) > 0 && javaEnums.count(t) == 0;
    }

    // Only the default discipline copies; movable/unique transfer the pointer.
    bool isCopyDiscipline(const std::string& t) {
        auto it = classes.find(baseType(t));
        return it != classes.end() && !it->second.isMovable && !it->second.isUnique;
    }

    // An existing object that a value copy must duplicate (vs. a fresh `new`).
    bool isCopyableLValue(const ast::Expr& e) {
        return dynamic_cast<const ast::IdentifierExpr*>(&e) != nullptr ||
               dynamic_cast<const ast::MemberExpr*>(&e) != nullptr;
    }

    // Duplicates an array block [ i64 length | elems... ] into a fresh heap block
    // so a value copy does not share the elements. Elements are 4 bytes in 0.1.
    llvm::Value* emitArrayDup(llvm::Value* srcBlock, const std::string& elemType) {
        llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), srcBlock, "arr.len");
        llvm::Value* total = builder.CreateAdd(
            builder.getInt64(8), builder.CreateMul(len, builder.getInt64(byteSizeOf(elemType))));
        llvm::Value* newBlock = builder.CreateCall(mallocFn(), {total}, "arr.copy");
        builder.CreateCall(memcpyFn(), {newBlock, srcBlock, total});
        return newBlock;
    }

    // Allocates a fresh struct and copies srcPtr into it (deep value copy): the
    // bytes are memcpy'd first, then each field that owns its storage -- arrays
    // and value sub-objects -- is duplicated so the two objects share nothing.
    // Pointer/reference fields are shared on purpose; primitives copy inline.
    llvm::Value* emitClassCopy(const std::string& className, llvm::Value* srcPtr, bool heap = false) {
        auto cit = classes.find(className);
        if (cit == classes.end()) return srcPtr;
        llvm::StructType* st = cit->second.type;
        // A copy bound to a field must outlive the current frame -> heap; a copy bound to a local
        // can live in the frame -> stack.
        llvm::Value* dest = heap ? builder.CreateCall(mallocFn(), {sizeOf(st)}, className + ".copy")
                                 : createEntryAlloca(className + ".copy", st);
        builder.CreateCall(memcpyFn(), {dest, srcPtr, sizeOf(st)});  // shallow copy first
        for (const auto& [fname, ftype] : collectFields(className)) {
            const unsigned idx = cit->second.fieldIndex[fname];
            llvm::Value* deep = nullptr;
            if (isArrayType(ftype)) {
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitArrayDup(builder.CreateLoad(builder.getPtrTy(), srcSlot), elementOf(ftype));
            } else if (isClassValue(ftype) && isCopyDiscipline(ftype)) {
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitClassCopy(ftype, builder.CreateLoad(builder.getPtrTy(), srcSlot), heap);
            }
            if (deep != nullptr) builder.CreateStore(deep, builder.CreateStructGEP(st, dest, idx));
        }
        return dest;
    }

    // Array memory layout: one heap block [ i64 length | elem 0 | elem 1 | ... ].
    // The array value is a pointer to the length header (element count); elements
    // start 8 bytes in and are sized by the element type.
    llvm::Value* arrayData(llvm::Value* block) {
        return builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "arr.data");
    }
    llvm::Value* arrayElemPtr(llvm::Value* block, llvm::Value* index, llvm::Type* elemTy) {
        llvm::Value* idx = index->getType()->isIntegerTy(64)
                               ? index
                               : builder.CreateSExt(index, builder.getInt64Ty());
        // Bounds check (no UB): one unsigned compare catches both index < 0 and index >= length.
        // The length load and data base are loop-invariant, so LICM hoists them; LLVM elides the
        // compare itself where it can prove the index in range.
        llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), block, "arr.len");
        llvm::Value* oob = builder.CreateICmpUGE(idx, len, "arr.oob");
        llvm::Function* f = currentFn;
        auto* badBB = llvm::BasicBlock::Create(context, "idx.bad", f);
        auto* okBB = llvm::BasicBlock::Create(context, "idx.ok", f);
        builder.CreateCondBr(oob, badBB, okBB, coldBranchWeights());
        builder.SetInsertPoint(badBB);
        emitPanic("array index out of bounds");
        builder.SetInsertPoint(okBB);
        return builder.CreateGEP(elemTy, arrayData(block), idx, "arr.elem");
    }

    // Branch weights marking the true (panic) edge as cold, so the optimizer keeps the hot
    // path straight-line and the predictor assumes in-bounds.
    llvm::MDNode* coldBranchWeights() {
        llvm::MDBuilder mdb(context);
        return mdb.createBranchWeights(1, 1u << 20);
    }

    llvm::Value* emitNewArray(const ast::NewArrayExpr& na) {
        llvm::Value* n = emitExpr(*na.size);
        if (n == nullptr) return nullptr;
        llvm::Value* n64 = builder.CreateSExt(n, builder.getInt64Ty());
        const unsigned esz = byteSizeOf(na.elementType);  // real element width (1/2/4/8 bytes)
        llvm::Value* elemBytes = builder.CreateMul(n64, builder.getInt64(esz));
        llvm::Value* total = builder.CreateAdd(builder.getInt64(8), elemBytes);
        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "arr");
        builder.CreateStore(n64, block);  // length header (element count)
        builder.CreateCall(memsetFn(), {arrayData(block), builder.getInt32(0), elemBytes});
        return block;
    }

    // `[a, b, c]` (spec 25): allocate an array block of n elements and store each. Same layout as
    // emitNewArray ([i64 length][elements]); stores bypass the bounds check (indices are known).
    llvm::Value* emitArrayLiteral(const ast::ArrayLiteralExpr& al) {
        const std::size_t n = al.elements.size();
        const std::string elemType = n > 0 ? typeName(*al.elements[0]) : "int";
        const unsigned esz = byteSizeOf(elemType);
        llvm::Value* block = builder.CreateCall(
            mallocFn(), {builder.getInt64(8 + static_cast<std::uint64_t>(n) * esz)}, "arrlit");
        builder.CreateStore(builder.getInt64(static_cast<std::uint64_t>(n)), block);  // length header
        llvm::Type* et = llvmType(elemType);
        llvm::Value* data = arrayData(block);
        for (std::size_t i = 0; i < n; ++i) {
            llvm::Value* v = emitExpr(*al.elements[i]);
            if (v == nullptr) continue;
            v = coerce(v, typeName(*al.elements[i]), elemType);  // widen/convert to element type
            builder.CreateStore(v, builder.CreateGEP(et, data, builder.getInt64(i)));
        }
        return block;
    }

    llvm::Value* createEntryAlloca(const std::string& name, llvm::Type* type) {
        llvm::BasicBlock& entryBB = currentFn->getEntryBlock();
        llvm::IRBuilder<> tmp(&entryBB, entryBB.begin());
        return tmp.CreateAlloca(type, nullptr, name);
    }

    // Pointer to the struct of an object expression (`this` or a class variable).
    // If `mem` is a static-field reference `ClassName.field` (the receiver names a
    // class, not a local), returns its mangled key "Class.field"; otherwise "".
    std::string staticFieldKey(const ast::MemberExpr& mem) {
        const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem.object.get());
        if (objId == nullptr || objId->name == "this") return "";
        if (locals.find(objId->name) != locals.end()) return "";
        const std::string key = objId->name + "." + mem.member;
        return staticGlobals.count(key) > 0 ? key : std::string();
    }

    // The in-process persistent block for an identity key (one per variable that binds a
    // persistent-bearing object). A private global, created lazily; survives delete within a run.
    llvm::GlobalVariable* getPersistBlock(const std::string& key, llvm::StructType* blockTy) {
        const std::string gname = key + ".__pblock";
        if (staticGlobals.count(gname) == 0) {
            staticGlobals[gname] = new llvm::GlobalVariable(
                module, blockTy, /*isConstant=*/false, llvm::GlobalValue::PrivateLinkage,
                llvm::Constant::getNullValue(blockTy), gname);
        }
        return staticGlobals[gname];
    }

    // Object reattach (spec 18.2): address of a persistent instance field, reached through the
    // object's __persist pointer -- so this.field (in methods/ctor) and var.field both work, and
    // the field survives `delete` (it lives in the block, not the object). Null if `mem` is not
    // a persistent instance field access.
    llvm::Value* persistentFieldPtr(const ast::MemberExpr& mem) {
        const std::string cls = baseType(typeName(*mem.object));
        auto cit = classes.find(cls);
        if (cit == classes.end() || cit->second.persistPtrIdx == 0) return nullptr;
        const auto& order = cit->second.persistOrder;
        auto pos = std::find(order.begin(), order.end(), mem.member);
        if (pos == order.end()) return nullptr;  // not a persistent field
        llvm::Value* objPtr = emitObjectPtr(*mem.object);
        if (objPtr == nullptr) return nullptr;
        llvm::Value* slot = builder.CreateStructGEP(cit->second.type, objPtr,
                                                    cit->second.persistPtrIdx, "__persist");
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "pblock");
        const auto fidx = static_cast<unsigned>(pos - order.begin());
        return builder.CreateStructGEP(cit->second.persistBlock, block, fidx, mem.member);
    }

    llvm::FunctionCallee lazyLockFn() {
        return module.getOrInsertFunction("__ldp3_lazy_lock",
                                          llvm::FunctionType::get(builder.getVoidTy(), {}, false));
    }
    llvm::FunctionCallee lazyUnlockFn() {
        return module.getOrInsertFunction("__ldp3_lazy_unlock",
                                          llvm::FunctionType::get(builder.getVoidTy(), {}, false));
    }

    // Runs a lazy local's deferred initializer the first time it is read (spec 37.3). Thread-safe
    // by default via double-checked locking: the fast path is a plain flag read, and only the first
    // initialization takes the process-wide lazy lock and rechecks, so concurrent first-accesses
    // initialize exactly once. A no-op for non-lazy locals.
    void ensureLazy(llvm::Value* flag, const ast::Expr* init, llvm::Value* storage,
                    const std::string& type, const std::string& name) {
        if (flag == nullptr || init == nullptr) return;
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
            if (isClassValue(type) && isCopyDiscipline(type) && isCopyableLValue(*init))
                initV = emitClassCopy(type, initV);
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

    llvm::Value* emitObjectPtr(const ast::Expr& expr) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            if (id->name == "this") return currentThis;
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

    // Address (pointer) of an assignable expression.
    llvm::Value* emitLValue(const ast::Expr& expr) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            auto it = locals.find(id->name);
            if (it == locals.end()) {
                error("use of undeclared variable '" + id->name + "'", id->loc);
                return nullptr;
            }
            return it->second.storage;
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
            if (const std::string key = staticFieldKey(*mem); !key.empty()) {
                return staticGlobals[key];  // the global itself is the address
            }
            if (llvm::Value* pp = persistentFieldPtr(*mem)) {
                return pp;  // persistent instance field: address inside the object's block
            }
            llvm::Value* objPtr = emitObjectPtr(*mem->object);
            if (objPtr == nullptr) return nullptr;
            auto cit = classes.find(baseType(typeName(*mem->object)));  // see through T* / T&
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
            if (block == nullptr) return nullptr;
            llvm::Value* index = emitExpr(*ix->index);
            if (index == nullptr) return nullptr;
            const std::string at = typeName(*ix->array);
            // Raw pointer index p[i] (spec 17.8): unchecked GEP, no array header / bounds check.
            if (isRefType(at)) {
                llvm::Value* i = index->getType()->isIntegerTy(64)
                                     ? index
                                     : builder.CreateSExt(index, builder.getInt64Ty());
                return builder.CreateGEP(llvmType(baseType(at)), block, i, "ptr.elem");
            }
            return arrayElemPtr(block, index, llvmType(elementOf(at)));
        }
        error("invalid assignment target", expr.loc);
        return nullptr;
    }

    // The String object layout: { i64 length, ptr data }. Lazily created.
    llvm::StructType* stringType() {
        if (stringStructTy == nullptr)
            stringStructTy =
                llvm::StructType::create(context, {builder.getInt64Ty(), builder.getPtrTy()}, "String");
        return stringStructTy;
    }

    // Materializes an immutable String object as a private global { length, data },
    // where data points to a null-terminated byte array. Returns a ptr to the object.
    llvm::Value* emitStringObject(const std::string& bytes) {
        llvm::Constant* dataArr = llvm::ConstantDataArray::getString(context, bytes, /*AddNull=*/true);
        auto* dataG = new llvm::GlobalVariable(module, dataArr->getType(), /*isConstant=*/true,
                                               llvm::GlobalValue::PrivateLinkage, dataArr, ".strdata");
        llvm::Constant* obj = llvm::ConstantStruct::get(
            stringType(), {builder.getInt64(bytes.size()), dataG});
        auto* objG = new llvm::GlobalVariable(module, stringType(), /*isConstant=*/true,
                                              llvm::GlobalValue::PrivateLinkage, obj, ".strobj");
        return objG;
    }

    // Loads the null-terminated byte pointer (data) of a String object, for libc interop.
    llvm::Value* stringData(llvm::Value* strObj) {
        return builder.CreateLoad(builder.getPtrTy(),
                                  builder.CreateStructGEP(stringType(), strObj, 1, "str.data"), "data");
    }
    // If `e` is a String/string value, lowers it to its libc byte pointer (for %s); else
    // returns the value unchanged.
    llvm::Value* asCStr(const ast::Expr& e, llvm::Value* v) {
        const std::string t = typeName(e);
        if (t == "String" || t == "string") return stringData(v);
        // C varargs default argument promotions: an integer narrower than int is promoted to int,
        // and a float to double, so printf reads each argument at the width its conversion expects.
        if (v->getType()->isIntegerTy() && v->getType()->getIntegerBitWidth() < 32)
            v = isUnsigned(t) ? builder.CreateZExt(v, builder.getInt32Ty())
                              : builder.CreateSExt(v, builder.getInt32Ty());
        else if (v->getType()->isFloatTy())
            v = builder.CreateFPExt(v, builder.getDoubleTy());
        return v;
    }

    // The reflection Type token layout (spec 31): { ptr name, i64 methodCount,
    // ptr methodNames, ptr methodFns, i64 fieldCount, ptr fieldNames }. methodFns is a
    // parallel array of function pointers, one per method (for Method.invoke). The name
    // arrays are globals of String pointers. Lazily created.
    llvm::StructType* typeTokenType() {
        if (typeStructTy == nullptr)
            typeStructTy = llvm::StructType::create(
                context,
                {builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(), builder.getPtrTy(),
                 builder.getInt64Ty(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy()},
                "ReflectType");  // ..., i64 size, ptr ctorFn  (for instantiate, spec 31)
        return typeStructTy;
    }
    // The reflection Method token layout: { ptr name, ptr fn }. Lazily created.
    llvm::StructType* methodTokenType() {
        if (methodStructTy == nullptr)
            methodStructTy = llvm::StructType::create(
                context, {builder.getPtrTy(), builder.getPtrTy()}, "ReflectMethod");
        return methodStructTy;
    }
    // Builds a global array of String pointers from a list of names; returns {count, arrayPtr}.
    std::pair<llvm::Constant*, llvm::Constant*> nameArray(const std::vector<std::string>& names,
                                                          const std::string& tag) {
        std::vector<llvm::Constant*> ptrs;
        for (const std::string& n : names) ptrs.push_back(llvm::cast<llvm::Constant>(emitStringObject(n)));
        llvm::ArrayType* arrTy = llvm::ArrayType::get(builder.getPtrTy(), ptrs.size());
        auto* arrG = new llvm::GlobalVariable(module, arrTy, /*isConstant=*/true,
                                              llvm::GlobalValue::PrivateLinkage,
                                              llvm::ConstantArray::get(arrTy, ptrs), tag);
        return {builder.getInt64(names.size()), arrG};
    }
    // The Type token for a class (spec 31), one shared global per class, holding its name
    // and its declared method and field names (in declaration order).
    llvm::Value* typeTokenFor(const std::string& className) {
        auto it = typeGlobals.find(className);
        if (it != typeGlobals.end()) return it->second;
        std::vector<std::string> methodNames, fieldNames;
        if (auto cit = classes.find(className); cit != classes.end() && cit->second.decl != nullptr) {
            for (const ast::MemberPtr& m : cit->second.decl->members) {
                if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get()))
                    methodNames.push_back(md->name);
                else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get()))
                    fieldNames.push_back(fd->name);
            }
        }
        auto* nameStr = llvm::cast<llvm::Constant>(emitStringObject(className));
        auto [mcount, mnames] = nameArray(methodNames, "methods." + className);
        auto [fcount, fnames] = nameArray(fieldNames, "fields." + className);
        // Parallel array of method function pointers (null where there is no body).
        std::vector<llvm::Constant*> fns;
        for (const std::string& mn : methodNames) {
            auto fit = functions.find(className + "." + mn);
            fns.push_back(fit != functions.end()
                              ? llvm::cast<llvm::Constant>(fit->second)
                              : llvm::ConstantPointerNull::get(builder.getPtrTy()));
        }
        llvm::ArrayType* fnArrTy = llvm::ArrayType::get(builder.getPtrTy(), fns.size());
        auto* fnsG = new llvm::GlobalVariable(module, fnArrTy, /*isConstant=*/true,
                                              llvm::GlobalValue::PrivateLinkage,
                                              llvm::ConstantArray::get(fnArrTy, fns),
                                              "methodfns." + className);
        // size of an instance + the (no-arg) constructor, for Type.instantiate().
        llvm::Constant* size = llvm::ConstantInt::get(builder.getInt64Ty(), 8);
        if (auto cit = classes.find(className); cit != classes.end())
            size = llvm::cast<llvm::Constant>(sizeOf(cit->second.type));
        auto ctorIt = functions.find(className + "." + className);
        llvm::Constant* ctorFn = ctorIt != functions.end()
                                     ? llvm::cast<llvm::Constant>(ctorIt->second)
                                     : llvm::ConstantPointerNull::get(builder.getPtrTy());
        llvm::Constant* obj = llvm::ConstantStruct::get(
            typeTokenType(), {nameStr, mcount, mnames, fnsG, fcount, fnames, size, ctorFn});
        auto* g = new llvm::GlobalVariable(module, typeTokenType(), /*isConstant=*/true,
                                           llvm::GlobalValue::PrivateLinkage, obj, "type." + className);
        typeGlobals[className] = g;
        return g;
    }

    llvm::Value* emitExpr(const ast::Expr& expr) {
        if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(&expr)) {
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
            for (const auto& p : lam->params) pts.push_back(llvmType(typeRefName(p.type)));
            llvm::Type* rt = llvmType(typeRefName(lam->returnType));
            llvm::Function* fn = llvm::Function::Create(
                llvm::FunctionType::get(rt, pts, false), llvm::Function::InternalLinkage,
                "__ldp3_lambda_" + std::to_string(lambdaCounter++), module);
            // Collect each captured variable's storage and type from the enclosing scope before
            // emitBody clears `locals`.
            std::vector<llvm::Value*> capStorages;
            std::vector<std::string> capTypes;
            for (const auto& cap : lam->captures) {
                auto cit = locals.find(cap.name);
                capStorages.push_back(cit != locals.end() ? cit->second.storage : nullptr);
                capTypes.push_back(cit != locals.end() ? cit->second.type : std::string("int"));
            }
            // emitBody clobbers all function-local state -- save and restore it.
            auto sFn = currentFn; auto sCls = currentClass; auto sRet = currentRetType;
            auto sEns = currentEnsures; auto sInv = currentInvariants; auto sThis = currentThis;
            auto sLoc = locals; auto sScope = scopeObjects; auto sDef = deferred;
            auto sRegions = scopeRegions;
            auto sDtorChain = currentDtorChain;
            auto sOld = oldValues_;  // emitBody clears these; the enclosing method's old() slots must survive
            auto sIP = builder.saveIP();
            emitBody(fn, lam->body, lam->params, "", rt, nullptr, nullptr, nullptr, nullptr,
                     /*hasEnv=*/true, &lam->captures, &capTypes);
            currentFn = sFn; currentClass = sCls; currentRetType = sRet;
            currentEnsures = sEns; currentInvariants = sInv; currentThis = sThis;
            currentDtorChain = sDtorChain;
            oldValues_ = sOld;
            locals = sLoc; scopeObjects = sScope; deferred = sDef;
            scopeRegions = sRegions;
            builder.restoreIP(sIP);
            // Build the environment: one pointer slot per capture. byvalue copies the value into a
            // fresh heap slot; byref shares the variable's own storage.
            llvm::Value* envPtr = llvm::ConstantPointerNull::get(builder.getPtrTy());
            if (!lam->captures.empty()) {
                envPtr = builder.CreateCall(
                    mallocFn(), {builder.getInt64(8 * (std::int64_t)lam->captures.size())}, "env");
                for (std::size_t i = 0; i < lam->captures.size(); i++) {
                    llvm::Value* dst =
                        builder.CreateGEP(builder.getPtrTy(), envPtr, builder.getInt32(i));
                    if (lam->captures[i].byRef) {
                        builder.CreateStore(capStorages[i], dst);  // share the original storage
                    } else {
                        llvm::Type* vt = llvmType(capTypes[i]);
                        llvm::Value* copy =
                            builder.CreateCall(mallocFn(), {builder.getInt64(8)}, "cap");
                        builder.CreateStore(builder.CreateLoad(vt, capStorages[i]), copy);
                        builder.CreateStore(copy, dst);
                    }
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
            if (recv == nullptr) return nullptr;
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
            for (unsigned i = 1; i < target->arg_size(); i++)
                tpts.push_back(target->getArg(i)->getType());
            auto* thunkTy = llvm::FunctionType::get(target->getReturnType(), tpts, false);
            llvm::Function* thunk = llvm::Function::Create(
                thunkTy, llvm::Function::InternalLinkage,
                "__ldp3_methodref_" + std::to_string(lambdaCounter++), module);
            auto sIP = builder.saveIP();
            auto* entry = llvm::BasicBlock::Create(context, "entry", thunk);
            builder.SetInsertPoint(entry);
            llvm::Value* recvIn = builder.CreateLoad(builder.getPtrTy(), thunk->getArg(0), "recv");
            std::vector<llvm::Value*> callArgs;
            callArgs.push_back(recvIn);
            for (unsigned i = 1; i < thunk->arg_size(); i++) callArgs.push_back(thunk->getArg(i));
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
            if (target->getReturnType()->isVoidTy())
                builder.CreateRetVoid();
            else
                builder.CreateRet(result);
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
            if (v >= INT32_MIN && v <= INT32_MAX) {
                return builder.getInt32(static_cast<std::uint32_t>(v));
            }
            return builder.getInt64(static_cast<std::uint64_t>(v));  // literal needs 64 bits
        }
        if (const auto* f = dynamic_cast<const ast::FloatLiteralExpr*>(&expr)) {
            std::string s;
            for (char c : f->text) {
                if (c != '_' && c != 'f' && c != 'F') s += c;
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
                if (v == nullptr) return nullptr;
                v = coerce(v, typeName(*tup->elements[i]), comps[i]);
                agg = builder.CreateInsertValue(agg, v, {static_cast<unsigned>(i)});
            }
            return agg;
        }
        if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
            return emitMatchExpr(*me);
        }
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            if (id->name == "this") return currentThis;
            auto it = locals.find(id->name);
            if (it == locals.end()) {
                // A namespace-level compile-time constant (spec 28.1).
                if (namespaceConstTypes.count(id->name) > 0) return constLiteral(id->name);
                // A bare enum constant inside one of that enum's own methods (spec 12.4).
                if (auto eit = enums.find(currentClass); eit != enums.end()) {
                    const auto& cs = eit->second;
                    auto cpos = std::find(cs.begin(), cs.end(), id->name);
                    if (cpos != cs.end())
                        return builder.getInt32(static_cast<int>(cpos - cs.begin()));
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
            // SIMD vector lane read: v.x / v.y / v.z / v.w -> extractelement. Gate on the lane
            // name first so a class/enum-name receiver isn't type-probed here.
            if (int lane = vecLane(mem->member); lane >= 0) {
                if (int w = vecWidth(typeName(*mem->object)); lane < w) {
                    llvm::Value* v = emitExpr(*mem->object);
                    if (v == nullptr) return nullptr;
                    return builder.CreateExtractElement(v, builder.getInt32(lane), mem->member);
                }
            }
            if (const std::string key = staticFieldKey(*mem); !key.empty()) {
                return builder.CreateLoad(llvmType(staticFieldType[key]), staticGlobals[key],
                                          mem->member);
            }
            if (llvm::Value* pp = persistentFieldPtr(*mem)) {
                return builder.CreateLoad(llvmType(typeName(*mem)), pp, mem->member);
            }
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (locals.find(objId->name) == locals.end()) {
                    // Java-style enum constant -> materialize the instance.
                    auto jit = javaEnums.find(objId->name);
                    if (jit != javaEnums.end()) return emitEnumConstant(*jit->second, mem->member);
                    // Int-style enum constant -> its ordinal (i32).
                    auto eit = enums.find(objId->name);
                    if (eit != enums.end()) {
                        auto pos = std::find(eit->second.begin(), eit->second.end(), mem->member);
                        const int ord = pos == eit->second.end()
                                            ? 0
                                            : static_cast<int>(pos - eit->second.begin());
                        return builder.getInt32(static_cast<std::uint32_t>(ord));
                    }
                }
            }
            // Computed get-only property: obj.name calls the getter (no parens).
            const std::string ot = baseType(typeName(*mem->object));
            if (const ast::MethodDecl* pm = findMethodDecl(ot, mem->member);
                pm != nullptr && pm->isProperty) {
                const std::string owner = methodOwner(ot, mem->member);
                auto fnit = functions.find(owner + "." + mem->member);
                if (fnit != functions.end()) {
                    llvm::Value* recv = emitObjectPtr(*mem->object);
                    if (recv == nullptr) return nullptr;
                    return builder.CreateCall(fnit->second, {recv});
                }
            }
            llvm::Value* fieldPtr = emitLValue(*mem);
            if (fieldPtr == nullptr) return nullptr;
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
            return builder.CreateLoad(llvmType(typeName(*mem)), fieldPtr, isVolatileAccess(*mem),
                                      mem->member);
        }
        if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
            llvm::Value* taskObj = emitExpr(*aw->operand);
            if (taskObj == nullptr) return nullptr;
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
                    module.getOrInsertFunction("__ldp3_await", awTy),
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
                llvm::FunctionType* trTy = llvm::FunctionType::get(
                    builder.getInt64Ty(), {builder.getInt64Ty()}, false);
                llvm::Value* r = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_task_result", trTy), {savedH}, "aw.result");
                return castTaskResult(r, elem);
            }
            // Non-async context (e.g. main): block until the task completes, then read its result.
            llvm::FunctionType* wtTy = llvm::FunctionType::get(
                builder.getInt64Ty(), {builder.getInt64Ty()}, false);
            llvm::Value* r = builder.CreateCall(
                module.getOrInsertFunction("__ldp3_task_wait", wtTy), {h}, "await");
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
            if (un->op == "&") return emitObjectPtr(*un->operand);  // address-of: the object pointer
            llvm::Value* v = emitExpr(*un->operand);
            if (v == nullptr) return nullptr;
            if (un->op == "-")
                return v->getType()->isFloatingPointTy() ? builder.CreateFNeg(v)
                                                          : builder.CreateNeg(v);
            if (un->op == "!") {
                return builder.CreateZExt(builder.CreateICmpEQ(v, builder.getInt32(0)),
                                          builder.getInt32Ty());
            }
            if (un->op == "~") return builder.CreateNot(v);  // bitwise not
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
        if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) {
            return emitExpr(*mv->operand);  // move transfers the pointer (no copy)
        }
        if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
            // try? expr (spec 21.2): if Ok/Some, yield the inner value; if Err/None, early-return the
            // operand to the enclosing method's Result/Option (propagation).
            llvm::Value* val = emitExpr(*tx->operand);
            if (val == nullptr) return nullptr;
            const std::string base = baseType(typeName(*tx->operand));  // Result$T$E / Option$T
            const auto p = base.find('$');
            const std::string tag = base.rfind("Option", 0) == 0 ? "Some" : "Ok";
            auto cit = classes.find(p == std::string::npos ? tag : tag + base.substr(p));
            if (cit == classes.end() || cit->second.vtable == nullptr ||
                cit->second.fieldIndex.count("value") == 0) {
                error("try? requires a Result or Option operand", tx->loc);
                return nullptr;
            }
            llvm::Function* fn = builder.GetInsertBlock()->getParent();
            llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), val, "try.vtbl");
            llvm::Value* isOk = builder.CreateICmpEQ(vtbl, cit->second.vtable, "try.ok");
            llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "try.ok", fn);
            llvm::BasicBlock* errBB = llvm::BasicBlock::Create(context, "try.err", fn);
            builder.CreateCondBr(isOk, okBB, errBB);
            builder.SetInsertPoint(errBB);
            emitPendingFinallys(0);       // run enclosing finallys before propagating out
            emitScopeCleanup();           // run destructors/defers before propagating
            builder.CreateRet(val);       // forward the Err/None as the method's Result/Option
            builder.SetInsertPoint(okBB);
            const std::string vt = cit->second.fieldType.at("value");
            llvm::Value* vp = builder.CreateStructGEP(cit->second.type, val,
                                                      cit->second.fieldIndex.at("value"), "try.vp");
            return builder.CreateLoad(llvmType(vt), vp, "try.value");
        }
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
            return emitRegionAllocate(ri->size.get(), ri->atAddress.get());
        }
        if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
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
                        if (recv == nullptr) return nullptr;
                        return builder.CreateCall(fnit->second, {recv});
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
                if (recv == nullptr || idx == nullptr) return nullptr;
                if (fnit->second->arg_size() >= 2)
                    idx = coerceToType(idx, fnit->second->getArg(1)->getType());
                return builder.CreateCall(fnit->second, {recv, idx});
            }
            // SIMD vector index: v[i] -> extractelement, bounds-checked (no UB).
            if (int w = vecWidth(at); w > 0) {
                llvm::Value* v = emitExpr(*ix->array);
                llvm::Value* idx = emitExpr(*ix->index);
                if (v == nullptr || idx == nullptr) return nullptr;
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
            if (elemPtr == nullptr) return nullptr;
            const std::string et = isRefType(at) ? baseType(at) : elementOf(at);  // T* -> T
            return builder.CreateLoad(llvmType(et), elemPtr, "elem");
        }
        if (dynamic_cast<const ast::InterpStringExpr*>(&expr) != nullptr) {
            error("string interpolation is only supported as a printf/println argument for now",
                  expr.loc);
            return nullptr;
        }
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
            // super(args) was already emitted in the constructor prologue.
            if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
                return nullptr;
            }
            return emitCall(*call);
        }
        error("unsupported expression in codegen", expr.loc);
        return nullptr;
    }

    // Short-circuit && / ||: evaluate the right operand only when needed.
    // a && b -> if a then b else false;  a || b -> if a then true else b.
    llvm::Value* emitShortCircuit(const ast::BinaryExpr& bin) {
        llvm::Value* a = emitExpr(*bin.lhs);
        if (a == nullptr) return nullptr;
        a = builder.CreateICmpNE(a, llvm::Constant::getNullValue(a->getType()), "sc.a");
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* startBB = builder.GetInsertBlock();
        llvm::BasicBlock* rhsBB = llvm::BasicBlock::Create(context, "sc.rhs", fn);
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "sc.end", fn);
        const bool isAnd = (bin.op == "&&");
        builder.CreateCondBr(a, isAnd ? rhsBB : endBB, isAnd ? endBB : rhsBB);
        builder.SetInsertPoint(rhsBB);
        llvm::Value* b = emitExpr(*bin.rhs);
        if (b == nullptr) return nullptr;
        b = builder.CreateICmpNE(b, llvm::Constant::getNullValue(b->getType()), "sc.b");
        llvm::BasicBlock* rhsEnd = builder.GetInsertBlock();
        builder.CreateBr(endBB);
        builder.SetInsertPoint(endBB);
        llvm::PHINode* phi = builder.CreatePHI(builder.getInt1Ty(), 2, "sc");
        phi->addIncoming(builder.getInt1(!isAnd), startBB);  // && short-circuits to false, || to true
        phi->addIncoming(b, rhsEnd);
        return builder.CreateZExt(phi, builder.getInt32Ty());
    }

    // cond ? a : b -- evaluates one branch and merges with a phi (spec 6).
    // `obj?.member` / `obj?.method(...)` (spec 3.7): when obj is null the whole access yields null,
    // otherwise the plain access runs. `node` is the member/call expression; `receiver` is obj.
    // The receiver is re-evaluated in the live branch (harmless for the usual variable/field
    // receivers; a call-valued receiver would run twice).
    llvm::Value* emitSafeNav(const ast::Expr& node, const ast::Expr& receiver) {
        llvm::Value* recv = emitExpr(receiver);
        if (recv == nullptr) return nullptr;
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
        if (val == nullptr) return nullptr;
        if (!val->getType()->isPointerTy()) val = nullp;  // ?. yields a reference value
        llvm::BasicBlock* liveEnd = builder.GetInsertBlock();
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
        llvm::PHINode* phi = builder.CreatePHI(builder.getPtrTy(), 2, "safe");
        phi->addIncoming(nullp, entryBB);
        phi->addIncoming(val, liveEnd);
        return phi;
    }

    // `a ?? b` (spec 3.7): yields a when non-null, else b. b is only evaluated when a is null.
    // Operates on reference values (ptr), so the result is a pointer.
    llvm::Value* emitNullCoalesce(const ast::NullCoalesceExpr& nc) {
        llvm::Value* a = emitExpr(*nc.lhs);
        if (a == nullptr) return nullptr;
        llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
        llvm::Function* fn = currentFn;
        llvm::BasicBlock* aBB = builder.GetInsertBlock();
        auto* elseBB = llvm::BasicBlock::Create(context, "coalesce.else", fn);
        auto* contBB = llvm::BasicBlock::Create(context, "coalesce.cont", fn);
        builder.CreateCondBr(builder.CreateICmpNE(a, nullp), contBB, elseBB);
        builder.SetInsertPoint(elseBB);
        llvm::Value* b = emitExpr(*nc.rhs);
        if (b == nullptr) b = nullp;
        llvm::BasicBlock* bBB = builder.GetInsertBlock();
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
        llvm::PHINode* phi = builder.CreatePHI(builder.getPtrTy(), 2, "coalesce");
        phi->addIncoming(a, aBB);
        phi->addIncoming(b, bBB);
        return phi;
    }

    llvm::Value* emitTernary(const ast::TernaryExpr& t) {
        llvm::Value* c = emitExpr(*t.cond);
        if (c == nullptr) return nullptr;
        c = builder.CreateICmpNE(c, builder.getInt32(0), "tern.c");
        const std::string rt = typeName(*t.thenExpr);
        llvm::Type* rty = llvmType(rt);
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "tern.then", fn);
        llvm::BasicBlock* elseBB = llvm::BasicBlock::Create(context, "tern.else", fn);
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "tern.end", fn);
        builder.CreateCondBr(c, thenBB, elseBB);
        builder.SetInsertPoint(thenBB);
        llvm::Value* tv = emitExpr(*t.thenExpr);
        if (tv != nullptr) tv = coerce(tv, typeName(*t.thenExpr), rt);
        llvm::BasicBlock* thenEnd = builder.GetInsertBlock();
        builder.CreateBr(endBB);
        builder.SetInsertPoint(elseBB);
        llvm::Value* ev = emitExpr(*t.elseExpr);
        if (ev != nullptr) ev = coerce(ev, typeName(*t.elseExpr), rt);
        llvm::BasicBlock* elseEnd = builder.GetInsertBlock();
        builder.CreateBr(endBB);
        builder.SetInsertPoint(endBB);
        if (tv == nullptr || ev == nullptr) return tv != nullptr ? tv : ev;
        llvm::PHINode* phi = builder.CreatePHI(rty, 2, "tern");
        phi->addIncoming(tv, thenEnd);
        phi->addIncoming(ev, elseEnd);
        return phi;
    }

    llvm::Value* emitBinary(const ast::BinaryExpr& bin) {
        if (bin.op == "&&" || bin.op == "||") return emitShortCircuit(bin);
        const std::string lt = typeName(*bin.lhs);
        // Operator overloading: a OP b -> a.operator OP(b) when a's class defines it.
        {
            const std::string owner = methodOwner(baseType(lt), "operator" + bin.op);
            auto fnit = owner.empty() ? functions.end()
                                      : functions.find(owner + ".operator" + bin.op);
            if (fnit != functions.end()) {
                llvm::Value* recv = emitExpr(*bin.lhs);
                SpillToken rtk;
                if (asyncSM && containsAwait(*bin.rhs)) rtk = spillAcrossAwait(recv);
                llvm::Value* arg = emitExpr(*bin.rhs);
                recv = reloadSpill(rtk, recv);
                if (recv == nullptr || arg == nullptr) return nullptr;
                if (fnit->second->arg_size() >= 2) {
                    arg = coerceToType(arg, fnit->second->getArg(1)->getType());
                }
                return builder.CreateCall(fnit->second, {recv, arg});
            }
        }
        const std::string rt = typeName(*bin.rhs);
        llvm::Value* l = emitExpr(*bin.lhs);
        SpillToken ltk;
        if (asyncSM && containsAwait(*bin.rhs)) ltk = spillAcrossAwait(l);
        llvm::Value* r = emitExpr(*bin.rhs);
        l = reloadSpill(ltk, l);
        if (l == nullptr || r == nullptr) return nullptr;
        const std::string& op = bin.op;
        // SIMD vector path: element-wise + - * / on vecN; a scalar operand is broadcast.
        if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) {
            auto toVec = [&](llvm::Value* x, const std::string& xt) -> llvm::Value* {
                if (vecWidth(xt) > 0) return x;  // already a vector
                return builder.CreateVectorSplat(vw, coerceToType(x, builder.getFloatTy()));
            };
            l = toVec(l, lt);
            r = toVec(r, rt);
            if (op == "+") return builder.CreateFAdd(l, r);
            if (op == "-") return builder.CreateFSub(l, r);
            if (op == "*") return builder.CreateFMul(l, r);
            if (op == "/") return builder.CreateFDiv(l, r);
            error("unsupported vector operator '" + op + "'", bin.loc);
            return nullptr;
        }
        // Floating-point path: the result is f64 if either side is f64, else f32.
        if (isFloatType(lt) || isFloatType(rt)) {
            const bool f64 = (isFloatType(lt) && !isF32(lt)) || (isFloatType(rt) && !isF32(rt));
            const std::string ft = f64 ? "double" : "float";
            l = coerce(l, lt, ft);
            r = coerce(r, rt, ft);
            if (op == "+") return builder.CreateFAdd(l, r);
            if (op == "-") return builder.CreateFSub(l, r);
            if (op == "*") return builder.CreateFMul(l, r);
            if (op == "/") return builder.CreateFDiv(l, r);
            llvm::Value* fc = nullptr;
            if (op == "==") fc = builder.CreateFCmpOEQ(l, r);
            else if (op == "!=") fc = builder.CreateFCmpONE(l, r);
            else if (op == "<") fc = builder.CreateFCmpOLT(l, r);
            else if (op == ">") fc = builder.CreateFCmpOGT(l, r);
            else if (op == "<=") fc = builder.CreateFCmpOLE(l, r);
            else if (op == ">=") fc = builder.CreateFCmpOGE(l, r);
            if (fc != nullptr) return builder.CreateZExt(fc, builder.getInt32Ty());
            error("unsupported float operator '" + op + "'", bin.loc);
            return nullptr;
        }
        // Pointer path: == / != on pointers (incl. null) compares addresses directly,
        // skipping integer promotion (which would try to cast a pointer to int). A Java-style
        // enum value is a pointer to its singleton, so identity comparison is its equality.
        auto isPtrish = [this](const std::string& t) {
            return t == "null" || (!t.empty() && (t.back() == '*' || t.back() == '&')) ||
                   javaEnums.count(baseType(t)) > 0;
        };
        const bool javaEnumCmp = javaEnums.count(baseType(lt)) > 0 || javaEnums.count(baseType(rt)) > 0;
        if (javaEnumCmp && op != "==" && op != "!=") {
            error("ordering comparison '" + op + "' is not supported on Java-style enum values; "
                  "use == / != or compare a field",
                  bin.loc);
            return nullptr;
        }
        if ((op == "==" || op == "!=") && (isPtrish(lt) || isPtrish(rt))) {
            llvm::Value* cmp = (op == "==") ? builder.CreateICmpEQ(l, r)
                                            : builder.CreateICmpNE(l, r);
            return builder.CreateZExt(cmp, builder.getInt32Ty());
        }
        // Integer path: promote both operands to the wider bit width. If either
        // side is unsigned the operation is unsigned (zero-extend, udiv/urem,
        // unsigned comparisons).
        const unsigned w = std::max(intBits(lt), intBits(rt));
        const bool uns = isUnsigned(lt) || isUnsigned(rt);
        l = fitInt(l, w, uns);
        r = fitInt(r, w, uns);
        if (op == "+") return builder.CreateAdd(l, r);
        if (op == "-") return builder.CreateSub(l, r);
        if (op == "*") return builder.CreateMul(l, r);
        if (op == "/") return emitIntDivRem(l, r, uns, /*rem=*/false);
        if (op == "%") return emitIntDivRem(l, r, uns, /*rem=*/true);
        if (op == "&") return builder.CreateAnd(l, r);
        if (op == "|") return builder.CreateOr(l, r);
        if (op == "^") return builder.CreateXor(l, r);
        if (op == "<<") return builder.CreateShl(l, r);
        if (op == ">>") return uns ? builder.CreateLShr(l, r) : builder.CreateAShr(l, r);

        llvm::Value* cmp = nullptr;
        if (op == "==") cmp = builder.CreateICmpEQ(l, r);
        else if (op == "!=") cmp = builder.CreateICmpNE(l, r);
        else if (op == "<") cmp = uns ? builder.CreateICmpULT(l, r) : builder.CreateICmpSLT(l, r);
        else if (op == ">") cmp = uns ? builder.CreateICmpUGT(l, r) : builder.CreateICmpSGT(l, r);
        else if (op == "<=") cmp = uns ? builder.CreateICmpULE(l, r) : builder.CreateICmpSLE(l, r);
        else if (op == ">=") cmp = uns ? builder.CreateICmpUGE(l, r) : builder.CreateICmpSGE(l, r);
        if (cmp != nullptr) return builder.CreateZExt(cmp, builder.getInt32Ty());

        error("unsupported binary operator '" + op + "'", bin.loc);
        return nullptr;
    }

    // A region block is [ i64 used | i64 capacity | data... ]. Bump-allocates
    // `objType` bytes (8-aligned) from region variable `name` and returns the slot.
    llvm::Value* emitRegionBumpAlloc(const std::string& name, llvm::StructType* objType,
                                     SourceLocation loc) {
        auto it = locals.find(name);
        if (it == locals.end()) {
            error("unknown region '" + name + "'", loc);
            return nullptr;
        }
        // `lazy region` (spec 37.3): allocate the backing block the first time an object enters.
        if (lazyRegions_.count(name) > 0) {
            llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), it->second.storage, "lazyrgn");
            llvm::Function* fn = currentFn;
            auto* allocBB = llvm::BasicBlock::Create(context, "lazyrgn.alloc", fn);
            auto* contBB = llvm::BasicBlock::Create(context, "lazyrgn.cont", fn);
            builder.CreateCondBr(
                builder.CreateICmpEQ(cur, llvm::ConstantPointerNull::get(builder.getPtrTy())),
                allocBB, contBB);
            builder.SetInsertPoint(allocBB);
            llvm::Value* blk = emitRegionAllocate(lazyRegionSize_[name], lazyRegionAt_[name]);
            if (blk != nullptr) builder.CreateStore(blk, it->second.storage);
            builder.CreateBr(contBB);
            builder.SetInsertPoint(contBB);
        }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), it->second.storage, "region");
        llvm::Value* used = builder.CreateLoad(builder.getInt64Ty(), block, "used");
        llvm::Value* dataBase = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 16, "rgn.dbase"),
            "rgn.data");
        llvm::Value* objPtr = builder.CreateGEP(builder.getInt8Ty(), dataBase, used, "rgn.obj");
        llvm::Value* aligned = builder.CreateAnd(builder.CreateAdd(sizeOf(objType), builder.getInt64(7)),
                                                 builder.getInt64(~static_cast<std::uint64_t>(7)));
        builder.CreateStore(builder.CreateAdd(used, aligned), block);  // bump
        return objPtr;
    }

    // itself.allocate(size) / itself.at(addr, size): create a region. The block header is
    // [i64 used][i64 cap][ptr dataBase] (24 bytes). For allocate, dataBase points just past the
    // header in the same malloc'd block; for `at`, the header is malloc'd but dataBase is the fixed
    // address (spec 17.8 / 36.9). `size` is a ByteSize (read .bytes) or a raw byte count;
    // accepts/rejects are compile-time only, so codegen ignores them.
    llvm::Value* emitRegionAllocate(const ast::Expr* sizeExpr, const ast::Expr* atAddr = nullptr) {
        llvm::Value* nbytes = builder.getInt64(0);
        if (sizeExpr != nullptr) {
            llvm::Value* arg = emitExpr(*sizeExpr);
            if (arg == nullptr) return nullptr;
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
        llvm::Value* block;
        llvm::Value* dataBase;
        if (atAddr != nullptr) {
            llvm::Value* addr = emitExpr(*atAddr);
            if (addr == nullptr) return nullptr;
            block = builder.CreateCall(mallocFn(), {builder.getInt64(24)}, "region");
            dataBase = builder.CreateIntToPtr(
                builder.CreateIntCast(addr, builder.getInt64Ty(), false), builder.getPtrTy());
        } else {
            block = builder.CreateCall(
                mallocFn(), {builder.CreateAdd(builder.getInt64(24), nbytes)}, "region");
            dataBase = builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 24, "rgn.databegin");
        }
        builder.CreateStore(builder.getInt64(0), block);  // used = 0
        builder.CreateStore(nbytes,
                            builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "rgn.cap"));
        builder.CreateStore(dataBase,
                            builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 16, "rgn.dbase"));
        return block;
    }

    llvm::Value* emitNew(const ast::NewExpr& nw) {
        const std::string cn = ast::mangleGeneric(nw.className, nw.typeArgs);  // Box<int> -> Box$int
        auto cit = classes.find(cn);
        if (cit == classes.end()) {
            error("unknown class '" + cn + "'", nw.loc);
            return nullptr;
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
        if (!nw.region.empty()) {
            objPtr = emitRegionBumpAlloc(nw.region, cit->second.type, nw.loc);
            if (objPtr == nullptr) return nullptr;
        } else if (nw.location == "stack") {
            objPtr = createEntryAlloca(cn + ".obj", cit->second.type);
        } else if (nw.location == "heap") {
            objPtr = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, cn + ".obj");
        } else {
            error("'new' location must be 'stack' or 'heap', got '" + nw.location + "'", nw.loc);
            return nullptr;
        }
        // Wire up the persistent block (if any) BEFORE the constructor, so the ctor can read
        // and write this.<persistent field>. Keyed by the binding variable's identity.
        llvm::Value* persistBlockRef = nullptr;
        if (cit->second.persistPtrIdx != 0 && !pendingPersistKey.empty()) {
            persistBlockRef = getPersistBlock(pendingPersistKey, cit->second.persistBlock);
            llvm::Value* slot = builder.CreateStructGEP(cit->second.type, objPtr,
                                                        cit->second.persistPtrIdx, "__persist");
            builder.CreateStore(persistBlockRef, slot);
            pendingPersistKey.clear();
        }
        auto fnit = functions.find(cn + "." + cn);
        if (fnit != functions.end()) {
            std::vector<llvm::Value*> args;
            args.push_back(objPtr);
            // Partial constructor (spec 18.9): when fewer args are given than the ctor has
            // parameters, the provided args fill the non-persistent parameters in order, and
            // each parameter whose name matches a persistent field takes its value from the
            // persistent block (the reattached value), rather than being passed in.
            const ast::ConstructorDecl* ctor = nullptr;
            if (cit->second.decl != nullptr)
                for (const ast::MemberPtr& m : cit->second.decl->members)
                    if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) { ctor = c; break; }
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
                    if (v == nullptr) return nullptr;
                    if (pi + 1 < fnit->second->arg_size())
                        v = coerceToType(v, fnit->second->getArg(pi + 1)->getType());
                    args.push_back(v);
                }
            } else {
                for (std::size_t i = 0; i < nw.args.size(); ++i) {
                    llvm::Value* v = emitExpr(*nw.args[i]);
                    if (v == nullptr) return nullptr;
                    if (i + 1 < fnit->second->arg_size())  // coerce to the ctor's param width/type
                        v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                    args.push_back(v);
                }
            }
            emitMaybeInvoke(fnit->second, args);
        }
        return objPtr;
    }

    // A java-style enum constant: materializes `new EnumName(args)` on the heap.
    // Not yet a true singleton -- each reference rebuilds it; identity is a later
    // refinement (would need a global + eager init).
    // A Java-style enum constant is a singleton (spec 12.2): the instance is built once into a
    // private global on first use and reused after, so `==`/`!=` are correct identity comparisons.
    llvm::Value* emitEnumConstant(const ast::EnumDecl& en, const std::string& constName) {
        auto pos = std::find(en.constants.begin(), en.constants.end(), constName);
        if (pos == en.constants.end()) {
            error("enum '" + en.name + "' has no constant '" + constName + "'", en.loc);
            return nullptr;
        }
        const std::size_t idx = static_cast<std::size_t>(pos - en.constants.begin());
        auto cit = classes.find(en.name);
        if (cit == classes.end()) return nullptr;
        const std::string gname = en.name + "." + constName + ".__inst";
        if (staticGlobals.count(gname) == 0) {
            staticGlobals[gname] = new llvm::GlobalVariable(
                module, builder.getPtrTy(), /*isConstant=*/false,
                llvm::GlobalValue::PrivateLinkage,
                llvm::ConstantPointerNull::get(builder.getPtrTy()), gname);
        }
        llvm::GlobalVariable* g = staticGlobals[gname];
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
                if (v == nullptr) return nullptr;
                if (i + 1 < fnit->second->arg_size()) {
                    v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                }
                args.push_back(v);
            }
            emitMaybeInvoke(fnit->second, args);
        }
        builder.CreateStore(objPtr, g);
        builder.CreateBr(doneBB);
        builder.SetInsertPoint(doneBB);
        return builder.CreateLoad(builder.getPtrTy(), g, en.name);
    }

    // Lowers $"lit {e0} lit {e1} ..." to a printf: builds a format string with a
    // specifier per expression (%c for char, %d otherwise) and passes the values.
    llvm::Value* emitInterp(const ast::InterpStringExpr& is, bool addNewline) {
        std::string fmt;
        std::vector<llvm::Value*> values;
        for (std::size_t i = 0; i < is.exprs.size(); ++i) {
            fmt += resolveEscapes(is.literals[i]);
            const std::string et = typeName(*is.exprs[i]);
            llvm::Value* v = emitExpr(*is.exprs[i]);
            if (v == nullptr) return nullptr;
            if (isFloatType(et)) {
                fmt += "%g";
                v = coerce(v, et, "double");  // f64 for the %g vararg
            } else if (et == "char") {
                fmt += "%c";
            } else if (isUnsigned(et)) {
                if (intBits(et) == 64) {
                    fmt += "%llu";
                } else {
                    fmt += "%u";
                    if (v->getType()->isIntegerTy() && v->getType()->getIntegerBitWidth() < 32) {
                        v = builder.CreateZExt(v, builder.getInt32Ty());  // varargs promotion
                    }
                }
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
        fmt += resolveEscapes(is.literals.back());
        if (addNewline) fmt += "\n";
        std::vector<llvm::Value*> args;
        args.push_back(builder.CreateGlobalStringPtr(fmt, ".str"));
        for (llvm::Value* v : values) args.push_back(v);
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
    bool collectSelectChain(const ast::Expr* chain, std::vector<SelectCase>& cases) {
        const auto* call = dynamic_cast<const ast::CallExpr*>(chain);
        if (call == nullptr) return false;
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
        if (mem == nullptr) return false;
        if (mem->member == "select" && call->args.empty()) {
            const auto* base = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
            return base != nullptr && base->name == "Channel";  // base: Channel.select()
        }
        if (!collectSelectChain(mem->object.get(), cases)) return false;  // recurse to the base
        if (mem->member == "receive" && call->args.size() == 2)
            cases.push_back({call->args[0].get(), call->args[1].get(), nullptr, false});
        else if (mem->member == "timeout" && call->args.size() == 2)
            cases.push_back({nullptr, call->args[1].get(), call->args[0].get(), true});
        else return false;
        return true;
    }
    // Calls a function<void> / function<void, T> closure value (code+env pair) with an optional arg.
    void emitClosureCallVoid(llvm::Value* closPtr, const std::string& paramType, llvm::Value* arg) {
        std::vector<llvm::Type*> pts = {builder.getPtrTy()};
        if (arg != nullptr) pts.push_back(llvmType(paramType));
        llvm::FunctionType* fty = llvm::FunctionType::get(builder.getVoidTy(), pts, false);
        llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), closPtr, "code");
        llvm::Value* env = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), closPtr, builder.getInt32(1)),
            "env");
        std::vector<llvm::Value*> args = {env};
        if (arg != nullptr) args.push_back(coerceToType(arg, llvmType(paramType)));
        builder.CreateCall(fty, fnPtr, args);
    }
    // Emits a Channel.select as a poll loop: each iteration tries a non-blocking receive on every
    // channel (calling its handler with the value on success), then optionally fires the timeout.
    void emitSelect(const std::vector<SelectCase>& cases) {
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
        if (msVal != nullptr)
            startMs = builder.CreateCall(module.getOrInsertFunction("__ldp3_now_ms", nowTy), {});
        llvm::Value* tmp = createEntryAlloca("sel.tmp", builder.getInt64Ty());
        llvm::BasicBlock* loopBlk = llvm::BasicBlock::Create(context, "sel.loop", currentFn);
        llvm::BasicBlock* doneBlk = llvm::BasicBlock::Create(context, "sel.done", currentFn);
        builder.CreateBr(loopBlk);
        builder.SetInsertPoint(loopBlk);
        llvm::FunctionType* trTy = llvm::FunctionType::get(
            builder.getInt32Ty(), {builder.getInt64Ty(), builder.getPtrTy()}, false);
        for (const auto& r : recvs) {
            llvm::Value* got = builder.CreateCall(
                module.getOrInsertFunction("__ldp3_chan_try_receive", trTy), {r.h, tmp}, "sel.got");
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
            llvm::Value* now = builder.CreateCall(module.getOrInsertFunction("__ldp3_now_ms", nowTy), {});
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
            module.getOrInsertFunction("__ldp3_yield", llvm::FunctionType::get(builder.getVoidTy(), false)),
            {});
        builder.CreateBr(loopBlk);
        builder.SetInsertPoint(doneBlk);
    }

    llvm::Value* emitCall(const ast::CallExpr& call) {
        if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
            cm != nullptr && cm->safe && &call != safeGuardNode_) {  // obj?.method(...) (spec 3.7)
            return emitSafeNav(call, *cm->object);
        }
        const std::string name = flattenCallee(*call.callee);
        // External C function call (spec 26): a bare call to an `extern` declaration.
        if (auto er = externReturnType.find(name); er != externReturnType.end()) {
            llvm::Function* fn = functions[name];
            std::vector<llvm::Value*> args;
            for (std::size_t i = 0; i < call.args.size(); ++i) {
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) return nullptr;
                if (i < fn->getFunctionType()->getNumParams())
                    v = coerceToType(v, fn->getFunctionType()->getParamType(i));
                args.push_back(v);
            }
            llvm::Value* r = builder.CreateCall(fn, args);
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
                if (c == nullptr) return nullptr;
                vec = builder.CreateInsertElement(vec, coerceToType(c, builder.getFloatTy()),
                                                  builder.getInt32(i));
            }
            return vec;
        }
        // Calling a function value: a local of type function<Ret, Params...> -> indirect call.
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(call.callee.get())) {
            auto lit = locals.find(id->name);
            if (lit != locals.end() && lit->second.type.rfind("function<", 0) == 0) {
                const std::string& ft = lit->second.type;
                const std::string inner = ft.substr(9, ft.size() - 10);  // strip "function<" ">"
                std::vector<std::string> parts;
                int depth = 0;
                for (std::size_t i = 0, s = 0; i <= inner.size(); i++) {
                    if (i == inner.size() || (inner[i] == ',' && depth == 0)) {
                        parts.push_back(inner.substr(s, i - s));
                        s = i + 1;
                    } else if (inner[i] == '<') {
                        depth++;
                    } else if (inner[i] == '>') {
                        depth--;
                    }
                }
                std::vector<llvm::Type*> pts;
                pts.push_back(builder.getPtrTy());  // arg 0: env
                for (std::size_t i = 1; i < parts.size(); i++) pts.push_back(llvmType(parts[i]));
                auto* fty = llvm::FunctionType::get(llvmType(parts[0]), pts, false);
                llvm::Value* closPtr =
                    builder.CreateLoad(builder.getPtrTy(), lit->second.storage, id->name);
                llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), closPtr, "code");
                llvm::Value* envSlot =
                    builder.CreateGEP(builder.getPtrTy(), closPtr, builder.getInt32(1));
                llvm::Value* env = builder.CreateLoad(builder.getPtrTy(), envSlot, "env");
                std::vector<llvm::Value*> args;
                args.push_back(env);  // arg 0: env
                for (std::size_t i = 0; i < call.args.size(); ++i) {
                    llvm::Value* v = emitExpr(*call.args[i]);
                    if (v == nullptr) return nullptr;
                    if (i + 1 < fty->getNumParams()) v = coerceToType(v, fty->getParamType(i + 1));
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
                std::vector<std::string> parts;
                int depth = 0;
                for (std::size_t i = 0, s = 0; i <= inner.size(); i++) {
                    if (i == inner.size() || (inner[i] == ',' && depth == 0)) {
                        parts.push_back(inner.substr(s, i - s));
                        s = i + 1;
                    } else if (inner[i] == '<') {
                        depth++;
                    } else if (inner[i] == '>') {
                        depth--;
                    }
                }
                std::vector<llvm::Type*> pts;
                pts.push_back(builder.getPtrTy());  // arg 0: env
                for (std::size_t i = 1; i < parts.size(); i++) pts.push_back(llvmType(parts[i]));
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
                    if (v == nullptr) return nullptr;
                    if (i + 1 < fty->getNumParams()) v = coerceToType(v, fty->getParamType(i + 1));
                    args.push_back(v);
                }
                return emitMaybeInvoke(fty, fnPtr, args);
            }
        }
        // Low-level thread builtins (used by the System.Concurrency.Thread prelude class) ->
        // runtime CreateThread/WaitForSingleObject (runtime/ldp3_rt.c).
        if (name == "System.Concurrency.__threadStart") {
            llvm::Value* clos = emitExpr(*call.args[0]);  // the function<void> closure pointer
            if (clos == nullptr) return nullptr;
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
            return builder.CreateCall(module.getOrInsertFunction("__ldp3_thread_spawn", ft), {clos},
                                      "thread.h");
        }
        if (name == "System.Concurrency.__threadJoin") {
            llvm::Value* h = emitExpr(*call.args[0]);  // the int64 handle
            if (h == nullptr) return nullptr;
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
            builder.CreateCall(module.getOrInsertFunction("__ldp3_thread_join", ft), {h});
            return nullptr;
        }
        // Mutex lock builtins (used by System.Concurrency.Mutex) -> runtime CRITICAL_SECTION.
        if (name == "System.Concurrency.__lockCreate") {
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {}, false);
            return builder.CreateCall(module.getOrInsertFunction("__ldp3_lock_create", ft), {},
                                      "lock.h");
        }
        // Math (spec 34.6): static functions on double -> LLVM intrinsics.
        if (name.rfind("Math.", 0) == 0) {
            const std::string fn = name.substr(5);
            llvm::Intrinsic::ID id = llvm::Intrinsic::not_intrinsic;
            if (fn == "sqrt") id = llvm::Intrinsic::sqrt;
            else if (fn == "abs") id = llvm::Intrinsic::fabs;
            else if (fn == "floor") id = llvm::Intrinsic::floor;
            else if (fn == "ceil") id = llvm::Intrinsic::ceil;
            else if (fn == "round") id = llvm::Intrinsic::round;
            else if (fn == "trunc") id = llvm::Intrinsic::trunc;
            else if (fn == "sin") id = llvm::Intrinsic::sin;
            else if (fn == "cos") id = llvm::Intrinsic::cos;
            else if (fn == "exp") id = llvm::Intrinsic::exp;
            else if (fn == "log") id = llvm::Intrinsic::log;
            else if (fn == "log2") id = llvm::Intrinsic::log2;
            else if (fn == "log10") id = llvm::Intrinsic::log10;
            else if (fn == "pow") id = llvm::Intrinsic::pow;
            else if (fn == "min") id = llvm::Intrinsic::minnum;
            else if (fn == "max") id = llvm::Intrinsic::maxnum;
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
                    if (v == nullptr) return nullptr;
                    args.push_back(coerceToType(v, d));
                }
                if (id != llvm::Intrinsic::not_intrinsic)
                    return builder.CreateIntrinsic(d, id, args);
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
        // Memory API (spec 17.8): low-level address-based access. `address` is an i64.
        if (name == "Memory.alloc") {
            llvm::Value* n = emitExpr(*call.args[0]);
            if (n == nullptr) return nullptr;
            llvm::Value* p = builder.CreateCall(
                mallocFn(), {builder.CreateIntCast(n, builder.getInt64Ty(), false)}, "mem.alloc");
            return builder.CreatePtrToInt(p, builder.getInt64Ty());
        }
        if (name == "Memory.free") {
            llvm::Value* a = emitExpr(*call.args[0]);
            if (a == nullptr) return nullptr;
            builder.CreateCall(freeFn(), {builder.CreateIntToPtr(a, builder.getPtrTy())});
            return nullptr;
        }
        if (name == "Memory.getMemory") {
            llvm::Value* p = emitLValue(*call.args[0]);  // the target's storage address
            if (p == nullptr) return nullptr;
            return builder.CreatePtrToInt(p, builder.getInt64Ty());
        }
        if (name == "Memory.read") {
            llvm::Value* a = emitExpr(*call.args[0]);
            if (a == nullptr) return nullptr;
            llvm::Type* t = llvmType(call.typeArgs.empty() ? "int" : call.typeArgs[0]);
            return builder.CreateLoad(t, builder.CreateIntToPtr(a, builder.getPtrTy()), "mem.read");
        }
        if (name == "Memory.write") {
            llvm::Value* a = emitExpr(*call.args[0]);
            llvm::Value* v = emitExpr(*call.args[1]);
            if (a == nullptr || v == nullptr) return nullptr;
            builder.CreateStore(v, builder.CreateIntToPtr(a, builder.getPtrTy()));
            return nullptr;
        }
        // Time (spec 34): clock + sleep builtins lowering to runtime helpers.
        if (name.rfind("Time.", 0) == 0) {
            const std::string fn = name.substr(5);
            if (fn == "sleep") {
                llvm::Value* ms = fitInt(emitExpr(*call.args[0]), 64);
                if (ms == nullptr) return nullptr;
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_sleep", ft), {ms});
                return nullptr;
            }
            if (fn == "millis" || fn == "nanos" || fn == "unixMillis") {
                const char* rfn = fn == "millis"  ? "__ldp3_now_ms"
                                  : fn == "nanos" ? "__ldp3_now_ns"
                                                  : "__ldp3_unix_ms";
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {}, false);
                return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {});
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
                if (host == nullptr || port == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, builder.getInt32Ty()}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_connect", ft),
                                          {stringData(host), fitInt(port, 32)});
            }
            if (fn == "send") {
                llvm::Value* sock = emitExpr(*call.args[0]);
                llvm::Value* data = emitExpr(*call.args[1]);
                if (sock == nullptr || data == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_send", ft),
                                          {fitInt(sock, 64), stringData(data), stringLen(data)});
            }
            if (fn == "recv") {
                llvm::Value* sock = emitExpr(*call.args[0]);
                llvm::Value* max = emitExpr(*call.args[1]);
                if (sock == nullptr || max == nullptr) return nullptr;
                llvm::Value* cap = fitInt(max, 64);
                llvm::Value* buf = builder.CreateCall(
                    mallocFn(), {builder.CreateAdd(cap, builder.getInt64(1))}, "rc.buf");
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
                llvm::Value* n = builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_recv", ft),
                                                    {fitInt(sock, 64), buf, cap});
                llvm::Value* len = builder.CreateSelect(
                    builder.CreateICmpSLT(n, builder.getInt64(0)), builder.getInt64(0), n);
                builder.CreateStore(builder.getInt8(0),
                                    builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
                return emitStringFromParts(len, buf);
            }
            if (fn == "close") {
                llvm::Value* sock = emitExpr(*call.args[0]);
                if (sock == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_close", ft), {fitInt(sock, 64)});
                return nullptr;
            }
        }
        // File I/O (spec 34.4): static methods lowering to runtime stdio helpers.
        if (name.rfind("File.", 0) == 0) {
            const std::string fn = name.substr(5);
            llvm::Type* p = builder.getPtrTy();
            if (fn == "readAll") {
                llvm::Value* s = emitExpr(*call.args[0]);
                if (s == nullptr) return nullptr;
                llvm::Value* lenSlot = builder.CreateAlloca(builder.getInt64Ty(), nullptr, "fr.len");
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_file_read_all", ft), {stringData(s), lenSlot});
                llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), lenSlot, "fr.n");
                return emitStringFromParts(len, buf);
            }
            if (fn == "writeAll" || fn == "appendAll") {
                llvm::Value* path = emitExpr(*call.args[0]);
                llvm::Value* content = emitExpr(*call.args[1]);
                if (path == nullptr || content == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(
                    builder.getInt32Ty(), {p, p, builder.getInt64Ty(), builder.getInt32Ty()}, false);
                return builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_file_write_all", ft),
                    {stringData(path), stringData(content), stringLen(content),
                     builder.getInt32(fn == "appendAll" ? 1 : 0)});
            }
            if (fn == "exists" || fn == "remove") {
                llvm::Value* path = emitExpr(*call.args[0]);
                if (path == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p}, false);
                const char* rfn = fn == "exists" ? "__ldp3_file_exists" : "__ldp3_file_delete";
                return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {stringData(path)});
            }
        }
        // Memory.readString(address, len): build a String by copying `len` bytes from a raw buffer
        // (the new String owns its own copy). Used by StringBuilder.toString().
        if (name == "Memory.readString") {
            llvm::Value* addr = emitExpr(*call.args[0]);
            llvm::Value* len = fitInt(emitExpr(*call.args[1]), 64);
            if (addr == nullptr || len == nullptr) return nullptr;
            llvm::Value* src = builder.CreateIntToPtr(addr, builder.getPtrTy());
            llvm::Value* buf = builder.CreateCall(
                mallocFn(), {builder.CreateAdd(len, builder.getInt64(1))}, "fb.buf");
            builder.CreateCall(memcpyFn(), {buf, src, len});
            builder.CreateStore(builder.getInt8(0),
                                builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
            return emitStringFromParts(len, buf);
        }
        if (name == "System.Concurrency.__chanNew") {  // used by the Channel prelude class
            llvm::Value* cap = emitExpr(*call.args[0]);
            if (cap == nullptr) return nullptr;
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getInt64Ty(), {builder.getInt64Ty()}, false);
            return builder.CreateCall(module.getOrInsertFunction("__ldp3_chan_new", ft), {cap},
                                      "chan.h");
        }
        if (name == "System.Concurrency.__lockAcquire" ||
            name == "System.Concurrency.__lockRelease") {
            llvm::Value* h = emitExpr(*call.args[0]);
            if (h == nullptr) return nullptr;
            llvm::FunctionType* ft =
                llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
            const char* fn = name == "System.Concurrency.__lockAcquire" ? "__ldp3_lock_acquire"
                                                                        : "__ldp3_lock_release";
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
                llvm::Value* tmp = createEntryAlloca("readtmp", builder.getInt32Ty());
                builder.CreateCall(scanf(), {builder.CreateGlobalStringPtr("%d", ".scanfmt"), tmp});
                return builder.CreateLoad(builder.getInt32Ty(), tmp, "read");
            }
            if (isPrintf || isPrintln || isPrint) {
                const bool nl = isPrintln;
                if (!call.args.empty())
                    if (const auto* is =
                            dynamic_cast<const ast::InterpStringExpr*>(call.args.front().get()))
                        return emitInterp(*is, nl);
                if (call.args.empty()) {
                    if (nl)
                        builder.CreateCall(printf(), {builder.CreateGlobalStringPtr("\n", ".str")});
                    return nullptr;
                }
                std::vector<llvm::Value*> args;
                // A leading string literal is a printf-style format; otherwise the first arg is a
                // String value, printed with %s.
                if (const auto* lit =
                        dynamic_cast<const ast::StringLiteralExpr*>(call.args.front().get())) {
                    args.push_back(builder.CreateGlobalStringPtr(
                        resolveEscapes(lit->value) + (nl ? "\n" : ""), ".str"));
                    for (std::size_t i = 1; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) return nullptr;
                        args.push_back(asCStr(*call.args[i], v));
                    }
                } else {
                    llvm::Value* s = emitExpr(*call.args.front());
                    if (s == nullptr) return nullptr;
                    args.push_back(builder.CreateGlobalStringPtr(nl ? "%s\n" : "%s", ".str"));
                    args.push_back(asCStr(*call.args.front(), s));
                }
                return builder.CreateCall(printf(), args);
            }
        }
        // reflect.typeOf<T>() (spec 31): returns the Type token for class T.
        if (name == "reflect.typeOf" && !call.typeArgs.empty()) {
            return typeTokenFor(ast::mangleGeneric(call.typeArgs[0], {}));
        }
        // Namespace-level literal suffix function: name(arg). (comptime in the
        // spec; for now it runs at runtime with the same result -- see Fase C.)
        if (auto fnit = functions.find(name);
            fnit != functions.end() && literalReturnType.count(name) > 0) {
            std::vector<llvm::Value*> args;
            for (const auto& arg : call.args) {
                llvm::Value* v = emitExpr(*arg);
                if (v == nullptr) return nullptr;
                args.push_back(v);
            }
            if (!args.empty()) args[0] = coerceToType(args[0], fnit->second->getArg(0)->getType());
            return emitMaybeInvoke(fnit->second, args);
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get())) {
            if (mem->member == "length" && isArrayType(typeName(*mem->object))) {
                // array.length(): read the i64 length header and truncate to int.
                if (call.args.empty()) {
                    llvm::Value* block = emitExpr(*mem->object);
                    if (block == nullptr) return nullptr;
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
                if (nArg == nullptr) return nullptr;
                llvm::Value* n64 = builder.CreateSExt(nArg, builder.getInt64Ty());
                const std::uint64_t esz = byteSizeOf(elementOf(typeName(*mem->object)));
                llvm::Value* total = builder.CreateAdd(
                    builder.getInt64(8), builder.CreateMul(n64, builder.getInt64(esz)));
                llvm::Value* nb = builder.CreateCall(reallocFn(), {block, total}, "arr.new");
                builder.CreateStore(n64, nb);  // new length header
                // Zero only the grown region [oldLen, n): count is 0 when shrinking.
                llvm::Value* grew = builder.CreateICmpSGT(n64, oldLen);
                llvm::Value* cnt = builder.CreateSelect(
                    grew, builder.CreateMul(builder.CreateSub(n64, oldLen), builder.getInt64(esz)),
                    builder.getInt64(0));
                llvm::Value* dst = builder.CreateGEP(builder.getInt8Ty(), arrayData(nb),
                                                     builder.CreateMul(oldLen, builder.getInt64(esz)));
                builder.CreateCall(memsetFn(), {dst, builder.getInt32(0), cnt});
                builder.CreateStore(nb, slot);  // realloc may move the block
                return nullptr;  // resize is void
            }
            // Channel<T> blocking operations (spec 20.3): send/receive a 64-bit slot via the
            // runtime queue (blocks while full / empty).
            if (const std::string ot = baseType(typeName(*mem->object)); ot.rfind("Channel$", 0) == 0) {
                llvm::Value* obj = emitObjectPtr(*mem->object);
                if (obj == nullptr) return nullptr;
                auto cit = classes.find(ot);
                llvm::Value* h = builder.CreateLoad(
                    builder.getInt64Ty(),
                    builder.CreateStructGEP(cit->second.type, obj, cit->second.fieldIndex["h"],
                                            "chan.h.addr"),
                    "chan.h");
                if (mem->member == "send") {
                    llvm::Value* v = emitExpr(*call.args[0]);
                    if (v == nullptr) return nullptr;
                    llvm::FunctionType* ft = llvm::FunctionType::get(
                        builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
                    builder.CreateCall(module.getOrInsertFunction("__ldp3_chan_send", ft),
                                       {h, valueToI64(v)});
                    return nullptr;
                }
                if (mem->member == "receive") {
                    llvm::FunctionType* ft = llvm::FunctionType::get(
                        builder.getInt64Ty(), {builder.getInt64Ty()}, false);
                    llvm::Value* r = builder.CreateCall(
                        module.getOrInsertFunction("__ldp3_chan_receive", ft), {h}, "chan.recv");
                    return castTaskResult(r, ot.substr(8));
                }
                return nullptr;
            }
            // atomic<T> operations (spec 20.6): lower to LLVM atomic instructions.
            if (const std::string ot = baseType(typeName(*mem->object)); ot.rfind("atomic$", 0) == 0) {
                llvm::Value* obj = emitObjectPtr(*mem->object);
                if (obj == nullptr) return nullptr;
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
                    if (n == nullptr) return nullptr;
                    llvm::StoreInst* st = builder.CreateStore(n, vp);
                    st->setAtomic(seqcst);
                    st->setAlignment(al);
                    return nullptr;
                }
                if (mem->member == "add" || mem->member == "increment") {
                    llvm::Value* n = mem->member == "increment" ? llvm::ConstantInt::get(et, 1)
                                                                : emitExpr(*call.args[0]);
                    if (n == nullptr) return nullptr;
                    llvm::Value* old = builder.CreateAtomicRMW(llvm::AtomicRMWInst::Add, vp, n, al,
                                                              seqcst);
                    return builder.CreateAdd(old, n, "atomic.new");  // return the new value
                }
                if (mem->member == "compareAndSet") {
                    llvm::Value* exp = emitExpr(*call.args[0]);
                    llvm::Value* des = emitExpr(*call.args[1]);
                    if (exp == nullptr || des == nullptr) return nullptr;
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
                if (s == nullptr) return nullptr;
                if (mem->member == "length")
                    return builder.CreateTrunc(stringLen(s), builder.getInt32Ty());
                if (mem->member == "isEmpty")
                    return builder.CreateZExt(
                        builder.CreateICmpEQ(stringLen(s), builder.getInt64(0)), builder.getInt32Ty());
                if (mem->member == "charAt") {
                    llvm::Value* i = emitExpr(*call.args[0]);
                    if (i == nullptr) return nullptr;
                    llvm::Value* byte = builder.CreateLoad(
                        builder.getInt8Ty(),
                        builder.CreateGEP(builder.getInt8Ty(), stringData(s), fitInt(i, 64), "ch.addr"),
                        "ch");
                    return builder.CreateZExt(byte, builder.getInt32Ty());  // char is i32
                }
                if (mem->member == "equals") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    llvm::Value* cmp = builder.CreateCall(strcmpFn(), {stringData(s), stringData(o)});
                    return builder.CreateZExt(builder.CreateICmpEQ(cmp, builder.getInt32(0)),
                                              builder.getInt32Ty());
                }
                if (mem->member == "concat") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    llvm::Value* la = stringLen(s);
                    llvm::Value* lb = stringLen(o);
                    llvm::Value* total = builder.CreateAdd(la, lb);
                    llvm::Value* buf = builder.CreateCall(
                        mallocFn(), {builder.CreateAdd(total, builder.getInt64(1))}, "cat.buf");
                    builder.CreateCall(memcpyFn(), {buf, stringData(s), la});
                    builder.CreateCall(memcpyFn(),
                                       {builder.CreateGEP(builder.getInt8Ty(), buf, la), stringData(o), lb});
                    builder.CreateStore(builder.getInt8(0),
                                        builder.CreateGEP(builder.getInt8Ty(), buf, total));  // NUL
                    return emitStringFromParts(total, buf);
                }
                if (mem->member == "substring") {
                    llvm::Value* start = fitInt(emitExpr(*call.args[0]), 64);
                    llvm::Value* end = fitInt(emitExpr(*call.args[1]), 64);
                    llvm::Value* n = builder.CreateSub(end, start);
                    llvm::Value* buf = builder.CreateCall(
                        mallocFn(), {builder.CreateAdd(n, builder.getInt64(1))}, "sub.buf");
                    builder.CreateCall(
                        memcpyFn(),
                        {buf, builder.CreateGEP(builder.getInt8Ty(), stringData(s), start), n});
                    builder.CreateStore(builder.getInt8(0),
                                        builder.CreateGEP(builder.getInt8Ty(), buf, n));  // NUL
                    return emitStringFromParts(n, buf);
                }
                // Search / predicates (spec 34.5): indexOf / contains / startsWith / endsWith.
                if (mem->member == "indexOf" || mem->member == "contains" ||
                    mem->member == "startsWith") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    llvm::Type* p = builder.getPtrTy();
                    llvm::Type* i64 = builder.getInt64Ty();
                    llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, i64, p, i64}, false);
                    llvm::Value* idx = builder.CreateCall(
                        module.getOrInsertFunction("__ldp3_str_index", ft),
                        {stringData(s), stringLen(s), stringData(o), stringLen(o)});
                    if (mem->member == "indexOf") return builder.CreateTrunc(idx, builder.getInt32Ty());
                    llvm::Value* cmp = mem->member == "contains"
                                           ? builder.CreateICmpSGE(idx, builder.getInt64(0))
                                           : builder.CreateICmpEQ(idx, builder.getInt64(0));
                    return builder.CreateZExt(cmp, builder.getInt32Ty());
                }
                if (mem->member == "endsWith") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    llvm::Type* p = builder.getPtrTy();
                    llvm::Type* i64 = builder.getInt64Ty();
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(builder.getInt32Ty(), {p, i64, p, i64}, false);
                    return builder.CreateCall(module.getOrInsertFunction("__ldp3_str_ends", ft),
                                              {stringData(s), stringLen(s), stringData(o), stringLen(o)});
                }
                // Transforms (spec 34.5): toUpper / toLower / trim / repeat (new owned Strings).
                if (mem->member == "toUpper" || mem->member == "toLower") {
                    llvm::Type* p = builder.getPtrTy();
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(p, {p, builder.getInt64Ty()}, false);
                    const char* fn = mem->member == "toUpper" ? "__ldp3_str_upper" : "__ldp3_str_lower";
                    llvm::Value* len = stringLen(s);
                    llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction(fn, ft),
                                                          {stringData(s), len});
                    return emitStringFromParts(len, buf);
                }
                if (mem->member == "trim") {
                    llvm::Type* p = builder.getPtrTy();
                    llvm::Type* i64 = builder.getInt64Ty();
                    llvm::Value* lenSlot = builder.CreateAlloca(i64, nullptr, "trim.len");
                    llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, i64, p}, false);
                    llvm::Value* buf = builder.CreateCall(
                        module.getOrInsertFunction("__ldp3_str_trim", ft),
                        {stringData(s), stringLen(s), lenSlot});
                    return emitStringFromParts(builder.CreateLoad(i64, lenSlot), buf);
                }
                if (mem->member == "repeat") {
                    llvm::Value* count = fitInt(emitExpr(*call.args[0]), 64);
                    if (count == nullptr) return nullptr;
                    llvm::Type* p = builder.getPtrTy();
                    llvm::Type* i64 = builder.getInt64Ty();
                    llvm::Value* lenSlot = builder.CreateAlloca(i64, nullptr, "rep.len");
                    llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, i64, i64, p}, false);
                    llvm::Value* buf = builder.CreateCall(
                        module.getOrInsertFunction("__ldp3_str_repeat", ft),
                        {stringData(s), stringLen(s), count, lenSlot});
                    return emitStringFromParts(builder.CreateLoad(i64, lenSlot), buf);
                }
                if (mem->member == "toString") return s;  // identity
                // String satisfies Hashable<String>/Comparable<String> (collections).
                if (mem->member == "hash")
                    return builder.CreateCall(strHashFn(), {stringData(s), stringLen(s)});
                if (mem->member == "equalsKey") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    llvm::Value* cmp = builder.CreateCall(strcmpFn(), {stringData(s), stringData(o)});
                    return builder.CreateZExt(builder.CreateICmpEQ(cmp, builder.getInt32(0)),
                                              builder.getInt32Ty());
                }
                if (mem->member == "compareTo") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    return builder.CreateCall(strcmpFn(), {stringData(s), stringData(o)});  // sign matters
                }
            }
            // Integer keys satisfy Hashable<T>/Comparable<T> via builtins (collections). Gate on the
            // builtin member names so this never intercepts ClassName.staticMethod() (whose receiver
            // typeName falls back to "int").
            if (const std::string ot = typeName(*mem->object);
                isIntName(ot) && (mem->member == "hash" || mem->member == "toString" ||
                                  mem->member == "equalsKey" || mem->member == "compareTo")) {
                llvm::Value* a = emitExpr(*mem->object);
                if (a == nullptr) return nullptr;
                if (mem->member == "hash") return fitInt(a, 64);
                if (mem->member == "toString") {
                    llvm::Value* buf =
                        builder.CreateCall(mallocFn(), {builder.getInt64(24)}, "itoa.buf");
                    llvm::Value* len = builder.CreateCall(itoaFn(), {fitInt(a, 64), buf});
                    return emitStringFromParts(len, buf);
                }
                llvm::Value* b = emitExpr(*call.args[0]);
                if (b == nullptr) return nullptr;
                b = builder.CreateSExtOrTrunc(b, a->getType());
                if (mem->member == "equalsKey")
                    return builder.CreateZExt(builder.CreateICmpEQ(a, b), builder.getInt32Ty());
                if (mem->member == "compareTo") {
                    const bool u = isUnsigned(ot);
                    llvm::Value* lt = u ? builder.CreateICmpULT(a, b) : builder.CreateICmpSLT(a, b);
                    llvm::Value* gt = u ? builder.CreateICmpUGT(a, b) : builder.CreateICmpSGT(a, b);
                    return builder.CreateSelect(
                        lt, builder.getInt32(-1),
                        builder.CreateSelect(gt, builder.getInt32(1), builder.getInt32(0)));
                }
            }
            // Type reflection (spec 31): name(), method/field enumeration.
            if (typeName(*mem->object) == "Type") {
                llvm::Value* t = emitExpr(*mem->object);
                if (t == nullptr) return nullptr;
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
                    if (i == nullptr) return nullptr;
                    llvm::Value* slot = builder.CreateGEP(builder.getPtrTy(), arr, fitInt(i, 64), "slot");
                    return builder.CreateLoad(builder.getPtrTy(), slot, "elem");
                };
                if (mem->member == "name")
                    return builder.CreateLoad(builder.getPtrTy(),
                                              builder.CreateStructGEP(typeTokenType(), t, 0), "name");
                if (mem->member == "methodCount") return loadCount(1);
                if (mem->member == "methodName") return loadNameAt(2);
                if (mem->member == "fieldCount") return loadCount(4);
                if (mem->member == "fieldName") return loadNameAt(5);
                // Type.method(name): find a method by name; returns a Method token whose
                // fn is null if not found (spec 31).
                if (mem->member == "method") {
                    llvm::Value* mcount = builder.CreateLoad(
                        builder.getInt64Ty(), builder.CreateStructGEP(typeTokenType(), t, 1));
                    llvm::Value* mnamesArr = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 2));
                    llvm::Value* mfnsArr = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 3));
                    llvm::Value* want = stringData(emitExpr(*call.args[0]));
                    llvm::Value* result =
                        builder.CreateCall(mallocFn(), {sizeOf(methodTokenType())}, "method");
                    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
                    builder.CreateStore(nullp, builder.CreateStructGEP(methodTokenType(), result, 0));
                    builder.CreateStore(nullp, builder.CreateStructGEP(methodTokenType(), result, 1));
                    llvm::Function* fn = currentFn;
                    llvm::Value* iSlot = createEntryAlloca("mi", builder.getInt64Ty());
                    builder.CreateStore(builder.getInt64(0), iSlot);
                    auto* hdr = llvm::BasicBlock::Create(context, "m.hdr", fn);
                    auto* body = llvm::BasicBlock::Create(context, "m.body", fn);
                    auto* hit = llvm::BasicBlock::Create(context, "m.hit", fn);
                    auto* nxt = llvm::BasicBlock::Create(context, "m.next", fn);
                    auto* end = llvm::BasicBlock::Create(context, "m.end", fn);
                    builder.CreateBr(hdr);
                    builder.SetInsertPoint(hdr);
                    llvm::Value* i = builder.CreateLoad(builder.getInt64Ty(), iSlot, "i");
                    builder.CreateCondBr(builder.CreateICmpSLT(i, mcount), body, end);
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
                    builder.CreateBr(end);
                    builder.SetInsertPoint(nxt);
                    builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
                    builder.CreateBr(hdr);
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
                    llvm::Value* obj = builder.CreateCall(mallocFn(), {size}, "inst");
                    // Forward the call's arguments to the constructor (spec 31), building the
                    // function type from the argument values so a ctor with parameters runs.
                    std::vector<llvm::Type*> pts = {builder.getPtrTy()};
                    std::vector<llvm::Value*> cargs = {obj};
                    for (const auto& a : call.args) {
                        llvm::Value* av = emitExpr(*a);
                        if (av == nullptr) return nullptr;
                        pts.push_back(av->getType());
                        cargs.push_back(av);
                    }
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(builder.getVoidTy(), pts, false);
                    builder.CreateCall(ft, ctorFn, cargs);
                    return obj;
                }
                // Type.methods()/fields() (spec 31): build an ArrayList<String> of the
                // member names (forced-monomorphized as ArrayList$String).
                if (mem->member == "methods" || mem->member == "fields") {
                    const bool isMethods = (mem->member == "methods");
                    auto clsIt = classes.find("ArrayList$String");
                    auto ctorIt = functions.find("ArrayList$String.ArrayList$String");
                    auto addIt = functions.find("ArrayList$String.add");
                    if (clsIt == classes.end() || ctorIt == functions.end() ||
                        addIt == functions.end()) {
                        error("internal: ArrayList<String> not available for reflection", mem->loc);
                        return nullptr;
                    }
                    llvm::Value* list =
                        builder.CreateCall(mallocFn(), {sizeOf(clsIt->second.type)}, "list");
                    builder.CreateCall(ctorIt->second, {list});
                    llvm::Value* count = builder.CreateLoad(
                        builder.getInt64Ty(),
                        builder.CreateStructGEP(typeTokenType(), t, isMethods ? 1 : 4), "n");
                    llvm::Value* arr = builder.CreateLoad(
                        builder.getPtrTy(),
                        builder.CreateStructGEP(typeTokenType(), t, isMethods ? 2 : 5), "names");
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
                        builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), arr, i), "nm");
                    builder.CreateCall(addIt->second, {list, nm});
                    builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
                    builder.CreateBr(hdr);
                    builder.SetInsertPoint(done);
                    return list;
                }
            }
            // Method reflection (spec 31): name() and invoke(receiver) for no-arg methods.
            if (typeName(*mem->object) == "Method") {
                llvm::Value* m = emitExpr(*mem->object);
                if (m == nullptr) return nullptr;
                if (mem->member == "name")
                    return builder.CreateLoad(builder.getPtrTy(),
                                              builder.CreateStructGEP(methodTokenType(), m, 0), "m.name");
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
                    llvm::Value* recv = emitExpr(*call.args[0]);  // first arg is the receiver
                    if (recv == nullptr) return nullptr;
                    // Forward the remaining arguments to the method (spec 31). The result type is
                    // not carried by the Method token, so invoke is typed void for now.
                    std::vector<llvm::Type*> pts = {builder.getPtrTy()};
                    std::vector<llvm::Value*> cargs = {recv};
                    for (std::size_t i = 1; i < call.args.size(); ++i) {
                        llvm::Value* av = emitExpr(*call.args[i]);
                        if (av == nullptr) return nullptr;
                        pts.push_back(av->getType());
                        cargs.push_back(av);
                    }
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(builder.getVoidTy(), pts, false);
                    builder.CreateCall(ft, fnPtr, cargs);
                    return nullptr;
                }
            }
            // Enum built-ins (spec 12.5): EnumName.count() / EnumName.values().
            if (const auto* eid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                auto eit = enums.find(eid->name);
                if (eit != enums.end()) {
                    const int n = static_cast<int>(eit->second.size());
                    if (mem->member == "count") return builder.getInt32(n);
                    if (mem->member == "values") {
                        // Build an int[] of ordinals [0 .. n-1].
                        llvm::Value* total = builder.getInt64(8 + static_cast<long long>(n) * 4);
                        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "enum.vals");
                        builder.CreateStore(builder.getInt64(n), block);  // length header
                        for (int i = 0; i < n; ++i)
                            builder.CreateStore(
                                builder.getInt32(i),
                                arrayElemPtr(block, builder.getInt32(i), builder.getInt32Ty()));
                        return block;
                    }
                }
            }
            // Static call: the receiver names a class, not a local/this.
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (objId->name != "this" && locals.find(objId->name) == locals.end() &&
                    classes.count(objId->name) > 0) {
                    auto fnit = functions.find(objId->name + "." + mem->member);
                    if (fnit == functions.end()) {
                        error("unknown static method '" + mem->member + "'", call.loc);
                        return nullptr;
                    }
                    std::vector<llvm::Value*> args;
                    std::vector<SpillToken> atk(call.args.size());
                    for (std::size_t i = 0; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) return nullptr;
                        if (i < fnit->second->arg_size())  // static: no implicit `this`
                            v = coerceToType(v, fnit->second->getArg(i)->getType());
                        args.push_back(v);
                        if (asyncSM && laterArgAwaits(call.args, i)) atk[i] = spillAcrossAwait(v);
                    }
                    for (std::size_t i = call.args.size(); i-- > 0;)
                        if (atk[i].active) args[i] = reloadSpill(atk[i], args[i]);
                    return emitMaybeInvoke(fnit->second, args);
                }
            }
            // Enum (catalog) instance method: the receiver is an enum value. Dispatch
            // statically by the enum type, passing the ordinal as `this` (an i32).
            // Dispatch through a catalog-typed receiver (cross-enum polymorphism) is
            // not supported: an i32 ordinal carries no type tag.
            {
                const std::string est = baseType(typeName(*mem->object));
                if (enums.count(est) > 0) {
                    auto fnit = functions.find(est + "." + mem->member);
                    if (fnit != functions.end()) {
                        llvm::Value* recv = emitExpr(*mem->object);  // the ordinal (i32)
                        if (recv == nullptr) return nullptr;
                        std::vector<llvm::Value*> args;
                        args.push_back(recv);
                        for (std::size_t i = 0; i < call.args.size(); ++i) {
                            llvm::Value* v = emitExpr(*call.args[i]);
                            if (v == nullptr) return nullptr;
                            if (i + 1 < fnit->second->arg_size())
                                v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                            args.push_back(v);
                        }
                        return emitMaybeInvoke(fnit->second, args);
                    }
                }
            }
            // spec 30: calling a method on an unimported type throws (rather than branching
            // into the int3-overwritten code).
            emitAliveGuard(baseType(typeName(*mem->object)));
            // Virtual dispatch: if the static type is polymorphic and the method
            // has a vtable slot, call indirectly through the object's vtable.
            const std::string st = baseType(typeName(*mem->object));  // see through T* / T&
            auto stit = classes.find(st);
            if (stit != classes.end() && stit->second.hasVtable) {
                const int slot = slotIndex(st, mem->member);
                const ast::MethodDecl* mdecl = findMethodDecl(st, mem->member);
                if (slot >= 0 && mdecl != nullptr) {
                    llvm::Value* recv = emitObjectPtr(*mem->object);
                    if (recv == nullptr) return nullptr;
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
                    if (asyncSM && anyArgAwaits(call.args)) recvTk = spillAcrossAwait(recv);
                    std::vector<SpillToken> atk(call.args.size());
                    for (std::size_t i = 0; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) return nullptr;
                        if (i + 1 < fty->getNumParams()) v = coerceToType(v, fty->getParamType(i + 1));
                        vargs.push_back(v);
                        if (asyncSM && laterArgAwaits(call.args, i)) atk[i] = spillAcrossAwait(v);
                    }
                    for (std::size_t i = call.args.size(); i-- > 0;)
                        if (atk[i].active) vargs[1 + i] = reloadSpill(atk[i], vargs[1 + i]);
                    if (recvTk.active) vargs[0] = reloadSpill(recvTk, vargs[0]);
                    return emitMaybeInvoke(fty, fnPtr, vargs);
                }
            }

            // Direct call: obj.method(this, args...). The implementation is on the
            // class that defines the method (which may be a superclass).
            llvm::Value* objPtr = emitObjectPtr(*mem->object);
            if (objPtr == nullptr) return nullptr;
            const std::string owner = methodOwner(typeName(*mem->object), mem->member);
            auto fnit = functions.find(owner + "." + mem->member);
            if (owner.empty() || fnit == functions.end()) {
                error("unknown method '" + mem->member + "'", call.loc);
                return nullptr;
            }
            std::vector<llvm::Value*> args;
            args.push_back(objPtr);
            SpillToken recvTk;
            if (asyncSM && anyArgAwaits(call.args)) recvTk = spillAcrossAwait(objPtr);
            std::vector<SpillToken> atk(call.args.size());
            for (std::size_t i = 0; i < call.args.size(); ++i) {
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) return nullptr;
                if (i + 1 < fnit->second->arg_size())
                    v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                args.push_back(v);
                if (asyncSM && laterArgAwaits(call.args, i)) atk[i] = spillAcrossAwait(v);
            }
            for (std::size_t i = call.args.size(); i-- > 0;)
                if (atk[i].active) args[1 + i] = reloadSpill(atk[i], args[1 + i]);
            if (recvTk.active) args[0] = reloadSpill(recvTk, args[0]);
            return emitMaybeInvoke(fnit->second, args);
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call.loc);
        return nullptr;
    }

    // Calls the destructor of every live stack object, in reverse declaration
    // order. Emitted before each `return` and at the function's fall-through end.
    // M4 tracks objects at function scope; per-block RAII comes with nested
    // scopes in a later phase.
    void emitScopeCleanup() {
        // Contracts: postconditions run at each exit, before defers/destructors (spec 29).
        if (currentEnsures != nullptr)
            for (const ast::ExprPtr& e : *currentEnsures) emitContractCheck(*e, "ensures");
        if (currentInvariants != nullptr)
            for (const ast::Expr* inv : *currentInvariants) emitContractCheck(*inv, "invariant");
        // Deferred blocks run first, in reverse (LIFO) order.
        for (auto it = deferred.rbegin(); it != deferred.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) break;
            emitBlock(**it);
        }
        for (auto it = scopeObjects.rbegin(); it != scopeObjects.rend(); ++it) {
            if (!it->region.empty()) continue;  // region objects are destructed when the region frees
            auto fnit = functions.find(it->className + ".~" + it->className);
            if (fnit == functions.end()) continue;
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), it->slot);
            builder.CreateCall(fnit->second, {objPtr});
        }
        freeRegionsFrom(0);  // region RAII (spec 17.7): free every live region at this exit
        // Inside a destructor: chain to the base class destructor last (derived-then-base),
        // so the inherited part is torn down at every exit of this destructor.
        if (!currentDtorChain.empty()) {
            if (auto fit = functions.find(currentDtorChain); fit != functions.end() && currentThis)
                builder.CreateCall(fit->second, {currentThis});
        }
    }

    // The live-instance counter for a class (spec 32.5 onFirstInstance/onLastInstanceDestroyed),
    // a private global initialized to 0.
    llvm::GlobalVariable* instanceCounter(const std::string& name) {
        auto it = instanceCounters.find(name);
        if (it != instanceCounters.end()) return it->second;
        auto* g = new llvm::GlobalVariable(module, builder.getInt32Ty(), /*isConstant=*/false,
                                           llvm::GlobalValue::PrivateLinkage, builder.getInt32(0),
                                           "instances." + name);
        instanceCounters[name] = g;
        return g;
    }

    // Builds a private global table of every function's address, so the physical-unload
    // runtime helper can bound each overwrite by the next function (spec 30).
    void buildFunctionTable() {
        std::vector<llvm::Constant*> fns;
        for (const auto& [name, f] : functions)
            if (!f->isDeclaration()) fns.push_back(f);
        fnTableCount = static_cast<long long>(fns.size());
        auto* arrTy = llvm::ArrayType::get(builder.getPtrTy(), fns.size());
        fnTableGlobal = new llvm::GlobalVariable(module, arrTy, /*isConstant=*/true,
                                                 llvm::GlobalValue::PrivateLinkage,
                                                 llvm::ConstantArray::get(arrTy, fns), "__ldp3_fns");
    }

    // Physically overwrites the machine code of a class's methods (and ctor/dtor) in RAM
    // with int3 traps, via the runtime helper (spec 30 aggressive unload). The code is
    // ripped from memory; the alive guard ensures we never branch into the traps.
    // Calls a runtime code op (__ldp3_unload_fn / __ldp3_reload_fn) on every method, the
    // constructor, and the destructor of a class -- physically overwriting (unimport) or
    // restoring from disk (reimport) their machine code (spec 30).
    void emitPhysicalCodeOp(const std::string& className, const char* runtimeFn) {
        if (fnTableGlobal == nullptr) return;
        auto cit = classes.find(className);
        if (cit == classes.end() || cit->second.decl == nullptr) return;
        llvm::FunctionType* ht = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee helper = module.getOrInsertFunction(runtimeFn, ht);
        auto op = [&](const std::string& fnName) {
            if (auto f = functions.find(fnName); f != functions.end())
                builder.CreateCall(helper,
                                   {f->second, fnTableGlobal, builder.getInt64(fnTableCount)});
        };
        for (const ast::MemberPtr& m : cit->second.decl->members)
            if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get()); md && !md->isAbstract)
                op(className + "." + md->name);
        op(className + "." + className);        // constructor
        op(className + ".~" + className);        // destructor
    }
    void emitPhysicalUnload(const std::string& cn) { emitPhysicalCodeOp(cn, "__ldp3_unload_fn"); }
    void emitPhysicalReload(const std::string& cn) { emitPhysicalCodeOp(cn, "__ldp3_reload_fn"); }

    // Unimport one class (spec 30): run onClassUnload while the code still exists, mark it dead,
    // then physically rip its code from RAM.
    void emitUnimportClass(const std::string& cn) {
        if (auto f = functions.find(cn + ".__onClassUnload"); f != functions.end())
            builder.CreateCall(f->second);
        builder.CreateStore(builder.getInt32(0), aliveFlag(cn));
        emitPhysicalUnload(cn);
    }

    // `cascade unimport X` (spec 37.1): X plus every subclass and every monomorphization (X$args).
    std::vector<std::string> cascadeUnimportTargets(const std::string& x) {
        std::vector<std::string> out;
        for (const auto& [name, layout] : classes) {
            bool match = name == x || name.rfind(x + "$", 0) == 0;  // self or monomorphization
            for (std::string cur = layout.superclass; !match && !cur.empty();) {
                if (cur == x) { match = true; break; }
                auto it = classes.find(cur);
                if (it == classes.end()) break;
                cur = it->second.superclass;
            }
            if (match) out.push_back(name);
        }
        return out;
    }

    // Emits an `expecting { ... }` block (spec 30.18) inline as an expression: the value its
    // `return` produces is captured into a slot, and the block's end becomes the continuation.
    llvm::Value* emitExpectingValue(const ast::Block* block) {
        if (block == nullptr) return builder.getInt32(0);
        std::string vt = "int";
        for (const auto& s : block->statements)
            if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s.get());
                rs != nullptr && rs->value != nullptr)
                vt = typeName(*rs->value);
        llvm::Type* ty = llvmType(vt);
        llvm::Value* slot = builder.CreateAlloca(ty, nullptr, "expecting.val");
        builder.CreateStore(llvm::Constant::getNullValue(ty), slot);
        llvm::BasicBlock* end = llvm::BasicBlock::Create(context, "expecting.end", currentFn);
        llvm::Value* savedSlot = expectingSlot_;
        llvm::BasicBlock* savedEnd = expectingEnd_;
        expectingSlot_ = slot;
        expectingEnd_ = end;
        emitBlock(*block, /*newScope=*/true);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(end);
        expectingSlot_ = savedSlot;
        expectingEnd_ = savedEnd;
        builder.SetInsertPoint(end);
        return builder.CreateLoad(ty, slot, "expecting.result");
    }

    // Bit-for-bit comparison of two validation values (spec 30.18 rule 4): compares the raw memory
    // representation rather than an operator== overload, to defeat a spoofed equals(). Scalars only;
    // struct/object validation values are a follow-up.
    llvm::Value* emitBitEqual(llvm::Value* a, llvm::Value* b) {
        if (a == nullptr || b == nullptr) return builder.getInt1(true);
        llvm::Type* ta = a->getType();
        if (ta->isFloatingPointTy()) {
            llvm::Type* it = builder.getIntNTy(ta->getPrimitiveSizeInBits());
            return builder.CreateICmpEQ(builder.CreateBitCast(a, it), builder.CreateBitCast(b, it));
        }
        if (ta->isPointerTy())
            return builder.CreateICmpEQ(builder.CreatePtrToInt(a, builder.getInt64Ty()),
                                        builder.CreatePtrToInt(b, builder.getInt64Ty()));
        if (ta->isIntegerTy()) return builder.CreateICmpEQ(a, b);
        return builder.getInt1(true);
    }

    // Constructs and throws a System.Runtime.UnimportedTypeException (spec 30): used when
    // an unimported type is instantiated or its methods are called. Terminates the block.
    void emitThrowUnimported() {
        auto cit = classes.find("UnimportedTypeException");
        if (cit == classes.end()) { builder.CreateUnreachable(); return; }
        llvm::Value* exc = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "unimp.exc");
        if (auto f = functions.find("UnimportedTypeException.UnimportedTypeException");
            f != functions.end())
            builder.CreateCall(f->second, {exc});  // sets the vtable, so catch can match the type
        emitThrowObject(exc);
    }
    // If `cn` is unimportable, throws UnimportedTypeException when its alive flag is 0,
    // continuing on a fresh block for the live path (spec 30).
    void emitAliveGuard(const std::string& cn) {
        if (unimportableClasses.count(cn) == 0) return;
        llvm::Value* alive = builder.CreateLoad(builder.getInt32Ty(), aliveFlag(cn), "alive");
        llvm::Function* f = currentFn;
        auto* deadBB = llvm::BasicBlock::Create(context, "unimported", f);
        auto* okBB = llvm::BasicBlock::Create(context, "alive.ok", f);
        builder.CreateCondBr(builder.CreateICmpEQ(alive, builder.getInt32(0)), deadBB, okBB);
        builder.SetInsertPoint(deadBB);
        emitThrowUnimported();
        builder.SetInsertPoint(okBB);
    }

    // The per-class "alive" flag for unimport (spec 30): a private global i32, 1 = alive.
    llvm::GlobalVariable* aliveFlag(const std::string& name) {
        auto it = aliveFlags.find(name);
        if (it != aliveFlags.end()) return it->second;
        auto* g = new llvm::GlobalVariable(module, builder.getInt32Ty(), /*isConstant=*/false,
                                           llvm::GlobalValue::PrivateLinkage, builder.getInt32(1),
                                           "alive." + name);
        aliveFlags[name] = g;
        return g;
    }

    // The runtime reference counter for an abstainable label (spec 7.11), lazily
    // created as a private global initialized to 0 (enabled).
    llvm::GlobalVariable* abstainCounter(const std::string& name) {
        auto it = abstainCounters.find(name);
        if (it != abstainCounters.end()) return it->second;
        auto* g = new llvm::GlobalVariable(module, builder.getInt32Ty(), /*isConstant=*/false,
                                           llvm::GlobalValue::PrivateLinkage, builder.getInt32(0),
                                           "abstain." + name);
        abstainCounters[name] = g;
        return g;
    }

    // Pre-scan: collect every label named by an `abstainfrom`/`reinstate` anywhere in
    // the program, so only those labels get a runtime guard (spec 7.11).
    void scanAbstained(const ast::Stmt* st) {
        if (st == nullptr) return;
        if (const auto* a = dynamic_cast<const ast::AbstainfromStmt*>(st)) {
            // Intra-method: qualify by the containing method so the key matches the label guard's
            // "class.method.label" and same-named labels in different methods never collide (7.11).
            abstainedLabels.insert(scanClass_ + "." + scanMethod_ + "." + a->name);
            return;
        }
        if (const auto* u = dynamic_cast<const ast::UnimportStmt*>(st)) { unimportableClasses.insert(baseType(u->target)); return; }
        if (const auto* rv = dynamic_cast<const ast::ReimportValidateStmt*>(st)) {  // spec 30.18
            unimportableClasses.insert(baseType(rv->target));
            if (rv->expecting) for (const auto& s : rv->expecting->statements) scanAbstained(s.get());
            if (rv->onFailure) for (const auto& s : rv->onFailure->statements) scanAbstained(s.get());
            return;
        }
        if (const auto* c = dynamic_cast<const ast::CascadeStmt*>(st)) {  // cascade unimport: X + subtypes
            if (c->op == ast::CascadeOpKind::Unimport)
                for (const std::string& t : cascadeUnimportTargets(c->typeName))
                    unimportableClasses.insert(t);
            return;
        }
        // `unimport X expecting { ... }` (spec 30.18) appears in expression position (e.g. a var
        // initializer); scan the expression-bearing leaf statements for it.
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) { scanExprForUnimport(vd->init.get()); return; }
        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(st)) { scanExprForUnimport(es->expr.get()); return; }
        if (const auto* as = dynamic_cast<const ast::AssignStmt*>(st)) { scanExprForUnimport(as->value.get()); return; }
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(st)) { scanExprForUnimport(rs->value.get()); return; }
        auto blk = [&](const ast::Block& b) { for (const auto& s : b.statements) scanAbstained(s.get()); };
        if (const auto* i = dynamic_cast<const ast::IfStmt*>(st)) { blk(i->thenBlock); if (i->elseBlock) blk(*i->elseBlock); return; }
        if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) { blk(w->body); return; }
        if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) { blk(d->body); return; }
        if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) { blk(f->body); return; }
        if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) { blk(fe->body); return; }
        if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) { for (auto& c : sw->cases) blk(c.body); if (sw->defaultBody) blk(*sw->defaultBody); return; }
        if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) { for (auto& c : ms->cases) blk(c.body); if (ms->defaultBody) blk(*ms->defaultBody); return; }
        if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) { blk(tr->body); for (auto& c : tr->catches) blk(c.body); if (tr->finallyBlock) blk(*tr->finallyBlock); return; }
        if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) { blk(df->body); return; }
        if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) { blk(us->body); return; }
        if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { scanAbstained(lb->stmt.get()); return; }
    }
    // Registers any `unimport X expecting { ... }` validation expression (spec 30.18) reachable in
    // an expression as making X unimportable, so the alive guard is emitted for it.
    void scanExprForUnimport(const ast::Expr* e) {
        if (e == nullptr) return;
        if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(e)) {
            unimportableClasses.insert(baseType(ue->target));
            if (ue->expecting)
                for (const auto& s : ue->expecting->statements) scanAbstained(s.get());
            return;
        }
        if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
            scanExprForUnimport(b->lhs.get());
            scanExprForUnimport(b->rhs.get());
            return;
        }
        if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e))
            scanExprForUnimport(u->operand.get());
    }
    void collectAbstainedLabels() {
        for (const ast::Bundle& bundle : program.bundles)
            for (const ast::Namespace& ns : bundle.namespaces)
                for (const ast::ClassDecl& cls : ns.classes)
                    for (const ast::MemberPtr& member : cls.members) {
                        scanClass_ = cls.name;
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            scanMethod_ = m->name;  // function name is "class.method"
                            for (const auto& s : m->body.statements) scanAbstained(s.get());
                        } else if (const auto* c =
                                       dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            scanMethod_ = cls.name;  // function name is "class.class"
                            for (const auto& s : c->body.statements) scanAbstained(s.get());
                        } else if (const auto* d =
                                       dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                            scanMethod_ = "~" + cls.name;  // function name is "class.~class"
                            for (const auto& s : d->body.statements) scanAbstained(s.get());
                        }
                    }
    }

    // Exits the current function early with the default value for its return type,
    // running finallys and destructors (used by the abstainfrom skip path).
    void emitDefaultReturn() {
        emitPendingFinallys(0);
        emitScopeCleanup();
        if (currentRetType->isVoidTy()) builder.CreateRetVoid();
        else if (currentRetType->isDoubleTy() || currentRetType->isFloatTy())
            builder.CreateRet(llvm::ConstantFP::get(currentRetType, 0.0));
        else if (currentRetType->isPointerTy())
            builder.CreateRet(llvm::ConstantPointerNull::get(builder.getPtrTy()));
        else if (currentRetType->isStructTy())
            builder.CreateRet(llvm::UndefValue::get(currentRetType));
        else
            builder.CreateRet(llvm::ConstantInt::get(currentRetType, 0));
    }

    // Emits the `finally` blocks of the try regions being left, innermost-out, down to
    // (but not including) finallyStack index `downTo`. Each is a fresh copy because an
    // exit edge has its own predecessor. Used by return/break/continue/try? so finally
    // runs on every structured exit, not only the normal/caught fall-through.
    void emitPendingFinallys(std::size_t downTo) {
        for (std::size_t i = finallyStack.size(); i > downTo; --i) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) return;
            emitBlock(*finallyStack[i - 1]);
        }
    }

    // Finds the loop targeted by break/continue: the named loop, or the innermost.
    const LoopTargets* findLoop(const std::string& label) {
        if (label.empty()) return loopStack.empty() ? nullptr : &loopStack.back();
        for (auto it = loopStack.rbegin(); it != loopStack.rend(); ++it)
            if (it->label == label) return &*it;
        return nullptr;
    }

    // --- Exceptions (spec 21): Windows WinEH via __CxxFrameHandler3. Every LDP3 exception is thrown
    // as one canonical carrier -- the object pointer typed void* (PEAX) -- so a single reusable set
    // of EH tables serves all types; catch clauses match on the LDP3 runtime type, not on RTTI. ---
    void ensurePersonality() {
        if (currentFn != nullptr && !currentFn->hasPersonalityFn()) {
            llvm::FunctionCallee p = module.getOrInsertFunction(
                "__CxxFrameHandler3", llvm::FunctionType::get(builder.getInt32Ty(), true));
            currentFn->setPersonalityFn(llvm::cast<llvm::Constant>(p.getCallee()));
        }
    }
    llvm::Constant* imageBaseSym() {
        llvm::GlobalVariable* g = module.getNamedGlobal("__ImageBase");
        if (g == nullptr)
            g = new llvm::GlobalVariable(module, builder.getInt8Ty(), true,
                                         llvm::GlobalValue::ExternalLinkage, nullptr, "__ImageBase");
        return g;
    }
    // 32-bit image-relative offset of x -- how MSVC EH tables reference their members.
    llvm::Constant* imageRel(llvm::Constant* x) {
        llvm::Type* i64 = builder.getInt64Ty();
        return llvm::ConstantExpr::getTrunc(
            llvm::ConstantExpr::getSub(llvm::ConstantExpr::getPtrToInt(x, i64),
                                       llvm::ConstantExpr::getPtrToInt(imageBaseSym(), i64)),
            builder.getInt32Ty());
    }
    void buildEhStructures() {
        if (ehThrowInfoCache != nullptr) return;
        llvm::Type* i32 = builder.getInt32Ty();
        llvm::PointerType* ptrTy = builder.getPtrTy();
        llvm::GlobalVariable* tiVt = module.getNamedGlobal("??_7type_info@@6B@");
        if (tiVt == nullptr)
            tiVt = new llvm::GlobalVariable(module, ptrTy, true, llvm::GlobalValue::ExternalLinkage,
                                            nullptr, "??_7type_info@@6B@");
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
    llvm::Constant* ehThrowInfo() { buildEhStructures(); return ehThrowInfoCache; }
    llvm::Constant* ehTypeDesc() { buildEhStructures(); return ehTypeDescCache; }
    llvm::FunctionCallee cxxThrowFn() {
        return module.getOrInsertFunction(
            "_CxxThrowException",
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()},
                                    false));
    }

    // S4 RAII-on-unwind: build a fresh chain of cleanuppads that destruct the live stack objects in
    // reverse declaration order, then unwind to finalUnwind (null = to the caller). Returns the
    // innermost pad (the unwind target for a faulting call), or finalUnwind if no live object has a
    // destructor. Mirrors clang's WinEH pattern (pad_n -> ... -> pad_0 -> finalUnwind). Materialized
    // lazily -- only when an exception is actually propagating out of the function -- so no orphan
    // pads are emitted. The normal-path destructors (emitScopeCleanup) are emitted separately and
    // are mutually exclusive with these pads (a cleanuppad is only reached via unwind).
    llvm::BasicBlock* buildCleanupChain(llvm::BasicBlock* finalUnwind) {
        llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
        llvm::BasicBlock* succ = finalUnwind;
        for (const ScopeObject& so : scopeObjects) {
            auto fnit = functions.find(so.className + ".~" + so.className);
            if (fnit == functions.end()) continue;  // no destructor: not part of the chain
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
    // Where a faulting call/throw at the current point must unwind to: the enclosing try's landing
    // pad if inside a try (unchanged S1/S2); else, if stack objects are live, a fresh cleanup chain
    // that runs their destructors before propagating to the caller; else null (an ordinary call).
    // MVP note: inside a try we go straight to the catchswitch -- objects declared in the try body
    // are cleaned only on the normal/return path (emitScopeCleanup), not on the caught-exception
    // path. Full block-scoped unwind cleanup is a later slice.
    llvm::BasicBlock* computeUnwindDest() {
        if (!ehPadStack.empty()) return ehPadStack.back();
        if (scopeObjects.empty()) return nullptr;
        return buildCleanupChain(nullptr);
    }

    // A user call that may throw: when there is an active unwind target (an enclosing try, or live
    // stack objects to destruct), it becomes an invoke unwinding there; otherwise an ordinary call.
    // Builtins that cannot throw (printf/malloc/scanf/...) keep using CreateCall directly.
    llvm::Value* emitMaybeInvoke(llvm::FunctionType* fty, llvm::Value* callee,
                                 llvm::ArrayRef<llvm::Value*> args, const std::string& name = "") {
        llvm::BasicBlock* ud = computeUnwindDest();
        if (ud == nullptr) return builder.CreateCall(fty, callee, args, name);
        llvm::BasicBlock* cont = llvm::BasicBlock::Create(context, "invoke.cont", currentFn);
        llvm::InvokeInst* inv = builder.CreateInvoke(fty, callee, cont, ud, args, name);
        builder.SetInsertPoint(cont);
        return inv;
    }
    llvm::Value* emitMaybeInvoke(llvm::FunctionCallee callee, llvm::ArrayRef<llvm::Value*> args,
                                 const std::string& name = "") {
        return emitMaybeInvoke(callee.getFunctionType(), callee.getCallee(), args, name);
    }

    // Throws (or re-throws) the object `obj` as the canonical void* carrier, unwinding
    // through live destructors into an enclosing try (if any) or to the caller. Ends
    // the current block with unreachable. Shared by `throw` and the uncaught-rethrow path.
    void emitThrowObject(llvm::Value* obj) {
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

    // Vtables of every concrete class that is `t` or a subclass of `t` -- used to match a caught
    // exception's dynamic type against a catch clause (subtype-aware). Empty if `t` is not a
    // polymorphic class, in which case the clause is treated as a catch-all (preserves the carrier).
    std::vector<llvm::Constant*> subtypeVtables(const std::string& t) {
        std::vector<llvm::Constant*> out;
        for (const auto& [cn, cl] : classes) {
            if (cl.vtable == nullptr) continue;
            for (std::string c = cn; !c.empty();) {
                if (c == t) { out.push_back(cl.vtable); break; }
                auto it = classes.find(c);
                c = (it != classes.end()) ? it->second.superclass : std::string();
            }
        }
        return out;
    }

    // try { body } catch (T e) { ... } ... [finally { ... }] (spec 21.1). One catchpad catches the
    // canonical carrier; the clauses are matched in order against the exception's LDP3 runtime type
    // (subtype-aware via vtables). If none match, the current exception is rethrown. finally runs on
    // the normal and caught paths (the uncaught-propagation finally is a later slice).
    void emitTry(const ast::TryStmt& s) {
        ensurePersonality();
        llvm::PointerType* ptrTy = builder.getPtrTy();
        llvm::BasicBlock* ehpad = llvm::BasicBlock::Create(context, "ehpad", currentFn);
        llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "try.cont", currentFn);
        ehPadStack.push_back(ehpad);
        // Pending finally for early exits (return/break/continue/try?) within the body
        // and catch handlers; popped before the normal-path finally at contBB.
        if (s.finallyBlock != nullptr) finallyStack.push_back(s.finallyBlock.get());
        emitBlock(s.body);
        ehPadStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(contBB);
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
            if (match == nullptr) match = builder.getInt1(true);  // non-polymorphic: catch-all
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
            if (had) locals[cc.name] = saved; else locals.erase(cc.name);
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(contBB);
            builder.SetInsertPoint(nextBB);  // keep dispatching inside the funclet
        }
        // No clause matched: leave the funclet (catchret to normal context) so the
        // finally can run with ordinary calls, then re-throw the caught exception to
        // the enclosing try or the caller (spec 21.1: finally always runs).
        if (s.finallyBlock != nullptr) finallyStack.pop_back();  // no longer pending for early exits
        llvm::BasicBlock* rethrowBB = llvm::BasicBlock::Create(context, "rethrow", currentFn);
        builder.CreateCatchRet(cp, rethrowBB);
        builder.SetInsertPoint(rethrowBB);
        llvm::Value* rethrown = builder.CreateLoad(ptrTy, caughtSlot, "rethrow.obj");
        if (s.finallyBlock != nullptr) emitBlock(*s.finallyBlock);  // uncaught path: finally runs
        emitThrowObject(rethrown);
        // Normal / caught fall-through: the finally runs once here too.
        builder.SetInsertPoint(contBB);
        if (s.finallyBlock != nullptr) emitBlock(*s.finallyBlock);
    }

    void emitStatement(const ast::Stmt& stmt) {
        // No code after a terminator (statements following break/continue/return are dead). A
        // `label name;` is the exception: it must still place its block so a comefrom can target it.
        if (builder.GetInsertBlock()->getTerminator() != nullptr &&
            dynamic_cast<const ast::LabelMarkStmt*>(&stmt) == nullptr) {
            return;
        }
        // static_assert is a compile-time check (spec 28.2); it emits no code.
        if (dynamic_cast<const ast::StaticAssertStmt*>(&stmt) != nullptr) return;
        if (const auto* br = dynamic_cast<const ast::BreakStmt*>(&stmt)) {
            if (const LoopTargets* t = findLoop(br->label)) {
                llvm::BasicBlock* target = t->brk;
                const std::size_t so = t->soBase, df = t->dfBase, rg = t->regBase;
                emitPendingFinallys(t->finallyDepth);  // run finallys of try regions left by break
                emitBlockCleanup(so, df, rg);  // run destructors/defers/region-frees of loop scopes
                if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(target);
            }
            return;
        }
        if (const auto* co = dynamic_cast<const ast::ContinueStmt*>(&stmt)) {
            if (const LoopTargets* t = findLoop(co->label)) {
                llvm::BasicBlock* target = t->cont;
                const std::size_t so = t->soBase, df = t->dfBase, rg = t->regBase;
                emitPendingFinallys(t->finallyDepth);
                emitBlockCleanup(so, df, rg);  // tear down this iteration's loop-body scopes
                if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(target);
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
            if (bb == nullptr) bb = llvm::BasicBlock::Create(context, "label." + lm->name, currentFn);
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(bb);
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
                emitDefaultReturn();  // disabled: skip the guarded region (to method end)
                builder.SetInsertPoint(body);
            }
            return;
        }
        // `comefrom name;` -- transfer control to label name (forward or backward). Code after is
        // dead (the terminator guard above skips it).
        if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(&stmt)) {
            llvm::BasicBlock*& bb = labelBlocks[cf->name];
            if (bb == nullptr) bb = llvm::BasicBlock::Create(context, "label." + cf->name, currentFn);
            builder.CreateBr(bb);
            return;
        }
        if (const auto* g = dynamic_cast<const ast::GotoStmt*>(&stmt)) {  // spec 7.9
            llvm::FunctionType* voidFn = llvm::FunctionType::get(builder.getVoidTy(), {}, false);
            if (g->address != nullptr) {  // `goto 0x1000` -- raw control transfer; does not return
                llvm::Value* a = emitExpr(*g->address);
                if (a == nullptr) return;
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
            // `goto label;` -- branch to the label's block in the same method.
            llvm::BasicBlock*& bb = labelBlocks[g->name];
            if (bb == nullptr) bb = llvm::BasicBlock::Create(context, "label." + g->name, currentFn);
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
            if (obj == nullptr) return;
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
            if (agg == nullptr) return;
            const std::vector<std::string> comps = tupleElems(typeName(*td->init));
            for (std::size_t i = 0; i < td->bindings.size(); ++i) {
                const std::string bt = typeRefName(td->bindings[i].type);
                llvm::Value* v = builder.CreateExtractValue(agg, {static_cast<unsigned>(i)});
                if (i < comps.size()) v = coerce(v, comps[i], bt);
                llvm::Value* slot = createEntryAlloca(td->bindings[i].name, llvmType(bt));
                builder.CreateStore(v, slot);
                locals[td->bindings[i].name] = LocalSlot{slot, bt};
            }
            return;
        }
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
            const std::string declType = vd->isVar ? typeName(*vd->init) : typeRefName(vd->type);
            // Inside an async state machine the local already lives in the heap state object
            // (pre-bound); just evaluate the initializer (which may itself await) and store it.
            if (asyncSM) {
                auto it = locals.find(vd->name);
                if (it != locals.end()) {
                    llvm::Value* v = emitExpr(*vd->init);
                    if (v != nullptr)
                        builder.CreateStore(coerceToType(v, llvmType(it->second.type)),
                                            it->second.storage);
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
                    if (init == nullptr) init = llvm::Constant::getNullValue(lty);
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
                    if (vd->isVolatile) volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO)
                    if (!vd->isEternal) scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
                    return;
                }
            }
            llvm::Value* initV = emitExpr(*vd->init);
            pendingPersistKey.clear();
            if (initV == nullptr) return;
            // Value semantics: copying a class value from an existing object makes
            // an independent copy; binding a fresh `new`/pointer/`move` does not,
            // and movable/unique disciplines transfer instead of copying.
            if (isClassValue(declType) && isCopyDiscipline(declType) &&
                isCopyableLValue(*vd->init)) {
                initV = emitClassCopy(declType, initV);
            }
            initV = coerce(initV, typeName(*vd->init), declType);  // int -> float widening
            llvm::Value* slot = createEntryAlloca(vd->name, llvmType(declType));
            builder.CreateStore(initV, slot, vd->isVolatile);  // spec 37.5
            locals[vd->name] = LocalSlot{slot, declType, vd->isVolatile};
            // RAII: a freshly built `new ... on stack` object with a destructor gets cleaned up
            // when the function returns -- unless it is `eternal` (spec 37.2: lives for the whole
            // program, no cleanup).
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                auto cit = classes.find(nw->className);
                if (cit != classes.end() && cit->second.hasDestructor && !vd->isEternal) {
                    // A region object's destructor runs when the region is released/freed (spec
                    // 17.7); a plain stack object's runs at scope exit. A heap object is manual.
                    if (!nw->region.empty())
                        scopeObjects.push_back(ScopeObject{slot, nw->className, nw->region});
                    else if (nw->location == "stack")
                        scopeObjects.push_back(ScopeObject{slot, nw->className, ""});
                }
                // An object placed in a `volatile region` (MMIO): its field accesses are volatile.
                if (!nw->region.empty() && volatileRegions_.count(nw->region) > 0)
                    volatileObjects_.insert(vd->name);
            }
            // RAII for regions (spec 17.7): freed at the end of the lexical block
            // unless eternal. An explicit `release region` nulls the slot first, so
            // the scope-end free is a harmless free(null).
            if (declType == "region" && !vd->isEternal)
                scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
            if (declType == "region" && vd->isVolatile)
                volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO): volatile object accesses
            return;
        }
        if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
            // operator[]= overload: obj[i] = v -> obj.operator[]=(i, v) (spec 6.5).
            if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(assign->target.get())) {
                const std::string owner = methodOwner(baseType(typeName(*ix->array)), "operator[]=");
                auto fnit = owner.empty() ? functions.end()
                                          : functions.find(owner + ".operator[]=");
                if (fnit != functions.end()) {
                    llvm::Value* recv = emitExpr(*ix->array);
                    llvm::Value* idx = emitExpr(*ix->index);
                    llvm::Value* val = emitExpr(*assign->value);
                    if (recv == nullptr || idx == nullptr || val == nullptr) return;
                    if (fnit->second->arg_size() >= 3) {
                        idx = coerceToType(idx, fnit->second->getArg(1)->getType());
                        val = coerceToType(val, fnit->second->getArg(2)->getType());
                    }
                    builder.CreateCall(fnit->second, {recv, idx, val});
                    return;
                }
            }
            const std::string targetType = typeName(*assign->target);
            // atomic<T> assignment (spec 20.6): `counter = counter +/- n` -> atomicrmw add/sub;
            // any other `counter = v` -> atomic store.
            if (baseType(targetType).rfind("atomic$", 0) == 0) {
                llvm::Value* obj = emitObjectPtr(*assign->target);
                if (obj == nullptr) return;
                auto cit = classes.find(baseType(targetType));
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
                    if (bin->op == "+" && same(bin->lhs.get())) delta = bin->rhs.get();
                    else if (bin->op == "+" && same(bin->rhs.get())) delta = bin->lhs.get();
                    else if (bin->op == "-" && same(bin->lhs.get())) { delta = bin->rhs.get(); sub = true; }
                }
                if (delta != nullptr) {
                    llvm::Value* d = emitExpr(*delta);
                    if (d == nullptr) return;
                    builder.CreateAtomicRMW(sub ? llvm::AtomicRMWInst::Sub : llvm::AtomicRMWInst::Add,
                                            vp, d, al, seqcst);
                    return;
                }
                llvm::Value* v = emitExpr(*assign->value);
                if (v == nullptr) return;
                llvm::StoreInst* st = builder.CreateStore(v, vp);
                st->setAtomic(seqcst);
                st->setAlignment(al);
                return;
            }
            llvm::Value* slot = emitLValue(*assign->target);
            if (slot == nullptr) return;
            llvm::Value* v = emitExpr(*assign->value);
            if (v == nullptr) return;
            // Value semantics: assigning a class value makes the target an independent copy.
            if (isClassValue(targetType) && isCopyDiscipline(targetType) &&
                isCopyableLValue(*assign->value)) {
                if (dynamic_cast<const ast::MemberExpr*>(assign->target.get()) != nullptr ||
                    dynamic_cast<const ast::IndexExpr*>(assign->target.get()) != nullptr) {
                    // A class-value field or array element is a pointer slot with no backing object
                    // (a fresh array's elements are null), so deep-copy into a fresh heap object and
                    // store the pointer rather than memcpy'ing into a (possibly null) existing object.
                    builder.CreateStore(emitClassCopy(targetType, v, /*heap=*/true), slot);
                } else {
                    // A local already has a backing object (from its declaration). Deep-copy the
                    // source into a fresh object (duplicating its arrays / value sub-objects), then
                    // copy that object's bytes into the local's backing object, so target and source
                    // share no storage -- matching the declaration and field paths (value semantics).
                    llvm::Value* destStruct = builder.CreateLoad(builder.getPtrTy(), slot);
                    llvm::Value* deep = emitClassCopy(targetType, v);  // duplicates owned fields
                    builder.CreateCall(memcpyFn(),
                                       {destStruct, deep, sizeOf(classes[targetType].type)});
                }
            } else {
                llvm::Value* sv = coerce(v, typeName(*assign->value), targetType);
                if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get()))
                    sv = maskBitField(sv, typeName(*mt->object), mt->member);  // bit-field (spec 11.1)
                builder.CreateStore(sv, slot, isVolatileAccess(*assign->target));  // spec 37.5
            }
            return;
        }
        if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
            // atomic<T> ++ / -- lowers to a lock-free atomicrmw add/sub of 1 (spec 20.6).
            if (const std::string at = baseType(typeName(*incdec->target));
                at.rfind("atomic$", 0) == 0) {
                llvm::Value* obj = emitObjectPtr(*incdec->target);
                if (obj == nullptr) return;
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
            llvm::Type* ty = llvmType(typeName(*incdec->target));
            llvm::Value* slot = emitLValue(*incdec->target);
            if (slot == nullptr) return;
            llvm::Value* cur = builder.CreateLoad(ty, slot);
            llvm::Value* one = llvm::ConstantInt::get(ty, 1);
            llvm::Value* res =
                incdec->isIncrement ? builder.CreateAdd(cur, one) : builder.CreateSub(cur, one);
            builder.CreateStore(res, slot);
            return;
        }
        if (const auto* um = dynamic_cast<const ast::UnimportStmt*>(&stmt)) {
            const std::string cn = baseType(um->target);
            if (!um->isReimport) {
                emitUnimportClass(cn);
            } else {
                // reimport (spec 30.3): restore the ripped-out code from the .exe on disk,
                // then re-enable the class.
                emitPhysicalReload(cn);
                builder.CreateStore(builder.getInt32(1), aliveFlag(cn));
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
            if (rv->onFailure != nullptr) emitBlock(*rv->onFailure, /*newScope=*/true);
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(okBB);
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
                if (root == nullptr) return;
                const CascadeOp op = cs->op == ast::CascadeOpKind::Println ? CascadeOp::Println
                                                                           : CascadeOp::Validate;
                emitCascade(op, root, cn, cascadeCsid_++, cs->params);
            } else if (cs->op == ast::CascadeOpKind::Clone) {
                // `cascade clone X into Y`: deep-clone X's owned graph and store the root in Y.
                const std::string cn = baseType(typeName(*cs->target));
                llvm::Value* src = emitObjectPtr(*cs->target);
                llvm::Value* destSlot = emitLValue(*cs->dest);
                if (src == nullptr || destSlot == nullptr) return;
                emitCascadeClone(src, cn, destSlot, cascadeCsid_++, cs->params);
            } else if (cs->op == ast::CascadeOpKind::Unimport) {
                // `cascade unimport X`: unimport X and every subclass and monomorphization.
                for (const std::string& t : cascadeUnimportTargets(baseType(cs->typeName)))
                    emitUnimportClass(t);
            }
            return;
        }
        if (const auto* cm = dynamic_cast<const ast::CascadeMoveStmt*>(&stmt)) {
            // Move the object graph into the destination region, then repoint the target.
            const std::string cn = baseType(typeName(*cm->target));
            llvm::Value* src = emitObjectPtr(*cm->target);
            if (src == nullptr) return;
            llvm::Value* dst = emitCascadeMove(src, cn, cm->toRegion, cm->loc);
            if (llvm::Value* slot = emitLValue(*cm->target)) builder.CreateStore(dst, slot);
            return;
        }
        if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&stmt)) {
            const std::string t = typeName(*del->target);
            if (isArrayType(t)) {
                // An array is a single heap block: just free it.
                llvm::Value* block = emitExpr(*del->target);
                if (block != nullptr) builder.CreateCall(freeFn(), {block});
                return;
            }
            llvm::Value* objPtr = emitObjectPtr(*del->target);
            if (objPtr == nullptr) return;
            const std::string cn = baseType(t);  // see through T*
            auto cit = classes.find(cn);
            // `delete X from region R` (spec 17.7): the region owns the memory and reclaims it on
            // release, so run the destructor now and drop the object from RAII tracking (so the
            // region release does not run it again), but never free() into the bump allocator.
            if (!del->fromRegion.empty()) {
                if (cit != classes.end() && cit->second.hasDestructor)
                    builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
                if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(del->target.get()))
                    if (auto lit = locals.find(tid->name); lit != locals.end())
                        for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so)
                            if (so->slot == lit->second.storage) { scopeObjects.erase(so); break; }
                return;
            }
            // `cascade delete` (spec 37.1): delete the object and everything it owns
            // by composition. Heap-only (the spec's intent); no stack early-destruct.
            if (del->isCascade) {
                emitCascade(CascadeOp::Delete, objPtr, cn, cascadeCsid_++, del->cascade);
                return;
            }
            // A stack-allocated owned object (tracked for RAII): `delete` is an early
            // destruct -- run the destructor once and drop it from tracking, but never
            // free() a stack pointer or let scope-exit destruct it again.
            if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(del->target.get())) {
                if (auto lit = locals.find(tid->name); lit != locals.end()) {
                    for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so) {
                        if (so->slot != lit->second.storage) continue;
                        if (cit != classes.end() && cit->second.hasDestructor)
                            builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
                        scopeObjects.erase(so);
                        return;
                    }
                }
            }
            // Polymorphic delete dispatches the destructor through the vtable; a plain
            // class calls its destructor directly. Both then free (see emitDeleteObject).
            emitDeleteObject(objPtr, cn);
            return;
        }
        if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
            if (rel->isPersistent) {
                // `release persistent obj.field`: persistents are in-process (spec 18) and
                // reclaimed at program shutdown, so the explicit release is a no-op for now;
                // its role is to satisfy the static release obligation (spec 18.15). Freeing
                // the backing storage on release is a later runtime refinement.
                return;
            }
            // Destruct every object in the region, then free the whole block (spec 17.7). Null the
            // slot so the scope-end region RAII frees null (no double free), and the objects are
            // cleared so they are not destructed again on the freed block.
            auto it = locals.find(rel->region);
            if (it != locals.end()) {
                runRegionObjectDtors(rel->region);
                llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), it->second.storage);
                builder.CreateCall(freeFn(), {block});
                builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()),
                                    it->second.storage);
            }
            return;
        }
        if (const auto* def = dynamic_cast<const ast::DeferStmt*>(&stmt)) {
            deferred.push_back(&def->body);  // runs at scope end (see emitScopeCleanup)
            return;
        }
        if (const auto* us = dynamic_cast<const ast::UsingStmt*>(&stmt)) {
            emitStatement(*us->decl);  // declare the resource
            emitBlock(us->body);       // use it
            // Dispose it at the block's end. A heap resource is freed; a stack
            // resource is an alloca (never free it). Either way drop it from RAII
            // tracking so scope-exit does not destruct it a second time.
            auto it = locals.find(us->varName);
            if (it != locals.end() && builder.GetInsertBlock()->getTerminator() == nullptr) {
                const std::string cn = baseType(it->second.type);
                llvm::Value* objPtr =
                    builder.CreateLoad(builder.getPtrTy(), it->second.storage);
                auto cit = classes.find(cn);
                if (cit != classes.end() && cit->second.hasDestructor) {
                    builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
                }
                bool onStack = false;
                for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so) {
                    if (so->slot == it->second.storage) {
                        onStack = true;
                        scopeObjects.erase(so);
                        break;
                    }
                }
                if (!onStack) builder.CreateCall(freeFn(), {objPtr});
            }
            return;
        }
        if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(&stmt)) {
            llvm::Value* mptr = emitObjectPtr(*sy->mutex);  // the Mutex instance
            if (mptr == nullptr) return;
            auto cit = classes.find(baseType(typeName(*sy->mutex)));
            if (cit == classes.end()) return;
            const ClassLayout& cl = cit->second;
            auto lockIt = cl.fieldIndex.find("lock");
            auto valIt = cl.fieldIndex.find("value");
            if (lockIt == cl.fieldIndex.end() || valIt == cl.fieldIndex.end()) return;
            llvm::FunctionType* lf =
                llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
            // Acquire the lock for the duration of the block.
            llvm::Value* lockAddr =
                builder.CreateStructGEP(cl.type, mptr, lockIt->second, "mtx.lock.addr");
            llvm::Value* lock = builder.CreateLoad(builder.getInt64Ty(), lockAddr, "mtx.lock");
            builder.CreateCall(module.getOrInsertFunction("__ldp3_lock_acquire", lf), {lock});
            // Bind the name to a reference to the protected value: the local's storage *is* the
            // address of the value field, so reads/writes of the binding hit the field directly.
            llvm::Value* valAddr =
                builder.CreateStructGEP(cl.type, mptr, valIt->second, "mtx.value.addr");
            const bool had = locals.count(sy->bindName) > 0;
            LocalSlot saved = had ? locals[sy->bindName] : LocalSlot{};
            locals[sy->bindName] = LocalSlot{valAddr, sy->bindType.name};
            emitBlock(sy->body);
            if (builder.GetInsertBlock()->getTerminator() == nullptr)
                builder.CreateCall(module.getOrInsertFunction("__ldp3_lock_release", lf), {lock});
            if (had) locals[sy->bindName] = saved; else locals.erase(sy->bindName);
            return;
        }
        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
            emitExpr(*es->expr);
            return;
        }
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
            // Inside an `expecting { ... }` block (spec 30.18), `return X` is the block's value:
            // store it and jump to the block's end, rather than returning from the method.
            if (expectingSlot_ != nullptr) {
                llvm::Value* v = rs->value != nullptr ? emitExpr(*rs->value) : nullptr;
                if (v != nullptr) builder.CreateStore(v, expectingSlot_);
                builder.CreateBr(expectingEnd_);
                return;
            }
            // Inside an async resume, `return X` completes the task with X (spec 20.2).
            if (currentAsyncState != nullptr) {
                llvm::Value* v = rs->value != nullptr ? emitExpr(*rs->value) : nullptr;
                emitPendingFinallys(0);
                emitScopeCleanup();
                emitTaskComplete(v);
                builder.CreateRetVoid();
                return;
            }
            if (rs->value != nullptr) {
                llvm::Value* v = emitExpr(*rs->value);
                if (v != nullptr && currentRetType->isDoubleTy() && v->getType()->isIntegerTy()) {
                    v = builder.CreateSIToFP(v, currentRetType);  // int -> double return
                }
                emitPendingFinallys(0);  // run every enclosing try's finally before leaving
                emitScopeCleanup();
                if (v != nullptr) builder.CreateRet(v);
                return;
            }
            emitPendingFinallys(0);
            emitScopeCleanup();
            if (currentRetType->isVoidTy()) {
                builder.CreateRetVoid();
            } else if (currentRetType->isDoubleTy()) {
                builder.CreateRet(llvm::ConstantFP::get(currentRetType, 0.0));
            } else if (currentRetType->isStructTy()) {
                builder.CreateRet(llvm::UndefValue::get(currentRetType));  // tuple
            } else {
                builder.CreateRet(builder.getInt32(0));
            }
            return;
        }
        error("unsupported statement in codegen", stmt.loc);
    }

    // Runs the deferred blocks and stack-object destructors registered since the
    // given marks (LIFO), without the function-level contracts. Used to tear down a
    // lexical block on its normal exit. Stops if a terminator appears.
    // Frees every region in scopeRegions at index >= base (load the block and free;
    // a released region's slot is null, so free(null) is a harmless no-op).
    // Run (and clear) the destructors of every tracked object allocated in region `name`, in
    // reverse declaration order. Cleared (className emptied) so a later region free or scope
    // cleanup never runs them again on freed memory.
    void runRegionObjectDtors(const std::string& name) {
        if (name.empty()) return;
        for (std::size_t i = scopeObjects.size(); i > 0; --i) {
            ScopeObject& so = scopeObjects[i - 1];
            if (so.region != name || so.className.empty()) continue;
            if (auto fnit = functions.find(so.className + ".~" + so.className);
                fnit != functions.end()) {
                llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), so.slot);
                builder.CreateCall(fnit->second, {objPtr});
            }
            so.className.clear();  // mark done
        }
    }

    void freeRegionsFrom(std::size_t base) {
        for (std::size_t i = scopeRegions.size(); i > base; --i) {
            runRegionObjectDtors(scopeRegions[i - 1].name);  // destruct objects before freeing (17.7)
            llvm::Value* block =
                builder.CreateLoad(builder.getPtrTy(), scopeRegions[i - 1].slot, "region");
            builder.CreateCall(freeFn(), {block});
        }
    }

    void emitBlockCleanup(std::size_t soBase, std::size_t dfBase, std::size_t regBase) {
        for (std::size_t i = deferred.size(); i > dfBase; --i) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) return;
            emitBlock(*deferred[i - 1]);
        }
        for (std::size_t i = scopeObjects.size(); i > soBase; --i) {
            const ScopeObject& so = scopeObjects[i - 1];
            if (!so.region.empty()) continue;  // region objects are destructed when the region frees
            auto fnit = functions.find(so.className + ".~" + so.className);
            if (fnit == functions.end()) continue;
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), so.slot);
            builder.CreateCall(fnit->second, {objPtr});
        }
        freeRegionsFrom(regBase);  // region RAII (spec 17.7)
    }

    // Emits a lexical block. When `newScope` (every nested block: if/loop/try/case/
    // etc.), stack objects and `defer`s declared inside are torn down at the block's
    // normal exit and dropped from tracking -- so a destructor only runs on a path
    // that actually ran the declaration (no dtor on uninitialized memory), runs once
    // per loop iteration (no leak), and a defer fires per iteration. The function
    // body passes newScope=false: emitBody owns that teardown (with contracts).
    void emitBlock(const ast::Block& block, bool newScope = true) {
        const std::size_t soBase = scopeObjects.size();
        const std::size_t dfBase = deferred.size();
        const std::size_t regBase = scopeRegions.size();
        for (const auto& stmt : block.statements) {
            // Don't stop at a terminator: a later `label` (the target of a forward goto/comefrom)
            // must still be placed. emitStatement skips genuinely dead statements but always emits
            // labels, re-establishing a reachable block for the code that follows.
            emitStatement(*stmt);
        }
        if (newScope) {
            // Normal fall-through: tear down this block's objects/defers/regions. On a
            // terminating exit (return runs full cleanup; break/continue branch out)
            // we skip emission but still drop the entries so they are not re-run or
            // run on a stale slot at an outer/function exit.
            if (builder.GetInsertBlock()->getTerminator() == nullptr)
                emitBlockCleanup(soBase, dfBase, regBase);
            scopeObjects.resize(soBase);
            deferred.resize(dfBase);
            scopeRegions.resize(regBase);
        }
    }

    void emitIf(const ast::IfStmt& s) {
        // `comptime if` (spec 37.4): fold the condition and emit only the taken branch;
        // the dead branch produces no code. The analyzer guaranteed the condition folds.
        if (s.isComptime) {
            long long c = 0;
            if (foldConstInt(*s.cond, c)) {
                if (c != 0) emitBlock(s.thenBlock);
                else if (s.elseBlock) emitBlock(*s.elseBlock);
                return;
            }
        }
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        llvm::Value* condBool = builder.CreateICmpNE(condV, builder.getInt32(0));
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "if.then", fn);
        llvm::BasicBlock* elseBB =
            s.elseBlock ? llvm::BasicBlock::Create(context, "if.else", fn) : nullptr;
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "if.end", fn);
        builder.CreateCondBr(condBool, thenBB, elseBB != nullptr ? elseBB : endBB);

        builder.SetInsertPoint(thenBB);
        emitBlock(s.thenBlock);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);

        if (elseBB != nullptr) {
            builder.SetInsertPoint(elseBB);
            emitBlock(*s.elseBlock);
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
        }
        builder.SetInsertPoint(endBB);
    }

    // match (subject) { case Type(binds) { ... } ... default { ... } } (spec 16):
    // a chain of vtable comparisons. Each case binds the case type's own fields
    // (positional) and runs its body.
    void emitMatch(const ast::MatchStmt& s) {
        llvm::Value* subj = emitExpr(*s.subject);
        if (subj == nullptr) return;
        auto sit = classes.find(baseType(typeName(*s.subject)));
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
            const std::string caseType = mDollar == std::string::npos
                                             ? c.typeName : c.typeName + mSubjBase.substr(mDollar);
            auto cit = classes.find(caseType);
            if (cit == classes.end() || cit->second.vtable == nullptr) continue;
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
                if (auto pit = locals.find(c.bindings[i].name); pit != locals.end())
                    prior.push_back({c.bindings[i].name, pit->second});
                locals[c.bindings[i].name] = LocalSlot{slot, ftype};
                added.push_back(c.bindings[i].name);
            }
            emitBlock(c.body);
            for (const std::string& n : added) locals.erase(n);  // bindings are case-scoped
            for (const auto& [n, s] : prior) locals[n] = s;       // restore shadowed outer locals
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
            builder.SetInsertPoint(nextBB);
        }
        if (s.defaultBody) emitBlock(*s.defaultBody);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
        builder.SetInsertPoint(endBB);
    }

    // Expression form (spec 16.2): each arm yields a value; a phi at the join merges
    // them. Mirrors emitMatch's vtable dispatch + positional binding, but produces a
    // value. Sema guarantees exhaustiveness, so the no-match tail is unreachable.
    llvm::Value* emitMatchExpr(const ast::MatchExpr& s) {
        llvm::Value* subj = emitExpr(*s.subject);
        if (subj == nullptr) return nullptr;
        auto sit = classes.find(baseType(typeName(*s.subject)));
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
            const std::string caseType = mDollar == std::string::npos
                                             ? c.typeName : c.typeName + mSubjBase.substr(mDollar);
            auto cit = classes.find(caseType);
            if (cit == classes.end() || cit->second.vtable == nullptr) continue;
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
                if (auto pit = locals.find(c.bindings[i].name); pit != locals.end())
                    prior.push_back({c.bindings[i].name, pit->second});
                locals[c.bindings[i].name] = LocalSlot{slot, ftype};
                added.push_back(c.bindings[i].name);
            }
            llvm::Value* v = c.result ? emitExpr(*c.result) : nullptr;
            if (v != nullptr) v = coerce(v, typeName(*c.result), rtype);  // typeName needs bindings
            for (const std::string& n : added) locals.erase(n);  // bindings are arm-scoped
            for (const auto& [n, s] : prior) locals[n] = s;       // restore shadowed outer locals
            if (v == nullptr) v = llvm::Constant::getNullValue(rty);  // error recovery
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
        } else {
            builder.CreateUnreachable();  // sema guarantees a sealed match is exhaustive
        }
        builder.SetInsertPoint(endBB);
        if (incoming.empty()) return llvm::Constant::getNullValue(rty);
        llvm::PHINode* phi = builder.CreatePHI(rty, static_cast<unsigned>(incoming.size()), "matchx");
        for (auto& in : incoming) phi->addIncoming(in.first, in.second);
        return phi;
    }

    void emitWhile(const ast::WhileStmt& s) {
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "while.cond", fn);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "while.body", fn);
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "while.end", fn);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(condBB);
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        builder.CreateCondBr(builder.CreateICmpNE(condV, builder.getInt32(0)), bodyBB, endBB);
        builder.SetInsertPoint(bodyBB);
        loopStack.push_back({endBB, condBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});  // break -> end, continue -> cond
        pendingLoopLabel.clear();
        emitBlock(s.body);
        loopStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(condBB);
        builder.SetInsertPoint(endBB);
    }

    // do { body } while (cond); -- the body runs at least once (spec 7).
    void emitDoWhile(const ast::DoWhileStmt& s) {
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
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(condBB);
        builder.SetInsertPoint(condBB);
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        builder.CreateCondBr(builder.CreateICmpNE(condV, builder.getInt32(0)), bodyBB, endBB);
        builder.SetInsertPoint(endBB);
    }

    void emitFor(const ast::ForStmt& s) {
        if (s.init) emitStatement(*s.init);
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* condBB = llvm::BasicBlock::Create(context, "for.cond", fn);
        llvm::BasicBlock* bodyBB = llvm::BasicBlock::Create(context, "for.body", fn);
        llvm::BasicBlock* updateBB = llvm::BasicBlock::Create(context, "for.update", fn);
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "for.end", fn);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(condBB);
        llvm::Value* condV = emitExpr(*s.cond);
        if (condV == nullptr) return;
        builder.CreateCondBr(builder.CreateICmpNE(condV, builder.getInt32(0)), bodyBB, endBB);
        builder.SetInsertPoint(bodyBB);
        loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});  // break -> end, continue -> update
        pendingLoopLabel.clear();
        emitBlock(s.body);
        loopStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(updateBB);
        builder.SetInsertPoint(updateBB);
        if (s.update) emitStatement(*s.update);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(condBB);
        builder.SetInsertPoint(endBB);
    }

    // for (T v in array) { ... } -- iterate an array's elements (spec 7). Elements
    // are i32 (int/char/boolean) in the current array model.
    void emitForeach(const ast::ForeachStmt& s) {
        if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(s.iterable.get())) {
            emitForeachRange(s, *rng);
            return;
        }
        llvm::Value* block = emitExpr(*s.iterable);
        if (block == nullptr) return;
        llvm::Value* len64 = builder.CreateLoad(builder.getInt64Ty(), block, "fe.len");
        llvm::Value* len = builder.CreateTrunc(len64, builder.getInt32Ty(), "fe.len32");
        llvm::Value* iSlot = createEntryAlloca("fe.i", builder.getInt32Ty());
        builder.CreateStore(builder.getInt32(0), iSlot);
        const std::string at = typeName(*s.iterable);
        const std::string et = s.isVar ? (isArrayType(at) ? at.substr(0, at.size() - 2) : at)
                                       : typeRefName(s.elemType);
        llvm::Value* vSlot = createEntryAlloca(s.varName, llvmType(et));
        locals[s.varName] = LocalSlot{vSlot, et};
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
        if (!s.indexName.empty()) locals[s.indexName] = LocalSlot{iSlot, "int"};
        llvm::Type* feElemTy = llvmType(et);
        llvm::Value* elem =
            builder.CreateLoad(feElemTy, arrayElemPtr(block, i, feElemTy), "fe.el");
        builder.CreateStore(elem, vSlot);
        loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(), scopeObjects.size(), deferred.size(), scopeRegions.size()});
        pendingLoopLabel.clear();
        emitBlock(s.body);
        loopStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(updateBB);
        builder.SetInsertPoint(updateBB);
        llvm::Value* iv = builder.CreateLoad(builder.getInt32Ty(), iSlot);
        builder.CreateStore(builder.CreateAdd(iv, builder.getInt32(1)), iSlot);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(endBB);
        locals.erase(s.varName);
        if (!s.indexName.empty()) locals.erase(s.indexName);
    }

    // `for (int i in start..end [step k])` (spec 7.5): a counting loop over an integer range. `..` is
    // exclusive of end, `..=` inclusive; the step defaults to 1. Ascending ranges.
    void emitForeachRange(const ast::ForeachStmt& s, const ast::RangeExpr& rng) {
        const std::string et = s.isVar ? typeName(*rng.start) : typeRefName(s.elemType);
        llvm::Type* ty = llvmType(et);
        if (!ty->isIntegerTy()) ty = builder.getInt32Ty();
        llvm::Value* start = coerceToType(emitExpr(*rng.start), ty);
        llvm::Value* end = coerceToType(emitExpr(*rng.end), ty);
        llvm::Value* step =
            rng.step ? coerceToType(emitExpr(*rng.step), ty) : llvm::ConstantInt::get(ty, 1);
        if (start == nullptr || end == nullptr || step == nullptr) return;
        llvm::Value* vSlot = createEntryAlloca(s.varName, ty);
        builder.CreateStore(start, vSlot);
        locals[s.varName] = LocalSlot{vSlot, et};
        // The `index i` form (spec 7.6): a 0-based counter alongside the range value.
        llvm::Value* idxSlot = nullptr;
        if (!s.indexName.empty()) {
            idxSlot = createEntryAlloca(s.indexName, builder.getInt32Ty());
            builder.CreateStore(builder.getInt32(0), idxSlot);
            locals[s.indexName] = LocalSlot{idxSlot, "int"};
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
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(updateBB);
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
        if (!s.indexName.empty()) locals.erase(s.indexName);
    }

    // switch (x) { case C { ... } ... default { ... } } with C-style fall-through (spec 7.3).
    void emitSwitch(const ast::SwitchStmt& s) {
        llvm::Value* subj = emitExpr(*s.subject);
        if (subj == nullptr) return;
        llvm::Function* fn = builder.GetInsertBlock()->getParent();
        llvm::BasicBlock* endBB = llvm::BasicBlock::Create(context, "switch.end", fn);
        const std::size_t n = s.cases.size();
        std::vector<llvm::BasicBlock*> bodyBBs;
        for (std::size_t i = 0; i < n; ++i)
            bodyBBs.push_back(llvm::BasicBlock::Create(context, "switch.case", fn));
        llvm::BasicBlock* defaultBB =
            s.defaultBody ? llvm::BasicBlock::Create(context, "switch.default", fn) : endBB;
        // Dispatch chain: compare the subject against each case value.
        for (std::size_t i = 0; i < n; ++i) {
            llvm::Value* cv = emitExpr(*s.cases[i].value);
            llvm::Value* eq = builder.CreateICmpEQ(subj, cv, "switch.is");
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
            if (builder.GetInsertBlock()->getTerminator() == nullptr)
                builder.CreateBr((i + 1 < n) ? bodyBBs[i + 1] : defaultBB);  // fall-through
        }
        if (s.defaultBody) {
            builder.SetInsertPoint(defaultBB);
            loopStack.push_back(brk);
            emitBlock(*s.defaultBody);
            loopStack.pop_back();
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
        }
        builder.SetInsertPoint(endBB);
    }

    // ---- Top-level generation ----

    void declareClasses() {
        // Pass 0: register enums (int-style lowers to i32 ordinals; java-style
        // constants are singletons materialized as instances of a desugared class).
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::EnumDecl& en : ns.enums) {
                    enums[en.name] = en.constants;
                    if (en.isJavaStyle) javaEnums[en.name] = &en;
                    else if (!en.members.empty()) enumMethodDecls[en.name] = &en;  // catalog enum
                }
            }
        }
        // Pass 1: create struct types and record declaration, superclass,
        // interfaces, flags and own members. All names registered first.
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    ClassLayout layout;
                    layout.decl = &cls;
                    layout.type = llvm::StructType::create(context, "class." + cls.name);
                    layout.superclass = cls.superclass;
                    layout.interfaces = cls.interfaces;
                    layout.isAbstract = cls.isAbstract;
                    layout.isInterface = cls.isInterface;
                    layout.isUnion = cls.isUnion;
                    layout.isMovable = cls.isMovable;
                    layout.isUnique = cls.isUnique;
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                            // A generic field type must mangle its args (Node<int>* -> Node$int*).
                            const std::string base = f->type.typeArgs.empty()
                                ? f->type.name
                                : ast::mangleGeneric(f->type.name, f->type.typeArgs);
                            const std::string ftype = base + ast::arrayDimsSuffix(f->type.arrayDims) +
                                                      (f->type.isPointer ? "*" : "") +
                                                      (f->type.isRef ? "&" : "");
                            // Static fields live in a single LLVM global, not in each
                            // instance, so they are excluded from the struct layout.
                            if (f->isStatic) {
                                staticFieldType[cls.name + "." + f->name] = ftype;
                            } else {
                                layout.ownFields.emplace_back(f->name, ftype);
                                if (f->isPersistent) layout.persistOrder.push_back(f->name);
                                if (f->bitWidth > 0) layout.bitFieldWidth[f->name] = f->bitWidth;
                                if (f->isVolatile) layout.volatileFields.insert(f->name);
                                if (f->isExternal) layout.externalFields.insert(f->name);
                                if (f->isLazy && f->init) layout.lazyFieldInit[f->name] = f->init.get();
                            }
                        } else if (const auto* m =
                                       dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            layout.methodReturnType[m->name] = ast::canonicalType(m->returnType);
                            layout.ownMethods[m->name] = m;
                        } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) !=
                                   nullptr) {
                            layout.hasDestructor = true;
                        }
                    }
                    classes[cls.name] = std::move(layout);
                }
            }
        }
        // Pass 1.5: vtable metadata. A class is polymorphic (carries a vtable
        // pointer) if it is in any inheritance/interface relationship.
        std::unordered_set<std::string> bases;
        for (const auto& [name, l] : classes) {
            if (!l.superclass.empty()) bases.insert(l.superclass);
            for (const std::string& i : l.interfaces) bases.insert(i);
        }
        for (auto& [name, l] : classes) {
            l.hasVtable = !l.superclass.empty() || !l.interfaces.empty() || l.isAbstract ||
                          l.isInterface || bases.count(name) > 0;
        }
        // Assign a stable global slot to every distinct virtual method name, walking
        // the AST in declaration order (deterministic, unlike the classes map). A
        // single global numbering shared by all classes/interfaces is what makes a
        // class with multiple interfaces dispatch each one to the correct slot.
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    auto cit = classes.find(cls.name);
                    if (cit == classes.end() || !cit->second.hasVtable) continue;
                    for (const ast::MemberPtr& member : cls.members) {
                        const auto* md = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (md == nullptr || md->isStatic) continue;
                        if (methodSlots.count(md->name) == 0) {
                            methodSlots[md->name] = static_cast<int>(methodSlotNames.size());
                            methodSlotNames.push_back(md->name);
                        }
                    }
                }
            }
        }
        for (auto& [name, l] : classes) {
            if (l.hasVtable) l.vtslots = computeSlots(name);
        }
        // Pass 2: lay out fields (vtable pointer at slot 0 when polymorphic),
        // inherited fields first, then own.
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    ClassLayout& layout = classes[cls.name];
                    if (layout.isUnion) {
                        // All fields overlap at offset 0; storage is the largest field.
                        std::string biggest;
                        unsigned maxBytes = 0;
                        for (const auto& [fname, ftype] : collectFields(cls.name)) {
                            layout.fieldIndex[fname] = 0;
                            layout.fieldType[fname] = ftype;
                            if (byteSizeOf(ftype) > maxBytes) {
                                maxBytes = byteSizeOf(ftype);
                                biggest = ftype;
                            }
                        }
                        std::vector<llvm::Type*> body;
                        if (!biggest.empty()) body.push_back(llvmType(biggest));
                        layout.type->setBody(body);
                        continue;
                    }
                    std::vector<llvm::Type*> fieldTypes;
                    if (layout.hasVtable) fieldTypes.push_back(builder.getPtrTy());  // vtable ptr
                    unsigned idx = layout.hasVtable ? 1u : 0u;
                    for (const auto& [fname, ftype] : collectFields(cls.name)) {
                        layout.fieldIndex[fname] = idx++;
                        layout.fieldType[fname] = ftype;
                        fieldTypes.push_back(llvmType(ftype));
                    }
                    // Persistent instance fields also get an out-of-object block; the object
                    // holds a pointer to it (set at construction) so this.f and var.f both work
                    // and the field survives `delete` (it lives in the block, not the object).
                    if (!layout.persistOrder.empty()) {
                        std::vector<llvm::Type*> blockTypes;
                        for (const auto& pf : layout.persistOrder)
                            blockTypes.push_back(llvmType(layout.fieldType[pf]));
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
    }

    // Folds a simple literal initializer to an LLVM constant of `llvmType(type)`.
    // Returns nullptr when the expression is not a compile-time literal we handle
    // here (the caller then zero-initializes the global).
    // Folds a constant integer/boolean/char expression, resolving references to
    // namespace-level consts and `comptime` method calls (spec 28) via the shared
    // evaluator. Returns false if not a compile-time integer constant.
    comptime::Context comptimeCtx() {
        comptime::Context ctx;
        ctx.consts = &constIntVals;
        ctx.dconsts = &constDblVals;
        ctx.methods = &comptimeMethods;
        return ctx;
    }
    bool foldConstInt(const ast::Expr& e, long long& out) {
        comptime::Context ctx = comptimeCtx();
        return comptime::evalInt(e, out, ctx);
    }
    // Folds a constant floating-point expression (int consts/literals/calls promote).
    bool foldConstDouble(const ast::Expr& e, double& out) {
        comptime::Context ctx = comptimeCtx();
        return comptime::evalDouble(e, out, ctx);
    }

    // The materialized value of a namespace-level const, at its declared type.
    llvm::Constant* constLiteral(const std::string& name) {
        auto tit = namespaceConstTypes.find(name);
        if (tit == namespaceConstTypes.end()) return nullptr;
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

    // Folds every namespace-level const (in declaration order, so later consts may
    // reference earlier ones). Run before any function body is emitted.
    void emitNamespaceConsts() {
        // Index `comptime` methods first, so const initializers can call them (spec 28.3).
        for (const ast::Bundle& bundle : program.bundles)
            for (const ast::Namespace& ns : bundle.namespaces)
                for (const ast::ClassDecl& cls : ns.classes)
                    for (const ast::MemberPtr& member : cls.members)
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                            m != nullptr && m->isComptime && !m->isAbstract)
                            comptimeMethods.emplace(m->name, m);
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ConstDecl& c : ns.consts) {
                    const std::string type = typeRefName(c.type);
                    namespaceConstTypes[c.name] = type;
                    if (c.init == nullptr) continue;
                    if (isFloatType(type)) {
                        double d;
                        if (foldConstDouble(*c.init, d)) constDblVals[c.name] = d;
                    } else {
                        long long v;
                        if (foldConstInt(*c.init, v)) constIntVals[c.name] = v;
                    }
                }
            }
        }
    }

    llvm::Constant* constFold(const ast::Expr& expr, const std::string& type) {
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
                if (ch != '_' && ch != 'f' && ch != 'F') s += ch;
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
                    if (ch != '_' && ch != 'f' && ch != 'F') s += ch;
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
                if (foldConstDouble(expr, d)) return llvm::ConstantFP::get(lty, d);
            } else {
                long long v;
                if (foldConstInt(expr, v))
                    return llvm::ConstantInt::get(lty, static_cast<std::uint64_t>(v),
                                                  /*isSigned=*/true);
            }
        }
        return nullptr;
    }

    // Emits one zero-initialized (or literal-initialized) LLVM global per static
    // field, named "Class.field". Static fields are class-wide, not per instance.
    // Persistents (spec 18, in-process): a `static persistent` global keeps its constant initial
    // value at startup and whatever it accumulates for the lifetime of the run, like a static
    // field. Per-variable reattach within a run is via the persist blocks (see getPersistBlock).
    void emitStaticFields() {
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    for (const ast::MemberPtr& member : cls.members) {
                        const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
                        if (f == nullptr) continue;
                        if (f->isPersistent && !f->isStatic) {
                            persistentInstanceFields[cls.name].insert(f->name);
                        }
                        if (!f->isStatic) continue;
                        const std::string key = cls.name + "." + f->name;
                        const std::string ftype = staticFieldType[key];
                        llvm::Type* lty = llvmType(ftype);
                        llvm::Constant* init =
                            f->init ? constFold(*f->init, ftype) : nullptr;
                        if (init == nullptr) init = llvm::Constant::getNullValue(lty);
                        staticGlobals[key] =
                            new llvm::GlobalVariable(module, lty, /*isConstant=*/false,
                                                     llvm::GlobalValue::PrivateLinkage, init, key);
                    }
                }
            }
        }
    }

    // Emits one vtable global per concrete polymorphic class: an array of
    // function pointers, one per slot, pointing at the most-derived impl.
    void emitVtables() {
        for (auto& [name, l] : classes) {
            if (!l.hasVtable || l.isAbstract || l.isInterface) continue;  // concrete only
            std::vector<llvm::Constant*> entries;
            for (const std::string& slot : l.vtslots) {
                const std::string impl = vtableImpl(name, slot);
                llvm::Constant* slotFn = llvm::ConstantPointerNull::get(builder.getPtrTy());
                auto fit = functions.find(impl);
                if (!impl.empty() && fit != functions.end()) slotFn = fit->second;  // Function*
                entries.push_back(slotFn);
            }
            // Trailing slot: the most-derived destructor (for virtual `delete`), or null.
            llvm::Constant* dtorFn = llvm::ConstantPointerNull::get(builder.getPtrTy());
            if (const std::string di = dtorImpl(name); !di.empty()) {
                if (auto fit = functions.find(di); fit != functions.end()) dtorFn = fit->second;
            }
            entries.push_back(dtorFn);
            llvm::ArrayType* vtType = llvm::ArrayType::get(builder.getPtrTy(), entries.size());
            l.vtable = new llvm::GlobalVariable(module, vtType, /*isConstant=*/true,
                                                llvm::GlobalValue::PrivateLinkage,
                                                llvm::ConstantArray::get(vtType, entries),
                                                name + ".vtable");
        }
    }

    void declareFunctions() {
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ExternDecl& ex : ns.externs) {  // external C functions (spec 26)
                    std::vector<llvm::Type*> pts;
                    for (const auto& p : ex.params) pts.push_back(llvmType(typeRefName(p.type)));
                    llvm::FunctionType* ty = llvm::FunctionType::get(
                        llvmType(typeRefName(ex.returnType)), pts, ex.isVariadic);
                    functions[ex.name] =
                        llvm::Function::Create(ty, llvm::Function::ExternalLinkage, ex.name, module);
                    externReturnType[ex.name] = typeRefName(ex.returnType);
                }
                for (const ast::ClassDecl& cls : ns.classes) {
                    bool hasCtor = false;
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            if (m == entry.method) {
                                llvm::FunctionType* ty =
                                    llvm::FunctionType::get(builder.getInt32Ty(), false);
                                functions["@entry"] = llvm::Function::Create(
                                    ty, llvm::Function::ExternalLinkage, "main", module);
                                continue;
                            }
                            if (m->isAbstract) continue;  // no body to declare
                            std::vector<llvm::Type*> ptypes;
                            if (!m->isStatic) ptypes.push_back(builder.getPtrTy());
                            for (const auto& p : m->params)
                                ptypes.push_back(llvmType(typeRefName(p.type)));
                            const std::string mangled = cls.name + "." + m->name;
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
                            llvm::FunctionType* ty = llvm::FunctionType::get(
                                llvmType(typeRefName(m->returnType)), ptypes, false);
                            llvm::Function* fn = llvm::Function::Create(
                                ty, llvm::Function::ExternalLinkage, mangled, module);
                            if (m->isVolatile) {  // spec 37.5: never inlined or optimized away
                                fn->addFnAttr(llvm::Attribute::NoInline);
                                fn->addFnAttr(llvm::Attribute::OptimizeNone);
                            }
                            functions[mangled] = fn;
                        } else if (const auto* c =
                                       dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            hasCtor = true;
                            std::vector<llvm::Type*> ptypes;
                            ptypes.push_back(builder.getPtrTy());  // this
                            for (const auto& p : c->params)
                                ptypes.push_back(llvmType(typeRefName(p.type)));
                            llvm::FunctionType* ty =
                                llvm::FunctionType::get(builder.getVoidTy(), ptypes, false);
                            const std::string mangled = cls.name + "." + cls.name;
                            functions[mangled] = llvm::Function::Create(
                                ty, llvm::Function::ExternalLinkage, mangled, module);
                        } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) !=
                                   nullptr) {
                            llvm::FunctionType* ty = llvm::FunctionType::get(
                                builder.getVoidTy(), {builder.getPtrTy()}, false);
                            const std::string mangled = cls.name + ".~" + cls.name;
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
                        const std::string mangled = cls.name + "." + cls.name;
                        functions[mangled] = llvm::Function::Create(
                            ty, llvm::Function::ExternalLinkage, mangled, module);
                    }
                    // spec 32.5 lifecycle hooks (void, no this).
                    auto declHook = [&](const std::unique_ptr<ast::Block>& b, const char* suffix) {
                        if (!b) return;
                        llvm::FunctionType* ty = llvm::FunctionType::get(builder.getVoidTy(), false);
                        functions[cls.name + suffix] = llvm::Function::Create(
                            ty, llvm::Function::ExternalLinkage, cls.name + suffix, module);
                    };
                    declHook(cls.onClassLoad, ".__onClassLoad");
                    declHook(cls.onFirstInstance, ".__onFirstInstance");
                    declHook(cls.onLastInstanceDestroyed, ".__onLastInstanceDestroyed");
                    declHook(cls.onClassUnload, ".__onClassUnload");
                }
                // Namespace-level `comptime literal` suffix functions (spec 17.10).
                for (const ast::LiteralDecl& lit : ns.literals) {
                    llvm::FunctionType* ty = llvm::FunctionType::get(
                        llvmType(typeRefName(lit.returnType)),
                        {llvmType(typeRefName(lit.param.type))}, false);
                    functions[lit.name] = llvm::Function::Create(
                        ty, llvm::Function::ExternalLinkage, "literal." + lit.name, module);
                    literalReturnType[lit.name] = typeRefName(lit.returnType);
                }
                // Catalog-implementing enum methods (spec 12.4). An instance method
                // receives the enum value (its i32 ordinal) as `this`.
                for (const ast::EnumDecl& en : ns.enums) {
                    if (en.isJavaStyle) continue;
                    for (const ast::MemberPtr& member : en.members) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m == nullptr || m->isAbstract) continue;
                        std::vector<llvm::Type*> ptypes;
                        if (!m->isStatic) ptypes.push_back(builder.getInt32Ty());  // this = ordinal
                        for (const auto& p : m->params)
                            ptypes.push_back(llvmType(typeRefName(p.type)));
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

    // Applies every inline field initializer to `thisPtr`, in declaration order.
    // Run at the start of each constructor, before its body (spec 940).
    void emitFieldInits(const ast::ClassDecl& cls, llvm::Value* thisPtr) {
        ClassLayout& layout = classes[cls.name];
        for (const ast::MemberPtr& member : cls.members) {
            const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
            if (f == nullptr || !f->init || f->isStatic) continue;
            auto idx = layout.fieldIndex.find(f->name);
            // A lazy field (spec 28.4) is initialized on first access, not here -- but
            // its storage must start null so the null sentinel is valid (heap objects
            // come from malloc, which does not zero).
            if (f->isLazy) {
                if (idx == layout.fieldIndex.end()) continue;
                llvm::Type* fty = llvmType(typeRefName(f->type));
                if (fty->isPointerTy()) {
                    builder.CreateStore(
                        llvm::ConstantPointerNull::get(builder.getPtrTy()),
                        builder.CreateStructGEP(layout.type, thisPtr, idx->second, f->name));
                }
                continue;
            }
            if (idx == layout.fieldIndex.end()) continue;
            llvm::Value* v = emitExpr(*f->init);
            if (v == nullptr) continue;
            v = maskBitField(v, cls.name, f->name);  // constrain a bit-field initializer (spec 11.1)
            llvm::Value* fp = builder.CreateStructGEP(layout.type, thisPtr, idx->second, f->name);
            builder.CreateStore(v, fp);
        }
    }

    // Completes the current async resume's task with `value` (spec 20.2): the task's result is
    // stored (as a 64-bit slot) and its continuation/waiters are scheduled by the runtime.
    void emitTaskComplete(llvm::Value* value) {
        llvm::FunctionType* ft = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
        llvm::Value* h = builder.CreatePtrToInt(currentAsyncState, builder.getInt64Ty());
        llvm::Value* v;
        if (value == nullptr) v = builder.getInt64(0);
        else if (value->getType()->isPointerTy()) v = builder.CreatePtrToInt(value, builder.getInt64Ty());
        else if (value->getType()->isIntegerTy()) v = builder.CreateIntCast(value, builder.getInt64Ty(), true);
        else if (value->getType()->isDoubleTy()) v = builder.CreateBitCast(value, builder.getInt64Ty());
        else v = builder.getInt64(0);
        builder.CreateCall(module.getOrInsertFunction("__ldp3_task_complete", ft), {h, v});
    }

    void emitBody(llvm::Function* fn, const ast::Block& body,
                  const std::vector<ast::Param>& params, const std::string& thisClass,
                  llvm::Type* retType, const ast::ClassDecl* ctorOf = nullptr,
                  const std::vector<ast::ExprPtr>* requiresClauses = nullptr,
                  const std::vector<ast::ExprPtr>* ensuresClauses = nullptr,
                  const std::vector<const ast::Expr*>* invariants = nullptr,
                  bool hasEnv = false, const std::vector<ast::Capture>* caps = nullptr,
                  const std::vector<std::string>* capTypes = nullptr,
                  const std::string& dtorChainBase = "", const ast::ClassDecl* dtorOf = nullptr,
                  bool asyncResume = false) {
        currentFn = fn;
        currentClass = thisClass;
        currentRetType = retType;
        currentEnsures = ensuresClauses;
        currentInvariants = invariants;
        currentDtorChain = dtorChainBase;  // a destructor calls its base destructor at each exit
        currentThis = nullptr;
        // An async resume's single argument is the ldp3_task* state (spec 20.2); `return`
        // completes it (see the ReturnStmt codegen) rather than returning a value.
        currentAsyncState = asyncResume ? fn->getArg(0) : nullptr;
        locals.clear();
        scopeObjects.clear();
        scopeRegions.clear();
        lazyRegions_.clear();  // region/volatile tracking is keyed by local name; reset per function
        lazyRegionSize_.clear();
        lazyRegionAt_.clear();
        volatileRegions_.clear();
        volatileObjects_.clear();
        deferred.clear();
        labelBlocks.clear();
        llvm::BasicBlock* block = llvm::BasicBlock::Create(context, "entry", fn);
        builder.SetInsertPoint(block);

        unsigned argIdx = 0;
        if (hasEnv) {
            argIdx = 1;  // arg 0 is the captured-environment pointer (a lambda)
        } else if (!thisClass.empty()) {
            currentThis = fn->getArg(0);
            argIdx = 1;
        }
        for (const ast::Param& p : params) {
            const std::string pt = typeRefName(p.type);
            llvm::Value* slot = createEntryAlloca(p.name, llvmType(pt));
            builder.CreateStore(fn->getArg(argIdx), slot);
            locals[p.name] = LocalSlot{slot, pt};
            ++argIdx;
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
            if (ctorOf->onFirstInstance || ctorOf->onLastInstanceDestroyed) {
                llvm::GlobalVariable* ctr = instanceCounter(ctorOf->name);
                llvm::Value* cur = builder.CreateLoad(builder.getInt32Ty(), ctr, "inst.n");
                if (ctorOf->onFirstInstance) {
                    llvm::Function* f = currentFn;
                    auto* doBB = llvm::BasicBlock::Create(context, "first.do", f);
                    auto* contBB = llvm::BasicBlock::Create(context, "first.cont", f);
                    builder.CreateCondBr(builder.CreateICmpEQ(cur, builder.getInt32(0)), doBB, contBB);
                    builder.SetInsertPoint(doBB);
                    builder.CreateCall(functions[ctorOf->name + ".__onFirstInstance"]);
                    builder.CreateBr(contBB);
                    builder.SetInsertPoint(contBB);
                }
                builder.CreateStore(builder.CreateAdd(cur, builder.getInt32(1)), ctr);
            }
        }

        // Instance lifecycle (spec 32.5): a destructor decrements the live-instance count
        // and runs onLastInstanceDestroyed when it reaches zero.
        if (dtorOf != nullptr && (dtorOf->onLastInstanceDestroyed || dtorOf->onFirstInstance)) {
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
                builder.CreateCall(functions[dtorOf->name + ".__onLastInstanceDestroyed"]);
                builder.CreateBr(contBB);
                builder.SetInsertPoint(contBB);
            }
        }

        // Contracts: preconditions run after the prologue, before the body (spec 29).
        if (requiresClauses != nullptr)
            for (const ast::ExprPtr& r : *requiresClauses) emitContractCheck(*r, "requires");
        // Capture each old(e) in the ensures clauses at entry, so the exit check compares against
        // the entry-time value (spec 29).
        oldValues_.clear();
        if (ensuresClauses != nullptr) {
            std::vector<const ast::OldExpr*> olds;
            for (const ast::ExprPtr& e : *ensuresClauses) collectOld(e.get(), olds);
            for (const ast::OldExpr* o : olds) {
                llvm::Value* v = emitExpr(*o->inner);
                if (v == nullptr) continue;
                llvm::Value* slot = createEntryAlloca("old", v->getType());
                builder.CreateStore(v, slot);
                oldValues_[o] = slot;
            }
        }

        // Entry point: run every class's onClassLoad hook once, before main (spec 32.5).
        if (auto eit = functions.find("@entry"); eit != functions.end() && fn == eit->second) {
            for (const ast::Bundle& b : program.bundles)
                for (const ast::Namespace& n : b.namespaces)
                    for (const ast::ClassDecl& c : n.classes)
                        // `lazy import` defers a class's load to its first instance (spec 37.3).
                        if (c.onClassLoad && !isLazyImport(c.name))
                            builder.CreateCall(functions[c.name + ".__onClassLoad"]);
        }

        emitBlock(body, /*newScope=*/false);  // emitBody owns function-level teardown (+ contracts)
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            emitScopeCleanup();
            if (currentAsyncState != nullptr) {
                emitTaskComplete(nullptr);  // async body fell through without an explicit return
                builder.CreateRetVoid();
            } else if (retType->isVoidTy()) {
                builder.CreateRetVoid();
            } else if (retType->isDoubleTy()) {
                builder.CreateRet(llvm::ConstantFP::get(retType, 0.0));
            } else if (retType->isStructTy()) {
                builder.CreateRet(llvm::UndefValue::get(retType));  // tuple: no implicit default
            } else {
                builder.CreateRet(builder.getInt32(0));
            }
        }
    }

    // The heap state object for an async method (spec 20.2): field 0 is the resume-point index,
    // field 1 is the task it produces, then one field per parameter. (Slice B will append the
    // body's locals + await temporaries here so they survive suspension.)
    llvm::StructType* asyncStateType(const ast::MethodDecl& m, const std::string& mangled) {
        std::vector<llvm::Type*> fields = {builder.getInt32Ty(), builder.getPtrTy()};
        for (const auto& p : m.params) fields.push_back(llvmType(typeRefName(p.type)));
        return llvm::StructType::create(context, fields, mangled + "$state");
    }

    // Emits an async method (spec 20.2) as two functions: a resume function holding the body
    // (whose `return X` completes the task), and a wrapper that allocates the state object, copies
    // the arguments in, schedules the resume on the worker pool, and returns the Task immediately.
    void emitAsyncMethod(const ast::ClassDecl& cls, const ast::MethodDecl& m) {
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
        currentDtorChain = "";
        locals.clear();
        scopeObjects.clear();
        scopeRegions.clear();
        lazyRegions_.clear();  // region/volatile tracking is keyed by local name; reset per function
        lazyRegionSize_.clear();
        lazyRegionAt_.clear();
        volatileRegions_.clear();
        volatileObjects_.clear();
        deferred.clear();
        labelBlocks.clear();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", res));
        llvm::Value* st = res->getArg(0);
        currentAsyncState = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateStructGEP(stateTy, st, 1, "st.task.addr"), "st.task");
        for (std::size_t i = 0; i < m.params.size(); ++i)
            locals[m.params[i].name] = LocalSlot{
                builder.CreateStructGEP(stateTy, st, 2 + i, m.params[i].name),
                typeRefName(m.params[i].type)};
        emitBlock(m.body, /*newScope=*/false);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            emitTaskComplete(nullptr);
            builder.CreateRetVoid();
        }
        currentAsyncState = nullptr;
        emitAsyncWrapper(stateTy, m, mangled);
    }

    // The wrapper foo(args): allocate the state object, copy arguments into it, schedule the
    // resume on the worker pool, and return a Task<T> immediately (spec 20.2).
    void emitAsyncWrapper(llvm::StructType* stateTy, const ast::MethodDecl& m,
                          const std::string& mangled) {
        llvm::Function* res = functions[mangled + "$resume"];
        llvm::Function* wrap = functions[mangled];
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", wrap));
        llvm::FunctionType* tnTy = llvm::FunctionType::get(builder.getInt64Ty(), false);
        llvm::Value* taskH =
            builder.CreateCall(module.getOrInsertFunction("__ldp3_task_new", tnTy), {}, "task");
        llvm::Value* state = builder.CreateCall(mallocFn(), {sizeOf(stateTy)}, "state");
        builder.CreateStore(builder.getInt32(0), builder.CreateStructGEP(stateTy, state, 0));
        builder.CreateStore(builder.CreateIntToPtr(taskH, builder.getPtrTy()),
                            builder.CreateStructGEP(stateTy, state, 1));
        for (std::size_t i = 0; i < m.params.size(); ++i)
            builder.CreateStore(wrap->getArg(i), builder.CreateStructGEP(stateTy, state, 2 + i));
        llvm::FunctionType* schTy = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        builder.CreateCall(module.getOrInsertFunction("__ldp3_schedule", schTy), {res, state});
        const std::string taskCls = ast::mangleGeneric("Task", {typeRefName(m.returnType)});
        llvm::Value* obj = llvm::ConstantPointerNull::get(builder.getPtrTy());
        if (auto cit = classes.find(taskCls); cit != classes.end()) {
            obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "task.obj");
            if (auto ctor = functions.find(taskCls + "." + taskCls); ctor != functions.end())
                builder.CreateCall(ctor->second, {obj});
            if (auto hIt = cit->second.fieldIndex.find("h"); hIt != cit->second.fieldIndex.end())
                builder.CreateStore(taskH, builder.CreateStructGEP(cit->second.type, obj,
                                                                   hIt->second, "task.h.addr"));
        }
        builder.CreateRet(obj);
    }

    // Widens a value to a 64-bit slot (for task results / channel elements): pointers and doubles
    // are reinterpreted, integers sign-extended.
    llvm::Value* valueToI64(llvm::Value* v) {
        if (v->getType()->isPointerTy()) return builder.CreatePtrToInt(v, builder.getInt64Ty());
        if (v->getType()->isDoubleTy()) return builder.CreateBitCast(v, builder.getInt64Ty());
        if (v->getType()->isIntegerTy()) return builder.CreateIntCast(v, builder.getInt64Ty(), true);
        return v;
    }

    // Casts a 64-bit task-result slot back to the awaited type T.
    llvm::Value* castTaskResult(llvm::Value* res64, const std::string& t) {
        llvm::Type* tt = llvmType(t);
        if (tt->isPointerTy()) return builder.CreateIntToPtr(res64, tt);
        if (tt->isDoubleTy()) return builder.CreateBitCast(res64, tt);
        if (tt->isIntegerTy()) return builder.CreateIntCast(res64, tt, true);
        return res64;
    }

    // Collects every local declared anywhere in an async body (recursing into control flow), so
    // they can live in the state object and survive suspension.
    void scanAsyncLocals(const ast::Block& b, std::vector<std::pair<std::string, std::string>>& out) {
        for (const auto& sp : b.statements) scanAsyncLocalsS(sp.get(), out);
    }
    void scanAsyncLocalsS(const ast::Stmt* s, std::vector<std::pair<std::string, std::string>>& out) {
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s))
            out.push_back({vd->name, vd->isVar ? typeName(*vd->init) : typeRefName(vd->type)});
        else if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
            scanAsyncLocals(i->thenBlock, out);
            if (i->elseBlock) scanAsyncLocals(*i->elseBlock, out);
        } else if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) {
            scanAsyncLocals(w->body, out);
        } else if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) {
            scanAsyncLocals(d->body, out);
        } else if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) {
            if (f->init) scanAsyncLocalsS(f->init.get(), out);
            scanAsyncLocals(f->body, out);
        } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
            scanAsyncLocals(fe->body, out);
        }
    }
    // Counts every await reachable in an async body (recursing into control flow + the await-
    // bearing expressions), so the state object can reserve a handle slot per await.
    int countAwaitsE(const ast::Expr* e) {
        if (e == nullptr) return 0;
        if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(e))
            return 1 + countAwaitsE(aw->operand.get());
        if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e))
            return countAwaitsE(b->lhs.get()) + countAwaitsE(b->rhs.get());
        if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e))
            return countAwaitsE(u->operand.get());
        if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
            int n = 0;
            for (const auto& a : c->args) n += countAwaitsE(a.get());
            return n;
        }
        if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) return countAwaitsE(ca->operand.get());
        if (const auto* mx = dynamic_cast<const ast::MemberExpr*>(e)) return countAwaitsE(mx->object.get());
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e))
            return countAwaitsE(ix->array.get()) + countAwaitsE(ix->index.get());
        return 0;
    }
    int countAsyncAwaitsS(const ast::Stmt* s) {
        int n = 0;
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) n += countAwaitsE(vd->init.get());
        else if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) n += countAwaitsE(es->expr.get());
        else if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) n += countAwaitsE(rs->value.get());
        else if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) n += countAwaitsE(as->value.get());
        else if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
            n += countAwaitsE(i->cond.get()) + countAsyncAwaits(i->thenBlock);
            if (i->elseBlock) n += countAsyncAwaits(*i->elseBlock);
        } else if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) {
            n += countAwaitsE(w->cond.get()) + countAsyncAwaits(w->body);
        } else if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) {
            n += countAsyncAwaits(d->body) + countAwaitsE(d->cond.get());
        } else if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) {
            if (f->init) n += countAsyncAwaitsS(f->init.get());
            n += countAwaitsE(f->cond.get()) + countAsyncAwaits(f->body);
        } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
            n += countAsyncAwaits(fe->body);
        }
        return n;
    }
    int countAsyncAwaits(const ast::Block& b) {
        int n = 0;
        for (const auto& sp : b.statements) n += countAsyncAwaitsS(sp.get());
        return n;
    }
    bool containsAwait(const ast::Expr& e) { return countAwaitsE(&e) > 0; }
    bool laterArgAwaits(const std::vector<ast::ExprPtr>& a, std::size_t i) {
        for (std::size_t j = i + 1; j < a.size(); ++j)
            if (containsAwait(*a[j])) return true;
        return false;
    }
    bool anyArgAwaits(const std::vector<ast::ExprPtr>& a) {
        for (const auto& x : a)
            if (containsAwait(*x)) return true;
        return false;
    }
    // Saves a value into the async state object so it survives a later await's suspend/resume
    // split (otherwise it would not dominate its use in the resume block). reloadSpill reads it
    // back after the await. Spills/reloads nest LIFO within an expression.
    SpillToken spillAcrossAwait(llvm::Value* v) {
        SpillToken t;
        if (!asyncSM || v == nullptr || asyncSpillTop_ >= kAsyncScratchSlots) return t;
        t.active = true;
        t.slot = asyncSMScratchBase + static_cast<unsigned>(asyncSpillTop_++);
        t.ty = v->getType();
        builder.CreateStore(
            v, builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, t.slot, "spill"));
        return t;
    }
    llvm::Value* reloadSpill(const SpillToken& t, llvm::Value* orig) {
        if (!t.active) return orig;
        --asyncSpillTop_;
        return builder.CreateLoad(
            t.ty, builder.CreateStructGEP(asyncSMState, asyncSMStatePtr, t.slot, "reload"),
            "spilled");
    }

    // Emits an async method whose body awaits (spec 20.2) as a state machine, via coroutine
    // lowering: every local lives in the heap state object, the body is emitted with its natural
    // control flow, and each `await` (anywhere -- including inside loops/ifs) splits its block into
    // a suspend/resume pair. The entry switch jumps to the saved resume block; `await` in emitExpr
    // either reads an already-ready result or registers a continuation and returns (suspends).
    void emitAsyncStateMachine(const ast::ClassDecl& cls, const ast::MethodDecl& m) {
        const std::string mangled = cls.name + "." + m.name;
        std::vector<std::pair<std::string, std::string>> tlocals;
        scanAsyncLocals(m.body, tlocals);
        const int awaitCount = countAsyncAwaits(m.body);

        // State layout: {i32 state, ptr task, args..., locals..., awaitHandles(i64)...}.
        std::vector<llvm::Type*> fields = {builder.getInt32Ty(), builder.getPtrTy()};
        const unsigned argBase = 2;
        for (const auto& p : m.params) fields.push_back(llvmType(typeRefName(p.type)));
        const unsigned localBase = static_cast<unsigned>(fields.size());
        for (const auto& l : tlocals) fields.push_back(llvmType(l.second));
        const unsigned awaitBase = static_cast<unsigned>(fields.size());
        for (int k = 0; k < awaitCount; ++k) fields.push_back(builder.getInt64Ty());
        const unsigned scratchBase = static_cast<unsigned>(fields.size());
        for (int k = 0; k < kAsyncScratchSlots; ++k) fields.push_back(builder.getInt64Ty());
        llvm::StructType* stateTy = llvm::StructType::create(context, fields, mangled + "$state");

        llvm::Function* res = functions[mangled + "$resume"];
        currentFn = res;
        currentClass = "";
        currentRetType = builder.getVoidTy();
        currentThis = nullptr;
        currentEnsures = nullptr;
        currentInvariants = nullptr;
        currentDtorChain = "";
        locals.clear();
        scopeObjects.clear();
        scopeRegions.clear();
        lazyRegions_.clear();  // region/volatile tracking is keyed by local name; reset per function
        lazyRegionSize_.clear();
        lazyRegionAt_.clear();
        volatileRegions_.clear();
        volatileObjects_.clear();
        deferred.clear();
        labelBlocks.clear();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", res));
        llvm::Value* st = res->getArg(0);
        currentAsyncState = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateStructGEP(stateTy, st, 1, "st.task.addr"), "st.task");
        for (std::size_t i = 0; i < m.params.size(); ++i)
            locals[m.params[i].name] = LocalSlot{
                builder.CreateStructGEP(stateTy, st, argBase + i, m.params[i].name),
                typeRefName(m.params[i].type)};
        for (std::size_t j = 0; j < tlocals.size(); ++j)
            locals[tlocals[j].first] = LocalSlot{
                builder.CreateStructGEP(stateTy, st, localBase + j, tlocals[j].first),
                tlocals[j].second};

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
        emitBlock(m.body, /*newScope=*/false);  // natural control flow; awaits split their blocks
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            emitTaskComplete(nullptr);
            builder.CreateRetVoid();
        }
        builder.SetInsertPoint(suspendBlk);
        builder.CreateRetVoid();
        for (const auto& [idx, blk] : asyncSMCases) sw->addCase(builder.getInt32(idx), blk);

        asyncSM = false;
        currentAsyncState = nullptr;
        emitAsyncWrapper(stateTy, m, mangled);
    }

    void emitFunctions() {
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    bool hasCtor = false;
                    enclosingClass_ = cls.name;
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            enclosingMethod_ = m->name;
                            if (m == entry.method) {
                                emitBody(functions["@entry"], m->body, {}, "",
                                         builder.getInt32Ty());
                            } else if (m->isAsync && !m->isAbstract) {
                                emitAsyncMethod(cls, *m);
                            } else if (!m->isAbstract) {
                                emitBody(functions[cls.name + "." + m->name], m->body, m->params,
                                         m->isStatic ? std::string() : cls.name,
                                         llvmType(typeRefName(m->returnType)), nullptr,
                                         &m->requiresClauses, &m->ensuresClauses,
                                         m->isStatic ? nullptr : &classInvariants(cls.name));
                            }
                        } else if (const auto* c =
                                       dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            hasCtor = true;
                            enclosingMethod_ = cls.name;  // ctor function is "class.class"
                            emitBody(functions[cls.name + "." + cls.name], c->body, c->params,
                                     cls.name, builder.getVoidTy(), &cls,
                                     &c->requiresClauses, &c->ensuresClauses,
                                     &classInvariants(cls.name));
                        } else if (const auto* d =
                                       dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                            // Chain to the nearest ancestor's destructor (derived-then-base).
                            enclosingMethod_ = "~" + cls.name;  // dtor function is "class.~class"
                            emitBody(functions[cls.name + ".~" + cls.name], d->body, {}, cls.name,
                                     builder.getVoidTy(), nullptr, nullptr, nullptr, nullptr, false,
                                     nullptr, nullptr, dtorImpl(cls.superclass), &cls);
                        }
                    }
                    // Emit the synthesized default constructor (sets the vtable +
                    // field inits). Interfaces get none.
                    if (!hasCtor && !cls.isInterface) {
                        const ast::Block emptyBody;
                        enclosingMethod_ = cls.name;
                        emitBody(functions[cls.name + "." + cls.name], emptyBody, {}, cls.name,
                                 builder.getVoidTy(), &cls);
                    }
                    // spec 32.5: static-context hook bodies.
                    auto emitHook = [&](const std::unique_ptr<ast::Block>& b, const char* suffix) {
                        if (b)
                            emitBody(functions[cls.name + suffix], *b, {}, /*thisClass=*/"",
                                     builder.getVoidTy());
                    };
                    emitHook(cls.onClassLoad, ".__onClassLoad");
                    emitHook(cls.onFirstInstance, ".__onFirstInstance");
                    emitHook(cls.onLastInstanceDestroyed, ".__onLastInstanceDestroyed");
                    emitHook(cls.onClassUnload, ".__onClassUnload");
                }
                // Literal suffix bodies: emitted as static functions (no `this`).
                for (const ast::LiteralDecl& lit : ns.literals) {
                    emitBody(functions[lit.name], lit.body, {lit.param}, /*thisClass=*/"",
                             llvmType(typeRefName(lit.returnType)));
                }
                // Catalog-implementing enum method bodies (spec 12.4). For an instance
                // method, `this` is the enum value (an i32 ordinal), so thisClass is the
                // enum name (binds currentThis to arg 0) but there is no vtable/field init.
                for (const ast::EnumDecl& en : ns.enums) {
                    if (en.isJavaStyle) continue;
                    for (const ast::MemberPtr& member : en.members) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m == nullptr || m->isAbstract) continue;
                        emitBody(functions[en.name + "." + m->name], m->body, m->params,
                                 m->isStatic ? std::string() : en.name,
                                 llvmType(typeRefName(m->returnType)), nullptr,
                                 &m->requiresClauses, &m->ensuresClauses);
                    }
                }
            }
        }
    }
};

CodeGenerator::CodeGenerator(const ast::Program& program, const EntryPoint& entry,
                             std::string_view moduleName)
    : impl_(std::make_unique<Impl>(program, entry, moduleName, errors_)) {}

CodeGenerator::~CodeGenerator() = default;

void CodeGenerator::setTargetTriple(const std::string& triple) {
    impl_->module.setTargetTriple(triple);
}

bool CodeGenerator::generate() {
    if (impl_->entry.method == nullptr) {
        errors_.push_back(CodegenError{"no entry point to generate", {}});
        return false;
    }
    impl_->declareClasses();
    impl_->collectAbstainedLabels();
    impl_->emitNamespaceConsts();
    impl_->emitStaticFields();
    impl_->declareFunctions();
    impl_->buildFunctionTable();  // address table for physical unimport (spec 30)
    impl_->emitVtables();
    impl_->emitFunctions();
    if (!errors_.empty()) return false;

    std::string verifyMsg;
    llvm::raw_string_ostream os(verifyMsg);
    if (llvm::verifyModule(impl_->module, &os)) {
        errors_.push_back(CodegenError{"module verification failed: " + verifyMsg, {}});
        return false;
    }
    return true;
}

namespace {

// LDP3 middle-end pass: bounded recursive self-inlining (spec: close the gap to GCC on recursion).
// clang's inliner refuses to inline a function into itself, so naive recursion (e.g. fib) pays a
// call on every node. GCC inlines a few levels; we inline deeper, under an instruction budget, so
// each call does several recursion levels of work inline before recursing. Measured ~8x on fib(40)
// vs clang's naive code, beating GCC. Correctness is unconditional (inlining always preserves
// semantics); the budget bounds code growth.
struct RecursiveInlinePass : llvm::PassInfoMixin<RecursiveInlinePass> {
    static unsigned instCount(const llvm::Function& f) {
        unsigned n = 0;
        for (const llvm::BasicBlock& bb : f) n += static_cast<unsigned>(bb.size());
        return n;
    }

    llvm::PreservedAnalyses run(llvm::Module& m, llvm::ModuleAnalysisManager&) {
        bool changed = false;
        for (llvm::Function& f : m) {
            if (f.isDeclaration() || f.isVarArg()) continue;
            if (f.hasPersonalityFn()) continue;  // skip exception-handling functions (landing pads)
            if (f.hasFnAttribute(llvm::Attribute::NoInline)) continue;
            const unsigned base = instCount(f);
            if (base > 80) continue;  // only small functions: deep inlining of a big body explodes
            // Is it self-recursive? (a direct call to itself somewhere.)
            bool selfRec = false;
            for (llvm::BasicBlock& bb : f)
                for (llvm::Instruction& i : bb)
                    if (auto* cb = llvm::dyn_cast<llvm::CallBase>(&i))
                        if (cb->getCalledFunction() == &f) selfRec = true;
            if (!selfRec) continue;
            // Inline self-calls round by round; a fixed instruction budget bounds total growth and
            // caps the effective depth (deeper for tinier bodies). Innermost self-calls stay as real
            // recursion.
            const unsigned budget = base <= 25 ? 700u : 1500u;
            for (int round = 0; round < 16; ++round) {
                std::vector<llvm::CallBase*> sites;
                for (llvm::BasicBlock& bb : f)
                    for (llvm::Instruction& i : bb)
                        if (auto* cb = llvm::dyn_cast<llvm::CallBase>(&i))
                            if (cb->getCalledFunction() == &f) sites.push_back(cb);
                if (sites.empty()) break;
                bool didAny = false;
                for (llvm::CallBase* cb : sites) {
                    if (instCount(f) >= budget) break;
                    llvm::InlineFunctionInfo ifi;
                    if (llvm::InlineFunction(*cb, ifi).isSuccess()) {
                        didAny = true;
                        changed = true;
                    }
                }
                if (!didAny || instCount(f) >= budget) break;
            }
        }
        return changed ? llvm::PreservedAnalyses::none() : llvm::PreservedAnalyses::all();
    }
};

}  // namespace

void CodeGenerator::optimize(int level) {
    if (level <= 0) return;  // O0: leave the IR as generated
    llvm::OptimizationLevel ol = level >= 3   ? llvm::OptimizationLevel::O3
                                 : level == 2 ? llvm::OptimizationLevel::O2
                                              : llvm::OptimizationLevel::O1;
    // The four analysis managers the new pass manager needs, cross-registered.
    llvm::LoopAnalysisManager lam;
    llvm::FunctionAnalysisManager fam;
    llvm::CGSCCAnalysisManager cgam;
    llvm::ModuleAnalysisManager mam;
    llvm::PassBuilder pb;
    // Our middle-end passes run before the default pipeline, which then cleans up and optimizes the
    // result. This is where the transforms clang's default pipeline omits (recursive inlining now;
    // loop interchange next) live.
    pb.registerPipelineStartEPCallback(
        [](llvm::ModulePassManager& mpm, llvm::OptimizationLevel) {
            mpm.addPass(RecursiveInlinePass());
        });
    pb.registerModuleAnalyses(mam);
    pb.registerCGSCCAnalyses(cgam);
    pb.registerFunctionAnalyses(fam);
    pb.registerLoopAnalyses(lam);
    pb.crossRegisterProxies(lam, fam, cgam, mam);
    llvm::ModulePassManager mpm = pb.buildPerModuleDefaultPipeline(ol);
    mpm.run(impl_->module, mam);
}

std::string CodeGenerator::toIR() const {
    std::string out;
    llvm::raw_string_ostream os(out);
    impl_->module.print(os, nullptr);
    return out;
}

}  // namespace ldp3
