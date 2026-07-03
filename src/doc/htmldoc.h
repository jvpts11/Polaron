#pragma once
#include <string>
#include <vector>
#include "lexer/lexer.h"
#include "parser/ast.h"

namespace ldp3::doc {

// Render a single self-contained HTML page documenting the program's public API (public classes and their
// public members) from the `///` doc comments collected by the lexer.
std::string generateHtml(const ast::Program& program, const std::vector<DocComment>& docs);

}  // namespace ldp3::doc
