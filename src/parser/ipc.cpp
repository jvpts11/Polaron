#include "parser/ipc.h"

#include <cstdio>
#include <map>
#include <set>
#include <string>
#include <vector>

#include "lexer/lexer.h"
#include "parser/parser.h"

namespace ldp3 {
namespace {

using namespace ast;

// The declared type of a value crossing the wire decides how it crosses (spec 2.8 / D3): a value is
// COPIED, a pointer/reference is SHARED (the object stays home; the peer gets a proxy).
enum class Wire { Scalar, Text, Handle, Token, Unsupported };

Wire wireOf(const TypeRef& t) {
    if (t.arrayDims > 0) return Wire::Unsupported;
    // A capability token (spec 32.7) travels as the nonce its issuer minted, and is validated on
    // arrival -- that check is the whole point of the type, so it is checked before the pointer rule.
    if (t.name == "BundleAccessToken") return Wire::Token;
    if (t.isPointer || t.isRef) return Wire::Handle;
    const std::string& n = t.name;
    if (n == "int" || n == "long" || n == "short" || n == "byte" || n == "boolean" || n == "char" ||
        n == "double" || n == "float" || n == "void" || n == "uint" || n == "ulong")
        return Wire::Scalar;
    if (n == "String" || n == "string") return Wire::Text;
    return Wire::Unsupported;
}

// The IpcWriter call that puts a value of this type on the wire.
std::string putCall(const TypeRef& t, const std::string& expr, const std::string& dispatcher,
                    const std::set<std::string>& remoteClasses) {
    switch (wireOf(t)) {
        case Wire::Text:
            return "w.putString(" + expr + ");";
        case Wire::Handle:
            // A pointer to a REMOTE class is already a proxy: send the id it stands for. A pointer to
            // one of OUR classes is an object we are lending out: register it and send its id, so the
            // peer can call back into it.
            if (remoteClasses.count(t.name) > 0)
                return "w.putLong(" + expr + ".__ipcId());";
            return "w.putLong(" + dispatcher + ".lend(cast<address>(" + expr + ")));";
        case Wire::Scalar:
            if (t.name == "boolean") return "w.putBoolean(" + expr + ");";
            if (t.name == "char") return "w.putChar(" + expr + ");";
            if (t.name == "double" || t.name == "float") return "w.putDouble(cast<double>(" + expr + "));";
            if (t.name == "long" || t.name == "ulong") return "w.putLong(" + expr + ");";
            return "w.putInt(cast<int>(" + expr + "));";
        default:
            return "";
    }
}

// The IpcReader call that takes a value of this type off the wire.
std::string getCall(const TypeRef& t) {
    switch (wireOf(t)) {
        case Wire::Text:
            return "r.getString()";
        case Wire::Handle:
            return "r.getLong()";
        case Wire::Scalar:
            if (t.name == "boolean") return "r.getBoolean()";
            if (t.name == "char") return "r.getChar()";
            if (t.name == "double" || t.name == "float") return "r.getDouble()";
            if (t.name == "long" || t.name == "ulong") return "r.getLong()";
            return "r.getInt()";
        default:
            return "";
    }
}

std::string spell(const TypeRef& t) {
    std::string s = t.name;
    if (t.isPointer) s += "*";
    if (t.isRef) s += "&";
    return s;
}

// Is this the capability token the server must validate before running the method (spec 32.7)?
bool isToken(const TypeRef& t) { return t.name == "BundleAccessToken"; }

bool exported(const MethodDecl& m) {
    return m.visibility == "public" && !m.isStatic && !m.isAbstract && !m.isExtern && !m.isProperty &&
           m.name.rfind("operator", 0) != 0 && m.name.rfind("__ipc", 0) != 0;
}

void fail(const SourceLocation& loc, const std::string& msg) {
    std::fprintf(stderr, "%s:%d:%d: error: %s\n", std::string(loc.file).c_str(), loc.line, loc.col,
                 msg.c_str());
}

}  // namespace

namespace {

// The synthesized code is ordinary LDP3, so it needs the ordinary imports -- the stdlib is import-gated
// on purpose, and generated code does not get an exemption.
void addIpcImports(Bundle& b) {
    static const char* kNeeded[][3] = {
        {"System", "Collections", "HashSet"}, {"System", "Ipc", "IpcProto"},
        {"System", "Ipc", "IpcWriter"},       {"System", "Ipc", "IpcReader"},
        {"System", "Ipc", "IpcChannel"},      {"System", "Ipc", "IpcError"},
        {"System", "Ipc", "IpcServer"},       {"System", "Ipc", "BundleAccessToken"},
        {"System", "Ipc", "RemoteType"},
    };
    for (const auto& n : kNeeded) {
        bool have = false;
        for (const ImportDecl& i : b.imports)
            if (i.path.size() == 3 && i.path[2] == n[2]) have = true;
        if (have) continue;
        ImportDecl imp;
        imp.path = {n[0], n[1], n[2]};
        imp.loc = b.loc;
        b.imports.push_back(imp);
    }
}

}  // namespace

bool synthesizeIpc(ast::Program& program) {
    // --- what is remote (its code lives in another process), and what do we export?
    std::set<std::string> remoteClasses;
    for (const Bundle& b : program.bundles)
        if (b.isRemote)
            for (const Namespace& ns : b.namespaces)
                for (const ClassDecl& c : ns.classes) {
                    bool isEntry = false;
                    for (const MemberPtr& m : c.members)
                        if (const auto* meth = dynamic_cast<const MethodDecl*>(m.get()))
                            if (meth->isStatic && meth->name == "main") isEntry = true;
                    if (!isEntry) remoteClasses.insert(c.name);
                }

    bool servesIpc = false;  // does this program call Program.serve? (a cheap textual signal is enough:
                             // the pass only needs to know whether to emit a dispatcher, and a program
                             // that imports from another one needs one anyway, for its lent-out objects)
    for (const Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported || b.isRemote) continue;
        for (const ImportDecl& i : b.imports)
            if (!i.programName.empty()) servesIpc = true;
    }
    for (const ImportDecl& i : program.imports)
        if (!i.programName.empty()) servesIpc = true;
    if (program.usesIpcServe) servesIpc = true;
    if (remoteClasses.empty() && !servesIpc) return true;  // this program has nothing to do with IPC

    // --- the classes THIS program can be asked about: its own public ones.
    struct Exported {
        const ClassDecl* cls;
        std::string ns;
    };
    std::vector<Exported> exports;
    std::string hostNs;  // where the dispatcher goes: the namespace of the first exported class
    for (const Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported || b.isRemote) continue;
        for (const Namespace& ns : b.namespaces)
            for (const ClassDecl& c : ns.classes) {
                if (c.visibility != "public" || c.isInterface || c.isAbstract) continue;
                if (c.name.rfind("IpcDispatch", 0) == 0) continue;
                exports.push_back({&c, ns.name});
                if (hostNs.empty()) hostNs = ns.name;
            }
    }
    if (hostNs.empty()) return true;  // nothing to dispatch to
    const std::string disp = "IpcDispatch";

    // --- 1. the proxies: every remote class becomes a { connection, id } pair whose methods are RPCs.
    for (Bundle& b : program.bundles) {
        if (!b.isRemote) continue;
        b.isImported = false;  // its bodies are ours now (synthesized), so it compiles like any bundle
        addIpcImports(b);
        for (Namespace& ns : b.namespaces) {
            std::vector<ClassDecl> kept;
            for (ClassDecl& c : ns.classes) {
                // The other program's ENTRY class is in its header like any public class, but it is not
                // something to call remotely -- and a proxy for it would collide with our own Main.
                bool isEntry = false;
                for (const MemberPtr& m : c.members)
                    if (const auto* meth = dynamic_cast<const MethodDecl*>(m.get()))
                        if (meth->isStatic && meth->name == "main") isEntry = true;
                if (isEntry) continue;
                std::string src;
                src += "public class " + c.name + " {\n";
                src += "    private mutable long __conn;\n";
                src += "    private mutable long __id;\n";
                // A concrete mention of RemoteType<C>, so the generic is instantiated: the fluent path
                // `handle.type<C>()` reaches it only through a generic METHOD, which is expanded after
                // the classes are generated, so nothing would otherwise ask for RemoteType<C> to exist.
                src += "    private static method __ipcSeed(long conn) returns RemoteType<" + c.name +
                       "> {\n";
                src += "        return new RemoteType<" + c.name + ">(conn) on heap;\n";
                src += "    }\n";
                // ONE constructor, because LDP3 has no overloading: id 0 means "create the object in the
                // other program"; any other id binds this proxy to an object that program already owns
                // (one it handed back as a T*).
                src += "    public constructor " + c.name + "(long conn, long id) {\n";
                src += "        this.__conn = conn;\n";
                src += "        if (id != cast<long>(0)) {\n";
                src += "            this.__id = id;\n";
                src += "            return;\n";
                src += "        }\n";
                src += "        IpcWriter w = new IpcWriter() on heap;\n";
                src += "        w.putByte(IpcProto.kCreate());\n";
                src += "        w.putString(\"" + c.name + "\");\n";
                src += "        IpcChannel ch = new IpcChannel(conn) on heap;\n";
                src += "        IpcReader r = ch.request(w.toFrame());\n";
                src += "        this.__id = r.getLong();\n";
                src += "        delete r;\n";
                src += "        delete ch;\n";
                src += "        delete w;\n";
                src += "    }\n";
                src += "    public method __ipcId() returns long {\n        return this.__id;\n    }\n";
                src += "    public method __ipcConn() returns long {\n        return this.__conn;\n    }\n";
                // Give the remote object back. The id is a capability, and a capability that is never
                // returned is just a permanent address -- so a proxy that is done with its object says
                // so, and the far side revokes the id. Explicit rather than implicit in the destructor:
                // the release is a round trip over a connection that may already be gone, and a
                // destructor is the one place where a throw has nowhere to go.
                src += "    public method release() throws(IpcError) returns void {\n";
                src += "        if (this.__id == cast<long>(0)) { return; }\n";
                src += "        IpcWriter w = new IpcWriter() on heap;\n";
                src += "        w.putByte(IpcProto.kRelease());\n";
                src += "        w.putLong(this.__id);\n";
                src += "        IpcChannel ch = new IpcChannel(this.__conn) on heap;\n";
                src += "        IpcReader r = ch.request(w.toFrame());\n";
                src += "        delete r;\n";
                src += "        delete ch;\n";
                src += "        delete w;\n";
                src += "        this.__id = cast<long>(0);\n";   // a released proxy names nothing
                src += "        return;\n";
                src += "    }\n";
                for (const MemberPtr& m : c.members) {
                    const auto* meth = dynamic_cast<const MethodDecl*>(m.get());
                    if (meth == nullptr || !exported(*meth)) continue;
                    if (wireOf(meth->returnType) == Wire::Unsupported) {
                        fail(meth->loc, "'" + c.name + "." + meth->name + "' cannot cross a program " +
                                            "boundary: its return type '" + spell(meth->returnType) +
                                            "' is not serializable (spec 2.8)");
                        return false;
                    }
                    std::string sig = "    public method " + meth->name + "(";
                    for (std::size_t i = 0; i < meth->params.size(); ++i) {
                        if (wireOf(meth->params[i].type) == Wire::Unsupported) {
                            fail(meth->loc, "parameter '" + meth->params[i].name + "' of '" + c.name +
                                                "." + meth->name + "' cannot cross a program boundary: '" +
                                                spell(meth->params[i].type) + "' is not serializable " +
                                                "(spec 2.8)");
                            return false;
                        }
                        if (i > 0) sig += ", ";
                        sig += spell(meth->params[i].type) + " " + meth->params[i].name;
                    }
                    sig += ") throws(IpcError) returns " + spell(meth->returnType) + " {\n";
                    src += sig;
                    src += "        IpcWriter w = new IpcWriter() on heap;\n";
                    src += "        w.putByte(IpcProto.kCall());\n";
                    src += "        w.putLong(this.__id);\n";
                    src += "        w.putString(\"" + c.name + "\");\n";
                    src += "        w.putString(\"" + meth->name + "\");\n";
                    for (const Param& p : meth->params) {
                        if (isToken(p.type))
                            src += "        w.putLong(" + p.name + ".nonce());\n";
                        else
                            src += "        " + putCall(p.type, p.name, disp, remoteClasses) + "\n";
                    }
                    src += "        IpcChannel ch = new IpcChannel(this.__conn) on heap;\n";
                    src += "        IpcReader r = ch.request(w.toFrame());\n";
                    const TypeRef& rt = meth->returnType;
                    if (rt.name == "void") {
                        src += "        delete r;\n        delete ch;\n        delete w;\n";
                        src += "        return;\n";
                    } else if (wireOf(rt) == Wire::Handle) {
                        src += "        long id = r.getLong();\n";
                        src += "        delete r;\n        delete ch;\n        delete w;\n";
                        src += "        return new " + rt.name + "(this.__conn, id) on heap;\n";
                    } else {
                        src += "        " + spell(rt) + " out = " + getCall(rt) + ";\n";
                        src += "        delete r;\n        delete ch;\n        delete w;\n";
                        src += "        return out;\n";
                    }
                    src += "    }\n";
                }
                src += "}\n";

                Lexer lex(src, "<ipc-proxy>");
                Parser parser(lex.tokenize(), "<ipc-proxy>");
                ClassDecl proxy = parser.parseClassForSynthesis();
                if (parser.hasErrors()) {
                    fail(c.loc, "internal error: the generated IPC proxy for '" + c.name +
                                    "' failed to parse");
                    return false;
                }
                proxy.loc = c.loc;
                c.members = std::move(proxy.members);
                c.superclass.clear();
                c.interfaces.clear();
                c.interfaceTypeArgs.clear();
                c.isSealed = false;
                c.permits.clear();
                kept.push_back(std::move(c));
            }
            ns.classes = std::move(kept);
        }
    }

    // --- 2. the dispatcher: this program answering for its own objects.
    std::string d;
    // `internal`: the dispatcher is this program's own plumbing. Public would put it in the program's
    // .ldh, and a client compiling against that header would synthesize a proxy named IpcDispatch --
    // colliding with its own dispatcher.
    d += "internal class " + disp + " {\n";
    d += "    private static mutable HashSet<long> live;\n";
    d += "    private static mutable boolean ready;\n";
    d += "    private static method ensure() returns void {\n";
    d += "        if (!" + disp + ".ready) {\n";
    d += "            " + disp + ".live = new HashSet<long>() on heap;\n";
    d += "            " + disp + ".ready = true;\n";
    d += "        }\n";
    d += "        return;\n";
    d += "    }\n";
    // An id is the object's own address -- but a peer's number is never trusted: only ids this program
    // handed out are accepted, so a forged pointer cannot be dereferenced.
    d += "    public static method lend(address obj) returns long {\n";
    d += "        " + disp + ".ensure();\n";
    d += "        long id = cast<long>(obj);\n";
    d += "        " + disp + ".live.add(id);\n";
    d += "        return id;\n";
    d += "    }\n";
    d += "    private static method known(long id) returns boolean {\n";
    d += "        " + disp + ".ensure();\n";
    d += "        return " + disp + ".live.contains(id);\n";
    d += "    }\n";
    // REVOCATION. Without it an id was added by `lend` and never removed, so a peer that kept an old
    // number still passed `known(id)` after the object was gone -- a use-after-free reachable from
    // network input, in the one feature whose whole argument is capability tokens. Dropping the id is
    // what makes the number a capability rather than a permanent address.
    d += "    public static method revoke(long id) returns boolean {\n";
    d += "        " + disp + ".ensure();\n";
    d += "        if (!" + disp + ".live.contains(id)) { return false; }\n";
    d += "        " + disp + ".live.remove(id);\n";
    d += "        return true;\n";
    d += "    }\n";
    d += "    public static method handle(String frame) returns String {\n";
    d += "        IpcReader r = new IpcReader(frame) on heap;\n";
    d += "        int kind = r.getByte();\n";
    d += "        if (kind == IpcProto.kCreate()) {\n";
    d += "            String type = r.getString();\n";
    d += "            delete r;\n";
    for (const Exported& e : exports) {
        bool hasNoArgCtor = false;
        bool anyCtor = false;
        for (const MemberPtr& m : e.cls->members)
            if (const auto* ct = dynamic_cast<const ConstructorDecl*>(m.get())) {
                anyCtor = true;
                if (ct->params.empty()) hasNoArgCtor = true;
            }
        if (!anyCtor) hasNoArgCtor = true;  // the synthesized default constructor
        if (!hasNoArgCtor) continue;        // instantiate() takes no arguments (spec 2.8)
        d += "            if (type.equals(\"" + e.cls->name + "\")) {\n";
        d += "                " + e.cls->name + "* o = new " + e.cls->name + "() on heap;\n";
        d += "                IpcWriter w = new IpcWriter() on heap;\n";
        d += "                w.putByte(IpcProto.kReplyOk());\n";
        d += "                w.putLong(" + disp + ".lend(cast<address>(o)));\n";
        d += "                String f = w.toFrame();\n";
        d += "                delete w;\n";
        d += "                return f;\n";
        d += "            }\n";
    }
    d += "            return IpcProto.errorFrame(\"no such type: \" + type);\n";
    d += "        }\n";
    // `kRelease` was defined in the protocol from the start and never handled, so nothing could ever
    // give an object back. Revoking FIRST and deleting second is the order that cannot be raced: an id
    // that is no longer in `live` is already unreachable through `known`, whatever arrives next.
    d += "        if (kind == IpcProto.kRelease()) {\n";
    d += "            long id = r.getLong();\n";
    d += "            delete r;\n";
    d += "            if (!" + disp + ".revoke(id)) {\n";
    d += "                return IpcProto.errorFrame(\"unknown object\");\n";
    d += "            }\n";
    d += "            return IpcProto.okFrame();\n";
    d += "        }\n";
    d += "        if (kind == IpcProto.kCall()) {\n";
    d += "            long id = r.getLong();\n";
    d += "            String type = r.getString();\n";
    d += "            String meth = r.getString();\n";
    d += "            if (!" + disp + ".known(id)) {\n";
    d += "                delete r;\n";
    d += "                return IpcProto.errorFrame(\"unknown object\");\n";
    d += "            }\n";
    for (const Exported& e : exports) {
        const std::string cn = e.cls->name;
        bool any = false;
        std::string body;
        for (const MemberPtr& m : e.cls->members) {
            const auto* meth = dynamic_cast<const MethodDecl*>(m.get());
            if (meth == nullptr || !exported(*meth)) continue;
            bool ok = wireOf(meth->returnType) != Wire::Unsupported;
            for (const Param& p : meth->params) {
                if (wireOf(p.type) == Wire::Unsupported) ok = false;
                // A parameter that is a pointer to a REMOTE class would ask this program to hold a proxy
                // into a third one; that is a later slice, so the method is simply not exposed rather
                // than half-worked.
                if (wireOf(p.type) == Wire::Handle && remoteClasses.count(p.type.name) > 0) ok = false;
            }
            if (!ok) continue;  // not callable across a boundary; simply not exposed
            any = true;
            body += "                if (meth.equals(\"" + meth->name + "\")) {\n";
            // decode the arguments in declared order, then run the method
            for (const Param& p : meth->params) {
                if (isToken(p.type)) {
                    body += "                    long __tok_" + p.name + " = r.getLong();\n";
                    body += "                    if (!IpcServer.validate(__tok_" + p.name + ", \"" +
                            p.name + "\")) {\n";
                    body += "                        delete r;\n";
                    body += "                        return IpcProto.errorFrame(\"capability required\");\n";
                    body += "                    }\n";
                    body += "                    BundleAccessToken " + p.name +
                            " = new BundleAccessToken(__tok_" + p.name + ", \"" + p.name +
                            "\") on heap;\n";
                } else if (wireOf(p.type) == Wire::Handle) {
                    // A T* argument: the peer sent the id of an object WE handed out, so it is one of
                    // our own addresses -- checked, never trusted -- and the callee sees the very same
                    // object, which is exactly what writing T* instead of T asked for.
                    body += "                    long __h_" + p.name + " = r.getLong();\n";
                    body += "                    if (!" + disp + ".known(__h_" + p.name + ")) {\n";
                    body += "                        delete r;\n";
                    body += "                        return IpcProto.errorFrame(\"unknown object\");\n";
                    body += "                    }\n";
                    body += "                    " + p.type.name + "* " + p.name + " = cast<" +
                            p.type.name + "*>(cast<address>(__h_" + p.name + "));\n";
                } else {
                    body += "                    " + spell(p.type) + " " + p.name + " = " +
                            getCall(p.type) + ";\n";
                }
            }
            body += "                    " + cn + "* self = cast<" + cn +
                    "*>(cast<address>(id));\n";
            const std::string args = [&] {
                std::string a;
                for (std::size_t i = 0; i < meth->params.size(); ++i) {
                    if (i > 0) a += ", ";
                    a += meth->params[i].name;
                }
                return a;
            }();
            body += "                    delete r;\n";
            body += "                    IpcWriter w = new IpcWriter() on heap;\n";
            body += "                    w.putByte(IpcProto.kReplyOk());\n";
            if (meth->returnType.name == "void") {
                body += "                    self." + meth->name + "(" + args + ");\n";
            } else if (wireOf(meth->returnType) == Wire::Handle) {
                body += "                    " + spell(meth->returnType) + " out = self." + meth->name +
                        "(" + args + ");\n";
                body += "                    w.putLong(" + disp + ".lend(cast<address>(out)));\n";
            } else {
                body += "                    " + spell(meth->returnType) + " out = self." + meth->name +
                        "(" + args + ");\n";
                body += "                    " + putCall(meth->returnType, "out", disp, remoteClasses) +
                        "\n";
            }
            body += "                    String f = w.toFrame();\n";
            body += "                    delete w;\n";
            body += "                    return f;\n";
            body += "                }\n";
        }
        if (!any) continue;
        d += "            if (type.equals(\"" + cn + "\")) {\n";
        d += body;
        d += "            }\n";
    }
    d += "            delete r;\n";
    d += "            return IpcProto.errorFrame(\"no such method\");\n";
    d += "        }\n";
    d += "        delete r;\n";
    d += "        return IpcProto.errorFrame(\"bad frame\");\n";
    d += "    }\n";
    d += "}\n";

    Lexer dlex(d, "<ipc-dispatch>");
    Parser dparser(dlex.tokenize(), "<ipc-dispatch>");
    ClassDecl dcls = dparser.parseClassForSynthesis();
    if (dparser.hasErrors()) {
        std::fprintf(stderr, "internal error: the generated IPC dispatcher failed to parse\n");
        return false;
    }

    for (Bundle& b : program.bundles) {
        if (b.isPrelude || b.isImported || b.isRemote) continue;
        bool placed = false;
        for (Namespace& ns : b.namespaces) {
            if (ns.name != hostNs) continue;
            dcls.loc = ns.loc;
            ns.classes.push_back(std::move(dcls));
            placed = true;
            break;
        }
        if (placed) {
            addIpcImports(b);
            break;
        }
    }

    // --- 3. the seam: IpcRuntime.handle (in the prelude) now answers through this program's dispatcher.
    //
    // The namespace is matched by SUFFIX, not equality. This pass runs BEFORE qualifyNamespaces, so the
    // prelude's namespace is still written as it is declared -- `Ipc`, nested in bundle `System` -- while
    // this looked for the qualified `System.Ipc` and therefore never matched. The seam was silently never
    // installed, so every server answered every request with the prelude's default
    // "this program exports nothing over IPC", and the client raised an uncaught IpcError and died with
    // its stdout still buffered. That is the whole of the IPC hang.
    bool seamInstalled = false;
    auto isIpcNamespace = [](const std::string& n) {
        return n == "Ipc" || n == "System.Ipc" || (n.size() > 4 && n.compare(n.size() - 4, 4, ".Ipc") == 0);
    };
    for (Bundle& b : program.bundles) {
        if (!b.isPrelude) continue;
        for (Namespace& ns : b.namespaces) {
            if (!isIpcNamespace(ns.name)) continue;
            for (ClassDecl& c : ns.classes) {
                if (c.name != "IpcRuntime") continue;
                for (MemberPtr& m : c.members) {
                    auto* meth = dynamic_cast<MethodDecl*>(m.get());
                    if (meth == nullptr || meth->name != "handle") continue;
                    const std::string body = "public class Seam {\n    public static method handle(String frame) "
                                             "returns String {\n        return " +
                                             disp + ".handle(frame);\n    }\n}\n";
                    Lexer slex(body, "<ipc-seam>");
                    Parser sparser(slex.tokenize(), "<ipc-seam>");
                    ClassDecl seam = sparser.parseClassForSynthesis();
                    if (sparser.hasErrors()) return false;
                    for (MemberPtr& sm : seam.members) {
                        auto* smeth = dynamic_cast<MethodDecl*>(sm.get());
                        if (smeth != nullptr && smeth->name == "handle") {
                            meth->body = std::move(smeth->body);
                            seamInstalled = true;
                        }
                    }
                }
            }
        }
    }
    // A dispatcher nothing routes to is a program that silently refuses every request -- the failure this
    // pass just spent its work preventing. If the seam could not be installed, say so loudly here rather
    // than let it surface as a peer that answers "this program exports nothing" for reasons no one can see.
    if (!seamInstalled) {
        fail(program.loc,
             "internal error: the IPC dispatcher was synthesized but IpcRuntime.handle could not be "
             "rewritten to call it, so this program would refuse every request it serves");
        return false;
    }
    return true;
}

}  // namespace ldp3
