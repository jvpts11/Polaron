# Transformers

*Design note, 2026-08-11. A new namespace-level declaration, `transformer`, and a new kind of member,
`procedure`. This note is the decision record, written so that the reasons survive as well as the
rules. **The core is now built — see "What is built" at the end for exactly how much.***

## What a transformer IS

> A **transformer** is a construct that establishes a **transformation relation between two classes**.

`class` says what a thing **is**. `interface` says what it **must be able to do**. `layout` says how
it **arranges itself**. **`transformer` says what a type gains — and how it relates to the other
types that gain the same.**

Inside one live **variables** and **transformable methods**. A transformable method is an abstract
method that may nevertheless carry a default implementation inside the transformer itself, and that
implementation can still be swapped for one belonging to a class. Nothing among ordinary methods does
that, which is why the word is different: these are **procedures**.

A transformer is **not implemented and not extended. It is applied** — and it has exactly two
operations, **application** and **call**, both below. It is never instantiated, and it is resolved
entirely at compile time, so it **creates no vtables**.

## The hole it fills

Look at what Polaron can declare today: `class`, `record`, `interface`, `catalog`, `enum`, `union`,
`layout`. **Every one of them has a single type as its subject.** They say what a thing is, what values
it has, what shape it takes in memory, what it must be able to do. Not one of them says what a type
**gains**.

Other languages fill that gap with a lambda — a body of behaviour you can name, hold and pass around
without a class. Polaron refuses first-class functions, deliberately and permanently: **behaviour lives in
methods, and methods live in types.** That decision is right, and it left nothing in its place at
declaration level.

A `transformer` is that missing piece. It is a **noun** — a thing, with a name, that you can point at —
and it is never instantiated. It produces nothing you can hold. What it produces is what the types that
apply it gain.

> `class` says what a thing **is**. `interface` says what it **must be able to do**.
> `transformer` says what a type **gains by applying it**.

## Two words: method and procedure

```
A METHOD's signature is fixed where it is declared.
A PROCEDURE's signature is completed at the type that applies it.
```

That is the whole distinction, and it is why the second word is needed. Inside a transformer, `itself`
is *the type that will apply this* — a type that does not exist yet. A procedure returning `itself`
returns a different type in every type that applies it.

This is what "abstract, but with an implementation" means: a procedure's body exists, but it is not code
for any type yet. It is not floating behaviour — **its subject exists, it just does not know its name.**

### The subject rule

An action lives in a method or in a procedure. Both have a subject. This is the same rule that killed
`static_assert` at namespace level and turned it into `demand`: `static_assert(x)` sitting in a
namespace was an imperative about nothing in particular — an action with no owner, in a place where only
declarations belong.

It follows, and is not a separate rule, that:

> **A static procedure must mention `itself` in its signature.**

`static procedure from(Other value) returns itself` — legal; it is about the applying type.
`static procedure max(int a, int b) returns int` — rejected; it names no subject, so it is `static_assert`
in a new suit.

## Naming: `T` + stem + `er`

> `public transformer TDescriber`, never `public transformer Describe`.

A transformer is **the coupling between two types and neither of them** — an electrical transformer
has two windings and is not either winding. So it is named for the AGENT of the relation, which is
what the `-er` says, and the leading `T` says at a glance which of the three list-like clauses on a
class line you are reading: `extends` is identity, `implements` is obligation, `applies` is
equipment, and only the third holds these.

A **warning**, not an error, like the PascalCase convention it sits beside — it nudges without
breaking code written before the rule. The compiler **generates the name** rather than only
demanding one, because a diagnostic that says "wrong" and stops has handed the reader the rename.
`able`/`ible` are trimmed first, which is what makes the examples in this very note come out right:

| written | suggested |
|---|---|
| `Describable` | `TDescriber` |
| `Convertible` | `TConverter` |
| `Sortable` | `TSorter` |
| `RegionOwner` | `TRegionOwner` |

## The declaration

```polaron
public mutual transformer Convertible {
    error Failed;

    procedure into<Other>() returns Other;
    static procedure from<Other>(Other value) returns itself;
}
```

A transformer may contain:

- **procedures**, with or without a body;
- **applied fields** — state that goes into every type that applies it;
- **constants** (`fixed`);
- **an error type** it declares for its own failures.

It may not contain mutable state of its own. See [State](#state), below.

## Applying it

```polaron
public class Celsius extends Temperature implements IHeat applies Convertible { }
```

The order on the class line is deliberate: it runs from **identity** to **obligation** to **equipment**.
`extends` is one, is-a, the tightest coupling. `implements` is many, and is a promise made to the
outside world. `applies` is many, purely additive, and nobody outside needs to know about it.

> **`implements` is a promise. `applies` is equipment.** That is why they are separate clauses rather
> than one list.

### Implementations are written as `procedure`

A type that supplies its own body for an applied procedure writes it with `procedure`, not `method`:

```polaron
public class Celsius extends Temperature implements IHeat applies Convertible {
    private mutable int degrees;

    public procedure into<Fahrenheit>() returns Fahrenheit {
        return new Fahrenheit(itself.degrees * 9 / 5 + 32);
    }
}
```

This is not documentation, it is **checked in both directions**:

- writing `method into()` when `into` came from an applied transformer is an error;
- writing `procedure foo()` when no applied transformer declares `foo` is an error.

Provenance therefore does not depend on an editor. Open the file in a terminal, a diff or a review and
you can see what came from a transformer and what is the type's own. This is what `@Override` in Java
tries to be and fails at, because it can be omitted.

The cost is the same one inheritance already has: procedures the type does **not** override do not appear
in its text. That is a known cost, not a new one, but it should be stated rather than discovered.

## Procedures

### Bodies and dispatch

A procedure with no body is a **socket**: the applying type must implement it, or the error lands on the
`applies` line naming what is missing. A procedure with a body is an implementation the type gets for
free and may replace.

**Calls between procedures inside a transformer dispatch to the applied version.** This is what makes the
feature useful — the transformer writes the algorithm, the type supplies the parts:

```polaron
public transformer Sortable {
    public procedure sorted() returns itself {
        // ... compare(a, b) ...
    }

    protected procedure compare(itself a, itself b) returns int;   // socket
}
```

A transformer declares its own sockets this way instead of borrowing an interface for them. `requires`
stays for demanding things that exist independently and that other declarations also name.

`final procedure` seals a body: the applying type may not replace it.

### Visibility is what the member ENTERS THE CLASS with

> The visibility written on a procedure is **not** about who may reach it inside the transformer.
> Nothing can reach into a transformer at all — the only way to get at a procedure is to apply the
> transformer that holds it. It is the visibility the member **enters the applying class with**.

So procedures are **private by default**. Applying a transformer is equipment, not a promise made to
the outside world, and a procedure that belongs on the type's public surface says so.

**Corrected 2026-08-14, and the default is what settled it.** This was first built the other way
round — "application is about existing, reach is about calling", with `private` denying `call`. That
reading cannot survive the default: it would disable the second of the feature's two operations in
the ordinary case. `call` is restricted by its subject (only inside a declaration that applies the
transformer) and by nothing else.

### Static procedures

A static procedure exists because one end of a relation is often a type you do not own. You cannot write
`int applies Convertible`, so the way back from `int` must live on the type that does apply it, and there
is no instance to hang it on — you are holding a raw `int`:

```polaron
Errno e = Errno.from(-14);
```

The subject is `Errno`. The verb always has a noun in front of it.

### `call`

```polaron
call RegionOwner.releaseStore();
int a = call SomeTransformer.someProcedure();
```

> `call` exists because **there is no receiver to write to the left of the dot**.

Three rules follow:

1. It is legal only inside a declaration that applies the transformer. Outside, it would be an action
   with no subject — and this is the only restriction on it.
2. It reaches the **transformer's** body, not the applying type's override. If you wanted the type's, you
   would write `itself.p()`. `call` means *"my type replaced this, and I want the original anyway."*
3. Inside the transformer, no `call` is needed — you are already there, so `dosomething()` resolves
   normally. This is not an exception to the rule; it is the rule (there is a receiver).

## Derivation

> **A procedure is derivable when the answer is already entirely inside its input.**

This is a property of the question, not of the kind of declaration:

| | derivable? | why |
|---|---|---|
| `clone()` on a `record` | yes | the answer is the structure |
| `clone()` on an `enum` | yes, trivially | a constant is its own clone |
| `into()` from `Errno` to `int` | **no** | it is a table |
| `into()` from `Celsius` to `Fahrenheit` | **no** | it is a formula |

`record` has non-derivable cases and `enum` has derivable ones, so the split is not between kinds. Where
the answer is new information — a table, a formula — there is nothing to derive, and the transformer's
contribution is not a body but an **obligation**.

## Totality and partiality

Where a procedure's **source** is a closed kind, the compiler checks that the implementation covers it.
This is constructor definite assignment, generalised:

| kind | what must be covered |
|---|---|
| `class` / `record` | every **field** |
| `union` | every **alternative** |
| `enum` | every **constant** |

Adding a constant to an enum then becomes an error in the implementation, naming the constant. A `union`
needs no separate rule: an alternative has fields, so it is the `record` rule running underneath the
`enum` rule.

Partiality is **deduced, never annotated**:

> A procedure whose source is a **closed** kind may be total, and is checked.
> A procedure whose source is an **open** type is fallible by construction, and must return a result that
> can fail.

`Errno → int` is total: the constants are a finite list you own. `int → Errno` is not, and no annotation
is required to say so — there is no list to cover, and the compiler knows it. When both ends are closed
(`HidUsage ⟷ ScanCode`), both directions are total and both tables are checked against different lists.

## Pairs, and `mutual`


Nothing declares "A converts to B". Two types apply the same transformer and implement its procedures,
and **the transformation emerges from the pair**. Direction emerges too: one side implemented means one
way, both sides means both.

This is why the word fits. An electrical transformer has two windings and is neither of them; it is the
coupling. Two types, two windings.

What does not emerge is the *obligation* to write the second side. `mutual` declares it:

```polaron
public mutual transformer Convertible { }
```

> If `X` applies a `mutual` transformer and implements `into<Y>`, then `Y` must apply the same
> transformer and implement `into<X>`. The error lands on `X`, naming the `Y` that did not answer.

`mutual` also says when it cannot be used: `Errno ⟷ int` cannot be mutual, because `int` is not yours and
applies nothing. The compiler says so up front instead of letting you find out later that you have half a
relation. The way back still exists — as the partial static procedure above.

## Sets, and `collective`

*Added 2026-08-14.*

`mutual` is a relation over a **pair**. There is a shape it cannot say, and it is the one that comes up
whenever several types are different encodings of one value: that **all of them convert among
themselves**.

```polaron
public collective transformer TScaler {
    public procedure into<each Other>() returns Other;
}
```

> `mutual` says a pair is symmetric. **`collective` says the appliers form one transformation set**, so
> each of them can become any of the others.

This shape has always been written by hand, and the patterns it is written with are the evidence that
the language could not say it: a canonical pivot type everything converts through, a registry of
converters, double dispatch, a visitor. None of them is about the problem; all of them are about the
missing declaration.

### Composition is what makes it affordable

Taken literally, a complete relation over N types is N(N−1) procedures, and nobody would write it. So
the conversions you write are **edges**, and the compiler completes the graph along them:

```polaron
public class Celsius    applies TScaler { procedure into<Fahrenheit>() { ... } }
public class Fahrenheit applies TScaler { procedure into<Kelvin>()     { ... } }
public class Kelvin     applies TScaler { procedure into<Celsius>()    { ... } }
```

Three procedures, **six conversions**. `Celsius → Kelvin` is composed through Fahrenheit;
`Kelvin → Fahrenheit` through Celsius. The requirement is that the digraph be strongly connected, and a
cycle is the cheapest way to satisfy it: N types, N edges.

**The pivot pattern is not made easier. It stops being necessary** — because a pivot *is* a path through
this graph, so it stops being something anybody writes down.

### Two rules keep it honest, and they are already the feature's rules

> There is never an implicit winner, and never an order.

- **No path** → an error naming the pair, and naming the cheap fix: any conversion that reaches it,
  because the rest is composed.
- **Two shortest paths tied** → an error naming where they fork. A composed conversion may not pick one.
  You break the tie by writing that conversion, exactly as a member-name collision between two
  transformers is broken by the type.

The second is the important one. Silently taking either route would make a conversion's *answer* depend
on a graph nobody drew — and in `Celsius → Kelvin` the two routes differ by rounding, which is a wrong
answer arriving quietly.

**And composition here is not the compiler writing code nobody asked for**, which the destructor section
below rejects for good reason. The word on the transformer is the request. Without `collective` nothing
is composed at all.

### What is in the relation and what is not

- **Instance per-target families only.** A `static` per-target procedure converts *to* this type from an
  open source; it is the escape hatch for types you do not own, and a relation cannot range over `int`.
- **Composable means the shape is a conversion**: no parameters, returning the target. A family of any
  other shape — `render<each Other>(Other into)` — must still be complete, because that is what the word
  promises, but there is nothing to compose along, and saying so beats generating a body that means
  something else.
- **Private edges are not paths.** A `private procedure` is the type's own business; a composed body may
  not reach through it.
- **A composed conversion is exempt from the totality check.** It reads no field, and demanding that it
  should would be asking it to redo the work: its totality is inherited from each hop, checked where
  that hop was written.
- **`collective` implies `mutual`.** A complete relation contains the way back from every pair, so
  writing both is accepted with a warning that says which one is doing nothing.

### Seeing what was derived

Composed conversions are listed in the generated documentation, with the route they take. A derived
conversion nobody can see is a conversion nobody can audit — and it answers the question that follows
immediately, which is where the rounding went.

## Transformers applying transformers

```polaron
public transformer Sortable applies Comparable { }
```

means **"whoever applies `Sortable` also applies `Comparable`"**. The carrier receives nothing; the
procedures land in the type.

**There is no linearization problem, and the reason is `call`.** Scala's traits need an order because
`super.foo()` means "the next trait in the order". `call Comparable.compare()` names its target. No chain,
nothing to linearize.

It follows that:

- **Applying twice is applying once.** A transformer has no constructor, no state of its own and no
  ordered initialization, so the closure is a set union deduped by identity. A diamond never forms.
- **Cycles are legal.** `A applies B` and `B applies A` computes to `{A, B}` and stops. It is harmless —
  and it is also empty of meaning, because `applies` is *inclusion, not direction*. Bidirectionality lives
  between types, not between transformers; see `mutual`.
- **Collisions are resolved by the type.** If two transformers bring `describe()`, the type either
  implements it or gets an error on the `applies` line. There is never an implicit winner and never an
  order.
- **Field collisions are an error, full stop.** A type cannot "implement" a field to break the tie. This is
  also a reason for transformers to be frugal with fields.
- **`requires` must travel with the message.** *"Celsius applies Sortable, which applies B, which requires
  Comparable"* — otherwise someone reads an error about an interface they never wrote.

The cost of transport is that the class line stops showing everything: a grep for `applies Comparable` no
longer finds every type that has it. The choice is per transformer and is explicit — `requires` forces the
type to write both and keeps the grep working; `applies` hides it in exchange for brevity. See also
`explicit`, below.

## State

```polaron
public transformer RegionOwner {
    protected mutable region store;      // APPLIED FIELD: every applying object has its own
    private fixed int Slack = 512;       // CONSTANT: the transformer's, and goes nowhere
}
```

**The applied field is why this is not an interface.** An interface cannot give you state. A transformer
can, which is what lets it supply the `store` field *and* the code that releases it. Each applying object
has its own; the transformer is a mould for state, not an owner of it.

**Mutable state belonging to the transformer itself is not allowed.** A transformer is never instantiated,
so such a variable could only be a global shared by every applying type, or a per-type static — and the
second already exists as a static field on a class. The first is the same disease that killed
`static_assert` in a namespace, in data rather than in actions: **state with no subject**, invisible to the
region model, owned by nobody, synchronised by nobody.

The test: **a `mutable` in a transformer is legal only if it is applied.** Otherwise it is `fixed`, or it
does not exist.

## Construction and destruction

An applied field is subject to both ends of the same rule:

| | |
|---|---|
| **construction** | it must be assigned — definite assignment |
| **destruction** | it must be released — **definite release** |

Definite release is new and is worth having on its own, with no transformers involved:

> A `region` field must be released on every exit path of the destructor.

It is the same dataflow as definite assignment, run backwards. Forgetting it is a silent leak today.

### The destructor is not woven

A transformer does **not** contribute code to a destructor the type already has. Weaving would mean an
implicit order between transformers, and — decisively — that order would not even be visible on the class
line once a transformer is transported by another. You would have code running in your object's
destruction in an order determined by a chain you did not write.

With definite release in place, no weaving is needed:

```polaron
public explicit freestanding transformer RegionOwner {
    protected mutable region store;

    protected procedure releaseStore() returns void { release region itself.store; }
}
```

```polaron
public class DeviceRegistry applies RegionOwner {
    public destructor ~DeviceRegistry() returns void {
        call RegionOwner.releaseStore();
    }
}
```

Forgetting the line is an error that writes itself: *"DeviceRegistry applies RegionOwner, which brings the
region field `store`, and the destructor does not release it."* It names the transformer, the field and
what is missing.

**And the ordering problem does not get solved — it stops existing.** Two transformers with region fields
are two lines in the destructor, in the order the type wrote them. Nothing is implicit, nothing depends on
the `applies` list, and reordering the class line changes nothing.

The remaining ceremony belongs in the **diagnostic**, not in the language: the error carries the fix, and
the editor applies it. The compiler does not write code nobody asked for.

## Modifiers

A modifier earns its place if it **changes what the compiler checks at the declaration**. If the
information is already in the body, deduce it; if it is a list, make it a clause.

| modifier | meaning |
|---|---|
| `public` / `private` | visibility of the transformer in its namespace |
| `mutual` | pairs must be symmetric, and this is checked |
| `freestanding` | the bodies obey the bare-metal subset |
| `explicit` | may only be applied directly by a type, never transported by another transformer |

`freestanding` is the one that earns its place most clearly. Without it, a transformer whose bodies use
string interpolation or exceptions compiles happily and fails **in somebody else's kernel**, three layers
down, on a line they did not write. Marking it here puts the check where the code is — the same argument as
the freestanding import gate.

`explicit` buys back the readability lost to transport. A transformer marked this way always appears on the
class line, so the grep finds everyone. For anything that puts a field and a release obligation inside your
type, this should be the norm. It is deliberately *not* called `sealed`: that word means "cannot be
extended" elsewhere, and this is a different thing.

`final` belongs on a **procedure**, not on the transformer: the applying type may not replace this body.
Since internal calls dispatch to the applied version, there has to be a way to say "not this one".

### Rejected

| | why |
|---|---|
| `abstract` | a transformer is already part abstract by construction — bodiless procedures are the sockets, bodied ones the implementation |
| `static` | it is never instantiated; there is nothing to contrast with |
| `eternal` / `persistent` | it has no state of its own |
| `layout`, `heap` | it is not a memory shape and allocates nothing |

### Deduced, not declared

**Which kinds may apply a transformer.** `RegionOwner` makes no sense on an `enum` — a constant cannot own
a region — but that is already written in the body: it declares a `mutable` field and an enum has no
fields. The compiler can say so on the `applies` line without anyone writing an annotation.

## Interaction with the rest of the language

**`layout` is the real conflict.** A type with a pinned layout is an ABI; `Dirent` exists to match the bytes
Linux expects. A transformer that brings a field would break it silently. **A type with a `layout` may only
apply field-less transformers**, and the error says why.

**Regions.** An applied `region` field puts the transformer inside the ownership tree, and the region binder
must see it exactly as it sees any other field.

**Freestanding costs nothing.** A transformer is resolved at compile time — the same monomorphization
machinery, running over another list. No vtable unless it satisfies an interface, no allocation, no
indirection. What you pay is exactly the code you would have written by hand, which is what makes it usable
in a kernel without thinking twice.

## What would improve it next — 2026-08-14

*Nothing below is built. Ordered by what I would build first, and judged by this note's own rule for a
modifier: it earns its place if it changes what the compiler checks at the declaration.*

### 1. `applies` as a CONSTRAINT, not only a clause

`method f<T implements IShape>()` exists. `method f<T applies TComparer>()` does not, and neither does
`demand T applies TComparer;`.

> Until this exists, **a transformer is a second-class citizen beside an interface**: it can give
> equipment and it cannot be demanded.

This is what forces the parallel interface in almost every case. `satisfies` closed half of it — the
run-time, polymorphic half. The compile-time half is still open, and it is the half generic code
lives in. **No new keyword: the word is already `applies`.**

### 2. Structural procedures — one body over the applying type's FIELDS

A transformer can supply a fixed body or a socket. What it cannot supply is a body **derived from the
shape** of the type that applies it: clone every field, compare every field, serialise every field.

That is exactly what `record` already does for `equals`/`hashCode`/`clone` — **hard-coded in the
compiler instead of expressible in the language**. So `TSerializer`, `TEquator`, `TCloner` are not
merely unwritten; they are unwritable, and every structural transformer is written per type or not at
all.

This is the capability that changes what the feature *is*: from a mixin facility into a
metaprogramming one. It needs to iterate `itself`'s fields at `comptime`, which is the only piece
missing — `comptime` itself already exists.

The note's finding that "derivation needed no implementation, it is a property of the question"
remains true about **when** to derive. It says nothing about the machinery to actually do it, and
there is none.

### 3. Operators from a transformer

One `compare` socket yielding `<`, `>`, `<=`, `>=` is the canonical case — it is Rust's `PartialOrd`.
Operators are already `MethodDecl`s named `operator+`, **so this may already work and simply be
untested**; verify before designing. If it works it is the flagship example this note lacks.

### 4. The LAW of the relation

This note rejected the bidirectional-codec transformer on the grounds that *"the only thing it adds
over a class with two static methods is the round-trip check, and that is a contract, not a new kind
of declaration."* The argument was sound **and has expired**: the declaration now exists, so the
contract has somewhere to live.

```polaron
public mutual transformer TConverter {
    procedure into<each Other>() returns Other;
    invariant itself.into<Other>().into<itself>() == itself;   // the law of the RELATION
}
```

No new keyword — `invariant` already means "a property that must hold", and this is the first time it
has had a subject that is a relation rather than an object. It would be checked as a generated
property test, not at run time. A round-trip law is the only thing separating a conversion that is
right from a conversion that compiles.

### 5. Conditional procedures — the one new word

```polaron
procedure sorted() returns itself when Other applies TComparer;
```

Rust's `where`. Today `applies` is all-or-nothing: a transformer cannot give more to a type that has
more. Real value, smaller than the four above, and **the only item here that needs a new keyword**.

### 6. An initializer on an applied field

A transformer that brings a field forces every applier's constructor to assign something its class
never declared. An `=` on the field solves it with no weaving — and the argument against weaving the
destructor (an implicit order, invisible on the class line) **does not apply to an initial value**,
which has no order at all.

### Keywords: reuse, don't add

| capability | word | new? |
|---|---|---|
| generic constraint | `applies` | no |
| compile-time predicate | `demand ... applies ...` | no |
| law of the relation | `invariant` | no |
| structural body | `comptime` over `itself`'s fields | no (needs a way to name the fields) |
| conditional procedure | `when` | **yes, and it is the only one** |

**Deliberately not added**, each for a reason already in this note: `total`/`partial` (partiality is
deduced; annotating it would undo the finding), `abstract transformer` (already part-abstract by
construction), `sealed transformer ... permits` (`explicit` buys the readability, `private` buys the
access), and a word for the N→1 shape — *everything becomes `Json`* is an ordinary socket and needs
nothing.

### An asymmetry worth fixing before there is code to break

`mutual` and `collective` sit **on the transformer**, but the author's own description puts the
relation on the procedure: *"I have a procedure, applied to several classes."* Today a transformer
with two families imposes the same relation on both. `collective procedure into<each Other>()` would
be more precise and would allow one collective family beside one ordinary one. Not urgent — and
exactly the kind of change that gets expensive once programs exist.

## Ideas that were rejected along the way

Kept because the reasons are the useful part.

**A transformer as a bidirectional layout ↔ struct codec.** Nearly survives, but the only thing it adds
over a class with two static methods is the round-trip check, and that is a contract, not a new kind of
declaration.

**A transformer as a compiler pass written by the user.** That is a macro system. It is also not needed as a
keyword — a compiler plugin can do it — and it is how a language stops being readable.

**A transformer as a one-way pipeline stage.** Does not earn a namespace-level declaration.

**A transformer as a law about change** (legal state transitions; a policy for crossing a region boundary).
Both survived the "an interface cannot express this" test, and both died on a better one: **they are verbs.**
Polaron does not have free-floating verbs and is not going to.

**Weaving into the destructor.** See above.

**Forbidding cycles between transformers, and forbidding `A applies B`.** Both were over-caution. The design
is immune to linearization because `call` names its target, and the closure of a cyclic graph is finite.

## What is built — 2026-08-11

**`transformer`, `procedure` and `applies` are real**, and a transformer runs: a sample where `Dog`
gets `describe()` from the transformer and answers its socket with `label()`, while `Cat` replaces
`describe()` outright, prints `<dog> [cat]` as a compiled, linked, executed program. Suite 688/688,
pico 132/132.

**It is not a new node.** A transformer parses into a `ClassDecl` with `isTransformer`, the way
`operator+` parses into a `MethodDecl` — its members are ordinary members and every pass that walks a
class body already knows how to walk them. What is different about a transformer is not its inside;
it is that it is never instantiated and never a type, and that is expressed by keeping it in
`Namespace::transformers` rather than `classes`. Nothing downstream had to learn that some classes
are not classes. `layout` gets the same treatment for the same reason.

**One copier, two features.** `expandTransformers` runs before `qualifyNamespaces` and copies each
applied transformer's members into the type, using the SAME deep-clone-with-substitution that
monomorphization uses to expand a generic — `itself` bound to the applying type's name. That is not
an economy, it is the cost claim made good: a transformer is resolved entirely at compile time, so
what runs is exactly the code you would have written by hand, with no vtable, no allocation and no
indirection.

**`itself` has two jobs and they are genuinely two.** `itself.head` is an object; `returns itself` is
a type. The expression case is resolved at the PARSE site (inside a transformer, `itself` is written
as `this`) and only the type case reaches the substitution map. Doing both through the map turned
`itself.label()` into the static call `Dog.label()` — the first version did exactly that and the
compiler said `method 'label' is not static`.

**`call` is a name, not a mechanism.** `call T.p(args)` is desugared at the parse site to
`this.T$p(args)`, and the expansion pass copies every bodied procedure a SECOND time under that
name — unconditionally, so `call` means one thing whether or not the type overrode it. No AST node,
no codegen, no dispatch. `[<cat>]` is the test: the brackets are Cat's replacement, the angle
brackets the original it asked for anyway, and without `call` that original is unreachable because
`this.describe()` from inside `describe()` is the override calling itself.

`call` is a HARD keyword, decided by the author after being shown the cost: `decomp/src/lift.pol`
declares `mutable String call` and uses it dozens of times, so that file needs a rename. Recorded
here so the breakage is a known debt rather than a discovery.

**Applied fields already carry their obligations, and this was measured rather than built.** A
`region` field brought by a transformer is a real field, so the definite-release check written for
ordinary fields already refuses a destructor that forgets it — on a field the class never declared.
The one thing that needed fixing was WHERE it pointed: every copied member now takes the location of
the `applies` clause, so a diagnostic about it lands in the reader's own file instead of inside
somebody else's transformer.

Built and tested: the declaration with `mutual`/`explicit` as soft keywords; `applies` on classes and
records; bodied procedures (free, replaceable) and bodiless ones (sockets, with the error landing on
the `applies` line); provenance checked in both directions; the `applies` closure with transport,
deduped so a diamond never forms; `explicit` refusing to be carried; field collisions; the `layout`
conflict; `call` with its three rules — applied here, reachable, not a socket; and the naming
convention as a warning that generates the name.

**A procedure's generics come in TWO forms, and they are different features.** This took a wrong turn
and a correction worth recording. The first implementation read every `procedure p<X>` as a family
indexed by the target type; the author corrected it — `into<Other>` in this note was an example of a
generic procedure, not a mechanism — so it was reverted to ordinary generics. **That reverted too
much**, and the author saw it: with one body over every T, `new Fahrenheit(...)` cannot be written,
so conversion (this note's flagship) became inexpressible, and `mutual`, totality and derivation all
lost the declaration they read. Four sections of this note, gone.

Both forms now exist, told apart by a marker on the SOCKET:

```polaron
procedure tag<T>(T value) returns String { }   // ordinary generics: one body for every T
procedure into<each Other>() returns Other;    // per-target family: one body per target
```

**`each` is on the socket and not on the implementation**, and specifically not inferred from
"is the name inside `<>` already a type?". That rule is decidable and poisonous: declaring a class
named `T` would silently change what `method foo<T>()` means in another file. Whoever designs the
relation decides whether it is per-target; whoever uses it writes nothing extra —
`procedure into<Fahrenheit>()` on the applying type, bound to `into$Fahrenheit`, which is exactly
what the generic call `c.into<Fahrenheit>()` is rewritten to.

The round trip runs: Celsius(100) → Fahrenheit(212) → Celsius(100).

**`mutual` is checked**, and only the per-target family makes it checkable: `into$Celsius` is a
member you can READ on Kelvin. With one generic body there would be nothing but call sites to
inspect, which is a different and much stronger promise. All three failure modes report: the far type
does not apply the transformer, it applies it but does not answer, and it is a type you do not own
(`Errno ⟷ int` cannot be mutual, said up front rather than discovered as half a relation).

**Totality is checked, and partiality is deduced.** A per-target procedure converts FROM the type it
is written on; a class is closed over its fields, so the conversion must read them. The dual is what
makes it honest rather than pedantic: a STATIC per-target procedure converts *to* this type, its
source is the parameter, that source is open, and it is fallible by construction — so it is exempt.
`Errno → int` is total; `int → Errno` is not; neither needed a word. **That dual was found by the
check firing on a correct program** — the first version had no `isStatic` exemption and rejected a
`static procedure parse<Port>` for not reading Port's fields, which it has no business reading.

**Derivation needed no implementation, and that is the finding.** It is a property of the QUESTION,
not a mechanism: derivable means the answer is already entirely inside the input. `clone()` on a
record is derivable because the answer is the structure; `into()` from `Errno` to `int` is not,
because it is a table. Where the answer is new information the transformer's contribution is not a
body but an OBLIGATION — which is exactly what a socket already is. The table in this note is a guide
for whoever writes a transformer, telling them when to supply a body and when to supply a socket, and
both already exist.

**The error type is built, and its shape was decided here.** `error Failed;` becomes an ordinary
class in the transformer's namespace, under the name written, carrying a `String reason`. Referenced
as `Failed`, not `TParser.Failed`: a nested spelling would need a new resolution rule for `Type.Type`
in every position a type can appear — `throws`, `catch`, `new`, a field, a parameter — to buy a
qualification the namespace already provides. The cost is that the name must be free in its
namespace, and that is checked rather than discovered as a silently shared class. Synthesized ONCE,
at the transformer, not per applying type: two types that fail the same conversion must raise the
same thing or a caller cannot write one `catch`.

## Everything that was open — closed 2026-08-14

Suite **765/765**, pico **132/132**. Each of these was either a promise this note made that the
compiler did not keep, or a question it left for later.

**`freestanding transformer` did not parse at all.** The declaration scanned past `mutual` and
`explicit` and nothing else, so this note's own `RegionOwner` example was unwritable. It parses now, and
the gate is the REAL one: a body copied out of such a transformer is analyzed with the bare-metal
subset turned on, even in a hosted program, so everything that gate already refuses — interpolation,
exceptions, `await`, `unimport`, `Test`, `Console` — applies unchanged, and anything added to it later
applies too. A second hand-written list of what bare metal cannot have would have drifted. The
diagnostic says why a hosted program is being held to it, naming the transformer.

**`final procedure` sealed nothing.** It parsed, it was stored, and the expansion skipped the member
whenever the type declared the same name without ever consulting the flag — so a sealed body was
replaced in silence. Refused at the `applies` line, and it has to be refused there: after expansion
there are not two members to compare, only the type's own, and nothing downstream can tell it ever
stood in for something.

**The `enum` row of the totality table** is checked — and the reason it mattered is narrower than
"`match` covers it". `match` exhaustiveness covers the natural spelling; an `if`/`else` chain over
constants was checked by nothing at all, and the constant it forgot fell through to whatever the last
line returned. It is measured the same way the field rule is, by recording which of the source's own
constants the body named, at the point the analyzer already resolves `E.CONSTANT`.

**An enum could not apply a transformer at all**, which is why that row had never bitten: this note's
flagship conversion is `Errno → int`, and `Errno` is an enum. The clause is accepted there now. Its
constants stay ordinals; what it gains is members, which an ordinal enum has always been able to hold. A
transformer that brings a FIELD is refused on one — a constant is a value, not an object — and so is a
`satisfies` clause, because an enum implements catalogs rather than interfaces.

**The `union` row was not an omission, and writing it down was the fix.** A union looks like it should
take the record rule and must not: its fields share one storage and nothing tags which is live, so a
conversion reading every field would be reading bytes that mean something else. The rule would have
demanded a bug — and until now it did, because the field rule ran over unions. A union's source is
**open**, like an `int`.

**The subject rule was stated here and checked by nothing.** `static procedure max(int a, int b) returns
int` compiled. It is refused now, in the terms this note already used: an action belongs to a subject,
and a static procedure that mentions no `itself` is `static_assert` in a new suit.

**A static procedure with no source is legal, and the line is more than convention.** `static procedure
empty() returns itself` passes the subject rule and gives derived construction. A static constructor
belongs to one type and is written on it; this is written once and every applying type has it. That is
the difference between a member and a mould, which is the difference the whole declaration is for.

**The error type's shape** was decided when it was built (an ordinary class in the transformer's
namespace, referenced unqualified, synthesized once). What was added since: it is **not** synthesized
again for an imported bundle, where it already crossed the header as an ordinary class.

**A transformer could not cross a bundle boundary**, and nothing said so — `polh.cpp` wrote classes and
enums, and the word `transformer` appeared nowhere in `src/bundle` at all. So the standard library could
not publish a `TComparer`, and neither could anyone else. It crosses now as **its own source**, and that
is the point rather than a shortcut: a header carries signatures because a caller of a compiled method
needs nothing more, but a transformer is expanded and what the applying type receives is the BODY. A
header with only its shape would ship half the feature — sockets still demanded, every free
implementation silently gone. It has no runtime existence at all, so its text is its interface, exactly
as a header-only template's is. Captured at parse time rather than printed back from the AST, because
there is no AST-to-source printer here and a second one written for this would drift from what the
parser accepts.

The name is **importable** though it is never a type. `applies` resolves by simple name in a pass that
runs long before imports are looked at, so it would have worked with no import at all — which is exactly
why it had to be registered: a declaration that quietly opted out of "a name from another bundle is
written down where it enters" would be the only one in the language that did.

**Nothing linked a transformer to the interface it implements**, so the common case was written twice on
every applying type with nothing saying the second half answered the first. `satisfies` is that link.
The interface is pushed onto the applying type's own `implements` list, so every existing check runs
unchanged — the analyzer verifies it, the vtable is built the usual way, `X is I` answers yes.

Two details it turned up. A copied procedure that answers an interface **is** an override and has to
say so, and nobody can write the word on a member the compiler put there, so the compiler marks it —
identified by position, because `isProcedure` is deliberately not carried by the cloner. And a
procedure the TYPE writes to replace one is marked too: `override` exists so that answering something
inherited is visible, and `procedure` already says that, checked in both directions. A `method` the
type wrote itself still owes the word.

**Transformers were invisible in generated documentation** — `htmldoc` walked `ns.classes` only, so a
program's equipment was documented as though it did not exist. They appear now with their relation
words, their sockets marked as sockets, and the `applies` clause on the types that use them. The
documentation pass runs the expansion first, so what is documented is what the types really have.

**Found on the way, unrelated to any of it:** a `call T.p()` written in a **record** body was never
drained from the parser's pending list, so it was attributed to whichever declaration was parsed next —
the three rules `call` carries were checked against the wrong type's `applies` clause, in both
directions. A record takes `applies`, so it can hold a `call`, so it has to hand its sites over like
everyone else.
