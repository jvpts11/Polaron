# Restructuring the Polaron standard library

*Specification, 2026-08-13. The library is to be **as complete as possible** — the ambition stated is
"C# plus Java, and more complete still". This document is about what has to be true for that to be
possible, which is mostly not about which types to write.*

## The number, first

`java.*` is roughly 4 500 public classes; the .NET BCL is comparable. The stated ambition is
therefore **thousands of types**. Today the prelude has **240**, in 20 flat namespaces, in one file
of 9 675 lines.

That is a 10–20× expansion, and it is years of work by many hands. So the useful content of a
specification is not a list of types — any list written today is obsolete by the time a tenth of it
exists. What survives is the **structure, the placement rules, and the mechanism**. Those are what
this document fixes; the types accrete inside them.

## What is measured today, so the goals are not guesses

| | measured |
|---|---|
| Prelude size | 9 675 lines, 240 types, 20 namespaces |
| Front-end time for a *hello world* | **195 ms** — the whole prelude, lexed, parsed and analyzed, every compile |
| IR emitted for that same hello world | **63 lines** — dead-stripping already removes essentially all of it |
| Binary vs the C equivalent | 232 KB vs 147 KB, and the difference is `polaron_rt.cpp`, not the library |

Read those two middle rows together, because they decide the whole design:

- **Binary size is already solved.** A 9 675-line library becomes 63 lines of IR. Nothing needs to be
  done about what *reaches the program*.
- **Compile time is not, and it is the thing that scales with ambition.** 195 ms today buys 240
  types. At the stated ambition it buys nothing — a library ten times larger, embedded as source, is
  seconds on every compile of every program, forever.

**So the mechanism below is not an optimization. It is the precondition for the ambition.**

## Mechanism: one precompiled bundle per subject

Polaron already has separate compilation and it is already tested: `polc --lib` compiles a library to
a `.polb` (code + a `.polh` of public declarations); a consumer passes `--use` and links only what it
calls. The standard library is the one library in the system that does **not** use it — it is
embedded as source text and recompiled from scratch by every program that has ever been written.

The change: **each subject becomes its own `.polb`, built once, shipped with the toolchain.** An
`import System.Math.Numerics` type-checks against that bundle's `.polh` and links its code. A program
that imports nothing from `System.Net` pays nothing for `System.Net` — not link time, and, decisively,
not parse time.

Two consequences to design for, not discover:

- **A bundle is the unit of versioning and ABI.** `.polb` already carries a fingerprint and refuses a
  mismatch. Splitting the library into ~20 bundles means ~20 fingerprints; the build must keep them
  consistent, and the test suite must cover a stale one.
- **Cross-subject dependencies become real edges.** Today everything can see everything because it is
  one file. `System.Net` using `System.Text` becomes a declared dependency. That is a feature — it
  makes the library's own coupling visible for the first time — but the dependency graph has to be
  acyclic, and today nobody has checked that it is.

## Structure: `System` as the base, namespaces nesting by subject

One bundle per subject; namespaces nest inside it to whatever depth the subject needs. The types —
classes, interfaces, structs, records, enums, unions, catalogs, layouts, transformers — live at the
leaves.

The tree is not enumerated here beyond its top level, deliberately: at the target scale the top level
is the contract, and the interior is where growth happens.

```
System
  Runtime      Object, exceptions, reflection, the type system
  Memory       Buffer, ByteSize, allocators, spans/slices
  Collections  the containers, split from the algorithms
  Algorithms   graph, DP, selection, search -- today wrongly inside Collections
  Text         strings, formatting, regex, parsing -- text and ONLY text
  Codecs       base64/32/58, hex, UTF, CSV/INI/JSON/XML, compression
  Security     digests, HMAC, ciphers, keys, signatures, random
  Math         arithmetic, numerics, linear algebra, statistics, geometry
  Time         instants, civil dates, zones, formatting
  IO           streams, files, paths, directories, watching
  Net          addresses, sockets, HTTP, TLS, DNS
  Concurrency  threads, tasks, executors, synchronization, channels
  Ipc          the cross-program surface that exists today
  OS           processes, signals, environment, terminals
  Diagnostics  logging, tracing, metrics, assertions
  Globalization locales, encodings, culture-aware formatting
  App          the application-level pieces that exist today
  Test         the test framework
```

### The placement rule

Because the library will be written by many hands over years, the rule matters more than any single
decision. **A type belongs to the subject that names what it IS, not what it is made of.**

`Sha256` is not text because it happens to consume bytes; it is a digest, so it is `System.Security`.
`Lz77` is not text; it is compression, so it is `System.Codecs`. `Knapsack` is not a collection
because it uses arrays; it is an algorithm. Applied to today's library this rule alone moves roughly
a third of `Text` and a third of `Collections`.

## What today's structure gets wrong, from the survey

- **`OS` and `Os` both exist**, differing only in case: `ProcessResult`/`Subprocess`/`Pty` in one,
  `Signals` in the other. This is a defect, not a preference.
- **`Text` holds 63 types and about half are not text**: `Sha256`, `Sha1`, `Md5`, `Hmac`, `Crc`,
  `Adler32`, `Fletcher`, `Huffman`, `Lz77`, `Caesar`, `Vigenere`, `Base64`/`32`/`58`, `Ascii85`,
  `Hex`, `Csv*`, `Ini`, `Properties`, `Uuid`, `Luhn`, `Isbn`. Meanwhile `Security` holds **two**.
- **`Collections` holds 59 and mixes three levels**: containers (`ArrayList`, `HashMap`), algorithmic
  structures (`Fenwick`, `SegmentTree`, `UnionFind`), and plain algorithms that are not collections at
  all (`Kadane`, `Lcs`, `Knapsack`, `QuickSelect`, `SlidingWindowMax`).
- **`Time` is built on the shapes `java.time` exists to replace.** It has `Date` and `Calendar`
  alongside `Instant` and `ZonedDateTime`, and lacks the civil types (`LocalDate`, `LocalTime`,
  `LocalDateTime`, `Period`, `DayOfWeek`, `Month`) and any formatting or parsing.
- **`IO` has five types** (`Console`, `Files`, `Paths`, `Logger`, `Args`) and **`Net` has six**. These
  are the two furthest from the ambition, and `Logger` is diagnostics, not IO.

## Gaps, ordered by how far they are from the ambition

1. **IO** — streams and readers/writers with buffering, memory-mapped files, directory walking and
   watching, temporary files, metadata and permissions, charsets beyond UTF-8, file compression.
2. **Time** — the civil types and a formatter/parser; retire `Date`/`Calendar`.
3. **Net** — `Url`/`Uri` as types, an HTTP client that follows redirects and keeps cookies, TLS, DNS,
   an HTTP server.
4. **Security** — signatures, key pairs, X.509, plus the digests moved in from `Text`.
5. **Concurrency** — the primitives are all there and nothing *schedules*: executors, thread pools,
   cancellation, parallel loops.
6. **Globalization** — absent entirely, and it is the difference between formatting a number and
   formatting it for a reader.
7. **Diagnostics** — logging exists as one class inside IO; tracing and metrics do not exist.
8. **Serialization** — JSON parses and prints; there is no object mapping, and no XML at all.

## Rewriting with the language's own features, as the files are touched

A separate audit (`stdlib-feature-audit` in the working memory) found the library is written in a
conservative OOP subset. The headline: **zero uses of `region` against 222 `on heap` allocations**,
zero `weak`, and `ensures`/`invariant` never used while `requires` is used 29 times.

Since every file is going to be moved anyway, the rewrite happens then — not as a separate pass:

- **`ensures` and `invariant` first.** Cheapest, changes no behaviour, and it puts the compiler to
  work checking the library. A library's postconditions are exactly what its callers cannot verify.
- **Regions where ownership is clear** — `StringBuilder`, `ArrayList`, `HashMap`. This is where the
  performance win and the teaching win coincide: `regions` beats malloc/free by 12× in the benchmark
  suite, and the library that every program reads currently demonstrates the opposite.
  **Known blocker:** a region allocates *typed* objects and arrays, while `StringBuilder`'s buffer is
  a raw `address` used with `Allocator.copy`/`Raw.writeString`. `Raw.addressOf`, which would bridge
  this, is named in an analyzer comment but **does not exist**. Either implement it, or the buffer
  becomes a `byte[]` in the region.
- **`weak`** where the library holds a back-reference: iterators onto their collection, `MapStream`
  onto its source.

## What must not happen

- **No big-bang rewrite.** The only safety net is 714 tests, and this session demonstrated three times
  over that the suite passes through changes that make things 2.5× slower. One subject at a time,
  green at each step.
- **No move without a test.** A reorganization of this size moves code nobody verifies. Any subject
  that moves and has no test gets one first, or it does not move.
- **No performance regression on the benchmark suite.** `bench-all.ps1` runs after each subject.
  The unit tests do not protect performance; only that does.
- **No cyclic bundle dependency.** It is checkable and cheap to check; it is expensive to discover.

## Staging

The order below is chosen so each step is independently valuable and independently reversible.

1. **Fix `OS`/`Os`.** A defect, and it costs nothing.
2. **Split the prelude into per-subject source files** — still one bundle, still compiled as one.
   Pure file movement, and everything stays green. This is the step that makes every later step
   small.
3. **Apply the placement rule** to `Text` and `Collections`, creating `Codecs` and `Algorithms` and
   filling out `Security`. Still one bundle.
4. **Precompile one subject** — `System.Math` is the best candidate: large, self-contained, and it
   depends on almost nothing. Prove the `.polb` path end to end and measure the front-end time drop.
5. **Precompile the rest**, subject by subject, watching the dependency graph.
6. **Fill the gaps**, in the order listed above.

Steps 1–3 are organization and carry little risk. Step 4 is the one that decides whether the ambition
is affordable, and it should be done early enough to learn from — before there are 3 000 types to
move rather than 240.
