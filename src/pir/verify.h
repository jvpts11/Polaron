#pragma once

#include <string>
#include <vector>

#include "pir/module.h"

// `pir::verify` -- the floor everything else stands on.
//
// See docs/design/polaron-ir.md §9. The rule list there is NORMATIVE and this file implements exactly
// it: a rule not in that list is not checked here, and a check here that is not in that list does not
// belong. That correspondence is the point -- the alternative is a verifier whose real contract is
// whatever its code happens to do, which nobody can read and everybody has to guess at.
//
// A failure names the rule number, so a message can be looked up rather than reverse-engineered.
namespace polaron::pir {

struct VerifyError {
    int rule = 0;             // §9's numbering
    std::string what;
    std::string where;        // "@key" or "@key ^block" or "@key ^block #3"
    SourceLocation loc;
};

// Every rule that fails, not just the first: a lowering bug usually breaks several at once, and a
// verifier that stops at the first turns one debugging session into five.
std::vector<VerifyError> verify(const Module& module);

// Convenience for tests and for the driver: the errors rendered one per line.
std::string renderVerifyErrors(const std::vector<VerifyError>& errors);

}  // namespace polaron::pir
