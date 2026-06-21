#pragma once

#include <string>
#include <unordered_map>

#include "parser/ast.h"

// Shared compile-time evaluator (spec 28). It folds constant integer/boolean/char
// expressions, resolving named consts and calls to `comptime` methods (recursively,
// with a step budget). Both the analyzer and the codegen drive it, so the language's
// notion of "what is a compile-time constant" lives in exactly one place.
namespace ldp3::comptime {

struct Context {
    // Named namespace-level consts (spec 28.1), by name -> value.
    const std::unordered_map<std::string, long long>* consts = nullptr;
    // `comptime` methods (spec 28.3) indexed by their (simple) name.
    const std::unordered_map<std::string, const ast::MethodDecl*>* methods = nullptr;
    long long steps = 0;                 // work done so far (bounds total loop/recursion work)
    long long stepLimit = 5'000'000;     // hard cap: past this, evaluation fails
    int depth = 0;                       // current comptime-call nesting (bounds native stack)
    int depthLimit = 256;                // hard cap on recursion depth (avoids stack overflow)
};

// Evaluates `e` to a compile-time integer. Returns false if it is not a constant
// (unknown name, unsupported construct, division by zero, or budget exhausted).
bool evalInt(const ast::Expr& e, long long& out, Context& ctx);

}  // namespace ldp3::comptime
