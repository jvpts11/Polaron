import * as vscode from 'vscode';
import { ldp3Path, projectCwd, run } from './tools';

let channel: vscode.OutputChannel | undefined;

function output(): vscode.OutputChannel {
  if (!channel) {
    channel = vscode.window.createOutputChannel('LDP3');
  }
  return channel;
}

function requireCwd(): string | undefined {
  const cwd = projectCwd();
  if (!cwd) {
    void vscode.window.showErrorMessage('LDP3: open a file or folder inside an LDP3 project first.');
  }
  return cwd;
}

// Run a non-interactive verb (build/test/doc/fmt/new), streaming its output to the LDP3 output channel.
async function runCaptured(verb: string, extra: string[] = []): Promise<void> {
  const cwd = requireCwd();
  if (!cwd) {
    return;
  }
  const ch = output();
  ch.show(true);
  ch.appendLine(`$ ldp3 ${verb} ${extra.join(' ')}`.trimEnd());
  const { code, out } = await run(ldp3Path(), [verb, ...extra], cwd);
  ch.append(out.endsWith('\n') ? out : out + '\n');
  ch.appendLine(code === 0 ? `✔ ldp3 ${verb} succeeded` : `✖ ldp3 ${verb} failed (exit ${code})`);
}

// Run the program interactively: a terminal whose shell *is* `ldp3 run`, so the program can read input.
function runInteractive(): void {
  const cwd = requireCwd();
  if (!cwd) {
    return;
  }
  const term = vscode.window.createTerminal({ name: 'ldp3 run', cwd, shellPath: ldp3Path(), shellArgs: ['run'] });
  term.show();
}

export function registerCommands(context: vscode.ExtensionContext): void {
  const push = (id: string, fn: () => void | Promise<void>) =>
    context.subscriptions.push(vscode.commands.registerCommand(id, fn));

  push('ldp3.run', runInteractive);
  for (const verb of ['build', 'test', 'doc', 'fmt']) {
    push(`ldp3.${verb}`, () => runCaptured(verb));
  }
  push('ldp3.new', async () => {
    const name = await vscode.window.showInputBox({
      prompt: 'New LDP3 project name',
      validateInput: (v) => (/^[A-Za-z0-9_-]+$/.test(v) ? undefined : 'Use letters, digits, _ or -.'),
    });
    if (name) {
      await runCaptured('new', [name]);
    }
  });
}
