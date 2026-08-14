// polaron-lsp: the Polaron language server. Speaks LSP (JSON-RPC over stdio) and reuses the compiler's front-end
// for live diagnostics, a symbol outline and keyword completion.
#include "lsp/server.h"

int main() {
    polaron::lsp::Server server;
    return server.run();
}
