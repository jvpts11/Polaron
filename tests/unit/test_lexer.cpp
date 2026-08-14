#include <doctest/doctest.h>

#include <cstddef>
#include <string_view>
#include <vector>

#include "lexer/lexer.h"

using namespace polaron;

namespace {
std::vector<TokenKind> kindsOf(std::string_view src) {
    Lexer lexer(src, "test");
    std::vector<TokenKind> out;
    for (const Token& t : lexer.tokenize()) out.push_back(t.kind);
    return out;
}
}  // namespace

TEST_CASE("lexer captures /// doc comments but not ordinary comments") {
    Lexer lexer("/// hello docs\n// not a doc\n/// second line\nclass X", "test");
    const std::vector<Token> toks = lexer.tokenize();
    // The doc comments are not tokens: only `class X` plus EOF remain.
    REQUIRE(toks.size() == 3);
    CHECK(toks[0].kind == TokenKind::KwClass);
    const std::vector<DocComment>& docs = lexer.docComments();
    REQUIRE(docs.size() == 2);
    CHECK(docs[0].text == "hello docs");
    CHECK(docs[0].line == 1);
    CHECK(docs[1].text == "second line");
    CHECK(docs[1].line == 3);
}

TEST_CASE("lexer distinguishes keywords from identifiers") {
    Lexer lexer("class classy", "test");
    const std::vector<Token> toks = lexer.tokenize();
    REQUIRE(toks.size() == 3);
    CHECK(toks[0].kind == TokenKind::KwClass);
    CHECK(toks[1].kind == TokenKind::Identifier);
    CHECK(toks[1].lexeme == "classy");
    CHECK(toks[2].kind == TokenKind::EndOfFile);
    CHECK_FALSE(lexer.hasErrors());
}

TEST_CASE("lexer scans integer literals in several bases") {
    Lexer lexer("42 0xFF 0b1010 1_000 100L", "test");
    const std::vector<Token> toks = lexer.tokenize();
    REQUIRE(toks.size() == 6);
    for (std::size_t i = 0; i < 5; ++i) CHECK(toks[i].kind == TokenKind::IntLiteral);
    CHECK(toks[0].lexeme == "42");
    CHECK(toks[1].lexeme == "0xFF");
    CHECK(toks[2].lexeme == "0b1010");
    CHECK(toks[3].lexeme == "1_000");
    CHECK(toks[4].lexeme == "100L");
}

TEST_CASE("lexer scans float literals") {
    const std::vector<TokenKind> k = kindsOf("3.14 2.0f 0.5");
    REQUIRE(k.size() == 4);
    CHECK(k[0] == TokenKind::FloatLiteral);
    CHECK(k[1] == TokenKind::FloatLiteral);
    CHECK(k[2] == TokenKind::FloatLiteral);
}

TEST_CASE("lexer scans char literals and escapes") {
    Lexer lexer("'a' '\\n'", "test");
    const std::vector<Token> toks = lexer.tokenize();
    REQUIRE(toks.size() == 3);
    CHECK(toks[0].kind == TokenKind::CharLiteral);
    CHECK(toks[0].lexeme == "a");
    CHECK(toks[1].kind == TokenKind::CharLiteral);
    CHECK(toks[1].lexeme == "\\n");  // raw content: backslash + 'n'
    CHECK_FALSE(lexer.hasErrors());
}

TEST_CASE("lexer reports an empty char literal") {
    Lexer lexer("''", "test");
    lexer.tokenize();
    CHECK(lexer.hasErrors());
}

TEST_CASE("lexer reports an unterminated string") {
    Lexer lexer("\"oops", "test");
    lexer.tokenize();
    CHECK(lexer.hasErrors());
}

TEST_CASE("lexer skips line and block comments") {
    Lexer lexer("a // comment\n /* block\n spanning */ b", "test");
    const std::vector<Token> toks = lexer.tokenize();
    REQUIRE(toks.size() == 3);
    CHECK(toks[0].lexeme == "a");
    CHECK(toks[1].lexeme == "b");
    CHECK_FALSE(lexer.hasErrors());
}

TEST_CASE("lexer reports an unterminated block comment") {
    Lexer lexer("/* never ends", "test");
    lexer.tokenize();
    CHECK(lexer.hasErrors());
}

TEST_CASE("lexer scans multi-character operators") {
    const std::vector<TokenKind> k = kindsOf("== != <= >= && || ++ -- << >> +=");
    REQUIRE(k.size() == 12);  // 11 operators + EndOfFile
    CHECK(k[0] == TokenKind::EqEq);
    CHECK(k[1] == TokenKind::BangEq);
    CHECK(k[2] == TokenKind::LtEq);
    CHECK(k[3] == TokenKind::GtEq);
    CHECK(k[4] == TokenKind::AmpAmp);
    CHECK(k[5] == TokenKind::PipePipe);
    CHECK(k[6] == TokenKind::PlusPlus);
    CHECK(k[7] == TokenKind::MinusMinus);
    CHECK(k[8] == TokenKind::Shl);
    CHECK(k[9] == TokenKind::Shr);
    CHECK(k[10] == TokenKind::PlusEq);
}

TEST_CASE("lexer does not swallow range operators after a number") {
    Lexer lexer("0..10", "test");
    const std::vector<Token> toks = lexer.tokenize();
    REQUIRE(toks.size() == 4);
    CHECK(toks[0].kind == TokenKind::IntLiteral);
    CHECK(toks[0].lexeme == "0");
    CHECK(toks[1].kind == TokenKind::DotDot);
    CHECK(toks[2].kind == TokenKind::IntLiteral);
    CHECK(toks[2].lexeme == "10");
}

TEST_CASE("lexer tracks source locations across lines") {
    Lexer lexer("a\n  b", "test");
    const std::vector<Token> toks = lexer.tokenize();
    REQUIRE(toks.size() == 3);
    CHECK(toks[0].loc.line == 1);
    CHECK(toks[0].loc.col == 1);
    CHECK(toks[1].loc.line == 2);
    CHECK(toks[1].loc.col == 3);
}
