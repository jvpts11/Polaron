# 16. Testing

A test in LDP3 is an annotated static method that lives next to the code it tests. There is no `test`
keyword and no `assert` keyword — it is annotations, static methods, and classes, the same pieces the
rest of the language is made of. `ldp3 test` finds them, runs them, and exits non-zero if any failed.

This chapter is about writing tests that are worth having: not only "does `add(2, 2)` return 4", but
"is the world this generator produced acceptable", "does this run give back all the memory it took",
"does the whole program still do the right thing end to end".

## 16.1 A first test

Annotate a `public static` method with `[Test]`, and assert:

```ldp3
import System.Test.Test;
program MathTests;

public bundle Main {
    public namespace App {
        public class MathUtils {
            public static method add(int a, int b) returns int {
                return a + b;
            }

            [Test]
            public static method add_basic() returns void {
                Test.assertEqual(MathUtils.add(2, 2), 4);
                Test.assertEqual(MathUtils.add(-1, 1), 0);
                return;
            }
        }
    }
}
```

```
$ ldp3 test
PASS MathUtils.add_basic
tests: 1 passed, 0 failed, 0 skipped
```

A `[Test]` method may return **`void`**, as above — its verdict is "no assertion failed" — or
**`boolean`**, in which case the test *is* its own verdict:

```ldp3
[Test]
public static method still_boolean() returns boolean {
    return MathUtils.add(20, 22) == 42;
}
```

Tests are discovered only in your own code: the standard library and your dependencies are not
scanned, so a dependency's tests belong to that dependency's own project.

Annotations may equally be written `@Test`; the two spellings are identical ([§10.3](#103-annotations)).
This documentation uses the bracket form throughout.

## 16.2 Saying what broke

An assertion that fails prints the numbers. Numbers alone are rarely enough:

```
  expected 8..22, got 31
```

`Test.checking(...)` names the criterion the following assertions are testing, and the failure becomes
readable:

```ldp3
Test.checking("mountain share stays in band");
Test.assertBetween(mountainPercent, 8, 22);
```

```
  [mountain share stays in band] expected 8..22, got 31
```

The label is cleared at the start of every test, so it costs nothing when you do not use it, and there
is no bookkeeping to get wrong. Reach for it whenever a test checks more than one thing.

Two more reporting calls round it out:

- `Test.fail(String why)` records a failure directly, for a check no assertion covers.
- `Test.skip(String why)` gives up at runtime on an **unmet precondition** — no GPU, no network, a
  fixture that could not be built. The test is reported as SKIP, which is neither a pass nor a defect.
  A test that skips is honest; one that passes because it never ran is not.

## 16.3 The assertions

| Group | Calls |
|---|---|
| Equality | `assertEqual(int, int)`, `assertNotEqual`, `assertEqualLong`, `assertEqualString`, `assertEqualIntArray` |
| Predicates | `assertTrue`, `assertFalse`, `assertContains(String, String)` |
| Ranges | `assertBetween(int, int low, int high)`, `assertAtLeast`, `assertAtMost`, `assertBetweenDouble` |
| Tolerances | `assertWithin(double, double, double absolute)`, `assertNear(double, double, double relative)` |
| Exceptions | `assertThrows<E>(function<void>)` |
| Memory | `assertNoLeaks(function<void>)` — see [§16.6](#166-asserting-on-memory) |

Two of these deserve a note.

**Ranges, not exact values.** Most measurements of a generated or simulated system are only ever
"within an acceptable band". Writing that as `assertTrue(v >= 8 && v <= 22)` compiles fine and throws
away everything the report needed: which bound, and by how much. `assertBetween` keeps the numbers.

**`assertNear` is relative.** `assertWithin(actual, expected, 0.5)` means "within half a unit";
`assertNear(actual, expected, 0.05)` means "within 5%". Use the relative form for quantities whose
scale varies — a cell count that depends on world size, an elapsed time. It falls back to an absolute
comparison when the expected value is zero, where a relative one has no meaning.

## 16.4 Fixtures: the lifecycle hooks

A test that needs an expensive thing — a generated world, a parsed file, an open connection — should
not rebuild it for every assertion. Four hooks control when setup happens:

| Hook | Runs |
|---|---|
| `[BeforeAll]` | once, before the class's first test |
| `[AfterAll]` | once, after the class's last test |
| `[Setup]` | before **each** test of the class |
| `[Teardown]` | after **each** test of the class |

All four are `public static` methods returning `void`, and there may be at most **one of each per
class** — two would have no defined order, so the runner would have to silently pick one, and the
compiler rejects it instead.

```ldp3
public class Census {
    private static mutable int[] cells;      // the class fixture
    private static mutable int[] scratch;    // a per-test buffer

    [BeforeAll]
    public static method buildWorld() returns void {
        Census.cells = new int[65536]();
        return;
    }

    [AfterAll]
    public static method dropWorld() returns void {
        delete Census.cells;
        return;
    }

    [Setup]
    public static method openScratch() returns void {
        Census.scratch = new int[8]();
        return;
    }

    [Teardown]
    public static method closeScratch() returns void {
        delete Census.scratch;
        return;
    }

    [Test]
    public static method values_stay_in_band() returns void {
        Test.checking("every cell holds a value in 0..6");
        mutable int i = 0;
        while (i < Census.cells.length()) {
            Test.assertBetween(Census.cells[i], 0, 6);
            i = i + 1;
        }
        return;
    }
}
```

The hooks belong to their class alone; another class in the same file is unaffected. And `[BeforeAll]`
is **skipped entirely** when `--filter` selected none of the class's tests — the expensive fixture is
never built for a run that was not going to use it.

## 16.5 Known-broken tests

A test for something that does not work yet has two bad fates: deleted, or commented out. Both make
the gap invisible. `[Ignore]` is the third option — the test stays in the file and in the report:

```ldp3
[Ignore(reason: "regrowth is not implemented yet")]
[Test]
public static method forest_regrows() returns void {
    Test.fail("would fail today");
    return;
}
```

```
SKIP Census.forest_regrows -- regrowth is not implemented yet
```

It never runs, so it cannot turn the suite red, and it names itself and its reason on every run so
nobody forgets it is there.

## 16.6 Asserting on memory

LDP3 manages memory by hand, so a program can be entirely correct and still be wrong: it produces the
right answer and grows by a megabyte a second. No correctness assertion can see that.
`Test.assertNoLeaks` can:

```ldp3
[Test]
public static method parsing_gives_everything_back() returns void {
    Test.checking("a parse round-trip leaves no live blocks");
    Test.assertNoLeaks(lambda() returns void {
        Document* d = Parser.parse(sample) on heap;
        delete d;
    });
    return;
}
```

It records the live-block total before and after the action and fails if it grew. Three limits worth
knowing: it measures the **calling thread**, so work handed to another thread is not covered; it
measures *net* bytes, so a leak exactly balanced by a matching free elsewhere in the action reads as
clean; and **the assertion machinery allocates too** — `Test.checking` stores its label as a `String`
— so keep `Test.*` calls out of the action being measured.

`Test.liveBytes()` exposes the same number directly, for when the question is a budget rather than a
leak:

```ldp3
long before = Test.liveBytes();
this.simulateOneFrame();
long after = Test.liveBytes();
Test.checking("a frame allocates under a megabyte");
Test.assertTrue(after - before < 1048576);
```

## 16.7 Testing the whole program

Under `--test` the runner is the entry point, which means your program's own `main` is no longer the
entry point — it is an ordinary static method, and a test can call it:

```ldp3
[Test]
public static method drives_the_whole_program() returns void {
    string[] argv = new string[2]();
    argv[0] = "prog";
    argv[1] = "--seed=42";
    Main.main(argv);
    Test.checking("a full run leaves the world in a valid state");
    Test.assertBetween(World.landmasses(), 3, 9);
    delete argv;
    return;
}
```

This is the answer to "can a test exercise the whole program": it can, with the arguments it chooses,
as many times as it likes, asserting on whatever state the run left behind. Nothing special is needed
— no harness, no separate entry point, no mode flag threaded through `main`.

## 16.8 Running them

| Command | What it does |
|---|---|
| `ldp3 test` | Build and run every test in the project. |
| `ldp3 test -- --filter <text>` | Run only the tests whose `Class.method` name contains `<text>`. |
| `ldp3 test -- --list` | Print the test names without running anything. |
| `ldp3 test -- --timing` | Add per-test and total durations to the report. |

Everything after `--` goes to the runner; anything it does not recognize it ignores, so a project may
pass its program's own flags the same way.

A **`[library]` project** is tested the same way. It normally builds to a `.ldb` bundle with no entry
point, but `ldp3 test` builds its sources as an executable instead — the runner supplies the entry —
so a library's tests run exactly like a program's. Its tests belong to it: a program that depends on
the library does not re-run them.

The report is **deterministic by default** — durations are opt-in behind `--timing` — so it can be
diffed, pasted into a review, or compared against a golden file:

```
PASS Census.values_stay_in_band
SKIP Census.forest_regrows -- regrowth is not implemented yet
FAIL Census.setup_ran_for_this_test
  [scratch is fresh] expected 8, got 0
tests: 1 passed, 1 failed, 1 skipped
```

The process exit code is non-zero if anything failed, which is all a CI needs.

## 16.9 Malformed tests are compile errors

A test that silently does not run is worse than a test nobody wrote: the suite stays green and nobody
learns anything. So the compiler rejects, rather than ignores:

- a `[Test]` that is not `public static`, or returns something other than `boolean`/`void`;
- a hook that is not `public static` returning `void`;
- a second `[Setup]` (or `[BeforeAll]`, `[AfterAll]`, `[Teardown]`) in the same class;
- a method marked both `[Test]` and a hook — a hook runs *around* the tests, so it cannot be one;
- `[Ignore]` on anything that is not a `[Test]`, where it would read as "skipped" while the method
  runs perfectly normally.
