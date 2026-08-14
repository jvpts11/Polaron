# 8. Errors, Results & Contracts

Every real program has to reckon with the moment things go wrong: a file that isn't
there, a number the user typed that can't be parsed, a division whose denominator
turned out to be zero. Polaron does not pretend those moments away, and it does not
leave them to chance either. The language gives you three complementary tools for
dealing with failure, and a fourth guarantee that sits underneath all of them.

The three tools are *exceptions* (`try`/`catch`/`finally` with `throw`), *result
types* (`Result<T, E>` and `Option<T>`, matched exhaustively or threaded with the
`try?` operator), and *contracts* (`requires`, `ensures`, `invariant`). The
guarantee underneath is the no-undefined-behaviour principle: when an operation
cannot produce a meaningful answer — an integer that overflows, an index past the
end of an array, a dereference through a null reference — the result is always
*deterministic*, never an exploitable crash into the weeds.

This chapter explains what each tool does, how the compiler implements it, and,
just as importantly, *when to reach for which one*. The short version: use
exceptions for genuinely exceptional, cross-cutting failures; use `Result`/`Option`
for expected, recoverable outcomes on the value path; use contracts to state the
rules a method assumes and promises; and lean on the no-UB guarantee to know that
even the failures you *didn't* plan for stop cleanly.

---

## 8.1 Exceptions: `try`, `catch`, `finally`, `throw`

An exception is a way to abandon the current computation and hand control to a
handler further up the call stack. You raise one with `throw`, you guard a region
of code with `try`, and you handle raised exceptions with `catch`. A `finally`
block runs no matter how the guarded region is left.

Here is the whole shape in one runnable program. `run(true)` throws and is caught;
`run(false)` completes normally. In both cases the `finally` block runs.

```polaron
import System.IO.Console;
program ExceptionsIntro;

public bundle main {
    public namespace app {
        public interface Throwable { }

        public class MyError implements Throwable {
            public constructor MyError() { }
        }

        public class Main {
            public static method run(boolean fail) returns void {
                try {
                    if (fail) { throw new MyError() on heap; }
                    System.IO.Console.println("body ok");
                } catch (MyError e) {
                    System.IO.Console.println("caught");
                } finally {
                    System.IO.Console.println("finally");
                }
                return;
            }

            public static method main(string[] args) returns void {
                Main.run(true);    // prints: caught / finally
                Main.run(false);   // prints: body ok / finally
                return;
            }
        }
    }
}
```

### What you can throw

A thrown value must be a **heap-allocated object that participates in a class
hierarchy** — that is, a class that either `extends` another class or `implements`
an interface, so that it carries a vtable. Two rules follow, and the compiler
enforces both:

- **You cannot throw a bare primitive.** `throw 5;` is a compile error, not a
  runtime surprise. An exception has to be an object the handler can identify by
  type.
- **You cannot catch a standalone (non-polymorphic) class.** A class with no base
  and no interface has no vtable, so a handler would have no type information to
  match against; the compiler rejects `catch (Plain p)` for such a `Plain`.

The object must also live on the heap, because it has to outlive the stack frame
that raised it:

```polaron
throw new MyError() on heap;   // ok

MyError e = new MyError() on stack;
throw e;                        // compile error: a thrown object must be heap-allocated
```

The spec's canonical example roots exceptions in a base `Exception` class
(`public class IOException extends Exception { }`); implementing a small
`Throwable` interface, as above, works exactly the same way. What matters is only
that the thrown type is polymorphic.

### Type-matched catch

Catch clauses are tried top to bottom, and a clause matches when the thrown
object's runtime type **is** the caught type *or a subtype of it*. Polaron does the
matching itself — it compares the thrown object's vtable pointer against the set of
vtables for the caught class and all its subclasses — rather than relying on C++
RTTI. So an ancestor clause catches a descendant, exactly as you'd expect:

```polaron
public class AppError implements Throwable { public constructor AppError() { } }
public class ParseError extends AppError { public constructor ParseError() { } }

try {
    throw new ParseError() on heap;
} catch (AppError e) {           // matches: ParseError is-a AppError
    System.IO.Console.println("handled as AppError");
}
```

Put the most specific clauses first; a broad `catch (AppError e)` placed before a
`catch (ParseError e)` would shadow the narrower one.

### The `throws` clause

A method may declare the exception types it is expected to raise with a `throws`
clause. `throws` is a real keyword, not an annotation:

```polaron
public method readFile(String path) throws(IOException, NetworkException) returns string {
    if (!this.exists(path)) {
        throw new IOException() on heap;
    }
    // ...
}
```

Polaron's exceptions are *unchecked*: the `throws` clause documents intent and drives a
compiler **warning**, it does not force callers to handle anything. If a `throw`
reaches a point where it is neither caught by an enclosing `try` nor covered by the
method's own `throws` clause, the compiler warns that the exception "is neither
caught nor declared in the method's 'throws' clause" — a nudge to either handle it
or declare it, never a hard error that stops the build.

### `finally` always runs

The defining property of `finally` is that it runs on *every* way out of the
guarded region, not just the tidy ones. That includes:

- normal fall-through off the end of the `try` body,
- a caught exception (the matching `catch` runs, then `finally`),
- an *uncaught* exception that propagates to an outer handler,
- and an early `return`, `break`, or `continue` that jumps out of the `try`.

The uncaught case is the subtle one. Here an inner `try` has only a `finally`; the
throw is caught by the *outer* `try`, but the inner `finally` still runs on the way
out:

```polaron
try {
    try {
        System.IO.Console.println("throwing");
        throw new MyError() on heap;
    } finally {
        System.IO.Console.println("inner finally");   // runs, though uncaught here
    }
} catch (MyError ex) {
    System.IO.Console.println("outer caught");
}
// prints: throwing / inner finally / outer caught
```

And the early-exit case — a `return` out of a `try`, or a `break` that leaves a
`try` nested in a loop — runs `finally` before control actually departs:

```polaron
public static method withReturn() returns int {
    try {
        return 1;
    } finally {
        System.IO.Console.println("finally-return");   // runs before the return leaves
    }
}
```

### The unwinding model, and why cleanup is reliable

Polaron lowers exceptions to the platform's **native landing-pad unwinding**, not to
`setjmp`/`longjmp`. On Windows the compiler emits Microsoft's structured-exception
tables and routes through `__CxxFrameHandler3`; on Linux and other ELF targets it
emits the Itanium/DWARF model, throwing through `__cxa_throw` with the
`__gxx_personality_v0` personality. In both cases every Polaron exception travels as a
single canonical carrier — the object pointer — and the handler does the real
type-matching in ordinary code.

The practical payoff is a **zero-cost happy path**: when nothing is thrown, the
`try` region is just straight-line code with no per-statement bookkeeping and no
overhead. You pay only when an exception is actually raised and the runtime walks
the stack to find a handler.

That stack walk is where reliability matters, and this is a point Polaron takes
seriously. As the stack unwinds through each frame, *all* scope cleanup runs, in
the correct order:

- `finally` blocks,
- `defer` statements (LIFO, see Chapter on scoped resources),
- `using` bindings (their `delete` fires),
- region releases,
- and `synchronized`/mutex unlocks.

None of these are skipped just because the exit path is an exception rather than a
normal return. A resource acquired before a throw is released as the throw passes
back through its scope:

```polaron
public method process(String path) returns void {
    File f = new File(path) on heap;
    defer { delete f; }          // runs even if f.read() throws
    f.read();
}
```

This closes a whole category of leaks-on-error that plague languages where cleanup
and unwinding are bolted on separately.

---

## 8.2 `Result<T, E>` and `Option<T>`

Exceptions are the right tool when a failure is genuinely exceptional and you want
it to punch through several call frames at once. But a great many "failures" are
ordinary, expected outcomes: parsing might not succeed, a lookup might find
nothing. For those, Polaron gives you two sum types in the prelude that make the
failure part of the value itself, so the type system forces you to deal with it.

`Result<T, E>` holds either a success value of type `T` (an `Ok`) or an error value
of type `E` (an `Err`). `Option<T>` holds either a present value (a `Some`) or
nothing (a `None`). Both are sealed types — the set of cases is fixed — which is
what lets `match` check exhaustiveness. They live under `System.Errors`:

```polaron
import System.Errors.Result;
import System.Errors.Option;
```

### Constructing them

The explicit form is an ordinary heap allocation:

```polaron
Result<int, int>* ok  = new Ok<int, int>(7) on heap;
Result<int, int>* err = new Err<int, int>(404) on heap;
Option<int>* some = new Some<int>(9) on heap;
Option<int>* none = new None<int>() on heap;
```

More commonly you use the construction *sugar* — `Ok(x)`, `Err(x)`, `Some(x)`,
`None()` — and let the compiler infer the generic arguments from the expected type,
which is either the method's declared return type or the type of the variable you
are assigning to:

```polaron
public static method parse(int n) returns Result<int, int>* {
    if (n < 0) { return Err(404); }   // E inferred as int from the return type
    return Ok(n);                      // T inferred as int
}

Result<int, int>* a = Ok(7);          // both inferred from the declared type
Option<int>* o = Some(9);
Option<int>* p = None();
```

### Consuming them with `match`

Because `Result` and `Option` are sealed, a `match` over one must cover every case
— and, having covered them, needs no `default` arm. Each `case` binds the payload
positionally:

```polaron
public static method grade(Result<int, int>* r) returns int {
    match (r) {
        case Ok(int v)  { return v; }
        case Err(int e) { return 0 - e; }
    }
    return 0;
}
```

The same reads naturally for `Option`:

```polaron
match (o) {
    case Some(int v) { System.IO.Console.printf("some %d\n", v); }
    case None()      { System.IO.Console.printf("none\n"); }
}
```

If you forget a case, the compiler tells you at build time rather than letting a
missing branch slip through — that is the whole point of making failure a value
with a closed set of shapes.

### Propagating with `try?`

Threading a `Result` up through several layers by hand — match, pull out the value
on success, return the error on failure, repeat — is tedious and easy to get
wrong. The `try?` operator does exactly that in one token. Applied to a `Result` or
`Option`, it evaluates to the inner value when the operand is `Ok`/`Some`, and
otherwise **immediately returns** the `Err`/`None` from the enclosing method:

```polaron
public static method parse(int n) returns Result<int, int>* {
    if (n < 0) { return Err(0 - n); }
    return Ok(n);
}

public static method doubleIt(int n) returns Result<int, int>* {
    int v = try? Main.parse(n);   // Ok -> v; Err -> return that Err from doubleIt
    return Ok(v + v);
}
```

`doubleIt(5)` runs `parse(5) = Ok(5)`, binds `v = 5`, and returns `Ok(10)`.
`doubleIt(-3)` runs `parse(-3) = Err(3)`, and `try?` short-circuits: `doubleIt`
returns that `Err` without ever reaching the next line.

Two constraints keep `try?` honest, and the compiler checks both:

- the operand must actually be a `Result` or `Option` — `try?` on anything else is
  a compile error ("`try?` requires a Result or Option operand"); and
- the enclosing method must itself return a `Result` or `Option`, since that's
  where the propagated error goes. Using `try?` inside a method that returns `void`
  is a clean compile error, not a runtime crash.

### When to prefer Results over exceptions

Reach for `Result`/`Option` when failure is an *expected, recoverable* part of the
job — parsing input, looking something up, opening a file that might be absent. The
failure stays on the value path, every caller can see from the signature that it
must be handled, and there is no stack-unwinding machinery involved.

Reach for exceptions when a failure is genuinely *exceptional* and should unwind
across many frames to a distant handler — the kind of error most call sites have no
useful way to react to locally.

There is also a hard rule: **freestanding mode has no exceptions.** When a program
or bundle is declared `freestanding` (for kernels and bare-metal targets, where
there is no unwinder and no C++ personality routine), the compiler rejects `try`,
`catch`, and `throw` outright. In that environment `Result` and `Option` are your
*only* structured error-handling tools — which is one more reason to build the
habit of using them for anything a caller can reasonably recover from.

---

## 8.3 Contracts: `requires`, `ensures`, `invariant`

Contracts let a method state, in executable form, the assumptions it makes and the
promises it keeps. They are optional — you attach them where a rule is worth
enforcing — and they read as part of the method's signature, before the body.

- **`requires`** states a *precondition*: something that must be true on entry.
- **`ensures`** states a *postcondition*: something the method guarantees on exit.
- **`invariant`** states a *class invariant*: something that must hold for every
  instance across its observable lifetime.

Here is an `Account` that spells out all three:

```polaron
public class Account {
    private mutable int balance;

    invariant this.balance >= 0;

    public constructor Account(int start)
        requires start >= 0
        ensures this.balance == start
    {
        this.balance = start;
    }

    public method deposit(int amount) returns void
        requires amount > 0
        ensures this.balance == old(this.balance) + amount
    {
        this.balance = this.balance + amount;
    }

    public method withdraw(int amount) returns void
        requires amount > 0
        requires amount <= this.balance
        ensures this.balance == old(this.balance) - amount
    {
        this.balance = this.balance - amount;
    }
}
```

Each clause is an ordinary boolean expression. You may stack several `requires` (or
several `ensures`); they all have to hold.

### When each check runs

The compiler weaves the checks into the generated code:

- `requires` clauses are evaluated **on entry**, before the body runs.
- `ensures` clauses are evaluated **on exit**, after the body has done its work.
- `invariant` clauses are also evaluated on method exit, so every public operation
  leaves the object in a valid state.

When a clause holds, execution proceeds. When one fails, the program stops with a
non-zero status. A violation is a bug in the program, so it stops deterministically
rather than raising a catchable exception — you are meant to fix the caller or the
method, not to `catch` a broken contract.

### What a violation says

A contract exists to name a disagreement, so one that fails says **which** one, and
on stderr rather than in the middle of the program's own output:

```
contract violated: requires
  --> src/gfx/GlWorld3D.pol:345:32  in GlWorld3D.upload
   |  requires wrote == counted
   |  left = 17561340, right = 23966928
```

The clause is quoted as you wrote it, read back out of the source. The last line
appears whenever the clause is a comparison whose two sides can be read a second
time **without consequences** — identifiers, fields, literals, casts of those.
Never a call: a diagnostic that changes the state it is diagnosing is worse than
none, so anything that could log, mutate or allocate simply goes unquoted.

The no-UB guards — an index off the end, a division by zero, a full region — report
in the same shape, with their own two numbers (`index = 9, length = 6`).

**All of it holds in `freestanding` too**, including the values, which a kernel
formats without stdio. There it arrives through `__polaron_panic`, which a kernel may
override to route reports to its own console; overriding it keeps the whole message,
because everything is composed before that call rather than printed around it.

### `old(...)` in postconditions

A postcondition often needs to compare the final state to the state *at entry* —
"the balance went up by exactly `amount`." The `old(e)` form gives you the value
`e` had when the method was entered. The compiler captures each `old(...)`
expression on entry into a hidden slot and reads it back when the `ensures` clause
runs:

```polaron
ensures this.balance == old(this.balance) + amount
```

`old(...)` is only meaningful inside an `ensures` clause; using it elsewhere is a
compile error.

### `result` in postconditions

Every example above is a `void` mutator promising something about `this`. The other
half of what a postcondition is for is the *returned value* — "what I hand you
satisfies this" — and inside an `ensures` clause the name `result` is that value:

```polaron
public method takePage() returns int
    ensures result % 4096 == 0
{
    ...
}
```

This is the guarantee that meets a caller's `requires`. A frame allocator that
promises page-aligned addresses and a mapper that requires them state the two halves
of one contract, and neither has to trust the other.

`result` is in scope in `ensures` only. A `requires` clause runs on entry, before
there is a result, so naming it there is an undeclared-name error like any other. It
is not a reserved word: a local actually called `result` shadows the binding and
means itself. With several `return` statements, each one's postconditions see that
return's own value.

### Invariants are inherited

A class invariant binds not only the class that declares it but every subclass. If
`Counter` declares `invariant this.count >= 0;`, then a `Stepper extends Counter`
is held to that same invariant on exit of *its* own methods too:

```polaron
public class Counter {
    protected mutable int count;
    invariant this.count >= 0;
    public constructor Counter() { this.count = 0; }
    public method get() returns int { return this.count; }
}

public class Stepper extends Counter {
    public constructor Stepper() { this.count = 0; }
    public method up(int n) returns void { this.count = this.count + n; }
    public method down(int n) returns void {
        this.count = this.count - n;   // checked against the inherited invariant on exit
    }
}
```

If `down` ever drove `count` below zero, the inherited invariant would fire on the
way out of `down`, even though the rule was written on `Counter`.

### `demand`: the compile-time cousin

Contracts are checked as the program runs. Sometimes the thing you want to state
is knowable at *build time* — a buffer size, a table length, a bit of arithmetic
that must come out a certain way. `demand <condition> otherwise "why";` settles a
constant condition during compilation and emits no runtime code at all:

```polaron
demand 2 + 2 == 4 otherwise "math is broken";
demand 16 * 1024 < 65536 otherwise "the buffer does not fit";
```

If the condition is false the build stops with your reason. If it is true the
demand disappears entirely — there is nothing left to run. Think of it as a
`requires` clause on the program's own assumptions, paid once while building
rather than on every call.

It is a **statement**, like `return` or `throw`, so it lives in a method body and
carries no parentheses of its own. Its condition must be knowable then: one that
does not fold is refused outright, never quietly deferred to runtime.

For the **size of a type**, use a [`layout`](06-oop.md) rather than a demand. A byte
budget is a property of the type, not a condition about the program — and a layout
lets the compiler order the fields to meet it, which is a guarantee rather than a
check. See §10 for how `demand` shares its evaluator with `comptime` and `fixed`.

---

## 8.4 The no-UB principle and failure

Underneath all three tools sits a promise that shapes how Polaron handles the failures
you *didn't* write a handler for: **there is no exploitable undefined behaviour.**
Where C would quietly wander into the undefined — signed overflow, a stray index, a
null dereference — Polaron produces a *deterministic* outcome. Either the operation is
given a defined answer, or the program stops cleanly with a message via a runtime
panic. It never becomes a silent memory-corruption bug an attacker can steer.

These deterministic panics are distinct from exceptions: they are not thrown, not
caught, and not part of the `try`/`catch` machinery. They terminate the program.
They are the language refusing to lie about a computation it cannot honestly
perform.

### Integer overflow

Integer arithmetic has, by default, a **defined two's-complement wrap**. That's the
zero-overhead choice, and because the result is defined it is not undefined
behaviour — an overflowing `int` wraps predictably rather than poisoning the
program. When you want overflow to be an *error* instead, wrap the expression in
`checked(...)`, and signed `+`, `-`, and `*` will trap deterministically on
overflow:

```polaron
int fast = a + b;                 // defined wrap, no overhead
int safe = checked(a * b + c);    // signed overflow here panics deterministically
```

For per-operation control there are explicit methods: `wrappingAdd` /
`wrappingSub` / `wrappingMul` (and `unchecked...` aliases) for guaranteed wrap, and
`saturatingAdd` / `saturatingSub` / `saturatingMul` to clamp to the type's minimum
or maximum instead of wrapping:

```polaron
int clamped = x.saturatingAdd(y);   // pins to the type's max/min instead of wrapping
int wrapped = x.wrappingAdd(y);     // explicit wrap
```

(Unsigned arithmetic and freestanding mode always wrap.)

### Division by zero

Integer division by zero — and the `INT_MIN / -1` overflow corner — do not invoke
undefined behaviour. They panic deterministically with a clear message:

```polaron
int q = a / b;   // if b == 0, the program panics: "integer division by zero or overflow"
```

### Array bounds

Every array index is bounds-checked. An out-of-range access panics rather than
reading or writing past the block:

```polaron
int[] xs = new int[3]();
int bad = xs[7];   // panics: "array index out of bounds"
```

The check is cheap and, where the optimizer can prove an index is in range (a loop
counter over the array's own length, say), it is elided entirely — so the guarantee
costs nothing in the common, provably-safe case.

### Null dereference

Dereferencing a **nullable** reference that happens to be null does not fault into
address zero. The compiler emits a null check on the accesses that actually
dereference, so a null receiver traps deterministically with a message instead of
segfaulting:

```polaron
nullable Dog maybe = this.find(name);
maybe.bark();   // if maybe is null, this traps deterministically, not a wild segfault
```

Non-nullable references pay nothing for this — the check is emitted only where the
type says the value *could* be null. And taking an address (`&x`) does not
dereference, so it is exempt.

### Float-to-int conversion

Converting a floating-point value to an integer is *saturating* and therefore
always defined: a value too large for the target type clamps to that type's
extreme rather than producing a garbage bit pattern.

---

## 8.5 Choosing the right tool

To close, a rule of thumb for a chapter that has offered several overlapping tools:

- **`Result<T, E>` / `Option<T>`** — for expected, recoverable failures that belong
  on the value path, where you want every caller to see and handle the outcome.
  Thread them with `try?`. In **freestanding** code, these are the only structured
  error tools available.
- **Exceptions (`try`/`catch`/`throw`)** — for genuinely exceptional failures that
  should unwind across many frames to a distant handler. Trust `finally`, `defer`,
  `using`, region releases, and mutex unlocks to run during that unwind.
- **Contracts (`requires`/`ensures`/`invariant`)** — for stating and enforcing the
  rules a method assumes and promises; a violation is a bug and stops the program.
  Use `demand` for the assumptions you can settle at compile time.
- **The no-UB guarantee** — you don't reach for this; it is always on. Overflow,
  division by zero, out-of-bounds access, and null dereference are all
  deterministic, so even the failures you never anticipated stop cleanly instead of
  becoming security holes.
