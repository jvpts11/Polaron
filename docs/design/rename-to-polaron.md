# Renaming the language to Polaron

*Record, 2026-08-13. The language was `LDP3`, was `Ingra` for one day, and is now **Polaron**. The
slogan carries over: **"High level, to the bare metal."***

This is the second rename in two days. It absorbs the earlier `rename-to-ingra.md`, which no longer
exists: its durable thinking is the *How to think about it* section below, and its measured traps are
folded in with this pass's. Nothing here is a plan written in advance — it is what the plan turned
into when it was run a second time, on a tree that had already been through it once.

## How to think about it (from the first rename, still the right frame)

Sort the work by **how it fails**, not by how much of it there is. A compile error is free; a silent
one is not.

- **Class A — fails loudly, do it first.** C++ identifiers, namespaces, type names, comments, docs,
  CMake target names, the repository layout. Everything here breaks the build the instant it is wrong.
- **Class B — fails at link, and names a symbol nobody wrote.** The runtime symbols
  (`__ingra_*` → `__polaron_*`, 181 of them). Both ends must move together. Note the blast radius is
  smaller than the count suggests: pico references only `__polaron_panic` directly, everything else is
  emitted by codegen, so the external surface is one symbol, not 181.
- **Class C — fails silently, and is the reason any of this is written down.** Anything where the old
  name still *works*: an old extension the driver still accepts, a manifest key still honoured, a
  stale bundle still loadable. If both names work during the transition, nothing tells you the
  migration is incomplete — you find out months later, from someone else's build.

Two rules follow, and both held again this time:

- **No aliases and no dual acceptance.** If `.ing` still compiled afterwards, the migration would have
  no end state and no way to know it is done. Break it on one commit.
- **Rename nothing that belongs to a foreign library.** `llvm::Function` is LLVM's word for its own
  object; the vocabulary rule (they are *methods*, *interrupts*, *procedures* and *lambdas*, never
  "functions") governs this language's own naming, not somebody else's API.

And one that the first document did not have, learned by being caught by its own sweep — a table row
came out reading `.ing`→`.ing`:

> **Rename what the project *is*. Do not rewrite records of what it *was*.**

## The decisions

| what | was | is |
|---|---|---|
| the language | Ingra | **Polaron** |
| source files | `.ing` | **`.pol`** |
| public-API header | `.ingh` | **`.polh`** |
| bundle container | `.ingb` | **`.polb`** |
| the compiler | `ingrac` | **`polc`** |
| the driver | `ingra` | **`polaron`** |
| tools | `ingra-lsp`, `ingra-studio` | `polaron-lsp`, `polaron-studio` |
| runtime symbols | `__ingra_*` | `__polaron_*` |
| environment | `INGRA_*` | `POLARON_*` |
| manifest | `ingra.toml`, `[ingra_project]` | `polaron.toml`, `[polaron_project]` |
| container magic | `INGB` | **`POLB`** |
| the checkout | `Desktop\things\ingra\Ingra` | `Desktop\things\polaron\Polaron` |

`polc`, not `polaronc`: the compiler's name was chosen short on purpose, which means it does **not**
fall out of the language name by suffix and has to be its own substitution rule, running *before* the
rule for the name it contains.

No aliases, no dual acceptance — same as last time, and for the same reason: if `.ing` still compiled
afterwards, nothing would ever tell us the migration was finished.

## The size of it, measured

| what | count |
|---|---|
| `ingra` occurrences in compiler C++ (`src/`, `runtime/`) | 1 972 |
| distinct `__ingra_*` runtime symbols | 181 |
| replacements made in compiler text | **9 615** across 450 files |
| replacements made in the ecosystem | 301 across 85 files |
| paths renamed (files + directories) | **981** |
| `.ing` source files | 714 compiler + 224 ecosystem |

## The two traps that belong to these letters

**1. `ingb` is inside `stringBuilder`.** There are **1 553** occurrences of `ringB` in this tree and
every single one is a string operation — `stringBuilder`, `substringBefore`, `RingBuffer`. Also
`EncodingHexBase64` (`ingH`) and `analyzeExpectingBlock` (`ingB`). A naive `ingb` → `polb` produces
`strpolbuilder` in a thousand places, and most of them are in the standard library.

The shape that separates them is the camel hump. In `stringBuilder` the `ing` belongs to `string` and
the capital `B` starts `Builder`; in `depIngb` the capital `I` starts `Ingb`. So:

```
Ingb              -> Polb     no guard needed: capital-I-lowercase-ngb never occurs inside a word
(?<![A-Za-z])ingb -> polb     covers `ingbPath`, `.ingb`, `--dump-ingb`, `run_ingb_test`
(?<![A-Za-z])INGB -> POLB     covers the include guards, excludes `UPPLINGB`
```

**2. `ingra` is safe, and I nearly convinced myself otherwise.** I enumerated all **371** distinct
identifiers containing it: every one is the language name. The one thing that looks like a
counterexample is `FoldingRange` from the LSP protocol — but that is `ingRa`, with a capital R, so a
case-sensitive rule passes it by. My *verification* grep was case-insensitive, reported 143 hits in
`extension.js`, and for a minute looked like a hundred survivors. The rules were right; the check was
wrong.

## What no rule can reach, and had to be done by hand

- **The container magic.** `constexpr char kMagic[4] = {'I','N','G','B'}` — written as characters, so
  it is invisible to every substitution that works on identifiers or strings. It was invisible to the
  *previous* rename too, for the same reason. Bumping it is not cosmetic: it is what makes a stale
  bundle be *refused* rather than misread.
- **The bare extension.** `ext=ldp3` → `ext=ing` → `ext=pol`. It is the asserted output of
  `Paths.extension("src/lib/file.pol")`, spelled without a dot, in two places. This is the third
  rename in a row it has needed hand-holding for.
- **The English article.** *"is not an Ingra manifest"* → *"is not **a** Polaron manifest"*. 25 places.
  A rename changes the sentence around the name, not only the name.

## The records, and how each one was actually resolved

The first pass left four things carrying the old name on purpose. This pass was told to leave
**nothing**, which forced a better answer for each — and the answers differ, because the reason each
one resisted renaming was different.

- **`"LDP3 kernel OK"` — regenerated, which was always the correct fix.** It was never a brand: it is
  the *measurement*, the bytes a prebuilt `kernel.elf` writes to VGA memory, which `harness_kern.cpp`
  compares against. The first pass froze it because renaming the assertion alone would make the test
  compare against something no file on disk prints. But the ELF has source — `kernel/kernel.pol` in
  this repository — so the honest fix is to change the source and rebuild the fixture. Done: the
  kernel now spells `Polaron kernel OK`.

  **Three numbers moved with it**, and this is the interesting part: the new name is three characters
  longer, so the harness buffer went `char[15]` → `char[18]`, its loop `14` → `17`, and the lifted
  byte range `245` → `296` (three more VGA cells is ~17 bytes of code each). *A rename can change an
  offset.* The comment in `kernel.pol` had already been swept to say `"Polaron kernel OK"` while the
  character codes below it still spelled the old name — a comment lying about the code underneath it,
  which is exactly the silent-failure class.
- **`decomp/recovered_ldp3_source.txt` — swept and renamed.** A decompiler dump of the old prelude;
  the 24 old-name occurrences in it were this language's own runtime symbols.
- **`LDP3-Language-Reference-1.0.12.pdf` — moved out of the tree.** A PDF's text cannot be rewritten,
  and that version's sources no longer exist to regenerate it, so renaming the file would only make it
  lie on the outside. The *current* manual was regenerated instead, from the already-swept markdown.
- **`docs/design/rename-to-ingra.md` — folded into this document** (see *How to think about it*) and
  removed. Superseding a record is honest; rewriting one is not.

Nothing was deleted: the ecosystem repository is not under git, so the unrewritable artifacts were
**moved** to `Desktop\things\ingra-BACKUP-pre-polaron\_superseded-by-polaron\` rather than destroyed.

**`decomp/harness_kern.cpp` was moved out too, and not regenerated.** It is machine-generated output
whose input — `kernel.elf` — has just changed, so it is stale by construction; its lifted body still
adds `76`, `68`, `51` to the VGA attribute (`L`, `D`, `3`). Regenerating it needs `decomp` to build,
and `decomp` does not build for reasons that predate this rename (a `use of variable after it was
deleted` plus ~20 `constructor never assigns field`). Hand-editing a decompiler's output to look
right would have been the dishonest option.

## Artifacts that now lie, and must be regenerated

Renaming a file does not rename what is inside a binary. These carry the new name on the outside and
the old one within, and are wrong until rebuilt:

- `docs/reference/Polaron-Language-Reference-1.0.16.pdf` — every page says Ingra.
- `editors/vscode/polaron-0.2.0.vsix` — a packaged build of the extension.
- `kernel/kernel_polaron.o`, and the stale `.exe`s under `tests/samples/` and `performance tests/`.
- `installer/dist/stage/` — still staged with `ingra.exe`, `ingrac.exe`, `ingra_rt.lib`.

`build-local`, `build`, `build-linux`, `build-output` and `performance tests/_bench` were **deleted**
rather than swept: a CMake cache holds absolute paths *and* target names, so after this change it is
wrong twice over.

## Order of work, as actually run

1. Measure, and enumerate every identifier containing the old name before writing a single rule.
2. Back up the tree (the previous rename was still uncommitted, so git offered no way back).
3. Sweep file **contents** in both trees, dry run first, with per-rule counts.
4. Sweep file and directory **names**, deepest first.
5. The hand cases: magic, bare extension, articles.
6. Delete the build trees, move the checkout, repoint `POLARON_TOOLCHAIN`.
7. Configure from scratch, build every target, run the suite.

## Measurement hygiene, again

Two of the three reporting bugs in this session were in the *instruments*, not the work:

- A PowerShell hashtable compares string keys **case-insensitively**, so `ingra->polaron` and
  `INGRA->POLARON` collapsed into one bucket and the report printed the same total three times for
  three different rules. Index counters by position, not by a name that differs only in case.
- The case-insensitive verification grep, above.

And the standing one from last time still applies: **check `vcvars64` before believing a catastrophe.**
Without it every `_runs` test fails on `winsock2.h` and the suite reports hundreds of failures on a
tree that is green.
