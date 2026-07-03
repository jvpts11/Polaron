#pragma once
#include <optional>
#include <string>
#include <vector>

namespace ldp3::driver {

struct SemVer {
    int major = 0;
    int minor = 0;
    int patch = 0;
};

// Parse "1.2.3" (an optional leading 'v' is stripped). Pre-release/build suffixes are ignored. Returns
// nullopt if there is no major.minor.patch triple.
std::optional<SemVer> parseSemVer(const std::string& s);

// -1 / 0 / +1 for a < b / a == b / a > b.
int compareSemVer(const SemVer& a, const SemVer& b);

// Does version `v` satisfy `range`? Ranges: exact ("1.2.3"), caret ("^1.2.3"), tilde ("~1.2.3"),
// minimum (">=1.2.3"). An unrecognised range is treated as exact.
bool satisfies(const SemVer& v, const std::string& range);

// From `tags` (raw tag strings, possibly v-prefixed), pick the highest that parses as semver and satisfies
// `range`. Returns the original tag string, or nullopt if none match.
std::optional<std::string> highestMatching(const std::vector<std::string>& tags, const std::string& range);

// Is `s` a version range/constraint (rather than empty or a plain branch name)? True for a leading
// digit, 'v'+digit, or one of ^ ~ >= .
bool isVersionConstraint(const std::string& s);

}  // namespace ldp3::driver
