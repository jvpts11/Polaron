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

std::vector<std::string> readLines(const std::filesystem::path& p) {
    std::vector<std::string> lines;
    std::ifstream in(p);
    std::string line;
    while (std::getline(in, line)) {
        if (!line.empty() && line.back() == '\r') line.pop_back();
        lines.push_back(line);
    }
    return lines;
}

bool writeLines(const std::filesystem::path& p, const std::vector<std::string>& lines) {
    std::ofstream out(p, std::ios::binary);
    if (!out) return false;
    for (const auto& l : lines) out << l << "\n";
    return static_cast<bool>(out);
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
            if (section == "library") m.isLibrary = true;
            continue;
        }
        const auto eq = s.find('=');
        if (eq == std::string::npos) continue;
        const std::string key = trim(s.substr(0, eq));
        const std::string val = unquote(trim(s.substr(eq + 1)));
        if (section == "program" || section == "library") {
            if (section == "library") m.isLibrary = true;
            if (key == "name") m.name = val;
            else if (key == "version") m.version = val;
            else if (key == "language_version") m.languageVersion = val;
            else if (key == "entry") m.entry = val;
        } else if (section == "build") {
            if (key == "output") m.outputDir = val;
            else if (key == "target") m.target = val;
            else if (key == "sysroot") m.sysroot = val;  // cross-compile: clang/lld --sysroot for a non-host target
            else if (key == "environment") m.environment = val;
            else if (key == "freestanding") m.freestanding = (val == "true");
            else if (key == "subsystem") m.subsystem = val;  // "windows" = GUI app, no console window
            else if (key == "native_libs") {  // comma-separated system libs for FFI (opengl32, ...)
                std::stringstream ls(val);
                std::string lib;
                while (std::getline(ls, lib, ',')) {
                    const std::string t = trim(lib);
                    if (!t.empty()) m.nativeLibs.push_back(t);
                }
            }
        } else if (section == "dependencies") {
            Dependency d;
            d.name = key;
            const std::string raw = trim(s.substr(eq + 1));
            if (!raw.empty() && raw.front() == '{') {  // inline table: { path = "../lib" }
                const auto pp = raw.find("path");
                const auto q1 = (pp == std::string::npos) ? std::string::npos : raw.find('"', pp);
                const auto q2 = (q1 == std::string::npos) ? std::string::npos : raw.find('"', q1 + 1);
                if (q1 != std::string::npos && q2 != std::string::npos)
                    d.path = raw.substr(q1 + 1, q2 - q1 - 1);
            } else {
                d.version = val;
            }
            m.dependencies.push_back(d);
            m.hasDependencies = true;
        }
    }
    return m;
}

// Walk up from `start` looking for a project manifest: a .toml whose first non-blank line is
// `[ldp3_project]`. Every filesystem query takes an error_code -- the throwing overloads abort the
// process on an unreadable entry (a broken link or a permission-denied directory, both common under
// %TEMP% and network drives), which would kill the driver with no message at all.
// `sawToml` reports a .toml that was found but lacked the header, so the caller can say so.
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start,
                                                  std::filesystem::path* sawToml) {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::path dir = fs::absolute(start, ec);
    if (ec) dir = start;
    if (fs::is_regular_file(dir, ec)) dir = dir.parent_path();
    for (;; dir = dir.parent_path()) {
        std::error_code dec;
        fs::directory_iterator it(dir, fs::directory_options::skip_permission_denied, dec);
        if (!dec) {
            for (const auto& entry : it) {
                std::error_code fec;
                if (!entry.is_regular_file(fec) || fec) continue;
                if (entry.path().extension() != ".toml") continue;
                std::ifstream f(entry.path());
                std::string line;
                while (std::getline(f, line)) {
                    const std::string t = trim(line);
                    if (t.empty()) continue;
                    if (t == "[ldp3_project]") return entry.path();
                    if (sawToml != nullptr && sawToml->empty()) *sawToml = entry.path();
                    break;  // first non-blank line only
                }
            }
        }
        if (!dir.has_parent_path() || dir == dir.parent_path()) return std::nullopt;
    }
}
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start) {
    return findManifest(start, nullptr);
}

Manifest ephemeralManifest(const std::filesystem::path& file) {
    Manifest m;
    m.name = file.stem().string();
    m.entry = file.string();
    m.version = "0.0.0";
    m.singleFile = true;  // a loose file stands alone; do not sweep in sibling .ldp3 files
    return m;
}

bool addDependency(const std::filesystem::path& manifestPath, const std::string& name,
                   const std::string& version) {
    std::vector<std::string> lines = readLines(manifestPath);
    const std::string newLine = name + " = \"" + version + "\"";

    int header = -1;
    for (size_t i = 0; i < lines.size(); ++i) {
        if (trim(lines[i]) == "[dependencies]") { header = static_cast<int>(i); break; }
    }
    if (header < 0) {  // no section yet: append one
        if (!lines.empty() && !trim(lines.back()).empty()) lines.push_back("");
        lines.push_back("[dependencies]");
        lines.push_back(newLine);
        return writeLines(manifestPath, lines);
    }

    int sectionEnd = static_cast<int>(lines.size());
    for (int i = header + 1; i < static_cast<int>(lines.size()); ++i) {
        const std::string t = trim(lines[i]);
        if (!t.empty() && t.front() == '[') { sectionEnd = i; break; }
    }
    int insertAt = header + 1;
    for (int i = header + 1; i < sectionEnd; ++i) {
        const std::string t = trim(lines[i]);
        const auto eq = t.find('=');
        if (eq != std::string::npos && trim(t.substr(0, eq)) == name) {
            lines[i] = newLine;  // update in place
            return writeLines(manifestPath, lines);
        }
        if (!t.empty()) insertAt = i + 1;
    }
    lines.insert(lines.begin() + insertAt, newLine);
    return writeLines(manifestPath, lines);
}

bool removeDependency(const std::filesystem::path& manifestPath, const std::string& name) {
    std::vector<std::string> lines = readLines(manifestPath);
    bool inDeps = false;
    for (size_t i = 0; i < lines.size(); ++i) {
        const std::string t = trim(lines[i]);
        if (!t.empty() && t.front() == '[') { inDeps = (t == "[dependencies]"); continue; }
        if (!inDeps) continue;
        const auto eq = t.find('=');
        if (eq != std::string::npos && trim(t.substr(0, eq)) == name) {
            lines.erase(lines.begin() + i);
            break;
        }
    }
    return writeLines(manifestPath, lines);
}

}  // namespace ldp3::driver
