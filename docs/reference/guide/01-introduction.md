# 1. Introduction & Philosophy

Welcome to the LDP3 Language Reference. This book describes **LDP3** — *Linguagem De
Programação 3* — as it exists today: a real compiler that turns source text into native
machine code. Every example in these pages is written in the language the compiler actually
accepts, and the features described are the features it actually implements. Where the design
reaches further than the current implementation, the text says so plainly.

LDP3 was created by **João Victor Pereira Tavares**. This reference tracks toolchain
version **1.0.11**.

## 1.1 What LDP3 is

LDP3 is a **systems programming language** with three commitments that are rarely held together
at the same time:

- It is **object-oriented by mandate**. There are no free functions and no loose statements at
  the top of a file. All behavior lives inside a type — a class, interface, record, struct, or
  enum — which in turn lives inside a namespace, inside a bundle, inside a program. If you come
  from Java or C#, this hierarchy will feel familiar; the difference is that LDP3 takes it all
  the way down to the systems layer.
- It is **manually memory-managed, with no garbage collector**. You decide where each object
  lives — on the stack or on the heap — and when it is released. Destructors run
  deterministically, at a point in the program you can name and reason about, not whenever a
  collector decides to wake up.
- It **compiles to fast native code** through LLVM. There is no interpreter and no virtual
  machine between your program and the processor. Because LDP3 shares the LLVM backend with
  Clang, code written in LDP3 reaches the same machine instructions that equivalent C or C++
  would, and runs at the same speed.

Put together, these commitments aim at a specific gap in the landscape: a language that reads
with the clarity and structure of a managed, object-oriented language, but that gives you the
control, predictability, and raw performance of a low-level one — without a garbage collector
sitting in the hot path.

The reference implementation is written in C++20 and targets Windows x86-64 first, with a
native Linux x86-64 port. It emits LLVM IR, which the toolchain hands to `clang`/`lld` to
produce a real executable.

## 1.2 The design pillars

LDP3 is verbose in places, and the verbosity is deliberate. The language's guiding conviction is
that *explicit beats implicit* whenever the explicit form eliminates ambiguity, documents intent,
or prevents a whole category of bugs. Everything else follows from a small set of pillars.

### Pillar 1 — Object orientation is mandatory

There is no such thing as a top-level function in LDP3. You cannot drop a `main` on its own into
a file. Behavior belongs to types, and types belong to namespaces. The rationale is uniformity:
when *every* piece of logic has a home in the type system, tooling, encapsulation, visibility,
and the module graph all work the same way everywhere, with no special cases for "the loose bits
outside the classes." A codebase becomes a forest of well-labeled types instead of a mix of
objects and free-floating helpers.

The one concession to pragmatism is data: a namespace may hold global *variables*, but never
global *functions*. Logic is always a method on something.

### Pillar 2 — Manual memory with value semantics

LDP3 has no garbage collector. You allocate, and you free. An object is created with `new` and
placed explicitly `on stack` or `on heap`; heap objects are released with `delete`. Stack objects
are released automatically when their scope ends, and their destructor runs at exactly that
point (RAII).

Crucially, **assignment is a deep copy**, even for class instances. Writing `b = a` gives `b` its
own independent copy of `a`, not a shared reference to it. This is the opposite of the default in
most object-oriented languages, and it is a deliberate choice: value semantics make ownership
obvious and aliasing bugs rare. When you *do* want two names to refer to the same object, you say
so explicitly with a pointer (`T*`) or a reference (`T&`).

```ldp3
import System.IO.Console;
program ValueCopy;

public bundle main {
    public namespace app {
        public class Point {
            public mutable int x;
            public constructor Point(int x) { this.x = x; }
        }

        public class Main {
            public static method main(string[] args) returns void {
                Point a = new Point(1) on stack;
                Point b = a;        // deep copy -- b is independent of a
                b.x = 99;
                Point* p = &a;      // a pointer shares the instance
                p.x = 7;
                System.IO.Console.println($"a={a.x} b={b.x}");   // a=7 b=99
                return;
            }
        }
    }
}
```

The assignment `b = a` copied the point, so changing `b.x` left `a` untouched. The pointer `p`,
by contrast, aliased `a`, so `p.x = 7` changed `a` itself.

### Pillar 3 — No exploitable undefined behavior

In C and C++, signed integer overflow, out-of-bounds indexing, and dereferencing a null pointer
are *undefined behavior*: the compiler is free to assume they never happen, and the program is
free to do anything at all when they do. This is the source of a large fraction of security
vulnerabilities in systems software. LDP3 refuses that bargain.

Every operation that would be undefined in C has a **defined** outcome in LDP3 — it either
saturates, traps, or is checked deterministically:

- Integer overflow **traps** by default (raises a runtime error rather than silently wrapping).
  When you genuinely want another behavior, the standard library offers explicit methods:
  `x.wrappingAdd(y)` for C-style wrap-around, `x.saturatingAdd(y)` to clamp at the type's
  maximum or minimum.
- Array indexing is **bounds-checked**. An out-of-range access halts with a defined
  `array index out of bounds` panic instead of corrupting memory.
- Division by zero **traps** rather than producing an undefined result.
- Dereferencing a null pointer produces a **deterministic trap**, not a wander into arbitrary
  memory.

The point is not to make LDP3 slower than C — where the compiler can prove a check is
unnecessary, it removes it — but to make sure that when something *does* go wrong, the failure is
a clean, predictable stop, never a silent exploitable corruption. Safety here is a property of
the language's definition, not an optional linter.

### Pillar 4 — No ceremony in the common case, a cannon when you need one

Verbosity in LDP3 is not verbosity for its own sake. The everyday path is meant to be
lightweight, and the heavy machinery is meant to be *available* rather than *mandatory*. You do
not have to specify where an object lives every single time — `new Rectangle(3, 4)` defaults to
the stack for objects and the heap for arrays — but when placement matters, `on stack` and
`on heap` are right there to say it. You do not have to reach for pointers to pass data around,
because value semantics handle the common case; but when you need shared, aliased state, `T*` and
`T&` give you exactly that.

This is the "sensible default, explicit opt-in" principle applied throughout the language. The
90% case should read cleanly. The 10% case — the region allocator, the ownership discipline, the
freestanding kernel — should be *expressible*, precisely and without fighting the language, when
you finally need the cannon.

### Pillar 5 — Immutability by default

Bindings and fields are **immutable unless you say otherwise**. A variable you never reassign
needs no annotation; a variable you *do* intend to reassign must be marked `mutable`. This turns
the more dangerous choice — mutable state — into the one that is visible in the source, and makes
the safer choice the effortless one.

```ldp3
int side = 4;              // immutable: side can never be reassigned
mutable int count = 0;     // mutable: count is expected to change
count = count + 1;         // fine
// side = 5;               // compile error: side is not mutable
```

The same rule governs fields. A field set once in the constructor and never touched again is left
immutable; only a field that is reassigned during the object's life is marked `mutable`.

### Pillar 6 — Native performance as a first-class goal

Performance is not an afterthought bolted on with an optimizing pass; it is a design constraint.
LDP3 has no implicit boxing, no hidden allocations behind ordinary syntax, no runtime type
soup, and no garbage collector to introduce pauses. It compiles straight through LLVM to native
instructions. Because it targets the same backend as Clang, an LDP3 program and its C or C++
equivalent that express the same computation end up at parity — there is no inherent overhead
imposed by the language itself. LDP3 is intended to be usable for the domains where that matters:
game engines, simulations, audio processing, and systems software.

## 1.3 Who LDP3 is for

LDP3 is aimed at programmers who need control and speed but are tired of the accidental
complexity that usually comes with them:

- **Java and C# developers** who love the structure of object orientation but hit a wall with
  garbage-collection pauses in latency-sensitive work.
- **C++ developers** who want a modern, manually-managed language without decades of accreted
  legacy and undefined behavior.
- **Game and engine developers, simulation and audio authors** — anyone for whom a GC pause at
  the wrong millisecond is unacceptable.
- **Systems and kernel programmers**, who can drop into the freestanding mode described below and
  write bare-metal code while keeping full object orientation.

It is deliberately *not* trying to be your web-backend, data-science, or quick-scripting language.
For those, reach for Go, Python, or TypeScript. LDP3 competes with **C, C++, Rust, and Zig** — the
languages you choose when the machine is close and every cycle counts. Against C and C++ it offers
defined behavior and value-semantic clarity without giving up native speed. Against Rust it trades
the borrow checker for a simpler, more familiar object model plus explicit ownership tools you opt
into. Against Zig it keeps a rich, structured type system and mandatory OOP rather than a minimal
procedural core.

## 1.4 A first taste

Here is the canonical LDP3 "hello, world." Read it from the outside in.

```ldp3
import System.IO.Console;
program HelloWorld;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello, world!");
                return;
            }
        }
    }
}
```

Even the smallest program shows the shape of the language:

- The `import` line brings the standard-library console into scope. LDP3 requires imports to be
  explicit — nothing from the standard library is available implicitly, so the dependency on
  `System.IO.Console` is stated up front.
- `program HelloWorld;` names the program.
- A **program** contains one or more **bundles**, a bundle contains one or more **namespaces**,
  and a namespace contains **types**. Every layer here is marked `public` because the entry point
  must be reachable from the outside.
- The entry point is a `public static method main(string[] args) returns void` inside a
  `public class Main`. The compiler looks for exactly this chain — a public bundle, a public
  namespace, a public `Main`, and a public static `main` — to decide where execution starts.
- Output goes through `System.IO.Console`. Its `println` prints a line; `printf` takes a format
  string and arguments; `print` writes without a trailing newline.

Now a slightly richer program — a real class with a private field, a constructor, and a method —
to show how the everyday code you will write actually looks:

```ldp3
import System.IO.Console;
program Geometry;

public bundle main {
    public namespace shapes {

        public class Rectangle {
            private int width;
            private int height;

            public constructor Rectangle(int width, int height) {
                this.width = width;
                this.height = height;
            }

            public method area() returns int {
                return this.width * this.height;
            }
        }

        public class Main {
            public static method main(string[] args) returns void {
                Rectangle r = new Rectangle(3, 4);   // default placement: on stack
                System.IO.Console.println($"area = {r.area()}");   // area = 12
                return;
            }
        }
    }
}
```

Several conventions, all enforced by the compiler, are on display:

- **Every block is braced.** There is no brace-less `if` or single-statement body; a block always
  has `{ }`.
- **Member access always goes through `this.`** Inside `Rectangle`, the fields are `this.width`
  and `this.height`, never bare `width`. This makes it unmistakable when you are touching object
  state versus a local.
- **Visibility is explicit on everything** — `public`, `private`, `protected`, or `internal`.
  There is no implicit default, so a member's reach is always written down.
- **The fields are immutable.** `width` and `height` are set once in the constructor and never
  reassigned, so neither needs `mutable`.
- **`new Rectangle(3, 4)` defaults to the stack.** Because `r` is a plain object, it lives on the
  stack and its destructor (if any) runs when `main` returns — no `delete` required. Had we asked
  for `on heap`, we would owe a matching `delete r;`.
- **`$"..."` is string interpolation.** The expression `{r.area()}` is evaluated and spliced into
  the string, which is a convenient way to build console output.
- **`var` is only for locals.** Here the type is written out, but inside a method body you may
  write `var r = new Rectangle(3, 4);` and let the compiler infer it. Fields, parameters, and
  return types always require an explicit type — inference stops at the method boundary.

To build and run a program with the current toolchain, the compiler (`ldp3c`) emits LLVM IR and
`clang` links it:

```
ldp3c geometry.ldp3 -o geometry.ll
clang geometry.ll -o geometry.exe
geometry.exe
```

## 1.5 Two execution modes

LDP3 comes in two flavors, and it is worth knowing they exist before you meet them in detail
later in the reference.

**Managed (normal) mode** is what every example above uses. It is the full language: the standard
library, the console, dynamic memory, exceptions, reflection, and the runtime services that make
ordinary application code pleasant to write.

**Freestanding mode** is the systems subset, declared with `program X freestanding;` (or on an
individual `bundle X freestanding`). It strips away the parts that assume an operating system and
a runtime — no managed heap services, no reflection, no exceptions — so you can write a kernel or
bare-metal code while keeping classes, inheritance, and the rest of the object model. The compiler
enforces the boundary: use a forbidden feature in a freestanding program and it is a compile
error, not a mysterious crash at runtime.

## 1.6 How to read this reference

This book is organized to be read front to back the first time and dipped into by topic
thereafter. The chapters build on one another:

1. **Introduction & Philosophy** *(this chapter)* — what LDP3 is, why it is shaped the way it is,
   and a first taste of real code.
2. **Program Structure & Modules** — programs, bundles, namespaces, imports, visibility, and the
   entry point in depth.
3. **Values & the Type System** — the primitive families, `boolean`, `char`, `String`/`string`,
   literals and explicit conversion, plus records, structs, unions, enums, and generics.
4. **Memory & Ownership** — stack versus heap, `new`/`delete`, deep-copy assignment, pointers and
   references, deterministic destruction, and the ownership and region tools you opt into.
5. **Object-Oriented Programming** — fields, constructors and destructors, instance and static
   methods, `this`, calling methods, encapsulation, inheritance, interfaces, `override`, and
   virtual dispatch.
6. **Control Flow** — conditionals, loops, ranges, `switch`/`match`, and the "chaos tetrad".
7. **Errors, Results & Contracts** — exceptions, `Result`/`Option`, contracts, and
   defined-behavior traps.
8. **Concurrency** — threads, channels, mutexes, and `async`/`await`.
9. **Compile-Time, Reflection & Prefixes** — `comptime`, reflection, the universal prefixes, and
   the managed-runtime features (persistents, `unimport`).
10. **Systems Programming** — freestanding mode, raw pointers, the low-level `Memory` API, and FFI.
11. **Keyword Reference** — every reserved word, its status, and a short example.
12. **Diagnostics** — how to read an LDP3 error, its structure, and `ldp3 explain`.
13. **Functions & Lambdas** — `lambda`, `function<...>` types, and method references.
14. **Toolchain** — how to build, run, package, and test LDP3 programs.

Six **Standard Library** chapters follow the guide: concurrency & core, collections, data
structures, text/encoding/crypto, parsing/time/JSON, and math/net/misc.

Throughout, code appears in fenced ` ```ldp3 ` blocks and reflects what the compiler accepts
today. When a feature is planned but not yet fully implemented, the text will say so, so that you
are never left guessing whether an example will actually run. This reference is the canonical
description of the language, cross-checked against the compiler; it exists to *explain* the
language and teach it to a human reader, not merely to enumerate it.

With the philosophy in hand, turn to Chapter 2 to see how a program is assembled from bundles and
namespaces.
