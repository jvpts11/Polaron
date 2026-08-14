#include "driver/scaffold.h"
#include <cctype>
#include <cstdio>
#include <fstream>

namespace polaron::driver {
namespace fs = std::filesystem;

namespace {
bool writeFile(const fs::path& p, const std::string& content) {
    std::ofstream f(p, std::ios::binary);
    if (!f) {
        return false;
    }
    f << content;
    return static_cast<bool>(f);
}

// A directory name is not always a valid Polaron identifier ("my-game", "2048", a trailing slash leaving
// it empty): keep letters/digits/underscores, map anything else to '_', and make sure it starts with a
// letter. Used for `program <Name>;` in the generated source.
std::string identifierFrom(const std::string& name) {
    std::string id;
    for (const char c : name) {
        id += (std::isalnum(static_cast<unsigned char>(c)) || c == '_') ? c : '_';
    }
    while (!id.empty() && id.front() == '_') {
        id.erase(id.begin());
    }
    if (id.empty()) {
        id = "App";
    }
    if (std::isdigit(static_cast<unsigned char>(id.front()))) {
        id = "App" + id;
    }
    id.front() = static_cast<char>(std::toupper(static_cast<unsigned char>(id.front())));
    return id;
}
}  // namespace

int scaffold(const fs::path& dir, const std::string& name) {
    std::error_code ec;
    fs::create_directories(dir / "src", ec);
    if (ec) {
        std::fprintf(stderr, "polaron: cannot create '%s': %s\n", dir.string().c_str(), ec.message().c_str());
        return 1;
    }

    const std::string manifest =
        "[polaron_project]\n\n"
        "[program]\n"
        "name = \"" + name + "\"\n"
        "version = \"0.1.0\"\n"
        "language_version = \"1.0\"\n"
        "entry = \"src/main.pol\"\n\n"
        "[dependencies]\n\n"
        "[build]\n"
        "output = \"build-output/\"\n"
        "target = \"x86_64-windows\"\n"
        "freestanding = false\n";

    const std::string prog = identifierFrom(name);
    const std::string main =
        "import System.IO.Console;\n"
        "program " + prog + ";\n\n"
        "public bundle main {\n"
        "    public namespace app {\n"
        "        public class Main {\n"
        "            public static method main(string[] args) returns void {\n"
        "                System.IO.Console.println(\"Hello from " + prog + "!\");\n"
        "                return;\n"
        "            }\n"
        "        }\n"
        "    }\n"
        "}\n";

    const std::string gitignore = "packages/\nbuild-output/\n";

    if (!writeFile(dir / "polaron.toml", manifest) ||
        !writeFile(dir / "src" / "main.pol", main) ||
        !writeFile(dir / ".gitignore", gitignore)) {
        std::fprintf(stderr, "polaron: failed to write project files\n");
        return 1;
    }
    std::printf("created project '%s'\n", name.c_str());
    return 0;
}

}  // namespace polaron::driver
