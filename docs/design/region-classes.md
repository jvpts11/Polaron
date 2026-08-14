# Region classes

*Design record, 2026-08-13. João's proposal, discussed and decided; the synchronization question was
settled by measurement rather than argument.*

A class can declare that its instances live in one region, owned by the type rather than by an object:

```polaron
public region class A on heap;
```

Every `A` in the program is allocated from `A`'s region, and that region holds nothing else.

## Half of it already exists

`accepts`/`rejects` (spec 17.3) already take a **set of types**, and `fixedslot` already *requires*
an `.accepts({T})` — precisely because a single type turns the allocator into index arithmetic:

```polaron
fixedslot region dogs = itself.allocate(64 kilobytes).accepts({Dog});
Dog* d = new Dog(42) in region dogs;     // a Cat here is a compile error
```

So "a region that only accepts A" is not the new part. **The new part is the implicit, total binding**:
the region is declared *with* the class rather than at each use site, and it becomes true that *every*
A in the program is in it.

## Why totality is the whole point

Three things follow from it, and none of them follow from today's `fixedslot ... accepts({A})`,
because today an `A` can also be born `on heap` somewhere else:

- **`unimport` becomes O(1).** It already refuses to rip out a type that has live instances, and today
  it must go looking. "Is any A alive?" becomes "does A's region have an occupied slot?"
- **Iterating every instance of a type** becomes a linear, cache-friendly scan. That is an ECS's
  archetype storage, and `System.Ecs` is in the library already.
- **The pointer can shrink.** If every `A*` comes from one region, an `A*` is representable as a
  **32-bit slot index**. A tree node `{key, value, left, right}` with `int` keys is 8 bytes of data
  and 16 of pointers; halving the pointers nearly halves the node, which doubles the nodes per cache
  line and moves the point where the working set stops fitting. Pointer-chasing structures are
  bounded by cache misses, not arithmetic, so this is a step change rather than a percentage.

  This is also the one place the language can beat hand-written C without C being able to copy it
  cheaply: a C programmer can rewrite a structure as `uint32_t` indices into an array, but gives up
  type checking, destructors and readability to do it. Here it is the default, and `A*` still reads
  as a pointer.

**Therefore: in a region class, `new A() on heap` and `new A() in region other` are errors.** Either
the guarantee is total or none of the above is available. This constraint is the feature.

The 32-bit representation is *not* the first version — it ships with ordinary pointers. What the
totality buys is that the door stays open. Let one `A` escape to the heap and it closes permanently.

## Decisions taken

**A region class is `sealed`.** A `fixedslot` region has one slot size; a subclass with more fields
does not fit. The alternatives were a region per subclass (which destroys the totality the feature
exists for) or sizing the region to the largest subclass (which needs whole-program knowledge and
breaks separate compilation into `.polb`). Sealed is the honest answer.

**One per program**, validated the way `heap class X` already is — that keyword solves the same
problem (who supplies the program's heap, exactly once) and its machinery applies unchanged.

**Released at program exit.** A class region has no owner, and the safety model is *region binding by
encapsulation*: the binder can prove a pointer never outlives its region because the region's lifetime
is its owner's. With no owner there is nothing to bind to, so an explicit `release region A` would
dangle every `A*` in the program at once, unprovably. If an explicit release is ever wanted, it must
carry the same live-instance proof `unimport` already performs.

## Synchronization: measured, not argued

One region per type, program-wide, means every thread allocating an `A` hits the same allocator.
Today's regions need no synchronization because each is owned by an object and inherits its thread.

`performance tests/region-sync/region_sync.cpp` mirrors `__polaron_region_new`'s hot path for the
homogeneous case (pop a free slot, else bump) and measures each strategy under two loads: `grow`
(allocate, never free — a loading phase, pure cursor) and `churn` (a rolling window — steady state,
where the free list carries the traffic). 16 cores, 2M ops/thread, median of three.

```
ns per allocation (lower is better)
load   thr    nosync  subpool   mutex     spin   atomic  chunked
grow     1       4.93     4.79    11.77     6.33     9.22     5.80
grow     4       —        2.00    28.38    63.39    22.53     4.22
grow    16       —        2.01    73.68   207.64    25.14     7.34

churn    1       1.17     1.09    14.75     3.51     1.42     1.38
churn    4       —        0.49    32.54    87.04     0.83     0.39
churn   16       —        0.40   107.34   342.67     0.28     0.16
```

**Both locking designs are disqualified.** A mutex costs **9× the allocation** even uncontended
(13.9 vs 1.5 ns in churn), because the allocation is a handful of instructions and the lock is a CAS;
at 16 threads it is 107 ns. The spinlock is *worse*, not better — 343 ns — because sixteen cores
spinning on one cache line spend their time tearing it away from each other. The usual intuition
("short critical section, use a spinlock") is wrong at this size.

**Per-thread subpools scale beautifully but pay in the wrong currency**: they split the address space
per thread. "Every A is contiguous" becomes "contiguous *within its thread*", a handle needs a pool
field, and one linear scan becomes N. They cost exactly the guarantees the feature exists to buy.

**Chosen: a chunked atomic bump with thread-local free lists, and no lock anywhere.** Each thread
takes a run of 64 slots from the cursor with one `fetch_add` and hands them out locally.

- **Fastest of all in steady state**, subpools included: 0.16 ns vs 0.40 at 16 threads. The local free
  list absorbs the traffic and the shared cursor is never touched.
- **~5 ns while growing**, against the 4.93 ns unsynchronized floor: thread safety costs about
  **0.9 ns per object**, which is the `thread_local` access and nothing else.
- **Keeps a single contiguous address space**, which is what preserves the single-number slot index,
  the single linear scan, and the O(1) liveness query.

A `fetch_add` per object (the `atomic` column) plateaus at 22–25 ns — one cache line ping-ponging
between sixteen cores. Taking 64 at a time divides that by 64 and the problem disappears.

**Producer/consumer.** A thread-local free list returns a freed slot to the thread that freed it, so a
pattern where thread A allocates and thread B frees would pile slots up in B and never return them to
A. Not corruption — waste. Fix, decided with the above: when a local free list grows past two runs it
hands a batch to a **shared overflow stack**; a thread whose local list is empty steals a batch from
there before touching the cursor. One atomic per batch, not per object — the same trick that makes
the chunked cursor win.

## Shared regions: `abstract region class`

A pure region class holds one type, so it cannot express a **phase arena** — a compiler's AST storage,
a frame's scratch memory, a request's allocations — where many types share one lifetime. João's answer,
taken: an **abstract region class declares a region shared by everything beneath it.**

```polaron
public abstract region class AstNode on heap;        // declares the region
public region class Ident extends AstNode { ... }    // lives in AstNode's region
public region class Call  extends AstNode { ... }    // same region
```

A region class may inherit *only* from an abstract region class; a pure one is sealed. That is the
`sealed` rule from the other side, and it keeps the leaves closed while letting the family share.

This is better than the alternative that prompted it (regions as namespace members, rejected below),
because sharing becomes a **property of a type hierarchy** rather than a global with a nicer name. The
question "who may live here?" still has an answer, and the answer is a type.

**The checking already exists.** `checkRegionAccepts` honours subtyping:

```cpp
for (const std::string& acc : rc->accepts) {
    if (type == acc || isSubtype(type, acc)) return;
}
```

so `accepts({AstNode})` already admits every subclass. This is a wiring job, not a new mechanism.

**The flavor stops being a choice and becomes a deduction.** A pure region class has one object size →
`fixedslot`, index arithmetic. A family has mixed sizes → `pool`, which is size classes plus free
lists, and is literally what `__polaron_region_new` already does for `flavor == 1`. Nothing arbitrary
to teach: the shape of the problem picks.

**The narrow pointer survives, as a byte offset.** Mixed sizes break `index * sizeof(T)`, but a 32-bit
*byte offset* from the region's base works and caps a region at 4 GB. The gain is larger here than in
the pure case: a **polymorphic `AstNode*` stays 32 bits across the whole family**, and polymorphic
tree traversal is exactly where pointers dominate the node.

Three rules go with it:

1. **The region belongs to the root.** With `Expr extends AstNode` and `Ident extends Expr`, `AstNode`
   declares it; intermediate abstracts do not redeclare.
2. **Everything below an abstract region class must be a region class.** Let an ordinary class inherit
   and its instances are born outside the region — totality dies, and with it the narrow pointer and
   the O(1) liveness.
3. **A pure region class stays sealed.**

**And this is where explicit release earns its keep.** A phase arena is worth having because it dies at
the end of the phase; "released at program exit" would not solve the case that motivated it. So
`release region AstNode` is **allowed**, gated by the same live-instance proof `unimport` already
performs. No new safety machinery — the existing proof, reused.

**The cost, so the choice is informed:** within a family, `Ident`s and `Call`s are interleaved in one
region. "Iterate every `AstNode`" stays linear (walk the slot chain, reading each header's size);
"iterate every `Ident`" no longer is. An ECS wants pure region classes, one per component; an AST
wants the family.

The language then has three region shapes, each with a clear owner story:

| shape | owner | dies |
|---|---|---|
| region local | the method | at scope exit — the binder proves everything |
| `region` field | the object | with its owner — the binder proves everything |
| region class / family | the **type** | at program exit, or by `release` with the liveness proof |

## How it meets the rest of the type system

Probed rather than assumed, and one assumption was wrong. The emitted IR for a class holding a
`struct` field and a `record` field is:

```llvm
%class.Row    = type { i32, i32 }
%class.Point  = type { i32, i32 }
%class.Holder = type { ptr, ptr, ptr }   ; BOTH the struct and the record field are pointers
```

**A `struct` and a `record` are not embedded in their owner — they are separately allocated objects.**
So they are not value types in the C# sense, and the objection "a struct lives inside its container,
so totality is impossible" does not apply here.

| kind | region class? | why |
|---|---|---|
| `class` | **yes** | the central case |
| `record` | **yes, the ideal case** | immutable, uniform, bulk-allocated; immutability removes the aliasing questions |
| `struct` | **yes** | no vtable, no inheritance → a perfect `fixedslot` and the narrowest pointer |
| `union` | as `struct` | same shape |
| `enum` | **no** | a closed constant set created once at class-load; a region buys nothing |
| `interface` | **no** | has no instances of its own |

### Two consequences worth stating out loud

**A region class loses stack allocation for its locals.** `new T()` defaults to stack with RAII. If
every `A` must be in A's region, then a local `A` is born in the region and lives until it is deleted
or the region dies — *not* until the block exits. This is a change of semantics, not of placement, and
it is indivisible: let one `A` stay on the stack and an `A*` can point at the stack, which kills the
narrow pointer. It applies equally to classes, structs and records.

**Interfaces force two pointer widths.** An `I*` can point at a `Foo` in Foo's region and a `Bar` in
Bar's — different bases — and a 32-bit offset is only meaningful relative to one region. So:

> the narrow pointer exists when the pointer's **static type** is rooted in a region — a pure region
> class, or a family root. An `I*`, or a pointer to an ordinary abstract class, stays 64 bits.

Implementable (it is `base + offset`), but it introduces two representations and the conversions
between them. One more reason the narrow pointer is a later step, not the first one.

### Transformers and generics: the part that comes out free

A transformer is compile-time equipment and allocates nothing itself. But when the code it generates
allocates — a `TCloner` writing `new itself(...)` — it lands correctly without being told, because
`new T()` in a region class already means "in T's region".

That removes a friction named earlier in this document: today, generic code that allocates **has to be
handed** a region. With region classes, placement is a property of the **type**, not of the call site,
so transformers, generics and synthesized code are correct without knowing regions exist.

A design warning follows: **a container's nodes should not be a region class.** A `LinkedNode<T>` must
die with the list that owns it — which is what it does today, in a `pool region` field of the
`LinkedList`. Region classes are for types whose lifetime is program- or phase-scale, not for types a
container owns.

## Rejected: regions as namespace members

Considered and turned down. A namespace holds **types**; a region is a **value**. The symmetry argument
therefore points at `region class` itself, which *is* a region declared at namespace scope — named by a
type, living where types live, with an owner, a rule about who may live in it, and an O(1) liveness
answer.

The substantive objection: **the value of a region is dying as a unit.** An ownerless namespace region
can never be proven safe to release, so it never dies, so it degenerates into a bump allocator with no
free — a region that is not a region. And the binder, which proves a pointer never outlives its region
*because the region is reachable from an owner*, would answer "lives forever" for everything touching
it: not unsafe, but **silent**, which is worse.

**What to do instead: finish static region fields.** This already parses:

```polaron
public class Arena {
    public static mutable pool region shared;
}
```

but the use site fails with `error[Polaron-0105]: unknown region field 'Arena.shared'`. In
`analyzer.cpp` (~6035) the resolution has two paths and neither sees a static: the dotted path looks
the name up in `currentClass_`, and the undotted path looks only at locals. So **static region fields
are declarable and unusable.** Finishing them gives a program-wide shared arena that keeps an owner's
name on it, stays inside mandatory OOP, and costs a bounded analyzer change.

**Latent bug found there:** the dotted path *ignores the qualifier* — it takes the name after the dot
and looks it up in the current class, so `Other.arena` silently resolves to your own field of the same
name if one exists.

## Syntax

`on heap` says where the backing comes from, which maps onto the existing `itself.allocate(...)` vs
`itself.at(...)`. The second form is the one worth having for bare metal:

```polaron
public region class VgaChar at 0xB8000;
```

— a class whose instances are born, by construction, at the address the hardware dictates.

Two things the proposed spelling still needs: the **flavor** (`fixedslot` is the natural default for a
homogeneous type) and the **capacity**, which is explicit everywhere else today. `growable fixedslot`
by default avoids making the author guess a size.

## What is built, 2026-08-13

**The pure `region class` works end to end.** `public region class Node { ... }` parses, the class is
implicitly `sealed`, and `new Node(10)` allocates from a program-lifetime region owned by the type:

```llvm
@Node.region = internal global ptr null
  ...
  %Node.obj = call ptr @__polaron_region_new(ptr %rgncls.block, i64 ...)
```

- **The region is created on first use, not by a static initializer** — bare metal runs no static
  constructors, and a feature that works hosted and not freestanding is half a feature here.
- **`growable pool`**: pool because a class-homogeneous region wants a free list and O(1) reuse of a
  freed slot; growable so nobody has to guess a capacity for a store that lives as long as the program.
- **`new A() in region other` is refused**, with the reason: the guarantee that makes a region class
  worth having is that there is nowhere else.
- **A region class loses stack allocation for its locals**, exactly as this document warned. `new A()`
  with no `on heap` — which for any other class is a stack object with scope-exit destruction — now
  goes to the region. That is the price of totality, paid deliberately.

**And the family works too.** `abstract region class Node` is *not* sealed — being inherited from is
what it is for — and every class beneath it reaches the SAME block:

```polaron
public abstract region class Node { ... }      // declares the region
public region class Ident extends Node { ... } // 
public region class Call  extends Node { ... } // a different size, and the same arena
```

emits exactly one `@Node.region`, which is the phase-arena case a single-type region cannot express.
The lookup walks up the chain while the parent is still a region class, so a pure region class is its
own root and a family shares its root's.

Tests: `codegen_region_class_runs`, `codegen_region_class_family_runs`.

Reused rather than written: the region runtime (`__polaron_region_init` / `__polaron_region_new`), the
flavor codes, and the block header size all already existed for owned regions. The feature is a routing
decision plus one global per class.

## What is left to build

**All of it is built** (2026-08-14), step 6 included — **except step 3, which the narrow-pointer
rewrite silently undid; see *Audited, 2026-08-14* at the end.** Steps 1–5 are kept written out rather
than struck through because the sub-points are the specification of what each layer must enforce, and
that is still what the code is read against. What step 6 took is written up under *The narrow `A*`,
built* at the end.

1. Parser: the `region class` and `abstract region class` modifiers, the flavor, and the
   `on heap` / `at <addr>` backing.
2. Sema:
   - seal a pure region class; allow inheritance only from an abstract region class;
   - require every type below an abstract region class to be a region class;
   - reject `on heap` and `in region other` for a region class's instances;
   - reject `region` on `enum` and `interface`;
   - enforce one region per family root, the way `heap class` is enforced;
   - deduce the flavor: `fixedslot` for a pure class, `pool` for a family.
3. Runtime: the chunked-bump allocator with thread-local free lists and the shared overflow stack.
4. Codegen: route `new A()` to the region of A's family root, including from generic and
   transformer-generated code; emit the program-exit release.
5. ~~`release region <Root>`, gated by `unimport`'s live-instance proof.~~ **DONE.**

   `release region Node` frees the family's whole block chain and nulls the global, so the next `new`
   rebuilds it through the same lazy path bare metal needs. The gate is the counter `unimport` already
   uses, read for **every class in the family** — releasing on the root's count alone would free an
   arena still holding `Ident`s. Tests `codegen_region_class_release_runs` (build, delete, release,
   rebuild) and `codegen_region_class_release_live_panics` (a node still alive: refused, naming the
   family).

   **A pure region class is refused, and that is the design.** It is sealed and its arena holds
   instances of one type, so releasing it is releasing every instance — which `delete` already says,
   one object at a time. The family arena is the shape with no other spelling.

   **The counter is not free, so it is not always on.** A new set, `countedClasses`, forces it for
   exactly the families some `release region` names. Putting them in `unimportableClasses` would have
   worked and would also have emitted the whole code-address table, which anchors every function in
   the program and defeats dead-code elimination — a program that releases a phase arena should not
   pay for a feature it never used.

   Two things this cost, both worth recording. Marking a class as having a destructor **without
   declaring the function** is a *segfault*, not a link error: the delete path reads
   `functions[cn + ".~" + cn]`, and `operator[]` on a missing key inserts a null that goes straight to
   `CreateCall`. And the test harness could not express "this guard must fire" at all — every runner
   treated a non-zero exit as failure — so `run_exe_test.cmake` gained `EXPECT_EXIT`. A guard that
   cannot be tested when it trips is a guard nobody has seen work.
6. Later, and only because totality was preserved: the narrow `A*` — a slot index for a pure region
   class, a byte offset for a family — with ordinary 64-bit pointers kept for interface-typed and
   cross-region references.

**Adjacent, and worth doing first because it is small and independently useful:** ~~finish static region
fields (see *Rejected: regions as namespace members*), and fix the qualifier-ignoring bug in the dotted
region-field lookup.~~ **BOTH DONE, 2026-08-14.**

**The qualifier is read.** `new X in region <a>.<b>` took `<b>` and looked it up on the current
receiver, discarding `<a>` — in the analyser *and* in codegen, which emitted a GEP into `this` at that
field's index. `Other.arena` therefore allocated from your own arena whenever you happened to have a
field of the same name, with no diagnostic. Naming another class's *instance* field now says what is
wrong and which of the two things you probably meant. Test `sema_region_qualifier_errors`.

**Static region fields work.** `public static mutable pool region shared;` parsed and every use
answered `unknown region field`. The arena is built on **first use**, not by a static constructor, for
the same reason a region class's is: bare metal runs none. It is a `growable pool`, so a shared arena
chains another block instead of trapping. Test `codegen_region_static_field_runs`.

## The narrow `A*`, built — 2026-08-14

Step 6, and the reason totality was insisted on from the first page.

### It needed the arena to be contiguous first, and it was not

A region class's arena was a `growable pool`: 64 KiB to start, chaining another block on overflow. A
narrow `A*` is an offset from the arena's base, and offsets are only unique while there is **one**
base — two objects at the same offset in different chain links are the same 32-bit value. Chaining and
narrow pointers cannot both be true, so the door the design kept open had quietly closed in the
implementation.

Capping the arena instead is not an answer; a bare-metal-friendly "never traps, never moves" is. So the
arena now **reserves address space and commits it as it fills**. Measured on this machine, and it is
why `malloc` cannot do the job:

```
malloc(256 MiB)            ->  private commit +257 MiB, immediately
VirtualAlloc(MEM_RESERVE)  ->  private commit +0
```

1 GiB reserved (the offset is unsigned, so 4 GiB is what the representation allows), committed a MiB
at a time. `__polaron_arena_reserve/alloc/base/free` on Windows via `VirtualAlloc`, on POSIX via
`mmap(PROT_NONE, MAP_NORESERVE)` + `mprotect`. **Offset zero is never handed out**, which is what buys
null: a narrow pointer spells absence the way every other pointer does.

`release region <Root>` got simpler rather than harder — one reservation goes back in one call, with
no chain to walk.

### Narrowed in fields only

The win is entirely about how much of a structure fits in a cache line. A local or an argument lives in
a register, where 32 bits buy nothing and the widening arithmetic is pure cost. So an `A*` **in a
field** is stored as `i32` and every other `A*` stays an ordinary pointer: one representation change,
at the one place it pays, and no conversions anywhere else. Measured on `tests/samples/region_class_narrow.pol`
against the identical class declared without `region`:

```
without   %class.Node = type { ptr, i32, i32, ptr, ptr }    32 bytes
with      %class.Node = type { ptr, i32, i32, i32, i32 }    24 bytes
```

A quarter off the node — a third again as many per cache line. (The vtable pointer is why it is not a
half: the two `int`s and the two children are 24 of the 32.)

The two access points are the same ones bit fields use, and for the same reason: a field whose storage
type is not its declared type can be read and written only through its own pair. `emitNarrowLoad` is
`off == 0 ? null : base + off`; `emitNarrowStore` is `p == null ? 0 : (i32)(p - base)`. Interface- and
abstract-typed references are excluded by `narrowTargetClass`, exactly as *Two consequences worth
stating out loud* said they would have to be: an `I*` can point into a different family's arena, and an
offset is only meaningful against one base.

### Three things it cost

**The arena's global is named after the class, so the name has to be the class's.** A tree's children
are `nullable Node*`, and taking the type as written gave them an arena global called
`nullable Node.region` — a second, empty reservation that `new Node()` never allocated from. It linked,
it ran, and it died on the first walk.

**Bare metal has no address space to reserve.** `polaron build` emits a static arena for a freestanding
image instead, which is the right answer rather than a concession: a kernel wants a bound it can see,
name and raise (`POLARON_FS_CLASS_ARENA`), with every byte accounted for before the first instruction.
Both arenas keep the same two promises — one base, and no offset zero. The first default (256 KiB × 4)
put 1.06 MiB into `.bss` and is now 64 KiB × 2, because a bare-metal default that breaks a hello-world
kernel is the wrong default however defensible the number looks.

**And it found a boot test that was passing by luck.** `tests/i686/boot.s` declared
`.section .multiboot` without `"a"`, so the section was not allocatable: the linker script's
`. = 1M; .multiboot : {...}` was ignored, the section got address 0, and it landed in no load segment.
QEMU booted the image only because it scans the *file* for the magic and the section happened to sit at
offset `0x14f0`. One region class grew `.text` from `0x474` to `0x50dc`, the header slid to `0x6310`,
and the guest wrote nothing at all. A test that depends on the size of the program it is testing is not
testing what it says.

The i686 image now boots **with a region class in it**, and asserts the walk
(`ports = 0x0000000000000ad8`) alongside the arithmetic it already checked. Tests:
`codegen_region_class_narrow_layout`, `codegen_region_class_narrow_runs`, `port_i686_boots`.

## Audited, 2026-08-14 — five escapes, and one decision that never shipped

The question asked of the tree was the one this document opens with: *is it true that every A is in
A's region?* `emitNew` refuses `on heap` and `in region other`, and that is where the enforcement
stopped — because `emitNew` was the **only** caller of `classArenaAlloc`. Every other way an A comes
into existence went somewhere else, and none of them said so.

**Why they were invisible.** A misplaced object still has the right shape and the right fields, so it
reads back correctly and the program looks fine. What makes it fatal is step 6: a narrow `A*` field
stores `(i32)(p - arenaBase)`, so an A outside the arena is not a misplaced object — it is a field
holding an arbitrary 32-bit number that the next read turns back into an address. `Node b = a;
root.left = b;` was an access violation with no diagnostic before this audit.

Each of the five is now refused or routed, with a sample and a test:

| escape | was | now |
|---|---|---|
| value copy (`A b = a;`) | `alloca` for a local, `malloc` for a field | `classArenaAlloc` — `codegen_region_class_copy_runs` |
| `cascade` clone | `malloc` in `cloneHelper` | `classArenaAlloc` |
| `Type.instantiate()` | `malloc` from the type token | the token carries the arena's own `new` — `codegen_region_class_reflect_runs` |
| library-mode `__new` | `malloc` in the exported constructor | `classArenaAlloc` |
| `move x into region R` | relocated into R | refused — `codegen_region_class_move_in_errors` |

And two the refusals had missed:

- **`on stack` was accepted and quietly overridden**, because it *is* the default: `location` reads
  "stack" whether the author wrote it or wrote nothing, so codegen could not tell the two apart.
  `NewExpr` now records whether the placement was **written**, and a written one is refused whatever
  it says (`codegen_region_class_on_stack_errors`). This is the case the `on heap` refusal exists to
  prevent, and it was open for the one placement that does the most damage.
- **`extract`** relocates an object out of a region it would otherwise die with. A region class has no
  such moment, so there is nowhere to extract to — refused, and naming the class where a region goes
  now says that rather than "unknown region" (`sema_region_class_extract_errors`).

**And an instance did not live as long as this document says it does.** *Two consequences worth
stating out loud* promised that a local A "lives until it is deleted or the region dies — **not** until
the block exits". It did not: RAII registration keyed off `NewExpr::location`, which for `new A()` is
"stack", so the object was filed as a stack object and **destructed at the closing brace** while the
arena still held it and every kept `A*` still pointed at it. A use-after-destruct that reads as
harmless exactly when the destructor does nothing. Both registration sites now ask the class where its
instances live instead of reading a placement nobody wrote
(`codegen_region_class_outlives_block_runs`).

**Fixing that uncovered the one underneath it, which is the usual way a pair like this comes apart.**
Being filed as a stack object had also been routing `delete` to the branch that destructs and never
frees — the right behaviour, reached for entirely the wrong reason. Take the misfiling away and
`delete` fell through to `emitDeleteObject`, which hands the pointer to the allocator; the sixteen
bytes in front of an arena object are arena bytes rather than a block header, so no stamp matches, the
allocator calls it foreign and forwards it to libc. Two existing tests turned into
**STATUS_HEAP_CORRUPTION** the moment the lifetime bug was fixed, which is the clearest evidence
either bug produced. `delete` on a region class now destructs and stops, deliberately: the destructor
is also what brings the instance counter down, which is what `release region` reads.

### Step 3 was not built, and the narrow pointer is what took it away

`__polaron_arena_alloc` is a **plain bump on a non-atomic `unsigned long long used`**, with no free
list anywhere. Step 3 specifies "the chunked-bump allocator with thread-local free lists and the
shared overflow stack", and the *Synchronization: measured, not argued* section above exists precisely
to justify it — sixteen cores, four strategies, a table of numbers. None of it is in the shipped
allocator.

It is not that the work was skipped; it is that the narrow-pointer rewrite **replaced** the allocator.
The old arena was a `growable pool` reached through `__polaron_region_new`, which had the free lists;
one reservation with one base was needed for offsets to be unique, so it went, and the free list and
the synchronization went with it without anything noticing.

Two things follow, both open:

- **Two threads allocating an A race on `used`.** Read-modify-write with no atomic: both can be handed
  the same offset, so two objects share one address. This is the failure the measurement section was
  written to prevent, and it contradicts the no-UB rule the rest of the language is held to.
- **`delete` reclaims nothing.** A pure bump has nowhere to put a freed slot, so an allocate/delete
  loop walks the 1 GiB reservation to its end and panics — with a message that tells the author to
  "delete what is finished with", which is the one thing that does not help.
- **And a double delete destructs twice, silently.** Everywhere else the freed stamp catches it; here
  there is no free list to write one into. This is not a third problem — it is the second one seen
  from the guard's side, and the same free list closes both.

Neither is a hole in the *design*: the design settled both, with numbers. What is missing is the
implementation, and it should be built against the table above rather than reinvented.
