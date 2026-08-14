import * as vscode from 'vscode';
import { loadWorkspace } from './json';
import { runInteractiveIn, runVerbIn } from './commands';

let panel: vscode.WebviewPanel | undefined;

// The "Polaron Studio" dashboard: a webview reusing the studio's amber design, showing project cards with action
// buttons. Buttons post messages back to run the corresponding command in that project.
export function registerDashboard(context: vscode.ExtensionContext): void {
  context.subscriptions.push(
    vscode.commands.registerCommand('polaron.dashboard', () => void openDashboard()),
  );
}

async function openDashboard(): Promise<void> {
  if (panel) {
    panel.reveal();
    await refresh();
    return;
  }
  panel = vscode.window.createWebviewPanel('polaronDashboard', 'Polaron Studio', vscode.ViewColumn.Active, {
    enableScripts: true,
    retainContextWhenHidden: true,
  });
  panel.onDidDispose(() => {
    panel = undefined;
  });
  panel.webview.html = html();
  panel.webview.onDidReceiveMessage(async (msg: { command: string; dir?: string }) => {
    if (msg.command === 'refresh') {
      await refresh();
      return;
    }
    if (!msg.dir) {
      return;
    }
    if (msg.command === 'run') {
      runInteractiveIn(msg.dir);
    } else if (['build', 'test', 'doc', 'fmt'].includes(msg.command)) {
      await runVerbIn(msg.command, msg.dir);
    }
  });
  await refresh();
}

async function refresh(): Promise<void> {
  if (!panel) {
    return;
  }
  const data = await loadWorkspace();
  await panel.webview.postMessage({ type: 'workspace', data });
}

function nonce(): string {
  let s = '';
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (let i = 0; i < 24; i++) {
    s += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return s;
}

function html(): string {
  const n = nonce();
  const csp = `default-src 'none'; style-src 'unsafe-inline'; script-src 'nonce-${n}';`;
  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="Content-Security-Policy" content="${csp}">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Polaron Studio</title>
<style>
  :root {
    --ground:#0d1417; --panel:#101c1f; --line:#23383c; --ink:#e4ece9; --muted:#86a09b; --faint:#58726e;
    --amber:#eab464; --teal:#58c8bf; --green:#93c97e; --violet:#b79ae0;
    --mono:"Cascadia Code",ui-monospace,Menlo,Consolas,monospace;
  }
  * { box-sizing:border-box; }
  body { margin:0; background:var(--ground); color:var(--ink); font-family:var(--mono); font-size:13px; }
  header { display:flex; align-items:center; gap:.6rem; padding:.8rem 1.1rem; border-bottom:1px solid var(--line); }
  .mark { color:var(--amber); font-weight:700; }
  .count { color:var(--faint); margin-left:auto; }
  button { font-family:var(--mono); font-size:12px; cursor:pointer; border-radius:6px; border:1px solid var(--line);
    background:transparent; color:var(--muted); padding:.28rem .6rem; }
  button:hover { color:var(--ink); border-color:var(--amber); }
  button.primary { color:var(--ground); background:var(--amber); border-color:transparent; font-weight:600; }
  .refresh { margin-left:.6rem; }
  main { padding:1rem 1.1rem; display:grid; gap:.9rem; grid-template-columns:repeat(auto-fill,minmax(280px,1fr)); }
  .card { border:1px solid var(--line); border-radius:10px; padding:.9rem; background:var(--panel); }
  .card h2 { margin:0 0 .1rem; font-size:14px; color:var(--amber); }
  .path { color:var(--faint); font-size:11px; word-break:break-all; margin-bottom:.6rem; }
  .meta { display:flex; flex-wrap:wrap; gap:.35rem; margin-bottom:.7rem; }
  .chip { font-size:10.5px; padding:.1rem .45rem; border-radius:999px; border:1px solid var(--line); color:var(--muted); }
  .chip.env { color:var(--violet); border-color:#3a3155; }
  .actions { display:flex; flex-wrap:wrap; gap:.35rem; }
  .empty { color:var(--muted); padding:2rem 1.1rem; }
</style>
</head>
<body>
<header>
  <span class="mark">▲ Polaron Studio</span>
  <span class="count" id="count"></span>
  <button class="refresh" id="refreshBtn">↻ Refresh</button>
</header>
<main id="cards"></main>
<script nonce="${n}">
  const vscode = acquireVsCodeApi();
  const cards = document.getElementById('cards');
  const count = document.getElementById('count');
  document.getElementById('refreshBtn').addEventListener('click', () => vscode.postMessage({ command: 'refresh' }));

  function esc(s) { return String(s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c])); }

  function render(data) {
    const projects = (data && data.projects) || [];
    count.textContent = projects.length + ' project' + (projects.length === 1 ? '' : 's');
    if (projects.length === 0) {
      cards.innerHTML = '<div class="empty">No Polaron projects in this folder.</div>';
      return;
    }
    cards.innerHTML = '';
    for (const p of projects) {
      const card = document.createElement('div');
      card.className = 'card';
      const env = p.environment ? '<span class="chip env">' + esc(p.environment) + '</span>' : '';
      card.innerHTML =
        '<h2>' + esc(p.name) + '</h2>' +
        '<div class="path">' + esc(p.dir) + '</div>' +
        '<div class="meta"><span class="chip">v' + esc(p.version) + '</span>' + env +
        '<span class="chip">' + esc(p.deps) + ' deps</span>' +
        '<span class="chip">' + esc(p.target) + '</span></div>' +
        '<div class="actions">' +
        '<button class="primary" data-cmd="run">Run</button>' +
        '<button data-cmd="build">Build</button>' +
        '<button data-cmd="test">Test</button>' +
        '<button data-cmd="doc">Doc</button>' +
        '<button data-cmd="fmt">Fmt</button></div>';
      for (const b of card.querySelectorAll('button')) {
        b.addEventListener('click', () => vscode.postMessage({ command: b.dataset.cmd, dir: p.dir }));
      }
      cards.appendChild(card);
    }
  }

  window.addEventListener('message', (e) => {
    if (e.data && e.data.type === 'workspace') { render(e.data.data); }
  });
</script>
</body>
</html>`;
}
