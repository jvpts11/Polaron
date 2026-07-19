# 6. Control Flow

Control flow is where a program stops being a list of declarations and starts making
decisions. LDP3 gives you the full imperative toolkit you would expect — conditionals,
loops, multi-way branching, and pattern matching — plus a small, deliberately unusual
set of low-level jump constructs (the "chaos tetrad") for the rare occasions when
ordinary structured flow gets in your way. This chapter walks through all of it, from
the everyday `if` to the kernel-grade `abstainfrom`, and it shows each construct with a
short program you can actually compile and run.

Two rules cut across everything in this chapter, so it is worth stating them once and
loudly before we begin.

**Every block is braced.** There is no such thing as a one-line `if` in LDP3. A
conditional, a loop, a `switch` case, a `match` arm — every one of them delimits its body
with `{ }`. This is not stylistic pedantry: the classic "dangling else" and the
"goto fail" family of bugs both come from bodies whose extent is implicit. LDP3 removes
the ambiguity at the grammar level.

```ldp3
if (x == null) { return; }    // OK
if (x == null) return;        // compile error: block requires braces
```

**Assignment is not an expression.** You cannot write `if (x = 5)` and accidentally
assign where you meant to compare — the compiler rejects it. A condition must be a
genuine boolean-valued (or truthy) expression, never an assignment. The whole category of
`=`-versus-`==` slips is designed out of the language.

With those two invariants in place, the rest of the chapter is mostly familiar territory
told carefully.

---

## 6.1 Conditionals: `if`, `else if`, `else`

The `if` statement runs its block when the condition holds. An optional `else` supplies
the alternative, and chaining `else if` gives you a ladder of mutually exclusive cases.
Because braces are mandatory, the shape of the code always matches its meaning — there is
never a hidden statement dangling off the end of a branch.

```ldp3
import System.IO.Console;
program Grade;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                int score = 82;
                if (score >= 90) {
                    System.IO.Console.println("A");
                } else if (score >= 80) {
                    System.IO.Console.println("B");        // this branch
                } else if (score >= 70) {
                    System.IO.Console.println("C");
                } else {
                    System.IO.Console.println("F");
                }
                return;
            }
        }
    }
}
```

Conditions are evaluated for truthiness. A boolean expression is the obvious case, but a
reference is also usable directly: an object reference is "truthy" when it is non-null, so
`if (dog)` reads as `if (dog != null)`. This lets a null check double as a presence check
without extra ceremony.

```ldp3
if (dog) {          // equivalent to: if (dog != null)
    dog.bark();
}
```

The boolean operators `&&` and `||` short-circuit, exactly as you would hope. In
`a() && b()`, `b()` is never evaluated when `a()` is already false; in `a() || b()`,
`b()` is skipped when `a()` is already true. That is not merely an optimization — it is a
guarantee you can lean on to guard a potentially unsafe second operand behind a cheap
first one.

---

## 6.2 `while` and `do`-`while`

A `while` loop tests its condition *before* each iteration, so a loop whose condition is
false at the outset runs its body zero times. A `do`-`while` loop tests *after* each
iteration, which means the body always runs at least once. Reach for `do`-`while` when the
work must happen before you can even decide whether to repeat it — reading a value, then
looping while that value is unsatisfactory, is the canonical shape.

```ldp3
import System.IO.Console;
program DoWhile;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                mutable int n = 0;
                mutable int count = 0;
                do {
                    count = count + 1;
                    n = n + 2;
                } while (n < 10);
                System.IO.Console.println($"count = {count}");   // n: 2,4,6,8,10 -> 5 iterations

                // The body runs at least once even when the condition is false up front.
                mutable int runs = 0;
                do {
                    runs = runs + 1;
                } while (runs < 0);
                System.IO.Console.println($"runs = {runs}");      // 1
                return;
            }
        }
    }
}
```

Note the `mutable` on every variable the loop reassigns. LDP3 is immutable-by-default:
a plain `int n = 0;` is a constant binding, and attempting to reassign it is a compile
error. Any counter, accumulator, or flag that a loop updates must be declared `mutable`.

---

## 6.3 The classic `for`

The three-clause `for` loop packages initialization, a per-iteration condition, and a
step into one header. It is the right tool when the loop is fundamentally driven by an
index or a hand-managed cursor.

```ldp3
import System.IO.Console;
program ForClassic;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                mutable int total = 0;
                for (mutable int i = 0; i < 10; i++) {
                    total = total + i;
                }
                System.IO.Console.println($"sum 0..9 = {total}");   // 45
                return;
            }
        }
    }
}
```

The loop variable `i` is scoped to the loop: it exists only inside the header and body,
and it is gone the moment the loop ends. The initializer declares it `mutable` because the
step clause reassigns it every pass.

---

## 6.4 `foreach`: iterating ranges and collections

The `for (T item in source)` form — "foreach" — iterates without an explicit index. It
comes in two flavors that share one syntax: iterating a **range** of integers, and
iterating any **collection** that models `Iterable<T>` (see the collections chapter). In
both, you may spell the element type explicitly or write `var` and let it be inferred.

### 6.4.1 Ranges

A range literal produces a sequence of integers. `a..b` is *half-open* — it includes `a`
and excludes `b` — which is the convention that makes lengths and offsets line up cleanly.
`a..=b` is *closed*: it includes both endpoints. Adding `step k` changes the stride from
the default of 1.

```ldp3
import System.IO.Console;
program ForRange;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                mutable int sum = 0;
                for (int i in 0..5) {           // 0,1,2,3,4  -> 10
                    sum = sum + i;
                }
                System.IO.Console.printf("excl=%d\n", sum);

                mutable int inc = 0;
                for (int i in 1..=5) {          // 1,2,3,4,5  -> 15  (closed)
                    inc = inc + i;
                }
                System.IO.Console.printf("incl=%d\n", inc);

                mutable int stepped = 0;
                for (int i in 0..10 step 2) {   // 0,2,4,6,8  -> 20
                    stepped = stepped + i;
                }
                System.IO.Console.printf("step=%d\n", stepped);
                return;
            }
        }
    }
}
```

A range is not just loop sugar; it is a first-class `Range<T>` value you can name, store,
and pass around, then iterate later:

```ldp3
Range<int> r = 0..100 step 5;
for (int i in r) { /* ... */ }
```

### 6.4.2 Collections

The same `for (... in ...)` iterates arrays and any `Iterable<T>`. Here the element type
is inferred with `var`:

```ldp3
import System.IO.Console;
program Foreach;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                int[] nums = new int[5]();
                for (mutable int i = 0; i < 5; i++) {
                    nums[i] = i * i;
                }
                mutable int sum = 0;
                for (var x in nums) {          // inferred element type
                    sum = sum + x;
                }
                System.IO.Console.println($"sum of squares = {sum}");   // 0+1+4+9+16 = 30
                delete nums;
                return;
            }
        }
    }
}
```

### 6.4.3 Iterating with an index

When you need the position alongside each element, add an `index` binding. The form
`for (index i, T v in source)` gives you the 0-based position `i` and the element `v` on
every pass, over both arrays and ranges. It is cleaner than a separate hand-maintained
counter and it cannot drift out of sync with the iteration.

```ldp3
import System.IO.Console;
program ForeachIndex;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                int[] xs = new int[4]();
                xs[0] = 10; xs[1] = 20; xs[2] = 30; xs[3] = 40;
                mutable int dot = 0;
                for (index i, int v in xs) {     // sum of i*v = 0 + 20 + 60 + 120 = 200
                    dot = dot + i * v;
                }
                System.IO.Console.printf("dot=%d\n", dot);
                delete xs;
                return;
            }
        }
    }
}
```

### 6.4.4 Generators: producing a sequence with `yield`

The other side of `foreach` is *producing* the sequence. A method that returns `Iterator<T>`
and whose body contains `yield` is a **generator**: instead of building a whole collection
and returning it, its body runs *lazily* — one element per `yield`, suspending right there
and resuming on the consumer's next request.

```ldp3
import System.Collections.Iterator;

public static method evens(int limit) returns Iterator<int> {
    mutable int n = 0;
    while (n <= limit) {
        yield n;          // hand back n, suspend here
        n = n + 2;        // resumes here on the next request
    }
}
```

You consume a generator like any iterable — with `foreach`:

```ldp3
mutable int sum = 0;
for (int e in Sequences.evens(8)) {
    sum = sum + e;        // 0 + 2 + 4 + 6 + 8
}
```

Because generation is lazy, a generator can be **infinite** — the consumer decides when to
stop, and `break` simply leaves the body suspended forever:

```ldp3
public static method primes() returns Iterator<int> {
    mutable int n = 2;
    while (true) {                  // never ends on its own
        if (Sequences.isPrime(n)) {
            yield n;
        }
        n = n + 1;
    }
}

for (int p in Sequences.primes()) {
    if (p > 30) {
        break;                      // the loop stops; the generator is abandoned
    }
    // ... use p ...
}
```

An **instance** generator captures `this`, so its body can read the object's fields, and an
early `return;` ends the sequence:

```ldp3
public method ticks() returns Iterator<int> {
    mutable int t = this.from;
    while (t > 0) {
        yield t;
        t = t - 1;
    }
    yield 0;
    return;                         // ends the sequence
}
```

Under the hood the compiler lowers the body to a heap state machine (the same coroutine
lowering `async`/`await` uses) wrapped in a synthesized class that implements `Iterator<T>`.
So a generator *is* an ordinary iterator: you can hold it in an `Iterator<T>` variable,
drive it by hand with `hasNext()`/`next()`, and `delete` it when done.

```ldp3
Iterator<int> it = Sequences.evens(4);
if (it.hasNext()) {
    int first = it.next();
}
delete it;
```

> `yield` has a second, unrelated use — the value of a block arm in a `match` expression
> (see [§6.7.2](#672-the-expression-form---and-yield)). The compiler tells them apart by
> context: `yield` inside a method that returns `Iterator<T>` is a generator; `yield` inside
> a `match` arm is that arm's value.

---

## 6.5 `break` and `continue`, plain and labelled

Inside any loop, `break` abandons the loop entirely and `continue` skips to the next
iteration. In their bare form they act on the innermost enclosing loop.

Nested loops raise a familiar problem: from inside the inner loop, how do you break out of
the *outer* one? LDP3 answers with **loop labels**. Prefix a loop with `name:` and then
`break name;` or `continue name;` targets that specific loop rather than the nearest one.
This removes the usual workaround of a `found` flag threaded through both loops, and it
keeps the intent explicit at the jump site.

```ldp3
import System.IO.Console;
program Labeled;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                // break to a labelled outer loop
                mutable int found = 0;
                outer: for (mutable int i = 0; i < 5; i++) {
                    for (mutable int j = 0; j < 5; j++) {
                        if (i * j == 6) {
                            found = i * 10 + j;
                            break outer;
                        }
                    }
                }
                System.IO.Console.println($"found = {found}");   // i=2, j=3 -> 23

                // continue to a labelled outer loop: abandon the current row, move to the next
                mutable int sum = 0;
                rows: for (mutable int r = 0; r < 3; r++) {
                    for (mutable int c = 0; c < 3; c++) {
                        if (c == 1) { continue rows; }
                        sum = sum + 1;
                    }
                }
                System.IO.Console.println($"sum = {sum}");       // 1 per row x 3 = 3
                return;
            }
        }
    }
}
```

`break outer;` unwinds both loops at once; `continue rows;` abandons the rest of the
current row and jumps straight to the next value of `r`. These loop labels are a
convenience of the looping constructs and are distinct from the standalone `label`
statements used by the jump constructs in section 6.8 — do not confuse the two.

---

## 6.6 `switch`: multi-way branching with fall-through

`switch` dispatches on a value against a list of `case` constants. LDP3's `switch` has two
firm rules that set it apart from the C tradition it otherwise resembles.

First, **every case body is braced** — `case 1 { ... }`, not `case 1:`. There are no
colon-introduced fall-through regions; a case is a block, like everything else in the
language.

Second, a **`default` is mandatory**. The compiler rejects a `switch` that does not handle
the residual case, so there is no silent "and if none of these, do nothing" hiding in your
control flow. If doing nothing is genuinely what you want, you write an empty `default { }`
and say so.

Fall-through is still available — it is often exactly what you want for grouping cases —
but it is now *opt-in per case*. A case that ends without `break` falls through into the
next one; a case that ends with `break` does not. Because the boundary of each case is a
brace rather than the next `case` label, the fall-through is a deliberate choice you make
by omitting `break`, not an accident of forgetting a colon.

```ldp3
import System.IO.Console;
program Switch;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                for (mutable int x = 0; x < 4; x++) {
                    switch (x) {
                        case 0 {
                            System.IO.Console.printf("zero ");
                            // no break: falls through into case 1
                        }
                        case 1 {
                            System.IO.Console.printf("one ");
                            break;
                        }
                        case 2 {
                            System.IO.Console.printf("two ");
                            break;
                        }
                        default {
                            System.IO.Console.printf("other ");
                        }
                    }
                }
                System.IO.Console.println("");   // "zero one one two other "
                return;
            }
        }
    }
}
```

`switch` is not limited to integers. It matches enum constants by their name and — a
notable extension — it matches `String` values *by content*, not by pointer identity. Two
strings built separately at runtime that hold the same characters take the same case.

```ldp3
switch (dir) {
    case Dir.NORTH { code = 0; break; }
    case Dir.EAST  { code = 1; break; }
    default        { code = 9; }
}

switch (command) {
    case "hi"    { greet(); break; }
    case "hello" { greet(); break; }   // matched by value, even for a runtime-built string
    default      { unknown(); }
}
```

When you are branching on the *dynamic type* of an object rather than on a scalar value,
`switch` is the wrong tool — that is what `match` is for, and it is where we go next.

---

## 6.7 `match`: exhaustive pattern matching

`match` (specification §16) is `switch`'s type-aware sibling. Instead of comparing a
scalar against constants, it dispatches on the *runtime type* of an object across a class
hierarchy, binds the matched object's fields to fresh locals in one step
("destructuring"), and — crucially — can be checked for **exhaustiveness** at compile
time. It exists in two forms: a *statement* form that runs a block per case, and an
*expression* form that produces a value.

### 6.7.1 The statement form and positional destructuring

Each `case` names a concrete subtype and, in parentheses, a list of bindings positionally
matched to that type's fields in declaration order. When an object matches a case, its
fields are pulled out into those named locals, ready to use in the arm's body. No manual
downcast, no field-by-field access — the dispatch and the extraction happen together.

```ldp3
import System.IO.Console;
program MatchDispatch;

public bundle main {
    public namespace app {
        public sealed abstract class Shape permits Circle, Rect {
            public abstract method tag() returns int;
        }
        public class Circle extends Shape {
            public int r;
            public constructor Circle(int r) { this.r = r; }
            public override method tag() returns int { return 1; }
        }
        public class Rect extends Shape {
            public int w;
            public int h;
            public constructor Rect(int w, int h) { this.w = w; this.h = h; }
            public override method tag() returns int { return 2; }
        }

        public class Main {
            public static method main(string[] args) returns void {
                Shape* s = new Rect(3, 4) on heap;
                match (s) {
                    case Circle(int r)        { System.IO.Console.println($"circle {r}"); }
                    case Rect(int w, int h)   { System.IO.Console.println($"rect area {w * h}"); }
                }
                delete s;
                return;
            }
        }
    }
}
```

Here `s` has static type `Shape*` but points to a `Rect`. The `match` inspects the dynamic
type, selects the `Rect` arm, and binds `w = 3` and `h = 4` positionally from the
instance's fields. Under the hood this is the same virtual-dispatch machinery that powers
method calls — matching on type is not a chain of hand-written casts.

### 6.7.2 The expression form: `->` and `yield`

A `match` can also *be* a value. In expression form, each arm uses `->` to supply its
result, and the whole `match` evaluates to the result of the selected arm. This turns a
five-line assign-in-each-branch statement into a single expression.

```ldp3
double area = match (shape) {
    case Circle(double r)          -> PI * r * r;
    case Square(double s)          -> s * s;
    case Triangle(double b, double h) -> b * h / 2.0;
};
```

When an arm needs more than a single expression, write it as a block and hand back the
value with `yield`:

```ldp3
int a = match (s) {
    case Circle(int r) -> {
        int p = r * r;       // multi-statement block arm
        yield p * 3;         // Circle(3): 9 * 3 = 27
    };
    case Square(int side) -> side * side;
};
```

Every arm — whether `-> expr` or `-> { ... yield ...; }` — must produce a value of the
same type, and that type is the type of the whole `match` expression.

### 6.7.3 Exhaustiveness, `sealed`, and `default`

The payoff of `match` is that the compiler can *prove* you handled every case. This hinges
on whether the matched type is `sealed`.

A `sealed` class fixes its set of direct subtypes with a `permits` clause: `sealed abstract
class Shape permits Circle, Square` declares that `Circle` and `Square` are the *only*
shapes there will ever be. Given that closed set, the compiler can check a `match` for
completeness. If you cover every permitted subtype, **no `default` is needed** — and if you
add a new subtype to the `permits` list later, every non-exhaustive `match` in the program
becomes a compile error until you handle it. That is the feature working for you: the type
system turns "did I update all the matches?" from a manual audit into a guaranteed one.

```ldp3
import System.IO.Console;
program Sealed;

public bundle main {
    public namespace app {
        public sealed abstract class Shape permits Circle, Square {
            public abstract method area() returns int;
        }
        public class Circle extends Shape {
            private int r;
            public constructor Circle(int r) { this.r = r; }
            public override method area() returns int { return this.r * this.r * 3; }
        }
        public class Square extends Shape {
            private int side;
            public constructor Square(int side) { this.side = side; }
            public override method area() returns int { return this.side * this.side; }
        }

        public class Main {
            public static method main(string[] args) returns void {
                Shape* s = new Circle(3) on heap;
                match (s) {                    // no default: sealed and exhaustive
                    case Circle(int r)    { System.IO.Console.println($"circle r = {r}"); }
                    case Square(int side) { System.IO.Console.println($"square side = {side}"); }
                }
                delete s;
                return;
            }
        }
    }
}
```

When the matched type is **not** sealed, the compiler cannot know the full set of
subtypes, so a `default` arm is **required** to cover whatever you did not name. The rule is
symmetric and easy to remember: *sealed and complete needs no default; anything else needs
a default.* You can, of course, use a `default` on a sealed type too, when you deliberately
want to collapse several permitted subtypes into one fallback:

```ldp3
int d = match (u) {
    case Circle(int r) -> r;
    default            -> 7;      // Square (and any other) falls here
};
```

---

## 6.8 The chaos tetrad: `goto`, `comefrom`, `abstainfrom`, `reinstate`

Beyond structured control flow, LDP3 exposes four low-level jump and toggle constructs,
collectively the "chaos tetrad" (specification §7.9–§7.11). They are powerful, they are
niche, and they are honest about being both. You will not use them in ordinary
application code — structured loops and `match` cover that ground better. Their home is
systems programming: kernels, drivers, bootloaders, embedded power management, and the
occasional retry or state-machine pattern where an ordinary loop reads worse than a jump.

Three properties define the tetrad and keep it disciplined.

**They are intra-method only.** Every one of the four references `label`s declared *in the
same method*. There is no jumping into another method, and no jumping across a class
boundary — `goto otherMethod.label` is a compile error, and so is the equivalent for the
other three. Cross-method jumping was considered and deliberately removed: action-at-a-
distance between methods is precisely the kind of chaos that makes these constructs
infamous elsewhere. By confining them to a single method body, LDP3 keeps the unit of
flow-control reasoning small and local. (The old "jump to file line *N*" forms —
`goto line N`, `comefrom line N` — were removed for the same reason and because they are
fragile under edits; use a named `label`.)

**They are available in freestanding mode.** This is worth stating plainly because it is
easy to assume otherwise: all four members of the tetrad work in `freestanding` programs
(specification §36). None of them depends on the managed runtime. `goto` and `comefrom`
lower to ordinary compile-time branches; `abstainfrom`/`reinstate` lower to a single
global integer — a reference counter — manipulated with atomic load/add/store. There is no
allocator, no syscall, and no runtime library involved, so everything compiles straight to
bare-metal instructions. In fact freestanding is where `abstainfrom` shines brightest
(power management, feature flags, conditional debug instrumentation in a kernel), so its
availability there is by design, not by accident. The managed features that freestanding
*does* drop are a different list entirely — exceptions, async/await, unimport/reimport,
reflection, `lazy`, `using`, `within`, persistents, and the managed `Console` — and the
tetrad is not among them.

A `label` itself is a bare statement marker, written `label name;`. It names a point in
the method that the tetrad constructs can target. Only labels you write explicitly are
valid targets; labels the compiler, runtime, or standard library generate are off-limits.

### 6.8.1 `goto` and `label`

`goto name;` transfers control directly to `label name;` in the same method. The most
common use is a forward jump that skips a stretch of code:

```ldp3
import System.IO.Console;
program GotoForward;

public bundle main {
    public namespace app {
        public class Main {
            public static method check(int x) returns void {
                if (x < 0) { goto negative; }
                System.IO.Console.println("non-negative");
                return;
                label negative;
                System.IO.Console.println("negative");
            }
            public static method main(string[] args) returns void {
                Main.check(5);        // non-negative
                Main.check(0 - 3);    // negative
                return;
            }
        }
    }
}
```

There is a second, deliberately unchecked form of `goto` for low-level and FFI work: a
jump to a raw *address* or an `extern` function. `goto myFunction;` treats an external
function as a jump target; `goto 0x1000;` jumps to a literal address. This is a one-way
transfer — control does not come back, and whatever follows the `goto` is unreachable —
so the programmer is fully responsible for the target's validity. It exists for bootloader
and kernel-entry scenarios, where handing control to code loaded at a known address is
exactly the job. This address form is a freestanding/low-level tool; the label form above
is the one you use in ordinary methods.

### 6.8.2 `comefrom`: inverse interception

`comefrom` is `goto` turned inside out. Where `goto` announces the jump at the *source*
("go there"), `comefrom` announces the interception at the *destination* ("when execution
reaches label L, come here instead"). When control reaches the referenced label, flow is
redirected to the point where the `comefrom` sits. It reads as a declarative statement
about a label elsewhere in the method, which is what makes it interesting — and what makes
it demand tooling support to read comfortably.

Because a `comefrom` can reference a label that appears either earlier or later in the
method, it serves as both a forward skip and a backward retry. On a backward jump, local
variables keep their values — there is no implicit reset — which is exactly what a retry
loop wants.

```ldp3
import System.IO.Console;
program Comefrom;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                mutable int a = 1;
                if (a == 1) { comefrom skip; }     // forward: intercept at `label skip`
                System.IO.Console.println("X");            // skipped
                label skip;
                System.IO.Console.println("forward ok");

                mutable int n = 0;
                label loop;
                n = n + 1;
                System.IO.Console.println($"n={n}");
                if (n < 3) { comefrom loop; }       // backward: retry; n keeps its value
                System.IO.Console.println("done");
                return;
            }
        }
    }
}
```

The discipline around `comefrom` is real. At most one `comefrom` may target any given
label (two would make the order ambiguous), it fires *after* the labelled statement runs,
and the compiler emits a warning when static analysis spots an obvious infinite cycle.
It does not, and cannot, undo I/O or external effects — a `comefrom` that jumps back over
a heap allocation leaves that memory to you (wrap the risky region in a `region` or use
`defer` for automatic cleanup). LDP3 is upfront about the limits.

### 6.8.3 `abstainfrom` and `reinstate`: toggling code at runtime

The last pair lets a method switch a block of its own code on and off at runtime without
threading boolean flags through the logic. `abstainfrom name;` disables the code from
`label name;` up to the next label (or the end of the method); `reinstate name;` turns it
back on. While a label is abstained, execution skips its block entirely.

Because the disabled region runs from the label to the end of the method, the
`abstainfrom`/`reinstate` calls must sit *before* the label they control — otherwise they
would land inside the very block they are trying to toggle and could never re-enable it.
The canonical shape is to read some state at the top of the method and toggle accordingly,
then let the guarded block follow:

```ldp3
import System.IO.Console;
program GotoAbstainfrom;

public bundle main {
    public namespace app {
        public class Main {
            public static method run(int mode) returns void {
                if (mode == 1) { abstainfrom body; }   // disable `body` from now on
                if (mode == 2) { reinstate body; }     // re-enable it
                label body;
                System.IO.Console.printf("body\n");    // skipped while abstained
            }
            public static method main(string[] args) returns void {
                Main.run(0);   // body
                Main.run(1);   // abstains body -> silent
                Main.run(0);   // still abstained -> silent
                Main.run(2);   // reinstates body -> body
                return;
            }
        }
    }
}
```

The on/off state is a **reference count**, not a single flag. Two `abstainfrom body;`
calls stack to a count of 2, and the block only wakes up when a matching number of
`reinstate body;` calls bring the count back to 0. This lets several independent reasons
to disable a block coexist without stepping on each other — no one caller has to know
whether another has already abstained. Reinstating an already-active label is a harmless
no-op (a warning, not an error), and the counter is per-execution: every program run starts
with everything reinstated.

The counter's increments and decrements are atomic and sequentially consistent, so
`abstainfrom`/`reinstate` behave predictably under concurrency: a toggle affects only
executions that *reach* the label afterward, while any thread already inside the block runs
to completion. And because that atomic counter is the entire runtime cost — one global
integer, no allocator, no scheduler — the whole mechanism is freestanding-safe, which is
why it is a natural fit for kernel power-management and driver feature-flag code.

For safety, `abstainfrom` refuses a long list of targets outright: compiler-generated
labels, import/unimport machinery, reimport validation, type-system checks, bounds checks,
constructors and destructors, region and persistent lifecycles, contract checks, and more.
You cannot use it to switch off the language's own correctness and safety mechanisms.

Here is the same pattern in a `freestanding` bundle, emitting through a bare `extern`
function — proof that the tetrad needs nothing from the managed runtime:

```ldp3
program FreestandingTetrad freestanding;

public bundle main freestanding {
    public namespace boot {
        public class Sys {
            public extern cdecl static method putchar(int c) returns int;
        }
        public class Main {
            public static method tick(int mode) returns int {
                if (mode == 1) { abstainfrom body; }   // disable body
                if (mode == 2) { reinstate body; }     // re-enable body
                label body;
                Sys.putchar(66);   // 'B'
                return 0;
            }
            public static method main(string[] args) returns int {
                Main.tick(0);   // B
                Main.tick(1);   // abstains -> silent
                Main.tick(0);   // silent
                Main.tick(2);   // reinstates -> B
                Sys.putchar(10);
                return 0;
            }
        }
    }
}
```

---

## 6.9 Choosing the right construct

With so many ways to branch and loop, a short guide helps.

- Use **`if`/`else if`/`else`** for a handful of boolean conditions.
- Use **`switch`** to branch a single scalar, enum, or string value against known
  constants — and remember the mandatory `default` and the opt-in fall-through.
- Use **`match`** whenever you are branching on an object's *dynamic type*, especially over
  a `sealed` hierarchy where you want the compiler to guarantee you covered every case, or
  when you want branching to *produce a value* via the `->`/`yield` expression form.
- Use **`while`** / **`do`-`while`** for condition-driven repetition, **classic `for`** for
  index-driven loops, and **`foreach`** for ranges and collections — reaching for the
  `index` binding when you need positions.
- Use **loop labels** with `break`/`continue` to control an outer loop from within a nested
  one.
- Reach for the **chaos tetrad** only in low-level or systems code, where a jump genuinely
  reads better than structured flow — and lean on the fact that it stays entirely within
  one method and works in freestanding mode.

The everyday constructs keep your code obvious; the tetrad is the escape hatch for the day
you need to talk to the machine on its own terms.
