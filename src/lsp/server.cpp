#include "lsp/server.h"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

#include "lexer/lexer.h"
#include "parser/ast.h"
#include "parser/parser.h"

#if defined(_WIN32)
#include <fcntl.h>
#include <io.h>
#endif

namespace ldp3::lsp {
namespace {

Json position(int line, int character) {
    Json p = Json::makeObject();
    p.set("line", Json::of(line));
    p.set("character", Json::of(character));
    return p;
}

Json range(int line, int col, int endCol) {
    Json r = Json::makeObject();
    r.set("start", position(line, col));
    r.set("end", position(line, endCol));
    return r;
}

// LSP is 0-based; the compiler's locations are 1-based.
Json pointRange(const SourceLocation& loc, int width) {
    const int line = loc.line > 0 ? loc.line - 1 : 0;
    const int col = loc.col > 0 ? loc.col - 1 : 0;
    return range(line, col, col + width);
}

Json diagnostic(const SourceLocation& loc, const std::string& message) {
    Json d = Json::makeObject();
    d.set("range", pointRange(loc, 1));
    d.set("severity", Json::of(1));  // Error
    d.set("source", Json::of(std::string("ldp3")));
    d.set("message", Json::of(message));
    return d;
}

// LSP SymbolKind values.
constexpr int kNamespace = 3;
constexpr int kClass = 5;
constexpr int kMethod = 6;
constexpr int kField = 8;
constexpr int kEnum = 10;
constexpr int kInterface = 11;

Json symbol(const std::string& name, int kind, const SourceLocation& loc, Json children) {
    Json s = Json::makeObject();
    s.set("name", name.empty() ? Json::of(std::string("?")) : Json::of(name));
    s.set("kind", Json::of(kind));
    Json r = pointRange(loc, static_cast<int>(name.size()) + 1);
    s.set("range", r);
    s.set("selectionRange", r);
    if (children.type == Json::Type::Array && !children.arr.empty()) s.set("children", std::move(children));
    return s;
}

Json classSymbol(const ast::ClassDecl& c) {
    Json members = Json::makeArray();
    for (const ast::MemberPtr& mp : c.members) {
        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
            members.push(symbol(m->name, kMethod, m->loc, Json::makeArray()));
        } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get())) {
            members.push(symbol(f->name, kField, f->loc, Json::makeArray()));
        }
    }
    const int kind = c.isInterface ? kInterface : kClass;
    return symbol(c.name, kind, c.loc, std::move(members));
}

Json documentSymbols(const ast::Program& program) {
    Json out = Json::makeArray();
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            Json children = Json::makeArray();
            for (const ast::ClassDecl& c : ns.classes) children.push(classSymbol(c));
            for (const ast::EnumDecl& e : ns.enums) children.push(symbol(e.name, kEnum, e.loc, Json::makeArray()));
            out.push(symbol(ns.name, kNamespace, ns.loc, std::move(children)));
        }
    }
    return out;
}

// --- go-to-definition and hover -----------------------------------------------------------------
// Both answer the same question -- "what is the name under the cursor?" -- so they share one lookup
// over the parsed file. This resolves against the AST rather than by matching text, so it lands on a
// declaration rather than on the next occurrence of the same word.
//
// SCOPE: the current document only. Resolving across files needs a project-wide index that this
// server does not build yet, so a name declared elsewhere returns nothing and the editor falls back
// to its own textual search.

bool isIdentChar(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_';
}

// The identifier at (line, character) in `text`, both 0-based, or "" when the cursor is not on one.
std::string wordAt(const std::string& text, int line, int character) {
    std::size_t pos = 0;
    for (int l = 0; l < line; ++l) {
        const std::size_t nl = text.find('\n', pos);
        if (nl == std::string::npos) return "";
        pos = nl + 1;
    }
    const std::size_t lineEnd = text.find('\n', pos);
    const std::string row = text.substr(pos, lineEnd == std::string::npos ? std::string::npos
                                                                          : lineEnd - pos);
    if (character < 0 || static_cast<std::size_t>(character) > row.size()) return "";
    std::size_t start = static_cast<std::size_t>(character);
    // A cursor just past the end of a word should still find it, which is where a click usually lands.
    if (start > 0 && (start == row.size() || !isIdentChar(row[start]))) --start;
    if (start >= row.size() || !isIdentChar(row[start])) return "";
    std::size_t end = start;
    while (start > 0 && isIdentChar(row[start - 1])) --start;
    while (end + 1 < row.size() && isIdentChar(row[end + 1])) ++end;
    return row.substr(start, end - start + 1);
}

std::string typeText(const ast::TypeRef& t) {
    std::string s = t.name;
    if (t.arrayElemPointer) s += "*";
    for (int i = 0; i < t.arrayDims; ++i) s += "[]";
    if (t.isPointer) s += "*";
    if (t.doublePointer) s += "*";
    if (t.isRef) s += "&";
    if (t.isNullable) s = "nullable " + s;
    return s;
}

// The declaration line, as it would be written -- what hover shows.
std::string methodSignature(const ast::ClassDecl& c, const ast::MethodDecl& m) {
    std::string s;
    if (!m.visibility.empty()) s += m.visibility + " ";
    if (m.isStatic) s += "static ";
    if (m.isAbstract) s += "abstract ";
    s += "method " + c.name + "." + m.name + "(";
    for (std::size_t i = 0; i < m.params.size(); ++i) {
        if (i > 0) s += ", ";
        s += typeText(m.params[i].type) + " " + m.params[i].name;
    }
    s += ") returns " + typeText(m.returnType);
    return s;
}

std::string fieldSignature(const ast::ClassDecl& c, const ast::FieldDecl& f) {
    std::string s;
    if (!f.visibility.empty()) s += f.visibility + " ";
    if (f.isStatic) s += "static ";
    if (f.isMutable) s += "mutable ";
    s += typeText(f.type) + " " + c.name + "." + f.name;
    return s;
}

// Where `name` is declared in this program, and how to describe it. Found is false when the name is
// not declared here (a local, an import, or something in another file).
struct Found {
    bool found = false;
    SourceLocation loc;
    std::string detail;
    std::size_t width = 1;
};

// A declaration's `loc` marks where the declaration STARTS (the `method` or `class` keyword), not
// where its name is. Highlighting that span would underline the wrong word, so the column is nudged
// to the name itself when it can be found on that line.
void aimAtName(const std::string& text, const std::string& name, Found& hit) {
    if (!hit.found || name.empty()) return;
    std::size_t pos = 0;
    for (int l = 1; l < hit.loc.line; ++l) {
        const std::size_t nl = text.find('\n', pos);
        if (nl == std::string::npos) return;
        pos = nl + 1;
    }
    const std::size_t lineEnd = text.find('\n', pos);
    const std::string row = text.substr(pos, lineEnd == std::string::npos ? std::string::npos
                                                                          : lineEnd - pos);
    const std::size_t at = row.find(name);
    if (at != std::string::npos) hit.loc.col = static_cast<int>(at) + 1;   // locations are 1-based
}

Found findDeclaration(const ast::Program& program, const std::string& name) {
    Found out;
    if (name.empty()) return out;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                if (c.name == name) {
                    out.found = true;
                    out.loc = c.loc;
                    out.detail = std::string(c.isInterface ? "interface " : "class ") + c.name;
                    out.width = c.name.size();
                    return out;
                }
                for (const ast::MemberPtr& mp : c.members) {
                    if (const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
                        if (m->name == name) {
                            out.found = true;
                            out.loc = m->loc;
                            out.detail = methodSignature(c, *m);
                            out.width = m->name.size();
                            return out;
                        }
                    } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get())) {
                        if (f->name == name) {
                            out.found = true;
                            out.loc = f->loc;
                            out.detail = fieldSignature(c, *f);
                            out.width = f->name.size();
                            return out;
                        }
                    }
                }
            }
            for (const ast::EnumDecl& e : ns.enums) {
                if (e.name == name) {
                    out.found = true;
                    out.loc = e.loc;
                    out.detail = "enum " + e.name;
                    out.width = e.name.size();
                    return out;
                }
            }
        }
    }
    return out;
}

// --- extract method -----------------------------------------------------------------------------
// Pulling lines out into a method is only safe if the new signature is right, and that needs types:
// a body using locals needs them as typed parameters, and a local it assigns that is read afterwards
// has to come back as the return value. The server has the parsed method, so it knows those types --
// which is exactly what an editor guessing from text cannot do.
//
// Types come from the AST; which names the selection actually uses is decided by scanning the
// selected text. That mix is deliberate: walking every expression to collect uses would be a lot of
// code for little gain, and over-reporting a use only adds a parameter that is passed and ignored,
// which still compiles. Under-reporting a TYPE would produce code that does not, so types are never
// guessed.

struct ExtractParam {
    std::string name;
    std::string type;
};

struct ExtractPlan {
    bool ok = false;
    std::string reason;                  // why not, when !ok -- shown to the user
    std::vector<ExtractParam> params;
    std::string returnType = "void";
    std::string returnName;              // the local handed back, when there is one
};

// Does `name` appear as a whole identifier anywhere in `text`?
bool mentions(const std::string& text, const std::string& name) {
    if (name.empty()) return false;
    std::size_t at = text.find(name);
    while (at != std::string::npos) {
        const bool leftOk = at == 0 || !isIdentChar(text[at - 1]);
        const std::size_t end = at + name.size();
        const bool rightOk = end >= text.size() || !isIdentChar(text[end]);
        if (leftOk && rightOk) return true;
        at = text.find(name, at + 1);
    }
    return false;
}

// The [first, last] lines of `text`, 1-based and inclusive.
std::string linesOf(const std::string& text, int first, int last) {
    std::string out;
    int line = 1;
    std::size_t pos = 0;
    while (pos <= text.size() && line <= last) {
        const std::size_t nl = text.find('\n', pos);
        const std::string row = text.substr(pos, nl == std::string::npos ? std::string::npos
                                                                         : nl - pos);
        if (line >= first) out += row + "\n";
        if (nl == std::string::npos) break;
        pos = nl + 1;
        ++line;
    }
    return out;
}

// Work out the signature for extracting [startLine, endLine] (1-based) out of whichever method
// contains them.
ExtractPlan planExtraction(const ast::Program& program, const std::string& text, int startLine,
                           int endLine) {
    ExtractPlan plan;
    const ast::MethodDecl* owner = nullptr;
    const ast::ClassDecl* ownerClass = nullptr;
    int ownerEnd = 0;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                for (const ast::MemberPtr& mp : c.members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get());
                    if (m == nullptr || m->body.statements.empty()) continue;
                    const int first = m->loc.line;
                    int last = first;
                    for (const ast::StmtPtr& s : m->body.statements) {
                        if (s && s->loc.line > last) last = s->loc.line;
                    }
                    if (startLine >= first && endLine <= last + 1) {
                        owner = m;
                        ownerClass = &c;
                        ownerEnd = last + 1;
                    }
                }
            }
        }
    }
    if (owner == nullptr) {
        plan.reason = "the selection is not inside a method body";
        return plan;
    }

    const std::string selected = linesOf(text, startLine, endLine);
    const std::string after = linesOf(text, endLine + 1, ownerEnd);

    // Anything in scope before the selection and used inside it becomes a parameter: the method's
    // own parameters first, then locals declared above the selection.
    for (const ast::Param& p : owner->params) {
        if (mentions(selected, p.name)) plan.params.push_back({p.name, typeText(p.type)});
    }
    for (const ast::StmtPtr& s : owner->body.statements) {
        const auto* v = dynamic_cast<const ast::VarDeclStmt*>(s.get());
        if (v == nullptr) continue;
        if (v->loc.line >= startLine) continue;                 // declared after: not in scope yet
        if (!mentions(selected, v->name)) continue;
        if (v->isVar) {
            // `var` records no type, and a parameter cannot be `var`. Refusing beats emitting a
            // signature that does not compile.
            plan.reason = "cannot extract: '" + v->name +
                          "' is declared with var, so its type is not written down";
            return plan;
        }
        plan.params.push_back({v->name, typeText(v->type)});
    }

    // A local declared inside the selection and still read afterwards has to be returned.
    std::vector<ExtractParam> escaping;
    for (const ast::StmtPtr& s : owner->body.statements) {
        const auto* v = dynamic_cast<const ast::VarDeclStmt*>(s.get());
        if (v == nullptr) continue;
        if (v->loc.line < startLine || v->loc.line > endLine) continue;
        if (!mentions(after, v->name)) continue;
        if (v->isVar) {
            plan.reason = "cannot extract: '" + v->name +
                          "' is declared with var and is used after the selection";
            return plan;
        }
        escaping.push_back({v->name, typeText(v->type)});
    }
    if (escaping.size() > 1) {
        plan.reason = "cannot extract: the selection defines " + std::to_string(escaping.size()) +
                      " values used afterwards, and a method returns one";
        return plan;
    }
    if (escaping.size() == 1) {
        plan.returnType = escaping[0].type;
        plan.returnName = escaping[0].name;
    }
    plan.ok = true;
    (void)ownerClass;
    return plan;
}

// --- workspace: uri <-> path, and reading files off disk ----------------------------------------
// Editors send file:// URIs; the index walks the filesystem. Percent-escapes are decoded because a
// project path containing a space arrives as %20 and would otherwise never be found.

std::string uriToPath(const std::string& uri) {
    std::string s = uri;
    const std::string prefix = "file:///";
    if (s.compare(0, prefix.size(), prefix) == 0) {
        s = s.substr(prefix.size());
    } else if (s.compare(0, 7, "file://") == 0) {
        s = s.substr(7);
    }
    std::string out;
    for (std::size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '%' && i + 2 < s.size()) {
            const std::string hex = s.substr(i + 1, 2);
            try {
                out += static_cast<char>(std::stoi(hex, nullptr, 16));
                i += 2;
                continue;
            } catch (...) {
                // not a valid escape: fall through and keep the '%'
            }
        }
        out += s[i];
    }
    return out;
}

std::string pathToUri(const std::string& path) {
    std::string s = path;
    for (char& c : s) {
        if (c == '\\') c = '/';
    }
    return "file:///" + s;
}

std::string readFile(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) return "";
    std::ostringstream ss;
    ss << in.rdbuf();
    return ss.str();
}

// Every whole-word occurrence of `name` in `text`, as {line, col} pairs (0-based).
// Occurrences inside a line comment are skipped, because renaming a word in prose is not a rename;
// string literals are NOT skipped here, since the caller decides whether those matter.
std::vector<std::pair<int, int>> occurrences(const std::string& text, const std::string& name) {
    std::vector<std::pair<int, int>> out;
    if (name.empty()) return out;
    int line = 0;
    std::size_t pos = 0;
    while (pos <= text.size()) {
        const std::size_t nl = text.find('\n', pos);
        const std::string row = text.substr(pos, nl == std::string::npos ? std::string::npos
                                                                        : nl - pos);
        const std::size_t comment = row.find("//");
        std::size_t at = row.find(name);
        while (at != std::string::npos) {
            const bool leftOk = at == 0 || !isIdentChar(row[at - 1]);
            const std::size_t end = at + name.size();
            const bool rightOk = end >= row.size() || !isIdentChar(row[end]);
            if (leftOk && rightOk && (comment == std::string::npos || at < comment)) {
                out.push_back({line, static_cast<int>(at)});
            }
            at = row.find(name, at + 1);
        }
        if (nl == std::string::npos) break;
        pos = nl + 1;
        ++line;
    }
    return out;
}

const char* const kKeywords[] = {
    "program", "bundle", "namespace", "class", "interface", "struct", "record", "union", "enum", "catalog",
    "method", "constructor", "destructor", "returns", "return", "public", "private", "protected", "internal",
    "static", "abstract", "final", "override", "mutable", "nullable", "sealed", "permits", "extends",
    "implements", "this", "super", "var", "new", "delete", "on", "in", "is", "as", "cast", "move", "region",
    "defer", "using", "synchronized", "async", "await", "extern", "import", "if", "else", "while", "do", "for",
    "switch", "match", "case", "default", "break", "continue", "step", "try", "catch", "finally", "throw",
    "throws", "comptime", "void", "boolean", "char", "string", "String", "int", "int8", "int16", "int32",
    "int64", "uint8", "uint16", "uint32", "uint64", "short", "long", "byte", "float", "double", "true", "false",
    "null",
};

Json keywordCompletion() {
    Json items = Json::makeArray();
    for (const char* kw : kKeywords) {
        Json item = Json::makeObject();
        item.set("label", Json::of(std::string(kw)));
        item.set("kind", Json::of(14));  // Keyword
        items.push(std::move(item));
    }
    return items;
}

std::string uriOf(const Json& params) {
    const Json* td = params.get("textDocument");
    return td ? td->getString("uri") : std::string();
}

}  // namespace

void Server::writeMessage(const Json& message) {
    const std::string body = message.dump();
    std::cout << "Content-Length: " << body.size() << "\r\n\r\n" << body;
    std::cout.flush();
}

void Server::reply(const Json& id, Json result) {
    Json msg = Json::makeObject();
    msg.set("jsonrpc", Json::of(std::string("2.0")));
    msg.set("id", id);
    msg.set("result", std::move(result));
    writeMessage(msg);
}

void Server::notify(const std::string& method, Json params) {
    Json msg = Json::makeObject();
    msg.set("jsonrpc", Json::of(std::string("2.0")));
    msg.set("method", Json::of(method));
    msg.set("params", std::move(params));
    writeMessage(msg);
}

// An open buffer wins over the file on disk: it may hold edits that were never saved, and answering
// from the stale copy is how a language server tells you about code you already changed.
std::string Server::textFor(const std::string& uri) const {
    const auto it = documents_.find(uri);
    if (it != documents_.end()) return it->second;
    return readFile(uriToPath(uri));
}

// Walk the workspace and record every declaration, so definition, references and rename can answer
// about files the editor never opened. Parsing every file is affordable because it happens at
// startup and on save, not per keystroke.
void Server::buildIndex() {
    index_.clear();
    projectFiles_.clear();
    if (rootPath_.empty()) return;
    std::error_code ec;
    const std::filesystem::path root(rootPath_);
    if (!std::filesystem::is_directory(root, ec)) return;
    for (auto it = std::filesystem::recursive_directory_iterator(
             root, std::filesystem::directory_options::skip_permission_denied, ec);
         it != std::filesystem::recursive_directory_iterator(); it.increment(ec)) {
        if (ec) break;
        const std::filesystem::path& p = it->path();
        // Skip build output and version control: their contents are generated or irrelevant, and a
        // staged copy of the whole project would double every result.
        const std::string name = p.filename().string();
        if (it->is_directory(ec) &&
            (name == ".git" || name == "build" || name == "build-output" || name == "dist" ||
             name == "node_modules")) {
            it.disable_recursion_pending();
            continue;
        }
        if (!it->is_regular_file(ec) || p.extension() != ".ldp3") continue;
        const std::string path = p.string();
        const std::string uri = pathToUri(path);
        projectFiles_.push_back(uri);
        const std::string text = textFor(uri);
        if (text.empty()) continue;
        Lexer lexer(text, uri);
        Parser parser(lexer.tokenize(), uri);
        const ast::Program program = parser.parse();
        for (const ast::Bundle& bundle : program.bundles) {
            for (const ast::Namespace& ns : bundle.namespaces) {
                for (const ast::ClassDecl& c : ns.classes) {
                    Found hit;
                    hit.found = true;
                    hit.loc = c.loc;
                    hit.detail = std::string(c.isInterface ? "interface " : "class ") + c.name;
                    aimAtName(text, c.name, hit);
                    index_.push_back({c.name, uri, hit.loc.line - 1, hit.loc.col - 1, hit.detail});
                    for (const ast::MemberPtr& mp : c.members) {
                        if (const auto* m = dynamic_cast<const ast::MethodDecl*>(mp.get())) {
                            Found mh;
                            mh.found = true;
                            mh.loc = m->loc;
                            mh.detail = methodSignature(c, *m);
                            aimAtName(text, m->name, mh);
                            index_.push_back({m->name, uri, mh.loc.line - 1, mh.loc.col - 1,
                                              mh.detail});
                        } else if (const auto* f = dynamic_cast<const ast::FieldDecl*>(mp.get())) {
                            Found fh;
                            fh.found = true;
                            fh.loc = f->loc;
                            fh.detail = fieldSignature(c, *f);
                            aimAtName(text, f->name, fh);
                            index_.push_back({f->name, uri, fh.loc.line - 1, fh.loc.col - 1,
                                              fh.detail});
                        }
                    }
                }
                for (const ast::EnumDecl& e : ns.enums) {
                    Found eh;
                    eh.found = true;
                    eh.loc = e.loc;
                    eh.detail = "enum " + e.name;
                    aimAtName(text, e.name, eh);
                    index_.push_back({e.name, uri, eh.loc.line - 1, eh.loc.col - 1, eh.detail});
                }
            }
        }
    }
}

void Server::publishDiagnostics(const std::string& uri) {
    const std::string& text = documents_[uri];
    Json diags = Json::makeArray();

    Lexer lexer(text, uri);
    std::vector<Token> tokens = lexer.tokenize();
    for (const LexError& e : lexer.errors()) diags.push(diagnostic(e.loc, e.message));
    Parser parser(std::move(tokens), uri);
    parser.parse();
    for (const ParseError& e : parser.errors()) diags.push(diagnostic(e.loc, e.message));

    Json params = Json::makeObject();
    params.set("uri", Json::of(uri));
    params.set("diagnostics", std::move(diags));
    notify("textDocument/publishDiagnostics", std::move(params));
}

void Server::handle(const Json& message) {
    const std::string method = message.getString("method");
    const Json* idPtr = message.get("id");
    const Json* paramsPtr = message.get("params");
    const Json params = paramsPtr ? *paramsPtr : Json::makeObject();

    if (method == "initialize") {
        Json caps = Json::makeObject();
        caps.set("textDocumentSync", Json::of(1));  // Full
        caps.set("documentSymbolProvider", Json::of(true));
        caps.set("definitionProvider", Json::of(true));
        caps.set("hoverProvider", Json::of(true));
        caps.set("referencesProvider", Json::of(true));
        caps.set("renameProvider", Json::of(true));
        Json completion = Json::makeObject();
        caps.set("completionProvider", std::move(completion));
        Json result = Json::makeObject();
        result.set("capabilities", std::move(caps));
        // The workspace root makes cross-file answers possible: without it the server can only
        // speak about documents the editor happens to have open.
        const std::string rootUri = params.getString("rootUri");
        if (!rootUri.empty()) {
            rootPath_ = uriToPath(rootUri);
        } else {
            const std::string rootPath = params.getString("rootPath");
            if (!rootPath.empty()) rootPath_ = rootPath;
        }
        if (idPtr) reply(*idPtr, std::move(result));
        initialized_ = true;
        buildIndex();
        return;
    }
    if (method == "shutdown") {
        if (idPtr) reply(*idPtr, Json{});
        return;
    }
    if (method == "textDocument/didOpen") {
        const Json* td = params.get("textDocument");
        if (td) {
            const std::string uri = td->getString("uri");
            documents_[uri] = td->getString("text");
            publishDiagnostics(uri);
        }
        return;
    }
    if (method == "textDocument/didChange") {
        const std::string uri = uriOf(params);
        const Json* changes = params.get("contentChanges");
        if (!uri.empty() && changes && changes->type == Json::Type::Array && !changes->arr.empty()) {
            documents_[uri] = changes->arr.back().getString("text");  // Full sync: last change is the text
            publishDiagnostics(uri);
        }
        return;
    }
    if (method == "textDocument/didSave") {
        buildIndex();          // a saved edit may have added or renamed a declaration
        return;
    }
    if (method == "textDocument/didClose") {
        const std::string uri = uriOf(params);
        documents_.erase(uri);
        Json p = Json::makeObject();
        p.set("uri", Json::of(uri));
        p.set("diagnostics", Json::makeArray());
        notify("textDocument/publishDiagnostics", std::move(p));
        return;
    }
    if (method == "textDocument/documentSymbol") {
        const std::string uri = uriOf(params);
        Lexer lexer(documents_[uri], uri);
        Parser parser(lexer.tokenize(), uri);
        const ast::Program program = parser.parse();
        if (idPtr) reply(*idPtr, documentSymbols(program));
        return;
    }
    if (method == "textDocument/completion") {
        if (idPtr) reply(*idPtr, keywordCompletion());
        return;
    }
    // A Forge extension, not standard LSP: given a line range, say what the extracted method's
    // signature has to be. The editor cannot work this out, because it does not know the types.
    if (method == "ldp3/extractMethod") {
        const std::string uri = uriOf(params);
        if (!idPtr) return;
        if (documents_.find(uri) == documents_.end()) {
            reply(*idPtr, Json{});
            return;
        }
        const std::string& text = documents_[uri];
        Lexer lexer(text, uri);
        Parser parser(lexer.tokenize(), uri);
        const ast::Program program = parser.parse();
        const ExtractPlan plan = planExtraction(program, text, params.getInt("startLine"),
                                                params.getInt("endLine"));
        Json result = Json::makeObject();
        result.set("ok", Json::of(plan.ok));
        if (!plan.ok) {
            result.set("reason", Json::of(plan.reason));
            reply(*idPtr, std::move(result));
            return;
        }
        Json ps = Json::makeArray();
        std::string paramList;
        std::string argList;
        for (std::size_t i = 0; i < plan.params.size(); ++i) {
            Json p = Json::makeObject();
            p.set("name", Json::of(plan.params[i].name));
            p.set("type", Json::of(plan.params[i].type));
            ps.push(std::move(p));
            if (i > 0) {
                paramList += ", ";
                argList += ", ";
            }
            paramList += plan.params[i].type + " " + plan.params[i].name;
            argList += plan.params[i].name;
        }
        result.set("params", std::move(ps));
        result.set("paramList", Json::of(paramList));
        result.set("argList", Json::of(argList));
        result.set("returnType", Json::of(plan.returnType));
        result.set("returnName", Json::of(plan.returnName));
        reply(*idPtr, std::move(result));
        return;
    }
    // references and rename both need every occurrence of the name across the project, so they share
    // the same sweep and differ only in what they return.
    if (method == "textDocument/references" || method == "textDocument/rename") {
        const std::string uri = uriOf(params);
        const Json* posPtr = params.get("position");
        if (!idPtr) return;
        if (!posPtr) {
            reply(*idPtr, Json{});
            return;
        }
        const std::string name = wordAt(textFor(uri), posPtr->getInt("line"),
                                        posPtr->getInt("character"));
        if (name.empty()) {
            reply(*idPtr, Json{});
            return;
        }
        // Every project file, plus the current one even when it sits outside the indexed root.
        std::vector<std::string> files = projectFiles_;
        bool haveCurrent = false;
        for (const std::string& f : files) {
            if (f == uri) haveCurrent = true;
        }
        if (!haveCurrent) files.push_back(uri);

        if (method == "textDocument/references") {
            Json out = Json::makeArray();
            for (const std::string& f : files) {
                const std::string body = textFor(f);
                for (const auto& [line, col] : occurrences(body, name)) {
                    Json loc = Json::makeObject();
                    loc.set("uri", Json::of(f));
                    loc.set("range", range(line, col, col + static_cast<int>(name.size())));
                    out.push(std::move(loc));
                }
            }
            reply(*idPtr, std::move(out));
            return;
        }

        // rename: a WorkspaceEdit grouping the edits per file. The editor applies them atomically,
        // which is why this returns edits rather than writing files itself.
        const std::string newName = params.getString("newName");
        if (newName.empty()) {
            reply(*idPtr, Json{});
            return;
        }
        Json changes = Json::makeObject();
        for (const std::string& f : files) {
            const std::string body = textFor(f);
            const auto hits = occurrences(body, name);
            if (hits.empty()) continue;
            Json edits = Json::makeArray();
            for (const auto& [line, col] : hits) {
                Json e = Json::makeObject();
                e.set("range", range(line, col, col + static_cast<int>(name.size())));
                e.set("newText", Json::of(newName));
                edits.push(std::move(e));
            }
            changes.set(f, std::move(edits));
        }
        Json result = Json::makeObject();
        result.set("changes", std::move(changes));
        reply(*idPtr, std::move(result));
        return;
    }
    if (method == "textDocument/definition" || method == "textDocument/hover") {
        const std::string uri = uriOf(params);
        const Json* posPtr = params.get("position");
        if (!idPtr) return;
        if (!posPtr || documents_.find(uri) == documents_.end()) {
            reply(*idPtr, Json{});
            return;
        }
        const std::string& text = documents_[uri];
        const std::string name = wordAt(text, posPtr->getInt("line"), posPtr->getInt("character"));
        Lexer lexer(text, uri);
        Parser parser(lexer.tokenize(), uri);
        const ast::Program program = parser.parse();
        Found hit = findDeclaration(program, name);
        aimAtName(text, name, hit);
        // Declared in this file? Answer from it. Otherwise consult the workspace index, which is
        // what makes go-to-definition work across files.
        std::string targetUri = uri;
        int targetLine = hit.loc.line - 1;
        int targetCol = hit.loc.col - 1;
        std::string detail = hit.detail;
        std::size_t width = hit.width;
        if (!hit.found) {
            const IndexEntry* found = nullptr;
            for (const IndexEntry& e : index_) {
                if (e.name == name) {
                    found = &e;
                    break;
                }
            }
            if (found == nullptr) {
                reply(*idPtr, Json{});   // null: the client falls back to its own search
                return;
            }
            targetUri = found->uri;
            targetLine = found->line;
            targetCol = found->col;
            detail = found->detail;
            width = name.size();
        }
        if (method == "textDocument/definition") {
            Json loc = Json::makeObject();
            loc.set("uri", Json::of(targetUri));
            loc.set("range", range(targetLine, targetCol, targetCol + static_cast<int>(width)));
            reply(*idPtr, std::move(loc));
            return;
        }
        // `detail` -- not hit.detail -- because the declaration may have come from the index rather
        // than from this file, in which case hit is empty and hovering would show a blank box.
        Json contents = Json::makeObject();
        contents.set("kind", Json::of(std::string("markdown")));
        contents.set("value", Json::of("```ldp3\n" + detail + "\n```"));
        Json result = Json::makeObject();
        result.set("contents", std::move(contents));
        result.set("range", range(targetLine, targetCol, targetCol + static_cast<int>(width)));
        reply(*idPtr, std::move(result));
        return;
    }
    // Unknown request: reply null so the client is not left waiting.
    if (idPtr) reply(*idPtr, Json{});
}

int Server::run() {
#if defined(_WIN32)
    _setmode(_fileno(stdin), _O_BINARY);
    _setmode(_fileno(stdout), _O_BINARY);
#endif
    while (true) {
        std::size_t contentLength = 0;
        std::string line;
        bool sawHeader = false;
        while (std::getline(std::cin, line)) {
            if (!line.empty() && line.back() == '\r') line.pop_back();
            if (line.empty()) break;  // blank line ends the headers
            sawHeader = true;
            const std::string prefix = "Content-Length:";
            if (line.compare(0, prefix.size(), prefix) == 0) {
                try {
                    contentLength = std::stoul(line.substr(prefix.size()));
                } catch (...) {
                    contentLength = 0;
                }
            }
        }
        if (!std::cin.good() && !sawHeader) break;  // EOF
        if (contentLength == 0) continue;

        std::string body(contentLength, '\0');
        std::cin.read(body.data(), static_cast<std::streamsize>(contentLength));
        if (static_cast<std::size_t>(std::cin.gcount()) != contentLength) break;

        Json message;
        if (!Json::parse(body, message)) continue;
        const std::string method = message.getString("method");
        if (method == "exit") break;
        handle(message);
    }
    return 0;
}

}  // namespace ldp3::lsp
