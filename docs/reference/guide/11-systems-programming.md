# 11. Systems Programming: Builtins, FFI & Freestanding

Most of what you have read so far is about *the language*: classes, generics, regions,
ownership, pattern matching. This chapter is about the layer beneath the language — the place
where LDP3 stops being an abstraction over "objects and methods" and becomes an abstraction over
"bytes and addresses." It covers three closely related topics: the **compiler builtins** that the
rest of the standard library is built on, the **foreign function interface (FFI)** that lets LDP3
talk to C and to the operating system, and **freestanding mode**, in which LDP3 runs with no
operating system underneath it at all.

The unifying idea is *no hidden machinery*. A high-level language earns the right to hide the
machine behind convenient syntax; a systems language earns the right to *show* it when you ask.
LDP3 tries to do both: the ordinary object model stays clean, and when you need to reach through
it — to a hardware register, a C library, a fixed physical address — the primitives in this
chapter are waiting.

---

## 11.1 Compiler builtins vs. the standard library

It helps to draw a line first. LDP3 has two very different kinds of "built-in" thing:

- **The standard library** is ordinary LDP3 code — classes like `ArrayList<T>`, `HashMap<K, V>`,
  `Strings`, `Files`, `Regex`. It is written in the language, compiled like your code, and you
  reach it with `import`. You could, in principle, have written it yourself.
- **Compiler builtins** are types and operations the compiler *knows about intrinsically*. They
  are not classes you could write in LDP3, because they lower directly to machine-level constructs:
  a `String`'s `{length, data}` layout, a `vec4`'s SSE register, a `Decimal`'s 128-bit mantissa, a
  raw `Memory.write<int>`. They are the bedrock the standard library stands on.

This distinction matters for the rest of the chapter, and especially for freestanding mode — where
the builtins are always available, and the library is available in the part that does not need an
operating system, which turns out to be most of it. Collections, `Buffer`, `Math` and the value types
all work bare metal; what does not is the handful of things that call the host — see
[what is removed](#what-is-removed-in-freestanding-mode) for the list and the reasoning.

Let us walk through the builtins first.

---

## 11.2 Strings: `String` and `string`

LDP3 gives you two string builtins with deliberately different personalities.

`String` is the **immutable** one. Once constructed, its bytes never change; every operation that
"modifies" it actually returns a fresh `String`. This makes it safe to share and cheap to reason
about. It is the type most APIs speak.

```ldp3
import System.IO.Console;
program StringDemo;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                String a = "Hello";
                String b = "World";
                String hw = a.concat(", ").concat(b).concat("!");   // a new String each step
                System.IO.Console.println(hw);                       // Hello, World!
                System.IO.Console.printf("len=%d empty=%d\n", hw.length(), hw.isEmpty());
                System.IO.Console.printf("c0=%c c7=%c\n", a.charAt(0), hw.charAt(7));
                System.IO.Console.println(hw.substring(7, 12));      // World
                System.IO.Console.printf("eq=%d\n", a.equals("Hello"));   // 1
                return;
            }
        }
    }
}
```

The core `String` methods the compiler recognizes are `length()`, `isEmpty()`, `charAt(int)`,
`equals(String)`, `concat(String)`, and `substring(int, int)`. The allocating ones (`concat`,
`substring`) build a new heap `String`; the query ones do not allocate. Everything richer —
`split`, `join`, `replace`, formatting — lives in the `Strings` helper class in the standard
library, which is just LDP3 code layered on top of these primitives.

`string` (lowercase) is the **mutable** counterpart: a growable buffer you build up in place.

```ldp3
string m = "hi";
m.append("!");
m.append(" there");        // "hi! there", grown in place
System.IO.Console.println(m);
```

Both string types obey LDP3's value semantics: assigning a string **copies** it. Mutating the
copy leaves the original untouched — no aliasing surprises.

```ldp3
string a = "x";
string b = a;              // a deep copy
b.append("y");
// a is still "x"; b is "xy"
```

Under the hood a string is a `{length, data}` pair: an `i64` length followed by a pointer to the
character bytes. You rarely see that layout — but when you hand a `String` to a C function
(§11.7), it is the raw `data` pointer that crosses the boundary, and knowing the layout explains
why.

---

## 11.3 `$"..."` string interpolation

Interpolation is the ergonomic way to build a `String` from a mix of literal text and expressions.
Inside a `$"..."` literal, anything in `{ ... }` is evaluated and stitched into the result. The
value produced is a real `String` object — you can store it, take its `length()`, pass it on.

```ldp3
int n = 7;
String who = "world";
String s = $"n={n}, hello {who}!";          // "n=7, hello world!"
System.IO.Console.println(s);
System.IO.Console.printf("len=%d\n", s.length());
String t = $"{n} doubled is {n + n}";        // nested expressions are fine
```

The compiler infers how to render each hole from the expression's type — integers, characters,
other strings, and so on — so you never write format specifiers inside `$"..."`. Interpolation is
one of the few conveniences that survives into freestanding mode, precisely because it can be
lowered without a dynamic `String` allocation when the result is only consumed, not stored.

---

## 11.4 `Decimal`: exact fixed-point arithmetic

Binary floating point (`float`, `double`) is fast and wrong for money: `0.1 + 0.2` is famously not
`0.3`. LDP3's answer is the **`Decimal`** builtin — an exact base-10 fixed-point type backed by a
128-bit mantissa scaled by `10^18`, giving eighteen fraction digits with no binary rounding error.
Decimal literals carry an `m` suffix, which is what tells the compiler "this is a `Decimal`, not a
`double`."

```ldp3
import System.IO.Console;
program Money;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                Decimal price = 19.99m;
                Decimal qty   = 3m;
                Decimal total = price * qty;              // exactly 59.97, not 59.9699999…
                System.IO.Console.println($"total={total}");
                Decimal tax = total * 0.08m;
                System.IO.Console.println($"tax={tax}");
                Decimal half = cast<Decimal>(5) / cast<Decimal>(2);   // exactly 2.5
                System.IO.Console.println($"half={half}");
                return;
            }
        }
    }
}
```

`Decimal` arithmetic (`+ - * /`) is exact, it compares and orders like any number, it converts
to and from the ordinary numeric types with `cast<...>`, and its textual form (via `toString` or
interpolation) trims trailing fraction zeros so `59.97m` prints as `59.97`, not `59.970000…`.
Reach for `Decimal` whenever a rounding error would be a bug — currency, tax, billing, ledgers.

---

## 11.5 Low-level memory: `address`, raw pointers, and the `Memory` API

This is where LDP3 opens the floor and lets you touch memory directly. Three builtins work
together.

**`address`** is a primitive integer the width of a pointer. It is a raw machine address with no
type attached — the LDP3 equivalent of `uintptr_t`. You can do arithmetic on it and cast it to and
from typed pointers.

**Int↔pointer casts** convert freely between an `address` (or any pointer-sized integer) and a
typed pointer `T*`, using `cast<T*>(addr)` one way and `cast<address>(ptr)` the other. This is the
reinterpretation escape hatch: "treat these bytes as an array of `int`."

**Raw pointer indexing** `p[i]` on a pointer obtained this way is an *unchecked* access — a plain
pointer-plus-offset (a GEP), with no array header and no bounds check. It is exactly `*(p + i)` in
C terms. That is the point: over hardware you do not get a length word, so you must not assume one.

The **`Memory` API** is the typed front door to a raw block:

- `Memory.alloc(bytes)` returns an `address` to a fresh raw block.
- `Memory.free(address)` releases it.
- `Memory.read<T>(address)` reads a `T` from an address; `Memory.write<T>(address, value)` writes
  one.
- `Memory.getMemory(x)` returns the raw `address` backing a value.

```ldp3
import System.IO.Console;
import System.Memory;
program LowLevelMemory;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                address mem = Memory.alloc(16);        // raw block -> an address
                int* p = cast<int*>(mem);              // reinterpret the address as int*
                p[0] = 100;                             // unchecked raw write
                p[1] = 200;
                System.IO.Console.printf("sum=%d\n", p[0] + p[1]);          // 300

                Memory.write<int>(mem, 999);
                System.IO.Console.printf("read=%d\n", Memory.read<int>(mem)); // 999

                address back = cast<address>(p);        // pointer -> address round-trip
                System.IO.Console.printf("delta=%d\n", cast<int>(back - mem)); // 0
                Memory.free(mem);
                return;
            }
        }
    }
}
```

Everything here is a direct machine operation — a load, a store, an add. Nothing calls into a
garbage collector or a bounds-checked collection. That is what makes this API usable in
freestanding mode, where `Memory.alloc` maps onto whatever allocator *your kernel* provides rather
than libc's `malloc`.

---

## 11.6 SIMD vectors: `vec2`/`vec3`/`vec4` and `mat4`

Graphics and physics math is dominated by small fixed-size vectors of floats. LDP3 makes them
first-class builtins that lower straight to LLVM `<N x float>` — that is, to SSE/AVX registers —
so a component-wise add is one instruction, not a loop.

`vec2`, `vec3`, and `vec4` are float vectors of two, three, and four lanes. You construct them by
calling the type, do element-wise `+ - * /` (a scalar operand *broadcasts* to all lanes), read
lanes with `.x`/`.y`/`.z`/`.w` or with `[i]`, and pass or return them by value.

```ldp3
import System.IO.Console;
program Simd;

public bundle main {
    public namespace app {
        public class Main {
            public static method dot3(vec3 a, vec3 b) returns float {
                vec3 p = a * b;               // element-wise multiply
                return p.x + p.y + p.z;
            }
            public static method main(string[] args) returns void {
                vec4 a = vec4(1.0, 2.0, 3.0, 4.0);
                vec4 b = vec4(10.0, 20.0, 30.0, 40.0);
                vec4 c = a + b;               // element-wise
                vec4 d = a * 2.0;             // scalar broadcast -> (2,4,6,8)
                System.IO.Console.printf("cx=%d dz=%d\n", cast<int>(c.x), cast<int>(d.z));

                vec3 u = vec3(1.0, 2.0, 2.0);
                System.IO.Console.printf("len=%d\n", cast<int>(u.length()));   // 3
                return;
            }
        }
    }
}
```

Vectors also carry the geometry methods you expect: `a.dot(b)`, `a.length()`, `a.normalize()`, and
(on `vec3`) `a.cross(b)`.

```ldp3
vec3 a = vec3(1.0, 2.0, 2.0);
vec3 b = vec3(3.0, 0.0, 0.0);
float d  = a.dot(b);         // 3
float l  = a.length();       // 3
vec3  n  = a.normalize();    // (1/3, 2/3, 2/3)
vec3  x  = a.cross(b);       // (0, 6, -6)
```

For transforms there is **`mat4`**, a 4×4 float matrix laid out row-major as `<16 x float>`. It
offers `mat4.identity()`, matrix×matrix `multiply`, and matrix×vector `transform`.

```ldp3
mat4 id = mat4.identity();
vec4 p  = vec4(1.0, 2.0, 3.0, 1.0);
vec4 tp = id.transform(p);              // identity * p = p
mat4 t  = mat4(1.0, 0.0, 0.0, 5.0,
               0.0, 1.0, 0.0, 6.0,
               0.0, 0.0, 1.0, 7.0,
               0.0, 0.0, 0.0, 1.0);
vec4 q  = t.transform(vec4(0.0, 0.0, 0.0, 1.0));   // origin -> (5, 6, 7)
```

These types were added to make real 3D code — the kind that used to require a C++ math library —
expressible directly in LDP3 without giving up performance.

---

## 11.7 `System.IO.Console`: the managed console

`System.IO.Console` is the built-in console. It is a *managed* builtin: it assumes an operating
system with standard streams underneath it, which is why it is one of the things freestanding mode
takes away (§11.9). In hosted programs it is your everyday I/O, and it must be imported.

```ldp3
import System.IO.Console;
// ...
System.IO.Console.printf("x=%d y=%c\n", 42, 'A');   // format string + args
System.IO.Console.print("no newline");
System.IO.Console.println("with newline");
String line = System.IO.Console.read();              // read a line, returns a String
```

`printf` takes a format string (a string literal or a `$"..."` interpolation) followed by
arguments; `print` and `println` take a string literal, an interpolation, or a `String` value;
`read()` returns a whole line as a `String` (parse it yourself for other types, e.g. `toInt`).
Note the deliberate design tension: the console is the most convenient builtin *and* the first one
a kernel loses, because printing to a screen without an OS means writing bytes to a hardware
buffer yourself — which is exactly what §11.9's VGA example does.

---

## 11.8 Foreign Function Interface (FFI)

No systems language is an island. Sooner or later you must call C: libc, a graphics driver, a
database client, or — in a kernel — a hand-written assembly routine. LDP3's FFI (spec §26) keeps
that inside the object model. A foreign function is declared as an `extern` **static method** of a
class, with no body; it resolves to a symbol with C linkage.

```ldp3
import System.IO.Console;
program FfiExtern;

public bundle main {
    public namespace app {
        public class LibC {
            public extern cdecl static method abs(int x) returns int;
            public extern cdecl static method labs(long x) returns long;
        }
        public class Main {
            public static method main(string[] args) returns void {
                int a  = LibC.abs(-42);                    // 42
                long b = LibC.labs(cast<long>(-1000000));  // 1000000
                System.IO.Console.printf("abs=%d\n", a);
                return;
            }
        }
    }
}
```

**The shape of the declaration** is `public extern <cdecl|stdcall|fastcall> static method
name(params) returns T;`. The calling convention is a *keyword*, not a string — `cdecl`,
`stdcall`, or `fastcall`. On the x86-64 targets LDP3 supports today these three conventions
converge on the single platform C ABI, so the choice is currently cosmetic on 64-bit; it is
carried through the AST so that the distinction can matter on 32-bit x86, where the conventions
genuinely differ. The enclosing class is pure organization: it groups related externs under one
convention and gives them a namespace. You call through it (`LibC.abs(...)`), but the actual C
symbol is the method's **simple name** (`abs`), so it links against the real `abs` in libc.

**Marshalling** — how LDP3 values become C values at the boundary — is where the interesting work
happens, and LDP3 handles the common cases automatically:

- **`String` / `string` → `char*`.** A string argument is passed as its NUL-terminated `data`
  pointer, not as the `{length, data}` object. The C side sees plain characters.

  ```ldp3
  public class LibC {
      public extern cdecl static method puts(String s) returns int;
  }
  // ...
  LibC.puts("hello from ldp3");     // C receives a char*
  ```

- **Small structs by value.** A value-type `struct` small enough to travel in a register (1/2/4/8
  bytes on Win64) is passed and returned by value: the compiler loads its bytes as the ABI integer
  for the call, and stores a returned register back into a fresh struct. A `Point { int x; int y; }`
  is eight bytes and matches a C `struct { int x, y; }`.

  ```ldp3
  public struct Point {
      public mutable int x;
      public mutable int y;
      public constructor Point(int x, int y) { this.x = x; this.y = y; }
  }
  public class PointApi {
      public extern cdecl static method ldp3_point_sum(Point p) returns int;
      public extern cdecl static method ldp3_point_scale(Point p, int k) returns Point;
  }
  ```

- **Capture-free lambdas → C callbacks.** A lambda with no captured environment is lowered to a
  raw C function pointer, so a C function can call straight back into it. Lambdas that *do* capture
  cannot cross the boundary (there is nowhere to put the environment).

  ```ldp3
  public class Cb {
      public extern cdecl static method ldp3_apply_cb(function<int, int> f, int x) returns int;
  }
  // ...
  int r = Cb.ldp3_apply_cb(lambda(int n) returns int { return n * n; }, 7);   // 49
  ```

- **Variadics.** A trailing `...` in the declaration marks a variadic C function, so you can bind
  things like `printf` directly.

  ```ldp3
  public class LibC {
      public extern cdecl static method printf(String format, ...) returns int;
  }
  // ...
  LibC.printf("x=%d\n", 42);
  ```

**Linking system libraries.** Declaring an extern says *what* to call; you still have to tell the
linker *where* the symbol lives. For libraries beyond the C runtime, list them in the project
manifest's `[build]` section under `native_libs`, as a comma-separated list of system libraries.
The driver forwards each to the linker.

```toml
[build]
target = "x86_64-windows"
native_libs = "opengl32, user32, gdi32"
```

This is precisely how a plugable graphics binding (LDP3-OpenGL, for instance) links `opengl32`
without any change to the compiler: extern declarations for the entry points, plus one
`native_libs` line.

---

## 11.9 Freestanding mode

Freestanding mode (spec §36) is LDP3 with the operating system removed. It is the mode for
kernels, bootloaders, firmware, hypervisors — bare metal, where there is no `malloc`, no thread
scheduler, no filesystem, and no exception handler until *you* write them.

### The central principle: no hidden runtime calls

Everything in freestanding mode rests on a single guarantee:

> **No freestanding feature emits a hidden call to runtime code.** Everything that executes at
> runtime corresponds directly to something the programmer wrote. Memory layout is predictable.
> There is no implicit allocation. There are no background threads.

This is the modern equivalent of what C and C++ offer with `-ffreestanding`, but with a much
larger language surface kept intact. A feature is allowed in freestanding mode if, and only if, it
can be lowered to code with no dependency on a managed runtime.

### What is removed, and why

The removed set is exactly the features that *cannot* keep that guarantee. Each removal has a
concrete technical reason:

- **Exceptions — `try` / `catch` / `finally` / `throw` / `throws`.** Stack unwinding needs runtime
  unwind tables, dynamic lookup, and compiler-generated cleanup paths. *Alternative:* `Result<T, E>`
  and `Option<T>` remain, and become the single error-handling mechanism.
- **Persistents — `persistent`, `reattach`, `release persistent`.** These depend on a global
  registry keyed by the `(scope, name, region)` triple, an implicit mutex, and runtime lookup.
  *Alternative:* ordinary `static` fields cover "a value that lives for the whole program."
- **Async — `async` / `await`.** These require a language-managed worker-thread scheduler. But the
  kernel is what *implements* schedulers; it cannot depend on one. *Alternative:* raw threads the
  kernel itself provides.
- **Unimport / hot reload — `unimport`, `reimport`.** These need a live-type registry and a
  mini-linker loading and unloading code segments at runtime. In a kernel, code is static after
  boot.
- **`lazy` initialization.** Lazy fields need runtime tracking and an implicit mutex on first read.
- **`using`.** The resource-token form depends on managed teardown.
- **`defer` with a timeout.** Timeout-based defer needs a runtime timer. *Static* `defer` — the
  plain "run this at scope exit" form, with no unwinding — is **kept**.
- **The runtime teardown lifecycle hooks — `onClassUnload`, `onLastInstanceDestroyed`.** These fire
  during dynamic destruction, which needs runtime tracking. The *static-init* hooks `onClassLoad`
  and `onFirstInstance` are **kept** and are how you do boot-time initialization.
- **`within`.** Its scoping depends on the managed runtime.
- **Reflection (`reflect.*`).** Reflection needs enormous runtime metadata — type tables, method
  names as strings, parameters, annotations. A kernel has no room for it and no need to inspect
  types dynamically.
- **The parts of the standard library that call an OPERATING SYSTEM.** This entry used to say "the
  managed standard library generally", and list `ArrayList` and `HashMap` alongside `Console` and
  `Thread`. That was wrong, and wrong in a way that cost real work: it sent people to reimplement
  collections by hand under a prohibition the compiler never enforced.

  The real test is not *"does this allocate"* — allocation has an answer bare metal, namely the
  program's own [`heap class`](#heap-class). It is *"does this reach for a host operating system"*,
  which has no answer at all. So the list is short, and the compiler now refuses exactly it, **at
  the `import`** rather than at the first use:

  `Console` · `File`/`Paths`/`Directory` · `Net`/`Socket`/`TcpClient`/`TcpListener` ·
  `Process`/`Env`/`Subproc`/`Conpty` · `Time` · `Thread`/`Task`/`Channel`/`Mutex`/`Semaphore`/`Latch`
  · `String`/`StringBuilder` · `Test`

  Everything else works. `ArrayList<T>`, `HashMap<K, V>` and the rest of the collections compile in a
  freestanding program and link against your `heap class`; `System.Memory.Buffer` — a library class
  with a contract on every access and a destructor — works, and so do `Math`, `Raw`, `Allocator`, the
  unit literals, `Result`/`Option`, and every value type.

  This is the same split C++ makes: a freestanding implementation drops `<iostream>`, `<fstream>` and
  `<thread>` and keeps the rest. LDP3 is in that position, not in C's.

  **`String` is on the list for now, and only for now.** It lowers to a family of eleven
  `__ldp3_str_*` symbols (copy, free, eq, hash, index, trim, upper, lower, repeat, ...) that no
  bare-metal runtime provides yet. They need nothing a kernel does not have — the program's heap and
  `memcpy` — so this is code nobody has written rather than a restriction. Until then, use a byte
  literal `b"..."` for fixed text and `byte*`/`byte[]` with the raw Memory API for text you build.

### What is kept — and this is the point

Freestanding LDP3 is not a toy subset. What survives is almost the entire *value* of the language:

- **Full OOP** — `class`, inheritance, `virtual`/`abstract`/`sealed`, `interface`, generics with
  constraints and variance, `struct` with bit fields, `record`, `union`, `enum`, `catalog`.
- **The chaos tetrad — `goto`, `comefrom`, `abstainfrom`, `reinstate`.** None needs the managed
  runtime: `goto`/`comefrom` are compile-time branches, and `abstainfrom`/`reinstate` are a single
  atomic global counter. `abstainfrom` is in fact a key power-management primitive for kernels and
  embedded code (disable a code path, re-enable it later).
- **Ownership — `move`, `movable`, `unique`, `partitionable`, `into`.** These are *compile-time
  only* disciplines with zero runtime cost, so they are essential for kernel devs who want
  ownership safety for free. (The contextual qualifiers `carrying`/`leaving`/`releasing` are the
  exception — they are removed, because they depend on persistents.)
- **Regions — `region`, `release region`, `itself`, `new ... in region`, including `at address`.**
  Type-safe manual memory with predictable layout; see the MMIO use below.
- **`comptime`** functions, `fixed` constants, `demand`, `layout`, and compile-time string DSLs.
- **The bit-counted numeric types — `int8`…`int64`, `uint8`…`uint64`, `float32`/`float64`, and
  `address`.** These are actually **freestanding-only**: in normal mode LDP3 uses the named types
  (`byte`/`short`/`int`/`long`, `smallfloat`/`float`/`double`, etc.) and the compiler *rejects* the
  bit-counted names. Freestanding is where exact widths matter — a hardware register is 32 bits,
  full stop — so that is where the bit-counted spellings live.
- Static `defer`, contracts (checked at compile time where possible), pattern matching, string
  interpolation without dynamic allocation, `volatile` fields, FFI with explicit calling
  conventions, and immutability-by-default.

A couple of runtime *rules* also tighten up: arrays keep bounds checking on by default (opt out
per hot path), and integer overflow simply wraps (no automatic checking) — with `checked(...)`
available where you want it back.

### Declaring freestanding and how it is enforced

You can pass `--freestanding` on the command line, but the robust way is to declare it in the
source, so the requirement travels with the code. A `program` or a `bundle` can be marked
`freestanding`, and the compiler then rejects any non-freestanding feature *even without the
flag* — you cannot accidentally reach for the managed runtime.

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
                msg[0] = 79;   // 'O'
                msg[1] = 75;   // 'K'
                msg[2] = 10;   // '\n'
                for (mutable int i = 0; i < 3; i++) {
                    Sys.putchar(msg[i]);          // I/O via FFI, not the managed Console
                }
                Memory.free(buf);
                return 0;
            }
        }
    }
}
```

Try to use the managed console, `async`, exceptions, `unimport`, or reflection inside a
freestanding unit and the compiler stops you with a message that names the feature and the spec
section. For example, `System.IO.Console.println(...)` becomes *"Console (managed stdlib) is not
available in freestanding mode; use FFI for I/O."*

And because the tetrad is kept, the kernel power-management idiom works unchanged:

```ldp3
public static method tick(int mode) returns int {
    if (mode == 1) { abstainfrom body; }   // disable `body` from now on
    if (mode == 2) { reinstate body; }     // re-enable it
    label body;
    Sys.putchar(66);                        // 'B'
    return 0;
}
```

### `region at address` for memory-mapped I/O

The freestanding jewel is combining regions with fixed addresses. `itself.at(address, size)`
builds a region whose objects live at a *fixed* physical address — exactly what you need for a
memory-mapped hardware register or a framebuffer. `new ... in region` bump-allocates starting
there, with full type safety over the layout; `release region` frees only the region's small
header, never the fixed memory itself.

```ldp3
region hw = itself.at(mem, 256 bytes);      // `mem` here is a fixed hardware address
Cell* c = new Cell() in region hw;          // placed at that address, type-checked
c.v = 77;
release region hw;                           // frees the header only
```

A memory-mapped type should be a `struct`, not a `class`: a struct is a value type with a
predictable layout and no vtable, so its fields sit at exactly the hardware offsets. A class would
carry an `Object` vtable pointer at offset 0 and shift everything. This is the classic VGA text
buffer, straight out of the spec's minimal kernel:

```ldp3
public region vga_text = itself.at(0xB8000, 4000 bytes).accepts({VGAChar});

public struct VGAChar {
    public mutable uint8 character;
    public mutable uint8 attribute;
}
```

### Cross-compiling with `--target`

Finally, you tell the compiler *which machine* to emit for with `--target=<triple>`. For a hosted
program the default is the native host (e.g. `x86_64-windows`). For a real bare-metal target you
pass a triple whose OS field is `none`:

```
ldp3 build --freestanding --target=x86_64-unknown-none --output=kernel.elf
```

A bare-metal triple changes the entry point. A hosted program (even a freestanding one) still gets
an ordinary `main` that the C runtime calls. But when the triple contains `none`, there is no C
runtime to build an `argc`/`argv` array — so the compiler emits an entry named **`kmain`** that
your assembly boot stub calls directly, with nothing that needs libc. The result is a bare-metal
object (for `x86_64-unknown-none`) with predictable layout and no dynamic dependencies, ready to be
linked into a kernel image.

---

## 11.10 Putting it together

The three subjects of this chapter are really one subject seen from three distances. Builtins are
the primitives; FFI is how those primitives reach outward to existing native code; freestanding
mode is what remains when you take the operating system away — and it is *almost everything*,
because LDP3 was designed so that its abstractions (OOP, regions, ownership, comptime) cost nothing
at runtime and therefore survive the trip to bare metal. You can write a hardware driver as a set
of classes, guard its memory with type-safe regions at fixed addresses, prove its ownership at
compile time, and never once depend on a runtime that will not be there. That combination — full
OOP plus type-safe regions plus predictable layout, with no hidden machinery — is what LDP3 offers
that the older systems languages do not.
