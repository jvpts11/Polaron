#pragma once

#include "parser/ast.h"

namespace ldp3 {

// Expands every `applies` clause: the transformer's members are copied into the type that applies
// it, with `itself` substituted for that type's name.
//
// A transformer is resolved ENTIRELY here, at compile time, and nothing of it survives under its own
// name -- the same treatment `layout` gets. That is what makes it usable in a kernel without
// thinking twice: no vtable, no allocation, no indirection. What you pay is exactly the code you
// would have written by hand.
//
// Runs before `qualifyNamespaces`, so names are still simple and a transformer is matched by the
// name the author wrote. Returns false if anything was reported.
bool expandTransformers(ast::Program& program);

}  // namespace ldp3
