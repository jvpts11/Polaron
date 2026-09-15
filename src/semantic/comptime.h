#pragma once

#include <functional>
#include <string>
#include <unordered_map>
#include <vector>

#include "parser/ast.h"

// Shared compile-time evaluator (spec 28). It folds constant numeric/boolean/char
// expressions, resolving named consts and calls to `comptime` methods (recursively,
// with a step budget). Values are int or double (tagged internally), so both
// `const int`/`static_assert` and `const double` with comptime calls go through the
// same logic. Both the analyzer and the codegen drive it, so the language's notion
// of "what is a compile-time constant" lives in exactly one place.
namespace polaron::comptime {

struct Context {
    // Named namespace-level consts (spec 28.1), by name -> value.
    const std::unordered_map<std::string, long long>* consts = nullptr;   // int/bool/char consts
    const std::unordered_map<std::string, double>* dconsts = nullptr;     // float/double consts
    // `comptime` methods (spec 28.3) indexed by their (simple) name.
    const std::unordered_map<std::string, const ast::MethodDecl*>* methods = nullptr;
    long long steps = 0;                 // work done so far (bounds total loop/recursion work)
    long long stepLimit = 5'000'000;     // hard cap: past this, evaluation fails
    int depth = 0;                       // current comptime-call nesting (bounds native stack)
    int depthLimit = 64;                 // hard cap on recursion depth (avoids stack overflow); kept
                                         // well under the native stack so a runaway is reported, not
                                         // crashed (comptime recursion in practice is shallow)
    // Interned compile-time strings (spec 32.4 string DSLs). A string value is a small index into
    // this pool, so the value type stays register-small and deep comptime recursion does not enlarge
    // the native stack frame.
    std::vector<std::string> strings;
    // Resolves `sizeof(T)` / `T.sizeof()` (spec issue #7) to a byte count, so a size can take part in
    // a constant expression -- `static_assert(sizeof(Beast) <= 20, ...)` is the point.
    //
    // Only whoever knows the TARGET's layout may set this: the codegen, which holds the DataLayout.
    // A caller that would have to guess leaves it unset, and then an expression containing sizeof is
    // simply not constant. A size folded from a second, hand-rolled layout model would be a
    // confident lie the moment the two models drifted, and an assertion that lies is worse than one
    // that cannot run.
    std::function<bool(const std::string& typeName, long long& out)> sizeOfType;
    // Resolves `EnumName.count()` (spec 12.5) to how many constants the enum declares. An enum is a
    // closed set written out in the source, so its size is settled the moment the declaration is
    // parsed -- there is nothing about it a running program could know that the compiler does not.
    // That makes it fit to stand in a `demand`, which is the point: a table keyed by one enum and
    // offset by the size of another can say so at build time instead of renumbering itself in
    // silence when somebody adds a constant.
    //
    // Set by whichever stage holds the enum declarations. Left unset, a count is simply not
    // constant, exactly as an unset sizeOfType makes a size non-constant.
    std::function<bool(const std::string& enumName, long long& out)> enumCount;
    // ...AND WHICH NUMBER EACH MEMBER IS, which is the same fact `enumCount` reads the size of,
    // asked one level in.
    //
    // WHAT IT IS FOR: a protocol between separately compiled images. Horizon's window manager takes
    // an operation as a number; the kernel and the programs are separate freestanding images with
    // no symbol between them, so the numbers are written twice and nothing held the two copies
    // together. Insert a member in the MIDDLE of the enum and every number after it shifts, and
    // twelve programs compiled against the old ones start asking for the operation next door --
    // `raise` becomes `dismiss`, and a click that brings a window forward closes it.
    //
    // `demand cast<int>(WmOp.raise) == 11` is how that stops being possible, and this is what makes
    // that expression constant. Left unset, an ordinal is simply not constant, exactly as an unset
    // `sizeOfType` makes a size non-constant.
    std::function<bool(const std::string& enumName, const std::string& member, long long& out)>
        enumOrdinal;
    // WHICH MACHINE THIS BUILD IS FOR, as a number a `comptime if` can compare.
    //
    // `Machine.Port` is x86: `in` and `out` are instructions aarch64 does not have, and an `asm`
    // block declaring one architecture inside a build for another is a compile error -- correctly,
    // because assembly cannot be ported by the compiler. So one library serving every target must
    // be able to say which arm of itself is the program, and that is `comptime if` over the target
    // (`freestanding-prelude.md` S6) -- with the rule that makes it work: the untaken branch parses
    // and is NOT analysed, so the aarch64 arm may name registers x86 does not have and vice versa.
    //
    // A NUMBER rather than a string, because a `comptime if` compares and comparing strings at build
    // time is a facility this evaluator does not have and does not need one of. The prelude gives
    // the numbers names (`Target.X86`), so no call site writes a bare 1.
    //
    // Left unset -- by a stage that does not know the triple -- makes `__target_arch` simply not
    // constant, exactly as an unset `sizeOfType` makes a size non-constant. It is never guessed: a
    // wrong answer here selects the wrong half of a hardware library.
    std::function<bool(long long& out)> targetArch;
};

// The identifier the prelude reads the target through. A reserved spelling rather than a keyword:
// it is a fact the compiler supplies, exactly like `sizeof`, and the leading underscores say no
// program should be writing it -- `Machine.Target` is where it gets a name people use.
inline constexpr const char* kTargetArchName = "__target_arch";

// ...AND HOW WIDE A POINTER IS ON IT, 64 or 32.
//
// A second fact rather than more architecture numbers, because it is a second question. `in al, dx`
// is the same instruction on i686 and x86_64 -- the I/O space does not change width -- so the two
// are ONE architecture as far as `Machine.Port` is concerned. What differs is the register file and
// the ABI, which is why the `asm` block has to declare `x86_64` on one and `i686` on the other, and
// why a library serving both needs to ask which.
//
// It is also what a kernel wants for its own reasons: a page-table entry, a descriptor, a stack
// frame. Splitting `X86` into `X86_64` and `X86_32` would have answered the asm question and made
// every `comptime if` about the I/O space test two values -- partitioning the library along a line
// the hardware does not have.
inline constexpr const char* kTargetBitsName = "__target_bits";

// The numbering, shared between the compiler and `Machine/Target.pol`. Two places have to agree
// about what 1 means; the other is a table of `fixed int` the prelude declares with these values
// beside a comment pointing here.
enum class TargetArch : long long {
    Other = 0,
    X86 = 1,       // x86_64 and i686 both: the I/O space and `in`/`out` are the same instructions
    Arm64 = 2,
    Arm32 = 3,
    Wasm = 4,
    Riscv = 5,
    M68k = 6,
    PowerPc = 7,
};

// The number for an architecture FAMILY (`cgutil::archFamily`'s answer: "x86_64", "aarch64", ...).
// One function so the mapping lives in one place -- the analyzer and the lowering both need it, and
// two copies of a table like this drift the day somebody adds a target to only one.
long long archCode(const std::string& family);

// How wide a pointer is on this architecture family: 64 or 32. Beside `archCode` because both read
// the same word and a second reading of it somewhere else is a second thing to keep in step.
long long archBits(const std::string& family);

// True when `e` mentions `sizeof` anywhere. Such a condition can only be folded where the target
// layout is known, so the analyzer defers it to the codegen instead of rejecting it (spec 28.2).
bool mentionsSizeof(const ast::Expr& e);

// The dotted type name an expression spells (`Beast`, `app.Beast`), or "" if it is not a plain name.
// `sizeof`'s argument names a type, so it is read rather than evaluated.
std::string typeNameSpelled(const ast::Expr& e);

// Evaluates `e` to a compile-time integer (the result must be int-valued; a
// double result fails). Returns false if it is not such a constant.
bool evalInt(const ast::Expr& e, long long& out, Context& ctx);

// Evaluates `e` to a compile-time double (integers promote). Returns false if it
// is not a compile-time numeric constant.
bool evalDouble(const ast::Expr& e, double& out, Context& ctx);

}  // namespace polaron::comptime
