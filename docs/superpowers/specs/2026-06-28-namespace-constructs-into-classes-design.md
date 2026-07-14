# Design: move non-type namespace constructs into classes (OOP integrity)

Date: 2026-06-28
Status: approved (brainstorm), implementation pending

## Principle

LDP3 is OOP-mandatory. It must be **impossible** to declare a function or method (or any
non-type executable/value declaration) outside a class or OOP construct. Free-floating
declarations are an OOP hole that erodes LDP3's identity. The only future, controlled way to
have functions outside a class will be **dominions** (a v1.1 concept: top-level math-domain
construct holding `function`s — not methods — that must return a value, with encapsulation,
subdominions, and dominion-interfaces). Dominions are explicitly out of scope here.

## The three offenders (the only non-type namespace-level constructs)

Source of truth: parser `parseNamespace`. Everything else declarable at namespace level is a
type (`class`, `interface`, `enum`, `record`, `catalog`, `struct`/`union`, `annotation`,
`typealias`/`newtype`) and stays.

1. `const` (namespace-level named compile-time constant value)
2. `comptime literal` (literal suffix, e.g. `64 kilobytes`)
3. `extern` (C FFI declaration)

## Decisions

### A. `const` -> `static` field of a class
A named compile-time constant is data; its OOP home is a static constant field (Java/C# style).
- New: `public class Limits { public static const int MAX = 100; }`, referenced `Limits.MAX`.
- Namespace-level `const` becomes a compile-time error.
- Keeps the existing constant-fold rule (`evalConst*`).

### B. `comptime literal` -> member of the result type's class/struct (its own member kind)
A literal suffix stays its OWN member kind (like `constructor`/`destructor`/`operator`), declared
inside the class/struct it produces. It is implicitly static (no `this`; `64 kilobytes` has no
receiver). All existing rules carry over unchanged (must be `comptime`, exactly one numeric
parameter, argument must be a compile-time constant, overload by parameter type).
- New:
  ```
  public struct ByteSize {
      public final int64 bytes;
      public constructor ByteSize(int64 b) { this.bytes = b; }
      public comptime literal kilobytes(int x) returns ByteSize { return new ByteSize(cast<int64>(x) * 1024L); }
  }
  ```
- Suffix sugar `64 kilobytes` -> `ByteSize.kilobytes(64)` (still requires import to bring the
  suffix name into scope).
- Explicit form requires qualification by the owner: `ByteSize.kilobytes(64)`. The bare
  `kilobytes(64)` form is removed (only the suffix sugar `64 kilobytes` stays bare).
- Namespace-level `comptime literal` becomes a compile-time error.

### C. `extern` -> `static extern` method of a class
An extern declares a foreign C symbol with no LDP3 body. It becomes a static method carrying the
`extern` + calling-convention modifiers, owned by a class that groups the foreign library.
- New: `public class LibC { public extern cdecl static method abs(int x) returns int; }`,
  called `LibC.abs(-42)`. The C symbol = the method's simple name.
- The `extern library NAME { ... }` block becomes a class grouping its extern static methods.
- Namespace-level `extern` becomes a compile-time error.
- Open item: `goto`-to-extern (spec 7.9) currently references an extern by bare name; resolve it
  against the class-qualified extern (or its C symbol) when migrating.

### D. FFI callbacks (after C) — passing a non-capturing lambda to C
An extern method parameter typed `function<R, Args...>` accepts a **non-capturing** lambda; the
compiler emits a C-signature trampoline that calls the lambda's code with a null environment
(spec 30.8 / 3461). Capturing lambdas are rejected (they need a heap env, incompatible with a
raw C function pointer).
- `public class C { public extern cdecl static method qsort(ptr base, int n, int sz, function<int, ptr, ptr> cmp) returns void; }`

## Migration (suite must stay green at each step)

- `const`: `comptime_double`, `comptime_fn`, `comptime_if`, `comptime_runaway_bad`,
  `const_nonconst_bad`, `const_values`, `static_assert_comptime`.
- `comptime literal`: `literals`, `literal_overload`, `suffixes`, plus the prelude
  `System.Memory.Units` in `src/cli/main.cpp` (6 suffixes move into `ByteSize`).
- `extern`: `cascade_graph`, `ffi_extern`, `ffi_library`, `ffi_struct`, `freestanding_kernel`,
  `freestanding_tetrad`; check `goto_*` for goto-to-extern.

## Implementation order (decomposed; each its own commit, suite green)

1. **const into classes** (lowest risk): parse `static const` field; error on namespace const;
   migrate 7 samples + references.
2. **comptime literal into classes**: parse `comptime literal` as a class/struct member (implicit
   static); suffix/explicit resolution qualified by owner; error on namespace literal; migrate 3
   samples + prelude.
3. **extern into classes**: parse `extern ... static method` as a class member; error on
   namespace extern; handle goto-to-extern; migrate 6 samples.
4. **FFI callbacks**: `function<>` extern param + non-capturing-lambda trampoline; reject captures.

## Out of scope (v1.1)
The full `dominion` construct (functions, morphisms, encapsulation, subdominions,
dominion-interfaces). When it lands, literal suffixes / free functions may move there; this design
keeps them in classes until then.
