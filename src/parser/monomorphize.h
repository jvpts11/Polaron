#pragma once

#include "parser/ast.h"

namespace ldp3 {

// Monomorphizes generic classes: replaces each `class Box<T>` template with one
// concrete copy per instantiation used in the program (Box<int>, Box<double>,
// ...), named like "Box$int" (see ast::mangleGeneric). After this pass the
// program contains only concrete classes, so semantics and codegen stay
// generics-unaware. Uses (Box<int> b, new Box<int>(...)) resolve to the mangled
// names because typeRefStr / typeRefName mangle their type arguments.
// Returns false (after reporting to stderr) if a generic instantiation violates a
// type-parameter constraint (spec 15.2); true otherwise.
bool monomorphize(ast::Program& program);

// Rewrites type names that collide across namespaces (app.Foo vs lib.Foo) to
// unique internal names, so namespaces actually scope type names. A no-op when no
// simple type name is declared in more than one namespace. Run before monomorphize.
void qualifyNamespaces(ast::Program& program);

// Expands every `typealias` to its target type everywhere (transparent, spec 24), so the rest of
// the pipeline only sees concrete types. `newtype`s are left for the analyzer. A no-op when the
// program declares no type aliases. Run first, before qualifyNamespaces and monomorphize.
void resolveTypeAliases(ast::Program& program);

}  // namespace ldp3
