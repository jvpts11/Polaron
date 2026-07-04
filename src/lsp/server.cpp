#include "lsp/server.h"

#include <iostream>
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
        Json completion = Json::makeObject();
        caps.set("completionProvider", std::move(completion));
        Json result = Json::makeObject();
        result.set("capabilities", std::move(caps));
        if (idPtr) reply(*idPtr, std::move(result));
        initialized_ = true;
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
