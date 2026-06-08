#pragma once

#include <memory>
#include <string>
#include <vector>

#include "lexer/token.h"

// Abstract syntax tree for the Release 0.1 subset. Nodes carry a
// SourceLocation and know how to dump themselves as an indented tree
// (see --dump-ast). The shape grows phase by phase; for now it covers the
// program/bundle/namespace/class/method hierarchy plus the expression
// statements the hello-world walking skeleton needs.
namespace ldp3::ast {

// A type reference, e.g. `void`, `int`, `string[]`, or a class name.
struct TypeRef {
    std::string name;
    bool isArray = false;
    SourceLocation loc;
};

// ---- Expressions ----
struct Expr {
    SourceLocation loc;
    virtual ~Expr() = default;
    virtual void dump(std::string& out, int indent) const = 0;
};
using ExprPtr = std::unique_ptr<Expr>;

struct IdentifierExpr : Expr {
    std::string name;
    void dump(std::string& out, int indent) const override;
};

struct IntLiteralExpr : Expr {
    std::string text;  // raw lexeme; parsed to a value in a later phase
    void dump(std::string& out, int indent) const override;
};

struct StringLiteralExpr : Expr {
    std::string value;  // raw content; escapes resolved in a later phase
    void dump(std::string& out, int indent) const override;
};

struct CharLiteralExpr : Expr {
    std::string value;
    void dump(std::string& out, int indent) const override;
};

struct BoolLiteralExpr : Expr {
    bool value = false;
    void dump(std::string& out, int indent) const override;
};

struct MemberExpr : Expr {
    ExprPtr object;
    std::string member;
    void dump(std::string& out, int indent) const override;
};

struct CallExpr : Expr {
    ExprPtr callee;
    std::vector<ExprPtr> args;
    void dump(std::string& out, int indent) const override;
};

struct BinaryExpr : Expr {
    std::string op;  // "+", "-", "*", "/", "%"
    ExprPtr lhs;
    ExprPtr rhs;
    void dump(std::string& out, int indent) const override;
};

struct UnaryExpr : Expr {
    std::string op;  // "-"
    ExprPtr operand;
    void dump(std::string& out, int indent) const override;
};

// ---- Statements ----
struct Stmt {
    SourceLocation loc;
    virtual ~Stmt() = default;
    virtual void dump(std::string& out, int indent) const = 0;
};
using StmtPtr = std::unique_ptr<Stmt>;

struct ExprStmt : Stmt {
    ExprPtr expr;
    void dump(std::string& out, int indent) const override;
};

struct ReturnStmt : Stmt {
    ExprPtr value;  // null for a bare `return;`
    void dump(std::string& out, int indent) const override;
};

struct VarDeclStmt : Stmt {
    bool isMutable = false;
    bool isVar = false;  // `var` type inference; `type` then unused
    TypeRef type;        // used when !isVar
    std::string name;
    ExprPtr init;        // M2: an initializer is required
    void dump(std::string& out, int indent) const override;
};

struct Block {
    std::vector<StmtPtr> statements;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// ---- Declarations ----
struct Param {
    TypeRef type;
    std::string name;
    SourceLocation loc;
};

// Base for class-body members (method now; field/constructor/destructor later).
struct MemberDecl {
    SourceLocation loc;
    virtual ~MemberDecl() = default;
    virtual void dump(std::string& out, int indent) const = 0;
};
using MemberPtr = std::unique_ptr<MemberDecl>;

struct MethodDecl : MemberDecl {
    std::string visibility;  // "" when none
    bool isStatic = false;
    std::string name;
    std::vector<Param> params;
    TypeRef returnType;
    Block body;
    void dump(std::string& out, int indent) const override;
};

struct ClassDecl {
    std::string visibility;
    std::string name;
    std::vector<MemberPtr> members;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct Namespace {
    std::string visibility;
    std::string name;
    std::vector<ClassDecl> classes;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct Bundle {
    std::string visibility;
    std::string name;
    std::vector<Namespace> namespaces;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct Program {
    std::string name;
    std::vector<Bundle> bundles;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

}  // namespace ldp3::ast
