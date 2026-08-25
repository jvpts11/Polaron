# Ownership — `unique` over values, `move` generalised, `shareable`

> **Status.** Designed, not implemented. This is not a new construct: it is spec §19 reaching where
> it was penned in, plus **one** new word.

---

# Part I — Why

## 1. The findings

**AP-09** — *encapsulation hides layout, so nobody can reason about adjacency.* **Stands**, and its
conclusion is one sentence carrying two problems:

> *"An object cannot place its own counters because it does not contain them."*

| | |
|---|---|
| it does not **contain** them | `atomic<T>` is a class, so an atomic field is a pointer and two counters are two separate allocations. **Fixed here.** |
| it cannot **place** them | a class may not have a `layout`. Fixed by `layout.md` + `dynamic.md` |

Neither fix is enough alone.

The same finding names a third gap in its own words:

> *"A way to mark an object **shareable** across threads without a lock, when its mutable state is
> entirely atomic — today a thread closure refuses **every** `T*`, tested with plain fields, with
> all-`atomic` fields, and with a fully immutable object."*

**AP-33** — *object identity encourages aliasing.* **Inverts**: the textbook race is a compile error
naming the three sanctioned ways to share, where C compiles the same program clean under
`-Wall -Wextra` and loses 40% of the increments, differently each run. But it closes with a cost:

> *"The refusal is not free: only `atomic`/`Mutex`/`Channel` cross, so lock-free per-thread work
> cannot live on a type."*

## 2. The prelude proves AP-09 with its own code

```polaron
public class Semaphore     { private mutable atomic<int> count;   this.count   = new atomic<int>(n) on heap; }
public class Barrier       { private mutable atomic<int> arrived; this.arrived = new atomic<int>(0) on heap; }
public class ReadWriteLock { private mutable atomic<int> readers; this.readers = new atomic<int>(0) on heap; }
```

Three classes, three counters, **three separate allocations**, and not one of the three contains its
own counter. `atomic<T>` is declared `public class atomic<T>`.

## 3. A correction on the record

During design this was attributed to **spec §32.7, resource tokens**, and that attribution is wrong.
§32.7 is *capability-based security* — a `FileAccessToken` proving permission, for sandboxing,
plugins and privilege separation. It is a different feature.

The error was productive in one way: a capability token that can be freely copied is a capability
that cannot be controlled, so §32.7 becomes a **client** of what is designed here rather than its
home.

And the concept it was standing in for did not need inventing either — see §4.

---

# Part II — `unique` reaches value types

## 4. The word already exists

Spec §19, *Move e disciplinas de ownership*, defines three disciplines for classes:

| | |
|---|---|
| **default** | copy semantics, like Java |
| **movable** | explicit transfer keeps a single active reference |
| **unique** | one live holder at a time. **Every assignment is a move.** Cannot be passed by value to several parameters at once, cannot be stored in containers that duplicate |

That is exactly *a value whose only transfer is a move*. Nothing needed inventing.

> An earlier reading took `unique` for a singleton — *"classe única globalmente"*, from the §19.10
> example's comment. §19.2 settles it: several `FileHandle`s exist, each with one live holder. It is
> **one holder**, not one instance.

## 5. What is actually missing: one line of §19.1

> *«Disciplina é declarada como prefixo **na classe**»*

The disciplines live on classes. A **value type** has none — which is why `atomic<T>` is a class and
every use of it is a separate heap allocation.

> **`unique` stops being a discipline of classes and becomes a discipline of types.** It means the
> same on a `struct`, a `record` and a `union` as it means on a class.

The discipline is orthogonal to the representation. Whether the value lives inside its owner or is
reached through a pointer is what `struct` versus `class` already decides; `unique` says who may hold
it. It was pinned to one side by a sentence, not by a reason.

One vocabulary adjustment: for a class §19 says *"one live reference"*. A value has no reference — it
**is** the storage — so it reads *"one live holder"*. Same discipline; the sentence was written for
the case at hand.

## 6. The rules — **DECIDED**

### 6.1 Contagion is automatic, and the diagnostic names the cause

A type with a `unique` field **cannot be copied**. That is not a choice, it is arithmetic, so unlike
`dynamic` it is implied rather than written. The diagnostic must name the field that causes it:

```
`Queue` cannot be copied: its field `head` is `unique`.
```

Without that, the user sees a refusal with no visible cause.

### 6.2 Containers: read gives a reference, removal gives the value

Most of this falls out of §19.2 rather than needing new methods. *"For unique, every assignment is a
move"* — and passing by value is an assignment. So `list.add(x)` on a unique `x` **is already a
move**, and `x` is invalidated, with no change to `ArrayList` at all.

What needs stating is the other direction, and it is a rule rather than a set of methods:

> **Reading gives a reference; removing gives the value.** `get(i)` on a unique `T` returns `T&` —
> returning by value would move out and leave a hole. `removeAt(i)` returns by value, because the
> slot is going away regardless.

Moving out of a container is therefore **always also a removal**, which disposes of the hole without
tombstones or any new mechanism.

### 6.3 Inline arrays of unique values

`atomic<int>[16]` as a field, indexing yielding a reference, no allocation. This is the per-thread
accumulator array AP-09 named as the standard shape that cannot be written today, in its cheapest
form — and it is what a kernel wants where there are no collections.

### 6.4 Returning by value is a move, and is allowed

Otherwise there is no way to construct one and hand it out.

### 6.5 Not a field of an `entity`

Materialising a row copies. A `unique` field in an `entity` cannot exist; refused, with the reason.

### 6.6 Not readable by reflection

Reading a field by reflection returns a copy. A `unique` field is not readable that way, which
`Serialize` and `Compare` will meet. Refused, with the reason.

## 7. What it does to the prelude

`atomic<T>` becomes a `unique struct`. An atomic field stops being a pointer and becomes bytes inside
its owner; two counters are two fields; and with `layout` reaching classes with no dispatch pointer
(`dynamic.md` §9) and the resolver's `itself.isolate(f)` (`layout.md` §8.1), **the object can place
them**. That is AP-09 closed, by both halves.

`Mutex<T>` follows, and so do a file descriptor, a region token, a `using` guard, and §32.7's
capability tokens.

## 8. Open: the symmetry of the family

The three disciplines are a family. If `unique` crosses to value types, **`movable` should cross
too** — otherwise value types get one discipline of three, which is an exception with no reason
behind it. Not decided.

---

# Part III — `move`, generalised

## 9. It already reaches further than expected

Spec §19 gives `move` a full clause grammar:

```
move <source> [into <dest>] [to|into region <R>] [from region <R0>] [as <Type>]
              [carrying|leaving|releasing persistents];
<Type> <var> = move <source> [from region <R0>] [into region <R>] [as <Type>] [...];
```

It already moves between regions **without reallocating** — *"a unique Polaron capability"*, per
§19 — converts type on the way (`as`), and decides what happens to persistents. And it already exists
as a parameter modifier: `method consume(move Conn c)`.

## 10. What is missing is destinations, not syntax

`move` stays one expression. What generalises is **where its result may go**.

| destination | state |
|---|---|
| another variable | exists |
| a region, in or out | exists |
| a parameter | exists |
| a **container slot**, in | falls out of the discipline (§6.2) |
| a container slot, out | needs the removal rule (§6.2) |
| a field, an array element | the same `move` on the left of an assignment |
| **a thread** | **missing, and it is the important one** |

## 11. A thread as a destination — the fourth way to cross

Look at what the three sanctioned crossings have in common: `atomic<T>`, `Mutex<T>` and `Channel<T>`
are three ways to **share**. None of them is the obvious one, which is **not to share** — to hand it
over.

A thread that receives its chunk by `move` is its sole holder. No race is possible because there is
no second holder. It is safe **by construction** rather than by a lock, and it costs nothing.

This is the common case — one worker, one chunk — and it needs no relaxation of the rule that
protects the dangerous case.

## 12. A side effect worth money

From the PIR hand-off table (`polaron-ir.md` §12):

| PIR fact | LLVM |
|---|---|
| `isUnique`, or a pointer that was `move`d | **`noalias`** |

**Every new place `move` reaches is a place the compiler learns non-aliasing.** And `noalias=0` at the
hand-off is the first suspect behind the largest performance target in the ledger — the vectoriser
gap that four AP tests reach from four directions. Generalising `move` is not only ergonomics: it
feeds exactly the facts that front is waiting for.

---

# Part IV — `shareable`

## 13. It already exists, as `implements Shared`

A `shareable` modifier was designed here and then found in the compiler, already built.
`src/prelude/lib/Concurrency.pol`:

```polaron
// A TYPE ITS OWN THREADS MAY SHARE, and the whole of what it says is that its author
// thought about it (spec 20).
//
// The region binder refuses to hand the same object to two hands at once, which is right by
// default and wrong for the one case a worker pool is made of: a value everybody reads and
// nobody writes, or one whose writes are already atomic. Marking it is a sentence somebody
// has to write, so it cannot be arrived at by accident -- which is the difference between
// this and a compiler flag that turns the check off.
public interface Shared {
}
```

`SemanticAnalyzer::declaresShared` walks the interface chain and the superclasses, and the thread
closure check accepts a capture whose type `declaresShared`. `tests/samples/thread_shared_type.pol`
exercises it.

> **AP-09's finding is incomplete rather than wrong.** It reported *"a thread closure refuses **every**
> `T*` — tested with plain fields, with all-`atomic` fields, and with a fully immutable object"*. All
> three were true; none of the three declared `implements Shared`, which is the escape hatch that
> exists. The gap it named — *"a way to mark an object shareable across threads without a lock"* — is
> **met in spelling**. §14 is where it is not met.

## 13a. Two things that are genuinely missing

**It is not checked** (§14), which is the substance.

**And it is an interface, which under `dynamic` becomes a cost.** An empty marker interface that a
class `implements` would give that class a **dispatch pointer** under `docs/design/dynamic.md` §6 —
eight bytes and a table, to carry a fact that is consumed entirely at compile time and reaches no
run-time dispatch at all.

> **DECIDED: `Shared` becomes a modifier**, not a marker interface. `public Shared class Tally { ... }`
> rather than `implements Shared`. It buys no dispatch pointer, it cannot be reached through, and it
> is what it always was — a sentence the author writes about the type, now checked (§14).

## 14. It is **checked**, not trusted — and this is not optional

A bare permission would be a one-word hole in the no-UB principle: write it over a type with a plain
mutable `int` and you have the race the compiler currently refuses. And that refusal is what makes
AP-33 invert — trading it for a password would be handing the objection back after winning it.

Its own comment concedes it: *"the whole of what it says is that its author thought about it."*

There is no need to trust it, because the check is **local and decidable from the declaration**:

> **`Shared` is legal when every mutable field is `atomic<T>`, or is itself `Shared` — or when the
> type is entirely immutable.** Any other mutable field is an error, naming the field.

No whole-program knowledge, no flow analysis, and it travels in the `.polh` header. That puts it in
the same category as `override`: **you declare the intent and the compiler confirms it** — the house
pattern, alongside `layout` stating and the compiler refusing, and `interrupt` declaring and the
reachability walk checking.

## 15. Two interactions to write down

**`unique` and `Shared` contradict** — one has a single holder, the other needs two. The §19.9
anti-contradiction rule should catch it.

**But a `unique` atomic *inside* a `Shared` object does not**, and this is subtle enough to be worth
stating: `unique` is about ownership of **the value** — its owner is the object containing it, and
there is one. `Shared` is about aliasing of **a pointer to the container**. The two threads hold
`Counters*`; they do not hold the atomic. Different levels.

## 16. Where it belongs

If it becomes a modifier (§13a), it is a **type and region** modifier, not a universal prefix.
`Shared` on a region means something — two threads allocating from it. On a method it means nothing.

## 17. Deliberately not built: the escape hatch

A type the compiler **cannot** verify but whose author knows is safe — one holding an `address` and
doing its own synchronisation, or wrapping a lock-free structure over raw memory. Polaron has no
`unsafe`, and opening a hole in the one guarantee AP-33 inverts is expensive.

**Refused for now**, to be revisited when a measured case demands it rather than building the exit
before anyone wants to leave.

---

# Part V — The result

## 18. Five ways across a thread boundary, graded

| | when | cost |
|---|---|---|
| **`move`** | I hand it over and stop holding it | zero — there is no sharing |
| **`Shared`** | several holders, all mutable state atomic | lock-free |
| `atomic<T>` | one value | one instruction |
| `Mutex<T>` | the invariant spans more than a word | a lock |
| `Channel<T>` | I hand it over as a message | a queue |

Four of the five already exist. The one that is missing is the first: **not sharing at all.** And of
the four, `Shared` is the one that is written but not verified.

## 19. What this adds to the language

**No new keyword.** Everything in this document is reach or rigour:

| | |
|---|---|
| `unique` | crosses to value types (§5) |
| `move` | gains destinations, chiefly a thread (§10–11) |
| `Shared` | is **checked** rather than trusted (§14), and probably stops being an interface (§13a) |

A `shareable` keyword was designed here and then found already built, which makes this the **fifth**
time in this round that the answer was a word the language already had — after `comptime`
(statements), `permits` (layout concessions), `unique` (value types) and `move` (destinations).

> The method that keeps failing is trusting the notes. The ledger recorded *"today a thread closure
> refuses every `T*`"* and the compiler had the escape hatch, the walk that honours it, and a sample
> exercising it. **Read the repository, not the record.**

## 20. Still to design

| | |
|---|---|
| 20.1 | does `movable` cross to value types as well (§8)? |
| 20.2 | the escape hatch for an unverifiable `Shared` (§17) — refused for now, not settled |
| 20.3 | `ArrayList` grows by copying its backing array; over `unique` elements that is a bulk move. Confirm the growth path expresses it as one |
| 20.4 | `Shared` as a modifier rather than a marker interface (§13a), so it does not buy a dispatch pointer under `dynamic` |
| 20.5 | `Shared` on a region (§16) — what it means for the region binder, which is otherwise single-threaded |
