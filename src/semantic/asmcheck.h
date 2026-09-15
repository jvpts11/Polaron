// Semantic analysis of inline assembly.
//
// Polaron's `asm` block is already structured rather than a string: the architecture and dialect are named,
// and the operands are ordinary expressions the analyser resolves. What was missing is the half that
// makes that structure worth having -- nobody looked at the BODY. It went to the assembler verbatim, so
// `asm` was the one construct in the language where genuinely arbitrary code could live, and the one
// place a mistake was neither caught nor catchable. That is C's bargain, and Polaron exists to refuse it.
//
// The checks below are not stylistic. Each one corresponds to a class of fault that has actually cost
// time in a real freestanding Polaron program:
//
//   * A register written by the body but declared to nobody. The compiler allocates around an asm block
//     using ONLY what the block declares -- outputs and `clobber(...)`. A body that writes `eax` without
//     saying so is a lie the register allocator believes, and the damage lands in unrelated code that
//     happened to be holding a live value there. Nothing about the symptom points back here.
//   * A `push`/`pop` sequence that does not balance, or that pops in an order other than the exact
//     reverse of its pushes. This is the shape of every hand-written save/restore, and its correctness
//     is "these two lists agree" -- an invariant maintained by a human reading carefully, which is
//     precisely what a compiler is for.
//   * AT&T sigils in an Intel-dialect block. Intel is `dst, src` and AT&T is `src, dst`, so mixing them
//     does not fail to assemble -- it silently inverts the meaning.
//   * `$3` where only two operands were supplied.
//   * A mnemonic that is not an instruction on the named architecture.
//
// HONESTY ABOUT COVERAGE. A body using `.macro`, `.rept` or `.if` is not the instruction stream that
// will be assembled -- it is a program that produces one. The flow-sensitive checks (push/pop pairing)
// are meaningless there and are SKIPPED rather than guessed at, and `AsmReport::flowChecked` says so,
// so a caller can tell "verified" from "not looked at". A checker that quietly reports success on what
// it could not read would be worse than no checker.
#pragma once

#include <string>
#include <vector>

namespace polaron::semantic {

// One thing the checker has to say. `offset` is a byte index into the body text, so a caller can point
// at the offending line rather than at the block as a whole.
struct AsmFinding {
    enum class Severity { Error, Warning };
    Severity severity = Severity::Error;
    std::string message;
    int line = 0;        // 1-based line within the asm body
};

struct AsmReport {
    std::vector<AsmFinding> findings;
    bool flowChecked = false;   // false when macros made the instruction stream unknowable
    int instructions = 0;       // how many instruction lines were actually examined
};

// What the block declared about itself, from the AST.
struct AsmDeclared {
    std::string arch;                   // "x86_64", ...
    std::string dialect;                // "intel" | "att" | "" (architecture default)
    int outputCount = 0;
    int inputCount = 0;
    std::vector<std::string> clobbers;  // as written: "rax", "memory", "cc", ...
    // True when the enclosing method is `naked`. The undeclared-write check does not apply there: a
    // naked body IS the whole method, so there is no compiler-generated code holding live values for it
    // to corrupt. Applying it anyway would reject every boot stub and every interrupt entry ever
    // written, which is the one way to make this checker worse than useless.
    bool inNakedFunction = false;
};

// Analyse one body. Never throws; an unrecognised architecture yields an empty report rather than a
// pile of false positives, because refusing to compile correct code for an architecture this checker
// has not learned yet would be the worse failure.
AsmReport checkAsm(const std::string& body, const AsmDeclared& declared);

// ---- operand constraints (docs/design/asm-constraints.md §6) ----

// Is `place` something an operand of a block declared for `arch` may be constrained to? Accepts a
// register name, a colon-joined PAIR of them (`"edx:eax"`, high part first), and the two class words
// `"memory"` and `"immediate"`. An empty `place` means nothing was said, which is always fine.
//
// `why` receives a diagnosis when the answer is false -- not a restatement of the rule, but which of
// the several ways it can be wrong this one is. The failure it is really for is not a typo, it is a
// PORT: a block copied from the x86 side with the arch word changed gets every mnemonic checked
// against the new architecture and, without this, its constraints checked against nothing at all.
bool asmPlaceIsValid(const std::string& arch, const std::string& place, std::string* why);

// The register families a constrained operand destroys -- one per part of a pair, empty for a class
// word or an unconstrained operand. Writing `eax` destroys `rax`, which is why this speaks in
// families rather than names; a pair destroys two of them, through the one syntax that names two
// registers at once.
std::vector<std::string> asmPlaceFamilies(const std::string& arch, const std::string& place);

}  // namespace polaron::semantic
