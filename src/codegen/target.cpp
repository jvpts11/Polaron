// What a target's bytes look like. See `target.h`, which carries the reasoning for all three.
//
// These definitions used to sit at the top of `codegen.cpp`, inside the AST-to-LLVM back end, while
// their declarations sat in this shared header -- and `applyBareMetalAttrs`'s own comment records
// what that arrangement cost: TWO BACKENDS, ONE RULE, and the rule lived in only one of them. The
// header was the fix; giving it a body of its own is the rest of that fix, and it is what let the
// back end below it be deleted without taking the rule along.

#include "codegen/target.h"

#include <llvm/TargetParser/Host.h>
#include <llvm/TargetParser/Triple.h>

namespace polaron {

std::string dataLayoutFor(const std::string& triple) {
    const bool windows =
        triple.find("windows") != std::string::npos || triple.find("msvc") != std::string::npos;
    if (triple.find("x86_64") != std::string::npos || triple.find("amd64") != std::string::npos) {
        return windows
                   ? "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
                   : "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128";
    }
    if (triple.find("aarch64") != std::string::npos || triple.find("arm64") != std::string::npos) {
        return windows
                   ? "e-m:w-p270:32:32-p271:32:32-p272:64:64-p:64:64-i32:32-i64:64-i128:128-n32:64-S128-Fn32"
                   : "e-m:e-p270:32:32-p271:32:32-p272:64:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-Fn32";
    }
    if (triple.rfind("armv", 0) == 0 || triple.find("-arm-") != std::string::npos) {
        return "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64";
    }
    if (triple.find("i686") != std::string::npos || triple.find("i386") != std::string::npos) {
        return windows
                   ? "e-m:x-p:32:32-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32-a:0:32-S32"
                   : "e-m:e-p:32:32-p270:32:32-p271:32:32-p272:64:64-i128:128-f64:32:64-f80:32-n8:16:32-S128";
    }
    if (triple.find("wasm32") != std::string::npos) {
        return "e-m:e-p:32:32-p10:8:8-p20:8:8-i64:64-i128:128-n32:64-S128-ni:1:10:20";
    }
    if (triple.find("riscv64") != std::string::npos) {
        return "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128";
    }
    return {};
}

void applyTarget(llvm::Module& module, const std::string& triple) {
    // AN EMPTY TRIPLE IS THE HOST, not "no target". A program built without `--target` runs on this
    // machine, and asking for its layout is the difference between the sizes this compiler computes
    // and the sizes the linker's clang will lay out an object with.
    const std::string want = triple.empty() ? llvm::sys::getDefaultTargetTriple() : triple;
#if LLVM_VERSION_MAJOR >= 21
    module.setTargetTriple(llvm::Triple(want));
#else
    module.setTargetTriple(want);
#endif
    if (const std::string layout = dataLayoutFor(want); !layout.empty()) {
        module.setDataLayout(layout);
    }
}

bool targetArchIsKnown(const std::string& triple) {
    return triple.empty() ||   // no `--target` is the host, which LLVM certainly knows
           llvm::Triple(triple).getArch() != llvm::Triple::UnknownArch;
}

void applyBareMetalAttrs(llvm::Module& module) {
#if LLVM_VERSION_MAJOR >= 21
    const llvm::Triple triple = module.getTargetTriple();
#else
    const llvm::Triple triple(module.getTargetTriple());
#endif
    // An unset triple is the hosted default, and an unparseable arch is not a target we can reason
    // about -- neither is bare metal, so neither gets the attribute.
    if (triple.getArch() == llvm::Triple::UnknownArch) {
        return;
    }
    if (triple.getOS() != llvm::Triple::UnknownOS) {
        return;  // `...-none-elf` parses as no OS
    }
    for (llvm::Function& f : module) {
        if (!f.isDeclaration()) {
            f.addFnAttr(llvm::Attribute::NoRedZone);
        }
    }
}

}  // namespace polaron
