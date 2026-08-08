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

## Open questions — these need the author

1. **Modifier or a distinct kind of method?** Leaning modifier, beside `naked`. But if `interrupt`
   carries enough meaning to be its own declaration form, that is a call about the language's shape.
2. **Binding to a vector: explicit registration or a declaration-site annotation?**
   `Idt.install(32, Isr.onTimer)` has no magic and lets one handler serve several vectors; an annotation
   puts the fact where the handler is. Leaning explicit.
3. **Is rule 3 an error or a warning in v1?** An error is what the language promises. But it can make
   existing code inexpressible before `atomic<T>` is known to work bare-metal — **and that has not been
   verified**. Worth checking before deciding.
4. **Hosted lowering: which one?** A POSIX signal handler and a Windows Ctrl-C handler are both honest
   readings of "entered, not called". Picking one, both, or making it a world-level decision changes how
   portable a handler's source is.

## What exists today

Nothing. No lexer token, no parser support, no AST node, no codegen. `interrupt` is not currently a
reserved word, so adding it is a breaking change for any program using it as an identifier — worth a
grep across his own LDP3 before committing to the spelling.

Related: [`persistent-keys.md`](persistent-keys.md) for the shape of a design note that settled an open
question before implementation, and §11.1 of the specification for the bit-field packing decided the
same day this note was written.
