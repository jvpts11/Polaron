# 14. Functions, lambdas & tuples

Methods are Polaron's primary unit of behavior, but they are not the only one. Functions are
*first-class values*: you can store one in a variable, pass it to a method, return it, and
build a closure that captures its surroundings. This chapter covers function values and
their type, lambdas and captures, bound method references, bare C function pointers for
FFI, multiple return values via tuples, and named arguments.

## 14.1 Function values and the `function<>` type

The type of a function value is `function<...>`: the parameter types first, then the return
type **last**. A function taking one `int` and returning an `int` is `function<int, int>`;
one taking nothing and returning nothing is `function<void>`.

```polaron
function<int, int> dbl = ...;     // (int) -> int
function<void> tick = ...;        // () -> void
function<int, boolean, int> f;    // (int, boolean) -> int
```

You call a function value like a method — with parentheses:

```polaron
int a = dbl(5);
```

## 14.2 Lambdas and captures

A **lambda** is a function value written inline. Its shape mirrors a method: a parameter
list, a `returns` type, and a body.

```polaron
function<int, int> dbl = lambda(int x) returns int { return x * 2; };
```

A lambda that references variables from its surroundings must **capture** them explicitly, in
a `[captures: ...]` clause. Captures are `byvalue` (a copy is taken when the lambda is
created) or `byref` (mutations flow back to the original variable):

```polaron
int base = 100;
function<int, int> addBase =
    lambda[captures: byvalue base](int x) returns int { return x + base; };
int b = addBase(7);          // 107 — `base` was copied in

mutable int counter = 0;
function<void> inc =
    lambda[captures: byref counter]() returns void { counter = counter + 1; };
inc(); inc(); inc();         // counter is now 3
```

Explicit captures keep closures honest: a lambda cannot silently reach out and mutate state
you didn't hand it, and `byvalue` vs `byref` says exactly which you meant.

A lambda **body is type-checked like any other body**: names must resolve, `return` must
match the declared type, and the flow analysis runs inside it. The captured variables are
in scope during that check, and the body's own flow facts stay inside it — a `delete x`
within a lambda does not mark the enclosing method's `x` as freed, because the two are
separate flows of control.

## 14.3 Functions as parameters and return values

Because functions are values, a method can take one as a parameter or hand one back — the
basis for callbacks, strategies, and the functional pipeline on collections.

```polaron
public static method twice(function<int, int> f, int v) returns int {
    return f(f(v));
}

// A closure factory: returns a lambda that captures n.
public static method adder(int n) returns function<int, int> {
    return lambda[captures: byvalue n](int x) returns int { return x + n; };
}

int c = Main.twice(dbl, 3);              // dbl(dbl(3)) = 12
function<int, int> add10 = Main.adder(10);
int d = add10(5);                        // 15
```

## 14.4 Method references: `methodref`

`methodref obj.method` captures a *bound* method — the receiver and the method together — as
a `function<>` value. Dispatch stays virtual: if the receiver is statically a base type but
dynamically a subclass, the override runs.

```polaron
Animal cat = new Cat() on heap;          // Cat overrides speak()
function<int, int> sp = methodref cat.speak;
int e = sp(4);                           // runs Cat.speak(4)
```

## 14.5 Bare C function pointers: `funcptr<>`

For dynamic FFI — loading a C entry point at runtime, e.g. `wglGetProcAddress` for modern
OpenGL — Polaron has `funcptr<...>`: a raw C function pointer with no closure environment.
Unlike `function<>`, its type parameters put the **return type first**, then the argument
types (matching how C signatures read):

```polaron
public mutable funcptr<int, int> createShader;             // int  create(int)
public mutable funcptr<void, int, int, long, long> shaderSource;  // void source(int,int,long,long)
```

You call a `funcptr` value like any function; the compiler emits a plain indirect C call.
Use `function<>` for Polaron closures and callbacks; use `funcptr<>` only at the FFI boundary,
where the value really is a bare C pointer.

## 14.6 Multiple return values: tuples

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

## 14.7 Named arguments

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
