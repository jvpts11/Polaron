# Cross-program IPC + capability tokens — design

**Date:** 2026-07-14
**Spec:** LDP3 §2.7 (`import from program`), §2.8 (cross-program access via IPC), §32.7 (resource tokens)
**Status:** approved by João (transport + authorization model), implementation autonomous.

## What the spec asks for

```ldp3
// in program B:
import from program GameEngine bundle audio.mixers.StereoMixer;

ProgramHandle a = Program.connect("GameEngine");
if (a != null) {
    StereoMixer mixer = a.bundle("audio").namespace("mixers").type<StereoMixer>().instantiate();
    mixer.play(soundFile);   // this call becomes serialized IPC
}
```

plus: "cross-program access respects capabilities/resource tokens: program A may require specific
tokens before B may use its bundles" (§2.8), and §32.7's token model:

```ldp3
public method readFile(FileAccessToken token, String path) returns string { ... }
FileAccessToken token = system.requestFileAccess();
```

The spec fixes the *syntax* and leaves the *mechanism* open. The decisions below fill that gap.

## Decisions

### D1 — Transport: named pipe (Windows) / Unix domain socket (POSIX). **[João]**

The program's NAME is its address:

| OS | endpoint |
|---|---|
| Windows | `\\.\pipe\ldp3.<ProgramName>` |
| POSIX | `/tmp/ldp3-<ProgramName>.sock` (mode 0600) |

`Program.connect("GameEngine")` therefore needs no registry, no port file and no discovery
protocol — it opens the endpoint named after the program. Nothing is exposed on the network, and the
OS's own permissions (pipe ACL / socket mode) already keep other users out.

Rejected: TCP loopback (opens a local port any process can reach, needs a port-file registry that
goes stale) and stdio-subprocess (cannot attach to an *already running* A, which is what
`Program.connect` means).

### D2 — Authorization: full capability tokens (§32.7). **[João]**

Not merely a connection password: A hands out **unforgeable token objects**, and a remote method may
demand one as a parameter.

- A token type is an ordinary class whose constructor is **private** — only its issuing authority can
  mint one. It carries a 64-bit nonce.
- The local broker `System` grants local capabilities (`System.requestFileAccess()` etc.) against a
  process-wide policy, so a plugin loaded without privileges cannot obtain one.
- Across the wire, A issues `BundleAccessToken`s: `a.requestAccess("audio")` asks the server, whose
  auth callback approves or refuses; on approval the server records the nonce it minted. Any remote
  method that declares a token parameter has that token **validated server-side** by the generated
  dispatcher before the real method runs. A forged or unknown nonce is refused.

### D3 — Object model: the declared type already says it. **[João]**

LDP3 already has exactly one rule for this, and IPC does not get to invent a second one:

> **a value is copied; a pointer/reference is shared.**

Across a process boundary that reads:

- **Value types** (primitives, `String`, and class/record/struct **values**) travel **by copy**: field
  by field, by declared type. Assignment in LDP3 is a deep copy, so serialization *is* that copy —
  it merely crosses an address space on the way.
- **`T*` / `T&` travel as a REMOTE HANDLE — and are fully valid.** The object stays in the address
  space that owns it; the peer receives a proxy, and every call on that proxy is an RPC back to the
  owner. Sharing is preserved: a mutation the peer makes is a mutation of the one real object, which
  is the whole point of writing `T*` instead of `T`.
- Therefore **the channel is symmetric**: both peers keep an object registry and a dispatcher, and a
  CALL frame may travel in either direction. When a side is blocked waiting for a reply and an
  inbound CALL arrives (a callback into an object it lent out), it serves that call and goes back to
  waiting — the standard re-entrant RPC pump. `instantiate()` is just the special case of a handle
  the server hands out for an object it created.
- Direct **field access on a remote object is a compile error** in this slice (`use a method`).
  Adding get/set RPC later is mechanical; it is not needed by the spec's example.

### D4 — Where the code comes from: the `.ldh`, like every other dependency. **[mine]**

B already knows how to type-check against a bundle it does not link: `--use <dep.ldb>` parses the
bundle's `.ldh` header. Cross-program is the same thing with a different lowering:

    ldp3c b.ldp3 --use-remote engine.ldb -o b.ll

marks that bundle `isRemote`. Its classes are visible and type-checked exactly as today, but instead
of linking their bodies (`--use`) or resolving them at runtime (`--use-dynamic`), the compiler
**synthesizes proxy bodies** that talk IPC. The driver (`ldp3 build`) surfaces it as a manifest
dependency `{ path = "../engine", remote = true }`.

### D5 — Lowering: AST synthesis + a prelude runtime, not raw LLVM. **[mine]**

Same architecture that made generators work today: a pass in `monomorphize` synthesizes ordinary
LDP3, so semantic analysis and codegen see nothing special.

**Client side (B)** — for each class of a remote bundle, replace its declaration with a proxy:

```ldp3
public class StereoMixer {          // synthesized
    private mutable long __conn;
    private mutable long __id;
    public method play(String f) returns void {
        IpcCall c = new IpcCall(this.__conn, this.__id, "StereoMixer", "play") on heap;
        c.putString(f);
        IpcReply r = c.send();      // throws IpcError if the remote threw or refused
        delete c;
        return;
    }
}
```

**Server side (A) — and B too**, because a program that lends out a `T*` must answer calls on it.
Any program that takes part in IPC (it calls `Program.serve`, or it imports from a program) gets a
synthesized `__IpcDispatch`:

- one `ArrayList<T>` registry per exported type (LDP3 has no `Object` root, so the object id encodes
  `typeIndex << 32 | slot`);
- `create(typeName, args)` → construct, register, return the id;
- `dispatch(id, typeName, methodName, args)` → decode each argument by its **declared** type, verify
  any capability-token parameter, call the real method, encode the result;
- `serve(auth)` → accept, read frame, dispatch, write reply, loop.

`Program.serve(auth)` in the user's source is rewritten to `__IpcDispatch.serve(auth)` by the same
pass; `Program.connect(name, token)` needs no per-program code and lives in the prelude.

### D6 — Wire format: length-prefixed frames of tagged values.

```
frame  = [u32 length][u8 kind][payload]
kind 1 = CREATE   : typeName, argc, arg*                  -> reply OK(id)
kind 2 = CALL     : id, typeName, methodName, argc, arg*  -> reply OK(value) | ERR(text)
                    (may travel in EITHER direction: a callback on a lent-out T*)
kind 3 = RELEASE  : id                                    -> reply OK(void)
kind 4 = REQUEST  : bundleName, token                     -> reply OK(nonce) | ERR(text)
kind 5 = HELLO    : programName, token                    -> reply OK | ERR
arg    = [u8 tag][value]   tags: void long double boolean char String object handle null token
object = [u16 fieldCount][arg*]      (a VALUE object: fields in declared layout order)
handle = [u64 id][String typeName]   (a T* / T&: the object stays home, this is a proxy to it)
```

Everything is built and parsed in the prelude (`System.Ipc`), on top of six new runtime builtins
(`__ldp3_ipc_listen/accept/connect/send/recv/close`). Binary payloads travel inside `String`, which is
already a length-prefixed byte buffer.

## Error handling

- Endpoint absent or auth refused → `Program.connect` returns **null** (the spec's example tests for
  it). No exception for the expected case.
- A remote method that throws → the dispatcher catches it, serializes the exception's class name and
  message, and the client's proxy **rethrows** it as `IpcError` carrying both. The call site sees a
  normal LDP3 exception.
- Broken pipe mid-call → `IpcError`.
- Missing/forged token → refused server-side, surfaced as `IpcError` ("capability required").

## Testing

- Unit: frame encode/decode round-trip for every tag (doctest, C++ side of the runtime).
- E2E (CTest): two programs. `server.ldp3` exports a class and calls `Program.serve`; `client.ldp3`
  spawns the server executable (the existing `Subprocess` builtin), connects by name, instantiates,
  calls methods (value args, value return, a remote throw, a token-gated method with and without the
  token) and prints the results. Deterministic output, compared like every other e2e sample.
- E2E: a `T*` argument -- B lends A an object, A mutates it through the proxy (a callback into B),
  and B observes the mutation on its own object. That is the proof that a pointer still SHARES.
- Negative (sema): a direct field access on a remote object is a compile error with the message above.

## Slices

1. **Runtime transport** — the six builtins, Windows named pipe + POSIX UDS, behind the existing shim.
2. **Prelude protocol** — `IpcChannel`, frame writer/reader, `IpcCall`, `IpcReply`, `IpcError`.
3. **Client lowering** — `import from program`, `--use-remote`, proxy synthesis, `Program`/
   `ProgramHandle`/`RemoteType<T>` + the `bundle().namespace().type<T>().instantiate()` chain.
4. **Server lowering** — `__IpcDispatch` synthesis + `Program.serve` rewrite.
5. **Capability tokens (§32.7)** — token types, the local broker, `requestAccess`, server-side
   validation of token parameters.
6. **E2E test + docs.**
