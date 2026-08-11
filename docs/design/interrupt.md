# `interrupt` — a method the program does not call

*Design note, 2026-08-07. **Nothing is implemented.** This exists to be read away from the code and
decided on. The keyword was deferred twice, deliberately, for the same reason both times: it carries
real semantic weight, it should serve beyond this one class of bug and beyond freestanding, and it must
not be born as a patch.*

## The claim

The essence of an interrupt is not that a CPU jumps somewhere. It is:

> A method that is **entered**, by something outside the program, at a moment the program did not
> choose, on top of whatever was running.

That sentence mentions no architecture and no execution mode. It is equally true of a bare-metal ISR, a
POSIX signal handler, a Windows console Ctrl-C handler, a vectored exception handler, and a callback a
foreign event loop invokes on its own thread. The *meaning* is portable; only the lowering is
target-specific — which is the pattern LDP3 already uses for `asm`, for regions over fixed memory, and
for the bit-counted integer names.

**The value of the keyword is in what it forbids, not in what it generates.** The calling convention is
about fifty lines of codegen and LLVM already has it (`CallingConv::X86_INTR`). If that were all,
`interrupt` would not be worth a word.

## Three rules

### 1. It cannot be called

`Isr.onTimer()` is an error. There is no caller inside the program; calling it is simulating an
interrupt, which is a different thing wearing the same name.

There is a corner here worth deciding on rather than discovering: **taking a reference to it must stay
legal**, because that is how it gets installed. If `&Isr.onTimer` produced an ordinary `function<>`, the
"cannot be called" rule would leak straight back out through the reference. So it should produce an
**installable handle**, distinct from a callable value.

### 2. It cannot block or allocate

No `new ... on heap`, no region that can grow, no lock, no `await`, no channel receive, no I/O that
waits.

The reason is literal rather than stylistic: the code this method interrupted may be standing inside the
allocator, or holding the very lock this body would take. C states these rules in prose — "async-signal-
safe" — and checks none of them. A compiler that knows what a method reaches can check them, and LDP3
already tracks that for the region binder.

### 3. State shared with an interrupt must be declared as such

This is the deepest rule and the one that keeps the keyword count at zero.

An interrupt and the code it preempts share memory. The question "what may both of them touch?" already
has an answer in LDP3: `volatile` for device memory, `atomic<T>` for counters and flags. So `interrupt`
should **require one of those** for anything mutable it reaches, and not invent a marker of its own.

That is the `identity` argument applied again: *what makes two of these the same already has a name*, so
do not add a second name for one concept. Here the concept is "state something that can preempt me also
touches", and it is already spelled two ways for two real cases.

## Why it is worth doing, empirically

pico's IRQ entry/exit stub is about forty lines of hand-written assembly. On 2026-08-07 it was read line
by line and described in a comment as symmetric. It was not: the entry gate decided whether to `swapgs`
by testing the **interrupted code's `rax`** instead of the saved CS, so the decision was a coincidence —
correct only when ring 3 was interrupted with `rax & 3 != 0`, or ring 0 with `rax & 3 == 0`. Getting it
wrong left ring 3 running with the kernel's per-CPU base in GS and zero in KERNEL_GS_BASE, and the next
`syscall` loaded its stack pointer from the BIOS interrupt vector table.

Reading did not find it. Measurement did, from QEMU's interrupt log, two days later.

Under `x86_intrcc` that stub does not exist: LLVM saves and restores every register the body touches and
emits the `iretq`. This is the strongest argument available for the keyword, and it is not "it would be
tidier" — it is that a careful human wrote this by hand, twice reviewed it, and it was wrong.

## The parameter should be an object

Today pico's dispatcher is `irq_dispatch(address vector, address ctx)` — two raw integers. LLVM's
`x86_intrcc` wants one or two pointers. Neither is LDP3.

    public interrupt method onFault(Trap t) returns void

`Trap` is a type the target world defines: the vector, the error code, the saved frame, with methods.
It is exactly the object already hiding inside those two `address` parameters. If the body of a handler
is going to be ordinary LDP3, its argument should be too.

## The tension that decides the design

**pico's timer ISR performs preemption.** `irq_dispatch` *returns the context to resume*, and the
scheduler switches process by returning a different saved block. That is the whole of preemptive
scheduling in this kernel.

An `interrupt` method under `x86_intrcc` returns void and LLVM emits `iretq`. There is nowhere to return
a different register block from. So **preemption is precisely the case the calling convention does not
cover**, and it is the case pico most cares about.

Two ways out:

**(a)** `interrupt` v1 covers handlers that do not switch context — keyboard, serial, NIC, spurious,
faults, which is most of them — and the timer keeps its hand-written stub.

**(b)** `interrupt` models "resume somewhere else" as a first-class notion, so a handler can name the
context it wants the CPU to return through.

**Recommended: (a) now, with (b) designed and not built.** Shipping (b) cheaply would be worse than not
shipping it, and preemption deserves the care that keyed persistents got. Note that (a) still deletes
most of the assembly and most of the risk, and the timer's stub becomes the one remaining hand-written
path rather than the pattern.

## Deliberately out of scope for v1

**Termination checking.** "A handler must finish" is true, and it is half the halting problem. pico's
`Deadline` type is already the library answer to bounded waiting. Leave it out; a rule that cannot be
enforced should not be pretended.

## ANSWERED 2026-08-11 — three of the four are decided

**1. Modifier or its own declaration form? → ITS OWN FORM, and nameless:**

```ldp3
public interrupt(Trap t) returns void { }
```

João's call, and the argument that carries it is not the resemblance to a constructor: **it is the
only form that gives the handler an OBJECT.** A free interrupt function has no state; an instance
method reads `this.buffer` and `this.head`. The kernel is already built that way — sixteen
`Peripheral` objects — and a handler that could not reach its device would drag the whole driver model
back to statics with a C shape.

Nameless means **one per class**, like the destructor, and that is a rule worth having rather than a
limitation: **one device, one handler.** Two handlers means two objects. The keyboard has one IRQ, the
timer has one, the NIC has one — the model already says so.

**2. Binding to a vector? → EXPLICIT, AND IT TAKES THE OBJECT.** This falls out of answer 1 rather
than being chosen separately. The CPU jumps to an address: no receiver, no argument, nothing but a
vector and a frame. If the handler is an instance method, something has to bind it to an instance:

```ldp3
Idt.install(33, keyboard);   // the OBJECT, not the method
```

and the compiler emits the per-vector trampoline that saves what must be saved, loads `this`, and
calls — precisely the code pico writes by hand and that **was wrong for two days**.

**3. Error or warning in v1? → ERROR.** This was blocked on whether `atomic<T>` works bare metal, and
it does — **verified 2026-08-11**: `atomic<int>` in a freestanding build emits `atomicrmw` and
`load atomic` inline, and the link reports no `__atomic_*` undefined symbol. On x86-64 word-sized
atomics are `lock`-prefixed instructions with no runtime behind them, so the alternative the rule
offers exists on the target where the rule matters most, and costs one instruction.
*(A caveat that deserves an error of its own: a `T` wider than the word makes LLVM emit `__atomic_*`
libcalls, which a kernel cannot link. Today's uses are counters and flags, so it does not bite — but it
should be refused rather than surface later as an unresolved symbol.)*

**The parameter is NOT optional in general.** `public interrupt()` alone cannot express preemption: the
timer ISR returns to a DIFFERENT context, so the handler must be able to modify the saved frame, which
means the frame has to reach it. Both spellings should be legal — a keyboard handler does not want it —
but if the parameterless form were the only one, pico's scheduler could not be written, and that is the
reason this word exists at all.

> *Superseded 2026-08-11 by measurement.* The frame reaches the handler, but writing it does nothing:
> see "Preemption: SETTLED" below. The parameter is still worth having — a fault handler reads the
> error code and the faulting RIP — but the argument above for why it must exist was wrong.

## BUILT 2026-08-11 — what the compiler does today

`interrupt` is a hard keyword. Grepped first across pico, psh and the samples: every occurrence was a
comment or a string, so nothing broke by reserving it.

**It is NOT a declaration node of its own.** It parses into a `MethodDecl` named `"interrupt"` with
`isInterrupt`, the way `operator+` already does. A `DestructorDecl` touches twenty places —
monomorphization, `loopopt`, implicit-`this`, three points in codegen — and an interrupt body is an
ordinary method body that every one of those passes already knows how to walk. What makes an interrupt
different lives at the two EDGES, not in the middle: nobody may call it, and codegen emits a second
function beside it. Modelling it as a method is what made this a day's work instead of a week's.

**Two functions come out.** The body is emitted as a normal method (`@Keyboard.interrupt(ptr this,
ptr trap)`), and beside it goes the entry the hardware jumps to:

```llvm
@"Keyboard$interrupt$self" = internal global ptr null
define x86_intrcc void @"Keyboard$interrupt"(ptr byval(%class.Trap) %0) {
  %self = load ptr, ptr @"Keyboard$interrupt$self"
  call void @Keyboard.interrupt(ptr %self, ptr %0)
  ret void
}
```

which at -O2 becomes the whole handler in five instructions:

```asm
pushq %rax
movq  Keyboard$interrupt$self(%rip), %rax
incl  (%rax)
popq  %rax
iretq
```

LLVM saved exactly the one register the body touched and wrote the `iretq`. Measured, both forms of the
convention work: with an error code it emits `addq $8, %rsp` before the `iretq` — the same correction
pico writes by hand.

**`byval` is not decoration.** It is how `x86_intrcc` is told the size of what the CPU pushed, and LLVM
rejects the convention without it. The declared `Trap` supplies it; the parameterless form gets a
five-word struct modelling rip/cs/rflags/rsp/ss so the size is still right.

**Binding: `keyboard.interrupt`**, a member access with no `()`. It stores the receiver into that
global and yields the entry address, and it is ONE expression because it is one act — a vector holds
an address and nothing else, so there is no way to obtain the address without saying whose handler it
is. This also settles the "installable handle" question from the top of this note without inventing a
type: what comes back is an `address`, not a callable, so the cannot-be-called rule does not leak back
out through the reference that installs it — `keyboard.interrupt()` fails on its own.

**One slot per class**, so binding a second instance of the same class replaces the first. That is the
nameless rule showing up in the machine code, and every real case is one class per device anyway.

**The entry is registered as a foreign entry point.** Without that, internalization plus DCE deletes
the only symbol the declaration exists to produce — and the failure is silent: a kernel that installs a
vector pointing at nothing. The first probe of this feature emitted the handler and then dropped it
exactly that way.

Rejections implemented, each with a message that explains the rule rather than the parse: calling it
(qualified or via implicit `this`), returning non-void, any modifier at all (`static` first among them
— it would take away the object the handler exists to reach), and a second interrupt in one class,
which reports *one device, one handler* instead of the generic no-overloading message.

Thirteen tests, covering the declaration, both lowerings, and both reachability rules. Suite
682/682, pico 132/132.

## Hosted, and the shape of the answer

`interrupt` works outside freestanding. **The meaning is what makes it portable** — a method entered
by something outside the program, at a moment the program did not choose — and a POSIX signal is
exactly that. Only the lowering differs:

| | entry point | installed with |
|---|---|---|
| freestanding | `x86_intrcc`, `byval` frame | `Idt.install(vector, obj.interrupt)` |
| hosted | `void(i32)`, ordinary C ABI | `signal(SIGINT, obj.interrupt)` |

`void(int)` was chosen over a per-OS answer because it is what `signal()` takes on POSIX *and*
through the Windows CRT, so one shape installs on both. `codegen_interrupt_hosted_runs` proves it by
handing the entry to the C runtime's own `signal()` and raising the signal for real — nothing short
of running it shows that an entry point is genuinely callable by something that never heard of LDP3.

**The MODE decides the lowering, not the target triple.** The triple answers an ABI question (is
there an OS to promise a red zone); `freestanding` answers a language one (is there a runtime at
all). The analyzer knows only the mode, so keying codegen off the triple would let the two disagree —
a `Trap` accepted at the declaration and then never delivered.

**The trap parameter is world-shaped**, and both halves are errors. Bare metal hands over the frame
the CPU pushed, so the parameter is a class; a hosted world hands over a *code* — a signal number, a
console control type — so it is an integer, and no frame exists to point at. **The parameterless form
is the intersection**: a handler that does not care where it came from compiles for both worlds
unchanged.

## Rules 2 and 3 — built, and how

Both are about what the handler REACHES, not about its own body: the code it interrupted may be
standing inside the allocator, or holding the very lock a method three calls down would take.

**The call graph is recorded during the analyzer's ordinary walk, not by a second traversal.** That
is not just economy. A hand-written visitor over seventy AST node types has one failure mode — a node
nobody remembered — and it is silent: the analysis does not see that branch and reports nothing.
Recording at the points where the analyzer has ALREADY resolved a call or a field means anything it
can typecheck, this can follow.

**Every diagnostic carries the path.** `Log.record allocates on the heap` is a fact about `Log`, and
a fact about `Log` is not a bug. `an interrupt must not allocate on the heap (reached via drain,
record)` is, and it is the sentence that says which of the two to change.

**Rule 2** rejects, transitively: `new ... on heap`, `delete`, `synchronized`, and `await`.

**Rule 3** requires every MUTABLE field an interrupt reaches to be `volatile` or `atomic<T>` — the
rule invents no marker of its own, because "state something that can preempt me also touches" already
has two names in LDP3, for two real cases. Immutable is the default, so a driver's ports, buffers and
base addresses need no marking at all; what it catches is exactly the state a handler and a main loop
both write.

**The receiver decides whether state is shared, and the first version of this got it wrong.** It
flagged `e.code` on an `Entry` the handler had created two lines above — private by construction,
invisible to anything it preempted. A rule that fires on code that cannot be wrong teaches people to
reach for the escape hatch, and then protects nothing. So it fires on `this.field` and
`Class.staticField` only: both are shared by construction. *Stated limitation:* a shared object
passed in as a parameter and written through that parameter is not caught. The call graph closes most
of that gap on its own — a method called on the shared object checks its own `this` — but it is a
hole, and better written down than discovered.

**The escape hatch was verified, not assumed.** `atomic<int>` in a freestanding build emits
`atomicrmw add ... seq_cst` and `load atomic` inline, with no `__atomic_*` symbol to link. A rule
whose alternative did not exist on the target that needs it would only make correct programs
inexpressible.

Measured against the shape that matters: a handler reading a port and pushing into a ring the main
loop drains — `volatile` head and tail, an immutable `Ring` field, an immutable capacity — compiles
clean.

## Preemption: SETTLED, and not the way the tension above guessed

The section "The tension that decides the design" recommended (a) — cover handlers that do not switch
context, leave the timer's stub hand-written — and kept (b) as designed-not-built. **(b) is not
buildable on this calling convention, and that is now measured rather than suspected.**

The obvious route to (b) is to rewrite the frame in place: `iretq` pops RIP/CS/RFLAGS/RSP/SS off the
stack, so a handler that changes RIP and RSP resumes somewhere else. The handler HAS a pointer to
that frame — the `byval` parameter. Three experiments, all at -O2:

1. **Plain stores through the frame pointer are DELETED.** The whole function compiles to a single
   `iretq`. `byval` promises the callee a private copy, so dead-store elimination is entitled to
   remove writes nobody reads, and it does.
2. **A `volatile` store survives** — and in a hand-written IR function with no prologue it landed at
   `(%rsp)`, which looked like the real frame. That was a coincidence of that function having
   nothing else on its stack.
3. **The same thing written in LDP3, with `volatile` fields throughout, lands in SCRATCH.** The
   emitted handler is `subq $16,%rsp` … two stores … `addq $16,%rsp` … `iretq`. LLVM materialised
   the copy, wrote into it, and discarded it before returning.

So a scheduler written this way compiles, runs, and never schedules — the exact failure class this
keyword exists to make impossible, arrived at through the keyword itself.

**The trap is therefore READ-ONLY**, enforced, with the measurement in the error message. Read the
frame in the handler; switch on the way out, at a controlled point, which is what Linux's
`need_resched` does and for the same reason. A handler that must switch context still writes its
entry by hand — one stub, not the pattern, exactly as (a) said.

## DEBT — agreed 2026-08-11, to be resolved

**A `Signal` class in the standard library, so installing a hosted handler does not start with an
`extern cdecl` in user code.** Today the test writes its own:

```ldp3
public extern cdecl static method signal(int sig, address handler) returns address;
Posix.signal(2, box.interrupt);
```

That works and is not a gap in the keyword — `extern cdecl` is how LDP3 reaches a C symbol, by
design, and `signal()` belongs to the C runtime rather than to us. **What the debt buys is moving the
declaration once into the library** so the user writes an import instead:

```ldp3
import System.Os.Signal;
Signal.on(Signal.Interrupt, box.interrupt);
```

The `extern cdecl` still exists — inside that class. It does not disappear from the program, only
from everybody's program. Worth doing because the signal NUMBERS want naming too (`2` is not a
readable SIGINT), and because Windows and POSIX disagree about which ones exist, which is exactly the
kind of thing a library should absorb once.

Note the asymmetry that makes this hosted-only: **freestanding needs no `extern` at all.** The IDT is
the kernel's own table, so installing is a write to memory we own. The C boundary appears only
because a hosted program has an operating system in the middle holding the pointer.

**Full context switching from inside a handler**, per the section above. Not a gap to close later:
the convention cannot express it, so the language says so instead of pretending.

Related: [`persistent-keys.md`](persistent-keys.md) for the shape of a design note that settled an open
question before implementation, and §11.1 of the specification for the bit-field packing decided the
same day this note was written.
