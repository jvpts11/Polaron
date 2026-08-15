#include "semantic/comptime.h"

#include <cstdio>
#include <cstdlib>
#include <string>

namespace polaron::comptime {

namespace {

// A compile-time value: an integer, a double, or a string (tagged). Comparisons and
// logical/bitwise ops produce integers; `/` and arithmetic promote to double when
// either operand is double. Strings enable compile-time string DSLs (spec 32.4): a
// `comptime` method can process a `comptime string` and fold to a numeric result.
struct Num {
    bool isDouble = false;
    bool isStr = false;  // when set, `i` is an index into Context::strings (kept small on purpose)
    long long i = 0;
    double d = 0.0;
    static Num I(long long v) { return {false, false, v, 0.0}; }
    static Num D(double v) { return {true, false, 0, v}; }
    static Num Sidx(long long idx) { return {false, true, idx, 0.0}; }
    double dbl() const { return isDouble ? d : static_cast<double>(i); }
    bool truth() const { return isDouble ? (d != 0.0) : (i != 0); }  // a string index is truthy
};

// Interns a string into the context pool and returns a string-valued Num pointing at it.
Num internStr(Context& ctx, std::string v) {
    ctx.strings.push_back(std::move(v));
    return Num::Sidx(static_cast<long long>(ctx.strings.size()) - 1);
}
// The interned text of a string-valued Num.
const std::string& strOf(const Context& ctx, const Num& n) { return ctx.strings[n.i]; }

// Resolves the backslash escapes in a string literal (spec 4.1) for compile-time processing.
std::string unescape(const std::string& raw) {
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

using Env = std::unordered_map<std::string, Num>;

bool parseIntLexeme(const std::string& lexeme, long long& out) {
    std::string s;
    for (char c : lexeme) {
        if (c != '_' && c != 'L' && c != 'l') {
            s += c;
        }
    }
    int base = 10;
    std::size_t start = 0;
    if (s.size() >= 2 && s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) { base = 16; start = 2; }
    else if (s.size() >= 2 && s[0] == '0' && (s[1] == 'b' || s[1] == 'B')) { base = 2; start = 2; }
    try {
        out = static_cast<long long>(std::stoll(s.substr(start), nullptr, base));
        return true;
    } catch (...) {
        try {
            out = static_cast<long long>(std::stoull(s.substr(start), nullptr, base));
            return true;
        } catch (...) {
            return false;
        }
    }
}

bool parseFloatLexeme(const std::string& lexeme, double& out) {
    std::string s;
    for (char ch : lexeme) {
        if (ch != '_' && ch != 'f' && ch != 'F') {
            s += ch;
        }
    }
    try { out = std::stod(s); return true; } catch (...) { return false; }
}

long long charValue(const std::string& s) {
    if (s.empty()) {
        return 0;
    }
    if (s[0] != '\\') {
        return static_cast<unsigned char>(s[0]);
    }
    if (s.size() < 2) {
        return '\\';
    }
    switch (s[1]) {
        case 'n': return '\n';
        case 't': return '\t';
        case 'r': return '\r';
        case '0': return '\0';
        case '\\': return '\\';
        case '\'': return '\'';
        case '"': return '"';
        default: return static_cast<unsigned char>(s[1]);
    }
}

bool eval(const ast::Expr& e, Num& out, Context& ctx, const Env& env);

// Evaluates a compile-time string builtin call (spec 32.4). Returns 1 if handled (out set), -1 if it
// is a string-receiver call that failed, 0 if it is not a string builtin (caller falls through).
int evalStringBuiltin(const ast::CallExpr& call, Num& out, Context& ctx, const Env& env);

bool exec(const ast::Stmt& st, Context& ctx, Env& env, Num& ret, bool& returned);

bool execBlock(const ast::Block& block, Context& ctx, Env& env, Num& ret, bool& returned) {
    for (const ast::StmtPtr& s : block.statements) {
        if (!exec(*s, ctx, env, ret, returned)) {
            return false;
        }
        if (returned) {
            return true;
        }
    }
    return true;
}

// Calls a comptime method with already-evaluated argument values.
bool callMethod(const ast::MethodDecl& m, const std::vector<Num>& args, Num& out, Context& ctx) {
    if (++ctx.steps > ctx.stepLimit) {
        return false;
    }
    if (++ctx.depth > ctx.depthLimit) { --ctx.depth; return false; }  // bound the native stack
    if (m.params.size() != args.size()) { --ctx.depth; return false; }
    Env env;
    for (std::size_t i = 0; i < m.params.size(); ++i) {
        env[m.params[i].name] = args[i];
    }
    Num ret;
    bool returned = false;
    const bool ok = execBlock(m.body, ctx, env, ret, returned);
    --ctx.depth;
    if (!ok || !returned) {
        return false;  // must succeed and produce a value
    }
    out = ret;
    return true;
}

// Resolves a class-level const read as Type.NAME (spec 28.1) against the const maps. Kept out of
// `eval` so it does not enlarge eval's frame on the recursive comptime hot path.
bool evalMemberConst(const ast::MemberExpr& mem, Num& out, Context& ctx) {
    const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem.object.get());
    if (oid == nullptr) {
        return false;
    }
    const std::string key = oid->name + "." + mem.member;
    if (ctx.dconsts != nullptr) {
        if (auto it = ctx.dconsts->find(key); it != ctx.dconsts->end()) { out = Num::D(it->second); return true; }
    }
    if (ctx.consts != nullptr) {
        if (auto it = ctx.consts->find(key); it != ctx.consts->end()) { out = Num::I(it->second); return true; }
    }
    return false;
}

bool eval(const ast::Expr& e, Num& out, Context& ctx, const Env& env) {
    if (++ctx.steps > ctx.stepLimit) {
        return false;
    }

    if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&e)) {
        long long v;
        if (!parseIntLexeme(n->text, v)) {
            return false;
        }
        out = Num::I(v);
        return true;
    }
    if (const auto* f = dynamic_cast<const ast::FloatLiteralExpr*>(&e)) {
        double v;
        if (!parseFloatLexeme(f->text, v)) {
            return false;
        }
        out = Num::D(v);
        return true;
    }
    if (const auto* b = dynamic_cast<const ast::BoolLiteralExpr*>(&e)) { out = Num::I(b->value ? 1 : 0); return true; }
    if (const auto* c = dynamic_cast<const ast::CharLiteralExpr*>(&e)) { out = Num::I(charValue(c->value)); return true; }
    if (const auto* s = dynamic_cast<const ast::StringLiteralExpr*>(&e)) { out = internStr(ctx, unescape(s->value)); return true; }

    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&e)) {
        if (auto it = env.find(id->name); it != env.end()) { out = it->second; return true; }
        if (ctx.dconsts != nullptr) {
            if (auto it = ctx.dconsts->find(id->name); it != ctx.dconsts->end()) { out = Num::D(it->second); return true; }
        }
        if (ctx.consts != nullptr) {
            if (auto it = ctx.consts->find(id->name); it != ctx.consts->end()) { out = Num::I(it->second); return true; }
        }
        return false;
    }

    // A class-level const read as Type.NAME (spec 28.1): keyed by "Owner.NAME". Handled in a separate
    // function so `eval`'s stack frame stays small -- this is on the recursive comptime hot path, and
    // a larger frame would overflow the native stack before the depth budget caught deep recursion.
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&e)) {
        return evalMemberConst(*mem, out, ctx);
    }

    if (const auto* cast = dynamic_cast<const ast::CastExpr*>(&e)) {
        Num v;
        if (!eval(*cast->operand, v, ctx, env)) {
            return false;
        }
        // A cast to an integer type truncates; to a float type promotes.
        const std::string& t = cast->targetType;
        if (t == "float" || t == "float32" || t == "double" || t == "float64") {
            out = Num::D(v.dbl());
        } else {
            out = Num::I(v.isDouble ? static_cast<long long>(v.d) : v.i);
        }
        return true;
    }

    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        Num v;
        if (!eval(*u->operand, v, ctx, env)) {
            return false;
        }
        if (u->op == "-") { out = v.isDouble ? Num::D(-v.d) : Num::I(-v.i); return true; }
        if (u->op == "!") { out = Num::I(v.truth() ? 0 : 1); return true; }
        if (u->op == "~") {
            if (v.isDouble) {
                return false;
            }
            out = Num::I(~v.i);
            return true;
        }
        return false;
    }

    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(&e)) {
        Num c;
        if (!eval(*t->cond, c, ctx, env)) {
            return false;
        }
        return eval(c.truth() ? *t->thenExpr : *t->elseExpr, out, ctx, env);
    }

    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        Num l, r;
        if (!eval(*bin->lhs, l, ctx, env) || !eval(*bin->rhs, r, ctx, env)) {
            return false;
        }
        const std::string& op = bin->op;
        // String operands (spec 32.4 compile-time DSLs): equality and concatenation.
        if (l.isStr || r.isStr) {
            if (!l.isStr || !r.isStr) {
                return false;
            }
            if (op == "==") { out = Num::I(strOf(ctx, l) == strOf(ctx, r) ? 1 : 0); return true; }
            if (op == "!=") { out = Num::I(strOf(ctx, l) != strOf(ctx, r) ? 1 : 0); return true; }
            if (op == "+") { out = internStr(ctx, strOf(ctx, l) + strOf(ctx, r)); return true; }
            return false;
        }
        const bool fp = l.isDouble || r.isDouble;
        // Comparisons and logical operators yield an integer (boolean) result.
        if (op == "==") { out = Num::I((fp ? l.dbl() == r.dbl() : l.i == r.i) ? 1 : 0); return true; }
        if (op == "!=") { out = Num::I((fp ? l.dbl() != r.dbl() : l.i != r.i) ? 1 : 0); return true; }
        if (op == "<")  { out = Num::I((fp ? l.dbl() < r.dbl()  : l.i < r.i)  ? 1 : 0); return true; }
        if (op == ">")  { out = Num::I((fp ? l.dbl() > r.dbl()  : l.i > r.i)  ? 1 : 0); return true; }
        if (op == "<=") { out = Num::I((fp ? l.dbl() <= r.dbl() : l.i <= r.i) ? 1 : 0); return true; }
        if (op == ">=") { out = Num::I((fp ? l.dbl() >= r.dbl() : l.i >= r.i) ? 1 : 0); return true; }
        if (op == "&&") { out = Num::I((l.truth() && r.truth()) ? 1 : 0); return true; }
        if (op == "||") { out = Num::I((l.truth() || r.truth()) ? 1 : 0); return true; }
        if (fp) {  // floating-point arithmetic
            if (op == "+") {
                out = Num::D(l.dbl() + r.dbl());
            } else if (op == "-") {
                out = Num::D(l.dbl() - r.dbl());
            } else if (op == "*") {
                out = Num::D(l.dbl() * r.dbl());
            } else if (op == "/") {
                if (r.dbl() == 0.0) {
                    return false;
                }
                out = Num::D(l.dbl() / r.dbl());
            } else {
                return false;  // %, bitwise, shifts are integer-only
            }
            return true;
        }
        if (op == "+") {
            out = Num::I(l.i + r.i);
        } else if (op == "-") {
            out = Num::I(l.i - r.i);
        } else if (op == "*") {
            out = Num::I(l.i * r.i);
        } else if (op == "/") {
            if (r.i == 0) {
                return false;
            }
            out = Num::I(l.i / r.i);
        } else if (op == "%") {
            if (r.i == 0) {
                return false;
            }
            out = Num::I(l.i % r.i);
        } else if (op == "&") {
            out = Num::I(l.i & r.i);
        } else if (op == "|") {
            out = Num::I(l.i | r.i);
        } else if (op == "^") {
            out = Num::I(l.i ^ r.i);
        } else if (op == "<<") {
            out = Num::I(l.i << r.i);
        } else if (op == ">>") {
            out = Num::I(l.i >> r.i);
        } else {
            return false;
        }
        return true;
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&e)) {
        // Compile-time string builtins (spec 32.4), handled in a separate function so eval's stack
        // frame stays small on the recursive comptime hot path. Only entered when the receiver is a
        // value (a bound local/param, or a nested expression) -- never for a bare `Class.method(...)`
        // user call, so it adds no native-stack depth to deep numeric recursion.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
            if (oid == nullptr || env.count(oid->name) > 0) {
                if (int r = evalStringBuiltin(*call, out, ctx, env); r != 0) {
                    return r == 1;
                }
            }
        }
        // A size, in the two spellings the language keeps (spec issue #7):
        //   `T.sizeof()`     -- the type answers about itself
        //   `Raw.sizeof(x)`  -- a static method on System.Memory.Raw, and the only way to ask about
        //                       an EXPRESSION rather than a named type
        // Neither is a bare word the language reserves. The name being measured is READ, never
        // evaluated -- `Raw.sizeof(float)` has no value to compute. Folds only where the context can
        // answer for the target's layout (see Context::sizeOfType).
        {
            std::string tn;
            if (const auto* sm = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                sm != nullptr && sm->member == "sizeof") {
                const std::string recv = typeNameSpelled(*sm->object);
                if (call->args.size() == 1 && (recv == "Raw" || recv == "System.Memory.Raw")) {
                    tn = typeNameSpelled(*call->args[0]);
                } else if (call->args.empty()) {
                    tn = recv;  // T.sizeof()
                }
            }
            if (!tn.empty()) {
                long long bytes = 0;
                if (!ctx.sizeOfType || !ctx.sizeOfType(tn, bytes)) {
                    return false;
                }
                out = Num::I(bytes);
                return true;
            }
        }

        // `EnumName.count()` (spec 12.5). An enum is a closed set written out in the source, so how
        // many constants it declares is settled the moment it is parsed. Folding it is what lets a
        // demand hold a table's family offsets to the size of the family before them.
        //
        // Only an ENUM answers here. A class with a static `count()` of its own -- a table asking
        // how long it is -- falls through to the ordinary call path below and stays a runtime read.
        if (ctx.enumCount) {
            if (const auto* cm = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                cm != nullptr && cm->member == "count" && call->args.empty()) {
                const std::string recv = typeNameSpelled(*cm->object);
                long long n = 0;
                if (!recv.empty() && ctx.enumCount(recv, n)) { out = Num::I(n); return true; }
            }
        }

        if (ctx.methods == nullptr) {
            return false;
        }
        std::string name;
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            name = cid->name;
        } else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            name = mem->member;  // Class.method(...) -- resolve by method name
        } else {
            return false;
        }
        auto mit = ctx.methods->find(name);
        if (mit == ctx.methods->end()) {
            return false;
        }
        std::vector<Num> args;
        args.reserve(call->args.size());
        for (const ast::ExprPtr& a : call->args) {
            Num v;
            if (!eval(*a, v, ctx, env)) {
                return false;
            }
            args.push_back(v);
        }
        return callMethod(*mit->second, args, out, ctx);
    }

    return false;
}

int evalStringBuiltin(const ast::CallExpr& call, Num& out, Context& ctx, const Env& env) {
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(call.callee.get());
    if (mem == nullptr) {
        return 0;
    }
    // THE NAME IS CHECKED BEFORE THE RECEIVER IS EVALUATED, and that ordering is the whole
    // difference between linear and exponential.
    //
    // Evaluating the receiver means evaluating everything to its left, and the receiver of a method
    // this function cannot fold is evaluated for nothing. On a chain -- `a.concat(b).concat(c)...`,
    // which is how anybody writes a long literal -- that wasted evaluation happens at EVERY level,
    // and each one re-evaluates the whole chain below it. Measured before this: eight links compiled
    // in 482 ms, fourteen took 34 SECONDS, and twenty never finished. `concat` is not foldable (it
    // would have to allocate a string in the compiler), so every one of those evaluations was thrown
    // away the moment it returned.
    //
    // Asking "can I use this?" first costs a string comparison.
    {
        const std::string& m = mem->member;
        const bool foldable = m == "length" || m == "isEmpty" || m == "charAt" || m == "equals" ||
                              m == "indexOf" || m == "substring";
        if (!foldable) {
            return 0;
        }
    }
    Num recv;
    if (!eval(*mem->object, recv, ctx, env) || !recv.isStr) {
        return 0;  // not a string receiver
    }
    std::vector<Num> a;
    for (const ast::ExprPtr& arg : call.args) {
        Num v;
        if (!eval(*arg, v, ctx, env)) {
            return -1;
        }
        a.push_back(v);
    }
    const std::string& s = strOf(ctx, recv);
    const std::string& m = mem->member;
    const long long len = static_cast<long long>(s.size());
    if (m == "length" && a.empty()) { out = Num::I(len); return 1; }
    if (m == "isEmpty" && a.empty()) { out = Num::I(s.empty() ? 1 : 0); return 1; }
    if (m == "charAt" && a.size() == 1 && !a[0].isStr && !a[0].isDouble) {
        if (a[0].i < 0 || a[0].i >= len) {
            return -1;
        }
        out = Num::I(static_cast<unsigned char>(s[a[0].i]));
        return 1;
    }
    if (m == "equals" && a.size() == 1 && a[0].isStr) {
        out = Num::I(s == strOf(ctx, a[0]) ? 1 : 0);
        return 1;
    }
    if (m == "substring" && a.size() == 2 && !a[0].isStr && !a[1].isStr) {
        if (a[0].i < 0 || a[1].i > len || a[0].i > a[1].i) {
            return -1;
        }
        out = internStr(ctx, s.substr(a[0].i, a[1].i - a[0].i));
        return 1;
    }
    if (m == "indexOf" && a.size() == 1 && a[0].isStr) {
        const auto p = s.find(strOf(ctx, a[0]));
        out = Num::I(p == std::string::npos ? -1 : static_cast<long long>(p));
        return 1;
    }
    return -1;  // a string receiver but an unsupported builtin
}

bool exec(const ast::Stmt& st, Context& ctx, Env& env, Num& ret, bool& returned) {
    if (++ctx.steps > ctx.stepLimit) {
        return false;
    }

    if (const auto* r = dynamic_cast<const ast::ReturnStmt*>(&st)) {
        if (r->value == nullptr) {
            return false;  // a value-returning comptime function
        }
        if (!eval(*r->value, ret, ctx, env)) {
            return false;
        }
        returned = true;
        return true;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&st)) {
        Num v;
        if (vd->init == nullptr || !eval(*vd->init, v, ctx, env)) {
            return false;
        }
        env[vd->name] = v;
        return true;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(&st)) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get());
        if (id == nullptr) {
            return false;  // only local-variable assignment is comptime
        }
        Num v;
        if (!eval(*as->value, v, ctx, env)) {
            return false;
        }
        env[id->name] = v;
        return true;
    }
    if (const auto* idc = dynamic_cast<const ast::IncDecStmt*>(&st)) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(idc->target.get());
        if (id == nullptr) {
            return false;
        }
        auto it = env.find(id->name);
        if (it == env.end()) {
            return false;
        }
        if (it->second.isDouble) {
            it->second.d += idc->isIncrement ? 1.0 : -1.0;
        } else {
            it->second.i += idc->isIncrement ? 1 : -1;
        }
        return true;
    }
    if (const auto* iff = dynamic_cast<const ast::IfStmt*>(&st)) {
        Num c;
        if (!eval(*iff->cond, c, ctx, env)) {
            return false;
        }
        if (c.truth()) {
            return execBlock(iff->thenBlock, ctx, env, ret, returned);
        }
        if (iff->elseBlock) {
            return execBlock(*iff->elseBlock, ctx, env, ret, returned);
        }
        return true;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(&st)) {
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) {
                return false;
            }
            Num c;
            if (!eval(*w->cond, c, ctx, env)) {
                return false;
            }
            if (!c.truth()) {
                return true;
            }
            if (!execBlock(w->body, ctx, env, ret, returned)) {
                return false;
            }
            if (returned) {
                return true;
            }
        }
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&st)) {
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) {
                return false;
            }
            if (!execBlock(dw->body, ctx, env, ret, returned)) {
                return false;
            }
            if (returned) {
                return true;
            }
            Num c;
            if (!eval(*dw->cond, c, ctx, env)) {
                return false;
            }
            if (!c.truth()) {
                return true;
            }
        }
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(&st)) {
        if (f->init != nullptr && !exec(*f->init, ctx, env, ret, returned)) {
            return false;
        }
        if (returned) {
            return true;
        }
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) {
                return false;
            }
            if (f->cond != nullptr) {
                Num c;
                if (!eval(*f->cond, c, ctx, env)) {
                    return false;
                }
                if (!c.truth()) {
                    return true;
                }
            }
            if (!execBlock(f->body, ctx, env, ret, returned)) {
                return false;
            }
            if (returned) {
                return true;
            }
            if (f->update != nullptr && !exec(*f->update, ctx, env, ret, returned)) {
                return false;
            }
        }
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&st)) {
        Num v;
        return eval(*es->expr, v, ctx, env);  // a call evaluated for its (pure) value
    }
    return false;  // any other statement is not comptime-evaluable
}

}  // namespace

bool evalInt(const ast::Expr& e, long long& out, Context& ctx) {
    Num n;
    if (!eval(e, n, ctx, Env{})) {
        return false;
    }
    if (n.isDouble || n.isStr) {
        return false;  // an integer context rejects a double/string result
    }
    out = n.i;
    return true;
}

bool evalDouble(const ast::Expr& e, double& out, Context& ctx) {
    Num n;
    if (!eval(e, n, ctx, Env{})) {
        return false;
    }
    if (n.isStr) {
        return false;
    }
    out = n.dbl();
    return true;
}

std::string typeNameSpelled(const ast::Expr& e) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&e)) {
        return id->name;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&e)) {
        const std::string base = typeNameSpelled(*mem->object);
        return base.empty() ? std::string() : base + "." + mem->member;
    }
    return {};  // anything else is a value expression, not a type name
}

bool mentionsSizeof(const ast::Expr& e) {
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&e)) {
        // Both kept spellings: `Memory.sizeof(x)` and `T.sizeof()`.
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            mem != nullptr && mem->member == "sizeof" && !typeNameSpelled(*mem->object).empty()) {
            return true;
        }
        if (call->callee && mentionsSizeof(*call->callee)) {
            return true;
        }
        for (const ast::ExprPtr& a : call->args) {
            if (a && mentionsSizeof(*a)) {
                return true;
            }
        }
        return false;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        return (b->lhs && mentionsSizeof(*b->lhs)) || (b->rhs && mentionsSizeof(*b->rhs));
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        return u->operand && mentionsSizeof(*u->operand);
    }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(&e)) {
        return (t->cond && mentionsSizeof(*t->cond)) || (t->thenExpr && mentionsSizeof(*t->thenExpr)) ||
               (t->elseExpr && mentionsSizeof(*t->elseExpr));
    }
    if (const auto* c = dynamic_cast<const ast::CastExpr*>(&e)) {
        return c->operand && mentionsSizeof(*c->operand);
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&e)) {
        return (nc->lhs && mentionsSizeof(*nc->lhs)) || (nc->rhs && mentionsSizeof(*nc->rhs));
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(&e)) {
        return m->object && mentionsSizeof(*m->object);
    }
    // Any other node cannot currently carry a sizeof into a constant expression. Answering `false`
    // here is the safe direction: the analyzer then reports the non-constant condition itself,
    // exactly as it did before, rather than deferring a check that would never run.
    return false;
}

}  // namespace polaron::comptime
