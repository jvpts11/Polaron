import * as vscode from 'vscode';

// Phase 1 -- the language (id, extension, grammar, configuration) is contributed declaratively in
// package.json, so syntax highlighting needs no activation code. Commands, tree views, the webview and the
// language client are added by later phases; this entry point is where they will be registered.
export function activate(_context: vscode.ExtensionContext): void {}

export function deactivate(): void {}
