# 18. Building real things

Five programs, each a shape somebody actually needs, written the way Polaron wants them written. They
are not tutorials for the syntax — the chapters before this one are that. They are the decisions:
what to reach for, what to leave out, and where each kind of program keeps its state.

Every one of these shapes exists in the wild today. The IDE, the world simulation and the 3D scene at
the end of this chapter are real programs that build and run with the toolchain in this repository.

---

## 18.1 A command-line tool

**The shape:** read arguments, do one thing, say what happened, exit with a code somebody's script
can read.

```polaron
import System.IO.Console;
import System.IO.Files;
import System.OS.Args;
import System.OS.Exit;
import System.Terminal.Style;

program Wc;

public bundle Main {
    public namespace App {
        public class Main {
            public static method main(string[] args) returns void {
                if (args.length() == 0) {
                    System.IO.Console.println("usage: wc <file>...");
                    Exit.failed();
                    return;
                }
                mutable int total = 0;
                for (var path in args) {
                    Option<String> text = Files.tryRead(path);
                    if (text.isNone()) {
                        System.IO.Console.println(Style.red("cannot read " + path));
                        Exit.failed();
                        return;
                    }
                    int lines = Files.readLines(path).size();
                    total = total + lines;
                    System.IO.Console.printf("%8d  %s\n", lines, path);
                }
                System.IO.Console.printf("%8d  total\n", total);
                return;
            }
        }
    }
}
```

**The decisions.**

- `Files.tryRead` and not `Files.read`: a missing file is an ordinary outcome for this tool, so it is
  an `Option` rather than an exception. Reverse that for a config file the program cannot start
  without — there, `read`'s throw names the path and the message is already written.
- `Exit.failed()` and not a silent return. `main` returns `void`; a refusal that exits 0 is a refusal
  no script, build or CI can see.
- `Style` is switched off in one place when output is redirected — colour codes in a pipe are noise
  in somebody's log file.
- `TextTable` when the output has columns. Measuring them by hand is the same bug every time.

## 18.2 A library other people plug

**The shape:** no entry point, a compiled bundle, a version, and foreign libraries named where they
belong.

```toml
# polaron.toml
[polaron_project]

[library]
name = "Polaron-OpenGL"
version = "1.0.1"
language_version = "1.0"
entry = "src/Gl.pol"

# The foreign libraries this code declares with `class X library Y`, mapped to the file each
# platform spells them in. The logical name is ours and lives in the source; the file name is the
# platform's and lives here.
[libraries]
OpenGL = { windows = "opengl32" }
Gdi    = { windows = "gdi32" }
```

```polaron
public class Gdi library Gdi {                     // which foreign library these come from
    public extern stdcall static method SwapBuffers(long dc) returns int;
}
```

**The decisions.**

- **The mapping travels inside the `.polb`.** A consumer runs `polaron plug <url>` and never learns
  that this library needs `opengl32` and four others — that was a secret it used to have to keep.
- **One type per file.** A library is read one type at a time.
- **Version it with a git tag**, because `plug` resolves `^1.0.0` against the tags: `polaron plug
  https://github.com/user/lib@^1.0.0` writes the exact resolved version into `polaron.lock`.
- Publish the `.polb` + `.polh` as a release asset too, so somebody can install it without `plug`.

## 18.3 A simulation with a window

**The shape:** a world that ticks, a renderer that draws it, and a hard line between them.

```polaron
public class Sim {
    private mutable Grid* ground;        // the world
    private mutable Population* folk;    // what lives in it
    private mutable Atlas* realm;        // and what it has built
    private mutable Crew* hands;         // the threads the tick is shared between

    private method tick() returns void {
        Grazing.tick(beasts, folk, ground, ticked, dice, log);
        Walking.tick(folk, ground, ways, ticked);
        Claiming.tick(realm, ground);
        return;
    }
}
```

**The decisions.**

- **The simulation never draws and the renderer never decides.** The renderer *borrows* the world:
  `r.takeFolk(sim.people(), art)`. A world that can only be seen through the window it happens to
  have is a world nothing can test.
- **Ids cross the seam; pointers stay inside a layer.** An agent holds `homeCity` as an id, and a
  city holds agent ids. Objects die and their slots are reused, so a pointer held across the seam
  names somebody else's person a minute later.
- **Regions for anything with one lifetime**: a pool of terminals, a frame's scratch, an arena of
  nodes. One release instead of a thousand frees, and `accepts` makes the wrong type a compile error.
- **`Parallel.forChunks` for the passes that share nothing**, with per-chunk scratch. Mark the types
  the hands share `Shared`, deliberately, so that marking is a sentence somebody wrote.
- **Measure the frame in phases from the first day.** A meter added later measures the world it finds
  rather than the change you are making.

## 18.4 A network service

**The shape:** a socket, a router, and answers that cannot be forgotten.

```polaron
import System.Net.ServerSocket;
import System.Net.Router;
import System.Net.ServerRequest;
import System.Net.ServerResponse;

Router* routes = new Router() on heap;
routes.get("/health", lambda[](ServerRequest* q) returns ServerResponse* {
    return new ServerResponse(ServerResponse.ok("ok")) on heap;
});

ServerSocket* door = ServerSocket.listen(8080);
while (door.isOpen()) {
    Socket link = door.accept();
    ServerRequest req = ServerRequest.parse(link.receive(65536));
    ServerResponse* answer = routes.dispatch(req);
    link.send(answer.toRaw());
    link.close();
    delete answer;
}
```

**The decisions.**

- **`Result` at every boundary that can refuse**, with a sealed enum of reasons rather than a status
  int. The caller cannot drop it and the reasons cannot silently grow.
- **Contracts on the parsing**, because a request is the one input a program never controls:
  `requires body.length() <= MAX` states the limit where it is enforced.
- **TLS is one call away** — `HttpClient.send` uses it for `https`, and `TlsClient.open` gives a raw
  encrypted stream for anything that is not HTTP.
- Reach for `Retry`, `CircuitBreaker` and `TokenBucket` in `System.App` rather than writing three
  counters that each get the off-by-one differently.

## 18.5 Bare metal

**The shape:** no operating system, no allocator you did not write, no runtime.

```polaron
program Kernel freestanding;

public bundle Kernel {
    public namespace Boot {
        public class Uart {
            public static fixed address BASE = cast<address>(0x09000000);
            public static method write(char c) returns void {
                Raw.write<int>(Uart.BASE, cast<int>(c));
            }
        }
    }
}
```

Build it for the machine rather than for this one:

```
polc kernel.pol --target=aarch64-unknown-none -o kernel.ll
```

**The decisions.**

- `freestanding` on the `program` is what makes the refusals compile-time: exceptions, `async`,
  reflection, `unimport` and `Console` are errors here, named as such, instead of link failures three
  layers down.
- **`address` is where the guarantees stop**, and that is the point of having a separate type for it.
  A number cast to a pointer is a fixed address — the UART at `0x09000000` was there before the
  program started — and the region binder treats it as the root region rather than refusing it.
- `extern` with an explicit calling convention for anything the firmware provides.
- No standard-library container of your own declared types on the paths the kernel uses (§17.7).

---

## 18.6 What each shape keeps, and where

| Program | State lives in | Freed by |
|---|---|---|
| CLI tool | Locals, for the length of one command | Scope exit |
| Library | Whatever the caller passes in; a library owns almost nothing | The caller |
| Simulation | Long-lived layer objects, arrays and regions | The `Sim`'s destructor, and the region releases |
| Service | Per-request objects; a connection pool that outlives them | The request loop, explicitly |
| Kernel | Static storage and hardware addresses | Nothing — there is nowhere to give it back to |

The pattern behind the table: **Polaron has no default owner**, so every program answers the question
in its own shape. What it gives you is that the answer must be written down — in a destructor, in a
region, in a `move` — where the next reader can find it.
