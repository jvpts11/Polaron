#include "semantic/analyzer.h"

#include "semantic/asmcheck.h"
#include "semantic/comptime.h"

#include <algorithm>
#include <functional>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

namespace ldp3 {

namespace {
// Levenshtein edit distance, capped: the number of single-character insertions, deletions or
// substitutions to turn `a` into `b`. Used only to say "did you mean X?" on a name error, so a small
// classic DP is plenty -- the strings are identifiers.
int editDistance(const std::string& a, const std::string& b) {
    const std::size_t n = a.size(), m = b.size();
    std::vector<int> prev(m + 1), cur(m + 1);
    for (std::size_t j = 0; j <= m; ++j) prev[j] = static_cast<int>(j);
    for (std::size_t i = 1; i <= n; ++i) {
        cur[0] = static_cast<int>(i);
        for (std::size_t j = 1; j <= m; ++j) {
            const int cost = a[i - 1] == b[j - 1] ? 0 : 1;
            cur[j] = std::min({prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost});
        }
        std::swap(prev, cur);
    }
    return prev[m];
}

// The candidate closest to `typed`, or "" if none is close enough to be worth suggesting. The threshold
// scales with the typed length -- one edit for a short name, up to a third of it for a long one -- so a
// genuine typo is caught but two unrelated names are not paired up. A case-only difference always wins.
std::string closestName(const std::string& typed, const std::vector<std::string>& candidates) {
    if (typed.empty()) return "";
    const int budget = std::max(1, static_cast<int>(typed.size()) / 3 + 1);
    std::string best;
    int bestDist = budget + 1;
    for (const std::string& c : candidates) {
        if (c == typed || c.empty()) continue;
        const int d = editDistance(typed, c);
        if (d < bestDist || (d == bestDist && c.size() == typed.size())) {
            bestDist = d;
            best = c;
        }
    }
    return bestDist <= budget ? best : "";
}

// The "; did you mean 'X'?" suffix for a name error, or "" when nothing is close. Kept as a suffix so the
// existing error text is untouched and an editor can pattern-match "did you mean '<name>'" to offer a fix.
std::string didYouMean(const std::string& typed, const std::vector<std::string>& candidates) {
    const std::string best = closestName(typed, candidates);
    return best.empty() ? "" : "; did you mean '" + best + "'?";
}

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
    std::string s = ast::stripNullable(t);           // strip the `nullable ` prefix (spec 3.7)
    // Strip ONE trailing pointer/reference marker: a generic with a pointer type argument mangles to a
    // name ending in '*', and only the outermost '*' is the receiver's own pointer (see codegen baseType).
    if (!s.empty() && (s.back() == '*' || s.back() == '&')) s.pop_back();
    return s;
}
// True if the type is declared `nullable` (canonical "nullable T" -- a prefix word, not a suffix mark).
inline bool isNullableType(const std::string& t) { return ast::typeIsNullable(t); }
std::string typeRefStr(const ast::TypeRef& t) { return ast::canonicalType(t); }
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

// Everything a bit field must be, checked where it is declared (spec 11.1).
//
// A bit field is not a narrower field -- it is a field with NO STORAGE OF ITS OWN, sharing a unit with
// the fields declared beside it. That is what makes it able to describe a hardware register or a wire
// format, and it is also what makes every one of these rules load-bearing rather than tidiness: a
// declaration the compiler cannot lay out unambiguously becomes a struct whose bits are somewhere
// other than where its author reads them, which is a bug no test of the program's logic can find.
void checkBitField(const ast::ClassDecl& cls, const ast::FieldDecl& f,
                   const std::function<void(const std::string&, const SourceLocation&)>& error) {
    if (f.bitWidth <= 0) {
        if (f.bitWidth == 0) return;  // no `: n` at all
        error("bit field '" + f.name + "' must have a width of at least 1", f.loc);
        return;
    }
    const std::string t = ast::canonicalType(f.type);
    if (!isIntName(t) || t == "address") {
        error("bit field '" + f.name + "' has type '" + t + "'; only integer types can be packed into "
              "bits, because a bit field is a range of bits inside a shared unit rather than a value "
              "with its own storage", f.loc);
        return;
    }
    if (static_cast<unsigned>(f.bitWidth) > intBits(t)) {
        error("bit field '" + f.name + "' is declared " + std::to_string(f.bitWidth) + " bits wide but "
              "its type '" + t + "' holds only " + std::to_string(intBits(t)) + "; widen the type or "
              "narrow the field", f.loc);
        return;
    }
    if (f.isStatic)
        error("bit field '" + f.name + "' cannot be static: a static field has one storage location of "
              "its own, which is the opposite of sharing a unit with its neighbours", f.loc);
    if (f.isPersistent)
        error("bit field '" + f.name + "' cannot be persistent: a persistent field is stored "
              "individually outside the object, so it has no unit to be packed into", f.loc);
    if (f.isWeak || f.isUnique || f.isMovable)
        error("bit field '" + f.name + "' cannot be weak, unique or movable: those describe ownership "
              "of a referenced object, and a bit field holds bits", f.loc);
    if (f.isLazy)
        error("bit field '" + f.name + "' cannot be lazy: a lazy field uses its own null value to mean "
              "'not yet computed', and a range of bits has no spare value to spend on that", f.loc);
    if (cls.isUnion)
        error("bit field '" + f.name + "' cannot be declared in a union: every union member starts at "
              "offset 0, so there is no run of neighbours for it to pack with", f.loc);
}

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
    // No explicit code at the call-site: infer one from the message so the diagnostic is still rich (the
    // mapping is the one table in diag/catalog.cpp). An unmatched message stays a clean one-liner.
    const diag::Code code = diag::classify(message);
    errors_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::warn(std::string message, SourceLocation loc) {
    const diag::Code code = diag::classify(message);
    warnings_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::error(diag::Code code, std::string message, SourceLocation loc) {
    errors_.push_back(SemaError{std::move(message), loc, code});
}

void SemanticAnalyzer::warn(diag::Code code, std::string message, SourceLocation loc) {
    warnings_.push_back(SemaError{std::move(message), loc, code});
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
    // Try the exact name first: a generic instance can have a trailing '*' that belongs to a type
    // argument (e.g. HashMap$int$Node* is HashMap<int,Node*>), which baseType would wrongly strip.
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) c = lookupClass(baseType(className));  // else see through outer T* / T&
    while (c != nullptr) {
        auto it = c->fields.find(field);
        if (it != c->fields.end()) return &it->second;
        if (c->superclass.empty()) break;
        c = lookupClass(c->superclass);
    }
    return nullptr;
}

// Every name usable as a bare identifier at the current point: the locals in every open scope, the
// namespace-level constants, and -- inside an enum's own methods -- that enum's constants. This is the
// candidate set for "did you mean?" on an undeclared-variable error, so it must mirror what the lookup at
// the error site actually accepts.
std::vector<std::string> SemanticAnalyzer::namesInScope() const {
    std::vector<std::string> out;
    for (const auto& scope : scopes_)
        for (const auto& [name, var] : scope) out.push_back(name);
    for (const auto& [name, type] : constTypes_) out.push_back(name);
    if (auto it = enums_.find(currentClass_); it != enums_.end())
        for (const std::string& c : it->second) out.push_back(c);
    return out;
}

// Every field name of a class, including inherited ones -- the candidate set for "did you mean?" on a
// no-such-field error.
std::vector<std::string> SemanticAnalyzer::fieldNames(const std::string& className) const {
    std::vector<std::string> out;
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) c = lookupClass(baseType(className));
    while (c != nullptr) {
        for (const auto& [name, info] : c->fields) out.push_back(name);
        if (c->superclass.empty()) break;
        c = lookupClass(c->superclass);
    }
    return out;
}

// spec 32.8: is `expr` a class's dispatch table (`Dog.methods`)? Returns the class name, or "".
std::string SemanticAnalyzer::dispatchTableClass(const ast::Expr& expr) const {
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr);
    if (mem == nullptr || mem->member != "methods") return "";
    const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
    if (id == nullptr || lookupClass(id->name) == nullptr) return "";
    return id->name;
}

// spec 32.8: `Dog.methods.replace("bark", <function value>)`. The replacement must be a function whose
// first parameter is the receiver, then the method's own parameters, returning what the method returns
// -- exactly the shape of the slot it takes over. Type safety is not lost: the signature is checked here,
// at compile time, and the replacement is installed in the class's vtable, so every instance (existing
// and future) picks it up.
std::string SemanticAnalyzer::checkMethodPatch(const std::string& className,
                                               const ast::CallExpr& call) {
    if (call.args.size() != 2) {
        error("'" + className + ".methods.replace' takes the method name and its replacement", call.loc);
        return "void";
    }
    const auto* lit = dynamic_cast<const ast::StringLiteralExpr*>(call.args[0].get());
    if (lit == nullptr) {
        error("the method to replace must be a string literal, so it can be checked at compile time",
              call.args[0]->loc);
        return "void";
    }
    const MethodInfo* m = findMethod(className, lit->value);
    if (m == nullptr) {
        error("no method '" + lit->value + "' on class '" + className + "' to replace", call.loc);
        return "void";
    }
    if (m->isStatic) {
        error("cannot replace the static method '" + className + "." + lit->value +
                  "'; only instance methods are dispatched through the table",
              call.loc);
        return "void";
    }
    std::string want = "function<" + m->returnType + "," + className;
    for (const std::string& pt : m->paramTypes) want += "," + pt;
    want += ">";
    const std::string got = typeOf(*call.args[1]);
    if (!got.empty() && got != want)
        error("the replacement for '" + className + "." + lit->value + "' must have type '" + want +
                  "' (the receiver, then the method's parameters); got '" + got + "'",
              call.args[1]->loc);
    patchedClasses_.insert(className);
    return "void";
}

const MethodInfo* SemanticAnalyzer::findMethod(const std::string& className,
                                               const std::string& method,
                                               bool objectFallback) const {
    // Exact name first (a generic instance's trailing '*' may belong to a type argument, e.g.
    // HashMap$int$Node*); only then strip an outer pointer/reference marker.
    const ClassInfo* c = lookupClass(className);
    if (c == nullptr) c = lookupClass(baseType(className));  // see through T* / T&
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
    // Every object is-a Object at runtime, so Object's universal methods (equals/hashCode/equalsKey/...)
    // resolve on any receiver -- including one whose static type is an interface, which has no superclass
    // chain to Object. Fall back to Object for anything the hierarchy walk did not find; a type's own
    // member always wins because it is checked first. This lets ArrayList<Iface>/HashMap<Iface,V> work.
    // Gated: only call resolution wants this, not the override/hiding check (else a record's generated
    // equals/hashCode would look like it overrides an interface method).
    if (objectFallback && className != "Object" && baseType(className) != "Object") {
        if (const ClassInfo* obj = lookupClass("Object")) {
            auto it = obj->methods.find(method);
            if (it != obj->methods.end()) return &it->second;
        }
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

// The tail on a type-mismatch message when the two sides are `address` and a plain integer. Without
// it the reader is told `address` and `long` are different types, which is true and unhelpful: both
// are 64-bit integers, the rule that separates them is new, and the whole point is that crossing
// between them should be a thing you decided rather than a thing that happened.
std::string SemanticAnalyzer::addressHint(const std::string& from, const std::string& to) const {
    if (!isIntName(from) || !isIntName(to)) return "";
    if ((from == "address") == (to == "address")) return "";
    if (to == "address")
        return ". An address is not an integer that happens to be 64 bits wide -- making one out of "
               "a number is how a program reads memory nobody gave it. Write 'cast<address>(...)' if "
               "that is what you mean";
    return ". An address is not an integer that happens to be 64 bits wide -- storing one in a "
           "number loses the fact that it points at something. Write 'cast<" + to +
           ">(...)' if that is what you mean";
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
            return ast::stripNullable(s);
        };
        return isSubtype(strip(sub), strip(super), depth + 1);
    }
    // String (immutable) and string (mutable) share a representation; they interconvert freely until
    // the immutability discipline is enforced (spec 4).
    if ((sub == "String" || sub == "string") && (super == "String" || super == "string")) return true;
    // Every value is an Object (spec 3.4): a primitive becomes one by boxing, a class by inheritance
    // (every class now extends Object, handled by the hierarchy walk below).
    if (super == "Object" && (isNumeric(sub) || sub == "boolean" || sub == "char")) return true;
    // An interface (and any class) is an Object too. Interfaces have no superclass chain to Object, so
    // the hierarchy walk below never reaches it; accept any known class/interface type directly.
    if (super == "Object" && lookupClass(baseType(sub)) != nullptr) return true;
    // int and float both widen to a float type (no implicit narrowing).
    if (isFloatType(super) && isNumeric(sub)) return true;
    // Integers widen to a wider integer (no implicit narrowing).
    if (isIntName(sub) && isIntName(super)) {
        // ...but `address` is not an integer that happens to be 64 bits wide, it is a machine
        // address, and it sits in isIntName only so the arithmetic on it works. Left as a plain
        // widening, `address a = someLong;` silently turned a number into a pointer and
        // `long n = someAddress;` silently turned a pointer into a number -- the exact conversion a
        // language with no exploitable UB has to make somebody write down.
        //
        // Freestanding is exempt, and not as a concession: on bare metal, turning an integer into an
        // address IS the work (spec 36), the memory-mapped register at 0xB8000 is a number until you
        // say otherwise, and there is no allocator to have given you the address instead. Measured
        // before landing: the whole hosted world is TWELVE sites -- five across 380 samples and seven
        // in agents-exe -- against 210 in the pico kernel, which is what that split looks like.
        if (!freestanding_ && (sub == "address") != (super == "address")) return false;
        return intBits(sub) <= intBits(super);
    }
    // Pointer/reference compatibility follows the pointee (T*, T& and T mix
    // freely for now; the strict value-vs-reference rules land with deep copy).
    //
    // ... but try the names AS WRITTEN first. A monomorphized generic can end in a '*' that belongs to
    // its last TYPE ARGUMENT rather than to the outer type -- `ArrayListIterator$Node*` is
    // `ArrayListIterator<Node*>`, a value -- so stripping it produces a type that does not exist and the
    // hierarchy walk below finds nothing. findField already had to learn this; the same trap is here.
    if (isRefType(sub) || isRefType(super)) {
        if (lookupClass(sub) == nullptr || lookupClass(super) == nullptr)
            return isSubtype(baseType(sub), baseType(super), depth + 1);
    }
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
    // A monomorphized instantiation keeps its superclass and interfaces under their BASE names
    // (`Option`, `Iterator`), while `super` here is a mangled instantiation (`Option$Node`). For the
    // pass-through case -- `C<T> extends B<T>` / `implements I<T>`, which is what the stdlib's Option,
    // Some/None and the iterators all are -- the instantiation's own argument suffix is the parent's
    // too, so retry with it. This can only ever ACCEPT a relation, never reject one, so a wrong guess
    // costs a missed error rather than a false one.
    const std::size_t argsAt = sub.find('$');
    const std::string suffix = (argsAt == std::string::npos) ? std::string() : sub.substr(argsAt);
    auto relates = [&](const std::string& parent) {
        if (isSubtype(parent, super, depth + 1)) return true;
        return !suffix.empty() && parent.find('$') == std::string::npos &&
               isSubtype(parent + suffix, super, depth + 1);
    };
    if (!c->superclass.empty() && relates(c->superclass)) return true;
    for (const std::string& iface : c->interfaces) {
        if (relates(iface)) return true;
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

// ---- the flow machine ----
// Four facts, one set of operations. Each of them answers "what does the compiler KNOW here", which is a
// different question from "what does the declaration say", and all four need the same handling at a
// branch, a loop and a scope boundary. Keeping them together is what stops them drifting apart.

FlowFacts SemanticAnalyzer::snapshotFlow() const {
    FlowFacts f;
    f.init = init_;
    f.nonNull = nonNull_;
    f.moved = moved_;
    f.deleted = deleted_;
    f.freed = freed_;
    return f;
}

void SemanticAnalyzer::restoreFlow(const FlowFacts& f) {
    init_ = f.init;
    nonNull_ = f.nonNull;
    moved_ = f.moved;
    deleted_ = f.deleted;
    freed_ = f.freed;
}

void SemanticAnalyzer::joinFlow(const FlowFacts& a, const FlowFacts& b) {
    // Initialization: Init only where BOTH arms initialized it. Where exactly one did, the result is
    // Maybe -- deliberately distinguished from Uninit, because "you set it in the `then` and forgot the
    // `else`" deserves to be told as that, not as "never initialized".
    init_.clear();
    for (const auto& [name, sa] : a.init) {
        const auto ib = b.init.find(name);
        const FlowFacts::Init sb = ib == b.init.end() ? FlowFacts::Init::Init : ib->second;
        init_[name] = (sa == sb) ? sa
                    : (sa == FlowFacts::Init::Uninit && sb == FlowFacts::Init::Uninit)
                          ? FlowFacts::Init::Uninit
                          : FlowFacts::Init::Maybe;
    }
    for (const auto& [name, sb] : b.init)
        if (a.init.find(name) == a.init.end() && sb != FlowFacts::Init::Init)
            init_[name] = FlowFacts::Init::Maybe;

    // A PROOF must hold on both paths to survive; an OBLIGATION (moved, deleted) that holds on either
    // must survive. The asymmetry is the point: be pessimistic about what you know, pessimistic about
    // what you owe. Optimism in either direction is how a flow analysis starts lying.
    nonNull_.clear();
    for (const std::string& n : a.nonNull)
        if (b.nonNull.count(n) > 0) nonNull_.insert(n);
    moved_ = a.moved;
    moved_.insert(b.moved.begin(), b.moved.end());
    deleted_ = a.deleted;
    deleted_.insert(b.deleted.begin(), b.deleted.end());
    freed_ = a.freed;
    freed_.insert(b.freed.begin(), b.freed.end());
}

void SemanticAnalyzer::invalidateAcrossBackEdge(const FlowFacts& before) {
    // The body may run again with whatever the previous iteration left behind, so a proof the body did
    // not already have at the top cannot be trusted at the top. Initialization is the opposite: it only
    // ever moves forward, so what the body initialized stays initialized.
    std::unordered_set<std::string> kept;
    for (const std::string& n : nonNull_)
        if (before.nonNull.count(n) > 0) kept.insert(n);
    nonNull_ = std::move(kept);
}

FlowFacts::Init SemanticAnalyzer::initStateOf(const std::string& name) const {
    const auto it = init_.find(name);
    return it == init_.end() ? FlowFacts::Init::Init : it->second;
}

void SemanticAnalyzer::markInitialized(const std::string& name) {
    if (init_.find(name) != init_.end()) init_[name] = FlowFacts::Init::Init;
}

// True when every path through this block leaves it -- return, throw, break or continue. Such a block
// contributes nothing to the state after the branch it belongs to, which is exactly why a guard clause
// (`if (p == null) { return; }`) can narrow the code that follows it.
bool SemanticAnalyzer::blockAlwaysExits(const ast::Block& b) {
    for (const auto& st : b.statements) {
        const ast::Stmt* s = st.get();
        if (dynamic_cast<const ast::ReturnStmt*>(s) != nullptr) return true;
        if (dynamic_cast<const ast::ThrowStmt*>(s) != nullptr) return true;
        if (dynamic_cast<const ast::BreakStmt*>(s) != nullptr) return true;
        if (dynamic_cast<const ast::ContinueStmt*>(s) != nullptr) return true;
        // A nested if counts only when BOTH of its arms exit -- otherwise a path falls through it.
        if (const auto* nested = dynamic_cast<const ast::IfStmt*>(s)) {
            if (nested->elseBlock != nullptr && blockAlwaysExits(nested->thenBlock) &&
                blockAlwaysExits(*nested->elseBlock))
                return true;
        }
    }
    return false;
}

// True when every path through this block RETURNS (or throws) -- deliberately not `blockAlwaysExits`,
// which answers a different question. That one counts `break` and `continue` as leaving, which is right
// for narrowing (the rest of that block is unreachable) and wrong here: a `break` carries on inside the
// method and still has to reach a `return`.
//
// Conservative by construction. A shape it does not recognise answers false, which costs a missed
// diagnostic; answering true where a path really does fall through would let the original bug back in,
// and answering false where the code is fine would break a build that was correct.
bool SemanticAnalyzer::alwaysReturns(const ast::Block& b) {
    for (const auto& st : b.statements) {
        const ast::Stmt* s = st.get();
        if (dynamic_cast<const ast::ReturnStmt*>(s) != nullptr) return true;
        if (dynamic_cast<const ast::ThrowStmt*>(s) != nullptr) return true;
        if (const auto* iff = dynamic_cast<const ast::IfStmt*>(s))
            if (iff->elseBlock != nullptr && alwaysReturns(iff->thenBlock) &&
                alwaysReturns(*iff->elseBlock))
                return true;
        // `while (true)` with no way out is a method that ends by never ending -- the shape a dispatch
        // loop, a scheduler and a kernel's idle path all have.
        if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s))
            if (const auto* c = dynamic_cast<const ast::BoolLiteralExpr*>(w->cond.get());
                c != nullptr && c->value && !blockHasBreak(w->body))
                return true;
        // try/catch: the value has to come out of the body AND out of every catch, or out of a finally
        // that returns regardless.
        if (const auto* tr = dynamic_cast<const ast::TryStmt*>(s)) {
            if (tr->finallyBlock != nullptr && alwaysReturns(*tr->finallyBlock)) return true;
            bool all = alwaysReturns(tr->body);
            for (const auto& c : tr->catches) all = all && alwaysReturns(c.body);
            if (all) return true;
        }
        // switch/match: only when there is a default, since without one a subject that matches nothing
        // falls straight through.
        if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
            if (sw->defaultBody != nullptr) {
                bool all = alwaysReturns(*sw->defaultBody);
                for (const auto& c : sw->cases) all = all && alwaysReturns(c.body);
                if (all) return true;
            }
        }
        if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
            bool all = ms->defaultBody != nullptr ? alwaysReturns(*ms->defaultBody) : true;
            for (const auto& c : ms->cases) all = all && alwaysReturns(c.body);
            if (all && !ms->cases.empty()) return true;   // a match over a sealed type is exhaustive
        }
    }
    return false;
}

// Whether a block contains a `break` that would leave a loop -- used only to tell a `while (true)` that
// never ends from one that does. Nested loops own their own breaks, so those do not count.
bool SemanticAnalyzer::blockHasBreak(const ast::Block& b) {
    for (const auto& st : b.statements) {
        const ast::Stmt* s = st.get();
        if (dynamic_cast<const ast::BreakStmt*>(s) != nullptr) return true;
        if (const auto* iff = dynamic_cast<const ast::IfStmt*>(s)) {
            if (blockHasBreak(iff->thenBlock)) return true;
            if (iff->elseBlock != nullptr && blockHasBreak(*iff->elseBlock)) return true;
        }
        if (const auto* tr = dynamic_cast<const ast::TryStmt*>(s)) {
            if (blockHasBreak(tr->body)) return true;
            for (const auto& c : tr->catches) if (blockHasBreak(c.body)) return true;
            if (tr->finallyBlock != nullptr && blockHasBreak(*tr->finallyBlock)) return true;
        }
    }
    return false;
}

// Read a null test and report what it PROVES, and for which arm. Only the shapes whose meaning is
// unambiguous are recognised -- `x != null` and `x == null` against a plain name. Anything cleverer
// (`a != null && b != null`, a call that returns a nullable) proves nothing here, which costs a cast at
// the call site and keeps the analysis honest. Being incomplete is safe; being wrong is not.
void SemanticAnalyzer::proofFromCondition(const ast::Expr& cond, std::string& provenThen,
                                          std::string& provenElse) {
    const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&cond);
    if (bin == nullptr) return;
    if (bin->op == "&&") {
        // `a != null && ...`: whatever the left side proves holds for the whole `then` arm, because the
        // right side only runs when the left was true. The `else` arm learns nothing.
        std::string lThen, lElse, rThen, rElse;
        proofFromCondition(*bin->lhs, lThen, lElse);
        proofFromCondition(*bin->rhs, rThen, rElse);
        provenThen = !lThen.empty() ? lThen : rThen;
        return;
    }
    if (bin->op != "==" && bin->op != "!=") return;
    const auto* lid = dynamic_cast<const ast::IdentifierExpr*>(bin->lhs.get());
    const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(bin->rhs.get());
    const bool lNull = dynamic_cast<const ast::NullLiteralExpr*>(bin->lhs.get()) != nullptr;
    const bool rNull = dynamic_cast<const ast::NullLiteralExpr*>(bin->rhs.get()) != nullptr;
    std::string name;
    if (lid != nullptr && rNull) name = lid->name;
    else if (rid != nullptr && lNull) name = rid->name;
    if (name.empty()) return;
    // `x != null` proves it in the `then`; `x == null` proves it in the `else`.
    if (bin->op == "!=") provenThen = name;
    else provenElse = name;
}

void SemanticAnalyzer::killProofsFor(const std::string& name) {
    nonNull_.erase(name);
    // A write to `obj` says nothing about `obj.field` any more either.
    const std::string prefix = name + ".";
    for (auto it = nonNull_.begin(); it != nonNull_.end();)
        it = (it->rfind(prefix, 0) == 0) ? nonNull_.erase(it) : std::next(it);
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
    // Value types first: a field can name a struct/record declared further down, and `keyFieldKind` has
    // to tell "a nested value" from "a reference to another object" to answer at all.
    valueTypeNames_.clear();
    for (const ast::Bundle& b : program.bundles)
        for (const ast::Namespace& n : b.namespaces)
            for (const ast::ClassDecl& c : n.classes)
                if ((c.isStruct || c.isRecord) && !c.isUnion) valueTypeNames_.insert(c.name);
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                if (auto prev = classes_.find(cls.name); prev != classes_.end()) {
                    // Point at whichever of the two the AUTHOR wrote. A user type colliding with a
                    // stdlib one used to be reported wherever the displaced type was USED, which for
                    // a stdlib type is inside the prelude -- so declaring `class File` produced four
                    // errors at `<prelude>:197` telling the standard library to import your class.
                    const bool mine = !bundle.isPrelude;
                    const SourceLocation at = mine ? cls.loc : prev->second.declLoc;
                    const std::string other =
                        (mine == prev->second.fromPrelude) ? "the standard library" : "your program";
                    error("'" + cls.name + "' is already declared by " + other +
                              " -- a type name is unique across the whole program, so this one takes "
                              "the other over and everything that used it breaks somewhere else. "
                              "Rename this type",
                          at);
                    continue;
                }
                // Freestanding has no standard library, so there is nothing for a shadowed builtin
                // to break: the program simply loses its own access to a builtin it could not have
                // called anyway (spec 36 rejects the hosted ones outright). The pico kernel declares
                // `class Process`, which is exactly the right name for a kernel's process, and
                // forbidding it would be a rule with no reason behind it.
                if (!bundle.isPrelude && !freestanding_ && builtinTypes_.count(cls.name) > 0) {
                    // The compiler answers for this name itself; there is no class to redeclare, so
                    // nothing above catches it and the name is simply taken over.
                    error("'" + cls.name +
                              "' is a type the compiler provides (spec 34), so it cannot also be a "
                              "class here -- declaring it takes the name over for the whole program, "
                              "including the standard library's own uses of it. Rename this type",
                          cls.loc);
                    continue;
                }
                ClassInfo info;
                info.name = cls.name;
                info.declLoc = cls.loc;
                info.fromPrelude = bundle.isPrelude;
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
                        // A name is unique within a class, and a silent duplicate here is worse
                        // than the method case: the layout gets a slot per declaration while every
                        // `this.name` resolves to the last one, so the earlier slot is storage that
                        // is never written and never read. If its type is owned, the destructor is
                        // handed uninitialised memory to free.
                        if (info.fields.count(f->name))
                            error("field '" + f->name + "' is already declared in class '" +
                                      cls.name +
                                      "' -- each field name must be unique, and a second declaration "
                                      "silently takes over every use of the name while leaving the "
                                      "first one as dead storage. Remove one of them",
                                  f->loc);
                        // A movable/unique field is reassignable (it is moved out and reassigned).
                        info.fields[f->name] =
                            FieldInfo{typeRefStr(f->type), f->isMutable || f->isMovable || f->isUnique,
                                      f->isStatic, f->isMovable, f->isUnique, f->bitWidth};
                        checkBitField(cls, *f,
                                      [this](const std::string& m, const SourceLocation& l) {
                                          error(m, l);
                                      });
                    } else if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        // LDP3 has no method overloading -- a name is unique within a class. A silent
                        // duplicate (last-wins in this map) makes codegen emit two same-named functions;
                        // LLVM renames the second to `.1`, and -g then emits a duplicate DISubprogram
                        // (invalid DWARF). A property get/set pair legitimately shares a name, so only two
                        // plain methods collide.
                        if (auto prev = info.methods.find(m->name);
                            prev != info.methods.end() && !prev->second.isProperty && !m->isProperty)
                            error("method '" + m->name + "' is already declared in class '" + cls.name +
                                      "' -- LDP3 has no method overloading, so each method name must be "
                                      "unique",
                                  m->loc);
                        MethodInfo mi{typeRefStr(m->returnType), m->isStatic,
                                      m->isAbstract, m->isProperty,
                                      m->params.size(), m->isFinal, m->isAsync};
                        for (const ast::Param& p : m->params) mi.paramTypes.push_back(typeRefStr(p.type));
                        for (const ast::Param& p : m->params) mi.comptimeParams.push_back(p.isComptime);
                        for (const ast::Param& p : m->params) mi.paramNames.push_back(p.name);
                        for (const ast::Param& p : m->params) mi.namedOnlyParams.push_back(p.requiresNamed);
                        for (const ast::Param& p : m->params) mi.moveParams.push_back(p.type.isMove);
                        mi.returnIsMove = m->returnType.isMove;
                        mi.isVariadic = m->isVariadic;
                        mi.isDeprecated = m->isDeprecated;
                        info.methods[m->name] = std::move(mi);
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        // One constructor per class, for the same reason there is one method per
                        // name: LDP3 has no overloading. A second one was accepted in silence and
                        // its parameters were APPENDED to the first's, so `P(int)` next to
                        // `P(int, int)` produced a three-parameter phantom and `new P(1)` was
                        // rejected with "expects 3 arguments" -- a message with no relation to the
                        // mistake, pointing at the call instead of the declaration. Codegen then
                        // emitted only the first, so even a program that satisfied the phantom ran
                        // the wrong body.
                        if (info.hasConstructor)
                            error("class '" + cls.name +
                                      "' already has a constructor -- LDP3 has no overloading, so a "
                                      "class has exactly one. Give the alternatives distinct names "
                                      "as static factory methods, or take one constructor with the "
                                      "widest parameter list",
                                  c->loc);
                        info.hasConstructor = true;
                        if (!c->params.empty()) info.ctorHasParams = true;
                        for (const ast::Param& p : c->params)
                            info.ctorParamTypes.push_back(typeRefStr(p.type));
                    } else if (dynamic_cast<const ast::DestructorDecl*>(member.get()) != nullptr) {
                        info.hasDestructor = true;
                    }
                }
                // A class can want two incompatible orders at once, and until now it got one of them in
                // silence. A PARTIAL constructor (spec 18.9) takes an omitted parameter's value FROM the
                // persistent block, so the block must be attached BEFORE the constructor runs. An
                // identity key is made of the class's value fields, which the constructor is what fills
                // in -- so it can only be known AFTER. Both are legitimate; they cannot both be honoured.
                //
                // The partial constructor wins, because it is the one that would otherwise break. Say so,
                // rather than letting a class that looks keyed quietly not be.
                if (!bundle.isPrelude) {
                    std::vector<std::string> persistNames;
                    bool hasKeyField = false, partialCapable = false;
                    for (const ast::MemberPtr& m : cls.members)
                        if (const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get());
                            f != nullptr && !f->isStatic) {
                            if (f->isPersistent) persistNames.push_back(f->name);
                            else if (ast::keyFieldKind(f->type, valueTypeNames_) !=
                                     ast::KeyFieldKind::None)
                                hasKeyField = true;
                        }
                    if (!persistNames.empty() && hasKeyField)
                        for (const ast::MemberPtr& m : cls.members)
                            if (const auto* c = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
                                for (const ast::Param& p : c->params)
                                    if (std::find(persistNames.begin(), persistNames.end(), p.name) !=
                                        persistNames.end())
                                        partialCapable = true;
                                break;
                            }
                    if (partialCapable)
                        warn("'" + cls.name + "' has value fields that would key its persistents by "
                             "identity, but its constructor takes a parameter named after a persistent "
                             "field -- a partial constructor (spec 18.9), which reads that value out of "
                             "the block before it runs. The block cannot be chosen before the identity "
                             "exists, so this class keeps the per-binding form. Rename the parameter if "
                             "you wanted the persistents keyed by identity instead",
                             cls.loc);
                }
                classes_[cls.name] = std::move(info);
                typeNamespace_[cls.name] = ns.name;
                typeBundle_[cls.name] = bundle.name;
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
                // An annotation and a CLASS may share a name: they are used in different positions and
                // never confused (`@Test` marks a method; `Test.assertEqual(...)` calls a static method).
                // The stdlib relies on it -- spec 32.11 calls both of them System.Test.Test. A clash with
                // an enum/newtype/another annotation is still a redeclaration.
                if (annotations_.count(a.name) > 0 || enums_.count(a.name) > 0 ||
                    newtypes_.count(a.name) > 0) {
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
        // Compiler attributes (spec 36.4): `[[no_bounds_check]]` -- a named, explicit opt-out of the
        // runtime bounds check on a hot path. Not a user annotation, so it needs no declaration.
        if (use.name == "no_bounds_check") {
            if (!use.args.empty()) error("'[[no_bounds_check]]' takes no arguments", use.loc);
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

namespace {
// The string value of an annotation argument, e.g. the "..." of [Cases(source: "...")].
std::string annotationText(const ast::AnnotationUse& use, const std::string& field) {
    for (const ast::AnnotationArg& a : use.args)
        if (a.name == field)
            if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(a.value.get()))
                return s->value;
    return "";
}
long long annotationNumber(const ast::AnnotationUse& use, const std::string& field,
                           long long fallback) {
    for (const ast::AnnotationArg& a : use.args)
        if (a.name == field)
            if (const auto* i = dynamic_cast<const ast::IntLiteralExpr*>(a.value.get())) {
                try {
                    return std::stoll(i->text, nullptr, 0);
                } catch (const std::exception&) {
                    return fallback;
                }
            }
    return fallback;
}
}  // namespace

// spec 32.11: every test declaration is well formed. This runs on EVERY compile, not only under
// --test, because a `[Test]` that cannot be called is a broken declaration whichever way you build --
// and finding out at build time (or in the editor, through `ldp3 check`) beats finding out on the day
// someone runs the suite and quietly gets one test fewer than they wrote.
// Which classes own a fixture. Runs before the bodies, because the warning about reading somebody
// else's fixture is raised where the call is checked.
void SemanticAnalyzer::collectFixtureOwners(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported || bundle.isPrelude) continue;
        for (const ast::Namespace& ns : bundle.namespaces)
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) continue;
                    for (const ast::AnnotationUse& a : m->annotations)
                        if (a.name == "BeforeAll" || a.name == "AfterAll") fixtureOwners_.insert(cls.name);
                }
    }
}

void SemanticAnalyzer::validateTestDeclarations(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported || bundle.isPrelude) continue;
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                std::map<std::string, std::string> hookOwner;  // hook kind -> the method holding it
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) continue;
                    const std::string sym = cls.name + "." + m->name;

                    bool isTest = false;
                    const ast::AnnotationUse* ignore = nullptr;
                    const ast::AnnotationUse* cases = nullptr;
                    const ast::AnnotationUse* repeat = nullptr;
                    const ast::AnnotationUse* bench = nullptr;
                    std::string hook;
                    for (const ast::AnnotationUse& a : m->annotations) {
                        if (a.name == "Test") isTest = true;
                        else if (a.name == "Ignore") ignore = &a;
                        else if (a.name == "Cases") cases = &a;
                        else if (a.name == "Repeat") repeat = &a;
                        else if (a.name == "Benchmark") bench = &a;
                        else if (a.name == "BeforeAll" || a.name == "AfterAll" || a.name == "Setup" ||
                                 a.name == "Teardown")
                            hook = a.name;
                    }

                    if (!hook.empty()) {
                        if (isTest) {
                            error("'[" + hook + "]' and '[Test]' cannot mark the same method '" + sym +
                                      "': a hook runs around the tests, so it cannot be one of them",
                                  m->loc);
                            continue;
                        }
                        if (!m->isStatic || typeRefStr(m->returnType) != "void") {
                            error("'[" + hook + "]' method '" + sym +
                                      "' must be a public static method returning void",
                                  m->loc);
                            continue;
                        }
                        auto [it, fresh] = hookOwner.emplace(hook, sym);
                        if (!fresh)
                            error("class '" + cls.name + "' already has a '[" + hook + "]' method ('" +
                                      it->second + "'); there may be only one, because two would have "
                                      "no defined order",
                                  m->loc);
                        continue;
                    }

                    if (bench != nullptr) {
                        if (isTest) {
                            error("'[Benchmark]' and '[Test]' cannot mark the same method '" + sym +
                                      "': a benchmark measures, a test judges",
                                  m->loc);
                            continue;
                        }
                        if (!m->isStatic || typeRefStr(m->returnType) != "void" || !m->params.empty())
                            error("'[Benchmark]' method '" + sym +
                                      "' must be a public static method taking no arguments and "
                                      "returning void",
                                  m->loc);
                        else if (annotationNumber(*bench, "iterations", 1000) < 1)
                            error("'[Benchmark(iterations: ...)]' on '" + sym +
                                      "' needs at least 1 iteration",
                                  bench->loc);
                        continue;
                    }

                    if (!isTest) {
                        if (ignore != nullptr)
                            error("'[Ignore]' on '" + sym +
                                      "' has no effect: it only applies to a '[Test]' method",
                                  m->loc);
                        if (cases != nullptr)
                            error("'[Cases]' on '" + sym +
                                      "' has no effect: it only applies to a '[Test]' method",
                                  m->loc);
                        continue;
                    }

                    const std::string ret = typeRefStr(m->returnType);
                    if (!m->isStatic || (ret != "boolean" && ret != "void")) {
                        error("[Test] method '" + sym +
                                  "' must be a public static method returning boolean (the test's own "
                                  "verdict) or void (the verdict comes from its Test.assert* calls)",
                              m->loc);
                        continue;
                    }
                    if (repeat != nullptr && annotationNumber(*repeat, "times", 1) < 1)
                        error("'[Repeat(times: ...)]' on '" + sym + "' needs a count of at least 1",
                              repeat->loc);
                    validateTestCases(cls, *m, cases, sym);
                }
            }
        }
    }
}

// The [Cases] half of the check above: a parametrized test takes exactly one parameter, and its
// source must be a static method of the same class returning an array of that parameter's type.
void SemanticAnalyzer::validateTestCases(const ast::ClassDecl& cls, const ast::MethodDecl& m,
                                         const ast::AnnotationUse* cases, const std::string& sym) {
    if (cases == nullptr) {
        if (!m.params.empty())
            error("[Test] method '" + sym +
                      "' takes parameters, so it needs a '[Cases(source: \"...\")]' naming the static "
                      "method that supplies its rows",
                  m.loc);
        return;
    }
    if (m.params.size() != 1) {
        error("'[Cases]' test '" + sym +
                  "' must take exactly one parameter (it is called once per row); group several "
                  "values into a record and take that",
              m.loc);
        return;
    }
    const std::string source = annotationText(*cases, "source");
    if (source.empty()) {
        error("'[Cases]' on '" + sym + "' needs a source: [Cases(source: \"methodName\")]", cases->loc);
        return;
    }
    const std::string want = typeRefStr(m.params.front().type);
    const ast::MethodDecl* src = nullptr;
    for (const ast::MemberPtr& member : cls.members) {
        const auto* cand = dynamic_cast<const ast::MethodDecl*>(member.get());
        if (cand != nullptr && cand->name == source) { src = cand; break; }
    }
    if (src == nullptr) {
        error("'[Cases]' source '" + source + "' is not a method of class '" + cls.name + "'",
              cases->loc);
        return;
    }
    const std::string got = typeRefStr(src->returnType);
    if (!src->isStatic || got != want + "[]")
        error("'[Cases]' source '" + cls.name + "." + source +
                  "' must be a public static method returning '" + want + "[]' to match the parameter "
                  "of '" + sym + "' (it returns '" + got + "')",
              src->loc);
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
                if (en.isJavaStyle) javaEnums_.insert(en.name);
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
                typeBundle_[en.name] = bundle.name;
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
                typeBundle_[cat.name] = bundle.name;
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
        if (libraryMode_ || testMode_) return;  // a library (.ldb) or a --test run needs no entry point
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
        if (f == nullptr) continue;
        // `transient` marks derived/scratch state, excluded from the object's canonical value (reset,
        // not copied, on a value copy; and not captured by serialization). `persistent` is the exact
        // opposite -- state that outlives the instance -- so the pair is a contradiction (spec).
        if (f->isTransient && f->isPersistent)
            error("field '" + f->name + "' cannot be both 'transient' and 'persistent'", f->loc);
        // A `weak T*` observes an object by identity and auto-nulls when it dies, so its target must be a
        // heap/stack object with identity -- i.e. a pointer to a class. Reject `weak int`, `weak T` (not a
        // pointer) and `weak int*` (no identity, no weak-list head): the intrusive auto-null has nowhere to
        // hook. This keeps `weak` a precise tool rather than a footgun on a nonsensical target.
        if (f->isWeak) {
            if (!f->type.isPointer)
                error("'weak' requires a pointer: write 'weak " + typeRefStr(f->type) + "* " + f->name +
                          "'. A weak reference observes an object by identity, so it must be a pointer.",
                      f->loc);
            else if (classes_.count(baseType(typeRefStr(f->type))) == 0)
                error("'weak " + typeRefStr(f->type) + "' has no valid target: a weak reference must point "
                      "at a class instance (an object with identity), not a primitive or non-class type.",
                      f->loc);
        }
        if (!f->init) continue;
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

// region-binder (§8): walk a method body collecting which value-parameters get stored into the receiver.
// `alias` maps a local (or parameter) name to a parameter index it aliases; `this.field = <param/alias>`
// (or an index-store into a `this` field) marks that parameter escaped. Handles the block-bearing control
// flow; a store buried in `switch`/`try` is not yet scanned (a v1 soundness gap, tracked).
// The declared type of `recv.field` -- resolves `this.field` (via the enclosing class) and `local.field`
// (via the local's type). Returns "" when it can't resolve (a computed receiver, etc.).
std::string SemanticAnalyzer::fieldTypeOf(const ast::MemberExpr& mem) {
    std::string cls;
    if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem.object.get())) {
        if (oid->name == "this") cls = enclosingClass_;
        else if (const LocalVar* v = lookupLocal(oid->name)) cls = baseType(v->type);
    }
    if (cls.empty()) return "";
    const FieldInfo* fi = findField(baseType(cls), mem.member);
    return fi != nullptr ? fi->type : "";
}

void SemanticAnalyzer::scanEscapes(const ast::Block& body, std::unordered_map<std::string, int>& alias,
                                   std::vector<bool>& esc) {
    for (const auto& stmt : body.statements) scanStmt(stmt.get(), alias, esc);
}

// Process one statement for the escape summary, recursing into EVERY block-bearing statement so a store
// buried in switch/try/match/using/etc. is never missed (soundness). (Stores buried inside a block-bearing
// EXPRESSION -- spec 30.18 -- are the one residual, tracked.)
void SemanticAnalyzer::scanStmt(const ast::Stmt* s, std::unordered_map<std::string, int>& alias,
                                std::vector<bool>& esc) {
    if (s == nullptr) return;
    auto paramOf = [&](const ast::Expr* e) -> int {  // the param index an expression aliases, or -1
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
            auto it = alias.find(id->name);
            return it == alias.end() ? -1 : it->second;
        }
        return -1;
    };
    // The lifetime "slot" a field-store target belongs to: -1 = `this` (receiver), j = parameter j (or an
    // alias of one), -2 = neither (a local -> same lifetime as us, no escape). We record the store regardless
    // of the field's type; whether it actually ALIASES (a value copies, a pointer/generic-ref aliases) is
    // decided at the CALL SITE from the concrete argument's type -- this is what makes it work through
    // generics (a `T[]` field is not a ref in the template but is when T = Node*).
    auto storeSlot = [&](const ast::Expr* target) -> int {
        const ast::Expr* t = target;
        if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(t)) t = ix->array.get();
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(t);
        if (mem == nullptr) return -2;
        const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        if (oid == nullptr) return -2;
        if (oid->name == "this") return -1;
        auto ta = alias.find(oid->name);              // is the target object a parameter (or its alias)?
        return (ta != alias.end() && escapeScanParams_ != nullptr &&
                ta->second < static_cast<int>(escapeScanParams_->size())) ? ta->second : -2;
    };
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        int p = vd->init ? paramOf(vd->init.get()) : -1;   // `var y = param/alias` -> y aliases it
        if (p >= 0) alias[vd->name] = p; else alias.erase(vd->name);
    } else if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        int slot = storeSlot(as->target.get());
        if (slot != -2) {
            int p = paramOf(as->value.get());   // storing parameter p into slot's ref field
            if (p >= 0 && p < static_cast<int>(esc.size())) {
                if (slot == -1) esc[p] = true;                            // escapes into the receiver
                else if (p < static_cast<int>(escapeScanParamTargets_.size()) &&
                         std::find(escapeScanParamTargets_[p].begin(), escapeScanParamTargets_[p].end(),
                                   slot) == escapeScanParamTargets_[p].end())
                    escapeScanParamTargets_[p].push_back(slot);          // escapes into parameter `slot`
            }
        }
        if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(as->target.get())) {
            int p = paramOf(as->value.get());              // reassigning a local: retag or clear
            if (p >= 0) alias[tid->name] = p; else alias.erase(tid->name);
        }
    } else if (const auto* is = dynamic_cast<const ast::IfStmt*>(s)) {
        scanEscapes(is->thenBlock, alias, esc);
        if (is->elseBlock) scanEscapes(*is->elseBlock, alias, esc);
    } else if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) {
        scanEscapes(ws->body, alias, esc);
    } else if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(s)) {
        scanEscapes(dw->body, alias, esc);
    } else if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) {
        scanStmt(fs->init.get(), alias, esc); scanStmt(fs->update.get(), alias, esc);
        scanEscapes(fs->body, alias, esc);
    } else if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
        scanEscapes(fe->body, alias, esc);
    } else if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
        for (const auto& c : ms->cases) scanEscapes(c.body, alias, esc);
        if (ms->defaultBody) scanEscapes(*ms->defaultBody, alias, esc);
    } else if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
        for (const auto& c : sw->cases) scanEscapes(c.body, alias, esc);
        if (sw->defaultBody) scanEscapes(*sw->defaultBody, alias, esc);
    } else if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) {
        scanEscapes(ts->body, alias, esc);
        for (const auto& c : ts->catches) scanEscapes(c.body, alias, esc);
        if (ts->finallyBlock) scanEscapes(*ts->finallyBlock, alias, esc);
    } else if (const auto* df = dynamic_cast<const ast::DeferStmt*>(s)) {
        scanEscapes(df->body, alias, esc);
    } else if (const auto* us = dynamic_cast<const ast::UsingStmt*>(s)) {
        scanStmt(us->decl.get(), alias, esc); scanEscapes(us->body, alias, esc);
    } else if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) {
        scanEscapes(sy->body, alias, esc);
    } else if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(s)) {
        scanStmt(lb->stmt.get(), alias, esc);
    } else if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) {
        // TRANSITIVE escape (fixpoint): `this.M(param)` or `this.field.M(param)` where callee M stores that
        // argument into ITS receiver -- which is part of OUR `this` -- makes the argument escape US too.
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get()))
            if (const auto* callee = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                std::string calleeClass;
                if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(callee->object.get())) {
                    if (rid->name == "this") calleeClass = escapeScanClass_;   // this.M(...)
                } else if (const auto* rmem = dynamic_cast<const ast::MemberExpr*>(callee->object.get())) {
                    if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(rmem->object.get());
                        oid != nullptr && oid->name == "this")                 // this.field.M(...)
                        if (const FieldInfo* fi = findField(escapeScanClass_, rmem->member))
                            calleeClass = baseType(fi->type);
                }
                if (!calleeClass.empty()) {
                    auto sit = escapesToReceiver_.find(calleeClass + "." + callee->member);
                    if (sit != escapesToReceiver_.end())
                        for (std::size_t k = 0; k < call->args.size() && k < sit->second.size(); ++k)
                            if (sit->second[k])
                                if (const auto* aid =
                                        dynamic_cast<const ast::IdentifierExpr*>(call->args[k].get())) {
                                    auto it = alias.find(aid->name);
                                    if (it != alias.end() && it->second < static_cast<int>(esc.size()) &&
                                        !esc[it->second]) {
                                        esc[it->second] = true;
                                        escapeSummaryChanged_ = true;  // a summary grew -> another fixpoint round
                                    }
                                }
                }
            }
    }
}

void SemanticAnalyzer::computeEscapeSummaries(const ast::Program& program) {
    // Iterate to a fixpoint: a transitive store (`this.list.add(param)`) can only be seen once the callee's
    // own summary is known, so re-scan until no summary grows. Monotone (bits only turn on) -> it converges.
    // IMPORTED bundles (user libraries via .ldb) carry no bodies -- their escape summary rode along in the
    // .ldh `escapes(...)` clause, parsed onto each MethodDecl. Load it so their container methods are checked.
    for (const ast::Bundle& bundle : program.bundles) {
        if (!bundle.isImported) continue;
        for (const ast::Namespace& ns : bundle.namespaces)
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& member : cls.members)
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        std::string key = baseType(cls.name) + "." + m->name;
                        std::vector<bool> rec(m->params.size(), false);
                        std::vector<std::vector<int>> par(m->params.size(), {});
                        for (const auto& [i, slot] : m->escapeSummary)
                            if (i >= 0 && i < static_cast<int>(m->params.size())) {
                                if (slot == -1) rec[i] = true; else par[i].push_back(slot);
                            }
                        escapesToReceiver_[key] = std::move(rec);
                        escapesToParam_[key] = std::move(par);
                    }
    }
    int guard = 0;
    do {
        escapeSummaryChanged_ = false;
        for (const ast::Bundle& bundle : program.bundles) {
            if (bundle.isImported) continue;
            for (const ast::Namespace& ns : bundle.namespaces)
                for (const ast::ClassDecl& cls : ns.classes)
                    for (const ast::MemberPtr& member : cls.members)
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                            if (m->isAbstract || m->isExtern) continue;   // no LDP3 body to scan
                            escapeScanClass_ = baseType(cls.name);
                            escapeScanParams_ = &m->params;
                            escapeScanParamTargets_.assign(m->params.size(), {});
                            std::unordered_map<std::string, int> alias;   // param/alias name -> param index
                            for (std::size_t i = 0; i < m->params.size(); ++i)
                                alias[m->params[i].name] = static_cast<int>(i);
                            std::string key = escapeScanClass_ + "." + m->name;
                            std::vector<bool> esc = escapesToReceiver_.count(key) > 0
                                                        ? escapesToReceiver_[key]  // keep bits from prior round
                                                        : std::vector<bool>(m->params.size(), false);
                            scanEscapes(m->body, alias, esc);
                            escapesToReceiver_[key] = esc;
                            escapesToParam_[key] = escapeScanParamTargets_;  // param -> param slots it escapes to
                            // write the summary back onto the AST so the .ldh emitter can serialize it for
                            // downstream compilation units (an `escapes(i>slot, ...)` clause).
                            std::vector<std::pair<int, int>> sum;
                            for (std::size_t i = 0; i < esc.size(); ++i) if (esc[i]) sum.emplace_back((int)i, -1);
                            for (std::size_t i = 0; i < escapeScanParamTargets_.size(); ++i)
                                for (int slot : escapeScanParamTargets_[i]) sum.emplace_back((int)i, slot);
                            const_cast<ast::MethodDecl*>(m)->escapeSummary = std::move(sum);
                        }
        }
    } while (escapeSummaryChanged_ && ++guard < 50);   // 50 = a very high safety bound; real depth is tiny
}

void SemanticAnalyzer::analyzeBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        if (bundle.isImported) continue;  // bodies live in the .ldb; only its public API is visible
        // The freestanding restrictions (spec 36.3) are about what the PROGRAM may use. The stdlib
        // itself is written in full LDP3 -- System.Ipc throws, for one -- and the parts a freestanding
        // program cannot reach are stripped as dead code anyway. Checking the prelude's own bodies
        // against them would outlaw the stdlib for having features the program simply never calls.
        const bool wasFreestanding = freestanding_;
        if (bundle.isPrelude) freestanding_ = false;
        // Imports are written before `program` (file level, spec 2.7); the in-bundle form is still
        // accepted during migration. Collect the imported symbol names from both.
        currentBundle_ = bundle.name;  // for the stdlib-cohesion visibility check
        currentImports_.clear();
        for (const ast::ImportDecl& imp : program.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::ImportDecl& imp : bundle.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            for (const ast::ClassDecl& cls : ns.classes) {
                currentClass_ = cls.name;  // keep accurate for checkTypeAccessible's mono exemption
                enclosingClass_ = cls.name;  // active from here so field inits resolve unqualified calls too
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
                enclosingClass_ = cls.name;  // kept across static methods (currentClass_ is cleared there)
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get())) {
                        if (m->isAbstract || m->isExtern) continue;  // no LDP3 body to analyze
                        if (m->isAsync && freestanding_)
                            error("async methods are not available in freestanding mode (spec 36.3)",
                                  m->loc);
                        // A value Result/Option rides the Task's 64-bit result slot boxed (codegen copies
                        // the { tag, payload } struct to the heap on completion and unboxes it on await),
                        // so both the value and boxed forms of an async Result/Option are allowed.
                        // A [Test] and the [Setup]/[Teardown] that bracket it all run inside their own
                        // class's fixture window, so they are the methods the fixture-ownership warning
                        // applies to.
                        inTestMethod_ = false;
                        for (const ast::AnnotationUse& a : m->annotations)
                            if (a.name == "Test" || a.name == "Setup" || a.name == "Teardown")
                                inTestMethod_ = true;
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : m->requiresClauses) contracts.push_back(e.get());
                        // Postconditions go separately: they are checked with `result` in scope, and
                        // preconditions must not see it.
                        std::vector<const ast::Expr*> posts;
                        for (const auto& e : m->ensuresClauses) posts.push_back(e.get());
                        currentReturnType_ = typeRefStr(m->returnType);  // for the return null check
                        currentReturnIsMove_ = m->returnType.isMove;
                        currentGenElem_ = m->genElem;  // spec 22.6: the type each `yield` must produce
                        currentThrows_.clear();
                        for (const auto& t : m->throwsTypes)
                            currentThrows_.push_back(baseType(typeRefStr(t)));
                        const std::string retT = typeRefStr(m->returnType);
                        // `naked` changes what an asm body is ALLOWED to do, so the asm checker has to
                        // know. In an ordinary method the block sits inside compiler-generated code and
                        // every register it destroys must be declared, or the allocator's live values
                        // are corrupted. A naked method has no such code -- the body IS the method --
                        // so the same write is not a lie, and reporting it would reject every boot stub
                        // ever written.
                        inNakedFn_ = m->isNaked;
                        analyzeMethodBody(m->body, m->params,
                                          m->isStatic ? std::string() : cls.name, false, contracts,
                                          posts, retT == "void" ? std::string() : retT);
                        inNakedFn_ = false;
                        // A non-void method that can reach its end without returning. LDP3-0501 was
                        // written in the catalog and had NO producer, so `returns int { if (n > 0) {
                        // return 7; } }` compiled clean and handed the caller a 0 -- a wrong answer, in
                        // the most ordinary shape there is. `blockAlwaysExits` is the same walker the
                        // flow machine uses to decide that a guard clause narrows, so the two agree
                        // about what "this path is over" means.
                        //
                        // Abstract/extern/async bodies are skipped: there is nothing to fall off.
                        // A generator (`yield`) ends by running out of values, not by returning one.
                        // An EMPTY body is also skipped, and not only for tidiness: every test that
                        // renames a class (the stdlib-name and namespace-collision ones) reaches this
                        // point with prelude `extern` declarations whose `isExtern` did not survive the
                        // rewrite, so the flag alone is not enough to tell "no body" from "a body that
                        // falls through". A declaration with nothing in it never had a path to check.
                        if (!m->isAbstract && !m->isExtern && !m->isAsync && m->genElem.empty() &&
                            !m->body.statements.empty() &&
                            !typeRefStr(m->returnType).empty() && typeRefStr(m->returnType) != "void" &&
                            !alwaysReturns(m->body))
                            error("method '" + m->name + "' returns '" + typeRefStr(m->returnType) +
                                      "', but a path reaches the end of its body without returning a "
                                      "value. Falling off the end leaves the caller holding whatever "
                                      "happened to be there -- add a `return` on that path, usually the "
                                      "final `else` or the code after the last `if`",
                                  m->loc);
                        currentGenElem_.clear();
                    } else if (const auto* c =
                                   dynamic_cast<const ast::ConstructorDecl*>(member.get())) {
                        std::vector<const ast::Expr*> contracts;
                        for (const auto& e : c->requiresClauses) contracts.push_back(e.get());
                        for (const auto& e : c->ensuresClauses) contracts.push_back(e.get());
                        currentReturnType_ = "void";
                        currentReturnIsMove_ = false;
                        currentThrows_.clear();
                        // WHICH FIELDS THIS CONSTRUCTOR OWES A VALUE. Computed from the declarations
                        // rather than from `ClassInfo`, because the exclusions live in the AST: an
                        // initializer at the declaration, `lazy`, `static`, `persistent`.
                        pendingCtorFields_.clear();
                        // A SYNTHESIZED class is not the programmer's to fix. The state class a
                        // `generator` method compiles into is written by this compiler, and an error
                        // pointing into it names a line nobody typed. Synthesized nodes carry an empty
                        // location, which is the same signal used elsewhere in this file.
                        // ...and neither is a MONOMORPHIZED one. By the time a generic reaches here it
                        // has been copied per type argument -- `FilterStream$int` -- and the copy has
                        // lost what the original said: a `T cached` guarded by a `hasCached` flag is
                        // now an `int cached` with no visible reason it may be left alone, and there is
                        // no default the constructor could write for a `T` anyway.
                        //
                        // STATED LIMITATION rather than a hidden one: the right place to check a
                        // generic is its TEMPLATE, once, before substitution, and this analysis does not
                        // run there. So a generic class's constructor is not checked at all today. The
                        // `$` in the name is what monomorphization and synthesis both leave behind.
                        const bool synthesized =
                            cls.loc.file.empty() || cls.name.find('$') != std::string::npos;
                        for (const ast::MemberPtr& fm : cls.members) {
                            if (synthesized) break;
                            const auto* fd = dynamic_cast<const ast::FieldDecl*>(fm.get());
                            if (fd == nullptr) continue;
                            // A field with a value at its declaration already has one.
                            if (fd->init) continue;
                            // A static field is not per-object, so a constructor is not where it gets
                            // its value.
                            if (fd->isStatic) continue;
                            // `lazy` MEANS uninitialised until first read -- that is the feature, and
                            // reporting it would make the keyword unusable.
                            if (fd->isLazy) continue;
                            // A persistent field is read out of its block, which the runtime fills from
                            // the previous incarnation; assigning it in the constructor is how INITIAL
                            // values are expressed, not a requirement (spec 18.9).
                            if (fd->isPersistent) continue;
                            // A field whose TYPE has a defined empty value is not uninitialised when it
                            // is left alone -- it is that value, and the type says so. `nullable T*`
                            // starts null and `weak T*` starts as an empty slot, both established by
                            // codegen rather than by the constructor. Requiring `this.next = null;`
                            // would be ceremony that says exactly what the declaration already said.
                            //
                            // A plain `T*` is NOT excluded, and that is the line: a non-nullable pointer
                            // left unassigned is a dangling pointer the type system has promised is
                            // valid, which is worse than either.
                            if (fd->isWeak) continue;
                            if (isNullableType(typeRefStr(fd->type))) continue;
                            // ANY pointer field. `nullable T*` is the explicit spelling, but a plain
                            // `T*` field null-defaults too, and the linked-list idiom -- a `next` the
                            // constructor deliberately leaves empty -- is written that way throughout
                            // the standard library and the tests. Demanding `this.next = null;` would be
                            // ceremony restating the declaration, and rejecting existing correct code is
                            // how a new check gets switched off rather than obeyed.
                            if (!typeRefStr(fd->type).empty() && typeRefStr(fd->type).back() == '*')
                                continue;
                            // A field whose type is one of the class's TYPE PARAMETERS has no default
                            // the constructor could write: there is no value of `T` to be had without
                            // one being supplied. The prelude's `FilterStream<T>` is the shape --
                            // a `T cached` guarded by a `hasCached` flag, correct and unassignable.
                            // Seeing that it is guarded needs reasoning this analysis does not do, so
                            // the type parameter is where the line goes.
                            bool isTypeParam = false;
                            for (const std::string& tp : cls.typeParams)
                                if (typeRefStr(fd->type) == tp) isTypeParam = true;
                            if (isTypeParam) continue;
                            // A `region` field is brought into being by `itself.allocate(...)`, which is
                            // an assignment like any other -- so regions are NOT excluded.
                            pendingCtorFields_.push_back({fd->name, fd->loc});
                        }
                        analyzeMethodBody(c->body, c->params, cls.name, /*inConstructor=*/true,
                                          contracts);
                        // ...and what it left unset. The two messages are the two different mistakes,
                        // exactly as for locals: never assigned, versus assigned on only some paths.
                        //
                        // Why this matters MORE for a field than for a local, which is the reason it was
                        // worth extending the analysis across the object boundary: an uninitialised
                        // local reads stack garbage, which is usually absurd and fails loudly. An
                        // uninitialised field reads THE PREVIOUS OBJECT'S VALUE, because the heap block
                        // is reused -- so the wrong value is plausible and stable. A socket in the pico
                        // kernel inherited a dead socket's port number this way: everything downstream
                        // worked perfectly with the wrong number, the datagram went out and the answer
                        // came back, and it was discarded one layer above.
                        for (const auto& [fname, floc] : pendingCtorFields_) {
                            const FlowFacts::Init st = initStateOf("this." + fname);
                            if (st == FlowFacts::Init::Init) continue;
                            error(st == FlowFacts::Init::Uninit
                                      ? "constructor of '" + cls.name + "' never assigns field '" +
                                            fname + "'. A new object's storage is whatever was last "
                                            "there -- for a heap object, the previous object's values -- "
                                            "so the field does not start empty, it starts WRONG. Assign "
                                            "it here, or give it a value at its declaration"
                                      : "constructor of '" + cls.name + "' assigns field '" + fname +
                                            "' on only some paths. The others leave it holding whatever "
                                            "was in that memory before, which for a reused heap block is "
                                            "the previous object's value. Assign it on every path, or "
                                            "give it a default at its declaration",
                                  floc);
                        }
                        pendingCtorFields_.clear();
                        // A base whose constructor takes arguments has to be given them. Without a
                        // `super(...)` codegen called it with `this` alone, so the arity was wrong and
                        // the LLVM verifier caught it -- "Incorrect number of arguments passed to called
                        // function", a message that names nothing the programmer wrote and points at no
                        // line of theirs. Reject it here, where the omission actually is.
                        if (!cls.superclass.empty())
                            if (const ClassInfo* sup = lookupClass(cls.superclass);
                                sup != nullptr && !sup->ctorParamTypes.empty()) {
                                bool hasSuper = false;
                                if (!c->body.statements.empty())
                                    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(
                                            c->body.statements.front().get()))
                                        if (const auto* call =
                                                dynamic_cast<const ast::CallExpr*>(es->expr.get()))
                                            if (dynamic_cast<const ast::SuperExpr*>(call->callee.get()) !=
                                                nullptr)
                                                hasSuper = true;
                                if (!hasSuper)
                                    error("'" + cls.name + "' extends '" + cls.superclass +
                                              "', whose constructor takes " +
                                              std::to_string(sup->ctorParamTypes.size()) +
                                              " argument(s), so this constructor has to begin with "
                                              "`super(...)` to supply them. Without it the base is left "
                                              "unbuilt and its fields hold whatever was there",
                                          c->loc);
                            }
                    } else if (const auto* d =
                                   dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        currentReturnType_ = "void";
                        currentReturnIsMove_ = false;
                        currentThrows_.clear();
                        analyzeMethodBody(d->body, {}, cls.name, false);
                    }
                }
            }
            // Catalog-implementing enums keep their method impls on the enum (they are
            // not desugared to a class); type-check those bodies too. `this` has the
            // enum type; an instance method receives the enum value (an ordinal).
            for (const ast::EnumDecl& en : ns.enums) {
                enclosingClass_ = en.name;
                for (const ast::MemberPtr& member : en.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->isAbstract) continue;
                    for (const ast::Param& p : m->params)
                        checkTypeAccessible(typeRefStr(p.type), p.loc);
                    checkTypeAccessible(typeRefStr(m->returnType), m->loc);
                    std::vector<const ast::Expr*> contracts;
                    for (const auto& e : m->requiresClauses) contracts.push_back(e.get());
                    for (const auto& e : m->ensuresClauses) contracts.push_back(e.get());
                    // Same leak as the literal suffixes below: an enum's method bodies are analyzed here
                    // rather than in the class member loop, so `currentReturnType_` still held whatever
                    // the last CLASS method left in it. A method on an enum returns a type like any other.
                    currentReturnType_ = typeRefStr(m->returnType);
                    currentReturnIsMove_ = m->returnType.isMove;
                    currentThrows_.clear();
                    analyzeMethodBody(m->body, m->params,
                                      m->isStatic ? std::string() : en.name, false, contracts);
                }
            }
        }
        freestanding_ = wasFreestanding;
    }
}

bool SemanticAnalyzer::analyze(const ast::Program& program, bool libraryMode, bool testMode) {
    libraryMode_ = libraryMode;
    testMode_ = testMode;
    // Freestanding mode (spec 36): the whole program, or any bundle, may opt out of the managed
    // runtime; here we treat the program as freestanding if it or any bundle declares it.
    freestanding_ = program.isFreestanding;
    for (const ast::Bundle& b : program.bundles) {
        if (b.isFreestanding) freestanding_ = true;
        bundleNames_.insert(b.name);  // every declared/imported bundle: the import path's first segment
        for (const ast::Namespace& ns : b.namespaces)
            namespaceBundle_[ns.name] = b.name;  // namespace -> owning bundle (stdlib-cohesion check)
    }
    // Virtual builtin types (no prelude class, e.g. to avoid clashing with a user class named Math) live
    // in the System bundle (spec 34). Registering their (bundle, namespace) lets the strict full-path
    // import validate, e.g. `import System.Math.Math;` -> bundle System, namespace Math, type Math.
    // `shadowable`: a builtin the standard library itself never calls, so a user class may take the
    // name and lose nothing but its own access to the builtin. Math is the one, and deliberately so
    // -- it exists as a virtual type rather than a prelude class precisely so that a program with its
    // own Math compiles, which is a common enough name to be worth the exemption. Every other builtin
    // IS used by the stdlib, so shadowing one breaks code the author never wrote.
    auto builtin = [&](const std::string& type, const std::string& ns, bool shadowable = false) {
        typeNamespace_[type] = ns;
        typeBundle_[type] = "System";
        if (!shadowable) builtinTypes_.insert(type);
    };
    // The one list lives in ast.h, because the monomorphizer needs the same answer -- see
    // ast::builtinStaticClasses(). Two copies of it already cost a day: expansion had its own, so a
    // generic `read<T>` anywhere rewrote every `Raw.read<int>` into a builtin that does not exist.
    //
    // spec 17.8: the low-level memory API is a NAMESPACE of classes that each do one thing --
    // System.Memory.Allocator and System.Memory.Raw. It used to be one class `Memory` hung straight
    // off the bundle with no namespace, the only builtin shaped that way.
    for (const ast::BuiltinStaticClass& b : ast::builtinStaticClasses())
        builtin(b.name, b.ns, b.shadowable);
    // reflect (spec 31) is a builtin namespace, not a prelude class; register it so `import reflect;`
    // (a bare, bundle-less import) resolves. Reflection use is gated on this import at reflect.typeOf.
    typeNamespace_["reflect"] = "reflect";
    // Naming convention (spec 2.6): bundle and namespace names are PascalCase. A lowercase initial (on
    // any dotted segment) is a warning, not an error -- it nudges the convention without breaking code.
    auto lowerInitial = [](const std::string& name) {
        bool atStart = true;
        for (char c : name) {
            if (atStart) {
                if (c >= 'a' && c <= 'z') return true;  // a segment starts lowercase
                atStart = false;
            }
            if (c == '.') atStart = true;
        }
        return false;
    };
    for (const ast::Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported) continue;  // warn on the user's own source only
        if (!b.name.empty() && lowerInitial(b.name))
            warn("bundle '" + b.name +
                     "' should start with a capital letter (bundle names are conventionally PascalCase)",
                 b.loc);
        for (const ast::Namespace& ns : b.namespaces)
            if (!ns.name.empty() && lowerInitial(ns.name))
                warn("namespace '" + ns.name +
                         "' should start with a capital letter (namespace names are conventionally "
                         "PascalCase)",
                     ns.loc);
    }
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
    // §8: compute the interprocedural escape summary before checking. Also run it when emitting a library
    // (even without --region-binder) so the summary is serialized into the .ldh for downstream consumers.
    if (regionBinder_ || libraryMode_) computeEscapeSummaries(program);
    collectFixtureOwners(program);  // spec 32.11: known before the bodies that reach into them
    analyzeBodies(program);
    analyzeLiteralBodies(program);
    validateAnnotations(program);  // spec 14.3: applied [Name(...)] match a declared annotation
    validateTestDeclarations(program);  // spec 32.11: [Test]/[Cases]/hooks are well formed
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
            error("a 'fixed' must have a numeric, boolean, or char type, got '" + type + "'", c.loc);
            return;
        }
        const std::string key = owner.empty() ? c.name : owner + "." + c.name;
        if (constTypes_.count(key) > 0) {
            error("fixed '" + key + "' is already defined", c.loc);
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
                error("a 'fixed' must be a static class or struct member; declare it inside a class",
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
            error("fixed '" + key + "' must have an initializer", c.loc);
            return;
        }
        if (isFloatType(type)) {
            double d;
            if (!evalConstDouble(*c.init, d, &constDoubles_, &constInts_, &comptimeMethods_))
                error("fixed '" + key + "' initializer must be a compile-time constant", c.loc);
            else
                constDoubles_[key] = d;
        } else {
            long long v;
            if (!evalConstInt(*c.init, v, &constInts_, &comptimeMethods_, &constDoubles_))
                error("fixed '" + key + "' initializer must be a compile-time constant", c.loc);
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

// Resolves each import against the spec 2.7 model: an intra-program import names the FULL path,
// bundle first, then the namespace, then the symbol (`import Forge.App.Controller;`). The last
// component is the symbol; the first must be a real bundle. Importing a literal suffix enables its
// `N suffix` syntax (spec 17.10 rule 5). An unknown symbol, an unknown bundle, or a namespace that
// does not match the symbol's real home is an error.
void SemanticAnalyzer::processImports(const ast::Program& program) {
    auto validate = [&](const ast::ImportDecl& imp) {
        if (imp.path.empty()) return;
        const std::string& symbol = imp.path.back();
        std::string full;
        for (std::size_t i = 0; i < imp.path.size(); ++i) full += (i > 0 ? "." : "") + imp.path[i];
        // Bring the symbol's literal suffixes into scope regardless of the path check below, so a
        // path mistake reports once and does not cascade into "unknown suffix/type" noise. (Type
        // visibility itself is gated by currentImports_, populated from the path's last segment.)
        auto bringIntoScope = [&]() {
            importedSuffixes_.insert(symbol);  // harmless for non-literals
            if (auto cs = classSuffixes_.find(symbol); cs != classSuffixes_.end())
                for (const std::string& s : cs->second) importedSuffixes_.insert(s);
            if (imp.isFinal) finalImports_.insert(symbol);  // spec 37.6: not unimportable
        };
        // Cross-program (spec 2.7/2.8): reached over IPC, the path rooted at the program name
        // (`import from program GameEngine GameEngine.audio.mixers.Foo;`). Its types are synthesized as
        // IPC proxies, so validate leniently -- just require the symbol to exist locally as a proxy.
        if (!imp.programName.empty()) {
            if (typeNamespace_.find(symbol) == typeNamespace_.end())
                error("import of unknown symbol '" + full + "' from program '" + imp.programName + "'",
                      imp.loc);
            bringIntoScope();
            return;
        }
        auto nsIt = typeNamespace_.find(symbol);
        if (nsIt == typeNamespace_.end()) {
            // A type name declared in MORE THAN ONE namespace is renamed to `<ns>__<Type>` by the
            // namespace-disambiguation pass (monomorphize.cpp), so the bare name is no longer in the
            // registry -- and this validator would report the import of a perfectly good type as an
            // unknown symbol. Retry with the disambiguated name built from this import's own
            // namespace path: if that exists, the import names a real type and is well-formed.
            std::string disambiguated;
            for (std::size_t i = 1; i + 1 < imp.path.size(); ++i)
                disambiguated += (disambiguated.empty() ? "" : "_") + imp.path[i];
            if (!disambiguated.empty()) {
                disambiguated += "__" + symbol;
                if (typeNamespace_.count(disambiguated) > 0) {
                    importedSuffixes_.insert(disambiguated);
                    if (imp.isFinal) finalImports_.insert(disambiguated);
                    bringIntoScope();
                    return;
                }
            }
            error("import of unknown symbol '" + full + "'", imp.loc);
            bringIntoScope();
            return;
        }
        // A bare, bundle-less builtin import (`import reflect;`): a single segment, nothing to qualify.
        if (imp.path.size() == 1) { bringIntoScope(); return; }
        // Full path (spec 2.7): Bundle.Namespace[.Sub].Type. The first segment must name a real bundle;
        // everything between it and the type must be the type's real namespace.
        const std::string& bundleSeg = imp.path.front();
        std::string nsPath;  // path[1 .. size-2]
        for (std::size_t i = 1; i + 1 < imp.path.size(); ++i)
            nsPath += (nsPath.empty() ? "" : ".") + imp.path[i];
        const std::string& realNs = nsIt->second;
        const std::string realBundle = typeBundle_.count(symbol) ? typeBundle_[symbol] : std::string();
        const std::string want =
            (realBundle.empty() ? std::string("<bundle>") : realBundle) + "." + realNs + "." + symbol;
        // The first segment is valid if it names a declared/imported bundle, or the symbol's own
        // registered bundle -- the latter covers a virtual builtin (System.Memory) whose bundle exists
        // even when the prelude that declares it is not part of this compilation.
        const bool bundleOk =
            bundleNames_.count(bundleSeg) > 0 || (!realBundle.empty() && bundleSeg == realBundle);
        if (bundleOk && nsPath == realNs) {
            bringIntoScope();  // well-formed full path
        } else if (!bundleOk && (nsPath == realNs || full == realNs + "." + symbol)) {
            // Resolves by namespace but names no real bundle first: the pre-2.7 short form. Point at
            // the full path the type now requires.
            error("import '" + symbol + "' by its full path: 'import " + want +
                      ";' -- imports now name the bundle first, then the namespace (spec 2.7)",
                  imp.loc);
            bringIntoScope();
        } else {
            error("'" + symbol + "' is imported as '" + want + "'; the path '" + full +
                      "' does not match its bundle/namespace (spec 2.7)",
                  imp.loc);
            bringIntoScope();
        }
    };
    for (const ast::ImportDecl& imp : program.imports) validate(imp);  // file-level (spec 2.7)
    for (const ast::Bundle& bundle : program.bundles)
        for (const ast::ImportDecl& imp : bundle.imports) validate(imp);
}

// Type-checks the body of each literal suffix, with its single parameter in
// scope and treated like a static function (no `this`).
void SemanticAnalyzer::analyzeLiteralBodies(const ast::Program& program) {
    for (const ast::Bundle& bundle : program.bundles) {
        currentBundle_ = bundle.name;  // for the stdlib-cohesion visibility check
        currentImports_.clear();
        for (const ast::ImportDecl& imp : program.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::ImportDecl& imp : bundle.imports)
            if (!imp.path.empty()) currentImports_.insert(imp.path.back());
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            // A LiteralDecl is its own AST node, not a MethodDecl, so the member loop above never set
            // `currentReturnType_` for one -- its body was analyzed carrying whatever the LAST method
            // analyzed had left there. Harmless while only nullability was checked (both sides
            // non-nullable), and a wave of false "cannot return X from a method returning boolean" the
            // moment the return TYPE was checked. A literal suffix returns a type like anything else.
            for (const ast::LiteralDecl& lit : ns.literals) {
                currentReturnType_ = typeRefStr(lit.returnType);
                currentReturnIsMove_ = false;
                currentThrows_.clear();
                analyzeMethodBody(lit.body, {lit.param}, /*thisClass=*/"", /*inConstructor=*/false);
            }
            // Class/struct-owned literal suffix bodies (spec 17.10): static, so no `this`.
            for (const ast::ClassDecl& cls : ns.classes)
                for (const ast::MemberPtr& m : cls.members)
                    if (const auto* lit = dynamic_cast<const ast::LiteralDecl*>(m.get())) {
                        currentReturnType_ = typeRefStr(lit->returnType);
                        currentThrows_.clear();
                        analyzeMethodBody(lit->body, {lit->param}, /*thisClass=*/"",
                                          /*inConstructor=*/false);
                    }
            currentReturnType_.clear();
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
                                         const std::vector<const ast::Expr*>& contracts,
                                         const std::vector<const ast::Expr*>& postconditions,
                                         const std::string& postResultType) {
    scopes_.clear();
    moved_.clear();
    // The flow facts describe THIS method's locals and mean nothing in the next one. Leaving them behind
    // made a `delete b` in one stdlib method report every later method's `b` as a use-after-free -- 51
    // tests failing on the same variable name, from a file none of them mentions.
    freed_.clear();
    init_.clear();
    nonNull_.clear();
    suppressNarrowing_ = false;
    activationOwned_.clear();
    lambdaLocals_.clear();
    extracted_.clear();
    checkpointRegion_.clear();
    regionOf_.clear();
    deleted_.clear();
    catchStack_.clear();
    regionConstraints_.clear();
    regionFlavor_.clear();
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
    // DEFINITE ASSIGNMENT FOR FIELDS. Seeded here so the flow machinery that already exists for locals
    // does the work: `init_` is keyed by opaque strings, and the join at a branch merge operates on the
    // map without caring what the keys mean -- so a field entered as `this.name` gets Uninit/Maybe/Init
    // exactly as a local does, including the "assigned on only one path" case that is the hard one.
    //
    // Only in a constructor, and only for fields that have nowhere else to get a value from. See
    // `fieldNeedsInit` for what is excluded and why.
    if (inConstructor)
        for (const auto& [fname, floc] : pendingCtorFields_)
            init_["this." + fname] = FlowFacts::Init::Uninit;
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
    // Postconditions, with `result` in scope. In their own scope so the binding cannot leak into the
    // body or into a sibling method, and AFTER the preconditions so a `requires` naming `result` is
    // still the undeclared-name error it should be -- on entry there is no result to talk about.
    if (!postconditions.empty()) {
        pushScope();
        if (!postResultType.empty()) declareLocal("result", LocalVar{postResultType, false});
        for (const ast::Expr* clause : postconditions) {
            const std::string t = typeOf(*clause);
            if (!t.empty() && t != "boolean")
                error("a contract clause must be boolean, got '" + t + "'", clause->loc);
        }
        popScope();
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
            error(diag::Code::UndeclaredVariable,
                  "assignment to undeclared variable '" + id->name + "'" +
                      didYouMean(id->name, namesInScope()),
                  loc);
            return;
        }
        // A region handle may be (re)bound to bind an empty `region r;` to its allocation (spec 17.2
        // form 3), so region locals are assignable without an explicit `mutable`.
        //
        // DEFERRED INITIALIZATION: the first write to a variable declared without a value is not a
        // reassignment, it is the initialization -- the value is still written exactly once, which is
        // what immutability actually promises. So it is allowed without `mutable`, and the SECOND write
        // is the one that needs it. This is what lets a value be chosen in a branch without making the
        // binding mutable for the rest of its life, which is how `mutable` stays meaningful.
        const bool initializingNow =
            var->deferredInit && initStateOf(id->name) != FlowFacts::Init::Init;
        if (!var->isMutable && var->type != "region" && !initializingNow) {
            error(var->deferredInit
                      ? "cannot assign to '" + id->name +
                            "' again: it was declared without a value and has already been initialized, "
                            "which used up its single write. Declare it 'mutable' if it really needs to "
                            "change"
                      : "cannot assign to immutable variable '" + id->name + "' (declare it 'mutable')",
                  loc);
        }
        markInitialized(id->name);
        // Whatever was proven about the OLD value says nothing about the new one.
        killProofsFor(id->name);
        if (!valueType.empty() && valueType != "null" && !isNullableType(valueType))
            nonNull_.insert(id->name);
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
        if (vecWidth(objType) > 0 && vecLane(mem->member) >= 0) {  // SIMD lane write: v.x = f
            if (const auto* bid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get()))
                if (const LocalVar* lv = lookupLocal(bid->name); lv != nullptr && !lv->isMutable)
                    error("cannot modify a lane of immutable vector '" + bid->name +
                              "' (declare it 'mutable')",
                          loc);
            if (!valueType.empty() && !isNumeric(valueType))
                error("a vector lane takes a numeric value, not '" + valueType + "'", loc);
            return;
        }
        const FieldInfo* f = findField(objType, mem->member);
        if (f == nullptr) {
            // A computed property with a custom setter (spec 8.4): `obj.prop = v` routes to prop$set.
            if (findMethod(objType, mem->member + "$set") != nullptr) {
                if (const MethodInfo* getter = findMethod(objType, mem->member);
                    getter != nullptr && !valueType.empty() && !isSubtype(valueType, getter->returnType))
                    error("cannot assign a value of type '" + valueType + "' to property '" +
                              mem->member + "'",
                          loc);
                return;
            }
            error(diag::Code::NoSuchField,
                  "class '" + objType + "' has no field '" + mem->member + "'" +
                      didYouMean(mem->member, fieldNames(objType)),
                  loc);
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
            // Say WHY, not just that. A null (or nullable) value reaching a non-nullable field is the
            // commonest version of this error and the one whose remedy the generic wording gets wrong:
            // you cannot cast null into a non-nullable type, you declare the field `nullable`.
            if ((valueType == "null" || isNullableType(valueType)) && !isNullableType(f->type)) {
                error("cannot assign " + std::string(valueType == "null" ? "null" : "a nullable value") +
                          " to field '" + mem->member + "': its type '" + f->type +
                          "' is non-nullable, and every type in LDP3 is non-null unless it says "
                          "otherwise. Declare the field 'nullable " + f->type +
                          "' if it can legitimately be absent",
                      loc);
            } else {
                error("cannot assign a value of type '" + valueType + "' to field '" + mem->member +
                          "' of type '" + f->type + "'",
                      loc);
            }
        }
        // Reassigning a partially-moved field reactivates it (spec 19.9).
        if (objId != nullptr) moved_.erase(objId->name + "." + mem->member);
        return;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&target)) {
        const std::string at = typeOf(*ix->array);
        typeOf(*ix->index);
        if (vecWidth(at) > 0) {  // SIMD lane write: v[i] = f
            if (const auto* bid = dynamic_cast<const ast::IdentifierExpr*>(ix->array.get()))
                if (const LocalVar* lv = lookupLocal(bid->name); lv != nullptr && !lv->isMutable)
                    error("cannot modify a lane of immutable vector '" + bid->name +
                              "' (declare it 'mutable')",
                          loc);
            if (!valueType.empty() && !isNumeric(valueType))
                error("a vector lane takes a numeric value, not '" + valueType + "'", loc);
            return;
        }
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
    // `*p = value`: dereference-assign through a pointer. The value must fit the pointee type (the
    // operand's type with one '*' peeled).
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&target); un != nullptr && un->op == "*") {
        const std::string pt = typeOf(*un->operand);
        if (!pt.empty() && pt.back() != '*') {
            error("cannot dereference '" + pt + "': it is not a pointer", loc);
            return;
        }
        const std::string pointee =
            (pt.empty() || pt.back() != '*') ? std::string() : pt.substr(0, pt.size() - 1);
        if (!valueType.empty() && !pointee.empty() && !isSubtype(valueType, pointee) &&
            !fits(pointee)) {
            error("cannot assign a value of type '" + valueType + "' through a '" + pt +
                      "' pointer to '" + pointee + "'",
                  loc);
        }
        return;
    }
    error("invalid assignment target", loc);
}

// Bit-counted type names (int8..int64, uint8..uint64, float32/64) exist only in freestanding mode
// (spec 3.1); in normal mode the named types (byte/short/int/long, float/double, ...) are required.
// Widening the RESULT of a narrow computation is almost always a bug, and a silent one: in
// `cast<address>(f << 12)` the shift already happened in 32 bits, so the high bits are gone before the
// cast runs -- the cast only documents the loss. The fix is always to widen the OPERAND first
// (`cast<address>(f) << 12`), which is one character of difference and a completely different result.
//
// This is the compile-time half of LDP3's no-implicit-conversion rule. Refusing implicit narrowing stops
// a value being silently truncated on the way IN; this stops a value being silently truncated on the way
// UP. Both exist because the compiler is not allowed to assume which width the author meant -- and in a
// kernel the wrong answer is a page mapped somewhere else, discovered much later and somewhere unrelated.
//
// Only the operators that can carry bits past the narrow width are flagged (`<<`, `*`, `+`, `-`); `&`,
// `|`, `>>` and comparisons cannot produce a value the narrow type could not already hold.
void SemanticAnalyzer::checkWideningLostBits(const ast::CastExpr& cst, const std::string& src,
                                             const std::string& dst) {
    if (!isIntName(src) || !isIntName(dst)) return;
    if (intBits(dst) <= intBits(src)) return;                 // not a widening cast
    const auto* bin = dynamic_cast<const ast::BinaryExpr*>(cst.operand.get());
    if (bin == nullptr) return;
    const std::string& op = bin->op;
    if (op != "<<") return;
    // `<<` ONLY, and that scope was measured rather than guessed. A left shift pushes bits straight out
    // of the top, so widening afterwards is essentially always the wrong order -- there is no common
    // correct code shaped like `cast<long>(x << k)`. `*`, `+` and `-` overflow only when the values are
    // large, and `cast<long>(i * n)` over loop indices is a correct idiom that appears throughout real
    // code (it fired on matmul and recursion tests here). Flagging those would make this noise, and a
    // diagnostic people learn to ignore protects nothing.
    error("widening the result of a narrow '" + op + "': `" + src + "` arithmetic is evaluated in " +
              std::to_string(intBits(src)) + " bits, so bits are lost BEFORE this cast to '" + dst +
              "'. Widen the operand instead: cast<" + dst + ">(x) " + op + " y",
          cst.loc);
}

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
    // ...and the gate in the other direction, which was missing these two. `String` and the test
    // framework's `Test` resolved fine in a freestanding program and then failed at LINK, on
    // __ldp3_str_copy / __ldp3_str_free / printf -- symbols the generated freestanding runtime
    // (memcpy/memset/memmove/__ldp3_panic, src/driver/build.cpp) does not provide. Compiles clean, dies
    // at link: exactly what this gate exists to prevent, and what guide/11 promises cannot happen
    // ("you cannot accidentally reach for the managed runtime").
    //
    // Only user code is flagged. The prelude's own classes name String constantly, and unused prelude
    // code is dead-stripped, so their mere presence must not break a program that never touches them --
    // the same rule the Console gate follows.
    if (freestanding_ && std::string(loc.file) != "<prelude>") {
        const std::string mn = baseType(typeName);
        if (mn == "String")
            error("'String' is a managed object and is not available in freestanding mode (spec 36.3): "
                  "it lowers to __ldp3_str_copy/__ldp3_str_free, which bare metal has no runtime to "
                  "provide. Use a byte literal `b\"...\"` for fixed text, or `byte*`/`byte[]` and the raw "
                  "Memory API for text you build",
                  loc);
        else if (mn == "Test")
            error("the test framework is not available in freestanding mode (spec 36.3): `Test` reports "
                  "through printf and builds Strings, neither of which exists bare metal. Test the "
                  "freestanding program from outside -- boot it and assert on what it emits",
                  loc);
    }
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
    // The stdlib is internally cohesive: a type in the System bundle may use any other System-bundle
    // type without an import (e.g. Json's Json uses Text's StringBuilder). Keyed on the bundle now that
    // stdlib namespaces are bare (IO, Text, ...) rather than carrying a System. prefix.
    if (currentBundle_ == "System") {
        // A generic template's own bundle is erased (typeBundle_ missing), but its namespace is shared
        // with real classes, so the namespace->bundle map covers it; a virtual builtin (Memory, Math)
        // has no namespace block, so its typeBundle_ covers it. Either proves System-bundle membership.
        auto nb = namespaceBundle_.find(it->second);
        if (nb != namespaceBundle_.end() && nb->second == "System") return;
        auto tb = typeBundle_.find(n);
        if (tb != typeBundle_.end() && tb->second == "System") return;
    }
    {
    const std::string b = typeBundle_.count(n) ? typeBundle_[n] : std::string("<bundle>");
    error("type '" + n + "' is in namespace '" + it->second + "'; import it (import " + b + "." +
              it->second + "." + n + ";) to use it here",
          loc);
    }
}

void SemanticAnalyzer::checkRegionAccepts(const std::string& region, const std::string& type,
                                          SourceLocation loc) {
    // Where the constraints live depends on where the REGION lives. A local's are in the per-method
    // map; a field's are at class scope, because the per-method map is cleared between methods -- right
    // for a local, which cannot outlive its declaring method, and fatal for a field, whose constraints
    // would be wiped before the first method that allocates into it ever ran.
    const RegionConstraints* rc = nullptr;
    auto local = regionConstraints_.find(region);
    if (local != regionConstraints_.end()) {
        rc = &local->second;
    } else if (region.rfind("this.", 0) == 0 && !currentClass_.empty()) {
        auto fld = fieldRegionConstraints_.find(currentClass_ + "." + region.substr(5));
        if (fld != fieldRegionConstraints_.end()) rc = &fld->second;
    }
    // A region that declares neither accepts nor rejects takes anything, like a plain arena -- with the
    // difference that it still knows what it took.
    if (rc == nullptr) return;

    for (const std::string& rej : rc->rejects) {
        if (type == rej || isSubtype(type, rej)) {
            error("region '" + region + "' rejects type '" + type + "'", loc);
            return;
        }
    }
    if (rc->accepts.empty()) return;  // rejects-only: anything not rejected is in
    for (const std::string& acc : rc->accepts) {
        if (type == acc || isSubtype(type, acc)) return;
    }
    error("region '" + region + "' does not accept type '" + type + "'", loc);
}

// The ONE place the value-ownership rules are decided, for every place a value can land.
//
// It used to be reachable from two: a local's declaration and a local's reassignment. So `movable`
// meant "you must write move" when the destination was a variable, and meant nothing when it was a
// field, an argument, or a return -- which is to say it meant nothing where ownership matters, since
// those three are exactly the ways a value outlives the method it was written in. The argument path
// had grown its own near-copy of the rules that handled `unique` and skipped `movable` outright.
//
// `what` names the destination so the fix reads right at each site; the rules themselves are here
// and only here.
void SemanticAnalyzer::checkOwnershipAssign(const std::string& targetType, const ast::Expr& rhs,
                                            SourceLocation loc, const std::string& what) {
    if (isRefType(targetType)) return;  // pointers/refs share; no move discipline
    const ClassInfo* ci = lookupClass(baseType(targetType));
    if (ci == nullptr) return;  // not a class value
    const bool rhsIsMove = dynamic_cast<const ast::MoveExpr*>(&rhs) != nullptr;
    const auto* rhsId = dynamic_cast<const ast::IdentifierExpr*>(&rhs);
    const bool rhsIsLValue =
        rhsId != nullptr || dynamic_cast<const ast::MemberExpr*>(&rhs) != nullptr;
    if (!rhsIsLValue || rhsIsMove) return;  // a fresh `new`, a `move`, or a temporary is fine
    if (ci->isMovable) {
        // Name the source as it is WRITTEN, so the hint can be pasted. `move x` where the source was
        // `this.held` is advice that does not compile.
        std::string name = "the value";
        if (rhsId != nullptr) {
            name = rhsId->name;
        } else if (const auto* rhsMem = dynamic_cast<const ast::MemberExpr*>(&rhs)) {
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(rhsMem->object.get()))
                name = oid->name + "." + rhsMem->member;
            else
                name = rhsMem->member;
        }
        error("'" + ci->name + "' is movable, so it is transferred and never copied: " + what +
                  " needs an explicit 'move' (move " + name + ")",
              loc);
    } else if (ci->isUnique && rhsId != nullptr) {
        moved_.insert(rhsId->name);  // unique: a plain assignment is an implicit move
    } else if (classHasUniqueField(baseType(targetType))) {
        // spec 19.2: a `unique` value may not be duplicated, so an object that owns a unique field
        // cannot be value-copied -- the shallow copy would alias the unique and break its single-owner
        // guarantee (a movable field is deep-copied, but a unique one has no valid copy). Share by
        // pointer/reference instead.
        error("cannot copy '" + ci->name + "' into " + what +
                  ": it owns a 'unique' field, which may not be duplicated (spec 19.2) -- share it "
                  "by pointer ('" + ci->name + "*') or reference",
              loc);
    }
}

bool SemanticAnalyzer::classHasUniqueField(const std::string& className) {
    const ClassInfo* ci = lookupClass(className);
    if (ci == nullptr) return false;
    for (const auto& [fname, fi] : ci->fields) {
        (void)fname;
        if (isRefType(fi.type)) continue;  // a pointer/ref field shares; the owner's copy doesn't dup it
        const std::string ft = baseType(fi.type);
        const ClassInfo* fci = lookupClass(ft);
        // The field is marked `unique`, or its type is a `unique` class -- either way the value cannot
        // be duplicated, so the owning object cannot be value-copied.
        if (fi.isUnique || (fci != nullptr && fci->isUnique)) return true;
        if (fci != nullptr && ft != className && classHasUniqueField(ft)) return true;  // recurse
    }
    if (!ci->superclass.empty()) return classHasUniqueField(baseType(ci->superclass));
    return false;
}

// spec 27: "Pointer arithmetic is allowed on every type, but the compiler emits a warning, because
// advancing a pointer to a class makes no semantic sense and can corrupt memory."
void SemanticAnalyzer::warnClassPointerArith(const std::string& ptrType, SourceLocation loc) {
    if (lookupClass(baseType(ptrType)) == nullptr) return;  // a pointer into an array of primitives
    warn("pointer arithmetic on '" + ptrType +
             "' can corrupt memory: a pointer to a class usually points at ONE object, not at an array "
             "of them (spec 27)",
         loc);
}

void SemanticAnalyzer::checkIncDecTarget(const ast::Expr& target, bool isIncrement, SourceLocation loc) {
    std::string type;
    bool mutableTarget = false;
    bool resolved = false;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
        const LocalVar* var = lookupLocal(id->name);
        if (var == nullptr) {
            error(diag::Code::UndeclaredVariable,
                  "modification of undeclared variable '" + id->name + "'" +
                      didYouMean(id->name, namesInScope()),
                  loc);
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
    // A class with an operator ++/-- overload is a valid target (spec 6.5): `c++` reassigns c to the
    // operator's result.
    if (findMethod(baseType(type), isIncrement ? "operator++" : "operator--") != nullptr) return;
    if (isRefType(type)) {  // spec 27: stepping a pointer is allowed -- one element forward or back
        warnClassPointerArith(type, loc);
        return;
    }
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
        if (!evalConstInt(*sa->condition, v, &constInts_, &comptimeMethods_, &constDoubles_)) {
            // A condition over `sizeof` needs the target's real layout, which only the codegen has
            // (spec 28.2, issue #7). Deferring it there is what lets a struct carry a byte budget;
            // folding a size from a layout guessed here would assert something the program does not
            // actually have. Every other non-constant condition is still rejected at once.
            if (!comptime::mentionsSizeof(*sa->condition))
                error("static_assert requires a constant expression", sa->loc);
        } else if (v == 0) {
            error("static assertion failed: " + sa->message, sa->loc);
        }
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
        const bool isRange = baseType(it) == "Range";  // a first-class Range value (spec 7.5), over int
        // Iterable / Iterator (spec 9.2): any class that declares hasNext()+next() (it IS an iterator) or
        // iterator() (it HAS one) can be foreach-ed lazily, no snapshot. Interfaces qualify too.
        const MethodInfo* hasNextM = findMethod(baseType(it), "hasNext", /*objectFallback=*/false);
        const MethodInfo* nextM = findMethod(baseType(it), "next", /*objectFallback=*/false);
        const MethodInfo* iterM = findMethod(baseType(it), "iterator", /*objectFallback=*/false);
        const bool isIterable =
            (hasNextM != nullptr && nextM != nullptr) || iterM != nullptr;
        if (!it.empty() && !isArrayType(it) && !isColl && !isRange && !isIterable)
            error("foreach requires an array, a collection, a range or an Iterable, got '" + it + "'",
                  fe->loc);
        std::string et;
        if (!fe->isVar) {
            et = typeRefStr(fe->elemType);
        } else if (isRange) {
            et = "int";
        } else if (isIterable && !isColl) {  // var x: the element type is what next() returns
            if (nextM != nullptr) {
                et = nextM->returnType;
            } else if (iterM != nullptr) {
                const MethodInfo* n2 = findMethod(baseType(iterM->returnType), "next", false);
                et = n2 != nullptr ? n2->returnType : "";
            }
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
        else error("a 'switch' must have a 'default' case (spec 7.3)", sw->loc);
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
        // A region may be declared empty (`region r;`, spec 17.2 form 3) and allocated later; its
        // init is then null. Every other declaration carries an initializer (the parser enforces it).
        const std::string initType = vd->init ? typeOf(*vd->init) : std::string();
        const std::string declType = vd->isVar ? initType : typeRefStr(vd->type);
        if (!vd->isVar) checkTypeAccessible(declType, vd->loc);
        // Region flavor / growth modifiers (spec 17, flavors expansion): a flavor word only qualifies a
        // region (LDP3-1719), and a region has exactly one flavor (LDP3-1710). The parser space-joins two
        // flavor words into regionFlavor so both names surface here.
        if (!vd->regionFlavor.empty() || vd->regionGrowable) {
            if (declType != "region") {
                const std::string w = !vd->regionFlavor.empty()
                                          ? vd->regionFlavor.substr(0, vd->regionFlavor.find(' '))
                                          : std::string("growable");
                error("'" + w + "' only qualifies a region (spec 17), not a '" + declType +
                          "' declaration",
                      vd->loc);
            } else {
                const std::size_t sp = vd->regionFlavor.find(' ');
                if (sp != std::string::npos) {
                    const std::string a = vd->regionFlavor.substr(0, sp);
                    const std::string b = vd->regionFlavor.substr(sp + 1);
                    error("a region has exactly one flavor, but region '" + vd->name +
                              "' was given two ('" + a + "' and '" + b + "')",
                          vd->loc);
                } else {
                    regionFlavor_[vd->name] = vd->regionFlavor;  // record for extract/delete checks
                    // fixedslot/ring hold one element type, so they need `.accepts({T})` of exactly one
                    // type (LDP3-1711): a single-size pool / a fixed-purpose circular buffer.
                    if (vd->regionFlavor == "fixedslot" || vd->regionFlavor == "ring") {
                        const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                        if (ri == nullptr || ri->accepts.size() != 1)
                            error("a " + vd->regionFlavor +
                                      " region needs its single element type: add .accepts({T}) with "
                                      "exactly one type (spec 17)",
                                  vd->loc);
                    }
                }
            }
            // `growable` contradictions (LDP3-1712): a ring is bounded by definition; a mapped
            // (at-address) region cannot grow; and a stack region is deliberately not growable -- its
            // discipline is mark/rollback within a fixed arena, so growth is expressed by sizing the
            // arena for its depth or by using a growable pool. This is by design, not a gap.
            if (vd->regionGrowable && declType == "region") {
                const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get());
                if (vd->regionFlavor == "ring")
                    error("growable does not apply to a ring region (a ring is bounded by "
                          "definition) (spec 17)",
                          vd->loc);
                else if (ri != nullptr && ri->atAddress != nullptr)
                    error("growable does not apply to a mapped (at address) region -- foreign "
                          "memory cannot grow (spec 17)",
                          vd->loc);
                else if (vd->regionFlavor == "stack")
                    error("growable does not compose with a stack region: size the stack region for its "
                          "depth, or use a growable pool (spec 17)",
                          vd->loc);
            }
        }
        if (!vd->isVar && !initType.empty() && !isSubtype(initType, declType) &&
            !intLiteralFits(*vd->init, declType)) {
            error("cannot initialize variable '" + vd->name + "' of type '" + declType +
                      "' with a value of type '" + initType + "'" + addressHint(initType, declType),
                  vd->loc);
        }
        if (lookupLocal(vd->name) != nullptr && deleted_.count(vd->name) == 0) {
            error("redeclaration or shadowing of variable '" + vd->name + "'", vd->loc);
        } else {
            deleted_.erase(vd->name);  // reborn after delete: persistents reattach (spec 18.2)
            freed_.erase(vd->name);
            // A class value bound to a `new ... on stack` (the default for objects) is a
            // stack object: RAII frees it, and it is not throwable (its carrier would
            // dangle after unwind).
            bool stackObj = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get()))
                stackObj = nw->location != "heap" && !declType.empty() &&
                           lookupClass(baseType(declType)) != nullptr && !isRefType(declType) &&
                           !isArrayType(declType);
            // A declaration with no initializer enters the *uninitialized* state. `region r;` keeps its
            // old behaviour (it is allocated by a later `r = itself.allocate(...)`, which the region
            // rules already police), so it is not tracked here.
            const bool deferred = vd->init == nullptr && declType != "region";
            bool heapObj = false;
            if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get()))
                heapObj = nw->location == "heap";
            declareLocal(vd->name, LocalVar{declType.empty() ? std::string("int") : declType,
                                            vd->isMutable, stackObj, heapObj, deferred});
            if (deferred) {
                init_[vd->name] = FlowFacts::Init::Uninit;
            } else {
                init_.erase(vd->name);
                // Redeclaring a name (a fresh scope) must not inherit the old one's proof.
                killProofsFor(vd->name);
                // An initializer that is itself non-null proves the variable non-null right away --
                // this is what makes `nullable T* p = &thing;` usable without a redundant check.
                //
                // Uses the type computed ABOVE rather than calling typeOf again: typeOf has side effects
                // (it records moves and reports errors), so re-typing the initializer made `Handle b =
                // move a;` report `a` as used-after-move -- against the very move that statement was.
                if (!initType.empty() && initType != "null" && !isNullableType(initType))
                    nonNull_.insert(vd->name);
            }
        }
        // Remember a region's accepts/rejects constraints, keyed by variable.
        if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(vd->init.get())) {
            regionConstraints_[vd->name] = RegionConstraints{ri->accepts, ri->rejects};
        }
        // Remember which region a `checkpoint m = mark of region R;` came from (spec 17, LDP3-1714).
        if (const auto* mk = dynamic_cast<const ast::MarkExpr*>(vd->init.get())) {
            checkpointRegion_[vd->name] = mk->region;
        }
        // Remember a local that points into a region (`T* p = new X in region R;`) so extracting the
        // OWNER of a field holding such a value can be rejected (spec 17, LDP3-1718).
        regionOf_.erase(vd->name);
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get()); nw != nullptr && !nw->region.empty())
            regionOf_[vd->name] = nw->region;
        // region-binder: a `new X` that lands in this ACTIVATION's frame names an object that dies at method
        // return. Track the local so storing a reference to it into a longer-lived location can be rejected
        // (§3). Two exclusions, and both are about where the object actually lives, not where the pointer to
        // it does:
        //
        //   `new X in region R` -- region-owned; it outlives the method and the region rules govern it.
        //   `new X() on heap`   -- heap-owned; the POINTER dies at return, the OBJECT lives until `delete`.
        //
        // The second one was missing, and it is why this analysis had to stay switched off: `Node* n = new
        // Node(v) on heap; this.top = n;` -- the first two lines of every linked structure ever written --
        // was reported as a dangling store. Storing a heap object into a longer-lived field is not an
        // escape, it is the ownership transfer the whole idiom is made of. A heap object that IS deleted in
        // this method and then stored is a use-after-free, which the flow machine already catches by name.
        //
        // Aliasing propagates the tag (`var y = x` / `var y = move x`): an alias to (or the new owner of) an
        // activation-owned object is itself activation-scoped, so the escape check can't be dodged through it.
        if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(vd->init.get()))
            lambdaLocals_[vd->name] = lam;   // `function<void> work = lambda[...]` -> track for the §14 check
        else lambdaLocals_.erase(vd->name);
        activationOwned_.erase(vd->name);
        if (const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
            nw != nullptr && nw->region.empty() && nw->location != "heap") {
            activationOwned_.insert(vd->name);
        } else if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(vd->init.get());
                   aid != nullptr && activationOwned_.count(aid->name) > 0) {
            activationOwned_.insert(vd->name);
        } else if (const auto* amv = dynamic_cast<const ast::MoveExpr*>(vd->init.get())) {
            if (const auto* mid = dynamic_cast<const ast::IdentifierExpr*>(amv->operand.get());
                mid != nullptr && activationOwned_.count(mid->name) > 0)
                activationOwned_.insert(vd->name);
        }
        if (vd->init) checkOwnershipAssign(declType, *vd->init, vd->loc, "this declaration");
        return;
    }
    if (const auto* assign = dynamic_cast<const ast::AssignStmt*>(&stmt)) {
        // spec 17 LDP3-1718: track a local / `obj.field` (re)assigned a region-allocated object, so
        // extracting/deleting the owner of a same-region field can be flagged. Any other assignment to
        // the path clears it.
        {
            std::string path;
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get()))
                path = id->name;
            else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get()))
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get()))
                    path = oid->name + "." + mem->member;
            if (!path.empty()) {
                regionOf_.erase(path);
                if (const auto* nw = dynamic_cast<const ast::NewExpr*>(assign->value.get());
                    nw != nullptr && !nw->region.empty())
                    regionOf_[path] = nw->region;
                // A region assigned to a FIELD keeps its accepts/rejects, exactly as a local does --
                // and they are kept at CLASS scope, because that is where the region lives. The
                // per-method map is cleared between methods, which is right for a local (it cannot
                // outlive its declaring method) and would erase this before the first method that
                // allocates into it ever ran. A region is typed always; one that accepted anything
                // because of where it happened to be stored was not a region.
                if (const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(assign->value.get())) {
                    regionConstraints_[path] = RegionConstraints{ri->accepts, ri->rejects};
                    if (path.rfind("this.", 0) == 0 && !currentClass_.empty())
                        fieldRegionConstraints_[currentClass_ + "." + path.substr(5)] =
                            RegionConstraints{ri->accepts, ri->rejects};
                }
            }
        }
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
        // region-binder ESCAPE CHECK (§3): storing a plain reference to an activation-owned object (a
        // `new`-here local, or an alias/move of one) into a field of something that OUTLIVES this method
        // would dangle at return. The target outlives the activation when its base object is not itself
        // activation-owned -- `this`, a parameter, a static, or an alias to an outer object. Storing into a
        // fellow activation-owned object (same lifetime) is fine. `x = move y` (a MoveExpr, not a bare
        // identifier) transfers ownership and is always allowed.
        if (regionBinder_)
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get()))
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                    oid != nullptr && activationOwned_.count(oid->name) == 0)  // target outlives the method
                    if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(assign->value.get());
                        rid != nullptr && activationOwned_.count(rid->name) > 0 &&
                        // only a POINTER/REFERENCE field aliases the object; a value field deep-copies it and
                        // cannot dangle. Gate on the field being T*/T& (isRefType).
                        isRefType(fieldTypeOf(*mem))) {
                        const std::string tgt = oid->name == "this" ? "this" : ("'" + oid->name + "'");
                        error("region-binder: storing a reference to the method-local object '" + rid->name +
                                  "' into " + tgt + "'s field '" + mem->member + "', which outlives it, "
                                  "would dangle when '" + rid->name + "' is freed; transfer ownership with "
                                  "'move' (= move " + rid->name + ")",
                              assign->loc);
                    }
        const std::string vt = typeOf(*assign->value);
        checkAssignTarget(*assign->target, vt, assign->loc, assign->value.get());
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(assign->target.get())) {
            moved_.erase(id->name);  // reassignment reactivates the variable
            activationOwned_.erase(id->name);  // reassigned: no longer the tracked activation-owned object
            extracted_.erase(id->name);  // ... including after an `x = extract x from region R;`
            const LocalVar* var = lookupLocal(id->name);
            if (var != nullptr) checkOwnershipAssign(var->type, *assign->value, assign->loc, "this assignment");
        } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(assign->target.get())) {
            // A FIELD is an assignment target too. The ownership rules lived only on the two
            // narrowest paths -- a local's declaration and a local's reassignment -- so `movable`
            // meant "you must write move" for a variable and nothing at all for a field, which is
            // the place ownership actually matters, since a field is what outlives the method.
            const std::string ft = fieldTypeOf(*mem);
            if (!ft.empty())
                checkOwnershipAssign(ft, *assign->value, assign->loc,
                                     "field '" + mem->member + "'");
            // `this.f = ...` inside a constructor discharges the obligation to give `f` a value. Only
            // through `this`: assigning some OTHER object's field of the same name says nothing about
            // ours, and matching on the name alone would silently accept a constructor that initialises
            // its argument instead of itself.
            // Walk down to the ROOT of the chain: `this.cap.x = x` initialises `cap`, field by field,
            // and is the ordinary way to fill a value-struct field. Marking only on a direct
            // `this.<name>` would report `cap` as unset in a constructor that plainly sets it -- and a
            // check that rejects correct code gets switched off rather than obeyed.
            if (inConstructor_) {
                const ast::MemberExpr* root = mem;
                while (const auto* outer = dynamic_cast<const ast::MemberExpr*>(root->object.get()))
                    root = outer;
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(root->object.get());
                    oid != nullptr && oid->name == "this")
                    markInitialized("this." + root->member);
            }
        }
        return;
    }
    if (const auto* incdec = dynamic_cast<const ast::IncDecStmt*>(&stmt)) {
        checkIncDecTarget(*incdec->target, incdec->isIncrement, incdec->loc);
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
        // The branch is where the flow machine earns itself. Each arm is analyzed from the SAME entry
        // state, and what survives afterwards is the join of the two -- so a proof made in one arm cannot
        // leak into code the other arm reaches.
        const FlowFacts entry = snapshotFlow();

        // A condition that PROVES something holds for the arm that ran because of it. `p != null` proves
        // it in the `then`; `p == null` proves it in the `else`, which is what makes the guard-clause
        // shape (`if (p == null) { return; }`) work: the proof lands on the continuation.
        std::string provenThen, provenElse;
        proofFromCondition(*ifs->cond, provenThen, provenElse);

        if (!provenThen.empty()) nonNull_.insert(provenThen);
        analyzeBlock(ifs->thenBlock);
        const FlowFacts afterThen = snapshotFlow();
        const bool thenExits = blockAlwaysExits(ifs->thenBlock);

        restoreFlow(entry);
        if (!provenElse.empty()) nonNull_.insert(provenElse);
        if (ifs->elseBlock) analyzeBlock(*ifs->elseBlock);
        const FlowFacts afterElse = snapshotFlow();
        const bool elseExits = ifs->elseBlock != nullptr && blockAlwaysExits(*ifs->elseBlock);

        // An arm that always exits (return/throw/break/continue) never reaches the code after the `if`,
        // so it contributes NOTHING to the join. That is both what makes a guard clause narrow the rest
        // of the method and what removes the ownership false positive the analysis doc calls out: a
        // branch that moved a value and then returned cannot have moved it for the code below.
        if (thenExits && elseExits) {
            restoreFlow(afterThen);
        } else if (thenExits) {
            restoreFlow(afterElse);
        } else if (elseExits) {
            restoreFlow(afterThen);
        } else {
            joinFlow(afterThen, afterElse);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(&stmt)) {
        const std::string subjType = typeOf(*ms->subject);
        const std::string subjBaseM = baseType(subjType);
        const auto subjDollarM = subjBaseM.find('$');
        for (const ast::MatchCase& c : ms->cases) {
            // A bare case name (Ok) on a monomorphized sealed subject (Result$int$int) may name the
            // matching instantiation (Ok$int$int) -- but a non-generic concrete subclass of a generic
            // base (class Leaf extends Base<int>) is just `Leaf`, not `Leaf$int`. Prefer the suffixed
            // instantiation when it exists, else fall back to the bare name.
            std::string caseType = c.typeName;
            if (subjDollarM != std::string::npos) {
                const std::string suffixed = c.typeName + subjBaseM.substr(subjDollarM);
                if (lookupClass(suffixed) != nullptr) caseType = suffixed;
            }
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
        // The body may not run at all, and it may run again -- so a proof it establishes survives
        // neither. What it INITIALIZES is different: a second pass cannot un-assign a variable, but a
        // zero-pass loop means we cannot claim it was assigned either, so the entry state stands.
        const FlowFacts entry = snapshotFlow();
        std::string provenBody, unused;
        proofFromCondition(*ws->cond, provenBody, unused);
        if (!provenBody.empty()) nonNull_.insert(provenBody);
        analyzeBlock(ws->body);
        invalidateAcrossBackEdge(entry);
        restoreFlow(entry);
        return;
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&stmt)) {
        // A do-while body always runs once, so what it initializes really is initialized afterwards.
        const FlowFacts entry = snapshotFlow();
        analyzeBlock(dw->body);
        invalidateAcrossBackEdge(entry);
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
        // Same as `while`: zero iterations is possible, so nothing the body establishes escapes it.
        const FlowFacts entry = snapshotFlow();
        analyzeBlock(fs->body);
        invalidateAcrossBackEdge(entry);
        restoreFlow(entry);
        popScope();
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&stmt)) {
        // LDP3-1720: `extract` transfers ownership to its result, so a bare `extract ...;` statement leaks
        // the object it just relocated. Its result must be bound to a variable or field.
        if (dynamic_cast<const ast::ExtractExpr*>(es->expr.get()) != nullptr)
            error("an extract result must be bound to a variable or field (spec 17): "
                  "write `T* out = extract ...;`, or use `delete X from region R;` to just destroy it",
                  es->expr->loc);
        typeOf(*es->expr);
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(&stmt)) {
        if (rs->value) {
            const std::string vt = typeOf(*rs->value);
            // Null safety (spec 3.7): a null/nullable value may not be returned where the declared
            // return type is non-nullable.
            if (!vt.empty() && !currentReturnType_.empty() && !isNullableType(currentReturnType_) &&
                (vt == "null" || isNullableType(vt))) {
                error("cannot return " + std::string(vt == "null" ? "null" : "a nullable value") +
                          " from a method declared 'returns " + currentReturnType_ +
                          "': that type is non-nullable" +
                          (vt == "null"
                               ? std::string(". Return a real value, or declare it 'returns nullable " +
                                             currentReturnType_ + "' if the caller must handle absence")
                               : std::string(". A direct null test on a NAME narrows it -- after "
                                             "`if (x == null) { return ...; }` a plain `return x;` "
                                             "compiles with no cast. This value's test was not a shape "
                                             "the compiler reads (a field, a call result, a cleverer "
                                             "condition), so state the check with 'cast<" +
                                             currentReturnType_ + ">(...)', which is verified at runtime")),
                      rs->loc);
            } else if (!vt.empty() && !currentReturnType_.empty() && vt != "null" &&
                       currentReturnType_ != "void" && !isSubtype(vt, currentReturnType_) &&
                       !intLiteralFits(*rs->value, currentReturnType_)) {
                // TYPE of the returned value (LDP3-0303). Only nullability was checked here, so
                // `return someDog;` from a method `returns Cat` produced valid IR and reinterpreted the
                // object -- vtable pointer included -- because every class is an opaque `ptr` at the LLVM
                // level. A language that verifies `cast<T>` at runtime had its guard facing the wrong way.
                //
                // The same pair of conditions the assignment check uses, deliberately: `isSubtype` for the
                // relation and `intLiteralFits` so an untyped literal still adapts to the declared type
                // (`return 0;` from a method returning `byte` stays legal, exactly as `byte b = 0;` is).
                error("cannot return a value of type '" + vt + "' from a method returning '" +
                          currentReturnType_ + "'",
                      rs->loc);
            }
            // region-binder ESCAPE BY RETURN (§8). The gap this analysis was named for and did not
            // close: `Point* make() { Point p = new Point() on stack; return &p; }` compiled clean in
            // every configuration, INCLUDING with the binder switched on. Chapter 5 promises the
            // opposite in as many words, so this was the most explicit unkept promise in the language.
            //
            // The rule is the same one the field-store check uses, pointed at the return slot: an
            // object that lives in this activation's frame cannot leave through a pointer or a
            // reference, because the frame goes away the instant the caller has it. A heap object is
            // not caught -- its pointer dies here, its storage does not -- which is exactly the
            // factory idiom and has to keep working.
            // A return is the fourth destination: the value lands in the caller. Same rules.
            if (!currentReturnType_.empty() && currentReturnType_ != "void")
                checkOwnershipAssign(currentReturnType_, *rs->value, rs->loc, "this return");
            // spec 19.6: `returns move T` hands ownership out, and the return says so.
            if (currentReturnIsMove_ &&
                dynamic_cast<const ast::MoveExpr*>(rs->value.get()) == nullptr) {
                error("this method is declared 'returns move " + currentReturnType_ +
                          "', so it gives up ownership: write 'return move ...'",
                      rs->loc);
            }
            if (regionBinder_ && isRefType(currentReturnType_)) {
                if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(rs->value.get());
                    rid != nullptr && activationOwned_.count(rid->name) > 0) {
                    error("region-binder: returning '" + rid->name +
                              "', which names an object living in this method's own frame; the frame "
                              "is gone by the time the caller reads it. Allocate it with 'on heap' so "
                              "it outlives the call, or return it by value so the caller gets a copy",
                          rs->loc);
                }
            }
        }
        return;
    }
    if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(&stmt)) {
        if (ys->value == nullptr) return;
        const std::string vt = typeOf(*ys->value);  // `yield expr;` (spec 16.2 / 22.6)
        // In a generator (spec 22.6) the yielded value is an element of the Iterator<T> it produces.
        if (!currentGenElem_.empty() && !vt.empty() && !isSubtype(vt, currentGenElem_))
            error("cannot yield a '" + vt + "' from a generator producing 'Iterator<" +
                      currentGenElem_ + ">'",
                  ys->loc);
        return;
    }
    if (const auto* asmS = dynamic_cast<const ast::AsmStmt*>(&stmt)) {
        // Inline assembly (spec issue 1). Its operands are ordinary expressions and must resolve -- so a
        // typo in `in (v)` is a compile error, not a mystery at assembly time. An `out (...)` operand is
        // written by the asm, so it must be an assignable lvalue.
        for (const ast::ExprPtr& i : asmS->inputs) typeOf(*i);
        for (const ast::ExprPtr& o : asmS->outputs) checkAssignTarget(*o, typeOf(*o), o->loc, nullptr);
        // And now the BODY.
        //
        // Until this, the body went to the assembler unread -- which made `asm` the one construct in
        // LDP3 where arbitrary code could live, and the only place a mistake was neither caught nor
        // catchable. The block already names its architecture and dialect; that information was being
        // collected and then thrown away. See asmcheck.h for what is checked and, as importantly, what
        // is deliberately not.
        semantic::AsmDeclared decl;
        decl.arch = asmS->arch;
        decl.dialect = asmS->dialect;
        decl.outputCount = static_cast<int>(asmS->outputs.size());
        decl.inputCount = static_cast<int>(asmS->inputs.size());
        decl.clobbers = asmS->clobbers;
        decl.inNakedFunction = inNakedFn_;
        const semantic::AsmReport report = semantic::checkAsm(asmS->body, decl);
        for (const semantic::AsmFinding& f : report.findings) {
            const std::string where = " (asm line " + std::to_string(f.line) + ")";
            if (f.severity == semantic::AsmFinding::Severity::Error) error(f.message + where, asmS->loc);
            else warn(f.message + where, asmS->loc);
        }
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(&stmt)) {
        auto checkTarget = [&](const ast::Expr& target) {
            const std::string t = typeOf(target);
            // `delete p` where p is a class, or a pointer/reference to one (see through T*/T&). Try the
            // full type too, not only baseType: a generic instantiated with a pointer type argument mangles
            // to a name that ends in '*' (e.g. `ArrayList$Node*` for ArrayList<Node*>), which baseType would
            // wrongly strip -- but the class is registered under the full name, so `delete` must accept it.
            if (!t.empty() && lookupClass(baseType(t)) == nullptr && lookupClass(t) == nullptr &&
                !isArrayType(t)) {
                error("'delete' expects a heap object or array; got a value of type '" + t + "'",
                      del->loc);
            }
            // A deleted variable may be redeclared with the same name, reattaching its persistents
            // (spec 18.2). Record it so the redeclaration is allowed -- and so a later READ of it is
            // caught as a use-after-free.
            //
            // ... but only where the delete actually FREES something. `delete v` on a value-form type
            // (a `Result<int,int>` held by value rather than `Result<int,int>*`) owns no heap and is a
            // documented no-op, so the variable stays perfectly readable and flagging it would be wrong.
            // The line is exactly whether the name denotes a reference to a heap object.
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&target)) {
                deleted_.insert(id->name);   // spec 18.2: the name may be redeclared either way
                const LocalVar* lv = lookupLocal(id->name);
                if (isRefType(t) || isArrayType(t) || (lv != nullptr && lv->isHeapObject))
                    freed_.insert(id->name);
            }
        };
        checkTarget(*del->target);
        for (const auto& mt : del->moreTargets) checkTarget(*mt);
        // `delete X from region R` on a ring region is rejected -- a ring auto-evicts (LDP3-1715).
        if (!del->fromRegion.empty() &&
            (regionFlavor_.count(del->fromRegion) ? regionFlavor_[del->fromRegion] : std::string()) ==
                "ring")
            error("a ring region auto-evicts; individual delete is not allowed on '" + del->fromRegion +
                      "' (spec 17)",
                  del->loc);
        return;
    }
    if (const auto* rel = dynamic_cast<const ast::ReleaseStmt*>(&stmt)) {
        if (rel->isPersistent) {
            // `release [persistent|eternal] obj.field;` -- record that this persistent
            // field is released somewhere, satisfying the obligation (spec 18.15).
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(rel->target.get())) {
                // `release C.field all;` names the CLASS, not an object -- there is no instance whose
                // identity is meant, because the point is every identity. Resolve the receiver as a type
                // name; typing it as an expression would report `C` as an undeclared variable.
                if (rel->allKeys) {
                    std::string cls;
                    if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get()))
                        cls = rid->name;
                    if (cls.empty() || lookupClass(cls) == nullptr) {
                        error("'release ... all' names a class and one of its persistent fields "
                              "(`release Session.hits all;`); '" +
                                  (cls.empty() ? std::string("this receiver") : "'" + cls + "'") +
                                  " is not a class in scope",
                              rel->loc);
                        return;
                    }
                    if (const std::string owner = persistentFieldOwner(cls, mem->member); !owner.empty())
                        releasedPersistents_.insert(owner + "." + mem->member);
                    else
                        error("'" + mem->member + "' is not a persistent field of '" + cls + "'",
                              rel->loc);
                    return;
                }
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
        // A `this.field` region is validated at codegen (via the field); only a plain local name is
        // resolved here (spec 17: region as a field).
        if (rel->region.find('.') == std::string::npos) {
            const LocalVar* r = lookupLocal(rel->region);
            if (r == nullptr) {
                error("unknown region '" + rel->region + "'", rel->loc);
            } else if (r->type != "region") {
                error("'" + rel->region + "' is not a region", rel->loc);
            }
        }
        return;
    }
    if (const auto* rb = dynamic_cast<const ast::RollbackStmt*>(&stmt)) {
        // `rollback region R to m` needs a stack region (LDP3-1713) and a checkpoint captured from that
        // same region (LDP3-1714). A `this.field` region is validated at codegen.
        if (rb->region.find('.') == std::string::npos) {
            const LocalVar* r = lookupLocal(rb->region);
            if (r == nullptr)
                error("unknown region '" + rb->region + "'", rb->loc);
            else if (r->type != "region")
                error("'" + rb->region + "' is not a region", rb->loc);
            else if ((regionFlavor_.count(rb->region) ? regionFlavor_[rb->region] : std::string()) != "stack")
                error("mark/rollback need a `stack region`, but '" + rb->region + "' is not one (spec 17)",
                      rb->loc);
        }
        const std::string ct = rb->checkpoint ? typeOf(*rb->checkpoint) : std::string();
        if (!ct.empty() && ct != "checkpoint")
            error("`rollback ... to` expects a checkpoint (from `mark of region`), not a '" + ct + "'",
                  rb->loc);
        // If the checkpoint is a plain variable, it must have been marked from THIS region (LDP3-1714).
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(rb->checkpoint.get())) {
            auto cr = checkpointRegion_.find(id->name);
            if (cr != checkpointRegion_.end() && cr->second != rb->region)
                error("this checkpoint belongs to region '" + cr->second +
                          "', not '" + rb->region + "'; roll back the region it came from",
                      rb->loc);
        }
        return;
    }
    if (const auto* um = dynamic_cast<const ast::UnimportStmt*>(&stmt)) {
        if (freestanding_)
            error("unimport/reimport is not available in freestanding mode (spec 36.3)", um->loc);
        // Namespace / bundle granularity (spec 30.1) is accepted as-is; the codegen expands it to the
        // contained types. An individual target must be a known class, interface or enum.
        if (um->granularity == 0) {
            const std::string bt = baseType(um->target);
            if (lookupClass(bt) == nullptr && enums_.count(bt) == 0)
                error("cannot " + std::string(um->isReimport ? "reimport" : "unimport") + " '" +
                          um->target + "': not a known type",
                      um->loc);
            else if (!um->isReimport && finalImports_.count(bt) > 0)
                error("cannot unimport '" + um->target +
                          "': it was brought in by 'final import' (spec 37.6)",
                      um->loc);
        }
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
        if (def->within != nullptr) {  // spec 32.10: the cleanup's time budget
            const std::string t = baseType(typeOf(*def->within));
            if (t != "Duration" && !isIntName(t) && !t.empty()) {
                error("'defer within' expects a Duration or a millisecond count, got '" + t + "'",
                      def->within->loc);
            }
        }
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
        // A catch runs BECAUSE the try failed, and it can fail anywhere -- at the first statement or the
        // last. So a catch body must be analyzed from the state at try ENTRY, not from the state the try
        // body left behind: the try's work may not have happened at all. Analyzing them in sequence made
        // the stdlib's own `try { delete ch; } catch { delete ch; }` look like a use-after-free, which is
        // correct code and was the first thing the new check reported.
        const FlowFacts beforeTry = snapshotFlow();
        analyzeBlock(tr->body);
        const FlowFacts afterTry = snapshotFlow();
        catchStack_.pop_back();
        for (const ast::CatchClause& cc : tr->catches) {
            restoreFlow(beforeTry);
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
        // After the whole statement, only what the try body established can be relied on -- a catch that
        // fell through contributes its own state, but the conservative and correct thing for `finally`
        // and the code below is the try's outcome, since that is the path that did not throw.
        restoreFlow(afterTry);
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
                                    const std::string& desc,
                                    const std::vector<bool>* moveParams) {
    for (std::size_t i = 0; i < args.size(); ++i) {
        const std::string at = typeOf(*args[i]);
        if (i >= paramTypes.size()) continue;
        const std::string& pt = paramTypes[i];
        // spec 19.6: `move T` in the signature demands `move` at the call. The whole argument for
        // the verbosity is that reading the CALL tells you ownership changed hands, without going to
        // look at the declaration -- so a `move` parameter passed plainly defeats the only thing the
        // annotation is for. It parsed and meant nothing until now: `isMove` existed in exactly two
        // places in the compiler, the field and the line the parser wrote it on.
        if (moveParams != nullptr && i < moveParams->size() && (*moveParams)[i] &&
            dynamic_cast<const ast::MoveExpr*>(args[i].get()) == nullptr) {
            const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(args[i].get());
            error("parameter " + std::to_string(i + 1) + " of " + desc +
                      " is declared 'move " + pt +
                      "', so the call has to say so: pass 'move " +
                      (aid != nullptr ? aid->name : std::string("value")) +
                      "'. The name is finished after the call",
                  args[i]->loc);
        }
        if (at.empty() || pt.empty()) continue;
        if (!isNullableType(pt) && (at == "null" || isNullableType(at))) {
            // The part a reader cannot guess: a direct null test on a NAME narrows the type, but a test of a
            // field or of a call result does not -- so someone who "already checked" can still land here,
            // and will otherwise conclude the compiler is broken rather than that it wants the cast.
            error("argument " + std::to_string(i + 1) + " to " + desc + " is " +
                      std::string(at == "null" ? "null" : "'" + at + "', which is nullable") +
                      ", but the parameter type '" + pt + "' is non-nullable" +
                      (at == "null"
                           ? std::string(". Pass a real value, or declare the parameter 'nullable " + pt +
                                         "' if absence is meaningful to it")
                           : std::string(". A direct null test on a NAME narrows it -- after "
                                         "`if (p == null) { return; }` you pass `p` as-is, no cast. This "
                                         "value's test was not a shape the compiler reads (a field, a call "
                                         "result, a cleverer condition), so state the check with 'cast<" +
                                         pt + ">(...)', which is verified at runtime")),
                  args[i]->loc);
        } else if (!isSubtype(at, pt)) {
            error("argument " + std::to_string(i + 1) + " to " + desc + " has type '" + at +
                      "' but the parameter type is '" + pt + "'",
                  args[i]->loc);
        }
        // spec 19.2: passing an object that owns a `unique` field BY VALUE would copy it and alias the
        // unique, breaking its single-owner guarantee (the same reason a value assignment is rejected --
        // see checkOwnershipAssign). Reject it for a by-value parameter; a fresh temporary or an explicit
        // `move` is fine, and a pointer/reference parameter shares rather than copies.
        // A by-value parameter is a destination like any other, so it goes through the one place the
        // ownership rules live rather than the near-copy that used to be inlined here -- a copy that
        // handled `unique` and skipped `movable` entirely, which is half the feature.
        checkOwnershipAssign(pt, *args[i], args[i]->loc, "the parameter of " + desc);
    }
}

// A compile-time constant argument (spec 32.4): a literal, or a numeric expression the comptime
// evaluator can fold (a const or a `comptime` method call over constants).
bool SemanticAnalyzer::isConstArg(const ast::Expr& e) {
    if (dynamic_cast<const ast::StringLiteralExpr*>(&e) ||
        dynamic_cast<const ast::IntLiteralExpr*>(&e) ||
        dynamic_cast<const ast::CharLiteralExpr*>(&e) ||
        dynamic_cast<const ast::BoolLiteralExpr*>(&e) ||
        dynamic_cast<const ast::FloatLiteralExpr*>(&e))
        return true;
    long long i;
    double d;
    return evalConstInt(e, i, &constInts_, &comptimeMethods_, &constDoubles_) ||
           evalConstDouble(e, d, &constDoubles_, &constInts_, &comptimeMethods_);
}

void SemanticAnalyzer::checkComptimeArgs(const std::vector<ast::ExprPtr>& args,
                                         const std::vector<bool>& comptimeParams,
                                         const std::string& desc) {
    for (std::size_t i = 0; i < args.size() && i < comptimeParams.size(); ++i)
        if (comptimeParams[i] && !isConstArg(*args[i]))
            error("argument " + std::to_string(i + 1) + " to " + desc +
                      " must be a compile-time constant ('comptime' parameter, spec 32.4)",
                  args[i]->loc);
}

// Named arguments (spec 22.4). Rewrites `call->args` into declared parameter order, so every later stage
// (type checking, codegen) only ever sees positional arguments, and enforces the rules:
//   - a name must match a parameter, and no parameter may be bound twice;
//   - positional arguments come first (once you name one, the rest must be named);
//   - a `requires named` parameter cannot be passed positionally;
//   - every parameter must end up bound.
// A call with no names and no `requires named` parameter is left untouched (the common path).
void SemanticAnalyzer::bindNamedArgs(ast::CallExpr* call, const std::vector<std::string>& paramNames,
                                     const std::vector<bool>& namedOnly, const std::string& desc) {
    if (call == nullptr || call->argsBound || paramNames.empty()) return;
    const bool anyNamed = std::any_of(call->argNames.begin(), call->argNames.end(),
                                      [](const std::string& n) { return !n.empty(); });
    const bool anyNamedOnly = std::any_of(namedOnly.begin(), namedOnly.end(), [](bool b) { return b; });
    if (!anyNamed && !anyNamedOnly) return;                       // ordinary positional call: nothing to do
    if (call->args.size() != call->argNames.size()) return;       // synthesized call: nothing to bind
    if (call->args.size() != paramNames.size()) return;           // arity error is reported elsewhere
    // The analyzer may type a call more than once (overload probing, generic instantiation), so bind exactly
    // once. Validate everything BEFORE moving anything, so a rejected call leaves the AST intact.
    call->argsBound = true;

    std::vector<std::size_t> slotOf(call->args.size(), 0);   // arg i -> parameter slot
    std::vector<bool> filled(paramNames.size(), false);
    bool sawNamed = false;
    for (std::size_t i = 0; i < call->args.size(); ++i) {
        const std::string& n = call->argNames[i];
        if (n.empty()) {
            if (sawNamed) {
                error("positional argument after a named one in a call to " + desc +
                          " (spec 22.4: once an argument is named, the rest must be too)",
                      call->args[i]->loc);
                return;
            }
            if (i < namedOnly.size() && namedOnly[i]) {
                error("parameter '" + paramNames[i] + "' of " + desc +
                          " is 'requires named': pass it as '" + paramNames[i] + ": <value>' (spec 22.4)",
                      call->args[i]->loc);
                return;
            }
            slotOf[i] = i;
            filled[i] = true;
            continue;
        }
        sawNamed = true;
        const auto it = std::find(paramNames.begin(), paramNames.end(), n);
        if (it == paramNames.end()) {
            error(desc + " has no parameter named '" + n + "'", call->args[i]->loc);
            return;
        }
        const std::size_t slot = static_cast<std::size_t>(it - paramNames.begin());
        if (filled[slot]) {
            error("argument '" + n + "' passed twice to " + desc, call->args[i]->loc);
            return;
        }
        slotOf[i] = slot;
        filled[slot] = true;
    }
    for (std::size_t s = 0; s < filled.size(); ++s) {
        if (!filled[s]) {
            error("no argument for parameter '" + paramNames[s] + "' of " + desc, call->loc);
            return;
        }
    }
    if (!anyNamed) return;   // only the `requires named` rule applied; the order is already positional
    std::vector<ast::ExprPtr> bound(paramNames.size());
    for (std::size_t i = 0; i < call->args.size(); ++i) bound[slotOf[i]] = std::move(call->args[i]);
    call->args = std::move(bound);
    call->argNames.assign(call->args.size(), std::string());   // now purely positional
}

std::string SemanticAnalyzer::typeOf(const ast::Expr& expr) {
    if (const auto* il = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
        // A literal WRITTEN with more than 32 bits of digits is 64-bit, whatever signed value it
        // happens to equal -- so `int m = 0xFFFFFFFFFFFFF000;` is the error it should be instead of a
        // silent truncation. Codegen agrees (see intLiteralNeeds64).
        return ldp3::ast::intLiteralNeeds64(il->text) ? "long" : "int";
    }
    if (const auto* fl = dynamic_cast<const ast::FloatLiteralExpr*>(&expr))
        return fl->isDecimal ? "Decimal" : "double";
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) return "char";
    if (const auto* sl = dynamic_cast<const ast::StringLiteralExpr*>(&expr))
        return sl->isBytes ? "byte*" : "String";   // b"..." is the raw bytes
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) return "boolean";
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) return "null";
    if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
        std::string s = "function<" + typeRefStr(lam->returnType);
        for (const auto& p : lam->params) s += "," + typeRefStr(p.type);
        // ...and CHECK THE BODY. It used to build this signature and return, so a lambda body was a
        // blind spot the size of every callback in the language: Thread bodies, collection
        // predicates, FFI trampolines. Anything at all could be written in one -- a call to a method
        // that does not exist, a return of the wrong type, a name never declared -- and the front
        // end would hand it to codegen, which assumes a valid AST.
        //
        // Analyzed HERE rather than deferred, because a lambda captures the enclosing locals and
        // this is the only moment they are in scope. The lambda's own return type replaces the
        // enclosing method's for the duration so `return` inside it is checked against the right
        // thing, and every flow fact that names a local is saved and restored -- a lambda body is a
        // separate flow of control, and letting its `delete x` mark the enclosing method's `x` as
        // freed would be the same cross-contamination that once failed 51 tests on one variable name.
        if (!analyzingLambda_) {
            analyzingLambda_ = true;
            const std::string savedReturn = currentReturnType_;
            const bool savedReturnMove = currentReturnIsMove_;
            auto savedMoved = moved_, savedFreed = freed_, savedDeleted = deleted_;
            auto savedNonNull = nonNull_, savedActivation = activationOwned_;
            auto savedInit = init_;
            currentReturnType_ = typeRefStr(lam->returnType);
            currentReturnIsMove_ = false;
            // The parameter types `itself(...)` is checked against -- the lambda has no name to look
            // its own signature up by, so the signature has to be carried here while its body runs.
            auto savedLambdaParams = currentLambdaParams_;
            currentLambdaParams_.clear();
            for (const ast::Param& p : lam->params)
                currentLambdaParams_.push_back(typeRefStr(p.type));
            pushScope();
            for (const ast::Param& p : lam->params)
                declareLocal(p.name, LocalVar{typeRefStr(p.type), false});
            for (const auto& st : lam->body.statements) analyzeStatement(*st);
            popScope();
            currentLambdaParams_ = std::move(savedLambdaParams);
            currentReturnType_ = savedReturn;
            currentReturnIsMove_ = savedReturnMove;
            moved_ = std::move(savedMoved);
            freed_ = std::move(savedFreed);
            deleted_ = std::move(savedDeleted);
            nonNull_ = std::move(savedNonNull);
            activationOwned_ = std::move(savedActivation);
            init_ = std::move(savedInit);
            analyzingLambda_ = false;
        }
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
            error(diag::Code::UndeclaredVariable,
                  "use of undeclared variable '" + id->name + "'" + didYouMean(id->name, namesInScope()),
                  id->loc);
            return "";
        }
        if (auto ex = extracted_.find(id->name); ex != extracted_.end()) {
            error("variable '" + id->name + "' was extracted from its region (line " +
                      std::to_string(ex->second) + ") and cannot be used again; use the value extract "
                      "returned",
                  id->loc);
        } else if (moved_.count(id->name) > 0) {
            error("use of variable '" + id->name +
                      "' after it was moved (reassign it before using)",
                  id->loc);
        } else if (freed_.count(id->name) > 0) {
            // USE AFTER FREE, caught at compile time. The machinery was already here -- `deleted_` was
            // populated by every `delete` and read only to permit redeclaring the name -- so the trap the
            // guide promises (05:768) was one condition away the whole time.
            error("use of variable '" + id->name +
                      "' after it was deleted: the object it named is gone, and reading the variable "
                      "reads freed memory. Redeclare the name with a new object if you meant to reuse "
                      "it (spec 18.2), or move the `delete` after this use",
                  id->loc);
        } else if (const FlowFacts::Init st = initStateOf(id->name); st != FlowFacts::Init::Init) {
            // Definite assignment. The two states get different messages because they are different
            // mistakes: never assigned at all, versus assigned on only one path through a branch.
            error(st == FlowFacts::Init::Uninit
                      ? "variable '" + id->name +
                            "' is used before it is initialized. It was declared without a value, which "
                            "leaves it in the uninitialized state -- not null, not zero, no value at "
                            "all -- so assign to it before reading it"
                      : "variable '" + id->name +
                            "' may be used before it is initialized: some paths to this point assign it "
                            "and others do not. Assign it on every path (an `else` branch, or a default "
                            "before the branch) so it holds a value however control got here",
                  id->loc);
        }
        // NARROWING. A name proven non-null here reports the non-nullable type, so every consumer --
        // argument passing, `return`, field assignment -- sees the proof without any of them knowing the
        // proof exists. The proof is only ever recorded where nothing can falsify it (see killProofsFor
        // and invalidateAcrossBackEdge), so this cannot claim more than the compiler actually knows.
        if (!suppressNarrowing_ && isNullableType(var->type) && nonNull_.count(id->name) > 0)
            return ast::stripNullable(var->type);
        return var->type;
    }

    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
        if (freestanding_)
            error("async/await is not available in freestanding mode (spec 36.3)", aw->loc);
        // await ch.receive() (spec 20.7): a channel receive already blocks for the value, so `await`
        // is a passthrough and yields the element type.
        if (const auto* call = dynamic_cast<const ast::CallExpr*>(aw->operand.get()))
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get()))
                if (mem->member == "receive" && call->args.empty() &&
                    baseType(typeOf(*mem->object)).rfind("Channel$", 0) == 0)
                    return typeOf(*aw->operand);
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
        typeOf(*rng->start);  // a range over int (spec 7.5)
        typeOf(*rng->end);
        if (rng->step) typeOf(*rng->step);
        return "Range";  // a first-class Range value; foreach over a literal range is handled separately
    }
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string t = typeOf(*un->operand);
        if (un->op == "&") {
            // A packed bit field HAS NO ADDRESS (spec 11.1). It occupies a range of bits inside a unit
            // it shares with its neighbours, and the smallest thing a pointer can name is a byte. The
            // only address that could be handed back is the unit's, which would let a write through it
            // destroy every field packed beside this one -- silently, and nowhere near the `&`.
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(un->operand.get())) {
                const std::string owner = baseType(typeOf(*mem->object));
                if (const FieldInfo* fi = findField(owner, mem->member);
                    fi != nullptr && fi->bitWidth > 0)
                    error("cannot take the address of '" + mem->member + "': it is a " +
                          std::to_string(fi->bitWidth) + "-bit field packed into a storage unit it "
                          "shares with the fields declared next to it, so it has no address of its "
                          "own. Copy it into a local and take the address of that",
                          un->loc);
            }
            return t.empty() ? std::string() : t + "*";  // address-of: T -> T*
        }
        if (un->op == "*") {  // pointer dereference: T* -> T (peel one '*')
            if (!t.empty() && t.back() != '*')
                error("cannot dereference '" + t + "': it is not a pointer", un->loc);
            return (t.empty() || t.back() != '*') ? std::string() : t.substr(0, t.size() - 1);
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
            // Map a bare case name to the subject's instantiation (Ok -> Ok$int$int) when that exists;
            // fall back to the bare name for a non-generic concrete subclass (Leaf extends Base<int>).
            std::string caseType = c.typeName;
            if (subjDollarM != std::string::npos) {
                const std::string suffixed = c.typeName + subjBase.substr(subjDollarM);
                if (lookupClass(suffixed) != nullptr) caseType = suffixed;
            }
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
    if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(&expr)) {
        // `extract X from region R` (spec 17): the region must exist; the object type is the result type
        // (an owning pointer to the relocated object). The source variable is spent afterwards (like move).
        const std::string t = typeOf(*ex->target);  // also checks the target's first (valid) use
        if (ex->region.find('.') == std::string::npos) {  // a `this.field` region is validated at codegen
            const LocalVar* r = lookupLocal(ex->region);
            if (r == nullptr)
                error("unknown region '" + ex->region + "' in extract", ex->loc);
            else if (r->type != "region")
                error("'" + ex->region + "' is not a region", ex->loc);
        }
        // LDP3-1717: mark the source spent so a later read is rejected with the extract-specific message.
        // Only a plain variable can be flow-tracked; an element/field target is nulled at run time instead.
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(ex->target.get())) {
            // LDP3-1718: if a field of the object being extracted was allocated in the SAME region, moving
            // just the object leaves that field behind -- a dangling pointer after release. Reject it.
            const std::string prefix = id->name + ".";
            for (const auto& [path, rgn] : regionOf_)
                if (rgn == ex->region && path.rfind(prefix, 0) == 0) {
                    error("cannot extract '" + id->name + "': its field '" + path.substr(prefix.size()) +
                              "' lives in the same region '" + ex->region +
                              "' -- extract the graph (cascade move) or allocate the field elsewhere",
                          ex->loc);
                    break;
                }
            extracted_[id->name] = ex->loc.line;
            moved_.insert(id->name);
            regionOf_.erase(id->name);  // the object left the region; its recorded fields are stale
        }
        return t;
    }
    if (const auto* mk = dynamic_cast<const ast::MarkExpr*>(&expr)) {
        // `mark of region R` yields a `checkpoint`; mark/rollback need a `stack region` (LDP3-1713).
        // A `this.field` region is validated at codegen (spec 17: region as a field).
        if (mk->region.find('.') == std::string::npos) {
            const LocalVar* r = lookupLocal(mk->region);
            if (r == nullptr)
                error("unknown region '" + mk->region + "' in mark", mk->loc);
            else if (r->type != "region")
                error("'" + mk->region + "' is not a region", mk->loc);
            else if ((regionFlavor_.count(mk->region) ? regionFlavor_[mk->region] : std::string()) != "stack")
                error("mark/rollback need a `stack region`, but '" + mk->region + "' is not one (spec 17)",
                      mk->loc);
        }
        return "checkpoint";
    }
    if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
        // try? Result<T,E>/Option<T> yields T (the first type arg of the operand's instantiation).
        const std::string ot = baseType(typeOf(*tx->operand));
        // try? early-returns the Err/None to the ENCLOSING method, so that method must itself return a
        // Result/Option (spec 21.2). Otherwise codegen would emit a type-mismatched `return`. Take the
        // bare type name (before generic args and any pointer marker), e.g. "Result$int$int*" -> "Result".
        const std::string rtm = baseType(currentReturnType_);
        auto family = [](const std::string& mangled) {
            const auto d = mangled.find('$');
            return d == std::string::npos ? mangled : mangled.substr(0, d);
        };
        // The error payload of a `Result$T$E`, read off the monomorphized `Err$T$E`'s own `error` field
        // rather than by splitting the mangled string -- `Result<Map<int,int>, E>` mangles to
        // `Result$Map$int$int$E` and no amount of `$`-counting recovers E from that. Codegen decodes the
        // payload the same way (through the variant class, not the string), so the two phases agree by
        // construction. An unresolvable name yields "" and the check stands down: incomplete is safe.
        auto errPayload = [&](const std::string& mangled) -> std::string {
            const auto d = mangled.find('$');
            if (d == std::string::npos) return {};
            const ClassInfo* ec = lookupClass("Err" + mangled.substr(d));
            if (ec == nullptr) return {};
            const auto f = ec->fields.find("error");
            return f == ec->fields.end() ? std::string() : f->second.type;
        };
        const std::string rb = family(rtm);
        const std::string ob = family(ot);
        if (!currentReturnType_.empty() && rb != "Result" && rb != "Option") {
            error("'try?' can only be used inside a method that returns Result or Option, but this "
                  "method returns '" + currentReturnType_ + "' (spec 21.2)",
                  tx->loc);
        } else if (!currentReturnType_.empty() && (ob == "Result" || ob == "Option") && ob != rb) {
            // Propagation forwards the operand UNCHANGED -- codegen emits `CreateRet(val)` on the very
            // value it tested. A None cannot stand in for an Err (it carries no payload) and an Err
            // cannot stand in for a None (it carries one), so the two families may not be crossed.
            error("'try?' propagates the failure of an operand of type '" + ob +
                      "', but this method returns '" + rb +
                      "': the failure value is forwarded unchanged, so the two must be the same family "
                      "(spec 21.2). Match the method's return type to the operand, or convert "
                      "explicitly -- " +
                      std::string(ob == "Option"
                                      ? "a None carries no error value to put in an Err"
                                      : "an Err carries an error value that a None would discard"),
                  tx->loc);
        } else if (ob == "Result" && rb == "Result") {
            // The E half. Same reason: the Err travels out byte-for-byte, and at the LLVM level every
            // value-form Result is ONE StructType and every boxed one an opaque `ptr` -- so a mismatched
            // error type is not caught downstream by anything. It reaches the binary and is reinterpreted.
            const std::string oe = errPayload(ot);
            const std::string re = errPayload(rtm);
            if (!oe.empty() && !re.empty() && !isSubtype(oe, re))
                error("'try?' propagates a 'Result' whose error type is '" + oe +
                          "', but this method returns a 'Result' whose error type is '" + re +
                          "'. The failure value is forwarded unchanged (spec 21.2), so '" + oe +
                          "' would be reinterpreted as '" + re +
                          "'. Convert the error before propagating -- match on the operand and return an "
                          "`Err(...)` built with the '" + re + "' this method declares -- or declare it "
                          "'returns Result<..., " + oe + ">' and let the error travel as it is",
                      tx->loc);
        }
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
                // A generic constraint type (Box<?>, ArrayList<int>) names a template, not a plain
                // class; skip the plain-class existence check for those (spec 17.3, best-effort filter).
                if (t.find('<') == std::string::npos && t.find('.') == std::string::npos &&
                    lookupClass(t) == nullptr) {
                    error("region accepts/rejects references unknown type '" + t + "'", ri->loc);
                }
            }
        }
        // atMultiple ranges (spec 17.4): each range address must be numeric; its accepts/rejects types
        // must exist.
        for (const auto& r : ri->ranges) {
            const std::string at = typeOf(*r.address);
            if (!at.empty() && !isNumeric(at))
                error("region range address must be a number or address, got '" + at + "'", ri->loc);
            for (const auto& list : {r.accepts, r.rejects})
                for (const std::string& t : list)
                    if (t.find('<') == std::string::npos && t.find('.') == std::string::npos &&
                        lookupClass(t) == nullptr)
                        error("region range accepts/rejects references unknown type '" + t + "'", ri->loc);
        }
        return "region";
    }

    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        const std::string srcRaw = typeOf(*cst->operand);
        const std::string& dst = cst->targetType;
        checkBitCounted(dst, cst->loc);  // reject cast<int64> etc. outside freestanding mode
        checkWideningLostBits(*cst, srcRaw, dst);  // cast<address>(f << 12): the bits are already gone  // cast<address>(f << 12): the bits are already gone
        // A `newtype` casts to/from its underlying type (spec 24): classify both by the underlying
        // so cast<OrderId>(long) and cast<long>(orderId) are accepted while staying distinct types.
        auto under = [&](const std::string& t) {
            auto it = newtypes_.find(baseType(t));
            return it != newtypes_.end() ? it->second : t;
        };
        const std::string src = under(srcRaw);
        const bool dstRef = dst == "Object" || lookupClass(baseType(dst)) != nullptr;
        const bool srcRef = src.empty() || src == "Object" || src == "Type" || src == "Method" ||
                            lookupClass(baseType(src)) != nullptr || isRefType(src) ||
                            src.rfind("funcptr<", 0) == 0;  // a bare C fn pointer reinterprets like a ptr
        const bool dstFuncptr = dst.rfind("funcptr<", 0) == 0;  // a bare C function pointer (dynamic FFI)
        const bool dstPtr = isRefType(dst) || dstRef || dstFuncptr;  // pointer/ref target (T*, T&, class)
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
            const bool intToPtr = (isRefType(dst) || dstFuncptr) && isNumeric(src);
            if (!src.empty() && !srcRef && !intToPtr)
                error("cannot cast '" + src + "' to '" + dst + "'", cst->loc);
        } else if (enums_.count(baseType(dst)) > 0) {
            // NUMBER -> int-style enum, the reverse of the ordinal reinterpret just above.
            //
            // It was missing, and the asymmetry was the tell: `cast<int>(someEnum)` has always been
            // allowed, so an enum could be taken apart and never put back together. That is a real
            // hole for any program that reads an enumerated field out of something -- a device
            // register, a wire format, a file header -- because such a field always arrives as a
            // number.
            //
            // CHECKED, not a reinterpret (see codegen). An unchecked version would let a program
            // manufacture an enum value outside the declared set, which is a hole in the type system
            // rather than a convenience -- and this language does not convert integers silently
            // anywhere else either.
            if (!src.empty() && !numLike(src) && enums_.count(baseType(src)) == 0)
                error("cannot cast '" + srcRaw + "' to enum '" + dst + "'", cst->loc);
        } else {
            error("cast<" + dst + "> is not supported here", cst->loc);
        }
        if (cst->op == 1) return "boolean";        // `x is T` -> boolean test
        if (cst->op == 2) return ast::makeNullable(dst);   // `x as? T` -> the value or null
        return dst;                                // cast<T> / `x as T` (checked)
    }

    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        const std::string ct = typeOf(*tern->cond);
        if (!ct.empty() && ct != "boolean")
            error("ternary condition must be boolean, got '" + ct + "'", tern->loc);
        // The result type comes from BOTH arms. Reading it off `then` alone made the other arm truncate:
        // `long r = c ? 7 : big;` took `int` from the literal, and codegen -- which had the same omission,
        // so the two agreed -- emitted `trunc i64 %big to i32`. The assignment to `long` then looked like
        // an ordinary widening and nothing reported anything.
        const std::string tt = typeOf(*tern->thenExpr);
        const std::string et = typeOf(*tern->elseExpr);
        if (tt.empty() || et.empty() || tt == et) return tt.empty() ? et : tt;
        if (tt == "null" || et == "null" || isNullableType(tt) || isNullableType(et)) {
            const std::string bt = ast::stripNullable(tt), be = ast::stripNullable(et);
            if (bt == "null") return ast::makeNullable(be);
            if (be == "null") return ast::makeNullable(bt);
            return ast::makeNullable(bt);
        }
        if (isIntName(tt) && isIntName(et)) {
            // Width widens silently; SIGNEDNESS must agree, the same rule the arithmetic operators use --
            // a literal that fits the other arm adapts, exactly as it does at an assignment or a return.
            const bool tLit = intLiteralFits(*tern->thenExpr, et);
            const bool eLit = intLiteralFits(*tern->elseExpr, tt);
            if (!tLit && !eLit && ast::isUnsignedIntName(tt) != ast::isUnsignedIntName(et))
                error("the two arms of this '?:' are '" + tt + "' and '" + et +
                          "', which differ in signedness. Widening happens on its own, but mixing signed "
                          "and unsigned does not: the same bits mean different numbers. Convert one arm "
                          "explicitly -- `cast<" + tt + ">(...)` on the else-arm, or `cast<" + et +
                          ">(...)` on the then-arm -- so the result's meaning is written down",
                      tern->loc);
            if (tLit) return et;
            if (eLit) return tt;
            return intBits(tt) >= intBits(et) ? tt : et;   // the wider arm, so neither is truncated
        }
        if (isNumeric(tt) && isNumeric(et)) {
            if (tt == "double" || et == "double") return "double";
            if (tt == "float" || et == "float") return "float";
            return tt;
        }
        // Classes and everything else: one arm has to be usable as the other, or the result has no type.
        if (isSubtype(et, tt)) return tt;
        if (isSubtype(tt, et)) return et;
        error("the two arms of this '?:' have unrelated types '" + tt + "' and '" + et +
                  "', so the expression has no single type. Both arms must produce the same type, or one "
                  "that the other can stand in for -- give them a common supertype, or convert one arm",
              tern->loc);
        return tt;
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&expr)) {  // a ?? b (spec 3.7)
        const std::string lt = typeOf(*nc->lhs);
        const std::string rt = typeOf(*nc->rhs);
        const std::string base = ast::stripNullable(lt);
        // The fallback's base must be compatible with the left's base.
        if (!base.empty() && !rt.empty()) {
            const std::string rbase = ast::stripNullable(rt);
            if (rbase != "null" && !isSubtype(rbase, base) && !isSubtype(base, rbase))
                error("'??' fallback of type '" + rt + "' is incompatible with '" + lt + "'", nc->loc);
        }
        // Result is the left's non-null base, but stays nullable if the fallback can be null.
        return isNullableType(rt) ? ast::makeNullable(base) : base;
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        // A NULL TEST must see the operand un-narrowed. Testing a value the compiler has already proven
        // non-null is redundant, not wrong -- and the declaration still says `nullable`, so the
        // comparison is exactly what the author wrote. Narrowing it first turned `nullable int b = 5;
        // ... b != null` into "operator '!=' requires operands of the same type", because the narrowed
        // `int` is neither a pointer nor nullable and no longer looks comparable to null.
        const bool nullTest =
            (bin->op == "==" || bin->op == "!=") &&
            (dynamic_cast<const ast::NullLiteralExpr*>(bin->lhs.get()) != nullptr ||
             dynamic_cast<const ast::NullLiteralExpr*>(bin->rhs.get()) != nullptr);
        const bool savedSuppress = suppressNarrowing_;
        suppressNarrowing_ = suppressNarrowing_ || nullTest;
        const std::string lt = typeOf(*bin->lhs);
        const std::string rt = typeOf(*bin->rhs);
        suppressNarrowing_ = savedSuppress;
        const std::string& op = bin->op;
        // Operator overloading: a OP b where a's class defines `operator OP` (spec 6.5).
        if (const MethodInfo* om = findMethod(baseType(lt), "operator" + op)) {
            // The right operand is the operator's PARAMETER and was never checked against it -- so
            // `money + other` called `operator+(Money)` with an unrelated class and read its fields
            // through Money's layout. Type confusion, in an expression that reads like arithmetic.
            // A call spelled `a.plus(b)` had this check all along; the symbol form skipped it.
            if (!om->paramTypes.empty() && !rt.empty()) {
                const std::string& pt = om->paramTypes.front();
                // Report the name as WRITTEN. A type declared in two namespaces is rewritten to
                // `Ns__Type` internally, and telling someone their operand does not match `A__Money`
                // names a class they never wrote.
                auto asWritten = [](const std::string& s) {
                    const auto p = s.rfind("__");
                    return p == std::string::npos ? s : s.substr(p + 2);
                };
                if (!pt.empty() && !isSubtype(rt, pt) && !intLiteralFits(*bin->rhs, pt))
                    error("the right operand of '" + op + "' is '" + asWritten(rt) + "', but '" +
                              asWritten(baseType(lt)) + "' declares `operator" + op + "(" + asWritten(pt) +
                              ")`. An operator is an ordinary method reached through a symbol, so its "
                              "operand has to match its parameter -- otherwise the value is read "
                              "through the wrong type's layout. Convert it, or declare an "
                              "`operator" + op + "(" + asWritten(rt) + ")` if this combination is meant",
                          bin->loc);
            }
            return om->returnType;
        }
        // SIMD vectors: element-wise + - * / ; a scalar operand broadcasts.
        if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) {
            if (op != "+" && op != "-" && op != "*" && op != "/")
                error("operator '" + op + "' is not defined on vectors", bin->loc);
            return "vec" + std::to_string(vw);
        }
        // Pointer arithmetic (spec 27): `p + n` / `p - n` step by whole elements and stay a pointer;
        // `q - p` is the number of elements between them. Allowed on every pointee type, but stepping a
        // pointer TO A CLASS is warned about: it usually points at one object, not an array of them.
        if ((op == "+" || op == "-") && isRefType(lt) && !isRefType(rt) && !rt.empty()) {
            if (!isIntName(rt))
                error("a pointer can only be offset by an integer, got '" + rt + "' (spec 27)", bin->loc);
            warnClassPointerArith(lt, bin->loc);
            return lt;
        }
        if (op == "-" && isRefType(lt) && isRefType(rt)) {
            if (baseType(lt) != baseType(rt))
                error("cannot subtract pointers to different types ('" + lt + "' and '" + rt + "')",
                      bin->loc);
            warnClassPointerArith(lt, bin->loc);
            return "long";
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
        // SIGNEDNESS must agree (spec 3.6). Width does not: a narrower integer widens silently because
        // that conversion preserves the value. Signedness is different -- there is no common type that
        // represents every value of a 64-bit unsigned AND every value of a signed one, so the compiler
        // would have to pick a side and be wrong about the other. It did: `address(1) < int(-1)` answered
        // TRUE, because -1 sign-extends and then the comparison is unsigned.
        //
        // Deliberately NOT a rule about type names: `address` and `ulong` are one type under two
        // spellings, and demanding a cast between two identically-sized types would be noise. Measured
        // across the kernel, the stdlib and every sample: 380 mixed-type sites, and this rejects none of
        // them -- it costs nothing today and closes the one case that gives wrong answers.
        auto signednessOk = [&](const std::string& a, const std::string& b) {
            if (!isIntName(a) || !isIntName(b)) return true;              // not the integer path
            if (ast::isUnsignedIntName(a) == ast::isUnsignedIntName(b)) return true;
            // Mixed: fine when the SIGNED side is strictly wider, because it then represents every value
            // of the unsigned one (`uint` + `long`). Equal width cannot: half of each is unrepresentable.
            const std::string& u = ast::isUnsignedIntName(a) ? a : b;
            const std::string& s = ast::isUnsignedIntName(a) ? b : a;
            return intBits(s) > intBits(u);
        };
        auto checkSignedness = [&]() {
            // An untyped literal expression adapts to its context, exactly as it does in an assignment
            // (`byte b = 0;`), so it never forces a cast.
            if (ast::isLiteralOnlyExpr(*bin->lhs) || ast::isLiteralOnlyExpr(*bin->rhs)) return;
            if (signednessOk(lt, rt)) return;
            error("cannot mix signed and unsigned operands ('" + lt + "' " + op + " '" + rt +
                      "'): there is no common type that represents both, so convert one explicitly "
                      "with cast<T>(...)",
                  bin->loc);
        };
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
            checkSignedness();
            return intBits(lt) >= intBits(rt) ? lt : rt;  // wider integer wins
        }
        if (op == "&" || op == "|" || op == "^" || op == "<<" || op == ">>") {
            if (isFloatType(lt) || isFloatType(rt) || (!lt.empty() && !numOk(lt)) ||
                (!rt.empty() && !numOk(rt))) {
                error("operator '" + op + "' requires integer operands", bin->loc);
            }
            // A shift's right operand is a COUNT, not a value in the same domain -- `addr >> 12` shifts
            // by twelve, and twelve is not an address. Only `& | ^` pair two values.
            if (op != "<<" && op != ">>") checkSignedness();
            return intBits(lt) >= intBits(rt) ? lt : rt;
        }
        if (op == "<" || op == ">" || op == "<=" || op == ">=") {
            // Java-style enums order by ordinal (spec 12.2), like Java's compareTo: allow ordering when
            // both sides are the same such enum.
            const bool sameJavaEnum = baseType(lt) == baseType(rt) && javaEnums_.count(baseType(lt)) > 0;
            if (!sameJavaEnum &&
                ((!lt.empty() && !numOk(lt)) || (!rt.empty() && !numOk(rt)))) {
                error("operator '" + op + "' requires numeric operands", bin->loc);
            }
            // Ordering is where mixing signedness produced a WRONG ANSWER rather than a surprising one:
            // `address(1) < int(-1)` was true, because -1 sign-extends and the comparison is unsigned.
            if (!sameJavaEnum) checkSignedness();
            return "boolean";
        }
        if (op == "==" || op == "!=") {
            // Same hazard as ordering: the operands widen to one type first, so a negative signed value
            // and a large unsigned one can come out equal.
            checkSignedness();
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
        // region-binder DATA-RACE (§14): a closure handed to a Thread may only capture state that is safe to
        // share across threads -- atomic<T>/Mutex<T>/Channel<T>, or a copied value. Capturing a plain mutable
        // reference (byref, or byvalue a pointer) shares mutable state between two threads -> a data race.
        if (regionBinder_ && nw->className == "Thread" && !nw->args.empty()) {
            const ast::LambdaExpr* lam = dynamic_cast<const ast::LambdaExpr*>(nw->args[0].get());
            if (lam == nullptr)
                if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(nw->args[0].get())) {
                    auto it = lambdaLocals_.find(aid->name);
                    if (it != lambdaLocals_.end()) lam = it->second;
                }
            if (lam != nullptr)
                for (const ast::Capture& cap : lam->captures) {
                    const LocalVar* lv = lookupLocal(cap.name);
                    if (lv == nullptr) continue;
                    const std::string b = baseType(lv->type);
                    const bool safe = b.rfind("atomic", 0) == 0 || b.rfind("Mutex", 0) == 0 ||
                                      b.rfind("Channel", 0) == 0;
                    const bool shares = cap.byRef || isRefType(lv->type);  // shares the var / the pointee
                    if (shares && !safe)
                        error("region-binder: thread closure captures shared mutable '" + cap.name +
                                  "' (type '" + lv->type + "') -- a data race; share it via atomic<T> / "
                                  "Mutex<T> / Channel<T>, or capture an immutable copy (byvalue a value)",
                              nw->loc);
                }
        }
        // Value Result/Option (spec 21, value form): Ok/Err/Some/None with location "value" is a value, not
        // a heap object. Type it as the sealed base (Result$T$E / Option$T, no star) and check the payload
        // against T (Ok/Some) or E (Err); None carries no payload. No class is allocated.
        if (nw->location == "value") {
            const bool isResult = nw->className == "Ok" || nw->className == "Err";
            const bool okSide = nw->className == "Ok" || nw->className == "Some";
            const std::string payloadType =
                okSide ? (nw->typeArgs.empty() ? std::string() : nw->typeArgs[0])
                       : (isResult && nw->typeArgs.size() > 1 ? nw->typeArgs[1] : std::string());
            if (!nw->args.empty()) {
                const std::string at = typeOf(*nw->args[0]);
                if (!payloadType.empty() && !at.empty() && !isSubtype(at, payloadType) &&
                    !intLiteralFits(*nw->args[0], payloadType))
                    error("cannot build '" + nw->className + "' with a value of type '" + at +
                              "' (expected '" + payloadType + "')",
                          nw->loc);
            }
            return ast::mangleGeneric(isResult ? "Result" : "Option", nw->typeArgs);
        }
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
        // `new T[n]() in region R` is checked against the region's accepts/rejects exactly as an object
        // is. A region is TYPED -- that is what separates it from a hand-rolled arena, which takes bytes
        // and forgets what they were -- so an array entering one has to answer the same question its
        // element type would. Checked on the ELEMENT: `accepts({byte})` admits `byte[]`, because what
        // the region is being asked to hold is bytes.
        if (!na->region.empty()) checkRegionAccepts(na->region, na->elementType, na->loc);
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
        if (vecWidth(at) > 0 || at == "mat4") {  // SIMD vector/matrix: v[i] / m[i] -> float
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
        // Interpolation builds a String, so it carries the managed runtime with it -- a stored `$"..."`
        // emitted snprintf + __ldp3_malloc + __ldp3_str_copy/free, none of which exist bare metal. The
        // guide notes it can be lowered without an allocation "when the result is only consumed, not
        // stored", but in freestanding every consumer of a String (Console, the collections) is already
        // gated, so there is no consumed form left to permit.
        if (freestanding_ && std::string(is->loc.file) != "<prelude>")
            error("string interpolation is not available in freestanding mode (spec 36.3): `$\"...\"` "
                  "builds a managed String, which needs snprintf and the String runtime. Format into a "
                  "byte buffer yourself, or emit the pieces one at a time",
                  is->loc);
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
        // A CONSTRUCTOR THAT DELEGATES cannot be judged by the field-initialisation check below: a
        // `this.setUp()` or a `super(...)` assigns fields in a body this analysis does not follow, so
        // every field would be reported as unset. That is not a stricter check, it is a wrong one, and
        // it would reject a pattern the standard library itself uses.
        //
        // Discharging ALL of them rather than guessing which the callee touches: seeing through the
        // call needs interprocedural analysis, and a check that is sometimes wrong teaches people to
        // ignore it -- which costs more than the cases it would have caught. Done HERE, inside the
        // traversal that already visits every expression, so a delegation nested in a branch is found
        // without a second walker that could disagree with this one about where it looked.
        if (inConstructor_ && !pendingCtorFields_.empty()) {
            bool delegates = dynamic_cast<const ast::SuperExpr*>(call->callee.get()) != nullptr;
            if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call->callee.get()))
                if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(cm->object.get());
                    oid != nullptr && oid->name == "this")
                    delegates = true;
            if (delegates)
                for (const auto& [fname, floc] : pendingCtorFields_)
                    markInitialized("this." + fname);
        }
        // `itself(...)` inside a lambda: the lambda calling itself. Handled before every other call
        // shape because there `itself` resolves to no class, no local and no method -- the enclosing
        // lambda has no name of its own to look up. Everywhere else the pronoun has already been
        // resolved to the entity being declared, so reaching here means there was no such entity.
        if (const auto* iid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get());
            iid != nullptr && iid->name == "itself") {
            if (!analyzingLambda_) {
                error("'itself' names the entity being declared, and there is none to name here. "
                      "Inside a lambda body it is the lambda, which is how an anonymous function "
                      "recurses; in a declaration or an assignment it is what is being declared or "
                      "assigned to. In a method, call the method by its name",
                      call->loc);
                return "";
            }
            // Arity first: checkCallArgs only type-checks the arguments that line up with a parameter,
            // so a wrong COUNT would slip through it and reach codegen, which builds the call from the
            // function's own arity and would silently drop or invent an argument.
            if (call->args.size() != currentLambdaParams_.size()) {
                error("this lambda takes " + std::to_string(currentLambdaParams_.size()) +
                          " argument(s), but 'itself' is called here with " +
                          std::to_string(call->args.size()),
                      call->loc);
                for (const auto& a : call->args) typeOf(*a);
                return currentReturnType_;
            }
            checkCallArgs(call->args, currentLambdaParams_, "this lambda (called through 'itself')");
            return currentReturnType_;   // set to the lambda's return type for the body's duration
        }
        // spec 32.8: `Dog.methods.replace("bark", <function value>)` -- a mutable dispatch table. The
        // replacement takes over the class's vtable slot, so every Dog (already alive or not yet born)
        // gets the new behaviour: genuine AOP, mocking without a framework, localized hot patching.
        if (const auto* rp = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            rp != nullptr && rp->member == "replace") {
            if (const std::string cls = dispatchTableClass(*rp->object); !cls.empty())
                return checkMethodPatch(cls, *call);
        }
        // mat4.identity(): the identity-matrix factory.
        if (const auto* mc = dynamic_cast<const ast::MemberExpr*>(call->callee.get()))
            if (const auto* mo = dynamic_cast<const ast::IdentifierExpr*>(mc->object.get());
                mo != nullptr && mo->name == "mat4" && mc->member == "identity" && call->args.empty())
                return "mat4";
        // SIMD vector construction: vec4(x,y,z,w) etc. -- N numeric args -> vecN.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (cid->name == "mat4") {  // mat4(m0..m15) construction
                if (call->args.size() != 16) error("mat4 takes 16 components", call->loc);
                for (const auto& arg : call->args) {
                    const std::string at = typeOf(*arg);
                    if (!at.empty() && !isNumeric(at))
                        error("mat4 components must be numeric, got '" + at + "'", arg->loc);
                }
                return "mat4";
            }
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
        // Calling a funcptr<Ret, Params...> value (a bare C function pointer) -> Ret.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (const LocalVar* fv = lookupLocal(cid->name);
                fv != nullptr && fv->type.rfind("funcptr<", 0) == 0) {
                for (const auto& arg : call->args) typeOf(*arg);
                const std::string inner = ast::funcptrBody(fv->type.substr(8, fv->type.size() - 9));  // [unknown-abi]
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') depth++;
                    else if (inner[i] == '>') depth--;
                    else if (inner[i] == ',' && depth == 0) return inner.substr(0, i);
                }
                return inner;
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
        // The test framework, reached as a static call (`Test.assertEqual(...)`), which never goes
        // through checkTypeAccessible -- so gating the TYPE was not enough to stop it. It reports
        // through printf and builds Strings; a freestanding program that used it compiled clean and
        // failed at link. Same rule as Console: user code only, since the prelude names it freely.
        if (freestanding_ && std::string(call->loc.file) != "<prelude>" &&
            (name.rfind("Test.", 0) == 0 || name.rfind("System.Test.Test.", 0) == 0))
            error("the test framework is not available in freestanding mode (spec 36.3): 'Test' reports "
                  "through printf and builds Strings, neither of which exists bare metal. Test a "
                  "freestanding program from outside -- boot it and assert on what it emits",
                  call->loc);
        // embed("path") (spec 36): the file's bytes, materialized into the image at compile time.
        if (name == "embed" && call->args.size() == 1) {
            if (dynamic_cast<const ast::StringLiteralExpr*>(call->args[0].get()) == nullptr)
                error("embed(...) needs a literal path known at compile time", call->loc);
            return "byte[]";
        }
        if (name == "checked" && call->args.size() == 1)  // checked(expr): overflow-trapping, same type
            return typeOf(*call->args[0]);
        // `T.sizeof()` (spec issue #7): the type answers about itself. The companion spelling,
        // `Memory.sizeof(x)`, lives with the rest of the Memory API below and is the only one that
        // takes an expression.
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
                // The prelude's own library classes (e.g. Logger) may reference Console; their mere
                // presence must not break a freestanding program that never uses them (unused prelude code
                // is dead-stripped). Only flag Console used directly in user code.
                if (freestanding_ && std::string(call->loc.file) != "<prelude>")
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
        // Memory API (spec 17.8): a NAMESPACE of stdlib classes -- System.Memory.Allocator (alloc/
        // free/copy) and System.Memory.Raw (read/write/readString/writeString/addressOf/sizeof).
        // Reached fully qualified (always allowed) or, after `import System.Memory.Allocator;` /
        // `import System.Memory.Raw;`, by the short Allocator.X / Raw.X. The short form requires the
        // import, enforced through checkTypeAccessible exactly like System.Math.Math (System.* code
        // stays exempt, and so does freestanding, whose systems core this is).
        std::string memName = name;
        if (memName.rfind("System.Memory.", 0) == 0) {
            memName = memName.substr(14);   // -> "Allocator.alloc" / "Raw.read"
        } else if ((memName.rfind("Allocator.", 0) == 0 || memName.rfind("Raw.", 0) == 0) &&
                   !freestanding_) {
            checkTypeAccessible(memName.substr(0, memName.find('.')), call->loc);
        }
        // `Raw.sizeof(T)` (spec issue #7): the byte size of a type, or of an expression's type. A size
        // is a question about how a value is laid out in memory, so it is asked of the class that
        // reads and writes memory rather than by a bare word the language would have to reserve.
        // Folded to a constant in the code generator, which is what lets a `static_assert` hold a
        // struct to a byte budget.
        //
        // The argument may NAME A TYPE, which has no value to type-check -- but when it names no type
        // it is a VALUE, and a value must be checked like one. Skipping both is how a size of a
        // nonexistent name used to compile to a guessed 4 instead of saying the name means nothing.
        // The test is deliberately permissive: the code generator holds the real layout and decides,
        // so anything arguable passes here and only a bare name matching nothing is checked as a value.
        if (memName == "Raw.sizeof") {
            if (call->args.size() != 1) {
                error("Raw.sizeof takes one type or expression", call->loc);
                return "int";
            }
            const std::string spelled = comptime::typeNameSpelled(*call->args[0]);
            const std::string bare = baseType(spelled);
            const bool looksLikeAType =
                !spelled.empty() &&
                (spelled.find('<') != std::string::npos || spelled.find('.') != std::string::npos ||
                 isNumeric(bare) || bare == "boolean" || bare == "char" || bare == "void" ||
                 bare == "String" || bare == "string" || bare == "Object" || bare == "Decimal" ||
                 bare == "vec2" || bare == "vec3" || bare == "vec4" || bare == "mat4" ||
                 enums_.count(bare) > 0 || catalogs_.count(bare) > 0 || newtypes_.count(bare) > 0 ||
                 classes_.count(bare) > 0 || lookupClass(bare) != nullptr);
            if (!looksLikeAType) typeOf(*call->args[0]);
            return "int";
        }
        if (memName == "Allocator.alloc") {
            if (call->args.size() != 1) error("Allocator.alloc takes a byte count", call->loc);
            else typeOf(*call->args.front());
            return "address";
        }
        if (memName == "Allocator.free") {
            if (call->args.size() != 1) error("Allocator.free takes an address", call->loc);
            else typeOf(*call->args.front());
            return "void";
        }
        if (memName == "Raw.getMemory") {
            if (call->args.size() != 1) error("Raw.getMemory takes one argument", call->loc);
            else typeOf(*call->args.front());
            return "address";
        }
        if (memName == "Raw.read") {
            if (call->typeArgs.size() != 1) error("Raw.read<T> needs a type argument", call->loc);
            else checkBitCounted(call->typeArgs[0], call->loc);  // int8/int16/... are freestanding-only
            for (const auto& a : call->args) typeOf(*a);
            return call->typeArgs.empty() ? "" : call->typeArgs[0];
        }
        if (memName == "Raw.write") {
            if (!call->typeArgs.empty()) checkBitCounted(call->typeArgs[0], call->loc);  // bit-counted: freestanding-only
            for (const auto& a : call->args) typeOf(*a);
            return "void";
        }
        // Raw.writeString(address, String): bulk-copy a String's bytes to a raw buffer (StringBuilder).
        if (memName == "Raw.writeString") {
            if (call->args.size() != 2) error("Raw.writeString takes (address, String)", call->loc);
            for (const auto& a : call->args) typeOf(*a);
            return "void";
        }
        // Allocator.copy(dst, src, n): raw memcpy of n bytes between two addresses (StringBuilder growth).
        if (memName == "Allocator.copy") {
            if (call->args.size() != 3) error("Allocator.copy takes (dst, src, n)", call->loc);
            for (const auto& a : call->args) typeOf(*a);
            return "void";
        }
        if (name == "Bits.doubleToLong" || name == "Bits.longToDouble") {
            checkTypeAccessible("Bits", call->loc);
            for (const auto& a : call->args) typeOf(*a);
            return name == "Bits.doubleToLong" ? "long" : "double";
        }
        // Ipc (spec 2.8): cross-program transport builtins. The program NAME is the address.
        if (name.rfind("Ipc.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "listen" || fn == "accept" || fn == "connect" || fn == "send" || fn == "recv" ||
                fn == "close") {
                checkTypeAccessible("Ipc", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                if (fn == "recv") return "String";   // (conn) -> one whole frame ("" when the peer left)
                if (fn == "close") return "void";    // (handle)
                return "long";  // listen(name)/accept(srv)/connect(name) -> handle (-1); send -> bytes
            }
        }
        // Net (spec 34): TCP client builtins. Require `import System.Net.Net;` (used by Socket).
        if (name.rfind("Net.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "connect" || fn == "send" || fn == "recv" || fn == "close" ||
                fn == "listen" || fn == "accept" ||
                fn == "udpOpen" || fn == "udpSend" || fn == "udpRecv" ||
                fn == "udpPeerHost" || fn == "udpPeerPort" || fn == "udpClose") {
                checkTypeAccessible("Net", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                if (fn == "connect") return "long";     // (host, port) -> socket handle (or -1)
                if (fn == "send") return "long";        // (sock, data) -> bytes sent
                if (fn == "recv") return "String";      // (sock, max) -> received bytes
                if (fn == "listen") return "long";      // (port) -> listening socket (or -1)
                if (fn == "accept") return "long";      // (server) -> connection socket (or -1)
                if (fn == "udpOpen") return "long";     // (port) -> UDP socket (port 0 = ephemeral)
                if (fn == "udpSend") return "long";     // (sock, host, port, data) -> bytes sent
                if (fn == "udpRecv") return "String";   // (sock, max) -> datagram payload
                if (fn == "udpPeerHost") return "String"; // () -> last datagram's sender IP
                if (fn == "udpPeerPort") return "int";  // () -> last datagram's sender port
                return "void";                          // close(sock) / udpClose(sock)
            }
        }
        // Process (spec 34): Process.run(cmd) runs a shell command, returning a ProcessResult with its
        // captured stdout and exit code. Require `import System.OS.Process;`.
        if (name.rfind("Process.", 0) == 0) {
            const std::string fn = name.substr(8);
            if (fn == "run") {
                checkTypeAccessible("Process", call->loc);
                if (call->args.size() != 1) error("Process.run takes a command string", call->loc);
                else typeOf(*call->args[0]);
                return "ProcessResult";
            }
        }
        // Env (spec 34): environment variables. Env.get(name) -> String (empty if unset); Env.set(name,
        // value) -> boolean. Require `import System.OS.Env;`.
        if (name.rfind("Env.", 0) == 0) {
            const std::string fn = name.substr(4);
            if (fn == "get" || fn == "set") {
                checkTypeAccessible("Env", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                const std::size_t want = (fn == "set") ? 2u : 1u;
                if (call->args.size() != want)
                    error("Env." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                return fn == "get" ? "String" : "boolean";
            }
            // executablePath() -> the running program's own full path (spec 34). Lets a program
            // resolve files relative to its executable rather than the current directory.
            if (fn == "executablePath") {
                checkTypeAccessible("Env", call->loc);
                if (!call->args.empty())
                    error("Env.executablePath takes no arguments", call->loc);
                return "String";
            }
        }
        // Persistent subprocess (debugger/LSP): low-level builtins behind the System.OS.Subprocess class.
        // spawn(cmd) -> handle (0 = failed); writeStr(h, data) -> bytes written; readChunk(h) -> available
        // bytes ("" on EOF); isAlive(h)/closeStdin(h)/kill(h). Internal; the Subprocess class is the API.
        if (name.rfind("Subproc.", 0) == 0) {
            const std::string fn = name.substr(8);
            for (const auto& a : call->args) typeOf(*a);
            // spawnCombined: same, but the child's stderr shares its stdout pipe (a compiler's diagnostics).
            // spawnVisible: the child gets its own console window instead of being windowless.
            if (fn == "spawn" || fn == "spawnCombined" || fn == "spawnVisible") return "long";
            if (fn == "writeStr") return "int";
            if (fn == "readChunk") return "String";
            if (fn == "isAlive" || fn == "canRead") return "boolean";
            if (fn == "closeStdin" || fn == "kill") return "void";
        }
        // Pseudo-console (the Pty terminal): spawn(cmd,cols,rows) -> handle; writeStr(h,data) -> bytes;
        // readChunk(h) -> output; isAlive/canRead(h) -> boolean; resize(h,cols,rows)/close(h) -> void.
        if (name.rfind("Conpty.", 0) == 0) {
            const std::string fn = name.substr(7);
            for (const auto& a : call->args) typeOf(*a);
            if (fn == "spawn") return "long";
            if (fn == "writeStr") return "int";
            if (fn == "readChunk") return "String";
            if (fn == "isAlive" || fn == "canRead") return "boolean";
            if (fn == "resize" || fn == "close") return "void";
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
            // Directory / filesystem metadata (spec 34.4): list, mkdir, rename, size, isDir.
            if (fn == "list" || fn == "mkdir" || fn == "rename" || fn == "size" || fn == "isDir") {
                checkTypeAccessible("File", call->loc);
                for (const auto& a : call->args) typeOf(*a);
                const std::size_t want = (fn == "rename") ? 2u : 1u;
                if (call->args.size() != want)
                    error("File." + fn + " takes " + std::to_string(want) + " argument(s)", call->loc);
                if (fn == "list") return "String";        // newline-separated entries
                if (fn == "size") return "long";          // byte count (-1 if missing)
                return "boolean";                          // mkdir / rename / isDir
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
        if (memName == "Raw.readString") {
            if (call->args.size() != 2) error("Raw.readString takes (address, length)", call->loc);
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
        // Fully-qualified static call to a stdlib/user class: `bundle.namespace...Class.staticMethod(...)`.
        // Only the `Console`/`File` builtins are recognized by their full path; other classes must be
        // called by the short name `Class.method` after importing (BUG3). Rather than the misleading
        // "use of undeclared variable 'System'", point the user at the short form. Fires only when the
        // receiver is a dotted path whose head is NOT a local and whose last segment is a known class
        // with a static method by this name.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            mem != nullptr && dynamic_cast<const ast::MemberExpr*>(mem->object.get()) != nullptr) {
            const std::string flat = flattenCallee(*mem->object);
            const std::size_t dot = flat.rfind('.');
            if (dot != std::string::npos && !flat.empty()) {
                const std::string cls = flat.substr(dot + 1);
                const std::string head = flat.substr(0, flat.find('.'));
                if (head != "this" && lookupLocal(head) == nullptr) {
                    if (const ClassInfo* sc = lookupClass(cls)) {
                        if (auto mit = sc->methods.find(mem->member);
                            mit != sc->methods.end() && mit->second.isStatic) {
                            error("call '" + cls + "." + mem->member + "' by its short name after "
                                  "importing it (e.g. `import " + flat + ";` then `" + cls + "." +
                                  mem->member + "(...)`); the fully-qualified path is only resolved for "
                                  "the Console/File builtins",
                                  call->loc);
                            for (const auto& arg : call->args) typeOf(*arg);
                            return mit->second.returnType;
                        }
                    }
                }
            }
        }
        // Otherwise the callee should be a method: obj.method(...) or, when the
        // receiver names a class, a static call ClassName.method(...).
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (objId->name != "this" && lookupLocal(objId->name) == nullptr) {
                    if (const ClassInfo* sc = lookupClass(objId->name)) {
                        // spec 32.11: [BeforeAll]/[AfterAll] bracket the tests of the class that
                        // DECLARES them and nothing else, so a test reaching into another class's
                        // fixture reads state that class may already have torn down. The failure is a
                        // read of freed memory in a suite whose output showed nothing but passes.
                        if (inTestMethod_ && objId->name != enclosingClass_ &&
                            fixtureOwners_.count(objId->name) > 0) {
                            const std::string key = enclosingClass_ + "." + mem->member + "|" + objId->name;
                            if (fixtureWarned_.insert(key).second)
                                warn("this test reads '" + objId->name +
                                         "', which owns a [BeforeAll]/[AfterAll] fixture, from class '" +
                                         enclosingClass_ +
                                         "'. Those hooks bracket only their own class's tests, so '" +
                                         objId->name +
                                         "' may already have torn the fixture down by the time this "
                                         "runs. Move the test into '" +
                                         objId->name + "', or give this class its own fixture",
                                     call->loc);
                        }
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
                            // A java-style enum desugars to a class of the same name; its auto-generated
                            // built-ins (values/count/random/parse, spec 12.5) are NOT class methods, so
                            // fall through to the enum built-in resolver below instead of erroring.
                            if (enums_.count(objId->name) > 0) goto enumBuiltin;
                            error("class '" + objId->name + "' has no method '" + mem->member + "'",
                                  call->loc);
                            return "";
                        }
                        if (!mit->second.isStatic) {
                            error("method '" + mem->member + "' is not static; call it on an instance",
                                  call->loc);
                            return "";
                        }
                        if (mit->second.isVariadic) {
                            // A variadic extern (spec 26): the fixed params are checked, extra args are
                            // the `...` and pass through.
                            for (const auto& a : call->args) typeOf(*a);
                        } else {
                            if (mit->second.isDeprecated)
                                warn("'" + mem->member + "' is deprecated (spec 14.2)", call->loc);
                            bindNamedArgs(const_cast<ast::CallExpr*>(call), mit->second.paramNames,
                                          mit->second.namedOnlyParams, "method '" + mem->member + "'");
                            checkCallArgs(call->args, mit->second.paramTypes, "'" + mem->member + "'", &mit->second.moveParams);
                            checkComptimeArgs(call->args, mit->second.comptimeParams,
                                              "'" + mem->member + "'");
                            if (call->args.size() != mit->second.paramCount) {
                                error("method '" + mem->member + "' expects " +
                                          std::to_string(mit->second.paramCount) + " argument(s) but got " +
                                          std::to_string(call->args.size()),
                                      call->loc);
                            }
                        }
                        // An async static method yields a Task<returnType> (spec 20.2).
                        if (mit->second.isAsync)
                            return ast::mangleGeneric("Task", {mit->second.returnType});
                        return mit->second.returnType;
                    }
                }
            }
        enumBuiltin:;
            // Enum built-ins: EnumName.count() / EnumName.values() (spec 12.5). Reached directly, or via
            // fall-through from the class branch for a java-style enum (desugared to a same-named class).
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (lookupLocal(oid->name) == nullptr && enums_.count(oid->name) > 0) {
                    if (mem->member == "count" && call->args.empty()) return "int";
                    if (mem->member == "values" && call->args.empty()) return oid->name + "[]";
                    if (mem->member == "random" && call->args.empty()) return oid->name;
                    if (mem->member == "parse" && call->args.size() == 1) {  // -> Option<Enum>
                        typeOf(*call->args[0]);
                        return "Option$" + oid->name;
                    }
                    // A STATIC method the enum declares itself. Spec 12.2 gives enums methods and
                    // nothing restricts them to instance methods; codegen has always emitted these
                    // correctly (a static one simply gets no `this` parameter), but resolution never
                    // looked past the built-ins -- so declaring one compiled and CALLING it did not.
                    // That is the worst shape a gap can have: a declaration the language accepts and
                    // then gives you no way to reach.
                    //
                    // It bites hardest where an enum meets hardware. A register field arrives as an
                    // integer and something has to turn it into a value; that is a factory, and a
                    // factory is static by nature.
                    if (auto emit = enumMethods_.find(oid->name); emit != enumMethods_.end()) {
                        auto mit = emit->second.find(mem->member);
                        if (mit != emit->second.end() && mit->second.isStatic) {
                            for (const auto& arg : call->args) typeOf(*arg);
                            const std::size_t want = enumMethodParams_[oid->name][mem->member];
                            if (call->args.size() != want) {
                                error("method '" + mem->member + "' expects " + std::to_string(want) +
                                          " argument(s) but got " + std::to_string(call->args.size()),
                                      call->loc);
                            }
                            return mit->second.returnType;
                        }
                        // Declared, but on an instance. Saying which beats "has no built-in", which
                        // sends the reader hunting for a spelling mistake that is not there.
                        if (mit != emit->second.end()) {
                            error("method '" + mem->member + "' on enum '" + oid->name +
                                      "' is an instance method -- call it on a value of the enum, "
                                      "not on the type itself",
                                  call->loc);
                            return mit->second.returnType;
                        }
                    }
                    error("enum '" + oid->name + "' has no built-in or static method '" +
                              mem->member + "'",
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
            if (int vw = vecWidth(objType); vw > 0) {  // SIMD vector methods (GLSL-style)
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "dot" && call->args.size() == 1) return "float";
                if (mem->member == "length" && call->args.empty()) return "float";  // magnitude
                if (mem->member == "normalize" && call->args.empty()) return objType;   // vecN
                if (mem->member == "cross" && call->args.size() == 1 && vw == 3) return "vec3";
                error("vec" + std::to_string(vw) + " has dot/length/normalize" +
                          (vw == 3 ? std::string("/cross") : std::string("")) + "; '" +
                          mem->member + "' is not one",
                      call->loc);
                return "";
            }
            if (objType == "mat4") {  // SIMD matrix methods
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "multiply" && call->args.size() == 1) return "mat4";
                if (mem->member == "transform" && call->args.size() == 1) return "vec4";
                error("mat4 has multiply/transform; '" + mem->member + "' is not one", call->loc);
                return "";
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
                if (mem->member == "toDouble" && call->args.empty()) return "double";  // parse (spec 4)
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
            if (objType == "Decimal" && mem->member == "toString" && call->args.empty()) {
                return "String";  // formats the i128 fixed-point value (codegen emitDecimalToString)
            }
            // Floating-point types render themselves as text, the same way int does. Without this a
            // `record` with a float field cannot even be declared: its synthesized toString() calls
            // toString() on every field. (Only toString -- floats are deliberately NOT hashable or
            // comparable keys, since float equality is not an identity anyone should key a map on.)
            if (isFloatType(objType) && mem->member == "toString" && call->args.empty()) {
                return "String";
            }
            // And a boolean, for exactly the same reason and with exactly the same limit: a `record`
            // with a boolean field could not be DECLARED, because its synthesized toString() calls
            // toString() on every field and there was no such method -- so the error landed on the
            // record declaration, naming a call the author never wrote. "true"/"false", which is the
            // answer every language that has this gives. (toString only: a bare boolean is not a
            // useful map key, so it stays out of the Hashable/Comparable builtins.)
            if (objType == "boolean" && mem->member == "toString" && call->args.empty()) {
                return "String";
            }
            // Integer types satisfy Hashable<T>/Comparable<T> via builtins, so they can be used as
            // map/set keys without boxing (collections, spec 34).
            if (isIntName(objType)) {
                for (const auto& arg : call->args) typeOf(*arg);
                if (mem->member == "hash" && call->args.empty()) return "long";
                if (mem->member == "toString" && call->args.empty()) return "String";
                if (mem->member == "equalsKey" && call->args.size() == 1) return "boolean";
                if (mem->member == "compareTo" && call->args.size() == 1) return "int";
                // Overflow-mode arithmetic (spec 3.6): wrapping/saturating/unchecked, same int type.
                static const std::set<std::string> kOverflowMethods = {
                    "wrappingAdd",   "wrappingSub",   "wrappingMul",   "wrappingDiv",
                    "saturatingAdd", "saturatingSub", "saturatingMul",
                    "uncheckedAdd",  "uncheckedSub",  "uncheckedMul",  "uncheckedDiv"};
                if (kOverflowMethods.count(mem->member) > 0 && call->args.size() == 1) return objType;
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
                if (mem->member == "invoke") return "Object";  // invoke(receiver [, args]) -> boxed result
                if (mem->member == "annotations" && call->args.empty())
                    return "ArrayList$Annotation";  // the method's own applied annotations (spec 31)
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
            // A field of funcptr<...> type (a bare C function pointer): obj.f(args) calls it -> Ret.
            if (const FieldInfo* fpf = findField(objType, mem->member);
                fpf != nullptr && fpf->type.rfind("funcptr<", 0) == 0) {
                for (const auto& arg : call->args) typeOf(*arg);
                const std::string inner = ast::funcptrBody(fpf->type.substr(8, fpf->type.size() - 9));  // [unknown-abi]
                for (std::size_t i = 0, depth = 0; i < inner.size(); i++) {
                    if (inner[i] == '<') depth++;
                    else if (inner[i] == '>') depth--;
                    else if (inner[i] == ',' && depth == 0) return inner.substr(0, i);
                }
                return inner;
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
            // Calling a catalog method through a catalog-TYPED receiver (spec 12.4). A catalog value
            // carries a runtime type tag (enum id + ordinal), so dispatch works for any number of
            // implementers: every implementer must define the method and agree on its return type,
            // which becomes the call's type.
            if (catalogs_.count(baseType(objType)) > 0) {
                std::vector<std::string> impls = catalogImplementers(baseType(objType));
                for (const auto& arg : call->args) typeOf(*arg);
                if (impls.empty()) {
                    error("cannot call method '" + mem->member + "' through catalog '" +
                              baseType(objType) + "': no enum implements it",
                          call->loc);
                    return "";
                }
                std::string retType;
                bool ok = true;
                for (const std::string& impl : impls) {
                    auto emit = enumMethods_.find(impl);
                    if (emit == enumMethods_.end() ||
                        emit->second.find(mem->member) == emit->second.end()) {
                        error("enum '" + impl + "' implementing catalog '" + baseType(objType) +
                                  "' has no method '" + mem->member + "'",
                              call->loc);
                        ok = false;
                        break;
                    }
                    const std::string rt = emit->second.at(mem->member).returnType;
                    if (retType.empty()) retType = rt;
                    else if (rt != retType) {
                        error("implementers of catalog '" + baseType(objType) + "' disagree on the "
                                  "return type of '" + mem->member + "' (" + retType + " vs " + rt +
                                  "); they must match for catalog dispatch",
                              call->loc);
                        ok = false;
                        break;
                    }
                }
                return ok ? retType : std::string();
            }
            const MethodInfo* m = findMethod(objType, mem->member, /*objectFallback=*/true);
            if (m == nullptr) {
                error("class '" + objType + "' has no method '" + mem->member + "'", call->loc);
                return "";
            }
            // Named arguments (spec 22.4): rewrite into parameter order before anything checks the args.
            if (m->isDeprecated)
                warn("'" + mem->member + "' is deprecated (spec 14.2)", call->loc);
            bindNamedArgs(const_cast<ast::CallExpr*>(call), m->paramNames, m->namedOnlyParams,
                          "method '" + mem->member + "'");
            checkCallArgs(call->args, m->paramTypes, "'" + mem->member + "'", &m->moveParams);
            // region-binder INTERPROCEDURAL escape check (§8): if the callee stores parameter i into its
            // receiver (per the escape summary) and we pass an activation-owned object there, it dangles
            // once this method returns -- unless the receiver is itself activation-local (same lifetime).
            if (regionBinder_) {
                // an argument aliases (rather than copies) only when its own type is a pointer/reference --
                // this reads the CONCRETE type, so a generic `add(T)` with T = Node* is caught.
                auto argAliases = [&](const ast::IdentifierExpr* aid) -> bool {
                    const LocalVar* lv = lookupLocal(aid->name);
                    return lv != nullptr && isRefType(lv->type);
                };
                auto sit = escapesToReceiver_.find(baseType(objType) + "." + mem->member);
                if (sit != escapesToReceiver_.end()) {
                    const auto* recvId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                    const bool recvOutlives = recvId == nullptr || activationOwned_.count(recvId->name) == 0;
                    if (recvOutlives)
                        for (std::size_t i = 0; i < call->args.size() && i < sit->second.size(); ++i)
                            if (sit->second[i])
                                if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(call->args[i].get());
                                    aid != nullptr && activationOwned_.count(aid->name) > 0 &&
                                    argAliases(aid))   // only a pointer/reference argument actually aliases
                                    error("region-binder: '" + mem->member + "' stores argument '" + aid->name +
                                              "' into a receiver that outlives this method, so the method-local "
                                              "object would dangle at return; pass ownership with 'move' (move " +
                                              aid->name + ")",
                                          call->args[i]->loc);
                }
                // escapes-into-parameter (§8): the callee stores argument i into argument j's field. If i is
                // activation-owned and j outlives it (j is not itself activation-local), i dangles inside j.
                auto pit = escapesToParam_.find(baseType(objType) + "." + mem->member);
                if (pit != escapesToParam_.end())
                    for (std::size_t i = 0; i < call->args.size() && i < pit->second.size(); ++i)
                            if (const auto* aid = dynamic_cast<const ast::IdentifierExpr*>(call->args[i].get());
                                aid != nullptr && activationOwned_.count(aid->name) > 0 && argAliases(aid))
                                for (int j : pit->second[i]) {
                                    if (j < 0 || j >= static_cast<int>(call->args.size())) continue;
                                    const auto* jid =
                                        dynamic_cast<const ast::IdentifierExpr*>(call->args[j].get());
                                    if (jid == nullptr || activationOwned_.count(jid->name) == 0)  // j outlives i
                                        error("region-binder: '" + mem->member + "' stores argument '" +
                                                  aid->name + "' into argument " + std::to_string(j + 1) +
                                                  ", which outlives it, so the method-local object would dangle; "
                                                  "pass ownership with 'move' (move " + aid->name + ")",
                                              call->args[i]->loc);
                                }
            }
            checkComptimeArgs(call->args, m->comptimeParams, "'" + mem->member + "'");
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
                return ast::makeNullable(m->returnType);
            }
            return m->returnType;
        }
        // A bare, unqualified call. LDP3 has no free functions, so this names a method of the enclosing
        // class written without its receiver. The `this.`/`ClassName.` qualifier is optional: locals and
        // lambdas were already resolved above, so `name` here is not a local -- resolve it as `this.name`
        // (an instance method, in an instance context) or `EnclosingClass.name` (a static method), exactly
        // as if the receiver had been written. Only when the method is an instance method reached from a
        // static context -- or when no such method exists anywhere -- do we error, naming the cause and fix.
        if (!name.empty() && name.find('.') == std::string::npos) {
            if (!enclosingClass_.empty()) {
                if (const MethodInfo* m = findMethod(enclosingClass_, name, /*objectFallback=*/false)) {
                    // An instance-method call needs a receiver; `this` exists only in an instance context
                    // (currentClass_ is cleared inside a static method).
                    if (m->isStatic || !currentClass_.empty()) {
                        if (m->isDeprecated) warn("'" + name + "' is deprecated (spec 14.2)", call->loc);
                        bindNamedArgs(const_cast<ast::CallExpr*>(call), m->paramNames, m->namedOnlyParams,
                                      "method '" + name + "'");
                        checkCallArgs(call->args, m->paramTypes, "'" + name + "'", &m->moveParams);
                        checkComptimeArgs(call->args, m->comptimeParams, "'" + name + "'");
                        if (!m->isProperty && call->args.size() != m->paramCount) {
                            error("method '" + name + "' expects " + std::to_string(m->paramCount) +
                                      " argument(s) but got " + std::to_string(call->args.size()),
                                  call->loc);
                        }
                        // An async method call yields a Task<returnType> (spec 20.2), not the bare value.
                        if (m->isAsync) return ast::mangleGeneric("Task", {m->returnType});
                        return m->returnType;
                    }
                    // Instance method reached from a static method: there is no `this` to call it on.
                    error("unknown call '" + name + "': '" + name + "' is an instance method of '" +
                              enclosingClass_ +
                              "'; it needs an object -- call it on an instance, or mark it 'static' to "
                              "call it from a static method",
                          call->loc);
                    return m->returnType;
                }
            }
            // Not a method of the enclosing class. Name a same-named method elsewhere (there are no free
            // functions, so a bare call can only ever be a member) to point at the likely fix.
            auto describe = [&](const std::string& owner, const MethodInfo* m) {
                if (m->isStatic)
                    return "unknown call '" + name + "': LDP3 has no free functions -- '" + name +
                           "' is a static method of '" + owner + "'; call it qualified as '" + owner +
                           "." + name + "(...)'";
                return "unknown call '" + name + "': LDP3 has no free functions -- '" + name +
                       "' is an instance method of '" + owner +
                       "'; call it on an object ('obj." + name + "(...)')";
            };
            for (const auto& [cn, ci] : classes_) {
                if (cn.find('$') != std::string::npos) continue;  // skip monomorphized instances
                if (const MethodInfo* m = findMethod(cn, name, /*objectFallback=*/false)) {
                    error(describe(cn, m), call->loc);
                    return "";
                }
            }
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
            error(diag::Code::NoSuchField,
                  "class '" + objType + "' has no field '" + mem->member + "'" +
                      didYouMean(mem->member, fieldNames(objType)),
                  mem->loc);
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
        return ast::makeNullable(memType);
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
