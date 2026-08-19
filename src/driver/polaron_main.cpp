// The `polaron` toolchain driver: a lightweight front-end that dispatches subcommands and orchestrates
// the low-level compiler (polc) and linker (clang). Carries no LLVM itself.
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
constexpr const char* kVersion = "polaron 1.0.142";

int printHelp() {
    std::printf(
        "polaron - the Polaron toolchain\n\n"
        "usage:\n"
        "  polaron run [file.pol] [-- args...]   build and run (current project, or a bare file)\n"
        "  polaron build                          build the current project to build-output/\n"
        "  polaron check [--project <dir>]        type-check the project, print diagnostics, emit nothing\n"
        "             [--overlay <file>=<tmp>]  check <file> as it reads in <tmp> (an editor's buffer)\n"
        "  polaron explain <code>                 the why / fix / prevent for a diagnostic code (e.g. Polaron-0101)\n"
        "  polaron test [-- <runner args>]        build and run the project's [Test] methods\n"
        "      -- --filter <text>              run only the tests whose name contains <text>\n"
        "      -- --tag <name>                 run only the tests carrying that [Tag]\n"
        "      -- --exclude-tag <name>         run everything except those\n"
        "      -- --list                       print the test names without running them\n"
        "      -- --timing                     add per-test durations to the report\n"
        "      -- --fail-fast                  stop at the first failure\n"
        "      -- --format=json                emit one machine-readable document\n"
        "      -- --bench                      also run the [Benchmark] methods\n"
        "      -- --update-golden              rewrite golden files instead of comparing\n"
        "  polaron doc                            render the public API to HTML from /// comments\n"
        "  polaron fmt [file.pol]                format the project's source (or one file) in place\n"
        "  polaron compile <file.pol>            compile one file to an .exe (no run)\n"
        "  polaron plug [<url|name>[@version]] [-e] download a dependency (or all of them if none named)\n"
        "  polaron unplug <name> [-e]             remove a dependency\n"
        "  polaron env new|list|remove [<name>]   manage shared environments\n"
        "  polaron studio                         open the TUI project manager\n"
        "  polaron new <name>                     scaffold a new project\n"
        "  polaron init                           scaffold in the current directory\n"
        "  polaron clean                          remove build-output/\n"
        "  polaron --version                      print the version\n"
        "  polaron --help                         print this help\n");
    return 0;
}
}  // namespace

namespace {
int runCli(int argc, char** argv) {
    std::vector<std::string> args(argv + 1, argv + argc);
    if (args.empty()) {
        return printHelp();
    }
    const std::string& cmd = args[0];

    if (cmd == "--version" || cmd == "-v") {
        std::printf("%s\n", kVersion);
        return 0;
    }
    if (cmd == "--help" || cmd == "-h") {
        return printHelp();
    }

    if (cmd == "json") {  // machine-readable workspace data for the VS Code extension's tree views
        std::fputs(polaron::driver::studioJson(std::filesystem::current_path()).c_str(), stdout);
        return 0;
    }

    // `polaron explain <code>`: the canonical why / fix / prevent for a diagnostic code -- forwarded to the
    // compiler, which owns the catalog. With no code, lists every code.
    if (cmd == "explain") {
        const polaron::driver::Toolchain tc = polaron::driver::locateToolchain();
        std::vector<std::string> forward = {"--explain"};
        for (std::size_t i = 1; i < args.size(); ++i) {
            forward.push_back(args[i]);
        }
        return polaron::driver::runProcess(tc.polc, forward);
    }

    if (cmd == "new") {
        if (args.size() < 2) { std::fprintf(stderr, "polaron: 'new' requires a project name\n"); return 2; }
        // The argument may be a path ("C:/dev/game" or "projects/game"): the project is created there,
        // but its NAME is the last path component, not the whole path.
        const std::filesystem::path dir(args[1]);
        return polaron::driver::scaffold(dir, dir.filename().string());
    }
    if (cmd == "init") {
        const std::filesystem::path cwd = std::filesystem::current_path();
        return polaron::driver::scaffold(cwd, cwd.filename().string());
    }
    // `polaron fix-asm <file.s>` -- apply the target-specific assembly fixups a build applies, in place.
    //
    // Exposed as a command because the knowledge has to live in ONE place and two things need it: the
    // build below, and any harness that drives clang itself. Today it means the m68k rewrite (see
    // `rewriteM68kPcRelative`), where LLVM addresses every global with a 16-bit PC-relative
    // displacement and nothing larger than 32 KB can link.
    if (cmd == "fix-asm") {
        if (args.size() < 2) {
            std::fprintf(stderr, "polaron: 'fix-asm' requires an assembly file\n");
            return 2;
        }
        return polaron::driver::fixTargetAssembly(std::filesystem::path(args[1])) ? 0 : 1;
    }
    if (cmd == "compile") {
        if (args.size() < 2) { std::fprintf(stderr, "polaron: 'compile' requires a file\n"); return 2; }
        const std::filesystem::path file(args[1]);
        polaron::driver::Manifest m = polaron::driver::ephemeralManifest(file);
        m.outputDir = "build-output/";
        polaron::driver::BuildOptions opts;
        for (std::size_t i = 2; i < args.size(); ++i) {
            if (args[i] == "--debug") {
                opts.debug = true;
            } else if (args[i] == "--static") {
                // Link the C library IN, so the binary does not carry a `GLIBC_2.x` requirement and
                // runs on distributions older than the one that built it. See BuildOptions.
                opts.staticLink = true;
            } else {
                opts.passthrough.push_back(args[i]);
            }
        }
        return polaron::driver::buildProgram(m, std::filesystem::current_path(), opts);
    }
    // `polaron check [--overlay <real>=<temp>]...` -- the project's diagnostics, without building anything.
    // An editor runs this on every pause in typing, passing an overlay for each buffer it has not saved:
    // the check then sees exactly the code on screen, and reports against the file the user is editing.
    if (cmd == "check") {
        polaron::driver::BuildOptions opts;
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
                std::fprintf(stderr, "polaron: unknown 'check' option '%s'\n", args[i].c_str());
                return 2;
            }
        }
        const auto manifestPath = polaron::driver::findManifest(from);
        if (!manifestPath) {
            std::fprintf(stderr, "polaron: no polaron.toml found in %s or any parent\n", from.string().c_str());
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        polaron::driver::Manifest m = polaron::driver::parseManifestText(ss.str());
        if (m.entry.empty() && !m.isLibrary) {
            std::fprintf(stderr, "polaron: manifest has no [program] entry\n");
            return 1;
        }
        return polaron::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }

    if (cmd == "build") {
        std::filesystem::path sawToml;
        const auto manifestPath = polaron::driver::findManifest(std::filesystem::current_path(), &sawToml);
        if (!manifestPath) {
            if (!sawToml.empty()) {
                std::fprintf(stderr,
                    "polaron: %s is not a Polaron manifest: its first line must be [polaron_project]\n"
                    "      (a Polaron manifest looks like:  [polaron_project]  /  [program] name= entry=)\n",
                    sawToml.string().c_str());
                return 1;
            }
            std::fprintf(stderr,
                "polaron: no polaron.toml found in this directory or any parent; "
                "run 'polaron init' or 'polaron run <file>'\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        polaron::driver::Manifest m = polaron::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "polaron: manifest has no [program] entry\n"); return 1; }
        // Name the manifest, always. A build that resolves upward can be building a project the user is
        // not standing in, and "wrote foo.elf" is far too late a place to learn that -- by then it reads
        // as an output name, not as an answer to "which project?".
        std::printf("polaron: %s (%s)\n", m.name.c_str(), manifestPath->string().c_str());
        polaron::driver::BuildOptions opts;
        // `--debug`: a -g -O0 build a debugger can step (DWARF line tables + variables). Other flags pass
        // through to polc.
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "--debug") {
                opts.debug = true;
            } else if (args[i] == "--static") {
                // Link the C library IN, so the binary does not carry a `GLIBC_2.x` requirement and
                // runs on distributions older than the one that built it. See BuildOptions.
                opts.staticLink = true;
            } else {
                opts.passthrough.push_back(args[i]);
            }
        }
        return polaron::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }
    if (cmd == "fmt") {
        namespace fs = std::filesystem;
        std::vector<fs::path> files;
        if (args.size() >= 2 && !args[1].empty() && args[1][0] != '-') {
            files.emplace_back(args[1]);  // a specific file
        } else {  // every .pol under the project, skipping libraries/ and build-output/
            const auto manifestPath = polaron::driver::findManifest(fs::current_path());
            const fs::path base = manifestPath ? manifestPath->parent_path() : fs::current_path();
            std::error_code ec;
            for (fs::recursive_directory_iterator it(base, ec), end; it != end; it.increment(ec)) {
                if (it->is_directory()) {
                    const std::string n = it->path().filename().string();
                    // `packages` was where an installed library went before, and a project that still
                    // has one is not a reason to reformat somebody else's source.
                    if (n == polaron::driver::kLibrariesDir || n == "packages" ||
                        n == "build-output" || n == ".git") {
                        it.disable_recursion_pending();
                    }
                    continue;
                }
                if (it->path().extension() == ".pol") {
                    files.push_back(it->path());
                }
            }
        }
        if (files.empty()) {
            std::printf("no .pol files to format\n");
            return 0;
        }
        const polaron::driver::Toolchain tc = polaron::driver::locateToolchain();
        int failures = 0;
        for (const fs::path& f : files) {
            if (polaron::driver::runProcess(tc.polc, {"--fmt", f.string()}) != 0) {
                ++failures;
            }
        }
        std::printf("formatted %zu file(s)\n", files.size() - static_cast<std::size_t>(failures));
        return failures > 0 ? 1 : 0;
    }
    if (cmd == "doc") {
        const auto manifestPath = polaron::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr, "polaron: no polaron.toml found; run 'polaron init' first\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        const polaron::driver::Manifest m = polaron::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "polaron: manifest has no [program] entry\n"); return 1; }
        const std::filesystem::path projectDir = manifestPath->parent_path();
        const std::filesystem::path outDir = projectDir / m.outputDir;
        std::error_code ec;
        std::filesystem::create_directories(outDir, ec);
        const std::filesystem::path html = outDir / (m.name + "-doc.html");
        const polaron::driver::Toolchain tc = polaron::driver::locateToolchain();
        return polaron::driver::runProcess(
            tc.polc, {"--doc", (projectDir / m.entry).string(), "-o", html.string()});
    }
    if (cmd == "test") {
        const auto manifestPath = polaron::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr, "polaron: no polaron.toml found; run 'polaron init' first\n");
            return 1;
        }
        std::ifstream f(*manifestPath);
        std::stringstream ss;
        ss << f.rdbuf();
        polaron::driver::Manifest m = polaron::driver::parseManifestText(ss.str());
        if (m.entry.empty()) { std::fprintf(stderr, "polaron: manifest has no [program] entry\n"); return 1; }
        m.name = m.name + "-test";  // keep the test binary separate from the normal build
        // A [library] is normally built to a .polb with no entry point. Its tests still have to RUN,
        // so build the same sources as an executable instead: --test synthesizes the entry, and the
        // analyzer already exempts a test run from needing a `main`. Without this, `polaron test` on a
        // library wrote the bundle and exited 0 without running a single test -- which a CI reads as
        // "all tests passed".
        m.isLibrary = false;
        polaron::driver::BuildOptions opts;
        opts.run = true;
        opts.passthrough = {"--test"};
        // Everything after `--` goes to the runner: `polaron test -- --filter Census`, `-- --list`,
        // `-- --timing`. Anything it does not recognize it ignores, so a project may also pass its
        // program's own flags through.
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] != "--") {
                continue;
            }
            for (std::size_t j = i + 1; j < args.size(); ++j) {
                opts.runArgs.push_back(args[j]);
            }
            break;
        }
        return polaron::driver::buildProgram(m, manifestPath->parent_path(), opts);
    }
    if (cmd == "run") {
        polaron::driver::BuildOptions opts;
        opts.run = true;
        std::size_t sep = args.size();  // index of a "--" run-args separator, if present
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "--") {
                sep = i;
                break;
            }
        }

        polaron::driver::Manifest m;
        std::filesystem::path projectDir = std::filesystem::current_path();
        if (args.size() >= 2 && args[1] != "--") {
            // bare file: polaron run file.pol -- args...
            m = polaron::driver::ephemeralManifest(std::filesystem::path(args[1]));
            m.outputDir = "build-output/";
        } else {
            const auto manifestPath = polaron::driver::findManifest(std::filesystem::current_path());
            if (!manifestPath) {
                std::fprintf(stderr, "polaron: no polaron.toml found; run 'polaron init' or 'polaron run <file>'\n");
                return 1;
            }
            std::ifstream f(*manifestPath);
            std::stringstream ss;
            ss << f.rdbuf();
            m = polaron::driver::parseManifestText(ss.str());
            projectDir = manifestPath->parent_path();
        }
        for (std::size_t i = sep + 1; i < args.size(); ++i) {
            opts.runArgs.push_back(args[i]);
        }
        return polaron::driver::buildProgram(m, projectDir, opts);
    }
    if (cmd == "plug" || cmd == "unplug") {
        bool toEnv = false;
        std::string pkg;
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "-e" || args[i] == "--env") {
                toEnv = true;
            } else if (pkg.empty()) {
                pkg = args[i];
            }
        }
        const auto manifestPath = polaron::driver::findManifest(std::filesystem::current_path());
        if (!manifestPath) {
            std::fprintf(stderr, "polaron: no polaron.toml found; run 'polaron init' first\n");
            return 1;
        }
        // Resolve the target: the project's libraries/, or its declared environment (with -e).
        std::filesystem::path recordManifest = *manifestPath;
        std::filesystem::path packagesDir =
            manifestPath->parent_path() / polaron::driver::kLibrariesDir;
        if (toEnv) {
            std::ifstream f(*manifestPath);
            std::stringstream ss;
            ss << f.rdbuf();
            const polaron::driver::Manifest m = polaron::driver::parseManifestText(ss.str());
            if (m.environment.empty()) {
                std::fprintf(stderr,
                    "polaron: no environment declared ([build] environment); declare one or drop -e\n");
                return 1;
            }
            if (!std::filesystem::exists(polaron::driver::environmentsDir() / m.environment)) {
                std::fprintf(stderr, "polaron: environment '%s' does not exist; run 'polaron env new %s'\n",
                             m.environment.c_str(), m.environment.c_str());
                return 1;
            }
            recordManifest = polaron::driver::environmentManifest(m.environment);
            packagesDir = polaron::driver::environmentPackagesDir(m.environment);
        }
        const std::filesystem::path sourcesToml = polaron::driver::polaronHomeDir() / "sources.toml";
        const polaron::driver::Toolchain tc = polaron::driver::locateToolchain();
        if (cmd == "plug" && pkg.empty()) {  // no package: install everything the manifest declares
            return polaron::driver::plugAll(recordManifest, packagesDir, sourcesToml, tc.polc);
        }
        if (pkg.empty()) {
            std::fprintf(stderr, "polaron: 'unplug' requires a package\n");
            return 2;
        }
        if (cmd == "unplug") {
            return polaron::driver::unplug(recordManifest, packagesDir, pkg);
        }
        return polaron::driver::plug(recordManifest, packagesDir, sourcesToml, pkg, tc.polc);
    }
    if (cmd == "env") {
        if (args.size() < 2) {
            std::fprintf(stderr, "polaron: 'env' requires a subcommand (new|list|remove)\n");
            return 2;
        }
        const std::string& sub = args[1];
        if (sub == "list") {
            return polaron::driver::envList();
        }
        if (sub == "new" || sub == "remove") {
            if (args.size() < 3) { std::fprintf(stderr, "polaron: 'env %s' requires a name\n", sub.c_str()); return 2; }
            return sub == "new" ? polaron::driver::envNew(args[2]) : polaron::driver::envRemove(args[2]);
        }
        std::fprintf(stderr, "polaron: unknown 'env' subcommand '%s'\n", sub.c_str());
        return 2;
    }
    if (cmd == "clean") {
        const auto manifestPath = polaron::driver::findManifest(std::filesystem::current_path());
        const std::filesystem::path base =
            manifestPath ? manifestPath->parent_path() : std::filesystem::current_path();
        std::error_code ec;
        std::filesystem::remove_all(base / "build-output", ec);
        std::printf("cleaned %s\n", (base / "build-output").string().c_str());
        return 0;
    }
    if (cmd == "studio") {  // launch the TUI project manager, a sibling binary
        const std::string studioName = "polaron-studio" + polaron::driver::exeSuffix();
        const std::filesystem::path studio = polaron::driver::exeDir() / studioName;
        if (!std::filesystem::exists(studio)) {
            std::fprintf(stderr, "polaron: %s was not found next to polaron\n", studioName.c_str());
            return 1;
        }
        const std::vector<std::string> passthrough(args.begin() + 1, args.end());
        return polaron::driver::runProcess(studio.string(), passthrough);
    }

    std::fprintf(stderr, "polaron: unknown command '%s'\n", cmd.c_str());
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
        std::fprintf(stderr, "polaron: filesystem error: %s\n", e.what());
        return 1;
    } catch (const std::exception& e) {
        std::fprintf(stderr, "polaron: %s\n", e.what());
        return 1;
    } catch (...) {
        std::fprintf(stderr, "polaron: unknown internal error\n");
        return 1;
    }
}
