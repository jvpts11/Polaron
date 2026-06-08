#include "parser/parser.h"

#include <utility>

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
        case TokenKind::Star:
        case TokenKind::Slash:
        case TokenKind::Percent:
            return 2;
        case TokenKind::Plus:
        case TokenKind::Minus:
            return 1;
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
        ns.classes.push_back(parseClass());
    }
    expect(TokenKind::RBrace, "'}'");
    return ns;
}

ast::ClassDecl Parser::parseClass() {
    ast::ClassDecl c;
    c.loc = current().loc;
    c.visibility = parseVisibilityOpt();
    expect(TokenKind::KwClass, "'class'");
    c.name = expect(TokenKind::Identifier, "the class name").lexeme;
    expect(TokenKind::LBrace, "'{'");
    while (!check(TokenKind::RBrace) && !check(TokenKind::EndOfFile)) {
        c.members.push_back(parseMember());
    }
    expect(TokenKind::RBrace, "'}'");
    return c;
}

ast::MemberPtr Parser::parseMember() {
    std::string visibility = parseVisibilityOpt();
    bool isStatic = match(TokenKind::KwStatic);
    // Other modifiers (abstract/final/override) and member kinds (fields,
    // constructors, destructors) join in later phases.
    if (check(TokenKind::KwMethod)) {
        return parseMethod(std::move(visibility), isStatic);
    }
    fail("expected a class member but found '" + current().lexeme + "'", current().loc);
}

std::unique_ptr<ast::MethodDecl> Parser::parseMethod(std::string visibility, bool isStatic) {
    auto m = std::make_unique<ast::MethodDecl>();
    m->loc = current().loc;
    m->visibility = std::move(visibility);
    m->isStatic = isStatic;
    expect(TokenKind::KwMethod, "'method'");
    m->name = expect(TokenKind::Identifier, "the method name").lexeme;
    expect(TokenKind::LParen, "'('");
    m->params = parseParams();
    expect(TokenKind::RParen, "')'");
    expect(TokenKind::KwReturns, "'returns'");
    m->returnType = parseTypeRef();
    m->body = parseBlock();
    return m;
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
    if (check(TokenKind::KwMutable) || check(TokenKind::KwVar) ||
        isTypeKeyword(current().kind)) {
        return parseVarDecl();
    }
    auto stmt = std::make_unique<ast::ExprStmt>();
    stmt->loc = current().loc;
    stmt->expr = parseExpression();
    expect(TokenKind::Semicolon, "';'");
    return stmt;
}

ast::StmtPtr Parser::parseVarDecl() {
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
    expect(TokenKind::Semicolon, "';'");
    return decl;
}

ast::ExprPtr Parser::parseExpression() { return parseBinary(1); }

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
    if (check(TokenKind::Minus)) {
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
        case TokenKind::LParen: {
            advance();
            ast::ExprPtr inner = parseExpression();
            expect(TokenKind::RParen, "')'");
            return inner;
        }
        default:
            fail("expected an expression but found '" + tok.lexeme + "'", tok.loc);
    }
}

}  // namespace ldp3
