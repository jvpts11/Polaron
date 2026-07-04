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

std::filesystem::path ldp3Cli() { return ldp3::driver::exeDir() / "ldp3.exe"; }

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

ActionResult runCaptured(const std::string& verb, const std::filesystem::path& projectDir) {
    std::string output;
    ActionResult r;
    r.exitCode = ldp3::driver::runProcessCapture(ldp3Cli().string(), {verb}, output, projectDir.string(),
                                                 /*mergeStderr=*/true);
    std::stringstream ss(output);
    std::string line;
    while (std::getline(ss, line)) {
        if (!line.empty() && line.back() == '\r') line.pop_back();
        r.lines.push_back(line);
    }
    if (r.lines.empty()) r.lines.push_back("(no output)");
    return r;
}

}  // namespace ldp3::studio
