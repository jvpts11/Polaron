#include "driver/git.h"
#include "driver/process.h"

namespace ldp3::driver {

int gitClone(const std::string& url, const std::string& version, const std::filesystem::path& dest) {
    std::vector<std::string> args = {"clone", "--depth", "1"};
    if (!version.empty()) {
        args.push_back("--branch");
        args.push_back(version);
    }
    args.push_back(url);
    args.push_back(dest.string());
    return runProcess("git", args);
}

}  // namespace ldp3::driver
