import * as vscode from 'vscode';
import * as path from 'path';
import { loadWorkspace, Workspace, JsonProject } from './json';

// A tree node with eager children and, on project rows, the project it represents.
class Node extends vscode.TreeItem {
  children: Node[] = [];
  project?: JsonProject;
}

function leaf(label: string, description?: string, icon?: string): Node {
  const n = new Node(label, vscode.TreeItemCollapsibleState.None);
  if (description !== undefined) {
    n.description = description;
  }
  if (icon) {
    n.iconPath = new vscode.ThemeIcon(icon);
  }
  return n;
}

function branch(label: string, icon: string, contextValue?: string): Node {
  const n = new Node(label, vscode.TreeItemCollapsibleState.Collapsed);
  n.iconPath = new vscode.ThemeIcon(icon);
  if (contextValue) {
    n.contextValue = contextValue;
  }
  return n;
}

class SimpleProvider implements vscode.TreeDataProvider<Node> {
  private readonly emitter = new vscode.EventEmitter<Node | undefined>();
  readonly onDidChangeTreeData = this.emitter.event;
  constructor(private readonly roots: () => Node[]) {}
  refresh(): void {
    this.emitter.fire(undefined);
  }
  getTreeItem(n: Node): vscode.TreeItem {
    return n;
  }
  getChildren(n?: Node): Node[] {
    return n ? n.children : this.roots();
  }
}

// The three Polaron tree views, sharing one workspace model loaded via `polaron json`.
export class LdpTrees {
  private data: Workspace = { projects: [], environments: [], libraries: [] };
  readonly projects = new SimpleProvider(() => this.projectNodes());
  readonly environments = new SimpleProvider(() => this.envNodes());
  readonly libraries = new SimpleProvider(() => this.libNodes());

  async refresh(): Promise<void> {
    this.data = await loadWorkspace();
    this.projects.refresh();
    this.environments.refresh();
    this.libraries.refresh();
  }

  private projectNodes(): Node[] {
    if (this.data.projects.length === 0) {
      return [leaf('No Polaron projects here.', undefined, 'info')];
    }
    return this.data.projects.map((p) => {
      const n = branch(p.name, 'package', 'polaronProject');
      n.description = `v${p.version}${p.environment ? ' · ' + p.environment : ''}`;
      n.project = p;
      n.command = {
        command: 'vscode.open',
        title: 'Open',
        arguments: [vscode.Uri.file(path.join(p.dir, p.entry))],
      };
      n.children = [
        leaf('entry', p.entry, 'file-code'),
        leaf('version', p.version, 'tag'),
        leaf('environment', p.environment || '—', 'server-environment'),
        leaf('dependencies', String(p.deps), 'library'),
        leaf('target', p.target, 'chip'),
      ];
      return n;
    });
  }

  private envNodes(): Node[] {
    if (this.data.environments.length === 0) {
      return [leaf('No environments.', undefined, 'info')];
    }
    return this.data.environments.map((e) => {
      const n = branch(e.name, 'server-environment');
      n.description = `${e.libs.length} libs · ${e.usedBy.length} projects`;
      n.children = [
        ...e.libs.map((d) => leaf(d.name, d.version, 'library')),
        ...e.usedBy.map((u) => leaf(u, 'uses this', 'package')),
      ];
      return n;
    });
  }

  private libNodes(): Node[] {
    if (this.data.libraries.length === 0) {
      return [leaf('No libraries.', undefined, 'info')];
    }
    return this.data.libraries.map((l) => {
      const n = branch(l.name, 'library');
      n.description = l.versions.join(', ');
      n.children = [
        ...l.usedByProjects.map((u) => leaf(u, 'project', 'package')),
        ...l.usedByEnvs.map((u) => leaf(u, 'environment', 'server-environment')),
      ];
      return n;
    });
  }
}

// The project a tree context-menu command was invoked on.
export function nodeProject(node: unknown): JsonProject | undefined {
  return node instanceof Node ? node.project : undefined;
}
