#include <doctest/doctest.h>

#include "lexer/lexer.h"
#include "parser/parser.h"

using namespace ldp3;

namespace {
const char* kHello =
    "program HelloWorld;\n"
    "public bundle main {\n"
    "  public namespace app {\n"
    "    public class Main {\n"
    "      public static method main(string[] args) returns void {\n"
    "        System.IO.printf(\"x\", 1);\n"
    "      }\n"
    "    }\n"
    "  }\n"
    "}\n";
}  // namespace

TEST_CASE("parser builds the program hierarchy") {
    Lexer lexer(kHello, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());
    CHECK(prog.name == "HelloWorld");
    REQUIRE(prog.bundles.size() == 1);
    CHECK(prog.bundles[0].name == "main");
    CHECK(prog.bundles[0].visibility == "public");
    REQUIRE(prog.bundles[0].namespaces.size() == 1);
    CHECK(prog.bundles[0].namespaces[0].name == "app");
    REQUIRE(prog.bundles[0].namespaces[0].classes.size() == 1);
    CHECK(prog.bundles[0].namespaces[0].classes[0].name == "Main");
}

TEST_CASE("parser parses a member-access call expression") {
    Lexer lexer(kHello, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    REQUIRE_FALSE(parser.hasErrors());

    const ast::ClassDecl& cls = prog.bundles.at(0).namespaces.at(0).classes.at(0);
    REQUIRE(cls.members.size() == 1);
    const auto* method = dynamic_cast<const ast::MethodDecl*>(cls.members[0].get());
    REQUIRE(method != nullptr);
    REQUIRE(method->body.statements.size() == 1);
    const auto* stmt = dynamic_cast<const ast::ExprStmt*>(method->body.statements[0].get());
    REQUIRE(stmt != nullptr);
    const auto* call = dynamic_cast<const ast::CallExpr*>(stmt->expr.get());
    REQUIRE(call != nullptr);
    CHECK(call->args.size() == 2);
}

TEST_CASE("parser reports a missing semicolon with a location") {
    Lexer lexer("program P", "test");  // missing ';'
    Parser parser(lexer.tokenize(), "test");
    parser.parse();
    REQUIRE(parser.hasErrors());
    CHECK(parser.errors()[0].loc.line == 1);
}

TEST_CASE("parser reports a missing closing brace") {
    Lexer lexer("program P;\npublic bundle b {", "test");
    Parser parser(lexer.tokenize(), "test");
    parser.parse();
    CHECK(parser.hasErrors());
}
