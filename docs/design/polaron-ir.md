# Polaron IR (PIR) — specification

A middle of our own: the representation everything above the backend speaks, and the only place
Polaron's semantics can live.

- **Part I** — why this exists, with the measurements that decided its scope.
- **Part II** — the specification. Normative.
- **Part III** — what it is for: the fact inventory, the passes, the LLVM hand-off.
- **Part IV** — migration, in stages that each keep the compiler working.

---

# Part I — Why

## Why — and first, why NOT

This began as "the LLVM IR has bitten us a few times; let us depend on it less." Before designing
anything, both halves of that sentence were measured, and neither survived.

### The bugs have not been LLVM's

Every codegen defect this project has chased recently was in **our lowering layer**, not in LLVM:

| defect | whose |
|---|---|
| `typeName` exponential on a call chain (2026-08-15) | ours |
| `typeName(BinaryExpr)` exponential (1.0.13) | ours |
| `Scanner.nextWord` — one symbol for two classes | ours |
| vtables not gated by reachability → undefined symbol | ours |
| methods on the value form of `Option` dispatching through a tag | ours |
| `dir_list` returning a libc block freed by our allocator | ours (runtime) |

In the reachability work, LLVM's `GlobalDCE` was used as the **oracle**: the 678 samples were compiled
twice and its answer was taken as the truth our own analysis had to match. It found our bugs; we did
not find its.

### LLVM is not the slow half either

Measured on `tree_sync.pol` (697 KB of emitted IR), with the ~1.9 s that `vcvars64.bat` adds to every
invocation removed — that overhead had been polluting every earlier reading:

| stage | time |
|---|---|
| `polc` — front end, analysis, IR construction, printing | **264–381 ms** |
| `clang -O0 -c` — LLVM parses the IR, selects instructions, emits an object | 162 ms |
| `clang -O2 -c` — the same with the optimiser | 423 ms |
| `lld` — link | 148 ms |

Our half costs about twice LLVM's at `-O0`. A backend of our own, written to make compilation faster,
would be optimising the cheaper end while the expensive end stays exactly where it is.

### What the real reasons are

Three, and the first is the one that matters.

**1. There is nowhere for Polaron's own semantics to live.** The compiler goes from an AST straight to
LLVM IR in one step. Regions, ownership, persistents, contracts, unimport, the no-UB rules — none of
them can be represented in LLVM IR, so every check about them happens on the **tree**, before
lowering, where flow analysis is awkward and where types are recomputed on demand by walking. That is
not an aesthetic complaint: it is precisely where the bugs come from. `typeName` exists *because* the
tree does not carry types; it went exponential *because* two askers each re-derived the same answer.
In an IR where every value carries its type, that function does not exist to be wrong.

**2. LLVM assumes undefined behaviour never happens; Polaron forbids it.** The optimiser's whole
licence is "the program has no UB, so I may assume X". Polaron's rule is that UB is not expressible —
casts saturate, division is checked, indexing is bounds-checked. Handing a no-UB language to an
optimiser built on UB is a semantic mismatch we currently paper over. An IR of our own can say
`checked` and `wrapping` and `saturating` as *facts about the operation* rather than as emitted
guard code the optimiser then reasons about without knowing why it is there.

**3. LLVM is a heavy dependency to require of anybody building the compiler.** Hours and gigabytes
through vcpkg. That blocks self-hosting, blocks a small `polaron` distribution, and blocks bringing
up a new architecture without dragging the whole of LLVM along.

## The measurement that decided the scope (2026-08-18)

Before extending the design, the premise was checked: *does the backend today optimise around
Polaron's constructs?*

**It does not.** In **18 827 lines of codegen**, the total information forwarded to LLVM is:

| emitted | sites | from which feature |
|---|---|---|
| `llvm.assume` | 1 (`codegen_emit.cpp:1109`) | contracts |
| `NoAlias` on a return | 4 (`codegen_layout.cpp`) | allocator declarations |
| `onlyReadsMemory` | 1 | idem |
| `NonNull` + `Dereferenceable` + `Align` | 1, on parameter 0 | the `this` of instance methods |
| TBAA metadata | 2 | — |

Nothing else. No `noalias` from `unique` or from a moved pointer, no `readonly` from the absence of
`mutable`, no `nonnull` from a non-`nullable` type, no `!range` from a `newtype` with a bounded
domain, no `align` from a `layout`, no `invariant.load` from `fixed`, no `nounwind` from a method
that cannot throw.

The keywords carry the facts. The analyzer checks them. **They die at the lowering boundary.**

The `this` site is the proof that the technique is understood here — its comment explains that LICM
only speculates a load out of a non-guaranteed block when the address is dereferenceable **and
aligned**, and that the asymmetry in the emitted assembly is what pointed at it. Understood, and
applied in one place.

**Consequence:** an IR that merely *holds* Polaron's semantics optimises nothing either. What produces
optimisation is the pair in Part III — passes that rewrite on the facts, and a backend hand-off that
turns every remaining fact into something LLVM acts on.

## The decision

**PIR becomes the middle. LLVM stays as a backend.** Not a replacement — a demotion from "the only
representation" to "one of the ways out". At `-O2` LLVM costs 423 ms and produces code we would not
match in years of work; that trade stays.

What changes is that everything above the backend stops knowing about LLVM, and every Polaron-specific
check moves to a representation that can hold it.

---

# Part II — The specification

## 1. Principles

1. **Every value carries its type.** No `typeName(expr)` walking a tree. The type is a field, decided
   once when the value is created.
2. **SSA with block arguments, not phi nodes.** A block declares parameters; every branch to it passes
   values. A phi keeps an ordering agreement between its operand list and the block's predecessor
   list, and two lists that must agree is the shape this project keeps removing. Block arguments have
   no such agreement to break, and the translation to LLVM's phi form at the boundary is mechanical.
3. **Polaron semantics are first-class**, not lowered away: a region is a thing in the IR, not a
   malloc call; `move` is an instruction, not a memcpy; a persistent binding is a named slot.
4. **Every fact is on the thing it is about.** The overflow rule is on the arithmetic instruction, the
   calling convention is on the function, the storage discipline is on the type. Not in a side table
   the reader has to join.
5. **Verifiable.** A `pir::verify` pass that a malformed module cannot survive — the same role LLVM's
   verifier plays for us today, but speaking about our rules.
6. **Printable and parseable, round-tripping exactly.** That is what makes every stage testable in
   isolation and what makes a bug report a file.

## 2. Module

```
Module ::= target-triple
           data-layout
           TypeTable
           Global*
           Function*
           ModuleInit*        the lifecycle hooks that run before main
           ModuleFini*
```

A module names one bundle. `unimport` boundaries are recorded per function (§6), not per module: a
module is a unit of compilation, not a unit of cutting.

## 3. Types and the type table

### 3.1 Type grammar

```
PirType ::= void
          | int<N>                      N in 8,16,32,64,128    signedness is on the OPERATION
          | float<N>                    N in 16,32,64,128
          | bool
          | ptr                         opaque, as in LLVM 17+
          | addr<W>                     W in 8,16,32,64        `byte`/`short`/`half`/full address
          | struct { Field* }           classes, records, value structs, tuples
          | array<T, n, storage>        see 3.2 — the extent AND the discipline
          | slice<T>                    ptr + length, the `T[]` view form
          | fn(PirType*) -> PirType with Conv
          | region
          | variant { tag: int<32>, cases: PirType* }
          | closure { fn, captures: struct }
```

`Field ::= PirType, offset?, bitrange?` — `offset` is present exactly when the type came from a
`layout`; absent means the backend chooses. `bitrange` carries a bitfield's position and width so the
shift-and-mask is generated, not open-coded.

`addr<W>` is separate from `ptr` and that is load-bearing for freestanding: an address is a number the
program computed, a pointer is something the compiler tracks. Today the distinction exists in the
analyzer and is lost at lowering.

Signedness lives on the operation (`add.s` / `add.u`), which is how LLVM does it and is right: the
same bits are read two ways by different code, and putting it on the type multiplies the type table
for no gain.

### 3.2 Array storage discipline

`array<T, n, storage>` where `storage` is one of:

| storage | Polaron | representation |
|---|---|---|
| `inline` | `int[16]`, `int[3][4]` | the elements, in place. No length header, no pointer, nothing to release; dies with its owner |
| `heap` | `int[]` | a header carrying the length, reached through a pointer, released by `delete` |

Nesting reads outermost-first, as C, Java and C# read it: `array<array<int,4,inline>,3,inline>` is
`int[3][4]`, three of `int[4]`.

**Conflating the two is a double-free or a leak, depending on the direction**, which is why the
discipline is in the type rather than inferred from context.

### 3.3 The five facts every type entry carries

A type table entry is a shape **plus five facts**, decided once. The compiler already holds all five —
the `T.isValue()` / `T.owns()` / `T.isMovable()` / `T.isUnique()` / `T.sizeof()` queries are exactly
these, answered at compile time — and the passes want the same answers.

| fact | meaning | consumed by |
|---|---|---|
| `size`, `align` | in bytes | layout; the `align` and `dereferenceable` attributes |
| `isValue` | copied, not pointed at | escape analysis; whether a copy is a copy |
| `owns` | destroying one does work | destructor insertion; the container-of-values double-free |
| `isMovable` | may be `move`d | `move` verification; `partitionable` |
| `isUnique` | at most one live reference | alias analysis → `noalias` |

### 3.4 Nominal identity

A `newtype` is a **distinct entry** over the same shape, not an alias. `typealias` is erased at
lowering and survives only in metadata, for diagnostics. Two entries with the same shape and
different names never implicitly convert.

## 4. Values, blocks and block arguments

```
Value  ::= %name : PirType                    SSA, defined once
Block  ::= ^label(%arg : PirType, ...) { Inst* Terminator }
```

Every branch names the target block and supplies one value per declared parameter, positionally. The
verifier requires the counts and types to match at every edge. There are no phi instructions.

The entry block takes the function's parameters as its arguments.

## 5. Constants and globals

```
Global ::= @name : PirType = Init, Linkage, Storage
Init   ::= const | zeroinit | uninit | extern
Storage::= static | persistent | eternal | transient | threadlocal
```

`persistent` / `eternal` / `transient` are named storage classes, not a lowering trick: a persistent
binding is a slot the IR can see, which is what lets a pass ask where it is written.

## 6. Functions

```
Function ::= @key(Param*) -> PirType {
                 Linkage, Conv, Attr*, Unwind, Affinity, Cut?
                 Contract*
                 Block+
             }
```

- **`key`** — the Polaron name plus its class key. The backend derives the symbol from it. One source;
  the symbol-collision bug happened because the key was decided in one place and the name in another.
- **`Linkage`** — `public` | `internal` | `private` | `external`. `internal` and `private` become
  internal linkage, which is what lets LLVM inline and devirtualise inside a bundle. Currently thrown
  away with everything else.
- **`Conv`** — spelled exactly as the language spells it, so there is no translation table to keep in
  step: `polaron` | `cdecl` | `stdcall` | `fastcall` | `cppdecl` | `rustdecl` | `zigdecl` | `syscall`
  | `interrupt` | `naked` | `unknown <world>`. Six of these already reach the backend
  (`CallingConv::C`, `Win64`, `X86_64_SysV`, `X86_FastCall`, `X86_StdCall`, `ARM_AAPCS`) and must
  survive PIR verbatim; the target triple decides which machine convention `cdecl` becomes.
  `unknown <world>` adopts a foreign binary's ABI and carries the world name with it.
- **`Kind`** — `method` | `constructor` | `destructor` | `operator` | `procedure` | `interrupt`.
  A constructor and a destructor are functions with a key like any other; the kind is kept because
  `drop` names a destructor and the verifier checks it exists, and because an `operator` is a call
  whose spelling was an operator.
- **`Attr`** — `pure`, `nounwind`, `noreturn`, `inline.always`, `inline.never`, `noredzone`,
  `deprecated`.
- **`Unwind`** — `never` | `may`. Derived from `throws` and from what it calls.
- **`Affinity`** — `none` | `hot` | `cold`.
- **`Cut`** — present when the function belongs to a unit that `unimport` may remove at run time. It
  keeps the symbol reachable that DCE would otherwise delete, and names the reimport slot.
- **`Contract`** — `requires` / `ensures` / `invariant`, as facts (§7.11), not as emitted branches.

An `extern` function has a body of zero blocks plus a `Symbol` and an optional `Library`.

## 7. Instructions

Grouped by what they mean, not by how they lower.

### 7.1 Constants

```
const.int T, value          const.float T, value        const.bool value
const.null T                const.addr T, value         const.str bytes
const.fn @key               undef T
```

### 7.2 Arithmetic

The overflow rule is **part of the instruction**, which is the whole point:

```
add.wrap  add.checked  add.saturate            and likewise sub, mul, shl
div.checked  div.trap                          rem likewise
neg.wrap  neg.checked  neg.saturate
and  or  xor  not  shr.l  shr.a
```

Signed and unsigned select the operation, not the type: `add.s.checked`, `div.u.checked`.

Float arithmetic is `fadd`, `fsub`, `fmul`, `fdiv`, `frem`, `fneg`, with no overflow rule and an
explicit rounding/fast-math flag set.

Today the analyzer decides the rule and the codegen emits guard code; the fact is then invisible.
Here it survives into the backend, so LLVM gets the right intrinsic (`sadd.with.overflow`) and our
own backend picks the right instruction.

### 7.3 Comparison and conversion

```
cmp.s.lt  cmp.u.lt  cmp.f.olt  ...  cmp.eq  cmp.ne
trunc T          extend.s T      extend.u T
fp.trunc T       fp.extend T     fp.to.int.saturate T    int.to.fp T
ptr.to.addr      addr.to.ptr                              addr.narrow W    addr.widen W
```

Every narrowing conversion is `saturate` by default because the language says casts saturate. A
`wrap` variant exists and must be written explicitly.

### 7.4 Memory

```
alloca T                              frame slot
load T, ptr [volatile] [align n]
store T, value, ptr [volatile] [align n]
gep T, ptr, index*                    field or element address
memcpy dst, src, n                    memset dst, byte, n         memmove dst, src, n
```

`volatile` is a fact on the access that blocks every reordering. It is not a hint.

### 7.5 Aggregates

```
extract agg, index*        -> T           insert agg, value, index*  -> agg
```

For `inline` arrays and value structs, which have no address unless one is taken.

### 7.6 Regions

The reason this whole document exists. Four instructions were not enough: the language has sixteen
more words about regions and every one is a fact the binder wants.

```
region.create size, flavor, growable?  -> region
region.alloc  region, T                -> ptr        the allocation is IN a region, visibly
region.release region
region.accepts region, T               -> bool       the `accepts({T})` check, as a fact
region.mark   region                   -> mark       a snapshot point
region.restore region, mark                          rollback to it
region.extract region, ptr, T          -> ptr        take one object OUT, transferring ownership
region.depth  region                   -> int
region.validate region                 -> bool       the `validate` check
region.clone  region                   -> region
```

`flavor` is one of `bump`, `pool`, `stack`, `fixedslot`, `ring` — the set the parser accepts today —
and `growable` is a separate bit. For a `region class` the flavour is **deduced**, not chosen:
`fixedslot` for a pure class, `pool` for a family.

The escape vocabulary (`escapes`, `leaving`, `carrying`, `entrusts`, `within`, `mutual`,
`unlimited`, `atMultiple`) is not instructions — it is **edge annotation** on `region.alloc` results
and on call arguments, read by the region binder:

```
%p = region.alloc %r, T  escapes(leaving)          may outlive the region
call @f(%p carrying %r)                            the callee receives the region with it
call @f(%p entrusts)                               ownership transfers to the callee
```

Today a region is a runtime call and the type discipline is enforced only in the analyzer. In PIR the
binder walks the graph and answers "does this pointer outlive its region" as a dataflow question
instead of an AST pattern match — the analysis this project keeps wanting and keeps writing narrowly.

### 7.7 Ownership and lifetime

```
move src               -> value      source becomes invalid; the verifier enforces it
copy.deep src, T       -> value      the value-semantics copy, explicit
drop ptr, T                          run T's destructor
drop.cascade ptr, T                  and the owned graph beneath it
forget ptr                           ownership abandoned deliberately
```

A `weak` edge is a **field flag** in the type table, not an instruction: it says this slot does not
own, which is what lets the binder form the ownership forest instead of a graph with cycles.

### 7.8 Calls and dispatch

```
call        @key(args)                       -> T
call.indirect ptr, sig, args                 -> T
call.unwind @key(args) to ^ok unwind ^land   -> T      a call that may unwind
vtable.load obj, slot                        -> ptr    virtual dispatch, as ONE instruction
iface.load  obj, iface, slot                 -> ptr    interface dispatch
closure.make @key, captures                  -> closure
closure.call clo, args                       -> T
```

Making dispatch one instruction is what stops "the vtable was not emitted" from being found at link
time: the verifier requires every `vtable.load` to name a class whose table exists.

A `closure` records its capture set as a struct type, and whether it escapes — the second feeds escape
analysis directly.

### 7.9 Control

```
br ^target(args)
br.cond %c, ^then(args), ^else(args)
switch %v, ^default(args), [ case value -> ^block(args) ]*
ret %v            ret void
unreachable
```

`switch` over a `variant` whose case set is closed carries a `total` flag: there is no default edge to
keep alive, and the verifier requires every case to be named. That flag is what a `match` over a
`sealed enum` becomes, and it is what makes the exhaustiveness a property of the IR rather than of a
check that ran earlier.

A `goto` is a `br` and needs nothing of its own: the interesting jumps are the ones below.

**The chaos tetrad** is control flow, so it is edges and nothing else. `label` names a block;
`comefrom` adds an inbound edge to it from the named site; `abstainfrom` removes one; `reinstate`
restores it. They are recorded on the block as `comefrom ^site` / `abstainfrom ^site` so the CFG is
literally what the program says, with nothing to infer.

### 7.10 Unwinding

```
^land(%exc : ptr):
    landing                       -> exception value
    resume %exc                   continue unwinding
    cleanup.end
```

`defer` lowers to a cleanup block reached on **every** exit edge from the scope, normal and
unwinding — which is the guarantee the keyword makes and which no comment can enforce.

### 7.11 Facts, guards and contracts

The no-UB rules, named rather than open-coded:

```
guard.bounds index, length, loc
guard.null   ptr, loc
guard.divisor v, loc
guard.cast   value, T, loc
```

Emitting them as instructions rather than as branches means (a) the backend lowers them to a trap or a
check as the target prefers, (b) the optimiser can remove a redundant one because it knows what it is,
(c) `--no-bounds-check` becomes a pass that deletes a node instead of a flag threaded through the
emitter, and (d) it unblocks the hoisting the bounds check currently prevents.

Contracts are facts attached to the function and to the class, not code:

```
fact.requires  %cond, loc
fact.ensures   %cond, loc
fact.invariant %cond, loc
fact.range     %v, lo, hi
```

They are consumed by the guard eliminator **first** and lowered to `llvm.assume` **last**. An assume
emitted early is a fact thrown away.

### 7.12 Variants

```
variant.make T, tag, payload   -> variant
variant.tag  %v                -> int<32>
variant.payload %v, case       -> T
```

`catalog`, an `enum` with data, a `union` and the value form of `Option`/`Result` are all this. The
`Option` bug — a boxed case stored into a value slot and read back as a tag — is a type error here and
cannot be written.

### 7.13 Concurrency

```
suspend %state -> ^resume(args)       an await/yield point: splits the function
lock.acquire %m       lock.release %m
atomic.load / atomic.store / atomic.rmw op / atomic.cmpxchg   with an ordering
fence ordering
```

A suspension point is a CFG fact: the function is split, and the state that must survive the split is
the coroutine frame's type — which the verifier can check is exactly the set of values live across it.

### 7.14 Inline assembly

```
asm arch, template, constraints, operands*, clobbers*, [volatile] [align.stack]
```

Found by the coverage check and nearly missed: `asm("x86_64") { ... }` with its `clobber` list is a
first-class construct, the whole pico kernel rests on it, and this document had no representation for
it at all.

It is **not** an opaque string. The operands are PIR values with types, the clobber list names
registers the block destroys, and `arch` names the architecture the block is written for — which is
what lets the verifier refuse an `x86_64` block in an `aarch64` build instead of the assembler doing
it later and worse. `polc` already analyses assembly bodies semantically; that analysis has somewhere
to live now.

An `asm` block is a barrier for the passes in §11 unless its clobber list says otherwise.

### 7.15 Region-class self-allocation

```
itself.alloc T          -> ptr        allocate into the region this class IS
```

A `region class` is its own arena. `itself.allocate` is how an instance is placed in it, and the
flavour is deduced rather than chosen (§7.6). It is a distinct instruction from `region.alloc` because
there is no region operand to name — the receiver is the region.

### 7.16 Lazy and lifecycle

```
lazy.get @global, ^init               guarded first-use initialisation
```

Lifecycle hooks (`onClassLoad`, `onFirstInstance`, `onLastInstanceDestroyed`, `onClassUnload`) are
`ModuleInit`/`ModuleFini` entries with the class key they belong to. `onArrange` is a layout hook and
runs at compile time; nothing of it reaches PIR.

## 8. Metadata that travels

Every instruction carries a source location. Every function carries its Polaron name, its class key,
its visibility, and whether it is unimportable. Every type carries its Polaron spelling.

That is not decoration: the symbol-collision bug happened because the key was decided in one place and
the name in another. In PIR the function *has* a key, and the backend derives the symbol from it — one
source, no agreement to keep.

Annotations survive as metadata on the declaration they were written on, which is what inline tests
(`[Test]`, `[BeforeAll]`) read.

## 9. Verification

`pir::verify` refuses a module that breaks any of these. The list is normative; a rule not here is not
checked, and a check not here does not exist.

**Structural**
1. Every value is defined exactly once and every use is dominated by its definition.
2. Every block ends in exactly one terminator, and terminators appear nowhere else.
3. Every branch supplies one argument per declared block parameter, with matching types.
4. The entry block has no predecessors and its parameters are the function's.

**Types**
5. Every operand's type matches the instruction's signature.
6. `gep` indices are in range for the type being walked.
7. `array<T,n,inline>` is never `delete`d and never carries a length header; `slice<T>` always does.
8. A `newtype` never implicitly converts to or from its representation.

**Ownership**
9. A value that has been `move`d has no later use.
10. `drop` names a type whose `owns` fact is true.
11. A `weak` field is never the target of `drop.cascade`.

**Regions**
12. Every `region.alloc` names a live region.
13. A pointer with no `escapes` annotation has no use that outlives its region's `release`.
14. `region.restore` names a `mark` taken from the same region.

**Dispatch**
15. Every `vtable.load` names a class whose table is emitted in this module or declared external.
16. Every `iface.load` names an interface the object's class implements.
17. A `satisfies` obligation on a transformer is discharged by every type it `applies` to.

**Control**
18. A `switch` marked `total` names every case of its variant and has no default edge.
19. Every `call.unwind` has both a normal and a landing successor; a `landing` appears only as the
    first instruction of a block that is some `call.unwind`'s landing successor.
20. Every value live across a `suspend` is in the coroutine frame's type.

**Facts**
21. `fact.*` instructions have no uses and no side effects; deleting one is always sound.

---

# Part III — What it is for

## 10. The fact inventory

Every feature the compiler accepts — **135 hard keywords** and **57 contextual soft keywords** — and
where it lands. A feature that appears in neither column below is front-end only and correctly absent
(`bundle`, `namespace`, `import`, `using`, `partial`, `deprecated`, `var`, the primitive spellings,
`foreach`, `continue`).

### Facts about a value

| Polaron | PIR | consumed by |
|---|---|---|
| the type of everything | a field on the value | every pass; kills `typeName` |
| `mutable` / its absence | SSA by construction; a slot carries a `mut` bit | immutability propagation → `readonly`, `!invariant.load` |
| `nullable` / its absence | `nonnull` fact on a ptr | guard elimination → `nonnull` |
| `unique` | the `isUnique` type fact | alias analysis → `noalias` |
| `weak` | a non-owning field flag | the ownership forest |
| `move` | an instruction; the source dies | verifier; `noalias` at the destination |
| `newtype` | a distinct type-table entry | no implicit conversion; `!range` when bounded |
| `typealias` | erased; kept in metadata | diagnostics |
| `fixed` | a constant global | folding; `!invariant.load` |
| `volatile` | a flag on load/store | blocks reordering — a fact, not a guess |
| `address`, `half`/`short`/`byte address` | `addr<W>` | freestanding; half the traffic per pointer |
| `T.sizeof/align/owns/isValue/isMovable/isUnique` | folded before PIR; the facts are in the type table | §3.3 |

### Facts about memory and lifetime

| Polaron | PIR | consumed by |
|---|---|---|
| `region` + flavour + `growable` | `region.create` | region binding; per-flavour lowering |
| `region class` / `abstract region class` | a region whose object size is deduced | flavour deduction |
| `accepts` / `rejects` | `region.accepts` | admission folded at compile time |
| `escapes` `leaving` `carrying` `entrusts` `within` `mutual` `unlimited` `atMultiple` | edge annotations (§7.6) | the binder's dataflow |
| `mark` `restore` `rollback` `snapshot` | `region.mark` / `region.restore` | the runtime layer that already ships |
| `extract` `releasing` `validate` `clone` `depth` `allocate` | the region instruction set | binder; diagnostics |
| `on stack` / `on heap` / `in region` | the allocation names its arena | escape analysis can *rewrite* heap → stack |
| `defer` | a cleanup block on every exit edge | guaranteed release |
| `cascade delete` | `drop.cascade` | ownership forest |
| `persistent` `eternal` `transient` | storage classes on a global | placement; no re-derivation |
| `int[16]` vs `int[]` | `array<T,n,inline>` vs `slice<T>` | §3.2 |

### Facts about control and dispatch

| Polaron | PIR | consumed by |
|---|---|---|
| `sealed enum` + `match` | `switch ... total` | jump table; no default edge to keep alive |
| `interface` `implements` `override` | `iface.load` | devirtualisation; the verifier requires the table |
| `extends` `super` `permits` `final` `abstract` | the class hierarchy in the type table | devirtualisation when the target set is closed |
| `delegate` | resolved at declaration, recorded | one call, not a forwarding frame |
| `transformer` `applies` `collective` `procedure` `satisfies` | monomorphised; `satisfies` kept as an obligation | verifier rule 17 |
| `lambda` `methodref` `methodptr` | `closure` with its capture set (a `methodptr` has none) | escape analysis |
| `try` `catch` `finally` `throw` `throws` | `call.unwind`, `landing`, `resume` | `nounwind` when absent |
| `async` `await` `yield` | `suspend` | frame construction; verifier rule 20 |
| `synchronized` | `lock.acquire`/`release` | ordering |
| `interrupt` `naked` | a calling convention | `naked`, `noredzone`; **and no allocation allowed** |
| `comefrom` `label` `abstainfrom` `reinstate` | explicit CFG edges | nothing to infer |
| `unimport` `reimport` `expecting` `except` | the `Cut` marker on a function | keeps a symbol DCE would remove |
| `partitionable` `movable` | the `isMovable` fact plus a partition marker | the scheduler's fact, checkable |
| `affinity hot` / `cold` | a function attribute | `cold`, `!prof`, section placement |
| `public` `private` `protected` `internal` `static` | `Linkage` and `Storage` | internal linkage → inlining, devirtualisation |
| `lazy` | `lazy.get` | one guarded initialisation, not open-coded |
| `extern` + the seven conventions + `library` `symbol` `syscall` | `Conv`, `Symbol`, `Library` | must survive verbatim |
| lifecycle hooks | `ModuleInit` / `ModuleFini` | ordered static init |

### Facts about arithmetic, safety and layout

| Polaron | PIR | consumed by |
|---|---|---|
| the overflow rule | on the instruction | the right intrinsic |
| bounds / null / divisor checking | `guard.*` | **guard elimination** |
| `requires` `ensures` `invariant` | `fact.*` | the eliminator first, `llvm.assume` last |
| `comptime` `literal` | evaluated before PIR exists | nothing reaches the IR |
| `layout` | exact offsets, size, alignment on the fields | `align`, precise TBAA, one load not a computed GEP |
| bitfields | a bit range on a field | shift/mask generated, not open-coded |
| `record` `struct` `union` | value struct / variant | passed in registers; never aliases |
| `catalog`, `enum` with data | `variant` | §7.12 |
| `annotation` | metadata on the declaration | inline tests |

### The three spec-32 features — decided (Wave 4.5), and **none of them needs a node**

This section named three features as having no representation here: **bidirectional types** (32.6),
**resource tokens** (32.7) and **mutable dispatch tables** (32.8), each requiring a decision before
Stage 1 lowered a program that used one. All three are settled, and the answer is the same shape
three times: **the representation exists, in a form that was already there.**

| | what it needs | why no node |
|---|---|---|
| **32.6 bidirectional types** | nothing | `parser.cpp:2482` desugars `bidirectional double fahrenheit { celsius to fahrenheit: ...; fahrenheit to celsius: ...; }` into the **existing property machinery** — a computed getter and a `fahrenheit$set(value)` that assigns the backing field, with the names rewritten on the token stream. PIR never sees the construct; it sees two methods |
| **32.7 resource tokens** | nothing of its own | `ownership.md` §5–7: §32.7 is capability-based security — a `FileAccessToken` proving permission — and it is a **client** of the ownership design rather than a peer of it. A token is a `unique` value that may not be copied, which is `unique` doing its job. `Mutex<T>`, a file descriptor, a region token and a `using` guard are the same shape |
| **32.8 mutable dispatch tables** | **built, in Wave 3** | `Dog.methods.replace("bark", fn)` is `Module::replaceableMethods` (the method names that may be repointed) plus `Global::isConst = !rewritesItsVtable(c)` (a table that is written is not in `.rdata`). Both were needed by §11.8 for a different reason — a replaceable method must never be devirtualised, and a non-const vtable is not a fact — so the representation arrived as a **consequence of the pass rather than as a feature** |

**What the three have in common is worth more than the three answers.** Each was recorded as a gap
in this document while the compiler already had the mechanism: a desugaring, a keyword doing the
work under another name, and a pair of module fields. `ownership.md` §19 states the rule that catches
this — *"the method that keeps failing is trusting the notes; read the repository, not the record"* —
and it was written after the ledger recorded a thread-closure restriction the compiler had already
lifted. **Three more instances, found by going to look.**

## 11. The passes

A fact is worth nothing until something rewrites on it. In dependency order:

1. **`pir::verify`** — a malformed module cannot survive. Not an optimisation; the floor.
2. **Type-fact propagation** — `nonnull`, ranges from `newtype` and from `requires`, constants from
   `fixed`. Fills the lattice the next three read.
3. **Guard elimination** — a `guard.bounds` dominated by a stronger one, or by a `requires`, or by an
   `invariant`, is deleted. **This is the pass that pays for the project**: today the guard is an
   open-coded branch, so LICM will not hoist it and the vectoriser will not touch the loop.
4. **Immutability propagation** — a slot never stored to after initialisation becomes a value; loads
   hoist out of loops and survive across calls.
5. **Escape analysis** — an object allocated `on heap` that provably does not escape becomes
   `on stack`. Closure captures feed this.
6. **Allocation hoisting and sinking** — an allocation inside a loop whose result dies in the
   iteration moves out.
7. **Region binding** — a dataflow question over the graph, not an AST pattern match.
8. **Devirtualisation** — from `final`, from `sealed`, from `permits`, from a `vtable.load` with one
   possible target.
9. **Reachability / DCE** — already validated against LLVM's `GlobalDCE` as an oracle. `Cut` functions
   are roots.
10. **Contract lowering** — `fact.*` becomes `llvm.assume` *after* pass 3 has used it.

## 12. The hand-off — every remaining fact becomes something LLVM acts on

| PIR fact | LLVM |
|---|---|
| a value never stored to | `!invariant.load` on the load; `readonly` on the parameter |
| `isUnique`, or a pointer that was `move`d | `noalias` |
| non-`nullable` ptr | `nonnull` |
| a `region.alloc` result | `noalias` + `dereferenceable(n)` + `align(a)` |
| `layout` offsets | `align`, and TBAA built from the real layout instead of nothing |
| `newtype` with a bounded domain | `!range` on the load |
| `Unwind = never` | `nounwind` |
| `pure` | `readnone`, `speculatable`, `willreturn` |
| `Affinity = cold` | `cold` fn attr, `!prof` weights, `.text.unlikely` |
| `Linkage = internal/private` | internal linkage → inlining and devirtualisation inside the bundle |
| `fixed` | a constant global, `!invariant.load` |
| overflow rule `checked` | `llvm.sadd.with.overflow`, not an open-coded compare |
| `Conv` | the calling convention, verbatim |
| `interrupt` / `naked` | `naked`, `noredzone` — already done |
| `fact.*` surviving pass 10 | `llvm.assume` — already done, at exactly one site |

**This table is the acceptance criterion for the project.** When each row is emitted and measured, the
claim *«writing idiomatic Polaron is writing fast Polaron»* becomes true — and only then are the
`0Cxx` idiom warnings (`idiom-warnings.md`) honest, because their `why` can name an optimisation that
exists.

---

# Part IV — Getting there

## 13. Where PIR sits

```
source
  → lexer → parser → AST
  → analyzer            (names, types, visibility, ownership, regions — unchanged)
  → LOWER TO PIR        [new]  the AST is consumed here and never seen again
  → pir::verify         [new]  refuses a malformed module
  → pir passes          [new]  §11
  → backend
      ├── pir → LLVM IR   (release: hand LLVM the optimiser's worth of work)
      └── pir → IA-64     (the one target LLVM does not have; §15. Not scheduled)
```

The analyzer stays. This is not a rewrite of the front end — it is a new floor under the existing one,
and the existing codegen becomes one of two consumers.

## 13a. What is built (2026-08-19)

**A program compiles, links and RUNS through PIR, and prints what the trusted path prints.**
`tests/run_pir_behaviour_test.cmake` builds `hello_world.pol` both ways, links both, runs both and
requires the same output. That is the oracle Stage 3 asked for — comparing names could only ever say
a function exists.

The passes measured on a real program:

```
pir passes: guards-removed=1 immutable-slots=7118 dead-removed=2858 facts=203
```

`guards-removed=1` on a `foreach` over an array is the result the project rests on: **the loop's own
condition proves the bounds check, so the check is gone.** Open-coded as a branch that is invisible —
LICM will not hoist a check it cannot recognise and the vectoriser will not enter a loop containing
one. As a `guard.bounds` node against a `cmp` node it is a lookup. Proved four ways in
`tests/unit/test_pir.cpp`: a dominated guard, a guard a `requires` established, a loop-proved bounds
check, and — the half that matters more — a guard on a *different* array that is kept.


Stages 0 to 4 exist and are tested. `ctest -R pir_` is nine tests; `polaron_unit_tests` carries
thirteen more.

| stage | what is there | where |
|---|---|---|
| **0** | `Module`/`Function`/`Block`/`Value`/`Inst`, the type table with its five facts, the text form printing and parsing, and `verify` with the twenty-one rules of §9 | `src/pir/{type,module,print,parse,verify}.cpp` |
| **1** | The AST lowered to PIR behind `--emit-pir=<path\|->`, beside the real pipeline, with a **counted gap list** for what it does not cover | `src/pir/lower.cpp` |
| **2** | PIR → LLVM, and §12's hand-off table emitted and **counted** | `src/pir/tollvm.cpp` |
| **3** | ✅ **Complete, 2026-08-25.** The trusted path is deleted; PIR is the only back end | — |
| **4** | Guard elimination, immutability propagation and DCE, on the graph | `src/pir/passes.cpp` |

**Stage 3 was the oracle before it was the deletion.** The default was not changed until the
ratchets reached zero and the differential compared bodies rather than names — flipping it with a
lowering that still counted its gaps would have been declaring victory. What follows is the record
of both halves.

### The flip, 2026-08-21

Everything the flip was waiting for arrived: the ratchets reached zero, the differential compares
what the programs PRINT, and the speed is level. The default was flipped to try it, and **one thing
failed: `--test`.**

The synthetic runner over a program's `[Test]` methods — fixtures, `[Cases]`, `[Repeat]`,
`[ExpectedToFail]`, `[Tag]`/`[MaxTime]`, the JSON form, the golden comparison — is built inside the
trusted backend (`CodeGenerator::setTestMode`), and **the PIR lowering has no notion of it.** A
program compiled `--test` through PIR gets its own `main` as the entry and runs *that*:
`test_lifecycle --list` printed `run me with --test`, which is the line the sample's own `Main.main`
prints. Nine tests in the suite caught it within a minute of the flip.

Silently running a different program than the one asked for is not a gap to ship, so **the default
was put back** while the runner moved to `codegen/testrunner` -- beside both backends, because which
entry point `--test` means is the LANGUAGE's rule. See the note at the top of that header, and the
three real divergences between the two backends that the move exposed: a `boolean` is an i32 in one
and an i1 in the other, dead-code elimination removed every `[Test]` method (reachable only from an
entry that did not exist yet), and the prelude methods the runner itself calls went the same way.

**And the differential was discarding stderr.** A panic prints there, so every diagnostic in the
language -- the `--> file:line:col in Method` line under a panic, a violated contract, a `defer`
past its budget -- was outside the comparison. Turning it on surfaced six real differences
immediately, every one of them PIR printing less than the other path. Fixed; the numbers below are
with stderr compared.

**The default is PIR.** What it rests on:

| | |
|---|---|
| the corpus, both ways, outputs compared -- **stdout AND stderr** | **693/693 at -O0, 694/694 at -O2** -- no difference, no build failure, no link failure |
| `ctest`, with PIR as the default | **1010/1010** |
| `--test`, through either backend | `test_lifecycle`, `test_full` and `test_class_load` print byte-for-byte the same |
| Forge, the IDE -- a hosted GUI program with a library | builds, links, **476 editor checks** through PIR |
| pico, a freestanding kernel and its ring-3 payload | boots and passes **all 219 checks**, FAT16 and FAT32, through PIR |
| speed | **median 1.00x** over 19 benchmarks, worst 1.08x, best 0.84x |
| cross targets | aarch64, wasm32, i686, armv7, m68k and powerpc all COMPILE through PIR with matching data layouts -- not RUN here, there is no qemu in this session |

**The older path is not going anywhere, and that is deliberate.** The differential IS the
verification: every sample is built both ways and the outputs compared, and a harness cannot compare
two things if one of them is gone. What the flip changes is which one a user gets without asking.

*(It went, four days later. See "The deletion" below — and note that the sentence above states
exactly the debt that deletion had to pay first.)*

**Every arm of every comparison now NAMES the backend it wants** -- and that change was kept, because
it is right under either default. Leaving the variable unset selects whatever the default is, so a
harness reaching for the trusted path by unsetting would, the moment the default moved, compile PIR,
compare it with itself, and report agreement on everything. That failure has happened here once
already, silently, for twenty-two samples; the four CMake drivers and the sweep scripts now pass
`POLARON_VIA_PIR=0` explicitly.

**And the two backends now spell a class the same way.** The trusted path names every class struct
`class.<Name>`; PIR named it `<Name>`, so `%class.RealModePointer = type { i16, i16 }` -- the test
that pins the narrow-address layout -- could not match. Two paths that spell one class two ways
disagree about their own output, and nothing notices until one of them becomes the default.

### The measurement that is the point

The 2026-08-18 measurement found the old path forwarding, in 18 827 lines of codegen: **one**
`llvm.assume`, **four** `NoAlias` returns, **one** `onlyReadsMemory`, **three** attributes on `this`.

Through PIR, on one small program (`tests/samples/fixed_array.pol`, the standard library
monomorphised in):

```
pir->llvm handoff: nonnull=1973 align=11072 nounwind=2220 internal=23 checked=790
pir passes: guards-removed=0 immutable-slots=1403 dead-removed=75
```

`checked=790` is 790 arithmetic operations handed to LLVM as `llvm.sadd.with.overflow` rather than
as an open-coded compare the optimiser has to reverse-engineer. `nounwind=2220` is 2 220 methods
LLVM now knows cannot unwind. Those two rows alone did not exist before.

**`guards-removed=0` on that program is honest and is not a failure of the pass.** The pass works and
is proved three ways in `tests/unit/test_pir.cpp`: it deletes a guard dominated by an identical one,
it deletes a guard a `requires` has already established — *«contracts that pay for themselves»*, and
it is only possible because the fact and the guard live in one representation — and it keeps a guard
on a different value. Zero on that sample means the lowering emits few guards yet, not that the
elimination does not happen.

### The number that decides whether LLVM's path can be turned off

`tests/run_pir_batch_test.cmake` compiles sixty samples **both ways**, links both, runs both, and
compares the output. It is ratcheted: the count may only go up, and a crash fails outright.

```
pir batch: 9 agree, 28 differ, 17 do not build
```

**Nine of fifty-four.** That is the answer to "can the trusted path be turned off", and it settled
the question better than any amount of reasoning about it would have. The migration is finished when
this number is the sample count, and not before — turning the default over at nine would break the
compiler for the other forty-five.

What it has already caught, in its first two runs: a `polc` that **segfaulted** on
`array_literals.pol` because a local whose type the lowering could not work out produced an
`alloca void`, which LLVM asserts on — and an assertion in a Release build is a crash with no
message. Fixed in both places, and a crash now fails this test by name rather than showing up as a
difference.

### The deletion, 2026-08-25

Stage 3 completes here. **24 092 lines gone**, eleven files under `src/codegen/` plus the four
harnesses that existed only to compare the two. `llvm::` in `src/` went from 3 399 mentions to
1 016, and every remaining one outside `tollvm.cpp` is a shared service rather than a back end:
`bridges` (what a program with no libc must be given), `testrunner` (`--test`), `optimize` (the
middle end) and `target` (the data layout).

**The debt was paid before the deletion, not after.** Every check that existed only as a *comparison*
stops existing at the moment the second side is removed, and seven defects had been found by that
comparison and by nothing else. So each was first re-expressed as an ABSOLUTE check — a number the
program reports about itself, held against a recorded expectation:

| the comparison | what replaced it |
|---|---|
| "PIR allocates where trusted does not" | `live_*`: `POLARON_LIVE` at exit against a recorded `bytes/blocks` pair, 21 samples |
| "PIR strides differently" | a sample that reads back what it wrote through an array of a padded struct |
| "PIR emits no `x86_intrcc`" | `object_*`: the convention and the `iretq`, read out of the emitted object |
| "the bodies differ in shape" | `golden_ir_*`: the exact IR of three chosen functions, recorded |

Two of them exist only to prove the instrument still has teeth: `live_catches_reintroduced_defect`
and `golden_ir_catches_reintroduced_defect` each put a real, fixed defect back behind an environment
variable and **fail if the check does not notice.** Both were green before anything was deleted.

**And the absolute half was never a consolation for losing the differential — it is the half that was
always missing.** PIR was built against the trusted path, so a defect present in BOTH never diverged
and was never visible. Wave 1 closed eighteen defects, and **four of them had been sitting in both
back ends, agreeing with each other, called correct by every comparison in the suite** — three of the
four were wrong answers rather than leaks.

**What the deletion itself found, in twelve minutes:** twelve diagnostics stopped being emitted, and
not one of them failed loudly. `polc` accepted each program, emitted IR for it, and exited 0. They
were the checks the trusted path performed *as it walked the AST* — a `region class` placed `on
heap`, an `asm` block written for another architecture, `extern syscall` on Windows, `interrupt` on
AArch64, threads on bare wasm, a static initialiser that would have to allocate before the process
exists, a `demand` over `sizeof`, a `layout` byte budget, and a `--target` naming an architecture
LLVM cannot parse. PIR had no error channel at all — only `gaps`, which say "not lowered yet" and
emit the module anyway. It has one now (`Lowering::errors`), and the distinction is the point: a gap
is a work queue, an error is a program that must not be built.

### What is still open, named rather than implied

- The lowering's gap list: `ForeachStmt`, `InterpStringExpr`, unresolved names (namespace constants
  and enum members), and `delete` targets whose type it has not propagated.
- The differential compares **names**, not bodies. Comparing bodies is what decides Stage 3.
- Synthesised definitions — an implicit constructor, `__onClassLoad` — are emitted by the front end
  and not by the lowering. They are what the ratchets currently hold.
- `noalias=0`: nothing sets `isUnique` yet, because the lowering does not read `unique` from the
  declaration. One row of §12 with nothing behind it.

## 14. Migration, in stages that each keep the compiler working

The rule this project already follows: never spend days with the pipeline broken. Each stage ends with
a compiler that passes the whole suite.

**Stage 0 — the shape, with nothing depending on it.**
`pir::Module`, `Function`, `Block`, `Value`, `Inst`, the type table with its five facts, the text
printer and parser, and `verify` with the twenty-one rules of §9. Round-trip tests only: print a
module, parse it back, require identity. No connection to the compiler yet.

**Stage 1 — lower, print, throw away.**
A `--emit-pir` flag that lowers the AST to PIR and prints it, in parallel with the real pipeline that
still goes straight to LLVM. Nothing depends on the result, so nothing can break. This buys the whole
sample suite as PIR test input immediately, and it is where the three "still to design" features must
be settled.

**Stage 2 — PIR → LLVM, behind a switch.**
A second backend that consumes PIR and produces the same LLVM module. `POLARON_VIA_PIR=1` selects it.
**Differential testing is the oracle** — the same method the reachability work used against
`GlobalDCE`: compile all 880+ samples both ways and require the final modules to name the same things
and the programs to print the same output. Where they differ, the old path is right until proven
otherwise.

**AND ASKING FOR THIS BACKEND MEANS GETTING IT.** When `toLlvm` produced a module LLVM refused, polc
used to print one line and then write the TRUSTED module to the output — so the sample compiled,
linked, ran and printed exactly what the other arm printed, because it *was* the other arm.
Twenty-two samples were counted as agreement on that basis and had never once been built by the
backend they were testing. `POLARON_VIA_PIR=1` with an unusable PIR module is now an error and stops
the compile: a comparison whose two sides can quietly become the same side is not a comparison.

Two switches exist for bisecting, and both CAP rather than enable — a debugging knob that turns
something on which the command line did not ask for is not a debugging knob:

| variable | effect |
|---|---|
| `POLARON_PIR_OPT=<0..3>` | caps the LLVM optimisation level applied to the PIR module |
| `POLARON_PIR_PASSES=<list>` | runs only the named §11 passes: `fold`, `guards`, `immutable`, `dead`, `purity`, `reach`. Unset runs all of them |

The second was written for pico: when a 66 000-line kernel boots one way and hangs the other, the
first question is WHICH transformation changed it, and answering that by editing a file and
rebuilding costs twenty minutes a guess. It earned its keep immediately by clearing every §11 pass of
the failure being chased.

**Stage 3 — flip the default, keep the old path.**
PIR becomes the way through; the direct AST→LLVM path stays behind a flag for one release as the
comparison. Once a release passes with no differences it is deleted — and roughly 3 400 lines of
`llvm::` spread over 11 files collapses into one backend that is the only thing holding an `llvm::`
type.

**Stage 4 — move the analyses down.**
Region binding, ownership flow, guard elimination, reachability: each moves from the AST to a PIR
pass, one at a time, each keeping its tests. This is where the win is collected — these are the
analyses that are hard on a tree and natural on a graph.

**Stage 5 — a back end of our own, replacing LLVM. Not scheduled; the ambition is recorded.**

Stage 5 was cut once, and the cut was correct **for the thing that was proposed then**: a second
back end, for debug builds and freestanding, sitting beside LLVM. Those reasons are kept below,
because two of the three do not survive a change of ambition and one does.

### 15.1 What was written against it, and what still stands

| the argument against | under a *replacement* |
|---|---|
| **Debug speed.** `clang -O0 -c` costs 162 ms against our 264–381 ms; a perfect back end removes 23% of the pipeline for months of work | **never was the point of a replacement.** Speed of compilation is not why one would be written; control of code generation is |
| **Dropping the LLVM dependency.** *"A second back end that is not the only back end does not remove a dependency"* | **answered.** The bar below is that it is the only one |
| **A second back end is a second place where lowering bugs live** — and every recent defect was in our lowering layer, none in LLVM | **answered by the same bar.** One lowering layer, not two — but see §15.4, because during the transition there are two |
| **The UB mismatch** — paid by Stage 2, which names the rule on the instruction | still true, and unaffected either way |

### 15.2 The bar, and it is the whole of the decision

> **A back end of our own is worth building only if it is built to cover everything** — every target
> already supported, every optimisation level, release as well as debug, and everything the language
> gains afterwards.

This is the bar that kills the alternative. Zig and Rust both ship their own back ends **for debug
only** and keep LLVM for release; the result is two lowering layers, two sets of bugs, and a
dependency that never goes away. Built that way, the project would take the cost of §15.1's third
row and none of the benefit of its second.

Everything or nothing.

### 15.3 What is actually gained, and it is not speed of compilation

**We would dictate exactly how everything Polaron knows becomes machine code.**

The §12 hand-off table exists because today our facts have to be *translated* into LLVM's vocabulary
and then hoped over. `isUnique` becomes `noalias` — which is close, not equal. A guard that pass 3
*proved* redundant becomes an absence, not a proof. `switch ... total` becomes a `switch` and the
totality is dropped at the boundary. A back end reading PIR consumes the facts themselves: it does
not approximate them into another IR's nearest word.

And the campaign that produced `PLAN.md` added an argument the original cut did not have:

> **Our last step is clang, and on a strided read over an array of records clang is 2–5.7× behind
> GCC — on identical C, with no bounds checks and no header.** Four tests reach it independently.
> Raising Polaron to `-O3` moves it 1028 → 924, so it is a vectoriser and not an optimisation level.

That is a ceiling we do not control and cannot raise from our side. A back end of our own is the only
path that is not hostage to it.

### 15.4 What remains true, and must not be soft-pedalled

**The scale.** Covering everything means instruction selection, register allocation, scheduling, the
ABI for every supported target, unwind tables, DWARF, atomics, SIMD, inline-assembly integration,
relocations, object formats (ELF/COFF/Mach-O) and a linker. It is the largest single undertaking
available to this project, by a wide margin.

**And LLVM's optimiser is thousands of person-years.** The honest division is that PIR's passes do
the work LLVM *cannot* do — the language-specific proofs — and a native back end does the
machine-specific work. Matching the machine-specific half is the hard part, and the vectoriser gap
above cuts both ways: it shows LLVM is beatable on one shape, not that it is beatable in general.

**During the transition there are two lowering layers**, which is exactly the surface §15.1's third
row warns about. It is survivable only with the instrument that Stage 3 already requires: a
differential oracle comparing **bodies**, not names.

### 15.5 When it becomes a sane thing to start

Three preconditions, in order:

1. **Stages 0–4 finished** — in particular every §12 hand-off row emitted and measured, because that
   table is what says which facts actually pay. Building a back end before knowing that is guessing
   at its input.
2. **`PLAN.md` Wave 4 has run** — the experiment that hands LLVM `noalias`, real TBAA and
   `dereferenceable` and asks whether it vectorises the strided read it refuses to vectorise for C.
   If it does, the ceiling of §15.3 lifts and Stage 5 loses its sharpest argument. **If it does not,
   Stage 5 stops being an ambition and becomes the answer to a measured problem.**
   **It has run — see §15.5a. The answer is neither of those two.**
3. **Somebody wants it** for a reason bigger than elegance.

### 15.5a Wave 4 — it ran, and the gap was the benchmark

> **In one line: with the benchmark's own repetition made real, Polaron is level with clang and 24%
> AHEAD of GCC on the loop it was recorded as being 5.7× behind on.**

The ledger's largest performance target, reached from four directions — AP-02, AP-06, AP-08, AP-10 —
was *"GCC vectorises the strided reduction; clang leaves it scalar,"* and Polaron sits on clang's
number because Polaron **is** clang at the last step. Two hypotheses were written down: the facts
change LLVM's answer, or LLVM's vectoriser does not do this shape.

**Neither. The measurement was not measuring what it said.**

**Step one — aliasing is not the reason.** The same reduction in C, four ways, `-O3`:

| variant | clang | gcc |
|---|---|---|
| pointer parameter, nothing declared | scalar | scalar |
| `__restrict` — C's whole vocabulary for *nothing else touches this* | scalar | scalar |
| a 16-byte record (half the stride) | scalar | **vectorised** |
| the field lifted into its own array (unit stride) | **vectorised** | **vectorised** |

`restrict` changes clang's output **by not one instruction** — 282 both times, zero SIMD. Whatever
stops it, it is not doubt about aliasing, and so not something `noalias` was ever going to fix.
Hypothesis 1 is dead, for a reason worth keeping: *a fact can only help where the missing fact was
the obstacle.*

**Step two — GCC's assembly for the case it does NOT vectorise.**

```
.L2: movslq (%r8), %rcx          ; load a[i].who ONCE
     movl   $20, %eax
.L3: leaq   (%rdx,%rcx,2), %rdx  ; and add it twenty times, in a register
     subl   $2, %eax
     jne    .L3
     addq   $32, %r8             ; only THEN move to the next record
```

**GCC interchanged the loops.** The benchmark walks the array twenty times to get a measurable
duration; GCC swapped them so the walk happens *once* and each value is added twenty times, then
strength-reduced that twenty into ten `+2x`. **One twentieth of the memory traffic, in a benchmark
whose whole subject is memory traffic.** It is not vectorisation and it never was.

**Step three — the same loop with the rounds made real.** One empty `asm` with a memory clobber per
round: it emits nothing, so what is timed is still the walk, but interchange becomes illegal and all
twenty walks must happen. Picoseconds per read, five runs, median:

| | declared (32 B) | arranged / sorted (16 B) |
|---|---|---|
| **Polaron `-O3`** | **257** | **163** |
| C, `clang -O3` | 265 | 162 |
| C, `gcc -O3` | 337 | 197 |
| *C, `gcc -O3`, as the benchmark was written* | *113* | *57* |

Polaron is **level with clang** and **24% / 17% ahead of GCC**. The entire recorded gap — the single
biggest performance target found so far — was GCC exploiting a repetition loop that exists only
because the program is a benchmark.

**What survives, smaller and truer:**

- **LLVM does not do loop interchange; GCC does.** Real, and worth 2.9× *here*. On a program that
  walks an array once — which is what a program does — it is worth nothing. Something to know, not
  something to build a back end for.
- **LLVM's vectoriser wants unit stride; GCC's manages 16-byte stride.** Also real, also narrower
  than recorded: at 32 bytes neither vectorises. `layout` + `fitWithin` gets records to 16 bytes,
  which is exactly the band where GCC's vectoriser reaches and LLVM's does not — so the language
  feature pays, and would pay *more* under a back end that vectorised there.
- **Nothing here argues for Stage 5.** Precondition 2 is discharged in the direction that removes
  its sharpest argument. A back end of our own would have to beat clang, and clang is currently the
  faster of the two production compilers on this loop.

**The lesson that outlives the numbers.** Four findings agreed, and all four were downstream of one
benchmark shape. **Agreement between measurements that share a defect is not corroboration — it is
one reading taken four times.** Every timing loop in `anti-procedural-tests` repeats its work to get
a duration, and every one is exposed to this; `LEDGER.md` and the four findings are re-measured in
Wave 8 against the honest form.

### 15.6 IA-64 stops being the target and becomes the proof

The case below was written when IA-64 was the *only* back end thought worth writing. Under §15.2 it
is something better: **the instance that shows the general case is right.** If a back end has to be
built to cover everything, then building it to cover a machine LLVM has no target for at all costs
nothing extra in ambition — and IA-64 is the machine that most rewards exactly what PIR carries.

**LLVM has no IA-64 target.** The Itanium backend was removed long ago. For every other
architecture, writing a backend means competing with one that exists and wins; for IA-64 there is
nothing to compete with. That is the whole difference.

**And EPIC wants exactly the facts PIR carries.** On an out-of-order machine the *hardware* finds the
parallelism, speculates and predicts. On IA-64 the **compiler** does all of it and emits the result
explicitly: bundling into 128-bit groups with templates, predication instead of branches, control and
data speculation, rotating registers, software pipelining. An EPIC backend lives or dies by what the
compiler can *prove* — and a language without UB, whose checks are named instructions, proves more
than C can:

| EPIC needs to know | PIR already says it |
|---|---|
| this operation cannot fault, so it may be hoisted above the branch that guards it | guard elimination (§11.3) proved it and deleted the guard |
| both arms are total and side-effect free, so the branch may become predication | `switch ... total` over a closed `variant` |
| this load cannot alias that store, so it may be speculated | `isUnique` / `noalias` (§3.3) |
| this call cannot unwind, so the region may be scheduled as one | `Unwind = never` |

The shape is a **target-selected backend**, not a replacement: the compiler branches on the target
triple, IA-64 goes to our own backend, everything else goes to LLVM. Nothing is abandoned; a
destination is added to a middle that already exists.

It is not scheduled. It becomes possible once stages 0–4 are done, and it should be started only when
somebody actually wants to run Polaron on that machine.

## 16. What this does NOT do

- **It does not remove LLVM**, and it does not try to. Every architecture LLVM supports keeps going
  through LLVM, at every optimisation level.
- **It does not make compilation faster on its own.** Our half is already the slower one; PIR adds a
  step. Speed comes from the passes of §11 and from analyses that stop re-walking trees — not from
  replacing a backend that was measured and found not to be the problem.
- **It does not replace the analyzer.** Names, visibility and type checking stay where they are.

## 17. How we will know it worked

- The exponential class of bug becomes unwritable: no query recomputes a type, because values have
  types.
- `llvm::` appears in exactly one directory.
- Every Polaron-specific rule has a pass that owns it, with its own tests, instead of living as a
  special case in the emitter.
- A malformed lowering is caught by `pir::verify` with a Polaron-shaped message, not by LLVM's
  verifier with `Function return type does not match operand type of return inst!`.
- Every row of §12 is emitted, and each one has a measurement next to it.
