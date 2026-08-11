#include "parser/transformers.h"

#include <map>
#include <set>
#include <string>
#include <vector>

#include <cstdio>

#include "diag/diagnostic.h"
#include "diag/render.h"
#include "parser/monomorphize.h"

namespace ldp3 {
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
    if (stem.size() > 1 && stem[0] == 'T' && std::isupper(static_cast<unsigned char>(stem[1])) != 0)
        stem.erase(0, 1);
    auto endsWith = [&](const char* suffix) {
        const std::size_t n = std::char_traits<char>::length(suffix);
        return stem.size() > n && stem.compare(stem.size() - n, n, suffix) == 0;
    };
    if (endsWith("able"))      stem.erase(stem.size() - 4);
    else if (endsWith("ible")) stem.erase(stem.size() - 4);
    else if (endsWith("er"))   stem.erase(stem.size() - 2);
    else if (endsWith("e"))    stem.erase(stem.size() - 1);
    return "T" + stem + "er";
}

bool followsConvention(const std::string& name) {
    if (name.size() < 4 || name[0] != 'T') return false;
    if (std::isupper(static_cast<unsigned char>(name[1])) == 0) return false;
    return name.compare(name.size() - 2, 2, "er") == 0;
}

using Index = std::map<std::string, const ast::ClassDecl*>;

Index indexTransformers(const ast::Program& program) {
    Index out;
    for (const ast::Bundle& b : program.bundles)
        for (const ast::Namespace& ns : b.namespaces)
            for (const ast::ClassDecl& t : ns.transformers) out[t.name] = &t;
    return out;
}

// The names declared with `layout`. Needed because this pass runs BEFORE `resolveLayouts`, so a
// pinned layout is still sitting in the type's `implements` list looking like an interface.
std::set<std::string> indexLayouts(const ast::Program& program) {
    std::set<std::string> out;
    for (const ast::Bundle& b : program.bundles)
        for (const ast::Namespace& ns : b.namespaces)
            for (const ast::ClassDecl& c : ns.classes)
                if (c.isLayout) out.insert(c.name);
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
    if (!seen.insert(name).second) return;
    auto it = index.find(name);
    if (it == index.end()) return;      // unknown: reported at the `applies` line that named it
    for (const std::string& carried : it->second->applies) closure(carried, index, order, seen);
    order.push_back(name);
}

// `explicit` buys back the readability that transport costs: a transformer marked this way always
// appears on the class line, so a grep for `applies RegionOwner` finds everyone who has it.
void checkTransport(const ast::ClassDecl& carrier, const Index& index) {
    for (std::size_t i = 0; i < carrier.applies.size(); ++i) {
        auto it = index.find(carrier.applies[i]);
        if (it == index.end() || !it->second->isExplicitTransformer) continue;
        report(i < carrier.appliesLocs.size() ? carrier.appliesLocs[i] : carrier.loc,
               "transformer '" + carrier.applies[i] + "' is `explicit`, so it may only be applied "
               "directly by a type -- '" + carrier.name + "' is a transformer, and carrying it would "
               "put it inside types whose class line never names it. Apply it on each type instead.");
    }
}

// Copies one transformer's members into a type. The substitution is the whole trick: inside a
// transformer `itself` is THE TYPE THAT WILL APPLY THIS, a type that does not exist yet, so binding
// it here is what completes a procedure's signature at the applying type.
void applyOne(const ast::ClassDecl& t, ast::ClassDecl& target,
              const SourceLocation& appliesLoc) {
    // What the type already writes for itself. A procedure it implements REPLACES the transformer's
    // body rather than colliding with it -- that is the point of a bodied procedure being "free and
    // replaceable".
    std::set<std::string> own;
    for (const ast::MemberPtr& m : target.members) {
        if (const ast::MethodDecl* md = asMethod(m)) own.insert(md->name);
        else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) own.insert(fd->name);
    }
    std::map<std::string, std::string> subst{{"itself", target.name}};
    for (const ast::MemberPtr& m : t.members) {
        const ast::MethodDecl* md = asMethod(m);
        const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get());
        const std::string name = md != nullptr ? md->name : (fd != nullptr ? fd->name : std::string());
        if (name.empty()) continue;
        // A PER-TARGET SOCKET names a family, so it is answered by any member of it: a type that
        // can convert to one thing has satisfied `into<each Other>`. Nothing here can know how many
        // targets it ought to reach -- that is the program's business, and `mutual` is the only
        // rule that says more.
        if (md != nullptr && md->isAbstract && md->isEachFamily) {
            bool answered = false;
            for (const std::string& n : own)
                if (n.rfind(name + "$", 0) == 0) answered = true;
            if (!answered)
                report(appliesLoc,
                       "'" + target.name + "' applies transformer '" + t.name + "', which requires "
                       "`procedure " + name + "<each ...>`, and implements it for no target. It "
                       "names a family: supply at least one, e.g. `procedure " + name +
                       "<SomeType>(...)`.");
            continue;
        }
        if (md != nullptr && md->isAbstract) {
            // A SOCKET. The applying type must answer it, and the error lands on the `applies` line
            // because that line is where the obligation was taken on -- not inside the transformer,
            // which is correct and is somebody else's file.
            if (own.count(name) == 0)
                report(appliesLoc,
                       "'" + target.name + "' applies transformer '" + t.name + "', which requires "
                       "`procedure " + name + "`, and does not implement it. A procedure with no "
                       "body is a socket: the transformer writes the algorithm and the type supplies "
                       "this part.");
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
            target.members.push_back(std::move(twin));
        }
        if (own.count(name) > 0) {
            // FIELD COLLISIONS ARE AN ERROR, FULL STOP -- a type cannot "implement" a field to break
            // the tie, and silently keeping one of the two would give the object storage under a
            // name that means something else. Methods are different: replacing a bodied procedure is
            // the feature.
            if (fd != nullptr)
                report(appliesLoc,
                       "transformer '" + t.name + "' brings the field '" + name + "', and '" +
                           target.name + "' already declares one by that name. A field cannot be "
                           "overridden the way a procedure can -- rename one of them.");
            continue;
        }
        auto copy = cloneMemberSubst(m.get(), subst);
        // POINT THE COPY AT THE `applies` LINE, not at the transformer. Every later diagnostic about
        // this member -- definite release on an applied `region`, definite assignment on an applied
        // field -- now lands where the obligation was taken on, in the reader's own file. Measured
        // rather than assumed: forgetting to release an applied region already errors, correctly,
        // via the check built for ordinary fields; it just pointed into somebody else's source.
        copy->loc = appliesLoc;
        target.members.push_back(std::move(copy));
        own.insert(name);
    }
}

// `method` where a transformer said `procedure`, and `procedure` where no transformer said
// anything. Checked in both directions so PROVENANCE SURVIVES A TERMINAL: open the file in a diff or
// a review and you can see what came from a transformer and what is the type's own. This is what
// Java's `@Override` tries to be and fails at, because it can be omitted.
void checkProvenance(ast::ClassDecl& target, const std::vector<std::string>& applied,
                     const Index& index) {
    std::set<std::string> broughtIn;
    for (const std::string& tn : applied) {
        auto it = index.find(tn);
        if (it == index.end()) continue;
        for (const ast::MemberPtr& m : it->second->members)
            if (const ast::MethodDecl* md = asMethod(m)) broughtIn.insert(md->name);
    }
    for (const ast::MemberPtr& m : target.members) {
        auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
        if (md == nullptr) continue;
        // `into$Fahrenheit` is one member of the family `into<each Other>`, so it carries the
        // family's provenance -- otherwise the bound name looks like a procedure nobody declared.
        const bool fromTransformer =
            broughtIn.count(md->name) > 0 ||
            (md->isEachFamily && broughtIn.count(md->name.substr(0, md->name.find('$'))) > 0);
        if (md->isProcedure && !fromTransformer)
            report(md->loc,
                   "'" + md->name + "' is written as a `procedure`, but no transformer this type "
                   "applies declares it. A procedure's signature is completed by the transformer "
                   "that declared it; with none, this is an ordinary `method`.");
        if (!md->isProcedure && fromTransformer)
            report(md->loc,
                   "'" + md->name + "' comes from a transformer this type applies, so it is written "
                   "`procedure`, not `method`. The word is what makes the provenance readable "
                   "without an editor.");
    }
}

// The three rules `call` carries, checked where the parser recorded each site.
//
// APPLICATION AND REACH ARE DIFFERENT OPERATIONS, which is the subtle one: a `private procedure` IS
// applied -- it lands in the type as a private member and the type's own methods use it -- and what
// `private` denies is `call`. Visibility in the transformer governs reach, not existence.
void checkProcCalls(const ast::ClassDecl& target, const std::vector<std::string>& applied,
                    const Index& index) {
    const std::set<std::string> reachable(applied.begin(), applied.end());
    for (const ast::ClassDecl::ProcCall& pc : target.procCalls) {
        if (reachable.count(pc.transformer) == 0) {
            report(pc.loc,
                   "`call " + pc.transformer + "." + pc.procedure + "` is only legal inside a "
                   "declaration that applies '" + pc.transformer + "', and '" + target.name +
                   "' does not. Outside one it would be an action with no subject.");
            continue;
        }
        auto it = index.find(pc.transformer);
        if (it == index.end()) continue;
        const ast::MethodDecl* found = nullptr;
        for (const ast::MemberPtr& m : it->second->members)
            if (const ast::MethodDecl* md = asMethod(m); md != nullptr && md->name == pc.procedure)
                found = md;
        if (found == nullptr) {
            report(pc.loc, "transformer '" + pc.transformer + "' declares no procedure '" +
                               pc.procedure + "'");
            continue;
        }
        if (found->isAbstract)
            report(pc.loc,
                   "`call " + pc.transformer + "." + pc.procedure + "` has nothing to reach: '" +
                       pc.procedure + "' is a socket, so the transformer supplies no body for it. "
                       "Call it on the receiver instead -- `this." + pc.procedure + "()` -- which "
                       "is this type's own implementation.");
        else if (found->visibility == "private")
            report(pc.loc,
                   "procedure '" + pc.procedure + "' is private to transformer '" + pc.transformer +
                       "', so `call` cannot reach it. It is still APPLIED -- it lands in '" +
                       target.name + "' as a private member and this type's methods use it -- "
                       "because application and reach are different operations.");
        else if (found->isStatic)
            report(pc.loc, "`call` reaches an instance procedure; '" + pc.procedure +
                               "' is static, so write `" + target.name + "." + pc.procedure + "()`");
    }
}

// The `each` families an applied transformer declares, and the socket that declares each one.
std::map<std::string, const ast::MethodDecl*> eachFamilies(const std::vector<std::string>& applied,
                                                           const Index& index) {
    std::map<std::string, const ast::MethodDecl*> out;
    for (const std::string& tn : applied) {
        auto it = index.find(tn);
        if (it == index.end()) continue;
        for (const ast::MemberPtr& m : it->second->members)
            if (const ast::MethodDecl* md = asMethod(m); md != nullptr && md->isEachFamily)
                out[md->name] = md;
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
void bindEachTargets(ast::ClassDecl& target,
                     const std::map<std::string, const ast::MethodDecl*>& families) {
    if (families.empty()) return;
    for (const ast::MemberPtr& m : target.members) {
        auto* md = dynamic_cast<ast::MethodDecl*>(m.get());
        if (md == nullptr || !md->isProcedure || md->typeParams.empty()) continue;
        auto f = families.find(md->name);
        if (f == families.end()) continue;
        if (md->typeParams.size() != 1) {
            report(md->loc, "`procedure " + md->name + "` implements a per-target family, so it "
                            "binds exactly one target type");
            continue;
        }
        md->name = ast::mangleGeneric(md->name, md->typeParams);
        md->typeParams.clear();      // the argument is already concrete
        md->typeParamBounds.clear();
        md->isEachFamily = true;     // remembered for `mutual` and for provenance
    }
}

void expandInto(ast::ClassDecl& target, const Index& index, const std::set<std::string>& layouts) {
    bool hasLayout = target.isLayout;
    for (const std::string& i : target.interfaces)
        if (layouts.count(i) > 0) hasLayout = true;
    std::vector<std::string> order;
    std::set<std::string> seen;
    // Provenance runs even with NO `applies`, and that half is the one that keeps the word honest:
    // a `procedure` on a type that applies nothing has no transformer to complete its signature, so
    // without this check `procedure` would quietly decay into a synonym for `method`.
    if (target.applies.empty()) {
        checkProvenance(target, order, index);
        checkProcCalls(target, order, index);   // `call` with nothing applied: reported, not ignored
        return;
    }
    for (std::size_t i = 0; i < target.applies.size(); ++i) {
        if (index.count(target.applies[i]) == 0) {
            report(i < target.appliesLocs.size() ? target.appliesLocs[i] : target.loc,
                   "unknown transformer '" + target.applies[i] + "'");
            continue;
        }
        closure(target.applies[i], index, order, seen);
    }
    // BEFORE anything reads the member names: after this, `into<Fahrenheit>` IS `into$Fahrenheit`,
    // and provenance, socket satisfaction and `mutual` all read one consistent set of names.
    const std::map<std::string, const ast::MethodDecl*> families = eachFamilies(order, index);
    bindEachTargets(target, families);
    checkProvenance(target, order, index);
    checkProcCalls(target, order, index);
    for (const std::string& tn : order) {
        auto it = index.find(tn);
        if (it == index.end()) continue;
        // A LAYOUT IS AN ABI. `Dirent` exists to match the bytes Linux expects, so a transformer
        // that brings a field would break it silently -- the one interaction in the language where
        // "purely additive" is false.
        if (hasLayout) {
            bool bringsField = false;
            for (const ast::MemberPtr& m : it->second->members)
                if (dynamic_cast<const ast::FieldDecl*>(m.get()) != nullptr) bringsField = true;
            if (bringsField) {
                report(target.loc,
                       "'" + target.name + "' has a pinned layout, which is an ABI, and transformer '" +
                           tn + "' brings a field -- applying it would move the bytes something "
                           "outside this program is matching. A type with a layout may only apply "
                           "field-less transformers.");
                continue;
            }
        }
        applyOne(*it->second, target, target.appliesLocs.empty() ? target.loc : target.appliesLocs[0]);
    }
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
void checkMutual(const ast::Program& program, const Index& index) {
    std::map<std::string, const ast::ClassDecl*> types;
    for (const ast::Bundle& b : program.bundles)
        for (const ast::Namespace& ns : b.namespaces)
            for (const ast::ClassDecl& c : ns.classes) types[c.name] = &c;

    auto declares = [](const ast::ClassDecl& c, const std::string& member) {
        for (const ast::MemberPtr& m : c.members)
            if (const ast::MethodDecl* md = asMethod(m); md != nullptr && md->name == member)
                return true;
        return false;
    };

    for (const auto& [name, decl] : types) {
        for (std::size_t i = 0; i < decl->applies.size(); ++i) {
            auto ti = index.find(decl->applies[i]);
            if (ti == index.end() || !ti->second->isMutualTransformer) continue;
            const SourceLocation where =
                i < decl->appliesLocs.size() ? decl->appliesLocs[i] : decl->loc;
            for (const ast::MemberPtr& tm : ti->second->members) {
                const ast::MethodDecl* socket = asMethod(tm);
                if (socket == nullptr || !socket->isEachFamily) continue;
                const std::string prefix = socket->name + "$";
                for (const ast::MemberPtr& own : decl->members) {
                    const ast::MethodDecl* impl = asMethod(own);
                    if (impl == nullptr || impl->name.rfind(prefix, 0) != 0) continue;
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
                    for (const std::string& a : oi->second->applies)
                        if (a == ti->second->name) appliesIt = true;
                    if (!appliesIt)
                        report(where,
                               "transformer '" + ti->second->name + "' is `mutual`, and '" + name +
                                   "' implements " + pair + " -- so '" + other + "' must apply '" +
                                   ti->second->name + "' too, and does not. A pair is symmetric or "
                                   "it is not a pair.");
                    else if (!declares(*oi->second, socket->name + "$" + name))
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
            for (const ast::ClassDecl& c : ns.classes)
                if (c.name == name) taken = true;
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
    const Index index = indexTransformers(program);
    const std::set<std::string> layouts = indexLayouts(program);
    for (ast::Bundle& b : program.bundles) {
        for (ast::Namespace& ns : b.namespaces) {
            synthesizeErrorTypes(ns);  // before expansion: a procedure may name its own error type
            for (ast::ClassDecl& t : ns.transformers) {
                checkTransport(t, index);
                // A WARNING, not an error, for the same reason the PascalCase one is: it nudges the
                // convention without breaking code that predates it.
                if (!b.isPrelude && !b.isImported && !followsConvention(t.name))
                    warn(t.nameLoc.line != 0 ? t.nameLoc : t.loc,
                         "transformer '" + t.name + "' should be named `" + conventionalName(t.name) +
                             "` -- a transformer is named `T` + stem + `er`, because it is the "
                             "COUPLING between two types and not either of them, and the `T` says "
                             "which of the clauses on a class line you are reading");
            }
            for (ast::ClassDecl& c : ns.classes) expandInto(c, index, layouts);
        }
    }
    checkMutual(program, index);  // after every type: the answer is about somebody else's members
    return g_errors == 0;
}

}  // namespace ldp3
