# `entity` — specification

> **Status.** Designed, not implemented. Every section marked **DECIDED** is settled; §15 lists what
> is deliberately still open, including one debt taken on purpose.

---

# Part I — Why

## The objection this answers

From the anti-procedural tests, **AP-06**:

> *Objects force array-of-structures. A loop over one field of ten thousand objects touches ten
> thousand cache lines where a column touches six hundred. Systems code needs columns, so at this
> level you must abandon the type.*

It is the objection that **stands**, and it stands for a reason worth stating exactly. Polaron can
already express structure-of-arrays and run level with C — but only by dissolving the type into
parallel arrays. The measurement was written twice and failed twice:

- eight parallel `float[]` columns: matches C, and there is no `Particle` anywhere in the program;
- eight `ComponentStore<int>`: matches C, and there is *still* no `Particle` — the containers had
  names and types, the **element** did not.

The second attempt is the instructive one. It looked object-oriented and was not, and the repository
had to grow a rule for it:

> *The question is always whether **the thing the program is about** still has a type, not whether the
> machinery around it does.*

No library can fix this, because the transposition has to happen *below* the type. Something the
compiler understands has to hold the type still while the storage comes apart underneath it. That is
what `entity` is.

## What it is not

It is not an ECS. An ECS is the shape a program reaches for when the language cannot express this —
entities become integers, components become side tables, and the type is reconstructed by
convention. `entity` takes the word ECS uses for the thing that disappears and makes it the word that
guarantees it does not.

---

# Part II — The specification

## 1. What an entity is — **DECIDED**

> **An `entity` is a value type whose ARRAYS are transposed.**

That is the whole of the new semantics. Everything else follows from value semantics the language
already has: assignment copies, there is no identity, small values pass in registers (AP-10 measured
`%class.Point %1` in the emitted IR — a value, not a pointer).

It joins `struct`, `record` and `union` in the family that **names a nature**. It does not name an
arrangement — the arrangement is a consequence, and the family has never named arrangements
(`struct` does not say how it is packed; `layout` does).

## 2. Declaration — **DECIDED**

```polaron
public entity Particle {
    public mutable float x;
    public mutable float y;
    public mutable float vx;
    public mutable float vy;

    public constructor Particle(float x, float y) {
        this.x = x;
        this.y = y;
        vx = 0.0f;
        vy = 0.0f;
    }

    public method speed() returns float { return vx * vx + vy * vy; }

    public pass advance(float dt) reads (vx, vy) writes (x, y) {
        x = x + vx * dt;
        y = y + vy * dt;
    }
}
```

Fields, visibility, constructor, methods, `pass` members. The type is declared once and never leaves
the program.

## 3. Storage — **DECIDED**

```polaron
mutable Particle[] swarm = new Particle[1000000]();
```

allocates **one block**, holding four columns end to end, each aligned:

```
[ x[0..n) ][ pad ][ y[0..n) ][ pad ][ vx[0..n) ][ pad ][ vy[0..n) ]
```

Four consequences, each of which is a property the hand-written form does not have:

| | why it matters |
|---|---|
| **one allocation, not four** | hand-rolled SoA does four `malloc` and cannot make them neighbours. The entity form can be *faster* than the procedural form, not merely equal |
| **one length, not four** | the compiler knows the columns are the same length **by construction**. Four parallel arrays cannot say this — it is the underlying complaint behind advice `0B40` |
| **no padding, ever** | each column is homogeneous, so there are no alignment holes between fields of different types. **AP-08's defect is inexpressible in an entity** |
| **growth is one reallocation** | of the block, with the columns re-based |

`delete swarm;` frees the one block.

Placement is orthogonal and unchanged: `on stack`, `on heap`, `in region r` all apply to the block.

## 4. The reference — what `swarm[i]` is — **DECIDED in shape, OPEN in lifetime**

`swarm[i]` yields a `Particle&` whose representation is **(block, index)** — two words, like a slice.

```polaron
Particle p = swarm[i];      // materialises: copies 4 floats out of 4 columns into a local
swarm[i].x = 0.0f;          // writes the column directly; nothing is materialised
swarm[i].speed();           // method call on a scattered receiver
```

`T&` keeps its meaning — *a reference to a T*. Whether it is one pointer or a base and an index is
**representation, not meaning**, so this does not give an existing word a second sense.

A method's body is identical whichever representation the receiver has; only the addressing changes.
Since an entity is never `dynamic` (§10), there is no dispatch, so the body inlines — which is what
lets the loop vectorise.

**Decided (§15.3):** in a dense entity a `Particle&` **does not escape** — local, `foreach` binding
and parameter, never a field, a return or a capture — which is the rule §8 already gives for storing
an index. In a `stable` entity all of it is legal, because the address does not change. One rule for
both, answered by escape analysis (§11.5, built in Wave 3) rather than by a borrow checker.

## 5. `pass` — the member kind — **DECIDED**

A `pass` is written for one row and runs over the whole population.

```polaron
public pass advance(float dt) reads (vx, vy) writes (x, y) {
    x = x + vx * dt;
}
```

```polaron
swarm.advance(dt);      // runs it over every row
```

There is precedent for adding a member kind: **`interrupt` is one** — AP-17 measured it lowering to
`x86_intrcc` with the frame `byval`, a 22-byte handler ending in `iretq`.

Three things a `pass` buys that a `method` does not:

1. **Vectorisation becomes a contract rather than a hope.** A `pass` the compiler could not vectorise
   is a diagnostic with a reason (§14).
2. **The population gets members without free functions.** Without it, "advance every particle"
   becomes `static method advance(Particle[] ps)` — a free function in a hat, which this project has
   written by accident twice and recorded as a lesson.
3. **It is the unit of parallelism** (§6).

## 6. `reads` / `writes` — **DECIDED, soft keywords**

Access-set clauses, in the same grammatical slot as `returns`, `throws`, `requires`, `ensures`.

```polaron
public pass advance(float dt) reads (vx, vy) writes (x, y) { ... }
public pass repel()           reads (x, y)  writes (vx, vy) { ... }
```

**They are soft (contextual) keywords.** A program is entitled to a `method reads()`. The position
makes it safe: after the parameter list's `)`, the only legal continuations today are `returns`,
`throws`, `requires`, `ensures` or `{` — an identifier can never appear there, so there is nothing to
be ambiguous with.

> This is the `expecting` case, not the `step` case. `expecting` became soft successfully because it
> follows a name. `step` failed as a soft keyword because it follows a *numeric literal*, where the
> unit-suffix grammar (`64 kilobytes`) can claim it. Nothing can claim this position.

### What the sets are for

**Two passes whose write sets are disjoint can run concurrently, provably.** The proof is over
columns, not over pointer aliasing — which is why it succeeds where the object case cannot. AP-09 and
AP-33 both closed with the same residue: the language refuses to hand *any* object to a thread, for
good reasons, so lock-free per-thread work cannot live on a type. It can live on an entity.

### Per-row independence is syntactic

A `pass` body that names only its own fields is **independent between rows by inspection** — no
analysis required. It stops being so the moment it names another row (`swarm[j]`) or shared state (a
`static` field). The compiler can therefore always tell, and can always say why not.

### `pure` is deliberately absent

The PIR hand-off table (`docs/design/polaron-ir.md` §12) carries a row for `pure` →
`readnone, speculatable, willreturn`. **There is no such keyword and there should not be.**

`pure` is a claim about *a function* — referential transparency, a word from a paradigm whose unit is
the function. Polaron has no functions; it has members of types. `reads`/`writes` states the same
fact in the language's own universe: not *"this is a mathematical function"* but *"this is what this
member touches"*. Purity is then the degenerate case, `reads () writes ()`, and two spellings for one
property is what the `final` discussion established the language does not do.

This is the same move `transformer` made against effect systems: take the information the back end
needs, say it in object terms, and do not import the neighbouring paradigm's model along with its
vocabulary.

**Action:** the §12 row is to be corrected or removed when the implementation pass reaches it.

## 7. `sparse` — **DECIDED**

A field whose column is stored **by presence, not per row**.

```polaron
public entity Particle {
    public mutable float x;
    public mutable float y;
    public sparse mutable Trail trail;    // present on a few thousand of a million
}
```

Without it there are two ways out and both are bad: a dense column of a million slots for the three
thousand that exist, or a side table beside the entity — **and a side table is the type dissolving
again**, which is the exact failure AP-06 records.

`sparse` is **not** `nullable`, and the axes are genuinely different:

| | says | costs |
|---|---|---|
| `nullable` | the **value** may be absent | a slot per row regardless |
| `sparse` | the **storage** is not dense | per presence |

They compose: a `sparse nullable` field is legal and means both.

## 8. `stable` — **DECIDED (and it is a universal prefix)**

`stable` was found here and turned out to be larger than the case that produced it. Its meaning:

> **`stable` — the address of this does not change.**

| context | meaning |
|---|---|
| `stable entity` | rows never move: an index is a permanent reference |
| `stable class` | the allocator or region may not relocate the instance — a promise about the *address*, distinct from `movable`, which is about *ownership* |
| `stable region` | does not compact |
| `stable` field | a pointer to the field stays valid |
| `stable method` | the code's address does not change — a method pointer survives a `reimport` |
| `stable thread` | does not migrate between cores |
| `stable` local | not promoted, not relocated |

One meaning everywhere, which is what qualifies it for the universal-prefix family. With it the
family is nine: `cascade`, `eternal`, `lazy`, `comptime`, `volatile`, `final`, `delegate`, `dynamic`,
`stable`.

What this makes sayable, in one word with one meaning, that C spells with half a dozen unrelated
mechanisms: a DMA buffer that must not move, a page table, an interrupt vector, core affinity.

### On an entity, it is the whole liveness trade

Deletion has two coherent implementations and they are incompatible. `stable` is the word that
chooses between them, once, at the type, where a reader can see it:

|  | iteration | rows | an index is |
|---|---|---|---|
| **default (dense)** | a perfect loop, no branch, fully vectorisable — the last row fills the hole | **move** | ephemeral |
| **`stable`** | must skip holes: a test per row, or a mask per 64 | **never move** | permanent |

Neither is better; a particle system wants the first, a process table or a page frame database wants
the second. Every serious ECS picks one and buries the choice in a library where nobody sees it.

Three things this pays for:

1. **`foreach` has no hidden branch.** Without `stable` there are no holes, so there is no test; with
   `stable` there is a test and it is **declared on the type**. AP-12 and AP-26 are satisfied: what
   runs is written down.
2. **It settles the dangling-index question by construction.** In a dense entity, storing an index is
   a **compile error with a reason** — rows move, that is not a reference. In a `stable` entity it is
   legitimate, and a generation counter is an ordinary column written by whoever needs one.
3. **The default is the fast case**, and the word is the price of wanting permanent references, paid
   where that want is declared.

> **A correction on the record.** During design this was argued as a memory-safety obligation — a
> stale index called "use-after-free wearing an integer". **It is not.** Out of bounds is caught by
> the bounds check; in bounds it reads a live, valid, correctly-aligned row that happens to be the
> wrong one. That is a correctness bug, not undefined behaviour, and the no-UB principle does not
> compel the language to own generations.

### `stable` and `movable`

**Decided (§15.9): not a contradiction, and it is the useful combination.** The check was made rather
than assumed, and the two words turn out to be about different subjects — which the table above
already says: `movable` is about transferring **ownership**, `stable` about the **address**, and
moving ownership of a heap object need not move it.

`stable movable entity` means the rows never move **and** the block is moved rather than copied when
it changes hands: a page-frame database handed from the boot allocator to the kernel, whose entries
are referenced by permanent index throughout. Refusing the pair would refuse that, by reading two
words as one.

## 9. `layout` on an entity — **DECIDED that it applies; the verbs are OPEN**

An earlier draft of this design called `layout` and `entity` contradictory, on the grounds that
`layout` arranges fields *within an instance* and an entity has no instances. That was looking at the
answer instead of the question. `layout` asks **"how do this type's fields sit in memory?"**, and for
an entity that question has an answer — *which columns are adjacent, and in blocks of what*.

That answer space is **AoSoA**, the state of the art in HPC, which today is hand-rolled everywhere.

The verbs an entity needs beyond `fitWithin` and `refuse`:

| verb | meaning on an entity | meaning on a struct |
|---|---|---|
| `alignTo(64 bytes)` | each column starts aligned | the instance is aligned |
| `apart(a, b)` | never in the same block | never in the same cache line |
| `together(a, b)` | the same block — this is the AoSoA knob | adjacent |

`alignTo` and `apart` are wanted independently: AP-09 measured that C constructs false sharing with
`_Alignas(64)` and verifies it with `_Static_assert` on `offsetof`, and that Polaron can state neither.

**Decided (§15.10, and it affects AP-09 as much as it affects entities).** The answer is that the
field-naming verbs do not live in the shared contract at all: **the layout declares a resolver and
the target implements it**, naming its own fields because they are its own (`layout.md` §7). A
reusable layout says what must be true (`fitWithin`, `refuse`) and what it permits (`reorder`,
`padding`); the type says how. `layout.md` §13.5 then gives every verb its entity meaning, `together`
included. The problem, as it was originally posed:

`layout` is a **named, reusable declaration** that types `implements` —

```polaron
public layout WireRecord {
    onArrange {
        itself.fitWithin(32 bytes);
        itself.refuse("a wire record is 32 bytes; both ends index it");
    }
}
public struct Packet implements WireRecord { ... }
```

— so a layout does not know the implementing type's field names. `fitWithin(32 bytes)` names no
fields; `together(x, y)` names two. **Resolved by the third role**: the verbs belong to the
*resolver*, which the target writes, and the three earlier proposals — roles bound on the clause, an
inline block in the type, a modifier on the field — are all withdrawn.

## 10. Restrictions, and where each comes from — **DECIDED**

Every one of these falls out of the design; none is arbitrary.

| restriction | why |
|---|---|
| **an entity may not be `dynamic`** | the header would become a column of pointers. The §19.9 anti-contradiction rule already catches it |
| **fields must be values** — primitives, `newtype`, `struct`, other entities (flattened into columns) | a column of pointers is pointer chasing, which is what this exists to avoid |
| **no destructor** | follows from the above: it owns nothing, so there is nothing to release |
| **no interfaces** | holding a value by an interface is erasure, and erasure requires `dynamic`. The static counterpart, `satisfies` on a `transformer`, does apply |
| **a `layout` may be implemented** | `implements` carries both interfaces and layouts; only the interface use is refused |
| **no identity** | it is a value. Where a stable handle is wanted, the index carries a type: `newtype ParticleId = int;` — which is precisely what AP-07 concluded, *"`newtype` keeps the type the index layout is supposed to cost"* |

## 11. What is **not** in the language — **DECIDED**

Liveness bookkeeping, free lists, generation counters, compaction, and queries are **columns and
code**. They are not language features and there is no population construct.

A population with capacity, live count and generations is a `Particle[]` plus two more columns and
some loops over them. Writing that as a library is legitimate here for the exact reason it was
illegitimate in AP-06: there, `ComponentStore<int>` held an `int` and the element had dissolved; here
the element is a whole `Particle`, with fields and methods, and a library above it dissolves nothing.

This was tested deliberately, because it decides whether `entity` needs a second construct beside it.
It does not. **`entity` is `entity`** — `pass`, `reads`/`writes`, `sparse` and `stable` all belong to
it, none belongs to a population type, and the collection-flavoured keyword that the naming search
kept reaching for is not needed, because there was no construct there to name.

## 12. Properties that fall out — **DECIDED**

Consequences of the design that are worth knowing because they answer objections other than AP-06.

1. **Padding cannot occur** (§3). AP-08's subject is inexpressible.
2. **Hot and cold split themselves.** A rarely-read field lives in its own column and never enters
   anybody's cache line. Systems programmers do this by hand by splitting structs in two.
3. **Adding a field costs nothing to code that does not use it.** In AoS a new field changes the
   stride and disturbs the cache behaviour of every loop that passes through. Here it adds a column.
4. **The column is nameable and typed.**
   ```polaron
   Slice<float> xs = swarm.x;
   ```
   When a column is genuinely what you want — a SIMD routine, a solver, a file write — it is there,
   typed, without `Particle` ceasing to exist. `Slice<T>` already exists and is exactly this: a
   non-owning window. Note the difference from `ComponentStore<int>`: there the column existed and
   the type did not; here both exist and the column is a *view of* the type.
5. **It rides through generics untouched.** The transposition lives in `T[]`. Every standard-library
   container that stores a `T[]` becomes columnar when `T` is an entity, **without one line changed
   in any of them** — the opposite of an ECS library, where every container must be written for the
   case.
6. **It works bare-metal.** No header, no vtable, no allocation beyond the block. A process table, a
   descriptor array, and above all a **page frame database** — which is a structure-of-arrays problem
   in every real kernel — are all entity-shaped. This matters to `pico` directly.

## 13. What it depends on — **and this dependency is not optional**

Every field access through a scattered reference is `column[i]`. Four fields is four bounds guards
unless one dominates the rest — and the columns are the same length **by construction**, so one
should.

That is **PIR §11 pass 3, guard elimination**, which that document calls *"the pass that pays for the
project"*, with the reason spelled out: *"today the guard is an open-coded branch, so LICM will not
hoist it and the vectoriser will not touch the loop."*

Stated plainly: **if guard elimination does not land, `entity` is born slower than the hand-written
parallel arrays it exists to defeat.** It is not a side risk; it is the dependency.

Two more PIR rows it needs, both already promised in §12:

- `isUnique` → `noalias`. Columns are disjoint by construction, which is a promise C cannot make.
- `layout` offsets → `align` and real TBAA.

## 14. How the guarantee is enforced — **DECIDED**

The requirement, and it is the right one: **a transposition that silently does not happen is
undetectable.** The program is correct and slower and nothing says so. The codebase already names
this failure mode, in `src/pir/passes.h`:

> *"Each pass reports what it did. A pass that silently does nothing looks exactly like a pass that
> works, which is how an optimisation quietly stops happening."*

AP-03 is the proof that it is not hypothetical: sixteen dispatch arms were folded away by clang, the
checksum was identical and correct, and the only thing that caught it was reading the assembly.

Three routes, together:

1. **Declare and refuse, at the type.** `entity` *is* the demand — there is no fallback to
   array-of-structures. A field that cannot be a column (§10) is a **compile error**, not a silent
   downgrade. This is the `onArrange` pattern: the type states its requirement and the compiler
   refuses when it cannot meet it.
2. **Report, at the `pass`.** Whether a given loop was actually emitted columnar and vectorised is a
   property of the generated code, not of the type. A `pass` that did not vectorise says so, with the
   reason — which is where the `0Cxx` idiom-advice family finally gets a `why` naming an optimisation
   that exists.
3. **A test that compares the emitted assembly**, not the output. Nothing else catches this class of
   regression. It is the only instrument that caught AP-03.

> An earlier proposal put a modifier (`transposable`) on the entity for route 1. It is not needed: if
> every `entity` is columnar and a non-columnisable field is an error, the declaration is already the
> demand, and a second word would only restate it. `transposable` also reads wrong — in Polaron the
> `-able` family (`movable`, `partitionable`, `nullable`) means *permission*, and this needs to
> assert. If it is ever revisited, `columnar` is the better word: it failed as a *type* name because
> the family names natures, and a modifier is exactly where an arrangement adjective belongs.

## 15. Decided (Wave 4.5) — one debt kept, and it is named

Everything in §15.2 is now decided. **15.1 alone remains parked**, deliberately and with its
condition written down: it opens onto the ML work, and a construct is not designed by being wanted.

### 15.1 The transposition operator — **a debt taken on purpose**

Transposition is an **operation**, not a declaration: *give me the transpose of this, as a copy*.
`Type a = b<^>;`, over an entity array, a matrix, a tensor.

It is a good idea on its own merits, and for a reason that only became clear while testing it: **an
operator is a member.** With operator overloading, `<^>` is defined *on the type* — the matrix knows
how to transpose itself, the tensor knows, the entity array knows. It is not a builtin with
mathematics compiled into it, and it reads in a formula where a method does not:
`(a<^> * b)<^>` against `(a.transposed() * b).transposed()`.

Three things are unresolved and it is **deliberately parked**, because the third leads somewhere this
design should not go yet:

1. **The glyph fights the generics syntax.** `matrix<^>` reads as a generic instantiation in a
   language that has `Box<T>`. It lexes unambiguously — `^>` cannot follow `<` in any other
   construct — but it does not *read* unambiguously. A prefix `^b` is free of the collision (`^` is
   binary-only today) at the cost of the conventional postfix position.
2. **The AoS form of an entity has no name.** An entity array is already column-major, so its
   transpose is the interleaved form — which is genuinely useful (FFI, vertex buffers, file writes)
   and has **no type in the language**, since every entity array is columnar. `Type a = b<^>` needs a
   `Type`. Three ways out: name the materialised row type; make the result a typed raw buffer for
   interop only; or let a `columnar` modifier distinguish the two forms and have `<^>` convert
   between them.
3. **Rank above 2 needs axes.** A bare postfix operator covers rank 2 and the AoS↔SoA flip. General
   tensor transposition is `permute(0, 2, 1)` and wants a form with arguments.

**Why it is parked:** it opens onto the ML work — native `brainfloat` and `nf4`, `tensor<float, A,
B>`, and the keywords that would make backpropagation expressible, with full ML/DL in Polaron as the
goal. That is its own design and this one should not pre-empt it. Until then, §14's three routes
carry the guarantee, which is what the operator was originally reached for and is not what it does.

**And "parked" is now a state with a way out, which it was not before.** A parked item that names no
condition is an open item wearing a better word. This one's condition: **`<^>` is designed with the
ML work or not at all** — the same document that decides `tensor<float, A, B>` and native
`brainfloat` decides the transposition operator, because two of its three unresolved points (the AoS
row type, and rank above 2) are answered there or nowhere.

### 15.2 Everything else — now decided

| | question |
|---|---|
| ~~15.3~~ | **DECIDED — a row reference obeys the rule the index already obeys.** In a dense entity a `Particle&` **does not escape**: it may be a local, a `foreach` binding and a parameter, but it may not be stored in a field, returned, or captured by a closure — the same refusal, for the same reason, that §8 already gives for storing an index. In a `stable` entity all of that is legal, because `stable` already means the address does not change and the language already permits a pointer to a `stable` field. One rule for both representations, and **no borrow checker**: the question is *"does this outlive what it points into"*, which is escape analysis (§11 pass 5) and which the region binder already answers |
| ~~15.4~~ | **DECIDED — yes, and it is not a second representation, because §4 already creates one.** `Particle p = swarm[i];` *"materialises: copies 4 floats out of 4 columns into a local"* — that local **is** a lone entity. The two representations (`Particle` materialised, `Particle&` as block-and-index) are §4's decision, already taken; 15.4 only asks whether the first may be constructed directly rather than only extracted. Refusing `new Particle(1, 2) on stack` while permitting the line above would refuse one spelling of a value the language already makes, which is the worse kind of restriction: it does not remove the representation, it removes the way of getting one that does not need an array to exist first |
| ~~15.5~~ | **DECIDED — yes, flatten, recursively, to leaves.** §3's *"no padding, ever"* is the whole claim, and it holds only because every column is homogeneous. A nested `struct` kept as a struct-column re-introduces **exactly AP-08's holes**, inside the column, where nobody would think to look — the defect this construct is supposed to make inexpressible, smuggled back in by a field. So a nested `struct` or `entity` field becomes its own columns, by leaf: `Body { Vec3 pos; Vec3 vel; }` is six float columns. **Three things do not flatten and each for its own reason:** a pointer field is a leaf (it *is* one word); a dynamic array field has no fixed width, so it is one column of slices; and a `sparse` field (§7) has its own storage rule, which flattening would silently override |
| ~~15.6~~ | **DECIDED — after, and the design is nonetheless closed.** The *meaning* of `together` is settled in `layout.md` §13.5, so nothing is left undesigned; what is deferred is only building it. **Wave 4 is why.** The largest performance target in the ledger was planned around for months and turned out to be a benchmark artefact — four findings agreeing, all four downstream of one shape. AoSoA's value depends on the target's vector width and on the access pattern, and the pure-SoA case has not been measured once. Building the harder arrangement before measuring the simpler one is the same mistake with a different subject |
| ~~15.7~~ | **DECIDED — `index i`, the same word in the same position `foreach` puts it.** `lexer.cpp:165` makes `index` a keyword and `parser.cpp:4192` uses it for exactly this: *"optional index variable: `foreach (index i, T v in coll)`"*. It is a **binder**, not a value — it introduces a name for the position of the current element. A `pass` is an iteration, so it takes the same clause: `pass advance(float dt) index i reads (vx) writes (x)`. Optional, because most passes never ask. Not a parameter, because the caller does not supply it — which is why it sits outside the parameter list rather than inside it, where it would read as one |
| ~~15.8~~ | **DECIDED — the call site, spelled `in parallel`.** The item's own reasoning is right and decisive: the schedule depends on N, the caller knows N and the type does not, and the *safety* is derived from `reads`/`writes` (§6) either way. So the declaration says nothing and `swarm.advance(dt) in parallel;` asks. It reuses the `in` clause the language already has for placement (`in region r`) — same word, same position, a modifier on the expression — so `parallel` is a soft keyword in one clause and nothing else. **The reason it is not derived:** a compiler choosing to parallelise from N alone would be choosing for a caller that may already be inside a parallel region, on a machine whose other cores are busy, in a program where the pass is the cheap part. That is a scheduling decision, and scheduling decisions belong to whoever has the schedule |
| ~~15.9~~ | **DECIDED — not a contradiction, and it is the useful combination.** They are about different subjects: `stable` is about the **address** and `movable` about the **ownership** — which §8's own table already says (*"a promise about the address, distinct from `movable`, which is about ownership"*). `stable movable entity` means the rows never move **and** the block is moved rather than copied when it changes hands: a page-frame database handed from the boot allocator to the kernel, whose entries are referenced by permanent index throughout. Refusing the pair would refuse that, and would do it by reading two words as one |

**15.10 is closed.** It asked how the field-naming `layout` verbs could live in a reusable layout
contract that does not know the implementing type's field names. They do not: the layout declares a
resolver and the **target implements it**, naming its own fields because they are its own
(`docs/design/layout.md` §7). Three earlier proposals — roles bound on the clause, an inline block in
the type, a modifier on the field — are all withdrawn.

## 16. What this adds to the language

| word | kind | where |
|---|---|---|
| `entity` | hard keyword, type declaration | §1 |
| `pass` | hard keyword, member kind | §5 |
| `sparse` | hard keyword, field modifier | §7 |
| `stable` | hard keyword, **universal prefix (9th)** | §8 |
| `reads` | **soft** keyword, signature clause | §6 |
| `writes` | **soft** keyword, signature clause | §6 |

All six are free in `src/lexer/lexer.cpp` today.

Not added, and each for a stated reason: `pure` (§6 — wrong paradigm, and the degenerate case of
`reads`/`writes`), `transposable` (§14 — the declaration is already the demand), a population type
(§11 — there is no construct there), `<^>` (§15.1 — parked with the ML work).

`dynamic` also appears in this document, but it is not entity's: it belongs to the object-header
design, and is referenced here only for the contradiction in §10.
