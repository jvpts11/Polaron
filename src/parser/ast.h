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
namespace polaron::ast {

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
        // Canonicalize the `string` alias to `String`: they are the same runtime type ({i64 len, ptr
        // data}) and convert freely, so `Box<string>` and `Box<String>` must be the SAME instantiation.
        // Otherwise a stdlib method taking `ArrayList<String>` rejects an `ArrayList<string>` argument
        // ("type ArrayList$string but parameter is ArrayList$String"). Whole-word replace only.
        for (std::size_t p = enc.find("string"); p != std::string::npos; p = enc.find("string", p + 6)) {
            auto ident = [](char c) {
                return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ||
                       c == '_';
            };
            bool wb = (p == 0) || !ident(enc[p - 1]);
            bool we = (p + 6 >= enc.size()) || !ident(enc[p + 6]);
            if (wb && we) {
                enc.replace(p, 6, "String");
            }
        }
        for (std::size_t p = enc.find("[]"); p != std::string::npos; p = enc.find("[]", p)) {
            enc.replace(p, 2, "~arr");
        }
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
    bool isPointer = false;  // T* -- true whenever pointerDepth >= 1 (kept for the many "is it a pointer"
                             // checks that don't care about depth)
    int pointerDepth = 0;    // number of trailing '*': 1 = T*, 2 = T** (pointer-to-pointer), 3 = T***, ...
                             // N-level pointers are supported on non-generic base types only, because a
                             // generic's mangled name can itself end in '*' (e.g. HashMap<..,T*> ->
                             // "HashMap$..T*"), which would make counting the outer '*' ambiguous.
    bool arrayElemPointer = false;  // T*[] : array whose ELEMENT is a pointer (not T[]* = pointer to array)
    // `T[N]` -- an array whose EXTENT IS IN THE TYPE. Zero means the extent is not stated, which is
    // the ordinary dynamic array (`T[]`, heap, length header, `delete`).
    //
    // It is an array, not a struct wearing brackets: N elements of one type, indexed, with a length.
    // What differs is only where the length lives -- in the type, so the value does not carry it,
    // does not need a header, lives where it is declared and dies with its owner. The canonical
    // spelling is `int[16]`, which no existing check mistakes for `int[]` because they test for the
    // literal "[]".
    int arrayExtent = 0;
    /* ...AND THE EXTENT BEFORE IT IS A NUMBER (A.3). `T[R * C]` inside `Matrix<fixed T, fixed int R,
     * fixed int C>` states an extent the type knows and the compiler cannot fold until R and C are
     * bound. Held as the text between the brackets ("R*C"), substituted with everything else when
     * the class is stamped, and folded to `arrayExtent` there.
     *
     * Empty for every ordinary array, which is every array written before this existed: a stated
     * extent that is already a literal fills `arrayExtent` at the parse and never comes here. */
    std::string arrayExtentExpr;
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
    for (int i = 0; i < dims; ++i) {
        s += "[]";
    }
    return s;
}

// Canonical type string of a TypeRef, matching the form sema/codegen key on:
// generic args mangled into the name, then [] / * / & markers (e.g. "Box$int*", "int[][]").
// A tuple type already carries its full spelling in `name` (e.g. "(int,int)").
// Polaron spells qualities as PREFIX WORDS, not suffix punctuation (`nullable T`, `mutable T`): a prefix
// says what kind of thing is coming before you read it, which is why the language has almost no suffixes.
// The canonical form keeps that shape -- "nullable Dog*", never "Dog*?".
//
// It also settles what `nullable T[]` means. With the marker in FRONT, `[]` is the outermost suffix, so
// "nullable Dog*[]" is an ARRAY (indexable, like any array) whose ELEMENTS may be null -- strip the "[]"
// and the element type is "nullable Dog*". The old suffix form said the opposite (a nullable array) and
// could not express element nullability at all.
inline const char* kNullablePrefix = "nullable ";
inline bool typeIsNullable(const std::string& t) { return t.rfind(kNullablePrefix, 0) == 0; }
inline std::string stripNullable(const std::string& t) {
    return typeIsNullable(t) ? t.substr(9) : t;
}
inline std::string makeNullable(const std::string& t) {
    return typeIsNullable(t) ? t : kNullablePrefix + t;
}
inline std::string canonicalType(const TypeRef& t) {
    // spec 32.2: `RegionSnapshot` IS an `address` -- a handle to a block the caller placed and owns.
    // It gets its own spelling because a snapshot handle and a raw address say different things to a
    // reader, and it is mapped HERE, at the one place both the analyzer and codegen ask what a type is
    // called, so the two can never end up disagreeing about it. (It was tried as a `typealias` in the
    // prelude first; adding one to `namespace Memory` breaks `System.Memory.Units.kilobytes`.)
    const std::string base = t.name == "RegionSnapshot" ? std::string("address") : t.name;
    // An extent that is still an expression renders as the expression: `float[R*C]` is a stable name
    // for a template, and stamping rewrites it to `float[16]` the same way it rewrites `T`.
    const std::string extent = t.arrayExtent > 0 ? "[" + std::to_string(t.arrayExtent) + "]"
                               : !t.arrayExtentExpr.empty() ? "[" + t.arrayExtentExpr + "]"
                                                            : arrayDimsSuffix(t.arrayDims);
    const std::string core = mangleGeneric(base, t.typeArgs) + (t.arrayElemPointer ? "*" : "") +
                             extent + std::string(t.pointerDepth, '*') + (t.isRef ? "&" : "");
    return t.isNullable ? makeNullable(core) : core;
}

// THE TEXT BETWEEN THE BRACKETS, cut by finding them rather than by counting the prefix.
//
// Every caller used to write `t.substr(8, t.size() - 9)`, where 8 is the length of "funcptr<". That
// held for exactly as long as the word did: the type has been renamed twice, and "methodptr<" is ten
// characters. A hardcoded 8 does not fail to compile -- it silently cuts two characters off the
// return type, which is the kind of wrong that reaches a machine.
inline std::string bracketedInner(const std::string& type) {
    const std::size_t open = type.find('<');
    if (open == std::string::npos || type.empty() || type.back() != '>') {
        return std::string();
    }
    return type.substr(open + 1, type.size() - open - 2);
}

// [unknown-abi] A `methodptr<...>` type may carry a foreign-world calling convention as a leading
// "$<conv>" element inside its brackets: "methodptr<$unknown:pe,Ret,P0,...>" (from `unknown pe
// methodptr<...>`). These recover / strip it so every substring-splitter (codegen + sema) stays in
// sync; a plain methodptr (no leading '$') is returned unchanged. `inner` = the bracketed text.
inline std::string methodptrWorld(const std::string& inner) {  // "" if none; else e.g. "unknown:pe"
    if (inner.empty() || inner[0] != '$') {
        return "";
    }
    std::size_t c = inner.find(',');
    return inner.substr(1, (c == std::string::npos ? inner.size() : c) - 1);
}
inline std::string methodptrBody(const std::string& inner) {  // `inner` with any "$<conv>," removed
    if (inner.empty() || inner[0] != '$') {
        return inner;
    }
    std::size_t c = inner.find(',');
    return c == std::string::npos ? std::string() : inner.substr(c + 1);
}
// A bare code address, `nullable` or not. It is spelled with brackets rather than a trailing '*', so
// `isRefType` does not recognise it -- and every place that asks "may this be compared against null"
// has to ask this too. A null code address is not an edge case in the C ABI: it is how "there is no
// callback" is written, which is why the nullable spelling has to answer yes here as well. Testing the
// declared type against the bare prefix said no, and a `nullable methodptr` field then had no way to
// be either called or checked.
inline bool isMethodPtrType(const std::string& t) {
    return stripNullable(t).rfind("methodptr<", 0) == 0;
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

// True when an integer literal was WRITTEN with more than 32 bits of digits, whatever signed value it
// happens to equal. `0xFFFFFFFFFFFFF000` is a 64-bit mask that equals -4096 as an int64, so deciding its
// width by value alone typed it `int` and silently truncated it to 0xFFFFF000 -- an address mask that
// quietly dropped everything above 4 GiB. Someone who writes sixteen hex digits means sixteen hex digits.
//
// It lives here, next to the AST, because it is a fact about the literal's SYNTAX: both the analyzer and
// the code generator have to reach the same answer, and two copies of this rule would eventually not.
inline bool intLiteralNeeds64(const std::string& lexeme) {
    std::string s;
    for (char c : lexeme) {
        if (c == '_' || c == 'L' || c == 'l') {
            continue;
        }
        s += c;
    }
    std::size_t start = 0;
    int bitsPerDigit = 0;
    if (s.size() >= 2 && s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) { start = 2; bitsPerDigit = 4; }
    else if (s.size() >= 2 && s[0] == '0' && (s[1] == 'b' || s[1] == 'B')) { start = 2; bitsPerDigit = 1; }
    if (bitsPerDigit == 0) {
        return false;  // decimal: its value already decides, and it cannot lie
    }
    while (start < s.size() && s[start] == '0') {
        ++start;  // leading zeros are not significant
    }
    return (s.size() - start) * static_cast<std::size_t>(bitsPerDigit) > 32;
}

struct StringLiteralExpr : Expr {
    std::string value;  // raw content; escapes resolved in a later phase
    // b"...": the bytes THEMSELVES (NUL-terminated, type `byte*`), not a String object. Freestanding
    // has no runtime to build a String, and a kernel wants the raw bytes anyway -- a path, a device
    // name, a PE import name are all things it compares byte by byte.
    bool isBytes = false;
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

// `obj.[expr]` -- the member whose NAME is the compile-time string `expr`.
//
// It never survives into a program. A structural procedure is unrolled once per field of the type
// that applies it, and each copy resolves its splices to ordinary `MemberExpr`s; anything left after
// that is an error, because a name that is not known at compile time is not a member access at all.
struct MemberSpliceExpr : Expr {
    ExprPtr object;
    ExprPtr name;   // must fold to a string: `field.name`
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

// The stdlib's BUILTIN STATIC CLASSES: types whose static methods are compiler intrinsics rather
// than Polaron code. Written down ONCE, for the same reason as the predicate below -- two copies of a
// list like this are a defect waiting for the day they disagree, and that day already came: the
// monomorphizer had its own copy, so a class declaring a generic `read<T>` rewrote every
// `Raw.read<int>` in the program into a builtin that does not exist.
//
// Two consumers. The analyzer registers each as a type in its namespace; the monomorphizer must know
// them so generic-method expansion leaves their type arguments alone (a builtin's `<int>` says what
// to load, not which template to instantiate).
struct BuiltinStaticClass {
    const char* name;
    const char* ns;      // namespace inside bundle System
    bool shadowable;     // may a user class of the same name take precedence?
};
inline const std::vector<BuiltinStaticClass>& builtinStaticClasses() {
    static const std::vector<BuiltinStaticClass> kAll = {
        {"Math", "Math", true},        // spec 34.6: virtual so a user `class Math` works
        {"Allocator", "Memory", false},  // spec 17.8: alloc/free/copy
        {"Raw", "Memory", false},        // spec 17.8: read/write/sizeof/addressOf
        {"File", "IO", false},           // spec 34.4: static methods lower to runtime stdio
        {"Time", "Time", false},         // spec 34: clock + sleep builtins
        {"Net", "Net", false},           // spec 34: TCP builtins over runtime winsock
        {"Ipc", "Ipc", false},           // spec 2.8: cross-program transport builtins
        {"Bits", "Ipc", false},          // exact double<->long bit reinterpretation (IEEE-754)
        {"Process", "OS", false},        // spec 34: subprocess builtin (Process.run)
        {"Env", "OS", false},            // spec 34: environment-variable builtins
        {"Subproc", "OS", false},        // low-level persistent-subprocess builtins
        {"Conpty", "OS", false},         // low-level pseudo-console builtins
    };
    return kAll;
}
inline bool isBuiltinStaticClassName(const std::string& n) {
    for (const BuiltinStaticClass& b : builtinStaticClasses()) {
        if (n == b.name) {
            return true;
        }
    }
    return n == "reflect";  // a builtin NAMESPACE rather than a class, but calls on it read the same
}

// Unsigned integer type names. `byte` is int8 (SIGNED) per spec 5 -- exactly the sort of fact that two
// copies of this predicate would eventually disagree about, which is why there is one and both the
// analyzer and the code generator call it.
inline bool isUnsignedIntName(const std::string& t) {
    // Every address is unsigned, the narrow ones included: there is no negative address, and a SIGNED
    // 16-bit one would sign-extend on the way to a wider type -- turning 0xFFF0 into
    // 0xFFFFFFFFFFFFFFF0, which is the whole class of bug these types exist to make unwritable.
    return t.rfind("uint", 0) == 0 || t == "address" || t == "ubyte" || t == "ushort" ||
           t == "ulong" || t == "halfaddress" || t == "shortaddress" || t == "byteaddress";
}

// What a field contributes to a type's IDENTITY -- the generated equalsKey/hash/compareTo, and the
// serialised key of a keyed persistent (docs/design/persistent-keys.md). One definition, called by the
// synthesis pass and by codegen, for the reason the predicate above exists: two copies of "does this
// field count?" would eventually disagree, and here they would disagree about where state lives.
//
// Excluded on purpose: a pointer, array, reference or nullable field has no structural value to compare,
// and a class reference is an identity of its own rather than part of this one. A field left out
// is warned about at the declaration, never silently dropped.
//
// AN ENUM IS NOT ONE OF THOSE, and saying it was cost Stone Reports a real bug. `record Entry(String
// path, String name, EntryKind kind, int start, int size)` says in its own header comment that two
// entries with the same name, KIND, start and size are the same entry -- and the generated equality
// dropped `kind`, so a storage and a stream that agreed on everything else compared EQUAL. An ordinal
// enum is a small integer with names on it: it has exactly the structural value the exclusion says it
// lacks. A SUM is the case that sentence was really about, and a sum never reaches here -- a case with
// a payload desugars into a sealed hierarchy at the parse site, so its field names a class.
enum class KeyFieldKind {
    None,    // not part of the identity
    Scalar,  // fixed-width: integers, boolean, char, floats -- compared and serialised as their bytes
    Text,    // String: variable-width, serialised as a length prefix then the contents
    Nested,  // a struct/record of the above: recurse in declaration order
};
inline KeyFieldKind keyFieldKind(const TypeRef& t, const std::set<std::string>& valueTypeNames,
                                 const std::set<std::string>& ordinalEnumNames) {
    if (t.isArray || t.isPointer || t.isRef || t.isNullable) {
        return KeyFieldKind::None;
    }
    if (t.name == "String") {
        return KeyFieldKind::Text;
    }
    if (valueTypeNames.count(t.name) > 0) {
        return KeyFieldKind::Nested;
    }
    // Compared with `==`, folded into the hash through `cast<long>`, and left out of the ORDERING --
    // `<` on an enum is refused (0801), the same shape booleans are already in. An order is a weaker
    // contract than an identity, and the identity is what was wrong.
    if (ordinalEnumNames.count(t.name) > 0) {
        return KeyFieldKind::Scalar;
    }
    static const std::set<std::string> scalars = {
        "byte", "ubyte", "short", "ushort", "int", "uint", "long", "ulong", "address",
        "smallfloat", "float", "double", "quadruple", "char", "boolean",
        "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64",
        "float32", "float64", "usize", "isize"};
    return scalars.count(t.name) > 0 ? KeyFieldKind::Scalar : KeyFieldKind::None;
}

// True when an expression is built ONLY from integer literals and arithmetic on them -- a constant whose
// type its context is free to choose, so mixing it with any integer type is safe.
//
// It has to be the whole EXPRESSION, not a bare literal token: `addr & (0 - 4096)` is the commonest mask
// idiom there is, and `(0 - 4096)` is a BinaryExpr of two literals. A rule that exempted only single
// literals would reject exactly the code it was written to keep working.
inline bool isLiteralOnlyExpr(const Expr& e) {
    if (dynamic_cast<const IntLiteralExpr*>(&e) != nullptr) {
        return true;
    }
    if (const auto* u = dynamic_cast<const UnaryExpr*>(&e)) {
        return isLiteralOnlyExpr(*u->operand);
    }
    if (const auto* b = dynamic_cast<const BinaryExpr*>(&e)) {
        return isLiteralOnlyExpr(*b->lhs) && isLiteralOnlyExpr(*b->rhs);
    }
    return false;
}

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
    // Whether `on <location>` was WRITTEN. The default is "stack", so `on heap` is self-evidently the
    // author's word while `on stack` is indistinguishable from silence -- and a region class needs to
    // tell them apart, because it must refuse a placement it was given and quietly take the one it was
    // not. Refusing what the author wrote and overriding it without a word are not the same act.
    bool locationWritten = false;
    // Storage with no constructor run over it: what a bound target starts as. Never written by an
    // author -- it is synthesized for `procedure into<Fahrenheit f>`, where the body IS the
    // construction and the analyzer proves it assigns every field before the end.
    bool blank = false;
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

// `extract X from region R` (spec 17, flavors expansion) -- relocate object X out of region R to a fresh
// heap allocation and yield the owning pointer. Like `move`, the source variable is spent afterwards
// (use-after-extract is an error); on a pool/fixedslot region the vacated slot is reclaimed. RHS-only:
// its result transfers ownership and must be bound to a variable/field (a bare statement leaks it).
struct ExtractExpr : Expr {
    ExprPtr target;         // the object to relocate (an lvalue: identifier / a[i] / this.field)
    std::string region;     // the region it currently lives in
    void dump(std::string& out, int indent) const override;
};

// `mark of region R` (spec 17, stack flavor) -- capture region R's current allocation cursor as a
// `checkpoint` value. A later `rollback region R to m` destructs everything allocated after the mark
// (newest first) and rewinds the cursor. `checkpoint` is a built-in value type (an opaque i64 cursor).
struct MarkExpr : Expr {
    std::string region;
    void dump(std::string& out, int indent) const override;
};

// `capacity of region R` / `used of region R` / `room of region R` (spec 17) -- how big the arena is,
// how much of it has been handed out, and how much is left, in bytes.
//
// WHY A REGION HAS TO BE ABLE TO ANSWER THIS. A fixed region that fills does not return null, it
// panics -- deliberately, because a silent short allocation in an arena is worse. But that leaves a
// caller who wants to STAY inside a budget with nothing to ask: the only way to know whether the next
// object fits was to keep a byte counter beside the region and add up the sizes by hand, including
// the per-array header, and hope that private arithmetic and the region's own never drifted apart.
// That is a second allocator written next to the real one, and it is exactly the shape of thing this
// language exists to delete.
//
// So the region answers. `room of region R` is the question an admission check actually asks, and it
// is asked of the object that cannot be wrong about it.
struct RegionSpaceExpr : Expr {
    enum class Ask { Capacity, Used, Room };
    Ask ask = Ask::Room;
    std::string region;
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
    // A SUB-REGION: `region inner = itself.allocate(1 kilobytes) in region outer;` -- the block is
    // carved out of `outer` rather than taken from the allocator, so releasing the parent reclaims
    // every child in one stroke and a per-phase arena inside a per-world one costs no second
    // allocation. Empty when the region stands on its own.
    //
    // The phrase is the one the language already has: `new Dog() in region pen` means "take the
    // memory from pen", and this means the same thing about a region's own block. Nesting by SCOPE
    // was always possible and is what §10 orders; this is nesting in SPACE, which was not.
    std::string inRegion;
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
    bool targetVolatile = false;  // cast<volatile T*>: the result is an MMIO pointer; accesses through it
                                  // (indexing/deref) are volatile -- never reordered, fused, or elided.
    // THE COMPILER WROTE THIS ONE, not the author. A record's generated `hash` folds every scalar
    // field into a `long`, an `address` field included -- which is right there, and is exactly the
    // shape the address-discipline warning reports. A warning pointing at `public struct WmRequest`
    // about a cast nobody wrote is the worst kind of noise: unfixable at the line it names. Advice is
    // suppressed for these. Errors are not: generated code that cannot compile is a compiler bug and
    // has to be reported somewhere.
    bool synthetic = false;
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
    // `in region R`, exactly as NewExpr has it. A region holds ANYTHING that passes its accepts/rejects
    // (spec 17); an array was excluded only because this field did not exist -- and the consequence was
    // that a program wanting its buffers region-owned had to hand-roll an arena beside the region, which
    // is the precise thing regions exist to make unnecessary. Empty means the ordinary heap.
    std::string region;
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

// ---- Annotations (spec 14.3) ----
//
// HERE rather than beside the declarations they mostly apply to, because a LOCAL carries them now
// and a local is a statement. A `std::vector<AnnotationUse>` in a statement needs the type complete
// where the member is declared, and the alternative -- an incomplete element type -- is a rule about
// which member functions may be instantiated where, which is not a rule this file should depend on.

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
    // ALREADY HONOURED, BEFORE THE ANALYSER RAN. A few rules are checked in the driver, while the
    // AST is still being built -- the generated-key one, because it decides what to generate -- and
    // an `[Allow]` they obey is invisible to the staleness check, which lives in the analyser and
    // only sees the suppressions the analyser itself performed. Without this the author is told, in
    // the same run, that the annotation silenced a warning and that it never silenced anything.
    mutable bool honouredEarly = false;
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
    /* Written `discard <expr>;` -- THE ANSWER WAS SEEN AND NOT WANTED (B.2).
     *
     * `mustuse` warns when a result is thrown away, and a rule with no way to say "yes, on purpose"
     * is a rule people learn to switch off. This is the valve, and it is a WORD rather than a
     * suppression comment: it is in the code, at the line, and a reader sees the decision instead of
     * a missing diagnostic. Nothing else about the statement changes -- the expression is evaluated
     * and its value dropped, exactly as before. */
    bool isDiscard = false;
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
// Optional trailing operand clauses let the assembly exchange values with the surrounding code:
//   asm("x86_64") { mov cr3, $0 } in (v);
//   asm("x86_64") { mov $0, cr3 } out (r);
//   asm("x86_64") { in $0, dx } out (v) in (port) clobber ("rax");
// In the body `$0`, `$1`, ... number the OUTPUTS first, then the INPUTS (the GCC/LLVM order).
struct AsmStmt : Stmt {
    std::string arch;
    std::string dialect;  // "intel" | "att" | "" (follow the architecture: Intel on x86)
    std::string body;
    std::vector<ExprPtr> outputs;       // lvalues the asm writes  -> "=r" constraints
    std::vector<ExprPtr> inputs;        // values the asm reads    -> "r"  constraints
    std::vector<std::string> clobbers;  // registers the asm destroys -> "~{reg}"
    // WHERE EACH OPERAND MUST BE (docs/design/asm-constraints.md), parallel to the two lists above
    // and empty where the author said nothing -- which is every block written before this existed.
    //
    // `asm("x86_64") { in $0, dx } out ("ax": value) in ("dx": port)`. The vocabulary is the
    // ARCHITECTURE'S OWN register names, not C's letter codes: `"ax"`, not `"a"`. A private alphabet
    // is a second thing to learn for a fact the machine already has a word for, and it runs out --
    // C spells the `edx:eax` pair `"A"` and has no letter left for another pair.
    //
    // A SECOND VECTOR INDEXED BY THE SAME INTEGER IS THE SHAPE THAT HIDES A TYPE, and it is here
    // anyway rather than as a field on a new `AsmOperand`. `outputs` and `inputs` are `ExprPtr`
    // lists that the parser, the analyzer, the cloner and the emitter all walk by index; giving them
    // an element type would touch five files to carry a string. What the ban protects against is
    // parallel arrays that can DISAGREE about their length, and these cannot: `parseAsm` pushes to
    // both on every operand, and `""` is what "nothing said" looks like.
    std::vector<std::string> outputWhere;   // per outputs[i]: "ax", "edx:eax", "memory", ""
    std::vector<std::string> inputWhere;    // per inputs[i], the same vocabulary
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
    bool isPersistent = false;  // set for `release <expr>` (the `persistent`/`eternal` word is optional)
    ExprPtr target;           // the persistent lvalue (obj.field), when isPersistent
    bool allKeys = false;     // `release C.field all` -- every keyed entry, not just this object's
    void dump(std::string& out, int indent) const override;
};

// `rollback region R to m;` (spec 17, stack flavor) -- run destructors newest-first for everything
// allocated in stack region R after checkpoint m, then rewind R's cursor to m.
struct RollbackStmt : Stmt {
    std::string region;
    ExprPtr checkpoint;       // the `checkpoint` value captured by an earlier `mark of region R`
    void dump(std::string& out, int indent) const override;
};

// `snapshot region W in region B` (spec 32.2): capture W's state into a block placed in B, and yield
// the handle. An EXPRESSION because the declaring form is an initializer:
//   RegionSnapshot k = snapshot region world in region backups;
// `snapshot` is a SOFT keyword -- an ordinary identifier everywhere else, because pico already has a
// `restore()` method and the pair has to stay usable as names.
struct SnapshotExpr : Expr {
    std::string region;   // the region being captured
    std::string home;     // `in region B` -- where the snapshot's bytes live; the caller owns them
    void dump(std::string& out, int indent) const override;
};

// `snapshot region W into k;` -- re-capture into a snapshot that already has its block.
struct SnapshotIntoStmt : Stmt {
    std::string region;
    ExprPtr into;
    void dump(std::string& out, int indent) const override;
};

// `restore k into W;` / `restore k into region W;` -- put W back the way k found it. The destructors
// of everything allocated since the capture run FIRST; see runtime/polaron_region_core.hpp.
struct RestoreStmt : Stmt {
    std::string region;
    ExprPtr snapshot;
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
    // Region flavor axis (spec 17, flavors expansion): the reclaim strategy of a `region` declaration.
    // "" == bump == the historical linear/monotonic behavior (byte-identical fast path). The flavor
    // words are contextual soft keywords recognized only immediately before `region`.
    std::string regionFlavor;    // "" (=bump) | "bump" | "pool" | "stack" | "fixedslot" | "ring"
    bool regionGrowable = false; // `growable` modifier: chain a new block on overflow
    TypeRef type;        // used when !isVar
    std::string name;
    ExprPtr init;        // M2: an initializer is required
    // `[Allow(code: "...", why: "...")]` written on the DECLARATION. Every other place a warning is
    // reported has somewhere to put one -- a class, a method, a field -- and a local did not, so the
    // one kind of advice that is ABOUT a local could not be answered at all: the author's only move
    // was to change code that was right, or to put an `[Allow]` on the whole method and switch the
    // rule off for every other local in it.
    //
    // Read by NAME at the warn site rather than pushed as a frame, and that is the difference
    // between this and every other `[Allow]` here: a frame would cover the rest of the method, so
    // one local's exemption would quietly cover the next one's.
    std::vector<AnnotationUse> annotations;
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
    // `move x` -- THE FOURTH WAY ACROSS A THREAD BOUNDARY (docs/design/ownership.md §11).
    //
    // `atomic<T>`, `Mutex<T>` and `Channel<T>` are three ways to SHARE. None of them is the obvious
    // one, which is **not to share** -- to hand it over. A thread that receives its chunk by `move`
    // is its sole holder, so no race is possible because there is no second holder: safe by
    // construction rather than by a lock, and it costs nothing.
    //
    // It is the common case -- one worker, one chunk -- and expressing it needed no relaxation of
    // the rule that protects the dangerous case. What it needed was a third capture mode: `byvalue`
    // copies, `byref` shares, and neither says *the outer scope no longer has this*.
    bool isMove = false;
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
    // The generated command class that expresses this binding -- `Animal$bound$speak`, carrying the
    // receiver and forwarding to the method. Filled in by the analyzer, which is where the receiver's
    // type is known; empty until then, and empty for good if the reference did not resolve.
    std::string boundClass;
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

// demand <cond> otherwise "why"; -- a compile-time check (spec 28.2). The
// condition must be a constant expression; checked by the analyzer, emits no code.
struct DemandStmt : Stmt {
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
    // `comptime foreach (field in itself.fields)`: UNROLLED, not run. The expansion pass replaces it
    // with one copy of the body per field of the applying type, each with the field's name and type
    // substituted as literals. Nothing reaches the analyzer -- a comptime foreach that survives is an
    // error, because it means nothing knew what to unroll it over.
    bool isComptime = false;
    Block body;
    void dump(std::string& out, int indent) const override;
};

// ---- Annotations (spec 14.3) ----
//
// The two types themselves are declared ABOVE the statements, because a local declaration carries
// them now -- see `VarDeclStmt::annotations` for what that is for.

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
    // WRITTEN BY THE COMPILER, not by anybody. A record's `equals`, `hashCode` and `toString` carry
    // the record's own source location, because that is the only place a reader could be sent -- and
    // that made every rule that reads a body report about code nobody typed. `record Datagram(String
    // data, String host, int port)` earned "the number 31 is written out 3 times in this method",
    // about the multiplier in a hash the author never saw. Advice skips these; errors do not, since
    // a generated body that does not compile is a real defect (see the note in buildRecordHashCode
    // about a `+` reported on a record declaration).
    bool isSynthesized = false;
    virtual ~MemberDecl() = default;
    virtual void dump(std::string& out, int indent) const = 0;
};
using MemberPtr = std::unique_ptr<MemberDecl>;

// A constraint on a type parameter (spec 15.2): `<T extends Base>`, `<T implements Iface>` or
// `<T applies TComparer>`.
//
// THE KIND IS STORED, NOT DEDUCED FROM THE NAME. A class and a transformer may share a name, and a
// rule that decides which one a bound meant by looking it up lets a declaration in another file
// change what this one says -- the same reason `each` is written on the socket rather than inferred
// from whether the name inside `<>` happens to already be a type.
struct TypeBound {
    std::string param;     // the type parameter being constrained
    std::string bound;     // the bound, in canonical mangled form ("Comparable$T")
    bool applies = false;  // `applies` -- equipment, checked against the applied closure
};

struct MethodDecl : MemberDecl {
    std::string visibility;  // "" when none
    bool isStatic = false;
    bool isAbstract = false;  // no body; must be overridden
    bool isOverride = false;  // overrides an inherited/interface method
    // `surveyed`: the region binder does not derive this method's lifetime summary from its body.
    // Inside, the one refusal about values it cannot PLACE is suspended -- everything it can still
    // prove wrong stays refused. Outside, the boundary goes to the worst case: every reference
    // parameter is treated as kept, and a reference result as a borrow of everything in reach.
    //
    // The freedom is local and the suspicion is exported, which is the opposite of what `unsafe`
    // does -- and it is what makes marking a method cost its callers rather than nobody.
    bool isSurveyed = false;
    bool isFinal = false;     // cannot be overridden
    bool isProperty = false;  // computed get-only property: read as obj.name (no parens)
    std::string propertySetter;  // spec 8.4: setter method when this getter also has a custom set { }
    bool isComptime = false;  // spec 28.3/37.4: may be evaluated at compile time
    bool isAsync = false;     // spec 20.2: returns a Task<T>; body becomes a state machine
    bool isVolatile = false;  // spec 37.5: always executed; never inlined or optimized away
    bool isDeprecated = false;  // spec 14.2: every call site gets a warning
    bool isExtern = false;    // spec 26: an external C function (no Polaron body); links to a C symbol
    bool isVariadic = false;  // spec 26: an extern C function with a trailing `...` (e.g. printf)
    // spec 36: `naked` -- no prologue/epilogue is emitted; the body is raw assembly that owns the machine
    // state exactly as the hardware handed it over (a reset vector with no stack, a syscall entry running
    // on the caller's stack, an ISR that must not disturb the CPU-pushed frame).
    bool isNaked = false;
    // `public interrupt(Trap t) returns void { }` -- ENTERED, not called. Modeled as a MethodDecl
    // named "interrupt" (the source form is nameless) for the same reason `operator+` is: everything
    // downstream -- monomorphization, implicit `this`, contracts, the region binder -- already knows
    // how to handle a method, and an interrupt body IS an ordinary method body. What differs is
    // entirely at the edges: nothing may call it, and codegen emits a second function beside it
    // carrying `x86_intrcc` so LLVM writes the register save/restore and the `iretq`.
    bool isInterrupt = false;
    // `reentrant method m()` (docs/design/reentrant.md): THIS MAY BE ENTERED AGAIN WHILE AN EARLIER
    // ENTRY IS STILL RUNNING.
    //
    // Two things follow from that one sentence, and the `interrupt` rule already checks both: it
    // reaches no storage another activation could be inside (the allocator has global mutable state
    // you may have interrupted mid-update), and it touches no shared mutable state. Naming the
    // REASON rather than one of the mechanisms is what makes it wider than a "does not allocate"
    // marker -- it also catches the lock, because a `reentrant` method that takes a `Mutex`
    // deadlocks against itself, which no allocation rule can see.
    //
    // `interrupt` is IMPLICITLY reentrant (§4, §7), so its bespoke list of prohibitions becomes one
    // implication of a property anything can declare -- and a method that is not a handler but must
    // be equally careful (a scheduler entry, a page-fault path, a destructor during teardown) gains
    // a way to say so, which it did not have.
    //
    // VIRAL, which is the half that closes AP-12's hole for free: the obligation is inherited by
    // everything the method calls, including the implicit destructor at scope exit, because that is
    // a call and calls are checked.
    bool isReentrant = false;
    /* `readonly` -- THIS METHOD WRITES NOTHING, declared and then checked.
     *
     * Strict: no field of its own, no field of anything it was handed, no static, no output. The
     * analysis already existed -- `methodFacts_` computes what a body writes and composes it by
     * fixpoint over the call graph -- and what was missing was the DECLARATION. With it, an
     * inference becomes a promise: the compiler refuses the word over a body that writes, so a
     * reader who sees it does not have to go and check.
     *
     * It is what makes a method callable from a contract, which is the rule that needed it most: a
     * `requires` that could change state would make the check part of the program's behaviour.
     */
    bool isReadonly = false;
    /* `cold` -- THIS PATH IS RARELY TAKEN (B.3).
     *
     * The inliner costs a method by its SIZE, which is a poor proxy when the bulk of one runs once
     * in a thousand calls -- `ArrayList.ensureCapacity` is the case that asked for it. Marked cold,
     * the body moves off the hot line and stops being inlined into one.
     *
     * There is no `hot`. Hot is what the optimizer already assumes, so the word would spend a token
     * and tell the compiler nothing it did not have. It composes with `throw`: a path that ends in
     * one is already implicitly cold, and the keyword is for what cannot be inferred.
     */
    bool isCold = false;
    // `mustuse` on a METHOD (B.2): this one's answer is the point, so dropping it is a mistake.
    // The refinement beside the type-level default -- `Result` and `Option` carry it by nature, and
    // this is for the occasional method whose answer matters on a type that is otherwise ordinary.
    bool isMustUse = false;
    // Written `pass` rather than `method` (entity.md 5). The body is written for ONE ROW and runs
    // over the whole population: `swarm.advance(dt)` iterates. It is an ordinary instance method of
    // the entity -- the body says `x = x + vx * dt` and `x` is this row's -- plus a driver the
    // compiler synthesises over the array, so the two never disagree about what the body means.
    //
    // Without it, "advance every particle" becomes `static method advance(Particle[] ps)`, which is
    // a free function in a hat; this repository has written one by accident twice.
    bool isPass = false;
    // `pass advance(float dt) reads (vx, vy) writes (x, y)` -- the access sets (entity.md 6), in
    // the grammatical slot `returns`/`throws`/`requires`/`ensures` occupy.
    //
    // What they are FOR: two passes whose write sets are disjoint can run concurrently, PROVABLY,
    // and the proof is over columns rather than over pointer aliasing -- which is why it succeeds
    // where the object case cannot. `pure` is deliberately absent: it is a claim about a function,
    // from a paradigm whose unit is the function, and its content here is the degenerate case
    // `reads () writes ()`.
    std::vector<std::string> readsFields;
    std::vector<std::string> writesFields;
    // `pass advance(float dt) index i` -- the row's position, bound by the same word `foreach` uses
    // and in the same position. A BINDER, not a parameter: the caller does not supply it, which is
    // why it sits outside the parameter list where it would otherwise read as one. Empty when the
    // pass never asks, which is most of them.
    std::string indexBinding;
    // Written `procedure` rather than `method`. A METHOD's signature is fixed where it is declared;
    // a PROCEDURE's is completed at the type that applies it, which is the whole distinction and the
    // reason the second word exists. Checked in BOTH directions at the applying type -- `method` for
    // something a transformer brought is an error, and `procedure` for something no transformer
    // declares is too -- so provenance survives a terminal, a diff and a review, which is what
    // Java's `@Override` tries to be and fails at because it can be left out.
    bool isProcedure = false;
    /* Written `command` rather than `method`: PORTABLE behaviour, the third member kind beside
       `method` (an instance's) and `procedure` (a relation's). A command is a thing you hand to
       whoever knows WHEN to run it -- what a lambda is for, said with a subject and a name.

       `carries (...)` IS THE CAPTURE, DECLARED. Nothing is closed over implicitly: naming an outer
       local that is not on this list is a compile error, so what a command holds is its declaration
       and the region binder reads the list rather than discovering it. `into <pack>` names where
       that baggage lives, and inside the body it is reached qualified (`pack.minAge`) -- no language
       gives the environment of a closure a name, and this one does.

       `this` is never captured either. If the instance has to travel it goes on the list like any
       other value, so a command WITHOUT it provably does not hold its declaring object. */
    bool isCommand = false;
    std::vector<Param> carries;   // the baggage, in declaration order: the generated class's fields
    std::string packName;         // what the baggage is called inside the body; empty when there is none
    SourceLocation packLoc;
    // THE MEMBER A LAYOUT'S `resolvedBy` NAMES -- set by `resolveLayouts`, before the analyser runs,
    // on the target's own and on the layout's default alike.
    //
    // What it buys is one exemption, and it is the same one `onArrange` has: the body is READ and
    // never analysed as ordinary code. Inside it `itself` is the arrangement being decided rather
    // than any value the program can hold, and `itself.place(head)` names a FIELD where the analyser
    // would look for a variable -- so analysing it reports *use of undeclared variable 'itself'* on
    // a line whose whole purpose is to be read at build time. It is validated instead by
    // `readResolver`, which knows what the four verbs are and what they take.
    bool isLayoutResolver = false;
    // `procedure into<each Other>() returns Other;` -- a socket that names a FAMILY of procedures
    // indexed by the target type, one implementation per target, instead of one body over every T.
    //
    // The two are genuinely different features and the language wants both: `tag<T>(T v)` is one
    // algorithm over any T (ordinary generics, monomorphized); `into<Fahrenheit>()` is one of
    // several bodies, and only a per-target body can write `new Fahrenheit(...)`. Conversion --
    // Celsius/Fahrenheit, Errno/int, HidUsage/ScanCode -- is inexpressible without it.
    //
    // THE MARKER LIVES ON THE SOCKET, not on the implementation, and not on "is the name inside
    // <> already a type?". That last rule is decidable and poisonous: declaring a class named `T`
    // would silently change what `method foo<T>()` means in another file. Whoever designs the
    // relation decides whether it is per-target; whoever uses it writes nothing extra.
    bool isEachFamily = false;
    // Non-empty on a member copied out of a `freestanding` transformer, naming it. The bare-metal
    // subset is then applied to THIS body even when the program around it is hosted, which is the
    // whole point of the modifier: the author of the transformer learns, rather than the author of
    // the kernel that applies it.
    std::string freestandingFrom;
    // Set on a per-target conversion the compiler COMPOSED rather than the programmer wrote, naming
    // the intermediate types it went through ("Fahrenheit" for Celsius -> Fahrenheit -> Kelvin).
    // Only a `collective` transformer produces these, and they are listed in the generated docs --
    // a derived conversion that nobody can see is a conversion nobody can audit.
    std::vector<std::string> composedVia;
    // spec 22.6 generators: a method whose body yields. The synthesis pass (monomorphize) turns the
    // original method into a factory returning a synthesized Iterator class, and parks the original
    // body in a hidden twin flagged here. Codegen emits that twin as four raw functions
    // (<genSym>$start/$resume/$current/$free) whose resume is a yield-suspending state machine.
    bool isGeneratorBody = false;
    std::string genElem;  // the element type T of the Iterator<T> the generator produces
    std::string genSym;   // symbol prefix of its four raw functions, e.g. "Primes$upTo"
    std::string externConvention;  // "cdecl"/"stdcall"/"fastcall" when isExtern
    // `symbol("...")`: the linker name, when it differs from the Polaron name.
    //
    // Without this the C symbol IS the method's name, so binding `SDL_CreateWindow` forced a Polaron
    // method to be called `SDL_CreateWindow` -- foreign naming pushed into Polaron source, which is
    // the one thing the object model is meant to keep out. It has to be a string and not an
    // identifier: a mangled C++ symbol (`?f@@YAXXZ`, `_ZN3Foo3barEv`) is not an identifier in any
    // language, and being able to paste one here is what makes `cppdecl` usable without a mangler.
    std::string externSymbol;
    std::string name;
    std::vector<std::string> typeParams;  // generic method parameters: identity<T> -> ["T"]
    // A.3, per parameter: `fixed` binds at stamping, and a non-empty value type makes it a hole
    // where a NUMBER goes rather than a type -- `timesShape<fixed int N>`.
    std::vector<bool> typeParamFixed;
    std::vector<std::string> typeParamValueType;
    // spec 15.2: constraints on those parameters -- `clamp<T extends Numeric>` -> [{"T","Numeric"}].
    // Checked against the type arguments at monomorphization, like the class-level ones.
    std::vector<TypeBound> typeParamBounds;
    // `procedure into<Fahrenheit f>` -- the name the target is bound to inside the body, empty when
    // the slot names only a type. The target is raw storage the body must fill: every field assigned
    // by the end, proven by the same dataflow a constructor already passes, so no half-built object
    // is ever observable. The type it binds is `typeParams[0]`.
    std::string boundTarget;
    SourceLocation boundTargetLoc;
    bool boundTargetMutable = false;   // whether the NAME may be re-bound, as on a local
    std::string boundTargetType;       // the type bound, kept once the type parameter is cleared
    std::string boundTargetVia;        // the transformer whose family this is: what must be entrusted
    // The transformer this member was copied out of, empty when the type wrote it. Kept because
    // after expansion a copy is indistinguishable from a member somebody typed, and two questions
    // need to tell them apart -- whose consent a bound target needs, and who was there to write
    // `override`.
    std::string fromTransformer;
    // `when itself applies TComparer` -- this procedure is only copied into a type that satisfies the
    // condition. Empty when unconditional, which is nearly all of them. The subject is `itself`, the
    // applying type; the answer is read from the closure the expansion pass computes anyway.
    std::string whenSubject;
    std::string whenTransformer;
    SourceLocation whenLoc;
    // `invariant <expr>;` on a per-target procedure -- the LAW OF THE RELATION, as opposed to a
    // transformer-level `invariant`, which is about state. It becomes a `<name>Law$<Target>` method
    // on each applying type, answering true when the law holds AT THE RECEIVER: checkable rather
    // than checked, because a property test needs values and the compiler cannot invent them.
    ExprPtr law;
    std::vector<Param> params;
    TypeRef returnType;
    std::vector<TypeRef> throwsTypes;  // `throws(...)` declared exceptions (spec 21.1)
    // region-binder escape summary, so it survives across compilation units in the .polh. Each entry is a
    // pair (paramIndex, targetSlot) meaning "parameter paramIndex is stored into targetSlot", where slot
    // -1 = the receiver (`this`) and j>=0 = parameter j. Emitted as `escapes(i>t, ...)`; parsed back on
    // import; computed by the analyzer for local methods (written back here for emission).
    std::vector<std::pair<int, int>> escapeSummary;
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
    // spec 37.4: the INITIALIZER is evaluated during compilation. Not the same thing as `fixed`, which
    // is a class-level constant with no storage and no `mutable` -- a `comptime` field is an ordinary
    // field, possibly per-instance and possibly mutable, whose starting value costs nothing to produce.
    bool isComptime = false;
    // spec 18.7: `in region X` field placement, as WRITTEN. Kept only so the analyzer can say that it
    // currently does nothing -- measured, the IR is byte-identical with and without it.
    std::string inRegion;
    bool isExternal = false;    // spec 37.1: an association, not owned; cascade does not follow it
    // `delegate T f` -- this class satisfies its interfaces BY FORWARDING to this field. Every method an
    // interface declares and the class does not define is synthesized as `return this.f.m(args);`.
    // Composition instead of inheritance, without the boilerplate that is the real reason nobody chooses
    // composition: doing it by hand means writing N methods that say nothing but the forwarding itself.
    bool isDelegate = false;
    bool isMovable = false;     // spec 19.9: `movable` field -- movable separately (partitionable class)
    bool isUnique = false;      // spec 19.9: `unique` field -- single live reference, movable separately
    bool isWeak = false;        // `weak T*` field -- non-owning; auto-nulled when the pointee dies (intrusive)
    // `sparse` (entity.md 7): this column is stored BY PRESENCE rather than per row. The two ways
    // out without it are both bad -- a dense column of a million slots for the three thousand that
    // exist, or a side table beside the entity, and a side table is the type dissolving again,
    // which is the exact failure the construct answers.
    bool isSparse = false;
    // `stable` on a field: a pointer to it stays valid. The universal prefix's field spelling.
    bool isStableField = false;
    // spec 32.9: "hot" / "cold" when the field was declared inside an `affinity` block; "" otherwise.
    // A layout hint only: hot fields are packed first in the object and cold ones last, so a loop that
    // touches only the hot ones touches fewer cache lines.
    std::string affinity;
    TypeRef type;
    std::string name;
    int bitWidth = 0;  // `field : N` bit-field width (spec 11.1); 0 = not a bit-field
    std::string regionFlavor;    // spec 17 flavors: a `pool/stack/... region` field ("" = bump)
    bool regionGrowable = false; // spec 17: a `growable region` field
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
    SourceLocation nameLoc;   // the name itself; `loc` is the `public` that starts the declaration
    std::vector<std::string> typeParams;  // generic parameters, e.g. Box<T> -> ["T"]
    // Variance per type param (spec 15.3): "out" covariant, "in" contravariant, "" invariant.
    std::vector<std::string> typeParamVariance;
    /* CONST GENERICS (A.3): what each parameter is, and WHEN it binds.
     *
     * `class Matrix<fixed T, fixed int R, fixed int C>` has three parameters and two kinds. `T` is a
     * hole where a TYPE goes; `R` and `C` are holes where a NUMBER goes -- which is the thing the
     * language had no way to write, and why `Math.Matrix` carries its dimensions as runtime fields:
     * `get(r, c)` computes an index with a load, the type cannot be embedded in another, and
     * `multiply` accepts any matrix at all, so a 4x3 times a 7x9 compiles and fails at run time.
     *
     * `typeParamValueType` is empty for a type parameter and holds the value's type ("int") for a
     * value parameter. `typeParamFixed` says the parameter binds at STAMPING -- it participates in
     * the type's identity and is monomorphized.
     *
     * `fixed` is per parameter and does not spread: `<fixed T, int a>` means T is stamped and `a` is
     * not, which is the anti-modifier-infection rule. What a BARE parameter means is reserved rather
     * than spent -- a bare value parameter is runtime-bound (`mdspan`'s mixed extents) and a bare
     * type parameter is a runtime generic over a type descriptor -- and v1 refuses a bare value
     * parameter with a message saying so, so nobody spends the spelling on something else.
     */
    std::vector<bool> typeParamFixed;
    std::vector<std::string> typeParamValueType;
    // Constraint per type param, if any, from `<T extends X>` / `<T implements I>` / `<T applies T2>`.
    std::vector<TypeBound> typeParamBounds;
    bool isInterface = false;             // declared with `interface`
    // Declared with the namespace-level form `command Name(args) returns T;` -- the ROLE a command
    // plays, written where an API needs to name it. It is an interface with exactly one method, and
    // it is `isInterface` too, so everything downstream treats it as the interface it is; the flag
    // exists so `expandCommands` can find the roles a generated command class fits, and so a
    // diagnostic can say "command type" where the author wrote one.
    //
    // A ROLE, NOT A FORM: nothing implements it by name. `expandCommands` adds it to every command
    // class whose signature matches, which is what makes `Kennel.aboveAge(21)` usable as a
    // `DogTest*` without the command's author having heard of `DogTest`.
    bool isCommandType = false;
    /* `mustuse` on a TYPE (B.2): a value of it is the point of the call that produced it, so a
     * caller who drops one has almost certainly forgotten something.
     *
     * The DEFAULT belongs here rather than on each method. `Result` and `Option` are must-use by
     * nature -- a `Result` whose answer is thrown away is an error nobody handled, which is the
     * commonest bug this language's error model exists to prevent -- and stating it once on the
     * type covers every method that ever returns one, including the ones written next year. */
    bool isMustUse = false;
    // VALUE AGGREGATE. Set by `struct`, and ALSO by `record` and `union`, which are the same thing
    // under three field-arrangement policies: in sequence, in sequence with generated identity, and
    // overlapping. The name says `struct` for history; what it means is "a value aggregate", which is
    // the category `layout` applies to and the one three classes of defect have already clustered in.
    bool isStruct = false;
    bool isRecord = false;                // declared with `record` -- immutable value type
    bool isUnion = false;                 // declared with `union` -- fields share one storage
    // Declared with `entity` (docs/design/entity.md) -- a value type whose ARRAYS are transposed. A
    // lone entity is a struct and is laid out as one; what the word changes is `T[]`, which becomes
    // one block of columns rather than a run of rows. It sets `isStruct` too, because everything
    // about a single one -- value semantics, no vtable, no inheritance -- is what `struct` means.
    bool isEntity = false;
    // `stable entity` -- the rows never move, so an index into one is a permanent reference and
    // deletion leaves a hole rather than swapping the last row down. On any other declaration the
    // word means the same thing about that thing's address; the entity case is the one where it
    // changes what the compiler emits.
    bool isStable = false;
    // Declared with `layout` -- an interface for memory (not a species): it says how an implementing
    // value aggregate arranges itself, and is consumed entirely by the compiler. Never a type: no
    // variable has a layout type, no value is ever one, and nothing of it reaches the executable.
    bool isLayout = false;
    // Declared with `transformer`: what a type GAINS by applying it. Never instantiated, never a
    // type -- like `layout`, it is consumed by the compiler and nothing of it reaches the executable
    // under its own name. Kept in `Namespace::transformers`, never in `classes`, so nothing
    // downstream has to learn that some "classes" are not.
    bool isTransformer = false;
    bool isMutualTransformer = false;     // `mutual`: a pair must be symmetric, and it is checked
    bool isExplicitTransformer = false;   // `explicit`: only applied directly, never transported
    // `collective`: the relation ranges over EVERY type that applies this transformer, not over a
    // declared pair. `mutual` says a pair is symmetric; `collective` says the appliers form one
    // transformation set, so each of them can become any of the others. What makes it affordable
    // rather than N-squared is that the missing conversions are COMPOSED along the ones written:
    // three types need three procedures, not six.
    bool isCollectiveTransformer = false;
    // `freestanding`: the bodies obey the bare-metal subset, checked at the transformer instead of
    // in somebody else's kernel. Without it a transformer whose body interpolates a string or throws
    // compiles perfectly here and fails three layers down, on a line its reader never wrote.
    bool isFreestandingTransformer = false;
    // `transformer T satisfies I` -- whoever applies T implements I, and T's procedures are the
    // implementation. A separate word from `implements` because it is a separate act: the transformer
    // is never instantiated, so it cannot itself satisfy anything; what it does is make a promise ON
    // BEHALF OF the types that apply it. Without this clause the common case -- give me the code AND
    // make me polymorphic -- is written twice on every applying type, with nothing saying the second
    // half answers the first.
    std::vector<std::string> satisfies;
    std::vector<SourceLocation> satisfiesLocs;
    // A TRANSFORMER'S OWN SOURCE, kept verbatim so it can cross a bundle boundary.
    //
    // A `.polh` carries signatures, because that is all a caller of a compiled method needs. A
    // transformer is not compiled: it is expanded, and what the applying type receives is the BODY.
    // So a header that carried only its signatures would ship half the feature -- sockets would work
    // and every free implementation would vanish. The declaration has no runtime existence at all,
    // which is exactly why shipping its text is the honest thing rather than a shortcut: its source
    // IS its interface, the way a header-only template's is.
    //
    // Captured at parse time rather than printed back from the AST, because there is no AST-to-source
    // printer in this compiler and a second one written for this would drift from what the parser
    // accepts. What is stored is what was written.
    std::string sourceText;
    SourceLocation declEnd;   // the closing brace, so the span above can be sliced
    // The transformers this type applies. A separate clause from `implements` on purpose: the class
    // line runs identity -> obligation -> equipment. `implements` is a promise made to the outside
    // world; `applies` is equipment, purely additive, and nobody outside needs to know about it.
    std::vector<std::string> applies;
    std::vector<SourceLocation> appliesLocs;  // per entry, so a diagnostic points at the right name
    // The same set closed over `transformer A applies B`, filled in by the expansion pass, which
    // already computes it to know what to copy. Kept BESIDE `applies` and not folded into it because
    // `applies` is what the author wrote and is printed back as such by the documentation generator.
    // It is what a `<T applies TComparer>` constraint is checked against, long after transformers
    // themselves are gone from the tree.
    std::vector<std::string> appliedClosure;
    // Of those, the ones written with `entrusts` rather than `applies`: this type consents to being
    // ASSEMBLED by their procedures -- storage handed over field by field, with no constructor of its
    // own running first. It is the one grant a class cannot be given from outside, because what is
    // being handed over is the right to establish its invariants.
    std::vector<std::string> entrusts;
    // Every `call T.p()` written inside this type, recorded at the parse site. Kept as a list rather
    // than found by walking the bodies later: the expansion pass needs to check that T is applied
    // here and that `p` is reachable, and a second full traversal to rediscover what the parser had
    // in its hand is exactly the kind of walk that goes silently out of date.
    struct ProcCall {
        std::string transformer;
        std::string procedure;
        SourceLocation loc;
    };
    std::vector<ProcCall> procCalls;
    // `error Failed;` inside a transformer -- the failure type it declares for its own conversions,
    // so a failure names the conversion that failed instead of surfacing as somebody else's
    // exception. Synthesized as an ordinary class in the transformer's namespace.
    std::vector<std::pair<std::string, SourceLocation>> errorTypes;
    bool isAbstract = false;              // `abstract class` (interfaces are abstract too)
    bool isFinal = false;                 // `final class` -- cannot be extended
    bool isSealed = false;                // `sealed` -- only `permits` types may extend it
    bool isPartial = false;               // spec 8.3: this is one part of a class split across declarations
    bool isMovable = false;               // `movable class` -- move discipline
    // spec 36: `heap class X` -- THIS class provides the program's heap. In freestanding there is no libc
    // to allocate from, so `new T() on heap` (and dynamic arrays) route to its static allocate/release.
    // Exactly one per program. It is legitimately static: the allocator IS the bottom of the memory
    // system, so it cannot own heap state -- the same reason the physical frame allocator is static.
    // `region class A`: every instance comes from ONE region owned by the type, and that region holds
    // nothing else. The class is implicitly `sealed` -- a fixedslot region has one slot size, and a
    // subclass with more fields does not fit it.
    // `class Sdl library SDL2` -- the logical name of the foreign library this class's externs live in.
    // Logical because the real file differs per platform (SDL2.lib, libSDL2-2.0.so.0), and that mapping
    // belongs in the manifest rather than in the source.
    std::string foreignLibrary;
    bool isRegionClass = false;
    bool isHeap = false;
    bool isUnique = false;                // `unique class` -- single live reference
    // `dynamic class X` (docs/design/dynamic.md): the instance CARRIES ITS TYPE at run time -- a
    // vtable pointer as field zero, eight bytes on every instance, and membership of the `Object`
    // root so it can be held as one, asked `is`, and dispatched through.
    //
    // Without it a class is its fields, and that is the whole of AP-02: `class Tag`, which nothing
    // extends and nothing overrides, was eight bytes wide because nobody had written anything. C++
    // hangs the same cost on a per-method `virtual` and lets the header appear as a side effect the
    // declaration does not mention; here one word says both which bodies are chosen at run time and
    // which types are known at run time, and a class that does neither pays for neither.
    //
    // NOT INFERRED (§7.1). A class used as an `Object*` without the word is a compile error naming
    // the word and the eight bytes, rather than being marked dynamic because the use was seen --
    // inference needs whole-program knowledge, breaks across a bundle boundary, and moves the cost
    // away from the declaration, which is the one property the design rests on.
    bool isDynamic = false;
    // `shareable class X` / `shareable struct X` (ownership.md §13a, §14, §20.4): safe to reach from
    // several threads at once, so the region binder may hand it to a thread.
    //
    // A MODIFIER rather than the `implements Shared` marker it started as. Three reasons, and the
    // third forces it: it is an adjective, not a contract with methods; `implements` reads as
    // *dispatches something* and it dispatches nothing; and under `dynamic` a class that implements
    // an interface carries a header -- so a value type declaring itself shareable would acquire
    // eight bytes and an indirection for a property that generates no calls. That cost is invisible
    // at the declaration, which is the one thing this language's cost story forbids.
    //
    // CHECKED, NOT TRUSTED (§14), and the rule is local: legal when every mutable field is
    // `atomic<T>` or itself shareable, or when the type is entirely immutable. A bare permission
    // would be a one-word hole in the no-UB principle, and trading the refusal for a password hands
    // AP-33 back after winning it.
    bool isShareable = false;
    bool isPartitionable = false;         // `partitionable class` -- fields movable separately (spec 19.9)
    std::string superclass;               // "" when none (from `extends`)
    std::vector<std::string> superclassTypeArgs;  // type args on `extends Base<...>` (generics)
    std::vector<std::string> interfaces;  // from `implements`
    // The layouts this type is arranged by -- written `arranges L`, and still read out of
    // `implements L`, from which they are moved before the analyser runs so that everything
    // downstream keeps seeing a list of interfaces only. A layout has no methods to implement and
    // no vtable slot; it decides how the fields are arranged and then is gone.
    std::vector<std::string> layouts;
    std::vector<std::vector<std::string>> interfaceTypeArgs;  // type args per interface (generics)
    std::vector<std::string> permits;     // sealed permits list (subtypes)
    // WHAT A LAYOUT CONCEDES -- `layout Compact permits reorder, padding`. Read off the same
    // `permits` list a `sealed` class uses, because it is the same sense of the word about a
    // different noun: there it is the closed set of what may extend, here the closed set of what
    // the compiler is allowed to DO to reach an arrangement.
    //
    // BOTH DEFAULT TO FALSE, AND THAT IS THE WHOLE POINT OF THE SECOND DESIGN. Reordering used to
    // be granted by the act of naming a layout at all, which made a wire format -- the case the
    // repository's own `WireRecord` sample is written for, whose comment says *both ends index it*
    // -- silently reorderable. Two declarations of the same record with the fields written in
    // different orders both measured 32 bytes, both compiled, and disagreed on every offset.
    bool permitsReorder = false;
    // `padding`: bytes beyond what alignment requires. `isolate` and `align` are both spellings of
    // inserting them deliberately, so both need this and neither is free (docs/design/layout.md
    // 13.4) -- a layout that concedes nothing must come back with the bytes it was written for.
    bool permitsPadding = false;
    std::vector<ExprPtr> invariants;      // class invariants (spec 29), checked per method
    std::unique_ptr<Block> onClassLoad;   // spec 32.5: hook run once at program start, before main
    std::unique_ptr<Block> onFirstInstance;          // spec 32.5: before the first instance is created
    std::unique_ptr<Block> onLastInstanceDestroyed;  // spec 32.5: after the last instance is destroyed
    std::unique_ptr<Block> onClassUnload;            // spec 32.5: on unimport (deferred: needs unimport)
    // A `layout`'s arrangement hook. Same shape as the lifecycle hooks above -- a block nobody calls --
    // but a different MOMENT: those run in the built program, this one runs during the build and
    // leaves nothing behind. So it is read by the compiler rather than analyzed and emitted as code,
    // and inside it `itself` is the arrangement being decided, not any value the program can hold.
    std::unique_ptr<Block> onArrange;
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
    // The PAYLOAD of each case (spec 16, enum-variants 10.1): `enum Shape { Circle(double r), ... }`.
    // Parallel to `constants`, empty for a case that carries nothing. This is what separates a sum
    // from an ordinal enum: a java-style constant carries the same data for every use of that
    // constant -- `RED(255)` is one red -- where a case with a payload carries data chosen at each
    // construction, so `Circle(r)` is a different circle each time. The two spellings look alike,
    // both being `NAME(...)`, and are told apart by what is inside the parentheses: expressions for
    // one, `Type name` declarations for the other. See `payloadCaseAhead`.
    std::vector<std::vector<Param>> constantPayloads;
    // `enum Option<T> { Some(T value), None }`. The parameters are what make the payload SIZED:
    // `Option<T>` has no known width, `Option<int>` is four bytes and a tag, decided by the same
    // monomorphisation that decides `Box<int>`'s layout (enum-variants 10.1).
    //
    // The variance and bounds grammar comes over from the class line unchanged, because a sum's
    // parameters constrain exactly as a class's do: `enum Sorted<T extends Comparable<T>>` means
    // what it looks like. They are carried straight onto the desugared base and each case.
    std::vector<std::string> typeParams;
    std::vector<std::string> typeParamVariance;
    std::vector<TypeBound> typeParamBounds;
    std::vector<MemberPtr> members;                // java-style: fields/constructor/methods
    bool isJavaStyle = false;
    // Set when any case declares a payload: the enum is a SUM, and the desugaring at the parse site
    // turns it into the sealed hierarchy that `Result`/`Option` are written out as by hand.
    bool isSum = false;
    // `sealed enum E permits A, B, C;` (spec 12/16). An enum's constants are a closed list either
    // way -- what the word buys is that a `match` over it must COVER them, with the compiler naming
    // the ones that were forgotten, instead of quietly requiring a `default` that swallows the
    // constant added next year.
    bool isSealed = false;
    // The transformers this enum applies. An enum is the flagship of the totality rule -- `Errno ->
    // int` is total because the constants are a finite list you own -- so it has to be able to take
    // the clause that carries the conversion. Its constants stay ordinals; what it gains is members.
    std::vector<std::string> applies;
    std::vector<SourceLocation> appliesLocs;
    std::vector<ClassDecl::ProcCall> procCalls;    // every `call T.p()` written in this enum's body
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
    SourceLocation nameLoc;   // the name itself, not the `public` that starts the declaration
    std::vector<ClassDecl> classes;
    // Transformers live apart from classes because they are not types. `expandTransformers` copies
    // their members into every type that applies them and nothing else ever looks here, so no later
    // pass has to know the difference -- the same treatment `layout` gets, for the same reason.
    std::vector<ClassDecl> transformers;
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
    // spec 2.7/2.8: `import from program GameEngine bundle audio.mixers.StereoMixer;` -- the type lives
    // in ANOTHER PROGRAM and is reached over IPC. Empty for an ordinary import.
    std::string programName;
    bool isFinal = false;           // `final import` (spec 37.6): the symbol cannot be unimported
    bool isLazy = false;            // `lazy import` (spec 37.3): load on first instance, not at boot
    SourceLocation loc;
};

struct Bundle {
    std::string visibility;
    std::string name;
    // WHERE THE NAME IS, which is not where the declaration starts.
    //
    // `loc` is the `public` keyword, because that is where parsing began. A diagnostic ABOUT THE NAME
    // pointed there instead: `bundle 'main' should start with a capital letter` put its caret under
    // `public`, fourteen columns from the word it was talking about. A caret that points at the wrong
    // token is worse than no caret -- it sends the reader to inspect something that is not the subject.
    SourceLocation nameLoc;
    bool isFreestanding = false;  // `bundle X freestanding { ... }` (spec 36)
    bool isPrelude = false;       // from the embedded prelude, not user source; excluded from the .polh
    // Appended by the compiler as part of the runtime -- the region core, the freestanding seed. Its
    // `unknown c` methods carry a C ABI because the compiler emits calls to them by name, but every
    // one of those calls is in this same module: they are not a boundary, and internalization must
    // not keep them alive on a program that never reaches one. See `Function::appendedRuntime`.
    bool isAppendedRuntime = false;
    bool isImported = false;      // from a depended-on .polb (parsed from its .polh): types are visible,
                                  // but bodies live in the .polb -- sema skips them, codegen externs them
    bool isDynamic = false;       // imported via --use-dynamic: loaded at runtime; codegen emits thunks
                                  // that load the .polb and resolve the symbol instead of linking it
    bool isRemote = false;        // imported via --use-remote (spec 2.8): its code runs in ANOTHER
                                  // PROGRAM; the compiler synthesizes IPC proxies for its classes
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
    bool usesIpcServe = false;    // spec 2.8: the program calls Program.serve, so it needs a dispatcher
    // Internal names produced by namespace disambiguation (e.g. app__Box). These are
    // already explicitly scoped, so they bypass the import/visibility requirement.
    std::set<std::string> qualifiedTypes;
    // Base name -> the namespaceS declaring a generic class of that name, captured before
    // monomorphization erases the templates. Lets the type checker enforce imports on a collection
    // (ArrayList) by its base name.
    //
    // A LIST AND NOT ONE NAMESPACE: a program may declare its own `Stack` while the standard library
    // declares `Collections.Stack`, and with a single slot the second registration overwrote the
    // first -- so the checker told an author to import a type they had declared themselves. Both
    // exist; which one a use means is decided by where the use is, and that decision needs both.
    std::map<std::string, std::vector<std::string>> genericNamespaces;
    /* EVERY METHOD NAME A `methodref` IN THIS PROGRAM NAMES.
     *
     * `methodref cat.speak` is a receiver bound to a method, which is a command carrying one thing.
     * The class that expresses it is generated -- see `expandCommands` -- and generating one per
     * (class, method) pair in the program would be an explosion for a construct most programs use
     * nowhere. The parser is already walking every expression, so it writes down the handful of
     * names that are actually referenced and the generator works from that list.
     *
     * Collected in the PARSER rather than by a later walk, for the reason every rewrite in this
     * pipeline is: a second visitor over the tree goes out of date the first time a node kind is
     * added, quietly, and only here. */
    std::set<std::string> methodRefNames;
    SourceLocation loc;
    void dump(std::string& out, int indent) const;
};

}  // namespace polaron::ast

namespace polaron {

// THE METHOD EVERY COMMAND CLASS ANSWERS TO. One name for all of them, so a value of a command type
// is callable without the caller knowing which command it holds -- the same role a single-method
// interface plays, with the name chosen so nothing an author writes can collide with it.
//
// A HEADER CONSTANT, because the parser needs it and the language server links the parser WITHOUT
// the expansion pass: defined in a .cpp it was an unresolved symbol in one binary out of five, and
// that binary is the one nobody builds while working on the compiler.
inline constexpr const char* kCommandMethod = "__command";

}  // namespace polaron
