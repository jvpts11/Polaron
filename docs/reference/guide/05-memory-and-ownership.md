# 5. Memory & Ownership

This is the chapter where LDP3 stops looking like a friendly object-oriented language
and starts showing its real personality. LDP3 is a systems language: it compiles
straight to native code, it has **no garbage collector**, and it never stops the world
to sweep your heap behind your back. Every byte your program uses has a birth and a
death that you can point to in the source. That is the whole bargain — you trade the
convenience of a GC for **determinism**: you always know *when* memory is reclaimed,
*where* an object lives, and *who* is responsible for it.

The surprising part is that this bargain does not feel dangerous in day-to-day code.
LDP3 achieves that with three ideas working together, and this chapter is the story of
how they fit:

1. **Value semantics as the default.** Assignment copies. A variable *is* its object,
   not a handle to one somewhere else. Two variables never accidentally alias the same
   thing, so a mutation over here can never spookily change a value over there.
2. **RAII and scoped cleanup.** Objects clean themselves up when their scope ends —
   automatically, deterministically, and even when an exception is unwinding through
   the frame. You rarely write cleanup code by hand.
3. **Compile-time ownership when you need it.** When a resource genuinely must have a
   single owner (a file handle, a socket, a mutex guard), you say so in the type, and
   the compiler proves at *compile time* that the rule holds — with zero runtime cost.

And when the safe defaults get in the way — when you want a bump allocator, a
memory-mapped hardware register, or state that outlives the object that created it —
LDP3 hands you the sharp tools: pointers, regions, and persistents. The design
principle throughout is *no ceremony in the common case, a cannon when you need one*.

Let's build the model from the ground up.

---

## 5.1 Value semantics: assignment is a deep copy

In LDP3, **assignment copies the whole value**, and for a class instance that means a
**deep copy**. This is the single most important sentence in the chapter, so let's sit
with it. When you write `b = a` and both are class-typed, `b` becomes a brand-new,
fully independent object with the same contents as `a`. Mutating `b` afterward cannot
touch `a`, because there is no shared storage between them.

```ldp3
import System.IO.Console;
program ValueCopy;

public bundle main {
    public namespace app {
        public class Point {
            public mutable int x;
            public constructor Point(int x) { this.x = x; }
        }

        public class Main {
            public static method main(string[] args) returns void {
                Point a = new Point(1) on stack;
                Point b = a;        // deep copy -- b is a separate object
                b.x = 99;           // mutates only b
                System.IO.Console.println($"a={a.x} b={b.x}");   // a=1 b=99
                return;
            }
        }
    }
}
```

The copy is *deep*, not shallow. If a class owns an array or a nested value object, that
storage is duplicated too, so the two objects share nothing at all:

```ldp3
public class Bag {
    public mutable int[] items;
    public constructor Bag() {
        this.items = new int[3]();
        this.items[0] = 10;
    }
    public method set(int i, int v) returns void { this.items[i] = v; }
    public method get(int i) returns int { return this.items[i]; }
}

// inside main:
Bag a = new Bag();
Bag b = a;            // the backing array is duplicated, not aliased
b.set(0, 999);        // mutate only b's array
System.IO.Console.println($"a[0]={a.get(0)} b[0]={b.get(0)}");   // a[0]=10 b[0]=999
```

Under the hood the compiler copies the object's bytes, then walks each field that *owns*
its storage — arrays and nested value sub-objects — and duplicates those recursively.
Primitive fields copy inline; the two `Bag`s end up with two completely separate `items`
arrays.

**Why default to copying?** Because aliasing is the source of an enormous class of bugs,
and a value default eliminates them by construction. In a reference-by-default language
(Java, Python, C#), `b = a` makes `b` point at *the same* object, and now a write through
either name is visible through both — often at a distance, often surprising. LDP3 flips
the default: sharing is the thing you must ask for explicitly, so when you *see* sharing
in the source you know it is intentional. It also composes cleanly with manual memory:
if every variable owns its own object, "who frees this?" almost always has the obvious
answer — the scope that declared it.

**Parameter passing follows the same rule: by value.** A class-typed parameter receives
an independent deep copy, exactly like assignment. Mutating the parameter inside the
method does **not** affect the caller's object.

```ldp3
public static method tryToChange(Point p) returns void {
    p.x = 500;                 // mutates the local copy only
}
// caller:
Point a = new Point(1);
Main.tryToChange(a);
System.IO.Console.println($"{a.x}");   // still 1
```

This is safe and predictable, but copying a large object on every call is wasteful, and
sometimes you genuinely *want* the callee to see the caller's object. That is what
pointers and references are for — the subject of the next section.

> One consequence worth internalizing: abstract classes and interfaces are always handled
> by reference, because the concrete subclass behind them has a size the compiler cannot
> know statically. `String`, being immutable, is shared freely — copying an immutable value
> is pointless, and it can never surprise you.

---

## 5.2 Sharing on purpose: pointers (`T*`) and references (`T&`)

When you want two names to see and mutate **the same** instance, you opt out of value
semantics with a pointer (`T*`) or a reference (`T&`). Both share the underlying object;
they differ in ergonomics and intent.

A **pointer** `T*` holds the address of an object. You take an address with the `&`
operator, and — this is a small but important convenience — you access members through a
pointer with the ordinary dot (`.`), not a separate arrow operator:

```ldp3
Point a = new Point(1) on stack;
Point b = a;        // deep copy -- independent
Point* p = &a;      // p shares a's instance
p.x = 7;            // writes through to a
System.IO.Console.println($"a={a.x} b={b.x}");   // a=7 b=99
```

Here `b` was copied and stayed at `99`, while writing through `p` changed `a` to `7`,
because `p` is not a copy — it is a second name for the very same object.

A **reference** `T&` is a bound alias: it is tied to one object when it is created and
stands in for that object from then on. Use a reference when "this is just another name
for that object" is the whole story; use a pointer when you need an address you can pass
around, store, rebind, or compare with `null`.

```ldp3
Point a = new Point(1);
Point* p = &a;   // an address: rebindable, can be null, supports & and pointer ops
Point& r = a;    // an alias: bound to a, use it exactly like a
```

For passing large objects into a method without paying for the deep copy, declare the
parameter as a reference (or pointer). Now the method sees the caller's object and can
mutate it:

```ldp3
public static method bump(Point& p) returns void {
    p.x = p.x + 1;     // mutates the caller's object
}
```

Pointer arithmetic (`p++`) is permitted on any pointer, but the compiler warns on class
pointers, because advancing a pointer into the middle of an object rarely means anything
and can corrupt memory. The safe, idiomatic use of `T*` is *sharing*, not walking.

### Pointers to pointers: `T**`, `T***`, and the `*` operator

A pointer is itself a value with an address, so you can take a pointer *to* a pointer, to
any depth: `T**` is a pointer-to-pointer, `T***` a triple pointer, and so on. Each `&`
adds a level and the prefix **`*`** operator peels one off — `*pp` on a `T**` yields the
`T*`, and `**pp` reaches the underlying `T`. This is the classic tool for an
*out-parameter* (a method that rebinds the caller's pointer) and for pointer-based data
structures:

```ldp3
mutable int x = 5;
int* p = &x;          // p -> x
int** pp = &p;        // pp -> p
int*** ppp = &pp;     // and so on, to any depth

int v = ***ppp;       // 5 -- read through three levels
**pp = 99;            // write through two levels: x is now 99

// An out-parameter rebinds the caller's pointer through a T**:
public static method rebind(int** slot, int* target) returns void {
    *slot = target;   // *slot as an lvalue: store through the pointer
}
```

The one restriction: a pointer to a *generic* type may be only one level deep (`Box<int>*`
is fine, `Box<int>**` is not), because a generic's internal name can itself end in `*` and
a second one would be ambiguous. Every non-generic type — primitives, classes, structs —
supports pointers to any depth. `T&` references, by contrast, are always a single level: a
reference is a bound alias, not an address you build towers of.

The mental model to carry forward: **value by default, share by exception.** A plain
variable is an object; a `T*`/`T&` is a way to reach into someone else's object. When
you read LDP3 and see a `*` or `&`, that is the code announcing "sharing happens here."

---

## 5.3 Where objects live: stack vs heap

Every allocation answers a question: *where does this live, and when does it die?* LDP3
makes you name the answer with `new ... on stack` or `new ... on heap` — but only when
the default is not what you want.

- **`on stack`** places the object in the current frame. It is reclaimed automatically
  when the enclosing scope ends. No `delete`, no bookkeeping — the object simply ceases
  to exist at the closing brace (running its destructor on the way out; see §5.5).
- **`on heap`** allocates from the heap and hands you ownership of a long-lived object.
  Heap objects are **not** reclaimed automatically — you must `delete` them.

```ldp3
Dog rex = new Dog("Rex", 5) on stack;      // dies at end of scope
Dog* big = new Dog("Big", 10) on heap;     // lives until you delete it
delete big;                                 // reclaim the heap object
delete big from heap;                       // the explicit, unambiguous form
```

**The placement is optional — no ceremony in the common case.** When you omit it, the
compiler picks the sensible default: **objects go on the stack** (RAII, freed
automatically), and **arrays and dynamic collections go on the heap** (they are naturally
dynamic). You write the placement explicitly only to force something other than the
default, or when the type itself demands the heap (a `T*` you intend to return, an object
that must outlive its scope).

```ldp3
Dog rex = new Dog("Rex", 5);            // no ceremony -> stack (RAII)
Dog* big = new Dog("Big", 10) on heap;  // the "cannon": manual heap, needs delete
int[] scores = new int[16]();           // arrays default to the heap
```

The design intent is a smooth gradient: reach for a stack object and forget about it in
the easy 90% of code; drop down to explicit `on heap` + `delete` exactly when a value has
to outlive the scope that made it. Both live in the same language, one keystroke apart.

---

## 5.4 No undefined behavior: dangling, double-free, and the trap

Manual memory has a reputation for foot-guns: use-after-free, double-free, dangling
pointers. In C and C++ these are *undefined behavior* — the program might crash, might
silently corrupt data, might appear to work until it doesn't. LDP3 takes a firm position
here, the **no-UB principle**: a memory mistake must **fail deterministically**, never
silently corrupt.

Consider a double-`delete`:

```ldp3
Dog* d = new Dog("Rex", 5) on heap;
delete d;
delete d;   // deterministic panic, not silent corruption
```

The second `delete` does not quietly free a recycled block and march on. Before running
the destructor, the compiler emits a liveness check (`__ldp3_check_live`) against the
allocator: if the block has already been freed, the program panics immediately with a
clear message. A live pointer, or a pointer the allocator doesn't own, passes through
untouched. The same guard covers `delete` of an already-released object. You still bear
the responsibility of freeing heap objects once, but freeing *twice* turns a lurking
corruption bug into a loud, reproducible crash at the exact offending line.

Other memory hazards are handled in the same spirit elsewhere in the language:
dereferencing a `nullable` that happens to be null traps deterministically rather than
segfaulting; out-of-bounds array indexing traps at the access; integer overflow can be
made to trap under `checked(...)`. The unifying rule is that LDP3 would rather stop your
program with a precise diagnostic than let it wander into corrupted state.

The best defense, though, is to not manage memory by hand at all where you don't have to —
which is exactly what the next three sections are about.

---

## 5.5 RAII: destructors and automatic cleanup

RAII — *Resource Acquisition Is Initialization* — is the backbone of LDP3's memory
determinism. The idea: tie a resource's lifetime to an object's lifetime, so that
cleanup is automatic and happens at a well-defined moment. In LDP3 that moment is
**scope exit**, and the mechanism is the **destructor**.

A destructor is written `~ClassName` and runs when the object's lifetime ends:

```ldp3
public class Board {
    private mutable char[] cells;
    public constructor Board() { this.cells = new char[9](); }
    public destructor ~Board() returns void {
        delete this.cells;      // release the array this object owns
    }
}
```

For a **stack object**, the destructor runs automatically at the end of the block that
declared it. You do not call it; you cannot forget it:

```ldp3
public method play() returns void {
    Board board = new Board();      // on the stack by default
    board.place(0, 'X');
    return;                          // ~Board() runs here, freeing cells
}
```

Destructors run in **reverse order of construction** (last built, first destroyed), which
is what you want: a later object may depend on an earlier one, so it must be torn down
first. When one class extends another, the derived destructor runs first, then the base —
inner-to-outer, always deterministic.

Crucially, **cleanup also runs on exception unwind**. If an exception is thrown and
propagates out through a frame, every live stack object in that frame still has its
destructor run as the stack unwinds. There is no path — normal `return` or exceptional
throw — where a stack object silently skips its cleanup. This is what makes RAII
trustworthy rather than merely convenient: the guarantee holds precisely in the moments
(errors, early exits) when hand-written cleanup is most likely to be forgotten.

Heap objects are the exception to automatic cleanup — their destructor runs when *you*
`delete` them, because their whole point is to outlive the current scope. RAII plus
`delete` is the two-speed system again: stack objects clean themselves; heap objects
clean up on command.

---

## 5.6 `defer` and `using`: cleanup that can't be skipped

Sometimes the resource you need to release is not neatly wrapped in a stack object — it's
a heap allocation, a lock, an open handle — and you want to guarantee its cleanup runs no
matter how the block exits. LDP3 gives you two scoped tools for that, and both share
RAII's iron guarantee: **they run on normal exit and on exception unwind alike.**

**`defer`** schedules a block to run when the enclosing scope ends:

```ldp3
public method processFile(String path) returns void {
    File f = new File(path) on heap;
    defer { delete f; }        // runs at scope exit, even if read() throws
    f.read();
}
```

The deferred block runs whether the method returns normally or an exception tears through
it. You put the cleanup right next to the acquisition, so you can never lose track of it
across a long method with many exit points.

Multiple `defer`s run in **LIFO order** — last deferred, first run — mirroring
destructor order, so nested resources unwind in the correct sequence:

```ldp3
defer { System.IO.Console.println("deferred 1"); }
defer { System.IO.Console.println("deferred 2"); }
System.IO.Console.println("body");
// prints: body, then "deferred 2", then "deferred 1"
```

**`using`** is sugar for a resource with a well-defined scope. It declares the resource,
runs the block, and disposes the resource at the closing brace — running its destructor
and, for a heap resource, freeing it:

```ldp3
using (Resource r = new Resource(3) on heap) {
    System.IO.Console.println("inside using");
}   // r is disposed here: ~Resource() runs, then the heap block is freed
```

If you explicitly `delete r` inside the block, `using` notices and does not double-dispose
it. Like everything else in this section, `using` disposal fires on the exception path
too, so a throw inside the block still releases the resource before unwinding onward.

The three mechanisms — destructors, `defer`, `using` — are one idea seen from three angles:
*cleanup is attached to a scope, ordered LIFO, and guaranteed on every exit.* Together
they mean that in idiomatic LDP3 you write very little explicit cleanup, and the cleanup
you do write cannot be skipped.

---

## 5.7 Regions: arena allocation

Individual `new`/`delete` is precise but has a cost, and sometimes it's the wrong shape
for the problem. When you're about to allocate *thousands* of small objects that all die
at the same time — a parse tree, a frame of a simulation, every entity in a level — you
don't want thousands of separate frees. You want to allocate them all in one arena and
throw the arena away in a single stroke. That's a **region**.

`region` is a primitive type in LDP3, on the same footing as `int` or `boolean`. A region
owns a slab of memory and hands out pieces of it with a trivial *bump* — advance a pointer,
that's the whole allocation. You create one with the `itself` self-reference and an
amount expressed in real units:

```ldp3
import System.Memory.Units.kilobytes;

region pen = itself.allocate(1 kilobytes);
Dog* a = new Dog(5) in region pen;      // bump-allocated inside pen
System.IO.Console.println($"a = {a.getAge()}");
// pen is freed automatically at end of scope (region RAII)
```

`itself` is a pronoun that, inside a declaration's initializer, refers to the variable
being declared — so `itself.allocate(...)` reads naturally without repeating the name.
The `1 kilobytes` is not a bare integer: the `kilobytes` suffix (a compile-time `literal`
function from `System.Memory.Units`) produces a `ByteSize`, a distinct type, so you can't
accidentally hand a region a raw `int` meant for something else.

Objects placed with `new T() in region r` do **not** get individually freed. The whole
region is released at once — either automatically when its scope ends (region RAII, the
same discipline as stack objects), or explicitly:

```ldp3
release region pen;   // frees the whole arena at once; destructors of its objects run
```

When a region is released, every object still living in it has its destructor run, then
the entire slab goes back in one operation. That is the performance rationale in a
sentence: **you pay for allocation once per region, not once per object.** The bump
allocation itself is nearly free; the runtime even caches a released slab per thread so a
hot `allocate ... release` loop reuses the block instead of round-tripping a multi-megabyte
request through the OS every iteration.

Regions can also enforce **what may live in them**, via `accepts` and `rejects` — chained
onto the allocation and validated by the type system:

```ldp3
region pen = itself.allocate(1 kilobytes).accepts({Dog});
Dog* d = new Dog(42) in region pen;     // OK: Dog is accepted
// putting a Cat in `pen` is a compile error (and a runtime exception if only known dynamically)

region io = itself.allocate(8 kilobytes).rejects({String});
```

A region can be a **class field**, so an object owns its own arena for the objects it
manages:

```ldp3
public class Pool {
    public region arena;
    public constructor Pool() { this.arena = itself.allocate(1 kilobytes); }
    public method makeDog(int n) returns Dog* {
        return new Dog(n) in region this.arena;   // allocate into the field's region
    }
}
```

Finally, a region can sit over a **fixed physical address** with `itself.at(addr, size)`.
This is the basis for memory-mapped I/O in freestanding code — a VGA text buffer, a
device register — where objects must live at an address the hardware dictates. Releasing
such a region frees only its small header; it never touches the fixed memory itself.

```ldp3
import System.Memory.Units.bytes;

region hw = itself.at(0xB8000, 4000 bytes).accepts({VGAChar});
// objects placed in `hw` land at the hardware address; ideal for MMIO
```

Regions are LDP3's answer to "GC-like ergonomics without a GC": batch the lifetime, and a
whole graph of objects becomes as cheap to reclaim as a single free.

### 5.7.1 Region flavors

The plain `region` above is a **bump** allocator: allocation just advances a cursor, and
nothing is reclaimed piecemeal — the whole slab goes back at once. That is the right shape
for "everything dies together," but not every arena has that shape. LDP3 lets you pick the
allocator's *flavor* by writing a soft keyword **before** `region`:

```ldp3
region a = itself.allocate(64 kilobytes);              // bump (the default)
pool region b = itself.allocate(64 kilobytes);         // free-list
stack region c = itself.allocate(64 kilobytes);        // mark / rollback (LIFO)
fixedslot region d = itself.allocate(64 kilobytes).accepts({Dog});  // one fixed-size type
ring region e = itself.allocate(96 bytes).accepts({Log});           // circular, auto-evicting
```

- **bump** (default) — advance a pointer; the cheapest possible allocation. Reclaimed only
  when the whole region is released. Best when the objects share one lifetime.
- **pool** — a free list. `delete x from region r` runs `x`'s destructor and returns its
  slot to the free list, so a pool sustains an endless churn of allocate/delete without the
  region growing. (See "Reclaiming one object" below.)
- **stack** — LIFO reclamation with explicit marks: allocate, then rewind the cursor to an
  earlier point to free everything allocated since, all at once.
- **fixedslot** — a pool specialized to a *single* type, so every slot is the same size and
  both allocation and free are O(1) index math. It **requires** `.accepts({T})` naming that
  one type; without it the compiler reports an error.
- **ring** — a fixed circle of slots. When it fills, the *oldest* live object is evicted
  (its destructor runs) to make room for the new one — a bounded "most recent N" buffer.
  You never `delete` from a ring; it evicts on its own.

A region carries exactly one flavor — writing two (`pool stack region ...`) is an error, and
a flavor keyword only qualifies a `region` (`pool int x` is an error).

**`growable`.** Any flavor except `ring` can be made `growable`, which chains a fresh block
when the current one fills instead of failing the allocation (a ring is inherently bounded,
so `growable ring` is rejected):

```ldp3
growable pool region g = itself.allocate(256 bytes);   // grows in 256-byte blocks as needed
```

Flavors work on **region fields**, too — the pattern behind Forge's terminal pool, where a
long-lived object churns short-lived ones through its own free list:

```ldp3
public class Kennel {
    private pool region den;
    public constructor Kennel() { this.den = itself.allocate(4 kilobytes); }
    public method adopt(int n) returns void {
        Dog* d = new Dog(n) in region this.den;
        // ... use d ...
        delete d from region this.den;   // reclaims the slot for the next dog
    }
}
```

#### Reclaiming one object

- **`delete x from region r`** — on a **pool** or **fixedslot** region, runs `x`'s destructor
  and returns its slot to the free list for reuse. On a bump region it runs the destructor
  and marks the slot dead, but the space is not reclaimed (bump has no free list). On a ring
  it is an error — rings evict automatically.
- **`extract x from region r`** — moves `x` *out* of the region onto the heap (a deep
  relocation) and returns the new heap pointer, which you must bind:

  ```ldp3
  pool region kennel = itself.allocate(2 kilobytes);
  Dog* d = new Dog(7) in region kennel;
  Dog* out = extract d from region kennel;   // relocate to the heap; the kennel slot is reclaimed
  // `d` is now moved-from; use `out`. Delete `out` yourself later.
  ```

  Extract is how you let a single object *survive* an arena that is about to go away. The
  compiler rejects an extract whose object still holds a pointer into the same region (that
  pointer would dangle after the move), and rejects a bare `extract` whose result isn't bound.

#### Marks and rollback (stack regions)

A `stack` region reclaims in LIFO order. Take a **`checkpoint`** with `mark`, allocate scratch,
then `rollback` to that checkpoint to free everything since — destructors run in reverse:

```ldp3
stack region tmp = itself.allocate(1 megabytes);
checkpoint m = mark of region tmp;   // remember the cursor
Node* scratch = new Node(1) in region tmp;
// ... build a throwaway working set ...
rollback region tmp to m;            // reclaim everything allocated since m
```

`checkpoint` is a built-in cursor type. `mark` requires a stack region, and a checkpoint may
only be rolled back on the region it came from — mixing them is a compile error. Marks nest,
so a hot loop can `mark` / build / `rollback` each iteration and reuse the same memory every
time.

---

## 5.8 Ownership disciplines: `movable`, `unique`, `partitionable`

Value semantics is a fine default, but some things must **not** be copied. A file handle,
a socket, a mutex guard, a GPU buffer — duplicating one of these is either meaningless or
actively dangerous (two owners closing the same file). For these, LDP3 lets you declare an
**ownership discipline** on the class itself, and then proves the rules at *compile time*.
The discipline is part of the type's contract: anyone using your class learns the rules by
reading its declaration, not its documentation.

There are three disciplines, declared as a prefix before `class`:

**Default (no prefix) — copy semantics.** Everything in §5.1. Assignment copies; multiple
independent instances coexist. This is what you've used so far.

**`movable` — transfer, don't copy.** A `movable` class forbids the silent deep copy.
Ownership moves from one variable to another with the explicit `move` keyword, and the
source variable is *invalidated* by the move — the compiler tracks it and rejects any
later use:

```ldp3
public movable class Connection {
    public mutable int id;
    public constructor Connection(int id) { this.id = id; }
}

Connection c1 = new Connection(1) on heap;
Connection c2 = move c1;    // ownership transfers to c2; c1 is now "moved"
// c1.id;                   // COMPILE ERROR: 'c1' used after it was moved
```

A plain `Connection c2 = c1;` (no `move`) is a compile error for a movable type — the
whole point is that transfer must be visible in the source. A moved-from variable is not
garbage you must tiptoe around; it is simply *empty*, and you can bring it back to life by
reassigning it:

```ldp3
mutable Connection c = new Connection(1) on heap;
for (int i in 0..10) {
    consume(move c);                    // c is moved out...
    c = new Connection(i) on heap;      // ...and reassigned: valid again
}
```

**`unique` — one live owner, ever.** A `unique` class guarantees that at any instant only
one variable in the whole program references the object. Every assignment is an implicit
move (the `move` keyword is optional but recommended for clarity), and passing a `unique`
value by value to two places, or storing it in a container that would duplicate it, is
rejected at compile time.

```ldp3
public unique class FileHandle {
    public constructor FileHandle(string path) { /* open */ }
}

FileHandle f1 = new FileHandle("data.txt") on heap;
FileHandle f2 = f1;   // implicit move; f1 is now invalid (== move f1)
```

**`partitionable` — opt in to moving fields out one at a time.** By default you cannot
move a single field out of an object, because that would leave the parent in a half-built
state. A `partitionable` class permits it for its `movable`/`unique` fields; the compiler
then tracks each field's state independently:

```ldp3
public partitionable class Connection {
    public movable Socket socket;
    public mutable Config config;
}

Connection c1 = new Connection() on heap;
Socket s = move c1.socket;   // OK because Connection is partitionable
// c1.socket is now moved-out and inaccessible until reassigned
// c1.config is still fully valid
c1.socket = new Socket() on heap;   // reactivate the field
```

`unique` and `partitionable` are contradictory — partitioning hands out independent
references to pieces of an object, which breaks the single-owner guarantee — so the
compiler rejects that combination outright.

**The flow analysis behind all this is the key to why it's free.** The compiler assigns
every `movable`/`unique` variable one of three states — *valid*, *moved*, or
*uninitialized* — and tracks how that state flows through assignments, moves, branches,
and loops. Using a *moved* variable is a compile error with the exact line of the move in
the message. And because the compiler knows which variables are *valid* at each scope
exit, it runs destructors **only** on those — a moved-from variable's destructor does not
run, so ownership transfer never causes a double-free. All of this happens during
compilation and produces no runtime checks, no reference counts, no hidden flags:
**ownership safety is zero-cost.** Contrast C++, where `std::move` is a cast that doesn't
actually move anything and leaves the source "valid but unspecified" — a fertile source of
silent bugs. LDP3 makes the state real and checks it.

`move` is a small family of operations, not just variable-to-variable transfer. It also
moves objects **between regions** without logically reallocating them:

```ldp3
Car* c2 = move c1 from region staging to region production carrying persistents;
// c1's object now lives in production; staging can be released and c2 survives
```

And `cascade move` transfers an object *and the entire graph it owns* from one region to
another — promote a whole subtree from a scratch arena to a permanent one in one statement:

```ldp3
cascade move tree from region old to region fresh;   // tree + everything it owns
release region old;                                   // old is freed; tree lives in fresh
```

In freestanding (kernel) mode the ownership keywords `move`, `movable`, `unique`,
`partitionable`, and `into` all remain available — precisely because they are compile-time
only and need no managed runtime, which makes them ideal for low-level code that wants
ownership safety at zero cost.

---

## 5.9 Persistents and `reattach`: state that outlives its object

The last piece of LDP3's memory model turns the usual object lifetime on its head. A
**persistent** is a class member whose *lifetime is decoupled from the instance that
declares it*. It survives its parent object's destructor, and it can **reattach** to a
new object that occupies the same conceptual slot. Think of it as durable state that a
class carries across the birth and death of its instances — a cache, a counter, a
skeleton that shouldn't be rebuilt every time.

A persistent's identity is bound to a **triple**:

```
(lexical scope, variable name, region)
```

Two variables that differ in *any* of the three coordinates get *independent* persistents;
two that match on all three share the same persistent. When a variable with a matching
triple is created again after the previous one was deleted, its persistent fields reattach
automatically — the new object sees the values that were live before.

```ldp3
public class Car {
    public eternal persistent mutable int chassi = 0;
    public constructor Car() {}
}

// Each call builds a fresh Car, bumps chassi, and deletes the Car.
// Because chassi is persistent, it lives outside the object and counts up
// across calls: 1, 2, 3 -- even though the Car is deleted every time.
public static method bump() returns int {
    Car c = new Car() on heap;
    c.chassi = c.chassi + 1;
    int r = c.chassi;
    delete c;                 // the Car dies; chassi persists
    return r;
}
```

The persistent even remains accessible *after* the parent is deleted, through the
qualified path — it genuinely outlived the object. LDP3's persistents are **in-process**:
they live for the duration of the program run, keyed by that triple, and reattach in
memory within the same run.

Because a persistent that nobody ever releases is a memory leak by construction, LDP3
enforces a **release obligation at compile time**. A non-`eternal` persistent must have a
`release persistent` somewhere in the program, or compilation fails with an error telling
you to either release it, mark it `eternal`, or annotate that release is delegated
elsewhere:

```ldp3
public class Cache {
    public persistent mutable int slot = 0;    // non-eternal: must be released
    public constructor Cache() {}
    public method use() returns void { this.slot = this.slot + 1; }
}

// somewhere in the program:
Cache c = new Cache() on heap;
c.use();
release persistent c.slot;    // satisfies the compile-time release obligation
delete c;
```

The escape hatch is `eternal`: a persistent that is *meant* to live for the whole run
(a global config cache, a session-long counter) is marked `eternal persistent`, and then
no release is required — the runtime frees it at program shutdown, running its destructor.
`eternal` is actually a general lifetime modifier — it applies to regions, threads,
channels, and static singletons too, always with the same meaning: *lives for the whole
program, no explicit cleanup required.*

Persistents interact with everything else in this chapter. They can be disambiguated by
region with `of region`, they follow (or don't) an object across a `move` via the
`carrying` / `leaving` / `releasing` qualifiers, and they can be placed in a named region
at declaration. They are the most advanced corner of LDP3's memory model — reach for them
when you have state whose lifetime honestly doesn't match any single object, and let the
default value semantics handle everything else.

---

## Putting it together

Step back and the whole design reads as one coherent stance on memory:

- **Default to values.** Assignment deep-copies; every variable owns its object; nothing
  aliases by accident. Bugs of shared mutation simply don't arise.
- **Share deliberately.** `T*` and `T&` opt in to sharing, and their presence in the
  source is the signal that sharing is intended.
- **Let scopes clean up.** Stack objects, `defer`, and `using` reclaim resources
  automatically and deterministically — on normal exit *and* on exception unwind.
- **Batch what dies together.** Regions turn a graph of allocations into a single
  arena and a single free, for GC-like ergonomics at a bump allocator's speed.
- **Prove ownership when it matters.** `movable`, `unique`, and `partitionable` push
  single-owner rules into the type system, enforced by compile-time flow analysis at
  zero runtime cost.
- **Fail loud, never silent.** Double-free, use-after-free, null deref, and out-of-bounds
  trap deterministically. There is no undefined behavior to exploit you.
- **Keep durable state where it belongs.** Persistents give state a lifetime independent
  of any one object, with a compile-time guarantee that it is eventually released.

No garbage collector, no hidden pauses, no mystery about when memory is reclaimed — and
yet, in the code you write most of the time, almost no manual bookkeeping. That balance —
determinism without drudgery — is the heart of LDP3.
