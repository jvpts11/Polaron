<!-- LDP3 — Linguagem De Programação 3. -->

# LDP3

**LDP3** (*Linguagem De Programação 3*) is an object-orientation–mandatory, manually
memory-managed systems language that compiles to native code through LLVM. It aims to be
as fast as C and C++ while being safer by construction — value semantics, no garbage
collector, and no *exploitable* undefined behaviour.

Created by João Victor Pereira Tavares.

```ldp3
import System.IO.Console;

program Hello;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello, world!");
            }
        }
    }
}
```

## Why LDP3

- **OOP-mandatory, no ceremony.** Everything lives in a `class`; there are no free
  functions. Sensible defaults keep the common case terse, with explicit syntax available
  when you need the "cannon".
- **Manual memory, made safe.** `new`/`delete`, RAII, and value semantics (assignment is a
  deep copy; share with `T*`/`T&`). Compile-time **ownership** (`move`/`movable`/`unique`)
  and **regions** (bump/pool/stack/fixedslot/ring arenas) give control without a GC.
- **No exploitable UB.** Bounds, division, and casts are checked or saturated rather than
  left undefined.
- **Rich, modern surface.** Generics, `record`/`struct`/`union`/`enum`, pattern `match`,
  `Result`/`Option`, exceptions, contracts, `async`/`await`, reflection, comptime, SIMD,
  FFI, and a freestanding mode for bare-metal targets.
- **Native speed.** LLVM back end with a small optimizing middle-end; on equal footing with
  C/C++ on the same workloads.

## Documentation

The canonical language documentation is the book-length reference under
[`docs/reference/`](docs/reference/):

- [The Language Reference](docs/reference/README.md) — a teaching reference with runnable
  examples: types, memory & ownership, OOP, control flow, errors & contracts, concurrency,
  metaprogramming, systems programming, and a full keyword reference.
- [The Standard Library](docs/reference/stdlib/) — collections, text/encoding, math, and more.

Small, self-contained programs live in [`examples/`](examples/).

## Building the compiler

LDP3 is written in C++20 and builds with CMake against LLVM 17+.

```
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=<vcpkg-root>/scripts/buildsystems/vcpkg.cmake -DLDP3_WITH_LLVM=ON
cmake --build build --config Debug
ctest --test-dir build -C Debug
```

The compiler is `ldp3c` and the project driver is `ldp3`. A Windows installer that bundles
a self-contained toolchain (compiler + linker + runtime) is built from
[`installer/`](installer/).

## Compiling a program

```
ldp3 build            # builds an ldp3.toml project
# or, a single file:
ldp3c hello.ldp3 -o hello.ll && clang hello.ll -o hello.exe
```

## Status

Windows x86-64 is the primary target today; a Linux x86-64 port is in progress. The
language core, standard library, and toolchain are in active development.

## License

See [LICENSE](LICENSE).
