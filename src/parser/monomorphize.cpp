#include "parser/monomorphize.h"

#include <map>
#include <set>
#include <string>
#include <utility>
#include <vector>

namespace ldp3 {
namespace {

using Subst = std::map<std::string, std::string>;            // type param -> concrete type
using InstMap = std::map<std::string, std::pair<std::string, std::vector<std::string>>>;  // mangled -> (base, args)

// Substitutes type parameters in a TypeRef (T -> int). Generic args are
// substituted in place; typeRefStr/typeRefName mangle them later.
ast::TypeRef substType(const ast::TypeRef& t, const Subst& s) {
    ast::TypeRef r = t;
    auto it = s.find(r.name);
    if (it != s.end()) r.name = it->second;
    for (std::string& a : r.typeArgs) {
        auto ai = s.find(a);
        if (ai != s.end()) a = ai->second;
    }
    return r;
}

// ---- Deep clone of the AST with type substitution ----
ast::ExprPtr cloneExpr(const ast::Expr* e, const Subst& s);
ast::StmtPtr cloneStmt(const ast::Stmt* st, const Subst& s);

ast::Block cloneBlock(const ast::Block& b, const Subst& s) {
    ast::Block r;
    r.loc = b.loc;
    for (const auto& st : b.statements) r.statements.push_back(cloneStmt(st.get(), s));
    return r;
}

ast::ExprPtr cloneExpr(const ast::Expr* e, const Subst& s) {
    if (e == nullptr) return nullptr;
    if (const auto* x = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        auto n = std::make_unique<ast::IdentifierExpr>();
        n->loc = x->loc;
        n->name = x->name;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IntLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::IntLiteralExpr>();
        n->loc = x->loc;
        n->text = x->text;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::FloatLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::FloatLiteralExpr>();
        n->loc = x->loc;
        n->text = x->text;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::StringLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::StringLiteralExpr>();
        n->loc = x->loc;
        n->value = x->value;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CharLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::CharLiteralExpr>();
        n->loc = x->loc;
        n->value = x->value;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::BoolLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::BoolLiteralExpr>();
        n->loc = x->loc;
        n->value = x->value;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) {
        auto n = std::make_unique<ast::MemberExpr>();
        n->loc = x->loc;
        n->member = x->member;
        n->object = cloneExpr(x->object.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        auto n = std::make_unique<ast::CallExpr>();
        n->loc = x->loc;
        n->fromSuffix = x->fromSuffix;
        n->callee = cloneExpr(x->callee.get(), s);
        for (const auto& a : x->args) n->args.push_back(cloneExpr(a.get(), s));
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) {
        auto n = std::make_unique<ast::BinaryExpr>();
        n->loc = x->loc;
        n->op = x->op;
        n->lhs = cloneExpr(x->lhs.get(), s);
        n->rhs = cloneExpr(x->rhs.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) {
        auto n = std::make_unique<ast::UnaryExpr>();
        n->loc = x->loc;
        n->op = x->op;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NewExpr*>(e)) {
        auto n = std::make_unique<ast::NewExpr>();
        n->loc = x->loc;
        n->className = x->className;
        auto it = s.find(n->className);
        if (it != s.end()) n->className = it->second;
        for (const std::string& a : x->typeArgs) {
            auto ai = s.find(a);
            n->typeArgs.push_back(ai != s.end() ? ai->second : a);
        }
        for (const auto& a : x->args) n->args.push_back(cloneExpr(a.get(), s));
        n->location = x->location;
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) {
        auto n = std::make_unique<ast::NewArrayExpr>();
        n->loc = x->loc;
        n->elementType = x->elementType;
        auto it = s.find(n->elementType);
        if (it != s.end()) n->elementType = it->second;
        n->size = cloneExpr(x->size.get(), s);
        n->location = x->location;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) {
        auto n = std::make_unique<ast::IndexExpr>();
        n->loc = x->loc;
        n->array = cloneExpr(x->array.get(), s);
        n->index = cloneExpr(x->index.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) {
        auto n = std::make_unique<ast::MoveExpr>();
        n->loc = x->loc;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) {
        auto n = std::make_unique<ast::CastExpr>();
        n->loc = x->loc;
        n->targetType = x->targetType;
        auto it = s.find(n->targetType);
        if (it != s.end()) n->targetType = it->second;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SuperExpr*>(e)) {
        auto n = std::make_unique<ast::SuperExpr>();
        n->loc = x->loc;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::RegionInitExpr*>(e)) {
        auto n = std::make_unique<ast::RegionInitExpr>();
        n->loc = x->loc;
        n->size = cloneExpr(x->size.get(), s);
        n->accepts = x->accepts;
        n->rejects = x->rejects;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) {
        auto n = std::make_unique<ast::InterpStringExpr>();
        n->loc = x->loc;
        n->literals = x->literals;
        for (const auto& ex : x->exprs) n->exprs.push_back(cloneExpr(ex.get(), s));
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MatchExpr*>(e)) {
        auto n = std::make_unique<ast::MatchExpr>();
        n->loc = x->loc;
        n->subject = cloneExpr(x->subject.get(), s);
        for (const auto& c : x->cases) {
            ast::MatchCase nc;
            nc.loc = c.loc;
            nc.typeName = c.typeName;
            auto it = s.find(nc.typeName);
            if (it != s.end()) nc.typeName = it->second;  // a case type may be a type param
            for (const auto& b : c.bindings) {
                ast::Param p;
                p.loc = b.loc;
                p.type = substType(b.type, s);
                p.name = b.name;
                nc.bindings.push_back(std::move(p));
            }
            nc.result = cloneExpr(c.result.get(), s);
            n->cases.push_back(std::move(nc));
        }
        n->defaultResult = cloneExpr(x->defaultResult.get(), s);
        return n;
    }
    return nullptr;  // unknown node: should not happen for well-formed input
}

ast::StmtPtr cloneStmt(const ast::Stmt* st, const Subst& s) {
    if (st == nullptr) return nullptr;
    if (const auto* x = dynamic_cast<const ast::ExprStmt*>(st)) {
        auto n = std::make_unique<ast::ExprStmt>();
        n->loc = x->loc;
        n->expr = cloneExpr(x->expr.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) {
        auto n = std::make_unique<ast::ReturnStmt>();
        n->loc = x->loc;
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) {
        auto n = std::make_unique<ast::DeleteStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ReleaseStmt*>(st)) {
        auto n = std::make_unique<ast::ReleaseStmt>();
        n->loc = x->loc;
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) {
        auto n = std::make_unique<ast::VarDeclStmt>();
        n->loc = x->loc;
        n->isMutable = x->isMutable;
        n->isVar = x->isVar;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->init = cloneExpr(x->init.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) {
        auto n = std::make_unique<ast::AssignStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) {
        auto n = std::make_unique<ast::IncDecStmt>();
        n->loc = x->loc;
        n->target = cloneExpr(x->target.get(), s);
        n->isIncrement = x->isIncrement;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) {
        auto n = std::make_unique<ast::DeferStmt>();
        n->loc = x->loc;
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) {
        auto n = std::make_unique<ast::UsingStmt>();
        n->loc = x->loc;
        n->decl = cloneStmt(x->decl.get(), s);
        n->varName = x->varName;
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) {
        auto n = std::make_unique<ast::IfStmt>();
        n->loc = x->loc;
        n->cond = cloneExpr(x->cond.get(), s);
        n->thenBlock = cloneBlock(x->thenBlock, s);
        if (x->elseBlock) n->elseBlock = std::make_unique<ast::Block>(cloneBlock(*x->elseBlock, s));
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) {
        auto n = std::make_unique<ast::WhileStmt>();
        n->loc = x->loc;
        n->cond = cloneExpr(x->cond.get(), s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) {
        auto n = std::make_unique<ast::ForStmt>();
        n->loc = x->loc;
        n->init = cloneStmt(x->init.get(), s);
        n->cond = cloneExpr(x->cond.get(), s);
        n->update = cloneStmt(x->update.get(), s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    return nullptr;
}

ast::MemberPtr cloneMember(const ast::MemberDecl* m, const Subst& s) {
    if (const auto* x = dynamic_cast<const ast::MethodDecl*>(m)) {
        auto n = std::make_unique<ast::MethodDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->isStatic = x->isStatic;
        n->isAbstract = x->isAbstract;
        n->isOverride = x->isOverride;
        n->isFinal = x->isFinal;
        n->name = x->name;
        for (const auto& p : x->params) n->params.push_back({substType(p.type, s), p.name, p.loc});
        n->returnType = substType(x->returnType, s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::FieldDecl*>(m)) {
        auto n = std::make_unique<ast::FieldDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->isStatic = x->isStatic;
        n->isMutable = x->isMutable;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->init = cloneExpr(x->init.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ConstructorDecl*>(m)) {
        auto n = std::make_unique<ast::ConstructorDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        for (const auto& p : x->params) n->params.push_back({substType(p.type, s), p.name, p.loc});
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::DestructorDecl*>(m)) {
        auto n = std::make_unique<ast::DestructorDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->body = cloneBlock(x->body, s);
        return n;
    }
    return nullptr;
}

ast::ClassDecl cloneClass(const ast::ClassDecl& d, const Subst& s, const std::string& newName) {
    ast::ClassDecl c;
    c.loc = d.loc;
    c.visibility = d.visibility;
    c.name = newName;  // concrete: no type params
    c.isInterface = d.isInterface;
    c.isStruct = d.isStruct;
    c.isRecord = d.isRecord;
    c.isAbstract = d.isAbstract;
    c.isMovable = d.isMovable;
    c.isUnique = d.isUnique;
    c.superclass = d.superclass;
    c.interfaces = d.interfaces;
    for (const auto& m : d.members) c.members.push_back(cloneMember(m.get(), s));
    return c;
}

// ---- Collect generic instantiations used in the program ----
void collectType(const ast::TypeRef& t, const std::set<std::string>& generics, InstMap& out) {
    if (!t.typeArgs.empty() && generics.count(t.name) > 0) {
        out[ast::mangleGeneric(t.name, t.typeArgs)] = {t.name, t.typeArgs};
    }
}
void collectExpr(const ast::Expr* e, const std::set<std::string>& g, InstMap& out);
void collectStmt(const ast::Stmt* st, const std::set<std::string>& g, InstMap& out);
void collectBlock(const ast::Block& b, const std::set<std::string>& g, InstMap& out) {
    for (const auto& st : b.statements) collectStmt(st.get(), g, out);
}
void collectExpr(const ast::Expr* e, const std::set<std::string>& g, InstMap& out) {
    if (e == nullptr) return;
    if (const auto* x = dynamic_cast<const ast::NewExpr*>(e)) {
        if (!x->typeArgs.empty() && g.count(x->className) > 0) {
            out[ast::mangleGeneric(x->className, x->typeArgs)] = {x->className, x->typeArgs};
        }
        for (const auto& a : x->args) collectExpr(a.get(), g, out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) { collectExpr(x->object.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        collectExpr(x->callee.get(), g, out);
        for (const auto& a : x->args) collectExpr(a.get(), g, out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) { collectExpr(x->lhs.get(), g, out); collectExpr(x->rhs.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) { collectExpr(x->array.get(), g, out); collectExpr(x->index.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) { for (const auto& ex : x->exprs) collectExpr(ex.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) { collectExpr(x->size.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::RegionInitExpr*>(e)) { collectExpr(x->size.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::MatchExpr*>(e)) {
        collectExpr(x->subject.get(), g, out);
        for (const auto& c : x->cases) collectExpr(c.result.get(), g, out);
        collectExpr(x->defaultResult.get(), g, out);
        return;
    }
}
void collectStmt(const ast::Stmt* st, const std::set<std::string>& g, InstMap& out) {
    if (st == nullptr) return;
    if (const auto* x = dynamic_cast<const ast::ExprStmt*>(st)) { collectExpr(x->expr.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) { collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) { collectExpr(x->target.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) { collectType(x->type, g, out); collectExpr(x->init.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) { collectExpr(x->target.get(), g, out); collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) { collectExpr(x->target.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) { collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) { collectStmt(x->decl.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) { collectExpr(x->cond.get(), g, out); collectBlock(x->thenBlock, g, out); if (x->elseBlock) collectBlock(*x->elseBlock, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) { collectExpr(x->cond.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) { collectStmt(x->init.get(), g, out); collectExpr(x->cond.get(), g, out); collectStmt(x->update.get(), g, out); collectBlock(x->body, g, out); return; }
}
void collectClass(const ast::ClassDecl& c, const std::set<std::string>& g, InstMap& out) {
    for (const auto& m : c.members) {
        if (const auto* x = dynamic_cast<const ast::MethodDecl*>(m.get())) {
            for (const auto& p : x->params) collectType(p.type, g, out);
            collectType(x->returnType, g, out);
            collectBlock(x->body, g, out);
        } else if (const auto* x = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            collectType(x->type, g, out);
            collectExpr(x->init.get(), g, out);
        } else if (const auto* x = dynamic_cast<const ast::ConstructorDecl*>(m.get())) {
            for (const auto& p : x->params) collectType(p.type, g, out);
            collectBlock(x->body, g, out);
        } else if (const auto* x = dynamic_cast<const ast::DestructorDecl*>(m.get())) {
            collectBlock(x->body, g, out);
        }
    }
}

}  // namespace

void monomorphize(ast::Program& program) {
    // Index generic templates by name.
    std::map<std::string, const ast::ClassDecl*> templates;
    std::set<std::string> generics;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes)
                if (!c.typeParams.empty()) {
                    templates[c.name] = &c;
                    generics.insert(c.name);
                }
    if (templates.empty()) return;

    // Collect instantiations used across the whole program.
    InstMap insts;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes) collectClass(c, generics, insts);

    // Generate a concrete class per instantiation (worklist for transitive ones).
    std::vector<ast::ClassDecl> generated;
    std::set<std::string> done;
    std::vector<std::string> work;
    for (const auto& [m, _] : insts) work.push_back(m);
    while (!work.empty()) {
        const std::string m = work.back();
        work.pop_back();
        if (done.count(m) > 0) continue;
        done.insert(m);
        const auto& [base, args] = insts[m];
        auto tit = templates.find(base);
        if (tit == templates.end() || tit->second->typeParams.size() != args.size()) continue;
        Subst s;
        for (std::size_t i = 0; i < args.size(); ++i) s[tit->second->typeParams[i]] = args[i];
        ast::ClassDecl concrete = cloneClass(*tit->second, s, m);
        InstMap more;
        collectClass(concrete, generics, more);
        for (const auto& [mm, pp] : more) {
            if (insts.find(mm) == insts.end()) insts[mm] = pp;
            if (done.count(mm) == 0) work.push_back(mm);
        }
        generated.push_back(std::move(concrete));
    }

    // Drop the templates; the generated concrete classes take their place.
    ast::Namespace* sink = nullptr;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces) {
            std::vector<ast::ClassDecl> kept;
            for (auto& c : ns.classes)
                if (c.typeParams.empty()) kept.push_back(std::move(c));
            ns.classes = std::move(kept);
            if (sink == nullptr) sink = &ns;
        }
    if (sink != nullptr)
        for (auto& c : generated) sink->classes.push_back(std::move(c));
}

}  // namespace ldp3
