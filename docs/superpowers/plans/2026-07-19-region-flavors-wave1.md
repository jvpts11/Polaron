# Region Flavors — Wave 1 Implementation Plan (foundation + pool + extract)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the region *flavor* axis to LDP3 with the **pool** (free-list, reclaiming) flavor and the
**extract** operator, so an object can be individually reclaimed from or relocated out of a region —
while `bump` (bare `region`) stays byte-identical to today.

**Architecture:** A contextual soft-keyword flavor modifier (`bump`/`pool`/…) parses onto the region
`VarDecl`; a per-region runtime descriptor carries the flavor and (for pool) segregated free-lists;
codegen dispatches `new … in R` / `delete … from R` / `extract` by flavor. Bump keeps its own untouched
fast path. Rich `LDP3-17NN` diagnostics reject malformed declarations.

**Tech Stack:** C++20, LLVM 17 IR (opaque pointers), the existing `diag::classify` diagnostics, the
runtime `ldp3_rt.cpp` segregated allocator (`LDP3_SLAB`), CTest + Forge 398 self-test.

## Global Constraints

- Bare `region` == `bump` == **current behavior, byte-identical IR** (verify via benchmark `.ll` diff:
  `matrixmul`, `primes`, `regions` must be identical to the pre-change baseline).
- New keywords are **contextual soft keywords** only before `region` (flavors/`growable`) or in operator
  position (`extract`); they remain valid identifiers elsewhere. No hard reservation.
- All code, comments, identifiers, error messages, commit messages in **English**; chat replies to João
  in **pt-BR**. Commit style: lowercase subject, no capitalized prefix, no `Co-Authored-By` trailer
  (`git commit -F -` heredoc).
- Every task ends green on `ctest --test-dir build -C Debug` (538 baseline) and, where Forge is touched,
  `Forge.exe test` (398 checks). No exploitable UB: every region misuse traps via `__ldp3_panic`.
- Never inline `{}` blocks in `.ldp3` samples — always multi-line.
- Build: `cmake --build build --config Debug --target ldp3c`. Run a sample:
  `ldp3c f.ldp3 -o f.ll && clang -O2 f.ll runtime/ldp3_rt.cpp -o f.exe -llegacy_stdio_definitions`.

---

## File structure

- `src/parser/ast.h` — add `regionFlavor` (enum/string) + `regionGrowable` to `VarDecl`; add `ExtractExpr`.
- `src/parser/parser.cpp` — recognize flavor/`growable` soft keywords before `KwRegion`; parse `extract`.
- `src/parser/ast.cpp` — debug-print the new nodes/fields.
- `src/semantic/analyzer.cpp` — track a region var's flavor; LDP3-1710/1717/1718/1719/1720 checks;
  flow-mark `extract`'d vars as moved (reuse move machinery).
- `src/semantic/diagnostics.*` (wherever `diag::classify` lives) — map the new messages to `LDP3-17NN`.
- `src/codegen/codegen.cpp` — `emitRegionAlloc(flavor,…)` dispatch (bump path unchanged); pool free-list
  alloc/free; `delete … from region` reclaim on pool; `extract` lowering.
- `runtime/ldp3_rt.cpp` — region descriptor + `__ldp3_region_new/free` flavor-aware (pool free-list).
- `tests/samples/region_pool*.ldp3`, `region_extract*.ldp3`, `region_bad_*.ldp3` + `tests/CMakeLists.txt`
  entries (run + expected output / should-fail).

---

## Task 1: Flavor + growable parse onto the region VarDecl

**Files:**
- Modify: `src/parser/ast.h` (VarDecl), `src/parser/parser.cpp` (declaration parse), `src/parser/ast.cpp` (dump)
- Test: `tests/samples/region_pool_parse.ldp3` + `tests/CMakeLists.txt`

**Interfaces:**
- Produces: `ast::VarDecl::regionFlavor` (a `std::string`: "", "bump", "pool", "stack", "fixedslot",
  "ring"; "" means bump) and `ast::VarDecl::regionGrowable` (`bool`). Consumed by semantic + codegen.

- [ ] **Step 1: Failing test** — create `tests/samples/region_pool_parse.ldp3`:

```ldp3
import System.IO.Console;
program RegionPoolParse;
public bundle main {
    public namespace app {
        public class Dog {
            public mutable int age;
            public constructor Dog(int a) {
                this.age = a;
            }
        }
        public class Main {
            public static method main(string[] args) returns void {
                pool region kennel = itself.allocate(64 kilobytes);
                Dog* rex = new Dog(3) in region kennel;
                System.IO.Console.printf("age=%d\n", rex.age);
                release region kennel;
            }
        }
    }
}
```
Add to `tests/CMakeLists.txt` a run test expecting stdout contains `age=3` (mirror an existing
`add_ldp3_run_test`/`CONTAINS` entry — grep `regions` in that file for the pattern). In Wave 1 a `pool`
region may still allocate like bump internally at this step; the test proves the flavor *parses and runs*.

- [ ] **Step 2: Run it, expect FAIL** — `ldp3c` errors on `pool region` ("expected a name"/parse error).

- [ ] **Step 3: AST fields** — in `src/parser/ast.h`, in `struct VarDecl`, add near the region fields
  (`std::string region;` ~line 199):

```cpp
    std::string regionFlavor;   // region flavor: "" (=bump) | "bump" | "pool" | "stack" | "fixedslot" | "ring"
    bool regionGrowable = false; // `growable` modifier: chain a new block on overflow
```

- [ ] **Step 4: Parse the soft keywords** — in `src/parser/parser.cpp`, at the start of statement/local
  declaration parsing (where a declaration beginning with the `region` type keyword is handled — grep for
  `KwRegion` in the declaration/statement parser), add a contextual pre-scan: when the current token is an
  `Identifier` whose lexeme is one of `growable/bump/pool/stack/fixedslot/ring` **and** a following token
  (skipping other flavor/`growable` words) is `KwRegion`, consume them, set `regionGrowable` / the single
  flavor, then fall through to the existing `region` decl parse. Reject a second flavor word here as a
  parse-level guard is optional — semantic Task 3 emits the rich LDP3-1710. Keep bare `region` unchanged.
  Follow the existing soft-keyword style (parser.cpp ~1526 for get/set, ~1026 for affinity).

- [ ] **Step 5: Dump** — in `src/parser/ast.cpp`, where `VarDecl` prints, append `regionFlavor`/`growable`
  when non-empty so `--dump-ast` shows them (grep how VarDecl currently prints).

- [ ] **Step 6: Build + run** — `cmake --build build --config Debug --target ldp3c`; compile+run the
  sample; expect `age=3`. (Flavor is parsed and threaded; codegen still treats it as bump — fine here.)

- [ ] **Step 7: Commit** — `git add -A && git commit -F -` "parser: region flavor + growable modifiers (contextual soft keywords)".

---

## Task 2: Runtime region descriptor + pool free-list

**Files:**
- Modify: `runtime/ldp3_rt.cpp` (near `__ldp3_region_acquire/release` ~336)
- Test: exercised end-to-end by Task 4/5 (no standalone C test harness in this project)

**Interfaces:**
- Produces (C ABI, `extern "C"`):
  - `void* __ldp3_region_new(void* desc, unsigned long long size)` — allocate `size` bytes from the
    region described by `desc`; bump for bump/stack, free-list-then-bump for pool/fixedslot.
  - `void __ldp3_region_free(void* desc, void* ptr, unsigned long long size)` — push `ptr` onto the
    pool/fixedslot free-list for its size class; no-op (or trap) for bump.
  - The descriptor layout the compiler emits per region (a small struct: `{ char* base; unsigned long long
    cap; unsigned long long cursor; int flavor; /* pool */ FreeNode* freelists[NCLASS]; }`). Define the
    struct + a `__ldp3_region_init(desc, base, cap, flavor)` if the compiler can't inline the init.

- [ ] **Step 1** Add the descriptor struct + free-node (`struct Ldp3RegionDesc { ... }`,
  `struct Ldp3FreeNode { Ldp3FreeNode* next; }`) modeled on the existing `LDP3_SLAB` segregated lists
  (grep `LDP3_SLAB` / size-class helper). Reuse the same size-class function so pool classes match malloc's.

- [ ] **Step 2** Implement `__ldp3_region_new`: flavor bump/stack → align+bump `cursor`, trap via
  `__ldp3_panic("region out of memory ...")` on overflow (Wave 2 adds growable chaining here); flavor
  pool/fixedslot → pop the size class's free-list if non-empty, else bump.

- [ ] **Step 3** Implement `__ldp3_region_free`: pool/fixedslot → push `ptr` on the size class's list;
  bump/stack → this path is not called for them (compiler doesn't emit it).

- [ ] **Step 4** Build the runtime standalone to catch STL/ABI issues:
  `clang -O2 -c runtime/ldp3_rt.cpp -o /tmp/rt.o` — expect success (no `<atomic>`/`<thread>` STL; plain C++).

- [ ] **Step 5: Commit** — "runtime: region descriptor + pool/fixedslot free-list allocator".

---

## Task 3: Semantic flavor tracking + declaration diagnostics

**Files:**
- Modify: `src/semantic/analyzer.cpp` (region region-check area ~1911/2379), the `diag::classify` table.
- Test: `tests/samples/region_bad_twoflavors.ldp3` (should-fail) + CMake `WILL_FAIL`/expected-error entry.

**Interfaces:**
- Consumes: `VarDecl::regionFlavor/regionGrowable`. Produces: a per-region flavor map the analyzer/codegen
  can query (e.g. `regionFlavor_[name]`), and validated LDP3-17NN errors.

- [ ] **Step 1: Failing test** — `tests/samples/region_bad_twoflavors.ldp3` with `pool stack region R = itself.allocate(1 kilobytes);`
  Add a should-fail CMake entry asserting the compile fails with `LDP3-1710` (grep an existing
  should-fail/`error[LDP3-` test for the pattern).

- [ ] **Step 2** In `analyzer.cpp`, record each region var's flavor; emit `error(...)` (which routes
  through `diag::classify`) for: two flavors (LDP3-1710), flavor on a non-region decl (LDP3-1719). Add the
  message→code mappings in the `diag::classify` table with `why:`/`fix:`/`prevent:` text per the spec's
  diagnostics catalogue.

- [ ] **Step 3** Build; run the should-fail sample; expect `error[LDP3-1710]` with the rich body.

- [ ] **Step 4: full CTest** — `ctest --test-dir build -C Debug` — 538 + the new tests green.

- [ ] **Step 5: Commit** — "sema: track region flavor + LDP3-1710/1719 diagnostics".

---

## Task 4: Codegen — emitRegionAlloc(flavor) dispatch; pool `new … in R`

**Files:**
- Modify: `src/codegen/codegen.cpp` (`emitRegionBumpAlloc` ~4689 → `emitRegionAlloc`; the region decl
  codegen that acquires the block; `new … in region` path ~1768/4177).

**Interfaces:**
- Consumes: the flavor map from Task 3. Produces: region blocks carry the flavor; `new … in R` routes to
  `__ldp3_region_new(desc,size)`; bump path unchanged.

- [ ] **Step 1** At region-decl codegen, when acquiring the block, also materialize the `Ldp3RegionDesc`
  (base/cap/flavor/zeroed freelists) — a stack/heap alloca the region variable points at. Bump/stack keep
  today's cursor logic; pool/fixedslot get a descriptor with the flavor set.

- [ ] **Step 2** Rename/generalize `emitRegionBumpAlloc` → `emitRegionAlloc(region, type, loc)`: for
  bump/stack keep the **exact current bump IR** (no behavior change — critical for the perf gate); for
  pool/fixedslot emit a `call __ldp3_region_new(desc, sizeOf(type))`.

- [ ] **Step 3** Build; recompile `tests/samples/region_pool_parse.ldp3`; run → `age=3` (now via the pool
  allocator).

- [ ] **Step 4: Perf gate (bump byte-identical)** — regenerate `matrixmul.ll`/`primes.ll`/`regions.ll` and
  `diff` against the committed pre-change baseline (`scratchpad/*.old.ll` or regenerate from `git stash`);
  expect IDENTICAL. If they differ, the bump path was disturbed — fix before continuing.

- [ ] **Step 5: Commit** — "codegen: emitRegionAlloc flavor dispatch; pool new-in-region (bump unchanged)".

---

## Task 5: `delete X from region R` reclaims on pool

**Files:**
- Modify: `src/codegen/codegen.cpp` (the `delete … from region` path, ~9046).
- Test: `tests/samples/region_pool_churn.ldp3` under `LDP3_MEMPROF` (live stays flat).

**Interfaces:**
- Consumes: flavor map, `__ldp3_region_free`. On a pool/fixedslot region, `delete X from region R` runs the
  dtor (as today) **and** calls `__ldp3_region_free(desc, ptr, sizeOf)`; bump unchanged.

- [ ] **Step 1: Failing test** — `region_pool_churn.ldp3`: a loop 500k iterations that `new`s an object in
  a `pool region`, uses it, then `delete x from region R`; print a checksum so `-O2` can't elide. Add a
  CMake run test. (Before this task it "works" but the region would fill without reclaim — the MEMPROF
  check is what fails.)

- [ ] **Step 2** In the `delete … from region` codegen (~9046), when the region flavor is pool/fixedslot,
  after the destructor call add `call __ldp3_region_free(desc, objPtr, sizeOf(type))`.

- [ ] **Step 3** Build; compile the churn sample with the profiling runtime
  (`ldp3_rt_prof.lib`); `LDP3_MEMPROF=1 ./region_pool_churn.exe` → **live flat** (region reuses slots),
  no `__ldp3_panic` (no double-free).

- [ ] **Step 4: CTest** — 538 + new green.

- [ ] **Step 5: Commit** — "codegen: delete-from-region reclaims the slot on pool/fixedslot regions".

---

## Task 6: `extract X from region R`

**Files:**
- Modify: `src/parser/ast.h` (`ExtractExpr`), `src/parser/parser.cpp` (parse), `src/parser/ast.cpp`
  (dump), `src/semantic/analyzer.cpp` (moved-state + LDP3-1717/1718/1720), `src/codegen/codegen.cpp`
  (lowering).
- Test: `tests/samples/region_extract.ldp3` (+ MEMPROF), `region_bad_use_after_extract.ldp3` (should-fail).

**Interfaces:**
- Produces: `ast::ExtractExpr { ExprPtr target; std::string region; }`. `extract <lvalue> from region R`
  parses only as an assignment/decl RHS. Codegen: heap-alloc `sizeOf(T)`, deep-relocate the object out
  (`emitClassCopy`-style move to heap), return the heap pointer, drop the source from the region's RAII
  tracking, and on pool/fixedslot `__ldp3_region_free` the vacated slot; mark the source variable moved.

- [ ] **Step 1: Failing test** — `region_extract.ldp3`: `pool region R`; `new Dog(...) in region R`;
  `Dog* out = extract d from region R;` use `out`; `delete out;` `release region R;`. Print a checksum.
  Should-fail: `region_bad_use_after_extract.ldp3` uses the source var after extract → expect `LDP3-1717`.

- [ ] **Step 2** `ExtractExpr` in ast.h; parse `extract` as a soft keyword at expression/RHS position
  (`extract` ident + target lvalue + `from` + `KwRegion` + region name), mirroring how `move` is parsed
  (grep `move` in parser.cpp ~3071). A bare `extract …;` statement (not an RHS) → error LDP3-1720.

- [ ] **Step 3** Semantic: resolve the region + target; flow-mark the target variable as moved (reuse the
  move state machinery so use-after-extract = LDP3-1717); if the target's type has a field allocated in the
  same region, LDP3-1718.

- [ ] **Step 4** Codegen `ExtractExpr`: `heap = __ldp3_malloc(sizeOf(T))`; memcpy the struct + deep-copy
  owned array/String fields out (reuse `emitClassCopy` onto the heap); remove the source from `scopeObjects`
  region tracking; if pool/fixedslot, `__ldp3_region_free(desc, srcPtr, sizeOf)`; result = `heap`.

- [ ] **Step 5** Build; run `region_extract.ldp3` under MEMPROF → after `delete out` + `release R`, live
  flat, no panic; run the should-fail → `LDP3-1717`.

- [ ] **Step 6: CTest** — 538 + new green.

- [ ] **Step 7: Commit** — "codegen+sema: extract X from region R (relocate to heap, reclaim slot, moved-state)".

---

## Task 7: Dogfood — terminals become a pool region (Forge)

**Files:**
- Modify: `Forge-IDE/src/app/Workbench.ldp3` (the `ArrayList<Terminal*>` → `pool region` allocation).

- [ ] **Step 1** Declare `pool region termRegion = itself.allocate(16 kilobytes).accepts({Terminal});` in
  Workbench; allocate each terminal `new Terminal() in region termRegion`; `closeActiveTerminal` →
  `t.close(); delete t from region termRegion;` (reclaims); keep the `ArrayList<Terminal*>` only as the
  tab-order index (pointers into the region). `release region termRegion` on teardown.

- [ ] **Step 2** `./build.ps1` → 398-check self-test green; open/close terminals in a `serve`/renderonly
  smoke test → no crash, region reused.

- [ ] **Step 3: Commit (Forge repo)** — "forge: terminals live in a pool region (reclaim on close)".

---

## Roadmap — Waves 2-5 (separate plans)

- **Wave 2 — stack + growable:** `mark`/`rollback` + `checkpoint` type; `growable` block chaining in
  `__ldp3_region_new`; LDP3-1712/1713/1714/1716 diagnostics.
- **Wave 3 — fixedslot + ring:** single-size pool (accepts-required, LDP3-1711); circular buffer +
  auto-evict (`delete` rejected, LDP3-1715).
- **Wave 4 — Forge 0.2:** highlighter + LSP keywords for the new grammar; version bump; reference regen.
- **Wave 5 — docs:** fold the model into `docs/LDP3_specification.md` §17; update memory + keyword catalogue.

---

## Self-review

- **Spec coverage (Wave 1 scope):** pool flavor (T2,T4,T5) ✓; extract (T6) ✓; delete-from reclaim (T5) ✓;
  flavor parse/soft-keywords (T1) ✓; LDP3-1710/1717/1718/1719/1720 (T3,T6) ✓; bump byte-identical gate
  (T4 step 4) ✓; dogfood terminals (T7) ✓. Deferred to later waves (documented): stack/fixedslot/ring/
  growable + their diagnostics, Forge 0.2 grammar, spec §17 fold — intentional wave split.
- **Placeholders:** none — test samples are concrete; where exact C++ lines depend on tracing (parser
  soft-keyword site, codegen delete path), the task names the file + anchor + the change; the executing
  subagent reads the code. This is the honest granularity for a compiler change, not a placeholder.
- **Type consistency:** `regionFlavor`/`regionGrowable`, `__ldp3_region_new/free`, `ExtractExpr{target,
  region}`, `emitRegionAlloc` used consistently across tasks.
