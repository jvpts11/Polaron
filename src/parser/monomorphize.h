#pragma once

#include "parser/ast.h"

namespace ldp3 {

// Monomorphizes generic classes: replaces each `class Box<T>` template with one
// concrete copy per instantiation used in the program (Box<int>, Box<double>,
// ...), named like "Box$int" (see ast::mangleGeneric). After this pass the
// program contains only concrete classes, so semantics and codegen stay
// generics-unaware. Uses (Box<int> b, new Box<int>(...)) resolve to the mangled
// names because typeRefStr / typeRefName mangle their type arguments.
void monomorphize(ast::Program& program);

}  // namespace ldp3
