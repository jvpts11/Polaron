# 13. Diagnostics

Every error and warning the Polaron compiler emits carries a stable code — `Polaron-NNNN` — and,
by default, a short explanation of *what* went wrong, *why*, *how to fix it*, and *how to
avoid it next time*. The goal is that a diagnostic teaches rather than just scolds: you
should rarely have to search the web to understand a Polaron error.

## 13.1 Anatomy of a diagnostic

A rich diagnostic (the default) looks like this:

```
error[Polaron-0101]: use of undeclared variable 'coutn'
  --> game/Board.pol:42:17
      |
   42 |         return coutn;
      |                ^^^^^ not declared in this scope
      |
 why:     A name must be declared before it is read -- as a local (var/mutable), a
          parameter, a field (via this.), or a namespace constant. This name matches
          nothing visible here, which is almost always a typo or a missing declaration.
 fix:     If it is a typo, use the suggested name ('count'). Otherwise declare it before
          this point, e.g. `mutable int coutn = ...;`.
 prevent: Let the editor autocomplete names. Forge's live check flags an undeclared name
          as you type, and Alt+Enter applies the suggested fix.
```

The parts:

- **`error` / `warning`** — the severity. Warnings do not stop the build.
- **`[Polaron-NNNN]`** — the stable diagnostic **code**. It never changes for a given kind of
  problem, so it is safe to search for, suppress-by-policy, or look up with `polaron explain`.
- **the title** — the specific problem, naming the actual identifiers/types involved.
- **the source span** — file, line, column, and a caret (`^^^`) under the exact tokens.
- **why / fix / prevent** — the canonical explanation for that code. This wording is written
  once, in the compiler's diagnostic catalog, so it is identical wherever the code appears:
  the terminal, `polaron explain`, and Forge's hover.

### Concise mode

Rich output is the default. For dense build logs or CI, pass `-q` (quiet) to get the
one-line form and drop the why/fix/prevent block:

```
game/Board.pol:42:17: error[Polaron-0101]: use of undeclared variable 'coutn'
```

## 13.2 `polaron explain`

To read the full why / fix / prevent for a code without triggering it, ask the driver:

```
polaron explain Polaron-0101      # the canonical explanation for one code (use the full Polaron- code)
polc --explain             # list every code the compiler knows
```

`polaron explain` forwards to the compiler, which owns the catalog, so the text is always in
sync with the version you have installed.

## 13.3 Code ranges

Codes are grouped by the compiler phase that raises them. The ranges are stable; individual codes are
added over time.

| Range  | Phase / area |
|--------|--------------|
| `00xx` | Lexing & syntax |
| `01xx` | Name & type resolution |
| `02xx` | Visibility |
| `03xx` | Type checking |
| `04xx` | Mutability & ownership |
| `05xx` | Flow & exhaustiveness |
| `06xx` | Declarations & inheritance |
| `07xx` | Literals, interpolation & bit widths |
| `08xx` | Feature-specific semantics (operators, reflection, regions, vectors, unimport, atomics, interrupts, transformers, tests) |
| `09xx` | Freestanding mode |
| `0Axx` | Not implemented yet |
| `0Bxx` | Warnings |
| `17xx` | Regions: flavors, operations, and the region binder |

## 13.4 Every code

The complete list, with the one-line title each carries. The **why / fix / prevent** for any of them is
in the compiler — `polaron explain Polaron-0405` prints it — because writing that text twice is how the
two copies come to disagree.

| Code | Title |
|------|-------|
| `Polaron-0001` | unexpected syntax here |
| `Polaron-0002` | cannot read this text |
| `Polaron-0101` | not declared in this scope |
| `Polaron-0102` | no such field on this type |
| `Polaron-0103` | no such method on this type |
| `Polaron-0104` | unknown type |
| `Polaron-0105` | no such name |
| `Polaron-0106` | this name was brought in under a different path |
| `Polaron-0201` | not accessible from here |
| `Polaron-0300` | null where a value is required |
| `Polaron-0301` | wrong type here |
| `Polaron-0302` | wrong number of arguments |
| `Polaron-0303` | return type does not match |
| `Polaron-0304` | argument type does not match the parameter |
| `Polaron-0305` | this cast is not allowed |
| `Polaron-0306` | cannot index this |
| `Polaron-0307` | operator applied to the wrong type |
| `Polaron-0307b` | type argument does not satisfy the bound |
| `Polaron-0401` | this is not mutable |
| `Polaron-0402` | used after it was moved |
| `Polaron-0403` | this cannot be moved |
| `Polaron-0404` | cannot assign to this |
| `Polaron-0405` | a movable value is transferred, never copied — say so |
| `Polaron-0406` | `weak` describes a reference, and this is not one |
| `Polaron-0501` | not all paths return a value |
| `Polaron-0502` | match does not cover every case |
| `Polaron-0503` | `try?` needs a Result/Option method |
| `Polaron-0504` | `try?` propagates a failure this method cannot carry |
| `Polaron-0601` | already declared |
| `Polaron-0602` | duplicate field |
| `Polaron-0603` | duplicate member |
| `Polaron-0604` | inheritance cycle |
| `Polaron-0605` | cannot extend this type |
| `Polaron-0606` | cannot override a final method |
| `Polaron-0607` | these modifiers contradict each other |
| `Polaron-0608` | this static field's initializer has no value before the program starts |
| `Polaron-0609` | this program has nowhere to start |
| `Polaron-0610` | a class has one constructor, and this is the second |
| `Polaron-0611` | this name already belongs to a type the compiler provides |
| `Polaron-0612` | this field is left with no value by the constructor |
| `Polaron-0701` | bad literal suffix |
| `Polaron-0702` | cannot interpolate this value |
| `Polaron-0703` | printf needs a literal format string |
| `Polaron-0704` | this value does not fit the bits the field was given |
| `Polaron-0801` | malformed operator overload |
| `Polaron-0802` | reflection used incorrectly |
| `Polaron-0803` | region used incorrectly |
| `Polaron-0804` | vector/matrix operation is malformed |
| `Polaron-0805` | unimport/reimport used incorrectly |
| `Polaron-0806` | demand |
| `Polaron-0807` | this must be a compile-time constant |
| `Polaron-0808` | a persistent is never released |
| `Polaron-0809` | this is wider than the machine can do atomically |
| `Polaron-0810` | an interrupt is entered, not called, and it runs where almost nothing is safe |
| `Polaron-0811` | this transformer's contract is not met here |
| `Polaron-0812` | this annotation cannot go on this method |
| `Polaron-0901` | not available in freestanding mode |
| `Polaron-0A01` | not implemented yet |
| `Polaron-0B01` | this name reads against the convention the rest of the language follows |
| `Polaron-0B02` | the standard library already has a type with this short name |
| `Polaron-0B03` | this local hides a field of the same name |
| `Polaron-0B04` | this exception leaves the method without being declared |
| `Polaron-0B05` | a pointer to a class usually points at one object, not at an array |
| `Polaron-0B06` | this changes a copy, and the caller will not see it |
| `Polaron-0B07` | the calling convention and the symbol it binds do not agree |
| `Polaron-0B08` | this still works and is not going to keep working |
| `Polaron-0B09` | these persistents will be told apart by identity, not by their contents |
| `Polaron-0B0A` | this test reads a fixture whose setup it does not run |
| `Polaron-0613` | this does not match how the annotation was declared |
| `Polaron-0B0B` | this builds a String by re-copying it on every iteration |
| `Polaron-0B0C` | this [Allow] never suppressed anything |
| `Polaron-0B0D` | nothing ever assigns to this, so `mutable` claims a freedom it does not use |
| `Polaron-0B0E` | this `catch` neither handles the failure nor lets anyone know it happened |
| `Polaron-0B0F` | this method is `async` and never awaits anything |
| `Polaron-0B10` | this class is only static methods, which is a namespace with a class round it |
| `Polaron-0B11` | this is public fields with no methods and no invariant, which is a record |
| `Polaron-0B12` | these constants share a prefix, which is a set being kept by hand |
| `Polaron-0B13` | this is an instance method with the receiver written out |
| `Polaron-0B14` | this name spells a type the declaration already gives |
| `Polaron-0B15` | this has a default over a set whose members the compiler already knows |
| `Polaron-0B16` | these branches all compare the same thing, one after another |
| `Polaron-0B17` | this number is written out several times in one method |
| `Polaron-0B18` | this try raises and catches its own exception |
| `Polaron-0B19` | this call returns a Result or Option and the statement drops it |
| `Polaron-0B1A` | this is allocated on the heap and deleted in the same block |
| `Polaron-0B1B` | this cleanup is repeated before more than one return |
| `Polaron-0B1C` | this throw is inside a loop |
| `Polaron-0B1D` | every subtype of this is in this program, and the declaration does not say so |
| `Polaron-0B1E` | this abstract class has exactly one subtype |
| `Polaron-0B1F` | the destructor frees this field, and the declaration does not say it owns it |
| `Polaron-0B20` | several methods here open by checking the same thing about this object |
| `Polaron-0B21` | this returns a boolean and writes its real answer through a parameter |
| `Polaron-0B22` | this public method opens by rejecting its argument |
| `Polaron-0B23` | this compares a non-nullable value against null |
| `Polaron-0B24` | several parameters of one primitive type, which any order will satisfy |
| `Polaron-0B25` | these static arrays are one row read sideways |
| `Polaron-0B26` | this converts to and from another type by hand |
| `Polaron-0B27` | this loop allocates and frees on every iteration |
| `Polaron-0B28` | this allocates a bigger array, copies into it, and frees the old one |
| `Polaron-1710` | a region has exactly one flavor |
| `Polaron-1711` | a fixedslot/ring region needs its single element type |
| `Polaron-1712` | growable does not apply here |
| `Polaron-1713` | mark/rollback need a stack region |
| `Polaron-1714` | this checkpoint belongs to another region |
| `Polaron-1715` | a ring region auto-evicts; individual delete is not allowed |
| `Polaron-1717` | use of a variable after it was extracted from its region |
| `Polaron-1718` | cannot extract an object whose field lives in the same region |
| `Polaron-1719` | a flavor modifier only qualifies a region |
| `Polaron-1720` | an `extract` result must be bound |
| `Polaron-1721` | this hands out a pointer to storage that is about to disappear |
| `Polaron-1722` | nothing in the program says which of these two dies first |
| `Polaron-1723` | past this point there is no proof to be had |
| `Polaron-1724` | what this holds was freed by an earlier call |

## 13.5 In the editor

Forge surfaces the same codes end to end. Its live checker runs the compiler on the unsaved
buffer, so diagnostics appear as you type; hovering a squiggle shows the code's why/fix/prevent
(the same catalog text), **Alt+Enter** applies a suggested quick-fix where one exists, and
**Ctrl+F1** runs `polaron explain` on the diagnostic under the caret.
