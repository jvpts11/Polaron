import * as vscode from 'vscode';
import * as fs from 'fs';
import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
  TransportKind,
} from 'vscode-languageclient/node';
import { polaronLspPath } from './tools';

let client: LanguageClient | undefined;

// Start the polaron-lsp language server and connect a client for Polaron documents. The server owns diagnostics,
// the document-symbol outline and completion. Returns false (so the caller can fall back to on-save
// diagnostics) if the server binary cannot be found.
export function startLanguageServer(context: vscode.ExtensionContext): boolean {
  const command = polaronLspPath();
  if (command !== 'polaron-lsp' && !fs.existsSync(command)) {
    return false;
  }

  const serverOptions: ServerOptions = {
    run: { command, transport: TransportKind.stdio },
    debug: { command, transport: TransportKind.stdio },
  };
  const clientOptions: LanguageClientOptions = {
    documentSelector: [{ scheme: 'file', language: 'polaron' }],
  };
  client = new LanguageClient('polaron-lsp', 'Polaron Language Server', serverOptions, clientOptions);
  void client.start();
  context.subscriptions.push({ dispose: () => void client?.stop() });
  return true;
}
