#include "studio/engine.h"

#include <algorithm>
#include <fstream>
#include <sstream>
#include <utility>

#include "driver/environs.h"
#include "driver/manifest.h"
#include "driver/process.h"
#include "driver/scaffold.h"
#include "driver/toolchain.h"

namespace ldp3::studio {

std::filesystem::path ldp3Cli() {
    return ldp3::driver::exeDir() / ("ldp3" + ldp3::driver::exeSuffix());
}

std::vector<Library> loadLibraries(const std::vector<ldp3::driver::DiscoveredProject>& projects,
                                   const std::vector<Environment>& environments) {
    std::vector<Library> libs;
    auto get = [&libs](const std::string& name) -> Library& {
        for (Library& l : libs)
            if (l.name == name) return l;
        libs.push_back(Library{name, {}, {}, {}});
        return libs.back();
    };
    auto addVersion = [](Library& l, const std::string& v) {
        if (std::find(l.versions.begin(), l.versions.end(), v) == l.versions.end()) l.versions.push_back(v);
    };
    for (const ldp3::driver::DiscoveredProject& p : projects)
        for (const ldp3::driver::Dependency& d : p.manifest.dependencies) {
            Library& l = get(d.name);
            addVersion(l, d.version);
            l.usedByProjects.push_back(p.manifest.name);
        }
    for (const Environment& e : environments)
        for (const ldp3::driver::Dependency& d : e.libs) {
            Library& l = get(d.name);
            addVersion(l, d.version);
            l.usedByEnvs.push_back(e.name);
        }
    std::sort(libs.begin(), libs.end(), [](const Library& a, const Library& b) { return a.name < b.name; });
    return libs;
}

ToolchainInfo loadToolchainInfo() {
    const ldp3::driver::Toolchain tc = ldp3::driver::locateToolchain();
    ToolchainInfo i;
    i.version = "ldp3 0.1.0-dev";
    i.ldp3c = tc.ldp3c;
    i.clang = tc.clang;
    i.runtime = tc.runtimeLib;
    i.home = ldp3::driver::ldp3HomeDir().string();
    i.environments = ldp3::driver::environmentsDir().string();
    i.target = "x86_64-windows";
    return i;
}

bool createProject(const std::string& name, const std::filesystem::path& parentDir, const std::string& env) {
    const std::filesystem::path dir = parentDir / name;
    if (ldp3::driver::scaffold(dir, name) != 0) return false;
    if (!env.empty()) {
        std::ofstream f(dir / "ldp3.toml", std::ios::app);
        f << "\n[build]\nenvironment = \"" << env << "\"\n";
    }
    return true;
}

std::vector<Environment> loadEnvironments(const std::vector<ldp3::driver::DiscoveredProject>& projects) {
    std::vector<Environment> envs;
    for (const std::string& name : ldp3::driver::listEnvironments()) {
        Environment e;
        e.name = name;
        std::ifstream f(ldp3::driver::environmentManifest(name));
        if (f) {
            std::stringstream ss;
            ss << f.rdbuf();
            e.libs = ldp3::driver::parseManifestText(ss.str()).dependencies;
        }
        for (const ldp3::driver::DiscoveredProject& p : projects)
            if (p.manifest.environment == name) e.usedBy.push_back(p.manifest.name);
        envs.push_back(std::move(e));
    }
    return envs;
}

ActionResult runCaptured(const std::vector<std::string>& args, const std::filesystem::path& projectDir) {
    ActionResult r;
    std::error_code ec;

    // Pre-flight the toolchain before spawning. A missing or misconfigured install (a wrong path, an
    // incomplete package) must fail here with a clear message rather than launch something that stalls
    // forever or returns nothing -- there is deliberately no response timeout, so this check is what
    // keeps a broken toolchain from hanging the studio.
    const std::filesystem::path cli = ldp3Cli();
    if (!std::filesystem::exists(cli, ec)) {
        r.exitCode = -1;
        r.lines = {"toolchain error: the ldp3 CLI is not next to LDP3 Studio.",
                   "  expected at: " + cli.string(),
                   "Reinstall the LDP3 toolchain so ldp3 and ldp3-studio share a directory."};
        return r;
    }
    const std::string verb = args.empty() ? std::string() : args.front();
    if (verb == "build" || verb == "check" || verb == "run" || verb == "plug") {
        const ldp3::driver::Toolchain tc = ldp3::driver::locateToolchain();
        std::vector<std::string> missing;
        if (tc.ldp3c.empty() || !std::filesystem::exists(tc.ldp3c, ec))
            missing.push_back("ldp3c (compiler): " + (tc.ldp3c.empty() ? std::string("not located") : tc.ldp3c));
        if (tc.clang.empty() || !std::filesystem::exists(tc.clang, ec))
            missing.push_back("clang (linker): " + (tc.clang.empty() ? std::string("not located") : tc.clang));
        if (!missing.empty()) {
            r.exitCode = -1;
            r.lines.push_back("toolchain error: the compiler toolchain is incomplete --");
            for (const std::string& m : missing) r.lines.push_back("  missing " + m);
            r.lines.push_back("Check the LDP3 installation, or set $LDP3C / $LDP3_CLANG, then retry.");
            return r;
        }
    }

    std::string output;
    r.exitCode = ldp3::driver::runProcessCapture(cli.string(), args, output, projectDir.string(),
                                                 /*mergeStderr=*/true);
    if (r.exitCode == -1 && output.empty()) {  // CreateProcess/exec itself failed to launch the CLI
        r.lines = {"toolchain error: failed to launch '" + cli.string() + "'.",
                   "Check the installation and file permissions."};
        return r;
    }
    std::stringstream ss(output);
    std::string line;
    while (std::getline(ss, line)) {
        if (!line.empty() && line.back() == '\r') line.pop_back();
        r.lines.push_back(line);
    }
    if (r.lines.empty()) r.lines.push_back("(no output)");
    return r;
}

ActionResult runCaptured(const std::string& verb, const std::filesystem::path& projectDir) {
    return runCaptured(std::vector<std::string>{verb}, projectDir);
}

}  // namespace ldp3::studio
