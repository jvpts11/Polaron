// THE REGION BINDER: which region a value lives in, and whether a reference may point at it.
//
// Its name is both words. What it binds is supposed to be REGIONS, and until now that was the part
// that was never built: the analysis tracked one lifetime boundary -- this frame -- as a set of local
// NAMES, so it could see a local escaping a local and nothing else. Measured against a real program
// (a SQL engine, 2026-08-16), a result set handing back rows its table then freed compiled clean and
// printed another statement's data.
//
// The model is `pico/docs/polaron-safety-model.md` §1-§14, and its first sentence is the design:
// regions are inferred from structure the language already has, and the region tree IS the
// composition tree. Four kinds, ordered:
//
//     Root  ⊒  Object ◇o  ⊒  Region R  ⊒  Activation ◇m
//
// with §3 generating every error: a referring binding may only point at a region that outlives its
// own.
#include <functional>
#include <string>
#include <unordered_map>
#include <unordered_set>

#include "parser/ast.h"
#include "semantic/analyzer.h"
#include "semantic/semutil.h"

namespace polaron {

using namespace semutil;   // NOLINT(google-build-using-namespace): as in analyzer.cpp

// ---- The order -------------------------------------------------------------------------------

// REFUSING WHAT CANNOT BE PLACED IS THE DEFAULT, and getting here took closing every shape rather
// than arguing about the switch. The measured cost of the flip went 35 sites, then 23, then 18, then
// 10, then 0 -- and 0 is not "we stopped counting", it is 799 sample programs, a 27-file SQL engine
// and a 20,000-line standard library reporting the same number in both modes. Every step that
// removed sites taught the analysis to place another real shape; none of them relaxed a rule.
//
// So the number was never a count of dangerous code. It was a count of this analysis's own silence,
// and a checker that says "allowed" where it means "I could not tell" cannot state a guarantee at
// all. Now it can: a value the analysis cannot place is refused, which is what separates a checker
// that FINDS from one that GUARANTEES.
//
// `--permissive-regions` keeps the old direction for a program that has not been read against this
// yet. It is a migration aid and it takes the guarantee away while it is on.
bool SemanticAnalyzer::strictRegions_ = true;

bool SemanticAnalyzer::outlivesOrEqual(const Lifetime& a, const Lifetime& b) const {
    if (a.kind == RegionKind::Unknown || b.kind == RegionKind::Unknown) {
        return !strictRegions_;
    }
    // THE ORDER THE MODEL STATES (§1.3), as ranks:
    //
    //     Root (3)  ⊒  Object ◇o (2)  ⊒  Region R (1)  ⊒  Activation ◇m (0)
    //
    // An object outlives a scope region because a region's lifetime is its lexical scope and an
    // object's is its owner's -- which is what makes the whole thing a scope-nesting check rather
    // than lifetime inference, and why it needs no borrow checker.
    auto rank = [](RegionKind k) {
        switch (k) {
            case RegionKind::Root:       return 3;
            case RegionKind::Object:     return 2;
            case RegionKind::Region:     return 1;
            default:                     return 0;   // Activation
        }
    };
    // TWO DIFFERENT OBJECTS ARE INCOMPARABLE, and that is the answer rather than a gap. Nothing in
    // the program says which of them dies first, so a reference from one into the other cannot be
    // proven safe -- which is exactly the bug a database gets wrong. The same object is itself.
    if (a.kind == RegionKind::Object && b.kind == RegionKind::Object) {
        return a.owner == b.owner;
    }
    // TWO EXPLICIT REGIONS, ORDERED BY WHEN THEY WERE BORN (§10).
    //
    // Regions are released last-in-first-out: at scope exit, in reverse declaration order. And a
    // region declared inside a block is necessarily born after the region enclosing that block. So
    // "born earlier" is exactly "dies later", and one number per region orders an arbitrarily deep
    // nest without modelling the nest -- which is what makes this a scope-nesting check rather than
    // lifetime inference, and why it needs no borrow checker.
    //
    // Identity first, because a region outlives itself and the birth numbers are equal.
    if (a.kind == RegionKind::Region && b.kind == RegionKind::Region) {
        if (a.owner == b.owner) {
            return true;
        }
        auto ba = regionBirth_.find(a.owner);
        auto bb = regionBirth_.find(b.owner);
        if (ba == regionBirth_.end() || bb == regionBirth_.end()) {
            // One of them is a field region or came from somewhere this frame cannot see. Unordered,
            // and the default's direction decides -- the same open question as everywhere else.
            return !strictRegions_;
        }
        return ba->second < bb->second;
    }
    return rank(a.kind) >= rank(b.kind);
}

// ---- Ownership, read off the destructor -------------------------------------------------------

// Every field name this block frees, however it is spelled: `delete this.f`, `delete this.f.get(i)`,
// a loop over `this.f` that deletes its elements. All three mean the same thing about the field --
// the class is responsible for what is in it -- and a check that only understood the first would
// call every collection-holding class a borrower.
void SemanticAnalyzer::collectFreed(const ast::Block& body,
                                    std::unordered_set<std::string>& freed) const {
    // The root field name of an expression like `this.rows.get(i)` -> "rows". Anything that does not
    // start at `this` is not about this object's fields.
    auto rootField = [](const ast::Expr* e) -> std::string {
        // Through a cast first: `delete cast<Predicate*>(this.filter)` is how a nullable field is
        // freed, and it is the ordinary spelling -- not seeing through it reported four setters in a
        // twenty-file program as borrows when their destructor plainly frees them.
        while (const auto* cast = dynamic_cast<const ast::CastExpr*>(e)) {
            e = cast->operand.get();
        }
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(e);
        while (mem != nullptr) {
            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                id != nullptr && id->name == "this") {
                return mem->member;
            }
            if (const auto* call = dynamic_cast<const ast::CallExpr*>(mem->object.get())) {
                mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                continue;
            }
            mem = dynamic_cast<const ast::MemberExpr*>(mem->object.get());
        }
        return "";
    };
    // A local standing in for a field, so that `Json* here = cast<Json*>(cur); ... delete here;`
    // still says the field is owned. Walking a chain through a local is how a linked structure's
    // destructor is written -- the node has to be read before it is freed -- and a check that only
    // understood `delete this.f` called every such class a borrower of its own children.
    std::unordered_map<std::string, std::string> standsFor;
    std::function<void(const ast::Stmt*)> walkStmt = [&](const ast::Stmt* st) {
        if (st == nullptr) {
            return;
        }
        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) {
            if (vd->init != nullptr) {
                const ast::Expr* v = vd->init.get();
                while (const auto* c = dynamic_cast<const ast::CastExpr*>(v)) {
                    v = c->operand.get();
                }
                if (const std::string f = rootField(v); !f.empty()) {
                    standsFor[vd->name] = f;
                } else if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(v)) {
                    if (auto it = standsFor.find(id->name); it != standsFor.end()) {
                        standsFor[vd->name] = it->second;   // an alias of an alias
                    }
                }
            }
            return;
        }
        if (const auto* as = dynamic_cast<const ast::AssignStmt*>(st)) {
            if (const auto* tid = dynamic_cast<const ast::IdentifierExpr*>(as->target.get())) {
                const ast::Expr* v = as->value.get();
                while (const auto* c = dynamic_cast<const ast::CastExpr*>(v)) {
                    v = c->operand.get();
                }
                if (const std::string f = rootField(v); !f.empty()) {
                    standsFor[tid->name] = f;   // `cur = this.firstChild;` walks the same chain
                }
            }
            return;
        }
        if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(st)) {
            const ast::Expr* target = del->target.get();
            std::string name = rootField(target);
            if (!name.empty()) {
                freed.insert(name);
            }
            // ...or through the local that stands in for it.
            {
                const ast::Expr* bare = target;
                while (const auto* c = dynamic_cast<const ast::CastExpr*>(bare)) {
                    bare = c->operand.get();
                }
                if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(bare)) {
                    if (auto it = standsFor.find(id->name); it != standsFor.end()) {
                        freed.insert(it->second);
                    }
                }
            }
            // `delete this.rows.get(i)` reaches the field through a call, so the receiver of that
            // call is where the name is.
            if (const auto* call = dynamic_cast<const ast::CallExpr*>(target)) {
                std::string viaCall = rootField(call->callee.get());
                if (!viaCall.empty()) {
                    freed.insert(viaCall);
                }
            }
            return;
        }
        if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(st)) {
            for (const auto& s : ifs->thenBlock.statements) {
                walkStmt(s.get());
            }
            if (ifs->elseBlock != nullptr) {
                for (const auto& s : ifs->elseBlock->statements) {
                    walkStmt(s.get());
                }
            }
            return;
        }
        if (const auto* wh = dynamic_cast<const ast::WhileStmt*>(st)) {
            for (const auto& s : wh->body.statements) {
                walkStmt(s.get());
            }
            return;
        }
        if (const auto* fo = dynamic_cast<const ast::ForStmt*>(st)) {
            for (const auto& s : fo->body.statements) {
                walkStmt(s.get());
            }
            return;
        }
        if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) {
            for (const auto& s : fe->body.statements) {
                walkStmt(s.get());
            }
            return;
        }
        if (const auto* def = dynamic_cast<const ast::DeferStmt*>(st)) {
            for (const auto& s : def->body.statements) {
                walkStmt(s.get());
            }
            return;
        }
    };
    for (const auto& st : body.statements) {
        walkStmt(st.get());
    }
}

// A class OWNS the fields its destructor frees, and borrows the rest.
//
// No annotation, and none wanted: the author already had to write the destructor, and what it frees
// is the same sentence an `owned` keyword would have made them write twice. `Database` frees nothing
// and its store is a persistent (root); `Table` frees its rows and columns (owns them); a result set
// that hands back views frees its list and not its rows, and is therefore a borrower -- which is
// precisely the shape that has to be refused.
//
// A DESTRUCTOR IT CALLS COUNTS TOO: `~Table` calling `this.clear()` frees the rows there, and a
// check that only read the destructor's own statements would report the class as owning nothing.
void SemanticAnalyzer::computeOwnership(const ast::Program& program) {
    // ROUND AND ROUND UNTIL NOTHING NEW IS FRESH. Freshness is transitive -- a factory that hands
    // back another factory's result hands back fresh storage too -- and the standard library is
    // written in exactly that chain. Monotone (names only get added), so it converges; bounded
    // anyway, because a program has finitely many methods.
    for (int round = 0; round < 8; ++round) {
        freshGrew_ = false;
        computeOwnershipRound(program);
        if (!freshGrew_) {
            break;
        }
    }
}

// WHICH METHODS FREE WHAT THEY ARE HANDED, and through them, which fields a class really owns.
//
// A tree does not free itself in its destructor. `~TreeMap` calls `freeSubtree(this.root)`, and that
// helper deletes its own parameter and recurses down `n.left` and `n.right` -- so the destructor's
// own statements free nothing, and reading only those said `TreeMap` owns nothing and `TreeNode`
// owns nothing, which made every rotation in the AVL code a store of an unplaceable reference. The
// ownership was written down plainly; it was just written one call away.
//
// Two facts come out of the same scan:
//   * `M(this.f)` where M deletes that parameter  ->  the class owns `f`.
//   * inside such an M, `M2(p.g)` where M2 also deletes  ->  `p`'s class owns `g`.
// The second is what makes a node own its children, and it is why one pass over a helper answers for
// a whole recursive structure. Both feed the fixpoint: a summary that grows starts another round.
void SemanticAnalyzer::computeDeleteSummaries(const ast::Program& program) {
    // `M(this.F)` tells us what M's parameter really is: whatever type field F has on the class doing
    // the calling -- and that one is instantiated, so it is the name the rest of the compiler uses.
    auto noteParamClass = [this](const std::string& key, int slot, const std::string& holder,
                                 const std::string& field) {
        const FieldInfo* fi = findField(holder, field);
        if (fi == nullptr) {
            return;
        }
        const std::string cls = baseType(fi->type);
        if (!cls.empty() && paramClassOf_[key].emplace(slot, cls).second) {
            freshGrew_ = true;
        }
    };
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                const std::string self = baseType(cls.name);
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr) {
                        continue;
                    }
                    // Which parameter a name refers to, seeing through the locals that stand in for
                    // one -- a walk reads the node into a local before freeing it, always.
                    std::unordered_map<std::string, int> slotOf;
                    for (std::size_t i = 0; i < m->params.size(); ++i) {
                        slotOf[m->params[i].name] = static_cast<int>(i);
                    }
                    auto bare = [](const ast::Expr* e) {
                        while (const auto* c = dynamic_cast<const ast::CastExpr*>(e)) {
                            e = c->operand.get();
                        }
                        return e;
                    };
                    auto slotFor = [&](const ast::Expr* e) -> int {
                        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(bare(e))) {
                            auto it = slotOf.find(id->name);
                            return it == slotOf.end() ? -1 : it->second;
                        }
                        return -1;
                    };
                    const std::string key = self + "." + m->name;
                    std::function<void(const ast::Stmt*)> walk = [&](const ast::Stmt* st) {
                        if (st == nullptr) {
                            return;
                        }
                        if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st)) {
                            if (vd->init != nullptr) {
                                if (const int s = slotFor(vd->init.get()); s >= 0) {
                                    slotOf[vd->name] = s;
                                }
                            }
                            return;
                        }
                        if (const auto* del = dynamic_cast<const ast::DeleteStmt*>(st)) {
                            if (const int s = slotFor(del->target.get()); s >= 0) {
                                if (deletesParam_[key].insert(s).second) {
                                    freshGrew_ = true;
                                }
                            }
                            return;
                        }
                        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(st)) {
                            const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get());
                            if (call == nullptr) {
                                return;
                            }
                            const auto* callee =
                                dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                            if (callee == nullptr) {
                                return;
                            }
                            // Only a call on `this` or a static one on this class: a helper that
                            // frees is a private detail of the class that owns the structure.
                            const auto* recv =
                                dynamic_cast<const ast::IdentifierExpr*>(callee->object.get());
                            if (recv == nullptr || (recv->name != "this" && recv->name != self)) {
                                return;
                            }
                            auto sit = deletesParam_.find(self + "." + callee->member);
                            if (sit == deletesParam_.end()) {
                                return;
                            }
                            for (int k : sit->second) {
                                if (k >= static_cast<int>(call->args.size())) {
                                    continue;
                                }
                                const ast::Expr* arg = bare(call->args[k].get());
                                // Passing our own parameter on: we free it too.
                                if (const int s = slotFor(arg); s >= 0) {
                                    if (deletesParam_[key].insert(s).second) {
                                        freshGrew_ = true;
                                    }
                                    continue;
                                }
                                const auto* mem = dynamic_cast<const ast::MemberExpr*>(arg);
                                if (mem == nullptr) {
                                    continue;
                                }
                                const auto* base =
                                    dynamic_cast<const ast::IdentifierExpr*>(bare(mem->object.get()));
                                if (base == nullptr) {
                                    continue;
                                }
                                if (base->name == "this") {
                                    if (ownedFields_[self].insert(mem->member).second) {
                                        freshGrew_ = true;   // `M(this.root)` and M frees it
                                    }
                                    noteParamClass(self + "." + callee->member, k, self,
                                                   mem->member);
                                    continue;
                                }
                                // `M2(p.g)` inside a method that frees `p`: `p`'s class owns `g`.
                                auto pit = slotOf.find(base->name);
                                if (pit == slotOf.end() ||
                                    deletesParam_[key].count(pit->second) == 0 ||
                                    pit->second >= static_cast<int>(m->params.size())) {
                                    continue;
                                }
                                // THE NAME AS THE PROGRAM WILL ASK FOR IT LATER. A monomorphized
                                // helper still carries its template's parameter type -- the
                                // instantiated `TreeSet$int.freeSubtree` says `TreeSetNode`, not
                                // `TreeSetNode$int` -- so attributing the field to the declared name
                                // filed it under a class no call site ever looks up, and the whole
                                // AVL tree stayed unplaceable while the analysis believed it had
                                // solved it. The field the helper is CALLED with carries the real
                                // name, because it belongs to an instantiated class.
                                std::string nodeClass;
                                auto pcit = paramClassOf_.find(key);
                                if (pcit != paramClassOf_.end()) {
                                    auto sit2 = pcit->second.find(pit->second);
                                    if (sit2 != pcit->second.end()) {
                                        nodeClass = sit2->second;
                                    }
                                }
                                if (nodeClass.empty()) {
                                    nodeClass = baseType(m->params[pit->second].type.name);
                                }
                                if (!nodeClass.empty() &&
                                    ownedFields_[nodeClass].insert(mem->member).second) {
                                    freshGrew_ = true;
                                }
                            }
                            return;
                        }
                        if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(st)) {
                            for (const auto& s : ifs->thenBlock.statements) { walk(s.get()); }
                            if (ifs->elseBlock != nullptr) {
                                for (const auto& s : ifs->elseBlock->statements) { walk(s.get()); }
                            }
                            return;
                        }
                        if (const auto* wh = dynamic_cast<const ast::WhileStmt*>(st)) {
                            for (const auto& s : wh->body.statements) { walk(s.get()); }
                            return;
                        }
                        if (const auto* fo = dynamic_cast<const ast::ForStmt*>(st)) {
                            for (const auto& s : fo->body.statements) { walk(s.get()); }
                            return;
                        }
                        if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st)) {
                            for (const auto& s : fe->body.statements) { walk(s.get()); }
                            return;
                        }
                        if (const auto* df = dynamic_cast<const ast::DeferStmt*>(st)) {
                            for (const auto& s : df->body.statements) { walk(s.get()); }
                        }
                    };
                    for (const auto& st : m->body.statements) {
                        walk(st.get());
                    }
                }
                // The destructor is the other caller of those helpers, and it is where a class most
                // often says what it owns: `~TreeMap` is two lines, both of them a call.
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* dtor = dynamic_cast<const ast::DestructorDecl*>(member.get());
                    if (dtor == nullptr) {
                        continue;
                    }
                    std::function<void(const ast::Stmt*)> walk = [&](const ast::Stmt* st) {
                        if (const auto* es = dynamic_cast<const ast::ExprStmt*>(st)) {
                            const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get());
                            if (call == nullptr) { return; }
                            const auto* callee =
                                dynamic_cast<const ast::MemberExpr*>(call->callee.get());
                            if (callee == nullptr) { return; }
                            auto sit = deletesParam_.find(self + "." + callee->member);
                            if (sit == deletesParam_.end()) { return; }
                            for (int k : sit->second) {
                                if (k >= static_cast<int>(call->args.size())) { continue; }
                                const ast::Expr* arg = call->args[k].get();
                                while (const auto* c = dynamic_cast<const ast::CastExpr*>(arg)) {
                                    arg = c->operand.get();
                                }
                                if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(arg)) {
                                    if (const auto* base = dynamic_cast<const ast::IdentifierExpr*>(
                                            mem->object.get());
                                        base != nullptr && base->name == "this") {
                                        if (ownedFields_[self].insert(mem->member).second) {
                                            freshGrew_ = true;
                                        }
                                        noteParamClass(self + "." + callee->member, k, self,
                                                       mem->member);
                                    }
                                }
                            }
                        }
                    };
                    for (const auto& st : dtor->body.statements) {
                        walk(st.get());
                    }
                }
            }
        }
    }
}

void SemanticAnalyzer::computeOwnershipRound(const ast::Program& program) {
    computeDeleteSummaries(program);
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& cls : ns.classes) {
                std::unordered_set<std::string> freed;
                for (const ast::MemberPtr& member : cls.members) {
                    if (const auto* dtor = dynamic_cast<const ast::DestructorDecl*>(member.get())) {
                        collectFreed(dtor->body, freed);
                    }
                }
                // ...and one level of helper, which is how a destructor that shares its cleanup with
                // a `clear()` is written. Deeper than one level is not chased: a class whose
                // ownership is three calls away is a class whose ownership nobody can read either.
                if (!freed.empty() || true) {
                    for (const ast::MemberPtr& member : cls.members) {
                        const auto* dtor = dynamic_cast<const ast::DestructorDecl*>(member.get());
                        if (dtor == nullptr) {
                            continue;
                        }
                        std::unordered_set<std::string> calledNames;
                        std::function<void(const ast::Stmt*)> findCalls = [&](const ast::Stmt* st) {
                            if (const auto* es = dynamic_cast<const ast::ExprStmt*>(st)) {
                                if (const auto* call = dynamic_cast<const ast::CallExpr*>(es->expr.get())) {
                                    if (const auto* mem =
                                            dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
                                        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(
                                                mem->object.get());
                                            id != nullptr && id->name == "this") {
                                            calledNames.insert(mem->member);
                                        }
                                    }
                                }
                            }
                        };
                        for (const auto& st : dtor->body.statements) {
                            findCalls(st.get());
                        }
                        for (const ast::MemberPtr& other : cls.members) {
                            const auto* m = dynamic_cast<const ast::MethodDecl*>(other.get());
                            if (m != nullptr && calledNames.count(m->name) > 0) {
                                collectFreed(m->body, freed);
                            }
                        }
                    }
                }
                // MERGED, not assigned. What the destructor frees directly and what it frees through
                // a helper are two halves of one answer, and overwriting threw the other half away.
                for (const std::string& f : freed) {
                    if (ownedFields_[baseType(cls.name)].insert(f).second) {
                        freshGrew_ = true;
                    }
                }
                // WHICH METHODS HAND BACK FRESH STORAGE, which is the commonest thing a call
                // result can be and was an Unknown until now: `node.addChild(this.element())`
                // stores something `element` just allocated, and that is a handover, not a borrow.
                //
                // Every `return` in the method must be a fresh heap allocation -- directly, or a
                // local bound to one. A method that sometimes hands back a field and sometimes a new
                // object is not answered here, and stays Unknown, which is the honest outcome.
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->body.statements.empty()) {
                        continue;
                    }
                    std::unordered_set<std::string> freshLocals;
                    bool sawReturn = false;
                    bool allFresh = true;
                    std::function<void(const ast::Block&)> look = [&](const ast::Block& body) {
                        for (const auto& st : body.statements) {
                            if (const auto* vd = dynamic_cast<const ast::VarDeclStmt*>(st.get())) {
                                if (const auto* nw =
                                        dynamic_cast<const ast::NewExpr*>(vd->init.get());
                                    nw != nullptr && nw->location == "heap" && nw->region.empty()) {
                                    freshLocals.insert(vd->name);
                                } else if (const auto* ic =
                                               dynamic_cast<const ast::CallExpr*>(vd->init.get())) {
                                    // ...and a local bound to a FACTORY's result is fresh too:
                                    // `mutable Json map = Json.object();` then `return map;` is how
                                    // the standard library's builders are written, and reading only
                                    // `new` here broke the chain three callers up.
                                    const auto* im =
                                        dynamic_cast<const ast::MemberExpr*>(ic->callee.get());
                                    if (im != nullptr) {
                                        if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(
                                                im->object.get())) {
                                            const std::string owner =
                                                oid->name == "this" ? baseType(cls.name)
                                                                    : baseType(oid->name);
                                            if (returnsFresh_.count(owner + "." + im->member) > 0) {
                                                freshLocals.insert(vd->name);
                                            }
                                        }
                                    }
                                }
                                continue;
                            }
                            if (const auto* ret = dynamic_cast<const ast::ReturnStmt*>(st.get())) {
                                if (ret->value == nullptr) {
                                    continue;
                                }
                                sawReturn = true;
                                const ast::Expr* v = ret->value.get();
                                if (const auto* nw = dynamic_cast<const ast::NewExpr*>(v)) {
                                    if (nw->location != "heap" || !nw->region.empty()) {
                                        allFresh = false;
                                    }
                                } else if (const auto* id =
                                               dynamic_cast<const ast::IdentifierExpr*>(v)) {
                                    if (freshLocals.count(id->name) == 0) {
                                        allFresh = false;
                                    }
                                } else if (const auto* rc = dynamic_cast<const ast::CallExpr*>(v)) {
                                    // FRESHNESS IS TRANSITIVE, and the standard library is written in
                                    // exactly that chain: `Toml.value` hands back `Json.ofStr(...)`,
                                    // which hands back the `new`. One layer of factory is the rule,
                                    // not the exception, so this is computed to a fixpoint below.
                                    const auto* rm =
                                        dynamic_cast<const ast::MemberExpr*>(rc->callee.get());
                                    std::string owner;
                                    if (rm != nullptr) {
                                        if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(
                                                rm->object.get())) {
                                            owner = oid->name == "this" ? baseType(cls.name)
                                                                        : baseType(oid->name);
                                        }
                                    }
                                    if (owner.empty() ||
                                        returnsFresh_.count(owner + "." + rm->member) == 0) {
                                        allFresh = false;
                                    }
                                } else {
                                    allFresh = false;
                                }
                                continue;
                            }
                            // EVERY BLOCK, not just the branches. A factory that returns from inside
                            // a loop is ordinary -- `Toml.number` parses digits in a `while` and
                            // returns out of it -- and a scan that only descended into `if` called
                            // such a method unplaceable, which then made every caller unplaceable
                            // too. One missed statement kind travels a long way up a chain.
                            if (const auto* ifs = dynamic_cast<const ast::IfStmt*>(st.get())) {
                                look(ifs->thenBlock);
                                if (ifs->elseBlock != nullptr) {
                                    look(*ifs->elseBlock);
                                }
                            } else if (const auto* wh = dynamic_cast<const ast::WhileStmt*>(st.get())) {
                                look(wh->body);
                            } else if (const auto* fo = dynamic_cast<const ast::ForStmt*>(st.get())) {
                                look(fo->body);
                            } else if (const auto* fe =
                                           dynamic_cast<const ast::ForeachStmt*>(st.get())) {
                                look(fe->body);
                            } else if (const auto* dw = dynamic_cast<const ast::DoWhileStmt*>(st.get())) {
                                look(dw->body);
                            } else if (const auto* tr = dynamic_cast<const ast::TryStmt*>(st.get())) {
                                look(tr->body);
                                for (const auto& c : tr->catches) {
                                    look(c.body);
                                }
                                if (tr->finallyBlock != nullptr) {
                                    look(*tr->finallyBlock);
                                }
                            }
                        }
                    };
                    look(m->body);
                    if (sawReturn && allFresh &&
                        returnsFresh_.insert(baseType(cls.name) + "." + m->name).second) {
                        freshGrew_ = true;   // the fixpoint has to go round again
                    }
                }
                // ...and while the class is in hand, the one-line accessors. `at(i) { return
                // this.rows.get(i); }` hands back a row the table owns, and without knowing that,
                // the commonest way one object reaches into another is invisible to the analysis.
                for (const ast::MemberPtr& member : cls.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m == nullptr || m->body.statements.size() != 1) {
                        continue;
                    }
                    const auto* ret =
                        dynamic_cast<const ast::ReturnStmt*>(m->body.statements[0].get());
                    if (ret == nullptr || ret->value == nullptr) {
                        continue;
                    }
                    // `return this.f;` or `return this.f.get(i);` -- both hand back what is in `f`.
                    const ast::Expr* value = ret->value.get();
                    if (const auto* call = dynamic_cast<const ast::CallExpr*>(value)) {
                        value = call->callee.get();
                    }
                    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(value)) {
                        const ast::Expr* base = mem->object.get();
                        if (const auto* inner = dynamic_cast<const ast::MemberExpr*>(base)) {
                            base = inner->object.get();
                            if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(base);
                                id != nullptr && id->name == "this") {
                                accessorField_[baseType(cls.name) + "." + m->name] = inner->member;
                            }
                        } else if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(base);
                                   id != nullptr && id->name == "this") {
                            accessorField_[baseType(cls.name) + "." + m->name] = mem->member;
                        }
                    }
                }
            }
        }
    }
}

bool SemanticAnalyzer::ownsField(const std::string& className, const std::string& field) const {
    auto it = ownedFields_.find(baseType(className));
    if (it == ownedFields_.end()) {
        return false;
    }
    return it->second.count(field) > 0;
}

// ONE OWNER IS ENOUGH. An escape summary records every field an argument lands in, comma-joined,
// because an append writes it into the chain the object owns AND into the tail pointer that makes
// the next append cheap. If any of them is owned, the object took the value and the call is a
// handover, whatever the other fields are.
bool SemanticAnalyzer::anyFieldOwns(const std::string& className,
                                    const std::string& fieldList) const {
    std::string::size_type at = 0;
    while (at <= fieldList.size()) {
        const std::string::size_type comma = fieldList.find(',', at);
        const std::string one = fieldList.substr(
            at, comma == std::string::npos ? std::string::npos : comma - at);
        if (!one.empty() && ownsField(className, one)) {
            return true;
        }
        if (comma == std::string::npos) {
            break;
        }
        at = comma + 1;
    }
    return false;
}

// ---- The lifetime of a VALUE -------------------------------------------------------------------

// The structural change the model needed, in one method.
//
// Lifetime used to be a property of a NAME -- a set of locals tagged at their declaration -- so an
// escape had to be spelled as a bare identifier on both sides to be seen. A temporary, an array
// element, a field read, a call result: all invisible, and real code is made of those. Here it is a
// property of the VALUE, worked out by the same walk that works out its type, so `h.kept =
// new Node(2)` and `out.keep(table.at(i))` are the same question as `h.kept = n`.
// A REGION HELD AS A FIELD LIVES AS LONG AS ITS OBJECT, and one held as a local lives as long as its
// scope. Those are different lifetimes wearing one keyword, and reading them as one refused a
// perfectly ordinary shape: an intrusive list whose nodes live in `region this.nodes` and whose
// `head` and `tail` point into it. Both die with the object, together, always.
SemanticAnalyzer::Lifetime SemanticAnalyzer::regionLifetime(const std::string& name) const {
    if (name.rfind("this.", 0) == 0) {
        return Lifetime{RegionKind::Object, "this"};
    }
    return Lifetime{RegionKind::Region, name};
}

SemanticAnalyzer::Lifetime SemanticAnalyzer::lifetimeOf(const ast::Expr& expr) {
    // Muted for the duration: the receiver types this needs are asked for with `typeOf`, which
    // reports as it goes, and a question must not produce a complaint.
    Quiet hush(*this);
    // `null` POINTS AT NOTHING, so it fits anywhere and always has. Not an Unknown: Unknown means
    // "this analysis cannot say", and about null it can say everything. Left out, the strict mode
    // refused `this.kept = null;` in a constructor -- which is most constructors.
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) {
        return Lifetime{RegionKind::Root, ""};
    }
    // A TERNARY IS AS SHORT-LIVED AS ITS SHORTER ARM. The value is one of the two and nothing here
    // says which, so the only sound answer is the one that would be refused -- the join, taken
    // downward. Without it, `h.kept = pick ? a : b` was an Unknown and passed.
    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        const Lifetime a = lifetimeOf(*tern->thenExpr);
        const Lifetime b = lifetimeOf(*tern->elseExpr);
        return outlivesOrEqual(a, b) ? b : a;
    }
    // THE ADDRESS OF A THING LIVES WHERE THE THING LIVES, which is the one question `&x` asks and
    // the answer the analysis was not giving: it read `a.next = &b` as a reference to somewhere it
    // could not place, when `b` is a local three lines up and its lifetime is right there. Taking an
    // address changes what you hold, not how long what you point at lasts.
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        if (un->op == "&" || un->op == "*") {
            return lifetimeOf(*un->operand);
        }
    }
    // `new T()` -- the allocation says where it lives, which is the one case that needs no inference.
    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
        if (!nw->region.empty()) {
            return regionLifetime(nw->region);
        }
        if (nw->location == "heap") {
            // A FRESH HEAP ALLOCATION HAS NO REGION YET, and giving it one would be the wrong
            // answer in the ordinary direction: `owner.field = new T() on heap` is how a class takes
            // ownership of something, and it must not be an error. It outlives everything until
            // somebody takes it, so it goes in anywhere -- and what happens after is the target's
            // business, which is where the destructor is read.
            return Lifetime{RegionKind::Root, ""};
        }
        // A `region class` PLACES ITS OWN INSTANCES, and not in this frame: `new Node(k, v)` inside
        // one is an allocation in the class's region, which is why the declaration exists. Reading
        // the missing `on heap` as "stack" refused a binary tree linking its own children -- the
        // shape the feature was added for.
        if (const ClassInfo* ci = lookupClass(nw->className); ci != nullptr && ci->isRegionClass) {
            return Lifetime{RegionKind::Object, "this"};
        }
        return Lifetime{RegionKind::Activation, ""};   // `on stack`, the default for an object
    }
    // A bare name.
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        if (id->name == "this") {
            return Lifetime{RegionKind::Object, "this"};
        }
        if (auto it = regionOf_.find(id->name); it != regionOf_.end()) {
            return regionLifetime(it->second);
        }
        if (activationOwned_.count(id->name) > 0) {
            return Lifetime{RegionKind::Activation, ""};
        }
        if (const LocalVar* local = lookupLocal(id->name); local != nullptr) {
            // A PARAMETER, OR A LOCAL HOLDING A HEAP OBJECT. Neither dies with this frame -- the
            // caller gave us the first and the second outlives the binding that names it -- so both
            // are objects, and WHICH object is the name itself. Calling this Unknown was the first
            // version's mistake: Unknown is permissive, so the commonest possible target (a
            // parameter's field) passed every check and the rule fired on nothing at all.
            return Lifetime{RegionKind::Object, id->name};
        }
        // Not a local at all: a static or a class name. Statics are the root region.
        return Lifetime{RegionKind::Root, ""};
    }
    // `recv.field` -- THE CASE THE WHOLE THING TURNS ON. If the receiver's class OWNS that field,
    // the value lives in the receiver's region; if it borrows it, the value lives wherever the real
    // owner keeps it, which this expression does not say.
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string recvType = baseType(typeOf(*mem->object));
        if (!recvType.empty() && ownsField(recvType, mem->member)) {
            return Lifetime{RegionKind::Object, describePath(*mem->object)};
        }
        // A BORROWED FIELD GETS THE SAME ANSWER, and it is not a shrug -- it is the induction this
        // whole analysis runs on. Every store into that field was itself checked against this rule,
        // so whatever is in there already outlives the object holding it. The holder's lifetime is
        // therefore a true LOWER BOUND on the value's, and a lower bound is exactly what a source
        // position may be understated to: it can refuse a program that was fine, never accept one
        // that was not.
        //
        // Calling it Unknown instead cost the guarantee outright. `node.next = this.head` is the
        // second line of every linked list ever written, and under a strict default an Unknown is a
        // refusal -- so the standard library's own list, stack and queue stopped compiling, on a
        // value the analysis could have named.
        const std::string path = describePath(*mem->object);
        if (path.empty()) {
            return Lifetime{RegionKind::Unknown, ""};
        }
        return Lifetime{RegionKind::Object, path};
    }
    // A call: its result belongs to the receiver when the callee hands back something the receiver
    // owns -- `table.at(i)` is a row the table owns -- and that is read from the RECEIVER, because a
    // method that returns a field returns that field's region.
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            // A STATIC CALL NAMES ITS CLASS RATHER THAN AN OBJECT, so `typeOf` on the receiver has no
            // type to give: `Toml.value(x)` reads `Toml` as an expression and answers nothing. Every
            // factory in the standard library is spelled that way, which is why most of what was
            // left unplaceable was a call whose class was sitting right there in the source.
            std::string recvType;
            if (const auto* rid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                rid != nullptr && lookupLocal(rid->name) == nullptr &&
                lookupClass(rid->name) != nullptr) {
                recvType = baseType(rid->name);
            } else {
                recvType = baseType(typeOf(*mem->object));
            }
            const std::string returned = returnedFieldOf(recvType, mem->member);
            if (!returned.empty() && ownsField(recvType, returned)) {
                return Lifetime{RegionKind::Object, describePath(*mem->object)};
            }
            // A method that hands back FRESH storage hands back something nobody owns yet, and
            // whoever takes it becomes its owner -- so it fits anywhere, exactly like a `new` at the
            // call site. Thirteen of the standard library's remaining unplaceable values were this.
            if (returnsFresh_.count(recvType + "." + mem->member) > 0) {
                return Lifetime{RegionKind::Root, ""};
            }
        }
        return Lifetime{RegionKind::Unknown, ""};
    }
    // An array element has its array's lifetime, which is the array expression's.
    if (const auto* idx = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        return lifetimeOf(*idx->array);
    }
    if (const auto* cast = dynamic_cast<const ast::CastExpr*>(&expr)) {
        // A NUMBER CAST TO A POINTER IS A FIXED ADDRESS, and a fixed address outlives everything --
        // the UART at 0x09000000 was there before the program started and will be there after. That
        // is the root region by definition, and it is the whole of how a freestanding program talks
        // to hardware, so reading it as unplaceable stopped the aarch64 kernel from compiling on a
        // line whose lifetime is the least uncertain in the language.
        if (isRefType(cast->targetType) && !isRefType(typeOf(*cast->operand))) {
            return Lifetime{RegionKind::Root, ""};
        }
        return lifetimeOf(*cast->operand);
    }
    return Lifetime{RegionKind::Unknown, ""};
}

// A stable name for the object an expression denotes, so two references to the same owner compare
// equal. Not a canonical form -- `this`, `a.b`, `p` -- just enough that `table` and `table` match
// and `table` and `other` do not.
std::string SemanticAnalyzer::describePath(const ast::Expr& expr) const {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        return id->name;
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string base = describePath(*mem->object);
        return base.empty() ? mem->member : base + "." + mem->member;
    }
    return "";
}

// Which field a one-line accessor hands back, or "". `at(i) { return this.rows.get(i); }` answers
// "rows", which is what lets a call result carry its receiver's region. Deliberately shallow: an
// accessor is one statement, and a method that needs analysis to say what it returns is a method
// whose result the caller should not be assuming things about either.
std::string SemanticAnalyzer::returnedFieldOf(const std::string& className,
                                              const std::string& method) const {
    auto it = accessorField_.find(baseType(className) + "." + method);
    return it == accessorField_.end() ? std::string() : it->second;
}

// ---- Saying it in a sentence -------------------------------------------------------------------

// A region named the way the reader thinks of it. "the frame" and not "activation ◇m": the model's
// notation is for the model, and a diagnostic is read by somebody who has not opened it.
std::string SemanticAnalyzer::describeRegion(const Lifetime& life) const {
    switch (life.kind) {
        case RegionKind::Root:
            return "static storage";
        case RegionKind::Activation:
            return "this call";
        case RegionKind::Region:
            return "region " + life.owner;
        case RegionKind::Object:
            return life.owner == "this" ? std::string("this object")
                                        : ("what '" + life.owner + "' belongs to");
        default:
            return "somewhere this analysis cannot place";
    }
}

// WHAT TO DO ABOUT IT, which is the half a diagnostic usually leaves out. The advice differs by
// which two regions met, because the fix does: a frame-local escaping wants ownership transferred,
// and one object's value stored in another wants a copy -- the decision a result set makes when it
// chooses to own its rows rather than view them.
std::string SemanticAnalyzer::regionAdvice(const Lifetime& source, const Lifetime& target) const {
    (void)target;
    if (source.kind == RegionKind::Activation) {
        return "Transfer ownership with `move`, or store a copy instead of a reference.";
    }
    if (source.kind == RegionKind::Region) {
        return "A value in a region dies when the region is released. Copy it out, or keep the "
               "reference somewhere that does not outlive the region.";
    }
    if (source.kind == RegionKind::Object) {
        return "Nothing says which of the two objects dies first, so this reference cannot be "
               "proven safe. Store a copy, or have one of them own the value outright.";
    }
    return "Store a copy, or make the owner outlive the place the reference is kept.";
}

}  // namespace polaron
