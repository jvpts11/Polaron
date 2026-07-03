#pragma once
#include <string>
#include <vector>

namespace ldp3::driver {

// Spawn `exe` with `args` and wait. Returns the child's exit code, or -1 if it could not start.
int runProcess(const std::string& exe, const std::vector<std::string>& args);

}  // namespace ldp3::driver
