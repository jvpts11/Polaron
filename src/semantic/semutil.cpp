// The definitions of the analyser's pure helpers. See semutil.h for what makes them a unit, and for
// the duplication with codegen's cgutil that is recorded there rather than papered over.
//
// Moved out of analyzer.cpp verbatim, so `git blame` still lands on the change that wrote each line.

#include "semantic/semutil.h"

#include <algorithm>
#include <cctype>
#include <string>

namespace polaron {
namespace semutil {
// Levenshtein edit distance, capped: the number of single-character insertions, deletions or
// substitutions to turn `a` into `b`. Used only to say "did you mean X?" on a name error, so a small
// classic DP is plenty -- the strings are identifiers.
int editDistance(const std::string& a, const std::string& b) {
    const std::size_t n = a.size(), m = b.size();
    std::vector<int> prev(m + 1), cur(m + 1);
    for (std::size_t j = 0; j <= m; ++j) {
        prev[j] = static_cast<int>(j);
    }
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
    if (typed.empty()) {
        return "";
    }
    const int budget = std::max(1, static_cast<int>(typed.size()) / 3 + 1);
    std::string best;
    int bestDist = budget + 1;
    for (const std::string& c : candidates) {
        if (c == typed || c.empty()) {
            continue;
        }
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
// `T[N]`: the extent read back out of the name, or 0 when it is not one. Deliberately strict --
// every character between the brackets must be a digit and there must be at least one, so a generic
// mangled name or anything else ending in ']' cannot be mistaken for an extent.
// `T[N]`: the extent stated in the type, or 0. Reads the FIRST bracket group, which is the OUTER
// one -- `int[3][4]` is three of `int[4]`, the way C, Java and C# all read it. The element type is
// then the base with that group removed, which is itself an array when more groups follow.
int fixedExtent(const std::string& t) {
    const std::string::size_type open = t.find('[');
    if (open == std::string::npos || open + 1 >= t.size()) {
        return 0;
    }
    const std::string::size_type close = t.find(']', open);
    if (close == std::string::npos || close == open + 1) {
        return 0;   // "[]" -- a dynamic array, whose extent is deliberately not stated
    }
    int n = 0;
    for (std::string::size_type i = open + 1; i < close; ++i) {
        if (std::isdigit(static_cast<unsigned char>(t[i])) == 0) {
            return 0;
        }
        n = n * 10 + (t[i] - '0');
    }
    return n;
}
bool isFixedArrayType(const std::string& t) {
    return fixedExtent(t) > 0;
}
std::string elementOf(const std::string& t) {
    if (isFixedArrayType(t)) {
        const std::string::size_type open = t.find('[');
        return t.substr(0, open) + t.substr(t.find(']', open) + 1);
    }
    if (isArrayType(t)) {
        return t.substr(0, t.size() - 2);
    }
    return t;
}
// Pointer/reference types end with '*' or '&' (e.g. "Dog*", "Dog&").
bool isRefType(const std::string& t) {
    return !t.empty() && (t.back() == '*' || t.back() == '&');
}
std::string baseType(const std::string& t) {
    std::string s = ast::stripNullable(t);           // strip the `nullable ` prefix (spec 3.7)
    // Strip ONE trailing pointer/reference marker: a generic with a pointer type argument mangles to a
    // name ending in '*', and only the outermost '*' is the receiver's own pointer (see codegen baseType).
    if (!s.empty() && (s.back() == '*' || s.back() == '&')) {
        s.pop_back();
    }
    return s;
}
// True if the type is declared `nullable` (canonical "nullable T" -- a prefix word, not a suffix mark).
// Was inline when it lived in an anonymous namespace, where that cost nothing. Out here it meant
// no external symbol was emitted, and the link failed on this one name alone.
bool isNullableType(const std::string& t) { return ast::typeIsNullable(t); }
std::string typeRefStr(const ast::TypeRef& t) { return ast::canonicalType(t); }
bool isFloatType(const std::string& t) {
    // Normal names: smallfloat(16)/float(32)/double(64)/quadruple(128). Bit-counted float32/float64
    // are freestanding-only aliases (enforced elsewhere).
    return t == "float" || t == "float32" || t == "double" || t == "float64" ||
           t == "smallfloat" || t == "quadruple";
}
// THE ADDRESS FAMILY. `address` is 64 bits on every target -- see docs/design/porting.md: a compiler
// that INFERS a width is a compiler that can be wrong about one, so the width is stated and any
// narrowing is a `cast` the author wrote.
//
// The three narrow forms are DOMAIN TYPES, not a portability mechanism. They exist for addresses that
// are genuinely not the machine's pointer: a real-mode 16-bit offset, a 6502 zero page, a physical
// address stored narrow inside a hardware structure. Written `uint16` those are indistinguishable from
// a number, which is exactly the confusion `address` exists to end -- so they are addresses, and they
// carry the same separation from ordinary integers that `address` does.
//
// Spelled as a width word before `address` (`half address`, `short address`, `byte address`), because
// `short` and `byte` already mean 16 and 8. The canonical name closes the space: a type name reaches
// symbol mangling, and a space there is not something a linker can carry.
bool isAddressName(const std::string& t) {
    return t == "address" || t == "halfaddress" || t == "shortaddress" || t == "byteaddress";
}

bool isIntName(const std::string& t) {
    // Normal: byte/short/int/long (signed), ubyte/ushort/uint/ulong (unsigned). Bit-counted
    // int8..int64/uint8..uint64 are freestanding-only aliases (enforced elsewhere). address: raw.
    return t == "int" || t == "int8" || t == "int16" || t == "int32" || t == "int64" ||
           t == "uint8" || t == "uint16" || t == "uint32" || t == "uint64" || t == "short" ||
           t == "long" || t == "byte" || t == "ubyte" || t == "ushort" ||
           t == "uint" || t == "ulong" || isAddressName(t);
}
unsigned intBits(const std::string& t) {
    if (t == "int8" || t == "uint8" || t == "byte" || t == "ubyte" || t == "byteaddress") {
        return 8;
    }
    if (t == "int16" || t == "uint16" || t == "short" || t == "ushort" || t == "shortaddress") {
        return 16;
    }
    if (t == "int64" || t == "uint64" || t == "long" || t == "address" || t == "ulong") {
        return 64;
    }
    return 32;   // int / uint / int32 / uint32 / halfaddress
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
        if (f.bitWidth == 0) {
            return;  // no `: n` at all
        }
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
    if (f.isStatic) {
        error("bit field '" + f.name + "' cannot be static: a static field has one storage location of "
              "its own, which is the opposite of sharing a unit with its neighbours", f.loc);
    }
    if (f.isPersistent) {
        error("bit field '" + f.name + "' cannot be persistent: a persistent field is stored "
              "individually outside the object, so it has no unit to be packed into", f.loc);
    }
    if (f.isWeak || f.isUnique || f.isMovable) {
        error("bit field '" + f.name + "' cannot be weak, unique or movable: those describe ownership "
              "of a referenced object, and a bit field holds bits", f.loc);
    }
    if (f.isLazy) {
        error("bit field '" + f.name + "' cannot be lazy: a lazy field uses its own null value to mean "
              "'not yet computed', and a range of bits has no spare value to spend on that", f.loc);
    }
    if (cls.isUnion) {
        error("bit field '" + f.name + "' cannot be declared in a union: every union member starts at "
              "offset 0, so there is no run of neighbours for it to pack with", f.loc);
    }
}

// True if `init` is an integer literal (optionally negated) whose value fits the integer type
// `target`. A compile-time literal coerces to a narrower type when it fits, so `byte b = 5;` and
// `short s = 300;` are accepted without an explicit cast (the value is known at compile time).
// The value of an integer literal, if that is what this expression is -- `-3`, `0x1f`, `0b1010`,
// `1_000` and plain decimal, with the leading minus folded in. False for anything else, and false
// for a literal too large to read, so a caller never acts on a number that was not there.
//
// Split out of `intLiteralFits` rather than copied: two readers of the same lexeme is two chances
// to disagree about what `0b` means, and this project has paid for that shape more than once.
bool readIntLiteral(const ast::Expr& e, long long& out) {
    const ast::Expr* p = &e;
    bool neg = false;
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(p); u != nullptr && u->op == "-") {
        neg = true;
        p = u->operand.get();
    }
    const auto* lit = dynamic_cast<const ast::IntLiteralExpr*>(p);
    if (lit == nullptr) {
        return false;
    }
    std::string s;
    for (char c : lit->text) {
        if (c != '_') {
            s += c;
        }
    }
    try {
        if (s.size() > 2 && s[0] == '0' && (s[1] == 'b' || s[1] == 'B')) {
            out = std::stoll(s.substr(2), nullptr, 2);
        } else {
            out = std::stoll(s, nullptr, 0);  // 0x / 0 (octal) / decimal
        }
    } catch (...) {
        return false;
    }
    if (neg) {
        out = -out;
    }
    return true;
}

bool intLiteralFits(const ast::Expr& init, const std::string& target) {
    if (!isIntName(target)) {
        return false;
    }
    long long v = 0;
    if (!readIntLiteral(init, v)) {
        // Either not a literal at all, or one this cannot read. The second case must not block:
        // codegen handles the value, and refusing here would reject a program for a limitation of
        // this function.
        return dynamic_cast<const ast::IntLiteralExpr*>(&init) != nullptr ||
               dynamic_cast<const ast::UnaryExpr*>(&init) != nullptr;
    }
    const unsigned bits = intBits(target);
    const bool uns = !target.empty() && target[0] == 'u';
    if (uns) {
        if (v < 0) {
            return false;
        }
        if (bits >= 64) {
            return true;
        }
        return static_cast<unsigned long long>(v) < (1ull << bits);
    }
    if (bits >= 64) {
        return true;
    }
    const long long lo = -(1ll << (bits - 1));
    const long long hi = (1ll << (bits - 1)) - 1;
    return v >= lo && v <= hi;
}

// Whether an `await` (spec 20.2) appears anywhere in an expression / statement / block. Used to
// reject awaiting while holding a mutex (spec 22), which would risk a deadlock.
bool exprHasAwait(const ast::Expr* e);
bool stmtHasAwait(const ast::Stmt* s);
bool blockHasAwait(const ast::Block& b) {
    for (const auto& s : b.statements) {
        if (stmtHasAwait(s.get())) {
            return true;
        }
    }
    return false;
}
bool exprHasAwait(const ast::Expr* e) {
    if (e == nullptr) {
        return false;
    }
    if (dynamic_cast<const ast::AwaitExpr*>(e)) {
        return true;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        return exprHasAwait(b->lhs.get()) || exprHasAwait(b->rhs.get());
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        return exprHasAwait(u->operand.get());
    }
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        if (exprHasAwait(c->callee.get())) {
            return true;
        }
        for (const auto& a : c->args) {
            if (exprHasAwait(a.get())) {
                return true;
            }
        }
        return false;
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        return exprHasAwait(m->object.get());
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        return exprHasAwait(ix->array.get()) || exprHasAwait(ix->index.get());
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(e)) {
        return exprHasAwait(nc->lhs.get()) || exprHasAwait(nc->rhs.get());
    }
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
        return exprHasAwait(ca->operand.get());
    }
    return false;
}
bool stmtHasAwait(const ast::Stmt* s) {
    if (s == nullptr) {
        return false;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        return exprHasAwait(vd->init.get());
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) {
        return exprHasAwait(es->expr.get());
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) {
        return exprHasAwait(rs->value.get());
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        return exprHasAwait(as->value.get());
    }
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
        return exprHasAwait(i->cond.get()) || blockHasAwait(i->thenBlock) ||
               (i->elseBlock && blockHasAwait(*i->elseBlock));
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) {
        return exprHasAwait(w->cond.get()) || blockHasAwait(w->body);
    }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) {
        return blockHasAwait(d->body) || exprHasAwait(d->cond.get());
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) {
        return blockHasAwait(f->body);
    }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) {
        return blockHasAwait(fe->body);
    }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) {
        return blockHasAwait(sy->body);
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(s)) {
        if (blockHasAwait(tr->body)) {
            return true;
        }
        for (const auto& c : tr->catches) {
            if (blockHasAwait(c.body)) {
                return true;
            }
        }
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
    if (t == "int8") {
        return "byte";
    }
    if (t == "int16") {
        return "short";
    }
    if (t == "int32") {
        return "int";
    }
    if (t == "int64") {
        return "long";
    }
    if (t == "uint8") {
        return "ubyte";
    }
    if (t == "uint16") {
        return "ushort";
    }
    if (t == "uint32") {
        return "uint";
    }
    if (t == "uint64") {
        return "ulong";
    }
    if (t == "float32") {
        return "float";
    }
    if (t == "float64") {
        return "double";
    }
    return t;
}

// SIMD vector types vec2/vec3/vec4 (float32 elements). Width (2/3/4) or 0; lane index or -1.
int vecWidth(const std::string& t) {
    if (t == "vec2") {
        return 2;
    }
    if (t == "vec3") {
        return 3;
    }
    if (t == "vec4") {
        return 4;
    }
    return 0;
}
int vecLane(const std::string& m) {
    if (m == "x" || m == "r") {
        return 0;
    }
    if (m == "y" || m == "g") {
        return 1;
    }
    if (m == "z" || m == "b") {
        return 2;
    }
    if (m == "w" || m == "a") {
        return 3;
    }
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
    if (!isTupleType(t)) {
        return out;
    }
    int depth = 0;
    std::string cur;
    for (std::size_t i = 1; i + 1 < t.size(); ++i) {
        const char c = t[i];
        if (c == '(') {
            ++depth;
        }
        if (c == ')') {
            --depth;
        }
        if (c == ',' && depth == 0) {
            out.push_back(cur);
            cur.clear();
        } else {
            cur += c;
        }
    }
    if (!cur.empty()) {
        out.push_back(cur);
    }
    return out;
}
}  // namespace semutil
}  // namespace polaron