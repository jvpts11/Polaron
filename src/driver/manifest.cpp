#include "driver/manifest.h"
#include <fstream>
#include <sstream>

namespace ldp3::driver {
namespace {

std::string trim(const std::string& s) {
    const char* ws = " \t\r\n";
    const auto b = s.find_first_not_of(ws);
    if (b == std::string::npos) return "";
    const auto e = s.find_last_not_of(ws);
    return s.substr(b, e - b + 1);
}

// Strip a trailing unquoted # comment, then trim.
std::string stripComment(const std::string& s) {
    bool inQuotes = false;
    for (size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '"') inQuotes = !inQuotes;
        else if (s[i] == '#' && !inQuotes) return trim(s.substr(0, i));
    }
    return trim(s);
}

std::string unquote(const std::string& s) {
    if (s.size() >= 2 && s.front() == '"' && s.back() == '"') return s.substr(1, s.size() - 2);
    return s;
}

}  // namespace

Manifest parseManifestText(const std::string& text) {
    Manifest m;
    std::istringstream in(text);
    std::string line;
    std::string section;
    while (std::getline(in, line)) {
        const std::string s = stripComment(line);
        if (s.empty()) continue;
        if (s.front() == '[' && s.back() == ']') {
            section = s.substr(1, s.size() - 2);
            continue;
        }
        const auto eq = s.find('=');
        if (eq == std::string::npos) continue;
        const std::string key = trim(s.substr(0, eq));
        const std::string val = unquote(trim(s.substr(eq + 1)));
        if (section == "program") {
            if (key == "name") m.name = val;
            else if (key == "version") m.version = val;
            else if (key == "language_version") m.languageVersion = val;
            else if (key == "entry") m.entry = val;
        } else if (section == "build") {
            if (key == "output") m.outputDir = val;
            else if (key == "target") m.target = val;
            else if (key == "freestanding") m.freestanding = (val == "true");
        } else if (section == "dependencies") {
            m.hasDependencies = true;
        }
    }
    return m;
}

std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start) {
    namespace fs = std::filesystem;
    fs::path dir = fs::absolute(start);
    if (fs::is_regular_file(dir)) dir = dir.parent_path();
    for (;; dir = dir.parent_path()) {
        std::error_code ec;
        for (const auto& entry : fs::directory_iterator(dir, ec)) {
            if (!entry.is_regular_file() || entry.path().extension() != ".toml") continue;
            std::ifstream f(entry.path());
            std::string line;
            while (std::getline(f, line)) {
                const std::string t = trim(line);
                if (t.empty()) continue;
                if (t == "[ldp3_project]") return entry.path();
                break;  // first non-blank line only
            }
        }
        if (!dir.has_parent_path() || dir == dir.parent_path()) return std::nullopt;
    }
}

Manifest ephemeralManifest(const std::filesystem::path& file) {
    Manifest m;
    m.name = file.stem().string();
    m.entry = file.string();
    m.version = "0.0.0";
    return m;
}

}  // namespace ldp3::driver
