#pragma once

#include <string>

#include "pir/module.h"

// Stage 4: the analyses, moved down from the AST onto the graph.
//
// See docs/design/polaron-ir.md §11. This is where the win is collected -- these are the analyses
// that are awkward on a tree and natural on a graph, and the first of them is the one the whole
// project rests on:
//
//   GUARD ELIMINATION. Today a bounds check is an open-coded branch, so LICM will not hoist it and
//   the vectoriser will not touch the loop. As `guard.bounds`, a check dominated by a stronger one,
//   or by a `requires`, or by an `invariant`, is a node the pass deletes -- and `--no-bounds-check`
//   becomes a pass that removes a node rather than a flag threaded through an emitter.
//
// Each pass reports what it did. A pass that silently does nothing looks exactly like a pass that
// works, which is how an optimisation quietly stops happening.
namespace polaron::pir {

struct PassReport {
    int factsPropagated = 0;
    int guardsRemoved = 0;
    // Counted apart from `factsPropagated` because it answers a different question: how often a
    // contract the programmer WROTE stood in for a check the compiler would otherwise have emitted.
    // Zero here, in a program with contracts, means the two are not meeting -- which is what it
    // read for as long as `requires` lowered to a marker with no condition attached to it.
    int contractFacts = 0;
    int slotsMadeImmutable = 0;
    int deadRemoved = 0;
    int allocationsHoisted = 0;
    // §11.8: dispatches that turned out to have one possible answer, so the call names it. Counted
    // apart from everything else because it is the row of the §12 hand-off scoreboard that read
    // `devirt=0` while the compiler was busy printing diagnostics that ENUMERATED the closed set --
    // it knew the answer and emitted a table lookup anyway.
    int devirtualised = 0;
    // §11.5: allocations that provably do not outlive the frame, so the frame is where they went.
    // Each one is a `__polaron_malloc` and a `__polaron_free` that stop existing, plus the header
    // and the pointer chase behind them.
    int heapToStack = 0;

    bool didSomething() const {
        return factsPropagated + guardsRemoved + slotsMadeImmutable + deadRemoved +
                   allocationsHoisted + devirtualised + heapToStack >
               0;
    }
};

// Runs the §11 pipeline, in dependency order, over every function in the module.
PassReport runPasses(Module* module);

std::string renderPassReport(const PassReport& r);

}  // namespace polaron::pir
