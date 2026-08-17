# Examples

Each file here is a complete, runnable program. Run one with:

```
polaron run examples/regions.pol
```

Every example says at the top what it prints, and every one of them is compiled **and executed** by the
test suite (`examples_run`), so a change to the language that breaks one of these breaks the build.

## Start here

| File | What it shows |
|------|---------------|
| [hello.pol](hello.pol) | The smallest complete program: `program`, `bundle`, `namespace`, `class`, `main`. |
| [variables.pol](variables.pol) | Immutable by default, `mutable` where it is not, `var` for locals. |
| [operators.pol](operators.pol) | Arithmetic, comparison, logic, bitwise. |
| [control_flow.pol](control_flow.pol) | `if`/`else`, `while`, `for`, `switch`, `break`/`continue`. |
| [io.pol](io.pol) | Printing and reading, and string interpolation. |
| [classes.pol](classes.pol) | Fields, constructors, destructors, `static`, inheritance, interfaces. |
| [car.pol](car.pol) | The ergonomic form: stack by default, RAII, no ceremony. |

## The language's own ideas

| File | What it shows |
|------|---------------|
| [regions.pol](regions.pol) | Arena allocation: many objects, one lifetime, one release — and `accepts` making it a compile error to put the wrong type in. |
| [ownership.pol](ownership.pol) | Assignment is a copy; `movable` and `unique` for the things that must not be copied; `move` written down where ownership changes. |
| [transformers.pol](transformers.pol) | A conversion as a named relation between two types, with `entrusts` handing over the right to construct. |
| [contracts.pol](contracts.pol) | `requires`, `ensures` and `invariant` as part of the declaration, checked and handed to the optimiser. |
| [match_and_records.pol](match_and_records.pol) | `sealed ... permits` closing a hierarchy so `match` can be checked for exhaustiveness; `record` for values. |
| [generics.pol](generics.pol) | Monomorphized generics: `Box<int>` and `Box<String>` are two real types, with no boxing and no erasure. |
| [properties_and_operators.pol](properties_and_operators.pol) | A computed value that reads like a field; `operator +` on a vector. |
| [errors.pol](errors.pol) | `Result<T, E>` for failure a caller must handle, `throw`/`catch` for failure that unwinds. |

## Using the machine

| File | What it shows |
|------|---------------|
| [collections.pol](collections.pol) | `ArrayList`, `HashMap`, and the functional surface — `filter`, `map`, `reduce`, `any` — with lambdas. |
| [strings.pol](strings.pol) | Immutable `String`, mutable `string`, `StringBuilder`, and the `Strings` operations. |
| [iterators.pol](iterators.pol) | `for (x in …)` over anything iterable, and generators that `yield` values without building a list. |
| [concurrency.pol](concurrency.pol) | `Thread`, a lock-free `atomic<T>`, and a `Channel<T>` that hands values over instead of sharing them. |
| [ffi.pol](ffi.pol) | Calling C: `extern cdecl`, `symbol("…")`, and `class X library Y` naming where the symbols come from. |
| [testing.pol](testing.pol) | `[Test]` methods that `polaron test` finds and runs, with no framework to install. |

## Building them all

The suite does it, and so can you:

```
polaron run examples/hello.pol       # one of them
ctest --test-dir build2 -R examples  # all of them, compiled and run
```
