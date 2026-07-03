#include "studio/engine.h"

#include <sstream>

#include "driver/process.h"
#include "driver/toolchain.h"

namespace ldp3::studio {

std::filesystem::path ldp3Cli() { return ldp3::driver::exeDir() / "ldp3.exe"; }

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
