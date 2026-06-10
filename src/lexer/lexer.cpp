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
        {"struct", TokenKind::KwStruct},
        {"enum", TokenKind::KwEnum},
        {"method", TokenKind::KwMethod},
        {"constructor", TokenKind::KwConstructor},
        {"destructor", TokenKind::KwDestructor},
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
        {"partitionable", TokenKind::KwPartitionable},
        {"region", TokenKind::KwRegion},
        {"of", TokenKind::KwOf},
        {"accepts", TokenKind::KwAccepts},
        {"rejects", TokenKind::KwRejects},
        {"defer", TokenKind::KwDefer},
        {"using", TokenKind::KwUsing},
        {"itself", TokenKind::KwItself},
        {"release", TokenKind::KwRelease},
        {"comptime", TokenKind::KwComptime},
        {"literal", TokenKind::KwLiteral},
        {"import", TokenKind::KwImport},
        {"if", TokenKind::KwIf},
        {"else", TokenKind::KwElse},
        {"while", TokenKind::KwWhile},
        {"do", TokenKind::KwDo},
        {"for", TokenKind::KwFor},
        {"switch", TokenKind::KwSwitch},
        {"case", TokenKind::KwCase},
        {"default", TokenKind::KwDefault},
        {"break", TokenKind::KwBreak},
        {"continue", TokenKind::KwContinue},
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

Lexer::Lexer(std::string_view source, std::string_view file)
    : source_(source), file_(file) {}

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
            while (!atEnd() && peek() != '\n') advance();
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
    }

    char suffix = peek();
    if (suffix == 'f' || suffix == 'F') {
        isFloat = true;
        advance();
    } else if (suffix == 'L' || suffix == 'l') {
        advance();
    }

    std::string text(source_.substr(start, pos_ - start));
    return make(isFloat ? TokenKind::FloatLiteral : TokenKind::IntLiteral, std::move(text), loc);
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
    while (!atEnd() && peek() != '"' && peek() != '\n') {
        if (peek() == '\\') {
            value += advance();                // backslash
            if (!atEnd()) value += advance();  // escaped char
        } else {
            value += advance();
        }
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
        case '[': return make(TokenKind::LBracket, "[", loc);
        case ']': return make(TokenKind::RBracket, "]", loc);
        case ';': return make(TokenKind::Semicolon, ";", loc);
        case ',': return make(TokenKind::Comma, ",", loc);
        case '?': return make(TokenKind::Question, "?", loc);
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
