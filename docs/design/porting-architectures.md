# Porting Polaron to other architectures

*Record, 2026-08-13. Written after measuring, and the measurement changed what the work is.*

The goal: run Polaron on old machines — late-1990s and 2000s hardware — reaching ARM first, then
WebAssembly, then whatever else is relevant. On a machine too old for a feature, **the compiler is
allowed to refuse and say so**, which is what this document is mostly about.

## The finding: the backends already work

Before writing anything, every candidate target was tried end to end — Polaron source → `polc
--target=<triple>` → LLVM IR → `clang -c` → object file:

| target | IR | object |
|---|---|---|
| `aarch64-unknown-linux-gnu` | yes | yes |
| `aarch64-unknown-none-elf` (bare metal) | yes | yes |
| `armv7-unknown-linux-gnueabihf` (32-bit ARM) | yes | yes |
| `i686-unknown-linux-gnu` (32-bit x86 — the 90s machines) | yes | yes |
| `wasm32-unknown-unknown` | yes | yes |
| `riscv64-unknown-linux-gnu` | yes | yes |

The AArch64 disassembly is real AArch64 (`sub sp, sp, #0x60`, `str x30, [sp, #0x50]`). The driver's
triple table already carried `aarch64-windows`, `aarch64-linux` and `aarch64-macos`.

**So "porting to ARM" is not writing a backend.** LLVM has the backends and the compiler already hands
them a triple. The work is everything *around* that: what breaks silently, what cannot exist on a given
machine, and whether the compiler says so or lets the failure surface somewhere unhelpful.

## What was wrong, and is now fixed

**An `asm` block's architecture was never checked.** `asm("x86_64") { hlt }` compiled for AArch64
travelled all the way to clang's assembler and failed there:

```
<inline asm>:1:3: error: too few operands for instruction
        hlt
```

A message about a line of assembly, in a file called `<inline asm>`, with no path back to the Polaron
source that wrote it or the target that made it wrong. Porting a program consists mostly of finding
exactly these. Now:

```
error: this `asm` block is written for x86_64, and the target is aarch64. Assembly cannot be ported by
the compiler: give the block for this architecture, or guard the method so it is not reached here
  --> asm_wrong_arch.pol:6:17
   6 |                 asm("x86_64") { hlt }
```

Compared by architecture **family**, so `x86_64`/`amd64` are one answer and `aarch64`/`arm64` another,
and an unknown name is not judged — a target this compiler has never heard of is not evidence that the
author's assembly is wrong. Note `x86` (32-bit) is deliberately *not* the same family as `x86_64`: the
register file and the ABI differ, and a block written for one is wrong on the other.

Tests: `codegen_asm_wrong_arch_errors`, `codegen_asm_right_arch_ok`. And the check was run against the
one program that would notice: **pico has 43 `asm("x86_64")` blocks** and still passes 132/132, because
its bare-metal triple `x86_64-unknown-none-elf` is the same family. A check that refuses nothing real
is the failure mode to watch for here, and that is what makes pico the acceptance test.

**Only x86-64 had a data layout.** Every other target produced a layout-less module, which is correct
downstream (clang re-applies its own) but blind to *our* in-process passes — and a layout-less module
aligns `i64` to 4, which is exactly what stops the SIMD vectorizer on the hot reduction loops the
benchmark suite measures. Layouts are now set for aarch64 (ELF and MSVC), 32-bit ARM, i686 (ELF and
MSVC), wasm32 and riscv64.

**Every one of those strings was read out of clang**, not written from memory: `clang --target=T -S
-emit-llvm` on an empty file prints the layout that target actually uses. A hand-written layout that is
subtly wrong does not fail — it silently misaligns, and the cost appears as a vectorizer that stopped
firing on one architecture and nowhere else.

## The gap the diagnostic exposed: there is no way to write per-architecture code

Writing the message above forced the question of what it should *advise*, and the honest answer turned
out to be uncomfortable. The first draft said "guard the method so it is not reached here" — and that
advice does not exist:

- **`demand <cond> otherwise "why"`** is a compile-time *assertion*, not conditional compilation. It
  can refuse a build; it cannot select between two bodies.
- **The manifest carries ONE `target`** and has no per-target source selection, so a program cannot
  ship an x86 file and an ARM file and have the right one chosen.

So today a program has exactly one architecture's assembly in it, and porting means editing that
assembly. **The single largest missing language feature for the port is conditional compilation by
target** — whatever its eventual spelling. Every other item on this page is work; that one is a design
decision, and it is worth taking deliberately rather than discovering under pressure when a second
architecture actually needs to build.

The message now says what is true: the block has to be written for the target, or the program built
for the block's architecture.

## POLARON RUNS ON ARM. And on a Pentium III.

*Added the same day, after the section below said the port was unproven until something ran.*

Two bare-metal projects now boot under QEMU as part of the suite: `tests/arm64` on the AArch64 `virt`
board (`cortex-a57`), and `tests/i686` on a `pc` with `-cpu pentium3` — a real late-1990s CPU, which is
the machine this whole port was aimed at. Each prints through the only console its board has and
computes `sum(i² for i in 1..100)` in a `long`; the test asserts `0x529ae` on the serial line. That
number is the point of the exercise: on i686 every shift below 32 bits crosses a register boundary, so
it comes out right only if the 32-bit lowering is right. Tests `port_aarch64_boots`, `port_i686_boots`,
skipped rather than failed when QEMU is absent.

The source is ordinary Polaron — a class, a constructor, methods, a `while`, a `byte*` walk. The only
architecture in either file is how a byte leaves the machine: a volatile store to the PL011 that `virt`
maps at `0x09000000`, against an `out dx, al` to COM1 on the PC. That is the claim being tested — that
the *language*, and not a subset of it, reaches another machine.

**What was actually broken was all in the driver**, and none of it was the compiler:

- **`-mno-red-zone` was passed unconditionally.** It is an x86-64 System V idea; AArch64 clang rejects
  it as an unknown argument and the build stops. Flags now come from `bareMetalFlagsFor(triple)`, which
  also knows that `-mgeneral-regs-only` applies on ARM and AArch64 for the same reason it applies on
  x86 (nobody saves vector state across an interrupt) and nowhere else.
- **The bare-metal link passed `-m elf_x86_64`.** lld's error names the emulation rather than the flag,
  so it reads as a broken toolchain rather than a driver that only knew one architecture.
- **The freestanding runtime was x86 assembly, unconditionally.** `memcpy`/`memset`/`memmove` (LLVM
  emits calls to these from loops nobody wrote) and the default `__polaron_panic`. There are now two
  halves, and both are the right answer for their machine: x86-64 keeps `rep movsb`, which is not a
  byte loop written differently but the instruction the CPU implements memcpy with; everywhere else
  gets a C++ implementation, compiled `-ffreestanding -fno-builtin` so the loop-idiom pass cannot turn
  those loops into calls to themselves.
- **The panic console had nowhere to go.** COM1 at port 0x3F8 is a genuine x86-wide convention — no
  driver, no mapping, works before anything is initialised, which is exactly when guards fire. AArch64
  has no equivalent, because a UART's address there is a fact about the *board*. So the manifest gained
  `[freestanding] panic_uart = "0x09000000"`, and with nothing named the default panic halts **without
  printing**. A guessed UART address is a store into live memory, and a wrong one is worse than silence.
- **`.bss` was never zeroed by anything we control.** x86 hid this completely: the PVH and multiboot
  loaders zero the gap between `filesz` and `memsz`, so a global that had to start at zero did, and
  nothing in the toolchain ever had to say so. QEMU's `-kernel` on `virt` does not. The generated
  linker script now emits `__bss_start`/`__bss_end` and each boot stub zeroes the range itself — which
  is where that job belonged all along.

And a bug written and caught the same hour: the first version of the "which runtime" predicate read
`x86_64 || i686`, which reads correctly and assembles nothing — the assembly in question is written in
`rdi`/`rsi`/`rcx`. 32-bit x86 takes the portable path, with COM1 through inline `outb` since port I/O
is an x86 idea and not an x86-64 one.

## WebAssembly: it links, and a feature it lacks is refused

**The module is real.** `polc --target=wasm32-unknown-unknown` → `clang -c` → `wasm-ld` produces a
file whose first eight bytes are `\0asm\1\0\0\0` and whose body holds the compiled method — verified
in the suite by `port_wasm32_links`, which checks the magic and finds the symbol. That is a step past
"the backend accepts it": an object can be emitted for a target whose linker then rejects it.

It stops there. There is no wasm host on this machine — no node, no wasmtime — so nothing has *run*.
Unlike ARM, that is a missing **tool** rather than missing work.

**And the first real feature gate landed here.** A threaded program compiled cleanly for wasm32 and
emitted four calls to `__polaron_thread_spawn`, which a bare module has no import for; the failure
would have surfaced at link, naming a symbol the author never wrote. Now it is refused at the call,
with the reason: a bare WebAssembly module runs on one thread, and spawning needs the atomics and
bulk-memory proposals plus a host that provides the shared memory and the workers. Test
`port_wasm32_threads_error`, which asserts the *sentence* and not merely a non-zero exit — a compiler
that refused for an unrelated reason would pass a test that only checked the exit code.

**The gate had to move once, and the reason is the general lesson.** The first version checked where
`Thread.start()` reaches the runtime — a line in the *prelude*, emitted for every program whether or
not it uses threads. So a wasm module that never mentioned a thread was refused, with a caret pointing
into a file its author had never opened. It now checks at the program's own call, where the receiver's
class and the caller are both known. **A check that refuses something correct is worse than no check**,
and this is the second time that has been the failure mode here: the `asm` architecture check was
validated against pico's 43 blocks for exactly this reason.

`requireTargetFeature(feature, what, loc)` is the one place these live, so the next one is a branch
rather than a new mechanism.

## The second gate, and the worst diagnostic found so far

**`interrupt` is an x86 calling convention.** It lowers to `x86_intrcc`, which LLVM implements for x86
and x86-64 and nowhere else: the CPU pushes a specific frame and the handler returns with `iret`.
AArch64 and RISC-V both have interrupts, by a different mechanism with a different frame — so this is
not a lowering we are missing, it is one that does not exist.

Ungated, polc emitted the IR happily and **clang's backend died on it**:

```
fatal error: error in backend: unsupported calling convention
PLEASE submit a bug report to https://github.com/llvm/llvm-project/issues/
Stack dump: ...
```

No source line, no method name, and an invitation to file a bug against LLVM for a decision *this*
compiler made. It is the clearest example yet of what these gates are for. Now:

```
error: `interrupt` is an x86 calling convention and this target is aarch64-unknown-none-elf. A handler
declared this way expects the frame an x86 CPU pushes and returns with `iret`; `Timer.interrupt`
cannot be built for another architecture ... Build for x86, or write the handler for this machine as a
`naked` method with its own entry sequence
```

Test `port_interrupt_needs_x86`. And pico, which has interrupt handlers throughout and builds for
`x86_64-unknown-none-elf`, still passes 132/132 — a gate that refuses something real is the failure
mode to watch for, and pico is what watches for it.

## What is still open, honestly

- **The runtime is not cross-compiled.** `polaron_rt.cpp` builds for the host. A *hosted* program on
  ARM needs it built for ARM; the freestanding path cross-compiles (that is how both boot tests work),
  so the machinery exists and has not been pointed at a hosted cross-target.
- **Nothing has run on wasm**, for want of a host on this machine.
- **Three feature gates are still unwritten.** `asm` (architecture), `syscall` (target) and threads
  (wasm) are checked; these are not, and each is a place an old machine will differ:
  - **SIMD** (`vec2`/`vec3`/`vec4`/`mat4`) on a target without it — a Pentium II has no SSE2, wasm
    needs `simd128`, ARMv7 needs NEON.
  - **64-bit atomics on 32-bit targets** — `atomic<long>` on i686 or ARMv7 needs `cmpxchg8b`/LDREXD,
    absent on the oldest of them.
  - **`address` is 64 bits always** (a deliberate identity decision). On a 32-bit target a pointer is
    32 bits and an `address` still 64 — which works, and means every `cast<address>` round trip must
    be checked on those targets rather than assumed. The i686 boot test exercises 64-bit arithmetic
    for exactly this reason, and it is right; the pointer round trip is not yet covered.
- **The oldest floor is now partly measured.** The porting spec put the floor at `address`=64 → an
  Opteron of 2003. The i686 image **boots on a `-cpu pentium3`**, so bare metal reaches further back
  than that. What remains unmeasured is the *hosted* floor, which the runtime decides.
