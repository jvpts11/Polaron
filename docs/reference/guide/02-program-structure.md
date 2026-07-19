# 2. Program Structure & Modules

Every language has to answer a deceptively simple question before you can write
a single line of logic: *where does code live?* In some languages the answer is
"in a file"; in others it is "in a package" or "in a module." LDP3 takes a firm
position. Code lives inside a strict, four-level hierarchy — **program → bundle →
namespace → type** — and that hierarchy is not optional decoration you can skip
for small programs. It is the shape of every LDP3 program, from a one-line
"Hello, world!" to an operating-system kernel.

This chapter walks that hierarchy from the outside in. We start with the
`program` declaration that opens every source file, descend through bundles and
namespaces, arrive at the entry point where execution begins, and then look at
the two mechanisms that control what can see what: **visibility modifiers** and
**imports**. Along the way we cover how several files compose into one program,
and we close with a glance at freestanding mode.

## The compilation unit, top to bottom

Open any LDP3 source file and you will find the same skeleton. Here is the
smallest complete, runnable program:

```ldp3
import System.IO.Console;
program HelloWorld;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.printf("Resultado: %d\n", 42);
            }
        }
    }
}
```

Read it from the top. First come the **imports** — one per line, each ending in a
semicolon, each naming exactly one thing you intend to use. Then comes the
**`program` declaration**, which names the whole compilation and is terminated by
a semicolon. Everything after that is the body: a `bundle`, which contains a
`namespace`, which contains a `class`, which contains the `method` where the work
happens.

Notice that even this trivial program pays the full structural tax. There is no
"script mode," no top-level statements, no free functions floating outside a
class. LDP3 is object-oriented by mandate: the only place executable code can
live is inside a method, and the only place a method can live is inside a type.
The scaffolding you see here is the *minimum*, not ceremony you have grown by
accident.

### Why this rigidity?

The hierarchy exists because each level answers a different question:

- The **program** is the whole deliverable — the thing you compile and ship. It
  has a name and, ultimately, an identity at runtime.
- A **bundle** is a *unit of independent compilation*. Bundles can be compiled
  separately, distributed as their own binary artifact, swapped in and out of a
  build, and even shared between running programs. They are LDP3's answer to
  libraries, plugins, and build variants all at once.
- A **namespace** is a naming and visibility scope *inside* a bundle. It keeps
  type names from colliding and draws the line that imports have to cross.
- A **type** (`class`, `interface`, `record`, `struct`, or `enum`) is where data
  and behavior finally live.

The first three levels are purely organizational — they hold no fields and run no
code of their own. They exist to give every type a precise address and to make
the reach of every name explicit rather than accidental.

### The two declaration styles

LDP3 accepts a hybrid syntax for the outer declarations. The **long form** braces
the program and each bundle explicitly, nesting everything visually:

```ldp3
program GameEngine {
    public bundle audio {
        public namespace mixers {
            public class StereoMixer { /* ... */ }
        }
    }
}
```

The **short form** declares the program (and, if you like, the bundle) with a
trailing semicolon instead of a brace block, letting the namespaces sit at the
top level of the file:

```ldp3
program GameEngine;
bundle audio;

public namespace mixers {
    public class StereoMixer { /* ... */ }
}

public namespace effects {
    public class Reverb { /* ... */ }
}
```

Both forms describe the same hierarchy; they differ only in how much you indent.
Throughout this reference — and in the compiler's own sample suite — the common
idiom is the short `program Name;` line followed by a braced `public bundle`, as
in the Hello, world program above. Use whichever reads better for the file at
hand.

## The entry point

An executable program must have exactly one place for execution to begin. LDP3
finds that place by looking for a specific, fully public chain of declarations —
there is no configuration file and no naming magic beyond the rule itself. The
entry point is:

> a **`public` bundle**, containing a **`public` namespace**, containing a
> **`public class` named `Main`**, containing a
> **`public static method main(string[] args)`** that returns `void` (or `int`).

Every word of that sentence is enforced. The bundle, the namespace, and the class
must all be `public`; the class must be named exactly `Main`; the method must be
named exactly `main`, must be `static`, must take a single parameter, and that
parameter must be an array of `string`. The return type must be either `void` or
`int` — nothing else, and it may not itself be an array.

```ldp3
import System.IO.Console;
program Greeter;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                System.IO.Console.println("Hello from LDP3");
                return;
            }
        }
    }
}
```

The `string[] args` parameter is the program's command-line arguments — the words
that followed the executable's name on the command line, delivered as a dynamic
array of strings. A program that ignores its arguments simply never touches
`args`, but the parameter must still appear in the signature: it is part of the
shape the compiler matches against.

A `void` `main` may end with a bare `return;` or simply run off the end of the
method; both are fine. If you would rather signal an exit status to the operating
system, declare `returns int` instead and return a number.

The compiler is strict in both directions. If **no** valid entry-point chain
exists, compilation of an executable fails with a diagnostic telling you to
provide a public `Main`. If **more than one** valid `main` exists across the
program, that is an ambiguity error — you must disambiguate by renaming,
narrowing visibility, or changing a signature so that exactly one candidate
remains. Libraries are the deliberate exception: a bundle compiled as a library
(see multi-file compilation below) needs no entry point at all, because it is
meant to be consumed, not launched.

## Visibility

Visibility is how LDP3 controls reach: which code is allowed to name, touch, or
call which other code. Every declaration states its visibility explicitly —
there is no "package-private by omission" default to memorize. If you leave the
modifier off where one is expected, that is a mistake to be corrected, not a
silent default.

At the **bundle and namespace level**, three modifiers apply, and they describe
how far across *program boundaries* a bundle or namespace reaches:

- **`public`** — reachable by *other running programs* at runtime (LDP3 lets one
  program call into another's public bundles). This is the visibility the entry
  point requires.
- **`internal`** — reachable anywhere inside the *same program*, across any of
  its bundles, but never from outside.
- **`private`** — reachable only inside the *owning bundle*.

At the **member level** — the fields and methods inside a class — four modifiers
apply, and they describe reach within the type hierarchy in the way you would
expect from any class-based language:

- **`public`** — visible to all code that can see the type.
- **`protected`** — visible inside the class and its subclasses.
- **`private`** — visible only inside the declaring class.
- **`internal`** — visible within the same program.

Here `protected` lets a subclass reach a base-class field while keeping it hidden
from unrelated code:

```ldp3
public class Account {
    protected mutable int balance;

    public constructor Account(int initial) {
        this.balance = initial;
    }
}

public class Savings extends Account {
    public constructor Savings(int initial) {
        super(initial);
    }
    public method addInterest() returns void {
        this.balance = this.balance + this.balance / 100;   // protected field, reachable in subclass
    }
}
```

Two habits from the language's conventions are worth restating because they
interact with visibility on every line: member access always goes through
`this.` (there is no implicit receiver), and values are immutable unless marked
`mutable`. The `balance` field above is both `protected` *and* `mutable`, because
a subclass reads it and the class reassigns it.

## Imports

If visibility decides what *could* be seen, imports decide what a given file
actually *chooses* to see. LDP3's rule here is uncompromising and central to the
language's character: **nothing is implicit.** There is no ambient prelude of
globally visible names, no automatically imported standard library. If a file
uses a type, that type must either live in the same namespace or be imported by
name.

An import names one symbol and ends with a semicolon:

```ldp3
import System.IO.Console;
import System.Collections.ArrayList;
```

The path is the symbol's full address: everything before the last component is
the namespace, and the last component is the type (or other importable symbol)
itself. `import System.IO.Console;` brings the `Console` type from the
`System.IO` namespace into this file's scope. **Wildcards are not allowed** in
any form — you cannot write `import System.IO.*;`. Each thing you use is spelled
out, one import per line. This is verbose on purpose: reading the top of a file
tells you exactly what it depends on, with no guessing.

Because the rule admits no exceptions, even the most everyday facilities require
an import. Printing to the console needs `import System.IO.Console;`; there is no
built-in `print`. A program that forgets the import and then calls
`System.IO.Console.println(...)` will not compile. The verbosity is the intended
cost of having no hidden magic.

### How imports gate cross-namespace access

The purpose of an import is to cross a namespace boundary. Within a single
namespace, types see each other freely — no import is needed for one class in
`app` to use another class in `app`. The moment a type in one namespace refers to
a type in *another* namespace, though, an import (or a fully qualified name) is
required, and the compiler enforces this on **every** place a type name can
appear: local variables, field declarations, method parameters, return types,
and expressions alike.

Consider a program with two namespaces where `app` wants to use a helper from
`lib`:

```ldp3
import System.IO.Console;
import lib.LibHelper;              // reach across the namespace boundary
program TwoNamespaces;

public bundle main {

    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                LibHelper* h = new LibHelper() on heap;   // LibHelper is visible thanks to the import
                System.IO.Console.printf("weight=%d\n", h.weight());
                delete h;
                return;
            }
        }
    }

    public namespace lib {
        public class LibHelper {
            public constructor LibHelper() {}
            public method weight() returns int { return 9; }
        }
    }
}
```

Drop the `import lib.LibHelper;` line and the compiler objects that `LibHelper`
lives in namespace `lib` and must be imported to be used here. The diagnostic
even suggests the exact line to add. The same barrier applies if `LibHelper`
appeared only as a parameter type or a return type — the import gates the *name*,
wherever it is written.

### Import-prefix validation

An import is not merely a spelling of a name; it is a *claim* about where that
name lives, and the compiler checks the claim. The prefix — everything before the
final component — must be the symbol's real, declared namespace. If it is not,
compilation fails.

```ldp3
import lib.LibHelper;     // OK: LibHelper really is declared in namespace `lib`
import app.LibHelper;     // error: 'LibHelper' is in namespace 'lib', not 'app'
import lib.Nonexistent;   // error: import of unknown symbol 'lib.Nonexistent'
```

This turns imports into checked documentation. You cannot accidentally import the
wrong `Widget` from the wrong namespace and have it silently resolve to something
unexpected: the path either matches the truth or the build stops.

The standard library is internally cohesive, so a `System.*` type may lean on
another `System.*` type without an explicit import between them — `System.Json`
can use a `StringBuilder` from `System.Text` freely. But that cohesion is a
convenience *inside* the standard library. Your code always imports what it uses
from `System`, every symbol, every time.

## Programs that span several files

Real programs outgrow a single file, and LDP3 lets one program be assembled from
many `.ldp3` files. There are two distinct mechanisms, and it is worth keeping
them separate in your mind.

The first is **compiling several files together as one program.** You hand the
compiler more than one source file at once:

```
ldp3c core.ldp3 ui.ldp3 net.ldp3 -o app.ll
```

Every file must open with the *same* `program` name — the first file establishes
the name, and any file that disagrees is rejected with an error. The compiler
then merges all the bundles and all the file-level imports from every file into a
single program and analyzes them as a whole. Because file-level imports are
gathered together, the split across files is purely for your own organization;
the resulting program behaves exactly as if you had written it all in one file.
Each file still carries its own imports at the top, so each file remains readable
on its own.

The second mechanism is **separate bundle compilation.** Because a bundle is a
unit of independent compilation, you can build one on its own into a distributable
binary — a `.ldb` file (the compiled implementation) paired with a `.ldh` header
(its public declarations, used for type-checking consumers). A library bundle is
compiled in library mode and needs no entry point:

```
ldp3c calc_lib.ldp3 --lib -o calc.ldb        # produces calc.ldb + calc.ldh
```

A separate program then *consumes* that bundle. It imports the bundle's public
types by name exactly as if they were part of its own source, and points the
compiler at the compiled bundle so the implementation can be linked in:

```ldp3
import System.IO.Console;
import math.Calc;                 // a public type from the separately-compiled `calc` bundle
program CalcApp;

public bundle main {
    public namespace app {
        public class Main {
            public static method main(string[] args) returns void {
                int r = Calc.square(7);
                System.IO.Console.printf("square = %d\n", r);
                return;
            }
        }
    }
}
```

```
ldp3c calc_app.ldp3 --use calc.ldb -o app.ll
```

Here the consumer type-checks against `calc.ldh` and links the real code from
`calc.ldb`. The bundle boundary is thus both a compilation boundary and a
distribution boundary — the foundation for shipping libraries, plugins, and
different build variants of the same program without maintaining parallel source
trees.

## Cross-program access via IPC

Two separate LDP3 programs can talk to each other as if they shared one object graph. A
**server** program exports a class; a **client** program holds a proxy for it and calls its
methods, and each call is serialized across a pipe/socket named after the server program. The
object's state lives only in the server process.

The server calls `Program.serve`, naming itself and supplying a **capability policy** — a
lambda consulted for every capability a client requests:

```ldp3
import System.Ipc.Program;

// Grant "mixdown", refuse everything else.
Program.serve("GameEngine", lambda(String capability) returns boolean {
    return capability.equals("mixdown");
});
```

Any method on the exported class is callable remotely. A method that takes a
`BundleAccessToken` parameter is **privileged**: the dispatcher runs it only after checking
the token is one this program actually issued (see the client side below).

The client imports the remote type's header with `import from program`, connects by name, and
builds a proxy. `Program.connect` returns a `nullable ProgramHandle*` (null if the server
isn't running); the proxy's every method call becomes IPC:

```ldp3
import from program GameEngine bundle audio.StereoMixer;
import System.Ipc.Program;
import System.Ipc.IpcError;

nullable ProgramHandle* a = Program.connect("GameEngine");
if (a == null) {
    // the engine is not running
    return;
}

StereoMixer mixer = a.bundle("audio").namespace("mixers").type<StereoMixer>().instantiate();
try {
    int n = mixer.play("boom.wav");   // arguments are serialized; the result comes back
    mixer.setVolume(9);               // state persists in the server across calls

    // Capabilities: ask the server's policy, then use the token for a privileged call.
    BundleAccessToken* mixdown = a.requestAccess("mixdown");
    if (mixdown.granted()) {
        int level = mixer.mixdown(mixdown);
    }
} catch (IpcError e) {
    // a call failed on the wire
}
a.close();
```

The type is known to the client only from the server's header (its *body* lives in the other
process), so the compiler hands the client a proxy whose methods are wire frames. Capability
tokens make the trust boundary explicit: the server decides, per client, what is allowed.

## A forward pointer: freestanding mode

Everything above assumes the managed LDP3 runtime — the machinery behind
exceptions, the standard `Console`, reflection, and more. For systems programming
that runs with no runtime beneath it (a kernel, a bootloader, bare metal), a
program or an individual bundle can be declared **freestanding** by adding the
keyword to its declaration: `program Kernel freestanding;` or
`public bundle main freestanding { ... }`. In that mode the compiler removes the
managed runtime and actively *rejects* any feature that would depend on it —
async/await, exceptions, reflection, the managed `Console` and standard library —
leaving the systems core of structs, regions, raw pointers, the low-level
`Memory` API, and FFI. Freestanding mode is a subject of its own and is covered in
a later chapter; it is mentioned here only so that its declaration syntax has a
place in the structural picture drawn by this one.
