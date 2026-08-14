import * as vscode from 'vscode';
import { registerCommands, runVerbIn, runInteractiveIn } from './commands';
import { registerFormatter } from './format';
import { registerDiagnostics } from './diagnostics';
import { LdpTrees, nodeProject } from './trees';
import { registerDashboard } from './webview';
import { startLanguageServer } from './lsp';

export function activate(context: vscode.ExtensionContext): void {
  registerCommands(context);
  registerFormatter(context);
  registerDashboard(context);

  // The language server owns diagnostics (and the outline and completion). When it is unavailable, fall back
  // to running the compiler in check mode on save.
  if (!startLanguageServer(context)) {
    registerDiagnostics(context);
  }

  const trees = new LdpTrees();
  context.subscriptions.push(
    vscode.window.registerTreeDataProvider('polaronProjects', trees.projects),
    vscode.window.registerTreeDataProvider('polaronEnvironments', trees.environments),
    vscode.window.registerTreeDataProvider('polaronLibraries', trees.libraries),
    vscode.commands.registerCommand('polaron.refresh', () => trees.refresh()),
    vscode.commands.registerCommand('polaron.tree.build', (n: unknown) => {
      const p = nodeProject(n);
      if (p) {
        void runVerbIn('build', p.dir);
      }
    }),
    vscode.commands.registerCommand('polaron.tree.run', (n: unknown) => {
      const p = nodeProject(n);
      if (p) {
        runInteractiveIn(p.dir);
      }
    }),
    vscode.commands.registerCommand('polaron.tree.test', (n: unknown) => {
      const p = nodeProject(n);
      if (p) {
        void runVerbIn('test', p.dir);
      }
    }),
  );

  // Keep the trees in sync with the manifests on disk.
  const watcher = vscode.workspace.createFileSystemWatcher('**/polaron.toml');
  const reload = () => void trees.refresh();
  watcher.onDidChange(reload);
  watcher.onDidCreate(reload);
  watcher.onDidDelete(reload);
  context.subscriptions.push(watcher);

  void trees.refresh();
}

export function deactivate(): void {}
