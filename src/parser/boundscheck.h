#pragma once

#include "parser/ast.h"

namespace polaron {

// Bounds-check hoisting by loop versioning (a "no-UB, zero-overhead-when-valid" optimization).
//
// A `for` loop that indexes an array by its induction variable pays a per-iteration bounds check that
// LLVM cannot always remove -- when the loop bound is a parameter or local rather than the array's own
// length, the compiler has no way to see the index stays in range. This pass proves the induction
// variable's range from the loop header, then rewrites
//
//     for (i = lo; i <= hi; i++) { ... a[i] ... }
//
// into
//
//     if (lo >= 0 && hi < a.length() && ...) { <fast copy: a[i] unchecked> }
//     else                                    { <original copy: a[i] checked> }
//
// The fast copy runs with the per-access checks removed; the guard, evaluated once, is built from
// exactly the accesses that were made unchecked. A valid program takes the fast path with no checks; an
// out-of-range one takes the original checked path and traps at the exact access, so the no-UB guarantee
// is preserved unchanged. This is the classic JVM loop-versioning transform.
//
// Deliberately conservative for soundness: only clean integer `for` loops with a monotonically
// increasing induction variable, only bare `array[i]` accesses, only loop-invariant arrays, and only
// when the loop body makes no calls or allocations (which could reallocate or free the array). Anything
// unproven is simply left checked. Runs after monomorphize, before the analyzer (which type-checks the
// generated guard and both loop copies).
void hoistBoundsChecks(ast::Program& program);

}  // namespace polaron
