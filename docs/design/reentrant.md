# `reentrant` — a method that may be entered while it is already running

> **Status.** Designed, not implemented. One new keyword. It **replaces** a list of ad-hoc rules
> rather than adding to it.

---

# Part I — Why

## 1. The objection

**AP-11** — *allocation is hidden, and there are contexts where allocating is forbidden.*

> *"Allocation hides: in constructors, in temporaries, in copies you did not write. And there are
> places where allocating is not merely slow but forbidden — an interrupt handler that may have
> interrupted the allocator itself, a destructor running during teardown, anything that runs before
> the heap exists."*

It **falls** — but by a hand check, and the finding says so: *"the region binder should have caught
what a hand check did."*

## 2. What C has, and why it is shallower than its reputation

`#pragma GCC poison malloc free` is the strongest thing C offers, and it works:

```
nofree.c:45:21: error: attempt to use a poisoned identifier
```

Three limits, and the third is fatal:

- **file-scoped, not function-scoped.** You cannot say *"this handler must not allocate"*; you say
  *"this translation unit must not mention the word."*
- **lexical, not semantic.** It bans an *identifier*, not an *operation*. It is a `grep` with
  compiler support.
- **so it misses the case that matters.** Put the allocation behind a wrapper — `scratch_get`
  calling `malloc` above the pragma — and the file is **clean** while the program does exactly the
  forbidden thing. That is not a trick played on the mechanism; it is what every real codebase looks
  like, because allocation always lives behind a wrapper.

```
--- direct ---            2 errors
--- behind a wrapper ---  exit 0
```

## 3. What Polaron has today

Nothing general — and one special case. `interrupt` already carries a per-method obligation checked
over calls: it refuses an explicit allocation, one a call away (naming the path), a `delete`, and
shared mutable state. Two holes are known and measured:

| | from |
|---|---|
| it does not follow the **implicit destructor** at scope exit, so a handler whose scope-exit frees compiles clean — and *"must not free memory"* is the rule's own second entry | AP-12 |
| it does not follow **compiler-generated calls**, so it cannot see the `__polaron_malloc` the back end itself inserted into the handler to deep-copy a by-value `Trap` parameter | AP-17 |

Everything else — a destructor, a method that promises in a comment — is unchecked. `nofree.pol`
compiles and runs clean with three violations in it.

---

# Part II — The design

## 4. The word, and why it is the wide property

> **`reentrant` — this may be entered again while an earlier entry is still running.**

Two things follow from that one sentence, and the `interrupt` rule already checks both:

| | why |
|---|---|
| it reaches **no storage another activation could be inside** | the allocator has global mutable state; you may have interrupted it mid-update |
| it touches **no shared mutable state** | the earlier activation may be mid-update of the same thing |

Naming the *reason* rather than one of the mechanisms buys three things a narrow "does not allocate"
marker would not:

1. **`interrupt` stops having rules of its own.** An interrupt handler is *implicitly `reentrant`*,
   and the bespoke list collapses into one property with one checker.
2. **It catches the lock.** A `reentrant` method that takes a `Mutex` **deadlocks against itself** —
   a real kernel bug class that a no-allocation rule cannot see. `atomic<T>` stays legal, because a
   single atomic instruction has no half-done state to interrupt; `Mutex<T>` does not.
3. **It is the word systems programmers already have.** No one has to be taught it.

## 5. Semantic, per-method, viral — and in the PIR

The finding named the first three; AP-17 forces the fourth.

**Semantic.** It forbids the *operation*, not the spelling. The compiler knows which of its own
constructs allocate: `new ... on heap`, `new T[n]()`, a collection growing past capacity, a String
concatenation, a `throw`, a closure that captures. Nothing has to be listed in a pragma.

**Per method.** On the declaration, not on the file.

**Viral.** A `reentrant` method may only call `reentrant` methods. This is the half C cannot have and
the half that closes the wrapper hole: an obligation that stops at the first call boundary is not an
obligation.

**In the PIR, not the AST.** The back end inserts calls nobody wrote — AP-17 measured a
`__polaron_malloc` per interrupt entry, generated to copy a by-value parameter. A check over the tree
sees the author's code and not the compiler's, which is precisely why today's `interrupt` rule has
that hole. A viral property over a call graph is what a PIR pass is for, and `polaron-ir.md` §11
already lists the analyses that should move down out of the AST for this reason.

## 6. Regions — and this is the binder's question, not a bypass of it

`new X in r` is a pointer bump inside storage that already exists, which is not what makes allocating
dangerous. The finding left it open; the answer is not a blanket rule either way.

Ask **why** the general heap is forbidden. Not because it allocates — because **the allocator has
global mutable state you may have interrupted.** A region has mutable state too: the bump pointer. If
the interrupted code was mid-bump in *the same region*, a handler bumping it corrupts it exactly as
the heap would be corrupted.

So the rule is not *"do not allocate"*:

> **Do not reach storage that another activation could be inside.**

The general heap is always shared, so it is always refused. A region is refused **if and only if it
is reachable from outside the `reentrant` method**. A region the method creates and releases within
itself, or one belonging to the handler alone, is fine — which is the ordinary shape of a handler
that needs scratch space.

That is not a rule that goes around the region binder. **It is a question only the binder can
answer** — it already knows which region each allocation comes from and who can reach it. The marker
gives the binder work rather than passing it by.

> **Open (§10.1):** a handler that can interrupt *itself* — nested interrupts of the same vector —
> re-enters its own exclusive region. Exclusive ownership is necessary and may not be sufficient.

## 6a. `interrupt` does not go away — one of its four jobs moves

Said plainly, because *"`interrupt` stops having rules of its own"* reads worse than it means.
`interrupt` carries four things and exactly one of them moves:

| | |
|---|---|
| **the calling convention** — `x86_intrcc`, the frame `byval`, `iretq` instead of `ret`, `noredzone` | **stays, and nothing replaces it** |
| **it is entered, not called** — calling it is refused, because that simulates an interrupt, which is a different thing wearing the same name | **stays** |
| **one per class** — a device has one handler | **stays** |
| the **list of prohibitions** — must not allocate, must not free, the state it reaches must be state the interrupted code agreed to share | **becomes `reentrant`** |

The first is why AP-17 falls: the handler is **22 bytes ending in `iretq`** against C's 20 — the same
six instructions, the same scratch register, the two-byte gap being the relocation model — where C's
answer is a *compiler extension* or an assembly stub. None of that is about reentrancy and none of it
changes.

What the fourth line buys by moving is symmetrical:

- the handler is checked by the checker **with both holes closed** (§3), instead of the one it has;
- and a method that is **not** a handler but must be equally careful — a scheduler entry, a
  page-fault path, a destructor during teardown — gains a way to say so, which today it has not.

## 7. Two obligations nobody writes

- **`interrupt`** is implicitly `reentrant` (§4). It is a keyword precisely so the compiler knows
  what it is.
- **the implicit destructor at scope exit** inside a `reentrant` method inherits the obligation
  **virally**, which closes AP-12's hole with no special rule — it is a call, and calls are checked.

A destructor is **not** implicitly `reentrant` on its own. Many legitimately touch shared state —
removing themselves from a parent's list — and forcing the property on all of them would be a
different and much larger change. It is inherited where it is needed and written where it is wanted.

## 8. Virality at the edges

| | |
|---|---|
| **across a bundle** | the marker travels in the `.polh`, like `final`. AP-04 measured that this is what makes a promise usable without whole-program knowledge |
| **through a `dynamic method`** | the target is not known at the call. The base's declaration carries the obligation and **every `override` must be `reentrant` too** — the same shape as `override` checking, and it fails at the override rather than at the call |
| **through `extern`** | unknowable. An `extern` declaration is already the author's unverifiable promise about a foreign symbol, so `reentrant` on one is consistent with what that line already is. Without it, a `reentrant` method may not call it |
| **compiler-generated calls** | the reason §5 puts the check in the PIR |

## 9. Contradictions, under the §19.9 rule

| | why |
|---|---|
| `reentrant synchronized` | `synchronized` takes a lock; re-entering deadlocks against yourself |
| `reentrant async` | an `async` method suspends and resumes on a scheduler; the second entry is the scheduler's, not the caller's. **Open (§10.2)** — this may be a contradiction or may be exactly what an executor wants |

## 10. Still to design

| | |
|---|---|
| 10.1 | self-interrupting handlers and an exclusively-owned region (§6) |
| 10.2 | `reentrant async` (§9) |
| 10.3 | `reentrant class` as a shorthand for *every method of it* — useful for a driver, and it is a member modifier rather than a universal prefix (`reentrant field` means nothing) |
| 10.4 | what counts as **shared mutable state** in the narrow sense. Today's `interrupt` rule already answers this; the answer has to be lifted out with the rest and written down rather than inherited |
| 10.5 | freestanding. A program with no heap at all would like every method to be `reentrant` by default; whether that is a program-level statement or just what happens is a separate question |

## 11. What this closes

| | |
|---|---|
| **AP-11** | the objection already fell; it now falls **by the compiler** rather than by a hand check, which is what the finding asked for |
| **AP-12's hole** | the implicit destructor at scope exit, closed by virality rather than by a rule |
| **AP-17's hole** | compiler-generated calls, closed by the check living in the PIR |

And it is strictly better than C's answer rather than a copy of it: **semantic where `poison` is
lexical, per-method where `poison` is per-file, and viral where `poison` stops at the first
wrapper** — which is the case that decides whether the guarantee is worth anything.

## 12. What this adds to the language

| word | kind |
|---|---|
| `reentrant` | hard keyword, member modifier |

**One** — and it removes more than it adds: the `interrupt` rule stops being a bespoke list and
becomes one implication of a property that anything can declare.
