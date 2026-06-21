#include "semantic/comptime.h"

#include <string>

namespace ldp3::comptime {

namespace {

// A compile-time number: either an integer or a double (tagged). Comparisons and
// logical/bitwise ops produce integers; `/` and arithmetic promote to double when
// either operand is double.
struct Num {
    bool isDouble = false;
    long long i = 0;
    double d = 0.0;
    static Num I(long long v) { return {false, v, 0.0}; }
    static Num D(double v) { return {true, 0, v}; }
    double dbl() const { return isDouble ? d : static_cast<double>(i); }
    bool truth() const { return isDouble ? (d != 0.0) : (i != 0); }
};

using Env = std::unordered_map<std::string, Num>;

bool parseIntLexeme(const std::string& lexeme, long long& out) {
    std::string s;
    for (char c : lexeme)
        if (c != '_' && c != 'L' && c != 'l') s += c;
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
    for (char ch : lexeme)
        if (ch != '_' && ch != 'f' && ch != 'F') s += ch;
    try { out = std::stod(s); return true; } catch (...) { return false; }
}

long long charValue(const std::string& s) {
    if (s.empty()) return 0;
    if (s[0] != '\\') return static_cast<unsigned char>(s[0]);
    if (s.size() < 2) return '\\';
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

bool exec(const ast::Stmt& st, Context& ctx, Env& env, Num& ret, bool& returned);

bool execBlock(const ast::Block& block, Context& ctx, Env& env, Num& ret, bool& returned) {
    for (const ast::StmtPtr& s : block.statements) {
        if (!exec(*s, ctx, env, ret, returned)) return false;
        if (returned) return true;
    }
    return true;
}

// Calls a comptime method with already-evaluated argument values.
bool callMethod(const ast::MethodDecl& m, const std::vector<Num>& args, Num& out, Context& ctx) {
    if (++ctx.steps > ctx.stepLimit) return false;
    if (++ctx.depth > ctx.depthLimit) { --ctx.depth; return false; }  // bound the native stack
    if (m.params.size() != args.size()) { --ctx.depth; return false; }
    Env env;
    for (std::size_t i = 0; i < m.params.size(); ++i) env[m.params[i].name] = args[i];
    Num ret;
    bool returned = false;
    const bool ok = execBlock(m.body, ctx, env, ret, returned);
    --ctx.depth;
    if (!ok || !returned) return false;  // must succeed and produce a value
    out = ret;
    return true;
}

bool eval(const ast::Expr& e, Num& out, Context& ctx, const Env& env) {
    if (++ctx.steps > ctx.stepLimit) return false;

    if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&e)) {
        long long v;
        if (!parseIntLexeme(n->text, v)) return false;
        out = Num::I(v);
        return true;
    }
    if (const auto* f = dynamic_cast<const ast::FloatLiteralExpr*>(&e)) {
        double v;
        if (!parseFloatLexeme(f->text, v)) return false;
        out = Num::D(v);
        return true;
    }
    if (const auto* b = dynamic_cast<const ast::BoolLiteralExpr*>(&e)) { out = Num::I(b->value ? 1 : 0); return true; }
    if (const auto* c = dynamic_cast<const ast::CharLiteralExpr*>(&e)) { out = Num::I(charValue(c->value)); return true; }

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

    if (const auto* cast = dynamic_cast<const ast::CastExpr*>(&e)) {
        Num v;
        if (!eval(*cast->operand, v, ctx, env)) return false;
        // A cast to an integer type truncates; to a float type promotes.
        const std::string& t = cast->targetType;
        if (t == "float" || t == "float32" || t == "double" || t == "float64") out = Num::D(v.dbl());
        else out = Num::I(v.isDouble ? static_cast<long long>(v.d) : v.i);
        return true;
    }

    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        Num v;
        if (!eval(*u->operand, v, ctx, env)) return false;
        if (u->op == "-") { out = v.isDouble ? Num::D(-v.d) : Num::I(-v.i); return true; }
        if (u->op == "!") { out = Num::I(v.truth() ? 0 : 1); return true; }
        if (u->op == "~") { if (v.isDouble) return false; out = Num::I(~v.i); return true; }
        return false;
    }

    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(&e)) {
        Num c;
        if (!eval(*t->cond, c, ctx, env)) return false;
        return eval(c.truth() ? *t->thenExpr : *t->elseExpr, out, ctx, env);
    }

    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        Num l, r;
        if (!eval(*bin->lhs, l, ctx, env) || !eval(*bin->rhs, r, ctx, env)) return false;
        const std::string& op = bin->op;
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
            if (op == "+") out = Num::D(l.dbl() + r.dbl());
            else if (op == "-") out = Num::D(l.dbl() - r.dbl());
            else if (op == "*") out = Num::D(l.dbl() * r.dbl());
            else if (op == "/") { if (r.dbl() == 0.0) return false; out = Num::D(l.dbl() / r.dbl()); }
            else return false;  // %, bitwise, shifts are integer-only
            return true;
        }
        if (op == "+") out = Num::I(l.i + r.i);
        else if (op == "-") out = Num::I(l.i - r.i);
        else if (op == "*") out = Num::I(l.i * r.i);
        else if (op == "/") { if (r.i == 0) return false; out = Num::I(l.i / r.i); }
        else if (op == "%") { if (r.i == 0) return false; out = Num::I(l.i % r.i); }
        else if (op == "&") out = Num::I(l.i & r.i);
        else if (op == "|") out = Num::I(l.i | r.i);
        else if (op == "^") out = Num::I(l.i ^ r.i);
        else if (op == "<<") out = Num::I(l.i << r.i);
        else if (op == ">>") out = Num::I(l.i >> r.i);
        else return false;
        return true;
    }

    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&e)) {
        if (ctx.methods == nullptr) return false;
        std::string name;
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get()))
            name = cid->name;
        else if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get()))
            name = mem->member;  // Class.method(...) -- resolve by method name
        else
            return false;
        auto mit = ctx.methods->find(name);
        if (mit == ctx.methods->end()) return false;
        std::vector<Num> args;
        args.reserve(call->args.size());
        for (const ast::ExprPtr& a : call->args) {
            Num v;
            if (!eval(*a, v, ctx, env)) return false;
            args.push_back(v);
        }
        return callMethod(*mit->second, args, out, ctx);
    }

    return false;
}

bool exec(const ast::Stmt& st, Context& ctx, Env& env, Num& ret, bool& returned) {
    if (++ctx.steps > ctx.stepLimit) return false;

    if (const auto* r = dynamic_cast<const ast::ReturnStmt*>(&st)) {
        if (r->value == nullptr) return false;  // a value-returning comptime function
        if (!eval(*r->value, ret, ctx, env)) return false;
        returned = true;
        return true;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&st)) {
        Num v;
        if (vd->init == nullptr || !eval(*vd->init, v, ctx, env)) return false;
        env[vd->name] = v;
        return true;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(&st)) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get());
        if (id == nullptr) return false;  // only local-variable assignment is comptime
        Num v;
        if (!eval(*as->value, v, ctx, env)) return false;
        env[id->name] = v;
        return true;
    }
    if (const auto* idc = dynamic_cast<const ast::IncDecStmt*>(&st)) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(idc->target.get());
        if (id == nullptr) return false;
        auto it = env.find(id->name);
        if (it == env.end()) return false;
        if (it->second.isDouble) it->second.d += idc->isIncrement ? 1.0 : -1.0;
        else it->second.i += idc->isIncrement ? 1 : -1;
        return true;
    }
    if (const auto* iff = dynamic_cast<const ast::IfStmt*>(&st)) {
        Num c;
        if (!eval(*iff->cond, c, ctx, env)) return false;
        if (c.truth()) return execBlock(iff->thenBlock, ctx, env, ret, returned);
        if (iff->elseBlock) return execBlock(*iff->elseBlock, ctx, env, ret, returned);
        return true;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(&st)) {
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) return false;
            Num c;
            if (!eval(*w->cond, c, ctx, env)) return false;
            if (!c.truth()) return true;
            if (!execBlock(w->body, ctx, env, ret, returned)) return false;
            if (returned) return true;
        }
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&st)) {
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) return false;
            if (!execBlock(dw->body, ctx, env, ret, returned)) return false;
            if (returned) return true;
            Num c;
            if (!eval(*dw->cond, c, ctx, env)) return false;
            if (!c.truth()) return true;
        }
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(&st)) {
        if (f->init != nullptr && !exec(*f->init, ctx, env, ret, returned)) return false;
        if (returned) return true;
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) return false;
            if (f->cond != nullptr) {
                Num c;
                if (!eval(*f->cond, c, ctx, env)) return false;
                if (!c.truth()) return true;
            }
            if (!execBlock(f->body, ctx, env, ret, returned)) return false;
            if (returned) return true;
            if (f->update != nullptr && !exec(*f->update, ctx, env, ret, returned)) return false;
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
    if (!eval(e, n, ctx, Env{})) return false;
    if (n.isDouble) return false;  // an integer context rejects a double result
    out = n.i;
    return true;
}

bool evalDouble(const ast::Expr& e, double& out, Context& ctx) {
    Num n;
    if (!eval(e, n, ctx, Env{})) return false;
    out = n.dbl();
    return true;
}

}  // namespace ldp3::comptime
