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
| 11.5 | **escape analysis** | **DONE** — `heap-to-stack=49` on a small program | `entity`'s non-escaping row reference; `reentrant` |
| 11.6 | allocation hoisting and sinking | **DONE** — `hoisted=`, the per-iteration case | |
| 11.7 | **region binding, on the graph** | **the graph answers it**; the binder is held against it | `reentrant`'s region rule |
| 11.8 | **devirtualisation** — from `final`, `sealed`, `permits` | **DONE** — `devirt=4 collapsed=3` | **AP-01, AP-03, AP-04, AP-05** |
| 11.9 | reachability / DCE | runs, validated against `GlobalDCE` | the 302-vtables defect |
| 11.10 | contract lowering → `llvm.assume` | **already ran** — see below | |

### The §12 scoreboard, measured over the corpus instead of over one program

The `assume=0 tbaa=0 checked=0 devirt=0` line this plan opened with was read off **one** program —
and three of those four zeros were the program's, not the compiler's. Compiled over all 892 samples
and taking the highest each row reaches:

```
align 20962  assume 1071  checked 508  cold 17  collapsed 3  deref 2781  devirt 8
internal 1313  noalias 3  nonnull 4535  nounwind 2908  pure 19  tbaa 4670
```

**§11.10 was never missing.** `contracts.pol` hands over `assume=3`, `invariant_assume_readonly`
`assume=2`; the backend has emitted `llvm.assume` for `fact.requires` / `fact.ensures` /
`fact.invariant` at one site all along. What read zero was a sample with no contracts in it. The
same for `tbaa` and `checked`. **A scoreboard measured on one program measures that program**, and
this one had been quoted as if it measured the compiler.

`noalias` was the real zero — **3 across 892 programs**, the three `unique class` declarations in
the corpus — and §12.1 of `ownership.md` now records both what was done about it and what could not
be: the allocator's return is `noalias` (`codegen_allocator_is_noalias`), and `move` → `noalias`
**does not follow** from the language as it stands, because `Conn* b = a;` before `move a` is
accepted and leaves a second holder. That is a Part III language change, not a pass.

### 11.8, done — and what it cost to get right

The pass itself is small. What it needed was for the lowering to stop throwing away what it knew:
`Module::ClassShape` now carries `base`, `interfaces`, `permits`, `isAbstract`, `isFinal`,
`isSealed` and `openWorld`, and the module carries `slotMethod` and `replaceableMethods`. None of
that was recoverable from an LLVM struct, so §11.8 could only ever have been written back on the
AST — which is the arrangement §11 exists to undo.

**What is left for the pass, precisely.** `needsDispatch` already walks the whole program asking
"does anything under this class override this method", so a concrete class with no overriders never
reaches the pass. What reaches it is what that question cannot see: a static class that does not
*implement* the method, so there is nothing to call directly and the lowering has to say *only the
object knows*. That is every abstract base and every interface — and one implementation under an
abstract base is one candidate, not none. Exactly the ledger's complaint from four directions.

**The refusals, each from a fact already in the module rather than a second list:** a non-`const`
vtable global (which is `methods.replace` and `unimport` in one check), a `replaceableMethods` name,
an empty candidate shape, and a resolved key that names no function — a `call` naming nothing emits
*nothing at all*, silently.

**And the bug it had on the day it was written.** `openWorld` was asked only of the compilation
*writing* a library. Using one is the mirror image and worse: a `.polh` names a bundle's public
types and nothing else. A library with an abstract `Source`, a public `Visible` and a non-public
`Internal` hands out an `Internal` through a factory; the consumer could name two of the three,
counted one implementation, and compiled the call into `@Visible.rate`. It printed **3 where the
answer is 9** — Wave 2's `total = 17` seen in a mirror. `devirt_hidden_subclass_runs` is that
question asked by a machine, because reading the pass and believing myself is what produced it.

**The test shape Wave 3's exit criterion actually needs** now exists as
`tests/run_pass_matters_test.cmake`: compile twice, once with the pipeline whole and once with
`POLARON_PIR_PASSES` naming every *other* pass, and assert the **difference** — the direct call
appears only with the pass on, the `vtable.load` it replaced only with it off. A presence test alone
does not do it, and measuring on the `.ll` does not either: the backend's inline cache emits the
same direct call from the other side, so the assertion reads **PIR**
(`tests/run_pir_contains_test.cmake`), which is the module as the pass left it.

### 11.5 and 11.6 — one transformation, two proofs

The lowering marks an allocation `[heap]` and the matching `drop` the same way; the backend reads
that one note to choose between `__polaron_malloc` and a frame slot, between `__polaron_free` and
nothing. **So the whole transformation is removing a note from two instructions**, and a malloc, a
free, a header and a pointer chase stop existing. The destructor still runs — it is not part of the
note.

**The word doing the work is "provably".** A plain use-walk finds an escape immediately in code that
has none, because two things stand between every allocation and its uses:

```
%6 = alloca %Point [heap]
call @Point.Point %6, %2, %5      <- handed to its constructor, which is a CALL
store %6, %7:p                    <- put in a local,            which is a STORE
%9 = load ptr %7:p                <- and every later use comes back through it
```

A pass that calls both of those an escape fires on nothing and looks exactly like a pass that works.
So both are answered: a frame slot whose own address never leaves the function is not memory anything
else can reach, and *does parameter i of this method escape* is a module-wide summary computed by
fixpoint from every parameter escaping. A constructor that writes its arguments into `this` does not
leak `this` — the value stored is the argument — and that is what makes the pass fire at all.

**11.6 is 11.5 with one more thing proved.** A frame slot is one address reused every iteration, so
the loop case needs *no two iterations hold the object at once*; the condition asked for is the blunt
one, a `drop` in the same block after the allocation. `hoist_allocation_from_loop.pol` has both
shapes side by side and the refusal is the half with something to lose.

**Two things it must not do, and one of them cost a test.**

- `Test.liveBytes()` and `assertNoLeaks` (§32.11) make the allocator's accounting an **observable**,
  and nothing in the graph connects an allocation to the two calls that bracket it. A body that reads
  that accounting now keeps its allocations exactly where the author put them. `Polaron-0B1A` warns
  about the very line in question and its `fix` is what this pass does — the advice and the pass
  agree; what was missing is that a program *measuring* the heap is not making that mistake.
- Two `live_*` baselines came down to the prelude floor, and **the ratchet is what made me look**.
  `random_shuffle` writes `new Random(...) on heap` twice and deletes neither; `region_field_dtor`
  holds one the same way. Escape analysis proved they never leave their frames and gave them the
  frames, so the leaks are not there to count. The numbers were changed with the cause written beside
  them, not to make a test green.

### 11.7 — the graph answers it, and the binder is held against it

*"A dataflow question over the graph, not an AST pattern match."* The binder's central answer is
`escapesToReceiver`: per declared parameter, is it stored into the receiver — read off the tree by
pattern, to a fixpoint. §11.5 needed the same fact for a different reason and computed it from the
**instructions**: what is stored, what is returned, what is passed on.

So the question now has two independent answers, which is the arrangement §11.9 already has with
`GlobalDCE`, and `polc` holds them against each other on every compile. The implication runs one way
— *stored into the receiver* implies *escapes* — so the contradiction is narrow and real: a parameter
the graph proved never leaves, that the binder saw stored into a field. Reported and not fatal,
because a disagreement there is a compiler defect and stopping the build punishes the wrong person.

**What remains, stated plainly:** the *diagnostics* still run on the AST. Moving them means moving
the region binder's error reporting to after lowering, which changes when a program is refused and
is a larger change than this wave. What this wave settles is that the dataflow exists, is used, and
does not disagree with the pattern match.

### Exit criterion

> **No row of the §12 scoreboard reads zero without a written reason**, and for every pass there is a
> test that **fails when that pass is turned off**. The machinery exists: `POLARON_PIR_PASSES=<list>`
> runs only the named passes, and was written for exactly this kind of question.

Both halves are met. `tests/run_pass_matters_test.cmake` is the shape the second half needs: compile
twice, once whole and once with `POLARON_PIR_PASSES` naming every *other* pass, and assert the
**difference**. No row reads zero over the corpus, and the one that is nearly zero — `noalias` — has
its reason written in `ownership.md` §12.1 rather than a number nobody looked behind.

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

### DONE — and the answer is neither hypothesis

Written up in full, with every number, in **`polaron-ir.md` §15.5a**. In short:

**`__restrict` changes clang's output by not one instruction** — 282 both ways, zero SIMD. So it was
never doubt about aliasing, and `noalias` was never going to fix it: hypothesis 1 is dead, for a
reason worth keeping — *a fact can only help where the missing fact was the obstacle.*

Then reading GCC's assembly **for the case it does not vectorise** said what it actually does:

```
.L2: movslq (%r8), %rcx          ; load a[i].who ONCE
.L3: leaq   (%rdx,%rcx,2), %rdx  ; and add it twenty times, in a register
```

**GCC interchanged the loops.** The benchmark walks the array twenty times to get a measurable
duration, and GCC swapped the two so the walk happens once — one twentieth of the memory traffic, in
a benchmark whose whole subject is memory traffic. With one empty `asm` per round making the twenty
walks real (ps/read, five runs, median):

| | declared (32 B) | arranged / sorted (16 B) |
|---|---|---|
| **Polaron `-O3`** | **257** | **163** |
| C, `clang -O3` | 265 | 162 |
| C, `gcc -O3` | 337 | 197 |
| *C, `gcc -O3`, as written* | *113* | *57* |

**Polaron is level with clang and 24% / 17% ahead of GCC.** The single biggest performance target in
the ledger was a benchmark artefact. What survives is smaller and true: LLVM does not do loop
interchange, and its vectoriser wants unit stride where GCC's manages 16-byte stride — which is
exactly the band `layout` + `fitWithin` puts records in.

**And the lesson: four findings agreeing is not four confirmations when all four are downstream of
one benchmark shape.** Every timing loop in `anti-procedural-tests` repeats its work to get a
duration. Wave 8 re-measures them all against the honest form.

### The trap

Ordering the rest of the performance work before this has run. Until it has, any such ordering is a
guess. — *Sprung, and in the most expensive way available: the ordering was already written down.
`noalias` was named as the first thing to look at, and it was the wrong thing to look at.*

---

# Wave 4.5 — design closure

**Every `Still to design` table in every design document is emptied before a line of Wave 5 is
written.** A construct implemented with an open decision inside it has that decision made silently,
at the keyboard, by whoever gets there first.

| document | what was open | |
|---|---|---|
| `entity.md` §15 | lone entity legal · nested flattening · AoSoA now or later · how a `pass` names its row index · parallel asked or derived · `stable movable` | **all decided** |
| `layout.md` §13 | short-name collisions · inherited fields in a resolver · what a resolver may read of a field · `align` without the `padding` concession · `layout` over an `entity`'s columns | **all decided** |
| `dynamic.md` §10 | `dynamic` on an `abstract method` · constraint-only interfaces → `transformer`/`satisfies` · the four root methods · the freestanding representation reused per class | **all decided** |
| `ownership.md` §20 | does `movable` cross to values · the `Shared` escape hatch · `ArrayList` growth as a bulk move · `Shared` on a region | **all decided** |
| `reentrant.md` §10 | self-interrupting handlers and an exclusive region · `reentrant async` · `reentrant class` · what counts as shared mutable state · freestanding default | **all decided** |
| `enum-variants.md` §10 | generic enums · `match` over a payload · equality of a class payload · `catalog` over a parameterised case · the boxed form's survival | **all decided** |
| `asm-constraints.md` §6 | register pairs (`edx:eax`) · architectures beyond x86_64 · which class words | **all decided** |
| `freestanding-prelude.md` §9–10 | the three-tier split · the first cut · where `Machine` lives · core as a third bundle or gated | **all decided** |
| **`.polb` carries PIR?** | the right shape of the precompiled-prelude question (Wave 6) | **decided — below** |

### `.polb` carries PIR — decided: **yes, as a fourth section beside `code`**

`PolbBundle` today carries `polh` (the public API as declaration text) and `code` (LLVM bitcode).
The precompiled-prelude question is *what does a consumer skip*, and those two answer different
halves of it: `polh` skips **parsing and analysis**, `code` skips **emission**. Neither skips the
part in between, which is now where the work is — lowering to PIR and the §11 passes over it.

**So the bundle carries the module, and the consumer's choice becomes real rather than nominal.**
A third artefact, `pir`, holding the printed module for the bundle's own functions:

- **A consumer that only calls in** needs `polh` and links `code`. Unchanged, and still the fast path.
- **A consumer that inlines across the boundary** — which is what a precompiled prelude is for, since
  `String.length()` must inline or the prelude is a call per character — needs the bundle's PIR, so
  its own §11 passes can see through the call. Bitcode would work too, and it is the wrong level:
  §11.8 needs `Module::classes`, `slotMethod` and `replaceableMethods`, none of which survive the
  drop to LLVM. **A bundle that carries only bitcode can be inlined into and not reasoned about.**
- **And the ABI reason, which is the one that settles it.** Wave 2 recorded *"the `.polb` still came
  from the other back end"* and handing the bundle to PIR failed twenty tests. That is exactly the
  hazard of two producers for one artefact — and it is over, because there is one back end now. The
  section is added at the moment the question of which producer wrote it cannot arise.

**Versioned by `abiRevision`, and a missing section is not an error.** A `.polb` without `pir` is a
bundle built by an older `polc`; the consumer links its `code` and does not inline through it, which
is today's behaviour exactly. That is what makes this additive rather than a format break — and it
is the same shape as `vtableSlots`, which was added for the same kind of reason.

**What it is not:** it is not a replacement for `code`. Shipping only PIR would make every consumer
re-run the backend over the whole bundle, turning a link into a compile — which is the toll Wave 6
exists to remove, paid twice.

### Exit criterion

> No design document under `docs/design/` contains an open item. Every table above reads *decided*,
> with the decision and its reason in the document.

**Met.** Nine tables, thirty-five decisions, each with its reason in the document that owns it. One
item is deliberately **parked and not decided** — `entity.md` §15.1, the transposition operator — and
it now carries the condition that gets it out: *designed with the ML work or not at all*, because two
of its three unresolved points are answered there or nowhere. **A parked item that names no condition
is an open item wearing a better word**, which is what it was before this wave.

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

### Landed so far

| | what it closed | measured |
|---|---|---|
| **`super.method()`** | AP-29's residue | six levels of refinement cost what one level costs — the chain collapses to `load` + `add i32 %1, 57`, against **4.5×** for six dispatched levels |
| **`asm` operand constraints** | AP-18's detail | C's 13-byte lead is now **2** — 36 bytes against 34 |
| **`dynamic`** | **AP-02 outright** | `class Tag` is **8 bytes**, down from 16; `%class.Tag = type { i32, i32 }` |
| **`unique` over values** | the containing half of AP-09 | already worked; what was missing was §6.1's diagnostic — it now names the *field* and the type as written |
| **`shareable`** | AP-09/AP-33's residue | a modifier, not a marker interface, and **checked**: every mutable field `atomic` or itself shareable, or the type immutable. A `shareable struct` is 4 bytes — as an interface it would have been 12 |
| **`move` to a thread** | the fourth way across | a third capture mode, and the source is invalidated — so *sole holder* is enforced rather than asserted |
| **`reentrant`** | AP-11, and AP-12/AP-17's holes | one walk, two sets of roots. `interrupt`'s bespoke list collapses into one property, and it **catches the lock** |
| **`comptime if` prunes** | `layout`'s resolver, `Machine`'s partition | the untaken branch is parsed and *nothing else* — the sample's dead arms call three methods declared nowhere |
| **`Machine`** | AP-19's residue | a second prelude bundle, six subjects, partitioned by `__target_arch`. A freestanding program has a library instead of a refusal |
| **`enum` with payloads** | user-declared value sums | the language had two sums — `Result` and `Option` — written out in the prelude by hand, with their four case names built into the parser, the type checker and the lowerer. `enum` over cases that carry data now **produces the same declarations**, so a user sum inherits monomorphisation, exhaustiveness, positional destructuring and the tag test without a second mechanism |
| **`entity` + `pass`** | **AP-06 — the last objection standing whole** | `&swarm[1].x - &swarm[0].x` is **4**, and `&swarm[0].y - &swarm[0].x` is **400** over a hundred rows. Under the row arrangement they are 8 and 4 — and every value in the sample reads back correctly either way, which is why the addresses are what the test asks |
| **`layout` redesigned** | **AP-16's live defect** — which was not a missing feature but a wrong answer — and AP-09's placing half | `arranges` replaces `implements`; `permits reorder, padding` on the layout; the refusal names the concession with its number; and the target resolves itself with `place`/`isolate`/`align`/`pad`. `WireA` and `WireB` — the same four fields in two orders — measure **12 and 8** where they used to measure 8 and 8. And `isolate` is **64 bytes apart**, measured as an address rather than a size, where the compiler's own strategy gives 4 at the same total |

### `layout`, and what it cost to get right

**The defect was the default, and the default was invisible.** Under the first design, naming any
layout authorised the compiler to permute the fields — so the case `layout` is most reached for, a
format that something outside the program also indexes, was the one it got wrong. The repository's
own example is called `WireRecord` and its message reads *"a wire record is 32 bytes; both ends index
it"*; two declarations of it written in different field orders both measured 32, both compiled, and
disagreed about every offset. §3.1 called this *"today a `layout` for a wire format is wrong, and the
repository's own example is one"*, and it was.

**A size check could not have caught it, and that is the general lesson.** Two declarations differing
only in field order come out the *same size* once both are sorted — precisely the number a test would
have compared. Only the offsets differ, and the language exposes no offsets. So the regression test
reads the first byte of a value through its own **address**, and declares the same four fields twice
in two orders, so that *the compiler made both ends agree* becomes two numbers that must differ.

**And the diagnostic is the feature, not the trimming.** Making the concession explicit reintroduces,
on its own, exactly what `layout` was written to avoid: a check that merely refuses where the problem
could have been solved. It does not, because the compiler can answer the question it raises — it has
the fields and it has the target's data layout, so it measures the other arrangement and quotes it:
*"`Small` does not permit reordering, and with `permits reorder` it measures 8, which fits"*.

**The resolver's one surprise, and it is the load-bearing part.** A boundary cannot be RECORDED on a
field and left to the backend: what the backend emits is a struct type, and `{ i32, i32 }` puts two
counters four bytes apart whatever is written down about them. So `align` and `isolate` **materialise**
the gap as real padding, exactly as `pad` does — and the *tail* is rounded up too, because stopping at
68 puts the second element of an array 68 bytes in, its first counter sharing a line with the previous
element's second. The guarantee would have held inside one object and failed one subscript away, which
is worse than not holding: it is a `demand` that passes.

**And two defects found by building it, neither in the new code.** `resolveImplicitThis` runs before
layouts are resolved and rewrites every unqualified member reference, so `itself.place(head)` arrives
as `this.head` — nothing has told that pass which methods are resolvers, because that is decided from
the layout's `resolvedBy` afterwards. And `cloneMember` dropped `isLayoutResolver`, which is the ninth
instance of that hole: the consequence is not a missing feature but a resolver silently becoming
ordinary code, so the first thing the compiler says is *use of undeclared variable 'itself'* about a
line that is not wrong, in a file the author will not connect to the `typealias` that caused the clone.

**Still open:** §13.2's inherited fields, §13.5's `together` over entity columns, and §11's extension
to non-`dynamic` classes. §8.2's topological order over containment is not needed yet — a resolver
that read another type's `sizeof()` would need it, and the four verbs as built read only the target's
own fields.

**`enum` with payloads is a desugaring, and that is the whole of why it was affordable.** `Result<T,E>`
was already a sealed abstract base with one class per case and a value representation; the word `enum`
over payload cases emits *those declarations*. The parser tells `Circle(double radius)` from
`BRIGHT(Level.HIGH)` by what is inside the parentheses — strip a trailing name, and what is left must
be a non-empty type that does not end in a dot, which is exactly what separates `Errors.Fault f` from
`Level.HIGH`.

**And it found a hole two sizes larger than itself.** *"Nothing reads `Circle.radius`"* was reported
about a field two lines under a `case Circle(double radius)`. The narrow reading is that
destructuring needed recording. The true one: **`advice.cpp`'s index walked six statement kinds, and
a `match` was not one of them** — not its subject, not its arms, not one expression inside them. In a
language that pushes you toward matching on a sealed sum, every rule that consults that index was
blind to most of the program: the field an arm reads looked unread, the method it calls looked
uncalled, the type it holds looked never held. `switch`, `defer`, `using`, `throw`, a labelled
statement, a match *expression* and a lambda body were the same.

**`entity` is the objection that stands, and the measurement had to be of addresses.** *"A loop over
one field of ten thousand objects touches ten thousand cache lines where a column touches six
hundred, so at this level you must abandon the type."* Polaron could already reach C's numbers with
eight parallel `float[]` — and then the thing the program is about has no type. What is built:

- **transposed storage**, one block, columns end to end, with no padding between them by construction;
- **`swarm[i].x`** reads and writes the column — no row is assembled to be discarded a field later;
- **`Particle p = swarm[i]`** materialises a copy, which is the second representation §15.4 decides;
- **`pass`**, whose loop is *inside the callee with the body lowered into it* — a method called per
  row would give every number and hand back the cost the construct exists to remove, so the absence
  of a call in the pass's own body is asserted;
- **`reads`/`writes`** and **`index i`**, the row's position bound by the word `foreach` uses.

> **Two words of `entity` are refused rather than accepted.** `sparse` (a column stored by presence)
> needs an index of its own beside the block; `stable` chooses between the two ways a row can be
> deleted, and deleting a row is not built. Both are designed, in `entity.md` §7 and §8. Accepting
> either would mean the author writes a guarantee down, gets no diagnostic, and gets no guarantee —
> so each refusal names which of the two it is. `Polaron-0410` covers the third restriction, which
> is real and permanent in shape: a field with no width decided at its declaration has no column
> offset to give.

**Three defects found by writing these, and none of them in the new code.** `(q - p).toString()` on
an `address` **segfaulted in any program** — the receiver fell through to the lookup by bare name,
found `StringBuilder.toString`, and read a length out of a machine address; reachable by four
keystrokes since `address` existed, with nothing said at compile time. A speculative lowering that is
then rejected gets lowered *again* by the path below it, which **doubles at every level of a call
chain** — the compiler stopped responding on any program containing an `entity`, inside the prelude's
`Sha512`. And `emitCall` hands back `kNoValue` for a void call, which is the same word "I did not
handle this" is spelled with: `swarm.advance(2)` was emitted twice and the sample printed 24 where
the program says 12.

**`super.method()` was already lowered.** The lowering matched it and emitted a call to the base by
name, with a comment saying why it must not dispatch; the analyzer one layer above refused it with a
message describing the only use anyone had needed. Writing the test then found a second bug: a
`super.m()` whose immediate parent is silent named a key nothing defines, and **a call naming a key
nothing defines emits nothing at all** — undef, presenting as an access violation with no diagnostic
in the compile.

**`dynamic` is the one that cost.** The eight bytes came from *one loop in the driver* giving
`extends Object` to every hosted class, and removing it surfaced four latent defects — each a place
where the header's presence had been compiled into a constant:

- `needsDispatch` emitting a table lookup for a class with no table: it loaded field zero, read the
  `int` living there, and jumped through it;
- the weak-list head hardcoded at 8, *"right behind the vtable"*, for classes with nothing in front;
- `delete` dispatching the destructor through a slot on classes that have no slot;
- a `--lib`'s public class laid out **with** the header on one side of a bundle boundary and
  **without** it on the other, so a field declared 7 read back 42 and linked without a word.

All four were wrong before and unreachable before. Each is now an invariant stated where the decision
is made rather than a constant repeated at three call sites.

**Four defects in the compiler's own advice and machinery, each found by real code the hour it was
written** — which is the argument for building the library rather than describing it:

- **`asm` outputs were not assignments.** `mutable int v = 0; asm { in al, dx } out ("al": v);` drew
  *"'v' is declared mutable and nothing ever assigns to it"* against the one line whose purpose is
  to assign to it. Every port read in `Machine.Port` is that shape.
- **The bounds-elimination advice fired on raw pointers**, which have no length and no check to
  prove away: it told the author of `copy(to, from, count)` to count to `p.length()`.
- **The cloner dropped `comptime`.** A program containing a `typealias` sends bodies through the
  monomorphiser, which forgot the word — so a `comptime if` became a runtime one, both arms lowered,
  and `asm("i686")` reached an x86_64 assembler *from inside the standard library*. Eighth instance
  of that hole; see `polc-clone-fidelity`.
- **"Is this the prelude" was a name comparison.** `b.name != "System"` held for exactly as long as
  the prelude was one bundle; the day `Machine` arrived every program had two "authored" bundles and
  the public-with-no-outside-use rule fired on every public type again.

> **One debt, and it is one word.** `assignObjectRoot` still gives the implicit root to
> `bundle.isPrelude`. Something in the prelude depends on the eight bytes; the symptom is a heap
> overrun whose effect changes with whether stdout is a console or a pipe, because the stdio buffer
> moves under it. User code does not pay — a `class Tag { int id; }` is four bytes — and the prelude
> will stop paying when that is found. The condition is one clause in `src/cli/main.cpp`, and this is
> where it is deleted.

---

# Wave 6 — the toll and the tools

| | worth |
|---|---|
| **precompiled prelude** — as *"does `.polb` carry PIR?"*, decided in Wave 4.5 | **measured by phase, and the section is BUILT — see the two rows below.** Building it found eight defects in the text form, and the round trip that was Stage 0's acceptance criterion had never once been run on a real module |
| **`switch` → jump table** | **DONE** — the row below has the measurement. Not 20%: between 1.00× and 7.2× depending on something neither the language nor the arm count decides |
| **vtable emission** — 302 tables for a 16-class program; PIR's slot space is twice the trusted path's | **measured, tried, reverted — the row below is the finding** |
| **mangle by representation** | **measured — the row below has the numbers and the condition** |
| **DWARF `DICompositeType`/`DIDerivedType`** | **DONE for value types and scalars; pointers are the honest limit — the row below** |

### Exit criterion

> Each with its measurement, before and after, in the finding it closes.

### The `pir` section, in full — a format nobody reads back is a format that is correct by assumption

**`.polb` carries the module now**, as Wave 4.5 decided: a fourth section beside `polh` and `code`,
holding the printed PIR. `polh` lets a consumer skip parsing and analysis, `code` lets it skip
emission; neither skips the part between them, which is where the work is. An empty section means
*do not inline through me* and is what an older bundle reads as.

**And writing it found that PIR's text form did not round-trip.** `parse(print(m))` printing
identically is Stage 0's entire acceptance criterion, and nothing had ever run it on a module a
compiler produced — so it held for modules with no generics in them, which is no module anybody
compiles. The first attempt failed at **line 60 of 175 440**. Eight defects, none subtle, all
invisible:

| | |
|---|---|
| **no `type` declarations at all** | the printer emitted none and the reader's branch for them SKIPPED them, *because the types are rebuilt from their uses* — true of a structural type and false of the only kind that line sees. `gep ptr @level of %Mixer imm 1` names a struct and gives an index into fields the reader is told nothing about, so a module read back had the right instructions over EMPTY structs |
| **`blocks_` was module-wide** | the second function's `^entry` resolved to the FIRST function's block. Which is why the smallest reproducer is two functions, each of which parses perfectly alone |
| **blocks came back in MENTION order** | a `br -> ^forstep11` precedes `^forstep11:`, so the pre-scan had to take only labels that START a line. This one parsed and produced a valid module that was a **different** one — and block order is not decoration, since the backend lays them out in it |
| **`%` is a value and a type; `[` an array and an extra; a parameter may be named `ptr`** | three ambiguities settled by guessing at the word rather than reading the structure. `%1:ptr : ptr` had its NAME read as its type |
| **a float printed at six digits** | `2147483647.0` came back as 2147480000 — a constant silently changed by writing it down |
| **a `fact.requires` spanned lines** | one token over twenty lines, in a format whose lines are its structure. Every line after the first read as a new instruction |
| **mangled names** | `$`, `*`, `~` in `ArrayList$Certificate*` and `~Some$String`. The printer now QUOTES what the reader will not take bare, so the next mangling character costs nothing |
| **and the block pre-scan did not run** | `atEnd()` skips whitespace and does not put the line counter back, so the `sameLine()` asked after it compares a token's line with itself and answers yes forever. A fix that reads correct and never executes — found only because the reprint was still wrong after it |

`--check-pir <file>` runs the criterion, and reports the first differing LINE from each side plus the
whole reprint as a file, because two 175 000-line modules that differ somewhere are a job for `diff`
and not for a message.

### The prelude row, in full — the whole front end is the standard library, and the parse is 9% of it

**An EMPTY program costs exactly what a hello-world costs.** `polc --check` on a program whose only
content is `main() { return; }`:

```
[phase] appendPrelude            22 ms
[phase] resolveImplicitThis      13 ms
[phase] monomorphize             49 ms
[phase] sema.analyze            152 ms      total 250 ms
```

and on `hello_world.pol`, the same figures to the millisecond. The user's own code is free; the
250 ms is 20 750 lines of standard library, re-parsed, re-monomorphised and re-analysed from scratch
on every compilation.

**That reframes what "a precompiled prelude" has to be, and the obvious reading is the wrong one.**
Caching the parsed AST -- what the phrase suggests, and what this row carried -- saves
`appendPrelude`: **22 ms of 250, nine per cent**. What costs is the analysis.

**How much of the analysis is the bodies**, measured rather than guessed, with a switch added for the
purpose (`POLARON_SKIP_PRELUDE_BODIES=1`, documented in the source as a measurement and not a
feature): `sema.analyze` goes **152 ms → 99 ms**. So the prelude's method bodies are 54 ms and its
DECLARATIONS -- signatures, imports, type registration, the class table -- are 99. A cache has to
carry both to be worth building.

| what a cache would have to hold | what it saves |
|---|---|
| the parsed AST | 22 ms |
| ...and `resolveImplicitThis` | 13 ms |
| ...and the monomorphised instantiations | 49 ms |
| ...and the analysed declarations | 99 ms |
| ...and the method facts from the bodies | 54 ms |
| **everything through analysis** | **~237 of 250 ms** |

**And the last row is not optional, which is the trap.** The prelude's bodies are where its
`methodFacts_` come from, and the `interrupt`/`reentrant` reachability walk follows those INTO the
library -- so a cache that keeps signatures and drops bodies makes a handler that calls a prelude
method which allocates compile clean. That is the same hole that was closed this same day at the
other end of the walk (a constructor and a destructor having no facts row at all). A precompiled
prelude is a serialisation of the analyzer's tables, not of its input.

### The DWARF row, in full — the metadata was present and wrong, which is worse than absent

**Every local was declared to DWARF as a 32-bit signed `int`**, whatever it held. One line did it:
`createAutoVariable(..., diInt_)`, with `diInt_` a single basic type built once at start-up. So a
debugger stopped on the right line, with the right name in scope, printed a `double` as its low half
read as an integer, a pointer as a small negative number, and an OBJECT as whatever four bytes sat
at its address.

That is worse than having no debug info: an absent variable is a question, and a wrong one is an
answer. And the existing test could not see it — it asked whether the `.ll` contained
`!DILocalVariable`, which it did, 
for every one of them, all wrong.

**What it emits now.** A `diTypeOf(const Type*)` over the PIR type table: a basic type per integer
width, a `float`, a `boolean`, an unsigned integer for an `address` (a number the program does
arithmetic on, not a pointer to print), an array that is the elements when it is inline and a
pointer when it is a heap array, and a **`DICompositeType` per struct with its fields as
`DIDerivedType` members** -- honouring a `layout`'s stated offsets where there are any, so a hardware
register block prints correctly rather than plausibly. Memoised by type entry, with the placeholder
inserted before the members are built so a class holding a pointer to its own kind terminates.

**THE HONEST LIMIT: a pointer's pointee is gone from the IR.** LLVM 17+ pointers are opaque and PIR
followed, so a `Ptr` entry mostly carries no `element` -- and a `DW_TAG_pointer_type` with a null
base is a pointer to `void`. `p here` on a class instance still prints the address and stops. The
code reads `element` where the lowering did record one; making that always true means the lowering
keeping the pointee on every pointer entry it makes, which is a change to the type table rather than
to the backend. Value structs and scalars print correctly today, which is most of what a debugger
stopped in a method is asked.

`run_debuginfo_test.cmake` now checks for the composite, the derived members, `DW_TAG_structure_type`
and a `float64` basic type -- the last because a basic type that is not `int32` is the cheapest
possible evidence that a variable's own type reached the metadata rather than the default.

### The mangle row, in full — measured, and the condition it turns on

A `hello_world.pol` carries **2827 functions, 731 of them monomorphised**. The families and the type
arguments each is instantiated at:

```
ArrayList          Annotation ArrayList Certificate Field Object Route String Type  boolean int long
ArrayListIterator  (the same eleven)
Iterable           (the same eleven)
Iterator           (the same eleven)
Option / Some / None (the same eleven)
HashMap            String int
```

**Eight of those eleven are class types, which is to say one representation.** `ArrayList` is
instantiated eleven times at thirty methods each — 360 functions — where four instantiations would
do: a pointer, a `boolean`, an `int` and a `long`. Across the pointer-shaped families that is
roughly 731 monomorphised functions where about 300 would do, a **~59% cut**, and it is compile time
as much as image size: every one of those bodies is lowered, verified and optimised.

**The condition, which is why this is a row and not a patch.** Sharing an instantiation across type
arguments requires that the body use the type parameter for its REPRESENTATION ONLY. A generic that
writes `new T(...)` needs T's constructor; `x is T` and `cast<T>` need T's vtable; `T.something()`
needs T's statics. None of those survive being keyed by representation, and getting it wrong is not a
diagnostic -- it is a call into another type's method with the receiver of this one, which is the
same class of fault as the two the network-card work turned up tonight.

So the rule is: **key by representation only where the generic's own body never names T except as a
value.** That is a scan of the instantiated AST for `new T`, `T.`, `is T` and `cast<T>`, and it has
to agree at every CALL SITE as well, since the mangled name is what a caller links against.

**Not landed at the time of writing**, deliberately: the measurement is solid and the analysis is
half a day's work with a miscompile at the end of the wrong version of it. Two miscompiles were
found by dogfooding this same night (a call inside a string concatenation running twice; a struct
returned by value passed as `this`), and both were invisible until a program with a side effect went
through them. A third, introduced at speed, would be worse than the 431 functions it saves.

### The `switch` row, in full — a cliff removed, not a speedup delivered

**What was there.** `Op::Switch` existed in the IR: `module.h` declared it, `module.cpp` named it,
`print.cpp` printed it and `verify.cpp` had a rule about it — and **nothing emitted it, and
`tollvm.cpp` had no case for it at all.** Had anything emitted one, it would have fallen through the
backend's instruction switch to nothing: a block with no terminator, which is an LLVM verifier error
and not a Polaron diagnostic. An opcode the IR can express and the backend cannot translate is a
hole that stays quiet exactly until something uses it. Every `switch` lowered to a chain of equality
tests, one block and one compare and one conditional branch per arm.

**What it is now.** A `switch` whose case values are all compile-time integers, over an integer
subject, is one terminator. Everything else — a `String` subject, a Java-style enum, a case value
that is not constant, a repeated value — still lowers to the chain, which is what makes those work
at all. The decision is made from the *source*, through `comptime::evalInt`, and emits nothing while
deciding: lowering a case value speculatively and lowering it again in the chain is the shape that
made a program with an `entity` hang.

Two things had to be true for it to reach real code. `comptime::evalInt` had to answer for an enum
member during *lowering* and not only during checking — the analyzer's context had `enumOrdinal` and
the lowerer's had only `enumCount`, so `case Dir.EAST` was constant in one phase and not in the
other. And a `fixed` class member had to fold, because that is how Horizon spells a syscall number.

**The trap, which the test suite already held.** `Planet.MARS` answers an ordinal when the folder is
asked for one — but a Java-style enum's *value* is a singleton object, and its arms compare
identity. A rule that decides "closed set of integers" by asking the folder about each case takes
that program too and compares a pointer against 0, 1, 2: every arm misses and the whole switch takes
its default. `codegen_switch_enum_java_runs` is what says so.

**The measurement.** All at `-O2`, best of five, every pair producing the same checksum. `chain` is
the compiler with the new path disabled; the benchmark is `performance tests/dispatch.pol` and the
generated variants beside it.

| arms | what each arm does | chain | table | |
|---|---|---|---|---|
| 8 / 16 / 24 | one add | 24 / 24 / 29 ms | 24 / 24 / 29 ms | byte-identical machine code |
| 48 | one add | 160 ms | 29 ms | **5.5×** |
| 96 | one add | 161 ms | 30 ms | **5.4×** |
| 200 | one add | 216 ms | 30 ms | **7.2×** |
| 48 | eight kinds | 161 ms | 162 ms | identical |
| 64 | eight kinds | 125 ms | 124 ms | identical |
| 200 | eight kinds | 216 ms | 168 ms | **1.29×** |

**Read the table, because it does not say what it looks like it says.** LLVM's own `SimplifyCFG`
recovers a `switch` out of a compare chain — often. When it does, emitting one changes nothing at
all. When it does not, the cost is between 1.3× and 7.2×. And **what decides is not the arm count**:
48 arms of one `add` each falls off the cliff and 48 arms of mixed arithmetic does not. It is
whether the arms are small enough that `SimplifyCFG` speculatively flattens some of them first,
which breaks the closed set before the chain-to-switch recovery ever looks at it.

So the honest claim is not "a speedup". It is that **the cost of the language's own construct for
closed sets no longer depends on an optimiser heuristic nobody can see from the source.** A program
whose dispatch is 5× slower than the identical dispatch written with two more instructions per arm
is not a performance problem anyone can debug.

**Horizon, which is where this was expected to pay and did not.** The kernel's syscall entry is 97
arms of `case SyscallNr.Write` — every call from every program. Its emitted IR before and after is
identical except for block *names*, and by exactly 100 of them: the `nextcase` blocks the chain used
to create. `SimplifyCFG` had been recovering that one all along. The gain there is 100 fewer PIR
blocks for every pass to walk, and no longer being one refactor of an arm away from the cliff.

**What is smaller in every case.** PIR, which every §11 pass then walks. On the 64-arm benchmark's
`main`: 82 → 58 blocks and 320 → 248 instructions.

**One rule got better on the way.** `Inst` carried `std::vector<int64_t> cases` "parallel to
`edges[1..]`" — two arrays that had to stay the same length, which is a type nobody wrote down. The
printer had already grown an `i - 1 < in.cases.size()` guard against the skew, and verifier rule
18's second half was arithmetic on the two lengths *whose message said the opposite of its
condition* — what a check nothing exercises decays into. The value lives on the `Edge` now. Rule 18
checks a property instead: a `total` switch's default edge leads to `unreachable`, which is the
thing the backend can actually use, since a default it can prove is never taken is a range check it
can drop.

### The vtable row, in full — a measurement that was real and a fix that was not

The number is worse than the row above claimed. A **hello-world** carries **298 dispatch tables of
1151 pointers each**, almost every entry null: 2.7 MB of table to dispatch nothing. The cause is
structural rather than accidental — the slot numbering is *global*, one number per distinct method
name in the program **and its prelude**, so a dispatch is a fixed index and every table must be long
enough for the highest index anything reads. `padVtables` therefore pads all of them to
`vtableSlot_.size()`, and that is the count of every method name the prelude defines.

Two narrower rules were written and both were taken out again:

1. **as wide as the highest slot with a surviving body.** Wrong: it reads `fns_`, the map of
   lowered function bodies, and the two spellings do not always agree — a class shadowing a
   standard-library one resolves its bodies under a key that map does not hold. The table came out
   one pointer long and the dispatch was an access violation, not a diagnostic.
2. **as wide as the highest slot any table CLAIMS**, which is the compiler's own record and cannot
   be wrong about what a class responds to. Still wrong, for a reason the first rule hid: `unimport`
   and `methods.replace` **write slots that are null in the image** — that is what they are for — so
   "nothing in it now" says nothing about what a dispatch reads later.

Each broke the same five tests in two unrelated groups (`codegen_unimport_*` ×3,
`codegen_shadow_stdlib_*` ×2).

**And the saving was not there to begin with.** Every one of those tables is all-null, so LLVM emits
`zeroinitializer` and the linker puts it in `.bss`. `hello_world.exe` is **297984 bytes with the
full-width tables and 297984 bytes without them**. What 2.7 MB of null table costs is address space
and a page-zeroing at load — not one byte of the image. The row's "72 KB" was counting a saving that
the object format already makes for free.

So the honest state is: **the measurement stands, the fix does not exist at this layer.** The real
fix is **per-hierarchy slot numbering** — a class's table as long as its own chain, which is what
every C++ ABI does — and that is a change to the slot list a `.polb` carries and to what a consumer
adopts, not to the emitter. It is a Wave 6 item in its own right and it is *not* closed. The finding
is written at both sites in the code (`pir/lower.cpp`'s `padVtables`, `pir/tollvm.cpp`'s
`emitGlobal`) so the next person to measure the widths finds the two dead ends before walking them.

---

# Wave 7 — the advice system

Nine entries, found by taking the compiler's own advice until every file compiled clean: `0B2B`
counting sites not allocations, `0B47` advising a remedy that does not compile, `0B40` twice, `0B45`
silent on the textbook case, `0B0C` blind to a declaration-site `[Allow]`, `0B3C` firing on the shape
its own fix recommends, `[Allow]` a parse error before a local, and codeless warnings that cannot be
allowed at all.

Last on purpose: several read differently once the constructs above exist. **That is a reason to
sequence them last, not a reason to leave any of them.**

### All nine, closed

| | what it was | what it is |
|---|---|---|
| **`0B2B`** | counted `new ... in region r` SITES. A loop is one site and N allocations — the shape the rule's own reasoning calls *earning its keep* | a site inside a loop counts as more than one, so the rule reports only a region that really does hold one object |
| **`0B47`** | its fix said `fixed int SLOTS = 8 * 8;` in the place the local was, **a line that does not parse** — `fixed` is a member modifier | the fix names the class, which is what the message itself had been saying all along |
| **`0B40`** (i) | fired on a raw pointer, which has no length and no check to prove away — every byte primitive in `Machine.Raw` | a `T*` is exempt: the advice was to call a method that does not exist about a check that is not emitted |
| **`0B40`** (ii) | fired on a CONSTANT bound over an array of CONSTANT length — `new byte[12]()` walked to 11, the commonest shape a scratch buffer has | exempt, and the prelude's count fell 172 → 159. Its fix was strictly weaker than the constant *and* ran the loop one element further than the author meant |
| **`0B45`** | skipped classes: *"only an inline aggregate has a layout the author's order decides"*, which confuses WHERE the bytes live with WHETHER the order costs | a class is reported too — and it is the more expensive case, since a struct's holes cost a few bytes of stack per call and a class with a million instances carries a million copies |
| **`0B0C`** | could not see a local's `[Allow]` at all, because there was none to see | reports a stale one per declaration, exactly |
| **`0B3C`** | fired on the shape its own fix recommends: *wrap the address in a type that owns it and frees it* IS a class with an address in a field | a class with a destructor has made the lifetime its business, which is what the rule was asking for |
| **`[Allow]` on a local** | a syntax error. The one kind of advice that is ABOUT a local could not be answered at all | parsed, attached to the declaration, and read **by name** at the report — a frame would have covered the rest of the method and silenced every other local in it |
| **codeless warnings** | one survived: the generated-key warning was a bare `fprintf(stderr, "warning: ...")` — no code, no file, no line | `Polaron-0B50`, at the field's own line, with why/fix/prevent and an `[Allow]` that works |

**Two of the nine were asserted by the test suite as correct behaviour**, which is the finding worth
keeping. `lint_final.pol` declared a class that allocates in its constructor and frees in its
destructor — the exact remedy 0B3C recommends — and a test pinned the warning about it. The compiler
was tested against the defect, so the defect could not fail.

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

### Where it stands — every bare `open` row has been re-run

**The rule the ledger sets for itself is the whole of the wave:** *a row is not closed because
somebody remembers fixing it — it is closed by running the reproducer again and writing down what
came out.* Twenty-one rows were re-measured earlier; the six that still said a bare `open` were the
ones nobody had gone back to, and *that is a different thing from knowing they are still true.*

**Five of them were the severe ones, and all five are closed by their own reproducers:**

| | what the re-run printed |
|---|---|
| **a bare `Object`'s vtable** — *"an indirect jump through uninitialised memory"* | `hash 0` / `eq true`, exit 0. Two virtual calls and not one, because a table with one right entry would have passed the row's own test |
| **an array leaked through a FIELD** — *"worst consequence found so far"* | eight objects each owning a 24-element array end at **112 bytes in 5 blocks**, which is the baseline every clean program ends at. A failure would be 8 × 112 more |
| **an array of structs strided by the SUM of its fields** — *"most serious found so far"* | `byte, long, int` measures **24**, not the 13 the fields sum to, and all four elements read back every field |
| **the value `Result`/`Option` on the heap** | `value_try.pol` emits **two** `__polaron_malloc` in the module and both are the runtime's `argv`. Counted in the module rather than at runtime, because an allocation that is freed leaves the live count where it started |
| **destructors skipped on the unwind path** | `dtor inner` then `caught`, in that order. The ORDER is the assertion: running after the handler prints the same two lines and means the opposite |

**And the sixth closed as written and left something behind, which is the one worth reading.** *A
user type re-points name resolution inside the standard library* no longer happens — the collision
warns under `0B02` and compiles. But a colliding name still costs, and the cost had moved: a class
renamed for a collision goes through `cloneClass`, and **the cloner dropped the layout's
`onArrange`**. A `layout` anywhere near a collision — or near a `typealias`, which sends every class
in the program through the same path — silently stopped checking `fitWithin` at all.

That is the tenth time a field added to `ClassDecl` was dropped by the clone, and the first where
what was lost is a **guarantee** rather than a line of output: the other nine made a program print
less, this one makes a program that violates its own stated size budget compile clean.
`layout_survives_the_cloner` holds it, and the `typealias` in that sample is the entire test.

**What still says open** is the four optimisation rows — vtable emission, devirtualisation through a
base pointer, PIR's slot space, per-instantiation generics — each re-measured with numbers, and the
compile toll, whose **carrier is now built** (the `.polb` `pir` section) while the cache is not.

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
