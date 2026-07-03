#include "driver/process.h"
#include <process.h>

namespace ldp3::driver {

int runProcess(const std::string& exe, const std::vector<std::string>& args) {
    std::vector<const char*> argv;
    argv.push_back(exe.c_str());
    for (const auto& a : args) argv.push_back(a.c_str());
    argv.push_back(nullptr);
    // _P_WAIT returns the child's exit code (no shell involved, so paths with spaces are safe).
    const intptr_t rc = _spawnv(_P_WAIT, exe.c_str(), argv.data());
    return static_cast<int>(rc);
}

}  // namespace ldp3::driver
