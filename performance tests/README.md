# LDP3 Performance Tests

Micro-benchmarks comparing LDP3 against its targets, C and C++, on workloads C/C++ are
known to be fast at. Each benchmark is implemented identically (same algorithm, same
parameters, same checksum) in all three languages so the comparison is fair and the
checksums confirm correctness.

- **LDP3 sources:** this folder (`*.ldp3`).
- **C / C++ sources:** the Visual Studio solution at
  `C:\Users\jvpts\Documents\GitHub\C and C++ perf tests\ConsoleApplication1`, one project
  per benchmark, prefixed `C_` (C) and `Cpp_` (C++).

## Benchmarks

| Name | What it stresses |
|------|------------------|
| `matrixmul`   | Dense 512×512 `double` matrix multiply — FP throughput + cache |
| `mandelbrot`  | 1200×1200 escape-time, maxIter 1000 — pure FP, nested loops (no sqrt) |
| `primes`      | Sieve of Eratosthenes to 20M — integer work + large-array memory |
| `fibonacci`   | Naive recursive `fib(40)` — function-call overhead |
| `binarytrees` | Build/check/free depth-18 trees ×30 — allocation churn + pointer chasing |

## Building & running (LDP3)

```
build\bin\Debug\ldp3c.exe "performance tests\matrixmul.ldp3" -o "performance tests\matrixmul.ll"
clang -O2 -ffp-contract=off "performance tests\matrixmul.ll" runtime\ldp3_rt.c -o "performance tests\matrixmul.exe" -llegacy_stdio_definitions
"performance tests\matrixmul.exe"
```

C/C++: build the VS solution in `Release|x64`, or `clang -O2 -ffp-contract=off` the sources.

## Results (2026-06-25, best of 3 runs, ms)

LDP3 is compiled with clang `-O2`; the comparison below shows both the targets as normally
built (MSVC `/O2` from Visual Studio) and built with the same backend (clang `-O2`) to
isolate language overhead from compiler differences. All checksums matched across the three
languages.

### vs MSVC (Visual Studio Release /O2)

| Benchmark   | LDP3 | C (MSVC) | C++ (MSVC) |
|-------------|-----:|---------:|-----------:|
| MatrixMul   | 297.9 | 296.5 | 295.5 |
| Mandelbrot  | 704.5 | 723.7 | 728.0 |
| Primes      | 295.3 | 286.4 | 286.3 |
| Fibonacci   | 241.6 | 365.6 | 364.9 |
| BinaryTrees | 699.7 | 724.6 | 735.8 |

### Same backend (all clang -O2)

| Benchmark   | LDP3 | C (clang) | C++ (clang) |
|-------------|-----:|----------:|------------:|
| MatrixMul   | 304.7 | 311.7 | 314.8 |
| Mandelbrot  | 707.9 | 715.1 | 721.1 |
| Primes      | 319.8 | 312.8 | 322.2 |
| Fibonacci   | 240.3 | 248.5 | 244.8 |
| BinaryTrees | 731.8 | 710.1 | 715.7 |

## Takeaway

With the same backend, **LDP3 is on par with C and C++ (within run-to-run noise)** on these
raw-compute kernels: it shares the LLVM optimizer and the generated IR is clean enough to
optimize as well as hand-written C/C++. The value-semantics model does not cost anything
here because arrays are pointers and there are no class-by-value copies in the hot loops
(workloads that copy classes by value would be a separate, fairer place to measure that cost).

## Notes / caveats

- `-ffp-contract=off` is used so FMA contraction does not change FP results across compilers
  (keeps the checksums identical).
- Timings are whole-process (process startup is negligible at these sizes).
- Single-threaded; parallelism (async/Thread) is phase F8.
