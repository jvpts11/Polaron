#include "driver/git.h"
#include "driver/process.h"
#include <sstream>

namespace ldp3::driver {

std::vector<std::string> gitListTags(const std::string& url) {
    std::string out;
    if (runProcessCapture("git", {"ls-remote", "--tags", url}, out) != 0) return {};
    std::vector<std::string> tags;
    std::istringstream in(out);
    std::string line;
    const std::string prefix = "refs/tags/";
    while (std::getline(in, line)) {
        const auto tab = line.find('\t');
        if (tab == std::string::npos) continue;
        std::string ref = line.substr(tab + 1);
        while (!ref.empty() && (ref.back() == '\r' || ref.back() == '\n' || ref.back() == ' '))
            ref.pop_back();
        if (ref.rfind(prefix, 0) != 0) continue;
        std::string tag = ref.substr(prefix.size());
        if (tag.size() >= 3 && tag.substr(tag.size() - 3) == "^{}") continue;  // peeled tag entry
        tags.push_back(tag);
    }
    return tags;
}

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
