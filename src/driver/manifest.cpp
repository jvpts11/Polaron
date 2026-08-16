#include "driver/manifest.h"
#include <fstream>
#include <sstream>

namespace polaron::driver {
namespace {

std::string trim(const std::string& s) {
    const char* ws = " \t\r\n";
    const auto b = s.find_first_not_of(ws);
    if (b == std::string::npos) {
        return "";
    }
    const auto e = s.find_last_not_of(ws);
    return s.substr(b, e - b + 1);
}

// Strip a trailing unquoted # comment, then trim.
std::string stripComment(const std::string& s) {
    bool inQuotes = false;
    for (size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '"') {
            inQuotes = !inQuotes;
        } else if (s[i] == '#' && !inQuotes) {
            return trim(s.substr(0, i));
        }
    }
    return trim(s);
}

std::string unquote(const std::string& s) {
    if (s.size() >= 2 && s.front() == '"' && s.back() == '"') {
        return s.substr(1, s.size() - 2);
    }
    return s;
}

std::vector<std::string> readLines(const std::filesystem::path& p) {
    std::vector<std::string> lines;
    std::ifstream in(p);
    std::string line;
    while (std::getline(in, line)) {
        if (!line.empty() && line.back() == '\r') {
            line.pop_back();
        }
        lines.push_back(line);
    }
    return lines;
}

bool writeLines(const std::filesystem::path& p, const std::vector<std::string>& lines) {
    std::ofstream out(p, std::ios::binary);
    if (!out) {
        return false;
    }
    for (const auto& l : lines) {
        out << l << "\n";
    }
    return static_cast<bool>(out);
}

// Read `{ windows = "SDL2", linux = "SDL2-2.0" }` into platform -> file. Deliberately forgiving about
// what it does not understand: an unknown inner key is simply a platform this build is not running on.
std::map<std::string, std::string> parseInlineTable(const std::string& raw) {
    std::map<std::string, std::string> out;
    const auto open = raw.find('{');
    const auto close = raw.rfind('}');
    if (open == std::string::npos || close == std::string::npos || close < open) {
        return out;
    }
    std::stringstream fields(raw.substr(open + 1, close - open - 1));
    std::string field;
    while (std::getline(fields, field, ',')) {
        const auto eq = field.find('=');
        if (eq == std::string::npos) {
            continue;
        }
        const std::string k = trim(field.substr(0, eq));
        if (!k.empty()) {
            out[k] = unquote(trim(field.substr(eq + 1)));
        }
    }
    return out;
}

}  // namespace

Manifest parseManifestText(const std::string& text) {
    Manifest m;
    std::istringstream in(text);
    std::string line;
    std::string section;
    while (std::getline(in, line)) {
        const std::string s = stripComment(line);
        if (s.empty()) {
            continue;
        }
        if (s.front() == '[' && s.back() == ']') {
            section = s.substr(1, s.size() - 2);
            if (section == "library") {
                m.isLibrary = true;
            }
            if (section == "freestanding") {  // [freestanding] section => bare-metal, and link an image
                m.freestanding = true;
                m.hasFreestandingSection = true;
            }
            continue;
        }
        const auto eq = s.find('=');
        if (eq == std::string::npos) {
            continue;
        }
        const std::string key = trim(s.substr(0, eq));
        const std::string val = unquote(trim(s.substr(eq + 1)));
        if (section == "program" || section == "library") {
            if (section == "library") {
                m.isLibrary = true;
            }
            if (key == "name") {
                m.name = val;
            } else if (key == "version") {
                m.version = val;
            } else if (key == "language_version") {
                m.languageVersion = val;
            } else if (key == "entry") {
                m.entry = val;
            }
        } else if (section == "build") {
            if (key == "output") {
                m.outputDir = val;
            } else if (key == "target") {
                m.target = val;
            } else if (key == "sysroot") {
                m.sysroot = val;  // cross-compile: clang/lld --sysroot for a non-host target
            } else if (key == "environment") {
                m.environment = val;
            } else if (key == "freestanding") {
                m.freestanding = (val == "true");
            } else if (key == "subsystem") {
                m.subsystem = val;              // "windows" = GUI app, no console window
            } else if (key == "native_libs") {  // comma-separated system libs for FFI (opengl32, ...)
                std::stringstream ls(val);
                std::string lib;
                while (std::getline(ls, lib, ',')) {
                    const std::string t = trim(lib);
                    if (!t.empty()) {
                        m.nativeLibs.push_back(t);
                    }
                }
            }
        } else if (section == "freestanding") {  // bare-metal build inputs (spec 36)
            if (key == "target") {
                m.fsTarget = val;  // override the default -none triple
            } else if (key == "linker_script") {
                m.linkerScript = val;  // explicit script: skips generation
            } else if (key == "load_address") {
                m.loadAddress = val;  // where the image is linked
            } else if (key == "boot_protocol") {
                m.bootProtocol = val;  // "pvh" -> .note.Xen section first
            } else if (key == "panic_uart") {
                m.panicUart = val;  // MMIO transmit register for the default panic reporter
            } else if (key == "image") {
                m.imageFormat = val;     // elf | bin | iso
            } else if (key == "boot") {  // comma-separated asm boot stubs, assembled with clang and linked in
                std::stringstream bs(val);
                std::string b;
                while (std::getline(bs, b, ',')) {
                    const std::string t = trim(b);
                    if (!t.empty()) {
                        m.bootSources.push_back(t);
                    }
                }
            }
        } else if (section == "dependencies") {
            Dependency d;
            d.name = key;
            const std::string raw = trim(s.substr(eq + 1));
            if (!raw.empty() && raw.front() == '{') {
                // { path = "libraries/X", source = "https://...@v1.0.1" } or { path = "../sibling" }
                const std::map<std::string, std::string> fields = parseInlineTable(raw);
                const auto p = fields.find("path");
                const auto src = fields.find("source");
                if (p != fields.end()) {
                    d.path = p->second;
                }
                if (src != fields.end()) {
                    d.source = src->second;
                    d.version = src->second;  // the spec `plug` re-resolves from
                }
            } else {
                // The bare form is the link alone; the location takes its default.
                d.source = val;
                d.version = val;
            }
            if (!d.source.empty() && d.path.empty()) {
                d.path = std::string(kLibrariesDir) + "/" + d.name;
            }
            m.dependencies.push_back(d);
            m.hasDependencies = true;
        } else if (section == "libraries") {
            // `SDL2 = { windows = "SDL2", linux = "SDL2-2.0" }` or `Zlib = "z"`.
            const std::string raw = trim(s.substr(eq + 1));
            if (!raw.empty() && raw.front() == '{') {
                m.foreignLibraries[key] = parseInlineTable(raw);
            } else {
                m.foreignLibraries[key]["*"] = val;  // one file, every platform
            }
        } else if (section.rfind("libraries.", 0) == 0) {
            // The same thing written long-hand, which is what a library with four platforms wants:
            //   [libraries.SDL2]
            //   windows = "SDL2"
            //   linux = "SDL2-2.0"
            m.foreignLibraries[section.substr(std::string("libraries.").size())][key] = val;
        }
    }
    return m;
}

std::string platformOfTriple(const std::string& triple) {
    if (triple.find("windows") != std::string::npos) {
        return "windows";
    }
    if (triple.find("darwin") != std::string::npos || triple.find("macos") != std::string::npos ||
        triple.find("apple") != std::string::npos) {
        return "macos";
    }
    return "linux";
}

std::optional<std::string> resolveForeignLibrary(const Manifest& m, const std::string& logical,
                                                 const std::string& platform) {
    return resolveForeignLibrary(m.foreignLibraries, logical, platform);
}

std::optional<std::string> resolveForeignLibrary(const ForeignLibraryMap& libs, const std::string& logical,
                                                 const std::string& platform) {
    const auto entry = libs.find(logical);
    if (entry != libs.end()) {
        const auto exact = entry->second.find(platform);
        const auto any = entry->second.find("*");
        const auto* file = (exact != entry->second.end())  ? &exact->second
                           : (any != entry->second.end()) ? &any->second
                                                           : nullptr;
        if (file != nullptr) {
            if (file->empty()) {
                return std::nullopt;  // deliberately mapped to nothing: needs no flag here
            }
            return *file;
        }
        // Named in [libraries] but not for THIS platform. Falling through to the name itself would
        // link something the manifest did not sanction, so answer nothing and let the linker report
        // the unresolved symbol -- which names the method, where a guess would name a file.
        return std::nullopt;
    }
    // `library C` is the C runtime, which every platform links already and no platform spells `c` on
    // the link line the same way (`-lc` is implicit on Linux, and Windows has no `c.lib` at all).
    if (logical == "C") {
        return std::nullopt;
    }
    return logical;
}

// Walk up from `start` looking for a project manifest: a .toml whose first meaningful line is
// `[polaron_project]`. Every filesystem query takes an error_code -- the throwing overloads abort the
// process on an unreadable entry (a broken link or a permission-denied directory, both common under
// %TEMP% and network drives), which would kill the driver with no message at all.
// `sawToml` reports a .toml that was found but lacked the header, so the caller can say so.
//
// "Meaningful" skips blank lines AND `#` comments, because a manifest is TOML and TOML has comments.
// The sniff used to break on the first non-blank line, so a manifest whose first line was a comment
// was rejected by the FINDER even though parseManifestText below reads it perfectly -- two different
// answers to "is this a manifest" in the same file.
//
// And a file named exactly `polaron.toml` that fails the sniff STOPS the walk. Climbing past it was the
// worse half of the same bug: `polaron build` in a subproject silently built the PARENT's project and
// exited 0, so the only evidence of the mistake was the name of the file it wrote. Naming a file
// polaron.toml is a claim; a claim that does not hold up is an error, not a reason to go look elsewhere.
// Any OTHER .toml (a Cargo.toml, some tool's config) is not a claim, so the walk passes it in silence.
std::optional<std::filesystem::path> findManifest(const std::filesystem::path& start,
                                                  std::filesystem::path* sawToml) {
    namespace fs = std::filesystem;
    std::error_code ec;
    fs::path dir = fs::absolute(start, ec);
    if (ec) {
        dir = start;
    }
    if (fs::is_regular_file(dir, ec)) {
        dir = dir.parent_path();
    }
    for (;; dir = dir.parent_path()) {
        std::error_code dec;
        fs::directory_iterator it(dir, fs::directory_options::skip_permission_denied, dec);
        if (!dec) {
            for (const auto& entry : it) {
                std::error_code fec;
                if (!entry.is_regular_file(fec) || fec) {
                    continue;
                }
                if (entry.path().extension() != ".toml") {
                    continue;
                }
                std::ifstream f(entry.path());
                std::string line;
                bool header = false;
                while (std::getline(f, line)) {
                    const std::string t = stripComment(line);
                    if (t.empty()) {
                        continue;  // blank, or a whole-line comment
                    }
                    header = (t == "[polaron_project]");
                    break;                            // first meaningful line only
                }
                if (header) {
                    return entry.path();
                }
                // Named polaron.toml but not one: say so here rather than building someone else's project.
                if (entry.path().filename() == "polaron.toml") {
                    if (sawToml != nullptr) {
                        *sawToml = entry.path();
                    }
                    return std::nullopt;
                }
            }
        }
        if (!dir.has_parent_path() || dir == dir.parent_path()) {
            return std::nullopt;
        }
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
    m.singleFile = true;  // a loose file stands alone; do not sweep in sibling .pol files
    return m;
}

bool addDependency(const std::filesystem::path& manifestPath, const std::string& name,
                   const std::string& version, const std::string& path) {
    std::vector<std::string> lines = readLines(manifestPath);
    // A dependency is recorded as WHAT IT IS AND WHERE IT IS, with the link it came from beside it.
    // The whole entry used to be the URL, which said where the library had been fetched from and
    // nothing about the thing now sitting in the project -- so a reader could not tell, from the
    // manifest, what was installed or where it lived.
    const std::string newLine =
        name + " = { path = \"" + path + "\", source = \"" + version + "\" }";

    int header = -1;
    for (size_t i = 0; i < lines.size(); ++i) {
        if (trim(lines[i]) == "[dependencies]") { header = static_cast<int>(i); break; }
    }
    if (header < 0) {  // no section yet: append one
        if (!lines.empty() && !trim(lines.back()).empty()) {
            lines.push_back("");
        }
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
        if (!t.empty()) {
            insertAt = i + 1;
        }
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
        if (!inDeps) {
            continue;
        }
        const auto eq = t.find('=');
        if (eq != std::string::npos && trim(t.substr(0, eq)) == name) {
            lines.erase(lines.begin() + i);
            break;
        }
    }
    return writeLines(manifestPath, lines);
}

}  // namespace polaron::driver
