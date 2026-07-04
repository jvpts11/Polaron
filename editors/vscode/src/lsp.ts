import * as vscode from 'vscode';
import * as fs from 'fs';
import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
  TransportKind,
} from 'vscode-languageclient/node';
import { ldp3LspPath } from './tools';

let client: LanguageClient | undefined;

// Start the ldp3-lsp language server and connect a client for LDP3 documents. The server owns diagnostics,
// the document-symbol outline and completion. Returns false (so the caller can fall back to on-save
// diagnostics) if the server binary cannot be found.
export function startLanguageServer(context: vscode.ExtensionContext): boolean {
  const command = ldp3LspPath();
  if (command !== 'ldp3-lsp' && !fs.existsSync(command)) {
    return false;
  }

  const serverOptions: ServerOptions = {
    run: { command, transport: TransportKind.stdio },
    debug: { command, transport: TransportKind.stdio },
  };
  const clientOptions: LanguageClientOptions = {
    documentSelector: [{ scheme: 'file', language: 'ldp3' }],
  };
  client = new LanguageClient('ldp3-lsp', 'LDP3 Language Server', serverOptions, clientOptions);
  void client.start();
  context.subscriptions.push({ dispose: () => void client?.stop() });
  return true;
}
