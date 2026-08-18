# 10. Compile-Time, Reflection & Universal Prefixes

Most of what you have read so far describes what a Polaron program *does* when it runs. This chapter
is about the two moments that bracket runtime: the work the compiler performs *before* the program
exists, and the questions the program can ask *about itself* while it runs. Between those two poles
sits a small, deliberately chosen vocabulary of **universal prefixes** — six keywords that attach to
almost any declaration or operation and bend its lifetime, its evaluation time, or its optimization
rules.

The through-line of the chapter is *when code executes*. `comptime` moves work to compile time so it
costs nothing at runtime. `reflection` does the opposite, deferring type decisions to runtime.
`lazy` slides an initializer from declaration time to first-use time. `eternal` stretches a lifetime
to the end of the program; `cascade` widens an operation from one object to a whole graph; `volatile`
forbids the optimizer from moving or erasing an access; and `final` freezes something so it can never
change again. Once you see each feature as a decision about *timing*, they stop looking like a grab
bag and start looking like one coherent idea.

A practical note runs through everything below: some of these features are pure compile-time or
zero-runtime machinery and work everywhere, including **freestanding** mode (§11); others lean on the
managed runtime and are therefore rejected in freestanding. The chapter flags which is which at each
step, and §10.6 collects the answers in one place.

---

## 10.1 Compile-time evaluation

Polaron has a real compile-time evaluator. It is not a preprocessor and it is not string substitution:
it interprets a genuine subset of the language — arithmetic, comparisons, locals, loops, recursion,
and calls to other compile-time functions — and folds the result straight into the binary. Anything
it computes has **zero runtime cost**, because by the time the program runs the answer is already a
constant baked into the machine code.

### Named constants with `fixed`

The simplest compile-time value is a named constant. In Polaron a constant is introduced with the
`fixed` keyword (the specification's prose calls this a `const`; the compiler spells the keyword
`fixed`). A `fixed` value must be initialized by a constant expression, and the analyzer evaluates
that expression at compile time.

```polaron
public class Cfg {
    public static fixed int MAX = 100;
    public static fixed int DOUBLED = Cfg.MAX * 2;   // 200, folded at compile time
}
```

A constant may refer to a sibling constant through its owning type (`Cfg.MAX`), and the evaluator
resolves the whole chain before any code is generated. Because the result is a true constant, it can
be used anywhere the language expects a compile-time value — the condition of a `demand`, the count
in a `new T[N]()`, another `fixed`.

> This paragraph used to end *"including as the size of a stack array"*. There are no stack arrays:
> every array in Polaron is heap-allocated and dynamic (§4.5), and nothing in the compiler or the
> samples has ever accepted one. The sentence described a feature that does not exist, which is the
> one kind of error a manual cannot be trusted to catch about itself — it reads exactly like the
> true sentences around it.

### What a type answers about itself

A type can be asked things directly, and every answer is folded into the binary as a constant:

```polaron
int.sizeof()          // 4
Dog.typeName()        // "Dog"
Pace.length()         // how many members a closed family has -- enums only
Point.isValue()       // true: copied where it stands, not reached through a pointer
Dog.owns()            // true: destroying one does work
```

Also available: `align()`, `isMovable()` and `isUnique()`.

**This is not reflection.** Reflection (§10.4) is a runtime service: it costs, and it is unavailable
in freestanding mode. These are facts the compiler is already holding, so asking costs nothing and
works everywhere.

**The point is generic code.** Inside `Box<T>` the parameter *is* the concrete type by the time the
question is answered, so `T` can be asked directly and no constraint has to promise anything:

```polaron
public class Box<T> {
    public method holds() returns String { return T.typeName(); }
    public method frees() returns boolean { return T.owns(); }
}
```

Because each instantiation is checked on its own, a `T` that cannot answer is an error **at that
instantiation**, naming the type that could not — `Pace.length()` is a count, and asking a class or
a primitive for one is refused rather than answered with a zero.

`owns()` is the one to reach for when writing a container. A container of **values** whose element
type has a destructor double-frees: each copy destroys what the original holds. Until this existed
there was no way to ask in advance (§17.1).

### `comptime` locals

Inside a method you can force a local to be computed at compile time by prefixing it with
`comptime`. The initializer runs during compilation, and the variable becomes a constant you can use
in constant contexts — for example, as an array length:

```polaron
comptime int x = 2 + 3 * 4;   // evaluated to 14 during compilation
int[] buf = new int[x]();     // a comptime value is a valid array size
```

### `comptime` methods

A method marked `comptime` runs at compile time whenever it is called with constant arguments. This
is the mechanism behind precomputed lookup tables, perfect hashes, and build-time configuration. The
evaluator handles recursion, iteration, and local mutation — it is a small interpreter, not a peephole
folder:

```polaron
public class Math {
    public static comptime method fib(int n) returns int {
        if (n < 2) { return n; }
        return Math.fib(n - 1) + Math.fib(n - 2);   // recursion at compile time
    }
    public static comptime method factorial(int n) returns int {
        mutable int acc = 1;
        for (mutable int i = 2; i <= n; i++) {       // a loop, at compile time
            acc = acc * i;
        }
        return acc;
    }

    public static fixed int FIB10 = Math.fib(10);        // folds to 55
    public static fixed int FACT5 = Math.factorial(5);   // folds to 120
}
```

The evaluator is numeric over both integers and doubles, so a `comptime` method may mix an integer
loop counter with a floating-point accumulator and return a `double` constant:

```polaron
public static comptime method scale(int n, double factor) returns double {
    mutable double acc = 0.0;
    for (mutable int i = 0; i < n; i++) { acc = acc + factor; }
    return acc;
}
public static fixed double TOTAL = Math.scale(3, 1.5);   // folds to 4.5
```

`comptime` can also be written as a trailing keyword on the method signature, matching the spec's
`§28.3` form; the prefix form shown above is the one used throughout the samples and is preferred for
readability.

### `comptime if`

A `comptime if` chooses its branch at compile time from a constant condition, and — crucially — the
branch that is not taken produces *no code at all*. This is how you compile out debug instrumentation
or select a code path per build without a runtime test:

```polaron
public class Cfg {
    public static fixed boolean DEBUG = false;
    public static fixed int LEVEL = 2;
}

comptime if (Cfg.DEBUG) {
    System.IO.Console.printf("debug on\n");
} else {
    System.IO.Console.printf("debug off\n");   // only this branch is emitted
}
comptime if (Cfg.LEVEL >= 2) {
    System.IO.Console.printf("level high\n");   // and only this one
}
```

### Compile-time string DSLs

Because the evaluator understands string operations too, a `comptime` method can take a
`comptime string` parameter, parse it during compilation, and fold the result to a constant — a
compile-time DSL with no runtime parser. The classic use is validating a query, a regex, or a format
string before the program ever runs. Here a comptime method counts the columns in a CSV header:

```polaron
public static comptime method colCount(comptime string s) returns int {
    mutable int n = 1;
    mutable int i = 0;
    while (i < s.length()) {
        if (s.charAt(i) == ',') { n = n + 1; }
        i = i + 1;
    }
    return n;
}
public static fixed int COLS = Sql.colCount("id,name,email,age");   // folds to 4
```

The argument to a `comptime` parameter must itself be a compile-time constant. Passing a runtime
value is a compile error, which keeps the "no runtime parser" guarantee honest:

```polaron
mutable string r = "hello";
int n = Sql.len(r);   // error: the argument to a comptime parameter must be constant
```

### `demand`

`demand <condition> otherwise "why";` settles a condition while the program is being built. It is a
**statement**, not a call — it stands beside `return`, `delete`, `throw` and `release`, takes no
receiver, returns nothing and emits nothing. It shares the one compile-time evaluator with
`comptime` and `fixed`, so its condition may reference named constants *and* call `comptime`
methods:

```polaron
demand 2 + 2 == 4 otherwise "math is broken";
demand 16 * 1024 < 65536 otherwise "the buffer does not fit";
demand Math.fib(10) == 55 otherwise "fib(10) must be 55";   // calls a comptime method
demand Fruit.count() == 3 otherwise "three fruit are drawn on the labels";   // an enum's size
```

An **enum's `count()`** folds here because an enum is a closed set written out in the source: its
size is settled the moment the declaration is parsed. That is what lets a table numbered across
several enums hold its own arithmetic together — give each family a slice of one index space and
the offset of a family is the size of everything before it, so

```polaron
demand 3 == Fruit.count() otherwise "crates are numbered after the fruit";
```

stops the build when somebody adds a fourth fruit, instead of silently renumbering every crate. A
*class* with a static `count()` of its own is not an enum and stays an ordinary runtime call.

If the condition holds, nothing at all reaches the executable. If it fails, compilation stops:

```
error[Polaron-0806]: demand not met: fib(10) must be 55
```

The `otherwise` text is the **reason**, not a restatement of the condition. The condition already
says `== 55`; the message is there to say why 55 matters, and it is what the failure prints.

A demand belongs in a method body, like any other statement. Its condition must be knowable at build
time — a non-constant condition is refused rather than deferred to runtime, because a check that
silently moves to runtime is a guarantee you have lost without being told.

Use it for the assumptions your code depends on: table lengths, protocol constants, arithmetic that
has to come out a certain way. For **the size of a type**, reach for a [`layout`](06-oop.md) instead —
a byte budget is a property of the type rather than a condition about the program, and a layout lets
the compiler arrange the fields to meet it instead of merely refusing when they do not.

### Guardrails

The compile-time evaluator is bounded. A recursion or step budget protects the compiler from
programs that would otherwise loop forever at build time — an unbounded `comptime` recursion is
rejected with a clear error rather than hanging the compiler:

```polaron
public static comptime method spin(int n) returns int {
    return M.spin(n) + 1;   // unbounded: rejected by the step budget, does not hang the build
}
```

Compile-time evaluation, `fixed`, `comptime`, `comptime if`, and `demand` are all pure
compile-time machinery. They emit no runtime support code, so they are fully available in
**freestanding** mode.

---

## 10.2 Reflection

Reflection is the runtime counterpart to compile-time evaluation: instead of the compiler asking
questions about your program, the *program* asks questions about its own types while it runs. Polaron
exposes this through the `reflect` namespace, and using any of it requires an explicit import:

```polaron
import reflect;
```

Forgetting the import is an error (`reflection requires 'import reflect;'`). Reflection is also the
one feature in this chapter that is **explicitly rejected in freestanding mode** — it depends on
runtime type information, the real `String`, and stdlib collections such as `ArrayList`, none of
which exist in the bare-metal subset. Attempting it there fails with
`reflection is not available in freestanding mode`.

### Type tokens

The entry point is `reflect.typeOf<T>()`, which returns a `Type` token describing a class. From a
`Type` you can read the class name as a real `String`:

```polaron
Type t = reflect.typeOf<Dog>();
System.IO.Console.println(t.name());    // Dog
String n = t.name();
System.IO.Console.printf("len=%d\n", n.length());   // 3
```

### Enumerating members

A `Type` exposes the class's declared methods and fields. You can enumerate them by name through the
count/index pair, or take them as collections:

```polaron
Type t = reflect.typeOf<Dog>();
System.IO.Console.printf("methods=%d fields=%d\n", t.methodCount(), t.fieldCount());
for (mutable int i = 0; i < t.methodCount(); i++) {
    System.IO.Console.println(t.methodName(i));
}
ArrayList<Method> ms = t.methods();   // the collection form
ArrayList<Field>  fs = t.fields();
```

### Reading and writing fields

A `Field` token reads and writes a field on a live object. Values cross the reflection boundary boxed
as `Object` — a reference passes through directly, and a primitive is boxed, so you cast it back on
the way out:

```polaron
Point p = new Point() on heap;
Field f = reflect.typeOf<Point>().fields().get(0);
int before = cast<int>(f.get(p));   // read, unboxing the Object
f.set(p, 99);                        // write it back
int after  = cast<int>(f.get(p));   // 99
```

### Invoking methods and constructing objects

A `Method` token dispatches a call by name (scoped to no-argument methods), and `Type.instantiate()`
allocates an object and runs its no-argument constructor, returning it as `Object`. Together they let
you drive an object known only at runtime:

```polaron
Type t = reflect.typeOf<Dog>();
Dog d = cast<Dog>(t.instantiate());   // dynamic construction via the no-arg ctor
Method m = t.method("bark");
System.IO.Console.println(m.name());  // bark
m.invoke(d);                          // Woof!
t.method("sit").invoke(d);            // chained lookup + invoke
```

### Reflecting over annotations

Both `Type` and `Method` report the annotations applied to them, as an `ArrayList<Annotation>`; each
`Annotation` exposes its `name()`. This is what makes user annotations useful — a framework can
discover them at runtime and act on them:

```polaron
Type t = reflect.typeOf<Widget>();
ArrayList<Annotation> anns = t.annotations();
System.IO.Console.printf("count=%d\n", anns.size());
for (Annotation a in anns) {
    System.IO.Console.println(a.name());   // Marker, Audited
}
```

A `Method` mirrors this with its own `annotations()`, so you can, for instance, find every method
tagged `[Audited]` and wrap it.

---

## 10.3 Annotations

Annotations attach declarative metadata to a class, method, or field without changing what that
declaration *does*. Polaron keeps a sharp line between language concepts and user metadata: built-in
modifiers such as `override`, `final`, `static`, and `volatile` are **keywords**, while everything
else that decorates a declaration is an annotation.

### The two spellings

An annotation may be written either way, and the two are **exactly** equivalent — same meaning, same
parsed result:

```polaron
[Test]                      @Test
[Ignore(reason: "flaky")]   @Ignore(reason: "flaky")
[MaxLength(value: 100)]     @MaxLength(value: 100)
```

This holds for both the annotations the standard library ships and the ones you declare, because
there is no difference between them: a built-in is simply an annotation the stdlib declares. Pick one
spelling and stay with it; this documentation uses `[Name]` throughout.

Arguments are always **named** (`field: value`), never positional, in both spellings.

A compiler **attribute** is a different thing and keeps its own spelling: double brackets, no `@`
form — `[[no_bounds_check]]` (§11). Attributes instruct the compiler; annotations carry metadata.

### Declaring an annotation

You declare an annotation with the `annotation` keyword. Its body lists fields, each of which is
either required or carries a `default`:

```polaron
public annotation MaxLength {
    int value;
    String errorMessage default "too long";   // optional, has a default
}
```

### Applying an annotation

Applications sit on the line above the thing they annotate and pass fields by name. They can decorate
a class, a method, or a field:

```polaron
[MaxLength(value: 100, errorMessage: "name too long")]
public class UserName {
    [MaxLength(value: 50)]
    private mutable int length;

    [Marker]
    public method length() returns int { return this.length; }
}
```

The compiler validates every application: the annotation must exist, each named argument must be a
real field of that annotation, and every required field must be supplied. Once validated, the
annotations ride along on the declaration and become visible to reflection (§10.2).

### `[CompileTimeProcessor]`

`[CompileTimeProcessor]` is a built-in annotation you apply *to another annotation* to mark it for
compile-time processing — the hook by which an annotation can drive code generation during the build
rather than being read back at runtime:

```polaron
[CompileTimeProcessor]
public annotation Marker { }
```

An annotation carrying `[CompileTimeProcessor]` is recognized by the compiler as a build-time
concern; a plain annotation is ordinary runtime metadata discovered through reflection.

---

## 10.4 Lifecycle hooks

Constructors and destructors describe the life of an *instance*. Lifecycle hooks describe the life of
the *class itself* — moments that have nothing to do with any single object. They are written as bare
named blocks in the class body, with no visibility and no parameters:

```polaron
public class Server {
    onClassLoad          { System.IO.Console.printf("Server loaded\n"); }
    onFirstInstance      { System.IO.Console.println("pool setup"); }
    onLastInstanceDestroyed { System.IO.Console.println("pool teardown"); }
    onClassUnload        { System.IO.Console.println("cache unloaded"); }
}
```

Each hook fires at a precise moment:

- **`onClassLoad`** runs once, at program start, *before* `main` — even if the class is never
  instantiated. It is the place for class-level setup that must exist before anyone uses the type.
- **`onFirstInstance`** runs when the count of live instances first leaves zero (0 → 1). It is backed
  by a per-class counter maintained in the constructor, and is ideal for lazily setting up state that
  is shared across all instances.
- **`onLastInstanceDestroyed`** runs when the last instance is destroyed (1 → 0). The counter is
  decremented in the destructor; this is the matching teardown for shared state.
- **`onClassUnload`** runs when the class is `unimport`ed (§ unimport), right before its code is torn
  out of memory. Because unimport belongs to the managed runtime, this hook only fires in managed
  programs.

The counter-based hooks make a common pattern trivial: a connection pool sets up on the first live
object and tears down when the last one dies, without any global flag written by hand.

### `unimport` and `reimport`: hot unloading a class

Polaron's managed runtime can unload a class's *code* at runtime and load it back. This is the
basis for hot-reload and plugin systems.

**`unimport X`** does two things: it marks the class dead, and it physically overwrites its
machine code in memory with trap instructions (`int3`, byte `0xCC`) — the code is really gone,
not just flagged. Any later use of the type — a `new`, or a method call on a surviving
instance — is caught by the alive guard and throws `UnimportedTypeException`, so control never
branches into the destroyed code. `onClassUnload` (above) fires just before the code is torn
out.

```polaron
import System.Runtime.UnimportedTypeException;

unimport Dog;
try {
    a.bark();                       // a survives, but Dog's code is gone
} catch (UnimportedTypeException e) {
    System.IO.Console.println("Dog is unloaded");
}
```

**`reimport X`** brings the code back by reloading the class's original bytes from the
program's own file on disk, after which the type works normally again.

For safe hot-reload you usually want to *verify* that the reloaded code is the version you
expect. The `expecting` challenge–response does this: `unimport X expecting using <inputs> { ... }`
runs a block in the **old** code to produce a validation value, and the matching
`reimport X expecting <value> using <inputs> { ... } onFailure { ... }` runs the block in the
**new** code and compares its result, bit for bit, with the saved value. On a match the program
continues; on a mismatch the `onFailure` block runs instead.

```polaron
int salt = 7;
var proof = unimport Plugin expecting using salt {
    return Plugin.fingerprint(salt);
};

reimport Plugin expecting proof using salt {
    return Plugin.fingerprint(salt);       // new code must reproduce `proof`
} onFailure {
    System.IO.Console.println("rejected: the reloaded code is not the expected version");
};
```

Because unimport/reimport depend on the managed runtime, they are unavailable in freestanding
mode (see [§10.6](#106-availability-in-freestanding-mode)).

---

## 10.5 The universal prefixes

Six keywords are promoted to **universal prefixes**: `cascade`, `eternal`, `lazy`, `comptime`,
`volatile`, and `final`. Each has one consistent meaning that it carries into every context where it
is legal, so they compose into precise intentions without a proliferation of one-off keywords. A
prefix modifies *the thing it precedes* — a declaration, or, for `cascade`/`lazy`/`comptime`, an
operation — and the sections below take them one at a time.

### `cascade` — propagate an operation across an owned graph

`cascade` runs an operation not just on its target but recursively across everything that target
**owns**. The rules are what make it safe: it follows composition (owned value fields and owned
pointers) but skips associations — a pointer marked `external` is treated as a back-reference and is
not followed — it detects cycles with a runtime visited-set so each node is touched exactly once, and
it respects visibility.

The most common form is `cascade delete`, which frees an object and everything reachable through
ownership. A plain `delete` would run only the outermost destructor and leak the rest:

```polaron
Outer o = new Outer() on heap;
cascade delete o;   // runs ~Outer, then ~Mid, then ~Leaf — the whole owned graph
```

This works through *inherited* ownership too: if a value field is declared in a base class,
cascade-deleting a derived object still frees it. Ownership propagates the same way through owned
pointers, and the visited-set makes even a cyclic owned graph free exactly once:

```polaron
Node* a = new Node() on heap;   // a -> b -> c -> a, an owned cycle
// ... link them ...
b.owner = a;                    // an `external` pointer: an association, skipped
cascade delete a;               // ~Node fires once per node, never twice
```

`cascade` generalizes well beyond deletion. `cascade clone X into Y` deep-copies X's entire owned
graph into a fresh graph stored in Y, sharing nothing — mutating the clone leaves the original
untouched. `cascade move t from region old to region fresh` relocates an object and its owned graph
between regions (§ regions), so the graph survives even after the source region is released. And any
plain operation can be cascaded across the graph — `cascade validate(x)` checks each node's
invariant, and `cascade Console.println(x)` describes every node:

```polaron
cascade clone a into c;                          // c is an independent deep copy of a's graph
cascade move t from region old to region fresh;  // t and its Leaf now live in `fresh`
cascade validate(a);                             // check the invariant of every node
cascade Console.println(a);                      // describe every node, once each
```

Optional parameters bound the walk — `cascade(depth: 3) delete tree`,
`cascade(except: {World}) delete player`, `cascade(types: {Item, Pet}) delete inventory`.
`cascade` is a runtime graph walk with no reliance on the managed services, so it works in
**freestanding** — with the single exception of `cascade unimport`, which needs the managed
runtime and is rejected there along with plain `unimport`.

### `eternal` — a lifetime that spans the whole program

`eternal` declares that a resource lives for the entire run of the program. The compiler stops
requiring explicit cleanup, and — importantly — an eternal object's destructor is **not** run at
scope end:

```polaron
public class Res {
    public destructor ~Res() returns void { System.IO.Console.printf("freed\n"); }
    public method use() returns int { return 1; }
}

eternal Res r = new Res() on stack;   // ~Res will NOT run when the scope ends
System.IO.Console.printf("using=%d\n", r.use());
// no "freed" is ever printed
```

This is the right tool for genuinely program-long state — a global cache, a logger, a config table —
where scope-based destruction would be wrong. `eternal` is a lifetime decision the compiler enforces
by *omitting* cleanup code, so it adds no runtime machinery and is available in **freestanding**.

### `lazy` — defer initialization until first access

`lazy` moves an initializer from declaration time to the first time the value is actually read, and
runs it at most once. A `lazy` binding that is never touched is never initialized at all — which is
exactly the point when the initializer is expensive:

```polaron
lazy Thing a = new Thing(1) on heap;   // deferred
lazy Thing b = new Thing(2) on heap;   // never accessed -> never constructed
int x = a.get();   // first access triggers construction of `a` now
int y = a.get();   // already built -> not repeated
```

The same applies to a class **field**: a `lazy` field is built on first access rather than during
construction, so building a `Holder` does not yet build its `Thing`:

```polaron
public class Holder {
    private lazy Thing* thing = new Thing() on heap;   // not built at construction
    public method use() returns int { return this.thing.val(); }   // first call builds it
}
```

`lazy` extends to other resources with the same "on first reference" meaning — `lazy region`,
`lazy import`, and `lazy thread` all defer their heavy step until the resource is first used. The
specification defines lazy initialization as **thread-safe**, guarded by an implicit mutex so two
threads racing on the first access still build exactly once. That thread-safe deferred initialization
is part of the managed runtime, so `lazy` — unlike the other prefixes in this section — is **not**
part of the freestanding subset.

### `comptime` — evaluate at compile time (as a prefix)

Used as a prefix, `comptime` is the same feature described in §10.1: it forces the thing it precedes
to be evaluated during compilation. As a local declaration it produces a compile-time constant
(`comptime int x = 2 + 3 * 4;`); as a method modifier it makes the method run at build time; and as a
statement prefix it drives `comptime if`. Because it is pure compile-time machinery it is fully
available in **freestanding**.

### `volatile` — never reorder, never elide

`volatile` tells the optimizer that an access has meaning beyond its value: it must not be reordered,
duplicated, folded, or removed. Every read performs a real load and every write performs a real
store. This does not change the result of a single-threaded program, but it is essential for
memory-mapped I/O and hardware registers, whose values change outside the program's control:

```polaron
public class Device {
    private volatile mutable int reg;
    public method poke(int v) returns void { this.reg = v; }   // every store really happens
    public method peek() returns int { return this.reg; }      // every load really fetches
}

Device d = new Device() on heap;
d.poke(7);
d.poke(42);   // the first write is NOT folded away, even though it looks dead
```

`volatile` composes onto more than fields. A `volatile method` is emitted `noinline`/`optnone`, so it
is always executed and never optimized away; and a `volatile region` marks every access to objects
placed in it as volatile — the natural way to describe an MMIO window:

```polaron
public class Sensor {
    public volatile method read() returns int { return 42; }   // never inlined or elided
}

volatile region mmio = itself.allocate(4 kilobytes);
Reg* r = new Reg() in region mmio;
r.ctrl = 7;   // a volatile store into mapped memory
```

`volatile` is an instruction to the code generator, not a runtime service, so it is available in
**freestanding** — where, being the language of MMIO, it is most at home.

### `final` — cannot be changed, overridden, or extended

`final` freezes something. On a field or a local it means explicitly immutable — the value is set
once and can never be reassigned (this is the deliberate opposite of `mutable`):

```polaron
public class C {
    private final int x;
    public constructor C() { this.x = 5; }   // set once, in the constructor
}
final int y = c.get();   // an explicitly immutable local
```

On a class, `final` forbids inheritance; on a method, it forbids overriding. Used correctly these
compile like any other declaration; misused, they are hard errors — extending a `final class` or
overriding a `final method` is rejected:

```polaron
public final class Color {
    public final method value() returns int { return this.rgb; }
}
// public class Sub extends Color { ... }   // error: cannot extend a final class
```

`final` also applies to `import` — `final import Dog` declares an import permanent and blocks any
later `unimport`. `final` is a compile-time constraint with no runtime footprint, so it is available
in **freestanding**.

### Composition, canonical order, and invalid combinations

Prefixes combine freely when their meanings are compatible, which is where the "compositional
vocabulary" idea pays off. `eternal lazy region` is a region that lives forever but only allocates
its backing block when the first object enters it; `eternal comptime int` is a constant computed at
build time and kept for the whole program; `volatile comptime int` reads a hardware base address at
compile time yet forbids caching it at runtime.

To keep declarations readable, the compiler enforces a **canonical order** of modifiers:

```
[annotations]
[visibility] [eternal] [lazy] [final] [comptime] [volatile] [cascade] [static] [mutable] ...
```

Writing them out of order (for example `public static eternal lazy int x`) is rejected with a
suggestion to reorder. For operations rather than declarations, only `cascade`, `lazy`, and
`comptime` apply, in that order.

Contradictory combinations are compile errors, because they ask for two incompatible things at once:

- `mutable final` — mutable means reassignable, `final` means it cannot be reassigned.
- `comptime volatile` — computed before runtime, yet allowed to change at runtime.
- `persistent transient` — survives the destructor, yet is not serialized.

The compiler reports each with a message that names the conflict and tells you to keep only one.

---

## 10.6 Availability in freestanding mode

Freestanding mode (§11) drops the managed runtime, so the features in this chapter split cleanly by
whether they need it. The table below is the summary; each rule is enforced by the analyzer.

| Feature | Freestanding? | Why |
|---|---|---|
| `fixed` constants, `comptime` (local / method / `if`), `demand`, `layout` | **Yes** | Pure compile-time; emit no runtime code. |
| `cascade` (delete / clone / move / validate / …) | **Yes** | A self-contained runtime graph walk. |
| `cascade unimport` | No | Unimport is a managed-runtime service. |
| `eternal` | **Yes** | A lifetime decision the compiler enforces by omitting cleanup. |
| `volatile` (field / local / method / region) | **Yes** | A code-generation instruction; the language of MMIO. |
| `final` (field / local / class / method / import) | **Yes** | A compile-time constraint with no runtime footprint. |
| `lazy` (local / field / region / import / thread) | No | Thread-safe deferred init belongs to the managed runtime. |
| Reflection (`reflect.typeOf`, `Type`, `Field`, `Method`, `Annotation`) | No | Explicitly rejected; needs RTTI, `String`, and stdlib collections. |
| Lifecycle hooks | Partial | `onClassLoad`/`onFirstInstance`/`onLastInstanceDestroyed` are ordinary; `onClassUnload` fires only where `unimport` exists (managed). |

The unifying idea is worth repeating: everything that happens *before* runtime, or that costs
*nothing* at runtime, survives into freestanding; everything that leans on managed services —
reflection, thread-safe laziness, unimport — does not. Keep that test in mind and you can predict the
availability of any prefix or feature without consulting the table.
