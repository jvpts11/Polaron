#include "diag/diagnostic.h"

// The diagnostic catalog: for each code, the canonical why / how-to-fix / how-to-prevent. Written once
// here, per rule, so the wording stays consistent everywhere it appears -- the terminal, `polaron explain`,
// and the Forge hover. The call-site supplies only the specific title (the names and types involved).
//
// classify() infers a code from a message so the hundreds of existing call-sites become rich without
// being edited; the mapping is the one reviewable table at the bottom of this file.
namespace polaron::diag {

namespace {
struct Row {
    Code code;
    Entry entry;
};

// clang-format off
constexpr Row kCatalog[] = {
    {Code::SyntaxError, {
        "Polaron-0001", "unexpected syntax here",
        "The parser reached something it did not expect for this construct: Polaron has a fixed grammar, so "
        "every statement, declaration, and expression has a required shape. The token here does not fit it.",
        "Compare the line with a working example of the same construct. The usual causes are a missing `;` "
        "or `}`, a keyword left out (every block needs `{ }`; every method a `returns` type), or `{}` used "
        "inline where Polaron wants each statement on its own line.",
        "Let the editor close brackets and indent for you, and build often so a syntax slip is caught one "
        "line after you make it. The subset reference (F1) shows each construct's exact shape." }},

    {Code::LexError, {
        "Polaron-0002", "cannot read this text",
        "The lexer -- the first pass, which turns characters into tokens -- hit something it cannot form a "
        "token from: an unterminated string or char literal, a stray character, or a malformed number.",
        "Close the string/char literal, remove the stray character, or fix the number. The caret points at "
        "where the lexer gave up, which is usually just after where the real mistake is.",
        "Type quotes and brackets in pairs (the editor helps), and keep literals on one line. A syntax "
        "theme makes an unterminated string obvious -- the colour runs to the end of the line." }},

    {Code::UndeclaredVariable, {
        "Polaron-0101", "not declared in this scope",
        "A name must be declared before it is read -- as a local (var/mutable), a parameter, a field (via "
        "this.), or a namespace constant. This name matches nothing visible here, which is almost always a "
        "typo or a missing declaration.",
        "If it is a typo, use the suggested name. Otherwise declare it before this point, e.g. "
        "`mutable int name = ...;`, or -- for a field -- write `this.name` and add the field to the class.",
        "Let the editor autocomplete names (Ctrl+Space in Forge). Forge's live check flags an undeclared "
        "name as you type, and Alt+Enter applies the suggested fix." }},

    {Code::NoSuchField, {
        "Polaron-0102", "no such field on this type",
        "A field must be declared in the class (or a superclass) before it can be read or assigned. The "
        "type here declares no field by this name, so the access cannot resolve.",
        "Use the correct field name (see the suggestion, if any), or add the field to the class: "
        "`public mutable T name;`. If you meant a method, call it with `()`.",
        "Member autocomplete after `this.` or `obj.` lists the real fields. Keeping one class per concern "
        "makes its fields easy to remember; the structure panel (Ctrl+F12) shows them at a glance." }},

    {Code::NoSuchMethod, {
        "Polaron-0103", "no such method on this type",
        "A method must be declared on the type (or a superclass/interface it has) before it can be called. "
        "The receiver's type exposes no method by this name.",
        "Call an existing method (member autocomplete lists them), or declare the method on the class. "
        "Check the receiver's type is what you expect -- a wrong type is a common cause.",
        "Member autocomplete and go-to-definition (F12) confirm a method exists before you call it. "
        "Interfaces make the available methods explicit at the call site's declared type. Two more "
        "declarations exist for the case where a whole FAMILY of types should answer to the same call. "
        "A `catalog` is that contract for enums: declare `method weight() returns int;` on it once, and "
        "every enum that extends it must provide one, so a value of the catalog type can always be "
        "asked. A `transformer` is the version that writes the method rather than only requiring it -- "
        "every type that `applies` it gets the body, expanded at compile time." }},

    {Code::UnknownType, {
        "Polaron-0104", "unknown type",
        "Every type name must resolve to a declared class, interface, enum, record, struct, or a built-in "
        "primitive. This name resolves to none of them -- it is misspelled, not imported, or not declared.",
        "Spell the type as declared, add the missing `import <bundle>.<namespace>.<Type>;`, or declare the "
        "type. Cross-namespace types need an import even within the same program.",
        "Import autocomplete completes type names as you type the import. The stdlib browser (F1) lists "
        "every built-in type; the structure panel lists the project's own." }},

    {Code::UnknownName, {
        "Polaron-0105", "no such name",
        "This name (a class, region, label, imported symbol, or annotation) refers to something that is "
        "not declared or not in scope here, so the compiler cannot resolve what you mean.",
        "Declare or import the thing before you name it, or correct the spelling. For a label, define it "
        "with `name:` in the same method; for an import, add the matching `import`.",
        "Declare before you use, and let autocomplete supply names that already exist. Workspace symbols "
        "(Ctrl+T) find a name across the whole project." }},

    {Code::NotAccessible, {
        "Polaron-0201", "not accessible from here",
        // `internal` said "the same bundle" here and the spec (2.6) says "the same program, any
        // bundle" -- two documents disagreeing about a word, in the one place a reader meets it. The
        // spec is the source of truth, so this text moved rather than the rule.
        "A member's visibility limits where it can be used: `private` is its own class only, `protected` "
        "adds subclasses, `internal` is the same program (any bundle in it), `public` is everywhere. "
        "This access is outside the member's allowed scope.",
        "Access it from an allowed scope, widen the member's visibility if that is intended (e.g. make it "
        "`public`), or add a public method that exposes what you need instead of the member directly.",
        "Decide a type's public surface up front and keep internals `private`; reach them through methods. "
        "Explicit visibility on every member (Polaron requires it) keeps the boundary in view." }},

    {Code::NullSafety, {
        "Polaron-0300", "null where a value is required",
        "Every type in Polaron is non-null by default: `Tree*` is a pointer that always points at something. "
        "`nullable T` is the opt-in that says \"this one may be absent\", and the compiler keeps the two "
        "apart so an absent value is a case you WROTE, never one you met at runtime.",
        "Three fixes, and which is right depends on what you meant. (1) If absence is a real state for this "
        "value, declare it nullable -- `public mutable nullable Tree* left;`. (2) If it cannot be absent, "
        "produce a real value instead of null. (3) If you already tested it, the CHECK NARROWS THE TYPE: "
        "after `if (p == null) { return; }`, and inside the `then` of `if (p != null)`, `p` is a plain `T*` "
        "and needs no cast. Narrowing reads a direct test of a NAME -- `p != null`, `p == null`, and `&&` "
        "chains of those. A test of anything else (`node.left != null`, the result of a call) proves "
        "nothing, and there `cast<T*>(p)` states that you checked -- a claim the compiler verifies at "
        "runtime, so a broken promise raises NullReferenceException instead of corrupting memory.",
        "Decide per field and per parameter whether absence is meaningful, and let the type say so. A type "
        "that is `nullable` everywhere teaches nothing; one that is nullable exactly where a value can be "
        "missing turns every other line into a place null cannot reach." }},

    {Code::TypeMismatch, {
        "Polaron-0301", "wrong type here",
        "Polaron is statically typed: a value's type must match where it is used. Assignment, arguments, and "
        "returns do not convert types implicitly, because a silent conversion is where bugs hide.",
        "Produce a value of the expected type, or convert explicitly with `cast<T>(value)` when the "
        "conversion is intended and safe. Check you are using the variable you think you are.",
        "Name types clearly and let `var` infer locals from an obviously-typed initializer. Forge's hover "
        "shows a value's type, so a mismatch is visible before you build." }},

    {Code::ArgCount, {
        "Polaron-0302", "wrong number of arguments",
        "A method is called with exactly its declared parameters -- Polaron has no overloading, so one name "
        "means one signature. Too few or too many arguments cannot match it.",
        "Pass exactly the declared parameters, in order. Signature help (in Forge, inside the `(`) shows "
        "them; check the method's declaration if unsure.",
        "Signature help as you type the call keeps the parameter list in front of you. One method, one "
        "signature (no overloading) means there is never a wrong overload to guess at." }},

    {Code::ReturnTypeMismatch, {
        "Polaron-0303", "return type does not match",
        "A `return` must produce a value of the method's declared return type (or nothing, for `void`). "
        "The returned value's type does not match what the method promises.",
        "Return a value of the declared type, convert it with `cast<T>(...)` if intended, or change the "
        "method's declared return type to match what it actually returns.",
        "State return types explicitly (Polaron requires them on methods) so the promise is visible. Forge's "
        "hover shows the expression's type next to the declared one. When the mismatch is really \"sometimes "
        "there is no value to return\", say that in the type rather than reaching for a sentinel: "
        "`Option<T>` for an absence and `Result<T, E>` for a failure both make the caller deal with the "
        "case, and `try?` forwards it in one character." }},

    {Code::ArgType, {
        "Polaron-0304", "argument type does not match the parameter",
        "Each argument's type must match (or be a subtype of) the parameter it is passed to; there is no "
        "implicit conversion. The value here is a different type than the parameter accepts.",
        "Pass a value of the parameter's type, or convert with `cast<T>(...)`. If you passed arguments in "
        "the wrong order, reorder them to match the declaration.",
        "Signature help shows each parameter's type as you fill the call in. Naming variables after what "
        "they hold makes an out-of-order or wrong-type argument obvious at the call site. For the "
        "signatures where that is not enough -- three booleans in a row, four numbers of the same type "
        "-- `requires named` on a parameter forces callers to write `repeat: false`, so a call cannot "
        "be silently wrong about which argument is which. It is worth spending on exactly the "
        "parameters whose order nobody will remember." }},

    {Code::BadCast, {
        "Polaron-0305", "this cast is not allowed",
        "`cast<T>(value)` converts between types the language knows how to convert -- numbers, a base and "
        "its subclass, an int and a pointer in freestanding. This pair is not one of them.",
        "Cast only between convertible types. To treat an object as a related type, cast up or down its own "
        "hierarchy; to reinterpret raw memory, do it in freestanding with pointer/address casts.",
        "Prefer designs where a value already has the type you need over casting to it. Where a cast is "
        "genuinely needed, a comment on why keeps the intent (and its safety) clear. A downcast to ask "
        "\"which kind is this\" has a better form: `match` over a `sealed` hierarchy binds the answer as "
        "the right type in each arm, and the compiler refuses the match if a case is missing -- so a new "
        "variant is a build error rather than a cast that starts failing at runtime." }},

    {Code::BadIndex, {
        "Polaron-0306", "cannot index this",
        "Indexing with `[i]` needs an array (or a pointer, in freestanding) and an integer index. Either "
        "the value indexed is not an array, or the index is not an integer.",
        "Index an array value, and use an integer index. If the value is a collection like ArrayList, use "
        "its `get(i)` method rather than `[]`.",
        "Give arrays and indices names that say so. Forge's hover shows a value's type, so indexing a "
        "non-array is caught before you build; `.length()` bounds a loop safely. Where the code is "
        "walking the whole thing, the index was never the point: `foreach` over an `Iterable<T>` reads "
        "as what it does and cannot go out of range, and `Slice<T>` is how a method takes PART of an "
        "array -- a window with a length, rather than a pointer and an integer the caller has to keep "
        "agreeing about." }},

    {Code::BadOperand, {
        "Polaron-0307", "operator applied to the wrong type",
        "Each operator requires operands of a particular type: arithmetic and bitwise want integers, `!` "
        "wants a boolean, `~` wants an integer, and so on. An operand here is a type the operator rejects.",
        "Convert the operand to the type the operator expects, or use the right operator for the types you "
        "have (e.g. `&&`/`||` for booleans, `&`/`|` for integer bits).",
        "Keep boolean and integer values distinct in your head and your names; most operand errors are a "
        "boolean where a number was meant, or the bitwise operator where the logical one was meant." }},

    {Code::AssignImmutable, {
        "Polaron-0401", "this is not mutable",
        "Values are immutable by default in Polaron; only a `mutable` variable or field can be reassigned. "
        "Assigning to an immutable binding would break the guarantee that it never changes after init.",
        "Mark the declaration `mutable` if it is meant to change (`mutable int n = 0;`), or avoid the "
        "reassignment -- often a new local expresses the intent more clearly than mutating one.",
        "Default to immutable and add `mutable` only where a value genuinely changes; the keyword then "
        "documents exactly what is expected to move. Fewer mutable bindings, fewer surprises." }},

    {Code::UseAfterMove, {
        "Polaron-0402", "used after it was moved",
        "A `move` transfers ownership: the source is emptied so there is exactly one owner and no double "
        "free. Reading the moved-from value afterwards would read something that no longer owns its data.",
        "Use the destination of the move instead, or reassign the moved-from variable before using it "
        "again. If you meant to keep both, take a reference (`&`) or a deep copy rather than moving.",
        "Move only at the point ownership really transfers, and let the moved-from name go out of scope "
        "soon after. Prefer `T&` for sharing and plain assignment -- which deep-copies -- for independent "
        "values. If the type is `unique`, moving is the only way it travels and the compiler will keep "
        "telling you so; if it should be splittable instead, `partitionable` lets its fields move one at "
        "a time while the object stays usable." }},

    {Code::MoveMisuse, {
        "Polaron-0403", "this cannot be moved",
        "Ownership can only be transferred from something that owns a whole value. Moving out of a field of "
        "a live object, or moving an immutable binding, would leave a half-owned or unchangeable value.",
        "Move a whole owning variable, not a field of one still in use (make the field `partitionable` if "
        "field-wise moves are intended), and move only `mutable` bindings. Copy or reference instead.",
        "Keep ownership at the granularity you move at: own a value in one variable and move that. "
        "`unique`/`movable` on a type document exactly how its instances may travel." }},

    {Code::InvalidAssignTarget, {
        "Polaron-0404", "cannot assign to this",
        "The left of `=` (or the target of `++`/`--`) must be an assignable place: a variable, a field, or "
        "an array element. This target is a value or expression, which has nowhere to store into.",
        "Assign to a variable, `this.field`, or `array[i]`. If you meant to compare, use `==`; assignment "
        "is not an expression in Polaron, so `if (x = 5)` is always a mistake.",
        "Assignment being a statement, not an expression, means a stray `=` in a condition is caught for "
        "you. Increment only real lvalues; compute new values into a named local otherwise." }},

    {Code::MissingReturn, {
        "Polaron-0501", "not all paths return a value",
        "A method that declares a non-void return type must return a value on every path that reaches its "
        "end. A path that falls off the end would leave the caller with no value.",
        "Add a `return <value>;` on the path that falls through -- often the final `else` or the code "
        "after a loop -- or restructure so every branch returns.",
        "Return early and often rather than threading one result to the bottom; each branch then obviously "
        "returns. A final unconditional `return` makes the fall-through impossible." }},

    {Code::MatchNotExhaustive, {
        "Polaron-0502", "match does not cover every case",
        "A `match`/`switch` must handle every possible value: a `sealed` type must cover all its permitted "
        "cases, and any other subject needs a `default`. An uncovered value would have no arm to run.",
        "Add the missing case, or a `default` arm. For a `sealed` type, cover each type in its `permits` "
        "list -- the compiler then checks completeness for you when the list grows.",
        "Prefer `sealed` types for closed sets of cases: the compiler makes a match over them exhaustive, "
        "so adding a new case turns every unhandled match into a compile error, not a silent gap. A "
        "`catalog` gives the same property to a family of enums -- the members that extend it are the "
        "cases, and the contract it declares is what every one of them must answer. Either way the "
        "closed set is written down once, and the compiler finds the matches that have fallen behind "
        "it instead of you finding them in production." }},

    {Code::Redeclaration, {
        "Polaron-0601", "already declared",
        "A name can be declared once in a given scope. A second declaration -- of a type, a variable, or a "
        "name that shadows an enclosing one -- is ambiguous: later uses cannot tell which you mean.",
        "Rename one of them, or remove the duplicate if they were meant to be the same thing. Shadowing an "
        "outer variable is rejected on purpose; pick a distinct name for the inner one.",
        "Distinct, descriptive names avoid collisions. The structure panel and workspace symbols (Ctrl+T) "
        "show what names already exist before you add another. Where two areas of a program genuinely "
        "want the same word, that is what a `namespace` is for: `Geometry.Point` and `Chart.Point` are "
        "two types, each named well, and an `import` at the top of a file decides which one that file "
        "means." }},

    {Code::DuplicateField, {
        "Polaron-0602", "duplicate field",
        "Each field in a class must have a unique name; two fields with the same name would give one "
        "storage slot two meanings. This name is declared more than once in the class.",
        "Rename one field, or remove the duplicate if it was pasted by mistake. If a subclass field is "
        "meant to be separate from a superclass one, give it a distinct name.",
        "Keep a class small enough to see its fields at once; the structure panel lists them. One concern "
        "per class keeps the field set short and collision-free. When a group of fields keeps travelling "
        "together -- `x`, `y`, `width`, `height` -- they are a type: a `record` names them once, copies "
        "as a value, and turns four fields into one, which is how a class stays small enough that a "
        "duplicate name is visible." }},

    {Code::DuplicateMember, {
        "Polaron-0603", "duplicate member",
        "The members of a set must be distinct: an enum's constants, a catalog's values, and a call's named "
        "arguments each name a thing once. A repeat makes two entries indistinguishable.",
        "Remove or rename the duplicate. For a named argument passed twice, pass it once; for an enum or "
        "catalog, each constant/value appears a single time.",
        "List members in a deliberate order and scan for repeats, or let the structure panel show them. "
        "Short, meaningful names make an accidental duplicate stand out. When one long enum is being "
        "kept in step with another -- the same constants repeated so two families can be asked the "
        "same question -- a `catalog` is what removes the repetition: it declares the contract once, "
        "and each enum extends it with only its own constants." }},

    {Code::InheritanceCycle, {
        "Polaron-0604", "inheritance cycle",
        "A class cannot (even transitively) extend itself, and a catalog cannot extend itself: the "
        "hierarchy has to bottom out, or laying out and initializing an instance would never terminate.",
        "Break the cycle -- one of the `extends`/`implements` links is wrong. Point the type at a real "
        "base, or introduce a shared base both were trying to be.",
        "Sketch the hierarchy as a tree before writing it; a tree has no cycles by construction. Prefer "
        "shallow hierarchies and interfaces over deep chains that are easy to tangle. A cycle usually "
        "means the chain was being used to share code rather than to model a kind-of relationship, and "
        "there is a declaration for that: a `transformer` is expanded into every type that `applies` it, "
        "so the shared behaviour costs no place in the hierarchy at all." }},

    {Code::LiteralSuffix, {
        "Polaron-0701", "bad literal suffix",
        "A literal's suffix picks its type (e.g. `10i8`, `3.0f`, `5m`) or its unit (a comptime size). This "
        "suffix is not one the compiler knows, or does not fit the literal it is on.",
        "Use a defined suffix for the type you want, or drop the suffix and let the literal take its "
        "default type. Check the spec's literal table for the exact spellings.",
        "Reach for a suffix only when the default type is not what you need; a plain literal is clearest. "
        "The stdlib browser (F1) documents the numeric types and their suffixes. And a suffix is not a "
        "fixed list you are stuck with: `public comptime literal kilobytes(int x) returns ByteSize` is "
        "how the standard library declares one, and a program can declare its own the same way -- so a "
        "quantity that keeps being written as a bare number with a comment beside it can become "
        "`64 kilobytes`, checked by the type system and folded before the program runs." }},

    {Code::StringInterp, {
        "Polaron-0702", "cannot interpolate this value",
        "String interpolation `$\"... {x} ...\"` prints simple values -- numbers, char, boolean -- by "
        "lowering each hole to a printf conversion. A value with no such conversion cannot be interpolated.",
        "Interpolate a numeric/char/boolean value, or convert the value to one first (e.g. call a method "
        "that returns an int). The real String type and its formatting arrive with the stdlib (F10).",
        "Keep interpolation for scalars and build richer text through methods that return printable values. "
        "Forge's hover shows a hole's type, so an unprintable one is visible before you build. When many "
        "types need to be printable, do not write the same method on each of them: a `transformer` that "
        "declares a description `procedure` gives every type that `applies` it one, expanded at compile "
        "time, and then a hole holding any of them has something to call." }},

    {Code::PrintfFormat, {
        "Polaron-0703", "printf needs a literal format string",
        "The format argument of System.IO printf/println/print must be a string literal (or an "
        "interpolation), so the compiler can check and lower it at compile time -- there is no runtime "
        "String type yet to hold a computed format.",
        "Pass a literal format string, or an interpolation `$\"...\"`. Move any computed text into the "
        "arguments after the format, not into the format itself.",
        "Write the format inline as a literal and let the values follow it. This also keeps the conversions "
        "(`%d`, `%c`) next to the values they format, where a mismatch is easy to spot. Better still, "
        "stop separating them: `$\"placed {row},{column} for {player}\"` puts each value where it is "
        "printed, so there is no order to get wrong and no conversion to choose -- the compiler picks it "
        "from the type." }},

    {Code::OperatorOverload, {
        "Polaron-0801", "malformed operator overload",
        "An `operator` declaration defines what a symbol means for a type; it has a fixed shape -- the "
        "operator, its operands, and a return type. This declaration does not match that shape.",
        "Declare the operator as the spec shows (`operator + (Other rhs) returns T { ... }`), with the "
        "right number of operands for the symbol. Return the operator's result type.",
        "Overload an operator only where it reads as naturally as the built-in one (arithmetic on a vector, "
        "say). A named method is clearer than an operator whose meaning is not obvious." }},

    {Code::ReflectionMisuse, {
        "Polaron-0802", "reflection used incorrectly",
        "Reflection (`reflect.typeOf<T>`, field/annotation access) needs `import reflect;` and a correct "
        "shape -- one type argument, a reflectable subject. This use is missing the import or malformed.",
        "Add `import reflect;`, and call the reflection API as documented (e.g. `reflect.typeOf<T>()` with "
        "exactly one type argument). Reflection is unavailable in freestanding mode.",
        "Reach for reflection sparingly -- direct method calls are faster and clearer. When you do use it, "
        "keep the reflective code in one place so its import and shape are easy to keep correct. Two "
        "things often mistaken for reflection are not: annotations (`[Name(...)]`) attach data to a "
        "declaration and are read without walking anything, and a `transformer` writes the per-type code "
        "at compile time instead of discovering the type at run time -- which is faster, checked, and "
        "cannot fail on a shape it did not expect." }},

    {Code::RegionMisuse, {
        "Polaron-0803", "region used incorrectly",
        "A region (spec 17) is a typed arena: its declaration, its address/range, and `new ... in region` "
        "have fixed shapes and type rules. This use breaks one of them -- a bad address, range, or type.",
        "Give the region a numeric or address bound where one is required, allocate types the region "
        "`accepts`, and spell `new T in region` as the spec shows. Check the region is in scope here.",
        "Decide what a region holds and where it lives when you declare it; `accepts`/`rejects` then make "
        "the compiler enforce it. Keep allocation and release of a region visibly paired." }},

    {Code::RegionTwoFlavors, {
        "Polaron-1710", "a region has exactly one flavor",
        "A region's flavor is its reclaim strategy -- bump, pool, stack, fixedslot or ring (spec 17) -- and "
        "a region has exactly one. Two flavor words on one declaration (like `pool stack region`) name two "
        "contradictory strategies, so the compiler cannot pick how the region reclaims memory.",
        "Keep a single flavor word before `region`. Choose pool for free-list reuse of mixed sizes, "
        "fixedslot for one repeated type, stack for mark/rollback, ring for a bounded auto-evicting buffer, "
        "or plain `region` (bump) to free everything at once on release.",
        "Decide the reclaim discipline once, when you declare the region, from how its objects die: all "
        "together (bump), individually (pool/fixedslot), newest-first (stack), or oldest-out (ring)." }},

    {Code::RegionFlavorOnNonRegion, {
        "Polaron-1719", "a flavor modifier only qualifies a region",
        "Words like `pool`, `stack`, `fixedslot`, `ring` and `growable` are region flavor/growth modifiers "
        "(spec 17): they only make sense in front of the `region` keyword, where they choose how the arena "
        "reclaims memory. Here one qualifies an ordinary declaration, which has no arena to reclaim.",
        "Drop the modifier from this declaration. If you meant to declare an arena, write it as "
        "`<flavor> region name = itself.allocate(...);`.",
        "Reserve the flavor words for region declarations; everywhere else they are ordinary identifiers." }},

    {Code::RegionUseAfterExtract, {
        "Polaron-1717", "use of a variable after it was extracted from its region",
        "`extract X from region R` relocates the object out of the region and transfers ownership to the "
        "result. Like `move`, it leaves the source variable empty: the region no longer owns that object, "
        "so reading the old handle would alias memory the region may already have reused.",
        "Use the value returned by `extract` from here on. If you still need the original handle, do not "
        "extract -- read it in place, or `extract` into the same variable (`x = extract x from region R;`).",
        "Treat `extract` like `move`: the name you extract from is spent afterwards. Bind the result to the "
        "variable you will keep using." }},

    {Code::RegionExtractInnerField, {
        "Polaron-1718", "cannot extract an object whose field lives in the same region",
        "`extract`/`delete from region` relocates or frees one object's own storage. This object owns a "
        "field allocated in the SAME region, so moving just the object would leave that field behind in the "
        "region -- a dangling pointer after the region is released, or a leak (spec 17).",
        "Extract the whole graph with `cascade move X from region A to region B`, or allocate the inner "
        "field outside this region (on the heap, or in a longer-lived region) so the object can leave alone.",
        "Keep an object and the sub-objects it owns in the same lifetime: either all in the region (freed "
        "together on release) or all relocatable together." }},

    {Code::RegionExtractNotBound, {
        "Polaron-1720", "an `extract` result must be bound",
        "`extract X from region R` transfers ownership of the relocated object to its result -- the caller "
        "must then delete it or hand it to something that will. A bare `extract ...;` statement drops that "
        "owner on the floor, leaking the object it just relocated to the heap (spec 17).",
        "Bind the result: `T* out = extract X from region R;` (or assign it to a field), then `delete out;` "
        "when done. If you only want to destroy X, use `delete X from region R;` instead.",
        "Read `extract` as producing a value you own now -- always on the right-hand side of a binding, "
        "never as a statement on its own." }},

    {Code::RegionMarkNonStack, {
        "Polaron-1713", "mark/rollback need a stack region",
        "`mark of region R` and `rollback region R to m` are the LIFO checkpoint operations of a `stack "
        "region` (spec 17): they record and rewind a single allocation cursor. A bump/pool/fixedslot/ring "
        "region has no LIFO cursor to mark, so these operations do not apply to it.",
        "Declare the region `stack` (`stack region R = itself.allocate(...)`). To reclaim individual "
        "objects from a pool region instead, use `delete X from region R` or `extract`.",
        "Choose the flavor from how the region reclaims: stack for nested/per-frame checkpoints (mark/"
        "rollback), pool for free-list reuse of individual objects." }},

    {Code::RegionCheckpointWrongRegion, {
        "Polaron-1714", "this checkpoint belongs to another region",
        "A `checkpoint` records a cursor position in the specific `stack region` it was marked from. Rolling "
        "a different region back to it would rewind that region to an offset that means nothing there -- "
        "reviving or dropping the wrong objects (spec 17).",
        "Roll back the region the checkpoint came from: `rollback region <that region> to m;`. Keep one "
        "checkpoint variable per region so it is obvious which pairs with which.",
        "Name checkpoints after their region, and mark/rollback the same region in a matched pair." }},

    {Code::RegionFixedslotAcceptsRequired, {
        "Polaron-1711", "a fixedslot/ring region needs its single element type",
        "A `fixedslot` region is a single-size pool and a `ring` region is a fixed-purpose circular buffer "
        "(spec 17): both hold exactly one element type, which sets the slot size. Without it the compiler "
        "cannot size the slots or know what to allocate.",
        "Constrain the region to one type: `fixedslot region R = itself.allocate(N).accepts({Particle});`. "
        "For a heterogeneous churn use a plain `pool region` instead (no accepts required).",
        "Pick fixedslot/ring when the region holds many of ONE type; name that type in `.accepts({T})`." }},

    {Code::RegionRingNoDelete, {
        "Polaron-1715", "a ring region auto-evicts; individual delete is not allowed",
        "A `ring` region is a bounded circular buffer: a new allocation past its capacity overwrites the "
        "oldest entry (running its destructor first). Deleting an individual entry would leave a hole in "
        "the ring and break that oldest-out discipline (spec 17).",
        "Let the ring evict on its own -- just keep allocating; the oldest entries fall off. To drop "
        "everything, `release region R` (or `.clear()`). Use a `pool region` if you need individual delete.",
        "Reach for a ring only for bounded history/streaming where losing the oldest is the intent." }},

    {Code::RegionGrowableContradiction, {
        "Polaron-1712", "growable does not apply here",
        "`growable` lets a region chain another block when it fills (spec 17). It cannot combine with a "
        "region that is bounded or fixed by nature: a `ring` is intentionally bounded, a mapped "
        "(`at address`) region backs fixed foreign memory, and a `stack` region's mark/rollback cursor is "
        "not defined across chained blocks.",
        "Drop `growable` here. For a pool that outgrows its size use `growable pool region`; for a fixed "
        "bound use `ring`; for a mapped region give `itself.at` the real size; size a `stack` region for "
        "its deepest nesting.",
        "Decide up front whether a region is bounded (ring / mapped / a sized stack) or open-ended "
        "(growable pool/bump); the two are mutually exclusive." }},

    {Code::VectorMisuse, {
        "Polaron-0804", "vector/matrix operation is malformed",
        "The SIMD vector and matrix types have fixed shapes: a vecN has N numeric lanes, a mat4 has 16 "
        "numeric components and its own operations. This use has the wrong shape, component, or lane type.",
        "Give a vec/mat the right number of numeric components, index a lane that exists (x/y/z/w), and use "
        "the type's own operations (e.g. mat4 multiply/transform). Lane values are numeric.",
        "Construct vectors and matrices with exactly their component count, and name them by dimension. The "
        "stdlib browser (F1) documents each vector/matrix type and its operations." }},

    {Code::UnimportMisuse, {
        "Polaron-0805", "unimport/reimport used incorrectly",
        "unimport/reimport (spec 32) swap a program's code at runtime under strict rules: what you unimport "
        "must be importable back, and the reimport must match. This use violates one of those rules.",
        "unimport a name that can be reimported, and make the reimport's `expecting` signature match the "
        "unimport. Check the target exists and is the kind unimport can replace.",
        "Keep the unimport/reimport pair close and their `expecting` contracts identical. Treat runtime "
        "code-swapping as a deliberate, well-tested seam, not a casual edit." }},

    {Code::Demand, {
        "Polaron-0806", "demand",
        "`demand <cond> otherwise \"why\";` settles a condition while the program is being built. The "
        "condition must be known then, and it must hold. Either it did not fold to a constant, or it "
        "folded to false.",
        "Build the condition from literals, `fixed` values and comptime calls, and make it true for the "
        "targets you compile. The `otherwise` text is the reason, and it is what the failure reports.",
        "Write the reason, not a restatement of the condition: `== 20` says the number, \"three to a "
        "cache line\" says why 20. A demand costs nothing at runtime -- it is gone by then. When the "
        "claim is about a type's SIZE rather than about a number, a `layout` says it in the place that "
        "owns the answer: `itself.fitWithin(20 bytes)` with `itself.refuse(\"three to a cache line\")` "
        "holds the same line, on the declaration, and keeps holding it when a field is added later by "
        "someone who never read the demand." }},

    {Code::TryContext, {
        "Polaron-0503", "`try?` needs a Result/Option method",
        "`try?` unwraps a Result/Option and, on the error case, returns that error from the current method. "
        "That only type-checks where the method itself returns a Result/Option to carry the error out.",
        "Use `try?` only inside a method whose return type is Result or Option. Otherwise handle the value "
        "with `match`, or change the method to return a Result/Option so the error has somewhere to go.",
        "Decide a method's error strategy from its signature: return Result/Option and `try?` composes "
        "cleanly through it. Mixing `try?` into a plain method is the mismatch this catches." }},

    {Code::TryErrorType, {
        "Polaron-0504", "`try?` propagates a failure this method cannot carry",
        "On the failure path `try?` does not build a new value -- it returns the operand's failure "
        "UNCHANGED, byte for byte. So the operand's failure has to be one the enclosing method's return "
        "type already carries: the same family (a None is not an Err, and an Err's payload is not a "
        "None's absence) and, for two Results, an error type that fits. Nothing downstream catches a "
        "mismatch: every value-form Result is one LLVM struct and every boxed one an opaque pointer, so "
        "a wrong error type is not a link error, it is a reinterpreted object at runtime.",
        "Convert the failure where the types change, rather than propagating across the boundary: "
        "`match` on the operand and return an `Err(...)` built from the error type this method declares. "
        "If the two really are the same error, declare this method to return that error type and let "
        "`try?` do its job. Crossing Result and Option needs a deliberate step either way -- an Option "
        "has no error value to promote, and a Result's error is what a None would silently drop.",
        "Pick one error type per layer and convert at the layer boundary, in one place. `try?` then "
        "composes freely inside a layer, and every conversion is somewhere you can read." }},

    {Code::IllegalExtend, {
        "Polaron-0605", "cannot extend this type",
        "A `final` class forbids any subclass, and a `sealed` type's variants are closed -- only its "
        "declared `permits` list may extend it. Extending outside those rules would break a guarantee the "
        "author made about the type's shape.",
        "Do not extend a `final` class -- compose with it instead (hold one as a field). To be a variant of "
        "a sealed type, be listed in its `permits`; otherwise model your type another way.",
        "`final` and `sealed` are deliberate: they say a hierarchy is closed so code can reason about all "
        "its cases. Prefer composition over extending types that were sealed shut on purpose. When what "
        "you wanted was to SHARE BEHAVIOUR rather than to be a variant, inheritance was the wrong tool "
        "even where it is allowed: a `transformer` is expanded into every type that `applies` it, so the "
        "behaviour is shared without a hierarchy, without a vtable, and without asking the author of a "
        "closed type for permission to extend it." }},

    {Code::IllegalOverride, {
        "Polaron-0606", "cannot override a final method",
        "A `final` method cannot be overridden: the base class declared that its behaviour is fixed, so "
        "subclasses rely on it. An override would silently change what callers of the base expect.",
        "Remove the override, or -- if the base method is meant to be customizable -- remove `final` from "
        "it in the base class. Give the subclass method a different name if it does a different thing.",
        "Mark a method `final` only when subclasses must not change it, and override only methods left open. "
        "The keyword documents the contract; respecting it keeps subclasses substitutable." }},

    {Code::ConstraintNotMet, {
        "Polaron-0307b", "type argument does not satisfy the bound",
        "A generic parameter can carry a bound (`T extends Comparable<T>`), and every type argument must "
        "meet it, so the generic body can rely on the bounded capability. This argument does not.",
        "Pass a type that satisfies the bound (implements the required interface / extends the required "
        "base), or relax the generic's bound if the capability is not actually needed.",
        "Read a generic's bounds as the promises its body depends on. Make a type satisfy them (implement "
        "the interface) before using it as the argument; the error names exactly which promise is missing." }},

    {Code::ContradictoryModifiers, {
        "Polaron-0607", "these modifiers contradict each other",
        "Some modifiers make opposite promises and cannot combine -- e.g. `unique` guarantees a single live "
        "reference while `partitionable` hands out field-wise pieces. Together they would promise both.",
        "Keep the one modifier that matches your intent and drop the other. Decide whether the type is "
        "singly-owned (`unique`) or splittable (`partitionable`), not both.",
        "Choose an ownership discipline per type up front. Each modifier documents one promise; combining "
        "conflicting ones is the contradiction this catches before it can confuse callers." }},

    {Code::StaticInitNotConst, {
        "Polaron-0608", "this static field's initializer has no value before the program starts",
        "A static field is one storage location per class, laid down in the binary before `main` runs, so "
        "whatever it starts as has to be computable by the compiler. It may be written in terms of literals, "
        "consts, `comptime` methods, and OTHER static fields in any order -- the only thing that cannot work "
        "is a cycle, where two fields are each defined from the other and neither can go first. Until this "
        "was checked, an initializer the compiler could not evaluate was silently emitted as ZERO: no error, "
        "no warning, and a program whose behaviour was wrong in a place no test of its output points back to.",
        "Three ways out, and which is right depends on WHY it will not fold. (1) If the value really is "
        "constant, break the cycle -- one of the two has to be a literal. (2) If it cannot be computed "
        "until the value is first NEEDED, mark it `lazy`: a lazy binding runs its initializer at the "
        "first read and at most once, which breaks a cycle without moving anything and skips the work "
        "entirely when nobody touches the field. (3) If it needs the machine running -- allocation, I/O, "
        "an OS call -- it does not belong in a declaration at all: move it into an `onClassLoad` block, "
        "which runs before anything touches the class and may compute anything.",
        "Keep static field initializers to plain arithmetic over other constants. Reach for `lazy` when "
        "the value is expensive or self-referential but still just a value, and `onClassLoad` when the "
        "setup genuinely needs to run. The split is the one the language draws everywhere else: what the "
        "compiler can know goes in the declaration, what needs the machine goes in code. And if what "
        "you actually wanted is state that survives the run rather than state that starts it, that is "
        "a `persistent`: it is created once, found again by its key on the next run, and released "
        "where you say -- none of which a static field can do, however its initializer is written." }},

    {Code::MoveRequired, {
        "Polaron-0405", "a movable value is transferred, never copied -- say so",
        "`movable` on a class means its instances have exactly one owner at a time and travel by handing "
        "that ownership over. A plain binding would read as a copy, and for a type whose whole point is a "
        "single owner there is no such thing as a copy -- so the transfer is written down: `move x`. The "
        "rule holds at every destination a value can reach, which is a declaration, an assignment to a "
        "variable or a field, a call argument, and a return. Three of those four were unchecked until "
        "recently, which meant the modifier was enforced exactly where it did not matter and ignored on "
        "every path by which a value outlives the method it was written in.",
        "Write `move` at the binding: `this.field = move t`, `f(move t)`, `return move t`. After it the "
        "source name is gone, which is the point -- reading it again is a separate diagnostic. If you "
        "wanted both to keep it and to pass it, the type is telling you it cannot be had: share it by "
        "pointer or reference instead, or drop `movable` if instances really are copyable.",
        "Decide per type whether instances are values (copyable), single-owner (`movable`/`unique`), or "
        "shared (used through `T*`/`T&`), and say it once on the declaration. Every call site then reads "
        "as what it is." }},

    {Code::EscapesFrame, {
        "Polaron-1721", "this hands out a pointer to storage that is about to disappear",
        "An object allocated in a method's own frame -- `new X()`, or `new X() on stack` -- lives exactly as "
        "long as the call. A pointer or reference to it that leaves the call (returned, or stored into "
        "something that outlives the call) is dangling the instant it arrives: the caller holds an address "
        "into a frame that has already been reused. Nothing downstream can catch it, because at the machine "
        "level a live pointer and a dangling one are the same 64 bits.",
        "Say where the object should live. `on heap` gives it a lifetime longer than the call and makes the "
        "caller responsible for `delete`; a region gives it the region's lifetime; returning by value gives "
        "the caller a copy and nobody a lifetime problem at all. If the object genuinely is scratch space "
        "for this call, keep it here and hand out the RESULT rather than the object.",
        "Decide an object's lifetime where it is allocated, not where it is used -- the allocation is the "
        "one place that has to know. If a whole program deliberately traffics in pointers to dead frames, "
        "`--no-region-binder` turns these checks off for that program; there is no per-line version, "
        "because a line that looks ordinary is exactly how this mistake survives review." }},

    {Code::RegionIncomparable, {
        "Polaron-1722", "nothing in the program says which of these two dies first",
        "Both of these live as long as some object -- neither is frame storage, so neither is obviously "
        "the shorter-lived one. That is not a gap in the analysis; it is a gap in the program. Nothing "
        "written anywhere says whether the object being pointed at outlives the object doing the "
        "pointing, so the reference cannot be shown to be valid for as long as it is reachable. It is "
        "the shape a database gets wrong: a result set holding rows a later statement frees, where "
        "every line involved is individually correct and only their order is not.",
        "Say who owns it, and the destructor is where that is said. If the object doing the pointing "
        "should free what it points at, give it a destructor that does -- the reference then becomes "
        "ownership and there is nothing left to prove. If it genuinely is a view, then it must not "
        "outlive what it views: build it, read it, and drop it before the owner changes. Storing a "
        "COPY removes the question entirely, and for small values that is usually the right answer.",
        "Decide, per field, whether it is ownership or a view, and let the destructor say so. A class "
        "whose destructor frees a field owns it and can be reasoned about; a class that frees nothing "
        "and holds pointers is a view, and a view has to be shorter-lived than what it views. Two "
        "features answer this question outright and are worth reaching for before pointers are: a "
        "`region` gives both objects one lifetime, so they are born and released together and there "
        "is nothing left to order; and `unique`/`movable` on the type says there is exactly one owner "
        "and makes every handover a `move` the compiler follows." }},

    {Code::RegionForeignBoundary, {
        "Polaron-1723", "past this point there is no proof to be had",
        "An `extern` function has no Polaron body, so nothing in this program can say whether it keeps "
        "the pointer it is handed. If it stores it somewhere that outlives the object, the object is "
        "freed and the foreign side is left holding an address -- and nothing on either side will "
        "notice. Assuming a foreign function keeps nothing is a guess, and a compiler that guesses "
        "here cannot claim a guarantee anywhere, because this is the one call that could always be "
        "reached to get around it.",
        "Say that the lifetime is outside the language: declare the parameter as `address`, which is a "
        "raw machine word and is exactly what a pointer crossing into C is. The refusal goes away "
        "because the claim goes away -- the declaration now states where this program's proof stops. "
        "If the foreign side only reads, hand it a copy, or hand it the values it needs rather than "
        "the object.",
        "Draw the boundary in the declaration, once, rather than at every call. An `extern` that takes "
        "`address` reads as what it is: a place where the program leaves its own guarantees behind." }},

    {Code::RegionUseAfterInvalidate, {
        "Polaron-1724", "what this holds was freed by an earlier call",
        "This value holds references into another object -- it was built from that object's contents "
        "-- and something since has freed those contents. The references are still there and still "
        "look valid; the storage behind them is not. This is use-after-free spread over three "
        "statements and two objects, which is why it survives review: building the view is correct, "
        "emptying the source is correct, reading the view is correct, and only their ORDER is wrong.",
        "Move the read before the call that empties, if the answer was wanted from the old contents. "
        "If it has to outlive them, it cannot hold references: have it keep copies of what it needs, "
        "so that emptying the source leaves it intact. Rebuilding it after the change also works, and "
        "is usually what was meant.",
        "A value built out of another object's contents belongs to that object's lifetime whether or "
        "not anything says so. Treat it as a window that is only open until the owner is next "
        "changed -- read it, take what you need out of it, and do not keep it across a mutation. "
        "Where the result has to survive, make it hold values rather than references: a `record` is "
        "copied on assignment, so a result built out of records is complete the moment it is built "
        "and no later change can reach into it. `Slice<T>` is the opposite choice, said out loud -- a "
        "window that does not own what it looks at, which is fine as long as it is read before the "
        "owner moves on." }},

    {Code::NoEntryPoint, {
        "Polaron-0609", "this program has nowhere to start",
        "A program has to name the one method the operating system calls first. Polaron spells it "
        "`public static method main(string[] args) returns void`, inside a public class in a public "
        "namespace in a public bundle -- and every step of that path must be public, because the "
        "runtime reaches it from outside the program entirely. A file with no such method compiles to "
        "no executable: there is nothing to run.",
        "Add the entry point, or make the existing one reachable. The usual cause is not a missing "
        "method but a missing `public`: a `main` inside a private namespace, or in a bundle that was "
        "never made public, is invisible from outside and does not count.",
        "Keep the entry point in one obvious place -- a class named `Main` at the top of the program's "
        "own bundle -- so the question of where a program starts has one answer." }},

    {Code::DuplicateConstructor, {
        "Polaron-0610", "a class has one constructor, and this is the second",
        "Polaron has no overloading, for constructors or for anything else: a name means one thing. "
        "Two constructors would mean the call `new Point(...)` picks between them by argument types, "
        "which is exactly the resolution the language leaves out so that reading a call tells you what "
        "runs.",
        "Keep one constructor and give the alternatives names: static factory methods (`Point.origin()`, "
        "`Point.polar(r, theta)`) that build and return. They read better at the call site than an "
        "overload set, because the name says which construction was meant. Default values on parameters "
        "cover the case where the difference is only which arguments were supplied.",
        "Name your constructions. A type with several ways to be built usually has several concepts "
        "behind it, and static factories put those concepts in the source instead of in a resolution "
        "rule." }},

    {Code::ShadowsBuiltinType, {
        "Polaron-0611", "this name already belongs to a type the compiler provides",
        "Some types are built into the compiler rather than written in the standard library -- the "
        "code generator knows their layout and lowers their operations directly. A user type with the "
        "same name would be two different types answering to one name, and which one a program meant "
        "would depend on where it was written.",
        "Rename yours. If you want a wrapper around the built-in behaviour, a distinct name (`TextFile`, "
        "`MyFile`) and a field of the built-in type gives you that without the collision.",
        "Check the built-in names when you are about to declare a very general one -- `File`, `String`, "
        "`Object`. A domain-specific name is usually the better name anyway." }},

    {Code::FieldNeverAssigned, {
        "Polaron-0612", "this field is left with no value by the constructor",
        "A new object's state is whatever its constructor assigns. A field it never touches holds "
        "nothing at all -- not zero, not null, no value -- and the first read of it reads memory that "
        "was never written. Polaron does not zero-fill, because a silent zero is a wrong answer that "
        "looks like a right one.",
        "Assign it in the constructor, or give the field an inline initializer at its declaration so "
        "every constructor starts from it. If a field genuinely has no value until later, say so with "
        "`nullable` and assign `null` here -- that makes the absence part of the type, and every reader "
        "of the field then has to deal with it.",
        "Write each field's initial value where the field is declared unless the constructor's argument "
        "decides it. Then a new constructor cannot forget one. A `record` removes the question "
        "altogether where it fits: its fields are all set by the construction, there is nowhere for one "
        "to be missed, and it copies as a value so nobody has to reason about who owns it either." }},

    {Code::WeakNeedsPointer, {
        "Polaron-0406", "`weak` describes a reference, and this is not one",
        "A weak reference is one that observes without keeping alive: it can be told that what it "
        "pointed at is gone. That only means anything for a pointer. A value is not observing anything "
        "-- it IS the thing -- so `weak` on it has nothing to describe.",
        "Write the pointer: `weak Node* parent` rather than `weak Node parent`. If you did want a "
        "value, drop the `weak`.",
        "`weak` belongs on the back-references in a graph -- a child pointing at its parent, an "
        "observer pointing at its subject -- which are pointers by their nature." }},

    {Code::AtomicTooWide, {
        "Polaron-0809", "this is wider than the machine can do atomically",
        "An atomic operation is one the hardware performs indivisibly, and hardware does that only up "
        "to a machine word. A wider type has to be protected by a lock instead, which the compiler "
        "will not insert silently: a value that says `atomic` and is quietly locked has different "
        "performance and different deadlock behaviour from what the declaration claims.",
        "Make the atomic part fit: hold an atomic index or pointer into the wide value rather than the "
        "value itself, or split it into two atomics that are updated independently. If the operation "
        "genuinely needs both halves at once, that is a critical section -- use a `Mutex<T>` and say "
        "so.",
        "Reach for `atomic` for counters, flags, and pointers, and for a `Mutex` when the invariant "
        "spans more than a word. The width limit is where those two tools divide -- and a `layout` "
        "on the type makes it a stated requirement rather than something discovered here: "
        "`itself.fitWithin(8 bytes)` fails the build the moment a field pushes it past what can be "
        "done atomically, at the declaration, where the decision belongs." }},

    {Code::InterruptMisuse, {
        "Polaron-0810", "an interrupt is entered, not called, and it runs where almost nothing is safe",
        "An interrupt handler is entered by the hardware or the operating system at a moment the "
        "program did not choose -- possibly in the middle of any other line of it. That is what makes "
        "the rules around it strict: it cannot be called like a method (calling it would simulate an "
        "interrupt, which is a different thing wearing the same name); a device has one handler, so a "
        "class declares at most one; it must not allocate or free, because it may have interrupted the "
        "allocator itself; and the state it reaches must be state the interrupted code agreed to share.",
        "For a call: extract the body into an ordinary method, and have both the handler and the caller "
        "use it. For allocation or freeing: do it before, in the code that installs the handler, and "
        "let the handler write into storage that already exists -- a fixed buffer or a ring. For shared "
        "state: make it `volatile` or an `atomic<T>`, which is how the program says that something else "
        "can touch it between two instructions.",
        "Give a handler one job: record what happened somewhere pre-allocated and return. Everything "
        "that interprets, formats, or allocates belongs in the ordinary code that reads the record "
        "afterwards. A `ring region` is the shape that fits: fixed storage taken once at startup, "
        "oldest entry evicted when it fills, and no allocation at the moment of writing -- which is "
        "exactly the guarantee a handler needs and the one a growable structure cannot make." }},

    {Code::TransformerMisuse, {
        "Polaron-0811", "this transformer's contract is not met here",
        "A transformer is expanded into the type that applies it, at compile time, so what it requires "
        "has to be present at that moment: a `procedure` it declares must exist on the applying type "
        "with the signature it declares, a `final procedure` may not be replaced, and a `collective` "
        "one binds every type that applies it. And a procedure must name its subject -- the expansion "
        "has to know which type it is being written into, so a signature that mentions none has no "
        "meaning.",
        "Read the transformer's declaration and match it exactly: same name, same parameters, same "
        "return type, and `procedure` rather than `method` for the ones it declares. If the type "
        "should not be bound by that contract, do not apply the transformer -- `applies` is the whole "
        "of the commitment.",
        "Keep a transformer small and its contract explicit. The narrower the set of procedures it "
        "requires, the fewer types it can be wrong about. The words that make the contract explicit "
        "are worth knowing before they are needed: `final procedure` says an applying type may not "
        "replace this one, `collective` binds every type that applies it to the same answer, `mutual` "
        "says a conversion must exist in both directions, and `entrusts` is how a type consents to "
        "being assembled field by field rather than through its own constructor. Each of them turns a "
        "convention into something the compiler checks." }},

    {Code::TestDeclaration, {
        "Polaron-0812", "this annotation cannot go on this method",
        "The test framework reads annotations to decide what to run and in what order, so each one has "
        "a shape it must find: a `[Test]` takes no parameters unless a `[Cases]` supplies them, a "
        "`[BeforeAll]` runs before any instance exists and so must be static, a class has one `[Setup]` "
        "because two would have no defined order, and a method cannot be both a test and a teardown. "
        "An annotation on the wrong shape would otherwise be ignored at run time, which is the worst "
        "outcome: a test that never runs and never says so.",
        "Match the shape the annotation needs -- usually adding `static`, removing parameters, or "
        "moving one of two conflicting annotations to a separate method. When a test really does need "
        "parameters, give it a `[Cases]` source: a public static method returning the rows to run it "
        "with.",
        "One annotation per method and one job per method. A method that wants two of these labels is "
        "two methods. When the same test should run over many inputs, that is not two methods either: "
        "a `[Cases]` source is a public static method returning the rows, and the `[Test]` takes them "
        "as parameters -- one body, one name in the report per row, and no copied-and-edited tests to "
        "drift apart." }},

    {Code::NamingConvention, {
        "Polaron-0B01", "this name reads against the convention the rest of the language follows",
        "Polaron names bundles, namespaces and types in PascalCase, and transformers with a leading "
        "`T` and an agent-noun ending -- `TNamer`, not `TName`. None of this changes what the program "
        "does. It changes whether a reader can tell what kind of thing a name refers to without "
        "looking it up, which is most of what makes unfamiliar code readable.",
        "Rename it. A bundle or namespace in PascalCase (`Main`, `Geometry`); a transformer as the "
        "thing it makes its subject into (`TDescriber`, `TComparer`).",
        "Pick the name when you declare the thing, in the form its kind uses. Renaming later is cheap "
        "in this language and expensive in habit." }},

    {Code::ShadowsStdlibType, {
        "Polaron-0B02", "the standard library already has a type with this short name",
        "Both types can exist -- they are in different namespaces and the compiler keeps them apart. "
        "The cost is at every use site: a file that imports one of them and mentions the name means "
        "that one, and a reader who knows the standard library will read it as the other. Nothing "
        "breaks, and everyone hesitates.",
        "Give yours a name from its own domain -- `Grid` rather than `Matrix`, `RoutePath` rather "
        "than `Paths`. If it really is the same concept and you want a variant, say so in the name "
        "(`CachingScanner`).",
        "Skim the standard library's names for the area you are working in before declaring a very "
        "general one. The domain-specific name is usually clearer anyway." }},

    {Code::ShadowsField, {
        "Polaron-0B03", "this local hides a field of the same name",
        "Inside this scope the bare name means the local, and the field is only reachable as "
        "`this.name`. That is a deliberate rule and not a bug -- it is what makes `this.x = x` in a "
        "constructor work -- but away from a constructor it usually means one of the two was meant "
        "and the other was written, and both compile.",
        "Rename the local if it is a different thing (`count` and `newCount`), or drop it and assign "
        "the field directly if it is the same thing. Where the shadowing is intended, writing "
        "`this.name` for every use of the field makes the intent visible instead of implied.",
        "Reserve shadowing for the one place it reads well -- a constructor or setter taking a "
        "parameter named after the field it sets." }},

    {Code::UndeclaredThrow, {
        "Polaron-0B04", "this exception leaves the method without being declared",
        "A method that can raise an exception has to say so in its signature (`throws E`), or handle "
        "it. This one does neither, so a caller reading the signature sees a method that cannot fail "
        "-- and finds out otherwise at run time. The signature is where the failure modes of a method "
        "are written down; an exception missing from it is a lie in the type.",
        "Add `throws E` to the method, and the callers will be told to deal with it; or catch it here "
        "and turn it into a value the signature does declare (a `Result`, an `Option`, a status). "
        "Which one depends on whether the caller can do anything useful about it.",
        "Decide a method's failure modes when you write its signature, and let the compiler push the "
        "obligation up to whoever can act on it. When the failure is ordinary rather than "
        "exceptional, a `Result<T, E>` return says so in the type and `try?` forwards it in one "
        "character -- the caller cannot forget it, because the value does not exist until the "
        "failure has been dealt with." }},

    {Code::ClassPointerArith, {
        "Polaron-0B05", "a pointer to a class usually points at one object, not at an array",
        "Pointer arithmetic steps by the size of the pointed-to type, which is only meaningful when "
        "the pointer is into a contiguous run of them. A pointer to a class normally holds the "
        "address of a single object, and stepping off it lands in memory that belongs to something "
        "else -- a write there corrupts an unrelated object, silently, and the crash arrives "
        "somewhere unrelated (spec 27).",
        "Index an array instead: `T[] items; items[i]` says what was meant and is bounds-checked. If "
        "you genuinely hold a pointer into a block of objects, hold the block: keep the array and its "
        "length together rather than a bare pointer.",
        "Let arrays be arrays. A bare pointer in Polaron is for referring to one object; the moment "
        "arithmetic appears on one, the type is not saying what the code is doing. When a method "
        "needs part of an array rather than all of it, `Slice<T>` is the type that means that -- a "
        "window with a length, bounds-checked, and non-owning by declaration, which is what the "
        "pointer arithmetic was trying to express without saying so." }},

    {Code::MutatesByValueParam, {
        "Polaron-0B06", "this changes a copy, and the caller will not see it",
        "A class parameter passed by value is a deep copy -- assignment in Polaron is copying -- so a "
        "method that mutates it mutates the copy, and the argument at the call site is untouched. The "
        "code reads exactly like code that works, which is what makes it worth a warning: nothing at "
        "the call site suggests the change went nowhere.",
        "Take it as `T*` or `T&` if the caller should see the change, which also says so in the "
        "signature. If the mutation is local scratch work, it is fine as it is -- and clearer if the "
        "copy is bound to a differently named local first.",
        "Say the direction in the parameter type: a value for input, a pointer or reference for "
        "something the method is meant to change." }},

    {Code::ForeignSymbolMismatch, {
        "Polaron-0B07", "the calling convention and the symbol it binds do not agree",
        "A foreign symbol's name encodes how it expects to be called on this platform, and the "
        "declared convention has to match what the object file actually exports. When they disagree, "
        "the link may still succeed and the call then pushes and pops the wrong things -- a corrupted "
        "stack, at a call that looks correct in both languages.",
        "Match the declaration to the symbol: `cdecl` for a plain C function, `stdcall` for a Win32 "
        "API. If unsure, check what the library's own header says -- the convention is part of its "
        "public interface, not a detail.",
        "Write the convention from the library's documentation rather than from what happened to "
        "link. This is one of the few mistakes in the language that no run-time check can catch." }},

    {Code::Deprecated, {
        "Polaron-0B08", "this still works and is not going to keep working",
        "A deprecated declaration is one whose author has said there is now a better way and that "
        "this one will be removed. It compiles and behaves exactly as before -- the warning is the "
        "notice period (spec 14.2).",
        "Move to the replacement the declaration names. If the code has to keep using the old one for "
        "now, the warning is the reminder that it is borrowed time; there is no way to silence it per "
        "call, deliberately.",
        "Deal with deprecations while they are still warnings and there is one of them, rather than "
        "at the release where the removal lands and there are forty." }},

    {Code::PersistentIdentity, {
        "Polaron-0B09", "these persistents will be told apart by identity, not by their contents",
        "A persistent is found again across runs by its key. When the key fields are values, two "
        "objects with equal contents are the same persistent and reattach to the same state -- which "
        "is usually the point. When they are not, the object is keyed by its identity instead, so a "
        "logically identical object built in a later run is a DIFFERENT persistent, and the state you "
        "expected to find will not be there.",
        "Give the class value-typed key fields that say what identifies it (an id, a name), so that "
        "rebuilding an equal object finds the same persistent. If identity really is what you want -- "
        "one per live object, not one per logical thing -- then this is correct and can be ignored.",
        "Decide what makes two of these 'the same thing' when you declare the persistent, and put "
        "exactly that in value fields. A `record` is the natural way to say it: it holds values, it "
        "copies rather than aliases, and using one as the key makes 'the same identity' a statement "
        "about contents that a later run can reproduce." }},

    {Code::FixtureLifecycle, {
        "Polaron-0B0A", "this test reads a fixture whose setup it does not run",
        "A `[BeforeAll]`/`[AfterAll]` pair belongs to the class that declares it, and runs around "
        "that class's tests. A test in another class that reads the fixture sees whatever state "
        "happens to be there -- set up if the other class ran first, not if it did not -- so the test "
        "passes or fails depending on test ordering, which is the least useful kind of failure.",
        "Move the test into the class that owns the fixture, or give this class its own "
        "`[BeforeAll]` that establishes what it needs. Sharing read-only constants across classes is "
        "fine; sharing lifecycle is not.",
        "Keep a fixture and the tests that depend on it in one class. A test should be runnable on "
        "its own, and that is only true when its setup is its own." }},

    {Code::StringBuildingInLoop, {
        "Polaron-0B0B", "this builds a String by re-copying it on every iteration",
        "A `String` is immutable, so `s = s + piece` does not append: it allocates a new string and "
        "copies everything already accumulated into it. Inside a loop that makes the work quadratic "
        "in the length of the result -- the first iteration copies nothing and the last copies the "
        "whole thing -- and the cost is invisible at the call site, because the line that pays it is "
        "the shortest one in the loop. Measured on this compiler's own benchmarks: 18.5x slower than "
        "the same loop building through a `StringBuilder`, and the gap widens with the output.",
        "Build through a `System.Text.StringBuilder`: `append` each piece in the loop and call "
        "`toString()` once after it. The pieces are written end to end and the result is copied out a "
        "single time, which is linear. For the two common special cases the standard library is "
        "shorter still -- `Strings.join` for a separator between elements, and `Strings.format` or "
        "`$\"...\"` for a fixed shape with holes in it.",
        "Read `+` on a `String` as \"allocate and copy both sides\", because that is what it is. It "
        "is the right thing for a handful of pieces whose number you can see, and the wrong thing "
        "the moment the number of pieces is a loop bound. The rule that catches it early: a `String` "
        "that is assigned more than once is a `StringBuilder` that has not been written yet." }},

    {Code::StaticsWithoutState, {
        "Polaron-0B10", "this class is only static methods, which is a namespace with a class round it",
        "A class earns its name from state plus the behaviour that guards it. With no fields, "
        "nothing is guarded: what is left is a list of functions that happen to share a prefix, and "
        "every call carries the subject in as an argument, where nothing checks that it is the right "
        "one of its type.",
        "Make it a `transformer` and have the types that want the behaviour `apply` it. The "
        "procedures are expanded into each applying type at compile time, so they reach `itself` "
        "instead of taking the subject as a parameter, they cost no call and no vtable, and the "
        "relation is declared where a reader will look for it. Where the methods really do belong to "
        "no type -- pure arithmetic over primitives -- the class is the right home and this is worth "
        "an `[Allow]` saying so.",
        "Ask what the subject is before writing the first static method. If every one of them takes "
        "the same first argument, the subject already exists and the class is describing it from "
        "outside." }},

    {Code::DataWithoutBehaviour, {
        "Polaron-0B11", "this is public fields with no methods and no invariant, which is a record",
        "A class with nothing to protect still costs what a class costs: identity rather than value, "
        "a reference where a copy was meant, and equality that compares addresses. Two of these with "
        "the same contents are not equal, which is almost never what a row of data is supposed to "
        "mean, and the day somebody needs them to be equal the comparison gets written by hand -- "
        "usually in one of the three places that need it.",
        "Declare it a `record`. Equality, hashing and copying come with it, defined over the fields "
        "rather than the address, and the type says at its first line that it is a value.",
        "Reach for `record` first for anything that is a row -- a point, a range, a parsed header -- "
        "and move to `class` when an invariant appears. Going that way costs one word; going the "
        "other way costs every use site that came to rely on identity." }},

    {Code::ConstantsThatAreAnEnum, {
        "Polaron-0B12", "these constants share a prefix, which is a set being kept by hand",
        "Constants with a common prefix are a type nobody declared. Nothing stops two of them "
        "holding the same value, nothing stops an integer that is none of them arriving where one is "
        "expected, and no `match` over them can be checked for completeness -- so the day a member "
        "is added, every place that handles them keeps compiling and quietly handles one fewer case.",
        "Declare an `enum`. The constants become values of their own type, a `match` over them is "
        "checked for exhaustiveness, and a new member turns every dispatcher that has not heard "
        "about it into a compile error. Where the numbers are a wire format or a foreign ABI rather "
        "than a set of alternatives, they are genuinely integers and this is worth an `[Allow]`.",
        "When a second constant joins the first with the same prefix, that is the moment: the set "
        "exists from then on, and the only question is whether the compiler knows about it." }},

    {Code::StaticTakesItsOwnClass, {
        "Polaron-0B13", "this is an instance method with the receiver written out",
        "A static method whose first parameter is its own class is doing what `this` does, without "
        "any of what `this` gives. A receiver dispatches, so a subclass can answer differently; it "
        "cannot be handed the wrong object of the right type, because there is no argument to swap; "
        "and it is a fact the compiler carries into the backend, which a parameter is not.",
        "Make it an instance method and drop the parameter. The call site changes from "
        "`Thing.act(t, x)` to `t.act(x)`, which is also the order a reader expects: subject first.",
        "The shape usually arrives from a language without methods, or from a helper that grew until "
        "it was really about one type. Notice it the second time the same first parameter appears." }},

    {Code::HungarianNotation, {
        "Polaron-0B14", "this name spells a type the declaration already gives",
        "A prefix that repeats the type writes the type twice: once where the compiler checks it and "
        "once where nothing does. The unchecked copy is the one that survives a change of type, and "
        "from then on the name is wrong in a way that reads as authoritative -- `nCount` that is now "
        "a `long`, `pNode` that is now a reference, `strName` that is now a `String` object rather "
        "than bytes.",
        "Rename it to what the value IS rather than what it is stored as: `count`, `node`, `name`. "
        "Where the prefix was carrying a distinction the type does not -- two integers that must "
        "never be swapped -- the answer is a `newtype`, which makes the compiler keep them apart "
        "instead of asking the reader to.",
        "Name a value after its role in the domain. The type is already on the line, and it is "
        "already checked." }},

    {Code::DefaultOverAClosedSet, {
        "Polaron-0B15", "this has a default over a set whose members the compiler already knows",
        "The point of an enum and of a `sealed` hierarchy is that the whole set is written down, so "
        "a match that lists every member turns the day a member is added into a compile error naming "
        "every place that has not heard about it. A `default` gives that up and replaces it with "
        "silence: the new member falls into the catch-all, the program keeps running, and it does "
        "whatever the fallback did -- which was written for cases nobody had thought of, not for "
        "this one.",
        "List the members and delete the `default`. Collapsing several members into one fallback is "
        "a legitimate thing to want, and the language allows it on purpose -- so where that is the "
        "intention, the `[Allow]` is how it stops being indistinguishable from having forgotten. "
        "(This is about `match` only: a `switch` is required to carry a default, so there is no "
        "choice there to advise about.)",
        "Add the case at the same time as the member. The compiler will name every site for you, "
        "which is the whole reason the type is closed." }},

    {Code::IfChainIsAMatch, {
        "Polaron-0B16", "these branches all compare the same thing, one after another",
        "A chain of `else if`s over one value is a match written the long way. It tests in order, so "
        "the last case pays for every one before it; nothing checks that the cases are distinct, so "
        "two arms can quietly cover the same value; and nothing notices when one is missing, because "
        "a chain has no idea what the complete set would be.",
        "Rewrite it as a `match`. Over an enum or a `sealed` type the compiler then checks the arms "
        "are complete, and the dispatch becomes a jump rather than a run of comparisons.",
        "Reach for `match` at the second branch, not the fourth. The shape is the same either way, "
        "and converting later means re-reading every arm to be sure none of them overlapped." }},

    {Code::RepeatedMagicNumber, {
        "Polaron-0B17", "this number is written out several times in one method",
        "The same literal in three places is one decision recorded three times, and nothing says "
        "whether they mean the same thing or merely happen to be equal. When it changes -- and a "
        "number that appears three times is a number that will -- they change one at a time, and the "
        "one that is missed is a bug that looks like arithmetic.",
        "Give it a name with `fixed`: `fixed int SLOTS = 64;`. It is a compile-time constant, so "
        "nothing is paid for the name, and every use now says what the number is for rather than "
        "what it is.",
        "Name a number the second time you write it. The first time it is an answer; the second time "
        "it is a decision, and a decision belongs somewhere a reader can find it." }},

    {Code::ThrowCaughtHere, {
        "Polaron-0B18", "this try raises and catches its own exception",
        "Unwinding is built for the case where the code that fails and the code that knows what to "
        "do are far apart -- across a call, across a layer. When they are four lines apart it buys "
        "nothing and costs a table lookup, a landing pad, and an edge in the control-flow graph the "
        "optimiser cannot see through, to express what an `if` or a `Result` says in the type.",
        "Return a `Result<T, E>` from the failing step and `match` on it, or, where it really is a "
        "local decision, use an `if` and skip the machinery altogether. Keep the exception for "
        "failures that leave this method.",
        "Ask, when writing the `throw`, who is meant to hear it. If the answer is the same method, "
        "the failure is a value, not an event." }},

    {Code::ResultNeverExamined, {
        "Polaron-0B19", "this call returns a Result or Option and the statement drops it",
        "The signature went to the trouble of making the failure visible, and the call site undoes "
        "it. What is left reads like a call that cannot fail -- there is nothing at the site to "
        "suggest otherwise -- and the failure that did happen goes nowhere at all. That is worse "
        "than an unchecked error code, because the type promised somebody was looking.",
        "Look at it: `match` on it, take the value with `valueOr`, or propagate with `try?`. Where "
        "the failure genuinely does not matter here, say so once -- discard it into a named local, "
        "or write the `[Allow]` -- so the next reader knows it was a decision.",
        "Treat a `Result` like a value that has to go somewhere, because that is what it is. The "
        "compiler will start insisting on this the day `mustuse` lands; until then the rule is the "
        "same and this is what says so." }},

    {Code::HeapWithLexicalLifetime, {
        "Polaron-0B1A", "this is allocated on the heap and deleted in the same block",
        "Both ends of the lifetime are written in one set of braces, so the block has already "
        "answered the question the allocator is being asked. What the heap costs here is a call out "
        "to the allocator and back, an object placed wherever the free list happened to point, and "
        "one more path on which an early return leaks it.",
        "Write `on stack` and drop the `delete`. The object is destroyed when the block ends -- "
        "including on every early return and every path out through a failure -- the allocation is a "
        "pointer bump, and the object sits where the rest of the frame already is.",
        "Start on the stack and move to the heap when something has to outlive the block. Going that "
        "way, the heap always has a reason; going the other way, it never had one." }},

    {Code::RepeatedCleanup, {
        "Polaron-0B1B", "this cleanup is repeated before more than one return",
        "Cleanup copied before each exit is correct exactly as long as nobody adds another exit. "
        "Another exit is always added -- usually in a hurry, usually inside a branch, usually the "
        "one place the copy is easiest to forget -- and the leak that follows is invisible at the "
        "line that caused it.",
        "Write `defer delete x;` once, at the point the resource is acquired. It runs on every path "
        "out of the method, in reverse order, including the paths that do not exist yet. `using` is "
        "the same idea where the scope is narrower than the method.",
        "Pair the acquisition with its `defer` on the same line you write it, before there is any "
        "control flow to get it wrong in." }},

    {Code::ThrowInLoop, {
        "Polaron-0B1C", "this throw is inside a loop",
        "Unwinding is priced for the rare path: a table lookup, a landing pad, and an edge the "
        "optimiser cannot see through, so the loop around it stops being a loop it can reason about. "
        "A failure that ends a loop is usually not exceptional at all -- it is the loop finishing "
        "early, which is what `break` is for, or a failure the caller should be handed as a value.",
        "Break out of the loop and decide outside it, or return a `Result` from the step that can "
        "fail and `match` on it. Keep the `throw` for the failure that has to leave the method, and "
        "leave the hot path clean.",
        "Ask what should happen next when writing the `throw`. If the answer is `stop looping`, the "
        "answer is `break`." }},

    {Code::HierarchyNotSealed, {
        "Polaron-0B1D", "every subtype of this is in this program, and the declaration does not say so",
        "An open base type is a promise that anybody may extend it, and that promise costs exactly "
        "what it is worth: no `match` over the type can be checked for completeness, no call through "
        "it can be resolved to a body, and a subtype nobody planned for is a run-time surprise rather "
        "than a compile error. When every subtype is already here, none of that is being paid for "
        "anything.",
        "Write `sealed <base> permits A, B`. The compiler then checks that a `match` covers them, "
        "resolves calls where it can, and refuses the day somebody adds a subtype without adding it "
        "to the list -- which is the reminder that would otherwise never come. A base genuinely "
        "meant to be extended from outside is what `[Allow]` is for.",
        "Seal by default and open deliberately. Opening later is one word; discovering later that "
        "half the program assumed the set was closed is not." }},

    {Code::AbstractWithOneSubtype, {
        "Polaron-0B1E", "this abstract class has exactly one subtype",
        "Two types describing one thing. The base cannot be instantiated and the subtype is the only "
        "way to get one, so the split buys no polymorphism at all -- what it costs is a vtable, a "
        "call the compiler cannot see through, and a reader holding two files open to follow one "
        "object.",
        "Fold them into one class. Where the split is there because a second subtype is coming, that "
        "is a real reason and the `[Allow]` is where it goes -- with the name of the one that is "
        "coming, so the note expires when it arrives.",
        "Introduce the abstraction at the second implementation, not the first. One implementation "
        "behind an interface is a guess about the future written in a place that charges rent." }},

    {Code::AnnotationMisuse, {
        "Polaron-0613", "this does not match how the annotation was declared",
        "An annotation is a declared type with named fields: which fields exist, which of them are "
        "required, and what each one holds are written where the annotation is declared. An applied "
        "one that names a field that is not there, names the same field twice, or leaves a required "
        "field out is not a small spelling problem -- the thing reading the annotation later, a test "
        "runner, a serializer, a suppression, will look for a value that was never given.",
        "Open the annotation's declaration and match it. A field with no `default` is required and "
        "has to be supplied at every use; one with a default may be left out. A field the "
        "declaration does not list is either a typo or a field that belongs on a different "
        "annotation.",
        "Give an annotation a default wherever a sensible one exists, and leave it out where the "
        "value genuinely has to be a decision -- a required field is how a declaration makes the "
        "compiler ask the question, which is worth far more than a default that is quietly wrong." }},

    {Code::AllowNeverUsed, {
        "Polaron-0B0C", "this [Allow] never suppressed anything",
        "An `[Allow]` says the code below disagrees with a rule for a reason, and names the rule. "
        "When nothing below reports that rule any more, what is left is a note asserting something "
        "about the code that has quietly stopped being true -- the shape it excused was rewritten, "
        "or the rule was narrowed, and nobody went back. That is worse than having no note, because "
        "the next reader believes it and works around a constraint that is gone.",
        "Delete it. If the suppression is still wanted for a rule that moved to another code, name "
        "the code that actually reports now -- the one in the warning you are trying to silence.",
        "Write an `[Allow]` on the smallest declaration that needs it, never on a whole class when "
        "one method is the reason. A narrow one goes stale loudly, the moment its method changes; a "
        "wide one keeps finding something to suppress and never tells you the reason expired." }},

    {Code::MutableNeverMutated, {
        "Polaron-0B0D", "nothing ever assigns to this, so `mutable` claims a freedom it does not use",
        "In Polaron a name is constant unless it says `mutable`, so the word is not decoration: it "
        "is the declaration that this value will change, and every reader of the line plans for "
        "that. When nothing assigns to it, the word costs a reader the question `where does this "
        "change?` -- which has no answer -- on every pass through the code. It also throws away the "
        "one thing the compiler could have relied on, since a value proven never to change is a "
        "fact the optimiser can use and a `mutable` one is not.",
        "Drop the `mutable`. If the plan is to assign to it soon, drop it now anyway and put it back "
        "with the assignment: the two belong in the same change, and one without the other is what "
        "leaves these behind.",
        "Write the declaration without `mutable` first and let the compiler ask for it. Reaching for "
        "it in advance is how a codebase ends up with the word on everything, at which point it says "
        "nothing about any particular line." }},

    {Code::SwallowedCatch, {
        "Polaron-0B0E", "this `catch` neither handles the failure nor lets anyone know it happened",
        "A catch whose body is empty -- or is only a comment -- turns a failure into silence. The "
        "program keeps going with whatever state the half-finished operation left, and the evidence "
        "that anything went wrong is destroyed at the one point where it existed. The bug that "
        "follows shows up somewhere else entirely, with nothing pointing back here, which is the "
        "most expensive shape a defect can take.",
        "Do one of three things, and any of them is enough: rethrow (or let it propagate), report it "
        "-- a log line, a `Result` returned to the caller -- or write down in the body why the "
        "failure is genuinely nothing, so the next reader does not have to guess. A comment alone "
        "does not count as the third: put it in an `[Allow(code: \"Polaron-0B0E\", why: ...)]`, "
        "where it is a claim somebody can review.",
        "Decide what a failure means at the moment you write the catch, not later. `catch { }` is "
        "almost always a note to self that never got finished." }},

    {Code::AsyncNeverAwaits, {
        "Polaron-0B0F", "this method is `async` and never awaits anything",
        "`async` is not a label for slow work: it turns the method into a state machine, returns a "
        "`Task<T>` rather than the value, and puts the body on the scheduler. A body with no `await` "
        "in it has nothing to suspend on, so all of that is paid and none of it is used -- an "
        "allocation, an indirection and a scheduling hop, in exchange for making every caller await "
        "a result that was ready before it asked.",
        "Remove `async` and return the value directly; the callers lose their `await` with it. If "
        "the method is async because an interface or a caller demands the shape, that is the reason "
        "to record in an `[Allow]`.",
        "Add `async` when the first `await` goes in, not when the method is written. Marking it in "
        "advance is how a codebase ends up with a scheduler between two functions that could have "
        "been one call." }},

    {Code::ImportNameMismatch, {
        "Polaron-0106", "this name was brought in under a different path",
        "An import names one type by its full path, and inside the file that name means exactly what "
        "was imported. Writing it as a different path -- or writing the short name when the import "
        "brought in a qualified one, or the other way round -- names something the file has not been "
        "given. Two types can share a short name across namespaces, which is why the import decides "
        "and not the use.",
        "Use the name the import introduced, or change the import to the path you meant. When two "
        "namespaces really do declare the same short name, only one of them can be imported into a "
        "file; reach the other through an instance or move the code that needs it.",
        "Import at the top of the file the exact types the file uses, one per line. Then the name at "
        "the use site and the name in the import are the same string, and there is nothing to get "
        "wrong." }},

    {Code::BitFieldRange, {
        "Polaron-0704", "this value does not fit the bits the field was given",
        "A bit field declares how many bits it has, and that fixes its range exactly. A literal "
        "outside it would be stored truncated -- a different number, silently, with no run-time check "
        "to catch it, because the truncation is what the hardware does. A SIGNED field spends one of "
        "its bits on the sign, so a 3-bit `int` holds -4 to 3 rather than 0 to 7, which is where this "
        "usually bites.",
        "Widen the field, or make it unsigned if the values are counts or ordinals and never negative "
        "-- an unsigned 3-bit field holds 0 to 7. If the value is genuinely out of range for what the "
        "field means, the value is the thing to fix.",
        "Decide signedness from the meaning, not the habit: quantities that cannot be negative should "
        "say so in the type, and then every bit is spent on range. And when the reason for hand-"
        "packing is a size budget, say the budget instead of the packing: a `layout` with "
        "`itself.fitWithin(12 bytes)` states what the type must cost, lets the compiler arrange the "
        "fields to meet it, and `itself.refuse(\"...\")` fails the build with your own sentence when "
        "it cannot. Chosen widths then answer to a stated requirement rather than to arithmetic "
        "somebody did once." }},

    {Code::ComptimeConstant, {
        "Polaron-0807", "this must be a compile-time constant",
        "Some positions are evaluated by the compiler, not at run time -- a `comptime` argument, a `fixed` "
        "field initializer, an array size. They require a constant expression built from literals and other "
        "compile-time values.",
        "Supply a constant expression: a literal, a `fixed`/`comptime` value, or an operation on those. "
        "Move any run-time computation elsewhere; only compile-time-known values belong here.",
        "Keep compile-time inputs (sizes, config constants) as `fixed`/`comptime` values so they compose "
        "into other constant positions. A run-time value in a constant slot is the mismatch this flags." }},

    {Code::PersistentLifecycle, {
        "Polaron-0808", "a persistent is never released",
        "A `persistent` outlives normal scope and must be explicitly torn down: the program needs a "
        "`release persistent` for it somewhere, or the resource it holds lives forever.",
        "Add a `release persistent <name>;` on the path that ends its life. Pair every persistent's "
        "creation with a release, the way `new` pairs with `delete`.",
        "Treat a persistent like any owned resource: decide where it is released when you declare it. "
        "Keeping the create/release pair in view prevents the leak this catches -- and the language "
        "has two ways to keep them in view without relying on memory. `defer` puts the release beside "
        "the creation and runs it however the scope ends, including through a `throw`; `using` binds "
        "the two together outright, so there is no path on which one happens and the other does not. "
        "A release written at the bottom of a long method is the one that gets skipped by an early "
        "return." }},

    {Code::NotSupportedYet, {
        "Polaron-0A01", "not implemented yet",
        "This construct is valid Polaron but the current compiler does not implement it yet. It is a gap in "
        "the toolchain, not a mistake in your code.",
        "Rework the code to avoid the unimplemented corner for now (the message says which one), or track "
        "the feature and revisit when the compiler grows it. Nearby language features usually cover the case.",
        "When you hit a not-yet-implemented corner, isolate it behind a small method so swapping in the real "
        "feature later is a one-line change. Report it so it gets prioritized." }},

    {Code::FreestandingRestriction, {
        "Polaron-0901", "not available in freestanding mode",
        "Freestanding mode (spec 36) targets bare metal with no runtime: features that need one -- "
        "async/await, exceptions, unimport, reflection, the Console -- are unavailable there by design.",
        "Remove the feature from freestanding code, or drop `freestanding` if this program actually runs on "
        "a host. Use the freestanding-safe equivalents: Result/Option for errors, raw Memory for I/O.",
        "Decide up front whether a program is freestanding; keep host-only features out of the modules it "
        "compiles. The restriction is the compiler guaranteeing your kernel pulls in no runtime. What "
        "remains available is most of the language and the parts of it built for this: `address` for a "
        "raw machine word, the `Memory` API for reading and writing one, `region ... at address` for "
        "memory the hardware maps rather than the allocator hands out, and `extern` for anything the "
        "firmware already provides. A freestanding program is not a subset of Polaron with the "
        "interesting parts removed; it is the same language with the host taken away." }},
};
// clang-format on

const Entry kEmpty{"", "", "", "", ""};

// The message -> code rules for classify(). First match wins, so order from most specific to least. A
// rule fires when its needle appears anywhere in the message. Kept next to the catalog so a new rule and
// its entry are added together.
struct Rule {
    std::string_view needle;
    Code code;
};
constexpr Rule kRules[] = {
    // Context restriction wins over the specific feature it restricts (async/exceptions/unimport/... ).
    {"not available in freestanding", Code::FreestandingRestriction},
    {"freestanding mode", Code::FreestandingRestriction},

    // THE REGION BINDER'S FOUR REASONS, each before the generic "region-binder:" rule below, because
    // first match wins and that one would otherwise explain frame escape for all of them -- confident
    // advice for a mistake the reader did not make.
    {"neither is known to outlive the other", Code::RegionIncomparable},
    {"is an extern function", Code::RegionForeignBoundary},
    {"was emptied: it holds references", Code::RegionUseAfterInvalidate},

    // Null safety BEFORE the general type rules: every one of these is also "a wrong type", but the
    // remedy is different -- casting cannot turn null into a non-nullable value -- so matching them as
    // TypeMismatch handed out advice ("convert explicitly with cast<T>") that cannot work.
    {"is non-nullable", Code::NullSafety},
    {"cannot assign null", Code::NullSafety},
    {"cannot return null", Code::NullSafety},

    // Operand/type rules before the more general operator/assignment ones.
    {"requires int operands", Code::BadOperand},
    {"requires an integer operand", Code::BadOperand},
    {"requires a boolean operand", Code::BadOperand},
    {"unsupported binary operator", Code::BadOperand},
    {"unsupported unary", Code::BadOperand},
    {"ternary condition must be boolean", Code::BadOperand},

    {"expects one type argument", Code::ReflectionMisuse},
    {"reflect", Code::ReflectionMisuse},
    {"reflection", Code::ReflectionMisuse},

    // "method 'x' expects N argument(s)" is an arg-count error, not a missing method.
    {"expects", Code::ArgCount},
    {"no argument for parameter", Code::ArgCount},
    {"positional argument after a named", Code::ArgCount},
    {"tuple destructuring expects", Code::ArgCount},
    {"lock op takes one handle", Code::ArgCount},

    {"has no field", Code::NoSuchField},
    {"has no method", Code::NoSuchMethod},
    {"no method '", Code::NoSuchMethod},
    {"cannot bind a static method", Code::NoSuchMethod},

    // WHAT WAS FALLING THROUGH TO NO CODE AT ALL. Measured across the 90 error programs the suite
    // keeps: 45 of 111 diagnostics printed as a bare line, with no why, no fix and nothing for
    // `explain` to find. These are the rules behind them, and `diagnostics_all_carry_a_code` fails
    // if the number ever climbs again.
    {"has no entry point", Code::NoEntryPoint},
    {"already has a constructor", Code::DuplicateConstructor},
    {"is a type the compiler provides", Code::ShadowsBuiltinType},
    {"never assigns field", Code::FieldNeverAssigned},
    {"'weak' requires a pointer", Code::WeakNeedsPointer},
    {"is wider than a machine word", Code::AtomicTooWide},
    {"is already declared in class", Code::DuplicateField},
    {"cannot return a value of type", Code::ReturnTypeMismatch},
    {"cannot mix signed and unsigned", Code::BadOperand},
    {"is used before it is initialized", Code::UndeclaredVariable},
    {"may be used before it is initialized", Code::UndeclaredVariable},
    {"has already been initialized", Code::AssignImmutable},
    // The `move` family: the type says single-owner and a binding did not say `move`.
    {"so it gives up ownership", Code::MoveRequired},
    {"so the call has to say so", Code::MoveRequired},
    // An interrupt is entered rather than called, and runs where almost nothing is safe.
    {"an interrupt", Code::InterruptMisuse},
    {"interrupt is entered", Code::InterruptMisuse},
    {"already declares an interrupt", Code::InterruptMisuse},
    {"a hosted interrupt", Code::InterruptMisuse},
    {"a freestanding interrupt", Code::InterruptMisuse},
    {"an interrupt reaches", Code::InterruptMisuse},
    {"the trap an interrupt receives", Code::InterruptMisuse},
    // Transformer contracts: what a type promised by writing `applies`.
    // ADVICE. Warnings reach classify() the same way errors do, and had no rules at all: 1309 of
    // them across the test corpus, one with a code. A warning needs its `why` more than an error
    // does -- an error at least stops you, while a warning is only worth printing if the reader can
    // tell from it whether it applies to them.
    {"should start with a capital letter", Code::NamingConvention},
    {"should be named `T", Code::NamingConvention},
    {"is also declared by the standard library", Code::ShadowsStdlibType},
    {"shadows the field of the same name", Code::ShadowsField},
    {"is neither caught nor declared", Code::UndeclaredThrow},
    {"pointer arithmetic on", Code::ClassPointerArith},
    {"changes the object it is called on", Code::MutatesByValueParam},
    {"but the symbol it binds", Code::ForeignSymbolMismatch},
    {"is deprecated", Code::Deprecated},
    {"would key its persistents by identity", Code::PersistentIdentity},
    {"which owns a [BeforeAll]", Code::FixtureLifecycle},

    {"is imported as", Code::ImportNameMismatch},
    {"does not fit '", Code::BitFieldRange},
    {"unknown transformer", Code::TransformerMisuse},
    {"does not entrust", Code::TransformerMisuse},
    {"applies transformer", Code::TransformerMisuse},
    {"comes from a transformer", Code::TransformerMisuse},
    {"but no transformer", Code::TransformerMisuse},
    {"is `mutual`", Code::TransformerMisuse},
    {"which is closed over", Code::TransformerMisuse},
    {"`collective` transformer", Code::TransformerMisuse},
    {"declares `final procedure", Code::TransformerMisuse},
    {"names no subject", Code::TransformerMisuse},
    // Test-framework annotations, where the failure mode is a test that silently never runs.
    {"'[Setup]' method", Code::TestDeclaration},
    {"'[BeforeAll]'", Code::TestDeclaration},
    {"'[Teardown]'", Code::TestDeclaration},
    {"'[Ignore]'", Code::TestDeclaration},
    {"'[Cases]'", Code::TestDeclaration},
    {"'[Benchmark]'", Code::TestDeclaration},
    {"[Test] method", Code::TestDeclaration},

    {"use of undeclared variable", Code::UndeclaredVariable},
    {"assignment to undeclared variable", Code::UndeclaredVariable},
    {"modification of undeclared variable", Code::UndeclaredVariable},
    {"use of variable '", Code::UseAfterMove},
    {"use of field '", Code::UseAfterMove},
    {"after it was moved", Code::UseAfterMove},
    {"cannot move", Code::MoveMisuse},

    {"references unknown type", Code::UnknownType},
    {"unknown type", Code::UnknownType},
    {"unknown class", Code::UnknownName},
    {"unknown call", Code::UnknownName},
    {"unknown region", Code::UnknownName},
    {"unknown annotation", Code::UnknownName},
    {"unknown label", Code::UnknownName},
    {"import of unknown symbol", Code::UnknownName},

    {"not accessible", Code::NotAccessible},
    {"is private", Code::NotAccessible},
    {"is internal", Code::NotAccessible},

    {"immutable", Code::AssignImmutable},
    {"invalid assignment target", Code::InvalidAssignTarget},
    {"invalid '++'/'--' target", Code::InvalidAssignTarget},

    {"cannot cast", Code::BadCast},
    {"cannot index", Code::BadIndex},
    {"index must be an integer", Code::BadIndex},
    {"vector index must be", Code::BadIndex},

    {"cannot assign a value of type", Code::TypeMismatch},
    {"cannot initialize variable", Code::TypeMismatch},
    {"cannot initialize field", Code::TypeMismatch},
    {"synchronized requires", Code::TypeMismatch},

    {"initializer for static field", Code::StaticInitNotConst},
    {"region-binder:", Code::EscapesFrame},
    // Before the generic "cannot move" rule -- first match wins, and that one explains the opposite
    // mistake (moving something unmovable, not failing to move something movable).
    {"is movable, so it is transferred", Code::MoveRequired},

    {"must return a value", Code::MissingReturn},
    {"paths return", Code::MissingReturn},
    {"must return Iterator", Code::ReturnTypeMismatch},
    // Before the generic `'try?'` rule -- first match wins, and that one would otherwise swallow this
    // and explain the wrong mistake (the method DOES return a Result; it is the failure that misfits).
    {"'try?' propagates", Code::TryErrorType},
    {"'try?'", Code::TryContext},
    {"try? can only", Code::TryContext},

    {"match requires a 'default'", Code::MatchNotExhaustive},
    {"match expression requires", Code::MatchNotExhaustive},
    {"match on sealed", Code::MatchNotExhaustive},
    {"must have a 'default'", Code::MatchNotExhaustive},

    {"cannot override final", Code::IllegalOverride},
    {"cannot extend", Code::IllegalExtend},
    {"sealed variant", Code::IllegalExtend},
    {"does not satisfy constraint", Code::ConstraintNotMet},
    {"contradictory", Code::ContradictoryModifiers},
    {"compile-time constant", Code::ComptimeConstant},
    {"release persistent", Code::PersistentLifecycle},
    {"not supported yet", Code::NotSupportedYet},
    {"not implemented", Code::NotSupportedYet},

    {"redeclaration", Code::Redeclaration},
    {"shadowing of variable", Code::Redeclaration},
    {"duplicate field", Code::DuplicateField},
    {"duplicate enum constant", Code::DuplicateMember},
    {"duplicate catalog value", Code::DuplicateMember},
    {"duplicate argument", Code::DuplicateMember},
    {"cycle involving", Code::InheritanceCycle},

    {"demand not met", Code::Demand},
    {"a demand is settled", Code::Demand},
    {"operator '", Code::OperatorOverload},
    // Region flavor / extract diagnostics (spec 17, flavors expansion) -- before the generic "region "
    // rule so they win. Each needle is a phrase the analyzer/parser guarantees in the matching message.
    {"exactly one flavor", Code::RegionTwoFlavors},
    {"only qualifies a region", Code::RegionFlavorOnNonRegion},
    {"was extracted", Code::RegionUseAfterExtract},
    {"lives in the same region", Code::RegionExtractInnerField},
    {"extract result must be bound", Code::RegionExtractNotBound},
    {"mark/rollback need a", Code::RegionMarkNonStack},
    {"this checkpoint belongs to region", Code::RegionCheckpointWrongRegion},
    {"needs its single element type", Code::RegionFixedslotAcceptsRequired},
    {"a ring region auto-evicts", Code::RegionRingNoDelete},
    {"growable does not apply", Code::RegionGrowableContradiction},
    {"growable does not compose", Code::RegionGrowableContradiction},
    {"region ", Code::RegionMisuse},
    {"vector ", Code::VectorMisuse},
    {"mat4 ", Code::VectorMisuse},
    {"a vector lane", Code::VectorMisuse},
    {"unimport", Code::UnimportMisuse},
    {"reimport", Code::UnimportMisuse},
    {"printf ", Code::PrintfFormat},
    {"println/print expects", Code::PrintfFormat},
    {"first argument to printf", Code::PrintfFormat},

    {"literal suffix", Code::LiteralSuffix},
    {"interpolation", Code::StringInterp},
};
}  // namespace

const Entry& entry(Code code) {
    for (const Row& r : kCatalog) {
        if (r.code == code) {
            return r.entry;
        }
    }
    return kEmpty;
}

const Entry* entryByCodeString(std::string_view codeStr) {
    for (const Row& r : kCatalog) {
        if (r.entry.codeStr == codeStr) {
            return &r.entry;
        }
    }
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

Code classify(std::string_view message) {
    for (const Rule& r : kRules) {
        if (message.find(r.needle) != std::string_view::npos) {
            return r.code;
        }
    }
    return Code::None;
}

namespace {
bool g_conciseMode = false;
}
void setConcise(bool concise) { g_conciseMode = concise; }
bool conciseMode() { return g_conciseMode; }

}  // namespace polaron::diag
