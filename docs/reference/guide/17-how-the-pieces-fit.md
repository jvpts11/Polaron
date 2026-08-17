# 17. How the pieces fit together

Every chapter before this one describes a feature on its own. This one is about the seams — the
places where two features meet and the result is not the sum of the two descriptions. Each section
is a pair, a rule, and the failure that happens when the rule is not known.

They are here because this is where the real mistakes live. Nobody misuses `while`. What people get
wrong is the third thing that follows from two decisions taken separately.

---

## 17.1 Value semantics × containers × destructors

**The rule:** assignment copies. A container of values holds copies. A type with a destructor must
therefore be held **by pointer**, or its copies each free what the original owns.

```polaron
// WRONG, and it compiles.
private mutable ArrayList<Controller>* tabs;      // Controller has a destructor
tabs.add(new Controller(rows, cols) on heap);     // the heap object is COPIED in, then leaks;
                                                  // the copy's destructor frees what the original holds
// RIGHT
private mutable ArrayList<Controller*>* tabs;
tabs.add(new Controller(rows, cols) on heap);
```

The failure is not a compile error and not a wrong number: it is a double free, which on Windows is
`0xC0000409` with no output at all — the process is killed before anything it printed reaches the
console. In a real editor this cost an afternoon, and the symptom was "the self-test prints nothing".

**How to tell which you want:** does the type *own* something — memory, a file, a GPU name, a
process? Then it is held by pointer and freed by one owner. Is it a value — three floats, an id, a
date? Then it is held by value and copies are free.

## 17.2 Destructors × ownership × the region binder

**The rule:** the region binder reads ownership **out of the destructor**. A class whose destructor
deletes a field owns that field; a class whose destructor does not is a viewer.

That is why adding a destructor can turn a program that compiled into one that does not, and why
adding one is usually the fix rather than the problem: it is the sentence that says who frees what,
and the analysis was refusing precisely because nobody had said it.

```polaron
public class Table {
    private mutable ArrayList<Row*>* rows;
    public destructor ~Table() returns void {
        for (var r in rows.toArray()) { delete r; }   // "a Table owns its rows"
        delete rows;                                   // "...and the list"
    }
}
```

From here `table.rows.add(row)` inside `Table` is a **handover**, not a borrow, and the binder stops
asking about it.

## 17.3 `weak` × the region binder

**The rule:** a `weak T*` is emptied when its target dies, so it cannot outlive what it points at —
and the binder therefore asks for **no ordering at all** on a store into one.

This is the answer whenever two objects genuinely have no lifetime relationship and one merely
*watches* the other:

```polaron
public class Stir {
    private mutable Wild* wild;                    // owned by the thing that made this
    private mutable weak nullable Grid* ground;    // the world's; nothing orders the two
}
```

Without `weak` the binder says *"nothing orders this object against what `ground` belongs to"*, and
it is right: the program had not said. `weak` is the saying.

**Do not reach for it to silence a diagnostic.** If the holder *should* free the thing, the answer is
a destructor (§17.2). `weak` is for the case where it genuinely should not.

## 17.4 `delegate` × interfaces × transformers

Two features look alike from the class line and are not:

> A **delegate** is a part the type *has*. A **transformer** is equipment the type *gains*.

```polaron
public class City implements Landholder {
    private delegate Territory territory;   // a city HAS ground; a Territory means something alone
}

public class Wild applies TFiler { ... }    // a Wild GAINS an index and the procedures that keep it
```

**The test:** would the part still mean something on its own? A `Territory`, a `Storehouse`, a
`Rule` would. An "ArmyMember" holding one id and three methods would not — it was invented to carry
a field, and that is the shape a transformer takes over.

The cost of getting it wrong is not correctness, it is fourteen hand-written forwarders that drift.

## 17.5 `sealed` × `match` × `Result`

**The rule:** `match` over a sealed type must cover every case, and a `default` is what makes a new
case invisible. Put the two together with `Result` and a failure cannot be dropped:

```polaron
public sealed enum Refusal permits NobodyLeft, NoReachableGround, TooClose;

public method found(...) returns Result<City*, Refusal>;
```

A caller cannot ignore a `Result`, and the `match` that reports the refusal does not compile until
every constant has an arm. **A seventh reason added next year is a compile error, not a silent
`continue`** — which is the whole reason to spend a type on it.

Where to put the exhaustive `match` matters: if it is only in the counting, adding a case still
compiles (an array indexed by ordinal grows by itself). Put it where the reason is **named** — the
report — and the compiler stops the build at the one place a human has to write a sentence.

## 17.6 Generics × monomorphisation × bundles

**The rule:** a generic is expanded per instantiation at compile time, and the instance is named from
the base name — `Stack<int>` is `Stack$int` whoever declared it.

Two consequences that only appear in real programs:

- A library and a program that both instantiate `ArrayList<String>` produce the same symbol. That is
  handled (`linkonce_odr`), but it is why a `.polb` skips `$`-named classes in its header.
- **Two different generic templates with the same short name collide**, because the instance is named
  from the base. Your own `Stack<T>` beside the library's is the one case where telling types apart
  by namespace is not enough.

Non-generic types sharing a short name with the standard library are fine — yours wins, and the
compiler says so with a warning.

## 17.7 Reflection × freestanding

**The rule:** reflection, exceptions, `async` and the managed runtime are absent in a `freestanding`
program, and the compiler refuses them there rather than letting a kernel link against a runtime it
does not have.

The seam that bites is indirect: a standard-library container calls `equalsKey`, which resolves onto
`Object`, which a freestanding build does not emit. That is why `Xml`'s children are a sibling chain
rather than an `ArrayList<Xml>` — the list version broke every bare-metal program in the suite with a
message about `equalsKey` from a type the kernel never mentions.

**Writing a library that must work in both:** avoid generic containers of your own declared types in
the paths a freestanding program uses. Chains and arrays are safe.

## 17.8 Regions × ownership × `accepts`

**The rule:** a region is a typed arena. `accepts`/`rejects` are checked at the allocation, and the
check follows the region into a field:

```polaron
private mutable pool region termRegion;             // on a class
this.termRegion = itself.allocate(16 kilobytes);
this.terms.add(new Terminal() in region this.termRegion);
```

Two rules that catch people:

1. **A class holding a region must release it in its destructor** — the compiler says so by name
   (`Polaron-0803`), because a region is memory the object owns and nothing gives it back on its own.
2. **What lives in the region is freed by the region**, so anything in it whose own destructor must
   run has to be deleted *before* the release. A shell behind a ConPTY freed without being closed
   leaves a process running with nobody to talk to.

## 17.9 Contracts × inheritance × generics

`requires`/`ensures` are checked at run time and inherited: an override cannot demand *more* of its
caller than the method it replaces. Inside a generic they are checked per instantiation, so a
contract that mentions `T`'s methods is checked for each `T` that exists.

A violated contract prints the file, the line, the method, the clause **and the operands**
(`left = 0, right = 0`) — a contract that only printed "requires" was a diagnostic that sent you
looking for which of three clauses it was.

## 17.10 Persistents × `unimport`/`reimport`

**The rule:** `persistent` state survives the code that uses it being unloaded and reloaded. That is
the pair: `unimport` takes a bundle out of the running program, `reimport` brings the version on disk
back, and a `persistent` field is what is still there afterwards.

`Memo` and `EventLog` in the standard library are the two worked examples: a cache that stays warm
across a reload, and an append-only log whose *reader* can change while the events do not.

## 17.11 The pointer types, in one table

| Written | Means | Freed by |
|---|---|---|
| `T` | A value. Assignment copies it, deeply. | Nobody — it lives inside whatever holds it. |
| `T*` | A reference to one object. | Whoever the destructor says owns it. |
| `T&` | A reference that cannot be null and cannot be re-seated. | Same. |
| `nullable T*` | May be absent, and the type says so. Dereferencing null traps. | Same. |
| `weak nullable T*` | A view that empties when the target dies. | **Never here** — that is what weak means. |
| `movable T` / `unique T` | Ownership that transfers with `move`, and a compile error to copy. | The last owner. |
| `address` | A raw machine address, no type and no proof. | Nobody; this is where the guarantees stop. |

---

## 17.12 A short list of things that surprise people

- **`this.` is optional**, and the places it is written are the places it disambiguates. A parameter
  named after the field it sets is the one case where it is required.
- **Assignment is not an expression.** `if (x = 5)` does not compile.
- **`main` returns `void`.** A program fails by calling `Exit.failed()`; there is nothing to return.
- **Every standard-library type needs an explicit `import`.** There is no automatic namespace.
- **A `catch` cannot catch what a method does not declare it `throws`.**
- **Integer division by zero throws** rather than being undefined, and a cast that would not fit
  saturates rather than wrapping — see the no-UB principle in §8.
- **`step`, `call`, `release`, `union` and `onFailure` are keywords**, and a local named after one of
  them is a syntax error in a line that otherwise looks fine.
