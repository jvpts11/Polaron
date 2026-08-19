// THE STRUCTURAL ADVICE THAT IS ABOUT A DECLARATION rather than about a statement.
//
// Every rule here has the same shape: a structure the compiler can see without guessing, a feature
// of the language that says the same thing shorter and checks more, and a gain that follows from
// the swap. Nothing infers intent. Where a shape is decidable but the reason for it is not, the rule
// still reports and `[Allow(code:, why:)]` is how the reason gets written down.
//
// The statement-level rules live beside the statements they read, in analyzer_stmt.cpp. The split is
// by what the rule LOOKS AT, not by what it is called, so a rule is always next to the thing it
// needs to understand.

#include "semantic/analyzer.h"
#include "semantic/semutil.h"

#include <algorithm>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace polaron {

using namespace semutil;   // NOLINT(google-build-using-namespace): as in analyzer.cpp

namespace {

// The Hungarian prefixes, and the type each one claims. A prefix that agrees with the resolved type
// is the whole test: `bFlag` on a boolean is the notation; `bytes` on an int is a word.
struct Hungarian {
    const char* prefix;
    const char* meaning;
};
constexpr Hungarian kHungarian[] = {
    {"b", "boolean"}, {"p", "a pointer"}, {"n", "an integer"},  {"dw", "an integer"},
    {"i", "an integer"}, {"str", "a string"}, {"sz", "a string"}, {"lst", "a collection"},
};

// `bFlag` -> prefix "b"; `bytes` -> nothing, because the character after the prefix must be an
// upper-case letter. That is what separates the notation from a word that starts the same way.
const Hungarian* hungarianPrefixOf(const std::string& name) {
    const Hungarian* best = nullptr;
    for (const Hungarian& h : kHungarian) {
        const std::size_t n = std::char_traits<char>::length(h.prefix);
        if (name.size() <= n || name.compare(0, n, h.prefix) != 0) {
            continue;
        }
        if (std::isupper(static_cast<unsigned char>(name[n])) == 0) {
            continue;
        }
        if (best == nullptr || n > std::char_traits<char>::length(best->prefix)) {
            best = &h;   // longest wins: `dwCount` is `dw`, not `d`
        }
    }
    return best;
}

bool typeAgreesWith(const std::string& type, const std::string& meaning) {
    const std::string base = baseType(type);
    if (meaning == "boolean") {
        return base == "boolean";
    }
    if (meaning == "a pointer") {
        return type.find('*') != std::string::npos;
    }
    if (meaning == "an integer") {
        return isIntName(base);
    }
    if (meaning == "a string") {
        return base == "String" || base == "string";
    }
    if (meaning == "a collection") {
        return type.find("[]") != std::string::npos || base.rfind("ArrayList", 0) == 0 ||
               base.rfind("HashMap", 0) == 0 || base.rfind("HashSet", 0) == 0;
    }
    return false;
}

// The longest prefix shared by every name in the group, cut at the last upper-case boundary so
// `MAX_SPEED`/`MAX_LOAD` share `MAX_` rather than `MAX_`+a stray letter.
std::string commonPrefix(const std::vector<std::string>& names) {
    if (names.size() < 2) {
        return {};
    }
    std::string p = names.front();
    for (const std::string& n : names) {
        std::size_t i = 0;
        while (i < p.size() && i < n.size() && p[i] == n[i]) {
            ++i;
        }
        p.resize(i);
    }
    const std::size_t cut = p.find_last_of('_');
    return cut == std::string::npos ? std::string() : p.substr(0, cut + 1);
}

}  // namespace

void SemanticAnalyzer::adviseOnClass(const ast::ClassDecl& c) {
    // A class-shaped rule reads only the declaration, so all of them share one walk over the members
    // rather than each opening the list again.
    std::vector<const ast::MethodDecl*> methods;
    std::vector<const ast::FieldDecl*> fields;
    std::vector<const ast::ConstDecl*> constants;
    const ast::DestructorDecl* dtor = nullptr;
    for (const ast::MemberPtr& m : c.members) {
        if (const auto* md = dynamic_cast<const ast::MethodDecl*>(m.get())) {
            methods.push_back(md);
        } else if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            fields.push_back(fd);
        } else if (const auto* cd = dynamic_cast<const ast::ConstDecl*>(m.get())) {
            constants.push_back(cd);
        } else if (const auto* dd = dynamic_cast<const ast::DestructorDecl*>(m.get())) {
            dtor = dd;
        }
    }
    pushAllows(c.annotations, {});

    // ---- a pointer field the destructor frees by hand is `unique` (catalogue 8) ----
    //
    // Writing `delete this.f` in a destructor is a claim: this object owns what `f` points at, and
    // nothing else will free it. The claim is true or the program double-frees, and today nothing
    // but discipline keeps it true -- a second field pointed at the same object, a copy handed out,
    // and the destructor runs twice on one allocation.
    if (dtor != nullptr) {
        std::unordered_set<std::string> freed;
        for (const ast::StmtPtr& st : dtor->body.statements) {
            const auto* del = dynamic_cast<const ast::DeleteStmt*>(st.get());
            if (del == nullptr) {
                continue;
            }
            // `this` is an ordinary identifier in this AST, not a node of its own.
            if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(del->target.get());
                mem != nullptr) {
                const auto* obj = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get());
                if (obj != nullptr && obj->name == "this") {
                    freed.insert(mem->member);
                }
            }
        }
        for (const ast::FieldDecl* f : fields) {
            const std::string t = typeRefStr(f->type);
            if (freed.count(f->name) == 0 || f->isUnique || f->isWeak || isArrayType(t)) {
                continue;
            }
            if (t.find('*') == std::string::npos) {
                continue;   // only a pointer field carries an ownership question
            }
            warn(diag::Code::OwnershipByDiscipline,
                 "'" + c.name + "." + f->name + "' is freed by the destructor, which is a claim "
                 "about ownership the declaration does not make",
                 f->loc);
        }
    }

    // ---- the same condition guarding the start of several methods is an invariant (cat. 52) ----
    //
    // A condition checked at the top of method after method is a property of the OBJECT that each
    // method is re-establishing on its own. Written as an `invariant` it is checked at every entry
    // and every exit -- including the ones nobody remembered to guard -- and it is handed to the
    // optimiser as a fact rather than tested again.
    {
        std::unordered_map<std::string, int> guards;
        std::unordered_map<std::string, SourceLocation> firstGuard;
        for (const ast::MethodDecl* m : methods) {
            if (m->isStatic || m->body.statements.empty()) {
                continue;
            }
            const auto* iff = dynamic_cast<const ast::IfStmt*>(m->body.statements[0].get());
            if (iff == nullptr || iff->cond == nullptr) {
                continue;
            }
            // The condition has to MENTION `this`, or it is about the arguments rather than the
            // object, and an invariant is the wrong word for it.
            std::string text;
            iff->cond->dump(text, 0);
            if (text.find("this") == std::string::npos) {
                continue;
            }
            if (++guards[text] == 1) {
                firstGuard[text] = iff->loc;
            }
        }
        for (const auto& [text, count] : guards) {
            if (count >= 3) {
                warn(diag::Code::GuardThatIsAnInvariant,
                     std::to_string(count) +
                         " methods here open by checking the same thing about this object",
                     firstGuard[text]);
            }
        }
    }

    // ---- a bag of static methods is a transformer that has not been written (catalogue 19) ----
    //
    // Every member static, three or more of them, and no state: that is not an object, it is a
    // namespace with a class around it. A transformer says the same thing and says it better --
    // its procedures are expanded into the type that applies them, so they reach `itself` instead
    // of taking the subject as an argument, and they cost no call.
    if (!c.isInterface && !c.isAbstract && fields.empty() && methods.size() >= 3 &&
        std::all_of(methods.begin(), methods.end(),
                    [](const ast::MethodDecl* m) { return m->isStatic; })) {
        warn(diag::Code::StaticsWithoutState,
             "'" + c.name + "' is " + std::to_string(methods.size()) +
                 " static methods and no state, which is a namespace rather than a class",
             c.loc);
    }

    // ---- data with no behaviour is a record (catalogue 11) ----
    //
    // Public fields, no methods, no invariant: the class is a row. A `record` says that, and the
    // compiler then writes the equality, the hash and the copy that would otherwise be forgotten
    // or written three different ways.
    if (!c.isRecord && !c.isStruct && !c.isInterface && !c.isAbstract && !c.isUnion &&
        c.invariants.empty() && methods.empty() && fields.size() >= 2 &&
        std::all_of(fields.begin(), fields.end(), [](const ast::FieldDecl* f) {
            return f->visibility == "public" && !f->isStatic;
        })) {
        warn(diag::Code::DataWithoutBehaviour,
             "'" + c.name + "' is " + std::to_string(fields.size()) +
                 " public fields with no methods and no invariant",
             c.loc);
    }

    // ---- constants with a shared prefix are an enum (catalogue 12) ----
    //
    // Three or more `fixed int` constants whose names share a prefix are a set somebody is keeping
    // by hand: nothing stops two of them being equal, nothing makes a `match` over them complete,
    // and nothing stops an int that is none of them being passed where one is expected.
    {
        std::vector<std::string> names;
        SourceLocation first{};
        for (const ast::ConstDecl* k : constants) {
            if (!isIntName(baseType(typeRefStr(k->type)))) {
                continue;
            }
            if (names.empty()) {
                first = k->loc;
            }
            names.push_back(k->name);
        }
        if (names.size() >= 3) {
            if (const std::string p = commonPrefix(names); !p.empty()) {
                warn(diag::Code::ConstantsThatAreAnEnum,
                     std::to_string(names.size()) + " constants here share the prefix '" + p +
                         "', which is a set being kept by hand",
                     first);
            }
        }
    }

    // ---- a static method whose first parameter is its own class (catalogue 2) ----
    //
    // `Board.place(Board* b, int at)` is an instance method with the receiver written out. `this`
    // is not shorter typing: it is a receiver the alias analysis understands, it dispatches, and it
    // cannot be handed the wrong object of the right type.
    for (const ast::MethodDecl* m : methods) {
        if (!m->isStatic || m->params.empty()) {
            continue;
        }
        if (baseType(typeRefStr(m->params[0].type)) == c.name) {
            warn(diag::Code::StaticTakesItsOwnClass,
                 "'" + c.name + "." + m->name + "' is static and takes a '" + c.name +
                     "' as its first parameter, which is what a receiver is",
                 m->loc);
        }
    }

    // ---- two parameters of one primitive, in a row (catalogue 15) ----
    //
    // `place(int x, int y)` is fine because the pair is the concept. `move(int from, int to)` is not:
    // the two are different things wearing one type, and the compiler will accept them in either
    // order for as long as the program exists. Three or more of one primitive is where the odds stop
    // being on the author's side.
    for (const ast::MethodDecl* m : methods) {
        std::unordered_map<std::string, int> byType;
        for (const ast::Param& p : m->params) {
            const std::string t = typeRefStr(p.type);
            if (isIntName(baseType(t)) || baseType(t) == "boolean") {
                ++byType[baseType(t)];
            }
        }
        for (const auto& [t, n] : byType) {
            if (n >= 3) {
                warn(diag::Code::PrimitiveObsession,
                     "'" + m->name + "' takes " + std::to_string(n) + " parameters of type '" + t +
                         "', which the compiler will accept in any order",
                     m->loc);
            }
        }
    }

    // ---- parallel static arrays are a table with no type (catalogue 16) ----
    //
    // Three or more static arrays in one class, read by the same index, are one row spread sideways.
    // Nothing keeps them the same length, nothing keeps a row complete, and a row added to one and
    // forgotten in the others reads as a zero -- which is a value, so nothing complains.
    {
        int columns = 0;
        SourceLocation first{};
        for (const ast::FieldDecl* f : fields) {
            if (f->isStatic && isArrayType(typeRefStr(f->type))) {
                if (columns == 0) {
                    first = f->loc;
                }
                ++columns;
            }
        }
        if (columns >= 3) {
            warn(diag::Code::ParallelArrayTable,
                 std::to_string(columns) +
                     " static arrays here are one row read sideways, and nothing keeps them in step",
                 first);
        }
    }

    // ---- `toX`/`fromX` pairs are a transformer (catalogue 20) ----
    //
    // A pair of hand-written conversions is a relation between two types kept in two places. A
    // `transformer` declares the relation once; the compiler expands it into both sides, checks with
    // `entrusts` that the assembly is complete field by field, and -- with `collective` -- completes
    // the graph so N types cost N edges rather than N squared.
    {
        std::unordered_set<std::string> tos;
        std::unordered_set<std::string> froms;
        for (const ast::MethodDecl* m : methods) {
            if (m->name.rfind("to", 0) == 0 && m->name.size() > 2 &&
                std::isupper(static_cast<unsigned char>(m->name[2])) != 0) {
                tos.insert(m->name.substr(2));
            } else if (m->name.rfind("from", 0) == 0 && m->name.size() > 4 &&
                       std::isupper(static_cast<unsigned char>(m->name[4])) != 0) {
                froms.insert(m->name.substr(4));
            }
        }
        for (const std::string& other : tos) {
            if (froms.count(other) > 0) {
                warn(diag::Code::HandWrittenConversionPair,
                     "'" + c.name + "' converts to and from '" + other +
                         "' by hand, which is a relation kept in two places",
                     c.loc);
            }
        }
    }

    // ---- Hungarian notation (catalogue 1) ----
    //
    // A prefix that agrees with the resolved type is a type written twice: once where the compiler
    // checks it and once where nothing does. The second copy is the one that survives a change of
    // type, and then it is a lie in the name.
    auto checkName = [&](const std::string& name, const std::string& type, SourceLocation loc) {
        const Hungarian* h = hungarianPrefixOf(name);
        if (h != nullptr && typeAgreesWith(type, h->meaning)) {
            warn(diag::Code::HungarianNotation,
                 "'" + name + "' spells " + std::string(h->meaning) + " in its prefix, which is what "
                 "its type already says",
                 loc);
        }
    };
    for (const ast::FieldDecl* f : fields) {
        checkName(f->name, typeRefStr(f->type), f->loc);
    }
    for (const ast::MethodDecl* m : methods) {
        for (const ast::Param& p : m->params) {
            checkName(p.name, typeRefStr(p.type), p.loc);
        }
    }

    popAllows();
}

void SemanticAnalyzer::adviseOnDeclarations(const ast::Program& program) {
    const std::string savedNs = currentNamespace_;
    const std::string savedBundle = currentBundle_;

    // THE TWO RULES THAT NEED THE WHOLE PROGRAM, so the subtype map is built once, first. Both are
    // about a set of subtypes the compiler can already see and the declaration has not admitted to.
    std::unordered_map<std::string, std::vector<const ast::ClassDecl*>> children;
    std::vector<const ast::ClassDecl*> all;
    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            for (const ast::ClassDecl& c : ns.classes) {
                all.push_back(&c);
                if (!c.superclass.empty()) {
                    children[baseType(c.superclass)].push_back(&c);
                }
            }
        }
    }
    for (const ast::ClassDecl* c : all) {
        auto kids = children.find(c->name);
        if (kids == children.end() || kids->second.empty()) {
            continue;
        }
        pushAllows(c->annotations, {});
        // ---- a closed hierarchy that has not said so (catalogue 21) ----
        //
        // Every subtype is right here, in this program, and the base does not say so. Saying it with
        // `sealed ... permits` is what lets a `match` be checked for completeness and lets a call
        // through the base be resolved rather than dispatched -- and it turns the arrival of a
        // subtype nobody planned for into a compile error rather than a surprise at run time.
        if (!c->isSealed && !c->isFinal && !c->isInterface) {
            std::string names;
            for (const ast::ClassDecl* k : kids->second) {
                names += (names.empty() ? "" : ", ") + k->name;
            }
            warn(diag::Code::HierarchyNotSealed,
                 "'" + c->name + "' is extended only by " + names +
                     ", and every one of them is in this program",
                 c->loc);
        }
        // ---- an abstract class with exactly one subtype (catalogue 60) ----
        //
        // Two types describing one thing. The base cannot be instantiated and the subtype is the
        // only way to get one, so the split buys no polymorphism -- it costs a vtable, an indirect
        // call the compiler cannot see through, and a reader two files to hold at once.
        if (c->isAbstract && kids->second.size() == 1) {
            warn(diag::Code::AbstractWithOneSubtype,
                 "'" + c->name + "' is abstract and '" + kids->second.front()->name +
                     "' is its only subtype",
                 c->loc);
        }
        popAllows();
    }

    for (const ast::Bundle& bundle : program.bundles) {
        for (const ast::Namespace& ns : bundle.namespaces) {
            currentNamespace_ = ns.name;
            currentBundle_ = bundle.name;
            for (const ast::ClassDecl& c : ns.classes) {
                adviseOnClass(c);
            }
        }
    }
    currentNamespace_ = savedNs;
    currentBundle_ = savedBundle;
}

}  // namespace polaron
