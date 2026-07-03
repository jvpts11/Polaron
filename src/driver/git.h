#pragma once
#include <filesystem>
#include <string>

namespace ldp3::driver {

// Clone `url` into `dest` (which must not already exist). If `version` is non-empty it is checked out as a
// tag/branch. Returns the git exit code (0 on success). Uses the system `git` from PATH.
int gitClone(const std::string& url, const std::string& version, const std::filesystem::path& dest);

}  // namespace ldp3::driver
