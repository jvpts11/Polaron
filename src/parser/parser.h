#pragma once

#include <cstddef>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

#include "lexer/token.h"
#include "parser/ast.h"

namespace ldp3 {

// A syntax diagnostic with location.
struct ParseError {
    std::string message;
    SourceLocation loc;
};

// Recursive-descent parser over the token stream produced by the lexer.
// Release 0.1 / walking skeleton scope: program -> bundle -> namespace ->
// class -> method, with expression/return statements and postfix
// (member/call) expressions. Binary operators, fields, control flow, etc.
// join in later phases.
//
// On a syntax error the parser records it and stops (panic mode); the
// returned Program may be partial. Recovery comes later.
class Parser {
public:
    Parser(std::vector<Token> tokens, std::string_view file);

    // Header mode: parsing a .ldh (a bundle's public API). Methods and constructors may be signatures
    // with no body (`...;`), like an interface; their implementations live in the .ldb. Call before
    // parse().
    void setHeaderMode(bool headerMode) { headerMode_ = headerMode; }

    ast::Program parse();

    bool hasErrors() const { return !errors_.empty(); }
    const std::vector<ParseError>& errors() const { return errors_; }

private:
    const Token& peek(int ahead = 0) const;
    const Token& current() const;
    bool check(TokenKind kind) const;
    bool match(TokenKind kind);
    const Token& advance();
    const Token& expect(TokenKind kind, const char* what);
    [[noreturn]] void fail(const std::string& message, SourceLocation loc);

    std::string parseVisibilityOpt();
    std::string parseDottedName();

    ast::Bundle parseBundle();
    ast::ImportDecl parseImportDecl();
    ast::Namespace parseNamespace();
    ast::ClassDecl parseClassOrInterface();
    ast::ClassDecl parseRecord();
    ast::EnumDecl parseEnum();
    ast::CatalogDecl parseCatalog();
    ast::LiteralDecl parseLiteral();
    std::unique_ptr<ast::LiteralDecl> parseLiteralMember(std::string visibility, bool isComptime);
    std::unique_ptr<ast::ConstDecl> parseConstMember(std::string visibility);
    void parseExternInto(std::vector<ast::ExternDecl>& out);  // single method or a `library { }` block
    ast::ExternDecl parseExternMethod(const std::string& convention);
    ast::ConstDecl parseConstDecl();
    ast::TypeAliasDecl parseTypeAlias();
    std::vector<ast::AnnotationUse> parseAnnotationUsesOpt();
    ast::AnnotationDecl parseAnnotationDecl(const std::vector<ast::AnnotationUse>& leading);
    ast::MemberPtr parseMember(bool inInterface);
    std::unique_ptr<ast::MethodDecl> parseMethod(std::string visibility, bool isStatic,
                                                 bool isAbstract, bool isOverride, bool isFinal,
                                                 bool inInterface, bool isComptime = false,
                                                 bool isAsync = false, bool isVolatile = false,
                                                 bool isExtern = false,
                                                 std::string externConvention = "");
    ast::MemberPtr parseField(std::string visibility, bool isStatic, bool isMutable,
                              bool isPersistent, bool isEternal, bool isTransient,
                              bool isVolatile = false, bool isLazy = false,
                              bool isExternal = false, bool isMovable = false,
                              bool isUnique = false);
    // Optional `cascade(...)` parameters (spec 37.1): `(depth: N)`, `(unlimited)`,
    // `(types: {A,B})`, `(except: {A,B})`, or combinations. Returns defaults if no `(`.
    ast::CascadeParams parseCascadeParamsOpt();
    // Parses a label reference `label` (spec 7.9-7.11). The chaos tetrad is intra-method only, so a
    // method-qualified `method.label` form is rejected.
    void parseLabelRef(std::string& name);
    ast::MemberPtr parseProperty(std::string visibility, bool isStatic, ast::TypeRef type,
                                 const std::string& name, SourceLocation loc);
    std::vector<ast::MemberPtr> extraMembers_;  // members synthesized by parseProperty (setters)
    std::unique_ptr<ast::ConstructorDecl> parseConstructor(std::string visibility);
    std::unique_ptr<ast::DestructorDecl> parseDestructor(std::string visibility);
    std::unique_ptr<ast::MethodDecl> parseOperator(std::string visibility);
    ast::ExprPtr parseNew();
    ast::ExprPtr parseUnimportExpr();  // `unimport X expecting [using ...] { ... }` (spec 30.18)
    // Parses `[using a, b] { ... }` after `expecting`; fills usingVars and returns the block.
    std::unique_ptr<ast::Block> parseExpectingTail(std::vector<std::string>& usingVars);
    std::vector<ast::Param> parseParams();
    ast::TypeRef parseTypeRef();
    ast::Block parseBlock();
    ast::StmtPtr parseStatement();
    bool looksLikeGenericVarDecl() const;
    bool looksLikeGenericCall() const;
    bool looksLikeTupleDestructuring() const;
    ast::StmtPtr parseTupleDecl();
    ast::StmtPtr parseIfStatement(bool isComptime = false);
    ast::StmtPtr parseWhileStatement();
    ast::StmtPtr parseDoStatement();
    ast::StmtPtr parseForStatement();
    ast::StmtPtr parseMatch();
    ast::StmtPtr parseSwitch();
    ast::StmtPtr parseDefer();
    ast::StmtPtr parseUsing();
    ast::StmtPtr parseSynchronized();
    ast::StmtPtr parseVarDecl();
    std::unique_ptr<ast::VarDeclStmt> parseVarDeclCore();   // no trailing ';'
    ast::StmtPtr parseExprStatement();                      // assignment/inc-dec/expr + ';'
    ast::StmtPtr parseSimpleStatement();                    // same, without ';'
    ast::ExprPtr parseExpression();
    ast::ExprPtr parseInterpolation(const std::string& raw, SourceLocation loc);
    ast::ExprPtr parseTernary();
    ast::ExprPtr parseBinary(int minPrec);
    ast::ExprPtr parseUnary();
    ast::ExprPtr parsePostfix();
    ast::ExprPtr parsePrimary();
    ast::ExprPtr maybeLiteralSuffix(ast::ExprPtr literal);
    ast::ExprPtr parseRegionInit();
    ast::ExprPtr parseMatchExpr();   // match(...) { case T(..) -> expr; ... } as a value
    void parseTypeSet(std::vector<std::string>& out);

    std::vector<Token> tokens_;
    std::string_view file_;
    std::size_t pos_ = 0;
    std::vector<ParseError> errors_;
    ast::TypeRef currentMethodReturnType_;  // for the Ok(x)/Err(x)/... return-value sugar (spec 21.2)
    bool looksLikeQualifiedVarDecl() const;  // `app.Box b` / `app.Box* p`
    bool sawQualifiedType_ = false;         // a `ns.Type` reference was parsed (spec 15)
    bool parsingEnsures_ = false;           // inside an `ensures` clause -> `old(...)` is allowed (spec 29)
    bool headerMode_ = false;               // parsing a .ldh: method/constructor bodies may be absent
};

}  // namespace ldp3
