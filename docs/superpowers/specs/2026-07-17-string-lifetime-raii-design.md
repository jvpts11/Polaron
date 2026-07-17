# String lifetime (scope-based RAII) — design

Status: **implemented (stage 1) — see "Shipped" at the bottom.** 538 CTest green; the 5 M-iter
String loop dropped 826 MB → 4.4 MB. The remaining increments (container-element freeing, tracking
method-call results, unwind-path release) are listed as follow-ups. The practical half (Forge stops
re-rendering when idle) shipped earlier. The rest of this doc is the original plan.

## The problem (measured)

`String` is a builtin `ptr → { i64 len, ptr data, i64 hash }`. The struct is `__ldp3_malloc`'d
(`codegen.cpp` `emitStringFromParts`) and the `data` buffer is a separate `__ldp3_malloc`. **Nothing
ever frees a String.** So every String literal-copy, concat, `toString`, `substring`, interpolation,
etc. leaks its struct + buffer.

Measured on a 20 M-iteration loop `String s = "row-" + i.toString();`: **3.3 GB** peak (~166 B/iter
= the `toString` temp + the concat temp, neither freed). A class object on the stack in the same
loop stays flat at 2.7 MB — **class RAII works; String has none.** This is why any long-running LDP3
program that builds Strings grows without bound, and why Forge grew just by rendering.

## Why it's not a one-liner (the codegen map)

Everything aliases; nothing copies:

- **Local decl** `String s = expr;` — plain pointer store (alias), no copy, not registered for
  scope-exit cleanup.
- **Assignment** (var / field / array element) — plain pointer store (alias); the old value is not
  freed.
- **Parameters** — plain pointer store = **borrow** (the callee does not own its String params).
- **Return** — plain pointer return; the caller owns it. `emitScopeCleanup()` runs *before*
  `CreateRet` but the return value is already materialized, so freeing a returned local would be a
  use-after-free (must exempt, like `escapingLocals_`).
- **Containers** — `ArrayList<String>` stores into `T[]` via a plain pointer store; `delete arr`
  frees only the backing block, never the elements.
- **Not-owned Strings that must never be freed**: string literals (their struct+data are `.strobj` /
  `.strdata` **globals**, not malloc'd — freeing panics/corrupts); `argv[i]` / `Env` / exe-path /
  `udpPeerHost` (wrap a **borrowed** cstr); `.toString()` on a `String` (**identity** — returns the
  receiver); the `mutable string` copy via `coerce` (a fresh struct that **shares** the source's data
  buffer).

The runtime `__ldp3_free` **panics on double-free** — so a wrong RAII scheme fails loudly in the
tests rather than corrupting silently. Good for iterating.

## The invariant we want (value semantics for String)

> Every owning location (local, field, array element) holds a String it **uniquely owns** and frees
> exactly once; temporaries are freed at the statement boundary; borrows (params) never free; literals
> and borrowed-cstrs are never freed.

Reaching it requires **copy-on-store everywhere** (so the source can be freed while the destination
keeps its own copy) plus **free-temporaries** and **free-owned-locals/elements**. The copy is what
makes freeing safe; without it, freeing a temp that was aliased into a slot/container is a UAF.

## Primitives (small, already prototyped once)

- `emitStringCopy(v)` → fresh struct + fresh buffer with the same bytes (owns its data). Null-safe.
  Turns any source (literal global, shared-buffer copy, temp) into a fully-owned String.
- `emitStringFree(v)` → `__ldp3_free(data)` then `__ldp3_free(struct)`. Null-safe. Only ever called
  on values we own.

## Ownership tracking

- Mark the results of the **fresh-malloc producers** as owned temporaries: `+`, `.concat`,
  `.substring`, `.toUpper/.toLower/.trim/.repeat`, `$"..."`, `int.toString`, `Decimal.toString`, and
  the owned read builtins. **Not**: literals, var/param/field refs, `.toString()`-identity, and the
  borrowed-cstr producers (argv/Env/exe/udpPeerHost).
- Track each `(value, creating-block)`. At a statement boundary, free the ones created in the current
  block (they dominate); drop (leave leaked, never free) ones from a conditional arm (ternary /
  short-circuit) so a value that may not have been created is never freed.
- **Untrack on escape**: a temp stored into a slot/field/array, passed as a call argument, or
  returned is removed from the free list so it is never freed while still referenced. A *missed*
  escape site can therefore only re-leak; a *wrong* free trips the double-free guard in the tests.

## Increments (each gated on the full CTest suite + the 3.3 GB leak test + Forge idle memory)

1. **Temp-slice (safe, self-contained):** track producers, free at statement boundaries, untrack on
   every escape. Frees intermediate concat/substring inputs and fully-discarded expression
   statements. No copy, no scope machinery. Low risk; modest impact (does not free anything aliased
   into a slot/call/container). Ship first to prove the tracking.
2. **Copy-on-store + free owned locals:** var-decl init and var/field/array assignment deep-copy the
   value; owned String locals register for scope-exit free (mirror `scopeObjects` /
   `emitBlockCleanup`); `return` copies and exempts. Frees the loop-local case fully (the 3.3 GB
   test → flat). Needs care: first-store into an uninitialized slot must not free garbage (null-init
   slots), and the container generic store (`this.data[i] = item`, `T = String`) must copy for
   `add`-then-free to be safe.
3. **Container element freeing:** `delete String[]` frees each element; String fields freed at object
   destruction. Fixes long-lived container leaks and the Forge per-frame `list.add(concat)` churn.

## Validation

- Full `ctest` (currently 538) green after every increment.
- The 20 M-iter String loop drops from 3.3 GB to flat.
- Build Forge with the new compiler; `Forge.exe test` green; idle-window memory stays flat *and*
  active-editing memory stops climbing.
- Consider an AddressSanitizer build of a String-heavy program to catch any UAF the double-free guard
  misses.

## Already shipped (the practical half)

`Forge` no longer repaints every frame — only on input, mouse movement, scroll/resize, or a change in
background state; after ~1.2 s idle it stops repainting entirely. Measured: idle window flat at
~214 MB instead of climbing. This removes the *observed* growth without touching String semantics;
the increments above remove the *cause* so any LDP3 program (not just Forge) stops leaking Strings.

## Shipped (stage 1 — 2026-07-17)

Implemented in codegen, restricted to the **immutable `String`** (the mutable `string` keeps its own
`coerce`/append lifecycle and shared data buffer, which this scheme must not double-free):

- Runtime `__ldp3_str_copy` / `__ldp3_str_free` as single calls (so codegen never splits a block to
  null-check). The four str helpers (`upper`/`lower`/`trim`/`repeat`) now allocate through
  `__ldp3_malloc` so the same allocator frees them.
- **Owned-temporary tracking**: every fresh-malloc producer (`+`, `.concat`, `.substring`,
  `.trim`/`.repeat`, `.toUpper`/`.toLower`, `$"..."`, `int`/`Decimal` `.toString`) is tracked and
  freed at the statement boundary and after `if`/`while`/`for` conditions; conditional-arm temps
  (wrong block) are dropped, never freed.
- **Copy-on-store**: var-decl init and identifier/field/element assignment deep-copy, so the owner is
  unaliased. A tracked local also frees its previous copy on reassignment (sound because copy-on-store
  keeps it a fresh, unshared, heap buffer).
- **Free owned locals at scope exit** (mirrors `scopeObjects` in `emitBlock` / `emitBlockCleanup` /
  `emitScopeCleanup`); `break`/`continue` deliberately skip it (the outer/function exit frees them, so
  no double-free). **Copy-on-return** so the caller receives an owned String outliving the frame.
- Tracking sets reset per function and saved/restored across lambda bodies, so a slot never leaks
  into another function's cleanup (this was a real cross-function-use IR-verifier crash caught in
  iteration).

Also fixed a **latent `StringBuilder.appendChar` heap overflow** this exposed: it wrote a char via an
untyped `Memory.write` (defaults to int, 4 bytes) while advancing the count by 1, spilling 3 zero
bytes past the buffer. Dormant until String structs were allocated in that adjacent memory (the
spilled zero overwrote a block-header magic byte → `csv_writer` heap corruption). Now writes one byte.

Result: 5 M-iter String loop 826 MB → 4.4 MB; 538 CTest green.

## Shipped (stage 2 — 2026-07-17)

The Forge render leaked ~12 k Strings **per frame** (90.7% of all allocations never freed). Measured
with a new env-gated allocation profiler in the runtime (`LDP3_MEMPROF`: net live-bytes + a size-class
histogram of the still-live set at exit — kept STL-free so it compiles with the bundled clang). The
render's churn is dominated by **method-call results returning String** (`document.line(i)`,
`renderLine(r)`, breadcrumb/status/tab helpers): every user method copy-on-returns an owned String, but
a discarded/consumed *call result* was never registered as a temporary, so stage 1 (which only tracked
the ~8 builtin producers) left them all leaking.

- **Track user-method String results**: at the single `emitExpr(CallExpr) -> emitCall` choke point, a
  call that resolves to a user-defined method / enum method whose declared return type is `String`
  registers its result as an owned temporary (`callReturnsOwnedUserString`). Freed at the statement
  boundary; stores (copy-on-store) and returns (copy-on-return) copy first, so a still-referenced String
  is never freed. **Whitelisted by user-method resolution**, so borrowed-String builtins (`.toString()`
  identity on a String, `Env`/`Net` cstr wrappers) and the self-tracking String producers never match
  and are never double-freed.
- **Copy-on-return keys on the declared return type too** (`currentRetTypeName_`, threaded through
  `emitBody`): `return "literal"` (a `string`-typed expression) from a `returns String` method now hands
  back an owned copy. Without this, stage 2's free would call `libc free()` on a string-literal global
  and corrupt the heap (found via 4 CTest failures exiting `0xC0000374`).

Result: Forge render-only (2000 frames) **1038 MB → 31.6 MB** live (33× fewer bytes leaked; 90.7% →
3.3% of allocations unfreed). Isolated 5 M-call leak test flat. 538 CTest green; Forge self-test 398.

### Follow-ups (stage 3)

- **Container element freeing**: `delete String[]` frees each element; String fields freed at object
  destruction; `this.data[i] = item` (generic `T = String`) copies. This is the bulk of the ~16 kB/frame
  Forge residual (e.g. `Breadcrumbs.trail()` returns an `ArrayList<String>*` whose elements leak).
- Track **computed String property getters** (read as a `MemberExpr`, not a `CallExpr`) and the
  remaining `System.*` `emitStringFromParts` producers (Env / exe-path / Process / Regex / split).
- **Free String locals on the exception-unwind path** (currently they leak on a throw that unwinds
  through them — bounded and rare, but the unwind pad should release them like `scopeObjects`).
- Free the **old value on field/array-element reassignment** (M3), once field/element ownership is
  tracked; today the previous String there leaks.
- Optimisation: **move** an owned temp into a store instead of copy-then-free (removes one alloc+copy
  per string-producing initializer/assignment).
