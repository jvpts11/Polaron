# Polaron Performance Tests

Micro-benchmarks comparing Polaron against its targets, C and C++, on workloads C/C++ are
known to be fast at. Each benchmark is implemented identically (same algorithm, same
parameters, same checksum) in all three languages so the comparison is fair and the
checksums confirm correctness.

- **Polaron sources:** this folder (`*.pol`).
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

## Building & running (Polaron)

**Pass `-O2` to `polc`.** This is not a detail — it is the single most important line on this page.
`polc` defaults to `-O0` for **its own middle end**, so without the flag the loop interchange and
the bounds-check hoisting never run and the backend cannot recover what they would have produced.
`polaron build` always passes it; a hand-written command line does not. Every number published here
before 2026-08-12 was measured without it, and understated `matrixmul` by **12×** (349 ms → 29 ms).

```
build-local\bin\Release\polc.exe -O2 "performance tests\matrixmul.pol" -o "performance tests\matrixmul.ll"
clang -O2 -ffp-contract=off "performance tests\matrixmul.ll" runtime\polaron_rt.cpp -o "performance tests\matrixmul.exe" -llegacy_stdio_definitions -Wno-override-module
"performance tests\matrixmul.exe"
```

Everything here is scripted: **`bench-all.ps1`** builds and times Polaron against the C references in
`c-reference\` with the same alignment and the same `-ffp-contract=off`, and refuses to compare arms
whose checksums disagree. Run it **inside vcvars64** — without it clang links nothing, and a missing
executable times as ~1 ms, which reads as an impossibly fast benchmark rather than as the error it is.

C/C++/Fortran references: `c-reference\*.c`, built with GCC (see below).

## Results (2026-08-12, AMD Ryzen 7 7800X3D, best of 3, ms)

Polaron: `polc -O2` + `clang -O2`. C: **GCC 16.1.0** (MinGW-w64 UCRT), which is the bar — it produces
the fastest C/C++/Fortran code available, so measuring against clang proves nothing about whether the
language is fast. All checksums matched across every arm.

| Benchmark   | Polaron | gcc -O2 | gcc -O3 | vs best GCC |
|-------------|------:|--------:|--------:|------------:|
| Regions     | **105.5** | 1150.5 | 1155.0 | **10.9× faster** |
| Fibonacci   |  **14.2** |  109.5 |   98.1 |  **6.9× faster** |
| MatrixMul   |  **29.0** |  186.0 |  198.2 |  **6.4× faster** |
| BinaryTrees | **140.8** |  580.6 |  580.2 |  **4.1× faster** |
| MonteCarlo  |  **67.3** |   90.9 |   93.2 |  **1.35× faster** |
| Collatz     |  **88.3** |  102.6 |  102.0 |  **1.16× faster** |
| QuickSort   |   224.7 |  **215.7** |  221.7 |  4% slower (within alignment noise) |
| Mandelbrot  |   721.6 |  **657.8** |  658.3 |  **9.7% slower** |
| Primes      |    54.2 |   **45.5** |   46.0 |  **19% slower** |

**Where the wins come from.** `MatrixMul` and `Fibonacci` are not backend luck: `polc`'s own middle
end does two transforms LLVM will not. Loop interchange turns the strided `ijk` inner loop into a
unit-stride one that the vectorizer then handles (GCC gets there by outer-loop vectorization, which
LLVM lacks) — measured 349 ms → 29 ms. Recursive inlining flattens self-recursion enough that CSE can
share subtrees; GCC does this too, we do it deeper. `Regions` and `BinaryTrees` are the allocator: a
region is a bump pointer released whole, against malloc/free per object.

**The two that break the rule** — Polaron must be faster than, or equal to, perfect hand-written C:

- **Primes (19%)**: the sieve's *inner* loop is versioned and runs unchecked, but the **outer** loop
  keeps a per-iteration bounds check over 20 M iterations. Compare + branch × 20 M ≈ 9 ms, and the
  whole deficit is 8.7 ms. The access is `sieve[i]` inside an `if` **condition**, which is the shape
  `hoistBoundsChecks` appears not to collect.
- **Mandelbrot (9.7%)**: not yet diagnosed.

## Superseded results (2026-06-25) — measured without `polc -O2`

The table that used to be here reported Polaron at 266 ms on MatrixMul and 243 ms on Fibonacci and
concluded GCC was "~2× ahead" on both. That conclusion was an artifact of invoking `polc` with no
`-O` flag, so the middle end was off. With it, both are 6× the other way. Kept only as a warning:
a benchmark harness that does not build the way the product builds measures a compiler nobody ships.

## Old results (2026-06-25, best of 3 runs, ms)

Polaron is compiled with clang `-O2`; the comparison below shows both the targets as normally
built (MSVC `/O2` from Visual Studio) and built with the same backend (clang `-O2`) to
isolate language overhead from compiler differences. All checksums matched across the three
languages.

All times in ms, best of 3, same machine. Polaron is built with clang `-O2`. C/C++ are shown
against the two community-reference compilers, GCC 16.1 and clang, both `-O2 -ffp-contract=off`.
All checksums matched across Polaron, C and C++, every compiler.

| Benchmark   |  Polaron | C (gcc) | C++ (gcc) | C (clang) | C++ (clang) |
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

- **Same backend (clang): Polaron == C == C++** within run-to-run noise. Polaron shares the LLVM
  optimizer and emits IR clean enough to optimize like hand-written C/C++ — no inherent
  language overhead on raw compute.
- **vs GCC, Polaron is competitive on most kernels** (Mandelbrot, BinaryTrees, QuickSort, Primes,
  Collatz) and **wins MonteCarlo**. GCC pulls clearly ahead on **MatrixMul** and **Fibonacci**
  (~2×) — its auto-vectorizer and recursion optimization at `-O2` beat what Polaron gets through
  clang `-O2`. Those are recoverable later (better IR / `-O3` / vectorization), not a language
  limitation.
- **`regions` is a ~6× win** for Polaron: its built-in region (bump allocator) crushes naive
  malloc/free-per-object across all compilers. A hand-rolled C arena would match it — the
  point is Polaron gives you that arena for free, safely, with no ceremony.
- The value-semantics model costs nothing here (arrays are pointers; no class-by-value copies
  in the hot loops). A workload that copies classes by value would be the place to measure it.

## Notes / caveats

- `-ffp-contract=off` is used so FMA contraction does not change FP results across compilers
  (keeps the checksums identical).
- Timings are whole-process (process startup is negligible at these sizes).
- Single-threaded; parallelism (async/Thread) is phase F8.
