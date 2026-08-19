#pragma once

#include <string>
#include <string_view>

// Rich diagnostics: every error and warning explains what happened, why it is an error, how to fix it
// here, and how to prevent it next time. A diagnostic call-site names the specific thing (the title); the
// canonical why/fix/prevent for the RULE live once, in the catalog (catalog.cpp), keyed by a stable code.
namespace polaron::diag {

// A stable diagnostic code. Code::None means "no rich entry yet" -- the diagnostic still prints, as a
// clean one-liner, rather than with fabricated prose. Codes are grouped by kind (01xx naming, 02xx
// visibility, 03xx types, 04xx mutability/ownership, 05xx control flow, 06xx declarations, ...); the exact
// numbers are stable once shipped, so `polaron explain Polaron-0101` keeps meaning the same thing.
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
    MoveRequired,         // a `movable` value bound somewhere without the explicit `move`
    // THE REGION BINDER REFUSES FOR FOUR DIFFERENT REASONS, and for a while all four printed the same
    // explanation -- the one about frames, which is wrong prose for three of them. A code exists so
    // that `why` and `fix` can say what actually happened; sharing one across unrelated rules gives
    // the reader confident advice for a mistake they did not make, which is worse than no advice.
    RegionIncomparable,   // two different objects, and nothing in the program orders their deaths
    RegionForeignBoundary,  // a pointer handed to an `extern`, where no proof is available at all
    RegionUseAfterInvalidate,  // a borrow read after the object it came from was emptied

    // 07xx -- literals and I/O builtins
    LiteralSuffix,        // an unknown or misused literal suffix
    StringInterp,         // a string interpolation of an unprintable value
    PrintfFormat,         // a printf/println whose format argument is not a string literal

    // 08xx -- features used incorrectly
    OperatorOverload,     // a malformed operator overload
    ReflectionMisuse,     // reflect.* used without the import, or wrongly
    RegionMisuse,         // a region declaration or `new in region` used wrongly
    RegionTwoFlavors,        // Polaron-1710: two reclaim flavors on one region (e.g. `pool stack region`)
    RegionFlavorOnNonRegion, // Polaron-1719: a flavor modifier (pool/stack/...) on a non-region declaration
    RegionUseAfterExtract,   // Polaron-1717: use of a variable after `extract X from region R`
    RegionExtractInnerField, // Polaron-1718: extract/delete of an object whose field lives in the same region
    RegionExtractNotBound,   // Polaron-1720: an `extract` result not bound to a variable/field
    RegionMarkNonStack,      // Polaron-1713: mark/rollback on a non-stack region
    RegionCheckpointWrongRegion,  // Polaron-1714: rollback with a checkpoint from another region
    RegionFixedslotAcceptsRequired,  // Polaron-1711: fixedslot/ring without .accepts({T}) of one type
    RegionRingNoDelete,      // Polaron-1715: delete X from a ring region (it auto-evicts)
    RegionGrowableContradiction,  // Polaron-1712: growable + ring / at-address / stack
    VectorMisuse,         // a vec/mat operation with the wrong shape or component
    UnimportMisuse,       // unimport/reimport used wrongly
    Demand,               // a `demand` that did not hold, or whose condition was not constant
    ComptimeConstant,     // a value required to be a compile-time constant but is not
    PersistentLifecycle,  // a persistent with no `release persistent` in the program

    NoEntryPoint,         // a program with no `public static method main` anywhere
    DuplicateConstructor, // a second constructor, in a language with no overloading
    ShadowsBuiltinType,   // a user type with the name of one the compiler provides
    FieldNeverAssigned,   // a constructor that leaves a field of the new object unset
    WeakNeedsPointer,     // `weak` on something that is not a pointer
    ImportNameMismatch,   // a name used differently from how the import brought it in
    BitFieldRange,        // a literal that does not fit the declared width of a bit field
    AtomicTooWide,        // an `atomic<T>` wider than the machine can do without a lock

    // 08xx -- features used incorrectly (continued below the older entries)
    InterruptMisuse,      // an interrupt handler that is called, duplicated, or reaches what it must not
    TransformerMisuse,    // a transformer contract a type does not meet, or a procedure that names no subject
    TestDeclaration,      // a [Test]/[Setup]/[Cases] annotation on something that cannot carry it

    // 09xx -- context restrictions
    FreestandingRestriction,  // a feature unavailable in freestanding mode (spec 36.3)

    AnnotationMisuse,     // an applied `[Name(...)]` that does not match the annotation's declaration

    // 0Axx -- not-yet-implemented corners
    NotSupportedYet,      // a valid construct the current compiler does not implement yet

    // 0Bxx -- ADVICE. These arrive as warnings: the program compiles and runs, and something about it
    // is likely to be a mistake or is likely to become one. A warning needs its `why` more than an
    // error does, not less -- an error at least stops you, while a warning is only worth printing if
    // the reader can tell from it whether it applies to them. Measured before these existed: 1309
    // warnings across the test corpus and exactly one of them carried a code.
    NamingConvention,     // a bundle/namespace/transformer named against the language's convention
    ShadowsStdlibType,    // a user type with the same short name as one in the standard library
    ShadowsField,         // a local whose name hides a field of the enclosing class
    UndeclaredThrow,      // an exception a method can raise and neither catches nor declares
    ClassPointerArith,    // arithmetic on a pointer to a class, which usually points at one object
    MutatesByValueParam,  // a mutating call on a parameter received by value (the caller sees nothing)
    ForeignSymbolMismatch,   // an `extern` whose convention and the symbol it binds disagree
    Deprecated,           // a call to something marked deprecated
    PersistentIdentity,   // a persistent keyed by identity because its key fields are values
    FixtureLifecycle,     // a test reading a fixture whose [BeforeAll]/[AfterAll] it does not run
    StringBuildingInLoop, // `s = s + piece` on an immutable String inside a loop -- quadratic
    AllowNeverUsed,       // an `[Allow]` that suppressed nothing: the shape it excused is gone
    MutableNeverMutated,  // `mutable` on something nothing ever assigns to
    SwallowedCatch,       // a `catch` whose body neither rethrows, reports nor records
    AsyncNeverAwaits,     // an `async` method with no `await` in it -- a scheduler for nothing
    StaticsWithoutState,  // a class that is only static methods: a namespace, or a transformer
    DataWithoutBehaviour, // public fields, no methods, no invariant: a `record`
    ConstantsThatAreAnEnum,  // int constants sharing a prefix: a set kept by hand
    StaticTakesItsOwnClass,  // a static method whose first parameter is its own class
    HungarianNotation,    // a name whose prefix spells the type the declaration already gives
    DefaultOverAClosedSet,   // a `default` over an enum or a sealed type, whose members are known
    IfChainIsAMatch,      // three or more `else if`s comparing the same thing against a value
    RepeatedMagicNumber,  // one number written out three or more times in a method
    ThrowCaughtHere,      // a try that raises and catches its own exception: local control flow
    ResultNeverExamined,  // a call returning Result/Option whose statement drops it
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
// by inline rendering and `polaron explain`. All are plain sentences; the renderer wraps them.
struct Entry {
    std::string_view codeStr;   // "Polaron-0101"
    std::string_view caret;     // short label under the ^^^ (e.g. "not declared in this scope")
    std::string_view why;       // why this is an error -- the rule
    std::string_view fix;       // how to fix it here
    std::string_view prevent;   // how to avoid it next time
};

// The catalog entry for a code. `Code::None` returns an empty entry (all fields "").
const Entry& entry(Code code);

// Look up an entry by its code string ("Polaron-0101"), for `polc --explain`. Null if unknown.
const Entry* entryByCodeString(std::string_view codeStr);

// The code string for a code ("Polaron-0101"), or "" for Code::None.
std::string codeString(Code code);

// Every known code string, for `polc --explain` with no argument (a listing).
std::string allCodesListing();

}  // namespace polaron::diag
