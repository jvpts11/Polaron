import * as vscode from 'vscode';
import { registerCommands } from './commands';
import { registerFormatter } from './format';
import { registerDiagnostics } from './diagnostics';

export function activate(context: vscode.ExtensionContext): void {
  registerCommands(context);
  registerFormatter(context);
  registerDiagnostics(context);
}

export function deactivate(): void {}
