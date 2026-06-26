#pragma once

#include "parser/ast.h"

namespace ldp3 {

// AST-level loop optimization: interchange a reduction loop nest so the innermost loop becomes
// unit-stride, which the backend vectorizer can then vectorize (matmul-style). Turns
//
//   for (j) { T acc = INIT; for (k) acc = acc + EXPR; DEST = acc; }
//
// into the cache-friendly, vectorizable form
//
//   for (j) DEST = INIT;
//   for (k) for (j) DEST = DEST + EXPR;
//
// The accumulation order for each DEST is preserved exactly (k still runs 0..K in order), so the
// result is bit-identical -- no floating-point reassociation. Fires only when provably safe:
// distinct, single-assignment `new[]` buffers (no aliasing between DEST and the read arrays), the
// loop bounds do not cross-depend, and the inner access is strided in k but unit in j (so the
// interchange is a speedup). Otherwise a no-op. Run only at optimization levels >= 1.
void interchangeReductionLoops(ast::Program& program);

}  // namespace ldp3
