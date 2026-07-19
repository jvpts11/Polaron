# 12. Diagnostics

Every error and warning the LDP3 compiler emits carries a stable code — `LDP3-NNNN` — and,
by default, a short explanation of *what* went wrong, *why*, *how to fix it*, and *how to
avoid it next time*. The goal is that a diagnostic teaches rather than just scolds: you
should rarely have to search the web to understand an LDP3 error.

## 12.1 Anatomy of a diagnostic

A rich diagnostic (the default) looks like this:

```
error[LDP3-0101]: use of undeclared variable 'coutn'
  --> game/Board.ldp3:42:17
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
- **`[LDP3-NNNN]`** — the stable diagnostic **code**. It never changes for a given kind of
  problem, so it is safe to search for, suppress-by-policy, or look up with `ldp3 explain`.
- **the title** — the specific problem, naming the actual identifiers/types involved.
- **the source span** — file, line, column, and a caret (`^^^`) under the exact tokens.
- **why / fix / prevent** — the canonical explanation for that code. This wording is written
  once, in the compiler's diagnostic catalog, so it is identical wherever the code appears:
  the terminal, `ldp3 explain`, and Forge's hover.

### Concise mode

Rich output is the default. For dense build logs or CI, pass `-q` (quiet) to get the
one-line form and drop the why/fix/prevent block:

```
game/Board.ldp3:42:17: error[LDP3-0101]: use of undeclared variable 'coutn'
```

## 12.2 `ldp3 explain`

To read the full why / fix / prevent for a code without triggering it, ask the driver:

```
ldp3 explain LDP3-0101      # the canonical explanation for one code
ldp3 explain 0101           # the LDP3- prefix is optional
ldp3 explain                # list every code the compiler knows
```

`ldp3 explain` forwards to the compiler, which owns the catalog, so the text is always in
sync with the version you have installed.

## 12.3 Code ranges

Codes are grouped by the compiler phase that raises them. The ranges are stable; individual
codes are added over time.

| Range   | Phase / area                     | Examples |
|---------|----------------------------------|----------|
| `00xx`  | Lexing & syntax                  | `0001` unexpected syntax · `0002` cannot read this text |
| `01xx`  | Name & type resolution           | `0101` undeclared name · `0102` no such field · `0103` no such method · `0104` unknown type |
| `02xx`  | Visibility                       | `0201` not accessible from here |
| `03xx`  | Type checking                    | `0301` wrong type · `0302` wrong number of arguments · `0303` return type mismatch · `0305` cast not allowed · `0307` operator on the wrong type |
| `04xx`  | Mutability & ownership           | `0401` not mutable · `0402` used after move · `0403` cannot be moved · `0404` cannot assign |
| `05xx`  | Flow & exhaustiveness            | `0501` not all paths return · `0502` match not exhaustive · `0503` `try?` needs a Result/Option |
| `06xx`  | Declarations & inheritance       | `0601` already declared · `0602/0603` duplicate field/member · `0604` inheritance cycle · `0605` cannot extend · `0606` override a final method · `0607` contradictory modifiers |
| `07xx`  | Literals & interpolation         | `0701` bad literal suffix · `0702` cannot interpolate this value · `0703` printf needs a literal format |
| `08xx`  | Feature-specific semantics       | `0801` operator overload · `0802` reflection · `0803` region · `0804` vector/matrix · `0805` unimport/reimport · `0806` static assertion · `0807` must be compile-time constant · `0808` a persistent is never released |
| `09xx`  | Freestanding mode                | `0901` not available in freestanding mode |
| `17xx`  | Regions (flavors & operations)   | `1710` a region has one flavor · `1711` fixedslot/ring needs its element type · `1712` growable does not apply · `1713` mark/rollback need a stack region · `1714` checkpoint belongs to another region · `1715` a ring auto-evicts · `1717` use after extract · `1718` cannot extract an object whose field lives in the same region · `1719` a flavor only qualifies a region · `1720` an extract result must be bound |

Run `ldp3 explain` with no argument for the authoritative, complete list.

## 12.4 In the editor

Forge surfaces the same codes end to end. Its live checker runs the compiler on the unsaved
buffer, so diagnostics appear as you type; hovering a squiggle shows the code's why/fix/prevent
(the same catalog text), **Alt+Enter** applies a suggested quick-fix where one exists, and
**Ctrl+F1** runs `ldp3 explain` on the diagnostic under the caret.
