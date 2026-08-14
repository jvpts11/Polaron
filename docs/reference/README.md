# The Polaron Language Reference — 1.0.18

A complete, book-length reference for **Polaron** (Linguagem De Programação 3): an
object-orientation–mandatory, manually memory-managed systems language that compiles to native
code through LLVM. Created by João Victor Pereira Tavares.

This reference is written to *teach*, not just to enumerate. Every feature is explained in terms of
what it does, why it exists, how it fits Polaron's philosophy, and how it interacts with the rest of the
language — each illustrated with short, runnable examples. It is the canonical description of the
language, cross-checked against the actual compiler and the embedded standard-library prelude, so
these pages describe **what the compiler accepts today**.

A single typeset PDF of everything below:
**[Polaron-Language-Reference-1.0.16.pdf](Polaron-Language-Reference-1.0.16.pdf)**.
Regenerate it with `python make-pdf.py`, then print `_reference.html` to PDF with a headless browser
(the exact command is in that script's header). The version stamp lives in `make-pdf.py`, and it is
**behind the compiler** — the pages describe what the compiler accepts today, but the stamp says
1.0.16 while `polc` reports 1.0.37.

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

## Part II — The Standard Library

The standard library is written in Polaron itself (an embedded prelude) on top of a small set of native
compiler builtins. Every type requires an explicit `import`. These pages document the full library as
verbatim member signatures with explanatory prose.

- [Concurrency & Core](stdlib/concurrency-and-core.md) — `Thread`, `Task`, `Channel`, `atomic`, `Mutex`, synchronization primitives; `Result`/`Option`; `Console`, `Files`, `Logger`; the exception hierarchy; `Iterator`/`Iterable`.
- [Collections](stdlib/collections.md) — `ArrayList` (with the functional pipeline), `Slice`, stacks/queues/deques, `HashMap`/`HashSet`, `TreeMap`/`TreeSet`, `PriorityQueue`, `Bitset`, and more.
- [Data Structures & ECS](stdlib/data-structures.md) — `Trie`, graphs, `UnionFind`, Fenwick/segment trees, `LruCache`, spatial grids, a small ECS, and an event system.
- [Text, Encoding & Crypto](stdlib/text-encoding-crypto.md) — `StringBuilder`, `Strings`, `Regex`, `Utf8`, `Scanner`; hex/Base64/Base32/…; SHA/MD5/HMAC/CRC; compression and string algorithms.
- [Parsing, Time & JSON](stdlib/parsing-time-json.md) — expression parsers, `Csv`/`Ini`/`Properties`, `Uuid`, `Semver`, text utilities; `Duration`/`Instant`/`Date`/`Calendar`; `Json`.
- [Math, Net & Misc](stdlib/math-net-misc.md) — `BigInteger`, `Rational`, `Complex`, matrices, vectors, `Fft`, statistics, number theory, geometry; `Socket`/`Http`; resilience utilities; a test runner.

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

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello, Polaron");
            }
        }
    }
}
```

```
polaron build          # inside a project (polaron.toml), or, by hand:
polc hello.pol -o hello.ll && clang hello.ll polaron_rt.lib -o hello.exe
```
