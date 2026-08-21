#pragma once

// COMPARING BODIES, NOT NAMES.
//
// The differential this project runs compares what a program PRINTS. That is the strongest evidence
// there is -- two programs that print the same thing on the same input agree about everything the
// input reached -- and it has exactly two blind spots, both of which cost a night each to find:
//
//   * it cannot see what must NOT be in the image. A freestanding program that prints nothing agrees
//     with any other program that prints nothing, so a kernel whose `asm` blocks were silently
//     dropped "passed";
//   * it cannot see a difference the program never reaches. A method compiled wrongly on a path no
//     sample takes is a method the corpus calls correct.
//
// This closes both by comparing the two modules THEMSELVES: for every function both backends emit,
// what its body is made of. Not the text -- the two paths name their values differently and always
// will -- but the shape: how many blocks, which opcodes and how many of each, and which functions it
// calls. A method that loads where the other stores, or calls `Queue$int.size` where the other calls
// `ArrayList$Command.size`, differs here even when nothing in the program ever runs it.
//
// What it deliberately does NOT report: value names, block names, instruction order within a block,
// and functions only one side emits. The first three are spelling; the last is a real difference but
// a noisy one -- a backend is free to synthesise a helper -- and it is already visible as a link
// failure when it matters.

#include <llvm/IR/Module.h>

#include <string>
#include <vector>

namespace polaron::pir {

struct ShapeDiff {
    std::string function;   // the symbol both modules define
    std::string what;       // one line saying how the two bodies differ
};

// Every function both modules define, whose bodies are not the same shape. Empty means the two
// backends built the same program.
std::vector<ShapeDiff> compareBodies(const llvm::Module& trusted, const llvm::Module& viaPir);

// The report, one line per difference, with a count. Empty when there is nothing to say.
std::string renderShapeDiffs(const std::vector<ShapeDiff>& diffs, size_t bothDefine);

}  // namespace polaron::pir
