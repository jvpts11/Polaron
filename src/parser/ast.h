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

// A type reference, e.g. `void`, `int`, `string[]`, `Dog*`, or a class name.
// Pointer (`T*`) and reference (`T&`) both mean "share the object" (opt-out of
// the default value/copy semantics); the distinction is refined later.
struct TypeRef {
    std::string name;
    bool isArray = false;
    bool isPointer = false;  // T*
    bool isRef = false;      // T&
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

struct NewExpr : Expr {
    std::string className;
    std::vector<ExprPtr> args;
    std::string location;  // "stack" or "heap"
    void dump(std::string& out, int indent) const override;
};

// `move x` -- transfers ownership; the source variable becomes invalid.
struct MoveExpr : Expr {
    ExprPtr operand;
    void dump(std::string& out, int indent) const override;
};

// new T[size]() -- a dynamic, zero-initialized array on the heap.
struct NewArrayExpr : Expr {
    std::string elementType;  // e.g. "int", "char"
    ExprPtr size;
    std::string location;  // "stack" or "heap" (arrays default to heap)
    void dump(std::string& out, int indent) const override;
};

// array[index] -- element access (readable and assignable).
struct IndexExpr : Expr {
    ExprPtr array;
    ExprPtr index;
    void dump(std::string& out, int indent) const override;
};

// $"lit0 {expr0} lit1 {expr1} ... litN" -- string interpolation. There are
// N+1 literal chunks interleaved with N expressions. Release 0.1: valid only
// as a System.IO.printf/println argument (lowered to a format string + args).
struct InterpStringExpr : Expr {
    std::vector<std::string> literals;  // N+1 chunks (escapes unresolved)
    std::vector<ExprPtr> exprs;         // N embedded expressions
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

struct DeleteStmt : Stmt {
    ExprPtr target;  // a heap object or array to free
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

struct AssignStmt : Stmt {
    ExprPtr target;  // lvalue: a variable or member access (this.field / obj.field)
    ExprPtr value;
    void dump(std::string& out, int indent) const override;
};

struct IncDecStmt : Stmt {
    ExprPtr target;  // lvalue
    bool isIncrement = true;  // ++ vs --
    void dump(std::string& out, int indent) const override;
};

struct Block {
    std::vector<StmtPtr> statements;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct IfStmt : Stmt {
    ExprPtr cond;
    Block thenBlock;
    std::unique_ptr<Block> elseBlock;  // null when there is no else
    void dump(std::string& out, int indent) const override;
};

struct WhileStmt : Stmt {
    ExprPtr cond;
    Block body;
    void dump(std::string& out, int indent) const override;
};

struct ForStmt : Stmt {
    StmtPtr init;    // variable declaration or assignment (may be null)
    ExprPtr cond;
    StmtPtr update;  // assignment or increment/decrement (may be null)
    Block body;
    void dump(std::string& out, int indent) const override;
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
    bool isAbstract = false;  // no body; must be overridden
    bool isOverride = false;  // overrides an inherited/interface method
    bool isFinal = false;     // cannot be overridden
    std::string name;
    std::vector<Param> params;
    TypeRef returnType;
    Block body;  // empty when isAbstract
    void dump(std::string& out, int indent) const override;
};

struct FieldDecl : MemberDecl {
    std::string visibility;
    bool isStatic = false;
    bool isMutable = false;
    TypeRef type;
    std::string name;
    ExprPtr init;  // optional inline initializer (null if none); see spec 940
    void dump(std::string& out, int indent) const override;
};

struct ConstructorDecl : MemberDecl {
    std::string visibility;
    std::vector<Param> params;
    Block body;
    void dump(std::string& out, int indent) const override;
};

struct DestructorDecl : MemberDecl {
    std::string visibility;
    Block body;  // a destructor takes no parameters and returns void
    void dump(std::string& out, int indent) const override;
};

struct ClassDecl {
    std::string visibility;
    std::string name;
    bool isInterface = false;             // declared with `interface`
    bool isAbstract = false;              // `abstract class` (interfaces are abstract too)
    bool isMovable = false;               // `movable class` -- move discipline
    bool isUnique = false;                // `unique class` -- single live reference
    std::string superclass;               // "" when none (from `extends`)
    std::vector<std::string> interfaces;  // from `implements`
    std::vector<MemberPtr> members;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// A simple (int-style) enum: a named set of constants. Java-style enums (with
// fields, constructors and methods) come once float/double land.
struct EnumDecl {
    std::string visibility;
    std::string name;
    std::vector<std::string> constants;  // in declaration order; ordinal = index
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct Namespace {
    std::string visibility;
    std::string name;
    std::vector<ClassDecl> classes;
    std::vector<EnumDecl> enums;
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
