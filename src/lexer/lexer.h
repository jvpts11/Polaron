#pragma once

#include <string>
#include <string_view>
#include <vector>

#include "lexer/token.h"

namespace polaron {

// A lexical diagnostic with location. The lexer collects these instead of
// aborting on the first problem (CLAUDE.md: accumulate errors when sensible).
struct LexError {
    std::string message;
    SourceLocation loc;
};

// One `///` documentation comment line: its line number and text (with the `///` and one leading space
// stripped). Consecutive lines form a doc block for the declaration that follows. Collected but not
// emitted as tokens, so parsing is unaffected; used by `polaron doc`.
struct DocComment {
    int line;
    std::string text;
};

// Turns Polaron source text into a flat list of tokens.
//
//   Lexer lexer(source, "file.pol");
//   std::vector<Token> tokens = lexer.tokenize();   // always ends with EndOfFile
//   if (lexer.hasErrors()) { for (auto& e : lexer.errors()) ... }
//
// `source` and `file` must outlive the lexer and the returned tokens
// (tokens keep a string_view to `file` in their SourceLocation).
class Lexer {
public:
    // keepComments: emit `//`, `///` and `/* */` as TokenKind::Comment tokens (for `polaron fmt`) instead of
    // discarding them. The parser uses the default (comments skipped).
    Lexer(std::string_view source, std::string_view file, bool keepComments = false);

    std::vector<Token> tokenize();

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<LexError>& errors() const { return errors_; }

    // The `///` doc comments collected during tokenize(), in source order.
    const std::vector<DocComment>& docComments() const { return docComments_; }

private:
    bool atEnd() const;
    char peek(int ahead = 0) const;
    char advance();
    bool match(char expected);
    SourceLocation here() const;

    void skipWhitespaceAndComments();
    void skipWhitespace();          // whitespace only, for keep-comments mode
    bool tryComment(Token& out);    // consume a comment as a token; true if one was found
    Token scanToken();
    Token scanIdentifierOrKeyword();
    Token scanNumber();
    Token scanChar();
    Token scanString();
    Token scanInterpString();

    Token make(TokenKind kind, std::string lexeme, SourceLocation loc) const;
    void error(std::string message, SourceLocation loc);

    std::string_view source_;
    std::string_view file_;
    std::size_t pos_ = 0;
    int line_ = 1;
    int col_ = 1;
    std::vector<LexError> errors_;
    std::vector<DocComment> docComments_;
    bool keepComments_ = false;
};

}  // namespace polaron
