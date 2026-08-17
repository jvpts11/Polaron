<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="72" height="72" align="left" role="img" aria-label="The Polaron mark">
  <g fill="#5a80ec">
    <circle cx="23.1" cy="23.1" r="3.1"/><circle cx="40.9" cy="23.1" r="3.1"/>
    <circle cx="23.1" cy="40.9" r="3.1"/><circle cx="40.9" cy="40.9" r="3.1"/>
    <circle cx="32" cy="11" r="2.3"/><circle cx="32" cy="53" r="2.3"/>
    <circle cx="11" cy="32" r="2.3"/><circle cx="53" cy="32" r="2.3"/>
  </g>
  <circle cx="32" cy="32" r="7" fill="#395fdb"/>
</svg>

# The Polaron Language Reference

A complete, book-length reference for **Polaron**: an object-orientation–mandatory, manually
memory-managed systems language that compiles to native code through LLVM. Created by João Victor
Pereira Tavares.

This reference is written to *teach*, not just to enumerate. Every feature is explained in terms of what
it does, why it exists, how it fits Polaron's philosophy, and how it interacts with the rest of the
language — each illustrated with short, runnable examples. It is the canonical description of the
language, cross-checked against the actual compiler and the embedded standard-library prelude, so these
pages describe **what the compiler accepts today**.

Three of those checks are mechanical, and they run in the suite: every keyword the lexer reserves
appears in [§12](guide/12-keyword-reference.md), every diagnostic code the compiler can emit appears
in [§13](guide/13-diagnostics.md), and **every public type in the standard library is mentioned
somewhere in these pages**. A feature added without a word about it here fails a test.

That third check was added after measuring the obvious: 109 of 338 public library types appeared on
no page at all, and nobody had noticed — because a manual's absences are invisible. Nobody reads
documentation looking for what is not in it.

A single typeset PDF of everything below is produced by `python make-pdf.py`, which prints
`_reference.html` with a headless browser (the exact command is in that script's header). Its version
stamp is one of the six places the toolchain's version lives, and `version_sites` in the suite requires
all six to agree — the stamp sat thirty versions behind the compiler until that check existed.

---

## Part I — The Language

| # | Chapter | What it covers |
|---|---------|----------------|
| 1 | [Introduction & Philosophy](guide/01-introduction.md) | What Polaron is, its design pillars (OOP-mandatory, no GC, value semantics, no exploitable UB), and a first taste. |
| 2 | [Program Structure & Modules](guide/02-program-structure.md) | `program`/`bundle`/`namespace`, the entry point, visibility, imports, multi-file programs. |
| 3 | [Expressions, Statements & Method Calls](guide/03-expressions-statements.md) | The everyday mechanics: variables and assignment, the operator set, expressions, statement kinds, and calling methods (instance, `this`, static, chained). |
| 4 | [Values & the Type System](guide/04-type-system.md) | Primitives and their names, literals, `String`/`string`, `nullable`, arrays, generics + variance, `record`/`struct`/`union`/`enum`/`catalog`, casting. |
| 5 | [Memory & Ownership](guide/05-memory-and-ownership.md) | Value semantics and deep copy, `T*`/`T&`, stack/heap, RAII, regions, `move`/`movable`/`unique`/`partitionable`, `defer`/`using`, persistents. |
| 6 | [Object-Oriented Programming](guide/06-oop.md) | Classes, inheritance, interfaces, `abstract`/`override`/vtables, properties, operators, enums, `sealed`/`permits`. |
| 7 | [Control Flow](guide/07-control-flow.md) | `if`/`while`/`for`/`foreach`/ranges, `switch`, `match`, labelled `break`/`continue`, and the chaos tetrad. |
| 8 | [Errors, Results & Contracts](guide/08-errors-and-contracts.md) | Exceptions, `Result`/`Option`/`try?`, `requires`/`ensures`/`invariant`, and the no-UB principle. |
| 9 | [Concurrency](guide/09-concurrency.md) | `async`/`await` + `Task`, `Thread`, `Mutex`/`synchronized`, `atomic`, `Channel`/`select`. |
| 10 | [Compile-Time, Reflection & Universal Prefixes](guide/10-metaprogramming-and-prefixes.md) | `comptime`, `demand`, reflection, annotations, lifecycle hooks, and `cascade`/`eternal`/`lazy`/`comptime`/`volatile`/`final`. |
| 11 | [Systems Programming](guide/11-systems-programming.md) | Compiler builtins (`String`, `Decimal`, `Memory`/`address`, SIMD, `Console`), FFI (`extern` + `native_libs`), and freestanding mode. |
| 12 | [Keyword Reference](guide/12-keyword-reference.md) | Every reserved word, grouped by role, with its meaning, syntax, an example, and its exact status. |
| 14 | [Functions, Lambdas & Tuples](guide/14-functions-and-lambdas.md) | First-class functions, the `function<>` type, lambdas + `byvalue`/`byref` captures, `methodref`, `funcptr<>` for FFI, tuple returns, and named arguments. |
| 17 | [How the Pieces Fit Together](guide/17-how-the-pieces-fit.md) | The seams: value semantics × containers × destructors, ownership read from destructors, `weak` and the region binder, delegate vs transformer, sealed + `match` + `Result`, generics across bundles, reflection in freestanding, regions and `accepts`. |
| 18 | [Building Real Things](guide/18-building-real-things.md) | Five shapes, end to end — a CLI tool, a library others `plug`, a simulation with a window, a network service, and bare metal — with the decisions each one turns on. |
| 19 | [Final Considerations](guide/19-final-considerations.md) | What the language is for, what it refuses and why, what it costs you, what is finished and what is not, and how to read this book coming from C++, Rust, Java or C#. |
| 20 | [The Mark, the Colour and the Icon](guide/20-identity.md) | The visual identity: the lattice, the palette, the wordmark, the file icon, and why the assets are generated rather than drawn. |

## Part II — The Standard Library

The standard library is written in Polaron itself (an embedded prelude) on top of a small set of native
compiler builtins. Every type requires an explicit `import`. These pages document the full library as
verbatim member signatures with explanatory prose.

- [Concurrency & Core](stdlib/concurrency-and-core.md) — `Thread`, `Task`, `Channel`, `atomic`, `Mutex`, synchronization primitives; `Result`/`Option`; `Console`, `Files`, `Logger`; the exception hierarchy; `Iterator`/`Iterable`.
- [Collections](stdlib/collections.md) — `ArrayList` (with the functional pipeline), `Slice`, stacks/queues/deques, `HashMap`/`HashSet`, `TreeMap`/`TreeSet`, `PriorityQueue`, `Bitset`, and more.
- [Data Structures & ECS](stdlib/data-structures.md) — `Trie`, graphs, `UnionFind`, Fenwick/segment trees, `LruCache`, spatial grids, a small ECS, and an event system.
- [Text, Encoding & Crypto](stdlib/text-encoding-crypto.md) — `StringBuilder`, `Strings`, `Regex`, `Utf8`, `Scanner`; hex/Base64/Base32/…; SHA/MD5/HMAC/CRC; compression and string algorithms.
- [Parsing, Time & JSON](stdlib/parsing-time-json.md) — expression parsers, `Csv`/`Ini`/`Properties`, `Uuid`, `Semver`, text utilities; `Duration`/`Instant`/`Date`/`Calendar`; `Json`.
- [Math, Net & Misc](stdlib/math-net-misc.md) — `BigInteger`, `Rational`, `Complex`, matrices, vectors, `Fft`, statistics, number theory, geometry; resilience utilities (`Retry`, `CircuitBreaker`, `TokenBucket`); `Style`/`TextTable`; a test runner.
- [Networking and TLS](stdlib/net-and-tls.md) — sockets, `Url`, the HTTP client and the server-side router; and **TLS 1.3 written in Polaron itself**: the handshake, the key schedule, X.509 parsing and chain validation, talking to real servers.
- [The System](stdlib/system-and-processes.md) — `Machine`, `Environment`, `Workspace`, `Disk`, `Exit`, `Signals`; the whole `Files` surface plus `FileStream`/`LineReader`/`TempFile`/`DirectoryWatcher`; `Process`/`Command`/`Subprocess`/`Pty`; and cross-program IPC.
- [What Reflection Gives You Free](stdlib/reflection-driven.md) — `Serializer`, `Validator` (rules as annotations on the field), `Services` (injection), `Compare`, `Arena`, and the persisted `Memo`/`EventLog`.
- [Science and Units](stdlib/science-and-units.md) — root finding, calculus, ODEs, distributions, hypothesis tests, optimisation; and the unit suffixes (`30 seconds`, `4 kilometres`) that produce a **type** rather than an int.

## Part III — Tooling & Ecosystem

| # | Chapter | What it covers |
|---|---------|----------------|
| 13 | [Diagnostics](guide/13-diagnostics.md) | The `Polaron-NNNN` code system, the rich why/fix/prevent format, `polaron explain`, the code ranges, and editor integration. |
| 15 | [The Toolchain & Projects](guide/15-toolchain.md) | The `polaron` driver and its commands, project layout, the `polaron.toml` manifest, dependencies, and environments. |
| 16 | [Testing](guide/16-testing.md) | `[Test]`, the assertion set, `[Setup]`/`[BeforeAll]` fixtures, `[Ignore]`, `assertNoLeaks`, testing the whole program, and running the suite. |

---

## Hello, Polaron

```polaron
import System.IO.Console;

program Hello;

public bundle Main {
    public namespace App {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello, Polaron");
            }
        }
    }
}
```

```
polaron new hello && cd hello && polaron run     # the scaffold, built and run
polaron build                                    # inside any project (polaron.toml)
polc hello.pol -o hello.ll && clang hello.ll polaron_rt.lib -o hello.exe    # or by hand
```

---

## Where to go next

| If you want to | Read |
|---|---|
| Understand the language's shape in ten minutes | [§1 Introduction](guide/01-introduction.md), then the `examples/` directory — twenty-two programs, each compiled and run by the test suite |
| Write your first real program | [§18 Building Real Things](guide/18-building-real-things.md) |
| Know why the compiler refused something | The message itself, then `polaron explain <code>`, then [§13](guide/13-diagnostics.md) |
| Find out how two features behave together | [§17 How the Pieces Fit Together](guide/17-how-the-pieces-fit.md) |
| Decide whether to use it at all | [§19 Final Considerations](guide/19-final-considerations.md) |
| Make something that matches the brand | [§20 The Mark, the Colour and the Icon](guide/20-identity.md) |
