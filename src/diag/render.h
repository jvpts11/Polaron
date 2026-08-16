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

// HOW TO SHOW A LOCATION, installed once by the driver.
//
// Only the driver has the compiled text of each file and the map from the concatenated standard
// library back to its subject files. Everything else that reports -- the monomorphizer, the
// transformer expander, the layout checker -- had neither, so their diagnostics printed with no
// source line under the caret and named `<prelude>`, a place nobody can open. They were the parts of
// the compiler whose messages were hardest to act on, for no reason except that they report from a
// different file.
//
// `display` turns a location's file into what the reader should see; `line` returns that file's
// numbered source line, or "" when it is unavailable.
struct SourceResolver {
    std::string (*display)(std::string_view file, int line) = nullptr;
    std::string (*line)(std::string_view file, int lineNo) = nullptr;
};
void setSourceResolver(SourceResolver r);

// COLOUR, off unless the driver turns it on. Errors red, warnings yellow, and the caret in the same
// colour as its severity so the eye finds the place before it reads the sentence. The driver decides:
// a terminal gets colour, a pipe or a file does not, because escape codes in a build log are noise
// that outlives the terminal that would have rendered them.
void setColor(bool on);
bool colorEnabled();

// `--noVerbose`: print the headline, the location and the caret, and stop. The default is the full
// write-up on every diagnostic -- an explanation is worth having every time it applies, and a reader
// who does not want it says so once on the command line rather than being rationed by the compiler.
void setVerbose(bool on);

// Render one diagnostic.
//
// `severity` is "error" or "warning". `sourceLine` is the offending source line (pass "" if unavailable --
// the snippet is then omitted). `concise` gives the one machine-parseable line
// `path:line:col: severity[CODE]: message` used by `--check` and CI; otherwise the full rich block with a
// snippet, a caret, and the why / fix / prevent sections from the catalog.
//
// The returned string ends with a newline and is ready to write to stderr.
std::string render(std::string_view severity, const std::string& path, int line, int col,
                   const std::string& message, Code code, const std::string& sourceLineIn,
                   bool concise);

}  // namespace polaron::diag
