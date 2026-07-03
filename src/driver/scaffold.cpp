#include "driver/scaffold.h"
#include <cstdio>
#include <fstream>

namespace ldp3::driver {
namespace fs = std::filesystem;

namespace {
bool writeFile(const fs::path& p, const std::string& content) {
    std::ofstream f(p, std::ios::binary);
    if (!f) return false;
    f << content;
    return static_cast<bool>(f);
}
}  // namespace

int scaffold(const fs::path& dir, const std::string& name) {
    std::error_code ec;
    fs::create_directories(dir / "src", ec);
    if (ec) {
        std::fprintf(stderr, "ldp3: cannot create '%s': %s\n", dir.string().c_str(), ec.message().c_str());
        return 1;
    }

    const std::string manifest =
        "[ldp3_project]\n\n"
        "[program]\n"
        "name = \"" + name + "\"\n"
        "version = \"0.1.0\"\n"
        "language_version = \"1.0\"\n"
        "entry = \"src/main.ldp3\"\n\n"
        "[dependencies]\n\n"
        "[build]\n"
        "output = \"build-output/\"\n"
        "target = \"x86_64-windows\"\n"
        "freestanding = false\n";

    const std::string main =
        "import System.IO.Console;\n"
        "program " + name + ";\n\n"
        "public bundle main {\n"
        "    public namespace app {\n"
        "        public class Main {\n"
        "            public static method main(string[] args) returns void {\n"
        "                System.IO.Console.println(\"Hello from " + name + "!\");\n"
        "                return;\n"
        "            }\n"
        "        }\n"
        "    }\n"
        "}\n";

    const std::string gitignore = "packages/\nbuild-output/\n";

    if (!writeFile(dir / "ldp3.toml", manifest) ||
        !writeFile(dir / "src" / "main.ldp3", main) ||
        !writeFile(dir / ".gitignore", gitignore)) {
        std::fprintf(stderr, "ldp3: failed to write project files\n");
        return 1;
    }
    std::printf("created project '%s'\n", name.c_str());
    return 0;
}

}  // namespace ldp3::driver
