# LDP3 Language Guide

*How the language works — a syntax and semantics overview.*

This guide is the "how it works" companion to the keyword reference
(`docs/LDP3_keywords.md`). The authoritative source of truth for the language is the
specification (`docs/LDP3_specification.md`); this guide summarizes it and cross-checks every
feature against the reference compiler (`src/lexer`, `src/parser`, `src/semantic`, `src/codegen`)
and the working programs in `tests/samples/`. Every code snippet below is adapted from a real
sample that compiles and runs, or from a spec example. Where the written spec and the working
compiler diverge, the divergence is flagged inline.

> LDP3 (Linguagem De Programação 3) is a mandatory-OOP systems language with manual memory
> management (no garbage collector), compiled to native code via LLVM. It combines three rarely
> co-located decisions: OOP is mandatory (all logic lives in classes, like Java/C#), memory is
> manual (like C++), and it ships a rich fine-grained vocabulary (regions, ownership, persistents,
> universal prefixes, catalogs, the "chaos tetrad", freestanding mode).

---

## Table of contents

1. [Philosophy and general rules](#1-philosophy-and-general-rules)
2. [Program structure](#2-program-structure)
3. [Comments](#3-comments)
4. [The type system](#4-the-type-system)
5. [Value semantics and memory](#5-value-semantics-and-memory)
6. [Object-oriented programming](#6-object-oriented-programming)
7. [Control flow](#7-control-flow)
8. [Exceptions and contracts](#8-exceptions-and-contracts)
9. [Lambdas and functions](#9-lambdas-and-functions)
10. [Concurrency](#10-concurrency)
11. [Universal prefixes](#11-universal-prefixes)
12. [Native compiler builtins](#12-native-compiler-builtins)
13. [Foreign function interface (FFI)](#13-foreign-function-interface-ffi)
14. [Freestanding mode](#14-freestanding-mode)
15. [Build, manifest and toolchain](#15-build-manifest-and-toolchain)
16. [Annotations](#16-annotations)
17. [Notes and known ambiguities](#17-notes-and-known-ambiguities)

---

## 1. Philosophy and general rules

A handful of rules apply everywhere in LDP3. Internalizing them explains most of the syntax:

- **OOP is mandatory.** All logic lives inside classes, interfaces, records, structs or enums.
  There are no free-standing (top-level) functions; only global *variables* are allowed at
  namespace level.
- **Explicit beats implicit.** Visibility is always written out. `this.` is mandatory on every
  member access. `override` is mandatory when overriding. There is no implicit numeric promotion
  and no implicit cast.
- **Immutable by default.** A binding is read-only unless declared `mutable`. Type inference with
  `var` is allowed *only* for locals.
- **Every block requires braces.** `if`, `else`, `while`, `for`, `do`, `switch`, `match` — all need
  `{ }`. A braceless body is a compile error:

```ldp3
if (x == null) { return; }    // OK
if (x == null) return;        // compile error
```

- **Assignment is a deep copy, not a reference share.** `Thing b = a;` produces an independent
  copy of `a` (recursively). To share one instance across names, opt in with a pointer `T*` or a
  reference `T&`.
- **Assignment is not an expression.** `if (x = 5)` is a compile error. Chained assignment
  (`a = b = c = 0`) is a recognized special case.
- **Manual memory, deterministic destruction.** The programmer chooses where objects live
  (`on stack` / `on heap`) and destructors run deterministically (RAII), not via a GC.

---

## 2. Program structure

### 2.1 The organizational hierarchy

```
program
  └── bundle          (independent compilation unit)
        └── namespace
              └── types (class, interface, record, struct, enum)
```

Every file states the `program` and `bundle` it belongs to at the top. There are two equivalent
forms. **Short form** (headers without braces):

```ldp3
program GameEngine;
bundle audio;

public namespace mixers {
    public class StereoMixer { /* ... */ }
}
```

**Long form** (fully braced):

```ldp3
program GameEngine {
    public bundle audio {
        public namespace mixers {
            public class StereoMixer { /* ... */ }
        }
    }
}
```

Every sample in the repo uses the short `program X;` header followed by a braced
`public bundle ... { public namespace ... { ... } }`.

### 2.2 The entry point

An executable program requires a chain of `public` declarations (spec §2.9):

1. at least one `public bundle`,
2. containing at least one `public namespace`,
3. containing a `public class Main`,
4. containing `public static method main(string[] args) returns void` (or `returns int`).

The canonical minimal program (`tests/samples/hello_world.ldp3`):

```ldp3
import System.IO.Console;
program HelloWorld;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.printf("Resultado: %d\n", 42);
            }
        }
    }
}
```

- `returns int` is used by kernel/freestanding entry points (`return 0;`).
- `args` holds the real command-line arguments (the program name is skipped); `args.length()` and
  `args[i]` work (`tests/samples/main_args.ldp3`).
- A missing chain is a compile error; multiple eligible `main`s produce an ambiguity error that you
  resolve by renaming, changing visibility, or a compiler flag.
- A program with no `main` is a library: it compiles to a distributable `.ldb`, not an executable.

### 2.3 Imports

Imports appear at file scope, **before** the `program` line (as in every sample). Wildcard imports
are **not** permitted in any form (spec §2.7).

```ldp3
import mixers.StereoMixer;                                       // same bundle
import bundle audio.mixers.StereoMixer;                          // another bundle, same program
import from program GameEngine bundle audio.mixers.StereoMixer;  // cross-program (via IPC)
```

**The standard library requires an explicit import** — this is a deliberate design choice
(verbosity that documents what a file pulls in). Everything from stdlib needs importing:
collections, `String`, `Result`/`Option`, `Channel`, and so on. I/O lives under
`System.IO.Console`:

```ldp3
import System.IO.Console;
import System.Memory.Units.bytes;      // a single literal suffix
import math.Calc;                       // a type from another namespace/bundle
```

The `Ok`/`Err`/`Some`/`None` construction sugar is exempt (it comes with `Result`/`Option`).

### 2.4 Bundles

A bundle is not just a naming layer — it is an **independent compilation unit** shipped as a
separate binary. Each bundle exports two artifacts (spec §2.5):

- `audio.ldb` — the compiled implementation (LDP3 Bundle),
- `audio.ldh` — a header of public declarations, used for type-checking when the bundle is not
  compiled alongside the consumer.

Bundles serve two purposes: **build variants** (different builds include different bundle sets from
one source — free/paid, lite/full) and **cross-program sharing** at runtime via IPC with automatic
serialization. Dependencies are explicit and versioned:

```ldp3
public bundle audio version 1.2.0 requires bundle math, bundle io {
    // may only import types from math and io
}
```

The compiler validates the dependency graph, detects cycles, and computes a load order. It also
computes an SHA-256 fingerprint of each bundle's public API; a mismatch at load time raises
`BundleAbiMismatchException`.

**Library vs application bundles.** A library bundle has no `Main`
(`tests/samples/bundle_calc_lib.ldp3`); an app bundle imports it and consumes it
(`tests/samples/bundle_calc_app.ldp3`):

```ldp3
// library
program CalcLib;
public bundle calc {
    public namespace math {
        public class Calc {
            public static method square(int x) returns int { return x * x; }
        }
    }
}

// application
import System.IO.Console;
import math.Calc;
program CalcApp;
public bundle main { public namespace app { public class Main {
    public static method main(string[] args) returns void {
        int r = Calc.square(7);
        System.IO.Console.printf("square = %d\n", r);
    }
} } }
```

**Partial compilation** (spec §2.4): a program can be built without all bundles. Any use of an
absent bundle must be wrapped in `try/catch`, or it is a compile error; at runtime the first use of
an unloaded bundle throws `BundleNotLoadedException`:

```ldp3
try {
    int r = Calc.square(7);
} catch (BundleNotLoadedException e) {
    System.IO.Console.printf("calc not available\n");
}
```

### 2.5 Qualified names and multi-file programs

Two namespaces in one bundle may each declare a same-named type; they are distinct and are
disambiguated with a namespace-qualified reference (`tests/samples/qualified_names.ldp3`):

```ldp3
app.Box* a = new app.Box() on heap;
lib.Box* b = new lib.Box() on heap;
```

A program can be split across files that repeat the same `program`/`bundle`/`namespace` headers;
the compiler merges files of the same program. Types in the same bundle/namespace are visible to
each other without an import (`tests/samples/multifile_a.ldp3` + `multifile_b.ldp3`).

### 2.6 Access modifiers at bundle/namespace level

- `public` — reachable by other programs at runtime via IPC.
- `internal` — reachable only within the same program, across any bundle.
- `private` — reachable only within the declaring bundle.

Member-level visibility adds `protected` (see §6.2).

---

## 3. Comments

```ldp3
// line comment
/* block
   comment */
/// documentation comment (extracted by tooling)
```

---

## 4. The type system

### 4.1 Primitive types (normal mode)

In **normal mode** the primitive names do not encode a bit width — the programmer does not have to
think about bit counts. (Bit-counted names exist, but *only* in freestanding mode — see §4.2.)

| Category | Types (bit width) |
|----------|-------------------|
| Signed integers | `byte` (8), `short` (16), `int` (32), `long` (64) |
| Unsigned integers | `ubyte` (8), `ushort` (16), `uint` (32), `ulong` (64) |
| Floating point | `smallfloat` (16 / half), `float` (32), `double` (64), `quadruple` (128 / fp128) |
| Boolean | `boolean` — `true` / `false` |
| Character | `char` |
| No value | `void` |
| Raw address | `address` — pointer-sized; low-level, but usable in normal mode too |

Semantics:

- **No implicit numeric promotion.** Width conversions use an explicit `cast<T>(x)`. (Assigning a
  literal into a wider declared type is accepted; see the literal rules below.)
- The default integer literal type is `int` (32-bit); a literal too large for `int` lives in its
  declared wider type. The default (unsuffixed) floating literal is `double`.
- Unsigned types have real unsigned semantics (unsigned division and comparison).
- `boolean` conditions accept truthy/falsy values: `if (dog)` is equivalent to `if (dog != null)`.
- `char` accepts single or double quotes (`'a'` and `"a"` are both valid); samples prefer `'a'`.

```ldp3
long big = 10000000000;    // 10^10 needs 64 bits
int n = 200;
long wide = n;             // int widened to long
double pi = 3.14;
uint u = 3000000000;       // past INT32_MAX, stays positive
ulong huge = 18000000000000000000;
```

**Reference types built in:** `String` (immutable class), `string` (mutable), and `Object` (the
root of the class hierarchy).

**Integer overflow** defaults to *trapping* (a checked error, no undefined behavior). Per-operation
alternatives are stdlib methods on the integer types: `wrappingAdd`/`wrappingSub`/`wrappingMul`
(C-style wrap), `saturatingAdd`/`saturatingSub`/`saturatingMul` (clamp at MAX/MIN), and
`uncheckedAdd`/… (no check). `checked(expr)` is a keyword that returns to the default checked
behavior explicitly.

### 4.2 Freestanding-only bit-counted names

The names `int8`/`int16`/`int32`/`int64`, `uint8`/…/`uint64`, and `float32`/`float64` exist **only
in freestanding mode**, where the exact width matters. Using one in normal mode is a compile error
whose message names the normal equivalent (e.g. *"type 'int64' exists only in freestanding mode;
use 'long'"*). The mapping is `byte`=int8, `short`=int16, `int`=int32, `long`=int64 (and unsigned
analogues); `float`=float32, `double`=float64.

### 4.3 Numeric literals and suffixes

```ldp3
int x     = 42;
int hex   = 0xFF;
int bin   = 0b1010;
int big   = 1_000_000;    // '_' digit separators
long l    = 100L;         // L = long
float f   = 3.14f;        // f = float
double d  = 2.71828;      // unsuffixed decimal = double
```

Bases: decimal, hex `0x`, binary `0b`; `_` digit separators are allowed. The built-in numeric
suffixes are `L` (long) and `f` (float). The compiler also implements an `m` suffix for the
`Decimal` fixed-point type (see §12.2), and the language supports **user/stdlib-defined literal
suffixes** via `comptime literal` functions (spec §17.10): a one-parameter compile-time function may
be applied as a suffix, resolved with zero runtime cost. The stdlib ships six under
`System.Memory.Units` that return a `ByteSize`:

```ldp3
import System.Memory.Units.kilobytes;
ByteSize a = 64 kilobytes;    // expands to kilobytes(64) at compile time -> 65536
ByteSize b = 2 megabytes;
```

The parameter type decides applicability (`int` param → integer literals, `double` param → decimal
literals); the return type is the type of the suffixed literal, so `64 kilobytes` is type-distinct
from a bare `int`.

### 4.4 String, string and char

```ldp3
String imut = "hello";    // immutable class (capital S) — shared freely
string mut  = "hello";    // mutable value type (lowercase s)
char c1 = 'a';
char c2 = "a";            // double quotes also accepted for char
```

`String` is an immutable heap object `{ i64 length, ptr data }`; `string` is mutable and grows in
place. Both have value-copy assignment (see §5). See §12.1 for the native methods and §12.6 for
string interpolation.

### 4.5 Nullable types

Types are non-nullable by default. The **`nullable` prefix** (not a `T?` postfix — the compiler
parses `nullable T`) opts a type into holding `null`:

```ldp3
Dog rex = null;            // compile error (Dog is non-nullable)
nullable Dog a = null;     // OK
nullable Dog b = new Dog(5) on heap;
```

The nullable model is intentionally simple (spec §3.7, and the design memory): enforcement is at
**declaration/assignment only**. A `null` or a `nullable` value does not flow into a non-nullable
target (variable, field, parameter, or return). There is no flow-analysis narrowing and no
force-unwrap operator — LDP3 deliberately is not a borrow-checker.

Dereferencing a *non-nullable* is always safe. Dereferencing a `nullable` is *allowed*; if it is
null at runtime the result is a **deterministic trap** (no undefined behavior). You compare with
`== null` / `!= null`:

```ldp3
nullable Dog b = new Dog(5) on heap;
if (b != null) { total = total + b.bark(); }   // b may be dereferenced directly
```

Two operators support nullable code:

- **`??` null-coalescing** — `a ?? b` yields `a` when non-null, else `b` (`b` evaluated only when
  needed). The result is non-null when `b` is, so it flows into a non-nullable target:

  ```ldp3
  nullable int x = null;
  int z = x ?? 99;      // 99
  ```

- **`?.` safe navigation** — `obj?.member` / `obj?.method()` yields null instead of trapping when
  `obj` is null; the result is nullable so it chains (`tests/samples/safe_navigation.ldp3`):

  ```ldp3
  nullable Node* n = a?.next;   // a null -> yields null
  ```

Nullable primitives are boxed (a `nullable int` is a null-capable pointer) so they can actually
hold null.

> Divergence note: `tests/samples/nullable.ldp3`'s header comment describes `if (x != null)`
> *narrowing* the type to non-null. The authoritative spec §3.7 and the design memory state there is
> no narrowing; the sample works only because dereferencing a nullable is always permitted (it
> traps on null). Treat the sample comment as informal.

### 4.6 Arrays

Native arrays `T[]` are dynamic (the size is a runtime value and can grow):

```ldp3
int[] arr = [1, 2, 3, 4];                   // literal
int[] dyn = new int[size]();                // runtime size, zero-initialized on the heap
Car[] cars = new Car[Car.sizeof()]();       // any expression as the size
int len = arr.length();                      // current length (reads the header)
arr.length(arr.length() + 1);                // grow by one (length() with an argument)
```

The heap layout is a length header followed by the elements (`[i64 length][elements...]`). Freed
with `delete arr;`. Multi-dimensional arrays are arrays of arrays (`int[][]`, `m[i][j]`):

```ldp3
int[][] m = [[1, 2], [3, 4]];
public static method trace(int[][] m) returns int { return m[0][0] + m[1][1]; }
```

For richer operations (insert/remove/contains/functional) use the stdlib `ArrayList<T>`.

### 4.7 Generics

Generics are **monomorphized** — each instantiation is a distinct concrete type. They apply to
classes, interfaces, and methods:

```ldp3
public class Box<T> {
    private T value;
    public method get() returns T { return this.value; }
}
public method swap<T>(T a, T b) returns (T, T) { return (b, a); }
```

Recursive generic pointer fields work (`public mutable Node<T>* next;`). Multi-parameter generics
are written `Pair<A, B>`.

- **Constraints** (spec §15.2): `<T extends Shape>`, `<T implements Comparable<T>>`, `<T extends
  Numeric>` — enforced at monomorphization.
- **Variance** is declaration-site, C#-style (spec §15.3): `interface Producer<out T>` (covariant),
  `interface Consumer<in T>` (contravariant), and invariant by default.

### 4.8 records, structs, unions, enums, catalogs

**record** (spec §10) — an immutable value with a primary constructor. `equals`/`hashCode`/
`toString` are auto-generated from the constructor parameters; records are implicitly `final`, take
no inheritance, may implement interfaces and have methods/constants, but no extra fields beyond the
constructor parameters, and cannot be `persistent`:

```ldp3
public record Point(int x, int y) {
    public method sum() returns int { return this.x + this.y; }
}
public record Point3D(double x, double y, double z) implements Comparable<Point3D> { /* ... */ }
```

**struct** (spec §11) — a mutable value object of fixed, known size. No inheritance, may implement
interfaces, no auto `equals`/`hashCode`, supports bit fields, `persistent` only on fields. Ideal
for memory-mapped/FFI layouts (no vtable pointer):

```ldp3
public struct Vec3 {
    public mutable float x;
    public mutable float y;
    public mutable float z;
    public constructor Vec3(float x, float y, float z) { this.x = x; this.y = y; this.z = z; }
}
```

Bit fields use `field : N` bit width; a store masks/truncates to N bits:

```ldp3
public mutable int a : 4;     // 0..15
public mutable int c : 12;    // 0..4095
```

record, struct and class all assign **by copy**; the differences are mutability, inheritance,
auto-methods, and size predictability. (Interfaces and abstract classes are always handled by
reference.)

**union** (spec §13) — C-style; all fields share the same storage:

```ldp3
public union Value {
    int asInt;
    float asFloat;
}
```

**enum** (spec §12). Simple, int-style — the constants are ordinals (`RED`=0, `GREEN`=1, `BLUE`=2):

```ldp3
public enum Color { RED, GREEN, BLUE }
```

Java-style — constants carry constructor arguments; a `;` separates them from the fields/methods
(`tests/samples/enum_java.ldp3`):

```ldp3
public enum Planet {
    EARTH(10, 2),
    MARS(30, 3);
    private final int mass;
    private final int radius;
    public constructor Planet(int mass, int radius) { this.mass = mass; this.radius = radius; }
    public method density() returns int { return this.mass / this.radius; }
}
```

Auto-generated enum members (spec §12.5): `EnumType.values()` → `EnumType[]` in declaration order,
`EnumType.count()` → `int`, `EnumType.random()`, and `EnumType.parse(string)` → `Option<EnumType>`.

**catalog** (spec §12.3–12.4) — an *interface for enums* that forces both required methods (shape)
and required values. An enum `extends` a catalog and supplies the required values in a `byCatalog`
block; the required methods are implemented as ordinary enum methods. Catalogs can carry defaults,
can extend other catalogs (transitively), and an enum can extend multiple catalogs. The enum is a
*subtype* of the catalog:

```ldp3
public catalog Priced {
    cheap, pricey
    method price() returns int;
    method rank() returns int;
}
public enum Item extends Priced {
    book, phone
    byCatalog { cheap, pricey }                      // supply the catalog-required values
    public method price() returns int { if (this == Item.pricey) { return 100; } return 10; }
    public method rank()  returns int { if (this == cheap) { return 1; } return 2; }
}
// Priced p = Item.pricey;  p.price() dispatches to Item.price()
```

### 4.9 Type inference with `var`

`var` is allowed **only for local variables** inside methods. Fields, parameters, and returns
always need an explicit type. Shadowing a name in a nested scope is forbidden.

```ldp3
var dogs = new ArrayList<Dog>() on heap;   // OK
var pair = getPair();                       // OK

var x = 5;                       // ERROR: a field needs a type
public method bar(var x) { }     // ERROR: a parameter needs a type
```

### 4.10 Type aliases and newtype

```ldp3
public typealias DogList = ArrayList<Dog>;
public typealias Callback = function<void, int>;   // function-type alias
public typealias UserId = long;                     // transparent: UserId == long
public newtype OrderId = long;                       // distinct type
```

`typealias` is fully transparent — the alias and the target are interchangeable. `newtype` creates
a distinct nominal type over the same representation; crossing the boundary needs a cast:

```ldp3
OrderId o = cast<OrderId>(cast<long>(1000));
long raw = cast<long>(o) + 7;    // cast out, compute, cast back
```

---

## 5. Value semantics and memory

### 5.1 Value semantics — assignment is a deep copy

Classes and structs have **value semantics**: assignment (and parameter passing) makes an
independent, recursive deep copy. Mutating the copy does not affect the original
(`tests/samples/value_semantics.ldp3`, `deep_copy.ldp3`):

```ldp3
Box a = new Box(1) on stack;
Box b = a;            // deep copy -> b is independent
b.set(99);            // a=1, b=99
```

The copy is recursive: an owned `int[]` member is duplicated too. To *share* one instance, opt in
with a pointer or reference.

### 5.2 Pointers `T*` and references `T&`

`T*`/`T&` are the opt-in to share an instance. A pointer is formed with the address-of `&`; members
are accessed with `.` (there is no `->`):

```ldp3
Box b = new Box() on stack;
Box* p = &b;          // p shares b (no copy)
p.set(5);             // mutate through the pointer -> b=5, p=5
Box& r = b;           // a reference to the same instance
```

Pointer arithmetic is allowed on all types but the compiler *warns* on class pointers (advancing a
class pointer is semantically meaningless and can corrupt memory).

### 5.3 `new … on stack` / `on heap`, and `delete`

`new T(args) [on stack | on heap]`. The location clause is **optional**; when omitted the compiler
picks a sensible default: **objects go to the stack** (RAII, freed automatically at end of scope)
and **arrays / dynamic collections go to the heap**. Heap allocations require an explicit `delete`:

```ldp3
Dog rex = new Dog("Rex", 5);            // no ceremony -> stack (RAII)
Dog* big = new Dog("Big", 10) on heap;  // the "cannon": manual heap, needs delete
delete big;
```

`delete` on a stack object runs its destructor early exactly once and does not free the stack slot;
scope exit will not run the destructor again (`tests/samples/stack_delete.ldp3`).

### 5.4 RAII destructors

A destructor is `public destructor ~ClassName() returns void { ... }` (note the explicit
`returns void`). It runs deterministically at the end of the scope that owns the object. RAII is
control-flow aware: an object inside a not-taken branch is never constructed; an object declared in
a loop body is destructed each iteration (`tests/samples/block_raii.ldp3`).

```ldp3
public destructor ~Greeter() returns void { System.IO.Console.printf("dtor\n"); }
// ...
Greeter g = new Greeter() on stack;   // dtor runs at end of scope
```

**Virtual destructors**: `delete` through a base pointer dispatches dynamically through the vtable,
running most-derived first then chaining to the base (`tests/samples/virtual_dtor.ldp3`):

```ldp3
Base* b = new Derived() on heap;
delete b;                      // ~Derived, then ~Base
```

### 5.5 Regions

`region` is a **native type** (like `int`). A region is a named arena you allocate into and free all
at once — a local region is freed at scope end (RAII), a field region lives with the object, a
namespace region lives for the whole program. Sizes use the `System.Memory.Units` literal suffixes.

```ldp3
import System.Memory.Units.*;
region pen = itself.allocate(1 kilobytes);   // a 1 KiB arena
Dog* a = new Dog(3) in region pen;            // bump-allocated into the arena
Dog* b = new Dog(7) in region pen;
release region pen;                            // frees both at once (runs destructors)
```

The `itself` pronoun is the region being declared; the fluent chain builds it. There are three
equivalent declaration forms (`itself.allocate(...)`, a named `small.allocate(...)`, or a separate
declaration then assignment). An uninitialized `region small;` is in an **empty state** (no backing
memory) — only `.allocate(...)`, `.at(...)`, or copy-assignment from another region are legal until
it leaves that state.

**Type filters** `accepts` / `rejects` restrict what a region may hold; they chain and are enforced
statically and at runtime:

```ldp3
region E = itself.allocate(4096 bytes).accepts({Dog, Cat});
region F = itself.allocate(8192 bytes).rejects({String});
region G = itself.allocate(2 kilobytes).accepts({Dog}).rejects({Cat});
```

Other region operations: `delete a from region pen;` destroys one object now and removes it from
teardown; a region may be a **class field**, allocated in the constructor; and `itself.at(addr,
size)` places a region at a fixed address for memory-mapped hardware — see §14.

### 5.6 Ownership: `movable`, `unique`, `partitionable`

Ownership is a **class prefix** after visibility — it is part of the type, not the reference
(spec §19):

```ldp3
public class Buffer { }               // default: copy semantics
public movable class Connection { }   // requires an explicit `move`; source is invalidated
public unique class FileHandle { }    // one live reference program-wide; assignment is implicit move
```

`move` transfers ownership; the source becomes invalid and use-after-move is a **compile error**.
The compiler tracks each variable as valid / moved / uninitialized; reassigning revives it:

```ldp3
Handle a = new Handle(7) on heap;
Handle b = move a;                  // ownership -> b; a is now invalid
a = new Handle(9) on heap;          // a valid again
```

Destructors only run on variables still valid at scope end (no double-free). `move` also appears in
signatures — on the parameter and at the call site — and on returns:

```ldp3
public static method consume(move Conn c) returns void { /* ... */ }
Main.consume(move c);
public method create() returns move Connection { return move c; }
```

`partitionable` opts a class into partial field moves: a `movable`/`unique` field can be moved out
while the parent stays valid for its other fields, and the moved field is reassignable
(`tests/samples/partitionable.ldp3`). `unique + partitionable` is contradictory and rejected. `move`
also relocates objects between regions (`move c1 from region staging to region production`), so an
object can outlive the release of its source arena.

### 5.7 Scoped resources: `defer` and `using`

`defer { ... }` runs its block at scope end in **LIFO** order (including during exception
unwinding). `using (...) { ... }` disposes the bound resource at block end (its type must implement
`Disposable`) — `tests/samples/scoped.ldp3`:

```ldp3
using (Resource r = new Resource(3) on heap) {
    System.IO.Console.println("inside using");
}   // r disposed here

defer { System.IO.Console.println("deferred 1"); }
defer { System.IO.Console.println("deferred 2"); }
// on scope exit: "deferred 2", then "deferred 1"
```

### 5.8 Persistents

A `persistent` field's lifetime is *decoupled* from the object that declares it: it **survives the
destructor** and **reattaches** when an equivalent variable is recreated. Its identity is the triple
`(lexical scope, variable name, region)` — differ in any coordinate and the persistents are
independent (spec §18).

```ldp3
public class Car {
    public eternal persistent mutable int chassi = 0;   // run-lifetime storage
    public constructor Car() {}
}
// ...
Car c = new Car() on heap;
c.chassi = c.chassi + 1;   // counts 1, 2, 3 across calls despite delete each time
delete c;
```

- Access after `delete` is legal (`c.chassi` still reads the surviving block).
- A **partial constructor** may omit a parameter whose name matches a persistent field; its value
  then comes from the reattached block (an argument, if supplied, overrides).
- `eternal persistent` needs no explicit cleanup (freed at program shutdown). A **non-eternal**
  persistent must have a matching `release persistent` somewhere in the program or it is a compile
  error (checked interprocedurally):

  ```ldp3
  public persistent mutable int slot = 0;   // non-eternal
  // ...
  release persistent c.slot;                 // satisfies the release obligation
  ```

> Persistents are an in-process feature (reattach happens within one run). They do not exist in
> freestanding mode.

---

## 6. Object-oriented programming

### 6.1 Classes

```ldp3
public class Dog extends Animal implements Barkable {
    private String name;
    public constructor Dog(String dogName, int dogAge) { this.name = dogName; /* ... */ }
    public override method bark() returns void { System.IO.Console.println(this.name); }
    public destructor ~Dog() returns void { /* free resources */ }
}
```

Rules (spec §8):

- Visibility is always explicit. `this.` is mandatory on every member access.
- A class has a **single constructor — there is no method overloading**; each method name is
  unique.
- Fields may be initialized at the declaration or in the constructor.
- `return` is optional in `void` methods, required otherwise.
- Assignment copies; share with `T*`/`T&`.

**Static** members are accessed by class name, even inside the class
(`tests/samples/class_static.ldp3`):

```ldp3
public class Counter {
    public static int total = 0;
    public static method increment() returns void { Counter.total = Counter.total + 1; }
}
```

### 6.2 Modifiers

- **Visibility:** `public`, `private`, `protected`, `internal`.
- **`mutable`** — opt a field/local into reassignment (everything is immutable by default).
- **`static`** — class-level member.
- **`abstract`** — an abstract class cannot be instantiated; an abstract method has no body.
- **`final`** — a `final` field/local is immutable, a `final` method cannot be overridden, a
  `final` class cannot be extended. `mutable final` is a contradiction and is rejected.
- **`sealed permits A, B`** — only the listed classes may extend (see §6.7).
- **`partial`** — a class split across files.

### 6.3 Inheritance and virtual dispatch

Single inheritance via `extends`. **`override` is mandatory** when overriding. `super()` is
implicit; write it explicitly only to pass constructor arguments
(`tests/samples/super_args.ldp3`):

```ldp3
public constructor Dog(int barks) {
    super(4);              // forward 4 to Animal's constructor
    this.barks = barks;
}
```

A base-typed variable dispatches to the derived override through the vtable
(`tests/samples/polymorphism.ldp3`):

```ldp3
Animal a = new Dog();   // upcast
a.speak();              // dispatched to Dog.speak (virtual)
```

> Note: only `super(args)` (constructor chaining) is attested in the spec and samples. A
> `super.method()` form is not documented — do not rely on it.

### 6.4 Interfaces

An interface declares methods (no visibility modifier, `;`-terminated), and may carry default
(implemented) methods and constants. A class implements one or more with `implements A, B`:

```ldp3
public interface Barkable { method bark() returns void; }

public interface Greeter {
    method name() returns int;
    method greet() returns int { return this.name() + 100; }   // default method
}

public class Alice implements Greeter {
    public override method name() returns int { return 1; }
    // inherits the default greet() -> 101
}
```

Interface-typed fields are stored by reference (not deep-copied), which supports
decorator/delegation patterns. Interfaces may be generic
(`interface Iterable<T> { method iterator() returns Iterator<T>; }`).

### 6.5 Properties

C#-style properties (spec §8.4). Inside a setter, `value` is the implicit incoming value.
`get`/`set`/`init` are reserved keywords.

```ldp3
public int w    { get; set; }                          // auto-property (mutable)
public int h    { get; init; }                          // init-only (settable in the constructor)
public int area { get { return this.w * this.h; } }     // computed, get-only

public int fahrenheit {                                  // custom get + set with a backing field
    get { return this.celsius * 9 / 5 + 32; }
    set { this.celsius = (value - 32) * 5 / 9; }
}
```

### 6.6 Operator overloading

`public operator <op> (params) returns T`. Operators are instance members: `a + b` is
`a.operator+(b)`. Overloadable operators include the binary and comparison operators, unary,
increment/decrement, and the index operators `[]` (read) and `[]=` (write):

```ldp3
public operator +  (Vec3 other) returns Vec3 { return new Vec3(this.x + other.x, /* ... */) on heap; }
public operator [] (int i) returns int { return i == 0 ? this.a : this.b; }
public operator []=(int i, int v) returns void { if (i == 0) { this.a = v; } else { this.b = v; } }
public operator ++ () returns Counter { return new Counter(this.n + 1) on heap; }
public operator -  () returns Vec2 { return new Vec2(0 - this.x, 0 - this.y) on heap; }  // unary minus
```

A **conversion operator** is invoked through `cast<T>(obj)`:

```ldp3
public operator explicit cast<Fahrenheit>() returns Fahrenheit {
    return new Fahrenheit(this.temp * 9 / 5 + 32) on heap;
}
```

### 6.7 sealed / permits and match exhaustiveness

`sealed ... permits` closes a hierarchy to a known set, which lets a `match` over that type omit
`default` (the set is exhaustive):

```ldp3
public sealed abstract class Shape permits Circle, Square {
    public abstract method area() returns int;
}
match (s) {                    // no default: sealed and exhaustive
    case Circle(int r)    { /* ... */ }
    case Square(int side) { /* ... */ }
}
```

### 6.8 Catalogs

A `catalog` is the enum equivalent of an interface — see §4.8. It forces both required values and
required methods on an implementing enum, and the enum becomes a subtype of the catalog, allowing
dispatch through a catalog-typed value.

---

## 7. Control flow

### 7.1 Operators

- Arithmetic: `+ - * / %`
- Comparison: `== != < > <= >=`
- Logical (short-circuit): `&& || !`
- Bitwise: `& | ^ ~ << >>`
- Assignment `=` and compound `+= -= *= /= %= &= |= ^= <<= >>=`
- Increment/decrement `++ --`
- Ternary `cond ? a : b`
- Chained assignment `a = b = c = 0`

Type operators: explicit cast `cast<T>(expr)`; type test `x is Dog`; narrowing cast `x as Dog`;
nullable narrowing cast `x as? Dog` (null if not that type). Short-circuit is observable — the
right operand of `&&`/`||` runs only when needed.

### 7.2 if / while / do-while / for

```ldp3
if (n % 2 == 0) { result = 1; } else { result = 2; }

while (n < 10) { n = n + 2; }

do {
    count = count + 1;
    n = n + 2;
} while (n < 10);          // body runs at least once

for (mutable int i = 0; i < 10; i++) { /* ... */ }
```

### 7.3 foreach and ranges

`foreach` iterates any `Iterable<T>`; the element may be `var`-inferred. Range literals are
first-class:

- `a..b` — `b` exclusive
- `a..=b` — both inclusive
- `step k` — custom stride

```ldp3
for (var x in nums)          { sum = sum + x; }
for (int i in 0..5)          { sum = sum + i; }        // 0,1,2,3,4
for (int i in 1..=5)         { inc = inc + i; }        // 1..5
for (int i in 0..10 step 2)  { stepped = stepped + i; } // 0,2,4,6,8
for (index i, Dog d in dogs) { /* indexed form */ }
```

`Range<int> r = 0..100 step 5;` is a value you can store and iterate.

### 7.4 switch

`switch` uses braced `case N { }` arms, a **mandatory** `default`, and **fall-through** (a case
without `break` falls into the next):

```ldp3
switch (x) {
    case 0 {
        System.IO.Console.printf("zero ");
        // no break: falls through to case 1
    }
    case 1 { System.IO.Console.printf("one "); break; }
    case 2 { System.IO.Console.printf("two "); break; }
    default { System.IO.Console.printf("other "); }
}
```

`switch` also matches enum constants and strings (by value, not pointer identity).

### 7.5 match (pattern matching)

`match` does dynamic-type dispatch with positional destructuring. Exhaustiveness is mandatory: over
a `sealed` type no `default` is allowed or needed; otherwise `default` is required. There are two
forms.

**Statement form:**

```ldp3
match (s) {
    case Circle(int r)      { System.IO.Console.println($"circle {r}"); }
    case Rect(int w, int h) { System.IO.Console.println($"rect area {w * h}"); }
}
```

**Expression form** (with `->` for a single expression, `{ }` for a block) — the whole `match` is a
value:

```ldp3
int a = match (s) {
    case Circle(int r)    -> r * r * 3;
    case Square(int side) -> side * side;
};
```

`match` is also the primary way to consume `Result`/`Option` (see §8.2).

### 7.6 Labeled break / continue

Prefix a loop with `label:` and target it:

```ldp3
outer: for (mutable int i = 0; i < 5; i++) {
    for (mutable int j = 0; j < 5; j++) {
        if (i * j == 6) { break outer; }
    }
}
```

### 7.7 goto / comefrom / abstainfrom / reinstate — the "chaos tetrad"

All four are **intra-method only** (they reference only labels declared in the same method) and are
available in freestanding mode. A label is a bare statement: `label name;`. Only explicitly declared
labels can be targeted.

- **`goto`** — jump (forward or backward) to a label in the same method:

  ```ldp3
  if (x < 0) { goto negative; }
  System.IO.Console.println("non-negative");
  return;
  label negative;
  System.IO.Console.println("negative");
  ```

- **`comefrom`** — the inverse of goto: the jump is declared at the *destination*. When execution
  reaches the referenced label, control is redirected to where the `comefrom` sits (after the
  labeled statement runs). Only one `comefrom` may target a given label.

  ```ldp3
  label loop;
  n = n + 1;
  if (n < 3) { comefrom loop; }   // backward retry; locals are preserved
  ```

- **`abstainfrom` / `reinstate`** — declaratively disable / re-enable the block a label guards (from
  the target label to the next label or the end of the method). They use reference counting, so
  multiple abstains stack. Safety-critical targets (constructors/destructors, bounds/contract
  checks, compiler-generated labels) cannot be abstained.

  ```ldp3
  if (mode == 1) { abstainfrom body; }   // disable
  if (mode == 2) { reinstate body; }     // re-enable
  label body;
  System.IO.Console.printf("body\n");
  ```

---

## 8. Exceptions and contracts

### 8.1 Exceptions

Exceptions are **unchecked**. `throws(...)` is a keyword clause; the compiler emits a *warning* (not
an error) for an undeclared throw. Full `try` / `catch` / `finally` / `throw` are supported; `throw`
takes a placement clause like any allocation:

```ldp3
public method readFile(String path) throws(IOException) returns string {
    if (!exists(path)) { throw new IOException($"file {path} missing") on heap; }
    // ...
}
try {
    string data = readFile("config.json");
} catch (IOException e) {
    System.IO.Console.println(e.message);
} finally {
    // always runs
}
```

Catch clauses are matched in order and are subtype-aware (a base clause catches a derived
exception). Stack unwinding runs `defer`/`using`/destructors. `finally` runs on both the caught and
the normal-completion paths.

### 8.2 Result / Option and `try?`

`Result<T, E>` and `Option<T>` are built-in sealed sum types (import `System.Errors.Result` /
`System.Errors.Option`). Variants are `Ok`/`Err` and `Some`/`None`. Construction sugar
(`Ok(x)`, `Err(x)`, `Some(x)`, `None()`) infers the generic arguments from context and is exempt
from the import rule. They are consumed with an exhaustive `match`:

```ldp3
public static method parse(int n) returns Result<int, int>* {
    if (n < 0) { return Err(404); }
    return Ok(n);
}
match (o) {
    case Some(int v) { System.IO.Console.printf("some %d\n", v); }
    case None()      { System.IO.Console.printf("none\n"); }
}
```

**`try?`** unwraps `Ok`/`Some` to the inner value, or early-returns the `Err`/`None` to the enclosing
method (propagation):

```ldp3
public static method doubleIt(int n) returns Result<int, int>* {
    int v = try? Main.parse(n);   // Err -> propagate; Ok -> unwrap
    return Ok(v + v);
}
```

### 8.3 Contracts

`requires` (preconditions), `ensures` (postconditions), and class `invariant`. Clauses are boolean
expressions placed between a method signature and its body; `ensures` may reference the entry-time
value with `old(e)`. Multiple `requires` stack. Contract violations are checked and cannot be
disabled by `abstainfrom`.

```ldp3
public class Account {
    private mutable int balance;
    invariant this.balance >= 0;

    public method withdraw(int amount) returns void
        requires amount > 0
        requires amount <= this.balance
        ensures this.balance == old(this.balance) - amount
    { this.balance = this.balance - amount; }
}
```

---

## 9. Lambdas and functions

The function type is `function<Ret, Params...>` (return type first). A lambda is
`lambda(params) returns T { ... }` and is called like a method:

```ldp3
function<int, int, int> add = lambda(int a, int b) returns int { return a + b; };
function<int, int>      sq  = lambda(int n) returns int { return n * n; };
// add(3, 5) = 8;  sq(6) = 36
```

**Captures** are explicit via a `[captures: ...]` clause with `byvalue` (copy) or `byref`
(mutations flow back):

```ldp3
mutable int counter = 0;
function<void> inc = lambda[captures: byref counter]() returns void { counter = counter + 1; };
inc(); inc(); inc();   // counter = 3
```

Functions are first-class values — they can be parameters and return values (higher-order
functions and closures):

```ldp3
public static method twice(function<int, int> f, int v) returns int { return f(f(v)); }
public static method compose(function<int,int> f, function<int,int> g) returns function<int,int> {
    return lambda(int x) returns int { return f(g(x)); };
}
```

A **method reference** `methodref receiver.method` produces a bound `function<...>` and preserves
virtual dispatch. The spec also documents named arguments (`requires named`), multiple returns via
tuples (`returns (int q, int r)` with destructuring `(int q, int r) = divmod(17, 5)`), and generators
via `yield` returning `Iterator<T>`.

---

## 10. Concurrency

Concurrency is mostly **stdlib types, not keywords** — only `async`/`await` are keywords (they drive
state-machine codegen).

**Thread** (`System.Concurrency.Thread`) wraps a `function<void>`:

```ldp3
Thread t = new Thread(work) on heap;
t.start();
t.join();
```

**async / await + `Task<T>`** (`System.Concurrency.Task`). An `async method` returns a `Task<T>`
immediately and runs on the language-managed worker pool; `await` yields the result. Awaiting inside
an async body suspends it — the compiler splits the method at each `await` into a heap-allocated
state machine (awaits inside loops/ifs are lowered as coroutines). Holding a mutex across an `await`
is forbidden by the compiler.

```ldp3
public static async method sumA() returns int { /* ... */ return s; }
Task<int> a = Main.sumA();   // scheduled, returns immediately
int ra = await a;
```

**Channel\<T\>** (`System.Concurrency.Channel`) — a bounded blocking queue; `.send(v)` blocks when
full, `.receive()` blocks when empty. `Channel.select()` is a static fluent builder:

```ldp3
Channel<int> ch = new Channel<int>(4) on heap;
// producer: ch.send(i);   consumer: sum = sum + ch.receive();

Channel.select()
    .receive(a, lambda(int x) returns void { System.IO.Console.printf("a=%d\n", x); })
    .receive(b, lambda(int y) returns void { System.IO.Console.printf("b=%d\n", y); })
    .timeout(milliseconds(1000), lambda() returns void { /* ... */ })
    .run();
```

**Mutex\<T\> + `synchronized`** (`System.Concurrency.Mutex`). The mutex wraps the protected value;
`synchronized (m) using T& name { ... }` holds the lock for the block and binds `name` as a
reference to the guarded value:

```ldp3
Mutex<int> counter = new Mutex<int>(0) on heap;
synchronized (counter) using int& c {
    c = c + 1;   // atomic under the lock
}
```

**atomic\<T\>** (`System.Concurrency.atomic`) — a lock-free cell lowering to LLVM atomics. Method
form (`get`/`set`/`add`/`increment`/`compareAndSet`) and operator form (`++ -- += -=` lower to
`atomicrmw`; a plain `c = 100` is an atomic store):

```ldp3
atomic<int> c = new atomic<int>(5) on heap;
c++;  c += 4;  c--;      // 6, 10, 9
int v = c.get();
```

Also in the stdlib: `Semaphore` and `CountdownLatch`.

---

## 11. Universal prefixes

Six keywords are promoted to **universal prefixes** — modifiers with consistent semantics applied to
any compatible declaration or operation (spec §37). They compose freely when semantically valid; the
compiler rejects contradictions.

| Prefix | Meaning | Example |
|--------|---------|---------|
| `cascade` | propagate the operation recursively through owned dependencies | `cascade delete player;` |
| `eternal` | lives for the whole program; no explicit cleanup required | `eternal region cache = itself.allocate(64 megabytes);` |
| `lazy` | defer execution/initialization until first access (thread-safe) | `lazy Dog rex = new Dog("Rex");` |
| `comptime` | evaluate during compilation; zero runtime cost | `comptime int fib10 = fibonacci(10);` |
| `volatile` | not optimizable; every read/write is a real memory access | `volatile int hardwareRegister = 0;` |
| `final` | cannot be modified, overridden, replaced or removed | `final import Dog;` |

They combine, in a canonical order the compiler enforces:

```ldp3
eternal lazy region globalCache = itself.allocate(64 megabytes);  // lives forever, allocates on first use
eternal comptime int VERSION_HASH = computeHash(VERSION);          // compile-time constant, program-lifetime
final lazy thread monitor = startMonitor();                        // on-demand, non-replaceable
```

Contradictions are compile errors — e.g. `mutable final`, `persistent transient`,
`comptime volatile`.

---

## 12. Native compiler builtins

The following are implemented directly in the compiler's code generator
(`src/codegen/codegen.cpp`), not in the prelude. They lower to LLVM IR (or small runtime helpers)
without a managed class behind them.

### 12.1 `String` / `string` methods

Native methods on the `String`/`string` type (element access is byte-level; `char` is `i32`):

| Method | Returns | Notes |
|--------|---------|-------|
| `length()` | `int` | the byte length |
| `isEmpty()` | `boolean` | |
| `charAt(i)` | `char` | byte at index `i` |
| `equals(o)` | `boolean` | content comparison (`strcmp`) |
| `concat(o)` | `String` | new joined string |
| `substring(start, end)` | `String` | new owned slice |
| `indexOf(o)` | `int` | -1 if absent |
| `contains(o)` / `startsWith(o)` / `endsWith(o)` | `boolean` | |
| `toUpper()` / `toLower()` / `trim()` | `String` | new owned strings |
| `repeat(n)` | `String` | |
| `toInt()` | `int` | base-10 parse (`atoi`) |
| `toString()` | `String` | identity |
| `hash()` / `equalsKey(o)` / `compareTo(o)` | | so `String` satisfies `Hashable`/`Comparable` for collections |
| `append(o)` | `string` | **mutable `string` only** — grows in place, returns the receiver for chaining |

```ldp3
String s = "Hello, World!";
System.IO.Console.println(s);
System.IO.Console.printf("len=%d\n", s.length());

string m = "hi";
m.append("!");
m.append(" there");      // in-place growth
```

> The richer, split-style helpers (`Strings.split`, `join`, `format`, `padLeft`, …) live in the
> stdlib `Strings` utility class, not among these native methods.

### 12.2 `Decimal` — exact fixed-point

`Decimal` is a native primitive backed by a 128-bit mantissa scaled by 10^18 (18 fraction digits);
literals carry an **`m`** suffix. Arithmetic is exact (no binary rounding), it converts to/from the
numeric types with `cast`, and `toString`/interpolation trim trailing fraction zeros:

```ldp3
Decimal price = 19.99m;
Decimal qty   = 3m;
Decimal total = price * qty;             // 59.97, exact
System.IO.Console.println($"total={total}");
Decimal half = cast<Decimal>(5) / cast<Decimal>(2);   // 2.5
```

> The written spec lists `Decimal` under the stdlib Math section (§34.6) and does not document the
> `m` literal suffix; the reference compiler implements both `Decimal` and the `m` suffix natively,
> as shown by `tests/samples/decimal.ldp3`.

### 12.3 `System.Memory` / freestanding `address` and `Memory` API

`address` is a pointer-sized raw integer. The `Memory` API is a set of by-name builtins that lower
to `malloc`/`free`/load/store through int↔pointer casts (`tests/samples/low_level_memory.ldp3`):

```ldp3
address mem = Memory.alloc(16);      // raw block -> address
int* p = cast<int*>(mem);            // reinterpret the address as a pointer
p[0] = 100; p[1] = 200;              // raw pointer writes (unchecked GEP, no array header)
Memory.write<int>(mem, 999);
int v = Memory.read<int>(mem);       // 999
address back = cast<address>(p);     // pointer -> address round-trip
Memory.free(mem);
```

`Memory.getMemory(expr)` returns the storage address of a target. These builtins are also available
in normal mode (they are not exclusive to freestanding).

### 12.4 SIMD vectors `vec2` / `vec3` / `vec4` (and `mat4`)

GLSL-style float vectors lowering to LLVM `<N x float>` (SSE/AVX). Construction `vecN(...)`,
element-wise `+ - * /` (a scalar operand broadcasts), lane access `.x/.y/.z/.w`, indexed access
`v[i]` (bounds-checked), and passing/returning by value:

```ldp3
vec4 a = vec4(1.0, 2.0, 3.0, 4.0);
vec4 b = vec4(10.0, 20.0, 30.0, 40.0);
vec4 c = a + b;          // element-wise
vec4 d = a * 2.0;        // scalar broadcast
float x = c.x;           // lane read
```

Vector methods: `dot(o)` and `length()` → `float`, `normalize()` → `vecN`, `cross(o)` → `vec3`.
There is also a `mat4` 4x4 matrix type with `multiply`, `transform`, and `mat4.identity()`.

### 12.5 `System.IO.Console`

The console builtins (import `System.IO.Console`):

- `System.IO.Console.printf(format, args...)` — C-style `printf`; the format is a string literal
  supporting `%d`, `%c`, `%s`, and escapes such as `\n`, `\t`.
- `System.IO.Console.println(x)` / `print(x)` — write a value (or a literal), with/without a
  trailing newline. A leading string literal is treated as a `printf` format; otherwise the first
  argument is a `String` printed with `%s`.
- `System.IO.Console.read()` — reads a line from stdin and returns it as a `String` (parse it
  further with e.g. `toInt()`).

### 12.6 String interpolation `$"..."`

A `$"..."` literal builds a `String` value, interpolating expressions in `{ }`. The compiler picks
the format per operand type (`%d`/`%lld`/`%u` for integers, `%g` for floats, `%c` for `char`, `%s`
for strings and `Decimal`). Without the leading `$`, braces are literal.

```ldp3
int n = 7;
String who = "world";
String s = $"n={n}, hello {who}!";     // a String value
String t = $"{n} doubled is {n + n}";
```

Interpolation is valid both as a standalone `String` and directly as an argument to
`println`/`printf`/`print`.

---

## 13. Foreign function interface (FFI)

FFI declares external C functions with a calling convention (`cdecl`, `stdcall`, `fastcall` — these
are keywords, not strings). In the working compiler the externs are declared as **`static` methods
inside a class**, in the order `public extern <conv> static method`; the C symbol is the method's
simple name (`tests/samples/ffi_extern.ldp3`):

```ldp3
public class LibC {
    public extern cdecl static method abs(int x) returns int;
    public extern cdecl static method labs(long x) returns long;
}
// int a = LibC.abs(-42);
```

Marshalling (from the samples):

- **`String` → `char*`** — a `String` argument passes as a NUL-terminated `char*`
  (`ffi_string_arg.ldp3`): `public extern cdecl static method puts(String s) returns int;`
- **struct by value** — a small value-type `struct` passes and returns by value, matching the C
  layout (`ffi_struct.ldp3`).
- **callback** — a *capture-free* lambda lowers to a raw C function pointer; declared as
  `function<...>` (`ffi_callback.ldp3`): `... method ldp3_apply_cb(function<int, int> f, int x) returns int;`
- **variadic** — a trailing `...` (`ffi_variadic.ldp3`):
  `public extern cdecl static method printf(String format, ...) returns int;`

Native/system libraries an FFI program links against are declared in the manifest (see §15).

> Divergence note: the written spec §26 also shows namespace-level `extern cdecl method foo(...)` and
> an `extern <conv> library name { ... }` / `at path` block form. The `library` block and `at path`
> forms have no working sample and were listed as not-yet-implemented — prefer the class-scoped
> `static` form documented above.

---

## 14. Freestanding mode

Freestanding mode is a subset for kernels, bootloaders, firmware and embedded code (no OS, no
managed runtime). The opt-in keyword follows the program and bundle names
(`tests/samples/freestanding_kernel.ldp3`):

```ldp3
program FreestandingKernel freestanding;

public bundle main freestanding {
    public namespace boot {
        public class Sys {
            public extern cdecl static method putchar(int c) returns int;
        }
        public class Main {
            public static method main(string[] args) returns int {
                address buf = Memory.alloc(8);
                int* msg = cast<int*>(buf);
                msg[0] = 79; msg[1] = 75; msg[2] = 10;   // "OK\n"
                for (mutable int i = 0; i < 3; i++) { Sys.putchar(msg[i]); }
                Memory.free(buf);
                return 0;
            }
        }
    }
}
```

Core principle: **no freestanding feature emits hidden runtime calls** — everything at runtime maps
to something the programmer wrote. What is available and what is forbidden:

- **Available:** full OOP classes; `struct` (with bit fields), `record`, `union`, `enum`, `catalog`;
  generics with variance; the bit-counted primitive names (`int32`, `uint8`, `float64`, …); the
  `address` type and int↔pointer casts; raw pointer indexing `p[i]`; the `Memory` API; regions,
  including `region ... at address` for memory-mapped hardware; FFI; inline assembly (`asm(...) {}`);
  `comptime`/`const`/`static_assert`; `volatile` fields; and the chaos tetrad.
- **Forbidden (rejected by the compiler):** `async`/`await`; exceptions
  (`try`/`catch`/`finally`/`throw`/`throws`); `unimport`/reimport/hot reload; reflection; `persistent`
  and `release persistent`; the managed `Console` and the managed stdlib generics; custom runtime
  annotations; inline `tests { }`; lambdas with dynamic capture (capture-free lambdas stay allowed);
  and cross-program bundles/IPC.

Region at a fixed address (memory-mapped I/O — use a `struct`, not a `class`, for a predictable
layout with no vtable pointer):

```ldp3
import System.Memory.Units.bytes;
region hw = itself.at(mem, 256 bytes);
Cell* c = new Cell() in region hw;     // placed at the fixed address
release region hw;                     // frees the region header, not the fixed memory
```

Other freestanding rules: no implicit allocation (string `+` and array literals need an explicit
region); globals limited to literals/const expressions; bounds checking on by default (opt out per
method/block with `[[no_bounds_check]]`); numeric overflow wraps by default (use `checked(...)` for
checked). Build with `--freestanding --target=<triple>` (e.g. `x86_64-unknown-none`), which emits a
bare-metal object with no libc.

---

## 15. Build, manifest and toolchain

A project needs a manifest (a `.toml`) plus at least one `.ldp3` file with the entry point. The
manifest is identified by its first-line header `[ldp3_project]`, not by filename (spec §38.4):

```toml
[ldp3_project]

[program]
name = "my_project"
version = "0.1.0"
language_version = "1.0"
entry = "src/main.ldp3"

[dependencies]
audio_lib = "1.2.0"       # exact
math_utils = ">=2.0.0"    # minimum
graphics = "^3.1.0"       # compatible range

[build]
output = "build-output/"
target = "x86_64-windows"   # compiler default (the spec example shows x86_64-linux)
freestanding = false
native_libs = "opengl32, user32, gdi32"
```

- **`native_libs`** is a comma-separated list of native/system libraries to link for FFI (spaces are
  trimmed). On Windows each entry becomes `<lib>.lib` for `lld-link`; on POSIX `-l<lib>` for clang.
  This is a compiler feature beyond the written spec's manifest example.
- **`--target=<triple>`** writes the triple into the emitted `.ll`; combined with `--freestanding`
  it produces a bare-metal object.
- Running a loose file with no manifest (`ldp3 run file.ldp3`) synthesizes an ephemeral manifest.

**The `ldp3` toolchain** (spec §38.1) is a single binary. Key subcommands: `ldp3 run [file]`,
`ldp3 build`, `ldp3 compile file.ldp3`, `ldp3 plug` / `unplug` (LDP3's own verbs for adding/removing
dependencies — resolved via Git, no central registry, into a per-project `packages/`),
`ldp3 new` / `init`, `ldp3 test`, `ldp3 fmt`, `ldp3 doc`, `ldp3 clean`, and the internal `ldp3 lsp`.
Library bundles are built with `ldp3c --lib` (producing `.ldb` + `.ldh`).

In the current bring-up, the compiler `ldp3c` emits `.ll` and `clang`/`lld` performs the final link;
the unified `ldp3` driver wraps this.

---

## 16. Annotations

Two syntaxes (spec §14):

- **Built-in language concepts are keywords, not annotations** (`override`, `final`, `abstract`,
  `sealed`, `static`, `mutable`, `persistent`, `lazy`, `volatile`, `transient`, `deprecated`, …). A
  few tool-facing built-ins use the `@Name` form.
- **User-defined annotations** use the bracket form `[Name(...)]` and are declared with
  `annotation`, accessible via reflection:

```ldp3
public annotation MaxLength {
    int value;
    String errorMessage default "exceeded maximum length";
}

[MaxLength(value: 100)]
public class UserName { }
```

An annotation marked `[CompileTimeProcessor]` is processed during compilation and may generate
auxiliary code.

---

## 17. Notes and known ambiguities

These are points where the written spec, the legacy keyword catalog, and the reference compiler do
not fully agree. Where they diverge, this guide follows the **compiler + spec §** and flags it:

1. **Nullable syntax** is the prefix `nullable T`, not a postfix `T?`. The `?` character appears only
   in `??` (null-coalescing), `?.` (safe navigation), and `as?` (narrowing cast).
2. **Nullable narrowing** does not exist: enforcement is at assignment only, with no flow-analysis
   narrowing or force-unwrap. A `nullable` can always be dereferenced directly (it traps on null).
   `tests/samples/nullable.ldp3`'s comment implies narrowing; that is informal.
3. **`Decimal` and its `m` suffix** are implemented natively by the compiler even though the written
   spec files them under the stdlib and do not mention the suffix.
4. **`super.method()`** is not attested; only `super(args)` (constructor chaining) is documented.
5. **FFI**: use the class-scoped `public extern <conv> static method` form. The spec's
   `extern ... library { }` / `at path` block forms have no working sample.
6. **`get`/`set`/`init`** are reserved keywords (not merely contextual/soft keywords). A
   `bidirectional` property variant is documented in the spec (§32.6) but has no working sample.
7. **Bit fields and unions** in the spec use freestanding bit-counted names (`uint8`, `int32`); in
   normal-mode code use the normal names (`int`, `float`), as the working samples do.
8. **Default build target** is `x86_64-windows` in the compiler; the spec example shows
   `x86_64-linux`.
9. **switch** uses braced `case N { }` arms with a mandatory `default` and fall-through (per spec
   §7.3); the legacy keyword catalog's colon-and-`break` form is out of date.

For the exhaustive list of open issues and spec ambiguities, see spec §40 and the keyword
reference (`docs/LDP3_keywords.md`).

---

*Sources: `docs/LDP3_specification.md` (authoritative); the reference compiler in `src/` (lexer,
parser, semantic, codegen); and the working programs in `tests/samples/`. This guide documents what
the specification and the implementation actually support; it does not invent syntax.*
