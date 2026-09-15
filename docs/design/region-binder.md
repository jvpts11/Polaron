# The region binder: what it checks, and what it would take to be Rust

*Measured 2026-08-14, by probing the compiler — not by reading the spec. The region binder is **on by
default** since 1.0.18, so nothing below is explained by it being switched off.*

---

## BUILT — 2026-08-16

**Everything below the line was the plan; this section is what happened to it.** Steps 1, 2 and 3 are
built, and step 4 exists behind a flag with the measurement it needed. 929 tests.

**The name is true now.** Four regions, ordered as the model states, with §3 generating every error:

    Root  ⊒  Object ◇o  ⊒  Region R  ⊒  Activation ◇m

**Lifetime is a property of a VALUE** (`lifetimeOf`, beside `typeOf`), which is the structural change
and what closes cases (b) and (d) of the experiment below — an escape nobody named, and an object in
a region. All four now report.

**Ownership is read off the DESTRUCTOR.** This is the piece that makes `object ◇o` decidable with no
annotation on any field, and it is the model's own first sentence made good: regions come from
structure the language already has. A `T*` field may be ownership or a borrow and the type says
nothing — but the destructor does, because the author already had to write it. A field it frees is a
handover; a field it leaves alone is somebody else's.

Getting that half wrong is worth recording: without it the check reported every constructor, setter
and `list.add` in the language — **808 of 925 tests**. That is not a measurement, it is noise, and a
checker that cries at `add` gets switched off and then checks nothing.

**A proof and an absence of proof are different diagnostics.** Frame-local or region storage escaping
is a proof — the release is a point the program states — and errors. Two different objects are merely
incomparable, and warns.

**`release` kills every pointer into the region**, flow-sensitively, with its own message. The one
shape that must stay legal is next door and the first version refused it: `cascade move` relocates
the object, so the map that says where things live has to follow the move.

**A virtual call reads the union over every override.** The one place inheritance costs this analysis
anything — and not because ownership and inheritance conflict. Inheritance is an *identity* relation
and the region tree is a *containment* one: a Derived is not inside a Base, it IS one, so a hierarchy
adds no nodes to the region tree at all. What it adds is several callees behind one call.

### The number nobody had

Step 4 says the default must flip — refuse what cannot be proven — and that the size of the output is
the real measurement of how far the language is from the guarantee. `--strict-regions` is that flip,
behind a flag because it is a decision and not an implementation detail. Measured:

| | as it ships | `--strict-regions` |
|---|---|---|
| the standard library (20 439 lines, 338 types) | **10** | **35** |
| the SQL engine (20 files, written to be measured) | **3** | **9** |
| 120 compiler samples | **8** | — |

**Thirty-five sites in the whole standard library.** The flip is affordable, and that was the thing
nobody could say before.

### §10, sub-regions and nesting — built the same day

Two explicit regions were compared by IDENTITY, so a nest of them was a set of unrelated boxes: the
direction that is a bug looked exactly like the direction that is fine.

**The order needs no model of the nest.** Regions are released last-in-first-out — at scope exit, in
reverse declaration order — and a region declared inside a block is necessarily born after the region
enclosing that block. So *born earlier* is exactly *dies later*, and **one number per region** orders
an arbitrarily deep nest. Nothing about lexical depth is tracked separately, because an inner region
cannot be born before the outer one it sits inside.

That is the whole of §10, and it is why this is a scope-nesting check rather than lifetime inference:
a region's lifetime is lexical and declared, not inferred, which is what lets the model reach temporal
safety without a borrow checker.

`region_nesting_bad.pol` carries **both directions**, because a rule that refuses everything is not an
order: a scratch node pointing at durable data stays silent, and the durable node pointing into the
scratch region is the one error.

### Two more shapes it could not place — 2026-08-17, found by the kernel

The kernel was the first program to run against this and it reported **7**. Six of them were the
analysis, in two shapes, and both are closed the way the others were: by teaching it to place a real
shape, not by relaxing anything. 961 tests, and pico went 7 → 1.

**An accessor returning a borrowed field placed nowhere, while reading the field placed at the
object.** `p.handles` was `Object(p)`; `p.table()`, whose whole body is `return this.handles;`, was
unplaceable — `ownsField` gated the call path while the field path used the borrowed-field induction.
Two spellings of one value disagreeing is not a rule, and it was the whole of what stopped the
kernel, because every store there goes through the accessor. The induction is the same one the field
read already runs on: every store into that field was itself checked, so the holder is a true LOWER
BOUND, and a lower bound can refuse a program that was fine but never accept one that was not.

**Ownership written more than one call from the destructor was not read.** The helper scan went one
level deep, on the reasoning that ownership three calls away is unreadable anyway. The ordinary shape
reaches two by itself: `~HandleTable` calls `closeAll`, `closeAll` closes each slot in a loop, and
the `delete` is in `close`. Nothing about that is hard to read. It is a worklist now rather than a
depth limit — the right bound is "everything this destructor can reach on itself", and any number
picked instead is a number some real cleanup chain exceeds. The `this.<m>()` calls are collected on
the SAME walk that finds the deletes, so a helper hiding in a `while` is found by the code that
already finds a `delete` hiding there, and the two cannot drift.

### The shape the MODEL has no word for

The one diagnostic left in the kernel is not the analysis being wrong. `TcpListener.openTo` returns
`this.slots[i]` — a connection living in the listener's own array, which the listener **recycles**
when it goes idle — and `SocketFile.attach` keeps that pointer with no identity check, while
`destroy` frees only the datagram endpoint. So a socket outliving its connection reads a slot that
`openTo` may already have handed to somebody else. That is the same defect as a result set holding
rows its table freed, and the region binder found it in a kernel that had passed 132 tests.

It also names a gap in the model rather than in the code. What the socket wants is neither of the two
things the message offers: not a copy, and not ownership of a slot somebody else recycles. It wants a
**validated handle into another object's pool** — an index plus a generation, the standard answer for
every pool, slab and handle table — and the language has no word for that. `weak` is the closest and
is wrong here: it nulls on a target's DEATH, and a recycled slot never dies, so marking the field
`weak` would silence the diagnostic and leave the bug.

### The handle the language has no word for — decided (Wave 4.5): **it needs no word**

A validated handle into another object's pool — index plus generation — is not a reference, and that
is exactly why it is the answer. It is a **value**: two integers, copied freely, stored anywhere,
outliving whatever it points at without danger, because holding one is not holding the object. The
region binder has nothing to refuse about it — and that is not the binder being evaded, it is the
binder having nothing to say, because there is no lifetime relationship to check.

**Every part is already in the language.** `stable entity` (`entity.md` §8) means rows never move, so
an index is a permanent reference — that document's exact words. A generation counter is a column
beside it. `Handle<T>` is then a two-field `record` in the prelude, and the pool's accessor compares
the generation and returns `Option<T&>`: a recycled slot has a different generation, so a stale
handle **reads as absent rather than as somebody else's object**, which is the bug this section opens
by describing.

**What is genuinely owed is the diagnostic, not the construct.** The message today offers two things
the socket does not want — a copy, or ownership of a slot somebody else recycles — and never names
the third. It should, and it should say why `weak` is wrong here in one line: *`weak` nulls when the
target dies, and a recycled slot never dies, so it would silence this and leave the bug.* That
sentence is in this document and not in the compiler, which is the whole distance left to travel.

### What is still not built, and it is deliberate

`&mut` exclusivity — a separate question about aliasing, and it stays one. Steps 1–3 plus §10 reach
**temporal** safety, which is what the region model was designed to promise.

**Data-race freedom is decided elsewhere and does not arrive here as a side effect**, which was the
concern. `ownership.md` §13–14 makes `Shared` a checked property rather than a trusted marker, §18
grades the five ways across a thread boundary, and §20.5 decides that **a region may not be
`Shared`** — precisely because this binder's model is one activation at a time, and region release is
bulk and instantaneous, so there is no per-object lifetime for a second thread to reason about. The
answer for concurrent work is a region per thread with `move` across (§11), which has no
synchronisation on allocation at all and is therefore faster than a shared region would be.

The split is settled rather than pending: **temporal safety is this document's, data-race freedom is
`ownership.md`'s, and neither is a side effect of the other.**

---

> Its name is **region binder**, both words. Calling it "the binder" is not shorthand, it is the
> mistake this whole note is about: what it binds is supposed to be **regions**, and that is precisely
> the part that was never built.

## The one experiment

Four methods. In each, the receiver `h` is a **parameter**, so it genuinely outlives the frame and the
escape is real in all four. Only the spelling differs.

```polaron
public static method a(Holder h) returns void {     // CAUGHT
    Node n = new Node(1);
    h.kept = n;
}
public static method b(Holder h) returns void {     // MISSED
    h.kept = new Node(2);
}
public static method c(Holder h) returns void {     // CAUGHT
    Node n = new Node(3);
    nullable Node* alias = n;
    h.kept = alias;
}
public static method d(Holder h) returns void {     // MISSED
    region scratch = itself.allocate(512 bytes);
    Node* n = new Node(4) in region scratch;
    h.kept = n;
}
```

Two of four. And the two it misses are the two that matter most: **an escape that was never given a
name**, and **an object that lives in a region** — the thing the analysis is named after.

## What it actually tracks

`activationOwned_` is a set of **local variable names**, populated at a declaration when the
initializer is:

```cpp
if (nw != nullptr && nw->region.empty() && nw->location != "heap") { ... }
```

Read that condition. A frame-local `new T()` goes in; `new T() on heap` does not, correctly; and
**`new T() in region R` does not either**. So a region-allocated object is invisible to the region
binder from the first line. Aliases and `move`s of a tracked local propagate the tag, which is why (c) is
caught.

Three checks consume the set, and all three pattern-match on an `IdentifierExpr`:

1. `return localName`, when the return type is a reference type.
2. `outliving.field = localName`, when the field is a reference type.
3. A call whose escape summary says the callee stores parameter *i* into its receiver or into another
   parameter, and argument *i* is a tracked local.

## Why it has never fired on real code

Three reasons, and they compound.

**It is not about regions.** Everything region-allocated is excluded at the point of tracking, so no
program that uses regions can trip it. A codebase that uses regions well is a codebase where this
analysis has nothing to say.

**It matches identifiers, not values.** An escape has to be spelled as a bare name on both sides. A
temporary, an array element, a field read, a call result — all invisible. Real code is full of these.

**Its default is "allowed".** No escape summary for a callee means no error. An unresolved receiver
means no error. A shape the pattern does not match means no error.

> Rust's checker **refuses what it cannot prove**. This one **accepts what it cannot prove**.

That difference is the whole story. A checker whose default is *allowed* can find bugs but can never
state a guarantee — and it will be quiet on any codebase whose idioms it does not happen to match.

## What was SPECIFIED, and what of it exists

The model is written out in `pico/docs/polaron-safety-model.md`, §1–§14. Its first sentence is the
whole design: **regions are inferred from structure the language already has, and the region tree IS
the composition/encapsulation tree.** Every value lives in exactly one region; the regions are totally
ordered by *outlives-or-equal*; and one rule (§3) generates every error.

Measured against the code, section by section:

| specified | built |
|---|---|
| **§1.2 four region kinds:** `root`, `activation ◇m`, `object ◇o`, explicit `region` block | **one and a half.** `activation` exists, as a set of *names*. `root` is not modeled. **`object ◇o` is not modeled at all.** Explicit `region` blocks are tracked (`regionOf_`) but **excluded from the escape analysis**. |
| **§1.3 a total order over regions** | **a boolean.** In the frame, or not in the frame. There is no order because there are no other regions to order. |
| **§1.1 every value lives in exactly one region** | values have no region. *Names* have a tag, and only inside the method being analyzed. |
| **§3 the Prime Rule** | **one instance of it**, restricted to the activation region and matched syntactically against `IdentifierExpr`. |
| **§5 the access modifier is the escape ceiling** | **nothing.** Visibility is never read by the escape analysis. (And separately: `private` is not enforced anywhere in the compiler at all — see `spec-divergences.md` §9.1.) |
| **§7 liveness → use-after-move / use-after-free** | use-after-**move** exists and predates the region binder (`moved_`). Use-after-**extract** exists and is good — including `Polaron-1718`, which catches extracting an object whose *field* still lives in the region. Use-after-**release of a region**: absent. |
| **§8 parameters and returns, via summaries** | **built, and it is the strongest part**: a transitive fixpoint over escapes-into-receiver and escapes-into-parameter, serialized through the `.polh` so it crosses a bundle. |
| **§9 collections** | built — the summary records the store and the call site decides aliasing from the concrete argument type. |
| **§10 sub-regions and nesting** | absent. |

> **The part that was never built is the part the name is about.** Nothing divides the program into
> regions. Nothing reads the encapsulation tree. There is no proof that a value does not outlive the
> release of its region, because no value is assigned a region in the first place.

What exists is one method at a time, one lifetime boundary (this frame), and a set of names — plus a
genuinely good interprocedural escape summary sitting on top of it. That is an **activation-escape
checker**. It is a slice of §3 and all of §8, and it was worth building; it is not the region binder
the model describes.

This also explains, better than any of the reasons below, why it has never fired on real code: the
model's power comes from `object ◇o` — a reference to something a *different object* owns, outliving
that owner. That is the shape real programs get wrong, and it is the one region kind that does not
exist.

## Region LEAKS are a different matter, and largely closed

Measured, not assumed:

| shape | verdict |
|---|---|
| a class owning a `region` field whose destructor forgets to release it | **caught** — `Polaron-0803` |
| a class owning a `region` field with no destructor at all | **caught** — `Polaron-0803`, naming the destructor to write |
| a local `region` on a method with an early return | **not a leak** — a scope region is released on every exit path; the IR carries a release per path |

So the open problem is **not** leaks. It is **use-after-free**, which is the harder half and the one
the region binder was created for.

Not checked at all today: reading through a pointer into a region **after** `release region R`. This
one is embarrassing precisely because it is easy — the analyzer already keeps flow-sensitive
`deleted_`/`freed_` sets for `delete`, so the machinery exists and simply does not cover regions.

## What it would take to reach Rust's level

In the order I would build them. The first three are one project; the fourth is a separate decision.

### 1. Give every EXPRESSION a lifetime, not every identifier a tag

The single structural change, and it fixes case (b), array elements, call results and field-to-field
in one move. Today lifetime is a property of a *name*; it has to become a property of a *value*,
computed by the same walk that computes its type. `typeOf(expr)` gains a companion
`lifetimeOf(expr)`.

### 2. Build the four regions the model already specifies, and order them

This is not new design work — §1.2 is written. Today there is a boolean; what it needs is the order
the model already states:

```
root  ⊒  object ◇o  ⊒  explicit region R  ⊒  activation ◇m
```

with §3, unchanged, generating every error: **a referring binding may only point at a region that
outlives its own.**

The one that pays is **`object ◇o`** — everything an object owns is its region, and the region tree is
the encapsulation tree, which the language already has and no other language can rely on because they
all have free functions. That is the whole bet of the design, and it is the piece that is missing.
Adding it turns *"is this in my frame?"* into *"whose is this, and does that owner outlive the place
I am storing it?"* — which is the question real code gets wrong.

Explicit `region` blocks join the same order for free: a region's lifetime is its lexical scope, which
is what makes all of this a **scope-nesting check rather than lifetime inference**, and is why it
needs no borrow checker. It is also what makes case (d) an error instead of silence.

### 3. Kill pointers at `release`

`release region R` invalidates every value whose lifetime is `region R`. After that statement, a read
through one is an error naming the release. Flow-sensitive, and the analyzer already does this shape
for `delete`.

### 4. The default has to flip

This is the painful one and there is no way around it. To *guarantee* rather than *find*, an unknown
callee, an unresolved receiver and an unmatched shape must all mean **refused**, not allowed. That is
where Rust's learning curve comes from, and adopting it means every existing program has to be
re-examined.

Staged honestly: flip it to a **warning** first, run it over pico, decomp and the stdlib, and read what
comes out. The size of that output is the real measurement of how far the language is from the
guarantee — and it is a number nobody has today.

### And the half that is a separate decision

Rust's guarantee is two things: no use-after-free **and** no data race, and the second comes from
`&mut` exclusivity — no two live mutable references to one object. Polaron has no such rule.
`unique class` and `movable` gesture at it without enforcing it.

Steps 1–3 reach **temporal** safety, which is the promise the region model was designed to make and
is achievable without a borrow checker, because a region's lifetime is lexical and declared rather
than inferred. Data-race freedom is a further rule about aliasing, and it should be decided as its
own question rather than arriving as a side effect.
