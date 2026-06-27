#include <doctest/doctest.h>

#include <string>

#include "lexer/lexer.h"
#include "parser/monomorphize.h"
#include "parser/parser.h"
#include "semantic/analyzer.h"

using namespace ldp3;

namespace {
// Runs lex -> parse -> monomorphize -> sema on `src`; true if the program is valid.
bool checkSrc(const std::string& src, std::string* entryOut = nullptr) {
    Lexer lexer(src, "test");
    Parser parser(lexer.tokenize(), "test");
    ast::Program prog = parser.parse();
    if (parser.hasErrors()) return false;
    resolveTypeAliases(prog);  // expand `typealias` first, as the real pipeline does
    qualifyNamespaces(prog);  // matches the real pipeline (run before monomorphize)
    if (!monomorphize(prog)) return false;
    SemanticAnalyzer sema;
    const bool ok = sema.analyze(prog);
    if (ok && entryOut != nullptr) *entryOut = sema.entryPoint().qualifiedName;
    return ok;
}

// Wraps a class member in a minimal program with a public class Main. Imports go before `program`
// (spec 2.7). Tests run sema without the prelude, so a minimal System.IO.Console stub namespace is
// included so the import resolves; the I/O calls themselves are compiler builtins.
const char* kIoHead = "import System.IO.Console; program P; public bundle b { ";
const char* kIoStub = "public namespace System.IO { public class Console { } } ";

std::string wrapMain(const std::string& member) {
    return std::string(kIoHead) + kIoStub +
           "public namespace n { public class Main { " + member + " } } }";
}

// A program with a helper class `classDef` plus a Main whose body is `mainBody`.
std::string withClass(const std::string& classDef, const std::string& mainBody) {
    return std::string(kIoHead) + kIoStub + "public namespace n { " +
           classDef + " public class Main { public static method main(string[] args) returns void { " +
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

TEST_CASE("semantic accepts persistent / eternal / transient field modifiers") {
    CHECK(checkSrc(withClass(
        "public class Config {"
        " public eternal persistent int counter = 0;"
        " private eternal persistent int sessions = 0;"
        " private transient int cache = 0;"
        " public constructor Config() {} }",
        "")));
}

TEST_CASE("semantic accepts a persistent local variable") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " persistent mutable int n = 0; n = n + 1; }")));
}

TEST_CASE("semantic accepts a persistent instance field accessed via a variable") {
    CHECK(checkSrc(
        "program P; public bundle main { public namespace app {"
        " public class Car { public eternal persistent mutable int chassi = 0;"
        " public constructor Car() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " Car c = new Car() on heap; c.chassi = c.chassi + 1; delete c; return; } } } }"));
}

TEST_CASE("semantic accepts a persistent instance field used via this in a method") {
    CHECK(checkSrc(
        "program P; public bundle main { public namespace app {"
        " public class Car { public eternal persistent mutable int chassi = 0;"
        " public constructor Car() {}"
        " public method bump() returns void { this.chassi = this.chassi + 1; } }"
        " public class Main { public static method main(string[] args) returns void {"
        " Car c = new Car() on heap; c.bump(); delete c; return; } } } }"));
}

TEST_CASE("semantic accepts null assigned to a pointer and compared with ==/!=") {
    CHECK(checkSrc(
        "program P; public bundle main { public namespace app {"
        " public class Node { public mutable int v = 0; public constructor Node() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " mutable nullable Node* p = null; if (p == null) { p = new Node() on heap; }"
        " if (p != null) { delete p; } return; } } } }"));
}

TEST_CASE("semantic accepts a persistent pointer field (graph serialization)") {
    CHECK(checkSrc(
        "program P; public bundle main { public namespace app {"
        " public class Engine { public mutable int power = 0; public constructor Engine() {} }"
        " public class Car { public eternal persistent mutable Engine* engine;"
        " public constructor Car() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " Car c = new Car() on heap; c.engine = new Engine() on heap;"
        " c.engine.power = 1; delete c; return; } } } }"));
}

TEST_CASE("semantic rejects a non-eternal persistent field never released (spec 18.15)") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle main { public namespace app {"
        " public class Cache { public persistent mutable int slot = 0;"
        " public constructor Cache() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " Cache c = new Cache() on heap; delete c; return; } } } }"));
}

TEST_CASE("semantic accepts a non-eternal persistent field released somewhere (spec 18.15)") {
    CHECK(checkSrc(
        "program P; public bundle main { public namespace app {"
        " public class Cache { public persistent mutable int slot = 0;"
        " public constructor Cache() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " Cache c = new Cache() on heap; release persistent c.slot; delete c; return; } } } }"));
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

TEST_CASE("semantic accepts reading and writing a static field as ClassName.field") {
    CHECK(checkSrc(withClass(
        "public class Counter { private static mutable int count;"
        " public static method inc() returns void { Counter.count = Counter.count + 1; }"
        " public static method get() returns int { return Counter.count; } }",
        "Counter.inc(); int n = Counter.get();")));
}

TEST_CASE("semantic rejects assigning to a non-mutable static field") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Cfg { private static int limit; }", "Cfg.limit = 5;")));
}

TEST_CASE("semantic rejects accessing a non-static field as ClassName.field") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Box { private mutable int v; }", "int n = Box.v;")));
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
        "Counter c = new Counter() on stack; System.IO.Console.printf(c.get());")));
}

TEST_CASE("semantic accepts printf with a literal format and a value") {
    CHECK(checkSrc(withClass(
        kCounter,
        "Counter c = new Counter() on stack; System.IO.Console.printf(\"%d\\n\", c.get());")));
}

TEST_CASE("semantic accepts 'new' without an explicit location") {
    CHECK(checkSrc(withClass(kCounter, "Counter c = new Counter(); c.inc();")));
}

TEST_CASE("semantic accepts println with no arguments") {
    CHECK(checkSrc(withClass(kCounter, "System.IO.Console.println();")));
}

TEST_CASE("semantic accepts println with a literal and a value") {
    CHECK(checkSrc(withClass(
        kCounter, "Counter c = new Counter(); System.IO.Console.println(\"%d\", c.get());")));
}

TEST_CASE("semantic rejects println with a non-literal first argument") {
    CHECK_FALSE(checkSrc(withClass(
        kCounter, "Counter c = new Counter(); System.IO.Console.println(c.get());")));
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
        "public static method main(string[] args) returns void { int x = System.IO.Console.read(); }")));
}

TEST_CASE("semantic rejects readInt with arguments") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = System.IO.Console.read(5); }")));
}

TEST_CASE("semantic accepts interpolation in println") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ int a = 1; System.IO.Console.println($\"a = {a}, twice = {a + a}\"); }")));
}

TEST_CASE("semantic rejects interpolating a non-printable value") {
    CHECK_FALSE(checkSrc(withClass(
        kCounter, "Counter c = new Counter(); System.IO.Console.println($\"c = {c}\");")));
}

// ---- Inheritance, interfaces and polymorphism (M8) ----

TEST_CASE("semantic accepts inheritance, override and an upcast") {
    CHECK(checkSrc(withClass(
        "public class Animal { public method speak() returns void { } }"
        " public class Dog extends Animal { public override method speak() returns void { } }",
        "Animal a = new Dog(); a.speak();")));
}

TEST_CASE("semantic rejects extends of an unknown class") {
    CHECK_FALSE(checkSrc(withClass("public class Dog extends Ghost { }", "")));
}

TEST_CASE("semantic rejects instantiating an abstract class") {
    CHECK_FALSE(checkSrc(withClass(
        "public abstract class Shape { public abstract method area() returns int; }",
        "Shape s = new Shape();")));
}

TEST_CASE("semantic rejects 'override' that overrides nothing") {
    CHECK_FALSE(checkSrc(withClass(
        "public class A { public override method foo() returns void { } }", "")));
}

TEST_CASE("semantic requires 'override' on an inherited method") {
    CHECK_FALSE(checkSrc(withClass(
        "public class A { public method foo() returns void { } }"
        " public class B extends A { public method foo() returns void { } }",
        "")));
}

TEST_CASE("semantic rejects a concrete class leaving a method abstract") {
    CHECK_FALSE(checkSrc(withClass(
        "public abstract class Shape { public abstract method area() returns int; }"
        " public class Bad extends Shape { }",
        "")));
}

TEST_CASE("semantic accepts implementing an interface") {
    CHECK(checkSrc(withClass(
        "public interface Drawable { method draw() returns void; }"
        " public class Dot implements Drawable { public override method draw() returns void { } }",
        "")));
}

TEST_CASE("semantic accepts a class implementing two interfaces and dispatching each") {
    // Regression: a class implementing two interfaces must resolve each interface's
    // method through its own pointer. Codegen lays vtables out by global per-name
    // slots so n.nameCode() and s.size() land on the right slots (codegen_multi_iface).
    CHECK(checkSrc(withClass(
        "public interface Named { method nameCode() returns int; }"
        " public interface Sized { method size() returns int; }"
        " public class Item implements Named, Sized {"
        " public override method nameCode() returns int { return 7; }"
        " public override method size() returns int { return 42; } }",
        "Item it = new Item() on stack; Named* n = &it; Sized* s = &it;"
        " int a = n.nameCode(); int b = s.size();")));
}

TEST_CASE("semantic rejects an inheritance cycle") {
    CHECK_FALSE(checkSrc(withClass(
        "public class A extends B { } public class B extends A { }", "")));
}

TEST_CASE("semantic accepts initializing an immutable field in the constructor") {
    CHECK(checkSrc(withClass(
        "public class Box { private int v;"
        " public constructor Box(int x) { this.v = x; }"
        " public method get() returns int { return this.v; } }",
        "Box b = new Box(7);")));
}

// ---- Enums (M9) ----

TEST_CASE("semantic accepts an enum constant and comparison") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public enum Color { RED, GREEN, BLUE }"
        " public class Main { public static method main(string[] args) returns void {"
        " Color c = Color.RED; boolean x = c == Color.BLUE; } } } }"));
}

TEST_CASE("semantic rejects an unknown enum constant") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public enum Color { RED, GREEN }"
        " public class Main { public static method main(string[] args) returns void {"
        " Color c = Color.PURPLE; } } } }"));
}

TEST_CASE("semantic rejects mixing an enum with an int") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public enum Color { RED, GREEN }"
        " public class Main { public static method main(string[] args) returns void {"
        " int x = Color.RED; } } } }"));
}

// ---- Pointers / references (0.2 Fase A1) ----

TEST_CASE("semantic accepts a pointer, address-of and member access through it") {
    CHECK(checkSrc(withClass(
        "public class Box { public mutable int v;"
        " public method get() returns int { return this.v; } }",
        "Box b = new Box() on stack; Box* p = &b; int x = p.get();")));
}

TEST_CASE("semantic accepts an upcast pointer (Square* to Shape*)") {
    CHECK(checkSrc(withClass(
        "public abstract class Shape { public abstract method area() returns int; }"
        " public class Square extends Shape {"
        " public override method area() returns int { return 1; } }",
        "Square sq = new Square() on stack; Shape* s = &sq; int a = s.area();")));
}

// ---- Ownership (0.2 Fase B) ----

TEST_CASE("semantic accepts a move and the new owner") {
    CHECK(checkSrc(withClass(
        "public movable class H { public mutable int id;"
        " public constructor H() { this.id = 1; } }",
        "H a = new H() on heap; H b = move a;")));
}

TEST_CASE("semantic rejects use of a moved variable") {
    CHECK_FALSE(checkSrc(withClass(
        "public movable class H { public mutable int id;"
        " public constructor H() { this.id = 1; }"
        " public method v() returns int { return this.id; } }",
        "H a = new H() on heap; H b = move a; int x = a.v();")));
}

TEST_CASE("semantic rejects assigning a movable without move") {
    CHECK_FALSE(checkSrc(withClass(
        "public movable class H { public mutable int id;"
        " public constructor H() { this.id = 1; } }",
        "H a = new H() on heap; H b = a;")));
}

TEST_CASE("semantic treats unique assignment as an implicit move") {
    CHECK_FALSE(checkSrc(withClass(
        "public unique class U { public mutable int id;"
        " public constructor U() { this.id = 1; }"
        " public method v() returns int { return this.id; } }",
        "U a = new U() on heap; U b = a; int x = a.v();")));
}

TEST_CASE("semantic reactivates a moved variable on reassignment") {
    CHECK(checkSrc(withClass(
        "public movable class H { public mutable int id;"
        " public constructor H() { this.id = 1; }"
        " public method v() returns int { return this.id; } }",
        "mutable H a = new H() on heap; H b = move a;"
        " a = new H() on heap; int x = a.v();")));
}

// ---- Floating point ----

TEST_CASE("semantic accepts double arithmetic") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void "
        "{ double pi = 3.14; double a = pi * 2.0; }")));
}

TEST_CASE("semantic widens an int to a double") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { double d = 5; }")));
}

TEST_CASE("semantic rejects narrowing a double to an int") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = 3.14; }")));
}

TEST_CASE("semantic rejects modulo on doubles") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { double x = 5.0 % 2.0; }")));
}

TEST_CASE("semantic widens an int to a long") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int n = 3; long w = n; }")));
}

TEST_CASE("semantic rejects narrowing a long to an int") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { long w = 3; int n = w; }")));
}

TEST_CASE("semantic accepts an explicit cast that narrows a double to an int") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int n = cast<int>(3.14); }")));
}

TEST_CASE("semantic accepts an explicit cast that narrows a long to an int") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { long w = 3; int n = cast<int>(w); }")));
}

TEST_CASE("semantic accepts a reference cast (reflection downcast, F10)") {
    CHECK(checkSrc(withClass(
        "public class Animal { public constructor Animal() {} }",
        "Animal a = new Animal(); Animal b = cast<Animal>(a);")));
}

TEST_CASE("semantic rejects casting a number to a class") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Animal { public constructor Animal() {} }",
        "int n = 5; Animal a = cast<Animal>(n);")));
}

namespace {
// A base class and a subclass whose constructor forwards an argument via super.
const std::string kAnimalDog =
    "public class Animal { protected int legs;"
    " public constructor Animal(int legs) { this.legs = legs; } }"
    " public class Dog extends Animal { private mutable int barks;"
    " public constructor Dog(int barks) { super(4); this.barks = barks; } }";
}  // namespace

TEST_CASE("semantic accepts super(args) as the first statement of a constructor") {
    CHECK(checkSrc(withClass(kAnimalDog, "Dog d = new Dog(3);")));
}

TEST_CASE("semantic rejects super(args) when the class has no superclass") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Lonely { public constructor Lonely() { super(1); } }",
        "Lonely x = new Lonely();")));
}

TEST_CASE("semantic rejects super(args) outside the first statement") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Animal { protected int legs;"
        " public constructor Animal(int legs) { this.legs = legs; } }"
        " public class Dog extends Animal { private mutable int barks;"
        " public constructor Dog(int barks) { this.barks = barks; super(4); } }",
        "Dog d = new Dog(3);")));
}

TEST_CASE("semantic accepts a struct value type with a constructor and method") {
    CHECK(checkSrc(withClass(
        "public struct Point { public mutable int x; public mutable int y;"
        " public constructor Point(int x, int y) { this.x = x; this.y = y; } }",
        "Point p = new Point(1, 2); int s = p.x + p.y;")));
}

TEST_CASE("parser rejects a struct that extends another type") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Base { public constructor Base() {} }"
        " public struct Bad extends Base { public mutable int x; }",
        "int n = 0;")));
}

TEST_CASE("semantic rejects a class that extends a struct") {
    CHECK_FALSE(checkSrc(withClass(
        "public struct S { public mutable int x; }"
        " public class C extends S { public constructor C() {} }",
        "int n = 0;")));
}

TEST_CASE("semantic accepts a comptime literal suffix function") {
    CHECK(checkSrc(withClass(
        "public comptime literal kib(int x) returns long { return cast<long>(x) * 1024; }",
        "long s = kib(64);")));
}

TEST_CASE("semantic rejects a literal suffix that is not comptime") {
    CHECK_FALSE(checkSrc(withClass(
        "public literal kib(int x) returns long { return cast<long>(x); }",
        "long s = kib(1);")));
}

TEST_CASE("parser rejects a literal suffix with more than one parameter") {
    CHECK_FALSE(checkSrc(withClass(
        "public comptime literal bad(int x, int y) returns long { return cast<long>(x); }",
        "int n = 0;")));
}

namespace {
// A program with a literal suffix `kib` in namespace `n` and a Main in `m`.
// `importLine` goes before `program` (spec 2.7).
std::string withSuffix(const std::string& importLine, const std::string& mainBody) {
    return importLine + " program P; public bundle b {"
           " public namespace n { public comptime literal kib(int x) returns long {"
           " return cast<long>(x) * 1024; } }"
           " public namespace m { public class Main {"
           " public static method main(string[] args) returns void { " +
           mainBody + " } } } }";
}
}  // namespace

TEST_CASE("semantic accepts the N-suffix form when the suffix is imported") {
    CHECK(checkSrc(withSuffix("import n.kib;", "long s = 64 kib;")));
}

TEST_CASE("semantic rejects the N-suffix form without an import") {
    CHECK_FALSE(checkSrc(withSuffix("", "long s = 64 kib;")));
}

TEST_CASE("semantic still allows an explicit literal call without an import") {
    CHECK(checkSrc(withSuffix("", "long s = kib(64);")));
}

TEST_CASE("semantic rejects an import of an unknown symbol") {
    CHECK_FALSE(checkSrc(withSuffix("import n.nope;", "int s = 0;")));
}

TEST_CASE("semantic accepts a region: allocate, new in region, release") {
    CHECK(checkSrc(withClass(
        "public class Dog { public constructor Dog() {} }",
        "region r = itself.allocate(1024); Dog* d = new Dog() in region r; release region r;")));
}

TEST_CASE("semantic rejects new in an unknown region") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Dog { public constructor Dog() {} }",
        "Dog* d = new Dog() in region nope;")));
}

TEST_CASE("semantic rejects release of a non-region") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int x = 5; release region x; }")));
}

namespace {
const std::string kDogCat =
    "public class Dog { public constructor Dog() {} }"
    " public class Cat { public constructor Cat() {} }";
}  // namespace

TEST_CASE("semantic allows allocating an accepted type in a region") {
    CHECK(checkSrc(withClass(
        kDogCat,
        "region r = itself.allocate(1024).accepts({Dog}); Dog* d = new Dog() in region r;")));
}

TEST_CASE("semantic rejects allocating a type a region does not accept") {
    CHECK_FALSE(checkSrc(withClass(
        kDogCat,
        "region r = itself.allocate(1024).accepts({Dog}); Cat* c = new Cat() in region r;")));
}

TEST_CASE("semantic rejects allocating a type a region rejects") {
    CHECK_FALSE(checkSrc(withClass(
        kDogCat,
        "region r = itself.allocate(1024).rejects({Cat}); Cat* c = new Cat() in region r;")));
}

TEST_CASE("semantic accepts a subtype of an accepted type in a region") {
    CHECK(checkSrc(withClass(
        "public class Animal { public constructor Animal() {} }"
        " public class Dog extends Animal { public constructor Dog() {} }",
        "region r = itself.allocate(1024).accepts({Animal}); Dog* d = new Dog() in region r;")));
}

TEST_CASE("semantic accepts a record with fields and a method, plus auto equals") {
    CHECK(checkSrc(withClass(
        "public record Point(int x, int y) { public method sum() returns int { return this.x + this.y; } }",
        "Point p = new Point(1, 2); int s = p.sum(); boolean e = p.equals(p);")));
}

TEST_CASE("semantic rejects mutating a record field (records are immutable)") {
    CHECK_FALSE(checkSrc(withClass(
        "public record Point(int x, int y) {}",
        "Point p = new Point(1, 2); p.x = 9;")));
}

TEST_CASE("parser rejects a record with an extra field beyond its parameters") {
    CHECK_FALSE(checkSrc(withClass(
        "public record Point(int x, int y) { private int extra; }",
        "int n = 0;")));
}

TEST_CASE("parser rejects a record that extends a type") {
    CHECK_FALSE(checkSrc(withClass(
        "public record Point(int x) extends Object {}",
        "int n = 0;")));
}

TEST_CASE("semantic accepts a java-style enum with fields and a method") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public enum Planet { EARTH(10, 2), MARS(30, 3);"
        " private final int mass; private final int radius;"
        " public constructor Planet(int mass, int radius) { this.mass = mass; this.radius = radius; }"
        " public method density() returns int { return this.mass / this.radius; } }"
        " public class Main { public static method main(string[] args) returns void {"
        " int d = Planet.EARTH.density(); } } } }"));
}

TEST_CASE("semantic still accepts a plain int-style enum") {
    CHECK(checkSrc(withClass(
        "public enum Color { RED, GREEN, BLUE }",
        "Color c = Color.GREEN;")));
}

TEST_CASE("semantic accepts a generic class instantiated with two element types") {
    CHECK(checkSrc(withClass(
        "public class Box<T> { private T value;"
        " public constructor Box(T v) { this.value = v; }"
        " public method get() returns T { return this.value; } }",
        "Box<int> a = new Box<int>(1); Box<char> b = new Box<char>('x');"
        " int x = a.get();")));
}

TEST_CASE("parser keeps a < b as a comparison, not a generic declaration") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " int a = 1; int b = 2; boolean c = a < b; }")));
}

TEST_CASE("semantic accepts properties: auto, init-only and computed get-only") {
    CHECK(checkSrc(withClass(
        "public class Rect { public int w { get; set; } public int h { get; init; }"
        " public constructor Rect(int w, int h) { this.w = w; this.h = h; }"
        " public int area { get { return this.w * this.h; } } }",
        "Rect r = new Rect(3, 4); int a = r.area; r.w = 10;")));
}

TEST_CASE("semantic rejects writing an init-only property after construction") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Rect { public int h { get; init; }"
        " public constructor Rect(int h) { this.h = h; } }",
        "Rect r = new Rect(4); r.h = 9;")));
}

TEST_CASE("parser still allows a method named get (get is a soft keyword)") {
    CHECK(checkSrc(withClass(
        "public class Box { public mutable int v;"
        " public constructor Box(int v) { this.v = v; }"
        " public method get() returns int { return this.v; } }",
        "Box b = new Box(5); int x = b.get();")));
}

TEST_CASE("semantic accepts operator overloading and types a + b as its return") {
    CHECK(checkSrc(withClass(
        "public class Vec { public mutable int x;"
        " public constructor Vec(int x) { this.x = x; }"
        " public operator + (Vec o) returns Vec { return new Vec(this.x + o.x) on heap; }"
        " public operator == (Vec o) returns boolean { return this.x == o.x; } }",
        "Vec a = new Vec(1) on heap; Vec b = new Vec(2) on heap;"
        " Vec c = a + b; boolean eq = a == b;")));
}

namespace {
// A Shape hierarchy plus a match in Main's body.
std::string withMatch(const std::string& matchBody) {
    return withClass(
        "public abstract class Shape { public abstract method area() returns int; }"
        " public class Circle extends Shape { private int r;"
        " public constructor Circle(int r) { this.r = r; }"
        " public override method area() returns int { return this.r; } }",
        "Shape* s = new Circle(2) on heap; " + matchBody);
}
}  // namespace

TEST_CASE("semantic accepts a match with subtype cases and field bindings") {
    CHECK(checkSrc(withMatch("match (s) { case Circle(int r) { int x = r; } default {} }")));
}

namespace {
// A sealed Shape permitting Circle and Square, plus a match in Main's body.
std::string withSealed(const std::string& matchBody) {
    return withClass(
        "public sealed abstract class Shape permits Circle, Square {"
        " public abstract method area() returns int; }"
        " public class Circle extends Shape { public constructor Circle() {}"
        " public override method area() returns int { return 0; } }"
        " public class Square extends Shape { public constructor Square() {}"
        " public override method area() returns int { return 0; } }",
        "Shape* s = new Circle() on heap; " + matchBody);
}
}  // namespace

TEST_CASE("semantic accepts an exhaustive sealed match without a default") {
    CHECK(checkSrc(withSealed("match (s) { case Circle() {} case Square() {} }")));
}

TEST_CASE("semantic rejects a non-exhaustive sealed match without a default") {
    CHECK_FALSE(checkSrc(withSealed("match (s) { case Circle() {} }")));
}

TEST_CASE("semantic rejects a non-sealed match without a default") {
    CHECK_FALSE(checkSrc(withMatch("match (s) { case Circle(int r) { int x = r; } }")));
}

TEST_CASE("semantic accepts a match expression with a binding and a default") {
    CHECK(checkSrc(withMatch("int v = match (s) { case Circle(int r) -> r * r; default -> 0; };")));
}

TEST_CASE("semantic accepts an exhaustive sealed match expression without a default") {
    CHECK(checkSrc(withSealed("int v = match (s) { case Circle() -> 1; case Square() -> 2; };")));
}

TEST_CASE("semantic rejects a non-exhaustive sealed match expression without a default") {
    CHECK_FALSE(checkSrc(withSealed("int v = match (s) { case Circle() -> 1; };")));
}

TEST_CASE("semantic rejects a non-sealed match expression without a default") {
    CHECK_FALSE(checkSrc(withMatch("int v = match (s) { case Circle(int r) -> r; };")));
}

TEST_CASE("semantic accepts requires/ensures contract clauses") {
    CHECK(checkSrc(withClass(
        "public class C { public method m(int x) returns void"
        " requires x > 0 ensures x > 0 { } }",
        "int n = 0;")));
}

TEST_CASE("semantic rejects a non-boolean contract clause") {
    CHECK_FALSE(checkSrc(withClass(
        "public class C { public method m(int x) returns void requires x + 1 { } }",
        "int n = 0;")));
}

TEST_CASE("semantic accepts a class invariant") {
    CHECK(checkSrc(withClass(
        "public class C { private mutable int x; invariant this.x >= 0;"
        " public constructor C() { this.x = 1; } }",
        "int n = 0;")));
}

TEST_CASE("semantic accepts a generic instantiation that satisfies its constraint") {
    CHECK(checkSrc(withClass(
        "public abstract class Shape { public abstract method area() returns int; }"
        " public class Circle extends Shape { public constructor Circle() {}"
        " public override method area() returns int { return 1; } }"
        " public class Box<T extends Shape> { private T* it;"
        " public constructor Box(T* it) { this.it = it; } }",
        "Circle c = new Circle() on stack; Box<Circle> b = new Box<Circle>(&c) on stack;")));
}

TEST_CASE("semantic accepts variance markers (out/in) on type parameters") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class A<out T> { public constructor A() {} }"
        " public class C<in T> { public constructor C() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " A<int> a = new A<int>() on stack; C<int> c = new C<int>() on stack; return; } } } }"));
}

TEST_CASE("semantic accepts a generic pointer variable and generic upcast") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class Animal<T> { public constructor Animal() {}"
        " public method s() returns int { return 0; } }"
        " public class Dog<T> extends Animal<T> { public constructor Dog() {}"
        " public override method s() returns int { return 1; } }"
        " public class Main { public static method main(string[] args) returns void {"
        " Animal<int>* a = new Dog<int>() on heap; int x = a.s(); delete a; } } } }"));
}

TEST_CASE("semantic accepts generic inheritance") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class Base<T> { public constructor Base() {}"
        " public method f() returns int { return 1; } }"
        " public class Derived<T> extends Base<T> { public constructor Derived() {} }"
        " public class Main { public static method main(string[] args) returns void {"
        " Derived<int> d = new Derived<int>() on stack; int x = d.f(); } } } }"));
}

TEST_CASE("semantic accepts a generic method call") {
    CHECK(checkSrc(withClass(
        "public class Util { public constructor Util() {}"
        " public method identity<T>(T x) returns T { return x; } }",
        "Util u = new Util() on stack; int x = u.identity<int>(42);")));
}

TEST_CASE("semantic rejects a generic instantiation that violates its constraint") {
    CHECK_FALSE(checkSrc(withClass(
        "public abstract class Shape { public abstract method area() returns int; }"
        " public class Box<T extends Shape> { private T* it;"
        " public constructor Box(T* it) { this.it = it; } }",
        "int n = 5; Box<int> b = new Box<int>(&n) on stack;")));
}

TEST_CASE("semantic accepts a true static_assert") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " static_assert(2 + 2 == 4, \"ok\"); }")));
}

TEST_CASE("semantic rejects a false static_assert") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " static_assert(1 == 2, \"nope\"); }")));
}

TEST_CASE("semantic rejects a non-constant static_assert") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " mutable int x = 3; static_assert(x == 3, \"not const\"); }")));
}

TEST_CASE("semantic accepts break and continue inside loops") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " for (mutable int i = 0; i < 3; i++) { if (i == 1) { continue; } if (i == 2) { break; } } }")));
}

TEST_CASE("semantic accepts foreach over an array") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " int[] a = new int[3](); mutable int s = 0; for (int x in a) { s = s + x; } }")));
}

TEST_CASE("semantic accepts var in foreach (inferred element type)") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " int[] a = new int[3](); mutable int s = 0; for (var x in a) { s = s + x; } }")));
}

TEST_CASE("semantic rejects foreach over a non-array") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " mutable int a = 3; for (int x in a) { } }")));
}

TEST_CASE("semantic accepts a switch with cases and default") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " mutable int x = 1; switch (x) { case 1 { } case 2 { break; } default { } } }")));
}

TEST_CASE("semantic accepts labeled break and continue") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " outer: for (mutable int i = 0; i < 3; i++) { for (mutable int j = 0; j < 3; j++) {"
        " if (i == j) { break outer; } if (j == 0) { continue outer; } } } }")));
}

TEST_CASE("semantic accepts a do-while loop") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " mutable int n = 0; do { n = n + 1; } while (n < 3); }")));
}

TEST_CASE("semantic accepts compound assignment") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " mutable int x = 1; x += 2; x *= 3; x -= 1; }")));
}

TEST_CASE("semantic accepts final on a field and a local") {
    CHECK(checkSrc(withClass(
        "public class C { private final int x; public constructor C() { this.x = 5; }"
        " public method get() returns int { return this.x; } }",
        "C c = new C() on stack; final int y = c.get();")));
}

TEST_CASE("semantic rejects reassigning a final local") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " final int y = 5; y = 6; }")));
}

TEST_CASE("semantic accepts bitwise compound assignment") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " mutable int x = 12; x &= 10; x |= 1; x ^= 3; x <<= 2; x >>= 1; }")));
}

TEST_CASE("semantic accepts bitwise operators") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " int a = 12; int b = 10; int c = (a & b) | (a ^ b); int d = a << 2 >> 1; int e = ~a; }")));
}

TEST_CASE("semantic rejects bitwise on a float operand") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { double f = 1.5; int c = f & 3; }")));
}

TEST_CASE("semantic accepts a ternary expression") {
    CHECK(checkSrc(wrapMain(
        "public static method main(string[] args) returns void {"
        " int a = 1; int b = 2; int m = a > b ? a : b; }")));
}

TEST_CASE("semantic rejects a ternary with a non-boolean condition") {
    CHECK_FALSE(checkSrc(wrapMain(
        "public static method main(string[] args) returns void { int a = 5; int m = a ? 1 : 2; }")));
}

TEST_CASE("semantic accepts operator[] overloading") {
    CHECK(checkSrc(withClass(
        "public class Triple { private int a; public constructor Triple() { this.a = 7; }"
        " public operator [] (int i) returns int { return this.a; } }",
        "Triple t = new Triple() on stack; int x = t[0];")));
}

TEST_CASE("semantic accepts operator[]= overloading") {
    CHECK(checkSrc(withClass(
        "public class Box { private mutable int a; public constructor Box() { this.a = 0; }"
        " public operator []= (int i, int v) returns void { this.a = v; } }",
        "Box b = new Box() on stack; b[0] = 5;")));
}

TEST_CASE("semantic accepts enum count() and values()") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public enum E { A, B, C }"
        " public class Main { public static method main(string[] args) returns void {"
        " int k = E.count(); mutable int s = 0; for (int x in E.values()) { s = s + x; } } } } }"));
}

TEST_CASE("semantic accepts a pointer field and pointer-field assignment") {
    CHECK(checkSrc(withClass(
        "public class Node { public mutable int val; public mutable Node* next;"
        " public constructor Node(int v) { this.val = v; } }",
        "Node a = new Node(1) on stack; Node b = new Node(2) on stack; a.next = &b;")));
}

TEST_CASE("semantic accepts chained member access through pointer fields") {
    CHECK(checkSrc(withClass(
        "public class Node { public mutable int val; public mutable Node* next;"
        " public constructor Node(int v) { this.val = v; } }",
        "Node a = new Node(1) on stack; Node b = new Node(2) on stack;"
        " a.next = &b; int x = a.next.val;")));
}

TEST_CASE("semantic rejects a class extending a sealed type not in its permits") {
    CHECK_FALSE(checkSrc(withClass(
        "public sealed class Base permits Ok { public constructor Base() {} }"
        " public class Ok extends Base { public constructor Ok() {} }"
        " public class Sneaky extends Base { public constructor Sneaky() {} }",
        "int n = 0;")));
}

TEST_CASE("semantic rejects a match case that is not a subtype of the subject") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Foo { public constructor Foo() {} }"
        " public abstract class Shape { public abstract method area() returns int; }"
        " public class Circle extends Shape { public constructor Circle() {}"
        " public override method area() returns int { return 0; } }",
        "Shape* s = new Circle() on heap; match (s) { case Foo() {} default {} }")));
}

namespace {
// `importLine` goes before `program` (spec 2.7). A Widget lives in namespace `lib`; Main
// in namespace `app` uses it -- visible only with an import.
std::string crossNs(const std::string& importLine) {
    return importLine + " program P; public bundle b {"
           " public namespace lib { public class Widget { public constructor Widget() {} } }"
           " public namespace app { public class Main {"
           " public static method main(string[] args) returns void {"
           " Widget w = new Widget(); } } } }";
}
}  // namespace

TEST_CASE("semantic rejects a type from another namespace without an import") {
    CHECK_FALSE(checkSrc(crossNs("")));
}

TEST_CASE("semantic accepts a type from another namespace when imported") {
    CHECK(checkSrc(crossNs("import lib.Widget;")));
}

TEST_CASE("semantic allows a type from the same namespace without an import") {
    CHECK(checkSrc(withClass(
        "public class Widget { public constructor Widget() {} }",
        "Widget w = new Widget();")));
}

TEST_CASE("semantic rejects an import whose namespace prefix is wrong") {
    CHECK_FALSE(checkSrc(crossNs("import wrong.Widget;")));
}

TEST_CASE("semantic accepts a C-style union and lets its fields be written") {
    CHECK(checkSrc(withClass(
        "public union Value { int asInt; float asFloat; }",
        "Value v = new Value(); v.asFloat = 1.5; int b = v.asInt;")));
}

TEST_CASE("semantic rejects a field typed from another namespace without an import") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b {"
        " public namespace lib { public class Widget { public constructor Widget() {} } }"
        " public namespace app { public class Holder { private Widget w; }"
        " public class Main { public static method main(string[] args) returns void {} } } }"));
}

namespace {
// A helper class returning a tuple, used by the tuple destructuring tests (spec 22.5).
const std::string kMathX =
    "public class MathX {"
    " public static method divmod(int a, int b) returns (int, int) { return (a / b, a % b); } }";
}  // namespace

TEST_CASE("semantic accepts a tuple return and destructuring") {
    CHECK(checkSrc(withClass(kMathX, "(int q, int r) = MathX.divmod(17, 5);")));
}

TEST_CASE("semantic accepts a tuple literal initializer destructured into locals") {
    CHECK(checkSrc(withClass(kMathX, "(int x, int y) = (1, 2);")));
}

TEST_CASE("semantic binds tuple components as usable locals") {
    CHECK(checkSrc(withClass(
        kMathX, "(int q, int r) = MathX.divmod(9, 4); System.IO.Console.println($\"{q} {r}\");")));
}

TEST_CASE("semantic rejects a tuple destructuring with the wrong arity") {
    CHECK_FALSE(checkSrc(withClass(kMathX, "(int q, int r, int s) = MathX.divmod(9, 4);")));
}

TEST_CASE("semantic rejects destructuring a non-tuple value") {
    CHECK_FALSE(checkSrc(withClass(kMathX, "(int x, int y) = 42;")));
}

TEST_CASE("semantic rejects a tuple component bound to an incompatible type") {
    // The components are int; a boolean binding can't accept an int (no narrowing).
    CHECK_FALSE(checkSrc(withClass(kMathX, "(boolean q, int r) = MathX.divmod(9, 4);")));
}

// ---- Freestanding mode (spec 36) ----

TEST_CASE("semantic accepts low-level memory in freestanding mode") {
    CHECK(checkSrc(
        "program K freestanding; public bundle b freestanding { public namespace n {"
        " public class Main { public static method main(string[] args) returns int {"
        " address a = Memory.alloc(8); int* p = cast<int*>(a); p[0] = 5;"
        " int x = p[0]; Memory.free(a); return x; } } } }"));
}

TEST_CASE("semantic rejects async in freestanding mode") {
    CHECK_FALSE(checkSrc(
        "program K freestanding; public bundle b freestanding { public namespace n {"
        " public class Main { public static async method foo() returns int { return 1; }"
        " public static method main(string[] args) returns int { return 0; } } } }"));
}

TEST_CASE("semantic rejects exceptions in freestanding mode") {
    CHECK_FALSE(checkSrc(
        "program K freestanding; public bundle b freestanding { public namespace n {"
        " public class Oops { public constructor Oops() {} }"
        " public class Main { public static method main(string[] args) returns int {"
        " throw new Oops() on heap; } } } }"));
}

TEST_CASE("semantic accepts a self-referential generic class, declared and instantiated") {
    // A `Node<T>* next` field inside Node<T>: the monomorphizer must not generate a bogus `Node$T`
    // from the template's self-reference, and instantiating Node<int> must not crash (cloneExpr used
    // to drop the `null` literal -> null deref).
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class Node<T> { public mutable T v; public mutable nullable Node<T>* next;"
        " public constructor Node(T x) { this.v = x; this.next = null; } }"
        " public class Main { public static method main(string[] args) returns void {"
        " Node<int> a = new Node<int>(5) on heap; a.next = a; return; } } } }"));
}

// ---- Null safety (spec 3.7) ----
namespace {
// Wraps a method body with a Dog class (has bark()) + Main, for the nullable tests.
std::string withDog(const std::string& body) {
    return "program P; public bundle b { public namespace n {"
           " public class Dog { public constructor Dog() {}"
           " public method bark() returns int { return 1; } }"
           " public class Main { public static method main(string[] args) returns void { " +
           body + " } } } }";
}
}  // namespace

TEST_CASE("semantic rejects assigning null to a non-nullable type") {
    CHECK_FALSE(checkSrc(withDog("Dog d = null; return;")));
}
TEST_CASE("semantic accepts null in a nullable type") {
    CHECK(checkSrc(withDog("nullable Dog d = null; return;")));
}
TEST_CASE("semantic accepts a non-null value flowing into a nullable") {
    CHECK(checkSrc(withDog("nullable Dog d = new Dog() on heap; return;")));
}
TEST_CASE("semantic rejects a nullable flowing into a non-nullable") {
    CHECK_FALSE(checkSrc(withDog("nullable Dog d = null; Dog e = d; return;")));
}
TEST_CASE("semantic allows a member access on a nullable (deref traps at runtime if null)") {
    // `nullable` only constrains assignment; dereferencing is permitted with no flow check.
    CHECK(checkSrc(withDog("nullable Dog d = new Dog() on heap; int x = d.bark(); return;")));
}
TEST_CASE("semantic allows a member access on a nullable inside a null check too") {
    CHECK(checkSrc(withDog(
        "nullable Dog d = new Dog() on heap; if (d != null) { int x = d.bark(); } return;")));
}

// First-class functions (spec 22): methodref binds a function value to obj.method.
TEST_CASE("semantic infers a function type for methodref") {
    CHECK(checkSrc(withDog(
        "Dog d = new Dog() on heap; function<int> f = methodref d.bark; int x = f(); return;")));
}
TEST_CASE("semantic rejects methodref to a missing method") {
    CHECK_FALSE(
        checkSrc(withDog("Dog d = new Dog() on heap; function<int> f = methodref d.woof; return;")));
}
TEST_CASE("semantic rejects methodref assigned to the wrong function type") {
    CHECK_FALSE(checkSrc(
        withDog("Dog d = new Dog() on heap; function<void> f = methodref d.bark; return;")));
}

// Type aliases and newtype (spec 24).
namespace {
std::string withAlias(const std::string& decls, const std::string& body) {
    return "program P; public bundle b { public namespace n {" + decls +
           " public class Main { public static method main(string[] args) returns void { " + body +
           " } } } }";
}
}  // namespace
TEST_CASE("semantic treats a typealias as interchangeable with its target") {
    CHECK(checkSrc(withAlias("public typealias Meters = int;", "Meters m = 5; int x = m + 1; return;")));
}
TEST_CASE("semantic accepts a newtype value cast to and from its underlying type") {
    CHECK(checkSrc(withAlias("public newtype OrderId = int;",
                             "OrderId o = cast<OrderId>(5); int x = cast<int>(o); return;")));
}
TEST_CASE("semantic rejects assigning the underlying type to a newtype without a cast") {
    CHECK_FALSE(checkSrc(withAlias("public newtype OrderId = int;", "OrderId o = 5; return;")));
}
TEST_CASE("semantic rejects assigning a newtype to its underlying type without a cast") {
    CHECK_FALSE(checkSrc(withAlias("public newtype OrderId = int;",
                                   "OrderId o = cast<OrderId>(5); int x = o; return;")));
}
TEST_CASE("semantic keeps two newtypes over the same underlying distinct") {
    CHECK_FALSE(checkSrc(withAlias("public newtype A = int; public newtype B = int;",
                                   "A a = cast<A>(5); B b = a; return;")));
}

// Custom annotations (spec 14.3).
namespace {
// A program with one annotation `[MaxLength]` (one required field `value`, one optional `msg`)
// applied to a class via `appl`, e.g. "[MaxLength(value: 10)]".
std::string withAnnotation(const std::string& appl) {
    return "program P; public bundle b { public namespace n {"
           " public annotation MaxLength { int value; String msg default \"x\"; } " +
           appl +
           " public class Foo { public constructor Foo() {} }"
           " public class Main { public static method main(string[] args) returns void { return; } "
           "} } }";
}
}  // namespace
TEST_CASE("semantic accepts a valid annotation application") {
    CHECK(checkSrc(withAnnotation("[MaxLength(value: 10)]")));
}
TEST_CASE("semantic accepts an annotation that also sets an optional field") {
    CHECK(checkSrc(withAnnotation("[MaxLength(value: 10, msg: \"hi\")]")));
}
TEST_CASE("semantic rejects an unknown annotation") {
    CHECK_FALSE(checkSrc(withAnnotation("[Bogus(value: 1)]")));
}
TEST_CASE("semantic rejects an annotation missing a required field") {
    CHECK_FALSE(checkSrc(withAnnotation("[MaxLength]")));
}
TEST_CASE("semantic rejects an annotation argument that is not a field") {
    CHECK_FALSE(checkSrc(withAnnotation("[MaxLength(value: 1, nope: 2)]")));
}
TEST_CASE("semantic rejects a duplicate annotation argument") {
    CHECK_FALSE(checkSrc(withAnnotation("[MaxLength(value: 1, value: 2)]")));
}

// Contracts (spec 29).
namespace {
// A class C with one int field and a `bump` method carrying the given contract clauses, plus Main.
std::string withContract(const std::string& clauses, const std::string& body) {
    return "program P; public bundle b { public namespace n {"
           " public class C { private mutable int v;"
           " public constructor C() { this.v = 0; }"
           " public method bump(int n) returns void " +
           clauses + " { " + body +
           " } }"
           " public class Main { public static method main(string[] args) returns void { return; } "
           "} } }";
}
}  // namespace
TEST_CASE("semantic accepts requires and ensures with old()") {
    CHECK(checkSrc(withContract("requires n > 0 ensures this.v == old(this.v) + n",
                                "this.v = this.v + n;")));
}
TEST_CASE("semantic rejects a non-boolean contract clause") {
    CHECK_FALSE(checkSrc(withContract("requires this.v", "this.v = this.v + n;")));
}
TEST_CASE("semantic accepts a class invariant") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class C { private mutable int v; invariant this.v >= 0;"
        " public constructor C() { this.v = 0; } }"
        " public class Main { public static method main(string[] args) returns void { return; } } } }"));
}

// `final import` (spec 37.6): the imported symbol cannot be unimported.
TEST_CASE("semantic rejects unimport of a final-imported symbol") {
    CHECK_FALSE(checkSrc(
        "final import lib.Widget; program P; public bundle b {"
        " public namespace lib { public class Widget { public constructor Widget() {} } }"
        " public namespace app { public class Main {"
        " public static method main(string[] args) returns void { unimport Widget; return; } } } }"));
}
TEST_CASE("semantic allows unimport of a plainly-imported symbol") {
    CHECK(checkSrc(
        "import lib.Widget; program P; public bundle b {"
        " public namespace lib { public class Widget { public constructor Widget() {} } }"
        " public namespace app { public class Main {"
        " public static method main(string[] args) returns void { unimport Widget; return; } } } }"));
}

// `cascade println` (spec 37.1 rule 4): only supported if the type provides the per-node form,
// i.e. a describe() method. Without one it is a compile error.
TEST_CASE("semantic rejects cascade println without a describe method") {
    CHECK_FALSE(checkSrc(withClass(
        "public class N { public mutable int id; public constructor N() { this.id = 0; } }",
        "N* a = new N() on heap; cascade Console.println(a); delete a;")));
}
TEST_CASE("semantic accepts cascade println when describe is defined") {
    CHECK(checkSrc(withClass(
        "public class N { public mutable int id; public constructor N() { this.id = 0; }"
        " public method describe() returns void { System.IO.Console.println($\"N {this.id}\"); } }",
        "N* a = new N() on heap; cascade Console.println(a); delete a;")));
}

// `cascade release persistent X` (spec 37.1) satisfies the spec 18.15 release obligation for every
// persistent reachable from X.
TEST_CASE("semantic accepts cascade release satisfying the persistent obligation") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class Session { public persistent mutable int token;"
        " public constructor Session() { this.token = 0; } }"
        " public class Main { public static method main(string[] args) returns void {"
        " Session s = new Session() on heap; cascade release persistent s; delete s; return; } } } }"));
}
TEST_CASE("semantic rejects a non-eternal persistent with no release at all") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n {"
        " public class Session { public persistent mutable int token;"
        " public constructor Session() { this.token = 0; } }"
        " public class Main { public static method main(string[] args) returns void {"
        " Session s = new Session() on heap; delete s; return; } } } }"));
}

// The chaos tetrad (goto/comefrom/abstainfrom/reinstate) is intra-method only (spec 7.9-7.11): a
// method-qualified `method.label` reference is rejected.
TEST_CASE("semantic rejects cross-method abstainfrom") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n { public class Main {"
        " public static method run() returns void { label proc; }"
        " public static method main(string[] args) returns void {"
        " abstainfrom run.proc; return; } } } }"));
}
TEST_CASE("semantic accepts intra-method abstainfrom") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n { public class Main {"
        " public static method main(string[] args) returns void {"
        " abstainfrom body; label body; return; } } } }"));
}

// A goto/comefrom/abstainfrom target must be a label declared in the same method (spec 7.9-7.11).
TEST_CASE("semantic rejects goto to an unknown label") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n { public class Main {"
        " public static method main(string[] args) returns void { goto nope; return; } } } }"));
}
TEST_CASE("semantic accepts goto to a forward label in the same method") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n { public class Main {"
        " public static method main(string[] args) returns void {"
        " goto done; label done; return; } } } }"));
}
// At most one comefrom may target a given label (spec 7.10 rule 2).
TEST_CASE("semantic rejects two comefroms to the same label") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b { public namespace n { public class Main {"
        " public static method main(string[] args) returns void {"
        " label x; comefrom x; comefrom x; return; } } } }"));
}
// `goto <addr>` / `goto externFn` are unchecked FFI/low-level jumps (spec 7.9).
TEST_CASE("semantic accepts goto to a raw address") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n { public class Main {"
        " public static method main(string[] args) returns void { goto 0x1000; } } } }"));
}
TEST_CASE("semantic accepts goto to an extern function") {
    CHECK(checkSrc(
        "program P; public bundle b { public namespace n {"
        " extern cdecl method kernelEntry() returns void;"
        " public class Main { public static method main(string[] args) returns void {"
        " goto kernelEntry; } } } }"));
}

namespace {
const std::string kBox =
    "public class Box { public mutable int v;"
    " public constructor Box(int v) { this.v = v; }"
    " public method take(Box* b) returns void { } }";
}  // namespace

TEST_CASE("semantic type-checks constructor arguments") {
    CHECK(checkSrc(withClass(kBox, "Box* a = new Box(7) on heap;")));
    CHECK_FALSE(checkSrc(withClass(kBox, "Box* a = new Box(true) on heap;")));  // bool -> int
    CHECK_FALSE(checkSrc(withClass(kBox, "Box* a = new Box(null) on heap;")));  // null -> int
    CHECK_FALSE(checkSrc(withClass(kBox, "Box* a = new Box(1, 2) on heap;")));  // too many args
}

TEST_CASE("semantic type-checks method-call arguments") {
    CHECK(checkSrc(withClass(
        kBox, "Box* a = new Box(1) on heap; Box* c = new Box(2) on heap; a.take(c);")));
    CHECK_FALSE(checkSrc(withClass(  // int where a Box* parameter is expected
        kBox, "Box* a = new Box(1) on heap; a.take(5);")));
}
