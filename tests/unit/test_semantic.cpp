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
    monomorphize(prog);
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

TEST_CASE("semantic rejects a class cast in 0.1 (numeric casts only)") {
    CHECK_FALSE(checkSrc(withClass(
        "public class Animal { public constructor Animal() {} }",
        "Animal a = new Animal(); Animal b = cast<Animal>(a);")));
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
        "public comptime literal kib(int x) returns int64 { return cast<int64>(x) * 1024; }",
        "int64 s = kib(64);")));
}

TEST_CASE("semantic rejects a literal suffix that is not comptime") {
    CHECK_FALSE(checkSrc(withClass(
        "public literal kib(int x) returns int64 { return cast<int64>(x); }",
        "int64 s = kib(1);")));
}

TEST_CASE("parser rejects a literal suffix with more than one parameter") {
    CHECK_FALSE(checkSrc(withClass(
        "public comptime literal bad(int x, int y) returns int64 { return cast<int64>(x); }",
        "int n = 0;")));
}

namespace {
// A program with a literal suffix `kib` in namespace `n` and a Main in `m`.
// `importLine` is spliced right after the bundle's `{`.
std::string withSuffix(const std::string& importLine, const std::string& mainBody) {
    return "program P; public bundle b { " + importLine +
           " public namespace n { public comptime literal kib(int x) returns int64 {"
           " return cast<int64>(x) * 1024; } }"
           " public namespace m { public class Main {"
           " public static method main(string[] args) returns void { " +
           mainBody + " } } } }";
}
}  // namespace

TEST_CASE("semantic accepts the N-suffix form when the suffix is imported") {
    CHECK(checkSrc(withSuffix("import n.kib;", "int64 s = 64 kib;")));
}

TEST_CASE("semantic rejects the N-suffix form without an import") {
    CHECK_FALSE(checkSrc(withSuffix("", "int64 s = 64 kib;")));
}

TEST_CASE("semantic still allows an explicit literal call without an import") {
    CHECK(checkSrc(withSuffix("", "int64 s = kib(64);")));
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
// `importLine` after the bundle's `{`. A Widget lives in namespace `lib`; Main
// in namespace `app` uses it -- visible only with an import.
std::string crossNs(const std::string& importLine) {
    return "program P; public bundle b { " + importLine +
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
        "public union Value { int32 asInt; float32 asFloat; }",
        "Value v = new Value(); v.asFloat = 1.5; int b = v.asInt;")));
}

TEST_CASE("semantic rejects a field typed from another namespace without an import") {
    CHECK_FALSE(checkSrc(
        "program P; public bundle b {"
        " public namespace lib { public class Widget { public constructor Widget() {} } }"
        " public namespace app { public class Holder { private Widget w; }"
        " public class Main { public static method main(string[] args) returns void {} } } }"));
}
