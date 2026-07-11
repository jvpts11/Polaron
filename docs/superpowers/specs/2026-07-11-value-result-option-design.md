# Value `Result<T,E>` and `Option<T>` — design

**Status:** approved (João, 2026-07-11) — "value Result + Option together, in slices."
**Motivates:** E5 of the anti-Muratori benchmark protocol. `Result<int,int>*` is a heap sum type today;
`Ok(i)` allocates per call, so a hot always-Ok loop is 7.6× a plain return. The IR confirms the callee is
inlined and the `Result` does not escape, but the pooled allocator isn't attributed for LLVM to fold, and a
heap-to-stack promotion would leave the no-UB double-delete guard reading a stack pointer. The real fix is a
representation change, decided here.

## Goal

Make `Result<T,E>` (and `Option<T>`) a **value type** — a small tagged union passed in registers, like Rust
`Result` / C++ `std::expected` — so `Ok(x)`/`Err(y)` allocate nothing, `match` reads a tag, and there is no
`delete`. It must **beat the error-code baseline** on the E5 hot loop, with checksums identical.

## The compatibility hinge: the `*` already distinguishes the two forms

Today `Result<T,E>` is a `sealed abstract class permits Ok, Err` (prelude), and code uses `Result<T,E>*`
(pointer to the heap object) — **15 of 16 sample uses carry the `*`**. So the split is natural and breaks
nothing:

| Spelling | Today | After |
|---|---|---|
| `Result<T,E>` (no `*`) | ~unusable (abstract class by value) | **NEW: value** `{ i32 tag, payload }` — registers, no heap, no `delete` |
| `Result<T,E>*` (with `*`) | heap: `new Ok on heap` + `delete r` | **unchanged** — for storing/sharing/returning a boxed variant |

Same for `Option<T>` (value) vs `Option<T>*` (boxed). Existing `Result*`/`Option*` code compiles and runs
identically; new code drops the `*` to get the fast value form.

## Representation

`Result<T,E>` value → LLVM `{ i32 tag, [P x i8] }`, `P = max(sizeof(T), sizeof(E))`, alignment
`max(align(T), align(E))`. `tag`: `0 = Ok`, `1 = Err`. `Option<T>`: `0 = Some`, `1 = None` (None carries no
payload; `P = sizeof(T)`). Small (≤16 bytes) → passed/returned in registers; larger → sret (reuse the
struct-return path already used for value `struct`s). `T`/`E` that are reference types (String, class ptr)
store a pointer in the payload — same as any value struct field.

## Lowering, per stage

- **Parser** (`rewriteVariantCtor`, parser.cpp:1611). Today it rewrites `Ok(x)` → `new Ok<...> on heap`
  against the expected type. Change: when the expected type is the **value** form (a `Result`/`Option` type
  with no `*`), rewrite to a new **`VariantValueExpr { base: "Result"|"Option", variant, typeArgs, arg }`**
  (or reuse `NewExpr` with `location = "value"`) instead of a heap `new`. The boxed form (`*`) keeps the
  `new ... on heap` path untouched. The expected type is already threaded in (`currentMethodReturnType_`,
  declared var type), so the `*`/no-`*` bit is available.
- **Analyzer.** Type a value `Result<T,E>`/`Option<T>` as itself (not a pointer); type-check `Ok`/`Err`/
  `Some`/`None` args against `T`/`E`; `match` over a value subject binds `Ok(T v)`/`Err(E e)` from the
  payload; exhaustiveness is unchanged (sealed → Ok+Err cover it, no default needed). `try?` on a value
  `Result`/`Option` requires the enclosing method to return a matching value `Result`/`Option` (or the boxed
  form — allow both).
- **Codegen.** New: a value tagged-union LLVM type per monomorphized `Result$T$E` / `Option$T` **when used
  by value**. `emitVariantValue` builds `{tag, payload}` in an entry alloca (or as an aggregate). `match`
  over a value subject: load `tag`, switch, reinterpret payload as `T`/`E` for the binding. `return` of a
  value variant: small → return the aggregate; large → store through the sret pointer. `delete` applied to a
  value `Result`/`Option` is a **no-op** (with a soft warning: values don't need it) — keeps mixed code
  compiling during migration. `try?` on a value: load tag; if Err/None, construct the enclosing method's
  value result carrying the same payload and return it.

## Slices (each: sample + e2e test + full CTest green)

1. **Value representation + construct + match (scalars).** `Result<T,E>`/`Option<T>` value types for scalar
   `T,E`; `Ok/Err/Some/None` build a value; `match` reads it; return by value (small, register). Test: the
   E5 loop pattern (`Result<int,int> r = f(i); match(r){...}` — **no `delete`**) compiles, runs, checksum
   matches the boxed version, and the IR shows **no `__ldp3_malloc` in the loop**.
2. **`try?` on values + larger payloads (sret) + reference `T`/`E`.** `f()?` early-returns the Err/None
   value; `Result<String,int>` etc.; payloads > 16 bytes via sret.
3. **Compat + interop sweep.** `Result*`/`Option*` still work everywhere (regression); `Task<Result<...>>`
   value across `await`; nested `Result<Option<int>, E>`; `delete` on a value is a no-op with a warning.
4. **Benchmark + docs.** Re-measure E5 (value `Result` vs error-code vs boxed) → expect a win; update the
   protocol RESULTS.md; update spec §21 to document value-vs-boxed and the `*` rule; memory.

## Risks / open questions (resolve during implementation, ask João if genuinely forked)

- **Monomorphized name collision.** `Result$int$int` names the boxed class today; the value form needs its
  own LLVM struct type without clobbering the class. Use a distinct type handle (e.g. keep the class for the
  boxed form, add a parallel value-struct type keyed the same name) selected by whether the use is starred.
- **`match` default rules.** A sealed value `Result` without a default must still be exhaustive (Ok+Err);
  reuse the existing sealed-exhaustiveness check.
- **Async.** `Task<Result<int,int>>` (value payload) must survive the await state-machine spill — the value
  is a struct, spill it like any value struct.
- **`delete` on a value:** chosen as a no-op + warning (not an error) so partially-migrated code compiles.
- **`std` APIs returning `Result`.** Audit stdlib/prelude signatures: those returning `Result<T,E>*` keep
  the boxed form; consider migrating hot ones to value in a later pass (out of scope here).
