# Porting Polaron

*Specification, 2026-08-12. What it takes to run Polaron on an architecture or an operating system it
does not run on today — hosted and bare metal, current hardware and old. Written from measurement:
every "today" below was checked against the tree on the date above, not read off the spec.*

## Where it stands today, measured

**Rewritten 2026-08-14, when the port stopped being a plan.** The prediction this table used to carry
— "the runtime divides by OS and not by processor, so it compiles for AArch64 without a line changed"
— was exactly right, and it is now demonstrated rather than reasoned: the runtime cross-compiled for
three architectures with no change at all, and for FreeBSD with none either.

| what | state |
|---|---|
| Windows x86-64 | the whole suite, **753/753** |
| Linux x86-64 | the whole suite, **754/754** — and the compiler itself builds there |
| **FreeBSD 14.4 x86-64** | the runtime compiles with **no change**, and a program runs |
| AArch64 hosted | cross-compiled and **run** under `qemu-aarch64`; in the suite |
| RISC-V 64 hosted | cross-compiled and **run** under `qemu-riscv64`; in the suite |
| i686 hosted | cross-compiled and **run** under `qemu-i386`; in the suite |
| AArch64 / i686 bare metal | boot in QEMU inside the suite |
| wasm32 | a self-contained module, rendered in a real browser by the suite |
| macOS | **not run.** The one call that stops it is named below |
| data layout | x86-64, AArch64, i686, wasm32, RISC-V |
| `asm` verification | **x86-64 only** — it refuses by instruction name |
| interrupts | `x86_intrcc`, unconditional — **x86-64 only** |

**"Runs on most distributions" is not about distributions.** It is about symbol versions: a binary
built against glibc 2.43 records references up to `GLIBC_2.34` (2021, where pthread moved into libc),
and an older machine refuses to start it with a message about the dynamic loader rather than about the
program. `polaron build --static` links the C library in — no `PT_INTERP`, no versioned symbol, 93 KB
becomes 1.4 MB — and the kernel is then the only compatibility question left. Test
`build_static_has_no_glibc_requirement` asserts the ABSENCE, because a static link that quietly fell
back to dynamic would still link and still run on the machine that built it.

**What still stops macOS**, all in `polaron_rt.cpp`:

- `dl_iterate_phdr` with `<elf.h>`/`<link.h>` — `reimport` reads the on-disk ELF to restore a
  function's bytes, and macOS is Mach-O. That is real work, not a rename.
- ~~`/proc/self/exe`~~ and ~~`getrandom`~~ — **done**: `_NSGetExecutablePath` and `arc4random_buf`.
  Both were found by FreeBSD, where the first returned an empty string and reported nothing.

## The rule that decides everything: `address` is 64 bits, always

```
address       64      the address type
half address  32
short address 16      (`short` already means 16)
byte address   8      (`byte` already means 8)
```

`address` does **not** follow the target's width, and that is a decision, not an omission.

> A compiler that infers a width is a compiler that can be wrong about one. Polaron states widths and
> checks them; the narrowing is a `cast` the author wrote, and a mismatch is an error before the
> program is built rather than an overflow after it ships. This is the same rule that already forbids
> implicit conversion between integer widths, and it exists because the opposite is C's fatal error —
> one of the reasons this language exists at all.

**A pointer is not an `address`.** `T*` is whatever the target's pointer width is; `address` is a
64-bit integer that can hold one on any target of 64 bits or fewer. On a 32-bit machine `cast<address>(p)`
widens and `cast<T*>(a)` narrows, both written. **This is what makes 32-bit targets possible without
`address` moving.**

The narrower forms are **domain types**, not a portability mechanism. They exist for addresses that
are genuinely not the machine's pointer: a real-mode 16-bit offset, a 6502 zero page, a physical
address stored narrow inside a hardware structure. Today those are written `uint16` and the intent is
lost.

## What a port must supply, in order

### 1. Data layout — required, and currently missing off x86-64

`setTargetTriple` sets a layout only when the triple contains `x86_64`/`amd64`. Everywhere else the
module ships **without one**, and the comment beside it explains the cost in its own words: a
layout-less module aligns `i64` to 4, so every field load emits `align 4`.

On x86-64 that is lost vectorization. On targets where unaligned access is a fault rather than a
slowdown it is worse than lost performance. **Every new target contributes its layout string, taken
from clang's own for that triple.** No target ships without one.

### 2. Calling convention — one row

`worldToCallConv` maps a world to an LLVM convention. A new architecture adds its raw ABI beside
`win64`/`sysv`/`aapcs`, and its binary format if that format is new.

### 3. `asm` verification — per architecture

The verifier knows x86-64 and refuses by instruction name. An ARM kernel's `asm` would be rejected
wholesale, or worse, waved through unchecked.

This matters more than it looks: **the verifier was built because pico's hand-written `asm` had
errors nobody could see by reading.** A port that leaves it x86-only ships the new architecture
without the check that found those. Each architecture brings its own mnemonic set, its own clobber
rules and its own dialect default.

### 4. Interrupts — a design decision, not a translation

`interrupt` lowers to `x86_intrcc` unconditionally. AArch64 has no such convention: it has an
exception vector table and `eret`, which is a different shape — entries at fixed offsets, one per
exception class and level, not one per vector.

So the keyword's **meaning** is portable ("entered, not called") and its lowering is not, which is
already stated in `interrupt.md` for the hosted case. Extending it by architecture is the same
question asked again, and it has to be answered per target rather than derived.

### 5. Whatever the runtime asks of the OS

The runtime divides by OS. A new OS supplies: file read/write, directory listing, `mprotect`-equivalent
(needed by `unimport`), a clock, threads if the program uses them, and sockets if it uses those. Dead
code stripping means a program pays only for what it touches — a freestanding image pays for none of
it.

## Target tiers

**Tier 1 — tested, in CI.** x86-64 Windows, x86-64 Linux. What exists today.

**Tier 2 — reachable now.** AArch64 Linux / macOS / Windows. Triples, convention and runtime are
already in place; what is missing is the layout string, the `asm` verifier, and testing. **This is
where the next port should go, and the cheapest way to start is not a port at all: compile an
existing Polaron program for `aarch64-linux` and read what breaks.** Not pico — that is x86 by nature —
but `psh` or a sample. That produces the real list in hours, where reasoning produces a list of
suspicions. Expect the data layout to surface first.

**Tier 3 — a row each.** RISC-V 64, LoongArch64, PowerPC64LE, s390x. LLVM generates for all of them;
each needs a convention row, a layout string, and an `asm` verifier if the target runs kernel code.

**Tier 4 — needs a design decision first.** WebAssembly (no `asm`, no interrupts, a different memory
model). 32-bit targets: possible under the pointer/`address` split above, but nothing has exercised
it and the `asm` verifier, the interrupt lowering and the freestanding entry all assume 64.

## Bare metal

A freestanding image asks nothing of an operating system and everything of the CPU. What it needs
from a port, beyond the four layers above:

- **A red-zone answer.** The rule in the tree is "no OS in the triple ⇒ no red zone", and it is set as
  a function attribute rather than a flag, because `-mno-red-zone` is a front-end flag that reaches
  nothing when the input is `.ll`. A new architecture states whether it has a red zone at all.
- **A general-registers-only answer.** x86-64 freestanding is built with `-mgeneral-regs-only`
  because the SSE registers cannot be saved across an interrupt. Every architecture with a
  vector unit has this question.
- **An entry point.** Freestanding emits `kmain` instead of `main` and skips argv construction.
- **The provided symbols.** `__polaron_panic`, `__polaron_malloc`/`_free`/`_check_live` from the `heap
  class`, and `__polaron_unload_fn`/`_reload_fn` if the program uses `unimport`. The String helpers are
  generated, not linked.

## Old machines and old operating systems

Two floors, and they are different.

**Hosted** is bounded by the runtime's newest API, and only for programs that reach it — dead
stripping means an unused API is not a requirement:

| what the program uses | floor |
|---|---|
| subprocesses with a pseudo-console | `CreatePseudoConsole` — **Windows 10 1809 (2018)** |
| threads | `CONDITION_VARIABLE` — **Windows Vista (2007)** |
| files, sockets, `unimport` only | `CreateFileW`, `VirtualProtect`, `WSAStartup` — **Windows XP x64 (2005)** |
| Linux, any of the above | `clock_gettime`, `mprotect`, `pthread`, `dl_iterate_phdr` — **kernel 2.6 (~2004)** |

**Bare metal has no OS floor at all.** The floor is the CPU.

And on both, the real floor is `address`: **64 bits means a 64-bit machine**, so the oldest hardware
that runs Polaron today is an **AMD Opteron or Athlon 64, April 2003** — with Windows XP Professional
x64 (2005) or a 2.6-series Linux.

A 386, a Pentium, an Amiga or a Z80 do not run Polaron, and the obstacle is not the backend. Reaching
them means the pointer/`address` split above being exercised for real, plus the Tier-4 work. It is a
port of the language's assumptions, not of its code generator.

## What porting is not allowed to do

- **Ship a target without a data layout.** The one thing measured to be missing today is the one
  thing every new target must bring.
- **Ship a target whose `asm` is unverified.** Silence there is what the verifier exists to end.
- **Infer a width.** No target changes what `address` means.
