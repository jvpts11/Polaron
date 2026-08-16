#include "driver/discovery.h"
#include "driver/manifest.h"

#include <algorithm>
#include <fstream>
#include <sstream>
#include <system_error>

#include "driver/toolchain.h"  // polaronHomeDir

namespace polaron::driver {

void discoverProjectsStreaming(const std::filesystem::path& root,
                               const std::function<void(DiscoveredProject)>& onFound,
                               const std::function<bool()>& shouldStop) {
    namespace fs = std::filesystem;
    std::error_code ec;
    if (!fs::exists(root, ec)) {
        return;
    }

    for (fs::recursive_directory_iterator it(root, fs::directory_options::skip_permission_denied, ec), end;
         it != end; it.increment(ec)) {
        if (shouldStop()) {
            return;
        }
        if (ec) {  // a bad entry: skip it, keep walking
            ec.clear();
            continue;
        }
        if (it->is_directory(ec)) {
            const std::string name = it->path().filename().string();
            if (name == kLibrariesDir || name == "packages" || name == "build-output" ||
                name == ".git" || name == "node_modules") {
                it.disable_recursion_pending();
            }
            continue;
        }
        if (it->path().filename() == "polaron.toml") {
            std::ifstream f(it->path());
            if (!f) {
                continue;
            }
            std::stringstream ss;
            ss << f.rdbuf();
            Manifest m = parseManifestText(ss.str());
            onFound({it->path().parent_path(), std::move(m)});
        }
    }
}

std::vector<DiscoveredProject> discoverProjects(const std::filesystem::path& root) {
    std::vector<DiscoveredProject> out;
    discoverProjectsStreaming(
        root, [&out](DiscoveredProject p) { out.push_back(std::move(p)); }, [] { return false; });
    std::sort(out.begin(), out.end(), [](const DiscoveredProject& a, const DiscoveredProject& b) {
        return a.manifest.name < b.manifest.name;
    });
    return out;
}

namespace {
std::filesystem::path registryPath() { return polaronHomeDir() / "registry.toml"; }

// The remembered project directories, most-recent first (one `path = "..."` per line).
std::vector<std::string> readRegistry() {
    std::vector<std::string> out;
    std::ifstream f(registryPath());
    std::string line;
    while (std::getline(f, line)) {
        if (line.find("path") == std::string::npos) {
            continue;
        }
        const auto q1 = line.find('"');
        if (q1 == std::string::npos) {
            continue;
        }
        const auto q2 = line.find('"', q1 + 1);
        if (q2 != std::string::npos) {
            out.push_back(line.substr(q1 + 1, q2 - q1 - 1));
        }
    }
    return out;
}
}  // namespace

std::vector<DiscoveredProject> loadRememberedProjects() {
    namespace fs = std::filesystem;
    std::vector<DiscoveredProject> out;
    for (const std::string& dir : readRegistry()) {
        std::ifstream f(fs::path(dir) / "polaron.toml");
        if (!f) {
            continue;  // moved or deleted since it was remembered
        }
        std::stringstream ss;
        ss << f.rdbuf();
        out.push_back({fs::path(dir), parseManifestText(ss.str())});
    }
    return out;
}

void rememberProject(const std::filesystem::path& dir) {
    namespace fs = std::filesystem;
    std::error_code ec;
    const fs::path canon = fs::weakly_canonical(dir, ec);
    const std::string key = (ec ? dir : canon).generic_string();
    std::vector<std::string> kept = {key};  // most-recent first, de-duplicated, capped
    for (const std::string& p : readRegistry()) {
        if (p != key && kept.size() < 30) {
            kept.push_back(p);
        }
    }
    fs::create_directories(registryPath().parent_path(), ec);
    std::ofstream f(registryPath(), std::ios::trunc);
    if (!f) {
        return;
    }
    f << "# Projects remembered by polaron-studio (most recent first).\n\n";
    for (const std::string& p : kept) {
        f << "[[project]]\npath = \"" << p << "\"\n\n";
    }
}

}  // namespace polaron::driver
