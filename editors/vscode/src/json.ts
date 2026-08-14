import * as vscode from 'vscode';
import { polaronPath, run } from './tools';

export interface JsonProject {
  name: string;
  dir: string;
  version: string;
  entry: string;
  environment: string;
  deps: number;
  target: string;
}

export interface JsonDep {
  name: string;
  version: string;
}

export interface JsonEnv {
  name: string;
  libs: JsonDep[];
  usedBy: string[];
}

export interface JsonLib {
  name: string;
  versions: string[];
  usedByProjects: string[];
  usedByEnvs: string[];
}

export interface Workspace {
  projects: JsonProject[];
  environments: JsonEnv[];
  libraries: JsonLib[];
}

const EMPTY: Workspace = { projects: [], environments: [], libraries: [] };

// The directory `polaron json` should scan: the first workspace folder (it discovers every project beneath it).
function workspaceRoot(): string | undefined {
  return vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
}

// Load the workspace model by running `polaron json`. Returns an empty model if there is no workspace or the
// command fails, so callers never have to special-case it.
export async function loadWorkspace(): Promise<Workspace> {
  const cwd = workspaceRoot();
  if (!cwd) {
    return EMPTY;
  }
  const { code, out } = await run(polaronPath(), ['json'], cwd);
  if (code !== 0) {
    return EMPTY;
  }
  try {
    return JSON.parse(out) as Workspace;
  } catch {
    return EMPTY;
  }
}
