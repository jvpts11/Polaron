#include "parser/parser.h"

#include <cstdlib>
#include <utility>

#include "lexer/lexer.h"

namespace ldp3 {

namespace {

// AST builders used to synthesize a record's primary constructor and equals().
std::unique_ptr<ast::IdentifierExpr> makeIdent(const std::string& name, SourceLocation loc) {
    auto e = std::make_unique<ast::IdentifierExpr>();
    e->loc = loc;
    e->name = name;
    return e;
}
std::unique_ptr<ast::MemberExpr> makeMember(ast::ExprPtr obj, const std::string& member,
                                            SourceLocation loc) {
    auto e = std::make_unique<ast::MemberExpr>();
    e->loc = loc;
    e->member = member;
    e->object = std::move(obj);
    return e;
}

// Builds `public method equals(Name other) returns boolean { return this.f0 ==
// other.f0 && ...; }` for a record's fields (spec 10: auto-generated equals).
ast::MemberPtr buildRecordEquals(const std::string& typeName,
                                 const std::vector<ast::Param>& fields, SourceLocation loc) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = loc;
    m->visibility = "public";
    m->name = "equals";
    ast::Param p;
    p.loc = loc;
    p.type.name = typeName;
    p.name = "other";
    m->params.push_back(p);
    m->returnType.name = "boolean";

    ast::ExprPtr expr;
    for (const ast::Param& f : fields) {
        auto cmp = std::make_unique<ast::BinaryExpr>();
        cmp->loc = loc;
        cmp->op = "==";
        cmp->lhs = makeMember(makeIdent("this", loc), f.name, loc);
        cmp->rhs = makeMember(makeIdent("other", loc), f.name, loc);
        if (!expr) {
            expr = std::move(cmp);
        } else {
            auto conj = std::make_unique<ast::BinaryExpr>();
            conj->loc = loc;
            conj->op = "&&";
            conj->lhs = std::move(expr);
            conj->rhs = std::move(cmp);
            expr = std::move(conj);
        }
    }
    if (!expr) {
        auto b = std::make_unique<ast::BoolLiteralExpr>();
        b->loc = loc;
        b->value = true;
        expr = std::move(b);
    }
    auto ret = std::make_unique<ast::ReturnStmt>();
    ret->loc = loc;
    ret->value = std::move(expr);
    m->body.statements.push_back(std::move(ret));
    return m;
}

bool isTypeKeyword(TokenKind k) {
    switch (k) {
        case TokenKind::KwVoid:
        case TokenKind::KwBoolean:
        case TokenKind::KwChar:
        case TokenKind::KwString:
        case TokenKind::KwStringClass:
        case TokenKind::KwInt:
        case TokenKind::KwInt8:
        case TokenKind::KwInt16:
        case TokenKind::KwInt32:
        case TokenKind::KwInt64:
        case TokenKind::KwUint8:
        case TokenKind::KwUint16:
        case TokenKind::KwUint32:
        case TokenKind::KwUint64:
        case TokenKind::KwShort:
        case TokenKind::KwLong:
        case TokenKind::KwByte:
        case TokenKind::KwFloat:
        case TokenKind::KwDouble:
        case TokenKind::KwFloat32:
        case TokenKind::KwFloat64:
        case TokenKind::KwRegion:
            return true;
        default:
            return false;
    }
}

// Binary operator precedence (higher binds tighter); 0 means "not a binary op".
int binaryPrec(TokenKind k) {
    switch (k) {
        case TokenKind::PipePipe:
            return 1;
        case TokenKind::AmpAmp:
            return 2;
        case TokenKind::Pipe:  // bitwise or
            return 3;
        case TokenKind::Caret:  // bitwise xor
            return 4;
        case TokenKind::Amp:  // bitwise and
            return 5;
        case TokenKind::EqEq:
        case TokenKind::BangEq:
            return 6;
        case TokenKind::Lt:
        case TokenKind::Gt:
        case TokenKind::LtEq:
        case TokenKind::GtEq:
            return 7;
        case TokenKind::Shl:
        case TokenKind::Shr:
            return 8;
        case TokenKind::Plus:
        case TokenKind::Minus:
            return 9;
        case TokenKind::Star:
        case TokenKind::Slash:
        case TokenKind::Percent:
            return 10;
        default:
            return 0;
    }
}

}  // namespace

Parser::Parser(std::vector<Token> tokens, std::string_view file)
    : tokens_(std::move(tokens)), file_(file) {}

const Token& Parser::peek(int ahead) const {
    std::size_t i = pos_ + static_cast<std::size_t>(ahead);
    if (i >= tokens_.size()) return tokens_.back();  // EndOfFile sentinel
    return tokens_[i];
}

const Token& Parser::current() const { return peek(0); }

bool Parser::check(TokenKind kind) const { return current().kind == kind; }

const Token& Parser::advance() {
    const Token& t = tokens_[pos_];
    if (pos_ + 1 < tokens_.size()) ++pos_;
    return t;
}

bool Parser::match(TokenKind kind) {
    if (check(kind)) {
        advance();
        return true;
    }
    return false;
}

const Token& Parser::expect(TokenKind kind, const char* what) {
    if (check(kind)) return advance();
    fail(std::string("expected ") + what + " but found '" + current().lexeme + "'",
         current().loc);
}

void Parser::fail(const std::string& message, SourceLocation loc) {
    errors_.push_back(ParseError{message, loc});
    throw ParseError{message, loc};
}

std::string Parser::parseVisibilityOpt() {
    switch (current().kind) {
        case TokenKind::KwPublic:    advance(); return "public";
        case TokenKind::KwPrivate:   advance(); return "private";
        case TokenKind::KwProtected: advance(); return "protected";
        case TokenKind::KwInternal:  advance(); return "internal";
        default:                     return "";
    }
}

std::string Parser::parseDottedName() {
    std::string name = expect(TokenKind::Identifier, "a name").lexeme;
    while (match(TokenKind::Dot)) {
        name += ".";
        name += expect(TokenKind::Identifier, "a name after '.'").lexeme;
    }
    return name;
}

ast::Program Parser::parse() {
    ast::Program program;
    try {
        program.loc = current().loc;
        expect(TokenKind::KwProgram, "'program'");
        program.name = expect(TokenKind::Identifier, "the program name").lexeme;
        expect(TokenKind::Semicolon, "';'");
        while (!check(TokenKind::EndOfFile)) {
            program.bundles.push_back(parseBundle());
        }
    } catch (const ParseError&) {
        // Already recorded; stop here (panic mode for the walking skeleton).
    }
    program.hasQualifiedTypeRef = sawQualifiedType_;
    return program;
}

ast::Bundle Parser::parseBundle() {
    ast::Bundle b;
    b.loc = current().loc;
    b.visibility = parseVisibilityOpt();
    expect(TokenKind::KwBundle, "'bundle'");
    b.name = expect(TokenKind::Identifier, "the bundle name").lexeme;
    expect(TokenKind::LBrace, "'{'");
    // Imports come first: `import a.b.c;` (spec 2.7). The `bundle`/`from program`
    // forms are later phases.
    while (check(TokenKind::KwImport)) {
        ast::ImportDecl imp;
        imp.loc = current().loc;
        advance();  // 'import'
        imp.path.push_back(expect(TokenKind::Identifier, "an import path").lexeme);
        while (match(TokenKind::Dot)) {
            imp.path.push_back(expect(TokenKind::Identifier, "a name after '.'").lexeme);
        }
        expect(TokenKind::Semicolon, "';'");
        b.imports.push_back(std::move(imp));
    }
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        b.namespaces.push_back(parseNamespace());
    }
    expect(TokenKind::RBrace, "'}'");
    return b;
}

ast::Namespace Parser::parseNamespace() {
    ast::Namespace ns;
    ns.loc = current().loc;
    ns.visibility = parseVisibilityOpt();
    expect(TokenKind::KwNamespace, "'namespace'");
    ns.name = parseDottedName();
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        // Peek past an optional visibility modifier to tell enums from classes.
        TokenKind kind = current().kind;
        if (kind == TokenKind::KwPublic || kind == TokenKind::KwPrivate ||
            kind == TokenKind::KwProtected || kind == TokenKind::KwInternal) {
            kind = peek(1).kind;
        }
        if (kind == TokenKind::KwEnum) {
            ast::EnumDecl en = parseEnum();
            if (en.isJavaStyle) {
                // Desugar: a class carries the fields/constructor/methods (reusing
                // the whole class pipeline); a light enum keeps the constants and
                // their constructor args so `Type.CONST` can materialize them.
                ast::ClassDecl cls;
                cls.loc = en.loc;
                cls.visibility = en.visibility;
                cls.name = en.name;
                cls.members = std::move(en.members);
                ns.classes.push_back(std::move(cls));
                ast::EnumDecl light;
                light.loc = en.loc;
                light.visibility = en.visibility;
                light.name = en.name;
                light.constants = std::move(en.constants);
                light.constantArgs = std::move(en.constantArgs);
                light.isJavaStyle = true;
                ns.enums.push_back(std::move(light));
            } else {
                ns.enums.push_back(std::move(en));
            }
        } else if (kind == TokenKind::KwCatalog) {
            ns.catalogs.push_back(parseCatalog());
        } else if (kind == TokenKind::KwComptime || kind == TokenKind::KwLiteral) {
            ns.literals.push_back(parseLiteral());
        } else if (kind == TokenKind::KwConst) {
            ns.consts.push_back(parseConstDecl());
        } else if (kind == TokenKind::KwRecord) {
            ns.classes.push_back(parseRecord());
        } else {
            ns.classes.push_back(parseClassOrInterface());
        }
    }
    expect(TokenKind::RBrace, "'}'");
    return ns;
}

ast::LiteralDecl Parser::parseLiteral() {
    ast::LiteralDecl l;
    l.loc = current().loc;
    l.visibility = parseVisibilityOpt();
    if (match(TokenKind::KwComptime)) l.isComptime = true;
    expect(TokenKind::KwLiteral, "'literal'");
    l.name = expect(TokenKind::Identifier, "the literal suffix name").lexeme;
    expect(TokenKind::LParen, "'('");
    std::vector<ast::Param> params = parseParams();
    expect(TokenKind::RParen, "')'");
    if (params.size() != 1) {
        fail("a literal suffix must take exactly one parameter", l.loc);
    }
    l.param = std::move(params[0]);
    expect(TokenKind::KwReturns, "'returns'");
    l.returnType = parseTypeRef();
    l.body = parseBlock();
    return l;
}

// `[visibility] const T NAME = expr;` -- a namespace-level compile-time constant
// (spec 28.1). The initializer is a constant expression validated by the analyzer.
ast::ConstDecl Parser::parseConstDecl() {
    ast::ConstDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    expect(TokenKind::KwConst, "'const'");
    c.type = parseTypeRef();
    c.name = expect(TokenKind::Identifier, "the constant name").lexeme;
    expect(TokenKind::Assign, "'='");
    c.init = parseExpression();
    expect(TokenKind::Semicolon, "';'");
    return c;
}

ast::EnumDecl Parser::parseEnum() {
    ast::EnumDecl e;
    e.loc = current().loc;
    e.visibility = parseVisibilityOpt();
    expect(TokenKind::KwEnum, "'enum'");
    e.name = expect(TokenKind::Identifier, "the enum name").lexeme;
    // Catalogs implemented by this enum (spec 12.4): `enum Motor extends TipoMotor`.
    if (match(TokenKind::KwExtends)) {
        do {
            e.extendsCatalogs.push_back(expect(TokenKind::Identifier, "a catalog name").lexeme);
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::LBrace, "'{'");
    // Constants: NAME [ (ctor args) ], comma-separated. Args make it Java-style.
    if (check(TokenKind::Identifier)) {
        do {
            e.constants.push_back(expect(TokenKind::Identifier, "an enum constant").lexeme);
            std::vector<ast::ExprPtr> args;
            if (match(TokenKind::LParen)) {
                e.isJavaStyle = true;
                if (!check(TokenKind::RParen)) {
                    do {
                        args.push_back(parseExpression());
                    } while (match(TokenKind::Comma));
                }
                expect(TokenKind::RParen, "')'");
            }
            e.constantArgs.push_back(std::move(args));
        } while (match(TokenKind::Comma));
    }
    // `byCatalog { ... }` block (spec 12.4): constants provided to satisfy a catalog.
    // They become real enum constants (appended after the own ones, so ordinals
    // continue), and are recorded as catalog-provided for clarity/validation.
    if (match(TokenKind::KwByCatalog)) {
        expect(TokenKind::LBrace, "'{' to open byCatalog");
        if (check(TokenKind::Identifier)) {
            do {
                const std::string v = expect(TokenKind::Identifier, "a catalog value").lexeme;
                e.byCatalogValues.push_back(v);
                e.constants.push_back(v);
                e.constantArgs.push_back({});  // keep parallel to `constants`
            } while (match(TokenKind::Comma));
        }
        expect(TokenKind::RBrace, "'}' to close byCatalog");
    }
    // Java-style body: `;` then fields / constructor / methods (spec 12.2).
    if (match(TokenKind::Semicolon)) {
        e.isJavaStyle = true;
        while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
            e.members.push_back(parseMember(/*inInterface=*/false));
        }
    } else if (!e.extendsCatalogs.empty()) {
        // Catalog-implementing enum: its methods follow the constants/byCatalog block
        // directly (no leading `;`). Kept on the enum (NOT desugared to a class) so
        // its constants stay plain i32 ordinals with correct value semantics.
        while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
            e.members.push_back(parseMember(/*inInterface=*/false));
        }
    }
    expect(TokenKind::RBrace, "'}'");
    // A catalog-implementing enum stays a plain ordinal enum (its constants are
    // i32 ordinals with value semantics); it cannot also be java-style (per-constant
    // constructor args or a `;` body), whose constants are heap objects.
    if (!e.extendsCatalogs.empty() && e.isJavaStyle) {
        fail("a catalog-implementing enum cannot use java-style constructor-argument "
             "constants (it must be a plain ordinal enum)",
             e.loc);
    }
    return e;
}

// A catalog (spec 12.3): an interface for enums declaring required VALUES and
// required METHOD SIGNATURES (standard form `method name(params) returns T;`).
ast::CatalogDecl Parser::parseCatalog() {
    ast::CatalogDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    expect(TokenKind::KwCatalog, "'catalog'");
    c.name = expect(TokenKind::Identifier, "the catalog name").lexeme;
    // A catalog may extend other catalogs (spec 12.3): `catalog A extends B, C`.
    if (match(TokenKind::KwExtends)) {
        do {
            c.extendsCatalogs.push_back(expect(TokenKind::Identifier, "a catalog name").lexeme);
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::LBrace, "'{'");
    // Required values: comma-separated bare identifiers (catalogs have no fields).
    if (check(TokenKind::Identifier)) {
        do {
            c.requiredValues.push_back(expect(TokenKind::Identifier, "a catalog value").lexeme);
        } while (match(TokenKind::Comma));
    }
    // Required method signatures (abstract): parsed like interface methods.
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        c.methods.push_back(parseMember(/*inInterface=*/true));
    }
    expect(TokenKind::RBrace, "'}'");
    return c;
}

ast::ClassDecl Parser::parseClassOrInterface() {
    ast::ClassDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    if (match(TokenKind::KwSealed)) c.isSealed = true;
    if (match(TokenKind::KwFinal)) c.isFinal = true;
    if (match(TokenKind::KwAbstract)) c.isAbstract = true;
    if (match(TokenKind::KwMovable)) {
        c.isMovable = true;
    } else if (match(TokenKind::KwUnique)) {
        c.isUnique = true;
    }
    if (match(TokenKind::KwPartitionable)) c.isPartitionable = true;  // spec 19.9
    if (match(TokenKind::KwInterface)) {
        c.isInterface = true;
        c.isAbstract = true;  // interfaces are abstract by nature
    } else if (match(TokenKind::KwStruct)) {
        c.isStruct = true;  // value type, no inheritance
    } else if (match(TokenKind::KwUnion)) {
        c.isUnion = true;   // value type whose fields overlap one storage
        c.isStruct = true;
    } else {
        expect(TokenKind::KwClass, "'class', 'struct', 'union' or 'interface'");
    }
    c.name = expect(TokenKind::Identifier, "the type name").lexeme;
    // Generic parameters: class Box<T>, class Pair<K, V>.
    if (match(TokenKind::Lt)) {
        do {
            // Variance marker (spec 15.3): <out T> covariant, <in T> contravariant,
            // <T> invariant. Only consume out/in when a parameter name follows, so a
            // parameter literally named "out" still works.
            std::string variance;
            if (check(TokenKind::KwIn) && peek(1).kind == TokenKind::Identifier) {
                advance();
                variance = "in";
            } else if (check(TokenKind::Identifier) && current().lexeme == "out" &&
                       peek(1).kind == TokenKind::Identifier) {
                advance();
                variance = "out";
            }
            const std::string tp = expect(TokenKind::Identifier, "a type parameter").lexeme;
            c.typeParams.push_back(tp);
            c.typeParamVariance.push_back(variance);
            // Constraint (spec 15.2): `<T extends Base>` or `<T implements Iface>`.
            if (match(TokenKind::KwExtends) || match(TokenKind::KwImplements)) {
                c.typeParamBounds.push_back(
                    {tp, expect(TokenKind::Identifier, "a constraint type").lexeme});
                // A generic bound like Comparable<T> is accepted; its arguments are skipped for now.
                if (match(TokenKind::Lt)) {
                    int depth = 1;
                    while (depth > 0 && !check(TokenKind::EndOfFile)) {
                        if (match(TokenKind::Lt)) ++depth;
                        else if (match(TokenKind::Gt)) --depth;
                        else advance();
                    }
                }
            }
        } while (match(TokenKind::Comma));
        expect(TokenKind::Gt, "'>' to close type parameters");
    }
    if (match(TokenKind::KwExtends)) {
        if (c.isStruct) fail("a struct cannot extend another type (structs have no inheritance)",
                             c.loc);
        c.superclass = expect(TokenKind::Identifier, "a superclass name").lexeme;
        if (match(TokenKind::Lt)) {  // generic base: extends Base<T>
            do {
                c.superclassTypeArgs.push_back(
                    expect(TokenKind::Identifier, "a type argument").lexeme);
            } while (match(TokenKind::Comma));
            expect(TokenKind::Gt, "'>' to close type arguments");
        }
    }
    if (match(TokenKind::KwImplements)) {
        do {
            c.interfaces.push_back(expect(TokenKind::Identifier, "an interface name").lexeme);
            std::vector<std::string> args;  // generic interface args: implements Producer<Dog>
            if (match(TokenKind::Lt)) {
                do {
                    args.push_back(expect(TokenKind::Identifier, "a type argument").lexeme);
                } while (match(TokenKind::Comma));
                expect(TokenKind::Gt, "'>' to close type arguments");
            }
            c.interfaceTypeArgs.push_back(std::move(args));
        } while (match(TokenKind::Comma));
    }
    // `sealed ... permits A, B, C`: only the listed types may extend it (spec 12/16).
    if (match(TokenKind::KwPermits)) {
        do {
            c.permits.push_back(expect(TokenKind::Identifier, "a permitted subtype").lexeme);
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        // Class invariant (spec 29): `invariant <expr>;` -- a class-level contract.
        if (match(TokenKind::KwInvariant)) {
            c.invariants.push_back(parseExpression());
            expect(TokenKind::Semicolon, "';'");
            continue;
        }
        // Lifecycle hooks (spec 32.5): `onClassLoad`/`onFirstInstance`/... -- soft keywords.
        if (check(TokenKind::Identifier) && current().lexeme == "onClassLoad") {
            advance();
            c.onClassLoad = std::make_unique<ast::Block>(parseBlock());
            continue;
        }
        if (check(TokenKind::Identifier) && current().lexeme == "onFirstInstance") {
            advance();
            c.onFirstInstance = std::make_unique<ast::Block>(parseBlock());
            continue;
        }
        if (check(TokenKind::Identifier) && current().lexeme == "onLastInstanceDestroyed") {
            advance();
            c.onLastInstanceDestroyed = std::make_unique<ast::Block>(parseBlock());
            continue;
        }
        if (check(TokenKind::Identifier) && current().lexeme == "onClassUnload") {
            advance();
            c.onClassUnload = std::make_unique<ast::Block>(parseBlock());
            continue;
        }
        c.members.push_back(parseMember(c.isInterface));
    }
    expect(TokenKind::RBrace, "'}'");
    // Union fields are written/read freely (manual memory); make them mutable.
    if (c.isUnion) {
        for (const ast::MemberPtr& member : c.members) {
            if (auto* f = dynamic_cast<ast::FieldDecl*>(member.get())) f->isMutable = true;
        }
    }
    return c;
}

// record Name(params) [implements ...] { methods }. The params are the record's
// fields; we synthesize a field per param, a primary constructor, and equals()
// (spec 10). A record is an immutable value type, so it reuses the struct path.
ast::ClassDecl Parser::parseRecord() {
    ast::ClassDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    expect(TokenKind::KwRecord, "'record'");
    c.isRecord = true;
    c.isStruct = true;  // value type, no vtable -> reuses struct codegen
    c.name = expect(TokenKind::Identifier, "the record name").lexeme;
    expect(TokenKind::LParen, "'('");
    std::vector<ast::Param> fields = parseParams();
    expect(TokenKind::RParen, "')'");
    if (match(TokenKind::KwImplements)) {
        do {
            c.interfaces.push_back(expect(TokenKind::Identifier, "an interface name").lexeme);
        } while (match(TokenKind::Comma));
    }

    // A field per parameter (immutable).
    for (const ast::Param& f : fields) {
        auto fd = std::make_unique<ast::FieldDecl>();
        fd->loc = c.loc;
        fd->visibility = "public";
        fd->isMutable = false;
        fd->type = f.type;
        fd->name = f.name;
        c.members.push_back(std::move(fd));
    }
    // Primary constructor: this.f = f; for each field.
    {
        auto ctor = std::make_unique<ast::ConstructorDecl>();
        ctor->loc = c.loc;
        ctor->visibility = "public";
        ctor->params = fields;
        for (const ast::Param& f : fields) {
            auto assign = std::make_unique<ast::AssignStmt>();
            assign->loc = c.loc;
            assign->target = makeMember(makeIdent("this", c.loc), f.name, c.loc);
            assign->value = makeIdent(f.name, c.loc);
            ctor->body.statements.push_back(std::move(assign));
        }
        c.members.push_back(std::move(ctor));
    }
    c.members.push_back(buildRecordEquals(c.name, fields, c.loc));

    // Body: methods and constants only -- no extra fields (spec 10).
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        ast::MemberPtr m = parseMember(/*inInterface=*/false);
        if (dynamic_cast<ast::FieldDecl*>(m.get()) != nullptr) {
            fail("a record cannot declare fields beyond its primary constructor parameters", m->loc);
        }
        c.members.push_back(std::move(m));
    }
    expect(TokenKind::RBrace, "'}'");
    return c;
}

ast::MemberPtr Parser::parseMember(bool inInterface) {
    std::string visibility = parseVisibilityOpt();
    bool isStatic = false;
    bool isMutable = false;
    bool isAbstract = false;
    bool isOverride = false;
    bool isFinal = false;
    bool isPersistent = false;
    bool isEternal = false;
    bool isTransient = false;
    bool isVolatile = false;
    bool isComptime = false;
    bool isLazy = false;
    for (;;) {
        if (!isStatic && check(TokenKind::KwStatic)) {
            advance();
            isStatic = true;
            continue;
        }
        if (!isMutable && check(TokenKind::KwMutable)) {
            advance();
            isMutable = true;
            continue;
        }
        if (!isAbstract && check(TokenKind::KwAbstract)) {
            advance();
            isAbstract = true;
            continue;
        }
        if (!isOverride && check(TokenKind::KwOverride)) {
            advance();
            isOverride = true;
            continue;
        }
        if (!isFinal && check(TokenKind::KwFinal)) {
            advance();
            isFinal = true;
            continue;
        }
        if (!isPersistent && check(TokenKind::KwPersistent)) {
            advance();
            isPersistent = true;
            continue;
        }
        if (!isEternal && check(TokenKind::KwEternal)) {
            advance();
            isEternal = true;
            continue;
        }
        if (!isTransient && check(TokenKind::KwTransient)) {
            advance();
            isTransient = true;
            continue;
        }
        if (!isVolatile && check(TokenKind::KwVolatile)) {
            advance();
            isVolatile = true;
            continue;
        }
        if (!isComptime && check(TokenKind::KwComptime)) {
            advance();
            isComptime = true;
            continue;
        }
        if (!isLazy && check(TokenKind::KwLazy)) {
            advance();
            isLazy = true;
            continue;
        }
        break;
    }
    if (check(TokenKind::KwMethod)) {
        return parseMethod(std::move(visibility), isStatic, isAbstract, isOverride, isFinal,
                           inInterface, isComptime);
    }
    if (check(TokenKind::KwConstructor)) {
        return parseConstructor(std::move(visibility));
    }
    if (check(TokenKind::KwDestructor)) {
        return parseDestructor(std::move(visibility));
    }
    if (check(TokenKind::KwOperator)) {
        return parseOperator(std::move(visibility));
    }
    // Otherwise it is a field:  <type> <name> ;
    return parseField(std::move(visibility), isStatic, isMutable, isPersistent, isEternal,
                      isTransient, isVolatile, isLazy);
}

// `operator <op> (params) returns T { body }` (spec 6.5). Modeled as a method
// named "operator<op>" (e.g. "operator+"), reusing the whole method pipeline.
std::unique_ptr<ast::MethodDecl> Parser::parseOperator(std::string visibility) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    expect(TokenKind::KwOperator, "'operator'");
    const Token op = advance();  // the operator symbol token (+, -, ==, <, [, ...)
    std::string sym = op.lexeme;
    if (op.kind == TokenKind::LBracket) {  // operator [] (read) / operator []= (write)
        expect(TokenKind::RBracket, "']' to form operator[]");
        sym = match(TokenKind::Assign) ? "[]=" : "[]";
    }
    m->name = "operator" + sym;
    expect(TokenKind::LParen, "'('");
    m->params = parseParams();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::KwReturns, "'returns'");
    m->returnType = parseTypeRef();
    currentMethodReturnType_ = m->returnType;  // enables the Ok(x)/.. return-value sugar
    m->body = parseBlock();
    return m;
}

std::unique_ptr<ast::MethodDecl> Parser::parseMethod(std::string visibility, bool isStatic,
                                                     bool isAbstract, bool isOverride, bool isFinal,
                                                     bool inInterface, bool isComptime) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    m->isStatic = isStatic;
    m->isAbstract = isAbstract || inInterface;  // interface methods are abstract
    m->isOverride = isOverride;
    m->isFinal = isFinal;
    m->isComptime = isComptime;  // `comptime` prefix (spec 37.4); suffix handled below
    expect(TokenKind::KwMethod, "'method'");
    m->name = expect(TokenKind::Identifier, "the method name").lexeme;
    // Generic method type parameters: method identity<T>(...) (spec 15). Each
    // (method-name, type-args) call is monomorphized into a concrete method.
    if (match(TokenKind::Lt)) {
        do {
            m->typeParams.push_back(
                expect(TokenKind::Identifier, "a type parameter").lexeme);
        } while (match(TokenKind::Comma));
        expect(TokenKind::Gt, "'>' to close type parameters");
    }
    expect(TokenKind::LParen, "'('");
    m->params = parseParams();
    expect(TokenKind::RParen, "')'");
    // `throws(T1, T2)` clause (spec 21.1), between the signature and `returns`.
    if (match(TokenKind::KwThrows)) {
        expect(TokenKind::LParen, "'(' after 'throws'");
        do {
            m->throwsTypes.push_back(parseTypeRef());
        } while (match(TokenKind::Comma));
        expect(TokenKind::RParen, "')' to close 'throws'");
    }
    expect(TokenKind::KwReturns, "'returns'");
    m->returnType = parseTypeRef();
    if (match(TokenKind::KwComptime)) m->isComptime = true;  // suffix form (spec 28.3)
    currentMethodReturnType_ = m->returnType;  // enables the Ok(x)/.. return-value sugar
    // Contract clauses (spec 29): `requires <expr>` / `ensures <expr>`, between the
    // signature and the body, no separators. `old(...)` in ensures is not yet supported.
    while (check(TokenKind::KwRequires) || check(TokenKind::KwEnsures)) {
        const bool isReq = check(TokenKind::KwRequires);
        advance();
        (isReq ? m->requiresClauses : m->ensuresClauses).push_back(parseExpression());
    }
    if (m->isAbstract) {
        expect(TokenKind::Semicolon, "';' (an abstract method has no body)");
    } else {
        m->body = parseBlock();
    }
    return m;
}

ast::MemberPtr Parser::parseField(std::string visibility, bool isStatic, bool isMutable,
                                  bool isPersistent, bool isEternal, bool isTransient,
                                  bool isVolatile, bool isLazy) {
    const SourceLocation loc = current().loc;
    ast::TypeRef type = parseTypeRef();
    const std::string name = expect(TokenKind::Identifier, "a field name").lexeme;
    // A `{` here makes it a property (spec 8.4) rather than a plain field.
    if (check(TokenKind::LBrace)) {
        return parseProperty(std::move(visibility), isStatic, std::move(type), name, loc);
    }
    auto f = std::make_unique<ast::FieldDecl>();
    f->loc = loc;
    f->visibility = std::move(visibility);
    f->isStatic = isStatic;
    f->isMutable = isMutable;
    f->isPersistent = isPersistent;
    f->isEternal = isEternal;
    f->isTransient = isTransient;
    f->isVolatile = isVolatile;
    f->isLazy = isLazy;
    f->type = std::move(type);
    f->name = name;
    // Bit-field width: `field : N` (spec 11.1). Constrains the stored value to N bits.
    if (match(TokenKind::Colon)) {
        const Token w = expect(TokenKind::IntLiteral, "a bit-field width");
        f->bitWidth = static_cast<int>(std::strtol(w.lexeme.c_str(), nullptr, 0));
    }
    if (match(TokenKind::Assign)) {
        f->init = parseExpression();  // inline field initializer (spec 940)
    }
    expect(TokenKind::Semicolon, "';'");
    return f;
}

// Property (spec 8.4). Auto-accessors desugar to a field (set -> mutable;
// init / get-only -> immutable). A `get { body }` is a computed get-only
// property: it becomes a getter method read as `obj.name` (no parens).
// set-with-body (backing-field properties) is a later refinement.
ast::MemberPtr Parser::parseProperty(std::string visibility, bool isStatic, ast::TypeRef type,
                                     const std::string& name, SourceLocation loc) {
    expect(TokenKind::LBrace, "'{'");
    bool hasSet = false;
    bool getHasBody = false;
    ast::Block getBody;
    // get / set / init are soft keywords here (plain identifiers).
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        if (!check(TokenKind::Identifier)) {
            fail("expected 'get', 'set' or 'init' in a property", current().loc);
        }
        const std::string accessor = advance().lexeme;
        if (accessor == "get") {
            if (check(TokenKind::LBrace)) {
                getBody = parseBlock();
                getHasBody = true;
            } else {
                expect(TokenKind::Semicolon, "';' (auto-property) or a '{ ... }' get body");
            }
        } else if (accessor == "set") {
            if (check(TokenKind::LBrace)) {
                fail("set bodies are not supported yet; use an auto-property `set;`", loc);
            }
            hasSet = true;
            expect(TokenKind::Semicolon, "';'");
        } else if (accessor == "init") {
            expect(TokenKind::Semicolon, "';'");  // init-only -> immutable
        } else {
            fail("expected 'get', 'set' or 'init' in a property, found '" + accessor + "'", loc);
        }
    }
    expect(TokenKind::RBrace, "'}'");

    if (getHasBody) {  // computed get-only property -> a getter method
        auto m = std::make_unique<ast::MethodDecl>();
        m->loc = loc;
        m->visibility = std::move(visibility);
        m->isStatic = isStatic;
        m->isProperty = true;
        m->name = name;
        m->returnType = std::move(type);
        m->body = std::move(getBody);
        return m;
    }
    // Auto-property -> a field (set => mutable; init / get-only => immutable).
    auto f = std::make_unique<ast::FieldDecl>();
    f->loc = loc;
    f->visibility = std::move(visibility);
    f->isStatic = isStatic;
    f->isMutable = hasSet;
    f->type = std::move(type);
    f->name = name;
    return f;  // a property ends at '}', no trailing ';'
}

std::unique_ptr<ast::ConstructorDecl> Parser::parseConstructor(std::string visibility) {
    auto c = std::make_unique<ast::ConstructorDecl>();
    c->loc = current().loc;
    c->visibility = std::move(visibility);
    expect(TokenKind::KwConstructor, "'constructor'");
    expect(TokenKind::Identifier, "the constructor name (the class name)");
    expect(TokenKind::LParen, "'('");
    c->params = parseParams();
    expect(TokenKind::RParen, "')'");
    while (check(TokenKind::KwRequires) || check(TokenKind::KwEnsures)) {
        const bool isReq = check(TokenKind::KwRequires);
        advance();
        (isReq ? c->requiresClauses : c->ensuresClauses).push_back(parseExpression());
    }
    c->body = parseBlock();
    return c;
}

std::unique_ptr<ast::DestructorDecl> Parser::parseDestructor(std::string visibility) {
    auto d = std::make_unique<ast::DestructorDecl>();
    d->loc = current().loc;
    d->visibility = std::move(visibility);
    expect(TokenKind::KwDestructor, "'destructor'");
    expect(TokenKind::Tilde, "'~'");
    expect(TokenKind::Identifier, "the destructor name (the class name)");
    expect(TokenKind::LParen, "'('");
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::KwReturns, "'returns'");
    const ast::TypeRef ret = parseTypeRef();  // must be void
    if (ret.name != "void" || ret.isArray) {
        fail("a destructor must return void", ret.loc);
    }
    d->body = parseBlock();
    return d;
}

std::vector<ast::Param> Parser::parseParams() {
    std::vector<ast::Param> params;
    if (check(TokenKind::RParen)) return params;
    do {
        ast::Param p;
        p.loc = current().loc;
        p.type = parseTypeRef();
        p.name = expect(TokenKind::Identifier, "a parameter name").lexeme;
        params.push_back(std::move(p));
    } while (match(TokenKind::Comma));
    return params;
}

ast::TypeRef Parser::parseTypeRef() {
    ast::TypeRef t;
    const Token& tok = current();
    t.loc = tok.loc;
    // Tuple type (spec 22.5): `(T0, T1, ...)`, with optional component names
    // (e.g. `(int quotient, int remainder)`). The canonical type string is the
    // comma-joined component types in parentheses, e.g. "(int,int)". The names
    // are documentation only -- bindings come from the destructuring site.
    if (tok.kind == TokenKind::LParen) {
        advance();  // '('
        std::string canonical = "(";
        std::size_t count = 0;
        do {
            ast::TypeRef elem = parseTypeRef();
            // An optional component name follows the type.
            if (check(TokenKind::Identifier)) advance();
            canonical += (count++ ? "," : "") + ast::canonicalType(elem);
        } while (match(TokenKind::Comma));
        expect(TokenKind::RParen, "')' to close a tuple type");
        if (count < 2) fail("a tuple type needs at least two components", t.loc);
        t.name = canonical + ")";
        return t;  // tuple components carry their own markers; no outer [] / * / &
    }
    // function<Ret, Params...> -- the whole canonical string is the type name (no generic mangling).
    if (tok.kind == TokenKind::KwFunction) {
        advance();
        std::string nm = "function<";
        expect(TokenKind::Lt, "'<' after function");
        std::size_t fn = 0;
        do {
            ast::TypeRef arg = parseTypeRef();
            nm += (fn++ ? "," : "") + ast::canonicalType(arg);
        } while (match(TokenKind::Comma));
        if (current().kind == TokenKind::Shr) {
            tokens_[pos_].kind = TokenKind::Gt;  // split ">>": take one ">", leave one for the outer type
        } else {
            expect(TokenKind::Gt, "'>' to close function type");
        }
        t.name = nm + ">";
        return t;
    }
    if (isTypeKeyword(tok.kind) || tok.kind == TokenKind::Identifier) {
        t.name = tok.lexeme;
        advance();
        // Namespace-qualified type name: `app.Box` (a type declared in another
        // namespace). Resolved to the concrete type by qualifyNamespaces.
        while (tok.kind == TokenKind::Identifier && check(TokenKind::Dot) &&
               peek(1).kind == TokenKind::Identifier) {
            advance();  // '.'
            t.name += "." + expect(TokenKind::Identifier, "a type name after '.'").lexeme;
            sawQualifiedType_ = true;
        }
    } else {
        fail("expected a type but found '" + tok.lexeme + "'", tok.loc);
    }
    // Generic arguments: Box<int>, Pair<int, double>, nested like Box<List<int>>. Each arg is a
    // full type (recursive parseTypeRef); a trailing '>>' (Shr) is split into two '>'.
    if (match(TokenKind::Lt)) {
        do {
            ast::TypeRef arg = parseTypeRef();
            t.typeArgs.push_back(ast::canonicalType(arg));
        } while (match(TokenKind::Comma));
        if (current().kind == TokenKind::Shr) {
            tokens_[pos_].kind = TokenKind::Gt;  // split '>>' so the enclosing generic gets a '>'
        } else {
            expect(TokenKind::Gt, "'>' to close type arguments");
        }
    }
    if (match(TokenKind::LBracket)) {
        expect(TokenKind::RBracket, "']'");
        t.isArray = true;
    }
    // Pointer / reference: share the object instead of copying it.
    if (match(TokenKind::Star)) {
        t.isPointer = true;
    } else if (match(TokenKind::Amp)) {
        t.isRef = true;
    }
    return t;
}

ast::Block Parser::parseBlock() {
    ast::Block block;
    block.loc = current().loc;
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        block.statements.push_back(parseStatement());
    }
    expect(TokenKind::RBrace, "'}'");
    return block;
}

// Sugar for Result/Option construction (spec 21.2-3): in a return value or a typed var-decl init,
// `Ok(x)` / `Err(x)` / `Some(x)` / `None()` become `new Ok<args>(x) on heap`, taking the generic
// args from the expected type (the method return type or the declared variable type). Those args are
// syntactically present, so no inference is needed; the normal `new` lowering handles the rest.
static void rewriteVariantCtor(ast::ExprPtr& value, const ast::TypeRef& expected) {
    if (expected.typeArgs.empty()) return;
    auto* call = dynamic_cast<ast::CallExpr*>(value.get());
    if (call == nullptr) return;
    const auto* id = dynamic_cast<const ast::IdentifierExpr*>(call->callee.get());
    if (id == nullptr) return;
    const bool isResult = id->name == "Ok" || id->name == "Err";
    const bool isOption = id->name == "Some" || id->name == "None";
    if (!isResult && !isOption) return;
    // Only sugar against the matching sealed base with the right arity, so `Some(x)`
    // in a non-Option (or wrong-arity) context falls through to normal resolution
    // (a clear error) instead of fabricating a malformed Some$int$int instantiation.
    if (isResult && !(expected.name == "Result" && expected.typeArgs.size() == 2)) return;
    if (isOption && !(expected.name == "Option" && expected.typeArgs.size() == 1)) return;
    auto nw = std::make_unique<ast::NewExpr>();
    nw->loc = call->loc;
    nw->className = id->name;
    nw->typeArgs = expected.typeArgs;
    nw->args = std::move(call->args);
    nw->location = "heap";
    value = std::move(nw);
}

ast::StmtPtr Parser::parseStatement() {
    // Loop label: `name: <loop>` (spec 7.4). A bare identifier followed by ':'.
    if (check(TokenKind::Identifier) && peek(1).kind == TokenKind::Colon) {
        auto lbl = std::make_unique<ast::LabeledStmt>();
        lbl->loc = current().loc;
        lbl->label = advance().lexeme;  // the name
        advance();                      // ':'
        lbl->stmt = parseStatement();
        return lbl;
    }
    if (check(TokenKind::KwLabel)) {  // `label name;` -- a comefrom target (spec 7.10)
        auto m = std::make_unique<ast::LabelMarkStmt>();
        m->loc = current().loc;
        advance();  // 'label'
        m->name = expect(TokenKind::Identifier, "a label name").lexeme;
        expect(TokenKind::Semicolon, "';'");
        return m;
    }
    if (check(TokenKind::KwComefrom)) {  // `comefrom name;` -- jump to label name (spec 7.10)
        auto c = std::make_unique<ast::ComefromStmt>();
        c->loc = current().loc;
        advance();  // 'comefrom'
        c->name = expect(TokenKind::Identifier, "a label name after 'comefrom'").lexeme;
        expect(TokenKind::Semicolon, "';'");
        return c;
    }
    if (check(TokenKind::KwGoto)) {  // `goto name;` -- jump to a label (spec 7.9)
        auto g = std::make_unique<ast::GotoStmt>();
        g->loc = current().loc;
        advance();  // 'goto'
        g->name = expect(TokenKind::Identifier, "a label name after 'goto'").lexeme;
        expect(TokenKind::Semicolon, "';'");
        return g;
    }
    if (check(TokenKind::KwUnimport) || check(TokenKind::KwReimport)) {  // spec 30
        auto u = std::make_unique<ast::UnimportStmt>();
        u->loc = current().loc;
        u->isReimport = match(TokenKind::KwReimport);
        if (!u->isReimport) advance();  // 'unimport'
        u->target = expect(TokenKind::Identifier, "a type name to (un)import").lexeme;
        // Accept (and ignore) extra modifiers/granularity: `force`, `namespace`, dotted names.
        while (match(TokenKind::Dot)) u->target += "." + expect(TokenKind::Identifier, "a name").lexeme;
        while (check(TokenKind::Identifier)) advance();  // e.g. `force`
        expect(TokenKind::Semicolon, "';'");
        return u;
    }
    if (check(TokenKind::KwAbstainfrom) || check(TokenKind::KwReinstate)) {  // spec 7.11
        auto a = std::make_unique<ast::AbstainfromStmt>();
        a->loc = current().loc;
        a->isReinstate = match(TokenKind::KwReinstate);
        if (!a->isReinstate) advance();  // 'abstainfrom'
        a->name = expect(TokenKind::Identifier, "a label name").lexeme;
        // Accept (and ignore) a cross-method `method.label` form: take the last component.
        while (match(TokenKind::Dot)) a->name = expect(TokenKind::Identifier, "a label name").lexeme;
        expect(TokenKind::Semicolon, "';'");
        return a;
    }
    if (check(TokenKind::KwThrow)) {  // throw expr; (spec 21.1)
        auto t = std::make_unique<ast::ThrowStmt>();
        t->loc = current().loc;
        advance();  // 'throw'
        t->value = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        return t;
    }
    if (check(TokenKind::KwTry)) {  // try { } catch (T e) { } ... finally { } (spec 21.1)
        auto t = std::make_unique<ast::TryStmt>();
        t->loc = current().loc;
        advance();  // 'try'
        t->body = parseBlock();
        while (check(TokenKind::KwCatch)) {
            ast::CatchClause cc;
            cc.loc = current().loc;
            advance();  // 'catch'
            expect(TokenKind::LParen, "'(' after 'catch'");
            cc.type = parseTypeRef();
            cc.name = expect(TokenKind::Identifier, "a catch variable name").lexeme;
            expect(TokenKind::RParen, "')'");
            cc.body = parseBlock();
            t->catches.push_back(std::move(cc));
        }
        if (match(TokenKind::KwFinally)) {
            t->finallyBlock = std::make_unique<ast::Block>(parseBlock());
        }
        if (t->catches.empty() && t->finallyBlock == nullptr) {
            fail("a 'try' needs at least one 'catch' or a 'finally'", t->loc);
        }
        return t;
    }
    if (check(TokenKind::KwIf)) {
        return parseIfStatement();
    }
    // `comptime if (...)` -- the branch is selected at compile time (spec 37.4).
    if (check(TokenKind::KwComptime) && peek(1).kind == TokenKind::KwIf) {
        advance();  // consume 'comptime'
        return parseIfStatement(/*isComptime=*/true);
    }
    if (check(TokenKind::KwWhile)) {
        return parseWhileStatement();
    }
    if (check(TokenKind::KwDo)) {
        return parseDoStatement();
    }
    if (check(TokenKind::KwFor)) {
        return parseForStatement();
    }
    if (check(TokenKind::KwMatch)) {
        return parseMatch();
    }
    if (check(TokenKind::KwSwitch)) {
        return parseSwitch();
    }
    if (check(TokenKind::KwStaticAssert)) {
        auto sa = std::make_unique<ast::StaticAssertStmt>();
        sa->loc = current().loc;
        advance();  // 'static_assert'
        expect(TokenKind::LParen, "'('");
        sa->condition = parseExpression();
        expect(TokenKind::Comma, "',' (static_assert takes a message)");
        sa->message = expect(TokenKind::StringLiteral, "a message string").lexeme;
        expect(TokenKind::RParen, "')'");
        expect(TokenKind::Semicolon, "';'");
        return sa;
    }
    if (check(TokenKind::KwBreak)) {
        auto b = std::make_unique<ast::BreakStmt>();
        b->loc = current().loc;
        advance();
        if (check(TokenKind::Identifier)) b->label = advance().lexeme;  // break label;
        expect(TokenKind::Semicolon, "';'");
        return b;
    }
    if (check(TokenKind::KwContinue)) {
        auto c = std::make_unique<ast::ContinueStmt>();
        c->loc = current().loc;
        advance();
        if (check(TokenKind::Identifier)) c->label = advance().lexeme;  // continue label;
        expect(TokenKind::Semicolon, "';'");
        return c;
    }
    if (check(TokenKind::KwReturn)) {
        auto ret = std::make_unique<ast::ReturnStmt>();
        ret->loc = current().loc;
        advance();
        if (!check(TokenKind::Semicolon)) {
            ret->value = parseExpression();
            rewriteVariantCtor(ret->value, currentMethodReturnType_);
        }
        expect(TokenKind::Semicolon, "';'");
        return ret;
    }
    // `cascade move tree from region A to region B [leaving persistents];` (spec 19.8).
    if (check(TokenKind::KwCascade) && peek(1).kind == TokenKind::KwMove) {
        auto cm = std::make_unique<ast::CascadeMoveStmt>();
        cm->loc = current().loc;
        advance();  // 'cascade'
        advance();  // 'move'
        cm->target = parseExpression();
        if (!(check(TokenKind::Identifier) && current().lexeme == "from"))
            fail("expected 'from' in cascade move", current().loc);
        advance();  // 'from'
        expect(TokenKind::KwRegion, "'region' after 'from'");
        cm->fromRegion = expect(TokenKind::Identifier, "the source region name").lexeme;
        if (!(check(TokenKind::Identifier) && current().lexeme == "to"))
            fail("expected 'to' in cascade move", current().loc);
        advance();  // 'to'
        expect(TokenKind::KwRegion, "'region' after 'to'");
        cm->toRegion = expect(TokenKind::Identifier, "the destination region name").lexeme;
        if (check(TokenKind::Identifier) && current().lexeme == "leaving") {
            advance();  // 'leaving'
            if (check(TokenKind::Identifier) && current().lexeme == "persistents") advance();
            cm->leavingPersistents = true;
        }
        expect(TokenKind::Semicolon, "';'");
        return cm;
    }
    if (check(TokenKind::KwCascade) || check(TokenKind::KwDelete)) {
        auto del = std::make_unique<ast::DeleteStmt>();
        del->loc = current().loc;
        if (match(TokenKind::KwCascade)) del->isCascade = true;  // spec 37.1
        expect(TokenKind::KwDelete, "'delete' (cascade applies to delete or move)");
        del->target = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        return del;
    }
    if (check(TokenKind::KwRelease)) {
        auto rel = std::make_unique<ast::ReleaseStmt>();
        rel->loc = current().loc;
        advance();  // 'release'
        if (match(TokenKind::KwRegion)) {
            rel->region = expect(TokenKind::Identifier, "the region name").lexeme;
        } else {
            // `release persistent obj.field;` / `release eternal obj.field;` (spec 18.13/18.15).
            if (!match(TokenKind::KwPersistent)) expect(TokenKind::KwEternal, "'region', 'persistent' or 'eternal' after 'release'");
            rel->isPersistent = true;
            rel->target = parseExpression();
        }
        expect(TokenKind::Semicolon, "';'");
        return rel;
    }
    if (check(TokenKind::KwDefer)) {
        return parseDefer();
    }
    if (check(TokenKind::KwUsing)) {
        return parseUsing();
    }
    // Tuple destructuring `(int q, int r) = expr;` (spec 22.5).
    if (looksLikeTupleDestructuring()) {
        return parseTupleDecl();
    }
    // A class-typed local: `ClassName name`, `ClassName* p`, `ClassName& r`,
    // or `ClassName[] a` (the receiver of a member access starts with '.', so it
    // never matches these shapes).
    const bool classVarDecl =
        check(TokenKind::Identifier) &&
        (peek(1).kind == TokenKind::Identifier ||
         (peek(1).kind == TokenKind::Star && peek(2).kind == TokenKind::Identifier) ||
         (peek(1).kind == TokenKind::Amp && peek(2).kind == TokenKind::Identifier) ||
         (peek(1).kind == TokenKind::LBracket && peek(2).kind == TokenKind::RBracket &&
          peek(3).kind == TokenKind::Identifier));
    if (check(TokenKind::KwFinal) || check(TokenKind::KwMutable) || check(TokenKind::KwVar) ||
        check(TokenKind::KwPersistent) || check(TokenKind::KwEternal) ||
        check(TokenKind::KwVolatile) ||  // spec 37.5: volatile local
        check(TokenKind::KwLazy) ||      // spec 37.3: lazy local
        check(TokenKind::KwFunction) ||  // function<Ret, Params...> local
        isTypeKeyword(current().kind) || classVarDecl || looksLikeGenericVarDecl() ||
        looksLikeQualifiedVarDecl()) {
        return parseVarDecl();
    }
    return parseExprStatement();
}

// Distinguishes `Box<int> b` (a generic-typed declaration) from `a < b`
// (a comparison): scans the `<...>` -- which may hold only type names and
// commas -- and checks that an identifier (the variable name) follows the `>`.
bool Parser::looksLikeGenericVarDecl() const {
    if (!check(TokenKind::Identifier) || peek(1).kind != TokenKind::Lt) return false;
    int i = 2;
    int depth = 1;
    while (true) {
        const TokenKind k = peek(i).kind;
        if (k == TokenKind::EndOfFile) return false;
        if (k == TokenKind::Lt) {
            ++depth;
        } else if (k == TokenKind::Gt) {
            if (--depth == 0) break;
        } else if (k == TokenKind::Shr) {
            depth -= 2;  // '>>' closes two generic levels at once
            if (depth <= 0) break;
        } else if (k != TokenKind::Identifier && k != TokenKind::Comma && !isTypeKeyword(k)) {
            return false;  // not a pure type-argument list -> it's a comparison
        }
        ++i;
    }
    // Allow a trailing *, &, or [] before the variable name (Box<int>* p, Box<int>[] a).
    int j = i + 1;
    if (peek(j).kind == TokenKind::Star || peek(j).kind == TokenKind::Amp) {
        ++j;
    } else if (peek(j).kind == TokenKind::LBracket && peek(j + 1).kind == TokenKind::RBracket) {
        j += 2;
    }
    return peek(j).kind == TokenKind::Identifier;
}

// Distinguishes a namespace-qualified-typed declaration (`app.Box b`, `app.Box* p`)
// from an expression. Requires a dotted name (Identifier.Identifier...) then an
// optional *, &, or [] then a name. A trailing `(`, `=` etc. (a member call or
// assignment) does not match, so those stay expressions.
bool Parser::looksLikeQualifiedVarDecl() const {
    if (!check(TokenKind::Identifier) || peek(1).kind != TokenKind::Dot) return false;
    int i = 1;
    while (peek(i).kind == TokenKind::Dot && peek(i + 1).kind == TokenKind::Identifier) i += 2;
    if (peek(i).kind == TokenKind::Star || peek(i).kind == TokenKind::Amp) {
        ++i;
    } else if (peek(i).kind == TokenKind::LBracket && peek(i + 1).kind == TokenKind::RBracket) {
        i += 2;
    }
    return peek(i).kind == TokenKind::Identifier;
}

// Distinguishes a generic method call `obj.m<int>(...)` from a comparison
// `obj.m < x`. The current token is the `<`; scans the `<...>` (only type names
// and commas) and requires a `(` immediately after the closing `>`. The `(`
// rules out comparisons -- `a < b > c` has no parenthesized call after `>`.
bool Parser::looksLikeGenericCall() const {
    if (!check(TokenKind::Lt)) return false;
    int i = 1;
    int depth = 1;
    while (true) {
        const TokenKind k = peek(i).kind;
        if (k == TokenKind::EndOfFile) return false;
        if (k == TokenKind::Lt) {
            ++depth;
        } else if (k == TokenKind::Gt) {
            if (--depth == 0) break;
        } else if (k == TokenKind::Shr) {
            depth -= 2;  // '>>' closes two generic levels at once
            if (depth <= 0) break;
        } else if (k != TokenKind::Identifier && k != TokenKind::Comma && !isTypeKeyword(k)) {
            return false;  // not a pure type-argument list -> it's a comparison
        }
        ++i;
    }
    return peek(i + 1).kind == TokenKind::LParen;
}

// Distinguishes a tuple destructuring `(int q, int r) = expr;` (spec 22.5) from
// an ordinary parenthesized/tuple expression statement. Scans the parenthesized
// list and requires each component to be `type name` (two-plus components) and
// the closing `)` to be immediately followed by `=`. A tuple *expression* like
// `(a, b);` has bare identifiers (no per-component name) and no trailing `=`.
bool Parser::looksLikeTupleDestructuring() const {
    if (!check(TokenKind::LParen)) return false;
    int i = 1;
    int comps = 0;
    while (true) {
        // One component: a type, then a binding name.
        const TokenKind tk = peek(i).kind;
        if (tk != TokenKind::Identifier && !isTypeKeyword(tk)) return false;
        ++i;
        // Optional generic arguments `<...>` (only type names / commas inside).
        if (peek(i).kind == TokenKind::Lt) {
            int depth = 1;
            ++i;
            while (depth > 0) {
                const TokenKind k = peek(i).kind;
                if (k == TokenKind::EndOfFile) return false;
                if (k == TokenKind::Lt) ++depth;
                else if (k == TokenKind::Gt) --depth;
                else if (k == TokenKind::Shr) depth -= 2;  // '>>' closes two levels
                else if (k != TokenKind::Identifier && k != TokenKind::Comma && !isTypeKeyword(k))
                    return false;
                ++i;
            }
        }
        // Optional `[]`, then optional `*` / `&`.
        if (peek(i).kind == TokenKind::LBracket && peek(i + 1).kind == TokenKind::RBracket) i += 2;
        if (peek(i).kind == TokenKind::Star || peek(i).kind == TokenKind::Amp) ++i;
        // The binding name.
        if (peek(i).kind != TokenKind::Identifier) return false;
        ++i;
        ++comps;
        if (peek(i).kind == TokenKind::Comma) {
            ++i;
            continue;
        }
        break;
    }
    return comps >= 2 && peek(i).kind == TokenKind::RParen &&
           peek(i + 1).kind == TokenKind::Assign;
}

// (T0 x0, T1 x1, ...) = expr;
ast::StmtPtr Parser::parseTupleDecl() {
    auto decl = std::make_unique<ast::TupleDeclStmt>();
    decl->loc = current().loc;
    expect(TokenKind::LParen, "'('");
    do {
        ast::TupleBinding b;
        b.type = parseTypeRef();
        b.name = expect(TokenKind::Identifier, "a binding name").lexeme;
        decl->bindings.push_back(std::move(b));
    } while (match(TokenKind::Comma));
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::Assign, "'='");
    decl->init = parseExpression();
    expect(TokenKind::Semicolon, "';'");
    return decl;
}

ast::StmtPtr Parser::parseIfStatement(bool isComptime) {
    auto s = std::make_unique<ast::IfStmt>();
    s->loc = current().loc;
    s->isComptime = isComptime;
    expect(TokenKind::KwIf, "'if'");
    expect(TokenKind::LParen, "'('");
    s->cond = parseExpression();
    expect(TokenKind::RParen, "')'");
    s->thenBlock = parseBlock();
    if (match(TokenKind::KwElse)) {
        if (check(TokenKind::KwIf)) {
            // `else if`: wrap the nested if in a block to keep the AST uniform.
            auto inner = std::make_unique<ast::Block>();
            inner->loc = current().loc;
            inner->statements.push_back(parseIfStatement());
            s->elseBlock = std::move(inner);
        } else {
            s->elseBlock = std::make_unique<ast::Block>(parseBlock());
        }
    }
    return s;
}

ast::StmtPtr Parser::parseWhileStatement() {
    auto s = std::make_unique<ast::WhileStmt>();
    s->loc = current().loc;
    expect(TokenKind::KwWhile, "'while'");
    expect(TokenKind::LParen, "'('");
    s->cond = parseExpression();
    expect(TokenKind::RParen, "')'");
    s->body = parseBlock();
    return s;
}

ast::StmtPtr Parser::parseDoStatement() {
    auto s = std::make_unique<ast::DoWhileStmt>();
    s->loc = current().loc;
    expect(TokenKind::KwDo, "'do'");
    s->body = parseBlock();
    expect(TokenKind::KwWhile, "'while'");
    expect(TokenKind::LParen, "'('");
    s->cond = parseExpression();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::Semicolon, "';'");
    return s;
}

ast::StmtPtr Parser::parseForStatement() {
    const SourceLocation loc = current().loc;
    expect(TokenKind::KwFor, "'for'");
    expect(TokenKind::LParen, "'('");
    // foreach over an array: `for (T name in iterable) { ... }` (spec 7). Ranges
    // (`0..10`) and the `index i, T v` form are later refinements.
    if ((check(TokenKind::KwVar) || isTypeKeyword(current().kind) ||
         check(TokenKind::Identifier)) &&
        peek(1).kind == TokenKind::Identifier && peek(2).kind == TokenKind::KwIn) {
        auto fe = std::make_unique<ast::ForeachStmt>();
        fe->loc = loc;
        if (match(TokenKind::KwVar)) {
            fe->isVar = true;  // infer the element type
        } else {
            fe->elemType = parseTypeRef();
        }
        fe->varName = expect(TokenKind::Identifier, "a loop variable name").lexeme;
        expect(TokenKind::KwIn, "'in'");
        fe->iterable = parseExpression();
        expect(TokenKind::RParen, "')'");
        fe->body = parseBlock();
        return fe;
    }
    auto s = std::make_unique<ast::ForStmt>();
    s->loc = loc;
    if (check(TokenKind::KwFinal) || check(TokenKind::KwMutable) || check(TokenKind::KwVar) ||
        isTypeKeyword(current().kind)) {
        s->init = parseVarDeclCore();
    } else if (!check(TokenKind::Semicolon)) {
        s->init = parseSimpleStatement();
    }
    expect(TokenKind::Semicolon, "';'");
    s->cond = parseExpression();
    expect(TokenKind::Semicolon, "';'");
    if (!check(TokenKind::RParen)) {
        s->update = parseSimpleStatement();
    }
    expect(TokenKind::RParen, "')'");
    s->body = parseBlock();
    return s;
}

// switch (x) { case C { ... } ... default { ... } } with C-style fall-through (spec 7.3).
ast::StmtPtr Parser::parseSwitch() {
    auto sw = std::make_unique<ast::SwitchStmt>();
    sw->loc = current().loc;
    expect(TokenKind::KwSwitch, "'switch'");
    expect(TokenKind::LParen, "'('");
    sw->subject = parseExpression();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        if (match(TokenKind::KwDefault)) {
            sw->defaultBody = std::make_unique<ast::Block>(parseBlock());
            continue;
        }
        expect(TokenKind::KwCase, "'case' or 'default'");
        ast::SwitchCase c;
        c.loc = current().loc;
        c.value = parseExpression();
        c.body = parseBlock();
        sw->cases.push_back(std::move(c));
    }
    expect(TokenKind::RBrace, "'}'");
    return sw;
}

// match (subject) { case Type(bindings) { ... } ... default { ... } } (spec 16).
ast::StmtPtr Parser::parseMatch() {
    auto m = std::make_unique<ast::MatchStmt>();
    m->loc = current().loc;
    expect(TokenKind::KwMatch, "'match'");
    expect(TokenKind::LParen, "'('");
    m->subject = parseExpression();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        if (match(TokenKind::KwDefault)) {
            m->defaultBody = std::make_unique<ast::Block>(parseBlock());
            continue;
        }
        expect(TokenKind::KwCase, "'case' or 'default'");
        ast::MatchCase c;
        c.loc = current().loc;
        c.typeName = expect(TokenKind::Identifier, "a case type name").lexeme;
        expect(TokenKind::LParen, "'(' (positional field bindings)");
        c.bindings = parseParams();  // (type name, ...) -- may be empty
        expect(TokenKind::RParen, "')'");
        c.body = parseBlock();
        m->cases.push_back(std::move(c));
    }
    expect(TokenKind::RBrace, "'}'");
    return m;
}

// match (subject) { case Type(bindings) -> expr; ... default -> expr; } as an
// expression (spec 16.2). Each arm yields a value via `->`. Block-bodied arms in
// expression position are not supported yet (the spec leaves their value implicit).
ast::ExprPtr Parser::parseMatchExpr() {
    auto m = std::make_unique<ast::MatchExpr>();
    m->loc = current().loc;
    expect(TokenKind::KwMatch, "'match'");
    expect(TokenKind::LParen, "'('");
    m->subject = parseExpression();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        if (match(TokenKind::KwDefault)) {
            expect(TokenKind::Arrow, "'->' after 'default'");
            m->defaultResult = parseExpression();
            expect(TokenKind::Semicolon, "';'");
            continue;
        }
        expect(TokenKind::KwCase, "'case' or 'default'");
        ast::MatchCase c;
        c.loc = current().loc;
        c.typeName = expect(TokenKind::Identifier, "a case type name").lexeme;
        expect(TokenKind::LParen, "'(' (positional field bindings)");
        c.bindings = parseParams();  // (type name, ...) -- may be empty
        expect(TokenKind::RParen, "')'");
        expect(TokenKind::Arrow, "'->' (a match-expression arm yields a value)");
        c.result = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        m->cases.push_back(std::move(c));
    }
    expect(TokenKind::RBrace, "'}'");
    return m;
}

std::unique_ptr<ast::VarDeclStmt> Parser::parseVarDeclCore() {
    auto decl = std::make_unique<ast::VarDeclStmt>();
    decl->loc = current().loc;
    while (check(TokenKind::KwPersistent) || check(TokenKind::KwEternal) ||
           check(TokenKind::KwVolatile) || check(TokenKind::KwLazy)) {
        if (match(TokenKind::KwPersistent)) decl->isPersistent = true;
        else if (match(TokenKind::KwVolatile)) decl->isVolatile = true;  // spec 37.5
        else if (match(TokenKind::KwLazy)) decl->isLazy = true;          // spec 37.3
        else { advance(); decl->isEternal = true; }  // eternal [persistent]
    }
    if (match(TokenKind::KwFinal)) {  // final = explicitly immutable (the default)
        decl->isMutable = false;
    } else {
        decl->isMutable = match(TokenKind::KwMutable);
    }
    if (match(TokenKind::KwVar)) {
        decl->isVar = true;
    } else {
        decl->type = parseTypeRef();
    }
    decl->name = expect(TokenKind::Identifier, "a variable name").lexeme;
    expect(TokenKind::Assign, "'=' (variables require an initializer)");
    decl->init = parseExpression();
    if (!decl->isVar) rewriteVariantCtor(decl->init, decl->type);
    return decl;
}

ast::StmtPtr Parser::parseDefer() {
    auto d = std::make_unique<ast::DeferStmt>();
    d->loc = current().loc;
    expect(TokenKind::KwDefer, "'defer'");
    d->body = parseBlock();
    return d;
}

ast::StmtPtr Parser::parseUsing() {
    auto u = std::make_unique<ast::UsingStmt>();
    u->loc = current().loc;
    expect(TokenKind::KwUsing, "'using'");
    expect(TokenKind::LParen, "'('");
    auto decl = parseVarDeclCore();  // T x = expr
    u->varName = decl->name;
    u->decl = std::move(decl);
    expect(TokenKind::RParen, "')'");
    u->body = parseBlock();
    return u;
}

ast::StmtPtr Parser::parseVarDecl() {
    auto decl = parseVarDeclCore();
    expect(TokenKind::Semicolon, "';'");
    return decl;
}

// Clones a simple lvalue (identifier / this.field / a[i]) so `x += e` can desugar
// to `x = x + e` without re-parsing. Returns null for unsupported targets.
static ast::ExprPtr cloneLValue(const ast::Expr* e) {
    if (const auto* id = dynamic_cast<const ast::IdentifierExpr*>(e)) {
        auto n = std::make_unique<ast::IdentifierExpr>();
        n->loc = id->loc;
        n->name = id->name;
        return n;
    }
    if (const auto* m = dynamic_cast<const ast::MemberExpr*>(e)) {
        ast::ExprPtr obj = cloneLValue(m->object.get());
        if (obj == nullptr) return nullptr;
        auto n = std::make_unique<ast::MemberExpr>();
        n->loc = m->loc;
        n->member = m->member;
        n->object = std::move(obj);
        return n;
    }
    if (const auto* ix = dynamic_cast<const ast::IndexExpr*>(e)) {
        ast::ExprPtr arr = cloneLValue(ix->array.get());
        ast::ExprPtr idx = cloneLValue(ix->index.get());
        if (arr == nullptr || idx == nullptr) return nullptr;
        auto n = std::make_unique<ast::IndexExpr>();
        n->loc = ix->loc;
        n->array = std::move(arr);
        n->index = std::move(idx);
        return n;
    }
    if (const auto* il = dynamic_cast<const ast::IntLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::IntLiteralExpr>();
        n->loc = il->loc;
        n->text = il->text;
        return n;
    }
    if (const auto* nl = dynamic_cast<const ast::NullLiteralExpr*>(e)) {
        auto n = std::make_unique<ast::NullLiteralExpr>();
        n->loc = nl->loc;
        return n;
    }
    return nullptr;
}

ast::StmtPtr Parser::parseSimpleStatement() {
    ast::ExprPtr expr = parseExpression();
    if (check(TokenKind::Assign)) {
        const Token op = advance();
        auto s = std::make_unique<ast::AssignStmt>();
        s->loc = op.loc;
        s->target = std::move(expr);
        s->value = parseExpression();
        return s;
    }
    // Compound assignment: `x += e` desugars to `x = x + e` (spec 6).
    std::string compoundOp;
    if (check(TokenKind::PlusEq)) compoundOp = "+";
    else if (check(TokenKind::MinusEq)) compoundOp = "-";
    else if (check(TokenKind::StarEq)) compoundOp = "*";
    else if (check(TokenKind::SlashEq)) compoundOp = "/";
    else if (check(TokenKind::PercentEq)) compoundOp = "%";
    else if (check(TokenKind::AmpEq)) compoundOp = "&";
    else if (check(TokenKind::PipeEq)) compoundOp = "|";
    else if (check(TokenKind::CaretEq)) compoundOp = "^";
    else if (check(TokenKind::ShlEq)) compoundOp = "<<";
    else if (check(TokenKind::ShrEq)) compoundOp = ">>";
    if (!compoundOp.empty()) {
        const Token op = advance();
        ast::ExprPtr lhs = cloneLValue(expr.get());
        if (lhs == nullptr) fail("unsupported target for compound assignment", op.loc);
        auto bin = std::make_unique<ast::BinaryExpr>();
        bin->loc = op.loc;
        bin->op = compoundOp;
        bin->lhs = std::move(lhs);
        bin->rhs = parseExpression();
        auto s = std::make_unique<ast::AssignStmt>();
        s->loc = op.loc;
        s->target = std::move(expr);
        s->value = std::move(bin);
        return s;
    }
    if (check(TokenKind::PlusPlus) || check(TokenKind::MinusMinus)) {
        const Token op = advance();
        auto s = std::make_unique<ast::IncDecStmt>();
        s->loc = op.loc;
        s->target = std::move(expr);
        s->isIncrement = (op.kind == TokenKind::PlusPlus);
        return s;
    }
    auto s = std::make_unique<ast::ExprStmt>();
    s->loc = expr->loc;
    s->expr = std::move(expr);
    return s;
}

ast::StmtPtr Parser::parseExprStatement() {
    ast::StmtPtr s = parseSimpleStatement();
    expect(TokenKind::Semicolon, "';'");
    return s;
}

ast::ExprPtr Parser::parseExpression() { return parseTernary(); }

ast::ExprPtr Parser::parseTernary() {
    ast::ExprPtr cond = parseBinary(1);
    if (!check(TokenKind::Question)) return cond;
    auto t = std::make_unique<ast::TernaryExpr>();
    t->loc = current().loc;
    advance();  // '?'
    t->thenExpr = parseExpression();
    expect(TokenKind::Colon, "':' in a ternary expression");
    t->elseExpr = parseExpression();
    t->cond = std::move(cond);
    return t;
}

// Splits an interpolated string's raw content into literal chunks and embedded
// {expr} expressions. Each expression is lexed and parsed on its own (a nested
// Lexer/Parser over the substring); diagnostics are merged into this parser.
ast::ExprPtr Parser::parseInterpolation(const std::string& raw, SourceLocation loc) {
    auto e = std::make_unique<ast::InterpStringExpr>();
    e->loc = loc;
    std::string lit;
    std::size_t i = 0;
    while (i < raw.size()) {
        if (raw[i] == '{') {
            std::size_t depth = 1;
            std::size_t j = i + 1;
            std::string exprSrc;
            while (j < raw.size() && depth > 0) {
                if (raw[j] == '{') {
                    ++depth;
                } else if (raw[j] == '}') {
                    if (--depth == 0) break;
                }
                exprSrc += raw[j];
                ++j;
            }
            if (depth != 0) fail("unterminated '{' in interpolated string", loc);

            e->literals.push_back(lit);
            lit.clear();

            Lexer sublex(exprSrc, file_);
            Parser sub(sublex.tokenize(), file_);
            ast::ExprPtr parsed;
            try {
                parsed = sub.parseExpression();
            } catch (const ParseError&) {
                // recorded below via sub.errors()
            }
            for (const ParseError& se : sub.errors()) errors_.push_back(se);
            if (parsed == nullptr) {
                fail("invalid expression in interpolation: {" + exprSrc + "}", loc);
            }
            e->exprs.push_back(std::move(parsed));
            i = j + 1;  // skip past '}'
        } else {
            lit += raw[i];
            ++i;
        }
    }
    e->literals.push_back(lit);  // trailing chunk (N+1 literals for N expressions)
    return e;
}

ast::ExprPtr Parser::parseBinary(int minPrec) {
    ast::ExprPtr left = parseUnary();
    for (;;) {
        const int prec = binaryPrec(current().kind);
        if (prec == 0 || prec < minPrec) break;
        const Token op = advance();
        ast::ExprPtr right = parseBinary(prec + 1);
        auto bin = std::make_unique<ast::BinaryExpr>();
        bin->loc = op.loc;
        bin->op = op.lexeme;
        bin->lhs = std::move(left);
        bin->rhs = std::move(right);
        left = std::move(bin);
    }
    return left;
}

ast::ExprPtr Parser::parseUnary() {
    // try? expr -- Result/Option error propagation (spec 21.2): `try` then `?`.
    if (check(TokenKind::KwTry) && peek(1).kind == TokenKind::Question) {
        auto t = std::make_unique<ast::TryExpr>();
        t->loc = current().loc;
        advance();  // 'try'
        advance();  // '?'
        t->operand = parseUnary();
        return t;
    }
    // cast<T>(expr) -- explicit conversion.
    if (check(TokenKind::KwCast)) {
        auto c = std::make_unique<ast::CastExpr>();
        c->loc = current().loc;
        advance();  // 'cast'
        expect(TokenKind::Lt, "'<' after 'cast'");
        const Token& tt = current();
        if (isTypeKeyword(tt.kind) || tt.kind == TokenKind::Identifier) {
            c->targetType = tt.lexeme;
            advance();
        } else {
            fail("expected a type inside cast<...>", tt.loc);
        }
        expect(TokenKind::Gt, "'>' to close cast<...>");
        expect(TokenKind::LParen, "'(' after cast<T>");
        c->operand = parseExpression();
        expect(TokenKind::RParen, "')'");
        return c;
    }
    // `move x` transfers ownership (the source becomes invalid).
    if (check(TokenKind::KwMove)) {
        auto mv = std::make_unique<ast::MoveExpr>();
        mv->loc = current().loc;
        advance();
        mv->operand = parseUnary();
        return mv;
    }
    // Prefix '&' is address-of (share the object); '-' negation; '!' logical not; '~' bitwise not.
    if (check(TokenKind::Minus) || check(TokenKind::Bang) || check(TokenKind::Amp) ||
        check(TokenKind::Tilde)) {
        const Token op = advance();
        auto un = std::make_unique<ast::UnaryExpr>();
        un->loc = op.loc;
        un->op = op.lexeme;
        un->operand = parseUnary();
        return un;
    }
    return parsePostfix();
}

ast::ExprPtr Parser::parsePostfix() {
    ast::ExprPtr expr = parsePrimary();
    for (;;) {
        if (check(TokenKind::Dot)) {
            auto m = std::make_unique<ast::MemberExpr>();
            m->loc = current().loc;
            advance();  // '.'
            // `method` is a keyword but also the reflection accessor t.method("x").
            if (check(TokenKind::KwMethod)) {
                m->member = "method";
                advance();
            } else {
                m->member = expect(TokenKind::Identifier, "a member name").lexeme;
            }
            m->object = std::move(expr);
            expr = std::move(m);
        } else if (check(TokenKind::Lt) && looksLikeGenericCall()) {
            // Generic method call: obj.m<int>(args). Parse the type arguments here;
            // the `(` then forms the call below, carrying the args (spec 15).
            std::vector<std::string> typeArgs;
            advance();  // '<'
            do {
                ast::TypeRef arg = parseTypeRef();
                typeArgs.push_back(ast::canonicalType(arg));
            } while (match(TokenKind::Comma));
            if (current().kind == TokenKind::Shr) {
                tokens_[pos_].kind = TokenKind::Gt;  // split '>>'
            } else {
                expect(TokenKind::Gt, "'>' to close type arguments");
            }
            auto call = std::make_unique<ast::CallExpr>();
            call->loc = current().loc;
            expect(TokenKind::LParen, "'('");
            if (!check(TokenKind::RParen)) {
                do {
                    call->args.push_back(parseExpression());
                } while (match(TokenKind::Comma));
            }
            expect(TokenKind::RParen, "')'");
            call->callee = std::move(expr);
            call->typeArgs = std::move(typeArgs);
            expr = std::move(call);
        } else if (check(TokenKind::LParen)) {
            auto call = std::make_unique<ast::CallExpr>();
            call->loc = current().loc;
            advance();  // '('
            if (!check(TokenKind::RParen)) {
                do {
                    call->args.push_back(parseExpression());
                } while (match(TokenKind::Comma));
            }
            expect(TokenKind::RParen, "')'");
            call->callee = std::move(expr);
            expr = std::move(call);
        } else if (check(TokenKind::LBracket)) {
            auto idx = std::make_unique<ast::IndexExpr>();
            idx->loc = current().loc;
            advance();  // '['
            idx->index = parseExpression();
            expect(TokenKind::RBracket, "']'");
            idx->array = std::move(expr);
            expr = std::move(idx);
        } else {
            break;
        }
    }
    return expr;
}

// Parses `{ Type (, Type)* }` -- a set of (possibly dotted) type names, the
// argument to accepts/rejects.
void Parser::parseTypeSet(std::vector<std::string>& out) {
    expect(TokenKind::LParen, "'(' after accepts/rejects");
    expect(TokenKind::LBrace, "'{'");
    if (!check(TokenKind::RBrace)) {
        do {
            std::string name = expect(TokenKind::Identifier, "a type name").lexeme;
            while (match(TokenKind::Dot)) {
                name += "." + expect(TokenKind::Identifier, "a name after '.'").lexeme;
            }
            out.push_back(std::move(name));
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::RBrace, "'}'");
    expect(TokenKind::RParen, "')'");
}

// Parses `itself.allocate(size) [.accepts({...})] [.rejects({...})]` (spec 17.2-17.3).
ast::ExprPtr Parser::parseRegionInit() {
    auto e = std::make_unique<ast::RegionInitExpr>();
    e->loc = current().loc;
    expect(TokenKind::KwItself, "'itself'");
    expect(TokenKind::Dot, "'.' after 'itself'");
    const Token method = expect(TokenKind::Identifier, "'allocate'");
    if (method.lexeme != "allocate") {
        fail("only itself.allocate(...) is supported for now, not 'itself." + method.lexeme + "'",
             method.loc);
    }
    expect(TokenKind::LParen, "'('");
    e->size = parseExpression();
    expect(TokenKind::RParen, "')'");
    while (check(TokenKind::Dot)) {
        advance();  // '.'
        if (check(TokenKind::KwAccepts)) {
            advance();
            parseTypeSet(e->accepts);
        } else if (check(TokenKind::KwRejects)) {
            advance();
            parseTypeSet(e->rejects);
        } else {
            fail("expected 'accepts' or 'rejects' after '.'", current().loc);
        }
    }
    return e;
}

// After a numeric literal, an identifier means a literal suffix (spec 17.10):
// `64 kilobytes` parses as kilobytes(64). Otherwise the literal stands alone.
ast::ExprPtr Parser::maybeLiteralSuffix(ast::ExprPtr literal) {
    if (!check(TokenKind::Identifier)) return literal;
    auto call = std::make_unique<ast::CallExpr>();
    call->loc = current().loc;
    call->fromSuffix = true;
    auto callee = std::make_unique<ast::IdentifierExpr>();
    callee->loc = current().loc;
    callee->name = advance().lexeme;  // the suffix name
    call->callee = std::move(callee);
    call->args.push_back(std::move(literal));
    return call;
}

ast::ExprPtr Parser::parsePrimary() {
    const Token& tok = current();
    switch (tok.kind) {
        case TokenKind::IntLiteral: {
            auto e = std::make_unique<ast::IntLiteralExpr>();
            e->loc = tok.loc;
            e->text = tok.lexeme;
            advance();
            return maybeLiteralSuffix(std::move(e));
        }
        case TokenKind::FloatLiteral: {
            auto e = std::make_unique<ast::FloatLiteralExpr>();
            e->loc = tok.loc;
            e->text = tok.lexeme;
            advance();
            return maybeLiteralSuffix(std::move(e));
        }
        case TokenKind::KwNull: {
            auto e = std::make_unique<ast::NullLiteralExpr>();
            e->loc = tok.loc;
            advance();
            return e;
        }
        case TokenKind::KwLambda: {
            auto e = std::make_unique<ast::LambdaExpr>();
            e->loc = tok.loc;
            advance();  // 'lambda'
            // Optional capture list: lambda[captures: byvalue x, byref y](...). Parsed now;
            // the codegen for closures (carrying an environment) is the next step.
            if (check(TokenKind::LBracket)) {
                advance();  // '['
                expect(TokenKind::Identifier, "'captures' in the lambda capture list");
                expect(TokenKind::Colon, "':' after 'captures'");
                do {
                    ast::Capture cap;
                    cap.loc = current().loc;
                    const std::string mode = current().lexeme;
                    expect(TokenKind::Identifier, "'byvalue' or 'byref'");
                    if (mode != "byvalue" && mode != "byref") {
                        fail("expected 'byvalue' or 'byref' but found '" + mode + "'", cap.loc);
                    }
                    cap.byRef = (mode == "byref");
                    cap.name = current().lexeme;
                    expect(TokenKind::Identifier, "a captured variable name");
                    e->captures.push_back(std::move(cap));
                } while (match(TokenKind::Comma));
                expect(TokenKind::RBracket, "']' to close the capture list");
            }
            expect(TokenKind::LParen, "'(' after lambda");
            e->params = parseParams();
            expect(TokenKind::RParen, "')' to close lambda parameters");
            expect(TokenKind::KwReturns, "'returns' in a lambda");
            e->returnType = parseTypeRef();
            // The lambda's body has its OWN return type for the Ok(x)/Some(x) sugar;
            // save/restore so a return inside it rewrites against the lambda's type,
            // not the enclosing method's.
            ast::TypeRef savedRet = currentMethodReturnType_;
            currentMethodReturnType_ = e->returnType;
            e->body = parseBlock();
            currentMethodReturnType_ = savedRet;
            return e;
        }
        case TokenKind::StringLiteral: {
            auto e = std::make_unique<ast::StringLiteralExpr>();
            e->loc = tok.loc;
            e->value = tok.lexeme;
            advance();
            return e;
        }
        case TokenKind::CharLiteral: {
            auto e = std::make_unique<ast::CharLiteralExpr>();
            e->loc = tok.loc;
            e->value = tok.lexeme;
            advance();
            return e;
        }
        case TokenKind::InterpString: {
            const std::string raw = tok.lexeme;
            const SourceLocation loc = tok.loc;
            advance();
            return parseInterpolation(raw, loc);
        }
        case TokenKind::KwTrue:
        case TokenKind::KwFalse: {
            auto e = std::make_unique<ast::BoolLiteralExpr>();
            e->loc = tok.loc;
            e->value = (tok.kind == TokenKind::KwTrue);
            advance();
            return e;
        }
        case TokenKind::Identifier:
        case TokenKind::KwThis: {
            auto e = std::make_unique<ast::IdentifierExpr>();
            e->loc = tok.loc;
            e->name = tok.lexeme;
            advance();
            return e;
        }
        case TokenKind::KwSuper: {
            auto e = std::make_unique<ast::SuperExpr>();
            e->loc = tok.loc;
            advance();
            return e;  // parsePostfix turns `super(args)` into a CallExpr
        }
        case TokenKind::KwItself:
            // `itself.allocate(...)` region initializer (spec 17.2-17.3, 17.9).
            return parseRegionInit();
        case TokenKind::LParen: {
            const SourceLocation lp = tok.loc;
            advance();
            ast::ExprPtr inner = parseExpression();
            // A comma turns `(a, b, ...)` into a tuple literal (spec 22.5);
            // otherwise it is an ordinary parenthesized expression.
            if (check(TokenKind::Comma)) {
                auto tup = std::make_unique<ast::TupleExpr>();
                tup->loc = lp;
                tup->elements.push_back(std::move(inner));
                while (match(TokenKind::Comma)) {
                    tup->elements.push_back(parseExpression());
                }
                expect(TokenKind::RParen, "')' to close a tuple literal");
                return tup;
            }
            expect(TokenKind::RParen, "')'");
            return inner;
        }
        case TokenKind::KwNew:
            return parseNew();
        case TokenKind::KwMatch:
            // match (...) { case T(..) -> expr; ... } in expression position (spec 16.2).
            return parseMatchExpr();
        default:
            fail("expected an expression but found '" + tok.lexeme + "'", tok.loc);
    }
}

ast::ExprPtr Parser::parseNew() {
    const SourceLocation loc = current().loc;
    expect(TokenKind::KwNew, "'new'");
    // Base type: a primitive keyword (int/char/...) or a class name.
    std::string typeName;
    if (isTypeKeyword(current().kind) || check(TokenKind::Identifier)) {
        const bool isIdent = check(TokenKind::Identifier);
        typeName = advance().lexeme;
        // Namespace-qualified class name: new app.Box(...).
        while (isIdent && check(TokenKind::Dot) && peek(1).kind == TokenKind::Identifier) {
            advance();  // '.'
            typeName += "." + expect(TokenKind::Identifier, "a type name after '.'").lexeme;
            sawQualifiedType_ = true;
        }
    } else {
        fail("expected a type after 'new' but found '" + current().lexeme + "'", current().loc);
    }

    // Array form: new T[size]() [on stack|heap]
    if (match(TokenKind::LBracket)) {
        auto arr = std::make_unique<ast::NewArrayExpr>();
        arr->loc = loc;
        arr->elementType = std::move(typeName);
        arr->size = parseExpression();
        expect(TokenKind::RBracket, "']'");
        expect(TokenKind::LParen, "'(' (zero-initialized array: new T[n]())");
        expect(TokenKind::RParen, "')'");
        if (match(TokenKind::KwOn)) {
            arr->location = expect(TokenKind::Identifier, "'stack' or 'heap'").lexeme;
        } else {
            arr->location = "heap";  // arrays are dynamic -> default heap
        }
        return arr;
    }

    // Object form: new T(args) [on stack|heap], with optional generic args.
    auto e = std::make_unique<ast::NewExpr>();
    e->loc = loc;
    e->className = std::move(typeName);
    if (match(TokenKind::Lt)) {
        do {
            ast::TypeRef arg = parseTypeRef();
            e->typeArgs.push_back(ast::canonicalType(arg));
        } while (match(TokenKind::Comma));
        if (current().kind == TokenKind::Shr) {
            tokens_[pos_].kind = TokenKind::Gt;  // split '>>'
        } else {
            expect(TokenKind::Gt, "'>' to close type arguments");
        }
    }
    expect(TokenKind::LParen, "'('");
    if (!check(TokenKind::RParen)) {
        do {
            e->args.push_back(parseExpression());
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::RParen, "')'");
    // Memory location is optional. Omitted, objects default to the stack (RAII,
    // no `delete`). Write `on stack` / `on heap` only to force a placement.
    if (match(TokenKind::KwOn)) {
        e->location = expect(TokenKind::Identifier, "'stack' or 'heap'").lexeme;
    } else {
        e->location = "stack";
    }
    // `in region R`: allocate inside a region (spec 17.5). Takes precedence.
    if (match(TokenKind::KwIn)) {
        expect(TokenKind::KwRegion, "'region' after 'in'");
        e->region = expect(TokenKind::Identifier, "the region name").lexeme;
    }
    return e;
}

}  // namespace ldp3
