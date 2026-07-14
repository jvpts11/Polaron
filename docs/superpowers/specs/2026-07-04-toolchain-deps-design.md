# Toolchain Sub-project 2 — dependencies (`plug`/`unplug`) + packages + environments

Status: design approved (2026-07-04). Sub-project 2 of 5 of the toolchain (Step 3). Built directly on
sub-project 1 (the `ldp3` driver). João approved the design and asked for the whole sub-project to be
implemented autonomously.

## Goal

`ldp3 plug <lib>` downloads a dependency (a separately-published LDP3 library), compiles it once, and makes
it usable from the current project's code — and `ldp3 build`/`run` link it in automatically. Dependencies
live either in the project's own `packages/` or in a shared, named environment; a project may use **both at
once**.

## Dependency model (hybrid + additive)

Three project shapes, all supported:
1. **No environment** — deps only in `./packages/` (project-local, isolated).
2. **An environment** — deps come from a shared `~/.ldp3/environments/<name>/`.
3. **Both** — project-local deps in `./packages/` **and** a shared environment simultaneously.

Resolution at build time is the **union** of the project's `packages/` deps and (if declared) the
environment's deps. The manifest gains an optional `[build] environment = "<name>"`.

## How a dependency is consumed (the .ldb recipe)

A dependency is an LDP3 library compiled to a `.ldb` (code, as LLVM bitcode) + `.ldh` (public API header).
The proven pipeline (see `tests/run_ldb_link_test.cmake`):

1. `ldp3c --lib <dep-entry> -o <name>.ldb`   → emits `<name>.ldb` + `<name>.ldh` (done once, at plug time).
2. `ldp3c --extract-code <name>.ldb -o <name>.bc`   → the dep's bitcode (done at build time).
3. `ldp3c <app> --use <name>.ldb ... -o app.ll`   → the consumer, with the dep's public API resolved.
4. `clang app.ll <name>.bc ... -o app.exe`   → link the consumer with the dep's code.

## Commands

- `ldp3 plug <url|name>[@version] [-e|--env]` — resolve to a Git URL, clone, compile to `.ldb`/`.ldh`,
  record in the manifest. Default target is `./packages/`; `-e`/`--env` targets the project's declared
  environment.
- `ldp3 unplug <name> [-e|--env]` — remove the dep directory and its manifest/env entry.
- `ldp3 env new <name>` / `ldp3 env list` / `ldp3 env remove <name>` — manage named environments under
  `~/.ldp3/environments/`.

## Name resolution

- A full Git URL (`github.com/...`, `https://...`, a local path) is used as-is.
- A bare name resolves via `~/.ldp3/sources.toml` (`[sources]` `name = "url"`).
- An unknown bare name is an error suggesting a full URL. No hardcoded default GitHub org yet (deferred until
  there is an official registry).

Versions are Git tags: `git clone --depth 1 --branch <version> <url> <dest>`. Without a version, the default
branch's latest commit is used.

## Manifest (read + write)

The manifest parser gains an `environment` field and a real `dependencies` list (`name`, `version`), and the
driver gains `addDependency`/`removeDependency` that edit the `[dependencies]` section in place (create it if
absent). Only that section is rewritten; the rest of the file is preserved line by line.

## Build integration

`buildProgram` resolves the dep set — the project manifest's `[dependencies]` (found under `./packages/`) plus,
if `environment` is set, that environment's deps (under `~/.ldp3/environments/<name>/packages/`). For each dep
it extracts the `.bc`, passes `--use <ldb>` to the `ldp3c` compile, and hands each `.bc` to the `clang` link.
The previous "dependencies not supported yet" guard is removed.

## Components (new files under `src/driver/`)

- `sources.{h,cpp}` — resolve a name/URL to a Git URL via `~/.ldp3/sources.toml`.
- `git.{h,cpp}` — `gitClone(url, version, dest)` over the system `git` (shell-out, like clang).
- `deps.{h,cpp}` — `plug`/`unplug`: orchestrate resolve → clone → compile-to-`.ldb` → record; and the
  reverse.
- `environs.{h,cpp}` — environment directory management (`~/.ldp3/environments/`), `env new/list/remove`,
  home-dir resolution.
- Extend `manifest.{h,cpp}` — `environment` field, `dependencies` list, `addDependency`/`removeDependency`.
- Extend `build.{h,cpp}` — resolve + link the dep set.
- Extend `ldp3_main.cpp` — dispatch `plug`/`unplug`/`env`.

## Error handling

- Unknown bare package name → error naming `sources.toml` / a full URL.
- `git` not found → clear error (locate via PATH).
- Clone/compile failure → surface the tool's output, leave the project unchanged (don't half-record).
- `plug -e` with no environment declared and no `--env <name>` → clear error.
- `unplug` of an absent dep → a warning, exit 0 (idempotent).

## Testing (hermetic, offline)

A CTest helper (`run_plug_test.cmake`) creates a **local git repo** fixture: a minimal LDP3 library (its
`ldp3.toml` + a `src` file exposing a `public bundle` with a static method), `git init`/`add`/`commit`/`tag
v1.0.0` (with an explicit `-c user.name/-c user.email`). Then, in a scaffolded consumer project, it runs
`ldp3 plug <local-repo>@v1.0.0`, verifies `packages/<name>/<name>.ldb` exists and the manifest records the dep,
runs `ldp3 build`/`run`, and checks the consumer calls into the library. Unit tests (doctest) cover
`resolveSource` and the manifest add/remove.

## Out of scope (later)

Version-range resolution (`^`, `~`, `>=` — for now an exact tag or default branch), a lockfile, transitive
dependencies, `--update`, `--global`, and the TUI that manages projects/environments visually.
