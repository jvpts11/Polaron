#include "driver/deps.h"
#include "driver/git.h"
#include "driver/manifest.h"
#include "driver/process.h"
#include "driver/sources.h"
#include <cstdio>
#include <fstream>
#include <sstream>

namespace ldp3::driver {
namespace fs = std::filesystem;
namespace {

// Split "source@version" into {source, version}. Only splits on a trailing '@' whose suffix looks like a
// bare tag (no '/' or ':'), so ssh URLs like git@host:path are left intact.
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

}  // namespace

int plug(const fs::path& manifestPath, const fs::path& packagesDir, const fs::path& sourcesToml,
         const std::string& spec, const std::string& ldp3c) {
    std::string source, version;
    splitVersion(spec, source, version);
    const auto url = resolveSource(source, sourcesToml);
    if (!url) {
        std::fprintf(stderr, "ldp3: unknown package '%s'; use a full Git URL or add it to %s\n",
                     source.c_str(), sourcesToml.string().c_str());
        return 1;
    }
    const std::string name = deriveName(*url);
    if (name.empty()) {
        std::fprintf(stderr, "ldp3: could not derive a package name from '%s'\n", url->c_str());
        return 1;
    }

    std::error_code ec;
    fs::create_directories(packagesDir, ec);
    const fs::path dest = packagesDir / name;
    fs::remove_all(dest, ec);  // re-install cleanly

    if (gitClone(*url, version, dest) != 0) {
        std::fprintf(stderr, "ldp3: git clone failed for '%s'\n", url->c_str());
        fs::remove_all(dest, ec);
        return 1;
    }

    const fs::path entry = dest / depEntry(dest);
    if (!fs::is_regular_file(entry)) {
        std::fprintf(stderr, "ldp3: dependency '%s' has no entry file (%s)\n", name.c_str(),
                     entry.string().c_str());
        fs::remove_all(dest, ec);
        return 1;
    }
    const fs::path ldb = dest / (name + ".ldb");
    if (runProcess(ldp3c, {"--lib", entry.string(), "-o", ldb.string()}) != 0) {
        std::fprintf(stderr, "ldp3: compiling dependency '%s' failed\n", name.c_str());
        fs::remove_all(dest, ec);
        return 1;
    }

    addDependency(manifestPath, name, version.empty() ? "latest" : version);
    std::printf("plugged '%s'\n", name.c_str());
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

}  // namespace ldp3::driver
