#include "driver/build.h"
#include "driver/process.h"
#include "driver/toolchain.h"
#include <cstdio>
#include <fstream>
#include <set>
#include <sstream>

namespace ldp3::driver {
namespace fs = std::filesystem;
namespace {

Manifest readManifest(const fs::path& mf) {
    std::ifstream in(mf);
    std::stringstream ss;
    ss << in.rdbuf();
    return parseManifestText(ss.str());
}

// Collect the transitive closure of dependency bundles reachable from `direct`, walking each installed
// package's own manifest. Appends each package's .ldb to `out`. On a missing package, sets `missing`.
void collectClosure(const fs::path& packagesDir, const std::vector<std::string>& direct,
                    std::set<std::string>& visited, std::vector<fs::path>& out, std::string& missing) {
    for (const auto& name : direct) {
        if (!missing.empty()) return;
        if (visited.count(name)) continue;
        visited.insert(name);
        const fs::path pkgDir = packagesDir / name;
        const fs::path ldb = pkgDir / (name + ".ldb");
        if (!fs::is_regular_file(ldb)) { missing = name; return; }
        out.push_back(ldb);
        const fs::path mf = pkgDir / "ldp3.toml";
        if (fs::is_regular_file(mf)) {
            std::vector<std::string> children;
            for (const auto& d : readManifest(mf).dependencies) children.push_back(d.name);
            collectClosure(packagesDir, children, visited, out, missing);
        }
    }
}

}  // namespace

int buildProgram(const Manifest& m, const fs::path& projectDir, const BuildOptions& opts) {
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

    // Resolve dependency bundles. The consumer compiles against its *direct* dependencies only (a bundle's
    // .ldh already embeds its own transitive dependencies, so re-using them would redeclare types), but
    // links the *full transitive closure* of their code. Both the project's packages/ and, if declared, the
    // shared environment's packages/ contribute; a project may use both at once.
    std::vector<fs::path> directLdbs;  // for --use at compile time
    std::vector<fs::path> allLdbs;     // full closure, for linking
    {
        std::set<std::string> visited;
        std::vector<std::string> direct;
        for (const auto& d : m.dependencies) {
            direct.push_back(d.name);
            directLdbs.push_back(projectDir / "packages" / d.name / (d.name + ".ldb"));
        }
        std::string missing;
        collectClosure(projectDir / "packages", direct, visited, allLdbs, missing);
        if (!missing.empty()) {
            std::fprintf(stderr, "ldp3: dependency '%s' is not installed; run 'ldp3 plug'\n", missing.c_str());
            return 1;
        }
    }
    if (!m.environment.empty()) {
        const fs::path envDir = ldp3HomeDir() / "environments" / m.environment;
        if (!fs::is_regular_file(envDir / "ldp3.toml")) {
            std::fprintf(stderr, "ldp3: environment '%s' does not exist; run 'ldp3 env new %s'\n",
                         m.environment.c_str(), m.environment.c_str());
            return 1;
        }
        std::set<std::string> visited;
        std::vector<std::string> direct;
        for (const auto& d : readManifest(envDir / "ldp3.toml").dependencies) {
            direct.push_back(d.name);
            directLdbs.push_back(envDir / "packages" / d.name / (d.name + ".ldb"));
        }
        std::string missing;
        collectClosure(envDir / "packages", direct, visited, allLdbs, missing);
        if (!missing.empty()) {
            std::fprintf(stderr, "ldp3: environment dependency '%s' is not installed; run 'ldp3 plug -e'\n",
                         missing.c_str());
            return 1;
        }
    }
    const std::vector<fs::path>& ldbs = allLdbs;  // extracted + linked below (the full closure)

    // 1) Compile: ldp3c <entry> [--use <direct-dep.ldb>...] -o <ll> [passthrough]
    std::vector<std::string> compileArgs = {entry.string()};
    for (const auto& ldb : directLdbs) {
        compileArgs.push_back("--use");
        compileArgs.push_back(ldb.string());
    }
    compileArgs.push_back("-o");
    compileArgs.push_back(ll.string());
    for (const auto& p : opts.passthrough) compileArgs.push_back(p);
    if (int rc = runProcess(tc.ldp3c, compileArgs); rc != 0) {
        std::fprintf(stderr, "ldp3: compilation failed\n");
        return rc == -1 ? 1 : rc;
    }

    // 2) Extract each dependency's bitcode and compile it to a native object. (Handing raw bitcode to the
    // linker alongside the MSVC-built runtime lib pushes lld-link into an LTO path that drops the CRT
    // imports; a plain object sidesteps that.)
    std::vector<std::string> depObjects;
    for (const auto& ldb : ldbs) {
        const fs::path bc = outDir / (ldb.stem().string() + ".bc");
        if (int rc = runProcess(tc.ldp3c, {"--extract-code", ldb.string(), "-o", bc.string()}); rc != 0) {
            std::fprintf(stderr, "ldp3: extracting code from '%s' failed\n", ldb.string().c_str());
            return rc == -1 ? 1 : rc;
        }
        const fs::path obj = outDir / (ldb.stem().string() + ".obj");
        if (int rc = runProcess(tc.clang, {"-Wno-override-module", "-c", bc.string(), "-o", obj.string()});
            rc != 0) {
            std::fprintf(stderr, "ldp3: compiling dependency object from '%s' failed\n", ldb.string().c_str());
            return rc == -1 ? 1 : rc;
        }
        depObjects.push_back(obj.string());
    }

    // 3) Link: clang <ll> <dep.obj...> <runtimeLib> -llegacy_stdio_definitions -lws2_32 -o <exe>.
    // Force lld as the linker so the choice is deterministic -- a native object input can otherwise flip
    // clang to the MSVC link.exe, which does not pull in the UCRT the runtime needs. (Each bundle embeds
    // the stdlib prelude, but ldp3c emits those symbols in COMDATs, so the linker deduplicates them.)
    std::vector<std::string> linkArgs = {"-fuse-ld=lld", "-Wno-override-module", ll.string()};
    for (const auto& obj : depObjects) linkArgs.push_back(obj);
    linkArgs.push_back(tc.runtimeLib);
    linkArgs.push_back("-llegacy_stdio_definitions");
    linkArgs.push_back("-lws2_32");
    linkArgs.push_back("-o");
    linkArgs.push_back(exe.string());
    if (int rc = runProcess(tc.clang, linkArgs); rc != 0) {
        std::fprintf(stderr, "ldp3: link failed\n");
        return rc == -1 ? 1 : rc;
    }
    std::printf("wrote %s\n", exe.string().c_str());

    // 4) Optionally run.
    if (opts.run) return runProcess(exe.string(), opts.runArgs);
    return 0;
}

}  // namespace ldp3::driver
