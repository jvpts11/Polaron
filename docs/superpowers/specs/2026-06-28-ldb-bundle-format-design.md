# Design: F9 — the .ldb bundle container, .ldh header, and ABI fingerprint

Date: 2026-06-28
Status: design (spec issue #12); approved decisions: custom container, static + dynamic linking.

## Goal
Make `bundle` a real unit of separate compilation/distribution (spec 2.4-2.5). A library (a program
with no `main`) compiles to a `.ldb` (no `.exe`); a program that uses it type-checks against the
bundle's public API and links/loads its code, with an ABI fingerprint guarding compatibility.

## Decisions (from João)
- **Container**: a custom `.ldb` binary that wraps the compiled code + embedded metadata.
- **Linking**: support **both** static (linked at build) and dynamic (loaded at runtime).

## `.ldb` container format (binary, little-endian)
```
Header (fixed prefix):
  magic         : "LDB\x01"            (4 bytes)
  formatVersion : u16
  flags         : u16                  (bit0 freestanding; reserved otherwise)
  abiFingerprint: 32 bytes             (SHA-256 of the canonical public API; see below)
  nameLen u16, name   : UTF-8 bundle name (e.g. "audio")
  verLen  u16, version: UTF-8 semver  (e.g. "1.2.0")
Section directory:
  count u16, then count * { tag:4 bytes, offset:u32, size:u32 }
Sections (referenced by the directory):
  "LDH "  public API as LDP3 declaration text (UTF-8) -- consumed for type-checking.
  "DEPS"  required bundles: repeated { name, versionConstraint, expectedFingerprint:32 }.
  "CAPS"  required capabilities: repeated UTF-8 strings (spec capabilities).
  "CODE"  the bundle's compiled code as LLVM bitcode (portable: static -> compile+link with LTO;
          dynamic -> JIT/AOT at load). One module per bundle.
```
Bitcode in CODE keeps cross-bundle optimization possible (LTO) for static and lets the dynamic
loader JIT or AOT-compile on load.

## `.ldh` header
The public declarations (LDP3 text: public types/methods/fields, no bodies) plus the fingerprint.
Emitted as a standalone `.ldh` file AND embedded as the `.ldb` "LDH " section. A consumer compiling
against a bundle reads the `.ldh` (file or section), parses it like ordinary source for name/type
resolution, and records its fingerprint.

## ABI fingerprint (spec 2.5)
SHA-256 over the **canonical** public API: every public type and its public members
(method/field name + parameter and return types + modifiers), sorted deterministically, serialized
to a stable text form, hashed. Stable across unrelated private changes; changes when any public
signature changes. Stored in the `.ldb` header and the `.ldh`.

## Performance model (why multi-file costs no speed)
Shipping CODE as **bitcode** (not a pre-compiled native object) is what keeps LDP3 in the top
performance tier even when split across bundles:
- **Static (default)**: the final build runs **LTO across the program + all linked bundles**, so the
  optimizer treats everything as one unit -- cross-bundle inlining, vtable devirtualization, global
  DCE/const-prop. A multi-bundle static binary is as fast as a single-file program; the bundle
  boundary disappears. (Most native languages only get this with LTO explicitly enabled; here it is
  the default static path.)
- **Dynamic**: the loader has the bundle's bitcode and the caller's IR, so it can **JIT with LTO at
  load** -- inline/devirtualize across the load boundary -- approaching static runtime speed, moving
  the cost to load-time latency (mitigable with an AOT cache on first load). A native-object plugin
  (C/C++/Rust/Zig/Odin) cannot do this: its boundary cost is fixed.
- The compiler's own middle-end (task #19) runs inside the LTO/JIT step, so aggressive optimization
  applies across bundles in both modes.

## Static vs dynamic is a per-bundle choice
A bundle is linked statically (default, fastest) or loaded dynamically (plugins), chosen per
dependency in the project manifest (`audio = { dynamic = true }`) or via a build flag/variant
(`ldp3 build --dynamic=audio`, spec §40 #15). The default is static + LTO.

## Flows
### Static (build-time)
1. `ldp3c --lib audio.ldp3 -o audio.ldb` -> compile the library; emit `audio.ldb` (header + LDH +
   DEPS + CAPS + CODE bitcode) and `audio.ldh`.
2. `ldp3c app.ldp3` (imports `audio`) -> resolve `audio.ldh`, parse it for type-checking, record its
   fingerprint into the program.
3. Link: extract `audio.ldb` CODE bitcode -> compile to object (LTO with app) -> link into `app.exe`;
   verify the `.ldb` fingerprint equals the one the program compiled against (mismatch = build error).

### Dynamic (run-time)
1. The program marks the bundle as dynamically loaded; the expected fingerprint is embedded.
2. At runtime a loader (runtime/ldp3_rt + an LLVM-JIT-backed helper) opens `audio.ldb`, reads its
   fingerprint, compares to the expected -> mismatch throws `BundleAbiMismatchException`.
3. On match, the loader materializes CODE (JIT the bitcode, or AOT to a temp module) and resolves the
   bundle's exported symbols for the calling program.

## Phasing (each phase keeps the suite green)
1. **Container + .ldh + fingerprint (no linking yet)**: emit a `.ldb`/`.ldh` for a `--lib` program;
   a round-trip test reads the container back. Fingerprint computed + stored.
2. **Static use**: a program imports a bundle via its `.ldh` (type-check) and links the `.ldb` CODE;
   build-time fingerprint check. End-to-end: a 2-bundle program runs.
3. **Dynamic load**: runtime loader + load-time fingerprint check + `BundleAbiMismatchException` +
   symbol resolution (JIT). End-to-end: a program loads a `.ldb` at runtime and calls into it.

## Out of scope (later)
Version resolution when multiple compatible versions exist (spec §40 #14), cross-program IPC (#13),
build variants (#15), the unified `ldp3` toolchain that orchestrates all this (task #17, F10).
