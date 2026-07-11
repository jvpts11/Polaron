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

## Slice 1 implementation notes (done)

Landed: value repr `{i32 tag, i64 payload}` (shared `__ldp3_variant`), `Ok/Err/Some/None` value construct,
statement + expression `match`, return-by-value; enum `parse()` (`emitOptionVariant` + the parse slot)
migrated to value; stdlib `find/min/max` (which return no-star `Option<T>`) work as value. Sample
`value_result.ldp3`; the E5 loop is malloc-free.

**Mangling-ambiguity finding (important for later slices).** The value/boxed discriminator can't be a plain
string suffix: `Option<Node*>` (a value option of a pointer) mangles to `Option$Node*`, which is byte-identical
to the boxed `Option<Node>*`. Two consequences handled in slice 1 by keeping any pointer/ref-payload variant
**boxed**:
- `isValueVariant(t)` is true only when the mangled name has a `Result$`/`Option$` base **and no `*`/`&`/`?`
  anywhere** (a pointer type arg embeds a `*` mid-string; a trailing `*` is the boxed form).
- The value-vs-boxed choice is finalized **after monomorphization** (parser handles concrete sites;
  `monomorphize.cpp` re-boxes a `location:"value"` variant once a type arg substitutes to a pointer/ref, e.g.
  a generic `Option<T>` instantiated at `T = Node*`). This is why a value decision made at parse time on an
  abstract `T` is corrected once `T` is known.

**Deferred to a later slice:** a genuine value variant of an explicit-pointer payload (`Option<Node*>` value)
needs an unambiguous mangling — escape `*`/`&` inside `mangleGeneric` type args (e.g. `Node$ptr`) so the
boxed suffix is distinguishable — then drop the pointer-payload exclusion above.

## Slice 2 implementation notes (done)

Landed: `try?` on a value Result/Option (codegen `TryExpr` now branches on `isValueVariant`: dispatch on the
tag, yield the decoded payload on Ok/Some, and on Err/None early-return the value struct unchanged — the
propagated `{tag,payload}` is representation-identical to the enclosing method's value return, so no boxing).
Reference-typed `T`/`E` (`Result<String,int>`, class payloads) already work — a reference is a pointer, so it
packs into the i64 slot via ptrtoint. Value Result passed/returned by value works (small struct in registers).
Sample `value_try.ldp3`.

**Large payloads — kept boxed for now (not sret yet).** The 64-bit slot can't hold `Decimal` (i128), a tuple,
or a value `struct`. So those payloads stay boxed: `isValueVariant` and the parser/monomorphize decision also
exclude a `Decimal` or tuple `(…)` type arg, and `emitNew` guards a value-`struct` payload (undetectable by
name) with a clear "use the boxed form" error instead of a silent truncation or crash. **Deferred:** a
per-instance sized payload (`{ i32 tag, [max(sizeof T,E) x i8] }`, sret when large) to make these value too —
that is the remaining "sret payloads" work.

## Slice 3 implementation notes (done)

- **`delete` on a value Result/Option is a no-op** — a value owns no heap. The DeleteStmt codegen returns
  early when the target is a value variant (was a codegen crash before).
- **Boxed `Result*`/`Option*` keep working side by side** — verified across the suite; `value_compat.ldp3`
  uses both forms in one program.
- **Nested value variants** (`Result<Option<int>, E>`) hit the aggregate-payload guard (an inner value
  variant is a struct) and get a clear error; the `Ok(Some(x))` nested sugar also needs an explicit form.
  Both fail cleanly, not with a crash.
- **async is guarded.** An `async` method returning a **value** Result/Option is rejected in the analyzer
  ("use the boxed form"): the value would travel through the Task's result slot, which is not sized for the
  `{tag,payload}` struct and corrupted it. NOTE: async returning a *boxed* `Result<T,E>*` is a **pre-existing**
  limitation too (it fails to compile with "await of a non-Task value"), independent of the value form —
  `Task<Result<...>>` needs its own fix, tracked separately. Samples: `value_compat.ldp3`,
  `async_value_result_bad.ldp3`.
