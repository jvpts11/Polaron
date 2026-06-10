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

// A program with a helper class `classDef` plus a Main whose body is `mainBody`.
std::string withClass(const std::string& classDef, const std::string& mainBody) {
    return "program P; public bundle b { public namespace n { " + classDef +
           " public class Main { public static method main(string[] args) returns void { " +
           mainBody + " } } } }";
}

// A canonical helper class used across the class-semantics tests.
const std::string kCounter =
    "public class Counter { private mutable int count;"
    " public constructor Counter() { this.count = 0; }"
    " public method inc() returns void { this.count = this.count + 1; }"
    " public method get() returns int { return this.count; } }";
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

// ---- Classes (M4) ----

TEST_CASE("semantic accepts a class with fields, ctor and instance methods") {
    CHECK(checkSrc(withClass(kCounter, "Counter c = new Counter() on stack; c.inc();")));
}

TEST_CASE("semantic rejects assignment to an immutable field") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Box { private int v;"
        " public method set() returns void { this.v = 5; } }",
        "")));
}

TEST_CASE("semantic accepts assignment to a mutable field") {
    CHECK(checkSrc(withClass(
        "public class Box { private mutable int v;"
        " public method set() returns void { this.v = 5; } }",
        "")));
}

TEST_CASE("semantic rejects access to a nonexistent field") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Box { private mutable int v;"
        " public method bad() returns void { this.w = 5; } }",
        "")));
}

TEST_CASE("semantic rejects a call to a nonexistent method") {
    CHECK_FALSE(checkSrc(withClass(kCounter, "Counter c = new Counter() on stack; c.nope();")));
}

TEST_CASE("semantic rejects 'new' of an unknown class") {
    CHECK_FALSE(checkSrc(withClass(kCounter, "Widget w = new Widget() on stack;")));
}

TEST_CASE("semantic rejects 'delete' of a non-object") {
    CHECK_FALSE(checkSrc(withClass(kCounter, "int x = 5; delete x;")));
}

TEST_CASE("semantic accepts 'delete' of a heap object") {
    CHECK(checkSrc(withClass(kCounter, "Counter c = new Counter() on heap; delete c;")));
}

TEST_CASE("semantic rejects 'this' in a static context") {
    CHECK_FALSE(checkSrc(withClass(kCounter, "int x = this.count;")));
}

TEST_CASE("semantic accepts a static method called on the class") {
    CHECK(checkSrc(withClass(
        "public class MathU { public static method sq(int x) returns int { return x * x; } }",
        "int r = MathU.sq(4);")));
}

TEST_CASE("semantic rejects an instance method called statically") {
    CHECK_FALSE(checkSrc(withClass(kCounter, "int r = Counter.get();")));
}

TEST_CASE("semantic rejects a redeclared class") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class Dup { } public class Dup { }"
        " public class Main { public static method main(string[] args) returns void { } } } }"));
}

TEST_CASE("semantic accepts a valid inline field initializer") {
    CHECK(checkSrc(withClass("public class Cfg { public int w = 80; }", "")));
}

TEST_CASE("semantic rejects a field initializer of the wrong type") {
    CHECK_FALSE(checkSrc(withClass("public class Cfg { public int w = 1 < 2; }", "")));
}

TEST_CASE("semantic rejects printf with a non-literal format argument") {
    CHECK_FALSE(checkSrc(withClass(
        kCounter,
        "Counter c = new Counter() on stack; System.IO.printf(c.get());")));
}

TEST_CASE("semantic accepts printf with a literal format and a value") {
    CHECK(checkSrc(withClass(
        kCounter,
        "Counter c = new Counter() on stack; System.IO.printf(\"%d\\n\", c.get());")));
}

TEST_CASE("semantic accepts 'new' without an explicit location") {
    CHECK(checkSrc(withClass(kCounter, "Counter c = new Counter(); c.inc();")));
}

TEST_CASE("semantic accepts println with no arguments") {
    CHECK(checkSrc(withClass(kCounter, "System.IO.println();")));
}

TEST_CASE("semantic accepts println with a literal and a value") {
    CHECK(checkSrc(withClass(
        kCounter, "Counter c = new Counter(); System.IO.println(\"%d\", c.get());")));
}

TEST_CASE("semantic rejects println with a non-literal first argument") {
    CHECK_FALSE(checkSrc(withClass(
        kCounter, "Counter c = new Counter(); System.IO.println(c.get());")));
}

// ---- Arrays (M5) ----

TEST_CASE("semantic accepts array new, index, length and delete") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int[] a = new int[4](); a[0] = 7; int x = a[0] + a.length(); delete a; }")));
}

TEST_CASE("semantic infers element type from indexing") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ char[] cs = new char[2](); cs[0] = 'A'; char c = cs[0]; }")));
}

TEST_CASE("semantic rejects indexing a non-array") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int n = 5; int x = n[0]; }")));
}

TEST_CASE("semantic rejects a non-int array index") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int[] a = new int[2](); int x = a[1 < 2]; }")));
}

TEST_CASE("semantic rejects assigning the wrong type to an array element") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int[] a = new int[2](); a[0] = 1 < 2; }")));
}

TEST_CASE("semantic rejects calling a non-length method on an array") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int[] a = new int[2](); a.foo(); }")));
}

// ---- Input + interpolation (M6 / M5+) ----

TEST_CASE("semantic accepts readInt into an int") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = System.IO.readInt(); }")));
}

TEST_CASE("semantic rejects readInt with arguments") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = System.IO.readInt(5); }")));
}

TEST_CASE("semantic accepts interpolation in println") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int a = 1; System.IO.println($\"a = {a}, twice = {a + a}\"); }")));
}

TEST_CASE("semantic rejects interpolating a non-printable value") {
    CHECK_FALSE(checkSrc(withClass(
        kCounter, "Counter c = new Counter(); System.IO.println($\"c = {c}\");")));
}
