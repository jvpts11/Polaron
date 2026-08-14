import * as vscode from 'vscode';
import * as path from 'path';
import { polcPath, run } from './tools';

// A diagnostic line from `polc --check`, e.g. `C:\...\file.pol:3:65: parse error: expected an expression`.
// The non-greedy path segment stops at the first `:<line>:<col>:` (a Windows drive `C:` has no digits after
// its colon, so it is not mistaken for a location).
const DIAGNOSTIC = /^(.*?):(\d+):(\d+):\s*(.*)$/;

// On save/open, run the compiler in check mode over the file and surface its errors in the Problems panel.
// (Phase 5's language server replaces this with live, in-memory diagnostics.)
export function registerDiagnostics(context: vscode.ExtensionContext): void {
  const collection = vscode.languages.createDiagnosticCollection('polaron');
  context.subscriptions.push(collection);

  async function check(document: vscode.TextDocument): Promise<void> {
    if (document.languageId !== 'polaron' || document.uri.scheme !== 'file') {
      return;
    }
    const file = document.uri.fsPath;
    const { out } = await run(polcPath(), ['--check', file], path.dirname(file));
    const diagnostics: vscode.Diagnostic[] = [];
    for (const line of out.split(/\r?\n/)) {
      const m = DIAGNOSTIC.exec(line);
      if (!m) {
        continue;
      }
      const ln = Math.max(0, parseInt(m[2], 10) - 1);
      const col = Math.max(0, parseInt(m[3], 10) - 1);
      const range = new vscode.Range(ln, col, ln, col + 1);
      diagnostics.push(new vscode.Diagnostic(range, m[4], vscode.DiagnosticSeverity.Error));
    }
    collection.set(document.uri, diagnostics);
  }

  context.subscriptions.push(
    vscode.workspace.onDidSaveTextDocument(check),
    vscode.workspace.onDidOpenTextDocument(check),
    vscode.workspace.onDidCloseTextDocument((d) => collection.delete(d.uri)),
  );
  for (const doc of vscode.workspace.textDocuments) {
    void check(doc);
  }
}
