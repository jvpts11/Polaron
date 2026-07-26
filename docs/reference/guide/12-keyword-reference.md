# 12. Keyword Reference

This chapter catalogs every reserved word LDP3 recognizes. Each entry gives what the keyword does,
its **status**, and — where it clarifies — a short example. Use it as a lookup companion to the
preceding chapters, which explain each feature in depth.

**Source of truth.** What is *reserved today* comes from the compiler itself:
`src/lexer/lexer.cpp` + `src/lexer/token.h` (hard
keywords) and `src/parser` + `src/semantic/analyzer.cpp` (soft/contextual keywords and
semantically-resolved type names). Where the written spec and the implementation diverge, this
chapter documents what the compiler accepts today and flags the difference.

## How to read each status

| Status | Meaning |
|--------|---------|
| **hard** | Reserved in the lexer; can never be an identifier. |
| **soft (contextual)** | Tokenized as an identifier; becomes a keyword only in a specific parser context, and is a normal identifier elsewhere. |
| **type (semantic)** | Not a lexer keyword; a type name recognized by semantic analysis. |
| **freestanding-only** | Recognized, but usable only in freestanding mode. |
| **removed in freestanding** | A hard keyword in full mode; forbidden in freestanding mode. |
| **reserved (spec) — not yet implemented** | Appears in the spec/catalog, but the current compiler does not recognize it. Documented for completeness; do not rely on it. |
| **migrated to the stdlib** | Was a keyword in an older design; today it is a library type/method, not a reserved word. |

> **Spec-vs-implementation notes flagged in this chapter** (the spec wins on design; the
> implementation decides what compiles today):
> - A named compile-time constant uses **`fixed T NAME = expr;`**, not `const`. `const` appears in the
>   spec/catalog but is **not reserved** in the lexer.
> - `switch`/`case` uses `case V { ... }` (braces), per spec 7.3 — not the legacy `case V:` colon form.
> - `operator` uses `operator + (...)`, not the legacy `operator method +(...)`.
> - `cdecl`/`stdcall`/`fastcall`/`byCatalog`/`expecting`/`onFailure` are called "contextual" in spec 39,
>   but the lexer reserves them as **hard keywords**.
> - `yield` has two uses: the value of a `match`-expression arm (spec 16.2), and producing the
>   next element of a generator method that returns `Iterator<T>` (spec 22.6).

---

## Index

1. [Organization & structure](#1-organization--structure)
2. [Type members](#2-type-members)
3. [Visibility & modifiers](#3-visibility--modifiers)
4. [Inheritance & polymorphism](#4-inheritance--polymorphism)
5. [Types & type operations](#5-types--type-operations)
6. [Memory, ownership & resources](#6-memory-ownership--resources)
7. [Universal prefixes](#7-universal-prefixes)
8. [Control flow](#8-control-flow)
9. [Ranges & iteration](#9-ranges--iteration)
10. [Exceptions & contracts](#10-exceptions--contracts)
11. [Concurrency](#11-concurrency)
12. [FFI / interop](#12-ffi--interop)
13. [Compile-time, modules & imports](#13-compile-time-modules--imports)
14. [Managed runtime (persistents, unimport, hooks, chaos tetrad)](#14-managed-runtime)
15. [Primitive types & literals](#15-primitive-types--literals)
16. [Soft / contextual keywords](#16-soft--contextual-keywords)
17. [Reserved in the spec but not implemented](#17-reserved-in-the-spec-but-not-implemented)
18. [Identifiers reserved by the stdlib](#18-identifiers-reserved-by-the-stdlib)
19. [Freestanding mode — summary](#19-freestanding-mode--summary)
20. [Counts](#20-counts)

---

## 1. Organization & structure

#### `program`
**hard.** The outermost organizational unit; names the program. One declaration per root file.
```ldp3
program HelloWorld;
```

#### `bundle`
**hard.** An independent compilation unit within a program; contains namespaces. May be declared `freestanding`.
```ldp3
public bundle main { /* namespaces... */ }
public bundle kernel freestanding { /* ... */ }
```

#### `namespace`
**hard.** Logical organization inside a bundle; contains classes, interfaces, enums, and so on. Governs cross-namespace visibility (access requires `import`).
```ldp3
public namespace game.entities { public class Player { } }
```

#### `class`
**hard.** Declares a class — the fundamental unit of OOP in LDP3.
```ldp3
public class Dog { private string name; }
```

#### `interface`
**hard.** Declares an interface (a contract). May carry default methods.
```ldp3
public interface Drawable { method draw() returns void; }
```

#### `struct`
**hard.** A value-type composite; supports bit fields (`field : N`).
```ldp3
public struct PacketHeader {
    public mutable ubyte version : 4;
    public mutable ubyte kind : 4;
}
```

#### `record`
**hard.** An immutable DTO-style type; generates a constructor and equality from its positional parameters.
```ldp3
public record Point(int x, int y);
```

#### `union`
**hard.** A C-style union — the fields share the same storage (an alternative interpretation of the same bytes).

#### `enum`
**hard.** An enumeration. Simple form (ordinal constants) and Java-style form (fields, a constructor, methods).

#### `catalog`
**hard.** An interface for enums: requires the implementing enum to supply both methods **and** values.

#### `byCatalog`
**hard** (spec 39 lists it as contextual; the lexer reserves it). Inside an enum body, drives generation from a catalog.

---

## 2. Type members

#### `method`
**hard.** Declares a method. The keyword is mandatory. There is no overloading — one unique name per method.

#### `constructor`
**hard.** The special creation method; same name as the class.

#### `destructor`
**hard.** The special destruction method; syntax `~ClassName()`. Runs via RAII at the end of a stack object's scope, or on `delete`.

#### `operator`
**hard.** Declares an operator overload. Spec syntax: `operator <op> (...)` (no `method`).

#### `returns`
**hard.** Introduces a method's / constructor's return type.

#### `return`
**hard.** Returns from a method, with or without a value.

---

## 3. Visibility & modifiers

#### `public`
**hard.** Accessible from anywhere.

#### `private`
**hard.** Accessible only within the declaring class.

#### `protected`
**hard.** Accessible by the class and its subclasses.

#### `internal`
**hard.** Accessible only within the same bundle.

#### `static`
**hard.** Belongs to the class, not an instance. Called via `ClassName.member`.

#### `abstract`
**hard.** A class that cannot be instantiated directly; a body-less method that a concrete subclass must implement.

#### `final`
**hard.** Also a [universal prefix](#7-universal-prefixes). A method that cannot be overridden, or a class that cannot be extended.

#### `override`
**hard.** Mandatory when overriding an inherited method (from a class or interface).

#### `mutable`
**hard.** Allows reassignment/mutation. Everything is immutable by default; use `mutable` only where a value is actually reassigned.

#### `nullable`
**hard.** Marks a type as possibly `null`. Declaration-only: the check happens at assignment (no flow narrowing); dereferencing a null value traps deterministically.

#### `sealed`
**hard.** Restricts subclasses to those listed in `permits`; enables exhaustive `match` with no `default`.

#### `permits`
**hard.** Lists the allowed subclasses of a `sealed` class.

#### `partial`
**hard.** A class declared in several parts (across files); the compiler merges them into one type.

#### `deprecated`
**hard.** Marks a declaration as deprecated; using it raises a compiler warning.

---

## 4. Inheritance & polymorphism

#### `extends`
**hard.** Class inheritance (or an enum extending a catalog).

#### `implements`
**hard.** Interface (or catalog) implementation.

#### `this`
**hard.** A reference to the current instance. `this.` is **mandatory** to access one's own members.

#### `super`
**hard.** A reference to the superclass: `super(args)` in the constructor and `super.method()` to call the base implementation.

---

## 5. Types & type operations

#### `var`
**hard.** Type inference — permitted **only** for local variables.

#### `is`
**hard.** A dynamic type check; returns a boolean.

#### `as`
**hard.** A reference cast/downcast between compatible types (checked at runtime).

#### `cast`
**hard.** An explicit cast with the type in `< >`, including numeric conversions (saturating, no UB).
```ldp3
uint crc = cast<uint>(4294967295);
```

#### `null`
**hard.** The absence-of-value literal; valid only for `nullable` types.

#### `typealias`
**hard.** A type alias (no new identity).

#### `newtype`
**hard.** A wrapper with its own type identity (distinct from the underlying type).

---

## 6. Memory, ownership & resources

#### `new`
**hard.** Allocates an instance; the placement is optional (`on stack` / `on heap` / `in region`), with sensible defaults (objects → stack, arrays → heap).

#### `delete`
**hard.** Frees memory allocated with `new`, running the destructor first.

#### `on`
**hard.** Specifies the allocation site: `on stack` or `on heap`.

#### `in`
**hard.** Two uses: the region target of a `new` (`in region X`) and iteration in `for (x in coll)`.

#### `region`
**hard.** A native type: a named arena of memory with type-acceptance rules. Allocated via `itself.allocate(...)`.
```ldp3
region pen = itself.allocate(64 kilobytes);
Dog* a = new Dog(5) in region pen;   // freed by RAII at scope end
```

#### `of`
**hard.** Region disambiguation when declaring a pointer/variable.

#### `accepts`
**hard.** Lists the types a region accepts (`.accepts({...})`).

#### `rejects`
**hard.** Lists the types a region rejects.

#### `itself`
**hard.** The self-reference pronoun in a declaration's initializer — refers to the entity being declared (e.g. a region allocating its own backing memory).

#### `release`
**hard.** Frees a persistent or a region (`release region r;`). `release region` is **available in freestanding** (regions are freestanding-safe); the persistent form is not, since persistents do not exist there.

#### `move`
**hard.** Transfers ownership between variables, regions, or disciplines; invalidates the source.

#### `movable`
**hard.** A class discipline: requires an explicit `move` to transfer ownership; a plain assignment is an error.

#### `unique`
**hard.** A class discipline: at most one live reference at a time; assignment is an implicit move, and copying is forbidden.

#### `partitionable`
**hard.** A class modifier allowing individual fields to be moved out (opt-in via `into`). Contradictory with `unique`.

#### `persistent`
**hard.** A field that outlives its parent object's destructor; reattaches automatically by identity. **Removed in freestanding.**

#### `transient`
**hard.** A non-serializable field (excluded from snapshots/serialization).

#### `eternal`
**hard.** Also a [universal prefix](#7-universal-prefixes). A resource that lives for the whole program run (no cleanup).

#### `defer`
**hard.** Defers a block to the end of the current scope (LIFO order); also runs during exception unwind.
```ldp3
defer { file.close(); }
```

#### `using`
**hard.** The bound variable in `synchronized`, and scoped resource disposal. **Removed in freestanding.**

#### `external`
**hard.** A field modifier marking a **non-owned** association — `cascade` does not follow it.

---

## 7. Universal prefixes

#### `cascade`
**hard.** Propagates an operation recursively across the target's owned dependencies/fields (delete, clone, move, and so on).

#### `eternal`
**hard.** Program-lifetime. See §6.

#### `lazy`
**hard.** Defers execution/initialization until first access (implicitly thread-safe). **Removed in freestanding.**

#### `comptime`
**hard.** Runs at compile time; zero runtime overhead. See §13.

#### `volatile`
**hard.** Not optimizable by the compiler; reads/writes always happen for real (MMIO).

#### `final`
**hard.** Not modifiable/overridable/removable. See §3.

---

## 8. Control flow

#### `if` / `else`
**hard.** Conditional with mandatory braces; `else if` chains.

#### `while`
**hard.** A top-tested loop.

#### `do`
**hard.** A do-while loop: runs at least once, tests at the end.

#### `for`
**hard.** The classic three-clause `for` and the for-in over ranges / collections
(`for (int x in items) { ... }`). See `in`, `index`, `step`.

#### `foreach`
**hard.** Iterates a range or collection: `foreach (int x in items) { ... }`. A C#-style
spelling of the for-in loop; `for (x in items)` and `foreach (x in items)` are both accepted.
See `in`, `index`, `step`.

#### `switch`
**hard.** A switch with fall-through. **Braces are mandatory on each `case`** (spec 7.3).

#### `case`
**hard.** A `switch` or `match` clause. In `match` it can destructure positionally.

#### `default`
**hard.** The default clause of `switch`/`match`.

#### `break`
**hard.** Exits the current loop/switch (supports a label).

#### `continue`
**hard.** Advances to the loop's next iteration (supports a label).

#### `match`
**hard.** Exhaustive pattern matching on dynamic type (statement form, and an expression form with `->`).

#### `yield`
**hard.** Two uses: the value of a block arm in a `match` expression (spec 16.2); and, inside a
method that returns `Iterator<T>`, producing the next element of a generator (spec 22.6) — the
compiler lowers such a method to a state machine.

#### `goto`
**hard.** A jump to a `label` (intra-method; also goto-address in freestanding). Part of the "chaos tetrad". **Available in freestanding.**

#### `label`
**hard.** Marks a statement as the target of `goto`/`comefrom`/`abstainfrom` (`label name;`).

#### `comefrom`
**hard.** The inverse interception of `goto`: declared at the destination, so reaching the label diverts control. Intra-method scope. **Available in freestanding** (a compile-time branch).

#### `abstainfrom`
**hard.** Disables a label and the block it introduces (reference-counted; `reinstate` re-enables it). Intra-method scope. **Available in freestanding** (a global atomic counter, no runtime).

#### `reinstate`
**hard.** Re-enables a label previously disabled with `abstainfrom`. Intra-method scope. **Available in freestanding.**

---

## 9. Ranges & iteration

#### `step`
**hard.** A custom stride in a range (`a..b step n`).

#### `index`
**hard.** Exposes the index in a for-in loop.

---

## 10. Exceptions & contracts

#### `try`
**hard.** A protected block. **Removed in freestanding.**

#### `catch`
**hard.** Catches an exception. **Removed in freestanding.**

#### `finally`
**hard.** A block always executed (with or without an exception). **Removed in freestanding.**

#### `throw`
**hard.** Throws an exception. **Removed in freestanding.**

#### `throws`
**hard.** Declares the exceptions a method may throw. **Removed in freestanding.**

#### `requires`
**hard.** A precondition (contract), validated on method entry.

#### `ensures`
**hard.** A postcondition, validated on exit. Accepts `old(...)` for the prior value (a soft keyword).

#### `invariant`
**hard.** A class invariant, checked before/after every public method.

#### `static_assert`
**hard.** An assertion validated at compile time.

---

## 12. Concurrency

#### `async`
**hard.** Marks an asynchronous method; runs on a worker pool and may use `await`. **Removed in freestanding.**

#### `await`
**hard.** Suspends the async method until the awaited task completes. **Removed in freestanding.**

#### `synchronized`
**hard.** A critical section with an implicit mutex; the locked value is bound via `using`.
```ldp3
synchronized (counter) using int& c { c = c + 1; }
```

---

## 12. FFI / interop

#### `extern`
**hard.** Declares an external function (FFI); may specify a calling convention and library.

#### `cdecl`
**hard** (spec 39 calls it contextual; the lexer reserves it). The C calling convention in `extern`.

#### `stdcall`
**hard.** The Windows stdcall calling convention in `extern`.

#### `fastcall`
**hard.** The fastcall calling convention in `extern`.

#### `freestanding`
**hard.** Marks a `program`/`bundle` as freestanding (bare-metal): forbids async, exceptions, unimport, reflection, and the managed `Console`.

---

## 13. Compile-time, modules & imports

#### `comptime`
**hard.** Runs at compile time (a method/value/`if`). See also [prefixes](#7-universal-prefixes).

#### `literal`
**hard.** Declares a function as a numeric-literal suffix. Must be `comptime`, with exactly one parameter.

#### `fixed`
**hard.** Declares a **named compile-time constant** (`fixed T NAME = expr;`), at class or namespace level.

#### `import`
**hard.** Loads a symbol (class, namespace, bundle) into the program. The stdlib requires explicit imports.

#### `annotation`
**hard.** Declares a custom annotation (metadata for classes/methods/fields).

---

## 14. Managed runtime

Persistents, unimport, lifecycle hooks, and the chaos tetrad.

#### `unimport`
**hard.** Removes a symbol from memory at runtime (unloads its code). **Removed in freestanding.**

#### `reimport`
**hard.** Reloads, at runtime, a previously `unimport`ed symbol (reloads its code from the executable on disk). **Removed in freestanding.**

#### `expecting`
**hard** (spec 39 calls it contextual). An authenticity-validation block on import/unimport. **Removed in freestanding.**

#### `onFailure`
**hard.** The mandatory block fired when an `expecting` validation fails. **Removed in freestanding.**

#### `methodref`
**hard.** A bound method reference (spec 22.3).

#### `lambda`
**hard.** An anonymous function with explicit capture.
```ldp3
function<int> f = lambda[captures: byvalue n]() returns int { return n + 1; };
```

#### `function`
**hard, reserved.** Reserved by the lexer for function/reference types, used in type positions.

---

## 15. Primitive types & literals

The core primitive type names (also keywords). Normal mode uses these:

| Type | Meaning |
|------|---------|
| `byte` | signed 8-bit integer (equivalent to `int8`) |
| `short` | signed 16-bit integer |
| `int` | signed 32-bit integer |
| `long` | signed 64-bit integer |
| `float` | 32-bit floating point |
| `double` | 64-bit floating point |
| `boolean` | `true` / `false` |
| `char` | a character |
| `void` | absence of a return type |
| `string` | a mutable string |
| `String` | an immutable string (a class) |

```ldp3
int n = 42;
double d = 3.14;
char c = 'X';
boolean ok = true;
mutable string buf = "hi";
```

#### Semantically-resolved type names (not lexer keywords)

`ubyte`, `ushort`, `uint`, `ulong` (unsigned 8/16/32/64), plus `smallfloat` (16-bit) and `quadruple`
(128-bit), are **type names** recognized by semantic analysis rather than reserved words.

#### Bit-counted names (hard keywords, **freestanding-only**)

`int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `float32`, `float64`. In
normal mode, using them is an error (the compiler suggests `byte`/`short`/`int`/`long`/`ubyte`/…/
`float`/`double`).
```ldp3
// only inside a freestanding bundle:
uint8 version = 4;
float32 x = 1.0;
```

#### Boolean literals

- **`true`** (hard) — the boolean true literal.
- **`false`** (hard) — the boolean false literal.

> Other literals (not keywords): integers in several bases, floats (`1.5`), `Decimal` (the `m`
> suffix, e.g. `1.50m`), chars (`'x'`), strings (`"..."`), and interpolation (`$"x = {expr}"`).

---

## 16. Soft / contextual keywords

Tokenized as identifiers; they become keywords only in the context shown, and are ordinary
identifiers elsewhere.

| Word | Context | Use |
|------|---------|-----|
| `get` | property body | `public int age { get; }` |
| `set` | property body | `public int age { get; set; }` |
| `init` | property body | `public string key { get; init; }` |
| `from` | `import`/`move` | `import Dog from bundle pets;` / `move c from region a to region b` |
| `to` | `move` | `move c to region prod` |
| `into` | `move` | `move c1 into region prod` |
| `out` | generic type-parameter position | `interface Producer<out T> { }` (covariance) |
| `old` | inside `ensures(...)` | `ensures(this.n == old(this.n) + 1)` |
| `carrying` | `move` qualifier | `move c1 carrying persistents` (default) |
| `leaving` | `move` qualifier | `move c1 leaving persistents` |
| `releasing` | `move` qualifier | `move c1 releasing persistents` |
| `onClassLoad` | class body (hook) | `onClassLoad { init(); }` |
| `onFirstInstance` | class body (hook) | `onFirstInstance { setup(); }` |
| `onLastInstanceDestroyed` | class body (hook) | `onLastInstanceDestroyed { teardown(); }` (removed in freestanding) |
| `onClassUnload` | class body (hook) | `onClassUnload { cleanup(); }` (removed in freestanding) |
| `asm` | `asm("arch") { ... }` | an inline assembly block; a normal identifier otherwise |
| `funcptr` | type position | `funcptr<int, int>` — a bare C function-pointer type for dynamic FFI |
| `named` | `requires named` | `requires named` — a parameter that must be passed by name |
| `explicit` | conversion operator | `explicit operator Foo(...)` — an explicit-only conversion (spec 6.6) |
| `implicit` | conversion operator | `implicit operator Foo(...)` — an implicit conversion (spec 6.6) |
| `bidirectional` | type declaration | a type with a two-way conversion pair (spec 32.6) |
| `affinity` / `hot` / `cold` | `affinity { ... }` block | field layout / cache-locality hints (spec 32.9) |
| `within` | `defer within ...` | `defer within 5 seconds { ... }` — a deferred action with a timeout (spec 32.10) |
| `library` | `extern` clause | `extern ... library "name"` — names the native library to link |
| `bump` / `pool` / `stack` / `fixedslot` / `ring` | `region` declaration | the region's allocator flavor (spec 17.11); default is `bump` |
| `growable` | `region` declaration | a region that chains a new block when the current one is full |
| `mark` / `rollback` | region ops | `mark of region R` / `rollback region R to m` (stack regions) |
| `extract` | `extract X from region R` | relocate an object out of a region onto the heap |

> `carrying`/`leaving`/`releasing` are **removed in freestanding** (they depend on persistents).
> The contextual type names (`ubyte`/`ushort`/`uint`/`ulong`/`smallfloat`/`quadruple`/`address`) are
> covered in [§15](#15-primitive-types--literals) and [§19](#19-freestanding-mode--summary).

---

## 17. Reserved in the spec but not implemented

These words appear in the spec and/or the legacy catalog, but the current compiler does **not**
recognize them (they are neither in the lexer nor handled by the parser/semantic layers). Documented
for completeness — they do not work today.

| Word | Documented intent | Situation |
|------|-------------------|-----------|
| `const` | compile-time constant | **Replaced by `fixed`** in the implementation; `const` is not reserved. |
| `module` | future organizational unit | Reserved in the spec only; not implemented. |
| `package` | future package system | Reserved in the spec only; not implemented. |
| `delegate` | a method-reference type | Not implemented — use `methodref`/`lambda`. |
| `force` | an `unimport` modifier | Contextual in the spec; not recognized. |
| `timeout` | an `unimport` modifier | Not recognized as an unimport keyword (exists only as a `Channel.select` method). |
| `serializable` | marks something serializable | Documented; not recognized. |
| `version` | bundle versioning | Reserved in the spec only; not implemented. |
| `checked` / `saturating` / `wrapping` / `unchecked` | arithmetic modes | `checked(expr)` exists as a **builtin**, not a keyword; the others became stdlib methods. |

> **Migrated to the stdlib** (not keywords in any mode): `thread`, `channel`, `select`, `snapshot`,
> `restore`, `reverse`, `reversible`, `forward`, `backward`, `witness`, `assert`, `tests`,
> `saturating`, `wrapping`, `unchecked`, `allocate`, `at`, `kilobytes`, `megabytes`.

---

## 18. Identifiers reserved by the stdlib

Not technically keywords, but the stdlib reserves them; do not use them as identifiers.

- **`System`** — I/O and system: `System.IO.Console.println(...)`, `System.exit(code)`,
  `System.Memory.Units` (size suffixes).
- **`Console`** — the I/O shortcut: `Console.println(x)`, `Console.print(x)`, `Console.printf(...)`
  (requires `import System.IO.Console`).
- **`Memory`** — low-level operations (freestanding): `Memory.read<T>(addr)`,
  `Memory.write<T>(addr, v)`, `Memory.alloc`/`free`/`zero`/`copy`.

---

## 19. Freestanding mode — summary

Freestanding mode (spec 36) removes the keywords that depend on the managed runtime and unlocks the
bit-counted type names.

**Removed (hard keywords forbidden in freestanding):**
```
async  await  catch  finally  lazy  persistent
throw  throws  try  unimport  reimport  using
expecting  onFailure
onClassUnload  onLastInstanceDestroyed
```
Plus the contextual persistent-move qualifiers `carrying`, `leaving`, `releasing`.

**Kept and essential:** the ownership disciplines (`move`, `movable`, `unique`, `partitionable`,
`into`), `itself`, `literal`, `region` / `release region` / `accepts` / `rejects`,
`extern`/`cdecl`/`stdcall`/`fastcall`, **the chaos tetrad** (`goto`/`label`/`comefrom`/`abstainfrom`/
`reinstate` — compile-time branches plus a global atomic counter, no runtime), bit fields, and —
**freestanding-only** — the bit-counted names (`int8`…`float64`) and the `address` type (a raw memory
address; int↔pointer casts).

---

## 20. Counts

Design counts per the spec; the current implementation reserves a slightly different subset (see §17
for the divergences).

| Category | Count (spec) |
|----------|--------------|
| Core keywords | 133 |
| Contextual keywords | 13 |
| Primitive types (also keywords) | 20 |
| Freestanding mode | 112–115 keywords |

> **Accuracy note.** This is the canonical keyword reference: it lists what the compiler
> **recognizes today** (lexer + parser + semantic), which is the authority on the language's
> keywords. It is kept in sync with the compiler as the language evolves.
