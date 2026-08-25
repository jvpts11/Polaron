#pragma once

// WHAT OPTIMISING A POLARON PROGRAM MEANS, as one function over one module.
//
// `CodeGenerator::optimize` used to be the only way to reach it, which was fine while there was one
// back end. Then there were two: the second built its own `llvm::Module`, and until this existed
// that module went to the output UNOPTIMISED -- so every program compiled through PIR ran at -O0
// however the driver was invoked. In a hosted sample that reads as "a bit slower". In pico it reads
// as a kernel that spends tens of seconds compositing one frame and misses every wall-clock
// assertion its own suite makes.
//
// There is one back end again, and this still lives apart from it. Optimising a module has never had
// anything to do with which pass built the module -- that it was ever reachable only through one is
// the accident, and the accident is what cost pico those frames. What a program MEANS must not
// depend on which half of the compiler happened to construct it.

#include <llvm/IR/Module.h>

namespace polaron {

// Levels 1-3 map to the LLVM per-module default pipeline; 0 is a no-op and leaves the IR exactly as
// it was generated. The Polaron middle-end passes -- the transforms clang's default pipeline omits
// -- run BEFORE it, so the default pipeline cleans up after them.
void optimizeModule(llvm::Module& module, int level);

}  // namespace polaron
