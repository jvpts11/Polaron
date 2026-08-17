# Polaron

**High level, to the bare metal.**

**Polaron** is an object-orientation–mandatory, manually memory-managed systems language that compiles
to native code through LLVM. It aims to be as fast as C and C++ while being safer by construction —
value semantics, no garbage collector, and no *exploitable* undefined behaviour.

Created by João Victor Pereira Tavares.

```polaron
import System.IO.Console;

program Hello;

public bundle Hello {
    public namespace App {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello, world!");
            }
        }
    }
}
```

*Formerly `LDP3`, which was a placeholder and is now only the name of some old links.*

---

## Getting started

```
polaron new hello        # scaffold a project
cd hello
polaron run              # build it and run it
```

That is the whole loop. `polaron` is the project driver; `polc` underneath it is the compiler. The
other verbs are `build`, `test`, `check`, `fmt`, `doc`, `explain`, `plug`, and `studio` — run
`polaron --help` for the list.

To use a library somebody published:

```
polaron plug https://github.com/jvpts11/Polaron-OpenGL@v1.0.1
```

It is fetched into `libraries/`, compiled, and recorded in your `polaron.toml`. What that library needs
on the link line travels inside its bundle, so your manifest does not have to know about it.

## Why Polaron

- **OOP-mandatory, no ceremony.** Everything lives in a `class`; there are no free functions. Sensible
  defaults keep the common case terse — `new Thing()` is on the stack with RAII — and the explicit
  form is there when you need the cannon.
- **Manual memory, made safe.** `new`/`delete`, RAII, and value semantics: assignment is a deep copy,
  and you share with `T*`/`T&` when you mean to. **Ownership** (`move`/`movable`/`unique`) and
  **regions** (bump, pool, stack, fixedslot, ring arenas) give control without a collector — and the
  region binder refuses, at compile time, to place a value whose lifetime it cannot prove.
- **No exploitable UB.** Bounds, division and casts are checked or saturated, never left undefined.
- **A conversion is a relation, not a favour.** `transformer`s name the conversion between two types,
  and `entrusts` is how a type hands over the right to construct it.
- **Rich, modern surface.** Generics (monomorphized, no erasure), `record`/`struct`/`union`/`enum`,
  `sealed` hierarchies with exhaustive `match`, `Result`/`Option`, exceptions, contracts
  (`requires`/`ensures`/`invariant`), `async`/`await`, channels, reflection, comptime, SIMD, FFI, and a
  freestanding mode for bare metal.
- **Diagnostics that teach.** Every error carries a stable code and, by default, *why* it happened,
  *how* to fix it, and *how* to avoid it next time. `polaron explain Polaron-0405` prints any of them.
- **Native speed.** An LLVM back end with a small optimizing middle-end, on equal footing with C and
  C++ on the same workloads.

## Documentation

The canonical documentation is the book-length reference under [`docs/reference/`](docs/reference/):

- [The Language Reference](docs/reference/README.md) — a teaching reference with runnable examples:
  program structure, types, memory and ownership, OOP, control flow, functions and lambdas, errors and
  contracts, concurrency, metaprogramming, systems programming, testing, the toolchain, every
  diagnostic code, and every keyword.
- [The Standard Library](docs/reference/stdlib/) — collections, text and encoding, math, parsing, time.
- [`docs/POLARON_specification.md`](docs/POLARON_specification.md) — the original design document, in
  Portuguese. The reference above is what the compiler is checked against.

[`examples/`](examples/) holds twenty-one complete programs, from `hello.pol` to regions, ownership,
transformers, generics, concurrency and FFI. Every one of them is compiled and run by the test suite,
and checked against the output its own header promises.

## What runs today

The suite is 952 tests. Besides the host, it builds for and **executes on**:

| Target | How it is tested |
|--------|------------------|
| x86-64 Windows | the primary target; the whole suite |
| x86-64 Linux | the whole suite, under WSL and native |
| i686 | a kernel booted under QEMU (`pc`, CPU `pentium3`), read back over the serial port |
| aarch64 | a kernel booted under QEMU (`virt`, cortex-a57), over a PL011 UART |
| wasm32 | loaded and clicked in a real browser, screenshotted |

## Building the compiler

C++20, CMake, LLVM 17+.

```
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=<vcpkg-root>/scripts/buildsystems/vcpkg.cmake -DPOLARON_WITH_LLVM=ON
cmake --build build --config Release
ctest --test-dir build -C Release -j 12
```

**Release, and `-j`.** Measured on the full suite: Debug takes 234 s and Release 35 s, and almost all of
the difference is the compiler processing its embedded standard library once per test.

A Windows installer that bundles a self-contained toolchain — compiler, linker, CRT — is built from
[`installer/`](installer/); it needs no Visual Studio on the target machine.

## License

See [LICENSE](LICENSE).
