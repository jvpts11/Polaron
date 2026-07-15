#include "diag/diagnostic.h"

#include <array>

// The diagnostic catalog: for each code, the canonical why / how-to-fix / how-to-prevent. Written once
// here, per rule, so the wording stays consistent everywhere it appears -- the terminal, `ldp3 explain`,
// and the Forge hover. The call-site supplies only the specific title (the names and types involved).
namespace ldp3::diag {

namespace {
// Order does not matter; entry() indexes by Code, so keep the table keyed explicitly.
struct Row {
    Code code;
    Entry entry;
};

// clang-format off
constexpr std::array<Row, 13> kCatalog = {{
    {Code::UndeclaredVariable, {
        "LDP3-0101",
        "not declared in this scope",
        "A name must be declared before it is read -- as a local (var/mutable), a parameter, a field "
        "(via this.), or a namespace constant. This name matches nothing visible here, which is almost "
        "always a typo or a missing declaration.",
        "If it is a typo, use the suggested name. Otherwise declare it before this point, e.g. "
        "`mutable int name = ...;`, or -- for a field -- write `this.name` and add the field to the class.",
        "Let the editor autocomplete names (Ctrl+Space in Forge). Forge's live check flags an undeclared "
        "name as you type, and Alt+Enter applies the suggested fix." }},

    {Code::NoSuchField, {
        "LDP3-0102",
        "no such field on this type",
        "A field must be declared in the class (or a superclass) before it can be read or assigned. The "
        "type here declares no field by this name, so the access cannot resolve.",
        "Use the correct field name (see the suggestion, if any), or add the field to the class: "
        "`public mutable T name;`. If you meant a method, call it with `()`.",
        "Member autocomplete after `this.` or `obj.` lists the real fields. Keeping one class per concern "
        "makes its fields easy to remember; the structure panel (Ctrl+F12) shows them at a glance." }},

    {Code::NoSuchMethod, {
        "LDP3-0103",
        "no such method on this type",
        "A method must be declared on the type (or a superclass/interface it has) before it can be called. "
        "The receiver's type exposes no method by this name.",
        "Call an existing method (member autocomplete lists them), or declare the method on the class. "
        "Check the receiver's type is what you expect -- a wrong type is a common cause.",
        "Member autocomplete and go-to-definition (F12) confirm a method exists before you call it. "
        "Interfaces make the available methods explicit at the call site's declared type." }},

    {Code::UnknownType, {
        "LDP3-0104",
        "unknown type",
        "Every type name must resolve to a declared class, interface, enum, record, struct, or a built-in "
        "primitive. This name resolves to none of them -- it is misspelled, not imported, or not declared.",
        "Spell the type as declared, add the missing `import <bundle>.<namespace>.<Type>;`, or declare the "
        "type. Cross-namespace types need an import even within the same program.",
        "Import autocomplete completes type names as you type the import. The stdlib browser (F1) lists "
        "every built-in type; the structure panel lists the project's own." }},

    {Code::NotAccessible, {
        "LDP3-0201",
        "not accessible from here",
        "A member's visibility limits where it can be used: `private` is its own class only, `protected` "
        "adds subclasses, `internal` is the same bundle, `public` is everywhere. This access is outside "
        "the member's allowed scope.",
        "Access it from an allowed scope, widen the member's visibility if that is intended (e.g. make it "
        "`public`), or add a public method that exposes what you need instead of the field directly.",
        "Decide a type's public surface up front and keep internals `private`; reach them through methods. "
        "Explicit visibility on every member (LDP3 requires it) keeps the boundary in view." }},

    {Code::TypeMismatch, {
        "LDP3-0301",
        "wrong type here",
        "LDP3 is statically typed: a value's type must match where it is used. Assignment, arguments, and "
        "returns do not convert types implicitly, because a silent conversion is where bugs hide.",
        "Produce a value of the expected type, or convert explicitly with `cast<T>(value)` when the "
        "conversion is intended and safe. Check you are using the variable you think you are.",
        "Name types clearly and let `var` infer locals from an obviously-typed initializer. Forge's hover "
        "shows a value's type, so a mismatch is visible before you build." }},

    {Code::ArgCount, {
        "LDP3-0302",
        "wrong number of arguments",
        "A method is called with exactly its declared parameters -- LDP3 has no overloading, so one name "
        "means one signature. Too few or too many arguments cannot match it.",
        "Pass exactly the declared parameters, in order. Signature help (in Forge, inside the `(`) shows "
        "them; check the method's declaration if unsure.",
        "Signature help as you type the call keeps the parameter list in front of you. One method, one "
        "signature (no overloading) means there is never a wrong overload to guess at." }},

    {Code::ReturnTypeMismatch, {
        "LDP3-0303",
        "return type does not match",
        "A `return` must produce a value of the method's declared return type (or nothing, for `void`). "
        "The returned value's type does not match what the method promises.",
        "Return a value of the declared type, convert it with `cast<T>(...)` if intended, or change the "
        "method's declared return type to match what it actually returns.",
        "State return types explicitly (LDP3 requires them on methods) so the promise is visible. Forge's "
        "hover shows the expression's type next to the declared one." }},

    {Code::AssignImmutable, {
        "LDP3-0401",
        "this is not mutable",
        "Values are immutable by default in LDP3; only a `mutable` variable or field can be reassigned. "
        "Assigning to an immutable binding would break the guarantee that it never changes after init.",
        "Mark the declaration `mutable` if it is meant to change (`mutable int n = 0;`), or avoid the "
        "reassignment -- often a new local expresses the intent more clearly than mutating one.",
        "Default to immutable and add `mutable` only where a value genuinely changes; the keyword then "
        "documents exactly what is expected to move. Fewer mutable bindings, fewer surprises." }},

    {Code::UseAfterMove, {
        "LDP3-0402",
        "used after it was moved",
        "A `move` transfers ownership: the source is emptied so there is exactly one owner and no double "
        "free. Reading the moved-from value afterwards would read something that no longer owns its data.",
        "Use the destination of the move instead, or reassign the moved-from variable before using it "
        "again. If you meant to keep both, take a reference (`&`) or a deep copy rather than moving.",
        "Move only at the point ownership really transfers, and let the moved-from name go out of scope "
        "soon after. Prefer references for sharing and copies for independent values." }},

    {Code::MissingReturn, {
        "LDP3-0501",
        "not all paths return a value",
        "A method that declares a non-void return type must return a value on every path that reaches its "
        "end. A path that falls off the end would leave the caller with no value.",
        "Add a `return <value>;` on the path that falls through -- often the final `else` or the code "
        "after a loop -- or restructure so every branch returns.",
        "Return early and often rather than threading one result to the bottom; each branch then obviously "
        "returns. A final unconditional `return` makes the fall-through impossible." }},

    {Code::Redeclaration, {
        "LDP3-0601",
        "already declared",
        "A name can be declared once in a given scope. A second declaration of the same name is ambiguous "
        "-- the compiler cannot know which one later uses mean.",
        "Rename one of them, or -- if they are meant to be the same thing -- remove the duplicate "
        "declaration and keep a single one.",
        "Distinct, descriptive names avoid collisions. The structure panel and workspace symbols "
        "(Ctrl+T) show what names already exist before you add another." }},

    {Code::DuplicateField, {
        "LDP3-0602",
        "duplicate field",
        "Each field in a class must have a unique name; two fields with the same name would give one "
        "storage slot two meanings. This name is declared more than once in the class.",
        "Rename one field, or remove the duplicate if it was pasted by mistake. If a subclass field shadows "
        "a superclass one on purpose, give it a distinct name to make the intent clear.",
        "Keep a class small enough to see its fields at once; the structure panel lists them. One concern "
        "per class keeps the field set short and collision-free." }},
}};
// clang-format on

const Entry kEmpty{"", "", "", "", ""};
}  // namespace

const Entry& entry(Code code) {
    for (const Row& r : kCatalog)
        if (r.code == code) return r.entry;
    return kEmpty;
}

const Entry* entryByCodeString(std::string_view codeStr) {
    for (const Row& r : kCatalog)
        if (r.entry.codeStr == codeStr) return &r.entry;
    return nullptr;
}

std::string codeString(Code code) {
    return std::string(entry(code).codeStr);
}

std::string allCodesListing() {
    std::string out;
    for (const Row& r : kCatalog) {
        out += std::string(r.entry.codeStr);
        out += "  ";
        out += std::string(r.entry.caret);
        out += "\n";
    }
    return out;
}

}  // namespace ldp3::diag
