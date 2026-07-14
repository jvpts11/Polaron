# LDP3 stdlib expansion — curated research (2026-06-29)

Filter (João's principle): **add pure capabilities and genuinely good data/memory engineering — especially
where it synergizes with LDP3's persistents / type-safe regions / ownership — but DO NOT port features that
exist only to mitigate a language's own paradigm faults** (procedural-ness, lack of OOP/generics, a rigid
borrow checker, no exceptions, UB-by-default). LDP3 sidesteps those at the language level, so the stdlib
should be *feature-rich*, not *patch-rich*.

Sources surveyed: Rust (std + canonical crates), Go, C++ (STL + C++20/23/26), Zig std, Odin core, Swift,
Kotlin, C.

---

## A. Things to ADD, by domain

### A1. Iterators & functional pipelines  ★ biggest "feels modern" win
LDP3 today: `for-in` over a `toArray()` snapshot. Modern langs all have **lazy, composable iteration**.
- **Iterator/Iterable interface** + lazy adapters: `map`, `filter`, `take`, `skip`, `zip`, `enumerate`,
  `chain`, `flatMap`, `windows`, `chunks`, `stepBy`, `takeWhile`, `dropWhile`, `peekable`.
- **Terminal ops**: `collect`, `reduce`/`fold`, `sum`, `count`, `any`/`all`, `find`, `min`/`max`,
  `sorted`, `groupBy`, `partition`, `toMap`.
- Source: Rust `Iterator`, C++ ranges, Go 1.23 range-over-func, Swift Sequence. **Pure feature.**
- LDP3 angle: implement as an `Iterator<T>` interface (OOP-native) — cleaner than Go's func-iterators,
  and lazy so no intermediate allocations. This single addition removes most of the "thin" feeling.

### A2. Slices / Spans / Views  ★ pairs with regions/ownership
- **`Span<T>` / `Slice<T>`**: a non-owning view `{ptr, len}` over contiguous memory (array, region block,
  collection backing). Sub-slicing, bounds-checked (LDP3 no-UB).
- Source: C++ `std::span`, Rust slices, Go slices, Zig slices.
- LDP3 angle: a view that **explicitly does not own** maps perfectly onto `T*`/regions; lets you pass
  windows into region-allocated data with zero copies and zero ownership confusion.

### A3. Collections (modern, performance-oriented)
- **Colony / Hive** ★ (C++26 `std::hive`, plf::colony): stable element addresses, O(1) insert/erase,
  no reallocation invalidation. **Flagship for games** (particles/entities). See LDP3-unique below.
- **SlotMap / generational arena** ★ (Rust `slotmap`, ECS staple): stable `Key{index,generation}`
  handles, O(1) everywhere, use-after-free-proof. Synergizes with ownership.
- **Insertion-ordered map** (`LinkedHashMap` / Rust `indexmap` / Python dict): keeps insertion order —
  extremely commonly wanted, we lack it.
- **flat_map / flat_set** (C++23): sorted-vector-backed, cache-friendly for small/medium maps.
- **Ring buffer** (fixed-capacity circular): audio, networking, bounded queues.
- **Small/inline vector** (Rust `smallvec`, Folly): inline storage for the common small case, heap only on
  growth. Pure perf.
- **Bitset / dynamic bit vector** (C++ `std::bitset`, Rust `bitvec`): compact flags, set algebra.
- **Multiset / Multimap**, **immutable/persistent (structural-sharing) collections** (optional, heavier).
- **Sorting + search utilities**: stable sort, sort-by-comparator, binary search, `Comparator` combinators
  (byKey, reversed, thenBy). We have ordered trees but no general sort over arrays/lists.

### A4. Strings & text
- **`format(...)` returning String** with a real spec: width, alignment, fill, precision, hex/oct/bin,
  thousands grouping (`{x:>8.2f}`). Source: Rust `format!`, C++ `std::format`/`std::print`. We have
  interpolation; this is the programmatic sibling.
- **Missing String ops**: `split`, `join`, `replace`/`replaceAll`, `splitLines`, `padStart/End`, `repeat`
  (have some — fill gaps).
- **Regex** ★ (everyone has it; real gap): match/find/replace/groups/named groups.
- **UTF-8 / Unicode**: codepoint & grapheme iteration, `chars()`, length-in-codepoints, case folding;
  normalization optional. Source: Swift, Rust.
- **Text scanning**: a `Scanner`/`Lexer` helper (token/number/line reading) for parsers and CLIs.

### A5. I/O — streams, paths, processes
- **Reader / Writer interfaces** ★ + buffered wrappers (Go `io.Reader/Writer`, Rust `Read/Write`):
  composable IO is the backbone of real apps; we only have Console + File whole-file ops.
- **Path / FileSystem**: path join/normalize/extension, dir listing, metadata, exists/mkdir/remove,
  glob, temp files. Source: Rust `std::path` + `std::fs`, Go `path/filepath` + `os`.
- **Process / subprocess**: spawn, args, env, pipes, exit code, capture stdout. Source: Go `os/exec`,
  Rust `Command`.
- **Env, args, stdin/stdout/stderr** as first-class streams.
- **Binary IO / ByteBuffer + endianness** (Go `encoding/binary`, Rust `byteorder`): read/write
  int/float/varint LE/BE — needed for file formats and the wire.
- **Memory-mapped files**: synergize with `region at address` (already exists).

### A6. Serialization & encoding
- **Reflection-driven (de)serialization** ★★ (serde-style): LDP3 has **reflection + annotations + Field
  get/set** — we can offer `@Serializable`-style auto JSON/binary with NO codegen ceremony. This is a
  feature most stdlibs can't do cleanly. **Flagship.**
- **Binary format** (MessagePack/CBOR-ish or a native compact format).
- **CSV**, **TOML** (config), optionally YAML/XML.
- **Base64 / hex / URL-percent encoding**; **checksums** (CRC32, Adler32).

### A7. Networking
- **HTTP client** ★ (request/response, headers, JSON helpers) — big gap; **HTTP server** (Go `net/http`).
- **URL** parse/build/encode.
- **UDP** (have TCP `Socket`), **DNS resolve**.
- TLS/HTTPS and WebSocket: heavier, likely via FFI later.

### A8. Concurrency (we have strong primitives — add the missing ones)
- **Synchronization primitives**: `Semaphore`, `CondVar`, `RwLock`, `Barrier`, `CountDownLatch`,
  `WaitGroup`, `Once`. Source: Go `sync`, Rust `std::sync`. (These are genuine OS primitives, not
  paradigm patches.)
- **Thread pool / executor** API (we have an async worker pool internally — expose it).
- **Task combinators**: `all`/`join`, `any`/`race`, `timeout`, `withCancellation` (we have
  `Channel.select`).
- **Concurrent collections**: lock-free/blocking queue, concurrent map.
- **Structured concurrency** scopes (Swift/Kotlin/Java) — modern, fits OOP well.

### A9. Math & numerics
- **Complex**, **Rational**, **BigDecimal** (arbitrary precision, vs the fixed-18 `Decimal` primitive).
- **Matrices** mat2/3/4 (+ transforms) to go with the SIMD `vecN` — games/graphics.
- **Statistics**: mean/median/variance/stddev/percentile.
- **Random**: distributions (uniform/normal), explicit seeding/streams, **secure random** (CSPRNG).
- **Typed units / quantities** ★: leverages LDP3 **literal suffixes** (`5 meters`, `3 kilograms`) with
  compile-time dimensional checking — a feature most languages bolt on awkwardly; LDP3 has the syntax
  natively (already used for `ByteSize`).

### A10. Time & date
- Have Instant/Duration. Add **calendar**: Date/DateTime/LocalDate/Time-of-day, time zones, **format/parse**
  (strftime-style), Stopwatch, monotonic clock, scheduling helpers.

### A11. Crypto / hashing / identity
- **Hashing**: expose non-crypto hashes (FNV/xxHash/SipHash — the String one exists internally for maps);
  crypto SHA-256/SHA-3/BLAKE3, HMAC (SHA-256 already implemented internally for `.ldb` — expose it).
- **UUID/GUID** v4 + v7 (time-ordered) ★ — universal need.
- **Crypto** (AES/ChaCha, ed25519, X25519): heavier, FFI-backed later.

### A12. Diagnostics & app utilities
- **Logging** ★ (structured, leveled — Go `slog`, Rust `tracing`): universal.
- **CLI argument parsing** ★ (clap/cobra/Go `flag`): subcommands, flags, help generation.
- **Testing framework** (assert library + runner) — user-facing (we have doctest internally).
- **Assertions / contracts runtime** (we have `requires`/`ensures` — a stdlib `assert` + `debugAssert`).
- **Config** (env + file), **Benchmarking timer**.
- **Stack traces / panic-abort** introspection.

---

## B. Things to deliberately NOT port (paradigm patches — LDP3 already wins)

- **Rust `Rc`/`Arc`/`RefCell`/`Cell`/`Cow`/`Pin`**: these exist to negotiate the borrow checker. LDP3
  shares and mutates via `T*`/`T&`, **regions**, and **persistents** — no reference-counting churn needed.
- **Go `any`/`interface{}` + type assertions** as a generics substitute: LDP3 has real generics + OOP.
- **Rust `Wrapping`/`Checked`/`Saturating`/`NonZero` integer wrappers**: LDP3 has **no-UB arithmetic at
  the language level** (saturate/trap/check) — overflow handling isn't a stdlib opt-in here.
- **Go `errors`/Rust `anyhow`/`thiserror` boilerplate**: LDP3 has exceptions **and** Result/Option — the
  error-plumbing crates exist because those langs lack one or the other.
- **C manual vtable / function-pointer-table idioms**: virtual dispatch is built in.
- **`context.Context` cancellation threading (Go)**: keep *cancellation* as a feature; drop the manual
  plumbing — structured concurrency + ownership carry it.
- **Ubiquitous `unsafe` escape-hatch APIs (Rust)**: manual memory is the norm here and **type-safe
  regions** remove most of the danger, so we don't need an `unsafe`-shaped surface.
- **Go `defer`-as-only-cleanup**: we have destructors/RAII + `defer` + `using` — richer already.

Principle: if a stdlib item's reason-for-existing is "the language made memory/typing painful," skip it.
If it's "this is a genuinely useful capability or data structure," take it.

---

## C. LDP3-UNIQUE flagships (no other stdlib can do these cleanly)

1. **Persistent-backed Colony/Hive** ★ — a pool with stable element identity where elements are
   **persistents**, so a particle system / entity store keeps identity across reattach and over the
   program's life. (João's idea.) C++ has hive; nobody has hive × persistence.
2. **Region-allocated containers** ★ — `ArrayList`/`HashMap`/etc. that allocate **into a region** and are
   freed en masse, **with type-safe region guarantees**. Zig/Odin push arena allocators but they are
   untyped/unsafe; LDP3's regions are type-safe → safer arenas than the languages that made arenas famous.
2b. **Slot map with ownership-checked handles** — generational keys + `unique`/`movable` integration =
    compile-time-leaning use-after-free safety on top of runtime generations.
3. **Reflection+annotation auto-serialization** ★ — `@Serializable` derive with no macros/codegen, via
   the existing reflection + Field get/set.
4. **Typed quantities via literal suffixes** ★ — dimensional analysis using the native `N suffix` syntax.
5. **Persistent caches / memoization** — caches that survive `unimport`/`reimport`.

---

## C2. Wave 2 — advanced & UNIQUE (things no language ships in its base lib)

João's insight: a base stdlib can include things others force you to reach for libraries for. Each of
these is a *pure capability*, and several are LDP3-exclusive when crossed with persistents/regions/ECS.

### C2.1 Scientific computing in the base Math lib  ★★★ flagship theme ("scipy built in")
- **Automatic differentiation (autodiff)** ★ — forward + reverse mode. Crown jewel: the basis of ML,
  gradient optimization, physics. Almost no language ships it in std. With operator overloading + generics
  LDP3 can offer `derivative(f)` / gradient over a `Dual`/tape type.
- **Symbolic + numeric calculus**: numeric `derivative(f, x)` (finite diff), `integral(f, a, b)`
  (adaptive Simpson / Gauss-Legendre), symbolic differentiation over expression trees.
- **ODE solvers**: Euler, RK4, adaptive Runge-Kutta-Fehlberg.
- **Root finding**: bisection, Newton-Raphson, secant, Brent.
- **Optimization**: gradient descent, Nelder-Mead, BFGS, simplex (linear programming).
- **Interpolation/curves**: linear, cubic spline, Lagrange, Bézier, Catmull-Rom.
- **Linear algebra (general NxM)**: solve Ax=b, LU/QR/SVD/Cholesky, inverse, determinant, eigen,
  least-squares. (Beyond the mat2/3/4 for graphics.)
- **FFT/DFT** — signal processing; **convolution**, windowing.
- **Polynomials**: eval, roots, fitting/regression.
- **Statistics (deep)**: distributions (normal/poisson/binomial/…) pdf/cdf/quantile, hypothesis tests,
  correlation, linear/logistic regression.
- **Number theory & combinatorics**: gcd/lcm, prime sieve, modpow, factorization, nCr/nPr, factorial.
- **Special functions**: gamma, beta, erf, Bessel.
- **Geometry**: 2D/3D primitives, intersections, convex hull, **quaternions**, distance/closest-point.
- **Bit ops**: popcount, clz/ctz, byteswap, rotate. **Constants**: math + physical.

### C2.2 Advanced data structures
- **Graphs** ★: adjacency list/matrix, BFS/DFS, Dijkstra/A*, topo sort, MST (routing, games, build tools).
- **Spatial** ★: quadtree/octree, k-d tree, BVH, R-tree — collision/queries (crosses `vecN` + colony).
- **Trie / radix tree** (autocomplete, routers); **Rope** (large-text editing).
- **Probabilistic**: Bloom filter, Cuckoo filter, HyperLogLog, Count-Min sketch.
- **Range queries**: Fenwick (BIT), segment tree, sparse table.
- **Union-Find / disjoint set**; **Skip list**; **LRU/LFU cache**.

### C2.3 Game / realtime engine kit  ★ (showcase: beat C++ for games)
- **ECS (Entity-Component-System)** ★★ — built on **colony + slotmap + persistents**: the canonical
  modern game architecture, native and persistence-aware. Nobody ships ECS+persistence in std.
- Object pools (persistents/regions), transforms/scene graph, easing/tweening, spline paths.
- **Noise**: Perlin/Simplex/value (procedural gen). **Color**: RGBA/HSV/linear-sRGB.
- Fixed-timestep loop helpers, frame timing, input mapping.

### C2.4 Embedded storage / DB  ★★ (showcase: a DB engine — massive persistents synergy)
- **Embedded key-value store** (LSM-tree or B-tree) **on persistents/regions**; **write-ahead log**;
  page cache; MVCC. LDP3's persistents make durable in-process storage a *native* primitive — a
  differentiator no procedural/managed lang has.

### C2.5 Compression & data engineering
- **Compression**: gzip/deflate, zstd, lz4, run-length. (Universal need — files, network.)
- **Columnar / Arrow-like** buffers; **schema + validation**.
- **Diff** (Myers) + 3-way merge; **fuzzy** (Levenshtein, Jaro-Winkler).

### C2.6 Parsing & DSLs  ★ (LDP3 already has compile-time DSL ambitions)
- **Parser combinators / PEG**; **lexer/scanner toolkit**; **pretty-printer**; **template engine**.
- **Grammar-driven** config/format readers reused across CSV/TOML/JSON.

### C2.7 Parallel algorithms & advanced concurrency
- **Parallel map/sort/reduce/scan** (C++ `std::execution::par`); **work-stealing scheduler**.
- **Lock-free** queue/stack/hashmap; **STM** (software transactional memory) — interesting with persistents.
- **Reactive streams / dataflow**; **channels select** (have) extended to fan-in/out.

### C2.8 Observability, i18n, reactive
- **Metrics + tracing spans + profiler hooks** (built-in observability).
- **i18n**: locale, collation, message formatting, pluralization, number/date locale.
- **Reactive**: signals / observables / computed values (groundwork for native GUI later).

---

## C3. Wave 3 — Java/C# OOP-stdlib parity + features that resonate with LDP3's systems
(Scientific domain is considered done; this wave hunts everywhere else.)

### C3.1 Java/C# collection-framework gaps we lack
- **NavigableMap / NavigableSet** ops on the trees: `floor/ceiling/higher/lower/firstKey/lastKey/subMap/
  headMap/tailMap/descending`. We have TreeMap/TreeSet but not the navigation API.
- **EnumMap / EnumSet** ★ — array-backed, super-efficient enum-keyed map/set. Resonates with our enums.
- **Immutable / read-only collections** (Java `List.of`/`Collections.unmodifiable*`, C#
  `ImmutableList`/`IReadOnlyList`): unmodifiable views + truly immutable (structural-sharing) variants.
- **Collection utilities** (Java `Collections`/`Arrays`, C# LINQ helpers): sort/fill/copy/binarySearch/
  reverse/shuffle/frequency/min/max/asList/nCopies/swap/rotate.
- **Comparator toolkit** (Java `Comparator.comparing().thenComparing().reversed()`): full combinator set.
- **Optional/Result rich API**: `map/flatMap/filter/orElse/orElseGet/ifPresent/or` — make ours Java-grade.
- **StringJoiner**, **MessageFormat / templated messages**.

### C3.2 OOP idioms Java/C# ship that we should
- **Events / multicast delegates** ★ (C# `event`/`+=`/`-=`, Java listeners): first-class subscribe/emit;
  the canonical OOP decoupling tool. Pairs with our function types.
- **Standard functional interfaces** (Java `java.util.function`, C# `Func/Action`): named
  `Function/BiFunction/Supplier/Consumer/Predicate` + `andThen/compose/negate`.
- **Observable / bindable properties** ★ (C# `INotifyPropertyChanged`, JavaFX properties): change
  notification — groundwork for reactive UI and data binding. Pairs with our properties (`get`/`set`).
- **AutoCloseable / Disposable + scope pools**: we have `using`/RAII; add resource **pools** and a
  `Disposable` registry.
- **ThreadLocal** — per-thread storage.
- **Builder / fluent-API helpers**, **state machine** scaffolding, **enum-driven dispatch tables**.

### C3.3 Features that RESONATE with LDP3's unique systems  ★ (the real differentiators)
- **Dependency-Injection / service container** ★★ — register interfaces→impls, resolve graphs, scoped
  lifetimes. LDP3 is **OOP-mandatory + has reflection + interfaces** → DI is *native*, not a framework
  bolt-on (Spring/.NET-DI made this the dominant app pattern).
- **Plugin / ServiceLoader registry** ★★★ — discover + load service providers. LDP3 already **is** a
  plugin platform (`.ldb` bundles + dynamic load + `unimport`/`reimport`). A stdlib service-registry on
  top = a hot-swappable plugin system no other language has natively. Crown resonance.
- **Event sourcing / audit log on persistents** ★ — persistents make "append-only state that survives"
  a primitive; an event-sourcing + snapshot helper is uniquely natural here.
- **Schema versioning / data migration for persistents** ★ — persistent data outlives code, so it needs
  evolution; a migration framework (versioned records + upgrade hooks) is a real need our model creates.
- **Region-scoped allocator API** ★ — first-class `Allocator` abstraction (arena/pool/region/heap), with
  region being type-safe (vs Zig/Odin untyped arenas).
- **Memoization / caches bound to persistents** — computed results that survive reload.
- **Hot-reload utilities** — leverage `unimport`/`reimport` for live code update + state carry-over.
- **Validation framework via annotations** ★ — `@NotNull`/`@Range`/`@Pattern` checked through reflection
  (Java Bean Validation / C# DataAnnotations) — we have annotations + reflection + Field get/set.
- **Reflective deep-equals / deep-clone / pretty-print / diff** — over the object graph (we have cascade
  + reflection).

### C3.4 More modern non-scientific domains
- **Generators / lazy sequences** (`yield`-style producers) — pairs with iterators + the async machinery.
- **Async I/O / event loop** (epoll/IOCP-backed) — high-throughput servers, beyond blocking sockets.
- **Audio** (WAV read/write, mixing, synthesis) and **Image** (PNG/JPG decode/encode, basic ops) — games.
- **Resilience**: rate limiter, circuit breaker, retry/backoff, timeout policies.
- **Caching policies**: TTL, LRU/LFU/ARC, write-through/back (ties to the embedded store).
- **Web layer**: HTTP routing + middleware (beyond raw client/server), cookies/sessions, multipart.
- **Feature flags / config hot-reload**, **dependency/topological resolution** (build tools, plugins).
- **Text**: BreakIterator (word/line breaking), collation, transliteration, diff/patch (have diff).

### NOT to port from Java/C# (paradigm/GC patches)
- **WeakReference/SoftReference/PhantomReference + the whole GC-reachability surface** — LDP3 is manual
  memory; non-owning observation is `T*`/refs, lifetime is regions/ownership/persistents.
- **`dynamic`/ExpandoObject** (C#) — LDP3 is statically typed by design.
- **Reflection.Emit / runtime IL generation** — AOT; comptime + DSLs cover compile-time codegen.
- **finalizers (`Object.finalize`)** — we have deterministic destructors/RAII; nondeterministic
  finalizers are a GC artifact.
- **boxing-everywhere collections** (pre-generics Java `Vector`/`Hashtable`) — we have real generics.

---

## D. Residuals to resolve (language, not stdlib) — João wants all fixed

1. **persistents in arrays** — basic case works; reattach by array index is the missing sub-case.
2. **FFI struct-by-value > 8 bytes** — errors cleanly today; needs the Win64 ABI (by-pointer) path.
3. **literal-suffix overload by type** (`seconds(int)` + `seconds(double)` coexisting).
4. **`move` expression forms** with region/persistents in expression position.
5. **`finally` during uncaught propagation** — one residual ordering case.
6. (Out of this scope per roadmap: freestanding bootable-kernel `_start`/linker/QEMU — post-F10.)

---

## E. Plan (João, 2026-06-29): resolve ALL residuals, then implement ABSOLUTELY EVERYTHING above
(both waves), THEN return to the normal flow (toolchain #17 etc.). This is now a large committed
stdlib-buildout phase before the toolchain.

Proposed build order (each item: prelude LDP3 + sample + test, suite green per slice):
1. **Residuals (D)** — small, well-defined; restores "language truly done" confidence.
2. **Foundations: Iterators/functional (A1) + Slices/Spans (A2)** — everything else composes on these.
3. **Strings/format + Regex (A4)** · **I/O: Reader/Writer/paths/process (A5)**.
4. **Collections wave (A3 + C2.2)** — ordered map, slotmap, colony, ring/small-vec/bitset, graphs, spatial,
   tries, caches, union-find, range-query trees.
5. **LDP3 flagships (C + C2.3 + C2.4)** — colony×persistents, region-allocated containers, ECS,
   reflection-serialization, embedded KV store on persistents.
6. **Math/scientific (A9 + C2.1)** ★ — the differentiator: autodiff, calculus, linear algebra, FFT,
   stats, number theory, geometry/quaternions.
7. **Concurrency (A8 + C2.7)** · **Networking HTTP/URL/UDP (A7)** · **crypto/hash/UUID/encoding (A11)**
   · **compression/diff (C2.5)**.
8. **App layer: logging/CLI/testing (A12)** · **time/date (A10)** · **parsing/DSL (C2.6)** ·
   **observability/i18n/reactive (C2.8)**.

Most of this is **writing LDP3 in the prelude** (low compiler risk) plus targeted builtins/runtime
helpers (FFT, regex engine, compression, crypto, HTTP socket glue). After it all lands → toolchain.
