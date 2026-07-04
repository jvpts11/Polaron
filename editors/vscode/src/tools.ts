import * as vscode from 'vscode';
import * as cp from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

// Locate the ldp3 CLI: the `ldp3.path` setting, else the repo build output under a workspace folder, else the
// bare name resolved via PATH.
export function ldp3Path(): string {
  return locate('path', 'ldp3');
}

// Locate the low-level compiler ldp3c, similarly.
export function ldp3cPath(): string {
  return locate('compilerPath', 'ldp3c');
}

// Locate the ldp3-lsp language server, similarly.
export function ldp3LspPath(): string {
  return locate('lspPath', 'ldp3-lsp');
}

function locate(settingKey: string, exe: string): string {
  const configured = vscode.workspace.getConfiguration('ldp3').get<string>(settingKey);
  if (configured && configured.trim().length > 0) {
    return configured;
  }
  const built = findInWorkspace(exe);
  return built ?? exe;
}

function findInWorkspace(exe: string): string | undefined {
  const suffix = process.platform === 'win32' ? '.exe' : '';
  const relatives = [`build/bin/Debug/${exe}${suffix}`, `build/bin/Release/${exe}${suffix}`];
  // Search each workspace folder, then the repository the extension itself lives in (out/ -> repo root),
  // so running from source (editors/vscode) finds the build output without any configuration.
  const roots = [
    ...(vscode.workspace.workspaceFolders ?? []).map((f) => f.uri.fsPath),
    path.resolve(__dirname, '..', '..', '..'),
  ];
  for (const root of roots) {
    for (const rel of relatives) {
      const candidate = path.join(root, rel);
      if (fs.existsSync(candidate)) {
        return candidate;
      }
    }
  }
  return undefined;
}

// The working directory a command should run in: the active file's folder (ldp3 walks up to the manifest),
// else the first workspace folder.
export function projectCwd(): string | undefined {
  const doc = vscode.window.activeTextEditor?.document;
  if (doc && doc.uri.scheme === 'file') {
    return path.dirname(doc.uri.fsPath);
  }
  return vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
}

// Run a tool, capturing stdout+stderr and the exit code.
export function run(exe: string, args: string[], cwd: string): Promise<{ code: number; out: string }> {
  return new Promise((resolve) => {
    cp.execFile(exe, args, { cwd, windowsHide: true, maxBuffer: 8 * 1024 * 1024 }, (err, stdout, stderr) => {
      const code =
        err && typeof (err as NodeJS.ErrnoException & { code?: number }).code === 'number'
          ? Number((err as { code: number }).code)
          : err
            ? 1
            : 0;
      resolve({ code, out: (stdout ?? '') + (stderr ?? '') });
    });
  });
}
