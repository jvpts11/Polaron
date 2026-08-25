#pragma once

#include <array>
#include <cstdint>
#include <functional>
#include <string>
#include <string_view>
#include <vector>

#include "parser/ast.h"
#include "pir/module.h"

// Stage 1: lower the AST to PIR.
//
// See docs/design/polaron-ir.md §14. This runs IN PARALLEL with the real pipeline and nothing
// depends on its output, which is the whole design of the stage: the compiler cannot break because
// of it, and what it buys immediately is the entire sample suite as PIR test input.
//
// WHAT IS NOT LOWERED IS SAID OUT LOUD. `Lowering::gaps` collects one entry per construct this pass
// does not handle yet, with its source location. A lowering that silently emitted `unreachable` for
// what it did not understand would look finished and be worthless -- and the gap list is exactly the
// work queue for finishing the stage.
namespace polaron::pir {

struct Gap {
    std::string construct;   // "MatchStmt", "AwaitExpr", ...
    std::string where;       // "@Window.width"
    SourceLocation loc;
};

struct Lowering {
    Module module;
    std::vector<Gap> gaps;
    // THE DISPATCH NUMBERING THIS COMPILATION SETTLED ON, in slot order: position IS the slot, and
    // an empty entry is one nothing uses. `--lib` writes it into the `.polb` and a consumer seeds
    // itself with it (`BundleContext::vtableSlots`), because a library baked its vtables against
    // its own numbering and a consumer that renumbers sends every virtual call to whichever method
    // happens to sit at that index.
    //
    // Answered by the lowering because the lowering is what assigns them -- see `slotFor`. It used
    // to be answered by the other back end, which is why it had to outlive its own deletion by one
    // commit.
    std::vector<std::string> vtableSlots;
};

// ---- what the DRIVER knows about a bundle boundary and the program text does not ----
//
// Both of these were handed to the trusted backend alone (`seedVtableSlots`, `addDynamicBundle`),
// and that cost what every other one-sided fact has cost: the two backends disagreed silently.
// Thirteen of the eighteen bundle tests failed through PIR, and not one of them said "vtable" or
// "thunk" -- they said `value = 2` where `value = 12` was expected, and an access violation.

// A bundle whose code is resolved at RUN TIME (`--use-dynamic`). Its methods are declarations, and
// what stands in for each one is a thunk: it loads the `.polb` on first call, looks the symbol up
// and forwards. The fingerprint is what the loader checks the container against, so a bundle
// rebuilt with a different ABI is refused rather than called into.
struct DynamicBundle {
    std::string name;                              // the AST bundle name
    std::string path;                              // the `.polb` to load
    std::array<std::uint8_t, 32> fingerprint{};    // the ABI the consumer was compiled against
};

// THE SLOT LIST IS AN ORDER, NOT A SET. A library baked its vtables against its own numbering, and
// the consumer must hand out the SAME numbers or a virtual call reaches whichever method happens to
// sit at that index. `bundle_virtual_runs` crashed for exactly that reason.
struct BundleContext {
    std::vector<std::string> vtableSlots;
    std::vector<DynamicBundle> dynamic;
    // `--lib`: this compilation IS a bundle, so it is laid out for an OPEN world -- see
    // `carriesVtable`. A public class here may be extended by a consumer that does not exist yet.
    bool library = false;
};

// Lowers `program` into a fresh module. Never fails: an unhandled construct becomes a gap and an
// `unreachable`, so the module is always well-formed enough to print and to verify.
//
// `sourceLine` reads back one 1-based line of one compiled file, and it is optional because nothing
// in the lowering NEEDS it: without it the module is the same module. What it buys is the TEXT of a
// failing contract clause. §29 says a broken contract stops the program and names the disagreement,
// and naming it means quoting the line as written -- which the AST does not keep, because a parsed
// expression is a shape and the spelling is gone by then. The trusted path is handed the same
// lookup for the same reason (`CodeGenerator::setSourceLookup`), and the differential compares the
// two reports character for character.
//
// `triple` is the TARGET, and it answers a question the program cannot: whether anything calls
// `main`. "Is the program freestanding" is a different question -- it says nothing hands it an
// argv -- and running the two together renames `main` to `kmain` for a freestanding program built
// for a hosted machine, which then has no entry point at all. Empty means the host.
//
// `bundles` is what the driver read out of the `.polb` files on the command line. Empty for a
// program that imports none, which is nearly all of them.
Lowering lower(const ast::Program& program,
               std::function<std::string(std::string_view, int)> sourceLine = {},
               std::string triple = {}, BundleContext bundles = {});

std::string renderGaps(const std::vector<Gap>& gaps);

}  // namespace polaron::pir
