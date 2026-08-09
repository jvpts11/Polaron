#include "semantic/implicitthis.h"

#include <map>
#include <set>
#include <string>
#include <vector>

namespace ldp3 {
namespace {

// What a class can answer to a bare NAME, including everything it inherits. Methods are absent on
// purpose: a bare `name(...)` already resolves without help, so the only gap was the field.
//
// Instance and static are kept apart because they are reached differently: `this.f` needs a receiver
// and `Class.f` must not have one, and a static body has no `this` to offer.
struct Members {
    std::set<std::string> instanceFields;
    std::set<std::string> staticFields;
};

using ClassIndex = std::map<std::string, const ast::ClassDecl*>;

void gather(const std::string& typeName, const ClassIndex& index, Members& out,
            std::set<std::string>& seen) {
    if (!seen.insert(typeName).second) return;
    auto it = index.find(typeName);
    if (it == index.end()) return;
    const ast::ClassDecl& c = *it->second;
    for (const ast::MemberPtr& m : c.members) {
        if (const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            if (f->isStatic) out.staticFields.insert(f->name);
            else out.instanceFields.insert(f->name);
            continue;
        }
        // A PROPERTY is read without parentheses, so at the use site it is a field and not a call --
        // which is the whole point of the feature, and the reason it belongs in this pass while an
        // ordinary method does not.
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get()); md != nullptr && md->isProperty) {
            if (md->isStatic) out.staticFields.insert(md->name);
            else out.instanceFields.insert(md->name);
        }
    }
    if (!c.superclass.empty()) gather(c.superclass, index, out, seen);
    for (const std::string& i : c.interfaces) gather(i, index, out, seen);
}

ast::ExprPtr thisRef(const SourceLocation& loc) {
    auto id = std::make_unique<ast::IdentifierExpr>();
    id->name = "this";
    id->loc = loc;
    return id;
}

ast::ExprPtr typeRef(const std::string& name, const SourceLocation& loc) {
    auto id = std::make_unique<ast::IdentifierExpr>();
    id->name = name;
    id->loc = loc;
    return id;
}

// The name a bare `itself` stands for on the right of an assignment: the plain variable, or the
// field of a `this.field` target. Anything else yields "" and the pronoun is left alone -- for
// `a[i] = itself + 1` it would have to stand for an element whose index would then be evaluated a
// second time, and a pronoun must not cost an extra evaluation of anything.
std::string itselfTargetName(const ast::Expr* target) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(target)) return id->name;
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(target)) {
        const auto* obj = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
        if (obj != nullptr && obj->name == "this") return mem->member;
    }
    return "";
}

ast::ExprPtr memberOf(ast::ExprPtr object, const std::string& name, const SourceLocation& loc) {
    auto mem = std::make_unique<ast::MemberExpr>();
    mem->object = std::move(object);
    mem->member = name;
    mem->loc = loc;
    return mem;
}

// One method body being walked. Holds the scopes of names that are NOT members: parameters, then a
// set per block, pushed and popped as the walk enters and leaves.
class Rewriter {
public:
    Rewriter(const Members& members, const std::string& className, bool inStatic,
             const std::set<std::string>& typeNames)
        : m_(members), cls_(className), static_(inStatic), types_(typeNames) {}

    void block(ast::Block& b) {
        scopes_.emplace_back();
        for (auto& st : b.statements) stmt(st.get());
        scopes_.pop_back();
    }

    void declare(const std::string& name) {
        if (scopes_.empty()) scopes_.emplace_back();
        scopes_.back().insert(name);
    }

    void openScope() { scopes_.emplace_back(); }
    void closeScope() { scopes_.pop_back(); }

    void stmt(ast::Stmt* st);
    void expr(ast::ExprPtr& slot);

private:
    bool shadowed(const std::string& name) const {
        for (auto it = scopes_.rbegin(); it != scopes_.rend(); ++it)
            if (it->count(name) > 0) return true;
        return false;
    }

    // The one decision. Returns the receiver a bare `name` is missing, or null to leave it alone.
    ast::ExprPtr resolve(const std::string& name, const SourceLocation& loc) const {
        if (name == "this" || name == "super" || name == "itself" || name == "result") return nullptr;
        if (shadowed(name)) return nullptr;               // a local of that name -- `this.` is how
                                                          // the field is reached, and that is the rule
        // A type name stays a type name. `Console.println(...)` must not become `this.Console...`
        // just because some class in the program happens to have a field called Console.
        if (types_.count(name) > 0) return nullptr;
        if (!static_ && m_.instanceFields.count(name) > 0) return thisRef(loc);
        if (m_.staticFields.count(name) > 0) return typeRef(cls_, loc);
        // An instance field named from a static method is an error. Left alone on purpose: the
        // analyser's "undeclared variable" says the true thing here, and inventing a `this` in a body
        // that has none would replace it with a worse message about a receiver nobody wrote.
        return nullptr;
    }

    const Members& m_;
    const std::string& cls_;
    bool static_;
    const std::set<std::string>& types_;
    std::vector<std::set<std::string>> scopes_;

public:
    // `itself` -- the pronoun the keyword reference defines as "the entity being declared". Bare, it
    // is that entity; followed by a '.', it is that entity's TYPE. Both are known here and nowhere
    // later: by the time the analyser sees the initializer, the declaration it belongs to is no
    // longer the thing being walked. Empty when no declaration is open, which leaves `itself` alone
    // for the analyser to reject -- or, inside a lambda body, for the lambda to claim (the walk
    // returns before reaching a lambda, so its self-recursion is untouched by any of this).
    std::string itselfName_;
    std::string itselfType_;

    // Save/restore around a nested walk. A declaration's initializer can hold another declaration
    // (a lambda body, a match arm), and the inner one owns the pronoun while it is open.
    struct Entity {
        Rewriter& r;
        std::string name, type;
        Entity(Rewriter& rw, std::string n, std::string t)
            : r(rw), name(rw.itselfName_), type(rw.itselfType_) {
            r.itselfName_ = std::move(n);
            r.itselfType_ = std::move(t);
        }
        ~Entity() {
            r.itselfName_ = std::move(name);
            r.itselfType_ = std::move(type);
        }
    };
};

void Rewriter::expr(ast::ExprPtr& slot) {
    ast::Expr* e = slot.get();
    if (e == nullptr) return;

    if (auto* x = dynamic_cast<ast::CallExpr*>(e)) {
        // A BARE CALL IS NOT THIS PASS'S BUSINESS. `name(...)` already resolves to the enclosing
        // class's own method -- the analyser does it, and it does it better: from a static body it
        // reports that an instance method needs an object, which a rewrite to `this.name(...)` would
        // turn into a message about a receiver the author never wrote. Only the callee is skipped;
        // the arguments are ordinary expressions.
        if (dynamic_cast<ast::IdentifierExpr*>(x->callee.get()) == nullptr) expr(x->callee);
        for (auto& a : x->args) expr(a);
        return;
    }
    if (auto* x = dynamic_cast<ast::MemberExpr*>(e)) {
        // `itself.member`: the pronoun followed by a '.' names the declared entity's TYPE, so the
        // member is read off the type rather than off a value that does not exist yet. Taken before
        // walking into the object, which is where the bare-pronoun rewrite would otherwise claim it.
        if (auto* obj = dynamic_cast<ast::IdentifierExpr*>(x->object.get());
            obj != nullptr && obj->name == "itself" && !itselfType_.empty()) {
            obj->name = itselfType_;
            return;
        }
        expr(x->object);
        return;
    }
    if (auto* x = dynamic_cast<ast::BinaryExpr*>(e)) { expr(x->lhs); expr(x->rhs); return; }
    if (auto* x = dynamic_cast<ast::TernaryExpr*>(e)) { expr(x->cond); expr(x->thenExpr); expr(x->elseExpr); return; }
    if (auto* x = dynamic_cast<ast::UnaryExpr*>(e)) { expr(x->operand); return; }
    if (auto* x = dynamic_cast<ast::IndexExpr*>(e)) { expr(x->array); expr(x->index); return; }
    if (auto* x = dynamic_cast<ast::MoveExpr*>(e)) { expr(x->operand); return; }
    if (auto* x = dynamic_cast<ast::ExtractExpr*>(e)) { expr(x->target); return; }
    if (auto* x = dynamic_cast<ast::TryExpr*>(e)) { expr(x->operand); return; }
    if (auto* x = dynamic_cast<ast::CastExpr*>(e)) { expr(x->operand); return; }
    if (auto* x = dynamic_cast<ast::NewExpr*>(e)) { for (auto& a : x->args) expr(a); return; }
    if (auto* x = dynamic_cast<ast::NewArrayExpr*>(e)) { expr(x->size); return; }
    if (auto* x = dynamic_cast<ast::RegionInitExpr*>(e)) { expr(x->size); return; }
    if (auto* x = dynamic_cast<ast::InterpStringExpr*>(e)) { for (auto& ex : x->exprs) expr(ex); return; }
    if (auto* x = dynamic_cast<ast::MethodRefExpr*>(e)) { expr(x->object); return; }
    if (auto* x = dynamic_cast<ast::MatchExpr*>(e)) {
        expr(x->subject);
        for (auto& c : x->cases) {
            openScope();
            for (const ast::Param& p : c.bindings) declare(p.name);
            expr(c.result);
            closeScope();
        }
        expr(x->defaultResult);
        return;
    }
    // A LAMBDA BODY IS LEFT ALONE, and that is not an omission.
    //
    // A lambda is lowered to a top-level function with no receiver: `currentThis` is cleared while its
    // body is emitted, so `this` does not exist in there and a field is unreachable with or without
    // the prefix. Rewriting a name into `this.f` inside one would turn today's honest "undeclared
    // variable" into a crash. When lambdas capture their object, this is the line that changes.
    if (dynamic_cast<ast::LambdaExpr*>(e) != nullptr) return;

    if (auto* x = dynamic_cast<ast::IdentifierExpr*>(e)) {
        // Bare `itself` is the entity, not its type. Renamed rather than returned on, so that a field
        // still picks up its receiver from the resolve below: in `this.total = itself + 1` the
        // pronoun means the field, and a field needs its `this.` like any other mention of it.
        if (x->name == "itself" && !itselfName_.empty()) x->name = itselfName_;
        if (ast::ExprPtr repl = resolve(x->name, x->loc))
            slot = memberOf(std::move(repl), x->name, x->loc);
        return;
    }
}

void Rewriter::stmt(ast::Stmt* st) {
    if (st == nullptr) return;
    if (auto* x = dynamic_cast<ast::ExprStmt*>(st)) { expr(x->expr); return; }
    if (auto* x = dynamic_cast<ast::StaticAssertStmt*>(st)) { expr(x->condition); return; }
    if (auto* x = dynamic_cast<ast::LabeledStmt*>(st)) { stmt(x->stmt.get()); return; }
    if (auto* x = dynamic_cast<ast::ThrowStmt*>(st)) { expr(x->value); return; }
    if (auto* x = dynamic_cast<ast::ReturnStmt*>(st)) { expr(x->value); return; }
    if (auto* x = dynamic_cast<ast::DeleteStmt*>(st)) {
        expr(x->target);
        for (auto& mt : x->moreTargets) expr(mt);
        return;
    }
    if (auto* x = dynamic_cast<ast::AssignStmt*>(st)) {
        expr(x->target);
        // `a = itself + b`: what is being assigned is the entity the pronoun names. The target is
        // walked first, so a field has already become `this.field` and reads back as one. No type is
        // available in this pass, so the `itself.` form stays unresolved on an assignment and the
        // analyser reports it -- a declaration is where a written type exists.
        Entity ent(*this, itselfTargetName(x->target.get()), std::string());
        expr(x->value);
        return;
    }
    if (auto* x = dynamic_cast<ast::IncDecStmt*>(st)) { expr(x->target); return; }
    // THE INITIALIZER IS WALKED BEFORE THE NAME EXISTS. `int n = n;` names the field, not the local
    // being declared -- the local is not in scope until its own declaration is complete, which is the
    // rule everywhere else and the only one under which that line means anything at all.
    if (auto* x = dynamic_cast<ast::VarDeclStmt*>(st)) {
        // `itself` in the initializer is THIS declaration: its name, and its written type. With
        // `var` there is no written type -- it is being inferred from this very initializer -- so the
        // type form is left unresolved rather than made circular.
        Entity ent(*this, x->name, x->isVar ? std::string() : x->type.name);
        expr(x->init);
        declare(x->name);
        return;
    }
    if (auto* x = dynamic_cast<ast::TupleDeclStmt*>(st)) {
        expr(x->init);
        for (const ast::TupleBinding& b : x->bindings) declare(b.name);
        return;
    }
    if (auto* x = dynamic_cast<ast::ForeachStmt*>(st)) {
        expr(x->iterable);
        openScope();
        declare(x->varName);
        if (!x->indexName.empty()) declare(x->indexName);
        block(x->body);
        closeScope();
        return;
    }
    if (auto* x = dynamic_cast<ast::SwitchStmt*>(st)) {
        expr(x->subject);
        for (auto& c : x->cases) { expr(c.value); block(c.body); }
        if (x->defaultBody) block(*x->defaultBody);
        return;
    }
    if (auto* x = dynamic_cast<ast::MatchStmt*>(st)) {
        expr(x->subject);
        for (auto& c : x->cases) {
            openScope();
            for (const ast::Param& p : c.bindings) declare(p.name);
            block(c.body);
            closeScope();
        }
        if (x->defaultBody) block(*x->defaultBody);
        return;
    }
    if (auto* x = dynamic_cast<ast::TryStmt*>(st)) {
        block(x->body);
        for (auto& c : x->catches) {
            openScope();
            declare(c.name);
            block(c.body);
            closeScope();
        }
        if (x->finallyBlock) block(*x->finallyBlock);
        return;
    }
    if (auto* x = dynamic_cast<ast::DeferStmt*>(st)) { expr(x->within); block(x->body); return; }
    if (auto* x = dynamic_cast<ast::UsingStmt*>(st)) {
        openScope();
        stmt(x->decl.get());       // a VarDeclStmt: declares into the scope the body sees
        block(x->body);
        closeScope();
        return;
    }
    if (auto* x = dynamic_cast<ast::IfStmt*>(st)) {
        expr(x->cond);
        block(x->thenBlock);
        if (x->elseBlock) block(*x->elseBlock);
        return;
    }
    if (auto* x = dynamic_cast<ast::WhileStmt*>(st)) { expr(x->cond); block(x->body); return; }
    if (auto* x = dynamic_cast<ast::DoWhileStmt*>(st)) { block(x->body); expr(x->cond); return; }
    if (auto* x = dynamic_cast<ast::ForStmt*>(st)) {
        // The init's variable is in scope for the condition, the update and the body.
        openScope();
        stmt(x->init.get());
        expr(x->cond);
        stmt(x->update.get());
        block(x->body);
        closeScope();
        return;
    }
    if (auto* x = dynamic_cast<ast::SynchronizedStmt*>(st)) { expr(x->mutex); block(x->body); return; }
}

void runOnBody(ast::Block& body, const std::vector<ast::Param>& params, const Members& members,
               const std::string& className, bool isStatic,
               const std::set<std::string>& typeNames) {
    Rewriter r(members, className, isStatic, typeNames);
    r.openScope();
    for (const ast::Param& p : params) r.declare(p.name);
    r.block(body);
    r.closeScope();
}

}  // namespace

bool resolveImplicitThis(ast::Program& program) {
    ClassIndex index;
    std::set<std::string> typeNames;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                index[c.name] = &c;
                typeNames.insert(c.name);
            }
            for (auto& e : ns.enums) typeNames.insert(e.name);
        }

    // EVERY BODY, not just the methods. A lifecycle hook and an inline field initializer are code
    // written inside the class like any other, and a rule that held in a method and not in
    // `onClassLoad` would be a rule nobody could state.
    auto doMembers = [&](std::vector<ast::MemberPtr>& members, const std::string& owner,
                         const Members& seenMembers) {
        for (ast::MemberPtr& m : members) {
            if (auto* md = dynamic_cast<ast::MethodDecl*>(m.get())) {
                if (md->isAbstract) continue;
                runOnBody(md->body, md->params, seenMembers, owner, md->isStatic, typeNames);
                continue;
            }
            if (auto* cd = dynamic_cast<ast::ConstructorDecl*>(m.get())) {
                runOnBody(cd->body, cd->params, seenMembers, owner, false, typeNames);
                continue;
            }
            if (auto* dd = dynamic_cast<ast::DestructorDecl*>(m.get())) {
                runOnBody(dd->body, {}, seenMembers, owner, false, typeNames);
                continue;
            }
            if (auto* fd = dynamic_cast<ast::FieldDecl*>(m.get())) {
                if (fd->init == nullptr) continue;
                // A field initializer runs with no instance in hand for a static, and before the
                // constructor for an instance one; either way only a STATIC member is reachable, so
                // it is walked as static code.
                Rewriter r(seenMembers, owner, /*inStatic=*/true, typeNames);
                r.openScope();
                r.expr(fd->init);
                r.closeScope();
            }
        }
    };

    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                Members members;
                std::set<std::string> seen;
                gather(c.name, index, members, seen);
                doMembers(c.members, c.name, members);
                auto hook = [&](std::unique_ptr<ast::Block>& blk) {
                    if (blk) runOnBody(*blk, {}, members, c.name, /*inStatic=*/true, typeNames);
                };
                hook(c.onClassLoad);
                hook(c.onFirstInstance);
                hook(c.onLastInstanceDestroyed);
                hook(c.onClassUnload);
            }
            // A java-style enum is a class in every way that matters here: it has fields, a
            // constructor and methods, and code inside them names them the same way.
            for (auto& e : ns.enums) {
                if (e.members.empty()) continue;
                Members members;
                for (const ast::MemberPtr& m : e.members) {
                    if (const auto* f = dynamic_cast<const ast::FieldDecl*>(m.get())) {
                        if (f->isStatic) members.staticFields.insert(f->name);
                        else members.instanceFields.insert(f->name);
                        continue;
                    }
                    if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                        if (!md->isProperty) continue;   // a bare call already resolves on its own
                        if (md->isStatic) members.staticFields.insert(md->name);
                        else members.instanceFields.insert(md->name);
                    }
                }
                doMembers(e.members, e.name, members);
            }
        }
    return true;
}

}  // namespace ldp3
