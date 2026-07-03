#include "driver/build.h"
#include "driver/process.h"
#include "driver/toolchain.h"
#include <cstdio>
#include <fstream>
#include <sstream>

namespace ldp3::driver {
namespace fs = std::filesystem;

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

    // Resolve each dependency's compiled bundle (currently from the project's packages/; the shared
    // environment is added in a later slice). Every declared dependency must be installed.
    std::vector<fs::path> ldbs;
    for (const auto& d : m.dependencies) {
        const fs::path ldb = projectDir / "packages" / d.name / (d.name + ".ldb");
        if (!fs::is_regular_file(ldb)) {
            std::fprintf(stderr, "ldp3: dependency '%s' is not installed; run 'ldp3 plug'\n", d.name.c_str());
            return 1;
        }
        ldbs.push_back(ldb);
    }

    // Additionally resolve the shared environment's dependencies, if the project declares one (a project
    // may use its own packages/ and an environment at the same time -- the resolution is their union).
    if (!m.environment.empty()) {
        const fs::path envDir = ldp3HomeDir() / "environments" / m.environment;
        const fs::path envManifest = envDir / "ldp3.toml";
        if (fs::is_regular_file(envManifest)) {
            std::ifstream in(envManifest);
            std::stringstream ss;
            ss << in.rdbuf();
            const Manifest em = parseManifestText(ss.str());
            for (const auto& d : em.dependencies) {
                const fs::path ldb = envDir / "packages" / d.name / (d.name + ".ldb");
                if (!fs::is_regular_file(ldb)) {
                    std::fprintf(stderr,
                                 "ldp3: environment dependency '%s' is not installed; run 'ldp3 plug -e'\n",
                                 d.name.c_str());
                    return 1;
                }
                ldbs.push_back(ldb);
            }
        } else {
            std::fprintf(stderr, "ldp3: environment '%s' does not exist; run 'ldp3 env new %s'\n",
                         m.environment.c_str(), m.environment.c_str());
            return 1;
        }
    }

    // 1) Compile: ldp3c <entry> [--use <dep.ldb>...] -o <ll> [passthrough]
    std::vector<std::string> compileArgs = {entry.string()};
    for (const auto& ldb : ldbs) {
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
    // clang to the MSVC link.exe, which does not pull in the UCRT the runtime needs.
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
