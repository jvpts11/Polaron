// ldp3c -- the LDP3 compiler driver (CLI entry point).
//
// Release 0.1 / M1: the lexer is wired in behind --dump-tokens. The rest of
// the pipeline (parser -> semantic -> codegen -> .ll) lands in later phases.

#include <cstdio>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

#include "lexer/lexer.h"
#include "lexer/token.h"

namespace {

constexpr std::string_view kVersion = "ldp3c 0.1.0-dev";

std::optional<std::string> readFile(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) return std::nullopt;
    std::ostringstream buffer;
    buffer << in.rdbuf();
    return buffer.str();
}

int printUsage(const char* prog) {
    std::fprintf(stderr,
                 "usage: %s <input.ldp3>\n"
                 "       %s --dump-tokens <input.ldp3>\n"
                 "       %s --version\n",
                 prog, prog, prog);
    return 2;
}

int dumpTokens(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }

    ldp3::Lexer lexer(*source, path);
    const std::vector<ldp3::Token> tokens = lexer.tokenize();
    for (const ldp3::Token& tok : tokens) {
        const std::string_view name = ldp3::tokenKindName(tok.kind);
        std::printf("%s:%d:%d\t%.*s\t%s\n", path.c_str(), tok.loc.line, tok.loc.col,
                    static_cast<int>(name.size()), name.data(), tok.lexeme.c_str());
    }

    if (lexer.hasErrors()) {
        for (const ldp3::LexError& e : lexer.errors()) {
            std::fprintf(stderr, "%s:%d:%d: lex error: %s\n", path.c_str(), e.loc.line,
                         e.loc.col, e.message.c_str());
        }
        return 1;
    }
    return 0;
}

}  // namespace

int main(int argc, char** argv) {
    const std::vector<std::string_view> args(argv + 1, argv + argc);
    if (args.empty()) return printUsage(argv[0]);

    if (args[0] == "--version" || args[0] == "-v") {
        std::printf("%s\n", kVersion.data());
        return 0;
    }

    if (args[0] == "--dump-tokens") {
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --dump-tokens requires an input file\n");
            return printUsage(argv[0]);
        }
        return dumpTokens(std::string(args[1]));
    }

    // Default (placeholder until the full pipeline lands): read the source.
    const std::string path(args[0]);
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    std::printf("%s: read %zu bytes from '%s'\n", kVersion.data(), source->size(),
                path.c_str());
    return 0;
}
