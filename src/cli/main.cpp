// ldp3c -- the LDP3 compiler driver (CLI entry point).
//
// Release 0.1 / M0: this is the walking-skeleton seed. For now it only
// validates argument handling and reads the source file. The real pipeline
// (lex -> parse -> sema -> codegen -> .ll) is wired in starting at M1.

#include <cstdio>
#include <fstream>
#include <sstream>
#include <string>
#include <string_view>

namespace {

constexpr std::string_view kVersion = "ldp3c 0.1.0-dev";

int printUsage(const char* prog) {
    std::fprintf(stderr,
                 "usage: %s <input.ldp3> [-o <output.ll>]\n"
                 "       %s --version\n",
                 prog, prog);
    return 2;
}

}  // namespace

int main(int argc, char** argv) {
    if (argc < 2) {
        return printUsage(argv[0]);
    }

    const std::string_view arg = argv[1];
    if (arg == "--version" || arg == "-v") {
        std::printf("%s\n", kVersion.data());
        return 0;
    }

    const std::string inputPath{arg};
    std::ifstream in(inputPath, std::ios::binary);
    if (!in) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", inputPath.c_str());
        return 1;
    }

    std::ostringstream buffer;
    buffer << in.rdbuf();
    const std::string source = buffer.str();

    // M0 placeholder: prove the driver reads the source end to end.
    std::printf("%s: read %zu bytes from '%s'\n", kVersion.data(), source.size(),
                inputPath.c_str());
    return 0;
}
