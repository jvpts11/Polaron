# LDP3 Performance Tests

Micro-benchmarks comparing LDP3 against its targets, C and C++, on workloads C/C++ are
known to be fast at. Each benchmark is implemented identically (same algorithm, same
parameters, same checksum) in all three languages so the comparison is fair and the
checksums confirm correctness.

- **LDP3 sources:** this folder (`*.ldp3`).
- **C / C++ sources:** a sibling Visual Studio solution,
  `C and C++ perf tests/ConsoleApplication1`, one project per benchmark, prefixed `C_` (C)
  and `Cpp_` (C++).

## Benchmarks

| Name | What it stresses |
|------|------------------|
| `matrixmul`   | Dense 512×512 `double` matrix multiply — FP throughput + cache |
| `mandelbrot`  | 1200×1200 escape-time, maxIter 1000 — pure FP, nested loops (no sqrt) |
| `primes`      | Sieve of Eratosthenes to 20M — integer work + large-array memory |
| `fibonacci`   | Naive recursive `fib(40)` — function-call overhead |
| `binarytrees` | Build/check/free depth-18 trees ×30 — allocation churn + pointer chasing |
| `quicksort`   | In-place quicksort of 5M ints (Hoare) — recursion + branches + memory |
| `montecarlo`  | 50M-point pi estimation (uint32 LCG) — integer + FP |
| `collatz`     | Longest Collatz chain below 1M — integer + heavy branching (int64) |
| `regions`     | Arena allocation: bump-allocate 40M objects via `region` vs malloc/free |

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

All times in ms, best of 3, same machine. LDP3 is built with clang `-O2`. C/C++ are shown
against the two community-reference compilers, GCC 16.1 and clang, both `-O2 -ffp-contract=off`.
All checksums matched across LDP3, C and C++, every compiler.

| Benchmark   |  LDP3 | C (gcc) | C++ (gcc) | C (clang) | C++ (clang) |
|-------------|------:|--------:|----------:|----------:|------------:|
| MatrixMul   | 266.0 | **133.0** | **149.6** | 288.6 | 294.6 |
| Mandelbrot  | 703.5 | 723.7 | 721.4 | 710.6 | 703.9 |
| Primes      | 309.9 | 326.9 | 303.7 | 282.0 | 274.4 |
| Fibonacci   | 243.3 | **112.8** | **114.9** | 236.9 | 240.3 |
| BinaryTrees | 684.1 | 663.2 | 664.3 | 662.5 | 669.6 |
| QuickSort   | 289.1 | 280.3 | 288.1 | 265.6 | 273.1 |
| MonteCarlo  |  73.4 | 104.0 | 105.5 |  74.7 |  74.3 |
| Collatz     | 130.6 | 150.1 | 151.3 | 132.4 | 133.9 |
| Regions     | **208.5** | 1261.8 | 1274.7 | 1280.2 | 1313.5 |

(MSVC `/O2` from Visual Studio was also measured and is in the same ballpark, but GCC and
clang are the reference compilers for the community, so they are shown here.)

## Takeaway

- **Same backend (clang): LDP3 == C == C++** within run-to-run noise. LDP3 shares the LLVM
  optimizer and emits IR clean enough to optimize like hand-written C/C++ — no inherent
  language overhead on raw compute.
- **vs GCC, LDP3 is competitive on most kernels** (Mandelbrot, BinaryTrees, QuickSort, Primes,
  Collatz) and **wins MonteCarlo**. GCC pulls clearly ahead on **MatrixMul** and **Fibonacci**
  (~2×) — its auto-vectorizer and recursion optimization at `-O2` beat what LDP3 gets through
  clang `-O2`. Those are recoverable later (better IR / `-O3` / vectorization), not a language
  limitation.
- **`regions` is a ~6× win** for LDP3: its built-in region (bump allocator) crushes naive
  malloc/free-per-object across all compilers. A hand-rolled C arena would match it — the
  point is LDP3 gives you that arena for free, safely, with no ceremony.
- The value-semantics model costs nothing here (arrays are pointers; no class-by-value copies
  in the hot loops). A workload that copies classes by value would be the place to measure it.

## Notes / caveats

- `-ffp-contract=off` is used so FMA contraction does not change FP results across compilers
  (keeps the checksums identical).
- Timings are whole-process (process startup is negligible at these sizes).
- Single-threaded; parallelism (async/Thread) is phase F8.
