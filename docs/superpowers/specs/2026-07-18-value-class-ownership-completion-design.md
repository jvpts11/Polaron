# Value-class ownership completion — design

Status: **design (not implemented).** The safe, shipped state is `7d6e905` (LDP3) + `dd99df4` (Forge):
the Forge render leak is **37× smaller** (1038 MB → 27.8 MB over 2000 render frames), the double-free
and `--debug`/DWARF root bugs are fixed. The **residual** leak this design targets is value-class
*container* values that are never destructed. Two in-session attempts broke collection tests; the root
is bigger than a patch, hence this spec.

## The problem

`String` has a complete value-ownership model in codegen (copy-on-store, copy-on-return, free owned
temporaries/locals, free on `delete String[]`). **Value classes (records, and the ptr-boxed classes like
`ArrayList<T>`) have only *half* of it**, so a value-class value can be silently *borrowed* where value
semantics says it should be *owned*:

- **copy-on-store** exists for an **lvalue** init/assignment (`T b = a;`, `obj.f = a;`, `arr[i] = a;` →
  `emitClassCopy`), and now (`7d6e905`) for an array-element **read** (`dst[i] = src[i]`).
- **destruction** runs only for a `new … on stack` local and an **lvalue-copy** local (`T b = a;`).
- **Missing:** a value-class local initialized from a **call** (`ArrayList<Span> spans = producer();`)
  is neither copied nor registered for destruction — it just holds the returned pointer and **leaks**.
  This is the entire Forge render residual: `renderSpans()` / `tokenize()` return `ArrayList<Span>` by
  value every frame and the caller never frees them.
- **Missing:** **copy-on-return** for value classes. `return this.field` / `return arr[i]` hands back the
  pointer to storage the callee still owns. Today that is harmless only because callers never destruct a
  call result; the moment they do, it double-frees.

So the two gaps are entangled: to free call-result containers you must destruct them, and to destruct
them safely every value-class return must be *owned*.

## Current mechanics (what the design must fit into)

- `isClassValue(t)` — a value class (excludes interface/abstract = reference types, Java-enum singletons).
- `isCopyDiscipline(t)` — a class that copies on assignment (not `movable`/`unique`).
- `emitClassCopy(cn, v, heap)` — deep copy: memcpy the struct, then `emitArrayDup` each array field
  (which **already deep-copies boxed value-class elements**) and recurse into value sub-objects; a
  `copyChain_` set breaks self-referential type cycles by sharing the cyclic sub-object.
- **Escape analysis** (`collectReturnedNames` → `escapingLocals_`): a local returned via
  `return identifier` is *moved* — its copy is forced onto the heap (`emitClassCopy(..., heap=true)`) and
  it is **excluded from scope-exit destruction** (the caller owns it). Only bare **identifier** returns
  are tracked; `return this.field` / `return arr[i]` / `return f()` are not.

## What the two attempts taught us

1. **Register call-result value-class locals for destruction** (drop the `isCopyableLValue` guard at the
   var-decl site) → **spatial_grid + bimap_multimap double-freed** (exit 70, caught by the no-UB guard).
   Confirms: some value-class method returns an *aliased* value; destructing the caller's local frees the
   callee's still-owned storage twice.
2. **+ copy-on-return for `member`/`index` returns** (`return this.field` / `arr[i]` → `emitClassCopy`)
   → still failed spatial_grid + bimap **and newly broke pointer_collections**. Confirms the aliasing is
   **not only** `this.field` / `arr[i]`: it flows through call chains, ternaries, and nested collections
   (`HashMap` buckets, `ArrayList<X*>`), so a narrow member/index copy is both insufficient (misses
   some aliased returns) and over-eager (a `pointer_collections` case it must not have copied).

**Conclusion:** this is one coherent feature — *generalize the String ownership model to every value
class* — not a set of local patches. Doing it piecemeal shifts the double-free around (the classic
"3+ attempts, failures move" architectural signal).

## Design: generalize the value-ownership model to all value classes

The invariant (mirrors String): **every owning location — a local, a field, an array element — holds a
value-class value it uniquely owns and destructs exactly once; a value returned by a method is always
owned by the caller; borrows (`T*`, `T&`, parameters used read-only) never destruct.**

Reaching it needs three coordinated pieces, each gated on the full suite + the leak test + Forge:

### Piece 1 — copy-on-return, keyed on ownership not syntax
Every `return <expr>` whose static type is a copy-discipline value class hands back an **owned** value:
- `return identifier` — keep the **move** (escape analysis promotes + skips destruction). No copy.
- `return this.field` / `arr[i]` / any expression that reads an existing owned location — **copy**.
- `return f()` / `return new T()` / other rvalues — already owned; no copy.

The clean predicate is *"does this expression evaluate to storage something else still owns?"* — i.e. an
lvalue that is **not** a moved-out local. Encode it as: copy unless the return expression is (a) a bare
identifier in `escapingLocals_`, or (b) a known-fresh rvalue (`new`, call, arithmetic). Everything else
copies. (The narrow attempt only copied member/index; it must also cover ternary/`?:`, `match`
expression arms, and safe-nav that resolve to owned locations.)

### Piece 2 — destruct owned call-result / rvalue value-class locals
At the var-decl site, register a value-class local for scope-exit destruction whenever it **owns** its
value and does not itself escape: lvalue-copy inits (already), **and** call-result / rvalue inits (new).
`new … on heap` stays manual (the NewExpr branch). Reconcile with the escape analysis so a returned
local is destructed-or-moved but never both (today move; keep move for identifiers).

### Piece 3 — the deep-copy must be provably complete for every container shape
`emitClassCopy`/`emitArrayDup` already deep-copy boxed value-class array elements, but the failures imply
a gap for **maps/sets** (bucket arrays of node objects, `HashMap`/`TreeMap`) and for **collections of
pointers** (`ArrayList<X*>` must copy the backing but **share** the `X*` elements — borrowed). Audit and
close: a copy of a container must duplicate exactly what the container owns and share exactly what it
borrows, matching Piece-1/2's destruction.

## Test matrix (the gate — build all before trusting green)

A dedicated `tests/samples/value_ownership_*.ldp3` grid, each compiled + run under `LDP3_MEMPROF`:
`return this.field`; `return arr[i]`; `return local` (move); `return f()`; ternary/`match` return; copy
then delete both; nested `ArrayList<ArrayList<T>>`; `HashMap`/`TreeMap`/`HashSet` build→return→destruct;
`ArrayList<X*>` (borrowed elements must NOT be freed); a value-class field on a copied+deleted object;
the 5 M-iter container-churn leak test (must be flat). Plus the whole 538 CTest + Forge 398 + the render
leak (must drop from 27.8 MB toward flat) on **every** phase.

## Phasing

1. **P0 — test matrix first** (red): write the grid above; several must currently leak or double-free.
2. **P1 — copy-on-return** (Piece 1) alone: returns become owned; nothing destructs call-results yet, so
   the suite must stay green (no behavior change, just extra copies) — proves the copy is correct.
3. **P2 — destruct call-results** (Piece 2): now safe because P1 made returns owned. The matrix +
   spatial_grid/bimap/pointer_collections must go green; the render leak must drop.
4. **P3 — deep-copy completeness** (Piece 3): fix any map/set/pointer-collection copy gap P2 surfaces.
5. **P4 — move optimization**: elide copy-then-free where an owned temporary is stored/returned (perf).

## Risks & mitigations

- **UAF the no-UB guard misses.** The double-free guard catches double frees loudly, but a *borrow*
  wrongly copied (breaking identity) or a use-after-move would not always trip it. Mitigation: the
  explicit test matrix + an AddressSanitizer build of the container-heavy matrix.
- **Perf.** Copy-on-return adds a deep copy per aliased return; P4 (move) recovers the common case.
- **Scope creep.** This is value-semantics for containers, not just Forge. Land it phased, each phase
  independently green, so it can pause between phases.

## Not doing

- Rewriting Forge to pass containers by pointer everywhere — fights the language's value semantics and
  ripples to 9+ sites; the compiler is the right layer.
- Blindly re-attempting the narrow patch — it demonstrably shifts the double-free.

## Implementation log (2026-07-18, session 2)

Root-caused and shipped the *dominant* value-class leak, which turned out NOT to be call-result
containers (this doc's original focus) but **value-class arguments**:

- **SHIPPED (`19a42f5`) — free `new T() on heap` value-class arguments.** A value-class parameter is
  deep-copied at callee entry (emitBody) and never retains the caller's argument, so the pervasive
  `list.add(new T() on heap)` idiom leaked one element temporary per call — this was ~170 leaked Span
  objects/frame in Forge, the whole per-frame growth. Fix: at method/virtual/ctor call sites, destruct
  a `new … on heap` value-class argument after the call, gated on the parameter being a by-value
  copy-discipline class (T*/T&/interface/movable/unique excluded — they borrow or transfer). Safe
  because a fresh `new` temporary has no aliases. **Zero perf** (byte-identical IR on matmul/primes/
  regions), 538 CTest + Forge 398 green. Forge render-only 2000 frames **14.8 MB → 4.2 MB live**;
  per-frame growth 170 → ~7 value-class objects. (Total from the string-RAII start: 1038 MB → ~2.5 MB.)

- **TRIED then REVERTED (`815afad` → `060a5bc`) — destruct by-value parameter copies at callee exit.**
  Correct value semantics and fixes a real per-call leak of the copy's owned heap content (e.g. an
  `ArrayList<String>` param copies its backing + every String, then dropped them). IR-verified, 538
  CTest green — **but it segfaulted Forge's editor-core self-test deterministically.** Root: it turns a
  previously-silent leak into a **use-after-free**. Code that returns a pointer/reference into a
  by-value value-class parameter (a pointer into the copy's backing) was kept valid only by the leak;
  freeing the copy makes that returned pointer dangle. This is a latent dangling-pointer bug the leak
  masked. Shipping the param-copy free bare turns silent-leak into crash for any such code (the sim
  would hit it too). **It needs a companion: compile-time escape checking that rejects returning a
  pointer/ref into a by-value parameter** (an escape analysis for pointers), done together with
  copy-on-return. Folded into this doc's coordinated work; do not re-ship standalone.

- **SHIPPED (Forge `5abde27`) — free per-file readLines/symbol lists in project symbol indexing.**
  `refreshProjectSymbols`/`openWorkspaceSymbols` leaked the whole `Files.readLines(path)` result, the
  per-file `ArrayList<Symbol>`, and the `tree.allFiles()` list, per file, on project open/save. These
  are call-result / fresh-pointer temporaries the caller owns — deleted them explicitly. Startup symbol
  index footprint 3.7 → 2.0 MB.

### Revised understanding of the residual (~13 objects/frame after `19a42f5`)

MEMSITE (debug build, slope-isolated at 3000 frames) pins the *remaining* per-frame growth to a
long tail of ~13 distinct sites each leaking exactly 1/frame, all under `GuiApp.drawFrame`:
1. **Forge-side per-frame `new X() on heap` / call-result pointers never deleted** — e.g.
   `Brackets.none()`/`matchingBracket()` returning a fresh `Match*` (`GpuScreen.ldp3:1390`), and
   other draw-path temporaries. These are genuine manual-memory misses (LDP3 is manual for `T*`); fix
   Forge-side by deleting them, OR (better, general) by the coordinated ownership work below.
2. **Compiler String residual (E)** — `str_copy`'d Strings from the draw path that RAII doesn't yet
   track: computed String property getters (read as MemberExpr, not CallExpr) and a few `System.*`
   producers. A String-RAII follow-up.

### Sequencing decision (session 2)

The safe, perf-neutral, self-contained wins are shipped. The remaining pieces are the coordinated
value-class-ownership feature — and it now clearly needs a **fourth piece** the original doc missed:

- **Piece 0 (new) — escape checking for pointers into by-value parameters/locals.** Reject (or copy)
  `return &param` / `return param.elementPtr()` where the pointer escapes a by-value value-class
  parameter or a local that will be destructed. Without it, destructing param copies / call-result
  locals (Pieces 2) turns latent dangling pointers into crashes. This is the blocker the reverted
  `815afad` proved is real.

Order: Piece 0 (escape checking) → Piece 1 (copy-on-return) → Piece 2 (destruct param copies +
call-result locals) → Piece 3 (deep-copy completeness) → Piece 4 (move opt to keep perf). Each phase
gated on the full CTest suite + the Forge 398 self-test + the render leak measurement. This is a
dedicated multi-phase effort, not a tail-of-session patch.

## Implementation log (2026-07-18, session 3) — drove the residual 182 → ~2 objects/frame

Continued past the value-class-arg fix; the *String* side of the same value-ownership problem carried
most of the remaining Forge per-frame growth. All shipped fixes: repro flat under LDP3_MEMPROF, 538
CTest, byte-identical benchmark IR (zero perf), Forge 398 green.

- **`a80d6dc` — M3 for String fields/elements** (task #130). Reassigning a String field/array element
  leaked the previous value; now freed first. Made null-safe by **null-defaulting owned-type fields
  (String / value class / array) that lack an inline initializer** in the constructor prologue (malloc
  does not zero, so the first free would hit garbage). Borrowed `T*`/`T&` fields are left alone.
  Value-class field/element M3 stays deferred (aliasing — Piece 3 territory).
- **`67d0940` — owned String temporaries in ternary arms.** `cond ? path : path.substring(...)` (the
  `Paths.basename` shape, ~8 calls/frame in the draw path) created the substring in the arm block, which
  the merge-block `freeStringTemps` dropped and leaked. Each String-ternary arm is now copied to a fresh
  owned String with its producer temps released in-arm; the merge phi is one owned temp. This one fix
  took the residual from 10 → 2 objects/frame.
- **Forge-side `5abde27` / `6dcf2d0`** — freed the per-file symbol-index temporaries and the per-frame
  bracket `Match*`.

**Result: Forge render-only is essentially flat — 6000 frames = 2.1 MB live, +0.2 MB over 5800 frames
(~2 objects/frame, ~0.06 KB/frame).** From the string-RAII start that is ~1038 MB → ~2 MB; the per-frame
growth rate is ~57,000× below the original "80→300 MB/min" report. The last ~2/frame is a subtle String
temporary in the per-frame draw prologue (trackNav/pump path) — negligible, and it belongs to the same
coordinated work (copy-on-return / property-getter tracking) above rather than another point patch.
