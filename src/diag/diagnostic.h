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

    // 01xx -- naming and resolution
    UndeclaredVariable,   // read of a name bound to nothing in scope
    NoSuchField,          // obj.field where the class has no such field
    NoSuchMethod,         // obj.method() where the class has no such method
    UnknownType,          // a type name that resolves to no declared type

    // 02xx -- visibility
    NotAccessible,        // a private/internal member reached from outside its allowed scope

    // 03xx -- types
    TypeMismatch,         // a value of one type where another is required
    ArgCount,             // a call with the wrong number of arguments
    ReturnTypeMismatch,   // a return value that does not match the method's declared return type

    // 04xx -- mutability and ownership
    AssignImmutable,      // assignment to a value not declared mutable
    UseAfterMove,         // use of a value after it was moved out

    // 05xx -- control flow
    MissingReturn,        // a non-void method that can reach its end without returning

    // 06xx -- declarations
    Redeclaration,        // two declarations of the same name in the same scope
    DuplicateField,       // two fields with the same name in one class
};

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
