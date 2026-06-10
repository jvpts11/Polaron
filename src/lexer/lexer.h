#pragma once

#include <string>
#include <string_view>
#include <vector>

#include "lexer/token.h"

namespace ldp3 {

// A lexical diagnostic with location. The lexer collects these instead of
// aborting on the first problem (CLAUDE.md: accumulate errors when sensible).
struct LexError {
    std::string message;
    SourceLocation loc;
};

// Turns LDP3 source text into a flat list of tokens.
//
//   Lexer lexer(source, "file.ldp3");
//   std::vector<Token> tokens = lexer.tokenize();   // always ends with EndOfFile
//   if (lexer.hasErrors()) { for (auto& e : lexer.errors()) ... }
//
// `source` and `file` must outlive the lexer and the returned tokens
// (tokens keep a string_view to `file` in their SourceLocation).
class Lexer {
public:
    Lexer(std::string_view source, std::string_view file);

    std::vector<Token> tokenize();

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<LexError>& errors() const { return errors_; }

private:
    bool atEnd() const;
    char peek(int ahead = 0) const;
    char advance();
    bool match(char expected);
    SourceLocation here() const;

    void skipWhitespaceAndComments();
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
};

}  // namespace ldp3
