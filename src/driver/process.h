#pragma once
#include <string>
#include <vector>

namespace ldp3::driver {

// Spawn `exe` with `args` and wait. Returns the child's exit code, or -1 if it could not start.
int runProcess(const std::string& exe, const std::vector<std::string>& args);

// Like runProcess but captures the child's stdout into `output` (stderr still goes to the console).
int runProcessCapture(const std::string& exe, const std::vector<std::string>& args, std::string& output);

}  // namespace ldp3::driver
