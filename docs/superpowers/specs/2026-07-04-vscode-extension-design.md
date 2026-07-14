# LDP3 for VS Code — extension design (toolchain sub-project 5)

Status: approved direction 2026-07-04 (everything, maximum depth; in-tree at `editors/vscode/`).

## Goal

A comprehensive VS Code extension for LDP3: a real editing experience (syntax, diagnostics, formatting,
navigation) and the LDP3 Studio manager (projects, environments, libraries) inside the editor, plus commands
to build/run/test/doc/fmt. It reuses the same engine as the CLI and the TUI, and the same approved visual
design in a webview. Node 22 / npm 10 / VS Code are available for building, packaging and testing.

## Architecture: one engine, thin frontends (two new seams)

```
ldp3_driver / compiler (C++)  ── the engine
   ├── ldp3 CLI + new --json ........ the manager's data (projects / environments / libraries)
   ├── ldp3-lsp (new C++ binary) .... language server: reuses lexer/parser/analyzer, speaks LSP over
   │                                   stdio -> real diagnostics, symbols, completion, hover, go-to-def
   └── VS Code extension (TS, editors/vscode/) ── thin: TextMate grammar, commands, tree views,
                                                   webview (amber design), LSP client
```

Two new seams are added to the engine:
- **`ldp3 --json`**: machine-readable output of the driver's data (project discovery, environments,
  libraries, toolchain), consumed by the extension's tree views. Wraps the same driver functions the TUI uses.
- **`ldp3-lsp`**: a C++ Language Server that reuses the compiler's `Lexer`, `Parser` and `SemanticAnalyzer`
  to answer LSP requests with the real semantic model -- not a shallow TS reimplementation.

The extension itself is thin (TypeScript): it locates the `ldp3` tools, contributes a grammar and language
configuration, runs commands, provides formatting, hosts tree views and a webview, and connects a language
client to `ldp3-lsp`.

## Phases (walking skeleton; each phase builds, is committed, and is independently useful)

### Phase 1 — Foundation + syntax
- `editors/vscode/` scaffold: `package.json` (contributes, activation events), `tsconfig.json`, esbuild
  bundling, the extension entry (`src/extension.ts`), a `.gitignore` for `node_modules/`, `out/`, `*.vsix`.
- A `ldp3` tool locator (setting `ldp3.path`, else PATH, else the repo build output).
- A TextMate grammar (`syntaxes/ldp3.tmLanguage.json`) for `.ldp3`: keywords, primitive types, class/enum/
  interface, strings + `$"..."` interpolation, char, numbers (all bases), comments (`//`, `///`, `/* */`),
  annotations `[Name]`, operators.
- A language configuration (`language-configuration.json`): comments, brackets, auto-closing pairs, indent.
- Outcome: syntax highlighting for `.ldp3`.

### Phase 2 — Editor: commands + formatting
- Commands `ldp3.build/run/test/doc/fmt` and `ldp3.new`: resolve the project, run the `ldp3` CLI in an
  integrated terminal (run, which is interactive) or an output channel (build/test/doc), surface exit status.
- A `DocumentFormattingEditProvider` calling `ldp3 fmt` (or `ldp3c --fmt` on a temp copy) + format-on-save.
- Diagnostics: on save, run the compiler in check mode, parse `file:line:col: error: message`, publish to the
  Problems panel. (Superseded by the LSP's live diagnostics in Phase 5, but useful earlier and as a fallback.)
- Outcome: build/run/test/doc/fmt and formatting from VS Code.

### Phase 3 — Manager: `--json` seam + tree views
- CLI: `ldp3 --json <subcommand>` (or `ldp3 list --json`) emitting the discovered projects, environments and
  libraries as JSON, reusing `discoverProjects`, `listEnvironments`, `loadEnvironments`-equivalent logic.
- A "LDP3" view container in the activity bar with tree views: Projects, Environments, Libraries. Tree items
  carry context-menu actions (open, build, run, test; plug into project; new environment).
- Outcome: the studio manager as native VS Code tree views.

### Phase 4 — Manager: webview dashboard
- A webview panel reusing the approved amber design (project detail / dashboard). Buttons post messages back
  to the extension to run actions; the panel refreshes from `--json`. Content-Security-Policy compliant,
  theme-aware where sensible.
- Outcome: the rich studio look inside VS Code.

### Phase 5 — Language server (the deep layer)
- `ldp3-lsp`: a new C++ executable linking `ldp3_core`, speaking LSP over stdio (JSON-RPC). It maintains open
  documents, runs `Lexer`/`Parser`/`SemanticAnalyzer`, and answers:
  - **diagnostics** (real lex/parse/semantic errors, live as you type),
  - **document symbols** (outline: bundles/namespaces/classes/methods/fields),
  - **completion** (keywords, then scope-aware members/types),
  - **hover** (declared types, signatures),
  - **definition** (go-to-def within and across the program's files).
- The extension adds a `vscode-languageclient` that launches `ldp3-lsp`.
- The JSON-RPC/LSP plumbing in `ldp3-lsp` is unit-tested (doctest) at the request/response level; semantic
  answers reuse the already-tested analyzer.
- Outcome: real, semantic editing support.

## Testing

- TypeScript compiles under `tsc`/esbuild; the extension packages with `vsce package`.
- `ldp3-lsp`'s protocol layer (message framing, request dispatch, position mapping) gets doctest coverage;
  the semantic answers lean on the existing analyzer tests.
- The `--json` output has a shape test (the CLI emits valid JSON with the expected keys).
- Interactive UI (tree views, webview, live LSP) is verified in VS Code's Extension Development Host by the
  user, as with the TUI.

## Non-goals (for now)

- Marketplace publishing (packaging works; publishing is a later, deliberate step).
- Debugging support (a debug adapter) -- LDP3 has no debugger yet.
- Notebook or task-provider integration.
