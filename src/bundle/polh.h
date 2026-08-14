#pragma once

#include <string>

#include "parser/ast.h"

namespace polaron {

// Generates the public-API header (.polh) for a program: every public type in a public namespace of a
// public bundle, with its public/protected members as signatures (no bodies). The text is the bundle
// boundary a consumer type-checks against, and the input the ABI fingerprint hashes. Deterministic in
// source order, so the same source yields the same header.
std::string generatePolh(const ast::Program& program);

}  // namespace polaron
