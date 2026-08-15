# Polaron IR: a middle of our own

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

### The decision

**PIR becomes the middle. LLVM stays as a backend.** Not a replacement — a demotion from "the only
representation" to "one of the ways out". At `-O2` LLVM costs 423 ms and produces code we would not
match in years of work; that trade stays.

What changes is that everything above the backend stops knowing about LLVM, and every Polaron-specific
check moves to a representation that can hold it.

---

## The shape of PIR

### Principles

1. **Every value carries its type.** No `typeName(expr)` walking a tree. The type is a field, decided
   once when the value is created.
2. **SSA with explicit blocks.** One assignment per value, phi nodes at joins. It is the shape flow
   analysis wants, and every check we already do by hand on the AST becomes a walk over a graph.
3. **Polaron semantics are first-class**, not lowered away: a region is a thing in the IR, not a
   malloc call; `move` is an instruction, not a memcpy; a persistent binding is a named slot.
4. **Verifiable.** A `pir::verify` pass that a malformed module cannot survive — the same role
   LLVM's verifier plays for us today, but speaking about our rules.
5. **Printable and parseable.** A text form that round-trips, because that is what makes every stage
   testable in isolation and what makes a bug report a file.

### Types

```
PirType ::= void
          | int<N>            N in 8,16,32,64,128        signedness is on the OPERATION, not the type
          | float<N>          N in 16,32,64,128
          | bool
          | ptr                                          opaque, as in LLVM 17+
          | addr                                         a machine address; distinct from ptr (spec 36)
          | struct { PirType* }                          classes, records, tuples, value structs
          | array<PirType, n>                            fixed; dynamic arrays are a header + ptr
          | fn(PirType*) -> PirType
          | region                                       a first-class region handle
          | variant { tag: int32, payload: int64 }       Option/Result value form, named
```

Signedness lives on the operation (`add.s` / `add.u`), which is how LLVM does it and it is right: the
same bits are read two ways by different code, and putting it on the type multiplies the type table
for no gain.

`addr` separate from `ptr` matters for freestanding: an address is a number the program computed, a
pointer is something the compiler tracks. Today that distinction exists in the analyzer and is lost
at lowering.

### Instructions

Grouped by what they mean, not by how they lower.

**Arithmetic** — the overflow rule is part of the instruction, which is the whole point:
```
add.wrap  add.checked  add.saturate      and the same for sub, mul, div, rem, shl
```
Today the analyzer decides the rule and the codegen emits guard code; the fact is then invisible.
Here it survives into the backend, so LLVM can be handed the right intrinsic (`sadd.with.overflow`)
and our own backend can pick the right instruction.

**Memory**
```
alloca T                    frame slot
load T, ptr                 store T, value, ptr
gep T, ptr, indices         field/element address
```

**Regions** (spec 17) — the reason this section exists at all:
```
region.create size, flavor            -> region
region.alloc  region, T               -> ptr        the allocation is IN a region, visibly
region.release region
region.accepts region, T              -> bool       the `accepts({T})` check, as a fact
```
Today a region is a runtime call and the type discipline is enforced only in the analyzer. In PIR the
binder can walk the graph and answer "does this pointer outlive its region" as a dataflow question
instead of an AST pattern match — which is the analysis we keep wanting and keep writing narrowly.

**Ownership** (spec 19)
```
move src            -> value          source becomes invalid, checkable by the verifier
copy.deep src, T    -> value          the value-semantics copy, explicit
```

**Calls and dispatch**
```
call fn, args
call.indirect ptr, sig, args
vtable.load obj, slot -> ptr          virtual dispatch, as an instruction rather than three GEPs
```
Making dispatch one instruction is what stops "the vtable was not emitted" from being discovered at
link time: the verifier can require that every `vtable.load` names a class whose table exists.

**Sum types**
```
variant.make tag, payload -> variant
variant.tag  v            -> int32
variant.payload v, T      -> T
```
The `Option` bug — a boxed case stored into a value slot and read back as a tag — is a type error in
PIR and cannot be written.

**Control**
```
br label            br.cond v, then, else            switch v, default, cases
ret v               unreachable
phi [v, block]*
```

**Guards** — the no-UB rules, named rather than open-coded:
```
guard.bounds index, length, loc
guard.null   ptr, loc
guard.divisor v, loc
```
Emitting them as instructions rather than as branches means (a) the backend can lower them to a trap
or a check as the target prefers, (b) the optimiser can remove a redundant one because it knows what
it is, and (c) `--no-bounds-check` becomes a pass that deletes a node instead of a flag threaded
through the emitter. It also unblocks the hoisting that the bounds check currently prevents
(`ldp3-boundscheck-vectorization`).

### Metadata that travels

Every instruction carries a source location. Every function carries its Polaron name, its class key,
and whether it is unimportable. That is not decoration: the symbol-collision bug happened because the
key was decided in one place and the name in another. In PIR the function *has* a key, and the
backend derives the symbol from it — one source, no agreement to keep.

---

## Where PIR sits

```
source
  → lexer → parser → AST
  → analyzer            (names, types, visibility, ownership, regions — unchanged)
  → LOWER TO PIR        [new]  the AST is consumed here and never seen again
  → pir::verify         [new]  refuses a malformed module
  → pir passes          [new]  reachability, guard elimination, region binding, DCE
  → backend
      ├── pir → LLVM IR   (release: hand LLVM the optimiser's worth of work)
      └── pir → machine   (debug and freestanding; later)
```

The analyzer stays. This is not a rewrite of the front end — it is a new floor under the existing one,
and the existing codegen becomes one of two consumers.

---

## Migration, in stages that each keep the compiler working

The rule this project already follows: never spend days with the pipeline broken. Each stage below
ends with a compiler that passes the whole suite.

**Stage 0 — the shape, with nothing depending on it.**
`pir::Module`, `Function`, `Block`, `Value`, `Inst`, the type table, the text printer and parser, and
`verify`. Round-trip tests only: print a module, parse it back, require identity. No connection to the
compiler yet.

**Stage 1 — lower, print, throw away.**
A `--emit-pir` flag that lowers the AST to PIR and prints it, in parallel with the real pipeline that
still goes straight to LLVM. Nothing depends on the result, so nothing can break. What this buys is
the whole sample suite as PIR test input immediately.

**Stage 2 — PIR → LLVM, behind a switch.**
A second backend that consumes PIR and produces the same LLVM module. `POLARON_VIA_PIR=1` selects it.
**Differential testing is the oracle** — the same method the reachability work used against GlobalDCE:
compile all 880+ samples both ways and require the final modules to name the same things and the
programs to print the same output. Where they differ, the old path is right until proven otherwise.

**Stage 3 — flip the default, keep the old path.**
PIR becomes the way through; the direct AST→LLVM path stays behind a flag for one release as the
comparison. Once a release passes with no differences, it is deleted — and roughly 3 400 lines of
`llvm::` spread over 11 files collapses into one backend that is the only thing in the compiler
holding an `llvm::` type.

**Stage 4 — move the analyses down.**
Region binding, ownership flow, guard elimination, reachability: each moves from the AST to a PIR
pass, one at a time, each keeping its tests. This is where the win is actually collected — these are
the analyses that are hard on a tree and natural on a graph.

**Stage 5 — a second backend.**
`pir → x86-64` directly, for debug builds and for freestanding. Only worth starting once stages 0–4
are done and PIR has proven itself as the middle. The measured budget it has to beat is 162 ms for
`tree_sync` at `-O0`; if it cannot, it is not worth having, and LLVM stays the only backend — which is
a perfectly good outcome.

---

## What this does NOT do

- **It does not remove LLVM.** Release builds keep it, and should.
- **It does not make compilation faster on its own.** Our half is already the slower one; PIR adds a
  step. The speed comes later, from stage 5 and from analyses that stop re-walking trees.
- **It does not replace the analyzer.** Names, visibility and type checking stay where they are.

## How we will know it worked

- The exponential class of bug becomes unwritable: no query recomputes a type, because values have
  types.
- `llvm::` appears in exactly one directory.
- Every Polaron-specific rule has a pass that owns it, with its own tests, instead of living as a
  special case in the emitter.
- A malformed lowering is caught by `pir::verify` with a Polaron-shaped message, not by LLVM's
  verifier with `Function return type does not match operand type of return inst!`.
