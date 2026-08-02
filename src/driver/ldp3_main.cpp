// The `ldp3` toolchain driver: a lightweight front-end that dispatches subcommands and orchestrates
// the low-level compiler (ldp3c) and linker (clang). Carries no LLVM itself.
#include <cstdio>
#include <exception>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#include "driver/build.h"
#include "driver/deps.h"
#include "driver/environs.h"
#include "driver/jsonout.h"
#include "driver/manifest.h"
#include "driver/process.h"
#include "driver/scaffold.h"
#include "driver/toolchain.h"

namespace {
constexpr const char* kVersion = "ldp3 1.0.15";

int printHelp() {
    std::printf(
        "ldp3 - the LDP3 toolchain\n\n"
        "usage:\n"
        "  ldp3 run [file.ldp3] [-- args...]   build and run (current project, or a bare file)\n"
        "  ldp3 build                          build the current project to build-output/\n"
        "  ldp3 check [--project <dir>]        type-check the project, print diagnostics, emit nothing\n"
        "             [--overlay <file>=<tmp>]  check <file> as it reads in <tmp> (an editor's buffer)\n"
        "  ldp3 explain <code>                 the why / fix / prevent for a diagnostic code (e.g. LDP3-0101)\n"
        "  ldp3 test [-- <runner args>]        build and run the project's [Test] methods\n"
        "      -- --filter <text>              run only the tests whose name contains <text>\n"
        "      -- --list                       print the test names without running them\n"
        "      -- --timing                     add per-test durations to the report\n"
        "  ldp3 doc                            render the public API to HTML from /// comments\n"
        "  ldp3 fmt [file.ldp3]                format the project's source (or one file) in place\n"
        "  ldp3 compile <file.ldp3>            compile one file to an .exe (no run)\n"
        "  ldp3 plug [<url|name>[@version]] [-e] download a dependency (or all of them if none named)\n"
        "  ldp3 unplug <name> [-e]             remove a dependency\n"
        "  ldp3 env new|list|remove [<name>]   manage shared environments\n"
        "  ldp3 studio                         open the TUI project manager\n"
        "  ldp3 new <name>                     scaffold a new project\n"
        "  ldp3 init                           scaffold in the current directory\n"
        "  ldp3 clean                          remove build-output/\n"
        "  ldp3 --version                      print the version\n"
        "  ldp3 --help                         print this help\n");
    return 0;
}
}  // namespace

namespace {
int runCli(int argc, char** argv) {
    std::vector<std::string> args(argv + 1, argv + argc);
    if (args.empty()) return printHelp();
    const std::string& cmd = args[0];

    if (cmd == "--version" || cmd == "-v") {
        std::printf("%s\n", kVersion);
        return 0;
    }
    if (cmd == "--help" || cmd == "-h") return printHelp();

    if (cmd == "json") {  // machine-readable workspace data for the VS Code extension's tree views
        std::fputs(ldp3::driver::studioJson(std::filesystem::current_path()).c_str(), stdout);
        return 0;
    }

    // `ldp3 explain <code>`: the canonical why / fix / prevent for a diagnostic code -- forwarded to the
    // compiler, which owns the catalog. With no code, lists every code.
    if (cmd == "explain") {
        const ldp3::driver::Toolchain tc = ldp3::driver::locateToolchain();
        std::vector<std::string> forward = {"--explain"};
        for (std::size_t i = 1; i < args.size(); ++i) forward.push_back(args[i]);
        return ldp3::driver::runProcess(tc.ldp3c, forward);
    }

    if (cmd == "new") {
        if (args.size() < 2) { std::fprintf(stderr, "ldp3: 'new' requires a project name\n"); return 2; }
        // The argument may be a path ("C:/dev/game" or "projects/game"): the project is created there,
        // but its NAME is the last path component, not the whole path.
        const std::filesystem::path dir(args[1]);
        return ldp3::driver::scaffold(dir, dir.filename().string());
    }
    if (cmd == "init") {
        const std::filesystem::path cwd = std::filesystem::current_path();
        return ldp3::driver::scaffold(cwd, cwd.filename().string());
    }
    if (cmd == "compile") {
        if (args.size() < 2) { std::fprintf(stderr, "ldp3: 'compile' requires a file\n"); return 2; }
        const std::filesystem::path file(args[1]);
        ldp3::driver::Manifest m = ldp3::driver::ephemeralManifest(file);
        m.outputDir = "build-output/";
        ldp3::driver::BuildOptions opts;
        for (std::size_t i = 2; i < args.size(); ++i) {
            if (args[i] == "--debug") opts.debug = true;
            else opts.passthrough.push_back(args[i]);
        }
        return ldp3::driver::buildProgram(m, std::filesystem::current_path(), opts);
    }
    // `ldp3 check [--overlay <real>=<temp>]...` -- the project's diagnostics, without building anything.
    // An editor runs this on every pause in typing, passing an overlay for each buffer it has not saved:
    // the check then sees exactly the code on screen, and reports against the file the user is editing.
    if (cmd == "check") {
        ldp3::driver::BuildOptions opts;
        opts.checkOnly = true;
        // --project: check THAT project, whatever the working directory is. An editor spawns the check
        // directly, with no shell to cd for it, and a shell is not something to require on the hot path.
        std::filesystem::path from = std::filesystem::current_path();
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "--overlay" && i + 1 < args.size()) {
                opts.overlays.push_back(args[++i]);
            } else if (args[i] == "--project" && i + 1 < args.size()) {
                from = std::filesystem::path(args[++i]);
            } else {
                std::fprintf(stderr, "ldp3: unknown 'check' option '%s'\n", args[i].c_str());
                return 2;
            }
        }
        const auto manifestPath = ldp3::driver::findManifest(from);
        if (!manifestPath) {
            std::fprintf(stderr, "ldp3: no ldp3.toml found in %s or any parent\n", from.string().c_str());
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        ldp3::driver::Manifest m = ldp3::driver::parseManifestText(ss.str());
        if (m.entry.empty() && !m.isLibrary) {
            std::fprintf(stderr, "ldp3: manifest has no [program] entry\n");
            return 1;
        }
        return ldp3::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }

    if (cmd == "build") {
        std::filesystem::path sawToml;
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path(), &sawToml);
        if (!manifestPath) {
            if (!sawToml.empty()) {
                std::fprintf(stderr,
                    "ldp3: %s is not an LDP3 manifest: its first line must be [ldp3_project]\n"
                    "      (an LDP3 manifest looks like:  [ldp3_project]  /  [program] name= entry=)\n",
                    sawToml.string().c_str());
                return 1;
            }
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
        // `--debug`: a -g -O0 build a debugger can step (DWARF line tables + variables). Other flags pass
        // through to ldp3c.
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "--debug") opts.debug = true;
            else opts.passthrough.push_back(args[i]);
        }
        return ldp3::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }
    if (cmd == "fmt") {
        namespace fs = std::filesystem;
        std::vector<fs::path> files;
        if (args.size() >= 2 && !args[1].empty() && args[1][0] != '-') {
            files.emplace_back(args[1]);  // a specific file
        } else {  // every .ldp3 under the project, skipping packages/ and build-output/
            const auto manifestPath = ldp3::driver::findManifest(fs::current_path());
            const fs::path base = manifestPath ? manifestPath->parent_path() : fs::current_path();
            std::error_code ec;
            for (fs::recursive_directory_iterator it(base, ec), end; it != end; it.increment(ec)) {
                if (it->is_directory()) {
                    const std::string n = it->path().filename().string();
                    if (n == "packages" || n == "build-output" || n == ".git") it.disable_recursion_pending();
                    continue;
                }
                if (it->path().extension() == ".ldp3") files.push_back(it->path());
            }
        }
        if (files.empty()) {
            std::printf("no .ldp3 files to format\n");
            return 0;
        }
        const ldp3::driver::Toolchain tc = ldp3::driver::locateToolchain();
        int failures = 0;
        for (const fs::path& f : files)
            if (ldp3::driver::runProcess(tc.ldp3c, {"--fmt", f.string()}) != 0) ++failures;
        std::printf("formatted %zu file(s)\n", files.size() - static_cast<std::size_t>(failures));
        return failures > 0 ? 1 : 0;
    }
    if (cmd == "doc") {
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr, "ldp3: no ldp3.toml found; run 'ldp3 init' first\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        const ldp3::driver::Manifest m = ldp3::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "ldp3: manifest has no [program] entry\n"); return 1; }
        const std::filesystem::path projectDir = manifestPath->parent_path();
        const std::filesystem::path outDir = projectDir / m.outputDir;
        std::error_code ec;
        std::filesystem::create_directories(outDir, ec);
        const std::filesystem::path html = outDir / (m.name + "-doc.html");
        const ldp3::driver::Toolchain tc = ldp3::driver::locateToolchain();
        return ldp3::driver::runProcess(
            tc.ldp3c, {"--doc", (projectDir / m.entry).string(), "-o", html.string()});
    }
    if (cmd == "test") {
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr, "ldp3: no ldp3.toml found; run 'ldp3 init' first\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        ldp3::driver::Manifest m = ldp3::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "ldp3: manifest has no [program] entry\n"); return 1; }
        m.name = m.name + "-test";  // keep the test binary separate from the normal build
        // A [library] is normally built to a .ldb with no entry point. Its tests still have to RUN,
        // so build the same sources as an executable instead: --test synthesizes the entry, and the
        // analyzer already exempts a test run from needing a `main`. Without this, `ldp3 test` on a
        // library wrote the bundle and exited 0 without running a single test -- which a CI reads as
        // "all tests passed".
        m.isLibrary = false;
        ldp3::driver::BuildOptions opts;
        opts.run = true;
        opts.passthrough = {"--test"};
        // Everything after `--` goes to the runner: `ldp3 test -- --filter Census`, `-- --list`,
        // `-- --timing`. Anything it does not recognize it ignores, so a project may also pass its
        // program's own flags through.
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] != "--") continue;
            for (std::size_t j = i + 1; j < args.size(); ++j) opts.runArgs.push_back(args[j]);
            break;
        }
        return ldp3::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }
    if (cmd == "run") {
        ldp3::driver::BuildOptions opts;
        opts.run = true;
        std::size_t sep = args.size();  // index of a "--" run-args separator, if present
        for (std::size_t i = 1; i < args.size(); ++i) if (args[i] == "--") { sep = i; break; }

        ldp3::driver::Manifest m;
        std::filesystem::path projectDir = std::filesystem::current_path();
        if (args.size() >= 2 && args[1] != "--") {
            // bare file: ldp3 run file.ldp3 -- args...
            m = ldp3::driver::ephemeralManifest(std::filesystem::path(args[1]));
            m.outputDir = "build-output/";
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
        for (std::size_t i = sep + 1; i < args.size(); ++i) opts.runArgs.push_back(args[i]);
        return ldp3::driver::buildProgram(m, projectDir, opts);
    }
    if (cmd == "plug" || cmd == "unplug") {
        bool toEnv = false;
        std::string pkg;
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "-e" || args[i] == "--env") toEnv = true;
            else if (pkg.empty()) pkg = args[i];
        }
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr, "ldp3: no ldp3.toml found; run 'ldp3 init' first\n");
            return 1;
        }
        // Resolve the target: the project's packages/, or its declared environment (with -e).
        std::filesystem::path recordManifest = *manifestPath;
        std::filesystem::path packagesDir = manifestPath->parent_path() / "packages";
        if (toEnv) {
            std::ifstream f(*manifestPath);
            std::stringstream ss;
            ss << f.rdbuf();
            const ldp3::driver::Manifest m = ldp3::driver::parseManifestText(ss.str());
            if (m.environment.empty()) {
                std::fprintf(stderr,
                    "ldp3: no environment declared ([build] environment); declare one or drop -e\n");
                return 1;
            }
            if (!std::filesystem::exists(ldp3::driver::environmentsDir() / m.environment)) {
                std::fprintf(stderr, "ldp3: environment '%s' does not exist; run 'ldp3 env new %s'\n",
                             m.environment.c_str(), m.environment.c_str());
                return 1;
            }
            recordManifest = ldp3::driver::environmentManifest(m.environment);
            packagesDir = ldp3::driver::environmentPackagesDir(m.environment);
        }
        const std::filesystem::path sourcesToml = ldp3::driver::ldp3HomeDir() / "sources.toml";
        const ldp3::driver::Toolchain tc = ldp3::driver::locateToolchain();
        if (cmd == "plug" && pkg.empty()) {  // no package: install everything the manifest declares
            return ldp3::driver::plugAll(recordManifest, packagesDir, sourcesToml, tc.ldp3c);
        }
        if (pkg.empty()) {
            std::fprintf(stderr, "ldp3: 'unplug' requires a package\n");
            return 2;
        }
        if (cmd == "unplug") return ldp3::driver::unplug(recordManifest, packagesDir, pkg);
        return ldp3::driver::plug(recordManifest, packagesDir, sourcesToml, pkg, tc.ldp3c);
    }
    if (cmd == "env") {
        if (args.size() < 2) {
            std::fprintf(stderr, "ldp3: 'env' requires a subcommand (new|list|remove)\n");
            return 2;
        }
        const std::string& sub = args[1];
        if (sub == "list") return ldp3::driver::envList();
        if (sub == "new" || sub == "remove") {
            if (args.size() < 3) { std::fprintf(stderr, "ldp3: 'env %s' requires a name\n", sub.c_str()); return 2; }
            return sub == "new" ? ldp3::driver::envNew(args[2]) : ldp3::driver::envRemove(args[2]);
        }
        std::fprintf(stderr, "ldp3: unknown 'env' subcommand '%s'\n", sub.c_str());
        return 2;
    }
    if (cmd == "clean") {
        const auto manifestPath = ldp3::driver::findManifest(std::filesystem::current_path());
        const std::filesystem::path base =
            manifestPath ? manifestPath->parent_path() : std::filesystem::current_path();
        std::error_code ec;
        std::filesystem::remove_all(base / "build-output", ec);
        std::printf("cleaned %s\n", (base / "build-output").string().c_str());
        return 0;
    }
    if (cmd == "studio") {  // launch the TUI project manager, a sibling binary
        const std::string studioName = "ldp3-studio" + ldp3::driver::exeSuffix();
        const std::filesystem::path studio = ldp3::driver::exeDir() / studioName;
        if (!std::filesystem::exists(studio)) {
            std::fprintf(stderr, "ldp3: %s was not found next to ldp3\n", studioName.c_str());
            return 1;
        }
        const std::vector<std::string> passthrough(args.begin() + 1, args.end());
        return ldp3::driver::runProcess(studio.string(), passthrough);
    }

    std::fprintf(stderr, "ldp3: unknown command '%s'\n", cmd.c_str());
    printHelp();
    return 2;
}
}  // namespace

// Never let an exception escape: on Windows an uncaught one calls std::terminate, which fail-fasts the
// process (exit 0xC0000409) with no output at all -- the driver just vanishes. Report it instead.
int main(int argc, char** argv) {
    try {
        return runCli(argc, argv);
    } catch (const std::filesystem::filesystem_error& e) {
        std::fprintf(stderr, "ldp3: filesystem error: %s\n", e.what());
        return 1;
    } catch (const std::exception& e) {
        std::fprintf(stderr, "ldp3: %s\n", e.what());
        return 1;
    } catch (...) {
        std::fprintf(stderr, "ldp3: unknown internal error\n");
        return 1;
    }
}
