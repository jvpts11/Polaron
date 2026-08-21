#pragma once

// WHAT OPTIMISING A POLARON PROGRAM MEANS, as one function over one module.
//
// `CodeGenerator::optimize` used to be the only way to reach it, which was fine while there was one
// backend. There are two: the second builds its own `llvm::Module`, and until this existed that
// module went to the output UNOPTIMISED -- so every program compiled through PIR ran at -O0 however
// the driver was invoked. In a hosted sample that reads as "a bit slower". In pico it reads as a
// kernel that spends tens of seconds compositing one frame and misses every wall-clock assertion
// its own suite makes.
//
// Declared here, and NOT in `codegen.h`, because that header states its own rule at the top: the
// LLVM types stay behind a PIMPL so it is LLVM-free. This one is not, and says so by living apart.
//
// One definition rather than a copy per backend, for the reason this compiler keeps relearning: two
// copies of a rule drift, and then a program means two different things depending on which half of
// the compiler built it.

#include <llvm/IR/Module.h>

namespace polaron {

// Levels 1-3 map to the LLVM per-module default pipeline; 0 is a no-op and leaves the IR exactly as
// it was generated. The Polaron middle-end passes -- the transforms clang's default pipeline omits
// -- run BEFORE it, so the default pipeline cleans up after them.
void optimizeModule(llvm::Module& module, int level);

}  // namespace polaron
