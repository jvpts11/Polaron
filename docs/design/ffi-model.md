# Restructuring the FFI

*Design record, 2026-08-13. João's redesign, discussed and decided. What is written here is the target;
`docs/reference/guide/11-systems-programming.md` §11.8 still describes what exists today.*

The complaint that started it: **the declarations.** Today the FFI has ten spellings and cannot express
the single most basic thing a foreign-function interface needs — *this Polaron name binds to that
foreign symbol.* The AST node is the proof:

```cpp
struct ExternDecl {
    std::string convention;
    std::string name;          // <- this IS the linker symbol; there is no other field
    std::vector<Param> params;
    TypeRef returnType;
    bool isVariadic;
    SourceLocation loc;
};
```

So a binding to `SDL_CreateWindow` must be *called* `SDL_CreateWindow` in Polaron. C's naming is forced
into Polaron source, which is precisely the C-with-classes creep the project rules out everywhere else.

## What exists today, enumerated

Recovered from the parser, not from the documentation.

| # | form | where |
|---|---|---|
| 1 | `[vis] extern <conv> method name(params[, ...]) returns T;` | namespace |
| 2 | `[vis] extern <conv> library NAME { method …; }` | namespace |
| 3 | `[vis] extern <conv> [static] method name(params) returns T;` | class member |
| 4 | `unknown <world>` as a method modifier (no `extern`) — export *us* to a foreign ABI | class member |
| 5 | `naked` — no prologue/epilogue, body is raw asm | class member |
| 6 | `funcptr<Ret, Args…>` | type |
| 7 | `unknown <world> funcptr<…>` | type |
| 8 | capture-free lambda → C function pointer | implicit conversion |
| 9 | `asm("arch"[, "dialect"]) { … } [out(…)] [in(…)] [clobber(…)]` | statement |
| 10 | `native_libs = "…"` in the manifest `[build]` | manifest |

`<conv>` is `cdecl` \| `stdcall` \| `fastcall` \| `unknown <world>`, with `<world>` ∈ `pe`/`elf`/`macho`
/`win64`/`sysv`/`aapcs`.

Three defects fall out of the table itself:

- **Form 2 parses `library NAME` and throws it away** — the parser says so: `expect(Identifier, "the
  library name"); // linked externally; not used here yet`. You declare which library a symbol belongs
  to and the compiler ignores it; the actual linking comes from `native_libs` in another file with no
  connection to the declaration.
- **Three places to say the same thing** (1, 2, 3) and **two grammars for the convention** — one of
  which the reference itself admits is *"currently cosmetic on 64-bit"*.
- **There is no `extern` for data.** Only functions; a foreign global cannot be imported.

## The decisions

### Calling out is a class member, and only a class member

**Form 1 is removed.** It declares a loose function, which the language does not otherwise permit.

**Form 2 is removed as a namespace construct, and its one piece of real information — the library —
moves onto the class**, which is already the grouping unit:

```polaron
public class Sdl library SDL2 {
    private extern cdecl method createWindow(String title, int x, int y, int w, int h, long flags)
        returns address symbol("SDL_CreateWindow");
}
```

That one line fixes four things at once: no loose functions; the library name is no longer discarded;
the linker learns what to link *from the declaration* rather than from an unrelated manifest key; and
the binding is encapsulated in the class that uses it.

**The library name is an identifier, not a string.** `library SDL2` names a *logical* library; the
manifest maps that name to what it actually is on each platform. This is deliberate — an identifier
cannot spell `libSDL2-2.0.so.0`, and that limitation is what forces the per-platform mapping out of the
declaration and into the manifest, which is where it belongs. It also retires the flat, Windows-shaped
`native_libs = "opengl32, user32"`.

**The symbol is a string**, and the asymmetry is principled: the library name is *ours* (a logical name
we choose, so an identifier), while the symbol is *theirs* (a literal name we do not control). A
mangled C++ symbol — `?createWindow@@YAPEAXXZ`, `_ZN3Sdl12createWindowEv` — is not an identifier in any
language, so it can only be a string.

> **Spelling note.** `symbol("…")` rather than `asm("…")`, which was the first instinct. `asm(` is
> lexed as a single `AsmBlock` token for inline-assembly statements, so reusing it in a declaration
> collides in the lexer. If the word `asm` is wanted, it costs a lexer change.

### The convention becomes the *language*

A calling convention is an ABI detail; the **language** is what actually decides name mangling, how
aggregates travel, exceptions, and ownership conventions. So the keyword names a language:

| keyword | means | what it can honestly do today |
|---|---|---|
| `cdecl` | C | no mangling; symbol is the name, or the `symbol(…)` literal |
| `cppdecl` | C++ | C++ ABI rules for aggregates and the implicit `this`; **no mangler** — the symbol is taken literally |
| `rustdecl` | Rust | **lowers to the C ABI** |
| `zigdecl` | Zig | **lowers to the C ABI** |

**`cppdecl` without a mangler is still worth having**, and the reason is not the symbol: it is the
**argument-passing rules** (a class with a non-trivial copy constructor or destructor travels by
invisible reference under Itanium; MSVC has its own rules) and the **implicit `this`**, which is what
gives a non-`static` extern its meaning. What is lost is reaching a C++-mangled symbol by name — and
the escape hatch is that the author pastes the mangled name, from `nm` or `dumpbin`, into `symbol(…)`.

**`rustdecl` and `zigdecl` are reserved now and lower to the C ABI, and this must be documented as
such.** Neither language has a stable native ABI: what is callable from outside Rust is
`#[no_mangle] extern "C"`, and Zig's `export` is the C ABI. Reserving the words is still worth doing —
they declare intent, they are what makes the mismatch warning below meaningful, and the day Rust
stabilizes the keyword is already there. What they must not do is *promise* something the language
cannot deliver.

**A mismatch is a warning, not an error.** `extern cdecl` may point at anything; the compiler warns
when the evidence says it is not C. The check is concrete rather than a guess: **if the symbol it
resolves to is mangled** — `_ZN…` (Itanium) or `?…@@…` (MSVC) — it is not a C symbol, and `cdecl` is
the wrong declaration.

### `stdcall` and `fastcall` are removed

**`fastcall`** is a 32-bit x86 convention that passes the first two integer arguments in `ECX`/`EDX`
instead of on the stack. On x86-64 it means nothing — the platform ABI already passes in registers —
and under the new axis it is a *convention*, not a language. Gone.

**`stdcall`** is the 32-bit x86 convention where arguments are pushed right-to-left as in `cdecl` but
**the callee cleans the stack** (`ret N`), and the symbol is decorated with the argument byte size
(`_MessageBoxA@16`). It was the Win32 API convention; the point was code size, since the cleanup
appears once in the callee rather than at every call site. It has one consequence that explains a lot:
**variadics are impossible** under it, because the callee cannot know how many bytes it was passed —
which is why `wsprintf` is `cdecl` while the rest of Win32 is `stdcall`. On x86-64 there is one
convention and MSVC accepts and ignores `__stdcall`.

**A syscall gets its own form instead**, because a syscall is not a language and is not called by
symbol at all — it is an instruction with a *number*:

```polaron
private extern syscall(1) method write(int fd, address buf, long n) returns long;
```

The word `stdcall` is deliberately not reused for this: it means a specific, different thing in every
other toolchain, and repurposing it would collide with what every reader already knows. *(The spelling
`syscall(N)` is proposed, not yet ratified.)*

### `static` stops being required, and non-static gains a meaning

Today `static` is not enforced by the front end — it is *assumed* by codegen. A non-static extern
parses, type-checks, and dies at the LLVM verifier:

```
private extern cdecl method abs(int x) returns int;
→ error: module verification failed: Incorrect number of arguments passed to called function!
```

That is a bug, and the fix is the feature: **a non-static extern passes the receiver as the first
argument.** That is exactly the hidden `this` of a C++ member function (so `cppdecl` needs it) and
exactly the classic object-oriented-C idiom (`void widget_draw(Widget* self)`).

**Visibility already works** on class members — the prelude has
`private extern cdecl static method __polaron_secure_random() returns long;`. Only the namespace-level
form ignored visibility, and that form is being removed. So a binding can be `private` and reachable
only by the class that owns it, which is the encapsulation the redesign is for.

### Kept, and renamed

- **`unknown <world>`** stays. It is the only way to be *called from* a foreign ABI, and the world is
  required because the compiler must never infer it.
- **`naked`** stays.
- **`funcptr` becomes `methodptr`.** The vocabulary rule, applied consistently: `function` remains the
  first-class value type, and what a pointer points at is a *method*.
- **A capture-free lambda converts to a `methodptr`**, full stop — not to "a C function pointer". The
  ABI it is called through is whatever the pointer's type says, `unknown <world>` included.
- **`asm(…)` blocks** are unchanged.

## What this does not fix, and is listed so it is not mistaken for done

- **No foreign *data*.** A global variable in a C library still cannot be imported.
- **No opaque foreign types.** An `SDL_Window*` is still an `address` or a `long`, so every foreign
  handle is interchangeable with every other — a hole in the type system opened by the boundary.
- **No ownership at the boundary.** The language has `weak`, `unique`, `movable`, `delegate` and the
  whole region model, and none of that vocabulary exists in an `extern` declaration. Who frees a
  `char*` the C side returned is unstated and unstatable. This is the deepest remaining gap and it is
  the same silent-failure class the project keeps fighting.
- **Return marshalling is documented in one direction only.** `String → char*` is specified; a
  *returned* `char*` is not, nor is what happens to data containing NULs.

## Resulting grammar

```
class-decl      := [vis] "class" Name [ "library" Ident ] "{" member* "}"

extern-method   := [vis] "extern" lang [ "static" ] "method" Name "(" params ")"
                   "returns" Type [ "symbol" "(" String ")" ] ";"
lang            := "cdecl" | "cppdecl" | "rustdecl" | "zigdecl"
                 | "syscall" "(" Int ")"
                 | "unknown" world
world           := "pe" | "elf" | "macho" | "win64" | "sysv" | "aapcs"

export-method   := [vis] "unknown" world [ "naked" ] [ "static" ] "method" … { body }

methodptr-type  := [ "unknown" world ] "methodptr" "<" Type ("," Type)* ">"
```

`static` is optional throughout; omitting it passes the receiver as the first argument.

## Order of work

1. ~~Remove forms 1 and 2; move `library Ident` onto the class; keep the class-member form.~~ **DONE.**
   The parser refuses both namespace-level forms with the sentence that names the replacement, and
   `library Ident` parses on a class into `ClassDecl::foreignLibrary`. The `ExternDecl` node and its
   four consumers stay, so a header written by an older compiler still reads; the only thing that
   became impossible is writing a new one. Tests `parser_loose_extern_errors`,
   `codegen_ffi_library_clause_runs`, and two unit tests for the refusals.
2. ~~Add `symbol("…")` and use it as the linker name, falling back to the method name.~~ **DONE.**
3. ~~Rename the convention axis to the language axis; delete `stdcall`/`fastcall`; add `cppdecl`,
   `rustdecl`, `zigdecl` (the last two lowering to C, documented).~~ **DONE.**
4. ~~`syscall(N)`.~~ **DONE.** The method gets a **body** rather than a declaration -- there is nothing
   to link against -- emitting the Linux/x86-64 contract as inline asm: the number in `rax`, arguments
   in `rdi`/`rsi`/`rdx`/`r10`/`r8`/`r9` (r10 and not rcx, because the `syscall` instruction destroys
   rcx and r11, which are therefore clobbered). Refused on any other target, with the reason: Windows
   publishes no stable syscall ABI at all, and another architecture numbers and passes them
   differently. Also refused on a **non-static** method -- the kernel contract has no room for a
   `this`, and leaving that unchecked produced an LLVM verifier failure at the end of the pipeline
   instead of a sentence at the declaration. Tests `codegen_ffi_syscall_emits` (read from IR compiled
   for Linux, since it cannot be run here) and `codegen_ffi_syscall_wrong_target_errors`.
5. ~~Make non-`static` externs pass the receiver first, and delete the assumption in codegen that
   produced an IR-verifier error.~~ **DONE.**
6. ~~`funcptr` → `methodptr`, with the old spelling accepted and deprecated for one release.~~ **DONE.**
   Both spellings are read at all three sites that recognise the type; nothing in the tree used
   `funcptr`, so the transition costs nobody anything.
7. ~~The mangled-symbol warning.~~ **DONE.** `cdecl` binding an Itanium (`_ZN…`) or MSVC (`?…@@…`)
   mangled name warns, because no C compiler produces either. A warning and not an error on purpose:
   pasting a mangled symbol by hand is exactly how a C++ binding works without a mangler of our own,
   so it may be only the wrong word on a declaration that otherwise does the right thing.
   Test `sema_ffi_mangled_cdecl_warns`. **Known debt, recorded at the site:** the check is lodged in
   `collectFixtureOwners`, a pass whose name describes test fixtures — it is simply the walk that
   reaches every method declaration, and a check whose home is "wherever the loop already was" is how
   a pass stops meaning what it is called.
8. ~~Manifest: logical library name → per-platform files; retire `native_libs`.~~ **DONE.**

   ```toml
   [libraries]
   SDL2 = { windows = "SDL2", linux = "SDL2-2.0", macos = "SDL2" }
   Zlib = "z"                       # one file name, every platform

   [libraries.Curl]                 # the same thing long-hand, for a library with four platforms
   windows = "libcurl"
   linux = "curl"
   ```

   The compiler reads the source and the driver reads the manifest, so the two have to meet somewhere:
   `polc --emit-foreign-libs=<path|->` writes the logical names the program's classes declare, and
   `polaron build` reads that file back and resolves each through `[libraries]` for the platform being
   linked for. Three answers are possible, and each is deliberate:

   - **mapped** → that file goes on the link line;
   - **mapped, but not for this platform** → *nothing*, because answering with the logical name would
     link something the manifest never sanctioned; the linker then names the missing symbol, which is
     more informative than a guessed file name;
   - **unmapped** → the name itself, so a library spelled the same everywhere (`z`, `opengl32`) needs
     no entry at all. `C` is the one built-in exception: it resolves to nothing, every platform having
     linked its C runtime already and no platform spelling it the same way.

   **The requirement crosses a bundle boundary**, which is the part that needed the header. A bundle's
   externs are private and never appear in its `.polh`, so the `library` clause is emitted on the class
   instead; a program that depends on the bundle then learns it must link SDL2 from the declaration
   rather than from an unresolved symbol naming a method its author never wrote. Tests
   `driver_foreign_library_list` and `driver_foreign_library_crosses_bundle`.

   `native_libs` still works and is still read. It is superseded rather than deleted: a name there says
   only "link this", never "this is where `class Sdl` comes from", so the two are merged with the
   declared list winning nothing and duplicating nothing.

   **`region class` crosses too**, found while writing this: the header spelled it `public sealed class`
   and lost the `region`, so a consumer would have allocated an instance on the heap — an object of the
   right shape in the wrong place, which the family's region does not own and `unimport` cannot see. It
   is the same ABI rule as the private-field bug, arrived at from a third direction: *anything codegen
   uses to decide what `new` does must be in the `.polh`.*

### What shipped, 2026-08-13

**`symbol("...")`** — parsed as a soft keyword before the `;` of an extern declaration (so `symbol`
stays usable as a name), carried on `MethodDecl::externSymbol`, used by codegen as the LLVM function
name, and emitted into the `.polh` so a consumer binds the foreign name and not the Polaron one.
Verified end to end: a method named `absolute` emits `declare i32 @abs(i32)` and returns 42.
Test `codegen_ffi_symbol_runs`.

**The language axis** — `cdecl` / `cppdecl` / `rustdecl` / `zigdecl`, with `stdcall` and `fastcall`
removed (nothing used them; only a comment mentioned them). The new names are matched as identifiers
rather than added to the keyword table, so no existing program loses a name it was already using.
`worldToCallConv` already returned the C ABI for everything that is not `unknown:<world>`, so the
lowering needed no change — which is also exactly why `rustdecl` and `zigdecl` are honest today: they
*are* the C ABI, and the test says so. Test `codegen_ffi_languages_runs`.

**A bug found on the way**, and it is the family this project keeps meeting: `monomorphize.cpp`'s
method clone copied eleven flags and stopped, so `isExtern`, `externConvention`, `isVariadic`,
`isNaked`, `isInterrupt` and the generator fields were all dropped when a generic class was
instantiated — a generic class with an `extern` method lost its externness silently. Now copied.

**And a lesson that cost a red suite:** `isProcedure` is deliberately *not* copied. The same clone is
the copier the transformer machinery uses to inject a `procedure` into the type that applies it, and
in that copy the procedure must stop being a socket and become an ordinary method. The omission is the
mechanism, not an oversight — it is now written down where it can be read.

**The receiver-first extern** — `externFnType` grew a `hasReceiver` parameter, passed as `!isStatic`.
The call site needed nothing: it was *already* handing over the receiver, which is precisely why the
verifier complained. A real C function in the object-oriented-C idiom
(`int polaron_counter_add(void* self, int by)`) was added to the runtime so the test exercises the
convention rather than its shape. Test `codegen_ffi_receiver_runs`.

> The test's receiver is a `struct`, not a class, and that is worth knowing: a class in a hierarchy
> carries its vtable pointer at offset 0, so `this` does not point at the first field. The first
> version of the test read the low half of a vtable address and printed `605437957` — the *deltas*
> were right, which is how it was clear the mechanism worked and the test did not.
