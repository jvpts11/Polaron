# 15. The toolchain & projects

`polaron` is the one command you drive the language with: it builds and runs projects, checks
and formats source, manages dependencies and environments, and scaffolds new projects. Under
it sits `polc`, the compiler proper; you rarely call `polc` directly.

## 15.1 The `polaron` command

| Command | What it does |
|---------|--------------|
| `polaron run [file.pol] [-- args...]` | Build and run — the current project, or a single bare file. Arguments after `--` go to the program. |
| `polaron build` | Build the current project into `build-output/`. |
| `polaron check [--project <dir>] [--overlay <file>=<tmp>]` | Type-check and print diagnostics without emitting anything. `--overlay` checks a file as it reads in a temp buffer — the hook editors use for live diagnostics. |
| `polaron compile <file.pol>` | Compile one file to an `.exe`, without running it. |
| `polaron test [-- args...]` | Build and run the project's `[Test]` methods. Arguments after `--` go to the runner: `--filter <text>` narrows the run, `--list` names the tests without running them, `--timing` adds durations. |
| `polaron fmt [file.pol]` | Format the project's source (or one file) in place. |
| `polaron doc` | Render the public API to HTML from `///` doc comments. |
| `polaron explain <code>` | Print the why / fix / prevent for a diagnostic code (see [§13](#13-diagnostics)). |
| `polaron plug [<url\|name>[@version]] [-e]` | Download a dependency (or all of them if none is named). |
| `polaron unplug <name> [-e]` | Remove a dependency. |
| `polaron env new\|list\|remove [<name>]` | Manage shared environments (toolchain/dependency sets reused across projects). |
| `polaron new <name>` / `polaron init` | Scaffold a new project (in a new directory, or in the current one). |
| `polaron clean` | Remove `build-output/`. |
| `polaron studio` | Open the TUI project manager. |
| `polaron --version` / `polaron --help` | Print the version / usage. |

### Turning off the escape checks

The **region binder** — the analysis that stops a pointer to a dead frame from leaving the
frame ([§5.4](#54-no-undefined-behavior-dangling-double-free-and-the-trap)) — is on by
default. `polc --no-region-binder` turns it off for a whole program.

There is deliberately no per-line version. A line that hands out a pointer to storage that
is about to disappear looks like ordinary code, which is exactly how the mistake survives
review; so the way to opt out is one flag, visible in the build, rather than an annotation
buried in the source. `polc --check` accepts the same flag and has the same default, so
the editor's live diagnostics and the build never disagree about what is an error.

## 15.2 Project layout

A project is a directory with an `polaron.toml` manifest and a `src/` tree. `polaron build`
compiles every `.pol` under `src/` as one program and links the result into `build-output/`.

```
myapp/
├── polaron.toml
├── src/
│   └── main.pol
└── build-output/     (produced by `polaron build`)
```

## 15.3 The `polaron.toml` manifest

```toml
[polaron_project]

[program]
name = "MyApp"
version = "0.1.0"
language_version = "1.0"
entry = "src/main.pol"

[dependencies]
Polaron-OpenGL = "https://github.com/jvpts11/Polaron-OpenGL@v1.0.0"

[build]
output = "build-output/"
target = "x86_64-windows"
freestanding = false
subsystem = "windows"          # a GUI app: no console window on launch
```

Nothing here names opengl32 or gdi32, though the program links both. The classes that declare those
externs say which library they come from, the library's own manifest maps that name to a file per
platform, and the link inherits it — see [§11.8](#118-ffi-calling-c-from-polaron).

- **`[program]`** (or **`[library]`** for a reusable bundle) — `name`, `version`,
  `language_version`, and `entry` (the file holding `main`). A `[library]` builds an `.polb`
  bundle plus an `.polh` header instead of an executable.
- **`[dependencies]`** — each entry names another Polaron library and says where it is:
  - a **plugged** library, fetched by `polaron plug` and installed under `libraries/`:
    `Polaron-OpenGL = { path = "libraries/Polaron-OpenGL", source = "https://…@v1.0.1" }`. `path` is
    where it lives now; `source` is the link it came from. Writing the bare link
    (`Name = "https://…@v1.0.1"`) is the same entry with the location left to its default, which is
    what a command line gives and what `plug` expands.
  - a **path** dependency — a sibling project built from source with yours:
    `somelib = { path = "../somelib" }`. No `source`, because it was never fetched.
- **`[build]`** — `output` (the build directory), `target` (an LLVM triple, e.g.
  `x86_64-windows`), `freestanding` (bare-metal mode; see [§11](#11-systems-programming)),
  `subsystem` (`windows` links a GUI app with no console window; the default is a console
  app), `native_libs` (the older blunt way to name import libraries for FFI), and `environment`
  (a named shared environment to build against).
- **`[libraries]`** — what each logical foreign-library name (`class Wgl library OpenGL`) means on
  each platform: `OpenGL = { windows = "opengl32", linux = "GL" }`. A dependency's entries apply to
  whoever links it, so a consumer does not repeat its dependency's link list.

## 15.4 Dependencies and environments

`polaron plug` fetches a dependency into **`libraries/`** inside your project, compiles it — every source
file of it, not just its entry — and records it in `[dependencies]` as what it is, where it is, and where
it came from. `polaron unplug` removes both the directory and the entry. The `libraries/` directory is
build output, not source: `polaron new` puts it in `.gitignore`, and `polaron plug` with no arguments
rebuilds it from the manifest and `polaron.lock`, which pins the exact resolved version of everything
installed.

A **path dependency** points at a sibling project on disk instead, and is built from source as part of
the build: the pattern for a library being developed alongside its consumer.

**Environments** (`polaron env`) are shared toolchain/dependency sets: create one with
`polaron env new <name>`, list them with `polaron env list`, and point a project at one via the
`environment` key in `[build]`, so several projects share one resolved set of dependencies
instead of each re-fetching them.

## 15.5 Editor integration

The Forge IDE and the VS Code extension drive this same toolchain: `polaron check --overlay`
powers live diagnostics on the unsaved buffer, `polaron build`/`run`/`test` back the build and
run commands, `polaron fmt` formats on demand, and `polaron explain` backs the "explain this
diagnostic" action.
