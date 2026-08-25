// The definitions of codegen's pure helpers. See cgutil.h for what makes them a unit: nothing in this
// file mentions llvm.
//
// Moved out of codegen.cpp verbatim, so a `git blame` on any line still lands on the change that wrote
// it rather than on the move.

#include "codegen/cgutil.h"

#include <algorithm>
#include <cctype>
#include <cstddef>
#include <string>

namespace polaron {
namespace cgutil {
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
    for (const auto& st : b.statements) {
        collectRefs(st.get(), out);
    }
}

void collectRefs(const ast::Expr* e, std::set<std::string>& out) {
    if (!e) {
        return;
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) { out.insert(id->name); return; }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) { collectRefs(m->object.get(), out); return; }
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        collectRefs(c->callee.get(), out);
        for (const auto& a : c->args) {
            collectRefs(a.get(), out);
        }
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) { collectRefs(b->lhs.get(), out); collectRefs(b->rhs.get(), out); return; }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) { collectRefs(u->operand.get(), out); return; }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) { collectRefs(t->cond.get(), out); collectRefs(t->thenExpr.get(), out); collectRefs(t->elseExpr.get(), out); return; }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(e)) { collectRefs(nc->lhs.get(), out); collectRefs(nc->rhs.get(), out); return; }
    if (const auto* idx = dynamic_cast<const ast::IndexExpr*>(e)) { collectRefs(idx->array.get(), out); collectRefs(idx->index.get(), out); return; }
    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(e)) {
        for (const auto& a : nw->args) {
            collectRefs(a.get(), out);
        }
        return;
    }
    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(e)) { collectRefs(na->size.get(), out); return; }
    if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(e)) {
        for (const auto& x : al->elements) {
            collectRefs(x.get(), out);
        }
        return;
    }
    if (const auto* tp = dynamic_cast<const ast::TupleExpr*>(e)) {
        for (const auto& x : tp->elements) {
            collectRefs(x.get(), out);
        }
        return;
    }
    if (const auto* is = dynamic_cast<const ast::InterpStringExpr*>(e)) {
        for (const auto& x : is->exprs) {
            collectRefs(x.get(), out);
        }
        return;
    }
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
        if (mx->defaultBody) {
            collectRefs(*mx->defaultBody, out);
        }
        return;
    }
    // literals and other leaf expressions contribute no identifiers
}

void collectRefs(const ast::Stmt* s, std::set<std::string>& out) {
    if (!s) {
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) { collectRefs(es->expr.get(), out); return; }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) { collectRefs(rs->value.get(), out); return; }
    if (const auto* ys = dynamic_cast<const ast::YieldStmt*>(s)) { collectRefs(ys->value.get(), out); return; }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) { collectRefs(vd->init.get(), out); return; }
    if (const auto* td = dynamic_cast<const ast::TupleDeclStmt*>(s)) { collectRefs(td->init.get(), out); return; }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) { collectRefs(as->target.get(), out); collectRefs(as->value.get(), out); return; }
    if (const auto* ic = dynamic_cast<const ast::IncDecStmt*>(s)) { collectRefs(ic->target.get(), out); return; }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
        collectRefs(ifs->cond.get(), out);
        collectRefs(ifs->thenBlock, out);
        if (ifs->elseBlock) {
            collectRefs(*ifs->elseBlock, out);
        }
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) { collectRefs(ws->cond.get(), out); collectRefs(ws->body, out); return; }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(s)) { collectRefs(dw->body, out); collectRefs(dw->cond.get(), out); return; }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) { collectRefs(fs->init.get(), out); collectRefs(fs->cond.get(), out); collectRefs(fs->update.get(), out); collectRefs(fs->body, out); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) { collectRefs(fe->iterable.get(), out); collectRefs(fe->body, out); return; }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(s)) { collectRefs(df->within.get(), out); collectRefs(df->body, out); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(s)) { collectRefs(us->decl.get(), out); collectRefs(us->body, out); return; }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) { collectRefs(sy->mutex.get(), out); collectRefs(sy->body, out); return; }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
        collectRefs(ms->subject.get(), out);
        for (const auto& cs : ms->cases) {
            collectRefs(cs.result.get(), out);
            collectRefs(cs.body, out);
        }
        if (ms->defaultBody) {
            collectRefs(*ms->defaultBody, out);
        }
        return;
    }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
        collectRefs(sw->subject.get(), out);
        for (const auto& cs : sw->cases) {
            collectRefs(cs.value.get(), out);
            collectRefs(cs.body, out);
        }
        if (sw->defaultBody) {
            collectRefs(*sw->defaultBody, out);
        }
        return;
    }
    if (const auto* th = dynamic_cast<const ast::ThrowStmt*>(s)) { collectRefs(th->value.get(), out); return; }
    if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) {
        collectRefs(ts->body, out);
        for (const auto& c : ts->catches) {
            collectRefs(c.body, out);
        }
        if (ts->finallyBlock) {
            collectRefs(*ts->finallyBlock, out);
        }
        return;
    }
    if (const auto* ls = dynamic_cast<const ast::LabeledStmt*>(s)) { collectRefs(ls->stmt.get(), out); return; }
    if (const auto* dl = dynamic_cast<const ast::DeleteStmt*>(s)) {
        collectRefs(dl->target.get(), out);
        for (const auto& mt : dl->moreTargets) {
            collectRefs(mt.get(), out);
        }
        return;
    }
    // leaf statements (break/continue/goto/label/asm/...) contribute no identifiers
}

// How each `region` FIELD is created, keyed "Class.field". A field region assigned
// `itself.allocate(...)` owns its block, so that block can carry the descriptor header (and with it a
// destructor registry); `itself.at(...)` / `atMultiple` point at memory somebody else owns, so their
// header stays the lean 24 bytes and they get no registry.
//
// This is a pre-pass and not a decision made while emitting, because the METHODS that allocate into a
// field region are emitted in whatever order the classes appear -- possibly before the constructor that
// creates it. Every site has to agree about the header shape before any of them is emitted; disagreeing
// would mean one of them writing a registry pointer over the region's first object.

void scanFieldRegions(const ast::Stmt* s, const std::string& cls, FieldRegionKinds& out);
void scanFieldRegions(const ast::Block& b, const std::string& cls, FieldRegionKinds& out) {
    for (const auto& st : b.statements) {
        scanFieldRegions(st.get(), cls, out);
    }
}
void scanFieldRegions(const ast::Stmt* s, const std::string& cls, FieldRegionKinds& out) {
    if (!s) {
        return;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        const auto* mt = dynamic_cast<const ast::MemberExpr*>(as->target.get());
        const auto* ri = dynamic_cast<const ast::RegionInitExpr*>(as->value.get());
        const auto* recv = mt ? dynamic_cast<const ast::IdentifierExpr*>(mt->object.get()) : nullptr;
        if (mt != nullptr && ri != nullptr && recv != nullptr && recv->name == "this") {
            const std::string key = cls + "." + mt->member;
            if (ri->atAddress != nullptr || !ri->ranges.empty()) {
                out.external.insert(key);
            } else {
                out.owned.insert(key);
            }
        }
        return;
    }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
        scanFieldRegions(ifs->thenBlock, cls, out);
        if (ifs->elseBlock) {
            scanFieldRegions(*ifs->elseBlock, cls, out);
        }
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) { scanFieldRegions(ws->body, cls, out); return; }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(s)) { scanFieldRegions(dw->body, cls, out); return; }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) { scanFieldRegions(fs->init.get(), cls, out); scanFieldRegions(fs->body, cls, out); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(s)) { scanFieldRegions(fe->body, cls, out); return; }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(s)) { scanFieldRegions(df->body, cls, out); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(s)) { scanFieldRegions(us->decl.get(), cls, out); scanFieldRegions(us->body, cls, out); return; }
    if (const auto* sy = dynamic_cast<const ast::SynchronizedStmt*>(s)) { scanFieldRegions(sy->body, cls, out); return; }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(s)) {
        for (const auto& c : ms->cases) {
            scanFieldRegions(c.body, cls, out);
        }
        if (ms->defaultBody) {
            scanFieldRegions(*ms->defaultBody, cls, out);
        }
        return;
    }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(s)) {
        for (const auto& c : sw->cases) {
            scanFieldRegions(c.body, cls, out);
        }
        if (sw->defaultBody) {
            scanFieldRegions(*sw->defaultBody, cls, out);
        }
        return;
    }
    if (const auto* ts = dynamic_cast<const ast::TryStmt*>(s)) {
        scanFieldRegions(ts->body, cls, out);
        for (const auto& c : ts->catches) {
            scanFieldRegions(c.body, cls, out);
        }
        if (ts->finallyBlock) {
            scanFieldRegions(*ts->finallyBlock, cls, out);
        }
        return;
    }
    if (const auto* ls = dynamic_cast<const ast::LabeledStmt*>(s)) { scanFieldRegions(ls->stmt.get(), cls, out); return; }
    // Every other statement kind either cannot contain an assignment or cannot contain THIS one.
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
                // \xNN -- one byte by its hex value. Without it a `b"..."` literal, whose whole purpose
                // is RAW BYTES, could only express printable ASCII: the pico kernel hit this writing
                // machine code for a user-mode trampoline, where `b"\x48\x63\xC1\xC3"` silently became
                // the four characters `x`, `4`, `8`, `x` and the guest executed them.
                //
                // One or two digits, so `\x0` and `\x48` both work and `\x48ff` is a byte followed by
                // text. An unparseable `\x` keeps its old meaning (a literal 'x') rather than becoming
                // an error, because that is what any existing source containing one already means.
                case 'x': {
                    auto hexVal = [](char c) -> int {
                        if (c >= '0' && c <= '9') {
                            return c - '0';
                        }
                        if (c >= 'a' && c <= 'f') {
                            return c - 'a' + 10;
                        }
                        if (c >= 'A' && c <= 'F') {
                            return c - 'A' + 10;
                        }
                        return -1;
                    };
                    if (i + 1 < raw.size() && hexVal(raw[i + 1]) >= 0) {
                        int v = hexVal(raw[++i]);
                        if (i + 1 < raw.size() && hexVal(raw[i + 1]) >= 0) {
                            v = v * 16 + hexVal(raw[++i]);
                        }
                        out += static_cast<char>(static_cast<unsigned char>(v));
                    } else {
                        out += 'x';
                    }
                    break;
                }
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
        if (c == '_' || c == 'L' || c == 'l') {
            continue;
        }
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

std::string archFamily(const std::string& name) {
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

std::string archOfTriple(const std::string& triple) {
    const size_t dash = triple.find('-');
    return dash == std::string::npos ? triple : triple.substr(0, dash);
}

// Array types are spelled with a trailing "[]" (e.g. "int[]", "char[]").
bool isArrayType(const std::string& t) {
    return t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0;
}
// `T[N]`: the extent stated in the type, or 0. Mirrors semutil's copy -- see the note at the top of
// semutil.h about the deliberate duplication of these name questions.
// `T[N]`: the extent stated in the type, or 0. Reads the FIRST bracket group -- the OUTER one, so
// `int[3][4]` is three of `int[4]`, as C, Java and C# all read it. Mirrors semutil's copy; see the
// note there about the deliberate duplication of these name questions.
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
// The element type of an array type ("int[]" -> "int", "int[16]" -> "int", "int[3][4]" -> "int[4]").
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

// Floating-point types. `float`/`float32` lower to f32; `double`/`float64` to f64.
bool isFloatType(const std::string& t) {
    return t == "float" || t == "float32" || t == "double" || t == "float64" ||
           t == "smallfloat" || t == "quadruple";
}
bool isF32(const std::string& t) { return t == "float" || t == "float32"; }
// The number of fractional digits the Decimal primitive keeps: its value is the integer mantissa
// times 10^-DECIMAL_SCALE (spec 34). 10^18 fits the fraction in an i64, easing formatting.

// Scales a decimal lexeme (e.g. "1.50") to its integer mantissa as a base-10 digit string
// ("1500000000000000000"), padding or truncating the fraction to DECIMAL_SCALE digits.
std::string decimalScaledString(const std::string& text) {
    std::string s;
    for (char c : text) {
        if (c != '_') {
            s += c;
        }
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
    if (intPart.empty()) {
        intPart = "0";
    }
    if (fracPart.size() > static_cast<std::size_t>(DECIMAL_SCALE)) {
        fracPart = fracPart.substr(0, DECIMAL_SCALE);
    }
    while (fracPart.size() < static_cast<std::size_t>(DECIMAL_SCALE)) {
        fracPart += '0';
    }
    return (neg ? "-" : "") + intPart + fracPart;
}
// Bit width of a float type: smallfloat=16, float=32, double=64, quadruple=128.
unsigned floatBits(const std::string& t) {
    if (t == "smallfloat") {
        return 16;
    }
    if (t == "quadruple") {
        return 128;
    }
    if (t == "double" || t == "float64") {
        return 64;
    }
    return 32;  // float / float32
}

// Bit width of an integer-family type (int/char/boolean/enum default to 32).
// Must agree with the analyzer's own intBits (src/semantic/semutil.cpp) -- including the narrow
// address family, whose whole reason for existing is that a 16-bit address really is sixteen bits.
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

// Unsigned integer types. One definition, in ast.h, because the analyzer needs the same answer and a
// second copy of "is `byte` signed?" is a disagreement waiting to happen (it is: int8, spec 5).
bool isUnsigned(const std::string& t) { return ast::isUnsignedIntName(t); }

// Integer-family type names (matches the analyzer's isIntName).
bool isIntName(const std::string& t) {
    return t == "int" || t == "int8" || t == "int16" || t == "int32" || t == "int64" ||
           t == "uint8" || t == "uint16" || t == "uint32" || t == "uint64" || t == "short" ||
           t == "long" || t == "byte" || t == "address" || t == "ubyte" || t == "ushort" ||
           t == "uint" || t == "ulong" ||
           t == "halfaddress" || t == "shortaddress" || t == "byteaddress";
}

// SIMD vector types vec2/vec3/vec4 (float32 elements). Returns the element count, or 0.
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
// The explicit overflow-mode integer methods (spec 3.6): wrapping/unchecked wrap, saturating clamps.
bool isIntOverflowMethod(const std::string& m) {
    return m == "wrappingAdd" || m == "wrappingSub" || m == "wrappingMul" || m == "wrappingDiv" ||
           m == "saturatingAdd" || m == "saturatingSub" || m == "saturatingMul" ||
           m == "uncheckedAdd" || m == "uncheckedSub" || m == "uncheckedMul" || m == "uncheckedDiv";
}
// Named vector lane accessor: .x/.y/.z/.w (or .r/.g/.b/.a). Returns the index, or -1.
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

// Approximate byte size of a type, used to size a union's shared storage.
// Pointers/refs/arrays/classes are pointer-sized.
unsigned byteSizeOf(const std::string& t) {
    if (isFloatType(t)) {
        return floatBits(t) / 8;  // smallfloat=2 float=4 double=8 quadruple=16
    }
    if (int w = vecWidth(t)) {
        return static_cast<unsigned>(4 * w);  // vecN: N float32 elements
    }
    if (t == "mat4") {
        return 64;  // <16 x float>
    }
    if (!t.empty() &&
        (t.back() == '*' || t.back() == '&' || (t.size() >= 2 && t.compare(t.size() - 2, 2, "[]") == 0))) {
        return 8;  // pointer-sized (pointer / reference / array)
    }
    if (isIntName(t)) {
        return intBits(t) / 8;  // int family
    }
    if (t == "char" || t == "boolean") {
        return 4;  // i32-backed
    }
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
    if (t.rfind("Result$", 0) != 0 && t.rfind("Option$", 0) != 0) {
        return false;
    }
    // Slice 1/2 pack the payload into a 64-bit slot, so keep boxed anything that does not fit: pointer/ref
    // payloads (also mangling-ambiguous), Decimal (i128), and tuple payloads (an aggregate). A proper
    // per-instance sized payload (sret) for these is deferred.
    return t.find('*') == std::string::npos && t.find('&') == std::string::npos &&
           !ast::typeIsNullable(t) && t.find("Decimal") == std::string::npos &&
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
std::string baseType(const std::string& t) {
    std::string s = ast::stripNullable(t);     // drop the `nullable ` prefix (spec 3.7)
    // Strip ONE trailing pointer/reference marker (the outer T*/T&). Not a loop: a generic instantiated
    // with a pointer type argument mangles to a name that itself ends in '*' (e.g. HashMap<..,ArrayList<int>*>*
    // -> "HashMap$..$ArrayList$int**"), and only the outermost '*' is the receiver's own pointer; the rest
    // belong to the registered instantiation's name.
    if (!s.empty() && (s.back() == '*' || s.back() == '&')) {
        s.pop_back();
    }
    return s;
}

// The Polaron type name of a declaration, including array / pointer / ref markers.
// Generic arguments are mangled into the name (Box<int> -> "Box$int").
std::string typeRefName(const ast::TypeRef& t) { return ast::canonicalType(t); }

// ---- Escape analysis for a returned local (see cgutil.h) ----
void collectReturnedNames(const ast::Stmt* st, std::set<std::string>& out) {
    if (st == nullptr) {
        return;
    }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(st)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(rs->value.get())) {
            out.insert(id->name);
        }
        return;
    }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            collectReturnedNames(s.get(), out);
        }
    };
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(st)) {
        blk(i->thenBlock);
        if (i->elseBlock) {
            blk(*i->elseBlock);
        }
        return;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) { blk(w->body); return; }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) { blk(d->body); return; }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) { blk(f->body); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) { blk(fe->body); return; }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
        for (auto& c : sw->cases) {
            blk(c.body);
        }
        if (sw->defaultBody) {
            blk(*sw->defaultBody);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
        for (auto& c : ms->cases) {
            blk(c.body);
        }
        if (ms->defaultBody) {
            blk(*ms->defaultBody);
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
        blk(tr->body);
        for (auto& c : tr->catches) {
            blk(c.body);
        }
        if (tr->finallyBlock) {
            blk(*tr->finallyBlock);
        }
        return;
    }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) { blk(df->body); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) { blk(us->body); return; }
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { collectReturnedNames(lb->stmt.get(), out); return; }
}

void collectOld(const ast::Expr* e, std::vector<const ast::OldExpr*>& out) {
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

void promoteEscapingNews(const ast::Stmt* st, const std::set<std::string>& returned,
                         const std::function<bool(const std::string&)>& lives) {
    if (st == nullptr) {
        return;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) {
        if (returned.count(vd->name) > 0) {
            if (const auto* cnw = dynamic_cast<const ast::NewExpr*>(vd->init.get())) {
                // NOT A REGION CLASS, whose instances already outlive the frame -- they come from
                // the type's own region, released at program exit. Promoting one to the heap made
                // the emitter refuse the very line the author wrote: `Node* one = new Node(v); ...
                // return one;` reported "`Node` is a region class, so `on heap` has nowhere to put
                // this", pointing at a `new` with no placement on it. The compiler had written the
                // placement and then blamed the author for it.
                //
                // A region class has no promoting to do: escape is what its region is FOR.
                if (cnw->location == "stack" && cnw->region.empty() &&
                    !(lives && lives(cnw->className))) {
                    const_cast<ast::NewExpr*>(cnw)->location = "heap";
                }
            }
        }
        return;
    }
    auto blk = [&](const ast::Block& b) {
        for (const auto& s : b.statements) {
            promoteEscapingNews(s.get(), returned, lives);
        }
    };
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(st)) {
        blk(i->thenBlock);
        if (i->elseBlock) {
            blk(*i->elseBlock);
        }
        return;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(st)) { blk(w->body); return; }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(st)) { blk(d->body); return; }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(st)) { blk(f->body); return; }
    if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) { blk(fe->body); return; }
    if (const auto* sw = dynamic_cast<const ast::SwitchStmt*>(st)) {
        for (auto& c : sw->cases) {
            blk(c.body);
        }
        if (sw->defaultBody) {
            blk(*sw->defaultBody);
        }
        return;
    }
    if (const auto* ms = dynamic_cast<const ast::MatchStmt*>(st)) {
        for (auto& c : ms->cases) {
            blk(c.body);
        }
        if (ms->defaultBody) {
            blk(*ms->defaultBody);
        }
        return;
    }
    if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st)) {
        blk(tr->body);
        for (auto& c : tr->catches) {
            blk(c.body);
        }
        if (tr->finallyBlock) {
            blk(*tr->finallyBlock);
        }
        return;
    }
    if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) { blk(df->body); return; }
    if (const auto* us = dynamic_cast<const ast::UsingStmt*>(st)) { blk(us->body); return; }
    if (const auto* lb = dynamic_cast<const ast::LabeledStmt*>(st)) { promoteEscapingNews(lb->stmt.get(), returned, lives); return; }
}

// ---- Which invariants a method's exits have to re-check (see cgutil.h) ----

bool mentionsCall(const ast::Expr* e) {
    if (e == nullptr) {
        return false;
    }
    if (dynamic_cast<const ast::CallExpr*>(e) != nullptr) {
        return true;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        return mentionsCall(b->lhs.get()) || mentionsCall(b->rhs.get());
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        return mentionsCall(u->operand.get());
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        return mentionsCall(ix->array.get()) || mentionsCall(ix->index.get());
    }
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(e)) {
        return mentionsCall(c->operand.get());
    }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) {
        return mentionsCall(t->cond.get()) || mentionsCall(t->thenExpr.get()) ||
               mentionsCall(t->elseExpr.get());
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        return mentionsCall(m->object.get());
    }
    return false;
}

// Whether an expression names `old(...)` -- the state at a method's ENTRY. Where the CALLER stands
// that means before the call, and nothing there snapshotted it, so such a clause cannot be handed
// to the optimiser at a call site however cheap the rest of it is.
bool mentionsOld(const ast::Expr* e) {
    if (e == nullptr) {
        return false;
    }
    if (dynamic_cast<const ast::OldExpr*>(e) != nullptr) {
        return true;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        return mentionsOld(b->lhs.get()) || mentionsOld(b->rhs.get());
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        return mentionsOld(u->operand.get());
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        return mentionsOld(ix->array.get()) || mentionsOld(ix->index.get());
    }
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(e)) {
        return mentionsOld(c->operand.get());
    }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) {
        return mentionsOld(t->cond.get()) || mentionsOld(t->thenExpr.get()) ||
               mentionsOld(t->elseExpr.get());
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(e)) {
        return mentionsOld(mem->object.get());
    }
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(e)) {
        if (mentionsOld(call->callee.get())) {
            return true;
        }
        for (const auto& a : call->args) {
            if (mentionsOld(a.get())) {
                return true;
            }
        }
    }
    return false;
}

bool hasAnnotation(const ast::MethodDecl& m, const std::string& name) {
    for (const ast::AnnotationUse& a : m.annotations) {
        if (a.name == name) {
            return true;
        }
    }
    return false;
}

void collectThisFields(const ast::Expr* e, std::set<std::string>& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        if (const auto* o = dynamic_cast<const ast::IdentifierExpr*>(m->object.get())) {
            if (o->name == "this") {
                out.insert(m->member);
            }
        }
        collectThisFields(m->object.get(), out);
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) { collectThisFields(b->lhs.get(), out); collectThisFields(b->rhs.get(), out); return; }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) { collectThisFields(u->operand.get(), out); return; }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) { collectThisFields(ix->array.get(), out); collectThisFields(ix->index.get(), out); return; }
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(e)) { collectThisFields(c->operand.get(), out); return; }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) { collectThisFields(t->cond.get(), out); collectThisFields(t->thenExpr.get(), out); collectThisFields(t->elseExpr.get(), out); return; }
    if (const auto* ca = dynamic_cast<const ast::CallExpr*>(e)) {
        collectThisFields(ca->callee.get(), out);
        for (const auto& a : ca->args) {
            collectThisFields(a.get(), out);
        }
        return;
    }
}

static bool stmtAssignsThisField(const ast::Stmt* s, const std::set<std::string>& fields) {
    if (s == nullptr) {
        return false;
    }
    auto targets = [&](const ast::Expr* t) {
        std::set<std::string> hit;
        collectThisFields(t, hit);
        for (const std::string& f : hit) {
            if (fields.count(f) > 0) {
                return true;
            }
        }
        return false;
    };
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) { return targets(as->target.get()); }
    if (const auto* idd = dynamic_cast<const ast::IncDecStmt*>(s)) { return targets(idd->target.get()); }
    if (const auto* blk = dynamic_cast<const ast::Block*>(s)) { return blockAssignsThisField(*blk, fields); }
    if (const auto* i = dynamic_cast<const ast::IfStmt*>(s)) {
        return blockAssignsThisField(i->thenBlock, fields) ||
               (i->elseBlock && blockAssignsThisField(*i->elseBlock, fields));
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(s)) { return stmtAssignsThisField(f->init.get(), fields) || stmtAssignsThisField(f->update.get(), fields) || blockAssignsThisField(f->body, fields); }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(s)) { return blockAssignsThisField(w->body, fields); }
    if (const auto* d = dynamic_cast<const ast::DoWhileStmt*>(s)) { return blockAssignsThisField(d->body, fields); }
    // Anything unrecognised is assumed to write, so the check stays.
    return !dynamic_cast<const ast::ExprStmt*>(s) && !dynamic_cast<const ast::VarDeclStmt*>(s) &&
           !dynamic_cast<const ast::ReturnStmt*>(s) && !dynamic_cast<const ast::BreakStmt*>(s) &&
           !dynamic_cast<const ast::ContinueStmt*>(s);
}

bool blockAssignsThisField(const ast::Block& b, const std::set<std::string>& fields) {
    for (const auto& s : b.statements) {
        if (stmtAssignsThisField(s.get(), fields)) {
            return true;
        }
    }
    return false;
}

bool invariantCanBreakIn(const ast::Expr* invariant, const ast::Block& body) {
    std::set<std::string> fields;
    collectThisFields(invariant, fields);
    // AN INVARIANT THAT MENTIONS NO FIELD is about something this analysis cannot see, so it is
    // kept: the conservative answer is the one that leaves the check in.
    return fields.empty() || blockAssignsThisField(body, fields);
}

}  // namespace cgutil
}  // namespace polaron
