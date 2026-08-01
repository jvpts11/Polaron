#include "bundle/ldh.h"

namespace ldp3 {
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
                if (i) out += ", ";
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
            if (!first) out += ", ";
            out += t.name.substr(start, next == std::string::npos ? std::string::npos : next - start);
            first = false;
            if (next == std::string::npos) break;
            start = next + 1;
        }
        out += ">";
    }
    if (t.arrayElemPointer) out += "*";
    out += arrayDimsSuffix(t.arrayDims);
    for (int i = 0; i < t.pointerDepth; ++i) out += "*";
    if (t.isRef) out += "&";
    if (t.isNullable) out += "?";
    return out;
}

std::string spellParams(const std::vector<Param>& params) {
    std::string out;
    for (std::size_t i = 0; i < params.size(); ++i) {
        if (i) out += ", ";
        out += spellType(params[i].type) + " " + params[i].name;
    }
    return out;
}

std::string spellTypeParams(const std::vector<std::string>& tps) {
    if (tps.empty()) return "";
    std::string out = "<";
    for (std::size_t i = 0; i < tps.size(); ++i) {
        if (i) out += ", ";
        out += tps[i];
    }
    return out + ">";
}

// Members visible across a bundle boundary: public (callers) and protected (subclassers).
bool exposed(const std::string& vis) { return vis == "public" || vis == "protected"; }

// Spell a constant field initializer back to source. A static field with a literal initializer must
// carry its value across the bundle boundary, or an importer that reads `GL.X` sees an uninitialized
// global (0). Only literal forms are spelled; a non-literal initializer is dropped (value omitted).
std::string spellConstInit(const Expr* e) {
    if (e == nullptr) return "";
    if (const auto* i = dynamic_cast<const IntLiteralExpr*>(e)) return i->text;
    if (const auto* f = dynamic_cast<const FloatLiteralExpr*>(e)) return f->text;
    if (const auto* b = dynamic_cast<const BoolLiteralExpr*>(e)) return b->value ? "true" : "false";
    if (const auto* c = dynamic_cast<const CharLiteralExpr*>(e)) return "'" + c->value + "'";
    if (const auto* s = dynamic_cast<const StringLiteralExpr*>(e)) return "\"" + s->value + "\"";
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
    if (!m.visibility.empty() && !exposed(m.visibility)) return;
    std::string s = m.visibility.empty() ? "" : m.visibility + " ";
    if (m.isStatic) s += "static ";
    if (m.isAbstract) s += "abstract ";
    if (m.isOverride) s += "override ";
    if (m.isFinal) s += "final ";
    if (m.isAsync) s += "async ";
    if (m.isComptime) s += "comptime ";
    if (m.isVolatile) s += "volatile ";
    if (m.isExtern) s += "extern " + (m.externConvention.empty() ? "" : m.externConvention + " ");
    // Operators are stored as methods named "operator<sym>" (spec 6.5) / "operator cast$T" (6.6). Spell
    // them back as operator syntax: a literal "method operator+" is not valid LDP3 and would not re-parse.
    if (m.name.rfind("operator", 0) == 0) {
        const std::string rest = m.name.substr(8);  // after "operator"
        if (rest.rfind(" cast$", 0) == 0)
            s += "operator cast<" + rest.substr(6) + ">()";
        else
            s += "operator " + rest + " (" + spellParams(m.params) + ")";
        s += " returns " + spellType(m.returnType) + ";";
        e.line(s);
        return;
    }
    s += "method " + m.name + spellTypeParams(m.typeParams) + "(" + spellParams(m.params) + ")";
    s += " returns " + spellType(m.returnType);
    if (!m.throwsTypes.empty()) {
        s += " throws(";
        for (std::size_t i = 0; i < m.throwsTypes.size(); ++i) {
            if (i) s += ", ";
            s += spellType(m.throwsTypes[i]);
        }
        s += ")";
    }
    // region-binder escape summary (so imported callers can check container methods): `escapes(i:slot, ...)`
    // where slot -1 = the receiver, j = parameter j. Omitted when the method stores none of its parameters.
    if (!m.escapeSummary.empty()) {
        s += " escapes(";
        for (std::size_t i = 0; i < m.escapeSummary.size(); ++i) {
            if (i) s += ", ";
            s += std::to_string(m.escapeSummary[i].first) + ":" + std::to_string(m.escapeSummary[i].second);
        }
        s += ")";
    }
    e.line(s + ";");
}

void emitField(Emitter& e, const FieldDecl& f) {
    if (!exposed(f.visibility)) return;
    // spec 32.9: an affinity decides where the field sits in the object, so it MUST cross the bundle
    // boundary -- a consumer that laid the same class out in declaration order would disagree with the
    // bundle's own code about every offset. Each field is re-emitted in its own one-field block; the
    // grouping is by affinity, not by how many blocks it was written in, so the layout is identical.
    if (!f.affinity.empty()) {
        e.line("affinity " + f.affinity + " {");
        ++e.indent;
    }
    std::string s = f.visibility + " ";
    if (f.isStatic) s += "static ";
    if (f.isMutable) s += "mutable ";
    if (f.isPersistent) s += f.isEternal ? "eternal persistent " : "persistent ";
    if (f.isTransient) s += "transient ";
    if (f.isVolatile) s += "volatile ";
    if (f.isLazy) s += "lazy ";
    if (f.isExternal) s += "external ";
    if (f.isMovable) s += "movable ";
    if (f.isUnique) s += "unique ";
    s += spellType(f.type) + " " + f.name;
    if (f.bitWidth > 0) s += " : " + std::to_string(f.bitWidth);
    if (f.isStatic) {
        const std::string v = spellConstInit(f.init.get());  // carry a static constant's value across bundles
        if (!v.empty()) s += " = " + v;
    }
    e.line(s + ";");
    if (!f.affinity.empty()) {
        --e.indent;
        e.line("}");
    }
}

void emitClass(Emitter& e, const ClassDecl& c) {
    if (c.visibility != "public") return;
    // Skip monomorphized instances (Box$int): they are an implementation detail the consumer regenerates
    // from the generic template and its own uses, and their spelled form is not valid header syntax.
    if (c.name.find('$') != std::string::npos) return;
    std::string kind = "class";
    if (c.isInterface) kind = "interface";
    else if (c.isStruct) kind = "struct";
    else if (c.isRecord) kind = "record";
    else if (c.isUnion) kind = "union";

    std::string head = "public ";
    if (c.isAbstract && !c.isInterface) head += "abstract ";
    if (c.isFinal) head += "final ";
    if (c.isSealed) head += "sealed ";
    if (c.isMovable) head += "movable ";
    if (c.isUnique) head += "unique ";
    if (c.isPartitionable) head += "partitionable ";
    head += kind + " " + c.name + spellTypeParams(c.typeParams);
    if (!c.superclass.empty()) head += " extends " + c.superclass;
    if (!c.interfaces.empty()) {
        head += " implements ";
        for (std::size_t i = 0; i < c.interfaces.size(); ++i) {
            if (i) head += ", ";
            head += c.interfaces[i];
        }
    }
    if (!c.permits.empty()) {
        head += " permits ";
        for (std::size_t i = 0; i < c.permits.size(); ++i) {
            if (i) head += ", ";
            head += c.permits[i];
        }
    }
    e.line(head + " {");
    ++e.indent;
    for (const MemberPtr& m : c.members) {
        if (const auto* method = dynamic_cast<const MethodDecl*>(m.get())) emitMethod(e, *method);
        else if (const auto* field = dynamic_cast<const FieldDecl*>(m.get())) emitField(e, *field);
        else if (const auto* ctor = dynamic_cast<const ConstructorDecl*>(m.get())) {
            if (exposed(ctor->visibility))
                e.line(ctor->visibility + " constructor " + c.name + "(" + spellParams(ctor->params) + ");");
        } else if (const auto* lit = dynamic_cast<const LiteralDecl*>(m.get())) {
            if (exposed(lit->visibility))
                e.line(lit->visibility + " comptime literal " + lit->name + "(" +
                       spellType(lit->param.type) + " " + lit->param.name + ") returns " +
                       spellType(lit->returnType) + ";");
        } else if (const auto* cst = dynamic_cast<const ConstDecl*>(m.get())) {
            if (exposed(cst->visibility))
                e.line(cst->visibility + " const " + spellType(cst->type) + " " + cst->name + ";");
        }
    }
    --e.indent;
    e.line("}");
}

void emitEnum(Emitter& e, const EnumDecl& en) {
    if (en.visibility != "public") return;
    std::string s = "public enum " + en.name + " { ";
    for (std::size_t i = 0; i < en.constants.size(); ++i) {
        if (i) s += ", ";
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
        if (i) consts += ", ";
        consts += en.constants[i];
    }
    e.line(consts + ";");
    for (const MemberPtr& m : en.members)
        if (const auto* method = dynamic_cast<const MethodDecl*>(m.get())) emitMethod(e, *method);
    --e.indent;
    e.line("}");
}

void emitCatalog(Emitter& e, const CatalogDecl& cat) {
    if (cat.visibility != "public") return;
    e.line("public catalog " + cat.name + " {");
    ++e.indent;
    for (const std::string& v : cat.requiredValues) e.line(v + ";");
    for (const MemberPtr& m : cat.methods)
        if (const auto* method = dynamic_cast<const MethodDecl*>(m.get())) emitMethod(e, *method);
    --e.indent;
    e.line("}");
}

void emitNamespace(Emitter& e, const Namespace& ns) {
    if (ns.visibility != "public") return;
    e.line("public namespace " + ns.name + " {");
    ++e.indent;
    for (const TypeAliasDecl& a : ns.typeAliases)
        if (a.visibility == "public")
            e.line("public " + std::string(a.isNewtype ? "newtype " : "typealias ") + a.name +
                   " = " + spellType(a.target) + ";");
    for (const ClassDecl& c : ns.classes) emitClass(e, c);
    for (const EnumDecl& en : ns.enums) emitEnum(e, en);
    for (const CatalogDecl& cat : ns.catalogs) emitCatalog(e, cat);
    --e.indent;
    e.line("}");
}

}  // namespace

std::string generateLdh(const Program& program) {
    Emitter e;
    e.line("program " + program.name + ";");
    e.line("");
    for (const Bundle& b : program.bundles) {
        if (b.isPrelude || b.visibility != "public") continue;  // the .ldh describes user source only
        e.line("public bundle " + b.name + (b.isFreestanding ? " freestanding" : "") + " {");
        ++e.indent;
        for (const Namespace& ns : b.namespaces) emitNamespace(e, ns);
        --e.indent;
        e.line("}");
    }
    return e.out;
}

}  // namespace ldp3
