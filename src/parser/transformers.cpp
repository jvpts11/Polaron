#include "parser/transformers.h"

#include <algorithm>
#include <map>
#include <memory>
#include <set>
#include <string>
#include <utility>
#include <vector>

#include <cctype>
#include <cstdio>

#include "diag/diagnostic.h"
#include "diag/render.h"
#include "parser/monomorphize.h"

namespace polaron {
namespace {

std::size_t g_errors = 0;

void report(const SourceLocation& loc, const std::string& message) {
    ++g_errors;
    std::fputs(diag::render("error", std::string(loc.file), loc.line, loc.col, message,
                            diag::classify(message), "", diag::conciseMode())
                   .c_str(),
               stderr);
}

void warn(const SourceLocation& loc, const std::string& message) {
    std::fputs(diag::render("warning", std::string(loc.file), loc.line, loc.col, message,
                            diag::classify(message), "", diag::conciseMode())
                   .c_str(),
               stderr);
}

// NAMING CONVENTION: `T` + stem + `er`. A transformer is the coupling between two types rather than
// either of them -- an electrical transformer has two windings and is neither -- so it is named for
// the AGENT of the relation, and the `T` says at every use site which of the three list-like clauses
// on a class line you are reading.
//
// The suggestion is generated rather than the rule merely stated, because a warning that only says
// "wrong" costs the reader the rename. `able`/`ible` are trimmed first, which is what makes the
// design note's own examples come out right: Describable -> TDescriber, Convertible -> TConverter,
// Sortable -> TSorter. A name that already ends in `er` keeps its stem: RegionOwner -> TRegionOwner.
std::string conventionalName(const std::string& name) {
    std::string stem = name;
    if (stem.size() > 1 && stem[0] == 'T' && std::isupper(static_cast<unsigned char>(stem[1])) != 0) {
        stem.erase(0, 1);
    }
    auto endsWith = [&](const char* suffix) {
        const std::size_t n = std::char_traits<char>::length(suffix);
        return stem.size() > n && stem.compare(stem.size() - n, n, suffix) == 0;
    };
    if (endsWith("able")) {
        stem.erase(stem.size() - 4);
    } else if (endsWith("ible")) {
        stem.erase(stem.size() - 4);
    } else if (endsWith("er")) {
        stem.erase(stem.size() - 2);
    } else if (endsWith("e")) {
        stem.erase(stem.size() - 1);
    }
    return "T" + stem + "er";
}

bool followsConvention(const std::string& name) {
    if (name.size() < 4 || name[0] != 'T') {
        return false;
    }
    if (std::isupper(static_cast<unsigned char>(name[1])) == 0) {
        return false;
    }
    return name.compare(name.size() - 2, 2, "er") == 0;
}

using Index = std::map<std::string, const ast::ClassDecl*>;

// EVERY transformer of a given name, and where each was declared.
//
// A flat name -> declaration map was wrong and wrong silently: it kept whichever came last, so a
// program declaring its own `TComparer` beside the standard library's had one of them quietly
// discarded. The failure did not name the collision -- it reported the user's class for not
// implementing `compareTo`, a socket belonging to a transformer that class never mentioned.
//
// The same shape as the `Digest` collision found the same day in class lookup, in a second index
// that had not learned the lesson. A name is resolved against WHERE THE ASKER IS, so the candidates
// have to survive indexing.
struct TransformerEntry {
    const ast::ClassDecl* decl = nullptr;
    std::string ns;
    std::string bundle;
};
using AllTransformers = std::map<std::string, std::vector<TransformerEntry>>;

AllTransformers indexAllTransformers(const ast::Program& program) {
    AllTransformers out;
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& ns : b.namespaces) {
            for (const ast::ClassDecl& t : ns.transformers) {
                out[t.name].push_back({&t, ns.name, b.name});
            }
        }
    }
    return out;
}

// The flat view one namespace sees, so the rest of this pass goes on asking a plain question.
//
// Precedence is the one class lookup settled on, and for the same reasons: your own namespace, then
// your own bundle, then the standard library -- which is last because it is the one body of code
// everybody can see and so the one least likely to be what a bare name meant. A name that is still
// ambiguous after all three is left OUT of the view rather than guessed at, and the `applies` clause
// that named it reports it as unknown.
Index viewFor(const AllTransformers& all, const std::string& nsName, const std::string& bundleName) {
    Index out;
    for (const auto& [name, entries] : all) {
        const TransformerEntry* best = nullptr;
        int bestRank = 99;
        bool tied = false;
        for (const TransformerEntry& e : entries) {
            const int rank = (e.ns == nsName && e.bundle == bundleName) ? 0
                             : (e.bundle == bundleName)                 ? 1
                             : (e.bundle == "System")                   ? 3
                                                                        : 2;
            if (rank < bestRank) {
                best = &e;
                bestRank = rank;
                tied = false;
            } else if (rank == bestRank && best != nullptr && best->decl != e.decl) {
                tied = true;
            }
        }
        if (best != nullptr && !tied) {
            out[name] = best->decl;
        }
    }
    return out;
}

// Every interface's method names, inherited ones included. Read only by the `satisfies` clause, to
// mark the procedures it turns into implementations: a member that answers an interface must say
// `override`, and one the compiler copied in has nobody to write the word.
std::map<std::string, std::set<std::string>> indexInterfaceMethods(const ast::Program& program) {
    std::map<std::string, const ast::ClassDecl*> ifaces;
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& ns : b.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                if (c.isInterface) {
                    ifaces[c.name] = &c;
                }
            }
        }
    }
    std::map<std::string, std::set<std::string>> out;
    // Small and finite, so the transitive closure is taken by iterating to a fixed point rather than
    // by a recursion that has to guard against an interface cycle.
    for (const auto& [name, decl] : ifaces) {
        for (const ast::MemberPtr& m : decl->members) {
            if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
                out[name].insert(md->name);
            }
        }
    }
    for (std::size_t pass = 0; pass < ifaces.size(); ++pass) {
        bool grew = false;
        for (const auto& [name, decl] : ifaces) {
            for (const std::string& base : decl->interfaces) {
                auto bi = out.find(base);
                if (bi == out.end()) {
                    continue;
                }
                for (const std::string& mn : bi->second) {
                    if (out[name].insert(mn).second) {
                        grew = true;
                    }
                }
            }
        }
        if (!grew) {
            break;
        }
    }
    return out;
}

// The names declared with `layout`. Needed because this pass runs BEFORE `resolveLayouts`, so a
// pinned layout is still sitting in the type's `implements` list looking like an interface.
std::set<std::string> indexLayouts(const ast::Program& program) {
    std::set<std::string> out;
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& ns : b.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                if (c.isLayout) {
                    out.insert(c.name);
                }
            }
        }
    }
    return out;
}

const ast::MethodDecl* asMethod(const ast::MemberPtr& m) {
    return dynamic_cast<const ast::MethodDecl*>(m.get());
}

// The full set of transformers a type ends up with, following `transformer A applies B`.
//
// APPLYING TWICE IS APPLYING ONCE, so this is a set union deduped by name and a diamond never
// forms. That is not a simplification -- a transformer has no constructor, no state of its own and
// no ordered initialization, so there is nothing an order could decide. Cycles are finite for the
// same reason and are simply absorbed.
void closure(const std::string& name, const Index& index, std::vector<std::string>& order,
             std::set<std::string>& seen) {
    if (!seen.insert(name).second) {
        return;
    }
    auto it = index.find(name);
    if (it == index.end()) {
        return;  // unknown: reported at the `applies` line that named it
    }
    for (const std::string& carried : it->second->applies) {
        closure(carried, index, order, seen);
    }
    order.push_back(name);
}

// Does this type mention `itself` -- directly, or as an argument of a generic?
bool namesItself(const ast::TypeRef& t) {
    if (t.name == "itself") {
        return true;
    }
    for (const std::string& a : t.typeArgs) {
        if (a == "itself") {
            return true;
        }
    }
    return false;
}

// THE SUBJECT RULE, and the two words that need a job to be worth writing.
//
// An action lives in a method or a procedure, and both have a subject. That is the same rule that
// turned namespace-level `static_assert` into `demand`: an imperative about nothing in particular,
// in a place where only declarations belong. An INSTANCE procedure has its subject in the receiver.
// A STATIC one does not, so it has to name it:
//
//     static procedure from(Other value) returns itself   -- about the applying type. Legal.
//     static procedure max(int a, int b) returns int      -- names no subject. It is `static_assert`
//                                                            in a new suit, and is refused.
//
// `static procedure empty() returns itself` is legal and is NOT merely a static constructor by
// another name -- that was the last question the design note left open. A static constructor belongs
// to one type and is written on it; this is written once and every applying type has it. The
// difference is between a member and a mould, which is the difference the whole declaration is for.
void checkTransformerShape(const ast::ClassDecl& t, const Index& index) {
    for (const ast::MemberPtr& m : t.members) {
        const ast::MethodDecl* md = asMethod(m);
        if (md == nullptr || !md->isStatic) {
            continue;
        }
        bool mentions = namesItself(md->returnType);
        for (const ast::Param& p : md->params) {
            if (namesItself(p.type)) {
                mentions = true;
            }
        }
        if (!mentions) {
            report(md->loc,
                   "`static procedure " + md->name + "` names no subject: nothing in its signature "
                   "mentions `itself`, so it is not about the type that applies this transformer. An "
                   "action belongs to a subject -- give it one (`returns itself`, or a parameter of "
                   "that type), or make it a static method on a class, where it has an owner.");
        }
    }
    // A word that changes nothing is worse than no word: it reads as a promise. `collective` promises
    // a relation over the appliers, and only a per-target family carries one.
    if (t.isCollectiveTransformer) {
        bool hasFamily = false;
        std::vector<std::string> carried;
        std::set<std::string> seen;
        closure(t.name, index, carried, seen);
        for (const std::string& cn : carried) {
            auto ci = index.find(cn);
            if (ci == index.end()) {
                continue;
            }
            for (const ast::MemberPtr& m : ci->second->members) {
                const ast::MethodDecl* md = asMethod(m);
                if (md != nullptr && md->isEachFamily && !md->isStatic) {
                    hasFamily = true;
                }
            }
        }
        if (!hasFamily) {
            report(t.nameLoc.line != 0 ? t.nameLoc : t.loc,
                   "transformer '" + t.name + "' is `collective`, which says every type that applies "
                   "it can become every other -- and it declares no per-target family for them to "
                   "become each other THROUGH. Declare one (`procedure into<each Other>() returns "
                   "Other;`), or drop the word.");
        }
        // `collective` requires the relation to be complete, and completeness already contains every
        // reverse `mutual` would demand. Saying both is not wrong, it is just one of them doing
        // nothing -- and a modifier that does nothing is exactly what the modifier table forbids.
        if (t.isMutualTransformer) {
            warn(t.nameLoc.line != 0 ? t.nameLoc : t.loc,
                 "transformer '" + t.name + "' is both `mutual` and `collective`, and `collective` "
                 "already implies it: a complete relation contains the way back from every pair. "
                 "Drop `mutual`.");
        }
    }
}

// `explicit` buys back the readability that transport costs: a transformer marked this way always
// appears on the class line, so a grep for `applies RegionOwner` finds everyone who has it.
void checkTransport(const ast::ClassDecl& carrier, const Index& index) {
    for (std::size_t i = 0; i < carrier.applies.size(); ++i) {
        auto it = index.find(carrier.applies[i]);
        if (it == index.end() || !it->second->isExplicitTransformer) {
            continue;
        }
        report(i < carrier.appliesLocs.size() ? carrier.appliesLocs[i] : carrier.loc,
               "transformer '" + carrier.applies[i] + "' is `explicit`, so it may only be applied "
               "directly by a type -- '" + carrier.name + "' is a transformer, and carrying it would "
               "put it inside types whose class line never names it. Apply it on each type instead.");
    }
}

// Copies one transformer's members into a type. The substitution is the whole trick: inside a
// transformer `itself` is THE TYPE THAT WILL APPLY THIS, a type that does not exist yet, so binding
// it here is what completes a procedure's signature at the applying type.
void applyOne(const ast::ClassDecl& t, const std::string& targetName,
              std::vector<ast::MemberPtr>& members, const SourceLocation& appliesLoc,
              const std::vector<std::string>& appliedHere) {
    // What the type already writes for itself. A procedure it implements REPLACES the transformer's
    // body rather than colliding with it -- that is the point of a bodied procedure being "free and
    // replaceable".
    std::set<std::string> own;
    for (const ast::MemberPtr& m : members) {
        if (const ast::MethodDecl* md = asMethod(m)) {
            own.insert(md->name);
        } else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            own.insert(fd->name);
        }
    }
    std::map<std::string, std::string> subst{{"itself", targetName}};
    for (const ast::MemberPtr& m : t.members) {
        const ast::MethodDecl* md = asMethod(m);
        const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get());
        const std::string name = md != nullptr ? md->name : (fd != nullptr ? fd->name : std::string());
        if (name.empty()) {
            continue;
        }
        // `when itself applies TComparer` -- MORE FOR A TYPE THAT HAS MORE. Until this clause,
        // `applies` was all-or-nothing: every applier got the same equipment, so a transformer that
        // could do better for a type with an ordering had to either demand the ordering of everybody
        // or give it to nobody. A condition that does not hold means the member is simply not here,
        // which is the honest outcome -- not a body that exists and fails.
        if (md != nullptr && !md->whenTransformer.empty()) {
            if (md->whenSubject != "itself") {
                report(md->whenLoc,
                       "`when " + md->whenSubject + " applies ...` -- the only subject a condition "
                       "can have here is `itself`, the type that applies this transformer. A "
                       "condition about a per-target type parameter would have to be decided once "
                       "per target, and that is a different rule than this one.");
                continue;
            }
            bool holds = false;
            for (const std::string& applied : appliedHere) {
                if (applied == md->whenTransformer) {
                    holds = true;
                }
            }
            if (!holds) {
                continue;
            }
        }
        // A PER-TARGET SOCKET names a family, so it is answered by any member of it: a type that
        // can convert to one thing has satisfied `into<each Other>`. Nothing here can know how many
        // targets it ought to reach -- that is the program's business, and `mutual` is the only
        // rule that says more.
        if (md != nullptr && md->isAbstract && md->isEachFamily) {
            bool answered = false;
            for (const std::string& n : own) {
                if (n.rfind(name + "$", 0) == 0) {
                    answered = true;
                }
            }
            if (!answered) {
                report(appliesLoc,
                       "'" + targetName + "' applies transformer '" + t.name + "', which requires "
                       "`procedure " + name + "<each ...>`, and implements it for no target. It "
                       "names a family: supply at least one, e.g. `procedure " + name +
                       "<SomeType>(...)`.");
            }
            continue;
        }
        if (md != nullptr && md->isAbstract) {
            // A SOCKET. The applying type must answer it, and the error lands on the `applies` line
            // because that line is where the obligation was taken on -- not inside the transformer,
            // which is correct and is somebody else's file.
            if (own.count(name) == 0) {
                report(appliesLoc,
                       "'" + targetName + "' applies transformer '" + t.name + "', which requires "
                       "`procedure " + name + "`, and does not implement it. A procedure with no "
                       "body is a socket: the transformer writes the algorithm and the type supplies "
                       "this part.");
            }
            continue;   // nothing to copy: the type's own body is the implementation
        }
        // A SECOND COPY UNDER `T$p`, always, for `call T.p()` to reach. The transformer's own body
        // has to survive the type replacing it -- that is the entire meaning of the word: *"my type
        // replaced this, and I want the original anyway."* Copied unconditionally rather than only
        // when overridden, so `call` means one thing whether or not the type happened to override.
        if (md != nullptr && !md->isStatic) {
            auto twin = cloneMemberSubst(m.get(), subst);
            auto* tm = dynamic_cast<ast::MethodDecl*>(twin.get());
            tm->name = t.name + "$" + name;
            tm->isProcedure = false;   // it is reached by `call`, never written by hand
            tm->visibility = "private";
            // The `call` alias is a second copy of the same body, so it carries the same bound target
            // and owes the same consent. Missed once, and the symptom said nothing about a second
            // copy: the type was reported as not entrusting the empty string.
            if (!tm->boundTarget.empty() && tm->boundTargetVia.empty()) {
                tm->boundTargetVia = t.name;
            }
            if (tm->fromTransformer.empty()) {
                tm->fromTransformer = t.name;
            }
            if (t.isFreestandingTransformer) {
                tm->freestandingFrom = t.name;
            }
            members.push_back(std::move(twin));
        }
        if (own.count(name) > 0) {
            // FIELD COLLISIONS ARE AN ERROR, FULL STOP -- a type cannot "implement" a field to break
            // the tie, and silently keeping one of the two would give the object storage under a
            // name that means something else. Methods are different: replacing a bodied procedure is
            // the feature.
            if (fd != nullptr) {
                report(appliesLoc,
                       "transformer '" + t.name + "' brings the field '" + name + "', and '" +
                           targetName + "' already declares one by that name. A field cannot be "
                           "overridden the way a procedure can -- rename one of them.");
            }
            // `final procedure` SEALS A BODY. Calls between procedures inside a transformer dispatch
            // to the applied version, which is what makes the feature useful and is also what makes
            // this word necessary: without a way to say "not this one", a type can replace the step
            // the algorithm depends on and the transformer still gets the blame. Refused here rather
            // than in the analyzer because after expansion there are not two members to compare --
            // the type's own body is the only one left, and nothing downstream can tell it ever
            // stood in for something.
            if (md != nullptr && md->isFinal) {
                report(appliesLoc,
                       "transformer '" + t.name + "' declares `final procedure " + name + "`, so '" +
                           targetName + "' may not replace it. `final` on a procedure exists "
                           "because the transformer's other procedures call this one and get the "
                           "APPLIED version -- sealing it is how an algorithm keeps a step it "
                           "depends on. Rename this one, or ask the transformer's author to unseal "
                           "it.");
            }
            continue;
        }
        auto copy = cloneMemberSubst(m.get(), subst);
        // POINT THE COPY AT THE `applies` LINE, not at the transformer. Every later diagnostic about
        // this member -- definite release on an applied `region`, definite assignment on an applied
        // field -- now lands where the obligation was taken on, in the reader's own file. Measured
        // rather than assumed: forgetting to release an applied region already errors, correctly,
        // via the check built for ordinary fields; it just pointed into somebody else's source.
        copy->loc = appliesLoc;
        // THE BARE-METAL SUBSET TRAVELS WITH THE BODY. Marked on the copy rather than checked at the
        // transformer, because the transformer's own bodies are never analyzed -- `itself` is not a
        // type yet, so there is nothing to resolve them against. Once the body is inside a real type
        // it can be checked properly, and the whole existing freestanding gate applies to it: string
        // interpolation, exceptions, await, unimport, `Test`, `Console`. One gate, not a second
        // hand-written list that drifts out of date.
        if (t.isFreestandingTransformer) {
            if (auto* cm = dynamic_cast<ast::MethodDecl*>(copy.get())) {
                cm->freestandingFrom = t.name;
            }
        }
        // WHOSE PROCEDURE THIS WAS, kept on the copy. A bound target's consent is given to a NAMED
        // transformer, and after the copy the body is an ordinary member of the type with nothing
        // left saying where it came from -- so the one thing the consent check needs is stamped here,
        // at the only moment both facts are in hand.
        if (auto* cm = dynamic_cast<ast::MethodDecl*>(copy.get()); cm != nullptr) {
            if (!cm->boundTarget.empty() && cm->boundTargetVia.empty()) {
                cm->boundTargetVia = t.name;
            }
            if (cm->fromTransformer.empty()) {
                cm->fromTransformer = t.name;
            }
        }
        members.push_back(std::move(copy));
        own.insert(name);
    }
}

// `method` where a transformer said `procedure`, and `procedure` where no transformer said
// anything. Checked in both directions so PROVENANCE SURVIVES A TERMINAL: open the file in a diff or
// a review and you can see what came from a transformer and what is the type's own. This is what
// Java's `@Override` tries to be and fails at, because it can be omitted.
void checkProvenance(std::vector<ast::MemberPtr>& members, const std::vector<std::string>& applied,
                     const Index& index) {
    std::set<std::string> broughtIn;
    for (const std::string& tn : applied) {
        auto it = index.find(tn);
        if (it == index.end()) {
            continue;
        }
        for (const ast::MemberPtr& m : it->second->members) {
            if (const ast::MethodDecl* md = asMethod(m)) {
                broughtIn.insert(md->name);
            }
        }
    }
    for (const ast::MemberPtr& m : members) {
        auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
        if (md == nullptr) {
            continue;
        }
        // `into$Fahrenheit` is one member of the family `into<each Other>`, so it carries the
        // family's provenance -- otherwise the bound name looks like a procedure nobody declared.
        const bool fromTransformer =
            broughtIn.count(md->name) > 0 ||
            (md->isEachFamily && broughtIn.count(md->name.substr(0, md->name.find('$'))) > 0);
        if (md->isProcedure && !fromTransformer) {
            report(md->loc,
                   "'" + md->name + "' is written as a `procedure`, but no transformer this type "
                   "applies declares it. A procedure's signature is completed by the transformer "
                   "that declared it; with none, this is an ordinary `method`.");
        }
        if (!md->isProcedure && fromTransformer) {
            report(md->loc,
                   "'" + md->name + "' comes from a transformer this type applies, so it is written "
                   "`procedure`, not `method`. The word is what makes the provenance readable "
                   "without an editor.");
        }
    }
}

// The rules `call` carries, checked where the parser recorded each site.
//
// VISIBILITY IS NOT ONE OF THEM, and that is worth stating because it was once implemented as if it
// were. A procedure's visibility says what the member becomes IN THE APPLYING CLASS -- it is not
// about who may reach into the transformer, because nobody can reach into one at all. So it cannot
// also gate `call`; and since a procedure is private by DEFAULT, a rule that let visibility deny
// `call` would have disabled the second of the feature's two operations in the ordinary case.
//
// What restricts `call` is the subject: it is legal only inside a declaration that applies the
// transformer, because outside one there is no receiver for it to be about.
void checkProcCalls(const std::string& targetName,
                    const std::vector<ast::ClassDecl::ProcCall>& procCalls,
                    const std::vector<std::string>& applied, const Index& index) {
    const std::set<std::string> reachable(applied.begin(), applied.end());
    for (const ast::ClassDecl::ProcCall& pc : procCalls) {
        if (reachable.count(pc.transformer) == 0) {
            report(pc.loc,
                   "`call " + pc.transformer + "." + pc.procedure + "` is only legal inside a "
                   "declaration that applies '" + pc.transformer + "', and '" + targetName +
                   "' does not. Outside one it would be an action with no subject.");
            continue;
        }
        auto it = index.find(pc.transformer);
        if (it == index.end()) {
            continue;
        }
        const ast::MethodDecl* found = nullptr;
        for (const ast::MemberPtr& m : it->second->members) {
            if (const ast::MethodDecl* md = asMethod(m); md != nullptr && md->name == pc.procedure) {
                found = md;
            }
        }
        if (found == nullptr) {
            report(pc.loc, "transformer '" + pc.transformer + "' declares no procedure '" +
                               pc.procedure + "'");
            continue;
        }
        if (found->isAbstract) {
            report(pc.loc,
                   "`call " + pc.transformer + "." + pc.procedure + "` has nothing to reach: '" +
                       pc.procedure + "' is a socket, so the transformer supplies no body for it. "
                       "Call it on the receiver instead -- `this." + pc.procedure + "()` -- which "
                       "is this type's own implementation.");
        } else if (found->isStatic) {
            report(pc.loc, "`call` reaches an instance procedure; '" + pc.procedure +
                               "' is static, so write `" + targetName + "." + pc.procedure + "()`");
        }
    }
}

// The `each` families an applied transformer declares, and the socket that declares each one.
std::map<std::string, const ast::MethodDecl*> eachFamilies(const std::vector<std::string>& applied,
                                                           const Index& index,
                                                           std::map<std::string, std::string>* owner) {
    std::map<std::string, const ast::MethodDecl*> out;
    for (const std::string& tn : applied) {
        auto it = index.find(tn);
        if (it == index.end()) {
            continue;
        }
        for (const ast::MemberPtr& m : it->second->members) {
            if (const ast::MethodDecl* md = asMethod(m); md != nullptr && md->isEachFamily) {
                out[md->name] = md;
                // WHICH transformer declared the family, recorded because a bound target's consent
                // is given to a named transformer and not to assembly in general. Without it the
                // check could only ask "does this type entrust ANYBODY", which is a different and
                // much weaker sentence than the one on the class line.
                if (owner != nullptr) {
                    (*owner)[md->name] = tn;
                }
            }
        }
    }
    return out;
}

// `procedure into<Fahrenheit>() returns Fahrenheit` -- the target is a CONCRETE type, not a
// parameter, so there is nothing generic left to instantiate. Renamed to `into$Fahrenheit`, which
// is exactly what the generic call `c.into<Fahrenheit>()` is rewritten to by monomorphization.
//
// Done HERE and not in the parser, because only here is it known whether the name belongs to an
// `each` family: the socket that says so lives in a transformer, possibly in another file. That is
// the whole reason the marker is on the socket rather than inferred from the argument's spelling.
void bindEachTargets(std::vector<ast::MemberPtr>& members,
                     const std::map<std::string, const ast::MethodDecl*>& families,
                     const std::map<std::string, std::string>& familyOwner) {
    if (families.empty()) {
        return;
    }
    for (const ast::MemberPtr& m : members) {
        auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
        if (md == nullptr || !md->isProcedure || md->typeParams.empty()) {
            continue;
        }
        auto f = families.find(md->name);
        if (f == families.end()) {
            continue;
        }
        if (md->typeParams.size() != 1) {
            report(md->loc, "`procedure " + md->name + "` implements a per-target family, so it "
                            "binds exactly one target type");
            continue;
        }
        // A BOUND TARGET BECOMES A LOCAL, and the storage it starts as is the point. Prepended here,
        // where the target type is still known -- the name is about to be mangled into `into$X` and
        // the type parameter cleared, and after that nothing downstream could work out what `f` is.
        //
        // No constructor runs over it. The body IS the construction, which is what `entrusts` on the
        // target agreed to, and the analyzer holds it to the same completeness the target's own
        // constructor would owe.
        if (!md->boundTarget.empty()) {
            md->boundTargetType = md->typeParams[0];
            auto owner = familyOwner.find(md->name);
            md->boundTargetVia = owner == familyOwner.end() ? std::string() : owner->second;
            auto storage = std::make_unique<ast::NewExpr>();
            storage->loc = md->boundTargetLoc;
            storage->className = md->boundTargetType;
            storage->location = "stack";
            storage->blank = true;
            auto decl = std::make_unique<ast::VarDeclStmt>();
            decl->loc = md->boundTargetLoc;
            decl->name = md->boundTarget;
            decl->type.name = md->boundTargetType;
            decl->isMutable = md->boundTargetMutable;
            decl->init = std::move(storage);
            md->body.statements.insert(md->body.statements.begin(), std::move(decl));
        }
        md->name = ast::mangleGeneric(md->name, md->typeParams);
        md->typeParams.clear();      // the argument is already concrete
        md->typeParamBounds.clear();
        md->isEachFamily = true;     // remembered for `mutual` and for provenance
    }
}

// `transformer T satisfies I` -- whoever applies T implements I, and T's procedures are the
// implementation.
//
// WITHOUT THIS the common case is written twice. A transformer supplies the bodies; an interface
// makes the type polymorphic; and every applying type had to carry both clauses with nothing saying
// the second answers the first. The transformer is where the relation is known -- it is the
// declaration that knows its procedures ARE that interface's methods -- so it is where the promise
// belongs.
//
// The interface is pushed onto the applying type's own `implements` list, which means every existing
// check runs unchanged: the analyzer verifies the type really satisfies it, the vtable is built the
// usual way, and `X is I` answers yes. Nothing downstream learns a new concept.
std::vector<std::string> applySatisfies(const std::vector<std::string>& order, const Index& index,
                                        const std::string& targetName,
                                        std::vector<std::string>* interfaces,
                                        const SourceLocation& where) {
    std::vector<std::string> added;
    for (const std::string& tn : order) {
        auto it = index.find(tn);
        if (it == index.end() || it->second->satisfies.empty()) {
            continue;
        }
        if (interfaces == nullptr) {
            // An enum implements CATALOGS, not interfaces -- a catalog is an interface for enums
            // precisely because an enum's constants are values rather than instances. Said here
            // rather than letting the interface land on a declaration that cannot carry one.
            report(where,
                   "transformer '" + tn + "' satisfies '" + it->second->satisfies.front() +
                       "', so it may only be applied by a type that can implement an interface -- "
                       "and '" + targetName + "' is an enum, which implements catalogs instead. "
                       "Apply a transformer without a `satisfies` clause, or make this a class.");
            continue;
        }
        for (const std::string& iface : it->second->satisfies) {
            added.push_back(iface);
            bool already = false;
            for (const std::string& have : *interfaces) {
                if (have == iface) {
                    already = true;
                }
            }
            if (!already) {
                interfaces->push_back(iface);
            }
        }
    }
    return added;
}

// A procedure that answers an interface method IS an override, and has to say so -- the analyzer
// requires the word of every member that overrides one, and nobody can write it here: the member was
// copied in by the compiler, so the compiler is what marks it.
//
// ONLY THE COPIES, identified by position rather than by a flag. `isProcedure` is deliberately not
// carried by the cloner -- inside the applying type the procedure has stopped being a socket and
// become an ordinary method -- so there is nothing on a copy that says it was one. What there is, is
// where it sits: everything from `firstCopy` onwards was appended by this expansion. Marking by name
// alone would be wrong in the other direction, silently excusing a member the type wrote itself from
// a word it does owe.
void markSatisfiedOverrides(std::vector<ast::MemberPtr>& members, std::size_t firstCopy,
                            const std::vector<std::string>& satisfied,
                            const std::map<std::string, std::set<std::string>>& ifaceMethods) {
    if (satisfied.empty()) {
        return;
    }
    std::set<std::string> wanted;
    for (const std::string& iface : satisfied) {
        auto it = ifaceMethods.find(iface);
        if (it != ifaceMethods.end()) {
            wanted.insert(it->second.begin(), it->second.end());
        }
    }
    for (std::size_t i = 0; i < members.size(); ++i) {
        auto* md = dynamic_cast<ast::MethodDecl*>(members[i].get());
        if (md == nullptr || md->isStatic || md->isAbstract || wanted.count(md->name) == 0) {
            continue;
        }
        // Either a copy, or a `procedure` the type wrote to replace one. The second case matters and
        // is not a loosening: `override` exists so that answering something inherited is visible, and
        // on a replacement the word `procedure` already says that -- it is checked in both directions
        // and cannot be omitted. Demanding `override` as well would be demanding a word about an
        // interface that never appears on this class line. A `method` the type wrote itself is
        // untouched here and still owes the word.
        if (i >= firstCopy || md->isProcedure) {
            md->isOverride = true;
        }
    }
}

// The expansion itself, over whichever declaration's parts. Written against the pieces rather than
// against `ClassDecl` because an ENUM applies transformers too and has no class to be: it has
// members and an `applies` clause, which is all of it that this pass ever touched.
void expandCore(const std::string& targetName, std::vector<ast::MemberPtr>& members,
                const std::vector<std::string>& applies,
                const std::vector<SourceLocation>& appliesLocs, const SourceLocation& declLoc,
                bool hasLayout, std::vector<std::string>* interfaces,
                const std::vector<ast::ClassDecl::ProcCall>& procCalls, const Index& index,
                const std::map<std::string, std::set<std::string>>& ifaceMethods,
                std::vector<std::string>* closureOut) {
    std::vector<std::string> order;
    std::set<std::string> seen;
    // Whatever this pass works out about what the type applies, it hands back before returning --
    // by every exit, including the empty one. A `<T applies TComparer>` constraint is checked long
    // after transformers have left the tree, so the closure computed here is the only record that
    // survives, and a path that forgets to write it reports a type as applying nothing.
    struct HandBack {
        std::vector<std::string>* out;
        const std::vector<std::string>& order;
        ~HandBack() {
            if (out != nullptr) {
                *out = order;
            }
        }
    } handBack{closureOut, order};
    // Provenance runs even with NO `applies`, and that half is the one that keeps the word honest:
    // a `procedure` on a type that applies nothing has no transformer to complete its signature, so
    // without this check `procedure` would quietly decay into a synonym for `method`.
    if (applies.empty()) {
        checkProvenance(members, order, index);
        // `call` with nothing applied: reported, not ignored
        checkProcCalls(targetName, procCalls, order, index);
        return;
    }
    for (std::size_t i = 0; i < applies.size(); ++i) {
        if (index.count(applies[i]) == 0) {
            report(i < appliesLocs.size() ? appliesLocs[i] : declLoc,
                   "unknown transformer '" + applies[i] + "'");
            continue;
        }
        closure(applies[i], index, order, seen);
    }
    // BEFORE anything reads the member names: after this, `into<Fahrenheit>` IS `into$Fahrenheit`,
    // and provenance, socket satisfaction and `mutual` all read one consistent set of names.
    std::map<std::string, std::string> familyOwner;
    const std::map<std::string, const ast::MethodDecl*> families =
        eachFamilies(order, index, &familyOwner);
    bindEachTargets(members, families, familyOwner);
    checkProvenance(members, order, index);
    checkProcCalls(targetName, procCalls, order, index);
    const std::vector<std::string> satisfied = applySatisfies(
        order, index, targetName, interfaces, appliesLocs.empty() ? declLoc : appliesLocs[0]);
    const std::size_t firstCopy = members.size();   // everything after this was appended by us
    for (const std::string& tn : order) {
        auto it = index.find(tn);
        if (it == index.end()) {
            continue;
        }
        // A LAYOUT IS AN ABI. `Dirent` exists to match the bytes Linux expects, so a transformer
        // that brings a field would break it silently -- the one interaction in the language where
        // "purely additive" is false.
        if (hasLayout) {
            bool bringsField = false;
            for (const ast::MemberPtr& m : it->second->members) {
                if (dynamic_cast<const ast::FieldDecl*>(m.get()) != nullptr) {
                    bringsField = true;
                }
            }
            if (bringsField) {
                report(declLoc,
                       "'" + targetName + "' has a pinned layout, which is an ABI, and transformer '" +
                           tn + "' brings a field -- applying it would move the bytes something "
                           "outside this program is matching. A type with a layout may only apply "
                           "field-less transformers.");
                continue;
            }
        }
        applyOne(*it->second, targetName, members, appliesLocs.empty() ? declLoc : appliesLocs[0],
                 order);
    }
    // AFTER the copies exist, so the members it marks are there to mark.
    markSatisfiedOverrides(members, firstCopy, satisfied, ifaceMethods);
}

// ---- Structural bodies: `comptime foreach (field in itself.fields) { ... }` -----------------------

// The fields of a type, INHERITED FIRST and then its own, which is the order a constructor fills
// them and therefore the order anything derived from the shape should walk them.
void collectFields(const ast::ClassDecl& c,
                   const std::map<std::string, const ast::ClassDecl*>& index,
                   std::vector<const ast::FieldDecl*>& out, int depth = 0) {
    if (depth > 32) {
        return;   // a cyclic hierarchy is reported elsewhere; do not spin here
    }
    if (!c.superclass.empty()) {
        auto sup = index.find(c.superclass);
        if (sup != index.end()) {
            collectFields(*sup->second, index, out, depth + 1);
        }
    }
    for (const ast::MemberPtr& m : c.members) {
        if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get()); fd != nullptr && !fd->isStatic) {
            out.push_back(fd);
        }
    }
}

// A field's DECLARED type as the author wrote it -- `int`, `String`, `Point*`, `int[]`. Written here
// rather than borrowed, because what a structural body branches on is the SPELLING the reader sees
// in the class, and the mangling the compiler uses internally would leak names nobody wrote.
std::string declaredTypeName(const ast::TypeRef& t) {
    std::string out = t.name;
    for (int i = 0; i < t.pointerDepth; ++i) {
        out += "*";
    }
    for (int i = 0; i < t.arrayDims; ++i) {
        out += "[]";
    }
    return out;
}

// A CONDITION THAT IS ALREADY DECIDED, and the arm that did not survive.
//
// After unrolling, `if (field.typeName == "int")` reads `if ("int" == "int")` -- a question with an
// answer. Folding it here rather than leaving it to the optimizer is not about speed: the arm that
// does not apply is written for a DIFFERENT type and need not type-check for this one, so it has to
// be gone before the analyzer sees it. Branching on the field's type is the whole reason a
// serializer can be written structurally.
int foldCondition(const ast::Expr* e) {
    if (const auto* b = dynamic_cast<const ast::BinaryExpr*>(e)) {
        const auto* l = dynamic_cast<const ast::StringLiteralExpr*>(b->lhs.get());
        const auto* r = dynamic_cast<const ast::StringLiteralExpr*>(b->rhs.get());
        if (l != nullptr && r != nullptr && (b->op == "==" || b->op == "!=")) {
            const bool same = l->value == r->value;
            return (b->op == "==" ? same : !same) ? 1 : 0;
        }
        if (b->op == "&&" || b->op == "||") {
            const int lv = foldCondition(b->lhs.get());
            const int rv = foldCondition(b->rhs.get());
            if (lv < 0 || rv < 0) {
                return -1;
            }
            return b->op == "&&" ? (lv && rv ? 1 : 0) : (lv || rv ? 1 : 0);
        }
    }
    if (const auto* u = dynamic_cast<const ast::UnaryExpr*>(e); u != nullptr && u->op == "!") {
        const int v = foldCondition(u->operand.get());
        return v < 0 ? -1 : (v == 0 ? 1 : 0);
    }
    // `"a".equals("b")` -- the same question in the spelling a String comparison usually takes.
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(e)) {
        const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
        if (mem != nullptr && mem->member == "equals" && call->args.size() == 1) {
            const auto* l = dynamic_cast<const ast::StringLiteralExpr*>(mem->object.get());
            const auto* r = dynamic_cast<const ast::StringLiteralExpr*>(call->args[0].get());
            if (l != nullptr && r != nullptr) {
                return l->value == r->value ? 1 : 0;
            }
        }
    }
    return -1;   // not decidable here, and left alone
}

// Drop the arms that cannot be taken, wherever they are nested.
void foldDecided(ast::Block& block);

void foldDecidedStmt(std::vector<ast::StmtPtr>& out, ast::StmtPtr st) {
    if (auto* ifs = dynamic_cast<ast::IfStmt*>(st.get())) {
        const int v = foldCondition(ifs->cond.get());
        if (v == 1) {
            foldDecided(ifs->thenBlock);
            for (auto& s : ifs->thenBlock.statements) {
                out.push_back(std::move(s));
            }
            return;
        }
        if (v == 0) {
            if (ifs->elseBlock != nullptr) {
                foldDecided(*ifs->elseBlock);
                for (auto& s : ifs->elseBlock->statements) {
                    out.push_back(std::move(s));
                }
            }
            return;
        }
        foldDecided(ifs->thenBlock);
        if (ifs->elseBlock != nullptr) {
            foldDecided(*ifs->elseBlock);
        }
    }
    out.push_back(std::move(st));
}

void foldDecided(ast::Block& block) {
    std::vector<ast::StmtPtr> out;
    for (auto& st : block.statements) {
        foldDecidedStmt(out, std::move(st));
    }
    block.statements = std::move(out);
}

// The unroll itself: one copy of the body per field, with the field's name and declared type
// substituted as literals during the CLONE -- reusing the walker that already visits every node,
// rather than a second visitor that would go quietly out of date the first time a node kind is added.
void unrollStructural(ast::Block& body, const ast::ClassDecl& owner,
                      const std::map<std::string, const ast::ClassDecl*>& index) {
    bool any = false;
    for (const auto& st : body.statements) {
        if (const auto* fe = dynamic_cast<const ast::ForeachStmt*>(st.get());
            fe != nullptr && fe->isComptime) {
            any = true;
        }
    }
    // Nested first, so a `comptime foreach` inside an ordinary loop or branch is reached too.
    for (auto& st : body.statements) {
        if (auto* ifs = dynamic_cast<ast::IfStmt*>(st.get())) {
            unrollStructural(ifs->thenBlock, owner, index);
            if (ifs->elseBlock != nullptr) {
                unrollStructural(*ifs->elseBlock, owner, index);
            }
        } else if (auto* wh = dynamic_cast<ast::WhileStmt*>(st.get())) {
            unrollStructural(wh->body, owner, index);
        } else if (auto* fe = dynamic_cast<ast::ForeachStmt*>(st.get()); fe != nullptr && !fe->isComptime) {
            unrollStructural(fe->body, owner, index);
        }
    }
    if (!any) {
        return;
    }
    std::vector<const ast::FieldDecl*> fields;
    collectFields(owner, index, fields);
    std::vector<ast::StmtPtr> out;
    for (auto& st : body.statements) {
        auto* fe = dynamic_cast<ast::ForeachStmt*>(st.get());
        if (fe == nullptr || !fe->isComptime) {
            out.push_back(std::move(st));
            continue;
        }
        for (const ast::FieldDecl* fd : fields) {
            ast::Block copy = cloneBlockForField(fe->body, fe->varName, fd->name,
                                                 declaredTypeName(fd->type));
            foldDecided(copy);
            for (auto& s : copy.statements) {
                out.push_back(std::move(s));
            }
        }
    }
    body.statements = std::move(out);
}

void expandInto(ast::ClassDecl& target, const Index& index, const std::set<std::string>& layouts,
                const std::map<std::string, std::set<std::string>>& ifaceMethods) {
    bool hasLayout = target.isLayout;
    for (const std::string& i : target.interfaces) {
        if (layouts.count(i) > 0) {
            hasLayout = true;
        }
    }
    expandCore(target.name, target.members, target.applies, target.appliesLocs, target.loc,
               hasLayout, &target.interfaces, target.procCalls, index, ifaceMethods,
               &target.appliedClosure);
    // AND ITS INVARIANTS TRAVEL WITH ITS FIELDS. A transformer that brings state is the one place
    // that knows what must hold of it; copied in, the rule becomes this type's own and is checked by
    // the machinery every class invariant already uses. `itself` is bound to the applying type on the
    // way, like everything else the copier carries.
    for (const std::string& tn : target.appliedClosure) {
        auto it = index.find(tn);
        if (it == index.end()) {
            continue;
        }
        std::map<std::string, std::string> subst;
        subst["itself"] = target.name;
        for (const ast::ExprPtr& inv : it->second->invariants) {
            target.invariants.push_back(cloneExprSubst(inv.get(), subst));
        }
    }
}

// An ENUM is the flagship of the totality rule -- `Errno -> int` is total because the constants are
// a finite list you own -- so it has to be able to carry the conversion. Its constants stay plain
// ordinals; what it gains from a transformer is members, and an ordinal enum has always been able to
// hold those.
//
// A transformer that brings a FIELD is refused: an enum constant is a value, not an object, so there
// is nowhere to put per-instance state. That is the design note's "deduced, not declared" rule
// reaching its first real case, and it needs no annotation -- the transformer's own body says it.
void expandIntoEnum(ast::EnumDecl& target, const Index& index,
                    const std::map<std::string, std::set<std::string>>& ifaceMethods) {
    for (std::size_t i = 0; i < target.applies.size(); ++i) {
        auto it = index.find(target.applies[i]);
        if (it == index.end()) {
            continue;   // reported by expandCore
        }
        for (const ast::MemberPtr& m : it->second->members) {
            if (dynamic_cast<const ast::FieldDecl*>(m.get()) == nullptr) {
                continue;
            }
            const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get());
            if (fd->isStatic) {
                continue;   // a static field is the transformer's, not per-instance
            }
            report(i < target.appliesLocs.size() ? target.appliesLocs[i] : target.loc,
                   "transformer '" + target.applies[i] + "' brings the field '" + fd->name +
                       "', and '" + target.name + "' is an enum -- a constant is a value, not an "
                       "object, so there is nowhere to keep per-instance state. Apply a field-less "
                       "transformer, or make this a java-style enum, which has instances.");
            break;
        }
    }
    expandCore(target.name, target.members, target.applies, target.appliesLocs, target.loc,
               /*hasLayout=*/false, /*interfaces=*/nullptr, target.procCalls, index, ifaceMethods,
               /*closureOut=*/nullptr);
}

// A declaration that can apply a transformer, seen uniformly. A class and an enum are different
// kinds with different futures, and a relation between them is about neither of those: it is about
// the members they hold and the clause they wrote. Collected once and shared by both relation
// checks, so neither of them can quietly forget a kind -- which is exactly what `mutual` did while
// only classes could apply.
struct Applier {
    std::string name;
    std::vector<ast::MemberPtr>* members = nullptr;
    const std::vector<std::string>* applies = nullptr;
    const std::vector<SourceLocation>* appliesLocs = nullptr;
    SourceLocation loc;
};

std::map<std::string, Applier> collectAppliers(ast::Program& program) {
    std::map<std::string, Applier> out;
    for (ast::Bundle& b : program.bundles) {
        for (ast::Namespace& ns : b.namespaces) {
            for (ast::ClassDecl& c : ns.classes) {
                out[c.name] = Applier{c.name, &c.members, &c.applies, &c.appliesLocs, c.loc};
            }
            for (ast::EnumDecl& e : ns.enums) {
                // A java-style enum is already in `classes` under this name -- the parser splits it
                // into a class half that holds the members and a light enum that holds the
                // constants. The members are what a transformer touches, so the class half wins.
                if (out.count(e.name) == 0) {
                    out[e.name] = Applier{e.name, &e.members, &e.applies, &e.appliesLocs, e.loc};
                }
            }
        }
    }
    return out;
}

// Does this declaration end up with transformer `t` -- written on its own line, or carried there by
// one that is? Transport is why this cannot be a search of `applies`.
bool hasTransformer(const Applier& a, const std::string& t, const Index& index) {
    std::vector<std::string> order;
    std::set<std::string> seen;
    for (const std::string& direct : *a.applies) {
        closure(direct, index, order, seen);
    }
    return seen.count(t) > 0;
}

// `mutual`: if X applies this transformer and implements `p<Y>`, then Y must apply it too and
// implement `p<X>`. The error lands on X, naming the Y that did not answer.
//
// NOTHING DECLARES "A converts to B" -- two types apply the same transformer and the transformation
// EMERGES from the pair, direction included: one side implemented means one way, both sides means
// both. What does NOT emerge is the obligation to write the second side, and that is this word's
// entire job.
//
// It is checkable only because the family is per-target: `p$Y` is a member you can read on X. With
// one generic body there would be nothing but call sites to look at, which is a different and much
// stronger promise.
//
// Runs after every type has been expanded, so the answer never depends on the order namespaces
// happen to be walked in.
void checkMutual(const std::map<std::string, Applier>& types, const Index& index) {
    auto declares = [](const Applier& c, const std::string& member) {
        for (const ast::MemberPtr& m : *c.members) {
            if (const ast::MethodDecl* md = asMethod(m); md != nullptr && md->name == member) {
                return true;
            }
        }
        return false;
    };

    for (const auto& [name, decl] : types) {
        for (std::size_t i = 0; i < decl.applies->size(); ++i) {
            auto ti = index.find((*decl.applies)[i]);
            if (ti == index.end() || !ti->second->isMutualTransformer) {
                continue;
            }
            const SourceLocation where =
                i < decl.appliesLocs->size() ? (*decl.appliesLocs)[i] : decl.loc;
            for (const ast::MemberPtr& tm : ti->second->members) {
                const ast::MethodDecl* socket = asMethod(tm);
                if (socket == nullptr || !socket->isEachFamily) {
                    continue;
                }
                const std::string prefix = socket->name + "$";
                for (const ast::MemberPtr& own : *decl.members) {
                    const ast::MethodDecl* impl = asMethod(own);
                    if (impl == nullptr || impl->name.rfind(prefix, 0) != 0) {
                        continue;
                    }
                    const std::string other = impl->name.substr(prefix.size());
                    const std::string pair = "`" + socket->name + "<" + other + ">`";
                    auto oi = types.find(other);
                    if (oi == types.end()) {
                        // The far end is not ours to change. `Errno <-> int` cannot be mutual,
                        // because `int` applies nothing -- said up front rather than discovered
                        // later as half a relation. The way back still exists, as a static
                        // procedure.
                        report(where,
                               "transformer '" + ti->second->name + "' is `mutual`, and '" + name +
                                   "' implements " + pair + " -- but '" + other + "' is not a type "
                                   "this program declares, so it can never answer. A relation with "
                                   "a type you do not own cannot be mutual: drop `mutual`, and give "
                                   "the way back as a static procedure.");
                        continue;
                    }
                    bool appliesIt = false;
                    for (const std::string& a : *oi->second.applies) {
                        if (a == ti->second->name) {
                            appliesIt = true;
                        }
                    }
                    if (!appliesIt) {
                        report(where,
                               "transformer '" + ti->second->name + "' is `mutual`, and '" + name +
                                   "' implements " + pair + " -- so '" + other + "' must apply '" +
                                   ti->second->name + "' too, and does not. A pair is symmetric or "
                                   "it is not a pair.");
                    } else if (!declares(oi->second, socket->name + "$" + name)) {
                        report(where,
                               "transformer '" + ti->second->name + "' is `mutual`, and '" + name +
                                   "' implements " + pair + " -- so '" + other + "' must implement "
                                   "`" + socket->name + "<" + name + ">` and does not. One side "
                                   "implemented is one direction; `mutual` is what says both are "
                                   "owed.");
                    }
                }
            }
        }
    }
}

// ---------------------------------------------------------------------------------------------
// `collective`: the 1 -> N relation.
//
// A relation used to be a PAIR. One way is a procedure written on one side; `mutual` is the word
// that says the other side owes the way back. Neither can say the thing you actually mean when
// several types are different encodings of one value: that ALL of them convert among themselves.
// Without it that shape is written by hand, and the patterns it is written with -- a canonical pivot
// type everything converts through, a registry of converters, double dispatch, a visitor -- exist
// because the language could not say it.
//
// `collective` says it: the appliers form one transformation set, so each of them can become any of
// the others. What makes that affordable rather than N-squared is COMPOSITION. The conversions you
// write are edges; the compiler completes the graph along them. Three types in a cycle -- C -> F,
// F -> K, K -> C -- are three procedures and six conversions. The pivot pattern is not made easier;
// it stops being necessary, because a pivot is exactly what a path through the graph already is.
//
// TWO RULES KEEP IT HONEST, and they are the same rule the rest of the feature already follows:
// there is never an implicit winner, and never an order. If two shortest paths tie, that is an error
// naming both rather than a silent choice; if there is no path, that is an error naming the pair.
// The word on the transformer is what asks for the composition, which is what separates this from
// the compiler writing code nobody asked for.

// One hop of a composed conversion, as a written procedure the path may travel.
struct Edge {
    std::string to;
    const ast::MethodDecl* via = nullptr;
};

// `this.p$M1().p$M2()....p$B()` -- the composed conversion, as an expression.
ast::ExprPtr composeChain(const std::string& family, const std::vector<std::string>& path,
                          const SourceLocation& loc) {
    auto self = std::make_unique<ast::IdentifierExpr>();
    self->loc = loc;
    self->name = "this";
    ast::ExprPtr expr = std::move(self);
    for (std::size_t i = 1; i < path.size(); ++i) {   // path[0] is the source
        auto callee = std::make_unique<ast::MemberExpr>();
        callee->loc = loc;
        callee->object = std::move(expr);
        callee->member = family + "$" + path[i];
        auto call = std::make_unique<ast::CallExpr>();
        call->loc = loc;
        call->callee = std::move(callee);
        expr = std::move(call);
    }
    return expr;
}

void checkCollective(std::map<std::string, Applier>& types, const Index& index) {
    // Synthesized members are parked until every graph has been read. Appending to an applier's
    // member list while another applier's edges are still being computed off it would make the
    // answer depend on the order the appliers happen to be walked in, which is the one thing a
    // relation over a SET must never do.
    std::vector<std::pair<std::string, ast::MemberPtr>> synthesized;

    for (const auto& [tname, transformer] : index) {
        if (!transformer->isCollectiveTransformer) {
            continue;
        }
        std::vector<const Applier*> appliers;
        for (const auto& [n, a] : types) {
            if (hasTransformer(a, tname, index)) {
                appliers.push_back(&a);
            }
        }
        if (appliers.size() < 2) {
            continue;   // a relation over fewer than two types is satisfied by having nothing to do
        }
        std::set<std::string> inSet;
        for (const Applier* a : appliers) {
            inSet.insert(a->name);
        }
        // The families the relation ranges over: every per-target socket the appliers get FROM this
        // transformer, carried ones included -- `applies` is inclusion, so what a carried transformer
        // declares is equally what this one gave them.
        std::vector<std::string> carried;
        std::set<std::string> carriedSeen;
        closure(tname, index, carried, carriedSeen);
        for (const std::string& cn : carried) {
            auto ci = index.find(cn);
            if (ci == index.end()) {
                continue;
            }
            for (const ast::MemberPtr& sm : ci->second->members) {
                const ast::MethodDecl* socket = asMethod(sm);
                if (socket == nullptr || !socket->isEachFamily || socket->isStatic) {
                    continue;   // a static per-target procedure converts FROM an open source: not in
                }
                const std::string family = socket->name;
                // Composable means the shape is a conversion: nothing in, the target out. A family
                // of any other shape -- `render<each Other>(Other into)` -- still has to be complete,
                // because that is what the word promises, but there is nothing to compose along, and
                // saying so beats generating a body that means something else.
                const bool composable =
                    socket->params.empty() && socket->typeParams.size() == 1 &&
                    socket->returnType.name == socket->typeParams.front();

                std::map<std::string, std::vector<Edge>> edges;
                for (const Applier* a : appliers) {
                    for (const ast::MemberPtr& m : *a->members) {
                        const ast::MethodDecl* md = asMethod(m);
                        if (md == nullptr || md->isStatic || md->isAbstract ||
                            md->visibility == "private") {
                            continue;   // private is the type's own business; a path cannot use it
                        }
                        if (md->name.rfind(family + "$", 0) != 0) {
                            continue;
                        }
                        const std::string to = md->name.substr(family.size() + 1);
                        if (to != a->name && inSet.count(to) > 0) {
                            edges[a->name].push_back(Edge{to, md});
                        }
                    }
                }

                for (const Applier* from : appliers) {
                    // Breadth-first, counting the ways. A plain FIFO visits in non-decreasing
                    // distance, which is what makes `ways` a count of SHORTEST paths rather than of
                    // paths -- and the count is what turns an ambiguity into a diagnostic instead of
                    // an arbitrary pick. Capped at two: the message needs to know "more than one",
                    // not how many.
                    std::map<std::string, int> dist;
                    std::map<std::string, int> ways;
                    std::map<std::string, std::string> pred;
                    std::map<std::string, std::string> pred2;
                    std::vector<std::string> queue{from->name};
                    dist[from->name] = 0;
                    ways[from->name] = 1;
                    for (std::size_t qi = 0; qi < queue.size(); ++qi) {
                        const std::string u = queue[qi];
                        auto ei = edges.find(u);
                        if (ei == edges.end()) {
                            continue;
                        }
                        for (const Edge& e : ei->second) {
                            auto di = dist.find(e.to);
                            if (di == dist.end()) {
                                dist[e.to] = dist[u] + 1;
                                ways[e.to] = ways[u];
                                pred[e.to] = u;
                                queue.push_back(e.to);
                            } else if (di->second == dist[u] + 1) {
                                ways[e.to] = ways[e.to] + ways[u] > 2 ? 2 : ways[e.to] + ways[u];
                                if (pred[e.to] != u && pred2[e.to].empty()) {
                                    pred2[e.to] = u;
                                }
                            }
                        }
                    }

                    for (const Applier* to : appliers) {
                        // READ THROUGH `find`, NEVER `operator[]`. On a std::map the subscript
                        // INSERTS, so testing `dist[x] == 1` quietly created a zero entry for an
                        // unreachable target -- the "no path" branch then never fired, the path
                        // reconstruction walked into an empty predecessor and looped forever. The
                        // symptom was a compiler that never came back.
                        auto di = dist.find(to->name);
                        const int d = di == dist.end() ? -1 : di->second;
                        if (to->name == from->name || d == 1) {
                            continue;   // itself, or written by hand: nothing owed
                        }
                        const SourceLocation where =
                            from->appliesLocs->empty() ? from->loc : from->appliesLocs->front();
                        const std::string owed =
                            "`procedure " + family + "<" + to->name + ">` on '" + from->name + "'";
                        if (d < 0) {
                            report(where,
                                   "'" + from->name + "' applies the `collective` transformer '" +
                                       tname + "', so every type that applies it must be able to "
                                       "become every other -- and nothing leads from '" + from->name +
                                       "' to '" + to->name + "'. Write " + owed + ", or any "
                                       "conversion that reaches it: the compiler composes the rest.");
                            continue;
                        }
                        if (!composable) {
                            report(where,
                                   "'" + from->name + "' applies the `collective` transformer '" +
                                       tname + "', which declares `" + family + "<each ...>` -- and "
                                       "that family takes arguments, so there is nothing to compose "
                                       "along. A collective relation completes itself only for a "
                                       "conversion (no parameters, returning the target). Write " +
                                       owed + ".");
                            continue;
                        }
                        if (ways[to->name] > 1) {
                            // Find WHERE it forked, walking back from the target. Reporting the
                            // split point rather than the endpoints is what makes the message
                            // actionable: the two names in it are the two conversions to choose
                            // between.
                            std::string at = to->name;
                            while (pred2[at].empty() && !pred[at].empty()) {
                                at = pred[at];
                            }
                            report(where,
                                   "'" + from->name + "' applies the `collective` transformer '" +
                                       tname + "', and there are two equally short ways to reach '" +
                                       to->name + "': '" + at + "' can be reached through '" +
                                       pred[at] + "' and through '" + pred2[at] +
                                       "'. A composed conversion may not pick one -- write " + owed +
                                       " to say which, the way a collision on a member name is "
                                       "resolved by the type.");
                            continue;
                        }
                        std::vector<std::string> path{to->name};
                        for (std::string at = to->name; at != from->name; at = pred[at]) {
                            path.push_back(pred[at]);
                        }
                        std::reverse(path.begin(), path.end());

                        auto proc = std::make_unique<ast::MethodDecl>();
                        proc->loc = where;
                        proc->visibility = "public";
                        proc->isProcedure = true;
                        proc->isEachFamily = true;
                        proc->name = family + "$" + to->name;
                        proc->returnType.name = to->name;
                        proc->returnType.loc = where;
                        proc->composedVia.assign(path.begin() + 1, path.end() - 1);
                        // A composed conversion can fail exactly where its hops can. Carrying their
                        // `throws` forward is not a convenience: without it the body raises what its
                        // own signature does not declare, which is the one thing the checker exists
                        // to catch.
                        std::set<std::string> thrown;
                        for (std::size_t h = 1; h < path.size(); ++h) {
                            auto pi = types.find(path[h - 1]);
                            if (pi == types.end()) {
                                continue;
                            }
                            for (const ast::MemberPtr& m : *pi->second.members) {
                                const ast::MethodDecl* md = asMethod(m);
                                if (md == nullptr || md->name != family + "$" + path[h]) {
                                    continue;
                                }
                                for (const ast::TypeRef& tr : md->throwsTypes) {
                                    if (thrown.insert(tr.name).second) {
                                        proc->throwsTypes.push_back(tr);
                                    }
                                }
                            }
                        }
                        auto ret = std::make_unique<ast::ReturnStmt>();
                        ret->loc = where;
                        ret->value = composeChain(family, path, where);
                        proc->body.loc = where;
                        proc->body.statements.push_back(std::move(ret));
                        synthesized.emplace_back(from->name, std::move(proc));
                    }
                }
            }
        }
    }
    for (auto& [owner, member] : synthesized) {
        auto it = types.find(owner);
        if (it != types.end()) {
            it->second.members->push_back(std::move(member));
        }
    }
}

// `error Failed;` -- the transformer's own failure type, so a failure names the conversion that
// failed instead of surfacing as somebody else's exception.
//
// THE SHAPE, which the design note left open: it becomes an ORDINARY CLASS in the transformer's
// namespace, under the name written, carrying a `String reason`. Referenced as `Failed`, not
// `TConverter.Failed`.
//
// That is a decision and it is the cheap one on purpose. A nested spelling would need a new
// resolution rule for `Type.Type` in every position a type can appear -- `throws`, `catch`, `new`,
// a field, a parameter -- to buy a qualification the namespace already provides. The cost is that
// the name must be unique in its namespace, which is checked here rather than discovered as a
// silently-shared class.
//
// Synthesized ONCE, at the transformer, and not per applying type: two types that fail the same
// conversion should raise the same thing, or a caller cannot write one `catch`.
void synthesizeErrorTypes(ast::Namespace& ns) {
    for (const ast::ClassDecl& t : ns.transformers) {
        for (const auto& [name, loc] : t.errorTypes) {
            bool taken = false;
            for (const ast::ClassDecl& c : ns.classes) {
                if (c.name == name) {
                    taken = true;
                }
            }
            if (taken) {
                report(loc, "transformer '" + t.name + "' declares the error type '" + name +
                                "', and namespace '" + ns.name + "' already has a type by that "
                                "name. An error type is an ordinary class in its namespace, so the "
                                "name must be free -- give it one that names the failure, e.g. `" +
                                t.name + "Failed`.");
                continue;
            }
            ast::ClassDecl e;
            e.loc = loc;
            e.nameLoc = loc;
            e.visibility = "public";
            e.name = name;
            auto reason = std::make_unique<ast::FieldDecl>();
            reason->loc = loc;
            reason->visibility = "public";
            reason->name = "reason";
            reason->type.name = "String";
            reason->type.loc = loc;
            e.members.push_back(std::move(reason));
            auto ctor = std::make_unique<ast::ConstructorDecl>();
            ctor->loc = loc;
            ctor->visibility = "public";
            ast::Param p;
            p.loc = loc;
            p.name = "reason";
            p.type.name = "String";
            p.type.loc = loc;
            ctor->params.push_back(std::move(p));
            {   // this.reason = reason;
                auto self = std::make_unique<ast::IdentifierExpr>();
                self->loc = loc;
                self->name = "this";
                auto target = std::make_unique<ast::MemberExpr>();
                target->loc = loc;
                target->object = std::move(self);
                target->member = "reason";
                auto value = std::make_unique<ast::IdentifierExpr>();
                value->loc = loc;
                value->name = "reason";
                auto assign = std::make_unique<ast::AssignStmt>();
                assign->loc = loc;
                assign->target = std::move(target);
                assign->value = std::move(value);
                ctor->body.statements.push_back(std::move(assign));
            }
            e.members.push_back(std::move(ctor));
            ns.classes.push_back(std::move(e));
        }
    }
}

}  // namespace

bool expandTransformers(ast::Program& program) {
    g_errors = 0;
    const AllTransformers all = indexAllTransformers(program);
    // The whole-program view, for the two relation checks at the end: they range over types in
    // different namespaces at once, so there is no single asker to resolve against.
    const Index index = viewFor(all, "", "");
    const std::set<std::string> layouts = indexLayouts(program);
    const std::map<std::string, std::set<std::string>> ifaceMethods = indexInterfaceMethods(program);
    for (ast::Bundle& b : program.bundles) {
        for (ast::Namespace& ns : b.namespaces) {
            // Resolved from where this namespace stands, so a program's own transformer wins over a
            // standard-library one of the same name -- and the library's own code still sees its own.
            const Index here = viewFor(all, ns.name, b.name);
            // Before expansion: a procedure may name its own error type. NOT for an imported bundle
            // -- its error class was synthesized where the transformer was written and crossed the
            // header as an ordinary class, so doing it again would collide with itself and report
            // the name as taken by a type nobody wrote.
            if (!b.isImported) {
                synthesizeErrorTypes(ns);
            }
            for (ast::ClassDecl& t : ns.transformers) {
                checkTransport(t, here);
                if (!b.isPrelude && !b.isImported) {
                    checkTransformerShape(t, here);
                }
                // A WARNING, not an error, for the same reason the PascalCase one is: it nudges the
                // convention without breaking code that predates it.
                if (!b.isPrelude && !b.isImported && !followsConvention(t.name)) {
                    warn(t.nameLoc.line != 0 ? t.nameLoc : t.loc,
                         "transformer '" + t.name + "' should be named `" + conventionalName(t.name) +
                             "` -- a transformer is named `T` + stem + `er`, because it is the "
                             "COUPLING between two types and not either of them, and the `T` says "
                             "which of the clauses on a class line you are reading");
                }
            }
            for (ast::ClassDecl& c : ns.classes) {
                expandInto(c, here, layouts, ifaceMethods);
            }
            for (ast::EnumDecl& e : ns.enums) {
                expandIntoEnum(e, here, ifaceMethods);
            }
        }
    }
    // STRUCTURAL BODIES, unrolled once every copy is in place.
    //
    // A transformer could supply a fixed body or a socket, and could not supply a body derived from
    // the SHAPE of the type applying it -- clone every field, compare every field, write every field.
    // That is exactly what `record` does for `equals` and `clone`, hard-coded in the compiler because
    // it was not expressible in the language. So `TCloner` and `TEquator` were not unwritten, they
    // were unwritable.
    //
    // Done here, at the end, because only now is every member in place and every applying type known
    // -- and the fields being iterated are the APPLYING type's, which the transformer cannot see.
    {
        std::map<std::string, const ast::ClassDecl*> forFields;
        for (const ast::Bundle& b : program.bundles) {
            for (const ast::Namespace& ns : b.namespaces) {
                for (const ast::ClassDecl& c : ns.classes) {
                    forFields[c.name] = &c;
                }
            }
        }
        for (ast::Bundle& b : program.bundles) {
            for (ast::Namespace& ns : b.namespaces) {
                for (ast::ClassDecl& c : ns.classes) {
                    for (ast::MemberPtr& m : c.members) {
                        auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
                        if (md == nullptr) {
                            continue;
                        }
                        // A BOUND TARGET COPIED OUT OF A TRANSFORMER arrives here still holding its
                        // type parameter, because it is not an `each` family and `bindEachTargets`
                        // never saw it. `itself` has already become this type's name on the way in,
                        // so the storage it starts as can be declared now.
                        if (!md->boundTarget.empty() && md->boundTargetType.empty() &&
                            !md->typeParams.empty()) {
                            md->boundTargetType = md->typeParams[0];
                            md->typeParams.clear();
                            auto storage = std::make_unique<ast::NewExpr>();
                            storage->loc = md->boundTargetLoc;
                            storage->className = md->boundTargetType;
                            storage->location = "stack";
                            storage->blank = true;
                            auto decl = std::make_unique<ast::VarDeclStmt>();
                            decl->loc = md->boundTargetLoc;
                            decl->name = md->boundTarget;
                            decl->type.name = md->boundTargetType;
                            decl->isMutable = md->boundTargetMutable;
                            decl->init = std::move(storage);
                            md->body.statements.insert(md->body.statements.begin(), std::move(decl));
                        }
                        unrollStructural(md->body, c, forFields);
                    }
                }
            }
        }
        // A TRANSFORMER APPLIED TO A BASE AND TO ITS DERIVED CLASS puts a member on each, and the
        // derived one overrides. It was refused for not saying `override` -- a word nobody was there
        // to write, since the compiler made the member.
        //
        // The same sentence already sits above `indexInterfaceMethods`, for the copy that answers a
        // `satisfies` interface: a member the compiler copied in has nobody to write the word. The
        // argument transfers unchanged, and so should the answer. What `override` exists to make
        // visible IS visible here -- `applies TNamer` is on the class line, in the reader's own file.
        for (ast::Bundle& b : program.bundles) {
            for (ast::Namespace& ns : b.namespaces) {
                for (ast::ClassDecl& c : ns.classes) {
                    if (c.superclass.empty()) {
                        continue;
                    }
                    for (ast::MemberPtr& m : c.members) {
                        auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
                        if (md == nullptr || md->fromTransformer.empty() || md->isOverride) {
                            continue;
                        }
                        std::string up = c.superclass;
                        for (int depth = 0; depth < 32 && !up.empty(); ++depth) {
                            auto sup = forFields.find(up);
                            if (sup == forFields.end()) {
                                break;
                            }
                            for (const ast::MemberPtr& sm : sup->second->members) {
                                if (const ast::MethodDecl* smd = asMethod(sm);
                                    smd != nullptr && smd->name == md->name && !smd->isStatic) {
                                    md->isOverride = true;
                                }
                            }
                            up = sup->second->superclass;
                        }
                    }
                }
            }
        }
    }
    // CONSENT, checked after everything is expanded, because it is about somebody else's class line.
    //
    // A bound target is assembled field by field with no constructor of its own running, so what is
    // being handed over is the right to establish that type's invariants. Only the type can agree to
    // that, and it agrees by writing `entrusts` instead of `applies`. Without this check the binding
    // form would be a way for any type to build any other from the outside -- which is not a
    // permission the language grants anywhere else.
    std::map<std::string, const ast::ClassDecl*> byName;
    for (const ast::Bundle& b : program.bundles) {
        for (const ast::Namespace& ns : b.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                byName[c.name] = &c;
            }
        }
    }
    for (ast::Bundle& b : program.bundles) {
        for (ast::Namespace& ns : b.namespaces) {
            for (ast::ClassDecl& c : ns.classes) {
                for (const ast::MemberPtr& m : c.members) {
                    const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get());
                    if (md == nullptr || md->boundTarget.empty()) {
                        continue;
                    }
                    auto target = byName.find(md->boundTargetType);
                    if (target == byName.end()) {
                        report(md->boundTargetLoc,
                               "'" + md->boundTargetType + "' is not a class this program declares, "
                               "so it cannot be bound as a target");
                        continue;
                    }
                    bool trusted = false;
                    for (const std::string& t : target->second->entrusts) {
                        if (t == md->boundTargetVia) {
                            trusted = true;
                        }
                    }
                    if (!trusted) {
                        report(md->boundTargetLoc,
                               "'" + md->boundTargetType + "' does not entrust '" + md->boundTargetVia +
                                   "', so binding it as a target is not allowed. Binding assembles the "
                                   "target field by field with no constructor of its own running, so "
                                   "it is that type's invariants being established from outside -- "
                                   "write `entrusts " + md->boundTargetVia + "` on '" +
                                   md->boundTargetType + "' if that is intended, or build it with a "
                                   "constructor instead");
                    }
                }
            }
        }
    }
    // Both relations run after every type has been expanded, so neither answer depends on the order
    // namespaces happen to be walked in: each is about somebody ELSE's members.
    std::map<std::string, Applier> appliers = collectAppliers(program);
    checkMutual(appliers, index);
    checkCollective(appliers, index);
    return g_errors == 0;
}

}  // namespace polaron
