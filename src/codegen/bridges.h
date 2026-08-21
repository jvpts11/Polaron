#pragma once

// WHAT A PROGRAM WITH NO LIBC HAS TO BE GIVEN.
//
// Freestanding is not "hosted minus the standard library": several things the language promises
// everywhere are, in a hosted build, calls into the runtime -- and on bare metal there is no runtime
// to call. `String` copies and frees itself, and searches itself; a `cascade delete` over a graph
// that is not a forest needs a visited set so a node with two owners is not deleted twice. The
// reference lists all of these as available freestanding, so the compiler defines them itself.
//
// It lives here rather than inside a backend for the reason everything in this directory does: it is
// a promise of the LANGUAGE, and a backend that does not know about it emits a `declare` and lets
// the program fail at link with `undefined symbol: __polaron_str_copy`. That is exactly what
// happened the day the other backend was tried as the default -- five tests, on features that had
// worked for a year.
//
// Nothing here reads the AST, a class table, or either backend's state. It needs a module, a
// context, and to be told the program is freestanding; that is the whole interface, and it is what
// makes the code movable at all.

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

namespace polaron {

// `__polaron_str_copy`, `__polaron_str_free`, `__polaron_str_index` -- the String primitives, for a
// program that has no libc to provide them. A symbol that already has a body is left alone.
void emitStringBridge(llvm::LLVMContext& context, llvm::Module& module);

// THE VISITED SET A `cascade` NEEDS, for a program that has no libc.
//
// `cascade` is a freestanding feature and it links -- right up to the moment the owned graph stops
// being a forest. Then the cascade allocates a visited set so a node with two owners is not deleted
// twice, and that set was only ever a hosted runtime call: three undefined symbols at link time, on
// a keyword the reference lists as available bare metal.
//
// pico met it the ordinary way. Two classes each own a `TextRenderer` -- the desktop's type and the
// icon font's -- so the class has two owning edges, the forest test fails (it is a per-TYPE test,
// which it has to be), and a `cascade delete` that had linked for a year stopped linking because a
// second object of an existing kind came into being. Nothing about the kernel was wrong.
//
// A CHAIN OF BLOCKS, not a hash table. The sets a cascade builds are small -- the nodes of one owned
// graph -- and a linear scan over a handful of pointers beats hashing them; more to the point, a
// chain needs no rehash, so the whole thing is three loops with no allocation policy to get wrong.
// The block is 512 bytes: a count, a next pointer, and sixty-two slots.
void emitPointerSetBridge(llvm::LLVMContext& context, llvm::Module& module);

}  // namespace polaron
