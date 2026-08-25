# One front — the implementation plan

Three bodies of work turned out to be one:

1. **The anti-procedural findings** — 34 objections tested against C, with everything that is *work*
   collected in `anti-procedural-tests/LEDGER.md`.
2. **The language designs** decided in this round — `entity`, `dynamic`, `stable`, `reentrant`,
   `layout` redesigned, `unique` over values, `enum` with payloads, `asm` constraints, `Machine`.
3. **PIR stages 3 and 4** — completing the flip, and moving the analyses down out of the AST.

They are one because **every performance entry in the ledger is already a row of the PIR
specification** (§11 passes, §12 hand-off), because **every new construct depends on a PIR pass to be
worth having**, and because **the same weak instrument let five defects through all three**.

---

# The rule that governs the plan

> **A wave does not start until the previous wave has zero open items.** Not "the important ones
> done"; zero. Every wave below has an **exit criterion that can be checked by running something**,
> and a **trap** — the specific way that wave could look finished while leaving a debt.

Two consequences that are not negotiable, because both are ways a debt hides in plain sight:

- **A design document with an open `Still to design` table is a debt.** A construct cannot be
  implemented while a decision inside it is unmade — the decision then gets made by whoever writes
  the code, at the keyboard, unrecorded. Wave 5 begins by emptying those tables (§W4.5).
- **A measurement taken against a broken compiler is a debt.** Every number in the anti-procedural
  repository was measured on a back end that strides arrays wrong, leaks fields, allocates every
  `Result` and loses String ownership. They are re-run in Wave 8, and the campaign is not finished
  until they are.

---

## 0. The scoreboard already exists

Every compile prints it. From a build in this session:

```
pir passes: guards-removed=169 immutable-slots=6872 dead-removed=11240 facts=54 contract-facts=3
pir->llvm handoff: noalias=0 nonnull=3999 align=3678 deref=2211 nounwind=2561
                   pure=10 cold=12 internal=93 checked=0 assume=0 tbaa=10 devirt=0
```

`polaron-ir.md` §12 calls that table *"the acceptance criterion for the project"*. Four of its rows
read **zero** and one reads low:

| row | now | why it matters |
|---|---|---|
| `noalias` | **0** | the first suspect behind the vectoriser gap — four AP tests, 2–5.7× |
| `devirt` | **0** | four AP tests reach this from four directions |
| `checked` | **0** | overflow via `llvm.*.with.overflow` rather than open-coded compares |
| `assume` | **0** | contracts surviving pass 3 |
| `tbaa` | 10 | should come from real `layout` offsets, not from nothing |

**The plan is to drive those numbers to none-zero-without-a-reason.** It is not a proxy for progress;
§12 says it *is* the criterion.

---

# Wave 0 — the instrument — **DONE**

> **Closed.** Suite 1128 → **1133/1133**, and the shape gate is green over the **whole corpus**:
> 876 of 876 samples, 6 634 difference lines, **27 classes, zero unlooked-at** — from *9 402
> differences and not one program in full agreement*. The memory half exists for the first time.
>
> **Nine defects were found doing it** (Wave 1, marked **[W0]**), four of which break a guarantee
> the language makes rather than wasting memory: RAII skipped on the unwind path, objects in a
> region never destructed, a bare `Object` dispatch that is an access violation, and `await` that
> blocks instead of suspending.
>
> | | |
> |---|---|
> | classification | `tests/pir_shape_baseline.md` — 16 classes, two of them *"PIR is right"* |
> | shape gate | `pir_shape_classified` — by **kind**, not count; fails on any unseen kind |
> | memory gate | `POLARON_LIVE=1` at exit, compared in `run_pir_behaviour_test.cmake` against an **exact-pair waiver** that fails on one block of movement |
> | the entry wrapper | excluded from the shape diff, asserted absolutely — `samples/entry_wrapper.pol`, both paths |
> | new samples | `entry_wrapper`, `bare_object_dispatch` (`WILL_FAIL`, flips red when D5 is fixed) |
>
> **The first task was a reading and it paid**: `--compare-ir` already existed and already worked —
> it named the `Result` defect exactly — and gated nothing because nobody could read it.
>
> **And the stride is not the classification.** The registered gate runs 110 of 876 samples for
> time; the classification was built corpus-wide, and the corpus-wide run is what found three of
> the twelve classes that the stride had missed. `tests/pir_shape_baseline.md` carries the command
> and the rule: whenever a class is added or removed, run it over everything.

**Nothing else in this plan is trustworthy until this lands.** And the first task is a reading, not a
build, because the instrument already half exists.

### What was found by starting with the reading

`--compare-ir` exists and **works**: on the value-form `Result` defect it printed

```
Port.read: calls Err$int$Fault.Err$int$Fault 0->1, calls Ok$int$Fault.Ok$int$Fault 0->1,
           calls __polaron_malloc 0->2
```

— the defect, by function, with counts. And it is **drowned**: `hello_world.pol` reports
`0/2 bodies agree, 2 differ`, and across 27 samples almost everything disagrees almost entirely. A
tool that fails hello world gates nothing, which is why the suite is not gated on it and why five
defects walked past an instrument that was already built.

Two named sources of the noise, and only one of them is noise:

| | |
|---|---|
| **the wrong pair of functions** | the trusted path fuses `Main.main` into `main`; PIR emits a wrapper that calls it. Every program has a `main`, so it poisons everything — and it drags the body's allocations with it (`array_equality` reports `__polaron_malloc 4->2` in `main` purely as a consequence) |
| **String field ownership** | not noise — a **fifth defect**, diagnosed below and fixed in Wave 1 |

### The work

1. **Bring the noise floor to zero.** Classify every systematic difference. A difference is either
   fixed, or named in a list with a reason, and that list is checked into the repository.
2. **`liveBytes()` at exit, beside stdout.** The oracle has missed five memory defects for one
   reason: the output is identical.
3. **Gate the suite on both.**

### Exit criterion

> Run the whole sample corpus under `--compare-ir` and the `liveBytes` check. **Every sample either
> agrees, or appears in the checked-in exceptions list with a written reason.** The count of
> unexplained differences is **zero**, and CI fails if it stops being zero.

### The trap

Ending with *"the important samples agree"*. The five defects were all found in samples nobody
thought were important. An exceptions list with an unexplained entry in it is Wave 0 unfinished.

---

# Wave 1 — correctness — **DONE**

> **Closed at 1 153 tests green.** Every defect in the table below is fixed, refuted with evidence, or
> measured and named. The shape census went from **6 634 difference lines to 674, all classified**;
> `liveBytes` agrees exactly on every sample the sweep reaches but three, and those three are one
> rule with a number against it (see `tests/pir_shape_baseline.md`, "What is left, measured").
>
> Two entries below were **refuted**, which is worth as much as a fix and costs a sample each: D12's
> twelve constructor calls are twelve SITES behind twelve lazy flags and run three times on both
> paths, and class N's `foreach` does call the iterator protocol — exactly 7 `hasNext` and 6 `next`.
> Both were counted, not argued.
>
> Four defects nobody had listed came out of the work: an array of structs stepped by the sum of its
> fields (wrong answers and a short allocation), `ArrayList<Point>.get` returning `undef` (every
> value-struct element read back as zeros), `namespace App` in a program colliding with the library's
> so that declaring `Money` broke the prelude's own compilation, and a String built over a static of
> the runtime's and then released. Three of the four are wrong ANSWERS, not leaks.



> **The fixes go into PIR. The trusted path is not repaired.**
>
> PIR was built against the trusted path as its oracle — the two were meant to produce the same thing
> so PIR could be verified and PIR-specific problems cut out. Two things follow, and both change how
> this wave is run:
>
> 1. **A defect present in both is invisible to the differential**, by construction: it measures
>    divergence, and an inherited error does not diverge. PIR is LLVM's IR carried up to hold what
>    Polaron knows, so a defect on one side may sit on the other for the same reason. **This is what
>    Wave 2's absolute checks are actually for** — not merely to survive the deletion, but because
>    they are the only instrument that can see a shared defect at all.
> 2. **Repairing the trusted path is work thrown away** — it is deleted at the end of Wave 2. Where a
>    defect is on both sides, the PIR side is fixed and the trusted side is left, and the differential
>    goes red until Wave 2 removes the other arm. That red is honest and it is temporary.

**The list below was a floor, and Wave 0 raised it.** The instrument found **five defects nobody
knew about** in its first hours, three of which break a guarantee the language makes rather than
merely wasting memory. They are marked **[W0]**.

| known now | |
|---|---|
| **[W0] PIR's `await` blocks instead of suspending.** Trusted calls `__polaron_await`, which registers a continuation and returns so the worker is freed; PIR calls `__polaron_task_wait`, which sleeps on a condition variable until the task is done. With a bounded pool, tasks waiting on tasks that need a worker is the classic deadlock | **async is not asynchronous** |
| **[W0] PIR re-constructs a Java-style enum constant at every reference** — twelve constructor calls where the trusted path's lazily-initialised singleton makes three | behaviour, where the constructor has an effect |
| **[W0] PIR does not run destructors when an exception unwinds.** Trusted calls `Guard.~Guard` twice — `dtor.live` and `rethrow` with `[ "funclet"(token) ]`, the SEH cleanup path — and PIR calls it once, on the normal exit only. Every stack object with a destructor, every `defer`, every `using`, skipped when a throw passes through | **RAII is broken on the error path** |
| **[W0] PIR never writes the `Object` vtable pointer.** `Object.Object` stores `this` into a local and returns where trusted stores `@Object.vtable` into slot 0. A bare `Object` dispatched on exits `0xC0000005`. 874 samples missed it because not one constructs a bare `Object` | **an access violation** |
| **[W0] PIR does not emit the null-receiver check.** Trusted guards a dispatch with a panic naming file and line; PIR emits none anywhere — two samples, trusted 2 and 2, PIR 0 and 0. Hosted, the diagnostic is lost; freestanding with no MMU, the no-UB rule is | breaks a stated guarantee |
| **[W0] PIR lowers an atomic read-modify-write as load/add/store.** The `abstainfrom` counter loses updates between two threads, and loses one to any interrupt between the load and the store | breaks a stated guarantee |
| **[W0] PIR does not implement String field ownership** — neither the copy nor the free, anywhere. Because both halves are missing the failure is a leak rather than a dangling pointer | leak per field store |
| **[W0] PIR gives a non-capturing lambda a heap closure** where trusted stores a global and allocates nothing | allocation per construction |
| **PIR strides an array of structs by the sum of field sizes** — every element reads and writes the wrong bytes, silently | wrong answers |
| **PIR leaks an array reached through a field** — any class that owns a collection leaks it on every `delete` | leak per object |
| **PIR allocates the value form of `Result`/`Option`** — `lower.cpp:20860` puts `location == "value"` in the `"heap"` branch | allocation per fallible return |
| **PIR emits no `x86_intrcc` and allocates on interrupt entry** — `retq` against an interrupt frame corrupts the interrupted context | bare metal is broken |
| **PIR does not implement String field ownership.** The runtime states the protocol — *"a String field or element OWNS its buffer: storing one copies, and overwriting one frees the previous"* — and emits `str_copy`/`str_free` at every such store. Measured: trusted 3/3 in a sample, PIR **0/0 anywhere**. Because PIR omits *both* halves, the failure is a **leak, not a dangling pointer** | leak per field store |
| **the two fixes already written** — entry-block alloca, region-class arena copy. 62 lines, suite green at 1128/1128, uncommitted | commit here |
| **`polc` segfaults on an imported `abstract` class** — exit 139, both backends | a crash |
| **two `label` sites for one `comefrom` emit invalid IR** | |
| **a cross-bundle constructor symbol is built from the qualified key** — fails to link | |
| **a user type re-points name resolution inside the prelude** — declaring a `Money` breaks the standard library's own compilation, with no warning | a user program can break the stdlib |
| **two silent narrowing conversions** — `byte * byte` into a `byte`, `int → float` | |

### And two samples this wave owes, because the corpus cannot reach what it does not contain

| | why |
|---|---|
| **a custom `Iterator`** | PIR lowers `foreach` over an `Iterable` **without calling `iterator()` or `hasNext()`** (baseline class N). Output is identical here — but the corpus's only `Iterable` is `ArrayList`, whose iteration a compiler may reasonably know. A user type whose `next()` does anything would be bypassed by the same lowering and **no sample would notice** |
| **a bounded pool with tasks awaiting tasks** | D11 says `await` blocks instead of suspending, which is invisible in output and shows as a deadlock only when the pool runs out of workers. Nothing in the corpus fills a pool |

Both are the same lesson as `bare_object_dispatch.pol`: **a defect the corpus cannot reach is a
defect the corpus calls correct.**

### And the tests that probe the wrong site are part of this wave

`tests/samples/test_string_ownership.pol` was written **for the String divergence** and says so:
*"no test in the corpus could see the difference, because a leak prints nothing."* It still cannot —
it probes String **locals** in `Probe.churn`, where **both** back ends emit zero, so it passes on
both while the real divergence sits at **field stores**, untested. It is green and it is guarding
nothing.

Same shape as AP-03's foldable arms: a test written for one thing, measuring the thing beside it.
**Every test that Wave 0 shows is guarding nothing gets re-pointed here**, not later.

### One open question this wave must answer, not carry

Are String **locals** freed at all, on either path? Neither back end emits the pair inside
`Probe.churn`. If neither does, both leak locals and that is larger than the PIR defect. Counting IR
could not answer it; running it can, and the answer belongs in this wave.

### Exit criterion

> The strengthened oracle is silent across the whole corpus, `liveBytes` agrees, and no test in the
> corpus is green while guarding nothing.

### The trap

Fixing the eleven above and shipping, while Wave 0's output added a twelfth. Wave 1 closes against
**Wave 0's list**, not against this table.

---

# Wave 2 — PIR Stage 3 completes — **DONE**

> **Closed at 1 167 tests green, 2026-08-25.** The trusted path is deleted: **24 092 lines**, eleven
> files under `src/codegen/` plus the four harnesses that existed only to compare the two back ends.
> `llvm::` in `src/` went from 3 399 mentions to 1 016, and every one outside `tollvm.cpp` is a
> shared service — `bridges`, `testrunner`, `optimize`, `target` — rather than a back end.
>
> **The exit criterion was met in the order it demands.** The four absolute checks were landed AND
> demonstrated to fail on a reintroduced defect *before* the deletion, not after:
> `live_*` (21 samples, `POLARON_LIVE` against a recorded `bytes/blocks` pair), `golden_ir_*` (three
> recorded function bodies), `object_*` (the interrupt convention and `iretq`, read out of the
> object), and the padded-struct stride sample. `live_catches_reintroduced_defect` and
> `golden_ir_catches_reintroduced_defect` are the teeth: each puts a real, fixed defect back behind
> an environment variable and fails if the check does not notice.
>
> **1 181 → 1 167 is the fourteen differential tests, exactly.** `pir_differential_*` (3),
> `pir_behaviour_*` (9), `pir_shape_classified`, `pir_batch_agreement`. Nothing else left the suite,
> and all nine `pir_behaviour_*` samples kept both halves of what their pair asserted: `live_<sample>`
> pins the exit heap, `codegen_<sample>` pins the output.
>
> **Two things had to be done first, and neither was in the plan.**
>
> **1. The `.polb` still came from the other back end.** Handing the bundle to PIR failed twenty
> bundle tests at once, for five separate reasons: `module.library` was set *after* the reachability
> pass rather than before, so every public method of a `--lib` shipped as a symbol with no body;
> devirtualisation was being applied across a bundle boundary, where proving "nothing overrides this"
> proves nothing about a consumer compiled later (`bundle_inherit_runs` printed `total = 17` for 57);
> monomorphized instances and prelude methods are compiled on BOTH sides and collided at link
> (`duplicate symbol: Some$String.isSome`, then `Signals.INTERRUPT` behind it) — both are ODR with a
> COMDAT now, which is also more correct than the trusted path's answer of making every static
> private; the synthesized constructor was `internal`, which a program cannot notice and a library
> fails to link on; and nothing was `dllexport`, so `--use-dynamic` built and loaded the image
> perfectly, got a null from `GetProcAddress`, and died at `0xC0000409` with no output at all.
>
> **2. PIR had no error channel.** The deletion dropped **twelve diagnostics**, and not one failed
> loudly — `polc` accepted each program, emitted IR, exited 0. They were the checks the trusted back
> end performed as it walked the AST: a `region class` placed `on heap`/`on stack`/`into region`,
> an `asm` block written for another architecture, `extern syscall` off Linux/x86-64, `interrupt`
> off x86, threads on bare wasm, a static initialiser that cannot be evaluated (cycle, or a value
> that must be ALLOCATED before the process exists), a `demand` over `sizeof`, a `layout` byte
> budget, and a `--target` naming an architecture LLVM cannot parse. `Lowering::errors` exists now,
> and is deliberately not the gap list: a gap says "not lowered yet" and emits the module anyway.
>
> The threads gate was written wrong first and the trusted path's own comment said so in advance —
> asked where `Thread.start()` reaches the runtime, it refused a wasm module that never mentioned a
> thread, with the caret in a prelude file the author never opened. It is asked at the call site,
> where the caller is known, exactly as the note said to.

`polaron-ir.md` §14: *"once a release passes with no differences it is deleted — and roughly 3 400
lines of `llvm::` spread over 11 files collapses into one back end that is the only thing holding an
`llvm::` type."*

### The debt this wave hides, and it is the sharpest in the plan

**Deleting the trusted path deletes the instrument.** Every check that exists only as a *comparison*
stops existing at the moment the second side is removed. Seven defects were found by that comparison
and by nothing else.

And the comparison was never the whole instrument anyway: **PIR was built against the trusted path,
so a defect in both never diverges and was never visible.** Two things already point at a shared
defect rather than at a divergence, and neither is a differential:

- an **absolute** check — a number the program reports about itself, like `POLARON_LIVE`, held
  against a recorded expectation rather than against the other arm;
- the **anti-procedural tests**, which measure against **C** — an external standard that has no
  opinion about either of our backends, and is the only thing here that can call both of them wrong
  at once.

So this wave's checks are not a consolation for losing the differential. They are the half of the
instrument that was always missing.

So, **before** the deletion, every differential check must be re-expressed as an **absolute** one:

| differential today | absolute replacement |
|---|---|
| "PIR allocates where trusted does not" | `liveBytes` at exit, and per-function allocation counts asserted against a recorded expectation |
| "PIR strides differently" | a test that reads back what it wrote through an array of a padded struct |
| "PIR emits no `x86_intrcc`" | a test asserting the emitted convention and `iretq`, from the object |
| "the bodies differ in shape" | golden IR for a chosen set, and the assembly-comparing tests AP-03's lesson demands |

### Exit criterion

> The trusted path is deleted, one back end remains, the suite is green — **and the absolute checks
> above were landed and demonstrated to fail on a reintroduced defect before the deletion**, not
> after.

### The trap

Deleting first and rebuilding the checks afterwards. There is then a window with no instrument at
all, and the last five defects say what happens in such a window.

---

# Wave 3 — PIR Stage 4, the passes

`polaron-ir.md` §11, in its own dependency order. Four already run.

| § | pass | state | what waits on it |
|---|---|---|---|
| 11.2 | type-fact propagation | runs (`facts=54`) | |
| 11.3 | **guard elimination** | runs (`guards-removed=169`) — *"the pass that pays for the project"* | **`entity` is born slower without it** |
| 11.4 | immutability propagation | runs | |
| 11.5 | **escape analysis** | missing | `entity`'s non-escaping row reference; `reentrant` |
| 11.6 | allocation hoisting and sinking | missing | |
| 11.7 | **region binding, on the graph** | missing | `reentrant`'s region rule |
| 11.8 | **devirtualisation** — from `final`, `sealed`, `permits` | missing (`devirt=0`) | **AP-01, AP-03, AP-04, AP-05** |
| 11.9 | reachability / DCE | runs, validated against `GlobalDCE` | the 302-vtables defect |
| 11.10 | contract lowering → `llvm.assume` | missing (`assume=0`) | |

Plus every §12 hand-off row that reads zero: `noalias` from `isUnique` and from `move`, real TBAA
from `layout` offsets, `checked` from the overflow rule.

### Exit criterion

> **No row of the §12 scoreboard reads zero without a written reason**, and for every pass there is a
> test that **fails when that pass is turned off**. The machinery exists: `POLARON_PIR_PASSES=<list>`
> runs only the named passes, and was written for exactly this kind of question.

### The trap

A pass that lands, reports a number, and no test notices when it stops working.
`src/pir/passes.h` states the hazard in its own words: *"a pass that silently does nothing looks
exactly like a pass that works, which is how an optimisation quietly stops happening."*

---

# Wave 4 — the experiment that decides the largest question

**The vectoriser gap is 90% not ours**, and it was measured wrong the first time:

```
gcc -O3  on C ............  63 ps/read
clang -O3 on THE SAME C ... 323 ps      5.1x
Polaron ................... 366 ps      +13% over clang
```

Two hypotheses, and one afternoon separates them:

1. **The facts change LLVM's answer.** clang may give up on C precisely *because* C's aliasing is
   weak. Given `noalias`, real TBAA and `dereferenceable`, LLVM may vectorise where it refuses for C
   — in which case Polaron does not draw level with GCC, it **passes** it, because GCC must prove
   what we declare.
2. **LLVM's vectoriser does not do this shape.** Then the answer is a back end of our own
   (`polaron-ir.md` §15), and that is a far larger conversation.

### Exit criterion

> The experiment has run and **the answer is written down**, with the numbers, in
> `polaron-ir.md` §15.5 — which names this wave as Stage 5's gate.

### The trap

Ordering the rest of the performance work before this has run. Until it has, any such ordering is a
guess.

---

# Wave 4.5 — design closure

**Every `Still to design` table in every design document is emptied before a line of Wave 5 is
written.** A construct implemented with an open decision inside it has that decision made silently,
at the keyboard, by whoever gets there first.

| document | what is open |
|---|---|
| `entity.md` §15 | lone entity legal · nested flattening · AoSoA now or later · how a `pass` names its row index · parallel asked or derived · `stable movable` |
| `layout.md` §13 | short-name collisions · inherited fields in a resolver · what a resolver may read of a field · `align` without the `padding` concession · `layout` over an `entity`'s columns |
| `dynamic.md` §10 | `dynamic` on an `abstract method` · constraint-only interfaces → `transformer`/`satisfies` · the four root methods · the freestanding representation reused per class |
| `ownership.md` §20 | does `movable` cross to values · the `Shared` escape hatch · `ArrayList` growth as a bulk move · `Shared` on a region |
| `reentrant.md` §10 | self-interrupting handlers and an exclusive region · `reentrant async` · `reentrant class` · what counts as shared mutable state · freestanding default |
| `enum-variants.md` §10 | generic enums · `match` over a payload · equality of a class payload · `catalog` over a parameterised case · the boxed form's survival |
| `asm-constraints.md` §6 | register pairs (`edx:eax`) · architectures beyond x86_64 · which class words |
| `freestanding-prelude.md` §9–10 | the three-tier split · the first cut · where `Machine` lives · core as a third bundle or gated |
| **`.polb` carries PIR?** | the right shape of the precompiled-prelude question (Wave 6) |

### Exit criterion

> No design document under `docs/design/` contains an open item. Every table above reads *decided*,
> with the decision and its reason in the document.

---

# Wave 5 — the language, in dependency order

| | needs | closes |
|---|---|---|
| **`dynamic`** | nothing | AP-02 outright, and the header component of AP-07/10/24. **Unblocks `layout` on classes** |
| **`unique` over value types** | nothing | value `atomic<T>` — the *containing* half of AP-09 |
| **`Shared` as a checked modifier** | `dynamic` | AP-09/AP-33's residue |
| **`move` to a thread** | nothing | the fourth way across a thread boundary |
| **`comptime` generalised** | nothing | `layout`'s resolver, `Machine`'s per-architecture partition |
| **`layout` redesigned** | `comptime`; `dynamic`; a **topological order over containment** — the one new compiler phase in this plan | AP-16, and with the two above, **AP-09 entirely** |
| **`reentrant`** | Wave 3's call-graph pass | AP-11, and the holes in AP-12 and AP-17 |
| **`entity` + `pass` + `sparse` + `stable`** | guard elimination (11.3), escape analysis (11.5) | AP-06 — the last objection standing whole |
| **`enum` with payloads** | generic enums | user-declared value sums; payloads past 64 bits |
| **`asm` operand constraints** | nothing — `registerFamily()` already exists | AP-18's detail |
| **`super.method()`** | nothing | AP-29's residue |
| **`Machine` + the three-tier split** | `comptime if`; `reentrant` to check it | AP-19's residue |

### Exit criterion

> Each row lands with: its samples, its diagnostics written in the catalogue with `why`/`fix`/
> `prevent`, its `.polh` round trip where the fact must travel, and **the AP test it closes re-run
> and re-measured**. A feature whose objection has not been re-measured is not done.

### The trap

Landing the construct and leaving the diagnostic for later. The diagnostics *are* the feature here —
`dynamic` without the erasure-boundary message is a refusal with no explanation, and `layout` without
*"with `permits reorder` it measures 18"* is the check-that-only-refuses the original design set out
to avoid.

---

# Wave 6 — the toll and the tools

| | worth |
|---|---|
| **precompiled prelude** — as *"does `.polb` carry PIR?"*, decided in Wave 4.5 | 1089 ms → the floor. The *slope* is already 14× better than GCC's; this is one fixed toll |
| **`switch` → jump table** | 20% on the construct the language recommends for closed sets |
| **vtable emission** — 302 tables for a 16-class program; PIR's slot space is twice the trusted path's | 72 KB |
| **mangle by representation** | 80 `Box` functions where 10 would do |
| **DWARF `DICompositeType`/`DIDerivedType`** | a debugger stopped in a method can print the object |

### Exit criterion

> Each with its measurement, before and after, in the finding it closes.

---

# Wave 7 — the advice system

Nine entries, found by taking the compiler's own advice until every file compiled clean: `0B2B`
counting sites not allocations, `0B47` advising a remedy that does not compile, `0B40` twice, `0B45`
silent on the textbook case, `0B0C` blind to a declaration-site `[Allow]`, `0B3C` firing on the shape
its own fix recommends, `[Allow]` a parse error before a local, and codeless warnings that cannot be
allowed at all.

Last on purpose: several read differently once the constructs above exist. **That is a reason to
sequence them last, not a reason to leave any of them.**

---

# Wave 8 — re-measure the thirty-four

**Every number in `anti-procedural-tests/` was measured against a compiler with five known defects in
its default back end.** AP-21's byte table is already marked as needing re-measurement; it will not
be the only one.

- Re-run all 34, both languages, both C compilers, on the fixed compiler.
- Rewrite every finding whose numbers moved, and every verdict whose *cause* moved.
- **AP-32** gets what it has been missing: a kernel that boots **on `Machine`** rather than on
  hand-written casts is a different claim from `kernel/kernel.pol`'s 39 lines.

### Exit criterion

> Thirty-four findings, each re-measured on the finished compiler, and `LEDGER.md` empty of open
> rows.

### The trap

Treating this as optional because the constructs are built. A campaign whose numbers were taken
against a broken back end has not answered anything; it has recorded what a broken back end did.

---

## The dependency spine

```
Wave 0  instrument: noise floor to zero, liveBytes, suite gated
   |
Wave 1  correctness -- against WAVE 0's list, not against a list written in advance
   |
Wave 2  absolute checks land and are demonstrated  ->  then the trusted path is deleted
   |
Wave 3  Stage 4 passes -- no scoreboard zero without a reason, each pass with a test that
   |                      fails when it is turned off
   |
Wave 4  the vectoriser experiment -> the answer is written, and it gates PIR Stage 5
   |
Wave 4.5  every design document's open table emptied
   |
Wave 5  the language, each row with samples + diagnostics + .polh + its AP test re-measured
   |
Wave 6  the toll and the tools        Wave 7  the advice system
   |
Wave 8  the thirty-four, re-measured on the finished compiler
```

## What "finished" means

The campaign's criterion and §12's are the same sentence read from two sides:

- **thirty-four objections answered**, each with a C counterpart, each measured **on the finished
  compiler**;
- **every row of the §12 hand-off emitted and measured** — at which point *"writing idiomatic Polaron
  is writing fast Polaron"* is true, and the `0Cxx` idiom warnings become honest, because their `why`
  can name an optimisation that exists.

## What sits beyond this plan

**PIR Stage 5 — a back end of our own, replacing LLVM** (`polaron-ir.md` §15). Not scheduled, and
this plan is its precondition: §15.5 makes **Wave 4 the gate.**

## What is deliberately not here

**The transposition operator `<^>`**, parked with the ML work — native `brainfloat` and `nf4`,
`tensor<float, A, B>`, and the keywords that make backpropagation expressible. Its own design, and
this plan does not pre-empt it (`entity.md` §15.1).
