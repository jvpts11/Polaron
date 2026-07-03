#pragma once
#include <string>
#include <vector>

namespace ldp3::driver {

// Spawn `exe` with `args` and wait. Returns the child's exit code, or -1 if it could not start.
int runProcess(const std::string& exe, const std::vector<std::string>& args);

// Like runProcess but captures the child's stdout into `output`. `cwd`, when non-empty, is the child's
// working directory. With `mergeStderr`, the child's stderr is captured into `output` too (instead of going
// to the console) -- needed by the TUI, whose own display owns the terminal.
int runProcessCapture(const std::string& exe, const std::vector<std::string>& args, std::string& output,
                      const std::string& cwd = "", bool mergeStderr = false);

}  // namespace ldp3::driver
