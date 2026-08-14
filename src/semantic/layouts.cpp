#include "semantic/layouts.h"

#include <cstdio>
#include <cstdlib>
#include <map>
#include <string>
#include <utility>
#include <vector>

#include "diag/diagnostic.h"
#include "diag/render.h"

namespace polaron {
namespace {

void layoutError(const SourceLocation& loc, const std::string& message) {
    std::fputs(diag::render("error", std::string(loc.file), loc.line, loc.col, message,
                            diag::classify(message), "", diag::conciseMode())
                   .c_str(),
               stderr);
}

// The byte units, known to the COMPILER rather than looked up in the prelude. A layout has to hold
// in freestanding, where there is no library to hold `System.Memory.Units` -- and the prelude's
// version allocates a ByteSize on the heap to express a constant, which cannot happen at all in a
// block that runs during the build. Reading the unit here costs nothing and works in both modes.
long long unitScale(const std::string& suffix) {
    if (suffix == "bytes") {
        return 1;
    }
    if (suffix == "kilobytes") {
        return 1024LL;
    }
    if (suffix == "megabytes") {
        return 1024LL * 1024;
    }
    if (suffix == "gigabytes") {
        return 1024LL * 1024 * 1024;
    }
    return 0;  // not a byte unit
}

// A byte count written in the hook: `20 bytes`, `1 kilobytes`, or a plain `20`. The suffix parses as
// a call (`bytes(20)`), which is the shape unwound here.
bool byteCount(const ast::Expr* e, long long& out) {
    if (const auto* lit = dynamic_cast<const ast::IntLiteralExpr*>(e)) {
        out = std::strtoll(lit->text.c_str(), nullptr, 0);
        return true;
    }
    const auto* call = dynamic_cast<const ast::CallExpr*>(e);
    if (call == nullptr || call->args.size() != 1) {
        return false;
    }
    const auto* name = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get());
    if (name == nullptr) {
        return false;
    }
    const long long scale = unitScale(name->name);
    if (scale == 0) {
        return false;
    }
    long long n = 0;
    if (!byteCount(call->args[0].get(), n)) {
        return false;
    }
    out = n * scale;
    return true;
}

// `itself.<name>(...)` -- the arrangement being decided. Yields the method name, or "" if the
// statement is not a call on the pronoun.
std::string arrangementCall(const ast::Stmt* st, const ast::CallExpr*& call) {
    const auto* es = dynamic_cast<const ast::ExprStmt*>(st);
    if (es == nullptr) {
        return "";
    }
    call = dynamic_cast<const ast::CallExpr*>(es->expr.get());
    if (call == nullptr) {
        return "";
    }
    const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
    if (mem == nullptr) {
        return "";
    }
    const auto* recv = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
    if (recv == nullptr || recv->name != "itself") {
        return "";
    }
    return mem->member;
}

}  // namespace

bool readArrangement(const ast::ClassDecl& layout, Arrangement& out) {
    if (layout.onArrange == nullptr) {
        return true;  // a layout may carry only helpers
    }
    bool ok = true;
    for (const ast::StmtPtr& st : layout.onArrange->statements) {
        const ast::CallExpr* call = nullptr;
        const std::string what = arrangementCall(st.get(), call);
        if (what == "fitWithin") {
            long long n = 0;
            if (call->args.size() != 1 || !byteCount(call->args[0].get(), n)) {
                layoutError(st->loc,
                            "`itself.fitWithin(...)` takes a byte count written out, like "
                            "`20 bytes` -- the ceiling is decided while the program is being built, "
                            "so it cannot be computed from anything the program will hold");
                ok = false;
                continue;
            }
            out.maxBytes = n;
        } else if (what == "refuse") {
            const auto* msg = call->args.size() == 1
                                  ? dynamic_cast<const ast::StringLiteralExpr*>(call->args[0].get())
                                  : nullptr;
            if (msg == nullptr) {
                layoutError(st->loc, "`itself.refuse(...)` takes the message to report, written out");
                ok = false;
                continue;
            }
            out.refuseMessage = msg->value;
        } else {
            layoutError(st->loc,
                        "an `onArrange` block says how the type is arranged, using "
                        "`itself.fitWithin(N bytes)` and `itself.refuse(\"...\")`. It is read while "
                        "the program is being built and never runs, so ordinary statements have "
                        "nowhere to happen");
            ok = false;
        }
    }
    return ok;
}

bool resolveLayouts(ast::Program& program) {
    std::map<std::string, const ast::ClassDecl*> layouts;
    for (const auto& b : program.bundles) {
        for (const auto& ns : b.namespaces) {
            for (const auto& c : ns.classes) {
                if (c.isLayout) {
                    layouts[c.name] = &c;
                }
            }
        }
    }
    if (layouts.empty()) {
        return true;
    }

    bool ok = true;
    for (auto& b : program.bundles) {
        for (auto& ns : b.namespaces) {
            for (auto& c : ns.classes) {
                if (c.isLayout) {
                    Arrangement discard;
                    if (!readArrangement(c, discard)) {
                        ok = false;
                    }
                    // A layout refines a layout and nothing else: `extends` on one names a kind of
                    // thing it is, and the only kind it can be is another arrangement. `Object` is
                    // skipped because every declaration is given it implicitly -- it is the absence
                    // of an `extends`, not one.
                    if (!c.superclass.empty() && c.superclass != "Object" &&
                        layouts.count(c.superclass) == 0) {
                        layoutError(c.loc, "a layout can only extend another layout; `" +
                                               c.superclass + "` is not one");
                        ok = false;
                    }
                    continue;
                }
                // Split `implements` -- the layouts move out, so nothing downstream mistakes one for
                // an interface and starts looking for methods it was never going to have.
                std::vector<std::string> keptInterfaces;
                std::vector<std::vector<std::string>> keptTypeArgs;
                for (std::size_t i = 0; i < c.interfaces.size(); ++i) {
                    const std::string& name = c.interfaces[i];
                    if (layouts.count(name) == 0) {
                        keptInterfaces.push_back(name);
                        if (i < c.interfaceTypeArgs.size()) {
                            keptTypeArgs.push_back(c.interfaceTypeArgs[i]);
                        } else {
                            keptTypeArgs.emplace_back();
                        }
                        continue;
                    }
                    // Only a value aggregate has a layout of its own at the point of use. A class is
                    // reached through a pointer and carries a vtable slot the author did not write,
                    // so a byte budget over one would be measuring the compiler's decisions.
                    if (!c.isStruct) {
                        layoutError(c.loc,
                                    "`" + name + "` is a layout, and a layout arranges a value "
                                    "aggregate -- a struct, a record or a union. `" + c.name +
                                    "` is reached through a pointer, so its size is not a property "
                                    "of the places it is used");
                        ok = false;
                        continue;
                    }
                    c.layouts.push_back(name);
                }
                c.interfaces = std::move(keptInterfaces);
                c.interfaceTypeArgs = std::move(keptTypeArgs);
            }
        }
    }
    return ok;
}

}  // namespace polaron
