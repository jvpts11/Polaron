# `enum`, completed — variants with payloads

> **Status.** Designed, not implemented. **No new keyword.** This is `enum` reaching the case it was
> always the shape of.
>
> **This document was first written on a false premise** — that `Result`/`Option` needed to be made
> value types. They already are. §2 records what was measured instead, because the correction is more
> useful than the proposal was.

---

# Part I — Why

## 1. What was assumed, and what is actually there

The ledger recorded AP-21 like this:

> `Ok`/`Err` are **heap classes**: 672 bytes of vtable and `__polaron_malloc(16)` on every fallible
> return — so the recommended alternative demands the facility bare metal may not have.

None of that is a property of the language. `src/parser/parser.cpp` §`rewriteVariantCtor`:

> *"The `*` picks the representation (spec 21, value form): `Result<T,E>` (no star) builds a **value
> tagged union** (location `"value"` — no heap, no delete); `Result<T,E>*` keeps the boxed heap class.
> A payload that does not fit the value form's 64-bit slot stays boxed for now: a pointer/ref, a
> `Decimal` (i128), or a tuple. **Sized payloads are deferred.**"*

And `docs/design/polaron-ir.md` §7.12 already gives it a node:

```
variant.make T, tag, payload   -> variant
variant.tag  %v                -> int<32>
variant.payload %v, case       -> T
```

> *"`catalog`, an `enum` with data, a `union` and the value form of `Option`/`Result` are all this."*

## 2. What was measured — and it is a PIR defect, not a design gap

AP-21's own program, `parse_freestanding.pol`, compiled both ways:

| the same source | `__polaron_malloc` | vtable globals |
|---|---|---|
| **trusted backend** (`POLARON_VIA_PIR=0`) | 2 | **0** |
| **PIR** (the default) | 4 | **64** |

And a minimal isolate, `Port.read() returns Result<int, Fault>`:

```
trusted:  define internal %__polaron_variant @Port.read     -- 0 allocations
PIR:      define internal ... ptr @Port.read                -- 2 allocations
```

The cause is one line, `src/pir/lower.cpp:20860`:

```cpp
} else if (n.blank || n.location == "heap" || n.location == "value" || returningNew_) {
```

`"value"` sits in the same branch as `"heap"`, so PIR allocates what the trusted path returns in
registers.

**This is the fourth PIR defect of the same family** — after the per-iteration `malloc`, the array
stride computed from the sum of field sizes, and the array leaked through a field. And the
differential oracle missed it for the fourth time, for the same reason every time: **the output is
identical.** No stronger argument exists for comparing `Test.liveBytes()` at exit.

**AP-21's finding is wrong in its cause** and belongs on the PIR defect list, not the language list.

## 3. The two gaps that are real

**3.1 A user cannot write their own value sum.** `Result` and `Option` are special-cased by name in
the parser — `rewriteVariantCtor` matches the identifiers `Ok`, `Err`, `Some`, `None` and rewrites
against the expected type. Anyone wanting their own `Parsed<T>`, `Either<A,B>` or `Token` writes a
sealed class hierarchy and pays a vtable and a heap object per value.

**3.2 Sized payloads are deferred.** A payload beyond the 64-bit slot — a struct, a tuple, a
`Decimal`, a pointer — still boxes, on **both** backends. `Result<BigStruct, Fault>` allocates.

Both are the same missing thing: **`enum` cannot carry a payload chosen at construction.**

## 4. What the language has, and the hole

| | |
|---|---|
| `enum` simple | int constants |
| `enum` Java-style | constants whose data is **frozen at the declaration** — `EARTH(5.972e24, 6.371e6)` |
| `catalog` | an interface for enums: required shape and required values |
| `union` | shared storage, **no tag** |
| `sealed ... permits` | a closed set of **classes** |
| `Result` / `Option` | a value tagged union — **built in, by name, in the parser** |

The last row is the tell: the language has exactly one value sum, and it is hard-coded.

---

# Part II — The design

## 5. `enum` is extended — **DECIDED**

```polaron
public enum Result<T, E> {
    Ok(T value),
    Err(E error);
}

public enum Option<T> {
    Some(T value),
    None;
}

public enum Token {
    Number(long value),
    Word(String text),
    End;
}
```

`Result` and `Option` stop being special cases in the parser and become two declarations like anyone
else's — which is the point: whatever they get, a user's own sum gets.

### 5.1 This is completion, not conflation

`EARTH(5.972e24, 6.371e6)` is already **a variant with a tag and a payload** — the payload merely
happens to be frozen at the declaration. `Some(x)` is the same variant with the payload not yet
frozen. They are one thing, and today's `enum` is the frozen special case.

That is why extending `enum` does not give a word a second meaning: it always meant *a closed set of
named cases*, and the cases are being allowed to carry what the PIR node was already built for.

### 5.2 The two case forms are distinguishable by their own grammar

A frozen case takes **arguments**; a parameterised case declares **parameters**:

```polaron
EARTH(5.972e24, 6.371e6)     // expressions -- frozen
Ok(T value)                  // a type and a name -- a shape
```

### 5.3 Alternatives considered

| | why not |
|---|---|
| `sealed struct Result<T,E> permits Ok, Err` | the words exist and mean *closed set*, but a `struct` cannot `extends` (*"it has no vtable to inherit through"*), so the variant-to-sum relationship has no spelling |
| a new construct | inventing where the language already has the word |

## 6. The representation rule, per case

> **The value of an enum is its tag. A payload is carried in the value only when it is not frozen.**

| case form | where the payload lives | the value is |
|---|---|---|
| no payload — `RED` | nowhere | the tag |
| **frozen** — `EARTH(5.972e24, 6.371e6)` | a **static table indexed by tag**, one copy for the program | the tag |
| **parameterised** — `Ok(T value)` | inline in the value | tag + payload |

An enum's size is `tag + max(inline payloads)`. An enum with no parameterised case is therefore the
tag alone — today's int-style enum, generalised rather than special-cased.

This is also what lifts §3.2: the inline payload is sized per instantiation after monomorphisation,
rather than having to fit one 64-bit slot the parser reserved.

## 6.1 What this does to the Java-style enum: nothing, and it gets smaller

Everything it is stays: `EARTH` still names a constant nobody constructs, `mass` and `radius` still
read off it, methods still work, `==` still answers what identity answers today, ordinals and
iteration are unchanged.

Only the representation changes, in three ways, all improvements:

1. a `Planet` variable is **4 bytes**, where today it is an 8-byte pointer to a heap singleton;
2. `mass` becomes a load from a static table at index `tag` — no indirection through an object;
3. **an open double-free disappears rather than being fixed.** `delete` of an array of Java-style
   enum values double-frees the singletons today. With no singletons there is nothing to free twice.

## 7. Mixing frozen and parameterised cases is allowed

An earlier draft proposed refusing the mix. That is wrong for a concrete reason: **`Option` is itself
a mix** — `None` carries nothing, `Some(T value)` is parameterised. Refusing it would refuse one of
the two types the feature exists for. And there is no mechanism reason, because §6's rule is per
case.

## 8. What survives, and what changes

### 8.1 The property `Errors.pol` protects survives — by a different mechanism

> *"Written on the ABSTRACT BASE where the answer is the same for both variants, and overridden where
> it differs — so `match` and these agree by construction rather than by being kept in step, and **a
> variant added later cannot forget one**."*

On a value sum the methods become one body with a `match` inside rather than an override per variant.
**The guarantee survives through exhaustiveness instead of through override**: adding a `Timeout`
case makes the `match` stop compiling, exactly as a missing override does today.

### 8.2 What genuinely changes: equality

`Ok(5) == Ok(5)` is **false** today for the boxed form — two objects, compared by identity. As a
value it is **true**. That is the right answer for a value type and it is a behaviour change to be
written down rather than discovered.

## 9. Decided

| | |
|---|---|
| `enum` is the construct that is extended | §5 |
| `Option<T>` and `nullable T` **both stay** | they cost the same and say nearly the same thing; both kept deliberately |
| `try?` is unchanged | nothing in it depended on object identity |
| Java-style enums **may become values, and must not stop being what they are** | §6.1 is how both hold |
| frozen and parameterised cases may be mixed | §7 |

## 10. Still to design

| | |
|---|---|
| 10.1 | **generic enums.** `enum Result<T, E>` needs type parameters on an enum, which today's `enum` does not have. Monomorphisation then fixes each instantiation's payload size — which is what lifts §3.2 |
| 10.2 | `match` over an enum with payloads — destructuring exists (positional, spec 16.2); confirm it reads `variant.tag` and `variant.payload` rather than a vtable |
| 10.3 | equality (§8.2) — decided in principle; confirm what `==` does when a parameterised payload is itself a class |
| 10.4 | `catalog` over an extended enum. A catalog *"forces both the shape and the specific values the enum must contain"* — what a required *value* means when a case is parameterised |
| 10.5 | the boxed form. `Result<T,E>*` keeps the heap class today, and both forms coexist by design. Confirm the class survives the change, or that `*` over an enum means something |

## 11. What this adds to the language

**Nothing.** No new keyword, no new construct.

That is the fifth time in this round of design that the answer was a word the language already had,
penned into one context — after `comptime` (statements), `permits` (layout concessions), `unique`
(value types) and `move` (destinations). And the sixth thing found was not a gap at all: `Shared`
(`docs/design/ownership.md` §13) and the value form above were both already built.
