# LDP3 Studio — TUI design (toolchain sub-project 4)

Status: approved design, 2026-07-04. Working name: **ldp3 studio**.

## Goal

A rich, visually polished terminal UI that manages LDP3 projects and environments: discover the projects on the
machine, create new ones without friction, and drive build/run/test/doc/fmt on any of them. The visual identity
was approved from mockups (four screens, amber-on-teal-ink, rounded panels, a persistent keybar). This
sub-project delivers that TUI on Windows. A VS Code extension is an explicitly separate, later sub-project that
reuses the same engine and the same visual design (in a webview); nothing here is built for it beyond keeping
the engine reusable.

## Settled decisions

- **Sequencing:** TUI first; the VS Code extension is a dedicated follow-up sub-project.
- **Language:** C++. The TUI links `ldp3_driver` directly (no IPC).
- **Rendering:** FTXUI, vendored in-tree under `third_party/ftxui/` (pinned, no vcpkg/fetch), so the build stays
  self-contained. The "no external deps" rule was written for the *compiler*; the TUI is a separate toolchain
  tool, and FTXUI (MIT) realizes the approved mockups with far less risk than hand-rolling a terminal renderer.
- **Discovery (user's model):** on launch, scan the current directory tree for `ldp3.toml` and list what is
  found; a user-triggered "scan the whole computer" action warns it may take a while, runs on a background
  thread, and streams each found project into the list as it is discovered. Projects created/opened through the
  TUI are remembered in a light registry so they appear outside the current folder.
- **Distribution:** a separate binary `ldp3-studio` (keeps the lean `ldp3` CLI free of FTXUI); `ldp3 studio`
  may launch it. This matches the planned "two toolchain versions" (classic CLI / TUI manager).

## Architecture: one engine, thin frontends

```
ldp3_driver (C++ static lib)  ── the ENGINE: discovery, manifest, environments,
   │                             build/run/test/doc/fmt orchestration
   ├── ldp3         (classic CLI — prints; gains --json later for VS Code)
   └── ldp3-studio  (the TUI — links the driver directly + FTXUI)      ← this sub-project
                     (VS Code extension in TS, later, consumes `ldp3 --json`)
```

**Principle:** `ldp3_driver` functions return structured data rather than only printing. The CLI is a thin
printer over them; the TUI renders the same data; a future `--json` mode wraps the same functions. No logic is
duplicated across frontends. Where existing driver functions only print, they get a data-returning form and the
CLI prints that.

## Components (TUI internals)

Each is a focused unit with one purpose, testable where it is not intrinsically interactive.

- **App shell** (`app.{h,cpp}`) — owns the FTXUI `ScreenInteractive`, the top bar, the left navigation rail, the
  main area (routes to the active screen), and the bottom keybar. Holds `AppState` and dispatches global keys
  (quit, switch section, back).
- **AppState** (`state.h`) — current section/screen, the discovered project list, the selected project, the
  environments, and transient flags (scanning in progress, console buffer). Screens read and mutate it.
- **Screens** — each an FTXUI component with its own local state, render, and input handling:
  - `ProjectsScreen` — the discovered-projects list + a detail pane (entry, version, environment, last build).
  - `ProjectDetailScreen` — actions rail (Run/Build/Test/Doc/Fmt), dependencies + summary, and a console pane.
  - `EnvironmentsScreen` — named environments, their libraries, and which projects use each.
  - `NewProjectModal` — a step-through overlay (name, kind app/lib/freestanding, environment) that scaffolds via
    the driver.
- **Engine adapter** (`engine.{h,cpp}`) — thin wrappers over `ldp3_driver`: discover projects in a directory,
  read a project's manifest + derived facts, list/read environments, and run build/test/doc/fmt capturing output.
  This is the seam the screens call; it never touches FTXUI.
- **Theme** (`theme.h`) — the exact approved palette as `ftxui::Color::RGB` constants and small element helpers
  (panel, focused panel, pill, keybar) so every screen shares one look.

## Discovery

- **Launch scan:** walk the current working directory recursively for `ldp3.toml` (skipping `packages/`,
  `build-output/`, `.git`, `node_modules`), parse each manifest, and populate the list. Synchronous and fast for
  a normal project tree.
- **Full-computer scan:** a keybound action. Shows a warning/consent line, then spawns a background thread that
  walks the filesystem roots; for each `ldp3.toml` found it posts an event via `ScreenInteractive::PostEvent` so
  the main loop appends the project and re-renders. Cancelable. A visible "scanning… N found" indicator.
- **Registry:** `~/.ldp3/registry.toml` records projects created or opened through the TUI (path + last-opened),
  merged into the list on launch so known projects show regardless of the current folder.

## Build / run / test output

- **Non-interactive (Build/Test/Doc/Fmt):** the adapter spawns the same subprocesses the CLI uses (`ldp3c`,
  `clang`) via a streaming capture, on a background thread, posting each line to the console buffer; the console
  pane renders it with semantic color (PASS green, FAIL red, summary amber). Exit status sets a pass/fail pill.
- **Run:** the target program may be interactive (e.g. tic_tac_toe reads input). Run **suspends** the TUI
  (releases the terminal), runs the program inline exactly as `ldp3 run` does, then **resumes** the TUI when it
  exits. This is the clean path for programs that read stdin.

## FTXUI ↔ mockup mapping

The rail/main/keybar are `vbox`/`hbox` with `flex`; panels use `borderRounded`; colors are `Color::RGB` from the
palette below; the focused panel takes an amber border; selection is `bgcolor` + `bold`; the new-project modal is
a floating element over the dimmed screen. This maps almost 1:1 to the mockups.

Palette (from the approved mockups): ground `#0d1417`, panel `#101c1f`, line `#23383c`, ink `#e4ece9`, muted
`#86a09b`, faint `#58726e`, amber (brand/selection) `#eab464`, teal (secondary) `#58c8bf`, green (pass) `#93c97e`,
red (fail) `#e57f70`, violet (environment) `#b79ae0`. Monospace throughout (it is a terminal). Single dark theme
by deliberate choice.

## Build order (walking skeleton, one slice at a time)

The compiler methodology applies: the TUI always builds and runs something; add one screen/capability per slice.

1. **Skeleton** — vendored FTXUI builds; `ldp3-studio` opens, renders the shell (top bar + rail + empty main +
   keybar) in the real palette, quits on `q`. Proves the build, FTXUI, and the aesthetic.
2. **Projects** — launch-scan discovery, the projects list with navigation, and the detail pane.
3. **Actions** — Build/Test/Doc/Fmt stream into the console pane; Run suspends and runs.
4. **Environments** — the environments screen (list + libraries + used-by).
5. **New project** — the modal, scaffolding through the driver, then selecting the new project.
6. **Full-computer scan** — the background streaming discovery action.

## Testing

- The engine adapter and discovery logic (non-UI) get real unit tests (doctest): discovery finds the right
  `ldp3.toml` set and skips the excluded dirs; the adapter maps manifests to the facts the UI shows.
- Screens get smoke tests where practical (feed FTXUI a sequence of events, assert on the rendered string).
- The intrinsically interactive parts (Run suspension, live streaming) are verified manually; the bulk of the
  correctness guarantee sits in the engine, which is testable.

## Non-goals (this sub-project)

- The VS Code extension, the `--json` CLI mode, and the LSP are later sub-projects (the engine is kept reusable
  for them, but none is built here).
- No new visual direction: the look is locked to the approved mockups.
- Not a general file manager or editor — it manages LDP3 projects and environments and drives the toolchain.
