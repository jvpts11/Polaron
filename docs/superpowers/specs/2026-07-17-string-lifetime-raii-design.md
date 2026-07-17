# String lifetime (scope-based RAII) — design

Status: **designed, not yet implemented in codegen.** The practical half (Forge stops
re-rendering when idle, so it no longer grows) is already shipped. This doc is the plan for the
language-level half, to be implemented interactively with hard test gating.

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
