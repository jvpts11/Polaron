#include "fmt/formatter.h"
#include <cctype>
#include "lexer/lexer.h"

namespace ldp3::fmt {
namespace {

const std::string kIndentUnit = "    ";  // four spaces per level

bool is(const Token& t, const char* s) { return t.lexeme == s; }

// A token that can end an expression -- so a following +/-/*/& is binary, and a following ( / [ is a call
// or index rather than a grouping.
bool isValueEnd(const Token& t) {
    if (t.kind == TokenKind::Identifier) return true;
    if (t.lexeme == ")" || t.lexeme == "]") return true;
    if (t.lexeme == "this" || t.lexeme == "true" || t.lexeme == "false" || t.lexeme == "null" ||
        t.lexeme == "itself" || t.lexeme == "super")
        return true;
    if (!t.lexeme.empty()) {  // a literal (number, string, char)
        const char c = t.lexeme.front();
        if (std::isdigit(static_cast<unsigned char>(c)) || c == '"' || c == '\'' || c == '$') return true;
    }
    return false;
}

bool isOpener(const Token& t) { return is(t, "{") || is(t, "(") || is(t, "["); }
bool isCloser(const Token& t) { return is(t, "}") || is(t, ")") || is(t, "]"); }

// Is `t` one of +/-/*/& used as a unary operator, given the preceding token `prev`?
bool isUnary(const Token& prev, const Token& t) {
    if (is(t, "!") || is(t, "~")) return true;
    if (is(t, "-") || is(t, "+") || is(t, "*") || is(t, "&")) return !isValueEnd(prev);
    return false;
}

// Was there whitespace between `prev` and `cur` in the original source (same line only)? Used to preserve
// the user's spacing around < and >, whose generic-vs-comparison meaning we don't try to infer.
bool hadSpaceBetween(const Token& prev, const Token& cur) {
    if (prev.loc.line != cur.loc.line) return true;
    return cur.loc.col > prev.loc.col + static_cast<int>(prev.lexeme.size());
}

// Should a space separate `prev` (was it unary?) from `cur` on one line? Defaults to yes (extra space never
// changes tokens); only well-known unambiguous cases omit it.
bool ambiguous(const Token& t) {  // single-char operators whose type-vs-value meaning we cannot infer
    return is(t, "<") || is(t, ">") || is(t, "*") || is(t, "&") || is(t, "[") || is(t, "]");
}

bool needsSpace(const Token& prev, bool prevUnary, const Token& cur) {
    // For the type-ambiguous operators (< > * & [ ]) keep the source's spacing: this avoids mangling
    // Box<int>, int*, T[] and array indexing, while `a < b` / `6 * 7` etc. stay however the user wrote them.
    if (ambiguous(prev) || ambiguous(cur)) return hadSpaceBetween(prev, cur);
    if (is(cur, ";") || is(cur, ",") || is(cur, ")") || is(cur, ".")) return false;
    if (is(prev, ".") || is(prev, "(")) return false;
    if (is(cur, "(") && isValueEnd(prev)) return false;  // call
    if (prevUnary) return false;
    return true;
}

}  // namespace

std::string format(std::string_view source, std::string_view file, bool* ok) {
    Lexer lexer(source, file, /*keepComments=*/true);
    const std::vector<Token> tokens = lexer.tokenize();
    if (lexer.hasErrors()) {
        if (ok) *ok = false;
        return std::string(source);
    }
    if (ok) *ok = true;

    std::string out;
    int depth = 0;
    int prevEndLine = 0;
    bool haveEmitted = false;
    Token prev;
    Token prevPrev;

    for (const Token& tok : tokens) {
        if (tok.kind == TokenKind::EndOfFile) break;

        // A closer dedents the line it starts.
        if (isCloser(tok)) depth = depth > 0 ? depth - 1 : 0;

        if (!haveEmitted) {  // first token: indent only, no leading newline
            for (int i = 0; i < depth; ++i) out += kIndentUnit;
        } else if (tok.loc.line > prevEndLine) {  // new line(s)
            out += "\n";
            if (tok.loc.line - prevEndLine > 1) out += "\n";  // keep at most one blank line
            for (int i = 0; i < depth; ++i) out += kIndentUnit;
        } else {
            const bool prevUnary = haveEmitted && isUnary(prevPrev, prev);
            if (needsSpace(prev, prevUnary, tok)) out += " ";
        }

        out += tok.lexeme;

        if (isOpener(tok)) ++depth;
        // End line of this token accounts for multi-line tokens (block comments, interpolated strings).
        int endLine = tok.loc.line;
        for (char c : tok.lexeme)
            if (c == '\n') ++endLine;
        prevEndLine = endLine;
        prevPrev = prev;
        prev = tok;
        haveEmitted = true;
    }

    out += "\n";  // single trailing newline
    return out;
}

}  // namespace ldp3::fmt
