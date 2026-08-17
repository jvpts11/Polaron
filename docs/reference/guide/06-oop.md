# 6. Object-Oriented Programming

Polaron is an object-oriented language in the strict sense: object orientation is not a
style you may adopt but the only way to organize code. There are no free functions, no
top-level variables, and no bare statements floating outside a type. Every piece of
behavior you write is a method that belongs to a class, and every piece of state is a
field of some object or a `static` member of some class. This chapter explains how
classes are built, how they relate to one another through inheritance and interfaces,
how method calls are resolved at runtime, and how the finishing touches — properties,
operator overloading, and enums — round out the model.

If you come from Java or C#, most of this will feel familiar, but Polaron makes several
deliberate choices that a newcomer must internalize early: assignment copies by default
(so class variables behave like values, not references), member access always goes
through `this.`, mutability is opt-in rather than the default, and overriding an
inherited member is never accidental — you must say `override`.

## 6.1 Everything Lives in a Class

A Polaron program is a nested hierarchy: a `program` declaration names the compilation
target, a `bundle` groups related code, a `namespace` carves out a naming scope, and
classes live inside namespaces. Execution begins in a `static` method named `main`
that takes a `string[]` and returns `void`. Because there is nowhere else to put code,
even the smallest program is a class:

```polaron
import System.IO.Console;
program Hello;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("hello, world");
                return;
            }
        }
    }
}
```

The `import` line brings the `Console` facilities into scope; the standard library
always requires an explicit import. Notice that `main` is `static`: it runs without an
instance, because at program start no objects exist yet. From `main` you construct the
first objects and the program grows outward from there.

## 6.2 Fields, Constructors, and Destructors

A class bundles together the data it owns (its **fields**) with the operations that act
on that data (its **methods**). Fields declare the shape of every instance. Each field
carries an explicit visibility keyword — `public`, `private`, `protected`, or
`internal` — because Polaron never infers access silently. A field is immutable unless you
mark it `mutable`; this is the reverse of most languages and it means that a field you
never reassign needs no annotation, while one you do reassign announces that fact.

Fields can be given a value in two places: inline at the point of declaration, or inside
a **constructor**. A constructor is introduced by the `constructor` keyword followed by
the class name and a parameter list; it runs once, when an instance is created, and its
job is to leave every field in a valid state. Inside any method or constructor, access
to a member is always written through `this.` — there is no implicit `this`, so
`this.balance` is a field access and `balance` alone would be an unknown name.

```polaron
public class Account {
    private mutable int balance;
    private int id = 1000;          // inline initializer

    public constructor Account(int opening) {
        this.balance = opening;     // reassignable: declared mutable
    }

    public method deposit(int amount) returns void {
        this.balance = this.balance + amount;
        return;
    }

    public method getBalance() returns int {
        return this.balance;
    }
}
```

A class has **exactly one** constructor, for the same reason it has one method per name:
Polaron has no overloading. Where another language would offer several, give the alternatives
distinct names as static factory methods, or take one constructor with the widest
parameter list.

The mirror image of a constructor is a **destructor**, written `destructor ~Name()
returns void`. It runs when an object's lifetime ends and is where you release whatever
the object owns — heap memory, file handles, and the like. Polaron has no garbage
collector; memory is managed manually, and the destructor is the hook that makes manual
management ergonomic. For an object that lives on the stack, the destructor fires
automatically when the enclosing scope exits (this is RAII, the same discipline C++
uses); for an object on the heap you trigger it with `delete`. The following program
prints `ctor`, then `hello`, then `dtor`, in that order, because the stack object `g`
is destroyed as `main` returns:

```polaron
public class Greeter {
    public constructor Greeter() {
        System.IO.Console.printf("ctor\n");
    }
    public method hello() returns void {
        System.IO.Console.printf("hello\n");
        return;
    }
    public destructor ~Greeter() returns void {
        System.IO.Console.printf("dtor\n");
    }
}

public class Main {
    public static method main(string[] args) returns void {
        Greeter g = new Greeter() on stack;
        g.hello();
        return;                     // ~Greeter() runs here
    }
}
```

An object is created with `new`, optionally followed by a placement clause: `on stack`
puts it in the current frame, and `on heap` allocates it (and requires a matching
`delete`). The placement is optional and defaults sensibly — a plain object defaults to
the stack — but spelling it out is good style while you are learning where each object
lives.

## 6.3 Methods and `this`

Instance methods are declared with the `method` keyword, a unique name, a parameter
list, and a mandatory `returns` clause naming the result type (`void` if there is none).
The `return` statement is required in a non-void method and optional in a void one.

Polaron forbids method overloading. Within a class, a method name is unique — you cannot
declare two methods called `add` that differ only in their parameters. This keeps
dispatch unambiguous and error messages precise; when you need variants, give them
different names (`addInt`, `addAll`) rather than relying on the compiler to pick by
signature. Because names are unique, every call site names exactly one method.

Every block requires braces and there is no shorthand: `if (x) return;` written without
braces is a syntax error. This uniformity means a method body always reads as a
sequence of brace-delimited statements.

```polaron
public class Rectangle {
    private int width;
    private int height;

    public constructor Rectangle(int w, int h) {
        this.width = w;
        this.height = h;
    }

    public method area() returns int {
        return this.width * this.height;
    }

    public method describe() returns void {
        System.IO.Console.println($"rectangle {this.width}x{this.height} = {this.area()}");
        return;
    }
}
```

Note how `describe` calls `this.area()`: one method invoking another on the same object
still goes through `this.`. The `$"..."` form is string interpolation, and `{...}`
splices an expression's value into the output.

## 6.4 Static Members

Some state and behavior belong to a class as a whole rather than to any single instance.
Marking a field or method `static` lifts it to the class level. A static field is
shared by every instance and exists for the whole run of the program; a static method
runs without a receiver. Both are addressed by class name — `Counter.count`,
`Counter.inc()` — never through an instance. Static state that changes over time must
still be declared `mutable`, exactly like an instance field.

```polaron
public class Counter {
    private static mutable int count;

    public static method inc() returns void {
        Counter.count = Counter.count + 1;
    }
    public static method get() returns int {
        return Counter.count;
    }
}

public class Main {
    public static method main(string[] args) returns void {
        Counter.inc();
        Counter.inc();
        Counter.inc();
        System.IO.Console.println($"count = {Counter.get()}");   // count = 3
        return;
    }
}
```

## 6.5 Value Semantics: Assignment Copies

This is the single most important rule to absorb about Polaron objects, and the one most
likely to surprise a Java programmer: **assignment is a deep copy.** When you write
`Account b = a;`, `b` becomes an independent duplicate of `a`, recursively copying every
field. Mutating `b` afterwards leaves `a` untouched. Passing a class value as a method
argument follows the same rule — the parameter is a fresh deep copy, so a method cannot
change the caller's object merely by mutating its parameter.

```polaron
Account a = new Account(100) on stack;
Account b = a;          // deep copy: b is a separate account
b.deposit(50);
// a.getBalance() is still 100; b.getBalance() is 150
```

When you genuinely want two names to refer to the *same* object — the sharing semantics
that references give you in Java — you ask for it explicitly with a pointer (`T*`) or a
reference (`T&`). These are the tools for sharing and for avoiding the cost of copying a
large object.

There are principled exceptions to the copy rule, and they all share one justification:
copying would be either meaningless or unsafe. Interface-typed and abstract-class-typed
values are always references, because such a value is necessarily some concrete subclass
whose true size is not known at the declaration point — copying it by the base's own
(often smaller) layout would truncate the object. `String` is immutable, so sharing its
buffer is observationally identical to copying it. And a Java-style enum constant is a
shared singleton whose identity must be preserved. For everything else — plain classes,
structs, records — assignment means copy.

## 6.6 Inheritance with `extends`

A class may extend exactly one base class using `extends`. Polaron has single inheritance;
a class inherits all of its base's fields and methods and may add its own. The
`protected` visibility exists precisely for this relationship: a `protected` member is
visible to the declaring class and its subclasses but not to unrelated code.

When a subclass is constructed, the base class's constructor runs first so that inherited
fields are initialized before the subclass touches them. If the base has a no-argument
constructor, this happens implicitly — you write nothing. When the base constructor
needs arguments, you forward them explicitly with a `super(...)` call as the first
action of the subclass constructor:

```polaron
public class Animal {
    protected int legs;
    public constructor Animal(int legs) {
        this.legs = legs;
    }
    public method legCount() returns int {
        return this.legs;
    }
}

public class Dog extends Animal {
    private int barks;
    public constructor Dog(int barks) {
        super(4);                   // forward 4 to Animal's constructor
        this.barks = barks;
    }
    public method describe() returns void {
        System.IO.Console.println($"legs = {this.legCount()} barks = {this.barks}");
    }
}
```

Here `Dog` inherits both the `legs` field and the `legCount()` method; `super(4)` tells
`Animal` how to initialize its part of the object, and the subclass then initializes its
own `barks`. If `Animal` had a parameterless constructor, `Dog` could omit `super`
entirely and the base constructor would still run.

## 6.7 Interfaces

An interface describes a capability as a set of method signatures without committing to
an implementation. A class declares that it provides that capability with `implements`,
and unlike class inheritance a class may implement several interfaces at once. Interface
methods are abstract by default — just a signature terminated by a semicolon — and the
implementing class supplies the body, marking it `override` because it is fulfilling an
inherited obligation.

```polaron
public interface Drawable {
    method describe() returns void;
}

public class Sprite implements Drawable {
    public override method describe() returns void {
        System.IO.Console.println("a sprite");
        return;
    }
}
```

An interface method may also carry a body, in which case it is a **default method**.
Classes that implement the interface inherit the default automatically and may override
it if they want different behavior. A default method can call the interface's other
(still-abstract) methods on `this`, and those calls dispatch virtually to whatever the
concrete class provides — so a default written once adapts to every implementer:

```polaron
public interface Greeter {
    method name() returns int;
    method greet() returns int {
        return this.name() + 100;   // default, built from the abstract name()
    }
}

public class Alice implements Greeter {
    public override method name() returns int { return 1; }
    // inherits the default greet() -> returns 101
}

public class Bob implements Greeter {
    public override method name() returns int { return 2; }
    public override method greet() returns int { return 999; }   // overrides the default
}
```

Because an interface can never be instantiated on its own — any value of interface type
is really an instance of some concrete class — interface-typed values are always
references, never copied. The same is true of abstract classes, discussed next.

## 6.7b `partial` classes and `deprecated` members

**`partial`** lets one class be declared in several parts, which may live in different files. The
compiler folds them into one class before anything else looks at it, so a part can use a field a
different part declared:

```polaron
public partial class Dog {
    private mutable int barks;
    public constructor Dog() { this.barks = 0; }
    public method bark() returns void { this.barks = this.barks + 1; }
}

// Elsewhere — another part of the same class, possibly another file.
public partial class Dog {
    public method count() returns int { return this.barks; }
}
```

Its use is separating generated code from hand-written code, and splitting a large type along a
seam that means something. It is not a licence to scatter a class across a project: every part must
carry `partial`, and the fold happens before analysis, so nothing about the resulting class differs
from one written in a single piece.

**`deprecated`** marks a declaration as on its way out. Every call site gets a compiler warning and
the code still runs:

```polaron
public deprecated static method oldWay(int x) returns int { return x * 2; }
```

That is the whole feature, and its value is the migration it makes possible: the replacement lands,
the old name keeps working, and every caller is told — by the compiler, at the exact line — without
anything breaking on the day of the change.

## 6.8 Abstract, Final, and Sealed

The `abstract` modifier expresses "incomplete on purpose." An abstract class cannot be
instantiated; it exists to be extended. An abstract method has no body — only a
signature — and forces every concrete subclass to supply one. A class with any abstract
method must itself be abstract. This lets you write a base type that defines a contract
(and possibly some shared, concrete helpers) while leaving the essential behavior to be
filled in below.

```polaron
public abstract class Shape {
    public abstract method area() returns int;   // no body; subclasses must provide it
}
```

At the opposite end, `final` closes a door. A `final` method cannot be overridden by any
subclass, and a `final` class cannot be extended at all. Use it when a piece of behavior
must not be redefined, or when a class is a leaf by design.

`sealed` sits between open and closed: `sealed class Shape permits Circle, Square` allows
exactly the listed classes to extend `Shape` and no others. A sealed hierarchy is a
closed, known set of subtypes, which is what lets the compiler check a `match` over it
for exhaustiveness — if you have handled every permitted case, no `default` arm is
required.

```polaron
public sealed abstract class Shape permits Circle, Square {
    public abstract method area() returns int;
}
public class Circle extends Shape {
    private int r;
    public constructor Circle(int r) { this.r = r; }
    public override method area() returns int { return this.r * this.r * 3; }
}
public class Square extends Shape {
    private int side;
    public constructor Square(int side) { this.side = side; }
    public override method area() returns int { return this.side * this.side; }
}
```

## 6.9 Virtual Dispatch and Polymorphism

Polymorphism is the payoff of the whole model: a variable typed as a base class or an
interface can hold any subtype, and a method call on it runs the *most-derived* override
for the object's real runtime type. Polaron implements this the classic way, with virtual
method tables (vtables). A class that participates in a hierarchy carries a hidden
vtable pointer as its first field; each concrete class has one vtable, laid out so that
every distinct virtual method name occupies a stable slot. A call through a base-typed
variable loads the function pointer from that slot and calls it indirectly, so the code
that runs is chosen by the object, not by the declared type of the variable.

Overriding is explicit and checked: you write `override` on the subclass method, and the
compiler verifies that a matching method really exists to override. Forgetting `override`
when you meant to override, or writing it when nothing matches, is an error rather than a
silent new method.

The compiler devirtualizes when it safely can. If a receiver's concrete class is known
to have no subclasses at this point in the program, the call is compiled as a direct
call with no vtable indirection — you get polymorphism's flexibility where you need it
and a plain call where you don't.

```polaron
public class Animal {
    public method speak() returns void {
        System.IO.Console.println("...generic animal");
        return;
    }
}
public class Dog extends Animal {
    public override method speak() returns void {
        System.IO.Console.println("woof");
        return;
    }
}
public class Cat extends Animal {
    public override method speak() returns void {
        System.IO.Console.println("meow");
        return;
    }
}

public class Main {
    public static method main(string[] args) returns void {
        Animal a = new Dog();   // static type Animal, runtime type Dog
        a.speak();              // -> woof
        Animal b = new Cat();
        b.speak();              // -> meow
        return;
    }
}
```

The canonical shape example ties inheritance, abstraction, interfaces, and virtual
dispatch together. `Shape` is an abstract class that implements the `Drawable`
interface; `Square` and `Circle` each override `area()` and `describe()`. A variable of
static type `Shape` calls the override belonging to the object it actually holds:

```polaron
public interface Drawable {
    method describe() returns void;
}
public abstract class Shape implements Drawable {
    public abstract method area() returns int;
}
public class Square extends Shape {
    private int side;
    public constructor Square(int s) { this.side = s; }
    public override method area() returns int { return this.side * this.side; }
    public override method describe() returns void {
        System.IO.Console.println($"Square area: {this.area()}");
        return;
    }
}
public class Circle extends Shape {
    private int radius;
    public constructor Circle(int r) { this.radius = r; }
    public override method area() returns int { return 3 * this.radius * this.radius; }
    public override method describe() returns void {
        System.IO.Console.println($"Circle area: {this.area()}");
        return;
    }
}

public class Main {
    public static method main(string[] args) returns void {
        Shape s1 = new Square(4);   // prints Square area: 16
        Shape s2 = new Circle(2);   // prints Circle area: 12
        s1.describe();
        s2.describe();
        return;
    }
}
```

## 6.10 Properties

A property is a field-like member whose reads and writes are mediated by code. To the
outside it looks like a field — `r.area`, `a.balance = 50` — but under the hood a getter
and/or setter runs. Properties use the soft keywords `get`, `set`, and `init` inside a
brace block on a typed member.

The simplest form is an **auto-property**, where you write only `get;` and `set;` and the
compiler synthesizes the backing storage. A property with `get; set;` is a readable,
writable field; one with `get; init;` is **init-only** — it may be assigned inside the
constructor but is immutable thereafter. A **computed** property provides a getter body
and no setter, deriving its value on each read rather than storing it:

```polaron
public class Rect {
    public int w { get; set; }              // auto-property: read/write
    public int h { get; init; }             // init-only: set in the ctor, then immutable
    public constructor Rect(int w, int h) {
        this.w = w;
        this.h = h;
    }
    public int area { get { return this.w * this.h; } }   // computed, get-only
}

// r.area is recomputed on each read; r.w = 10 goes through the setter
```

You can also write full custom bodies for both accessors, backing them with a private
field and running logic on the way in or out. Inside a setter, the incoming value is
available as `value`. This is how you validate, clamp, or transform:

```polaron
public class Temp {
    private mutable int celsius;
    public constructor Temp() { this.celsius = 0; }
    public int fahrenheit {
        get { return this.celsius * 9 / 5 + 32; }
        set { this.celsius = (value - 32) * 5 / 9; }
    }
}
// t.fahrenheit = 212 stores celsius = 100; reading t.fahrenheit yields 212
```

Properties are first-class members of the dispatch model. When a subclass overrides a
property, **both** the getter and the setter dispatch virtually, exactly as overridden
methods do: reading or writing the property through a base-typed variable runs the
most-derived accessor for the object's real type. A property is not a second-class
citizen that quietly bypasses polymorphism — it is a method pair wearing a field's
clothes.

### Bidirectional properties

The getter/setter pair above converts *one way each*. When a property is really two
representations of the same datum — Celsius/Fahrenheit, radians/degrees, bytes/kilobytes — a
**`bidirectional`** property expresses both conversions over a backing field, as a pair of
`X to Y:` rules. Reading computes the property from the field; assigning computes the field
from the property:

```polaron
public class Temperature {
    private mutable double celsius;
    public constructor Temperature(double c) { this.celsius = c; }

    public bidirectional double fahrenheit {
        celsius to fahrenheit: celsius * 9.0 / 5.0 + 32.0;
        fahrenheit to celsius: (fahrenheit - 32.0) * 5.0 / 9.0;
    }
}

Temperature* t = new Temperature(100.0) on heap;
double f = t.fahrenheit;     // reads celsius, converts -> 212.0
t.fahrenheit = 32.0;         // converts and stores -> celsius = 0.0
```

Each rule names the source and destination and gives the expression; the backing field and
the property name are both in scope inside the rules, so the two directions read as the plain
formulas they are.

## 6.11 Operator Overloading

A class can give meaning to the built-in operators when applied to its instances. You
declare an operator with the `operator` keyword followed by the operator symbol, a
parameter list, and a `returns` type. The most common case is a binary operator such as
`+`: `a + b` where `a`'s class defines `operator +` compiles to a call of that operator
with `b` as the argument.

```polaron
public class Vec3 {
    public mutable int x;
    public mutable int y;
    public mutable int z;
    public constructor Vec3(int x, int y, int z) {
        this.x = x; this.y = y; this.z = z;
    }
    public operator + (Vec3 other) returns Vec3 {
        return new Vec3(this.x + other.x, this.y + other.y, this.z + other.z) on heap;
    }
}
// Vec3 c = a + b;   ->   a.operator+(b)
```

Beyond binary arithmetic and comparison operators, Polaron also lets you overload:

- **Unary increment/decrement**, `operator ++ ()` and `operator -- ()`, taking no
  parameters. `c++` reassigns `c` to the operator's result.
- **Indexing for reads**, `operator [] (int i) returns T`, so `t[i]` calls it.
- **Indexing for writes**, `operator []= (int i, T v) returns void`, so `t[i] = v`
  routes the assigned value through it.

```polaron
public class Pair {
    private mutable int a;
    private mutable int b;
    public constructor Pair() { this.a = 0; this.b = 0; }
    public operator [] (int i) returns int { return i == 0 ? this.a : this.b; }
    public operator []= (int i, int v) returns void {
        if (i == 0) { this.a = v; } else { this.b = v; }
    }
}
// p[0] = 10;  -> operator[]= ;  p[0]  -> operator[]
```

## 6.12 Enums

An enum names a fixed set of constants. In its simplest form an enum is a list of names,
and each name is a distinct ordinal value starting at zero. You refer to a constant as
`EnumName.CONSTANT`, compare enum values with `==` and `!=`, and use them in
interpolation, where a simple enum prints as its ordinal.

```polaron
public enum Color {
    RED,        // 0
    GREEN,      // 1
    BLUE        // 2
}
// Color.GREEN compares and prints as 1
```

Every enum automatically gains a small set of built-in members: `EnumName.count()`
returns how many constants there are, `EnumName.values()` returns an array of all
constants in declaration order (handy to iterate with `foreach`), `EnumName.random()`
returns an arbitrary constant, and `EnumName.parse(name)` returns an `Option` of the
constant matching a name.

```polaron
public enum Color { RED, GREEN, BLUE }

public class Main {
    public static method main(string[] args) returns void {
        System.IO.Console.println($"count = {Color.count()}");   // 3
        mutable int sum = 0;
        for (int c in Color.values()) {
            sum = sum + c;                                        // 0 + 1 + 2
        }
        System.IO.Console.println($"sum = {sum}");               // 3
        return;
    }
}
```

Enums can be far richer than a list of ordinals. In the **Java-style** form, each
constant carries constructor arguments, and the enum declares fields, a constructor, and
methods just like a class. Every constant is a single shared singleton instance,
constructed with its arguments — because the constants are shared by identity, they are
reference values and are never copied. This lets an enum bundle data and behavior with
each named value:

```polaron
public enum Planet {
    EARTH(10, 2),
    MARS(30, 3);

    private final int mass;
    private final int radius;

    public constructor Planet(int mass, int radius) {
        this.mass = mass;
        this.radius = radius;
    }

    public method density() returns int {
        return this.mass / this.radius;
    }
}

public class Main {
    public static method main(string[] args) returns void {
        System.IO.Console.println($"earth = {Planet.EARTH.density()} mars = {Planet.MARS.density()}");
        // earth = 5, mars = 10
        return;
    }
}
```

## 6.13 Field Layout: `affinity`

By default a class's fields are laid out in declaration order. For data-oriented code — where
a tight loop touches a few fields of every object, every frame — you often want the *hot*
fields packed together so a pass pulls in fewer cache lines, and the *cold* ones (debug ids,
bookkeeping) pushed to the end. `affinity` blocks express that intent without hand-splitting
the class into parallel arrays:

```polaron
public class Particle {
    public affinity cold {
        mutable int id;
        mutable int spawnFrame;
    }
    public affinity hot {
        mutable float x;
        mutable float y;
        mutable float vx;
        mutable float vy;
    }
    // The emitted object is { vtable, x, y, vx, vy, id, spawnFrame } -- hot first, regardless
    // of the order the blocks appear in.
}
```

Only the *layout* changes; the fields, their access, and the class's semantics are exactly as
if they were declared plainly. Affinity is inherited safely: a subclass's object still begins
with exactly the base's layout, and only the subclass's own fields are grouped.

With classes, inheritance, interfaces, virtual dispatch, properties, operators, enums, and
## 6.14 Layouts: an interface for memory

An interface says what a type **does**. A layout says how a type **arranges itself**. Those are
separate questions, so a layout is not a fourth species beside `struct`, `record` and `union` — it
crosses them:

```polaron
public layout ThreeToALine {
    onArrange {
        itself.fitWithin(20 bytes);
        itself.refuse("a beast must stay three to a cache line");
    }
}

public struct Beast implements ThreeToALine {
    public mutable float x;
    public mutable float y;
    public mutable int   herd;
    public mutable short stamina;
    public mutable short age;
}
```

`implements` needed no new grammar for this. A struct cannot `extends` — it has no vtable to inherit
through — but implementing was never inheriting, which is why the door was already open.

**Implementing a layout authorizes the compiler to order the fields**, and that is the point of the
feature rather than a side effect. A check that only refuses is a guard against a problem that could
have been solved; here it can be solved, because the compiler knows every size and alignment and
Polaron exposes no offsets. Fields are ordered widest-first, so the padding a declaration order pays
for simply is not spent. The build refuses only what could not be made to fit, and says so:

```
error: `Tick` is arranged by `Packed`, which fits it within 12 bytes -- it measures 16.
       The fields were already ordered widest-first to make it fit, so reordering them by
       hand will not help: something has to be narrower, or leave
       (a tick must stay five to a cache line)
```

### What a layout is not

A layout **establishes no contract** in the `requires`/`ensures` sense. A contract survives into the
binary and can fail while the program runs; a layout is consumed entirely by the compiler, and a
layout that cannot be satisfied means there is no program at all.

Nothing inside `onArrange` names a library type — not even the byte unit, which the compiler reads
directly. So layouts hold in freestanding by construction, rather than by a rule forbidding the
library. Inside the hook, `itself` is the arrangement being decided.

A layout applies to value aggregates because only they own a layout at the point of use: where a
`Beast` is used, twenty bytes are there. Where a class is used, a pointer is — and the vtable slot at
the front of the instance belongs to the compiler, not to the author.

**Modifiers.** A layout may be `public`/`private`/`internal`, `final` (it cannot be refined), or
`sealed ... permits` (only the listed types may implement it). `abstract` and `comptime` are refused
with a reason: a layout is already both. So are `partial`, the ownership modifiers, and `heap`.

For conditions that are *not* about a type's size — a table length, a protocol constant, arithmetic
that has to come out a certain way — use [`demand`](10-metaprogramming-and-prefixes.md) instead.

---

## 6.15 Transformers: a transformation relation between classes

A **transformer** is a construct that establishes a **transformation relation between two classes**.
It answers a question none of the other declarations do:

> `class` says what a thing **is**.
> `interface` says what it **must be able to do**.
> `layout` says how it **arranges itself**.
> **`transformer` says what a type gains — and how it relates to the other types that gain the same.**

A transformer is a noun. It has a name, you can point at it, and it is **never instantiated**: it
produces nothing you can hold. What it produces is what the types that apply it gain.

### What lives inside one

Two things: **variables**, and **transformable methods**.

A transformable method is an abstract method that may nevertheless carry a **default implementation
inside the transformer itself**, and that implementation can still be swapped for one belonging to a
class. That combination has no equivalent among ordinary methods, and it is why the word is
different: in Polaron these are **procedures**.

```
A METHOD's signature is fixed where it is declared.
A PROCEDURE's signature is completed at the type that applies it.
```

Inside a transformer, `itself` is *the type that will apply this* — a type that does not exist yet. A
procedure returning `itself` returns a different type in every type that applies it. That is what
"abstract, but with an implementation" means here: the body exists, but it is not code for any type
yet. It is not floating behaviour — **its subject exists, it just does not know its name.**

### The two operations: application and call

A transformer is **not implemented and not extended. It is applied.**

```polaron
public class Dog applies TDescriber { }
```

**Applying a transformer does not mean applying all of its procedures** — only the ones the class
chooses. Supplying a class's own body for a procedure is *also* called applying — applying that
procedure:

```polaron
public class Dog applies TDescriber {
    public procedure describe() returns string { return "a dog"; }
}
```

When a procedure is applied, its implementation changes — whether or not the transformer defined one.
**An applied procedure overrides the transformer's own body**, and there may be exactly **one
application per procedure per class**: a class applying `TDescriber` may apply `describe` once, and
only once.

Once applied, the procedure **belongs to the class**, and **its visibility travels with it**.

> The visibility written on a procedure is **not** about who may reach it inside the transformer —
> nothing can reach into a transformer at all. It is the visibility the member **enters the applying
> class with**.

Procedures are therefore **private by default**: applying a transformer is equipment, not a promise
made to the outside world, and the only way to get at a procedure at all is to apply the transformer
that holds it.

A transformer cannot be instantiated, so there is no receiver to write to the left of a dot. That is
what the second operation is for — **call**:

```polaron
public class Cat applies TDescriber {
    public procedure describe() returns string {
        return "[" + call TDescriber.describe() + "]";   // the transformer's own body
    }
}
```

`call T.p()` reaches the **transformer's** procedure directly, without going through the application.
So a class can use both: the applied procedure that now belongs to it, *and* the transformer's
original, which its own application would otherwise have covered over. Calling is **reserved to the
class that applied the transformer** — a transformer's procedure cannot be called from outside it.

### The relation

When two or more classes apply the same transformer **and the same procedure**, those classes
establish a transformation between themselves. It comes in three shapes:

| shape | meaning | declared with |
|---|---|---|
| **unidirectional, single** | `A → B` | nothing — it emerges from the pair |
| **unidirectional, multiple** | `A → B, C, D` | `collective` |
| **bidirectional** | `A ↔ B` | `mutual` |

Nothing declares "A converts to B". Two types apply the same transformer and implement its
procedures, and **the transformation emerges from the pair** — the direction too: one side
implemented is one way, both sides is both. What does *not* emerge is the **obligation** to write the
other side, and that is the whole of what those two words do.

`collective` is the multiple case, and it brings its own economy: the conversions you write are
edges, and the compiler completes the graph along them. Three classes in a cycle are three procedures
and six conversions. The rules that keep it honest are in the specification, §32.12.1 — no path is an
error, and two equally short paths is an error too, because a composed conversion may never pick one.

This is a **safe way to turn objects into other objects**, or something of one object into something
of another: a route for an `A` to become a `B` **without necessarily converting vtables**.

### `entrusts`: consenting to be built from outside

`applies` says *"I gain this equipment"*. **`entrusts`** is a different and stronger promise, made by
the type on the receiving end of a conversion: it hands the transformer the right to **construct**
this type, filling its storage field by field — private ones included.

```polaron
public transformer TConverter {
    public procedure into<each Other>() returns Other;
}

public class Metres applies TConverter {
    private mutable int whole;
    public procedure into<Feet f>() returns Feet {      // `f` is bound, and this fills it
        f.whole = itself.whole * 3;
        f.fraction = 0;
        return f;
    }
}

public class Feet entrusts TConverter {                 // "you may assemble me"
    private mutable int whole;
    private mutable int fraction;
}
```

Only the type itself can agree to that, because only it knows what its invariants are — which is why
`entrusts` sits on `Feet` and not on `Metres`. What comes back is an ordinary object; nothing about
it records that it was built from outside.

The consent buys an obligation, and the compiler enforces it: **the assembly must be complete.**
Leaving `f.fraction` unassigned above is an error, checked with exactly the dataflow a constructor
already passes — same map, same join at a branch. It matters more than an uninitialised local
would: a local reads stack garbage, which is usually absurd and fails loudly, while an unassigned
field reads whatever was last in that storage, so the wrong value is plausible, stable, and
everything downstream works perfectly with it.

### The cost

**Transformers are resolved at compile time, so they create no vtables.** A transformer is expanded
by the same machinery that expands a generic, running over another list — no vtable, no allocation,
no indirection. What you pay is exactly the code you would have written by hand, which is what makes
the feature usable in a kernel without thinking twice.

### Naming

`T` + stem + `er` — `TDescriber`, never `Describe`. A transformer is **the coupling between two types
and neither of them**: an electrical transformer has two windings and is not either winding, so it is
named for the agent of the relation. The leading `T` says at a glance which of the three list-like
clauses on a class line you are reading — `extends` is identity, `implements` is obligation, `applies`
is equipment. The compiler warns and *generates* the suggested name rather than only demanding one.

---

field-layout hints in hand, you have the whole object model Polaron offers. The recurring themes —
explicit over implicit (visibility, `this.`, `override`), value semantics with opt-in
sharing, and immutability by default — are worth keeping in mind as you read the
chapters that follow, because the rest of the language is built on top of exactly these
objects.
