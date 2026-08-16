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

// ANSI, and only where it will be rendered. Red for an error, yellow for a warning -- the two things
// severity has to answer at a glance, before any of the words are read.
//
// The escape sequences go OUTSIDE the token, never inside it: `error[Polaron-0102]` stays one
// unbroken substring, so a build log grep and every PASS_REGULAR_EXPRESSION in the suite keep
// matching whether colour is on or off.
constexpr std::string_view kRed = "\033[31m";
constexpr std::string_view kYellow = "\033[33m";
constexpr std::string_view kReset = "\033[0m";

std::string_view severityColor(std::string_view severity) {
    return severity == "warning" ? kYellow : kRed;
}

std::string paint(std::string_view severity, const std::string& text, bool color) {
    if (!color) {
        return text;
    }
    return std::string(severityColor(severity)) + text + std::string(kReset);
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
bool g_color = false;
bool g_verbose = true;
}
void setSourceResolver(SourceResolver r) { g_resolver = r; }
void setColor(bool on) { g_color = on; }
bool colorEnabled() { return g_color; }
void setVerbose(bool on) { g_verbose = on; }

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
        return shown + ":" + std::to_string(line) + ":" + std::to_string(col) + ": " +
               paint(severity, sev, g_color) + ": " + message + "\n";
    }

    const Entry& e = entry(code);
    std::string out;
    out += paint(severity, sev, g_color) + ": " + message + "\n";
    out += "  --> " + shown + ":" + std::to_string(line) + ":" + std::to_string(col) + "\n";

    // The snippet: the offending line with a caret beneath it. `line`/`col` are 1-based.
    if (!sourceLine.empty() && line > 0) {
        const std::string num = std::to_string(line);
        const std::string gutter(num.size(), ' ');
        out += "   " + gutter + " |\n";
        out += "   " + num + " | " + sourceLine + "\n";
        const int col0 = col > 0 ? col - 1 : 0;
        const int w = caretWidth(sourceLine, col0);
        std::string marker(w, '^');
        if (!e.caret.empty()) {
            marker += " " + std::string(e.caret);
        }
        // The caret and its label share the severity's colour: the eye lands on the place before it
        // starts reading, which is the whole job of a caret.
        out += "   " + gutter + " | " + std::string(col0, ' ') + paint(severity, marker, g_color) +
               "\n";
    }

    // The rich sections (only for coded diagnostics; an un-coded one stops at the snippet).
    //
    // EVERY TIME, BY DEFAULT. An earlier version printed the write-up once per code per run and gave
    // later occurrences a pointer to it, on the theory that repetition trains people to skim. The
    // theory is wrong about who is reading: someone fixing the fourth of four errors is looking at
    // that error, not scrolling up to the first, and a compiler that decides they have had enough
    // explaining is rationing the one thing it is uniquely able to give them.
    //
    // `--noVerbose` is how a reader who already knows says so -- once, on the command line, rather
    // than being decided for.
    if (code != Code::None) {
        out += "   " + std::string(std::to_string(line).size(), ' ') + " |\n";
        if (g_verbose) {
            section(out, "why", e.why);
            section(out, "fix", e.fix);
            section(out, "prevent", e.prevent);
        } else {
            section(out, "see", "`polc --explain " + codeString(code) + "`");
        }
    }
    return out;
}

}  // namespace polaron::diag
