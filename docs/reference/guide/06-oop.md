# 6. Object-Oriented Programming

LDP3 is an object-oriented language in the strict sense: object orientation is not a
style you may adopt but the only way to organize code. There are no free functions, no
top-level variables, and no bare statements floating outside a type. Every piece of
behavior you write is a method that belongs to a class, and every piece of state is a
field of some object or a `static` member of some class. This chapter explains how
classes are built, how they relate to one another through inheritance and interfaces,
how method calls are resolved at runtime, and how the finishing touches — properties,
operator overloading, and enums — round out the model.

If you come from Java or C#, most of this will feel familiar, but LDP3 makes several
deliberate choices that a newcomer must internalize early: assignment copies by default
(so class variables behave like values, not references), member access always goes
through `this.`, mutability is opt-in rather than the default, and overriding an
inherited member is never accidental — you must say `override`.

## 6.1 Everything Lives in a Class

An LDP3 program is a nested hierarchy: a `program` declaration names the compilation
target, a `bundle` groups related code, a `namespace` carves out a naming scope, and
classes live inside namespaces. Execution begins in a `static` method named `main`
that takes a `string[]` and returns `void`. Because there is nowhere else to put code,
even the smallest program is a class:

```ldp3
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
`internal` — because LDP3 never infers access silently. A field is immutable unless you
mark it `mutable`; this is the reverse of most languages and it means that a field you
never reassign needs no annotation, while one you do reassign announces that fact.

Fields can be given a value in two places: inline at the point of declaration, or inside
a **constructor**. A constructor is introduced by the `constructor` keyword followed by
the class name and a parameter list; it runs once, when an instance is created, and its
job is to leave every field in a valid state. Inside any method or constructor, access
to a member is always written through `this.` — there is no implicit `this`, so
`this.balance` is a field access and `balance` alone would be an unknown name.

```ldp3
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

The mirror image of a constructor is a **destructor**, written `destructor ~Name()
returns void`. It runs when an object's lifetime ends and is where you release whatever
the object owns — heap memory, file handles, and the like. LDP3 has no garbage
collector; memory is managed manually, and the destructor is the hook that makes manual
management ergonomic. For an object that lives on the stack, the destructor fires
automatically when the enclosing scope exits (this is RAII, the same discipline C++
uses); for an object on the heap you trigger it with `delete`. The following program
prints `ctor`, then `hello`, then `dtor`, in that order, because the stack object `g`
is destroyed as `main` returns:

```ldp3
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

LDP3 forbids method overloading. Within a class, a method name is unique — you cannot
declare two methods called `add` that differ only in their parameters. This keeps
dispatch unambiguous and error messages precise; when you need variants, give them
different names (`addInt`, `addAll`) rather than relying on the compiler to pick by
signature. Because names are unique, every call site names exactly one method.

Every block requires braces and there is no shorthand: `if (x) return;` written without
braces is a syntax error. This uniformity means a method body always reads as a
sequence of brace-delimited statements.

```ldp3
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

```ldp3
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

This is the single most important rule to absorb about LDP3 objects, and the one most
likely to surprise a Java programmer: **assignment is a deep copy.** When you write
`Account b = a;`, `b` becomes an independent duplicate of `a`, recursively copying every
field. Mutating `b` afterwards leaves `a` untouched. Passing a class value as a method
argument follows the same rule — the parameter is a fresh deep copy, so a method cannot
change the caller's object merely by mutating its parameter.

```ldp3
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

A class may extend exactly one base class using `extends`. LDP3 has single inheritance;
a class inherits all of its base's fields and methods and may add its own. The
`protected` visibility exists precisely for this relationship: a `protected` member is
visible to the declaring class and its subclasses but not to unrelated code.

When a subclass is constructed, the base class's constructor runs first so that inherited
fields are initialized before the subclass touches them. If the base has a no-argument
constructor, this happens implicitly — you write nothing. When the base constructor
needs arguments, you forward them explicitly with a `super(...)` call as the first
action of the subclass constructor:

```ldp3
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

```ldp3
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

```ldp3
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

## 6.8 Abstract, Final, and Sealed

The `abstract` modifier expresses "incomplete on purpose." An abstract class cannot be
instantiated; it exists to be extended. An abstract method has no body — only a
signature — and forces every concrete subclass to supply one. A class with any abstract
method must itself be abstract. This lets you write a base type that defines a contract
(and possibly some shared, concrete helpers) while leaving the essential behavior to be
filled in below.

```ldp3
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

```ldp3
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
for the object's real runtime type. LDP3 implements this the classic way, with virtual
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

```ldp3
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

```ldp3
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

```ldp3
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

```ldp3
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

```ldp3
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

```ldp3
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

Beyond binary arithmetic and comparison operators, LDP3 also lets you overload:

- **Unary increment/decrement**, `operator ++ ()` and `operator -- ()`, taking no
  parameters. `c++` reassigns `c` to the operator's result.
- **Indexing for reads**, `operator [] (int i) returns T`, so `t[i]` calls it.
- **Indexing for writes**, `operator []= (int i, T v) returns void`, so `t[i] = v`
  routes the assigned value through it.

```ldp3
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

```ldp3
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

```ldp3
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

```ldp3
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

```ldp3
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
field-layout hints in hand, you have the whole object model LDP3 offers. The recurring themes —
explicit over implicit (visibility, `this.`, `override`), value semantics with opt-in
sharing, and immutability by default — are worth keeping in mind as you read the
chapters that follow, because the rest of the language is built on top of exactly these
objects.
