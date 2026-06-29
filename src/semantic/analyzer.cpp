#include "semantic/analyzer.h"

#include "semantic/comptime.h"

#include <algorithm>
#include <functional>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

namespace ldp3 {

namespace {
// Array types are spelled with a trailing "[]" in the analyzer (e.g. "int[]").
bool isArrayType(const std::string& t) {
    return t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0;
}
std::string elementOf(const std::string& t) {
    return isArrayType(t) ? t.substr(0, t.size() - 2) : t;
}
// Pointer/reference types end with '*' or '&' (e.g. "Dog*", "Dog&").
bool isRefType(const std::string& t) {
    return !t.empty() && (t.back() == '*' || t.back() == '&');
}
std::string baseType(const std::string& t) {
    std::string s = t;
    if (!s.empty() && s.back() == '?') s.pop_back();  // strip nullable marker (spec 3.7)
    if (!s.empty() && (s.back() == '*' || s.back() == '&')) s.pop_back();  // strip pointer/reference
    return s;
}
// True if the type is declared `nullable` (canonical "T?").
inline bool isNullableType(const std::string& t) { return !t.empty() && t.back() == '?'; }
std::string typeRefStr(const ast::TypeRef& t) {
    return ast::mangleGeneric(t.name, t.typeArgs) + ast::arrayDimsSuffix(t.arrayDims) +
           (t.isPointer ? "*" : "") + (t.isRef ? "&" : "") + (t.isNullable ? "?" : "");
}
bool isFloatType(const std::string& t) {
    // Normal names: smallfloat(16)/float(32)/double(64)/quadruple(128). Bit-counted float32/float64
    // are freestanding-only aliases (enforced elsewhere).
    return t == "float" || t == "float32" || t == "double" || t == "float64" ||
           t == "smallfloat" || t == "quadruple";
}
bool isIntName(const std::string& t) {
    // Normal: byte/short/int/long (signed), ubyte/ushort/uint/ulong (unsigned). Bit-counted
    // int8..int64/uint8..uint64 are freestanding-only aliases (enforced elsewhere). address: raw.
    return t == "int" || t == "int8" || t == "int16" || t == "int32" || t == "int64" ||
           t == "uint8" || t == "uint16" || t == "uint32" || t == "uint64" || t == "short" ||
           t == "long" || t == "byte" || t == "address" || t == "ubyte" || t == "ushort" ||
           t == "uint" || t == "ulong";
}
unsigned intBits(const std::string& t) {
    if (t == "int8" || t == "uint8" || t == "byte" || t == "ubyte") return 8;
    if (t == "int16" || t == "uint16" || t == "short" || t == "ushort") return 16;
    if (t == "int64" || t == "uint64" || t == "long" || t == "address" || t == "ulong") return 64;
    return 32;
}
bool isNumeric(const std::string& t) { return isIntName(t) || isFloatType(t); }

// True if `init` is an integer literal (optionally negated) whose value fits the integer type
// `target`. A compile-time literal coerces to a narrower type when it fits, so `byte b = 5;` and
// `short s = 300;` are accepted without an explicit cast (the value is known at compile time).
bool intLiteralFits(const ast::Expr& init, const std::string& target) {
    if (!isIntName(target)) return false;
    const ast::Expr* e = &init;
    bool neg = false;
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e); u != nullptr && u->op == "-") {
        neg = true;
        e = u->operand.get();
    }
    const auto* lit = dynamic_cast<const ast::IntLiteralExpr*>(e);
    if (lit == nullptr) return false;
    std::string s;
    for (char c : lit->text) if (c != '_') s += c;
    long long v = 0;
    try {
        if (s.size() > 2 && s[0] == '0' && (s[1] == 'b' || s[1] == 'B'))
            v = std::stoll(s.substr(2), nullptr, 2);
        else
            v = std::stoll(s, nullptr, 0);  // 0x / 0 (octal) / decimal
    } catch (...) {
        return true;  // unparseable here -> don't block; codegen handles the value
    }
    if (neg) v = -v;
    const unsigned bits = intBits(target);
    const bool uns = !target.empty() && target[0] == 'u';
    if (uns) {
        if (v < 0) return false;
        if (bits >= 64) return true;
        return static_cast<unsigned long long>(v) < (1ull << bits);
    }
    if (bits >= 64) return true;
    const long long lo = -(1ll << (bits - 1));
    const long long hi = (1ll << (bits - 1)) - 1;
    return v >= lo && v <= hi;
}

// Whether an `await` (spec 20.2) appears anywhere in an expression / statement / block. Used to
// reject awaiting while holding a mutex (spec 22), which would risk a deadlock.
bool exprHasAwait(const ast::Expr* e);
bool stmtHasAwait(const ast::Stmt* s);
bool blockHasAwait(const ast::Block& b) {
    for (const auto& s : b.statements) if (stmtHasAwait(s.get())) return true;
    return false;
}
bool exprHasAwait(const ast::Expr* e) {
    if (e == nullptr) return false;
    if (dynamic_cast<const ast::AwaitExpr*>(e)) return true;
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e))
        return exprHasAwait(b->lhs.get()) || exprHasAwait(b->rhs.get());
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) return exprHasAwait(u->operand.get());
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        if (exprHasAwait(c->callee.get())) return true;
        for (const auto& a : c->args) if (exprHasAwait(a.get())) return true;
        return false;
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) return exprHasAwait(m->object.get());
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e))
        return exprHasAwait(ix->array.get()) || exprHasAwait(ix->index.get());
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(e))
        return exprHasAwait(nc->lhs.get()) || exprHasAwait(nc->rhs.get());
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) return exprHasAwait(ca->operand.get());
    return false;
}
bool stmtHasAwait(const ast::Stmt* s) {
    if (s == nullptr) return false;
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) return exprHasAwait(vd->init.get());
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) return exprHasAwait(es->expr.get());
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) return exprHasAwait(rs->value.get());
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) return exprHasAwait(as->value.get());
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(s))
        return exprHasAwait(i->cond.get()) || blockHasAwait(i->thenBlock) ||
               (i->elseBlock && blockHasAwait(*i->elseBlock));
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s))
        return exprHasAwait(w->cond.get()) || blockHasAwait(w->body);
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s))
        return blockHasAwait(d->body) || exprHasAwait(d->cond.get());
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) return blockHasAwait(f->body);
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) return blockHasAwait(fe->body);
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) return blockHasAwait(sy->body);
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(s)) {
        if (blockHasAwait(tr->body)) return true;
        for (const auto& c : tr->catches) if (blockHasAwait(c.body)) return true;
        return tr->finallyBlock && blockHasAwait(*tr->finallyBlock);
    }
    return false;
}

// Bit-counted type names exist only in freestanding mode (the normal names are byte/short/int/long,
// ubyte/ushort/uint/ulong, smallfloat/float/double/quadruple). Used to reject them in normal mode.
bool isBitCountedName(const std::string& t) {
    return t == "int8" || t == "int16" || t == "int32" || t == "int64" || t == "uint8" ||
           t == "uint16" || t == "uint32" || t == "uint64" || t == "float32" || t == "float64";
}
// The normal-mode replacement to suggest for a bit-counted name.
std::string normalTypeName(const std::string& t) {
    if (t == "int8") return "byte";
    if (t == "int16") return "short";
    if (t == "int32") return "int";
    if (t == "int64") return "long";
    if (t == "uint8") return "ubyte";
    if (t == "uint16") return "ushort";
    if (t == "uint32") return "uint";
    if (t == "uint64") return "ulong";
    if (t == "float32") return "float";
    if (t == "float64") return "double";
    return t;
}

// SIMD vector types vec2/vec3/vec4 (float32 elements). Width (2/3/4) or 0; lane index or -1.
int vecWidth(const std::string& t) {
    if (t == "vec2") return 2;
    if (t == "vec3") return 3;
    if (t == "vec4") return 4;
    return 0;
}
int vecLane(const std::string& m) {
    if (m == "x" || m == "r") return 0;
    if (m == "y" || m == "g") return 1;
    if (m == "z" || m == "b") return 2;
    if (m == "w" || m == "a") return 3;
    return -1;
}

// Tuple types are spelled "(T0,T1,...)" (spec 22.5).
bool isTupleType(const std::string& t) {
    return t.size() >= 2 && t.front() == '(' && t.back() == ')';
}
// Splits the components of a tuple type, honoring nested parentheses (a
// component may itself be a tuple) so commas inside nested tuples don't split.
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
}  // namespace

// Compile-time constant evaluators (spec 28); defined further below, but declared
// here so const registration (above their definitions) can call them.
static bool evalConstInt(const ast::Expr& e, long long& out,
                         const std::unordered_map<std::string, long long>* consts = nullptr,
                         const std::unordered_map<std::string, const ast::MethodDecl*>* methods =
                             nullptr,
                         const std::unordered_map<std::string, double>* dconsts = nullptr);
static bool evalConstDouble(const ast::Expr& e, double& out,
                            const std::unordered_map<std::string, double>* dconsts,
                            const std::unordered_map<std::string, long long>* iconsts,
                            const std::unordered_map<std::string, const ast::MethodDecl*>* methods =
                                nullptr);

void SemanticAnalyzer::error(std::string message, SourceLocation loc) {
    errors_.push_back(SemaError{std::move(message), loc});
}

void SemanticAnalyzer::warn(std::string message, SourceLocation loc) {
    warnings_.push_back(SemaError{std::move(message), loc});
}

// A statement that can exit or branch out of straight-line flow (so it could break a comefrom loop).
static bool stmtCanExit(const ast::Stmt* st) {
    return dynamic_cast<const ast::ReturnStmt*>(st) != nullptr ||
           dynamic_cast<const ast::BreakStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ContinueStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ThrowStmt*>(st) != nullptr ||
           dynamic_cast<const ast::GotoStmt*>(st) != nullptr ||
           dynamic_cast<const ast::IfStmt*>(st) != nullptr ||
           dynamic_cast<const ast::WhileStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ForStmt*>(st) != nullptr ||
           dynamic_cast<const ast::ForeachStmt*>(st) != nullptr ||
           dynamic_cast<const ast::DoWhileStmt*>(st) != nullptr ||
           dynamic_cast<const ast::SwitchStmt*>(st) != nullptr ||
           dynamic_cast<const ast::MatchStmt*>(st) != nullptr ||
           dynamic_cast<const ast::TryStmt*>(st) != nullptr;
}

// Best-effort warning for an obvious infinite loop via comefrom (spec 7.10 rule 7): a `comefrom X`
// preceded in the SAME block by `label X` with nothing that can exit between them branches back
// forever. (The retry pattern -- label at one level, comefrom inside a try/catch -- spans blocks
// and is not flagged.) Recurses into nested blocks to catch loops contained within them.
void SemanticAnalyzer::detectComefromLoops(const ast::Block& block) {
    for (std::size_t i = 0; i < block.statements.size(); ++i) {
        const ast::Stmt* st = block.statements[i].get();
        if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(st)) {
            for (std::size_t j = i; j-- > 0;) {
                const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(block.statements[j].get());
                if (lm == nullptr || lm->name != cf->name) continue;
                bool clear = true;
                for (std::size_t k = j + 1; k < i && clear; ++k)
                    if (stmtCanExit(block.statements[k].get())) clear = false;
                if (clear)
                    warn("comefrom '" + cf->name +
                             "' loops back with no exit between its label and itself: infinite loop "
                             "(spec 7.10)",
                         cf->loc);
                break;
            }
        }
        auto rec = [&](const ast::Block& b) { detectComefromLoops(b); };
        if (const auto* iff = dynamic_cast<const ast::IfStmt*>(st)) { rec(iff->thenBlock); if (iff->elseBlock) rec(*iff->elseBlock); }
        else if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) rec(w->body);
        else if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) rec(d->body);
        else if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) rec(f->body);
        else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) rec(fe->body);
        else if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) { for (auto& c : sw->cases) rec(c.body); if (sw->defaultBody) rec(*sw->defaultBody); }
        else if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) { for (auto& c : ms->cases) rec(c.body); if (ms->defaultBody) rec(*ms->defaultBody); }
        else if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) { rec(tr->body); for (auto& c : tr->catches) rec(c.body); if (tr->finallyBlock) rec(*tr->finallyBlock); }
        else if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) rec(df->body);
        else if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) rec(us->body);
    }
}

const ClassInfo* SemanticAnalyzer::lookupClass(const std::string& name) const {
    auto it = classes_.find(name);
    return it == classes_.end() ? nullptr : &it->second;
}

const FieldInfo* SemanticAnalyzer::findField(const std::string& className,
                                             const std::string& field) const {
    const ClassInfo* c = lookupClass(baseType(className));  // see through T* / T&
    while (c != nullptr) {
        auto it = c->fields.find(field);
        if (it != c->fields.end()) return &it->second;
        if (c->superclass.empty()) break;
        c = lookupClass(c->superclass);
    }
    return nullptr;
}

const MethodInfo* SemanticAnalyzer::findMethod(const std::string& className,
                                               const std::string& method) const {
    const ClassInfo* c = lookupClass(baseType(className));  // see through T* / T&
    while (c != nullptr) {
        auto it = c->methods.find(method);
        if (it != c->methods.end()) return &it->second;
        for (const std::string& iface : c->interfaces) {
            const MethodInfo* m = findMethod(iface, method);
            if (m != nullptr) return m;
        }
        if (c->superclass.empty()) break;
        c = lookupClass(c->superclass);
    }
    return nullptr;
}

// The enums that implement `catalog` (directly or through a catalog it extends), spec 12.4.
std::vector<std::string> SemanticAnalyzer::catalogImplementers(const std::string& catalog) const {
    std::vector<std::string> out;
    for (const auto& [name, _] : enums_)
        if (isSubtype(name, catalog)) out.push_back(name);
    return out;
}

bool SemanticAnalyzer::isSubtype(const std::string& sub, const std::string& super, int depth) const {
    if (sub == super) return true;
    // Guard against a cyclic type graph (e.g. `catalog A extends B; B extends A`):
    // bound the recursion so a malformed program errors instead of overflowing.
    if (depth > 256) return false;
    // null binds ONLY to a `nullable T` target -- never to a non-nullable type, whatever its kind
    // (spec 3.7 -- the core null-safety rule: non-null by default; `nullable` opts a type into null).
    if (sub == "null") return isNullableType(super);
    // Nullability (spec 3.7): a `nullable T` value may not flow into a non-nullable target (you must
    // check it first); a non-null value flows freely into a `nullable T`. Compare the underlying T.
    if (isNullableType(sub) || isNullableType(super)) {
        if (isNullableType(sub) && !isNullableType(super)) return false;
        auto strip = [](const std::string& s) {
            return isNullableType(s) ? s.substr(0, s.size() - 1) : s;
        };
        return isSubtype(strip(sub), strip(super), depth + 1);
    }
    // String (immutable) and string (mutable) share a representation; they interconvert freely until
    // the immutability discipline is enforced (spec 4).
    if ((sub == "String" || sub == "string") && (super == "String" || super == "string")) return true;
    // Every value is an Object (spec 3.4): a primitive becomes one by boxing, a class by inheritance
    // (every class now extends Object, handled by the hierarchy walk below).
    if (super == "Object" && (isNumeric(sub) || sub == "boolean" || sub == "char")) return true;
    // int and float both widen to a float type (no implicit narrowing).
    if (isFloatType(super) && isNumeric(sub)) return true;
    // Integers widen to a wider integer (no implicit narrowing).
    if (isIntName(sub) && isIntName(super)) return intBits(sub) <= intBits(super);
    // Pointer/reference compatibility follows the pointee (T*, T& and T mix
    // freely for now; the strict value-vs-reference rules land with deep copy).
    if (isRefType(sub) || isRefType(super))
        return isSubtype(baseType(sub), baseType(super), depth + 1);
    // An enum is a subtype of every catalog it extends (spec 12.4), transitively
    // through catalog->catalog extends.
    if (auto ecit = enumCatalogs_.find(sub); ecit != enumCatalogs_.end()) {
        for (const std::string& cat : ecit->second) {
            if (cat == super || isSubtype(cat, super, depth + 1)) return true;
        }
    }
    // A catalog is a subtype of every catalog it extends.
    if (auto ccit = catalogs_.find(sub); ccit != catalogs_.end()) {
        for (const std::string& cat : ccit->second.extendsCatalogs) {
            if (cat == super || isSubtype(cat, super, depth + 1)) return true;
        }
    }
    // Generic variance (spec 15.3): two instantiations of the same generic relate per
    // the declared variance of each type parameter (covariant `out`, contravariant
    // `in`, invariant otherwise). Instantiations are mangled "Base$arg[$arg...]".
    if (const auto subD = sub.find('$'), supD = super.find('$');
        subD != std::string::npos && supD != std::string::npos &&
        sub.compare(0, subD, super, 0, supD) == 0) {
        if (auto vit = genericVariance_.find(sub.substr(0, subD)); vit != genericVariance_.end()) {
            auto split = [](const std::string& s) {
                std::vector<std::string> out;
                std::size_t i = 0;
                while (i < s.size()) {
                    std::size_t j = s.find('$', i);
                    if (j == std::string::npos) j = s.size();
                    out.push_back(s.substr(i, j - i));
                    i = j + 1;
                }
                return out;
            };
            const std::vector<std::string> subArgs = split(sub.substr(subD + 1));
            const std::vector<std::string> supArgs = split(super.substr(supD + 1));
            if (subArgs.size() == supArgs.size() && subArgs.size() == vit->second.size()) {
                bool ok = true;
                for (std::size_t i = 0; i < subArgs.size() && ok; ++i) {
                    if (subArgs[i] == supArgs[i]) continue;
                    const std::string& var = vit->second[i];
                    if (var == "out") ok = isSubtype(subArgs[i], supArgs[i], depth + 1);
                    else if (var == "in") ok = isSubtype(supArgs[i], subArgs[i], depth + 1);
                    else ok = false;  // invariant: arguments must be identical
                }
                if (ok) return true;
            }
        }
    }
    const ClassInfo* c = lookupClass(sub);
    if (c == nullptr) return false;
    if (!c->superclass.empty() && isSubtype(c->superclass, super, depth + 1)) return true;
    for (const std::string& iface : c->interfaces) {
        if (isSubtype(iface, super, depth + 1)) return true;
    }
    return false;
}

bool SemanticAnalyzer::isPolymorphic(const std::string& name) const {
    const ClassInfo* c = lookupClass(name);
    if (c == nullptr) return false;
    if (c->isAbstract || c->isInterface || !c->superclass.empty() || !c->interfaces.empty())
        return true;
    for (const auto& [n, info] : classes_) {
        (void)n;
        if (info.superclass == name) return true;
        for (const std::string& i : info.interfaces)
            if (i == name) return true;
    }
    return false;
}

void SemanticAnalyzer::validateHierarchy() {
    // The permitted variants of every sealed type. Match exhaustiveness assumes a
    // closed world, so these are effectively final: a subclass of a variant would
    // have a distinct vtable and escape the exact-vtable arm checks (UB on no match).
    std::unordered_set<std::string> sealedVariants;
    for (const auto& [name, info] : classes_) {
        (void)name;
        if (info.isSealed)
            for (const std::string& p : info.permits) sealedVariants.insert(p);
    }
    for (const auto& [name, info] : classes_) {
        if (!info.superclass.empty()) {
            const ClassInfo* sup = lookupClass(info.superclass);
            const std::string supBare =
                baseType(info.superclass).substr(0, baseType(info.superclass).find('$'));
            if (sealedVariants.count(supBare) > 0) {
                error("class '" + name + "' cannot extend '" + info.superclass +
                          "', a sealed variant (sum-type variants are final)",
                      {});
            }
            if (sup == nullptr) {
                error("class '" + name + "' extends unknown type '" + info.superclass + "'", {});
            } else if (sup->isInterface) {
                error("class '" + name + "' extends interface '" + info.superclass +
                          "' (use 'implements')",
                      {});
            } else if (sup->isStruct) {
                error("class '" + name + "' extends struct '" + info.superclass +
                          "' (structs have no inheritance)",
                      {});
            } else if (sup->isFinal) {
                error("class '" + name + "' cannot extend final class '" + info.superclass + "'",
                      {});
            } else if (sup->isSealed &&
                       std::find(sup->permits.begin(), sup->permits.end(),
                                 name.substr(0, name.find('$'))) == sup->permits.end()) {
                // ^ permits hold bare names (Ok, Err); a monomorphized subclass is Ok$int$int.
                error("class '" + name + "' cannot extend sealed '" + info.superclass +
                          "' (not in its permits list)",
                      {});
            }
        }
        for (const std::string& iface : info.interfaces) {
            const ClassInfo* i = lookupClass(iface);
            if (i == nullptr) {
                error("'" + name + "' implements unknown type '" + iface + "'", {});
            } else if (!i->isInterface) {
                error("'" + name + "' implements '" + iface + "', which is not an interface", {});
            }
        }
        // Inheritance cycle detection via the superclass chain.
        std::string cur = info.superclass;
        const int limit = static_cast<int>(classes_.size()) + 1;
        for (int steps = 0; !cur.empty() && steps <= limit; ++steps) {
            if (cur == name) {
                error("inheritance cycle involving class '" + name + "'", {});
                break;
            }
            const ClassInfo* c = lookupClass(cur);
            if (c == nullptr) break;
            cur = c->superclass;
        }
    }
}

void SemanticAnalyzer::collectMethodNamesInto(const std::string& className,
                                              std::vector<std::string>& out) const {
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) return;
    for (const auto& [mname, mi] : c->methods) {
        (void)mi;
        if (std::find(out.begin(), out.end(), mname) == out.end()) out.push_back(mname);
    }
    if (!c->superclass.empty()) collectMethodNamesInto(c->superclass, out);
    for (const std::string& iface : c->interfaces) collectMethodNamesInto(iface, out);
}

void SemanticAnalyzer::validateOverrides(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                const ClassInfo* ci = lookupClass(cls.name);
                if (ci == nullptr) continue;

                // Does any superclass / interface declare `method`?
                auto inheritedHas = [&](const std::string& method) {
                    if (!ci->superclass.empty() && findMethod(ci->superclass, method) != nullptr) {
                        return true;
                    }
                    for (const std::string& iface : ci->interfaces) {
                        if (findMethod(iface, method) != nullptr) return true;
                    }
                    return false;
                };

                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isStatic) continue;
                    const bool inherited = inheritedHas(m->name);
                    if (m->isOverride && !inherited) {
                        error("method '" + m->name +
                                  "' is marked 'override' but does not override anything",
                              m->loc);
                    }
                    if (!m->isOverride && !m->isAbstract && inherited) {
                        error("method '" + m->name +
                                  "' overrides an inherited method; mark it 'override'",
                              m->loc);
                    }
                    // A `final` inherited method may not be overridden.
                    if (inherited) {
                        const MethodInfo* base = nullptr;
                        if (!ci->superclass.empty()) base = findMethod(ci->superclass, m->name);
                        for (const std::string& iface : ci->interfaces)
                            if (base == nullptr) base = findMethod(iface, m->name);
                        if (base != nullptr && base->isFinal)
                            error("method '" + m->name + "' cannot override final method '" +
                                      m->name + "'",
                                  m->loc);
                    }
                }

                // A concrete class must implement every abstract method it inherits.
                if (!ci->isAbstract && !ci->isInterface) {
                    std::vector<std::string> names;
                    collectMethodNamesInto(cls.name, names);
                    for (const std::string& mname : names) {
                        const MethodInfo* mi = findMethod(cls.name, mname);
                        if (mi != nullptr && mi->isAbstract) {
                            error("class '" + cls.name + "' must implement abstract method '" +
                                      mname + "'",
                                  cls.loc);
                        }
                    }
                }
            }
        }
    }
}

void SemanticAnalyzer::pushScope() { scopes_.emplace_back(); }

void SemanticAnalyzer::popScope() {
    if (!scopes_.empty()) scopes_.pop_back();
}

const LocalVar* SemanticAnalyzer::lookupLocal(const std::string& name) const {
    for (auto it = scopes_.rbegin(); it != scopes_.rend(); ++it) {
        auto found = it->find(name);
        if (found != it->end()) return &found->second;
    }
    return nullptr;
}

void SemanticAnalyzer::declareLocal(const std::string& name, LocalVar info) {
    scopes_.back()[name] = std::move(info);
}

bool SemanticAnalyzer::isValidMainSignature(const ast::MethodDecl& method) const {
    if (method.visibility != "public") return false;
    if (!method.isStatic) return false;
    if (method.params.size() != 1) return false;
    const ast::Param& p = method.params.front();
    if (p.type.name != "string" || !p.type.isArray) return false;
    if (method.returnType.isArray) return false;
    return method.returnType.name == "void" || method.returnType.name == "int";
}

// ---- Pass 1: collect every class's fields, methods and constructor. ----
void SemanticAnalyzer::registerClasses(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                if (classes_.count(cls.name) > 0) {
                    error("redeclaration of class '" + cls.name + "'", cls.loc);
                    continue;
                }
                ClassInfo info;
                info.name = cls.name;
                info.superclass = cls.superclass;
                info.interfaces = cls.interfaces;
                info.isAbstract = cls.isAbstract;
                info.isFinal = cls.isFinal;
                info.isInterface = cls.isInterface;
                info.isStruct = cls.isStruct;
                info.isSealed = cls.isSealed;
                info.permits = cls.permits;
                info.isMovable = cls.isMovable;
                info.isUnique = cls.isUnique;
                info.isPartitionable = cls.isPartitionable;
                // `unique` + `partitionable` is contradictory (spec 19.9): unique keeps a
                // single live reference to the whole object; partitionable hands out
                // independent references to its parts.
                if (cls.isUnique && cls.isPartitionable)
                    error("'unique' and 'partitionable' are contradictory: 'unique' guarantees a "
                          "single live reference to the whole object, 'partitionable' allows moving "
                          "its fields separately (spec 19.9)",
                          cls.loc);
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        // A movable/unique field is reassignable (it is moved out and reassigned).
                        info.fields[f->name] =
                            FieldInfo{typeRefStr(f->type), f->isMutable || f->isMovable || f->isUnique,
                                      f->isStatic, f->isMovable, f->isUnique};
                    } else if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        MethodInfo mi{typeRefStr(m->returnType), m->isStatic,
                                      m->isAbstract, m->isProperty,
                                      m->params.size(), m->isFinal, m->isAsync};
                        for (const ast::Param& p : m->params) mi.paramTypes.push_back(typeRefStr(p.type));
                        info.methods[m->name] = std::move(mi);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        info.hasConstructor = true;
                        if (!c->params.empty()) info.ctorHasParams = true;
                        for (const ast::Param& p : c->params)
                            info.ctorParamTypes.push_back(typeRefStr(p.type));
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) != nullptr) {
                        info.hasDestructor = true;
                    }
                }
                classes_[cls.name] = std::move(info);
                typeNamespace_[cls.name] = ns.name;
            }
        }
    }
}

void SemanticAnalyzer::registerNewtypes(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::TypeAliasDecl& a : ns.typeAliases) {
                if (!a.isNewtype) continue;  // `typealias` is resolved before sema; only newtypes survive
                if (newtypes_.count(a.name) > 0 || classes_.count(a.name) > 0 ||
                    enums_.count(a.name) > 0) {
                    error("redeclaration of type '" + a.name + "'", a.loc);
                    continue;
                }
                const std::string under = typeRefStr(a.target);
                checkBitCounted(under, a.target.loc);  // newtype over int64 etc. is freestanding-only
                newtypes_[a.name] = under;
            }
        }
    }
}

void SemanticAnalyzer::registerAnnotations(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::AnnotationDecl& a : ns.annotationDecls) {
                if (annotations_.count(a.name) > 0 || classes_.count(a.name) > 0 ||
                    enums_.count(a.name) > 0 || newtypes_.count(a.name) > 0) {
                    error("redeclaration of type '" + a.name + "'", a.loc);
                    continue;
                }
                AnnotationInfo info;
                info.isCompileTimeProcessor = a.isCompileTimeProcessor;
                std::unordered_set<std::string> seen;
                for (const ast::AnnotationField& f : a.fields) {
                    if (!seen.insert(f.name).second) {
                        error("duplicate field '" + f.name + "' in annotation '" + a.name + "'",
                              f.loc);
                        continue;
                    }
                    info.fields.emplace_back(f.name, typeRefStr(f.type));
                    if (f.defaultValue == nullptr) info.required.insert(f.name);
                }
                annotations_[a.name] = std::move(info);
            }
        }
    }
}

// Validates one declaration's applied annotations against the declared annotation types (spec 14.3):
// the annotation must exist, every named argument must be a real field, with no duplicates, and
// every required field (one without a default) must be supplied.
void SemanticAnalyzer::checkAnnotationUses(const std::vector<ast::AnnotationUse>& uses) {
    for (const ast::AnnotationUse& use : uses) {
        if (use.name == "CompileTimeProcessor") {  // built-in (spec 14.4): a marker, takes no args
            if (!use.args.empty())
                error("'[CompileTimeProcessor]' takes no arguments", use.loc);
            continue;
        }
        auto it = annotations_.find(use.name);
        if (it == annotations_.end()) {
            error("unknown annotation '" + use.name + "'", use.loc);
            continue;
        }
        const AnnotationInfo& info = it->second;
        std::unordered_set<std::string> provided;
        for (const ast::AnnotationArg& arg : use.args) {
            const bool isField = std::any_of(info.fields.begin(), info.fields.end(),
                                             [&](const auto& f) { return f.first == arg.name; });
            if (!isField) {
                error("annotation '" + use.name + "' has no field '" + arg.name + "'", arg.loc);
                continue;
            }
            if (!provided.insert(arg.name).second)
                error("duplicate argument '" + arg.name + "' for annotation '" + use.name + "'",
                      arg.loc);
        }
        for (const std::string& req : info.required)
            if (provided.count(req) == 0)
                error("annotation '" + use.name + "' requires a value for field '" + req + "'",
                      use.loc);
    }
}

void SemanticAnalyzer::validateAnnotations(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                checkAnnotationUses(c.annotations);
                for (const ast::MemberPtr& m : c.members) {
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get()))
                        checkAnnotationUses(md->annotations);
                    else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get()))
                        checkAnnotationUses(fd->annotations);
                }
            }
        }
    }
}

void SemanticAnalyzer::registerEnums(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ExternDecl& ex : ns.externs) {  // external C functions (spec 26)
                // A namespace-level extern is a free declaration outside a class; an extern must be a
                // static class member (`public extern <conv> static method ...`). Still registered so
                // its uses resolve and do not cascade.
                error("an 'extern' declaration must be a static class member; declare it inside a "
                      "class",
                      ex.loc);
                externReturns_[ex.name] = typeRefStr(ex.returnType);
                externParamCount_[ex.name] = ex.params.size();
            }
            // A class extern method is reachable by its bare C symbol for `goto` (spec 7.9).
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& m : cls.members)
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
                        md != nullptr && md->isExtern) {
                        externReturns_[md->name] = typeRefStr(md->returnType);
                        externParamCount_[md->name] = md->params.size();
                    }
            for (const ast::EnumDecl& en : ns.enums) {
                // A java-style enum is desugared into a class of the same name, so
                // its matching class entry is expected; only flag other clashes.
                if (enums_.count(en.name) > 0 || catalogs_.count(en.name) > 0 ||
                    (!en.isJavaStyle && classes_.count(en.name) > 0)) {
                    error("redeclaration of type '" + en.name + "'", en.loc);
                    continue;
                }
                // Reject duplicate constant names (own constants and byCatalog values share
                // one ordinal space; a repeat would create a hidden, unreachable constant).
                for (std::size_t i = 0; i < en.constants.size(); ++i)
                    for (std::size_t j = i + 1; j < en.constants.size(); ++j)
                        if (en.constants[i] == en.constants[j])
                            error("duplicate enum constant '" + en.constants[i] + "' in enum '" +
                                      en.name + "'",
                                  en.loc);
                enums_[en.name] = en.constants;
                if (!en.extendsCatalogs.empty()) enumCatalogs_[en.name] = en.extendsCatalogs;
                // Methods declared on the enum (e.g. catalog method impls) -- recorded so
                // `value.method()` resolves and the bodies get type-checked.
                for (const ast::MemberPtr& member : en.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        enumMethods_[en.name][m->name] =
                            MethodInfo{typeRefStr(m->returnType), m->isStatic, m->isAbstract,
                                       m->isProperty};
                        enumMethodParams_[en.name][m->name] = m->params.size();
                    }
                }
                typeNamespace_[en.name] = ns.name;
            }
        }
    }
}

// Registers each catalog's value/method contract so enums can implement it and
// catalog types participate in subtyping (spec 12.3).
void SemanticAnalyzer::registerCatalogs(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::CatalogDecl& cat : ns.catalogs) {
                if (catalogs_.count(cat.name) > 0 || classes_.count(cat.name) > 0 ||
                    enums_.count(cat.name) > 0) {
                    error("redeclaration of type '" + cat.name + "'", cat.loc);
                    continue;
                }
                // Reject duplicate required-value names in the catalog itself.
                for (std::size_t i = 0; i < cat.requiredValues.size(); ++i)
                    for (std::size_t j = i + 1; j < cat.requiredValues.size(); ++j)
                        if (cat.requiredValues[i] == cat.requiredValues[j])
                            error("duplicate catalog value '" + cat.requiredValues[i] +
                                      "' in catalog '" + cat.name + "'",
                                  cat.loc);
                CatalogInfo info;
                info.requiredValues = cat.requiredValues;
                info.extendsCatalogs = cat.extendsCatalogs;
                for (const ast::MemberPtr& member : cat.methods) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        info.methodNames.push_back(m->name);
                    }
                }
                catalogs_[cat.name] = std::move(info);
                typeNamespace_[cat.name] = ns.name;
            }
        }
    }
}

// Validates that every enum implementing a catalog satisfies its contract: the
// catalog exists, the `byCatalog` block covers exactly the required values, and
// every required method is implemented (spec 12.4). Also checks catalog->catalog
// extends targets exist.
void SemanticAnalyzer::validateCatalogs(const ast::Program& program) {
    // Catalog `extends` targets must be catalogs.
    for (const auto& [name, info] : catalogs_) {
        for (const std::string& parent : info.extendsCatalogs) {
            if (catalogs_.count(parent) == 0) {
                error("catalog '" + name + "' extends unknown catalog '" + parent + "'", {});
            }
        }
    }
    // A catalog `extends` cycle makes the contract ill-defined (and would make the
    // transitive walk below loop). Detect and report it (cf. class cycle detection).
    for (const auto& [name, info] : catalogs_) {
        std::unordered_set<std::string> visited;
        std::vector<std::string> stack(info.extendsCatalogs.begin(), info.extendsCatalogs.end());
        bool cyclic = false;
        while (!stack.empty()) {
            const std::string cur = stack.back();
            stack.pop_back();
            if (cur == name) { cyclic = true; break; }
            if (!visited.insert(cur).second) continue;
            if (auto it = catalogs_.find(cur); it != catalogs_.end())
                for (const auto& p : it->second.extendsCatalogs) stack.push_back(p);
        }
        if (cyclic) error("catalog cycle involving '" + name + "'", {});
    }
    // Collects a catalog's required values and methods transitively through its
    // `extends` parents (deduped); the visited set bounds it against any cycle.
    std::function<void(const std::string&, std::unordered_set<std::string>&,
                       std::vector<std::string>&, std::vector<std::string>&)>
        collect = [&](const std::string& catName, std::unordered_set<std::string>& seen,
                      std::vector<std::string>& vals, std::vector<std::string>& meths) {
            if (!seen.insert(catName).second) return;
            auto cit = catalogs_.find(catName);
            if (cit == catalogs_.end()) return;
            for (const auto& v : cit->second.requiredValues)
                if (std::find(vals.begin(), vals.end(), v) == vals.end()) vals.push_back(v);
            for (const auto& m : cit->second.methodNames)
                if (std::find(meths.begin(), meths.end(), m) == meths.end()) meths.push_back(m);
            for (const auto& parent : cit->second.extendsCatalogs)
                collect(parent, seen, vals, meths);
        };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::EnumDecl& en : ns.enums) {
                if (en.extendsCatalogs.empty()) {
                    if (!en.byCatalogValues.empty()) {
                        error("enum '" + en.name +
                                  "' has a 'byCatalog' block but does not extend any catalog",
                              en.loc);
                    }
                    continue;
                }
                // Gather the transitive contract (values + methods) of every catalog the
                // enum extends, including grandparents reached via catalog->catalog extends.
                std::vector<std::string> requiredValues;
                std::vector<std::string> requiredMethods;
                std::unordered_set<std::string> seen;
                for (const std::string& catName : en.extendsCatalogs) {
                    if (catalogs_.count(catName) == 0) {
                        error("enum '" + en.name + "' extends unknown catalog '" + catName + "'",
                              en.loc);
                        continue;
                    }
                    collect(catName, seen, requiredValues, requiredMethods);
                }
                // byCatalog must cover exactly the required values: none missing, none extra.
                for (const std::string& req : requiredValues) {
                    if (std::find(en.byCatalogValues.begin(), en.byCatalogValues.end(), req) ==
                        en.byCatalogValues.end()) {
                        error("enum '" + en.name +
                                  "' must provide catalog value '" + req + "' in its 'byCatalog' block",
                              en.loc);
                    }
                }
                for (const std::string& provided : en.byCatalogValues) {
                    if (std::find(requiredValues.begin(), requiredValues.end(), provided) ==
                        requiredValues.end()) {
                        error("enum '" + en.name + "' lists '" + provided +
                                  "' in 'byCatalog', but no extended catalog requires it",
                              en.loc);
                    }
                }
                // Every required method must be implemented as a (non-static) instance
                // method of the enum -- a catalog method receives the enum value as `this`.
                for (const std::string& req : requiredMethods) {
                    const ast::MethodDecl* impl = nullptr;
                    for (const ast::MemberPtr& member : en.members) {
                        const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                        if (m != nullptr && m->name == req) { impl = m; break; }
                    }
                    if (impl == nullptr) {
                        error("enum '" + en.name + "' must implement catalog method '" + req + "'",
                              en.loc);
                    } else if (impl->isStatic) {
                        error("enum '" + en.name + "' implements catalog method '" + req +
                                  "' as static; catalog methods are instance methods",
                              impl->loc);
                    }
                }
            }
        }
    }
}

// ---- Pass 2: locate the single entry point (spec section 2.9). ----
void SemanticAnalyzer::findEntryPoint(const ast::Program& program) {
    std::vector<EntryPoint> candidates;
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.visibility != "public") continue;
        for (const ast::Namespace& ns : bundle.namespaces) {
            if (ns.visibility != "public") continue;
            for (const ast::ClassDecl& cls : ns.classes) {
                if (cls.visibility != "public" || cls.name != "Main") continue;
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* method = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (method == nullptr || method->name != "main") continue;
                    if (isValidMainSignature(*method)) {
                        EntryPoint ep;
                        ep.method = method;
                        ep.qualifiedName =
                            bundle.name + "." + ns.name + "." + cls.name + "." + method->name;
                        candidates.push_back(std::move(ep));
                    }
                }
            }
        }
    }
    if (candidates.empty()) {
        if (libraryMode_) return;  // a library (.ldb) has no entry point
        error("program '" + program.name +
                  "' has no entry point. Provide a public bundle with a public namespace "
                  "containing 'public class Main' with 'public static method "
                  "main(string[] args) returns void' (or int).",
              program.loc);
        return;
    }
    if (candidates.size() > 1) {
        error("program '" + program.name + "' has " + std::to_string(candidates.size()) +
                  " entry points; exactly one 'public static method main' is allowed.",
              program.loc);
        return;
    }
    entry_ = std::move(candidates.front());
}

// ---- Pass 3: type-check the body of every method and constructor. ----
void SemanticAnalyzer::analyzeFieldInits(const ast::ClassDecl& cls) {
    scopes_.clear();
    currentClass_ = cls.name;
    pushScope();
    for (const ast::MemberPtr& member : cls.members) {
        const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
        if (f == nullptr || !f->init) continue;
        const std::string initType = typeOf(*f->init);
        const std::string ft = typeRefStr(f->type);
        if (!initType.empty() && !isSubtype(initType, ft) && !intLiteralFits(*f->init, ft)) {
            error("cannot initialize field '" + f->name + "' of type '" + ft +
                      "' with a value of type '" + initType + "'",
                  f->loc);
        }
    }
    popScope();
}

void SemanticAnalyzer::analyzeBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported) continue;  // bodies live in the .ldb; only its public API is visible
        // Imports are written before `program` (file level, spec 2.7); the in-bundle form is still
        // accepted during migration. Collect the imported symbol names from both.
        currentImports_.clear();
        for (const ast::ImportDecl& imp : program.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::ImportDecl& imp : bundle.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                currentClass_ = cls.name;  // keep accurate for checkTypeAccessible's mono exemption
                // Member signature types must also be visible from this namespace -- except for
                // monomorphized generic instances (name contains '$'), whose members reference the
                // type arguments by simple name; those were already checked at the template and the
                // instantiation site, and the generated class is not bound to the arg's namespace.
                const bool isMono = cls.name.find('$') != std::string::npos;
                for (const ast::MemberPtr& member : cls.members) {
                    if (isMono) break;
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        for (const ast::Param& p : m->params)
                            checkTypeAccessible(typeRefStr(p.type), p.loc);
                        checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get())) {
                        checkTypeAccessible(typeRefStr(f->type), f->loc);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        for (const ast::Param& p : c->params)
                            checkTypeAccessible(typeRefStr(p.type), p.loc);
                    }
                }
                analyzeFieldInits(cls);
                if (!cls.invariants.empty()) {
                    std::vector<const ast::Expr*> invs;
                    for (const auto& e : cls.invariants) invs.push_back(e.get());
                    analyzeMethodBody(ast::Block{}, {}, cls.name, false, invs);
                }
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        if (m->isAbstract || m->isExtern) continue;  // no LDP3 body to analyze
                        if (m->isAsync && freestanding_)
                            error("async methods are not available in freestanding mode (spec 36.3)",
                                  m->loc);
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : m->requiresClauses) contracts.push_back(e.get());
                        for (const auto& e : m->ensuresClauses) contracts.push_back(e.get());
                        currentReturnType_ = typeRefStr(m->returnType);  // for the return null check
                        currentThrows_.clear();
                        for (const auto& t : m->throwsTypes)
                            currentThrows_.push_back(baseType(typeRefStr(t)));
                        analyzeMethodBody(m->body, m->params,
                                          m->isStatic ? std::string() : cls.name, false, contracts);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : c->requiresClauses) contracts.push_back(e.get());
                        for (const auto& e : c->ensuresClauses) contracts.push_back(e.get());
                        currentReturnType_ = "void";
                        currentThrows_.clear();
                        analyzeMethodBody(c->body, c->params, cls.name, /*inConstructor=*/true,
                                          contracts);
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        currentReturnType_ = "void";
                        currentThrows_.clear();
                        analyzeMethodBody(d->body, {}, cls.name, false);
                    }
                }
            }
            // Catalog-implementing enums keep their method impls on the enum (they are
            // not desugared to a class); type-check those bodies too. `this` has the
            // enum type; an instance method receives the enum value (an ordinal).
            for (const ast::EnumDecl& en : ns.enums) {
                for (const ast::MemberPtr& member : en.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isAbstract) continue;
                    for (const ast::Param& p : m->params)
                        checkTypeAccessible(typeRefStr(p.type), p.loc);
                    checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    std::vector<const ast::Expr*> contracts;
                    for (const auto& e : m->requiresClauses) contracts.push_back(e.get());
                    for (const auto& e : m->ensuresClauses) contracts.push_back(e.get());
                    analyzeMethodBody(m->body, m->params,
                                      m->isStatic ? std::string() : en.name, false, contracts);
                }
            }
        }
    }
}

bool SemanticAnalyzer::analyze(const ast::Program& program, bool libraryMode) {
    libraryMode_ = libraryMode;
    // Freestanding mode (spec 36): the whole program, or any bundle, may opt out of the managed
    // runtime; here we treat the program as freestanding if it or any bundle declares it.
    freestanding_ = program.isFreestanding;
    for (const ast::Bundle& b : program.bundles)
        if (b.isFreestanding) freestanding_ = true;
    // Math (spec 34.6) is a virtual builtin type (no prelude class, to avoid clashing with user
    // classes named Math); register its namespace so `import System.Math.Math;` resolves.
    typeNamespace_["Math"] = "System.Math";
    // File (spec 34.4) is likewise a virtual builtin (static methods lower to runtime stdio calls);
    // register it so `import System.IO.File;` resolves.
    typeNamespace_["File"] = "System.IO";
    // Time (spec 34): clock + sleep builtins; register so `import System.Time.Time;` resolves.
    typeNamespace_["Time"] = "System.Time";
    // Net (spec 34): TCP builtins lowering to runtime winsock calls; register for the import.
    typeNamespace_["Net"] = "System.Net";
    // reflect (spec 31) is a builtin namespace, not a prelude class; register it so `import reflect;`
    // resolves. Reflection use is gated on this import at the reflect.typeOf call site.
    typeNamespace_["reflect"] = "reflect";
    // Generic templates (stdlib collections and user generics alike) are erased by monomorphization,
    // which rewrites each use to an instance (ArrayList$int) in the user's namespace. The base name ->
    // namespace map captured before monomorphization pins each generic to its real home, so a stdlib
    // collection requires an import while a user generic in the current namespace does not. Enforcement
    // strips the $arg suffix and checks the base name (see checkTypeAccessible).
    for (const auto& [base, ns] : program.genericNamespaces) typeNamespace_[base] = ns;
    genericVariance_ = program.genericVariance;  // variance of generic type params (spec 15.3)
    qualifiedTypes_.insert(program.qualifiedTypes.begin(), program.qualifiedTypes.end());
    registerClasses(program);
    registerCatalogs(program);  // before enums: registerEnums records enum->catalog edges
    registerEnums(program);
    registerNewtypes(program);
    registerAnnotations(program);
    registerLiterals(program);
    registerConsts(program);
    registerComptimeMethods(program);
    registerPersistentFields(program);
    processImports(program);
    evaluateConsts(program);
    validateHierarchy();
    // If the hierarchy itself is broken (cycle, missing super), stop: walking it
    // recursively below could otherwise loop forever.
    if (!errors_.empty()) return false;
    validateOverrides(program);
    validateCatalogs(program);
    findEntryPoint(program);
    analyzeBodies(program);
    analyzeLiteralBodies(program);
    validateAnnotations(program);  // spec 14.3: applied [Name(...)] match a declared annotation
    checkPersistentReleases();  // spec 18.15: after all bodies, so releases are collected
    return errors_.empty();
}

// Registers each namespace-level `comptime literal` suffix function and checks
// its shape (spec 17.10): must be comptime, exactly one numeric parameter, and a
// known return type. The body is type-checked later, in analyzeLiteralBodies.
void SemanticAnalyzer::registerLiterals(const ast::Program& program) {
    auto reg = [&](const ast::LiteralDecl& lit, const std::string& owner, const std::string& nsName) {
        const std::string paramType = typeRefStr(lit.param.type);
        const std::string returnType = typeRefStr(lit.returnType);
        if (!lit.isComptime)
            error("literal suffix '" + lit.name + "' must be 'comptime literal'", lit.loc);
        if (!isNumeric(paramType))
            error("literal suffix '" + lit.name +
                      "' must take a numeric parameter (int or float family)",
                  lit.loc);
        // Overloading by parameter type (spec 17.10 rule 6): seconds(int) and seconds(double)
        // may coexist; only a same-name, same-parameter-type redefinition is an error.
        for (const LiteralInfo& ov : literals_[lit.name])
            if (ov.paramType == paramType)
                error("literal suffix '" + lit.name + "(" + paramType + ")' is already defined",
                      lit.loc);
        literals_[lit.name].push_back(
            LiteralInfo{paramType, returnType, lit.isComptime, lit.loc, owner});
        typeNamespace_[lit.name] = nsName;  // for import-prefix validation
        if (!owner.empty()) classSuffixes_[owner].push_back(lit.name);  // import owner -> suffixes
    };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            // A namespace-level literal suffix is a free declaration outside a class; a suffix must
            // be a member of the class/struct it produces (spec 17.10). Still registered so its uses
            // resolve and do not cascade.
            for (const ast::LiteralDecl& lit : ns.literals) {
                error("a 'comptime literal' suffix must be a member of a class or struct (declare it "
                      "inside the type it returns)",
                      lit.loc);
                reg(lit, "", ns.name);
            }
            // A literal suffix declared inside a class/struct is owned by that type (spec 17.10).
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& m : cls.members)
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get()))
                        reg(*lit, cls.name, ns.name);
        }
    }
}

// Pass 1 for namespace-level consts (spec 28.1): record each name's type so that
// references resolve. Only primitive numeric / boolean / char consts are supported
// for now (no sizeof, no comptime functions -- those are later tiers).
void SemanticAnalyzer::registerConsts(const ast::Program& program) {
    auto reg = [&](const ast::ConstDecl& c, const std::string& owner) {
        const std::string type = typeRefStr(c.type);
        if (!isNumeric(type) && type != "boolean" && type != "char") {
            error("a 'const' must have a numeric, boolean, or char type, got '" + type + "'", c.loc);
            return;
        }
        const std::string key = owner.empty() ? c.name : owner + "." + c.name;
        if (constTypes_.count(key) > 0) {
            error("const '" + key + "' is already defined", c.loc);
            return;
        }
        constTypes_[key] = type;
    };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            // A namespace-level const is a free declaration outside a class; LDP3 is OOP-mandatory,
            // so a const must be a static class/struct member (spec 28.1). Still registered so its
            // references resolve and do not cascade into spurious errors.
            for (const ast::ConstDecl& c : ns.consts) {
                error("a 'const' must be a static class or struct member; declare it inside a class",
                      c.loc);
                reg(c, "");
            }
            // A const declared inside a class/struct is a static member, keyed Owner.NAME.
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& m : cls.members)
                    if (const auto* c = dynamic_cast<const ast::ConstDecl*>(m.get()))
                        reg(*c, cls.name);
        }
    }
}

// Indexes every `comptime` method by its (simple) name so the shared evaluator can
// resolve compile-time calls (spec 28.3). A comptime method is also an ordinary
// method, callable at runtime; the flag only enables compile-time folding.
void SemanticAnalyzer::registerComptimeMethods(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m != nullptr && m->isComptime && !m->isAbstract)
                        comptimeMethods_.emplace(m->name, m);
                }
            }
        }
    }
}

// Indexes persistent fields (spec 18.15). Non-eternal ones must be released
// somewhere in the program; eternal ones are exempt.
void SemanticAnalyzer::registerPersistentFields(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles)
        for (const ast::Namespace& ns : bundle.namespaces)
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& member : cls.members)
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(member.get());
                        f != nullptr && f->isPersistent)
                        persistentFields_.push_back({cls.name, f->name, f->isEternal, f->loc});
}

// The class in `cls`'s hierarchy that declares persistent field `field`, or "".
std::string SemanticAnalyzer::persistentFieldOwner(const std::string& cls,
                                                   const std::string& field) const {
    std::string cur = cls;
    for (int depth = 0; !cur.empty() && depth < 256; ++depth) {
        for (const PersistentFieldInfo& pf : persistentFields_)
            if (pf.cls == cur && pf.name == field) return cur;
        auto it = classes_.find(cur);
        if (it == classes_.end()) break;
        cur = it->second.superclass;
    }
    return "";
}

void SemanticAnalyzer::markCascadeReleased(const std::string& typeName,
                                           std::unordered_set<std::string>& seen) {
    const std::string base = baseType(typeName);
    if (base.empty() || !seen.insert(base).second) return;
    for (std::string cur = base; !cur.empty();) {
        auto it = classes_.find(cur);
        if (it == classes_.end()) break;
        for (const PersistentFieldInfo& pf : persistentFields_)
            if (pf.cls == cur) releasedPersistents_.insert(cur + "." + pf.name);
        for (const auto& [fname, fi] : it->second.fields) {  // recurse into owned class fields
            if (fi.type.find('&') != std::string::npos || isArrayType(fi.type)) continue;
            if (classes_.find(baseType(fi.type)) != classes_.end())
                markCascadeReleased(fi.type, seen);
        }
        cur = it->second.superclass;
    }
}

// Enforces the release obligation (spec 18.15): a non-eternal persistent field
// with no `release persistent` anywhere in the program is a compile error.
void SemanticAnalyzer::checkPersistentReleases() {
    for (const PersistentFieldInfo& pf : persistentFields_) {
        if (pf.isEternal) continue;
        if (releasedPersistents_.count(pf.cls + "." + pf.name) > 0) continue;
        error("persistent '" + pf.cls + "." + pf.name +
                  "' has no 'release persistent' anywhere in the program; non-eternal "
                  "persistents require explicit release (or mark the field 'eternal persistent')",
              pf.loc);
    }
}

// Pass 2: fold each const initializer (in declaration order, so a const may refer
// to earlier ones) and validate it is a compile-time constant of the right kind.
void SemanticAnalyzer::evaluateConsts(const ast::Program& program) {
    auto fold = [&](const ast::ConstDecl& c, const std::string& owner) {
        const std::string key = owner.empty() ? c.name : owner + "." + c.name;
        if (constTypes_.count(key) == 0) return;  // rejected in pass 1
        const std::string type = constTypes_[key];
        if (c.init == nullptr) {
            error("const '" + key + "' must have an initializer", c.loc);
            return;
        }
        if (isFloatType(type)) {
            double d;
            if (!evalConstDouble(*c.init, d, &constDoubles_, &constInts_, &comptimeMethods_))
                error("const '" + key + "' initializer must be a compile-time constant", c.loc);
            else
                constDoubles_[key] = d;
        } else {
            long long v;
            if (!evalConstInt(*c.init, v, &constInts_, &comptimeMethods_, &constDoubles_))
                error("const '" + key + "' initializer must be a compile-time constant", c.loc);
            else
                constInts_[key] = v;
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

// Resolves each `import a.b.c;`: the last component is the symbol. Importing a
// literal suffix enables its `N suffix` syntax (spec 17.10 rule 5). Importing a
// type is accepted (names are global in 0.2); an unknown symbol is an error.
void SemanticAnalyzer::processImports(const ast::Program& program) {
    auto validate = [&](const ast::ImportDecl& imp) {
        if (imp.path.empty()) return;
        const std::string& symbol = imp.path.back();
        std::string full;
        for (std::size_t i = 0; i < imp.path.size(); ++i) full += (i > 0 ? "." : "") + imp.path[i];
        // The prefix (everything before the symbol) must be the symbol's real namespace.
        std::string prefix;
        for (std::size_t i = 0; i + 1 < imp.path.size(); ++i)
            prefix += (i > 0 ? "." : "") + imp.path[i];
        auto nsIt = typeNamespace_.find(symbol);
        if (nsIt == typeNamespace_.end()) {
            error("import of unknown symbol '" + full + "'", imp.loc);
        } else if (!prefix.empty() && prefix != nsIt->second) {
            error("'" + symbol + "' is in namespace '" + nsIt->second + "', not '" + prefix + "'",
                  imp.loc);
        } else {
            importedSuffixes_.insert(symbol);  // harmless for non-literals
            // Importing the owner class brings its literal suffixes into scope (spec 17.10).
            if (auto cs = classSuffixes_.find(symbol); cs != classSuffixes_.end())
                for (const std::string& s : cs->second) importedSuffixes_.insert(s);
        }
        if (imp.isFinal) finalImports_.insert(symbol);  // spec 37.6: not unimportable
    };
    for (const ast::ImportDecl& imp : program.imports) validate(imp);  // file-level (spec 2.7)
    for (const ast::Bundle& bundle : program.bundles)
        for (const ast::ImportDecl& imp : bundle.imports) validate(imp);
}

// Type-checks the body of each literal suffix, with its single parameter in
// scope and treated like a static function (no `this`).
void SemanticAnalyzer::analyzeLiteralBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        currentImports_.clear();
        for (const ast::ImportDecl& imp : program.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::ImportDecl& imp : bundle.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            for (const ast::LiteralDecl& lit : ns.literals) {
                analyzeMethodBody(lit.body, {lit.param}, /*thisClass=*/"", /*inConstructor=*/false);
            }
            // Class/struct-owned literal suffix bodies (spec 17.10): static, so no `this`.
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& m : cls.members)
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get()))
                        analyzeMethodBody(lit->body, {lit->param}, /*thisClass=*/"",
                                          /*inConstructor=*/false);
        }
    }
}

// Recursively collects `label name;` markers from a statement (into nested control-flow blocks,
// but not into lambda bodies -- expressions are not traversed here). Used for tetrad validation.
static void collectLabelsInStmt(const ast::Stmt* st, std::unordered_set<std::string>& out) {
    if (st == nullptr) return;
    if (const auto* lm = dynamic_cast<const ast::LabelMarkStmt*>(st)) { out.insert(lm->name); return; }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) collectLabelsInStmt(s.get(), out);
    };
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
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { collectLabelsInStmt(lb->stmt.get(), out); return; }
}

void SemanticAnalyzer::collectMethodLabels(const ast::Block& block) {
    for (const auto& s : block.statements) collectLabelsInStmt(s.get(), methodLabels_);
}

void SemanticAnalyzer::analyzeMethodBody(const ast::Block& body,
                                         const std::vector<ast::Param>& params,
                                         const std::string& thisClass, bool inConstructor,
                                         const std::vector<const ast::Expr*>& contracts) {
    scopes_.clear();
    moved_.clear();
    deleted_.clear();
    catchStack_.clear();
    regionConstraints_.clear();
    methodLabels_.clear();
    comefromTargets_.clear();
    collectMethodLabels(body);  // chaos tetrad targets are validated against these (spec 7.9-7.11)
    detectComefromLoops(body);  // best-effort infinite-loop warning (spec 7.10 rule 7)
    currentClass_ = thisClass;
    inConstructor_ = inConstructor;
    pushScope();
    for (const ast::Param& p : params) {
        declareLocal(p.name, LocalVar{typeRefStr(p.type), false});  // params immutable by default
    }
    for (std::size_t i = 0; i < body.statements.size(); ++i) {
        // `super(...)` is only legal as the very first statement of a constructor.
        if (inConstructor && i != 0) {
            const auto* es = dynamic_cast<const ast::ExprStmt*>(body.statements[i].get());
            const auto* call = es ? dynamic_cast<const ast::CallExpr*>(es->expr.get()) : nullptr;
            if (call != nullptr &&
                dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
                error("'super(...)' must be the first statement of the constructor",
                      body.statements[i]->loc);
            }
        }
        analyzeStatement(*body.statements[i]);
    }
    // Contract clauses (spec 29) are boolean expressions over params/this/fields.
    for (const ast::Expr* clause : contracts) {
        const std::string t = typeOf(*clause);
        if (!t.empty() && t != "boolean")
            error("a contract clause must be boolean, got '" + t + "'", clause->loc);
    }
    popScope();
}

void SemanticAnalyzer::analyzeBlock(const ast::Block& block) {
    pushScope();
    for (const auto& stmt : block.statements) {
        analyzeStatement(*stmt);
    }
    popScope();
}

bool SemanticAnalyzer::isCompileTimeConstant(const ast::Expr& e) const {
    // A literal suffix applies to a compile-time-known value (spec 17.10): a numeric/char/boolean
    // literal, a namespace `const`, or arithmetic/casts over those. This is what stops a
    // `comptime literal` from being abused as a runtime free function -- it can only transform
    // constants, never run on a runtime argument.
    if (dynamic_cast<const ast::IntLiteralExpr*>(&e) != nullptr) return true;
    if (dynamic_cast<const ast::FloatLiteralExpr*>(&e) != nullptr) return true;
    if (dynamic_cast<const ast::CharLiteralExpr*>(&e) != nullptr) return true;
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&e) != nullptr) return true;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&e))
        return constTypes_.count(id->name) > 0;  // a folded namespace const
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e))
        return isCompileTimeConstant(*u->operand);
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(&e))
        return isCompileTimeConstant(*c->operand);
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(&e))
        return isCompileTimeConstant(*b->lhs) && isCompileTimeConstant(*b->rhs);
    return false;
}

std::string SemanticAnalyzer::analyzeYieldBlock(const ast::Block& body) {
    // Analyzes a match-expression block arm (spec 16.2) in its own scope (the case bindings are
    // already declared by the caller) and returns the type `yield` produces.
    pushScope();
    std::string yieldType;
    for (const auto& stmt : body.statements) {
        analyzeStatement(*stmt);
        if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(stmt.get());
            ys != nullptr && ys->value != nullptr)
            yieldType = typeOf(*ys->value);
    }
    popScope();
    return yieldType;
}

std::string SemanticAnalyzer::analyzeExpectingBlock(const ast::Block* block) {
    if (block == nullptr) return "";
    const std::string savedRet = currentReturnType_;
    currentReturnType_.clear();  // the block's return is its own value, not the method's
    pushScope();
    std::string valueType;
    for (const auto& stmt : block->statements) {
        analyzeStatement(*stmt);
        if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(stmt.get());
            rs != nullptr && rs->value != nullptr)
            valueType = typeOf(*rs->value);
    }
    popScope();
    currentReturnType_ = savedRet;
    return valueType;
}

void SemanticAnalyzer::checkAssignTarget(const ast::Expr& target, const std::string& valueType,
                                         SourceLocation loc, const ast::Expr* valueExpr) {
    // A compile-time integer literal coerces to a narrower target type when it fits (spec).
    auto fits = [&](const std::string& targetType) {
        return valueExpr != nullptr && intLiteralFits(*valueExpr, targetType);
    };
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error("assignment to undeclared variable '" + id->name + "'", loc);
            return;
        }
        if (!var->isMutable) {
            error("cannot assign to immutable variable '" + id->name + "' (declare it 'mutable')",
                  loc);
        }
        if (!valueType.empty() && !isSubtype(valueType, var->type) && !fits(var->type)) {
            error("cannot assign a value of type '" + valueType + "' to variable '" + id->name +
                      "' of type '" + var->type + "'",
                  loc);
        }
        return;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&target)) {
        // Static field target: ClassName.field (receiver names a class, not a variable).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (objId->name != "this" && lookupLocal(objId->name) == nullptr &&
                lookupClass(objId->name) != nullptr) {
                const FieldInfo* f = findField(objId->name, mem->member);
                if (f == nullptr || !f->isStatic) {
                    error("class '" + objId->name + "' has no static field '" + mem->member + "'",
                          loc);
                    return;
                }
                if (!f->isMutable) {
                    error("cannot assign to immutable static field '" + mem->member +
                              "' (declare it 'mutable')",
                          loc);
                }
                if (!valueType.empty() && !isSubtype(valueType, f->type) && !fits(f->type)) {
                    error("cannot assign a value of type '" + valueType + "' to static field '" +
                              mem->member + "' of type '" + f->type + "'",
                          loc);
                }
                return;
            }
        }
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) return;
        const FieldInfo* f = findField(objType, mem->member);
        if (f == nullptr) {
            error("class '" + objType + "' has no field '" + mem->member + "'", loc);
            return;
        }
        // Immutable fields may still be initialized via `this.field` in a constructor.
        const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        const bool isThisField = objId != nullptr && objId->name == "this";
        if (!f->isMutable && !(inConstructor_ && isThisField)) {
            error("cannot assign to immutable field '" + mem->member + "' (declare it 'mutable')",
                  loc);
        }
        if (!valueType.empty() && !isSubtype(valueType, f->type) && !fits(f->type)) {
            error("cannot assign a value of type '" + valueType + "' to field '" + mem->member +
                      "' of type '" + f->type + "'",
                  loc);
        }
        // Reassigning a partially-moved field reactivates it (spec 19.9).
        if (objId != nullptr) moved_.erase(objId->name + "." + mem->member);
        return;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&target)) {
        const std::string at = typeOf(*ix->array);
        typeOf(*ix->index);
        if (findMethod(baseType(at), "operator[]=")) return;  // operator[]= overload (spec 6.5)
        if (!at.empty() && !isArrayType(at) && !isRefType(at)) {
            error("cannot index a value of non-array type '" + at + "'", loc);
            return;
        }
        const std::string et = isRefType(at) ? baseType(at) : elementOf(at);  // p[i] = v on a T*
        if (!valueType.empty() && !et.empty() && !isSubtype(valueType, et)) {
            error("cannot assign a value of type '" + valueType +
                      "' to an array element of type '" + et + "'",
                  loc);
        }
        return;
    }
    error("invalid assignment target", loc);
}

// Bit-counted type names (int8..int64, uint8..uint64, float32/64) exist only in freestanding mode
// (spec 3.1); in normal mode the named types (byte/short/int/long, float/double, ...) are required.
void SemanticAnalyzer::checkBitCounted(const std::string& typeName, SourceLocation loc) {
    if (freestanding_) return;
    std::string n = baseType(typeName);
    if (isArrayType(n)) n = elementOf(n);
    if (isBitCountedName(n))
        error("type '" + n + "' exists only in freestanding mode; use '" + normalTypeName(n) +
                  "' instead",
              loc);
}

void SemanticAnalyzer::checkTypeAccessible(const std::string& typeName, SourceLocation loc) {
    std::string n = baseType(typeName);          // see through T* / T&
    if (isArrayType(n)) n = elementOf(n);         // and through T[]
    checkBitCounted(typeName, loc);                // bit-counted names are freestanding-only
    // Inside a compiler-generated monomorphized class, type references were already validated at the
    // template and the instantiation site (and may reach stdlib types like Json from ArrayList<Json>).
    if (currentClass_.find('$') != std::string::npos) return;
    // A monomorphized generic (ArrayList$int) is enforced on its generic base name (ArrayList): user
    // code must import the collection. The type-argument part is internal to the instantiation.
    if (const std::size_t d = n.find('$'); d != std::string::npos) n = n.substr(0, d);
    // Ok/Err/Some/None are the value-constructor sugar of Result/Option (spec 21), not types declared
    // by name; they come with the type, so importing Result/Option is enough.
    if (n == "Ok" || n == "Err" || n == "Some" || n == "None") return;
    if (qualifiedTypes_.count(n) > 0) return;      // explicitly namespace-qualified -> visible
    auto it = typeNamespace_.find(n);
    if (it == typeNamespace_.end()) return;        // primitive / unknown (other checks catch it)
    if (it->second == currentNamespace_) return;   // same namespace -> visible
    if (currentImports_.count(n) > 0) return;      // brought in by import (incl. stdlib)
    // The stdlib is internally cohesive: a System.* type may use any other System.* type without an
    // import (e.g. System.Json's Json uses System.Text's StringBuilder).
    if (currentNamespace_.rfind("System.", 0) == 0 && it->second.rfind("System.", 0) == 0) return;
    error("type '" + n + "' is in namespace '" + it->second + "'; import it (import " + it->second +
              "." + n + ";) to use it here",
          loc);
}

void SemanticAnalyzer::checkRegionAccepts(const std::string& region, const std::string& type,
                                          SourceLocation loc) {
    auto rc = regionConstraints_.find(region);
    if (rc == regionConstraints_.end()) return;  // no constraints recorded
    for (const std::string& rej : rc->second.rejects) {
        if (type == rej || isSubtype(type, rej)) {
            error("region '" + region + "' rejects type '" + type + "'", loc);
            return;
        }
    }
    if (!rc->second.accepts.empty()) {
        for (const std::string& acc : rc->second.accepts) {
            if (type == acc || isSubtype(type, acc)) return;  // accepted
        }
        error("region '" + region + "' does not accept type '" + type + "'", loc);
    }
}

void SemanticAnalyzer::checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                                            SourceLocation loc) {
    if (isRefType(targetType)) return;  // pointers/refs share; no move discipline
    const ClassInfo* ci = lookupClass(baseType(targetType));
    if (ci == nullptr) return;  // not a class value
    const bool rhsIsMove = dynamic_cast<const ast::MoveExpr*>(&rhs) != nullptr;
    const auto* rhsId = dynamic_cast<const ast::IdentifierExpr*>(&rhs);
    const bool rhsIsLValue =
        rhsId != nullptr || dynamic_cast<const ast::MemberExpr*>(&rhs) != nullptr;
    if (!rhsIsLValue || rhsIsMove) return;  // a fresh `new`, a `move`, or a temporary is fine
    if (ci->isMovable) {
        error("'" + ci->name + "' is movable; transfer ownership with 'move' (e.g. = move x)",
              loc);
    } else if (ci->isUnique && rhsId != nullptr) {
        moved_.insert(rhsId->name);  // unique: a plain assignment is an implicit move
    }
}

void SemanticAnalyzer::checkIncDecTarget(const ast::Expr& target, SourceLocation loc) {
    std::string type;
    bool mutableTarget = false;
    bool resolved = false;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error("modification of undeclared variable '" + id->name + "'", loc);
            return;
        }
        type = var->type;
        mutableTarget = var->isMutable;
        resolved = true;
    } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&target)) {
        const std::string objType = typeOf(*mem->object);
        if (objType.empty()) return;
        if (const FieldInfo* f = findField(objType, mem->member)) {
            type = f->type;
            mutableTarget = f->isMutable;
            resolved = true;
        }
        if (!resolved) {
            error("invalid '++'/'--' target", loc);
            return;
        }
    } else {
        error("invalid '++'/'--' target", loc);
        return;
    }
    // atomic<T> ++ / -- is a lock-free atomic update; the cell itself is the mutable container,
    // so the reference need not be `mutable` (spec 20.6).
    if (baseType(type).rfind("atomic$", 0) == 0) return;
    if (!mutableTarget) error("cannot modify an immutable target (declare it 'mutable')", loc);
    if (type != "int") error("'++'/'--' requires an int target", loc);
}

// Evaluates a constant integer/boolean/char expression at compile time (spec 28),
// delegating to the shared comptime evaluator so consts and `comptime` method calls
// resolve uniformly. `consts`/`methods` are optional resolution tables.
static bool evalConstInt(const ast::Expr& e, long long& out,
                         const std::unordered_map<std::string, long long>* consts,
                         const std::unordered_map<std::string, const ast::MethodDecl*>* methods,
                         const std::unordered_map<std::string, double>* dconsts) {
    comptime::Context ctx;
    ctx.consts = consts;
    ctx.dconsts = dconsts;  // so a double const in e.g. a comparison still resolves
    ctx.methods = methods;
    return comptime::evalInt(e, out, ctx);
}

// Evaluates a constant floating-point expression at compile time (integers promote),
// resolving consts and `comptime` method calls via the shared evaluator.
static bool evalConstDouble(const ast::Expr& e, double& out,
                            const std::unordered_map<std::string, double>* dconsts,
                            const std::unordered_map<std::string, long long>* iconsts,
                            const std::unordered_map<std::string, const ast::MethodDecl*>* methods) {
    comptime::Context ctx;
    ctx.consts = iconsts;
    ctx.dconsts = dconsts;
    ctx.methods = methods;
    return comptime::evalDouble(e, out, ctx);
}

void SemanticAnalyzer::analyzeStatement(const ast::Stmt& stmt) {
    if (const auto* sa = dynamic_cast<const ast::StaticAssertStmt*>(&stmt)) {
        long long v;
        if (!evalConstInt(*sa->condition, v, &constInts_, &comptimeMethods_, &constDoubles_))
            error("static_assert requires a constant expression", sa->loc);
        else if (v == 0)
            error("static assertion failed: " + sa->message, sa->loc);
        return;
    }
    if (dynamic_cast<const ast::BreakStmt*>(&stmt) != nullptr ||
        dynamic_cast<const ast::ContinueStmt*>(&stmt) != nullptr) {
        return;  // loop-context validation (break/continue only inside a loop) is a later refinement
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(&stmt)) {
        // A range `0..10` (spec 7.5) iterates integers; otherwise the iterable is an array.
        if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(fe->iterable.get())) {
            const std::string st = typeOf(*rng->start);
            typeOf(*rng->end);
            if (rng->step) typeOf(*rng->step);
            const std::string et = fe->isVar ? (st.empty() ? "int" : st) : typeRefStr(fe->elemType);
            pushScope();
            if (!fe->indexName.empty()) declareLocal(fe->indexName, LocalVar{"int", false});
            declareLocal(fe->varName, LocalVar{et, false});
            analyzeBlock(fe->body);
            popScope();
            return;
        }
        const std::string it = typeOf(*fe->iterable);
        // A collection is iterable too (spec 34): a generic/monomorphized class snapshot via toArray().
        const bool isColl =
            !it.empty() && !isArrayType(it) &&
            (it.find('<') != std::string::npos || it.find('$') != std::string::npos);
        if (!it.empty() && !isArrayType(it) && !isColl)
            error("foreach requires an array, a collection or a range, got '" + it + "'", fe->loc);
        std::string et;
        if (!fe->isVar) {
            et = typeRefStr(fe->elemType);
        } else if (isColl) {  // var x: take the single type argument (ArrayList<int> -> int)
            const std::size_t lt = it.find('<');
            const std::string args = lt != std::string::npos
                                         ? it.substr(lt + 1, it.size() - lt - 2)
                                         : it.substr(it.find('$') + 1);
            et = args.find(',') == std::string::npos && args.find('$') == std::string::npos ? args : "";
        } else {
            et = elementOf(it);
        }
        pushScope();
        if (!fe->indexName.empty()) declareLocal(fe->indexName, LocalVar{"int", false});
        declareLocal(fe->varName, LocalVar{et, false});
        analyzeBlock(fe->body);
        popScope();
        return;
    }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(&stmt)) {
        typeOf(*sw->subject);
        for (const ast::SwitchCase& c : sw->cases) {
            typeOf(*c.value);
            analyzeBlock(c.body);
        }
        if (sw->defaultBody) analyzeBlock(*sw->defaultBody);
        return;
    }
    if (const auto* td = dynamic_cast<const ast::TupleDeclStmt*>(&stmt)) {
        const std::string initType = typeOf(*td->init);
        if (!initType.empty() && !isTupleType(initType)) {
            error("cannot destructure a non-tuple value of type '" + initType + "'", td->loc);
        }
        const std::vector<std::string> comps = tupleElems(initType);
        if (!initType.empty() && comps.size() != td->bindings.size()) {
            error("tuple destructuring expects " + std::to_string(comps.size()) +
                      " bindings but found " + std::to_string(td->bindings.size()),
                  td->loc);
        }
        for (std::size_t i = 0; i < td->bindings.size(); ++i) {
            const std::string bt = typeRefStr(td->bindings[i].type);
            checkTypeAccessible(bt, td->loc);
            if (i < comps.size() && !comps[i].empty() && !isSubtype(comps[i], bt)) {
                error("cannot bind tuple component " + std::to_string(i) + " of type '" +
                          comps[i] + "' to '" + bt + "'",
                      td->loc);
            }
            if (lookupLocal(td->bindings[i].name) != nullptr) {
                error("redeclaration or shadowing of variable '" + td->bindings[i].name + "'",
                      td->loc);
            } else {
                declareLocal(td->bindings[i].name, LocalVar{bt, false});
            }
        }
        return;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&stmt)) {
        const std::string initType = typeOf(*vd->init);
        const std::string declType = vd->isVar ? initType : typeRefStr(vd->type);
        if (!vd->isVar) checkTypeAccessible(declType, vd->loc);
        if (!vd->isVar && !initType.empty() && !isSubtype(initType, declType) &&
            !intLiteralFits(*vd->init, declType)) {
            error("cannot initialize variable '" + vd->name + "' of type '" + declType +
                      "' with a value of type '" + initType + "'",
                  vd->loc);
        }
        if (lookupLocal(vd->name) != nullptr && deleted_.count(vd->name) == 0) {
            error("redeclaration or shadowing of variable '" + vd->name + "'", vd->loc);
        } else {
            deleted_.erase(vd->name);  // reborn after delete: persistents reattach (spec 18.2)
            // A class value bound to a `new ... on stack` (the default for objects) is a
            // stack object: RAII frees it, and it is not throwable (its carrier would
            // dangle after unwind).
            bool stackObj = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get()))
                stackObj = nw->location != "heap" && !declType.empty() &&
                           lookupClass(baseType(declType)) != nullptr && !isRefType(declType) &&
                           !isArrayType(declType);
            declareLocal(vd->name, LocalVar{declType.empty() ? std::string("int") : declType,
                                            vd->isMutable, stackObj});
        }
        // Remember a region's accepts/rejects constraints, keyed by variable.
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get())) {
            regionConstraints_[vd->name] = RegionConstraints{ri->accepts, ri->rejects};
        }
        checkOwnershipAssign(declType, *vd->init, vd->loc);
        return;
    }
    if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
        // atomic<T> assignment (spec 20.6): `counter = counter +/- n` (a lock-free atomicrmw,
        // from `+=`/`-=`) or `counter = v` (atomic store). The atomic<T> <-> T mixing is allowed
        // here rather than through the usual numeric checks (which reject atomic + int). Detect via
        // the local's type (not typeOf, which would read-type the target and error on moved vars).
        bool atomicTarget = false;
        if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get()))
            if (const LocalVar* v = lookupLocal(tid->name);
                v != nullptr && baseType(v->type).rfind("atomic$", 0) == 0)
                atomicTarget = true;
        if (atomicTarget) {
            if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(assign->value.get())) {
                typeOf(*bin->lhs);
                typeOf(*bin->rhs);
            } else {
                typeOf(*assign->value);
            }
            return;
        }
        const std::string vt = typeOf(*assign->value);
        checkAssignTarget(*assign->target, vt, assign->loc, assign->value.get());
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
            moved_.erase(id->name);  // reassignment reactivates the variable
            const LocalVar* var = lookupLocal(id->name);
            if (var != nullptr) checkOwnershipAssign(var->type, *assign->value, assign->loc);
        }
        return;
    }
    if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
        checkIncDecTarget(*incdec->target, incdec->loc);
        return;
    }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(&stmt)) {
        const std::string ct = typeOf(*ifs->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'if' condition must be boolean, got '" + ct + "'", ifs->loc);
        }
        if (ifs->isComptime) {
            long long v;
            if (!evalConstInt(*ifs->cond, v, &constInts_, &comptimeMethods_, &constDoubles_))
                error("'comptime if' requires a compile-time constant condition", ifs->loc);
        }
        analyzeBlock(ifs->thenBlock);
        if (ifs->elseBlock) analyzeBlock(*ifs->elseBlock);
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(&stmt)) {
        const std::string subjType = typeOf(*ms->subject);
        const std::string subjBaseM = baseType(subjType);
        const auto subjDollarM = subjBaseM.find('$');
        for (const ast::MatchCase& c : ms->cases) {
            // A bare case name (Ok) on a monomorphized sealed subject (Result$int$int) names the
            // matching instantiation (Ok$int$int). Exhaustiveness below stays bare (permits are bare).
            const std::string caseType = subjDollarM == std::string::npos
                                             ? c.typeName
                                             : c.typeName + subjBaseM.substr(subjDollarM);
            const ClassInfo* ci = lookupClass(caseType);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(caseType, subjBaseM)) {
                error("'" + c.typeName + "' is not a subtype of '" + subjType + "'", c.loc);
            }
            // Bindings introduce locals (the case type's fields) in the case body.
            pushScope();
            for (const ast::Param& b : c.bindings)
                declareLocal(b.name, LocalVar{typeRefStr(b.type), false});
            for (const auto& st : c.body.statements) analyzeStatement(*st);
            popScope();
        }
        if (ms->defaultBody) analyzeBlock(*ms->defaultBody);
        // Exhaustiveness (spec 16.1): a sealed subject must cover every permit and
        // needs no default; a non-sealed subject requires a default.
        const ClassInfo* sc = lookupClass(baseType(subjType));
        if (sc != nullptr && sc->isSealed) {
            for (const std::string& p : sc->permits) {
                bool covered = false;
                for (const ast::MatchCase& c : ms->cases)
                    if (c.typeName == p) covered = true;
                if (!covered && !ms->defaultBody)
                    error("match on sealed '" + baseType(subjType) +
                              "' is not exhaustive: missing case '" + p + "'",
                          ms->loc);
            }
        } else if (!ms->defaultBody) {
            error("match requires a 'default' case (the subject is not sealed)", ms->loc);
        }
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(&stmt)) {
        const std::string ct = typeOf(*ws->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'while' condition must be boolean, got '" + ct + "'", ws->loc);
        }
        analyzeBlock(ws->body);
        return;
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&stmt)) {
        analyzeBlock(dw->body);
        const std::string ct = typeOf(*dw->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'do-while' condition must be boolean, got '" + ct + "'", dw->loc);
        }
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(&stmt)) {
        pushScope();
        if (fs->init) analyzeStatement(*fs->init);
        const std::string ct = typeOf(*fs->cond);
        if (!ct.empty() && ct != "boolean") {
            error("'for' condition must be boolean, got '" + ct + "'", fs->loc);
        }
        if (fs->update) analyzeStatement(*fs->update);
        analyzeBlock(fs->body);
        popScope();
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
        typeOf(*es->expr);
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
        if (rs->value) {
            const std::string vt = typeOf(*rs->value);
            // Null safety (spec 3.7): a null/nullable value may not be returned where the declared
            // return type is non-nullable.
            if (!vt.empty() && !currentReturnType_.empty() && !isNullableType(currentReturnType_) &&
                (vt == "null" || isNullableType(vt)))
                error("cannot return a " + std::string(vt == "null" ? "null" : "nullable") +
                          " value from a method returning non-nullable '" + currentReturnType_ + "'",
                      rs->loc);
        }
        return;
    }
    if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(&stmt)) {
        if (ys->value) typeOf(*ys->value);  // `yield expr;` (spec 16.2): type-check the value
        return;
    }
    if (dynamic_cast<const ast::AsmStmt*>(&stmt) != nullptr) {
        return;  // inline assembly (spec issue 1): a raw body, nothing to type-check
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&stmt)) {
        const std::string t = typeOf(*del->target);
        // `delete p` where p is a class, or a pointer/reference to one (see through T*/T&).
        if (!t.empty() && lookupClass(baseType(t)) == nullptr && !isArrayType(t)) {
            error("'delete' expects a heap object or array; got a value of type '" + t + "'",
                  del->loc);
        }
        // A deleted variable may be redeclared with the same name, reattaching its persistents
        // (spec 18.2). Record it so the redeclaration is allowed.
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(del->target.get()))
            deleted_.insert(id->name);
        return;
    }
    if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
        if (rel->isPersistent) {
            // `release [persistent|eternal] obj.field;` -- record that this persistent
            // field is released somewhere, satisfying the obligation (spec 18.15).
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(rel->target.get())) {
                const std::string ot = baseType(typeOf(*mem->object));
                if (const std::string owner = persistentFieldOwner(ot, mem->member); !owner.empty())
                    releasedPersistents_.insert(owner + "." + mem->member);
                else if (!ot.empty())
                    error("'" + mem->member + "' is not a persistent field of '" + ot + "'",
                          rel->loc);
            } else if (rel->target != nullptr) {
                typeOf(*rel->target);  // still type-check the operand
                error("'release persistent' expects a persistent field access (obj.field)",
                      rel->loc);
            }
            return;
        }
        const LocalVar* r = lookupLocal(rel->region);
        if (r == nullptr) {
            error("unknown region '" + rel->region + "'", rel->loc);
        } else if (r->type != "region") {
            error("'" + rel->region + "' is not a region", rel->loc);
        }
        return;
    }
    if (const auto* um = dynamic_cast<const ast::UnimportStmt*>(&stmt)) {
        if (freestanding_)
            error("unimport/reimport is not available in freestanding mode (spec 36.3)", um->loc);
        if (lookupClass(baseType(um->target)) == nullptr)
            error("cannot " + std::string(um->isReimport ? "reimport" : "unimport") + " '" +
                      um->target + "': not a known class",
                  um->loc);
        else if (!um->isReimport && finalImports_.count(baseType(um->target)) > 0)
            error("cannot unimport '" + um->target + "': it was brought in by 'final import' (spec 37.6)",
                  um->loc);
        return;
    }
    if (const auto* rv = dynamic_cast<const ast::ReimportValidateStmt*>(&stmt)) {
        if (freestanding_)
            error("unimport/reimport is not available in freestanding mode (spec 36.3)", rv->loc);
        if (lookupClass(baseType(rv->target)) == nullptr)
            error("cannot reimport '" + rv->target + "': not a known class", rv->loc);
        const std::string expectedType = rv->expected ? typeOf(*rv->expected) : "";
        const std::string producedType = analyzeExpectingBlock(rv->expecting.get());
        // The two validation values must be the same type so they can be compared bit-for-bit.
        if (!expectedType.empty() && !producedType.empty() &&
            baseType(expectedType) != baseType(producedType))
            error("reimport validation type mismatch: the matching unimport produced '" +
                      expectedType + "' but this expecting block returns '" + producedType + "'",
                  rv->loc);
        if (rv->onFailure) analyzeBlock(*rv->onFailure);
        return;
    }
    if (const auto* cm = dynamic_cast<const ast::CascadeMoveStmt*>(&stmt)) {
        const std::string t = typeOf(*cm->target);  // type-check the moved object
        if (!t.empty() && lookupClass(baseType(t)) == nullptr)
            error("'cascade move' expects a class object, got '" + t + "'", cm->loc);
        for (const std::string& rn : {cm->fromRegion, cm->toRegion}) {
            const LocalVar* rv = lookupLocal(rn);
            if (rv == nullptr) error("unknown region '" + rn + "'", cm->loc);
            else if (rv->type != "region") error("'" + rn + "' is not a region", cm->loc);
        }
        return;
    }
    if (const auto* cs = dynamic_cast<const ast::CascadeStmt*>(&stmt)) {
        // `cascade unimport X` (spec 37.1): same rules as plain unimport, applied to X and its
        // subtypes/monomorphizations (the expansion happens in codegen).
        if (cs->op == ast::CascadeOpKind::Unimport) {
            if (freestanding_)
                error("unimport is not available in freestanding mode (spec 36.3)", cs->loc);
            if (lookupClass(baseType(cs->typeName)) == nullptr)
                error("cannot unimport '" + cs->typeName + "': not a known class", cs->loc);
            else if (finalImports_.count(baseType(cs->typeName)) > 0)
                error("cannot unimport '" + cs->typeName +
                          "': it was brought in by 'final import' (spec 37.6)",
                      cs->loc);
            return;
        }
        // `cascade release persistent X` (spec 37.1): satisfy the release obligation for every
        // persistent reachable from X's owned graph (spec 18.15). Runtime release is a no-op today,
        // matching plain `release persistent`.
        if (cs->op == ast::CascadeOpKind::Release) {
            const std::string t = cs->target != nullptr ? baseType(typeOf(*cs->target)) : "";
            if (!t.empty() && lookupClass(t) == nullptr)
                error("'cascade release' expects a class object, got '" + t + "'", cs->loc);
            else if (!t.empty()) {
                std::unordered_set<std::string> seen;
                markCascadeReleased(t, seen);
            }
            return;
        }
        // `cascade println(X)` / `cascade validate(X)` (spec 37.1). The operand must be a class
        // object; an operation supports cascade only if its per-node form exists (rule 4):
        // println needs a describe() on the type, validate uses the type's invariants.
        if (cs->target != nullptr) {
            const std::string t = typeOf(*cs->target);
            const std::string cn = baseType(t);
            if (!t.empty() && lookupClass(cn) == nullptr) {
                error("'cascade' expects a class object, got '" + t + "'", cs->loc);
            } else if (cs->op == ast::CascadeOpKind::Println && !cn.empty() &&
                       findMethod(cn, "describe") == nullptr) {
                error("'cascade println' requires a 'describe()' method on '" + cn +
                          "' (spec 37.1 rule 4)",
                      cs->loc);
            }
        }
        if (cs->dest != nullptr) typeOf(*cs->dest);  // type-check `cascade clone X into <dest>`
        return;
    }
    if (const auto* def = dynamic_cast<const ast::DeferStmt*>(&stmt)) {
        analyzeBlock(def->body);
        return;
    }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(&stmt)) {
        pushScope();
        analyzeStatement(*us->decl);
        analyzeBlock(us->body);
        popScope();
        return;
    }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(&stmt)) {
        const std::string mt = baseType(typeOf(*sy->mutex));  // expect a Mutex<...> instance
        if (!mt.empty() && mt.rfind("Mutex", 0) != 0)
            error("synchronized requires a Mutex value, got '" + mt + "'", sy->loc);
        if (!sy->bindType.isRef)
            error("synchronized binding must be a reference (e.g. T& name)", sy->loc);
        // Awaiting while holding the lock would suspend the task with the mutex held -- a deadlock
        // risk (spec 22). Reject it; release the lock before awaiting (or await outside the block).
        if (blockHasAwait(sy->body))
            error("cannot 'await' while holding a mutex in a 'synchronized' block (spec 22); "
                  "await outside the locked region", sy->loc);
        pushScope();
        // Bind name to a mutable reference to the Mutex's protected value.
        declareLocal(sy->bindName, LocalVar{sy->bindType.name, true});
        analyzeBlock(sy->body);
        popScope();
        return;
    }
    if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(&stmt)) {
        if (freestanding_)
            error("exceptions are not available in freestanding mode; use Result/Option (spec 36.3)",
                  th->loc);
        const std::string t = typeOf(*th->value);
        if (!t.empty()) {
            const std::string bt = baseType(t);
            if (lookupClass(bt) == nullptr) {
                error("'throw' expects an object value; got '" + t + "'", th->loc);
            }
            // Any polymorphic object can be thrown/caught (not only Exception subtypes). Since every
            // class is now an Object, this is always satisfied -- the meaningful guard is "is a class".
            // The carrier must outlive unwinding: a stack object's pointer would dangle.
            bool stackThrow = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(th->value.get()))
                stackThrow = nw->location != "heap";
            else if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(th->value.get()))
                if (const LocalVar* v = lookupLocal(id->name)) stackThrow = v->isStackObject;
            if (stackThrow) {
                error("a thrown object must be heap-allocated; use 'new ... on heap'", th->loc);
            }
            // Checked exceptions (spec 21.1): a throw that is neither caught by an enclosing try nor
            // listed in the method's `throws` clause escapes undeclared -- warn.
            if (lookupClass(bt) != nullptr) {
                bool covered = false;
                for (auto frame = catchStack_.rbegin(); !covered && frame != catchStack_.rend(); ++frame)
                    for (const std::string& ct : *frame)
                        if (bt == ct || isSubtype(bt, ct)) { covered = true; break; }
                if (!covered)
                    for (const std::string& dt : currentThrows_)
                        if (bt == dt || isSubtype(bt, dt)) { covered = true; break; }
                if (!covered) {
                    std::string disp = bt;  // show the simple name, not the namespace-mangled one
                    if (auto p = disp.rfind("__"); p != std::string::npos) disp = disp.substr(p + 2);
                    warn("exception '" + disp + "' is neither caught nor declared in the method's "
                         "'throws' clause", th->loc);
                }
            }
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(&stmt)) {
        if (freestanding_)
            error("exceptions are not available in freestanding mode; use Result/Option (spec 36.3)",
                  tr->loc);
        // A throw inside the try body is covered if one of these catch types matches it (spec 21.1).
        std::vector<std::string> caught;
        for (const ast::CatchClause& cc : tr->catches) caught.push_back(baseType(typeRefStr(cc.type)));
        catchStack_.push_back(std::move(caught));
        analyzeBlock(tr->body);
        catchStack_.pop_back();
        for (const ast::CatchClause& cc : tr->catches) {
            const std::string ct = baseType(typeRefStr(cc.type));
            checkTypeAccessible(typeRefStr(cc.type), cc.loc);
            if (lookupClass(ct) == nullptr) {
                error("catch type '" + ct + "' is not a class", cc.loc);
            }
            // A catch type must be a class; every class is polymorphic (an Object) so it can be
            // matched by dynamic type.
            pushScope();
            declareLocal(cc.name, LocalVar{typeRefStr(cc.type), false});
            for (const auto& st : cc.body.statements) analyzeStatement(*st);
            popScope();
        }
        if (tr->finallyBlock) analyzeBlock(*tr->finallyBlock);
        return;
    }
    // `label`/`comefrom` (spec 7.10) are accepted but not analyzed beyond this (out of
    // current type-checking scope); handled explicitly so they are not silently ignored.
    // Chaos tetrad (spec 7.9-7.11), intra-method only: goto/comefrom/abstainfrom/reinstate must
    // target a `label name;` declared in the same method, and a label may have at most one comefrom.
    if (dynamic_cast<const ast::LabelMarkStmt*>(&stmt) != nullptr) return;  // a declaration
    if (const auto* cf = dynamic_cast<const ast::ComefromStmt*>(&stmt)) {
        if (methodLabels_.count(cf->name) == 0)
            error("comefrom references unknown label '" + cf->name + "' in this method (spec 7.10)",
                  cf->loc);
        else if (!comefromTargets_.insert(cf->name).second)
            error("label '" + cf->name +
                      "' already has a comefrom; at most one comefrom per label (spec 7.10)",
                  cf->loc);
        return;
    }
    if (const auto* g = dynamic_cast<const ast::GotoStmt*>(&stmt)) {  // spec 7.9
        if (g->address != nullptr) {
            typeOf(*g->address);  // raw-address FFI jump (unchecked): just type-check the operand
        } else if (methodLabels_.count(g->name) == 0 && externReturns_.count(g->name) == 0) {
            error("goto references unknown label or extern function '" + g->name +
                      "' in this method (spec 7.9)",
                  g->loc);
        }
        return;
    }
    if (const auto* ab = dynamic_cast<const ast::AbstainfromStmt*>(&stmt)) {  // spec 7.11
        if (methodLabels_.count(ab->name) == 0)
            error(std::string(ab->isReinstate ? "reinstate" : "abstainfrom") +
                      " references unknown label '" + ab->name + "' in this method (spec 7.11)",
                  ab->loc);
        return;
    }
}

void SemanticAnalyzer::checkCallArgs(const std::vector<ast::ExprPtr>& args,
                                    const std::vector<std::string>& paramTypes,
                                    const std::string& desc) {
    for (std::size_t i = 0; i < args.size(); ++i) {
        const std::string at = typeOf(*args[i]);
        if (i >= paramTypes.size()) continue;
        const std::string& pt = paramTypes[i];
        if (at.empty() || pt.empty()) continue;
        if (!isNullableType(pt) && (at == "null" || isNullableType(at))) {
            error("argument " + std::to_string(i + 1) + " to " + desc + " is " +
                      std::string(at == "null" ? "null" : "nullable") +
                      " but the parameter type '" + pt + "' is non-nullable",
                  args[i]->loc);
        } else if (!isSubtype(at, pt)) {
            error("argument " + std::to_string(i + 1) + " to " + desc + " has type '" + at +
                      "' but the parameter type is '" + pt + "'",
                  args[i]->loc);
        }
    }
}

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    if (dynamic_cast<const ast::IntLiteralExpr*>(&expr) != nullptr) return "int";
    if (const auto* fl = dynamic_cast<const ast::FloatLiteralExpr*>(&expr))
        return fl->isDecimal ? "Decimal" : "double";
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
    if (dynamic_cast<const ast::StringLiteralExpr*>(&expr) != nullptr) return "String";
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) return "boolean";
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) return "null";
    if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
        std::string s = "function<" + typeRefStr(lam->returnType);
        for (const auto& p : lam->params) s += "," + typeRefStr(p.type);
        return s + ">";
    }
    if (const auto* old = dynamic_cast<const ast::OldExpr*>(&expr)) {
        // old(e) in an ensures clause (spec 29): the entry-time value of e, so it has e's type.
        return typeOf(*old->inner);
    }
    if (const auto* mr = dynamic_cast<const ast::MethodRefExpr*>(&expr)) {
        // methodref obj.method (spec 22.3): its type is the method's function<Ret, Params...>.
        const std::string objType = typeOf(*mr->object);
        const std::string cls = baseType(objType);
        const MethodInfo* m = findMethod(cls, mr->method);
        if (m == nullptr) {
            error("no method '" + mr->method + "' on type '" + cls + "' for methodref", mr->loc);
            return "function<void>";
        }
        if (m->isStatic) {
            error("methodref cannot bind a static method; reference it by name instead", mr->loc);
            return "function<void>";
        }
        std::string s = "function<" + m->returnType;
        for (const std::string& pt : m->paramTypes) s += "," + pt;
        return s + ">";
    }

    if (const auto* tup = dynamic_cast<const ast::TupleExpr*>(&expr)) {
        // A tuple literal's type is "(c0,c1,...)" of its components' types.
        std::string s = "(";
        for (std::size_t i = 0; i < tup->elements.size(); ++i) {
            const std::string et = typeOf(*tup->elements[i]);
            if (et.empty()) return "";
            s += (i ? "," : "") + et;
        }
        return s + ")";
    }

    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        if (id->name == "this") {
            if (currentClass_.empty()) {
                error("'this' is not available in a static context", id->loc);
                return "";
            }
            return currentClass_;
        }
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            // A namespace-level compile-time constant (spec 28.1).
            if (auto cit = constTypes_.find(id->name); cit != constTypes_.end())
                return cit->second;
            // A bare enum constant inside one of that enum's own methods (spec 12.2/12.4):
            // `return v8;` resolves to the enum value without the `Enum.` prefix.
            if (auto eit = enums_.find(currentClass_);
                eit != enums_.end() &&
                std::find(eit->second.begin(), eit->second.end(), id->name) != eit->second.end()) {
                return currentClass_;
            }
            error("use of undeclared variable '" + id->name + "'", id->loc);
            return "";
        }
        if (moved_.count(id->name) > 0) {
            error("use of variable '" + id->name +
                      "' after it was moved (reassign it before using)",
                  id->loc);
        }
        return var->type;
    }

    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
        if (freestanding_)
            error("async/await is not available in freestanding mode (spec 36.3)", aw->loc);
        // await Task<T> -> T (spec 20.2).
        const std::string t = baseType(typeOf(*aw->operand));
        if (!t.empty() && t.rfind("Task$", 0) != 0) {
            error("'await' expects a Task value, got '" + t + "'", aw->loc);
            return "";
        }
        return t.empty() ? std::string() : t.substr(5);  // strip "Task$"
    }
    if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(&expr)) {
        if (freestanding_)
            error("unimport/reimport is not available in freestanding mode (spec 36.3)", ue->loc);
        if (lookupClass(baseType(ue->target)) == nullptr)
            error("cannot unimport '" + ue->target + "': not a known class", ue->loc);
        else if (finalImports_.count(baseType(ue->target)) > 0)
            error("cannot unimport '" + ue->target +
                      "': it was brought in by 'final import' (spec 37.6)",
                  ue->loc);
        return analyzeExpectingBlock(ue->expecting.get());  // value type = expecting block's return
    }
    if (const auto* rng = dynamic_cast<const ast::RangeExpr*>(&expr)) {
        const std::string st = typeOf(*rng->start);  // a range over int (spec 7.5)
        typeOf(*rng->end);
        if (rng->step) typeOf(*rng->step);
        return st.empty() ? std::string("int") : st;
    }
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string t = typeOf(*un->operand);
        if (un->op == "&") {
            return t.empty() ? std::string() : t + "*";  // address-of: T -> T*
        }
        // Unary operator overload (spec 6.5): a class operand whose class defines a no-arg
        // operator<op> dispatches to it (paramCount 0 distinguishes it from the binary form).
        if (const MethodInfo* opm = findMethod(baseType(t), "operator" + un->op);
            opm != nullptr && opm->paramCount == 0)
            return opm->returnType;
        if (un->op == "!") {
            if (!t.empty() && t != "boolean") error("unary '!' requires a boolean operand", un->loc);
            return "boolean";
        }
        if (un->op == "~") {  // bitwise not: integers only
            if (!t.empty() && (!isNumeric(t) || isFloatType(t)))
                error("unary '~' requires an integer operand", un->loc);
            return t.empty() ? std::string("int") : t;
        }
        // unary '-' / '+': any numeric operand, keeping its type (width and int/float).
        if (!t.empty() && !isNumeric(t))
            error("unary '" + un->op + "' requires a numeric operand", un->loc);
        return t.empty() ? std::string("int") : t;
    }

    if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
        const std::string subjType = typeOf(*me->subject);
        const std::string subjBase = baseType(subjType);
        std::string resultType;
        const auto subjDollarM = subjBase.find('$');
        for (const ast::MatchCase& c : me->cases) {
            // Map a bare case name to the subject's instantiation (Ok -> Ok$int$int).
            const std::string caseType = subjDollarM == std::string::npos
                                             ? c.typeName
                                             : c.typeName + subjBase.substr(subjDollarM);
            const ClassInfo* ci = lookupClass(caseType);
            if (ci == nullptr) {
                error("unknown type '" + c.typeName + "' in match case", c.loc);
            } else if (!subjType.empty() && !isSubtype(caseType, subjBase)) {
                error("'" + c.typeName + "' is not a subtype of '" + subjType + "'", c.loc);
            }
            // Bindings introduce the case type's fields as locals in the arm body.
            pushScope();
            for (const ast::Param& b : c.bindings)
                declareLocal(b.name, LocalVar{typeRefStr(b.type), false});
            const std::string at = c.result ? typeOf(*c.result) : analyzeYieldBlock(c.body);
            popScope();
            if (resultType.empty()) resultType = at;
        }
        if (me->defaultResult) {
            const std::string dt = typeOf(*me->defaultResult);
            if (resultType.empty()) resultType = dt;
        } else if (me->defaultBody) {
            const std::string dt = analyzeYieldBlock(*me->defaultBody);
            if (resultType.empty()) resultType = dt;
        }
        // Exhaustiveness (spec 16.1): a sealed subject must cover every permit with no
        // default; otherwise a default arm is required so the expression always yields.
        const ClassInfo* sc = lookupClass(subjBase);
        if (sc != nullptr && sc->isSealed) {
            for (const std::string& p : sc->permits) {
                bool covered = false;
                for (const ast::MatchCase& c : me->cases)
                    if (c.typeName == p) covered = true;
                if (!covered && !me->defaultResult && !me->defaultBody)
                    error("match on sealed '" + subjBase +
                              "' is not exhaustive: missing case '" + p + "'",
                          me->loc);
            }
        } else if (!me->defaultResult && !me->defaultBody) {
            error("match expression requires a 'default' arm (the subject is not sealed)",
                  me->loc);
        }
        me->resultType = resultType;
        return resultType;
    }

    if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) {
        const std::string t = typeOf(*mv->operand);
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mv->operand.get())) {
            moved_.insert(id->name);  // the source variable becomes invalid
        } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(mv->operand.get())) {
            // Partial field move (spec 19.9): only a movable/unique field of a partitionable class.
            const std::string oc = baseType(typeOf(*mem->object));
            const ClassInfo* ci = lookupClass(oc);
            const FieldInfo* fi = ci != nullptr ? findField(oc, mem->member) : nullptr;
            if (ci != nullptr && fi != nullptr) {
                if (!ci->isPartitionable)
                    error("cannot move field '" + mem->member + "' of non-partitionable class '" +
                              oc + "'; mark the class 'partitionable' (spec 19.9)",
                          mv->loc);
                else if (!fi->isMovable && !fi->isUnique)
                    error("cannot move field '" + mem->member +
                              "': only a 'movable' or 'unique' field can be moved separately (spec 19.9)",
                          mv->loc);
                else if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get()))
                    moved_.insert(oid->name + "." + mem->member);  // track the field as moved
            }
        }
        return mv->castType.empty() ? t : mv->castType;  // `move x as T` reinterprets to T (spec 19.3)
    }
    if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
        // try? Result<T,E>/Option<T> yields T (the first type arg of the operand's instantiation).
        const std::string ot = baseType(typeOf(*tx->operand));
        const auto p = ot.find('$');
        if (p == std::string::npos) return "";
        const std::string rest = ot.substr(p + 1);
        const auto q = rest.find('$');
        return q == std::string::npos ? rest : rest.substr(0, q);
    }

    if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(&expr)) {
        if (ri->size) typeOf(*ri->size);
        if (ri->atAddress) {  // itself.at(addr, size): the address must be numeric/address
            const std::string at = typeOf(*ri->atAddress);
            if (!at.empty() && !isNumeric(at))
                error("region address must be a number or address, got '" + at + "'", ri->loc);
        }
        // Constrained types must exist (dotted family names like Animal.X are a
        // later refinement and are skipped here).
        for (const auto& list : {ri->accepts, ri->rejects}) {
            for (const std::string& t : list) {
                if (t.find('.') == std::string::npos && lookupClass(t) == nullptr) {
                    error("region accepts/rejects references unknown type '" + t + "'", ri->loc);
                }
            }
        }
        return "region";
    }

    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        const std::string srcRaw = typeOf(*cst->operand);
        const std::string& dst = cst->targetType;
        checkBitCounted(dst, cst->loc);  // reject cast<int64> etc. outside freestanding mode
        // A `newtype` casts to/from its underlying type (spec 24): classify both by the underlying
        // so cast<OrderId>(long) and cast<long>(orderId) are accepted while staying distinct types.
        auto under = [&](const std::string& t) {
            auto it = newtypes_.find(baseType(t));
            return it != newtypes_.end() ? it->second : t;
        };
        const std::string src = under(srcRaw);
        const bool dstRef = dst == "Object" || lookupClass(baseType(dst)) != nullptr;
        const bool srcRef = src.empty() || src == "Object" || src == "Type" || src == "Method" ||
                            lookupClass(baseType(src)) != nullptr || isRefType(src);
        const bool dstPtr = isRefType(dst) || dstRef;  // pointer/reference target (T*, T&, class)
        // `char` is an integer for casting purposes; Decimal converts to/from the numeric family too
        // (scaled fixed-point, spec 34).
        auto numLike = [](const std::string& t) {
            return isNumeric(t) || t == "char" || t == "Decimal";
        };
        const std::string dstU = under(dst);  // a newtype's underlying decides how the cast lowers
        if (numLike(dstU)) {
            // numeric <- numeric/char, a pointer/address reinterpreted as an integer (spec 17.8), or
            // an int-style enum reinterpreted as its ordinal (spec 12.1).
            const bool srcIntEnum = enums_.count(baseType(src)) > 0;
            if (!src.empty() && !numLike(src) && !srcRef && !srcIntEnum)
                error("cannot cast '" + srcRaw + "' to '" + dst + "'", cst->loc);
        } else if (dstPtr) {
            // Reference downcast (spec 31), or int/address -> an explicit pointer T* (spec 17.8).
            // Casting a number to a bare class (not a pointer) stays an error.
            const bool intToPtr = isRefType(dst) && isNumeric(src);
            if (!src.empty() && !srcRef && !intToPtr)
                error("cannot cast '" + src + "' to '" + dst + "'", cst->loc);
        } else {
            error("cast<" + dst + "> is not supported here", cst->loc);
        }
        return dst;
    }

    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        const std::string ct = typeOf(*tern->cond);
        if (!ct.empty() && ct != "boolean")
            error("ternary condition must be boolean, got '" + ct + "'", tern->loc);
        const std::string tt = typeOf(*tern->thenExpr);
        typeOf(*tern->elseExpr);
        return tt;
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&expr)) {  // a ?? b (spec 3.7)
        const std::string lt = typeOf(*nc->lhs);
        const std::string rt = typeOf(*nc->rhs);
        const std::string base = isNullableType(lt) ? lt.substr(0, lt.size() - 1) : lt;
        // The fallback's base must be compatible with the left's base.
        if (!base.empty() && !rt.empty()) {
            const std::string rbase = isNullableType(rt) ? rt.substr(0, rt.size() - 1) : rt;
            if (rbase != "null" && !isSubtype(rbase, base) && !isSubtype(base, rbase))
                error("'??' fallback of type '" + rt + "' is incompatible with '" + lt + "'", nc->loc);
        }
        // Result is the left's non-null base, but stays nullable if the fallback can be null.
        return isNullableType(rt) ? base + "?" : base;
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        const std::string lt = typeOf(*bin->lhs);
        const std::string rt = typeOf(*bin->rhs);
        const std::string& op = bin->op;
        // Operator overloading: a OP b where a's class defines `operator OP` (spec 6.5).
        if (const MethodInfo* om = findMethod(baseType(lt), "operator" + op)) {
            return om->returnType;
        }
        // SIMD vectors: element-wise + - * / ; a scalar operand broadcasts.
        if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) {
            if (op != "+" && op != "-" && op != "*" && op != "/")
                error("operator '" + op + "' is not defined on vectors", bin->loc);
            return "vec" + std::to_string(vw);
        }
        // String concatenation (spec 4): String/string + String/string -> String.
        auto isStr = [](const std::string& t) { return t == "String" || t == "string"; };
        if (op == "+" && isStr(lt) && isStr(rt)) return "String";
        // Decimal fixed-point (spec 34): arithmetic yields a Decimal, comparison a boolean. A mixed
        // Decimal/other operand needs an explicit cast.
        if (lt == "Decimal" && rt == "Decimal") {
            if (op == "+" || op == "-" || op == "*" || op == "/") return "Decimal";
            if (op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=")
                return "boolean";
        }
        // `char` is an integer (i32) for arithmetic/comparison/bitwise (e.g. c - '0', c >= '0').
        auto numOk = [](const std::string& t) { return isNumeric(t) || t == "char"; };
        if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%") {
            if ((!lt.empty() && !numOk(lt)) || (!rt.empty() && !numOk(rt))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            if (op == "%" && (isFloatType(lt) || isFloatType(rt))) {
                error("operator '%' requires int operands", bin->loc);
            }
            if (isFloatType(lt) || isFloatType(rt)) {  // f32 only if neither side is f64
                const bool f64 = lt == "double" || lt == "float64" || rt == "double" || rt == "float64";
                return f64 ? "double" : "float";
            }
            return intBits(lt) >= intBits(rt) ? lt : rt;  // wider integer wins
        }
        if (op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>") {
            if (isFloatType(lt) || isFloatType(rt) || (!lt.empty() && !numOk(lt)) ||
                (!rt.empty() && !numOk(rt))) {
                error("operator '" + op + "' requires integer operands", bin->loc);
            }
            return intBits(lt) >= intBits(rt) ? lt : rt;
        }
        if (op == "<" || op == ">" || op == "<=" || op == ">=") {
            if ((!lt.empty() && !numOk(lt)) || (!rt.empty() && !numOk(rt))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            return "boolean";
        }
        if (op == "==" || op == "!=") {
            const bool nullPtr =
                (lt == "null" && (isRefType(rt) || isNullableType(rt))) ||
                (rt == "null" && (isRefType(lt) || isNullableType(lt)));
            // Numeric (and char) operands compare after widening to a common type, so differing
            // integer/float widths are fine (e.g. a long compared with an int literal).
            const bool bothNumeric = numOk(lt) && numOk(rt);
            if (!lt.empty() && !rt.empty() && lt != rt && !nullPtr && !bothNumeric) {
                error("operator '" + op + "' requires operands of the same type", bin->loc);
            }
            return "boolean";
        }
        if (op == "&&" || op == "||") {
            if ((!lt.empty() && lt != "boolean") || (!rt.empty() && rt != "boolean")) {
                error("operator '" + op + "' requires boolean operands", bin->loc);
            }
            return "boolean";
        }
        error("unsupported binary operator '" + op + "'", bin->loc);
        return "";
    }

    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
        const std::string cn = ast::mangleGeneric(nw->className, nw->typeArgs);  // Box<int> -> Box$int
        checkTypeAccessible(cn, nw->loc);
        const ClassInfo* ci = lookupClass(cn);
        if (ci == nullptr) {
            error("unknown class '" + cn + "'", nw->loc);
            return "";
        }
        if (ci->isInterface || ci->isAbstract) {
            error("cannot instantiate " +
                      std::string(ci->isInterface ? "interface" : "abstract class") + " '" + cn + "'",
                  nw->loc);
        }
        if (nw->location != "stack" && nw->location != "heap") {
            error("'new' location must be 'stack' or 'heap', got '" + nw->location + "'", nw->loc);
        }
        if (!nw->region.empty()) {
            const auto dot = nw->region.find('.');
            if (dot != std::string::npos) {
                // `new X in region this.field` (spec 17: region as a field): validate the field.
                const std::string fieldName = nw->region.substr(dot + 1);
                const FieldInfo* f =
                    currentClass_.empty() ? nullptr : findField(currentClass_, fieldName);
                if (f == nullptr)
                    error("unknown region field '" + nw->region + "'", nw->loc);
                else if (f->type != "region")
                    error("'" + nw->region + "' is not a region", nw->loc);
            } else {
                const LocalVar* r = lookupLocal(nw->region);
                if (r == nullptr) {
                    error("unknown region '" + nw->region + "'", nw->loc);
                } else if (r->type != "region") {
                    error("'" + nw->region + "' is not a region", nw->loc);
                } else {
                    checkRegionAccepts(nw->region, cn, nw->loc);
                }
            }
        }
        // Full construction: arguments align 1:1 with parameters, so type-check them. Fewer
        // arguments is a partial constructor (spec 18.9) -- omitted params come from persistent
        // fields and the alignment is not 1:1, so only the too-many case is an error there.
        if (nw->args.size() == ci->ctorParamTypes.size()) {
            checkCallArgs(nw->args, ci->ctorParamTypes, "constructor '" + cn + "'");
        } else {
            for (const auto& arg : nw->args) typeOf(*arg);
            if (nw->args.size() > ci->ctorParamTypes.size()) {
                error("constructor '" + cn + "' expects at most " +
                          std::to_string(ci->ctorParamTypes.size()) + " argument(s) but got " +
                          std::to_string(nw->args.size()),
                      nw->loc);
            } else {
                // Fewer arguments is a partial constructor (spec 18.9), valid only when the class has
                // persistent fields to supply the omitted parameters; otherwise it is a missing
                // argument (calling the constructor with too few would be undefined).
                bool hasPersist = false;
                for (std::string c = baseType(cn); !c.empty() && !hasPersist;) {
                    for (const PersistentFieldInfo& pf : persistentFields_)
                        if (pf.cls == c) { hasPersist = true; break; }
                    const ClassInfo* ic = lookupClass(c);
                    c = ic != nullptr ? ic->superclass : std::string();
                }
                if (!hasPersist)
                    error("constructor '" + cn + "' expects " +
                              std::to_string(ci->ctorParamTypes.size()) + " argument(s) but got " +
                              std::to_string(nw->args.size()),
                          nw->loc);
            }
        }
        return cn;
    }

    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
        const std::string st = typeOf(*na->size);
        if (!st.empty() && st != "int") error("array size must be an int", na->loc);
        return na->elementType + "[]";
    }
    if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(&expr)) {  // `[a, b, c]` (spec 25)
        if (al->elements.empty()) {
            error("empty array literal '[]' has no inferable element type; use 'new T[0]()'",
                  al->loc);
            return "";
        }
        const std::string elem = typeOf(*al->elements[0]);
        for (std::size_t i = 1; i < al->elements.size(); ++i) {
            const std::string et = typeOf(*al->elements[i]);
            if (!et.empty() && !elem.empty() && !isSubtype(et, elem) && !isSubtype(elem, et))
                error("array literal element " + std::to_string(i + 1) + " has type '" + et +
                          "', incompatible with '" + elem + "'",
                      al->elements[i]->loc);
        }
        return elem + "[]";
    }

    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        const std::string at = typeOf(*ix->array);
        const std::string it = typeOf(*ix->index);
        // operator[] overload (spec 6.5): `obj[i]` where obj's class defines operator[].
        if (const MethodInfo* om = findMethod(baseType(at), "operator[]")) {
            return om->returnType;
        }
        if (vecWidth(at) > 0) {  // SIMD vector: v[i] -> float
            if (!it.empty() && it != "int") error("vector index must be an int", ix->loc);
            return "float";
        }
        if (!it.empty() && !isIntName(it)) error("index must be an integer", ix->loc);
        if (at.empty()) return "";
        if (isRefType(at)) return baseType(at);  // p[i] on a raw pointer T* -> T (spec 17.8)
        if (!isArrayType(at)) {
            error("cannot index a value of non-array type '" + at + "'", ix->loc);
            return "";
        }
        return elementOf(at);
    }

    if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(&expr)) {
        for (const auto& e : is->exprs) {
            const std::string t = typeOf(*e);
            const bool printable = t.empty() || isIntName(t) || isFloatType(t) || t == "char" ||
                                   t == "boolean" || t == "String" || t == "string" ||
                                   t == "Decimal" || enums_.count(t) > 0 || catalogs_.count(t) > 0;
            if (!printable) {
                error("string interpolation can only print numeric, char, boolean, String, Decimal or "
                      "enum values, got '" + t + "'",
                      e->loc);
            }
        }
        return "string";
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        // SIMD vector construction: vec4(x,y,z,w) etc. -- N numeric args -> vecN.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (int w = vecWidth(cid->name); w > 0) {
                if (static_cast<int>(call->args.size()) != w)
                    error(cid->name + " takes " + std::to_string(w) + " components", call->loc);
                for (const auto& arg : call->args) {
                    const std::string at = typeOf(*arg);
                    if (!at.empty() && !isNumeric(at))
                        error(cid->name + " components must be numeric, got '" + at + "'", arg->loc);
                }
                return cid->name;
            }
        }
        // Calling a function value: callee is a local of type function<Ret, Params...> -> Ret.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (const LocalVar* fv = lookupLocal(cid->name);
                fv != nullptr && fv->type.rfind("function<", 0) == 0) {
                for (const auto& arg : call->args) typeOf(*arg);
                const std::string inner = fv->type.substr(9, fv->type.size() - 10);
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') depth++;
                    else if (inner[i] == '>') depth--;
                    else if (inner[i] == ',' && depth == 0) return inner.substr(0, i);  // the Ret
                }
                return inner;  // no params -> the whole inner is the return type
            }
        }
        // super(args): explicitly call the base constructor to pass arguments.
        if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr) {
            if (!inConstructor_) {
                error("'super(...)' is only valid inside a constructor", call->loc);
            } else {
                const ClassInfo* ci = lookupClass(currentClass_);
                if (ci == nullptr || ci->superclass.empty()) {
                    error("'super(...)' requires a superclass, but '" + currentClass_ +
                              "' has none",
                          call->loc);
                }
            }
            for (const auto& arg : call->args) typeOf(*arg);
            return "void";
        }
        const std::string name = flattenCallee(*call->callee);
        // sizeof(Type) / sizeof(expr) (spec, issue #7): byte size as an int. The argument may name a
        // type, so it is not type-checked as an ordinary value here.
        if (name == "sizeof" && call->args.size() == 1) return "int";
        // Type.sizeof() (spec issue #7): the member form on a class type.
        if (const auto* sm = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            sm != nullptr && sm->member == "sizeof" && call->args.empty() &&
            lookupClass(baseType(flattenCallee(*sm->object))) != nullptr)
            return "int";
        // Namespace-level literal suffix function called by name: kilobytes(64).
        if (auto lit = literals_.find(name); lit != literals_.end() && !lit->second.empty()) {
            // The bare call form `name(arg)` is gone (spec 17.10): a suffix is used as the `N name`
            // sugar (which needs the suffix imported) or qualified by its owner as `Type.name(N)`.
            if (!call->fromSuffix) {
                error("call a literal suffix as 'N " + name + "' (imported) or '<Type>." + name +
                          "(N)'; the bare '" + name + "(N)' form is not allowed",
                      call->loc);
            } else if (importedSuffixes_.count(name) == 0) {
                error("literal suffix '" + name +
                          "' is not in scope; import it to use the 'N " + name + "' form",
                      call->loc);
            }
            const std::vector<LiteralInfo>& ovs = lit->second;
            if (call->args.size() != 1) {
                error("literal suffix '" + name + "' takes exactly one argument", call->loc);
                return ovs[0].returnType;
            }
            // A literal suffix may only be applied to a compile-time constant (spec 17.10): this is
            // what keeps `comptime literal` from becoming a runtime free function. Both `N suffix`
            // and the explicit `name(arg)` form require a literal/const argument.
            if (!isCompileTimeConstant(*call->args[0]))
                error("literal suffix '" + name +
                          "' applies only to a compile-time constant; calling it with a runtime "
                          "value is not allowed (a literal suffix is not a free function)",
                      call->loc);
            // Overload resolution by the literal's type (spec 17.10 rule 6): an exact parameter-type
            // match wins; otherwise the first overload is used and the argument is coerced.
            const std::string at = typeOf(*call->args[0]);
            const LiteralInfo* chosen = &ovs[0];
            for (const LiteralInfo& ov : ovs)
                if (ov.paramType == at) { chosen = &ov; break; }
            return chosen->returnType;
        }
        // Low-level thread builtins used by the System.Concurrency.Thread prelude class.
        if (name == "System.Concurrency.__threadStart") {
            if (call->args.size() != 1) error("__threadStart takes one function<void>", call->loc);
            else typeOf(*call->args.front());
            return "long";  // the OS thread handle
        }
        // Low-level Mutex lock builtins (used by the System.Concurrency.Mutex prelude class).
        if (name == "System.Concurrency.__lockCreate") {
            if (!call->args.empty()) error("__lockCreate takes no arguments", call->loc);
            return "long";  // an opaque lock handle
        }
        if (name == "System.Concurrency.__chanNew") {  // used by the Channel prelude class
            if (call->args.size() != 1) error("__chanNew takes one capacity", call->loc);
            else typeOf(*call->args.front());
            return "long";  // an opaque channel handle
        }
        if (name == "System.Concurrency.__lockAcquire" ||
            name == "System.Concurrency.__lockRelease") {
            if (call->args.size() != 1) error("lock op takes one handle", call->loc);
            else typeOf(*call->args.front());
            return "void";
        }
        if (name == "System.Concurrency.__threadJoin") {
            if (call->args.size() != 1) error("__threadJoin takes one handle", call->loc);
            else typeOf(*call->args.front());
            return "void";
        }
        // Console I/O (spec 4): System.IO.Console.{printf,println,print,readInt}. The pre-F10
        // names (System.IO.printf/println/readInt, bare Console.*) are kept as aliases until the
        // samples are migrated. Requires `import System.IO.Console;`.
        {
            const bool isRead = name == "System.IO.Console.read";
            const bool isPrintf = name == "System.IO.Console.printf";
            const bool isPrintln = name == "System.IO.Console.println";
            const bool isPrint = name == "System.IO.Console.print";
            if (isRead || isPrintf || isPrintln || isPrint) {
                if (freestanding_)
                    error("Console (managed stdlib) is not available in freestanding mode; use FFI "
                          "for I/O (spec 36.3)",
                          call->loc);
                checkTypeAccessible("Console", call->loc);  // require the import
                if (isRead) {
                    if (!call->args.empty()) error("Console.read takes no arguments", call->loc);
                    return "String";  // read() returns a line; parse it (e.g. toInt) for other types
                }
                if (isPrintf && call->args.empty())
                    error("printf requires a format string", call->loc);
                // The first argument must be a string literal/interpolation (a format), or -- for
                // println/print -- a String value. printf requires the format form specifically.
                if (!call->args.empty()) {
                    const ast::Expr* f = call->args.front().get();
                    const bool fmt = dynamic_cast<const ast::StringLiteralExpr*>(f) != nullptr ||
                                     dynamic_cast<const ast::InterpStringExpr*>(f) != nullptr;
                    if (!fmt) {
                        const std::string at = typeOf(*f);
                        if (isPrintf)
                            error("the first argument to printf must be a string literal or "
                                  "interpolated string", f->loc);
                        else if (!at.empty() && at != "String" && at != "string")
                            error("println/print expects a string literal, interpolation, or "
                                  "String value, got '" + at + "'", f->loc);
                    }
                }
                for (const auto& arg : call->args) typeOf(*arg);
                return "void";
            }
        }
        // External C function (spec 26): a bare call `name(args)` to an `extern` declaration.
        if (auto ext = externReturns_.find(name); ext != externReturns_.end()) {
            for (const auto& arg : call->args) typeOf(*arg);
            return ext->second;
        }
        // Math (spec 34.6): static functions on double, lowered to LLVM intrinsics.
        if (name.rfind("Math.", 0) == 0) {
            const std::string fn = name.substr(5);
            const bool unary = fn == "sqrt" || fn == "abs" || fn == "floor" || fn == "ceil" ||
                               fn == "round" || fn == "trunc" || fn == "sin" || fn == "cos" ||
                               fn == "exp" || fn == "log" || fn == "tan" || fn == "asin" ||
                               fn == "acos" || fn == "atan" || fn == "sinh" || fn == "cosh" ||
                               fn == "tanh" || fn == "cbrt" || fn == "log2" || fn == "log10";
            const bool binary = fn == "pow" || fn == "min" || fn == "max" || fn == "atan2" ||
                                fn == "hypot";
            const bool ternary = fn == "clamp" || fn == "lerp";
            if (unary || binary || ternary) {
                checkTypeAccessible("Math", call->loc);  // require `import System.Math.Math;`
                for (const auto& a : call->args) typeOf(*a);
                const std::size_t want = unary ? 1u : (binary ? 2u : 3u);
                if (call->args.size() != want)
                    error("Math." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                return "double";
            }
        }
        // Memory API (spec 17.8): low-level address-based memory access (freestanding-safe).
        if (name == "Memory.alloc") {
            if (call->args.size() != 1) error("Memory.alloc takes a byte count", call->loc);
            else typeOf(*call->args.front());
            return "address";
        }
        if (name == "Memory.free") {
            if (call->args.size() != 1) error("Memory.free takes an address", call->loc);
            else typeOf(*call->args.front());
            return "void";
        }
        if (name == "Memory.getMemory") {
            if (call->args.size() != 1) error("Memory.getMemory takes one argument", call->loc);
            else typeOf(*call->args.front());
            return "address";
        }
        if (name == "Memory.read") {
            if (call->typeArgs.size() != 1) error("Memory.read<T> needs a type argument", call->loc);
            for (const auto& a : call->args) typeOf(*a);
            return call->typeArgs.empty() ? "" : call->typeArgs[0];
        }
        if (name == "Memory.write") {
            for (const auto& a : call->args) typeOf(*a);
            return "void";
        }
        // Net (spec 34): TCP client builtins. Require `import System.Net.Net;` (used by Socket).
        if (name.rfind("Net.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "connect" || fn == "send" || fn == "recv" || fn == "close") {
                checkTypeAccessible("Net", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                if (fn == "connect") return "long";   // (host, port) -> socket handle (or -1)
                if (fn == "send") return "long";      // (sock, data) -> bytes sent
                if (fn == "recv") return "String";    // (sock, max) -> received bytes
                return "void";                        // close(sock)
            }
        }
        // File I/O (spec 34.4): static methods lowering to runtime stdio. Require `import System.IO.File;`.
        if (name.rfind("File.", 0) == 0) {
            const std::string fn = name.substr(5);
            if (fn == "readAll" || fn == "writeAll" || fn == "appendAll" || fn == "exists" ||
                fn == "remove") {
                checkTypeAccessible("File", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                const std::size_t want = (fn == "writeAll" || fn == "appendAll") ? 2u : 1u;
                if (call->args.size() != want)
                    error("File." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                return fn == "readAll" ? "String" : "boolean";
            }
        }
        // Time (spec 34): clock + sleep builtins. Require `import System.Time.Time;`.
        if (name.rfind("Time.", 0) == 0) {
            const std::string fn = name.substr(5);
            if (fn == "millis" || fn == "nanos" || fn == "unixMillis" || fn == "sleep") {
                checkTypeAccessible("Time", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                if (fn == "sleep") {
                    if (call->args.size() != 1) error("Time.sleep takes a millisecond count", call->loc);
                    return "void";
                }
                if (!call->args.empty()) error("Time." + fn + " takes no arguments", call->loc);
                return "long";
            }
        }
        // Memory.readString(address, len): build a String from a raw byte buffer (StringBuilder).
        if (name == "Memory.readString") {
            if (call->args.size() != 2) error("Memory.readString takes (address, length)", call->loc);
            for (const auto& a : call->args) typeOf(*a);
            return "String";
        }
        // Channel.select() (spec 20.4): starts a fluent select builder over multiple channels.
        if (name == "Channel.select") {
            if (!call->args.empty()) error("Channel.select takes no arguments", call->loc);
            return "Select";
        }
        // reflect.typeOf<T>() (spec 31): the Type token for class T. It is the only entry to
        // reflection, so requiring its import here gates the whole reflect.* surface.
        if (name == "reflect.typeOf") {
            if (currentImports_.count("reflect") == 0)
                error("reflection requires 'import reflect;'", call->loc);
            if (freestanding_)
                error("reflection is not available in freestanding mode (spec 36.3)", call->loc);
            if (call->typeArgs.size() != 1) {
                error("reflect.typeOf expects one type argument, e.g. reflect.typeOf<Dog>()",
                      call->loc);
                return "Type";
            }
            const std::string t = ast::mangleGeneric(call->typeArgs[0], {});
            if (lookupClass(t) == nullptr)
                error("reflect.typeOf<T>: '" + t + "' is not a class", call->loc);
            return "Type";
        }
        // Otherwise the callee should be a method: obj.method(...) or, when the
        // receiver names a class, a static call ClassName.method(...).
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                    if (const ClassInfo* sc = lookupClass(objId->name)) {
                        // Qualified literal suffix: Type.kib(64) (spec 17.10). A literal suffix is not
                        // in the method table, so resolve it before the method lookup.
                        if (auto lit = literals_.find(mem->member); lit != literals_.end()) {
                            const LiteralInfo* chosen = nullptr;
                            const std::string at = call->args.size() == 1 ? typeOf(*call->args[0]) : "";
                            for (const LiteralInfo& ov : lit->second)
                                if (ov.ownerClass == objId->name) {
                                    if (chosen == nullptr || ov.paramType == at) chosen = &ov;
                                    if (ov.paramType == at) break;
                                }
                            if (chosen != nullptr) {
                                if (call->args.size() != 1)
                                    error("literal suffix '" + mem->member +
                                              "' takes exactly one argument", call->loc);
                                else if (!isCompileTimeConstant(*call->args[0]))
                                    error("literal suffix '" + objId->name + "." + mem->member +
                                              "' applies only to a compile-time constant", call->loc);
                                return chosen->returnType;
                            }
                        }
                        auto mit = sc->methods.find(mem->member);
                        if (mit == sc->methods.end()) {
                            error("class '" + objId->name + "' has no method '" + mem->member + "'",
                                  call->loc);
                            return "";
                        }
                        if (!mit->second.isStatic) {
                            error("method '" + mem->member + "' is not static; call it on an instance",
                                  call->loc);
                            return "";
                        }
                        checkCallArgs(call->args, mit->second.paramTypes, "'" + mem->member + "'");
                        if (call->args.size() != mit->second.paramCount) {
                            error("method '" + mem->member + "' expects " +
                                      std::to_string(mit->second.paramCount) + " argument(s) but got " +
                                      std::to_string(call->args.size()),
                                  call->loc);
                        }
                        // An async static method yields a Task<returnType> (spec 20.2).
                        if (mit->second.isAsync)
                            return ast::mangleGeneric("Task", {mit->second.returnType});
                        return mit->second.returnType;
                    }
                }
            }
            // Enum built-ins: EnumName.count() / EnumName.values() (spec 12.5).
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (lookupLocal(oid->name) == nullptr && enums_.count(oid->name) > 0) {
                    if (mem->member == "count" && call->args.empty()) return "int";
                    if (mem->member == "values" && call->args.empty()) return oid->name + "[]";
                    if (mem->member == "random" && call->args.empty()) return oid->name;
                    if (mem->member == "parse" && call->args.size() == 1) {  // -> Option<Enum>
                        typeOf(*call->args[0]);
                        return "Option$" + oid->name;
                    }
                    error("enum '" + oid->name + "' has no built-in '" + mem->member + "'",
                          call->loc);
                    return "";
                }
            }
            std::string objType = typeOf(*mem->object);
            if (objType.empty()) return "";
            // Null safety (spec 3.7): `nullable` only constrains assignment -- a nullable value may
            // be dereferenced directly (no flow-check required); if it is null at runtime the deref
            // traps. So resolve the member against the underlying type.
            if (isNullableType(objType)) objType = baseType(objType);
            // Enum (catalog) instance method: m.pick() where m is an enum value.
            if (auto emit = enumMethods_.find(baseType(objType)); emit != enumMethods_.end()) {
                auto mit = emit->second.find(mem->member);
                if (mit != emit->second.end()) {
                    for (const auto& arg : call->args) typeOf(*arg);
                    const std::size_t want = enumMethodParams_[baseType(objType)][mem->member];
                    if (call->args.size() != want) {
                        error("method '" + mem->member + "' expects " + std::to_string(want) +
                                  " argument(s) but got " + std::to_string(call->args.size()),
                              call->loc);
                    }
                    return mit->second.returnType;
                }
            }
            if (isArrayType(objType)) {
                if (mem->member == "length" && call->args.empty()) return "int";  // read length
                if (mem->member == "length" && call->args.size() == 1) {  // resize (spec 25)
                    const std::string st = typeOf(*call->args[0]);
                    if (!st.empty() && st != "int") error("array length must be an int", call->loc);
                    return "void";
                }
                error("arrays support .length() to read and .length(n) to resize; '" + mem->member +
                          "' is not a method",
                      call->loc);
                return "";
            }
            if (objType == "String" || objType == "string") {
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "length" && call->args.empty()) return "int";
                if (mem->member == "isEmpty" && call->args.empty()) return "boolean";
                if (mem->member == "charAt" && call->args.size() == 1) return "char";
                if (mem->member == "toInt" && call->args.empty()) return "int";  // parse (spec 4)
                if (mem->member == "equals" && call->args.size() == 1) return "boolean";
                if (mem->member == "concat" && call->args.size() == 1) return "String";
                // append mutates the receiver, so it is only on the mutable `string` (spec 4).
                if (mem->member == "append" && call->args.size() == 1) {
                    if (objType != "string")
                        error("'append' mutates the string; it is not available on the immutable "
                              "String (use + to build a new String)",
                              mem->loc);
                    return "string";
                }
                if (mem->member == "substring" && call->args.size() == 2) return "String";
                // Search / predicates (spec 34.5).
                if (mem->member == "indexOf" && call->args.size() == 1) return "int";
                if (mem->member == "contains" && call->args.size() == 1) return "boolean";
                if (mem->member == "startsWith" && call->args.size() == 1) return "boolean";
                if (mem->member == "endsWith" && call->args.size() == 1) return "boolean";
                // Transforms (spec 34.5): new owned Strings.
                if (mem->member == "toUpper" && call->args.empty()) return "String";
                if (mem->member == "toLower" && call->args.empty()) return "String";
                if (mem->member == "trim" && call->args.empty()) return "String";
                if (mem->member == "repeat" && call->args.size() == 1) return "String";
                if (mem->member == "toString" && call->args.empty()) return "String";  // identity
                // String satisfies Hashable<String>/Comparable<String> (collections, spec 34).
                if (mem->member == "hash" && call->args.empty()) return "long";
                if (mem->member == "equalsKey" && call->args.size() == 1) return "boolean";
                if (mem->member == "compareTo" && call->args.size() == 1) return "int";
                error("String has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // Integer types satisfy Hashable<T>/Comparable<T> via builtins, so they can be used as
            // map/set keys without boxing (collections, spec 34).
            if (isIntName(objType)) {
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "hash" && call->args.empty()) return "long";
                if (mem->member == "toString" && call->args.empty()) return "String";
                if (mem->member == "equalsKey" && call->args.size() == 1) return "boolean";
                if (mem->member == "compareTo" && call->args.size() == 1) return "int";
                error("'" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // Channel.select builder (spec 20.4): .receive(ch, lambda) / .timeout(ms, lambda) chain
            // fluently (each returns the builder) and .run() executes it.
            if (objType == "Select") {
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "receive" && call->args.size() == 2) return "Select";
                if (mem->member == "timeout" && call->args.size() == 2) return "Select";
                if (mem->member == "run" && call->args.empty()) return "void";
                error("Select has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // Channel<T> blocking operations (spec 20.3).
            if (baseType(objType).rfind("Channel$", 0) == 0) {
                const std::string elem = baseType(objType).substr(8);
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "send" && call->args.size() == 1) return "void";
                if (mem->member == "receive" && call->args.empty()) return elem;
                error("Channel has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // atomic<T> lock-free operations (spec 20.6).
            if (baseType(objType).rfind("atomic$", 0) == 0) {
                const std::string elem = baseType(objType).substr(7);
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "get" && call->args.empty()) return elem;
                if (mem->member == "set" && call->args.size() == 1) return "void";
                if (mem->member == "add" && call->args.size() == 1) return elem;
                if (mem->member == "increment" && call->args.empty()) return elem;
                if (mem->member == "compareAndSet" && call->args.size() == 2) return "boolean";
                error("atomic has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Type") {  // reflection (spec 31)
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "name" && call->args.empty()) return "String";
                if (mem->member == "methodCount" && call->args.empty()) return "int";
                if (mem->member == "fieldCount" && call->args.empty()) return "int";
                if ((mem->member == "methodName" || mem->member == "fieldName") &&
                    call->args.size() == 1)
                    return "String";
                if (mem->member == "method" && call->args.size() == 1) return "Method";
                if (mem->member == "instantiate") return "Object";  // construct an instance
                if (mem->member == "methods" && call->args.empty()) return "ArrayList$Method";
                if (mem->member == "fields" && call->args.empty()) return "ArrayList$Field";
                if (mem->member == "annotations" && call->args.empty()) return "ArrayList$Annotation";
                error("Type has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Method") {  // reflection (spec 31)
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "name" && call->args.empty()) return "String";
                if (mem->member == "firstByte" && call->args.empty()) return "int";
                if (mem->member == "invoke") return "void";  // invoke(receiver [, args])
                if (mem->member == "equalsKey" && call->args.size() == 1) return "boolean";  // identity
                if (mem->member == "hash" && call->args.empty()) return "long";
                error("Method has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Field") {  // reflection (spec 31)
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "name" && call->args.empty()) return "String";
                if (mem->member == "get" && call->args.size() == 1) return "Object";  // boxed value
                if (mem->member == "set" && call->args.size() == 2) return "void";  // (obj, Object)
                if (mem->member == "equalsKey" && call->args.size() == 1) return "boolean";  // identity
                if (mem->member == "hash" && call->args.empty()) return "long";
                error("Field has no method '" + mem->member + "'", call->loc);
                return "";
            }
            if (objType == "Annotation") {  // reflection (spec 14.3, 31)
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "name" && call->args.empty()) return "String";
                if (mem->member == "equalsKey" && call->args.size() == 1) return "boolean";  // identity
                if (mem->member == "hash" && call->args.empty()) return "long";
                error("Annotation has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // A field of function<...> type is a function value: obj.f(args) calls it.
            if (const FieldInfo* fld = findField(objType, mem->member);
                fld != nullptr && fld->type.rfind("function<", 0) == 0) {
                for (const auto& arg : call->args) typeOf(*arg);
                const std::string inner = fld->type.substr(9, fld->type.size() - 10);
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') depth++;
                    else if (inner[i] == '>') depth--;
                    else if (inner[i] == ',' && depth == 0) return inner.substr(0, i);
                }
                return inner;
            }
            // Calling a catalog method through a catalog-TYPED receiver (spec 12.4): if exactly one
            // enum implements the catalog, the value is necessarily one of its ordinals, so dispatch
            // statically to that enum's method. Several implementers would need a runtime type tag an
            // i32 ordinal cannot carry, so that remains unsupported.
            if (catalogs_.count(baseType(objType)) > 0) {
                std::vector<std::string> impls = catalogImplementers(baseType(objType));
                if (impls.size() == 1) {
                    for (const auto& arg : call->args) typeOf(*arg);
                    auto emit = enumMethods_.find(impls[0]);
                    if (emit != enumMethods_.end()) {
                        auto mit = emit->second.find(mem->member);
                        if (mit != emit->second.end()) return mit->second.returnType;
                    }
                    error("enum '" + impls[0] + "' implementing catalog '" + baseType(objType) +
                              "' has no method '" + mem->member + "'",
                          call->loc);
                    return "";
                }
                error("cannot call catalog method '" + mem->member + "' through a catalog-typed "
                          "value of type '" + baseType(objType) + "': " +
                          (impls.empty() ? "no enum implements it"
                                         : "several enums implement it, so dispatch needs a runtime "
                                           "type tag (call it on the concrete enum instead)"),
                      call->loc);
                return "";
            }
            const MethodInfo* m = findMethod(objType, mem->member);
            if (m == nullptr) {
                error("class '" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            checkCallArgs(call->args, m->paramTypes, "'" + mem->member + "'");
            if (!m->isProperty && call->args.size() != m->paramCount) {
                error("method '" + mem->member + "' expects " + std::to_string(m->paramCount) +
                          " argument(s) but got " + std::to_string(call->args.size()),
                      call->loc);
            }
            // An async method call yields a Task<returnType> (spec 20.2), not the bare value.
            if (m->isAsync) return ast::mangleGeneric("Task", {m->returnType});
            // Safe navigation obj?.method() (spec 3.7): result is nullable; requires a
            // reference-typed return.
            if (mem->safe) {
                const std::string rb = baseType(m->returnType);
                if (!isRefType(m->returnType) && !isArrayType(m->returnType) &&
                    classes_.count(rb) == 0 && rb != "String") {
                    error("safe navigation '?.' requires a reference-typed result; '" + mem->member +
                              "' returns '" + m->returnType + "'",
                          call->loc);
                    return m->returnType;
                }
                return isNullableType(m->returnType) ? m->returnType : m->returnType + "?";
            }
            return m->returnType;
        }
        error("unknown call '" + (name.empty() ? std::string("<expr>") : name) + "'", call->loc);
        return "";
    }

    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        // SIMD vector lane: v.x / v.y / v.z / v.w -> float. Skip when the receiver is a bare
        // type name (e.g. EnumName.a is a constant, not a vector lane), so we don't type-probe it.
        if (int lane = vecLane(mem->member); lane >= 0) {
            const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
            const bool typeNameRecv = oid != nullptr && oid->name != "this" &&
                                      lookupLocal(oid->name) == nullptr;
            if (!typeNameRecv) {
                if (int w = vecWidth(typeOf(*mem->object)); w > 0) {
                    if (lane >= w) error("vector has no component '" + mem->member + "'", mem->loc);
                    return "float";
                }
            }
        }
        // Enum constant access: EnumName.CONSTANT (when the receiver names an enum,
        // not a variable).
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                auto eit = enums_.find(objId->name);
                if (eit != enums_.end()) {
                    if (std::find(eit->second.begin(), eit->second.end(), mem->member) ==
                        eit->second.end()) {
                        error("enum '" + objId->name + "' has no constant '" + mem->member + "'",
                              mem->loc);
                    }
                    return objId->name;
                }
                // Static field access: ClassName.field (when the receiver names a class).
                if (const ClassInfo* sc = lookupClass(objId->name)) {
                    // A class-level const, read as Type.NAME (spec 28.1, OOP form).
                    if (auto ct = constTypes_.find(objId->name + "." + mem->member);
                        ct != constTypes_.end())
                        return ct->second;
                    const FieldInfo* f = findField(objId->name, mem->member);
                    if (f == nullptr) {
                        error("class '" + objId->name + "' has no static field '" + mem->member + "'",
                              mem->loc);
                        return "";
                    }
                    if (!f->isStatic) {
                        error("field '" + mem->member +
                                  "' is not static; access it on an instance",
                              mem->loc);
                        return "";
                    }
                    return f->type;
                }
            }
        }
        std::string objType = typeOf(*mem->object);
        if (objType.empty()) return "";
        // Null safety (spec 3.7): `nullable` only constrains assignment -- a field may be read
        // through a nullable receiver directly (it traps at runtime if null). Resolve against the
        // underlying type.
        if (isNullableType(objType)) objType = baseType(objType);
        std::string memType;
        if (const FieldInfo* f = findField(objType, mem->member)) {
            memType = f->type;
            // Partial move (spec 19.9): a field moved out of its parent is inaccessible until reassign.
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                oid != nullptr && moved_.count(oid->name + "." + mem->member) > 0)
                error("use of field '" + mem->member +
                          "' after it was moved out (reassign it before using) (spec 19.9)",
                      mem->loc);
        } else if (const MethodInfo* pm = findMethod(objType, mem->member);
                   pm != nullptr && pm->isProperty) {
            memType = pm->returnType;  // computed get-only property read as obj.name (no parens)
        } else {
            error("class '" + objType + "' has no field '" + mem->member + "'", mem->loc);
            return "";
        }
        if (!mem->safe) return memType;
        // Safe navigation obj?.field (spec 3.7): yields null when obj is null, so the result is
        // nullable; the member must be reference-typed (a primitive cannot carry null).
        const std::string mb = baseType(memType);
        if (!isRefType(memType) && !isArrayType(memType) && classes_.count(mb) == 0 &&
            mb != "String") {
            error("safe navigation '?.' requires a reference-typed member; '" + mem->member +
                      "' is '" + memType + "'",
                  mem->loc);
            return memType;
        }
        return isNullableType(memType) ? memType : memType + "?";
    }

    if (dynamic_cast<const ast::SuperExpr*>(&expr) != nullptr) {
        error("'super' can only be used as 'super(...)' in a constructor", expr.loc);
        return "";
    }

    error("unsupported expression", expr.loc);
    return "";
}

std::string SemanticAnalyzer::flattenCallee(const ast::Expr& expr) const {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) return id->name;
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string base = flattenCallee(*mem->object);
        if (base.empty()) return "";
        return base + "." + mem->member;
    }
    return "";
}

}  // namespace ldp3
