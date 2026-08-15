#include "codegen/codegen_impl.h"

namespace polaron {

std::string CodeGenerator::Impl::typeName(const ast::Expr& expr) {
    if (const auto* n = dynamic_cast<const ast::IntLiteralExpr*>(&expr)) {
        const std::int64_t v = parseIntLiteral(n->text);
        if (ast::intLiteralNeeds64(n->text)) {
            return "long";
        }
        return (v >= INT32_MIN && v <= INT32_MAX) ? "int" : "long";
    }
    if (dynamic_cast<const ast::NullLiteralExpr*>(&expr) != nullptr) {
        return "null";
    }
    if (const auto* lam = dynamic_cast<const ast::LambdaExpr*>(&expr)) {
        std::string s = "function<" + typeRefName(lam->returnType);
        for (const auto& p : lam->params) {
            s += "," + typeRefName(p.type);
        }
        return s + ">";
    }
    if (const auto* mr = dynamic_cast<const ast::MethodRefExpr*>(&expr)) {
        const std::string st = baseType(typeName(*mr->object));
        const ast::MethodDecl* md = findMethodDecl(st, mr->method);
        if (md == nullptr) {
            return "function<void>";
        }
        std::string s = "function<" + typeRefName(md->returnType);
        for (const auto& p : md->params) {
            s += "," + typeRefName(p.type);
        }
        return s + ">";
    }
    if (const auto* old = dynamic_cast<const ast::OldExpr*>(&expr)) {
        return typeName(*old->inner);  // old(e) has e's type (spec 29)
    }
    if (const auto* tup = dynamic_cast<const ast::TupleExpr*>(&expr)) {
        std::string s = "(";
        for (std::size_t i = 0; i < tup->elements.size(); ++i) {
            s += (i ? "," : "") + typeName(*tup->elements[i]);
        }
        return s + ")";
    }
    if (const auto* fl = dynamic_cast<const ast::FloatLiteralExpr*>(&expr)) {
        return fl->isDecimal ? "Decimal" : "double";
    }
    if (dynamic_cast<const ast::CharLiteralExpr*>(&expr) != nullptr) {
        return "char";
    }
    if (const auto* sl = dynamic_cast<const ast::StringLiteralExpr*>(&expr)) {
        return sl->isBytes ? "byte*" : "string";   // b"..." is the raw bytes
    }
    if (dynamic_cast<const ast::InterpStringExpr*>(&expr) != nullptr) {
        return "String";  // $"..."
    }
    if (dynamic_cast<const ast::BoolLiteralExpr*>(&expr) != nullptr) {
        return "boolean";
    }
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(&expr)) {
        if (id->name == "this") {
            return currentClass;
        }
        auto it = locals.find(id->name);
        if (it != locals.end()) {
            return it->second.type;
        }
        if (auto cit = namespaceConstTypes.find(id->name); cit != namespaceConstTypes.end()) {
            return cit->second;
        }
        return "int";
    }
    if (const auto* un = dynamic_cast<const ast::UnaryExpr*>(&expr)) {
        const std::string ot = typeName(*un->operand);  // ONCE -- see the BinaryExpr note below
        if (un->op == "&") {
            return ot + "*";  // address-of: one level deeper
        }
        if (un->op == "*") {  // dereference: peel one '*' off the operand's pointer type
            if (!ot.empty() && ot.back() == '*') {
                return ot.substr(0, ot.size() - 1);
            }
            return ot;
        }
        // Unary operator overload (spec 6.5): the operator method's return type.
        if (un->op != "!") {
            const std::string owner = methodOwner(baseType(ot), "operator" + un->op);
            if (!owner.empty()) {
                if (auto rit = classes.find(owner);
                    rit != classes.end() && rit->second.methodReturnType.count("operator" + un->op) > 0) {
                    return rit->second.methodReturnType.at("operator" + un->op);
                }
            }
        }
        // Negation and bitwise-not keep the operand's numeric type (int/long/float/double); without
        // this, unary '-' was typed as int, so `-x` on a double misled callers (e.g. a ternary arm's
        // result type), producing a double value under an i32 phi -- an IR type mismatch.
        if (un->op == "~" || un->op == "-" || un->op == "+") {
            return ot;
        }
        return un->op == "!" ? "boolean" : "int";
    }
    if (const auto* aw = dynamic_cast<const ast::AwaitExpr*>(&expr)) {
        const std::string t = baseType(typeName(*aw->operand));  // Task$X -> X
        return t.rfind("Task$", 0) == 0 ? t.substr(5) : t;
    }
    if (const auto* ue = dynamic_cast<const ast::UnimportExpr*>(&expr)) {
        // spec 30.18: the validation value's type is what the expecting block returns.
        if (ue->expecting != nullptr) {
            for (const auto& s : ue->expecting->statements) {
                if (const auto* rs = dynamic_cast<const ast::ReturnStmt*>(s.get());
                    rs != nullptr && rs->value != nullptr) {
                    return typeName(*rs->value);
                }
            }
        }
        return "int";
    }
    if (const auto* me = dynamic_cast<const ast::MatchExpr*>(&expr)) {
        // Value type is the arms' common type, computed by sema (bindings in scope).
        if (!me->resultType.empty()) {
            return me->resultType;
        }
        if (!me->cases.empty() && me->cases[0].result) {
            return typeName(*me->cases[0].result);
        }
        if (me->defaultResult) {
            return typeName(*me->defaultResult);
        }
        return "int";
    }
    if (const auto* tern = dynamic_cast<const ast::TernaryExpr*>(&expr)) {
        return ternaryType(*tern);
    }
    if (const auto* nc = dynamic_cast<const ast::NullCoalesceExpr*>(&expr)) {  // a ?? b
        auto nullable = [](const std::string& s) { return ast::typeIsNullable(s); };
        const std::string lt = typeName(*nc->lhs);
        const std::string base = nullable(lt) ? ast::stripNullable(lt) : lt;
        return nullable(typeName(*nc->rhs)) ? ast::makeNullable(base) : base;
    }
    if (const auto* bin = dynamic_cast<const ast::BinaryExpr*>(&expr)) {
        const std::string& op = bin->op;
        // Compute the left operand's type ONCE and reuse it. Recomputing typeName(lhs) for both the
        // operator-overload probe below and the arithmetic path further down makes a left-nested
        // chain cost O(2^depth) type queries: for `a op b` we would descend the left subtree twice,
        // and each level does the same, doubling per node. A synthesized structural hash
        // (`((17*31+f1)*31+f2)*31+...`, two arithmetic nodes per field) is exactly that shape, so a
        // struct with a dozen-plus fields hangs codegen. One descent keeps this linear.
        //
        // Found twice independently, which is worth recording: once here, and once against the pico
        // kernel, where a single 13-field struct (PageFlags) accounted for 181 of the build's 193
        // seconds. Same line, same cause. See the CallExpr arm below for the worse sibling.
        const std::string lt = typeName(*bin->lhs);
        // Operator overloading: result type is the operator method's return type.
        const std::string oowner = methodOwner(baseType(lt), "operator" + op);
        if (!oowner.empty()) {
            return classes[oowner].methodReturnType["operator" + op];
        }
        if (op == "==" || op == "!=" || op == "<" || op == ">" || op == "<=" || op == ">=" ||
            op == "&&" || op == "||") {
            return "boolean";
        }
        const std::string rt = typeName(*bin->rhs);
        if (op == "+" && (lt == "String" || lt == "string") && (rt == "String" || rt == "string")) {
            return "String";  // string concatenation (spec 4)
        }
        if (lt == "Decimal" && rt == "Decimal" && (op == "+" || op == "-" || op == "*" || op == "/")) {
            return "Decimal";  // fixed-point arithmetic (spec 34)
        }
        if (int vw = std::max(vecWidth(lt), vecWidth(rt)); vw > 0) {
            return "vec" + std::to_string(vw);
        }
        if (isFloatType(lt) || isFloatType(rt)) {  // f32 only if both are f32
            const bool f64 = (isFloatType(lt) && !isF32(lt)) || (isFloatType(rt) && !isF32(rt));
            return f64 ? "double" : "float";
        }
        // Arithmetic result: the wider operand's width; unsigned is contagious.
        const unsigned w = std::max(intBits(lt), intBits(rt));
        const bool u = isUnsigned(lt) || isUnsigned(rt);
        if (w == 8) {
            return u ? "uint8" : "int8";
        }
        if (w == 16) {
            return u ? "uint16" : "int16";
        }
        if (w == 64) {
            return u ? "ulong" : "long";
        }
        return u ? "uint32" : "int";
    }
    if (const auto* nw = dynamic_cast<const ast::NewExpr*>(&expr)) {
        return ast::mangleGeneric(nw->className, nw->typeArgs);
    }
    if (dynamic_cast<const ast::RangeExpr*>(&expr)) {
        return "Range";  // first-class range value
    }
    if (const auto* na = dynamic_cast<const ast::NewArrayExpr*>(&expr)) {
        return na->elementType + "[]";
    }
    if (const auto* al = dynamic_cast<const ast::ArrayLiteralExpr*>(&expr)) {  // [a,b,c] (spec 25)
        return (al->elements.empty() ? std::string("int") : typeName(*al->elements[0])) + "[]";
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(&expr)) {
        const std::string at = typeName(*ix->array);
        if (vecWidth(at) > 0 || at == "mat4") {
            return "float";  // v[i] / m[i] element read
        }
        const std::string owner = methodOwner(baseType(at), "operator[]");
        if (!owner.empty()) {
            return classes[owner].methodReturnType["operator[]"];
        }
        if (isRefType(at)) {
            return baseType(at);  // p[i] on a raw pointer T* -> T
        }
        return isArrayType(at) ? at.substr(0, at.size() - 2) : std::string("int");
    }
    if (const auto* call = dynamic_cast<const ast::CallExpr*>(&expr)) {
        // CALLING A FUNCTION VALUE HAS THE FUNCTION'S RETURN TYPE, and this arm had no rule for it at
        // all -- so `f(x)` where `f` is a `function<double, double>` fell through every case below to
        // the default, and was typed as an integer.
        //
        // The consequence was invisible until two such calls met in one expression: `f(a) - f(b)`
        // emitted an INTEGER subtraction over two doubles, sign-extending each to i32 and converting
        // the result back. One call per statement was fine, because nothing then had to agree with it
        // about a type -- which is why this survived every use of a lambda the library already had
        // (`ArrayList.map`, `filter`, `sortedBy` all take a value and hand it straight back) and
        // surfaced only on a numerical derivative.
        //
        // The analyzer was right all along; this is codegen's own second opinion, and the two have to
        // agree because the analyzer decides whether the program is legal and codegen decides what it
        // means.
        if (const auto* cid = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get())) {
            if (auto lit = locals.find(cid->name);
                lit != locals.end() && lit->second.type.rfind("function<", 0) == 0) {
                const std::string inner =
                    lit->second.type.substr(9, lit->second.type.size() - 10);
                std::vector<std::string> parts = splitTypeList(inner);
                if (!parts.empty()) {
                    return parts[0];                     // function<Ret, Params...>
                }
            }
        }
        // The same for a function held in a FIELD -- `this.compare(a, b)` where `compare` is a
        // `function<int, T, T>` -- which reaches here as a member callee rather than an identifier.
        if (const auto* cmem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            const std::string mt = typeName(*cmem);
            if (mt.rfind("function<", 0) == 0) {
                std::vector<std::string> parts = splitTypeList(mt.substr(9, mt.size() - 10));
                if (!parts.empty()) {
                    return parts[0];
                }
            }
        }
        if (int w = vecWidth(flattenCallee(*call->callee)); w > 0) {
            return flattenCallee(*call->callee);  // vec2/3/4 construction
        }
        if (const std::string mc = flattenCallee(*call->callee); mc == "mat4" || mc == "mat4.identity") {
            return "mat4";  // mat4(...16 floats) construction and the mat4.identity() factory
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get());
            mem != nullptr && typeName(*mem->object) == "mat4") {
            if (mem->member == "multiply") {
                return "mat4";
            }
            if (mem->member == "transform") {
                return "vec4";
            }
        }
        if (flattenCallee(*call->callee) == "reflect.typeOf") {
            return "Type";  // spec 31
        }
        if (flattenCallee(*call->callee) == "System.IO.Console.read") {
            return "String";  // reads a line
        }
        if (const std::string rc = flattenCallee(*call->callee);
            rc == "Raw.readString" || rc == "System.Memory.Raw.readString") {
            return "String";  // StringBuilder
        }
        if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Time.", 0) == 0) {
            if (fc == "Time.millis" || fc == "Time.nanos" || fc == "Time.unixMillis") {
                return "long";  // spec 34
            }
            if (fc == "Time.sleep") {
                return "void";
            }
        }
        if (const std::string fc = flattenCallee(*call->callee); fc == "Bits.doubleToLong") {
            return "long";
        }
        if (const std::string fc = flattenCallee(*call->callee); fc == "Bits.longToDouble") {
            return "double";
        }
        if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Ipc.", 0) == 0) {
            if (fc == "Ipc.recv") {
                return "String";  // spec 2.8: one whole frame
            }
            if (fc == "Ipc.close") {
                return "void";
            }
            return "long";  // listen/accept/connect -> handle; send -> bytes written
        }
        if (const std::string fc = flattenCallee(*call->callee); fc.rfind("Net.", 0) == 0) {
            if (fc == "Net.recv" || fc == "Net.udpRecv" || fc == "Net.udpPeerHost") {
                return "String";  // spec 34
            }
            if (fc == "Net.connect" || fc == "Net.send" || fc == "Net.listen" || fc == "Net.accept" ||
                fc == "Net.udpOpen" || fc == "Net.udpSend") {
                return "long";
            }
            if (fc == "Net.udpPeerPort") {
                return "int";
            }
            if (fc == "Net.close" || fc == "Net.udpClose") {
                return "void";
            }
        }
        if (flattenCallee(*call->callee) == "Process.run") {
            return "ProcessResult";  // spec 34
        }
        if (const std::string ec = flattenCallee(*call->callee); ec.rfind("Env.", 0) == 0) {
            if (ec == "Env.get") {
                return "String";  // spec 34
            }
            if (ec == "Env.set") {
                return "boolean";
            }
            if (ec == "Env.executablePath") {
                return "String";
            }
        }
        if (const std::string sc = flattenCallee(*call->callee); sc.rfind("Subproc.", 0) == 0) {
            if (sc == "Subproc.spawn" || sc == "Subproc.spawnCombined" || sc == "Subproc.spawnVisible") {
                return "long";
            }
            if (sc == "Subproc.writeStr") {
                return "int";
            }
            if (sc == "Subproc.readChunk") {
                return "String";
            }
            if (sc == "Subproc.isAlive" || sc == "Subproc.canRead") {
                return "boolean";
            }
            if (sc == "Subproc.closeStdin" || sc == "Subproc.kill") {
                return "void";
            }
        }
        if (const std::string pc = flattenCallee(*call->callee); pc.rfind("Conpty.", 0) == 0) {
            if (pc == "Conpty.spawn") {
                return "long";
            }
            if (pc == "Conpty.writeStr") {
                return "int";
            }
            if (pc == "Conpty.readChunk") {
                return "String";
            }
            if (pc == "Conpty.isAlive" || pc == "Conpty.canRead") {
                return "boolean";
            }
            if (pc == "Conpty.resize" || pc == "Conpty.close") {
                return "void";
            }
        }
        if (const std::string fc = flattenCallee(*call->callee); fc.rfind("File.", 0) == 0) {
            if (fc == "File.readAll" || fc == "File.list") {
                return "String";  // spec 34.4
            }
            if (fc == "File.size") {
                return "long";
            }
            if (fc == "File.writeAll" || fc == "File.appendAll" || fc == "File.exists" ||
                fc == "File.remove" || fc == "File.mkdir" || fc == "File.rename" || fc == "File.isDir") {
                return "boolean";
            }
        }
        if (const std::string mc = flattenCallee(*call->callee); mc.rfind("Math.", 0) == 0) {
            const std::string fn = mc.substr(5);  // only the builtin Math.* (spec 34.6) -> double
            if (fn == "sqrt" || fn == "abs" || fn == "floor" || fn == "ceil" || fn == "round" ||
                fn == "trunc" || fn == "sin" || fn == "cos" || fn == "exp" || fn == "log" ||
                fn == "pow" || fn == "min" || fn == "max" || fn == "tan" || fn == "asin" ||
                fn == "acos" || fn == "atan" || fn == "sinh" || fn == "cosh" || fn == "tanh" ||
                fn == "cbrt" || fn == "log2" || fn == "log10" || fn == "atan2" || fn == "hypot" ||
                fn == "clamp" || fn == "lerp") {
                return "double";
            }
        }
        if (auto er = externReturnType.find(flattenCallee(*call->callee)); er != externReturnType.end()) {
            return er->second;  // external C function (spec 26)
        }
        if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(call->callee.get())) {
            // The receiver's type, computed ONCE. The builtin tables below ask about it nine times;
            // recursing nine times per level made this 9^depth on a method chain `a.f().g().h()`.
            const std::string ot = typeName(*mem->object);
            if (mem->member == "length" && isArrayType(ot)) {
                return "int";
            }
            if (ot == "String" || ot == "string") {
                if (mem->member == "length" || mem->member == "indexOf") {
                    return "int";
                }
                if (mem->member == "charAt") {
                    return "char";
                }
                if (mem->member == "isEmpty" || mem->member == "equals" || mem->member == "contains" ||
                    mem->member == "startsWith" || mem->member == "endsWith") {
                    return "boolean";
                }
                if (mem->member == "concat" || mem->member == "substring" || mem->member == "toUpper" ||
                    mem->member == "toLower" || mem->member == "trim" || mem->member == "repeat" ||
                    mem->member == "toString") {
                    return "String";
                }
                if (mem->member == "hash") {
                    return "long";
                }
                if (mem->member == "equalsKey") {
                    return "boolean";
                }
                if (mem->member == "compareTo") {
                    return "int";
                }
                if (mem->member == "toInt") {
                    return "int";
                }
                if (mem->member == "toDouble") {
                    return "double";
                }
            }
            if (ot == "Decimal" && mem->member == "toString") {
                return "String";
            }
            if (isFloatType(ot) && mem->member == "toString") {
                return "String";
            }
            if (ot == "boolean" && mem->member == "toString") {
                return "String";
            }
            // Integer keys: Hashable/Comparable builtins (collections) + toString (itoa).
            if (isIntName(ot)) {
                if (mem->member == "hash") {
                    return "long";
                }
                if (mem->member == "equalsKey") {
                    return "boolean";
                }
                if (mem->member == "compareTo") {
                    return "int";
                }
                if (mem->member == "toString") {
                    return "String";
                }
            }
            if (ot == "Type") {
                if (mem->member == "name" || mem->member == "methodName" || mem->member == "fieldName") {
                    return "String";
                }
                if (mem->member == "methodCount" || mem->member == "fieldCount") {
                    return "int";
                }
                if (mem->member == "method") {
                    return "Method";
                }
                if (mem->member == "instantiate") {
                    return "Object";
                }
                if (mem->member == "methods") {
                    return "ArrayList$Method";
                }
                if (mem->member == "fields") {
                    return "ArrayList$Field";
                }
                if (mem->member == "annotations") {
                    return "ArrayList$Annotation";
                }
            }
            if (ot == "Field") {
                if (mem->member == "name") {
                    return "String";
                }
                if (mem->member == "get") {
                    return "Object";  // boxed field value (spec 31)
                }
            }
            if (ot == "Annotation" && mem->member == "name") {
                return "String";
            }
            if (ot == "Method") {
                if (mem->member == "name") {
                    return "String";
                }
                if (mem->member == "invoke") {
                    return "Object";  // boxed result (spec 31)
                }
                if (mem->member == "firstByte") {
                    return "int";
                }
                if (mem->member == "annotations") {
                    return "ArrayList$Annotation";
                }
            }
            if (const auto* oid = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
                if (enums.count(oid->name) > 0) {
                    if (mem->member == "count") {
                        return "int";
                    }
                    if (mem->member == "values") {
                        return oid->name + "[]";
                    }
                    if (mem->member == "random") {
                        return oid->name;
                    }
                    if (mem->member == "parse") {
                        return "Option$" + oid->name;
                    }
                }
            }
            // Enum value built-in (spec 12.5): v.name() is a String, unless the enum
            // declares its own `name` (resolved through the paths below).
            if (enums.count(baseType(ot)) > 0 && mem->member == "name" &&
                functions.count(baseType(ot) + ".name") == 0) {
                return "String";
            }
            // Enum (catalog) instance method: m.pick() -> the method's return type. A
            // catalog-typed receiver resolves to its single implementing enum (spec 12.4).
            std::string enumRecv = baseType(ot);
            if (enumMethodDecls.find(enumRecv) == enumMethodDecls.end()) {
                if (std::string impl = catalogImplementerEnum(enumRecv, mem->member); !impl.empty()) {
                    enumRecv = impl;
                }
            }
            if (auto eit = enumMethodDecls.find(enumRecv); eit != enumMethodDecls.end()) {
                for (const ast::MemberPtr& member : eit->second->members) {
                    const auto* m = dynamic_cast<const ast::MethodDecl*>(member.get());
                    if (m != nullptr && m->name == mem->member) {
                        return typeRefName(m->returnType);
                    }
                }
            }
            // A java-style implementer's methods live on its desugared twin class.
            if (javaEnums.count(enumRecv) > 0 && classes.count(enumRecv) > 0) {
                auto& mrt = classes[enumRecv].methodReturnType;
                if (auto rit = mrt.find(mem->member); rit != mrt.end()) {
                    return rit->second;
                }
            }
            // instance: search the object's hierarchy; static: the named class.
            std::string owner = methodOwner(ot, mem->member);
            if (owner.empty() && classes.count(flattenCallee(*mem->object)) > 0) {
                owner = methodOwner(flattenCallee(*mem->object), mem->member);
            }
            if (!owner.empty()) {
                const std::string rt = classes[owner].methodReturnType[mem->member];
                // An async method call yields a Task<returnType> (spec 20.2).
                const ast::MethodDecl* md = findMethodDecl(owner, mem->member);
                if (md != nullptr && md->isAsync) {
                    return ast::mangleGeneric("Task", {rt});
                }
                return rt;
            }
            // Qualified literal suffix: Type.kib(64) (spec 17.10).
            if (literalSuffixParams.count(mem->member) > 0 && call->args.size() == 1) {
                const std::string key = chooseLiteralKey(mem->member, typeName(*call->args[0]));
                if (auto rit = literalReturnType.find(key); rit != literalReturnType.end()) {
                    return rit->second;
                }
            }
        }
        // Namespace-level literal suffix function: name(arg), overloaded by argument type.
        const std::string sname = flattenCallee(*call->callee);
        if (literalSuffixParams.count(sname) > 0 && call->args.size() == 1) {
            const std::string key = chooseLiteralKey(sname, typeName(*call->args[0]));
            if (auto rit = literalReturnType.find(key); rit != literalReturnType.end()) {
                return rit->second;
            }
        }
        // A CALL TO THE ENCLOSING TYPE'S OWN METHOD, with no receiver written. Every branch
        // above needs a receiver to read the return type off, so `own()` reached the fallback
        // and was typed `int` -- which nothing noticed while the answer was only being called,
        // and surfaced the moment somebody read a member off it: `own().field` looked the field
        // up on an `int` and reported "no such field", pointing at the field rather than at the
        // call whose type was invented.
        if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get());
            id != nullptr && !currentClass.empty()) {
            if (const std::string owner = methodOwner(currentClass, id->name); !owner.empty()) {
                const std::string rt = classes[owner].methodReturnType[id->name];
                const ast::MethodDecl* md = findMethodDecl(owner, id->name);
                if (md != nullptr && md->isAsync) {
                    return ast::mangleGeneric("Task", {rt});
                }
                if (!rt.empty()) {
                    return rt;
                }
            }
        }
        return "int";
    }
    if (dynamic_cast<const ast::RegionInitExpr*>(&expr) != nullptr) {
        return "region";
    }
    // spec 32.2: a snapshot handle is an address -- see the note in ast.h's canonicalType.
    if (dynamic_cast<const ast::SnapshotExpr*>(&expr) != nullptr) {
        return "address";
    }
    if (const auto* mem = dynamic_cast<const ast::MemberExpr*>(&expr)) {
        const std::string objT = typeName(*mem->object);  // ONCE -- see the BinaryExpr note
        if (vecWidth(objT) > 0 && vecLane(mem->member) >= 0) {
            return "float";  // v.x / v.y / v.z / v.w
        }
        // `obj.interrupt` is the installable handle: an address, deliberately not a callable.
        if (mem->member == "interrupt" && declaresInterrupt(baseType(objT))) {
            return "address";
        }
        if (const std::string key = staticFieldKey(*mem); !key.empty()) {
            return staticFieldType[key];
        }
        if (const auto* objId = dynamic_cast<const ast::IdentifierExpr*>(mem->object.get())) {
            // EnumName.CONSTANT -> the enum type, and ONLY when it names a constant. An enum may
            // also carry a `static fixed` of its own, and calling that the enum's type made
            // `n >= Pace.BRISK` compare an int against a singleton -- an ICmp of two different
            // types, which LLVM refuses and which the same read in a plain initializer never
            // produced, because that path asked the class first.
            if (locals.find(objId->name) == locals.end()) {
                if (auto eit = enums.find(objId->name);
                    eit != enums.end() &&
                    std::find(eit->second.begin(), eit->second.end(), mem->member) !=
                        eit->second.end()) {
                    return objId->name;
                }
            }
            if (auto ct = namespaceConstTypes.find(objId->name + "." + mem->member);
                ct != namespaceConstTypes.end()) {
                return ct->second;  // Type.NAME class const
            }
        }
        const std::string ot = clsKey(objT);
        auto cit = classes.find(ot);
        if (cit != classes.end()) {
            auto ft = cit->second.fieldType.find(mem->member);
            if (ft != cit->second.fieldType.end()) {
                return ft->second;
            }
        }
        // Computed get-only property read as obj.name -> the getter's return type.
        if (const ast::MethodDecl* pm = findMethodDecl(ot, mem->member);
            pm != nullptr && pm->isProperty) {
            const std::string owner = methodOwner(ot, mem->member);
            if (!owner.empty()) {
                return classes[owner].methodReturnType[mem->member];
            }
        }
        return "int";
    }
    if (const auto* cst = dynamic_cast<const ast::CastExpr*>(&expr)) {
        return cst->op == 1 ? std::string("boolean")
               : cst->op == 2 ? ast::makeNullable(cst->targetType)
                              : cst->targetType;
    }
    if (const auto* mv = dynamic_cast<const ast::MoveExpr*>(&expr)) {
        return mv->castType.empty() ? typeName(*mv->operand) : mv->castType;
    }
    if (const auto* ex = dynamic_cast<const ast::ExtractExpr*>(&expr)) {
        return typeName(*ex->target);  // extract yields an owning pointer to the same object type
    }
    if (dynamic_cast<const ast::MarkExpr*>(&expr) != nullptr) {
        return "checkpoint";  // spec 17 stack flavor: a cursor value
    }
    if (const auto* tx = dynamic_cast<const ast::TryExpr*>(&expr)) {
        const std::string ot = baseType(typeName(*tx->operand));  // Result$T$E / Option$T
        const auto p = ot.find('$');
        if (p == std::string::npos) {
            return "int";
        }
        const std::string rest = ot.substr(p + 1);
        const auto q = rest.find('$');
        return q == std::string::npos ? rest : rest.substr(0, q);  // T (the value type)
    }
    return "int";
}

}  // namespace polaron
