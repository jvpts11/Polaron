# 5b. The region binder

The previous chapter is about *what you can write*: `new`, `delete`, destructors, regions,
pointers, `move`. This one is about the analysis that reads all of it and decides whether the
result can dangle. It runs on every compile, it is **on by default**, and it is the reason
Polaron can offer manual memory management without the usual bargain attached.

Its name is both words. What it binds is **regions**: it works out, for every value in the
program, which region that value lives in — and then it enforces exactly one rule about
references between them.

> **The rule, complete:** a reference may only point at a region that **outlives** its own.

Everything in this chapter is either how a value's region is worked out, what "outlives" means
between two of them, or what to write when the answer is *"nothing in this program says"*.

---

## 5b.1 The idea in one page

A region is a lifetime with a name. Not an inferred interval, and not a runtime object: a place
whose end is a point the program already states — the closing brace of a call, a `release region`,
the destruction of the object that holds the field.

Polaron's claim is that **the program already contains this information**, and that it does not
need to be annotated a second time. Where an object lives is written at its `new`. When a region
ends is written at its scope. Who owns a field is written in the destructor that frees it. The
region binder's whole job is to read those three things and to check them against each other:

```polaron
public static method make() returns Point* {
    Point* p = new Point(7);     // this call's frame
    return p;                    // ...and the caller reads it after the frame is gone
}
```

```
error[Polaron-1721]: region-binder: returning 'p', which names an object living in this
method's own frame; the frame is gone by the time the caller reads it. Allocate it with
'on heap' so it outlives the call, or return it by value so the caller gets a copy
```

Nothing about that program was annotated. `new Point(7)` said "here", `return` said "there", and
"here" does not outlive "there".

The second half of the idea is the one that costs something, and it is worth stating plainly at
the top:

> **A value the analysis cannot place is refused.**

Not warned about — refused. A checker that answers *"allowed"* where it means *"I could not tell"*
finds bugs but cannot state a guarantee, because every guarantee has a shape it does not
recognise, and that shape is where the bug will be. Refusing the unplaceable is what turns the
region binder from a bug-finder into a promise.

---

## 5b.2 The four regions, and the order between them

Every value lives in exactly one of four kinds of region. They are **totally ordered**, longest-
lived first:

    Root  ⊒  Object ◇o  ⊒  Region R  ⊒  Activation ◇m

| Region | Written in the source as | Ends when |
|---|---|---|
| **Root** | a static field, a string literal, a fixed address, `on heap` before anyone takes it | never (or: not while the program runs) |
| **Object ◇o** | a field of some object; anything that object owns | that object is destroyed |
| **Region R** | `new T() in region r` | `release region r`, or its scope closes |
| **Activation ◇m** | `new T()` / `new T() on stack` — the frame of the call it is written in | the call returns |

In a diagnostic these are named the way you think of them, not the way the model writes them:
*static storage*, *this object*, *what 'p' belongs to*, *region pen*, *this call*.

Three details of the order do most of the work:

**A heap allocation nobody has taken yet is Root.** `new T() on heap` produces something that
outlives everything, because no one has claimed it. It therefore fits *anywhere* — which is what
makes `this.head = new Node(v) on heap;` the ordinary way a class takes ownership rather than an
error. What happens to it afterwards is the receiving object's business, and that is read from
the receiving object's destructor (§5b.4).

**Two different objects are incomparable.** Not "unknown, so allowed" — *incomparable*, and that
is a final answer rather than a gap:

```polaron
public class Session {
    private mutable Cache* cache;      // whose? and does it outlive a Session?
}
```

Nothing anywhere in the program says whether a `Cache` outlives a `Session` or the reverse, so a
pointer from one to the other cannot be shown valid for as long as it is reachable. The program
has to say. §5b.6 is the list of ways to say it, and there are six.

**Two explicit regions are ordered by birth.** Regions are released last-in-first-out — at scope
exit, in reverse declaration order — and a region declared inside a block is necessarily born
after the region enclosing it. So *born earlier* is exactly *dies later*, and **one number per
region** orders an arbitrarily deep nest without modelling the nest at all:

```polaron
region durable = itself.allocate(64 kilobytes);
{
    region scratch = itself.allocate(4 kilobytes);
    Node* tmp = new Node(1) in region scratch;
    Node* keep = new Node(2) in region durable;
    tmp.next = keep;      // fine: durable outlives scratch
    keep.next = tmp;      // error: scratch is released first
}
```

Both directions matter. A rule that refused both would not be an order.

---

## 5b.3 Against the alternatives

Three strategies exist for the same problem — *"is this reference still valid?"* — and they
differ in **when they answer** and **what the programmer has to write down**.

### The garbage collector answers at run time, by not answering

A tracing GC makes the question unaskable: nothing is freed while anything can reach it. That is
a real guarantee and it costs nothing to write — no annotation, no discipline, no shape of program
ruled out. What it costs is paid elsewhere: a runtime that traces, pauses that arrive when the
collector decides rather than when the program does, memory held past its last use, and object
graphs that must be laid out the collector's way rather than the cache's.

And it answers only the memory question. *When is this file closed? when is this GPU buffer
released? when is this lock dropped?* — none of those are memory, none are handled by tracing,
and every managed language grows a second mechanism for them (`using`, `try-with-resources`,
`defer`) precisely because the first one does not reach.

Polaron's destructors run at a point the program states, and that is the same mechanism for
memory, files, sockets and locks. The region binder is what makes those points safe.

### The borrow checker answers at compile time, by tracking aliasing

Rust's borrow checker proves more than the region binder does. It tracks **exclusivity** — one
mutable borrow *xor* many shared ones — which yields not only temporal safety but data-race
freedom and iterator invalidation as consequences of the same rule.

The price is that lifetimes become part of the *type*. When elision cannot infer them they are
written into signatures (`fn longest<'a>(x: &'a str, y: &'a str) -> &'a str`), they propagate
outward through every caller, and a data structure whose shape is not a tree — a graph, a
back-pointer, an observer list — is expressed through `Rc<RefCell<T>>`, arena indices, or `unsafe`.
That is not a flaw; it is the cost of proving a stronger statement.

### The region binder answers at compile time, by tracking placement

Polaron proves the weaker of the two statements — **temporal** safety, not exclusivity — and buys
something specific with the difference: **there are no lifetime annotations in the language.** Not
elided ones; none. Look at any Polaron signature in this manual and there is nowhere a lifetime
could be written.

That is possible because of the model's first sentence: **regions are inferred from structure the
language already has, and the region tree IS the composition tree.** A class contains its fields,
so its fields live in its region. A region contains what is allocated in it. A frame contains its
locals. Composition is a tree the programmer already drew, and containment is already an order —
so the ordering comes for free, out of code that was going to be written anyway.

The one thing that could not be read off the structure is which of two pointers is *ownership*.
Polaron reads that off the **destructor** (§5b.4), which the author already had to write, and
which says it unambiguously.

### Side by side

| | Garbage collector | Borrow checker | Region binder |
|---|---|---|---|
| **Answers** | at run time | at compile time | at compile time |
| **Proves** | reachable ⇒ alive | temporal safety **+ exclusivity** | temporal safety |
| **You write** | nothing | lifetimes in signatures, `'a`, sometimes `Rc`/`RefCell` | destructors, `on heap`/`in region`, occasionally `weak` |
| **Runtime cost** | tracing, pauses, headroom | none | none |
| **Non-memory resources** | a separate mechanism | same mechanism (`Drop`) | same mechanism (destructors) |
| **Graphs & back-pointers** | free | `Rc<RefCell>` / indices / `unsafe` | `weak`, or one region for both |
| **Data races** | not addressed | prevented by the same rule | a separate rule (ch. 9) |
| **Escape hatch** | `unsafe` blocks in some | `unsafe` blocks | `--no-region-binder`, whole program only |

Read the last row carefully, because it is a real difference in kind. Rust and C# let you turn the
rule off **in one place**. Polaron does not, and the reason is in §5b.8.

### What this means for how you write

If you have written Rust, the adjustment is that **you never annotate a lifetime and you often
write a destructor instead.** Where Rust asks "how long does this borrow last, relative to that
one?", Polaron asks "who frees this?" — and the answer goes in a destructor rather than a
signature.

If you have written C++ or C, the adjustment is that **the compiler now insists you answer the
question you were already supposed to have answered.** The refusals mostly land on the same lines
where a code review would ask "wait, who owns that?".

If you have written Java, C# or Go, the adjustment is real: object graphs must have a direction.
The next two sections are the practical part.

---

## 5b.4 The destructor is where ownership is declared

A `T*` field can be two completely different things and the type says nothing about which:

```polaron
private mutable ArrayList<Row*>* rows;      // does this class free these rows, or borrow them?
```

The destructor says:

```polaron
public class Table {
    private mutable ArrayList<Row*>* rows;
    public destructor ~Table() returns void {
        for (var r in rows.toArray()) { delete r; }   // "a Table owns its rows"
        delete rows;                                   // "...and the list itself"
    }
}

public class ResultSet {
    private mutable ArrayList<Row*>* rows;
    public destructor ~ResultSet() returns void {
        delete rows;                                   // the list only: a VIEW of somebody's rows
    }
}
```

Two classes, the same field, opposite meanings — and the region binder now treats them oppositely.
`table.rows.add(row)` is a **handover** and needs no ordering. `result.rows.add(row)` is a
**borrow** and must be proven safe.

Four consequences worth knowing:

**Owning a container is not owning what is in it.** `~ResultSet` frees a field called `rows`, and
so does `~Table`. A check that asked only "does it free `rows`?" could not tell a table from a
view — which is the exact bug the whole analysis exists to catch. So two answers come out of a
destructor: which **fields** it frees, and whose **contents** it frees. A value landing *in* a
field asks the first; a value landing *among* a field's elements asks the second.

**Every spelling counts.** `delete this.f`, `delete this.f.get(i)`, a loop that deletes the
elements, and a `this.clear()` whose body does the deleting — all four say the same thing about
the field.

**Adding a destructor can turn a program that compiled into one that does not**, and adding one
is usually the *fix* rather than the problem. It is the sentence that says who frees what, and the
refusal was there precisely because nobody had said it.

**Ownership crosses calls.** The compiler computes, for every method, which of its parameters get
stored into the receiver and into which field — an *escape summary* — and carries it through the
`.polh` so it survives a bundle boundary. That is why this reports at the call:

```polaron
Row scratch = new Row(1);        // this call's frame
result.keep(scratch);            // error: 'keep' keeps that argument
```

...and why the complaint lands where both objects are named, instead of inside `keep`, on a line
that could not be written any other way.

---

## 5b.5 Where a value's region comes from

The full inference. Read it as a lookup table for *"why did it say that?"*.

| The expression | Its region |
|---|---|
| `new T()`, `new T() on stack` | **this call** |
| `new T() on heap` | **Root** — nobody owns it yet, so it fits anywhere |
| `new T() in region r` | **region r** |
| `new T()` where `T` is a `region class` | the type's own region — it needs no `on heap` and no `in region`, because there is only one place its instances can go |
| `this` | this object |
| a parameter, or a local holding a heap object | **that object** (the object *is* the name) |
| a local declared `region r` | region r |
| a field of a class that **owns** it (`recv.f`) | the receiver's region |
| a field the class **borrows** | the receiver's region — as a *lower bound*, see below |
| `a[i]` | the array's region |
| `&x`, `*x` | whatever `x`'s region is — taking an address changes what you hold, not how long the thing lasts |
| `c ? a : b` | the **shorter-lived** of the two arms |
| `null` | Root — it points at nothing, so it fits everywhere |
| a static field, a class name | Root |
| `cast<T*>(0x09000000)` | Root — a fixed address was there before the program and will be after |
| `r.at(i)` where `at` returns a field `r` owns | the receiver's region |
| a method that returns **fresh** storage | Root — whoever takes it becomes the owner |
| any other call | **unplaceable** — and therefore refused |

Two entries deserve their own paragraph.

**A borrowed field read as a source is a lower bound, and that is sound.** When you read
`this.head` out of a class that does not own it, the analysis answers "the holder's region" even
though the true owner is elsewhere. That is legitimate because of induction: every store *into*
that field was itself checked by this same rule, so whatever is in there already outlives the
holder. A source position may be understated — it can refuse a program that was fine, never accept
one that was not. Answering "unknown" instead would refuse `node.next = this.head`, which is the
second line of every linked list ever written.

**A fresh object's region is lowered by what its constructor keeps.** `new Parser(tokens) on heap`
reads those tokens for as long as it exists, so it is no longer-lived than they are — whatever the
allocation says. The `new` itself is never the error, because nothing has gone wrong there yet; the
bound travels with the object and the diagnostic lands where it is stored, returned or kept.

---

## 5b.6 How to obey it

When a store or a return is refused, there are six answers. They are in the order you should
consider them, and the first two cover most cases.

### 1. Store a copy

Assignment in Polaron is a deep copy, so a value that is copied in has no lifetime relationship to
anything. If the data is small — an id, a date, three floats, a record — this is the right answer
and it removes the question rather than answering it.

```polaron
private mutable Config settings;      // a copy: no ordering to prove
```

A `record` is the shape built for this: copied on assignment, complete the moment it is built.

### 2. Own it, and say so in a destructor

If the holder *should* free the thing, write the destructor that frees it. The reference becomes
ownership and there is nothing left to prove.

```polaron
public class Panel {
    private mutable Button* ok;
    public destructor ~Panel() returns void { delete ok; }   // a Panel owns its button
}
```

### 3. Put both in one region

Two objects in the same region are born and released together, so there is no order to establish
— the question disappears entirely. This is the answer for graphs, parse trees, and anything where
"these all die at once" is true.

```polaron
region ast = itself.allocate(64 kilobytes);
Node* root = new Node("+") in region ast;
root.left = new Node("1") in region ast;      // same region: nothing to order
```

`region class` takes this further: every instance of the type comes from one region owned by the
type, so `new Node(v)` inside it needs no placement at all.

### 4. `weak` for a view that must outlive nothing

A `weak T*` is **emptied when its target dies**, so it cannot outlive what it points at — and the
binder therefore asks for no ordering on a store into one.

```polaron
private mutable weak nullable Grid* ground;    // the world's; nothing orders the two
```

A weak slot is two pointers wide (the reference, plus the registration that lets the target's
`delete` find and clear it). Use it for back-pointers, observers and caches — the shapes that
genuinely have no lifetime relationship.

**Do not reach for it to silence a diagnostic.** If the holder should free the thing, the answer
is #2. And note the rule is all-or-nothing: if a value lands in two fields and only one is `weak`,
the ordinary one still holds a raw pointer after the target dies, and that is the reference the
rule is about.

### 5. `move` / `unique` for a single owner

`unique` or `movable` on a type says there is exactly one owner, and makes every handover a `move`
the compiler follows. Where that is the truth, say it once on the declaration and every call site
reads as what it is.

### 6. Give it a longer life at the allocation

The remaining case is that the object was simply allocated in the wrong place. `on heap` gives it
a lifetime longer than the call and makes the caller responsible for `delete`; a region gives it
the region's lifetime.

```polaron
public static method make() returns Point* {
    return new Point(7) on heap;      // the caller deletes it
}
```

Decide an object's lifetime **where it is allocated**, not where it is used — the allocation is
the one place that has to know.

---

## 5b.7 The refusals, one at a time

Five diagnostics come out of this analysis. `polaron explain <code>` prints the full write-up for
any of them.

### `Polaron-1721` — this hands out a pointer to storage that is about to disappear

The frame-escape case. Something living in this call's frame is returned, or stored somewhere that
outlives the call.

```polaron
Node n = new Node(1);
holder.kept = n;        // 1721: the frame is freed first
```

**Fix:** #6 (allocate it where it should live), or #1 (store a copy).

### `Polaron-1722` — nothing in the program says which of these two dies first

The incomparable case. Both values live as long as *some* object, and nothing anywhere states
which object outlives the other.

```
region-binder: nothing orders this object against what 'cache' belongs to, so storing
that reference in field 'cache' cannot be proven safe: neither is known to outlive the
other. Store a copy, or have one of them own the value outright.
```

This is not a gap in the analysis; it is a gap in the program. **Fix:** #2 (own it), #1 (copy),
#3 (one region), or #4 (`weak`) — in that order of preference.

### `Polaron-1723` — past this point there is no proof to be had

A pointer is being handed to an `extern` function. There is no Polaron body to read, so nothing in
this program can say whether the foreign side keeps it.

**Fix:** declare the parameter as `address`. That is a raw machine word, which is exactly what a
pointer crossing into C is, and the refusal goes away because the *claim* goes away — the
declaration now states where this program's proof stops.

### `Polaron-1724` — what this holds was freed by an earlier call

A value built out of another object's contents, read after those contents were freed. This is
use-after-free spread over three statements, which is why it survives review: building the view is
correct, emptying the source is correct, reading the view is correct, and only their **order** is
wrong.

```polaron
watcher.watch(subject);   // watcher now holds a reference into subject
delete subject;           // ...and that is what it was pointing at
watcher.read();           // 1724: use of 'watcher' after 'subject' was emptied
```

Two things establish the borrow: a call that **keeps** an argument (above), and a method that
**returns a borrow of its parameter** (`var view = Query.over(table);`). Two things break it:
`delete`, and any method that frees the **contents** of one of its own fields — a `clear()` that
deletes each element invalidates every borrow taken out of that object. That last one is `DELETE
FROM people` arriving while an earlier `SELECT` is still holding the rows.

**Fix:** read before the mutation, or hold copies (`record`) so emptying the source leaves the
result intact. `Slice<T>` is the opposite choice said out loud — a window that does not own what it
looks at, fine as long as it is read before the owner moves on.

### `Polaron-0803` and friends — regions used incorrectly

The region-specific rules: releasing a parent before the sub-region carved out of it, using a
value after `release region`, a `region` field with no release in the destructor, `mark`/`rollback`
on the wrong flavor, `extract` of an object whose field is still in the region.

```
use of 'tmp' after `release region scratch`: it lives in that region, so its storage is
gone. Read it before the release, or copy what is needed out of the region first
```

---

## 5b.8 Reading a refusal you disagree with

The first move is to read *which two regions* the sentence names — it always names both, and the
fix follows from the pair. "this call outlives what 'p' belongs to" is a different problem from
"nothing orders this object against what 'cache' belongs to".

When the complaint is that a call *keeps* an argument, the question turns on **which field** it
landed in and whether that field is owned. That is printable:

```
POLARON_TRACE_KEEPS=1 polaron build
keeps: ResultSet.keep#0 -> [rows]
```

Now the argument is concrete: `keep` puts it in `rows`, and `~ResultSet` does not free the
elements of `rows`, so it is a borrow. Either the destructor is wrong or the call is.

Two shapes pass that look like they should not, and knowing them saves time:

- **Storing what the caller handed you.** `Parser(tokens) { this.tokens = tokens; }` is not checked
  inside the constructor — the answer is knowable only where both objects are named, which is at
  the `new`. The obligation is not dropped, it *moves* to every call site.
- **A second pointer to what this object already owns.** `this.first = v; this.last = v;` is the
  head-and-tail of every linked structure; the first store made this object the owner and the
  second names the same node again.

Finally, the escape hatch. `--no-region-binder` turns the analysis off **for a whole program**, and
that is the only choice on offer:

```
polc program.pol --no-region-binder
```

There is deliberately no per-line version, and the reason is not severity — it is that the analysis
divides a program into regions, and declaring that some part of it belongs to none makes every
proof about the *rest* unavailable, because those proofs are relative to a partition that no longer
covers the program. A partial guarantee here is not a weaker guarantee; it is not one. So the
choice offered is not *more safety or less*, but **"cannot write this bug" against "can write it
anywhere"** — and it is visible in the build rather than buried on a line that looks ordinary.

---

## 5b.9 A worked example: the result set that outlived its rows

This is the program that motivated the analysis, reduced to its bones. A table owns rows; a query
returns a result set holding some of them; a later statement deletes rows from the table.

```polaron
public class Table {
    private mutable ArrayList<Row*>* rows;
    public destructor ~Table() returns void {
        for (var r in rows.toArray()) { delete r; }
        delete rows;
    }
    public method select(int col) returns ResultSet* { ... }
}

public class ResultSet {
    private mutable ArrayList<Row*>* rows;         // rows the TABLE owns
    public method keep(Row* r) returns void { rows.add(r); }
    public destructor ~ResultSet() returns void { delete rows; }
}
```

Every line is individually correct. Run it and the second statement prints the first statement's
data, or garbage, depending on what the allocator did in between — the classic shape, and one that
survives review because there is no wrong line to point at.

The region binder points at `keep`:

```
error[Polaron-1722]: region-binder: 'keep' keeps that argument, and nothing orders what
'result' belongs to against what 'table' belongs to: neither is known to outlive the
other, so this reference cannot be proven safe. Store a copy, or have one of them own
the value outright.
```

Three fixes, and the choice is a design decision the program had been avoiding:

1. **The result set owns its rows** — copy each row in, free them in `~ResultSet`. Correct when
   results outlive statements.
2. **The result set is explicitly a window** — hold a `Slice<Row*>`, and read it before the table
   changes. Correct when results are consumed immediately, and now says so.
3. **Both live in one region** — a query region released when the statement ends. Correct when
   the whole engine is phase-structured.

The analysis does not choose. It refuses to let the question go unanswered.

---

## 5b.10 What it does not do

Stated plainly, because a guarantee is only as good as its boundary.

- **It does not prove exclusivity.** Two live references to the same mutable object are fine here.
  That is the borrow checker's stronger claim, and it is not made.
- **It does not prevent data races.** Concurrency safety is a separate rule with its own mechanisms
  — `atomic<T>`, `Mutex<T>`, `Channel<T>`, and a check on what a thread closure captures (ch. 9).
  It arrives by decision, not as a side effect.
- **It does not track values through arbitrary calls.** A call result is placed when the callee is
  a one-line accessor returning a field, or is known to return fresh storage. Anything else is
  unplaceable, and unplaceable is refused. The fix is usually to name the value at its source.
- **It does not free anything.** It is entirely a compile-time analysis; `delete`, destructors and
  `release` do the freeing, and the runtime's own liveness check (§5.4) catches what gets past.

What it cost to turn on is worth recording, since "refuse the unplaceable" sounds expensive: the
number of sites needing a change went 35, then 23, then 18, then 10, then **0** — across the
20,000-line standard library, 799 sample programs and a 27-file SQL engine. Every step that removed
sites taught the analysis to place another real shape; none of them relaxed a rule. The number was
never a count of dangerous code. It was a count of the analysis's own silence.

---

**See also:** §5.4 (the runtime half — deterministic traps), §5.7 (regions in full), §5.8
(`movable`/`unique`/`partitionable`), §17.2 and §17.3 (destructors and `weak` at the seams),
ch. 9 (concurrency), §11 (`address` and the FFI boundary).
