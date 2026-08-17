# 19. Final considerations

What the language is for, what it refuses, what it costs you, and what is honestly not finished. This
chapter is the one to read if you are deciding whether to write something in Polaron.

---

## 19.1 What it is for

Programs where **you are responsible for the machine**: a simulation with a hundred thousand moving
things, an editor that must not stutter, a service that runs for months, a kernel. Polaron is a
systems language with the manners of an application language — objects, generics, contracts,
reflection, a large standard library — and no garbage collector anywhere near the tick.

The bet it makes: *the object graph was never the problem.* The reason other languages reach for a
collector is not that objects are hard, it is that nobody wrote down who owns what. Polaron makes you
write it down — in a destructor, a region, a `move`, a `weak` — and then proves the rest.

## 19.2 What it refuses, on purpose

| Refused | Why |
|---|---|
| **Garbage collection** | A pause you did not schedule is a pause in the frame you were drawing. |
| **Exploitable undefined behaviour** | Division by zero throws, a cast that does not fit saturates, an index out of range traps. A wrong answer that looks right is worse than a crash. |
| **Implicit conversions between number types** | `int` to `long` is written down. The bugs this prevents are the ones nobody sees in review. |
| **Method overloading** | One name, one method. A call site says which thing it calls without knowing the argument types by heart. |
| **Assignment as an expression** | `if (x = 5)` has never been what anybody meant. |
| **Free functions** | Every method belongs to a type. A namespace of loose functions is a class that nobody admitted to writing. |
| **Merging two owners** | Nothing in the language moves one object's contents into another behind your back. |
| **A partial region guarantee** | There is no per-file switch for the borrow analysis. Either the program is placed or it is not — a proof about part of a partition is not a proof. |

Each of these is a place where the language is *less* convenient than its neighbours, deliberately,
because the convenience was paid for in a failure mode nobody could see.

## 19.3 What it costs you

Be honest with yourself about these before starting:

- **You will write destructors.** Not many — a value type needs none — but every type that owns
  something needs one, and forgetting is a leak the compiler will often, but not always, catch.
- **The region binder will refuse programs that are fine.** When two objects have no stated
  relationship it says so, and the fix is to state one (§17.2, §17.3). That is a real cost in the
  first week and mostly disappears after it.
- **No overloading and no implicit conversions** means more names and more casts.
- **The ecosystem is small.** The standard library is large — 338 public types, from `ArrayList` to
  TLS 1.3 — but the third-party world is what you and the people around you write. `polaron plug`
  installs from any git URL; there is no registry yet.
- **Windows and Linux, x86-64.** ARM and macOS are on the roadmap, not in your hands today.

## 19.4 What is finished, and what is not

**Finished** — used daily, tested, and not expected to change under you: the object model, generics,
regions and ownership, contracts, `Result`/`Option`, exceptions, `async`/`await` and the concurrency
set, reflection and annotations, the diagnostics system, the toolchain (`build`/`run`/`test`/`fmt`/
`doc`/`explain`/`plug`), the standard library documented in Part II, freestanding compilation on the
compiler's side.

**Working, with edges** —

- **The package manager** installs, pins and reproduces, but does not resolve version conflicts: two
  dependencies wanting different majors of one library take whichever was installed first, silently.
  There is no registry, no integrity hash and no global cache.
- **Bare metal** compiles and links for a bare target; the boot path (`_start`, a linker script, a
  QEMU run) is not written.
- **TLS** is 1.3 only. A server that requires 1.2 refuses the connection, and the client says so.
- **`Raw.sizeof`** under-reports a struct with more than one nested value struct — the fields
  themselves are correct, but a layout budget enforced with that call could pass while being wrong.

**Not started:** ARM and macOS targets, an incremental compiler, a package registry, a debugger UI of
its own (DWARF and `lldb-dap` work today).

## 19.5 How to read the rest of this book

- Coming from **C++**: start with §5 (memory), then §17 (how the pieces fit). The object model will
  be familiar; the region binder will not.
- Coming from **Rust**: §5 and §17.3. Ownership here is read from destructors rather than declared in
  types, and `weak` is the escape that a lifetime parameter would be.
- Coming from **Java or C#**: §5 first, and take §17.1 seriously — a container of values holds
  copies, which is the single most surprising thing about the language if you arrived from a world
  where every object is a reference.
- **Writing a kernel**: §11, then §18.5.
- **In a hurry**: §1, the `examples/` directory in the repository (twenty-two programs, each compiled
  and run by the test suite), and §18.

## 19.6 A closing note on the diagnostics

If you remember one thing from this reference, make it this: **when the compiler refuses something,
read the whole message.** Every one of the 82 diagnostics carries *why* the rule exists, *how* to
satisfy it, and *what habit prevents it next time* — and most of them were written the day a real
program hit them, by the person who then had to fix that program.

`polaron explain Polaron-1722` prints the long form of any of them from the command line. A language
that refuses your program owes you the reason, and this one tries to pay that debt at the moment of
refusal rather than in a chapter you would have to know to look for.
