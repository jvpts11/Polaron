#include "driver/discovery.h"

#include <algorithm>
#include <fstream>
#include <sstream>
#include <system_error>

namespace ldp3::driver {

std::vector<DiscoveredProject> discoverProjects(const std::filesystem::path& root) {
    namespace fs = std::filesystem;
    std::vector<DiscoveredProject> out;
    std::error_code ec;
    if (!fs::exists(root, ec)) return out;

    for (fs::recursive_directory_iterator it(root, fs::directory_options::skip_permission_denied, ec), end;
         it != end; it.increment(ec)) {
        if (ec) {  // a bad entry: skip it, keep walking
            ec.clear();
            continue;
        }
        if (it->is_directory(ec)) {
            const std::string name = it->path().filename().string();
            if (name == "packages" || name == "build-output" || name == ".git" || name == "node_modules")
                it.disable_recursion_pending();
            continue;
        }
        if (it->path().filename() == "ldp3.toml") {
            std::ifstream f(it->path());
            if (!f) continue;
            std::stringstream ss;
            ss << f.rdbuf();
            Manifest m = parseManifestText(ss.str());
            out.push_back({it->path().parent_path(), std::move(m)});
        }
    }

    std::sort(out.begin(), out.end(), [](const DiscoveredProject& a, const DiscoveredProject& b) {
        return a.manifest.name < b.manifest.name;
    });
    return out;
}

}  // namespace ldp3::driver
