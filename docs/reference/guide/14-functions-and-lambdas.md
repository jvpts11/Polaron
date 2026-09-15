# 14. Commands, method references & tuples

Methods are Polaron's primary unit of behavior, but they are not the only one. Sometimes a class
needs to hand out behaviour for somebody else to run later — a comparison, a predicate, a handler.
This chapter covers **commands**, which is how that is written; bound method references; bare C code
addresses for FFI; multiple return values via tuples; and named arguments.

## 14.1 Commands

A **command** is the third kind of member, beside `method` and `procedure`. A method is behaviour of
the instance; a procedure is behaviour of the relation between two types; a command is **portable
behaviour** — behaviour written in one place and run in another.

```polaron
public class Gate {
    public command aboveFloor(int x) carries (int floor) into pack returns boolean {
        return x > pack.floor;
    }
}
```

Naming it without calling it **builds** one. `Gate.aboveFloor(10)` is a value that carries
`floor = 10`; the arguments are the `carries` list, not the parameter list, because the parameters
are what the *caller* will supply later. The value is then called by naming it:

```polaron
var over10 = Gate.aboveFloor(10);
boolean yes = over10(11);       // true
boolean no  = over10(3);        // false
```

### What it carries, and why the list exists

`carries (T name, ...) into <pack>` is the command's state. It is copied when the command is built —
ordinary assignment semantics, so a value copies and a `T*` carries the pointer in plain sight — and
it lives under the name `into` gives it. Inside the body it is always reached through that name:

```polaron
public command countClick(Event& e) carries (Counter* stats) into pack returns void {
    pack.stats.increment(e.kind());
}
```

Two things follow, and both are the point of writing it this way:

* **Capture is impossible by grammar.** A name from the surrounding scope that is not on the
  `carries` list is not in scope inside the body. A command cannot quietly reach out and hold
  something you did not hand it, so what one keeps alive is readable from its first line.
* **`this` is never captured implicitly.** If the instance has to travel, it goes on the list like
  anything else (`Kennel.countClick(this.stats)`). A command with no `this` in its baggage provably
  does not hold the instance — a fact the region binder reads off the list rather than inferring.

Omit the clause when there is nothing to carry; the command is then stateless.

```polaron
public command isPositive(int x) returns boolean { return x > 0; }
```

### The role: a command type

An API that takes a command has to say what it will call, and it must be able to say it without
naming any particular command. That is a **command type** — the same word, at namespace level, with
a signature and no body:

```polaron
public command IntTest(int x) returns boolean;                     // the role

public static method count(int[] xs, IntTest* test) returns int {
    mutable int n = 0;
    for (mutable int i = 0; i < xs.length(); i = i + 1) {
        if (test(xs[i])) { n = n + 1; }
    }
    return n;
}
```

Conformance is **structural**: a command satisfies a role when the signatures agree. `Gate` never
heard of `IntTest`, `count` never heard of `aboveFloor`, and `Gate.count(xs, Gate.aboveFloor(10))`
works because the two signatures are the same shape. A command may satisfy several roles at once.

A command type is a role, not a form, so it never says what a command *holds*: the baggage differs
between commands playing the same role, and writing it on the role would demand they all carry the
same things.

### The inline form

Where the command is used once, right where it is written, it can be written there:

```polaron
int floor = 6;
int over = Gate.count(xs, command (int x) carries (int limit = floor) into pack returns boolean {
    return x > pack.limit;
});
```

The carried values are given **on the line**, because the inline form is written at the use and there
is no other place they could come from. (The declared form separates them — `carries (int floor)` at
the command, `Gate.aboveFloor(10)` at the use — precisely because there the two are in different
files, methods and minds.)

An inline command is lifted onto the class the expression is written in, so it is the same construct
as the declared one and not a second thing: the same rule that refuses a loose method applies, which
is why an inline command outside any class is an error rather than a free function in disguise.

## 14.2 The roles the standard library names

Most APIs do not want a command type of their own; they want the shape everybody means. Those live
in `System.Commands`, and a command satisfies them structurally like any other role:

| Role | Shape | Where it shows up |
|------|-------|-------------------|
| `Action` | `() -> void` | a thread's work, a test body, a notification handler |
| `Action1<T>` / `Action2<A, B>` | `(T) -> void`, `(A, B) -> void` | `forEach`, an event subscription, a chunked parallel loop |
| `Predicate<T>` | `(T) -> boolean` | `filter`, `any`, `all`, `count`, `find` |
| `Mapper<T, R>` | `(T) -> R` | `map`, and a request handler |
| `Comparer<T>` | `(T, T) -> int` | every sort and search in the library |
| `Folder<R, T>` | `(R, T) -> R` | `reduce`, `fold`, a map's `merge` |
| `Combiner<A, B, R>` / `Combiner3<A, B, C, R>` | `(A, B) -> R`, `(A, B, C) -> R` | the general two- and three-input shapes |

They overlap on purpose. A `(Dog*) -> boolean` command is a `Predicate<Dog*>` and also a
`Mapper<Dog*, boolean>`, and neither role has to know about the other — which is what lets each stay
named for what it MEANS at the call site rather than for its arity.

```polaron
import System.Commands.Comparer;

nums.sort(command (int a, int b) returns int { return a - b; });
```

## 14.3 What went away, and what to write instead

`lambda`, `function<...>` and the `[captures: ...]` clause are not part of the language. A lambda's
capture list could be left out entirely, and then what the value held was decided by its body and
stated nowhere; `function<Ret, Params...>` named a shape and no role, so an API taking one could not
say what it wanted beyond the arrow.

| Was | Is |
|-----|-----|
| `function<boolean, Dog*> p` | `Predicate<Dog*>* p`, or a command type you name |
| `lambda(int x) returns int { ... }` | `command (int x) returns int { ... }` |
| `lambda[captures: byvalue n](...)` | `command (...) carries (int n = n) into pack ...`, reading `pack.n` |
| `lambda[captures: move chunk](...)` | `carries (Chunk* mine = move chunk) into pack` |
| `lambda[captures: byref counter](...)` | nothing — baggage is copied; share an `atomic<T>` or a `Mutex<T>` |

The last row is a deliberate loss. A command that shared a caller's local could not outlive the frame
it was written in, which is the one thing a command is for.

## 14.5 Method references: `methodref`

`methodref obj.method` binds a receiver to a method — which is a command carrying one thing, and is
compiled as exactly that. Dispatch stays virtual: if the receiver is statically a base type but
dynamically a subclass, the override runs, because the call inside the binding is an ordinary call on
an ordinary pointer.

```polaron
Animal cat = new Cat() on heap;          // Cat overrides speak()
IntMap* sp = methodref cat.speak;        // any role of the right shape
int e = sp(4);                           // runs Cat.speak(4)
```

It binds an **instance** method only: a static one belongs to the class and has no receiver to bind,
so its address is `Class.method` — a `methodptr`, below.

## 14.6 A code address: `methodptr<>`

A **`methodptr<Ret, Params…>`** is the address of code: one machine word, no environment, the plain
C ABI, and a typed signature. It is what an entry point loaded at run time is (`wglGetProcAddress`
for modern OpenGL, `GetProcAddress`), what a driver's dispatch slot holds, and what a registry stores
against a bare pointer when the things it names belong to many different classes.

Its type parameters put the **return type first**, then the argument types, matching how a C
signature reads:

```polaron
public mutable methodptr<int, int> createShader;                    // int  create(int)
public mutable methodptr<void, int, int, long, long> shaderSource;  // void source(int,int,long,long)
```

`Class.method` without a call is that method's address, which is where one comes from without a
foreign symbol. Only a **static** method: an instance method's receiver is not named by that
expression, and a pointer to one without it is a `this` nobody supplied.

```polaron
methodptr<int, int> twice = Maths.twice;
twice(21);                                  // 42 -- a plain indirect call, with nothing in front
```

It completes the customs post, and the pair is the point: **`address`** is the address of *data*,
blind to shape and to guarantees; **`methodptr`** is the address of *code*, blind to guarantees and
sighted as to shape. Use a `command` for Polaron behaviour, which carries state and is an object; use
`methodptr<>` where the value really is a bare address — a C callback, a driver's dispatch slot, an
entry point resolved at run time.

> The type was spelled `funcptr`. It is gone from the grammar: in Polaron there are methods,
> procedures and commands, and the word "function" does not survive at the border either.

## 14.7 Multiple return values: tuples

A method can return several values at once by declaring a **tuple** return type — a
parenthesized list of types — and returning a parenthesized list of values:

```polaron
public static method divmod(int a, int b) returns (int, int) {
    return (a / b, a % b);
}
```

The caller **destructures** the result into fresh locals:

```polaron
(int q, int r) = MathX.divmod(17, 5);    // q = 3, r = 2
```

Tuple components may be named for documentation; the names don't change how the tuple is
used:

```polaron
public static method bounds() returns (int low, int high) {
    return (3, 9);
}
(int lo, int hi) = MathX.bounds();
```

Tuples are also ordinary values — you can build one from a literal and destructure it:

```polaron
(int x, int y) = (lo + 1, hi + 1);
```

## 14.8 Named arguments

At a call site, an argument may be passed **by name** with `name: value`, which documents
intent and frees you from remembering positional order:

```polaron
validate(value: 100, errorMessage: "name too long");
```

A parameter can be *required* to be passed by name by prefixing its declaration with
`requires named` (spec 22.4), so callers can never pass it positionally — useful for boolean
flags and other arguments whose meaning isn't obvious from position alone:

```polaron
public static method spawn(requires named boolean detached) returns void { /* ... */ }
// Main.spawn(true);            // error: 'detached' must be passed by name
Main.spawn(detached: true);     // ok
```
