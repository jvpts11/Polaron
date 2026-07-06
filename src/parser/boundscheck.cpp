#include "parser/boundscheck.h"

#include <memory>
#include <set>
#include <string>
#include <vector>

#include "parser/monomorphize.h"  // cloneStmtDeep

namespace ldp3 {
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

// ---------- conservative predicates (unknown node type => treat as unsafe) ----------

// True if `e` contains anything that could call user code or allocate/free (a call, a lambda, a new).
// Conservative: an expression node type not handled here is assumed to possibly contain such a thing.
bool exprUnsafe(const Expr* e) {
    if (e == nullptr) return false;
    if (dynamic_cast<const CallExpr*>(e)) return true;
    if (dynamic_cast<const NewExpr*>(e)) return true;
    if (dynamic_cast<const NewArrayExpr*>(e)) return true;
    if (dynamic_cast<const LambdaExpr*>(e)) return true;
    if (dynamic_cast<const IdentifierExpr*>(e)) return false;
    if (dynamic_cast<const IntLiteralExpr*>(e)) return false;
    if (dynamic_cast<const FloatLiteralExpr*>(e)) return false;
    if (dynamic_cast<const BoolLiteralExpr*>(e)) return false;
    if (dynamic_cast<const CharLiteralExpr*>(e)) return false;
    if (dynamic_cast<const StringLiteralExpr*>(e)) return false;
    if (dynamic_cast<const NullLiteralExpr*>(e)) return false;
    if (const auto* b = dynamic_cast<const BinaryExpr*>(e)) return exprUnsafe(b->lhs.get()) || exprUnsafe(b->rhs.get());
    if (const auto* u = dynamic_cast<const UnaryExpr*>(e)) return exprUnsafe(u->operand.get());
    if (const auto* ix = dynamic_cast<const IndexExpr*>(e)) return exprUnsafe(ix->array.get()) || exprUnsafe(ix->index.get());
    if (const auto* m = dynamic_cast<const MemberExpr*>(e)) return exprUnsafe(m->object.get());
    if (const auto* c = dynamic_cast<const CastExpr*>(e)) return exprUnsafe(c->operand.get());
    if (const auto* t = dynamic_cast<const TernaryExpr*>(e))
        return exprUnsafe(t->cond.get()) || exprUnsafe(t->thenExpr.get()) || exprUnsafe(t->elseExpr.get());
    return true;  // unknown expression type -> conservatively unsafe
}

bool blockUnsafe(const Block& b);

// True if `s` (or anything it contains) could call/allocate/free, or is a statement type we do not fully
// understand. Conservative: unknown statement type => unsafe, so it is never hoisted across.
bool stmtUnsafe(const Stmt* s) {
    if (s == nullptr) return false;
    if (dynamic_cast<const DeleteStmt*>(s)) return true;  // could free the array
    if (const auto* es = dynamic_cast<const ExprStmt*>(s)) return exprUnsafe(es->expr.get());
    if (const auto* vd = dynamic_cast<const VarDeclStmt*>(s)) return exprUnsafe(vd->init.get());
    if (const auto* as = dynamic_cast<const AssignStmt*>(s)) return exprUnsafe(as->target.get()) || exprUnsafe(as->value.get());
    if (const auto* id = dynamic_cast<const IncDecStmt*>(s)) return exprUnsafe(id->target.get());
    if (const auto* rs = dynamic_cast<const ReturnStmt*>(s)) return exprUnsafe(rs->value.get());
    if (dynamic_cast<const BreakStmt*>(s)) return false;
    if (dynamic_cast<const ContinueStmt*>(s)) return false;
    if (const auto* blk = dynamic_cast<const Block*>(s)) return blockUnsafe(*blk);
    if (const auto* i = dynamic_cast<const IfStmt*>(s))
        return exprUnsafe(i->cond.get()) || blockUnsafe(i->thenBlock) || (i->elseBlock && blockUnsafe(*i->elseBlock));
    if (const auto* f = dynamic_cast<const ForStmt*>(s))
        return stmtUnsafe(f->init.get()) || exprUnsafe(f->cond.get()) || stmtUnsafe(f->update.get()) || blockUnsafe(f->body);
    if (const auto* w = dynamic_cast<const WhileStmt*>(s)) return exprUnsafe(w->cond.get()) || blockUnsafe(w->body);
    if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) return exprUnsafe(d->cond.get()) || blockUnsafe(d->body);
    return true;  // unknown statement type -> conservatively unsafe
}

bool blockUnsafe(const Block& b) {
    for (const auto& s : b.statements)
        if (stmtUnsafe(s.get())) return true;
    return false;
}

// ---------- writes to a variable / member (for invariance + monotonicity) ----------

bool identWrittenInExpr(const Expr* /*e*/, const std::string& /*name*/) { return false; }  // writes are statements

bool identWrittenInBlock(const Block& b, const std::string& name);

bool identWrittenInStmt(const Stmt* s, const std::string& name) {
    if (s == nullptr) return false;
    if (const auto* as = dynamic_cast<const AssignStmt*>(s)) {
        if (const auto* id = dynamic_cast<const IdentifierExpr*>(as->target.get()))
            if (id->name == name) return true;
    }
    if (const auto* idd = dynamic_cast<const IncDecStmt*>(s)) {
        if (const auto* id = dynamic_cast<const IdentifierExpr*>(idd->target.get()))
            if (id->name == name) return true;
    }
    if (const auto* vd = dynamic_cast<const VarDeclStmt*>(s))
        if (vd->name == name) return true;  // shadow/redeclare
    if (const auto* blk = dynamic_cast<const Block*>(s)) return identWrittenInBlock(*blk, name);
    if (const auto* i = dynamic_cast<const IfStmt*>(s))
        return identWrittenInBlock(i->thenBlock, name) || (i->elseBlock && identWrittenInBlock(*i->elseBlock, name));
    if (const auto* f = dynamic_cast<const ForStmt*>(s))
        return identWrittenInStmt(f->init.get(), name) || identWrittenInStmt(f->update.get(), name) || identWrittenInBlock(f->body, name);
    if (const auto* w = dynamic_cast<const WhileStmt*>(s)) return identWrittenInBlock(w->body, name);
    if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) return identWrittenInBlock(d->body, name);
    return false;
}

bool identWrittenInBlock(const Block& b, const std::string& name) {
    for (const auto& s : b.statements)
        if (identWrittenInStmt(s.get(), name)) return true;
    return false;
}

// True if `this.field` is the target of any assignment in the block (would change the array's identity).
bool memberWrittenInBlock(const Block& b, const std::string& field);

bool memberWrittenInStmt(const Stmt* s, const std::string& field) {
    if (s == nullptr) return false;
    if (const auto* as = dynamic_cast<const AssignStmt*>(s)) {
        if (const auto* m = dynamic_cast<const MemberExpr*>(as->target.get()))
            if (const auto* o = dynamic_cast<const IdentifierExpr*>(m->object.get()))
                if (m->member == field && o->name == "this") return true;
    }
    if (const auto* blk = dynamic_cast<const Block*>(s)) return memberWrittenInBlock(*blk, field);
    if (const auto* i = dynamic_cast<const IfStmt*>(s))
        return memberWrittenInBlock(i->thenBlock, field) || (i->elseBlock && memberWrittenInBlock(*i->elseBlock, field));
    if (const auto* f = dynamic_cast<const ForStmt*>(s)) return memberWrittenInBlock(f->body, field);
    if (const auto* w = dynamic_cast<const WhileStmt*>(s)) return memberWrittenInBlock(w->body, field);
    if (const auto* d = dynamic_cast<const DoWhileStmt*>(s)) return memberWrittenInBlock(d->body, field);
    return false;
}

bool memberWrittenInBlock(const Block& b, const std::string& field) {
    for (const auto& s : b.statements)
        if (memberWrittenInStmt(s.get(), field)) return true;
    return false;
}

// ---------- array-expression identity ----------

// A stable key for a "simple" array expression, or "" if the expression is not one we can prove
// invariant / re-evaluate in the guard. Only a bare local/param (`a`) or a `this` field (`this.data`).
std::string arrayKey(const Expr* e) {
    if (const auto* id = dynamic_cast<const IdentifierExpr*>(e)) return "$" + id->name;
    if (const auto* m = dynamic_cast<const MemberExpr*>(e))
        if (const auto* o = dynamic_cast<const IdentifierExpr*>(m->object.get()))
            if (m->member.size() && o->name == "this") return "@" + m->member;
    return "";
}

// Is the array named by `key` provably unchanged over the loop body? (No call/alloc has already been
// ruled out by blockUnsafe; here we only need to rule out a direct reassignment of the base.)
bool arrayInvariant(const std::string& key, const Block& body) {
    if (key.empty()) return false;
    if (key[0] == '$') return !identWrittenInBlock(body, key.substr(1));   // local/param base
    if (key[0] == '@') return !memberWrittenInBlock(body, key.substr(1));  // this.field base
    return false;
}

// A pure, side-effect-free, call-free expression safe to clone and re-evaluate in the guard.
bool pureSimple(const Expr* e) { return !exprUnsafe(e); }

// Collect every identifier read in `e` (for invariance checks on a bound / step expression).
void collectIdents(const Expr* e, std::set<std::string>& out) {
    if (e == nullptr) return;
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
    for (const auto& id : ids)
        if (identWrittenInBlock(body, id)) return false;
    return true;
}

// ---------- collect `array[var]` accesses (bare induction index) ----------

void collectBareAccessesExpr(Expr* e, const std::string& var, std::vector<IndexExpr*>& out);

void collectBareAccessesBlock(Block& b, const std::string& var, std::vector<IndexExpr*>& out);

void collectBareAccessesStmt(Stmt* s, const std::string& var, std::vector<IndexExpr*>& out) {
    if (s == nullptr) return;
    if (auto* es = dynamic_cast<ExprStmt*>(s)) collectBareAccessesExpr(es->expr.get(), var, out);
    else if (auto* vd = dynamic_cast<VarDeclStmt*>(s)) collectBareAccessesExpr(vd->init.get(), var, out);
    else if (auto* as = dynamic_cast<AssignStmt*>(s)) { collectBareAccessesExpr(as->target.get(), var, out); collectBareAccessesExpr(as->value.get(), var, out); }
    else if (auto* idd = dynamic_cast<IncDecStmt*>(s)) collectBareAccessesExpr(idd->target.get(), var, out);
    else if (auto* rs = dynamic_cast<ReturnStmt*>(s)) collectBareAccessesExpr(rs->value.get(), var, out);
    else if (auto* blk = dynamic_cast<Block*>(s)) collectBareAccessesBlock(*blk, var, out);
    else if (auto* i = dynamic_cast<IfStmt*>(s)) { collectBareAccessesExpr(i->cond.get(), var, out); collectBareAccessesBlock(i->thenBlock, var, out); if (i->elseBlock) collectBareAccessesBlock(*i->elseBlock, var, out); }
    else if (auto* f = dynamic_cast<ForStmt*>(s)) { collectBareAccessesStmt(f->init.get(), var, out); collectBareAccessesExpr(f->cond.get(), var, out); collectBareAccessesStmt(f->update.get(), var, out); collectBareAccessesBlock(f->body, var, out); }
    else if (auto* w = dynamic_cast<WhileStmt*>(s)) { collectBareAccessesExpr(w->cond.get(), var, out); collectBareAccessesBlock(w->body, var, out); }
    else if (auto* d = dynamic_cast<DoWhileStmt*>(s)) { collectBareAccessesExpr(d->cond.get(), var, out); collectBareAccessesBlock(d->body, var, out); }
}

void collectBareAccessesExpr(Expr* e, const std::string& var, std::vector<IndexExpr*>& out) {
    if (e == nullptr) return;
    if (auto* ix = dynamic_cast<IndexExpr*>(e)) {
        collectBareAccessesExpr(ix->array.get(), var, out);
        collectBareAccessesExpr(ix->index.get(), var, out);
        const auto* idx = dynamic_cast<const IdentifierExpr*>(ix->index.get());
        if (idx != nullptr && idx->name == var && !arrayKey(ix->array.get()).empty()) out.push_back(ix);
        return;
    }
    if (auto* b = dynamic_cast<BinaryExpr*>(e)) { collectBareAccessesExpr(b->lhs.get(), var, out); collectBareAccessesExpr(b->rhs.get(), var, out); return; }
    if (auto* u = dynamic_cast<UnaryExpr*>(e)) { collectBareAccessesExpr(u->operand.get(), var, out); return; }
    if (auto* m = dynamic_cast<MemberExpr*>(e)) { collectBareAccessesExpr(m->object.get(), var, out); return; }
    if (auto* c = dynamic_cast<CastExpr*>(e)) { collectBareAccessesExpr(c->operand.get(), var, out); return; }
    if (auto* t = dynamic_cast<TernaryExpr*>(e)) { collectBareAccessesExpr(t->cond.get(), var, out); collectBareAccessesExpr(t->thenExpr.get(), var, out); collectBareAccessesExpr(t->elseExpr.get(), var, out); return; }
}

void collectBareAccessesBlock(Block& b, const std::string& var, std::vector<IndexExpr*>& out) {
    for (auto& s : b.statements) collectBareAccessesStmt(s.get(), var, out);
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
    if (vd == nullptr || vd->isVar || vd->init == nullptr) return false;
    info.var = vd->name;
    info.lo = vd->init.get();
    // cond: `var </<= HI`
    const auto* cond = dynamic_cast<const BinaryExpr*>(f.cond.get());
    if (cond == nullptr) return false;
    if (cond->op != "<" && cond->op != "<=") return false;
    const auto* lhs = dynamic_cast<const IdentifierExpr*>(cond->lhs.get());
    if (lhs == nullptr || lhs->name != info.var) return false;
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
    if (!okUpdate) return false;
    if (!pureSimple(info.lo) || !pureSimple(info.hi)) return false;
    return true;
}

// ---------- the transform ----------

bool containsLoop(const Block& b);

// True if `s` is, or contains, a loop. Used to restrict versioning to innermost loops.
bool stmtContainsLoop(const Stmt* s) {
    if (dynamic_cast<const ForStmt*>(s) || dynamic_cast<const WhileStmt*>(s) || dynamic_cast<const DoWhileStmt*>(s))
        return true;
    if (const auto* i = dynamic_cast<const IfStmt*>(s))
        return containsLoop(i->thenBlock) || (i->elseBlock && containsLoop(*i->elseBlock));
    if (const auto* blk = dynamic_cast<const Block*>(s)) return containsLoop(*blk);
    return false;
}
bool containsLoop(const Block& b) {
    for (const auto& s : b.statements)
        if (stmtContainsLoop(s.get())) return true;
    return false;
}

// Try to version the for-loop held in `slot`. On success `slot` becomes an IfStmt (guard ? fast : slow).
void tryVersion(StmtPtr& slot) {
    auto* f = dynamic_cast<ForStmt*>(slot.get());
    if (f == nullptr) return;
    ForInfo info;
    if (!analyzeFor(*f, info)) return;
    // Only version innermost loops: versioning a loop whose body holds another (already-versioned) loop
    // would duplicate that inner loop into both copies, multiplying code size with each nesting level.
    if (containsLoop(f->body)) return;
    // The induction variable must not be reassigned inside the body (only the header update moves it).
    if (identWrittenInBlock(f->body, info.var)) return;
    // No calls / allocations / frees in the body -- otherwise the array could be reallocated or freed.
    if (blockUnsafe(f->body)) return;

    // Collect the bare `array[var]` accesses and the distinct arrays they touch.
    std::vector<IndexExpr*> accesses;
    collectBareAccessesBlock(f->body, info.var, accesses);
    if (accesses.empty()) return;
    std::vector<Expr*> arrays;  // one representative array expr per distinct key
    std::vector<std::string> keys;
    for (auto* ix : accesses) {
        std::string k = arrayKey(ix->array.get());
        bool seen = false;
        for (const auto& kk : keys) if (kk == k) { seen = true; break; }
        if (!seen) { keys.push_back(k); arrays.push_back(ix->array.get()); }
    }
    // Every touched array must be provably unchanged across the loop.
    for (const auto& k : keys)
        if (!arrayInvariant(k, f->body)) return;
    // The bound must be loop-invariant: the guard is evaluated once, but the condition re-reads `hi`
    // every iteration, so a `hi` that grows in the body would let the fast copy run past it. Likewise a
    // variable step must be invariant (else it could flip sign and drive the index below lo).
    if (!exprInvariant(info.hi, f->body)) return;
    if (info.step != nullptr && !exprInvariant(info.step, f->body)) return;

    // Build the guard: lo >= 0  &&  (hi <= arr.length())[for `<`] / (hi < arr.length())[for `<=`] per
    // array  &&  (step >= 1)[only for a variable step]. For `i < hi` the max index is hi-1, so
    // `hi <= length`; for `i <= hi` it is hi, so `hi < length`.
    const std::string upperOp = info.inclusive ? "<" : "<=";
    ExprPtr guard = mkBin(">=", cloneExprDeep(info.lo), mkInt("0"));
    for (auto* arr : arrays) {
        ExprPtr clause = mkBin(upperOp, cloneExprDeep(info.hi), mkLength(cloneExprDeep(arr)));
        guard = mkBin("&&", std::move(guard), std::move(clause));
    }
    if (info.step != nullptr)  // ensure the index actually increases, so it stays in [lo, hi)
        guard = mkBin("&&", std::move(guard), mkBin(">=", cloneExprDeep(info.step), mkInt("1")));

    // Fast copy: clone the whole loop, then mark exactly the same accesses unchecked in the clone.
    StmtPtr fast = cloneStmtDeep(f);
    std::vector<IndexExpr*> fastAccesses;
    collectBareAccessesBlock(static_cast<ForStmt*>(fast.get())->body, info.var, fastAccesses);
    for (auto* ix : fastAccesses) ix->unchecked = true;

    // Slow copy: the original loop, left fully checked. Wrap both in `if (guard) fast else slow`.
    auto iff = std::make_unique<IfStmt>();
    iff->loc = f->loc;
    iff->cond = std::move(guard);
    iff->thenBlock.statements.push_back(std::move(fast));
    iff->elseBlock = std::make_unique<Block>();
    iff->elseBlock->statements.push_back(std::move(slot));  // move the original ForStmt into the else
    slot = std::move(iff);
}

// ---------- driver: walk every block, versioning innermost loops first ----------

void walkBlock(Block& b);

void walkStmt(StmtPtr& slot) {
    Stmt* s = slot.get();
    if (auto* f = dynamic_cast<ForStmt*>(s)) {
        walkBlock(f->body);   // version nested loops first
        tryVersion(slot);     // may replace `slot` with an IfStmt (whose copies are already processed)
        return;
    }
    if (auto* w = dynamic_cast<WhileStmt*>(s)) { walkBlock(w->body); return; }
    if (auto* d = dynamic_cast<DoWhileStmt*>(s)) { walkBlock(d->body); return; }
    if (auto* i = dynamic_cast<IfStmt*>(s)) { walkBlock(i->thenBlock); if (i->elseBlock) walkBlock(*i->elseBlock); return; }
    if (auto* blk = dynamic_cast<Block*>(s)) { walkBlock(*blk); return; }
}

void walkBlock(Block& b) {
    for (auto& s : b.statements) walkStmt(s);
}

}  // namespace

void hoistBoundsChecks(ast::Program& program) {
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& cls : ns.classes)
                for (auto& m : cls.members)
                    if (auto* md = dynamic_cast<ast::MethodDecl*>(m.get()))
                        if (!md->isAbstract) walkBlock(md->body);
}

}  // namespace ldp3
