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
#include <llvm/IR/Verifier.h>
#include <llvm/Support/raw_ostream.h>

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "parser/ast.h"

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

// Floating-point types. `float`/`float32` lower to f32; `double`/`float64` to f64.
bool isFloatType(const std::string& t) {
    return t == "float" || t == "float32" || t == "double" || t == "float64";
}
bool isF32(const std::string& t) { return t == "float" || t == "float32"; }

// Bit width of an integer-family type (int/char/boolean/enum default to 32).
unsigned intBits(const std::string& t) {
    if (t == "int8" || t == "uint8" || t == "byte") return 8;
    if (t == "int16" || t == "uint16" || t == "short") return 16;
    if (t == "int64" || t == "uint64" || t == "long") return 64;
    return 32;
}

// Unsigned integer types (uint8..uint64). `byte` is int8 (signed) per spec 5.
bool isUnsigned(const std::string& t) { return t.rfind("uint", 0) == 0; }

// Approximate byte size of a type, used to size a union's shared storage.
// Pointers/refs/arrays/classes are pointer-sized.
unsigned byteSizeOf(const std::string& t) {
    if (t == "double" || t == "float64") return 8;
    if (t == "float" || t == "float32") return 4;
    if (t.back() == '*' || t.back() == '&' || (t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0))
        return 8;  // pointer-sized
    return intBits(t) / 8;  // int family (and class names fall back to 4; refined later)
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
    return isRefType(t) ? t.substr(0, t.size() - 1) : t;
}

// The LDP3 type name of a declaration, including array / pointer / ref markers.
// Generic arguments are mangled into the name (Box<int> -> "Box$int").
std::string typeRefName(const ast::TypeRef& t) {
    return ast::mangleGeneric(t.name, t.typeArgs) + (t.isArray ? "[]" : "") +
           (t.isPointer ? "*" : "") + (t.isRef ? "&" : "");
}

// Layout of a class: its LLVM struct, field indices/types, and method returns.
// Polymorphic classes (in a hierarchy) carry a vtable pointer at field 0.
struct ClassLayout {
    const ast::ClassDecl* decl = nullptr;  // source declaration (members in order)
    llvm::StructType* type = nullptr;
    std::unordered_map<std::string, unsigned> fieldIndex;  // includes inherited fields
    std::unordered_map<std::string, std::string> fieldType;  // LDP3 type name per field
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
};

// A stack object with a destructor, pending end-of-scope cleanup (RAII).
struct ScopeObject {
    llvm::Value* slot = nullptr;  // the variable's slot (holds a pointer to the struct)
    std::string className;
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
    std::unordered_map<std::string, LocalSlot> locals;
    std::vector<ScopeObject> scopeObjects;  // stack objects awaiting destructor calls
    std::vector<const ast::Block*> deferred;  // defer blocks, run at scope end (LIFO)
    std::string currentClass;        // "" inside a static method / the entry point
    llvm::Value* currentThis = nullptr;
    llvm::Function* currentFn = nullptr;
    llvm::Type* currentRetType = nullptr;
    const std::vector<ast::ExprPtr>* currentEnsures = nullptr;  // contracts: postconditions
    const std::vector<ast::ExprPtr>* currentInvariants = nullptr;  // contracts: class invariants
    struct LoopTargets { llvm::BasicBlock* brk; llvm::BasicBlock* cont; std::string label; };
    std::vector<LoopTargets> loopStack;  // (break, continue, label) per active loop / switch
    std::string pendingLoopLabel;        // label to attach to the next loop (from a LabeledStmt)
    std::unordered_map<std::string, llvm::BasicBlock*> labelBlocks;  // `label name;` targets (comefrom)
    std::vector<llvm::BasicBlock*> ehPadStack;   // active try landing pads (catchswitch blocks)
    llvm::Constant* ehThrowInfoCache = nullptr;  // shared carrier-ptr ThrowInfo (_TI1PEAX), lazy
    llvm::Constant* ehTypeDescCache = nullptr;   // shared carrier-ptr type descriptor, lazy

    Impl(const ast::Program& p, const EntryPoint& e, std::string_view name,
         std::vector<CodegenError>& errs)
        : program(p), entry(e), errors(errs), module(std::string(name), context), builder(context) {}

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

    // float/float32 -> f32, double/float64 -> f64; class/array/pointer/ref ->
    // opaque pointer; int/boolean/char/enum -> iN; tuple -> anonymous struct.
    llvm::Type* llvmType(const std::string& t) {
        if (t == "void") return builder.getVoidTy();
        if (isTupleType(t)) return tupleStructType(t);
        if (isFloatType(t)) return isF32(t) ? builder.getFloatTy() : builder.getDoubleTy();
        if (isArrayType(t) || isRefType(t)) return builder.getPtrTy();
        if (t == "region") return builder.getPtrTy();  // pointer to the region block
        if (t.rfind("function<", 0) == 0) return builder.getPtrTy();  // a function value (pointer)
        if (classes.count(t) > 0) return builder.getPtrTy();
        return builder.getIntNTy(intBits(t));
    }

    // Adjusts a value to the target type: int->float widening, or integer
    // sign/zero-extend / truncate to the target bit width. Unsigned sources
    // zero-extend and use the unsigned int->float opcode.
    llvm::Value* coerce(llvm::Value* v, const std::string& from, const std::string& to) {
        if (v == nullptr) return v;
        if (isFloatType(to)) {
            llvm::Type* fty = llvmType(to);
            if (v->getType()->isIntegerTy()) {
                return isUnsigned(from) ? builder.CreateUIToFP(v, fty)
                                        : builder.CreateSIToFP(v, fty);
            }
            if (v->getType()->isFloatingPointTy() && v->getType() != fty) {
                return fty->isDoubleTy() ? builder.CreateFPExt(v, fty)     // f32 -> f64
                                         : builder.CreateFPTrunc(v, fty);  // f64 -> f32
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

    // Explicit numeric conversion for cast<T>(expr): covers every direction,
    // including the narrowing ones the implicit `coerce` refuses (long->int,
    // float->int, f64->f32). Unsigned source/target selects zero-extension and
    // the unsigned int<->float opcodes.
    llvm::Value* emitCast(llvm::Value* v, const std::string& from, const std::string& to) {
        if (v == nullptr) return v;
        const bool toFloat = isFloatType(to);
        const bool fromFloat = isFloatType(from);
        if (toFloat) {
            llvm::Type* fty = llvmType(to);
            if (fromFloat) {
                if (v->getType() == fty) return v;
                return fty->isDoubleTy() ? builder.CreateFPExt(v, fty)
                                         : builder.CreateFPTrunc(v, fty);
            }
            return isUnsigned(from) ? builder.CreateUIToFP(v, fty)
                                    : builder.CreateSIToFP(v, fty);
        }
        if (fromFloat) {
            return isUnsigned(to) ? builder.CreateFPToUI(v, llvmType(to))   // truncates toward zero
                                  : builder.CreateFPToSI(v, llvmType(to));
        }
        return fitInt(v, intBits(to), isUnsigned(from));  // int -> int: zext/sext / trunc
    }

    // Coerce a value to a target LLVM type (numeric widen/narrow), e.g. when an
    // argument's static type is a subtype of the parameter type.
    llvm::Value* coerceToType(llvm::Value* v, llvm::Type* ty) {
        if (v == nullptr || v->getType() == ty) return v;
        if (ty->isDoubleTy() && v->getType()->isIntegerTy()) return builder.CreateSIToFP(v, ty);
        if (ty->isIntegerTy() && v->getType()->isIntegerTy()) {
            const unsigned want = ty->getIntegerBitWidth();
            const unsigned have = v->getType()->getIntegerBitWidth();
            if (want > have) return builder.CreateSExt(v, ty);
            if (want < have) return builder.CreateTrunc(v, ty);
        }
        return v;
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
            return (v >= INT32_MIN && v <= INT32_MAX) ? "int" : "int64";
        }
        if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) return "null";
        if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
            std::string s = "function<" + typeRefName(lam->returnType);
            for (const auto& p : lam->params) s += "," + typeRefName(p.type);
            return s + ">";
        }
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
            return it == locals.end() ? std::string("int") : it->second.type;
        }
        if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
            if (un->op == "&") return typeName(*un->operand) + "*";  // address-of
            if (un->op == "~") return typeName(*un->operand);  // bitwise not keeps the width
            return un->op == "!" ? "boolean" : "int";
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
            if (isFloatType(lt) || isFloatType(rt)) return "double";
            // Arithmetic result: the wider operand's width; unsigned is contagious.
            const unsigned w = std::max(intBits(lt), intBits(rt));
            const bool u = isUnsigned(lt) || isUnsigned(rt);
            if (w == 8) return u ? "uint8" : "int8";
            if (w == 16) return u ? "uint16" : "int16";
            if (w == 64) return u ? "uint64" : "int64";
            return u ? "uint32" : "int";
        }
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
            return ast::mangleGeneric(nw->className, nw->typeArgs);
        }
        if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
            return na->elementType + "[]";
        }
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
            const std::string at = typeName(*ix->array);
            const std::string owner = methodOwner(baseType(at), "operator[]");
            if (!owner.empty()) return classes[owner].methodReturnType["operator[]"];
            return isArrayType(at) ? at.substr(0, at.size() - 2) : std::string("int");
        }
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                if (mem->member == "length" && isArrayType(typeName(*mem->object))) return "int";
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
                if (!owner.empty()) return classes[owner].methodReturnType[mem->member];
            }
            // Namespace-level literal suffix function: name(arg).
            auto lit = literalReturnType.find(flattenCallee(*call->callee));
            if (lit != literalReturnType.end()) return lit->second;
            return "int";
        }
        if (dynamic_cast<const ast::RegionInitExpr*>(&expr) != nullptr) return "region";
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
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
        if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) return typeName(*mv->operand);
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

    // A class value (not a pointer/ref, not an array, not a primitive/enum).
    bool isClassValue(const std::string& t) {
        return !isRefType(t) && !isArrayType(t) && classes.count(t) > 0;
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
    llvm::Value* emitArrayDup(llvm::Value* srcBlock) {
        llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), srcBlock, "arr.len");
        llvm::Value* total = builder.CreateAdd(builder.getInt64(8),
                                               builder.CreateMul(len, builder.getInt64(4)));
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
                deep = emitArrayDup(builder.CreateLoad(builder.getPtrTy(), srcSlot));
            } else if (isClassValue(ftype) && isCopyDiscipline(ftype)) {
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitClassCopy(ftype, builder.CreateLoad(builder.getPtrTy(), srcSlot), heap);
            }
            if (deep != nullptr) builder.CreateStore(deep, builder.CreateStructGEP(st, dest, idx));
        }
        return dest;
    }

    // Array memory layout: one heap block [ i64 length | elem 0 | elem 1 | ... ].
    // The array value is a pointer to the length header; elements (i32 in M5)
    // start 8 bytes in.
    llvm::Value* arrayData(llvm::Value* block) {
        return builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "arr.data");
    }
    llvm::Value* arrayElemPtr(llvm::Value* block, llvm::Value* index) {
        return builder.CreateGEP(builder.getInt32Ty(), arrayData(block), index, "arr.elem");
    }

    llvm::Value* emitNewArray(const ast::NewArrayExpr& na) {
        llvm::Value* n = emitExpr(*na.size);
        if (n == nullptr) return nullptr;
        llvm::Value* n64 = builder.CreateSExt(n, builder.getInt64Ty());
        llvm::Value* elemBytes = builder.CreateMul(n64, builder.getInt64(4));  // i32 elements
        llvm::Value* total = builder.CreateAdd(builder.getInt64(8), elemBytes);
        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "arr");
        builder.CreateStore(n64, block);  // length header
        builder.CreateCall(memsetFn(), {arrayData(block), builder.getInt32(0), elemBytes});
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

    llvm::Value* emitObjectPtr(const ast::Expr& expr) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
            if (id->name == "this") return currentThis;
            auto it = locals.find(id->name);
            if (it == locals.end()) {
                error("use of undeclared variable '" + id->name + "'", id->loc);
                return nullptr;
            }
            return builder.CreateLoad(builder.getPtrTy(), it->second.storage, id->name);
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
            return arrayElemPtr(block, index);
        }
        error("invalid assignment target", expr.loc);
        return nullptr;
    }

    llvm::Value* emitExpr(const ast::Expr& expr) {
        if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(&expr)) {
            return builder.CreateGlobalStringPtr(resolveEscapes(s->value), ".str");
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
            auto sIP = builder.saveIP();
            emitBody(fn, lam->body, lam->params, "", rt, nullptr, nullptr, nullptr, nullptr,
                     /*hasEnv=*/true, &lam->captures, &capTypes);
            currentFn = sFn; currentClass = sCls; currentRetType = sRet;
            currentEnsures = sEns; currentInvariants = sInv; currentThis = sThis;
            locals = sLoc; scopeObjects = sScope; deferred = sDef;
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
            return builder.CreateLoad(llvmType(it->second.type), it->second.storage, id->name);
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
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
            return builder.CreateLoad(llvmType(typeName(*mem)), fieldPtr, mem->member);
        }
        if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
            if (un->op == "&") return emitObjectPtr(*un->operand);  // address-of: the object pointer
            llvm::Value* v = emitExpr(*un->operand);
            if (v == nullptr) return nullptr;
            if (un->op == "-") return builder.CreateNeg(v);
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
            emitScopeCleanup();           // run destructors/defers before propagating
            builder.CreateRet(val);       // forward the Err/None as the method's Result/Option
            builder.SetInsertPoint(okBB);
            const std::string vt = cit->second.fieldType.at("value");
            llvm::Value* vp = builder.CreateStructGEP(cit->second.type, val,
                                                      cit->second.fieldIndex.at("value"), "try.vp");
            return builder.CreateLoad(llvmType(vt), vp, "try.value");
        }
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
            return emitRegionAllocate(ri->size.get());
        }
        if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
            return emitCast(emitExpr(*cst->operand), typeName(*cst->operand), cst->targetType);
        }
        if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
            return emitNewArray(*na);
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
            llvm::Value* elemPtr = emitLValue(*ix);
            if (elemPtr == nullptr) return nullptr;
            return builder.CreateLoad(builder.getInt32Ty(), elemPtr, "elem");
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
                llvm::Value* arg = emitExpr(*bin.rhs);
                if (recv == nullptr || arg == nullptr) return nullptr;
                if (fnit->second->arg_size() >= 2) {
                    arg = coerceToType(arg, fnit->second->getArg(1)->getType());
                }
                return builder.CreateCall(fnit->second, {recv, arg});
            }
        }
        const std::string rt = typeName(*bin.rhs);
        llvm::Value* l = emitExpr(*bin.lhs);
        llvm::Value* r = emitExpr(*bin.rhs);
        if (l == nullptr || r == nullptr) return nullptr;
        const std::string& op = bin.op;
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
        // skipping integer promotion (which would try to cast a pointer to int).
        auto isPtrish = [](const std::string& t) {
            return t == "null" || (!t.empty() && (t.back() == '*' || t.back() == '&'));
        };
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
        if (op == "/") return uns ? builder.CreateUDiv(l, r) : builder.CreateSDiv(l, r);
        if (op == "%") return uns ? builder.CreateURem(l, r) : builder.CreateSRem(l, r);
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
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), it->second.storage, "region");
        llvm::Value* used = builder.CreateLoad(builder.getInt64Ty(), block, "used");
        llvm::Value* dataBase = builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 16, "rgn.data");
        llvm::Value* objPtr = builder.CreateGEP(builder.getInt8Ty(), dataBase, used, "rgn.obj");
        llvm::Value* aligned = builder.CreateAnd(builder.CreateAdd(sizeOf(objType), builder.getInt64(7)),
                                                 builder.getInt64(~static_cast<std::uint64_t>(7)));
        builder.CreateStore(builder.CreateAdd(used, aligned), block);  // bump
        return objPtr;
    }

    // itself.allocate(size): malloc a region block and initialize its header.
    // `size` is a ByteSize (read .bytes) or a raw integer count of bytes.
    // accepts/rejects are compile-time only, so codegen ignores them.
    llvm::Value* emitRegionAllocate(const ast::Expr* sizeExpr) {
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
        llvm::Value* total = builder.CreateAdd(builder.getInt64(16), nbytes);
        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "region");
        builder.CreateStore(builder.getInt64(0), block);  // used = 0
        llvm::Value* capPtr = builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "rgn.cap");
        builder.CreateStore(nbytes, capPtr);  // capacity = nbytes
        return block;
    }

    llvm::Value* emitNew(const ast::NewExpr& nw) {
        const std::string cn = ast::mangleGeneric(nw.className, nw.typeArgs);  // Box<int> -> Box$int
        auto cit = classes.find(cn);
        if (cit == classes.end()) {
            error("unknown class '" + cn + "'", nw.loc);
            return nullptr;
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
        if (cit->second.persistPtrIdx != 0 && !pendingPersistKey.empty()) {
            llvm::Value* slot = builder.CreateStructGEP(cit->second.type, objPtr,
                                                        cit->second.persistPtrIdx, "__persist");
            builder.CreateStore(
                getPersistBlock(pendingPersistKey, cit->second.persistBlock), slot);
            pendingPersistKey.clear();
        }
        auto fnit = functions.find(cn + "." + cn);
        if (fnit != functions.end()) {
            std::vector<llvm::Value*> args;
            args.push_back(objPtr);
            for (const auto& arg : nw.args) {
                llvm::Value* v = emitExpr(*arg);
                if (v == nullptr) return nullptr;
                args.push_back(v);
            }
            emitMaybeInvoke(fnit->second, args);
        }
        return objPtr;
    }

    // A java-style enum constant: materializes `new EnumName(args)` on the heap.
    // Not yet a true singleton -- each reference rebuilds it; identity is a later
    // refinement (would need a global + eager init).
    llvm::Value* emitEnumConstant(const ast::EnumDecl& en, const std::string& constName) {
        auto pos = std::find(en.constants.begin(), en.constants.end(), constName);
        if (pos == en.constants.end()) {
            error("enum '" + en.name + "' has no constant '" + constName + "'", en.loc);
            return nullptr;
        }
        const std::size_t idx = static_cast<std::size_t>(pos - en.constants.begin());
        auto cit = classes.find(en.name);
        if (cit == classes.end()) return nullptr;
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
        return objPtr;
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

    llvm::Value* emitCall(const ast::CallExpr& call) {
        const std::string name = flattenCallee(*call.callee);
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
                for (const auto& a : call.args) {
                    llvm::Value* v = emitExpr(*a);
                    if (v == nullptr) return nullptr;
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
                for (const auto& a : call.args) {
                    llvm::Value* v = emitExpr(*a);
                    if (v == nullptr) return nullptr;
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
        if (name == "System.IO.readInt") {
            llvm::Value* tmp = createEntryAlloca("readtmp", builder.getInt32Ty());
            llvm::Value* fmt = builder.CreateGlobalStringPtr("%d", ".scanfmt");
            builder.CreateCall(scanf(), {fmt, tmp});
            return builder.CreateLoad(builder.getInt32Ty(), tmp, "readInt");
        }
        if (name == "System.IO.printf") {
            if (!call.args.empty()) {
                if (const auto* is =
                        dynamic_cast<const ast::InterpStringExpr*>(call.args.front().get())) {
                    return emitInterp(*is, /*addNewline=*/false);
                }
            }
            std::vector<llvm::Value*> args;
            for (const auto& arg : call.args) {
                llvm::Value* v = emitExpr(*arg);
                if (v == nullptr) return nullptr;
                args.push_back(v);
            }
            return builder.CreateCall(printf(), args);
        }
        // println: printf with a newline appended to the format string. With no
        // args it prints a blank line.
        if (name == "System.IO.println") {
            if (!call.args.empty()) {
                if (const auto* is =
                        dynamic_cast<const ast::InterpStringExpr*>(call.args.front().get())) {
                    return emitInterp(*is, /*addNewline=*/true);
                }
            }
            std::string fmt = "\n";
            if (!call.args.empty()) {
                const auto* lit =
                    dynamic_cast<const ast::StringLiteralExpr*>(call.args.front().get());
                fmt = (lit != nullptr ? resolveEscapes(lit->value) : std::string()) + "\n";
            }
            std::vector<llvm::Value*> args;
            args.push_back(builder.CreateGlobalStringPtr(fmt, ".str"));
            for (std::size_t i = 1; i < call.args.size(); ++i) {
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) return nullptr;
                args.push_back(v);
            }
            return builder.CreateCall(printf(), args);
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
            // array.length(): read the i64 length header and truncate to int.
            if (mem->member == "length" && isArrayType(typeName(*mem->object))) {
                llvm::Value* block = emitExpr(*mem->object);
                if (block == nullptr) return nullptr;
                llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), block, "len");
                return builder.CreateTrunc(len, builder.getInt32Ty());
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
                            builder.CreateStore(builder.getInt32(i),
                                                arrayElemPtr(block, builder.getInt32(i)));
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
                    for (const auto& arg : call.args) {
                        llvm::Value* v = emitExpr(*arg);
                        if (v == nullptr) return nullptr;
                        args.push_back(v);
                    }
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
                        for (const auto& arg : call.args) {
                            llvm::Value* v = emitExpr(*arg);
                            if (v == nullptr) return nullptr;
                            args.push_back(v);
                        }
                        return emitMaybeInvoke(fnit->second, args);
                    }
                }
            }
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
                    std::vector<llvm::Value*> vargs;
                    vargs.push_back(recv);
                    for (const auto& arg : call.args) {
                        llvm::Value* v = emitExpr(*arg);
                        if (v == nullptr) return nullptr;
                        vargs.push_back(v);
                    }
                    return emitMaybeInvoke(methodFnType(mdecl), fnPtr, vargs);
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
            for (const auto& arg : call.args) {
                llvm::Value* v = emitExpr(*arg);
                if (v == nullptr) return nullptr;
                args.push_back(v);
            }
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
            for (const ast::ExprPtr& inv : *currentInvariants) emitContractCheck(*inv, "invariant");
        // Deferred blocks run first, in reverse (LIFO) order.
        for (auto it = deferred.rbegin(); it != deferred.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) break;
            emitBlock(**it);
        }
        for (auto it = scopeObjects.rbegin(); it != scopeObjects.rend(); ++it) {
            auto fnit = functions.find(it->className + ".~" + it->className);
            if (fnit == functions.end()) continue;
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), it->slot);
            builder.CreateCall(fnit->second, {objPtr});
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
        // No clause matched: rethrow the current exception (handled by an outer try, or terminates).
        builder.CreateCall(
            cxxThrowFn(),
            {llvm::ConstantPointerNull::get(ptrTy), llvm::ConstantPointerNull::get(ptrTy)},
            {llvm::OperandBundleDef("funclet", llvm::ArrayRef<llvm::Value*>{cp})});
        builder.CreateUnreachable();
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
            if (const LoopTargets* t = findLoop(br->label)) builder.CreateBr(t->brk);
            return;
        }
        if (const auto* co = dynamic_cast<const ast::ContinueStmt*>(&stmt)) {
            if (const LoopTargets* t = findLoop(co->label)) builder.CreateBr(t->cont);
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
        if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(&stmt)) {  // throw expr; (spec 21.1)
            llvm::Value* obj = emitExpr(*th->value);
            if (obj == nullptr) return;
            ensurePersonality();
            llvm::Value* slot = createEntryAlloca("exc.thrown", builder.getPtrTy());
            builder.CreateStore(obj, slot);  // carrier: the object pointer, thrown as void*
            std::vector<llvm::Value*> args = {slot, ehThrowInfo()};
            // Unwind through any live stack-object destructors and into an enclosing try (if any).
            llvm::BasicBlock* ud = computeUnwindDest();
            if (ud != nullptr) {
                llvm::BasicBlock* cont = llvm::BasicBlock::Create(context, "throw.cont", currentFn);
                builder.CreateInvoke(cxxThrowFn(), cont, ud, args);
                builder.SetInsertPoint(cont);
            } else {
                builder.CreateCall(cxxThrowFn(), args);  // propagates to the caller
            }
            builder.CreateUnreachable();  // _CxxThrowException does not return
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
            builder.CreateStore(initV, slot);
            locals[vd->name] = LocalSlot{slot, declType};
            // RAII: a freshly built `new ... on stack` object with a destructor
            // gets cleaned up when the function returns.
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                auto cit = classes.find(nw->className);
                if (nw->location == "stack" && cit != classes.end() && cit->second.hasDestructor) {
                    scopeObjects.push_back(ScopeObject{slot, nw->className});
                }
            }
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
            llvm::Value* slot = emitLValue(*assign->target);
            if (slot == nullptr) return;
            llvm::Value* v = emitExpr(*assign->value);
            if (v == nullptr) return;
            // Value semantics: assigning a class value makes the target an independent copy.
            if (isClassValue(targetType) && isCopyDiscipline(targetType) &&
                isCopyableLValue(*assign->value)) {
                if (dynamic_cast<const ast::MemberExpr*>(assign->target.get()) != nullptr) {
                    // A class-value field has no backing object until assigned, so deep-copy into a
                    // fresh heap object and store the pointer (it outlives the constructor frame).
                    builder.CreateStore(emitClassCopy(targetType, v, /*heap=*/true), slot);
                } else {
                    // A local already has a backing object (from its declaration); copy into it.
                    llvm::Value* destStruct = builder.CreateLoad(builder.getPtrTy(), slot);
                    builder.CreateCall(memcpyFn(),
                                       {destStruct, v, sizeOf(classes[targetType].type)});
                }
            } else {
                builder.CreateStore(coerce(v, typeName(*assign->value), targetType), slot);
            }
            return;
        }
        if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
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
            if (cit != classes.end() && cit->second.hasDestructor) {
                builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
            }
            builder.CreateCall(freeFn(), {objPtr});
            return;
        }
        if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
            // Free the whole region block. (Per-object destructors on release are
            // a later refinement; the region is a bump allocator.)
            auto it = locals.find(rel->region);
            if (it != locals.end()) {
                llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), it->second.storage);
                builder.CreateCall(freeFn(), {block});
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
            // Dispose it (destructor if any, then free) at the block's end.
            auto it = locals.find(us->varName);
            if (it != locals.end() && builder.GetInsertBlock()->getTerminator() == nullptr) {
                const std::string cn = baseType(it->second.type);
                llvm::Value* objPtr =
                    builder.CreateLoad(builder.getPtrTy(), it->second.storage);
                auto cit = classes.find(cn);
                if (cit != classes.end() && cit->second.hasDestructor) {
                    builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
                }
                builder.CreateCall(freeFn(), {objPtr});
            }
            return;
        }
        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
            emitExpr(*es->expr);
            return;
        }
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
            if (rs->value != nullptr) {
                llvm::Value* v = emitExpr(*rs->value);
                if (v != nullptr && currentRetType->isDoubleTy() && v->getType()->isIntegerTy()) {
                    v = builder.CreateSIToFP(v, currentRetType);  // int -> double return
                }
                emitScopeCleanup();
                if (v != nullptr) builder.CreateRet(v);
                return;
            }
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

    void emitBlock(const ast::Block& block) {
        for (const auto& stmt : block.statements) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) break;
            emitStatement(*stmt);
        }
    }

    void emitIf(const ast::IfStmt& s) {
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
                locals[c.bindings[i].name] = LocalSlot{slot, ftype};
                added.push_back(c.bindings[i].name);
            }
            emitBlock(c.body);
            for (const std::string& n : added) locals.erase(n);  // bindings are case-scoped
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
                locals[c.bindings[i].name] = LocalSlot{slot, ftype};
                added.push_back(c.bindings[i].name);
            }
            llvm::Value* v = c.result ? emitExpr(*c.result) : nullptr;
            if (v != nullptr) v = coerce(v, typeName(*c.result), rtype);  // typeName needs bindings
            for (const std::string& n : added) locals.erase(n);  // bindings are arm-scoped
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
        loopStack.push_back({endBB, condBB, pendingLoopLabel});  // break -> end, continue -> cond
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
        loopStack.push_back({endBB, condBB, pendingLoopLabel});  // break -> end, continue -> cond
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
        loopStack.push_back({endBB, updateBB, pendingLoopLabel});  // break -> end, continue -> update
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
        llvm::Value* elem =
            builder.CreateLoad(builder.getInt32Ty(), arrayElemPtr(block, i), "fe.el");
        builder.CreateStore(elem, vSlot);
        loopStack.push_back({endBB, updateBB, pendingLoopLabel});
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
        const LoopTargets brk = {
            endBB, loopStack.empty() ? endBB : loopStack.back().cont, pendingLoopLabel};
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
                            const std::string ftype = base + (f->type.isArray ? "[]" : "") +
                                                      (f->type.isPointer ? "*" : "") +
                                                      (f->type.isRef ? "&" : "");
                            // Static fields live in a single LLVM global, not in each
                            // instance, so they are excluded from the struct layout.
                            if (f->isStatic) {
                                staticFieldType[cls.name + "." + f->name] = ftype;
                            } else {
                                layout.ownFields.emplace_back(f->name, ftype);
                                if (f->isPersistent) layout.persistOrder.push_back(f->name);
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
                            llvm::FunctionType* ty = llvm::FunctionType::get(
                                llvmType(typeRefName(m->returnType)), ptypes, false);
                            const std::string mangled = cls.name + "." + m->name;
                            functions[mangled] = llvm::Function::Create(
                                ty, llvm::Function::ExternalLinkage, mangled, module);
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
            if (idx == layout.fieldIndex.end()) continue;
            llvm::Value* v = emitExpr(*f->init);
            if (v == nullptr) continue;
            llvm::Value* fp = builder.CreateStructGEP(layout.type, thisPtr, idx->second, f->name);
            builder.CreateStore(v, fp);
        }
    }

    void emitBody(llvm::Function* fn, const ast::Block& body,
                  const std::vector<ast::Param>& params, const std::string& thisClass,
                  llvm::Type* retType, const ast::ClassDecl* ctorOf = nullptr,
                  const std::vector<ast::ExprPtr>* requiresClauses = nullptr,
                  const std::vector<ast::ExprPtr>* ensuresClauses = nullptr,
                  const std::vector<ast::ExprPtr>* invariants = nullptr,
                  bool hasEnv = false, const std::vector<ast::Capture>* caps = nullptr,
                  const std::vector<std::string>* capTypes = nullptr) {
        currentFn = fn;
        currentClass = thisClass;
        currentRetType = retType;
        currentEnsures = ensuresClauses;
        currentInvariants = invariants;
        currentThis = nullptr;
        locals.clear();
        scopeObjects.clear();
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
        }

        // Contracts: preconditions run after the prologue, before the body (spec 29).
        if (requiresClauses != nullptr)
            for (const ast::ExprPtr& r : *requiresClauses) emitContractCheck(*r, "requires");

        emitBlock(body);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) {
            emitScopeCleanup();
            if (retType->isVoidTy()) {
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

    void emitFunctions() {
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    bool hasCtor = false;
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            if (m == entry.method) {
                                emitBody(functions["@entry"], m->body, {}, "",
                                         builder.getInt32Ty());
                            } else if (!m->isAbstract) {
                                emitBody(functions[cls.name + "." + m->name], m->body, m->params,
                                         m->isStatic ? std::string() : cls.name,
                                         llvmType(typeRefName(m->returnType)), nullptr,
                                         &m->requiresClauses, &m->ensuresClauses,
                                         m->isStatic ? nullptr : &cls.invariants);
                            }
                        } else if (const auto* c =
                                       dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            hasCtor = true;
                            emitBody(functions[cls.name + "." + cls.name], c->body, c->params,
                                     cls.name, builder.getVoidTy(), &cls,
                                     &c->requiresClauses, &c->ensuresClauses, &cls.invariants);
                        } else if (const auto* d =
                                       dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                            emitBody(functions[cls.name + ".~" + cls.name], d->body, {}, cls.name,
                                     builder.getVoidTy());
                        }
                    }
                    // Emit the synthesized default constructor (sets the vtable +
                    // field inits). Interfaces get none.
                    if (!hasCtor && !cls.isInterface) {
                        const ast::Block emptyBody;
                        emitBody(functions[cls.name + "." + cls.name], emptyBody, {}, cls.name,
                                 builder.getVoidTy(), &cls);
                    }
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

bool CodeGenerator::generate() {
    if (impl_->entry.method == nullptr) {
        errors_.push_back(CodegenError{"no entry point to generate", {}});
        return false;
    }
    impl_->declareClasses();
    impl_->emitStaticFields();
    impl_->declareFunctions();
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

std::string CodeGenerator::toIR() const {
    std::string out;
    llvm::raw_string_ostream os(out);
    impl_->module.print(os, nullptr);
    return out;
}

}  // namespace ldp3
