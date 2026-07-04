// ldp3-lsp: the LDP3 language server. Speaks LSP (JSON-RPC over stdio) and reuses the compiler's front-end
// for live diagnostics, a symbol outline and keyword completion.
#include "lsp/server.h"

int main() {
    ldp3::lsp::Server server;
    return server.run();
}
