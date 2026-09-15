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

void layoutWarning(const SourceLocation& loc, const std::string& message) {
    std::fputs(diag::render("warning", std::string(loc.file), loc.line, loc.col, message,
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
    // THE CONCESSIONS ARE ON THE HEADER, NOT IN THE HOOK, because they answer a different question:
    // `onArrange` says what must be TRUE of the arrangement, `permits` says what the compiler may
    // DO to reach one. A layout with no hook at all still concedes what its header concedes, which
    // is why this is read before the early return below rather than inside the loop.
    out.permitsReorder = layout.permitsReorder;
    out.permitsPadding = layout.permitsPadding;
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
        } else if (what == "resolvedBy") {
            const auto* who = call->args.size() == 1
                                  ? dynamic_cast<const ast::IdentifierExpr*>(call->args[0].get())
                                  : nullptr;
            if (who == nullptr) {
                layoutError(st->loc,
                            "`itself.resolvedBy(...)` names the member that decides the "
                            "arrangement, written as a bare name: `itself.resolvedBy(arrange)`");
                ok = false;
                continue;
            }
            out.resolvedBy = who->name;
        } else {
            layoutError(st->loc,
                        "an `onArrange` block says how the type is arranged, using "
                        "`itself.fitWithin(N bytes)`, `itself.refuse(\"...\")` and "
                        "`itself.resolvedBy(<member>)`. It is read while the program is being built "
                        "and never runs, so ordinary statements have nowhere to happen");
            ok = false;
        }
    }
    return ok;
}

// ---- THE RESOLVER: THE TARGET ARRANGES, THE LAYOUT JUDGES ----
//
// The half of the second design that was missing. `layout`'s own header calls it *an interface for
// memory*, and an interface declares an obligation and the implementer provides it -- until now a
// layout had only constraints, so there was nothing to provide.
//
// THE FIELD-NAMING PROBLEM DOES NOT GET SOLVED HERE, IT DISAPPEARS. Three earlier proposals tried to
// let the LAYOUT talk about the target's fields -- roles bound on the clause, an inline block in the
// type, a modifier on the field -- and all three are unnecessary once the resolver lives on the
// target. `Queue` names `head` and `tail` because they are its own; the layout never sees them and
// does not need to.
//
// FOUR VERBS, and it is four rather than more because a resolver is ordinary comptime code over a
// small vocabulary. The moment it can read the program it becomes a macro system.
bool readResolver(const ast::MethodDecl& resolver, std::vector<Placement>& out) {
    if (resolver.isAbstract) {
        return true;   // an obligation, not a default: the target supplies one or the check reports
    }
    bool ok = true;
    for (const ast::StmtPtr& st : resolver.body.statements) {
        const ast::CallExpr* call = nullptr;
        const std::string what = arrangementCall(st.get(), call);
        Placement step;
        step.loc = st->loc;
        // A FIELD NAME, IN EITHER OF THE TWO SHAPES IT CAN ARRIVE IN.
        //
        // The author writes `itself.place(head)`, and by the time anything reads it that bare name
        // may have become `this.head`: `resolveImplicitThis` runs BEFORE this pass and rewrites
        // every unqualified member reference in every body, which is what makes `head` mean the
        // field in ordinary code. It cannot skip resolvers, because nothing has told it which
        // methods are resolvers yet -- that is decided here, from the layout's `resolvedBy`.
        //
        // Reordering the two passes would settle it and is the wrong trade: `resolveImplicitThis`
        // is what every later pass relies on having run, and moving it after layout resolution to
        // spare four lines here would put the whole compiler in a different order for one feature's
        // convenience. Accepting both spellings is the local cost of a global invariant.
        auto fieldArgument = [&](std::size_t at) -> bool {
            const ast::Expr* arg = call->args.size() > at ? call->args[at].get() : nullptr;
            if (const auto* named = dynamic_cast<const ast::IdentifierExpr*>(arg)) {
                step.field = named->name;
                return true;
            }
            if (const auto* member = dynamic_cast<const ast::MemberExpr*>(arg)) {
                const auto* recv = dynamic_cast<const ast::IdentifierExpr*>(member->object.get());
                if (recv != nullptr && recv->name == "this") {
                    step.field = member->member;
                    return true;
                }
            }
            layoutError(st->loc, "`itself." + what +
                                     "(...)` names a field of this type, written as a bare name -- "
                                     "`itself." + what + "(head)`");
            ok = false;
            return false;
        };
        if (what == "place" || what == "isolate") {
            if (call->args.size() != 1 || !fieldArgument(0)) {
                ok = false;
                continue;
            }
            step.verb = what == "place" ? Placement::Verb::Place : Placement::Verb::Isolate;
        } else if (what == "align") {
            if (call->args.size() != 2 || !fieldArgument(0)) {
                ok = false;
                continue;
            }
            if (!byteCount(call->args[1].get(), step.bytes) || step.bytes <= 0) {
                layoutError(st->loc,
                            "`itself.align(<field>, N bytes)` takes the boundary written out, like "
                            "`64 bytes` -- an offset is decided while the program is being built, so "
                            "it cannot be computed from anything the program will hold");
                ok = false;
                continue;
            }
            step.verb = Placement::Verb::Align;
        } else if (what == "pad") {
            if (call->args.size() != 1 || !byteCount(call->args[0].get(), step.bytes) ||
                step.bytes <= 0) {
                layoutError(st->loc,
                            "`itself.pad(N bytes)` takes the size of the hole, written out");
                ok = false;
                continue;
            }
            step.verb = Placement::Verb::Pad;
        } else {
            layoutError(st->loc,
                        "a resolver says where the bytes go, using `itself.place(f)`, "
                        "`itself.isolate(f)`, `itself.align(f, N bytes)` and `itself.pad(N bytes)`. "
                        "It is read while the program is being built and never runs, so ordinary "
                        "statements have nowhere to happen -- and a resolver that knows in advance "
                        "it cannot succeed says so with `demand ... otherwise \"...\"`, which is the "
                        "language's static assertion and already exists");
            ok = false;
            continue;
        }
        out.push_back(step);
    }
    return ok;
}

namespace {

// The same search, over a mutable declaration, so the flag can be set on what it finds. Kept beside
// `findResolver` rather than sharing a template with it: two short loops read better than one that
// has to be const-generic, and this one exists only for the single pass that marks them.
void markResolver(ast::ClassDecl& holder, const std::string& memberName) {
    for (ast::MemberPtr& m : holder.members) {
        if (auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
            md != nullptr && md->name == memberName) {
            md->isLayoutResolver = true;
        }
    }
}

}  // namespace

const ast::MethodDecl* findResolver(const ast::ClassDecl& target, const ast::ClassDecl& layout,
                                    const std::string& memberName) {
    if (memberName.empty()) {
        return nullptr;
    }
    // THE TARGET'S OWN COMES FIRST, always. `layout.md` §7.1: a member declared with a body on the
    // layout is a DEFAULT the target may override, and overriding is what having one's own means.
    for (const ast::MemberPtr& m : target.members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
            md != nullptr && md->name == memberName && !md->isAbstract) {
            return md;
        }
    }
    for (const ast::MemberPtr& m : layout.members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
            md != nullptr && md->name == memberName && !md->isAbstract) {
            return md;
        }
    }
    return nullptr;
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
                    // The layout's OWN member, when it has one -- a bodied `resolvedBy` target is a
                    // default the target may replace, and it is read rather than analysed for
                    // exactly the same reason the target's own is.
                    if (!discard.resolvedBy.empty()) {
                        markResolver(c, discard.resolvedBy);
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
                // `arranges L` PUT ITS NAMES STRAIGHT INTO `layouts` AT THE PARSE, so unlike the
                // `implements` split below they arrive unvalidated: nothing has yet asked whether
                // `L` names a layout at all, or whether this type is the kind of thing that has a
                // layout of its own. Both questions are answered here, once, for both spellings.
                {
                    std::vector<std::string> keptLayouts;
                    for (const std::string& name : c.layouts) {
                        if (layouts.count(name) == 0) {
                            layoutError(c.loc,
                                        "`arranges` names a layout, and `" + name +
                                            "` is not one. A layout is declared with the word "
                                            "`layout` and decides how the bytes of a value "
                                            "aggregate are placed; an interface is implemented, a "
                                            "transformer is applied, and a base is extended");
                            ok = false;
                            continue;
                        }
                        if (!c.isStruct) {
                            layoutError(c.loc,
                                        "`" + name +
                                            "` is a layout, and a layout arranges a value "
                                            "aggregate -- a struct, a record or a union. `" +
                                            c.name +
                                            "` is reached through a pointer, so its size is not a "
                                            "property of the places it is used");
                            ok = false;
                            continue;
                        }
                        // AN OBLIGATION IS AN OBLIGATION. A layout whose `resolvedBy` names a
                        // member with no body is saying *arrange yourself; I say what it must
                        // cost*, and a target that does not is not arranged at all -- there is no
                        // fallback to the built-in strategy, because the layout has said the
                        // strategy is the target's to choose. Reported here, on the `arranges`
                        // clause, which is the line that took the obligation on.
                        Arrangement want;
                        (void)readArrangement(*layouts.at(name), want);
                        // MARK BEFORE CHECKING, so the exemption lands even on a resolver this
                        // pass is about to complain about: a body that is read rather than analysed
                        // must not also draw the analyser's ordinary errors, or one mistake reports
                        // twice and the second report is about a rule that does not apply here.
                        if (!want.resolvedBy.empty()) {
                            markResolver(c, want.resolvedBy);
                        }
                        if (!want.resolvedBy.empty() &&
                            findResolver(c, *layouts.at(name), want.resolvedBy) == nullptr) {
                            layoutError(c.loc,
                                        "`" + name + "` is resolved by `" + want.resolvedBy +
                                            "`, and declares it without a body -- so `" + c.name +
                                            "` has to provide one: `public comptime method " +
                                            want.resolvedBy +
                                            "() returns void { ... }`, placing every field exactly "
                                            "once. A layout that wanted to decide the arrangement "
                                            "itself would have given the member a body, which is a "
                                            "default rather than an obligation");
                            ok = false;
                            continue;
                        }
                        keptLayouts.push_back(name);
                    }
                    c.layouts = std::move(keptLayouts);
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
                    // THE OLD SPELLING STILL MEANS WHAT IT MEANT, so this is a warning and not a
                    // refusal -- but the word is wrong about the thing, and the sample that used it
                    // needed a comment saying so. `arranges` is the word; naming it here is what
                    // turns a rename into a migration somebody can actually do.
                    layoutWarning(c.loc, "`" + c.name + "` says `implements " + name +
                                             "`, and `" + name +
                                             "` names a layout; write `arranges` instead");
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
