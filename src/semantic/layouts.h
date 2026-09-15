// `layout` -- an interface for memory.
//
// An interface says what a type DOES. A layout says how a type ARRANGES ITSELF. Those are separate
// questions, so a layout is not a fourth species alongside struct/record/union -- it crosses them:
//
//     public layout Packed permits reorder {
//         onArrange {
//             itself.fitWithin(20 bytes);
//         }
//     }
//     public struct Beast arranges Packed { ... }
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
// THE LAYOUT CONSTRAINS, THE LAYOUT CONCEDES, THE TARGET RESOLVES. Three roles, and the first
// design had only the first of them -- which is why every attempt to add a verb to it came out
// crooked, and why one of its two behaviours was wrong.
//
// A `permits reorder` AUTHORIZES THE COMPILER TO ORDER THE FIELDS, and where it is written that is
// the whole point: a check that merely refuses is a guard against a problem that could have been
// solved, and here it can be solved -- the compiler knows every size and alignment, and Polaron
// exposes no offsets, so the order of fields is its to choose.
//
// WITHOUT IT, NOTHING IS PERMUTED, and the default is that way round because of what the word
// `layout` is mostly reached for. The repository's own sample is called `WireRecord` and says *"a
// wire record is 32 bytes; both ends index it"* -- and under the first design, naming a layout at
// all was what granted the reordering. Two declarations of that record with the fields written in
// different orders both measured 32, both compiled, and disagreed on every offset, with nothing
// said. A concession that is granted by asking for a size ceiling is not a concession.
//
// "Keep the declared order" then stops being a badly-shaped constraint nobody could express: it is
// the ABSENCE of a concession, which is what it always was.
#pragma once

#include <string>

#include "parser/ast.h"

namespace polaron {

// What a layout asks of the type it arranges, read off its `onArrange` block -- and what it grants
// in return, read off the `permits` list on its own declaration.
struct Arrangement {
    long long maxBytes = -1;      // `itself.fitWithin(N bytes)`; -1 when the layout sets no ceiling
    std::string refuseMessage;    // the message `fitWithin` reports with, from `itself.refuse("...")`
    bool permitsReorder = false;  // `permits reorder` -- the arrangement may permute the fields
    bool permitsPadding = false;  // `permits padding` -- bytes beyond what alignment required
    // `itself.resolvedBy(arrange)` -- WHICH MEMBER DECIDES THE ARRANGEMENT.
    //
    // Written even though the member is declared, and an interface does not restate which of its
    // methods must be implemented. The reason only appears once a layout may carry more than one
    // member: without the line, EVERY method on a layout is ambiguous between a helper and the
    // resolver. This picks one, and puts the whole arrangement policy in the block a reader is
    // already looking at.
    std::string resolvedBy;
};

// ONE STEP OF A RESOLVER, read off its body. The order of these IS the order of the fields: the
// design's rule is *the order the calls are made in is the final order*, so this is a list and not
// a set, and nothing sorts it afterwards.
struct Placement {
    enum class Verb { Place, Isolate, Align, Pad };
    Verb verb = Verb::Place;
    std::string field;        // Place/Isolate/Align: which field. Empty for Pad.
    long long bytes = 0;      // Align: the boundary. Pad: the size of the hole.
    SourceLocation loc;       // the call's own line, so a refusal points at the verb that overreached
};

// Reads a resolver's body into the placements it describes. Like `readArrangement`, the block is
// READ and never executed: it decides where bytes go while the program is being built, and there is
// no program yet to run it in. Reports and returns false on a statement the body cannot contain.
bool readResolver(const ast::MethodDecl& resolver, std::vector<Placement>& out);

// The resolver a type's layout names, or nullptr. Prefers the TARGET's own -- which is the whole
// point, since the target is what knows its field names -- and falls back to a bodied default on the
// layout itself. An `abstract` one on the layout is an obligation and is not a default.
const ast::MethodDecl* findResolver(const ast::ClassDecl& target, const ast::ClassDecl& layout,
                                    const std::string& memberName);

// Validates the `arranges` clause, splits any layout still named in `implements` out of it, and
// rejects the combinations that cannot mean anything (a class arranged by a layout, a layout named
// as a type). Runs before the analyser, so that everything downstream keeps seeing an `interfaces`
// list holding only interfaces. Returns false when an error was reported.
bool resolveLayouts(ast::Program& program);

// Reads a layout's `onArrange` into the arrangement it describes. Reports and returns false on a
// statement the hook cannot contain. The block is READ, never executed: it runs at build time and
// there is no program yet to run it in.
bool readArrangement(const ast::ClassDecl& layout, Arrangement& out);

}  // namespace polaron
