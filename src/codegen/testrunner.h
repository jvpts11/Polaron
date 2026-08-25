#pragma once

// `--test`: the synthetic runner over a program's `[Test]` methods.
//
// WHY THIS IS ITS OWN UNIT, AND NOT PART OF A BACKEND.
//
// "`--test` means the entry point is a runner over the `[Test]` methods" is a rule of the LANGUAGE,
// spelled out in spec 32. It lived inside the AST-to-LLVM backend, and the day the other backend was
// tried as the default the cost arrived: a program compiled `--test` through PIR kept its OWN `main`
// as the entry and ran that. `test_lifecycle --list` printed `run me with --test` -- the sample's
// own first line -- and nine tests in the suite went red at once. The compiler accepted the flag,
// produced an executable, and the executable did something else.
//
// That is the same shape as every other divergence this work has turned up: a rule written in one
// backend is a rule the other one violates silently. So it moved here, beside `applyBareMetalAttrs`
// (which the triple decides, not a backend) and `invariantCanBreakIn` (which the language decides).
//
// The unit is in two halves because they answer two different questions:
//
//   `collect`  -- WHAT tests exist. Pure AST: annotations, signatures, lifecycle hooks, `[Cases]`
//                 sources. Needs one thing from the backend, `classKey`, because a test's SYMBOL is
//                 its class's emitted key and only the backend knows how it spelled that.
//   `emit`     -- the runner itself, built as LLVM IR against a module whose functions already
//                 exist. Needs four things a backend alone can answer, gathered in `Backend`.
//
// A LATER SIMPLIFICATION, RECORDED HERE SO IT IS NOT LOST: the runner's whole body -- the loops, the
// calls, the timing, the choice of verdict -- is expressible in Polaron. Synthesised as AST instead
// of as IR it would be lowered by every backend for free, now and for ever, and this file would
// shrink to its first half. What stopped that today is the argument handover: `__polaron_test_begin`
// takes the C `argc`/`argv`, which a Polaron `main` does not have, so the runtime would need to
// learn to take the marshalled `string[]` instead. That is a change to a shipped contract and it
// wants deciding, not assuming.

#include <functional>
#include <map>
#include <string>
#include <vector>

#include "codegen/cgutil.h"   // `CodegenError`, which is what this reports through
#include "parser/ast.h"

// `IRBuilder` is included rather than forward-declared: it is a class TEMPLATE, so a bare
// `class IRBuilder;` here would not declare it but a different type of the same name, and the real
// one is then rejected when it arrives.
#include <llvm/IR/IRBuilder.h>

namespace llvm {
class Function;
class LLVMContext;
class Module;
class Type;
class Value;
}  // namespace llvm

namespace polaron {
namespace testrunner {

// One `[Test]` method, or one row of a parametrised one.
struct Case {
    std::string sym;      // "Class.method" -- the key the function was emitted under
    std::string display;  // what the runner prints, and what --filter matches against
    std::string cls;      // owning class, to find its lifecycle hooks
    bool isVoid = false;  // verdict comes from Test.assert* rather than a returned boolean
    bool ignored = false;         // [Ignore(...)]: reported as SKIP, never run
    std::string ignoreReason;
    std::string tags;             // [Tag(name:)] entries, comma-joined, for --tag/--exclude-tag
    // [Cases(source: "m")]: the test takes one parameter and runs once per element of the array
    // that `m` returns. Empty when the test takes no parameters.
    std::string casesSym;         // "Class.m"
    std::string paramType;        // the element type, for the load out of the array block
    int repeat = 1;               // [Repeat(times:)]: all runs must pass
    bool expectedToFail = false;  // [ExpectedToFail]: the verdict is inverted
    long long maxTimeNs = 0;      // [MaxTime(ms:)]: a pass that overran becomes a failure
};

// [Benchmark] methods: timed loops rather than verdicts, run only under --bench.
struct Bench {
    std::string sym;
    std::string display;
    long long iterations = 1000;
    long long warmup = 100;
};

// [BeforeAll]/[AfterAll] run once around a class's tests; [Setup]/[Teardown] around EACH of them.
struct Hooks {
    std::string beforeAll, afterAll, setup, teardown;
};

struct Plan {
    std::vector<Case> tests;
    std::vector<Bench> benches;
    std::map<std::string, Hooks> hooks;   // by class NAME, which is what `Case::cls` holds
};

// The four things the runner needs that only a backend can answer.
struct Backend {
    // The emitted function for a key, or null. Both backends key by "Class.method".
    std::function<llvm::Function*(const std::string&)> function;
    // The LLVM type ONE ELEMENT of a `T[]` occupies, from the element type's name. `boolean` is a
    // byte in storage and an i32 in a value, which is why this cannot be guessed from the name here.
    std::function<llvm::Type*(const std::string&)> storageType;
    // Value coercion, which each backend already has and which differ in what they know about
    // struct returns and pointer widths.
    std::function<llvm::Value*(llvm::Value*, llvm::Type*)> coerce;
    // The program's classes load before its tests run, exactly as they do in an ordinary `main`.
    std::function<void()> emitClassLoadHooks;
};

// EVERY KEY THE RUNNER WILL CALL that nothing else in the program does: its `[Test]` methods, their
// `[Cases]` sources, the `[Benchmark]`s, the lifecycle hooks, and the prelude methods the runner
// itself uses. A backend that dead-strips before the runner exists must root all of these, or it
// concludes -- correctly, on what it can see -- that they are unreachable and removes them. Both
// failures show up only at LINK: `undefined symbol: Census.buildWorld`, then `Test.reset`.
std::vector<std::string> rootsOf(const Plan& plan);

// WHAT tests the program holds. `classKey` maps a class's NAME to the key its functions were
// emitted under -- for a class whose name the standard library also uses, that key carries a path,
// and composing the symbol from the bare name instead made a whole class's tests VANISH from the
// run. A suite that reports "8 passed" while holding eleven is worse than one that fails.
Plan collect(const ast::Program& program,
             const std::function<std::string(const std::string&)>& classKey,
             std::vector<CodegenError>& errors);

// The runner, as `main`, into `module`. Every function it calls must already exist there.
//
// The BUILDER comes from the caller, and that is not a detail: `Backend::emitClassLoadHooks` emits
// into it, and a backend that keeps its own builder -- the AST-to-LLVM one does -- would otherwise
// write those calls into whatever block it was last pointed at rather than into the runner.
void emit(llvm::LLVMContext& context, llvm::Module& module, llvm::IRBuilder<>& builder,
          const Plan& plan, const Backend& back);

}  // namespace testrunner
}  // namespace polaron
