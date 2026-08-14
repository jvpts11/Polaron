#include "parser/boundscheck.h"

#include <cstdio>
#include <cstdlib>
#include <memory>
#include <set>
#include <string>
#include <vector>

#include "parser/monomorphize.h"  // cloneStmtDeep

namespace polaron {
namespace {

using namespace ast;

// ---------- small AST builders (guard construction) ----------

ExprPtr mkIdent(const std::string& n) {
    auto e = std::make_unique<IdentifierExpr>();
    e->name = n;
    return e;
}
ExprPtr mkInt(const std::string& text) {
    auto e = std::make_unique<IntLiteralExpr>();
    e->text = text;
    return e;
}
ExprPtr mkBin(const std::string& op, ExprPtr l, ExprPtr r) {
    auto e = std::make_unique<BinaryExpr>();
    e->op = op;
    e->lhs = std::move(l);
    e->rhs = std::move(r);
    return e;
}
ExprPtr mkLength(ExprPtr arr) {  // arr.length()
    auto m = std::make_unique<MemberExpr>();
    m->object = std::move(arr);
    m->member = "length";
    auto c = std::make_unique<CallExpr>();
    c->callee = std::move(m);
    return c;
}
ExprPtr mkCast(const std::string& ty, ExprPtr e) {  // cast<ty>(e)
    auto c = std::make_unique<CastExpr>();
    c->targetType = ty;
    c->op = 0;
    c->operand = std::move(e);
    return c;
}

// ---------- conservative predicates (unknown node type => treat as unsafe) ----------

// True if `e` contains anything that could call user code or allocate/free (a call, a lambda, a new).
// Conservative: an expression node type not handled here is assumed to possibly contain such a thing.
bool exprUnsafe(const Expr* e) {
    if (e == nullptr) {
        return false;
    }
    if (dynamic_cast<const CallExpr*>(e)) {
        return true;
    }
    if (dynamic_cast<const NewExpr*>(e)) {
        return true;
    }
    if (dynamic_cast<const NewArrayExpr*>(e)) {
        return true;
    }
    if (dynamic_cast<const LambdaExpr*>(e)) {
        return true;
    }
    if (dynamic_cast<const IdentifierExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const IntLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const FloatLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const BoolLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const CharLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const StringLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const NullLiteralExpr*>(e)) {
        return false;
    }
    if (const auto* b = dynamic_cast<const BinaryExpr*>(e)) {
        return exprUnsafe(b->lhs.get()) || exprUnsafe(b->rhs.get());
    }
    if (const auto* u = dynamic_cast<const UnaryExpr*>(e)) {
        return exprUnsafe(u->operand.get());
    }
    if (const auto* ix = dynamic_cast<const IndexExpr*>(e)) {
        return exprUnsafe(ix->array.get()) || exprUnsafe(ix->index.get());
    }
    if (const auto* m = dynamic_cast<const MemberExpr*>(e)) {
        return exprUnsafe(m->object.get());
    }
    if (const auto* c = dynamic_cast<const CastExpr*>(e)) {
        return exprUnsafe(c->operand.get());
    }
    if (const auto* t = dynamic_cast<const TernaryExpr*>(e)) {
        return exprUnsafe(t->cond.get()) || exprUnsafe(t->thenExpr.get()) || exprUnsafe(t->elseExpr.get());
    }
    return true;  // unknown expression type -> conservatively unsafe
}

bool blockUnsafe(const Block& b);

// True if `s` (or anything it contains) could call/allocate/free, or is a statement type we do not fully
// understand. Conservative: unknown statement type => unsafe, so it is never hoisted across.
bool stmtUnsafe(const Stmt* s) {
    if (s == nullptr) {
        return false;
    }
    if (dynamic_cast<const DeleteStmt*>(s)) {
        return true;  // could free the array
    }
    if (const auto* es = dynamic_cast<const ExprStmt*>(s)) {
        return exprUnsafe(es->expr.get());
    }
    if (const auto* vd = dynamic_cast<const VarDeclStmt*>(s)) {
        return exprUnsafe(vd->init.get());
    }
    if (const auto* as = dynamic_cast<const AssignStmt*>(s)) {
        return exprUnsafe(as->target.get()) || exprUnsafe(as->value.get());
    }
    if (const auto* id = dynamic_cast<const IncDecStmt*>(s)) {
        return exprUnsafe(id->target.get());
    }
    if (const auto* rs = dynamic_cast<const ReturnStmt*>(s)) {
        return exprUnsafe(rs->value.get());
    }
    if (dynamic_cast<const BreakStmt*>(s)) {
        return false;
    }
    if (dynamic_cast<const ContinueStmt*>(s)) {
        return false;
    }
    if (const auto* blk = dynamic_cast<const Block*>(s)) {
        return blockUnsafe(*blk);
    }
    if (const auto* i = dynamic_cast<const IfStmt*>(s)) {
        return exprUnsafe(i->cond.get()) || blockUnsafe(i->thenBlock) || (i->elseBlock && blockUnsafe(*i->elseBlock));
    }
    if (const auto* f = dynamic_cast<const ForStmt*>(s)) {
        return stmtUnsafe(f->init.get()) || exprUnsafe(f->cond.get()) || stmtUnsafe(f->update.get()) || blockUnsafe(f->body);
    }
    if (const auto* w = dynamic_cast<const WhileStmt*>(s)) {
        return exprUnsafe(w->cond.get()) || blockUnsafe(w->body);
    }
    if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) {
        return exprUnsafe(d->cond.get()) || blockUnsafe(d->body);
    }
    return true;  // unknown statement type -> conservatively unsafe
}

bool blockUnsafe(const Block& b) {
    for (const auto& s : b.statements) {
        if (stmtUnsafe(s.get())) {
            return true;
        }
    }
    return false;
}

// ---------- writes to a variable / member (for invariance + monotonicity) ----------

bool identWrittenInExpr(const Expr* /*e*/, const std::string& /*name*/) { return false; }  // writes are statements

bool identWrittenInBlock(const Block& b, const std::string& name);

bool identWrittenInStmt(const Stmt* s, const std::string& name) {
    if (s == nullptr) {
        return false;
    }
    if (const auto* as = dynamic_cast<const AssignStmt*>(s)) {
        if (const auto* id = dynamic_cast<const IdentifierExpr*>(as->target.get())) {
            if (id->name == name) {
                return true;
            }
        }
    }
    if (const auto* idd = dynamic_cast<const IncDecStmt*>(s)) {
        if (const auto* id = dynamic_cast<const IdentifierExpr*>(idd->target.get())) {
            if (id->name == name) {
                return true;
            }
        }
    }
    if (const auto* vd = dynamic_cast<const VarDeclStmt*>(s)) {
        if (vd->name == name) {
            return true;  // shadow/redeclare
        }
    }
    if (const auto* blk = dynamic_cast<const Block*>(s)) {
        return identWrittenInBlock(*blk, name);
    }
    if (const auto* i = dynamic_cast<const IfStmt*>(s)) {
        return identWrittenInBlock(i->thenBlock, name) || (i->elseBlock && identWrittenInBlock(*i->elseBlock, name));
    }
    if (const auto* f = dynamic_cast<const ForStmt*>(s)) {
        return identWrittenInStmt(f->init.get(), name) || identWrittenInStmt(f->update.get(), name) || identWrittenInBlock(f->body, name);
    }
    if (const auto* w = dynamic_cast<const WhileStmt*>(s)) {
        return identWrittenInBlock(w->body, name);
    }
    if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) {
        return identWrittenInBlock(d->body, name);
    }
    return false;
}

bool identWrittenInBlock(const Block& b, const std::string& name) {
    for (const auto& s : b.statements) {
        if (identWrittenInStmt(s.get(), name)) {
            return true;
        }
    }
    return false;
}

// True if `this.field` is the target of any assignment in the block (would change the array's identity).
bool memberWrittenInBlock(const Block& b, const std::string& field);

bool memberWrittenInStmt(const Stmt* s, const std::string& field) {
    if (s == nullptr) {
        return false;
    }
    if (const auto* as = dynamic_cast<const AssignStmt*>(s)) {
        if (const auto* m = dynamic_cast<const MemberExpr*>(as->target.get())) {
            if (const auto* o = dynamic_cast<const IdentifierExpr*>(m->object.get())) {
                if (m->member == field && o->name == "this") {
                    return true;
                }
            }
        }
    }
    if (const auto* blk = dynamic_cast<const Block*>(s)) {
        return memberWrittenInBlock(*blk, field);
    }
    if (const auto* i = dynamic_cast<const IfStmt*>(s)) {
        return memberWrittenInBlock(i->thenBlock, field) || (i->elseBlock && memberWrittenInBlock(*i->elseBlock, field));
    }
    if (const auto* f = dynamic_cast<const ForStmt*>(s)) {
        return memberWrittenInBlock(f->body, field);
    }
    if (const auto* w = dynamic_cast<const WhileStmt*>(s)) {
        return memberWrittenInBlock(w->body, field);
    }
    if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) {
        return memberWrittenInBlock(d->body, field);
    }
    return false;
}

bool memberWrittenInBlock(const Block& b, const std::string& field) {
    for (const auto& s : b.statements) {
        if (memberWrittenInStmt(s.get(), field)) {
            return true;
        }
    }
    return false;
}

// ---------- array-expression identity ----------

// A stable key for a "simple" array expression, or "" if the expression is not one we can prove
// invariant / re-evaluate in the guard. Only a bare local/param (`a`) or a `this` field (`this.data`).
std::string arrayKey(const Expr* e) {
    if (const auto* id = dynamic_cast<const IdentifierExpr*>(e)) {
        return "$" + id->name;
    }
    if (const auto* m = dynamic_cast<const MemberExpr*>(e)) {
        if (const auto* o = dynamic_cast<const IdentifierExpr*>(m->object.get())) {
            if (m->member.size() && o->name == "this") {
                return "@" + m->member;
            }
        }
    }
    return "";
}

// Is the array named by `key` provably unchanged over the loop body? (No call/alloc has already been
// ruled out by blockUnsafe; here we only need to rule out a direct reassignment of the base.)
bool arrayInvariant(const std::string& key, const Block& body) {
    if (key.empty()) {
        return false;
    }
    if (key[0] == '$') {
        return !identWrittenInBlock(body, key.substr(1));  // local/param base
    }
    if (key[0] == '@') {
        return !memberWrittenInBlock(body, key.substr(1));  // this.field base
    }
    return false;
}

// A pure, side-effect-free, call-free expression safe to clone and re-evaluate in the guard.
bool pureSimple(const Expr* e) { return !exprUnsafe(e); }

// Collect every identifier read in `e` (for invariance checks on a bound / step expression).
void collectIdents(const Expr* e, std::set<std::string>& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* id = dynamic_cast<const IdentifierExpr*>(e)) { out.insert(id->name); return; }
    if (const auto* b = dynamic_cast<const BinaryExpr*>(e)) { collectIdents(b->lhs.get(), out); collectIdents(b->rhs.get(), out); return; }
    if (const auto* u = dynamic_cast<const UnaryExpr*>(e)) { collectIdents(u->operand.get(), out); return; }
    if (const auto* ix = dynamic_cast<const IndexExpr*>(e)) { collectIdents(ix->array.get(), out); collectIdents(ix->index.get(), out); return; }
    if (const auto* m = dynamic_cast<const MemberExpr*>(e)) { collectIdents(m->object.get(), out); return; }
    if (const auto* c = dynamic_cast<const CastExpr*>(e)) { collectIdents(c->operand.get(), out); return; }
    if (const auto* t = dynamic_cast<const TernaryExpr*>(e)) { collectIdents(t->cond.get(), out); collectIdents(t->thenExpr.get(), out); collectIdents(t->elseExpr.get(), out); return; }
}

bool identWrittenInBlock(const Block& b, const std::string& name);

// True if `e` is loop-invariant over `body`: none of the identifiers it reads is written in the body.
// (The body is already call/alloc-free when this is asked, so a plain identifier scan suffices.)
bool exprInvariant(const Expr* e, const Block& body) {
    std::set<std::string> ids;
    collectIdents(e, ids);
    for (const auto& id : ids) {
        if (identWrittenInBlock(body, id)) {
            return false;
        }
    }
    return true;
}

// ---------- collect `array[base + var]` accesses (affine index, coefficient +1) ----------

// A hoistable access: `array[index]` where `index` is `var` (base null) or `base + var` / `var + base`
// with `base` a var-free, loop-invariant offset. Only stride +1 is matched -- the common contiguous
// case -- so the accessed index range is exactly [base+lo, base+hi), which the guard bounds directly.
struct AffineAccess {
    IndexExpr* ix;
    Expr* base;  // nullptr means the index is the bare `var` (base 0)
};

// True if `e` reads `var`.
bool containsIdent(const Expr* e, const std::string& var) {
    std::set<std::string> ids;
    collectIdents(e, ids);
    return ids.count(var) > 0;
}

// If `idx` is `var`, `base + var`, or `var + base` (base var-free), return true and set `base` (nullptr
// for the bare `var`). Coefficient must be +1.
bool matchAffine(Expr* idx, const std::string& var, Expr*& base) {
    base = nullptr;
    if (const auto* id = dynamic_cast<const IdentifierExpr*>(idx)) {
        return id->name == var;
    }
    auto* b = dynamic_cast<BinaryExpr*>(idx);
    if (b == nullptr || b->op != "+") {
        return false;
    }
    const auto* l = dynamic_cast<const IdentifierExpr*>(b->lhs.get());
    const auto* r = dynamic_cast<const IdentifierExpr*>(b->rhs.get());
    if (r != nullptr && r->name == var && !containsIdent(b->lhs.get(), var)) { base = b->lhs.get(); return true; }
    if (l != nullptr && l->name == var && !containsIdent(b->rhs.get(), var)) { base = b->rhs.get(); return true; }
    return false;
}

void collectAffineExpr(Expr* e, const std::string& var, std::vector<AffineAccess>& out);

void collectAffineBlock(Block& b, const std::string& var, std::vector<AffineAccess>& out);

void collectAffineStmt(Stmt* s, const std::string& var, std::vector<AffineAccess>& out) {
    if (s == nullptr) {
        return;
    }
    if (auto* es = dynamic_cast<ExprStmt*>(s)) {
        collectAffineExpr(es->expr.get(), var, out);
    } else if (auto* vd = dynamic_cast<VarDeclStmt*>(s)) {
        collectAffineExpr(vd->init.get(), var, out);
    } else if (auto* as = dynamic_cast<AssignStmt*>(s)) {
        collectAffineExpr(as->target.get(), var, out);
        collectAffineExpr(as->value.get(), var, out);
    } else if (auto* idd = dynamic_cast<IncDecStmt*>(s)) {
        collectAffineExpr(idd->target.get(), var, out);
    } else if (auto* rs = dynamic_cast<ReturnStmt*>(s)) {
        collectAffineExpr(rs->value.get(), var, out);
    } else if (auto* blk = dynamic_cast<Block*>(s)) {
        collectAffineBlock(*blk, var, out);
    } else if (auto* i = dynamic_cast<IfStmt*>(s)) {
        collectAffineExpr(i->cond.get(), var, out);
        collectAffineBlock(i->thenBlock, var, out);
        if (i->elseBlock) {
            collectAffineBlock(*i->elseBlock, var, out);
        }
    } else if (auto* f = dynamic_cast<ForStmt*>(s)) {
        collectAffineStmt(f->init.get(), var, out);
        collectAffineExpr(f->cond.get(), var, out);
        collectAffineStmt(f->update.get(), var, out);
        collectAffineBlock(f->body, var, out);
    } else if (auto* w = dynamic_cast<WhileStmt*>(s)) {
        collectAffineExpr(w->cond.get(), var, out);
        collectAffineBlock(w->body, var, out);
    } else if (auto* d = dynamic_cast<DoWhileStmt*>(s)) {
        collectAffineExpr(d->cond.get(), var, out);
        collectAffineBlock(d->body, var, out);
    }
}

void collectAffineExpr(Expr* e, const std::string& var, std::vector<AffineAccess>& out) {
    if (e == nullptr) {
        return;
    }
    if (auto* ix = dynamic_cast<IndexExpr*>(e)) {
        collectAffineExpr(ix->array.get(), var, out);
        collectAffineExpr(ix->index.get(), var, out);
        Expr* base = nullptr;
        if (matchAffine(ix->index.get(), var, base) && !arrayKey(ix->array.get()).empty()) {
            out.push_back({ix, base});
        }
        return;
    }
    if (auto* b = dynamic_cast<BinaryExpr*>(e)) { collectAffineExpr(b->lhs.get(), var, out); collectAffineExpr(b->rhs.get(), var, out); return; }
    if (auto* u = dynamic_cast<UnaryExpr*>(e)) { collectAffineExpr(u->operand.get(), var, out); return; }
    if (auto* m = dynamic_cast<MemberExpr*>(e)) { collectAffineExpr(m->object.get(), var, out); return; }
    if (auto* c = dynamic_cast<CastExpr*>(e)) { collectAffineExpr(c->operand.get(), var, out); return; }
    if (auto* t = dynamic_cast<TernaryExpr*>(e)) { collectAffineExpr(t->cond.get(), var, out); collectAffineExpr(t->thenExpr.get(), var, out); collectAffineExpr(t->elseExpr.get(), var, out); return; }
}

void collectAffineBlock(Block& b, const std::string& var, std::vector<AffineAccess>& out) {
    for (auto& s : b.statements) {
        collectAffineStmt(s.get(), var, out);
    }
}

// ---------- clean-for analysis ----------

struct ForInfo {
    std::string var;
    const Expr* lo = nullptr;    // init value (owned by the ForStmt)
    const Expr* hi = nullptr;    // condition bound (owned by the ForStmt)
    bool inclusive = false;      // `i <= hi` vs `i < hi`
    const Expr* step = nullptr;  // non-null only for a variable step `var = var + S`: needs an `S >= 1`
                                 // guard clause and S must be loop-invariant. A `var++` or literal step
                                 // is left null (constant and positive, so no extra guard is needed).
};

// Recognize `for (int var = LO; var </<= HI; var++/var = var + posConst)` with LO/HI pure-simple.
bool analyzeFor(const ForStmt& f, ForInfo& info) {
    // init: `int var = LO`
    const auto* vd = dynamic_cast<const VarDeclStmt*>(f.init.get());
    if (vd == nullptr || vd->isVar || vd->init == nullptr) {
        return false;
    }
    info.var = vd->name;
    info.lo = vd->init.get();
    // cond: `var </<= HI`
    const auto* cond = dynamic_cast<const BinaryExpr*>(f.cond.get());
    if (cond == nullptr) {
        return false;
    }
    if (cond->op != "<" && cond->op != "<=") {
        return false;
    }
    const auto* lhs = dynamic_cast<const IdentifierExpr*>(cond->lhs.get());
    if (lhs == nullptr || lhs->name != info.var) {
        return false;
    }
    info.hi = cond->rhs.get();
    info.inclusive = (cond->op == "<=");
    // update: `var++`, `var = var + posConst`, or `var = var + S` (monotonically increasing, so var
    // stays >= LO). A variable step S records itself in info.step so tryVersion can guard `S >= 1` and
    // require S loop-invariant; a `++` or positive literal step needs neither.
    bool okUpdate = false;
    if (const auto* id = dynamic_cast<const IncDecStmt*>(f.update.get())) {
        const auto* t = dynamic_cast<const IdentifierExpr*>(id->target.get());
        okUpdate = (id->isIncrement && t != nullptr && t->name == info.var);
    } else if (const auto* as = dynamic_cast<const AssignStmt*>(f.update.get())) {
        const auto* t = dynamic_cast<const IdentifierExpr*>(as->target.get());
        const auto* add = dynamic_cast<const BinaryExpr*>(as->value.get());
        if (t != nullptr && t->name == info.var && add != nullptr && add->op == "+") {
            const auto* al = dynamic_cast<const IdentifierExpr*>(add->lhs.get());
            if (al != nullptr && al->name == info.var) {
                const auto* ar = dynamic_cast<const IntLiteralExpr*>(add->rhs.get());
                if (ar != nullptr) {  // `var = var + <positive int literal>`: constant step, no guard
                    okUpdate = (!ar->text.empty() && ar->text[0] != '-' && ar->text != "0");
                } else if (pureSimple(add->rhs.get())) {  // `var = var + S`: variable step, guard S >= 1
                    okUpdate = true;
                    info.step = add->rhs.get();
                }
            }
        }
    }
    if (!okUpdate) {
        return false;
    }
    if (!pureSimple(info.lo) || !pureSimple(info.hi)) {
        return false;
    }
    return true;
}

// Recognize the while form of a counted loop: `while (var </<= HI) { ...; INCREMENT }` where INCREMENT
// (`var++`, `var = var + posLit`, or `var = var + S`) is the LAST statement -- so every access in the
// body uses the same `var`, exactly as a for-header does -- and `var` is written nowhere else. `var` is
// declared before the loop, so its entry value is the lower bound: info.lo is a synthesized read of
// `var`, owned by `loStore` (which the caller must keep alive while the guard is built).
bool analyzeWhile(const WhileStmt& w, ForInfo& info, ExprPtr& loStore) {
    const auto* cond = dynamic_cast<const BinaryExpr*>(w.cond.get());
    if (cond == nullptr || (cond->op != "<" && cond->op != "<=")) {
        return false;
    }
    const auto* lhs = dynamic_cast<const IdentifierExpr*>(cond->lhs.get());
    if (lhs == nullptr) {
        return false;
    }
    info.var = lhs->name;
    info.hi = cond->rhs.get();
    info.inclusive = (cond->op == "<=");
    if (w.body.statements.empty()) {
        return false;
    }
    const Stmt* last = w.body.statements.back().get();
    bool okStep = false;
    if (const auto* idd = dynamic_cast<const IncDecStmt*>(last)) {
        const auto* t = dynamic_cast<const IdentifierExpr*>(idd->target.get());
        okStep = (idd->isIncrement && t != nullptr && t->name == info.var);
    } else if (const auto* as = dynamic_cast<const AssignStmt*>(last)) {
        const auto* t = dynamic_cast<const IdentifierExpr*>(as->target.get());
        const auto* add = dynamic_cast<const BinaryExpr*>(as->value.get());
        if (t != nullptr && t->name == info.var && add != nullptr && add->op == "+") {
            const auto* al = dynamic_cast<const IdentifierExpr*>(add->lhs.get());
            if (al != nullptr && al->name == info.var) {
                const auto* ar = dynamic_cast<const IntLiteralExpr*>(add->rhs.get());
                if (ar != nullptr) {
                    okStep = (!ar->text.empty() && ar->text[0] != '-' && ar->text != "0");
                } else if (pureSimple(add->rhs.get())) {
                    okStep = true;
                    info.step = add->rhs.get();
                }
            }
        }
    }
    if (!okStep) {
        return false;
    }
    // `var` must be written ONLY by that last increment -- no earlier or nested write would leave the
    // body's accesses at a value outside [lo, hi).
    for (std::size_t i = 0; i + 1 < w.body.statements.size(); ++i) {
        if (identWrittenInStmt(w.body.statements[i].get(), info.var)) {
            return false;
        }
    }
    if (!pureSimple(info.hi)) {
        return false;
    }
    loStore = mkIdent(info.var);
    info.lo = loStore.get();
    return true;
}

// ---------- the transform ----------

bool containsLoop(const Block& b);

// True if `s` is, or contains, a loop. Used to restrict versioning to innermost loops.
bool stmtContainsLoop(const Stmt* s) {
    if (dynamic_cast<const ForStmt*>(s) || dynamic_cast<const WhileStmt*>(s) ||
        dynamic_cast<const DoWhileStmt*>(s)) {
        return true;
    }
    if (const auto* i = dynamic_cast<const IfStmt*>(s)) {
        return containsLoop(i->thenBlock) || (i->elseBlock && containsLoop(*i->elseBlock));
    }
    if (const auto* blk = dynamic_cast<const Block*>(s)) {
        return containsLoop(*blk);
    }
    return false;
}
bool containsLoop(const Block& b) {
    for (const auto& s : b.statements) {
        if (stmtContainsLoop(s.get())) {
            return true;
        }
    }
    return false;
}

int blockStmtCount(const Block& b);

// How many statements a body holds, counting into everything nested. Versioning DUPLICATES the body,
// so this is the price of the transform, and the number the budget below is spent against.
int stmtCount(const Stmt* s) {
    if (s == nullptr) {
        return 0;
    }
    int n = 1;
    if (const auto* f = dynamic_cast<const ForStmt*>(s)) {
        n += blockStmtCount(f->body);
    } else if (const auto* w = dynamic_cast<const WhileStmt*>(s)) {
        n += blockStmtCount(w->body);
    } else if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) {
        n += blockStmtCount(d->body);
    } else if (const auto* i = dynamic_cast<const IfStmt*>(s)) {
        n += blockStmtCount(i->thenBlock);
        if (i->elseBlock) {
            n += blockStmtCount(*i->elseBlock);
        }
    } else if (const auto* blk = dynamic_cast<const Block*>(s)) {
        n += blockStmtCount(*blk);
    }
    return n;
}

int blockStmtCount(const Block& b) {
    int n = 0;
    for (const auto& s : b.statements) {
        n += stmtCount(s.get());
    }
    return n;
}

// Why a loop was NOT versioned. `POLARON_BC_TRACE=1` makes the pass say so on stderr.
//
// A hoisting pass that silently declines is indistinguishable from one that is not running at all,
// and telling those two apart by reading optimized IR cost an afternoon and three wrong hypotheses.
// The pass knows the answer at the moment it decides; making it say so is a two-line change.
void bcTrace(const char* why, int line) {
    static const bool on = std::getenv("POLARON_BC_TRACE") != nullptr;
    if (on) {
        std::fprintf(stderr, "boundscheck: loop at line %d not versioned -- %s\n", line, why);
    }
}

// What a versioned outer loop may cost in duplicated statements. Nesting multiplies -- each level
// versioned doubles what the level above would copy -- so the budget is deliberately small: enough
// for a sieve or a matrix row, nowhere near enough to double a real algorithm.
constexpr int kMaxDuplicatedStmts = 24;

// An affine access is hoistable in `body` iff its array is provably unchanged and its base offset is
// loop-invariant. A non-hoistable access is simply left checked (partial hoisting is safe).
bool accessHoistable(const Block& body, const AffineAccess& a) {
    if (!arrayInvariant(arrayKey(a.ix->array.get()), body)) {
        return false;
    }
    if (a.base != nullptr && !exprInvariant(a.base, body)) {
        return false;
    }
    return true;
}

// Build the versioning guard for the hoistable affine accesses in `body`; returns null if none qualify.
// Bare access (index == var): lo >= 0 (once) && hi {<=|<} length. Affine access base+var: (base+lo >= 0)
// && (base+hi {<=|<} length), computed in 64-bit so a large base cannot overflow the check (array indices
// fit i32, so the widened bound is exact). For `i < hi` the max index is hi-1 (`base+hi <= length`); for
// `i <= hi` it is hi (`base+hi < length`). A variable step adds `step >= 1`.
ExprPtr buildHoistGuard(Block& body, const ForInfo& info) {
    std::vector<AffineAccess> all;
    collectAffineBlock(body, info.var, all);
    std::vector<AffineAccess> hoistable;
    for (const auto& a : all) {
        if (accessHoistable(body, a)) {
            hoistable.push_back(a);
        }
    }
    if (hoistable.empty()) {
        return nullptr;
    }
    const std::string upperOp = info.inclusive ? "<" : "<=";
    ExprPtr guard = mkBin(">=", cloneExprDeep(info.lo), mkInt("0"));
    for (const auto& a : hoistable) {
        ExprPtr len = mkLength(cloneExprDeep(a.ix->array.get()));
        if (a.base == nullptr) {
            guard = mkBin("&&", std::move(guard), mkBin(upperOp, cloneExprDeep(info.hi), std::move(len)));
        } else {
            ExprPtr lo64 = mkBin("+", mkCast("long", cloneExprDeep(a.base)), mkCast("long", cloneExprDeep(info.lo)));
            ExprPtr hi64 = mkBin("+", mkCast("long", cloneExprDeep(a.base)), mkCast("long", cloneExprDeep(info.hi)));
            guard = mkBin("&&", std::move(guard), mkBin(">=", std::move(lo64), mkInt("0")));
            guard = mkBin("&&", std::move(guard), mkBin(upperOp, std::move(hi64), std::move(len)));
        }
    }
    if (info.step != nullptr) {
        guard = mkBin("&&", std::move(guard), mkBin(">=", cloneExprDeep(info.step), mkInt("1")));
    }
    return guard;
}

// Mark exactly the hoistable affine accesses in a (cloned) loop body unchecked -- the guard from
// buildHoistGuard, built with the identical filter on the identical structure, covers precisely these.
void markHoistable(Block& body, const std::string& var) {
    std::vector<AffineAccess> all;
    collectAffineBlock(body, var, all);
    for (const auto& a : all) {
        if (accessHoistable(body, a)) {
            a.ix->unchecked = true;
        }
    }
}

// Wrap `slot` (a loop) as `if (guard) fast else slow`: `fast` is a clone with the hoistable accesses
// marked unchecked, `slow` is the original fully-checked loop. `fastBody` is the clone's body.
void versionLoop(StmtPtr& slot, ExprPtr guard, StmtPtr fast, Block& fastBody, const std::string& var,
                 SourceLocation loc) {
    markHoistable(fastBody, var);
    auto iff = std::make_unique<IfStmt>();
    iff->loc = loc;
    iff->cond = std::move(guard);
    iff->thenBlock.statements.push_back(std::move(fast));
    iff->elseBlock = std::make_unique<Block>();
    iff->elseBlock->statements.push_back(std::move(slot));  // the original loop stays fully checked
    slot = std::move(iff);
}

// Try to version the for-loop held in `slot`. On success `slot` becomes an IfStmt (guard ? fast : slow).
//
// `bodyWasSafe` is the no-calls/no-allocations verdict taken on the USER's body, BEFORE this pass
// rewrote anything inside it -- see walkStmt for why it cannot be recomputed here.
void tryVersion(StmtPtr& slot, bool bodyWasSafe) {
    auto* f = dynamic_cast<ForStmt*>(slot.get());
    if (f == nullptr) {
        return;
    }
    ForInfo info;
    if (!analyzeFor(*f, info)) {
        return bcTrace("loop header is not a clean counted for", f->loc.line);
    }
    // Versioning duplicates the body into both copies, so an outer loop used to be refused outright
    // whenever it held a nested one: with each level the duplication multiplies. But "contains a loop"
    // is a proxy for "is big", and a poor one. The sieve in `performance tests/primes.pol` has a
    // two-statement inner loop, and that blanket refusal left its OUTER loop paying a bounds check
    // across 20 million iterations -- measured at 8.7 ms of a 54 ms run, which was the whole of a 19%
    // deficit against GCC. Budget the duplication instead of banning it: the reason was always code
    // size, so spend it against code size and let the cheap cases through.
    // ONLY INNERMOST LOOPS. Versioning duplicates the body, so an outer loop drags its whole nest
    // into both copies -- but code size is not the reason this is a hard refusal. Allowing it under
    // a duplication budget was tried on 2026-08-12 and measured: `primes` did not improve at all,
    // and `matrixmul` went from 29.0 ms to 68.8 ms -- a 2.4x REGRESSION, because versioning the
    // outer loop of a matmul nest splits the nest that `interchangeReductionLoops` had just made
    // vectorizable, and the backend loses it. The transform that matters on a loop nest is the
    // interchange; wrapping it in a guard destroys it. Leave the outer loops alone.
    if (containsLoop(f->body)) {
        return bcTrace("only innermost loops are versioned", f->loc.line);
    }
    // The induction variable must not be reassigned inside the body (only the header update moves it).
    if (identWrittenInBlock(f->body, info.var)) {
        return bcTrace("the induction variable is written inside the body", f->loc.line);
    }
    // No calls / allocations / frees in the body -- otherwise the array could be reallocated or freed.
    // Taken on the body as the USER wrote it, not as it stands now (see walkStmt).
    if (!bodyWasSafe) {
        return bcTrace("body calls, allocates or frees", f->loc.line);
    }
    // The bound / variable step must be loop-invariant (re-read every iteration, but guarded once).
    if (!exprInvariant(info.hi, f->body)) {
        return bcTrace("the loop bound is not invariant", f->loc.line);
    }
    if (info.step != nullptr && !exprInvariant(info.step, f->body)) {
        return bcTrace("the step is not invariant", f->loc.line);
    }

    ExprPtr guard = buildHoistGuard(f->body, info);
    if (guard == nullptr) {
        return bcTrace("no access proved hoistable", f->loc.line);
    }
    StmtPtr fast = cloneStmtDeep(f);
    Block& fastBody = static_cast<ForStmt*>(fast.get())->body;  // before the move (unspecified arg order)
    const SourceLocation loc = f->loc;
    versionLoop(slot, std::move(guard), std::move(fast), fastBody, info.var, loc);
}

// Try to version the while-loop held in `slot`: `while (var </<= HI) { ...; var = var + step }` where the
// increment is the LAST statement (so every access uses the same var, as in a for header) and var is
// written nowhere else. The lower bound is var's value at loop entry.
void tryVersionWhile(StmtPtr& slot, bool bodyWasSafe) {
    auto* w = dynamic_cast<WhileStmt*>(slot.get());
    if (w == nullptr) {
        return;
    }
    ForInfo info;
    ExprPtr loStore;  // owns the synthesized `var` read used as the lower bound
    if (!analyzeWhile(*w, info, loStore)) {
        return;
    }
    if (containsLoop(w->body)) {
        return;
    }
    if (!bodyWasSafe) {
        return;
    }
    if (!exprInvariant(info.hi, w->body)) {
        return;  // hi must not depend on var (which is written) or be reassigned
    }
    if (info.step != nullptr && !exprInvariant(info.step, w->body)) {
        return;
    }

    ExprPtr guard = buildHoistGuard(w->body, info);
    if (guard == nullptr) {
        return;
    }
    StmtPtr fast = cloneStmtDeep(w);
    Block& fastBody = static_cast<WhileStmt*>(fast.get())->body;
    const SourceLocation loc = w->loc;
    versionLoop(slot, std::move(guard), std::move(fast), fastBody, info.var, loc);
}

// ---------- driver: walk every block, versioning innermost loops first ----------

void walkBlock(Block& b);

void walkStmt(StmtPtr& slot) {
    Stmt* s = slot.get();
    // The safety verdict is taken BEFORE descending, on the body as the user wrote it.
    //
    // This is not a micro-optimization, it is a correctness-of-intent fix. Versioning a nested loop
    // inserts a guard that calls `arr.length()` -- a CallExpr -- into this body. Recomputing
    // "does the body make calls?" afterwards then sees OUR OWN guard and refuses to version the loop
    // above it. The rule exists to stop USER code from reallocating or freeing the array mid-loop;
    // a synthesized length read does neither, so it must not count against us. The cost of getting
    // this wrong was measured: the sieve in `performance tests/primes.pol` kept a bounds check across
    // 20 million outer iterations, ~9 ms of a 54 ms run, and the pass had blocked itself.
    if (auto* f = dynamic_cast<ForStmt*>(s)) {
        const bool bodySafe = !blockUnsafe(f->body);
        walkBlock(f->body);          // version nested loops first
        tryVersion(slot, bodySafe);  // may replace `slot` with an IfStmt (copies already processed)
        return;
    }
    if (auto* w = dynamic_cast<WhileStmt*>(s)) {
        const bool bodySafe = !blockUnsafe(w->body);
        walkBlock(w->body);          // version nested loops first
        tryVersionWhile(slot, bodySafe);
        return;
    }
    if (auto* d = dynamic_cast<DoWhileStmt*>(s)) { walkBlock(d->body); return; }
    if (auto* i = dynamic_cast<IfStmt*>(s)) {
        walkBlock(i->thenBlock);
        if (i->elseBlock) {
            walkBlock(*i->elseBlock);
        }
        return;
    }
    if (auto* blk = dynamic_cast<Block*>(s)) { walkBlock(*blk); return; }
}

void walkBlock(Block& b) {
    for (auto& s : b.statements) {
        walkStmt(s);
    }
}

// A MASKED-INDEX LOOP IS NOT VERSIONED, AND THAT WAS MEASURED RATHER THAN ASSUMED.
//
// A hash probe -- `i = h & mask; while (used[i] != 0) { ...; i = (i + 1) & mask; }` -- is the one loop
// shape this pass cannot see, because `i` wraps and so is affine in nothing. It is also where the
// bounds checks cost the most on paper: 10 instructions per probe against the identical C++ map's 6.
//
// It was built (2026-08-14): recognise the seed `v = <x> & M`, prove every write to `v` inside is
// masked by the same M, and version on `M >= 0 && M < arr.length()`. `M >= 0` is the whole soundness
// argument -- with `cap == 0` the mask is `-1` and `x & -1` is unbounded, so the guard must and does
// reject it. It worked exactly as designed: the fast loop came out at FIVE instructions, tighter than
// the C++ twin's six, with both bounds checks gone and both array bases in registers.
//
// AND IT MADE THE BENCHMARK SLOWER: `coll_mapoa` 38.3 -> 44.3 ms, and 40.9 even with the inliner
// forced past the size the duplication added. The reason is a property of hash probes rather than of
// this transform: **the loop is hot in CALLS, not in ITERATIONS**. With a well-distributed table the
// chain is about one step, so versioning pays ~8 setup instructions on every `slotFor` to save five in
// a body that almost never repeats.
//
// So the lever on a probe is the cost of ONE probe, not of the loop -- which is also why deleting the
// checks outright measured 38.3 -> 32.4 ms while making the loop smaller measured nothing. Anything
// that adds per-call setup loses here, however good the loop looks afterwards.
//
// Kept as a comment and not as code: the transform is correct, and the next person to look at this
// shape should know it has been written, measured and rejected on evidence.

}  // namespace

void hoistBoundsChecks(ast::Program& program) {
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& cls : ns.classes) {
                for (auto& m : cls.members) {
                    if (auto* md = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        if (!md->isAbstract) {
                            walkBlock(md->body);
                        }
                    }
                }
            }
        }
    }
}

}  // namespace polaron
