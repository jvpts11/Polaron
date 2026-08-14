import * as vscode from 'vscode';
import * as os from 'os';
import * as fs from 'fs';
import * as path from 'path';
import { polcPath, run } from './tools';

// Format a Polaron document by running `polc --fmt` on a temporary copy (so unsaved edits are honoured and the
// real file is never touched), then replacing the whole document with the result.
export function registerFormatter(context: vscode.ExtensionContext): void {
  context.subscriptions.push(
    vscode.languages.registerDocumentFormattingEditProvider('polaron', {
      async provideDocumentFormattingEdits(document: vscode.TextDocument): Promise<vscode.TextEdit[]> {
        const tmp = path.join(os.tmpdir(), `polaron-fmt-${process.pid}-${document.version}.pol`);
        try {
          fs.writeFileSync(tmp, document.getText(), 'utf8');
          const { code } = await run(polcPath(), ['--fmt', tmp], path.dirname(tmp));
          if (code !== 0) {
            return [];
          }
          const formatted = fs.readFileSync(tmp, 'utf8');
          const whole = new vscode.Range(
            document.positionAt(0),
            document.positionAt(document.getText().length),
          );
          return [vscode.TextEdit.replace(whole, formatted)];
        } catch {
          return [];
        } finally {
          try {
            fs.unlinkSync(tmp);
          } catch {
            /* ignore */
          }
        }
      },
    }),
  );
}
