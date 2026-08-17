# Standard Library — The System: machine, environment, files, processes, IPC

`import System.OS.Machine;` · `import System.IO.Files;` · `import System.OS.Subprocess;`

Everything a program needs to be a *program on a machine* rather than a computation: what hardware it
is on, what the environment says, where its files are, how to start another process and talk to it,
and how two Polaron programs speak to each other.

One rule runs through all of it, and it is worth stating once because it decides every signature
below:

> **Absent is not empty.** A variable that is not set, a file that is not there and a process that
> never started are each a different thing from a variable holding `""`, an empty file and a process
> that exited. Where the difference matters the answer is an `Option`, an exception, or a named
> boolean — never a value that could also be real data.

---

## 1. `Machine` — what you are running on

```polaron
import System.OS.Machine;

int hands = Machine.threads();          // share the work between this many
if (Machine.isWindows()) { ... }
```

| Member | Answers |
|---|---|
| `threads()` | Hardware threads. What a work crew is sized from. |
| `memory()` / `availableMemory()` | Total and free physical memory, in bytes. |
| `pageSize()` | The OS page size. |
| `uptime()` | Seconds since boot. |
| `os()` → `"windows"` / `"linux"` / `"macos"`; `isWindows()`, `isLinux()`, `isMacOS()` | Which system. |
| `architecture()`, `is64Bit()` | Which processor. |
| `hostname()`, `user()`, `processId()` | Who and where. |

---

## 2. `Environment` — variables, three ways on purpose

```polaron
import System.OS.Environment;

Option<String> maybe = Environment.lookup("EDITOR");      // absent is a state
String editor = Environment.get("EDITOR", "vi");           // absent has a fallback
String key = Environment.require("API_KEY");               // absent is an error
```

| Member | When to reach for it |
|---|---|
| `lookup(name) returns Option<String>` | The variable may or may not be set, and both are ordinary. |
| `get(name, fallback)` | There is a sensible default. |
| `require(name) throws(EnvironmentException)` | The program cannot run without it — and the throw names it, so the message is not "something went wrong". |
| `has(name)`, `set(name, value)`, `clear(name)` | Testing and changing. |
| `all() returns HashMap<String, String>` | Everything, for a dump or a child process. |
| `searchPath() returns ArrayList<String>`, `pathSeparator()` | `PATH`, already split for the platform. |

Three ways to read one variable looks like too many until the alternative is written out: one
`get(name)` returning `""` makes "unset" and "set to empty" the same answer, and every caller that
cares has to remember which one it got.

---

## 3. Files

`Files` is the large one — the whole filesystem surface, as static methods over paths.

```polaron
import System.IO.Files;

String text = Files.readOr("config.toml", "");
Files.write("out.txt", text);
for (var path in Files.walk("src").toArray()) { ... }
```

**Reading and writing:** `read` (throws `IoException` naming the path), `tryRead` (an `Option`),
`readOr` (a fallback), `readLines`, `write`, `append`, `writeLines`, `appendLine`, `replace`.
**Bytes:** `readInto(path, Buffer*)`, `writeBytes`, `appendBytes`.
**Asking:** `exists`, `size`, `isFile`, `isDirectory`, `isReadOnly`, `modifiedAt`, `createdAt`,
`accessedAt`, `isNewerThan`, `matches(pattern, path)` (glob).
**Changing:** `touch`, `setReadOnly`, `rename`, `move`, `copy`, `delete`, `createDirectory`,
`createDirectories`, `deleteDirectory`, `deleteRecursively`, `copyDirectory`.
**Walking:** `listDir`, `walk`, `walkDirectories`, `directorySize`.
**Links:** `isSymbolicLink`, `linkTarget`, `createSymbolicLink`, `createDirectoryLink`,
`createHardLink`.

### Streams, for what does not fit in a `String`

| Type | What it is |
|---|---|
| `FileStream` — `open(path, mode)`, `read(path)`, `write(path)`, `append(path)` | A handle: `readBytes(Buffer*, n)`, `writeBytes`, `seek`, `tell`, `flush`, `close`. For files bigger than memory, and for binary formats. |
| `LineReader` | A `FileStream` as an `Iterator<String>` — `foreach` over a file's lines without holding the file. |
| `TempFile` / `TempDirectory` | Made on construction, **deleted by the destructor**. `keep()` says "not this one" when a failure needs to be inspected. |
| `DirectoryWatcher` — `poll() returns DirectoryChanges` | What changed since the last poll: created, modified, removed. Polling rather than callbacks, because a callback from another thread is a rule about threads that a file API should not be imposing. |

---

## 4. Workspace, disk, exit, signals

| Type | Members |
|---|---|
| `Workspace` | `current()`, `moveTo(path)`, `homeDirectory()`, `tempDirectory()`, `executable()`, `executableDirectory()`. The last two are how a program finds its own assets — relative to the binary, not to wherever it was launched from. |
| `Disk` | `freeSpace(path)`, `totalSpace(path)`, `usedSpace(path)`. |
| `Exit` | `now(code)`, `ok()`, `failed()`. **`main` returns `void`**, so this is how a program refuses: a run that fails without an exit code is a failure no script can see. |
| `Signals` | `answer(sig, handler)`, `giveBack(sig)`, `sendToSelf(sig)` — Ctrl-C that shuts down cleanly rather than being killed mid-write. |

---

## 5. Processes

```polaron
import System.OS.Process;
import System.OS.Command;
import System.OS.Subprocess;

ProcessResult r = Process.run("git status --porcelain");
if (r.ok()) { System.IO.Console.println(r.output()); }
```

| Type | What it is |
|---|---|
| `Process.run(commandLine) returns ProcessResult` | One-shot: run it, capture stdout to the end, get `exitCode()`, `output()`, `ok()`. Goes through the system shell, with everything that implies about quoting. |
| `Command` | The same, built from a **program and its arguments** rather than one string — no shell, so nothing in an argument can become syntax. Reach for this whenever any part of the command came from outside the program. |
| `Subprocess` — `start`, `startCombined`, `startVisible` | A child that stays open: `write`, `read`, `canRead`, `isAlive`, `closeInput`, `close`. For request/response protocols (a language server, a debugger adapter). `startCombined` merges stderr into stdout — right for a compiler, wrong for anything speaking a framed protocol. |
| `Pty` — `start(command, cols, rows)` | A child on a real pseudo-terminal: `write`, `read`, `resize`, `isAlive`, `close`. What an integrated terminal needs — a shell behind a pipe does not draw. |

---

## 6. Talking to another Polaron program

`import System.Ipc.*;` — cross-program calls, where the other program is another Polaron
**program** rather than a library: it runs in its own process and exposes bundles.

```polaron
ProgramHandle engine = ...;                     // an open connection
BundleAccessToken* token = engine.requestAccess("audio.mixers");
if (token.granted()) { ... }
```

| Type | What it is |
|---|---|
| `ProgramHandle` | A connection: `bundle(name)`, `namespace(name)`, `requestAccess(capability)`, `close()`. |
| `BundleAccessToken` | The answer to a request for access: `granted()`, `capability()`, `nonce()`. **Access is asked for and granted, not assumed** — a program exposing a bundle decides who may call it. |
| `RemoteType<T>` | A type on the other side; `instantiate()` builds one there and hands back a proxy. |
| `IpcChannel` — `request(frame) throws(IpcError)` | The transport underneath. |
| `IpcWriter` / `IpcReader` | The frame format: `putInt`/`getInt`, `putString`/`getString`, and so on for every primitive. |
| `IpcProto`, `IpcRuntime` | The message kinds and the dispatcher on the serving side. |
| `IpcServer.serve(name, auth)` | The serving half: publishes this program under `name` and answers calls, with `auth` deciding **per capability** whether a caller may have it. A program that serves without an `auth` is a program that answers everybody. |

Ordinary code uses `import from program …` (see §2 of the guide) and never names these; they are here
for anybody implementing a transport or debugging a frame.
