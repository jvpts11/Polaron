# 4. Values & the Type System

Every value a LDP3 program manipulates has a type, and that type is known at
compile time. There is no dynamic typing, no "any", and no silent coercion that
quietly reinterprets your data behind your back. The compiler knows the exact
shape and size of every value before the program ever runs, and it uses that
knowledge to reject whole classes of mistakes — mixing a 32-bit integer with a
64-bit one without saying so, letting a `null` slip into a value that promised
never to be null, indexing past the end of an array — while the program is still
on your screen rather than in your users' hands.

This chapter is a tour of the values you can build. We start with the primitive
types that map directly onto machine registers, work through literals and the
rules that govern how numbers convert into one another, and then climb up into
the composite types — records, structs, unions, enums, catalogs — that let you
give a name and a shape to your own data. Along the way we cover the two string
types, the `nullable` opt-in, arrays, local type inference with `var`, generics
and their variance, and finally casting and LDP3's promise that a cast never
produces undefined behavior.

A recurring theme is worth stating up front, because it colors every example
that follows: **assignment in LDP3 is a deep copy, not a shared reference.**
Writing `b = a` gives `b` its own independent copy of everything `a` holds. When
you genuinely want two names to point at the same object, you say so explicitly
with a pointer (`T*`) or a reference (`T&`). Keep this in mind — it is one of the
language's load-bearing decisions, and it applies uniformly to primitives,
structs, records, and full classes alike.

---

## 4.1 The primitive types

Primitives are the atoms: fixed-size values that live in registers or on the
stack and carry no hidden machinery. LDP3 draws a deliberate line between the
*normal* names you use in everyday application code and the *bit-counted* names
reserved for freestanding, close-to-the-metal work.

### Integers

In **normal mode** — which is to say, ordinary applications, the mode you are in
unless you explicitly declare a program `freestanding` — the integer types wear
names that describe their role rather than their exact bit width. The idea is
that most of the time you should not have to think about whether an integer is
16 or 32 bits; you just want "an integer".

| Type    | Bits | Signed? | Range (approx.)                         |
|---------|------|---------|-----------------------------------------|
| `byte`  | 8    | signed  | −128 … 127                              |
| `short` | 16   | signed  | −32 768 … 32 767                        |
| `int`   | 32   | signed  | −2.1 billion … 2.1 billion              |
| `long`  | 64   | signed  | −9.2×10¹⁸ … 9.2×10¹⁸                     |
| `ubyte` | 8    | unsigned| 0 … 255                                 |
| `ushort`| 16   | unsigned| 0 … 65 535                              |
| `uint`  | 32   | unsigned| 0 … 4.29 billion                        |
| `ulong` | 64   | unsigned| 0 … 1.8×10¹⁹                             |

`int` is the workhorse — 32-bit and signed — and is what you reach for by
default. The unsigned family (`ubyte` … `ulong`) is genuinely unsigned: it wraps
and compares as an unsigned quantity, not as a signed one wearing a disguise.

```ldp3
int    count   = 42;
long   fileSize = 9000000000L;
ubyte  channel  = 200;      // fits in 0..255
ushort port     = 8080;
```

There is also `address`, a raw pointer-sized integer (64-bit on the current
target). It exists for low-level and freestanding code that needs to treat a
memory address as a number; you will rarely see it in application code.

`address` sits in the integer family so that arithmetic on it works, but it does
**not** convert to or from the other integers on its own. Making an address out of
a number is how a program reads memory nobody gave it, so the conversion is written
down:

```ldp3
mutable long n = 4096;
address a = n;                  // error: an address is not a 64-bit integer
address a = cast<address>(n);   // ...unless you say so
```

Freestanding code is exempt, and not as a concession: on bare metal, making an
address out of an integer *is* the work — the memory-mapped register at `0xB8000`
is a number until you say otherwise, and no allocator is going to hand you the
address instead.

### The freestanding-only bit-counted names

You may have seen names like `int32` or `uint8` in other systems languages, and
LDP3 does have them — but **only in freestanding mode.** The bit-counted family

```
int8   int16  int32  int64
uint8  uint16 uint32 uint64
float32 float64
```

exists because when you are writing a kernel, a device driver, or a wire-format
parser, the exact number of bits is part of the contract and hiding it would be
a lie. In normal mode, however, using any of these names is a **compile-time
error** — the compiler will point you at the normal-mode equivalent:

```ldp3
int32 x = 5;   // ERROR in normal mode:
               // "type 'int32' exists only in freestanding mode; use 'int'"
```

The mapping is exact: `byte`=int8, `short`=int16, `int`=int32, `long`=int64, and
likewise for the unsigned family and for `float`=float32, `double`=float64. The
two naming schemes describe the same machine types; they differ only in which
mode is allowed to spell them. This chapter uses the normal names throughout.

### Floating point

Normal mode offers four floating-point widths:

| Type         | Bits | Notes                                    |
|--------------|------|------------------------------------------|
| `smallfloat` | 16   | half precision                           |
| `float`      | 32   | single precision — the common choice     |
| `double`     | 64   | double precision                         |
| `quadruple`  | 128  | quad precision                           |

Note the crucial detail that trips up newcomers from other languages: in LDP3,
**`float` is 32 bits and `double` is 64 bits.** They are distinct types, and one
does not silently become the other. The bit-counted aliases `float32` and
`float64` are, again, freestanding-only.

```ldp3
float  ratio = 0.5f;      // 32-bit
double pi    = 3.14159;   // 64-bit
```

### `boolean`, `char`, and `void`

Three more primitives round out the set:

- **`boolean`** holds `true` or `false`. Conditions accept boolean expressions,
  and the language also permits truthy/falsy testing in conditions.
- **`char`** is a single character. It may be written with single or double
  quotes — `'a'` and `"a"` both denote a `char` — though the samples and this
  guide favor single quotes to keep `char` visually distinct from strings.
- **`void`** is the absence of a value; it appears only as the return type of a
  method that produces no result.

```ldp3
boolean done = false;
char    grade = 'A';

public method greet() returns void {
    System.IO.Console.println("hi");
    return;
}
```

---

## 4.2 Literals and literal suffixes

Integer literals may be written in several bases, and an underscore may be used
freely as a digit separator for readability — it has no effect on the value.

```ldp3
int decimal = 1_000_000;
int hex     = 0xFF;        // 255
int binary  = 0b1010;      // 10
long big    = 100L;        // the L suffix makes it a long
```

Floating-point literals default to `double`; the `f` suffix makes one a `float`
instead:

```ldp3
double e  = 2.71828;   // double by default
float  pi = 3.14f;     // 32-bit because of the f suffix
```

### The `m` suffix: `Decimal`

The suffix `m` (or `M`) produces a value of the primitive **`Decimal`** type — a
128-bit fixed-point number carrying eighteen fractional digits. `Decimal` exists
for money and any other domain where the rounding drift of binary floating point
is unacceptable. Because it is fixed-point, `0.1m + 0.2m` is exactly `0.3m`, not
the notorious `0.30000000000000004` you would get from `double`.

```ldp3
Decimal price = 19.99m;
Decimal tax   = 1.50m;
Decimal total = price + tax;   // exact: 21.49m
```

### Size suffixes and user-defined literal suffixes

LDP3 has no dedicated syntax for "kilobytes" or "milliseconds". Instead it offers
a single general mechanism — the `comptime literal` function — from which such
suffixes are built in the standard library and can be built by you. A `comptime
literal` function takes exactly one argument (the literal it follows) and is
evaluated entirely at compile time, so the suffix costs nothing at runtime.

The standard library's `System.Memory.Units` namespace provides six size
suffixes that all return a `ByteSize`:

```ldp3
import System.Memory.Units.kilobytes;

region cache = itself.allocate(64 kilobytes);   // expands to kilobytes(64)
```

The expression `64 kilobytes` is rewritten by the compiler into the call
`kilobytes(64)`, which — being `comptime` — folds to a constant `ByteSize`
before the program runs. The available suffixes are `bytes`, `kilobytes`,
`megabytes`, `gigabytes`, `terabytes`, and `exabytes`. Because the result is a
distinct `ByteSize` struct rather than a bare `int`, an API that wants a size can
demand exactly `ByteSize` and thereby refuse a raw, unit-less integer — you
cannot accidentally hand `1024` to something expecting `1024 bytes`. Defining
your own suffixes (say, `seconds` or `degrees`) works the same way; see the
memory chapter for the full rules.

### Numeric coercion — there is (almost) none

This is the rule that most distinguishes LDP3's arithmetic from C's: **there is
no implicit numeric promotion.** Converting between two integer widths, or
between integer and floating point, requires an explicit `cast<T>` (covered in
§4.12). The compiler will not quietly widen a `short` to an `int` for you, nor
truncate a `long` into an `int`.

```ldp3
long  total  = 5000000000L;
int   narrow = cast<int>(total);   // explicit narrowing required
double d     = cast<double>(narrow);
```

The one convenience the language does grant is for **compile-time integer
literals**: a literal that provably fits its target coerces without a cast,
because the value is known and the fit is provable.

```ldp3
byte  b = 5;      // OK: 5 fits in a byte
short s = 300;    // OK: 300 fits in a short
byte  x = 999;    // ERROR: 999 does not fit in a byte
```

Nothing about this applies to *variables*; only literals whose value the compiler
can see get this treatment.

### Overflow: a defined wrap by default

By default, integer arithmetic that overflows **wraps** with two's-complement
semantics — the zero-overhead choice. Crucially, this wrap is *defined behavior*,
not the undefined behavior C leaves it as, so an overflow can never be steered into
memory corruption; it just produces the wrapped value. When you want overflow to be
an **error** instead, wrap the expression in `checked(...)`, and signed `+`, `-`,
and `*` trap deterministically on overflow. For per-operation control, every integer
type carries explicit methods:

```ldp3
int fast = a + b;              // defined two's-complement wrap, no overhead (the default)
int safe = checked(a * b);     // signed overflow here traps deterministically
int a = x.wrappingAdd(y);      // explicit wrap
int b = x.saturatingAdd(y);    // clamps to the type's MIN/MAX
int c = x.uncheckedAdd(y);     // wrap, no check
```

The full family covers add/sub/mul (and div where meaningful) under each policy.
(Unsigned arithmetic, and all arithmetic in freestanding mode, always wraps.)

---

## 4.3 `String` versus `string`

LDP3 has two string types, and the capital letter carries real meaning.

- **`String`** (capital S) is the **immutable** string class. Once built, its
  contents never change; any "modification" produces a fresh `String`. Because it
  can never change underneath you, a `String` is safe to share freely — no copy
  is forced on assignment or on passing it to a method.
- **`string`** (lowercase) is the **mutable** string type, meant for building up
  or editing text in place.

Reach for `String` by default; reach for `string` when you are assembling text
incrementally and mutation is the point.

```ldp3
String greeting = "hello";     // immutable
string builder  = "";          // mutable, to be appended to
```

### String interpolation with `$"..."`

Prefixing a string literal with `$` turns `{ }` into an interpolation hole: the
expression inside is evaluated and its textual form spliced into the result.
Without the `$`, braces are just ordinary characters.

```ldp3
String name = "Ada";
int    age  = 36;
String msg  = $"Hello {name}, you are {age} years old";
String calc = $"Total: {price * quantity}";
String fmt  = $"Pi is {pi:0.00}";       // :format spec after a colon
```

A hole may contain any expression, not merely a variable, and an optional format
specifier follows a colon (`{pi:0.00}`). Interpolation is a first-class part of
the `String` machinery and reads far more clearly than manual concatenation.

---

## 4.4 `nullable` types

By default **no type in LDP3 can hold `null`.** A variable of type `Dog` always
refers to an actual `Dog`; the possibility of "no dog" simply does not exist for
it. If you need that possibility, you opt in with the `nullable` modifier:

```ldp3
Dog          rex = null;   // ERROR: Dog is non-nullable
nullable Dog rex = null;   // OK: nullable opts the type into null
```

The enforcement rule is deliberately simple and lives entirely **at assignment
boundaries.** A `null`, or a value that is itself `nullable`, may not flow into a
non-nullable target — whether that target is a variable, a field, a parameter, or
a return value. You decide, at each declaration, whether `null` is a legal value
there; the compiler holds you to it.

```ldp3
nullable Dog rex = maybeDog();
Dog          d  = rex;     // ERROR: nullable cannot flow into non-nullable
nullable Dog r2 = rex;     // OK: nullable -> nullable
```

What LDP3 deliberately does **not** have is a flow-sensitive narrowing analysis.
There is no "if you checked it for null on line 3, the compiler treats it as
non-null on line 4", no force-unwrap operator, and no borrow-checker-style
tracking. That machinery is exactly the complexity the language chose to avoid.

So what happens if you dereference a `nullable` that turns out to be `null` at
runtime? You get a **deterministic trap** — a clean, defined program halt with a
message — never undefined behavior and never a silent read through address zero.
This is consistent with LDP3's broader no-UB principle: dereferencing a nullable
is *allowed* (the compiler inserts a null check on the access), and if the value
is null the program stops predictably instead of corrupting memory. A
non-nullable value, by construction, can never be null, so dereferencing it costs
nothing extra. Comparing against `null` with `==` or `!=` is always permitted.

```ldp3
nullable Dog d = maybeDog();
int a = d.bark();          // allowed; traps deterministically if d is null
if (d != null) { }         // comparison is always fine
```

---

## 4.5 Arrays

Arrays in LDP3 are **dynamic and heap-allocated**. You create one with
`new T[n]()`, which allocates space for `n` elements on the heap and
zero-initializes them. Elements are read and written with the familiar `a[i]`
syntax, the current length is read back with `a.length()`, and the array is
released with `delete`.

```ldp3
int[] nums = new int[10]();          // ten zeroed ints on the heap
for (mutable int i = 0; i < nums.length(); i++) {
    nums[i] = i * i;
}
int first = nums[0];
delete nums;
```

Under the hood an array is a block laid out as a 64-bit length header followed by
the elements, with the array value being a pointer to that block; `length()`
simply reads the header. Every index is **bounds-checked**: an access outside
`0 … length-1` traps deterministically rather than wandering into adjacent
memory. A single unsigned comparison catches both negative indices and indices
past the end, so the check is cheap and there is no undefined behavior to exploit.

---

## 4.6 `var`: type inference for locals

Inside a method body you may write `var` and let the compiler infer the type from
the initializer. This is a convenience for locals **only** — fields, parameters,
and return types always require an explicit type, because those form the
published surface of a class and should never leave a reader guessing.

```ldp3
public method process() returns void {
    var dogs = new ArrayList<Dog>() on heap;   // inferred ArrayList<Dog>
    var n    = 42;                              // inferred int
}

public class Foo {
    var x = 5;                       // ERROR: a field needs an explicit type
    public method bar(var p) { }     // ERROR: a parameter needs an explicit type
}
```

Two related rules are worth remembering here. First, **immutability is the
default**: `var n = 42;` gives you an immutable `n`, and reassigning it is an
error unless you wrote `mutable var n = 42;`. Second, **shadowing is forbidden** —
you may not declare a variable that hides another of the same name in an
enclosing scope.

---

## 4.7 `record`

A `record` is an immutable data carrier defined by its primary constructor
parameters, which *are* its fields. Records are ideal for the small, value-like
bundles of data — points, coordinates, small results — that you pass around but
never mutate.

```ldp3
public record Point(int x, int y) {
    public method sum() returns int { return this.x + this.y; }
}

Point p = new Point(3, 4);
Point q = new Point(3, 4);
boolean same = p.equals(q);    // true — equality is by value
```

Records come with strong guarantees baked in. They are always immutable
(`mutable` is rejected outright). The compiler auto-generates `equals`,
`hashCode`, and `toString` from the parameters, so two records with equal fields
compare equal without you writing a line. They are implicitly `final` and cannot
be extended, though they *may* implement interfaces and *may* carry methods and
constants. What they may not do is add fields beyond the primary-constructor
parameters, and they cannot hold a `persistent`.

---

## 4.8 `struct` (and bit fields)

A `struct` is a **mutable value object** of a fixed, compile-time-known size. Like
a record it is copied on assignment and cannot participate in inheritance, but
unlike a record it is mutable and does not auto-generate `equals`/`hashCode`.
Structs are the right tool for small, mutable aggregates whose layout you care
about — a vector, a color, a packet header.

```ldp3
public struct Vec3 {
    public mutable float x;
    public mutable float y;
    public mutable float z;

    public constructor Vec3(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
}
```

Because a struct is a value, two struct variables never alias: assigning one to
another copies every field, exactly like the deep-copy rule for classes. A struct
may implement interfaces.

### Bit fields

A struct field may declare a bit width with `field : N`, constraining it to `N`
bits. This is essential for hardware registers and wire formats where individual
fields occupy sub-byte spans.

```ldp3
public struct Flags {
    public mutable int a : 4;    // 0..15
    public mutable int b : 4;
    public mutable int c : 12;   // 0..4095
}
```

In the current implementation the constraint is enforced as **value masking**: a
value that exceeds `N` bits is truncated to `N` bits on store (so writing `20`
into a 4-bit field stores `4`). Physically packing the fields into a tighter
struct layout is a planned refinement; the observable semantics — the masking —
are in place today.

---

## 4.9 `union`

A `union` is C-style: all of its fields occupy the **same** storage, so writing
one field and reading another reinterprets the same bits. This is a deliberately
low-level tool, most at home in manual-memory and systems code where you need to
view one block of memory through more than one lens.

```ldp3
public union Value {
    int   asInt;
    float asFloat;
}

Value v = new Value();
v.asFloat = 1.5;
int bits = v.asInt;     // the bit pattern of 1.5f, reinterpreted as int
```

Because every field aliases the same memory, it is your responsibility to know
which interpretation is currently valid — the compiler does not track it for you.

---

## 4.10 `enum` and `catalog`

### Simple enums

The simplest enum is a named set of constants. Each constant is an ordinal value,
and you refer to one by `EnumName.CONSTANT`.

```ldp3
public enum Color {
    RED,
    GREEN,
    BLUE
}

Color c = Color.GREEN;
```

### Java-style enums with fields and methods

An enum can also be a full-fledged type: each constant carries constructor
arguments, and the enum declares fields, a constructor, and methods just like a
class. This is the form to reach for when each constant needs associated data.

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

int d = Planet.EARTH.density();   // 5
```

Every enum, simple or Java-style, comes with auto-generated helpers:
`EnumType.values()` returns all constants in declaration order, `EnumType.count()`
returns how many there are, `EnumType.random()` picks one, and
`EnumType.parse(s)` returns an `Option<EnumType>` by name. On a VALUE, `v.name()`
returns the declared identifier back as a `String` — the same name data `parse`
reads in, read out the other way — and an enum that declares its own `name`
method keeps it. A Java-style value also converts to its declaration ordinal
with `cast<int>(v)` (never to its singleton's pointer bits).

### Catalogs

A `catalog` is, in essence, an *interface for enums*. Where an ordinary interface
constrains only the methods a type must provide, a catalog constrains both the
shape (the methods) **and** specific values the implementing enum must contain.
An enum satisfies a catalog by extending it and supplying the required values in a
`byCatalog` block, implementing any required methods as normal enum methods.

```ldp3
public catalog TipoMotor {
    combustao,
    h2,
    eletrico

    method classify() returns TipoMotor;
}

public enum Motor extends TipoMotor {
    v8, v12, doisPistoes

    byCatalog {
        combustao,
        h2,
        eletrico
    }

    public method classify() returns TipoMotor { return combustao; }
}
```

Catalogs may provide default implementations, may extend other catalogs, and an
enum may satisfy several catalogs at once — giving enums a form of multiple
"interface" conformance that carries required values along with required methods.

A **catalog-typed value** is a first-class one: it may be stored, returned, and
passed as an argument to a method, a class constructor, or an enum constant's
constructor, and calling a catalog method on it dispatches to the constant's own
implementation whichever enum that constant came from.

```ldp3
public class Scale {
    public static method weigh(Heavy h) returns int {
        return h.weight();          // dispatches to Ingot's or Stone's, by what was passed
    }
}
```

### Catalogs and Java-style enums compose

A catalog-implementing enum may be Java-style: each constant — the enum's own
and the `byCatalog` ones alike — takes constructor arguments, so every constant
carries its data instead of a table on the side. The catalog's required methods
are then implemented as ordinary enum methods reading the constant's own fields.

```ldp3
public catalog Scored {
    bronze,
    gold

    method score() returns int;
}

public enum Medal extends Scored {
    paper(1)

    byCatalog {
        bronze(10),
        gold(95)
    }
    ;
    private int points;

    public constructor Medal(int points) {
        this.points = points;
    }

    public method score() returns int {
        return this.points;
    }
}

Scored s = Medal.gold;
int g = s.score();   // 95 -- dispatch picks Medal, and `this` is the gold singleton
```

A value typed as the catalog still carries the (enum, ordinal) tag, so several
enums — ordinal and Java-style mixed freely — can implement one catalog and a
call through the catalog-typed value reaches the right implementation. Ordinals
run through `byCatalog` in declaration order exactly as for an ordinal enum, and
`values()`, `count()`, `random()` and `parse()` behave the same.

---

## 4.11 Generics

Generic types and methods let you write code once and use it across many element
types. LDP3 implements generics by **monomorphization**: for each concrete set of
type arguments you actually use, the compiler stamps out a specialized copy — so
`ArrayList<int>` and `ArrayList<Dog>` become genuinely distinct, fully-typed code
with no boxing and no runtime type erasure.

```ldp3
public class Box<T> {
    private T content;
    public constructor Box(T c) { this.content = c; }
    public method get() returns T { return this.content; }
}

public method swap<T>(T a, T b) returns (T, T) {
    return (b, a);
}

Box<int> b = new Box<int>(42) on heap;
int v = b.get();
```

### Constraints

A type parameter may be constrained with `extends` or `implements`, so that
generic code can rely on the capabilities of its type argument:

```ldp3
public class Cache<T extends Serializable> { }
public class Sorted<T implements Comparable<T>> { }
public method clamp<T extends Numeric>(T value, T min, T max) returns T { }
```

### Variance

LDP3 uses **declaration-site variance** in the style of C#. On a type parameter,
`out` marks it covariant (the type produces `T` values), `in` marks it
contravariant (the type consumes `T` values), and leaving the annotation off
makes the parameter **invariant** — the default and the safest choice.

```ldp3
public interface Producer<out T> {          // covariant: produces T
    method produce() returns T;
}

public interface Consumer<in T> {           // contravariant: consumes T
    method consume(T item) returns void;
}

public interface Box<T> { }                 // invariant (default)
```

Covariance lets a `Producer<Cat>` stand in where a `Producer<Animal>` is expected;
contravariance lets a `Consumer<Animal>` stand in where a `Consumer<Cat>` is
expected. Invariant parameters relate only to themselves.

### `sealed ... permits`

A class may declare a closed set of subclasses with `sealed ... permits`. Only the
listed classes may extend it, which turns the type into a finite, known set of
possibilities — the compiler will reject any other class that tries to extend it.

```ldp3
public sealed class Shape permits Circle, Square, Triangle { }
```

Sealing interacts directly with pattern matching: when you `match` on a value of a
`sealed` type, exhaustiveness becomes **mandatory** and no `default` arm is
required — you must cover every permitted variant, and if you miss one the
compiler tells you. (For a non-sealed type a `default` arm is required instead,
since the compiler cannot know the possibilities are complete.)

---

## 4.12 Casting

All conversions between distinct types are explicit, written `cast<T>(expr)`.
There is no hidden coercion; if you want a `long` from an `int`, you ask for it.

```ldp3
int    x = cast<int>(someLong);
double d = cast<double>(x);
Dog    dog = cast<Dog>(animal);   // downcast, checked at runtime
```

The companion tests `is` and `as` let you probe and convert reference types:
`animal is Dog` is a boolean test, `animal as Dog` performs the conversion, and
`animal as? Dog` yields a `nullable Dog` that is `null` when the object is not a
`Dog`.

### Casting never invokes undefined behavior

Casting in LDP3 is held to the same no-UB standard as the rest of the language. A
cast can fail, but it fails cleanly and predictably — it never produces a poison
value or a corrupt object. Three cases are worth spelling out:

- **Class downcasts are checked.** `cast<Dog>(animal)` verifies at runtime that
  the object really is a `Dog` (using the vtable) and throws a
  `ClassCastException` if it is not, rather than reinterpreting unrelated memory.
  Upcasts, identity casts, and plain reference reinterprets pass through unchecked
  because they cannot go wrong.

- **Float-to-integer conversions saturate.** Converting a floating-point value
  whose magnitude is too large for the target integer clamps it to the integer's
  minimum or maximum, and `NaN` becomes `0`. This uses hardware-supported
  saturating conversion, so it costs nothing at runtime while avoiding the poison
  result a naive truncation would give.

  ```ldp3
  double huge = 1.0e30;
  int    n    = cast<int>(huge);   // saturates to int's MAX, not garbage
  ```

- **Integer-to-integer conversions** widen (sign- or zero-extending as
  appropriate) or narrow by truncation — a defined, wrapping narrowing, never
  undefined.

Between raw integers and pointers, a `cast<T*>(addr)` or `cast<address>(ptr)`
reinterprets the value, a facility meant for low-level and freestanding code.
Finally, a class may define its own **conversion operators**, letting `cast<T>`
invoke user-written conversion logic:

```ldp3
public class Celsius {
    private double temp;
    public operator explicit cast<Fahrenheit>() returns Fahrenheit {
        return new Fahrenheit(this.temp * 9.0 / 5.0 + 32.0);
    }
}

Fahrenheit f = cast<Fahrenheit>(myCelsius);
```

---

## 4.13 Putting it together

The type system's job is to let you say precisely what you mean and to catch you
the moment you contradict yourself. A `nums` you declared `int[]` cannot suddenly
hold a `Dog`; a `nullable Dog` cannot leak into a `Dog`; a `long` cannot become an
`int` without your explicit consent; an index cannot run off the end of an array
without a clean trap. And because assignment copies, two names never accidentally
share state — sharing is something you request out loud, with `T*` or `T&`.

The composite types layer meaning on top of the primitives: `record` for
immutable value bundles, `struct` for mutable fixed-layout aggregates, `union` for
reinterpreting memory, `enum` and `catalog` for closed sets of named values, and
generics for writing one algorithm that works across many types with zero runtime
overhead. Each is a way of pinning down the shape of your data so the compiler can
be your first and most tireless reviewer.
