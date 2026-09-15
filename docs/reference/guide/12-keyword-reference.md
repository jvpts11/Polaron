# 12. Keyword Reference

This chapter catalogs every reserved word Polaron recognizes. Each entry gives what the keyword does,
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
>   but the lexer reserves them as **hard keywords**. After `extern`, `cdecl` and its siblings name a
>   foreign *language*; `stdcall` and `fastcall` name C plus a 32-bit x86 convention.
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
```polaron
program HelloWorld;
```

#### `bundle`
**hard.** An independent compilation unit within a program; contains namespaces. May be declared `freestanding`.
```polaron
public bundle main { /* namespaces... */ }
public bundle kernel freestanding { /* ... */ }
```

#### `namespace`
**hard.** Logical organization inside a bundle; contains classes, interfaces, enums, and so on. Governs cross-namespace visibility (access requires `import`).
```polaron
public namespace game.entities { public class Player { } }
```

#### `class`
**hard.** Declares a class — the fundamental unit of OOP in Polaron.
```polaron
public class Dog { private string name; }
```

#### `interface`
**hard.** Declares an interface (a contract). May carry default methods.
```polaron
public interface Drawable { method draw() returns void; }
```

#### `struct`
**hard.** A value-type composite; supports bit fields (`field : N`).
```polaron
public struct PacketHeader {
    public mutable ubyte version : 4;
    public mutable ubyte kind : 4;
}
```

#### `record`
**hard.** An immutable DTO-style type; generates a constructor and equality from its positional parameters.
```polaron
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

#### `procedure`
**hard.** A transformer's member: the conversion itself. `static procedure from<Other>(Other value)
returns itself` names the SOURCE; `procedure into<Fahrenheit f>() returns Fahrenheit` names the target
and binds it, so the body fills that storage in. A procedure is not a method — it belongs to the
relation between two types rather than to either one — and the bound target is storage with no
constructor run over it yet, which is why the body IS its construction and why every field of it must
be assigned before the body ends.

#### `command`
**hard.** The third kind of member, beside `method` (behaviour of the instance) and `procedure`
(behaviour of the relation): **portable behaviour** — something a class hands out for somebody else
to run later.

```polaron
public command aboveFloor(int x) carries (int floor) into pack returns boolean {
    return x > pack.floor;
}
```

Naming it without calling it BUILDS one: `Gate.aboveFloor(10)` is a value carrying `floor = 10`,
and the value is called by naming it — `test(11)`. At namespace level the same word declares the
**role** an API takes, which is how a method can accept a command without naming any particular one:

```polaron
public command IntTest(int x) returns boolean;                    // the role
public static method count(int[] xs, IntTest* test) returns int;  // the API
```

A command satisfies a role when the signatures agree — neither side names the other. There is also
an inline form, written where the value is wanted, with the carried values on the line:
`command (int x) carries (int floor = 10) into pack returns boolean { return x > pack.floor; }`.

#### `readonly`
**hard.** On a method: it writes nothing — no field of its own, no field of anything it was handed,
no static, no output. Declared, and then checked through the whole call graph, so a body that writes
nothing itself but calls something that does is refused too.

```polaron
public readonly method area() returns int { return this.w * this.h; }
```

It is what makes a method callable from a `requires` or an `ensures`: a contract that could change
state would make the check part of the program's behaviour. It also lets the optimizer drop a
repeated call and hoist one out of a loop. A cache is a write, however invisible from outside — the
spelling for that is `lazy`.

#### `cold`
**hard.** On a method: this path is rarely taken. The body moves off the hot line and stops being
inlined into one — the inliner costs a method by its SIZE, which is a poor proxy when the bulk of it
runs once in a thousand calls.

```polaron
private cold method grow() returns void { ... }
```

There is no `hot`: hot is what the optimizer already assumes, so the word would spend a token and add
no fact. The same word also tags an `affinity cold { }` field group, which is about where fields sit
rather than where code sits.

#### `mustuse`
**hard.** On a type or a method: the answer is the point, so a statement that drops it is warned
about (`Polaron-0B19`). `Result` and `Option` carry it — a `Result` whose answer is thrown away is an
error nobody handled — and any type may.

```polaron
public mustuse class Ticket { ... }        // once, for every method that returns one
public static mustuse method reading() returns int { ... }   // or just this one
```

The valve is **`discard`** (soft): `discard theCall();` says the dropping was deliberate, at the line,
where a reader sees a decision rather than a missing diagnostic.

#### `carries`
**hard.** What a command holds: `carries (int minAge) into pack`. The list is the command's state,
copied when one is built, and reached inside the body through the name `into` gives it
(`pack.minAge`) — so a read of carried state never looks like a read of anything else. Capture is
impossible by grammar: a name from the surrounding scope that is not on this list is not in scope
inside the body.

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
**hard.** Belongs to the class, not an instance. Called via `ClassName.member` — **always**, including
from inside that very class, and the compiler refuses a bare `member(...)`. An instance method may be
written bare because `this` is its subject and the language supplies it; a static one has none, and an
action with no subject is the shape this language refuses. Where two classes share a short name, the
namespace is what separates them: `Text.Reader.parse(1)`.

#### `abstract`
**hard.** A class that cannot be instantiated directly; a body-less method that a concrete subclass must implement.

#### `final`
**hard.** Also a [universal prefix](#7-universal-prefixes). A method that cannot be overridden, or a class that cannot be extended.

#### `override`
**hard.** Mandatory when overriding an inherited method (from a class or interface).

#### `surveyed`
**hard.** On a method: the region binder does not derive this method's lifetime summary from its
body — a person did, and answers for it. Inside, the one refusal about a value the analysis cannot
*place* is suspended; every other refusal stays, so anything it can still prove wrong is still
refused. Outside, the boundary goes to the worst case: every reference parameter is treated as kept
and a reference result as a borrow of everything in reach.

The freedom is local and the suspicion is exported, which is the opposite of what an `unsafe` does —
marking a method costs its callers, not nobody. It is inherited: an override may only be `surveyed`
if the method it overrides is. Not on a destructor, which is where ownership is *declared* and read
from. See §5b.

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

#### `transformer`
**hard.** Declares a **transformer**: a named relation between types, holding the `procedure`s that
convert between them and any rule that comes with the conversion. `public mutual transformer TConverter`
declares one both ends may implement. A transformer is not a value and has no instances; it is the thing
two types agree about. By convention its name starts with `T` and reads as an agent noun — `TConverter`,
`TDescriber` — and the compiler warns when it does not.

#### `applies`
**hard.** `class Celsius applies TDescriber` — the type takes the transformer's behaviour. What the
transformer brings is written once and every type that applies it has it. Also used in a condition:
`when itself applies TName`.

#### `entrusts`
**hard.** `class Fahrenheit entrusts TConverter` — stronger than `applies`, and a different promise: it
hands the transformer the right to CONSTRUCT this type, filling its storage field by field, private ones
included. Only the type itself can agree to that, because only it knows what its invariants are. What
comes back is an ordinary object; nothing about it says it was built from outside.

#### `call`
**hard.** `call TName.procedureName(args)` — reaches the TRANSFORMER's own body rather than this type's
override of it. The word exists because there is no receiver to write to the left of the dot: a
transformer is not a value, so `TName.p()` would be a static call on a type that is not one. It means
*"my type replaced this, and I want the original anyway"*.

#### `var`
**hard.** Type inference — permitted **only** for local variables.

#### `is`
**hard.** A dynamic type check; returns a boolean.

#### `as`
**hard.** A reference cast/downcast between compatible types (checked at runtime).

#### `cast`
**hard.** An explicit cast with the type in `< >`, including numeric conversions (saturating, no UB).
```polaron
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
**hard.** Allocates an instance; the placement is optional (`on stack` / `on heap` / `on static` / `in region`), with sensible defaults (objects → stack, arrays → heap).

#### `delete`
**hard.** Frees memory allocated with `new`, running the destructor first.

#### `on`
**hard.** Specifies the allocation site: `on stack`, `on heap`, or `on static`.

`on static` is storage that is **part of the image**: an array whose length is known when it is compiled, laid out where every Polaron array is laid out, allocated by nobody. It is legal on a static field's initialiser, which is the only place where "before the program runs" names a moment.

```polaron
private static mutable byte[] room = new byte[1024]() on static;
```

It exists for the layer that has nothing to allocate *with* — the failure reporter a fired guard calls, an allocator's own free lists, a region's bootstrap pool. Those were C++ for exactly this reason: a file-scope array costs nothing and asks nobody. The trade is said out loud rather than hidden — **one buffer for the whole program**, so two users at once share it.

`on stack` on an ARRAY is not honoured and never was: the clause parsed, nothing read it, and the array went to the heap whatever was written. That is `Polaron-0B54` now instead of silence.

#### `in`
**hard.** Two uses: the region target of a `new` (`in region X`) and iteration in `for (x in coll)`.

#### `region`
**hard.** A native type: a named arena of memory with type-acceptance rules. Allocated via `itself.allocate(...)`.
```polaron
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

#### `reentrant`
**hard.** A member modifier: **this may be entered again while an earlier entry is still running.**

Two things follow from that one sentence, and both are checked: the method reaches **no storage
another activation could be inside** (the allocator has global mutable state you may have
interrupted mid-update), and it touches **no shared mutable state**.

`interrupt` is one case of it and is implicitly `reentrant` — the handler's bespoke list of
prohibitions is now one property with one checker. Naming the *reason* rather than a mechanism is
what makes it wider than a "does not allocate" marker: **it also catches the lock**, because a
`reentrant` method that takes a `Mutex` deadlocks against itself. `atomic<T>` stays legal, since a
single atomic instruction has no half-done state to interrupt.

**Viral.** Everything the method calls carries the obligation, including the destructor that runs at
the end of a scope — and the diagnostic names the path that reached the violation, because *"Ring
allocates"* is a fact about Ring while *"this reentrant method reaches it, via refill"* is the bug.

Not a universal prefix: `reentrant field` means nothing.

#### `shareable`
**hard.** A type safe to reach from **several threads at once**, so the region binder may hand it
across a thread boundary. A modifier and not a marker interface: it names no methods and dispatches
nothing, and under `dynamic` an `implements` clause would buy an eight-byte header and an
indirection for a property that generates no calls.

**It is checked, not trusted**, and the rule is decidable from the declaration alone — which is why
it needs no whole-program knowledge and travels in a `.polh`:

> legal when every mutable field is `atomic<T>`, or is itself `shareable` — or when the type is
> entirely immutable.

A bare permission would be a one-word hole in the no-UB principle: written over a type with a plain
mutable `int`, it is exactly the race the compiler otherwise refuses. This is the house pattern —
**you declare the intent and the compiler confirms it** — beside `override` declaring and the
hierarchy checking, and `layout` stating and the arrangement refusing.

#### `dynamic`
**hard.** *Decided at run time.* On a class it means the instance **carries its type**: a dispatch
pointer as field zero, eight bytes on every instance, and membership of the `Object` root — so it may
be held as an `Object`, asked `is`, and dispatched through.

Without it, **a class is its fields.** `class Pair { int a; int b; }` is eight bytes, not sixteen.
C++ hangs the same cost on a per-method `virtual` and lets the header appear as a side effect the
declaration never mentions; here one word says both *which bodies are chosen at run time* and *which
types are known at run time*, and a class that does neither pays for neither.

**Four kinds carry it without the word, because for them it is not a choice:** a class that `extends`
something (the base already decided), one that `implements` an interface (interface dispatch needs a
table to dispatch from), an `abstract` class (it exists to be inherited from), and a `region class`
or `heap class` (their instances are walked, and a run of objects that do not say what they are
cannot be).

**It is never inferred.** Using a class as an `Object*` without the word is a compile error naming
the word and the eight bytes, rather than the class being marked `dynamic` because the use was seen —
inference needs whole-program knowledge, breaks across a bundle boundary, and moves the cost away
from the declaration, which is the one property the design rests on.

#### `weak`
**hard.** A field that points at an object without owning it and without keeping it alive: `private weak
nullable Cell* watcher;`. When the object it refers to is deleted, the field reads as null rather than
as a pointer into freed memory — which is what makes an observer, a parent link or a cache safe to hold.
A weak slot is two pointers wide, not one (the reference plus the registration that lets the delete find
it), and it must be `nullable`, because becoming null is the whole point.

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
```polaron
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

#### `demand`
**hard.** A statement that settles a condition while the program is built: `demand <cond> otherwise
"why";`. The condition must be knowable then, and it must hold. Emits nothing.

#### `otherwise`
**hard.** Introduces the reason on a `demand`.

#### `layout`
**hard.** An interface for memory, implemented by a value aggregate: it says how the type arranges
itself. Its `onArrange` hook runs at build time and leaves nothing behind; implementing one lets the
compiler order the type's fields. See §6.14.

---

## 12. Concurrency

#### `async`
**hard.** Marks an asynchronous method; runs on a worker pool and may use `await`. **Removed in freestanding.**

#### `await`
**hard.** Suspends the async method until the awaited task completes. **Removed in freestanding.**

#### `synchronized`
**hard.** A critical section with an implicit mutex; the locked value is bound via `using`.
```polaron
synchronized (counter) using int& c { c = c + 1; }
```

---

## 12. FFI / interop

#### `extern`
**hard.** Declares an external function (FFI); may specify a calling convention and library.

#### `cdecl`
**hard** (spec 39 calls it contextual; the lexer reserves it). Says the foreign language of an `extern`
is C. Its siblings — `cppdecl`, `rustdecl`, `zigdecl`, `unknown <world>` and `syscall(<n>)` — are matched
as identifiers rather than reserved, so no program loses a name it was already using.

#### `stdcall`
**hard.** In `extern`, C with the 32-bit x86 stdcall convention: the callee cleans the stack and the
symbol is decorated `@N` — how Win32 is called on i686. Legal on any target; on x86-64, where the three
conventions are one ABI, it lowers exactly as `cdecl`.

#### `fastcall`
**hard.** As `stdcall`, with the fastcall convention: the first two integer arguments in ECX and EDX.

#### `unknown`
**hard.** `extern unknown <world> method …` — a raw ABI with no language behind it, for a binary whose
origin has to be stated rather than guessed. The world is required: a binary FORMAT (`pe`, `elf`,
`macho`, resolved per target) or a raw ABI outright (`win64`, `sysv`, `aapcs`). `unknown c` means "this
target's own C ABI", which is the portable answer and the one a C-facing export wants.

#### `naked`
**hard.** A method the compiler emits with no prologue and no epilogue — no frame set up, no registers
saved, no return sequence. The body is the whole function, which is why it is almost always `asm`. For
an entry point the hardware or another ABI jumps to, where the standard frame would be wrong before the
first instruction ran. Freestanding (spec 36).

#### `interrupt`
**hard.** `public interrupt(Trap t) returns void { … }` — a hardware interrupt handler. Freestanding, it
lowers to `x86_intrcc`: LLVM writes the save of every register the body clobbers, the `cld`, the pop of
a pushed error code, and the `iretq`. Hosted, the same declaration installs through `signal()`. One per
class: an interrupt vector has room for an address and nothing else, so the bound receiver waits in a
single slot.

#### `freestanding`
**hard.** Marks a `program`/`bundle` as freestanding (bare-metal): forbids async, exceptions, unimport, reflection, and the managed `Console`.

---

## 13. Compile-time, modules & imports

#### `comptime`
**hard.** Runs at compile time (a method/value/`if`). See also [prefixes](#7-universal-prefixes).

#### `literal`
**hard.** Declares a function as a numeric-literal suffix. Must be `comptime`, with exactly one parameter.

#### `fixed`
**hard.** Declares a **named compile-time constant** (`fixed T NAME = expr;`), at class or namespace
level — and, in a type-parameter list, marks a parameter that **binds at stamping**.

```polaron
public struct Grid<fixed T, fixed int R, fixed int C> {
    private mutable T[R * C] cells;              // the extent is part of the type
    public method get(int r, int c) returns T { return this.cells[r * C + c]; }
}
Grid<int, 2, 3> g;                                // two shapes are two types
```

`fixed int R` is a hole where a **number** goes — the thing a generic could not express, and the
reason a runtime-dimension matrix computes its index with a load, cannot be embedded as a field, and
accepts any matrix at all in `multiply`. Marked `fixed`, `R` participates in the type, the class is
monomorphized per value, and `R` is a literal in the body.

It is per parameter and does not spread: `<fixed T, int a>` marks the first only. A **bare** value
parameter is reserved for the runtime-bound extent that arrives later, and is refused today
(`Polaron-010B`) rather than quietly given the stamped meaning.

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
**hard.** A receiver bound to one of its instance methods — a command carrying that receiver, and
compiled as one, so dispatch through it stays virtual.
```polaron
Animal cat = new Cat() on heap;
IntMap* sp = methodref cat.speak;    // runs Cat.speak
```

> **`lambda` and `function` are gone.** A command replaces both: the baggage is declared rather than
> captured, and a callable's type is a role somebody named (`Predicate<T>`, `Comparer<T>`). Neither
> word is reserved any more — they are ordinary identifiers again. See 14.1 and 14.3.

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

```polaron
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
```polaron
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
| `methodptr` | type position | `methodptr<int, int>` — the address of code: one machine word, no environment, plain C ABI. `Class.method` without a call is one (static only). |
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
| `delegate` | field prefix: satisfy the interfaces by forwarding to this field | Composition instead of inheritance; a method the class writes wins. Compile-time only, so freestanding too. For a callable VALUE use a `command`, a `methodref`, or `methodptr<>` at the C border. |
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
