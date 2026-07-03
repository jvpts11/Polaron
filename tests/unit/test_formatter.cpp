#include <doctest/doctest.h>
#include <string>
#include "fmt/formatter.h"
#include "lexer/lexer.h"

using namespace ldp3;

namespace {
// The non-comment token lexemes, to check formatting never changes the token sequence.
std::vector<std::string> codeTokens(const std::string& src) {
    Lexer lexer(src, "t");
    std::vector<std::string> out;
    for (const Token& t : lexer.tokenize())
        if (t.kind != TokenKind::EndOfFile) out.push_back(t.lexeme);
    return out;
}
}  // namespace

TEST_CASE("format normalizes indentation and spacing and is idempotent") {
    const std::string messy = "public class X{\npublic method f()returns int{\nreturn 1+2;\n}\n}\n";
    bool ok = false;
    const std::string f1 = fmt::format(messy, "t", &ok);
    CHECK(ok);
    const std::string f2 = fmt::format(f1, "t", &ok);
    CHECK(f2 == f1);  // idempotent
    CHECK(f1.find("\n    public method") != std::string::npos);  // indented under the class
    CHECK(f1.find("1 + 2") != std::string::npos);                // spaced binary operator
}

TEST_CASE("format preserves comments and does not change the token sequence") {
    const std::string src = "// leading\npublic class X {\nint x=5;// trailing\n}\n";
    const std::string f = fmt::format(src, "t");
    CHECK(f.find("// leading") != std::string::npos);
    CHECK(f.find("// trailing") != std::string::npos);
    CHECK(codeTokens(src) == codeTokens(f));  // meaning preserved
}

TEST_CASE("format keeps generic angle brackets tight when the source is tight") {
    const std::string src = "ArrayList<String> a = b;\n";
    const std::string f = fmt::format(src, "t");
    CHECK(f.find("ArrayList<String>") != std::string::npos);
}
