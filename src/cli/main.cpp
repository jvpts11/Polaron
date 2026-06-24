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
#include "parser/monomorphize.h"
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

// The embedded standard prelude. Parsed and merged into every program so that
// `import System.Memory.Units.kilobytes;` resolves without a stdlib on disk
// (spec 17.10). The unit literals return a heap-allocated ByteSize; the spec
// makes them comptime, so the allocation vanishes once comptime eval lands (F6).
constexpr std::string_view kPreludeSource = R"LDP3(
program __prelude;
public bundle std {
    public namespace System.Memory.Units {
        public struct ByteSize {
            public final int64 bytes;
            public constructor ByteSize(int64 bytes) { this.bytes = bytes; }
        }
        public comptime literal bytes(int x) returns ByteSize {
            return new ByteSize(cast<int64>(x)) on heap;
        }
        public comptime literal kilobytes(int x) returns ByteSize {
            return new ByteSize(cast<int64>(x) * 1024) on heap;
        }
        public comptime literal megabytes(int x) returns ByteSize {
            return new ByteSize(cast<int64>(x) * 1024 * 1024) on heap;
        }
        public comptime literal gigabytes(int x) returns ByteSize {
            return new ByteSize(cast<int64>(x) * 1024 * 1024 * 1024) on heap;
        }
        public comptime literal terabytes(int x) returns ByteSize {
            return new ByteSize(cast<int64>(x) * 1024 * 1024 * 1024 * 1024) on heap;
        }
        public comptime literal exabytes(int x) returns ByteSize {
            return new ByteSize(cast<int64>(x) * 1024 * 1024 * 1024 * 1024 * 1024 * 1024) on heap;
        }
    }
    public namespace System.Concurrency {
        // An OS thread (spec 20.1). Holds a function<void> and its OS handle; start()/join() call
        // the low-level thread builtins, which lower to CreateThread / WaitForSingleObject.
        public class Thread {
            private function<void> work;
            private mutable int64 handle;
            public constructor Thread(function<void> w) {
                this.work = w;
                this.handle = cast<int64>(0);
            }
            public method start() returns void {
                this.handle = System.Concurrency.__threadStart(this.work);
            }
            public method join() returns void {
                System.Concurrency.__threadJoin(this.handle);
            }
        }
        // The handle to an async computation that will produce a T (spec 20.2). `h` is the
        // runtime ldp3_task*; an async method returns one of these and `await` yields the T.
        public class Task<T> {
            public mutable int64 h;
            public constructor Task() { this.h = cast<int64>(0); }
        }
        // A lock-free atomic cell (spec 20.6). get/set/add/increment/compareAndSet (and the atomic
        // ++ / += operators) lower to LLVM atomic instructions; T is an integer type.
        public class atomic<T> {
            public mutable T value;
            public constructor atomic(T initial) { this.value = initial; }
        }
        // A mutual-exclusion lock guarding a value of type T (spec 20.5). The value is reached
        // only through `synchronized (m) using T& x { ... }`, which holds the lock for the block.
        public class Mutex<T> {
            public mutable T value;
            public mutable int64 lock;
            public constructor Mutex(T initial) {
                this.value = initial;
                this.lock = System.Concurrency.__lockCreate();
            }
        }
    }
    public namespace System.Errors {
        // Result<T,E> / Option<T> (spec 21.2-21.3): sealed sum types matched with `match`. Ok/Err/
        // Some/None are constructed with the type args taken from the expected type at the use site.
        // The abstract method forces a vtable so `match` can dispatch on the variant.
        public sealed abstract class Result<T, E> permits Ok, Err {
            public abstract method isOk() returns boolean;
        }
        public class Ok<T, E> extends Result<T, E> {
            public final T value;
            public constructor Ok(T value) { this.value = value; }
            public override method isOk() returns boolean { return true; }
        }
        public class Err<T, E> extends Result<T, E> {
            public final E error;
            public constructor Err(E error) { this.error = error; }
            public override method isOk() returns boolean { return false; }
        }
        public sealed abstract class Option<T> permits Some, None {
            public abstract method isSome() returns boolean;
        }
        public class Some<T> extends Option<T> {
            public final T value;
            public constructor Some(T value) { this.value = value; }
            public override method isSome() returns boolean { return true; }
        }
        public class None<T> extends Option<T> {
            public constructor None() {}
            public override method isSome() returns boolean { return false; }
        }
    }
    public namespace System.IO {
        // Console I/O (spec 2.9 / 4). The methods are recognized by the compiler and lower to
        // libc printf/scanf; this class exists so `import System.IO.Console;` resolves and the
        // usual namespace-visibility rules require importing it before use.
        public class Console {
        }
    }
    public namespace System.Runtime {
        // Base for runtime exceptions (polymorphic, so it can be caught). UnimportedType
        // Exception is thrown when an unimported type is used (spec 30).
        public abstract class Exception {
            public abstract method message() returns String;
        }
        public class UnimportedTypeException extends Exception {
            public constructor UnimportedTypeException() {}
            public override method message() returns String { return "type was unimported"; }
        }
    }
    public namespace System.Collections {
        // A growable list backed by a dynamic array that doubles on overflow (spec 31 uses
        // ArrayList<Method>/ArrayList<Field>; also a general-purpose collection).
        public class ArrayList<T> {
            private mutable T[] data;
            private mutable int count;
            public constructor ArrayList() {
                this.data = new T[4]();
                this.count = 0;
            }
            public method add(T item) returns void {
                if (this.count >= this.data.length()) {
                    mutable T[] bigger = new T[this.data.length() * 2]();
                    for (mutable int i = 0; i < this.count; i++) {
                        bigger[i] = this.data[i];
                    }
                    delete this.data;
                    this.data = bigger;
                }
                this.data[this.count] = item;
                this.count = this.count + 1;
            }
            public method get(int i) returns T {
                return this.data[i];
            }
            public method size() returns int {
                return this.count;
            }
        }
    }
}
)LDP3";

// Parses the embedded prelude and merges its bundles into `prog`.
void appendPrelude(ldp3::ast::Program& prog) {
    ldp3::Lexer lexer(kPreludeSource, "<prelude>");  // string_view: static lifetime
    ldp3::Parser parser(lexer.tokenize(), "<prelude>");
    ldp3::ast::Program prelude = parser.parse();
    if (parser.hasErrors()) {
        std::fprintf(stderr, "internal error: the embedded prelude failed to parse\n");
        return;
    }
    for (auto& bundle : prelude.bundles) prog.bundles.push_back(std::move(bundle));
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
    ldp3::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) return 1;
    appendPrelude(program);
    ldp3::qualifyNamespaces(program);            // make same-named types in different namespaces distinct
    if (!ldp3::monomorphize(program)) return 1;  // expand generics; false on constraint error
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

// Compiles one or more .ldp3 files that together form a single program. Each
// file declares `program <Name>;` (all must agree); their bundles are merged
// (the semantic catalog is flat, so concatenation is enough). `inputs` outlives
// this call, so token SourceLocations (string_views into the paths) stay valid.
int compile(const std::vector<std::string>& inputs, const std::string& outPath) {
    ldp3::ast::Program program;
    std::string programName;
    // Keep each file's source alive only within its iteration: the AST copies
    // the lexemes it needs, and locations reference the (long-lived) path string.
    for (const std::string& path : inputs) {
        auto source = readFile(path);
        if (!source) {
            std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
            return 1;
        }
        ldp3::Lexer lexer(*source, path);
        std::vector<ldp3::Token> tokens = lexer.tokenize();
        if (reportLexErrors(path, lexer)) return 1;
        ldp3::Parser parser(std::move(tokens), path);
        ldp3::ast::Program prog = parser.parse();
        if (reportParseErrors(path, parser)) return 1;
        if (programName.empty()) {
            programName = prog.name;
            program.name = prog.name;
            program.loc = prog.loc;
        } else if (prog.name != programName) {
            std::fprintf(stderr, "%s: error: program is '%s' but the first file declares '%s'\n",
                         path.c_str(), prog.name.c_str(), programName.c_str());
            return 1;
        }
        for (auto& bundle : prog.bundles) program.bundles.push_back(std::move(bundle));
        program.hasQualifiedTypeRef |= prog.hasQualifiedTypeRef;
    }

    appendPrelude(program);
    ldp3::qualifyNamespaces(program);            // make same-named types in different namespaces distinct
    if (!ldp3::monomorphize(program)) return 1;  // expand generics; false on constraint error
    ldp3::SemanticAnalyzer sema;
    if (!sema.analyze(program)) {
        for (const ldp3::SemaError& e : sema.errors()) {
            std::fprintf(stderr, "%.*s:%d:%d: error: %s\n", static_cast<int>(e.loc.file.size()),
                         e.loc.file.data(), e.loc.line, e.loc.col, e.message.c_str());
        }
        return 1;
    }

#ifdef LDP3_WITH_LLVM
    ldp3::CodeGenerator codegen(program, sema.entryPoint(), inputs.front());
    if (!codegen.generate()) {
        for (const ldp3::CodegenError& e : codegen.errors()) {
            std::fprintf(stderr, "%.*s:%d:%d: codegen error: %s\n",
                         static_cast<int>(e.loc.file.size()), e.loc.file.data(), e.loc.line,
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

    // Compile mode: <input...> [-o <output>]. A program may span several files.
    std::vector<std::string> inputs;
    std::string output;
    for (std::size_t i = 0; i < args.size(); ++i) {
        if (args[i] == "-o") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: -o requires an output path\n");
                return printUsage(argv[0]);
            }
            output = std::string(args[i + 1]);
            ++i;
        } else {
            inputs.emplace_back(args[i]);
        }
    }
    if (inputs.empty()) {
        std::fprintf(stderr, "error: no input files\n");
        return printUsage(argv[0]);
    }
    return compile(inputs, output);
}
