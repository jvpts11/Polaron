# The anti-procedural tests

Thirty-four claims that systems programming makes about object orientation, written as **tests**
rather than as arguments. Each one names what would have to be demonstrable for the claim to be
refuted, and what the repository can show today.

The point of the exercise: Polaron exists to write a complete operating system, top to bottom, in an
object-oriented language with Java's syntax, zero C anywhere, no undefined behaviour, and at C's
speed or better. Every claim below is a reason somebody would say that is impossible. So each one is
a test, and the bar is that **all of them pass**.

## The distinction that organises the list

The objections conflate three different things, and almost every public argument lives in that
confusion:

1. **Properties of objects as a concept.** Physics. Nobody escapes them — not Polaron either.
2. **Properties of the languages that popularised objects.** "OOP needs a garbage collector" is
   about Java, not about objects. "You cannot control layout" is about the absence of `struct`,
   `layout` and bit fields, not about objects.
3. **Properties of a managed runtime.** Type headers, unwinding tables, a heap that must exist
   before `main`. This is the category `pico` actually refutes.

Most of "OOP does not belong in systems" is (2) and (3), said as though it were (1). Marking which is
which is half the work, and it is done in the `kind` column.

## How to read the status

- **passes** — demonstrable today, with the evidence named.
- **partial** — the mechanism exists; the proof does not, or the default is wrong.
- **open** — nothing in the language answers it yet.

A test is only really passed when something in `tests/` fails if it stops being true. Where that
test does not exist yet the status says so, because "we have the feature" and "we would notice
losing it" are different claims.

---

## A. Dispatch

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-01** | A virtual call is an indirect call: it cannot inline, and it costs a branch the predictor may miss | physics | A call whose target is statically knowable is emitted direct, and a polymorphic hot path measures level with the C equivalent | **partial** — `devirt=1` in the PIR hand-off on a whole program. One. |
| **AP-02** | Every object carries a vtable pointer: eight bytes, and a cache line it did not need | physics | A class that nothing extends carries no pointer | **partial** — `final`/`sealed` opt out and `Polaron-0B1D` advises it, but the DEFAULT pays: `hasVtable` is true for any public non-final class, because it *could* be extended |
| **AP-03** | The table itself is a second cache line on the dispatch path | physics | Dispatch touches one line, or the table sits with what reads it | **open** |
| **AP-04** | Devirtualisation needs whole-program knowledge, which separate compilation and dynamic loading deny | physics | A closed world (`program`) devirtualises; an open one (`bundle`) says so rather than pretending | **partial** — reachability already computes the closed world before emitting |
| **AP-05** | Dynamic dispatch stops constant folding and specialisation across the call | physics | A devirtualised call folds like a direct one | **partial** — depends on AP-01 |

## B. Layout and locality — the data-oriented critique

*This is the group that decides "as fast as C", and the only one where the answer does not exist at
all yet.*

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-06** | Objects force array-of-structures. A loop over one field of ten thousand objects touches ten thousand cache lines where a column touches six hundred | physics | A hot loop over one field, written in ordinary object syntax, touches a column's worth of memory | **open** — nothing columnar exists. Searched: no construct, no stdlib |
| **AP-07** | An object graph is pointer chasing: dependent loads that defeat the prefetcher | physics | A graph can be laid out contiguously without giving up objects | **partial** — `region` gives contiguity; nothing orders within it |
| **AP-08** | Field order and padding waste memory the author never sees | physics | Layout is decided, reportable, and assertable | **passes** — a `layout` states a budget and the compiler REFUSES a type over it, naming the measured size: `codegen_rejects_layout_over_budget`, `sizeof_budget_bad` |
| **AP-09** | Encapsulation hides layout, so nobody can reason about adjacency | habit, real root | The layout is inspectable at compile time and can be demanded | **passes** — `sizeof` folds at compile time and `demand` settles it while the program is built: `ap16_hardware_layout` |
| **AP-10** | Identity forces indirection: objects are passed as pointers, values are not | physics | A type with no identity is a value, with no indirection | **passes** — `struct`, `record`, `union`; the choice is per type |

## C. Allocation

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-11** | Allocation is hidden: constructors, temporaries, copies. In an interrupt or before the allocator exists, allocating is not allowed at all | physics | A scope can FORBID allocation and the compiler enforces it | **open** — the catalogue says in prose that a destructor "must not allocate or free"; nothing checks it |
| **AP-12** | Implicit code runs at scope boundaries, and kernel code must know exactly what runs | habit, real root | What runs at a boundary is visible and can be asked for | **partial** — `defer` is explicit; destructors are not listed anywhere |
| **AP-13** | Garbage collection: pauses, unpredictability, a runtime that must exist | **not OOP** | No GC | **passes** — manual memory, no runtime allocator required |
| **AP-14** | RAII fights early boot and error paths: a destructor cannot run before there is a heap | physics | A type can exist and be destroyed before the allocator does | **partial** — `region at address`, stack placement |
| **AP-15** | Many small heterogeneous objects fragment the heap | physics | Allocation can be grouped by lifetime | **passes** — `region`, with flavours |

## D. The hardware boundary

*The group `pico` answers by existing.*

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-16** | MMIO registers, descriptor tables and packet headers need byte-exact layout | **not OOP** | A declaration produces exactly the bytes the hardware defines | **passes, with proof** — `ap16_hardware_layout` declares the x86-64 IDT entry, writes it through its fields and reads back all sixteen bytes in Intel's order. `demand` settles the size while the program is BUILT |
| **AP-17** | Interrupt handlers need a specific register discipline and no prologue | **not OOP** | `naked` and `interrupt` exist and produce the right frame | **passes** — both are keywords; `cdecl`/`stdcall`/`fastcall` too |
| **AP-18** | Assembly must be integrated, not shelled out to a separate file | **not OOP** | `asm` is a construct of the language | **passes** — `AsmStmt` in the parser; pico writes no separate `.s` |
| **AP-19** | An OO language needs a runtime before `main`, and a kernel has no "before main" | **runtime** | The language boots on bare hardware with nothing initialised | **passes** — pico boots, 219 checks. **The strongest objection on the list, and the one most clearly refuted** |
| **AP-20** | Objects carry headers -- type tag, GC bits, lock word -- that the hardware does not expect | **runtime** | An object is exactly its fields | **passes, with proof** — same test: a sixteen-byte descriptor measures sixteen bytes and its first field is at offset zero. Nothing is in front of it |

## E. Control flow

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-21** | Exceptions need unwinding tables and a runtime, and cannot be used in interrupt context | **not OOP** | The language can refuse them where they do not belong | **passes** — `freestanding` refuses exceptions by declaration |
| **AP-22** | Non-local exit breaks "I can see every path out of this function" | habit, real root | Every exit is visible, or the ones that are not are refused where it matters | **partial** — freestanding refuses exceptions; `throws` is declared |

## F. Compilation

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-23** | Monomorphised generics explode: instantiation count, icache pressure | physics | Identical instantiations collapse, and the cost is measured | **open, and now quantified** — see below. `linkonce_odr` dedupes across translation units by SYMBOL NAME, and two instantiations over different pointer types have different names, so nothing collapses |
| **AP-24** | OO is only fast with whole-program optimisation, which breaks separate compilation | physics | The closed world is exploited and the open one is honest | **partial** — reachability before emitting |
| **AP-25** | Compile times | consequence | Measured and bounded | **partial** — measured; the check path is 307 ms |

## G. Reasoning and auditability

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-26** | You cannot see what code runs: operator overloading, implicit conversions, destructors | habit | The compiler says where cost hides | **partial** — the advice catalogue, 77 rules |
| **AP-27** | Encapsulation hides cost: a property access might be a syscall | habit | Same | **partial** — same |
| **AP-28** | Inheritance couples: the fragile base class | habit, real root | Overriding is deliberate and a base can close itself | **passes** — `override` is required, `final` and `sealed permits` exist |
| **AP-29** | Deep hierarchies hide the code that actually executes | habit | Depth is visible and can be bounded | **open** |

## H. Culture and ecosystem

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-30** | The operating system's ABI is C, so you are wrapping C either way | true, and answered | A system whose own ABI is not C | **passes** — pico implements the C stdlib FOR foreign programs and uses none of it itself |
| **AP-31** | Debuggers and tools assume C | culture | A debugger that works | **passes** — lldb-dap ships in the installer |
| **AP-32** | Nobody has done it | culture | Somebody did | **passes** — pico |

## I. Concurrency

| id | the claim | kind | what refutes it | status |
|---|---|---|---|---|
| **AP-33** | Object identity encourages aliasing, which is the hard half of concurrency | physics | Sharing is stated in the type | **passes** — `unique`, `move`, `movable`, `weak`, the region binder |
| **AP-34** | A lock per object is the wrong granularity | habit | Granularity is the author's choice, stated | **passes** — `synchronized`, `Mutex<T>` |

---

## The tally

| | count | |
|---|---|---|
| **passes** | 16 | AP-08 and AP-09 were carried as partial and already had tests: the compiler REFUSES a type over its layout budget |
| **partial** | 12 | |
| **open** | 6 | AP-23 moved here from partial once it was measured |

The six open: **AP-03** (the table's own cache line), **AP-06** (nothing columnar), **AP-11** (no way
to forbid allocation), **AP-23** (identical instantiations do not collapse), **AP-29** (hierarchy
depth), and **AP-02** in its default.

Two of those moves are the same lesson in opposite directions: **AP-08/09 were stronger than the
audit said and AP-23 was weaker**, and both were settled by looking rather than by reasoning. A
status in this table is worth what the evidence beside it is worth.

## AP-23, measured 2026-08-21

The claim was carried as "partial, never measured". It is measured now, and it holds.

A program that makes `ArrayList<Alpha*>`, `ArrayList<Beta*>` and `ArrayList<Gamma*>` -- three lists
of pointers, whose machine code is **identical**, because every one of them is a list of `ptr`:

| | |
|---|---|
| functions emitted for `ArrayList$Alpha` | **30** |
| functions emitted for `ArrayList$Beta` | **30** |
| functions in the whole module | 144 |
| of those, monomorphised instantiations | **129** |

Ninety functions where thirty would do, and nine tenths of the module is instantiation. `linkonce_odr`
does not help: it collapses identical SYMBOL NAMES across translation units, and `ArrayList$Alpha.add`
and `ArrayList$Beta.add` are different names for the same instructions.

**The shape of the fix, not yet taken:** instantiate by REPRESENTATION rather than by name where the
type argument is a pointer. Every `T*` is `ptr`, and a collection of pointers compares its elements
by identity, so one body serves all of them -- `ArrayList$ptr`. It is a change to the mangling, which
is the part of this compiler that has bitten hardest and most recently (`ArrayList$Cell*` and the
`isSubtype` hole it opened, the same day this was written), so it is written down before it is
attempted.

**AP-06 is the one that decides the headline claim.** It is the only group where the answer does not
exist in any form, and it is the objection with a measured bite in this project's own code: in
`agents-exe`, reordering pointers without reordering the objects they point at DOUBLED the cost.
That measurement is not an argument against objects; it is the reason this test is the hard one.
