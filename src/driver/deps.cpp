#include "driver/deps.h"
#include "driver/git.h"
#include "driver/manifest.h"
#include "driver/process.h"
#include "driver/semver.h"
#include "driver/sources.h"
#include <cstdio>
#include <fstream>
#include <set>
#include <sstream>

namespace ldp3::driver {
namespace fs = std::filesystem;
namespace {

// Split "source@version" into {source, version}. Only splits on a trailing '@' whose suffix looks like a
// bare tag/range (no '/' or ':'), so ssh URLs like git@host:path are left intact.
void splitVersion(const std::string& spec, std::string& source, std::string& version) {
    source = spec;
    version.clear();
    const auto at = spec.find_last_of('@');
    if (at == std::string::npos) return;
    const std::string after = spec.substr(at + 1);
    if (!after.empty() && after.find('/') == std::string::npos && after.find(':') == std::string::npos) {
        source = spec.substr(0, at);
        version = after;
    }
}

// The package name is the URL/path's last segment, minus a trailing ".git".
std::string deriveName(const std::string& url) {
    std::string u = url;
    while (!u.empty() && (u.back() == '/' || u.back() == '\\')) u.pop_back();
    const auto pos = u.find_last_of("/\\");
    std::string name = (pos == std::string::npos) ? u : u.substr(pos + 1);
    if (name.size() > 4 && name.substr(name.size() - 4) == ".git") name = name.substr(0, name.size() - 4);
    return name;
}

// The dependency's entry file, from its own ldp3.toml (fallback: the conventional src/main.ldp3).
std::string depEntry(const fs::path& dir) {
    const fs::path mf = dir / "ldp3.toml";
    if (fs::is_regular_file(mf)) {
        std::ifstream in(mf);
        std::stringstream ss;
        ss << in.rdbuf();
        const Manifest m = parseManifestText(ss.str());
        if (!m.entry.empty()) return m.entry;
    }
    return "src/main.ldp3";
}

Manifest readManifest(const fs::path& mf) {
    std::ifstream in(mf);
    std::stringstream ss;
    ss << in.rdbuf();
    return parseManifestText(ss.str());
}

// Clone + compile `spec` into packagesDir/<name>, then recurse into the package's own dependencies (whose
// manifest values are themselves source specs). `visited` guards against cycles and repeated work. Fills
// `recordedSource` with "url@version" for the top-level caller to record. Returns the package name, or
// nullopt on failure.
std::optional<std::string> installDep(const fs::path& packagesDir, const fs::path& sourcesToml,
                                      const std::string& spec, const std::string& ldp3c,
                                      std::set<std::string>& visited, std::string* recordedSource) {
    std::string source, version;
    splitVersion(spec, source, version);
    const auto url = resolveSource(source, sourcesToml);
    if (!url) {
        std::fprintf(stderr, "ldp3: unknown package '%s'; use a full Git URL or add it to %s\n",
                     source.c_str(), sourcesToml.string().c_str());
        return std::nullopt;
    }
    const std::string name = deriveName(*url);
    if (name.empty()) {
        std::fprintf(stderr, "ldp3: could not derive a package name from '%s'\n", url->c_str());
        return std::nullopt;
    }
    if (recordedSource) *recordedSource = version.empty() ? *url : (*url + "@" + version);
    if (visited.count(name)) return name;  // already installed in this run
    visited.insert(name);

    // Resolve a semver range/constraint to a concrete tag; a plain branch or empty version clones directly.
    std::string cloneVersion = version;
    if (!version.empty() && isVersionConstraint(version)) {
        const auto resolved = highestMatching(gitListTags(*url), version);
        if (!resolved) {
            std::fprintf(stderr, "ldp3: no tag of '%s' matches version '%s'\n", name.c_str(),
                         version.c_str());
            return std::nullopt;
        }
        cloneVersion = *resolved;
    }

    std::error_code ec;
    fs::create_directories(packagesDir, ec);
    const fs::path dest = packagesDir / name;
    fs::remove_all(dest, ec);
    if (gitClone(*url, cloneVersion, dest) != 0) {
        std::fprintf(stderr, "ldp3: git clone failed for '%s'\n", url->c_str());
        fs::remove_all(dest, ec);
        return std::nullopt;
    }
    const fs::path entry = dest / depEntry(dest);
    if (!fs::is_regular_file(entry)) {
        std::fprintf(stderr, "ldp3: dependency '%s' has no entry file (%s)\n", name.c_str(),
                     entry.string().c_str());
        fs::remove_all(dest, ec);
        return std::nullopt;
    }

    // Install this package's own dependencies first (bottom-up), collecting their bundles so it can be
    // compiled against them. Their manifest values are themselves source specs.
    std::vector<std::string> useArgs;
    for (const auto& d : readManifest(dest / "ldp3.toml").dependencies) {
        const auto depName = installDep(packagesDir, sourcesToml, d.version, ldp3c, visited, nullptr);
        if (!depName) {
            fs::remove_all(dest, ec);
            return std::nullopt;
        }
        useArgs.push_back("--use");
        useArgs.push_back((packagesDir / *depName / (*depName + ".ldb")).string());
    }

    const fs::path ldb = dest / (name + ".ldb");
    std::vector<std::string> compileArgs = {"--lib", entry.string()};
    for (const auto& u : useArgs) compileArgs.push_back(u);
    compileArgs.push_back("-o");
    compileArgs.push_back(ldb.string());
    if (runProcess(ldp3c, compileArgs) != 0) {
        std::fprintf(stderr, "ldp3: compiling dependency '%s' failed\n", name.c_str());
        fs::remove_all(dest, ec);
        return std::nullopt;
    }
    return name;
}

}  // namespace

int plug(const fs::path& manifestPath, const fs::path& packagesDir, const fs::path& sourcesToml,
         const std::string& spec, const std::string& ldp3c) {
    std::set<std::string> visited;
    std::string recordedSource;
    const auto name = installDep(packagesDir, sourcesToml, spec, ldp3c, visited, &recordedSource);
    if (!name) return 1;
    addDependency(manifestPath, *name, recordedSource);
    std::printf("plugged '%s'\n", name->c_str());
    return 0;
}

int unplug(const fs::path& manifestPath, const fs::path& packagesDir, const std::string& name) {
    const fs::path dest = packagesDir / name;
    std::error_code ec;
    const bool existed = fs::exists(dest);
    fs::remove_all(dest, ec);
    removeDependency(manifestPath, name);
    if (existed) std::printf("unplugged '%s'\n", name.c_str());
    else std::printf("'%s' was not installed\n", name.c_str());
    return 0;
}

int plugAll(const fs::path& manifestPath, const fs::path& packagesDir, const fs::path& sourcesToml,
            const std::string& ldp3c) {
    const Manifest m = readManifest(manifestPath);
    if (m.dependencies.empty()) {
        std::printf("no dependencies to install\n");
        return 0;
    }
    std::set<std::string> visited;
    int failures = 0;
    for (const auto& d : m.dependencies) {
        if (!installDep(packagesDir, sourcesToml, d.version, ldp3c, visited, nullptr)) ++failures;
    }
    if (failures > 0) {
        std::fprintf(stderr, "ldp3: %d dependency(ies) failed to install\n", failures);
        return 1;
    }
    std::printf("installed %zu dependency(ies)\n", visited.size());
    return 0;
}

}  // namespace ldp3::driver
