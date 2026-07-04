#pragma once
#include <map>
#include <string>
#include "lsp/json.h"

namespace ldp3::lsp {

// The LDP3 language server: reads LSP (JSON-RPC over stdio, Content-Length framed) and answers with live
// lex/parse diagnostics, a document-symbol outline and keyword completion, reusing the compiler's front-end.
// (Deeper, semantic answers need the prelude available as a library -- see the design notes.)
class Server {
 public:
    int run();

 private:
    std::map<std::string, std::string> documents_;  // uri -> full text
    bool initialized_ = false;

    void handle(const Json& message);
    void publishDiagnostics(const std::string& uri);

    void writeMessage(const Json& message);
    void reply(const Json& id, Json result);
    void notify(const std::string& method, Json params);
};

}  // namespace ldp3::lsp
