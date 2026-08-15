# Type identity: giving a type its path

*Design proposal, 2026-08-15. Written from measurement on this machine; every number below was taken
before any of it was built, so the performance claim can be checked rather than believed.*

> The constraint is stated first because it decides the design: **the language must stay exactly as
> fast as it is now.** Not "fast enough" — as fast. That applies to compiled programs, and it applies
> to the compiler, which is 325 ms of fixed cost that every test in the suite pays.

## The problem, precisely

**A type does not carry its path.** The analyzer's symbol table is
`std::unordered_map<std::string, ClassInfo>` keyed by the **bare name**: `classes_[cls.name]`. There
is no `System.Spatial.Color` anywhere in the compiler — there is `Color`, and only one of them.

So when a program declares a type the standard library also declares, the compiler cannot tell them
apart. What it does instead is **invent** a difference: a pass in `monomorphize.cpp` rewrites both
declarations and every reference to them, `Color` becoming `Spatial__Color` and `App__Color`. That is
a qualified name faked with a `__` in the middle, because there is nowhere to put a real one.

**This is a stopgap, and it is already recorded as one.** `CLAUDE.md`'s F4 list has carried the line
*"nomes qualificados completos (app.Foo≠lib.Foo)"* since before today.

### What it cost on 2026-08-15

Adding a `Color` to the standard library — the likeliest name for a user's own type in a graphics
program — broke three things at once, in programs that had done nothing unusual and never imported it:

| what was not rewritten | how it failed |
|---|---|
| an enum's **method bodies** (only its name was renamed) | `Color.GREEN` inside the enum's own method: *use of undeclared variable 'Color'* |
| **`sizeof`'s argument** — a type written where a value goes | the same error, pointing at **line 1**, because the expression came from a string interpolation and sub-parsed nodes carry no location |
| **`unimport` / `reimport`** — not handled by the statement clone at all | the statement was silently **dropped** |

All three are the same omission in different places, and all three share one trigger: **nothing fires
until a stdlib type shares a name with a user's.** No collision, no renaming, nothing to walk. They
were fixed, and a test now pins them — but they are symptoms. A compiler where a type already knows
who it is has nothing to rewrite, so it has nothing to leave unrewritten.

## What was measured, before deciding anything

**Compile time is the prelude, and almost nothing else.** Median of five, Release, this machine:

```
hello_world   329 ms
tic_tac_toe   329 ms
science       341 ms
```

A program's own code costs about ten milliseconds. The other 325 is ~280 prelude types being parsed,
registered and resolved, and it is paid by every one of the 799 tests.

**The compiler is string-keyed throughout.** 188 `map<std::string, ...>` declarations across `src/`,
of which 37 are in the analyzer's header and 60 in codegen's.

**And the numbers that decide the whole design:**

```
prelude types            282
average type name        8.2 characters
average namespace name   5.7 characters
```

A canonical `Bundle.Namespace.Name` averages **≈21 characters**. MSVC's small-string optimisation
holds **15**. So naively switching the keys to canonical names moves every type name in the compiler
**from inline bytes to a heap allocation** — in 188 maps, on the hot path of a 325 ms compile that is
mostly symbol-table work.

> That single fact rules out the obvious design. "Key the maps by the full path" is the first idea
> anybody has, and it would cost a heap allocation per name per map. It has to be an integer.

## The design

**A type's identity is a `TypeId` — a 32-bit index — and its canonical name is a string kept once, in
one table, for diagnostics and for the `.polh`.**

```
struct TypeTable {
    std::vector<std::string> canonical;   // "System.Spatial.Color", by id
    std::vector<std::string> written;     // "Color" -- what a message must say
    std::unordered_map<std::string, TypeId> byCanonical;
    std::vector<ClassInfo> info;          // indexed by id, not hashed
};
```

Three consequences, and each is the answer to one of the failures above:

1. **`System.Spatial.Color` and `Main.App.Color` are different ids.** Nothing is renamed, so nothing
   can be left unrenamed. The whole `qualifyNamespaces` pass — and the three holes in it — goes away
   rather than being patched again.

2. **Lookups become an array index.** Today every visit to a type re-hashes a string; after this, a
   name is resolved to an id once per syntactic site and everything downstream indexes. This is the
   part that should make the compiler *faster*, and it is why the change is worth making on
   performance grounds alone rather than despite them.

3. **A name is resolved where the language says it is.** A written name resolves against the current
   namespace first, then the imports — which is what `import` already means, and what
   `checkTypeAccessible` already enforces for visibility. Resolution and visibility become one
   question asked once, instead of two mechanisms that agree by luck.

### What must not change

**Diagnostics must say what the author wrote.** Today two places un-mangle by hand with
`disp.rfind("__")`, copy-pasted, applied where somebody remembered. With identity carried properly
there is one `written[id]` and no rfind anywhere — but the rule has to be enforced, because the
current state is exactly what happens when it is not.

**Dedupe must keep deduping.** Monomorphization, function specialization and the `linkonce_odr`
sharing between a library and its consumer are all keyed on mangled names. If two spellings of the
same instantiation stop colliding, the program gets two copies of a template and loses the inlining
that made them one. **This is the one way this change could slow a compiled program down**, and it is
therefore what the measurement below watches.

## The performance guarantee, and how it is checked

Two different promises, measured two different ways.

**Compiled programs must be exactly as fast.** `performance tests/` already compares against C and C++
on the workloads they are known to be good at — matrixmul, mandelbrot, primes, fibonacci, the
collections set. Every one of them is run before the change and after, on this machine, under the
protocol in `ldp3-benchmark-protocol` (real conditions, no pinning). A regression in any of them stops
the change.

**Plus a proxy for the dedupe risk**, because a benchmark can hide it: the emitted `.ll` for a program
that instantiates several generics is compared line-for-line before and after. Dedupe failing shows up
as *more code*, immediately and unambiguously, long before it shows up as a slower loop.

**The compiler must not get slower.** The three compiles above are the baseline: 329 / 329 / 341 ms.
The change should move them **down**; the bar is that they must not move up.

## Staging

Each stage leaves the compiler working and the suite green. The order is chosen so the risky part is
last and the measurement exists before it.

1. **Measure and record.** Run the benchmark suite and the three compiles, and commit the numbers, so
   "as fast as it is now" is a number rather than a memory.
2. **A `TypeTable` beside the current maps.** Populate it, assert it agrees with `classes_` on every
   lookup, change no behaviour. This is where a disagreement is found cheaply.
3. **Resolution moves to it.** A written name resolves to a `TypeId` through namespace + imports. The
   old `qualifyNamespaces` pass is bypassed, not yet deleted, so the two can be compared.
4. **Delete the renaming.** `Ns__Type` stops existing. The three fixes made on 2026-08-15 become
   unreachable, and `shadow_stdlib_name.pol` keeps passing — it now tests real identity rather than
   correct rewriting.
5. **Storage.** `ClassInfo` moves from the hash map into a vector indexed by id, and the hot maps in
   codegen follow. Measure again.
6. **The `.polh` carries canonical names**, which it must, because a bundle boundary is exactly where
   two `Color`s meet.

## What is not yet known

Written down because a plan that hides its unknowns is a plan that discovers them late.

- **How many places assume a bare name is unique.** 188 string-keyed maps is the upper bound, not the
  count that matters; the real number is how many key on a *type* name specifically, and it has not
  been counted.
- **Whether reflection needs the canonical name or the written one.** `Type.name()` is observable
  behaviour, and changing what it returns is a language change rather than an implementation one.
- **What a generic instantiation is called.** `ArrayList$int` is a mangled name today and the dedupe
  depends on its exact spelling across bundles. It has to become an id too, and the `.polh` has to
  agree about it.
