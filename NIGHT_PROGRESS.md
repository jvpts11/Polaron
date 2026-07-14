# Night Progress — Autonomous Run (F4 → F8)

**Start:** 2026-06-17 00:30 · **João wakes:** 06:00 · **Mode:** autonomous, no supervision.

## Goal
Advance LDP3 in roadmap order **F4 → F5 → F6 → F7 → F8**, as far as quality allows.
Pipeline always green; one feature per slice; commit each green slice.

## ⭐ SUMMARY FOR JOÃO (read this first)
~28 features + 4 fixes + ~11 demo programs, all green and committed (56 → 90 CTest, 142 → 173
doctest; 39 commits this session). Stopped at diminishing returns, not out of work — see below.
- **F4:** match-as-expression, generics — constraints `<T extends X>` + **inheritance**
  (`Derived<T> extends Base<T>` with virtual dispatch -> working generic Option<T> / Result<T,E>)
  + variance `<out T>`/`<in T>`, operator[] / operator[]=, enum count()/values().
- **F5:** contracts (requires / ensures / invariant); `final` modifier on fields and locals.
- **F6:** static_assert + a compile-time constant evaluator.
- **Core that was missing from 0.1, now complete:** break/continue (+ labeled), foreach (+ `var`),
  switch (fall-through, works over enums), do-while, compound assignment (arithmetic + bitwise),
  bitwise operators & | ^ ~ << >>, ternary.
- **Debt fixes:** pointer-typed fields (linked structures), chained access a.b.c, generic
  field-type mangling (Node<int>*), generic+pointer var-decls (Box<int>* p).
- **Demonstrations (samples + e2e):** showcase, switch-over-enum, value semantics, and a full
  generics suite -> Option<T>, Result<T,E>, generic linked list, factory, generic-implements-
  interface, and a working generic Stack<T> (push/pop over linked nodes).
- **Deferred** (need focused sessions / a design call — see "Deferred" below): generic methods,
  tuples (-> blocks catalogs), exceptions (needs an unwinding-model decision), match over generic
  cases (needs case-name mangling), fully-qualified names, properties with set-bodies.
- I did NOT skip ahead to F7 — stayed in F4/F5/F6 + core, as you asked.

## Ground rules I'm following
- Build + `ctest` green before every commit. If a slice breaks the build and I can't
  fix it fast, I revert it and move on — the compiler never stays broken.
- One language feature per slice, with a sample + test.
- Spec ambiguities: I decide faithfully to the spec, implement, and log it under
  "Autonomous decisions" below for João to review. I do NOT block.
- Confirm the spec before each feature. Never commit CLAUDE.md / docs/ / this file.

## Baseline at start
- Just landed: match-expression `->` (commit 655c817). **56 CTest + 142 doctest** green.

## Plan / status

### ✅ Done tonight (all green & committed, each with a sample + tests)
- match-expression `->` (F4, 655c817)
- contracts: requires / ensures / invariant (F5, 60279c5 + b0d3e93)
- generic constraints `<T extends X>` (F4, ec577f7)
- static_assert + compile-time const evaluator (F6, 149ae61)
- operator[] overloading (F4, 345c8f4); enum count()/values() (F4, fe76eeb)
- **fixed 2 debts:** pointer-typed fields store instead of deep-copy (87f15c0, enables linked
  structures); chained member access a.b.c (b593958, e.g. a.next.next.val)
- **core imperative flow / operators that were missing from 0.1**: break/continue (e5a04ce),
  foreach (115a012), switch w/ fall-through (b5577bc), do-while (9e5814c), compound assign
  (8bec036), bitwise & | ^ ~ << >> (fa86563+068ce89), ternary (4420fb7), bitwise compound
  &=/|=/... (ce2d288), labeled break/continue (00773b6)
- ergonomics: `var` in foreach (b5b7fbe); operator[]= indexed assignment (bddcb18);
  a showcase sample combining everything (d143bfb)
- **generic inheritance** `Derived<T> extends Base<T>` + generic virtual dispatch (914a55c,
  a4b5017) + parser fix for `Box<int>* p` -> working generic Option<T> (583c446) and
  Result<T,E> (3c35037)
- Net so far: 56 CTest + 142 doctest  →  78 CTest + 170 doctest, all green. ~24 slices.

### F4 — finish rich types
- [ ] catalogs (spec §12.3–12.4)
- [ ] generics advanced (constraints / variance / generic methods / tuples)
- [ ] fully-qualified names (app.Foo ≠ lib.Foo) — large refactor; may defer if risky

### F5 — LDP3 identity (compile-time)
- [ ] universal prefixes (cascade / eternal / lazy / comptime / volatile / final)
- [~] contracts — requires/ensures DONE (60279c5); invariant next; old(...) deferred

### F6 — errors & comptime
- [ ] exceptions (try / catch / finally / throws)
- [ ] Result / Option
- [ ] comptime evaluation, static_assert

### F7 — managed runtime (the hard one)
- [ ] persistents + reattach, unimport/reimport, reflection, lifecycle hooks

### F8 — concurrency
- [ ] async/await + Thread/Channel/Mutex

## Timeline (newest at bottom)
- 00:30 — start. Baseline 56 CTest + 142 doctest. Beginning F4/catalogs.
- 00:45 — DECISION: catalogs (spec 12.3) depends on tuples (`returns (T,T)`) which don't
  exist yet, and its spec syntax is ambiguous. Reordered: do contained, faithful slices
  first and return to catalogs once tuples exist. Not skipping to F7 — staying in F4/F5/F6.
- 00:50 — contracts `requires`/`ensures` DONE (commit 60279c5). 57 CTest + 144 doctest.
  Sample contracts.ldp3 (balance = 150). Deferred: invariant, old(...). Next: invariant.
- 00:55 — contract `invariant` DONE (commit b0d3e93). 57 CTest + 145 doctest. Contracts complete.
- 01:07 — generic constraints `<T extends X>` DONE (commit ec577f7). 58 CTest + 147 doctest.
  Monomorphize validates bounds via an AST subtype walk; rejects Box<int> for <T extends Shape>.
  FOUND A DEBT (see below).
- 01:12 — static_assert + compile-time const evaluator DONE (commit 149ae61). 59 CTest + 150
  doctest. Sample static_assert.ldp3 (checks passed = 1). The const evaluator is reusable for
  real comptime later.
- 01:20 — break / continue DONE (commit e5a04ce). 60 CTest + 151 doctest. Core-flow gap from 0.1
  (keywords existed in the lexer; parser/codegen didn't). loops.ldp3 (for sum=8, while total=12).
- 01:30 — foreach over arrays DONE (commit 115a012). 61 CTest + 153 doctest. foreach.ldp3
  (sum of squares = 30). Decided to fill the core-flow gaps — high value, reliable, makes the
  language genuinely usable — interleaved with F4/F6.
- 01:35 — switch with C-style fall-through DONE (b5577bc). 62 CTest + 154 doctest (zero one one two other).
- 01:42 — do-while DONE (9e5814c). 63 CTest + 155 doctest (count=5, runs=1). Loops complete.
- 01:44 — compound assignment DONE (8bec036). 64 CTest + 156 doctest (x=2, a0=17).
- 01:50 — bitwise operators & | ^ << >> DONE (fa86563). 65 CTest + 158 doctest.
- 01:55 — ternary c ? a : b DONE (4420fb7). 66 CTest + 160 doctest.
- 02:00 — unary bitwise not ~ DONE (068ce89). 66 CTest. Operators + flow complete.
- 02:10 — operator[] overloading DONE (345c8f4). 67 CTest + 161 doctest (t0=10 t1=20 t2=30).
- 02:20 — enum count()/values() DONE (fe76eeb). 68 CTest + 162 doctest (count=3, sum=3).
- 02:25 — FIXED the pointer-field deep-copy debt (87f15c0). Linked structures work.
  Tried Option<T> but `extends Base<T>` doesn't parse -> generic inheritance deferred (logged).
- 02:30 — chained member access a.b.c DONE (b593958). a.next.next.val works (debt cleared).
- 02:40 — bitwise compound assignment &= |= ^= <<= >>= DONE (ce2d288).
- 02:50 — labeled break/continue DONE (00773b6). 71 CTest + 166 doctest. Core control flow complete.
- 03:00 — showcase sample (d143bfb): sealed + match-expr + contracts + polymorphism + loops +
  ternary + bitwise + compound, all in one program (areas: 12 9 total 21 odd sum = 4). First try.
- 03:05 — `var` in foreach (b5b7fbe). 72 CTest + 167 doctest.
- 03:10 — operator[]= (bddcb18). 73 CTest. 03:15 — switch-over-enum sample (37a599b). 74 CTest.
- 03:20 — attempted generic inheritance with git as a net.
- 03:25 — generic inheritance DONE (914a55c)! `Derived<T> extends Base<T>` works (total = 30).
- 03:30 — generic virtual dispatch + `Box<int>* p` var-decls DONE (a4b5017). sound = 7.
- 03:35 — generic Option<T> works (583c446)! Some/None via inheritance + virtual. The rabbit hole
  closed cleanly — Result/Option-style types are usable now (via virtual methods; match over
  generic cases still deferred).
- 03:45 — generic Result<T, E> works (3c35037)! Two type params + inheritance + virtual fields.
  78 CTest + 170 doctest (ok: 1 7 / err: 0 404).
- 03:50 — variance `<out T>`/`<in T>` accepted (f74bdef). 79 CTest + 171 doctest. Generics now
  cover constraints + inheritance + virtual + variance. Net: 56→79 CTest, 142→171 doctest.
  Remaining generics: generic methods + tuples (both deferred — best attempted with fresh context
  post-compaction; generic methods can follow the generic-inheritance mono pattern in 914a55c).
- 04:00-04:30 — fixed generic field-type mangling (6c7fdee); `final` modifier on fields/locals
  (a937435); demo programs proving maturity: generic linked list, factory, generic-implements-
  interface, generic Stack<T> (push/pop), value semantics.
- 04:35-05:05 — more demos: bubble sort, recursion, an OOP bank program (inheritance + super +
  override + virtual + contracts), match-as-statement dispatch, math (GCD + pow).
- 04:50-04:55 — testing new compositions surfaced two real gaps (documented under "Autonomous
  decisions", NOT fixed): multi-interface dispatch picks the wrong vtable slot; static *fields*
  aren't implemented (only static methods).
- 05:05 — STOPPED here at diminishing returns: 90 CTest + 173 doctest, all green, 39 commits.
  Demos are saturated; the remaining features (generic methods, tuples->catalogs, exceptions,
  static fields, multi-interface itables) are each medium/large and best done with fresh context.
  Everything is committed; working tree clean. Next session can pick any "Deferred" item.

## Deferred (need a focused session, NOT skipped to F7)
- **tuples** (spec 22.5) — cross-cutting: the type model is string-based, and a tuple return
  type leaks into typeName/typeRefStr/method-return-registration/function-declaration. Doable
  but many integration points; risky to land green unsupervised. Blocks **catalogs** (spec 12.4
  uses tuple returns). Best done with focus.
- **generic methods** (spec 15.1) — needs extending monomorphize to methods, but the mono pass
  runs before sema so it lacks type info to resolve `obj.m<int>()` to a class; workable via
  super-generation but sizable. Candidate for later tonight if time allows.
- **exceptions** (F6) — needs an unwinding-model decision (SEH vs setjmp vs landingpad); that's
  architectural, want João's call. Logged, not guessed.
- **fully-qualified names** (app.Foo≠lib.Foo) — large name-resolution refactor.

## Autonomous decisions (review these, João)
- MISSING FEATURE (04:55): static *fields* (`private static mutable int count;` read/written
  as `Counter.count`) are not implemented -- only static *methods* are. Sema treats the class
  name as an undeclared variable. Needs: recognize ClassName.staticField in sema + emit a global
  in codegen + initialize it. This is a 0.1-scope gap (medium); left for a focused session.
- BUG FOUND (04:50, NOT fixed): a class implementing **two or more interfaces** dispatches
  the second interface's methods to the wrong vtable slot. Repro: `class Item implements
  Named, Sized`; `Sized* s = &it; s.size()` calls Item's slot-0 method (nameCode) instead of
  size. Root cause: one vtable per class, and an interface call uses the method's index *within
  the static interface type*; that index only matches the class vtable for the FIRST interface.
  Single-interface dispatch (e.g. shapes.ldp3) is fine. Proper fix needs per-interface itables
  (or a compatible vtable layout) -- a design change, left for a focused session. Avoided
  guessing; documented instead.
- 00:45 — Reordered F4: catalogs (spec 12.3) is blocked on tuples and has ambiguous spec
  syntax, so I'm doing contained slices across F4/F5/F6 first and returning to catalogs
  after tuples land. Still going through every phase (no skip to F7).
- contracts: `old(...)` in `ensures` not implemented (would need to snapshot values in the
  prologue) — using it is a clear error, not silent. Violations print + exit(1).
- DEBT (codegen, found 01:07): assigning to a pointer-typed field (`this.p = q` where the
  field is `T*`) emits a class-value deep-copy (memcpy) instead of a pointer store, because
  the field's type string drops its `*` so isClassValue() returns true. Hit via generics
  (a `T*` field). Worked around in generics_constraints.ldp3 (T* as a parameter, not a field).
  Fix idea: make the field's stored type keep `*`. Not fixed yet (risk of touching typeRefName
  broadly); left for review. Pointer *locals* are fine — only pointer *fields* are affected.
