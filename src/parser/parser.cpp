#include "parser/parser.h"

#include <utility>

#include "lexer/lexer.h"

namespace ldp3 {

namespace {

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
        case TokenKind::EqEq:
        case TokenKind::BangEq:
            return 3;
        case TokenKind::Lt:
        case TokenKind::Gt:
        case TokenKind::LtEq:
        case TokenKind::GtEq:
            return 4;
        case TokenKind::Plus:
        case TokenKind::Minus:
            return 5;
        case TokenKind::Star:
        case TokenKind::Slash:
        case TokenKind::Percent:
            return 6;
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
    return program;
}

ast::Bundle Parser::parseBundle() {
    ast::Bundle b;
    b.loc = current().loc;
    b.visibility = parseVisibilityOpt();
    expect(TokenKind::KwBundle, "'bundle'");
    b.name = expect(TokenKind::Identifier, "the bundle name").lexeme;
    expect(TokenKind::LBrace, "'{'");
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
            ns.enums.push_back(parseEnum());
        } else {
            ns.classes.push_back(parseClassOrInterface());
        }
    }
    expect(TokenKind::RBrace, "'}'");
    return ns;
}

ast::EnumDecl Parser::parseEnum() {
    ast::EnumDecl e;
    e.loc = current().loc;
    e.visibility = parseVisibilityOpt();
    expect(TokenKind::KwEnum, "'enum'");
    e.name = expect(TokenKind::Identifier, "the enum name").lexeme;
    expect(TokenKind::LBrace, "'{'");
    if (!check(TokenKind::RBrace)) {
        do {
            e.constants.push_back(expect(TokenKind::Identifier, "an enum constant").lexeme);
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::RBrace, "'}'");
    return e;
}

ast::ClassDecl Parser::parseClassOrInterface() {
    ast::ClassDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    if (match(TokenKind::KwAbstract)) c.isAbstract = true;
    if (match(TokenKind::KwMovable)) {
        c.isMovable = true;
    } else if (match(TokenKind::KwUnique)) {
        c.isUnique = true;
    }
    if (match(TokenKind::KwInterface)) {
        c.isInterface = true;
        c.isAbstract = true;  // interfaces are abstract by nature
    } else if (match(TokenKind::KwStruct)) {
        c.isStruct = true;  // value type, no inheritance
    } else {
        expect(TokenKind::KwClass, "'class', 'struct' or 'interface'");
    }
    c.name = expect(TokenKind::Identifier, "the type name").lexeme;
    if (match(TokenKind::KwExtends)) {
        if (c.isStruct) fail("a struct cannot extend another type (structs have no inheritance)",
                             c.loc);
        c.superclass = expect(TokenKind::Identifier, "a superclass name").lexeme;
    }
    if (match(TokenKind::KwImplements)) {
        do {
            c.interfaces.push_back(expect(TokenKind::Identifier, "an interface name").lexeme);
        } while (match(TokenKind::Comma));
    }
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        c.members.push_back(parseMember(c.isInterface));
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
        break;
    }
    if (check(TokenKind::KwMethod)) {
        return parseMethod(std::move(visibility), isStatic, isAbstract, isOverride, isFinal,
                           inInterface);
    }
    if (check(TokenKind::KwConstructor)) {
        return parseConstructor(std::move(visibility));
    }
    if (check(TokenKind::KwDestructor)) {
        return parseDestructor(std::move(visibility));
    }
    // Otherwise it is a field:  <type> <name> ;
    return parseField(std::move(visibility), isStatic, isMutable);
}

std::unique_ptr<ast::MethodDecl> Parser::parseMethod(std::string visibility, bool isStatic,
                                                     bool isAbstract, bool isOverride, bool isFinal,
                                                     bool inInterface) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    m->isStatic = isStatic;
    m->isAbstract = isAbstract || inInterface;  // interface methods are abstract
    m->isOverride = isOverride;
    m->isFinal = isFinal;
    expect(TokenKind::KwMethod, "'method'");
    m->name = expect(TokenKind::Identifier, "the method name").lexeme;
    expect(TokenKind::LParen, "'('");
    m->params = parseParams();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::KwReturns, "'returns'");
    m->returnType = parseTypeRef();
    if (m->isAbstract) {
        expect(TokenKind::Semicolon, "';' (an abstract method has no body)");
    } else {
        m->body = parseBlock();
    }
    return m;
}

ast::MemberPtr Parser::parseField(std::string visibility, bool isStatic, bool isMutable) {
    auto f = std::make_unique<ast::FieldDecl>();
    f->loc = current().loc;
    f->visibility = std::move(visibility);
    f->isStatic = isStatic;
    f->isMutable = isMutable;
    f->type = parseTypeRef();
    f->name = expect(TokenKind::Identifier, "a field name").lexeme;
    if (match(TokenKind::Assign)) {
        f->init = parseExpression();  // inline field initializer (spec 940)
    }
    expect(TokenKind::Semicolon, "';'");
    return f;
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
    if (isTypeKeyword(tok.kind) || tok.kind == TokenKind::Identifier) {
        t.name = tok.lexeme;
        advance();
    } else {
        fail("expected a type but found '" + tok.lexeme + "'", tok.loc);
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

ast::StmtPtr Parser::parseStatement() {
    if (check(TokenKind::KwIf)) {
        return parseIfStatement();
    }
    if (check(TokenKind::KwWhile)) {
        return parseWhileStatement();
    }
    if (check(TokenKind::KwFor)) {
        return parseForStatement();
    }
    if (check(TokenKind::KwReturn)) {
        auto ret = std::make_unique<ast::ReturnStmt>();
        ret->loc = current().loc;
        advance();
        if (!check(TokenKind::Semicolon)) {
            ret->value = parseExpression();
        }
        expect(TokenKind::Semicolon, "';'");
        return ret;
    }
    if (check(TokenKind::KwDelete)) {
        auto del = std::make_unique<ast::DeleteStmt>();
        del->loc = current().loc;
        advance();
        del->target = parseExpression();
        expect(TokenKind::Semicolon, "';'");
        return del;
    }
    if (check(TokenKind::KwDefer)) {
        return parseDefer();
    }
    if (check(TokenKind::KwUsing)) {
        return parseUsing();
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
    if (check(TokenKind::KwMutable) || check(TokenKind::KwVar) ||
        isTypeKeyword(current().kind) || classVarDecl) {
        return parseVarDecl();
    }
    return parseExprStatement();
}

ast::StmtPtr Parser::parseIfStatement() {
    auto s = std::make_unique<ast::IfStmt>();
    s->loc = current().loc;
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

ast::StmtPtr Parser::parseForStatement() {
    auto s = std::make_unique<ast::ForStmt>();
    s->loc = current().loc;
    expect(TokenKind::KwFor, "'for'");
    expect(TokenKind::LParen, "'('");
    if (check(TokenKind::KwMutable) || check(TokenKind::KwVar) ||
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

std::unique_ptr<ast::VarDeclStmt> Parser::parseVarDeclCore() {
    auto decl = std::make_unique<ast::VarDeclStmt>();
    decl->loc = current().loc;
    decl->isMutable = match(TokenKind::KwMutable);
    if (match(TokenKind::KwVar)) {
        decl->isVar = true;
    } else {
        decl->type = parseTypeRef();
    }
    decl->name = expect(TokenKind::Identifier, "a variable name").lexeme;
    expect(TokenKind::Assign, "'=' (variables require an initializer)");
    decl->init = parseExpression();
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

ast::ExprPtr Parser::parseExpression() { return parseBinary(1); }

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
    // Prefix '&' is address-of (share the object); '-' negation; '!' logical not.
    if (check(TokenKind::Minus) || check(TokenKind::Bang) || check(TokenKind::Amp)) {
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
            m->member = expect(TokenKind::Identifier, "a member name").lexeme;
            m->object = std::move(expr);
            expr = std::move(m);
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

ast::ExprPtr Parser::parsePrimary() {
    const Token& tok = current();
    switch (tok.kind) {
        case TokenKind::IntLiteral: {
            auto e = std::make_unique<ast::IntLiteralExpr>();
            e->loc = tok.loc;
            e->text = tok.lexeme;
            advance();
            return e;
        }
        case TokenKind::FloatLiteral: {
            auto e = std::make_unique<ast::FloatLiteralExpr>();
            e->loc = tok.loc;
            e->text = tok.lexeme;
            advance();
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
        case TokenKind::LParen: {
            advance();
            ast::ExprPtr inner = parseExpression();
            expect(TokenKind::RParen, "')'");
            return inner;
        }
        case TokenKind::KwNew:
            return parseNew();
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
        typeName = advance().lexeme;
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

    // Object form: new T(args) [on stack|heap]
    auto e = std::make_unique<ast::NewExpr>();
    e->loc = loc;
    e->className = std::move(typeName);
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
    return e;
}

}  // namespace ldp3
