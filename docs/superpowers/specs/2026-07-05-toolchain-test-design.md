# Toolchain Sub-project 3, slice 1 — `ldp3 test`

Status: design (2026-07-05), approved approach (Model B). First of three slices in sub-project 3
(`test` → `doc` → `fmt`, one at a time). Built on the `ldp3` driver.

## Goal

`ldp3 test` discovers the project's tests and runs them, reporting pass/fail and exiting non-zero if any
fail. Tests are ordinary methods marked with the `[Test]` annotation (annotations use `[Name]` brackets in
LDP3 — the spec's `@Test` at §32.11 is a documentation error, confirmed by João). Discovery is automatic:
you write `[Test]`, `ldp3 test` finds and runs it.

## Test convention

A test is a `public static method` that returns `boolean` (true = pass) and carries the `[Test]` annotation:

```ldp3
import System.Test.Test;
import System.Test.Assert;

public class MathTests {
    [Test]
    public static method addition() returns boolean {
        return Assert.eq(2 + 2, 4);
    }
    [Test]
    public static method subtraction() returns boolean {
        return Assert.eq(5 - 3, 2);
    }
}
```

Tests may live in any class in the project; the compiler sees every file, so discovery spans the whole
program. A `[Test]` method that is not `public static` / does not return `boolean` is a compile error.

## Architecture

Discovery needs the AST (which carries each method's annotations), so it lives in the **compiler**. The
driver just drives it:

- **Prelude** gains a marker annotation `public annotation Test {}` in `System.Test`.
- **`ldp3c --test`** (new flag): instead of emitting the program's own entry point, the codegen collects every
  `[Test]` method and emits a synthetic entry that runs them all and reports.
- **`ldp3 test`** (driver): resolves the project, builds it with `--test` (output `build-output/<name>-test.exe`),
  runs it, and propagates its exit code.

## Compiler: `--test` mode

1. A `--test` CLI flag on `ldp3c` sets `testMode` on the codegen.
2. During the class walk, collect each method whose annotations include `Test` into a list of
   `{qualifiedName, displayName}` (displayName = the method name; qualifiedName = the emitted function symbol,
   e.g. `MathTests.addition`). Validate each is `public static` returning `boolean`; otherwise record a
   compile error.
3. In `testMode`, emit the `@entry` as a synthetic runner instead of wrapping the user's `main` (the user
   `main`, if any, is ignored). The runner, in emitted IR, does:
   - `int passed = 0, failed = 0;`
   - for each test T: `boolean r = <T>();` then `printf("PASS %s\n" | "FAIL %s\n", "<name>")` and bump the
     counter;
   - `printf("tests: %d passed, %d failed\n", passed, failed);`
   - `return failed == 0 ? 0 : 1;`
   - printf is the libc symbol the runtime already links.
4. Everything else (the classes, their methods, the runtime) is emitted as usual, so the test functions exist
   to be called.

Example output:

```
PASS addition
FAIL subtraction
tests: 1 passed, 1 failed
```

## Driver: `ldp3 test`

`ldp3 test` locates `ldp3.toml`, parses it, and calls the existing `buildProgram` with the manifest name
changed to `<name>-test`, `opts.passthrough = {"--test"}`, and `opts.run = true`. This compiles with the
test runner as the entry, links (including any dependencies, exactly like a normal build), runs the test
executable, and returns its exit code — so `ldp3 test` fails when a test fails. A missing manifest gives the
same clear error as `ldp3 build`.

## Error handling

- No manifest → `no ldp3.toml found; run 'ldp3 init' or ...`.
- A malformed `[Test]` method (not public/static, or not returning boolean) → a compile error naming the
  method.
- No `[Test]` methods at all → the runner prints `tests: 0 passed, 0 failed` and exits 0.

## Testing (CTest)

- A sample project with two `[Test]` methods (one passing, one deliberately failing) built and run through
  `ldp3 test`: the output contains `PASS`/`FAIL` lines and `1 passed, 1 failed`, and the command exits
  non-zero.
- A sample where all tests pass: exits zero.
- A doctest/unit check is not applicable (this is integration-level); coverage is the CTest above plus a
  compiler-level check that `[Test]` discovery works (via `--test` on a sample, matching stdout).

## Out of scope (later slices / future)

`ldp3 doc` and `ldp3 fmt` (the next slices). Test filtering (`ldp3 test <name>`), parallel test execution,
per-test timing, richer assertions, and setup/teardown are deferred.
