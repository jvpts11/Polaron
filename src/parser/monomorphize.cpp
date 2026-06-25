#include "parser/monomorphize.h"

#include <cstdio>
#include <map>
#include <set>
#include <string>
#include <utility>
#include <vector>

namespace ldp3 {
namespace {

using Subst = std::map<std::string, std::string>;            // type param -> concrete type
using InstMap = std::map<std::string, std::pair<std::string, std::vector<std::string>>>;  // mangled -> (base, args)

// `typealias` targets (spec 24), resolved transparently everywhere a type appears. Keyed by the
// alias name -> its target TypeRef. `newtype`s are NOT here -- they are distinct nominal types and
// must survive to the analyzer. Populated by resolveTypeAliases and consulted by substType, so the
// rest of the pipeline only ever sees concrete types.
std::map<std::string, ast::TypeRef> g_aliases;

// Resolve a bare type-name string (a typeArg, superclass, interface, or cast target) through the
// alias map, returning the canonical form of its target (or the name unchanged if not an alias).
std::string resolveAliasName(const std::string& name) {
    auto it = g_aliases.find(name);
    return it == g_aliases.end() ? name : ast::canonicalType(it->second);
}

// Substitutes type parameters in a TypeRef (T -> int). Generic args are
// substituted in place; typeRefStr/typeRefName mangle them later. Also expands any
// `typealias` in the base name or type arguments (transparent rewrite, spec 24).
ast::TypeRef substType(const ast::TypeRef& t, const Subst& s) {
    ast::TypeRef r = t;
    if (auto ai = g_aliases.find(r.name); ai != g_aliases.end()) {
        const ast::TypeRef& tgt = ai->second;  // expand the alias into the target's structure
        r.name = tgt.name;
        r.typeArgs.insert(r.typeArgs.begin(), tgt.typeArgs.begin(), tgt.typeArgs.end());
        r.isArray = r.isArray || tgt.isArray;
        r.isPointer = r.isPointer || tgt.isPointer;
        r.isRef = r.isRef || tgt.isRef;
        r.isNullable = r.isNullable || tgt.isNullable;
    }
    auto it = s.find(r.name);
    if (it != s.end()) r.name = it->second;
    for (std::string& a : r.typeArgs) {
        a = resolveAliasName(a);
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
    if (const auto* x = dynamic_cast<const ast::LambdaExpr*>(e)) {
        auto n = std::make_unique<ast::LambdaExpr>();
        n->loc = x->loc;
        for (const auto& p : x->params) {
            ast::Param np;
            np.type = substType(p.type, s);
            np.name = p.name;
            np.loc = p.loc;
            n->params.push_back(std::move(np));
        }
        n->returnType = substType(x->returnType, s);
        n->body = cloneBlock(x->body, s);
        n->captures = x->captures;  // captures carry no types to substitute -- copy as-is
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
    if (const auto* x = dynamic_cast<const ast::NullLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::NullLiteralExpr>();
        n->loc = x->loc;
        return n;  // was missing -> cloned `null` became nullptr -> typeOf(*nullptr) crash
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) {
        auto n = std::make_unique<ast::MemberExpr>();
        n->loc = x->loc;
        n->member = x->member;
        n->object = cloneExpr(x->object.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MethodRefExpr*>(e)) {
        auto n = std::make_unique<ast::MethodRefExpr>();
        n->loc = x->loc;
        n->method = x->method;
        n->object = cloneExpr(x->object.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        auto n = std::make_unique<ast::CallExpr>();
        n->loc = x->loc;
        n->fromSuffix = x->fromSuffix;
        n->callee = cloneExpr(x->callee.get(), s);
        for (const auto& a : x->args) n->args.push_back(cloneExpr(a.get(), s));
        for (const std::string& a : x->typeArgs) {  // generic call args may be type params
            auto ai = s.find(a);
            n->typeArgs.push_back(ai != s.end() ? ai->second : a);
        }
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
    if (const auto* x = dynamic_cast<const ast::TernaryExpr*>(e)) {
        auto n = std::make_unique<ast::TernaryExpr>();
        n->loc = x->loc;
        n->cond = cloneExpr(x->cond.get(), s);
        n->thenExpr = cloneExpr(x->thenExpr.get(), s);
        n->elseExpr = cloneExpr(x->elseExpr.get(), s);
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
        if (auto ai = g_aliases.find(n->className); ai != g_aliases.end()) {
            n->className = ai->second.name;  // `new DogList()` -> `new ArrayList<Dog>()`
            n->typeArgs.insert(n->typeArgs.end(), ai->second.typeArgs.begin(),
                               ai->second.typeArgs.end());
        }
        auto it = s.find(n->className);
        if (it != s.end()) n->className = it->second;
        for (const std::string& a : x->typeArgs) {
            const std::string ra = resolveAliasName(a);
            auto ai = s.find(ra);
            n->typeArgs.push_back(ai != s.end() ? ai->second : ra);
        }
        for (const auto& a : x->args) n->args.push_back(cloneExpr(a.get(), s));
        n->location = x->location;
        n->region = x->region;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) {
        auto n = std::make_unique<ast::NewArrayExpr>();
        n->loc = x->loc;
        n->elementType = resolveAliasName(x->elementType);
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
    if (const auto* x = dynamic_cast<const ast::TryExpr*>(e)) {
        auto n = std::make_unique<ast::TryExpr>();
        n->loc = x->loc;
        n->operand = cloneExpr(x->operand.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) {
        auto n = std::make_unique<ast::CastExpr>();
        n->loc = x->loc;
        n->targetType = resolveAliasName(x->targetType);
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
    if (const auto* x = dynamic_cast<const ast::TupleExpr*>(e)) {
        auto n = std::make_unique<ast::TupleExpr>();
        n->loc = x->loc;
        for (const auto& ex : x->elements) n->elements.push_back(cloneExpr(ex.get(), s));
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
    if (const auto* x = dynamic_cast<const ast::StaticAssertStmt*>(st)) {
        auto n = std::make_unique<ast::StaticAssertStmt>();
        n->loc = x->loc;
        n->message = x->message;
        n->condition = cloneExpr(x->condition.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::BreakStmt*>(st)) {
        auto n = std::make_unique<ast::BreakStmt>();
        n->loc = st->loc;
        n->label = x->label;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ContinueStmt*>(st)) {
        auto n = std::make_unique<ast::ContinueStmt>();
        n->loc = st->loc;
        n->label = x->label;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) {
        auto n = std::make_unique<ast::LabeledStmt>();
        n->loc = st->loc;
        n->label = x->label;
        n->stmt = cloneStmt(x->stmt.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::LabelMarkStmt*>(st)) {
        auto n = std::make_unique<ast::LabelMarkStmt>();
        n->loc = st->loc;
        n->name = x->name;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ComefromStmt*>(st)) {
        auto n = std::make_unique<ast::ComefromStmt>();
        n->loc = st->loc;
        n->name = x->name;
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ThrowStmt*>(st)) {
        auto n = std::make_unique<ast::ThrowStmt>();
        n->loc = x->loc;
        n->value = cloneExpr(x->value.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) {
        auto n = std::make_unique<ast::TryStmt>();
        n->loc = x->loc;
        n->body = cloneBlock(x->body, s);
        for (const auto& c : x->catches) {
            ast::CatchClause nc;
            nc.loc = c.loc;
            nc.type = substType(c.type, s);
            nc.name = c.name;
            nc.body = cloneBlock(c.body, s);
            n->catches.push_back(std::move(nc));
        }
        if (x->finallyBlock)
            n->finallyBlock = std::make_unique<ast::Block>(cloneBlock(*x->finallyBlock, s));
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) {
        auto n = std::make_unique<ast::ForeachStmt>();
        n->loc = x->loc;
        n->elemType = substType(x->elemType, s);
        n->isVar = x->isVar;
        n->varName = x->varName;
        n->iterable = cloneExpr(x->iterable.get(), s);
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) {
        auto n = std::make_unique<ast::SwitchStmt>();
        n->loc = x->loc;
        n->subject = cloneExpr(x->subject.get(), s);
        for (const auto& c : x->cases) {
            ast::SwitchCase nc;
            nc.loc = c.loc;
            nc.value = cloneExpr(c.value.get(), s);
            nc.body = cloneBlock(c.body, s);
            n->cases.push_back(std::move(nc));
        }
        if (x->defaultBody) n->defaultBody = std::make_unique<ast::Block>(cloneBlock(*x->defaultBody, s));
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) {  // was missing -> null deref crash
        auto n = std::make_unique<ast::MatchStmt>();
        n->loc = x->loc;
        n->subject = cloneExpr(x->subject.get(), s);
        for (const auto& c : x->cases) {
            ast::MatchCase nc;
            nc.loc = c.loc;
            auto it = s.find(c.typeName);
            nc.typeName = it != s.end() ? it->second : c.typeName;
            for (const auto& b : c.bindings) {
                ast::Param p;
                p.type = substType(b.type, s);
                p.name = b.name;
                p.loc = b.loc;
                nc.bindings.push_back(std::move(p));
            }
            nc.body = cloneBlock(c.body, s);
            if (c.result) nc.result = cloneExpr(c.result.get(), s);
            n->cases.push_back(std::move(nc));
        }
        if (x->defaultBody) n->defaultBody = std::make_unique<ast::Block>(cloneBlock(*x->defaultBody, s));
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
        n->isPersistent = x->isPersistent;
        n->isEternal = x->isEternal;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->init = cloneExpr(x->init.get(), s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::TupleDeclStmt*>(st)) {
        auto n = std::make_unique<ast::TupleDeclStmt>();
        n->loc = x->loc;
        for (const auto& b : x->bindings) {
            ast::TupleBinding nb;
            nb.type = substType(b.type, s);
            nb.name = b.name;
            n->bindings.push_back(std::move(nb));
        }
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
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) {
        auto n = std::make_unique<ast::DoWhileStmt>();
        n->loc = x->loc;
        n->body = cloneBlock(x->body, s);
        n->cond = cloneExpr(x->cond.get(), s);
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
        n->isProperty = x->isProperty;
        n->isComptime = x->isComptime;
        n->name = x->name;
        n->typeParams = x->typeParams;
        for (const auto& p : x->params) n->params.push_back({substType(p.type, s), p.name, p.loc});
        n->returnType = substType(x->returnType, s);
        for (const auto& t : x->throwsTypes) n->throwsTypes.push_back(substType(t, s));
        for (const auto& c : x->requiresClauses) n->requiresClauses.push_back(cloneExpr(c.get(), s));
        for (const auto& c : x->ensuresClauses) n->ensuresClauses.push_back(cloneExpr(c.get(), s));
        n->body = cloneBlock(x->body, s);
        return n;
    }
    if (const auto* x = dynamic_cast<const ast::FieldDecl*>(m)) {
        auto n = std::make_unique<ast::FieldDecl>();
        n->loc = x->loc;
        n->visibility = x->visibility;
        n->isStatic = x->isStatic;
        n->isMutable = x->isMutable;
        n->isPersistent = x->isPersistent;
        n->isEternal = x->isEternal;
        n->isTransient = x->isTransient;
        n->isVolatile = x->isVolatile;
        n->isLazy = x->isLazy;
        n->type = substType(x->type, s);
        n->name = x->name;
        n->bitWidth = x->bitWidth;
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
    c.isSealed = d.isSealed;          // keep sealed + permits so generic-sealed match stays exhaustive
    c.permits = d.permits;
    c.typeParamBounds = d.typeParamBounds;
    c.isMovable = d.isMovable;
    c.isUnique = d.isUnique;
    c.isPartitionable = d.isPartitionable;
    c.superclass = d.superclass;
    for (const auto& a : d.superclassTypeArgs) {  // substitute T in `extends Base<T>`
        auto it = s.find(a);
        c.superclassTypeArgs.push_back(it != s.end() ? it->second : a);
    }
    c.interfaces = d.interfaces;
    for (const auto& argList : d.interfaceTypeArgs) {  // substitute T in `implements Iface<T>`
        std::vector<std::string> sub;
        for (const auto& a : argList) {
            auto it = s.find(a);
            sub.push_back(it != s.end() ? it->second : a);
        }
        c.interfaceTypeArgs.push_back(std::move(sub));
    }
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
        // Reflection t.methods()/t.fields() return ArrayList<String>; force its
        // monomorphization here since the user never names the type (spec 31).
        if (const auto* m = dynamic_cast<const ast::MemberExpr*>(x->callee.get()))
            if ((m->member == "methods" || m->member == "fields") && g.count("ArrayList") > 0)
                out["ArrayList$String"] = {"ArrayList", {"String"}};
        collectExpr(x->callee.get(), g, out);
        for (const auto& a : x->args) collectExpr(a.get(), g, out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) { collectExpr(x->lhs.get(), g, out); collectExpr(x->rhs.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TernaryExpr*>(e)) { collectExpr(x->cond.get(), g, out); collectExpr(x->thenExpr.get(), g, out); collectExpr(x->elseExpr.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) { collectExpr(x->array.get(), g, out); collectExpr(x->index.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TryExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) { collectExpr(x->operand.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) { for (const auto& ex : x->exprs) collectExpr(ex.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TupleExpr*>(e)) { for (const auto& ex : x->elements) collectExpr(ex.get(), g, out); return; }
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
    if (const auto* x = dynamic_cast<const ast::StaticAssertStmt*>(st)) { collectExpr(x->condition.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) { collectStmt(x->stmt.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) { collectType(x->elemType, g, out); collectExpr(x->iterable.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) { collectExpr(x->subject.get(), g, out); for (const auto& c : x->cases) { collectExpr(c.value.get(), g, out); collectBlock(c.body, g, out); } if (x->defaultBody) collectBlock(*x->defaultBody, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) { collectExpr(x->subject.get(), g, out); for (const auto& c : x->cases) collectBlock(c.body, g, out); if (x->defaultBody) collectBlock(*x->defaultBody, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ThrowStmt*>(st)) { collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) { collectBlock(x->body, g, out); for (const auto& c : x->catches) { collectType(c.type, g, out); collectBlock(c.body, g, out); } if (x->finallyBlock) collectBlock(*x->finallyBlock, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) { collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) { collectExpr(x->target.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) { collectType(x->type, g, out); collectExpr(x->init.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::TupleDeclStmt*>(st)) { for (const auto& b : x->bindings) collectType(b.type, g, out); collectExpr(x->init.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) { collectExpr(x->target.get(), g, out); collectExpr(x->value.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) { collectExpr(x->target.get(), g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) { collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) { collectStmt(x->decl.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) { collectExpr(x->cond.get(), g, out); collectBlock(x->thenBlock, g, out); if (x->elseBlock) collectBlock(*x->elseBlock, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) { collectExpr(x->cond.get(), g, out); collectBlock(x->body, g, out); return; }
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) { collectBlock(x->body, g, out); collectExpr(x->cond.get(), g, out); return; }
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
    // A generic interface used in `implements Iface<Args>` is an instantiation too.
    for (std::size_t k = 0; k < c.interfaceTypeArgs.size() && k < c.interfaces.size(); ++k) {
        const auto& args = c.interfaceTypeArgs[k];
        if (!args.empty() && g.count(c.interfaces[k]) > 0)
            out[ast::mangleGeneric(c.interfaces[k], args)] = {c.interfaces[k], args};
    }
}

// ---- Generic methods (spec 15) ----
// A generic method `m<T>(...)` is monomorphized like a generic class: one
// concrete method per (name, type-args) call site. Because monomorphize runs
// before sema, a call `obj.m<int>()` can't be resolved to a receiver class by
// type; so every class that declares a generic method named `m` gets a concrete
// `m$int`, and the calls are rewritten to the mangled member. Sema/codegen then
// see ordinary calls.

using MethInst = std::pair<std::string, std::vector<std::string>>;  // (name, args)
using MethInsts = std::set<MethInst>;

// Collects every generic call's (name, type-args) from an expression tree.
// Const: it observes only; the rewrite to the mangled member is a later pass.
void collectMethExpr(const ast::Expr* e, MethInsts& out);
void collectMethStmt(const ast::Stmt* st, MethInsts& out);
void collectMethBlock(const ast::Block& b, MethInsts& out) {
    for (const auto& st : b.statements) collectMethStmt(st.get(), out);
}
void collectMethExpr(const ast::Expr* e, MethInsts& out) {
    if (e == nullptr) return;
    if (const auto* x = dynamic_cast<const ast::CallExpr*>(e)) {
        if (!x->typeArgs.empty())
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(x->callee.get()))
                out.insert({mem->member, x->typeArgs});
        collectMethExpr(x->callee.get(), out);
        for (const auto& a : x->args) collectMethExpr(a.get(), out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::MemberExpr*>(e)) { collectMethExpr(x->object.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::BinaryExpr*>(e)) { collectMethExpr(x->lhs.get(), out); collectMethExpr(x->rhs.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::TernaryExpr*>(e)) { collectMethExpr(x->cond.get(), out); collectMethExpr(x->thenExpr.get(), out); collectMethExpr(x->elseExpr.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::UnaryExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::IndexExpr*>(e)) { collectMethExpr(x->array.get(), out); collectMethExpr(x->index.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::MoveExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::TryExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::CastExpr*>(e)) { collectMethExpr(x->operand.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::NewExpr*>(e)) { for (const auto& a : x->args) collectMethExpr(a.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::NewArrayExpr*>(e)) { collectMethExpr(x->size.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::RegionInitExpr*>(e)) { collectMethExpr(x->size.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::InterpStringExpr*>(e)) { for (const auto& ex : x->exprs) collectMethExpr(ex.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::MatchExpr*>(e)) {
        collectMethExpr(x->subject.get(), out);
        for (const auto& c : x->cases) collectMethExpr(c.result.get(), out);
        collectMethExpr(x->defaultResult.get(), out);
        return;
    }
    if (const auto* x = dynamic_cast<const ast::LambdaExpr*>(e)) { collectMethBlock(x->body, out); return; }
}
void collectMethStmt(const ast::Stmt* st, MethInsts& out) {
    if (st == nullptr) return;
    if (const auto* x = dynamic_cast<const ast::ExprStmt*>(st)) { collectMethExpr(x->expr.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::StaticAssertStmt*>(st)) { collectMethExpr(x->condition.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::LabeledStmt*>(st)) { collectMethStmt(x->stmt.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::ForeachStmt*>(st)) { collectMethExpr(x->iterable.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::SwitchStmt*>(st)) { collectMethExpr(x->subject.get(), out); for (const auto& c : x->cases) { collectMethExpr(c.value.get(), out); collectMethBlock(c.body, out); } if (x->defaultBody) collectMethBlock(*x->defaultBody, out); return; }
    if (const auto* x = dynamic_cast<const ast::MatchStmt*>(st)) { collectMethExpr(x->subject.get(), out); for (const auto& c : x->cases) collectMethBlock(c.body, out); if (x->defaultBody) collectMethBlock(*x->defaultBody, out); return; }
    if (const auto* x = dynamic_cast<const ast::ThrowStmt*>(st)) { collectMethExpr(x->value.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::TryStmt*>(st)) { collectMethBlock(x->body, out); for (const auto& c : x->catches) collectMethBlock(c.body, out); if (x->finallyBlock) collectMethBlock(*x->finallyBlock, out); return; }
    if (const auto* x = dynamic_cast<const ast::ReturnStmt*>(st)) { collectMethExpr(x->value.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::DeleteStmt*>(st)) { collectMethExpr(x->target.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::VarDeclStmt*>(st)) { collectMethExpr(x->init.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::AssignStmt*>(st)) { collectMethExpr(x->target.get(), out); collectMethExpr(x->value.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::IncDecStmt*>(st)) { collectMethExpr(x->target.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::DeferStmt*>(st)) { collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::UsingStmt*>(st)) { collectMethStmt(x->decl.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::IfStmt*>(st)) { collectMethExpr(x->cond.get(), out); collectMethBlock(x->thenBlock, out); if (x->elseBlock) collectMethBlock(*x->elseBlock, out); return; }
    if (const auto* x = dynamic_cast<const ast::WhileStmt*>(st)) { collectMethExpr(x->cond.get(), out); collectMethBlock(x->body, out); return; }
    if (const auto* x = dynamic_cast<const ast::DoWhileStmt*>(st)) { collectMethBlock(x->body, out); collectMethExpr(x->cond.get(), out); return; }
    if (const auto* x = dynamic_cast<const ast::ForStmt*>(st)) { collectMethStmt(x->init.get(), out); collectMethExpr(x->cond.get(), out); collectMethStmt(x->update.get(), out); collectMethBlock(x->body, out); return; }
}

// Rewrites every generic call `obj.m<args>(...)` to the mangled member
// `obj.m$args(...)` with empty type-args, so sema/codegen see an ordinary call.
void rewriteMethExpr(ast::Expr* e);
void rewriteMethStmt(ast::Stmt* st);
void rewriteMethBlock(ast::Block& b) {
    for (auto& st : b.statements) rewriteMethStmt(st.get());
}
// Names of generic methods actually declared in the program; only calls to these get mangled.
// Without this, a builtin like `Memory.read<int8>(...)` (type args, but not a user generic method)
// would be wrongly rewritten to `Memory.read$int8` and lose its builtin meaning.
static const std::set<std::string>* g_genericMethodNames = nullptr;
void rewriteMethExpr(ast::Expr* e) {
    if (e == nullptr) return;
    if (auto* x = dynamic_cast<ast::CallExpr*>(e)) {
        if (!x->typeArgs.empty())
            if (auto* mem = dynamic_cast<ast::MemberExpr*>(x->callee.get()))
                if (g_genericMethodNames == nullptr ||
                    g_genericMethodNames->count(mem->member) > 0) {
                    mem->member = ast::mangleGeneric(mem->member, x->typeArgs);
                    x->typeArgs.clear();
                }
        rewriteMethExpr(x->callee.get());
        for (auto& a : x->args) rewriteMethExpr(a.get());
        return;
    }
    if (auto* x = dynamic_cast<ast::MemberExpr*>(e)) { rewriteMethExpr(x->object.get()); return; }
    if (auto* x = dynamic_cast<ast::BinaryExpr*>(e)) { rewriteMethExpr(x->lhs.get()); rewriteMethExpr(x->rhs.get()); return; }
    if (auto* x = dynamic_cast<ast::TernaryExpr*>(e)) { rewriteMethExpr(x->cond.get()); rewriteMethExpr(x->thenExpr.get()); rewriteMethExpr(x->elseExpr.get()); return; }
    if (auto* x = dynamic_cast<ast::UnaryExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::IndexExpr*>(e)) { rewriteMethExpr(x->array.get()); rewriteMethExpr(x->index.get()); return; }
    if (auto* x = dynamic_cast<ast::MoveExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::TryExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::CastExpr*>(e)) { rewriteMethExpr(x->operand.get()); return; }
    if (auto* x = dynamic_cast<ast::NewExpr*>(e)) { for (auto& a : x->args) rewriteMethExpr(a.get()); return; }
    if (auto* x = dynamic_cast<ast::NewArrayExpr*>(e)) { rewriteMethExpr(x->size.get()); return; }
    if (auto* x = dynamic_cast<ast::RegionInitExpr*>(e)) { rewriteMethExpr(x->size.get()); return; }
    if (auto* x = dynamic_cast<ast::InterpStringExpr*>(e)) { for (auto& ex : x->exprs) rewriteMethExpr(ex.get()); return; }
    if (auto* x = dynamic_cast<ast::MatchExpr*>(e)) {
        rewriteMethExpr(x->subject.get());
        for (auto& c : x->cases) rewriteMethExpr(c.result.get());
        rewriteMethExpr(x->defaultResult.get());
        return;
    }
    if (auto* x = dynamic_cast<ast::LambdaExpr*>(e)) { rewriteMethBlock(x->body); return; }
}
void rewriteMethStmt(ast::Stmt* st) {
    if (st == nullptr) return;
    if (auto* x = dynamic_cast<ast::ExprStmt*>(st)) { rewriteMethExpr(x->expr.get()); return; }
    if (auto* x = dynamic_cast<ast::StaticAssertStmt*>(st)) { rewriteMethExpr(x->condition.get()); return; }
    if (auto* x = dynamic_cast<ast::LabeledStmt*>(st)) { rewriteMethStmt(x->stmt.get()); return; }
    if (auto* x = dynamic_cast<ast::ForeachStmt*>(st)) { rewriteMethExpr(x->iterable.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::SwitchStmt*>(st)) { rewriteMethExpr(x->subject.get()); for (auto& c : x->cases) { rewriteMethExpr(c.value.get()); rewriteMethBlock(c.body); } if (x->defaultBody) rewriteMethBlock(*x->defaultBody); return; }
    if (auto* x = dynamic_cast<ast::MatchStmt*>(st)) { rewriteMethExpr(x->subject.get()); for (auto& c : x->cases) rewriteMethBlock(c.body); if (x->defaultBody) rewriteMethBlock(*x->defaultBody); return; }
    if (auto* x = dynamic_cast<ast::ThrowStmt*>(st)) { rewriteMethExpr(x->value.get()); return; }
    if (auto* x = dynamic_cast<ast::TryStmt*>(st)) { rewriteMethBlock(x->body); for (auto& c : x->catches) rewriteMethBlock(c.body); if (x->finallyBlock) rewriteMethBlock(*x->finallyBlock); return; }
    if (auto* x = dynamic_cast<ast::ReturnStmt*>(st)) { rewriteMethExpr(x->value.get()); return; }
    if (auto* x = dynamic_cast<ast::DeleteStmt*>(st)) { rewriteMethExpr(x->target.get()); return; }
    if (auto* x = dynamic_cast<ast::VarDeclStmt*>(st)) { rewriteMethExpr(x->init.get()); return; }
    if (auto* x = dynamic_cast<ast::AssignStmt*>(st)) { rewriteMethExpr(x->target.get()); rewriteMethExpr(x->value.get()); return; }
    if (auto* x = dynamic_cast<ast::IncDecStmt*>(st)) { rewriteMethExpr(x->target.get()); return; }
    if (auto* x = dynamic_cast<ast::DeferStmt*>(st)) { rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::UsingStmt*>(st)) { rewriteMethStmt(x->decl.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::IfStmt*>(st)) { rewriteMethExpr(x->cond.get()); rewriteMethBlock(x->thenBlock); if (x->elseBlock) rewriteMethBlock(*x->elseBlock); return; }
    if (auto* x = dynamic_cast<ast::WhileStmt*>(st)) { rewriteMethExpr(x->cond.get()); rewriteMethBlock(x->body); return; }
    if (auto* x = dynamic_cast<ast::DoWhileStmt*>(st)) { rewriteMethBlock(x->body); rewriteMethExpr(x->cond.get()); return; }
    if (auto* x = dynamic_cast<ast::ForStmt*>(st)) { rewriteMethStmt(x->init.get()); rewriteMethExpr(x->cond.get()); rewriteMethStmt(x->update.get()); rewriteMethBlock(x->body); return; }
}

// Expands generic methods program-wide. Materializes one concrete method per
// (name, type-args) call site on every class declaring a matching generic
// template, drops the templates, then rewrites every generic call to the mangled
// member. Cloning substitutes the type params, so a concrete body's own generic
// call `inner<T>` becomes `inner<int>`; a worklist collects those transitively.
void expandGenericMethods(ast::Program& program) {
    // Any generic method templates at all? If not, there is nothing to do.
    bool anyTemplate = false;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes)
                for (auto& m : c.members)
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get()))
                        if (!meth->typeParams.empty()) anyTemplate = true;
    if (!anyTemplate) return;

    // 1. Collect (name, args) from every existing method body (templates included).
    MethInsts insts;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes)
                for (auto& m : c.members)
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get()))
                        collectMethBlock(meth->body, insts);

    // 2. Generate concrete methods on each class, to a fixpoint (a generated body
    //    may itself contain a newly-discovered generic call).
    std::set<std::string> done;  // per-class "name$args" already generated; key includes class name
    bool changed = true;
    while (changed) {
        changed = false;
        for (auto& b : program.bundles)
            for (auto& ns : b.namespaces)
                for (auto& c : ns.classes) {
                    std::vector<ast::MemberPtr> generated;
                    for (auto& m : c.members) {
                        auto* meth = dynamic_cast<ast::MethodDecl*>(m.get());
                        if (meth == nullptr || meth->typeParams.empty()) continue;  // template
                        for (const MethInst& inst : insts) {
                            if (inst.first != meth->name ||
                                inst.second.size() != meth->typeParams.size())
                                continue;
                            const std::string mangled =
                                ast::mangleGeneric(meth->name, inst.second);
                            const std::string key = c.name + "::" + mangled;
                            if (done.count(key) > 0) continue;
                            done.insert(key);
                            Subst s;
                            for (std::size_t i = 0; i < inst.second.size(); ++i)
                                s[meth->typeParams[i]] = inst.second[i];
                            ast::MemberPtr cm = cloneMember(meth, s);
                            auto* cmeth = static_cast<ast::MethodDecl*>(cm.get());
                            cmeth->name = mangled;
                            cmeth->typeParams.clear();
                            collectMethBlock(cmeth->body, insts);  // transitive calls
                            generated.push_back(std::move(cm));
                            changed = true;
                        }
                    }
                    for (auto& g : generated) c.members.push_back(std::move(g));
                }
    }

    // 3. Drop the templates and rewrite all generic calls to the mangled member. Collect the
    //    declared generic method names first (templates still present) so the rewrite only mangles
    //    those -- not builtins that merely carry type args (e.g. Memory.read<int8>).
    std::set<std::string> genNames;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes)
                for (auto& m : c.members)
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get()))
                        if (!meth->typeParams.empty()) genNames.insert(meth->name);
    g_genericMethodNames = &genNames;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes) {
                std::vector<ast::MemberPtr> kept;
                for (auto& m : c.members) {
                    auto* meth = dynamic_cast<ast::MethodDecl*>(m.get());
                    if (meth != nullptr && !meth->typeParams.empty()) continue;  // template
                    kept.push_back(std::move(m));
                }
                c.members = std::move(kept);
                for (auto& m : c.members)
                    if (auto* meth = dynamic_cast<ast::MethodDecl*>(m.get()))
                        rewriteMethBlock(meth->body);
            }
    g_genericMethodNames = nullptr;
}

// Subtype check over the class hierarchy (AST-level), for constraint validation.
bool isSubtypeOf(const std::string& sub, const std::string& base,
                 const std::map<std::string, const ast::ClassDecl*>& idx) {
    if (sub == base) return true;
    auto it = idx.find(sub);
    if (it == idx.end()) return false;
    if (!it->second->superclass.empty() && isSubtypeOf(it->second->superclass, base, idx))
        return true;
    for (const auto& i : it->second->interfaces)
        if (isSubtypeOf(i, base, idx)) return true;
    return false;
}

}  // namespace

// Expands every `typealias` (spec 24) to its target type, transparently, everywhere a type
// appears -- so the analyzer and codegen only ever see concrete types. `newtype`s are left alone
// (they are distinct nominal types handled by the analyzer). Runs before qualifyNamespaces and
// monomorphize so the substituted targets are qualified and instantiated like any other type.
void resolveTypeAliases(ast::Program& program) {
    g_aliases.clear();
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& a : ns.typeAliases)
                if (!a.isNewtype) g_aliases[a.name] = a.target;
    if (g_aliases.empty()) return;

    // Resolve alias chains (typealias A = B; typealias B = int) and aliases nested in type args,
    // up to a bounded number of passes (a cycle just stops changing).
    for (int iter = 0; iter < 16; ++iter) {
        bool changed = false;
        for (auto& [name, tgt] : g_aliases) {
            if (auto it = g_aliases.find(tgt.name); it != g_aliases.end() && it->first != name) {
                const ast::TypeRef inner = it->second;
                const bool arr = tgt.isArray, ptr = tgt.isPointer, ref = tgt.isRef,
                           nul = tgt.isNullable;
                tgt = inner;
                tgt.isArray = tgt.isArray || arr;
                tgt.isPointer = tgt.isPointer || ptr;
                tgt.isRef = tgt.isRef || ref;
                tgt.isNullable = tgt.isNullable || nul;
                changed = true;
            }
            for (auto& arg : tgt.typeArgs) {
                const std::string r = resolveAliasName(arg);
                if (r != arg) { arg = r; changed = true; }
            }
        }
        if (!changed) break;
    }

    // Re-clone every class with an empty substitution: cloneClass runs substType over every
    // TypeRef it touches (fields, signatures, bodies), so aliases resolve everywhere for free.
    const Subst empty;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                ast::ClassDecl rewritten = cloneClass(c, empty, c.name);
                rewritten.typeParams = c.typeParams;  // cloneClass drops these; keep generics generic
                rewritten.typeParamVariance = c.typeParamVariance;
                rewritten.superclass = resolveAliasName(c.superclass);
                for (auto& iface : rewritten.interfaces) iface = resolveAliasName(iface);
                for (auto& a : rewritten.superclassTypeArgs) a = resolveAliasName(a);
                for (auto& argList : rewritten.interfaceTypeArgs)
                    for (auto& a : argList) a = resolveAliasName(a);
                c = std::move(rewritten);
            }
            for (auto& cst : ns.consts) cst.type = substType(cst.type, empty);
            for (auto& lit : ns.literals) {
                lit.param.type = substType(lit.param.type, empty);
                lit.returnType = substType(lit.returnType, empty);
            }
            for (auto& ex : ns.externs) {
                ex.returnType = substType(ex.returnType, empty);
                for (auto& p : ex.params) p.type = substType(p.type, empty);
            }
        }
    g_aliases.clear();  // done: later passes must not see alias rewrites
}

// Disambiguates type names that are declared in more than one namespace so that
// `app.Foo` and `lib.Foo` become distinct types (spec: namespaces scope type
// names). Each colliding declaration -- and every reference to it, resolved per
// the referring namespace's own declarations and imports -- is rewritten to a
// unique internal name (e.g. "app__Foo"). When no name collides across
// namespaces (the common case) this is a no-op, so single-namespace programs are
// untouched. Runs before monomorphize, so generic mangling sees unique names too.
void qualifyNamespaces(ast::Program& program) {
    // 1. Index each simple type name to the set of namespaces declaring it.
    std::map<std::string, std::set<std::string>> declNs;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) declNs[c.name].insert(ns.name);
            for (auto& e : ns.enums) declNs[e.name].insert(ns.name);
            for (auto& cat : ns.catalogs) declNs[cat.name].insert(ns.name);
        }
    std::set<std::string> ambiguous;
    for (auto& [name, nss] : declNs)
        if (nss.size() > 1) ambiguous.insert(name);
    // Nothing collides and no explicit `ns.Type` reference was written: leave every
    // name as-is (the common single-namespace case stays a no-op).
    if (ambiguous.empty() && !program.hasQualifiedTypeRef) return;

    auto qualified = [](const std::string& ns, const std::string& simple) {
        std::string s = ns;
        for (char& c : s) if (c == '.') c = '_';
        return s + "__" + simple;
    };

    // Explicit `ns.Type` references resolve to that namespace's concrete type name
    // (its qualified form if the simple name collides, else the simple name itself).
    Subst dotted;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces) {
            auto add = [&](const std::string& name) {
                if (ambiguous.count(name)) {
                    const std::string q = qualified(ns.name, name);
                    dotted[ns.name + "." + name] = q;
                    program.qualifiedTypes.insert(q);  // explicitly scoped: import-exempt
                } else {
                    dotted[ns.name + "." + name] = name;
                }
            };
            for (auto& c : ns.classes) add(c.name);
            for (auto& e : ns.enums) add(e.name);
            for (auto& cat : ns.catalogs) add(cat.name);
        }

    for (auto& b : program.bundles) {
        // Imported symbols of this bundle: type name -> the namespace it comes from.
        std::map<std::string, std::string> importNs;
        for (auto& imp : b.imports) {
            if (imp.path.size() < 2) continue;
            std::string nsPrefix;
            for (std::size_t i = 0; i + 1 < imp.path.size(); ++i)
                nsPrefix += (i ? "." : "") + imp.path[i];
            importNs[imp.path.back()] = nsPrefix;
        }
        for (auto& ns : b.namespaces) {
            std::set<std::string> ownNames;
            for (auto& c : ns.classes) ownNames.insert(c.name);
            for (auto& e : ns.enums) ownNames.insert(e.name);
            for (auto& cat : ns.catalogs) ownNames.insert(cat.name);
            // For each ambiguous name visible here, map it to its owning namespace's
            // unique name. Own declarations win; otherwise an import decides.
            Subst subst;
            for (const std::string& amb : ambiguous) {
                std::string owner;
                if (ownNames.count(amb) > 0)
                    owner = ns.name;
                else if (auto it = importNs.find(amb);
                         it != importNs.end() && declNs[amb].count(it->second) > 0)
                    owner = it->second;
                if (!owner.empty()) {
                    subst[amb] = qualified(owner, amb);
                    program.qualifiedTypes.insert(qualified(owner, amb));
                }
            }
            for (const auto& [k, v] : dotted) subst[k] = v;  // explicit ns.Type -> concrete name
            if (subst.empty()) continue;
            for (auto& c : ns.classes) {
                const std::string newName = subst.count(c.name) ? subst[c.name] : c.name;
                ast::ClassDecl rewritten = cloneClass(c, subst, newName);
                rewritten.typeParams = c.typeParams;  // cloneClass drops these; keep generics generic
                rewritten.typeParamVariance = c.typeParamVariance;
                // cloneClass does not run these name fields through the subst:
                if (auto it = subst.find(rewritten.superclass); it != subst.end())
                    rewritten.superclass = it->second;
                for (auto& iface : rewritten.interfaces)
                    if (auto it = subst.find(iface); it != subst.end()) iface = it->second;
                for (auto& p : rewritten.permits)
                    if (auto it = subst.find(p); it != subst.end()) p = it->second;
                c = std::move(rewritten);
            }
            for (auto& e : ns.enums) {
                if (subst.count(e.name) > 0) e.name = subst[e.name];
                for (auto& cat : e.extendsCatalogs)
                    if (auto it = subst.find(cat); it != subst.end()) cat = it->second;
            }
            for (auto& cat : ns.catalogs) {
                if (subst.count(cat.name) > 0) cat.name = subst[cat.name];
                for (auto& parent : cat.extendsCatalogs)
                    if (auto it = subst.find(parent); it != subst.end()) parent = it->second;
            }
        }
    }
}

bool monomorphize(ast::Program& program) {
    // Index generic templates by name.
    std::map<std::string, const ast::ClassDecl*> templates;
    std::set<std::string> generics;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes)
                if (!c.typeParams.empty()) {
                    templates[c.name] = &c;
                    generics.insert(c.name);
                    // Record variance (spec 15.3) before the template is dropped, so the
                    // analyzer can apply variance subtyping to the concrete instantiations.
                    if (!c.typeParamVariance.empty())
                        program.genericVariance[c.name] = c.typeParamVariance;
                }
    // Every generic type-parameter name (T, K, V, ...). An "instantiation" whose argument is one
    // of these is bogus: it comes from a template referring to itself with its own parameter (e.g.
    // `Node<T>* next` inside `Node<T>`, or `new Node<T>()` in its own body). Such pseudo-instances
    // must never be generated -- doing so produced a class with an undefined type and crashed.
    std::set<std::string> typeParamNames;
    for (const auto& [tname, tpl] : templates)
        for (const auto& tp : tpl->typeParams) typeParamNames.insert(tp);

    // No generic classes: still expand any generic methods, then done.
    if (templates.empty()) {
        expandGenericMethods(program);
        return true;
    }

    // Index every class by name for constraint subtype checks.
    std::map<std::string, const ast::ClassDecl*> classIndex;
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes) classIndex[c.name] = &c;
    bool ok = true;

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
        // Skip a template's self-reference with its own type parameter (e.g. Node$T from a
        // `Node<T>* next` field) -- it is not a real instantiation (see typeParamNames).
        bool selfParam = false;
        for (const auto& a : args)
            if (typeParamNames.count(a) > 0) selfParam = true;
        if (selfParam) continue;
        auto tit = templates.find(base);
        if (tit == templates.end() || tit->second->typeParams.size() != args.size()) continue;
        // Constraints (spec 15.2): each type argument must satisfy its bound.
        for (const auto& pb : tit->second->typeParamBounds) {
            std::size_t pi = 0;
            while (pi < tit->second->typeParams.size() && tit->second->typeParams[pi] != pb.first)
                ++pi;
            if (pi >= args.size()) continue;
            if (!isSubtypeOf(args[pi], pb.second, classIndex)) {
                const auto& loc = tit->second->loc;
                std::fprintf(stderr,
                             "%s:%d:%d: error: type argument '%s' does not satisfy constraint "
                             "'%s extends %s' in '%s'\n",
                             std::string(loc.file).c_str(), loc.line, loc.col, args[pi].c_str(),
                             pb.first.c_str(), pb.second.c_str(), m.c_str());
                ok = false;
            }
        }
        Subst s;
        for (std::size_t i = 0; i < args.size(); ++i) s[tit->second->typeParams[i]] = args[i];
        ast::ClassDecl concrete = cloneClass(*tit->second, s, m);
        // A generic base (`extends Base<T>`) is itself an instantiation to generate.
        if (!concrete.superclassTypeArgs.empty() && generics.count(concrete.superclass) > 0) {
            const std::string sm =
                ast::mangleGeneric(concrete.superclass, concrete.superclassTypeArgs);
            if (insts.find(sm) == insts.end())
                insts[sm] = {concrete.superclass, concrete.superclassTypeArgs};
            if (done.count(sm) == 0) work.push_back(sm);
        }
        // A generic sealed base seeds its permitted subclasses with the same args, so the variants
        // (e.g. Ok$int$int / Err$int$int for Result$int$int) exist for match and construction.
        for (const std::string& p : tit->second->permits) {
            if (generics.count(p) == 0) continue;
            const std::string pm = ast::mangleGeneric(p, args);
            if (insts.find(pm) == insts.end()) insts[pm] = {p, args};
            if (done.count(pm) == 0) work.push_back(pm);
        }
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
    // Mangle generic superclasses now that every concrete class exists (Derived$int
    // extends Base$int). Applies to generated and plain classes alike.
    for (auto& b : program.bundles)
        for (auto& ns : b.namespaces)
            for (auto& c : ns.classes) {
                if (!c.superclassTypeArgs.empty())
                    c.superclass = ast::mangleGeneric(c.superclass, c.superclassTypeArgs);
                // `implements Iface<Args>` now refers to the concrete instantiation.
                for (std::size_t k = 0;
                     k < c.interfaceTypeArgs.size() && k < c.interfaces.size(); ++k)
                    if (!c.interfaceTypeArgs[k].empty())
                        c.interfaces[k] =
                            ast::mangleGeneric(c.interfaces[k], c.interfaceTypeArgs[k]);
            }
    // Generic methods live on both plain and monomorphized classes; expand them
    // now that every concrete class (and its cloned bodies) exists.
    expandGenericMethods(program);
    return ok;
}

}  // namespace ldp3
