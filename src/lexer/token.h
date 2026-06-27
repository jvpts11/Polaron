#pragma once

#include <cstdint>
#include <string>
#include <string_view>

namespace ldp3 {

// A position in a source file. Carried from the very first phase so every
// later diagnostic can point back to file:line:col.
struct SourceLocation {
    std::string_view file;
    int line = 1;
    int col = 1;
};

// Every lexical category the LDP3 lexer can produce. The keyword set covers
// the Release 0.1 subset (F1-F3); further keywords are reserved as their
// language features land in later phases.
enum class TokenKind : std::uint8_t {
    // Special
    EndOfFile,
    Unknown,  // a character the lexer could not classify

    // Identifiers and literals
    Identifier,
    IntLiteral,
    FloatLiteral,
    CharLiteral,
    StringLiteral,
    InterpString,  // $"...{expr}..." -- raw content kept; split by the parser

    // Keywords -- structure
    KwProgram, KwBundle, KwNamespace,
    KwClass, KwInterface, KwStruct, KwRecord, KwUnion, KwEnum, KwCatalog, KwByCatalog,
    KwMethod, KwConstructor, KwDestructor, KwOperator,
    KwReturns, KwReturn,

    // Keywords -- modifiers / visibility
    KwPublic, KwPrivate, KwProtected, KwInternal,
    KwStatic, KwAbstract, KwFinal, KwOverride, KwMutable, KwNullable,

    // Keywords -- OOP / memory / type ops
    KwExtends, KwImplements, KwThis, KwSuper,
    KwSealed, KwPermits,
    KwRequires, KwEnsures, KwInvariant,
    KwStaticAssert,
    KwVar, KwNew, KwDelete, KwOn, KwIn,
    KwIs, KwAs, KwCast, KwNull,

    // Keywords -- ownership / regions / scoped resources (0.2 memory model)
    KwMove, KwMovable, KwUnique, KwPartitionable,
    KwRegion, KwOf, KwAccepts, KwRejects,
    KwItself, KwRelease,
    KwPersistent, KwEternal, KwTransient,
    KwDefer, KwUsing, KwSynchronized, KwAsync, KwAwait,
    KwExtern, KwCdecl, KwStdcall, KwFastcall, KwFreestanding,
    KwVolatile, KwCascade, KwLazy, KwExternal,
    KwLambda, KwFunction, KwMethodref,
    KwTypealias, KwNewtype, KwAnnotation,
    KwLabel, KwComefrom, KwGoto, KwAbstainfrom, KwReinstate, KwUnimport, KwReimport,
    KwTry, KwCatch, KwFinally, KwThrow, KwThrows,

    // Keywords -- compile-time / literal suffixes (0.2 Fase C)
    KwComptime, KwLiteral, KwImport, KwConst,
    // (get / set / init are soft keywords -- not reserved; see parser)

    // Keywords -- control flow
    KwIf, KwElse, KwWhile, KwDo, KwFor,
    KwSwitch, KwCase, KwDefault, KwBreak, KwContinue,
    KwStep, KwIndex, KwMatch,

    // Keywords -- primitive types + boolean literals
    KwVoid, KwBoolean, KwChar, KwString, KwStringClass,  // string / String
    KwInt, KwInt8, KwInt16, KwInt32, KwInt64,
    KwUint8, KwUint16, KwUint32, KwUint64,
    KwShort, KwLong, KwByte,
    KwFloat, KwDouble, KwFloat32, KwFloat64,
    KwTrue, KwFalse,

    // Punctuation
    LParen, RParen,       // ( )
    LBrace, RBrace,       // { }
    LBracket, RBracket,   // [ ]
    Semicolon, Comma,     // ; ,
    Dot, DotDot, DotDotEq,  // . .. ..=
    Colon, Question,      // : ?
    QuestionQuestion, QuestionDot,  // ?? (null-coalescing) ?. (safe navigation)

    // Operators -- arithmetic
    Plus, Minus, Star, Slash, Percent,
    PlusPlus, MinusMinus,

    // Operators -- assignment
    Assign,  // =
    PlusEq, MinusEq, StarEq, SlashEq, PercentEq,
    AmpEq, PipeEq, CaretEq, ShlEq, ShrEq,

    // Operators -- comparison
    EqEq, BangEq, Lt, Gt, LtEq, GtEq,  // == != < > <= >=

    // Operators -- logical
    AmpAmp, PipePipe, Bang,  // && || !

    // Operators -- misc
    Arrow,  // -> (match-expression arm)

    // Operators -- bitwise
    Amp, Pipe, Caret, Tilde, Shl, Shr,  // & | ^ ~ << >>
};

// Human-readable name for a token kind (diagnostics, --dump-tokens).
std::string_view tokenKindName(TokenKind kind);

// A single lexical token: what it is, the exact source text, and where it is.
struct Token {
    TokenKind kind = TokenKind::Unknown;
    std::string lexeme;
    SourceLocation loc;
};

}  // namespace ldp3
