#pragma once
#include <filesystem>
#include <string>
#include <vector>

namespace ldp3::driver {

// Clone `url` into `dest` (which must not already exist). If `version` is non-empty it is checked out as a
// tag/branch. Returns the git exit code (0 on success). Uses the system `git` from PATH.
int gitClone(const std::string& url, const std::string& version, const std::filesystem::path& dest);

// List the tag names published by `url` (via `git ls-remote --tags`), without cloning. Empty on failure.
std::vector<std::string> gitListTags(const std::string& url);

}  // namespace ldp3::driver
