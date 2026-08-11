# Transformers

*Design note, 2026-08-11. A new namespace-level declaration, `transformer`, and a new kind of member,
`procedure`. This note is the decision record, written so that the reasons survive as well as the
rules. **The core is now built — see "What is built" at the end for exactly how much.***

## The hole it fills

Look at what LDP3 can declare today: `class`, `record`, `interface`, `catalog`, `enum`, `union`,
`layout`. **Every one of them has a single type as its subject.** They say what a thing is, what values
it has, what shape it takes in memory, what it must be able to do. Not one of them says what a type
**gains**.

Other languages fill that gap with a lambda — a body of behaviour you can name, hold and pass around
without a class. LDP3 refuses first-class functions, deliberately and permanently: **behaviour lives in
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

```ldp3
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

```ldp3
public class Celsius extends Temperature implements IHeat applies Convertible { }
```

The order on the class line is deliberate: it runs from **identity** to **obligation** to **equipment**.
`extends` is one, is-a, the tightest coupling. `implements` is many, and is a promise made to the
outside world. `applies` is many, purely additive, and nobody outside needs to know about it.

> **`implements` is a promise. `applies` is equipment.** That is why they are separate clauses rather
> than one list.

### Implementations are written as `procedure`

A type that supplies its own body for an applied procedure writes it with `procedure`, not `method`:

```ldp3
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

```ldp3
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

### Visibility: application and reach are different operations

> **Application is about existing. Reach is about calling.** Visibility in the transformer governs the
> second, not the first.

A `private procedure` is still applied — it lands in the type as a private member and the type's own
methods use it. What `private` denies is `call`, which is a different operation (see below).

### Static procedures

A static procedure exists because one end of a relation is often a type you do not own. You cannot write
`int applies Convertible`, so the way back from `int` must live on the type that does apply it, and there
is no instance to hang it on — you are holding a raw `int`:

```ldp3
Errno e = Errno.from(-14);
```

The subject is `Errno`. The verb always has a noun in front of it.

### `call`

```ldp3
call RegionOwner.releaseStore();
int a = call SomeTransformer.someProcedure();
```

> `call` exists because **there is no receiver to write to the left of the dot**.

Three rules follow:

1. It is legal only inside a declaration that applies the transformer. Outside, it would be an action
   with no subject.
2. It reaches the **transformer's** body, not the applying type's override. If you wanted the type's, you
   would write `itself.p()`. `call` means *"my type replaced this, and I want the original anyway."*
3. Inside the transformer, no `call` is needed — you are already there, so `dosomething()` resolves
   normally. This is not an exception to the rule; it is the rule (there is a receiver).

`call` reaches only what visibility permits, which is how a transformer keeps procedures the applying
type may not invoke.

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

```ldp3
public mutual transformer Convertible { }
```

> If `X` applies a `mutual` transformer and implements `into<Y>`, then `Y` must apply the same
> transformer and implement `into<X>`. The error lands on `X`, naming the `Y` that did not answer.

`mutual` also says when it cannot be used: `Errno ⟷ int` cannot be mutual, because `int` is not yours and
applies nothing. The compiler says so up front instead of letting you find out later that you have half a
relation. The way back still exists — as the partial static procedure above.

## Transformers applying transformers

```ldp3
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

```ldp3
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

```ldp3
public explicit freestanding transformer RegionOwner {
    protected mutable region store;

    protected procedure releaseStore() returns void { release region itself.store; }
}
```

```ldp3
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
LDP3 does not have free-floating verbs and is not going to.

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

`call` is a HARD keyword, decided by the author after being shown the cost: `decomp/src/lift.ldp3`
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

```ldp3
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

## Open

- **The `enum` and `union` rows of the totality table** — cover every constant, every alternative —
  are not checked. `match` exhaustiveness already covers the natural way to write those, which is
  why they were the cheaper half to leave, but it is not the same guarantee: an `if`/`else` chain
  over constants is not checked by anything.
- **The error type.** A transformer declares its own (`error Failed`), so a failure names the conversion
  that failed. The shape and how it is referenced (`Convertible.Failed`?) are undecided.
- **A static procedure with no source.** `static procedure empty() returns itself` mentions `itself`, so it
  passes the subject rule, and it gives you derived construction — valuable in a kernel. Whether the line
  between it and a static constructor is more than convention is undecided.
