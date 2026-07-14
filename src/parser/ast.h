#pragma once

#include <map>
#include <memory>
#include <set>
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
    for (const std::string& a : args) {
        // Encode an array type-argument ("int[]") so it does not leave the mangled name ending in
        // "[]": otherwise isArrayType would misclassify the whole instantiation as an array, and
        // Box<int[]> would collide with the array type Box<int>[] (both would be "Box$int[]"). The
        // token has no '$' (so the base-name split on the first '$' still works) and no trailing
        // brackets. The real "int[]" argument is still used for type substitution; only the name changes.
        std::string enc = a;
        for (std::size_t p = enc.find("[]"); p != std::string::npos; p = enc.find("[]", p))
            enc.replace(p, 2, "~arr");
        s += "$" + enc;
    }
    return s;
}

// A type reference, e.g. `void`, `int`, `string[]`, `Dog*`, or a class name.
// Pointer (`T*`) and reference (`T&`) both mean "share the object" (opt-out of
// the default value/copy semantics); the distinction is refined later.
struct TypeRef {
    std::string name;
    bool isArray = false;     // any array (arrayDims >= 1); kept for "is it an array" checks
    int arrayDims = 0;        // number of `[]` (1 = T[], 2 = T[][], ...) -- 0 when not an array
    bool isPointer = false;  // T*
    bool isRef = false;      // T&
    bool isNullable = false;  // `nullable T` (spec 3.7): may hold null; canonical form is "T?"
    bool isMove = false;      // `move T` (spec 19.6): ownership-transfer param/return; transparent
                              // to the canonical type (same type, transferred rather than copied)
    std::vector<std::string> typeArgs;  // generic arguments, e.g. Box<int> -> ["int"]
    SourceLocation loc;
};

// The `[]...[]` suffix for `dims` array dimensions (e.g. 2 -> "[][]").
inline std::string arrayDimsSuffix(int dims) {
    std::string s;
    for (int i = 0; i < dims; ++i) s += "[]";
    return s;
}

// Canonical type string of a TypeRef, matching the form sema/codegen key on:
// generic args mangled into the name, then [] / * / & markers (e.g. "Box$int*", "int[][]").
// A tuple type already carries its full spelling in `name` (e.g. "(int,int)").
inline std::string canonicalType(const TypeRef& t) {
    return mangleGeneric(t.name, t.typeArgs) + arrayDimsSuffix(t.arrayDims) +
           (t.isPointer ? "*" : "") + (t.isRef ? "&" : "") + (t.isNullable ? "?" : "");
}

// ---- Expressions ----
struct Block;  // defined below; referenced by block-bearing expressions (spec 30.18)
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
    bool isDecimal = false;  // an `m`-suffixed literal: the fixed-point Decimal primitive (spec 34)
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

struct NullLiteralExpr : Expr {  // the `null` pointer literal
    void dump(std::string& out, int /*indent*/) const override { out += "null"; }
};

struct MemberExpr : Expr {
    ExprPtr object;
    std::string member;
    bool safe = false;  // `obj?.member` (spec 3.7): yields null when obj is null instead of trapping
    void dump(std::string& out, int indent) const override;
};

// `a ?? b` (spec 3.7): null-coalescing -- evaluates to `a` if non-null, else `b`. `b` is only
// evaluated when `a` is null. The result is non-null when `b` is non-null.
struct NullCoalesceExpr : Expr {
    ExprPtr lhs;
    ExprPtr rhs;
    void dump(std::string& out, int /*indent*/) const override { out += "??"; }
};

// `old(expr)` inside an `ensures` contract clause (spec 29): the value of `expr` captured at method
// entry, compared against the final state at exit. Only valid inside an ensures clause.
struct OldExpr : Expr {
    ExprPtr inner;
    void dump(std::string& out, int /*indent*/) const override { out += "old"; }
};

struct CallExpr : Expr {
    ExprPtr callee;
    std::vector<ExprPtr> args;
    // Named arguments (spec 22.4): `configure(5, duration: 2, repeat: false)`. Parallel to `args` -- an
    // empty string means the argument was passed positionally. Semantic analysis reorders `args` into the
    // parameter order and then clears these, so codegen only ever sees positional arguments.
    std::vector<std::string> argNames;
    bool argsBound = false;  // set once the analyzer has bound/validated the arguments (it may revisit a call)
    std::vector<std::string> typeArgs;  // generic method call: obj.identity<int>(x) -> ["int"]
    bool fromSuffix = false;  // formed from `N suffix` (spec 17.10); requires import
    void dump(std::string& out, int indent) const override;
};

struct BinaryExpr : Expr {
    std::string op;  // "+", "-", "*", "/", "%"
    ExprPtr lhs;
    ExprPtr rhs;
    void dump(std::string& out, int indent) const override;
};

// cond ? a : b -- conditional expression (spec 6).
struct TernaryExpr : Expr {
    ExprPtr cond;
    ExprPtr thenExpr;
    ExprPtr elseExpr;
    void dump(std::string& out, int indent) const override;
};

struct UnaryExpr : Expr {
    std::string op;  // "-"
    ExprPtr operand;
    void dump(std::string& out, int indent) const override;
};

// await expr (spec 20.2): suspends the enclosing async method until the awaited Task<T>
// completes, then yields its T. In a non-async context it blocks until the task is done.
struct AwaitExpr : Expr {
    ExprPtr operand;
    void dump(std::string& out, int indent) const override;
};

// `unimport X expecting [using a, b] { ... return v; }` (spec 30.18): runs the expecting block in
// the old code (before the class is unloaded) to produce a validation value, then unimports X. The
// expression evaluates to that value, which a later reimport compares against bit-for-bit.
struct UnimportExpr : Expr {
    std::string target;
    std::vector<std::string> usingVars;
    std::unique_ptr<Block> expecting;
    void dump(std::string& out, int /*indent*/) const override { out += "unimport " + target; }
};

// `start..end`, `start..=end`, optionally `step k` (spec 7.5): an integer range, used to drive a
// `for (int i in 0..10)` loop. `inclusive` selects `..=` (end included).
struct RangeExpr : Expr {
    ExprPtr start;
    ExprPtr end;
    ExprPtr step;          // null when no `step`
    bool inclusive = false;
    void dump(std::string& out, int /*indent*/) const override { out += "range"; }
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
    std::string castType;  // `move x as T` (spec 19.3): transfer + reinterpret (e.g. movable->unique)
    std::string fromRegion;  // `move x from region R0` (spec 19.3): the source region (informational)
    std::string toRegion;    // `move x into/to region R`: relocate the object into region R
    int persistMode = 0;     // 0 = carrying (default), 1 = leaving, 2 = releasing persistents
    void dump(std::string& out, int indent) const override;
};

// `try? expr` -- if expr is Ok/Some, yields its value; if Err/None, early-returns it (propagates)
// to the enclosing method's Result/Option (spec 21.2).
struct TryExpr : Expr {
    ExprPtr operand;
    void dump(std::string& out, int /*indent*/) const override { out += "try?"; }
};

// Region initializer: `itself.allocate(size)` with optional `.accepts({...})` /
// `.rejects({...})` type constraints (spec 17.2-17.3). Constraints are checked
// at compile time; the runtime exception form arrives with exceptions (F6).
struct RegionInitExpr : Expr {
    ExprPtr size;                      // the allocate(...) / at(...) byte size
    ExprPtr atAddress;                 // itself.at(addr, size): a region over fixed memory (null = allocate)
    std::vector<std::string> accepts;  // empty = accepts anything
    std::vector<std::string> rejects;
    // itself.atMultiple({ addr accepts {T}, addr rejects {T}, ... }) (spec 17.4): a region over several
    // fixed address ranges, each with its own accepts/rejects. `new T in R` routes to the matching range.
    struct Range {
        ExprPtr address;
        std::vector<std::string> accepts;
        std::vector<std::string> rejects;
    };
    std::vector<Range> ranges;         // non-empty => atMultiple
    void dump(std::string& out, int indent) const override;
};

// cast<T>(expr) -- explicit conversion. Release 0.1 handles numeric casts
// (int<->int of any width, int<->float); class casts arrive with exceptions.
// Also carries the postfix type operators `x is T` / `x as T` / `x as? T` (spec 6.4) via `op`:
// 0 = cast<T>/`as T` (checked conversion, throws on a bad class downcast); 1 = `is` (boolean test);
// 2 = `as?` (nullable: the value if it is a T, else null).
struct CastExpr : Expr {
    std::string targetType;  // simple type name, e.g. "int", "int64", "float"
    ExprPtr operand;
    int op = 0;  // 0 = cast/as, 1 = is, 2 = as?
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
    // Set by the bounds-check hoisting pass on accesses it has proven in-range for the whole loop
    // (the pass emits one guard covering exactly these, then runs an unchecked copy of the loop). The
    // codegen skips the per-access bounds check when true. Off by default -- every access is checked.
    bool unchecked = false;
    void dump(std::string& out, int indent) const override;
};

// `[a, b, c]` -- an array literal (spec 25). Elements may themselves be array literals (nested,
// for a multi-dimensional array). The element type is inferred from the first element.
struct ArrayLiteralExpr : Expr {
    std::vector<ExprPtr> elements;
    void dump(std::string& out, int /*indent*/) const override { out += "[...]"; }
};

// $"lit0 {expr0} lit1 {expr1} ... litN" -- string interpolation. There are
// N+1 literal chunks interleaved with N expressions. Release 0.1: valid only
// as a System.IO.printf/println argument (lowered to a format string + args).
struct InterpStringExpr : Expr {
    std::vector<std::string> literals;  // N+1 chunks (escapes unresolved)
    std::vector<ExprPtr> exprs;         // N embedded expressions
    // spec 4.1: an optional format specifier per expression -- `$"pi = {pi:0.00}"` -> formats[i] = "0.00".
    // "" means "default formatting". A specifier of zeros/hashes after a dot fixes the decimal places.
    std::vector<std::string> formats;
    void dump(std::string& out, int indent) const override;
};

// (e0, e1, ...) -- a tuple literal (spec 22.5). Lowered to an anonymous LLVM
// struct value; chiefly used to return several values from a method at once.
struct TupleExpr : Expr {
    std::vector<ExprPtr> elements;  // two or more components
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

// `yield expr;` (spec 16.2): inside a match-expression block arm, supplies the arm's value.
struct YieldStmt : Stmt {
    ExprPtr value;
    void dump(std::string& out, int /*indent*/) const override { out += "yield"; }
};

// `asm("arch") { raw }` (spec issue 1): inline assembly. `body` is the verbatim text between braces.
struct AsmStmt : Stmt {
    std::string arch;
    std::string body;
    void dump(std::string& out, int /*indent*/) const override { out += "asm"; }
};

// Optional `cascade(...)` parameters (spec 37.1): a propagation-depth limit and type filters.
// depth == -1 means unlimited. onlyTypes (from `types: {...}`) restricts propagation to the
// listed types; exceptTypes (from `except: {...}`) skips the listed types.
struct CascadeParams {
    int depth = -1;
    std::vector<std::string> onlyTypes;
    std::vector<std::string> exceptTypes;
};

struct DeleteStmt : Stmt {
    ExprPtr target;  // a heap object or array to free
    std::vector<ExprPtr> moreTargets;  // `delete a, b, c;` deletes each; modifiers apply to all
    bool isCascade = false;  // `cascade delete` (spec 37.1): also delete owned member objects
    CascadeParams cascade;   // propagation limits, when isCascade
    std::string fromRegion;  // `delete X from region R` (spec 17.7): run the dtor; region owns memory
    bool fromHeap = false;   // `delete X from heap` (spec 12.x): explicit heap free (same as delete)
    void dump(std::string& out, int indent) const override;
};

// `release region R;` frees a region (spec 17.7). `release persistent obj.field;`
// (and `release eternal obj.field;`) frees a persistent and satisfies the
// non-eternal-persistent release obligation (spec 18.15).
struct ReleaseStmt : Stmt {
    std::string region;       // set for `release region R`
    bool isPersistent = false;  // set for `release [persistent|eternal] <expr>`
    ExprPtr target;           // the persistent lvalue (obj.field), when isPersistent
    void dump(std::string& out, int indent) const override;
};

// `unimport X;` / `reimport X;` (spec 30): logically remove a class at runtime (and
// physically overwrite its code), or re-enable it.
struct UnimportStmt : Stmt {
    std::string target;          // the type / namespace / bundle name
    bool isReimport = false;     // `reimport` re-enables; `unimport` removes
    int granularity = 0;         // spec 30.1: 0 = individual type, 1 = namespace, 2 = bundle
    void dump(std::string& out, int /*indent*/) const override {
        out += (isReimport ? "reimport " : "unimport ") + target;
    }
};

// `import X expecting a [using ...] { ... return v; } onFailure { ... };` (spec 30.18): reimport X,
// run the expecting block in the new code, compare its value bit-for-bit with `expected` (the value
// a prior `unimport expecting` produced); on mismatch run the onFailure block. There is no default
// failure behaviour, so onFailure is mandatory.
struct ReimportValidateStmt : Stmt {
    std::string target;
    ExprPtr expected;                       // the validation value from the unimport side
    std::vector<std::string> usingVars;
    std::unique_ptr<Block> expecting;
    std::unique_ptr<Block> onFailure;
    void dump(std::string& out, int /*indent*/) const override {
        out += "import " + target + " expecting";
    }
};

// `cascade move tree from region A to region B [leaving persistents];` (spec 19.8):
// moves an object and the graph it owns from one region to another.
struct CascadeMoveStmt : Stmt {
    ExprPtr target;            // the object (an lvalue) to move
    std::string fromRegion;
    std::string toRegion;
    bool leavingPersistents = false;
    void dump(std::string& out, int indent) const override;
};

// `cascade <op> ...` for the operations other than delete/move (spec 37.1): an operation
// propagated through the object's owned graph. Println describes each node, Validate checks each
// node's invariant, Clone deep-copies the whole graph, Unimport removes a class and its subtypes.
enum class CascadeOpKind { Println, Validate, Clone, Unimport, Release };
struct CascadeStmt : Stmt {
    CascadeOpKind op = CascadeOpKind::Println;
    ExprPtr target;        // root object (Println/Validate/Clone); null for Unimport
    ExprPtr dest;          // `clone X into <dest>`
    std::string typeName;  // `unimport <Name>`
    CascadeParams params;
    void dump(std::string& out, int /*indent*/) const override { out += "cascade"; }
};

struct VarDeclStmt : Stmt {
    bool isMutable = false;
    bool isVar = false;  // `var` type inference; `type` then unused
    bool isPersistent = false;  // spec 18: disk-backed local, retained across calls/runs
    bool isEternal = false;     // eternal persistent
    bool isVolatile = false;    // spec 37.5: loads/stores are never optimized away
    bool isLazy = false;        // spec 37.3: initializer runs on first access, not here
    bool isComptime = false;    // spec 28.3: `comptime` local -- value computed at compile time
    TypeRef type;        // used when !isVar
    std::string name;
    ExprPtr init;        // M2: an initializer is required
    void dump(std::string& out, int indent) const override;
};

// (T0 x0, T1 x1, ...) = expr; -- destructures a tuple into fresh locals
// (spec 22.5). Each binding declares one local from the matching component.
struct TupleBinding {
    TypeRef type;
    std::string name;
};
struct TupleDeclStmt : Stmt {
    std::vector<TupleBinding> bindings;  // two or more, left to right
    ExprPtr init;
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
    // spec 32.10: `defer within milliseconds(100) { ... }` -- a soft deadline for the cleanup. Null when
    // the plain `defer` form was used. The expression is a Duration (or a millisecond count).
    ExprPtr within;
    void dump(std::string& out, int indent) const override;
};

// using (T x = ...) { ... } -- x is disposed automatically at the block's end.
struct UsingStmt : Stmt {
    StmtPtr decl;  // a VarDeclStmt
    std::string varName;
    Block body;
    void dump(std::string& out, int indent) const override;
};

// synchronized (mutex) using T& name { ... } -- locks the Mutex<T>, binds `name` to a
// reference to its protected value, runs the body, then unlocks at the end (spec 20.5).
struct SynchronizedStmt : Stmt {
    ExprPtr mutex;
    TypeRef bindType;
    std::string bindName;
    Block body;
    void dump(std::string& out, int indent) const override;
};

struct IfStmt : Stmt {
    ExprPtr cond;
    Block thenBlock;
    std::unique_ptr<Block> elseBlock;  // null when there is no else
    bool isComptime = false;  // spec 37.4: `comptime if` -- the branch is chosen at compile time
    void dump(std::string& out, int indent) const override;
};

struct WhileStmt : Stmt {
    ExprPtr cond;
    Block body;
    void dump(std::string& out, int indent) const override;
};

// do { body } while (cond); -- the body runs at least once (spec 7).
struct DoWhileStmt : Stmt {
    Block body;
    ExprPtr cond;
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
    bool isComptime = false;  // spec 32.4: `comptime T p` -- the argument must be a compile-time constant
    // spec 22.4: `requires named boolean repeat` -- callers MUST pass this one by name, so a bare
    // `configure(5, 2, false)` is rejected and the call site stays readable.
    bool requiresNamed = false;
};

// A lambda value: `lambda(params) returns T { body }`. Its type is function<T, Params...>.
// MVP: no captures (lowers to a top-level function pointer).
// One lambda capture: `byvalue x` (copy) or `byref y` (reference). Parsed now; the codegen for
// closures (a function value that carries an environment) is the next step.
struct Capture {
    bool byRef = false;
    std::string name;
    SourceLocation loc;
};

struct LambdaExpr : Expr {
    std::vector<Capture> captures;  // lambda[captures: ...]; empty = no-capture (current MVP)
    std::vector<Param> params;
    TypeRef returnType;
    Block body;
    void dump(std::string& out, int /*indent*/) const override { out += "lambda"; }
};

// A bound method reference: `methodref obj.method` (spec 22.3). Its value is a function value
// (a closure) whose environment carries the receiver `obj` and whose code forwards to
// `obj.method`. Its type is function<Ret, Params...> of the referenced method.
struct MethodRefExpr : Expr {
    ExprPtr object;       // the receiver expression
    std::string method;   // the method name
    void dump(std::string& out, int /*indent*/) const override { out += "methodref"; }
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
    std::vector<MatchCase> cases;     // arm uses `result` (`-> expr`) or `body` (`-> { yield }`)
    ExprPtr defaultResult;            // `default -> expr;`; null when absent
    std::unique_ptr<Block> defaultBody;  // `default -> { ... yield ...; }`; null when absent
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

// break [label]; / continue [label]; -- loop control (spec 7). Empty label = innermost.
struct BreakStmt : Stmt {
    std::string label;
    void dump(std::string& out, int indent) const override;
};
struct ContinueStmt : Stmt {
    std::string label;
    void dump(std::string& out, int indent) const override;
};
// label: <loop> -- names a loop so break/continue can target it (spec 7.4).
struct LabeledStmt : Stmt {
    std::string label;
    StmtPtr stmt;
    void dump(std::string& out, int indent) const override;
};

// `label name;` -- a standalone target marker for comefrom (spec 7.10).
struct LabelMarkStmt : Stmt {
    std::string name;
    void dump(std::string& out, int /*indent*/) const override { out += "label " + name; }
};

// `comefrom name;` -- transfers control to `label name;` in the same method (spec 7.10).
// The chaos tetrad (goto/comefrom/abstainfrom/reinstate) is intra-method only.
struct ComefromStmt : Stmt {
    std::string name;
    void dump(std::string& out, int /*indent*/) const override { out += "comefrom " + name; }
};

// `goto name;` jumps to a label in the same method, or to an `extern` function by name (spec 7.9).
// `goto <addr>;` (e.g. `goto 0x1000;`) is a raw control transfer to an address. Both function/
// address forms are unchecked FFI/low-level jumps: control does not return.
struct GotoStmt : Stmt {
    std::string name;     // a label or an extern function name (empty when `address` is set)
    ExprPtr address;      // `goto <expr>` raw-address form (null for the name form)
    void dump(std::string& out, int /*indent*/) const override { out += "goto " + name; }
};

// `abstainfrom name;` / `reinstate name;` -- disable/re-enable the code guarded by a label in the
// same method at runtime, via reference counting (spec 7.11).
struct AbstainfromStmt : Stmt {
    std::string name;
    bool isReinstate = false;  // `reinstate` decrements; `abstainfrom` increments
    void dump(std::string& out, int /*indent*/) const override {
        out += (isReinstate ? "reinstate " : "abstainfrom ") + name;
    }
};

// throw expr; -- raises an exception object (spec 21.1).
struct ThrowStmt : Stmt {
    ExprPtr value;
    void dump(std::string& out, int /*indent*/) const override { out += "throw"; }
};

// catch (Type name) { ... } -- one handler of a try (spec 21.1).
struct CatchClause {
    TypeRef type;
    std::string name;
    Block body;
    SourceLocation loc;
};

// try { ... } catch (Type e) { ... } ... finally { ... } -- structured exceptions (spec 21.1).
struct TryStmt : Stmt {
    Block body;
    std::vector<CatchClause> catches;
    std::unique_ptr<Block> finallyBlock;  // null when there is no finally
    void dump(std::string& out, int /*indent*/) const override { out += "try"; }
};

// for (T v in array) { ... } -- foreach over an array (spec 7). Ranges and the
// `index i, T v` form are later refinements.
struct ForeachStmt : Stmt {
    TypeRef elemType;        // ignored when isVar -- inferred from the array element type
    bool isVar = false;      // `for (var x in ...)`
    std::string varName;
    std::string indexName;   // `for (index i, T v in ...)` (spec 7.6); empty when absent
    ExprPtr iterable;
    Block body;
    void dump(std::string& out, int indent) const override;
};

// ---- Annotations (spec 14.3) ----

// One named argument of an annotation use: `value: 100`.
struct AnnotationArg {
    std::string name;   // the annotation field being set
    ExprPtr value;
    SourceLocation loc;
};

// An applied annotation `[Name(arg: val, ...)]`, attached to a declaration it precedes.
struct AnnotationUse {
    std::string name;
    std::vector<AnnotationArg> args;
    SourceLocation loc;
};

// A field of a custom annotation: `int value;` (required) or `String msg default "...";` (optional).
struct AnnotationField {
    TypeRef type;
    std::string name;
    ExprPtr defaultValue;  // null when the field is required
    SourceLocation loc;
};

// `public annotation Name { fields... }` (spec 14.3): declares a custom annotation type.
struct AnnotationDecl {
    std::string visibility;
    std::string name;
    std::vector<AnnotationField> fields;
    bool isCompileTimeProcessor = false;  // declared with [CompileTimeProcessor] (spec 14.4)
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
    bool isProperty = false;  // computed get-only property: read as obj.name (no parens)
    std::string propertySetter;  // spec 8.4: setter method when this getter also has a custom set { }
    bool isComptime = false;  // spec 28.3/37.4: may be evaluated at compile time
    bool isAsync = false;     // spec 20.2: returns a Task<T>; body becomes a state machine
    bool isVolatile = false;  // spec 37.5: always executed; never inlined or optimized away
    bool isDeprecated = false;  // spec 14.2: every call site gets a warning
    bool isExtern = false;    // spec 26: an external C function (no LDP3 body); links to a C symbol
    bool isVariadic = false;  // spec 26: an extern C function with a trailing `...` (e.g. printf)
    std::string externConvention;  // "cdecl"/"stdcall"/"fastcall" when isExtern
    std::string name;
    std::vector<std::string> typeParams;  // generic method parameters: identity<T> -> ["T"]
    // spec 15.2: constraints on those parameters -- `clamp<T extends Numeric>` -> [{"T","Numeric"}].
    // Checked against the type arguments at monomorphization, like the class-level ones.
    std::vector<std::pair<std::string, std::string>> typeParamBounds;
    std::vector<Param> params;
    TypeRef returnType;
    std::vector<TypeRef> throwsTypes;  // `throws(...)` declared exceptions (spec 21.1)
    Block body;  // empty when isAbstract
    std::vector<ExprPtr> requiresClauses;  // contracts (spec 29): preconditions
    std::vector<ExprPtr> ensuresClauses;   // contracts (spec 29): postconditions
    std::vector<AnnotationUse> annotations;  // applied `[Name(...)]` annotations (spec 14.3)
    void dump(std::string& out, int indent) const override;
};

struct FieldDecl : MemberDecl {
    std::string visibility;
    bool isStatic = false;
    bool isMutable = false;
    bool isPersistent = false;  // spec 18: lifetime decoupled from the object (cross-run via disk)
    bool isEternal = false;     // eternal persistent: never requires explicit release
    bool isTransient = false;   // excluded from serialization
    bool isVolatile = false;    // spec 37.5: loads/stores are never optimized away
    bool isLazy = false;        // spec 28.4: a class-typed field initialized on first access
    bool isExternal = false;    // spec 37.1: an association, not owned; cascade does not follow it
    bool isMovable = false;     // spec 19.9: `movable` field -- movable separately (partitionable class)
    bool isUnique = false;      // spec 19.9: `unique` field -- single live reference, movable separately
    TypeRef type;
    std::string name;
    int bitWidth = 0;  // `field : N` bit-field width (spec 11.1); 0 = not a bit-field
    std::string propertySetter;  // spec 8.4: setter method name when this field backs a `set { }`
    ExprPtr init;  // optional inline initializer (null if none); see spec 940
    std::vector<AnnotationUse> annotations;  // applied `[Name(...)]` annotations (spec 14.3)
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
    // Variance per type param (spec 15.3): "out" covariant, "in" contravariant, "" invariant.
    std::vector<std::string> typeParamVariance;
    // Constraint per type param, if any: (param, bound) from `<T extends X>` / `<T implements I>`.
    std::vector<std::pair<std::string, std::string>> typeParamBounds;
    bool isInterface = false;             // declared with `interface`
    bool isStruct = false;                // declared with `struct` -- value type, no inheritance
    bool isRecord = false;                // declared with `record` -- immutable value type
    bool isUnion = false;                 // declared with `union` -- fields share one storage
    bool isAbstract = false;              // `abstract class` (interfaces are abstract too)
    bool isFinal = false;                 // `final class` -- cannot be extended
    bool isSealed = false;                // `sealed` -- only `permits` types may extend it
    bool isPartial = false;               // spec 8.3: this is one part of a class split across declarations
    bool isMovable = false;               // `movable class` -- move discipline
    bool isUnique = false;                // `unique class` -- single live reference
    bool isPartitionable = false;         // `partitionable class` -- fields movable separately (spec 19.9)
    std::string superclass;               // "" when none (from `extends`)
    std::vector<std::string> superclassTypeArgs;  // type args on `extends Base<...>` (generics)
    std::vector<std::string> interfaces;  // from `implements`
    std::vector<std::vector<std::string>> interfaceTypeArgs;  // type args per interface (generics)
    std::vector<std::string> permits;     // sealed permits list (subtypes)
    std::vector<ExprPtr> invariants;      // class invariants (spec 29), checked per method
    std::unique_ptr<Block> onClassLoad;   // spec 32.5: hook run once at program start, before main
    std::unique_ptr<Block> onFirstInstance;          // spec 32.5: before the first instance is created
    std::unique_ptr<Block> onLastInstanceDestroyed;  // spec 32.5: after the last instance is destroyed
    std::unique_ptr<Block> onClassUnload;            // spec 32.5: on unimport (deferred: needs unimport)
    std::vector<MemberPtr> members;
    std::vector<AnnotationUse> annotations;  // applied `[Name(...)]` annotations (spec 14.3)
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// An enum. Int-style (`RED, GREEN`) uses only `constants` (ordinal = index).
// Java-style (spec 12.2) adds per-constant constructor args, plus fields,
// a constructor and methods in `members`; each constant is a singleton instance.
struct EnumDecl {
    std::string visibility;
    std::string name;
    std::vector<std::string> constants;            // names, in declaration order (own then byCatalog)
    std::vector<std::vector<ExprPtr>> constantArgs;  // java-style: ctor args, parallel to constants
    std::vector<MemberPtr> members;                // java-style: fields/constructor/methods
    bool isJavaStyle = false;
    // Catalogs implemented by this enum (spec 12.4): `enum Motor extends TipoMotor`.
    std::vector<std::string> extendsCatalogs;      // catalogs this enum satisfies (IS-A)
    std::vector<std::string> byCatalogValues;      // constants provided via `byCatalog { ... }`
                                                   // (also appended to `constants` for ordinals)
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// A catalog (spec 12.3): an interface for enums. It declares the VALUES an
// implementing enum must provide (`requiredValues`) and the method signatures it
// must implement (`methods`, abstract MethodDecls). An enum `extends` a catalog
// and becomes its subtype.
struct CatalogDecl {
    std::string visibility;
    std::string name;
    std::vector<std::string> requiredValues;       // constants an implementing enum must provide
    std::vector<MemberPtr> methods;                // required method signatures (abstract)
    std::vector<std::string> extendsCatalogs;      // catalogs this catalog extends (spec 12.3)
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// A `comptime literal` suffix function at namespace level (spec 17.10):
// `comptime literal name(T param) returns R { body }`, a member of the class/struct of its result
// type, used as `64 kilobytes` (the suffix) or `Type.name(N)`. Implicitly static (no `this`).
struct LiteralDecl : MemberDecl {
    std::string visibility;
    bool isComptime = false;  // spec requires `comptime`; semantics enforces it
    std::string name;
    Param param;              // exactly one parameter
    TypeRef returnType;
    Block body;
    void dump(std::string& out, int indent) const override;
};

// A namespace-level compile-time constant (spec 28.1): `const T NAME = expr;`,
// where `expr` is a constant expression (literals, arithmetic, and references to
// previously-declared consts). Folded at compile time; no runtime storage.
struct ConstDecl : MemberDecl {
    std::string visibility;
    TypeRef type;
    std::string name;
    ExprPtr init;
    void dump(std::string& out, int indent) const override;
};

// An external C function (spec 26): `extern cdecl method name(params) returns T;`. No body; it
// resolves to a symbol with C linkage. `convention` is cdecl/stdcall/fastcall (unified on x64).
struct ExternDecl {
    std::string convention;
    std::string name;
    std::vector<Param> params;
    TypeRef returnType;
    bool isVariadic = false;  // `...` trailing parameter
    SourceLocation loc;
};

// A `typealias Name = Target;` (transparent: Name and Target are interchangeable) or
// `newtype Name = Target;` (a distinct nominal type with the same representation, requiring a
// cast to convert to/from the underlying type). spec 24.
struct TypeAliasDecl {
    std::string visibility;
    std::string name;
    TypeRef target;
    bool isNewtype = false;
    SourceLocation loc;
};

struct Namespace {
    std::string visibility;
    std::string name;
    std::vector<ClassDecl> classes;
    std::vector<EnumDecl> enums;
    std::vector<CatalogDecl> catalogs;
    std::vector<LiteralDecl> literals;
    std::vector<ConstDecl> consts;
    std::vector<ExternDecl> externs;
    std::vector<TypeAliasDecl> typeAliases;
    std::vector<AnnotationDecl> annotationDecls;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

// `import a.b.c;` -- brings a symbol (last component) into scope. Required to
// enable a literal's `N suffix` syntax (spec 17.10 rule 5).
struct ImportDecl {
    std::vector<std::string> path;  // e.g. ["System","Memory","Units","kilobytes"]
    bool isFinal = false;           // `final import` (spec 37.6): the symbol cannot be unimported
    bool isLazy = false;            // `lazy import` (spec 37.3): load on first instance, not at boot
    SourceLocation loc;
};

struct Bundle {
    std::string visibility;
    std::string name;
    bool isFreestanding = false;  // `bundle X freestanding { ... }` (spec 36)
    bool isPrelude = false;       // from the embedded prelude, not user source; excluded from the .ldh
    bool isImported = false;      // from a depended-on .ldb (parsed from its .ldh): types are visible,
                                  // but bodies live in the .ldb -- sema skips them, codegen externs them
    bool isDynamic = false;       // imported via --use-dynamic: loaded at runtime; codegen emits thunks
                                  // that load the .ldb and resolve the symbol instead of linking it
    std::vector<ImportDecl> imports;
    std::vector<Namespace> namespaces;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

struct Program {
    std::string name;
    bool isFreestanding = false;  // `program X freestanding;` (spec 36): no managed-runtime features
    std::vector<ImportDecl> imports;  // file-level imports, written before `program` (spec 2.7)
    std::vector<Bundle> bundles;
    // Variance of each generic's type params (spec 15.3), recorded by monomorphize
    // before templates are dropped, so the analyzer can apply variance subtyping to
    // the surviving concrete instantiations. Keyed by the generic's (mangled) name.
    std::map<std::string, std::vector<std::string>> genericVariance;
    bool hasQualifiedTypeRef = false;  // a `ns.Type` reference was used (gates qualifyNamespaces)
    // Internal names produced by namespace disambiguation (e.g. app__Box). These are
    // already explicitly scoped, so they bypass the import/visibility requirement.
    std::set<std::string> qualifiedTypes;
    // Base name -> namespace for each generic class, captured before monomorphization erases the
    // templates. Lets the type checker enforce imports on a collection (ArrayList) by its base name.
    std::map<std::string, std::string> genericNamespaces;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

}  // namespace ldp3::ast
