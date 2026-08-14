import * as vscode from 'vscode';
import { polaronPath, projectCwd, run } from './tools';

let channel: vscode.OutputChannel | undefined;

function output(): vscode.OutputChannel {
  if (!channel) {
    channel = vscode.window.createOutputChannel('Polaron');
  }
  return channel;
}

// Run a non-interactive verb (build/test/doc/fmt/new) in `cwd`, streaming its output to the Polaron channel.
export async function runVerbIn(verb: string, cwd: string, extra: string[] = []): Promise<void> {
  const ch = output();
  ch.show(true);
  ch.appendLine(`$ polaron ${verb} ${extra.join(' ')}`.trimEnd());
  const { code, out } = await run(polaronPath(), [verb, ...extra], cwd);
  ch.append(out.endsWith('\n') ? out : out + '\n');
  ch.appendLine(code === 0 ? `✔ polaron ${verb} succeeded` : `✖ polaron ${verb} failed (exit ${code})`);
}

// Run the program interactively in `cwd`: a terminal whose shell *is* `polaron run`, so it can read input.
export function runInteractiveIn(cwd: string): void {
  const term = vscode.window.createTerminal({ name: 'polaron run', cwd, shellPath: polaronPath(), shellArgs: ['run'] });
  term.show();
}

function requireCwd(): string | undefined {
  const cwd = projectCwd();
  if (!cwd) {
    void vscode.window.showErrorMessage('Polaron: open a file or folder inside a Polaron project first.');
  }
  return cwd;
}

export function registerCommands(context: vscode.ExtensionContext): void {
  const push = (id: string, fn: () => void | Promise<void>) =>
    context.subscriptions.push(vscode.commands.registerCommand(id, fn));

  push('polaron.run', () => {
    const cwd = requireCwd();
    if (cwd) {
      runInteractiveIn(cwd);
    }
  });
  for (const verb of ['build', 'test', 'doc', 'fmt']) {
    push(`polaron.${verb}`, () => {
      const cwd = requireCwd();
      if (cwd) {
        return runVerbIn(verb, cwd);
      }
    });
  }
  push('polaron.new', async () => {
    const cwd = requireCwd();
    if (!cwd) {
      return;
    }
    const name = await vscode.window.showInputBox({
      prompt: 'New Polaron project name',
      validateInput: (v) => (/^[A-Za-z0-9_-]+$/.test(v) ? undefined : 'Use letters, digits, _ or -.'),
    });
    if (name) {
      await runVerbIn('new', cwd, [name]);
    }
  });
}
