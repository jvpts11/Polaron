#pragma once

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
};

// Evaluates `e` to a compile-time integer (the result must be int-valued; a
// double result fails). Returns false if it is not such a constant.
bool evalInt(const ast::Expr& e, long long& out, Context& ctx);

// Evaluates `e` to a compile-time double (integers promote). Returns false if it
// is not a compile-time numeric constant.
bool evalDouble(const ast::Expr& e, double& out, Context& ctx);

}  // namespace ldp3::comptime
