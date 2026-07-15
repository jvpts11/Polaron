# Rich diagnostics — the compiler teaches, it doesn't just reject

Every LDP3 error and warning explains itself in four parts: **what** happened (the title), **why** it is
an error (the rule), **how to fix** it here, and **how to prevent** it next time. The compiler and the whole
toolchain exist to keep a programmer out of trouble, not just to report it.

## Decisions (approved 2026-07-15)

- **Rich by default** in the terminal (`ldp3 build`, `ldp3c`): every diagnostic prints the four parts,
  with a source snippet and a caret. `-q` / `--concise` collapses to the classic one line (for CI / huge
  broken builds).
- **Stable error codes** (`LDP3-0101` …). They back `ldp3 explain <code>`, per-code documentation, and an
  IDE deep-link. A code names a *kind* of error; many call-sites can share one.
- **Machine-facing output stays parseable.** `ldp3 check` (what Forge's live-check runs) and `--concise`
  emit one line: `path:line:col: error[LDP3-0101]: message`. Rich multi-line output is human-facing only.

## Architecture

```
src/diag/diagnostic.h   Code enum + Rich payload + Entry (catalog row) + lookups
src/diag/catalog.cpp    the catalog: per code, {codeStr, caretLabel, why, fix, prevent} — canonical prose
src/diag/render.{h,cpp} render one diagnostic to text (snippet + caret + sections), or one concise line
```

- Each phase's error struct (`SemaError`, `LexError`, `ParseError`, `CodegenError`) carries a
  `diag::Code code`. `Code::None` = not yet migrated → renders as a clean one-liner (no fabricated prose).
- Call-sites gain a code: `error(diag::Code::NoSuchField, "class '…' has no field '…'", loc)`. The dynamic
  title stays at the call-site (it names the specific thing); the *why/fix/prevent* live once in the
  catalog, reused by both the inline render and `ldp3 explain`. Writing the rule's prose once, not at 343
  call-sites, is what keeps it consistent and reviewable.
- `ldp3c --explain <code>` prints a code's canonical write-up; `ldp3 explain <code>` forwards to it.

## Output shape (rich)

```
error[LDP3-0101]: use of undeclared variable 'totl'; did you mean 'total'?
  --> game/Main.ldp3:16:25
   |
16 |                 total = totl + 1;
   |                         ^^^^ not declared in this scope
   |
 why:     A variable must be declared (var/mutable/a parameter/a field) before it is
          read. 'totl' matches nothing in scope — almost always a typo.
 fix:     Change 'totl' to 'total', or declare it: `mutable int totl = …;`.
 prevent: Let the editor autocomplete names; Forge's live check flags this as you
          type and Alt+Enter applies the suggested fix.
```

## Compatibility

- Forge `app.Checker.severityOf`/`parseLine` accept `error[CODE]:` / `warning[CODE]:` (not only `error:`).
- CTest `PASS_REGULAR_EXPRESSION`s that anchored on `: error: ` move to `: error\[LDP3-…\]: `.
- The message text (what the tests mostly match) is unchanged.

## Rollout

Every error must end up rich ("sempre rico"). Realistically that is waves, not one commit:

1. **Infra + the ~20 errors a programmer hits most** (naming, types, mutability, visibility, return,
   arg count) fully rich, + `explain` + `--concise` + Forge/test compat. — this slice.
2. Broaden to the rest of the semantic errors, then lexer/parser/codegen, in further commits — each code
   gets real prose, no filler. `Code::None` sites shrink to zero over the waves.

The machine guarantees the shape; the catalog fills in the words, wave by wave.
