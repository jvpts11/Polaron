# Where the compiler and the spec disagree

*Survey, 2026-08-11. Everything below was **measured** — by probing the compiler or by reading the code
it actually runs — not inferred from the spec. Three states: **CORRIGIDO** (fixed today), **ABERTO**
(a real divergence, still there) and **POR MEDIR** (suspected from reading the source; not yet probed).*

The method matters, because it produced a result I did not expect. Grepping for a keyword cannot find a
feature nobody uses, and a behaviour test cannot see a feature that computes the right answer the wrong
way. Both traps fired today: `comptime` on a local was dead for as long as it has existed and no test
could have noticed, because a value computed at run time prints exactly like a value computed at
compile time. **The only instrument that finds these is a probe against the emitted code.**

---

## 1. The worst class: accepted and silently discarded

`parseMember` collects modifiers in ONE shared loop and hands a SUBSET to whichever declaration
follows — `parseMethod` took ten of them, `parseField` fifteen, and `parseConstructor`,
`parseDestructor` and `parseOperator` took **none**. Everything not handed over was dropped with no
diagnostic. `public eternal method f()` compiled and did nothing.

| | |
|---|---|
| **CORRIGIDO** | Every modifier the loop consumes is now checked against the declaration that followed it. A modifier that cannot be carried is an error naming where it belongs (`Parser::checkMemberModifiers`). |
| **CORRIGIDO** | Locals had the same disease in a different shape: a fixed sequence `[persistent\|eternal\|volatile\|lazy]*` then `[final\|mutable]`, so **`mutable volatile int x` handed `volatile` to the type parser and emitted a plain, non-volatile store**. Now one loop, same rules. |
| **ABERTO** | `override` on a **destructor** is accepted, dropped, and *used by the suite* (`cascade_inherited`). Either it means something and must be carried, or the sample should stop writing it. |
| **POR MEDIR** | `deprecated` on a **field** — `parseField` does not take it. Read from the source; not probed. |
| **POR MEDIR** | `in region X` on a **field** (§18.7) — the parser consumes it and the comment says outright *"Accepted; the field keeps its normal storage"*. If that is right, the placement clause is decorative on fields. |
| **POR MEDIR** | `eternal` on a **non-region** field. In codegen `isEternal` appears only in region paths, so it is likely inert everywhere else. |

## 2. §37 contradicted itself, three times

| | |
|---|---|
| **CORRIGIDO** | §37 said there are **six** universal prefixes. There are **seven** — `delegate` had no §37.x section at all, appearing only in the reserved-word list. Now §37.7b. |
| **CORRIGIDO** | §37.8 listed `comptime volatile` as a contradiction while §37.7, the section immediately above, gave `volatile comptime int MMIO_BASE` as a **valid composition example**. §37.7 is right: `comptime` says how the value was produced, `volatile` says how the storage is accessed. It is only a contradiction where there is no storage — on an expression or a method. |
| **CORRIGIDO** | §37.1, §37.2 and §37.3 wrote `snapshot of region world` as **language syntax**, while §32.2 said in as many words that there are no `snapshot`/`restore` keywords. |

## 3. §37.9 — the canonical order was fiction

The spec said *"compilador impõe ordem canônica"*. It imposed nothing. Worse, the order it printed was
contradicted by the language's own corpus in four independent pairs, with **zero** counter-examples:

| a §37.9 dizia | o código escreve | onde |
|---|---|---|
| `mutable persistent` | `persistent mutable` | 5 amostras |
| `mutable transient` | `transient mutable` | amostra |
| `comptime static` | `static comptime` | 5 amostras + 10 no pico |
| `volatile mutable` | `mutable volatile` | pico |

The reason it was never followed is visible once you look for it: **the old order was not organized by
anything** — the three lifetime words were split apart, with `static` and `mutable` between them.

**CORRIGIDO.** New order, one question per group, enforced: *visibility → deprecation → foreignness →
binding → lifetime → access → mutability → compilation → ownership → concurrency → placement*. Every
group boundary was measured (`mutable weak` ×18, `static async` ×14, `static comptime` ×15,
`extern cdecl static` ×13, `unknown sysv naked static` ×15). Total cost of adoption across all existing
Polaron: **four declarations**.

The order also revealed a second bug while being decided: the local parser only accepted `volatile`
before `mutable`, which is why `volatile` sits before `mutable` in the final order — the grammar had
already voted.

## 4. §37.8 — invalid combinations, one of three implemented

| | |
|---|---|
| **CORRIGIDO** | `mutable final` was rejected only **by accident**: the local parser stopped after `final`, so `final mutable int x` failed with *"expected a type but found 'mutable'"* — a message that explains the parse and not the mistake. Now the contradiction is checked in both orders, on fields and locals, with the spec's own wording. |
| já ok | `persistent transient` — checked, with a good message. |
| **CORRIGIDO** | `comptime volatile` — was in the list and should not have been (see §2). |

## 5. §37.4 — `comptime` was parsed, stored, and read by nobody

`comptime int a = Main.fib(10);` emitted **`call i32 @Main.fib(i32 10)`** and stored the result. The
prefix's one promise is *"zero overhead em runtime — valor calculado embutido no binário"*.

| | |
|---|---|
| **CORRIGIDO** | Locals: the analyzer now requires the initializer to fold (beside where a `fixed` initializer is already checked) and codegen embeds the constant. Regression test `codegen_comptime_local_folds` is an **IR test on purpose** — a behaviour test cannot see this bug. |
| **CORRIGIDO** | Fields: `FieldDecl` had no `isComptime` at all. Added, with the same guarantee. Not redundant with `fixed`: `fixed` is a class constant with no storage and no `mutable`; `comptime` qualifies the *initializer* of an ordinary field. |
| **CORRIGIDO** | Two folders disagreed: `constFold` (codegen) cannot call a `comptime` method and `foldConstInt` can, so **Polaron-0608 rejected an initializer the analyzer had evaluated one pass earlier**. |
| **ABERTO** | `comptime` as an **operation** prefix (§37.9 promises `[cascade] [lazy] [comptime] <operação>`). `comptime if` works; a bare `comptime <call>` does not. |
| **ABERTO** | `lazy` as an operation prefix — same line of §37.9, not implemented. |

## 6. §37.1 — `cascade` was under-reported, by me

I probed `cascade` once with an arbitrary method call, saw it refused, and wrote "only delete" into
§37.11. That was wrong and is corrected. Measured:

| operação | estado |
|---|---|
| `delete`, `move` (19.8), `clone X into Y`, `validate(x)`, `Console.println(x)`, `release [persistent] x`, `unimport T` | ✅ |
| `(depth:)` / `(except:)` / `(types:)` | ✅ |
| `cascade release region r` | **CORRIGIDO** — now refused *with the reason*: releasing a region already runs its objects' destructors, which release the regions those objects own. |
| `cascade w.snapshot()` | blocked on §5 below |
| `cascade map(items, transform)` | never — needs a transformation as a value, which the language does not have |
| `cascade reverse x.move()` | needs an undo system that is not designed |

## 7. §32.2 — snapshots did not exist at all

`RegionSnapshot` appeared nowhere in the prelude and `region` had no `snapshot()` method.

| | |
|---|---|
| **CORRIGIDO (runtime)** | `__polaron_region_snapshot_size` / `__polaron_region_snapshot` / `__polaron_region_restore` in `runtime/polaron_region_core.hpp`, verified compiling hosted (MSVC) and bare metal (clang) with the right unmangled symbols. Restore runs destructors first; refuses a `growable` region; refuses to restore over an object deleted by hand since the capture; refuses to write past the destination. |
| **CORRIGIDO (design)** | §32.2 rewritten with João's decision: `snapshot`/`restore` are **soft** keywords, a snapshot is a **copy** (so it works with any flavor), its address is **mandatory** in a named region, it is **constant**, and it is **not** released automatically. |
| **CORRIGIDO (surface)** | All three forms work end to end — `RegionSnapshot k = snapshot region W in region B;`, `snapshot region W into k;`, `restore k into [region] W;`. Test `codegen_region_snapshot_runs`. |
| **NOTE** | `RegionSnapshot` cannot be a prelude `typealias` inside `namespace Memory`: adding one there breaks `System.Memory.Units.kilobytes` resolution (measured — 4 tests fail). It is mapped to `address` in `ast::canonicalType`, the one place the analyzer and codegen both ask what a type is called. |
| **ABERTO** | The home region must be `pool`, `fixedslot` or `stack`. A plain (bump) region has no per-slot header — that absence is what makes its allocation cost what a hand-written arena costs — so placing a snapshot in one used to be an access violation. It is now a named panic **at run time**; it should be a compile-time error, since the flavor is on the declaration. |
| **ABERTO** | The two semantic rules João specified are not enforced yet: a snapshot is **constant** (`mutable RegionSnapshot` should be an error — it has a home in `checkMemberModifiers`) and its release is **mandatory** (definite release, the same analysis a `region` field needs). |
| **TRAP** | `snapshot`/`restore` must be **soft** keywords: pico already has a `restore()` method (`hardware.pol`, `font.pol`) that puts the video mode back. A hard keyword breaks the kernel. |

## 8. Fixed before today, listed so the record is one place

| | |
|---|---|
| `itself` | Documented as a general self-reference pronoun; only worked before `.allocate`/`.at`/`.atMultiple`. Fixed 2026-08-03 — and it made recursive anonymous methods possible, which no spelling allowed before. |
| freestanding + stdlib | The docs said the stdlib cannot be used freestanding. The real restriction is **five language features** (async/await, unimport/reimport, exceptions, string interpolation, reflection) — the library was never the problem. §36.3 rewritten. |
| persistents freestanding | `guide/01:330` said they do not work. The named form always emitted a private global with zero external symbols; only the **indexed** form needed a runtime, which now exists bare metal. |
| contract values | Guards and contracts printed their clause but not their numbers bare metal. One `__polaron_fail` for both targets now. |

---

## 9. Found 2026-08-14, closing the transformer gaps

### 9.1 The two that are still ABERTO

**`private` IS NOT ENFORCED ANYWHERE.** Member visibility is written, carried, published in the
`.polh` and shown in the generated docs — and never checked. This compiles and links today:

```polaron
public class Dog   { private method secret() returns int { return 5; } }
public class Other { public method probe() returns int { return new Dog().secret(); } }
```

Probed directly, both classes in the same namespace. It is not specific to transformers; it is every
member of every kind. **TYPE** visibility *is* checked (`checkTypeAccessible`, the stdlib-cohesion
rule), which is what makes the hole easy to miss — the word works at one level and not the other.

The consequence for transformers is worth stating precisely, because a rule was just written on top
of it: a procedure now enters the applying class **private by default** (spec 32.12). That is right on
the declaration, it is what the header and the documentation show, and it is what will be enforced the
day member visibility is — but today it denies nobody. Enforcing it reaches the prelude, pico and
decomp at once, so it is a decision, not a patch.

**`polaron build` CANNOT DO A HOSTED CROSS BUILD FOR ANY TARGET.** The driver hands the linker the
HOST's `libpolaron_rt.a`, and the runtime source is not embedded (only the region and alloc cores
are), so it cannot rebuild it for the target. aarch64 fails identically to m68k. The suite's cross
rows pass because they cross-compile the runtime themselves. Fixing it means either embedding
`polaron_rt.cpp` in the driver the way the two cores already are, or looking for a per-target
`libpolaron_rt-<triple>.a` beside the host one and saying clearly what to build when it is absent.

Also worth knowing while you are in there: the manifest's cross target lives in **`[build] target`**,
not `[program]`, and `--target=` on the command line is forwarded to polc only — so passing it there
gives you target IR and a host link.

### 9.2 CORRIGIDO, with the reason each one survived

| | |
|---|---|
| **the union row of the totality table** | It was not an omission — the FIELD rule ran over unions and demanded that a conversion read every one. A union's fields share one storage and nothing tags which is live, so the rule demanded a bug. A union's source is **open**, like an `int`. |
| **a freestanding `heap class` stopped linking** | The driver decided whether to supply a bare-metal allocator by looking for the NAME `__polaron_malloc` in the IR — and saw the definition codegen emits from the program's own `heap class`, supplying a second. `duplicate symbol`, on the one kind of program the shim exists to leave alone. **The suite was 100% green**: the freestanding tests either inspect the IR or boot under QEMU, and a duplicate symbol is not a property of one module. New test `port_freestanding_heap_class_links` asserts only that it LINKS, which is where the class of defect lives — and therefore needs no emulator. |
| **`call T.p()` in a `record` leaked** | Never drained from the parser's pending list, so every site was attributed to whichever declaration was parsed NEXT — the three rules `call` carries, checked against the wrong type's `applies` clause, in both directions. |
| **a procedure's visibility was backwards** | Built as "visibility governs `call`". It is the visibility the member **enters the applying class with**, and procedures are private by default — a reading under which the old rule would disable `call` in the ordinary case. See `docs/design/transformers.md`. |
| **five promises the note made and the compiler did not keep** | `freestanding transformer` did not parse at all; `final procedure` sealed nothing; the subject rule for a static procedure was checked by nothing; an `enum` could not apply a transformer (so the flagship `Errno → int` was unwritable, and the enum row of the totality table had never bitten); a transformer could not cross a bundle. |

---

## The pattern worth keeping

Six of the divergences above are the same shape: **the compiler accepts something and does nothing with
it**. Not a wrong answer — no answer, and no complaint. That shape survives every kind of test a project
normally has, because the program still runs and still prints what it printed before.

The rule that came out of it, and that §37 now states: **a prefix the spec calls universal has to either
work or say why not. Silence is the one answer it must never give.**
