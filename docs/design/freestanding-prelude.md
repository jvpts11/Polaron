# A standard library for bare metal — proposal

> **Status.** A proposal, not a design. The decision it asks for is **scope**, not syntax: no new
> keyword appears anywhere in it.

---

## 1. What is missing

**AP-19** — *an object language needs a runtime before `main`* — **falls by every margin**: eleven
bytes, no undefined symbols, byte-identical to C. The ledger's entry is not about that; it is about
what is left once the objection is answered:

> `System` assumes a hosted world. A bare-metal program has to hand-write text and framebuffer
> output, port I/O, descriptor tables, memory operations and serial — **every time**. `pico` has
> written a great deal of it and nobody else can use any of it.

`kernel/kernel.pol` in this tree is the shape of the problem: **39 lines**, of which the interesting
part is casting `0xB8000` to an `int16*` by hand and writing character-plus-attribute pairs into it.
It boots under QEMU, which is the point — but every kernel after it starts by writing those lines
again.

## 2. What exists today: a gate with nothing on the other side

The freestanding mode works by **refusal**. From `src/cli/main.cpp`:

> *"half a dozen checks ask whether a declaration came from the standard library by looking at its
> file — **the freestanding gate most of all, which refuses `StringBuilder`, `Console` and `Paths` to
> user code** and must not refuse the library its own."*

So a freestanding program loads the same prelude and is told what it may not have. Nothing is offered
in its place.

## 3. The proposal is not "write a second library"

The obvious reading of the ledger row is: build a bare-metal `System`. That is the wrong shape, and
looking at the prelude says why.

**There are three tiers, and today only one line is drawn.**

| tier | needs | examples |
|---|---|---|
| **core** | nothing — no heap, no OS, no privilege | `Result`, `Option`, `Slice<T>`, bit and math primitives, algorithms over arrays, `Comparable`, `entity` |
| **hosted** | a heap and an operating system | `String`, `Console`, growing collections, `File`, `Net`, threads |
| **bare** | privilege and hardware | port I/O, descriptor tables, paging, framebuffer, serial |

Today the line sits between **hosted** and *nothing*, so the **core** tier is trapped inside the
hosted prelude and a kernel re-writes things that already exist. The bare tier does not exist at all.

**So the work is two-thirds sorting and one-third writing.**

### 3.1 How much is already core — measured, with the proxy's limits stated

Counting per prelude file how many sites use `on heap`, name `String`, or use a growing collection:

| file | `on heap` | `String` | collections |
|---|---|---|---|
| `Errors.pol` — **`Result`/`Option`** | 0 | 0 | 0 |
| `Memory.pol` | 0 | 0 | 0 |
| `Science.pol` | 0 | 0 | 0 |
| `Ecs.pol` | 0 | 0 | 0 |
| `Algorithms.pol` | 0 | 1 | 1 |
| `Arrays.pol` | 0 | 1 | 2 |
| `Spatial.pol` | 5 | 0 | 0 |
| `Units.pol` | 35 | 0 | 0 |
| `Concurrency.pol` | 11 | 0 | 0 |

**Four files are already clean and two are one or two sites away.** `Result`/`Option` in particular
are heap-free, String-free and collection-free — which matters because they are what the freestanding
diagnostic *tells* people to use instead of `throw`.

> **What this proxy does not measure**, said because a number is only worth its method: `on heap` is a
> spelling, not a semantic. A file with zero of them may still allocate through a call, and a file
> with many may allocate only in one type nobody bare-metal would touch — `Math.pol` has 46, and they
> are almost certainly `BigInteger` and `Decimal` rather than the trigonometry beside them. The real
> answer comes from the `reentrant` checker (`docs/design/reentrant.md`), which is semantic and
> viral; this table only says the sorting is worth doing.

## 4. What goes in the bare tier

A bundle of its own, **`Machine`** — **DECIDED**. `import Machine.Serial;` rather than `System.*`,
because the distinction is the point and a namespace under `System` would blur it.

| | what it is | why it is first |
|---|---|---|
| `Machine.Port` | `in8/16/32`, `out8/16/32` | everything else on x86 goes through it |
| `Machine.Serial` | 16550 UART | how a kernel says anything at all before video works |
| `Machine.Screen` | VGA text buffer, linear framebuffer | the `0xB8000` cast, once, with a type |
| `Machine.Memory` | `set`, `copy`, `compare`, physical-address helpers | the compiler already bridges these for freestanding |
| `Machine.Format` | integers and hex into a caller's buffer | a kernel prints without a `String` and today writes the digit loop by hand |

A second cut, deliberately not first, because each is large and each is deeply architecture-shaped:
**descriptor tables** (GDT/IDT/TSS), **paging**, **interrupt controllers** (PIC/APIC), and a
**spinlock** — `Mutex` needs a scheduler, and before there is one a kernel needs the thing under it.

## 5. The two things that make this a *library* and not a subset

**No heap and no `String`.** Text output takes a `char[]` or a `Slice<char>`, never a `String`.
Formatting writes into a caller's buffer and returns how many bytes it wrote. Nothing returns an
object it allocated. This is not a restriction imposed on the library — it is what makes it usable at
all, and it is the reason a bare `Console` cannot simply be the hosted one with the file layer
removed.

**Most of it is `reentrant`.** A serial write can be called from an interrupt handler; so can a
formatter. With `reentrant` (`docs/design/reentrant.md`) that stops being a convention and becomes a
declaration the compiler checks — and, being viral, it checks the whole library at once rather than
one method at a time.

## 6. Architecture — and the answer is a construct we already designed

Port I/O is x86. `aarch64` has memory-mapped registers instead. So `Machine` is partitioned by
architecture, and the target is already declared: `--target=x86_64-unknown-none`.

The selection wants to be `comptime if` over the target — which is exactly what the generalised
`comptime` gives (`docs/design/layout.md` §10), including the rule that matters here: **the untaken
branch parses and is not analysed**, so the aarch64 arm may name registers x86 does not have and
vice versa. That case was named as the motivation for the rule; this is it.

## 7. How it is selected

Three ways, and the third is the one that fits what the language already does:

| | |
|---|---|
| the compiler swaps preludes on `freestanding` | invisible, and makes `freestanding` mean two things |
| both always load and the gate refuses | today's mechanism, and it would let a hosted program name `Port.out8`, which faults in userspace |
| **explicit imports, and `Machine` is available only in a freestanding program** | matches `ldp3-stdlib-imports-explicit` — the stdlib already requires an import — and puts something on the other side of the gate that already exists |

The third. The gate stops being only a refusal and becomes a choice of library.

## 8. What this is worth

`pico` is the reason. A complete unix-like operating system with zero C is the project's founding
goal, and every line of hardware access it has written is currently unreachable by anyone else — and
unreachable by the compiler's own test suite, which is why `kernel/kernel.pol` is 39 lines of raw
casts rather than 39 lines of a library being exercised.

It is also what turns AP-32 from an argument into a demonstration: *"nobody has done it"* is answered
by a kernel that boots, and a kernel that boots **on a standard library** is a different claim from a
kernel that boots on hand-written casts.

## 9. The decision this asks for — made (Wave 4.5)

**Scope, in three parts. All three are settled:**

1. **The three-tier split is accepted** — core / hosted / bare, with the core tier lifted out of the
   hosted prelude so a freestanding program can have it.

   **Because the tiering already exists and is done wrongly.** §2 quotes the gate: half a dozen
   checks ask *which file did this declaration come from*. That is a tier boundary — an unnamed one,
   drawn along the file system, enforced by refusal. `Result` and `Option` are on the wrong side of
   it for no reason anybody chose; they are there because they happen to live in a file the gate
   rejects. Accepting the split does not introduce a boundary, it **names the one already being
   enforced** and turns a refusal into an offer.

2. **The first cut is the five in §4**, with descriptor tables, paging, interrupt controllers and
   the spinlock deliberately second.

   **Because the order is the boot order.** `Port` is under everything else on x86; `Serial` is how
   a kernel says anything at all before video works — including how it reports that the descriptor
   tables it just loaded were wrong. Putting the second cut first means debugging paging with no way
   to print. And the four held back are each large *and* each deeply architecture-shaped, so each is
   a design of its own; the five are small and nearly architecture-free, which is what makes them a
   first cut rather than a first instalment.

3. ~~The bundle name~~ — **`Machine`. Decided.**

## 10. Decided (Wave 4.5)

### 10.1 `src/prelude/machine/`, a sibling of `lib/`

**Decided.** The tier has to be visible **where the gate looks**, and the gate looks at the file path
(§2). A `Machine` bundle scattered through `lib/` would be a tier the language knows about and the
compiler's own checks cannot see — which is today's failure exactly, inverted. The directory is not
organisation; it is the thing being tested.

### 10.2 Core is a bundle of its own, and `System` keeps its names by `typealias`

**Decided**, and the document had already said which answer was right: *"the second is less
disruptive and less honest."* When those are the two axes, honesty wins — the disruption is one-off
and the dishonesty is permanent. A `System.Errors.Result` usable with no operating system under it is
a name that lies about its tier every time anybody reads it.

**The disruption is then paid off rather than accepted**, with a word the language already has.
`Core` owns the declarations; `System` declares a `typealias` for each name it used to own. Existing
`import System.Errors.Result` keeps compiling, `import Core.Result` works in freestanding, and there
is exactly one definition. No re-export mechanism has to be invented — which matters, because
inventing one was the other reading of "less disruptive".

### 10.3 Answered — four of five lift, and Horizon is the measurement

The item read *"cannot be answered from this tree, because `pico` is not in it."* It is answerable:
`pico` is **Horizon**, and it is **678 Polaron files, 102 358 lines** of exactly this code.

| §4 entry | in Horizon | liftable? |
|---|---|---|
| `Machine.Port` | port I/O under `Cpu`, `src/arch/` | yes — it is `in`/`out` and nothing else |
| `Machine.Serial` | `src/arch/serial.pol`, **224 lines** | **yes, as it stands** |
| `Machine.Screen` | `framebuffer.pol` (153), `textconsole.pol` (52), `graphicsconsole.pol` (310) | the first two; the third is a console, not a screen |
| `Machine.Memory` | `src/memory/memorymap.pol`, `memoryregion.pol` | yes |
| `Machine.Format` | the digit loops, written by hand at each site | **no — this is the one to write** |

**`serial.pol` names nothing hosted**: no `String`, no `on heap`, no import of anything at all. §5
says the two things making this a library rather than a subset are no heap and no `String` — and a
driver written under the freestanding gate has already been forced to satisfy both. **The gate that
refused these programs a library is what made their code liftable**, which is worth saying because it
is the one good thing about the present arrangement and it stops being true the moment the library
exists.

Four lifted, one written — and the one to write is `Format`, which is also the one every kernel
currently re-writes as a digit loop. Not a coincidence: **what nobody could share is what nobody
had.**

### 10.4 It is what happens, not a program-level statement

**Decided.** A freestanding program with no heap does not declare *no allocation anywhere*. It
declares no `heap class`, and then every allocation site has nothing to call.

**Because the statement would be a second way of saying something already said.** §36 makes
`heap class X` the program's allocator and exactly one exists per program; a program declaring none
has no allocator, so `new T() on heap` in it is already an error — one that names the missing
declaration, which is a better message than a mode flag could give. A program-level `noheap` would
have to agree with the absence of a `heap class` in every case, and **two facts that must agree are
one fact and one opportunity to disagree.**

This is `reentrant.md` §10.5's answer seen from the other side, and the two now match: `reentrant` is
a property of a **method** and stays one. *Every method is reentrant* is not declared — it is what a
program with nothing shared to violate turns out to be.
