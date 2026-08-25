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
//
// AND TWO MORE, ADDED AFTER MEASURING. A census over all 874 samples reported 9 402 differences and
// ZERO programs in full agreement, which is a report nobody can act on -- and is why five memory
// defects walked past this file while it was already built. `tests/pir_shape_baseline.md` classifies
// every systematic difference; two of the four classes are answered here:
//
//   * where PIR keeps a value in a stack slot and the trusted path uses the value -- 2 981 lines,
//     reaching `Object.Object` and therefore every program. `normalizeForShapeCompare` promotes
//     those away first (see there for why promotion and not the pipeline);
//   * the synthesised entry wrapper, which the two paths structure differently on purpose -- 609
//     lines. Skipped here and asserted absolutely instead.

#include <llvm/IR/Module.h>

#include <string>
#include <vector>

namespace polaron::pir {

struct ShapeDiff {
    std::string function;   // the symbol both modules define
    std::string what;       // one line saying how the two bodies differ
};

// Promotes stack slots to values, and nothing else. Run on BOTH modules before comparing.
//
// The comparison runs before `optimize` deliberately -- "after it the two have been through the same
// pipeline, and a difference the pipeline erased is a difference that was there". That is sound
// about the OPTIMISER and too broad for this one pass: a difference `mem2reg` erases is not a
// difference in behaviour, by construction, because promotion only removes a slot whose every use it
// can see. So this runs promotion, alone -- not the pipeline, not `-O1` -- which erases exactly the
// class that was drowning the report and nothing else.
void normalizeForShapeCompare(llvm::Module& m);

// Every function both modules define, whose bodies are not the same shape. Empty means the two
// backends built the same program.
std::vector<ShapeDiff> compareBodies(const llvm::Module& trusted, const llvm::Module& viaPir);

// The report, one line per difference, with a count. Empty when there is nothing to say.
std::string renderShapeDiffs(const std::vector<ShapeDiff>& diffs, size_t bothDefine);

}  // namespace polaron::pir
