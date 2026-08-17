# Standard Library — What reflection gives you for free

`import System.Data.Serializer;` · `import System.Data.Validator;` · `import System.Data.Services;`

Four libraries that would be code generators, macros or annotation processors in another language,
and are ordinary Polaron here because the language can **read its own types at run time**. Each is a
few hundred lines, each works on any type, and none of them asks you to write a line of glue.

They are grouped on one page because they are one idea: *the type already says this; stop saying it
again.*

---

## 1. `Serializer` — JSON from the fields themselves

```polaron
import System.Data.Serializer;

[Serializable]
public class Order {
    public mutable int id;
    public mutable String customer;
    public mutable double total;
}

String text = Serializer.text<Order>(order);       // {"id":7,"customer":"Ana","total":19.5}
Json shape = Serializer.of<Order>(order);          // or the tree, to add to
```

| Member | What it does |
|---|---|
| `Serializer.of<T>(T value) returns Json` | The value as a JSON tree, field by field, following nested objects and lists. |
| `Serializer.text<T>(T value) returns String` | The same, printed. |
| `[Serializable]` | Marks a type as intended for this. Not required to make it work — required to say you meant it. |
| `Schema.of<T>() returns String` | The shape rather than a value: the field names and their types, for a document, a contract test, or the other end of a wire. |

No macro, no generated file, no build step. Add a field and it is serialised; rename one and the
output follows; delete one and nothing anywhere still mentions it.

## 2. `Validator` — the rules live on the field

```polaron
import System.Data.Validator;

public class Signup {
    [NotEmpty] [Length(min: 3, max: 32)] public mutable String user;
    [Email]                              public mutable String mail;
    [Range(min: 18, max: 120)]           public mutable int age;
    [Positive]                           public mutable double credit;
    [Chars(allow: "0123456789-")]        public mutable String phone;
}

Findings bad = Validator.check<Signup>(form);
if (bad.any()) { ... }
```

| Annotation | Holds |
|---|---|
| `[NotEmpty]` | A string with something in it. |
| `[Length(min, max)]` | A string's length, inclusive. |
| `[Range(min, max)]` | A number's value, inclusive. |
| `[Positive]` | Greater than zero. |
| `[Email]` | Shaped like an address. |
| `[Chars(allow)]` | Every character drawn from a set. |

`Validator.check<T>` walks the type's fields, reads their annotations and answers `Findings` — which
names the field and the rule it broke, not a boolean. A form with three bad fields reports three
findings, because "invalid" is not a message anybody can act on.

## 3. `Services` — dependency injection, no container configuration

```polaron
import System.Data.Services;

public class Repo { ... }
public class Api {
    [Inject] public mutable Repo* repo;      // filled in by the container
}

Services* box = new Services() on heap;
box.provide<Repo>();
nullable Object made = box.build<Api>();
if (!box.complete()) { ... }                 // something asked for what nobody provides
```

| Member | What it does |
|---|---|
| `provide<T>()` | Registers a type the container can build. |
| `build<T>() returns nullable Object` | Builds one, filling every `[Inject]` field from what is registered. |
| `complete()` / `unwiredCount()` | Whether every injection point was satisfied — asked rather than assumed, because a half-wired object fails later and somewhere else. |

## 4. `Compare` — equality and a diff, field by field

`Compare.equal<T>(a, b)` answers whether two values of any type match on every field, and
`Compare.diff<T>(a, b)` says **which fields differ and what each holds** — the sentence a failing
test wants instead of "expected X, got Y" over two objects nobody can read.

---

## 5. `Arena` — a container with a typed region

```polaron
import System.Memory.Arena;

Arena* work = new Arena(64 kilobytes) on heap;     // accepts: what may live here
```

An arena is a region with the container's manners: many objects, one lifetime, one release. Its
`accepts` clause is checked **on the field**, so a type the arena was not built for cannot be
allocated into it — the region binder's rule, applied where a library holds the region rather than
where a method declares one.

---

## 6. Persisted state — `Memo` and `EventLog`

Two `persistent` types: their contents survive a `reimport` of the code that uses them, which is what
persistents are for.

| Type | Members |
|---|---|
| `Memo` | A cache that outlives the code: `remember(key, value)`, `has`, `get`, `size`, `hits`, `misses`, `discard`. Reload a function and its memo table is still warm. |
| `EventLog` | An append-only log with a schema version: `append(kind, value)`, `size`, `kindAt`, `valueAt`, `version`, and `replay(combine, initial)` to fold it. Change the code that reads the events, keep the events. |

---

## 7. Where the annotations themselves are documented

How to declare and read your own annotations, and the reflection API these are built on
(`Type.of`, `fields()`, `get`/`set`, `annotations()`), is
[§10 Compile-Time, Reflection & Universal Prefixes](../guide/10-metaprogramming-and-prefixes.md).
