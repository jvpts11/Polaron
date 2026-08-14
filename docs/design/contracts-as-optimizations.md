# Contracts that pay for themselves

*Proposal, 2026-08-13. **Built 2026-08-14** — see "What shipped" at the end; the version that shipped
needed no decision, because the invariants turned out to be checked at every exit already.*

**And it uncovered a serious bug on the way in: a generic class LOST its invariants when instantiated.**
`monomorphize.cpp::cloneClass` copied eighteen properties of a class and dropped `invariants`, so
`HashMap<K,V>` declared five clauses and `HashMap$int$int` — the class every program links — had none.
Nothing checked them at any exit. The same failure as `cloneMember` dropping `isExtern`: a clone that
copies almost everything, where what goes missing is a *check*, so it goes missing in silence. Test
`contracts_generic_invariant_enforced`.

## The measurement that produced it

`HashMap` is 1.55× slower than the identical open-addressing map hand-written in C++ (`coll_mapoa`:
38.3 ms against 24.4, measured above the harness's ~6 ms process floor — see the note at the top of
that reference file, because everything measured below the floor was noise).

Read from the emitted machine code, the probe loop is **10 instructions against the C++ twin's 6**:

```asm
; C++ (6)                            ; Polaron (10)
                                     cmpb   $0, 8(%r9,%r8)     ; used[i]
cmpl  %edi, (%rdx,%rcx,4)            je     .exit
je    .exit                          movq   (%rdx), %r11       ; keys.length
incl  %r9d                           cmpq   %r8, %r11          ; BOUNDS CHECK
andl  %eax, %r9d                     jbe    .fail
movslq %r9d, %rcx                    cmpl   %ebx, 8(%rdx,%r8,4); keys[i]
cmpb  $0, (%r8,%rcx)                 je     .exit
jne   .loop                          incl   %r10d ; andl %eax, %r10d
                                     movslq %r10d, %r8
                                     cmpq   %r8, %rcx          ; BOUNDS CHECK (rotated)
                                     ja     .loop
```

And the loop is **branch-bound, not throughput-bound** — proven both ways:

- removing two instructions from it (a field reload, hoisted once the receiver was marked `align`)
  changed the clock by nothing;
- removing the two bounds checks — which are *branches* — took it from 38.3 ms to 32.4.

So the lever is the two branches per probe, and nothing else measured so far.

## The fact needed to delete them is already written in the source

`HashMap` declares, above its fields:

```polaron
// The three parallel arrays must stay the same length as the declared capacity -- that
// is the assumption every probe makes when it masks an index and then indexes all three.
invariant this.keys.length() == this.cap;
invariant this.values.length() == this.cap;
invariant this.used.length() == this.cap;
```

and every probe indexes with `i = <something> & (this.cap - 1)`.

`x & (n-1)` lies in `[0, n-1]`, so with `length == cap` the index is **provably in range**. The author
wrote that proof obligation down, for correctness — and the compiler ignores it. Today `cap` and
`length` are two unrelated loads, so neither our passes nor LLVM can connect them.

**Making the invariant feed the optimizer is the most Polaron-shaped speedup available**: a contract
written to be correct starts paying for itself in speed.

## There is a version that needs NO decision, and it is better

*Added after the section below was written. The proposal above trades a language promise for speed;
this one does not, and gets the same branches out of the loop.*

**Hoist the guard instead of eliding it.** The index is `i = <x> & (cap - 1)`, so every value `i` can
take satisfies `i <= cap - 1`. One check before the loop therefore implies all of them:

```
if ((unsigned)(cap - 1) >= used.length()) panic;   // once, before the probe
...then every arr[i] inside the loop is provably in range
```

Why this is sound with no invariant and no trust:

- **`cap >= 1`**: `i <= cap-1 < length` follows directly. Nothing is assumed.
- **`cap == 0`**: `cap - 1` is `-1`, which **as an unsigned compare** is the largest value, so
  `>= length` is true and the guard fires *before* the loop. Exactly the outcome the per-iteration
  check would have produced — no window in which an unbounded `x & -1` indexes anything.

So it needs neither the `invariant`, nor `cap >= 1`, nor any change to what `invariant` means. It is
ordinary **loop-invariant guard hoisting**, applied to a shape `boundscheck.cpp` does not yet know:
a `while` whose index is `i = (i + k) & mask` rather than a `for` with an affine `base + var`.

**The one visible difference is *when* a broken program panics** — before the probe rather than partway
through it. Same guard, same message, one iteration earlier. That is a smaller change than trusting a
contract, and it is why this version should be built first.

**What it needs:** recognise, in `boundscheck.cpp`, a loop whose index variable is written only as
`i = (i + <const>) & <expr>` with `<expr>` loop-invariant, and whose array accesses are all `arr[i]`
for arrays that are not reassigned in the loop. Emit the one-shot guard in the preheader and pass
`checked = false` to those accesses — the same `checked` flag the pass already uses for its versioned
loops, so no new way to drop a check is introduced.

## The decision the *other* version needs

An invariant today is *checked*. This proposal would additionally make it *trusted* — and those are
different promises:

- **Where is it true?** At method entry and exit, by the usual contract discipline. It is *not* true
  mid-body: `grow()` reassigns `cap` and all three arrays, and between those statements the invariant
  is briefly false. So an `llvm.assume` may be emitted at entry, and must be invalidated by any write
  to a field the invariant mentions.
- **What if it is false?** Trusting a false invariant reintroduces undefined behaviour — the exact
  thing the guards exist to prevent. That is acceptable only if the invariant is *also* checked at the
  points where it is assumed, or if trusting is opt-in.
- **`cap == 0` is the sharp edge.** `x & (0-1)` is `x & -1` = `x`, unbounded. The elision is sound only
  with `cap >= 1`, which follows from `count >= 0` and `count < cap` — two more declared invariants,
  chained. A first implementation should require the chain rather than assume it.

**These are language-semantics questions, not compiler-implementation ones**, which is why this is a
proposal and not a patch.

## Sketch, once the decision is made

1. Collect each class's `invariant` clauses of the shape `this.<array>.length() == this.<field>`
   (either order).
2. At method entry, for each such pair, emit `llvm.assume(icmp eq (load length), (load field))`.
3. Invalidate on any store to `<array>` or `<field>` in the method — the same invariance analysis
   `boundscheck.cpp` already performs for its loop versioning.
4. Let LLVM do the rest: with `length == cap` known, `(x & (cap-1)) < length` folds to true and the
   branch disappears on its own. **No new elision logic, and no new place where a check can be dropped
   by mistake** — which matters, because a bounds check removed in error is exactly the failure this
   language exists to make impossible.

The existing `boundscheck.cpp` does not help here: it versions innermost `for` loops over affine
`array[base + var]` accesses, and a probe loop is a `while` with `i = (i + 1) & mask`. Different shape,
different mechanism.

---

# What shipped, 2026-08-14

**Simpler than either version above, and it needed no decision.** Every declared `invariant` becomes an
`llvm.assume` at method entry — no pattern matching on clause shapes at all, and no new elision rule.
LLVM removes a bounds check only where it can prove the index in range, exactly as it always has; this
just stops hiding from it the facts the author wrote down.

**Why it is sound without trusting anything.** `emitScopeCleanup` already checks every invariant at
every exit of every method, the constructor checks them too, and there is no switch that turns
contracts off. An object can therefore only be observed by a later method in a state some earlier exit
already verified. If an invariant were false the program would have panicked at the exit that broke it.
So the assume asserts only what is checked.

**Two things it cost, both found by the compiler crashing or the clock moving:**

1. **Never in a constructor.** The invariant is *established* by the constructor; at its entry the
   fields hold whatever the allocation left. Evaluating `this.data.length()` there dereferences
   garbage, and the map benchmark died with an access violation before printing a character.
   Destructors are excluded for the mirror reason.
2. **Checking every invariant at every exit is expensive**, and it had to be paid the moment the
   monomorphize bug was fixed — five checks on the way out of `get`, `size`, `slotFor`, methods that
   assign nothing. `invariantsToCheck` now keeps only the clauses naming a field the method actually
   assigns. A call is not a hole: the callee re-checks at its own exit.

**Measured** (`coll_mapoa`, workload above the harness floor), with contracts enforced in both arms:
**43.3 ms without the assumes, 41.8 with**. Bounds-check failure sites in the emitted assembly fell
from 45 to 30, and the `keys` length load moved *out* of the probe loop.

**Do not compare either number with the old "38.3 ms baseline"**: that build had the contracts
silently disabled. It was faster because it was not doing the work.

## The assumes were reaching the wrong methods. Fixed 2026-08-14, and it was worth 17%

The two lists above — *what to check at exit* and *what to assume at entry* — were the same list, and
that gave the optimisation to precisely the methods that could not use it.

`invariantsToCheck` narrows to the invariants a method might have broken. Correct, and worth 3.5 ms.
But `emitInvariantAssumes` read the same narrowed list, so a method that assigns no field got an
**empty** one. Counted on `HashMap$int$int`:

| | `llvm.assume` | guards left |
|---|---|---|
| `slotFor`, `get`, `containsKey`, `getOrDefault`, `keyArray`, `valueArray` | **0** | all of them |
| `put`, `grow`, `merge`, `remove` | 5 each | — |

The read-only methods are the ones with something to gain; the writers reassign the arrays and cannot
use the fact at all. **The probe loop this whole document is about was the one place the transform
never reached.** Every invariant holds on entry whatever the method does next — a method that writes
nothing is not a method that knows nothing — so `currentInvariantsToAssume` is now the full list while
`currentInvariants` stays narrowed for the exit checks.

**Measured: `coll_mapoa` 48.2 → 39.8 ms**, and against the same C++ twin the ratio went **0.55 → 0.67**.
Tests `codegen_invariant_assume_reaches_readonly` (scoped to `Table.probe`, because a module-wide grep
for `llvm.assume` passes with the bug present — the constructor is special-cased to keep every clause)
and `codegen_invariant_assume_readonly_runs`.

## And a transform that was built, measured and rejected

A masked-index loop versioning (`i = h & mask` → guard on `mask >= 0 && mask < arr.length()`, fast copy
unchecked) was written for `boundscheck.cpp`, and it worked exactly as designed — the fast probe loop
came out at **five instructions against the C++ twin's six**, with both checks gone.

**It made the benchmark slower** (38.3 → 44.3 ms, 40.9 with the inliner forced). The reason is a
property of hash probes: **the loop is hot in calls, not in iterations.** A well-distributed table
probes about once, so versioning pays ~8 setup instructions per `slotFor` to save five in a body that
rarely repeats. The reasoning is written into `boundscheck.cpp` where the next person will look for it.
