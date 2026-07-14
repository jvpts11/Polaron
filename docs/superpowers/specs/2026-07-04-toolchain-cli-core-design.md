# Toolchain Sub-project 1 — `ldp3` CLI core + build/run

Status: design (2026-07-04). Part of Step 3 (toolchain) of the master sequence. This is sub-project 1
of 5 (the others: deps/plug + environments; fmt/test/doc/clean; TUI; LSP).

## Goal

A single user-facing command `ldp3` that takes an LDP3 program all the way to a native `.exe` and runs it,
without the user ever invoking `clang` by hand. This is the "gcc-style" / no-TUI version: driven from the
command line, one shot per invocation. It reads the project manifest, orchestrates the compile + link, and
scaffolds new projects.

Success = `ldp3 run` on a scaffolded project (or a bare file) prints the program's output; `ldp3 build`
produces a runnable `.exe` in `build-output/`; `ldp3 new`/`init` create a valid project.

## Non-goals (later sub-projects)

Dependency management (`plug`/`unplug`), environments, `fmt`, `test`, `doc`, `lsp`, the TUI, and the
`--freestanding` bootable-image path are all out of scope here. The manifest's `[dependencies]` section is
parsed but empty-only (a non-empty one is a clear "not yet" error).

## Project structure (locked)

```
meu_projeto/
├── ldp3.toml             # manifest (conventional name; any .toml with header [ldp3_project] is accepted)
├── src/
│   └── main.ldp3         # entry (path declared in the manifest)
├── packages/             # dependencies (created lazily by a later sub-project; gitignored)
└── build-output/         # compiler/linker output (gitignored)
```

```toml
[ldp3_project]
[program]
name = "meu_projeto"
version = "0.1.0"
language_version = "1.0"
entry = "src/main.ldp3"
[dependencies]
[build]
output = "build-output/"
target = "x86_64-windows"
freestanding = false
```

## Architecture

`ldp3` is a **lightweight driver** — a new binary that orchestrates existing tools by spawning them. It does
**not** link LLVM or `ldp3_core`. This is the cargo→rustc model:

```
ldp3.exe  (tiny: arg parse, TOML, orchestration, process spawn — no LLVM)
   ├── spawns ldp3c.exe   (the existing compiler; carries the LLVM weight; unchanged)
   └── spawns clang       (links .ll + runtime + system libs → .exe)
```

Why shell out instead of linking `ldp3_core` in-process:
- **Tiny driver binary.** `ldp3.exe` stays a few hundred KB; only `ldp3c.exe` carries LLVM. (cargo is small,
  rustc is big.)
- **No refactor.** The compile orchestration currently lives in `src/cli/main.cpp` (there is no library
  entry point for "compile this file to .ll"). Shelling out reuses the tested `ldp3c` as-is.
- **Clean separation** of driver (toolchain) from compiler, exactly matching the decision to keep `ldp3c`.
- Cost — one process spawn per compile — is negligible next to compile time.

(Future v2: a `Compiler` library API in `ldp3_core` + in-process invocation, once we also replace `clang`
with our own `llc`+`lld` step. Not now.)

Code lives in a new `src/driver/` directory (currently empty) with a new CMake target `ldp3`.

## Components

1. **CLI dispatcher** (`src/driver/ldp3_main.cpp`) — reads `argv[1]` as the subcommand and dispatches.
   Handles `--version`, `--help`, unknown-command errors.
2. **Manifest** (`src/driver/manifest.{h,cpp}`) — a minimal TOML reader for exactly the sections we use
   (`[ldp3_project]`, `[program]`, `[dependencies]`, `[build]`); `key = "value"` and `key = value`. Finds
   `ldp3.toml` (or any `.toml` whose first non-blank line is `[ldp3_project]`) by walking up from the cwd.
   Builds an ephemeral manifest for a bare-file run (name = file stem, version 0.0.0, entry = the file).
3. **Build orchestrator** (`src/driver/build.{h,cpp}`) — resolves the project, runs `ldp3c` to emit `.ll`
   into `build-output/`, then runs `clang` to link with the runtime + system libs into `build-output/<name>.exe`.
4. **Scaffolder** (`src/driver/scaffold.{h,cpp}`) — `new`/`init` write `ldp3.toml`, `src/main.ldp3` (a hello
   world), and `.gitignore` (`packages/`, `build-output/`).
5. **Toolchain locator** (`src/driver/toolchain.{h,cpp}`) — finds `ldp3c`, `clang`, and the runtime. Order:
   env vars (`LDP3C`, `LDP3_CLANG`, `LDP3_RUNTIME`) → path relative to the `ldp3` executable → a
   CMake-generated `ldp3_config.h` default for dev builds. Clear error if `clang` is not found.

## Runtime linking

The link step needs the runtime (`ldp3_rt.cpp`) plus `legacy_stdio_definitions` and `ws2_32`. CMake builds
`runtime/ldp3_rt.cpp` into a static lib **`ldp3_rt.lib`** once (a `add_library(ldp3_rt STATIC ...)` target);
the orchestrator links that. (This also removes the per-link recompile the test harness does today.) The lib
is located via the toolchain locator (env / relative / dev default).

## Subcommands (this slice)

- `ldp3 run [file.ldp3] [-- args...]` — resolve the project (or ephemeral manifest for a bare file), build,
  then execute the `.exe`, forwarding args after `--` and propagating its exit code.
- `ldp3 build` — build the current project to `build-output/`.
- `ldp3 compile <file.ldp3>` — compile a single file to `build-output/<stem>.exe` without running.
  (`--emit=exe|obj|ll`, default `exe`.)
- `ldp3 new <name>` — scaffold `./<name>/`.
- `ldp3 init` — scaffold in the current directory.
- `ldp3 clean` — remove `build-output/`.
- `ldp3 --version`, `ldp3 --help`.
- Pass-through to the compiler for power users: `--target=<triple>`, `-O0..-O3`, `--lib`, `--use <dep.ldb>`.

## Build pipeline (run / build / compile)

1. Resolve the manifest → `{ name, entry, target, output dir, freestanding, optLevel }`.
   (Non-empty `[dependencies]` → "dependencies are not supported yet" error.)
2. **Compile:** spawn `ldp3c <entry> -o <output>/<name>.ll [--target=… -O…]`. Surface its stderr; abort on
   non-zero.
3. **Link:** spawn `clang <output>/<name>.ll <ldp3_rt.lib> -llegacy_stdio_definitions -lws2_32
   -o <output>/<name>.exe`. Surface stderr; abort on non-zero.
4. **run only:** execute `<output>/<name>.exe`, forward args, propagate exit code.

`freestanding = true` passes `--target`/`--freestanding` through to `ldp3c` and skips the OS runtime link;
the full bootable-image path is a later sub-project (explicitly out of scope here).

## Error handling

- No manifest found for `build` → `error: no ldp3.toml found in this directory or any parent; run 'ldp3 init'
  or 'ldp3 run <file>'`.
- `clang`/`ldp3c` not found → clear error naming the env var to set.
- Compile or link failure → forward the tool's own diagnostics and exit non-zero.
- Non-empty `[dependencies]` → `error: dependencies are not supported yet (coming in a later release)`.

## Testing (CTest, via the driver)

- `ldp3 --version` prints the version.
- `ldp3 new demo` creates `demo/ldp3.toml`, `demo/src/main.ldp3`, `demo/.gitignore`.
- `ldp3 run <hello_world.ldp3>` (bare file, ephemeral manifest) prints `Resultado: 42`.
- `ldp3 build` on a scaffolded project produces `build-output/demo.exe`, which runs and prints its output.
- `ldp3 compile <file>` produces an `.exe` and does not run it.

## Decisions locked

- Manifest conventional name `ldp3.toml`; identified by the `[ldp3_project]` header.
- `ldp3` is a new lightweight driver that spawns `ldp3c` + `clang`; `ldp3c` is kept as the low-level compiler.
- `ldp3 compile` emits `.exe` by default.
- v1 links with `clang`; replacing it with our own backend (`llc`+`lld`) is a later goal.

## Future (recorded, not in scope)

- Own linker/codegen step to drop the `clang` dependency (João wants this).
- `ldp3 build --freestanding` → bootable image (needs `_start`/multiboot header + linker script + QEMU) — a
  priority sub-project, but after the CLI core.
- In-process `ldp3_core` compile API (single binary), paired with the own-linker work.
