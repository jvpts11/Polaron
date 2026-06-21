#include "semantic/comptime.h"

#include <string>

namespace ldp3::comptime {

namespace {

using Env = std::unordered_map<std::string, long long>;

// Parses an integer literal lexeme, honoring 0x / 0b prefixes and digit separators
// (mirrors the lexeme handling used elsewhere in the compiler).
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

bool eval(const ast::Expr& e, long long& out, Context& ctx, const Env& env);

// Executes one statement of a comptime method body. `returned`/`ret` carry an early
// return out of the body. Returns false on any non-comptime construct or error.
bool exec(const ast::Stmt& st, Context& ctx, Env& env, long long& ret, bool& returned);

bool execBlock(const ast::Block& block, Context& ctx, Env& env, long long& ret, bool& returned) {
    for (const ast::StmtPtr& s : block.statements) {
        if (!exec(*s, ctx, env, ret, returned)) return false;
        if (returned) return true;
    }
    return true;
}

// Calls a comptime method with already-evaluated argument values.
bool callMethod(const ast::MethodDecl& m, const std::vector<long long>& args, long long& out,
                Context& ctx) {
    if (++ctx.steps > ctx.stepLimit) return false;
    if (++ctx.depth > ctx.depthLimit) { --ctx.depth; return false; }  // bound the native stack
    if (m.params.size() != args.size()) { --ctx.depth; return false; }
    Env env;
    for (std::size_t i = 0; i < m.params.size(); ++i) env[m.params[i].name] = args[i];
    long long ret = 0;
    bool returned = false;
    const bool ok = execBlock(m.body, ctx, env, ret, returned);
    --ctx.depth;
    if (!ok || !returned) return false;  // must succeed and produce a value
    out = ret;
    return true;
}

bool eval(const ast::Expr& e, long long& out, Context& ctx, const Env& env) {
    if (++ctx.steps > ctx.stepLimit) return false;

    if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&e)) return parseIntLexeme(n->text, out);
    if (const auto* b = dynamic_cast<const ast::BoolLiteralExpr*>(&e)) { out = b->value ? 1 : 0; return true; }
    if (const auto* c = dynamic_cast<const ast::CharLiteralExpr*>(&e)) { out = charValue(c->value); return true; }

    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&e)) {
        if (auto it = env.find(id->name); it != env.end()) { out = it->second; return true; }
        if (ctx.consts != nullptr) {
            if (auto it = ctx.consts->find(id->name); it != ctx.consts->end()) { out = it->second; return true; }
        }
        return false;
    }

    if (const auto* cast = dynamic_cast<const ast::CastExpr*>(&e)) {
        // Integer casts are value-preserving here (comptime is the integer domain).
        return eval(*cast->operand, out, ctx, env);
    }

    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(&e)) {
        long long v;
        if (!eval(*u->operand, v, ctx, env)) return false;
        if (u->op == "-") { out = -v; return true; }
        if (u->op == "!") { out = v ? 0 : 1; return true; }
        if (u->op == "~") { out = ~v; return true; }
        return false;
    }

    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(&e)) {
        long long c;
        if (!eval(*t->cond, c, ctx, env)) return false;
        return eval(c ? *t->thenExpr : *t->elseExpr, out, ctx, env);
    }

    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&e)) {
        long long l, r;
        if (!eval(*bin->lhs, l, ctx, env) || !eval(*bin->rhs, r, ctx, env)) return false;
        const std::string& op = bin->op;
        if (op == "+") out = l + r;
        else if (op == "-") out = l - r;
        else if (op == "*") out = l * r;
        else if (op == "/") { if (r == 0) return false; out = l / r; }
        else if (op == "%") { if (r == 0) return false; out = l % r; }
        else if (op == "==") out = (l == r) ? 1 : 0;
        else if (op == "!=") out = (l != r) ? 1 : 0;
        else if (op == "<") out = (l < r) ? 1 : 0;
        else if (op == ">") out = (l > r) ? 1 : 0;
        else if (op == "<=") out = (l <= r) ? 1 : 0;
        else if (op == ">=") out = (l >= r) ? 1 : 0;
        else if (op == "&&") out = (l && r) ? 1 : 0;
        else if (op == "||") out = (l || r) ? 1 : 0;
        else if (op == "&") out = l & r;
        else if (op == "|") out = l | r;
        else if (op == "^") out = l ^ r;
        else if (op == "<<") out = l << r;
        else if (op == ">>") out = l >> r;
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
        std::vector<long long> args;
        args.reserve(call->args.size());
        for (const ast::ExprPtr& a : call->args) {
            long long v;
            if (!eval(*a, v, ctx, env)) return false;
            args.push_back(v);
        }
        return callMethod(*mit->second, args, out, ctx);
    }

    return false;
}

bool exec(const ast::Stmt& st, Context& ctx, Env& env, long long& ret, bool& returned) {
    if (++ctx.steps > ctx.stepLimit) return false;

    if (const auto* r = dynamic_cast<const ast::ReturnStmt*>(&st)) {
        if (r->value == nullptr) return false;  // a value-returning comptime function
        if (!eval(*r->value, ret, ctx, env)) return false;
        returned = true;
        return true;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(&st)) {
        long long v;
        if (vd->init == nullptr || !eval(*vd->init, v, ctx, env)) return false;
        env[vd->name] = v;
        return true;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(&st)) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get());
        if (id == nullptr) return false;  // only local-variable assignment is comptime
        long long v;
        if (!eval(*as->value, v, ctx, env)) return false;
        env[id->name] = v;
        return true;
    }
    if (const auto* idc = dynamic_cast<const ast::IncDecStmt*>(&st)) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(idc->target.get());
        if (id == nullptr) return false;
        auto it = env.find(id->name);
        if (it == env.end()) return false;
        it->second += idc->isIncrement ? 1 : -1;
        return true;
    }
    if (const auto* iff = dynamic_cast<const ast::IfStmt*>(&st)) {
        long long c;
        if (!eval(*iff->cond, c, ctx, env)) return false;
        if (c) return execBlock(iff->thenBlock, ctx, env, ret, returned);
        if (iff->elseBlock) return execBlock(*iff->elseBlock, ctx, env, ret, returned);
        return true;
    }
    if (const auto* w = dynamic_cast<const ast::WhileStmt*>(&st)) {
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) return false;
            long long c;
            if (!eval(*w->cond, c, ctx, env)) return false;
            if (!c) return true;
            if (!execBlock(w->body, ctx, env, ret, returned)) return false;
            if (returned) return true;
        }
    }
    if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(&st)) {
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) return false;
            if (!execBlock(dw->body, ctx, env, ret, returned)) return false;
            if (returned) return true;
            long long c;
            if (!eval(*dw->cond, c, ctx, env)) return false;
            if (!c) return true;
        }
    }
    if (const auto* f = dynamic_cast<const ast::ForStmt*>(&st)) {
        if (f->init != nullptr && !exec(*f->init, ctx, env, ret, returned)) return false;
        if (returned) return true;
        for (;;) {
            if (++ctx.steps > ctx.stepLimit) return false;
            if (f->cond != nullptr) {
                long long c;
                if (!eval(*f->cond, c, ctx, env)) return false;
                if (!c) return true;
            }
            if (!execBlock(f->body, ctx, env, ret, returned)) return false;
            if (returned) return true;
            if (f->update != nullptr && !exec(*f->update, ctx, env, ret, returned)) return false;
        }
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(&st)) {
        long long v;
        return eval(*es->expr, v, ctx, env);  // a call evaluated for its (pure) value
    }
    return false;  // any other statement is not comptime-evaluable
}

}  // namespace

bool evalInt(const ast::Expr& e, long long& out, Context& ctx) {
    return eval(e, out, ctx, Env{});
}

}  // namespace ldp3::comptime
