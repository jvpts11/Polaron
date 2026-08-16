#include "diag/render.h"

#include <algorithm>
#include <cctype>
#include <set>
#include <string>

namespace polaron::diag {

namespace {
bool isIdentChar(char c) {
    return std::isalnum(static_cast<unsigned char>(c)) || c == '_';
}

// A path for display: one separator, always '/'. On Windows a project path (backslashes) joined with a
// manifest's forward-slash entry produces a mixed `C:\proj\src/main.pol`; forward slashes throughout read
// clean, stay clickable, and match what the editor passes for its overlay files.
std::string displayPath(const std::string& path) {
    std::string p = path;
    std::replace(p.begin(), p.end(), '\\', '/');
    return p;
}

// How many characters the caret should underline, starting at column `col` (0-based) of `line`: the
// identifier run there, or 1 when the column is not on an identifier (an operator, end of line).
int caretWidth(const std::string& line, int col) {
    if (col < 0 || col >= static_cast<int>(line.size())) {
        return 1;
    }
    if (!isIdentChar(line[col])) {
        return 1;
    }
    int end = col;
    while (end < static_cast<int>(line.size()) && isIdentChar(line[end])) {
        ++end;
    }
    return end - col;
}

// The severity token with its code, e.g. "error[Polaron-0101]" or, for an un-coded diagnostic, just "error".
std::string severityToken(std::string_view severity, Code code) {
    std::string s(severity);
    const std::string cs = codeString(code);
    if (!cs.empty()) {
        s += "[" + cs + "]";
    }
    return s;
}

// Append `body` to `out` as a labelled section: "  <label>: <text>", wrapping at ~92 columns with the
// continuation lines hanging under the text (not the label). Blank body is skipped entirely.
void section(std::string& out, std::string_view label, std::string_view body) {
    if (body.empty()) {
        return;
    }
    const std::string lead = " " + std::string(label) + ": ";
    const std::size_t indent = 10;  // " why:     " etc. line up the section bodies
    std::string pad(indent, ' ');
    // First line: the label, padded to `indent`, then wrapped words.
    std::string line = lead;
    while (line.size() < indent) {
        line += ' ';
    }
    std::size_t col = line.size();
    std::size_t i = 0;
    bool firstWord = true;
    while (i < body.size()) {
        // take the next word
        std::size_t j = i;
        while (j < body.size() && body[j] != ' ') {
            ++j;
        }
        const std::string word(body.substr(i, j - i));
        if (!firstWord && col + 1 + word.size() > 92) {
            out += line;
            out += '\n';
            line = pad;
            col = indent;
            line += word;
            col += word.size();
        } else {
            if (!firstWord) {
                line += ' ';
                ++col;
            }
            line += word;
            col += word.size();
        }
        firstWord = false;
        i = j + 1;
    }
    out += line;
    out += '\n';
}
}  // namespace

// Which codes have already had their write-up printed in this run. Process-wide, like the concise
// flag next door, because "this run" is what a reader experiences as one piece of output.
std::set<std::string>& explainedCodes() {
    static std::set<std::string> seen;
    return seen;
}

namespace {
SourceResolver g_resolver;
}
void setSourceResolver(SourceResolver r) { g_resolver = r; }

std::string render(std::string_view severity, const std::string& path, int line, int col,
                   const std::string& message, Code code, const std::string& sourceLineIn,
                   bool concise) {
    const std::string sev = severityToken(severity, code);
    // The resolver fills in what the reporting site could not know: how the path should read, and
    // the source text under the caret. A caller that already has the line keeps it.
    const std::string shown =
        displayPath(g_resolver.display != nullptr ? g_resolver.display(path, line) : path);
    const std::string sourceLine =
        (sourceLineIn.empty() && g_resolver.line != nullptr) ? g_resolver.line(path, line)
                                                             : sourceLineIn;

    // Concise: the one line CI and Forge's live-check parse.
    if (concise) {
        return shown + ":" + std::to_string(line) + ":" + std::to_string(col) + ": " + sev + ": " +
               message + "\n";
    }

    const Entry& e = entry(code);
    std::string out;
    out += sev + ": " + message + "\n";
    out += "  --> " + shown + ":" + std::to_string(line) + ":" + std::to_string(col) + "\n";

    // The snippet: the offending line with a caret beneath it. `line`/`col` are 1-based.
    if (!sourceLine.empty() && line > 0) {
        const std::string num = std::to_string(line);
        const std::string gutter(num.size(), ' ');
        out += "   " + gutter + " |\n";
        out += "   " + num + " | " + sourceLine + "\n";
        const int col0 = col > 0 ? col - 1 : 0;
        const int w = caretWidth(sourceLine, col0);
        std::string carets = "   " + gutter + " | " + std::string(col0, ' ') + std::string(w, '^');
        if (!e.caret.empty()) {
            carets += " " + std::string(e.caret);
        }
        out += carets + "\n";
    }

    // The rich sections (only for coded diagnostics; an un-coded one stops at the snippet).
    //
    // ONCE PER CODE PER RUN. The write-up is worth reading the first time and is noise the tenth: a
    // file with two naming warnings printed the same fifteen lines twice, and a real program with a
    // dozen of them would bury everything else under repeated prose. That is how output stops being
    // read at all -- and a diagnostic nobody reads has failed, however good it is.
    //
    // The rule is per RUN rather than per file, because a build is one thing to a reader. Later
    // occurrences keep their headline, location and caret, and say where the rest went.
    if (code != Code::None) {
        out += "   " + std::string(std::to_string(line).size(), ' ') + " |\n";
        if (explainedCodes().insert(codeString(code)).second) {
            section(out, "why", e.why);
            section(out, "fix", e.fix);
            section(out, "prevent", e.prevent);
        } else {
            section(out, "see", "the write-up above, or `polc --explain " + codeString(code) + "`");
        }
    }
    return out;
}

}  // namespace polaron::diag
