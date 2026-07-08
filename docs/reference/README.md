# LDP3 Language Reference — 1.0.0

Complete reference for **LDP3** (Linguagem De Programação 3): an OOP-mandatory, manually
memory-managed systems language that compiles to native code through LLVM. Created by
João Victor Pereira Tavares.

Everything here is generated from — and cross-checked against — the actual compiler and the
embedded standard-library prelude, not just the spec: where the written spec and the implementation
disagree, these pages document **what the compiler accepts today** and flag the divergence.

For the full language design narrative see [`../LDP3_specification.md`](../LDP3_specification.md)
(the design source of truth); this reference is the practical, implementation-accurate companion.

---

## The language

- **[Language Guide](language-guide.md)** — how the language works, end to end, with ~85 runnable
  examples: program/bundle/namespace structure and the entry point, imports, the full type system
  (primitives, `String`/`string`, `nullable`, arrays, generics, `record`/`struct`/`union`/`enum`/
  `catalog`), value semantics and the memory model (deep-copy assignment, `T*`/`T&`, stack/heap,
  RAII, regions, `move`/`movable`/`unique`, `defer`/`using`, persistents), OOP (inheritance,
  interfaces, `abstract`/`override`/vtables, properties, operator overloading, `sealed`/`permits`),
  control flow (`if`/`while`/`for`/`foreach`/ranges/`switch`/`match`, the `goto`/`comefrom` tetrad),
  exceptions + `Result`/`Option`/`try?` + contracts, lambdas, concurrency (`async`/`await`, `Channel`,
  `Mutex`/`synchronized`, `atomic`, `Thread`), the universal prefixes, the **native compiler builtins**
  (`String`/`string` methods, `Decimal` + the `m` suffix, `Memory`/`address`, SIMD `vec2/3/4` + `mat4`,
  `System.IO.Console`, `$"..."` interpolation), FFI (`extern` + `native_libs`), and freestanding mode.

- **[Keyword Reference](keywords.md)** — every reserved word the compiler recognizes (~123 hard
  keywords + ~16 soft/contextual + the semantic type names), each with what it does, its syntax, a
  short example, and its status (hard / soft-contextual / freestanding-only / reserved-not-yet-
  implemented), grouped into 20 categories with a navigable index. Includes the known
  spec-vs-implementation divergences.

## The standard library

The stdlib is written in LDP3 itself (an embedded prelude) on top of a small set of native builtins.
Every type below requires an **explicit import** (`import System.<Namespace>.<Type>;`). These six pages
document **222 types with ~880 public members**, each as its verbatim signature plus a one-line
description.

| Reference | Namespaces | Contents |
|---|---|---|
| **[Concurrency & core](stdlib/concurrency-and-core.md)** | `System.Concurrency`, `System.Errors`, `System.IO`, `System.Runtime`, `System.Collections` | `Thread`, `Task<T>`, `Channel<T>`, `atomic<T>`, `Mutex<T>`, `Semaphore`, `CountdownLatch`, `Barrier`, `ReadWriteLock`; `Result`/`Ok`/`Err`, `Option`/`Some`/`None`; `Console`, `Files`, `Paths`, `Logger`, `Args`; `Object`, the exception hierarchy; `Iterator`/`Iterable`. |
| **[Collections](stdlib/collections.md)** | `System.Collections` | `ArrayList<T>` (with `forEach`/`filter`/`map`/`reduce`/`any`/`all`/`find`/`min`/`max`/`sortedBy`), lazy streams, `Slice<T>`, `Stack`/`Queue`/`Deque`/`LinkedList`, `Hashable`/`Comparable`, `HashMap`/`HashSet`, `TreeMap`/`TreeSet` (AVL), `PriorityQueue`, `Bitset`, `Multiset`, `RingBuffer`, `LinkedHashMap`. |
| **[Data structures & ECS](stdlib/data-structures.md)** | `System.Collections`, `System.Ecs`, `System.Events` | `Range`, `Trie`, `Graph`/`DiGraph`/`WeightedGraph`, `UnionFind`, `Bst`, `Fenwick`/`Fenwick2D`, `SegmentTree`, `SparseTable`, `LruCache`, `BiMap`/`MultiMap`, `SpatialGrid`, `SlotMap`, `EnumMap`/`EnumSet`, algorithm helpers (`Knapsack`, `Lcs`, `QuickSelect`, `Kadane`, interval tools), a small ECS (`World`/`ComponentStore`) and a `Signal`/event system. |
| **[Text, encoding & crypto](stdlib/text-encoding-crypto.md)** | `System.Text` | `StringBuilder`, `Strings`, `Regex`, `Utf8`, `Scanner`; `Hex`/`Radix`/`Base64`/`Base32`/`Base58`/`Ascii85`; `Sha256`/`Sha1`/`Sha224`/`Md5`/`Hmac`/`Crc`/`Adler32`/`Fletcher`/`Digest`; `BloomFilter`, `Huffman`, `Lz77`, `Rle`; string algorithms (`Kmp`, `Manacher`, `Soundex`); `Calculator`. |
| **[Parsing, time & JSON](stdlib/parsing-time-json.md)** | `System.Text`, `System.Time`, `System.Json` | `Rpn`/`ShuntingYard`, `Template`, `Csv`/`CsvReader`/`CsvWriter`, `Ini`, `Properties`, `Glob`, `Uuid`, `Semver`, `StateMachine`, `Colors`, `Caesar`/`Vigenere`, text utils (`Slugify`, `Inflector`, `Levenshtein`, `JaroWinkler`, `Luhn`, `Isbn`, `Humanize`, `NumberWords`, `Validators`); `Duration`/`Instant`/`ZonedDateTime`/`Date`/`Calendar`/`Stopwatch`; `Json`/`JsonPointer`/`JsonParser`. |
| **[Math, net & misc](stdlib/math-net-misc.md)** | `System.Math`, `System.OS`, `System.Security`, `System.Net`, `System.App`, `System.Test` | `BigInteger`, `Rational`, `Complex`, `Matrix`/`MatrixD`, `Vector2/3/4`, `Quaternion`, `Mat4`, `Fft`, `Polynomial`, `Stats`/`Regression`/`Correlation`, number theory (`Sieve`, `NumberTheory`, `Crt`, `Combinatorics`), geometry (`ConvexHull`, `Polygon`), sketches (`CountMinSketch`, `HyperLogLog`); `SecureRandom`/`Aes`; `Socket`/`ServerSocket`/`UdpSocket`/`Http`; `CircuitBreaker`, `TokenBucket`, `ObjectPool`, `Money`; `Assert`/`TestRunner`. |

## Hello, LDP3

```ldp3
import System.IO.Console;

program Hello;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello, LDP3 1.0.0");
            }
        }
    }
}
```

Build it:

```
ldp3 build          # in a project dir (ldp3.toml), or:
ldp3c hello.ldp3 -o hello.ll && clang hello.ll ldp3_rt.lib -o hello.exe
```
