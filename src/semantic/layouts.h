// `layout` -- an interface for memory.
//
// An interface says what a type DOES. A layout says how a type ARRANGES ITSELF. Those are separate
// questions, so a layout is not a fourth species alongside struct/record/union -- it crosses them:
//
//     public layout Packed {
//         onArrange {
//             itself.fitWithin(20 bytes);
//         }
//     }
//     public struct Beast implements Packed { ... }
//
// It applies to value aggregates because only they have a layout that belongs to them at the point
// of use. Where a `Beast` is used, twenty bytes are there; where a class is used, a pointer is, and
// the vtable slot at the front of the instance is the compiler's, not the author's. That is why
// `implements` on a struct needed no grammar change: a struct cannot `extends` (it has no vtable to
// inherit through), but implementing was never inheriting.
//
// A layout is consumed entirely by the compiler. It establishes no contract in the requires/ensures
// sense: a contract survives into the binary and can fail while the program runs, whereas a layout
// that cannot be satisfied means there is no program. Nothing of it reaches the executable, and
// nothing inside `onArrange` names a library type -- so a layout holds in freestanding by
// construction rather than by a rule forbidding the library.
//
// Implementing one authorizes the compiler to ORDER THE FIELDS. That is the whole point: a check
// that merely refuses is a guard against a problem that could have been solved, and here it can be
// solved -- the compiler knows every size and alignment, and LDP3 exposes no offsets, so the order
// of fields is its to choose.
#pragma once

#include <string>

#include "parser/ast.h"

namespace ldp3 {

// What a layout asks of the type implementing it, read off its `onArrange` block.
struct Arrangement {
    long long maxBytes = -1;      // `itself.fitWithin(N bytes)`; -1 when the layout sets no ceiling
    std::string refuseMessage;    // the message `fitWithin` reports with, from `itself.refuse("...")`
};

// Splits `implements` into interfaces and layouts, and rejects the combinations that cannot mean
// anything (a class implementing a layout, a layout named as a type). Runs before the analyser, so
// that everything downstream keeps seeing an `interfaces` list holding only interfaces.
// Returns false when a diagnostic was reported.
bool resolveLayouts(ast::Program& program);

// Reads a layout's `onArrange` into the arrangement it describes. Reports and returns false on a
// statement the hook cannot contain. The block is READ, never executed: it runs at build time and
// there is no program yet to run it in.
bool readArrangement(const ast::ClassDecl& layout, Arrangement& out);

}  // namespace ldp3
