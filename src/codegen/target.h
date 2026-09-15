#pragma once

// WHAT A TARGET'S BYTES LOOK LIKE, as one string, in one place.
//
// A module with no data layout is not "unset" -- it is a module with the WRONG one. LLVM's default
// aligns `i64` to four bytes, so `struct { int; long; boolean }` measures sixteen where the machine
// says twenty-four, and every size the compiler computes from it is short: a `memset` that leaves
// the last field holding whatever was there, a `malloc` that hands back a block the constructor
// writes past the end of. Both of those are silent, and the second one is a kernel that fails
// differently on every boot.
//
// Both backends need the same answer, which is why it lives here rather than inside the one that
// happened to need it first.

#include <llvm/IR/Module.h>

#include <string>

namespace polaron {

// The layout string for `triple`, or empty when LLVM does not name that architecture -- in which
// case the module keeps whatever clang applies downstream, which is correct but invisible to our
// own passes.
//
// EVERY STRING IS READ OUT OF CLANG, not written from memory: `clang --target=T -S -emit-llvm` on an
// empty file prints the layout that target actually uses. A hand-written layout that is subtly wrong
// does not fail -- it silently misaligns.
std::string dataLayoutFor(const std::string& triple);

// Sets both the triple and its layout on `module`. An empty triple means the host, which is what a
// program built with no `--target` runs on.
void applyTarget(llvm::Module& module, const std::string& triple);

// Whether LLVM names the architecture in `triple` at all.
//
// `sh4-unknown-linux-gnu` is a real target and LLVM answers `UnknownArch` for it: it cannot say how
// wide that machine's pointers are, so neither can this compiler, and every width-dependent decision
// downstream would be a guess wearing a target's name. `dataLayoutFor` returning empty is not the
// same thing -- that means "correct, just not visible to our own passes", and is fine.
//
// Asked of the COMMAND LINE, before anything is built, so the refusal names the flag rather than
// arriving much later as wrong code. A guess is what the `address` rule exists to refuse; this
// refuses it at the moment the target is chosen.
bool targetArchIsKnown(const std::string& triple);

// WHETHER THERE IS AN OPERATING SYSTEM UNDER THIS TRIPLE, which decides more than the red zone: it
// decides who supplies the runtime. `program X freestanding;` is a statement about the LANGUAGE
// subset the source may use, and that is not the same question -- a freestanding program is
// regularly compiled for a HOSTED triple and linked against the hosted runtime, which is how
// several of this suite's own samples are run. Asking the keyword instead of the triple put a
// second `__polaron_fail` into those links, and the linker was what noticed.
//
// The rule is `applyBareMetalAttrs`' rule, and it lives here so that the two cannot drift: an arch
// LLVM can name, and either no OS or UEFI -- see the long note below for why UEFI counts.
bool targetIsBareMetal(const std::string& triple);

// BARE METAL HAS NO RED ZONE. Marks every method in `module` `noredzone` when the target names no
// operating system. Call it once, after every body has been emitted -- an attribute cannot be put on
// a function that does not exist yet, which is why this is not folded into `applyTarget`.
//
// The red zone is the 128 bytes BELOW the stack pointer that the System V AMD64 ABI lets a leaf
// method use without moving RSP. It is safe in a hosted program because the operating system
// promises it: the kernel builds a signal frame clear of it. Nothing makes that promise to a
// freestanding program, and worse, the hardware actively breaks it -- an interrupt taken with no
// privilege change pushes RIP/CS/RFLAGS/RSP/SS starting AT the stack pointer and going down, which
// is the red zone, byte for byte. The interrupt stub's own pushes then cover the rest of it.
//
// So on bare metal a leaf method's locals are destroyed by any interrupt that arrives while they are
// live, and what that looks like from the outside is not a crash. The kernel that found this the
// first time spent two days on it: the two things spilled below RSP were POINTERS, the interrupt
// frame replaced them with RFLAGS and the interrupted RSP, and the method read its answer out of the
// saved stack. Every heap canary and DMA redzone came back clean, correctly.
//
// It then found it a SECOND time, through the other backend, and it looked nothing like the first:
// `Bytes.copy` keeps its loop counter at `-0x20(%rsp)`, the timer interrupt overwrote it on nearly
// every tick, and the kernel brought up its drivers, its network and its desktop and then span in an
// eight-byte memcpy for ever. No exception, no fault, no wrong value -- a machine that simply stops.
// TWO BACKENDS, ONE RULE, and the rule lived in only one of them.
//
// This must be set HERE, on the function, and not by passing `-mno-red-zone` to the compiler that
// consumes the IR. That flag is a front-end flag: clang applies it while lowering C or C++, by
// attaching this exact attribute. Handed a .ll file the front end is bypassed, the flag reaches
// nothing, and LLVM's x86 frame lowering asks only one question -- does the function carry
// `noredzone`. It silently compiled the flag and silently ignored it.
//
// "No OS in the triple" is the condition rather than a build-mode flag, because it is the true one:
// the red zone is a promise by an operating system, so a target that names none has nobody to make
// it. A hosted program keeps the red zone and the optimisation it buys.
//
// UEFI IS THE SECOND TARGET THAT QUALIFIES, and it names an OS in the triple, which is why it had to
// be added by hand. `x86_64-unknown-uefi` parses with OS = UEFI, so the rule above let it through and
// a UEFI application was built with the red zone live. UEFI is not an operating system in the sense
// this rule cares about: an EFI application runs in ring 0 on the firmware's own IDT, with interrupts
// enabled and the firmware's timer arriving on whatever stack is current. That interrupt pushes its
// frame starting at RSP and going down -- the red zone, byte for byte -- exactly as it does on bare
// metal. Nobody promises anything; there is only firmware that happens to be running first.
void applyBareMetalAttrs(llvm::Module& module);

// A pointer to a private, null-terminated constant string. LLVM 21 removed
// `IRBuilder::CreateGlobalStringPtr` and made `CreateGlobalString` return the pointer directly;
// older LLVM (17/18, the Windows build) keeps the `*Ptr` spelling -- there `CreateGlobalString`
// returns a `GlobalVariable*`, not a usable pointer. Templated on the builder type so it works with
// any IRBuilder folder/inserter.
//
// Here rather than inside a backend for the same reason as everything else in this header: it is a
// fact about the LLVM being built against, not about which backend is doing the building -- and the
// `--test` runner needs it from outside `CodeGenerator::Impl`.
template <typename B>
llvm::Value* createGlobalStringPtr(B& b, llvm::StringRef s, const llvm::Twine& name = "") {
#if LLVM_VERSION_MAJOR >= 21
    return b.CreateGlobalString(s, name);
#else
    return b.CreateGlobalStringPtr(s, name);
#endif
}

}  // namespace polaron
