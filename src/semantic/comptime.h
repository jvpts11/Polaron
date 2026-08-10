#pragma once

#include <functional>
#include <string>
#include <unordered_map>
#include <vector>

#include "parser/ast.h"

// Shared compile-time evaluator (spec 28). It folds constant numeric/boolean/char
// expressions, resolving named consts and calls to `comptime` methods (recursively,
// with a step budget). Values are int or double (tagged internally), so both
// `const int`/`static_assert` and `const double` with comptime calls go through the
// same logic. Both the analyzer and the codegen drive it, so the language's notion
// of "what is a compile-time constant" lives in exactly one place.
namespace ldp3::comptime {

struct Context {
    // Named namespace-level consts (spec 28.1), by name -> value.
    const std::unordered_map<std::string, long long>* consts = nullptr;   // int/bool/char consts
    const std::unordered_map<std::string, double>* dconsts = nullptr;     // float/double consts
    // `comptime` methods (spec 28.3) indexed by their (simple) name.
    const std::unordered_map<std::string, const ast::MethodDecl*>* methods = nullptr;
    long long steps = 0;                 // work done so far (bounds total loop/recursion work)
    long long stepLimit = 5'000'000;     // hard cap: past this, evaluation fails
    int depth = 0;                       // current comptime-call nesting (bounds native stack)
    int depthLimit = 64;                 // hard cap on recursion depth (avoids stack overflow); kept
                                         // well under the native stack so a runaway is reported, not
                                         // crashed (comptime recursion in practice is shallow)
    // Interned compile-time strings (spec 32.4 string DSLs). A string value is a small index into
    // this pool, so the value type stays register-small and deep comptime recursion does not enlarge
    // the native stack frame.
    std::vector<std::string> strings;
    // Resolves `sizeof(T)` / `T.sizeof()` (spec issue #7) to a byte count, so a size can take part in
    // a constant expression -- `static_assert(sizeof(Beast) <= 20, ...)` is the point.
    //
    // Only whoever knows the TARGET's layout may set this: the codegen, which holds the DataLayout.
    // A caller that would have to guess leaves it unset, and then an expression containing sizeof is
    // simply not constant. A size folded from a second, hand-rolled layout model would be a
    // confident lie the moment the two models drifted, and an assertion that lies is worse than one
    // that cannot run.
    std::function<bool(const std::string& typeName, long long& out)> sizeOfType;
    // Resolves `EnumName.count()` (spec 12.5) to how many constants the enum declares. An enum is a
    // closed set written out in the source, so its size is settled the moment the declaration is
    // parsed -- there is nothing about it a running program could know that the compiler does not.
    // That makes it fit to stand in a `demand`, which is the point: a table keyed by one enum and
    // offset by the size of another can say so at build time instead of renumbering itself in
    // silence when somebody adds a constant.
    //
    // Set by whichever stage holds the enum declarations. Left unset, a count is simply not
    // constant, exactly as an unset sizeOfType makes a size non-constant.
    std::function<bool(const std::string& enumName, long long& out)> enumCount;
};

// True when `e` mentions `sizeof` anywhere. Such a condition can only be folded where the target
// layout is known, so the analyzer defers it to the codegen instead of rejecting it (spec 28.2).
bool mentionsSizeof(const ast::Expr& e);

// The dotted type name an expression spells (`Beast`, `app.Beast`), or "" if it is not a plain name.
// `sizeof`'s argument names a type, so it is read rather than evaluated.
std::string typeNameSpelled(const ast::Expr& e);

// Evaluates `e` to a compile-time integer (the result must be int-valued; a
// double result fails). Returns false if it is not such a constant.
bool evalInt(const ast::Expr& e, long long& out, Context& ctx);

// Evaluates `e` to a compile-time double (integers promote). Returns false if it
// is not a compile-time numeric constant.
bool evalDouble(const ast::Expr& e, double& out, Context& ctx);

}  // namespace ldp3::comptime
