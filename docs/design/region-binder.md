# The region binder: what it checks, and what it would take to be Rust

*Measured 2026-08-14, by probing the compiler — not by reading the spec. The region binder is **on by
default** since 1.0.18, so nothing below is explained by it being switched off.*

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
