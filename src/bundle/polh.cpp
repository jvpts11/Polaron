#include "bundle/polh.h"

namespace polaron {
namespace {

using namespace ast;

// A type spelled for the header: generic mangling ("Box$int") shown as source ("Box<int>"), then the
// array / pointer / reference / nullable markers. One level of generics is demangled; deeper nesting
// keeps the mangled args (refined when the header is re-parsed for type-checking, phase 2).
std::string spellType(const TypeRef& t) {
    std::string out;
    const std::size_t sep = t.name.find('$');
    if (sep == std::string::npos) {
        out = t.name;
        if (!t.typeArgs.empty()) {
            out += "<";
            for (std::size_t i = 0; i < t.typeArgs.size(); ++i) {
                if (i) {
                    out += ", ";
                }
                out += t.typeArgs[i];
            }
            out += ">";
        }
    } else {
        out = t.name.substr(0, sep) + "<";
        std::size_t start = sep + 1;
        bool first = true;
        while (start <= t.name.size()) {
            const std::size_t next = t.name.find('$', start);
            if (!first) {
                out += ", ";
            }
            out += t.name.substr(start, next == std::string::npos ? std::string::npos : next - start);
            first = false;
            if (next == std::string::npos) {
                break;
            }
            start = next + 1;
        }
        out += ">";
    }
    if (t.arrayElemPointer) {
        out += "*";
    }
    out += arrayDimsSuffix(t.arrayDims);
    for (int i = 0; i < t.pointerDepth; ++i) {
        out += "*";
    }
    if (t.isRef) {
        out += "&";
    }
    // `nullable T`, never `T?`. THE PARSER HAS NO TRAILING `?` -- it reads the `nullable` keyword before
    // the type and nothing else (parser.cpp, KwNullable) -- so a header spelled `Cell*?` is a file this
    // compiler wrote and cannot read back. Any bundle with a public nullable field failed at
    // `failed to parse the header of bundle '...'`, which names the file and not the reason.
    if (t.isNullable) {
        return "nullable " + out;
    }
    return out;
}

std::string spellParams(const std::vector<Param>& params) {
    std::string out;
    for (std::size_t i = 0; i < params.size(); ++i) {
        if (i) {
            out += ", ";
        }
        out += spellType(params[i].type) + " " + params[i].name;
    }
    return out;
}

std::string spellTypeParams(const std::vector<std::string>& tps) {
    if (tps.empty()) {
        return "";
    }
    std::string out = "<";
    for (std::size_t i = 0; i < tps.size(); ++i) {
        if (i) {
            out += ", ";
        }
        out += tps[i];
    }
    return out + ">";
}

// Members visible across a bundle boundary: public (callers) and protected (subclassers).
bool exposed(const std::string& vis) { return vis == "public" || vis == "protected"; }

// A private INSTANCE field is invisible to the consumer and yet occupies space, so every public field
// declared after one sits at a different offset on the two sides. That is not a visibility question,
// it is a layout question, and getting it wrong is silent: the consumer reads and writes the same
// wrong place, so nothing looks broken from where it is standing. (Measured before this existed: a
// consumer's `b.visible = 7` landed in the bundle's private `hidden`.)
//
// So the private field crosses as an unnamed RESERVATION -- its bytes, never its name. Keeping the
// name out is not tidiness: the header is what the ABI fingerprint hashes, so a leaked name would make
// RENAMING a private field invalidate every consumer, which is exactly the recompilation the
// fingerprint exists to avoid asking for.
//
// The widths below are measured from emitted IR, not assumed:
//   byte i8 | short i16 | int i32 | long i64 | float | double | boolean i32 (!) | char i32 (!)
//   address i64 | everything else (class, struct, record, String, array, nullable, pointer) -> ptr
//   weak T*  -> %WeakSlot = { ptr, ptr }, SIXTEEN bytes, not eight
// `boolean` and `char` being 32 bits wide is the surprise; a header that guessed 8 would misplace
// every field after one.
bool isScalarWidth(const TypeRef& t) {
    if (t.pointerDepth > 0 || t.isRef || t.isNullable || t.isArray || t.arrayDims > 0 || t.arrayElemPointer) {
        return false;
    }
    const std::string& n = t.name;
    return n == "byte" || n == "short" || n == "int" || n == "long" || n == "float" ||
           n == "double" || n == "boolean" || n == "char" || n == "address";
}

// The reservation for one private instance field, as header source. `index` numbers the synthesized
// names so they are stable under a rename of the real field.
std::string spellReservation(const FieldDecl& f, int index) {
    const std::string name = "__reserved" + std::to_string(index);
    if (f.isWeak) {  // a weak slot is two pointers; two reservations reproduce its 16 bytes and 8-alignment
        return "private mutable address " + name + "a;\nprivate mutable address " + name + "b;";
    }
    if (f.bitWidth > 0) {  // a bit field must keep its width, or the packing run it belongs to changes
        return "private mutable " + spellType(f.type) + " " + name + " : " + std::to_string(f.bitWidth) + ";";
    }
    if (isScalarWidth(f.type)) {
        return "private mutable " + spellType(f.type) + " " + name + ";";
    }
    return "private mutable address " + name + ";";  // every non-scalar is one pointer in the object
}

// Spell a constant field initializer back to source. A static field with a literal initializer must
// carry its value across the bundle boundary, or an importer that reads `GL.X` sees an uninitialized
// global (0). Only literal forms are spelled; a non-literal initializer is dropped (value omitted).
std::string spellConstInit(const Expr* e) {
    if (e == nullptr) {
        return "";
    }
    if (const auto* i = dynamic_cast<const IntLiteralExpr*>(e)) {
        return i->text;
    }
    if (const auto* f = dynamic_cast<const FloatLiteralExpr*>(e)) {
        return f->text;
    }
    if (const auto* b = dynamic_cast<const BoolLiteralExpr*>(e)) {
        return b->value ? "true" : "false";
    }
    if (const auto* c = dynamic_cast<const CharLiteralExpr*>(e)) {
        return "'" + c->value + "'";
    }
    if (const auto* s = dynamic_cast<const StringLiteralExpr*>(e)) {
        return "\"" + s->value + "\"";
    }
    return "";
}

struct Emitter {
    std::string out;
    int indent = 0;
    void line(const std::string& s) {
        out.append(static_cast<std::size_t>(indent) * 4, ' ');
        out += s;
        out += '\n';
    }
};

void emitMethod(Emitter& e, const MethodDecl& m) {
    // Interface methods have implicit (empty) visibility and are always public API; class members
    // with an explicit private/internal visibility are not exposed.
    if (!m.visibility.empty() && !exposed(m.visibility)) {
        return;
    }
    // THE ORDER HERE IS THE ORDER THE PARSER DEMANDS (spec 37.9): visibility, foreignness, binding,
    // then the rest. It is not cosmetic -- a header is re-parsed by this same compiler, so writing
    // `static extern` produces a file that cannot be read back, and the failure surfaces far away
    // as "failed to parse the header of bundle X" on a file nobody wrote by hand.
    std::string s = m.visibility.empty() ? "" : m.visibility + " ";
    if (m.isExtern) {
        s += "extern " + (m.externConvention.empty() ? "" : m.externConvention + " ");
    }
    if (m.isStatic) {
        s += "static ";
    }
    if (m.isAbstract) {
        s += "abstract ";
    }
    if (m.isOverride) {
        s += "override ";
    }
    if (m.isFinal) {
        s += "final ";
    }
    if (m.isAsync) {
        s += "async ";
    }
    if (m.isComptime) {
        s += "comptime ";
    }
    if (m.isVolatile) {
        s += "volatile ";
    }
    // Operators are stored as methods named "operator<sym>" (spec 6.5) / "operator cast$T" (6.6). Spell
    // them back as operator syntax: a literal "method operator+" is not valid Polaron and would not re-parse.
    if (m.name.rfind("operator", 0) == 0) {
        const std::string rest = m.name.substr(8);  // after "operator"
        if (rest.rfind(" cast$", 0) == 0) {
            s += "operator cast<" + rest.substr(6) + ">()";
        } else {
            s += "operator " + rest + " (" + spellParams(m.params) + ")";
        }
        s += " returns " + spellType(m.returnType) + ";";
        e.line(s);
        return;
    }
    s += "method " + m.name + spellTypeParams(m.typeParams) + "(" + spellParams(m.params) + ")";
    s += " returns " + spellType(m.returnType);
    if (!m.throwsTypes.empty()) {
        s += " throws(";
        for (std::size_t i = 0; i < m.throwsTypes.size(); ++i) {
            if (i) {
                s += ", ";
            }
            s += spellType(m.throwsTypes[i]);
        }
        s += ")";
    }
    // The linker symbol, when it differs from the method's name. It has to cross: a consumer that
    // re-declared the extern from this header without it would bind the Polaron name and never reach
    // the foreign one -- an undefined symbol at link, naming something nobody wrote.
    if (m.isExtern && !m.externSymbol.empty()) {
        s += " symbol(\"" + m.externSymbol + "\")";
    }
    // region-binder escape summary (so imported callers can check container methods): `escapes(i:slot, ...)`
    // where slot -1 = the receiver, j = parameter j. Omitted when the method stores none of its parameters.
    if (!m.escapeSummary.empty()) {
        s += " escapes(";
        for (std::size_t i = 0; i < m.escapeSummary.size(); ++i) {
            if (i) {
                s += ", ";
            }
            s += std::to_string(m.escapeSummary[i].first) + ":" + std::to_string(m.escapeSummary[i].second);
        }
        s += ")";
    }
    e.line(s + ";");
}

void emitField(Emitter& e, const FieldDecl& f, int& reservedCount) {
    if (!exposed(f.visibility)) {
        // A static field has no instance storage, so it changes no offset and crosses as nothing.
        if (f.isStatic) {
            return;
        }
        const std::string res = spellReservation(f, reservedCount++);
        std::size_t start = 0;  // spellReservation may return two lines (a weak slot)
        while (start < res.size()) {
            const std::size_t nl = res.find('\n', start);
            e.line(res.substr(start, nl == std::string::npos ? std::string::npos : nl - start));
            if (nl == std::string::npos) {
                break;
            }
            start = nl + 1;
        }
        return;
    }
    // spec 32.9: an affinity decides where the field sits in the object, so it MUST cross the bundle
    // boundary -- a consumer that laid the same class out in declaration order would disagree with the
    // bundle's own code about every offset. Each field is re-emitted in its own one-field block; the
    // grouping is by affinity, not by how many blocks it was written in, so the layout is identical.
    if (!f.affinity.empty()) {
        e.line("affinity " + f.affinity + " {");
        ++e.indent;
    }
    std::string s = f.visibility + " ";
    if (f.isStatic) {
        s += "static ";
    }
    if (f.isMutable) {
        s += "mutable ";
    }
    if (f.isPersistent) {
        s += f.isEternal ? "eternal persistent " : "persistent ";
    }
    if (f.isTransient) {
        s += "transient ";
    }
    if (f.isVolatile) {
        s += "volatile ";
    }
    if (f.isLazy) {
        s += "lazy ";
    }
    if (f.isExternal) {
        s += "external ";
    }
    if (f.isMovable) {
        s += "movable ";
    }
    if (f.isUnique) {
        s += "unique ";
    }
    // `weak` is not a permission, it is a SIZE. A weak field is a `%WeakSlot = { ptr, ptr }` -- sixteen
    // bytes, because the slot carries its place in the pointee's weak list so it can be nulled when the
    // pointee dies. Spelled as a plain pointer in the header, a consumer would lay it out as eight and
    // misplace every field after it. (The reservation for a PRIVATE weak field already reserved two
    // words for exactly this reason; the public one was reading its own rule and not applying it.)
    if (f.isWeak) {
        s += "weak ";
    }
    s += spellType(f.type) + " " + f.name;
    if (f.bitWidth > 0) {
        s += " : " + std::to_string(f.bitWidth);
    }
    if (f.isStatic) {
        const std::string v = spellConstInit(f.init.get());  // carry a static constant's value across bundles
        if (!v.empty()) {
            s += " = " + v;
        }
    }
    e.line(s + ";");
    if (!f.affinity.empty()) {
        --e.indent;
        e.line("}");
    }
}

void emitClass(Emitter& e, const ClassDecl& c) {
    if (c.visibility != "public") {
        return;
    }
    // Skip monomorphized instances (Box$int): they are an implementation detail the consumer regenerates
    // from the generic template and its own uses, and their spelled form is not valid header syntax.
    if (c.name.find('$') != std::string::npos) {
        return;
    }
    std::string kind = "class";
    if (c.isInterface) {
        kind = "interface";
    } else if (c.isLayout) {
        // A layout must cross, because IMPLEMENTING ONE REORDERS THE FIELDS -- widest alignment first,
        // in codegen's `orderForLayout`. A consumer that did not know a struct was arranged would lay
        // it out in declaration order and disagree with the bundle's own code about every offset after
        // the first: the same silent divergence private fields used to cause, arrived at from a
        // different direction.
        //
        // Only the FACT of it needs to travel. The reordering is triggered by there being a layout at
        // all, not by what that layout asks for, so the header carries an empty arrangement rather than
        // a copy of a budget the library has already satisfied.
        kind = "layout";
    } else if (c.isStruct) {
        kind = "struct";
    } else if (c.isRecord) {
        kind = "record";
    } else if (c.isUnion) {
        kind = "union";
    }

    std::string head = "public ";
    if (c.isAbstract && !c.isInterface && !c.isLayout) {
        head += "abstract ";
    }
    if (c.isFinal) {
        head += "final ";
    }
    if (c.isSealed) {
        head += "sealed ";
    }
    if (c.isMovable) {
        head += "movable ";
    }
    if (c.isUnique) {
        head += "unique ";
    }
    if (c.isPartitionable) {
        head += "partitionable ";
    }
    // A REGION CLASS MUST CROSS, for the reason every other ABI fact in this file must: it changes what
    // `new` does. Instances come from the type's own region, not the heap, and a consumer that read this
    // header as an ordinary class would allocate one on the heap -- an object of the right shape in the
    // wrong place, which the family's region then does not own and `unimport` does not see.
    if (c.isRegionClass) {
        head += "region ";
    }
    head += kind + " " + c.name;
    // `library NAME` travels because the LINK does. The externs behind it are private and never appear
    // in this header, so without the clause the consuming program has no way to learn that linking this
    // bundle also means linking SDL2 -- the first evidence would be an unresolved symbol naming a method
    // the program never wrote.
    if (!c.foreignLibrary.empty()) {
        head += " library " + c.foreignLibrary;
    }
    head += spellTypeParams(c.typeParams);
    if (!c.superclass.empty()) {
        head += " extends " + c.superclass;
    }
    // Layouts travel back in the same `implements` clause they arrived in. `layouts.cpp` moves them out
    // of `interfaces` before the analyser runs, so re-joining them here is not a merge of two ideas --
    // it is putting back the one clause the author wrote.
    if (!c.interfaces.empty() || !c.layouts.empty()) {
        head += " implements ";
        bool first = true;
        for (const std::string& name : c.interfaces) {
            if (!first) {
                head += ", ";
            }
            head += name;
            first = false;
        }
        for (const std::string& name : c.layouts) {
            if (!first) {
                head += ", ";
            }
            head += name;
            first = false;
        }
    }
    if (!c.permits.empty()) {
        head += " permits ";
        for (std::size_t i = 0; i < c.permits.size(); ++i) {
            if (i) {
                head += ", ";
            }
            head += c.permits[i];
        }
    }
    // A layout's body is its `onArrange` budget, which belongs to the library that had to meet it. The
    // consumer needs the name to bind an `implements` to, and nothing else.
    if (c.isLayout) {
        e.line(head + " { }");
        return;
    }
    e.line(head + " {");
    ++e.indent;
    int reservedCount = 0;   // numbers this class's private-field reservations, in declaration order
    for (const MemberPtr& m : c.members) {
        if (const auto* method = dynamic_cast<const MethodDecl*>(m.get())) {
            emitMethod(e, *method);
        } else if (const auto* field = dynamic_cast<const FieldDecl*>(m.get())) {
            emitField(e, *field, reservedCount);
        } else if (const auto* ctor = dynamic_cast<const ConstructorDecl*>(m.get())) {
            if (exposed(ctor->visibility)) {
                e.line(ctor->visibility + " constructor " + c.name + "(" + spellParams(ctor->params) + ");");
            }
        } else if (const auto* lit = dynamic_cast<const LiteralDecl*>(m.get())) {
            if (exposed(lit->visibility)) {
                e.line(lit->visibility + " comptime literal " + lit->name + "(" +
                       spellType(lit->param.type) + " " + lit->param.name + ") returns " +
                       spellType(lit->returnType) + ";");
            }
        } else if (const auto* cst = dynamic_cast<const ConstDecl*>(m.get())) {
            if (exposed(cst->visibility)) {
                e.line(cst->visibility + " const " + spellType(cst->type) + " " + cst->name + ";");
            }
        }
    }
    --e.indent;
    e.line("}");
}

void emitEnum(Emitter& e, const EnumDecl& en) {
    if (en.visibility != "public") {
        return;
    }
    std::string s = "public enum " + en.name + " { ";
    for (std::size_t i = 0; i < en.constants.size(); ++i) {
        if (i) {
            s += ", ";
        }
        s += en.constants[i];
    }
    s += " }";
    if (!en.isJavaStyle) {
        e.line(s);
        return;
    }
    // Java-style: keep the constant list, then expose the public method signatures.
    e.line("public enum " + en.name + " {");
    ++e.indent;
    std::string consts;
    for (std::size_t i = 0; i < en.constants.size(); ++i) {
        if (i) {
            consts += ", ";
        }
        consts += en.constants[i];
    }
    e.line(consts + ";");
    for (const MemberPtr& m : en.members) {
        if (const auto* method = dynamic_cast<const MethodDecl*>(m.get())) {
            emitMethod(e, *method);
        }
    }
    --e.indent;
    e.line("}");
}

void emitCatalog(Emitter& e, const CatalogDecl& cat) {
    if (cat.visibility != "public") {
        return;
    }
    e.line("public catalog " + cat.name + " {");
    ++e.indent;
    for (const std::string& v : cat.requiredValues) {
        e.line(v + ";");
    }
    for (const MemberPtr& m : cat.methods) {
        if (const auto* method = dynamic_cast<const MethodDecl*>(m.get())) {
            emitMethod(e, *method);
        }
    }
    --e.indent;
    e.line("}");
}

// A TRANSFORMER CROSSES AS ITS OWN SOURCE, and that is the point rather than a shortcut.
//
// Everything else in a header is a signature, because a caller of a compiled method needs to know
// how to call it and nothing more. A transformer is never compiled -- it is expanded, and what the
// applying type receives is the BODY. A header carrying only its signatures would ship half the
// feature: sockets would still be demanded, and every free implementation would silently vanish, so
// a type that applied it across a bundle boundary would fail to compile naming a procedure the
// transformer plainly declares.
//
// It has no runtime existence at all -- nothing of it reaches the executable under its own name --
// so its text IS its interface, exactly as a header-only template's is.
void emitTransformer(Emitter& e, const ClassDecl& t) {
    if (!exposed(t.visibility)) {
        return;   // a private transformer is its bundle's own equipment
    }
    if (t.sourceText.empty()) {
        // Nothing to publish and nothing that would work: said out loud, because a header that
        // silently omitted it would fail later at the consumer, on their `applies` line, about a
        // transformer that looks perfectly present in the source they are reading.
        e.line("// transformer '" + t.name + "' could not be published: its source was not captured");
        return;
    }
    // The slice begins at the declaration's first character, so every line after it still carries the
    // indentation it had in its own file. Strip exactly that much and let the emitter re-apply its
    // own, or the body arrives in the header hanging off to the right of the brace that opened it.
    const std::size_t hang = t.loc.col > 1 ? static_cast<std::size_t>(t.loc.col - 1) : 0;
    std::size_t start = 0;
    bool first = true;
    while (start <= t.sourceText.size()) {
        const std::size_t nl = t.sourceText.find('\n', start);
        const std::size_t end = nl == std::string::npos ? t.sourceText.size() : nl;
        std::string ln = t.sourceText.substr(start, end - start);
        while (!ln.empty() && (ln.back() == '\r' || ln.back() == ' ')) {
            ln.pop_back();
        }
        if (!first) {
            std::size_t drop = 0;
            while (drop < hang && drop < ln.size() && ln[drop] == ' ') {
                ++drop;
            }
            ln.erase(0, drop);
        }
        first = false;
        e.line(ln);
        if (nl == std::string::npos) {
            break;
        }
        start = nl + 1;
    }
}

void emitNamespace(Emitter& e, const Namespace& ns) {
    if (ns.visibility != "public") {
        return;
    }
    e.line("public namespace " + ns.name + " {");
    ++e.indent;
    for (const TypeAliasDecl& a : ns.typeAliases) {
        if (a.visibility == "public") {
            e.line("public " + std::string(a.isNewtype ? "newtype " : "typealias ") + a.name +
                   " = " + spellType(a.target) + ";");
        }
    }
    // BEFORE the classes, because a class in this same namespace may apply one and a header is read
    // back by the same parser that reads source: a forward reference costs nothing, but keeping the
    // declaration order that a human would write costs nothing either and reads correctly.
    for (const ClassDecl& t : ns.transformers) {
        emitTransformer(e, t);
    }
    for (const ClassDecl& c : ns.classes) {
        emitClass(e, c);
    }
    for (const EnumDecl& en : ns.enums) {
        emitEnum(e, en);
    }
    for (const CatalogDecl& cat : ns.catalogs) {
        emitCatalog(e, cat);
    }
    --e.indent;
    e.line("}");
}

}  // namespace

std::string generatePolh(const Program& program) {
    Emitter e;
    e.line("program " + program.name + ";");
    e.line("");
    for (const Bundle& b : program.bundles) {
        if (b.isPrelude || b.visibility != "public") {
            continue;  // the .polh describes user source only
        }
        e.line("public bundle " + b.name + (b.isFreestanding ? " freestanding" : "") + " {");
        ++e.indent;
        for (const Namespace& ns : b.namespaces) {
            emitNamespace(e, ns);
        }
        --e.indent;
        e.line("}");
    }
    return e.out;
}

}  // namespace polaron
