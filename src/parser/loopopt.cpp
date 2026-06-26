#include "parser/loopopt.h"

#include <string>
#include <vector>

#include "parser/monomorphize.h"  // cloneExprDeep / cloneStmtDeep

namespace ldp3 {
namespace {

using ast::Expr;
using ast::Stmt;

// ---- Occurrence analysis -------------------------------------------------------------------------

// Does `name` appear as an identifier anywhere in `e`? Leaves that cannot contain it return false;
// composite nodes recurse; any node type not handled returns true (conservative -> callers bail).
bool occurs(const Expr* e, const std::string& name) {
    if (e == nullptr) return false;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) return id->name == name;
    if (dynamic_cast<const ast::IntLiteralExpr*>(e)) return false;
    if (dynamic_cast<const ast::FloatLiteralExpr*>(e)) return false;
    if (dynamic_cast<const ast::BoolLiteralExpr*>(e)) return false;
    if (dynamic_cast<const ast::CharLiteralExpr*>(e)) return false;
    if (dynamic_cast<const ast::StringLiteralExpr*>(e)) return false;
    if (dynamic_cast<const ast::NullLiteralExpr*>(e)) return false;
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e))
        return occurs(b->lhs.get(), name) || occurs(b->rhs.get(), name);
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) return occurs(u->operand.get(), name);
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e))
        return occurs(ix->array.get(), name) || occurs(ix->index.get(), name);
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) return occurs(m->object.get(), name);
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) return occurs(ca->operand.get(), name);
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e))
        return occurs(t->cond.get(), name) || occurs(t->thenExpr.get(), name) ||
               occurs(t->elseExpr.get(), name);
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        if (occurs(c->callee.get(), name)) return true;
        for (const auto& a : c->args)
            if (occurs(a.get(), name)) return true;
        return false;
    }
    return true;  // unknown node: assume it might contain `name` (callers then bail -> safe)
}

// `name` appears as a top-level additive term of `e` (e.g. j in `k*n + j`): unit stride.
bool isUnitAdditive(const Expr* e, const std::string& name) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) return id->name == name;
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        if (b->op == "+") return isUnitAdditive(b->lhs.get(), name) || isUnitAdditive(b->rhs.get(), name);
        if (b->op == "-") return isUnitAdditive(b->lhs.get(), name);  // left side of a subtraction
    }
    return false;
}

// `name` appears inside a multiply/divide subexpression of `e` (e.g. k in `k*n + j`): strided.
bool isMultiplied(const Expr* e, const std::string& name) {
    const auto* b = dynamic_cast<const ast::BinaryExpr*>(e);
    if (b == nullptr) return false;
    if ((b->op == "*" || b->op == "/" || b->op == "%") &&
        (occurs(b->lhs.get(), name) || occurs(b->rhs.get(), name)))
        return true;
    return isMultiplied(b->lhs.get(), name) || isMultiplied(b->rhs.get(), name);
}

// True if some array access in `e` is strided in `k` but unit in `j` -- so making `j` the inner
// loop turns it into a unit-stride access (the whole point of the interchange).
bool hasStridedKUnitJ(const Expr* e, const std::string& j, const std::string& k) {
    if (e == nullptr) return false;
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        const Expr* idx = ix->index.get();
        if (isUnitAdditive(idx, j) && isMultiplied(idx, k)) return true;
        return hasStridedKUnitJ(ix->array.get(), j, k) || hasStridedKUnitJ(ix->index.get(), j, k);
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e))
        return hasStridedKUnitJ(b->lhs.get(), j, k) || hasStridedKUnitJ(b->rhs.get(), j, k);
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e))
        return hasStridedKUnitJ(u->operand.get(), j, k);
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e))
        return hasStridedKUnitJ(ca->operand.get(), j, k);
    return false;
}

// ---- Counted-loop matching -----------------------------------------------------------------------

// Matches `for (<v init>; v < BOUND; v++)`: extracts the loop variable name and the bound. Returns
// false for any other shape (conservative).
bool matchCounted(const ast::ForStmt* f, std::string& var, const Expr*& bound) {
    if (f == nullptr || f->init == nullptr || f->cond == nullptr || f->update == nullptr) return false;
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(f->init.get()))
        var = vd->name;
    else if (const auto* as = dynamic_cast<const ast::AssignStmt*>(f->init.get())) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get());
        if (id == nullptr) return false;
        var = id->name;
    } else {
        return false;
    }
    const auto* cmp = dynamic_cast<const ast::BinaryExpr*>(f->cond.get());
    if (cmp == nullptr || (cmp->op != "<" && cmp->op != "<=")) return false;
    const auto* lhs = dynamic_cast<const ast::IdentifierExpr*>(cmp->lhs.get());
    if (lhs == nullptr || lhs->name != var) return false;
    bound = cmp->rhs.get();
    const auto* inc = dynamic_cast<const ast::IncDecStmt*>(f->update.get());
    if (inc == nullptr || !inc->isIncrement) return false;
    const auto* it = dynamic_cast<const ast::IdentifierExpr*>(inc->target.get());
    return it != nullptr && it->name == var;
}

// ---- Aliasing safety: `name` is a distinct, single-assignment new[] buffer in `body` -------------

struct UseCounts {
    int total = 0;        // every identifier use of the name
    int arrayBase = 0;    // uses as the array operand of an index expr
    int deleteTgt = 0;    // uses as a `delete name;` target
    int newDecls = 0;     // declarations `T[] name = new T[...]`
    int otherDecls = 0;   // any other declaration of the name (disqualifies)
    int assignTgt = 0;    // `name = ...` (disqualifies)
    bool unknown = false; // a statement kind we don't analyze appears -> bail (conservative)
};

void countExpr(const Expr* e, const std::string& name, UseCounts& c, bool asArrayBase) {
    if (e == nullptr) return;
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        if (id->name == name) {
            c.total++;
            if (asArrayBase) c.arrayBase++;
        }
        return;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        countExpr(ix->array.get(), name, c, /*asArrayBase=*/true);
        countExpr(ix->index.get(), name, c, false);
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        countExpr(b->lhs.get(), name, c, false);
        countExpr(b->rhs.get(), name, c, false);
        return;
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) { countExpr(u->operand.get(), name, c, false); return; }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) { countExpr(m->object.get(), name, c, false); return; }
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) { countExpr(ca->operand.get(), name, c, false); return; }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) {
        countExpr(t->cond.get(), name, c, false);
        countExpr(t->thenExpr.get(), name, c, false);
        countExpr(t->elseExpr.get(), name, c, false);
        return;
    }
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(e)) {
        countExpr(call->callee.get(), name, c, false);
        for (const auto& a : call->args) countExpr(a.get(), name, c, false);
        return;
    }
    // Other expr kinds: nothing references a plain local array name in a way we recognize as safe.
}

void countBlock(const ast::Block& b, const std::string& name, UseCounts& c);

void countStmt(const Stmt* s, const std::string& name, UseCounts& c) {
    if (s == nullptr) return;
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        if (vd->name == name) {
            if (dynamic_cast<const ast::NewArrayExpr*>(vd->init.get()) != nullptr) c.newDecls++;
            else c.otherDecls++;
        }
        countExpr(vd->init.get(), name, c, false);
        return;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get()))
            if (id->name == name) c.assignTgt++;
        countExpr(as->target.get(), name, c, false);
        countExpr(as->value.get(), name, c, false);
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(s)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(del->target.get()))
            if (id->name == name) { c.deleteTgt++; c.total++; return; }
        countExpr(del->target.get(), name, c, false);
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) { countExpr(es->expr.get(), name, c, false); return; }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) { countExpr(rs->value.get(), name, c, false); return; }
    if (const auto* incd = dynamic_cast<const ast::IncDecStmt*>(s)) { countExpr(incd->target.get(), name, c, false); return; }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
        countExpr(ifs->cond.get(), name, c, false);
        countBlock(ifs->thenBlock, name, c);
        if (ifs->elseBlock) countBlock(*ifs->elseBlock, name, c);
        return;
    }
    if (const auto* ws = dynamic_cast<const ast::WhileStmt*>(s)) {
        countExpr(ws->cond.get(), name, c, false);
        countBlock(ws->body, name, c);
        return;
    }
    if (const auto* fs = dynamic_cast<const ast::ForStmt*>(s)) {
        countStmt(fs->init.get(), name, c);
        countExpr(fs->cond.get(), name, c, false);
        countStmt(fs->update.get(), name, c);
        countBlock(fs->body, name, c);
        return;
    }
    if (const auto* bl = dynamic_cast<const ast::Block*>(s)) { countBlock(*bl, name, c); return; }
    // An unrecognized statement kind might use `name` in a way we can't see (foreach, switch,
    // try, ...). Mark the scan unknown so isDistinctBuffer bails -- correctness over coverage.
    c.unknown = true;
}

void countBlock(const ast::Block& b, const std::string& name, UseCounts& c) {
    for (const auto& s : b.statements) countStmt(s.get(), name, c);
}

// `name` is a buffer we can treat as not aliasing any other distinctly-named buffer: declared
// exactly once as `T[] name = new T[...]`, never reassigned, and used only to index or delete.
bool isDistinctBuffer(const ast::Block& methodBody, const std::string& name) {
    UseCounts c;
    countBlock(methodBody, name, c);
    if (c.unknown) return false;  // an unanalyzed statement kind is present -> be safe
    if (c.newDecls != 1 || c.otherDecls != 0) return false;
    if (c.assignTgt != 0) return false;
    return c.total == c.arrayBase + c.deleteTgt;  // every use is an index base or a delete
}

// ---- The transform -------------------------------------------------------------------------------

// Collect the distinct array base names indexed in `e`.
void collectArrayBases(const Expr* e, std::vector<std::string>& out) {
    if (e == nullptr) return;
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(ix->array.get())) out.push_back(id->name);
        collectArrayBases(ix->array.get(), out);
        collectArrayBases(ix->index.get(), out);
        return;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        collectArrayBases(b->lhs.get(), out);
        collectArrayBases(b->rhs.get(), out);
        return;
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) { collectArrayBases(u->operand.get(), out); return; }
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) { collectArrayBases(ca->operand.get(), out); return; }
}

std::unique_ptr<ast::AssignStmt> makeAssign(ast::ExprPtr target, ast::ExprPtr value, SourceLocation loc) {
    auto a = std::make_unique<ast::AssignStmt>();
    a->loc = loc;
    a->target = std::move(target);
    a->value = std::move(value);
    return a;
}

// Build a `for (<jInit>; <jCond>; <jUpdate>) <body>` from cloned j-loop headers.
std::unique_ptr<ast::ForStmt> makeJLoop(const ast::ForStmt& jSrc, ast::StmtPtr body) {
    auto f = std::make_unique<ast::ForStmt>();
    f->loc = jSrc.loc;
    f->init = cloneStmtDeep(jSrc.init.get());
    f->cond = cloneExprDeep(jSrc.cond.get());
    f->update = cloneStmtDeep(jSrc.update.get());
    f->body.loc = jSrc.body.loc;
    f->body.statements.push_back(std::move(body));
    return f;
}

// If `jLoop` is an interchangeable reduction nest, returns the replacement statements; else empty.
std::vector<ast::StmtPtr> tryTransform(const ast::ForStmt& jLoop, const ast::Block& methodBody) {
    std::vector<ast::StmtPtr> none;
    std::string j;
    const Expr* jBound = nullptr;
    if (!matchCounted(&jLoop, j, jBound)) return none;
    // Body must be exactly: [VarDecl acc = INIT] [ForStmt kLoop] [Assign DEST = acc].
    if (jLoop.body.statements.size() != 3) return none;
    const auto* accDecl = dynamic_cast<const ast::VarDeclStmt*>(jLoop.body.statements[0].get());
    const auto* kLoop = dynamic_cast<const ast::ForStmt*>(jLoop.body.statements[1].get());
    const auto* store = dynamic_cast<const ast::AssignStmt*>(jLoop.body.statements[2].get());
    if (accDecl == nullptr || kLoop == nullptr || store == nullptr) return none;
    if (accDecl->init == nullptr) return none;
    const std::string acc = accDecl->name;
    // Store must be `DEST = acc` where DEST does not depend on k and acc is exactly the value.
    const auto* storeVal = dynamic_cast<const ast::IdentifierExpr*>(store->value.get());
    if (storeVal == nullptr || storeVal->name != acc) return none;
    const Expr* dest = store->target.get();
    // k-loop matching.
    std::string k;
    const Expr* kBound = nullptr;
    if (!matchCounted(kLoop, k, kBound)) return none;
    if (j == k) return none;
    // k-loop body must be exactly `acc = acc + EXPR`.
    if (kLoop->body.statements.size() != 1) return none;
    const auto* red = dynamic_cast<const ast::AssignStmt*>(kLoop->body.statements[0].get());
    if (red == nullptr) return none;
    const auto* redTgt = dynamic_cast<const ast::IdentifierExpr*>(red->target.get());
    if (redTgt == nullptr || redTgt->name != acc) return none;
    const auto* sum = dynamic_cast<const ast::BinaryExpr*>(red->value.get());
    if (sum == nullptr || sum->op != "+") return none;
    // One side of the `+` is `acc`, the other is the reduction term EXPR.
    const Expr* term = nullptr;
    if (const auto* l = dynamic_cast<const ast::IdentifierExpr*>(sum->lhs.get()); l && l->name == acc)
        term = sum->rhs.get();
    else if (const auto* r = dynamic_cast<const ast::IdentifierExpr*>(sum->rhs.get()); r && r->name == acc)
        term = sum->lhs.get();
    if (term == nullptr) return none;

    // ---- Legality ----
    if (occurs(term, acc)) return none;            // EXPR must not reference the accumulator
    if (occurs(dest, acc) || occurs(dest, k)) return none;  // DEST must be k-independent (and not acc)
    if (occurs(jBound, k) || occurs(kBound, j)) return none;  // bounds must not cross-depend
    if (occurs(accDecl->init.get(), j) || occurs(accDecl->init.get(), k)) return none;  // INIT loop-invariant

    // ---- Profitability ----
    if (!hasStridedKUnitJ(term, j, k)) return none;  // interchange must turn a strided access unit-stride

    // ---- Aliasing safety ----
    // DEST must be an array element whose base buffer is distinct from every buffer read in EXPR,
    // and all of them must be distinct single-assignment new[] locals.
    const auto* destIx = dynamic_cast<const ast::IndexExpr*>(dest);
    if (destIx == nullptr) return none;
    const auto* destBaseId = dynamic_cast<const ast::IdentifierExpr*>(destIx->array.get());
    if (destBaseId == nullptr) return none;
    const std::string destBase = destBaseId->name;
    std::vector<std::string> readBases;
    collectArrayBases(term, readBases);
    if (readBases.empty()) return none;
    if (!isDistinctBuffer(methodBody, destBase)) return none;
    for (const std::string& rb : readBases) {
        if (rb == destBase) return none;  // DEST aliases a read array
        if (!isDistinctBuffer(methodBody, rb)) return none;
    }

    // ---- Build the replacement ----
    // 1) init loop:  for (j) DEST = INIT;
    auto initStore = makeAssign(cloneExprDeep(dest), cloneExprDeep(accDecl->init.get()), store->loc);
    auto initLoop = makeJLoop(jLoop, std::move(initStore));
    // 2) interchanged loop: for (k) for (j) DEST = DEST + EXPR;
    auto accumVal = std::make_unique<ast::BinaryExpr>();
    accumVal->loc = red->loc;
    accumVal->op = "+";
    accumVal->lhs = cloneExprDeep(dest);
    accumVal->rhs = cloneExprDeep(term);
    auto accum = makeAssign(cloneExprDeep(dest), std::move(accumVal), red->loc);
    auto innerJ = makeJLoop(jLoop, std::move(accum));
    auto kOuter = std::make_unique<ast::ForStmt>();
    kOuter->loc = kLoop->loc;
    kOuter->init = cloneStmtDeep(kLoop->init.get());
    kOuter->cond = cloneExprDeep(kLoop->cond.get());
    kOuter->update = cloneStmtDeep(kLoop->update.get());
    kOuter->body.loc = kLoop->body.loc;
    kOuter->body.statements.push_back(std::move(innerJ));

    std::vector<ast::StmtPtr> out;
    out.push_back(std::move(initLoop));
    out.push_back(std::move(kOuter));
    return out;
}

void transformBlock(ast::Block& block, const ast::Block& methodBody) {
    // Recurse into nested blocks first.
    for (auto& s : block.statements) {
        if (auto* f = dynamic_cast<ast::ForStmt*>(s.get())) transformBlock(f->body, methodBody);
        else if (auto* w = dynamic_cast<ast::WhileStmt*>(s.get())) transformBlock(w->body, methodBody);
        else if (auto* i = dynamic_cast<ast::IfStmt*>(s.get())) {
            transformBlock(i->thenBlock, methodBody);
            if (i->elseBlock) transformBlock(*i->elseBlock, methodBody);
        }
    }
    // Then rewrite matching reduction nests in this block. Always rebuild (moving every statement
    // into `rebuilt` and back) so non-matching statements are preserved -- gating the reassignment
    // would leave the moved-from originals dangling.
    std::vector<ast::StmtPtr> rebuilt;
    for (auto& s : block.statements) {
        if (auto* f = dynamic_cast<ast::ForStmt*>(s.get())) {
            std::vector<ast::StmtPtr> repl = tryTransform(*f, methodBody);
            if (!repl.empty()) {
                for (auto& r : repl) rebuilt.push_back(std::move(r));
                continue;
            }
        }
        rebuilt.push_back(std::move(s));
    }
    block.statements = std::move(rebuilt);
}

void transformMethodBody(ast::Block& body) { transformBlock(body, body); }

}  // namespace

void interchangeReductionLoops(ast::Program& program) {
    for (ast::Bundle& b : program.bundles)
        for (ast::Namespace& ns : b.namespaces)
            for (ast::ClassDecl& c : ns.classes)
                for (ast::MemberPtr& m : c.members) {
                    if (auto* md = dynamic_cast<ast::MethodDecl*>(m.get())) transformMethodBody(md->body);
                    else if (auto* ctor = dynamic_cast<ast::ConstructorDecl*>(m.get())) transformMethodBody(ctor->body);
                    else if (auto* dtor = dynamic_cast<ast::DestructorDecl*>(m.get())) transformMethodBody(dtor->body);
                }
}

}  // namespace ldp3
