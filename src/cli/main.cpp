// polc -- the Polaron compiler driver (CLI entry point).
//
// Release 0.1 / M1 (walking skeleton): the full pipeline is wired up.
//   polc <in.pol> [-o <out.ll>]   compile to LLVM IR (stdout if no -o)
//   polc --dump-tokens <in.pol>   lexer output
//   polc --dump-ast <in.pol>      parser output
//   polc --check <in.pol>...      lex + parse + semantic only (no codegen), report every diagnostic
//   polc --version

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <map>
#include <optional>
#include <tuple>
#include <sstream>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "lexer/lexer.h"
#include "lexer/token.h"
#include "parser/ast.h"
#include "parser/boundscheck.h"
#include "parser/loopopt.h"
#include "parser/ipc.h"
#include <chrono>
#include "parser/monomorphize.h"
#include "parser/parser.h"
#include "parser/transformers.h"
#include "semantic/analyzer.h"
#include "semantic/semutil.h"  // typeRefStr, for the C header's type mapping
#include "semantic/implicitthis.h"
#include "semantic/layouts.h"

#include "bundle/polh.h"
#include "diag/diagnostic.h"
#include "diag/render.h"
#include "doc/htmldoc.h"
#include "fmt/formatter.h"

#ifdef POLARON_WITH_LLVM
#include "bundle/polb.h"
#include "codegen/codegen.h"
// Renumbering a dependency's vtables (`--extract-code --remap-slots`) rewrites its module, so this
// file reads and edits IR directly -- the only place outside codegen/ that does.
#include <llvm/IR/Constants.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/raw_ostream.h>
#endif

namespace {

constexpr std::string_view kVersion = "polc 1.0.46";

std::optional<std::string> readFile(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) {
        return std::nullopt;
    }
    std::ostringstream buffer;
    buffer << in.rdbuf();
    return buffer.str();
}

// `--overlay <real>=<temp>`: read <real>'s CONTENT from <temp>, but keep calling it <real>.
//
// An editor checks a buffer that is not on disk yet. It writes the buffer to a scratch file and asks for
// a check -- and every diagnostic must still point at the file the user is looking at, not at the scratch
// copy. So the compiler is told both paths: the bytes come from one, the name from the other.
std::map<std::string, std::string> g_overlays;  // key(real) -> temp path

std::string overlayKey(const std::string& path) {
    std::error_code ec;
    std::filesystem::path c = std::filesystem::weakly_canonical(std::filesystem::path(path), ec);
    std::string s = (ec ? std::filesystem::path(path) : c).string();
#ifdef _WIN32
    for (char& ch : s) {
        ch = static_cast<char>(std::tolower(static_cast<unsigned char>(ch)));
    }
#endif
    return s;
}

std::optional<std::string> readSource(const std::string& path) {
    const auto it = g_overlays.find(overlayKey(path));
    return readFile(it == g_overlays.end() ? path : it->second);
}

// The source of every file compiled this run, so the rich-diagnostic renderer can show the offending line.
// Keyed by the loc's file string (the path as it appears in SourceLocation), and holding the OVERLAID
// content when an overlay is in effect -- the snippet must show what was actually compiled.
std::map<std::string, std::string> g_sources;
bool g_concise = false;  // --concise: one machine-parseable line per diagnostic (implied by --check)

// The 1-based `line` of `file`'s compiled source, or "" if unavailable (e.g. the embedded prelude).
std::string sourceLineAt(std::string_view file, int line) {
    const auto it = g_sources.find(std::string(file));
    if (it == g_sources.end() || line < 1) {
        return "";
    }
    const std::string& src = it->second;
    std::size_t start = 0;
    for (int cur = 1; cur < line; ++cur) {
        const std::size_t nl = src.find('\n', start);
        if (nl == std::string::npos) {
            return "";
        }
        start = nl + 1;
    }
    std::size_t end = src.find('\n', start);
    std::string ln = src.substr(start, end == std::string::npos ? std::string::npos : end - start);
    if (!ln.empty() && ln.back() == '\r') {
        ln.pop_back();
    }
    return ln;
}

// Print one semantic diagnostic (error or warning) richly, unless concise output was requested.
void printSemaDiag(std::string_view severity, const polaron::SemaError& d, bool concise) {
    const std::string file(d.loc.file);
    std::fputs(polaron::diag::render(severity, file, d.loc.line, d.loc.col, d.message, d.code,
                                  sourceLineAt(d.loc.file, d.loc.line), concise)
                   .c_str(),
               stderr);
}

// The embedded standard prelude, parsed and merged into every program so that
// `import System.Memory.Units.kilobytes;` resolves without a stdlib on disk (spec 17.10).
//
// It LIVES IN `src/prelude/prelude.pol` and is embedded at build time by
// cmake/embed_prelude.cmake. It used to be written right here, as 9 629 lines of Polaron inside a raw
// string literal: the compiler could not see its own standard library as code -- no highlighting,
// no formatter, no LSP, no `go to definition` -- and this file was 10 807 lines of which 89% were
// not C++. The generated header keeps the single self-contained binary, which is what the literal
// was for; what it gives back is a source file that is a source file.
#include "prelude_source.h"   // generated: kPreludeSource

// Parses the embedded prelude and merges its bundles into `prog`.
void appendPrelude(polaron::ast::Program& prog) {
    // Register the prelude's text under its own pseudo-path, so a diagnostic pointing into stdlib
    // code can quote the line like any other. Without this a stdlib contract could name its method
    // and its line and then show neither the clause nor the values -- which is most of the message.
    if (g_sources.find("<prelude>") == g_sources.end()) {
        g_sources["<prelude>"] = std::string(kPreludeSource);
    }
    polaron::Lexer lexer(kPreludeSource, "<prelude>");  // string_view: static lifetime
    polaron::Parser parser(lexer.tokenize(), "<prelude>");
    polaron::ast::Program prelude = parser.parse();
    if (parser.hasErrors()) {
        std::fprintf(stderr, "internal error: the embedded prelude failed to parse\n");
        for (const polaron::ParseError& e : parser.errors()) {
            std::fprintf(stderr, "  <prelude>:%d:%d: %s\n", e.loc.line, e.loc.col, e.message.c_str());
        }
        return;
    }
    // THE STANDARD LIBRARY IMPORTS ITSELF, like everybody else.
    //
    // It never did. There is not one `import` line in any of the 25 prelude files, and an exemption in
    // the analyzer let it through: "the stdlib is internally cohesive -- a type in the System bundle
    // may use any other System-bundle type without an import". Convenient, and it made the standard
    // library the ONE body of code in the program that resolves a name by a different rule from
    // everything else.
    //
    // That is what blocks type identity. When two types answer to `Scanner`, resolution asks the
    // ordinary questions -- is it yours, did you import it -- and the prelude answers neither, so it
    // needs a special case, and a special case is a second rule that has to agree with the first
    // forever. It stops needing one the moment its imports exist.
    //
    // Generated rather than written: the compiler has just parsed the declarations, so it knows every
    // type and where it lives exactly. Writing ~280 import lines by hand across 25 files would be the
    // same list, maintained by somebody.
    for (auto& bundle : prelude.bundles) {
        bundle.isPrelude = true;  // not user source; kept out of the .polh
        // `reflect` is a builtin NAMESPACE rather than a type, and the library uses it too -- the
        // serializer walks a type's fields with it. One entry, because it has no path to name.
        {
            polaron::ast::ImportDecl r;
            r.loc.file = "<prelude>";
            r.path.push_back("reflect");
            bundle.imports.push_back(std::move(r));
        }
        for (const auto& ns : bundle.namespaces) {
            auto declare = [&](const std::string& typeName) {
                polaron::ast::ImportDecl imp;
                // FROM `<prelude>`, and that is not decoration. Half a dozen checks ask whether a
                // declaration came from the standard library by looking at its FILE -- the
                // freestanding gate most of all, which refuses `StringBuilder`, `Console` and `Paths`
                // to user code and must not refuse the library its own. A synthesized import with no
                // location reads as user source and is held to the user's rules.
                imp.loc.file = "<prelude>";
                imp.path.push_back(bundle.name);
                imp.path.push_back(ns.name);
                imp.path.push_back(typeName);
                bundle.imports.push_back(std::move(imp));
            };
            for (const auto& c : ns.classes) {
                declare(c.name);
            }
            for (const auto& e : ns.enums) {
                declare(e.name);
            }
            for (const auto& cat : ns.catalogs) {
                declare(cat.name);
            }
        }
        prog.bundles.push_back(std::move(bundle));
    }
}

// Object is the root of the class hierarchy (spec 3.4): a regular class with no `extends` implicitly
// extends Object. Run after the prelude is merged so Object exists. Making a class extend Object makes
// it polymorphic (a vtable on every object), so Object's equals/hashCode dispatch on it. Excluded:
// interfaces, value types (struct/record/union), Object itself, and freestanding code -- freestanding
// needs a predictable layout with no hidden vtable (spec 36).
void assignObjectRoot(polaron::ast::Program& program) {
    for (auto& bundle : program.bundles) {
        if (program.isFreestanding || bundle.isFreestanding) {
            continue;
        }
        for (auto& ns : bundle.namespaces) {
            for (auto& cls : ns.classes) {
                if (cls.superclass.empty() && cls.name != "Object" && !cls.isInterface && !cls.isStruct &&
                    !cls.isRecord && !cls.isUnion) {
                    cls.superclass = "Object";
                }
            }
        }
    }
}

// A value type (struct/record) has no vtable and no implicit Object base, so it has none of the
// collection-keying hooks the stdlib containers call on their keys/elements: ArrayList/HashMap/HashSet
// need equalsKey (and HashMap/HashSet also key.hash()); TreeMap/TreeSet/PriorityQueue need
// key.compareTo(). Eager monomorphization compiles those container methods even when unused, so e.g.
// HashMap<Point> or TreeSet<Point> would fail to codegen ("unknown method 'hash'/'compareTo'").
// Synthesize each missing hook structurally (field by field), matching a record's auto-generated equals:
// == for equalsKey, a 31-mixed field hash for hash(), and lexicographic field order for compareTo().
// Collection-keying hooks only; no public equals() is added.
void synthesizeValueKeyHooks(polaron::ast::Program& program) {
    using namespace polaron::ast;
    // Fields whose type has its own hash()/compareTo() (String and other value types) are keyed through
    // those methods; primitive numeric/char fields are compared/hashed directly; anything else (class
    // references, arrays, pointers, enums) is skipped -- the hook still compiles, just ignores that field.
    static const std::set<std::string> numeric = {
        "byte", "short", "int", "long", "smallfloat", "float", "double", "quadruple", "char",
        "int8", "int16", "int32", "int64", "uint8", "uint16", "uint32", "uint64",
        "float32", "float64", "usize", "isize"};
    std::set<std::string> valueTypeNames = {"String"};
    for (auto& bundle : program.bundles) {
        for (auto& ns : bundle.namespaces) {
            for (auto& cls : ns.classes) {
                if ((cls.isStruct || cls.isRecord) && !cls.isUnion) {
                    valueTypeNames.insert(cls.name);
                }
            }
        }
    }

    for (auto& bundle : program.bundles) {
        for (auto& ns : bundle.namespaces) {
            for (auto& cls : ns.classes) {
                if (!(cls.isStruct || cls.isRecord) || cls.isUnion) {
                    continue;  // unions overlap storage
                }
                bool hasEq = false, hasHash = false, hasCmp = false;
                std::vector<const FieldDecl*> fields;
                for (const auto& m : cls.members) {
                    if (const auto* md = dynamic_cast<const MethodDecl*>(m.get())) {
                        if (md->name == "equalsKey") {
                            hasEq = true;
                        } else if (md->name == "hash") {
                            hasHash = true;
                        } else if (md->name == "compareTo") {
                            hasCmp = true;
                        }
                    } else if (const auto* f = dynamic_cast<const FieldDecl*>(m.get())) {
                        if (!f->isStatic) {
                            fields.push_back(f);
                        }
                    }
                }
                const auto loc = cls.loc;
                // Which fields the generated key is built from -- ONE answer, used by all three hooks.
                // They used to disagree: equalsKey compared EVERY field with `==`, while hash and
                // compareTo skipped pointers, arrays, refs, nullables and enums. So for a record with an
                // `int[]` or a `Node*` field, `==` fell back to comparing ADDRESSES while the hash ignored
                // the field entirely -- two records with identical contents were "different", and which
                // fields made up the key depended on which hook you happened to ask.
                //
                // 0 = not part of the key, 1 = compared directly, 2 = through the field type's own hooks.
                // Classified by `ast::keyFieldKind`, which codegen also calls to serialise a keyed
                // persistent -- so what makes up a type's identity is decided in exactly one place.
                auto keyPart = [&](const FieldDecl* f) -> int {
                    switch (polaron::ast::keyFieldKind(f->type, valueTypeNames)) {
                        case polaron::ast::KeyFieldKind::None:   return 0;
                        case polaron::ast::KeyFieldKind::Scalar: return 1;
                        case polaron::ast::KeyFieldKind::Text:
                        case polaron::ast::KeyFieldKind::Nested: return 2;   // through the type's own hooks
                    }
                    return 0;
                };
                // ... and say so. A field silently left out of a type's identity is how two things that
                // look equal compare unequal, and it is invisible in code that only ever reads the
                // declaration. Warn once per field, at the class, naming the way out.
                if (!hasEq || !hasHash || !hasCmp) {
                    for (const FieldDecl* f : fields) {
                        if (keyPart(f) != 0) {
                            continue;
                        }
                        std::fprintf(stderr,
                                     "warning: field '%s' of '%s' is not part of the generated key: %s "
                                     "has no structural value to compare, so it is left out of equalsKey, "
                                     "hash and compareTo alike. Two %s values that differ only in this "
                                     "field will compare EQUAL. Write your own equalsKey/hash if it should "
                                     "count, or make the field a value type (a struct, record or String).\n",
                                     f->name.c_str(), cls.name.c_str(),
                                     f->type.isArray      ? "an array"
                                     : f->type.isPointer  ? "a pointer"
                                     : f->type.isRef      ? "a reference"
                                     : f->type.isNullable ? "a nullable field"
                                                          : "a class or enum reference",
                                     cls.name.c_str());
                    }
                }
                // --- small AST builders (capture loc) ---
                auto ident = [&](const std::string& n) -> ExprPtr {
                    auto e = std::make_unique<IdentifierExpr>(); e->loc = loc; e->name = n; return e;
                };
                auto field = [&](const std::string& recv, const std::string& fn) -> ExprPtr {
                    auto e = std::make_unique<MemberExpr>(); e->loc = loc; e->member = fn;
                    e->object = ident(recv); return e;
                };
                auto intLit = [&](const char* t) -> ExprPtr {
                    auto e = std::make_unique<IntLiteralExpr>(); e->loc = loc; e->text = t; return e;
                };
                auto cast = [&](const std::string& ty, ExprPtr op) -> ExprPtr {
                    auto e = std::make_unique<CastExpr>(); e->loc = loc; e->targetType = ty;
                    e->operand = std::move(op); return e;
                };
                auto binary = [&](const std::string& op, ExprPtr l, ExprPtr r) -> ExprPtr {
                    auto e = std::make_unique<BinaryExpr>(); e->loc = loc; e->op = op;
                    e->lhs = std::move(l); e->rhs = std::move(r); return e;
                };
                auto call0 = [&](ExprPtr recv, const std::string& m) -> ExprPtr {
                    auto callee = std::make_unique<MemberExpr>(); callee->loc = loc; callee->member = m;
                    callee->object = std::move(recv);
                    auto c = std::make_unique<CallExpr>(); c->loc = loc; c->callee = std::move(callee);
                    return c;
                };
                auto call1 = [&](ExprPtr recv, const std::string& m, ExprPtr arg) -> ExprPtr {
                    auto callee = std::make_unique<MemberExpr>(); callee->loc = loc; callee->member = m;
                    callee->object = std::move(recv);
                    auto c = std::make_unique<CallExpr>(); c->loc = loc; c->callee = std::move(callee);
                    c->args.push_back(std::move(arg)); return c;
                };
                auto ret = [&](ExprPtr v) -> polaron::ast::StmtPtr {
                    auto s = std::make_unique<ReturnStmt>(); s->loc = loc; s->value = std::move(v); return s;
                };

                // --- equalsKey: field-by-field == (&&) ---
                if (!hasEq) {
                    auto method = std::make_unique<MethodDecl>();
                    method->loc = loc; method->visibility = "public"; method->name = "equalsKey";
                    Param p; p.loc = loc; p.type.name = cls.name; p.name = "other";
                    method->params.push_back(std::move(p));
                    method->returnType.name = "boolean";
                    ExprPtr expr;
                    for (const FieldDecl* f : fields) {
                        const int part = keyPart(f);
                        if (part == 0) {
                            continue;  // the same fields hash and compareTo use, not more
                        }
                        // A value-typed field compares through its OWN equalsKey. `==` on it would test
                        // the reference, which is the disagreement this whole predicate exists to end.
                        auto cmp = part == 2
                            ? call1(field("this", f->name), "equalsKey", field("other", f->name))
                            : binary("==", field("this", f->name), field("other", f->name));
                        expr = expr ? binary("&&", std::move(expr), std::move(cmp)) : std::move(cmp);
                    }
                    if (!expr) { auto b = std::make_unique<BoolLiteralExpr>(); b->loc = loc; b->value = true; expr = std::move(b); }
                    method->body.statements.push_back(ret(std::move(expr)));
                    cls.members.push_back(std::move(method));
                }

                // --- hash: acc = acc*31 + <per-field contribution>, seeded at 17 (all long) ---
                if (!hasHash) {
                    auto method = std::make_unique<MethodDecl>();
                    method->loc = loc; method->visibility = "public"; method->name = "hash";
                    method->returnType.name = "long";
                    ExprPtr acc = cast("long", intLit("17"));
                    for (const FieldDecl* f : fields) {
                        const int part = keyPart(f);   // exactly the fields equalsKey compares
                        if (part == 0) {
                            continue;
                        }
                        // A boolean is part of the key (equalsKey compares it), but `cast<long>` of one
                        // is not a legal conversion in Polaron -- so folding it like any other scalar made
                        // this generated method reject itself, and every struct or record with a
                        // `boolean` field became UNDECLARABLE with an error pointing at a cast its
                        // author never wrote. Contribute 1 or 0 instead, which is what the cast was
                        // reaching for. (`compareTo` above leaves booleans out of the ORDERING, and
                        // says so -- an order is a weaker contract than an identity, and a hash that
                        // ignored a field equalsKey compares would put unequal values in one bucket.)
                        ExprPtr contrib;
                        if (part == 2) {
                            contrib = call0(field("this", f->name), "hash");
                        } else if (f->type.name == "boolean") {
                            auto t = std::make_unique<TernaryExpr>();
                            t->loc = loc;
                            t->cond = field("this", f->name);
                            t->thenExpr = cast("long", intLit("1"));
                            t->elseExpr = cast("long", intLit("0"));
                            contrib = std::move(t);
                        } else {
                            contrib = cast("long", field("this", f->name));
                        }
                        acc = binary("+", binary("*", std::move(acc), cast("long", intLit("31"))),
                                     std::move(contrib));
                    }
                    method->body.statements.push_back(ret(std::move(acc)));
                    cls.members.push_back(std::move(method));
                }

                // --- compareTo: lexicographic over the fields; first non-equal field decides ---
                if (!hasCmp) {
                    auto method = std::make_unique<MethodDecl>();
                    method->loc = loc; method->visibility = "public"; method->name = "compareTo";
                    Param p; p.loc = loc; p.type.name = cls.name; p.name = "other";
                    method->params.push_back(std::move(p));
                    method->returnType.name = "int";
                    for (const FieldDecl* f : fields) {
                        if (keyPart(f) == 0) {
                            continue;  // same fields again
                        }
                        const std::string& ft = f->type.name;
                        if (valueTypeNames.count(ft) > 0) {
                            // if (this.f.compareTo(other.f) != 0) return this.f.compareTo(other.f);
                            auto cond = binary("!=", call1(field("this", f->name), "compareTo", field("other", f->name)), intLit("0"));
                            auto ifs = std::make_unique<IfStmt>(); ifs->loc = loc; ifs->cond = std::move(cond);
                            ifs->thenBlock.statements.push_back(ret(call1(field("this", f->name), "compareTo", field("other", f->name))));
                            method->body.statements.push_back(std::move(ifs));
                        } else if (numeric.count(ft) > 0) {
                            // Numeric/char fields order directly with </>. (boolean fields have no </>
                            // and cannot cast to int, so they don't participate in the ordering.)
                            auto ltIf = std::make_unique<IfStmt>(); ltIf->loc = loc;
                            ltIf->cond = binary("<", field("this", f->name), field("other", f->name));
                            ltIf->thenBlock.statements.push_back(ret(intLit("-1")));
                            method->body.statements.push_back(std::move(ltIf));
                            auto gtIf = std::make_unique<IfStmt>(); gtIf->loc = loc;
                            gtIf->cond = binary(">", field("this", f->name), field("other", f->name));
                            gtIf->thenBlock.statements.push_back(ret(intLit("1")));
                            method->body.statements.push_back(std::move(gtIf));
                        }
                    }
                    method->body.statements.push_back(ret(intLit("0")));
                    cls.members.push_back(std::move(method));
                }
            }
        }
    }
}

int printUsage(const char* prog) {
    std::fprintf(stderr,
                 "usage: %s <input.pol> [-o <output.ll>] [--use <dep.polb>] [--use-dynamic <dep.polb>]\n"
                 "       %s --lib <input.pol> -o <output.polb>   (compile a bundle; emits .polb + .polh)\n"
                 "       %s --extract-code <input.polb> -o <output.bc>\n"
                 "       %s --dump-polb <input.polb>\n"
                 "       %s --dump-tokens <input.pol>\n"
                 "       %s --dump-ast <input.pol>\n"
                 "       %s --check <input.pol>\n"
                 "       %s --version\n"
                 "\n"
                 "  --no-region-binder   turn OFF the escape checks that stop a pointer to a dead\n"
                 "                       frame from leaving the frame. They are on by default; this\n"
                 "                       is the way to write one deliberately.\n",
                 prog, prog, prog, prog, prog, prog, prog, prog);
    return 2;
}

bool reportLexErrors(const std::string& path, const polaron::Lexer& lexer, bool concise = false) {
    if (!lexer.hasErrors()) {
        return false;
    }
    for (const polaron::LexError& e : lexer.errors()) {
        std::fputs(polaron::diag::render("error", path, e.loc.line, e.loc.col, e.message,
                                      polaron::diag::Code::LexError, sourceLineAt(path, e.loc.line), concise)
                       .c_str(),
                   stderr);
    }
    return true;
}

bool reportParseErrors(const std::string& path, const polaron::Parser& parser, bool concise = false) {
    if (!parser.hasErrors()) {
        return false;
    }
    for (const polaron::ParseError& e : parser.errors()) {
        std::fputs(polaron::diag::render("error", path, e.loc.line, e.loc.col, e.message,
                                      polaron::diag::Code::SyntaxError, sourceLineAt(path, e.loc.line), concise)
                       .c_str(),
                   stderr);
    }
    return true;
}

int dumpTokens(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    polaron::Lexer lexer(*source, path);
    for (const polaron::Token& tok : lexer.tokenize()) {
        const std::string_view name = polaron::tokenKindName(tok.kind);
        std::printf("%s:%d:%d\t%.*s\t%s\n", path.c_str(), tok.loc.line, tok.loc.col,
                    static_cast<int>(name.size()), name.data(), tok.lexeme.c_str());
    }
    return reportLexErrors(path, lexer) ? 1 : 0;
}

// `polc --fmt <file> [-o out]`: re-format a file's whitespace, in place by default.
int fmtFile(const std::string& path, const std::string& outPath) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    bool ok = false;
    const std::string formatted = polaron::fmt::format(*source, path, &ok);
    if (!ok) {
        std::fprintf(stderr, "error: cannot format '%s' (it does not lex)\n", path.c_str());
        return 1;
    }
    const std::string& target = outPath.empty() ? path : outPath;
    std::ofstream out(target, std::ios::binary);
    if (!out) {
        std::fprintf(stderr, "error: cannot write '%s'\n", target.c_str());
        return 1;
    }
    out << formatted;
    return 0;
}

// `polc --doc <file> [-o out.html]`: parse a file and render its public API to HTML from /// comments.
int dumpDoc(const std::string& path, const std::string& outPath) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    polaron::Lexer lexer(*source, path);
    std::vector<polaron::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) {
        return 1;
    }
    polaron::Parser parser(std::move(tokens), path, *source);
    polaron::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) {
        return 1;
    }
    // EXPANSION RUNS BEFORE THE DOCUMENTATION IS WRITTEN, so what is documented is what the types
    // really have. A transformer's whole purpose is to put members into somebody else's type, and a
    // reader who has to open the transformer to find out what a class can do has been handed the
    // work back. It also makes the COMPOSED conversions visible: `collective` produces bodies nobody
    // wrote, and this page is the one place they can be read.
    //
    // Its diagnostics still print, and the page is still written: documenting a program that does
    // not expand cleanly is more use than refusing to, and staying silent about why would be worse
    // than either.
    polaron::expandTransformers(program);
    const std::string html = polaron::doc::generateHtml(program, lexer.docComments());
    if (outPath.empty()) {
        std::fputs(html.c_str(), stdout);
        return 0;
    }
    std::ofstream out(outPath, std::ios::binary);
    if (!out) {
        std::fprintf(stderr, "error: cannot write '%s'\n", outPath.c_str());
        return 1;
    }
    out << html;
    std::printf("wrote %s\n", outPath.c_str());
    return 0;
}

int dumpAst(const std::string& path) {
    auto source = readFile(path);
    if (!source) {
        std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
        return 1;
    }
    polaron::Lexer lexer(*source, path);
    std::vector<polaron::Token> tokens = lexer.tokenize();
    if (reportLexErrors(path, lexer)) {
        return 1;
    }
    polaron::Parser parser(std::move(tokens), path);
    const polaron::ast::Program program = parser.parse();
    if (reportParseErrors(path, parser)) {
        return 1;
    }
    std::string out;
    program.dump(out, 0);
    std::fputs(out.c_str(), stdout);
    return 0;
}

// Compiles one or more .pol files that together form a single program. Each
// file declares `program <Name>;` (all must agree); their bundles are merged
// (the semantic catalog is flat, so concatenation is enough). `inputs` outlives
// this call, so token SourceLocations (string_views into the paths) stay valid.
// Refuses a bundle whose code was laid out by different rules from the ones this compiler uses.
//
// THE FINGERPRINT CANNOT ANSWER THIS. It hashes the .polh, and two compilers can agree on every
// declaration in that header while disagreeing about where a field sits -- and when they do, nothing
// notices, because the consumer then reads and writes a consistent wrong offset. So the layout rules
// carry a revision of their own (`kAbiRevision`), and it is checked here rather than inferred.
//
// The producer string is in the message and not in the test on purpose: two releases of polc with the
// same layout rules must still link, and one release that changes them must not.
bool bundleAbiIsCompatible(const polaron::PolbBundle& b, const std::string& path) {
    if (b.abiRevision == polaron::kAbiRevision) {
        return true;
    }
    std::fprintf(stderr,
                 "error: bundle '%s' was built to ABI revision %u and this compiler lays objects out to "
                 "revision %u%s%s%s -- rebuild the bundle from source. (The fingerprint matches: the "
                 "two agree on the declarations and disagree on the layout, which is exactly the case "
                 "no header check can see.)\n",
                 path.c_str(), static_cast<unsigned>(b.abiRevision),
                 static_cast<unsigned>(polaron::kAbiRevision), b.producer.empty() ? "" : " (built by ",
                 b.producer.empty() ? "" : b.producer.c_str(), b.producer.empty() ? "" : ")");
    return false;
}

// Prints a .polb's header (name, version, flags, fingerprint, code size) and its embedded .polh.
int dumpPolb(const std::string& path) {
#ifdef POLARON_WITH_LLVM
    auto bytes = readFile(path);
    if (!bytes) {
        std::fprintf(stderr, "error: cannot open '%s'\n", path.c_str());
        return 1;
    }
    polaron::PolbBundle b;
    if (!polaron::readPolb(*bytes, b)) {
        std::fprintf(stderr, "error: '%s' is not a valid .polb bundle\n", path.c_str());
        return 1;
    }
    std::printf("bundle: %s\n", b.name.c_str());
    std::printf("version: %s\n", b.version.c_str());
    std::printf("producer: %s\n", b.producer.empty() ? "(unrecorded)" : b.producer.c_str());
    std::printf("abi revision: %u%s\n", static_cast<unsigned>(b.abiRevision),
                b.abiRevision == polaron::kAbiRevision ? "" : " (DIFFERENT from this compiler's)");
    std::printf("flags: 0x%04x%s\n", static_cast<unsigned>(b.flags),
                (b.flags & polaron::PolbBundle::kFreestanding) ? " (freestanding)" : "");
    std::printf("fingerprint: ");
    for (unsigned char c : b.fingerprint) {
        std::printf("%02x", c);
    }
    std::printf("\ncode: %llu bytes of bitcode\n", static_cast<unsigned long long>(b.code.size()));
    for (const polaron::PolbDep& d : b.deps) {
        std::printf("dep: %s %s\n", d.name.c_str(), d.versionConstraint.c_str());
    }
    for (const std::string& c : b.capabilities) {
        std::printf("capability: %s\n", c.c_str());
    }
    std::printf("--- .polh ---\n%s", b.polh.c_str());
    return 0;
#else
    (void)path;
    std::fprintf(stderr, "error: this polc was built without the LLVM backend\n");
    return 1;
#endif
}

// TWO INDEPENDENT LIBRARIES COULD NOT BE USED IN ONE PROGRAM, and remapping is what fixes it.
//
// Every bundle bakes its vtables with its own 0-based slot numbering, so a library of shapes and a
// library of animals -- sharing not one type -- both claim slot 0, and linking them was refused
// outright: "vtable layout incompatible ... they cannot be linked together". Reproduced with two
// four-line bundles. For a language meant to ship binary libraries that is not a rough edge; it is the
// feature not existing.
//
// The numbering cannot simply be made independent: it is GLOBAL on purpose, because that is what lets
// a class implementing several interfaces dispatch all of them through one table. What can be done is
// to TRANSLATE. The consumer's compile knows its merged numbering and each dependency's own, so a
// dependency's baked vtables are permuted into the merged layout as its code is extracted. Nothing
// about dispatch changes; the tables are renumbered on the way in.
//
// Same principle as the rest of the bundle model: not "stabilise the ABI", but "know exactly what the
// other side did, and reconcile it".

// Permute one vtable initializer from the `from` numbering into the `to` numbering.
//
// The emitted table is ONE LONGER than the slot map: `computeSlots` returns a full-width row indexed by
// global slot, and codegen appends the most-derived destructor after it for virtual `delete`. That
// trailing entry is positional, not named, so it is carried across rather than looked up -- and getting
// this off by one is not a compile error, it is a table whose last useful entry is a destructor pointer
// called as a method. (It was: the size test demanded exact equality, never matched, and every table was
// passed through unpermuted.)
static llvm::Constant* remapVtableInit(llvm::Constant* init, const std::vector<std::string>& from,
                                       const std::vector<std::string>& to) {
    auto* arrTy = llvm::dyn_cast<llvm::ArrayType>(init->getType());
    if (arrTy == nullptr || arrTy->getNumElements() != from.size() + 1) {
        return nullptr;   // not a slot table in this numbering: leave it alone
    }
    llvm::Type* elemTy = arrTy->getElementType();
    std::vector<llvm::Constant*> out(to.size() + 1, llvm::Constant::getNullValue(elemTy));
    for (std::size_t i = 0; i < from.size(); ++i) {
        if (from[i].empty()) {
            continue;   // a slot this bundle numbered but no class of it implements
        }
        auto at = std::find(to.begin(), to.end(), from[i]);
        if (at == to.end()) {
            continue;   // a name the consumer never learned: nothing can call it here
        }
        out[static_cast<std::size_t>(at - to.begin())] =
            init->getAggregateElement(static_cast<unsigned>(i));
    }
    out.back() = init->getAggregateElement(static_cast<unsigned>(from.size()));  // the destructor
    return llvm::ConstantArray::get(llvm::ArrayType::get(elemTy, to.size() + 1), out);
}

// Writes a .polb's CODE section (LLVM bitcode) to `outPath`, for the linker to consume (clang accepts
// .bc directly). Used to link a depended-on bundle's implementation into the final executable.
//
// With `mergedSlotsPath`, the bundle's vtables are renumbered into that layout first -- see above.
int extractCode(const std::string& polbPath, const std::string& outPath,
                const std::string& mergedSlotsPath = "") {
#ifdef POLARON_WITH_LLVM
    if (outPath.empty()) {
        std::fprintf(stderr, "error: --extract-code requires -o <output.bc>\n");
        return 1;
    }
    auto bytes = readFile(polbPath);
    if (!bytes) {
        std::fprintf(stderr, "error: cannot open '%s'\n", polbPath.c_str());
        return 1;
    }
    polaron::PolbBundle b;
    if (!polaron::readPolb(*bytes, b)) {
        std::fprintf(stderr, "error: '%s' is not a valid .polb bundle\n", polbPath.c_str());
        return 1;
    }
    if (!mergedSlotsPath.empty() && !b.vtableSlots.empty()) {
        std::vector<std::string> merged;
        std::ifstream slotsIn(mergedSlotsPath);
        if (!slotsIn) {
            std::fprintf(stderr, "error: cannot read the slot map '%s'\n", mergedSlotsPath.c_str());
            return 1;
        }
        for (std::string line; std::getline(slotsIn, line);) {
            while (!line.empty() && (line.back() == '\r' || line.back() == ' ')) {
                line.pop_back();
            }
            merged.push_back(line);   // an empty line is a real unused slot: the position matters
        }
        if (merged != b.vtableSlots) {
            llvm::LLVMContext ctx;
            llvm::SMDiagnostic err;
            auto buf = llvm::MemoryBuffer::getMemBuffer(b.code, polbPath,
                                                        /*RequiresNullTerminator=*/false);
            auto mod = llvm::parseIR(buf->getMemBufferRef(), err, ctx);
            if (!mod) {
                std::fprintf(stderr, "error: cannot parse the code in '%s'\n", polbPath.c_str());
                return 1;
            }
            std::vector<llvm::GlobalVariable*> tables;
            for (llvm::GlobalVariable& g : mod->globals()) {
                if (g.hasInitializer() && g.getName().contains(".vtable")) {
                    tables.push_back(&g);
                }
            }
            int remapped = 0;
            for (llvm::GlobalVariable* g : tables) {
                llvm::Constant* fresh = remapVtableInit(g->getInitializer(), b.vtableSlots, merged);
                if (fresh == nullptr) {
                    continue;
                }
                // A global's type is fixed at construction and the slot count changes, so the table is
                // REPLACED rather than reinitialised.
                auto* ng = new llvm::GlobalVariable(*mod, fresh->getType(), g->isConstant(),
                                                    g->getLinkage(), fresh, "");
                ng->setAlignment(g->getAlign());
                g->replaceAllUsesWith(ng);
                const std::string name = g->getName().str();
                g->eraseFromParent();
                ng->setName(name);
                ++remapped;
            }
            if (remapped > 0) {
                std::string text;
                llvm::raw_string_ostream os(text);
                mod->print(os, nullptr);
                os.flush();
                std::ofstream out(outPath, std::ios::binary);
                if (!out) {
                    std::fprintf(stderr, "error: cannot write '%s'\n", outPath.c_str());
                    return 1;
                }
                out << text;
                return 0;
            }
        }
    }
    std::ofstream out(outPath, std::ios::binary);
    if (!out) {
        std::fprintf(stderr, "error: cannot write '%s'\n", outPath.c_str());
        return 1;
    }
    out << b.code;
    return 0;
#else
    (void)polbPath;
    (void)outPath;
    std::fprintf(stderr, "error: this polc was built without the LLVM backend\n");
    return 1;
#endif
}

// Derives the .polh path that sits next to a .polb output (foo.polb -> foo.polh; otherwise append).
//
// The length is taken from the suffix rather than written as a number. It used to be a literal 4,
// for `.polb`, and the rename to `.polb` made it five -- so the match never fired and every bundle
// wrote `foo.polb.polh`, which the loader then could not find.
std::string polhPathFor(const std::string& polbPath) {
    constexpr std::string_view kExt = ".polb";
    if (polbPath.size() >= kExt.size() &&
        polbPath.compare(polbPath.size() - kExt.size(), kExt.size(), kExt) == 0) {
        return polbPath.substr(0, polbPath.size() - kExt.size()) + ".polh";
    }
    return polbPath + ".polh";
}

// Every logical foreign library the program depends on: the `library NAME` of each class that names
// one, deduplicated, in declaration order.
//
// The build needs this and cannot get it anywhere else. Only the compiler reads the source, and only
// the driver reads the manifest that maps a logical name to a per-platform file, so the one has to
// tell the other. Imported bundles are walked too -- linking a dependency means linking what the
// dependency binds to, and its header carries the clause for exactly that reason.
std::vector<std::string> collectForeignLibraries(const polaron::ast::Program& program) {
    std::vector<std::string> names;
    std::set<std::string> seen;
    for (const polaron::ast::Bundle& b : program.bundles) {
        for (const polaron::ast::Namespace& ns : b.namespaces) {
            for (const polaron::ast::ClassDecl& c : ns.classes) {
                if (!c.foreignLibrary.empty() && seen.insert(c.foreignLibrary).second) {
                    names.push_back(c.foreignLibrary);
                }
            }
        }
    }
    return names;
}

// THE EXTERNAL WORLD'S HEADER: what a C or C++ program must be told to call into Polaron.
//
// The closed world has the `.polh`, checked by exact verification. The open world had nothing at all
// -- a Polaron method could be exported with a bare C symbol (`public unknown win64 static method
// polaron_add(int, int) returns int` emits `define win64cc i32 @polaron_add(i32, i32)`), and the
// person on the other side had to work out the declaration by reading the source or the disassembly.
//
// The mapping is where the value is, because two of its entries are surprising and silently wrong if
// guessed: `boolean` and `char` are **i32**, not `bool` and not `char`. A C caller who declares
// `bool polaron_flag(void)` reads one byte of a four-byte return and gets whatever was in the other
// three. That fact is measured (see docs/design/abi.md) and this is the file that carries it.
std::string cTypeFor(const std::string& polaronType) {
    static const std::map<std::string, std::string> kMap = {
        {"void", "void"},        {"int", "int32_t"},     {"long", "int64_t"},
        {"short", "int16_t"},    {"byte", "int8_t"},     {"float", "float"},
        {"double", "double"},    {"address", "void*"},
        // Four bytes each, and that is the whole point of writing them down.
        {"boolean", "int32_t"},  {"char", "int32_t"},
    };
    if (auto it = kMap.find(polaronType); it != kMap.end()) {
        return it->second;
    }
    if (!polaronType.empty() && polaronType.back() == '*') {
        return "void*";   // every reference is a pointer on this side of the boundary
    }
    return "";   // no honest C spelling: the caller is told rather than given a wrong one
}

// Emit a C header for the methods this program exports to the outside world.
std::string emitCHeader(const polaron::ast::Program& program, const std::string& moduleName) {
    std::string out;
    out += "/* Generated by polc --emit-c-header from " + moduleName + ". Do not edit.\n";
    out += " *\n";
    out += " * The methods below are declared `unknown <world>` in Polaron, which is what gives them a\n";
    out += " * bare linker symbol and a named calling convention. Everything else in the program has\n";
    out += " * internal linkage and a mangled name, and is deliberately not reachable from here.\n";
    out += " *\n";
    out += " * NOTE: `boolean` and `char` are 32-BIT in Polaron. They appear below as int32_t, and\n";
    out += " * declaring them as C's `bool` or `char` reads the wrong number of bytes.\n";
    out += " */\n";
    out += "#pragma once\n#include <stdint.h>\n\n#ifdef __cplusplus\nextern \"C\" {\n#endif\n\n";
    int exported = 0;
    for (const polaron::ast::Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported) {
            continue;   // the prelude exports nothing to C, and an imported bundle has its own header
        }
        for (const polaron::ast::Namespace& ns : b.namespaces) {
            for (const polaron::ast::ClassDecl& c : ns.classes) {
                for (const polaron::ast::MemberPtr& mem : c.members) {
                    const auto* m = dynamic_cast<const polaron::ast::MethodDecl*>(mem.get());
                    if (m == nullptr || m->externConvention.rfind("unknown:", 0) != 0) {
                        continue;
                    }
                    const std::string ret = cTypeFor(polaron::semutil::typeRefStr(m->returnType));
                    std::string params;
                    bool spellable = !ret.empty();
                    for (const auto& p : m->params) {
                        const std::string pt = cTypeFor(polaron::semutil::typeRefStr(p.type));
                        if (pt.empty()) {
                            spellable = false;
                            break;
                        }
                        params += (params.empty() ? "" : ", ") + pt + " " + p.name;
                    }
                    out += "/* " + c.name + "." + m->name + ", " +
                           m->externConvention.substr(std::string("unknown:").size()) + " */\n";
                    if (!spellable) {
                        // Said out loud rather than skipped. A method missing from a generated header
                        // reads as "there is no such export", which sends the reader to look for a
                        // bug that is not there.
                        out += "/* NOT SPELLABLE IN C: a parameter or the return type is a Polaron\n";
                        out += "   value with no C equivalent (a string, an array, an object). Pass it\n";
                        out += "   as `address` and agree the layout, or export a wrapper. */\n";
                        out += "/* " + m->name + " */\n\n";
                        continue;
                    }
                    out += ret + " " + m->name + "(" + (params.empty() ? "void" : params) + ");\n\n";
                    ++exported;
                }
            }
        }
    }
    if (exported == 0) {
        out += "/* This program exports nothing: no method is declared `unknown <world>`. */\n\n";
    }
    out += "#ifdef __cplusplus\n}  /* extern \"C\" */\n#endif\n";
    return out;
}

int compile(const std::vector<std::string>& inputs, const std::string& outPath,
            const std::string& target = "", int optLevel = 0, bool libraryMode = false,
            const std::vector<std::string>& deps = {},
            const std::vector<std::string>& dynDeps = {}, bool testMode = false,
            bool debugInfo = false, const std::vector<std::string>& remoteDeps = {},
            bool checkOnly = false, bool regionBinder = true, bool verifyStack = false,
            const std::string& foreignLibsOut = "", const std::string& cHeaderOut = "",
            const std::string& slotsOut = "") {
    polaron::ast::Program program;
    std::string programName;
    // In check mode a broken file must not hide the others: an editor asks about the whole project and
    // expects every file's diagnostics back, so the front end keeps going and reports at the end.
    bool frontEndFailed = false;
    // Keep each file's source alive only within its iteration: the AST copies
    // the lexemes it needs, and locations reference the (long-lived) path string.
    for (const std::string& path : inputs) {
        auto source = readSource(path);
        if (!source) {
            std::fprintf(stderr, "error: cannot open input file '%s'\n", path.c_str());
            return 1;
        }
        g_sources[path] = *source;  // for the rich-diagnostic snippet
        const bool frontEndConcise = checkOnly || g_concise;  // check/CI: one parseable line per error
        polaron::diag::setConcise(frontEndConcise);  // so monomorphize's own diagnostics honour it too
        polaron::Lexer lexer(*source, path);
        std::vector<polaron::Token> tokens = lexer.tokenize();
        if (reportLexErrors(path, lexer, frontEndConcise)) {
            if (!checkOnly) {
                return 1;
            }
            frontEndFailed = true;
            continue;
        }
        // The source goes in as well as the tokens: a transformer's own text is kept verbatim, so a
        // declaration that is expanded rather than compiled can be republished in a `.polh` with its
        // bodies -- which is the only form of it a consuming bundle can use.
        polaron::Parser parser(std::move(tokens), path, g_sources[path]);
        polaron::ast::Program prog = parser.parse();
        if (reportParseErrors(path, parser, frontEndConcise)) {
            if (!checkOnly) {
                return 1;
            }
            frontEndFailed = true;
            continue;
        }
        if (programName.empty()) {
            programName = prog.name;
            program.name = prog.name;
            program.loc = prog.loc;
        } else if (prog.name != programName) {
            std::fprintf(stderr, "%s: error: program is '%s' but the first file declares '%s'\n",
                         path.c_str(), prog.name.c_str(), programName.c_str());
            return 1;
        }
        for (auto& bundle : prog.bundles) {
            program.bundles.push_back(std::move(bundle));
        }
        for (auto& imp : prog.imports) {
            program.imports.push_back(std::move(imp));  // file-level (spec 2.7)
        }
        program.hasQualifiedTypeRef |= prog.hasQualifiedTypeRef;
        // spec 2.8: a program that serves its types over IPC needs a dispatcher for them. Spotting the
        // call in the source is enough -- a false positive only synthesizes a dispatcher nobody calls.
        if (source->find("Program.serve") != std::string::npos) {
            program.usesIpcServe = true;
        }
        if (prog.isFreestanding) {
            program.isFreestanding = true;
        }
    }
    if (frontEndFailed) {
        return 1;  // check mode: every file was lexed and parsed, and some did not survive
    }

    std::vector<std::string> seedSlots;  // vtable slot layout adopted from imported bundles
    std::vector<std::pair<std::string, std::vector<std::string>>> depSlotMaps;  // (path, slots) per dep
    // Dynamic bundles to register with codegen: (AST bundle name, .polb path, ABI fingerprint).
    std::vector<std::tuple<std::string, std::string, std::array<std::uint8_t, 32>>> dynBundleInfo;
#ifdef POLARON_WITH_LLVM
    // Depended-on bundles (--use foo.polb): parse each .polh as the bundle's public API and merge it as
    // an imported bundle (types visible; bodies stay in the .polb, linked separately). The .polb's
    // fingerprint must match its own header, catching a corrupt or tampered bundle.
    for (const std::string& depPath : deps) {
        auto depBytes = readFile(depPath);
        if (!depBytes) {
            std::fprintf(stderr, "error: cannot open bundle '%s'\n", depPath.c_str());
            return 1;
        }
        polaron::PolbBundle dep;
        if (!polaron::readPolb(*depBytes, dep)) {
            std::fprintf(stderr, "error: '%s' is not a valid .polb bundle\n", depPath.c_str());
            return 1;
        }
        if (!bundleAbiIsCompatible(dep, depPath)) {
            return 1;
        }
        if (polaron::polbFingerprint(dep.polh) != dep.fingerprint) {
            std::fprintf(stderr, "error: bundle '%s' fingerprint does not match its header (corrupt)\n",
                         depPath.c_str());
            return 1;
        }
        polaron::Lexer dlex(dep.polh, depPath);
        polaron::Parser dparser(dlex.tokenize(), depPath);
        dparser.setHeaderMode(true);
        polaron::ast::Program dprog = dparser.parse();
        if (dparser.hasErrors()) {
            std::fprintf(stderr, "error: failed to parse the header of bundle '%s'\n", depPath.c_str());
            // WHY it failed, not merely that it did. A header is generated by this same compiler, so
            // a parse failure here is always a disagreement between the writer and the reader -- and
            // finding it without the message means bisecting a file nobody wrote by hand.
            for (const auto& e : dparser.errors()) {
                std::fprintf(stderr, "  line %d col %d: %s\n", e.loc.line, e.loc.col,
                             e.message.c_str());
            }
            return 1;
        }
        for (auto& b : dprog.bundles) {
            b.isImported = true;
            program.bundles.push_back(std::move(b));
        }
        // Adopt the bundle's vtable slot layout so virtual calls on its types hit the right slots.
        if (!dep.vtableSlots.empty()) {
            depSlotMaps.emplace_back(depPath, dep.vtableSlots);
        }
        for (const std::string& s : dep.vtableSlots) {
            if (std::find(seedSlots.begin(), seedSlots.end(), s) == seedSlots.end()) {
                seedSlots.push_back(s);
            }
        }
    }
    // Remote bundles (--use-remote foo.polb, spec 2.8): the types are known from the .polh, but the code
    // runs in ANOTHER PROGRAM. synthesizeIpc turns each of their classes into a proxy whose methods are
    // RPCs, so nothing is linked and nothing is loaded -- the calls travel over the IPC channel.
    for (const std::string& depPath : remoteDeps) {
        auto depBytes = readFile(depPath);
        if (!depBytes) {
            std::fprintf(stderr, "error: cannot open bundle '%s'\n", depPath.c_str());
            return 1;
        }
        polaron::PolbBundle dep;
        if (!polaron::readPolb(*depBytes, dep)) {
            std::fprintf(stderr, "error: '%s' is not a valid .polb bundle\n", depPath.c_str());
            return 1;
        }
        if (!bundleAbiIsCompatible(dep, depPath)) {
            return 1;
        }
        polaron::Lexer rlex(dep.polh, depPath);
        polaron::Parser rparser(rlex.tokenize(), depPath);
        rparser.setHeaderMode(true);
        polaron::ast::Program rprog = rparser.parse();
        if (rparser.hasErrors()) {
            std::fprintf(stderr, "error: failed to parse the header of bundle '%s'\n",
                         depPath.c_str());
            return 1;
        }
        for (auto& b : rprog.bundles) {
            b.isImported = true;   // synthesizeIpc clears this once it has given the classes bodies
            b.isRemote = true;
            program.bundles.push_back(std::move(b));
        }
    }
    // Dynamically-loaded bundles (--use-dynamic foo.polb): same type-checking against the .polh, but the
    // implementation is loaded at runtime (not linked). Codegen emits resolving thunks; record each
    // bundle's path and fingerprint so the thunk can load and verify it.
    for (const std::string& depPath : dynDeps) {
        auto depBytes = readFile(depPath);
        if (!depBytes) {
            std::fprintf(stderr, "error: cannot open bundle '%s'\n", depPath.c_str());
            return 1;
        }
        polaron::PolbBundle dep;
        if (!polaron::readPolb(*depBytes, dep)) {
            std::fprintf(stderr, "error: '%s' is not a valid .polb bundle\n", depPath.c_str());
            return 1;
        }
        if (!bundleAbiIsCompatible(dep, depPath)) {
            return 1;
        }
        if (polaron::polbFingerprint(dep.polh) != dep.fingerprint) {
            std::fprintf(stderr, "error: bundle '%s' fingerprint does not match its header (corrupt)\n",
                         depPath.c_str());
            return 1;
        }
        polaron::Lexer dlex(dep.polh, depPath);
        polaron::Parser dparser(dlex.tokenize(), depPath);
        dparser.setHeaderMode(true);
        polaron::ast::Program dprog = dparser.parse();
        if (dparser.hasErrors()) {
            std::fprintf(stderr, "error: failed to parse the header of bundle '%s'\n", depPath.c_str());
            return 1;
        }
        for (auto& b : dprog.bundles) {
            b.isImported = true;
            b.isDynamic = true;
            dynBundleInfo.emplace_back(b.name, depPath, dep.fingerprint);
            program.bundles.push_back(std::move(b));
        }
        if (!dep.vtableSlots.empty()) {
            depSlotMaps.emplace_back(depPath, dep.vtableSlots);
        }
        for (const std::string& s : dep.vtableSlots) {
            if (std::find(seedSlots.begin(), seedSlots.end(), s) == seedSlots.end()) {
                seedSlots.push_back(s);
            }
        }
    }
    // EACH BUNDLE'S NUMBERING IS RECONCILED, NOT REQUIRED TO MATCH.
    //
    // This used to demand that every dependency's slot list be a PREFIX of the merged one, and refuse
    // the build otherwise. Refusing was right -- dispatching through a slot another bundle numbered
    // differently calls the wrong method -- but the requirement is one no two independently built
    // libraries can meet: both number their own first virtual method 0. Two four-line bundles sharing
    // no type at all could not be used in one program.
    //
    // So the merged numbering is built as a UNION (above), and each dependency's baked vtables are
    // permuted into it when its code is extracted -- `polc --extract-code ... --remap-slots`. See
    // `extractCode`. What remains here is the one case remapping cannot fix.
    for (const auto& [path, map] : depSlotMaps) {
        for (std::size_t i = 0; i < map.size(); ++i) {
            if (map[i].empty()) {
                continue;
            }
            auto at = std::find(seedSlots.begin(), seedSlots.end(), map[i]);
            if (at == seedSlots.end()) {
                std::fprintf(stderr,
                             "error: bundle '%s' names the virtual method '%s' in its vtable, and it "
                             "is absent from the merged layout -- the bundle and its header disagree\n",
                             path.c_str(), map[i].c_str());
                return 1;
            }
        }
    }
#else
    if (!deps.empty() || !dynDeps.empty()) {
        std::fprintf(stderr, "error: --use/--use-dynamic needs the LLVM backend\n");
        return 1;
    }
#endif

    // POLARON_PHASE_TIMES=1: print how long each front-end phase takes. Kept in the tree because "which
    // pass is slow" is otherwise unanswerable without a profiler, and compile time is a feature.
    const bool phaseTimes = std::getenv("POLARON_PHASE_TIMES") != nullptr;
    auto phaseClock = std::chrono::steady_clock::now();
    auto phase = [&](const char* name) {
        if (!phaseTimes) {
            return;
        }
        const auto now = std::chrono::steady_clock::now();
        std::fprintf(stderr, "[phase] %-24s %lld ms\n", name,
                     (long long)std::chrono::duration_cast<std::chrono::milliseconds>(
                         now - phaseClock).count());
        phaseClock = now;
    };
    phase("(parse+read)");
    appendPrelude(program);
    phase("appendPrelude");
    // In a library the prelude is emitted into the .polb with weak (linkonce_odr) linkage (handled in
    // codegen): static linking deduplicates it against the program's own prelude, and a dynamically
    // built DLL is self-contained (every class extends the prelude's Object). This matters now that
    // Object is the universal root, so even a trivial bundle references the prelude.
    polaron::resolveTypeAliases(program);           // expand `typealias` to its target everywhere (spec 24)
    phase("resolveTypeAliases");
    // Before qualifyNamespaces: the remote program's header carries ITS entry class, which this pass
    // drops. Left in place, two classes named Main would look like a name clash and both would be
    // renamed -- and this program would lose its entry point.
    if (!polaron::synthesizeIpc(program)) {
        return 1;  // spec 2.8: IPC proxies + this program's dispatcher
    }
    // BEFORE qualifyNamespaces, so a transformer is matched by the name the author wrote, and before
    // everything that reads a class body -- from here on a procedure a transformer brought IS an
    // ordinary member of the type, and no later pass has to know a transformer existed.
    if (!polaron::expandTransformers(program)) {
        return 1;
    }
    phase("expandTransformers");
    polaron::qualifyNamespaces(program);            // make same-named types in different namespaces distinct
    phase("qualifyNamespaces");
    assignObjectRoot(program);                   // a class with no `extends` implicitly extends Object
    phase("assignObjectRoot");
    synthesizeValueKeyHooks(program);            // value types get structural equalsKey/hash/compareTo (collection keying)
    phase("synthesizeValueKeyHooks");
    // Before monomorphize: a generic class is delegated ONCE, on the template, and the forwarding
    // methods are then copied per instantiation like any other member.
    if (!polaron::expandDelegates(program)) {
        return 1;
    }
    phase("expandDelegates");
    // AFTER delegation, so a synthesized forwarder is walked like any other method, and BEFORE
    // everything that reads the tree: from here on a member reference IS a member access, so nothing
    // downstream needs to know the prefix was ever optional.
    if (!polaron::resolveImplicitThis(program)) {
        return 1;
    }
    phase("resolveImplicitThis");
    // A layout is named in `implements` beside the interfaces, and is not one. Splitting it out here
    // -- before anything looks for methods to bind or slots to fill -- is what lets the rest of the
    // compiler go on seeing an interface list that holds only interfaces.
    if (!polaron::resolveLayouts(program)) {
        return 1;
    }
    phase("resolveLayouts");
    if (!polaron::monomorphize(program)) {
        return 1;
    }
    phase("monomorphize");  // expand generics; false on constraint error
    // Freestanding has no managed arrays and no bounds checks (raw-pointer `p[i]` is unchecked), so these
    // array-shaped loop optimizations don't apply -- and hoistBoundsChecks would synthesize `p.length()`
    // on a raw pointer (which has no `length`), erroring under -O2. Skip both in freestanding.
    // Each middle-end pass can be switched off on its own, so "did THIS pass cost us?" is one run and
    // not a rebuild. Both of these have already been measured making a benchmark WORSE (see
    // `performance tests/README.md`), so the ability to A/B them is not hypothetical.
    const bool noInterchange = std::getenv("POLARON_NO_INTERCHANGE") != nullptr;
    const bool noHoist = std::getenv("POLARON_NO_HOIST_BOUNDS") != nullptr;
    if (optLevel > 0 && !program.isFreestanding && !noInterchange) {
        polaron::interchangeReductionLoops(program);  // loop interchange (sema re-checks it)
    }
    if (optLevel > 0 && !program.isFreestanding && !noHoist) {
        polaron::hoistBoundsChecks(program);          // bounds-check hoisting (sema re-checks it)
    }
    // `--test` on a freestanding program synthesized a runner that calls printf, __polaron_now_ns and the
    // whole hosted test runtime -- it emitted the IR without a word, and the link failed later on symbols
    // the program never wrote. Refuse at the point the mistake is made, and say what to do instead: a
    // freestanding image is tested by RUNNING it, which is what pico's harness does (boot under QEMU,
    // assert on the serial output).
    if (testMode && program.isFreestanding) {
        std::fprintf(stderr,
                     "error: `--test` is not available for a freestanding program: the generated runner "
                     "reports through printf and the managed test runtime, which bare metal has no way "
                     "to provide. Test a freestanding image from outside -- boot it and assert on what "
                     "it emits.\n");
        return 1;
    }
    polaron::SemanticAnalyzer sema;
    sema.setRegionBinder(regionBinder);
    const bool semaOk = sema.analyze(program, libraryMode, testMode);
    phase("sema.analyze");
    // `--check` (used by the editor's live check) and `--concise` want one machine-parseable line per
    // diagnostic; a normal build shows the full rich explanation.
    const bool concise = checkOnly || g_concise;
    for (const polaron::SemaError& w : sema.warnings()) {
        printSemaDiag("warning", w, concise);
    }
    if (!semaOk) {
        for (const polaron::SemaError& e : sema.errors()) {
            printSemaDiag("error", e, concise);
        }
        return 1;
    }

    // `--emit-foreign-libs`: after analysis, because a name that came out of a file that did not compile
    // is not a fact about the program. `-` writes to stdout, which is how a test asks the question.
    if (!foreignLibsOut.empty()) {
        std::string listing;
        for (const std::string& lib : collectForeignLibraries(program)) {
            listing += lib + "\n";
        }
        if (foreignLibsOut == "-") {
            std::fputs(listing.c_str(), stdout);
        } else {
            std::ofstream libs(foreignLibsOut, std::ios::binary);
            if (!libs) {
                std::fprintf(stderr, "error: cannot write '%s'\n", foreignLibsOut.c_str());
                return 1;
            }
            libs << listing;
        }
    }

    // `--emit-c-header`: the outside world's counterpart to the `.polh`. After analysis, for the same
    // reason the library list is: a declaration recovered from a file that did not compile is not a
    // fact about the program.
    if (!cHeaderOut.empty()) {
        const std::string header = emitCHeader(program, programName);
        if (cHeaderOut == "-") {
            std::fputs(header.c_str(), stdout);
        } else {
            std::ofstream hf(cHeaderOut, std::ios::binary);
            if (!hf) {
                std::fprintf(stderr, "error: cannot write '%s'\n", cHeaderOut.c_str());
                return 1;
            }
            hf << header;
        }
    }

    // `--check`: the answer is the diagnostics above, so stop here. Everything the front end can catch has
    // been caught, and codegen -- by far the slowest phase -- is skipped, which is what makes this fast
    // enough for an editor to run on every pause in typing.
    if (checkOnly) {
        if (!libraryMode) {
            std::printf("OK: entry point %s\n", sema.entryPoint().qualifiedName.c_str());
        } else {
            std::printf("OK: library\n");
        }
        return 0;
    }

#ifdef POLARON_WITH_LLVM
    polaron::CodeGenerator codegen(program, sema.entryPoint(), inputs.front());
    codegen.setPatchedClasses(sema.patchedClasses());  // spec 32.8: they need a writable vtable
    codegen.setClassReferences(sema.classReferences());  // emit only what the program can reach
    codegen.setDemandOwners(sema.demandOwners());        // ...except a build-time assertion
    // The same source map the rich diagnostics read, so a contract that fails at RUNTIME can quote
    // the clause the way an error quotes the offending line. The two now say the same kind of thing
    // in the same shape, which is the point: a contract is a diagnostic that happens later.
    codegen.setSourceLookup(sourceLineAt);
    // Always set a triple (and, through it, the data layout) -- with --target for freestanding/cross, or
    // the host's otherwise -- so ABI alignments are correct and hot loops vectorize. Without this the
    // module is layout-less and i64 loads emit `align 4`.
    std::string effectiveTriple = target;
    if (effectiveTriple.empty()) {
#ifdef _WIN32
        effectiveTriple = "x86_64-pc-windows-msvc";
#else
        effectiveTriple = "x86_64-unknown-linux-gnu";
#endif
    }
    codegen.setTargetTriple(effectiveTriple);
    codegen.setLibrary(libraryMode);  // a .polb has no entry point / `main`
    codegen.setTestMode(testMode);    // --test: synthetic [Test] runner as the entry
    codegen.setDebugInfo(debugInfo);  // -g: emit DWARF debug metadata
    codegen.setVerifyStack(verifyStack);  // --verify-stack: each method proves its own stack pointer
    codegen.seedVtableSlots(seedSlots);  // adopt imported bundles' vtable slot layout
    for (const auto& [name, path, fp] : dynBundleInfo) {
        codegen.addDynamicBundle(name, path, fp);  // runtime-resolving thunks for --use-dynamic
    }
    if (!codegen.generate()) {
        // Through the SAME renderer the front end uses. Codegen's errors used to be printed raw --
        // no code, no source line, no caret, no why/fix/prevent, and invisible to `polaron explain` --
        // so which half of the compiler noticed a mistake decided how well it was explained. That is
        // not a distinction anybody writing Polaron can see or should have to. `classify` reads the
        // message the same way it does for a sema error that predates its own code.
        for (const polaron::CodegenError& e : codegen.errors()) {
            const std::string file(e.loc.file);
            std::fputs(polaron::diag::render("error", file, e.loc.line, e.loc.col, e.message,
                                          polaron::diag::classify(e.message),
                                          sourceLineAt(e.loc.file, e.loc.line), g_concise)
                           .c_str(),
                       stderr);
        }
        return 1;
    }
    // The merged vtable layout, for `--extract-code --remap-slots` to renumber each dependency into.
    // Written before optimization, since the layout is a fact about the module's shape and not about
    // what the passes do to it.
    if (!slotsOut.empty()) {
        std::ofstream sf(slotsOut, std::ios::binary);
        if (!sf) {
            std::fprintf(stderr, "error: cannot write '%s'\n", slotsOut.c_str());
            return 1;
        }
        for (const std::string& name : codegen.vtableSlotNames()) {
            sf << name << "\n";   // position IS the slot; an empty line is an unused one
        }
    }
    codegen.optimize(optLevel);  // polc's own optimization pipeline (no-op at -O0)

    if (libraryMode) {
        // Emit a self-describing .polb bundle plus a standalone .polh header. The bundle name is the
        // program name; versioning arrives with the manifest (F10 toolchain). CODE is bitcode so a
        // consumer can LTO it (static) or JIT it (dynamic).
        polaron::PolbBundle bundle;
        bundle.name = program.name;
        bundle.version = "0.0.0";
        // What built it, for the message a mismatch prints. `abiRevision` defaults to this compiler's
        // and is what the check actually tests -- the producer names the culprit, it does not judge it.
        bundle.producer = std::string(kVersion);
        if (program.isFreestanding) {
            bundle.flags |= polaron::PolbBundle::kFreestanding;
        }
        bundle.polh = polaron::generatePolh(program);
        bundle.fingerprint = polaron::polbFingerprint(bundle.polh);
        bundle.code = codegen.toBitcode();
        bundle.vtableSlots = codegen.vtableSlotNames();  // so consumers seed the same slot layout
        const std::string polbPath = outPath.empty() ? program.name + ".polb" : outPath;
        const std::string polhPath = polhPathFor(polbPath);
        std::ofstream polb(polbPath, std::ios::binary);
        if (!polb) {
            std::fprintf(stderr, "error: cannot write bundle file '%s'\n", polbPath.c_str());
            return 1;
        }
        polb << polaron::writePolb(bundle);
        std::ofstream polh(polhPath, std::ios::binary);
        if (!polh) {
            std::fprintf(stderr, "error: cannot write header file '%s'\n", polhPath.c_str());
            return 1;
        }
        polh << bundle.polh;
        std::printf("OK: bundle '%s' -> %s, %s\n", program.name.c_str(), polbPath.c_str(),
                    polhPath.c_str());
        return 0;
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
                 "error: this polc was built without the LLVM backend "
                 "(configure with -DPOLARON_WITH_LLVM=ON)\n");
    return 1;
#endif
}

}  // namespace

int main(int argc, char** argv) {
    const std::vector<std::string_view> args(argv + 1, argv + argc);
    if (args.empty()) {
        return printUsage(argv[0]);
    }

    if (args[0] == "--version" || args[0] == "-v") {
        std::printf("%s\n", kVersion.data());
        return 0;
    }

    // `--explain <code>`: the canonical write-up for a diagnostic code (why / how to fix / how to prevent),
    // the way `rustc --explain` works. With no code, list every code. `polaron explain <code>` forwards here.
    if (args[0] == "--explain") {
        if (args.size() < 2) {
            std::fputs(polaron::diag::allCodesListing().c_str(), stdout);
            return 0;
        }
        const std::string code(args[1]);
        const polaron::diag::Entry* e = polaron::diag::entryByCodeString(code);
        if (e == nullptr) {
            std::fprintf(stderr, "error: unknown diagnostic code '%s' (try `polc --explain` for a list)\n",
                         code.c_str());
            return 1;
        }
        std::printf("%s -- %.*s\n\n", code.c_str(), static_cast<int>(e->caret.size()), e->caret.data());
        std::printf("why:     %.*s\n\n", static_cast<int>(e->why.size()), e->why.data());
        std::printf("fix:     %.*s\n\n", static_cast<int>(e->fix.size()), e->fix.data());
        std::printf("prevent: %.*s\n", static_cast<int>(e->prevent.size()), e->prevent.data());
        return 0;
    }

    if (args[0] == "--dump-tokens" || args[0] == "--dump-ast") {
        if (args.size() < 2) {
            std::fprintf(stderr, "error: %.*s requires an input file\n",
                         static_cast<int>(args[0].size()), args[0].data());
            return printUsage(argv[0]);
        }
        const std::string path(args[1]);
        if (args[0] == "--dump-tokens") {
            return dumpTokens(path);
        }
        return dumpAst(path);
    }

    // `--check <file.pol>... [--lib] [--use <dep.polb>]... [--overlay <real>=<temp>]...`
    // The front end only: every diagnostic the compiler can produce without generating code. It takes the
    // same inputs a build does -- a program spans several files and sees its dependencies' headers -- so an
    // editor gets the SAME answer the build would give, in a fraction of the time.
    if (args[0] == "--check") {
        std::vector<std::string> inputs;
        std::vector<std::string> deps;
        bool libraryMode = false;
        // Same default as a real build, and the same switch. The editor's live check has to agree
        // with the compiler about what is an error -- a check that stays quiet and a build that then
        // fails is worse than either one alone.
        bool regionBinder = true;
        std::string foreignLibsOut;
        std::string cHeaderOut;
        for (std::size_t i = 1; i < args.size(); ++i) {
            if (args[i] == "--lib") {
                libraryMode = true;
            } else if (args[i].rfind("--emit-foreign-libs=", 0) == 0) {
                // Available here as well as on a build: the list is a front-end fact, and asking for it
                // should not cost a codegen.
                foreignLibsOut = std::string(args[i].substr(std::string("--emit-foreign-libs=").size()));
            } else if (args[i].rfind("--emit-c-header=", 0) == 0) {
                cHeaderOut = std::string(args[i].substr(std::string("--emit-c-header=").size()));
            } else if (args[i] == "--region-binder") {
                regionBinder = true;
            } else if (args[i] == "--no-region-binder") {
                regionBinder = false;
            } else if (args[i] == "--strict-regions") {
                polaron::SemanticAnalyzer::setStrictRegions(true);   // now the default; kept so old
                                                                    // scripts and build files still run
            } else if (args[i] == "--permissive-regions") {
                // ALLOW what cannot be placed, which is where this started and what it cost to leave.
                // A migration aid for a program written before the analysis could place its shapes:
                // while it is on the compiler finds bugs and states no guarantee.
                polaron::SemanticAnalyzer::setStrictRegions(false);
            } else if (args[i] == "--use" && i + 1 < args.size()) {
                deps.emplace_back(args[++i]);
            } else if (args[i] == "--overlay" && i + 1 < args.size()) {
                const std::string pair(args[++i]);
                const std::size_t eq = pair.rfind('=');  // rfind: a Windows path may hold no '=', the temp may
                if (eq == std::string::npos) {
                    std::fprintf(stderr, "error: --overlay expects <real>=<temp>\n");
                    return 2;
                }
                g_overlays[overlayKey(pair.substr(0, eq))] = pair.substr(eq + 1);
            } else if (args[i].rfind("--", 0) == 0) {
                std::fprintf(stderr, "error: unknown --check option '%.*s'\n",
                             static_cast<int>(args[i].size()), args[i].data());
                return 2;
            } else {
                inputs.emplace_back(args[i]);
            }
        }
        if (inputs.empty()) {
            std::fprintf(stderr, "error: --check requires an input file\n");
            return printUsage(argv[0]);
        }
        return compile(inputs, "", "", 0, libraryMode, deps, {}, false, false, {}, /*checkOnly=*/true,
                       regionBinder, /*verifyStack=*/false, foreignLibsOut, cHeaderOut);
    }

    if (args[0] == "--fmt") {  // re-format a file's whitespace (in place, or to -o)
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --fmt requires an input file\n");
            return printUsage(argv[0]);
        }
        std::string output;
        for (std::size_t i = 2; i + 1 < args.size(); ++i) {
            if (args[i] == "-o") {
                output = std::string(args[i + 1]);
            }
        }
        return fmtFile(std::string(args[1]), output);
    }

    if (args[0] == "--doc") {  // render a file's public API to HTML from its /// comments
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --doc requires an input file\n");
            return printUsage(argv[0]);
        }
        std::string output;
        for (std::size_t i = 2; i + 1 < args.size(); ++i) {
            if (args[i] == "-o") {
                output = std::string(args[i + 1]);
            }
        }
        return dumpDoc(std::string(args[1]), output);
    }

    if (args[0] == "--dump-polb") {  // inspect a .polb: print its header + embedded .polh
        if (args.size() < 2) {
            std::fprintf(stderr, "error: --dump-polb requires a .polb file\n");
            return printUsage(argv[0]);
        }
        return dumpPolb(std::string(args[1]));
    }

    // Compile mode: <input...> [-o <output>] [--lib] [--use <dep.polb> ...]. May span several files.
    std::vector<std::string> inputs;
    std::vector<std::string> deps;  // --use <dep.polb>: depended-on bundles to type-check/link against
    std::vector<std::string> dynDeps;  // --use-dynamic <dep.polb>: bundles loaded at runtime
    std::vector<std::string> remoteDeps;  // --use-remote <dep.polb>: spec 2.8, the code runs in ANOTHER
                                          // PROGRAM; the compiler synthesizes IPC proxies for its types
    std::string output;
    std::string extractFrom;  // --extract-code <dep.polb>: dump the bundle's CODE bitcode to -o
    std::string target;  // --target=<triple>, e.g. x86_64-unknown-none for freestanding/bare metal
    int optLevel = 0;    // -O0..-O3: run polc's own optimization pipeline before emitting IR
    bool libraryMode = false;  // --lib: compile a bundle to a .polb (+ .polh), no entry point required
    bool testMode = false;     // --test: emit a synthetic runner over the [Test] methods, not main
    bool debugInfo = false;    // -g: emit DWARF debug metadata (for @@LOW@@UPPLINGB@@@@ / the Forge debugger)
    // --verify-stack: every method checks that the stack pointer it returns on is the one it was called
    // on. Off by default because it costs two reads and a compare per call; see the flag's own comment
    // below for the fault that made it necessary.
    bool verifyStack = false;
    // ON by default: the static temporal-safety escape checks. It was opt-in for as long as it could
    // not tell a heap object from a stack one -- `Node* n = new Node(v) on heap; this.top = n;`, the
    // first two lines of every linked structure, was reported as a dangling store, so nobody could
    // have left it on. With that fixed the whole suite is green with it enabled, so the safe thing
    // is the default and the unsafe thing is `--no-region-binder`, spelled out loud.
    bool regionBinder = true;
    // --emit-foreign-libs=<path|->: the logical library names the program's classes declare, for the
    // driver to resolve through the manifest and put on the link line.
    std::string foreignLibsOut;
    // --emit-c-header=<path|->: the header a C or C++ caller needs for the methods this program
    // exports. The external world's counterpart to the .polh, which serves the closed one.
    std::string cHeaderOut;
    std::string slotsOut;     // --emit-vtable-slots=<path>: the merged vtable layout
    std::string remapSlots;   // --remap-slots=<path>: renumber an extracted bundle into that layout
    for (std::size_t i = 0; i < args.size(); ++i) {
        if (args[i] == "-o") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: -o requires an output path\n");
                return printUsage(argv[0]);
            }
            output = std::string(args[i + 1]);
            ++i;
        } else if (args[i] == "--lib") {
            libraryMode = true;
        } else if (args[i] == "--test") {
            testMode = true;
        } else if (args[i] == "--use") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use requires a .polb file\n");
                return printUsage(argv[0]);
            }
            deps.emplace_back(args[i + 1]);
            ++i;
        } else if (args[i] == "--use-remote") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use-remote requires a .polb file\n");
                return printUsage(argv[0]);
            }
            remoteDeps.emplace_back(args[i + 1]);
            ++i;
        } else if (args[i] == "--use-dynamic") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --use-dynamic requires a .polb file\n");
                return printUsage(argv[0]);
            }
            dynDeps.emplace_back(args[i + 1]);
            ++i;
        } else if (args[i] == "--extract-code") {
            if (i + 1 >= args.size()) {
                std::fprintf(stderr, "error: --extract-code requires a .polb file\n");
                return printUsage(argv[0]);
            }
            extractFrom = std::string(args[i + 1]);
            ++i;
        } else if (args[i].rfind("--target=", 0) == 0) {
            target = std::string(args[i].substr(9));
        } else if (args[i].rfind("--emit-foreign-libs=", 0) == 0) {
            foreignLibsOut = std::string(args[i].substr(std::string("--emit-foreign-libs=").size()));
        } else if (args[i].rfind("--emit-c-header=", 0) == 0) {
            cHeaderOut = std::string(args[i].substr(std::string("--emit-c-header=").size()));
        } else if (args[i].rfind("--emit-vtable-slots=", 0) == 0) {
            // The merged slot layout, for `--extract-code --remap-slots` to renumber each dependency
            // into. One name per line, position = slot; an empty line is an unused slot.
            slotsOut = std::string(args[i].substr(std::string("--emit-vtable-slots=").size()));
        } else if (args[i].rfind("--remap-slots=", 0) == 0) {
            remapSlots = std::string(args[i].substr(std::string("--remap-slots=").size()));
        } else if (args[i] == "--verify-stack") {
            // Make every method prove its own stack pointer survived its body.
            //
            // This exists because of a fault nothing else could locate: a stack slot came back holding
            // a return address, about one boot in twenty, if and only if an interrupt landed inside the
            // call being made at that moment. Every hand-placed probe moved it, and two days produced
            // clues and no cause. Only the compiler knows what the stack pointer is SUPPOSED to be at
            // each point -- and checking that is mechanical, not analysis. A displacement stops being a
            // mystery three hours downstream and becomes a named method at the moment it happens.
            verifyStack = true;
        } else if (args[i] == "-O" || args[i] == "-O2") {
            optLevel = 2;
        } else if (args[i] == "-O0") {
            optLevel = 0;
        } else if (args[i] == "-O1") {
            optLevel = 1;
        } else if (args[i] == "-O3") {
            optLevel = 3;
        } else if (args[i] == "-g") {
            debugInfo = true;
            optLevel = 0;  // debug info survives best unoptimized (variables, line stepping)
        } else if (args[i] == "--region-binder") {
            regionBinder = true;  // accepted and a no-op: it is the default. Kept so build scripts
                                  // written while it was opt-in keep working.
        } else if (args[i] == "--strict-regions") {
            polaron::SemanticAnalyzer::setStrictRegions(true);   // the default; kept for old scripts
        } else if (args[i] == "--permissive-regions") {
            polaron::SemanticAnalyzer::setStrictRegions(false);
        } else if (args[i] == "--no-region-binder") {
            // The escape hatch. There is no dialect of "safe" that lets you deliberately hand out a
            // pointer to a dead frame, so the way to do it is to turn the analysis off for the
            // program and mean it -- one flag, visible in the build, rather than a per-line
            // annotation that reads as ordinary code six months later.
            regionBinder = false;
        } else if (args[i] == "--concise" || args[i] == "-q") {
            g_concise = true;  // one machine-parseable line per diagnostic (CI / huge broken builds)
        } else {
            inputs.emplace_back(args[i]);
        }
    }
    if (!extractFrom.empty()) {
        return extractCode(extractFrom, output, remapSlots);  // dump CODE, renumbering if asked
    }
    if (inputs.empty()) {
        std::fprintf(stderr, "error: no input files\n");
        return printUsage(argv[0]);
    }
    return compile(inputs, output, target, optLevel, libraryMode, deps, dynDeps, testMode, debugInfo,
                   remoteDeps, /*checkOnly=*/false, regionBinder, verifyStack, foreignLibsOut,
                   cHeaderOut, slotsOut);
}
