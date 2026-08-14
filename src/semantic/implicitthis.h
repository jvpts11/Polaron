// `this.` is required only where it says something.
//
// Writing `this.` in front of every member of the enclosing class carries no information: inside a
// method there is exactly one object the name could belong to, so the reader learns nothing from the
// prefix that the declaration did not already tell them. That is boilerplate rather than verbosity --
// verbosity spends words to say something, boilerplate spends them to say nothing -- and the cost is
// paid on every line of every method in the language.
//
// So a bare name now finds a field, and a bare call now finds a method, of the class the code is
// written inside. `this.` keeps working everywhere and becomes REQUIRED in exactly the case where it
// distinguishes two things: a local or parameter of the same name as a field. There the local wins,
// as it does in every language with the rule, and `this.name` is how the field is reached.
//
// Implemented as a rewrite of the tree rather than a second lookup path in the analyser. Every name
// that resolves to a member is turned into the member access it stands for, before anything looks at
// the program -- so type checking, ownership, flow analysis, codegen and reflection go on seeing what
// they see today, and there is no possibility of two resolution rules drifting apart. The same shape
// `expandDelegates` uses, and for the same reason.
#pragma once

#include "parser/ast.h"

namespace polaron {

// Rewrites bare member references into `this.x` / `Class.x`, in place. Returns false if anything went
// wrong; today nothing can, and the return exists so a future ambiguity has somewhere to be reported.
bool resolveImplicitThis(ast::Program& program);

}  // namespace polaron
