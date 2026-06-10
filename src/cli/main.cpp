// ldp3c -- the LDP3 compiler driver (CLI entry point).
//
// Release 0.1 / M1 (walking skeleton): the full pipeline is wired up.
//   ldp3c <in.ldp3> [-o <out.ll>]   compile to LLVM IR (stdout if no -o)
//   ldp3c --dump-tokens <in.ldp3>   lexer output
//   ldp3c --dump-ast <in.ldp3>      parser output
//   ldp3c --check <in.ldp3>         lex + parse + semantic, report entry point
//   ldp3c --version

#include <cstdio>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "lexer/lexer.h"
#include "lexer/token.h"
#include "parser/ast.h"
#include "parser/parser.h"
#include "semantic/analyzer.h"

#ifdef LDP3_WITH_LLVM
#include "codegen/codegen.h"
#endif

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
                 "usage: %s <input.ldp3> [-o <output.ll>]\n"
                 "       %s --dump-tokens <input.ldp3>\n"
                 "       %s --dump-ast <input.ldp3>\n"
                 "       %s --check <input.ldp3>\n"
                 "       %s --version\n",
                 prog, prog, prog, prog, prog);
    return 2;
}

bool reportLexErrors(const std::string& path, const ldp3::Lexer& lexer) {
    if (!lexer.hasErrors()) return false;
    for (const ldp3::LexError& e : lexer.errors()) {
        std::fprintf(stderr, "%s:%d:%d: lex error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                     e.message.c_str());
    }
    return true;
}

bool reportParseErrors(const std::string& path, const ldp3::Parser& parser) {
    if (!parser.hasErrors()) return false;
    for (const ldp3::ParseError& e : parser.errors()) {
        std::fprintf(stderr, "%s:%d:%d: parse error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                     e.message.c_str());
    }
    return true;
}

int dumpTokens(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    for (const ldp3::Token& tok : lexer.tokenize()) {
        const std::string_view name = ldp3::tokenKindName(tok.kind);
        std::printf("%s:%d:%d\t%.*s\t%s\n", path.c_str(), tok.loc.line, tok.loc.col,
                    static_cast<int>(name.size()), name.data(), tok.lexeme.c_str());
    }
    return reportLexErrors(path, lexer) ? 1 : 0;
}

int dumpAst(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    std::vector<ldp3::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) return 1;
    ldp3::Parser parser(std::move(tokens), path);
    const ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    std::string out;
    program.dump(out, 0);
    std::fputs(out.c_str(), stdout);
    return 0;
}

int checkProgram(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    std::vector<ldp3::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) return 1;
    ldp3::Parser parser(std::move(tokens), path);
    const ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    ldp3::SemanticAnalyzer sema;
    if (!sema.analyze(program)) {
        for (const ldp3::SemaError& e : sema.errors()) {
            std::fprintf(stderr, "%s:%d:%d: error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                         e.message.c_str());
        }
        return 1;
    }
    std::printf("OK: entry point %s\n", sema.entryPoint().qualifiedName.c_str());
    return 0;
}

int compile(const std::string& path, const std::string& outPath) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    ldp3::Lexer lexer(*source, path);
    std::vector<ldp3::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) return 1;
    ldp3::Parser parser(std::move(tokens), path);
    const ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    ldp3::SemanticAnalyzer sema;
    if (!sema.analyze(program)) {
        for (const ldp3::SemaError& e : sema.errors()) {
            std::fprintf(stderr, "%s:%d:%d: error: %s\n", path.c_str(), e.loc.line, e.loc.col,
                         e.message.c_str());
        }
        return 1;
    }

#ifdef LDP3_WITH_LLVM
    ldp3::CodeGenerator codegen(program, sema.entryPoint(), path);
    if (!codegen.generate()) {
        for (const ldp3::CodegenError& e : codegen.errors()) {
            std::fprintf(stderr, "%s:%d:%d: codegen error: %s\n", path.c_str(), e.loc.line,
                         e.loc.col, e.message.c_str());
        }
        return 1;
    }
    const std::string ir = codegen.toIR();
    if (outPath.empty()) {
        std::fputs(ir.c_str(), stdout);
    } else {
        std::ofstream out(outPath, std::ios::binary);
        if (!out) {
            std::fprintf(stderr, "error: cannot write output file '%s'\n", outPath.c_str());
            return 1;
        }
        out << ir;
    }
    return 0;
#else
    (void)outPath;
    std::fprintf(stderr,
                 "error: this ldp3c was built without the LLVM backend "
                 "(configure with -DLDP3_WITH_LLVM=ON)\n");
    return 1;
#endif
}

}  // namespace

int main(int argc, char** argv) {
    const std::vector<std::string_view> args(argv + 1, argv + argc);
    if (args.empty()) return printUsage(argv[0]);

    if (args[0] == "--version" || args[0] == "-v") {
        std::printf("%s\n", kVersion.data());
        return 0;
    }

    if (args[0] == "--dump-tokens" || args[0] == "--dump-ast" || args[0] == "--check") {
        if (args.size() < 2) {
            std::fprintf(stderr, "error: %.*s requires an input file\n",
                         static_cast<int>(args[0].size()), args[0].data());
            return printUsage(argv[0]);
        }
        const std::string path(args[1]);
        if (args[0] == "--dump-tokens") return dumpTokens(path);
        if (args[0] == "--dump-ast") return dumpAst(path);
        return checkProgram(path);
    }

    // Compile mode: <input> [-o <output>].
    const std::string input(args[0]);
    std::string output;
    for (std::size_t i = 1; i < args.size(); ++i) {
        if (args[i] == "-o") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: -o requires an output path\n");
                return printUsage(argv[0]);
            }
            output = std::string(args[i + 1]);
            ++i;
        } else {
            std::fprintf(stderr, "error: unexpected argument '%.*s'\n",
                         static_cast<int>(args[i].size()), args[i].data());
            return printUsage(argv[0]);
        }
    }
    return compile(input, output);
}
