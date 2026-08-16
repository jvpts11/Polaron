#pragma once

#include <set>
#include <string>
#include <string_view>

#include "diag/diagnostic.h"

namespace polaron::diag {

// Codes whose why/fix/prevent has already been printed in this run. The write-up appears once; later
// diagnostics with the same code keep their headline and caret and point at it. Exposed so a test can
// clear it between renders.
std::set<std::string>& explainedCodes();

// Render one diagnostic.
//
// `severity` is "error" or "warning". `sourceLine` is the offending source line (pass "" if unavailable --
// the snippet is then omitted). `concise` gives the one machine-parseable line
// `path:line:col: severity[CODE]: message` used by `--check` and CI; otherwise the full rich block with a
// snippet, a caret, and the why / fix / prevent sections from the catalog.
//
// The returned string ends with a newline and is ready to write to stderr.
std::string render(std::string_view severity, const std::string& path, int line, int col,
                   const std::string& message, Code code, const std::string& sourceLine, bool concise);

}  // namespace polaron::diag
