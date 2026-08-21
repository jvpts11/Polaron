#include "pir/shapediff.h"

#include <llvm/IR/Function.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Instructions.h>

#include <algorithm>
#include <map>
#include <set>

namespace polaron::pir {

namespace {

// WHAT A BODY IS MADE OF, with the spelling thrown away.
//
// Three facts, chosen because each one catches a different kind of mistake and none of them changes
// when a backend numbers its values differently:
//
//   * the opcode histogram -- a body that loads where the other stores, or has one `call` where the
//     other has two, differs here;
//   * the call targets -- the receiver-resolution bugs this compiler keeps finding are invisible in
//     the histogram (a call is a call) and unmistakable here;
//   * the block count -- a branch that vanished, or a guard that was not emitted.
struct Shape {
    std::map<std::string, unsigned> opcodes;
    std::map<std::string, unsigned> callees;
    unsigned blocks = 0;
};

Shape shapeOf(const llvm::Function& f) {
    Shape s;
    s.blocks = static_cast<unsigned>(f.size());
    for (const llvm::Instruction& in : llvm::instructions(f)) {
        ++s.opcodes[in.getOpcodeName()];
        if (const auto* call = llvm::dyn_cast<llvm::CallBase>(&in)) {
            // An INDIRECT call has no name and is still a fact: the two paths must agree about which
            // calls go through a table. `<indirect>` is a target like any other here.
            const llvm::Function* target = call->getCalledFunction();
            ++s.callees[target != nullptr ? target->getName().str() : std::string("<indirect>")];
        }
    }
    return s;
}

// The first few entries of `a` that `b` does not match, as text. Reported rather than counted: the
// NAME of the missing call is the whole diagnosis, and a number is a second question.
std::string firstDisagreements(const std::map<std::string, unsigned>& a,
                               const std::map<std::string, unsigned>& b, const char* what) {
    std::string out;
    unsigned shown = 0;
    std::set<std::string> keys;
    for (const auto& [k, _] : a) {
        keys.insert(k);
    }
    for (const auto& [k, _] : b) {
        keys.insert(k);
    }
    for (const std::string& k : keys) {
        const auto ia = a.find(k);
        const auto ib = b.find(k);
        const unsigned na = ia == a.end() ? 0 : ia->second;
        const unsigned nb = ib == b.end() ? 0 : ib->second;
        if (na == nb) {
            continue;
        }
        if (shown == 3) {
            out += ", ...";
            break;
        }
        if (shown != 0) {
            out += ", ";
        }
        out += std::string(what) + " " + k + " " + std::to_string(na) + "->" + std::to_string(nb);
        ++shown;
    }
    return out;
}

}  // namespace

std::vector<ShapeDiff> compareBodies(const llvm::Module& trusted, const llvm::Module& viaPir) {
    std::vector<ShapeDiff> out;
    for (const llvm::Function& a : trusted) {
        if (a.isDeclaration()) {
            continue;
        }
        const llvm::Function* b = viaPir.getFunction(a.getName());
        if (b == nullptr || b->isDeclaration()) {
            continue;   // only one side emits it: see the header for why that is not reported here
        }
        const Shape sa = shapeOf(a);
        const Shape sb = shapeOf(*b);
        std::string why;
        if (sa.callees != sb.callees) {
            why = firstDisagreements(sa.callees, sb.callees, "calls");
        }
        if (why.empty() && sa.opcodes != sb.opcodes) {
            why = firstDisagreements(sa.opcodes, sb.opcodes, "");
        }
        if (why.empty() && sa.blocks != sb.blocks) {
            why = "blocks " + std::to_string(sa.blocks) + "->" + std::to_string(sb.blocks);
        }
        if (!why.empty()) {
            out.push_back(ShapeDiff{a.getName().str(), why});
        }
    }
    std::sort(out.begin(), out.end(),
              [](const ShapeDiff& l, const ShapeDiff& r) { return l.function < r.function; });
    return out;
}

std::string renderShapeDiffs(const std::vector<ShapeDiff>& diffs, size_t bothDefine) {
    std::string out = "pir::shapes: " + std::to_string(bothDefine - diffs.size()) + "/" +
                      std::to_string(bothDefine) + " bodies agree";
    if (diffs.empty()) {
        return out + "\n";
    }
    out += ", " + std::to_string(diffs.size()) + " differ\n";
    // BOUNDED, and it says so. A first run over a real program can differ in hundreds of methods,
    // and a report nobody can read is a report nobody reads; the count above is the number that
    // matters and the list below is where to start.
    size_t shown = 0;
    for (const ShapeDiff& d : diffs) {
        if (shown == 40) {
            out += "  ... and " + std::to_string(diffs.size() - shown) + " more\n";
            break;
        }
        out += "  " + d.function + ": " + d.what + "\n";
        ++shown;
    }
    return out;
}

}  // namespace polaron::pir
