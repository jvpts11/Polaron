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
        } else if (f.type.name == "boolean") {
            // 1 or 0. A boolean is listed as a hashed field (it is part of the record's identity and
            // `equals` compares it) but it is not an arithmetic value: adding it into the mix directly
            // gave "operator '+' requires numeric operands" ON THE RECORD DECLARATION, for a `+` the
            // author never wrote. Same gap as the `cast<long>(boolean)` in the value-key hooks.
            auto t = std::make_unique<ast::TernaryExpr>();
            t->loc = loc;
            t->cond = std::move(fieldVal);
            t->thenExpr = makeInt("1");
            t->elseExpr = makeInt("0");
            fieldVal = std::move(t);
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
        case TokenKind::KwUnknown:  // [unknown-abi] `unknown <world> funcptr<...>` starts a type
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

// A SOFT KEYWORD is an ordinary identifier that means something in exactly one position. It is the
// difference between a language that reserves a word and one that merely recognizes it: `expecting`
// means something after `unimport Foo`, and is a field name anywhere else -- which it has to be,
// because an agent's `byte expecting` (how many children are coming) is an ordinary thing to write.
bool Parser::checkWord(const char* word) const {
    return current().kind == TokenKind::Identifier && current().lexeme == word;
}

void Parser::expectWord(const char* word, const char* what) {
    if (!checkWord(word))
        fail(std::string("expected ") + what + " but found '" + current().lexeme + "'",
             current().loc);
    advance();
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
        if (match(TokenKind::KwFreestanding)) {
            program.isFreestanding = true;  // spec 36.8
            freestanding_ = true;
        }
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
    // Taken BEFORE the token is consumed: a diagnostic about the NAME has to point at the name, and
    // `b.loc` is the `public` that started the declaration.
    b.nameLoc = current().loc;
    b.name = expect(TokenKind::Identifier, "the bundle name").lexeme;
    if (match(TokenKind::KwFreestanding)) {
        b.isFreestanding = true;  // spec 36.8
        freestanding_ = true;
    }
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
    ns.nameLoc = current().loc;
    ns.name = parseDottedName();
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        // Leading annotations (spec 14.3): `[Name(...)]` applied to the declaration that follows.
        std::vector<ast::AnnotationUse> anns = parseAnnotationUsesOpt();
        // Peek past an optional visibility modifier to tell enums from classes.
        TokenKind kind = current().kind;
        std::size_t kindAt = 0;
        if (kind == TokenKind::KwPublic || kind == TokenKind::KwPrivate ||
            kind == TokenKind::KwProtected || kind == TokenKind::KwInternal) {
            kindAt = 1;
            kind = peek(1).kind;
        }
        // ... and past `sealed`, which an ENUM may also carry. `sealed enum` is not the same
        // question as `sealed class`: a class is sealed to stop anyone extending it, and an enum's
        // constants are already a closed list -- what the word buys is that a `match` over it must
        // COVER them, with the compiler naming the ones it forgot. Without this the declaration was
        // refused by a message about classes, on a form the specifications write throughout.
        if (kind == TokenKind::KwSealed && peek(kindAt + 1).kind == TokenKind::KwEnum) {
            kind = TokenKind::KwEnum;
        }
        if (kind == TokenKind::KwAnnotation) {
            ns.annotationDecls.push_back(parseAnnotationDecl(anns));
            continue;
        }
        // A transformer needs more than the one-token peek the others use: `mutual` and `explicit`
        // are SOFT keywords, so they lex as identifiers and sit between the visibility and the word
        // that decides the declaration. Scan past them rather than reserving two more words.
        {
            int i = (current().kind == TokenKind::KwPublic || current().kind == TokenKind::KwPrivate ||
                     current().kind == TokenKind::KwProtected || current().kind == TokenKind::KwInternal)
                        ? 1
                        : 0;
            while (peek(i).kind == TokenKind::Identifier &&
                   (peek(i).lexeme == "mutual" || peek(i).lexeme == "explicit"))
                ++i;
            if (peek(i).kind == TokenKind::KwTransformer) {
                ns.transformers.push_back(parseTransformer());
                continue;
            }
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
                // A java-style enum may implement catalogs (2026-08-09); the light enum keeps the
                // linkage so the analyzer validates the contract and codegen finds the implementer.
                light.extendsCatalogs = std::move(en.extendsCatalogs);
                light.byCatalogValues = std::move(en.byCatalogValues);
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
    else if (match(TokenKind::KwUnknown))  // `unknown <world>`: adopt a foreign binary's ABI (world required)
        conv = "unknown:" + expect(TokenKind::Identifier,
                   "the foreign world (pe/elf/macho, or raw win64/sysv/aapcs) after 'unknown'").lexeme;
    else fail("expected a calling convention (cdecl/stdcall/fastcall/unknown) after 'extern'", current().loc);
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

// Parses zero or more applied annotations preceding a declaration. An annotation has two
// interchangeable spellings (spec 14.1), and BOTH are accepted for BOTH built-in and user-defined
// annotations -- a built-in is just an annotation the stdlib declares, so there is nothing to tell
// them apart and no reason to spell them differently:
//   `[Name(arg: val, ...)]`  e.g. `[Test]`, `[Ignore(reason: "flaky")]`, `[MyAnnotation]`
//   `@Name(arg: val, ...)`   e.g. `@Test`, `@Ignore(reason: "flaky")`, `@MyAnnotation`
// Both produce the same AnnotationUse, so every consumer just looks the name up.
// A compiler ATTRIBUTE is a different thing and keeps its own spelling: `[[no_bounds_check]]`
// (spec 36.4), double-bracketed only, never `@`.
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
    if (match(TokenKind::KwSealed)) e.isSealed = true;
    expect(TokenKind::KwEnum, "'enum'");
    e.name = expect(TokenKind::Identifier, "the enum name").lexeme;
    // Catalogs implemented by this enum (spec 12.4): `enum Motor extends TipoMotor`.
    if (match(TokenKind::KwExtends)) {
        do {
            e.extendsCatalogs.push_back(expect(TokenKind::Identifier, "a catalog name").lexeme);
        } while (match(TokenKind::Comma));
    }
    // `sealed enum Ending permits Caught, Escaped;` -- the constants ARE the permits list, and
    // there is no body. The two spellings say the same thing and the specifications use this one
    // wherever the point is that every outcome is named and counted; `{ ... }` remains for the
    // ordinary case and for anything java-style, which needs somewhere to put its members.
    if (check(TokenKind::KwPermits)) {
        if (!e.isSealed) {
            fail("`permits` lists the constants of a SEALED enum; write `sealed enum " + e.name +
                     " permits ...`, or give it a `{ ... }` body",
                 current().loc);
        }
        advance();
        do {
            e.constants.push_back(expect(TokenKind::Identifier, "an enum constant").lexeme);
            e.constantArgs.push_back({});
        } while (match(TokenKind::Comma));
        expect(TokenKind::Semicolon, "';' to close a `permits` enum");
        // AND IT MAY STILL HAVE BEHAVIOUR. `permits` says what the constants ARE; it says nothing
        // about what they can do, and an enum whose whole point is that every case is named is
        // exactly the enum you want to `match` over inside a method of its own -- the sealing is
        // what makes that match total. Refusing the body meant the two spellings of `sealed enum`
        // were not interchangeable after all: one could answer questions and the other could not.
        //
        // Methods alone never make an enum java-style; the normalisation below is shared, so these
        // constants stay i32 ordinals with value semantics exactly as they would in the `{ ... }`
        // spelling (see the note on it, and RL-7 for what it costs when that slips).
        if (match(TokenKind::LBrace)) {
            while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
                e.members.push_back(parseMember(/*inInterface=*/false));
            }
            expect(TokenKind::RBrace, "'}' to close the enum body");
            e.isJavaStyle = true;
            normalizeEnumStyle(e);
        }
        return e;
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
    // continue), and are recorded as catalog-provided for clarity/validation. In a
    // java-style enum every constant carries its data, so a byCatalog constant takes
    // constructor arguments exactly like an own constant does.
    if (match(TokenKind::KwByCatalog)) {
        expect(TokenKind::LBrace, "'{' to open byCatalog");
        if (check(TokenKind::Identifier)) {
            do {
                const std::string v = expect(TokenKind::Identifier, "a catalog value").lexeme;
                e.byCatalogValues.push_back(v);
                e.constants.push_back(v);
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
                e.constantArgs.push_back(std::move(args));  // keep parallel to `constants`
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
    normalizeEnumStyle(e);
    return e;
}

// What makes an enum java-style is STATE -- per-constant constructor arguments, instance fields, a
// constructor -- never methods alone. A methods-only enum is normalised back to ordinal whether or
// not it implements a catalog: its constants stay i32 ordinals with value semantics, its methods
// dispatch on the ordinal, and `;` is only ever a separator. (Before 2026-08-09 this normalisation
// existed only for catalog-implementing enums, so a plain enum that declared one method silently
// turned its constants into heap singletons -- found by the relayout when Biome gained its
// questions, as an 8-byte sizeof where 4 was promised.)
//
// Shared by both spellings of an enum body, so `permits ...; { ... }` cannot drift from `{ ... }`
// on the one question where drifting is silent and expensive.
void Parser::normalizeEnumStyle(ast::EnumDecl& e) {
    if (!e.isJavaStyle) return;
    bool hasCtorArgs = false;
    for (const auto& a : e.constantArgs) {
        if (!a.empty()) {
            hasCtorArgs = true;
            break;
        }
    }
    bool hasStateOrCtor = false;
    for (const auto& m : e.members) {
        if (dynamic_cast<const ast::ConstructorDecl*>(m.get()) != nullptr) {
            hasStateOrCtor = true;
            break;
        }
        if (const auto* fd = dynamic_cast<const ast::FieldDecl*>(m.get())) {
            if (!fd->isStatic) {
                hasStateOrCtor = true;
                break;
            }
        }
    }
    if (!hasCtorArgs && !hasStateOrCtor) e.isJavaStyle = false;
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

// `applies A, B` on a declaration line. Shared by class/interface and record, because a record can
// gain things too -- the design says so, and a record is exactly where a derived `clone` belongs.
void Parser::parseAppliesOpt(ast::ClassDecl& c) {
    if (!match(TokenKind::KwApplies)) return;
    do {
        c.appliesLocs.push_back(current().loc);
        c.applies.push_back(expect(TokenKind::Identifier, "a transformer name").lexeme);
    } while (match(TokenKind::Comma));
}

// `public [mutual] [explicit] transformer Name { ... }`
//
// Parsed into a ClassDecl, the way `operator+` is parsed into a MethodDecl: its members are
// ordinary members and every pass that walks a class body already knows how to walk them. What is
// different about a transformer is not its inside -- it is that it is never instantiated and never a
// type, and that is expressed by keeping it out of `Namespace::classes` entirely.
ast::ClassDecl Parser::parseTransformer() {
    ast::ClassDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    // `mutual` and `explicit` are SOFT keywords: both are ordinary words a program may already use
    // as a name, and neither needs to be reserved to be recognised here -- nothing else can appear
    // between the visibility and `transformer`.
    for (;;) {
        if (check(TokenKind::Identifier) && current().lexeme == "mutual") {
            advance();
            c.isMutualTransformer = true;
            continue;
        }
        if (check(TokenKind::Identifier) && current().lexeme == "explicit") {
            advance();
            c.isExplicitTransformer = true;
            continue;
        }
        break;
    }
    expect(TokenKind::KwTransformer, "'transformer'");
    c.isTransformer = true;
    c.nameLoc = current().loc;
    c.name = expect(TokenKind::Identifier, "the transformer name").lexeme;
    parseAppliesOpt(c);  // `transformer A applies B` -- whoever applies A also applies B
    expect(TokenKind::LBrace, "'{'");
    inTransformer_ = true;
    pendingProcCalls_.clear();
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        // `error Failed;` -- the transformer's own failure type. A soft keyword: it is recognised
        // only here, followed by a name and a semicolon, and stays usable as an identifier
        // everywhere else in the language.
        if (check(TokenKind::Identifier) && current().lexeme == "error" &&
            peek(1).kind == TokenKind::Identifier && peek(2).kind == TokenKind::Semicolon) {
            advance();  // error
            const SourceLocation nameLoc = current().loc;
            c.errorTypes.emplace_back(expect(TokenKind::Identifier, "the error type name").lexeme,
                                      nameLoc);
            expect(TokenKind::Semicolon, "';'");
            continue;
        }
        c.members.push_back(parseMember(/*inInterface=*/false));
    }
    inTransformer_ = false;
    c.procCalls = std::move(pendingProcCalls_);
    pendingProcCalls_.clear();
    expect(TokenKind::RBrace, "'}'");
    return c;
}

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
    // `heap class X` (spec 36): X provides the program's heap. A soft keyword -- `heap` stays usable as
    // an identifier everywhere else, notably in `new T() on heap`.
    if (check(TokenKind::Identifier) && current().lexeme == "heap" &&
        peek(1).kind == TokenKind::KwClass) {
        advance();
        c.isHeap = true;
    }
    if (match(TokenKind::KwInterface)) {
        c.isInterface = true;
        c.isAbstract = true;  // interfaces are abstract by nature
    } else if (match(TokenKind::KwLayout)) {
        // A layout is an interface for MEMORY: it says how an implementing value aggregate arranges
        // itself. The class modifiers describe objects and lifetimes, so most of them say nothing
        // about one. Refused with the reason rather than ignored -- silently accepting a word that
        // does nothing teaches that it did something.
        if (c.isAbstract)
            fail("a layout is abstract by nature -- it describes memory and never has an instance, "
                 "so `abstract` states what is already true", c.loc);
        if (c.isPartial)
            fail("a layout cannot be split across declarations: an arrangement is decided once, and "
                 "two halves could ask for two different ones", c.loc);
        if (c.isMovable || c.isUnique || c.isPartitionable)
            fail("ownership modifiers belong to a type that holds a value; a layout holds nothing "
                 "and is gone by the time the program runs", c.loc);
        if (c.isHeap)
            fail("`heap` marks the class that provides the program's heap, which a layout is not", c.loc);
        c.isLayout = true;
        c.isAbstract = true;  // abstract by nature, like an interface
    } else if (match(TokenKind::KwStruct)) {
        c.isStruct = true;  // value type, no inheritance
    } else if (match(TokenKind::KwUnion)) {
        c.isUnion = true;   // value type whose fields overlap one storage
        c.isStruct = true;
    } else {
        expect(TokenKind::KwClass, "'class', 'struct', 'union', 'interface' or 'layout'");
    }
    c.nameLoc = current().loc;   // before consuming it: a diagnostic about the NAME points at the name
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
    // `applies A, B` -- LAST on the class line, and the order is the argument: identity, then
    // obligation, then equipment. `extends` is one and is-a; `implements` is many and is a promise
    // made outward; `applies` is many, purely additive, and nobody outside needs to know about it.
    parseAppliesOpt(c);
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
        // A layout's arrangement hook -- the lifecycle hooks' shape (a soft keyword and a block that
        // nobody calls) at a different moment: this one runs during the build and leaves nothing in
        // the program. Rejected outside a layout, where there is no arrangement to speak of.
        if (check(TokenKind::Identifier) && current().lexeme == "onArrange") {
            const SourceLocation hookLoc = current().loc;
            advance();
            if (!c.isLayout)
                fail("`onArrange` decides how a type arranges itself in memory, which is a layout's "
                     "job -- declare a `layout` and implement it from here", hookLoc);
            if (c.onArrange != nullptr)
                fail("this layout already has an `onArrange`: one arrangement, decided in one place",
                     hookLoc);
            c.onArrange = std::make_unique<ast::Block>(parseBlock());
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
    c.procCalls = std::move(pendingProcCalls_);  // every `call T.p()` written in this body
    pendingProcCalls_.clear();
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
    parseAppliesOpt(c);  // a record gains things too -- it is where a derived `clone` belongs

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
    // `toString` returns a String, and String is a managed object that freestanding does not have
    // (spec 36.3). Generating it there made every `record` UNDECLARABLE -- the type was rejected for a
    // method the author never wrote, with an error pointing at the String machinery rather than at the
    // record. So the auto-member that cannot exist is simply not generated.
    //
    // `equals` and `hashCode` stay: neither touches String (hashCode already skips non-numeric fields
    // by design), and they are the two that make a record worth having as an immutable value -- which
    // is exactly the shape a kernel wants for a descriptor.
    if (!freestanding_) c.members.push_back(buildRecordToString(c.name, fields, c.loc));

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

// SPEC 37: WHERE EACH MODIFIER MAY APPEAR, AND IN WHAT ORDER.
//
// parseMember collects every modifier in ONE shared loop and then hands a SUBSET of them to whichever
// declaration follows: parseMethod takes ten of them, parseField takes fifteen, and parseConstructor,
// parseDestructor and parseOperator take NONE. Everything not handed over was silently discarded --
// `public eternal method f()` parsed, compiled and did nothing, with no diagnostic, because MethodDecl
// has nowhere to put it. Six modifiers behaved that way on a method alone, and `comptime` did on a
// field, which spec 37.4 shows as valid.
//
// That is the worst shape a gap can take: the programmer believes they declared something. So the span
// of tokens the loop consumed is checked against the declaration that followed it, and a modifier that
// cannot be carried is an error naming where it does belong. A prefix the spec calls universal has to
// either work or say why not; silence is the one answer it must never give.
namespace {

enum ModShape : unsigned {
    kOnMethod = 1u << 0, kOnField = 1u << 1, kOnCtor = 1u << 2, kOnDtor = 1u << 3,
    kOnOperator = 1u << 4, kOnLiteral = 1u << 5, kOnFixed = 1u << 6, kOnLocal = 1u << 7,
};

struct ModifierRule {
    TokenKind kind;
    const char* name;
    unsigned carriedBy;   // the declarations that can actually carry it
    int rank;             // canonical order (spec 37.9); 0 = the spec does not rank it
    const char* belongs;  // where it DOES apply -- the half of the message that helps
};

// THE CANONICAL ORDER (spec 37.9), AND WHY IT IS NOT THE ONE THE SPEC USED TO PRINT.
//
// The old order -- `eternal lazy final comptime volatile cascade static mutable persistent transient`
// -- was not organized by anything: the three LIFETIME words were split apart with `static` and
// `mutable` between them. That is why nothing followed it. Turning it on rejected 17 tests in this
// repository's own suite, and reading them said the paragraph was wrong rather than the code.
//
// A declaration now reads left to right as one question per group:
//
//   visibility   who may touch this?        public private protected internal
//   deprecation  should anyone still?       deprecated
//   foreignness  is it even an LDP3 method? extern <conv>  unknown <world>  naked
//   binding      one per class or object?   static abstract override final
//   lifetime     how long does it exist?    eternal lazy persistent transient
//   access       how must it be touched?    volatile
//   mutability   may the program change it? mutable
//   compilation  when is it computed?       comptime
//   ownership    who owns it?               weak unique movable delegate external
//   concurrency  how does it run?           async
//   placement    where does it live?        in region X
//
// Binding before lifetime is deliberate: `static` decides WHERE THE STORAGE IS -- on the class or on
// the object -- and a lifetime modifies that storage, so the storage is named first. It also keeps
// `static` next to the visibility, which is how a declaration is read everywhere else.
//
// Foreignness comes before ALL of it, and that is measured, not chosen: the samples write
// `extern cdecl static method` 13 times and pico writes `unknown sysv naked static method` 15 times,
// with no counter-example. It reads correctly too -- these say the declaration is not an ordinary
// LDP3 method at all, which is the outermost fact about it. `async` does NOT belong with them: it
// describes how OUR method runs, not how it is called from outside, and the corpus agrees --
// `static async method` appears 14 times and `async static` never.
//
// THE ORDER IS BETWEEN QUESTIONS, NOT BETWEEN ANSWERS TO ONE. Members of a group share a rank, so
// `static override` and `override static` are both fine. The language has an opinion about which
// question comes first; it has none about which of two binding words comes first, and the compiler
// must not invent one.
//
// Measured against the whole corpus (samples + pico + psh) this order costs exactly TWO declarations:
// `persist_demo.ldp3` and `cascade_graph.ldp3`. Everything else already satisfies it, including
// `mutable weak` (18 uses), `static async` (14), `static comptime` (15) and `persistent mutable` (5).
constexpr bool kEnforceCanonicalOrder = true;

constexpr ModifierRule kModifierRules[] = {
    {TokenKind::KwDeprecated, "deprecated", kOnMethod, 10, "a method (spec 14.2)"},

    {TokenKind::KwExtern,     "extern",     kOnMethod, 15, "a method (spec 26)"},
    {TokenKind::KwUnknown,    "unknown",    kOnMethod, 15,
     "a method (spec 26: the calling convention of a foreign binary's world)"},
    {TokenKind::KwNaked,      "naked",      kOnMethod, 15, "a method (spec 36)"},

    // `fixed` members are static by nature; spelling it out is redundant but legal, and used.
    {TokenKind::KwStatic,     "static",     kOnMethod | kOnField | kOnFixed, 20, "a method or a field"},
    {TokenKind::KwAbstract,   "abstract",   kOnMethod | kOnField, 20, "a method or a field"},
    // NOT on a destructor. `cascade_inherited` wrote it and I let it through on that evidence; then I
    // compiled the sample with and without and the IR was byte-identical. A destructor does not
    // override anything -- the chain runs derived-then-base by itself -- so the word said nothing, and
    // saying nothing quietly is the shape this check exists to stop.
    {TokenKind::KwOverride,   "override",   kOnMethod | kOnField, 20, "a method or a field"},
    {TokenKind::KwFinal,      "final",      kOnMethod | kOnField | kOnLocal, 20,
     "a class, a method, a field, a local or an import (spec 37.6)"},

    {TokenKind::KwEternal,    "eternal",    kOnField | kOnLocal, 30, "a field or a local (spec 37.2)"},
    {TokenKind::KwLazy,       "lazy",       kOnField | kOnLocal, 30,
     "a field, a local or an import (spec 37.3)"},
    {TokenKind::KwPersistent, "persistent", kOnField | kOnLocal, 30, "a field or a local (spec 18)"},
    {TokenKind::KwTransient,  "transient",  kOnField, 30, "a field"},

    // Access before mutability, and the language had already voted: the LOCAL declaration parser only
    // accepts `volatile` BEFORE `mutable` -- written the other way round it is consumed and dropped,
    // and `volatile mutable int sum` stops emitting a volatile store with nothing said. `volatile` is
    // a fact about the storage itself (how it must be touched, because hardware is on the other end);
    // `mutable` is the program's permission to write it. The storage comes first.
    {TokenKind::KwVolatile,   "volatile",   kOnMethod | kOnField | kOnLocal, 40,
     "a method, a field, a local or a region (spec 37.5)"},

    {TokenKind::KwMutable,    "mutable",    kOnField | kOnLocal, 50, "a field or a local"},

    {TokenKind::KwComptime,   "comptime",   kOnMethod | kOnField | kOnLiteral, 60,
     "a method, a field, a local or a literal suffix (spec 37.4)"},

    {TokenKind::KwWeak,       "weak",       kOnField, 70, "a field"},
    {TokenKind::KwUnique,     "unique",     kOnField, 70, "a field (spec 19.9)"},
    {TokenKind::KwMovable,    "movable",    kOnField, 70, "a field (spec 19.9)"},
    {TokenKind::KwDelegate,   "delegate",   kOnField, 70,
     "a field -- delegation names the target that receives the calls, and the target is the field"},
    {TokenKind::KwExternal,   "external",   kOnField, 70,
     "a field (spec 37.1: an association, which cascade does not follow)"},

    {TokenKind::KwAsync,      "async",      kOnMethod, 80, "a method"},
};

// The group each rank names, for the error message -- a reordering is easier to act on when the
// message says WHY one comes first rather than just listing the order.
const char* groupOfRank(int rank) {
    switch (rank) {
        case 10: return "deprecation";
        case 15: return "foreignness";
        case 20: return "binding";
        case 30: return "lifetime";
        case 40: return "access";
        case 50: return "mutability";
        case 60: return "compilation";
        case 70: return "ownership";
        case 80: return "concurrency";
        default: return "";
    }
}

}  // namespace

void Parser::checkMemberModifiers(std::size_t from, std::size_t to, MemberShape shape) {
    unsigned bit = 0;
    const char* what = "";
    switch (shape) {
        case MemberShape::Method:      bit = kOnMethod;   what = "a method";           break;
        case MemberShape::Field:       bit = kOnField;    what = "a field";            break;
        case MemberShape::Constructor: bit = kOnCtor;     what = "a constructor";      break;
        case MemberShape::Destructor:  bit = kOnDtor;     what = "a destructor";       break;
        case MemberShape::Operator:    bit = kOnOperator; what = "an operator";        break;
        case MemberShape::Literal:     bit = kOnLiteral;  what = "a literal suffix";   break;
        case MemberShape::Fixed:       bit = kOnFixed;    what = "a `fixed` constant"; break;
        case MemberShape::Local:       bit = kOnLocal;    what = "a local";            break;
        // No rule carries this bit, so an interrupt accepts visibility and nothing else -- and that
        // is the point rather than an omission. `static` would take away the object the handler
        // exists to reach; `abstract`/`override` describe dispatch through a table nobody calls
        // through; `async` describes a method that suspends and resumes, which is the one thing an
        // interrupt may never do.
        case MemberShape::Interrupt:   bit = 0;           what = "an interrupt";       break;
    }
    int lastRank = 0;
    const char* lastRanked = nullptr;
    bool sawFinal = false;
    bool sawMutable = false;
    for (std::size_t i = from; i < to && i < tokens_.size(); ++i) {
        const ModifierRule* rule = nullptr;
        for (const ModifierRule& r : kModifierRules)
            if (r.kind == tokens_[i].kind) { rule = &r; break; }
        // Not a modifier: the region name after `in region`, the convention after `extern`, and so on.
        if (rule == nullptr) continue;
        if ((rule->carriedBy & bit) == 0)
            fail(std::string("'") + rule->name + "' cannot be applied to " + what + ". It applies to " +
                     rule->belongs + ".",
                 tokens_[i].loc);
        // spec 37.8: the one contradiction the grammar cannot express, because both words are legal
        // in the same place. It used to be caught by accident -- the local parser stopped after
        // `final`, so `final mutable int x` failed with "expected a type but found 'mutable'", which
        // explains the parse and not the mistake.
        if (rule->kind == TokenKind::KwFinal) sawFinal = true;
        if (rule->kind == TokenKind::KwMutable) sawMutable = true;
        if (sawFinal && sawMutable)
            fail("'final' and 'mutable' are contradictory (spec 37.8): 'final' means the value cannot "
                 "be modified after initialization, 'mutable' allows reassignment. Use one.",
                 tokens_[i].loc);
        if (!kEnforceCanonicalOrder || rule->rank == 0) continue;
        if (rule->rank < lastRank)
            fail(std::string("modifier order: '") + rule->name + "' must come before '" + lastRanked +
                     "'. A declaration answers one question per group, in this order (spec 37.9): "
                     "visibility, deprecation, foreignness, binding, lifetime, access, mutability, "
                     "compilation, ownership, concurrency, placement -- and '" + rule->name + "' is " +
                     groupOfRank(rule->rank) + " while '" + lastRanked + "' is " +
                     groupOfRank(lastRank) + ".",
                 tokens_[i].loc);
        lastRank = rule->rank;
        lastRanked = rule->name;
    }
}

ast::MemberPtr Parser::parseMember(bool inInterface) {
    std::vector<ast::AnnotationUse> anns = parseAnnotationUsesOpt();  // leading `[Name(...)]` (spec 14.3)
    std::string visibility = parseVisibilityOpt();
    const std::size_t modFrom = pos_;   // the modifier span, checked once the declaration is known
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
    bool isNaked = false;
    bool isExternal = false;
    bool isDelegateField = false;
    bool isMovableField = false;
    bool isUniqueField = false;
    bool isWeakField = false;
    bool isExtern = false;          // spec 26: extern C method member
    std::string externConvention;
    std::string fieldInRegion;      // spec 18.7: `in region X` placement, as written
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
            fieldInRegion = expect(TokenKind::Identifier, "the region name after 'in region'").lexeme;
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
        if (!isNaked && check(TokenKind::KwNaked)) {  // spec 36: no prologue/epilogue, body is raw asm
            advance();
            isNaked = true;
            continue;
        }
        if (!isExternal && check(TokenKind::KwExternal)) {
            advance();
            isExternal = true;
            continue;
        }
        if (!isDelegateField && check(TokenKind::KwDelegate)) {  // implement the interfaces via this field
            advance();
            isDelegateField = true;
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
        if (!isWeakField && check(TokenKind::KwWeak)) {  // `weak T*` field: non-owning, auto-nulled on death
            advance();
            isWeakField = true;
            continue;
        }
        if (!isExtern && check(TokenKind::KwExtern)) {  // spec 26: extern <conv> [static] method ...
            advance();
            if (match(TokenKind::KwCdecl)) externConvention = "cdecl";
            else if (match(TokenKind::KwStdcall)) externConvention = "stdcall";
            else if (match(TokenKind::KwFastcall)) externConvention = "fastcall";
            else if (match(TokenKind::KwUnknown))
                externConvention = "unknown:" + expect(TokenKind::Identifier,
                    "the foreign world (pe/elf/macho, or raw win64/sysv/aapcs) after 'unknown'").lexeme;
            else fail("expected a calling convention (cdecl/stdcall/fastcall/unknown) after 'extern'",
                      current().loc);
            isExtern = true;
            continue;
        }
        // `unknown <world>` as a standalone modifier: emit this (non-extern) method with the calling
        // convention of a foreign binary's world, so that binary can call it across the boundary (e.g.
        // a Windows PE through its IAT). The world is REQUIRED -- the compiler never infers it.
        if (externConvention.empty() && check(TokenKind::KwUnknown)) {
            advance();
            externConvention = "unknown:" + expect(TokenKind::Identifier,
                "the foreign world (pe/elf/macho, or raw win64/sysv/aapcs) after 'unknown'").lexeme;
            continue;
        }
        break;
    }
    const std::size_t modTo = pos_;
    ast::MemberPtr member;
    // spec 32.6: `bidirectional T name { src to name: expr; name to src: expr; }` -- a property that
    // converts both ways over a backing field. `bidirectional` is a soft keyword (still usable as a name).
    if (check(TokenKind::Identifier) && current().lexeme == "bidirectional") {
        advance();
        return parseBidirectional(std::move(visibility), isStatic);
    }
    if (check(TokenKind::KwMethod) || check(TokenKind::KwProcedure)) {
        checkMemberModifiers(modFrom, modTo, MemberShape::Method);
        member = parseMethod(std::move(visibility), isStatic, isAbstract, isOverride, isFinal,
                             inInterface, isComptime, isAsync, isVolatile, isExtern,
                             std::move(externConvention), isDeprecated, isNaked);
    } else if (check(TokenKind::KwConstructor)) {
        checkMemberModifiers(modFrom, modTo, MemberShape::Constructor);
        member = parseConstructor(std::move(visibility));
    } else if (check(TokenKind::KwDestructor)) {
        checkMemberModifiers(modFrom, modTo, MemberShape::Destructor);
        member = parseDestructor(std::move(visibility));
    } else if (check(TokenKind::KwInterrupt)) {
        checkMemberModifiers(modFrom, modTo, MemberShape::Interrupt);
        member = parseInterrupt(std::move(visibility));
    } else if (check(TokenKind::KwOperator)) {
        checkMemberModifiers(modFrom, modTo, MemberShape::Operator);
        member = parseOperator(std::move(visibility));
    } else if (check(TokenKind::KwLiteral)) {  // a literal suffix is a member of its result type's class
        checkMemberModifiers(modFrom, modTo, MemberShape::Literal);
        member = parseLiteralMember(std::move(visibility), isComptime);
    } else if (check(TokenKind::KwFixed)) {  // a compile-time constant as a static class member
        checkMemberModifiers(modFrom, modTo, MemberShape::Fixed);
        member = parseConstMember(std::move(visibility));
    } else {
        checkMemberModifiers(modFrom, modTo, MemberShape::Field);
        pendingFieldInRegion_ = fieldInRegion;
        // Otherwise it is a field:  <type> <name> ;
        member = parseField(std::move(visibility), isStatic, isMutable, isPersistent, isEternal,
                            isTransient, isVolatile, isLazy, isComptime, isExternal, isDelegateField,
                            isMovableField, isUniqueField, isWeakField, isAbstract, isOverride,
                            isFinal, inInterface);
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
                                                     std::string externConvention, bool isDeprecated, bool isNaked) {
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
    m->isNaked = isNaked;            // spec 36: no prologue/epilogue; the body is raw assembly
    // `procedure` takes the same path as `method` because the difference is not in the parse: a
    // procedure has a name, parameters, a return type and (usually) a body, exactly like a method.
    // What differs is WHERE its signature is completed -- at the type that applies it -- and that is
    // a question for the expansion pass, not the grammar.
    if (check(TokenKind::KwProcedure)) {
        advance();
        m->isProcedure = true;
    } else {
        expect(TokenKind::KwMethod, "'method'");
    }
    m->name = expectMemberName(m->isProcedure ? "the procedure name" : "the method name");
    // Generic method type parameters: method identity<T>(...) (spec 15). Each
    // (method-name, type-args) call is monomorphized into a concrete method.
    if (match(TokenKind::Lt)) {
        do {
            // `<each Other>` on a procedure: the implementations bind this one per target rather
            // than sharing a body. A soft keyword -- `each` stays usable as a name everywhere else.
            if (m->isProcedure && check(TokenKind::Identifier) && current().lexeme == "each" &&
                peek(1).kind == TokenKind::Identifier) {
                advance();
                m->isEachFamily = true;
            }
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
    // region-binder escape summary carried in the .ldh: `escapes(i:slot, ...)`, slot -1 = receiver, j = param
    // j. A soft keyword (only meaningful here); harmless elsewhere. Round-trips a library method's summary.
    if (check(TokenKind::Identifier) && current().lexeme == "escapes" &&
        peek(1).kind == TokenKind::LParen) {
        advance();  // 'escapes'
        advance();  // '('
        if (!check(TokenKind::RParen))
            do {
                int pi = std::stoi(expect(TokenKind::IntLiteral, "a parameter index in escapes(...)").lexeme);
                expect(TokenKind::Colon, "':' in escapes(i:slot)");
                bool neg = match(TokenKind::Minus);
                int slot = std::stoi(expect(TokenKind::IntLiteral, "a slot in escapes(...)").lexeme);
                m->escapeSummary.emplace_back(pi, neg ? -slot : slot);
            } while (match(TokenKind::Comma));
        expect(TokenKind::RParen, "')' to close escapes(...)");
    }
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
    } else if (m->isProcedure && !check(TokenKind::Semicolon) && !headerMode_) {
        inProcedure_ = true;   // so `itself.x` in the body is the receiver, on the type too
        m->body = parseBlock();
        inProcedure_ = false;
    } else if (m->isProcedure && check(TokenKind::Semicolon)) {
        // A SOCKET: a procedure with no body. The applying type must supply one, or the error lands
        // on its `applies` line naming what is missing. This is how a transformer declares the parts
        // of its own algorithm instead of borrowing an interface to hold them.
        m->isAbstract = true;
        advance();
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
                                  bool isVolatile, bool isLazy, bool isComptime, bool isExternal, bool isDelegate,
                                  bool isMovable, bool isUnique, bool isWeak, bool isAbstract,
                                  bool isOverride, bool isFinal, bool inInterface) {
    const SourceLocation loc = current().loc;
    // Region flavor / growth soft keywords (spec 17 flavors) on a `region` field, before the type.
    std::string fieldRegionFlavor;
    bool fieldRegionGrowable = false;
    while (isRegionFlavorWord(current())) {
        const std::string w = current().lexeme;
        advance();
        if (w == "growable") fieldRegionGrowable = true;
        else if (fieldRegionFlavor.empty()) fieldRegionFlavor = w;
        else fieldRegionFlavor += " " + w;  // two flavors -> LDP3-1710 in the analyzer
    }
    ast::TypeRef type = parseTypeRef();
    const std::string name = expect(TokenKind::Identifier, "a field name").lexeme;
    // A `{` here makes it a property (spec 8.4) rather than a plain field. Inheritance modifiers
    // (override/abstract/final) apply to the property's synthesized accessors, not a plain field.
    if (check(TokenKind::LBrace)) {
        return parseProperty(std::move(visibility), isStatic, std::move(type), name, loc, isAbstract,
                             isOverride, isFinal, inInterface);
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
    f->isComptime = isComptime;  // spec 37.4: the initializer is evaluated during compilation
    f->inRegion = pendingFieldInRegion_;  // spec 18.7, carried only so the analyzer can say it is inert
    pendingFieldInRegion_.clear();
    f->isExternal = isExternal;
    f->isDelegate = isDelegate;
    f->isMovable = isMovable;
    f->isUnique = isUnique;
    f->isWeak = isWeak;
    f->regionFlavor = fieldRegionFlavor;
    f->regionGrowable = fieldRegionGrowable;
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
                                     bool isOverride, bool isFinal, bool inInterface) {
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
    // In an interface a bodyless auto-property is an abstract property CONTRACT, not data: emit an
    // abstract property getter method (+ an abstract `name$set` when it has `set`) so implementers
    // dispatch through the vtable -- exactly like a `get { ... }` interface property (spec 8.4/32).
    // (A plain field here would make interface access read the object's first data slot -- BUG 5.)
    if (inInterface) {
        if (hasSet) {
            auto setter = std::make_unique<ast::MethodDecl>();
            setter->loc = loc; setter->visibility = visibility; setter->isStatic = isStatic;
            setter->isAbstract = true; setter->name = name + "$set";
            ast::Param sp; sp.loc = loc; sp.type = type; sp.name = "value";
            setter->params.push_back(std::move(sp));
            setter->returnType.name = "void";
            extraMembers_.push_back(std::move(setter));
        }
        auto m = std::make_unique<ast::MethodDecl>();
        m->loc = loc; m->visibility = std::move(visibility); m->isStatic = isStatic;
        m->isAbstract = true; m->isProperty = true; m->name = name;
        m->returnType = std::move(type);
        if (hasSet) m->propertySetter = name + "$set";
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

// `public interrupt(Trap t) returns void { }` -- a method the program does not call, because
// something outside it enters the method at a moment the program did not choose.
//
// NAMELESS, like the destructor, which makes it one per class: one device, one handler. That is not
// a limitation to work around, it is the model the kernel already has -- sixteen `Peripheral`
// objects, each owning one IRQ. Two handlers means two objects.
//
// Modeled as a `MethodDecl` named "interrupt" rather than a declaration node of its own. The body is
// an ordinary method body and every pass downstream already knows how to walk one; what makes an
// interrupt different lives at the two edges (nobody may call it, and codegen emits the
// `x86_intrcc` trampoline beside it), not in the middle.
std::unique_ptr<ast::MethodDecl> Parser::parseInterrupt(std::string visibility) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    m->isInterrupt = true;
    m->name = "interrupt";
    expect(TokenKind::KwInterrupt, "'interrupt'");
    expect(TokenKind::LParen, "'(' after 'interrupt' -- an interrupt has no name of its own");
    m->params = parseParams();
    expect(TokenKind::RParen, "')'");
    // At most one, and it is not the compiler being frugal: the CPU pushes ONE frame, so a second
    // parameter would name something no hardware ever supplies and no caller exists to pass.
    if (m->params.size() > 1) {
        fail("an interrupt takes at most one parameter -- the trap the hardware handed over. Nothing "
             "calls an interrupt, so there is nobody to pass a second argument.",
             m->params[1].loc);
    }
    expect(TokenKind::KwReturns, "'returns'");
    m->returnType = parseTypeRef();
    if (m->returnType.name != "void" || m->returnType.isArray) {
        fail("an interrupt must return void -- it is entered, not called, so a returned value would "
             "have nowhere to go. To resume somewhere else, modify the trap.",
             m->returnType.loc);
    }
    currentMethodReturnType_ = m->returnType;
    if (headerMode_ && check(TokenKind::Semicolon)) {
        advance();  // a .ldh signature: the .ldb carries the body
        return m;
    }
    m->body = parseBlock();
    return m;
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
    // [unknown-abi] `unknown <world> funcptr<...>` -- a function pointer INTO a foreign binary; a call
    // THROUGH it uses that world's ABI (e.g. jumping to a Windows PE entry point, or a callback the
    // foreign code will invoke). The world is REQUIRED (never inferred) and is encoded as a leading
    // "$unknown:<world>" element so it survives into the flattened canonical string.
    if (tok.kind == TokenKind::KwUnknown) {
        advance();
        std::string world = expect(TokenKind::Identifier,
            "the foreign world (pe/elf/macho, or raw win64/sysv/aapcs) after 'unknown'").lexeme;
        if (!(current().kind == TokenKind::Identifier && current().lexeme == "funcptr"))
            fail("`unknown <world>` on a type applies only to funcptr (e.g. `unknown pe funcptr<...>`)",
                 current().loc);
        advance();  // 'funcptr'
        std::string nm = "funcptr<$unknown:" + world + ",";
        expect(TokenKind::Lt, "'<' after funcptr");
        std::size_t fn = 0;
        do {
            ast::TypeRef arg = parseTypeRef();
            nm += (fn++ ? "," : "") + ast::canonicalType(arg);
        } while (match(TokenKind::Comma));
        if (current().kind == TokenKind::Shr) { tokens_[pos_].kind = TokenKind::Gt; }
        else { expect(TokenKind::Gt, "'>' to close funcptr type"); }
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
    // `T*[]`: a '*' right before '[' makes the array's ELEMENT a pointer (an array of pointers), distinct
    // from `T[]*` (a pointer to an array). A bare '*' with no following '[' is the ordinary pointer below.
    if (check(TokenKind::Star) && peek(1).kind == TokenKind::LBracket) {
        advance();  // consume the element '*'
        t.arrayElemPointer = true;
    }
    while (match(TokenKind::LBracket)) {  // T[], T[][], ... -- multi-dimensional (spec 25)
        expect(TokenKind::RBracket, "']'");
        t.isArray = true;
        t.arrayDims++;
    }
    // Pointer / reference: share the object instead of copying it. `T*` is a pointer, `T**` a
    // pointer-to-pointer, and so on to any depth (spec 17.8). N-level pointers are supported on
    // non-generic base types only: a generic's mangled name can itself end in '*' (e.g.
    // HashMap<..,T*> -> "HashMap$..T*"), so a second outer '*' would be ambiguous to decode.
    while (match(TokenKind::Star)) {
        t.isPointer = true;
        t.pointerDepth++;
    }
    if (t.pointerDepth >= 2 && !t.typeArgs.empty()) {
        fail("a pointer to a generic type may be only one level deep; '" + t.name +
                 "<...>' with " + std::to_string(t.pointerDepth) +
                 " pointer levels is not representable (its mangled name already ends in '*')",
             t.loc);
    }
    if (t.pointerDepth == 0 && match(TokenKind::Amp)) {
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
        const bool validated = peek(k).kind == TokenKind::Identifier && peek(k).lexeme == "expecting";

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
            expectWord("expecting", "'expecting'");
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
    if (check(TokenKind::KwForeach)) {
        return parseForeachStatement();
    }
    if (check(TokenKind::KwMatch)) {
        return parseMatch();
    }
    if (check(TokenKind::KwSwitch)) {
        return parseSwitch();
    }
    // `demand <cond> otherwise "why";` -- a compile-time check, and a STATEMENT rather than a call.
    // The C++ spelling was a function of two arguments, which put it in the one category this does
    // not belong to: it takes no receiver, returns nothing, and emits nothing. Here it stands beside
    // the other imperative statements -- return, delete, throw, release -- which is what it is.
    if (check(TokenKind::KwDemand)) {
        auto dm = std::make_unique<ast::DemandStmt>();
        dm->loc = current().loc;
        advance();  // 'demand'
        dm->condition = parseExpression();
        expect(TokenKind::KwOtherwise,
               "'otherwise \"...\"' (a demand carries the reason it exists; the condition says what "
               "must hold, the message says why)");
        dm->message = expect(TokenKind::StringLiteral, "the reason, as a string").lexeme;
        expect(TokenKind::Semicolon, "';'");
        return dm;
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
        const std::string& lex = current().lexeme;  // arch + '\x1e' + dialect + '\x1f' + body
        const std::size_t sep = lex.find('\x1f');
        const std::string head = sep == std::string::npos ? std::string() : lex.substr(0, sep);
        a->body = sep == std::string::npos ? lex : lex.substr(sep + 1);
        if (const std::size_t d = head.find('\x1e'); d != std::string::npos) {
            a->arch = head.substr(0, d);
            a->dialect = head.substr(d + 1);  // asm("x86_64", "att") -- explicit dialect
        } else {
            a->arch = head;
        }
        advance();
        // Optional operand clauses, in any order: `out (lv, ...)`, `in (e, ...)`, `clobber ("r", ...)`.
        // Without them the block is a bare instruction sequence (cli/hlt/...), as before.
        for (bool more = true; more;) {
            if (check(TokenKind::Identifier) && current().lexeme == "out") {
                advance();
                expect(TokenKind::LParen, "'(' after 'out' in an asm operand list");
                do { a->outputs.push_back(parseExpression()); } while (match(TokenKind::Comma));
                expect(TokenKind::RParen, "')' to close the asm 'out' list");
            } else if (check(TokenKind::KwIn)) {
                advance();
                expect(TokenKind::LParen, "'(' after 'in' in an asm operand list");
                do { a->inputs.push_back(parseExpression()); } while (match(TokenKind::Comma));
                expect(TokenKind::RParen, "')' to close the asm 'in' list");
            } else if (check(TokenKind::Identifier) && current().lexeme == "clobber") {
                advance();
                expect(TokenKind::LParen, "'(' after 'clobber' in an asm operand list");
                do {
                    a->clobbers.push_back(current().lexeme);
                    expect(TokenKind::StringLiteral, "a register name string in 'clobber'");
                } while (match(TokenKind::Comma));
                expect(TokenKind::RParen, "')' to close the asm 'clobber' list");
            } else {
                more = false;
            }
        }
        match(TokenKind::Semicolon);  // optional -- a bare block needs none
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
            // `cascade release region r` used to die on "expected an expression but found 'region'",
            // which explains the parse and not the mistake. It is not a missing feature: releasing a
            // region ALREADY runs the destructors of the objects inside it, and those destructors
            // release whatever regions those objects own. The recursion the prefix asks for is what
            // the ownership model does by itself, so the honest answer is to say so.
            if (check(TokenKind::KwRegion))
                fail("'cascade' is not needed on 'release region': releasing a region already runs the "
                     "destructors of the objects in it, and those release the regions those objects "
                     "own. Write 'release region ...'.",
                     current().loc);
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
                del->fromRegion = parseRegionName();
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
                del->fromRegion = parseRegionName();
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
    // `snapshot region W into k;` (spec 32.2) -- re-capture into a snapshot that already has a block.
    if (check(TokenKind::Identifier) && current().lexeme == "snapshot" &&
        peek(1).kind == TokenKind::KwRegion) {
        auto st = std::make_unique<ast::SnapshotIntoStmt>();
        st->loc = current().loc;
        advance();  // 'snapshot'
        advance();  // 'region'
        st->region = parseRegionName();
        if (!(check(TokenKind::Identifier) && current().lexeme == "into"))
            fail("expected 'into <snapshot>' after 'snapshot region " + st->region +
                     "'. To declare a new one, write 'RegionSnapshot k = snapshot region " +
                     st->region + " in region <name>;'.",
                 current().loc);
        advance();  // 'into'
        st->into = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        return st;
    }
    // `restore k into W;` / `restore k into region W;` (spec 32.2).
    //
    // A SOFT keyword, and not by preference: pico has a `restore()` METHOD that puts the video mode
    // back (dev/core/hardware.ldp3, dev/display/font.ldp3). `saved.restore()` starts with `saved` and a
    // bare call starts with `restore` followed by '(', so requiring an IDENTIFIER after it tells the
    // two apart exactly, and a hard keyword would have broken the kernel.
    if (check(TokenKind::Identifier) && current().lexeme == "restore" &&
        peek(1).kind == TokenKind::Identifier) {
        auto st = std::make_unique<ast::RestoreStmt>();
        st->loc = current().loc;
        advance();  // 'restore'
        st->snapshot = parseExpression();
        if (!(check(TokenKind::Identifier) && current().lexeme == "into"))
            fail("expected 'into <region>' after 'restore <snapshot>'", current().loc);
        advance();  // 'into'
        match(TokenKind::KwRegion);  // `into region W` and `into W` are both accepted
        st->region = parseRegionName();
        expect(TokenKind::Semicolon, "';'");
        return st;
    }
    if (check(TokenKind::KwRelease)) {
        auto rel = std::make_unique<ast::ReleaseStmt>();
        rel->loc = current().loc;
        advance();  // 'release'
        if (match(TokenKind::KwRegion)) {
            rel->region = parseRegionName();
        } else {
            // `release obj.field;` (spec 18.13/18.15). The `persistent` / `eternal` word is OPTIONAL and
            // carries nothing: the field was already declared persistent, so restating it at the release
            // site resolves no ambiguity -- and this language does not make you repeat what it already
            // knows. Both spellings are accepted so existing code keeps compiling.
            if (!match(TokenKind::KwPersistent)) match(TokenKind::KwEternal);
            rel->isPersistent = true;
            rel->target = parseExpression();
            // `release Session.hits all;` -- every entry the field has, not just this object's key.
            // Without it a program could only ever release the identities it still happened to be
            // holding, which is a leak with extra steps rather than a release.
            if (check(TokenKind::Identifier) && current().lexeme == "all") {
                advance();
                rel->allKeys = true;
            }
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
        rb->region = parseRegionName();
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
         (peek(1).kind == TokenKind::Star && peek(2).kind == TokenKind::Star) ||  // ClassName** p (N-level)
         (peek(1).kind == TokenKind::Star && peek(2).kind == TokenKind::LBracket &&
          peek(3).kind == TokenKind::RBracket && peek(4).kind == TokenKind::Identifier) ||  // ClassName*[] a
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
// A region reference in an operation (`... region R` / `... region this.field`): a local name, or a
// region field reached through `this` (spec 17: region as a field). Mirrors the `new ... in region` form.
std::string Parser::parseRegionName() {
    std::string r;
    if (match(TokenKind::KwThis)) r = "this";
    else r = expect(TokenKind::Identifier, "the region name").lexeme;
    while (match(TokenKind::Dot)) r += "." + expect(TokenKind::Identifier, "a field name").lexeme;
    return r;
}

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

// C#-style iteration: `foreach (T v in coll)`, `foreach (var v in coll)`, or with an index
// `foreach (index i, T v in coll)` (spec 7.6). Identical in effect to the `for (T v in coll)` form --
// LDP3 keeps both spellings so C# and Java/C++ programmers each find the one they expect; they lower
// to the same ForeachStmt.
ast::StmtPtr Parser::parseForeachStatement() {
    const SourceLocation loc = current().loc;
    expect(TokenKind::KwForeach, "'foreach'");
    expect(TokenKind::LParen, "'('");
    auto fe = std::make_unique<ast::ForeachStmt>();
    fe->loc = loc;
    if (match(TokenKind::KwIndex)) {  // optional index variable: `foreach (index i, T v in coll)`
        fe->indexName = expect(TokenKind::Identifier, "an index variable name").lexeme;
        expect(TokenKind::Comma, "',' after the index variable");
    }
    if (match(TokenKind::KwVar)) {
        fe->isVar = true;  // infer the element type
    } else {
        fe->elemType = parseTypeRef();
    }
    fe->varName = expect(TokenKind::Identifier, "a loop variable name").lexeme;
    expect(TokenKind::KwIn, "'in' (foreach iterates as 'foreach (T v in collection)')");
    fe->iterable = parseExpression();
    expect(TokenKind::RParen, "')'");
    fe->body = parseBlock();
    return fe;
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
        // THE BINDINGS ARE OPTIONAL, because an enum constant has nothing to bind.
        //
        // `match` began as dispatch over a sealed hierarchy, where every arm names a type and takes
        // its fields apart -- so the parentheses were required, and `case Grazing { ... }` over an
        // enum failed at the parser with a message about positional field bindings. An enum
        // constant is a value and not a shape: there is nothing inside it to name, and demanding
        // `case Grazing()` would be punctuation standing in for a promise nobody made.
        if (match(TokenKind::LParen)) {
            c.bindings = parseParams();  // (type name, ...) -- may be empty
            expect(TokenKind::RParen, "')'");
        }
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
        if (match(TokenKind::LParen)) {  // optional: an enum constant has nothing to bind
            c.bindings = parseParams();  // (type name, ...) -- may be empty
            expect(TokenKind::RParen, "')'");
        }
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
    // ONE loop, not a fixed sequence. This used to be `[persistent|eternal|volatile|lazy]*` followed
    // by `[final|mutable]`, which silently lost anything written after `mutable`: in
    // `mutable volatile int x` the loop had already finished, `mutable` was consumed, and `volatile`
    // was handed to parseTypeRef -- so the declaration compiled to a PLAIN store with nothing said.
    // A local now collects its modifiers in any order and has them checked, by the same rules a class
    // member obeys (spec 37.9), so a wrong order is a message instead of a missing guarantee.
    const std::size_t modFrom = pos_;
    bool sawFinal = false;
    for (;;) {
        if (match(TokenKind::KwPersistent)) { decl->isPersistent = true; continue; }
        if (match(TokenKind::KwEternal))    { decl->isEternal = true;    continue; }  // eternal [persistent]
        if (match(TokenKind::KwVolatile))   { decl->isVolatile = true;   continue; }  // spec 37.5
        if (match(TokenKind::KwLazy))       { decl->isLazy = true;       continue; }  // spec 37.3
        if (match(TokenKind::KwFinal))      { sawFinal = true;           continue; }
        if (match(TokenKind::KwMutable))    { decl->isMutable = true;    continue; }
        break;
    }
    checkMemberModifiers(modFrom, pos_, MemberShape::Local);
    if (sawFinal) decl->isMutable = false;  // final = explicitly immutable (the default)
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
    // A DECLARATION WITHOUT AN INITIALIZER leaves the variable in the *uninitialized* state -- which is
    // not null and not a zero, but a third state the analyzer tracks until something assigns to it
    // (guide 05-memory-and-ownership.md:640). Reading it before that is a compile error, so nothing is
    // lost by allowing the form; what is gained is the ability to choose a value in a branch without
    // making the binding `mutable` forever.
    //
    // `region r;` (spec 17.2 form 3) used to be the sole special case here, carved out because the
    // general rule was "every variable needs an initializer". It is now just an instance of the rule.
    //
    // `var x;` stays illegal, and for a different reason: `var` infers the type FROM the initializer, so
    // without one there is nothing to infer and the declaration says nothing at all.
    if (check(TokenKind::Semicolon)) {
        if (decl->isVar) {
            fail("'var' infers the type from the initializer, so `var " + decl->name +
                     ";` has nothing to infer from -- write the type (`int " + decl->name +
                     ";`) to declare it uninitialized, or give it a value",
                 decl->loc);
        }
        return decl;  // init stays null: the uninitialized state
    }
    expect(TokenKind::Assign, "'=' (a variable is either initialized here or declared without a value)");
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
        // `step k`, and `step` is a HARD keyword rather than a contextual one -- which is not for
        // want of trying. Matching it by text here works everywhere except where it has to: a
        // numeric literal may carry a UNIT SUFFIX (`64 kilobytes`, spec 3.9), so `10 step` parses as
        // the end of the range with `step` as its suffix, and the count after it has nowhere to go.
        // The two features want the same grammar and only one of them can have it.
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

            // Where this embedded expression actually sits in the file. The sub-parser below lexes
            // `exprSrc` on its own, so every location it reports counts from the start of THAT
            // string -- line 1, column 1. Left alone, the first error a reader sees points at line 1
            // of the file, which is innocent code and the worst possible place to be wrong.
            // `loc` is the '$'; the content starts two characters later, past `$"`. An interpolated
            // string never spans lines (the lexer stops at a newline), so the line is `loc`'s.
            SourceLocation exprLoc = loc;
            exprLoc.col = loc.col + 2 + static_cast<int>(i + 1);  // i+1 == just past the '{'

            Lexer sublex(exprSrc, file_);
            Parser sub(sublex.tokenize(), file_);
            ast::ExprPtr parsed;
            try {
                parsed = sub.parseExpression();
            } catch (const ParseError&) {
                // recorded below via sub.errors()
            }
            bool subReported = false;
            for (ParseError se : sub.errors()) {
                // The sub-parser counted from its own line 1, column 1. Its column is an offset into
                // the embedded expression, so it lands exactly where the fault is once rebased.
                se.loc.col = exprLoc.col + se.loc.col - 1;
                se.loc.line = exprLoc.line;
                se.loc.file = exprLoc.file;
                errors_.push_back(std::move(se));
                subReported = true;
            }
            if (parsed == nullptr) {
                // The sub-parser's own message is the precise one; this generic one only speaks when
                // it said nothing, so a single fault is not reported twice.
                if (subReported) throw errors_.back();
                fail("invalid expression in interpolation: {" + exprSrc + "}", exprLoc);
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
        if (match(TokenKind::KwVolatile)) c->targetVolatile = true;  // cast<volatile T*>: MMIO (spec 37.5)
        const Token& tt = current();
        if (tt.kind == TokenKind::KwFunction || tt.kind == TokenKind::KwUnknown ||  // [unknown-abi]
            (tt.kind == TokenKind::Identifier && tt.lexeme == "funcptr" &&
             peek(1).kind == TokenKind::Lt)) {
            // A function<...> / funcptr<...> / unknown-world-funcptr target carries its own angle
            // brackets: parse the full
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
        return parsePostfixOps(std::move(c));  // allow cast<T*>(x)[i], cast<T>(x).field, cast<T>(x)(args)
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
        mk->region = parseRegionName();
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
        ex->region = parseRegionName();
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
                const std::string rgn = parseRegionName();
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
    // Prefix '&' is address-of (share the object); prefix '*' is pointer dereference (peel one level,
    // e.g. `*pp` on a T** yields a T*); '-' negation; '!' logical not; '~' bitwise not. A leading '*'
    // is only ever a dereference here -- multiplication is binary and never reaches parseUnary in
    // operator position.
    if (check(TokenKind::Minus) || check(TokenKind::Bang) || check(TokenKind::Amp) ||
        check(TokenKind::Tilde) || check(TokenKind::Star)) {
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
    return parsePostfixOps(parsePrimary());
}

// Apply postfix operators -- .member / obj.m<T>(args) / (call) / [index] -- to an already-parsed base
// expression, left to right. Shared by parsePostfix and by cast<T>(x), so `cast<T*>(x)[i]`,
// `cast<T>(x).field` and `cast<T>(x)(args)` all chain like any other primary.
ast::ExprPtr Parser::parsePostfixOps(ast::ExprPtr base) {
    ast::ExprPtr expr = std::move(base);
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
            // `Memory.sizeof(T)`'s argument names a TYPE (spec issue #7), and a primitive type is a
            // keyword, not an identifier -- so `Memory.sizeof(float)` has no expression to parse and
            // would be a syntax error. Read the type here and carry its canonical spelling as a name;
            // a class or vector name is already an identifier and takes the ordinary path below.
            const auto* calleeMem = dynamic_cast<const ast::MemberExpr*>(expr.get());
            if (calleeMem != nullptr && calleeMem->member == "sizeof" &&
                isTypeKeyword(current().kind)) {
                auto named = std::make_unique<ast::IdentifierExpr>();
                named->loc = current().loc;
                ast::TypeRef t = parseTypeRef();
                named->name = ast::canonicalType(t);
                call->args.push_back(std::move(named));
                call->argNames.emplace_back();
            } else {
                parseCallArgs(*call);
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
            // Generic type arguments in a constraint set (spec 17.3): Box<int>, ArrayList<?>,
            // Pair<int,String>, nested Box<List<int>>. Consumed as a balanced <...> span (the '?'
            // wildcard is accepted here, unlike parseTypeRef).
            if (check(TokenKind::Lt)) {
                int depth = 0;
                do {
                    const Token& tk = current();
                    if (tk.kind == TokenKind::Lt)       { ++depth;    name += "<"; }
                    else if (tk.kind == TokenKind::Gt)  { --depth;    name += ">"; }
                    else if (tk.kind == TokenKind::Shr) { depth -= 2; name += ">>"; }  // '>>' closes two
                    else                                {             name += tk.lexeme; }
                    advance();
                } while (depth > 0 && !check(TokenKind::EndOfFile));
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
    // `snapshot region W in region B` (spec 32.2) -- capture W into a block placed in B, yield the
    // handle. A SOFT keyword: this is only a snapshot when `region` follows, so `snapshot` stays an
    // ordinary name everywhere else. The address is not optional: a snapshot of a 64 MiB region is
    // 64 MiB, and in this language those bytes have an owner or they do not exist.
    if (tok.kind == TokenKind::Identifier && tok.lexeme == "snapshot" &&
        peek(1).kind == TokenKind::KwRegion) {
        auto e = std::make_unique<ast::SnapshotExpr>();
        e->loc = tok.loc;
        advance();  // 'snapshot'
        advance();  // 'region'
        e->region = parseRegionName();
        if (!match(TokenKind::KwIn))
            fail("a snapshot needs somewhere to live: write 'snapshot region " + e->region +
                     " in region <name>'. The bytes are the caller's, and releasing them is too.",
                 current().loc);
        expect(TokenKind::KwRegion, "'region' after 'in'");
        e->home = parseRegionName();
        return e;
    }
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
        case TokenKind::StringLiteral:
        case TokenKind::BytesLiteral: {
            auto e = std::make_unique<ast::StringLiteralExpr>();
            e->loc = tok.loc;
            e->value = tok.lexeme;
            e->isBytes = (tok.kind == TokenKind::BytesLiteral);
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
        case TokenKind::KwItself: {
            // `itself.allocate(...)` / `.at(...)` / `.atMultiple(...)` is the region initializer
            // (spec 17.2-17.3, 17.9). It is NOT a special case of the pronoun -- it is an instance of
            // it: `itself.` names the declared entity's TYPE, and for a `region` those three are how
            // that type builds one. Only those three names are claimed here; every other
            // `itself.member` is an ordinary access on the declared type, resolved in the
            // implicit-this pass where the declaration's type is still in hand.
            if (peek(1).kind == TokenKind::Dot && peek(2).kind == TokenKind::Identifier &&
                (peek(2).lexeme == "allocate" || peek(2).lexeme == "at" ||
                 peek(2).lexeme == "atMultiple"))
                return parseRegionInit();
            // BARE `itself` is the self-reference pronoun the keyword reference already describes:
            // "refers to the entity being declared". Inside a lambda that entity is the lambda, so
            // `itself(...)` is how an anonymous function recurses.
            //
            // It has no workaround. Naming the variable the lambda is being assigned to does not
            // compile -- that variable holds nothing until the lambda value exists, so the body
            // referring to it is a use of something not yet initialized. Recursive anonymous
            // functions were simply unwritable.
            //
            // Parsed as an identifier so `parsePostfix` builds the CallExpr; `itself` is a keyword,
            // so no user name can collide with it.
            auto e = std::make_unique<ast::IdentifierExpr>();
            e->loc = tok.loc;
            // IN A PROCEDURE -- in the transformer or in the type that applies it -- `itself` IS
            // THE RECEIVER, so it is written as `this` here rather than substituted later. In a
            // TYPE position `itself` stays the word and the expansion binds it to the applying
            // type's name. Two jobs for one word, and they are genuinely two: `itself.degrees` is
            // an object, `returns itself` is a type. Resolving the expression case at the parse
            // site is what keeps the substitution map honest -- doing it there instead turned
            // `itself.label()` into the STATIC call `Dog.label()`.
            e->name = (inTransformer_ || inProcedure_) ? "this" : "itself";
            advance();
            return e;
        }
        case TokenKind::KwCall: {
            // `call T.p(args)` -- reach the TRANSFORMER's body rather than this type's override.
            // The word exists because there is no receiver to write to the left of the dot: a
            // transformer is not a value, so `T.p()` would be a static call on a type that is not
            // one. It means *"my type replaced this, and I want the original anyway"*.
            //
            // Desugared right here to `this.T$p(args)`, which is where the expansion pass copied
            // the transformer's own body. No new AST node and no codegen: the feature is a name.
            advance();  // call
            const std::string transformer = expect(TokenKind::Identifier, "a transformer name").lexeme;
            expect(TokenKind::Dot, "'.' after the transformer name");
            const SourceLocation procLoc = current().loc;
            const std::string proc = expectMemberName("a procedure name");
            pendingProcCalls_.push_back({transformer, proc, procLoc});
            auto self = std::make_unique<ast::IdentifierExpr>();
            self->loc = tok.loc;
            self->name = "this";
            auto m = std::make_unique<ast::MemberExpr>();
            m->loc = tok.loc;
            m->object = std::move(self);
            m->member = transformer + "$" + proc;
            return m;  // parsePostfixOps attaches the argument list
        }
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
    expectWord("expecting", "'expecting'");
    e->expecting = parseExpectingTail(e->usingVars);
    return e;
}

ast::ExprPtr Parser::parseNew() {
    const SourceLocation loc = current().loc;
    expect(TokenKind::KwNew, "'new'");
    // `new nullable T*[n]()` -- an array whose elements are OPTIONAL pointers.
    //
    // A field could be declared `nullable T*[]` and there was no way to construct one, which is the
    // gap shape that keeps turning up: the language accepts the declaration and then offers no
    // expression that produces a value for it. It matters for every table of slots in a kernel -- a
    // scheduler's processes, a registry's devices, a handle table -- where "this slot is empty" is a
    // normal state and the honest type for it is `nullable`. Without this the arrays held raw
    // `address` with 0 for empty and a cast at every read, which is the exact hole in the type system
    // the `nullable` keyword exists to close.
    //
    // `nullable` is dropped from the element type name rather than carried: an element slot is
    // pointer-sized either way, and null IS the zero the array is already initialised to. It is the
    // DECLARED type that makes the caller check, and that is on the field, not here.
    if (check(TokenKind::KwNullable)) advance();
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

    // Element-pointer array: new T*[n]() -- an array whose elements are pointers (T*), distinct from a
    // plain new T[n](). Fold the '*' into the element type name so codegen stores pointer-sized slots.
    if (check(TokenKind::Star) && peek(1).kind == TokenKind::LBracket) {
        advance();  // '*'
        typeName += "*";
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
        // `in region R`, the same suffix an object new takes and for the same reason: a region owns
        // whatever its accepts/rejects allow, and nothing about an array makes that a different question.
        if (match(TokenKind::KwIn)) {
            expect(TokenKind::KwRegion, "'region' after 'in'");
            arr->region = parseRegionName();
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
        e->region = parseRegionName();  // a local name or a `this.field` region (spec 17)
    }
    return e;
}

}  // namespace ldp3
