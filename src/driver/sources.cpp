#include "driver/sources.h"
#include <cctype>
#include <fstream>

namespace ldp3::driver {
namespace {

std::string trim(const std::string& s) {
    const char* ws = " \t\r\n";
    const auto b = s.find_first_not_of(ws);
    if (b == std::string::npos) return "";
    const auto e = s.find_last_not_of(ws);
    return s.substr(b, e - b + 1);
}

std::string unquote(const std::string& s) {
    if (s.size() >= 2 && s.front() == '"' && s.back() == '"') return s.substr(1, s.size() - 2);
    return s;
}

// Look up `name` under [sources] in the given TOML file.
std::optional<std::string> lookupSource(const std::string& name, const std::filesystem::path& sourcesToml) {
    std::ifstream in(sourcesToml);
    if (!in) return std::nullopt;
    std::string line;
    std::string section;
    while (std::getline(in, line)) {
        const std::string s = trim(line);
        if (s.empty() || s[0] == '#') continue;
        if (s.front() == '[' && s.back() == ']') { section = s.substr(1, s.size() - 2); continue; }
        if (section != "sources") continue;
        const auto eq = s.find('=');
        if (eq == std::string::npos) continue;
        if (trim(s.substr(0, eq)) == name) return unquote(trim(s.substr(eq + 1)));
    }
    return std::nullopt;
}

}  // namespace

std::optional<std::string> resolveSource(const std::string& spec, const std::filesystem::path& sourcesToml) {
    if (spec.find("://") != std::string::npos) return spec;  // full URL
    const bool drive = spec.size() >= 2 && std::isalpha(static_cast<unsigned char>(spec[0])) && spec[1] == ':';
    if (!spec.empty() && (spec[0] == '.' || spec[0] == '/' || spec[0] == '\\' || drive)) return spec;  // path
    const auto slash = spec.find('/');
    if (slash != std::string::npos) {
        const std::string host = spec.substr(0, slash);
        if (host.find('.') != std::string::npos) return "https://" + spec;  // schemeless host
        return spec;
    }
    return lookupSource(spec, sourcesToml);  // bare name
}

}  // namespace ldp3::driver
