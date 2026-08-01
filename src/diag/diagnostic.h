#pragma once

#include <string>
#include <string_view>

// Rich diagnostics: every error and warning explains what happened, why it is an error, how to fix it
// here, and how to prevent it next time. A diagnostic call-site names the specific thing (the title); the
// canonical why/fix/prevent for the RULE live once, in the catalog (catalog.cpp), keyed by a stable code.
namespace ldp3::diag {

// A stable diagnostic code. Code::None means "no rich entry yet" -- the diagnostic still prints, as a
// clean one-liner, rather than with fabricated prose. Codes are grouped by kind (01xx naming, 02xx
// visibility, 03xx types, 04xx mutability/ownership, 05xx control flow, 06xx declarations, ...); the exact
// numbers are stable once shipped, so `ldp3 explain LDP3-0101` keeps meaning the same thing.
enum class Code {
    None = 0,

    // 00xx -- lexing and parsing
    SyntaxError,          // the parser expected different syntax here
    LexError,             // the lexer could not tokenize the source here

    // 01xx -- naming and resolution
    UndeclaredVariable,   // read of a name bound to nothing in scope
    NoSuchField,          // obj.field where the class has no such field
    NoSuchMethod,         // obj.method() where the class has no such method
    UnknownType,          // a type name that resolves to no declared type
    UnknownName,          // an unknown class/region/label/symbol/import referenced by name

    // 02xx -- visibility
    NotAccessible,        // a private/internal member reached from outside its allowed scope

    // 03xx -- types
    // Null safety has its own code because it has its own REMEDY. Folded into TypeMismatch it inherited
    // "convert explicitly with cast<T>(value)", which is advice that cannot work: null does not become a
    // non-nullable value by casting. The fix is always one of three specific things, and the code is what
    // lets us say which.
    NullSafety,           // null (or a `nullable T`) reaching a non-nullable type
    TypeMismatch,         // a value of one type where another is required
    ArgCount,             // a call with the wrong number of arguments
    ReturnTypeMismatch,   // a return value that does not match the method's declared return type
    ArgType,              // an argument whose type does not match the parameter
    BadCast,              // a cast between types that cannot convert
    BadIndex,             // indexing a non-array, or with a non-integer
    BadOperand,           // an operator applied to an operand of the wrong type

    // 04xx -- mutability and ownership
    AssignImmutable,      // assignment to a value not declared mutable
    UseAfterMove,         // use of a value after it was moved out
    MoveMisuse,           // moving something that cannot be moved (a field, an immutable)
    InvalidAssignTarget,  // assigning to / incrementing something that is not an assignable place

    // 05xx -- control flow
    MissingReturn,        // a non-void method that can reach its end without returning
    MatchNotExhaustive,   // a match/switch that does not cover every case and has no default
    TryContext,           // `try?` used outside a method returning Result/Option
    TryErrorType,         // `try?` propagates a failure the enclosing method's type cannot carry

    // 06xx -- declarations and inheritance
    Redeclaration,        // two declarations of the same name in the same scope
    DuplicateField,       // two fields with the same name in one class
    DuplicateMember,      // a duplicated enum constant / catalog value / argument name
    InheritanceCycle,     // a class/catalog that (transitively) extends itself
    IllegalExtend,        // extending a final/sealed type that forbids it
    IllegalOverride,      // overriding a final method
    ConstraintNotMet,     // a type argument that does not satisfy a generic bound
    ContradictoryModifiers,  // modifiers that cannot combine (e.g. unique + partitionable)
    StaticInitNotConst,   // a static field's initializer cannot be evaluated before the program runs
    EscapesFrame,         // a pointer/reference to this activation's own storage leaving the activation

    // 07xx -- literals and I/O builtins
    LiteralSuffix,        // an unknown or misused literal suffix
    StringInterp,         // a string interpolation of an unprintable value
    PrintfFormat,         // a printf/println whose format argument is not a string literal

    // 08xx -- features used incorrectly
    OperatorOverload,     // a malformed operator overload
    ReflectionMisuse,     // reflect.* used without the import, or wrongly
    RegionMisuse,         // a region declaration or `new in region` used wrongly
    RegionTwoFlavors,        // LDP3-1710: two reclaim flavors on one region (e.g. `pool stack region`)
    RegionFlavorOnNonRegion, // LDP3-1719: a flavor modifier (pool/stack/...) on a non-region declaration
    RegionUseAfterExtract,   // LDP3-1717: use of a variable after `extract X from region R`
    RegionExtractInnerField, // LDP3-1718: extract/delete of an object whose field lives in the same region
    RegionExtractNotBound,   // LDP3-1720: an `extract` result not bound to a variable/field
    RegionMarkNonStack,      // LDP3-1713: mark/rollback on a non-stack region
    RegionCheckpointWrongRegion,  // LDP3-1714: rollback with a checkpoint from another region
    RegionFixedslotAcceptsRequired,  // LDP3-1711: fixedslot/ring without .accepts({T}) of one type
    RegionRingNoDelete,      // LDP3-1715: delete X from a ring region (it auto-evicts)
    RegionGrowableContradiction,  // LDP3-1712: growable + ring / at-address / stack
    VectorMisuse,         // a vec/mat operation with the wrong shape or component
    UnimportMisuse,       // unimport/reimport used wrongly
    StaticAssert,         // a failed or non-constant static_assert
    ComptimeConstant,     // a value required to be a compile-time constant but is not
    PersistentLifecycle,  // a persistent with no `release persistent` in the program

    // 09xx -- context restrictions
    FreestandingRestriction,  // a feature unavailable in freestanding mode (spec 36.3)

    // 0Axx -- not-yet-implemented corners
    NotSupportedYet,      // a valid construct the current compiler does not implement yet
};

// Infer a code from a diagnostic message, for the many call-sites that pass no explicit code. First
// matching rule wins; an unmatched message stays Code::None (a clean one-liner). This is what makes every
// error rich without editing every call-site -- the mapping lives in one reviewable table (catalog.cpp).
Code classify(std::string_view message);

// The process-wide concise flag, so subsystems that print diagnostics on their own (e.g. monomorphize)
// can honour --check / --concise without threading the flag through. Set once by the driver.
void setConcise(bool concise);
bool conciseMode();

// The rich payload attached to a SemaError/LexError/etc. Empty (Code::None) renders as a plain one-liner.
struct Rich {
    Code code = Code::None;
};

// A catalog row: the canonical rich explanation for a code. `title` is supplied dynamically at the
// call-site (it names the specific thing); caret/why/fix/prevent are the fixed prose for the RULE, shared
// by inline rendering and `ldp3 explain`. All are plain sentences; the renderer wraps them.
struct Entry {
    std::string_view codeStr;   // "LDP3-0101"
    std::string_view caret;     // short label under the ^^^ (e.g. "not declared in this scope")
    std::string_view why;       // why this is an error -- the rule
    std::string_view fix;       // how to fix it here
    std::string_view prevent;   // how to avoid it next time
};

// The catalog entry for a code. `Code::None` returns an empty entry (all fields "").
const Entry& entry(Code code);

// Look up an entry by its code string ("LDP3-0101"), for `ldp3c --explain`. Null if unknown.
const Entry* entryByCodeString(std::string_view codeStr);

// The code string for a code ("LDP3-0101"), or "" for Code::None.
std::string codeString(Code code);

// Every known code string, for `ldp3c --explain` with no argument (a listing).
std::string allCodesListing();

}  // namespace ldp3::diag
