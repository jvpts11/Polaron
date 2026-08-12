#include "lexer/lexer.h"

#include <cctype>
#include <unordered_map>
#include <utility>

namespace ldp3 {

namespace {

bool isIdentStart(char c) {
    return std::isalpha(static_cast<unsigned char>(c)) || c == '_';
}
bool isIdentCont(char c) {
    return std::isalnum(static_cast<unsigned char>(c)) || c == '_';
}
bool isDigit(char c) { return c >= '0' && c <= '9'; }

// Maps an identifier spelling to its keyword kind, or Identifier if it is not
// a reserved word. Only the Release 0.1 subset is reserved here; later phases
// extend this table as features land.
TokenKind keywordKind(std::string_view text) {
    static const std::unordered_map<std::string_view, TokenKind> kw = {
        {"program", TokenKind::KwProgram},
        {"bundle", TokenKind::KwBundle},
        {"namespace", TokenKind::KwNamespace},
        {"class", TokenKind::KwClass},
        {"interface", TokenKind::KwInterface},
        {"layout", TokenKind::KwLayout},
        {"struct", TokenKind::KwStruct},
        {"record", TokenKind::KwRecord},
        {"union", TokenKind::KwUnion},
        {"enum", TokenKind::KwEnum},
        {"catalog", TokenKind::KwCatalog},
        {"byCatalog", TokenKind::KwByCatalog},
        {"method", TokenKind::KwMethod},
        {"operator", TokenKind::KwOperator},
        {"constructor", TokenKind::KwConstructor},
        {"destructor", TokenKind::KwDestructor},
        {"interrupt", TokenKind::KwInterrupt},
        {"transformer", TokenKind::KwTransformer},
        {"applies", TokenKind::KwApplies},
        {"procedure", TokenKind::KwProcedure},
        {"call", TokenKind::KwCall},
        {"returns", TokenKind::KwReturns},
        {"return", TokenKind::KwReturn},
        {"public", TokenKind::KwPublic},
        {"private", TokenKind::KwPrivate},
        {"protected", TokenKind::KwProtected},
        {"internal", TokenKind::KwInternal},
        {"static", TokenKind::KwStatic},
        {"abstract", TokenKind::KwAbstract},
        {"final", TokenKind::KwFinal},
        {"override", TokenKind::KwOverride},
        {"mutable", TokenKind::KwMutable},
        {"nullable", TokenKind::KwNullable},
        {"sealed", TokenKind::KwSealed},
        {"permits", TokenKind::KwPermits},
        {"requires", TokenKind::KwRequires},
        {"ensures", TokenKind::KwEnsures},
        {"invariant", TokenKind::KwInvariant},
        {"demand", TokenKind::KwDemand},
        {"otherwise", TokenKind::KwOtherwise},
        {"extends", TokenKind::KwExtends},
        {"implements", TokenKind::KwImplements},
        {"this", TokenKind::KwThis},
        {"super", TokenKind::KwSuper},
        {"var", TokenKind::KwVar},
        {"new", TokenKind::KwNew},
        {"delete", TokenKind::KwDelete},
        {"on", TokenKind::KwOn},
        {"in", TokenKind::KwIn},
        {"is", TokenKind::KwIs},
        {"as", TokenKind::KwAs},
        {"cast", TokenKind::KwCast},
        {"null", TokenKind::KwNull},
        {"move", TokenKind::KwMove},
        {"movable", TokenKind::KwMovable},
        {"unique", TokenKind::KwUnique},
        {"weak", TokenKind::KwWeak},
        {"partitionable", TokenKind::KwPartitionable},
        {"region", TokenKind::KwRegion},
        {"of", TokenKind::KwOf},
        {"accepts", TokenKind::KwAccepts},
        {"rejects", TokenKind::KwRejects},
        {"defer", TokenKind::KwDefer},
        {"using", TokenKind::KwUsing},
        {"synchronized", TokenKind::KwSynchronized},
        {"async", TokenKind::KwAsync},
        {"await", TokenKind::KwAwait},
        {"extern", TokenKind::KwExtern},
        {"cdecl", TokenKind::KwCdecl},
        {"stdcall", TokenKind::KwStdcall},
        {"fastcall", TokenKind::KwFastcall},
        {"unknown", TokenKind::KwUnknown},
        {"freestanding", TokenKind::KwFreestanding},
        {"naked", TokenKind::KwNaked},
        {"itself", TokenKind::KwItself},
        {"release", TokenKind::KwRelease},
        {"persistent", TokenKind::KwPersistent},
        {"eternal", TokenKind::KwEternal},
        {"transient", TokenKind::KwTransient},
        {"deprecated", TokenKind::KwDeprecated},
        {"partial", TokenKind::KwPartial},
        {"lambda", TokenKind::KwLambda},
        {"function", TokenKind::KwFunction},
        {"methodref", TokenKind::KwMethodref},
        {"typealias", TokenKind::KwTypealias},
        {"newtype", TokenKind::KwNewtype},
        {"annotation", TokenKind::KwAnnotation},
        {"label", TokenKind::KwLabel},
        {"comefrom", TokenKind::KwComefrom},
        {"goto", TokenKind::KwGoto},
        {"abstainfrom", TokenKind::KwAbstainfrom},
        {"reinstate", TokenKind::KwReinstate},
        {"unimport", TokenKind::KwUnimport},
        {"reimport", TokenKind::KwReimport},
        // NOTE: `expecting` is a SOFT keyword -- recognized by the unimport/reimport parser, in the
        // one position it can appear in (after the dotted type name), and an ordinary identifier
        // everywhere else. It was hard, and it took a word an ordinary program wants: a `Body` in
        // the agent layout has `byte expecting` for how many children are coming, which would not
        // parse. Unlike `step` there is nothing to be ambiguous with -- it follows a NAME, not a
        // numeric literal, so no unit suffix can claim it.
        {"onFailure", TokenKind::KwOnFailure},
        {"yield", TokenKind::KwYield},
        {"try", TokenKind::KwTry},
        {"catch", TokenKind::KwCatch},
        {"finally", TokenKind::KwFinally},
        {"throw", TokenKind::KwThrow},
        {"throws", TokenKind::KwThrows},
        {"comptime", TokenKind::KwComptime},
        {"literal", TokenKind::KwLiteral},
        {"import", TokenKind::KwImport},
        {"fixed", TokenKind::KwFixed},
        {"volatile", TokenKind::KwVolatile},
        {"cascade", TokenKind::KwCascade},
        {"lazy", TokenKind::KwLazy},
        {"external", TokenKind::KwExternal},
        {"delegate", TokenKind::KwDelegate},
        // NOTE: get / set / init are soft keywords -- recognized contextually in
        // a property body (parseProperty), not reserved, so `method get()` works.
        {"if", TokenKind::KwIf},
        {"else", TokenKind::KwElse},
        {"while", TokenKind::KwWhile},
        {"do", TokenKind::KwDo},
        {"for", TokenKind::KwFor},
        {"foreach", TokenKind::KwForeach},
        {"switch", TokenKind::KwSwitch},
        {"match", TokenKind::KwMatch},
        {"case", TokenKind::KwCase},
        {"default", TokenKind::KwDefault},
        {"break", TokenKind::KwBreak},
        {"continue", TokenKind::KwContinue},
        // `step` IS HARD, AND IT WAS TRIED AS A SOFT ONE. It costs every program a natural name --
        // `float step = ...` for a distance walked in one go is a parse error -- so it was made
        // contextual, matched by text after `a..b` where nothing else may follow. It does not work,
        // and the reason is a feature one file away: a numeric literal may take a UNIT SUFFIX
        // (`64 kilobytes`, spec 3.9), which is exactly the shape `10 step`. As an identifier, `step`
        // is eaten as the suffix of the range's end and the count after it has nowhere to go --
        // `for (int i in 0..10 step 2)` fails on the `2`. The two features want the same grammar,
        // and a keyword is the cheaper of them to give up. Left reserved on purpose; see the note
        // in parseExpression.
        {"step", TokenKind::KwStep},
        {"index", TokenKind::KwIndex},
        {"void", TokenKind::KwVoid},
        {"boolean", TokenKind::KwBoolean},
        {"char", TokenKind::KwChar},
        {"string", TokenKind::KwString},
        {"String", TokenKind::KwStringClass},
        {"int", TokenKind::KwInt},
        {"int8", TokenKind::KwInt8},
        {"int16", TokenKind::KwInt16},
        {"int32", TokenKind::KwInt32},
        {"int64", TokenKind::KwInt64},
        {"uint8", TokenKind::KwUint8},
        {"uint16", TokenKind::KwUint16},
        {"uint32", TokenKind::KwUint32},
        {"uint64", TokenKind::KwUint64},
        {"short", TokenKind::KwShort},
        {"long", TokenKind::KwLong},
        {"byte", TokenKind::KwByte},
        {"float", TokenKind::KwFloat},
        {"double", TokenKind::KwDouble},
        {"float32", TokenKind::KwFloat32},
        {"float64", TokenKind::KwFloat64},
        {"true", TokenKind::KwTrue},
        {"false", TokenKind::KwFalse},
    };
    auto it = kw.find(text);
    return it == kw.end() ? TokenKind::Identifier : it->second;
}

}  // namespace

Lexer::Lexer(std::string_view source, std::string_view file, bool keepComments)
    : source_(source), file_(file), keepComments_(keepComments) {
    // Skip a leading UTF-8 BOM (EF BB BF): many Windows editors (Notepad, some VS Code / PowerShell
    // configs) save source with one, and it must not surface as a stray lex error on the first character.
    if (source_.size() >= 3 && static_cast<unsigned char>(source_[0]) == 0xEF &&
        static_cast<unsigned char>(source_[1]) == 0xBB && static_cast<unsigned char>(source_[2]) == 0xBF) {
        source_.remove_prefix(3);
    }
}

void Lexer::skipWhitespace() {
    while (!atEnd()) {
        const char c = peek();
        if (c == ' ' || c == '\t' || c == '\r' || c == '\n') advance();
        else break;
    }
}

bool Lexer::tryComment(Token& out) {
    const char c = peek();
    if (c == '/' && peek(1) == '/') {  // // or /// line comment: keep the whole line's text
        const SourceLocation loc = here();
        std::string text;
        while (!atEnd() && peek() != '\n') text += advance();
        while (!text.empty() && text.back() == '\r') text.pop_back();
        out = make(TokenKind::Comment, std::move(text), loc);
        return true;
    }
    if (c == '/' && peek(1) == '*') {  // /* ... */ block comment
        const SourceLocation loc = here();
        std::string text;
        text += advance();  // '/'
        text += advance();  // '*'
        bool closed = false;
        while (!atEnd()) {
            if (peek() == '*' && peek(1) == '/') {
                text += advance();
                text += advance();
                closed = true;
                break;
            }
            text += advance();
        }
        if (!closed) error("unterminated block comment", loc);
        out = make(TokenKind::Comment, std::move(text), loc);
        return true;
    }
    return false;
}

bool Lexer::atEnd() const { return pos_ >= source_.size(); }

char Lexer::peek(int ahead) const {
    std::size_t i = pos_ + static_cast<std::size_t>(ahead);
    return i < source_.size() ? source_[i] : '\0';
}

char Lexer::advance() {
    char c = source_[pos_++];
    if (c == '\n') {
        ++line_;
        col_ = 1;
    } else {
        ++col_;
    }
    return c;
}

bool Lexer::match(char expected) {
    if (atEnd() || source_[pos_] != expected) return false;
    advance();
    return true;
}

SourceLocation Lexer::here() const { return SourceLocation{file_, line_, col_}; }

Token Lexer::make(TokenKind kind, std::string lexeme, SourceLocation loc) const {
    return Token{kind, std::move(lexeme), loc};
}

void Lexer::error(std::string message, SourceLocation loc) {
    errors_.push_back(LexError{std::move(message), loc});
}

void Lexer::skipWhitespaceAndComments() {
    for (;;) {
        char c = peek();
        if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
            advance();
        } else if (c == '/' && peek(1) == '/') {
            if (peek(2) == '/') {  // /// documentation comment: capture the text
                const int line = line_;
                advance();  // '/'
                advance();  // '/'
                advance();  // '/'
                if (peek() == ' ') advance();  // drop one conventional leading space
                std::string text;
                while (!atEnd() && peek() != '\n') text += advance();
                while (!text.empty() && (text.back() == '\r' || text.back() == ' ')) text.pop_back();
                docComments_.push_back({line, std::move(text)});
            } else {
                while (!atEnd() && peek() != '\n') advance();  // ordinary line comment
            }
        } else if (c == '/' && peek(1) == '*') {
            SourceLocation start = here();
            advance();  // '/'
            advance();  // '*'
            bool closed = false;
            while (!atEnd()) {
                if (peek() == '*' && peek(1) == '/') {
                    advance();
                    advance();
                    closed = true;
                    break;
                }
                advance();
            }
            if (!closed) error("unterminated block comment", start);
        } else {
            break;
        }
    }
}

std::vector<Token> Lexer::tokenize() {
    std::vector<Token> tokens;
    for (;;) {
        if (keepComments_) {
            skipWhitespace();
            if (atEnd()) {
                tokens.push_back(make(TokenKind::EndOfFile, "", here()));
                break;
            }
            if (Token comment; tryComment(comment)) {
                tokens.push_back(std::move(comment));
                continue;
            }
            // Keep the RAW source text of the token (quotes, escapes) so the formatter re-emits it exactly;
            // the decoded lexeme of a string/char literal drops its quotes.
            const std::size_t startPos = pos_;
            Token t = scanToken();
            t.lexeme = std::string(source_.substr(startPos, pos_ - startPos));
            tokens.push_back(std::move(t));
            continue;
        }
        skipWhitespaceAndComments();
        if (atEnd()) {
            tokens.push_back(make(TokenKind::EndOfFile, "", here()));
            break;
        }
        tokens.push_back(scanToken());
    }
    return tokens;
}

Token Lexer::scanIdentifierOrKeyword() {
    SourceLocation loc = here();
    std::size_t start = pos_;
    while (!atEnd() && isIdentCont(peek())) advance();
    std::string text(source_.substr(start, pos_ - start));
    TokenKind kind = keywordKind(text);
    // Inline assembly (spec issue 1): `asm("arch") { raw }` -- only when `(` follows, so `asm` stays
    // usable as an ordinary identifier elsewhere. The raw body is captured verbatim (the LDP3 lexer
    // does not tokenize it); the token's lexeme is arch + '\x1f' + body.
    // b"..." -- a raw byte-string literal. Only when the quote follows IMMEDIATELY, so an ordinary
    // identifier named `b` is untouched. Yields `byte*` at the bytes, NUL-terminated: what freestanding
    // code needs, since a String object requires a runtime that a kernel does not have.
    if (text == "b" && peek() == '"') {
        Token str = scanString();
        if (str.kind == TokenKind::StringLiteral) str.kind = TokenKind::BytesLiteral;
        str.loc = loc;
        return str;
    }
    if (text == "asm") {
        auto skipWs = [&]() {
            while (!atEnd() && (peek() == ' ' || peek() == '\t' || peek() == '\n' || peek() == '\r'))
                advance();
        };
        std::size_t save = pos_;
        skipWs();
        if (peek() == '(') {
            advance();  // '('
            skipWs();
            if (peek() != '"') {
                error("expected a target string in asm(\"...\")", loc);
                pos_ = save;
                return make(kind, std::move(text), loc);
            }
            advance();  // opening '"'
            std::size_t as = pos_;
            while (!atEnd() && peek() != '"') advance();
            std::string arch(source_.substr(as, pos_ - as));
            if (peek() == '"') advance();  // closing '"'
            skipWs();
            // Optional second string: the assembly DIALECT -- `asm("x86_64", "att") { ... }`. Without it
            // the dialect follows the architecture (Intel on x86, the native syntax elsewhere), which is
            // what an LDP3 asm block is written in; name it explicitly to paste in code written the other
            // way (a GCC/AT&T snippet, say) instead of hand-translating it.
            std::string dialect;
            if (peek() == ',') {
                advance();  // ','
                skipWs();
                if (peek() != '"') {
                    error("expected a dialect string after ',' in asm(\"arch\", \"dialect\")", loc);
                } else {
                    advance();  // opening '"'
                    std::size_t ds = pos_;
                    while (!atEnd() && peek() != '"') advance();
                    dialect = std::string(source_.substr(ds, pos_ - ds));
                    if (peek() == '"') advance();  // closing '"'
                    skipWs();
                }
            }
            if (peek() == ')') advance();
            else error("expected ')' after the asm target", loc);
            skipWs();
            if (peek() != '{') {
                error("expected '{' to open the asm block", loc);
                return make(kind, std::move(text), loc);
            }
            advance();  // '{'
            std::size_t bs = pos_;
            int depth = 1;
            while (!atEnd() && depth > 0) {
                if (peek() == '{') depth++;
                else if (peek() == '}' && --depth == 0) break;
                advance();
            }
            std::string body(source_.substr(bs, pos_ - bs));
            if (peek() == '}') advance();  // closing '}'
            // arch \x1e dialect \x1f body
            return make(TokenKind::AsmBlock, arch + '\x1e' + dialect + '\x1f' + body, loc);
        }
        pos_ = save;  // not an asm block -- `asm` is a plain identifier here
    }
    return make(kind, std::move(text), loc);
}

Token Lexer::scanNumber() {
    SourceLocation loc = here();
    std::size_t start = pos_;
    bool isFloat = false;

    if (peek() == '0' && (peek(1) == 'x' || peek(1) == 'X')) {
        advance();
        advance();
        while (!atEnd() &&
               (std::isxdigit(static_cast<unsigned char>(peek())) || peek() == '_')) {
            advance();
        }
    } else if (peek() == '0' && (peek(1) == 'b' || peek(1) == 'B')) {
        advance();
        advance();
        while (!atEnd() && (peek() == '0' || peek() == '1' || peek() == '_')) advance();
    } else {
        while (!atEnd() && (isDigit(peek()) || peek() == '_')) advance();
        if (peek() == '.' && isDigit(peek(1))) {
            isFloat = true;
            advance();  // '.'
            while (!atEnd() && (isDigit(peek()) || peek() == '_')) advance();
        }
        // Scientific notation: 1.0e30, 1e-9, 6.022E+23. Without this the exponent was not part of the
        // number at all -- `1.0e30` lexed as `1.0` followed by the IDENTIFIER `e30`, which the parser then
        // read as a member access and rejected with "unknown call 'e30'", a message about a method on a
        // line containing no method. An exponent also makes the literal a float on its own: `1e30` has no
        // '.' and is still a double.
        //
        // Only consumed when a digit really follows (after an optional sign), so `1.0exp` keeps lexing as
        // `1.0` then `exp` -- consuming the 'e' of an identifier would turn a typo into a lexer error
        // pointing at the wrong place. Hex is excluded by construction: 'e' is a hex DIGIT, and that
        // branch is handled above.
        if ((peek() == 'e' || peek() == 'E') &&
            (isDigit(peek(1)) || ((peek(1) == '+' || peek(1) == '-') && isDigit(peek(2))))) {
            isFloat = true;
            advance();                                        // 'e' / 'E'
            if (peek() == '+' || peek() == '-') advance();     // optional sign
            while (!atEnd() && (isDigit(peek()) || peek() == '_')) advance();
        }
    }

    char suffix = peek();
    bool isDecimal = false;
    if (suffix == 'f' || suffix == 'F') {
        isFloat = true;
        advance();
    } else if (suffix == 'L' || suffix == 'l') {
        advance();
    } else if (suffix == 'm' || suffix == 'M') {  // Decimal literal (spec 34): 1.50m
        isDecimal = true;
        advance();
    }

    std::string text(source_.substr(start, pos_ - start));
    if (isDecimal) text.pop_back();  // drop the 'm'; keep just the numeric text
    return make(isDecimal  ? TokenKind::DecimalLiteral
                : isFloat  ? TokenKind::FloatLiteral
                           : TokenKind::IntLiteral,
                std::move(text), loc);
}

Token Lexer::scanChar() {
    SourceLocation loc = here();
    advance();  // opening '
    std::string value;
    if (atEnd() || peek() == '\n') {
        error("unterminated char literal", loc);
        return make(TokenKind::Unknown, std::move(value), loc);
    }
    if (peek() == '\'') {
        advance();  // closing '
        error("empty char literal", loc);
        return make(TokenKind::Unknown, std::move(value), loc);
    }
    if (peek() == '\\') {
        value += advance();              // backslash
        if (!atEnd()) value += advance();  // escaped char
    } else {
        value += advance();
    }
    if (!match('\'')) {
        error("unterminated char literal", loc);
        return make(TokenKind::Unknown, std::move(value), loc);
    }
    return make(TokenKind::CharLiteral, std::move(value), loc);
}

Token Lexer::scanString() {
    SourceLocation loc = here();
    advance();  // opening "
    std::string value;
    while (!atEnd() && peek() != '"' && peek() != '\n') {
        if (peek() == '\\') {
            value += advance();              // backslash
            if (!atEnd()) value += advance();  // escaped char
        } else {
            value += advance();
        }
    }
    if (!match('"')) {
        error("unterminated string literal", loc);
        return make(TokenKind::Unknown, std::move(value), loc);
    }
    return make(TokenKind::StringLiteral, std::move(value), loc);
}

// An interpolated string: $"text {expr} more". The raw content between the
// quotes (braces and all) is kept verbatim; the parser splits it into literal
// chunks and embedded expressions.
Token Lexer::scanInterpString() {
    SourceLocation loc = here();
    advance();  // '$'
    advance();  // '"'
    std::string value;
    int braceDepth = 0;  // >0 while inside a {expr} region
    while (!atEnd() && peek() != '\n') {
        char c = peek();
        if (c == '"' && braceDepth == 0) break;  // the interp string's own closing quote
        if (c == '\\') {                         // escape (in literal text or in an expr)
            value += advance();                  // backslash
            if (!atEnd()) value += advance();    // escaped char
            continue;
        }
        if (c == '{') { ++braceDepth; value += advance(); continue; }
        if (c == '}') { if (braceDepth > 0) --braceDepth; value += advance(); continue; }
        if (c == '"') {                          // braceDepth>0: a nested string literal inside {expr}
            value += advance();                  // opening quote, kept verbatim
            while (!atEnd() && peek() != '"' && peek() != '\n') {
                if (peek() == '\\') { value += advance(); if (!atEnd()) value += advance(); }
                else                { value += advance(); }
            }
            if (!atEnd() && peek() == '"') value += advance();  // closing quote
            continue;
        }
        value += advance();
    }
    if (!match('"')) {
        error("unterminated interpolated string", loc);
        return make(TokenKind::Unknown, std::move(value), loc);
    }
    return make(TokenKind::InterpString, std::move(value), loc);
}

Token Lexer::scanToken() {
    SourceLocation loc = here();
    char c = peek();

    if (isIdentStart(c)) return scanIdentifierOrKeyword();
    if (isDigit(c)) return scanNumber();
    if (c == '\'') return scanChar();
    if (c == '"') return scanString();
    if (c == '$' && peek(1) == '"') return scanInterpString();

    advance();  // consume the operator/punctuation lead character
    switch (c) {
        case '(': return make(TokenKind::LParen, "(", loc);
        case ')': return make(TokenKind::RParen, ")", loc);
        case '{': return make(TokenKind::LBrace, "{", loc);
        case '}': return make(TokenKind::RBrace, "}", loc);
        case '@': return make(TokenKind::At, "@", loc);
        case '[': return make(TokenKind::LBracket, "[", loc);
        case ']': return make(TokenKind::RBracket, "]", loc);
        case ';': return make(TokenKind::Semicolon, ";", loc);
        case ',': return make(TokenKind::Comma, ",", loc);
        case '?':
            if (match('?')) return make(TokenKind::QuestionQuestion, "??", loc);  // null-coalescing
            if (match('.')) return make(TokenKind::QuestionDot, "?.", loc);        // safe navigation
            return make(TokenKind::Question, "?", loc);
        case ':': return make(TokenKind::Colon, ":", loc);
        case '~': return make(TokenKind::Tilde, "~", loc);
        case '.':
            if (match('.')) {
                if (match('=')) return make(TokenKind::DotDotEq, "..=", loc);
                return make(TokenKind::DotDot, "..", loc);
            }
            return make(TokenKind::Dot, ".", loc);
        case '+':
            if (match('+')) return make(TokenKind::PlusPlus, "++", loc);
            if (match('=')) return make(TokenKind::PlusEq, "+=", loc);
            return make(TokenKind::Plus, "+", loc);
        case '-':
            if (match('-')) return make(TokenKind::MinusMinus, "--", loc);
            if (match('=')) return make(TokenKind::MinusEq, "-=", loc);
            if (match('>')) return make(TokenKind::Arrow, "->", loc);
            return make(TokenKind::Minus, "-", loc);
        case '*':
            if (match('=')) return make(TokenKind::StarEq, "*=", loc);
            return make(TokenKind::Star, "*", loc);
        case '/':
            if (match('=')) return make(TokenKind::SlashEq, "/=", loc);
            return make(TokenKind::Slash, "/", loc);
        case '%':
            if (match('=')) return make(TokenKind::PercentEq, "%=", loc);
            return make(TokenKind::Percent, "%", loc);
        case '=':
            if (match('=')) return make(TokenKind::EqEq, "==", loc);
            return make(TokenKind::Assign, "=", loc);
        case '!':
            if (match('=')) return make(TokenKind::BangEq, "!=", loc);
            return make(TokenKind::Bang, "!", loc);
        case '<':
            if (match('=')) return make(TokenKind::LtEq, "<=", loc);
            if (match('<')) {
                if (match('=')) return make(TokenKind::ShlEq, "<<=", loc);
                return make(TokenKind::Shl, "<<", loc);
            }
            return make(TokenKind::Lt, "<", loc);
        case '>':
            if (match('=')) return make(TokenKind::GtEq, ">=", loc);
            if (match('>')) {
                if (match('=')) return make(TokenKind::ShrEq, ">>=", loc);
                return make(TokenKind::Shr, ">>", loc);
            }
            return make(TokenKind::Gt, ">", loc);
        case '&':
            if (match('&')) return make(TokenKind::AmpAmp, "&&", loc);
            if (match('=')) return make(TokenKind::AmpEq, "&=", loc);
            return make(TokenKind::Amp, "&", loc);
        case '|':
            if (match('|')) return make(TokenKind::PipePipe, "||", loc);
            if (match('=')) return make(TokenKind::PipeEq, "|=", loc);
            return make(TokenKind::Pipe, "|", loc);
        case '^':
            if (match('=')) return make(TokenKind::CaretEq, "^=", loc);
            return make(TokenKind::Caret, "^", loc);
        default: {
            std::string msg = "unexpected character '";
            msg += c;
            msg += '\'';
            error(msg, loc);
            return make(TokenKind::Unknown, std::string(1, c), loc);
        }
    }
}

}  // namespace ldp3
