# The PIR shape baseline — what the two backends differ about, and why

`--compare-ir` compares the two backends' bodies shape by shape. It existed before this file and
**gated nothing**: a census over all 874 samples reported **9 402 differences and zero programs in
full agreement** — a report nobody can act on. Five memory defects walked past an instrument that was
already built; making it readable found **five more within the hour**, one of which is an access
violation and two of which break the language's own guarantees.

This file is the classification the gate needs: **every systematic difference, named, with a
disposition.** `tests/run_pir_shape_test.cmake` checks it **by kind and not by count** — a count lets
a new defect hide on the day an old one is fixed.

## The two instruments, and what each is blind to

Neither gate is sufficient alone, and each has caught what the other could not:

| | sees | blind to |
|---|---|---|
| **the shape gate** | anything the two modules build differently, including on a path no sample runs | a difference sharing a line with a class already matched — a line carries up to three disagreements and is classified by the first that matches |
| **`POLARON_LIVE`** | memory the program still holds at exit, by an absolute number | **only heap blocks.** A region's memory comes from the arena, so D13 — objects in a region never destructed — moves neither total |

The `generator.pol` leak reached the live check and not the shape gate: its free-count lines were
already classified as D6 while its unclassified lines were about names. D13 went the other way — the
shape gate saw the missing teardown call and the live totals matched exactly.

## What this instrument cannot see, and why it matters more than it looks

**PIR was built against the trusted path as its oracle.** The two were meant to produce the same
thing so PIR could be verified and PIR-specific problems cut out — PIR is LLVM's IR carried up to
hold everything Polaron knows. So **a defect present in both is invisible here, by construction.**
This file measures *divergence*; an inherited error does not diverge.

Two consequences that govern how it is read:

- **"the trusted path is right" is not a finding, it is the differential's tie-break rule** (*"where
  they differ, the old path is right until proven otherwise"*). Every defect below that is more than
  a tie-break says what independent standard it fails: the runtime's own written protocol (D1), the
  compiler's own decision (D2), a crash (D5), an atomic that is not atomic (D7), the no-UB principle
  (D8), a destructor that does not run (D9), the recorded claim that async suspends (D11). **D3, D4
  and D10 rest only on the comparison, and those three are exactly the ones marked candidate.**
- **The fixes go into PIR only.** The trusted path is deleted at the end of this plan; repairing it
  is work that gets thrown away, and the differential's job is to be a comparison until then.

**What covers the blind spot is absolute checks**, not this one — `PLAN.md` Wave 2 already requires
every differential check to become an absolute one *before* the deletion. That requirement is
stronger than it reads: absolute checks are not only for after the trusted path is gone, they are
**the only thing that can find a defect both paths share.**

## Where it stands

| | census 1 | census 2 | the gate, corpus-wide |
|---|---|---|---|
| samples | 874 | 874 | **876 of 876** |
| **programs in full agreement** | **0** | **11** | |
| difference lines | 9 402 | 7 024 | 6 634 |
| **unclassified** | 9 402 | — | **0** |
| classes | — | — | **27** |

The registered CTest gate runs a stride of 110 for time; the numbers above are the whole corpus.

Census 2 is after two changes inside the comparison itself, each answering a whole class:

- **promotion.** `normalizeForShapeCompare` runs `mem2reg` — and only that — on both modules first.
  2 981 lines were PIR keeping a value in a stack slot where the trusted path used the value,
  reaching `Object.Object` and therefore every program. A difference `mem2reg` erases is not a
  difference in behaviour, by construction. It runs on a **copy** of the PIR module, because that one
  is what gets emitted.
- **the entry wrapper.** 609 lines were `main`, which the two paths structure differently on purpose
  (the trusted path fuses `Main.main` into it and emits no `Main.main`; they also order argv
  construction and static class load oppositely, and both orders are correct). Skipped in the
  comparison and asserted absolutely instead — `samples/entry_wrapper.pol` runs through both paths
  and checks argv intact, class load before user code, exit 0.

## The sixteen classes

| | what | disposition |
|---|---|---|
| **C** | checked arithmetic, **and guard elimination** | **PIR is right** |
| **J** | speculative devirtualisation | **PIR is right** |
| **E** | index and bounds lowering | looked at |
| **F** | address arithmetic in region/arena code | looked at |
| **H** | how a string literal reaches a call | looked at |
| **I** | an arithmetic idiom (`select` against a shift) | looked at |
| **D1** | String field ownership | **defect — FIXED** |
| **D2** | the value form of `Result`/`Option` on the heap | **defect — FIXED** |
| **D3** | an LLVM memory intrinsic becomes a library call | candidate |
| **D4** | fewer `llvm.assume` | candidate |
| **D5** | the `Object` vtable pointer is never written | **defect — an access violation — FIXED** |
| **D6** | a destructor that does not free | **defect — six causes fixed; the tail is one rule, measured below** |
| **D7** | an atomic read-modify-write becomes load/add/store | **defect — FIXED** |
| **D8** | the null-receiver check is not emitted | **defect — FIXED** |
| **D9** | **RAII does not run when an exception unwinds** | **defect — FIXED** |
| **D10** | a non-capturing lambda gets a heap closure | **defect — FIXED** |
| **D11** | **`await` blocks the thread instead of suspending** | **defect — FIXED** |
| **D12** | a Java-style enum constant is re-constructed at every reference | **REFUTED — twelve sites, three runs** |
| **K** | a block count that differs with nothing else to say | looked at |
| **L** | the `finally` body duplicated across a different number of exit edges | looked at — **output verified identical** |
| **M** | PIR allocates **fewer** | looked at — kept apart from D2/D10 on purpose |
| **N** | `foreach` over an `Iterable` without calling the protocol | **REFUTED — the protocol IS called: 7 and 6** |
| **R** | a value variant is unpacked once per arm | looked at — same answers, more instructions |
| **O** | a generator's coroutine helpers are class-qualified on one path, bare on the other | looked at — **output verified identical** |
| **P** | region-class lowering reaches the arena primitives directly | looked at |
| **Q** | a constructor symbol qualified on one path, bare on the other | looked at |
| **D13** | **objects in a region are never destructed** | **defect — FIXED** |
| **D14** | **a receiver expression is evaluated twice** | **defect — FIXED** |

---

## The two where PIR is right

### C. Checked arithmetic, and guard elimination

```
calls llvm.sadd.with.overflow.i32 0->1        calls __polaron_fail 2->0
 icmp 4->2,  zext 2->0                        calls DivideByZeroException... 2->1
```

**The overflow rule reaches its intrinsic** — §12's hand-off row, *"not an open-coded compare"* — so
the intrinsic appears on one side and the open-coded `icmp`/`zext`/`__polaron_fail` vanish from the
other. And **guard elimination runs** (§11.3, with no counterpart on the trusted path): `adler32`
divides twice by the same constant and PIR keeps one `DivideByZeroException` where the trusted path
emits two. The compile line says it out loud — `guards-removed=169`.

Recorded here so it is never mistaken for a regression, which is exactly the shape it has: the newer
path calls something the older one does not.

### J. Speculative devirtualisation

```llvm
trusted:  %fn = load ptr, ptr %slot        ; and an indirect call
PIR:      %dv.is = icmp eq ptr %vfn, @"Some$int.isSome"   ; then a direct call
```

Where the trusted path loads a vtable slot and calls indirectly, PIR compares the loaded pointer
against a known target and calls it directly when it matches. Both possible targets therefore appear
as direct calls the trusted module does not contain.

## The four that are looked at and benign

| | |
|---|---|
| **E** | `ArrayList.get`/`.set`, `HashMap.getOrDefault` — the checked-index path, address computed arithmetically, one more block |
| **F** | `SlotMap`, `UnionFind`, `IntHeap` — `add`/`mul`/`and`/`ptrtoint` where the trusted path uses a `getelementptr`. §11.7 moves region binding onto the graph anyway |
| **H** | the trusted path hands `printf` a raw C-string global; PIR emits a `String` object and loads its `data` (offset 8 in `PolaronStr{len,data,hash}`). The same pointer arrives, and the loads are of a constant |
| **I** | `ashr 2->1, select 0->1` in colour packing — same value, different instruction choice |

---

## The defects — Wave 1

### D1. String field ownership

```
Test.__onClassLoad: calls __polaron_str_copy 2->0, calls __polaron_str_free 2->0
```

The runtime states the protocol — *"a String field or element OWNS its buffer: storing one copies,
and overwriting one frees the previous"* — and emits the pair at every such store. Trusted follows
it; **PIR emits neither half, anywhere.** Because it omits both, the failure is a **leak, not a
dangling pointer**. Also visible in the live totals: trusted exits at `bytes=112 count=5` and PIR at
`bytes=16 count=1`, on every sample — the four blocks are the two copied Strings.

### D2. The value form of `Result`/`Option`, heap-allocated

`src/pir/lower.cpp:20860` puts `location == "value"` in the same branch as `"heap"`. Trusted emits
`%__polaron_variant` with **zero allocations and zero vtables**; PIR emits `ptr`, one
`__polaron_malloc(16)` per return path, and 64 vtable globals for the same source.

### D3 / D4 — candidates

An LLVM memory intrinsic (`memcpy`, `memset`) becomes a library call — opaque to the optimiser, and
a symbol a freestanding target may not have. And PIR emits fewer `llvm.assume`, which is related to
§11.10 not running yet; whether the missing one is a lost fact or a redundant one is not established.

### D5. The `Object` vtable pointer is never written — an access violation

```
Object.Object:  getelementptr 1->0,  store 1->0        (the whole body)
Dog.Dog:        getelementptr 2->1,  store 2->1        (one store of two, in every constructor)
```

Trusted's `Object.Object` is `store ptr @Object.vtable` into slot 0; PIR's stores `this` into a local
and returns. PIR *does* write the vtable for user classes, so the gap is `Object` itself — the one
class nobody declares and every program has.

```
trusted: prints `same true` / `diff false`, exits 0
PIR:     exits -1073741819 (0xC0000005, access violation)
```

**874 samples never found it, because not one constructs a bare `Object`.** Now one does:
`samples/bare_object_dispatch.pol`, registered `WILL_FAIL` so it flips red the day it is fixed.

### D6. A destructor that does not free

`ArrayList$int.~ArrayList$int: calls __polaron_free 1->0`, and beside it the indirect destructor call
and `__polaron_check_live`. The field-array leak the ledger already carries (AP-15), here with its
reach measured.

**And it is much larger than one destructor.** `generator.pol` compiles to the same **10**
`__polaron_malloc` sites on both paths and to **25** `__polaron_free` sites on the trusted one
against **4** on PIR. It shows in the live total: PIR normally exits *below* the trusted path by the
D1 baseline of 96 bytes, and on this sample it exits 208/8 against 112/5 — **192 bytes and 7 blocks
above its own baseline**, on a program whose output is identical.

> That leak reached the live check and **not** the shape gate, because the free-count lines were
> already classified as D6 while the unclassified lines for this sample were about names (class O).
> It is the first-match limitation below, caught by the other instrument — which is the argument for
> having two.

### D7. An atomic read-modify-write becomes load/add/store

```llvm
trusted: %3 = atomicrmw add ptr @abstain.Main.run.a, i32 1 seq_cst
PIR:     %3 = load i64 ... ; add ; store i64
```

The `abstainfrom` counter. Two threads abstaining lose updates — and on bare metal, where AP-14
noted the counter is *"global by necessity, so it is mutable state anything that preempts the method
also touches"*, an interrupt between the load and the store loses one.

### D8. The null-receiver check is not emitted

Trusted guards a dispatch with `icmp eq ptr %recv, null` → `__polaron_panic("null reference
dereference")` → `unreachable`, naming file and line. **PIR emits none anywhere**: two samples
measured, trusted 2 and 2, PIR 0 and 0. Not one guard eliminated — the check is absent. A raw null
dereference traps on a hosted target, so what is lost there is the diagnostic; on bare metal with no
MMU it is the language's own no-UB rule, which says a null dereference is a named panic and not a
fault.

### D9. RAII does not run when an exception unwinds

In `Main.objCase` the trusted path calls `Guard.~Guard` **twice**:

```llvm
in dtor.live:  call void @"Guard.~Guard"(ptr %1)
in rethrow:    call void @"Guard.~Guard"(ptr %6) [ "funclet"(token %5) ]
```

PIR calls it once, on the normal exit only. **Every stack object with a destructor, every `defer` and
every `using` is skipped when a throw passes through the scope.**

### D10. A non-capturing lambda gets a heap closure

Trusted stores `@__polaron_closure`, a global, and allocates nothing. PIR calls
`__polaron_malloc(16)` per construction and fills it with the lambda pointer and a null capture. A
lambda with no captures has no state, so the global is both correct and free.

### D11. `await` blocks the thread instead of suspending

```
Main.combine$resume: calls __polaron_await 4->0, calls __polaron_task_result 4->0,
                     calls __polaron_task_wait 0->4
```

| | |
|---|---|
| `__polaron_await` (trusted) | registers the caller's continuation and **returns 1 so the state machine returns from its resume function** — the worker is freed |
| `__polaron_task_wait` (PIR) | `SleepConditionVariableCS(&g_donecond, &g_qlock, INFINITE)` in a loop until the task is done — **it holds the thread** |

With a bounded worker pool, tasks waiting on tasks that need a worker to run is the classic pool
deadlock, and suspension is exactly what avoids it. F8 is recorded as *"a real state machine with
suspension, including awaits in loops and ifs via coroutine lowering"*; the default backend throws
the suspension away.

### D12. A Java-style enum constant is re-constructed at every reference

```
Judge.judge: calls Grade.Grade 3->12
```

The trusted path treats a constant as a lazily-initialised singleton:

```llvm
%enum.cur = load ptr, ptr @Grade.ok.__inst              ; already made?
call void @Grade.Grade(ptr @Grade.ok.__store, i32 100)  ; make it, once, into a static store
store ptr @Grade.ok.__store, ptr @Grade.ok.__inst       ; remember it
```

Three constructor calls for three constants. PIR emits twelve. Wasteful for a pure value; a
behaviour change wherever the constructor has an effect or anything compares identity — and adjacent
to the open bug where deleting an array of Java-style enum values double-frees the singletons.

### L. The `finally` body is duplicated across a different number of exit edges

`Main.run: calls printf 4->5` in one sample and `Main.withReturn: calls printf 3->2` in another —
opposite directions. **Both programs print exactly the same thing**, verified by running them:

```
exceptions_finally   trusted: caught / finally / body ok / finally     PIR: identical
finally_exits        trusted: finally-return / r=1 / iter 0 / ...      PIR: identical
```

The difference is how many static call sites the body has; each path still runs it once.

> A `printf` count is broad enough to hide a genuine output change, and it is classified here anyway
> for a reason that has to hold: **output is compared elsewhere** — `pir_batch_agreement` over 120
> samples, and `run_pir_behaviour_test`. A shape gate is not the instrument for what a program
> prints, and pretending it is would make both weaker.

### M. PIR allocates fewer

`Fns.compose: calls __polaron_malloc 4->2` — two closures where the trusted path builds four, the
same output, and a live total lower by exactly those two.

**Kept apart from D2 and D10 deliberately.** Fewer allocations is never a memory defect on its own:
either it is better, or something that should have been built was not, and that shows as wrong
output, which the stdout oracle catches. **PIR allocating *more* stays a defect.** The direction is
compared in code, because a regex cannot.

### N. `foreach` over an `Iterable` without the protocol — **candidate**

```
Main.drain: calls ArrayList$String.iterator 1->0, calls ArrayListIterator$String.hasNext 1->0
```

PIR does not call `iterator()` or `hasNext()`. Same output, and the live totals differ by **exactly**
the D1 baseline (96 bytes, 4 blocks), so here it costs and saves nothing.

**Candidate rather than benign.** The corpus's only `Iterable` is `ArrayList`, whose iteration a
compiler may reasonably know. A **user type** implementing `Iterator` with a `next()` that does
anything would be bypassed by the same lowering, and **no sample would notice**. Wave 1 owes a sample
with a custom iterator.

### O. A generator's coroutine helpers are class-qualified on one path and bare on the other

```
Sequences$evens$Gen.pump: calls Sequences$evens$Gen.Sequences$evens$current 0->1,
                          calls Sequences$evens$current 1->0, ...
```

Each path defines **and** calls its own form — PIR does not emit the bare symbol at all — and both
`free` bodies call `__polaron_free`, so it is a name and not a missing function. Output verified
identical by running it.

The qualified form is the one the shared-name fix established: a bare `nextWord` was one symbol for
two classes, and carrying the class key made it unique.

### K. A block count that differs with nothing else to say

`Heap.allocate: br 2->3`. The comparator reports calls first, then opcodes, then blocks, so a lone
`br` line means the two agree about **every call and every other opcode** and differ by a basic
block — an extra empty merge or landing block. Named rather than ignored, because a branch that
genuinely vanished would show up as calls or opcodes as well.

---

## Order is part of the classification, not an implementation detail

The gate stops at the first class that matches, so **the order the rules are tried in decides what a
line is called.** This bit once, and visibly: D14 — *any dotted call whose count went up* — was
checked in code before the named patterns, and it swallowed **O** (a generator helper's symbol) and
**Q** (a constructor's symbol), reporting both as a **defect**. The gate was green and the
classification was wrong, which is worse than red: it would have sent the fix hunting a symbol
naming difference as though a call had been duplicated.

The rule that follows: **the greediest test goes last.** Specific shapes first — a constructor whose
count rose (D12), an indirect call that vanished or a devirtualised pair (J), an allocation count
that fell (M) — then every named pattern, and only then the broad one.

A class disappearing from the `classes seen:` line is therefore a signal, not noise. It means
something above it started claiming those lines.

## What the gate cannot see, said out loud

**A line is classified by the first class that matches it, and a line carries up to three
disagreements.** So a difference that arrives on the same line as a known class is hidden by it. The
patterns are therefore kept as narrow as they can be — D12 is checked in code rather than by regex,
because the loose form (`calls <anything> N->M`) would have swallowed every defect that arrives as a
call count, and four of the twelve below do.

**The gate registered in CTest runs a stride of 110 of 876 samples**, for time. The classification
itself was built from a **corpus-wide** census, and the corpus-wide run is what found D11, D12 and
K — the stride had missed all three. Whenever a class is added or removed, run it over everything:

```
cmake -DPOLC=<polc> -DSAMPLES=tests/samples -DWORKDIR=<build>/tests -DLIMIT=900 \
      -P tests/run_pir_shape_test.cmake
```

### D13. Objects living in a region are never destructed

```
LinkedList$int.~LinkedList$int: calls __polaron_region_teardown 1->0
Kennel.~Kennel:                 calls __polaron_region_teardown 1->0
LinkedList$int.addFirst:        calls __polaron_region_track 1->0
```

`__polaron_region_teardown` is not a `free`. It walks the region's track table and **runs each live
object's destructor**:

```cpp
while (d->trackCount > 0) {
    d->trackCount--;
    d->track[d->trackCount].dtor(d->track[d->trackCount].ptr);
}
PolaronBackend::metaFree(d->track, ...);
```

PIR omits the call at one end and `__polaron_region_track` at the other, so nothing is registered to
destruct and nothing destructs it. **D9 at region scope.**

And the live totals of both paths match exactly, because a region's memory comes from the arena
rather than the heap. What is lost is destructors, not bytes.

### D14. A receiver expression is evaluated twice

`fieldOffCall()` is `return table().n;` — **one** call in the source — and PIR emits
`calls Holder.table 1->2`.

In that sample `table()` returns `this`, so the doubling is harmless. The rule is not: a receiver
that allocated, logged, advanced a cursor, or was a generator's `next()` would run twice. AP-26's
objection is *"you cannot see what code runs"*, and this is the compiler making it true rather than
the language.

### P and Q — looked at

**P**: region-class lowering reaches `__polaron_arena_alloc`/`_base`/`_reserve` directly where the
trusted path called `__polaron_region_init` and the literal-suffix helper. The same family as F,
arriving as calls rather than as arithmetic.

**Q**: `Main.App.Scanner.Main.App.Scanner 0->1` against `Main.App.Scanner.Scanner 1->0` — a
constructor symbol qualified on one path and bare on the other, each path defining and calling its
own form. The same family as the anti-procedural ledger's cross-bundle constructor-symbol row, inside
one module.

---

## Wave 1 — closed

**6 634 difference lines became 674, and every one of them is classified.** The suite went from
1 128 to 1 153 tests, all green, and `liveBytes` now agrees exactly on every sample the sweep reaches
but three.

### Every defect, and what it was

| | what it was |
|---|---|
| **D1** | String field ownership reached only `<local>.<field>` — now all four ways a field is named, the release half as well as the copy, the field nulled in the constructor so "null-defaulted" is true rather than assumed, and the object's String fields released when it dies |
| **D2** | the value form of `Result`/`Option` was allocated and given 292 vtables — now `%__polaron_variant` end to end: type, construction, `match`, `try?`, methods on the value, and the boxing an `await` needs to carry one |
| **D5** | `Object`'s vtable pointer was never written — an access violation on `new Object()` |
| **D6** | six causes: `delete` through an interface local, the iterator a `foreach` mints, `using (… on heap)`, temporaries in a method whose last statement is its `return`, a `String` handed back by a call, and `delete` of a `T[]` or a reference class that came from a call |
| **D7** | an atomic read-modify-write was load/add/store |
| **D8** | the null-receiver check existed nowhere — now fires with code 70 and names the line |
| **D9** | RAII did not run when an exception unwound |
| **D10** | a non-capturing lambda got a heap closure per evaluation — now a constant in the image |
| **D11** | `await` blocked instead of suspending — now a real state machine: locals carried in the coroutine state, scratch slots for temporaries that cross a suspension, and an entry chain that resumes where it stopped |
| **D13** | objects in a region were never destructed |
| **D14** | a receiver expression was evaluated twice |
| **stride** | an array of structs stepped by the sum of its fields, not the struct's size — wrong answers and a short allocation |
| **element read** | `ArrayList<Point>.get` returned `undef` — every value-struct element read back as zeros |
| **namespace** | `App` in a program and `App` in the library were one place; declaring `Money` broke the prelude's own compilation |
| **interrupt** | the prologue called the allocator on a handler's entry path |
| **udpPeerHost** | a String was built over a static of the runtime's and released — `free` on a global |
| **narrowing** | `int → float` was grouped with the lossless widenings; now warned, `double` left alone |

**D12 was refuted.** The census counted twelve constructor calls against three; the constructor was
made to speak and it runs three times on both paths. Twelve SITES, each behind its own lazy flag.

**Class N was refuted.** A custom `Iterator` counts its own `hasNext`/`next` calls: 7 and 6 on both.

### What is left, measured

Three samples still hold more than the other path, all with identical output:

| | trusted | PIR | what it is |
|---|---|---|---|
| `autodiff_matrix` | 528/18 | 624/21 | one leaked copy per call taking an aggregate by value |
| `validate_annotations` | 3952/125 | 4112/127 | the same |
| `http_router` | 6736/189 | 10304/333 | the same, plus the element-store copy the other path makes |

All three are **one rule**: a by-value parameter's copy belongs on the frame, and putting it there
requires the element store to copy, because `ArrayList<T>.add` keeps the pointer it is handed. Both
changes were made together and measured: **nine samples change behaviour**, among them the ones that
deliberately SHARE a class through a collection. Separating those two cases is what §11.5's escape
analysis is for, and this belongs with it rather than in a correctness pass. The cost until then is
one allocation per by-value aggregate argument, never released — written down here rather than left
to be rediscovered.

## Wave 1 — what was fixed, and what fixing it taught

Six closed so far, each with a sample that fails without the fix and a suite run after it.

| | the fix | the sample |
|---|---|---|
| **D5** | `buildVtable` returned early with no entries while the LAYOUT had already reserved the pointer. A table of no entries is still a table. | `bare_object_dispatch.pol` |
| **D9** | `lowerTry`'s resume path tore down the body's own scope and not the scopes AROUND it. | `unwind_raii.pol` |
| **D13** | a region FIELD got neither `__polaron_region_track` nor the teardown, because the registry was gated on `flavor == "stack"`. Splitting `descriptor()` from `runtimeAlloc()` was the untangling; a heap-corrupting double release of a region field came out with it. | `region_field_dtor.pol` |
| **D7** | `atomicrmw add … seq_cst` and `load atomic … seq_cst` in place of load/add/store. | `abstain*.pol` |
| **D14** | the interrupt-binding probe evaluated the receiver to decide whether the member was a handler, then dropped it. Now a name index answers the question with nothing evaluated, and the swizzle probe reuses the one receiver instead of making a second. | `receiver_once.pol` |
| **D1** | the String ownership protocol reached only `<local>.<field>`. Now all four ways a field is named, the release half as well as the copy half, and the field nulled in the constructor so "null-defaulted" is true rather than assumed. | `static_alloc_init.pol`, `value_copy_string_field.pol` |

### D6 in width — the live sweep

D6 was found on one sample. `scratchpad/livesweep.ps1` runs the same instrument over every Nth
sample: compile both ways, run both, compare what each left live. **Nine of thirty disagreed, all in
the same direction** — PIR holding more. Four causes, all now fixed:

| cause | where |
|---|---|
| `delete` through an interface-typed local ran the destructor and left the block | an interface has no value form, so it is boxed without a star |
| a `foreach` never disposed the iterator it minted | the loop owns a FRESH one — `iterator()`, a generator, a `new` — and not a borrowed name |
| `using (R r = new R() on heap)` disposed without releasing | the branch that reaches it *is* the test for whose storage it is |
| a method whose last statement is its `return` released no temporaries | temps are released at the top of the NEXT statement, and there isn't one |

The last of those exposed a defect underneath it. `Net.udpPeerHost` answers with `g_udp_peer_host`,
a **static of the runtime's**, and the descriptor table spelled it the same way as
`Env.executablePath`, which really does `__polaron_malloc` its answer. Releasing the first called
`free` on a global: `udp_socket` exited `0xc0000374`. The table now says which — `t` owned, `b`
borrowed-and-copied — because that is a fact about each function, not something to infer from a name.

**What the sweep says is left**: `deep_call_chain` 368/13 against 176/7, plus `random_shuffle`,
`null_cast_checked`, `autodiff_matrix`, `encoding_hex_base64`, `validate_annotations`, `http_router`.
And `tuple` is **not D6 at all** — PIR *allocates* the tuple (`MathX.divmod`, two mallocs; the other
path, none), which is D2 wearing D6's clothes. A leak and a materialisation look identical to a
byte counter; only the IR separates them.

Three lessons, all of them about instruments rather than about the compiler.

**A test can be green because of a second defect.** `codegen_freestanding_has_no_string_runtime`
asserts a bare-metal image never names `__polaron_str_copy`. It passed for as long as PIR emitted no
String protocol at all — and went red the moment D1 was fixed, because the prelude's `Test` hook was
a root in a freestanding program and nothing had ever noticed. The absence test was measuring the
absence of a feature, not the presence of a guard. Both are fixed; the pairing is the warning.

**A correct fix can rest on a false premise.** The release half of D1 is right, and it took an access
violation to find that the premise under it — a String field holds null until something writes it —
was true on one path and merely assumed on the other. `new … on stack` is an `alloca`, which holds
the previous frame's bytes.

**A waiver written as an exact pair expires by itself.** The seven behaviour tests carried
`LIVE_KNOWN` pairs for D1's 96 bytes in 4 blocks. Fixing D1 collapsed every pair, the harness said so,
and the waivers were deleted. An allowance with slack would still be sitting there.

**And the instrument can be the thing that is wrong.** The sweep reported "output differs too" on
samples whose output was byte-identical, twice. `& exe 2>&1` in PowerShell 5.1 wraps each stderr line
of a *native* program in a `NativeCommandError` and splices the wrapper's own text into the stream —
and the live reporter writes to stderr, so five lines of PowerShell diagnostics landed in a different
position on each path. The fix was to make the script *show* the difference instead of asserting it,
at which point the cause was one line of output. A gate that cries wolf is worse than no gate: the
next real difference reads as more noise.

---

## How to use this file

A difference matching a class passes and the class is named in the log. **Anything else fails**, and
the failure says so: *"the two backends differ in a way nobody has classified"*. If a new difference
is real it is a defect; if it is expected it goes in this file **and** in the pattern list in
`run_pir_shape_test.cmake` — but it does not go unlooked-at, which is how ten defects reached this
page.
