# `layout` — specification, second design

> **Status.** A redesign of a construct that already ships. §3 is what exists today, measured against
> the source; §4 onwards is the new model. §9 lists what breaks. §10 generalises `comptime`, which is
> larger than `layout` and is written here because `layout` is what forced it.

---

# Part I — Why there is a second design

## 1. What `layout` is for

`layout` was reached for because the alternative was worse: without it, byte-exact arrangement was
either inexpressible or a risky workaround. It works, and three anti-procedural findings turn on it:

- **AP-08** — *field order and padding waste memory the author never sees.* The remedy half falls
  because a `layout` lets the **compiler** order the fields while the source keeps the order the
  author meant: 2.4× against C's hand-sorted 2.5–3.5×, and C may not reorder at all.
- **AP-16 / AP-20** — *hardware needs byte-exact layout.* Falls on nine levels; `packed` is the one
  level where C still wins outright.
- **AP-09** — *encapsulation hides layout, so nobody can reason about adjacency.* Stands. C states
  the requirement with `_Alignas(64)` and checks it with `_Static_assert` on `offsetof`; Polaron can
  state neither, because the whole vocabulary is a size ceiling and a message.

## 2. Why it is being redesigned rather than extended

It was written as an immediate answer to an immediate problem, and it never went through the
scrutiny `transformer` and `entity` went through. The consequence is not cosmetic — the model has
**one constraint, one resolution and one message, and no room for a second of any of them**, which
is why every attempt to add a verb comes out crooked.

An earlier draft of this redesign attacked the *syntax* — `onArrange`, `itself`, `refuse` — and was
wrong on three counts, recorded here so the reasoning is not repeated:

- `onArrange` is not foreign: it is one of a family (`onFailure`, the lifecycle hooks).
- `itself` is consistent: it is the pronoun for the thing being declared.
- **`refuse` being a single message is correct.** It is not the message of one assertion — it is what
  the compiler says when *no arrangement exists* that satisfies the layout. One per layout is the
  right number, because either an arrangement exists or it does not.
- And `fitWithin` + `refuse` is **not** `demand` + `otherwise`. `demand` is spec 28.2, Polaron's
  static assertion: it checks and reports. `fitWithin` orders the compiler to **solve**, and only
  gives up afterwards. Two mechanisms, and conflating them was an error.

The one syntactic complaint that survives is that `implements` lies, which the sample itself admits:
*"`implements` here must survive as a layout and not be mistaken for an interface."* When code needs
a comment saying it is not what it looks like, the syntax is at fault. §5 replaces it.

## 3. What exists today, end to end

| | |
|---|---|
| declaration | a namespace member — a `ClassDecl` with `isLayout`. May `extends` another layout. May carry members (*"a layout may carry only helpers"*) |
| binding | `struct/record/union S implements L`; `resolveLayouts` moves layouts out of `interfaces` before the analyser runs |
| who may | **value aggregates only.** A class is refused, with the reason: it is reached through a pointer and *"the vtable slot at the front of the instance is the compiler's, not the author's"* |
| the model | `struct Arrangement { long long maxBytes; std::string refuseMessage; }` — that is all of it |
| the resolution | fields ordered **widest-first**. Hard-coded in C++, unconditional, invisible — nothing grants it and nothing can refuse it |
| enforcement | `checkLayoutBudgets`, in **codegen**, because a size is only knowable against the target's data layout |
| reach | travels in `.polh` headers; survives monomorphisation; byte units are known to the compiler rather than looked up in the prelude, so a layout **holds in freestanding by construction** |

### 3.1 And one consequence of that table is a live defect

The canonical sample is called `WireRecord` and says *"a wire record is 32 bytes; both ends index
it"* — and implementing it **authorises the compiler to reorder its fields.** If the two ends are two
declarations whose fields were written in different orders, both measure 32 bytes, both compile, and
the offsets differ. Nothing says so.

So AP-16's `packed` gap is worse than a missing feature: **today a `layout` for a wire format is
wrong, and the repository's own example is one.**

---

# Part II — The model

## 4. Three roles, three owners

> **The layout constrains. The layout concedes. The target resolves.**

| kind | what it is | who writes it |
|---|---|---|
| **constraint** | what must be true of the arrangement | the layout |
| **concession** | what the compiler may **do** to get there | the layout |
| **resolver** | how it is actually arranged | the target, or the layout's default |

The division is what the current design is missing. It also explains why "keep the declared order"
kept reading like a badly-shaped constraint: **it is not a constraint, it is the absence of a
concession.**

## 5. `arranges` replaces `implements`

```polaron
public struct Packet arranges WireRecord { ... }
```

The test that this is right: the sample's warning comment can be deleted.

`arranges` is the only new hard keyword this design adds. Everything else is either a word the
language already has, or a verb on `itself`.

## 6. Concessions — `permits`, on the declaration

```polaron
public layout Compact permits reorder, padding {
    onArrange {
        itself.fitWithin(20 bytes);
        itself.refuse("three to a cache line");
    }
}

public layout WireRecord {                    // permits nothing
    onArrange {
        itself.fitWithin(32 bytes);
        itself.refuse("a wire record is 32 bytes; both ends index it");
    }
}
```

`permits` is reused, not redefined. In `sealed X permits A, B` it means *"this is the closed set of
what is allowed"*; here it means the same, about a different subject. Same sense, different noun — it
does not acquire a second meaning.

It goes on the **declaration header** rather than in `onArrange`, because it answers *what kind of
layout is this*, not *what must be true*.

Two concessions:

| | |
|---|---|
| `reorder` | the arrangement may permute the fields |
| `padding` | the arrangement may insert bytes beyond what alignment requires — to isolate a field, or to align the type |

**Packing is not a concession.** Removing the padding natural alignment wants is not the compiler
choosing; it is the ABI being overridden by the author. That is a **constraint**, and it lives in
`onArrange` beside `fitWithin`.

### 6.1 The default grants nothing, and the diagnostic pays for it

A layout that says only `fitWithin(20 bytes)` will now **refuse** where today it solves. That
reintroduces exactly what the original design set out to avoid — *"a check that merely refuses is a
guard against a problem that could have been solved"* — unless the diagnostic carries the
difference. It can, because the compiler knows the answer:

```
`Packet` is arranged by `Small`, which fits it within 20 bytes -- it measures 28.
`Small` does not permit reordering. With `permits reorder` it measures 18.
```

The concession becomes explicit and the friction becomes guidance: the compiler does not refuse and
fall silent, it refuses and names the word that would solve it, with the number.

## 7. The resolver — the layout declares it, the target implements it

The header calls `layout` *"an interface for memory"*. An interface declares an obligation and the
implementer provides it. Until now `layout` had only constraints. This is the half that was missing.

```polaron
public layout Unshared permits padding {
    onArrange {
        itself.fitWithin(128 bytes);
        itself.refuse("two counters, two lines");
        itself.resolvedBy(arrange);              // which member resolves
    }

    comptime method arrange() returns void;      // no body: the target must provide one
}

public class Queue arranges Unshared {
    public mutable atomic<int> head;
    public mutable atomic<int> tail;

    public comptime method arrange() returns void {
        itself.isolate(head);
        itself.isolate(tail);
    }
}
```

**The field-naming problem does not get solved here — it disappears.** The target names `head` and
`tail` because they are its own. The layout never sees them and does not need to. Three earlier
proposals — roles bound on the `arranges` clause, an inline arrangement block in the type, a
modifier on the field — are all unnecessary and all withdrawn.

### 7.1 Obligation or default: abstract versus bodied

No new concept — the distinction the language already draws between an abstract member and a
concrete one:

| | |
|---|---|
| **declared, no body** | an obligation. The target must resolve. What a hardware descriptor wants: *"arrange yourself; I say what it must cost"* |
| **declared with a body** | a default the target may override. What a shared policy wants: written once, replaced by whoever knows better |

### 7.2 Why `resolvedBy` is written even though the member is declared

An interface does not restate which of its methods must be implemented. This one does, for a reason
that only appears once a layout may carry more than one member: **without the line, every method on a
layout is ambiguous between a helper and the resolver.** `resolvedBy` picks one, and it puts the
whole arrangement policy in one block where it can be read at once.

## 8. The machine

1. **Resolve.** The target's resolver if it has one; else the layout's default; else the compiler's
   built-in strategy, within what the concessions allow.
2. **Measure.**
3. **The layout judges.** The constraints are checked against the result, whoever produced it.
4. **`refuse` speaks** when no arrangement satisfies them.

Step 3 is what makes this safe: **the target resolves, the layout judges.** A target that arranges
itself badly still meets `fitWithin`. The work moves; the authority does not.

And `permits` remains the outer authority. A `WireRecord` that concedes nothing must not be reordered
**even by the target's own resolver** — the format is dictated by a third party and the target has no
vote. A resolver that exceeds its concession is an error naming the line it did not have.

### 8.1 The resolver's vocabulary

Four verbs. It is four and not more because, with `comptime` generalised (§10), the resolver writes
the rest itself.

| | |
|---|---|
| `itself.place(f)` | put the field next. **The order the calls are made in is the final order** |
| `itself.isolate(f)` | put it with a cache line to itself |
| `itself.align(f, 64 bytes)` | put it at an N-aligned offset |
| `itself.pad(8 bytes)` | a deliberate hole |

What a resolver reads off a field: `f.name`, `f.type`, `f.sizeof()`, `f.align()`.

**`isolate` is not sugar for `align(f, 64 bytes)`.** A cache line is a property of the target, and a
kernel built for another machine does not want 64 written into its source. *"Alone on its line"* is
the intent; 64 is one machine's answer to it.

**Completeness, and it is what makes a hand-written resolver safe:** every field must be placed
**exactly once**. One missed or one placed twice is an error naming the field. Without it, a resolver
with a mis-closed `if` produces a type with a field missing.

**There is no verb for giving up.** A resolver that knows in advance that it cannot uses
`demand ... otherwise "..."`, which is the language's static assertion, is comptime, and already
exists. What the *layout* says at the end is still `refuse`.

### 8.2 Where the resolver runs, and the precedent for it

**At codegen**, because that is where the target's data layout exists and therefore where sizes are
knowable. The split is not new — it is exactly what `demand` already does, per `codegen_stmt.cpp`:

> *"The analyzer already checked every condition it could fold, and **deferred exactly those
> mentioning `sizeof`** — a size is only knowable against the target's layout, which exists here and
> nowhere earlier."*

So: the analyser checks the resolver's body (names resolve, `f` exists, `place` receives a field);
codegen **evaluates** it. One more client for a division that already works.

**One implementation cost, stated because it bites.** A resolver reads its fields' sizes, and those
are the sizes of other types, which may have resolvers of their own. There is no true circularity — a
value aggregate cannot contain itself by value — but there is an **order**: types must be arranged
bottom-up, in topological order over containment. Today no such order is needed, because the single
strategy reads no field's size. This is the one place the compiler gains a phase rather than
extending one it has.

## 9. What this breaks

**Reordering stops being automatic.** Every `layout` in the tree must now grant what it used to
receive for free. That is the change that fixes §3.1, and it is a real migration.

The diagnostic in §6.1 is what makes it a guided one rather than a hunt: each failure names the
concession that would solve it and what the type would then measure.

## 10. `comptime`, generalised — larger than `layout`, and forced by it

`comptime` is already one of the universal prefixes, so it must mean one thing everywhere. Over a
statement, that thing is plain:

> **`comptime <statement>` — this statement is executed while the program is being built.**

And one rule unifies the two uses that look different today:

> A `comptime` statement is **evaluated** at build time. Whatever **runtime** code its body contains
> is **emitted, once per evaluation**.

Under that rule the two are one:

- a `comptime foreach` whose body holds runtime statements **unrolls** — today's behaviour;
- a `comptime foreach` inside a resolver emits nothing, because its body holds only comptime code.

Not a second rule; the same rule with an empty runtime body.

So the form generalises: `comptime if`, `comptime for`, `comptime while`, `comptime switch`,
`comptime match`, `comptime foreach`, a bare `comptime { }`, a `comptime var`. The interpreter in
`semantic/comptime.cpp` already evaluates `if`, loops, blocks and `return` — the machinery exists; the
grammar has to let it be called.

**A rule is removed, not added.** `comptime foreach` loses its special case — *"unrolled over the
fields of the applying type"* — and becomes an ordinary comptime `foreach` over `itself.fields`,
which is a comptime collection like any other.

### 10.1 Three decisions the generalisation forces

**a) Is the untaken branch of a `comptime if` analysed? — DECIDED: parsed, not analysed.** It must
**parse**, so it is syntax and not text. It is **not analysed and not emitted**, so target-conditional
code may name things that do not exist in the other mode (`Console` in a freestanding program, an
aarch64 register in an x86 block). The price is that a typo in the dead branch goes unnoticed on that
target; that is the price of `#if` and it is what makes it useful. It is also what makes
`docs/design/freestanding-prelude.md` §6 possible — one `Machine` library, partitioned by target.

**b) A `comptime while` can fail to terminate, and then the build hangs.** A step limit with its own
diagnostic is required — *"this comptime loop passed N steps; the condition is not moving"*. Not
optional: without it a malformed program produces silence rather than an error.

**c) Where a comptime statement may appear:** anywhere a statement may. That is what takes
`comptime foreach` out of the one context it is allowed in today.

## 11. Classes, once `dynamic` lands

Today's restriction to value aggregates has a stated reason, and the reason is the object header:

> *"Where a `Beast` is used, twenty bytes are there; where a class is used, a pointer is, and the
> vtable slot at the front of the instance is the compiler's, not the author's."*

With `dynamic` opt-in (see the object-header design), a non-`dynamic` class carries no slot, and the
reason lapses. `layout` then extends to it.

That closes **AP-09** by both halves at once, which is worth stating because the finding reads as one
problem and is two: *"an object cannot place its own counters because it does not contain them."*

1. it does not **contain** them — `atomic<T>` is a class, so an atomic field is a pointer. Fixed by a
   value-kind atomic, which is `unique` reaching value types (`docs/design/ownership.md`).
2. it cannot **place** them — a class may not have a layout. Fixed here, by `dynamic`.

Neither fix alone is enough.

## 12. What this adds to the language

| word | kind | note |
|---|---|---|
| `arranges` | hard keyword, clause | the only new hard keyword |
| `permits` | **existing**, reused | same sense, new subject |
| `reorder`, `padding` | soft, only after `permits` in a layout header | |
| `resolvedBy`, `place`, `isolate`, `align`, `pad` | verbs on `itself` | not keywords |
| `comptime` | **existing**, generalised over statements | §10 |

## 13. Still to design

| | |
|---|---|
| 13.1 | `layout` collects by **short name globally** (`layouts[c.name] = &c`). Two layouts with one name in two namespaces is not handled |
| 13.2 | Does a resolver see **inherited** fields, and may it place them? A layout can `extends` a layout; a target can `extends` a target |
| 13.3 | Whether a resolver may read anything about a field beyond name/type/size/align — an annotation on it, for instance, which is what a "every field marked X gets its own line" rule would want |
| 13.4 | What `align` does when the concession `padding` was not granted: refuse, or is alignment not padding? |
| 13.5 | The `entity` case. `layout` on an `entity` arranges **columns**, not fields within an instance (`docs/design/entity.md` §9) — the same three roles apply, and the resolver's verbs need an entity meaning: `together(a, b)` for AoSoA is the one that has no analogue here |
