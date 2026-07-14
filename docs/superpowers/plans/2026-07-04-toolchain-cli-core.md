# `ldp3` CLI core + build/run — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A lightweight `ldp3` command that scaffolds projects and drives an LDP3 program all the way to a native `.exe` and runs it, without the user invoking `clang` by hand.

**Architecture:** `ldp3.exe` is a small driver (no LLVM). It reads an `ldp3.toml` manifest, spawns the existing `ldp3c` compiler to emit LLVM IR, then spawns `clang` to link that IR with a prebuilt runtime static lib into a `.exe` in `build-output/` (the cargo→rustc model). `ldp3c` is unchanged and kept as the low-level compiler.

**Tech Stack:** C++20, CMake, doctest (unit tests), CTest (integration). Windows/MSVC. Process spawning via `_spawnv` (`<process.h>`). No external dependencies beyond LLVM (already used by `ldp3c`) and doctest.

## Global Constraints

- C++20; RAII everywhere; `std::filesystem` for paths; no `new`/`delete`.
- All code, comments, identifiers, and commit messages in **English**. No C source files anywhere — C++ only.
- Commit style: lowercase imperative subject, blank line, prose body (no bullet lists), **no** prefix like `feat:`, **no** `Co-Authored-By`. One task per commit.
- Always `git add <explicit paths>` — **never** `git add -A`/`git add .` (the repo has intentionally-untracked files: `CLAUDE.md`, `docs/`, `tests/samples/*.ll`).
- Keep the whole CTest suite green (currently 455 tests).
- Windows shell for building is PowerShell; `&&` is unsupported (use `;`). Build the compiler with `cmake --build build --config Debug`. Reconfigure with `cmake -B build -S .` after editing any `CMakeLists.txt`.
- Manifest conventional name: `ldp3.toml`, identified by a first non-blank line of `[ldp3_project]`.
- `ldp3.exe` and `ldp3c.exe` are siblings in `build/bin/<config>/`; the runtime static lib `ldp3_rt.lib` is placed alongside them. `clang` is external (found via env `LDP3_CLANG`, then `PATH`, then a compile-time default).

---

## File Structure

- `CMakeLists.txt` (modify) — move the `find_program(clang)` to top level; add the `ldp3_rt` static lib; generate `ldp3_config.h`; add the `ldp3_driver` static lib and the `ldp3` executable.
- `src/driver/config.h.in` (create) — template for the generated `ldp3_config.h` (default clang path).
- `src/driver/ldp3_main.cpp` (create) — `main()` + subcommand dispatch. Links `ldp3_driver`.
- `src/driver/manifest.h` / `manifest.cpp` (create) — `Manifest` struct, minimal-TOML parse, upward search, ephemeral manifest.
- `src/driver/toolchain.h` / `toolchain.cpp` (create) — locate the running exe's directory, `ldp3c`, `clang`, `ldp3_rt.lib`.
- `src/driver/process.h` / `process.cpp` (create) — `runProcess(exe, args)` over `_spawnv`.
- `src/driver/scaffold.h` / `scaffold.cpp` (create) — `new`/`init` project scaffolding.
- `src/driver/build.h` / `build.cpp` (create) — resolve → compile (`ldp3c`) → link (`clang`) → optional run.
- `tests/CMakeLists.txt` (modify) — CTest integration tests for the driver.
- `tests/unit/test_manifest.cpp` (create) — doctest unit tests for the manifest parser.

The five logic modules (`manifest`, `toolchain`, `process`, `scaffold`, `build`) compile into a `ldp3_driver` static lib so both `ldp3` and `ldp3_unit_tests` can link them.

---

### Task 1: CMake wiring + `ldp3` binary with `--version`/`--help`

**Files:**
- Modify: `CMakeLists.txt`
- Create: `src/driver/config.h.in`
- Create: `src/driver/ldp3_main.cpp`
- Modify: `tests/CMakeLists.txt`

**Interfaces:**
- Produces: the `ldp3` executable; a generated `${CMAKE_BINARY_DIR}/ldp3_config.h` defining `LDP3_DEFAULT_CLANG`; the `ldp3_rt` static lib emitted next to the binaries; a `ldp3_driver` static lib (empty for now, populated by later tasks).

- [ ] **Step 1: Add the version integration test (failing)**

In `tests/CMakeLists.txt`, right after the existing `cli_version` test block, add:

```cmake
# ---- ldp3 driver (unified toolchain) integration tests ----
add_test(NAME ldp3_version COMMAND ldp3 --version)
set_tests_properties(ldp3_version PROPERTIES
    PASS_REGULAR_EXPRESSION "ldp3 0\\.1\\.0-dev")
```

- [ ] **Step 2: Wire the build (CMakeLists.txt)**

Move the clang lookup to the top level so both the config header and the tests can use it. In `tests/CMakeLists.txt`, delete the line `find_program(LDP3_CLANG clang HINTS "C:/Program Files/LLVM/bin")` (leave the `if(LDP3_CLANG)` using it). In the top-level `CMakeLists.txt`, replace the final lines (from `add_executable(ldp3c ...)` onward) with:

```cmake
add_executable(ldp3c src/cli/main.cpp)
target_link_libraries(ldp3c PRIVATE ldp3_core)

# Prebuilt runtime linked into every LDP3 program (placed next to the binaries so the driver
# finds it as a sibling).
add_library(ldp3_rt STATIC runtime/ldp3_rt.cpp)
set_target_properties(ldp3_rt PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

# Locate clang for the driver's compile-time default (same lookup the tests use).
find_program(LDP3_CLANG clang HINTS "C:/Program Files/LLVM/bin")
if(NOT LDP3_CLANG)
    set(LDP3_CLANG "clang")  # fall back to PATH lookup at run time
endif()
configure_file(src/driver/config.h.in "${CMAKE_BINARY_DIR}/ldp3_config.h" @ONLY)

# The lightweight toolchain driver: spawns ldp3c + clang. No LLVM.
add_library(ldp3_driver STATIC src/driver/dummy.cpp)
target_include_directories(ldp3_driver PUBLIC src "${CMAKE_BINARY_DIR}")

add_executable(ldp3 src/driver/ldp3_main.cpp)
target_link_libraries(ldp3 PRIVATE ldp3_driver)

enable_testing()
add_subdirectory(tests)
```

Note: `src/driver/dummy.cpp` is a placeholder so the lib is non-empty until Task 2 adds `manifest.cpp`. Create it:

```cpp
// Placeholder translation unit; real modules are added task by task.
namespace ldp3::driver { void _link_anchor() {} }
```
(Create `src/driver/dummy.cpp` with exactly that content.)

- [ ] **Step 3: Create the config header template**

Create `src/driver/config.h.in`:

```cpp
#pragma once
// Generated by CMake from config.h.in. Compile-time default paths for the driver.
#define LDP3_DEFAULT_CLANG "@LDP3_CLANG@"
```

- [ ] **Step 4: Create the driver entry point**

Create `src/driver/ldp3_main.cpp`:

```cpp
// The `ldp3` toolchain driver: a lightweight front-end that dispatches subcommands and orchestrates
// the low-level compiler (ldp3c) and linker (clang). Carries no LLVM itself.
#include <cstdio>
#include <string>
#include <vector>

namespace {
constexpr const char* kVersion = "ldp3 0.1.0-dev";

int printHelp() {
    std::printf(
        "ldp3 - the LDP3 toolchain\n\n"
        "usage:\n"
        "  ldp3 run [file.ldp3] [-- args...]   build and run (current project, or a bare file)\n"
        "  ldp3 build                          build the current project to build-output/\n"
        "  ldp3 compile <file.ldp3>            compile one file to an .exe (no run)\n"
        "  ldp3 new <name>                     scaffold a new project\n"
        "  ldp3 init                           scaffold in the current directory\n"
        "  ldp3 clean                          remove build-output/\n"
        "  ldp3 --version                      print the version\n"
        "  ldp3 --help                         print this help\n");
    return 0;
}
}  // namespace

int main(int argc, char** argv) {
    std::vector<std::string> args(argv + 1, argv + argc);
    if (args.empty()) return printHelp();
    const std::string& cmd = args[0];

    if (cmd == "--version" || cmd == "-v") {
        std::printf("%s\n", kVersion);
        return 0;
    }
    if (cmd == "--help" || cmd == "-h") return printHelp();

    std::fprintf(stderr, "ldp3: unknown command '%s'\n", cmd.c_str());
    printHelp();
    return 2;
}
```

- [ ] **Step 5: Configure and build**

Run:
```
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=C:/Users/jvpts/vcpkg/scripts/buildsystems/vcpkg.cmake -DLDP3_WITH_LLVM=ON
cmake --build build --config Debug --target ldp3
```
Expected: `ldp3.exe` builds in `build/bin/Debug/`.

- [ ] **Step 6: Run the test to verify it passes**

Run: `ctest --test-dir build -C Debug -R ldp3_version --output-on-failure`
Expected: PASS (output contains `ldp3 0.1.0-dev`).

- [ ] **Step 7: Commit**

```
git add CMakeLists.txt tests/CMakeLists.txt src/driver/config.h.in src/driver/ldp3_main.cpp src/driver/dummy.cpp
git commit -m "add the ldp3 driver binary with version and help" -m "A new lightweight ldp3 executable dispatches subcommands; it links a ldp3_driver static lib (populated in later tasks) and carries no LLVM. CMake now also builds the runtime as a ldp3_rt static lib next to the binaries and generates ldp3_config.h with the default clang path. Only --version and --help are wired so far."
```

---

### Task 2: Manifest model + minimal-TOML parser

**Files:**
- Create: `src/driver/manifest.h`, `src/driver/manifest.cpp`
- Create: `tests/unit/test_manifest.cpp`
- Modify: `CMakeLists.txt` (add `manifest.cpp` to `ldp3_driver`, drop `dummy.cpp`), `tests/CMakeLists.txt` (add the unit test file)

**Interfaces:**
- Produces:
  - `struct ldp3::driver::Manifest { std::string name, version, languageVersion, entry, outputDir, target; bool freestanding; bool hasDependencies; };`
  - `Manifest ldp3::driver::parseManifestText(const std::string& text);` — parse TOML subset text.
  - `std::optional<std::filesystem::path> ldp3::driver::findManifest(const std::filesystem::path& start);` — walk up from `start` for a `.toml` whose first non-blank line is `[ldp3_project]`.
  - `Manifest ldp3::driver::ephemeralManifest(const std::filesystem::path& file);` — synthesize for a bare file.

- [ ] **Step 1: Write the failing unit tests**

Create `tests/unit/test_manifest.cpp`:

```cpp
#include <doctest/doctest.h>
#include "driver/manifest.h"

using namespace ldp3::driver;

TEST_CASE("parseManifestText reads program fields") {
    const std::string toml =
        "[ldp3_project]\n"
        "[program]\n"
        "name = \"demo\"\n"
        "version = \"0.1.0\"\n"
        "language_version = \"1.0\"\n"
        "entry = \"src/main.ldp3\"\n"
        "[build]\n"
        "output = \"build-output/\"\n"
        "target = \"x86_64-windows\"\n"
        "freestanding = false\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.name == "demo");
    CHECK(m.version == "0.1.0");
    CHECK(m.entry == "src/main.ldp3");
    CHECK(m.outputDir == "build-output/");
    CHECK(m.target == "x86_64-windows");
    CHECK(m.freestanding == false);
    CHECK(m.hasDependencies == false);
}

TEST_CASE("parseManifestText ignores comments and detects dependencies") {
    const std::string toml =
        "[ldp3_project]\n"
        "[program]\n"
        "name = \"x\"  # trailing comment\n"
        "entry = \"main.ldp3\"\n"
        "[dependencies]\n"
        "audio = \"1.0.0\"\n";
    Manifest m = parseManifestText(toml);
    CHECK(m.name == "x");
    CHECK(m.entry == "main.ldp3");
    CHECK(m.hasDependencies == true);
}

TEST_CASE("ephemeralManifest uses the file stem and its path") {
    Manifest m = ephemeralManifest("samples/hello_world.ldp3");
    CHECK(m.name == "hello_world");
    CHECK(m.entry == "samples/hello_world.ldp3");
    CHECK(m.version == "0.0.0");
    CHECK(m.hasDependencies == false);
}
```

- [ ] **Step 2: Wire the sources**

In `CMakeLists.txt`, change the driver lib line to:
```cmake
add_library(ldp3_driver STATIC src/driver/manifest.cpp)
```
Delete `src/driver/dummy.cpp`. In `tests/CMakeLists.txt`, add `unit/test_manifest.cpp` to the `add_executable(ldp3_unit_tests ...)` source list, and after it add `target_link_libraries(ldp3_unit_tests PRIVATE ldp3_driver)` (append `ldp3_driver` to the existing link line).

- [ ] **Step 3: Run the tests to verify they fail**

Run: `cmake -B build -S . ; cmake --build build --config Debug --target ldp3_unit_tests`
Expected: FAIL to compile (`driver/manifest.h` not found).

- [ ] **Step 4: Write the manifest header**

Create `src/driver/manifest.h`:

```cpp
#pragma once
#include <filesystem>
#include <optional>
#include <string>

namespace ldp3::driver {

// A resolved project manifest. Fields not present in the file keep their defaults.
struct Manifest {
    std::string name;
    std::string version = "0.0.0";
    std::string languageVersion;
    std::string entry;
    std::string outputDir = "build-output/";
    std::string target = "x86_64-windows";
    bool freestanding = false;
    bool hasDependencies = false;  // true if [dependencies] has any non-blank entry
};

// Parse the supported TOML subset ([program]/[build]/[dependencies]) from text.
Manifest parseManifestText(const std::string& text);

// Walk up from `start` (inclusive) looking for a .toml whose first non-blank line is [ldp3_project].
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start);

// Synthesize a manifest for a single loose file (name = stem, entry = the file).
Manifest ephemeralManifest(const std::filesystem::path& file);

}  // namespace ldp3::driver
```

- [ ] **Step 5: Write the manifest implementation**

Create `src/driver/manifest.cpp`:

```cpp
#include "driver/manifest.h"
#include <fstream>
#include <sstream>

namespace ldp3::driver {
namespace {

std::string trim(const std::string& s) {
    const char* ws = " \t\r\n";
    const auto b = s.find_first_not_of(ws);
    if (b == std::string::npos) return "";
    const auto e = s.find_last_not_of(ws);
    return s.substr(b, e - b + 1);
}

// Strip a trailing unquoted # comment, then trim.
std::string stripComment(const std::string& s) {
    bool inQuotes = false;
    for (size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '"') inQuotes = !inQuotes;
        else if (s[i] == '#' && !inQuotes) return trim(s.substr(0, i));
    }
    return trim(s);
}

std::string unquote(const std::string& s) {
    if (s.size() >= 2 && s.front() == '"' && s.back() == '"') return s.substr(1, s.size() - 2);
    return s;
}

}  // namespace

Manifest parseManifestText(const std::string& text) {
    Manifest m;
    std::istringstream in(text);
    std::string line;
    std::string section;
    while (std::getline(in, line)) {
        const std::string s = stripComment(line);
        if (s.empty()) continue;
        if (s.front() == '[' && s.back() == ']') {
            section = s.substr(1, s.size() - 2);
            continue;
        }
        const auto eq = s.find('=');
        if (eq == std::string::npos) continue;
        const std::string key = trim(s.substr(0, eq));
        const std::string val = unquote(trim(s.substr(eq + 1)));
        if (section == "program") {
            if (key == "name") m.name = val;
            else if (key == "version") m.version = val;
            else if (key == "language_version") m.languageVersion = val;
            else if (key == "entry") m.entry = val;
        } else if (section == "build") {
            if (key == "output") m.outputDir = val;
            else if (key == "target") m.target = val;
            else if (key == "freestanding") m.freestanding = (val == "true");
        } else if (section == "dependencies") {
            m.hasDependencies = true;
        }
    }
    return m;
}

std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start) {
    namespace fs = std::filesystem;
    fs::path dir = fs::absolute(start);
    if (fs::is_regular_file(dir)) dir = dir.parent_path();
    for (;; dir = dir.parent_path()) {
        std::error_code ec;
        for (const auto& entry : fs::directory_iterator(dir, ec)) {
            if (!entry.is_regular_file() || entry.path().extension() != ".toml") continue;
            std::ifstream f(entry.path());
            std::string line;
            while (std::getline(f, line)) {
                const std::string t = trim(line);
                if (t.empty()) continue;
                if (t == "[ldp3_project]") return entry.path();
                break;  // first non-blank line only
            }
        }
        if (!dir.has_parent_path() || dir == dir.parent_path()) return std::nullopt;
    }
}

Manifest ephemeralManifest(const std::filesystem::path& file) {
    Manifest m;
    m.name = file.stem().string();
    m.entry = file.string();
    m.version = "0.0.0";
    return m;
}

}  // namespace ldp3::driver
```

- [ ] **Step 6: Run the tests to verify they pass**

Run: `cmake -B build -S . ; cmake --build build --config Debug --target ldp3_unit_tests ; ctest --test-dir build -C Debug -R unit_tests --output-on-failure`
Expected: PASS (the three manifest cases run inside `unit_tests`).

- [ ] **Step 7: Commit**

```
git add CMakeLists.txt tests/CMakeLists.txt src/driver/manifest.h src/driver/manifest.cpp tests/unit/test_manifest.cpp
git commit -m "add the project manifest and its TOML-subset parser" -m "The driver reads ldp3.toml: parseManifestText handles the [program], [build] and [dependencies] sections (quoted and bare values, trailing comments), findManifest walks up from the cwd for a .toml headed by [ldp3_project], and ephemeralManifest synthesizes one for a loose file. Covered by doctest unit tests."
```

---

### Task 3: Scaffolding — `ldp3 new` and `ldp3 init`

**Files:**
- Create: `src/driver/scaffold.h`, `src/driver/scaffold.cpp`
- Modify: `src/driver/ldp3_main.cpp` (dispatch `new`/`init`), `CMakeLists.txt` (add `scaffold.cpp`), `tests/CMakeLists.txt` (integration test)

**Interfaces:**
- Consumes: nothing from other driver modules.
- Produces: `int ldp3::driver::scaffold(const std::filesystem::path& dir, const std::string& name);` — writes `dir/ldp3.toml`, `dir/src/main.ldp3`, `dir/.gitignore`; returns 0 on success, non-zero on error.

- [ ] **Step 1: Write the failing integration test**

In `tests/CMakeLists.txt`, under the ldp3 driver tests, add:

```cmake
add_test(NAME ldp3_new_scaffolds
    COMMAND ldp3 new demoproj
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
set_tests_properties(ldp3_new_scaffolds PROPERTIES
    PASS_REGULAR_EXPRESSION "created project 'demoproj'")

add_test(NAME ldp3_new_wrote_manifest
    COMMAND "${CMAKE_COMMAND}" -E cat "${CMAKE_CURRENT_BINARY_DIR}/demoproj/ldp3.toml")
set_tests_properties(ldp3_new_wrote_manifest PROPERTIES
    DEPENDS ldp3_new_scaffolds
    PASS_REGULAR_EXPRESSION "\\[ldp3_project\\]")
```

- [ ] **Step 2: Wire the source**

In `CMakeLists.txt`, extend the driver lib:
```cmake
add_library(ldp3_driver STATIC src/driver/manifest.cpp src/driver/scaffold.cpp)
```

- [ ] **Step 3: Run to verify it fails**

Run: `cmake -B build -S . ; cmake --build build --config Debug --target ldp3 ; ctest --test-dir build -C Debug -R ldp3_new_scaffolds --output-on-failure`
Expected: FAIL (`ldp3` prints "unknown command 'new'", no match).

- [ ] **Step 4: Write the scaffold header**

Create `src/driver/scaffold.h`:

```cpp
#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

// Create dir/ (if needed) with ldp3.toml, src/main.ldp3 and .gitignore for a project called `name`.
int scaffold(const std::filesystem::path& dir, const std::string& name);

}  // namespace ldp3::driver
```

- [ ] **Step 5: Write the scaffold implementation**

Create `src/driver/scaffold.cpp`:

```cpp
#include "driver/scaffold.h"
#include <cstdio>
#include <fstream>

namespace ldp3::driver {
namespace fs = std::filesystem;

namespace {
bool writeFile(const fs::path& p, const std::string& content) {
    std::ofstream f(p, std::ios::binary);
    if (!f) return false;
    f << content;
    return static_cast<bool>(f);
}
}  // namespace

int scaffold(const fs::path& dir, const std::string& name) {
    std::error_code ec;
    fs::create_directories(dir / "src", ec);
    if (ec) {
        std::fprintf(stderr, "ldp3: cannot create '%s': %s\n", dir.string().c_str(), ec.message().c_str());
        return 1;
    }

    const std::string manifest =
        "[ldp3_project]\n\n"
        "[program]\n"
        "name = \"" + name + "\"\n"
        "version = \"0.1.0\"\n"
        "language_version = \"1.0\"\n"
        "entry = \"src/main.ldp3\"\n\n"
        "[dependencies]\n\n"
        "[build]\n"
        "output = \"build-output/\"\n"
        "target = \"x86_64-windows\"\n"
        "freestanding = false\n";

    const std::string main =
        "import System.IO.Console;\n"
        "program " + name + ";\n\n"
        "public bundle main {\n"
        "    public namespace app {\n"
        "        public class Main {\n"
        "            public static method main(string[] args) returns void {\n"
        "                System.IO.Console.println(\"Hello from " + name + "!\");\n"
        "                return;\n"
        "            }\n"
        "        }\n"
        "    }\n"
        "}\n";

    const std::string gitignore = "packages/\nbuild-output/\n";

    if (!writeFile(dir / "ldp3.toml", manifest) ||
        !writeFile(dir / "src" / "main.ldp3", main) ||
        !writeFile(dir / ".gitignore", gitignore)) {
        std::fprintf(stderr, "ldp3: failed to write project files\n");
        return 1;
    }
    std::printf("created project '%s'\n", name.c_str());
    return 0;
}

}  // namespace ldp3::driver
```

- [ ] **Step 6: Dispatch `new`/`init` in the driver**

In `src/driver/ldp3_main.cpp`, add `#include "driver/scaffold.h"` and `#include <filesystem>` at the top, and insert before the "unknown command" block:

```cpp
    if (cmd == "new") {
        if (args.size() < 2) { std::fprintf(stderr, "ldp3: 'new' requires a project name\n"); return 2; }
        return ldp3::driver::scaffold(std::filesystem::path(args[1]), args[1]);
    }
    if (cmd == "init") {
        const std::filesystem::path cwd = std::filesystem::current_path();
        return ldp3::driver::scaffold(cwd, cwd.filename().string());
    }
```

- [ ] **Step 7: Run to verify it passes**

Run: `cmake --build build --config Debug --target ldp3 ; ctest --test-dir build -C Debug -R "ldp3_new" --output-on-failure`
Expected: PASS (both `ldp3_new_scaffolds` and `ldp3_new_wrote_manifest`).

- [ ] **Step 8: Commit**

```
git add CMakeLists.txt tests/CMakeLists.txt src/driver/scaffold.h src/driver/scaffold.cpp src/driver/ldp3_main.cpp
git commit -m "add project scaffolding via ldp3 new and ldp3 init" -m "scaffold writes ldp3.toml, src/main.ldp3 (a hello-world entry point) and a .gitignore for packages/ and build-output/. 'new <name>' creates a directory; 'init' scaffolds the current one. Covered by a CTest integration test."
```

---

### Task 4: Toolchain locator + process runner + build orchestrator + `ldp3 compile`

**Files:**
- Create: `src/driver/process.h`, `src/driver/process.cpp`
- Create: `src/driver/toolchain.h`, `src/driver/toolchain.cpp`
- Create: `src/driver/build.h`, `src/driver/build.cpp`
- Modify: `src/driver/ldp3_main.cpp` (dispatch `compile`), `CMakeLists.txt`, `tests/CMakeLists.txt`

**Interfaces:**
- Consumes: `Manifest` (Task 2).
- Produces:
  - `int ldp3::driver::runProcess(const std::string& exe, const std::vector<std::string>& args);`
  - `struct ldp3::driver::Toolchain { std::string ldp3c, clang, runtimeLib; };`
  - `Toolchain ldp3::driver::locateToolchain();`
  - `struct ldp3::driver::BuildOptions { bool run; std::vector<std::string> runArgs; std::vector<std::string> passthrough; };`
  - `int ldp3::driver::buildProgram(const Manifest& m, const std::filesystem::path& projectDir, const BuildOptions& opts);` — compile+link (+run if `opts.run`); returns the program's exit code (or a non-zero build error).

- [ ] **Step 1: Write the failing integration test**

In `tests/CMakeLists.txt`, guard on clang (like the existing pipeline tests) and add:

```cmake
if(LDP3_CLANG)
    add_test(NAME ldp3_compile_produces_exe
        COMMAND ldp3 compile "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    set_tests_properties(ldp3_compile_produces_exe PROPERTIES
        PASS_REGULAR_EXPRESSION "wrote .*hello_world.exe")
endif()
```

- [ ] **Step 2: Wire the sources**

In `CMakeLists.txt`, extend the driver lib and make the clang default available:
```cmake
add_library(ldp3_driver STATIC
    src/driver/manifest.cpp
    src/driver/scaffold.cpp
    src/driver/process.cpp
    src/driver/toolchain.cpp
    src/driver/build.cpp)
```

- [ ] **Step 3: Run to verify it fails**

Run: `cmake -B build -S . ; cmake --build build --config Debug --target ldp3`
Expected: FAIL to build (`compile` dispatch references undefined symbols) — or, before Step 6, `ldp3 compile` reports "unknown command".

- [ ] **Step 4: Write the process runner**

Create `src/driver/process.h`:

```cpp
#pragma once
#include <string>
#include <vector>

namespace ldp3::driver {

// Spawn `exe` with `args` and wait. Returns the child's exit code, or -1 if it could not start.
int runProcess(const std::string& exe, const std::vector<std::string>& args);

}  // namespace ldp3::driver
```

Create `src/driver/process.cpp`:

```cpp
#include "driver/process.h"
#include <process.h>
#include <vector>

namespace ldp3::driver {

int runProcess(const std::string& exe, const std::vector<std::string>& args) {
    std::vector<const char*> argv;
    argv.push_back(exe.c_str());
    for (const auto& a : args) argv.push_back(a.c_str());
    argv.push_back(nullptr);
    // _P_WAIT returns the child's exit code (no shell involved, so paths with spaces are safe).
    const intptr_t rc = _spawnv(_P_WAIT, exe.c_str(), argv.data());
    return static_cast<int>(rc);
}

}  // namespace ldp3::driver
```

- [ ] **Step 5: Write the toolchain locator**

Create `src/driver/toolchain.h`:

```cpp
#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

struct Toolchain {
    std::string ldp3c;       // low-level compiler (sibling of this exe, or $LDP3C)
    std::string clang;       // linker driver ($LDP3_CLANG, PATH, or compile-time default)
    std::string runtimeLib;  // ldp3_rt.lib (sibling of this exe, or $LDP3_RUNTIME)
};

// Directory containing the running ldp3 executable.
std::filesystem::path exeDir();

// Resolve the tools the driver needs.
Toolchain locateToolchain();

}  // namespace ldp3::driver
```

Create `src/driver/toolchain.cpp`:

```cpp
#include "driver/toolchain.h"
#include "ldp3_config.h"
#include <cstdlib>
#include <windows.h>

namespace ldp3::driver {
namespace fs = std::filesystem;

namespace {
std::string envOr(const char* name, const std::string& fallback) {
    const char* v = std::getenv(name);
    return (v && *v) ? std::string(v) : fallback;
}
}  // namespace

fs::path exeDir() {
    char buf[MAX_PATH];
    const DWORD n = GetModuleFileNameA(nullptr, buf, MAX_PATH);
    return fs::path(std::string(buf, n)).parent_path();
}

Toolchain locateToolchain() {
    const fs::path dir = exeDir();
    Toolchain t;
    t.ldp3c = envOr("LDP3C", (dir / "ldp3c.exe").string());
    t.runtimeLib = envOr("LDP3_RUNTIME", (dir / "ldp3_rt.lib").string());
    t.clang = envOr("LDP3_CLANG", LDP3_DEFAULT_CLANG);  // may be a bare "clang" resolved via PATH
    return t;
}

}  // namespace ldp3::driver
```

- [ ] **Step 6: Write the build orchestrator**

Create `src/driver/build.h`:

```cpp
#pragma once
#include <filesystem>
#include <string>
#include <vector>
#include "driver/manifest.h"

namespace ldp3::driver {

struct BuildOptions {
    bool run = false;                       // execute the exe after building
    std::vector<std::string> runArgs;       // args passed to the program (run only)
    std::vector<std::string> passthrough;   // extra flags forwarded to ldp3c (--target, -O, ...)
};

// Compile the manifest's entry to IR (ldp3c) then link to an .exe (clang) under the output dir.
// If opts.run, execute it and return its exit code. Returns non-zero on any build failure.
int buildProgram(const Manifest& m, const std::filesystem::path& projectDir, const BuildOptions& opts);

}  // namespace ldp3::driver
```

Create `src/driver/build.cpp`:

```cpp
#include "driver/build.h"
#include "driver/process.h"
#include "driver/toolchain.h"
#include <cstdio>

namespace ldp3::driver {
namespace fs = std::filesystem;

int buildProgram(const Manifest& m, const fs::path& projectDir, const BuildOptions& opts) {
    if (m.hasDependencies) {
        std::fprintf(stderr, "ldp3: dependencies are not supported yet (coming in a later release)\n");
        return 1;
    }
    const Toolchain tc = locateToolchain();

    const fs::path entry = projectDir / m.entry;
    if (!fs::is_regular_file(entry)) {
        std::fprintf(stderr, "ldp3: entry file not found: %s\n", entry.string().c_str());
        return 1;
    }

    const fs::path outDir = projectDir / m.outputDir;
    std::error_code ec;
    fs::create_directories(outDir, ec);
    const fs::path ll = outDir / (m.name + ".ll");
    const fs::path exe = outDir / (m.name + ".exe");

    // 1) Compile: ldp3c <entry> -o <ll> [passthrough]
    std::vector<std::string> compileArgs = {entry.string(), "-o", ll.string()};
    for (const auto& p : opts.passthrough) compileArgs.push_back(p);
    if (int rc = runProcess(tc.ldp3c, compileArgs); rc != 0) {
        std::fprintf(stderr, "ldp3: compilation failed\n");
        return rc == -1 ? 1 : rc;
    }

    // 2) Link: clang <ll> <runtimeLib> -llegacy_stdio_definitions -lws2_32 -o <exe>
    std::vector<std::string> linkArgs = {
        "-Wno-override-module", ll.string(), tc.runtimeLib,
        "-llegacy_stdio_definitions", "-lws2_32", "-o", exe.string()};
    if (int rc = runProcess(tc.clang, linkArgs); rc != 0) {
        std::fprintf(stderr, "ldp3: link failed\n");
        return rc == -1 ? 1 : rc;
    }
    std::printf("wrote %s\n", exe.string().c_str());

    // 3) Optionally run.
    if (opts.run) return runProcess(exe.string(), opts.runArgs);
    return 0;
}

}  // namespace ldp3::driver
```

- [ ] **Step 7: Dispatch `compile` in the driver**

In `src/driver/ldp3_main.cpp`, add `#include "driver/build.h"` and `#include "driver/manifest.h"`, and insert before the unknown-command block:

```cpp
    if (cmd == "compile") {
        if (args.size() < 2) { std::fprintf(stderr, "ldp3: 'compile' requires a file\n"); return 2; }
        const std::filesystem::path file(args[1]);
        ldp3::driver::Manifest m = ldp3::driver::ephemeralManifest(file.filename());
        m.outputDir = "build-output/";
        ldp3::driver::BuildOptions opts;
        for (size_t i = 2; i < args.size(); ++i) opts.passthrough.push_back(args[i]);
        return ldp3::driver::buildProgram(m, file.parent_path().empty() ? "." : file.parent_path(), opts);
    }
```

- [ ] **Step 8: Build and run the test**

Run: `cmake -B build -S . ; cmake --build build --config Debug --target ldp3 ; ctest --test-dir build -C Debug -R ldp3_compile_produces_exe --output-on-failure`
Expected: PASS (`wrote .../build-output/hello_world.exe`).

- [ ] **Step 9: Commit**

```
git add CMakeLists.txt tests/CMakeLists.txt src/driver/process.h src/driver/process.cpp src/driver/toolchain.h src/driver/toolchain.cpp src/driver/build.h src/driver/build.cpp src/driver/ldp3_main.cpp
git commit -m "add the build orchestrator and ldp3 compile" -m "locateToolchain finds ldp3c and ldp3_rt.lib next to the ldp3 executable and clang via env/PATH/compile-time default; runProcess spawns them through _spawnv. buildProgram compiles the entry with ldp3c, links the IR with the runtime and system libs through clang into build-output/, and can run the result. 'ldp3 compile <file>' produces an .exe. Dependencies are rejected with a clear not-yet message."
```

---

### Task 5: `ldp3 build` (project-based)

**Files:**
- Modify: `src/driver/ldp3_main.cpp` (dispatch `build`), `tests/CMakeLists.txt` (integration test)

**Interfaces:**
- Consumes: `findManifest`, `parseManifestText` (Task 2); `buildProgram` (Task 4).

- [ ] **Step 1: Write the failing integration test**

In `tests/CMakeLists.txt`, add (guarded by clang). This scaffolds, then builds inside the scaffolded dir:

```cmake
if(LDP3_CLANG)
    add_test(NAME ldp3_build_project
        COMMAND ldp3 build
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
    set_tests_properties(ldp3_build_project PROPERTIES
        DEPENDS ldp3_new_scaffolds
        PASS_REGULAR_EXPRESSION "wrote .*demoproj.exe")
endif()
```

- [ ] **Step 2: Run to verify it fails**

Run: `cmake -B build -S . ; ctest --test-dir build -C Debug -R "ldp3_new_scaffolds|ldp3_build_project" --output-on-failure`
Expected: `ldp3_build_project` FAILS (`build` is still "unknown command").

- [ ] **Step 3: Dispatch `build` in the driver**

In `src/driver/ldp3_main.cpp`, add `#include <fstream>` and `#include <sstream>`, and insert before the unknown-command block:

```cpp
    if (cmd == "build") {
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr,
                "ldp3: no ldp3.toml found in this directory or any parent; "
                "run 'ldp3 init' or 'ldp3 run <file>'\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        ldp3::driver::Manifest m = ldp3::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "ldp3: manifest has no [program] entry\n"); return 1; }
        ldp3::driver::BuildOptions opts;
        return ldp3::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }
```

- [ ] **Step 4: Build and run the test**

Run: `cmake --build build --config Debug --target ldp3 ; ctest --test-dir build -C Debug -R "ldp3_new_scaffolds|ldp3_build_project" --output-on-failure`
Expected: PASS (`wrote .../demoproj/build-output/demoproj.exe`).

- [ ] **Step 5: Commit**

```
git add tests/CMakeLists.txt src/driver/ldp3_main.cpp
git commit -m "add ldp3 build for manifest projects" -m "'ldp3 build' locates ldp3.toml upward from the cwd, parses it, and builds the declared entry to the project's build-output/. A missing manifest gives a clear error pointing at 'ldp3 init' or 'ldp3 run <file>'."
```

---

### Task 6: `ldp3 run` + `ldp3 clean`

**Files:**
- Modify: `src/driver/ldp3_main.cpp` (dispatch `run`, `clean`), `tests/CMakeLists.txt` (integration tests)

**Interfaces:**
- Consumes: `findManifest`, `parseManifestText`, `ephemeralManifest` (Task 2); `buildProgram` with `opts.run = true` (Task 4).

- [ ] **Step 1: Write the failing integration tests**

In `tests/CMakeLists.txt`, add (guarded by clang):

```cmake
if(LDP3_CLANG)
    add_test(NAME ldp3_run_bare_file
        COMMAND ldp3 run "${CMAKE_CURRENT_SOURCE_DIR}/samples/hello_world.ldp3"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    set_tests_properties(ldp3_run_bare_file PROPERTIES
        PASS_REGULAR_EXPRESSION "Resultado: 42")
endif()

add_test(NAME ldp3_clean_removes_output
    COMMAND ldp3 clean
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/demoproj")
set_tests_properties(ldp3_clean_removes_output PROPERTIES
    DEPENDS ldp3_build_project
    PASS_REGULAR_EXPRESSION "cleaned")
```

- [ ] **Step 2: Run to verify they fail**

Run: `cmake -B build -S . ; ctest --test-dir build -C Debug -R "ldp3_run_bare_file|ldp3_clean_removes_output" --output-on-failure`
Expected: FAIL (`run` and `clean` are "unknown command").

- [ ] **Step 3: Dispatch `run` and `clean` in the driver**

In `src/driver/ldp3_main.cpp`, insert before the unknown-command block:

```cpp
    if (cmd == "run") {
        ldp3::driver::BuildOptions opts;
        opts.run = true;
        // collect run args after a "--" separator
        size_t sep = args.size();
        for (size_t i = 1; i < args.size(); ++i) if (args[i] == "--") { sep = i; break; }

        ldp3::driver::Manifest m;
        std::filesystem::path projectDir;
        if (args.size() >= 2 && args[1] != "--") {
            // bare file: ldp3 run file.ldp3
            const std::filesystem::path file(args[1]);
            m = ldp3::driver::ephemeralManifest(file.filename());
            m.outputDir = "build-output/";
            projectDir = file.parent_path().empty() ? "." : file.parent_path();
        } else {
            const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
            if (!manifestPath) {
                std::fprintf(stderr, "ldp3: no ldp3.toml found; run 'ldp3 init' or 'ldp3 run <file>'\n");
                return 1;
            }
            std::ifstream f(*manifestPath);
            std::stringstream ss;
            ss << f.rdbuf();
            m = ldp3::driver::parseManifestText(ss.str());
            projectDir = manifestPath->parent_path();
        }
        for (size_t i = sep + 1; i < args.size(); ++i) opts.runArgs.push_back(args[i]);
        return ldp3::driver::buildProgram(m, projectDir, opts);
    }
    if (cmd == "clean") {
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        const std::filesystem::path base = manifestPath ? manifestPath->parent_path()
                                                        : std::filesystem::current_path();
        std::error_code ec;
        std::filesystem::remove_all(base / "build-output", ec);
        std::printf("cleaned %s\n", (base / "build-output").string().c_str());
        return 0;
    }
```

- [ ] **Step 4: Build and run the tests**

Run: `cmake --build build --config Debug --target ldp3 ; ctest --test-dir build -C Debug -R "ldp3_run_bare_file|ldp3_clean_removes_output" --output-on-failure`
Expected: PASS (`Resultado: 42`; `cleaned ...`).

- [ ] **Step 5: Run the full suite**

Run: `ctest --test-dir build -C Debug -j 12`
Expected: PASS, 100% (previous 455 + the new driver tests).

- [ ] **Step 6: Commit**

```
git add tests/CMakeLists.txt src/driver/ldp3_main.cpp
git commit -m "add ldp3 run and ldp3 clean" -m "'ldp3 run' builds and executes either a bare file (ephemeral manifest) or the current project, forwarding args after '--' and propagating the program's exit code. 'ldp3 clean' removes the project's build-output/. Sub-project 1 of the toolchain (the gcc-style CLI) is now complete: new/init/build/compile/run/clean plus version/help."
```

---

## Self-Review

**Spec coverage:** manifest + `ldp3.toml` (Task 2); project structure + scaffolding (Task 3); shell-out architecture, toolchain locator, prebuilt runtime lib (Tasks 1, 4); run/build/compile/new/init/clean/version/help (Tasks 1, 3, 4, 5, 6); clang-based link with runtime + `legacy_stdio_definitions` + `ws2_32` (Task 4); dependency "not yet" error (Task 4); passthrough flags (Task 4); tests for each (all tasks). Freestanding bootable image and plug/fmt/test/doc/lsp/TUI are explicitly out of scope. Covered.

**Placeholder scan:** the only intentional placeholder is `src/driver/dummy.cpp` in Task 1, removed in Task 2. No TODO/TBD; all steps carry real code and exact commands.

**Type consistency:** `Manifest` fields (`name`, `version`, `languageVersion`, `entry`, `outputDir`, `target`, `freestanding`, `hasDependencies`) are used identically across Tasks 2/4/5/6. `buildProgram(const Manifest&, const fs::path&, const BuildOptions&)`, `BuildOptions{run, runArgs, passthrough}`, `locateToolchain()→Toolchain{ldp3c, clang, runtimeLib}`, `runProcess(exe, args)`, `scaffold(dir, name)`, `parseManifestText`, `findManifest`, `ephemeralManifest` are consistent between their definitions and call sites.
