# `layout` — specification, second design

> **Status.** A redesign of a construct that already ships. §3 is what exists today, measured against
> the source; §4 onwards is the new model. §9 lists what breaks. §10 generalises `comptime`, which is
> larger than `layout` and is written here because `layout` is what forced it.
>
> **BUILT — §5, §6, §6.1, §7 and §8.** `arranges` replaces `implements`, with the old spelling
> warning under `Polaron-0B51` rather than breaking. `permits reorder, padding` sits on the layout
> header and **nothing is permuted without it**. The refusal names the concession and what the type
> would then measure, under `Polaron-0813`. The concessions cross a `.polh`, survive the cloner and
> the monomorphiser, and the corpus is migrated. `layout_concession_is_explicit` reads bytes through
> an **address** to prove two declarations stay different, and `layout_names_the_concession` pins the
> message. **That closes §3.1, which was a live defect rather than a gap** — the numbers were 8 and 8
> and are now 12 and 8.
>
> **And the resolver:** `resolvedBy` names the member; a bodyless one on the layout is an obligation
> and a bodied one a default; the target's own always wins. All four verbs, completeness over the
> field set, and both concession checks — `align` and `isolate` need `padding` (§13.4), and a
> resolver that permutes without `reorder` is refused naming the word it did not have.
> `layout_resolver` measures **addresses**: `apart 64` is the promise `isolate` makes, where 4 would
> be the two counters adjacent at the same total size.
>
> **One implementation note the design did not anticipate, and it is the load-bearing one.** A
> boundary cannot be RECORDED on a field and left to the backend: what the backend emits is a struct
> type, and `{ i32, i32 }` puts two counters four bytes apart whatever is written down about them.
> `align` and `isolate` therefore **materialise** the gap as real padding, exactly as `pad` does —
> and the tail is rounded up too, because stopping at 68 puts the second element of an array 68 bytes
> in and the guarantee holds inside one object while failing one subscript away. A promise about a
> distance has to become a distance.
>
> **NOT BUILT:** §13.2's inherited fields (no arranged type in the corpus has a base), §13.5's
> `together`, and §11's extension to non-`dynamic` classes. §8.2's topological order over containment
> is not built either, and is not needed yet: a resolver that reads another type's `sizeof()` would
> need it, and the four verbs as built read only the target's own fields.

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

## 13. Decided (Wave 4.5)

### 13.1 Layouts are keyed by the resolved class key, like everything else

**Decided.** `layouts[c.name]` becomes `layouts[resolveClassKey(c.name)]` — the same key the type
table, the vtable globals and `vtable.load`'s `text` all use.

This is not a design question, it is **a bug with a design question written on it**. Two layouts named
`Compact` in two namespaces do not currently collide loudly; the second overwrites the first in a
`std::map`, and every target arranging by the first name silently gets the second one's rules. A wire
format arranged by somebody else's cache-line layout produces a struct of the right size with the
fields in the wrong places, and both ends of the wire agree it is 32 bytes.

The mechanism already exists and is used everywhere else — Wave 3 hit the same thing from the other
side, where `shape.base` and `shape.interfaces` had to be resolved or the descent relation silently
had no edges. **A name that half the compiler resolves and half does not is the shape both defects
have.**

### 13.2 A resolver sees inherited fields and must place them

**Decided: yes, it sees them, and completeness includes them.**

The alternative — inherited fields fixed at the base's arrangement, with the resolver placing only
the ones declared here — was tempting because it matches how single inheritance already works, and it
is wrong for what a layout is for. A layout is a statement about **the bytes of an instance**, and an
instance's bytes include what it inherited. A resolver that cannot see them cannot say *this field is
alone on its cache line* about the one field that matters, if the base declared it.

Three consequences, and each is a rule the machinery already has:

- **Completeness (§8.1) counts inherited fields.** Every field of the whole instance placed exactly
  once — one missed is an error naming it, and the error must say which class declared it, because
  the resolver's author may not have written that line.
- **A base's own arrangement is not binding on a derived target.** It is a different type with
  different bytes; the only thing that must survive is what the layout's concessions and constraints
  say.
- **But a `dynamic` class's header stays at offset zero**, whatever the resolver does, and that is
  not a field the resolver may place. It is not the author's byte to move: `Tagged*` used as a
  `Particle*` finds the vtable pointer at zero, and a resolver that relocated it would break every
  cast in the program. It is excluded from the field list rather than refused at `place`, so it never
  appears as something to forget.

### 13.3 A resolver reads name, type, size, align — and annotations

**Decided: annotations too, and nothing else.**

The case that forces it is the one the item names: *every field marked X gets its own line* is a real
rule, it is exactly what `isolate` is for, and without annotations the only way to write it is to
list field names in the resolver — which puts the target's field names in the layout, where a rename
breaks a file that does not mention the class.

`[Annotation]` is already applied to members (`AnnotationUse` on the AST), already read at compile
time, and already the language's way of saying *this one is different* without changing its type. A
resolver asking `f.hasAnnotation("Hot")` is reading a fact the author wrote on the field, at the
field, which is where a reader will look for the reason it moved.

**What is deliberately still out:** the field's *value*, anything about the methods of its type, and
anything about other declarations in the program. A resolver decides where bytes go; the moment it
can read the program it becomes a macro system, and §10's whole argument for `comptime` is that the
resolver writes ordinary code over a **small** vocabulary.

### 13.4 `align` needs the `padding` concession — because alignment *is* padding

**Decided: refuse without it.**

The question was whether alignment is padding, and it is: putting a field at a 64-aligned offset when
its type wants 8 means inserting up to 56 bytes that nothing asked for. That is precisely what
`padding` grants (§6: *"beyond what alignment requires"*), and the field's own alignment requirement
is not what is doing the work here — the resolver's `64 bytes` is.

**The alternative reading is worse than merely wrong.** If `align` were free, then `WireRecord`,
which permits nothing, could have its fields spread across 64-byte boundaries by its resolver, and a
declaration whose entire purpose is *both ends index this* would have granted the one thing it meant
to refuse. §8's rule is that a resolver exceeding its concession is an error naming the line it did
not have; this is that rule, applied to the verb where it is least obvious and therefore most needed.

**`isolate` needs it too**, for the same reason and more obviously — a cache line to itself is padding
by definition. It is stated here because §8.1 says `isolate` is *not* sugar for `align(f, 64 bytes)`,
and two verbs that are deliberately not the same thing might have been thought to need different
concessions. They need the same one.

### 13.5 On an `entity`, the verbs mean columns — and `together` is the new one

**Decided.** `layout` over an `entity` arranges **columns**, and each verb keeps its sense with the
subject changed from *field of an instance* to *column of the entity*:

| | over a struct | over an entity |
|---|---|---|
| `place(f)` | the field goes next | the **column** goes next |
| `isolate(f)` | a cache line to itself | the column's storage is its own allocation — no other column shares a line with it |
| `align(f, N)` | an N-aligned offset | each column's base is N-aligned, which is what a vector load wants |
| `pad(N)` | a hole | a hole between column allocations |
| **`together(a, b, ...)`** | — | the named columns are **interleaved**: AoSoA |

`together` is the one with no analogue, and it is the only addition. It exists because AoSoA is *the*
thing a column layout wants to say and nothing else can say it: `place` puts columns in an order,
`isolate` separates them, and neither expresses *these three travel as one block of N-element
groups*. The group width is the target's vector width, for the same reason `isolate` does not write
64 in the source — the intent is *these are read together*, and the width is one machine's answer.

**Concessions carry over unchanged and mean more here.** `reorder` over an entity is permission to
change **column order**, which is invisible to every reader of a row and therefore nearly free —
where over a struct it changes offsets that an FFI boundary might depend on. `permits` nothing over
an entity is the AoSoA-forbidding case: a column format read by something outside the program.

**And completeness still means every column exactly once**, including one named inside `together`.
A column that is interleaved and also placed is placed twice, which is the error §8.1 already
defines — arriving through a verb that makes it easy to do by accident.
