#include "llvm/IR/MDBuilder.h"
#include "codegen/codegen.h"

#include <llvm/ADT/ScopeExit.h>
#include <llvm/BinaryFormat/Dwarf.h>
#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DIBuilder.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/DerivedTypes.h>
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
#include <cctype>
#include <cstddef>
#include <cstdint>
#include <set>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "parser/ast.h"
#include "parser/monomorphize.h"  // cloneExprDeep, to reroute an unqualified self-call through the member path
#include "semantic/comptime.h"

namespace ldp3 {

namespace {

// The module's target triple as a string. LLVM 21 changed Module::get/setTargetTriple to traffic in a
// llvm::Triple object instead of a std::string; older LLVM (the Windows build targets 17/18) uses strings.
// This keeps the call sites version-agnostic.
std::string moduleTripleStr(const llvm::Module& m) {
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

// ---- Free-variable collection for lambda auto-capture ----
// Walk a lambda body and gather every identifier it references (as a value or a call target),
// descending into nested lambdas so that a variable used only by an inner lambda is still captured
// at each enclosing level (capture chaining). Leaf nodes (literals, break/continue/labels) contribute
// nothing; a node type not handled here simply isn't traversed (its identifiers go uncaptured -- a safe
// degradation, never a crash). The caller intersects this set with the enclosing locals, so type names,
// static receivers, and the lambda's own params are filtered out there.
void collectRefs(const ast::Expr* e, std::set<std::string>& out);
void collectRefs(const ast::Stmt* s, std::set<std::string>& out);
void collectRefs(const ast::Block& b, std::set<std::string>& out) {
    for (const auto& st : b.statements) collectRefs(st.get(), out);
}

void collectRefs(const ast::Expr* e, std::set<std::string>& out) {
    if (!e) return;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) { out.insert(id->name); return; }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) { collectRefs(m->object.get(), out); return; }
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        collectRefs(c->callee.get(), out);
        for (const auto& a : c->args) collectRefs(a.get(), out);
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) { collectRefs(b->lhs.get(), out); collectRefs(b->rhs.get(), out); return; }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) { collectRefs(u->operand.get(), out); return; }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) { collectRefs(t->cond.get(), out); collectRefs(t->thenExpr.get(), out); collectRefs(t->elseExpr.get(), out); return; }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(e)) { collectRefs(nc->lhs.get(), out); collectRefs(nc->rhs.get(), out); return; }
    if (const auto* idx = dynamic_cast<const ast::IndexExpr*>(e)) { collectRefs(idx->array.get(), out); collectRefs(idx->index.get(), out); return; }
    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(e)) { for (const auto& a : nw->args) collectRefs(a.get(), out); return; }
    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(e)) { collectRefs(na->size.get(), out); return; }
    if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(e)) { for (const auto& x : al->elements) collectRefs(x.get(), out); return; }
    if (const auto* tp = dynamic_cast<const ast::TupleExpr*>(e)) { for (const auto& x : tp->elements) collectRefs(x.get(), out); return; }
    if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(e)) { for (const auto& x : is->exprs) collectRefs(x.get(), out); return; }
    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(e)) { collectRefs(cst->operand.get(), out); return; }
    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(e)) { collectRefs(aw->operand.get(), out); return; }
    if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(e)) { collectRefs(mv->operand.get(), out); return; }
    if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(e)) { collectRefs(ex->target.get(), out); return; }
    if (const auto* tr = dynamic_cast<const ast::TryExpr*>(e)) { collectRefs(tr->operand.get(), out); return; }
    if (const auto* od = dynamic_cast<const ast::OldExpr*>(e)) { collectRefs(od->inner.get(), out); return; }
    if (const auto* rg = dynamic_cast<const ast::RangeExpr*>(e)) { collectRefs(rg->start.get(), out); collectRefs(rg->end.get(), out); collectRefs(rg->step.get(), out); return; }
    if (const auto* mr = dynamic_cast<const ast::MethodRefExpr*>(e)) { collectRefs(mr->object.get(), out); return; }
    if (const auto* lm = dynamic_cast<const ast::LambdaExpr*>(e)) { collectRefs(lm->body, out); return; }  // descend for capture chaining
    if (const auto* mx = dynamic_cast<const ast::MatchExpr*>(e)) {
        collectRefs(mx->subject.get(), out);
        for (const auto& cs : mx->cases) { collectRefs(cs.result.get(), out); collectRefs(cs.body, out); }
        collectRefs(mx->defaultResult.get(), out);
        if (mx->defaultBody) collectRefs(*mx->defaultBody, out);
        return;
    }
    // literals and other leaf expressions contribute no identifiers
}

void collectRefs(const ast::Stmt* s, std::set<std::string>& out) {
    if (!s) return;
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) { collectRefs(es->expr.get(), out); return; }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) { collectRefs(rs->value.get(), out); return; }
    if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(s)) { collectRefs(ys->value.get(), out); return; }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) { collectRefs(vd->init.get(), out); return; }
    if (const auto* td = dynamic_cast<const ast::TupleDeclStmt*>(s)) { collectRefs(td->init.get(), out); return; }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) { collectRefs(as->target.get(), out); collectRefs(as->value.get(), out); return; }
    if (const auto* ic = dynamic_cast<const ast::IncDecStmt*>(s)) { collectRefs(ic->target.get(), out); return; }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) { collectRefs(ifs->cond.get(), out); collectRefs(ifs->thenBlock, out); if (ifs->elseBlock) collectRefs(*ifs->elseBlock, out); return; }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) { collectRefs(ws->cond.get(), out); collectRefs(ws->body, out); return; }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(s)) { collectRefs(dw->body, out); collectRefs(dw->cond.get(), out); return; }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) { collectRefs(fs->init.get(), out); collectRefs(fs->cond.get(), out); collectRefs(fs->update.get(), out); collectRefs(fs->body, out); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) { collectRefs(fe->iterable.get(), out); collectRefs(fe->body, out); return; }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(s)) { collectRefs(df->within.get(), out); collectRefs(df->body, out); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(s)) { collectRefs(us->decl.get(), out); collectRefs(us->body, out); return; }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) { collectRefs(sy->mutex.get(), out); collectRefs(sy->body, out); return; }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) { collectRefs(ms->subject.get(), out); for (const auto& cs : ms->cases) { collectRefs(cs.result.get(), out); collectRefs(cs.body, out); } if (ms->defaultBody) collectRefs(*ms->defaultBody, out); return; }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) { collectRefs(sw->subject.get(), out); for (const auto& cs : sw->cases) { collectRefs(cs.value.get(), out); collectRefs(cs.body, out); } if (sw->defaultBody) collectRefs(*sw->defaultBody, out); return; }
    if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(s)) { collectRefs(th->value.get(), out); return; }
    if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) { collectRefs(ts->body, out); for (const auto& c : ts->catches) collectRefs(c.body, out); if (ts->finallyBlock) collectRefs(*ts->finallyBlock, out); return; }
    if (const auto* ls = dynamic_cast<const ast::LabeledStmt*>(s)) { collectRefs(ls->stmt.get(), out); return; }
    if (const auto* dl = dynamic_cast<const ast::DeleteStmt*>(s)) { collectRefs(dl->target.get(), out); for (const auto& mt : dl->moreTargets) collectRefs(mt.get(), out); return; }
    // leaf statements (break/continue/goto/label/asm/...) contribute no identifiers
}

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
// The number of fractional digits the Decimal primitive keeps: its value is the integer mantissa
// times 10^-DECIMAL_SCALE (spec 34). 10^18 fits the fraction in an i64, easing formatting.
constexpr int DECIMAL_SCALE = 18;
// Scales a decimal lexeme (e.g. "1.50") to its integer mantissa as a base-10 digit string
// ("1500000000000000000"), padding or truncating the fraction to DECIMAL_SCALE digits.
std::string decimalScaledString(const std::string& text) {
    std::string s;
    for (char c : text) {
        if (c != '_') s += c;
    }
    bool neg = false;
    std::size_t i = 0;
    if (!s.empty() && (s[0] == '-' || s[0] == '+')) {
        neg = (s[0] == '-');
        i = 1;
    }
    std::string intPart, fracPart;
    bool inFrac = false;
    for (; i < s.size(); ++i) {
        if (s[i] == '.') {
            inFrac = true;
        } else {
            (inFrac ? fracPart : intPart) += s[i];
        }
    }
    if (intPart.empty()) intPart = "0";
    if (fracPart.size() > static_cast<std::size_t>(DECIMAL_SCALE))
        fracPart = fracPart.substr(0, DECIMAL_SCALE);
    while (fracPart.size() < static_cast<std::size_t>(DECIMAL_SCALE)) fracPart += '0';
    return (neg ? "-" : "") + intPart + fracPart;
}
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
// The explicit overflow-mode integer methods (spec 3.6): wrapping/unchecked wrap, saturating clamps.
bool isIntOverflowMethod(const std::string& m) {
    return m == "wrappingAdd" || m == "wrappingSub" || m == "wrappingMul" || m == "wrappingDiv" ||
           m == "saturatingAdd" || m == "saturatingSub" || m == "saturatingMul" ||
           m == "uncheckedAdd" || m == "uncheckedSub" || m == "uncheckedMul" || m == "uncheckedDiv";
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
    if (t == "mat4") return 64;  // <16 x float>
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

// A *value* Result<T,E> / Option<T> (spec 21, value form): the tagged-union representation used when the
// type is written WITHOUT a `*` -- the `*` form stays the boxed heap class. By codegen time the type is
// monomorphized ("Result$int$int"). A trailing `*` is the boxed form; a pointer/ref TYPE ARG (Option<Node*>
// -> "Option$Node*") also embeds a `*` and, worse, collides in the mangled string with the boxed
// `Option<Node>*` -- so slice 1 keeps ANY variant whose mangling contains a pointer/ref/nullable marker
// boxed, and only packs pointer-free payloads (int/float/String/class-by-name) into the shared
// { i32 tag, i64 payload } struct. A value variant of an explicit-pointer payload needs an unambiguous
// mangling and is deferred.
bool isValueVariant(const std::string& t) {
    if (t.rfind("Result$", 0) != 0 && t.rfind("Option$", 0) != 0) return false;
    // Slice 1/2 pack the payload into a 64-bit slot, so keep boxed anything that does not fit: pointer/ref
    // payloads (also mangling-ambiguous), Decimal (i128), and tuple payloads (an aggregate). A proper
    // per-instance sized payload (sret) for these is deferred.
    return t.find('*') == std::string::npos && t.find('&') == std::string::npos &&
           t.find('?') == std::string::npos && t.find("Decimal") == std::string::npos &&
           t.find('(') == std::string::npos;
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
           (t.isPointer ? "*" : "") + (t.isRef ? "&" : "") + (t.isNullable ? "?" : "");
}

// Layout of a class: its LLVM struct, field indices/types, and method returns.
// Polymorphic classes (in a hierarchy) carry a vtable pointer at field 0.
struct ClassLayout {
    const ast::ClassDecl* decl = nullptr;  // source declaration (members in order)
    llvm::StructType* type = nullptr;
    std::unordered_map<std::string, unsigned> fieldIndex;  // includes inherited fields
    std::unordered_map<std::string, std::string> fieldType;  // LDP3 type name per field
    std::unordered_map<std::string, int> bitFieldWidth;  // field -> bit-field width (spec 11.1)
    std::unordered_map<std::string, std::string> propertySetters;  // field -> setter method (spec 8.4)
    std::unordered_set<std::string> volatileFields;  // fields whose accesses are volatile (spec 37.5)
    std::unordered_set<std::string> externalFields;  // `external` fields: associations, not owned (spec 37.1)
    std::unordered_set<std::string> uniqueFields;  // `unique T*` fields: single-owner, so cascade-safe forest edges
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
    bool imported = false;  // from a depended-on .ldb: allocate/destroy via the bundle's exported
                            // Class.__new / Class.__delete (the layout here is the public API only)
    bool dynamic = false;   // imported via --use-dynamic: its functions are runtime-resolved thunks
    std::string bundleName; // owning bundle (for dynamic classes: which .ldb to load)
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
    bool libraryMode = false;  // compiling a bundle to a .ldb: no entry point / `main` wrapper
    bool testMode = false;     // `ldp3c --test`: the entry is a synthetic [Test] runner
    std::vector<std::pair<std::string, std::string>> testMethods;  // {symbol "Class.method", display name}
    std::set<std::string> voidTests_;  // spec 32.11: tests that return void and report via Test.assert*
    std::vector<CodegenError>& errors;
    llvm::LLVMContext context;
    llvm::Module module;
    llvm::IRBuilder<> builder;

    // --- debug info (-g): DWARF metadata so the compiled program is debuggable by lldb / the Forge
    // debugger. dib is null unless -g is set. diCU is the compile unit; diFiles caches a DIFile per source
    // path; diCurrentSP is the DISubprogram of the function being emitted (the scope for line locations).
    bool debugInfo = false;
    std::unique_ptr<llvm::DIBuilder> dib;
    llvm::DICompileUnit* diCU = nullptr;
    std::unordered_map<std::string, llvm::DIFile*> diFiles;
    llvm::DISubprogram* diCurrentSP = nullptr;
    llvm::DIType* diIntTy = nullptr;   // a cached generic type for a minimal DISubroutineType

    // The DIFile for a source path (cached). Splits into directory + filename as DWARF expects.
    llvm::DIFile* diFileFor(std::string_view path) {
        std::string p(path);
        if (p.empty()) p = module.getName().str();
        auto it = diFiles.find(p);
        if (it != diFiles.end()) return it->second;
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

    // Set up the DIBuilder, compile unit and module flags. Called once at the start of generate() when -g
    // is on, before any function is emitted.
    void initDebugInfo() {
        dib = std::make_unique<llvm::DIBuilder>(module);
        llvm::DIFile* mainFile = diFileFor(module.getName());
        diCU = dib->createCompileUnit(llvm::dwarf::DW_LANG_C, mainFile, "ldp3c",
                                      /*isOptimized=*/false, /*flags=*/"", /*runtimeVersion=*/0);
        diIntTy = dib->createBasicType("int", 32, llvm::dwarf::DW_ATE_signed);
        module.addModuleFlag(llvm::Module::Warning, "Debug Info Version",
                             llvm::DEBUG_METADATA_VERSION);
        module.addModuleFlag(llvm::Module::Warning, "Dwarf Version", 4);
    }
    void finalizeDebugInfo() {
        if (dib) dib->finalize();
    }
    // A minimal DISubroutineType (return + no typed params). Enough for line-level breakpoints and stepping;
    // richer parameter types come with variable inspection.
    llvm::DISubroutineType* diMinimalFnType(llvm::DIFile* file) {
        llvm::SmallVector<llvm::Metadata*, 1> elts{diIntTy};
        return dib->createSubroutineType(dib->getOrCreateTypeArray(elts));
    }
    // Create and attach a DISubprogram for `fn`, using `loc` for its file/line, and make it the current
    // debug scope. Returns the subprogram (or null when -g is off).
    llvm::DISubprogram* beginDebugFunction(llvm::Function* fn, SourceLocation loc) {
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
    // Set the current debug location to (loc.line, loc.col) within the current function's scope. A no-op
    // when -g is off or there is no active subprogram.
    void setDebugLoc(SourceLocation loc) {
        if (!debugInfo || diCurrentSP == nullptr) return;
        unsigned line = loc.line > 0 ? static_cast<unsigned>(loc.line) : diCurrentSP->getLine();
        unsigned col = loc.col > 0 ? static_cast<unsigned>(loc.col) : 1;
        builder.SetCurrentDebugLocation(llvm::DILocation::get(context, line, col, diCurrentSP));
    }

    // --- Local/parameter variable debug info (llvm.dbg.declare) ---
    std::unordered_map<std::string, llvm::DIType*> diTypeCache;
    llvm::DIType* diPtrTy_ = nullptr;
    llvm::DIType* diCachedBasic(const std::string& name, unsigned bits, unsigned enc) {
        std::string key = name + ':' + std::to_string(bits) + ':' + std::to_string(enc);
        auto it = diTypeCache.find(key);
        if (it != diTypeCache.end()) return it->second;
        llvm::DIType* t = dib->createBasicType(name, bits, enc);
        diTypeCache[key] = t;
        return t;
    }
    llvm::DIType* diPtrTy() {
        if (diPtrTy_ == nullptr)
            diPtrTy_ = dib->createBasicType("ptr", 64, llvm::dwarf::DW_ATE_address);
        return diPtrTy_;
    }
    // The DIType for a variable. The bit-width/encoding follow the *actual* LLVM storage type so the
    // debugger reads the right number of bytes; the LDP3 type name (int, char, MyClass...) supplies a
    // readable label. Pointers/objects/arrays show as an address.
    llvm::DIType* diTypeFor(const std::string& tyName, llvm::Type* storage) {
        if (storage == nullptr) return diIntTy;
        if (storage->isPointerTy()) return diPtrTy();
        if (storage->isFloatTy())
            return diCachedBasic(tyName.empty() ? "smallfloat" : tyName, 32, llvm::dwarf::DW_ATE_float);
        if (storage->isDoubleTy())
            return diCachedBasic(tyName.empty() ? "float" : tyName, 64, llvm::dwarf::DW_ATE_float);
        if (auto* it = llvm::dyn_cast<llvm::IntegerType>(storage)) {
            unsigned bits = it->getBitWidth();
            if (bits == 1) return diCachedBasic("boolean", 8, llvm::dwarf::DW_ATE_boolean);
            bool uns = tyName.rfind("uint", 0) == 0 || tyName.rfind("ubyte", 0) == 0 ||
                       tyName.rfind("ushort", 0) == 0 || tyName.rfind("ulong", 0) == 0;
            unsigned enc = uns ? llvm::dwarf::DW_ATE_unsigned : llvm::dwarf::DW_ATE_signed;
            std::string nm = tyName.empty() ? ("int" + std::to_string(bits)) : tyName;
            return diCachedBasic(nm, bits, enc);
        }
        return diPtrTy();  // structs/arrays by value: at least surface the address
    }
    // Attach a DILocalVariable + llvm.dbg.declare to a stack slot so the debugger can name and read it.
    // argNo > 0 marks a function parameter (1-based); 0 is an ordinary local. No-op unless -g is on and the
    // slot is a plain alloca in the current function.
    void declareLocalDebug(llvm::Value* slot, const std::string& name, const std::string& tyName,
                           SourceLocation loc, unsigned argNo = 0) {
        if (!debugInfo || diCurrentSP == nullptr || dib == nullptr || name.empty()) return;
        auto* alloca = llvm::dyn_cast<llvm::AllocaInst>(slot);
        if (alloca == nullptr) return;  // dbg.declare needs a stack address
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
    // spec 32.8: classes whose dispatch table is patched at runtime (from the analyzer). They always get
    // a vtable, are never devirtualized, and their vtable global is writable.
    std::set<std::string> patchedClasses_;
    int patchCounter_ = 0;
    std::vector<std::string> seededSlots;              // slot layout adopted from imported bundles
    std::unordered_set<std::string> subclassed_;       // classes/interfaces that something extends or
                                                       // implements; a type NOT here has no subtype, so
                                                       // a call on it devirtualizes to a direct call
    // Dynamic bundles (--use-dynamic), keyed by AST bundle name: the .ldb path and the ABI
    // fingerprint the program compiled against. Their functions become runtime-resolving thunks.
    std::unordered_map<std::string, std::pair<std::string, std::array<std::uint8_t, 32>>> dynamicBundles;
    std::unordered_map<std::string, llvm::GlobalVariable*> dynBundleHandle;  // per-bundle cached handle
    std::unordered_set<std::string> preludeClasses;  // classes from the embedded prelude (weak in .ldb)
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
    std::unordered_map<std::string, llvm::GlobalVariable*> staticGlobals;  // "Class.field" -> global
    std::unordered_map<std::string, std::string> staticFieldType;  // "Class.field" -> LDP3 type
    // class -> its persistent instance field names (spec 18: object reattach via per-variable globals)
    std::unordered_map<std::string, std::unordered_set<std::string>> persistentInstanceFields;
    // set by a var-decl just before emitNew so the new object can wire up its persistent block
    std::string pendingPersistKey;
    // set for `arr[i] = new T()` (spec 18.5): the runtime index that, with pendingPersistKey (the array
    // identity), keys the object's persistent block so it reattaches by slot across a delete
    llvm::Value* pendingPersistIndex = nullptr;
    int lambdaCounter = 0;  // unique names for lowered lambda functions
    std::unordered_map<std::string, std::string> literalReturnType;  // mangled suffix (name$param) -> return type
    std::unordered_map<std::string, std::vector<std::string>> literalSuffixParams;  // suffix name -> param types
    std::unordered_map<std::string, std::string> externReturnType;   // extern C fn -> return type
    // Methods that return a value struct by value use an sret parameter: the caller passes the result
    // slot as the trailing argument and the callee constructs into it (no dangling/leaking copy).
    std::unordered_set<llvm::Function*> sretFns_;
    std::unordered_map<llvm::Function*, llvm::Type*> sretStructType_;  // fn -> its result struct type
    llvm::Value* currentSretSlot_ = nullptr;  // the active function's sret slot (null if not sret)
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
    // __ldp3_malloc'd, previously never freed. Scheme: every STORE of a String deep-copies it, so nothing
    // live is aliased; then every OWNED temporary (a fresh malloc from concat/substring/interp/toString/...)
    // is freed at its statement boundary and String LOCALS at scope exit, and a returned String is copied
    // out. stringTemps: owned temporaries + creating block (only ones in the current block are freed at the
    // boundary; a conditional-arm temp is dropped). scopeStrings: String local SLOTS, freed at scope exit.
    std::vector<std::pair<llvm::Value*, llvm::BasicBlock*>> stringTemps;
    std::vector<llvm::Value*> scopeStrings;
    bool checkedArith_ = false;
    // spec 36.4: `[[no_bounds_check]]` on a method -- its array indexing drops the runtime bounds check.
    // An EXPLICIT, named opt-out for a hot path: LDP3 has no implicit UB, but it does hand you the cannon.
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
    struct BlockScope { const ast::Block* block; std::size_t so, df, rg, st; };
    std::vector<BlockScope> blockScopes;
    std::unordered_map<std::string, const ast::Block*> labelBlock_;
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
    std::unordered_map<std::string, llvm::GlobalVariable*> aliveFlags;  // class -> i32 alive flag (1=alive)
    llvm::GlobalVariable* fnTableGlobal = nullptr;  // all function addresses (for physical unload)
    long long fnTableCount = 0;
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

    // The shared LLVM type of a *value* Result/Option (spec 21, value form): { i32 tag, i64 payload }.
    // tag 0 = Ok/Some, 1 = Err/None. Slice 1 packs any scalar/pointer/float payload (<= 64 bits) into the
    // i64 slot; larger value-struct payloads (sret) come in slice 2. One struct type serves every instance.
    llvm::StructType* variantStructTy_ = nullptr;
    llvm::StructType* variantStructType() {
        if (variantStructTy_ == nullptr)
            variantStructTy_ = llvm::StructType::create(
                context, {builder.getInt32Ty(), builder.getInt64Ty()}, "__ldp3_variant");
        return variantStructTy_;
    }
    // Pack a scalar/pointer/float payload into the i64 slot (zero-extended / bitcast); None passes null.
    llvm::Value* variantEncode(llvm::Value* v) {
        if (v == nullptr) return builder.getInt64(0);
        llvm::Type* ty = v->getType();
        if (ty->isPointerTy()) return builder.CreatePtrToInt(v, builder.getInt64Ty(), "var.enc.p");
        if (ty->isFloatingPointTy()) {
            llvm::Value* bits = builder.CreateBitCast(
                v, builder.getIntNTy(ty->getPrimitiveSizeInBits()), "var.enc.fb");
            return builder.CreateZExt(bits, builder.getInt64Ty(), "var.enc.f");
        }
        return builder.CreateZExtOrTrunc(v, builder.getInt64Ty(), "var.enc.i");
    }
    // Reverse of variantEncode: recover the payload as `ty` (truncate / bitcast / inttoptr).
    llvm::Value* variantDecode(llvm::Value* payload, llvm::Type* ty) {
        if (ty->isPointerTy()) return builder.CreateIntToPtr(payload, ty, "var.dec.p");
        if (ty->isFloatingPointTy()) {
            llvm::Value* bits = builder.CreateTrunc(
                payload, builder.getIntNTy(ty->getPrimitiveSizeInBits()), "var.dec.fb");
            return builder.CreateBitCast(bits, ty, "var.dec.f");
        }
        return builder.CreateZExtOrTrunc(payload, ty, "var.dec.i");
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
        // `nullable T` (spec 3.7): a nullable REFERENCE (class/String/array) already lowers to a
        // pointer, so the marker is a no-op there. A nullable PRIMITIVE has no in-band null, so it is
        // boxed as a null-capable pointer to a heap cell (null = the null pointer).
        if (!t.empty() && t.back() == '?') {
            const std::string inner = t.substr(0, t.size() - 1);
            if (isBoxablePrimitive(inner)) return builder.getPtrTy();
            return llvmType(inner);
        }
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
        if (t == "mat4") return llvm::FixedVectorType::get(builder.getFloatTy(), 16);  // SIMD 4x4 matrix
        if (isArrayType(t) || isRefType(t)) return builder.getPtrTy();
        if (t == "region") return builder.getPtrTy();  // pointer to the region block
        if (t == "checkpoint") return builder.getInt64Ty();  // spec 17 stack flavor: an opaque cursor value
        if (t.rfind("function<", 0) == 0) return builder.getPtrTy();  // a function value (pointer)
        if (t.rfind("funcptr<", 0) == 0) return builder.getPtrTy();   // a bare C function pointer
        if (t == "String" || t == "string") return builder.getPtrTy();  // ptr to {i64 len, ptr data}
        if (t == "Type" || t == "Method" || t == "Field" || t == "Annotation")
            return builder.getPtrTy();  // reflection tokens (spec 31)
        if (t == "Object") return builder.getPtrTy();  // root reference type (spec 3.4)
        if (t == "Decimal") return builder.getInt128Ty();  // fixed-point, scale 10^18 (spec 34)
        if (isValueVariant(t)) return variantStructType();  // value Result/Option: { i32 tag, i64 payload }
        if (classes.count(t) > 0) return builder.getPtrTy();
        if (auto it = newtypes_.find(t); it != newtypes_.end()) return llvmType(it->second);
        // A method-carrying catalog value is tagged (enumTypeId << 32 | ordinal) for multi-implementer
        // dispatch (spec 12.4), so it lowers to i64 rather than a bare i32 ordinal.
        if (isTaggedCatalog(t)) return builder.getInt64Ty();
        return builder.getIntNTy(intBits(t));
    }

    // Adjusts a value to the target type: int->float widening, or integer
    // sign/zero-extend / truncate to the target bit width. Unsigned sources
    // zero-extend and use the unsigned int->float opcode.
    llvm::Value* coerce(llvm::Value* v, const std::string& fromRaw, const std::string& toRaw) {
        if (v == nullptr) return v;
        const std::string from = repType(fromRaw), to = repType(toRaw);  // newtype -> underlying
        // A primitive flowing to Object is boxed (spec 3.4): every value is an Object.
        if (to == "Object" && isBoxablePrimitive(from)) return emitBox(v, from);
        // A mutable `string` owns its struct: copy it on assignment so a later append does not alias
        // the source (value semantics; spec 4). The data pointer is shared until an append replaces it.
        if (to == "string" && (from == "string" || from == "String"))
            return emitStringFromParts(stringLen(v), stringData(v));
        // Boxing a nullable primitive (spec 3.7): a primitive value flowing into `T?` is stored in a
        // heap cell so the pointer can be null. A null literal or an already-boxed nullable passes
        // through as the pointer. (Unboxing happens only via `??` / an explicit null check.)
        if (!to.empty() && to.back() == '?' && isBoxablePrimitive(to.substr(0, to.size() - 1))) {
            if (from == "null" || v->getType()->isPointerTy()) return v;
            const std::string inner = to.substr(0, to.size() - 1);
            llvm::Value* cell = builder.CreateCall(mallocFn(), {builder.getInt64(8)}, "nbox");
            builder.CreateStore(coerce(v, from, inner), cell);
            return cell;
        }
        // Catalog tag (spec 12.4 multi-implementer dispatch): pack an implementing enum's ordinal into a
        // tagged catalog value as (enumTypeId << 32 | ordinal). catalog->catalog is identity; the reverse
        // catalog->int is a plain truncation to the low 32 bits (the ordinal), handled by the integer
        // path below.
        if (isTaggedCatalog(to)) {
            if (isTaggedCatalog(from)) return v;
            if (enums.count(from) > 0 && v->getType()->isIntegerTy()) {
                llvm::Value* ord = builder.CreateZExt(v, builder.getInt64Ty());
                return builder.CreateOr(
                    ord, builder.getInt64(static_cast<std::int64_t>(enumTypeId[from]) << 32));
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
            if (want < have) return builder.CreateTrunc(v, llvmType(to));
        }
        return v;
    }

    // A primitive value type that boxes into an Object: it lowers to an integer or float (a class or
    // pointer lowers to a pointer instead).
    bool isBoxablePrimitive(const std::string& t) {
        if (t == "Decimal") return false;  // 128-bit; the box value field is only 64 bits
        if (isFloatType(t)) return true;
        llvm::Type* lt = llvmType(repType(t));
        return lt != nullptr && lt->isIntegerTy();
    }
    llvm::StructType* boxStructTy() {
        if (boxStructTy_ == nullptr)
            boxStructTy_ = llvm::StructType::create(
                context, {builder.getPtrTy(), builder.getInt64Ty()}, "__box");
        return boxStructTy_;
    }
    // Boxes a primitive into a heap Object: { Object vtable, the value widened to i64 }. The vtable
    // makes it a valid Object (equals/hashCode dispatch); the value round-trips through unboxing.
    llvm::Value* emitBox(llvm::Value* v, const std::string& from) {
        llvm::StructType* bt = boxStructTy();
        llvm::Value* box = builder.CreateCall(mallocFn(), {sizeOf(bt)}, "box");
        llvm::Value* vt = llvm::ConstantPointerNull::get(builder.getPtrTy());
        if (auto it = classes.find("Object"); it != classes.end() && it->second.vtable != nullptr)
            vt = it->second.vtable;
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
    // Unboxes an Object back to a primitive: reads the stored value and converts it to `to`.
    llvm::Value* emitUnbox(llvm::Value* box, const std::string& to) {
        llvm::StructType* bt = boxStructTy();
        llvm::Value* val64 = builder.CreateLoad(
            builder.getInt64Ty(), builder.CreateStructGEP(bt, box, 1), "unbox");
        if (isFloatType(to)) {
            if (isF32(to))
                return builder.CreateBitCast(builder.CreateTrunc(val64, builder.getInt32Ty()),
                                             builder.getFloatTy());
            return builder.CreateBitCast(val64, builder.getDoubleTy());
        }
        const unsigned w = llvmType(to)->getIntegerBitWidth();
        return w < 64 ? builder.CreateTrunc(val64, builder.getIntNTy(w)) : val64;
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
                           {createGlobalStringPtr(builder,msg, ".panic")});
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
        // Unbox: cast<primitive>(Object) reads the boxed value (spec 3.4). Must precede the
        // pointer<->int reinterpret below, which would otherwise treat the box pointer as an address.
        if (from == "Object" && isBoxablePrimitive(to) && v->getType()->isPointerTy())
            return emitUnbox(v, to);
        // Decimal conversions (spec 34): scale by 10^18 on the way in, descale on the way out. The
        // double paths are lossy (double keeps ~15-16 digits); int<->Decimal is exact.
        if (to == "Decimal" && from != "Decimal") {
            if (isFloatType(from)) {
                llvm::Value* d = v->getType()->isDoubleTy()
                                     ? v
                                     : builder.CreateFPExt(v, builder.getDoubleTy());
                llvm::Value* scaled =
                    builder.CreateFMul(d, llvm::ConstantFP::get(builder.getDoubleTy(), 1e18));
                return builder.CreateFPToSI(scaled, builder.getInt128Ty());
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
                emitThrowNamed("ClassCastException");  // terminates this block (throw)
                builder.SetInsertPoint(okBB);
            }
            return v;
        }
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

    // The class-table key for a type name. A generic instance can end in '*' as part of a type
    // argument (e.g. HashMap$int$Node* is HashMap<int,Node*>), so try the exact name first; only if it
    // is not a registered class do we strip an outer pointer/reference marker (Dog* -> Dog).
    std::string clsKey(const std::string& t) const {
        if (classes.count(t) > 0) return t;
        return baseType(t);
    }

    // Masks a value to a member's bit-field width (spec 11.1): only the low N bits
    // are kept, so `f : 4 = 20` stores 4. No-op for a non-bit-field member. (Value
    // masking; physical bit-packing of the struct layout is a later refinement.)
    llvm::Value* maskBitField(llvm::Value* v, const std::string& className,
                              const std::string& field) {
        if (v == nullptr || !v->getType()->isIntegerTy()) return v;
        auto cit = classes.find(clsKey(className));
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
            auto cit = classes.find(clsKey(typeName(*mem->object)));
            return cit != classes.end() && cit->second.volatileFields.count(mem->member) > 0;
        }
        return false;
    }

    // The deferred initializer of lazy field `field` declared in `className` or one of
    // its superclasses (spec 28.4), or null if `field` is not a lazy field.
    const ast::Expr* lazyFieldInitOf(const std::string& className, const std::string& field) {
        for (std::string cur = clsKey(className); !cur.empty();) {
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
    // Release the object's String fields before its block goes away. Copy-on-store gave each field its
    // own buffer that nothing else can reclaim, so without this every class holding a String leaked it
    // on destruction (a TreeMap<String,int> kept climbing even after the map itself freed its nodes).
    // Skipped for unions, whose fields share one storage, and for `external` fields, which are
    // associations the object does not own.
    void freeStringFields(llvm::Value* objPtr, const std::string& cn) {
        auto cit = classes.find(cn);
        if (cit == classes.end()) return;
        const ClassLayout& cl = cit->second;
        if (cl.isUnion || cl.type == nullptr || cl.imported) return;
        for (const auto& [fname, ftype] : cl.fieldType) {
            if (ftype != "String") continue;
            if (cl.externalFields.count(fname) > 0) continue;
            auto idxIt = cl.fieldIndex.find(fname);
            if (idxIt == cl.fieldIndex.end()) continue;
            llvm::Value* slot =
                builder.CreateStructGEP(cl.type, objPtr, idxIt->second, fname + ".sfree");
            builder.CreateCall(strFreeFn(), {builder.CreateLoad(builder.getPtrTy(), slot)});
        }
    }

    void emitDeleteObject(llvm::Value* objPtr, const std::string& cn) {
        // No-UB double-delete guard: a freed pool block's field 0 (the vtable slot) has been overwritten
        // by the free-list link, so the destructor lookup below would call through garbage. Panic first
        // if the block is already freed (live/foreign pointers pass through untouched).
        builder.CreateCall(checkLiveFn(), {objPtr});
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
            freeStringFields(objPtr, cn);
            builder.CreateCall(freeFn(), {objPtr});
            return;
        }
        if (cit != classes.end() && cit->second.hasDestructor)
            builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
        freeStringFields(objPtr, cn);
        builder.CreateCall(freeFn(), {objPtr});
    }

    // A `new T() on heap` value-class rvalue passed as an argument to a by-value copy-discipline parameter
    // is deep-copied by the callee at entry (see emitBody's parameter copy) and never retained, so the
    // caller's fresh heap temporary would leak -- the pervasive `list.add(new T() on heap)` idiom leaked one
    // object per call. This mirrors the String owned-temporary model. Returns the class to destruct after
    // the call (via emitDeleteObject), or "" if the argument is not such an owned temporary. Gated on the
    // parameter being a by-value copy-discipline class, exactly the condition under which the callee copies:
    // a T*/T& or interface/abstract parameter borrows/shares the pointer, so it must NOT be freed here; a
    // movable/unique parameter transfers ownership to the callee, which frees it. A `new ... on stack`
    // argument (an alloca in this frame) is left alone -- freeing it would be a stack free.
    std::string ownedHeapNewArg(const ast::Expr& argExpr, const std::string& paramType) {
        const auto* nw = dynamic_cast<const ast::NewExpr*>(&argExpr);
        if (nw == nullptr || nw->location != "heap" || !nw->region.empty()) return "";
        if (!isClassValue(paramType) || !isCopyDiscipline(paramType)) return "";
        return ast::mangleGeneric(nw->className, nw->typeArgs);
    }

    // spec 32.8: `Dog.methods.replace("bark", <function value>)` -- install a replacement in the class's
    // vtable slot, so every Dog (already alive or not yet born) dispatches to it. Genuine AOP, mocking
    // without a framework, localized hot patching.
    //
    // A function value in LDP3 is a closure pair {code, env} and its code takes the environment as arg 0,
    // while a vtable slot is called as (this, args...). The two are bridged by a thunk emitted per patch
    // site: it has the method's exact signature, reads the closure from a global the patch stores it into,
    // and calls code(env, this, args...). Going through the global (instead of baking the closure in) is
    // what lets the replacement capture, and what lets the same site install a different closure each time
    // it runs. The analyzer already checked the signature, so no dynamic check is needed here.
    llvm::Value* emitMethodPatch(const std::string& cls, const ast::CallExpr& call) {
        const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(call.args[0].get());
        auto cit = classes.find(cls);
        if (lit == nullptr || cit == classes.end()) return nullptr;
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
            if (mty->getReturnType()->isVoidTy()) builder.CreateRetVoid();
            else builder.CreateRet(r);
            builder.restoreIP(sIP);
        }

        // The patch itself: store the closure, then point the vtable slot at the thunk -- in this class
        // and in every subclass that INHERITS the same implementation. A Poodle is a Dog, so replacing
        // Dog.bark must reach the Poodles too; a subclass that overrides bark has its own behaviour and
        // is deliberately left alone.
        llvm::Value* fnVal = emitExpr(*call.args[1]);
        if (fnVal == nullptr) return nullptr;
        builder.CreateStore(fnVal, slotGV);
        for (auto& [cname, cl] : classes) {
            if (cl.vtable == nullptr) continue;                   // abstract/interface/imported: no table
            if (cname != cls && !derivesFrom(cname, cls)) continue;
            if (vtableImpl(cname, mname) != impl) continue;       // it overrides the method: keep its own
            llvm::ArrayType* vtType =
                llvm::ArrayType::get(builder.getPtrTy(), cl.vtslots.size() + 1);
            llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                vtType, cl.vtable, 0, static_cast<unsigned>(sit->second), "vt.slot");
            builder.CreateStore(thunk, slotPtr);
        }
        return nullptr;  // a statement, not a value
    }

    // Is `sub` a (transitive) subclass of `base`?
    bool derivesFrom(const std::string& sub, const std::string& base) {
        for (auto it = classes.find(sub); it != classes.end() && !it->second.superclass.empty();
             it = classes.find(it->second.superclass))
            if (it->second.superclass == base) return true;
        return false;
    }

    // spec 36.4: does this method carry the `[[<name>]]` compiler attribute?
    static bool hasAttribute(const ast::MethodDecl& m, const std::string& name) {
        for (const ast::AnnotationUse& a : m.annotations)
            if (a.name == name) return true;
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
        if (!seen.insert(cn).second) return true;
        std::unordered_set<std::string> shadowed;
        for (std::string cur = cn; !cur.empty();) {
            auto cc = classes.find(cur);
            if (cc == classes.end()) break;
            for (const auto& [fname, ftype] : cc->second.ownFields) {
                if (!shadowed.insert(fname).second) continue;
                if (ftype.find('&') != std::string::npos || isArrayType(ftype)) continue;  // association
                const bool isPtr = ftype.find('*') != std::string::npos;
                if (isPtr && cc->second.externalFields.count(fname) > 0) continue;  // association
                const std::string fcn = baseType(ftype);
                auto fit = classes.find(fcn);
                if (fit == classes.end()) continue;  // not a class field
                if (!params.onlyTypes.empty() &&
                    std::find(params.onlyTypes.begin(), params.onlyTypes.end(), fcn) ==
                        params.onlyTypes.end())
                    continue;
                if (std::find(params.exceptTypes.begin(), params.exceptTypes.end(), fcn) !=
                    params.exceptTypes.end())
                    continue;
                // A followed edge: forest-safe iff embedded value, a unique field, or a unique class.
                if (isPtr && cc->second.uniqueFields.count(fname) == 0 && !fit->second.isUnique)
                    return false;
                if (!cascadeIsForest(fcn, params, seen)) return false;
            }
            cur = cc->second.superclass;
        }
        return true;
    }
    bool cascadeIsForest(const std::string& cn, const ast::CascadeParams& params) {
        std::unordered_set<std::string> seen;
        return cascadeIsForest(cn, params, seen);
    }

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
        // Skip the visited-set entirely when the owned graph is provably a forest (all single-owner edges):
        // it can never dedup, so it is pure overhead. Behaviour is identical -- on a forest the set always
        // reports "fresh" -- only faster (no per-node hash insert, no growing table spilling cache).
        const bool forest = cascadeIsForest(cn, params);
        if (forest) forestCsids_.insert(csid);
        llvm::Value* set = forest ? static_cast<llvm::Value*>(
                                        llvm::ConstantPointerNull::get(builder.getPtrTy()))
                                  : static_cast<llvm::Value*>(builder.CreateCall(ptrsetNewFn(), {}));
        builder.CreateCall(cascadeHelper(op, csid, cn, params),
                           {root, set, builder.getInt32(params.depth)});
        if (!forest) builder.CreateCall(ptrsetFreeFn(), {set});
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
        llvm::Value* dst = emitRegionAlloc(region, cit->second.type, loc);
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
        std::string cn = clsKey(className);  // exact generic instance first, else see through T* / T&
        while (!cn.empty()) {
            auto it = classes.find(cn);
            if (it == classes.end()) break;
            if (it->second.methodReturnType.count(method) > 0) return cn;
            cn = it->second.superclass;
        }
        return "";
    }

    // Fields in layout order: inherited (base-first, in the base's own layout order, so a subclass's
    // object still starts with exactly the base's prefix), then own.
    //
    // Own fields are grouped by affinity (spec 32.9): hot first, then the unmarked ones, then cold --
    // stably, so declaration order is preserved within each group. Packing the hot fields together at
    // the front means a loop that touches only them touches fewer cache lines. Applying this per class
    // (rather than to the flattened list) is what keeps the base prefix intact.
    std::vector<std::pair<std::string, std::string>> collectFields(const std::string& className) {
        std::vector<std::pair<std::string, std::string>> result;
        auto it = classes.find(className);
        if (it == classes.end()) return result;
        if (!it->second.superclass.empty()) result = collectFields(it->second.superclass);
        const ClassLayout& l = it->second;
        if (l.fieldAffinity.empty()) {
            for (const auto& f : l.ownFields) result.push_back(f);
            return result;
        }
        for (const char* group : {"hot", "", "cold"})
            for (const auto& f : l.ownFields) {
                auto a = l.fieldAffinity.find(f.first);
                const std::string aff = a == l.fieldAffinity.end() ? std::string() : a->second;
                if (aff == group) result.push_back(f);
            }
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
        // Every object is-a Object, so Object's universal methods (equals/hashCode/equalsKey/...) resolve
        // on any receiver, including an interface-typed one (which has no superclass chain to Object).
        // Mirrors the analyzer's findMethod fallback so dispatch agrees with type checking.
        if (baseType(className) != "Object") {
            if (auto it = classes.find("Object"); it != classes.end()) {
                auto mit = it->second.ownMethods.find(method);
                if (mit != it->second.ownMethods.end()) return mit->second;
            }
        }
        return nullptr;
    }

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
        if (owner.empty() || fnit == functions.end()) return nullptr;
        return builder.CreateCall(fnit->second, args);
    }

    // The vtable slot for `method`. Slots are global per method name, so this is the
    // same whether the call goes through the class or any interface it implements.
    // The staticType is kept for the signature but no longer affects the index.
    int slotIndex(const std::string& staticType, const std::string& method) {
        (void)staticType;
        auto it = methodSlots.find(method);
        return it == methodSlots.end() ? -1 : it->second;
    }

    // True when `rt` names a value struct (not a pointer): such a return uses the sret convention.
    bool returnsValueStruct(const std::string& rt) {
        if (rt.find('*') != std::string::npos) return false;  // a pointer is not a value struct
        auto it = classes.find(clsKey(rt));
        return it != classes.end() && it->second.isStruct;
    }

    // Signature of an instance method as called through a vtable: (this, params) -> ret. A value
    // struct return becomes a trailing sret pointer with a void return (spec 11 value semantics).
    llvm::FunctionType* methodFnType(const ast::MethodDecl* m) {
        std::vector<llvm::Type*> ptypes;
        ptypes.push_back(builder.getPtrTy());  // this
        for (const auto& p : m->params) ptypes.push_back(llvmType(typeRefName(p.type)));
        const std::string rt = typeRefName(m->returnType);
        if (returnsValueStruct(rt)) {
            ptypes.push_back(builder.getPtrTy());  // sret result slot (trailing)
            return llvm::FunctionType::get(builder.getVoidTy(), ptypes, false);
        }
        return llvm::FunctionType::get(llvmType(rt), ptypes, false);
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
        if (const auto* fl = dynamic_cast<const ast::FloatLiteralExpr*>(&expr))
            return fl->isDecimal ? "Decimal" : "double";
        if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
        if (dynamic_cast<const ast::StringLiteralExpr*>(&expr) != nullptr) return "string";
        if (dynamic_cast<const ast::InterpStringExpr*>(&expr) != nullptr) return "String";  // $"..."
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
            // Unary operator overload (spec 6.5): the operator method's return type.
            if (un->op != "!") {
                const std::string owner =
                    methodOwner(baseType(typeName(*un->operand)), "operator" + un->op);
                if (!owner.empty())
                    if (auto rit = classes.find(owner);
                        rit != classes.end() &&
                        rit->second.methodReturnType.count("operator" + un->op) > 0)
                        return rit->second.methodReturnType.at("operator" + un->op);
            }
            // Negation and bitwise-not keep the operand's numeric type (int/long/float/double); without
            // this, unary '-' was typed as int, so `-x` on a double misled callers (e.g. a ternary arm's
            // result type), producing a double value under an i32 phi -- an IR type mismatch.
            if (un->op == "~" || un->op == "-" || un->op == "+") return typeName(*un->operand);
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
            if (op == "+" && (lt == "String" || lt == "string") && (rt == "String" || rt == "string"))
                return "String";  // string concatenation (spec 4)
            if (lt == "Decimal" && rt == "Decimal" &&
                (op == "+" || op == "-" || op == "*" || op == "/"))
                return "Decimal";  // fixed-point arithmetic (spec 34)
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
        if (dynamic_cast<const ast::RangeExpr*>(&expr)) return "Range";  // first-class range value
        if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
            return na->elementType + "[]";
        }
        if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(&expr)) {  // [a,b,c] (spec 25)
            return (al->elements.empty() ? std::string("int") : typeName(*al->elements[0])) + "[]";
        }
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
            const std::string at = typeName(*ix->array);
            if (vecWidth(at) > 0 || at == "mat4") return "float";  // v[i] / m[i] element read
            const std::string owner = methodOwner(baseType(at), "operator[]");
            if (!owner.empty()) return classes[owner].methodReturnType["operator[]"];
            if (isRefType(at)) return baseType(at);  // p[i] on a raw pointer T* -> T
            return isArrayType(at) ? at.substr(0, at.size() - 2) : std::string("int");
        }
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
            if (int w = vecWidth(flattenCallee(*call->callee)); w > 0)
                return flattenCallee(*call->callee);  // vec2/3/4 construction
            if (const std::string mc = flattenCallee(*call->callee); mc == "mat4" || mc == "mat4.identity")
                return "mat4";  // mat4(...16 floats) construction and the mat4.identity() factory
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                mem != nullptr && typeName(*mem->object) == "mat4") {
                if (mem->member == "multiply") return "mat4";
                if (mem->member == "transform") return "vec4";
            }
            if (flattenCallee(*call->callee) == "reflect.typeOf") return "Type";  // spec 31
            if (flattenCallee(*call->callee) == "System.IO.Console.read") return "String";  // reads a line
            if (const std::string rc = flattenCallee(*call->callee);
                rc == "Memory.readString" || rc == "System.Memory.readString") return "String";  // StringBuilder
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Time.", 0) == 0) {
                if (fc == "Time.millis" || fc == "Time.nanos" || fc == "Time.unixMillis")
                    return "long";  // spec 34
                if (fc == "Time.sleep") return "void";
            }
            if (const std::string fc = flattenCallee(*call->callee); fc == "Bits.doubleToLong")
                return "long";
            if (const std::string fc = flattenCallee(*call->callee); fc == "Bits.longToDouble")
                return "double";
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Ipc.", 0) == 0) {
                if (fc == "Ipc.recv") return "String";  // spec 2.8: one whole frame
                if (fc == "Ipc.close") return "void";
                return "long";  // listen/accept/connect -> handle; send -> bytes written
            }
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Net.", 0) == 0) {
                if (fc == "Net.recv" || fc == "Net.udpRecv" || fc == "Net.udpPeerHost") return "String";  // spec 34
                if (fc == "Net.connect" || fc == "Net.send" || fc == "Net.listen" || fc == "Net.accept" ||
                    fc == "Net.udpOpen" || fc == "Net.udpSend")
                    return "long";
                if (fc == "Net.udpPeerPort") return "int";
                if (fc == "Net.close" || fc == "Net.udpClose") return "void";
            }
            if (flattenCallee(*call->callee) == "Process.run") return "ProcessResult";  // spec 34
            if (const std::string ec = flattenCallee(*call->callee); ec.rfind("Env.", 0) == 0) {
                if (ec == "Env.get") return "String";  // spec 34
                if (ec == "Env.set") return "boolean";
                if (ec == "Env.executablePath") return "String";
            }
            if (const std::string sc = flattenCallee(*call->callee); sc.rfind("Subproc.", 0) == 0) {
                if (sc == "Subproc.spawn" || sc == "Subproc.spawnCombined"
                    || sc == "Subproc.spawnVisible") return "long";
                if (sc == "Subproc.writeStr") return "int";
                if (sc == "Subproc.readChunk") return "String";
                if (sc == "Subproc.isAlive" || sc == "Subproc.canRead") return "boolean";
                if (sc == "Subproc.closeStdin" || sc == "Subproc.kill") return "void";
            }
            if (const std::string pc = flattenCallee(*call->callee); pc.rfind("Conpty.", 0) == 0) {
                if (pc == "Conpty.spawn") return "long";
                if (pc == "Conpty.writeStr") return "int";
                if (pc == "Conpty.readChunk") return "String";
                if (pc == "Conpty.isAlive" || pc == "Conpty.canRead") return "boolean";
                if (pc == "Conpty.resize" || pc == "Conpty.close") return "void";
            }
            if (const std::string fc = flattenCallee(*call->callee); fc.rfind("File.", 0) == 0) {
                if (fc == "File.readAll" || fc == "File.list") return "String";  // spec 34.4
                if (fc == "File.size") return "long";
                if (fc == "File.writeAll" || fc == "File.appendAll" || fc == "File.exists" ||
                    fc == "File.remove" || fc == "File.mkdir" || fc == "File.rename" ||
                    fc == "File.isDir")
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
                    if (mem->member == "toInt") return "int";
                    if (mem->member == "toDouble") return "double";
                }
                if (typeName(*mem->object) == "Decimal" && mem->member == "toString") return "String";
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
                    if (mem->member == "methods") return "ArrayList$Method";
                    if (mem->member == "fields") return "ArrayList$Field";
                    if (mem->member == "annotations") return "ArrayList$Annotation";
                }
                if (typeName(*mem->object) == "Field") {
                    if (mem->member == "name") return "String";
                    if (mem->member == "get") return "Object";  // boxed field value (spec 31)
                }
                if (typeName(*mem->object) == "Annotation" && mem->member == "name") return "String";
                if (typeName(*mem->object) == "Method") {
                    if (mem->member == "name") return "String";
                    if (mem->member == "invoke") return "Object";  // boxed result (spec 31)
                    if (mem->member == "firstByte") return "int";
                    if (mem->member == "annotations") return "ArrayList$Annotation";
                }
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                    if (enums.count(oid->name) > 0) {
                        if (mem->member == "count") return "int";
                        if (mem->member == "values") return oid->name + "[]";
                        if (mem->member == "random") return oid->name;
                        if (mem->member == "parse") return "Option$" + oid->name;
                    }
                }
                // Enum (catalog) instance method: m.pick() -> the method's return type. A
                // catalog-typed receiver resolves to its single implementing enum (spec 12.4).
                std::string enumRecv = baseType(typeName(*mem->object));
                if (enumMethodDecls.find(enumRecv) == enumMethodDecls.end())
                    if (std::string impl = catalogImplementerEnum(enumRecv, mem->member); !impl.empty())
                        enumRecv = impl;
                if (auto eit = enumMethodDecls.find(enumRecv); eit != enumMethodDecls.end()) {
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
                // Qualified literal suffix: Type.kib(64) (spec 17.10).
                if (literalSuffixParams.count(mem->member) > 0 && call->args.size() == 1) {
                    const std::string key = chooseLiteralKey(mem->member, typeName(*call->args[0]));
                    if (auto rit = literalReturnType.find(key); rit != literalReturnType.end())
                        return rit->second;
                }
            }
            // Namespace-level literal suffix function: name(arg), overloaded by argument type.
            const std::string sname = flattenCallee(*call->callee);
            if (literalSuffixParams.count(sname) > 0 && call->args.size() == 1) {
                const std::string key = chooseLiteralKey(sname, typeName(*call->args[0]));
                if (auto rit = literalReturnType.find(key); rit != literalReturnType.end())
                    return rit->second;
            }
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
                if (auto ct = namespaceConstTypes.find(objId->name + "." + mem->member);
                    ct != namespaceConstTypes.end())
                    return ct->second;  // Type.NAME class const
            }
            const std::string ot = clsKey(typeName(*mem->object));
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
        if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr))
            return cst->op == 1 ? std::string("boolean")
                   : cst->op == 2 ? cst->targetType + "?"
                                  : cst->targetType;
        if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr))
            return mv->castType.empty() ? typeName(*mv->operand) : mv->castType;
        if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(&expr))
            return typeName(*ex->target);  // extract yields an owning pointer to the same object type
        if (dynamic_cast<const ast::MarkExpr*>(&expr) != nullptr)
            return "checkpoint";  // spec 17 stack flavor: a cursor value
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
        builder.CreateCall(printf(), {createGlobalStringPtr(builder,msg, ".contract")});
        builder.CreateCall(exitFn(), {builder.getInt32(1)});
        builder.CreateUnreachable();
        builder.SetInsertPoint(contBB);
    }

    llvm::FunctionCallee mallocFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__ldp3_malloc", ty);  // pooled (runtime)
        // libc malloc carries `noalias` on its result; the pool also returns fresh non-aliasing memory,
        // and clang needs the attribute to prove distinct arrays don't alias -- without it, it will not
        // vectorize loops like matmul (c[j] += a_ik * b[j]). Restore the attribute the rename dropped.
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee()))
            f->addRetAttr(llvm::Attribute::NoAlias);
        return c;
    }
    llvm::FunctionCallee reallocFn() {  // realloc(ptr, size) -> ptr (for array resize, spec 25)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__ldp3_realloc", ty);  // pooled (runtime)
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee()))
            f->addRetAttr(llvm::Attribute::NoAlias);
        return c;
    }
    // __ldp3_persist_slot(key, index, size) -> block: the in-process registry for index-keyed
    // persistent reattach (spec 18.5). Returns the surviving block for (key, index) or a fresh zeroed
    // one, so `delete arr[i]; arr[i] = new T()` reattaches by slot within a run.
    llvm::FunctionCallee persistSlotFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(),
            {builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__ldp3_persist_slot", ty);
    }

    llvm::FunctionCallee freeFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_free", ty);  // pooled allocator (runtime)
    }
    llvm::FunctionCallee checkLiveFn() {  // panics on a delete of an already-freed block (runtime)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_check_live", ty);
    }

    // Region backing-memory acquire/release (spec 17). Routes through the runtime's region cache instead
    // of raw malloc/free so a hot `allocate ... release` arena loop reuses the block on this thread rather
    // than round-tripping a multi-megabyte allocation through the OS (mmap/munmap + page zeroing) every
    // iteration -- the dominant cost, since the bump allocation itself is nearly free.
    llvm::FunctionCallee regionAcquireFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__ldp3_region_acquire", ty);
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee()))
            f->addRetAttr(llvm::Attribute::NoAlias);
        return c;
    }
    llvm::FunctionCallee regionReleaseFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_region_release", ty);
    }
    // Flavored-region allocator (spec 17, flavors expansion). init sets up a pool/fixedslot/ring block's
    // descriptor; new pops/bumps a slot; free returns a slot to the region's free-list. Bump/stack never
    // call these -- they keep the inline bump fast path.
    llvm::FunctionCallee regionInitFn() {  // (block, flavor, cap, growable) -> void
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(),
            {builder.getPtrTy(), builder.getInt64Ty(), builder.getInt64Ty(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__ldp3_region_init", ty);
    }
    llvm::FunctionCallee regionFreeChainFn() {  // (block) -> void  (free a growable region's block chain)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_region_free_chain", ty);
    }
    llvm::FunctionCallee regionNewFn() {  // (block, size) -> ptr
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__ldp3_region_new", ty);
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee()))
            f->addRetAttr(llvm::Attribute::NoAlias);
        return c;
    }
    llvm::FunctionCallee regionFreeFn() {  // (block, ptr, size) -> void
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__ldp3_region_free", ty);
    }
    llvm::FunctionCallee regionTrackFn() {  // (block, ptr, dtor) -> void  (stack: record for rollback)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_region_track", ty);
    }
    llvm::FunctionCallee regionRollbackFn() {  // (block, mark) -> void  (stack: destruct + reset cursor)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        return module.getOrInsertFunction("__ldp3_region_rollback", ty);
    }
    llvm::FunctionCallee regionTeardownFn() {  // (block) -> void  (stack: run all dtors + free registry)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_region_teardown", ty);
    }
    llvm::FunctionCallee ringNewFn() {  // (block, size) -> ptr  (circular; evicts oldest when full)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getPtrTy(), {builder.getPtrTy(), builder.getInt64Ty()}, false);
        llvm::FunctionCallee c = module.getOrInsertFunction("__ldp3_ring_new", ty);
        if (auto* f = llvm::dyn_cast<llvm::Function>(c.getCallee()))
            f->addRetAttr(llvm::Attribute::NoAlias);
        return c;
    }
    llvm::FunctionCallee ringSetDtorFn() {  // (block, dtor) -> void  (the ring's single element dtor)
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_ring_set_dtor", ty);
    }
    llvm::FunctionCallee ringTeardownFn() {  // (block) -> void  (destruct live entries before free)
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_ring_teardown", ty);
    }
    // Region flavor classification. bump ("") uses the inline cursor fast path. pool/fixedslot/stack use
    // the runtime Ldp3RegionDesc: pool/fixedslot allocate reclaimable slots from a free-list, stack bumps
    // with mark/rollback. (ring joins usesRuntimeDesc in a later wave.)
    static bool isPoolLikeFlavor(const std::string& f) { return f == "pool" || f == "fixedslot"; }
    static bool isStackFlavor(const std::string& f) { return f == "stack"; }
    static bool isRingFlavor(const std::string& f) { return f == "ring"; }
    // A runtime-desc flavor uses the Ldp3RegionDesc header (not the inline bump cursor): everything but bump.
    static bool usesRuntimeDesc(const std::string& f) {
        return f == "pool" || f == "fixedslot" || f == "stack" || f == "ring";
    }
    // The declared flavor of a region referenced by `name`: a local (regionFlavor_) or a `this.field`
    // region (looked up on the current class's field). "" == bump.
    const ast::FieldDecl* regionFieldDecl(const std::string& name) {
        const auto dot = name.find('.');
        if (dot == std::string::npos || currentClass.empty()) return nullptr;
        auto cit = classes.find(currentClass);
        if (cit == classes.end() || cit->second.decl == nullptr) return nullptr;
        const std::string fname = name.substr(dot + 1);
        for (const ast::MemberPtr& m : cit->second.decl->members)
            if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get()))
                if (fd->name == fname) return fd;
        return nullptr;
    }
    std::string flavorOfRegion(const std::string& name) {
        if (auto it = regionFlavor_.find(name); it != regionFlavor_.end()) return it->second;
        if (const ast::FieldDecl* fd = regionFieldDecl(name)) return fd->regionFlavor;
        return std::string();
    }
    bool growableOfRegion(const std::string& name) {
        if (growableRegions_.count(name) > 0) return true;
        if (const ast::FieldDecl* fd = regionFieldDecl(name)) return fd->regionGrowable;
        return false;
    }
    // The flavored-region data offset -- MUST match LDP3_REGION_HDR in runtime/ldp3_rt.cpp.
    static constexpr unsigned kRegionHdr = 448u;
    // The descriptor flavor code stored at block+24 (matches the runtime's reading).
    static unsigned flavorCode(const std::string& f) {
        if (f == "pool") return 1;
        if (f == "stack") return 2;
        if (f == "fixedslot") return 3;
        if (f == "ring") return 4;
        return 0;  // bump
    }
    // The flavor + growth threaded into emitRegionAllocate for an eager `<flavor> region r =
    // itself.allocate(...)` (the init expr itself does not carry them; the VarDecl does). Set around
    // emitExpr(init).
    std::string pendingRegionFlavor_;
    bool pendingRegionGrowable_ = false;

    // sizeof(type) in bytes, the target-portable way: gep null + 1, then
    // ptrtoint. The backend folds it to a constant using the real data layout.
    llvm::Value* sizeOf(llvm::Type* type) {
        llvm::Value* gep = builder.CreateConstGEP1_64(
            type, llvm::ConstantPointerNull::get(builder.getPtrTy()), 1);
        return builder.CreatePtrToInt(gep, builder.getInt64Ty());
    }

    // A value-type struct passed/returned across FFI by value (spec 26). True unless `t` is a
    // pointer/reference to the struct (those pass as a plain pointer).
    bool isFfiByValueStruct(const std::string& t) {
        if (!t.empty() && (t.back() == '*' || t.back() == '&')) return false;
        auto cit = classes.find(clsKey(t));
        return cit != classes.end() && cit->second.isStruct;
    }
    // FFI ABI (Win64): a by-value struct of 1/2/4/8 bytes travels in a register as an integer of
    // that size. Returns that integer type, or nullptr if `t` is not a register-sized by-value
    // struct (the type then passes as-is, e.g. a pointer).
    llvm::Type* ffiStructRegType(const std::string& t) {
        if (!isFfiByValueStruct(t)) return nullptr;
        auto cit = classes.find(clsKey(t));
        if (cit->second.type == nullptr) return nullptr;
        const uint64_t sz = module.getDataLayout().getTypeAllocSize(cit->second.type);
        switch (sz) {
            case 1: return builder.getInt8Ty();
            case 2: return builder.getInt16Ty();
            case 4: return builder.getInt32Ty();
            case 8: return builder.getInt64Ty();
            default: return nullptr;  // 3/5/6/7/>8: not register-passable here
        }
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
    // Length-aware content equality of two String objects -> i32 (1 equal, 0 not). Correct even when the
    // data buffer is not NUL-terminated (unlike strcmp), and null-safe. Backs String `==`/`!=` (spec 4).
    llvm::FunctionCallee strEqFn() {
        llvm::FunctionType* ty = llvm::FunctionType::get(
            builder.getInt32Ty(), {builder.getPtrTy(), builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_str_eq", ty);
    }
    // Cached FNV-1a hash of a String object (runtime helper reads/fills the object's hash field), for
    // Hashable<String>. Takes the String object pointer so repeated hashing of the same immutable String
    // (the HashMap<String,...> hot path) is a single field read after the first call.
    llvm::FunctionCallee strHashFn() {
        llvm::FunctionType* ty =
            llvm::FunctionType::get(builder.getInt64Ty(), {builder.getPtrTy()}, false);
        return module.getOrInsertFunction("__ldp3_str_hash_obj", ty);
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
        builder.CreateStore(builder.getInt64(0), builder.CreateStructGEP(stringType(), obj, 2));  // hash uncomputed
        return obj;
    }
    // The Decimal scale (10^18) as an i128 constant.
    llvm::Value* decimalScale() {
        return llvm::ConstantInt::get(context,
                                      llvm::APInt(128, "1" + std::string(DECIMAL_SCALE, '0'), 10));
    }
    // Formats a Decimal (i128 mantissa, scale 10^18) as a String: sign, integer part, '.', then the
    // 18 fraction digits (spec 34). The fraction fits an i64, so it prints with %018llu.
    llvm::Value* emitDecimalToString(llvm::Value* v) {
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
            module.getOrInsertFunction("__ldp3_decimal_str", ft),
            {builder.CreateZExt(neg, builder.getInt32Ty()), intPart, frac, buf});
        return ownedStr(emitStringFromParts(len, buf));
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
        // An interface- or abstract-typed value is a reference to a concrete object whose real type
        // (and size) is not statically known -- an interface/abstract class cannot be instantiated
        // directly, so the value is always a subclass instance. Deep-copying it by the base's own
        // (often field-less, minimal) size would truncate the object and read past its allocation on
        // a later virtual call. Interfaces and abstract classes are reference types.
        if (auto it = classes.find(t);
            it != classes.end() && (it->second.isInterface || it->second.isAbstract))
            return false;
        // String is immutable (spec 4), so a copy is observationally identical to sharing the buffer --
        // skip the copy on assignment and parameter passing. (The mutable `string` still copies.)
        if (baseType(t) == "String") return false;
        return !isRefType(t) && !isArrayType(t) && classes.count(t) > 0 && javaEnums.count(t) == 0;
    }

    // Only the default discipline copies; movable/unique transfer the pointer.
    bool isCopyDiscipline(const std::string& t) {
        auto it = classes.find(clsKey(t));
        return it != classes.end() && !it->second.isMovable && !it->second.isUnique;
    }

    // An existing object that a value copy must duplicate (vs. a fresh `new`). Reading an array element
    // (`arr[i]`) yields an existing object too, so it is copyable: without this, `dst[i] = src[i]` (e.g.
    // ArrayList's grow migration `bigger[i] = this.data[i]`) shallow-shared the boxed value-class element
    // between the two arrays -- a value-semantics violation, and a double-free once the source is freed.
    bool isCopyableLValue(const ast::Expr& e) {
        return dynamic_cast<const ast::IdentifierExpr*>(&e) != nullptr ||
               dynamic_cast<const ast::MemberExpr*>(&e) != nullptr ||
               dynamic_cast<const ast::IndexExpr*>(&e) != nullptr;
    }

    // Duplicates an array block [ i64 length | elems... ] into a fresh heap block
    // so a value copy does not share the elements. Elements are 4 bytes in 0.1.
    // Types currently on the deep-copy / free chain, to break self-referential type cycles at codegen
    // time (e.g. Node holding an ArrayList<Node>): a cyclic sub-object is shared rather than recursed
    // into forever. Acyclic types get a full deep copy / free.
    std::unordered_set<std::string> copyChain_;

    llvm::Value* emitArrayDup(llvm::Value* srcBlock, const std::string& elemType) {
        const long stride = arrayElemBytes(elemType);
        llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), srcBlock, "arr.len");
        llvm::Value* total = builder.CreateAdd(
            builder.getInt64(8), builder.CreateMul(len, builder.getInt64(stride)));
        llvm::Value* newBlock = builder.CreateCall(mallocFn(), {total}, "arr.copy");
        builder.CreateCall(memcpyFn(), {newBlock, srcBlock, total});
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
            llvm::Value* off = builder.CreateAdd(builder.getInt64(8), builder.CreateMul(i, builder.getInt64(stride)));
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
        // Break self-referential type cycles: if this class is already being copied up the call chain
        // (a field or array/collection element of its own type, directly or transitively), stop at the
        // shallow copy -- the cyclic sub-object is shared. Without this the codegen recurses on the type
        // forever (stack overflow). Acyclic types fall through to the full deep copy.
        if (!copyChain_.insert(className).second) return dest;
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
            } else if (ftype == "String") {
                // A String field is owned storage like an array is, so the copy needs its own buffer.
                // Sharing it made the two objects' lifetimes depend on each other: whichever died first
                // took the other's text with it (null-safe -- the helper passes null through).
                llvm::Value* srcSlot = builder.CreateStructGEP(st, srcPtr, idx);
                deep = emitStringCopy(builder.CreateLoad(builder.getPtrTy(), srcSlot));
            }
            if (deep != nullptr) builder.CreateStore(deep, builder.CreateStructGEP(st, dest, idx));
        }
        copyChain_.erase(className);
        return dest;
    }

    // Frees the storage a value object owns through its fields -- arrays and heap value sub-objects
    // (recursively) -- WITHOUT freeing the object itself. Used before overwriting an existing object in
    // a value-semantics reassignment (b = a), so the target's old owned copy does not leak. free(null)
    // is a no-op, so array fields need no guard; a value sub-object pointer is null-guarded before the
    // recursion so a not-yet-built field never dereferences null.
    void emitFreeOwnedFields(const std::string& className, llvm::Value* ptr) {
        auto cit = classes.find(className);
        if (cit == classes.end()) return;
        llvm::StructType* st = cit->second.type;
        for (const auto& [fname, ftype] : collectFields(className)) {
            const unsigned idx = cit->second.fieldIndex[fname];
            llvm::Value* slot = builder.CreateStructGEP(st, ptr, idx);
            if (isArrayType(ftype)) {
                builder.CreateCall(freeFn(), {builder.CreateLoad(builder.getPtrTy(), slot)});
            } else if (ftype == "String") {
                // Symmetric with emitClassCopy: the copy owns its String, so the overwrite releases it.
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

    // Array memory layout: one heap block [ i64 length | elem 0 | elem 1 | ... ].
    // The array value is a pointer to the length header (element count); elements
    // start 8 bytes in and are sized by the element type.
    llvm::Value* arrayData(llvm::Value* block) {
        return builder.CreateConstGEP1_64(builder.getInt8Ty(), block, 8, "arr.data");
    }
    // A boolean array element occupies 1 byte (i8), though a boolean *value* stays i32. Every other
    // element stores at its natural width. The byte size (allocation/stride) and the LLVM storage type
    // (load/store) MUST agree or indexing corrupts memory. char stays i32 -- a 32-bit Unicode scalar.
    unsigned arrayElemBytes(const std::string& elemType) {
        return elemType == "boolean" ? 1u : byteSizeOf(elemType);
    }
    llvm::Type* arrayStorageTy(const std::string& elemType) {
        return elemType == "boolean" ? builder.getInt8Ty() : llvmType(elemType);
    }

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
            llvm::Value* len = builder.CreateLoad(builder.getInt64Ty(), block, "arr.len");
            llvm::Value* oob = builder.CreateICmpUGE(idx, len, "arr.oob");
            llvm::Function* f = currentFn;
            auto* badBB = llvm::BasicBlock::Create(context, "idx.bad", f);
            auto* okBB = llvm::BasicBlock::Create(context, "idx.ok", f);
            builder.CreateCondBr(oob, badBB, okBB, coldBranchWeights());
            builder.SetInsertPoint(badBB);
            emitPanic("array index out of bounds");
            builder.SetInsertPoint(okBB);
        }
        return builder.CreateGEP(elemTy, arrayData(block), idx, "arr.elem");
    }

    // String RAII: free every element of a String[] before its backing block is freed. Each element is
    // an owned copy (copy-on-store), so it must be released or it leaks; a null slot (new String[n]()
    // zero-init, or a hole past an ArrayList's size) is skipped by the null-safe __ldp3_str_free. The
    // slot is nulled after freeing, so a re-delete of the same array finds nothing to free again. Loops
    // over the whole capacity (the array's i64 length header) -- copy-on-store keeps every live element
    // a distinct buffer, so no two slots alias and nothing is freed twice.
    void emitFreeOwnedArrayElements(llvm::Value* block, const std::string& elemType) {
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
        if (isStr) builder.CreateCall(strFreeFn(), {elem});
        else emitDeleteObject(elem, clsKey(elemType));
        builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), ep);
        builder.CreateBr(nextBB);
        builder.SetInsertPoint(nextBB);
        builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(endBB);
    }
    bool arrayOwnsElements(const std::string& elemType) {
        if (elemType == "String") return true;
        if (elemType == "string" || isArrayType(elemType)) return false;
        if (elemType.find('*') != std::string::npos) return false;
        return classes.count(clsKey(elemType)) > 0 && arrayStorageTy(elemType)->isPointerTy();
    }

    // Signed +/-/* with a trap on overflow (spec 3.6): the with.overflow intrinsic yields {result, ovf},
    // and a cold branch to a deterministic panic -- like the bounds and division checks, not a catchable
    // exception, so the hot path stays a single straight-line op and no invoke is introduced -- fires only
    // on overflow. LLVM elides the whole check where it can prove the operation cannot overflow (loop
    // counters, small constants). Unsigned arithmetic and freestanding mode never reach here (they wrap).
    llvm::Value* emitCheckedIntArith(const std::string& op, llvm::Value* l, llvm::Value* r) {
        llvm::Value* res = nullptr;
        llvm::Value* ovf = nullptr;
        if (op == "*") {
            // Signed multiply: the intrinsic is the practical detector (a manual check needs a wider
            // multiply). Multiplies are rarer than add/sub in hot arithmetic, so the intrinsic's cost is
            // localized.
            llvm::Value* pair = builder.CreateBinaryIntrinsic(llvm::Intrinsic::smul_with_overflow, l, r);
            res = builder.CreateExtractValue(pair, 0, "ovf.res");
            ovf = builder.CreateExtractValue(pair, 1, "ovf.bit");
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
        emitPanic("integer overflow");
        builder.SetInsertPoint(okBB);
        return res;
    }

    // Saturating arithmetic (spec 3.6): clamp to the type's min/max on overflow instead of wrapping.
    // Add/sub have direct intrinsics; multiply detects overflow and clamps by the operand signs.
    llvm::Value* emitSaturatingArith(const std::string& m, llvm::Value* a, llvm::Value* b, bool uns) {
        if (m == "saturatingAdd")
            return builder.CreateBinaryIntrinsic(
                uns ? llvm::Intrinsic::uadd_sat : llvm::Intrinsic::sadd_sat, a, b);
        if (m == "saturatingSub")
            return builder.CreateBinaryIntrinsic(
                uns ? llvm::Intrinsic::usub_sat : llvm::Intrinsic::ssub_sat, a, b);
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
        const unsigned esz = arrayElemBytes(na.elementType);  // real element width (boolean=1, else 1/2/4/8)
        llvm::Value* elemBytes = builder.CreateMul(n64, builder.getInt64(esz));
        llvm::Value* total = builder.CreateAdd(builder.getInt64(8), elemBytes);
        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "arr");
        builder.CreateStore(n64, block);  // length header (element count)
        builder.CreateCall(memsetFn(), {arrayData(block), builder.getInt32(0), elemBytes});
        return block;
    }

    // Builds the String[] handed to main(string[] args) from the process argv, skipping argv[0] (the
    // program name). Matches the array layout [i64 length][String* elements]; each String points at the
    // argv string (NUL-terminated, valid for the whole run).
    llvm::Value* emitArgvArray(llvm::Value* argc, llvm::Value* argv) {
        llvm::Type* i64 = builder.getInt64Ty();
        llvm::Type* p = builder.getPtrTy();
        llvm::Value* n = builder.CreateSub(builder.CreateSExt(argc, i64), builder.getInt64(1));
        n = builder.CreateSelect(builder.CreateICmpSLT(n, builder.getInt64(0)), builder.getInt64(0), n);
        llvm::Value* total =
            builder.CreateAdd(builder.getInt64(8), builder.CreateMul(n, builder.getInt64(8)));
        llvm::Value* block = builder.CreateCall(mallocFn(), {total}, "argv.arr");
        builder.CreateStore(n, block);
        llvm::Value* data = arrayData(block);
        llvm::FunctionCallee strlenFn =
            module.getOrInsertFunction("strlen", llvm::FunctionType::get(i64, {p}, false));
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
        llvm::Value* str = emitStringFromParts(builder.CreateCall(strlenFn, {src}, "argv.len"), src);
        builder.CreateStore(str, builder.CreateGEP(p, data, i));
        builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(endBB);
        return block;
    }

    // `[a, b, c]` (spec 25): allocate an array block of n elements and store each. Same layout as
    // emitNewArray ([i64 length][elements]); stores bypass the bounds check (indices are known).
    llvm::Value* emitArrayLiteral(const ast::ArrayLiteralExpr& al) {
        const std::size_t n = al.elements.size();
        const std::string elemType = n > 0 ? typeName(*al.elements[0]) : "int";
        const unsigned esz = arrayElemBytes(elemType);
        llvm::Value* block = builder.CreateCall(
            mallocFn(), {builder.getInt64(8 + static_cast<std::uint64_t>(n) * esz)}, "arrlit");
        builder.CreateStore(builder.getInt64(static_cast<std::uint64_t>(n)), block);  // length header
        llvm::Type* et = arrayStorageTy(elemType);
        llvm::Value* data = arrayData(block);
        for (std::size_t i = 0; i < n; ++i) {
            llvm::Value* v = emitExpr(*al.elements[i]);
            if (v == nullptr) continue;
            v = coerce(v, typeName(*al.elements[i]), elemType);  // widen/convert to element type
            if (elemType == "boolean") v = builder.CreateTrunc(v, builder.getInt8Ty());  // 1-byte slot
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

    // Resolves the receiver object pointer for a member/method access. When the receiver is a nullable
    // reference (spec 3.7) and the access actually dereferences it (field/method/assignment, i.e.
    // derefCheck), a null receiver traps deterministically with a message rather than segfaulting on a
    // read through address 0. `&x` (address-of) does not dereference, so it opts out. Non-nullable
    // receivers pay nothing -- the check is emitted only for a nullable reference type.
    llvm::Value* emitObjectPtr(const ast::Expr& expr, bool derefCheck = true) {
        llvm::Value* ptr = emitObjectPtrRaw(expr);
        if (ptr != nullptr && derefCheck) {
            const std::string t = typeName(expr);
            if (!t.empty() && t.back() == '?' && !isBoxablePrimitive(t.substr(0, t.size() - 1)))
                emitNullReceiverCheck(ptr);
        }
        return ptr;
    }
    void emitNullReceiverCheck(llvm::Value* ptr) {
        llvm::Value* isNull =
            builder.CreateICmpEQ(ptr, llvm::ConstantPointerNull::get(builder.getPtrTy()));
        llvm::BasicBlock* trapBB = llvm::BasicBlock::Create(context, "nullrecv", currentFn);
        llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "nullrecv.ok", currentFn);
        builder.CreateCondBr(isNull, trapBB, okBB);
        builder.SetInsertPoint(trapBB);
        emitPanic("null reference dereference");  // ends the block with unreachable
        builder.SetInsertPoint(okBB);
    }
    llvm::Value* emitObjectPtrRaw(const ast::Expr& expr) {
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
            return arrayElemPtr(block, index, arrayStorageTy(elementOf(at)),
                                /*checked=*/!ix->unchecked && !noBoundsCheck_);
        }
        error("invalid assignment target", expr.loc);
        return nullptr;
    }

    // The String object layout: { i64 length, ptr data }. Lazily created.
    llvm::StructType* stringType() {
        if (stringStructTy == nullptr)
            stringStructTy = llvm::StructType::create(
                context, {builder.getInt64Ty(), builder.getPtrTy(), builder.getInt64Ty()}, "String");
            // Layout: { i64 length, ptr data, i64 hash }. The trailing hash is a lazily-cached FNV-1a of
            // the bytes (0 = not yet computed); a String being immutable, it is computed at most once.
        return stringStructTy;
    }

    // Materializes an immutable String object as a private global { length, data },
    // where data points to a null-terminated byte array. Returns a ptr to the object.
    llvm::Value* emitStringObject(const std::string& bytes) {
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

    // Loads the null-terminated byte pointer (data) of a String object, for libc interop.
    llvm::Value* stringData(llvm::Value* strObj) {
        return builder.CreateLoad(builder.getPtrTy(),
                                  builder.CreateStructGEP(stringType(), strObj, 1, "str.data"), "data");
    }
    // Concatenates two String/string values into a fresh String: the basis of the + operator and the
    // concat method (spec 4).
    llvm::Value* emitStringConcat(llvm::Value* a, llvm::Value* b) {
        llvm::Value* la = stringLen(a);
        llvm::Value* lb = stringLen(b);
        llvm::Value* total = builder.CreateAdd(la, lb);
        llvm::Value* buf = builder.CreateCall(
            mallocFn(), {builder.CreateAdd(total, builder.getInt64(1))}, "cat.buf");
        builder.CreateCall(memcpyFn(), {buf, stringData(a), la});
        builder.CreateCall(memcpyFn(),
                           {builder.CreateGEP(builder.getInt8Ty(), buf, la), stringData(b), lb});
        builder.CreateStore(builder.getInt8(0),
                            builder.CreateGEP(builder.getInt8Ty(), buf, total));  // NUL terminator
        return emitStringFromParts(total, buf);
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

    // Runtime String RAII helpers (a single call, so codegen never splits a block to null-check).
    llvm::FunctionCallee strCopyFn() {
        return module.getOrInsertFunction("__ldp3_str_copy",
            llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false));
    }
    llvm::FunctionCallee strFreeFn() {
        return module.getOrInsertFunction("__ldp3_str_free",
            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false));
    }
    // Deep-copy a String into a fresh, fully-owned one (null-safe). Emitted on every String store so the
    // destination owns its own buffer and no live String is ever aliased.
    llvm::Value* emitStringCopy(llvm::Value* v) {
        if (v == nullptr) return v;
        return builder.CreateCall(strCopyFn(), {v}, "strcpy");
    }
    // Record a freshly-owned String temporary to free at the statement boundary.
    void trackStringTemp(llvm::Value* v) {
        if (v != nullptr) stringTemps.emplace_back(v, builder.GetInsertBlock());
    }
    // Wrap a fresh-malloc String producer: track it as an owned temporary, then return it unchanged.
    llvm::Value* ownedStr(llvm::Value* v) { trackStringTemp(v); return v; }
    // At a statement boundary: free the owned temporaries created in the CURRENT block (they dominate the
    // free point) and clear the list. Temporaries from a conditional arm (a different block) are dropped,
    // never freed unsafely. A no-op when empty, so code without String temporaries pays nothing.
    void freeStringTemps() {
        if (stringTemps.empty()) return;
        llvm::BasicBlock* here = builder.GetInsertBlock();
        if (here != nullptr && here->getTerminator() == nullptr)
            for (auto& tb : stringTemps)
                if (tb.second == here) builder.CreateCall(strFreeFn(), {tb.first});
        stringTemps.clear();
    }
    // Free the owned String temporaries created since `from` (a ternary/expression arm's own temps) that
    // live in the current block, and forget them. Used when an arm's value has just been copied into an
    // owned result, so the arm's producer temp (e.g. a substring in `cond ? a : b.substring()`) is freed
    // here rather than being dropped at the merge -- where freeStringTemps only sees the merge block.
    void releaseArmStringTemps(std::size_t from) {
        llvm::BasicBlock* here = builder.GetInsertBlock();
        if (here != nullptr && here->getTerminator() == nullptr)
            for (std::size_t i = from; i < stringTemps.size(); ++i)
                if (stringTemps[i].second == here)
                    builder.CreateCall(strFreeFn(), {stringTemps[i].first});
        if (from <= stringTemps.size()) stringTemps.resize(from);
    }
    // True if `slot` is a String local we own (tracked for scope-exit release) -- so reassigning it may
    // free the previous copy. A parameter slot or an untracked variable is left alone.
    bool isTrackedStringSlot(llvm::Value* slot) {
        return std::find(scopeStrings.begin(), scopeStrings.end(), slot) != scopeStrings.end();
    }
    // String RAII stage 2: true iff this call resolves to a user-defined method (or enum/catalog
    // method) whose declared return type is String. Every user method copy-on-returns (see the return
    // path), so its result is a freshly-owned String -- safe to register as a temporary and free at the
    // statement boundary. Builtins never match here: their receiver is not a user class/enum, so the
    // borrowed-String builtins (`.toString()` identity on a String, Env/Net cstr wrappers) and the
    // self-tracking String producers (concat/substring/...) are excluded and never double-freed.
    bool callReturnsOwnedUserString(const ast::CallExpr& call) {
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
        if (mem == nullptr) return false;
        // Enum/catalog instance method (spec 12.4): resolve the (possibly catalog-implementing) enum.
        std::string enumRecv = baseType(typeName(*mem->object));
        if (enumMethodDecls.find(enumRecv) == enumMethodDecls.end())
            if (std::string impl = catalogImplementerEnum(enumRecv, mem->member); !impl.empty())
                enumRecv = impl;
        if (auto eit = enumMethodDecls.find(enumRecv); eit != enumMethodDecls.end()) {
            for (const ast::MemberPtr& member : eit->second->members) {
                const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                if (m != nullptr && m->name == mem->member)
                    return typeRefName(m->returnType) == "String";
            }
            return false;
        }
        // Instance: search the receiver's class hierarchy; static: the named class.
        std::string owner = methodOwner(typeName(*mem->object), mem->member);
        if (owner.empty() && classes.count(flattenCallee(*mem->object)) > 0)
            owner = methodOwner(flattenCallee(*mem->object), mem->member);
        if (owner.empty()) return false;
        // An async method yields a Task<...>, not an owned String; leave it alone.
        const ast::MethodDecl* md = findMethodDecl(owner, mem->member);
        if (md != nullptr && md->isAsync) return false;
        return classes[owner].methodReturnType[mem->member] == "String";
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
                 builder.getInt64Ty(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(),
                 builder.getInt64Ty(), builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy(),
                 builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()},
                "ReflectType");  // ..., ptr fieldGetters, ptr fieldSetters, ptr methodAnnCounts(i64[]),
                                 // ptr methodAnnNames(ptr[] -> String[]), ptr methodRetTags(i64[])
        return typeStructTy;
    }
    // The reflection Annotation token layout: { ptr name }. Lazily created.
    llvm::StructType* annotationTokenType() {
        if (annotationStructTy == nullptr)
            annotationStructTy =
                llvm::StructType::create(context, {builder.getPtrTy()}, "ReflectAnnotation");
        return annotationStructTy;
    }
    // The reflection Method token layout: { ptr name, ptr fn, i64 annCount, ptr annNames(String[]),
    // i64 retTag }. retTag encodes the return type for invoke (see returnTag): 0=void, 1=i32, 2=i64,
    // 3=f64, 4=f32, 5=pointer. The annotation slots let a Method report its applied annotations (spec
    // 31). Lazily created.
    llvm::StructType* methodTokenType() {
        if (methodStructTy == nullptr)
            methodStructTy = llvm::StructType::create(
                context,
                {builder.getPtrTy(), builder.getPtrTy(), builder.getInt64Ty(), builder.getPtrTy(),
                 builder.getInt64Ty()},
                "ReflectMethod");
        return methodStructTy;
    }
    // Encodes a method's return type as a tag for reflective invoke (Method token field 4). Distinct
    // widths get distinct tags so the call uses the correct ABI (no-UB): 0=void, 1=i32, 2=i64, 3=f64,
    // 4=f32, 5=pointer, 6=i8, 7=i16.
    long long returnTag(const std::string& rt) {
        const std::string b = baseType(rt);
        if (b.empty() || b == "void") return 0;
        if (b == "long" || b == "int64" || b == "uint64" || b == "ulong") return 2;
        if (b == "double" || b == "float64") return 3;
        if (b == "float" || b == "float32" || b == "smallfloat") return 4;
        if (b == "byte" || b == "int8" || b == "ubyte" || b == "uint8") return 6;
        if (b == "short" || b == "int16" || b == "ushort" || b == "uint16") return 7;
        if (isBoxablePrimitive(b)) return 1;  // int/boolean/char/int32/uint32 (i32)
        return 5;  // a reference (class/String/array/enum/Object)
    }
    // The boxed-primitive type name for a return tag (for emitBox); "" means a pointer/void (no box).
    std::string tagBoxType(long long tag) {
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
    // The LLVM return type for a return tag.
    llvm::Type* tagRetType(long long tag) {
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
    // The reflection Field token layout: { ptr name, ptr getFn, ptr setFn }. The accessors box/unbox
    // the field value, so get/set work through Object (spec 31). Lazily created.
    llvm::StructType* fieldTokenType() {
        if (fieldStructTy == nullptr)
            fieldStructTy = llvm::StructType::create(
                context, {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, "ReflectField");
        return fieldStructTy;
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
    // Generates a per-field accessor for reflection get/set (spec 31). The field type is known here,
    // so the getter boxes a primitive (or returns a reference) and the setter unboxes (or stores the
    // reference) with no runtime type dispatch. Returns a function pointer for the Field token.
    llvm::Constant* emitFieldAccessor(const std::string& className, const std::string& fieldName,
                                      bool setter) {
        auto cit = classes.find(className);
        llvm::Constant* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
        if (cit == classes.end()) return nullp;
        auto idxIt = cit->second.fieldIndex.find(fieldName);
        auto tyIt = cit->second.fieldType.find(fieldName);
        if (idxIt == cit->second.fieldIndex.end() || tyIt == cit->second.fieldType.end()) return nullp;
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
        if (saved != nullptr) builder.SetInsertPoint(saved);
        return f;
    }

    // The Type token for a class (spec 31), one shared global per class, holding its name
    // and its declared method and field names (in declaration order).
    llvm::Value* typeTokenFor(const std::string& className) {
        auto it = typeGlobals.find(className);
        if (it != typeGlobals.end()) return it->second;
        std::vector<std::string> methodNames, fieldNames, annotationNames;
        std::vector<llvm::Constant*> methodRetTags;  // parallel to methodNames (for invoke, spec 31)
        if (auto cit = classes.find(className); cit != classes.end() && cit->second.decl != nullptr) {
            for (const ast::MemberPtr& m : cit->second.decl->members) {
                if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                    methodNames.push_back(md->name);
                    methodRetTags.push_back(
                        builder.getInt64(returnTag(typeRefName(md->returnType))));
                } else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get()))
                    fieldNames.push_back(fd->name);
            }
            for (const ast::AnnotationUse& a : cit->second.decl->annotations)
                annotationNames.push_back(a.name);  // applied [Name(...)] annotations (spec 14.3, 31)
        }
        auto* nameStr = llvm::cast<llvm::Constant>(emitStringObject(className));
        auto [mcount, mnames] = nameArray(methodNames, "methods." + className);
        auto [fcount, fnames] = nameArray(fieldNames, "fields." + className);
        auto [acount, anames] = nameArray(annotationNames, "annotations." + className);
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
        if (auto cit = classes.find(className); cit != classes.end() && cit->second.decl != nullptr) {
            std::size_t mi = 0;
            for (const ast::MemberPtr& m : cit->second.decl->members) {
                if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                    std::vector<std::string> anns;
                    for (const ast::AnnotationUse& a : md->annotations) anns.push_back(a.name);
                    auto [cnt, arr] = nameArray(anns, "methodann." + className + "." + std::to_string(mi));
                    mAnnCounts.push_back(cnt);
                    mAnnPtrs.push_back(arr);
                    ++mi;
                }
            }
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
        if (auto cit = classes.find(className); cit != classes.end())
            size = llvm::cast<llvm::Constant>(sizeOf(cit->second.type));
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

    // The enum that implements `catalog` and provides `method` (spec 12.4), or "" if none. The
    // analyzer guarantees a single implementer reaches here, so the first match is unambiguous.
    std::string catalogImplementerEnum(const std::string& catalog, const std::string& method) {
        for (const auto& [enumName, decl] : enumMethodDecls)
            for (const std::string& c : decl->extendsCatalogs)
                if (baseType(c) == catalog && functions.count(enumName + "." + method) > 0)
                    return enumName;
        return "";
    }
    // Every method-carrying enum implementing `catalog`, in a deterministic order (by type id), for
    // multi-implementer dispatch (spec 12.4).
    std::vector<std::string> catalogImplEnums(const std::string& catalog) {
        std::vector<std::string> out;
        for (const auto& [enumName, decl] : enumMethodDecls)
            for (const std::string& c : decl->extendsCatalogs)
                if (baseType(c) == catalog) { out.push_back(enumName); break; }
        std::sort(out.begin(), out.end(), [&](const std::string& a, const std::string& b) {
            return enumTypeId[a] < enumTypeId[b];
        });
        return out;
    }
    // A catalog is "tagged" (carries a runtime type id alongside its ordinal, lowering to i64) when at
    // least one method-carrying enum implements it -- i.e. dispatch through it is meaningful. Value-only
    // catalogs stay a bare i32 ordinal so existing code is unaffected.
    bool isTaggedCatalog(const std::string& name) {
        if (catalogNames.count(name) == 0) return false;
        for (const auto& [enumName, decl] : enumMethodDecls)
            for (const std::string& c : decl->extendsCatalogs)
                if (baseType(c) == name) return true;
        return false;
    }

    // Resolves an overloaded literal suffix (spec 17.10 rule 6) to its mangled function key
    // (name$paramType): an exact parameter-type match wins, otherwise the first overload.
    std::string chooseLiteralKey(const std::string& name, const std::string& argType) {
        auto it = literalSuffixParams.find(name);
        if (it == literalSuffixParams.end() || it->second.empty()) return "";
        for (const std::string& p : it->second)
            if (p == argType) return name + "$" + p;
        return name + "$" + it->second[0];
    }

    // Emits a capture-free lambda as a C-callable function (spec 26): no environment parameter, so
    // its signature is exactly R(Args) and its address is a raw C function pointer. A capturing
    // lambda is rejected (a C callback has nowhere to carry the environment).
    llvm::Function* emitCallbackFn(const ast::LambdaExpr& lam) {
        if (!lam.captures.empty()) {
            error("a capturing lambda cannot be passed as a C callback; use a capture-free lambda "
                  "(spec 26)",
                  lam.loc);
            return nullptr;
        }
        std::vector<llvm::Type*> pts;
        for (const auto& p : lam.params) pts.push_back(llvmType(typeRefName(p.type)));
        llvm::Type* rt = llvmType(typeRefName(lam.returnType));
        llvm::Function* fn = llvm::Function::Create(
            llvm::FunctionType::get(rt, pts, false), llvm::Function::InternalLinkage,
            "__ldp3_cb_" + std::to_string(lambdaCounter++), module);
        // emitBody clobbers function-local state -- save and restore it (mirrors the lambda path).
        auto sFn = currentFn; auto sCls = currentClass; auto sRet = currentRetType; auto sRetN = currentRetTypeName_;
        auto sEns = currentEnsures; auto sInv = currentInvariants; auto sThis = currentThis;
        auto sLoc = locals; auto sScope = scopeObjects; auto sDef = deferred;
        auto sRegions = scopeRegions; auto sDtorChain = currentDtorChain; auto sOld = oldValues_;
        auto sStr = scopeStrings; auto sTmp = stringTemps;  // String RAII: nested body gets its own set
        scopeStrings.clear(); stringTemps.clear();
        auto sIP = builder.saveIP();
        emitBody(fn, lam.body, lam.params, "", rt, nullptr, nullptr, nullptr, nullptr,
                 /*hasEnv=*/false);
        currentFn = sFn; currentClass = sCls; currentRetType = sRet; currentRetTypeName_ = sRetN;
        currentEnsures = sEns; currentInvariants = sInv; currentThis = sThis;
        currentDtorChain = sDtorChain; oldValues_ = sOld;
        locals = sLoc; scopeObjects = sScope; deferred = sDef; scopeRegions = sRegions;
        scopeStrings = sStr; stringTemps = sTmp;
        builder.restoreIP(sIP);
        return fn;
    }

    // Constructs Some<Enum>(ordinal) or None<Enum>() for EnumName.parse() (spec 12.5). parse() is typed
    // as the value Option<Enum> (no star), so build the value form -- a { tag, ordinal } -- to match.
    // ordinal < 0 = None.
    llvm::Value* emitOptionVariant(const std::string& variant, const std::string& en, int ordinal) {
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
            // Effective captures = explicitly-declared captures plus auto-captured free variables: any
            // identifier the body references that resolves to an enclosing local (and isn't the lambda's
            // own param or an already-declared capture). Auto-captures are byvalue, which copies the value
            // (for a function value, the closure pointer) so an escaping lambda never dangles on a stack var.
            std::vector<ast::Capture> eff = lam->captures;
            {
                std::set<std::string> refs;
                collectRefs(lam->body, refs);
                std::set<std::string> excluded;
                for (const auto& p : lam->params) excluded.insert(p.name);
                for (const auto& cap : lam->captures) excluded.insert(cap.name);
                for (const auto& name : refs) {
                    if (excluded.count(name)) continue;
                    if (locals.find(name) == locals.end()) continue;  // only enclosing locals
                    ast::Capture c;
                    c.byRef = false;
                    c.name = name;
                    eff.push_back(c);
                    excluded.insert(name);
                }
            }
            // Collect each captured variable's storage and type from the enclosing scope before
            // emitBody clears `locals`.
            std::vector<llvm::Value*> capStorages;
            std::vector<std::string> capTypes;
            for (const auto& cap : eff) {
                auto cit = locals.find(cap.name);
                capStorages.push_back(cit != locals.end() ? cit->second.storage : nullptr);
                capTypes.push_back(cit != locals.end() ? cit->second.type : std::string("int"));
            }
            // emitBody clobbers all function-local state -- save and restore it.
            auto sFn = currentFn; auto sCls = currentClass; auto sRet = currentRetType; auto sRetN = currentRetTypeName_;
            auto sEns = currentEnsures; auto sInv = currentInvariants; auto sThis = currentThis;
            auto sLoc = locals; auto sScope = scopeObjects; auto sDef = deferred;
            auto sRegions = scopeRegions;
            auto sDtorChain = currentDtorChain;
            auto sOld = oldValues_;  // emitBody clears these; the enclosing method's old() slots must survive
            auto sStr = scopeStrings; auto sTmp = stringTemps;  // String RAII: nested body gets its own set
            scopeStrings.clear(); stringTemps.clear();
            auto sIP = builder.saveIP();
            emitBody(fn, lam->body, lam->params, "", rt, nullptr, nullptr, nullptr, nullptr,
                     /*hasEnv=*/true, &eff, &capTypes);
            currentFn = sFn; currentClass = sCls; currentRetType = sRet; currentRetTypeName_ = sRetN;
            currentEnsures = sEns; currentInvariants = sInv; currentThis = sThis;
            currentDtorChain = sDtorChain;
            oldValues_ = sOld;
            locals = sLoc; scopeObjects = sScope; deferred = sDef;
            scopeRegions = sRegions;
            scopeStrings = sStr; stringTemps = sTmp;
            builder.restoreIP(sIP);
            // No captures: the closure {code, null} is a compile-time constant. Emit it as a private
            // unnamed constant global instead of a heap allocation. Two wins: a no-capture lambda never
            // allocates, and -- because the code pointer is now a constant the optimizer can see through --
            // LLVM (IPSCCP) can propagate this closure into the higher-order method that receives it,
            // turning the per-element indirect call through the function value into a direct, inlinable one.
            if (eff.empty()) {
                auto* pairTy = llvm::ArrayType::get(builder.getPtrTy(), 2);
                std::vector<llvm::Constant*> fields = {
                    llvm::cast<llvm::Constant>(fn),
                    llvm::ConstantPointerNull::get(builder.getPtrTy())};
                auto* gv = new llvm::GlobalVariable(
                    module, pairTy, /*isConstant=*/true, llvm::GlobalValue::PrivateLinkage,
                    llvm::ConstantArray::get(pairTy, fields), "__ldp3_closure");
                gv->setUnnamedAddr(llvm::GlobalValue::UnnamedAddr::Global);
                return gv;
            }
            // Captures: build the environment (one pointer slot per capture; byvalue copies the value into
            // a fresh heap slot, byref shares the variable's own storage) and wrap {code, env} on the heap.
            llvm::Value* envPtr = builder.CreateCall(
                mallocFn(), {builder.getInt64(8 * (std::int64_t)eff.size())}, "env");
            for (std::size_t i = 0; i < eff.size(); i++) {
                llvm::Value* dst =
                    builder.CreateGEP(builder.getPtrTy(), envPtr, builder.getInt32(i));
                if (eff[i].byRef) {
                    builder.CreateStore(capStorages[i], dst);  // share the original storage
                } else {
                    llvm::Type* vt = llvmType(capTypes[i]);
                    llvm::Value* copy =
                        builder.CreateCall(mallocFn(), {builder.getInt64(8)}, "cap");
                    builder.CreateStore(builder.CreateLoad(vt, capStorages[i]), copy);
                    builder.CreateStore(copy, dst);
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
            if (f->isDecimal)  // i128 mantissa scaled by 10^18 (spec 34)
                return llvm::ConstantInt::get(context,
                                              llvm::APInt(128, decimalScaledString(f->text), 10));
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
            // A class-level const, read as Type.NAME (spec 28.1, OOP form): folded constant.
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get()))
                if (const std::string ck = oid->name + "." + mem->member;
                    namespaceConstTypes.count(ck) > 0)
                    return constLiteral(ck);
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
                        // If the enum can be unimported (spec 30), guard the access: a use after
                        // `unimport enum X` throws UnimportedTypeException.
                        emitAliveGuard(objId->name);
                        auto pos = std::find(eit->second.begin(), eit->second.end(), mem->member);
                        const int ord = pos == eit->second.end()
                                            ? 0
                                            : static_cast<int>(pos - eit->second.begin());
                        return builder.getInt32(static_cast<std::uint32_t>(ord));
                    }
                }
            }
            // Computed get-only property: obj.name calls the getter (no parens). Dispatch through the
            // vtable when a subtype may override the getter -- exactly like a method call -- so an
            // overridden property reads the most-derived value; a concrete, un-subclassed receiver
            // devirtualizes to a direct call.
            const std::string ot = baseType(typeName(*mem->object));
            if (const ast::MethodDecl* pm = findMethodDecl(ot, mem->member);
                pm != nullptr && pm->isProperty) {
                llvm::Value* recv = emitObjectPtr(*mem->object);
                if (recv == nullptr) return nullptr;
                auto otit = classes.find(ot);
                const bool mayBeSubtype =
                    otit != classes.end() &&
                    (subclassed_.count(ot) > 0 || otit->second.isInterface ||
                     otit->second.isAbstract || otit->second.imported);
                const int slot = slotIndex(ot, mem->member);
                if (otit != classes.end() && otit->second.hasVtable && mayBeSubtype && slot >= 0) {
                    llvm::Value* vtblField =
                        builder.CreateStructGEP(otit->second.type, recv, 0, "vtbl.addr");
                    llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), vtblField, "vtbl");
                    llvm::Type* vtArrTy =
                        llvm::ArrayType::get(builder.getPtrTy(), otit->second.vtslots.size());
                    llvm::Value* slotPtr = builder.CreateConstGEP2_64(
                        vtArrTy, vtbl, 0, static_cast<std::uint64_t>(slot), "slot");
                    llvm::Value* fnPtr = builder.CreateLoad(builder.getPtrTy(), slotPtr, "fn");
                    return builder.CreateCall(methodFnType(pm), fnPtr, {recv});
                }
                const std::string owner = methodOwner(ot, mem->member);
                auto fnit = functions.find(owner + "." + mem->member);
                if (fnit != functions.end()) return builder.CreateCall(fnit->second, {recv});
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
            // await on a non-Task (a channel receive, spec 20.7) is a passthrough: the operand already
            // produces the value by blocking, so just evaluate it (the analyzer restricts this form).
            if (baseType(typeName(*aw->operand)).rfind("Task$", 0) != 0)
                return emitExpr(*aw->operand);
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
                emitAwaitRethrowCheck(savedH);  // re-throw here if the awaited task failed (spec 21)
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
            emitAwaitRethrowCheck(h);  // re-throw here if the awaited task failed (spec 21)
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
            if (un->op == "&") {
                // Address-of. For a class/struct value the variable's slot already holds the pointer to
                // the object -- its identity IS that pointer, so `&rex` is just `rex` (and address-of
                // does not dereference, so a null nullable is fine here). For anything else -- an int
                // local, an array element, a field -- the address is the address of its STORAGE, which
                // is what emitLValue yields. Taking emitObjectPtr for those loaded the VALUE and used it
                // as a pointer: `int* p = &xs[0]` used to produce garbage (a silent memory-safety hole).
                const std::string ot = typeName(*un->operand);
                const bool isObject = !ot.empty() && !isArrayType(ot) && !isRefType(ot) &&
                                      classes.count(baseType(ot)) > 0;
                if (isObject) return emitObjectPtr(*un->operand, /*derefCheck=*/false);
                return emitLValue(*un->operand);
            }
            // Unary operator overload (spec 6.5): a.operator<op>() when a's class defines a no-arg
            // one. A unary overload takes only `this` (arg_size 1), which distinguishes it from the
            // binary form of the same symbol.
            {
                const std::string owner =
                    methodOwner(baseType(typeName(*un->operand)), "operator" + un->op);
                if (!owner.empty()) {
                    auto fnit = functions.find(owner + ".operator" + un->op);
                    if (fnit != functions.end() && fnit->second->arg_size() == 1) {
                        llvm::Value* recv = emitExpr(*un->operand);
                        if (recv == nullptr) return nullptr;
                        return emitMaybeInvoke(fnit->second, {recv});
                    }
                }
            }
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
        if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(&expr)) {
            // A first-class range value (spec 7.5): new Range(start, end, step, inclusive) on the heap.
            llvm::Value* startV = coerceToType(emitExpr(*rng->start), builder.getInt32Ty());
            llvm::Value* endV = coerceToType(emitExpr(*rng->end), builder.getInt32Ty());
            llvm::Value* stepV = rng->step ? coerceToType(emitExpr(*rng->step), builder.getInt32Ty())
                                           : builder.getInt32(1);
            llvm::Value* incV = builder.getInt32(rng->inclusive ? 1 : 0);
            auto cit = classes.find("Range");
            if (cit == classes.end()) { error("Range type is not available", rng->loc); return nullptr; }
            llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "range");
            builder.CreateCall(functions["Range.Range"], {obj, startV, endV, stepV, incV});
            return obj;
        }
        if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) {
            llvm::Value* src = emitExpr(*mv->operand);
            if (src == nullptr) return nullptr;
            // `move x into/to region R` (spec 19.3): physically relocate the object into R's arena
            // (bump-allocate + shallow copy) so it outlives the source region's release. The analyzer
            // invalidates the source, so the old storage is dead. Otherwise a move is a pointer transfer.
            if (!mv->toRegion.empty()) {
                const std::string cls = baseType(typeName(*mv->operand));
                if (auto cit = classes.find(cls); cit != classes.end() && cit->second.type != nullptr) {
                    llvm::Value* dst = emitRegionAlloc(mv->toRegion, cit->second.type, mv->loc);
                    if (dst != nullptr) {
                        builder.CreateCall(memcpyFn(), {dst, src, sizeOf(cit->second.type)});
                        return dst;
                    }
                }
            }
            return src;  // move transfers the pointer (no copy)
        }
        if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(&expr)) {
            // `extract X from region R` (spec 17): relocate X out of the region to a fresh heap block and
            // yield the owning pointer. This is a MOVE -- a shallow copy of the object's bytes, so owned
            // heap fields (String/array backings, whose pointers live in those bytes) travel with it; the
            // source is not destructed. The vacated slot is reclaimed on pool/fixedslot (dead until release
            // on bump). The source lvalue is nulled and dropped from region RAII so nothing double-frees it.
            const std::string cn = baseType(typeName(*ex->target));
            auto cit = classes.find(cn);
            if (cit == classes.end() || cit->second.type == nullptr) {
                error("extract requires a class object (spec 17)", ex->loc);
                return nullptr;
            }
            llvm::Value* addr = emitLValue(*ex->target);       // where the source handle is stored
            llvm::Value* srcPtr = emitObjectPtr(*ex->target);  // the object's address in the region
            if (addr == nullptr || srcPtr == nullptr) return nullptr;
            llvm::Value* heap = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "extract.heap");
            builder.CreateCall(memcpyFn(), {heap, srcPtr, sizeOf(cit->second.type)});  // shallow move-out
            // Drop the source object from region RAII tracking so release does not destruct the moved bytes.
            if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(ex->target.get()))
                if (auto lit = locals.find(tid->name); lit != locals.end())
                    for (auto so = scopeObjects.begin(); so != scopeObjects.end(); ++so)
                        if (so->slot == lit->second.storage) { scopeObjects.erase(so); break; }
            // Reclaim/untrack the vacated slot on a pool/fixedslot/stack region (the runtime free untracks
            // a stack object so rollback/release never re-destructs the bytes that moved to the heap).
            const std::string rflavor =
                flavorOfRegion(ex->region);
            if (usesRuntimeDesc(rflavor)) {
                llvm::Value* block = builder.CreateLoad(
                    builder.getPtrTy(), regionStorageSlot(ex->region), "region");
                builder.CreateCall(regionFreeFn(), {block, srcPtr, sizeOf(cit->second.type)});
            }
            // Null the source handle: a later read is then a clean null, not a dangling reused slot (the
            // analyzer already rejects use-after-extract of a plain variable at compile time).
            builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), addr);
            return heap;
        }
        if (const auto* mk = dynamic_cast<const ast::MarkExpr*>(&expr)) {
            // `mark of region R`: capture the stack region's cursor (desc->used at offset 0) as a checkpoint.
            llvm::Value* slot = regionStorageSlot(mk->region);
            if (slot == nullptr) { error("unknown region '" + mk->region + "'", mk->loc); return nullptr; }
            llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
            return builder.CreateLoad(builder.getInt64Ty(), block, "mark");
        }
        if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
            // try? expr (spec 21.2): if Ok/Some, yield the inner value; if Err/None, early-return the
            // operand to the enclosing method's Result/Option (propagation).
            llvm::Value* val = emitExpr(*tx->operand);
            if (val == nullptr) return nullptr;
            const std::string opType = typeName(*tx->operand);
            const bool isValue = isValueVariant(opType);
            const std::string base = baseType(opType);  // Result$T$E / Option$T
            const auto p = base.find('$');
            const std::string variant = base.rfind("Option", 0) == 0 ? "Some" : "Ok";
            auto cit = classes.find(p == std::string::npos ? variant : variant + base.substr(p));
            if (cit == classes.end() || cit->second.fieldIndex.count("value") == 0 ||
                (!isValue && cit->second.vtable == nullptr)) {
                error("try? requires a Result or Option operand", tx->loc);
                return nullptr;
            }
            const std::string vt = cit->second.fieldType.at("value");  // T
            llvm::Function* fn = builder.GetInsertBlock()->getParent();
            llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "try.ok", fn);
            llvm::BasicBlock* errBB = llvm::BasicBlock::Create(context, "try.err", fn);
            if (isValue) {  // value form: dispatch on the tag (0 = Ok/Some)
                llvm::Value* tag = builder.CreateExtractValue(val, {0u}, "try.tag");
                builder.CreateCondBr(builder.CreateICmpEQ(tag, builder.getInt32(0), "try.ok?"), okBB,
                                     errBB);
            } else {  // boxed form: dispatch on the vtable
                llvm::Value* vtbl = builder.CreateLoad(builder.getPtrTy(), val, "try.vtbl");
                builder.CreateCondBr(builder.CreateICmpEQ(vtbl, cit->second.vtable, "try.ok?"), okBB,
                                     errBB);
            }
            builder.SetInsertPoint(errBB);
            emitPendingFinallys(0);       // run enclosing finallys before propagating out
            emitScopeCleanup();           // run destructors/defers before propagating
            if (builder.GetInsertBlock()->getTerminator() == nullptr)
                builder.CreateRet(val);   // forward the Err/None (value struct or boxed ptr) unchanged
            builder.SetInsertPoint(okBB);
            if (isValue) {  // decode the payload to T
                llvm::Value* payload = builder.CreateExtractValue(val, {1u}, "try.pl");
                return variantDecode(payload, llvmType(vt));
            }
            llvm::Value* vp = builder.CreateStructGEP(cit->second.type, val,
                                                      cit->second.fieldIndex.at("value"), "try.vp");
            return builder.CreateLoad(llvmType(vt), vp, "try.value");
        }
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
            return emitRegionAllocate(ri->size.get(), ri->atAddress.get(), pendingRegionFlavor_,
                                      pendingRegionGrowable_);
        }
        if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
            // `x is T` (op 1) / `x as? T` (op 2), spec 6.4: a runtime is-a test on a class value.
            if (cst->op == 1 || cst->op == 2) {
                llvm::Value* obj = emitExpr(*cst->operand);
                if (obj == nullptr) return nullptr;
                llvm::Value* isa = emitIsa(obj, baseType(cst->targetType));  // i1, null-safe
                if (cst->op == 1) return builder.CreateZExt(isa, builder.getInt32Ty());  // boolean = i32
                return builder.CreateSelect(isa, obj,
                                            llvm::ConstantPointerNull::get(builder.getPtrTy()));
            }
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
                return emitMaybeInvoke(fnit->second, {recv, idx});
            }
            // SIMD vector/matrix index: v[i] / m[i] -> extractelement, bounds-checked (no UB).
            if (int w = (at == "mat4" ? 16 : vecWidth(at)); w > 0) {
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
            if (!isRefType(at) && et == "boolean") {  // boolean array element: 1-byte storage, i32 value
                llvm::Value* raw = builder.CreateLoad(builder.getInt8Ty(), elemPtr, "elem");
                return builder.CreateZExt(raw, builder.getInt32Ty());
            }
            return builder.CreateLoad(llvmType(et), elemPtr, "elem");
        }
        if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(&expr)) {
            return emitInterp(*is, /*addNewline=*/false, /*asString=*/true);  // $"..." -> String (4.1)
        }
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
            // super(args) was already emitted in the constructor prologue.
            if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
                return nullptr;
            }
            // spec 32.8: `Dog.methods.replace("bark", fn)` rewrites the class's vtable slot.
            if (const auto* rp = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                rp != nullptr && rp->member == "replace" && call->args.size() == 2)
                if (const auto* tbl = dynamic_cast<const ast::MemberExpr*>(rp->object.get());
                    tbl != nullptr && tbl->member == "methods")
                    if (const auto* cn = dynamic_cast<const ast::IdentifierExpr*>(tbl->object.get());
                        cn != nullptr && classes.count(cn->name) > 0)
                        return emitMethodPatch(cn->name, *call);
            llvm::Value* r = emitCall(*call);
            // String RAII stage 2: a user method's String result is owned (copy-on-return). Register it
            // as a temporary so a discarded / consumed result is freed at the statement boundary instead
            // of leaking. Stores and returns copy first, so this never frees a still-referenced String.
            if (r != nullptr && callReturnsOwnedUserString(*call)) return ownedStr(r);
            return r;
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
        // For a nullable primitive `x ?? d`, x is a boxed pointer: unbox it on the non-null branch and
        // yield the inner primitive (matching d's type). For a nullable reference, the value is the
        // pointer itself and passes through.
        const std::string lt = typeName(*nc.lhs);
        const bool nullablePrim =
            !lt.empty() && lt.back() == '?' && isBoxablePrimitive(lt.substr(0, lt.size() - 1));
        const std::string inner = nullablePrim ? lt.substr(0, lt.size() - 1) : std::string();
        llvm::Value* a = emitExpr(*nc.lhs);
        if (a == nullptr) return nullptr;
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
        if (b == nullptr) b = nullp;
        if (nullablePrim) b = coerce(b, typeName(*nc.rhs), inner);
        llvm::BasicBlock* elseEnd = builder.GetInsertBlock();
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
        llvm::PHINode* phi =
            builder.CreatePHI(nullablePrim ? llvmType(inner) : builder.getPtrTy(), 2, "coalesce");
        phi->addIncoming(aVal, thenEnd);
        phi->addIncoming(b, elseEnd);
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
        // A String-typed ternary: an owned producer in one arm (e.g. `cond ? path : path.substring(...)`)
        // is created in that arm's block, so the enclosing statement's freeStringTemps -- which only sees
        // the merge block -- would drop it and leak. Copy each arm to a fresh owned String and free the
        // arm's own producer temp there; the merge phi is then one uniformly-owned temp tracked in endBB.
        const bool ownedStr_ = (rt == "String");
        builder.CreateCondBr(c, thenBB, elseBB);
        builder.SetInsertPoint(thenBB);
        std::size_t tBefore = stringTemps.size();
        llvm::Value* tv = emitExpr(*t.thenExpr);
        if (tv != nullptr) tv = coerce(tv, typeName(*t.thenExpr), rt);
        if (ownedStr_ && tv != nullptr) {
            tv = emitStringCopy(tv);
            releaseArmStringTemps(tBefore);
        }
        llvm::BasicBlock* thenEnd = builder.GetInsertBlock();
        builder.CreateBr(endBB);
        builder.SetInsertPoint(elseBB);
        std::size_t eBefore = stringTemps.size();
        llvm::Value* ev = emitExpr(*t.elseExpr);
        if (ev != nullptr) ev = coerce(ev, typeName(*t.elseExpr), rt);
        if (ownedStr_ && ev != nullptr) {
            ev = emitStringCopy(ev);
            releaseArmStringTemps(eBefore);
        }
        llvm::BasicBlock* elseEnd = builder.GetInsertBlock();
        builder.CreateBr(endBB);
        builder.SetInsertPoint(endBB);
        if (tv == nullptr || ev == nullptr) return tv != nullptr ? tv : ev;
        llvm::PHINode* phi = builder.CreatePHI(rty, 2, "tern");
        phi->addIncoming(tv, thenEnd);
        phi->addIncoming(ev, elseEnd);
        return ownedStr_ ? ownedStr(phi) : static_cast<llvm::Value*>(phi);
    }

    llvm::Value* emitBinary(const ast::BinaryExpr& bin) {
        if (bin.op == "&&" || bin.op == "||") return emitShortCircuit(bin);
        const std::string lt = typeName(*bin.lhs);
        // Pointer arithmetic (spec 27): `p + n` / `p - n` step by whole ELEMENTS. Without this the
        // pointer would be fed to an integer add, which is not even valid IR. The distance between two
        // pointers (`q - p`) is an element count, like C. The analyzer warns when the pointee is a class.
        if ((bin.op == "+" || bin.op == "-") && isRefType(lt)) {
            const std::string rt = typeName(*bin.rhs);
            llvm::Value* base = emitExpr(*bin.lhs);
            llvm::Value* off = emitExpr(*bin.rhs);
            if (base == nullptr || off == nullptr) return nullptr;
            llvm::Type* elem = llvmType(baseType(lt));
            if (isRefType(rt)) {  // q - p: how many elements apart
                if (bin.op != "-") {
                    error("two pointers cannot be added (spec 27)", bin.loc);
                    return nullptr;
                }
                llvm::Value* a = builder.CreatePtrToInt(base, builder.getInt64Ty());
                llvm::Value* b = builder.CreatePtrToInt(off, builder.getInt64Ty());
                llvm::Value* bytes = builder.CreateSub(a, b, "ptr.diff.bytes");
                return builder.CreateSDiv(bytes, sizeOf(elem), "ptr.diff");
            }
            llvm::Value* n = builder.CreateSExtOrTrunc(off, builder.getInt64Ty());
            if (bin.op == "-") n = builder.CreateNeg(n, "ptr.back");
            return builder.CreateGEP(elem, base, {n}, "ptr.off");
        }
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
                // Route through the sret-aware wrapper: an operator returning a value struct is an
                // sret function (extra trailing result-slot argument), so a raw 2-arg call would have
                // the wrong signature and crash. emitMaybeInvoke handles both sret and plain returns.
                return emitMaybeInvoke(fnit->second, {recv, arg});
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
        // String concatenation: + on String/string operands builds a fresh String (spec 4).
        if (op == "+" && (lt == "String" || lt == "string") && (rt == "String" || rt == "string"))
            return ownedStr(emitStringConcat(l, r));
        // String equality (spec 4): ==/!= on String/string operands compares CONTENT (immutable value
        // semantics), lowering to strcmp -- the same runtime String.equals uses. Without this the string
        // operands would fall through to the integer comparison path below, which sign-extends the
        // string pointers to i32 (invalid IR: "SExt only operates on integer").
        if ((op == "==" || op == "!=") && (lt == "String" || lt == "string") &&
            (rt == "String" || rt == "string")) {
            llvm::Value* eq = builder.CreateCall(strEqFn(), {l, r});  // i32: 1 equal, 0 not
            if (op == "==") return eq;
            return builder.CreateZExt(builder.CreateICmpEQ(eq, builder.getInt32(0)),
                                      builder.getInt32Ty());
        }
        // Decimal fixed-point arithmetic (spec 34): i128 mantissa, scale 10^18. Multiply and divide
        // rescale through a 256-bit intermediate so the product does not overflow.
        if (lt == "Decimal" && rt == "Decimal") {
            if (op == "+") return builder.CreateAdd(l, r);
            if (op == "-") return builder.CreateSub(l, r);
            llvm::Type* i256 = builder.getIntNTy(256);
            llvm::Constant* scale256 = llvm::ConstantInt::get(
                context, llvm::APInt(256, "1" + std::string(DECIMAL_SCALE, '0'), 10));
            if (op == "*") {
                llvm::Value* p =
                    builder.CreateMul(builder.CreateSExt(l, i256), builder.CreateSExt(r, i256));
                return builder.CreateTrunc(builder.CreateSDiv(p, scale256), builder.getInt128Ty());
            }
            if (op == "/") {
                llvm::Value* num = builder.CreateMul(builder.CreateSExt(l, i256), scale256);
                return builder.CreateTrunc(builder.CreateSDiv(num, builder.CreateSExt(r, i256)),
                                           builder.getInt128Ty());
            }
            llvm::Value* c = nullptr;
            if (op == "==") c = builder.CreateICmpEQ(l, r);
            else if (op == "!=") c = builder.CreateICmpNE(l, r);
            else if (op == "<") c = builder.CreateICmpSLT(l, r);
            else if (op == ">") c = builder.CreateICmpSGT(l, r);
            else if (op == "<=") c = builder.CreateICmpSLE(l, r);
            else if (op == ">=") c = builder.CreateICmpSGE(l, r);
            if (c != nullptr) return builder.CreateZExt(c, builder.getInt32Ty());
        }
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
            // A class instance is a pointer in codegen, so == / != on class references is identity
            // comparison (the basis of Object.equals). Pointers, refs, null and java-enums too. A
            // nullable primitive is boxed as a pointer (spec 3.7), so it compares as a pointer as well
            // (this is what makes `nullable int x = ...; x == null` work).
            if (t == "null" || (!t.empty() && (t.back() == '*' || t.back() == '&'))) return true;
            if (!t.empty() && t.back() == '?' && isBoxablePrimitive(t.substr(0, t.size() - 1)))
                return true;
            return javaEnums.count(baseType(t)) > 0 || classes.count(baseType(t)) > 0;
        };
        const bool javaEnumCmp = javaEnums.count(baseType(lt)) > 0 || javaEnums.count(baseType(rt)) > 0;
        if (javaEnumCmp && op != "==" && op != "!=") {
            // Order Java-style enums by ordinal (declaration order), matching Java's compareTo. Both
            // sides are the same enum for a well-typed program; recover each value's ordinal from its
            // singleton identity and compare those.
            const std::string en = javaEnums.count(baseType(lt)) > 0 ? baseType(lt) : baseType(rt);
            llvm::Value* oa = emitJavaEnumOrdinal(l, en);
            llvm::Value* ob = emitJavaEnumOrdinal(r, en);
            llvm::Value* cmp = nullptr;
            if (op == "<") cmp = builder.CreateICmpSLT(oa, ob);
            else if (op == ">") cmp = builder.CreateICmpSGT(oa, ob);
            else if (op == "<=") cmp = builder.CreateICmpSLE(oa, ob);
            else if (op == ">=") cmp = builder.CreateICmpSGE(oa, ob);
            if (cmp != nullptr) return builder.CreateZExt(cmp, builder.getInt32Ty());
            error("unsupported comparison '" + op + "' on Java-style enum values", bin.loc);
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
        if (op == "+" || op == "-" || op == "*") {
            // Integer arithmetic wraps by default (modular, zero-overhead -- overflow checking inhibits
            // the recursive-inline and loop optimizers, ~10x on hot arithmetic). Opt into trap-on-overflow
            // per expression with `checked(...)`; unsigned and freestanding always wrap.
            if (checkedArith_ && !uns && !program.isFreestanding) return emitCheckedIntArith(op, l, r);
            if (op == "+") return builder.CreateAdd(l, r);
            if (op == "-") return builder.CreateSub(l, r);
            return builder.CreateMul(l, r);
        }
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

    // The storage slot (address holding the region block pointer) for a region named either by a
    // local or by a `this.field` reference (spec 17: region as a field). Null if unresolved.
    llvm::Value* regionStorageSlot(const std::string& name) {
        const auto dot = name.find('.');
        if (dot == std::string::npos) {
            auto it = locals.find(name);
            return it == locals.end() ? nullptr : it->second.storage;
        }
        // `this.field`: GEP to the region field on the current receiver.
        if (currentThis == nullptr || currentClass.empty()) return nullptr;
        auto cit = classes.find(currentClass);
        if (cit == classes.end()) return nullptr;
        auto fi = cit->second.fieldIndex.find(name.substr(dot + 1));
        if (fi == cit->second.fieldIndex.end()) return nullptr;
        return builder.CreateStructGEP(cit->second.type, currentThis, fi->second, "rgn.field");
    }

    // An owned region init is `itself.allocate(size)` -- a region we own end to end (data at block+24),
    // as opposed to `itself.at(addr, ...)` (external memory) or `itself.atMultiple({...})` (multi-range).
    static bool isOwnedRegionInit(const ast::Expr* e) {
        const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(e);
        return ri != nullptr && ri->atAddress.get() == nullptr && ri->ranges.empty();
    }

    // Mark `name` as an owned local region and (re)zero its register-promotable bump cursor. Called at
    // each acquire of the region's block (eager decl, lazy first-use, reassignment) so the cursor starts
    // at 0 for the fresh block. The alloca is created once (entry block) and reused across re-acquires.
    void setupOwnedRegionCursor(const std::string& name) {
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

    // Allocate an `objType` object from region variable `name`, dispatching on its flavor (spec 17):
    // bump/stack use the inline bump cursor (a region block is [ i64 used | i64 cap | ptr dataBase | data ];
    // 8-aligned bump -- the untouched fast path); pool/fixedslot serve an individual slot from the runtime
    // free-list via __ldp3_region_new so `delete`/`extract` can reclaim it.
    llvm::Value* emitRegionAlloc(const std::string& name, llvm::StructType* objType,
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
            if (it != regionCursorSlot_.end()) cursorSlot = it->second;
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
            if (blk != nullptr) builder.CreateStore(blk, slot);
            if (cursorSlot != nullptr) builder.CreateStore(builder.getInt64(0), cursorSlot);  // fresh block: used = 0
            builder.CreateBr(contBB);
            builder.SetInsertPoint(contBB);
        }
        llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
        // ring: a circular buffer -- the runtime allocates the next slot, evicting (and destructing) the
        // oldest when full. pool/fixedslot serve a reclaimable free-list slot; stack bumps a slot
        // (reclaimed via mark/rollback). All go through the runtime allocator. (After any lazy acquire so
        // the block exists; bump falls through to the inline fast path below.)
        if (isRingFlavor(flavor)) {
            return builder.CreateCall(ringNewFn(), {block, sizeOf(objType)}, "ring.slot");
        }
        // A growable bump region also serves through the runtime allocator (it chains blocks on overflow),
        // so it leaves the inline cursor fast path -- only fixed bump keeps the byte-identical hot path.
        if (usesRuntimeDesc(flavor) || growable) {
            return builder.CreateCall(regionNewFn(), {block, sizeOf(objType)}, "rgn.slot");
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
        llvm::Value* aligned = builder.CreateAnd(builder.CreateAdd(sizeOf(objType), builder.getInt64(7)),
                                                 builder.getInt64(~static_cast<std::uint64_t>(7)));
        builder.CreateStore(builder.CreateAdd(used, aligned),
                            cursorSlot != nullptr ? cursorSlot : block);  // bump
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
                for (const std::string& a : ranges[i].accepts)
                    if (classIsSubtypeOf(className, baseType(a))) { ok = true; break; }
            } else {  // rejects-only (or open): accept unless T is rejected
                ok = true;
                for (const std::string& rj : ranges[i].rejects)
                    if (classIsSubtypeOf(className, baseType(rj))) { ok = false; break; }
            }
            if (ok) { idx = static_cast<int>(i); break; }
        }
        if (idx < 0) {
            error("no range in this region accepts a '" + className + "' (spec 17.4)", loc);
            return nullptr;
        }
        llvm::Value* addr = emitExpr(*ranges[idx].address);
        if (addr == nullptr) return nullptr;
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
                                    const std::string& flavor = "", bool growable = false) {
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
        // A flavored (pool/fixedslot/stack/ring) OR growable region: a larger block whose Ldp3RegionDesc
        // header (LDP3_REGION_HDR bytes) carries the free-lists / stack registry / grow chain; the runtime
        // init lays it out. Objects are then served by __ldp3_region_new/ring_new. `at address` cannot grow.
        if ((usesRuntimeDesc(flavor) || growable) && atAddr == nullptr) {
            llvm::Value* block = builder.CreateCall(
                regionAcquireFn(), {builder.CreateAdd(builder.getInt64(kRegionHdr), nbytes)}, "region");
            builder.CreateCall(regionInitFn(),
                               {block, builder.getInt64(flavorCode(flavor)), nbytes,
                                builder.getInt64(growable ? 1 : 0)});
            return block;
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
                regionAcquireFn(), {builder.CreateAdd(builder.getInt64(24), nbytes)}, "region");
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
        // Value Result/Option (spec 21, value form): Ok/Err/Some/None with location "value" build a
        // { i32 tag, i64 payload } directly -- no allocation, no class, no delete. tag 0 = Ok/Some,
        // 1 = Err/None. The payload is packed from the single arg (None carries none).
        if (nw.location == "value") {
            const int tag = (nw.className == "Ok" || nw.className == "Some") ? 0 : 1;
            llvm::Value* payload = builder.getInt64(0);
            if (!nw.args.empty()) {
                llvm::Value* a = emitExpr(*nw.args[0]);
                if (a == nullptr) return nullptr;
                // The value form packs the payload into 64 bits. Name-based detection keeps Decimal/tuple/
                // pointer payloads boxed upstream, but a value-`struct` payload can't be told apart by name,
                // so guard it here with a clear error rather than a silent truncation or a crash.
                if (a->getType()->isAggregateType() ||
                    (a->getType()->isIntegerTy() && a->getType()->getIntegerBitWidth() > 64)) {
                    error("a value Result/Option of this payload type is not supported yet; use the boxed "
                          "form (write the type with a '*')",
                          nw.loc);
                    return nullptr;
                }
                payload = variantEncode(a);
            }
            llvm::Value* agg = llvm::UndefValue::get(variantStructType());
            agg = builder.CreateInsertValue(agg, builder.getInt32(tag), {0u}, "var.tag");
            agg = builder.CreateInsertValue(agg, payload, {1u}, "var.val");
            return agg;
        }
        const std::string cn = ast::mangleGeneric(nw.className, nw.typeArgs);  // Box<int> -> Box$int
        auto cit = classes.find(cn);
        if (cit == classes.end()) {
            error("unknown class '" + cn + "'", nw.loc);
            return nullptr;
        }
        // Opaque cross-bundle creation: an imported class's full layout is not known here, so the
        // bundle's exported __new mallocs the real size and runs the constructor (spec: F9 opaque).
        if (cit->second.imported) {
            llvm::Function* nf = functions.count(cn + ".__new") ? functions[cn + ".__new"] : nullptr;
            if (nf == nullptr) {
                error("cannot construct imported class '" + cn + "' (no exported constructor)", nw.loc);
                return nullptr;
            }
            if (nw.location == "stack") {
                error("an imported class is heap-only across a bundle boundary; use 'on heap'", nw.loc);
                return nullptr;
            }
            std::vector<llvm::Value*> args;
            for (std::size_t i = 0; i < nw.args.size(); ++i) {
                llvm::Value* v = emitExpr(*nw.args[i]);
                if (v == nullptr) return nullptr;
                if (i < nf->arg_size()) v = coerceToType(v, nf->getArg(i)->getType());
                args.push_back(v);
            }
            return builder.CreateCall(nf, args, cn + ".new");
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
            objPtr = multiRegionRanges_.count(nw.region) > 0
                         ? emitMultiRegionAlloc(nw.region, cn, cit->second.type, nw.loc)
                         : emitRegionAlloc(nw.region, cit->second.type, nw.loc);
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
        if (cit->second.persistPtrIdx != 0) {
            if (pendingPersistIndex != nullptr && !pendingPersistKey.empty()) {
                // Index-keyed reattach (spec 18.5): `arr[i] = new T()`. A runtime registry keyed by
                // (array identity, index) returns the same block for the same slot across a delete, so
                // the object's persistent fields survive delete+recreate at that index.
                llvm::Value* keyStr = createGlobalStringPtr(builder,pendingPersistKey, "pkey");
                llvm::Value* idx64 =
                    builder.CreateSExtOrTrunc(pendingPersistIndex, builder.getInt64Ty(), "pidx");
                persistBlockRef = builder.CreateCall(
                    persistSlotFn(), {keyStr, idx64, sizeOf(cit->second.persistBlock)},
                    "__persist.slot");
            } else if (!pendingPersistKey.empty()) {
                persistBlockRef = getPersistBlock(pendingPersistKey, cit->second.persistBlock);
            } else {
                // No name binding (e.g. a temporary): give the object its own zeroed persistent block
                // so its persistent fields are usable instead of leaving the __persist pointer wild (a
                // segfault on first access). No reattach identity for a bare temporary.
                llvm::Value* sz = sizeOf(cit->second.persistBlock);
                persistBlockRef = builder.CreateCall(mallocFn(), {sz}, "__persist.anon");
                builder.CreateCall(memsetFn(), {persistBlockRef, builder.getInt32(0), sz});
            }
            llvm::Value* slot = builder.CreateStructGEP(cit->second.type, objPtr,
                                                        cit->second.persistPtrIdx, "__persist");
            builder.CreateStore(persistBlockRef, slot);
            pendingPersistKey.clear();
            pendingPersistIndex = nullptr;
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
            }
            std::vector<std::pair<std::size_t, std::string>> freeAfter;  // owned `new` ctor args
            if (!partial) {
                for (std::size_t i = 0; i < nw.args.size(); ++i) {
                    llvm::Value* v = emitExpr(*nw.args[i]);
                    if (v == nullptr) return nullptr;
                    if (i + 1 < fnit->second->arg_size())  // coerce to the ctor's param width/type
                        v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                    args.push_back(v);
                    if (ctor != nullptr && i < ctor->params.size())
                        if (std::string acn = ownedHeapNewArg(*nw.args[i],
                                                              typeRefName(ctor->params[i].type));
                            !acn.empty())
                            freeAfter.emplace_back(i + 1, acn);
                }
            }
            emitMaybeInvoke(fnit->second, args);
            for (const auto& [idx, acn] : freeAfter) emitDeleteObject(args[idx], acn);
        }
        // A stack region records each constructed object that has a destructor, so `rollback`/`release`
        // can run those destructors newest-first (the runtime registry, not scopeObjects, owns them).
        if (!nw.region.empty() && cit->second.hasDestructor &&
            isStackFlavor(flavorOfRegion(nw.region))) {
            llvm::Value* block =
                builder.CreateLoad(builder.getPtrTy(), regionStorageSlot(nw.region), "region");
            builder.CreateCall(regionTrackFn(), {block, objPtr, functions[cn + ".~" + cn]});
        }
        return objPtr;
    }

    // A java-style enum constant: materializes `new EnumName(args)` on the heap.
    // Not yet a true singleton -- each reference rebuilds it; identity is a later
    // refinement (would need a global + eager init).
    // A Java-style enum constant is a singleton (spec 12.2): the instance is built once into a
    // private global on first use and reused after, so `==`/`!=` are correct identity comparisons.
    // The private global caching a Java-style enum constant's singleton (null until first use).
    // Shared by constant materialization and ordinal recovery so both name the same slot.
    llvm::GlobalVariable* enumSingletonGlobal(const std::string& enumName, const std::string& constName) {
        const std::string gname = enumName + "." + constName + ".__inst";
        if (staticGlobals.count(gname) == 0) {
            staticGlobals[gname] = new llvm::GlobalVariable(
                module, builder.getPtrTy(), /*isConstant=*/false,
                llvm::GlobalValue::PrivateLinkage,
                llvm::ConstantPointerNull::get(builder.getPtrTy()), gname);
        }
        return staticGlobals[gname];
    }

    // The ordinal (declaration index) of a Java-style enum value at runtime. Each constant is a
    // cached singleton, so identity against each singleton recovers the index -- the basis for
    // ordering comparisons (spec 12.2: enum order is declaration order, like Java's compareTo).
    // Yields -1 for a value that matches no constant (e.g. null), which orders below every constant.
    llvm::Value* emitJavaEnumOrdinal(llvm::Value* v, const std::string& enumName) {
        llvm::Value* ord = builder.getInt32(-1);
        auto eit = enums.find(enumName);
        if (eit == enums.end()) return ord;
        for (std::size_t i = 0; i < eit->second.size(); ++i) {
            llvm::GlobalVariable* g = enumSingletonGlobal(enumName, eit->second[i]);
            llvm::Value* cur = builder.CreateLoad(builder.getPtrTy(), g, "enum.ord.cur");
            llvm::Value* eq = builder.CreateICmpEQ(v, cur);
            ord = builder.CreateSelect(eq, builder.getInt32(static_cast<int>(i)), ord, "enum.ord");
        }
        return ord;
    }

    llvm::Value* emitEnumConstant(const ast::EnumDecl& en, const std::string& constName) {
        auto pos = std::find(en.constants.begin(), en.constants.end(), constName);
        if (pos == en.constants.end()) {
            error("enum '" + en.name + "' has no constant '" + constName + "'", en.loc);
            return nullptr;
        }
        const std::size_t idx = static_cast<std::size_t>(pos - en.constants.begin());
        auto cit = classes.find(en.name);
        if (cit == classes.end()) return nullptr;
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
    llvm::Value* emitInterp(const ast::InterpStringExpr& is, bool addNewline, bool asString = false) {
        std::string fmt;
        std::vector<llvm::Value*> values;
        for (std::size_t i = 0; i < is.exprs.size(); ++i) {
            fmt += resolveEscapes(is.literals[i]);
            const std::string et = typeName(*is.exprs[i]);
            llvm::Value* v = emitExpr(*is.exprs[i]);
            if (v == nullptr) return nullptr;
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
                        if (v->getType()->isIntegerTy() &&
                            v->getType()->getIntegerBitWidth() < 32)
                            v = builder.CreateSExt(v, builder.getInt32Ty());
                    }
                    values.push_back(v);
                    continue;
                }
            }
            if (isFloatType(et)) {
                fmt += "%g";
                v = coerce(v, et, "double");  // f64 for the %g vararg
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
            for (llvm::Value* v : values) measure.push_back(v);
            llvm::Value* len = builder.CreateSExt(builder.CreateCall(sn, measure, "ilen"),
                                                  builder.getInt64Ty());
            llvm::Value* cap = builder.CreateAdd(len, builder.getInt64(1));
            llvm::Value* buf = builder.CreateCall(mallocFn(), {cap}, "ibuf");
            std::vector<llvm::Value*> format = {buf, cap, fmtG};
            for (llvm::Value* v : values) format.push_back(v);
            builder.CreateCall(sn, format);
            return ownedStr(emitStringFromParts(len, buf));
        }
        if (addNewline) fmt += "\n";
        std::vector<llvm::Value*> args;
        args.push_back(createGlobalStringPtr(builder,fmt, ".str"));
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
    // Calls a funcptr<Ret, Args...> value -- a bare C function pointer (dynamic FFI, e.g. a
    // wglGetProcAddress result) -- with the plain C ABI: no closure environment, args passed directly.
    llvm::Value* emitFuncptrCall(const std::string& ft, llvm::Value* fnPtr,
                                 const std::vector<ast::ExprPtr>& callArgs) {
        const std::string inner = ft.substr(8, ft.size() - 9);  // strip "funcptr<" ... ">"
        std::vector<std::string> parts;
        int depth = 0;
        for (std::size_t i = 0, s = 0; i <= inner.size(); i++) {
            if (i == inner.size() || (inner[i] == ',' && depth == 0)) {
                parts.push_back(inner.substr(s, i - s));
                s = i + 1;
            } else if (inner[i] == '<' || inner[i] == '(') {
                depth++;
            } else if (inner[i] == '>' || inner[i] == ')') {
                depth--;
            }
        }
        std::vector<llvm::Type*> pts;
        for (std::size_t i = 1; i < parts.size(); i++) pts.push_back(llvmType(parts[i]));
        llvm::Type* ret = parts.empty() ? builder.getVoidTy() : llvmType(parts[0]);
        llvm::FunctionType* fty = llvm::FunctionType::get(ret, pts, false);
        std::vector<llvm::Value*> args;
        for (std::size_t i = 0; i < callArgs.size(); ++i) {
            llvm::Value* v = emitExpr(*callArgs[i]);
            if (v == nullptr) return nullptr;
            const std::string pt = (i + 1 < parts.size()) ? parts[i + 1] : std::string();
            if (pt == "string" || pt == "String") {
                v = stringData(v);  // FFI: a String maps to its NUL-terminated C char* data (spec 26)
            } else if (i < pts.size()) {
                v = coerceToType(v, pts[i]);
            }
            args.push_back(v);
        }
        return builder.CreateCall(fty, fnPtr, args);  // foreign C call; does not throw an LDP3 exception
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

    // Sum the lanes of a <w x float> vector into a scalar float (used by dot/length).
    llvm::Value* horizontalAddVec(llvm::Value* v, int w) {
        llvm::Value* sum = builder.CreateExtractElement(v, builder.getInt32(0));
        for (int i = 1; i < w; i++)
            sum = builder.CreateFAdd(sum, builder.CreateExtractElement(v, builder.getInt32(i)));
        return sum;
    }
    // The 3D cross product of two <3 x float> vectors.
    llvm::Value* emitCross3(llvm::Value* a, llvm::Value* b) {
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

    // --- Function specialization over no-capture lambda arguments (see boundLambdas_) ---
    // If argExpr is a known constant lambda -- a no-capture lambda literal (its emitted value is a
    // constant global {code, null} closure) or a bound parameter forwarded transitively -- return its
    // underlying function; else null.
    llvm::Function* knownLambdaFor(const ast::Expr& argExpr, llvm::Value* argValue) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&argExpr))
            if (auto it = boundLambdas_.find(id->name); it != boundLambdas_.end()) return it->second;
        if (auto* gv = llvm::dyn_cast_or_null<llvm::GlobalVariable>(argValue);
            gv != nullptr && gv->isConstant() && gv->hasInitializer())
            if (auto* init = llvm::dyn_cast<llvm::ConstantArray>(gv->getInitializer());
                init != nullptr && init->getNumOperands() >= 1)
                return llvm::dyn_cast<llvm::Function>(init->getOperand(0));
        return nullptr;
    }
    // Get (or schedule) a specialized copy of `orig` in which the given function<> parameters are the
    // given lambdas. Same signature (the closures are still passed, just bypassed for the call); the body
    // is generated later from the worklist with boundLambdas_ set, so its calls to those params are direct.
    llvm::Function* specializeMethod(const ast::MethodDecl* decl, const std::string& definingClass,
                                     const std::string& method, llvm::Function* orig,
                                     const std::map<int, llvm::Function*>& specParams) {
        std::string key = definingClass + "." + method;
        for (const auto& [idx, fn] : specParams)
            key += "#" + std::to_string(idx) + "=" + fn->getName().str();
        if (auto it = specCache_.find(key); it != specCache_.end()) return it->second;
        auto* spec = llvm::Function::Create(orig->getFunctionType(), llvm::Function::InternalLinkage,
                                            key + "$fs", module);
        specCache_[key] = spec;
        Specialization req;
        req.fn = spec;
        req.decl = decl;
        req.owner = definingClass;
        req.returnType = typeRefName(decl->returnType);
        for (const auto& [idx, fn] : specParams)
            if (idx >= 0 && idx < static_cast<int>(decl->params.size()))
                req.bound[decl->params[idx].name] = fn;
        specWorklist_.push_back(std::move(req));
        return spec;
    }
    // Emit the deferred specialized bodies. Each may schedule more (transitive specialization); the cache
    // terminates the recursion. Run after the normal function pass, before dead-code stripping.
    void emitSpecializations() {
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

    // A mat4 is a <16 x float> in row-major order: element (row, col) lives at index row*4 + col.
    llvm::Value* mat4Zero() { return llvm::ConstantAggregateZero::get(llvmType("mat4")); }
    llvm::Value* mat4Identity() {
        llvm::Value* m = mat4Zero();
        for (int i = 0; i < 4; i++)  // 1.0 on the diagonal (indices 0, 5, 10, 15)
            m = builder.CreateInsertElement(m, llvm::ConstantFP::get(builder.getFloatTy(), 1.0),
                                            builder.getInt32(i * 5));
        return m;
    }
    llvm::Value* mat4Mul(llvm::Value* a, llvm::Value* b) {
        auto el = [&](llvm::Value* m, int i) { return builder.CreateExtractElement(m, builder.getInt32(i)); };
        llvm::Value* r = mat4Zero();
        for (int i = 0; i < 4; i++)
            for (int j = 0; j < 4; j++) {
                llvm::Value* sum = llvm::ConstantFP::get(builder.getFloatTy(), 0.0);
                for (int k = 0; k < 4; k++)
                    sum = builder.CreateFAdd(sum, builder.CreateFMul(el(a, i * 4 + k), el(b, k * 4 + j)));
                r = builder.CreateInsertElement(r, sum, builder.getInt32(i * 4 + j));
            }
        return r;
    }
    llvm::Value* mat4Transform(llvm::Value* m, llvm::Value* v) {  // m * v -> vec4
        auto me = [&](int i) { return builder.CreateExtractElement(m, builder.getInt32(i)); };
        auto ve = [&](int i) { return builder.CreateExtractElement(v, builder.getInt32(i)); };
        llvm::Value* r = llvm::ConstantAggregateZero::get(llvmType("vec4"));
        for (int i = 0; i < 4; i++) {
            llvm::Value* sum = llvm::ConstantFP::get(builder.getFloatTy(), 0.0);
            for (int k = 0; k < 4; k++)
                sum = builder.CreateFAdd(sum, builder.CreateFMul(me(i * 4 + k), ve(k)));
            r = builder.CreateInsertElement(r, sum, builder.getInt32(i));
        }
        return r;
    }

    llvm::Value* emitCall(const ast::CallExpr& call) {
        if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
            cm != nullptr && cm->safe && &call != safeGuardNode_) {  // obj?.method(...) (spec 3.7)
            return emitSafeNav(call, *cm->object);
        }
        const std::string name = flattenCallee(*call.callee);
        // checked(expr) (spec 3.6): evaluate expr with signed +/-/* trapping on overflow instead of
        // wrapping. Opt-in, since the default is the zero-overhead wrap.
        if (name == "checked" && call.args.size() == 1) {
            const bool saved = checkedArith_;
            checkedArith_ = true;
            llvm::Value* v = emitExpr(*call.args[0]);
            checkedArith_ = saved;
            return v;
        }
        // mat4: a.multiply(b) -> mat4, a.transform(v) -> vec4, plus the mat4.identity() factory.
        if (const auto* mm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
            mm != nullptr && typeName(*mm->object) == "mat4") {
            if (mm->member == "multiply" && call.args.size() == 1) {
                llvm::Value* a = emitExpr(*mm->object);
                llvm::Value* b = emitExpr(*call.args[0]);
                return (a == nullptr || b == nullptr) ? nullptr : mat4Mul(a, b);
            }
            if (mm->member == "transform" && call.args.size() == 1) {
                llvm::Value* a = emitExpr(*mm->object);
                llvm::Value* v = emitExpr(*call.args[0]);
                return (a == nullptr || v == nullptr) ? nullptr : mat4Transform(a, v);
            }
        }
        if (name == "mat4.identity" && call.args.empty()) return mat4Identity();
        // Decimal.toString(): format the i128 fixed-point mantissa (scale 10^18) as a decimal String.
        if (const auto* dm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
            dm != nullptr && dm->member == "toString" && call.args.empty() &&
            typeName(*dm->object) == "Decimal") {
            llvm::Value* v = emitExpr(*dm->object);
            return v == nullptr ? nullptr : emitDecimalToString(v);
        }
        // SIMD vector methods (GLSL-style): v.dot(o)/v.length() -> float, v.normalize() -> vecN,
        // v.cross(o) -> vec3. The element-wise math lowers to plain vector instructions.
        if (const auto* vm = dynamic_cast<const ast::MemberExpr*>(call.callee.get())) {
            const int vw = vecWidth(typeName(*vm->object));
            if (vw > 0) {
                const std::string& m = vm->member;
                if (m == "dot" && call.args.size() == 1) {
                    llvm::Value* a = emitExpr(*vm->object);
                    llvm::Value* b = emitExpr(*call.args[0]);
                    if (a == nullptr || b == nullptr) return nullptr;
                    return horizontalAddVec(builder.CreateFMul(a, b), vw);
                }
                if ((m == "length" || m == "normalize") && call.args.empty()) {
                    llvm::Value* a = emitExpr(*vm->object);
                    if (a == nullptr) return nullptr;
                    llvm::Value* len = builder.CreateUnaryIntrinsic(
                        llvm::Intrinsic::sqrt, horizontalAddVec(builder.CreateFMul(a, a), vw));
                    if (m == "length") return len;
                    return builder.CreateFDiv(a, builder.CreateVectorSplat(vw, len));  // normalize
                }
                if (m == "cross" && call.args.size() == 1 && vw == 3) {
                    llvm::Value* a = emitExpr(*vm->object);
                    llvm::Value* b = emitExpr(*call.args[0]);
                    if (a == nullptr || b == nullptr) return nullptr;
                    return emitCross3(a, b);
                }
            }
        }
        // Type.sizeof() (spec issue #7): the member form, equivalent to sizeof(Type) for a class type.
        if (const auto* sm = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
            sm != nullptr && sm->member == "sizeof" && call.args.empty()) {
            const std::string tn = flattenCallee(*sm->object);
            if (auto cit = classes.find(clsKey(tn)); cit != classes.end())
                return builder.CreateTrunc(sizeOf(cit->second.type), builder.getInt32Ty());
        }
        // sizeof(Type) / sizeof(expr) (spec, issue #7): the byte size of a type or an expression's
        // type, as an int. A bare class name is a type; otherwise the argument is an expression.
        if (name == "sizeof" && call.args.size() == 1) {
            const std::string bare = flattenCallee(*call.args[0]);
            const std::string tn =
                classes.count(baseType(bare)) > 0 ? bare : typeName(*call.args[0]);
            auto cit = classes.find(clsKey(tn));
            llvm::Value* sz = cit != classes.end() ? sizeOf(cit->second.type) : sizeOf(llvmType(tn));
            return builder.CreateTrunc(sz, builder.getInt32Ty());
        }
        // External C function call (spec 26): a bare call to an `extern` declaration.
        if (auto er = externReturnType.find(name); er != externReturnType.end()) {
            llvm::Function* fn = functions[name];
            std::vector<llvm::Value*> args;
            for (std::size_t i = 0; i < call.args.size(); ++i) {
                // A lambda argument to a C function is a callback: pass a raw C function pointer.
                if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(call.args[i].get())) {
                    llvm::Function* cb = emitCallbackFn(*lam);
                    if (cb == nullptr) return nullptr;
                    args.push_back(cb);
                    continue;
                }
                const std::string at = typeName(*call.args[i]);
                // A by-value struct argument travels in a register: load its bytes as the ABI int.
                if (llvm::Type* reg = ffiStructRegType(at)) {
                    llvm::Value* ptr = emitExpr(*call.args[i]);
                    if (ptr == nullptr) return nullptr;
                    args.push_back(builder.CreateLoad(reg, ptr, "ffi.byval"));
                    continue;
                }
                // A String maps to a C char*: pass the NUL-terminated data pointer (spec 26).
                if (at == "String" || at == "string") {
                    llvm::Value* sv = emitExpr(*call.args[i]);
                    if (sv == nullptr) return nullptr;
                    args.push_back(stringData(sv));
                    continue;
                }
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) return nullptr;
                if (i < fn->getFunctionType()->getNumParams())
                    v = coerceToType(v, fn->getFunctionType()->getParamType(i));
                args.push_back(v);
            }
            llvm::Value* r = builder.CreateCall(fn, args);
            // A by-value struct return arrives in a register: store it into a fresh struct object.
            if (llvm::Type* rreg = ffiStructRegType(er->second)) {
                auto cit = classes.find(clsKey(er->second));
                llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "ffi.ret");
                builder.CreateStore(r, obj);
                (void)rreg;
                return obj;
            }
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
        // mat4 construction: mat4(m0, ..., m15) -> a <16 x float> in row-major order.
        if (name == "mat4" && call.args.size() == 16) {
            llvm::Value* m = mat4Zero();
            for (int i = 0; i < 16; i++) {
                llvm::Value* c = emitExpr(*call.args[i]);
                if (c == nullptr) return nullptr;
                m = builder.CreateInsertElement(m, coerceToType(c, builder.getFloatTy()), builder.getInt32(i));
            }
            return m;
        }
        // Calling a funcptr<> value (a bare C function pointer): plain C indirect call, no environment.
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(call.callee.get())) {
            auto lit = locals.find(id->name);
            if (lit != locals.end() && lit->second.type.rfind("funcptr<", 0) == 0)
                return emitFuncptrCall(lit->second.type,
                                       builder.CreateLoad(builder.getPtrTy(), lit->second.storage, id->name),
                                       call.args);
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get())) {
            const std::string ft = typeName(*mem);
            if (ft.rfind("funcptr<", 0) == 0) return emitFuncptrCall(ft, emitExpr(*mem), call.args);
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
                // In a specialized copy this param is a known lambda: call it directly so LLVM inlines it.
                llvm::Value* fnPtr;
                if (auto bit = boundLambdas_.find(id->name); bit != boundLambdas_.end())
                    fnPtr = bit->second;
                else
                    fnPtr = builder.CreateLoad(builder.getPtrTy(), closPtr, "code");
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
        // runtime CreateThread/WaitForSingleObject (runtime/ldp3_rt.cpp).
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
        // Memory API (spec 17.8): low-level address-based access. `address` is an i64. Accept both the
        // qualified System.Memory.X and the short Memory.X (the semantic phase enforces the import).
        const std::string memName =
            (name.rfind("System.Memory.", 0) == 0) ? "Memory." + name.substr(14) : name;
        if (memName == "Memory.alloc") {
            llvm::Value* n = emitExpr(*call.args[0]);
            if (n == nullptr) return nullptr;
            llvm::Value* p = builder.CreateCall(
                mallocFn(), {builder.CreateIntCast(n, builder.getInt64Ty(), false)}, "mem.alloc");
            return builder.CreatePtrToInt(p, builder.getInt64Ty());
        }
        if (memName == "Memory.free") {
            llvm::Value* a = emitExpr(*call.args[0]);
            if (a == nullptr) return nullptr;
            builder.CreateCall(freeFn(), {builder.CreateIntToPtr(a, builder.getPtrTy())});
            return nullptr;
        }
        if (memName == "Memory.getMemory") {
            llvm::Value* p = emitLValue(*call.args[0]);  // the target's storage address
            if (p == nullptr) return nullptr;
            return builder.CreatePtrToInt(p, builder.getInt64Ty());
        }
        if (memName == "Memory.read") {
            llvm::Value* a = emitExpr(*call.args[0]);
            if (a == nullptr) return nullptr;
            llvm::Type* t = llvmType(call.typeArgs.empty() ? "int" : call.typeArgs[0]);
            return builder.CreateLoad(t, builder.CreateIntToPtr(a, builder.getPtrTy()), "mem.read");
        }
        if (memName == "Memory.write") {
            llvm::Value* a = emitExpr(*call.args[0]);
            llvm::Value* v = emitExpr(*call.args[1]);
            if (a == nullptr || v == nullptr) return nullptr;
            // Store as the declared <T>, not as the value's own type: Memory.write<float>(addr, 1.0)
            // must write 4 bytes, coercing the double literal down -- otherwise it writes 8 and runs
            // past the end of the buffer (heap corruption). Mirrors Memory.read<T>.
            llvm::Type* t = llvmType(call.typeArgs.empty() ? "int" : call.typeArgs[0]);
            v = coerceToType(v, t);
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
        // Bits: reinterpret a double's IEEE-754 bits as a long and back (no conversion, no rounding).
        if (name == "Bits.doubleToLong" || name == "Bits.longToDouble") {
            llvm::Value* v = emitExpr(*call.args[0]);
            if (v == nullptr) return nullptr;
            return name == "Bits.doubleToLong"
                       ? builder.CreateBitCast(v, builder.getInt64Ty(), "bits.d2l")
                       : builder.CreateBitCast(fitInt(v, 64), builder.getDoubleTy(), "bits.l2d");
        }
        // Ipc (spec 2.8): the cross-program transport. listen/accept/connect deal in program NAMES;
        // send/recv deal in whole length-prefixed frames, so the LDP3 side never reassembles a stream.
        if (name.rfind("Ipc.", 0) == 0) {
            const std::string fn = name.substr(4);
            llvm::Type* p = builder.getPtrTy();
            llvm::Type* i64 = builder.getInt64Ty();
            if (fn == "listen" || fn == "connect") {
                llvm::Value* nm = emitExpr(*call.args[0]);
                if (nm == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p}, false);
                return builder.CreateCall(
                    module.getOrInsertFunction(fn == "listen" ? "__ldp3_ipc_listen" : "__ldp3_ipc_connect",
                                               ft),
                    {stringData(nm)});
            }
            if (fn == "accept") {
                llvm::Value* srv = emitExpr(*call.args[0]);
                if (srv == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_ipc_accept", ft),
                                          {fitInt(srv, 64)});
            }
            if (fn == "send") {
                llvm::Value* conn = emitExpr(*call.args[0]);
                llvm::Value* data = emitExpr(*call.args[1]);
                if (conn == nullptr || data == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_ipc_send", ft),
                                          {fitInt(conn, 64), stringData(data), stringLen(data)});
            }
            if (fn == "recv") {
                llvm::Value* conn = emitExpr(*call.args[0]);
                if (conn == nullptr) return nullptr;
                llvm::Value* lenSlot = createEntryAlloca("ipc.len", i64);
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {i64, p}, false);
                llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction("__ldp3_ipc_recv", ft),
                                                      {fitInt(conn, 64), lenSlot});
                llvm::Value* len = builder.CreateLoad(i64, lenSlot, "ipc.n");
                return ownedStr(emitStringFromParts(len, buf));
            }
            if (fn == "close") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_ipc_close", ft), {fitInt(h, 64)});
                return nullptr;
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
                return ownedStr(emitStringFromParts(len, buf));
            }
            if (fn == "close") {
                llvm::Value* sock = emitExpr(*call.args[0]);
                if (sock == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_close", ft), {fitInt(sock, 64)});
                return nullptr;
            }
            if (fn == "listen") {  // (port) -> listening socket
                llvm::Value* port = emitExpr(*call.args[0]);
                if (port == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {builder.getInt32Ty()}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_listen", ft),
                                          {fitInt(port, 32)});
            }
            if (fn == "accept") {  // (server) -> connection socket
                llvm::Value* server = emitExpr(*call.args[0]);
                if (server == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_tcp_accept", ft),
                                          {fitInt(server, 64)});
            }
            if (fn == "udpOpen") {  // (port) -> UDP socket (port 0 = ephemeral)
                llvm::Value* port = emitExpr(*call.args[0]);
                if (port == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {builder.getInt32Ty()}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_udp_open", ft),
                                          {fitInt(port, 32)});
            }
            if (fn == "udpSend") {  // (sock, host, port, data) -> bytes sent
                llvm::Value* sock = emitExpr(*call.args[0]);
                llvm::Value* host = emitExpr(*call.args[1]);
                llvm::Value* port = emitExpr(*call.args[2]);
                llvm::Value* data = emitExpr(*call.args[3]);
                if (sock == nullptr || host == nullptr || port == nullptr || data == nullptr) return nullptr;
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(i64, {i64, p, builder.getInt32Ty(), p, i64}, false);
                return builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_udp_sendto", ft),
                    {fitInt(sock, 64), stringData(host), fitInt(port, 32), stringData(data), stringLen(data)});
            }
            if (fn == "udpRecv") {  // (sock, max) -> datagram payload
                llvm::Value* sock = emitExpr(*call.args[0]);
                llvm::Value* max = emitExpr(*call.args[1]);
                if (sock == nullptr || max == nullptr) return nullptr;
                llvm::Value* cap = fitInt(max, 64);
                llvm::Value* buf = builder.CreateCall(
                    mallocFn(), {builder.CreateAdd(cap, builder.getInt64(1))}, "urc.buf");
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
                llvm::Value* n = builder.CreateCall(module.getOrInsertFunction("__ldp3_udp_recvfrom", ft),
                                                    {fitInt(sock, 64), buf, cap});
                llvm::Value* len = builder.CreateSelect(
                    builder.CreateICmpSLT(n, builder.getInt64(0)), builder.getInt64(0), n);
                builder.CreateStore(builder.getInt8(0),
                                    builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
                return ownedStr(emitStringFromParts(len, buf));
            }
            if (fn == "udpPeerHost") {  // () -> last datagram's sender IP
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {}, false);
                llvm::Value* cstr =
                    builder.CreateCall(module.getOrInsertFunction("__ldp3_udp_peer_host", ft), {});
                llvm::FunctionCallee strlenFn =
                    module.getOrInsertFunction("strlen", llvm::FunctionType::get(i64, {p}, false));
                return emitStringFromParts(builder.CreateCall(strlenFn, {cstr}, "ph.len"), cstr);
            }
            if (fn == "udpPeerPort") {  // () -> last datagram's sender port
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_udp_peer_port", ft), {});
            }
            if (fn == "udpClose") {
                llvm::Value* sock = emitExpr(*call.args[0]);
                if (sock == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_udp_close", ft), {fitInt(sock, 64)});
                return nullptr;
            }
        }
        // Process (spec 34): Process.run(cmd) runs the command through the shell, captures its stdout
        // and exit code, and returns a ProcessResult built from them.
        if (name == "Process.run") {
            llvm::Value* cmd = emitExpr(*call.args[0]);
            if (cmd == nullptr) return nullptr;
            llvm::Type* p = builder.getPtrTy();
            llvm::Value* lenSlot = createEntryAlloca("pr.len", builder.getInt64Ty());
            llvm::Value* exitSlot = createEntryAlloca("pr.exit", builder.getInt32Ty());
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p, p}, false);
            llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction("__ldp3_process_run", ft),
                                                  {stringData(cmd), lenSlot, exitSlot});
            llvm::Value* output = emitStringFromParts(
                builder.CreateLoad(builder.getInt64Ty(), lenSlot, "pr.n"), buf);
            llvm::Value* code = builder.CreateLoad(builder.getInt32Ty(), exitSlot, "pr.rc");
            auto cit = classes.find("ProcessResult");
            if (cit == classes.end()) { error("ProcessResult is unavailable", call.loc); return nullptr; }
            llvm::Function* ctorFn = functions["ProcessResult.ProcessResult"];
            llvm::Value* obj = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "procres");
            builder.CreateCall(ctorFn, {obj, coerceToType(output, ctorFn->getArg(1)->getType()),
                                        coerceToType(code, ctorFn->getArg(2)->getType())});
            return obj;
        }
        // Persistent subprocess (debugger/LSP): low-level builtins behind the System.OS.Subprocess class.
        // The handle is a long (the runtime's heap pointer as i64). See runtime/ldp3_rt.cpp __ldp3_subproc_*.
        if (name.rfind("Subproc.", 0) == 0) {
            const std::string fn = name.substr(8);
            llvm::Type* p = builder.getPtrTy();
            llvm::Type* i64 = builder.getInt64Ty();
            llvm::Type* i32 = builder.getInt32Ty();
            if (fn == "spawn" || fn == "spawnCombined" || fn == "spawnVisible") {
                llvm::Value* cmd = emitExpr(*call.args[0]);
                if (cmd == nullptr) return nullptr;
                // spawnCombined: the child's stderr shares its stdout pipe, so one read() sees everything
                // it printed -- what a caller wants from a compiler, and what would corrupt a DAP stream.
                // spawnVisible: give the child its own console window (an interactive tool the user should
                // see); spawn/spawnCombined are windowless (a background tool piped to us).
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, i64, i64}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_subproc_spawn_ex", ft),
                                          {stringData(cmd),
                                           llvm::ConstantInt::get(i64, fn == "spawnCombined" ? 1 : 0),
                                           llvm::ConstantInt::get(i64, fn == "spawnVisible" ? 1 : 0)});
            }
            if (fn == "writeStr") {
                llvm::Value* h = emitExpr(*call.args[0]);
                llvm::Value* data = emitExpr(*call.args[1]);
                if (h == nullptr || data == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
                llvm::Value* n = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_subproc_write", ft),
                    {fitInt(h, 64), stringData(data), stringLen(data)});
                return builder.CreateTrunc(n, i32);
            }
            if (fn == "readChunk") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                llvm::Value* lenSlot = createEntryAlloca("sp.len", i64);
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {i64, p}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_subproc_read", ft), {fitInt(h, 64), lenSlot});
                return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot, "sp.n"), buf));
            }
            if (fn == "isAlive" || fn == "canRead") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                const char* sym =
                    fn == "canRead" ? "__ldp3_subproc_can_read" : "__ldp3_subproc_alive";
                llvm::FunctionType* ft = llvm::FunctionType::get(i32, {i64}, false);
                return builder.CreateCall(module.getOrInsertFunction(sym, ft), {fitInt(h, 64)});
            }
            if (fn == "closeStdin" || fn == "kill") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                const char* sym =
                    fn == "closeStdin" ? "__ldp3_subproc_close_stdin" : "__ldp3_subproc_close";
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
                builder.CreateCall(module.getOrInsertFunction(sym, ft), {fitInt(h, 64)});
                return nullptr;
            }
        }
        // Pseudo-console for the integrated terminal: low-level builtins behind System.OS.Pty. Handle is a
        // long (the runtime's LdpPty pointer). See runtime/ldp3_rt.cpp __ldp3_conpty_*.
        if (name.rfind("Conpty.", 0) == 0) {
            const std::string fn = name.substr(7);
            llvm::Type* p = builder.getPtrTy();
            llvm::Type* i64 = builder.getInt64Ty();
            llvm::Type* i32 = builder.getInt32Ty();
            if (fn == "spawn") {
                llvm::Value* cmd = emitExpr(*call.args[0]);
                llvm::Value* cols = emitExpr(*call.args[1]);
                llvm::Value* rows = emitExpr(*call.args[2]);
                if (cmd == nullptr || cols == nullptr || rows == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {p, i32, i32}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_conpty_spawn", ft),
                                          {stringData(cmd), fitInt(cols, 32), fitInt(rows, 32)});
            }
            if (fn == "writeStr") {
                llvm::Value* h = emitExpr(*call.args[0]);
                llvm::Value* data = emitExpr(*call.args[1]);
                if (h == nullptr || data == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(i64, {i64, p, i64}, false);
                llvm::Value* n = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_conpty_write", ft),
                    {fitInt(h, 64), stringData(data), stringLen(data)});
                return builder.CreateTrunc(n, i32);
            }
            if (fn == "readChunk") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                llvm::Value* lenSlot = createEntryAlloca("pty.len", i64);
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {i64, p}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_conpty_read", ft), {fitInt(h, 64), lenSlot});
                return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot, "pty.n"), buf));
            }
            if (fn == "isAlive" || fn == "canRead") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                const char* sym =
                    fn == "canRead" ? "__ldp3_conpty_can_read" : "__ldp3_conpty_alive";
                llvm::FunctionType* ft = llvm::FunctionType::get(i32, {i64}, false);
                return builder.CreateCall(module.getOrInsertFunction(sym, ft), {fitInt(h, 64)});
            }
            if (fn == "resize") {
                llvm::Value* h = emitExpr(*call.args[0]);
                llvm::Value* cols = emitExpr(*call.args[1]);
                llvm::Value* rows = emitExpr(*call.args[2]);
                if (h == nullptr || cols == nullptr || rows == nullptr) return nullptr;
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getVoidTy(), {i64, i32, i32}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_conpty_resize", ft),
                                   {fitInt(h, 64), fitInt(cols, 32), fitInt(rows, 32)});
                return nullptr;
            }
            if (fn == "close") {
                llvm::Value* h = emitExpr(*call.args[0]);
                if (h == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getVoidTy(), {i64}, false);
                builder.CreateCall(module.getOrInsertFunction("__ldp3_conpty_close", ft), {fitInt(h, 64)});
                return nullptr;
            }
        }
        // Env (spec 34): environment variables.
        if (name == "Env.get") {
            llvm::Value* nm = emitExpr(*call.args[0]);
            if (nm == nullptr) return nullptr;
            llvm::Type* p = builder.getPtrTy();
            llvm::Value* lenSlot = createEntryAlloca("ev.len", builder.getInt64Ty());
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p}, false);
            llvm::Value* buf = builder.CreateCall(module.getOrInsertFunction("__ldp3_env_get", ft),
                                                  {stringData(nm), lenSlot});
            return ownedStr(emitStringFromParts(builder.CreateLoad(builder.getInt64Ty(), lenSlot, "ev.n"), buf));
        }
        if (name == "Env.set") {
            llvm::Value* nm = emitExpr(*call.args[0]);
            llvm::Value* val = emitExpr(*call.args[1]);
            if (nm == nullptr || val == nullptr) return nullptr;
            llvm::Type* p = builder.getPtrTy();
            llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p, p}, false);
            return builder.CreateCall(module.getOrInsertFunction("__ldp3_env_set", ft),
                                      {stringData(nm), stringData(val)});
        }
        // executablePath(): the running program's own path -- a heap char* from the runtime.
        if (name == "Env.executablePath") {
            llvm::Type* p = builder.getPtrTy();
            llvm::Type* i64 = builder.getInt64Ty();
            llvm::FunctionType* ft = llvm::FunctionType::get(p, {}, false);
            llvm::Value* cstr =
                builder.CreateCall(module.getOrInsertFunction("__ldp3_executable_path", ft), {});
            llvm::FunctionCallee strlenFn =
                module.getOrInsertFunction("strlen", llvm::FunctionType::get(i64, {p}, false));
            return ownedStr(emitStringFromParts(builder.CreateCall(strlenFn, {cstr}, "exe.len"), cstr));
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
                return ownedStr(emitStringFromParts(len, buf));
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
            // Directory / filesystem metadata (spec 34.4).
            if (fn == "list") {  // newline-separated directory entries
                llvm::Value* path = emitExpr(*call.args[0]);
                if (path == nullptr) return nullptr;
                llvm::Value* lenSlot = createEntryAlloca("dl.len", builder.getInt64Ty());
                llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, p}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("__ldp3_dir_list", ft), {stringData(path), lenSlot});
                return ownedStr(emitStringFromParts(builder.CreateLoad(builder.getInt64Ty(), lenSlot, "dl.n"), buf));
            }
            if (fn == "size") {
                llvm::Value* path = emitExpr(*call.args[0]);
                if (path == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt64Ty(), {p}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_file_size", ft),
                                          {stringData(path)});
            }
            if (fn == "mkdir" || fn == "isDir") {
                llvm::Value* path = emitExpr(*call.args[0]);
                if (path == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p}, false);
                const char* rfn = fn == "mkdir" ? "__ldp3_mkdir" : "__ldp3_is_dir";
                return builder.CreateCall(module.getOrInsertFunction(rfn, ft), {stringData(path)});
            }
            if (fn == "rename") {
                llvm::Value* from = emitExpr(*call.args[0]);
                llvm::Value* to = emitExpr(*call.args[1]);
                if (from == nullptr || to == nullptr) return nullptr;
                llvm::FunctionType* ft = llvm::FunctionType::get(builder.getInt32Ty(), {p, p}, false);
                return builder.CreateCall(module.getOrInsertFunction("__ldp3_rename", ft),
                                          {stringData(from), stringData(to)});
            }
        }
        // Memory.writeString(address, src): bulk-copy src's bytes to a raw buffer via memcpy (used by
        // StringBuilder.append, replacing a byte-at-a-time charAt/write loop).
        if (memName == "Memory.writeString") {
            llvm::Value* dstAddr = emitExpr(*call.args[0]);
            llvm::Value* srcStr = emitExpr(*call.args[1]);
            if (dstAddr == nullptr || srcStr == nullptr) return nullptr;
            llvm::Value* dst = builder.CreateIntToPtr(dstAddr, builder.getPtrTy());
            builder.CreateCall(memcpyFn(), {dst, stringData(srcStr), stringLen(srcStr)});
            return nullptr;
        }
        // Memory.copy(dst, src, n): raw memcpy of n bytes between two addresses.
        if (memName == "Memory.copy") {
            llvm::Value* dstAddr = emitExpr(*call.args[0]);
            llvm::Value* srcAddr = emitExpr(*call.args[1]);
            llvm::Value* n = fitInt(emitExpr(*call.args[2]), 64);
            if (dstAddr == nullptr || srcAddr == nullptr || n == nullptr) return nullptr;
            builder.CreateCall(memcpyFn(), {builder.CreateIntToPtr(dstAddr, builder.getPtrTy()),
                                            builder.CreateIntToPtr(srcAddr, builder.getPtrTy()), n});
            return nullptr;
        }
        // Memory.readString(address, len): build a String by copying `len` bytes from a raw buffer
        // (the new String owns its own copy). Used by StringBuilder.toString().
        if (memName == "Memory.readString") {
            llvm::Value* addr = emitExpr(*call.args[0]);
            llvm::Value* len = fitInt(emitExpr(*call.args[1]), 64);
            if (addr == nullptr || len == nullptr) return nullptr;
            llvm::Value* src = builder.CreateIntToPtr(addr, builder.getPtrTy());
            llvm::Value* buf = builder.CreateCall(
                mallocFn(), {builder.CreateAdd(len, builder.getInt64(1))}, "fb.buf");
            builder.CreateCall(memcpyFn(), {buf, src, len});
            builder.CreateStore(builder.getInt8(0),
                                builder.CreateGEP(builder.getInt8Ty(), buf, len));  // NUL
            // Owned like every other String producer: this allocation belongs to the expression that
            // built it, so it has to be tracked or the temporary is never released. StringBuilder
            // .toString() goes through here, which made every builder-built String leak.
            return ownedStr(emitStringFromParts(len, buf));
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
                // read() reads a line from stdin and returns it as a String -- the one input
                // primitive (spec 4). Parse it (e.g. toInt) for other types.
                llvm::Value* lenSlot = createEntryAlloca("rlen", builder.getInt64Ty());
                llvm::FunctionType* ft =
                    llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
                llvm::Value* buf = builder.CreateCall(
                    module.getOrInsertFunction("ldp3_read_line", ft), {lenSlot}, "line");
                return ownedStr(emitStringFromParts(builder.CreateLoad(builder.getInt64Ty(), lenSlot), buf));
            }
            if (isPrintf || isPrintln || isPrint) {
                const bool nl = isPrintln;
                if (!call.args.empty())
                    if (const auto* is =
                            dynamic_cast<const ast::InterpStringExpr*>(call.args.front().get()))
                        return emitInterp(*is, nl);
                if (call.args.empty()) {
                    if (nl)
                        builder.CreateCall(printf(), {createGlobalStringPtr(builder,"\n", ".str")});
                    return nullptr;
                }
                std::vector<llvm::Value*> args;
                // A leading string literal is a printf-style format; otherwise the first arg is a
                // String value, printed with %s.
                if (const auto* lit =
                        dynamic_cast<const ast::StringLiteralExpr*>(call.args.front().get())) {
                    args.push_back(createGlobalStringPtr(builder,
                        resolveEscapes(lit->value) + (nl ? "\n" : ""), ".str"));
                    for (std::size_t i = 1; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) return nullptr;
                        args.push_back(asCStr(*call.args[i], v));
                    }
                } else {
                    llvm::Value* s = emitExpr(*call.args.front());
                    if (s == nullptr) return nullptr;
                    args.push_back(createGlobalStringPtr(builder,nl ? "%s\n" : "%s", ".str"));
                    args.push_back(asCStr(*call.args.front(), s));
                }
                return builder.CreateCall(printf(), args);
            }
        }
        // reflect.typeOf<T>() (spec 31): returns the Type token for class T.
        if (name == "reflect.typeOf" && !call.typeArgs.empty()) {
            return typeTokenFor(ast::mangleGeneric(call.typeArgs[0], {}));
        }
        // Namespace-level literal suffix function: name(arg). Overloaded by the argument's type
        // (spec 17.10 rule 6). (comptime in the spec; for now it runs at runtime -- see Fase C.)
        if (literalSuffixParams.count(name) > 0 && call.args.size() == 1) {
            const std::string key = chooseLiteralKey(name, typeName(*call.args[0]));
            if (auto fnit = functions.find(key); fnit != functions.end()) {
                llvm::Value* v = emitExpr(*call.args[0]);
                if (v == nullptr) return nullptr;
                v = coerceToType(v, fnit->second->getArg(0)->getType());
                return emitMaybeInvoke(fnit->second, {v});
            }
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
                    return ownedStr(emitStringConcat(s, o));
                }
                // toInt(): parse the string as a base-10 integer (spec 4) -- the typical use of read().
                if (mem->member == "toInt") {
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(builder.getInt32Ty(), {builder.getPtrTy()}, false);
                    return builder.CreateCall(module.getOrInsertFunction("atoi", ft), {stringData(s)});
                }
                // toDouble(): parse the string as a double (spec 4) -- sign, fraction, and 'e'
                // exponent -- mirroring toInt(). Invalid input yields 0.0 (defined, no UB), as atoi.
                if (mem->member == "toDouble") {
                    llvm::FunctionType* ft =
                        llvm::FunctionType::get(builder.getDoubleTy(), {builder.getPtrTy()}, false);
                    return builder.CreateCall(module.getOrInsertFunction("atof", ft), {stringData(s)});
                }
                // string.append(x): mutate the receiver in place by replacing its {length, data} with
                // the concatenation. The receiver must be a mutable `string` (its struct is on the
                // heap; see the value-copy in coerce). Returns the receiver for chaining (spec 4).
                if (mem->member == "append") {
                    llvm::Value* o = emitExpr(*call.args[0]);
                    if (o == nullptr) return nullptr;
                    llvm::Value* cat = emitStringConcat(s, o);
                    builder.CreateStore(stringLen(cat), builder.CreateStructGEP(stringType(), s, 0));
                    builder.CreateStore(stringData(cat), builder.CreateStructGEP(stringType(), s, 1));
                    builder.CreateStore(builder.getInt64(0),
                                        builder.CreateStructGEP(stringType(), s, 2));  // content changed: drop cached hash
                    return s;
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
                    return ownedStr(emitStringFromParts(n, buf));
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
                    return ownedStr(emitStringFromParts(len, buf));
                }
                if (mem->member == "trim") {
                    llvm::Type* p = builder.getPtrTy();
                    llvm::Type* i64 = builder.getInt64Ty();
                    llvm::Value* lenSlot = builder.CreateAlloca(i64, nullptr, "trim.len");
                    llvm::FunctionType* ft = llvm::FunctionType::get(p, {p, i64, p}, false);
                    llvm::Value* buf = builder.CreateCall(
                        module.getOrInsertFunction("__ldp3_str_trim", ft),
                        {stringData(s), stringLen(s), lenSlot});
                    return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot), buf));
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
                    return ownedStr(emitStringFromParts(builder.CreateLoad(i64, lenSlot), buf));
                }
                if (mem->member == "toString") return s;  // identity
                // String satisfies Hashable<String>/Comparable<String> (collections).
                if (mem->member == "hash")
                    return builder.CreateCall(strHashFn(), {s});  // s is the String object; hash cached in it
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
                                  mem->member == "equalsKey" || mem->member == "compareTo" ||
                                  isIntOverflowMethod(mem->member))) {
                llvm::Value* a = emitExpr(*mem->object);
                if (a == nullptr) return nullptr;
                if (mem->member == "hash") return fitInt(a, 64);
                if (mem->member == "toString") {
                    llvm::Value* buf =
                        builder.CreateCall(mallocFn(), {builder.getInt64(24)}, "itoa.buf");
                    llvm::Value* len = builder.CreateCall(itoaFn(), {fitInt(a, 64), buf});
                    return ownedStr(emitStringFromParts(len, buf));
                }
                llvm::Value* b = emitExpr(*call.args[0]);
                if (b == nullptr) return nullptr;
                b = builder.CreateSExtOrTrunc(b, a->getType());
                if (isIntOverflowMethod(mem->member)) {
                    const std::string& mm = mem->member;
                    if (mm == "wrappingAdd" || mm == "uncheckedAdd") return builder.CreateAdd(a, b);
                    if (mm == "wrappingSub" || mm == "uncheckedSub") return builder.CreateSub(a, b);
                    if (mm == "wrappingMul" || mm == "uncheckedMul") return builder.CreateMul(a, b);
                    // Division has exactly one overflow case: INT_MIN / -1, whose true quotient does not
                    // fit. Wrapping it yields INT_MIN (the two's-complement wrap), which is what the
                    // hardware would trap on -- so the divisor is folded to 1 in that case, and the
                    // dividend (INT_MIN) comes back. A zero divisor still panics: that is not overflow,
                    // it is undefined, and LDP3 has no undefined behaviour to hand out (spec 3.6).
                    if (mm == "wrappingDiv" || mm == "uncheckedDiv") {
                        {  // a zero divisor still panics -- that is not overflow, it is undefined
                            llvm::Value* zero =
                                builder.CreateICmpEQ(b, llvm::ConstantInt::get(b->getType(), 0));
                            auto* badBB = llvm::BasicBlock::Create(context, "div.bad", currentFn);
                            auto* okBB = llvm::BasicBlock::Create(context, "div.ok", currentFn);
                            builder.CreateCondBr(zero, badBB, okBB);
                            builder.SetInsertPoint(badBB);
                            emitPanic("integer division by zero");
                            builder.SetInsertPoint(okBB);
                        }
                        if (isUnsigned(ot)) return builder.CreateUDiv(a, b);
                        llvm::Type* ity = a->getType();
                        const unsigned bits = ity->getIntegerBitWidth();
                        llvm::Value* minV = llvm::ConstantInt::get(
                            ity, llvm::APInt::getSignedMinValue(bits));
                        llvm::Value* isMin = builder.CreateICmpEQ(a, minV);
                        llvm::Value* isNeg1 =
                            builder.CreateICmpEQ(b, llvm::ConstantInt::getSigned(ity, -1));
                        llvm::Value* wraps = builder.CreateAnd(isMin, isNeg1, "div.wraps");
                        llvm::Value* safeB = builder.CreateSelect(
                            wraps, llvm::ConstantInt::get(ity, 1), b, "div.rhs");
                        return builder.CreateSDiv(a, safeB);
                    }
                    return emitSaturatingArith(mm, a, b, isUnsigned(ot));  // saturating add/sub/mul
                }
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
            // Reflection tokens (Method/Field/Annotation) satisfy Hashable by identity, so they can
            // live in a collection: equalsKey is pointer equality and hash is the pointer value.
            if (const std::string ot = typeName(*mem->object);
                (ot == "Method" || ot == "Field" || ot == "Annotation") &&
                (mem->member == "equalsKey" || mem->member == "hash")) {
                llvm::Value* a = emitExpr(*mem->object);
                if (a == nullptr) return nullptr;
                if (mem->member == "hash")
                    return builder.CreatePtrToInt(a, builder.getInt64Ty());
                llvm::Value* b = emitExpr(*call.args[0]);
                if (b == nullptr) return nullptr;
                return builder.CreateZExt(builder.CreateICmpEQ(a, b), builder.getInt32Ty());
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
                    llvm::Value* mRetTagsArr = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, 14));
                    llvm::Value* want = stringData(emitExpr(*call.args[0]));
                    llvm::Value* result =
                        builder.CreateCall(mallocFn(), {sizeOf(methodTokenType())}, "method");
                    llvm::Value* nullp = llvm::ConstantPointerNull::get(builder.getPtrTy());
                    builder.CreateStore(nullp, builder.CreateStructGEP(methodTokenType(), result, 0));
                    builder.CreateStore(nullp, builder.CreateStructGEP(methodTokenType(), result, 1));
                    builder.CreateStore(builder.getInt64(0),
                                        builder.CreateStructGEP(methodTokenType(), result, 4));
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
                    builder.CreateStore(
                        builder.CreateLoad(builder.getInt64Ty(),
                                           builder.CreateGEP(builder.getInt64Ty(), mRetTagsArr, i)),
                        builder.CreateStructGEP(methodTokenType(), result, 4));
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
                // Type.methods()/fields()/annotations() (spec 31): build an ArrayList of the member
                // tokens. A Method token is {name, fn}; a Field/Annotation token is {name}.
                if (mem->member == "methods" || mem->member == "fields" ||
                    mem->member == "annotations") {
                    const bool isMethods = (mem->member == "methods");
                    const bool isAnnotations = (mem->member == "annotations");
                    const std::string listCls = isMethods      ? "ArrayList$Method"
                                                : isAnnotations ? "ArrayList$Annotation"
                                                                : "ArrayList$Field";
                    auto clsIt = classes.find(listCls);
                    auto ctorIt = functions.find(listCls + "." + listCls);
                    auto addIt = functions.find(listCls + ".add");
                    if (clsIt == classes.end() || ctorIt == functions.end() ||
                        addIt == functions.end()) {
                        error("internal: " + listCls + " not available for reflection", mem->loc);
                        return nullptr;
                    }
                    llvm::StructType* tokTy = isMethods        ? methodTokenType()
                                              : isAnnotations  ? annotationTokenType()
                                                               : fieldTokenType();
                    const unsigned countSlot = isMethods ? 1 : isAnnotations ? 8 : 4;
                    const unsigned namesSlot = isMethods ? 2 : isAnnotations ? 9 : 5;
                    llvm::Value* list =
                        builder.CreateCall(mallocFn(), {sizeOf(clsIt->second.type)}, "list");
                    builder.CreateCall(ctorIt->second, {list});
                    llvm::Value* count = builder.CreateLoad(
                        builder.getInt64Ty(), builder.CreateStructGEP(typeTokenType(), t, countSlot),
                        "n");
                    llvm::Value* names = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(typeTokenType(), t, namesSlot),
                        "names");
                    const bool isFields = !isMethods && !isAnnotations;
                    llvm::Value* fns =
                        isMethods ? builder.CreateLoad(builder.getPtrTy(),
                                                       builder.CreateStructGEP(typeTokenType(), t, 3),
                                                       "fns")
                                  : nullptr;
                    // Per-method annotation arrays (Type token slots 12, 13), for Method.annotations().
                    llvm::Value* mAnnCounts =
                        isMethods ? builder.CreateLoad(builder.getPtrTy(),
                                                       builder.CreateStructGEP(typeTokenType(), t, 12),
                                                       "manncounts")
                                  : nullptr;
                    llvm::Value* mAnnPtrs =
                        isMethods ? builder.CreateLoad(builder.getPtrTy(),
                                                       builder.CreateStructGEP(typeTokenType(), t, 13),
                                                       "mannptrs")
                                  : nullptr;
                    llvm::Value* fGet = isFields
                                            ? builder.CreateLoad(
                                                  builder.getPtrTy(),
                                                  builder.CreateStructGEP(typeTokenType(), t, 10), "fg")
                                            : nullptr;
                    llvm::Value* fSet = isFields
                                            ? builder.CreateLoad(
                                                  builder.getPtrTy(),
                                                  builder.CreateStructGEP(typeTokenType(), t, 11), "fs")
                                            : nullptr;
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
                        builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), names, i), "nm");
                    llvm::Value* tok = builder.CreateCall(mallocFn(), {sizeOf(tokTy)}, "tok");
                    builder.CreateStore(nm, builder.CreateStructGEP(tokTy, tok, 0));
                    if (isMethods) {
                        llvm::Value* fn = builder.CreateLoad(
                            builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), fns, i), "fn");
                        builder.CreateStore(fn, builder.CreateStructGEP(tokTy, tok, 1));
                        // Method token slots 2 (annotation count), 3 (annotation String[]).
                        builder.CreateStore(
                            builder.CreateLoad(builder.getInt64Ty(),
                                               builder.CreateGEP(builder.getInt64Ty(), mAnnCounts, i),
                                               "mac"),
                            builder.CreateStructGEP(tokTy, tok, 2));
                        builder.CreateStore(
                            builder.CreateLoad(builder.getPtrTy(),
                                               builder.CreateGEP(builder.getPtrTy(), mAnnPtrs, i), "map"),
                            builder.CreateStructGEP(tokTy, tok, 3));
                    } else if (isFields) {  // the field's get/set accessors (Field token slots 1, 2)
                        builder.CreateStore(
                            builder.CreateLoad(builder.getPtrTy(),
                                               builder.CreateGEP(builder.getPtrTy(), fGet, i), "g"),
                            builder.CreateStructGEP(tokTy, tok, 1));
                        builder.CreateStore(
                            builder.CreateLoad(builder.getPtrTy(),
                                               builder.CreateGEP(builder.getPtrTy(), fSet, i), "s"),
                            builder.CreateStructGEP(tokTy, tok, 2));
                    }
                    builder.CreateCall(addIt->second, {list, tok});
                    builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
                    builder.CreateBr(hdr);
                    builder.SetInsertPoint(done);
                    return list;
                }
            }
            // Field reflection (spec 31): name() reads the field token's name.
            if (typeName(*mem->object) == "Field" && mem->member == "name") {
                llvm::Value* f = emitExpr(*mem->object);
                if (f == nullptr) return nullptr;
                return builder.CreateLoad(builder.getPtrTy(),
                                          builder.CreateStructGEP(fieldTokenType(), f, 0), "f.name");
            }
            // Field.get(obj) / set(obj, value) (spec 31): call the field's boxing accessor stored in the
            // token. get returns the boxed field as an Object; set takes an Object (boxed primitive or
            // reference) and writes it back.
            if (typeName(*mem->object) == "Field" &&
                (mem->member == "get" || mem->member == "set")) {
                llvm::Value* f = emitExpr(*mem->object);
                if (f == nullptr) return nullptr;
                llvm::Value* obj = emitExpr(*call.args[0]);
                if (obj == nullptr) return nullptr;
                if (mem->member == "get") {
                    llvm::Value* getFn = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(fieldTokenType(), f, 1), "f.get");
                    llvm::FunctionType* gt =
                        llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false);
                    return builder.CreateCall(gt, getFn, {obj});
                }
                llvm::Value* v = coerce(emitExpr(*call.args[1]), typeName(*call.args[1]), "Object");
                if (v == nullptr) return nullptr;
                llvm::Value* setFn = builder.CreateLoad(
                    builder.getPtrTy(), builder.CreateStructGEP(fieldTokenType(), f, 2), "f.set");
                llvm::FunctionType* st = llvm::FunctionType::get(
                    builder.getVoidTy(), {builder.getPtrTy(), builder.getPtrTy()}, false);
                builder.CreateCall(st, setFn, {obj, v});
                return nullptr;
            }
            // Annotation reflection (spec 14.3, 31): name() reads the annotation token's name.
            if (typeName(*mem->object) == "Annotation" && mem->member == "name") {
                llvm::Value* a = emitExpr(*mem->object);
                if (a == nullptr) return nullptr;
                return builder.CreateLoad(builder.getPtrTy(),
                                          builder.CreateStructGEP(annotationTokenType(), a, 0), "a.name");
            }
            // Method reflection (spec 31): name() and invoke(receiver) for no-arg methods.
            if (typeName(*mem->object) == "Method") {
                llvm::Value* m = emitExpr(*mem->object);
                if (m == nullptr) return nullptr;
                if (mem->member == "name")
                    return builder.CreateLoad(builder.getPtrTy(),
                                              builder.CreateStructGEP(methodTokenType(), m, 0), "m.name");
                // annotations(): the method's own applied annotations (spec 31), from token slots 2/3.
                if (mem->member == "annotations") {
                    const std::string listCls = "ArrayList$Annotation";
                    auto clsIt = classes.find(listCls);
                    auto ctorIt2 = functions.find(listCls + "." + listCls);
                    auto addIt2 = functions.find(listCls + ".add");
                    if (clsIt == classes.end() || ctorIt2 == functions.end() ||
                        addIt2 == functions.end()) {
                        error("internal: ArrayList$Annotation not available for reflection", mem->loc);
                        return nullptr;
                    }
                    llvm::Value* list =
                        builder.CreateCall(mallocFn(), {sizeOf(clsIt->second.type)}, "annlist");
                    builder.CreateCall(ctorIt2->second, {list});
                    llvm::Value* count = builder.CreateLoad(
                        builder.getInt64Ty(), builder.CreateStructGEP(methodTokenType(), m, 2), "annc");
                    llvm::Value* names = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateStructGEP(methodTokenType(), m, 3), "annn");
                    llvm::Function* curFn = currentFn;
                    llvm::Value* iSlot = createEntryAlloca("ai", builder.getInt64Ty());
                    builder.CreateStore(builder.getInt64(0), iSlot);
                    auto* hdr = llvm::BasicBlock::Create(context, "ma.hdr", curFn);
                    auto* body = llvm::BasicBlock::Create(context, "ma.body", curFn);
                    auto* done = llvm::BasicBlock::Create(context, "ma.done", curFn);
                    builder.CreateBr(hdr);
                    builder.SetInsertPoint(hdr);
                    llvm::Value* i = builder.CreateLoad(builder.getInt64Ty(), iSlot, "i");
                    builder.CreateCondBr(builder.CreateICmpSLT(i, count), body, done);
                    builder.SetInsertPoint(body);
                    llvm::Value* nm = builder.CreateLoad(
                        builder.getPtrTy(), builder.CreateGEP(builder.getPtrTy(), names, i), "nm");
                    llvm::Value* tok =
                        builder.CreateCall(mallocFn(), {sizeOf(annotationTokenType())}, "ann");
                    builder.CreateStore(nm, builder.CreateStructGEP(annotationTokenType(), tok, 0));
                    builder.CreateCall(addIt2->second, {list, tok});
                    builder.CreateStore(builder.CreateAdd(i, builder.getInt64(1)), iSlot);
                    builder.CreateBr(hdr);
                    builder.SetInsertPoint(done);
                    return list;
                }
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
                    llvm::Value* tag = builder.CreateLoad(
                        builder.getInt64Ty(), builder.CreateStructGEP(methodTokenType(), m, 4), "m.tag");
                    llvm::Value* recv = emitExpr(*call.args[0]);  // first arg is the receiver
                    if (recv == nullptr) return nullptr;
                    // Forward the remaining arguments to the method (spec 31).
                    std::vector<llvm::Type*> pts = {builder.getPtrTy()};
                    std::vector<llvm::Value*> cargs = {recv};
                    for (std::size_t i = 1; i < call.args.size(); ++i) {
                        llvm::Value* av = emitExpr(*call.args[i]);
                        if (av == nullptr) return nullptr;
                        pts.push_back(av->getType());
                        cargs.push_back(av);
                    }
                    // The result type is carried as a tag (Method token field 4). Switch on it so the
                    // call uses the right ABI, then box the result to Object (a pointer return, or void,
                    // passes through as-is / null). See returnTag/tagRetType/tagBoxType.
                    llvm::Value* nullObj = llvm::ConstantPointerNull::get(builder.getPtrTy());
                    llvm::Function* fn = currentFn;
                    auto* defBB = llvm::BasicBlock::Create(context, "invoke.def", fn);
                    auto* contBB = llvm::BasicBlock::Create(context, "invoke.cont", fn);
                    llvm::SwitchInst* sw = builder.CreateSwitch(tag, defBB, 8);
                    std::vector<std::pair<llvm::BasicBlock*, llvm::Value*>> incoming;
                    for (long long tg = 0; tg <= 7; ++tg) {
                        auto* caseBB =
                            llvm::BasicBlock::Create(context, "invoke.t" + std::to_string(tg), fn);
                        sw->addCase(builder.getInt64(tg), caseBB);
                        builder.SetInsertPoint(caseBB);
                        llvm::FunctionType* ft =
                            llvm::FunctionType::get(tagRetType(tg), pts, false);
                        llvm::Value* res;
                        if (tg == 0) {  // void
                            builder.CreateCall(ft, fnPtr, cargs);
                            res = nullObj;
                        } else if (tg == 5) {  // a reference: already an Object pointer
                            res = builder.CreateCall(ft, fnPtr, cargs);
                        } else {  // a primitive: box it
                            res = emitBox(builder.CreateCall(ft, fnPtr, cargs), tagBoxType(tg));
                        }
                        incoming.emplace_back(builder.GetInsertBlock(), res);
                        builder.CreateBr(contBB);
                    }
                    builder.SetInsertPoint(defBB);
                    builder.CreateBr(contBB);
                    incoming.emplace_back(defBB, nullObj);
                    builder.SetInsertPoint(contBB);
                    llvm::PHINode* phi = builder.CreatePHI(builder.getPtrTy(), incoming.size(), "invoke.r");
                    for (auto& [bb, v] : incoming) phi->addIncoming(v, bb);
                    return phi;
                }
            }
            // Enum built-ins (spec 12.5): EnumName.count() / EnumName.values().
            if (const auto* eid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                auto eit = enums.find(eid->name);
                if (eit != enums.end()) {
                    const int n = static_cast<int>(eit->second.size());
                    if (mem->member == "count") return builder.getInt32(n);
                    if (mem->member == "random" && n > 0) {  // a random ordinal in [0, n)
                        llvm::FunctionType* rt = llvm::FunctionType::get(builder.getInt32Ty(), false);
                        llvm::Value* r =
                            builder.CreateCall(module.getOrInsertFunction("rand", rt), {}, "rand");
                        return builder.CreateSRem(r, builder.getInt32(n), "enum.random");
                    }
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
                    // EnumName.parse(s) -> Option<Enum> (spec 12.5): match s against each constant
                    // name; Some(ordinal) on a hit, None otherwise.
                    if (mem->member == "parse" && call.args.size() == 1) {
                        llvm::Value* s = emitExpr(*call.args[0]);
                        if (s == nullptr) return nullptr;
                        llvm::Value* sData = stringData(s);
                        // parse() yields the value Option<Enum> (a { tag, ordinal } struct), so the slot
                        // holds that value, not a boxed pointer.
                        llvm::Value* slot = createEntryAlloca("parse.opt", variantStructType());
                        llvm::Function* pf = currentFn;
                        llvm::BasicBlock* doneBB = llvm::BasicBlock::Create(context, "parse.done", pf);
                        for (int i = 0; i < n; ++i) {
                            llvm::Value* nm = stringData(emitStringObject(eit->second[i]));
                            llvm::Value* cmp = builder.CreateCall(strcmpFn(), {sData, nm}, "parse.cmp");
                            llvm::Value* eq = builder.CreateICmpEQ(cmp, builder.getInt32(0));
                            auto* mb = llvm::BasicBlock::Create(context, "parse.some", pf);
                            auto* nb = llvm::BasicBlock::Create(context, "parse.next", pf);
                            builder.CreateCondBr(eq, mb, nb);
                            builder.SetInsertPoint(mb);
                            builder.CreateStore(emitOptionVariant("Some", eid->name, i), slot);
                            builder.CreateBr(doneBB);
                            builder.SetInsertPoint(nb);
                        }
                        builder.CreateStore(emitOptionVariant("None", eid->name, -1), slot);
                        builder.CreateBr(doneBB);
                        builder.SetInsertPoint(doneBB);
                        return builder.CreateLoad(variantStructType(), slot, "parse.result");
                    }
                }
            }
            // Static call: the receiver names a class, not a local/this.
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (objId->name != "this" && locals.find(objId->name) == locals.end() &&
                    classes.count(objId->name) > 0) {
                    auto fnit = functions.find(objId->name + "." + mem->member);
                    if (fnit == functions.end()) {
                        // Qualified literal suffix: Type.kib(64) (spec 17.10).
                        if (literalSuffixParams.count(mem->member) > 0 && call.args.size() == 1) {
                            const std::string key =
                                chooseLiteralKey(mem->member, typeName(*call.args[0]));
                            if (auto lf = functions.find(key); lf != functions.end()) {
                                llvm::Value* v = emitExpr(*call.args[0]);
                                if (v == nullptr) return nullptr;
                                v = coerceToType(v, lf->second->getArg(0)->getType());
                                return emitMaybeInvoke(lf->second, {v});
                            }
                        }
                        error("unknown static method '" + mem->member + "'", call.loc);
                        return nullptr;
                    }
                    const bool isExternCall =
                        externReturnType.count(objId->name + "." + mem->member) > 0;
                    std::vector<llvm::Value*> args;
                    std::vector<SpillToken> atk(call.args.size());
                    for (std::size_t i = 0; i < call.args.size(); ++i) {
                        if (isExternCall) {
                            // A lambda argument to a C function is a callback: pass a raw C fn ptr.
                            if (const auto* lam =
                                    dynamic_cast<const ast::LambdaExpr*>(call.args[i].get())) {
                                llvm::Function* cb = emitCallbackFn(*lam);
                                if (cb == nullptr) return nullptr;
                                args.push_back(cb);
                                continue;
                            }
                            // A by-value struct travels in a register: load its bytes as the ABI int.
                            if (llvm::Type* reg = ffiStructRegType(typeName(*call.args[i]))) {
                                llvm::Value* ptr = emitExpr(*call.args[i]);
                                if (ptr == nullptr) return nullptr;
                                args.push_back(builder.CreateLoad(reg, ptr, "ffi.byval"));
                                continue;
                            }
                            // A String maps to a C char*: pass the NUL-terminated data pointer, not the
                            // {len,data} object (spec 26).
                            if (const std::string at = typeName(*call.args[i]);
                                at == "String" || at == "string") {
                                llvm::Value* sv = emitExpr(*call.args[i]);
                                if (sv == nullptr) return nullptr;
                                args.push_back(stringData(sv));
                                continue;
                            }
                        }
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) return nullptr;
                        if (i < fnit->second->arg_size())  // static: no implicit `this`
                            v = coerceToType(v, fnit->second->getArg(i)->getType());
                        args.push_back(v);
                        if (asyncSM && laterArgAwaits(call.args, i)) atk[i] = spillAcrossAwait(v);
                    }
                    for (std::size_t i = call.args.size(); i-- > 0;)
                        if (atk[i].active) args[i] = reloadSpill(atk[i], args[i]);
                    llvm::Value* r = emitMaybeInvoke(fnit->second, args);
                    // A by-value struct return arrives in a register: store it into a fresh object.
                    if (isExternCall) {
                        const std::string rt = externReturnType[objId->name + "." + mem->member];
                        if (ffiStructRegType(rt) != nullptr) {
                            auto cit = classes.find(clsKey(rt));
                            llvm::Value* obj = builder.CreateCall(
                                mallocFn(), {sizeOf(cit->second.type)}, "ffi.ret");
                            builder.CreateStore(r, obj);
                            return obj;
                        }
                    }
                    return r;
                }
            }
            // Enum/catalog instance method dispatch (spec 12.4). A direct enum receiver is an i32
            // ordinal dispatched statically. A catalog-typed receiver is the tagged i64 value: unpack
            // its ordinal (low 32) and enum type id (high 32) and dispatch to the implementing enum --
            // directly for one implementer, or via a switch on the type id for several.
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
                } else if (isTaggedCatalog(est)) {
                    std::vector<std::string> impls;
                    for (const std::string& e : catalogImplEnums(est))
                        if (functions.count(e + "." + mem->member) > 0) impls.push_back(e);
                    if (!impls.empty()) {
                        llvm::Value* tag = emitExpr(*mem->object);  // i64: enumId<<32 | ordinal
                        if (tag == nullptr) return nullptr;
                        llvm::Value* ord = builder.CreateTrunc(tag, builder.getInt32Ty(), "cat.ord");
                        std::vector<llvm::Value*> argVals;
                        for (std::size_t i = 0; i < call.args.size(); ++i) {
                            llvm::Value* v = emitExpr(*call.args[i]);
                            if (v == nullptr) return nullptr;
                            argVals.push_back(v);
                        }
                        auto callImpl = [&](const std::string& e) -> llvm::Value* {
                            auto fnit = functions.find(e + "." + mem->member);
                            std::vector<llvm::Value*> args;
                            args.push_back(ord);
                            for (std::size_t i = 0; i < argVals.size(); ++i) {
                                llvm::Value* v = argVals[i];
                                if (i + 1 < fnit->second->arg_size())
                                    v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                                args.push_back(v);
                            }
                            return builder.CreateCall(fnit->second, args);
                        };
                        if (impls.size() == 1) return callImpl(impls[0]);
                        llvm::Value* enumId = builder.CreateTrunc(
                            builder.CreateLShr(tag, builder.getInt64(32)), builder.getInt32Ty(), "cat.id");
                        llvm::Function* fn = currentFn;
                        llvm::Type* rt = functions[impls[0] + "." + mem->member]->getReturnType();
                        const bool isVoid = rt->isVoidTy();
                        llvm::Value* resSlot = isVoid ? nullptr : createEntryAlloca("cat.res", rt);
                        if (!isVoid) builder.CreateStore(llvm::Constant::getNullValue(rt), resSlot);
                        auto* contBB = llvm::BasicBlock::Create(context, "cat.cont", fn);
                        auto* defBB = llvm::BasicBlock::Create(context, "cat.default", fn);
                        llvm::SwitchInst* sw =
                            builder.CreateSwitch(enumId, defBB, static_cast<unsigned>(impls.size()));
                        for (const std::string& e : impls) {
                            auto* caseBB = llvm::BasicBlock::Create(context, "cat." + e, fn);
                            sw->addCase(builder.getInt32(enumTypeId[e]), caseBB);
                            builder.SetInsertPoint(caseBB);
                            llvm::Value* r = callImpl(e);
                            if (!isVoid) builder.CreateStore(r, resSlot);
                            builder.CreateBr(contBB);
                        }
                        builder.SetInsertPoint(defBB);
                        builder.CreateBr(contBB);  // a packed value always matches an arm
                        builder.SetInsertPoint(contBB);
                        if (isVoid) return nullptr;
                        return builder.CreateLoad(rt, resSlot, "cat.result");
                    }
                }
            }
            // spec 30: calling a method on an unimported type throws (rather than branching
            // into the int3-overwritten code).
            emitAliveGuard(baseType(typeName(*mem->object)));
            // Virtual dispatch: if the static type is polymorphic and the method has a vtable slot, call
            // indirectly through the object's vtable. Devirtualize when the static type is a concrete
            // class that nothing extends/implements (not in `subclassed_`): its instances are exactly
            // that type, so the call is direct and inlinable -- a plain-class method call then costs
            // nothing over a free function (e.g. Bitset.set in a tight sieve loop).
            const std::string st = baseType(typeName(*mem->object));  // see through T* / T&
            auto stit = classes.find(st);
            // Keep the virtual call whenever the runtime type may differ from the static type: the type
            // is extended/implemented (`subclassed_`), is an interface or abstract class (the value is
            // always some concrete subtype -- including via generic variance, e.g. Producer<out T>), or
            // is imported from a dynamically-loaded bundle (the plugin supplies the body). Only a
            // concrete, un-subclassed, local class has instances of exactly its own type -> devirtualize.
            const bool mayBeSubtype = stit != classes.end() &&
                                      (subclassed_.count(st) > 0 || stit->second.isInterface ||
                                       stit->second.isAbstract || stit->second.imported);
            if (stit != classes.end() && stit->second.hasVtable && mayBeSubtype) {
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
                    std::vector<std::pair<std::size_t, std::string>> freeAfter;  // owned `new` args
                    for (std::size_t i = 0; i < call.args.size(); ++i) {
                        llvm::Value* v = emitExpr(*call.args[i]);
                        if (v == nullptr) return nullptr;
                        if (i + 1 < fty->getNumParams()) v = coerceToType(v, fty->getParamType(i + 1));
                        vargs.push_back(v);
                        if (i < mdecl->params.size())
                            if (std::string cn = ownedHeapNewArg(*call.args[i],
                                                                 typeRefName(mdecl->params[i].type));
                                !cn.empty())
                                freeAfter.emplace_back(i + 1, cn);
                        if (asyncSM && laterArgAwaits(call.args, i)) atk[i] = spillAcrossAwait(v);
                    }
                    for (std::size_t i = call.args.size(); i-- > 0;)
                        if (atk[i].active) vargs[1 + i] = reloadSpill(atk[i], vargs[1 + i]);
                    if (recvTk.active) vargs[0] = reloadSpill(recvTk, vargs[0]);
                    // A value-struct return through the vtable is sret too: pass the result slot.
                    if (const std::string vrt = typeRefName(mdecl->returnType);
                        returnsValueStruct(vrt)) {
                        llvm::Value* slot = createEntryAlloca("sret", classes[baseType(vrt)].type);
                        vargs.push_back(slot);
                        emitMaybeInvoke(fty, fnPtr, vargs);
                        for (const auto& [idx, cn] : freeAfter) emitDeleteObject(vargs[idx], cn);
                        return slot;
                    }
                    llvm::Value* res = emitMaybeInvoke(fty, fnPtr, vargs);
                    for (const auto& [idx, cn] : freeAfter) emitDeleteObject(vargs[idx], cn);
                    return res;
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
            const ast::MethodDecl* mdecl = findMethodDecl(owner, mem->member);
            std::vector<llvm::Value*> args;
            args.push_back(objPtr);
            SpillToken recvTk;
            if (asyncSM && anyArgAwaits(call.args)) recvTk = spillAcrossAwait(objPtr);
            std::vector<SpillToken> atk(call.args.size());
            std::vector<std::pair<std::size_t, std::string>> freeAfter;  // owned `new` args to destruct
            for (std::size_t i = 0; i < call.args.size(); ++i) {
                llvm::Value* v = emitExpr(*call.args[i]);
                if (v == nullptr) return nullptr;
                if (i + 1 < fnit->second->arg_size())
                    v = coerceToType(v, fnit->second->getArg(i + 1)->getType());
                args.push_back(v);
                if (mdecl != nullptr && i < mdecl->params.size())
                    if (std::string cn = ownedHeapNewArg(*call.args[i],
                                                         typeRefName(mdecl->params[i].type));
                        !cn.empty())
                        freeAfter.emplace_back(i + 1, cn);
                if (asyncSM && laterArgAwaits(call.args, i)) atk[i] = spillAcrossAwait(v);
            }
            for (std::size_t i = call.args.size(); i-- > 0;)
                if (atk[i].active) args[1 + i] = reloadSpill(atk[i], args[1 + i]);
            if (recvTk.active) args[0] = reloadSpill(recvTk, args[0]);
            // Function specialization: if a function<> parameter was given a known lambda (a no-capture
            // constant, or a bound param forwarded here), call a specialized copy whose calls to it are
            // direct so LLVM inlines the lambda -- what makes sortedBy/filter/map/reduce competitive.
            llvm::Function* callee = fnit->second;
            if (mdecl != nullptr) {
                std::map<int, llvm::Function*> specParams;
                for (std::size_t i = 0; i < call.args.size() && i < mdecl->params.size(); ++i)
                    if (typeRefName(mdecl->params[i].type).rfind("function<", 0) == 0)
                        if (llvm::Function* lam = knownLambdaFor(*call.args[i], args[i + 1]))
                            specParams[static_cast<int>(i)] = lam;
                if (!specParams.empty())
                    callee = specializeMethod(mdecl, owner, mem->member, fnit->second, specParams);
            }
            llvm::Value* res = emitMaybeInvoke(callee, args);
            for (const auto& [idx, cn] : freeAfter) emitDeleteObject(args[idx], cn);
            return res;
        }
        // Unqualified same-class call: LDP3 has no free functions, and locals/lambdas were resolved above,
        // so a bare `name(...)` here names a method of the enclosing class written without its receiver.
        // The this./ClassName. qualifier is optional -- synthesize the receiver (`this` for an instance
        // method, the owning class for a static one) and re-emit through the normal member-call path, so
        // virtual dispatch, argument coercion and async spilling all still apply. (The analyzer has already
        // rejected the instance-from-static case, so a reachable call here always has a valid receiver.)
        if (!name.empty() && name.find('.') == std::string::npos && !enclosingClass_.empty()) {
            const std::string owner = methodOwner(enclosingClass_, name);
            if (!owner.empty() && functions.count(owner + "." + name) > 0) {
                const ast::MethodDecl* md = findMethodDecl(owner, name);
                const bool isStatic = md != nullptr && md->isStatic;
                if (isStatic || currentThis != nullptr) {
                    auto recv = std::make_unique<ast::IdentifierExpr>();
                    recv->name = isStatic ? owner : std::string("this");
                    recv->loc = call.loc;
                    auto callee = std::make_unique<ast::MemberExpr>();
                    callee->object = std::move(recv);
                    callee->member = name;
                    callee->loc = call.loc;
                    ast::CallExpr synth;
                    synth.callee = std::move(callee);
                    synth.loc = call.loc;
                    synth.typeArgs = call.typeArgs;
                    for (const auto& a : call.args) synth.args.push_back(cloneExprDeep(a.get()));
                    return emitCall(synth);
                }
            }
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call.loc);
        return nullptr;
    }

    // Calls the destructor of every live stack object, in reverse declaration
    // order. Emitted before each `return` and at the function's fall-through end.
    // M4 tracks objects at function scope; per-block RAII comes with nested
    // scopes in a later phase.
    // Runs one pending scope-exit action: a defer block, or a using resource's disposal.
    void emitCleanupAction(const Cleanup& c) {
        if (c.lockRelease != nullptr) {  // synchronized: release the Mutex lock (on normal exit or unwind)
            llvm::FunctionType* lf =
                llvm::FunctionType::get(builder.getVoidTy(), {builder.getInt64Ty()}, false);
            builder.CreateCall(module.getOrInsertFunction("__ldp3_lock_release", lf), {c.lockRelease});
            return;
        }
        if (c.block != nullptr) {
            if (c.budgetMs == nullptr) {
                emitBlock(*c.block);
                return;
            }
            // spec 32.10: time the cleanup and report an overrun of its budget.
            llvm::FunctionType* nowTy = llvm::FunctionType::get(builder.getInt64Ty(), {}, false);
            llvm::FunctionCallee now = module.getOrInsertFunction("__ldp3_now_ns", nowTy);
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
            builder.CreateCall(module.getOrInsertFunction("__ldp3_defer_overrun", ovTy),
                               {c.budgetMs, tookMs});
            builder.CreateBr(okBB);
            builder.SetInsertPoint(okBB);
            return;
        }
        if (c.consumed) return;  // an explicit `delete r` inside the using block already disposed it
        llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), c.slot);
        if (c.virtualDelete) {  // destructor through the vtable, then free (see emitDeleteObject)
            emitDeleteObject(objPtr, c.className);
            return;
        }
        auto cit = classes.find(c.className);
        if (cit != classes.end() && cit->second.hasDestructor)
            builder.CreateCall(functions[c.className + ".~" + c.className], {objPtr});
        if (c.heap) builder.CreateCall(freeFn(), {objPtr});  // a heap resource is freed too
    }
    void emitScopeCleanup() {
        // Contracts: postconditions run at each exit, before defers/destructors (spec 29).
        if (currentEnsures != nullptr)
            for (const ast::ExprPtr& e : *currentEnsures) emitContractCheck(*e, "ensures");
        if (currentInvariants != nullptr)
            for (const ast::Expr* inv : *currentInvariants) emitContractCheck(*inv, "invariant");
        // Deferred actions run first, in reverse (LIFO) order. Snapshot and clear the list while running
        // it: if a defer body throws, its own unwind must not re-run the defers (that double-ran them);
        // the still-live destructors/regions are cleaned by the unwind path instead. Restored after, so a
        // sibling exit path (another return in a different branch) still sees the defers.
        std::vector<Cleanup> savedDef = deferred;
        deferred.clear();
        for (auto it = savedDef.rbegin(); it != savedDef.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) break;
            emitCleanupAction(*it);
        }
        deferred = savedDef;
        // A defer/using body that itself threw already terminated the block and taken over control
        // (its exception propagates); the remaining teardown and the caller's return are unreachable.
        if (builder.GetInsertBlock()->getTerminator() != nullptr) return;
        for (auto it = scopeObjects.rbegin(); it != scopeObjects.rend(); ++it) {
            if (!it->region.empty()) continue;  // region objects are destructed when the region frees
            auto fnit = functions.find(it->className + ".~" + it->className);
            if (fnit == functions.end()) continue;
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), it->slot);
            builder.CreateCall(fnit->second, {objPtr});
        }
        // String RAII: release every live String local at this function exit (spec 4). Not cleared here
        // (like scopeObjects) -- the unwinding emitBlock calls resize away the tracking entries.
        for (auto it = scopeStrings.rbegin(); it != scopeStrings.rend(); ++it)
            builder.CreateCall(strFreeFn(), {builder.CreateLoad(builder.getPtrTy(), *it)});
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
    void attachTBAA() {
        llvm::MDBuilder mdb(context);
        llvm::MDNode* root = mdb.createTBAARoot("ldp3 TBAA");
        llvm::MDNode* omni = mdb.createTBAAScalarTypeNode("ldp3 char", root);  // aliases everything
        std::unordered_map<std::string, llvm::MDNode*> cat;
        auto node = [&](const char* name) -> llvm::MDNode* {
            auto it = cat.find(name);
            if (it != cat.end()) return it->second;
            llvm::MDNode* n = mdb.createTBAAScalarTypeNode(name, omni);
            return cat[name] = n;
        };
        auto tagFor = [&](llvm::Type* t) -> llvm::MDNode* {
            llvm::MDNode* n = nullptr;
            if (t->isPointerTy()) n = node("ptr");
            else if (t->isDoubleTy()) n = node("f64");
            else if (t->isFloatTy()) n = node("f32");
            else if (t->isIntegerTy()) {
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
        for (auto& [cn, ci] : classes)
            if (ci.type != nullptr && !ci.isUnion) okStruct.insert(ci.type);
        auto isClassField = [&](llvm::Value* ptr) -> bool {
            auto* gep = llvm::dyn_cast<llvm::GetElementPtrInst>(ptr);
            return gep != nullptr && okStruct.count(gep->getSourceElementType()) > 0;
        };
        for (llvm::Function& f : module) {
            for (llvm::BasicBlock& bb : f) {
                for (llvm::Instruction& inst : bb) {
                    if (auto* L = llvm::dyn_cast<llvm::LoadInst>(&inst)) {
                        if (isClassField(L->getPointerOperand()))
                            if (llvm::MDNode* tag = tagFor(L->getType()))
                                L->setMetadata(llvm::LLVMContext::MD_tbaa, tag);
                    } else if (auto* S = llvm::dyn_cast<llvm::StoreInst>(&inst)) {
                        if (isClassField(S->getPointerOperand()))
                            if (llvm::MDNode* tag = tagFor(S->getValueOperand()->getType()))
                                S->setMetadata(llvm::LLVMContext::MD_tbaa, tag);
                    }
                }
            }
        }
    }

    void stripDeadCode() {
        if (libraryMode) return;
        llvm::ModuleAnalysisManager mam;
        llvm::PassBuilder pb;
        pb.registerModuleAnalyses(mam);
        llvm::ModulePassManager mpm;
        mpm.addPass(llvm::InternalizePass(  // keep the entry (kmain is the freestanding entry, spec 36)
            [](const llvm::GlobalValue& gv) {
                return gv.getName() == "main" || gv.getName() == "kmain";
            }));
        mpm.addPass(llvm::GlobalDCEPass());
        mpm.run(module, mam);
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

    // The individual types named by an unimport (spec 30.1): the target itself for a plain type, or
    // every class/interface/enum in a namespace (granularity 1) or bundle (granularity 2).
    std::vector<std::string> unimportGroupTargets(const ast::UnimportStmt& u) {
        std::vector<std::string> out;
        if (u.granularity == 0) { out.push_back(baseType(u.target)); return out; }
        for (const ast::Bundle& b : program.bundles) {
            if (u.granularity == 2 && b.name != u.target) continue;
            for (const ast::Namespace& ns : b.namespaces) {
                if (u.granularity == 1 && ns.name != u.target) continue;
                for (const ast::ClassDecl& c : ns.classes) out.push_back(c.name);
                for (const ast::EnumDecl& e : ns.enums) out.push_back(e.name);
            }
        }
        return out;
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
    // Constructs and throws a named exception class (it must extend the catchable Exception base, so
    // its constructor installs a vtable that a catch clause can type-match). Used by dynamic-bundle
    // thunks to raise BundleNotLoadedException / BundleAbiMismatchException.
    void emitThrowNamed(const std::string& cn) {
        auto cit = classes.find(cn);
        if (cit == classes.end()) {
            builder.CreateUnreachable();
            return;
        }
        llvm::Value* exc = builder.CreateCall(mallocFn(), {sizeOf(cit->second.type)}, "exc");
        if (auto f = functions.find(cn + "." + cn); f != functions.end())
            builder.CreateCall(f->second, {exc});
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
        if (const auto* u = dynamic_cast<const ast::UnimportStmt*>(st)) { for (const std::string& t : unimportGroupTargets(*u)) unimportableClasses.insert(t); return; }
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
    // Chain top-level labels in source order so each label's abstain region ends at the NEXT top-level
    // label (spec 7.11), not the method end. Labels nested inside control-flow blocks are not chained --
    // their region conservatively runs to the method end (a forward branch into a nested block, past its
    // condition, would be unsafe).
    void scanLabelChainTopLevel(const ast::Block& body) {
        std::string last;
        for (const auto& s : body.statements) {
            const ast::Stmt* st = s.get();
            if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) st = lb->stmt.get();
            if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(st)) {
                if (!last.empty()) nextAbstainLabel_[last] = lm->name;
                last = scanClass_ + "." + scanMethod_ + "." + lm->name;
            }
        }
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
                            scanLabelChainTopLevel(m->body);
                        } else if (const auto* c =
                                       dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                            scanMethod_ = cls.name;  // function name is "class.class"
                            for (const auto& s : c->body.statements) scanAbstained(s.get());
                            scanLabelChainTopLevel(c->body);
                        } else if (const auto* d =
                                       dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                            scanMethod_ = "~" + cls.name;  // function name is "class.~class"
                            for (const auto& s : d->body.statements) scanAbstained(s.get());
                            scanLabelChainTopLevel(d->body);
                        }
                    }
    }

    // Exits the current function early with the default value for its return type,
    // running finallys and destructors (used by the abstainfrom skip path).
    void emitDefaultReturn() {
        emitPendingFinallys(0);
        emitScopeCleanup();
        if (builder.GetInsertBlock()->getTerminator() != nullptr) return;  // a throwing defer took over
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
            const char* name = isItaniumEH() ? "__gxx_personality_v0" : "__CxxFrameHandler3";
            llvm::FunctionCallee p =
                module.getOrInsertFunction(name, llvm::FunctionType::get(builder.getInt32Ty(), true));
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

    // --- Itanium / DWARF exceptions (Linux and other ELF/Mach-O targets) ---
    // The same LDP3 model as WinEH: one canonical carrier (the object pointer, thrown as void*) and
    // manual, subtype-aware type matching in the handler. On these targets the Windows funclet
    // primitives (catchswitch/catchpad/cleanuppad, image-relative EH tables) do not exist; instead a
    // faulting call is an `invoke` to a `landingpad`, throwing goes through __cxa_throw, and cleanups
    // end in `resume`. Because we match types ourselves, every throw uses one type (void* / _ZTIPv) and
    // every catch is `catch _ZTIPv`, so the C++ personality always routes an LDP3 exception into the
    // handler where the real matching happens.
    bool isItaniumEH() {
        const std::string t = moduleTripleStr(module);
        // An explicit target triple decides; an empty one (the common `ldp3c foo.ldp3` with no --target)
        // means the native host, so fall back to which platform ldp3c itself was built for. Without this,
        // a Windows build leaves the triple empty and would wrongly pick the Itanium path.
        if (!t.empty()) return t.find("windows") == std::string::npos;
#ifdef _WIN32
        return false;
#else
        return true;
#endif
    }
    // typeinfo for void* (_ZTIPv), supplied by the C++ runtime (libstdc++ / libc++abi).
    llvm::Constant* itaniumVoidPtrTypeInfo() {
        llvm::GlobalVariable* g = module.getNamedGlobal("_ZTIPv");
        if (g == nullptr)
            g = new llvm::GlobalVariable(module, builder.getPtrTy(), true,
                                         llvm::GlobalValue::ExternalLinkage, nullptr, "_ZTIPv");
        return g;
    }
    llvm::FunctionCallee cxaAllocateException() {
        return module.getOrInsertFunction(
            "__cxa_allocate_exception",
            llvm::FunctionType::get(builder.getPtrTy(), {builder.getInt64Ty()}, false));
    }
    llvm::FunctionCallee cxaThrowFn() {
        return module.getOrInsertFunction(
            "__cxa_throw", llvm::FunctionType::get(
                               builder.getVoidTy(),
                               {builder.getPtrTy(), builder.getPtrTy(), builder.getPtrTy()}, false));
    }
    llvm::FunctionCallee cxaBeginCatch() {
        return module.getOrInsertFunction(
            "__cxa_begin_catch",
            llvm::FunctionType::get(builder.getPtrTy(), {builder.getPtrTy()}, false));
    }
    llvm::FunctionCallee cxaEndCatch() {
        return module.getOrInsertFunction("__cxa_end_catch",
                                          llvm::FunctionType::get(builder.getVoidTy(), false));
    }
    llvm::StructType* landingPadType() {
        return llvm::StructType::get(context, {builder.getPtrTy(), builder.getInt32Ty()});
    }

    // Is there anything to run when an exception unwinds out of the current scope? -- a defer/using
    // block, a live region, or a stack object with a destructor. (Region objects are destructed when the
    // region frees, so they don't count on their own.)
    bool hasUnwindCleanup() {
        if (!deferred.empty() || !scopeRegions.empty()) return true;
        for (const ScopeObject& so : scopeObjects)
            if (so.region.empty() && functions.count(so.className + ".~" + so.className) > 0)
                return true;
        return false;
    }
    // Like hasUnwindCleanup, but only for entries added since the given bases -- i.e. the teardown a throw
    // must run to unwind out to an enclosing try whose body started at these sizes.
    bool hasUnwindCleanupAbove(std::size_t soBase, std::size_t dfBase, std::size_t rgBase) {
        if (deferred.size() > dfBase || scopeRegions.size() > rgBase) return true;
        for (std::size_t i = soBase; i < scopeObjects.size(); ++i)
            if (scopeObjects[i].region.empty() &&
                functions.count(scopeObjects[i].className + ".~" + scopeObjects[i].className) > 0)
                return true;
        return false;
    }
    // Runs the full scope teardown -- defer/using blocks (LIFO), then stack-object destructors (reverse
    // declaration order), then region frees -- as ordinary code, mirroring emitScopeCleanup. Used on the
    // unwind path so `defer`/`using`/regions are honoured when an exception propagates (spec 23.1), not
    // only on structured exits. The snapshots are passed in because the caller clears the live vectors
    // first, so a call inside a cleanup action never recursively targets this same cleanup.
    void emitUnwindCleanupBody(const std::vector<ScopeObject>& objs,
                               const std::vector<Cleanup>& defs,
                               const std::vector<RegionLocal>& regs) {
        for (auto it = defs.rbegin(); it != defs.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) return;
            emitCleanupAction(*it);
        }
        for (auto it = objs.rbegin(); it != objs.rend(); ++it) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) return;
            if (!it->region.empty()) continue;  // destructed with the region
            auto fnit = functions.find(it->className + ".~" + it->className);
            if (fnit == functions.end()) continue;
            builder.CreateCall(fnit->second, {builder.CreateLoad(builder.getPtrTy(), it->slot)});
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
        if (!hasUnwindCleanupAbove(soBase, dfBase, rgBase)) return nullptr;
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
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateResume(lp);
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
        if (isItaniumEH()) return buildCleanupChainItanium(soBase, dfBase, rgBase);
        soBase = std::min(soBase, scopeObjects.size());  // defensive: never form a past-the-end iterator
        dfBase = std::min(dfBase, deferred.size());
        rgBase = std::min(rgBase, scopeRegions.size());
        if (deferred.size() <= dfBase && scopeRegions.size() <= rgBase) {  // pure destructors: funclet chain
            llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
            llvm::BasicBlock* succ = finalUnwind;
            for (std::size_t i = soBase; i < scopeObjects.size(); ++i) {
                const ScopeObject& so = scopeObjects[i];
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
        if (builder.GetInsertBlock()->getTerminator() == nullptr) emitThrowObject(carrier);
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
    llvm::BasicBlock* computeUnwindDest() {
        if (!ehPadStack.empty()) {
            if (!ehBaseStack.empty()) {
                const EhBase& b = ehBaseStack.back();
                if (hasUnwindCleanupAbove(b.so, b.df, b.rg)) {
                    if (isItaniumEH()) {
                        if (b.itDispatch != nullptr)
                            return buildCleanupDispatchItanium(b.so, b.df, b.rg, b.itDispatch, b.itCarrier);
                    } else {
                        return buildCleanupChain(ehPadStack.back(), b.so, b.df, b.rg);
                    }
                }
            }
            return ehPadStack.back();
        }
        if (!hasUnwindCleanup()) return nullptr;
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
    void emitThrowObjectItanium(llvm::Value* obj) {
        ensurePersonality();
        llvm::PointerType* ptrTy = builder.getPtrTy();
        // Allocate an exception whose 8-byte payload is the carrier (the object pointer), then throw it
        // typed as void*. Every LDP3 throw uses this one type; matching happens in the handler.
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
    void emitThrowObject(llvm::Value* obj) {
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

    // True if class `cn` is `t`, or (transitively) extends or implements `t` -- the subtype relation
    // used for runtime `is`/`as`/`cast` checks (spec 6.3/6.4). Unlike subtypeVtables it also follows
    // interfaces, so `x is SomeInterface` works.
    bool classIsSubtypeOf(const std::string& cn, const std::string& t) {
        if (cn == t) return true;
        auto it = classes.find(cn);
        if (it == classes.end()) return false;
        if (!it->second.superclass.empty() && classIsSubtypeOf(it->second.superclass, t)) return true;
        for (const std::string& i : it->second.interfaces)
            if (classIsSubtypeOf(i, t)) return true;
        return false;
    }
    // Vtables of every concrete class that is a subtype of `t` (extends or implements it).
    std::vector<llvm::Constant*> subtypeVtablesInc(const std::string& t) {
        std::vector<llvm::Constant*> out;
        for (const auto& [cn, cl] : classes)
            if (cl.vtable != nullptr && classIsSubtypeOf(cn, t)) out.push_back(cl.vtable);
        return out;
    }
    // Runtime is-a test (spec 6.4): true iff `objPtr` is non-null and its concrete type (identified by
    // the vtable pointer at field 0) is a subtype of `targetClass`. Null-safe: null yields false.
    llvm::Value* emitIsa(llvm::Value* objPtr, const std::string& targetClass) {
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
        for (llvm::Constant* vt : subtypeVtablesInc(targetClass))
            match = builder.CreateOr(match, builder.CreateICmpEQ(vtbl, vt));
        llvm::BasicBlock* chkEnd = builder.GetInsertBlock();
        builder.CreateBr(contBB);
        builder.SetInsertPoint(contBB);
        llvm::PHINode* phi = builder.CreatePHI(builder.getInt1Ty(), 2, "isa");
        phi->addIncoming(builder.getFalse(), entryBB);
        phi->addIncoming(match, chkEnd);
        return phi;
    }

    // try { body } catch (T e) { ... } ... [finally { ... }] (spec 21.1). One catchpad catches the
    // canonical carrier; the clauses are matched in order against the exception's LDP3 runtime type
    // (subtype-aware via vtables). If none match, the current exception is rethrown. finally runs on
    // the normal and caught paths (the uncaught-propagation finally is a later slice).
    // Itanium counterpart of emitTry. Same LDP3 semantics and the same subtype-aware vtable matching;
    // only the pad mechanics differ. The landing pad catches the single carrier type, copies the object
    // out (begin/end_catch), and then dispatches in ordinary context -- so handlers, finally and the
    // unmatched rethrow are all normal code, with none of WinEH's funclet restrictions.
    void emitTryItanium(const ast::TryStmt& s) {
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
        if (s.finallyBlock != nullptr) finallyStack.push_back(s.finallyBlock.get());
        emitBlock(s.body);
        ehPadStack.pop_back();
        ehBaseStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(contBB);

        builder.SetInsertPoint(ehpad);
        llvm::LandingPadInst* lp = builder.CreateLandingPad(landingPadType(), 1);
        lp->addClause(itaniumVoidPtrTypeInfo());
        llvm::Value* excPtr = builder.CreateExtractValue(lp, 0, "exc");
        // __cxa_begin_catch on a pointer-typed exception (_ZTIPv) returns the thrown pointer value -- our
        // carrier -- directly, so it is used as-is with no extra load. end_catch then releases the
        // exception; the carrier points at the LDP3 object, which lives on its own, so it stays valid.
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
            if (match == nullptr) match = builder.getInt1(true);  // non-polymorphic: catch-all
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
            if (had) locals[cc.name] = saved; else locals.erase(cc.name);
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(contBB);
            builder.SetInsertPoint(nextBB);
        }
        // No clause matched: run finally (uncaught path) then re-raise the same carrier to the
        // enclosing try or the caller. A fresh throw avoids __cxa_rethrow's begin/end-catch bookkeeping.
        // If the finally itself threw, it already terminated the block, so skip the re-raise.
        if (s.finallyBlock != nullptr) finallyStack.pop_back();
        if (s.finallyBlock != nullptr) emitBlock(*s.finallyBlock);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) emitThrowObject(obj);
        // Normal / caught fall-through: the finally runs once here too.
        builder.SetInsertPoint(contBB);
        if (s.finallyBlock != nullptr) emitBlock(*s.finallyBlock);
    }

    void emitTry(const ast::TryStmt& s) {
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
        if (s.finallyBlock != nullptr) finallyStack.push_back(s.finallyBlock.get());
        emitBlock(s.body);
        ehPadStack.pop_back();
        ehBaseStack.pop_back();
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
        // A finally that itself threw already terminated the block, so skip the re-raise.
        if (builder.GetInsertBlock()->getTerminator() == nullptr) emitThrowObject(rethrown);
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
        setDebugLoc(stmt.loc);  // -g: this statement's line, so breakpoints/stepping map to source
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
                // While abstained, skip the guarded region. Its end is the NEXT top-level label (spec
                // 7.11): branch there so control resumes at that label (whose own guard then runs). Only
                // if there is no next label does the region run to the method end (default return).
                if (auto nit = nextAbstainLabel_.find(akey); nit != nextAbstainLabel_.end()) {
                    llvm::BasicBlock*& nb = labelBlocks[nit->second];
                    if (nb == nullptr)
                        nb = llvm::BasicBlock::Create(context, "label." + nit->second, currentFn);
                    builder.CreateBr(nb);
                } else {
                    emitDefaultReturn();  // no next label: the region runs to the method end
                }
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
            // `goto label;` -- branch to the label's block in the same method. First run the cleanup for
            // any scopes this jump leaves (defers + destructors), so goto-out-of-scope doesn't leak.
            emitGotoScopeCleanup(g->name);
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
            // Inside an async/generator state machine the local already lives in the heap state
            // object (pre-bound); just evaluate the initializer and store it, so it survives a suspend.
            if (asyncSM || genSM) {
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
            // Region flavor (spec 17, flavors expansion): record this region local's reclaim strategy so
            // new/delete/extract/release dispatch on it. pool/fixedslot serve reclaimable slots via the
            // runtime and do NOT get the inline bump cursor (that stays the bump/stack fast path).
            if (declType == "region" && !vd->regionFlavor.empty())
                regionFlavor_[vd->name] = vd->regionFlavor;
            if (declType == "region" && vd->regionGrowable)
                growableRegions_.insert(vd->name);
            // `lazy region` (spec 37.3): defer the backing allocation until the first object
            // enters. Store null now and remember the size/address to replay on first use.
            if (declType == "region" && vd->isLazy) {
                if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get())) {
                    // atMultiple (spec 17.4): a multi-range region over fixed addresses. Record the
                    // ranges + one bump used-counter per range; there is no malloc'd block to free.
                    if (!ri->ranges.empty()) {
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
                    llvm::Value* slot = createEntryAlloca(vd->name, builder.getPtrTy());
                    builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()), slot);
                    locals[vd->name] = LocalSlot{slot, "region"};
                    lazyRegions_.insert(vd->name);
                    lazyRegionSize_[vd->name] = ri->size.get();
                    lazyRegionAt_[vd->name] = ri->atAddress.get();
                    if (vd->isVolatile) volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO)
                    // An owned lazy region keeps its bump cursor in a register-promotable alloca; the
                    // lazy-acquire block re-zeros it each time the backing block is (re)allocated.
                    if (ri->atAddress.get() == nullptr && !usesRuntimeDesc(vd->regionFlavor) && !vd->regionGrowable)
                        setupOwnedRegionCursor(vd->name);
                    if (!vd->isEternal) scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
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
                if (vd->isVolatile) volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO)
                if (!vd->isEternal)
                    scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
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
            if (initV == nullptr) return;
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
            // String RAII: an immutable `String` local owns its own buffer (deep-copy on init) and is
            // freed at scope exit. Only a plain `String` value -- not `String*` (an alias), a `String[]`,
            // nor the mutable `string` (whose coerce shares the data pointer and whose append reallocs it,
            // so it carries a separate copy/free lifecycle we must not double-free here).
            // KNOWN GAP (task #252): `string d = ownedStringExpr` (e.g. concat) shares a temporary that is
            // freed at the statement end, so the local reads empty. Copying+tracking `string` here fixes
            // the read but double-frees on mutable reassign/append -- it needs the coordinated
            // mutable-string lifecycle pass, not a piecemeal change here.
            bool declIsString = (declType == "String");
            if (declIsString) initV = emitStringCopy(initV);
            llvm::Value* slot = createEntryAlloca(vd->name, llvmType(declType));
            builder.CreateStore(initV, slot, vd->isVolatile);  // spec 37.5
            locals[vd->name] = LocalSlot{slot, declType, vd->isVolatile};
            if (declIsString) scopeStrings.push_back(slot);
            declareLocalDebug(slot, vd->name, declType, vd->loc);  // -g: name/read this local in the debugger
            // An eagerly-allocated owned region (`region r = itself.allocate(...)`): give it a
            // register-promotable bump cursor, zeroed now that its block is freshly acquired.
            // (pool/fixedslot/stack/ring and any growable region use the runtime allocator, not an inline
            // cursor -- no cursor for them.)
            if (declType == "region" && isOwnedRegionInit(vd->init.get()) &&
                !usesRuntimeDesc(vd->regionFlavor) && !vd->regionGrowable)
                setupOwnedRegionCursor(vd->name);
            // A ring region records its single element type's destructor (from `.accepts({T})`), so
            // eviction of the oldest entry and release can run it. Set once, here at the declaration.
            if (declType == "region" && isRingFlavor(vd->regionFlavor)) {
                llvm::Value* dtor = llvm::ConstantPointerNull::get(builder.getPtrTy());
                if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                    ri != nullptr && !ri->accepts.empty()) {
                    const std::string acn = baseType(ri->accepts[0]);
                    if (auto cit = classes.find(acn); cit != classes.end() && cit->second.hasDestructor)
                        dtor = functions[acn + ".~" + acn];
                }
                llvm::Value* block = builder.CreateLoad(builder.getPtrTy(), slot, "region");
                builder.CreateCall(ringSetDtorFn(), {block, dtor});
            }
            // RAII: a freshly built `new ... on stack` object with a destructor gets cleaned up
            // when the function returns -- unless it is `eternal` (spec 37.2: lives for the whole
            // program, no cleanup).
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                auto cit = classes.find(nw->className);
                if (cit != classes.end() && cit->second.hasDestructor && !vd->isEternal) {
                    // A region object's destructor runs when the region is released/freed (spec
                    // 17.7); a plain stack object's runs at scope exit. A heap object is manual.
                    // A STACK- or RING-region object is NOT tracked here: the runtime owns its destructor
                    // (the stack registry / the ring teardown), so scopeObjects would double-destruct it.
                    const std::string rfl =
                        flavorOfRegion(nw->region);
                    if (!nw->region.empty() && !isStackFlavor(rfl) && !isRingFlavor(rfl))
                        scopeObjects.push_back(ScopeObject{slot, nw->className, nw->region});
                    else if (nw->region.empty() && nw->location == "stack")
                        scopeObjects.push_back(ScopeObject{slot, nw->className, ""});
                }
                // An object placed in a `volatile region` (MMIO): its field accesses are volatile.
                if (!nw->region.empty() && volatileRegions_.count(nw->region) > 0)
                    volatileObjects_.insert(vd->name);
            } else if (isClassValue(declType) && isCopyDiscipline(declType) &&
                       isCopyableLValue(*vd->init) && !vd->isEternal &&
                       escapingLocals_.count(vd->name) == 0) {
                // A copy-initialized local (T b = a;) is a deep copy this frame uniquely owns -- it lives
                // on the stack here (an escaping copy was promoted to the heap and is excluded). Register
                // it for scope-exit destruction so it does not leak, exactly like a `new ... on stack`
                // object; same ownership and same accepted this-escape risk as any stack object.
                const std::string cn = baseType(declType);
                if (auto cit = classes.find(cn); cit != classes.end() && cit->second.hasDestructor)
                    scopeObjects.push_back(ScopeObject{slot, cn, ""});
            }
            // RAII for regions (spec 17.7): freed at the end of the lexical block
            // unless eternal. An explicit `release region` nulls the slot first, so
            // the scope-end free is a harmless free(null).
            if (declType == "region" && !vd->isEternal)
                scopeRegions.push_back(RegionLocal{slot, vd->isEternal, vd->name});
            if (declType == "region" && vd->isVolatile)
                volatileRegions_.insert(vd->name);  // spec 37.5 (MMIO): volatile object accesses
            freeStringTemps();  // String RAII: the initializer's owned temporaries die here (slot holds a copy)
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
                    emitMaybeInvoke(fnit->second, {recv, idx, val});
                    return;
                }
            }
            // Property with a custom setter (spec 8.4): `obj.prop = v` routes through the setter
            // method, except inside the setter itself (which writes the backing field directly).
            if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
                const std::string oc = baseType(typeName(*mt->object));
                if (auto cit = classes.find(oc); cit != classes.end()) {
                    auto sit = cit->second.propertySetters.find(mt->member);
                    if (sit != cit->second.propertySetters.end()) {
                        const std::string owner = methodOwner(oc, sit->second);
                        const std::string setterFn = owner + "." + sit->second;
                        const bool inOwnSetter =
                            currentFn != nullptr && currentFn->getName().str() == setterFn;
                        if (!inOwnSetter) {
                            if (auto fnit = functions.find(setterFn); fnit != functions.end()) {
                                llvm::Value* recv = emitObjectPtr(*mt->object);
                                llvm::Value* val = emitExpr(*assign->value);
                                if (recv == nullptr || val == nullptr) return;
                                // Dispatch through the vtable when a subtype may override the setter --
                                // just like the getter and any method -- so `base.prop = v` runs the
                                // most-derived setter; a concrete un-subclassed receiver stays a direct
                                // call.
                                const ast::MethodDecl* sdecl = findMethodDecl(oc, sit->second);
                                const bool mayBeSubtype =
                                    subclassed_.count(oc) > 0 || cit->second.isInterface ||
                                    cit->second.isAbstract || cit->second.imported;
                                const int slot = slotIndex(oc, sit->second);
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
                                    if (fty->getNumParams() >= 2)
                                        val = coerceToType(val, fty->getParamType(1));
                                    builder.CreateCall(fty, fnPtr, {recv, val});
                                    return;
                                }
                                if (fnit->second->arg_size() >= 2)
                                    val = coerceToType(val, fnit->second->getArg(1)->getType());
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
                    if (slot == nullptr || val == nullptr) return;
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
                if (obj == nullptr) return;
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
                isClassValue(targetType))
                if (const auto* anw = dynamic_cast<const ast::NewExpr*>(assign->value.get());
                    anw != nullptr && anw->location == "stack" && anw->region.empty())
                    const_cast<ast::NewExpr*>(anw)->location = "heap";
            llvm::Value* slot = emitLValue(*assign->target);
            if (slot == nullptr) return;
            // A `this.field = itself.allocate(...)` init of a flavored region field: thread the field's
            // flavor/growth into the RegionInitExpr RHS so it lays out the right header (spec 17 fields).
            if (targetType == "region")
                if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get()))
                    if (const ast::FieldDecl* fd = regionFieldDecl("this." + mt->member)) {
                        pendingRegionFlavor_ = fd->regionFlavor;
                        pendingRegionGrowable_ = fd->regionGrowable;
                    }
            llvm::Value* v = emitExpr(*assign->value);
            pendingRegionFlavor_.clear();
            pendingRegionGrowable_ = false;
            if (v == nullptr) return;
            pendingPersistIndex = nullptr;  // defensive: never leak into the next new
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
                    builder.CreateCall(memcpyFn(), {destStruct, v, sizeOf(tst)});
                    for (const auto& [fname, ftype] : collectFields(targetType)) {
                        const unsigned idx = classes[targetType].fieldIndex[fname];
                        llvm::Value* deep = nullptr;
                        if (isArrayType(ftype))
                            deep = emitArrayDup(builder.CreateLoad(builder.getPtrTy(),
                                                                   builder.CreateStructGEP(tst, v, idx)),
                                                elementOf(ftype));
                        else if (isClassValue(ftype) && isCopyDiscipline(ftype))
                            deep = emitClassCopy(ftype,
                                                 builder.CreateLoad(builder.getPtrTy(),
                                                                    builder.CreateStructGEP(tst, v, idx)),
                                                 /*heap=*/true);
                        if (deep != nullptr)
                            builder.CreateStore(deep, builder.CreateStructGEP(tst, destStruct, idx));
                    }
                    builder.CreateBr(doneBB);
                    builder.SetInsertPoint(doneBB);
                }
            } else {
                llvm::Value* sv = coerce(v, typeName(*assign->value), targetType);
                // String RAII: assigning a `String` deep-copies so the target owns an independent buffer
                // (value semantics; spec 4). For a tracked local we also free its previous copy first --
                // sound because copy-on-store guarantees the slot owned a fresh, unshared, heap buffer
                // (null-safe; the fresh copy is distinct from the old value, so self-assign is fine too).
                if (targetType == "String") {
                    sv = emitStringCopy(sv);
                    const ast::Expr* tgt = assign->target.get();
                    if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(tgt)) {
                        if (auto lit = locals.find(tid->name);
                            lit != locals.end() && isTrackedStringSlot(lit->second.storage))
                            builder.CreateCall(strFreeFn(),
                                               {builder.CreateLoad(builder.getPtrTy(), lit->second.storage)});
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
                if (const auto* mt = dynamic_cast<const ast::MemberExpr*>(assign->target.get()))
                    sv = maskBitField(sv, typeName(*mt->object), mt->member);  // bit-field (spec 11.1)
                // A boolean array element occupies 1 byte; narrow the i32 boolean value before storing.
                if (targetType == "boolean")
                    if (const auto* tix = dynamic_cast<const ast::IndexExpr*>(assign->target.get()))
                        if (!isRefType(typeName(*tix->array)))
                            sv = builder.CreateTrunc(sv, builder.getInt8Ty());
                builder.CreateStore(sv, slot, isVolatileAccess(*assign->target));  // spec 37.5
                // Reassigning an owned region a fresh block (`r = itself.allocate(...)`, including filling
                // an empty-state region): (re)zero its register bump cursor so allocations restart at 0.
                if (targetType == "region")
                    if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get()))
                        if (isOwnedRegionInit(assign->value.get())) setupOwnedRegionCursor(tid->name);
            }
            freeStringTemps();  // String RAII: release owned temporaries at the statement boundary
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
            // operator ++ / -- overload (spec 6.5): the user's operator returns the new value; store it
            // back into the target. A unary operator takes only `this` (arg_size 1).
            {
                const std::string tt = baseType(typeName(*incdec->target));
                const std::string opName = incdec->isIncrement ? "operator++" : "operator--";
                const std::string owner = methodOwner(tt, opName);
                if (!owner.empty()) {
                    auto fnit = functions.find(owner + "." + opName);
                    if (fnit != functions.end() && fnit->second->arg_size() == 1) {
                        llvm::Value* recv = emitExpr(*incdec->target);
                        if (recv == nullptr) return;
                        llvm::Value* res = emitMaybeInvoke(fnit->second, {recv});
                        llvm::Value* dst = emitLValue(*incdec->target);
                        if (dst != nullptr) builder.CreateStore(res, dst);
                        return;
                    }
                }
            }
            const std::string itn = typeName(*incdec->target);
            llvm::Type* ty = llvmType(itn);
            llvm::Value* slot = emitLValue(*incdec->target);
            if (slot == nullptr) return;
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
            // One delete; called for `del->target` and each of `del->moreTargets`. The placement
            // modifiers (from region / cascade) are shared and read from `del`.
            auto deleteOne = [&](const ast::Expr& target) {
                // Deleting a `using` resource by name explicitly disposes it now, so mark its pending
                // disposal consumed -- the using block must not destruct/free it a second time (that was
                // a double free, now a hard panic via the allocator guard).
                if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(&target))
                    if (auto lit = locals.find(tid->name); lit != locals.end())
                        for (auto dit = deferred.rbegin(); dit != deferred.rend(); ++dit)
                            if (dit->block == nullptr && dit->slot == lit->second.storage) {
                                dit->consumed = true;
                                break;
                            }
                const std::string t = typeName(target);
                if (isValueVariant(t)) return;  // a value Result/Option is not heap-allocated: delete is a no-op
                if (isArrayType(t)) {
                    // An array is a single heap block. A String[] owns its elements (copy-on-store), so
                    // free each before the block or they leak (this is the ArrayList<String> backing that
                    // `delete this.data` reclaims); other element types own nothing here.
                    llvm::Value* block = emitExpr(target);
                    if (block != nullptr) {
                        if (arrayOwnsElements(elementOf(t))) emitFreeOwnedArrayElements(block, elementOf(t));
                        builder.CreateCall(freeFn(), {block});
                    }
                    return;
                }
                llvm::Value* objPtr = emitObjectPtr(target);
                if (objPtr == nullptr) return;
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
                    if (runtimeReclaim) builder.CreateCall(checkLiveFn(), {objPtr});
                    if (cit != classes.end() && cit->second.hasDestructor)
                        builder.CreateCall(functions[cn + ".~" + cn], {objPtr});
                    if (runtimeReclaim) {
                        llvm::Value* block = builder.CreateLoad(
                            builder.getPtrTy(), regionStorageSlot(del->fromRegion), "region");
                        builder.CreateCall(regionFreeFn(), {block, objPtr, sizeOf(cit->second.type)});
                    }
                    if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(&target))
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
                if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
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
            for (const auto& mt : del->moreTargets) deleteOne(*mt);
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
                // A stack region tears down its registry (rollback-to-0 + free it); a ring region destructs
                // its live entries -- both before the block is freed. A growable region frees its whole
                // block chain (bump/pool/fixedslot only -- growable stack/ring are rejected in sema).
                const std::string relFlavor =
                    flavorOfRegion(rel->region);
                if (isStackFlavor(relFlavor)) builder.CreateCall(regionTeardownFn(), {block});
                else if (isRingFlavor(relFlavor)) builder.CreateCall(ringTeardownFn(), {block});
                if (growableOfRegion(rel->region))
                    builder.CreateCall(regionFreeChainFn(), {block});
                else
                    builder.CreateCall(regionReleaseFn(), {block});
                builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()),
                                    it->second.storage);
            }
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
            if (m == nullptr) return;
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
                if (builder.GetInsertBlock()->getTerminator() == nullptr)
                    emitCleanupAction(deferred.back());
                deferred.pop_back();
            }
            return;
        }
        if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(&stmt)) {
            llvm::Value* mptr = emitObjectPtr(*sy->mutex);  // the Mutex instance
            if (mptr == nullptr) return;
            auto cit = classes.find(clsKey(typeName(*sy->mutex)));
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
            if (had) locals[sy->bindName] = saved; else locals.erase(sy->bindName);
            // Normal path: run the release we registered. The unwind path already ran it via the
            // cleanup chain (which snapshotted `deferred` when the body threw). Pop it either way.
            if (builder.GetInsertBlock()->getTerminator() == nullptr)
                for (std::size_t i = deferred.size(); i > dfBase; --i) emitCleanupAction(deferred[i - 1]);
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
                if (v == nullptr) return;
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
            if (v != nullptr && yieldSlot_ != nullptr)
                builder.CreateStore(coerce(v, typeName(*ys->value), yieldType_), yieldSlot_);
            if (yieldEnd_ != nullptr) builder.CreateBr(yieldEnd_);
            return;
        }
        if (const auto* as = dynamic_cast<const ast::AsmStmt*>(&stmt)) {
            // Inline assembly (spec issue 1): emit the raw body as a side-effecting LLVM inline asm
            // that clobbers memory (so it is not reordered/elided). The target arch comes from the
            // module triple; `as->arch` is a documentation/intent tag.
            llvm::FunctionType* aty = llvm::FunctionType::get(builder.getVoidTy(), false);
            llvm::InlineAsm* ia = llvm::InlineAsm::get(aty, as->body, /*constraints=*/"~{memory}",
                                                       /*hasSideEffects=*/true);
            builder.CreateCall(ia, {});
            return;
        }
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
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
            if (const auto* cnw = dynamic_cast<const ast::NewExpr*>(rs->value.get());
                cnw != nullptr && cnw->location == "stack" && cnw->region.empty())
                const_cast<ast::NewExpr*>(cnw)->location = "heap";
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
                if ((currentRetTypeName_ == "String" || typeName(*rs->value) == "String") && v != nullptr)
                    v = emitStringCopy(v);
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
                    if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateRetVoid();
                    return;
                }
                emitPendingFinallys(0);  // run every enclosing try's finally before leaving
                emitScopeCleanup();
                if (builder.GetInsertBlock()->getTerminator() == nullptr && v != nullptr)
                    builder.CreateRet(v);
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
            const std::string& rname = scopeRegions[i - 1].name;
            runRegionObjectDtors(rname);  // destruct objects before freeing (17.7)
            llvm::Value* block =
                builder.CreateLoad(builder.getPtrTy(), scopeRegions[i - 1].slot, "region");
            // stack tears down its registry, ring destructs its live entries -- on scope exit and
            // exception unwind alike, so region objects are reclaimed either way (spec 17.7).
            const std::string rfl = flavorOfRegion(rname);
            if (isStackFlavor(rfl)) builder.CreateCall(regionTeardownFn(), {block});
            else if (isRingFlavor(rfl)) builder.CreateCall(ringTeardownFn(), {block});
            if (growableOfRegion(rname))
                builder.CreateCall(regionFreeChainFn(), {block});  // free the whole grown chain
            else
                builder.CreateCall(regionReleaseFn(), {block});  // cache the block for reuse (see runtime)
        }
    }

    void emitBlockCleanup(std::size_t soBase, std::size_t dfBase, std::size_t regBase,
                          std::size_t strBase = static_cast<std::size_t>(-1)) {
        for (std::size_t i = deferred.size(); i > dfBase; --i) {
            if (builder.GetInsertBlock()->getTerminator() != nullptr) return;
            emitCleanupAction(deferred[i - 1]);
        }
        for (std::size_t i = scopeObjects.size(); i > soBase; --i) {
            const ScopeObject& so = scopeObjects[i - 1];
            if (!so.region.empty()) continue;  // region objects are destructed when the region frees
            auto fnit = functions.find(so.className + ".~" + so.className);
            if (fnit == functions.end()) continue;
            llvm::Value* objPtr = builder.CreateLoad(builder.getPtrTy(), so.slot);
            builder.CreateCall(fnit->second, {objPtr});
        }
        // String RAII: free String locals declared in this block (LIFO). The sentinel base means "leave
        // them" -- break/continue pass it so the outer scope-exit / function return frees them, never us
        // double-freeing here.
        if (strBase != static_cast<std::size_t>(-1))
            for (std::size_t i = scopeStrings.size(); i > strBase; --i)
                builder.CreateCall(strFreeFn(),
                                   {builder.CreateLoad(builder.getPtrTy(), scopeStrings[i - 1])});
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
    void scanLabelBlocks(const ast::Block& b) {
        for (const auto& sp : b.statements) scanStmtLabels(sp.get(), b);
    }
    void scanStmtLabels(const ast::Stmt* s, const ast::Block& owner) {
        if (s == nullptr) return;
        if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(s)) { labelBlock_[lm->name] = &owner; return; }
        if (const auto* is = dynamic_cast<const ast::IfStmt*>(s)) {
            scanLabelBlocks(is->thenBlock);
            if (is->elseBlock) scanLabelBlocks(*is->elseBlock);
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
            for (const auto& c : sw->cases) scanLabelBlocks(c.body);
            if (sw->defaultBody) scanLabelBlocks(*sw->defaultBody);
            return;
        }
        if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
            for (const auto& c : ms->cases) scanLabelBlocks(c.body);
            if (ms->defaultBody) scanLabelBlocks(*ms->defaultBody);
            return;
        }
        if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) {
            scanLabelBlocks(ts->body);
            for (const auto& c : ts->catches) scanLabelBlocks(c.body);
            if (ts->finallyBlock) scanLabelBlocks(*ts->finallyBlock);
            return;
        }
        if (const auto* la = dynamic_cast<const ast::LabeledStmt*>(s)) { scanStmtLabels(la->stmt.get(), owner); return; }
    }

    // Run the defers/destructors/regions/Strings for every open scope nested inside the target label's
    // scope, innermost first, before a `goto` branches there. No-op if the label is in the current scope
    // (nothing nested is being left) or is not on the open-scope stack.
    void emitGotoScopeCleanup(const std::string& label) {
        auto lit = labelBlock_.find(label);
        if (lit == labelBlock_.end()) return;
        const ast::Block* target = lit->second;
        int fi = -1;
        for (int i = static_cast<int>(blockScopes.size()) - 1; i >= 0; --i)
            if (blockScopes[i].block == target) { fi = i; break; }
        if (fi < 0 || fi + 1 >= static_cast<int>(blockScopes.size())) return;  // same scope / not open
        const BlockScope& inner = blockScopes[fi + 1];  // first scope nested inside the label's scope
        emitBlockCleanup(inner.so, inner.df, inner.rg, inner.st);
    }

    void emitBlock(const ast::Block& block, bool newScope = true) {
        const std::size_t soBase = scopeObjects.size();
        const std::size_t dfBase = deferred.size();
        const std::size_t regBase = scopeRegions.size();
        const std::size_t strBase = scopeStrings.size();
        if (blockScopes.empty()) { labelBlock_.clear(); scanLabelBlocks(block); }  // function-body entry
        blockScopes.push_back({&block, soBase, dfBase, regBase, strBase});
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
            if (builder.GetInsertBlock()->getTerminator() == nullptr)
                emitBlockCleanup(soBase, dfBase, regBase, strBase);
            scopeObjects.resize(soBase);
            deferred.resize(dfBase);
            scopeRegions.resize(regBase);
            scopeStrings.resize(strBase);
        }
        blockScopes.pop_back();
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
        freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
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
    // match on a *value* Result/Option (spec 21, value form): dispatch on the i32 tag (Ok/Some = 0,
    // Err/None = 1) instead of a vtable, and bind the payload decoded to the case's declared binding type.
    void emitValueMatch(const ast::MatchStmt& s, llvm::Value* subj) {
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
                if (hadPrior) locals[added] = prior;
            }
            if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
            builder.SetInsertPoint(nextBB);
        }
        if (s.defaultBody) emitBlock(*s.defaultBody);
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(endBB);
        builder.SetInsertPoint(endBB);
    }

    void emitMatch(const ast::MatchStmt& s) {
        llvm::Value* subj = emitExpr(*s.subject);
        if (subj == nullptr) return;
        if (isValueVariant(typeName(*s.subject))) { emitValueMatch(s, subj); return; }
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
            if (mDollar != std::string::npos &&
                classes.count(c.typeName + mSubjBase.substr(mDollar)) > 0)
                caseType = c.typeName + mSubjBase.substr(mDollar);
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
    // Emits a match-expression block arm (spec 16.2): runs the block, where `yield expr;` stores the
    // arm's value into a slot; returns that value at the arm's continuation.
    llvm::Value* emitYieldBlock(const ast::Block& body, llvm::Type* rty, const std::string& rtype) {
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
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(armEnd);
        yieldSlot_ = sSlot;
        yieldEnd_ = sEnd;
        yieldType_ = sTy;
        builder.SetInsertPoint(armEnd);
        return builder.CreateLoad(rty, slot, "matchx.arm.val");
    }

    // Expression form of a *value* Result/Option match: tag dispatch producing a phi (mirrors
    // emitMatchExpr's vtable path, but reads the { tag, payload } value).
    llvm::Value* emitValueMatchExpr(const ast::MatchExpr& s, llvm::Value* subj) {
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
                if (v != nullptr) v = coerce(v, typeName(*c.result), rtype);
            } else {
                v = emitYieldBlock(c.body, rty, rtype);
            }
            if (!added.empty()) {
                locals.erase(added);
                if (hadPrior) locals[added] = prior;
            }
            if (v == nullptr) v = llvm::Constant::getNullValue(rty);
            incoming.push_back({v, builder.GetInsertBlock()});
            builder.CreateBr(endBB);
            builder.SetInsertPoint(nextBB);
        }
        builder.CreateUnreachable();  // sema guarantees a sealed value match is exhaustive
        builder.SetInsertPoint(endBB);
        if (incoming.empty()) return llvm::Constant::getNullValue(rty);
        llvm::PHINode* phi = builder.CreatePHI(rty, static_cast<unsigned>(incoming.size()), "matchx");
        for (auto& in : incoming) phi->addIncoming(in.first, in.second);
        return phi;
    }

    llvm::Value* emitMatchExpr(const ast::MatchExpr& s) {
        llvm::Value* subj = emitExpr(*s.subject);
        if (subj == nullptr) return nullptr;
        if (isValueVariant(typeName(*s.subject))) return emitValueMatchExpr(s, subj);
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
            if (mDollar != std::string::npos &&
                classes.count(c.typeName + mSubjBase.substr(mDollar)) > 0)
                caseType = c.typeName + mSubjBase.substr(mDollar);
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
            llvm::Value* v;
            if (c.result) {
                v = emitExpr(*c.result);
                if (v != nullptr) v = coerce(v, typeName(*c.result), rtype);  // typeName needs bindings
            } else {
                v = emitYieldBlock(c.body, rty, rtype);  // `-> { ... yield ...; }` block arm
            }
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
        } else if (s.defaultBody) {
            llvm::Value* v = emitYieldBlock(*s.defaultBody, rty, rtype);  // `default -> { yield }`
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
        freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
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
        freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
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
        freeStringTemps();  // String RAII: release temporaries built in the condition, before branching
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
        const std::string at = typeName(*s.iterable);
        const std::string cbase = baseType(at);
        // foreach over a collection iterates a snapshot from its toArray() (spec 34): any class with a
        // toArray method is iterable. Arrays are iterated directly.
        const bool isCollection =
            classes.count(cbase) > 0 && functions.count(cbase + ".toArray") > 0;
        // Iterable / Iterator (spec 9.2): a class with no toArray but with `iterator()` (Iterable) or with
        // `hasNext()`/`next()` (Iterator itself) is iterated LAZILY, calling next() one element at a time --
        // no snapshot, so an infinite or expensive sequence works. Interface receivers dispatch virtually.
        if (!isCollection && classes.count(cbase) > 0 && emitForeachIterable(s, cbase)) return;
        llvm::Value* block;
        std::string et;
        if (isCollection) {
            llvm::Value* recv = emitExpr(*s.iterable);
            if (recv == nullptr) return;
            block = builder.CreateCall(functions[cbase + ".toArray"], {recv}, "fe.arr");
            const std::string ret = classes[cbase].methodReturnType.count("toArray") > 0
                                        ? classes[cbase].methodReturnType.at("toArray")
                                        : "";
            et = s.isVar ? (isArrayType(ret) ? ret.substr(0, ret.size() - 2) : ret)
                         : typeRefName(s.elemType);
        } else {
            block = emitExpr(*s.iterable);
            if (block == nullptr) return;
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
        if (et == "boolean") elem = builder.CreateZExt(elem, builder.getInt32Ty());  // i8 slot -> i32 value
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

    // Lazy `foreach` over an Iterable/Iterator (spec 9.2). The subject is either an Iterator itself
    // (it declares hasNext/next) or an Iterable (it declares iterator(), whose result is the Iterator).
    // The loop calls hasNext()/next() one element at a time -- no snapshot -- so a lazy or unbounded
    // sequence works, and an interface-typed subject dispatches through its vtable. Returns false when the
    // type is not iterable this way, so the caller can fall back to the array/toArray paths.
    bool emitForeachIterable(const ast::ForeachStmt& s, const std::string& cbase) {
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
            if (recv == nullptr) return false;
            const std::string owner = methodOwner(cbase, "iterator");
            const std::string ret = classes[clsKey(owner)].methodReturnType.at("iterator");
            itCls = baseType(ret);
            if (methodOwner(itCls, "hasNext").empty() || methodOwner(itCls, "next").empty()) return false;
            itObj = emitDynCall(cbase, "iterator", ptrToPtr, recv);
            ownsIterator = true;  // the loop minted it, so the loop disposes it
        } else {
            return false;
        }
        if (itObj == nullptr) return false;

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
        if (more == nullptr) return false;
        builder.CreateCondBr(builder.CreateICmpNE(more, builder.getInt32(0)), bodyBB, endBB);

        builder.SetInsertPoint(bodyBB);
        if (!s.indexName.empty()) {
            locals[s.indexName] = LocalSlot{iSlot, "int"};
            declareLocalDebug(iSlot, s.indexName, "int", s.loc);
        }
        llvm::Value* it2 = builder.CreateLoad(builder.getPtrTy(), itSlot, "fei.itv2");
        llvm::Value* elem = emitDynCall(itCls, "next", nextTy, it2);
        if (elem == nullptr) return false;
        builder.CreateStore(elem, vSlot);
        loopStack.push_back({endBB, updateBB, pendingLoopLabel, finallyStack.size(),
                             scopeObjects.size(), deferred.size(), scopeRegions.size()});
        pendingLoopLabel.clear();
        emitBlock(s.body);
        loopStack.pop_back();
        if (builder.GetInsertBlock()->getTerminator() == nullptr) builder.CreateBr(updateBB);
        builder.SetInsertPoint(updateBB);
        llvm::Value* iv = builder.CreateLoad(builder.getInt32Ty(), iSlot, "fei.iv");
        builder.CreateStore(builder.CreateAdd(iv, builder.getInt32(1)), iSlot);
        builder.CreateBr(condBB);
        builder.SetInsertPoint(endBB);
        locals.erase(s.varName);
        if (!s.indexName.empty()) locals.erase(s.indexName);
        return true;
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
        // A String subject compares by value (content), not by pointer identity, so a string case
        // literal actually matches (spec 7.3 extension). Other subjects compare as integers.
        const std::string subjType = typeName(*s.subject);
        const bool isStr = (subjType == "String" || subjType == "string");
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

    // The C-ABI signature of an extern declaration (spec 26): a small (1/2/4/8-byte) value struct is
    // passed/returned in a register; a larger one is an error. Shared by namespace-level externs and
    // class extern static methods.
    llvm::FunctionType* externFnType(const std::vector<ast::Param>& params,
                                     const ast::TypeRef& retType, bool variadic, SourceLocation loc) {
        std::vector<llvm::Type*> pts;
        for (const auto& p : params) {
            const std::string pt = typeRefName(p.type);
            if (llvm::Type* reg = ffiStructRegType(pt)) {
                pts.push_back(reg);
            } else {
                if (isFfiByValueStruct(pt))
                    error("FFI by-value struct '" + baseType(pt) +
                              "' must be 1, 2, 4 or 8 bytes; pass larger structs by pointer (spec 26)",
                          loc);
                pts.push_back(llvmType(pt));
            }
        }
        const std::string rt = typeRefName(retType);
        llvm::Type* retTy = ffiStructRegType(rt);
        if (retTy == nullptr) {
            if (isFfiByValueStruct(rt))
                error("FFI by-value struct return '" + baseType(rt) +
                          "' must be 1, 2, 4 or 8 bytes (spec 26)",
                      loc);
            retTy = llvmType(rt);
        }
        return llvm::FunctionType::get(retTy, pts, variadic);
    }

    void declareClasses() {
        // Pass 0: register enums (int-style lowers to i32 ordinals; java-style
        // constants are singletons materialized as instances of a desugared class).
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::EnumDecl& en : ns.enums) {
                    enums[en.name] = en.constants;
                    enumTypeId[en.name] = static_cast<int>(enumTypeId.size());  // stable per-enum tag id
                    if (en.isJavaStyle) javaEnums[en.name] = &en;
                    else if (!en.members.empty()) enumMethodDecls[en.name] = &en;  // catalog enum
                }
                for (const ast::CatalogDecl& cat : ns.catalogs) catalogNames.insert(cat.name);
            }
        }
        // Pass 1: create struct types and record declaration, superclass,
        // interfaces, flags and own members. All names registered first.
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    ClassLayout layout;
                    layout.decl = &cls;
                    layout.imported = bundle.isImported;  // bodies + full layout live in the .ldb
                    layout.dynamic = bundle.isDynamic;    // functions resolved at runtime via thunks
                    layout.bundleName = bundle.name;
                    if (bundle.isPrelude) preludeClasses.insert(cls.name);
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
                                if (!f->affinity.empty()) layout.fieldAffinity[f->name] = f->affinity;
                                if (f->isPersistent) layout.persistOrder.push_back(f->name);
                                if (f->bitWidth > 0) layout.bitFieldWidth[f->name] = f->bitWidth;
                                if (!f->propertySetter.empty())
                                    layout.propertySetters[f->name] = f->propertySetter;
                                if (f->isVolatile) layout.volatileFields.insert(f->name);
                                if (f->isExternal) layout.externalFields.insert(f->name);
                                if (f->isUnique) layout.uniqueFields.insert(f->name);
                                if (f->isTransient) layout.transientFields.insert(f->name);
                                if (f->isLazy && f->init) layout.lazyFieldInit[f->name] = f->init.get();
                            }
                        } else if (const auto* m =
                                       dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            layout.methodReturnType[m->name] = ast::canonicalType(m->returnType);
                            layout.ownMethods[m->name] = m;
                            // A computed property with a custom setter routes `obj.name = v` here.
                            if (!m->propertySetter.empty())
                                layout.propertySetters[m->name] = m->propertySetter;
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
                          l.isInterface || bases.count(name) > 0 || patchedClasses_.count(name) > 0;
        }
        // A patched class (spec 32.8) must dispatch through its vtable even with no subtype: that slot is
        // exactly where the replacement lands, so a direct call would keep running the original. Its
        // subclasses too -- they inherit the patched method, and a devirtualized `poodle.bark()` would
        // walk straight past the replacement installed in Poodle's table.
        for (const std::string& p : patchedClasses_) {
            bases.insert(p);
            for (const auto& [cname, cl] : classes)
                if (derivesFrom(cname, p)) bases.insert(cname);
        }
        subclassed_ = bases;  // remember which types have a subtype, for devirtualization at call sites
        // Adopt the slot layout of imported bundles first, so a virtual call on an imported object
        // hits the slot its baked-in vtable (in the .ldb) uses (spec 2.5 ABI). Fresh local methods
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
        auto fold = [&](const ast::ConstDecl& c, const std::string& owner) {
            const std::string key = owner.empty() ? c.name : owner + "." + c.name;
            const std::string type = typeRefName(c.type);
            namespaceConstTypes[key] = type;
            if (c.init == nullptr) return;
            if (isFloatType(type)) {
                double d;
                if (foldConstDouble(*c.init, d)) constDblVals[key] = d;
            } else {
                long long v;
                if (foldConstInt(*c.init, v)) constIntVals[key] = v;
            }
        };
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ConstDecl& c : ns.consts) fold(c, "");
                for (const ast::ClassDecl& cls : ns.classes)
                    for (const ast::MemberPtr& m : cls.members)
                        if (const auto* c = dynamic_cast<const ast::ConstDecl*>(m.get()))
                            fold(*c, cls.name);
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

    // Prepares the .ldb's symbols for both linking modes. The bundle's own functions are dll-exported
    // so a dynamic consumer resolves them by name (GetProcAddress). Prelude functions are made weak
    // (linkonce_odr): static linking deduplicates them against the program's own prelude, and a
    // dynamically built DLL is self-contained (every class extends the prelude's Object) -- unused
    // prelude functions are then dead-stripped when the DLL is built.
    void exportBundleSymbols() {
        for (llvm::Function& f : module.functions()) {
            if (f.isDeclaration()) continue;
            // Internal helpers such as __ldp3_lambda_N (closure code) are private to the module: they never
            // collide across objects and must keep default storage class (LLVM forbids dllexport on local
            // linkage). Leave them untouched -- do not export or weaken them.
            if (f.hasLocalLinkage()) continue;
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

    // Emits a runtime-resolving thunk for each function of a dynamically-loaded bundle (--use-dynamic).
    // The thunk lazily loads the .ldb (cached in a per-bundle handle global), resolves the symbol, and
    // forwards the call. A missing bundle / unresolved symbol aborts via ldp3_bundle_fail (spec 2.4).
    void emitDynamicThunks() {
        if (dynamicBundles.empty()) return;
        ehPadStack.clear();    // thunks are standalone: no enclosing try / RAII scope
        ehBaseStack.clear();
        scopeObjects.clear();
        llvm::PointerType* ptrTy = builder.getPtrTy();
        llvm::FunctionCallee loadFn = module.getOrInsertFunction(
            "ldp3_bundle_load", llvm::FunctionType::get(ptrTy, {ptrTy, ptrTy, ptrTy}, false));
        llvm::FunctionCallee symFn = module.getOrInsertFunction(
            "ldp3_bundle_sym", llvm::FunctionType::get(ptrTy, {ptrTy, ptrTy}, false));
        llvm::Constant* nullp = llvm::ConstantPointerNull::get(ptrTy);

        for (auto& [cn, cl] : classes) {
            if (!cl.dynamic) continue;
            auto dbit = dynamicBundles.find(cl.bundleName);
            if (dbit == dynamicBundles.end()) continue;
            const std::string& ldbPath = dbit->second.first;
            const auto& fp = dbit->second.second;

            std::vector<std::string> names;  // symbols to thunk: methods + __new + __delete
            if (cl.decl != nullptr)
                for (const ast::MemberPtr& m : cl.decl->members)
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get()))
                        if (!md->isAbstract) names.push_back(cn + "." + md->name);
            if (functions.count(cn + ".__new") != 0) names.push_back(cn + ".__new");
            if (functions.count(cn + ".__delete") != 0) names.push_back(cn + ".__delete");

            for (const std::string& name : names) {
                auto fit = functions.find(name);
                if (fit == functions.end() || !fit->second->isDeclaration()) continue;
                llvm::Function* f = fit->second;
                currentFn = f;
                builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", f));
                llvm::Value* statusSlot = createEntryAlloca("status", builder.getInt32Ty());
                builder.CreateStore(builder.getInt32(0), statusSlot);  // 0 = ok (overwritten on load)

                llvm::GlobalVariable*& hg = dynBundleHandle[cl.bundleName];
                if (hg == nullptr)
                    hg = new llvm::GlobalVariable(module, ptrTy, false,
                                                  llvm::GlobalValue::InternalLinkage, nullp,
                                                  "__dynh_" + cl.bundleName);
                llvm::Value* cur = builder.CreateLoad(ptrTy, hg, "h");
                llvm::BasicBlock* loadBB = llvm::BasicBlock::Create(context, "dyn.load", f);
                llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "dyn.cont", f);
                builder.CreateCondBr(builder.CreateICmpEQ(cur, nullp), loadBB, contBB);

                builder.SetInsertPoint(loadBB);
                llvm::Value* pathS = createGlobalStringPtr(builder,ldbPath, ".dynpath");
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
                for (auto& a : f->args()) args.push_back(&a);
                llvm::Value* r = builder.CreateCall(f->getFunctionType(), sym, args);
                if (f->getReturnType()->isVoidTy())
                    builder.CreateRetVoid();
                else
                    builder.CreateRet(r);
            }
        }
    }

    // Emits one vtable global per concrete polymorphic class: an array of
    // function pointers, one per slot, pointing at the most-derived impl.
    void emitVtables() {
        for (auto& [name, l] : classes) {
            if (!l.hasVtable || l.isAbstract || l.isInterface) continue;  // concrete only
            if (l.imported) continue;  // the bundle baked its own vtable; we dispatch via the object
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
            bool patched = patchedClasses_.count(name) > 0;  // spec 32.8: its slots are rewritten
            for (const std::string& p : patchedClasses_)      // ...and so are its subclasses' (inherited)
                if (derivesFrom(name, p)) patched = true;
            l.vtable = new llvm::GlobalVariable(module, vtType, /*isConstant=*/!patched,
                                                llvm::GlobalValue::PrivateLinkage,
                                                llvm::ConstantArray::get(vtType, entries),
                                                name + ".vtable");
        }
    }

    void declareFunctions() {
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ExternDecl& ex : ns.externs) {  // external C functions (spec 26)
                    llvm::FunctionType* ty =
                        externFnType(ex.params, ex.returnType, ex.isVariadic, ex.loc);
                    functions[ex.name] =
                        llvm::Function::Create(ty, llvm::Function::ExternalLinkage, ex.name, module);
                    externReturnType[ex.name] = typeRefName(ex.returnType);
                }
                for (const ast::ClassDecl& cls : ns.classes) {
                    bool hasCtor = false;
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            if (m == entry.method && !testMode) {
                                // A bare-metal target (triple ...-none...) is booted by an assembly stub, not
                                // a C runtime: emit `kmain(args)` that the stub calls with null -- no
                                // argc/argv and no argv-array construction, so nothing needs libc. A hosted
                                // freestanding program still gets the ordinary `main` (its C runtime calls it).
                                if (moduleTripleStr(module).find("none") != std::string::npos) {
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
                            if (m->isAbstract) continue;  // no body to declare
                            // spec 22.6: a generator's parked body is not a method at all -- it becomes
                            // the four raw functions declared as externs by the synthesized class.
                            if (m->isGeneratorBody) continue;
                            if (m->isExtern) {  // spec 26: links to a C symbol (the simple name)
                                llvm::FunctionType* ety =
                                    externFnType(m->params, m->returnType, m->isVariadic, m->loc);
                                llvm::Function* f = module.getFunction(m->name);
                                if (f == nullptr)
                                    f = llvm::Function::Create(ety, llvm::Function::ExternalLinkage,
                                                               m->name, module);
                                functions[cls.name + "." + m->name] = f;
                                functions[m->name] = f;  // also by bare C symbol, for goto (spec 7.9)
                                externReturnType[cls.name + "." + m->name] =
                                    typeRefName(m->returnType);
                                continue;
                            }
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
                            llvm::Function* fn = llvm::Function::Create(
                                ty, llvm::Function::ExternalLinkage, mangled, module);
                            if (mSret) {
                                sretFns_.insert(fn);
                                sretStructType_[fn] = classes[baseType(mrt)].type;
                            }
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
                    // F9 opaque bundles: a public class exports an allocating constructor (__new) and
                    // a destroying one (__delete). A consumer that imports the class cannot see its
                    // full layout, so it creates/destroys instances through these. Defined in library
                    // mode (its own classes); declared external for imported classes (call the .ldb).
                    if (!cls.isInterface && !cls.isAbstract && cls.visibility == "public" &&
                        (bundle.isImported || libraryMode)) {
                        std::vector<llvm::Type*> np;  // __new params = the constructor's params
                        for (const ast::MemberPtr& m : cls.members)
                            if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
                                for (const auto& p : c->params)
                                    np.push_back(llvmType(typeRefName(p.type)));
                                break;
                            }
                        functions[cls.name + ".__new"] = llvm::Function::Create(
                            llvm::FunctionType::get(builder.getPtrTy(), np, false),
                            llvm::Function::ExternalLinkage, cls.name + ".__new", module);
                        functions[cls.name + ".__delete"] = llvm::Function::Create(
                            llvm::FunctionType::get(builder.getVoidTy(), {builder.getPtrTy()}, false),
                            llvm::Function::ExternalLinkage, cls.name + ".__delete", module);
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
                for (const ast::LiteralDecl& lit : ns.literals) declLiteral(lit);
                for (const ast::ClassDecl& cls : ns.classes)
                    for (const ast::MemberPtr& m : cls.members)
                        if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get()))
                            declLiteral(*lit);
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

    // Does this statement (recursively) whole-assign `this.<field>` -- i.e. a `this.field = ...`
    // that sets the field itself, not a member of it (`this.field.x = ...`)? Mirrors the block-walk
    // used elsewhere (scanAbstained). Used to decide whether a value-struct field needs a default
    // heap allocation so its members can be written before any whole-value assignment.
    bool stmtWholeAssignsField(const ast::Stmt* st, const std::string& field) {
        if (st == nullptr) return false;
        if (const auto* as = dynamic_cast<const ast::AssignStmt*>(st)) {
            const auto* mt = dynamic_cast<const ast::MemberExpr*>(as->target.get());
            if (mt != nullptr && mt->member == field)
                if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mt->object.get()))
                    return id->name == "this";
            return false;
        }
        auto blk = [&](const ast::Block& b) {
            for (const auto& s : b.statements)
                if (stmtWholeAssignsField(s.get(), field)) return true;
            return false;
        };
        if (const auto* i = dynamic_cast<const ast::IfStmt*>(st))
            return blk(i->thenBlock) || (i->elseBlock && blk(*i->elseBlock));
        if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) return blk(w->body);
        if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) return blk(d->body);
        if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) return blk(f->body);
        if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) return blk(fe->body);
        if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
            for (const auto& c : sw->cases) if (blk(c.body)) return true;
            return sw->defaultBody && blk(*sw->defaultBody);
        }
        if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
            for (const auto& c : ms->cases) if (blk(c.body)) return true;
            return ms->defaultBody && blk(*ms->defaultBody);
        }
        if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
            if (blk(tr->body)) return true;
            for (const auto& c : tr->catches) if (blk(c.body)) return true;
            return tr->finallyBlock && blk(*tr->finallyBlock);
        }
        if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) return blk(df->body);
        if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) return blk(us->body);
        if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st))
            return stmtWholeAssignsField(lb->stmt.get(), field);
        return false;
    }
    // True when some constructor of `cls` assigns the whole field (`this.field = ...`), meaning it
    // will set the field itself and no default allocation is needed.
    bool anyCtorWholeAssignsField(const ast::ClassDecl& cls, const std::string& field) {
        for (const auto& m : cls.members)
            if (const auto* ctor = dynamic_cast<const ast::ConstructorDecl*>(m.get()))
                for (const auto& s : ctor->body.statements)
                    if (stmtWholeAssignsField(s.get(), field)) return true;
        return false;
    }

    // Applies every inline field initializer to `thisPtr`, in declaration order.
    // Run at the start of each constructor, before its body (spec 940).
    void emitFieldInits(const ast::ClassDecl& cls, llvm::Value* thisPtr) {
        ClassLayout& layout = classes[cls.name];
        // Null-default owned-type fields (String, value class, array) that have no inline initializer,
        // before running the initializers/body. Heap objects come from malloc, which does not zero, so
        // such a field would otherwise hold garbage until first assigned -- and reassignment now frees
        // the previous owned value (M3), which on a garbage pointer would crash. A null default makes
        // that free null-safe (and reading an unset owned field yields null, not garbage). Borrowed
        // T*/T& fields are left alone (not freed on reassignment, and often perf-critical, e.g. tree
        // links); fields with an inline initializer are set by the loop below.
        for (const ast::MemberPtr& member : cls.members) {
            const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
            if (f == nullptr || f->init || f->isStatic || f->isLazy) continue;
            const std::string ft = typeRefName(f->type);
            if (ft != "String" && !isClassValue(ft) && !isArrayType(ft)) continue;
            auto di = layout.fieldIndex.find(f->name);
            if (di == layout.fieldIndex.end()) continue;
            if (!llvmType(ft)->isPointerTy()) continue;  // only pointer-stored owned fields
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
                builder.CreateCall(memsetFn(), {inst, builder.getInt32(0), sizeOf(sty)});
                builder.CreateStore(
                    inst, builder.CreateStructGEP(layout.type, thisPtr, di->second, f->name));
                continue;
            }
            builder.CreateStore(llvm::ConstantPointerNull::get(builder.getPtrTy()),
                                builder.CreateStructGEP(layout.type, thisPtr, di->second, f->name));
        }
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
        // valueToI64 widens pointers/ints/doubles and boxes a value struct (a value Result/Option), so
        // an async method returning a value Result/Option completes correctly rather than losing it.
        llvm::Value* v = (value == nullptr) ? builder.getInt64(0) : valueToI64(value);
        builder.CreateCall(module.getOrInsertFunction("__ldp3_task_complete", ft), {h, v});
    }

    // Stores the exception carrier on the current async resume's task, so the awaiter re-throws it
    // (spec 21) rather than the exception escaping the resume function and crashing a worker thread.
    void emitTaskCompleteError(llvm::Value* carrier) {
        llvm::FunctionType* ft = llvm::FunctionType::get(
            builder.getVoidTy(), {builder.getInt64Ty(), builder.getInt64Ty()}, false);
        llvm::Value* h = builder.CreatePtrToInt(currentAsyncState, builder.getInt64Ty());
        llvm::Value* c = builder.CreatePtrToInt(carrier, builder.getInt64Ty());
        builder.CreateCall(module.getOrInsertFunction("__ldp3_task_complete_error", ft), {h, c});
    }

    // A catch-all landing pad for an async resume function: if the body throws, record the exception on
    // the task and return normally instead of letting it escape the worker thread. Pushed onto
    // ehPadStack around the body so any uncaught throw unwinds here (defers/using still run first, since
    // the cleanup pads chain into this one). Returns the pad to push.
    llvm::BasicBlock* buildAsyncGuardPad() {
        ensurePersonality();
        llvm::IRBuilderBase::InsertPoint saved = builder.saveIP();
        llvm::PointerType* ptrTy = builder.getPtrTy();
        llvm::BasicBlock* pad = llvm::BasicBlock::Create(context, "async.guard", currentFn);
        if (isItaniumEH()) {
            builder.SetInsertPoint(pad);
            llvm::LandingPadInst* lp = builder.CreateLandingPad(landingPadType(), 1);
            lp->addClause(itaniumVoidPtrTypeInfo());
            llvm::Value* exc = builder.CreateExtractValue(lp, 0, "exc");
            llvm::Value* carrier = builder.CreateCall(cxaBeginCatch(), {exc}, "async.err");
            emitTaskCompleteError(carrier);
            builder.CreateCall(cxaEndCatch(), {});
            builder.CreateRetVoid();
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
    void emitAwaitRethrowCheck(llvm::Value* handle) {
        llvm::FunctionType* ety =
            llvm::FunctionType::get(builder.getInt64Ty(), {builder.getInt64Ty()}, false);
        llvm::Value* err = builder.CreateCall(
            module.getOrInsertFunction("__ldp3_task_error", ety), {handle}, "aw.err");
        llvm::Value* hasErr = builder.CreateICmpNE(err, builder.getInt64(0));
        llvm::BasicBlock* throwBB = llvm::BasicBlock::Create(context, "await.throw", currentFn);
        llvm::BasicBlock* okBB = llvm::BasicBlock::Create(context, "await.ok", currentFn);
        builder.CreateCondBr(hasErr, throwBB, okBB);
        builder.SetInsertPoint(throwBB);
        emitThrowObject(builder.CreateIntToPtr(err, builder.getPtrTy()));
        builder.SetInsertPoint(okBB);
    }

    // Escape analysis for returned locals (mirrors the direct `return new X()` promotion). An object
    // built on the stack and then returned by name -- `T v = new T(); ...; return v;` -- escapes the
    // frame, so its pointer would dangle. Collect every identifier returned anywhere in a body, then
    // promote any matching stack `new` local initializer to the heap. Conservative: over-promotion only
    // moves a would-be-stack object to the heap, which is always safe.
    void collectReturnedNames(const ast::Stmt* st, std::set<std::string>& out) {
        if (st == nullptr) return;
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(st)) {
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(rs->value.get()))
                out.insert(id->name);
            return;
        }
        auto blk = [&](const ast::Block& b) { for (const auto& s : b.statements) collectReturnedNames(s.get(), out); };
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
        if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { collectReturnedNames(lb->stmt.get(), out); return; }
    }
    void promoteEscapingNews(const ast::Stmt* st, const std::set<std::string>& returned) {
        if (st == nullptr) return;
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) {
            if (returned.count(vd->name) > 0)
                if (const auto* cnw = dynamic_cast<const ast::NewExpr*>(vd->init.get()))
                    if (cnw->location == "stack" && cnw->region.empty())
                        const_cast<ast::NewExpr*>(cnw)->location = "heap";
            return;
        }
        auto blk = [&](const ast::Block& b) { for (const auto& s : b.statements) promoteEscapingNews(s.get(), returned); };
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
        if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { promoteEscapingNews(lb->stmt.get(), returned); return; }
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
                  bool asyncResume = false, bool argvEntry = false, const std::string& retTypeName = "") {
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
        auto bsRestore = llvm::make_scope_exit([this, &savedBS, &savedLB]() {
            blockScopes = std::move(savedBS);
            labelBlock_ = std::move(savedLB);
        });
        currentFn = fn;
        currentClass = thisClass;
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
        currentInvariants = invariants;
        currentDtorChain = dtorChainBase;  // a destructor calls its base destructor at each exit
        currentThis = nullptr;
        // An async resume's single argument is the ldp3_task* state (spec 20.2); `return`
        // completes it (see the ReturnStmt codegen) rather than returning a value.
        currentAsyncState = asyncResume ? fn->getArg(0) : nullptr;
        locals.clear();
        scopeObjects.clear();
        scopeRegions.clear();
        scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
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
        labelBlocks.clear();
        llvm::BasicBlock* block = llvm::BasicBlock::Create(context, "entry", fn);
        builder.SetInsertPoint(block);
        // -g: attach a DISubprogram for this function and give the prologue (arg stores, super/field-init
        // calls) the function's opening line, so no instruction in a debug function lacks a location.
        beginDebugFunction(fn, body.loc);
        setDebugLoc(body.loc);

        // Identifiers returned anywhere in the body. Used both to promote returned stack `new`s and to
        // decide whether a copied class-value parameter must live on the heap (it escapes) or the frame.
        std::set<std::string> escaping;
        for (const auto& s : body.statements) collectReturnedNames(s.get(), escaping);
        if (!escaping.empty())
            for (const auto& s : body.statements) promoteEscapingNews(s.get(), escaping);
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
                if (incoming != nullptr && isClassValue(pt) && isCopyDiscipline(pt))
                    incoming = emitClassCopy(pt, incoming, /*heap=*/escaping.count(p.name) > 0);
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
        scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
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
        labelBlocks.clear();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", res));
        llvm::Value* st = res->getArg(0);
        currentAsyncState = builder.CreateLoad(
            builder.getPtrTy(), builder.CreateStructGEP(stateTy, st, 1, "st.task.addr"), "st.task");
        for (std::size_t i = 0; i < m.params.size(); ++i)
            locals[m.params[i].name] = LocalSlot{
                builder.CreateStructGEP(stateTy, st, 2 + i, m.params[i].name),
                typeRefName(m.params[i].type)};
        llvm::BasicBlock* guard = buildAsyncGuardPad();  // a throw completes the task with the error
        ehPadStack.push_back(guard);
        // Sentinel base: the async guard covers the whole body and does its own completion; the in-try
        // block cleanup pass must not inject here, so keep it disabled for this pad.
        ehBaseStack.push_back({static_cast<std::size_t>(-1), static_cast<std::size_t>(-1),
                               static_cast<std::size_t>(-1)});
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

    // Casts a 64-bit task-result slot back to the awaited type T.
    llvm::Value* castTaskResult(llvm::Value* res64, const std::string& t) {
        llvm::Type* tt = llvmType(t);
        if (tt->isPointerTy()) return builder.CreateIntToPtr(res64, tt);
        if (tt->isDoubleTy()) return builder.CreateBitCast(res64, tt);
        if (tt->isIntegerTy()) return builder.CreateIntCast(res64, tt, true);
        if (tt->isAggregateType()) {
            // Unbox the value struct (a value Result/Option) that the async return boxed into the slot.
            llvm::Value* box = builder.CreateIntToPtr(res64, builder.getPtrTy());
            return builder.CreateLoad(tt, box, "task.unbox");
        }
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
    void emitGeneratorMethod(const ast::ClassDecl& cls, const ast::MethodDecl& m) {
        llvm::Function* startF = module.getFunction(m.genSym + "$start");
        llvm::Function* resumeF = module.getFunction(m.genSym + "$resume");
        llvm::Function* currentF = module.getFunction(m.genSym + "$current");
        llvm::Function* freeF = module.getFunction(m.genSym + "$free");
        if (startF == nullptr || resumeF == nullptr || currentF == nullptr || freeF == nullptr)
            return;  // the synthesized class was dropped (e.g. an earlier error): nothing to emit

        std::vector<std::pair<std::string, std::string>> tlocals;
        scanAsyncLocals(m.body, tlocals);  // same scan: every local must live in the state object

        // State layout: {i32 state, T current, self?, params..., locals...}.
        const bool hasSelf = !m.isStatic;
        std::vector<llvm::Type*> fields = {builder.getInt32Ty(), llvmType(m.genElem)};
        if (hasSelf) fields.push_back(builder.getPtrTy());
        const unsigned argBase = static_cast<unsigned>(fields.size());
        for (const auto& p : m.params) fields.push_back(llvmType(typeRefName(p.type)));
        const unsigned localBase = static_cast<unsigned>(fields.size());
        for (const auto& l : tlocals) fields.push_back(llvmType(l.second));
        llvm::StructType* stateTy =
            llvm::StructType::create(context, fields, m.genSym + "$genstate");

        // --- $start: malloc the state, store state=0 and the arguments, hand back the handle.
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", startF));
        llvm::Value* st = builder.CreateCall(mallocFn(), {sizeOf(stateTy)}, "gen.state");
        builder.CreateStore(builder.getInt32(0), builder.CreateStructGEP(stateTy, st, 0));
        for (unsigned i = 0; i < startF->arg_size(); ++i)  // self (if any) then the arguments, in order
            builder.CreateStore(startF->getArg(i), builder.CreateStructGEP(stateTy, st, 2 + i));
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
        currentDtorChain = "";
        locals.clear();
        scopeObjects.clear();
        scopeRegions.clear();
        scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
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
        labelBlocks.clear();
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", resumeF));
        llvm::Value* rst = builder.CreateIntToPtr(resumeF->getArg(0), builder.getPtrTy(), "gen.st");
        if (hasSelf)
            currentThis = builder.CreateLoad(builder.getPtrTy(),
                                             builder.CreateStructGEP(stateTy, rst, 2, "gen.self.addr"),
                                             "gen.self");
        for (std::size_t i = 0; i < m.params.size(); ++i)
            locals[m.params[i].name] =
                LocalSlot{builder.CreateStructGEP(stateTy, rst, argBase + i, m.params[i].name),
                          typeRefName(m.params[i].type)};
        for (std::size_t j = 0; j < tlocals.size(); ++j)
            locals[tlocals[j].first] = LocalSlot{
                builder.CreateStructGEP(stateTy, rst, localBase + j, tlocals[j].first),
                tlocals[j].second};

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
        for (const auto& [idx, blk] : genSMCases) sw->addCase(builder.getInt32(idx), blk);

        genSM = false;
        genSMState = nullptr;
        genSMStatePtr = nullptr;
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
        scopeStrings.clear();  // String RAII: reset per function so a slot never leaks into another's cleanup
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
        llvm::BasicBlock* guard = buildAsyncGuardPad();  // a throw completes the task with the error
        ehPadStack.push_back(guard);
        ehBaseStack.push_back({static_cast<std::size_t>(-1), static_cast<std::size_t>(-1),
                               static_cast<std::size_t>(-1)});  // sentinel: async guard, no in-try inject
        emitBlock(m.body, /*newScope=*/false);  // natural control flow; awaits split their blocks
        ehPadStack.pop_back();
        ehBaseStack.pop_back();
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

    // Collect [Test]-annotated methods (public static, returning boolean) from the user's own code, for the
    // --test runner. A malformed [Test] method is a compile error.
    void collectTests() {
        for (const ast::Bundle& bundle : program.bundles) {
            if (bundle.isImported || bundle.isPrelude) continue;
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    for (const ast::MemberPtr& member : cls.members) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m == nullptr) continue;
                        bool isTest = false;
                        for (const ast::AnnotationUse& a : m->annotations)
                            if (a.name == "Test") isTest = true;
                        if (!isTest) continue;
                        const std::string trt = typeRefName(m->returnType);
                        if (!m->isStatic || (trt != "boolean" && trt != "void")) {
                            errors.push_back(CodegenError{
                                "[Test] method '" + cls.name + "." + m->name +
                                    "' must be a public static method returning boolean (the test's own "
                                    "verdict) or void (the verdict comes from its Test.assert* calls)",
                                m->loc});
                            continue;
                        }
                        // spec 32.11: a void test passes when none of its Test.assert* calls failed.
                        if (trt == "void") voidTests_.insert(cls.name + "." + m->name);
                        testMethods.push_back({cls.name + "." + m->name, m->name});
                    }
                }
            }
        }
    }

    // Emit `int main()` as a runner that calls every collected [Test] method, prints PASS/FAIL per test and
    // a summary, and returns non-zero if any failed. Called after emitFunctions so the test bodies exist.
    void emitTestRunner() {
        llvm::FunctionType* mainTy = llvm::FunctionType::get(builder.getInt32Ty(), {}, false);
        llvm::Function* mainFn =
            llvm::Function::Create(mainTy, llvm::Function::ExternalLinkage, "main", module);
        functions["@entry"] = mainFn;
        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", mainFn));

        llvm::Type* i32 = builder.getInt32Ty();
        llvm::Value* passed = builder.CreateAlloca(i32, nullptr, "passed");
        llvm::Value* failed = builder.CreateAlloca(i32, nullptr, "failed");
        builder.CreateStore(builder.getInt32(0), passed);
        builder.CreateStore(builder.getInt32(0), failed);
        llvm::Value* passFmt = createGlobalStringPtr(builder,"PASS %s\n", ".test.pass");
        llvm::Value* failFmt = createGlobalStringPtr(builder,"FAIL %s\n", ".test.fail");

        for (const auto& [sym, name] : testMethods) {
            const auto it = functions.find(sym);
            if (it == functions.end()) continue;
            llvm::Value* ok = nullptr;
            if (voidTests_.count(sym) > 0) {
                // spec 32.11: `Test.assertEqual(...)` inside a void test records a failure; the test
                // passes if it recorded none. Reset the counter around the call so tests do not bleed.
                auto rit = functions.find("Test.reset");
                auto fit = functions.find("Test.failures");
                if (rit == functions.end() || fit == functions.end()) continue;
                builder.CreateCall(rit->second, {});
                builder.CreateCall(it->second, {});
                llvm::Value* f = builder.CreateCall(fit->second, {}, "t.failures");
                ok = builder.CreateICmpEQ(f, builder.getInt32(0), "ok");
            } else {
                llvm::Value* r = builder.CreateCall(it->second, {}, "t");
                ok = builder.CreateICmpNE(r, builder.getInt32(0), "ok");
            }
            llvm::Value* nameStr = createGlobalStringPtr(builder,name, ".test.name");
            llvm::BasicBlock* thenBB = llvm::BasicBlock::Create(context, "pass", mainFn);
            llvm::BasicBlock* elseBB = llvm::BasicBlock::Create(context, "fail", mainFn);
            llvm::BasicBlock* contBB = llvm::BasicBlock::Create(context, "cont", mainFn);
            builder.CreateCondBr(ok, thenBB, elseBB);
            builder.SetInsertPoint(thenBB);
            builder.CreateCall(printf(), {passFmt, nameStr});
            builder.CreateStore(builder.CreateAdd(builder.CreateLoad(i32, passed), builder.getInt32(1)),
                                passed);
            builder.CreateBr(contBB);
            builder.SetInsertPoint(elseBB);
            builder.CreateCall(printf(), {failFmt, nameStr});
            builder.CreateStore(builder.CreateAdd(builder.CreateLoad(i32, failed), builder.getInt32(1)),
                                failed);
            builder.CreateBr(contBB);
            builder.SetInsertPoint(contBB);
        }
        llvm::Value* sumFmt = createGlobalStringPtr(builder,"tests: %d passed, %d failed\n", ".test.sum");
        llvm::Value* pv = builder.CreateLoad(i32, passed);
        llvm::Value* fv = builder.CreateLoad(i32, failed);
        builder.CreateCall(printf(), {sumFmt, pv, fv});
        builder.CreateRet(builder.CreateSelect(builder.CreateICmpNE(fv, builder.getInt32(0)),
                                               builder.getInt32(1), builder.getInt32(0)));
    }

    void emitFunctions() {
        for (const ast::Bundle& bundle : program.bundles) {
            if (bundle.isImported) continue;  // bodies live in the depended-on .ldb (declared external)
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& cls : ns.classes) {
                    bool hasCtor = false;
                    enclosingClass_ = cls.name;
                    for (const ast::MemberPtr& member : cls.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            enclosingMethod_ = m->name;
                            noBoundsCheck_ = hasAttribute(*m, "no_bounds_check");  // spec 36.4
                            if (m == entry.method && !testMode) {
                                emitBody(functions["@entry"], m->body, m->params, "",
                                         builder.getInt32Ty(), nullptr, nullptr, nullptr, nullptr, false,
                                         nullptr, nullptr, "", nullptr, false,
                                         /*argvEntry=*/moduleTripleStr(module).find("none") ==
                                             std::string::npos);
                            } else if (m->isGeneratorBody) {
                                emitGeneratorMethod(cls, *m);  // spec 22.6: $start/$resume/$current/$free
                            } else if (m->isAsync && !m->isAbstract) {
                                emitAsyncMethod(cls, *m);
                            } else if (!m->isAbstract && !m->isExtern) {  // extern: no LDP3 body
                                emitBody(functions[cls.name + "." + m->name], m->body, m->params,
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
                    // F9 opaque bundles: bodies of the exported __new (malloc the real layout, run the
                    // constructor) and __delete (destruct + free). Library mode only; a consumer just
                    // calls these to create/destroy an instance it cannot lay out itself.
                    if (libraryMode && !cls.isInterface && !cls.isAbstract &&
                        cls.visibility == "public") {
                        llvm::Function* nf = functions[cls.name + ".__new"];
                        currentFn = nf;
                        builder.SetInsertPoint(llvm::BasicBlock::Create(context, "entry", nf));
                        llvm::Value* obj = builder.CreateCall(
                            mallocFn(), {sizeOf(classes[cls.name].type)}, cls.name + ".obj");
                        std::vector<llvm::Value*> cargs{obj};
                        for (auto& a : nf->args()) cargs.push_back(&a);
                        builder.CreateCall(functions[cls.name + "." + cls.name], cargs);
                        builder.CreateRet(obj);

                        llvm::Function* df = functions[cls.name + ".__delete"];
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
                for (const ast::LiteralDecl& lit : ns.literals) emitLiteralBody(lit);
                for (const ast::ClassDecl& cls : ns.classes)
                    for (const ast::MemberPtr& m : cls.members)
                        if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get()))
                            emitLiteralBody(*lit);
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
                                 &m->requiresClauses, &m->ensuresClauses,
                                 nullptr, false, nullptr, nullptr, "", nullptr, false, false,
                                 typeRefName(m->returnType));  // String RAII: copy-on-return key
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
#if LLVM_VERSION_MAJOR >= 21
    impl_->module.setTargetTriple(llvm::Triple(triple));
#else
    impl_->module.setTargetTriple(triple);
#endif
    // Set the target data layout so ABI type alignments are correct. Without it, a layout-less module
    // aligns i64 to 4, and every array/field load emits `load i64 ... align 4` -- which blocks LLVM's
    // SIMD vectorizer on hot reduction loops. These strings are clang's own for x86-64 (i64:64 == 8-byte
    // alignment), so the .ll handed to clang matches its target and needs no realignment. Non-x86-64
    // targets (e.g. bare-metal --target=...) keep the layout clang applies downstream.
    if (triple.find("x86_64") != std::string::npos || triple.find("amd64") != std::string::npos) {
        const bool windows =
            triple.find("windows") != std::string::npos || triple.find("msvc") != std::string::npos;
        impl_->module.setDataLayout(
            windows ? "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
                    : "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128");
    }
}

void CodeGenerator::setLibrary(bool library) { impl_->libraryMode = library; }
void CodeGenerator::setTestMode(bool test) { impl_->testMode = test; }
void CodeGenerator::setDebugInfo(bool debug) { impl_->debugInfo = debug; }

void CodeGenerator::setPatchedClasses(const std::set<std::string>& classes) {
    impl_->patchedClasses_ = classes;
}

void CodeGenerator::seedVtableSlots(const std::vector<std::string>& slotNames) {
    impl_->seededSlots = slotNames;
}

void CodeGenerator::addDynamicBundle(const std::string& bundleName, const std::string& ldbPath,
                                     const std::array<std::uint8_t, 32>& fingerprint) {
    impl_->dynamicBundles[bundleName] = {ldbPath, fingerprint};
}

const std::vector<std::string>& CodeGenerator::vtableSlotNames() const {
    return impl_->methodSlotNames;
}

bool CodeGenerator::generate() {
    if (impl_->entry.method == nullptr && !impl_->libraryMode && !impl_->testMode) {
        errors_.push_back(CodegenError{"no entry point to generate", {}});
        return false;
    }
    if (impl_->debugInfo) impl_->initDebugInfo();  // -g: set up the DIBuilder before any function is emitted
    if (impl_->testMode) impl_->collectTests();
    impl_->declareClasses();
    impl_->collectAbstainedLabels();
    impl_->emitNamespaceConsts();
    impl_->emitStaticFields();
    impl_->declareFunctions();
    // The address table anchors every function, so only emit it when the program actually uses
    // unimport/reimport (spec 30); otherwise it would defeat dead-code elimination below.
    // unimportableClasses was filled by collectAbstainedLabels() above.
    if (!impl_->unimportableClasses.empty())
        impl_->buildFunctionTable();  // address table for physical unimport (spec 30)
    impl_->emitVtables();
    impl_->emitFunctions();
    if (impl_->testMode) impl_->emitTestRunner();  // synthetic @entry that runs the [Test] methods
    impl_->emitDynamicThunks();  // runtime-resolving thunks for --use-dynamic bundles
    impl_->emitSpecializations();  // deferred lambda-specialized method copies (inlinable direct calls)
    if (impl_->libraryMode) impl_->exportBundleSymbols();  // make the .ldb's functions DLL-loadable
    impl_->finalizeDebugInfo();  // -g: resolve all debug metadata before verification
    if (!errors_.empty()) return false;
    impl_->attachTBAA();     // type-based alias metadata: lets LLVM hoist field loads across opaque calls
    impl_->stripDeadCode();  // drop unreferenced prelude/user code from executables

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
            // Skip NESTED self-recursion (e.g. ackermann's ack(m-1, ack(m,n-1)), where a self-call is an
            // argument to another self-call). Its recursive calls take distinct, non-overlapping arguments,
            // so deep inlining only bloats the body without the CSE collapse that makes fib fast -- and the
            // bloat actually makes clang optimize it worse than the small original. Leave those to clang.
            bool nested = false;
            for (llvm::BasicBlock& bb : f)
                for (llvm::Instruction& i : bb)
                    if (auto* cb = llvm::dyn_cast<llvm::CallBase>(&i))
                        if (cb->getCalledFunction() == &f)
                            for (llvm::Value* arg : cb->args())
                                if (auto* ac = llvm::dyn_cast<llvm::CallBase>(arg))
                                    if (ac->getCalledFunction() == &f) nested = true;
            if (nested) continue;
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

std::string CodeGenerator::toBitcode() const {
    std::string out;
    llvm::raw_string_ostream os(out);
    llvm::WriteBitcodeToFile(impl_->module, os);
    os.flush();
    return out;
}

}  // namespace ldp3
