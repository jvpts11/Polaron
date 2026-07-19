#include "parser/parser.h"

#include <algorithm>
#include <cctype>

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

// Numeric field types that contribute to a record's auto-generated hashCode.
bool isRecordNumericField(const std::string& t) {
    return t == "int" || t == "byte" || t == "short" || t == "long" || t == "char" ||
           t == "boolean" || t == "float" || t == "double" || t == "int8" || t == "int16" ||
           t == "int32" || t == "int64" || t == "uint8" || t == "uint16" || t == "uint32" ||
           t == "uint64" || t == "ubyte" || t == "ushort" || t == "uint" || t == "ulong" ||
           t == "float32" || t == "float64";
}
bool isRecordFloatField(const std::string& t) {
    return t == "float" || t == "double" || t == "float32" || t == "float64";
}

// Builds `public method hashCode() returns int { mutable int h = 17; h = h*31 + this.f; ...;
// return h; }` (spec 10: auto-generated hashCode). Combines the numeric fields; equal records have
// equal numeric fields, so they hash equal (object/String fields are skipped -- collisions allowed).
ast::MemberPtr buildRecordHashCode(const std::string& typeName,
                                   const std::vector<ast::Param>& fields, SourceLocation loc) {
    (void)typeName;
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = loc;
    m->visibility = "public";
    m->name = "hashCode";
    m->returnType.name = "int";
    auto makeInt = [&](const char* text) {
        auto lit = std::make_unique<ast::IntLiteralExpr>();
        lit->loc = loc;
        lit->text = text;
        return lit;
    };
    auto vd = std::make_unique<ast::VarDeclStmt>();
    vd->loc = loc;
    vd->name = "h";
    vd->isMutable = true;
    vd->type.name = "int";
    vd->init = makeInt("17");
    m->body.statements.push_back(std::move(vd));
    for (const ast::Param& f : fields) {
        if (!isRecordNumericField(f.type.name)) continue;  // object/String fields are not hashed
        ast::ExprPtr fieldVal = makeMember(makeIdent("this", loc), f.name, loc);
        if (isRecordFloatField(f.type.name)) {  // fold a float field to int for the mix
            auto cast = std::make_unique<ast::CastExpr>();
            cast->loc = loc;
            cast->targetType = "int";
            cast->operand = std::move(fieldVal);
            fieldVal = std::move(cast);
        }
        auto mul = std::make_unique<ast::BinaryExpr>();
        mul->loc = loc;
        mul->op = "*";
        mul->lhs = makeIdent("h", loc);
        mul->rhs = makeInt("31");
        auto add = std::make_unique<ast::BinaryExpr>();
        add->loc = loc;
        add->op = "+";
        add->lhs = std::move(mul);
        add->rhs = std::move(fieldVal);
        auto as = std::make_unique<ast::AssignStmt>();
        as->loc = loc;
        as->target = makeIdent("h", loc);
        as->value = std::move(add);
        m->body.statements.push_back(std::move(as));
    }
    auto ret = std::make_unique<ast::ReturnStmt>();
    ret->loc = loc;
    ret->value = makeIdent("h", loc);
    m->body.statements.push_back(std::move(ret));
    return m;
}

// Builds `public method toString() returns String { return "Name(" + this.f0.toString() + ", " + ...
// + ")"; }` for a record's fields (spec 10: auto-generated toString). Each field is rendered via its
// own toString(); a field type without toString() is a compile error in the generated method.
ast::MemberPtr buildRecordToString(const std::string& typeName,
                                   const std::vector<ast::Param>& fields, SourceLocation loc) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = loc;
    m->visibility = "public";
    m->name = "toString";
    m->returnType.name = "String";
    auto makeStr = [&](const std::string& s) {
        auto lit = std::make_unique<ast::StringLiteralExpr>();
        lit->loc = loc;
        lit->value = s;
        return lit;
    };
    auto concat = [&](ast::ExprPtr a, ast::ExprPtr b) -> ast::ExprPtr {
        auto bin = std::make_unique<ast::BinaryExpr>();
        bin->loc = loc;
        bin->op = "+";
        bin->lhs = std::move(a);
        bin->rhs = std::move(b);
        return bin;
    };
    auto fieldStr = [&](const ast::Param& f) -> ast::ExprPtr {
        auto call = std::make_unique<ast::CallExpr>();
        call->loc = loc;
        call->callee = makeMember(makeMember(makeIdent("this", loc), f.name, loc), "toString", loc);
        return call;
    };
    ast::ExprPtr expr = makeStr(typeName + "(");
    for (std::size_t i = 0; i < fields.size(); ++i) {
        if (i > 0) expr = concat(std::move(expr), makeStr(", "));
        expr = concat(std::move(expr), fieldStr(fields[i]));
    }
    expr = concat(std::move(expr), makeStr(")"));
    auto ret = std::make_unique<ast::ReturnStmt>();
    ret->loc = loc;
    ret->value = std::move(expr);
    m->body.statements.push_back(std::move(ret));
    return m;
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

// Region flavor / growth soft keywords (spec 17, flavors expansion). These are contextual: they act
// as modifiers only immediately before a `region` type, and stay ordinary identifiers everywhere else.
bool isRegionFlavorWord(const Token& t) {
    if (t.kind != TokenKind::Identifier) return false;
    const std::string& s = t.lexeme;
    return s == "bump" || s == "pool" || s == "stack" || s == "fixedslot" ||
           s == "ring" || s == "growable";
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
        // File-level imports come before `program` (spec 2.7); `final`/`lazy import` are permitted.
        while (check(TokenKind::KwImport) ||
               ((check(TokenKind::KwFinal) || check(TokenKind::KwLazy)) &&
                peek(1).kind == TokenKind::KwImport))
            program.imports.push_back(parseImportDecl());
        expect(TokenKind::KwProgram, "'program'");
        program.name = expect(TokenKind::Identifier, "the program name").lexeme;
        if (match(TokenKind::KwFreestanding)) program.isFreestanding = true;  // spec 36.8
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

// `import a.b.c;` (spec 2.7). Written before `program` (file level).
ast::ImportDecl Parser::parseImportDecl() {
    ast::ImportDecl imp;
    imp.loc = current().loc;
    imp.isFinal = match(TokenKind::KwFinal);  // `final import` (spec 37.6): cannot be unimported
    imp.isLazy = match(TokenKind::KwLazy);    // `lazy import` (spec 37.3): load on first instance
    expect(TokenKind::KwImport, "'import'");
    // Cross-program (spec 2.7/2.8): `import from program GameEngine bundle audio.mixers.StereoMixer;`
    // -- the type is known from the other program's header and reached over IPC.
    if (check(TokenKind::Identifier) && current().lexeme == "from") {
        advance();
        if (!(check(TokenKind::KwProgram))) fail("expected 'program' after 'import from'", current().loc);
        advance();
        imp.programName = expectMemberName("the program name");
        if (check(TokenKind::KwBundle)) advance();  // `bundle` is optional noise in the path
        imp.path.push_back(expectMemberName("an import path"));
        while (match(TokenKind::Dot)) imp.path.push_back(expectMemberName("a name after '.'"));
        expect(TokenKind::Semicolon, "';'");
        return imp;
    }
    imp.path.push_back(expect(TokenKind::Identifier, "an import path").lexeme);
    while (match(TokenKind::Dot))
        imp.path.push_back(expect(TokenKind::Identifier, "a name after '.'").lexeme);
    expect(TokenKind::Semicolon, "';'");
    return imp;
}

ast::CascadeParams Parser::parseCascadeParamsOpt() {
    ast::CascadeParams p;
    if (!match(TokenKind::LParen)) return p;
    if (!check(TokenKind::RParen)) {
        do {
            const Token key = current();
            if (key.kind != TokenKind::Identifier)
                fail("expected a cascade parameter (depth, unlimited, types, except)", key.loc);
            advance();
            if (key.lexeme == "unlimited") {
                p.depth = -1;
            } else if (key.lexeme == "depth") {
                expect(TokenKind::Colon, "':' after 'depth'");
                const Token n = expect(TokenKind::IntLiteral, "a depth value");
                p.depth = static_cast<int>(std::strtol(n.lexeme.c_str(), nullptr, 0));
            } else if (key.lexeme == "types" || key.lexeme == "except") {
                std::vector<std::string>& dst = (key.lexeme == "types") ? p.onlyTypes : p.exceptTypes;
                expect(TokenKind::Colon, "':' after a cascade type filter");
                expect(TokenKind::LBrace, "'{' to start the type list");
                if (!check(TokenKind::RBrace)) {
                    do {
                        dst.push_back(expect(TokenKind::Identifier, "a type name").lexeme);
                    } while (match(TokenKind::Comma));
                }
                expect(TokenKind::RBrace, "'}' to close the type list");
            } else {
                fail("unknown cascade parameter '" + key.lexeme +
                         "' (use depth, unlimited, types, except)",
                     key.loc);
            }
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::RParen, "')' to close cascade parameters");
    return p;
}

void Parser::parseLabelRef(std::string& name) {
    name = expect(TokenKind::Identifier, "a label name").lexeme;
    // The chaos tetrad is intra-method only: a method-qualified `method.label` form is an error.
    if (check(TokenKind::Dot))
        fail("cross-method goto/comefrom/abstainfrom/reinstate is not allowed; "
             "these are intra-method only (spec 7.9-7.11)",
             current().loc);
}

ast::Bundle Parser::parseBundle() {
    ast::Bundle b;
    b.loc = current().loc;
    b.visibility = parseVisibilityOpt();
    expect(TokenKind::KwBundle, "'bundle'");
    b.name = expect(TokenKind::Identifier, "the bundle name").lexeme;
    if (match(TokenKind::KwFreestanding)) b.isFreestanding = true;  // spec 36.8
    expect(TokenKind::LBrace, "'{'");
    // Imports belong before `program` (spec 2.7), not inside a bundle.
    if (check(TokenKind::KwImport))
        fail("imports must be written before 'program', not inside a bundle (spec 2.7)",
             current().loc);
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
        // Leading annotations (spec 14.3): `[Name(...)]` applied to the declaration that follows.
        std::vector<ast::AnnotationUse> anns = parseAnnotationUsesOpt();
        // Peek past an optional visibility modifier to tell enums from classes.
        TokenKind kind = current().kind;
        if (kind == TokenKind::KwPublic || kind == TokenKind::KwPrivate ||
            kind == TokenKind::KwProtected || kind == TokenKind::KwInternal) {
            kind = peek(1).kind;
        }
        if (kind == TokenKind::KwAnnotation) {
            ns.annotationDecls.push_back(parseAnnotationDecl(anns));
            continue;
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
        } else if (kind == TokenKind::KwFixed) {
            ns.consts.push_back(parseConstDecl());
        } else if (kind == TokenKind::KwRecord) {
            ast::ClassDecl rec = parseRecord();
            rec.annotations = std::move(anns);
            ns.classes.push_back(std::move(rec));
        } else if (kind == TokenKind::KwExtern) {
            parseExternInto(ns.externs);
        } else if (kind == TokenKind::KwTypealias || kind == TokenKind::KwNewtype) {
            ns.typeAliases.push_back(parseTypeAlias());
        } else {
            ast::ClassDecl cls = parseClassOrInterface();
            cls.annotations = std::move(anns);
            ns.classes.push_back(std::move(cls));
        }
    }
    expect(TokenKind::RBrace, "'}'");
    return ns;
}

// `[visibility] extern <cdecl|stdcall|fastcall> method name(params) returns T;` (spec 26), or the
// grouped form `extern <conv> library NAME { method ...; method ...; }`.
void Parser::parseExternInto(std::vector<ast::ExternDecl>& out) {
    parseVisibilityOpt();  // optional; an external symbol has no LDP3 visibility
    expect(TokenKind::KwExtern, "'extern'");
    std::string conv;
    if (match(TokenKind::KwCdecl)) conv = "cdecl";
    else if (match(TokenKind::KwStdcall)) conv = "stdcall";
    else if (match(TokenKind::KwFastcall)) conv = "fastcall";
    else fail("expected a calling convention (cdecl/stdcall/fastcall) after 'extern'", current().loc);
    if (check(TokenKind::Identifier) && current().lexeme == "library") {
        advance();  // 'library'
        expect(TokenKind::Identifier, "the library name");  // linked externally; not used here yet
        expect(TokenKind::LBrace, "'{' to open the extern library block");
        while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile))
            out.push_back(parseExternMethod(conv));
        expect(TokenKind::RBrace, "'}' to close the extern library block");
        return;
    }
    out.push_back(parseExternMethod(conv));
}

ast::ExternDecl Parser::parseExternMethod(const std::string& convention) {
    ast::ExternDecl e;
    e.convention = convention;
    e.loc = current().loc;
    expect(TokenKind::KwMethod, "'method' after the calling convention");
    e.name = expect(TokenKind::Identifier, "the external function name").lexeme;
    expect(TokenKind::LParen, "'('");
    // Like parseParams, but a trailing `...` marks the function variadic (spec 26, e.g. printf).
    // `...` is lexed as '..' (DotDot) followed by '.'.
    if (!check(TokenKind::RParen)) {
        do {
            if (check(TokenKind::DotDot)) {
                advance();
                match(TokenKind::Dot);  // the third '.'
                e.isVariadic = true;
                break;
            }
            ast::Param p;
            p.loc = current().loc;
            p.type = parseTypeRef();
            p.name = expect(TokenKind::Identifier, "a parameter name").lexeme;
            e.params.push_back(std::move(p));
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::KwReturns, "'returns'");
    e.returnType = parseTypeRef();
    expect(TokenKind::Semicolon, "';' after an extern declaration");
    return e;
}

// Parses a `[comptime] literal name(T param) returns R { body }` member from the `literal` keyword
// onward; the visibility and `comptime` modifier are parsed by the caller.
std::unique_ptr<ast::LiteralDecl> Parser::parseLiteralMember(std::string visibility, bool isComptime) {
    auto l = std::make_unique<ast::LiteralDecl>();
    l->loc = current().loc;
    l->visibility = std::move(visibility);
    l->isComptime = isComptime;
    expect(TokenKind::KwLiteral, "'literal'");
    l->name = expect(TokenKind::Identifier, "the literal suffix name").lexeme;
    expect(TokenKind::LParen, "'('");
    std::vector<ast::Param> params = parseParams();
    expect(TokenKind::RParen, "')'");
    if (params.size() != 1) {
        fail("a literal suffix must take exactly one parameter", l->loc);
    }
    l->param = std::move(params[0]);
    expect(TokenKind::KwReturns, "'returns'");
    l->returnType = parseTypeRef();
    l->body = parseBlock();
    return l;
}

ast::LiteralDecl Parser::parseLiteral() {
    std::string visibility = parseVisibilityOpt();
    bool isComptime = match(TokenKind::KwComptime);
    return std::move(*parseLiteralMember(std::move(visibility), isComptime));
}

// Parses zero or more applied annotations preceding a declaration. Two equivalent spellings (spec 14.1):
//   `[Name(arg: val, ...)]`  -- user-defined annotations (spec 14.3)
//   `@Name(arg: val, ...)`   -- the language's built-in ones, e.g. `@Test` (spec 32.11)
// Both produce the same AnnotationUse, so a built-in is just an annotation the stdlib declares.
std::vector<ast::AnnotationUse> Parser::parseAnnotationUsesOpt() {
    std::vector<ast::AnnotationUse> uses;
    while (check(TokenKind::LBracket) || check(TokenKind::At)) {
        const bool bracketed = check(TokenKind::LBracket);
        // A compiler attribute is written with double brackets (spec 36.4): `[[no_bounds_check]]`.
        // Same node, so a consumer just looks the name up; only the closing bracket count differs.
        const bool attribute = bracketed && peek(1).kind == TokenKind::LBracket;
        ast::AnnotationUse use;
        use.loc = current().loc;
        advance();  // '[' or '@'
        if (attribute) advance();  // the second '['
        use.name = expect(TokenKind::Identifier,
                          bracketed ? "an annotation name after '['" : "an annotation name after '@'")
                       .lexeme;
        if (match(TokenKind::LParen)) {
            if (!check(TokenKind::RParen)) {
                do {
                    ast::AnnotationArg arg;
                    arg.loc = current().loc;
                    arg.name = expect(TokenKind::Identifier, "an annotation argument name").lexeme;
                    expect(TokenKind::Colon, "':' after the annotation argument name");
                    arg.value = parseExpression();
                    use.args.push_back(std::move(arg));
                } while (match(TokenKind::Comma));
            }
            expect(TokenKind::RParen, "')' to close the annotation arguments");
        }
        if (bracketed) expect(TokenKind::RBracket, "']' to close the annotation");
        if (attribute) expect(TokenKind::RBracket, "']]' to close the attribute");
        uses.push_back(std::move(use));
    }
    return uses;
}

// `[visibility] annotation Name { (Type field [default expr];)* }` (spec 14.3): a custom annotation
// type. A preceding `[CompileTimeProcessor]` (spec 14.4) is passed in via `leading`.
ast::AnnotationDecl Parser::parseAnnotationDecl(const std::vector<ast::AnnotationUse>& leading) {
    ast::AnnotationDecl a;
    a.loc = current().loc;
    a.visibility = parseVisibilityOpt();
    expect(TokenKind::KwAnnotation, "'annotation'");
    a.name = expect(TokenKind::Identifier, "the annotation name").lexeme;
    for (const ast::AnnotationUse& u : leading)
        if (u.name == "CompileTimeProcessor") a.isCompileTimeProcessor = true;
    expect(TokenKind::LBrace, "'{' to open the annotation body");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        ast::AnnotationField f;
        f.loc = current().loc;
        f.type = parseTypeRef();
        f.name = expect(TokenKind::Identifier, "the annotation field name").lexeme;
        if (match(TokenKind::KwDefault)) {  // `default expr` -> the field is optional (spec 14.3)
            f.defaultValue = parseExpression();
        }
        expect(TokenKind::Semicolon, "';' after the annotation field");
        a.fields.push_back(std::move(f));
    }
    expect(TokenKind::RBrace, "'}' to close the annotation body");
    return a;
}

// `[visibility] (typealias|newtype) Name = Target;` (spec 24). typealias is transparent;
// newtype creates a distinct nominal type over the same representation.
ast::TypeAliasDecl Parser::parseTypeAlias() {
    ast::TypeAliasDecl a;
    a.loc = current().loc;
    a.visibility = parseVisibilityOpt();
    if (match(TokenKind::KwNewtype)) {
        a.isNewtype = true;
    } else {
        expect(TokenKind::KwTypealias, "'typealias' or 'newtype'");
    }
    a.name = expect(TokenKind::Identifier, "the alias name").lexeme;
    expect(TokenKind::Assign, "'=' in a type alias");
    a.target = parseTypeRef();
    expect(TokenKind::Semicolon, "';' after a type alias");
    return a;
}

// `[visibility] const T NAME = expr;` -- a namespace-level compile-time constant
// (spec 28.1). The initializer is a constant expression validated by the analyzer.
// Parses `const T NAME = expr;` from the `const` keyword onward; the visibility is parsed by the
// caller. Used both at namespace level and as a class/struct member (a static compile-time constant).
std::unique_ptr<ast::ConstDecl> Parser::parseConstMember(std::string visibility) {
    auto c = std::make_unique<ast::ConstDecl>();
    c->loc = current().loc;
    c->visibility = std::move(visibility);
    expect(TokenKind::KwFixed, "'fixed'");
    c->type = parseTypeRef();
    c->name = expect(TokenKind::Identifier, "the constant name").lexeme;
    expect(TokenKind::Assign, "'='");
    c->init = parseExpression();
    expect(TokenKind::Semicolon, "';'");
    return c;
}

ast::ConstDecl Parser::parseConstDecl() {
    std::string visibility = parseVisibilityOpt();
    return std::move(*parseConstMember(std::move(visibility)));
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

ast::ClassDecl Parser::parseClassForSynthesis() { return parseClassOrInterface(); }

ast::ClassDecl Parser::parseClassOrInterface() {
    ast::ClassDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    if (match(TokenKind::KwPartial)) c.isPartial = true;   // spec 8.3: one part of a split class
    if (match(TokenKind::KwSealed)) c.isSealed = true;
    if (match(TokenKind::KwFinal)) c.isFinal = true;
    if (match(TokenKind::KwAbstract)) c.isAbstract = true;
    if (match(TokenKind::KwPartial)) c.isPartial = true;   // ... in either order
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
            // Constraint (spec 15.2): `<T extends Base>` or `<T implements Iface>`, whose own type
            // arguments count: `<T implements Comparable<T>>` demands Comparable OF T, not of anything.
            // The bound is stored in its canonical mangled form ("Comparable$T"), so the constraint check
            // at instantiation can substitute T and compare the whole thing.
            if (match(TokenKind::KwExtends) || match(TokenKind::KwImplements))
                c.typeParamBounds.push_back({tp, parseBoundName()});
        } while (match(TokenKind::Comma));
        expect(TokenKind::Gt, "'>' to close type parameters");
    }
    if (match(TokenKind::KwExtends)) {
        if (c.isStruct) fail("a struct cannot extend another type (structs have no inheritance)",
                             c.loc);
        c.superclass = expect(TokenKind::Identifier, "a superclass name").lexeme;
        if (match(TokenKind::Lt)) {  // generic base: extends Base<T>, or a concrete arg like Base<int>
            do {
                if (!isTypeKeyword(current().kind) && current().kind != TokenKind::Identifier)
                    fail("expected a type argument but found '" + current().lexeme + "'", current().loc);
                c.superclassTypeArgs.push_back(current().lexeme);
                advance();
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
                    if (!isTypeKeyword(current().kind) && current().kind != TokenKind::Identifier)
                        fail("expected a type argument but found '" + current().lexeme + "'", current().loc);
                    args.push_back(current().lexeme);
                    advance();
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
        if (atAffinityBlock()) {  // spec 32.9: a cache-locality hint grouping fields as hot/cold
            parseAffinityBlock(c);
            continue;
        }
        c.members.push_back(parseMember(c.isInterface));
        // A property with a custom setter synthesizes extra members (the setter method); collect them.
        for (auto& em : extraMembers_) c.members.push_back(std::move(em));
        extraMembers_.clear();
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
            std::vector<std::string> args;  // generic interface args: implements Comparable<Point3D>
            if (match(TokenKind::Lt)) {
                do {
                    if (!isTypeKeyword(current().kind) && current().kind != TokenKind::Identifier)
                        fail("expected a type argument but found '" + current().lexeme + "'", current().loc);
                    args.push_back(current().lexeme);
                    advance();
                } while (match(TokenKind::Comma));
                expect(TokenKind::Gt, "'>' to close type arguments");
            }
            c.interfaceTypeArgs.push_back(std::move(args));
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
    c.members.push_back(buildRecordHashCode(c.name, fields, c.loc));
    c.members.push_back(buildRecordToString(c.name, fields, c.loc));

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

// A member name: an identifier, or a KEYWORD used as a member. `a.namespace("mixers")` (spec 2.8) and
// `method namespace(...)` are both unambiguous -- after a `.` or after `method`, nothing else can start
// there -- and the spec's own IPC example needs it, since `namespace` is one of the 134 reserved words.
std::string Parser::expectMemberName(const char* what) {
    if (check(TokenKind::Identifier)) return expect(TokenKind::Identifier, what).lexeme;
    const Token& t = current();
    if (!t.lexeme.empty() && (std::isalpha(static_cast<unsigned char>(t.lexeme[0])) != 0)) {
        advance();
        return t.lexeme;  // a keyword spelled where a member name is expected
    }
    return expect(TokenKind::Identifier, what).lexeme;  // reports the error
}

// A type-parameter constraint (spec 15.2), in canonical mangled form: `Numeric` -> "Numeric",
// `Comparable<T>` -> "Comparable$T". Carrying the bound's own arguments is what lets the check at
// instantiation demand Comparable OF T rather than Comparable of anything. A `>>` closing both the
// bound and the type-parameter list is split, leaving a single `>` for the caller.
std::string Parser::parseBoundName() {
    std::string base = expect(TokenKind::Identifier, "a constraint type").lexeme;
    std::vector<std::string> args;
    if (match(TokenKind::Lt)) {
        do {
            if (!isTypeKeyword(current().kind) && current().kind != TokenKind::Identifier)
                fail("expected a type argument but found '" + current().lexeme + "'", current().loc);
            args.push_back(current().lexeme);
            advance();
        } while (match(TokenKind::Comma));
        if (check(TokenKind::Shr)) tokens_[pos_].kind = TokenKind::Gt;  // `>>`: one closes the bound
        else expect(TokenKind::Gt, "'>' to close the constraint's type arguments");
    }
    return ast::mangleGeneric(base, args);
}

// `affinity` is a soft keyword: only a class-body `affinity hot {` / `affinity cold {` (with an optional
// leading visibility, which the spec's example carries and the keyword catalog's does not) starts a block.
// Anywhere else the word stays an ordinary identifier.
bool Parser::atAffinityBlock() const {
    int i = 0;
    if (check(TokenKind::KwPublic) || check(TokenKind::KwPrivate) || check(TokenKind::KwProtected) ||
        check(TokenKind::KwInternal))
        i = 1;
    return peek(i).kind == TokenKind::Identifier && peek(i).lexeme == "affinity" &&
           peek(i + 1).kind == TokenKind::Identifier &&
           (peek(i + 1).lexeme == "hot" || peek(i + 1).lexeme == "cold");
}

// spec 32.9: `public affinity hot { float x; float y; }` -- the fields inside are ordinary fields,
// tagged with their affinity. The block's visibility (if any) is the default for fields that state none.
void Parser::parseAffinityBlock(ast::ClassDecl& c) {
    const std::string vis = parseVisibilityOpt();
    advance();                                   // 'affinity'
    const std::string kind = current().lexeme;   // 'hot' or 'cold'
    advance();
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        ast::MemberPtr m = parseMember(/*inInterface=*/false);
        auto* f = dynamic_cast<ast::FieldDecl*>(m.get());
        if (f == nullptr) fail("an 'affinity' block holds only fields (spec 32.9)", m->loc);
        f->affinity = kind;
        if (f->visibility.empty()) f->visibility = vis;
        c.members.push_back(std::move(m));
        for (auto& em : extraMembers_) c.members.push_back(std::move(em));
        extraMembers_.clear();
    }
    expect(TokenKind::RBrace, "'}'");
}

ast::MemberPtr Parser::parseMember(bool inInterface) {
    std::vector<ast::AnnotationUse> anns = parseAnnotationUsesOpt();  // leading `[Name(...)]` (spec 14.3)
    std::string visibility = parseVisibilityOpt();
    bool isStatic = false;
    bool isMutable = false;
    bool isAbstract = false;
    bool isOverride = false;
    bool isFinal = false;
    bool isPersistent = false;
    bool isEternal = false;
    bool isTransient = false;
    bool isDeprecated = false;   // spec 14.2
    bool isVolatile = false;
    bool isComptime = false;
    bool isLazy = false;
    bool isAsync = false;
    bool isExternal = false;
    bool isMovableField = false;
    bool isUniqueField = false;
    bool isExtern = false;          // spec 26: extern C method member
    std::string externConvention;
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
        if (!isDeprecated && check(TokenKind::KwDeprecated)) {  // spec 14.2: warn at every use
            advance();
            isDeprecated = true;
            continue;
        }
        // `in region X` field placement (spec 18.7): places the field's storage in a region. Accepted;
        // the field keeps its normal (longer-lived) storage, which is safe for an in-process persistent
        // -- the region placement is a lifetime optimization, not a correctness requirement.
        if (check(TokenKind::KwIn) && peek(1).kind == TokenKind::KwRegion) {
            advance();  // 'in'
            advance();  // 'region'
            expect(TokenKind::Identifier, "the region name after 'in region'");
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
        if (!isAsync && check(TokenKind::KwAsync)) {
            advance();
            isAsync = true;
            continue;
        }
        if (!isExternal && check(TokenKind::KwExternal)) {
            advance();
            isExternal = true;
            continue;
        }
        if (!isMovableField && check(TokenKind::KwMovable)) {  // spec 19.9: field-level ownership
            advance();
            isMovableField = true;
            continue;
        }
        if (!isUniqueField && check(TokenKind::KwUnique)) {
            advance();
            isUniqueField = true;
            continue;
        }
        if (!isExtern && check(TokenKind::KwExtern)) {  // spec 26: extern <conv> [static] method ...
            advance();
            if (match(TokenKind::KwCdecl)) externConvention = "cdecl";
            else if (match(TokenKind::KwStdcall)) externConvention = "stdcall";
            else if (match(TokenKind::KwFastcall)) externConvention = "fastcall";
            else fail("expected a calling convention (cdecl/stdcall/fastcall) after 'extern'",
                      current().loc);
            isExtern = true;
            continue;
        }
        break;
    }
    ast::MemberPtr member;
    // spec 32.6: `bidirectional T name { src to name: expr; name to src: expr; }` -- a property that
    // converts both ways over a backing field. `bidirectional` is a soft keyword (still usable as a name).
    if (check(TokenKind::Identifier) && current().lexeme == "bidirectional") {
        advance();
        return parseBidirectional(std::move(visibility), isStatic);
    }
    if (check(TokenKind::KwMethod)) {
        member = parseMethod(std::move(visibility), isStatic, isAbstract, isOverride, isFinal,
                             inInterface, isComptime, isAsync, isVolatile, isExtern,
                             std::move(externConvention), isDeprecated);
    } else if (check(TokenKind::KwConstructor)) {
        member = parseConstructor(std::move(visibility));
    } else if (check(TokenKind::KwDestructor)) {
        member = parseDestructor(std::move(visibility));
    } else if (check(TokenKind::KwOperator)) {
        member = parseOperator(std::move(visibility));
    } else if (check(TokenKind::KwLiteral)) {  // a literal suffix is a member of its result type's class
        member = parseLiteralMember(std::move(visibility), isComptime);
    } else if (check(TokenKind::KwFixed)) {  // a compile-time constant as a static class member
        member = parseConstMember(std::move(visibility));
    } else {
        // Otherwise it is a field:  <type> <name> ;
        member = parseField(std::move(visibility), isStatic, isMutable, isPersistent, isEternal,
                            isTransient, isVolatile, isLazy, isExternal, isMovableField,
                            isUniqueField, isAbstract, isOverride, isFinal);
    }
    if (!anns.empty()) {  // attach leading annotations to the declaration they precede
        if (auto* m = dynamic_cast<ast::MethodDecl*>(member.get())) m->annotations = std::move(anns);
        else if (auto* f = dynamic_cast<ast::FieldDecl*>(member.get())) f->annotations = std::move(anns);
    }
    return member;
}

// `operator <op> (params) returns T { body }` (spec 6.5). Modeled as a method
// named "operator<op>" (e.g. "operator+"), reusing the whole method pipeline.
std::unique_ptr<ast::MethodDecl> Parser::parseOperator(std::string visibility) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    expect(TokenKind::KwOperator, "'operator'");
    // Conversion operator (spec 6.6): `operator [explicit|implicit] cast<T>() returns T`. Modeled as
    // a method named "operator cast$T", dispatched by cast<T>(obj).
    if ((check(TokenKind::Identifier) &&
         (current().lexeme == "explicit" || current().lexeme == "implicit")) ||
        check(TokenKind::KwCast)) {
        if (check(TokenKind::Identifier)) advance();  // explicit / implicit (both behave as cast<T>)
        expect(TokenKind::KwCast, "'cast' in a conversion operator");
        expect(TokenKind::Lt, "'<' after 'cast'");
        const ast::TypeRef target = parseTypeRef();
        expect(TokenKind::Gt, "'>' to close the conversion target");
        m->name = "operator cast$" + target.name;  // target.name is the raw (unqualified) type name
        expect(TokenKind::LParen, "'(' after the conversion target");
        expect(TokenKind::RParen, "')' (a conversion operator takes no parameters)");
        expect(TokenKind::KwReturns, "'returns'");
        m->returnType = parseTypeRef();
        currentMethodReturnType_ = m->returnType;
        if (headerMode_ && check(TokenKind::Semicolon)) advance();  // .ldh signature: body is in the .ldb
        else m->body = parseBlock();
        return m;
    }
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
    if (headerMode_ && check(TokenKind::Semicolon)) advance();  // .ldh signature: body is in the .ldb
    else m->body = parseBlock();
    return m;
}

std::unique_ptr<ast::MethodDecl> Parser::parseMethod(std::string visibility, bool isStatic,
                                                     bool isAbstract, bool isOverride, bool isFinal,
                                                     bool inInterface, bool isComptime,
                                                     bool isAsync, bool isVolatile, bool isExtern,
                                                     std::string externConvention, bool isDeprecated) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    m->isStatic = isStatic;
    m->isExtern = isExtern;
    m->externConvention = std::move(externConvention);
    // An interface method is abstract unless it provides a default body (spec 9); decided below.
    m->isAbstract = isAbstract;
    m->isOverride = isOverride;
    m->isFinal = isFinal;
    m->isComptime = isComptime;  // `comptime` prefix (spec 37.4); suffix handled below
    m->isAsync = isAsync;
    m->isVolatile = isVolatile;  // spec 37.5: always executed; never inlined/elided
    m->isDeprecated = isDeprecated;  // spec 14.2: warn at every call site
    expect(TokenKind::KwMethod, "'method'");
    m->name = expectMemberName("the method name");
    // Generic method type parameters: method identity<T>(...) (spec 15). Each
    // (method-name, type-args) call is monomorphized into a concrete method.
    if (match(TokenKind::Lt)) {
        do {
            const std::string tp = expect(TokenKind::Identifier, "a type parameter").lexeme;
            m->typeParams.push_back(tp);
            // Constraint (spec 15.2): `<T extends Numeric>` / `<T implements Comparable<T>>`, exactly like
            // the class-level form, type arguments included.
            if (match(TokenKind::KwExtends) || match(TokenKind::KwImplements))
                m->typeParamBounds.push_back({tp, parseBoundName()});
        } while (match(TokenKind::Comma));
        expect(TokenKind::Gt, "'>' to close type parameters");
    }
    expect(TokenKind::LParen, "'('");
    m->params = parseParams(m->isExtern ? &m->isVariadic : nullptr);
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
    // signature and the body, no separators. `old(...)` is recognized inside `ensures`.
    while (check(TokenKind::KwRequires) || check(TokenKind::KwEnsures)) {
        const bool isReq = check(TokenKind::KwRequires);
        advance();
        parsingEnsures_ = !isReq;
        (isReq ? m->requiresClauses : m->ensuresClauses).push_back(parseExpression());
        parsingEnsures_ = false;
    }
    if (headerMode_ && !inInterface && check(TokenKind::Semicolon)) {
        // A .ldh signature: no body (the implementation is in the .ldb). Not abstract -- the bundle
        // defines it; codegen for the importing program emits an external declaration. Interface
        // signatures fall through to the interface branch below (they stay abstract).
        advance();
    } else if (inInterface) {
        // `;` => an abstract signature; `{ ... }` => a default method with a body (spec 9).
        if (check(TokenKind::Semicolon)) {
            m->isAbstract = true;
            advance();
        } else {
            m->body = parseBlock();
        }
    } else if (m->isAbstract) {
        expect(TokenKind::Semicolon, "';' (an abstract method has no body)");
    } else if (m->isExtern) {
        expect(TokenKind::Semicolon, "';' (an extern method has no body; it links to a C symbol)");
    } else {
        m->body = parseBlock();
    }
    return m;
}

ast::MemberPtr Parser::parseField(std::string visibility, bool isStatic, bool isMutable,
                                  bool isPersistent, bool isEternal, bool isTransient,
                                  bool isVolatile, bool isLazy, bool isExternal, bool isMovable,
                                  bool isUnique, bool isAbstract, bool isOverride, bool isFinal) {
    const SourceLocation loc = current().loc;
    ast::TypeRef type = parseTypeRef();
    const std::string name = expect(TokenKind::Identifier, "a field name").lexeme;
    // A `{` here makes it a property (spec 8.4) rather than a plain field. Inheritance modifiers
    // (override/abstract/final) apply to the property's synthesized accessors, not a plain field.
    if (check(TokenKind::LBrace)) {
        return parseProperty(std::move(visibility), isStatic, std::move(type), name, loc, isAbstract,
                             isOverride, isFinal);
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
    f->isExternal = isExternal;
    f->isMovable = isMovable;
    f->isUnique = isUnique;
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
// Bidirectional property (spec 32.6):
//
//   public bidirectional double fahrenheit {
//       celsius to fahrenheit: celsius * 9.0 / 5.0 + 32.0;   // read:  compute it FROM the field
//       fahrenheit to celsius: (fahrenheit - 32.0) * 5.0 / 9.0;   // write: compute the field FROM it
//   }
//
// It desugars into the existing property machinery: a computed getter `fahrenheit` (isProperty) and a
// setter `fahrenheit$set(value)` that assigns the backing field. Inside the two expressions the field and
// the property are written as bare names; they are rewritten on the token stream before parsing --
// the field becomes `this.<field>` and, in the write direction, the property name becomes `value`.
ast::MemberPtr Parser::parseBidirectional(std::string visibility, bool isStatic) {
    const SourceLocation loc = current().loc;
    ast::TypeRef type = parseTypeRef();
    const std::string name = expect(TokenKind::Identifier, "the property name").lexeme;
    expect(TokenKind::LBrace, "'{' to open a bidirectional property");

    std::string field;                 // the backing field both directions talk about
    std::vector<Token> readToks;       // tokens of the read expression  (field -> property)
    std::vector<Token> writeToks;      // tokens of the write expression (property -> field)
    bool sawRead = false;
    bool sawWrite = false;
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        const std::string from = expect(TokenKind::Identifier, "a name before 'to'").lexeme;
        if (!(check(TokenKind::Identifier) && current().lexeme == "to"))
            fail("expected 'to' in a bidirectional property direction", current().loc);
        advance();  // 'to'
        const std::string to = expect(TokenKind::Identifier, "a name after 'to'").lexeme;
        expect(TokenKind::Colon, "':' after the direction");
        std::vector<Token> body;
        while (!check(TokenKind::Semicolon) && !check(TokenKind::EndOfFile)) body.push_back(advance());
        expect(TokenKind::Semicolon, "';' to end a bidirectional direction");
        if (to == name) {          // `<field> to <property>`: the READ direction
            field = from;
            readToks = std::move(body);
            sawRead = true;
        } else if (from == name) {  // `<property> to <field>`: the WRITE direction
            field = to;
            writeToks = std::move(body);
            sawWrite = true;
        } else {
            fail("a bidirectional direction must mention the property '" + name + "'", loc);
        }
    }
    expect(TokenKind::RBrace, "'}' to close a bidirectional property");
    if (!sawRead || !sawWrite)
        fail("a bidirectional property needs both directions ('field to " + name + "' and '" + name +
                 " to field')",
             loc);

    // Rewrite the bare names on the token stream, then parse each expression with a sub-parser.
    auto rewrite = [&](std::vector<Token> toks, bool writeDir) {
        std::vector<Token> out;
        for (Token& t : toks) {
            if (t.kind == TokenKind::Identifier && t.lexeme == field) {
                Token th = t;
                th.kind = TokenKind::KwThis;
                th.lexeme = "this";
                Token dot = t;
                dot.kind = TokenKind::Dot;
                dot.lexeme = ".";
                out.push_back(th);
                out.push_back(dot);
                out.push_back(t);
                continue;
            }
            if (writeDir && t.kind == TokenKind::Identifier && t.lexeme == name) {
                t.lexeme = "value";  // the incoming value in the setter
            }
            out.push_back(t);
        }
        Token eof;
        eof.kind = TokenKind::EndOfFile;
        eof.loc = loc;
        out.push_back(eof);
        Parser sub(std::move(out), file_);
        ast::ExprPtr e = sub.parseExpression();
        for (const ParseError& se : sub.errors()) errors_.push_back(se);
        return e;
    };
    ast::ExprPtr readExpr = rewrite(std::move(readToks), /*writeDir=*/false);
    ast::ExprPtr writeExpr = rewrite(std::move(writeToks), /*writeDir=*/true);
    if (readExpr == nullptr || writeExpr == nullptr)
        fail("invalid expression in bidirectional property '" + name + "'", loc);

    // setter: `method name$set(T value) { this.<field> = <writeExpr>; }`
    auto setter = std::make_unique<ast::MethodDecl>();
    setter->loc = loc;
    setter->visibility = visibility;
    setter->isStatic = isStatic;
    setter->name = name + "$set";
    ast::Param p;
    p.loc = loc;
    p.type = type;
    p.name = "value";
    setter->params.push_back(std::move(p));
    setter->returnType = ast::TypeRef{};
    setter->returnType.name = "void";
    {
        auto target = std::make_unique<ast::MemberExpr>();
        target->loc = loc;
        auto self = std::make_unique<ast::IdentifierExpr>();   // `this` is an identifier in the AST
        self->loc = loc;
        self->name = "this";
        target->object = std::move(self);
        target->member = field;
        auto assign = std::make_unique<ast::AssignStmt>();
        assign->loc = loc;
        assign->target = std::move(target);
        assign->value = std::move(writeExpr);
        setter->body.statements.push_back(std::move(assign));
    }
    extraMembers_.push_back(std::move(setter));

    // getter: `method name() returns T { return <readExpr>; }` (a computed property)
    auto getter = std::make_unique<ast::MethodDecl>();
    getter->loc = loc;
    getter->visibility = std::move(visibility);
    getter->isStatic = isStatic;
    getter->isProperty = true;
    getter->name = name;
    getter->returnType = type;
    getter->propertySetter = name + "$set";
    auto ret = std::make_unique<ast::ReturnStmt>();
    ret->loc = loc;
    ret->value = std::move(readExpr);
    getter->body.statements.push_back(std::move(ret));
    return getter;
}

ast::MemberPtr Parser::parseProperty(std::string visibility, bool isStatic, ast::TypeRef type,
                                     const std::string& name, SourceLocation loc, bool isAbstract,
                                     bool isOverride, bool isFinal) {
    expect(TokenKind::LBrace, "'{'");
    bool hasSet = false;
    bool getHasBody = false;
    bool setHasBody = false;
    ast::Block getBody;
    ast::Block setBody;
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
            hasSet = true;
            if (check(TokenKind::LBrace)) {
                setBody = parseBlock();
                setHasBody = true;
            } else {
                expect(TokenKind::Semicolon, "';'");
            }
        } else if (accessor == "init") {
            expect(TokenKind::Semicolon, "';'");  // init-only -> immutable
        } else {
            fail("expected 'get', 'set' or 'init' in a property, found '" + accessor + "'", loc);
        }
    }
    expect(TokenKind::RBrace, "'}'");

    // A property with BOTH a custom get and a custom set (spec 8.4): the property has no backing field
    // of its own (the accessors manage their own storage). Emit a computed getter method `name` and a
    // setter method `name$set`; reads call the getter, `obj.name = v` routes to the setter.
    if (setHasBody && getHasBody) {
        auto setter = std::make_unique<ast::MethodDecl>();
        setter->loc = loc;
        setter->visibility = visibility;
        setter->isStatic = isStatic;
        setter->name = name + "$set";
        ast::Param sp;
        sp.loc = loc;
        sp.type = type;
        sp.name = "value";
        setter->params.push_back(std::move(sp));
        setter->returnType = ast::TypeRef{};
        setter->returnType.name = "void";
        setter->body = std::move(setBody);
        setter->isAbstract = isAbstract;
        setter->isOverride = isOverride;
        setter->isFinal = isFinal;
        extraMembers_.push_back(std::move(setter));

        auto getter = std::make_unique<ast::MethodDecl>();
        getter->loc = loc;
        getter->visibility = std::move(visibility);
        getter->isStatic = isStatic;
        getter->isProperty = true;
        getter->isAbstract = isAbstract;
        getter->isOverride = isOverride;  // an overridden property dispatches through the vtable
        getter->isFinal = isFinal;
        getter->name = name;
        getter->returnType = std::move(type);
        getter->body = std::move(getBody);
        getter->propertySetter = name + "$set";  // assignment to the property routes here
        return getter;
    }
    // A custom set body (spec 8.4): the field is the backing store; `obj.name` reads it directly and
    // `obj.name = v` runs the setter, which sees `value` and writes `this.name`.
    if (setHasBody) {
        auto setter = std::make_unique<ast::MethodDecl>();
        setter->loc = loc;
        setter->visibility = visibility;
        setter->isStatic = isStatic;
        setter->name = name + "$set";
        ast::Param p;
        p.loc = loc;
        p.type = type;       // `value` has the property's type
        p.name = "value";
        setter->params.push_back(std::move(p));
        setter->returnType = ast::TypeRef{};
        setter->returnType.name = "void";
        setter->body = std::move(setBody);
        setter->isAbstract = isAbstract;
        setter->isOverride = isOverride;
        setter->isFinal = isFinal;
        extraMembers_.push_back(std::move(setter));

        auto f = std::make_unique<ast::FieldDecl>();
        f->loc = loc;
        f->visibility = std::move(visibility);
        f->isStatic = isStatic;
        f->isMutable = true;            // the setter writes it
        f->type = std::move(type);
        f->name = name;
        f->propertySetter = name + "$set";  // assignment to the property routes through this setter
        return f;
    }

    if (getHasBody) {  // computed get-only property -> a getter method
        auto m = std::make_unique<ast::MethodDecl>();
        m->loc = loc;
        m->visibility = std::move(visibility);
        m->isStatic = isStatic;
        m->isProperty = true;
        m->isAbstract = isAbstract;
        m->isOverride = isOverride;  // an overridden property dispatches through the vtable
        m->isFinal = isFinal;
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
        parsingEnsures_ = !isReq;
        (isReq ? c->requiresClauses : c->ensuresClauses).push_back(parseExpression());
        parsingEnsures_ = false;
    }
    if (headerMode_ && check(TokenKind::Semicolon)) {
        advance();  // a .ldh constructor signature: no body (the .ldb defines it)
        return c;
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

std::vector<ast::Param> Parser::parseParams(bool* variadic) {
    std::vector<ast::Param> params;
    if (check(TokenKind::RParen)) return params;
    do {
        // A trailing `...` (lexed as '..' then '.') marks a variadic extern (spec 26); only accepted
        // when the caller opts in via `variadic`.
        if (variadic != nullptr && check(TokenKind::DotDot)) {
            advance();
            match(TokenKind::Dot);  // the third '.'
            *variadic = true;
            break;
        }
        ast::Param p;
        p.loc = current().loc;
        p.isComptime = match(TokenKind::KwComptime);  // spec 32.4: `comptime T p` -- const argument
        // spec 22.4: `requires named T p` -- the caller must pass this argument by name. `named` is a soft
        // keyword here (it stays usable as an identifier everywhere else).
        if (check(TokenKind::KwRequires) && peek(1).kind == TokenKind::Identifier && peek(1).lexeme == "named") {
            advance();  // requires
            advance();  // named
            p.requiresNamed = true;
        }
        p.type = parseTypeRef();
        p.name = expect(TokenKind::Identifier, "a parameter name").lexeme;
        params.push_back(std::move(p));
    } while (match(TokenKind::Comma));
    return params;
}

// The argument list of a call, up to (but not consuming) the ')'. Supports named arguments (spec 22.4):
// `name: expr`. A bare `expr` is positional and records an empty name. A ternary `cond ? a : b` cannot be
// confused with one, because a named argument is exactly an identifier immediately followed by ':'.
void Parser::parseCallArgs(ast::CallExpr& call) {
    if (check(TokenKind::RParen)) return;
    do {
        std::string name;
        if (check(TokenKind::Identifier) && peek(1).kind == TokenKind::Colon) {
            name = current().lexeme;
            advance();  // the name
            advance();  // ':'
        }
        call.args.push_back(parseExpression());
        call.argNames.push_back(std::move(name));
    } while (match(TokenKind::Comma));
}

ast::TypeRef Parser::parseTypeRef() {
    ast::TypeRef t;
    const Token& tok = current();
    t.loc = tok.loc;
    // `move T` (spec 19.6): an ownership-transfer annotation on a parameter or return type. It is
    // the same type, just transferred instead of copied, so it is transparent to type checking.
    if (tok.kind == TokenKind::KwMove) {
        advance();
        ast::TypeRef inner = parseTypeRef();
        inner.isMove = true;
        return inner;
    }
    // `nullable T` (spec 3.7): a type modifier; parse the underlying type and mark it nullable.
    if (tok.kind == TokenKind::KwNullable) {
        advance();
        ast::TypeRef inner = parseTypeRef();
        inner.isNullable = true;
        inner.loc = t.loc;
        return inner;
    }
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
    // funcptr<Ret, Params...> -- a bare C function pointer (no closure environment), for dynamic FFI:
    // an address obtained at runtime (e.g. wglGetProcAddress / GetProcAddress) cast to this type and
    // called with the plain C ABI. `funcptr` is a contextual type name (only special before '<'), so it
    // is not a reserved word. The canonical string, like function<>, is not generic-mangled.
    if (tok.kind == TokenKind::Identifier && tok.lexeme == "funcptr" && peek(1).kind == TokenKind::Lt) {
        advance();
        std::string nm = "funcptr<";
        expect(TokenKind::Lt, "'<' after funcptr");
        std::size_t fn = 0;
        do {
            ast::TypeRef arg = parseTypeRef();
            nm += (fn++ ? "," : "") + ast::canonicalType(arg);
        } while (match(TokenKind::Comma));
        if (current().kind == TokenKind::Shr) {
            tokens_[pos_].kind = TokenKind::Gt;
        } else {
            expect(TokenKind::Gt, "'>' to close funcptr type");
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
    while (match(TokenKind::LBracket)) {  // T[], T[][], ... -- multi-dimensional (spec 25)
        expect(TokenKind::RBracket, "']'");
        t.isArray = true;
        t.arrayDims++;
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
    // The `*` picks the representation (spec 21, value form): `Result<T,E>` (no star) builds a value
    // tagged union (location "value" -- no heap, no delete); `Result<T,E>*` keeps the boxed heap class.
    // A payload that does not fit the value form's 64-bit slot stays boxed for now: a pointer/ref (also
    // mangling-ambiguous), Decimal (i128), or a tuple (aggregate). Sized payloads are deferred.
    bool boxedPayload = false;
    for (const std::string& a : expected.typeArgs)
        if (a.find('*') != std::string::npos || a.find('&') != std::string::npos ||
            a.find("Decimal") != std::string::npos || a.find('(') != std::string::npos)
            boxedPayload = true;
    nw->location = (expected.isPointer || boxedPayload) ? "heap" : "value";
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
    if (check(TokenKind::KwComefrom)) {  // `comefrom name;` -- same method only (spec 7.10)
        auto c = std::make_unique<ast::ComefromStmt>();
        c->loc = current().loc;
        advance();  // 'comefrom'
        parseLabelRef(c->name);
        expect(TokenKind::Semicolon, "';'");
        return c;
    }
    if (check(TokenKind::KwGoto)) {  // `goto label;` (same method) or `goto <addr>;` (FFI, spec 7.9)
        auto g = std::make_unique<ast::GotoStmt>();
        g->loc = current().loc;
        advance();  // 'goto'
        if (check(TokenKind::Identifier))
            parseLabelRef(g->name);          // a label or an extern function name
        else
            g->address = parseExpression();  // raw address form, e.g. `goto 0x1000;`
        expect(TokenKind::Semicolon, "';'");
        return g;
    }
    if (check(TokenKind::KwUnimport) || check(TokenKind::KwReimport) ||
        check(TokenKind::KwImport)) {  // spec 30, 30.18
        // Look past the (dotted) target name for the `expecting` keyword, which selects the
        // challenge-response validation forms (spec 30.18).
        int k = 1;
        if (peek(k).kind == TokenKind::Identifier) {
            ++k;
            while (peek(k).kind == TokenKind::Dot && peek(k + 1).kind == TokenKind::Identifier) k += 2;
        }
        const bool validated = peek(k).kind == TokenKind::KwExpecting;

        // `unimport X expecting { ... }` as a bare statement: an expression statement.
        if (check(TokenKind::KwUnimport) && validated) {
            auto es = std::make_unique<ast::ExprStmt>();
            es->loc = current().loc;
            es->expr = parseUnimportExpr();
            expect(TokenKind::Semicolon, "';'");
            return es;
        }
        // `import/reimport X expecting a [using ...] { ... } onFailure { ... };` (spec 30.18).
        if ((check(TokenKind::KwReimport) || check(TokenKind::KwImport)) && validated) {
            auto r = std::make_unique<ast::ReimportValidateStmt>();
            r->loc = current().loc;
            advance();  // 'import' / 'reimport'
            r->target = expect(TokenKind::Identifier, "a type name").lexeme;
            while (match(TokenKind::Dot))
                r->target += "." + expect(TokenKind::Identifier, "a name").lexeme;
            expect(TokenKind::KwExpecting, "'expecting'");
            r->expected = parseExpression();  // the value produced by the matching unimport
            r->expecting = parseExpectingTail(r->usingVars);
            expect(TokenKind::KwOnFailure, "'onFailure' (mandatory for a validated reimport)");
            r->onFailure = std::make_unique<ast::Block>(parseBlock());
            expect(TokenKind::Semicolon, "';'");
            return r;
        }
        if (check(TokenKind::KwImport)) {
            fail("'import' here must be a validated reimport: "
                 "import X expecting a { ... } onFailure { ... };", current().loc);
        }

        auto u = std::make_unique<ast::UnimportStmt>();
        u->loc = current().loc;
        u->isReimport = match(TokenKind::KwReimport);
        if (!u->isReimport) advance();  // 'unimport'
        // Granularity (spec 30.1): `namespace N` / `bundle B` unimport a whole namespace or bundle;
        // `interface`/`enum` just name an individual type (unimported like a class).
        if (match(TokenKind::KwNamespace)) u->granularity = 1;
        else if (match(TokenKind::KwBundle)) u->granularity = 2;
        else { match(TokenKind::KwInterface); match(TokenKind::KwEnum); }  // optional type-kind keyword
        u->target = expect(TokenKind::Identifier, "a type/namespace/bundle name to (un)import").lexeme;
        // Accept (and ignore) trailing modifiers (spec 30.6): a bare `force`, or `timeout(<duration>)`
        // whose argument is parsed and discarded (unimport/reimport is in-process, so the timeout is a
        // no-op). Dotted names extend the target.
        while (match(TokenKind::Dot)) u->target += "." + expect(TokenKind::Identifier, "a name").lexeme;
        // `unimport bundle B from program P` (spec 30.1): the program name is accepted (the bundle is
        // resolved locally). `from` is a soft keyword.
        if (u->granularity == 2 && check(TokenKind::Identifier) && current().lexeme == "from") {
            advance();  // 'from'
            expect(TokenKind::KwProgram, "'program' after 'from'");
            expect(TokenKind::Identifier, "the program name");
        }
        while (check(TokenKind::Identifier)) {
            advance();  // modifier name, e.g. `force` or `timeout`
            if (match(TokenKind::LParen)) {  // e.g. timeout(milliseconds(5000)) -- skip balanced parens
                int depth = 1;
                while (depth > 0 && !check(TokenKind::EndOfFile)) {
                    if (match(TokenKind::LParen)) { depth++; }
                    else if (match(TokenKind::RParen)) { depth--; }
                    else { advance(); }
                }
            }
        }
        expect(TokenKind::Semicolon, "';'");
        return u;
    }
    if (check(TokenKind::KwAbstainfrom) || check(TokenKind::KwReinstate)) {  // spec 7.11
        auto a = std::make_unique<ast::AbstainfromStmt>();
        a->loc = current().loc;
        a->isReinstate = match(TokenKind::KwReinstate);
        if (!a->isReinstate) advance();  // 'abstainfrom'
        parseLabelRef(a->name);  // same method only (spec 7.11)
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
    // `comptime <type> name = <constexpr>;` (spec 28.3): a local computed at compile time.
    if (check(TokenKind::KwComptime)) {
        advance();  // consume 'comptime'
        auto vd = parseVarDeclCore();
        vd->isComptime = true;
        expect(TokenKind::Semicolon, "';'");
        return vd;
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
    if (check(TokenKind::KwYield)) {  // `yield expr;` -- value of a match-expression block arm (16.2)
        auto y = std::make_unique<ast::YieldStmt>();
        y->loc = current().loc;
        advance();
        y->value = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        return y;
    }
    if (check(TokenKind::AsmBlock)) {  // `asm("arch") { raw }` inline assembly (spec issue 1)
        auto a = std::make_unique<ast::AsmStmt>();
        a->loc = current().loc;
        const std::string& lex = current().lexeme;  // arch + '\x1f' + body
        const std::size_t sep = lex.find('\x1f');
        a->arch = sep == std::string::npos ? std::string() : lex.substr(0, sep);
        a->body = sep == std::string::npos ? lex : lex.substr(sep + 1);
        advance();
        return a;
    }
    // `cascade [(params)] <operation>` (spec 37.1): propagate an operation through the object's
    // owned graph. Supported operations: delete, move (spec 19.8). Others are added below.
    if (check(TokenKind::KwCascade)) {
        const SourceLocation cloc = current().loc;
        advance();  // 'cascade'
        ast::CascadeParams params = parseCascadeParamsOpt();
        // `cascade move tree from region A to region B [leaving persistents];` (spec 19.8).
        if (check(TokenKind::KwMove)) {
            advance();  // 'move'
            auto cm = std::make_unique<ast::CascadeMoveStmt>();
            cm->loc = cloc;
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
        if (check(TokenKind::KwDelete)) {
            advance();  // 'delete'
            auto del = std::make_unique<ast::DeleteStmt>();
            del->loc = cloc;
            del->isCascade = true;  // spec 37.1
            del->cascade = std::move(params);
            del->target = parseExpression();
            expect(TokenKind::Semicolon, "';'");
            return del;
        }
        // `cascade release persistent X` (spec 37.1): release every persistent in X's owned graph.
        if (check(TokenKind::KwRelease)) {
            advance();  // 'release'
            auto cs = std::make_unique<ast::CascadeStmt>();
            cs->loc = cloc;
            cs->op = ast::CascadeOpKind::Release;
            cs->params = std::move(params);
            match(TokenKind::KwPersistent);  // optional 'persistent' keyword
            cs->target = parseExpression();
            expect(TokenKind::Semicolon, "';'");
            return cs;
        }
        // `cascade unimport X` (spec 37.1): unimport X and its subclasses and monomorphizations.
        if (check(TokenKind::KwUnimport)) {
            advance();  // 'unimport'
            auto cs = std::make_unique<ast::CascadeStmt>();
            cs->loc = cloc;
            cs->op = ast::CascadeOpKind::Unimport;
            cs->params = std::move(params);
            cs->typeName = expect(TokenKind::Identifier, "the class name to unimport").lexeme;
            expect(TokenKind::Semicolon, "';'");
            return cs;
        }
        // `cascade clone X into Y` (spec 37.1): deep-clone X's owned graph into Y. `clone`/`into`
        // are soft keywords here.
        if (check(TokenKind::Identifier) && current().lexeme == "clone") {
            advance();  // 'clone'
            auto cs = std::make_unique<ast::CascadeStmt>();
            cs->loc = cloc;
            cs->op = ast::CascadeOpKind::Clone;
            cs->params = std::move(params);
            cs->target = parseExpression();
            if (!(check(TokenKind::Identifier) && current().lexeme == "into"))
                fail("expected 'into' in cascade clone", current().loc);
            advance();  // 'into'
            cs->dest = parseExpression();
            expect(TokenKind::Semicolon, "';'");
            return cs;
        }
        // `cascade validate(X)` and `cascade [System.IO.]Console.println(X)` (spec 37.1):
        // `validate` and `println` are soft keywords recognized only after `cascade`.
        if (check(TokenKind::Identifier) && current().lexeme == "validate") {
            advance();  // 'validate'
            auto cs = std::make_unique<ast::CascadeStmt>();
            cs->loc = cloc;
            cs->op = ast::CascadeOpKind::Validate;
            cs->params = std::move(params);
            expect(TokenKind::LParen, "'(' after 'validate'");
            cs->target = parseExpression();
            expect(TokenKind::RParen, "')' to close 'validate'");
            expect(TokenKind::Semicolon, "';'");
            return cs;
        }
        if (check(TokenKind::Identifier)) {
            // A println form: an optional dotted prefix (Console, System.IO.Console, ...) then
            // `println(X)`. The last name before `(` must be `println`.
            std::string last = current().lexeme;
            advance();
            while (match(TokenKind::Dot))
                last = expect(TokenKind::Identifier, "a name after '.'").lexeme;
            if (last != "println")
                fail("this operation does not support 'cascade' (spec 37.1)", cloc);
            auto cs = std::make_unique<ast::CascadeStmt>();
            cs->loc = cloc;
            cs->op = ast::CascadeOpKind::Println;
            cs->params = std::move(params);
            expect(TokenKind::LParen, "'(' after 'println'");
            cs->target = parseExpression();
            expect(TokenKind::RParen, "')' to close 'println'");
            expect(TokenKind::Semicolon, "';'");
            return cs;
        }
        fail("this operation does not support 'cascade' (spec 37.1)", current().loc);
    }
    if (check(TokenKind::KwDelete)) {
        auto del = std::make_unique<ast::DeleteStmt>();
        del->loc = current().loc;
        expect(TokenKind::KwDelete, "'delete'");
        // Parse a delete target plus an optional `of region X` suffix (spec 17.6): X disambiguates
        // same-named variables across regions. A region-allocated object is destroyed in place (its
        // destructor runs; the region reclaims the memory on release), so this behaves like
        // `from region` -- set fromRegion so codegen runs the destructor without free()ing the arena.
        auto parseDeleteTarget = [&]() -> ast::ExprPtr {
            ast::ExprPtr t = parseExpression();
            if (match(TokenKind::KwOf)) {
                expect(TokenKind::KwRegion, "'region' after 'of'");
                del->fromRegion = expect(TokenKind::Identifier, "the region name").lexeme;
            }
            return t;
        };
        del->target = parseDeleteTarget();
        // `delete a, b, c;` frees several objects in one statement; any placement suffix applies to all.
        while (match(TokenKind::Comma)) del->moreTargets.push_back(parseDeleteTarget());
        // Optional placement suffix (spec 17.7 / 12.x): `from heap` is explicit; `from region R`
        // runs the destructor but leaves the memory for the region to reclaim on release. `from`
        // and `heap` are soft keywords (identifiers); only `region` is reserved.
        if (check(TokenKind::Identifier) && current().lexeme == "from") {
            advance();  // 'from'
            if (match(TokenKind::KwRegion))
                del->fromRegion = expect(TokenKind::Identifier, "the region name").lexeme;
            else if (check(TokenKind::Identifier) && current().lexeme == "heap") {
                advance();  // 'heap'
                del->fromHeap = true;
            } else {
                fail("expected 'heap' or 'region <name>' after 'from'", current().loc);
            }
        }
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
    // `rollback region R to m;` (spec 17, stack flavor): destruct everything above the checkpoint and
    // rewind. `rollback` is a soft keyword -- only this statement when directly followed by `region`.
    if (check(TokenKind::Identifier) && current().lexeme == "rollback" &&
        peek(1).kind == TokenKind::KwRegion) {
        auto rb = std::make_unique<ast::RollbackStmt>();
        rb->loc = current().loc;
        advance();  // 'rollback'
        advance();  // 'region'
        rb->region = expect(TokenKind::Identifier, "the region name after 'rollback region'").lexeme;
        if (!(check(TokenKind::Identifier) && current().lexeme == "to"))
            fail("expected 'to <checkpoint>' after 'rollback region <name>' (spec 17)", current().loc);
        advance();  // 'to'
        rb->checkpoint = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        return rb;
    }
    if (check(TokenKind::KwDefer)) {
        return parseDefer();
    }
    if (check(TokenKind::KwUsing)) {
        return parseUsing();
    }
    if (check(TokenKind::KwSynchronized)) {
        return parseSynchronized();
    }
    // Tuple destructuring `(int q, int r) = expr;` (spec 22.5).
    if (looksLikeTupleDestructuring()) {
        return parseTupleDecl();
    }
    // A bare `extract X from region R;` -- parse it as an expression statement (not a `ClassName name`
    // declaration) so the analyzer can reject the unbound extract result (LDP3-1720).
    if (looksLikeExtractStmt()) {
        return parseExprStatement();
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
        check(TokenKind::KwNullable) ||  // spec 3.7: `nullable T x` local
        isTypeKeyword(current().kind) || classVarDecl || looksLikeGenericVarDecl() ||
        looksLikeQualifiedVarDecl() || looksLikeFlavoredRegionDecl()) {
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
        } else if (k != TokenKind::Identifier && k != TokenKind::Comma && k != TokenKind::Star &&
                   k != TokenKind::Amp && k != TokenKind::LBracket && k != TokenKind::RBracket &&
                   k != TokenKind::Dot && !isTypeKeyword(k)) {
            // A pure type-argument list may hold pointer/ref/array/qualified args (Box<Point*>,
            // Box<int[]>, Box<app.Foo>); anything else means it's a comparison.
            return false;
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

// A region declaration carrying a flavor / growth modifier: `pool region R`, `growable region R`,
// `growable pool region R`. Recognized only when, after skipping one or more flavor/growth soft
// keywords, the next token is a *type keyword* -- normally `region`, but also a non-region type
// (e.g. `pool int x`) so the analyzer can reject the misuse with LDP3-1719. A flavor word followed by
// an ordinary identifier (e.g. `pool x`, a variable of a class named `pool`) is NOT a flavored decl,
// which keeps the words usable as identifiers.
bool Parser::looksLikeFlavoredRegionDecl() const {
    if (!isRegionFlavorWord(current())) return false;
    int i = 0;
    while (isRegionFlavorWord(peek(i))) ++i;
    return isTypeKeyword(peek(i).kind);
}

// A bare `extract <lvalue> from region R;` statement. Detected before the `ClassName name` var-decl
// dispatch so `extract d from ...` is not mis-parsed as declaring a variable `d` of a class `extract`
// (the analyzer then rejects the unbound extract with LDP3-1720). Requires `from` to follow the lvalue,
// so `extract d = ...` (a real declaration of a class named `extract`) is left to the var-decl path.
bool Parser::looksLikeExtractStmt() const {
    if (!(check(TokenKind::Identifier) && current().lexeme == "extract")) return false;
    int i = 1;
    if (peek(i).kind != TokenKind::Identifier && peek(i).kind != TokenKind::KwThis) return false;
    ++i;
    for (;;) {  // skip a member/index lvalue chain: .name, [ ... ]
        if (peek(i).kind == TokenKind::Dot && peek(i + 1).kind == TokenKind::Identifier) { i += 2; continue; }
        if (peek(i).kind == TokenKind::LBracket) {
            int depth = 1;
            ++i;
            while (depth > 0 && peek(i).kind != TokenKind::EndOfFile) {
                if (peek(i).kind == TokenKind::LBracket) ++depth;
                else if (peek(i).kind == TokenKind::RBracket) --depth;
                ++i;
            }
            continue;
        }
        break;
    }
    return peek(i).kind == TokenKind::Identifier && peek(i).lexeme == "from";
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
        } else if (k != TokenKind::Identifier && k != TokenKind::Comma && k != TokenKind::Star &&
                   k != TokenKind::Amp && k != TokenKind::LBracket && k != TokenKind::RBracket &&
                   k != TokenKind::Dot && !isTypeKeyword(k)) {
            // A pure type-argument list may hold pointer/ref/array/qualified args (Box<Point*>,
            // Box<int[]>, Box<app.Foo>); anything else means it's a comparison.
            return false;
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
                else if (k != TokenKind::Identifier && k != TokenKind::Comma &&
                         k != TokenKind::Star && k != TokenKind::Amp && k != TokenKind::LBracket &&
                         k != TokenKind::RBracket && k != TokenKind::Dot && !isTypeKeyword(k))
                    return false;  // pointer/ref/array/qualified type args are allowed
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
    // foreach with an index: `for (index i, T v in iterable) { ... }` (spec 7.6).
    if (check(TokenKind::KwIndex)) {
        auto fe = std::make_unique<ast::ForeachStmt>();
        fe->loc = loc;
        advance();  // 'index'
        fe->indexName = expect(TokenKind::Identifier, "an index variable name").lexeme;
        expect(TokenKind::Comma, "',' after the index variable");
        if (match(TokenKind::KwVar)) fe->isVar = true;
        else fe->elemType = parseTypeRef();
        fe->varName = expect(TokenKind::Identifier, "a loop variable name").lexeme;
        expect(TokenKind::KwIn, "'in'");
        fe->iterable = parseExpression();
        expect(TokenKind::RParen, "')'");
        fe->body = parseBlock();
        return fe;
    }
    // foreach over an array: `for (T name in iterable)`, or with a pointer element `for (T* name in ...)`
    // (spec 7). The pointer form is `Ident Star Ident In`; without this case a pointer element type is
    // mis-parsed as the multiplication `T * name`.
    if ((check(TokenKind::KwVar) || isTypeKeyword(current().kind) ||
         check(TokenKind::Identifier)) &&
        ((peek(1).kind == TokenKind::Identifier && peek(2).kind == TokenKind::KwIn) ||
         (peek(1).kind == TokenKind::Star && peek(2).kind == TokenKind::Identifier &&
          peek(3).kind == TokenKind::KwIn))) {
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
        check(TokenKind::KwNullable) || isTypeKeyword(current().kind)) {
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
            if (check(TokenKind::LBrace)) {  // block arm: yields via `yield expr;` (spec 16.2)
                m->defaultBody = std::make_unique<ast::Block>(parseBlock());
                match(TokenKind::Semicolon);  // optional trailing ';'
            } else {
                m->defaultResult = parseExpression();
                expect(TokenKind::Semicolon, "';'");
            }
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
        if (check(TokenKind::LBrace)) {  // block arm: yields via `yield expr;` (spec 16.2)
            c.body = parseBlock();
            match(TokenKind::Semicolon);  // optional trailing ';'
        } else {
            c.result = parseExpression();
            expect(TokenKind::Semicolon, "';'");
        }
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
    // Region flavor / growth soft keywords (spec 17, flavors expansion), consumed just before the type.
    // A second flavor word is space-joined into `regionFlavor` so the analyzer can report LDP3-1710 with
    // both names; `growable` sets its own flag. These stay ordinary identifiers unless a type follows.
    while (isRegionFlavorWord(current())) {
        const std::string w = current().lexeme;
        advance();
        if (w == "growable") {
            decl->regionGrowable = true;
        } else if (decl->regionFlavor.empty()) {
            decl->regionFlavor = w;
        } else {
            decl->regionFlavor += " " + w;  // two flavors -> LDP3-1710 in the analyzer
        }
    }
    if (match(TokenKind::KwVar)) {
        decl->isVar = true;
    } else {
        decl->type = parseTypeRef();
    }
    decl->name = expect(TokenKind::Identifier, "a variable name").lexeme;
    // A region may be declared empty (`region r;`, spec 17.2 form 3) and allocated later via
    // `r = itself.allocate(...)`; it is the one declaration form that omits the initializer.
    if (!decl->isVar && decl->type.name == "region" && check(TokenKind::Semicolon)) {
        return decl;  // init stays null
    }
    expect(TokenKind::Assign, "'=' (variables require an initializer)");
    decl->init = parseExpression();
    if (!decl->isVar) rewriteVariantCtor(decl->init, decl->type);
    return decl;
}

ast::StmtPtr Parser::parseDefer() {
    auto d = std::make_unique<ast::DeferStmt>();
    d->loc = current().loc;
    expect(TokenKind::KwDefer, "'defer'");
    // spec 32.10: `defer within <duration> { ... }` -- the cleanup has a time budget. `within` is a soft
    // keyword (it stays usable as an identifier), so only treat it as one when a block does not follow.
    if (check(TokenKind::Identifier) && current().lexeme == "within") {
        advance();
        d->within = parseExpression();
    }
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

ast::StmtPtr Parser::parseSynchronized() {
    auto s = std::make_unique<ast::SynchronizedStmt>();
    s->loc = current().loc;
    expect(TokenKind::KwSynchronized, "'synchronized'");
    expect(TokenKind::LParen, "'('");
    s->mutex = parseExpression();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::KwUsing, "'using'");
    s->bindType = parseTypeRef();  // T& -- a reference to the protected value
    s->bindName = expect(TokenKind::Identifier, "a binding name").lexeme;
    s->body = parseBlock();
    return s;
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

ast::ExprPtr Parser::parseExpression() {
    ast::ExprPtr e = parseTernary();
    // Range expression `start..end` / `start..=end` [`step k`] (spec 7.5).
    if (check(TokenKind::DotDot) || check(TokenKind::DotDotEq)) {
        auto r = std::make_unique<ast::RangeExpr>();
        r->loc = current().loc;
        r->inclusive = check(TokenKind::DotDotEq);
        advance();  // '..' or '..='
        r->start = std::move(e);
        r->end = parseTernary();
        if (match(TokenKind::KwStep)) r->step = parseTernary();
        return r;
    }
    return e;
}

ast::ExprPtr Parser::parseTernary() {
    ast::ExprPtr cond = parseBinary(1);
    while (check(TokenKind::QuestionQuestion)) {  // `a ?? b` null-coalescing (spec 3.7)
        auto nc = std::make_unique<ast::NullCoalesceExpr>();
        nc->loc = current().loc;
        advance();  // '??'
        nc->rhs = parseBinary(1);
        nc->lhs = std::move(cond);
        cond = std::move(nc);
    }
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

            // Optional format specifier (spec 4.1): `{pi:0.00}`. Split on the LAST ':' when what follows
            // looks like a specifier -- digits, '.', '#', ',' and letters, no spaces -- and the expression
            // contains no '?' (so a ternary `{a ? b : c}` is never mistaken for one).
            std::string format;
            if (exprSrc.find('?') == std::string::npos) {
                const std::size_t c = exprSrc.rfind(':');
                if (c != std::string::npos && c + 1 < exprSrc.size() && (c == 0 || exprSrc[c - 1] != ':')) {
                    const std::string tail = exprSrc.substr(c + 1);
                    const bool specLike =
                        !tail.empty() &&
                        std::all_of(tail.begin(), tail.end(), [](unsigned char ch) {
                            return std::isalnum(ch) != 0 || ch == '.' || ch == '#' || ch == ',';
                        });
                    if (specLike) {
                        format = tail;
                        exprSrc = exprSrc.substr(0, c);
                    }
                }
            }

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
            e->formats.push_back(std::move(format));
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
    // Postfix type operators (spec 6.4): `x is T`, `x as T`, `x as? T`. They bind tighter than the
    // comparison operators (so `a as T == b` groups as `(a as T) == b`) and reuse CastExpr with `op`.
    while (check(TokenKind::KwIs) || check(TokenKind::KwAs)) {
        const Token kw = advance();
        auto ce = std::make_unique<ast::CastExpr>();
        ce->loc = kw.loc;
        ce->operand = std::move(left);
        if (kw.kind == TokenKind::KwIs) ce->op = 1;                       // `is`  -> boolean
        else ce->op = match(TokenKind::Question) ? 2 : 0;                 // `as?` -> nullable, `as` -> checked
        const Token& tt = current();
        if (isTypeKeyword(tt.kind) || tt.kind == TokenKind::Identifier) {
            ce->targetType = tt.lexeme;
            advance();
            if (match(TokenKind::Star)) ce->targetType += "*";
        } else {
            fail("expected a type after 'is'/'as'", tt.loc);
        }
        left = std::move(ce);
    }
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
    // await expr (spec 20.2): suspend until the awaited Task completes, yielding its value.
    if (check(TokenKind::KwAwait)) {
        auto a = std::make_unique<ast::AwaitExpr>();
        a->loc = current().loc;
        advance();  // 'await'
        a->operand = parseUnary();
        return a;
    }
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
        if (tt.kind == TokenKind::KwFunction ||
            (tt.kind == TokenKind::Identifier && tt.lexeme == "funcptr" &&
             peek(1).kind == TokenKind::Lt)) {
            // A function<...> / funcptr<...> target carries its own angle brackets: parse the full
            // type (it also splits the trailing '>>', leaving one '>' for the cast to close).
            c->targetType = parseTypeRef().name;
        } else if (isTypeKeyword(tt.kind) || tt.kind == TokenKind::Identifier) {
            c->targetType = tt.lexeme;
            advance();
            if (match(TokenKind::Star)) c->targetType += "*";  // cast<T*>: pointer target (spec 17.8)
        } else {
            fail("expected a type inside cast<...>", tt.loc);
        }
        expect(TokenKind::Gt, "'>' to close cast<...>");
        expect(TokenKind::LParen, "'(' after cast<T>");
        c->operand = parseExpression();
        expect(TokenKind::RParen, "')'");
        return c;
    }
    // `mark of region R` (spec 17, stack flavor): capture R's cursor as a checkpoint. `mark` is a soft
    // keyword -- only this operator when directly followed by `of region`; otherwise an identifier.
    if (check(TokenKind::Identifier) && current().lexeme == "mark" &&
        peek(1).kind == TokenKind::KwOf && peek(2).kind == TokenKind::KwRegion) {
        auto mk = std::make_unique<ast::MarkExpr>();
        mk->loc = current().loc;
        advance();  // 'mark'
        advance();  // 'of'
        advance();  // 'region'
        mk->region = expect(TokenKind::Identifier, "the region name after 'mark of region'").lexeme;
        return mk;
    }
    // `extract X from region R` (spec 17, flavors expansion): relocate X out of a region and yield the
    // owning pointer. `extract` is a soft keyword -- treated as this operator only when it directly
    // precedes the start of an lvalue (an identifier or `this`); everywhere else it stays an identifier.
    // A class-typed declaration `extract x = ...` is routed to parseVarDecl before reaching here.
    if (check(TokenKind::Identifier) && current().lexeme == "extract" &&
        (peek(1).kind == TokenKind::Identifier || peek(1).kind == TokenKind::KwThis)) {
        auto ex = std::make_unique<ast::ExtractExpr>();
        ex->loc = current().loc;
        advance();  // 'extract'
        ex->target = parsePostfix();  // an lvalue: identifier / this.field / a[i]
        if (!(check(TokenKind::Identifier) && current().lexeme == "from"))
            fail("expected 'from region <name>' after the object to extract (spec 17)", current().loc);
        advance();  // 'from'
        expect(TokenKind::KwRegion, "'region' after 'from' in an extract");
        ex->region = expect(TokenKind::Identifier, "the region name").lexeme;
        return ex;
    }
    // `move x` transfers ownership (the source becomes invalid); `move x as T` also reinterprets the
    // moved value (spec 19.3, e.g. upgrading a movable to a unique).
    if (check(TokenKind::KwMove)) {
        auto mv = std::make_unique<ast::MoveExpr>();
        mv->loc = current().loc;
        advance();
        mv->operand = parseUnary();
        if (match(TokenKind::KwAs)) mv->castType = parseTypeRef().name;
        // Optional move qualifiers (spec 19.3), in any order: `from region R0`, `to`/`into region R`,
        // and `carrying`/`leaving`/`releasing persistents`. `from`/`to`/`into`/`carrying`/`leaving`/
        // `releasing`/`persistents` are soft keywords.
        for (;;) {
            if (check(TokenKind::Identifier) &&
                (current().lexeme == "from" || current().lexeme == "to" || current().lexeme == "into") &&
                peek(1).kind == TokenKind::KwRegion) {
                const std::string kw = advance().lexeme;  // from / to / into
                advance();                                // 'region'
                const std::string rgn = expect(TokenKind::Identifier, "the region name").lexeme;
                if (kw == "from") mv->fromRegion = rgn;
                else mv->toRegion = rgn;  // to / into region: relocate here
            } else if (check(TokenKind::Identifier) &&
                       (current().lexeme == "carrying" || current().lexeme == "leaving" ||
                        current().lexeme == "releasing")) {
                const std::string kw = advance().lexeme;
                if (check(TokenKind::Identifier) && current().lexeme == "persistents") advance();
                mv->persistMode = kw == "leaving" ? 1 : kw == "releasing" ? 2 : 0;
            } else {
                break;
            }
        }
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
        if (check(TokenKind::Dot) || check(TokenKind::QuestionDot)) {
            auto m = std::make_unique<ast::MemberExpr>();
            m->loc = current().loc;
            m->safe = check(TokenKind::QuestionDot);  // `obj?.member` safe navigation (spec 3.7)
            advance();  // '.' or '?.'
            // `method` is a keyword but also the reflection accessor t.method("x").
            if (check(TokenKind::KwMethod)) {
                m->member = "method";
                advance();
            } else {
                m->member = expectMemberName("a member name");
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
            parseCallArgs(*call);
            expect(TokenKind::RParen, "')'");
            call->callee = std::move(expr);
            call->typeArgs = std::move(typeArgs);
            expr = std::move(call);
        } else if (check(TokenKind::LParen)) {
            auto call = std::make_unique<ast::CallExpr>();
            call->loc = current().loc;
            advance();  // '('
            parseCallArgs(*call);
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
    const Token method = expect(TokenKind::Identifier, "'allocate', 'at' or 'atMultiple'");
    if (method.lexeme != "allocate" && method.lexeme != "at" && method.lexeme != "atMultiple") {
        fail("only itself.allocate(...) / itself.at(addr, size) / itself.atMultiple({...}) are "
             "supported, not 'itself." + method.lexeme + "'",
             method.loc);
    }
    expect(TokenKind::LParen, "'('");
    if (method.lexeme == "atMultiple") {
        // itself.atMultiple({ addr accepts {T}, addr rejects {T}, ... }) (spec 17.4): a region over
        // several fixed address ranges, each type-constrained; `new T in R` routes to the match.
        // A brace type-set `{A, B.C}` (no parens, unlike the chained `.accepts({...})`).
        auto braceTypeSet = [&](std::vector<std::string>& out) {
            expect(TokenKind::LBrace, "'{' after accepts/rejects");
            if (!check(TokenKind::RBrace)) {
                do {
                    std::string name = expect(TokenKind::Identifier, "a type name").lexeme;
                    while (match(TokenKind::Dot))
                        name += "." + expect(TokenKind::Identifier, "a name after '.'").lexeme;
                    out.push_back(std::move(name));
                } while (match(TokenKind::Comma));
            }
            expect(TokenKind::RBrace, "'}'");
        };
        expect(TokenKind::LBrace, "'{' after atMultiple(");
        do {
            ast::RegionInitExpr::Range r;
            r.address = parseExpression();
            if (match(TokenKind::KwAccepts)) braceTypeSet(r.accepts);
            else if (match(TokenKind::KwRejects)) braceTypeSet(r.rejects);
            else fail("expected 'accepts' or 'rejects' after a range address", current().loc);
            e->ranges.push_back(std::move(r));
        } while (match(TokenKind::Comma));
        expect(TokenKind::RBrace, "'}' to close atMultiple");
    } else if (method.lexeme == "at") {
        // itself.at(addr, size): a region over fixed memory (spec 17.8 / 36.9).
        e->atAddress = parseExpression();
        expect(TokenKind::Comma, "',' between address and size in itself.at(addr, size)");
        e->size = parseExpression();
    } else {
        e->size = parseExpression();
    }
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
    // `old(expr)` inside an ensures clause (spec 29): the value captured at method entry.
    if (parsingEnsures_ && tok.kind == TokenKind::Identifier && tok.lexeme == "old" &&
        peek(1).kind == TokenKind::LParen) {
        auto e = std::make_unique<ast::OldExpr>();
        e->loc = tok.loc;
        advance();  // 'old'
        expect(TokenKind::LParen, "'(' after 'old'");
        e->inner = parseExpression();
        expect(TokenKind::RParen, "')' to close 'old(...)'");
        return e;
    }
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
        case TokenKind::DecimalLiteral: {  // 1.50m -> the Decimal primitive (spec 34)
            auto e = std::make_unique<ast::FloatLiteralExpr>();
            e->loc = tok.loc;
            e->text = tok.lexeme;
            e->isDecimal = true;
            advance();
            return std::move(e);
        }
        case TokenKind::KwNull: {
            auto e = std::make_unique<ast::NullLiteralExpr>();
            e->loc = tok.loc;
            advance();
            return e;
        }
        case TokenKind::LBracket: {  // array literal `[a, b, c]` (spec 25); nested for multi-dim
            auto e = std::make_unique<ast::ArrayLiteralExpr>();
            e->loc = tok.loc;
            advance();  // '['
            if (!check(TokenKind::RBracket)) {
                do {
                    e->elements.push_back(parseExpression());
                } while (match(TokenKind::Comma));
            }
            expect(TokenKind::RBracket, "']' to close the array literal");
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
        case TokenKind::KwMethodref: {
            // methodref obj.method (spec 22.3): a bound method reference. The object may itself
            // be a member chain (a.b.c.method) -- everything before the final `.name` is the
            // receiver, the final `.name` is the method.
            auto e = std::make_unique<ast::MethodRefExpr>();
            e->loc = tok.loc;
            advance();  // 'methodref'
            ast::ExprPtr obj = parsePrimary();
            expect(TokenKind::Dot, "'.' in methodref (methodref obj.method)");
            std::string name = current().lexeme;
            expect(TokenKind::Identifier, "a method name after '.' in methodref");
            while (check(TokenKind::Dot)) {  // member chain: fold the prefix into the receiver
                auto m = std::make_unique<ast::MemberExpr>();
                m->loc = obj->loc;
                m->object = std::move(obj);
                m->member = name;
                obj = std::move(m);
                advance();  // '.'
                name = current().lexeme;
                expect(TokenKind::Identifier, "a method name after '.' in methodref");
            }
            e->object = std::move(obj);
            e->method = name;
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
        case TokenKind::KwUnimport:
            // unimport X expecting { ... } as a validation expression (spec 30.18).
            return parseUnimportExpr();
        case TokenKind::KwMatch:
            // match (...) { case T(..) -> expr; ... } in expression position (spec 16.2).
            return parseMatchExpr();
        default:
            fail("expected an expression but found '" + tok.lexeme + "'", tok.loc);
    }
}

// `[using a, b] { ... }` after the `expecting` keyword (spec 30.18). The `using` variables are
// context already visible in the surrounding scope, so they need no special binding here.
std::unique_ptr<ast::Block> Parser::parseExpectingTail(std::vector<std::string>& usingVars) {
    if (match(TokenKind::KwUsing)) {
        usingVars.push_back(expect(TokenKind::Identifier, "a context variable name").lexeme);
        while (match(TokenKind::Comma))
            usingVars.push_back(expect(TokenKind::Identifier, "a context variable name").lexeme);
    }
    return std::make_unique<ast::Block>(parseBlock());
}

// `unimport X expecting [using ...] { ... return v; }` (spec 30.18): a validation expression that
// produces the value the matching reimport compares against.
ast::ExprPtr Parser::parseUnimportExpr() {
    auto e = std::make_unique<ast::UnimportExpr>();
    e->loc = current().loc;
    expect(TokenKind::KwUnimport, "'unimport'");
    e->target = expect(TokenKind::Identifier, "a type name").lexeme;
    while (match(TokenKind::Dot)) e->target += "." + expect(TokenKind::Identifier, "a name").lexeme;
    expect(TokenKind::KwExpecting, "'expecting'");
    e->expecting = parseExpectingTail(e->usingVars);
    return e;
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
    // `in region R`: allocate inside a region (spec 17.5). The region may be a local or a field
    // accessed through `this` (spec 17: region as a field). Takes precedence.
    if (match(TokenKind::KwIn)) {
        expect(TokenKind::KwRegion, "'region' after 'in'");
        std::string r;
        if (match(TokenKind::KwThis)) r = "this";
        else r = expect(TokenKind::Identifier, "the region name").lexeme;
        while (match(TokenKind::Dot)) r += "." + expect(TokenKind::Identifier, "a field name").lexeme;
        e->region = r;
    }
    return e;
}

}  // namespace ldp3
