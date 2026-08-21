#pragma once

#include <string>

#include "pir/module.h"

// The PIR text form: print a module, parse it back, get the same module.
//
// See docs/design/polaron-ir.md §1.6. The round trip is not a convenience -- it is what makes every
// stage testable in isolation and what makes a bug report a file rather than a description. Stage 0's
// entire acceptance criterion is `parse(print(m))` printing identically.
//
// The grammar, by example:
//
//   module "x86_64-unknown-none-elf" bundle "Pico" {
//     type %Point = {i32, i32}
//     global @count : i32 = 0, internal, static
//
//     fn @Window.width(ptr) -> i32 linkage(public) conv(polaron) kind(method) unwind(never) {
//     ^entry(%this : ptr):
//       %w = load i32, %this
//       fact.requires %w
//       ret %w
//     }
//   }
namespace polaron::pir {

std::string print(const Module& module);

// Parses the text form. On failure the message names the line and what was expected; the module is
// left as far as it got, which is what makes a parse bug readable.
bool parse(const std::string& text, Module* into, std::string* error);

}  // namespace polaron::pir
