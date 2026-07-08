# LDP3 Standard Library — Concurrency & Core

This reference covers the concurrency primitives, `Result`/`Option` sum types, console/file/logging
helpers, the PRNG, the root `Object`, the runtime exception hierarchy, and the iteration interfaces.
All of these live in the LDP3-source prelude embedded in `src/cli/main.cpp` (the `kPreludeSource`
raw string literal). Every type below is compiled from that prelude just like user code, so the
signatures shown are the exact declarations in the source.

Notes that apply throughout:

- Namespace visibility is enforced. To use a type you must `import` it (the exact import line is
  given per type). `System.*` is not exempt.
- Some types are thin LDP3 shells over compiler builtins. For example, `Channel<T>.send`/`receive`
  and the `atomic<T>` operations are lowered by the compiler and do not appear as method
  declarations in the prelude; they are noted in prose but have no verbatim signature to quote.
- LDP3 is imutable-by-default; a field only carries `mutable` where it is reassigned.

---

## `Thread`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.Thread;`

An OS thread (spec 20.1). Holds a `function<void>` and its OS handle; `start()`/`join()` call the
low-level thread builtins, which lower to `CreateThread` / `WaitForSingleObject`.

Public members:

- `public constructor Thread(function<void> w)` — creates a thread bound to the work closure `w`; the handle starts at 0 (not yet started).
- `public method start() returns void` — spawns the OS thread running the closure (via `System.Concurrency.__threadStart`) and stores its handle.
- `public method join() returns void` — blocks until the thread finishes (via `System.Concurrency.__threadJoin`).

---

## `Task<T>`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.Task;`

The handle to an async computation that will produce a `T` (spec 20.2). An `async` method returns
one of these and `await` yields the `T`. The public field `h` is the runtime `ldp3_task*`.

Public members:

- `public mutable long h;` — the raw runtime task pointer, stored as a 64-bit slot.
- `public constructor Task()` — creates an empty task handle (`h` = 0); the runtime fills it in when an async method is invoked.

---

## `Channel<T>`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.Channel;`

A bounded blocking channel (spec 20.3): `send()` blocks while full, `receive()` blocks while empty.
The element `T` is passed as a 64-bit slot (an int or a reference).

Public members:

- `public mutable long h;` — the runtime channel handle.
- `public constructor Channel(int capacity)` — allocates a channel with the given buffer capacity (via `System.Concurrency.__chanNew`).
- `send(T)` / `receive()` — recognized by the compiler as channel builtins (used e.g. inside `Semaphore`); they block as described above but have no prelude method declaration.

---

## `atomic<T>`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.atomic;`

A lock-free atomic cell (spec 20.6). `T` is an integer type.

Public members:

- `public mutable T value;` — the cell's current value.
- `public constructor atomic(T initial)` — initializes the cell to `initial`.
- `get` / `set` / `add` / `increment` / `compareAndSet` (and the atomic `++` / `+=` operators) — recognized by the compiler and lowered to LLVM atomic instructions; no prelude method declaration. `add` returns the post-add value (used by `CountdownLatch`/`Barrier`).

---

## `Mutex<T>`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.Mutex;`

A mutual-exclusion lock guarding a value of type `T` (spec 20.5). The value is reached only through
`synchronized (m) using T& x { ... }`, which holds the lock for the block.

Public members:

- `public mutable T value;` — the guarded value.
- `public mutable long lock;` — the underlying OS lock handle.
- `public constructor Mutex(T initial)` — stores `initial` and creates the lock (via `System.Concurrency.__lockCreate`).

---

## `Semaphore`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.Semaphore;`

A counting semaphore (spec 20): `n` permits over a bounded channel. The channel's blocking
send/receive do the waiting. (Named `signal` rather than `release` because `release` is reserved.)

Public members:

- `public constructor Semaphore(int n)` — creates the semaphore with `n` permits (fills a capacity-`n` channel with `n` tokens).
- `public method acquire() returns void` — takes one permit, blocking while none are free (receives a token).
- `public method signal() returns void` — returns one permit (sends a token).

---

## `CountdownLatch`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.CountdownLatch;`

A one-shot latch (spec 20): threads `waitFor()` until `n` `countDown()` calls have happened. Once the
count reaches zero a token is placed in the gate and every waiter passes (take-then-return).

Public members:

- `public constructor CountdownLatch(int n)` — starts the count at `n`; if `n <= 0` the gate is opened immediately.
- `public method countDown() returns void` — atomically decrements the count; opens the gate when it hits zero.
- `public method waitFor() returns void` — blocks until the gate opens, then re-posts the token so other waiters also pass. (Named `waitFor` because `await` is a keyword.)
- `public method getCount() returns int` — returns the current count.

---

## `Barrier`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.Barrier;`

A cyclic-style barrier (spec 20): `n` threads `arrive()` until all have arrived, then all proceed.
The n-th arrival releases `n` tokens; each thread (including it) takes one. Single use.

Public members:

- `public constructor Barrier(int n)` — sets the party count to `n`, with an empty arrival counter and a capacity-`n` gate.
- `public method arrive() returns void` — records arrival; the final arrival posts `n` tokens, and each thread blocks until it can take one.

---

## `ReadWriteLock`

- **Namespace:** `System.Concurrency`
- **Import:** `import System.Concurrency.ReadWriteLock;`

A reader/writer lock (spec 20), reader-preference: any number of readers, or one writer. Built from
two semaphores plus a reader counter (the first reader takes the write lock, the last frees it).

Public members:

- `public constructor ReadWriteLock()` — creates the reader mutex, the write semaphore, and the reader counter.
- `public method readLock() returns void` — acquires a read lock; the first concurrent reader also takes the write semaphore.
- `public method readUnlock() returns void` — releases a read lock; the last reader releases the write semaphore.
- `public method writeLock() returns void` — acquires the exclusive write lock.
- `public method writeUnlock() returns void` — releases the exclusive write lock.

---

## `Result<T, E>` (sealed abstract, permits `Ok`, `Err`)

- **Namespace:** `System.Errors`
- **Import:** `import System.Errors.Result;`

The `Result<T,E>` sum type (spec 21.2): a sealed abstract base matched with `match`. The abstract
method forces a vtable so `match` can dispatch on the variant.

Public members:

- `public abstract method isOk() returns boolean` — abstract; each variant reports whether it is the success case.

---

## `Ok<T, E>` (extends `Result<T, E>`)

- **Namespace:** `System.Errors`
- **Import:** `import System.Errors.Ok;`

The success variant of `Result<T,E>` (spec 21.2), constructed with the type args taken from the
expected type at the use site (via the `Ok(x)` sugar).

Public members:

- `public final T value;` — the success payload.
- `public constructor Ok(T value)` — wraps a success value.
- `public override method isOk() returns boolean` — returns `true`.

---

## `Err<T, E>` (extends `Result<T, E>`)

- **Namespace:** `System.Errors`
- **Import:** `import System.Errors.Err;`

The error variant of `Result<T,E>` (spec 21.2), constructed via the `Err(e)` sugar.

Public members:

- `public final E error;` — the error payload.
- `public constructor Err(E error)` — wraps an error value.
- `public override method isOk() returns boolean` — returns `false`.

---

## `Option<T>` (sealed abstract, permits `Some`, `None`)

- **Namespace:** `System.Errors`
- **Import:** `import System.Errors.Option;`

The `Option<T>` sum type (spec 21.3): a sealed abstract base matched with `match`, with an abstract
method to force a vtable for dispatch.

Public members:

- `public abstract method isSome() returns boolean` — abstract; each variant reports whether a value is present.

---

## `Some<T>` (extends `Option<T>`)

- **Namespace:** `System.Errors`
- **Import:** `import System.Errors.Some;`

The present variant of `Option<T>` (spec 21.3), constructed via the `Some(x)` sugar.

Public members:

- `public final T value;` — the contained value.
- `public constructor Some(T value)` — wraps a present value.
- `public override method isSome() returns boolean` — returns `true`.

---

## `None<T>` (extends `Option<T>`)

- **Namespace:** `System.Errors`
- **Import:** `import System.Errors.None;`

The absent variant of `Option<T>` (spec 21.3), constructed via the `None` sugar.

Public members:

- `public constructor None()` — the empty option.
- `public override method isSome() returns boolean` — returns `false`.

---

## `Console`

- **Namespace:** `System.IO`
- **Import:** `import System.IO.Console;`

Console I/O (spec 2.9 / 4). The methods are recognized by the compiler and lower to libc
`printf`/`scanf`; the class exists only so `import System.IO.Console;` resolves and the usual
namespace-visibility rules require importing it before use.

Public members:

- (none declared in the prelude) — `printf`, `println`, `print`, and `read` are compiler builtins with no LDP3 method declaration.

---

## `Files`

- **Namespace:** `System.IO`
- **Import:** `import System.IO.Files;`

Line-oriented file helpers (spec 34.4). Layers newline handling on top of the `File` builtin so a
program reads a file into a list of lines and writes a list back without joining newlines itself.

Public members (all static):

- `public static method readLines(String path) returns ArrayList<String>` — reads the whole file and splits on `\n`, dropping the trailing empty piece from a final newline.
- `public static method writeLines(String path, ArrayList<String> lines) returns void` — writes each line followed by `\n`, building the output with a `StringBuilder` (avoids O(n²) concat).
- `public static method appendLine(String path, String line) returns void` — appends `line` plus a newline to the file.
- `public static method listDir(String path) returns ArrayList<String>` — returns the directory entries, one per element (empty if not a directory); wraps the newline-separated `File.list`.

---

## `Paths`

- **Namespace:** `System.IO`
- **Import:** `import System.IO.Paths;`

Path-string manipulation (spec 34.4): join segments and pull a path apart. Pure string work over
`"/"`; it does not touch the filesystem.

Public members (all static):

- `public static method join(String base, String name) returns String` — joins `base` and `name` with a single `/` (handles empty base and a trailing slash).
- `public static method basename(String path) returns String` — returns the final `/`-separated component.
- `public static method dirname(String path) returns String` — returns everything before the final component (empty if there is no directory part).
- `public static method extension(String path) returns String` — returns the text after the last `.` in the basename (empty if none).

---

## `Logger`

- **Namespace:** `System.IO`
- **Import:** `import System.IO.Logger;`

Leveled logging to the console (spec 34): each message carries a level (debug/info/warn/error) and
is printed with the logger's name only when its level is at or above the configured minimum, which
starts at info. Levels are numbered debug=0, info=1, warn=2, error=3.

Public members:

- `public constructor Logger(String name)` — creates a named logger with the minimum level set to info (1).
- `public method setLevel(int level) returns void` — sets the minimum level to print.
- `public method debug(String message) returns void` — logs at DEBUG (printed only if min level ≤ 0).
- `public method info(String message) returns void` — logs at INFO (printed only if min level ≤ 1).
- `public method warn(String message) returns void` — logs at WARN (printed only if min level ≤ 2).
- `public method error(String message) returns void` — logs at ERROR (printed only if min level ≤ 3).

(The private `emit` method does the actual `Console.printf` formatting and is not part of the public API.)

---

## `Args`

- **Namespace:** `System.IO`
- **Import:** `import System.IO.Args;`

Reads a program's command-line arguments (spec 34). Wraps the `String[]` handed to `main` so a
program parses its options without scanning the array by hand.

Public members:

- `public constructor Args(String[] argv)` — wraps the argument array.
- `public method has(String flag) returns boolean` — reports whether `flag` appears among the arguments.
- `public method value(String flag) returns String` — returns the token after `flag` (empty if the flag is absent or has no following token).
- `public method count() returns int` — returns the number of arguments.
- `public method get(int i) returns String` — returns the argument at index `i`.

---

## `Random`

- **Namespace:** `System.Math`
- **Import:** `import System.Math.Random;`

A deterministic PRNG (xorshift64), pure LDP3 over a `ulong` state (spec 34.6 Random). `Math` itself
is a compiler builtin, not a class; `Random` is the only real class in `System.Math`.

Public members:

- `public constructor Random(ulong seed)` — seeds the generator (a zero seed is bumped to 1 to avoid the fixed point).
- `public method nextInt() returns int` — advances the xorshift state and returns a non-negative 31-bit value.
- `public method nextIntMax(int max) returns int` — returns a value in `[0, max)`.
- `public method nextRange(int lo, int hi) returns int` — returns a value in `[lo, hi)`.
- `public method nextDouble() returns double` — returns a value in `[0, 1)`.
- `public method nextBool() returns boolean` — returns a coin-flip boolean.
- `public method nextGaussian() returns double` — a standard-normal N(0,1) sample via the Marsaglia polar method.
- `public method nextGaussianScaled(double mean, double stddev) returns double` — a normal sample shifted/scaled to the given mean and standard deviation.
- `public static method seededNow() returns Random` — a generator seeded from the monotonic clock (a fresh, non-reproducible sequence per run).

(The private `sqrtD` and `lnD` helpers keep `Random` from depending on the `Math` builtin name and are not public.)

---

## `Object`

- **Namespace:** `System.Runtime`
- **Import:** `import System.Runtime.Object;`

The root of the class hierarchy (spec 3.4): every class implicitly extends `Object`. `equals`
defaults to identity and `hashCode` to a constant; both are virtual so subclasses (e.g. records)
override them.

Public members:

- `public method equals(Object other) returns boolean` — reference-identity equality by default.
- `public method hashCode() returns int` — returns 0 by default (subclasses override).
- `public method equalsKey(Object other) returns boolean` — identity-based key equality, so every object is usable as a collection element/key; overridden alongside `hashCode` for value equality.
- `toString()` — returns `String` and is added together with the `String` type (not declared inline in this prelude slice).

---

## `Exception` (abstract)

- **Namespace:** `System.Runtime`
- **Import:** `import System.Runtime.Exception;`

Base for runtime exceptions (polymorphic, so it can be caught). Concrete runtime exceptions extend
it and supply a message.

Public members:

- `public abstract method message() returns String` — abstract; each exception returns its human-readable message.

---

## `UnimportedTypeException` (extends `Exception`)

- **Namespace:** `System.Runtime`
- **Import:** `import System.Runtime.UnimportedTypeException;`

Thrown when an unimported type is used (spec 30).

Public members:

- `public constructor UnimportedTypeException()` — creates the exception.
- `public override method message() returns String` — returns `"type was unimported"`.

---

## `BundleNotLoadedException` (extends `Exception`)

- **Namespace:** `System.Runtime`
- **Import:** `import System.Runtime.BundleNotLoadedException;`

Thrown on first use of a dynamically-loaded bundle (`--use-dynamic`) that is absent at runtime
(spec 2.4); wrap the use in try/catch to run without it.

Public members:

- `public constructor BundleNotLoadedException()` — creates the exception.
- `public override method message() returns String` — returns `"bundle not loaded"`.

---

## `BundleAbiMismatchException` (extends `Exception`)

- **Namespace:** `System.Runtime`
- **Import:** `import System.Runtime.BundleAbiMismatchException;`

Thrown when a loaded bundle's ABI fingerprint does not match what the program compiled against
(spec 2.5).

Public members:

- `public constructor BundleAbiMismatchException()` — creates the exception.
- `public override method message() returns String` — returns `"bundle ABI mismatch"`.

---

## `ClassCastException` (extends `Exception`)

- **Namespace:** `System.Runtime`
- **Import:** `import System.Runtime.ClassCastException;`

Thrown by an invalid class downcast: `cast<Dog>(animal)` / `animal as Dog` when the object is not a
`Dog` (spec 6.3). Catch it, or use `animal as? Dog` (yields null) / `animal is Dog`.

Public members:

- `public constructor ClassCastException()` — creates the exception.
- `public override method message() returns String` — returns `"invalid cast"`.

---

## `Iterator<T>` (interface)

- **Namespace:** `System.Collections`
- **Import:** `import System.Collections.Iterator;`

A cursor over a sequence (spec 34): reports whether another element remains and yields the current
one while advancing.

Public members:

- `method hasNext() returns boolean` — reports whether another element remains.
- `method next() returns T` — yields the current element and advances.

---

## `Iterable<T>` (interface)

- **Namespace:** `System.Collections`
- **Import:** `import System.Collections.Iterable;`

Anything that can hand out a fresh `Iterator` over its elements, so a generic algorithm can walk any
collection through these two interfaces (spec 34).

Public members:

- `method iterator() returns Iterator<T>` — returns a fresh iterator over the elements.
