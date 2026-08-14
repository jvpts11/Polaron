#include "parser/loopopt.h"

#include <map>
#include <set>
#include <string>
#include <vector>

#include "parser/monomorphize.h"  // cloneExprDeep / cloneStmtDeep

namespace polaron {
namespace {

using ast::Expr;
using ast::Stmt;

// ---- Occurrence analysis -------------------------------------------------------------------------

// Does `name` appear as an identifier anywhere in `e`? Leaves that cannot contain it return false;
// composite nodes recurse; any node type not handled returns true (conservative -> callers bail).
bool occurs(const Expr* e, const std::string& name) {
    if (e == nullptr) {
        return false;
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        return id->name == name;
    }
    if (dynamic_cast<const ast::IntLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const ast::FloatLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const ast::BoolLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const ast::CharLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const ast::StringLiteralExpr*>(e)) {
        return false;
    }
    if (dynamic_cast<const ast::NullLiteralExpr*>(e)) {
        return false;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        return occurs(b->lhs.get(), name) || occurs(b->rhs.get(), name);
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        return occurs(u->operand.get(), name);
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        return occurs(ix->array.get(), name) || occurs(ix->index.get(), name);
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        return occurs(m->object.get(), name);
    }
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
        return occurs(ca->operand.get(), name);
    }
    if (const auto* t = dynamic_cast<const ast::TernaryExpr*>(e)) {
        return occurs(t->cond.get(), name) || occurs(t->thenExpr.get(), name) ||
               occurs(t->elseExpr.get(), name);
    }
    if (const auto* c = dynamic_cast<const ast::CallExpr*>(e)) {
        if (occurs(c->callee.get(), name)) {
            return true;
        }
        for (const auto& a : c->args) {
            if (occurs(a.get(), name)) {
                return true;
            }
        }
        return false;
    }
    return true;  // unknown node: assume it might contain `name` (callers then bail -> safe)
}

// `name` appears as a top-level additive term of `e` (e.g. j in `k*n + j`): unit stride.
bool isUnitAdditive(const Expr* e, const std::string& name) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        return id->name == name;
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        if (b->op == "+") {
            return isUnitAdditive(b->lhs.get(), name) || isUnitAdditive(b->rhs.get(), name);
        }
        if (b->op == "-") {
            return isUnitAdditive(b->lhs.get(), name);  // left side of a subtraction
        }
    }
    return false;
}

// `name` appears inside a multiply/divide subexpression of `e` (e.g. k in `k*n + j`): strided.
bool isMultiplied(const Expr* e, const std::string& name) {
    const auto* b = dynamic_cast<const ast::BinaryExpr*>(e);
    if (b == nullptr) {
        return false;
    }
    if ((b->op == "*" || b->op == "/" || b->op == "%") &&
        (occurs(b->lhs.get(), name) || occurs(b->rhs.get(), name))) {
        return true;
    }
    return isMultiplied(b->lhs.get(), name) || isMultiplied(b->rhs.get(), name);
}

// True if some array access in `e` is strided in `k` but unit in `j` -- so making `j` the inner
// loop turns it into a unit-stride access (the whole point of the interchange).
bool hasStridedKUnitJ(const Expr* e, const std::string& j, const std::string& k) {
    if (e == nullptr) {
        return false;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        const Expr* idx = ix->index.get();
        if (isUnitAdditive(idx, j) && isMultiplied(idx, k)) {
            return true;
        }
        return hasStridedKUnitJ(ix->array.get(), j, k) || hasStridedKUnitJ(ix->index.get(), j, k);
    }
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        return hasStridedKUnitJ(b->lhs.get(), j, k) || hasStridedKUnitJ(b->rhs.get(), j, k);
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e)) {
        return hasStridedKUnitJ(u->operand.get(), j, k);
    }
    if (const auto* ca = dynamic_cast<const ast::CastExpr*>(e)) {
        return hasStridedKUnitJ(ca->operand.get(), j, k);
    }
    return false;
}

// ---- Counted-loop matching -----------------------------------------------------------------------

// Matches `for (<v init>; v < BOUND; v++)`: extracts the loop variable name and the bound. Returns
// false for any other shape (conservative).
bool matchCounted(const ast::ForStmt* f, std::string& var, const Expr*& bound) {
    if (f == nullptr || f->init == nullptr || f->cond == nullptr || f->update == nullptr) {
        return false;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(f->init.get())) {
        var = vd->name;
    } else if (const auto* as = dynamic_cast<const ast::AssignStmt*>(f->init.get())) {
        const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get());
        if (id == nullptr) {
            return false;
        }
        var = id->name;
    } else {
        return false;
    }
    const auto* cmp = dynamic_cast<const ast::BinaryExpr*>(f->cond.get());
    if (cmp == nullptr || (cmp->op != "<" && cmp->op != "<=")) {
        return false;
    }
    const auto* lhs = dynamic_cast<const ast::IdentifierExpr*>(cmp->lhs.get());
    if (lhs == nullptr || lhs->name != var) {
        return false;
    }
    bound = cmp->rhs.get();
    const auto* inc = dynamic_cast<const ast::IncDecStmt*>(f->update.get());
    if (inc == nullptr || !inc->isIncrement) {
        return false;
    }
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
    if (e == nullptr) {
        return;
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        if (id->name == name) {
            c.total++;
            if (asArrayBase) {
                c.arrayBase++;
            }
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
        for (const auto& a : call->args) {
            countExpr(a.get(), name, c, false);
        }
        return;
    }
    // Other expr kinds: nothing references a plain local array name in a way we recognize as safe.
}

void countBlock(const ast::Block& b, const std::string& name, UseCounts& c);

void countStmt(const Stmt* s, const std::string& name, UseCounts& c) {
    if (s == nullptr) {
        return;
    }
    if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s)) {
        if (vd->name == name) {
            if (dynamic_cast<const ast::NewArrayExpr*>(vd->init.get()) != nullptr) {
                c.newDecls++;
            } else {
                c.otherDecls++;
            }
        }
        countExpr(vd->init.get(), name, c, false);
        return;
    }
    if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(as->target.get())) {
            if (id->name == name) {
                c.assignTgt++;
            }
        }
        countExpr(as->target.get(), name, c, false);
        countExpr(as->value.get(), name, c, false);
        return;
    }
    if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(s)) {
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(del->target.get())) {
            if (id->name == name) { c.deleteTgt++; c.total++; return; }
        }
        countExpr(del->target.get(), name, c, false);
        return;
    }
    if (const auto* es = dynamic_cast<const ast::ExprStmt*>(s)) { countExpr(es->expr.get(), name, c, false); return; }
    if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s)) { countExpr(rs->value.get(), name, c, false); return; }
    if (const auto* incd = dynamic_cast<const ast::IncDecStmt*>(s)) { countExpr(incd->target.get(), name, c, false); return; }
    if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(s)) {
        countExpr(ifs->cond.get(), name, c, false);
        countBlock(ifs->thenBlock, name, c);
        if (ifs->elseBlock) {
            countBlock(*ifs->elseBlock, name, c);
        }
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
    for (const auto& s : b.statements) {
        countStmt(s.get(), name, c);
    }
}

// `name` is a buffer we can treat as not aliasing any other distinctly-named buffer: declared
// exactly once as `T[] name = new T[...]`, never reassigned, and used only to index or delete.
bool isDistinctBuffer(const ast::Block& methodBody, const std::string& name) {
    UseCounts c;
    countBlock(methodBody, name, c);
    if (c.unknown) {
        return false;  // an unanalyzed statement kind is present -> be safe
    }
    if (c.newDecls != 1 || c.otherDecls != 0) {
        return false;
    }
    if (c.assignTgt != 0) {
        return false;
    }
    return c.total == c.arrayBase + c.deleteTgt;  // every use is an index base or a delete
}

// ---- The transform -------------------------------------------------------------------------------

// A canonical key for an array-base expression: a plain local `c` -> "c"; a field access `obj.data`
// -> "obj.data" (obj a local or `this`). Empty for a base we do not model. Lets the interchange apply
// to OOP code (Matrix.operator* streams this.data / o.data into a fresh r.data) as well as raw arrays.
std::string arrayBaseKey(const Expr* e) {
    if (e == nullptr) {
        return "";
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        return id->name;
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        const std::string obj = arrayBaseKey(m->object.get());
        return obj.empty() ? std::string() : obj + "." + m->member;
    }
    return "";
}

// Splits "obj.field" into (obj, field); false for a plain local (no dot) or a deeper path.
bool splitFieldKey(const std::string& key, std::string& obj, std::string& field) {
    const std::size_t dot = key.find('.');
    if (dot == std::string::npos || key.find('.', dot + 1) != std::string::npos) {
        return false;
    }
    obj = key.substr(0, dot);
    field = key.substr(dot + 1);
    return true;
}

// Collect the distinct array base keys indexed in `e`.
void collectArrayBases(const Expr* e, std::vector<std::string>& out) {
    if (e == nullptr) {
        return;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        if (std::string k = arrayBaseKey(ix->array.get()); !k.empty()) {
            out.push_back(std::move(k));
        }
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

// Structural equality of two expressions (conservative: false for shapes we don't model). Used to
// recognize a direct accumulation `DEST = DEST op EXPR` where the target equals one operand.
bool sameExpr(const Expr* a, const Expr* b) {
    if (a == nullptr || b == nullptr) {
        return a == b;
    }
    if (const auto* x = dynamic_cast<const ast::IdentifierExpr*>(a)) {
        const auto* y = dynamic_cast<const ast::IdentifierExpr*>(b);
        return y != nullptr && x->name == y->name;
    }
    if (const auto* x = dynamic_cast<const ast::IntLiteralExpr*>(a)) {
        const auto* y = dynamic_cast<const ast::IntLiteralExpr*>(b);
        return y != nullptr && x->text == y->text;
    }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(a)) {
        const auto* y = dynamic_cast<const ast::IndexExpr*>(b);
        return y != nullptr && sameExpr(x->array.get(), y->array.get()) &&
               sameExpr(x->index.get(), y->index.get());
    }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(a)) {
        const auto* y = dynamic_cast<const ast::BinaryExpr*>(b);
        return y != nullptr && x->op == y->op && sameExpr(x->lhs.get(), y->lhs.get()) &&
               sameExpr(x->rhs.get(), y->rhs.get());
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(a)) {
        const auto* y = dynamic_cast<const ast::MemberExpr*>(b);
        return y != nullptr && x->member == y->member && sameExpr(x->object.get(), y->object.get());
    }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(a)) {
        const auto* y = dynamic_cast<const ast::CastExpr*>(b);
        return y != nullptr && x->targetType == y->targetType &&
               sameExpr(x->operand.get(), y->operand.get());
    }
    return false;
}

bool isReductionOp(const std::string& op) { return op == "+" || op == "-" || op == "*"; }

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

// Context threaded to the transform: the program's classes (to inspect a fresh result object's
// constructor) and the names that are pre-existing at method entry (`this` + parameters). A fresh
// object's freshly-allocated field cannot alias a pre-existing array -- that is what makes the
// interchange safe for OOP code (Matrix.operator* : r.data is new, this.data/o.data pre-date the call).
struct LoopCtx {
    const std::map<std::string, const ast::ClassDecl*>* classes = nullptr;
    std::set<std::string> preExisting;  // "this" + parameter names
};

// If `obj` is a local in `body` declared exactly `Type obj = new ClassName(...)` and never reassigned,
// returns its ClassDecl (so its constructor can be inspected); else nullptr. `obj.field` writes are
// fine -- only reassigning the reference `obj` itself would break the freshness argument.
const ast::ClassDecl* freshInstanceClass(const ast::Block& body, const std::string& obj,
                                         const LoopCtx& ctx) {
    if (ctx.classes == nullptr) {
        return nullptr;
    }
    UseCounts c;
    countBlock(body, obj, c);
    if (c.unknown || c.assignTgt != 0) {
        return nullptr;  // reassigned, or an unanalyzed statement kind
    }
    const ast::ClassDecl* cls = nullptr;
    for (const auto& s : body.statements) {
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(s.get()); vd && vd->name == obj) {
            const auto* nw = dynamic_cast<const ast::NewExpr*>(vd->init.get());
            if (nw == nullptr) {
                return nullptr;  // not a `new ClassName(...)`
            }
            auto it = ctx.classes->find(nw->className);
            cls = it == ctx.classes->end() ? nullptr : it->second;
        }
    }
    return cls;
}

// True if `cls`'s constructor assigns `this.field = new T[...]` -- so the field is a fresh allocation
// (not a shared array passed in). Then a fresh instance's field is a private buffer.
bool ctorAllocatesFieldFresh(const ast::ClassDecl* cls, const std::string& field) {
    if (cls == nullptr) {
        return false;
    }
    for (const auto& m : cls->members) {
        if (const auto* ctor = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
            for (const auto& s : ctor->body.statements) {
                if (const auto* as = dynamic_cast<const ast::AssignStmt*>(s.get())) {
                    const auto* mem = dynamic_cast<const ast::MemberExpr*>(as->target.get());
                    if (mem == nullptr || mem->member != field) {
                        continue;
                    }
                    const auto* moid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                    if (moid != nullptr && moid->name == "this" &&
                        dynamic_cast<const ast::NewArrayExpr*>(as->value.get()) != nullptr) {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

// If `jLoop` is an interchangeable reduction nest, returns the replacement statements; else empty.
// Two shapes are recognized:
//   A) scalar accumulator:   for(j){ T acc = INIT; for(k) acc = acc OP EXPR; DEST = acc; }
//   B) direct accumulation:  for(j){ for(k) DEST = DEST OP EXPR; }   (DEST k-independent)
// Both interchange to `for(k) for(j) DEST = DEST OP EXPR` (A also emits a `for(j) DEST = INIT;`
// prologue). OP is +, - or *; each DEST accumulates k in the same order, so results are identical.
std::vector<ast::StmtPtr> tryTransform(const ast::ForStmt& jLoop, const ast::Block& methodBody,
                                       const LoopCtx& ctx) {
    std::vector<ast::StmtPtr> none;
    std::string j;
    const Expr* jBound = nullptr;
    if (!matchCounted(&jLoop, j, jBound)) {
        return none;
    }

    const ast::ForStmt* kLoop = nullptr;
    const Expr* dest = nullptr;          // the reduction target lvalue
    const Expr* term = nullptr;          // the per-iteration EXPR
    std::string op;                      // reduction operator
    const ast::VarDeclStmt* accDecl = nullptr;  // shape A only (the scalar accumulator decl)

    if (jLoop.body.statements.size() == 3) {
        // Shape A: [VarDecl acc = INIT] [ForStmt kLoop] [Assign DEST = acc].
        accDecl = dynamic_cast<const ast::VarDeclStmt*>(jLoop.body.statements[0].get());
        kLoop = dynamic_cast<const ast::ForStmt*>(jLoop.body.statements[1].get());
        const auto* store = dynamic_cast<const ast::AssignStmt*>(jLoop.body.statements[2].get());
        if (accDecl == nullptr || kLoop == nullptr || store == nullptr || accDecl->init == nullptr) {
            return none;
        }
        const auto* storeVal = dynamic_cast<const ast::IdentifierExpr*>(store->value.get());
        if (storeVal == nullptr || storeVal->name != accDecl->name) {
            return none;
        }
        dest = store->target.get();
        if (kLoop->body.statements.size() != 1) {
            return none;
        }
        const auto* red = dynamic_cast<const ast::AssignStmt*>(kLoop->body.statements[0].get());
        if (red == nullptr) {
            return none;
        }
        const auto* redTgt = dynamic_cast<const ast::IdentifierExpr*>(red->target.get());
        if (redTgt == nullptr || redTgt->name != accDecl->name) {
            return none;
        }
        const auto* bin = dynamic_cast<const ast::BinaryExpr*>(red->value.get());
        if (bin == nullptr || !isReductionOp(bin->op)) {
            return none;
        }
        op = bin->op;
        // acc must be one operand; the other is EXPR. For '-', acc must be on the left.
        if (const auto* l = dynamic_cast<const ast::IdentifierExpr*>(bin->lhs.get());
            l && l->name == accDecl->name) {
            term = bin->rhs.get();
        } else if (op != "-") {
            if (const auto* r = dynamic_cast<const ast::IdentifierExpr*>(bin->rhs.get());
                r && r->name == accDecl->name) {
                term = bin->lhs.get();
            }
        }
        if (term == nullptr || occurs(term, accDecl->name)) {
            return none;
        }
        if (occurs(dest, accDecl->name)) {
            return none;
        }
        if (occurs(accDecl->init.get(), j)) {
            return none;  // INIT loop-invariant (k checked below)
        }
    } else if (jLoop.body.statements.size() == 1) {
        // Shape B: [ForStmt kLoop] with kLoop body `DEST = DEST OP EXPR`.
        kLoop = dynamic_cast<const ast::ForStmt*>(jLoop.body.statements[0].get());
        if (kLoop == nullptr || kLoop->body.statements.size() != 1) {
            return none;
        }
        const auto* red = dynamic_cast<const ast::AssignStmt*>(kLoop->body.statements[0].get());
        if (red == nullptr) {
            return none;
        }
        const auto* bin = dynamic_cast<const ast::BinaryExpr*>(red->value.get());
        if (bin == nullptr || !isReductionOp(bin->op)) {
            return none;
        }
        op = bin->op;
        dest = red->target.get();
        if (sameExpr(dest, bin->lhs.get())) {
            term = bin->rhs.get();
        } else if (op != "-" && sameExpr(dest, bin->rhs.get())) {
            term = bin->lhs.get();
        }
        if (term == nullptr) {
            return none;
        }
    } else {
        return none;
    }

    // k-loop matching + shared legality.
    std::string k;
    const Expr* kBound = nullptr;
    if (!matchCounted(kLoop, k, kBound)) {
        return none;
    }
    if (j == k) {
        return none;
    }
    if (occurs(dest, k)) {
        return none;  // DEST must be k-independent
    }
    if (occurs(jBound, k) || occurs(kBound, j)) {
        return none;  // bounds must not cross-depend
    }
    if (accDecl != nullptr && occurs(accDecl->init.get(), k)) {
        return none;
    }

    // ---- Profitability: interchange must turn a strided-in-k access unit-stride in j ----
    if (!hasStridedKUnitJ(term, j, k)) {
        return none;
    }

    // ---- Aliasing safety: DEST's buffer distinct from every read buffer ----
    const auto* destIx = dynamic_cast<const ast::IndexExpr*>(dest);
    if (destIx == nullptr) {
        return none;
    }
    const std::string destKey = arrayBaseKey(destIx->array.get());
    if (destKey.empty()) {
        return none;
    }
    std::vector<std::string> readBases;
    collectArrayBases(term, readBases);
    if (readBases.empty()) {
        return none;
    }

    std::string destObj, destField;
    if (splitFieldKey(destKey, destObj, destField)) {
        // OOP field arrays: DEST = destObj.destField, where destObj is a fresh instance whose ctor
        // allocates destField, and every read comes from a pre-existing object (this / a parameter)
        // that is not destObj. A field allocated *inside* this method cannot alias an array that
        // existed before the method, so accumulating into DEST in interchanged order is safe.
        if (!ctorAllocatesFieldFresh(freshInstanceClass(methodBody, destObj, ctx), destField)) {
            return none;
        }
        for (const std::string& rk : readBases) {
            std::string ro, rf;
            if (!splitFieldKey(rk, ro, rf)) {
                return none;  // a non-field (local) read mixed in
            }
            if (ro == destObj) {
                return none;  // reading the fresh dest object itself
            }
            if (ctx.preExisting.count(ro) == 0) {
                return none;  // read object not provably pre-existing
            }
        }
    } else {
        // Raw local arrays: each buffer is a distinct `new T[]` local, never reassigned.
        if (!isDistinctBuffer(methodBody, destKey)) {
            return none;
        }
        for (const std::string& rb : readBases) {
            if (rb.find('.') != std::string::npos) {
                return none;  // a field read mixed with a local dest
            }
            if (rb == destKey) {
                return none;
            }
            if (!isDistinctBuffer(methodBody, rb)) {
                return none;
            }
        }
    }

    // ---- Build: for(k) for(j) DEST = DEST OP EXPR; (shape A prepends for(j) DEST = INIT;) ----
    auto accumVal = std::make_unique<ast::BinaryExpr>();
    accumVal->loc = kLoop->loc;
    accumVal->op = op;
    accumVal->lhs = cloneExprDeep(dest);
    accumVal->rhs = cloneExprDeep(term);
    auto accum = makeAssign(cloneExprDeep(dest), std::move(accumVal), kLoop->loc);
    auto innerJ = makeJLoop(jLoop, std::move(accum));
    auto kOuter = std::make_unique<ast::ForStmt>();
    kOuter->loc = kLoop->loc;
    kOuter->init = cloneStmtDeep(kLoop->init.get());
    kOuter->cond = cloneExprDeep(kLoop->cond.get());
    kOuter->update = cloneStmtDeep(kLoop->update.get());
    kOuter->body.loc = kLoop->body.loc;
    kOuter->body.statements.push_back(std::move(innerJ));

    std::vector<ast::StmtPtr> out;
    if (accDecl != nullptr) {  // shape A: initialize the destination before accumulating
        auto initStore = makeAssign(cloneExprDeep(dest), cloneExprDeep(accDecl->init.get()), jLoop.loc);
        out.push_back(makeJLoop(jLoop, std::move(initStore)));
    }
    out.push_back(std::move(kOuter));
    return out;
}

void transformBlock(ast::Block& block, const ast::Block& methodBody, const LoopCtx& ctx) {
    // Recurse into nested blocks first.
    for (auto& s : block.statements) {
        if (auto* f = dynamic_cast<ast::ForStmt*>(s.get())) {
            transformBlock(f->body, methodBody, ctx);
        } else if (auto* w = dynamic_cast<ast::WhileStmt*>(s.get())) {
            transformBlock(w->body, methodBody, ctx);
        } else if (auto* i = dynamic_cast<ast::IfStmt*>(s.get())) {
            transformBlock(i->thenBlock, methodBody, ctx);
            if (i->elseBlock) {
                transformBlock(*i->elseBlock, methodBody, ctx);
            }
        }
    }
    // Then rewrite matching reduction nests in this block. Always rebuild (moving every statement
    // into `rebuilt` and back) so non-matching statements are preserved -- gating the reassignment
    // would leave the moved-from originals dangling.
    std::vector<ast::StmtPtr> rebuilt;
    for (auto& s : block.statements) {
        if (auto* f = dynamic_cast<ast::ForStmt*>(s.get())) {
            std::vector<ast::StmtPtr> repl = tryTransform(*f, methodBody, ctx);
            if (!repl.empty()) {
                for (auto& r : repl) {
                    rebuilt.push_back(std::move(r));
                }
                continue;
            }
        }
        rebuilt.push_back(std::move(s));
    }
    block.statements = std::move(rebuilt);
}

void transformMethodBody(ast::Block& body, const LoopCtx& ctx) { transformBlock(body, body, ctx); }

}  // namespace

void interchangeReductionLoops(ast::Program& program) {
    // Index classes so a reduction's fresh result object (e.g. `r = new Matrix(...)`) can have its
    // constructor inspected for the field-array aliasing proof.
    std::map<std::string, const ast::ClassDecl*> classes;
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& ns : b.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                classes[c.name] = &c;
            }
        }
    }

    for (ast::Bundle& b : program.bundles) {
        for (ast::Namespace& ns : b.namespaces) {
            for (ast::ClassDecl& c : ns.classes) {
                for (ast::MemberPtr& m : c.members) {
                    LoopCtx ctx;
                    ctx.classes = &classes;
                    ctx.preExisting.insert("this");  // the receiver and the parameters pre-date the call
                    if (auto* md = dynamic_cast<ast::MethodDecl*>(m.get())) {
                        for (const auto& p : md->params) {
                            ctx.preExisting.insert(p.name);
                        }
                        transformMethodBody(md->body, ctx);
                    } else if (auto* ctor = dynamic_cast<ast::ConstructorDecl*>(m.get())) {
                        for (const auto& p : ctor->params) {
                            ctx.preExisting.insert(p.name);
                        }
                        transformMethodBody(ctor->body, ctx);
                    } else if (auto* dtor = dynamic_cast<ast::DestructorDecl*>(m.get())) {
                        transformMethodBody(dtor->body, ctx);
                    }
                }
            }
        }
    }
}

}  // namespace polaron
