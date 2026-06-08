#include <doctest/doctest.h>

#include <string>

#include "lexer/lexer.h"
#include "parser/parser.h"
#include "semantic/analyzer.h"

using namespace ldp3;

namespace {
// Runs lex -> parse -> sema on `src`; returns true if the program is valid.
bool checkSrc(const std::string& src, std::string* entryOut = nullptr) {
    Lexer lexer(src, "test");
    Parser parser(lexer.tokenize(), "test");
    const ast::Program prog = parser.parse();
    if (parser.hasErrors()) return false;
    SemanticAnalyzer sema;
    const bool ok = sema.analyze(prog);
    if (ok && entryOut != nullptr) *entryOut = sema.entryPoint().qualifiedName;
    return ok;
}

// Wraps a class member in a minimal program with a public class Main.
std::string wrapMain(const std::string& member) {
    return "program P; public bundle b { public namespace n { public class Main { " + member +
           " } } }";
}
}  // namespace

TEST_CASE("semantic accepts a valid entry point") {
    std::string entry;
    CHECK(checkSrc(wrapMain("public static method main(string[] args) returns void { }"), &entry));
    CHECK(entry == "b.n.Main.main");
}

TEST_CASE("semantic accepts main returning int") {
    CHECK(checkSrc(wrapMain("public static method main(string[] args) returns int { }")));
}

TEST_CASE("semantic rejects a non-static main") {
    CHECK_FALSE(checkSrc(wrapMain("public method main(string[] args) returns void { }")));
}

TEST_CASE("semantic rejects main with the wrong parameter type") {
    CHECK_FALSE(checkSrc(wrapMain("public static method main(int x) returns void { }")));
}

TEST_CASE("semantic rejects a program without class Main") {
    const std::string src =
        "program P; public bundle b { public namespace n { public class Helper { "
        "public static method main(string[] args) returns void { } } } }";
    CHECK_FALSE(checkSrc(src));
}

TEST_CASE("semantic rejects multiple entry points") {
    const std::string src =
        "program P; public bundle b {"
        " public namespace n1 { public class Main {"
        "   public static method main(string[] a) returns void { } } }"
        " public namespace n2 { public class Main {"
        "   public static method main(string[] a) returns void { } } }"
        "}";
    CHECK_FALSE(checkSrc(src));
}

TEST_CASE("semantic rejects an undeclared variable") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int y = x + 1; }")));
}

TEST_CASE("semantic rejects variable redeclaration") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int z = 1; int z = 2; }")));
}

TEST_CASE("semantic accepts local var type inference") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { var n = 5; int m = n + 1; }")));
}

TEST_CASE("semantic rejects assignment to an immutable variable") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = 1; x = 2; }")));
}

TEST_CASE("semantic accepts assignment to a mutable variable") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { mutable int x = 1; x = 2; }")));
}

TEST_CASE("semantic rejects increment of an immutable variable") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = 1; x++; }")));
}

TEST_CASE("semantic types a comparison as boolean") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { boolean b = 1 < 2; }")));
}

TEST_CASE("semantic rejects assigning a boolean to an int") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int b = 1 < 2; }")));
}

TEST_CASE("semantic rejects logical operators on int operands") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { boolean b = 1 && 2; }")));
}

TEST_CASE("semantic rejects a non-boolean if condition") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { if (5) { } }")));
}

TEST_CASE("semantic scopes variables to their block") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ if (1 < 2) { int x = 1; } int y = x; }")));
}

TEST_CASE("semantic forbids shadowing in a nested block") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int x = 1; if (1 < 2) { int x = 2; } }")));
}

TEST_CASE("semantic rejects a non-boolean while condition") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { while (1) { } }")));
}

TEST_CASE("semantic scopes the for-init variable to the loop") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ for (mutable int i = 0; i < 3; i++) { } int x = i; }")));
}
