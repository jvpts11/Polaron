# The Polaron ABI

*Written 2026-08-13, from measurement. Every fact below was recovered by reading emitted IR and the
bundle format, because none of it was written down anywhere — which is how the bug in **Gap 1** stayed
hidden.*

**This document does not freeze the ABI. It states what it is**, so that the next change to it is a
decision rather than an accident.

## There are two ABIs, and Polaron deliberately has only one of them

**The closed world.** Everything is compiled from source by one compiler version; `.polb` bundles exist
for separate compilation and incremental builds, and compatibility is checked by *exact verification*
rather than guaranteed by stability. This is Rust's model, and Swift's before ABI stability.
**This is the one Polaron targets, and it is close to usable — three gaps, listed at the end.**

**The open world.** A binary library is shipped, someone else links it, possibly with a different
compiler version, possibly from C or C++. **Polaron does not have this in general, and almost none of
that is accidental**: every symbol has `internal` linkage in a program build, the vtable is a
program-global table indexed by method name, and there is no exception ABI across a boundary. Reaching
it in full is a programme of work, not a list of fixes.

**But its narrow door is now open, and verified.** `unknown <world>` was always the C-callable surface;
what it lacked was any way to tell the other side what was behind it. `polc --emit-c-header=<path>`
writes that header, and the test `abi_c_export_calls_in` compiles a Polaron `--lib`, generates the
header, builds a **C++** program against it, links the two, and checks the answers. It is the first
thing in this repository that verifies the open world at all.

The mapping is where the value is, because two entries are surprising and silently wrong if guessed:

| Polaron | C | note |
|---|---|---|
| `int` / `long` / `short` / `byte` | `int32_t` / `int64_t` / `int16_t` / `int8_t` | |
| `float` / `double` | `float` / `double` | |
| `address`, any reference | `void*` | |
| **`boolean`** | **`int32_t`** | four bytes, not `bool` |
| **`char`** | **`int32_t`** | four bytes, not `char` |
| `string`, arrays, objects | *(refused)* | no honest C spelling |

A C caller who declares `bool polaron_flag(void)` reads one byte of four and gets whatever was in the
other three. The header carries that fact so nobody rediscovers it, and the test calls
`polaron_is_even` precisely to prove the two sides agree on it.

**A method that cannot be spelled in C is written into the header as a refusal, not skipped.** An
export missing from a generated header reads as "there is no such export", which sends the reader
looking for a bug that is not there.

**A library, not a program.** The Polaron side is built with `--lib`, because in the open world
someone else's program owns `main` and links our code in. Building it as a program gives two `main`s
and a link error — which is a fair summary of what separates the two worlds.

The rest of this document describes the closed world.

## Object layout

| kind | layout | measured from |
|---|---|---|
| class in a hierarchy | `{ ptr vtable, fields… }` — vtable pointer at offset 0 | `%class.Base = type { ptr, i32 }` |
| standalone class | `{ fields… }` — **no header at all** | `%class.Point = type { i32, i32 }` |
| `struct`, `record` | same as a standalone class; **separately allocated, not embedded** | a class holding both emits `{ ptr, ptr }` for the two fields |
| root | `%class.Object = type { ptr }` | |

**Field order is declaration order.** Declaring `byte tiny; long big; int mid` emits
`{ ptr, i8, i64, i32 }` — no widest-first reordering, and therefore 11 bytes of padding in that
example. Two things modify placement:

- **`affinity`** groups fields, and **it crosses the `.polh`** — deliberately, with the reasoning
  recorded in `polh.cpp`: *"an affinity decides where the field sits in the object, so it MUST cross
  the bundle boundary."*
- **`layout`** — "an interface for MEMORY", a size budget a class can be arranged by. Whether an
  arrangement crosses the `.polh` is **unverified**; see Gap 3.

## Values

| | representation |
|---|---|
| `String` | `{ i64 length, ptr data, i64 hash }` — immutable; the hash is a lazily-cached FNV-1a, `0` meaning not yet computed |
| array | `[ i64 length ǀ elements… ]`, an 8-byte header; element `i` is at `8 + i * stride` |
| region slot | `[ 16-byte PolaronHdr ǀ payload ]`, payload 16-aligned |
| boxed primitive | `{ ptr vtable, i64 value }` — widened to 64 bits |

## Methods and symbols

- A method is `@Class.method`, with the **receiver as the first argument**.
- A constructor is `@Class.Class`.
- Linkage is **`internal` in a program build** and **`dllexport` in a `--lib` build** — so a bundle
  exports its methods and a program exports nothing.
- Generic types are mangled into the name: `Box<int>` → `Box$int`.
- The **one** deliberate escape from all of this is `unknown <world>`, which emits a method under its
  **bare name** with external linkage. That is how `_start`, an interrupt handler, `syscall_entry` and
  `__polaron_malloc` are defined, and it is the only door through which foreign code can call in.

## Virtual dispatch

A vtable is a **program-global table of 350 pointers**, and a slot is assigned per distinct **method
name across the whole program** — not per class, and not densely per hierarchy. `Object.equals`,
`hashCode` and `equalsKey` sit at slots 39–41 and everything else is mostly null.

Two consequences follow, and they explain the bundle format:

- Slot numbering depends on the **whole program's** set of method names, so two independently compiled
  units cannot be assumed to agree. This is why `PolbBundle::vtableSlots` exists: a bundle records its
  slot layout and a consumer seeds its own numbering from it.

  That seeding used to work only while every dependency's list was a **prefix** of the merged one, and
  polc refused the build otherwise — a requirement no two independently built libraries can meet,
  since both number their own first virtual method 0. Two four-line bundles sharing not one type could
  not be used in one program: for a language meant to ship binary libraries, the feature did not
  exist. The merged numbering is now a **union**, and each dependency's baked tables are **permuted
  into it on extraction** — `--emit-vtable-slots` on the consumer's compile (the only one that sees
  every bundle, so its numbering is the authority), `--extract-code --remap-slots` on each dependency.
  `src/driver/build.cpp` passes both. Translation rather than standardisation, which is the stance of
  this whole document. Tests: `two_bundle_link_runs`, `bundle_vtable_conflict_reconciled`.

  One detail that is easy to get wrong and does not fail loudly: the emitted table is **one entry
  longer** than the slot row, because codegen appends the most-derived destructor after it for virtual
  `delete`. That entry is positional, not named — carry it across rather than looking it up.
- Each instantiated polymorphic class costs a 2 800-byte table, mostly null. **Measured: a program
  using `ArrayList` emits 3 vtables, not hundreds** — dead-stripping keeps the cost proportional to
  *instantiated* polymorphic classes, not declared ones.

## The stability model: verify, do not stabilize

A `.polb` carries:

```
magic "POLB" | u16 format version | u16 flags | 32-byte fingerprint
name | version | .polh text | LLVM bitcode | deps[] | vtableSlots[]
```

- The **fingerprint** is `SHA-256(.polh text)` — the canonical public API. Each dependency records the
  fingerprint it compiled against, and a mismatch at load raises `BundleAbiMismatchException` rather
  than being misread. Tested end to end (`run_polb_abi_test.cmake` swaps a bundle for one with a
  different fingerprint and requires the exception).
- The **container magic and format version** guard the file, and the magic has changed with every
  rename of the language (`LDB\x01` → `INGB` → `POLB`), so a stale bundle is refused rather than
  misparsed.

**The model is coherent. The problem is that the fingerprint verifies the *interface*, and the layout
is not entirely determined by the interface.** That is Gap 1.

---

# What was missing for the closed world to be production-usable

**All five gaps below are closed.** They were found in one audit, against one rule — *anything codegen
uses to decide an offset must be in the `.polh`* — and each has a regression test that reads the fact
from the far side of a bundle boundary. What remains open for the closed world is not a gap in this
list; it is the ordinary work of keeping the rule true as the language grows.

## Gap 1 — private fields did not cross the `.polh`, so offsets diverged. **Closed.**

**The fix: bytes cross, names do not.** `spellReservation` emits every private instance field into the
header as an anonymous reservation — `private mutable long __reserved0;` — so the consumer lays out the
same object without learning what the field is called. Encapsulation is preserved by the *naming*, and
the ABI by the *width*. Four cases, each for a measured reason:

- a `weak` field is **two pointers** (16 bytes, 8-aligned), so it reserves two `address`es;
- a bit field keeps its declared width, or the packing run it belongs to changes;
- a scalar reserves its own type;
- everything else is one `address`, because a non-scalar field is a pointer in the object — structs
  and records are separately allocated, not embedded, and there are no inline array fields (checked:
  the only `ArrayType` in a class layout is the vtable).

Test `bundle_field_offset_runs`, which reads a public field **through** a private one across a bundle.

*What the gap looked like before:* `polh.cpp`'s `emitField` began:

```cpp
void emitField(Emitter& e, const FieldDecl& f) {
    if (!exposed(f.visibility)) return;      // private fields do not cross
```

A private field still occupies space, so every public field declared after one lands at a different
offset in the consumer than in the bundle.

```polaron
// library
public class Box {
    private mutable long hidden;      // 8 bytes, invisible to the consumer
    public mutable int visible;
    public constructor Box() { this.hidden = cast<long>(0); this.visible = 42; }
    public method get() returns int { return this.visible; }
    public method peekHidden() returns long { return this.hidden; }
}

// consumer, built with --use boxlib.polb
Box b = new Box() on heap;
b.visible = 7;
// prints: consumer thinks visible=7;  the bundle says get()=42;  hidden=7
```

| | layout of `Box` | `visible` at |
|---|---|---|
| bundle | `{ ptr, i64, i32 }`, 24 bytes | index 2, offset **16** |
| consumer, from the `.polh` | `{ ptr, i32 }`, 16 bytes | index 1, offset **8** |

**Why this is the worst possible shape:**

- **Silent and self-consistent.** The consumer writes and reads the same wrong place, so from its side
  everything looks right. It is only visible by asking the bundle.
- **The fingerprint cannot catch it.** Both sides agree on the `.polh` text, so the divergence lives
  *inside* a matching fingerprint.
- **Encapsulation is violated by the ABI itself** — the consumer silently corrupted a private field it
  cannot even name.
- **No heap overflow**, verified: the consumer calls `@Box.__new()`, a factory the bundle provides, so
  the allocation size is the bundle's and is correct. Only field access is wrong. Methods are fine —
  they are the bundle's code.

**The irony:** the `.polh` already did the right thing for `affinity`, for exactly this reason, stated
in that file. The reasoning had been applied to one input of the layout and not the other.

**Why no test caught it:** the ABI tests cover vtable slots (`bundle_shape`) and fingerprint mismatch
(`polb_abi`). **No test reads a public field across a bundle boundary.** The hole in the suite maps
exactly onto the hole in the implementation.

## Gap 2 — nothing recorded *which layout rules* built the bundle. **Closed.**

`bundle.version` is the *library's* semver and `kFormatVersion` guards the container; neither says how
the code inside was laid out. A bundle built by an older `polc` loaded into a newer one with no check
at all, and any change to the layout algorithm between them went undetected — the fingerprint cannot
notice, because it verifies the interface, not the rules used to arrange it.

**What was added, and why it is not simply the compiler's version.** Two releases of `polc` with
identical layout rules must still link; one release that changes them must not. So the rules carry
their own number, `kAbiRevision`, declared in `polb.h` with the list of changes that must bump it —
field ordering, the vtable pointer, a `weak` field, a bit-field run, an array header, a String, a
region slot, the bytes reserved for a private field, or the receiver's position. It sits next to what
it describes, so it is visible to whoever changes them.

The bundle also records a `producer` string (`"polc 1.0.37"`). It is in the **message** and not in the
**test**: it names the culprit, it does not judge it. The container version went to 2, so a v1 bundle
is refused by the header rather than misread from the inserted field onward.

```
error: bundle 'x.polb' was built to ABI revision 1 and this compiler lays objects out to revision 2
(built by polc 1.0.37) -- rebuild the bundle from source. (The fingerprint matches: the two agree on
the declarations and disagree on the layout, which is exactly the case no header check can see.)
```

## Gap 3 — `layout` arrangements did not cross the boundary. **Measured, real, and closed.**

Not a hypothetical after all. **Implementing a `layout` authorizes the compiler to reorder a struct's
fields widest-alignment-first** (codegen's `orderForLayout`, a `stable_sort` on alignment), and the
trigger is merely *having* a layout — not what the layout asks for. The `.polh` emitted neither the
`layout` declaration nor the `implements` clause that named it, because `layouts.cpp` moves layouts out
of `interfaces` before the analyser runs and the header only ever emitted `interfaces`.

Measured on a struct declared `byte, int, byte, int`:

| | layout of `Tick` |
|---|---|
| bundle | `{ i32, i32, i8, i8 }` — widest first |
| consumer, from the old `.polh` | `{ i8, i32, i8, i32 }` — as declared |

Every field after the first read from the wrong offset, silently, both sides self-consistent: Gap 1
again, arrived at from a different direction.

**Fixed** by emitting the layout (as an empty arrangement — only the *fact* of it matters, since the
budget belongs to the library that had to satisfy it) and re-joining `c.layouts` to the `implements`
clause they were taken out of. Regression test `bundle_layout_order_runs`.

## Gap 4 — a public `weak` field crossed as a plain pointer. **Closed.**

`emitField` spelled ten modifiers and not `weak`. A `weak T*` is a `%WeakSlot = { ptr, ptr }` —
**sixteen** bytes, because the slot carries its place in the pointee's weak list so it can be nulled
when the pointee dies — so a consumer reserved eight where the object has sixteen and misplaced
everything after it. Measured: `{ ptr, %WeakSlot, i32 }` in the bundle against `{ ptr, ptr, i32 }` in
the consumer.

The reservation written for *private* weak fields already reserved two words for exactly this reason.
The rule was there and was not applied one line away from where it was written.

## Gap 5 — the header spelled `nullable` in syntax the parser cannot read. **Closed.**

`spellType` emitted a trailing `?` (`Cell*?`). **The parser has no trailing `?`** — it reads the
`nullable` keyword *before* the type and nothing else. So any bundle with a public nullable field
produced a header this compiler had written and could not read back, failing at

```
error: failed to parse the header of bundle 'x.polb'
```

which names the file and not the reason. Now spelled `nullable Cell*`, as the source does.

## The audit, and what it is worth

Gap 1 was found in twenty minutes with the first example that came to mind — and gaps 3, 4 and 5 came
straight out of auditing against one line:

> **Anything codegen uses to decide an offset must be in the `.polh`, or the `.polh` must carry the
> offsets themselves.**

Checked against that rule, and now crossing: field order (declaration order), `affinity`, `layout`
arrangements, bit-field widths, `weak`, and private fields as byte reservations. Also checked and
found harmless: statics (no instance storage), monomorphized generics (the consumer regenerates them
from the same template), and the vtable pointer (both sides root a class at `Object`, so both give it
one).

**Still unaudited:** deep inheritance chains where a base is imported and a derived class is local;
`union` members across the boundary; and whether a bit-field run that starts in an imported base and
continues in a local derived class packs the same way on both sides.

## One more reason to have written this down

**The 32-bit region-class pointer is, by definition, an ABI change** (see `region-classes.md`). It is
better to change a layout that is written down than one that is not.
