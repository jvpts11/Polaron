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

All times in ms, best of 3. LDP3 is built with clang `-O2`. Both compilers are shown for
C/C++: MSVC `/O2` (Visual Studio Release) and clang `-O2` (same backend as LDP3).

| Benchmark   |  LDP3 | C (MSVC) | C++ (MSVC) | C (clang) | C++ (clang) |
|-------------|------:|---------:|-----------:|----------:|------------:|
| MatrixMul   | 292.2 | 293.1 | 293.8 | 284.9 | 301.0 |
| Mandelbrot  | 719.8 | 726.2 | 728.9 | 719.2 | 715.3 |
| Primes      | 270.7 | 264.0 | 269.8 | 256.9 | 264.1 |
| Fibonacci   | 242.6 | 363.3 | 367.9 | 249.0 | 250.6 |
| BinaryTrees | 726.9 | 721.2 | 728.4 | 693.9 | 720.7 |
| QuickSort   | 290.3 | 262.4 | 262.9 | 266.0 | 265.9 |
| MonteCarlo  |  73.0 | 105.4 | 104.4 |  73.5 |  74.3 |
| Collatz     | 130.8 | 209.6 | 212.4 | 132.1 | 131.9 |
| Regions     | 201.2 | 1281.8 | 1285.4 | 1281.5 | 1288.5 |

All checksums matched across the three languages and both compilers.

## Takeaway

- **Raw compute: LDP3 is on par with C and C++** (within run-to-run noise) on the same
  backend — it shares the LLVM optimizer and the generated IR is clean enough to optimize as
  well as hand-written C/C++.
- **vs MSVC, the LDP3 (clang) build wins clearly** on Fibonacci, Collatz, and MonteCarlo —
  a clang-vs-MSVC codegen difference, not a language one.
- **`regions` is a ~6.4× win** for LDP3: its built-in region (bump allocator) crushes naive
  malloc/free-per-object. A hand-rolled C arena would match it — the point is LDP3 gives you
  that arena for free, safely, with no ceremony.
- The value-semantics model costs nothing here (arrays are pointers; no class-by-value copies
  in the hot loops). QuickSort is the one kernel where LDP3 trails slightly (~9% vs clang) —
  array indexing carries a length-header offset; a candidate for later optimization.

## Notes / caveats

- `-ffp-contract=off` is used so FMA contraction does not change FP results across compilers
  (keeps the checksums identical).
- Timings are whole-process (process startup is negligible at these sizes).
- Single-threaded; parallelism (async/Thread) is phase F8.
