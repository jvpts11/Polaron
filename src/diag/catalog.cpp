#include "diag/diagnostic.h"

// The diagnostic catalog: for each code, the canonical why / how-to-fix / how-to-prevent. Written once
// here, per rule, so the wording stays consistent everywhere it appears -- the terminal, `ldp3 explain`,
// and the Forge hover. The call-site supplies only the specific title (the names and types involved).
//
// classify() infers a code from a message so the hundreds of existing call-sites become rich without
// being edited; the mapping is the one reviewable table at the bottom of this file.
namespace ldp3::diag {

namespace {
struct Row {
    Code code;
    Entry entry;
};

// clang-format off
constexpr Row kCatalog[] = {
    {Code::SyntaxError, {
        "LDP3-0001", "unexpected syntax here",
        "The parser reached something it did not expect for this construct: LDP3 has a fixed grammar, so "
        "every statement, declaration, and expression has a required shape. The token here does not fit it.",
        "Compare the line with a working example of the same construct. The usual causes are a missing `;` "
        "or `}`, a keyword left out (every block needs `{ }`; every method a `returns` type), or `{}` used "
        "inline where LDP3 wants each statement on its own line.",
        "Let the editor close brackets and indent for you, and build often so a syntax slip is caught one "
        "line after you make it. The subset reference (F1) shows each construct's exact shape." }},

    {Code::LexError, {
        "LDP3-0002", "cannot read this text",
        "The lexer -- the first pass, which turns characters into tokens -- hit something it cannot form a "
        "token from: an unterminated string or char literal, a stray character, or a malformed number.",
        "Close the string/char literal, remove the stray character, or fix the number. The caret points at "
        "where the lexer gave up, which is usually just after where the real mistake is.",
        "Type quotes and brackets in pairs (the editor helps), and keep literals on one line. A syntax "
        "theme makes an unterminated string obvious -- the colour runs to the end of the line." }},

    {Code::UndeclaredVariable, {
        "LDP3-0101", "not declared in this scope",
        "A name must be declared before it is read -- as a local (var/mutable), a parameter, a field (via "
        "this.), or a namespace constant. This name matches nothing visible here, which is almost always a "
        "typo or a missing declaration.",
        "If it is a typo, use the suggested name. Otherwise declare it before this point, e.g. "
        "`mutable int name = ...;`, or -- for a field -- write `this.name` and add the field to the class.",
        "Let the editor autocomplete names (Ctrl+Space in Forge). Forge's live check flags an undeclared "
        "name as you type, and Alt+Enter applies the suggested fix." }},

    {Code::NoSuchField, {
        "LDP3-0102", "no such field on this type",
        "A field must be declared in the class (or a superclass) before it can be read or assigned. The "
        "type here declares no field by this name, so the access cannot resolve.",
        "Use the correct field name (see the suggestion, if any), or add the field to the class: "
        "`public mutable T name;`. If you meant a method, call it with `()`.",
        "Member autocomplete after `this.` or `obj.` lists the real fields. Keeping one class per concern "
        "makes its fields easy to remember; the structure panel (Ctrl+F12) shows them at a glance." }},

    {Code::NoSuchMethod, {
        "LDP3-0103", "no such method on this type",
        "A method must be declared on the type (or a superclass/interface it has) before it can be called. "
        "The receiver's type exposes no method by this name.",
        "Call an existing method (member autocomplete lists them), or declare the method on the class. "
        "Check the receiver's type is what you expect -- a wrong type is a common cause.",
        "Member autocomplete and go-to-definition (F12) confirm a method exists before you call it. "
        "Interfaces make the available methods explicit at the call site's declared type." }},

    {Code::UnknownType, {
        "LDP3-0104", "unknown type",
        "Every type name must resolve to a declared class, interface, enum, record, struct, or a built-in "
        "primitive. This name resolves to none of them -- it is misspelled, not imported, or not declared.",
        "Spell the type as declared, add the missing `import <bundle>.<namespace>.<Type>;`, or declare the "
        "type. Cross-namespace types need an import even within the same program.",
        "Import autocomplete completes type names as you type the import. The stdlib browser (F1) lists "
        "every built-in type; the structure panel lists the project's own." }},

    {Code::UnknownName, {
        "LDP3-0105", "no such name",
        "This name (a class, region, label, imported symbol, or annotation) refers to something that is "
        "not declared or not in scope here, so the compiler cannot resolve what you mean.",
        "Declare or import the thing before you name it, or correct the spelling. For a label, define it "
        "with `name:` in the same method; for an import, add the matching `import`.",
        "Declare before you use, and let autocomplete supply names that already exist. Workspace symbols "
        "(Ctrl+T) find a name across the whole project." }},

    {Code::NotAccessible, {
        "LDP3-0201", "not accessible from here",
        "A member's visibility limits where it can be used: `private` is its own class only, `protected` "
        "adds subclasses, `internal` is the same bundle, `public` is everywhere. This access is outside "
        "the member's allowed scope.",
        "Access it from an allowed scope, widen the member's visibility if that is intended (e.g. make it "
        "`public`), or add a public method that exposes what you need instead of the member directly.",
        "Decide a type's public surface up front and keep internals `private`; reach them through methods. "
        "Explicit visibility on every member (LDP3 requires it) keeps the boundary in view." }},

    {Code::NullSafety, {
        "LDP3-0300", "null where a value is required",
        "Every type in LDP3 is non-null by default: `Tree*` is a pointer that always points at something. "
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
        "LDP3-0301", "wrong type here",
        "LDP3 is statically typed: a value's type must match where it is used. Assignment, arguments, and "
        "returns do not convert types implicitly, because a silent conversion is where bugs hide.",
        "Produce a value of the expected type, or convert explicitly with `cast<T>(value)` when the "
        "conversion is intended and safe. Check you are using the variable you think you are.",
        "Name types clearly and let `var` infer locals from an obviously-typed initializer. Forge's hover "
        "shows a value's type, so a mismatch is visible before you build." }},

    {Code::ArgCount, {
        "LDP3-0302", "wrong number of arguments",
        "A method is called with exactly its declared parameters -- LDP3 has no overloading, so one name "
        "means one signature. Too few or too many arguments cannot match it.",
        "Pass exactly the declared parameters, in order. Signature help (in Forge, inside the `(`) shows "
        "them; check the method's declaration if unsure.",
        "Signature help as you type the call keeps the parameter list in front of you. One method, one "
        "signature (no overloading) means there is never a wrong overload to guess at." }},

    {Code::ReturnTypeMismatch, {
        "LDP3-0303", "return type does not match",
        "A `return` must produce a value of the method's declared return type (or nothing, for `void`). "
        "The returned value's type does not match what the method promises.",
        "Return a value of the declared type, convert it with `cast<T>(...)` if intended, or change the "
        "method's declared return type to match what it actually returns.",
        "State return types explicitly (LDP3 requires them on methods) so the promise is visible. Forge's "
        "hover shows the expression's type next to the declared one." }},

    {Code::ArgType, {
        "LDP3-0304", "argument type does not match the parameter",
        "Each argument's type must match (or be a subtype of) the parameter it is passed to; there is no "
        "implicit conversion. The value here is a different type than the parameter accepts.",
        "Pass a value of the parameter's type, or convert with `cast<T>(...)`. If you passed arguments in "
        "the wrong order, reorder them to match the declaration.",
        "Signature help shows each parameter's type as you fill the call in. Naming variables after what "
        "they hold makes an out-of-order or wrong-type argument obvious at the call site." }},

    {Code::BadCast, {
        "LDP3-0305", "this cast is not allowed",
        "`cast<T>(value)` converts between types the language knows how to convert -- numbers, a base and "
        "its subclass, an int and a pointer in freestanding. This pair is not one of them.",
        "Cast only between convertible types. To treat an object as a related type, cast up or down its own "
        "hierarchy; to reinterpret raw memory, do it in freestanding with pointer/address casts.",
        "Prefer designs where a value already has the type you need over casting to it. Where a cast is "
        "genuinely needed, a comment on why keeps the intent (and its safety) clear." }},

    {Code::BadIndex, {
        "LDP3-0306", "cannot index this",
        "Indexing with `[i]` needs an array (or a pointer, in freestanding) and an integer index. Either "
        "the value indexed is not an array, or the index is not an integer.",
        "Index an array value, and use an integer index. If the value is a collection like ArrayList, use "
        "its `get(i)` method rather than `[]`.",
        "Give arrays and indices names that say so. Forge's hover shows a value's type, so indexing a "
        "non-array is caught before you build; `.length()` bounds a loop safely." }},

    {Code::BadOperand, {
        "LDP3-0307", "operator applied to the wrong type",
        "Each operator requires operands of a particular type: arithmetic and bitwise want integers, `!` "
        "wants a boolean, `~` wants an integer, and so on. An operand here is a type the operator rejects.",
        "Convert the operand to the type the operator expects, or use the right operator for the types you "
        "have (e.g. `&&`/`||` for booleans, `&`/`|` for integer bits).",
        "Keep boolean and integer values distinct in your head and your names; most operand errors are a "
        "boolean where a number was meant, or the bitwise operator where the logical one was meant." }},

    {Code::AssignImmutable, {
        "LDP3-0401", "this is not mutable",
        "Values are immutable by default in LDP3; only a `mutable` variable or field can be reassigned. "
        "Assigning to an immutable binding would break the guarantee that it never changes after init.",
        "Mark the declaration `mutable` if it is meant to change (`mutable int n = 0;`), or avoid the "
        "reassignment -- often a new local expresses the intent more clearly than mutating one.",
        "Default to immutable and add `mutable` only where a value genuinely changes; the keyword then "
        "documents exactly what is expected to move. Fewer mutable bindings, fewer surprises." }},

    {Code::UseAfterMove, {
        "LDP3-0402", "used after it was moved",
        "A `move` transfers ownership: the source is emptied so there is exactly one owner and no double "
        "free. Reading the moved-from value afterwards would read something that no longer owns its data.",
        "Use the destination of the move instead, or reassign the moved-from variable before using it "
        "again. If you meant to keep both, take a reference (`&`) or a deep copy rather than moving.",
        "Move only at the point ownership really transfers, and let the moved-from name go out of scope "
        "soon after. Prefer references for sharing and copies for independent values." }},

    {Code::MoveMisuse, {
        "LDP3-0403", "this cannot be moved",
        "Ownership can only be transferred from something that owns a whole value. Moving out of a field of "
        "a live object, or moving an immutable binding, would leave a half-owned or unchangeable value.",
        "Move a whole owning variable, not a field of one still in use (make the field `partitionable` if "
        "field-wise moves are intended), and move only `mutable` bindings. Copy or reference instead.",
        "Keep ownership at the granularity you move at: own a value in one variable and move that. "
        "`unique`/`movable` on a type document exactly how its instances may travel." }},

    {Code::InvalidAssignTarget, {
        "LDP3-0404", "cannot assign to this",
        "The left of `=` (or the target of `++`/`--`) must be an assignable place: a variable, a field, or "
        "an array element. This target is a value or expression, which has nowhere to store into.",
        "Assign to a variable, `this.field`, or `array[i]`. If you meant to compare, use `==`; assignment "
        "is not an expression in LDP3, so `if (x = 5)` is always a mistake.",
        "Assignment being a statement, not an expression, means a stray `=` in a condition is caught for "
        "you. Increment only real lvalues; compute new values into a named local otherwise." }},

    {Code::MissingReturn, {
        "LDP3-0501", "not all paths return a value",
        "A method that declares a non-void return type must return a value on every path that reaches its "
        "end. A path that falls off the end would leave the caller with no value.",
        "Add a `return <value>;` on the path that falls through -- often the final `else` or the code "
        "after a loop -- or restructure so every branch returns.",
        "Return early and often rather than threading one result to the bottom; each branch then obviously "
        "returns. A final unconditional `return` makes the fall-through impossible." }},

    {Code::MatchNotExhaustive, {
        "LDP3-0502", "match does not cover every case",
        "A `match`/`switch` must handle every possible value: a `sealed` type must cover all its permitted "
        "cases, and any other subject needs a `default`. An uncovered value would have no arm to run.",
        "Add the missing case, or a `default` arm. For a `sealed` type, cover each type in its `permits` "
        "list -- the compiler then checks completeness for you when the list grows.",
        "Prefer `sealed` types for closed sets of cases: the compiler makes a match over them exhaustive, "
        "so adding a new case turns every unhandled match into a compile error, not a silent gap." }},

    {Code::Redeclaration, {
        "LDP3-0601", "already declared",
        "A name can be declared once in a given scope. A second declaration -- of a type, a variable, or a "
        "name that shadows an enclosing one -- is ambiguous: later uses cannot tell which you mean.",
        "Rename one of them, or remove the duplicate if they were meant to be the same thing. Shadowing an "
        "outer variable is rejected on purpose; pick a distinct name for the inner one.",
        "Distinct, descriptive names avoid collisions. The structure panel and workspace symbols (Ctrl+T) "
        "show what names already exist before you add another." }},

    {Code::DuplicateField, {
        "LDP3-0602", "duplicate field",
        "Each field in a class must have a unique name; two fields with the same name would give one "
        "storage slot two meanings. This name is declared more than once in the class.",
        "Rename one field, or remove the duplicate if it was pasted by mistake. If a subclass field is "
        "meant to be separate from a superclass one, give it a distinct name.",
        "Keep a class small enough to see its fields at once; the structure panel lists them. One concern "
        "per class keeps the field set short and collision-free." }},

    {Code::DuplicateMember, {
        "LDP3-0603", "duplicate member",
        "The members of a set must be distinct: an enum's constants, a catalog's values, and a call's named "
        "arguments each name a thing once. A repeat makes two entries indistinguishable.",
        "Remove or rename the duplicate. For a named argument passed twice, pass it once; for an enum or "
        "catalog, each constant/value appears a single time.",
        "List members in a deliberate order and scan for repeats, or let the structure panel show them. "
        "Short, meaningful names make an accidental duplicate stand out." }},

    {Code::InheritanceCycle, {
        "LDP3-0604", "inheritance cycle",
        "A class cannot (even transitively) extend itself, and a catalog cannot extend itself: the "
        "hierarchy has to bottom out, or laying out and initializing an instance would never terminate.",
        "Break the cycle -- one of the `extends`/`implements` links is wrong. Point the type at a real "
        "base, or introduce a shared base both were trying to be.",
        "Sketch the hierarchy as a tree before writing it; a tree has no cycles by construction. Prefer "
        "shallow hierarchies and interfaces over deep chains that are easy to tangle." }},

    {Code::LiteralSuffix, {
        "LDP3-0701", "bad literal suffix",
        "A literal's suffix picks its type (e.g. `10i8`, `3.0f`, `5m`) or its unit (a comptime size). This "
        "suffix is not one the compiler knows, or does not fit the literal it is on.",
        "Use a defined suffix for the type you want, or drop the suffix and let the literal take its "
        "default type. Check the spec's literal table for the exact spellings.",
        "Reach for a suffix only when the default type is not what you need; a plain literal is clearest. "
        "The stdlib browser (F1) documents the numeric types and their suffixes." }},

    {Code::StringInterp, {
        "LDP3-0702", "cannot interpolate this value",
        "String interpolation `$\"... {x} ...\"` prints simple values -- numbers, char, boolean -- by "
        "lowering each hole to a printf conversion. A value with no such conversion cannot be interpolated.",
        "Interpolate a numeric/char/boolean value, or convert the value to one first (e.g. call a method "
        "that returns an int). The real String type and its formatting arrive with the stdlib (F10).",
        "Keep interpolation for scalars and build richer text through methods that return printable values. "
        "Forge's hover shows a hole's type, so an unprintable one is visible before you build." }},

    {Code::PrintfFormat, {
        "LDP3-0703", "printf needs a literal format string",
        "The format argument of System.IO printf/println/print must be a string literal (or an "
        "interpolation), so the compiler can check and lower it at compile time -- there is no runtime "
        "String type yet to hold a computed format.",
        "Pass a literal format string, or an interpolation `$\"...\"`. Move any computed text into the "
        "arguments after the format, not into the format itself.",
        "Write the format inline as a literal and let the values follow it. This also keeps the conversions "
        "(`%d`, `%c`) next to the values they format, where a mismatch is easy to spot." }},

    {Code::OperatorOverload, {
        "LDP3-0801", "malformed operator overload",
        "An `operator` declaration defines what a symbol means for a type; it has a fixed shape -- the "
        "operator, its operands, and a return type. This declaration does not match that shape.",
        "Declare the operator as the spec shows (`operator + (Other rhs) returns T { ... }`), with the "
        "right number of operands for the symbol. Return the operator's result type.",
        "Overload an operator only where it reads as naturally as the built-in one (arithmetic on a vector, "
        "say). A named method is clearer than an operator whose meaning is not obvious." }},

    {Code::ReflectionMisuse, {
        "LDP3-0802", "reflection used incorrectly",
        "Reflection (`reflect.typeOf<T>`, field/annotation access) needs `import reflect;` and a correct "
        "shape -- one type argument, a reflectable subject. This use is missing the import or malformed.",
        "Add `import reflect;`, and call the reflection API as documented (e.g. `reflect.typeOf<T>()` with "
        "exactly one type argument). Reflection is unavailable in freestanding mode.",
        "Reach for reflection sparingly -- direct method calls are faster and clearer. When you do use it, "
        "keep the reflective code in one place so its import and shape are easy to keep correct." }},

    {Code::RegionMisuse, {
        "LDP3-0803", "region used incorrectly",
        "A region (spec 17) is a typed arena: its declaration, its address/range, and `new ... in region` "
        "have fixed shapes and type rules. This use breaks one of them -- a bad address, range, or type.",
        "Give the region a numeric or address bound where one is required, allocate types the region "
        "`accepts`, and spell `new T in region` as the spec shows. Check the region is in scope here.",
        "Decide what a region holds and where it lives when you declare it; `accepts`/`rejects` then make "
        "the compiler enforce it. Keep allocation and release of a region visibly paired." }},

    {Code::RegionTwoFlavors, {
        "LDP3-1710", "a region has exactly one flavor",
        "A region's flavor is its reclaim strategy -- bump, pool, stack, fixedslot or ring (spec 17) -- and "
        "a region has exactly one. Two flavor words on one declaration (like `pool stack region`) name two "
        "contradictory strategies, so the compiler cannot pick how the region reclaims memory.",
        "Keep a single flavor word before `region`. Choose pool for free-list reuse of mixed sizes, "
        "fixedslot for one repeated type, stack for mark/rollback, ring for a bounded auto-evicting buffer, "
        "or plain `region` (bump) to free everything at once on release.",
        "Decide the reclaim discipline once, when you declare the region, from how its objects die: all "
        "together (bump), individually (pool/fixedslot), newest-first (stack), or oldest-out (ring)." }},

    {Code::RegionFlavorOnNonRegion, {
        "LDP3-1719", "a flavor modifier only qualifies a region",
        "Words like `pool`, `stack`, `fixedslot`, `ring` and `growable` are region flavor/growth modifiers "
        "(spec 17): they only make sense in front of the `region` keyword, where they choose how the arena "
        "reclaims memory. Here one qualifies an ordinary declaration, which has no arena to reclaim.",
        "Drop the modifier from this declaration. If you meant to declare an arena, write it as "
        "`<flavor> region name = itself.allocate(...);`.",
        "Reserve the flavor words for region declarations; everywhere else they are ordinary identifiers." }},

    {Code::RegionUseAfterExtract, {
        "LDP3-1717", "use of a variable after it was extracted from its region",
        "`extract X from region R` relocates the object out of the region and transfers ownership to the "
        "result. Like `move`, it leaves the source variable empty: the region no longer owns that object, "
        "so reading the old handle would alias memory the region may already have reused.",
        "Use the value returned by `extract` from here on. If you still need the original handle, do not "
        "extract -- read it in place, or `extract` into the same variable (`x = extract x from region R;`).",
        "Treat `extract` like `move`: the name you extract from is spent afterwards. Bind the result to the "
        "variable you will keep using." }},

    {Code::RegionExtractInnerField, {
        "LDP3-1718", "cannot extract an object whose field lives in the same region",
        "`extract`/`delete from region` relocates or frees one object's own storage. This object owns a "
        "field allocated in the SAME region, so moving just the object would leave that field behind in the "
        "region -- a dangling pointer after the region is released, or a leak (spec 17).",
        "Extract the whole graph with `cascade move X from region A to region B`, or allocate the inner "
        "field outside this region (on the heap, or in a longer-lived region) so the object can leave alone.",
        "Keep an object and the sub-objects it owns in the same lifetime: either all in the region (freed "
        "together on release) or all relocatable together." }},

    {Code::RegionExtractNotBound, {
        "LDP3-1720", "an `extract` result must be bound",
        "`extract X from region R` transfers ownership of the relocated object to its result -- the caller "
        "must then delete it or hand it to something that will. A bare `extract ...;` statement drops that "
        "owner on the floor, leaking the object it just relocated to the heap (spec 17).",
        "Bind the result: `T* out = extract X from region R;` (or assign it to a field), then `delete out;` "
        "when done. If you only want to destroy X, use `delete X from region R;` instead.",
        "Read `extract` as producing a value you own now -- always on the right-hand side of a binding, "
        "never as a statement on its own." }},

    {Code::RegionMarkNonStack, {
        "LDP3-1713", "mark/rollback need a stack region",
        "`mark of region R` and `rollback region R to m` are the LIFO checkpoint operations of a `stack "
        "region` (spec 17): they record and rewind a single allocation cursor. A bump/pool/fixedslot/ring "
        "region has no LIFO cursor to mark, so these operations do not apply to it.",
        "Declare the region `stack` (`stack region R = itself.allocate(...)`). To reclaim individual "
        "objects from a pool region instead, use `delete X from region R` or `extract`.",
        "Choose the flavor from how the region reclaims: stack for nested/per-frame checkpoints (mark/"
        "rollback), pool for free-list reuse of individual objects." }},

    {Code::RegionCheckpointWrongRegion, {
        "LDP3-1714", "this checkpoint belongs to another region",
        "A `checkpoint` records a cursor position in the specific `stack region` it was marked from. Rolling "
        "a different region back to it would rewind that region to an offset that means nothing there -- "
        "reviving or dropping the wrong objects (spec 17).",
        "Roll back the region the checkpoint came from: `rollback region <that region> to m;`. Keep one "
        "checkpoint variable per region so it is obvious which pairs with which.",
        "Name checkpoints after their region, and mark/rollback the same region in a matched pair." }},

    {Code::RegionFixedslotAcceptsRequired, {
        "LDP3-1711", "a fixedslot/ring region needs its single element type",
        "A `fixedslot` region is a single-size pool and a `ring` region is a fixed-purpose circular buffer "
        "(spec 17): both hold exactly one element type, which sets the slot size. Without it the compiler "
        "cannot size the slots or know what to allocate.",
        "Constrain the region to one type: `fixedslot region R = itself.allocate(N).accepts({Particle});`. "
        "For a heterogeneous churn use a plain `pool region` instead (no accepts required).",
        "Pick fixedslot/ring when the region holds many of ONE type; name that type in `.accepts({T})`." }},

    {Code::RegionRingNoDelete, {
        "LDP3-1715", "a ring region auto-evicts; individual delete is not allowed",
        "A `ring` region is a bounded circular buffer: a new allocation past its capacity overwrites the "
        "oldest entry (running its destructor first). Deleting an individual entry would leave a hole in "
        "the ring and break that oldest-out discipline (spec 17).",
        "Let the ring evict on its own -- just keep allocating; the oldest entries fall off. To drop "
        "everything, `release region R` (or `.clear()`). Use a `pool region` if you need individual delete.",
        "Reach for a ring only for bounded history/streaming where losing the oldest is the intent." }},

    {Code::RegionGrowableContradiction, {
        "LDP3-1712", "growable does not apply here",
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
        "LDP3-0804", "vector/matrix operation is malformed",
        "The SIMD vector and matrix types have fixed shapes: a vecN has N numeric lanes, a mat4 has 16 "
        "numeric components and its own operations. This use has the wrong shape, component, or lane type.",
        "Give a vec/mat the right number of numeric components, index a lane that exists (x/y/z/w), and use "
        "the type's own operations (e.g. mat4 multiply/transform). Lane values are numeric.",
        "Construct vectors and matrices with exactly their component count, and name them by dimension. The "
        "stdlib browser (F1) documents each vector/matrix type and its operations." }},

    {Code::UnimportMisuse, {
        "LDP3-0805", "unimport/reimport used incorrectly",
        "unimport/reimport (spec 32) swap a program's code at runtime under strict rules: what you unimport "
        "must be importable back, and the reimport must match. This use violates one of those rules.",
        "unimport a name that can be reimported, and make the reimport's `expecting` signature match the "
        "unimport. Check the target exists and is the kind unimport can replace.",
        "Keep the unimport/reimport pair close and their `expecting` contracts identical. Treat runtime "
        "code-swapping as a deliberate, well-tested seam, not a casual edit." }},

    {Code::StaticAssert, {
        "LDP3-0806", "static assertion",
        "`static_assert` checks a condition at compile time; the condition must be a constant expression, "
        "and it must hold. Either it did not evaluate to a constant, or it evaluated to false.",
        "Make the condition a compile-time constant (built from literals and comptime values), and ensure "
        "it is true for the cases you compile. The message after the comma explains the intended invariant.",
        "State the invariant the assert protects in its message, so a failure reads as a requirement, not a "
        "puzzle. Assert facts the compiler can check, and the check costs nothing at runtime." }},

    {Code::TryContext, {
        "LDP3-0503", "`try?` needs a Result/Option method",
        "`try?` unwraps a Result/Option and, on the error case, returns that error from the current method. "
        "That only type-checks where the method itself returns a Result/Option to carry the error out.",
        "Use `try?` only inside a method whose return type is Result or Option. Otherwise handle the value "
        "with `match`, or change the method to return a Result/Option so the error has somewhere to go.",
        "Decide a method's error strategy from its signature: return Result/Option and `try?` composes "
        "cleanly through it. Mixing `try?` into a plain method is the mismatch this catches." }},

    {Code::TryErrorType, {
        "LDP3-0504", "`try?` propagates a failure this method cannot carry",
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
        "LDP3-0605", "cannot extend this type",
        "A `final` class forbids any subclass, and a `sealed` type's variants are closed -- only its "
        "declared `permits` list may extend it. Extending outside those rules would break a guarantee the "
        "author made about the type's shape.",
        "Do not extend a `final` class -- compose with it instead (hold one as a field). To be a variant of "
        "a sealed type, be listed in its `permits`; otherwise model your type another way.",
        "`final` and `sealed` are deliberate: they say a hierarchy is closed so code can reason about all "
        "its cases. Prefer composition over extending types that were sealed shut on purpose." }},

    {Code::IllegalOverride, {
        "LDP3-0606", "cannot override a final method",
        "A `final` method cannot be overridden: the base class declared that its behaviour is fixed, so "
        "subclasses rely on it. An override would silently change what callers of the base expect.",
        "Remove the override, or -- if the base method is meant to be customizable -- remove `final` from "
        "it in the base class. Give the subclass method a different name if it does a different thing.",
        "Mark a method `final` only when subclasses must not change it, and override only methods left open. "
        "The keyword documents the contract; respecting it keeps subclasses substitutable." }},

    {Code::ConstraintNotMet, {
        "LDP3-0307b", "type argument does not satisfy the bound",
        "A generic parameter can carry a bound (`T extends Comparable<T>`), and every type argument must "
        "meet it, so the generic body can rely on the bounded capability. This argument does not.",
        "Pass a type that satisfies the bound (implements the required interface / extends the required "
        "base), or relax the generic's bound if the capability is not actually needed.",
        "Read a generic's bounds as the promises its body depends on. Make a type satisfy them (implement "
        "the interface) before using it as the argument; the error names exactly which promise is missing." }},

    {Code::ContradictoryModifiers, {
        "LDP3-0607", "these modifiers contradict each other",
        "Some modifiers make opposite promises and cannot combine -- e.g. `unique` guarantees a single live "
        "reference while `partitionable` hands out field-wise pieces. Together they would promise both.",
        "Keep the one modifier that matches your intent and drop the other. Decide whether the type is "
        "singly-owned (`unique`) or splittable (`partitionable`), not both.",
        "Choose an ownership discipline per type up front. Each modifier documents one promise; combining "
        "conflicting ones is the contradiction this catches before it can confuse callers." }},

    {Code::ComptimeConstant, {
        "LDP3-0807", "this must be a compile-time constant",
        "Some positions are evaluated by the compiler, not at run time -- a `comptime` argument, a `fixed` "
        "field initializer, an array size. They require a constant expression built from literals and other "
        "compile-time values.",
        "Supply a constant expression: a literal, a `fixed`/`comptime` value, or an operation on those. "
        "Move any run-time computation elsewhere; only compile-time-known values belong here.",
        "Keep compile-time inputs (sizes, config constants) as `fixed`/`comptime` values so they compose "
        "into other constant positions. A run-time value in a constant slot is the mismatch this flags." }},

    {Code::PersistentLifecycle, {
        "LDP3-0808", "a persistent is never released",
        "A `persistent` outlives normal scope and must be explicitly torn down: the program needs a "
        "`release persistent` for it somewhere, or the resource it holds lives forever.",
        "Add a `release persistent <name>;` on the path that ends its life. Pair every persistent's "
        "creation with a release, the way `new` pairs with `delete`.",
        "Treat a persistent like any owned resource: decide where it is released when you declare it. "
        "Keeping the create/release pair in view prevents the leak this catches." }},

    {Code::NotSupportedYet, {
        "LDP3-0A01", "not implemented yet",
        "This construct is valid LDP3 but the current compiler does not implement it yet. It is a gap in "
        "the toolchain, not a mistake in your code.",
        "Rework the code to avoid the unimplemented corner for now (the message says which one), or track "
        "the feature and revisit when the compiler grows it. Nearby language features usually cover the case.",
        "When you hit a not-yet-implemented corner, isolate it behind a small method so swapping in the real "
        "feature later is a one-line change. Report it so it gets prioritized." }},

    {Code::FreestandingRestriction, {
        "LDP3-0901", "not available in freestanding mode",
        "Freestanding mode (spec 36) targets bare metal with no runtime: features that need one -- "
        "async/await, exceptions, unimport, reflection, the Console -- are unavailable there by design.",
        "Remove the feature from freestanding code, or drop `freestanding` if this program actually runs on "
        "a host. Use the freestanding-safe equivalents: Result/Option for errors, raw Memory for I/O.",
        "Decide up front whether a program is freestanding; keep host-only features out of the modules it "
        "compiles. The restriction is the compiler guaranteeing your kernel pulls in no runtime." }},
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

    {"static assertion", Code::StaticAssert},
    {"static_assert", Code::StaticAssert},
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

Code classify(std::string_view message) {
    for (const Rule& r : kRules)
        if (message.find(r.needle) != std::string_view::npos) return r.code;
    return Code::None;
}

namespace {
bool g_conciseMode = false;
}
void setConcise(bool concise) { g_conciseMode = concise; }
bool conciseMode() { return g_conciseMode; }

}  // namespace ldp3::diag
