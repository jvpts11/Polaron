import * as vscode from 'vscode';
import { registerCommands, runVerbIn, runInteractiveIn } from './commands';
import { registerFormatter } from './format';
import { registerDiagnostics } from './diagnostics';
import { LdpTrees, nodeProject } from './trees';
import { registerDashboard } from './webview';

export function activate(context: vscode.ExtensionContext): void {
  registerCommands(context);
  registerFormatter(context);
  registerDiagnostics(context);
  registerDashboard(context);

  const trees = new LdpTrees();
  context.subscriptions.push(
    vscode.window.registerTreeDataProvider('ldp3Projects', trees.projects),
    vscode.window.registerTreeDataProvider('ldp3Environments', trees.environments),
    vscode.window.registerTreeDataProvider('ldp3Libraries', trees.libraries),
    vscode.commands.registerCommand('ldp3.refresh', () => trees.refresh()),
    vscode.commands.registerCommand('ldp3.tree.build', (n: unknown) => {
      const p = nodeProject(n);
      if (p) {
        void runVerbIn('build', p.dir);
      }
    }),
    vscode.commands.registerCommand('ldp3.tree.run', (n: unknown) => {
      const p = nodeProject(n);
      if (p) {
        runInteractiveIn(p.dir);
      }
    }),
    vscode.commands.registerCommand('ldp3.tree.test', (n: unknown) => {
      const p = nodeProject(n);
      if (p) {
        void runVerbIn('test', p.dir);
      }
    }),
  );

  // Keep the trees in sync with the manifests on disk.
  const watcher = vscode.workspace.createFileSystemWatcher('**/ldp3.toml');
  const reload = () => void trees.refresh();
  watcher.onDidChange(reload);
  watcher.onDidCreate(reload);
  watcher.onDidDelete(reload);
  context.subscriptions.push(watcher);

  void trees.refresh();
}

export function deactivate(): void {}
