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

// Mangled name of a generic instantiation: Box<int> -> "Box$int",
// Pair<int, double> -> "Pair$int$double". No args returns the base unchanged.
inline std::string mangleGeneric(const std::string& base, const std::vector<std::string>& args) {
    std::string s = base;
    for (const std::string& a : args) s += "$" + a;
    return s;
}

// A type reference, e.g. `void`, `int`, `string[]`, `Dog*`, or a class name.
// Pointer (`T*`) and reference (`T&`) both mean "share the object" (opt-out of
// the default value/copy semantics); the distinction is refined later.
struct TypeRef {
    std::string name;
    bool isArray = false;
    bool isPointer = false;  // T*
    bool isRef = false;      // T&
    std::vector<std::string> typeArgs;  // generic arguments, e.g. Box<int> -> ["int"]
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

struct FloatLiteralExpr : Expr {
    std::string text;  // raw lexeme, e.g. "3.14" or "2.0f"
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
    bool fromSuffix = false;  // formed from `N suffix` (spec 17.10); requires import
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
    std::vector<std::string> typeArgs;  // generic arguments: new Box<int>(...)
    std::vector<ExprPtr> args;
    std::string location;  // "stack" or "heap"
    std::string region;    // "in region R" target; empty when none
    void dump(std::string& out, int indent) const override;
};

// `move x` -- transfers ownership; the source variable becomes invalid.
struct MoveExpr : Expr {
    ExprPtr operand;
    void dump(std::string& out, int indent) const override;
};

// Region initializer: `itself.allocate(size)` with optional `.accepts({...})` /
// `.rejects({...})` type constraints (spec 17.2-17.3). Constraints are checked
// at compile time; the runtime exception form arrives with exceptions (F6).
struct RegionInitExpr : Expr {
    ExprPtr size;                      // the allocate(...) byte size
    std::vector<std::string> accepts;  // empty = accepts anything
    std::vector<std::string> rejects;
    void dump(std::string& out, int indent) const override;
};

// cast<T>(expr) -- explicit conversion. Release 0.1 handles numeric casts
// (int<->int of any width, int<->float); class casts arrive with exceptions.
struct CastExpr : Expr {
    std::string targetType;  // simple type name, e.g. "int", "int64", "float"
    ExprPtr operand;
    void dump(std::string& out, int indent) const override;
};

// `super` -- only valid as `super(args)`, the first statement of a constructor,
// to pass arguments to the base-class constructor (spec 8; super() is implicit).
struct SuperExpr : Expr {
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

// `release region R;` -- frees a region and everything allocated in it (spec 17.7).
struct ReleaseStmt : Stmt {
    std::string region;
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

// defer { ... } -- runs at the end of the enclosing method (LIFO).
struct DeferStmt : Stmt {
    Block body;
    void dump(std::string& out, int indent) const override;
};

// using (T x = ...) { ... } -- x is disposed automatically at the block's end.
struct UsingStmt : Stmt {
    StmtPtr decl;  // a VarDeclStmt
    std::string varName;
    Block body;
    void dump(std::string& out, int indent) const override;
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

// One arm of a match: `case Type(t1 b1, ...) { body }` (spec 16). The bindings
// are positional -- they bind the case type's own fields, in declaration order.
struct MatchCase {
    std::string typeName;
    std::vector<Param> bindings;
    Block body;          // statement form: the case body
    ExprPtr result;      // expression form (`-> expr`); null in the statement form
    SourceLocation loc;
};

// match (subject) { case ... } -- dynamic type dispatch with destructuring.
struct MatchStmt : Stmt {
    ExprPtr subject;
    std::vector<MatchCase> cases;
    std::unique_ptr<Block> defaultBody;  // null when absent
    void dump(std::string& out, int indent) const override;
};

// switch (x) { case C { ... } ... default { ... } } -- C-style fall-through (spec 7.3).
struct SwitchCase {
    ExprPtr value;
    Block body;
    SourceLocation loc;
};
struct SwitchStmt : Stmt {
    ExprPtr subject;
    std::vector<SwitchCase> cases;
    std::unique_ptr<Block> defaultBody;  // null when absent
    void dump(std::string& out, int indent) const override;
};

// match (subject) { case T(..) -> expr; ... } as an expression (spec 16.2):
// every arm yields one value via `->`; the whole match evaluates to that value.
struct MatchExpr : Expr {
    ExprPtr subject;
    std::vector<MatchCase> cases;     // each arm uses `result`; `body` stays empty
    ExprPtr defaultResult;            // `default -> expr;`; null when absent
    mutable std::string resultType;   // value type; computed by sema, read by codegen
    void dump(std::string& out, int indent) const override;
};

// static_assert(cond, "message"); -- compile-time assertion (spec 28.2). The
// condition must be a constant expression; checked by the analyzer, emits no code.
struct StaticAssertStmt : Stmt {
    ExprPtr condition;
    std::string message;
    void dump(std::string& out, int indent) const override;
};

// break; / continue; -- loop control (spec 7). Labeled forms are a later refinement.
struct BreakStmt : Stmt {
    void dump(std::string& out, int indent) const override;
};
struct ContinueStmt : Stmt {
    void dump(std::string& out, int indent) const override;
};

// for (T v in array) { ... } -- foreach over an array (spec 7). Ranges and the
// `index i, T v` form are later refinements.
struct ForeachStmt : Stmt {
    TypeRef elemType;
    std::string varName;
    ExprPtr iterable;
    Block body;
    void dump(std::string& out, int indent) const override;
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
    bool isProperty = false;  // computed get-only property: read as obj.name (no parens)
    std::string name;
    std::vector<Param> params;
    TypeRef returnType;
    Block body;  // empty when isAbstract
    std::vector<ExprPtr> requiresClauses;  // contracts (spec 29): preconditions
    std::vector<ExprPtr> ensuresClauses;   // contracts (spec 29): postconditions
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
    std::vector<ExprPtr> requiresClauses;  // contracts (spec 29): preconditions
    std::vector<ExprPtr> ensuresClauses;   // contracts (spec 29): postconditions
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
    std::vector<std::string> typeParams;  // generic parameters, e.g. Box<T> -> ["T"]
    // Constraint per type param, if any: (param, bound) from `<T extends X>` / `<T implements I>`.
    std::vector<std::pair<std::string, std::string>> typeParamBounds;
    bool isInterface = false;             // declared with `interface`
    bool isStruct = false;                // declared with `struct` -- value type, no inheritance
    bool isRecord = false;                // declared with `record` -- immutable value type
    bool isUnion = false;                 // declared with `union` -- fields share one storage
    bool isAbstract = false;              // `abstract class` (interfaces are abstract too)
    bool isSealed = false;                // `sealed` -- only `permits` types may extend it
    bool isMovable = false;               // `movable class` -- move discipline
    bool isUnique = false;                // `unique class` -- single live reference
    std::string superclass;               // "" when none (from `extends`)
    std::vector<std::string> interfaces;  // from `implements`
    std::vector<std::string> permits;     // sealed permits list (subtypes)
    std::vector<ExprPtr> invariants;      // class invariants (spec 29), checked per method
    std::vector<MemberPtr> members;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// An enum. Int-style (`RED, GREEN`) uses only `constants` (ordinal = index).
// Java-style (spec 12.2) adds per-constant constructor args, plus fields,
// a constructor and methods in `members`; each constant is a singleton instance.
struct EnumDecl {
    std::string visibility;
    std::string name;
    std::vector<std::string> constants;            // names, in declaration order
    std::vector<std::vector<ExprPtr>> constantArgs;  // java-style: ctor args, parallel to constants
    std::vector<MemberPtr> members;                // java-style: fields/constructor/methods
    bool isJavaStyle = false;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// A `comptime literal` suffix function at namespace level (spec 17.10):
// `comptime literal name(T param) returns R { body }`, used as `64 kilobytes`.
// This is the one namespace-level function form (OOP is mandatory otherwise).
struct LiteralDecl {
    std::string visibility;
    bool isComptime = false;  // spec requires `comptime`; semantics enforces it
    std::string name;
    Param param;              // exactly one parameter
    TypeRef returnType;
    Block body;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct Namespace {
    std::string visibility;
    std::string name;
    std::vector<ClassDecl> classes;
    std::vector<EnumDecl> enums;
    std::vector<LiteralDecl> literals;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// `import a.b.c;` -- brings a symbol (last component) into scope. Required to
// enable a literal's `N suffix` syntax (spec 17.10 rule 5).
struct ImportDecl {
    std::vector<std::string> path;  // e.g. ["System","Memory","Units","kilobytes"]
    SourceLocation loc;
};

struct Bundle {
    std::string visibility;
    std::string name;
    std::vector<ImportDecl> imports;
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
