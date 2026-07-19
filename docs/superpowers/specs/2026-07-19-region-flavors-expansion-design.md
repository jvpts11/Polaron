# Region flavors expansion — design

Status: **approved design (not implemented).** Approved by João 2026-07-19. Implement the *complete*
region model (all flavors + operations), not a terminal-specific patch — no accumulated debt.

## Motivation

`delete x from region R` runs the destructor but never reclaims the slot (bump allocator; reclaimed
only on `release`). Trying to close individual terminals from a region exposed that regions have **only
one allocation strategy** (bump) and are **missing the operation to take an object back out** (extract).
Rather than special-case terminals, this adds the full region model: a **flavor axis** (reclaim
strategy) plus the **operations** every arena/pool discipline needs, so regions work correctly for any
future program (the simulation flagship especially).

Guiding constraint: **no exploitable UB, rich diagnostics, zero regression to the bump fast-path.**
Bare `region` stays exactly what it is today (bump), so all existing code is unchanged.

## The complete region model (orthogonal axes)

A region is described by several independent properties that compose:

| axis | values | status |
|---|---|---|
| **reclaim strategy (flavor)** | bump · pool · stack · fixedslot · ring | **new** (bump = current) |
| growth | fixed · `growable` | `growable` new |
| placement/backing | `itself.allocate(N)` · `itself.at(addr,size)` · `itself.atMultiple({})` | exists |
| lifetime/access (universal prefixes) | `eternal` · `lazy` · `volatile` · `final` | exists, compose |
| type filter | `.accepts({...})` · `.rejects({...})` | exists |

### Flavor semantics + runtime allocator

- **bump** (linear/monotonic) — *current behavior, unchanged.* Allocate by advancing a cursor. No
  individual free. `release`/`clear` frees/resets everything. Fastest allocation. Use: allocate-many,
  free-together (parse trees, per-frame simulation objects). Backing = one block (`__ldp3_region_acquire`).
- **pool** (segregated free-list) — per-size-class free-list over the region block. `new … in R` pops a
  free slot of the right class or bumps a new one; `delete … from R` / `extract` push the slot back on
  its class list; a later `new` reuses it. Pointers never move (raw `T*` stay valid). Slightly slower
  alloc than bump; possible fragmentation across size classes. `release` frees the whole block O(1). Use:
  churn of mixed sizes (terminals, entities).
- **stack** (LIFO) — bump allocation plus `mark`/`rollback`: `mark of region R` records the cursor;
  `rollback region R to m` runs destructors for everything allocated after `m` (in reverse) and resets
  the cursor to `m`. Reclaim without a free-list, but only in reverse order. Use: nested scopes,
  per-request/per-frame checkpoints.
- **fixedslot** (single-size pool) — a pool specialised to **one** slot size, taken from a **single
  accepted type** (`accepts({T})` is *required*). All slots identical → O(1) alloc/free, zero
  fragmentation, one free-list. Use: homogeneous churn (a `Particle` pool, an all-`Terminal` region).
- **ring** (circular buffer) — fixed capacity of same-purpose entries; when full, a new allocation
  **overwrites the oldest** (its destructor runs first). No individual `delete` (auto-evicting). Use:
  bounded history/streaming (recent log lines, an event ring).

### Growth

- **fixed** (default) — a full region traps (no-UB) with a clear diagnostic.
- **`growable`** — on overflow the region **chains another block** (a linked list of blocks); allocation
  stays amortised O(1); `release` frees the whole chain. Composes with bump/pool/stack/fixedslot. It is
  **contradictory with `ring`** (ring is bounded by definition) and with **`at address`** (foreign
  memory cannot grow) → compile error.

## Keywords and grammar

All new words are **contextual (soft) keywords** — they are keywords only in their region position and
remain valid identifiers everywhere else (verified: `pool`, `bump`, `stack`, `grow`, `mark`, `ring`,
`growable`, `extract` are already used as identifiers/method names in existing LDP3 code, so hard
reservation would break it). Bare `region` = bump (backward compatible).

**Flavor + growth modifiers** — contextual, immediately before the `region` keyword:
```ldp3
region R           = itself.allocate(64 kilobytes);                       // bump (default)
bump region R      = itself.allocate(64 kilobytes);                       // explicit bump
pool region R      = itself.allocate(64 kilobytes);                       // free-list reclaim
stack region R     = itself.allocate(64 kilobytes);                       // LIFO mark/rollback
fixedslot region R = itself.allocate(64 kilobytes).accepts({Terminal});  // single-size pool (accepts required)
ring region R      = itself.allocate(64 kilobytes).accepts({LogLine});   // circular, auto-evict
growable pool region R = itself.allocate(64 kilobytes);                   // grows on overflow
```
Grammar: `region-decl := [ 'growable' ] [ flavor ] 'region' NAME [ '=' region-init ] ';'`
where `flavor := 'bump' | 'pool' | 'stack' | 'fixedslot' | 'ring'`. The parser recognises a flavor/`growable`
token only when the (possibly next) token is the `region` keyword; otherwise it is an ordinary identifier.
Universal prefixes still precede everything: `public eternal lazy growable pool region cache = …`.

**Operations** — contextual operators:
```ldp3
Terminal* t = extract terminals[i] from region R;   // relocate to heap, untrack, reclaim slot if pool/fixedslot
checkpoint m = mark of region R;                     // stack only: record the cursor
rollback region R to m;                              // stack only: destruct + reset to the mark
```
`extract` parses like `move` (a prefix operator on an lvalue) but is **RHS-only**: its result transfers
ownership to the caller and MUST be bound to a variable/field — a bare `extract …;` statement would leak
the relocated object and is a compile error (LDP3-1720). `checkpoint` is the one **new built-in type**
(an opaque cursor handle; copyable, no destructor).

**Introspection** — plain methods, no keywords: `R.used()`, `R.capacity()`, `R.remaining()`,
`R.contains(ptr)`, `R.grow(N bytes)` (explicit grow on a `growable` region). `grow` is deliberately a
method, not a keyword (28 identifier conflicts).

**Unchanged and still valid on every flavor:** `itself.allocate/at/atMultiple`, `.accepts/.rejects`,
`new X in region R`, `delete X from region R` (now reclaims on pool/fixedslot; LIFO-only on stack;
rejected on ring), `move X from/to/into region`, `release region R`, `.clear()`, `snapshot of region R`,
`of region X`, empty-state regions, region-copy assignment.

## Operation semantics + interactions

- **`new X in region R`** — dispatch to the flavor's allocator. fixedslot/ring require `R` to accept a
  single type; allocating a non-accepted type is the existing accepts/rejects error.
- **`delete X from region R`** — runs the destructor + drops RAII tracking (as today) and additionally:
  pool/fixedslot → return the slot to the free-list; bump → no reclaim (unchanged); stack → allowed only
  if `X` is the top allocation (else a diagnostic suggests `rollback`); ring → rejected (ring auto-evicts).
- **`extract X from region R`** — deep-relocate `X` to a fresh heap allocation, return it (owned by the
  caller — `delete` it or bind it to a value/`T*` with normal RAII), drop it from `R`'s tracking so
  `release` won't destruct it, and mark the source variable **moved** (use-after-extract = compile
  error, mirroring `move`). On pool/fixedslot the vacated slot is reclaimed; on bump it is dead until
  release (allowed, no error — extract is still the correct "promote out" op there). An object whose
  fields point **into the same region** cannot be safely extracted alone → diagnostic (extract the graph
  or use `move` between regions). Owned heap fields (String, ArrayList backings) travel fine.
- **`mark`/`rollback`** — stack flavor only. `rollback` runs destructors newest-first for objects above
  the mark. A `checkpoint` from another region used in `rollback region R to m` → diagnostic.
- **`move X from region A to region B`** — unchanged; when B is pool/fixedslot the destination slot comes
  from B's free-list; when A is pool/fixedslot A's slot is reclaimed.
- **`release`/`.clear()`** — flavor-independent: destruct all live objects, free/reset the block(s).

## Rich diagnostics (first-class requirement)

Every malformed region use gets the project's standard rich diagnostic (code `LDP3-17NN`, `why:` /
`fix:` / `prevent:`, snippet + caret), routed through `diag::classify` like the rest of the compiler.
The semantic phase (`analyzer.cpp`, near the existing region checks ~1911/2379) validates:

| code | condition | message → fix |
|---|---|---|
| LDP3-1710 | two flavors (`pool stack region`) | "a region has exactly one flavor" → keep one |
| LDP3-1711 | `fixedslot`/`ring` without `.accepts({T})` of exactly one type | "a fixedslot/ring region needs its single element type" → add `.accepts({T})` |
| LDP3-1712 | `growable ring` / `growable` + `at address` | "growable is contradictory with ring / a mapped region" → drop one |
| LDP3-1713 | `mark`/`rollback` on a non-stack region | "mark/rollback need a `stack region`" → declare it `stack` |
| LDP3-1714 | `rollback` with a checkpoint from another region | "this checkpoint belongs to region X" → roll back the region it came from |
| LDP3-1715 | `delete … from region` on a ring region | "a ring region auto-evicts; individual delete is not allowed" |
| LDP3-1716 | non-LIFO `delete … from region` on a stack region | "a stack region frees in reverse; use rollback to a mark" |
| LDP3-1717 | use of a variable after `extract` | "extracted on line N; the region no longer owns it" (mirrors move) |
| LDP3-1718 | `extract`/`delete from` of an object with fields allocated in the same region | "its field F lives in the same region" → extract the graph / use move |
| LDP3-1719 | flavor modifier on a non-region declaration | "pool/stack/… only qualify a region" |
| LDP3-1720 | `extract` result not bound (bare statement) | "extract transfers ownership; bind its result" |

(Existing region diagnostics — unknown region, not-a-region, accepts/rejects — are unchanged.)

## Compiler + runtime architecture

- **Lexer/parser:** recognise the contextual flavor/growth words before `region`, and `extract`/`mark`/
  `rollback`/`checkpoint`. AST: add `flavor` + `growable` to the region VarDecl; a `RegionOpStmt`/expr
  for extract and rollback; `mark` as an expression; `checkpoint` as a built-in type.
- **Semantic (`analyzer.cpp`):** track each region variable's flavor; run the LDP3-17NN validations;
  flow-track `extract`'d variables as moved (reuse the `move` machinery).
- **Codegen (`codegen.cpp`):** generalise `emitRegionBumpAlloc` → `emitRegionAlloc(flavor, …)` dispatching
  to the right runtime call; `new in R`, `delete from R`, `extract`, `mark`/`rollback`, `release` route
  by flavor. `extract` = heap alloc + deep copy out + untrack + (pool/fixedslot) free the region slot.
- **Runtime (`ldp3_rt.cpp`):** one region descriptor `{ blocks, cursor, flavor, freelists[], slotSize,
  ring state }`. New C functions alongside `__ldp3_region_acquire/release`:
  `__ldp3_region_new(desc, size)` (flavor-aware bump/pool/fixedslot/ring), `__ldp3_region_free(desc, ptr)`
  (pool/fixedslot free-list push), `__ldp3_region_mark/rollback(desc)` (stack cursor),
  `__ldp3_region_grow(desc)` (growable chain). The existing segregated free-list allocator (the
  `LDP3_SLAB` machinery) is the model for the pool free-lists. No-UB: overflow of a fixed region and
  every misuse traps via `__ldp3_panic` with a message, never silent corruption.

## Forge 0.2 update

Forge must understand the expanded region grammar so it lints/highlights it live:
- **Highlighter / VS Code grammar:** add `bump pool stack fixedslot ring growable extract mark rollback
  checkpoint` as region keywords (contextual colouring).
- **LSP (`ldp3-lsp`) / live check:** the expanded compiler is the checker, so region-flavor diagnostics
  (LDP3-17NN) surface in Forge automatically; add the new keywords to import/keyword autocomplete.
- **Version bump to 0.2** in `ldp3.toml` / about box once the grammar lands.
- Regenerate the bundled stdlib/keywords reference so Help shows the new region model.

## Backward compatibility

Bare `region` is bump — byte-identical to today. The new words are contextual, so no existing program
changes meaning. Existing region tests must stay green unchanged.

## Test matrix

A `tests/samples/region_*` grid, each compiled + run (several under `LDP3_MEMPROF` to prove reclaim):
per-flavor alloc/free; pool reclaim reuse (churn stays flat); fixedslot O(1) + accepts-required error;
stack mark/rollback (destructors run newest-first); ring overwrite-oldest; growable chaining past one
block; `extract` to heap (+ reclaim on pool, dead-slot on bump); every LDP3-17NN diagnostic (a
`should-fail` case each); `move` between flavored regions; `release` of each flavor; interaction with
`eternal`/`lazy`/`volatile`/`at address`. Plus the full CTest suite + Forge 398 self-test green on every
wave.

## Implementation waves (each independently green: CTest + Forge)

1. **Foundation + pool + extract.** Flavor axis in lexer/parser/AST/semantic; runtime region descriptor;
   `bump` (refactor current) + `pool` (free-list) + `extract` + `delete from` reclaim on pool; the
   LDP3-17NN diagnostics for these. Closes the original gap (terminals can be a pool region).
2. **stack + growable.** `mark`/`rollback` + `checkpoint`; `growable` chaining; their diagnostics.
3. **fixedslot + ring.** single-size pool; circular buffer + auto-evict; their diagnostics.
4. **Forge 0.2.** Highlighter + LSP keywords, version bump, reference regen; dogfood: terminals move to a
   `pool region`.
5. **Docs + spec.** Fold the model into `docs/LDP3_specification.md` §17; memory + keyword catalogue.

## Risks & mitigations

- **Perf regression to bump.** The flavor dispatch must not touch the bump fast-path — keep bump codegen
  byte-identical (verify with the benchmark IR diff, as with the leak fixes). Mitigation: bump is a
  distinct path, not a special case of pool.
- **Free-list correctness / no-UB.** Double-free, cross-region free, use-after-extract must all trap
  loudly (reuse the existing `__ldp3_check_live` / poisoning discipline), never corrupt.
- **Scope creep.** Five flavors is a lot; the waves keep each shippable and green so it can pause between.

## Not doing (now)

- Compacting/moving regions (breaks raw `T*`; needs handles/GC — against the model).
- `partitionable` (spec §19) integration beyond what exists — separate feature.
- Automatic flavor inference — the flavor is always explicit (bare = bump).
