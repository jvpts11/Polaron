# `dynamic` — specification

> **Status.** Designed, not implemented. The migration cost is **measured**, not estimated — §7.
> §6 is the one decision left open.

---

# Part I — Why

## 1. The objection

**AP-02** — *every object carries a vtable pointer: eight bytes, and a cache line it did not need. A C
struct is its fields.*

It **stands**, and `final` does not help:

| | `sizeof` |
|---|---|
| `struct Point` | **8** |
| `class Tag` — nothing extends it, nothing overridden | **16** |
| `final class Sealed` — the possible types are one, by declaration | **16** |
| `class Node` — a real base | **16** |

Measured four times, from four directions:

| | cost |
|---|---|
| AP-02, isolated — same array, same access pattern, only the eight bytes differing | **+74%** (GCC pays 12% for the identical change) |
| AP-07, a pointer walk | **+70%** |
| AP-10, identity against value | **+44%** |
| AP-24, memory footprint | **4×**, and four fifths of that test's 36% gap |

Note the middle two rows of the size table. `Tag` has no virtual method, nothing extends it, and
nothing of it is ever overridden — and it pays. That is the sharpest form of the objection, and the
answer below costs it **no annotation at all**.

## 2. What the specification actually commits to

Spec §3.4, in full:

> `Object` — raiz da hierarquia.

One line, and it is a statement about **typing**, not about **representation**. It does not say every
instance carries a pointer, it does not say `equals`/`hashCode` dispatch dynamically, it says nothing
about layout. The eight bytes come from `assignObjectRoot` in `src/cli/main.cpp` — an implementation
decision, taken once, for everyone.

So the question is not *may the spec be contradicted*. It is: **when is the pointer actually needed?**

## 3. Two capabilities, not one

This is the centre of the design, and the first draft got it wrong by conflating them — because
today one pointer serves both.

| | what it is | who already declares it |
|---|---|---|
| **dispatch** | which body runs, when a base or interface is held | `extends`, `override`, `abstract`, `implements` |
| **identity** | *what are you*, once the static type has been lost — `Object`, reflection, `Serialize` | **nothing. It has no word** |

They are different capabilities. C++ separates them too — a vtable is for dispatch, RTTI is a
separate feature people routinely switch off.

The consequence, and it is the rule that governs everything below:

> **`dynamic` does not touch polymorphic code.**

`override` is **mandatory** in Polaron, so a subclass that overrides has already declared, in writing,
that it wants dispatch. Requiring a second word on top of it would be saying the same thing twice,
and a word that adds no meaning is ceremony.

## 4. Why the word is not `final`

`final` was proposed for the header and is wrong, for a reason the specification settles. §37.6 makes
`final` one of the **six universal prefixes**, and §2.50 defines the family by a property:
*«6 modificadores com semântica consistente em qualquer contexto»*.

```
final class Foo      // not extensible
final method bar()   // not overridable
final region world   // cannot be reallocated
final thread monitor // cannot be replaced
```

One meaning: *this binding cannot be replaced or extended*. If `final class` also meant "carries no
header", it would be the first universal prefix whose sense depends on what it is attached to, which
destroys the property that defines the family. The two axes are orthogonal besides: a `final` class
may perfectly well be reflected, serialised, or passed as `Object`.

---

# Part II — The specification

## 5. The word, and the family

> **`dynamic` — this is decided at run time.**

| context | meaning |
|---|---|
| **`dynamic method m()`** | **which body runs** is decided at run time — the method may be overridden |
| **`dynamic class C`** | **which type this is** is decided at run time — the instance carries its type, so it can be erased to `Object`, reflected, serialised |
| `dynamic` field | what is inside is known only at run time: reflection reads and writes it |
| `dynamic region r` | which arena backs it is decided at run time, so it escapes the static binder |
| `dynamic` with `unimport`/`reimport` | which code is bound is decided at run time — something the language **already does** and had no word for |
| `dynamic delegate` / `thread` | the target is chosen at run time |

One sense throughout: *decided at run time*. On a method, which body; on a class, which type.

### 5.1 It is the half the prefix family was missing

The six are `cascade`, `eternal`, `lazy`, `comptime`, `volatile`, `final`. Look at `comptime`:
*resolved before there is any run time*. The compile-time pole of an axis is in the family; the
run-time pole of the same axis is not.

```
comptime  <————— when is this decided? —————>  dynamic
```

`dynamic` is not a new word asking for a place. It is **the missing half of an axis the family
already held half of** — which settles whether it deserves to be universal: if `comptime` does, this
does, because it is the same axis.

With it and `stable`, and counting `delegate`, the family is nine: `cascade`, `eternal`, `lazy`,
`comptime`, `volatile`, `final`, `delegate`, `dynamic`, `stable`.

### 5.2 Contradictions, under the §19.9 anti-contradiction rule

| | why |
|---|---|
| `comptime dynamic` | the two poles of one axis |
| `final dynamic method` | a body that cannot be replaced against a body chosen at run time |
| `dynamic entity` | the header would become a column of pointers (`entity.md` §10) |

## 6. `dynamic method` — dispatch

A base declares which of its methods may be overridden. It pairs symmetrically with the `override`
that is already mandatory on the other side:

```polaron
public class Shape {
    public dynamic method area() returns int { return 0; }
}
public class Square extends Shape {
    public override method area() returns int { return this.side * this.side; }
}
```

**A class carries a dispatch pointer if — and only if — it declares or inherits a `dynamic method`,
or implements an interface.** Nothing else gives it one: not being public, not being extended, not
being abstract.

### 6.1 Why this and not "any public class may be extended"

The alternative was to give every public non-`final` class a pointer, on the grounds that a consumer
in another bundle may extend it and dispatch through it. That needs no new word and changes no model
— and it gives libraries nothing at all. In the prelude, where almost everything is public, it is
**exactly today's cost**.

The declaration is what makes the promise travel. That is the same property AP-04 measured on
`final`: across a real bundle boundary, with opaque provenance and no LTO, a `final` class's call is
a direct call at 490 ps where the polymorphic one is 910 — because the promise is in the `.polh`
header, not in whole-program knowledge.

### 6.2 What it changes about the model

Today any method is overridable unless `final`. Under this, a method is overridable only if declared
`dynamic`. That is a real model change, and it is the same principle applied everywhere else in this
round of design: **the cost is written where it is born.**

`final method` does not disappear — it remains what it is, and `final dynamic method` is a
contradiction (§5.2). In practice `final` on a method becomes rare, because not writing `dynamic` is
already the closed case.

### 6.3 `abstract` and interfaces

- An **abstract method** has no body, so dispatch is the only way it can ever be called. It has no
  non-dynamic reading. **Open (§10.1):** whether `dynamic` is written on it anyway for consistency,
  or whether that is noise.
- An **interface member** is dispatch by definition. A class that `implements` an interface therefore
  carries a dispatch pointer.
  **Open (§10.2):** an interface used purely as a *constraint on a type parameter* dispatches
  nothing after monomorphisation — `Hashable<T>` and `Comparable<T>` in `Collections.pol` are used
  exactly this way, with the call `this.keys[i].equalsKey(key)` over a `K[]` resolving statically on
  the concrete `K`. Constraints of that kind arguably belong to the `transformer`/`satisfies`
  mechanism, which is structural and static, rather than to `interface`.

## 7. `dynamic class` — identity

```polaron
public dynamic class Account { ... }     // may be erased to Object, reflected, serialised
```

This is the capability with no other spelling: participating in the universal root **at run time**.
It is required to be

- passed where an `Object` is expected,
- read or written by reflection,
- handled by `Serialize`, `Inject` or `Compare`.

**Nothing implies it.** Not `abstract`, not `extends`, not `public`. A prefix that is sometimes
inferred stops being a statement of where the cost lives, which is the whole reason it exists.

### 7.1 The erasure boundary — **DECIDED: (a), refuse**

```polaron
Object* o = new Plain();     // `Plain` is not a dynamic class
```

Three ways, and they are not close:

| | | |
|---|---|---|
| **(a) refuse** | a compile error naming `dynamic` and the eight bytes it costs | **recommended** |
| (b) box | the compiler wraps it in a dynamic carrier at the boundary | an allocation nobody wrote. Against everything the language says about hidden cost |
| (c) infer | mark `Plain` dynamic because this use was seen | needs whole-program knowledge, breaks across bundle boundaries, and moves the cost away from the word — giving up exactly the property §6.1 relies on |

Recommended (a), with a diagnostic that names the reason rather than the rule:

```
`Plain` is not a `dynamic class`, so it does not carry its type at run time and cannot be held as an
`Object`. Add `dynamic` to the declaration -- it costs 8 bytes on every instance.
```

### 7.2 `is` / `as` / `match` need no special case

If the static type is not a `dynamic class`, the compiler knows exactly what the value is, so
`x is Foo` **folds at compile time**. No error is needed — it is a constant, and a lint can say the
test is always true. Dynamic-type questions only need a run-time answer when the type was erased,
which is precisely the case that requires the word.

## 8. The blast radius — measured

The stated requirement was that `dynamic` must not destroy the programming model that exists. It was
measured rather than argued.

### 8.1 The prelude — 334 classes, 20 750 lines

The entire polymorphic surface:

| | |
|---|---|
| hierarchies | **four**: `Exception` (13 descendants), `Stream` (6), `Result` (2), `Option` (2) |
| classes implementing an interface | **four**: `ArrayList`, `ArrayListIterator`, `Stream`, `LineReader` |
| `final` classes | 0 |
| `sealed` classes | 0 |
| `override` members | **40** |
| mentions of `Object` | **3 places, all reflection-facing**: `Serialize`, `Inject`, `Compare` — and in all three it is a *parameter type*, so no prelude class is itself erased |

> **`dynamic class`: ≈ zero. `dynamic method`: ≈ 40 — one per overridden method.
> And ≈ 304 of 334 classes lose eight bytes each.**

Six of the thirty that keep a dispatch pointer — `Result`/`Ok`/`Err`, `Option`/`Some`/`None` — leave
the set entirely the day `Result` becomes a value type (AP-21).

### 8.2 The test corpus — 874 files, 1787 classes

| | |
|---|---|
| classes with `extends` | 89 (5.0%) |
| classes with `implements` | 38 (2.1%) — several of which are **layouts**, not interfaces (`implements Packed`, `implements WireRecord`, `implements Quad`), and leave the count entirely once `arranges` lands |
| abstract classes | 18 |
| `override` members | **108** |
| files mentioning `Object` | 11 |
| files using reflection / `Serialize` / `Inject` / `Compare` | 10 |

> **`dynamic class`: about ten or eleven files. `dynamic method`: ≈ 108 sites, each one directly
> above an existing `override`.**

### 8.3 What the number does not measure

Said plainly, because a number is only worth its method:

1. It is a **static proxy**. A class passed as `Object` through a call chain the search did not
   follow would be missed. The ceiling is low — `Object` appears in 3 prelude sites and 11 sample
   files — but it is not zero.
2. It counts **declarations**, not instantiations of generics.
3. It says nothing about programs outside this tree.

## 9. What it unlocks that was not asked for

**`layout` on classes.** The stated reason `layout` is restricted to value aggregates is the header
itself:

> *"Where a `Beast` is used, twenty bytes are there; where a class is used, a pointer is, and the
> vtable slot at the front of the instance is the compiler's, not the author's."*

A class with no dispatch pointer and no identity has no slot, so the reason lapses. That closes the
second half of **AP-09** — *"an object cannot place its own counters because it does not contain
them"* — which is two problems wearing one sentence: it does not **contain** them (`atomic<T>` is a
class; fixed by `unique` reaching value types, `docs/design/ownership.md`) and it cannot **place**
them (fixed here). Neither fix alone is enough.

**A cleaner input to devirtualisation.** `comptime`, `dynamic`, `sealed permits` and `final` become
one coherent story about binding time, and a class with no `dynamic method` devirtualises without
analysis. Four tests reach that missing optimisation from four directions (AP-01, AP-03, AP-04,
AP-05).

## 10. Still to design

| | |
|---|---|
| 10.1 | is `dynamic` written on an `abstract method`, which can have no other reading (§6.3)? |
| 10.2 | constraint-only interfaces (§6.3). `Hashable<T>`/`Comparable<T>` dispatch nothing after monomorphisation; should they be `transformer`/`satisfies` instead, so that `implements` can mean dispatch without qualification? |
| 10.3 | the erasure boundary (§7.1) — recommended (a), not decided |
| 10.4 | the four root methods. `equals`, `hashCode`, `toString`, `equalsKey` on a class with no identity resolve statically — confirm no site reaches them through the root |
| 10.5 | freestanding already emits headerless classes (`assignObjectRoot` skips it), so the representation is built and tested. Confirm the hosted path can reuse it per class rather than per program |

## 11. What this adds

| word | kind |
|---|---|
| `dynamic` | hard keyword, **universal prefix (8th)** |

Nothing else. And AP-02 does not get mitigated — it **falls**, in its sharpest form and with no
annotation: `class Tag`, which nothing extends and nothing overrides, becomes eight bytes because
nobody wrote anything. C cannot declare this at all; C++ hangs it on a per-method `virtual` and lets
the header appear as a side effect nobody sees at the declaration. Here the same word says which
bodies are chosen at run time and which types are known at run time, and a class that does neither
is its fields.
