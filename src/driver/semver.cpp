#include "driver/semver.h"
#include <cctype>

namespace ldp3::driver {
namespace {

// Strip a leading 'v'/'V' and any range operator, returning the bare "x.y.z" part.
std::string bareVersion(const std::string& s) {
    std::size_t i = 0;
    if (i < s.size() && (s[i] == '^' || s[i] == '~')) ++i;
    else if (i + 1 < s.size() && s[i] == '>' && s[i + 1] == '=') i += 2;
    while (i < s.size() && (s[i] == ' ' || s[i] == 'v' || s[i] == 'V')) ++i;
    return s.substr(i);
}

}  // namespace

std::optional<SemVer> parseSemVer(const std::string& s) {
    std::string bare = bareVersion(s);
    SemVer v;
    int* fields[3] = {&v.major, &v.minor, &v.patch};
    std::size_t i = 0;
    for (int f = 0; f < 3; ++f) {
        if (i >= bare.size() || !std::isdigit(static_cast<unsigned char>(bare[i]))) {
            if (f == 0) return std::nullopt;  // need at least a major
            break;                            // "1" or "1.2" -> missing fields stay 0
        }
        int n = 0;
        while (i < bare.size() && std::isdigit(static_cast<unsigned char>(bare[i]))) {
            n = n * 10 + (bare[i] - '0');
            ++i;
        }
        *fields[f] = n;
        if (i < bare.size() && bare[i] == '.') ++i;
        else break;
    }
    return v;
}

int compareSemVer(const SemVer& a, const SemVer& b) {
    if (a.major != b.major) return a.major < b.major ? -1 : 1;
    if (a.minor != b.minor) return a.minor < b.minor ? -1 : 1;
    if (a.patch != b.patch) return a.patch < b.patch ? -1 : 1;
    return 0;
}

bool satisfies(const SemVer& v, const std::string& range) {
    const auto baseOpt = parseSemVer(range);
    if (!baseOpt) return false;
    const SemVer base = *baseOpt;

    if (range.size() >= 2 && range[0] == '>' && range[1] == '=') {
        return compareSemVer(v, base) >= 0;
    }
    if (!range.empty() && range[0] == '^') {  // >=base, < next incompatible
        if (compareSemVer(v, base) < 0) return false;
        SemVer upper;
        if (base.major > 0) upper = {base.major + 1, 0, 0};
        else if (base.minor > 0) upper = {0, base.minor + 1, 0};
        else upper = {0, 0, base.patch + 1};
        return compareSemVer(v, upper) < 0;
    }
    if (!range.empty() && range[0] == '~') {  // >=base, < next minor
        if (compareSemVer(v, base) < 0) return false;
        const SemVer upper = {base.major, base.minor + 1, 0};
        return compareSemVer(v, upper) < 0;
    }
    return compareSemVer(v, base) == 0;  // exact
}

std::optional<std::string> highestMatching(const std::vector<std::string>& tags, const std::string& range) {
    std::optional<std::string> best;
    SemVer bestVer;
    for (const auto& tag : tags) {
        const auto v = parseSemVer(tag);
        if (!v || !satisfies(*v, range)) continue;
        if (!best || compareSemVer(*v, bestVer) > 0) {
            best = tag;
            bestVer = *v;
        }
    }
    return best;
}

bool isVersionConstraint(const std::string& s) {
    if (s.empty()) return false;
    if (s[0] == '^' || s[0] == '~') return true;
    if (s.size() >= 2 && s[0] == '>' && s[1] == '=') return true;
    if (std::isdigit(static_cast<unsigned char>(s[0]))) return true;
    if ((s[0] == 'v' || s[0] == 'V') && s.size() > 1 && std::isdigit(static_cast<unsigned char>(s[1])))
        return true;
    return false;
}

}  // namespace ldp3::driver
