# 15. The toolchain & projects

`ldp3` is the one command you drive the language with: it builds and runs projects, checks
and formats source, manages dependencies and environments, and scaffolds new projects. Under
it sits `ldp3c`, the compiler proper; you rarely call `ldp3c` directly.

## 15.1 The `ldp3` command

| Command | What it does |
|---------|--------------|
| `ldp3 run [file.ldp3] [-- args...]` | Build and run — the current project, or a single bare file. Arguments after `--` go to the program. |
| `ldp3 build` | Build the current project into `build-output/`. |
| `ldp3 check [--project <dir>] [--overlay <file>=<tmp>]` | Type-check and print diagnostics without emitting anything. `--overlay` checks a file as it reads in a temp buffer — the hook editors use for live diagnostics. |
| `ldp3 compile <file.ldp3>` | Compile one file to an `.exe`, without running it. |
| `ldp3 test [-- args...]` | Build and run the project's `[Test]` methods. Arguments after `--` go to the runner: `--filter <text>` narrows the run, `--list` names the tests without running them, `--timing` adds durations. |
| `ldp3 fmt [file.ldp3]` | Format the project's source (or one file) in place. |
| `ldp3 doc` | Render the public API to HTML from `///` doc comments. |
| `ldp3 explain <code>` | Print the why / fix / prevent for a diagnostic code (see [§13](#13-diagnostics)). |
| `ldp3 plug [<url\|name>[@version]] [-e]` | Download a dependency (or all of them if none is named). |
| `ldp3 unplug <name> [-e]` | Remove a dependency. |
| `ldp3 env new\|list\|remove [<name>]` | Manage shared environments (toolchain/dependency sets reused across projects). |
| `ldp3 new <name>` / `ldp3 init` | Scaffold a new project (in a new directory, or in the current one). |
| `ldp3 clean` | Remove `build-output/`. |
| `ldp3 studio` | Open the TUI project manager. |
| `ldp3 --version` / `ldp3 --help` | Print the version / usage. |

### Turning off the escape checks

The **region binder** — the analysis that stops a pointer to a dead frame from leaving the
frame ([§5.4](#54-no-undefined-behavior-dangling-double-free-and-the-trap)) — is on by
default. `ldp3c --no-region-binder` turns it off for a whole program.

There is deliberately no per-line version. A line that hands out a pointer to storage that
is about to disappear looks like ordinary code, which is exactly how the mistake survives
review; so the way to opt out is one flag, visible in the build, rather than an annotation
buried in the source. `ldp3c --check` accepts the same flag and has the same default, so
the editor's live diagnostics and the build never disagree about what is an error.

## 15.2 Project layout

A project is a directory with an `ldp3.toml` manifest and a `src/` tree. `ldp3 build`
compiles every `.ldp3` under `src/` as one program and links the result into `build-output/`.

```
myapp/
├── ldp3.toml
├── src/
│   └── main.ldp3
└── build-output/     (produced by `ldp3 build`)
```

## 15.3 The `ldp3.toml` manifest

```toml
[ldp3_project]

[program]
name = "MyApp"
version = "0.1.0"
language_version = "1.0"
entry = "src/main.ldp3"

[dependencies]
ldp3-opengl = { path = "../ldp3-opengl" }

[build]
output = "build-output/"
target = "x86_64-windows"
freestanding = false
subsystem = "windows"          # a GUI app: no console window on launch
native_libs = "opengl32, gdi32, user32, kernel32"
```

- **`[program]`** (or **`[library]`** for a reusable bundle) — `name`, `version`,
  `language_version`, and `entry` (the file holding `main`). A `[library]` builds an `.ldb`
  bundle plus an `.ldh` header instead of an executable.
- **`[dependencies]`** — each entry is either a **path** dependency
  (`name = { path = "../sibling" }`) or a plugged one fetched by `ldp3 plug`. Dependencies
  are other LDP3 projects/libraries.
- **`[build]`** — `output` (the build directory), `target` (an LLVM triple, e.g.
  `x86_64-windows`), `freestanding` (bare-metal mode; see [§11](#11-systems-programming)),
  `subsystem` (`windows` links a GUI app with no console window; the default is a console
  app), `native_libs` (a comma-separated list of native import libraries to link for FFI),
  and `environment` (a named shared environment to build against).

## 15.4 Dependencies and environments

`ldp3 plug` fetches a dependency and records it in `[dependencies]`; `ldp3 unplug` removes
one. A **path dependency** points at a sibling project on disk and is built from source as
part of the build — the pattern Forge uses for `ldp3-opengl`.

**Environments** (`ldp3 env`) are shared toolchain/dependency sets: create one with
`ldp3 env new <name>`, list them with `ldp3 env list`, and point a project at one via the
`environment` key in `[build]`, so several projects share one resolved set of dependencies
instead of each re-fetching them.

## 15.5 Editor integration

The Forge IDE and the VS Code extension drive this same toolchain: `ldp3 check --overlay`
powers live diagnostics on the unsaved buffer, `ldp3 build`/`run`/`test` back the build and
run commands, `ldp3 fmt` formats on demand, and `ldp3 explain` backs the "explain this
diagnostic" action.
