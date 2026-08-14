#pragma once
#include <map>
#include <string>
#include <vector>
#include "lsp/json.h"

namespace polaron::lsp {

// One declaration found somewhere in the project. The workspace index holds these so definition,
// references and rename can answer about names declared in files the editor never opened.
struct IndexEntry {
    std::string name;
    std::string uri;
    int line = 0;   // 0-based, LSP style
    int col = 0;
    std::string detail;   // the declaration as it would be written -- what hover shows
};

// The Polaron language server: reads LSP (JSON-RPC over stdio, Content-Length framed) and answers with live
// lex/parse diagnostics, a document-symbol outline, keyword completion, go-to-definition, hover,
// references, rename, and an extract-method analysis, reusing the compiler's front-end.
class Server {
 public:
    int run();

 private:
    std::map<std::string, std::string> documents_;  // uri -> full text of an OPEN document
    std::vector<IndexEntry> index_;                 // declarations across the whole project
    std::vector<std::string> projectFiles_;         // every .pol found under the root
    std::string rootPath_;                          // filesystem path of the workspace root
    bool initialized_ = false;

    void handle(const Json& message);
    void publishDiagnostics(const std::string& uri);

    // Walk the workspace root and record every declaration. Built at initialize and refreshed on
    // save, so an edit in another file is eventually reflected.
    void buildIndex();
    // The text of `uri`: the open buffer when the editor has one (which may hold unsaved edits),
    // otherwise the file on disk. Answering an open file from its stale disk copy is the bug this
    // exists to avoid.
    std::string textFor(const std::string& uri) const;

    void writeMessage(const Json& message);
    void reply(const Json& id, Json result);
    void notify(const std::string& method, Json params);
};

}  // namespace polaron::lsp
