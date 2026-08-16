#pragma once

#include <cstdint>
#include <string>
#include <string_view>

namespace polaron {

// A position in a source file. Carried from the very first phase so every
// later diagnostic can point back to file:line:col.
struct SourceLocation {
    std::string_view file;
    int line = 1;
    int col = 1;
};

// Every lexical category the Polaron lexer can produce. The keyword set covers
// the Release 0.1 subset (F1-F3); further keywords are reserved as their
// language features land in later phases.
enum class TokenKind : std::uint8_t {
    // Special
    EndOfFile,
    Unknown,  // a character the lexer could not classify
    Comment,  // a //, /// or /* */ comment (only emitted in keep-comments mode, for `polaron fmt`)

    // Identifiers and literals
    Identifier,
    IntLiteral,
    FloatLiteral,
    DecimalLiteral,  // numeric with an `m` suffix (1.50m) -> the Decimal primitive (spec 34)
    CharLiteral,
    StringLiteral,
    BytesLiteral,   // b"..." -- raw NUL-terminated bytes, not a String object (freestanding)
    InterpString,  // $"...{expr}..." -- raw content kept; split by the parser

    // Keywords -- structure
    KwProgram, KwBundle, KwNamespace,
    KwClass, KwInterface, KwStruct, KwRecord, KwUnion, KwEnum, KwCatalog, KwByCatalog,
    KwLayout,   // an interface for memory: how a value aggregate arranges itself
    // `transformer` says what a type GAINS by applying it -- the one thing none of the other
    // declarations say. A noun, never instantiated; `applies` is the clause that takes it, and
    // `procedure` is the member kind whose signature is completed at the type that applies it.
    KwTransformer, KwApplies, KwProcedure,
    // `entrusts` is `applies` with consent: a type that lets a transformer's procedure ASSEMBLE it
    // field by field, instead of building it through a constructor of its own. It is a fourth clause
    // on the class line and the most intimate of them -- `extends` is identity, `implements` is a
    // promise to the outside, `applies` is equipment, and this one hands over the constructor.
    KwEntrusts,
    // `call T.p()` -- reach the TRANSFORMER's body rather than this type's override. It exists
    // because there is no receiver to write to the left of the dot: a transformer is not a value.
    //
    // A HARD keyword, by the author's decision after being shown the cost: `decomp/src/lift.pol`
    // declares `mutable String call` and uses it dozens of times, so that file needs a rename. The
    // measurement is recorded rather than the breakage discovered.
    KwCall,
    KwMethod, KwConstructor, KwDestructor, KwOperator,
    // `public interrupt(Trap t) returns void { }` -- a method the program never calls, because
    // something outside it ENTERS the method at a moment the program did not choose. Nameless, like
    // the destructor, and for the same reason: one device, one handler.
    KwInterrupt,
    KwReturns, KwReturn,

    // Keywords -- modifiers / visibility
    KwPublic, KwPrivate, KwProtected, KwInternal,
    KwStatic, KwAbstract, KwFinal, KwOverride, KwMutable, KwNullable,

    // Keywords -- OOP / memory / type ops
    KwExtends, KwImplements, KwThis, KwSuper,
    KwSealed, KwPermits,
    KwRequires, KwEnsures, KwInvariant,
    // `demand <cond> otherwise "why";` -- a compile-time check. A STATEMENT, not a call: the C++
    // spelling was a function taking two arguments, and a function is the one thing this is not.
    // Keyword rather than library, because the places it matters most include freestanding, where
    // there is no library to hold it.
    KwDemand, KwOtherwise,
    KwVar, KwNew, KwDelete, KwOn, KwIn,
    KwIs, KwAs, KwCast, KwNull,

    // Keywords -- ownership / regions / scoped resources (0.2 memory model)
    KwMove, KwMovable, KwUnique, KwWeak, KwPartitionable,
    KwRegion, KwOf, KwAccepts, KwRejects,
    KwItself, KwRelease,
    KwPersistent, KwEternal, KwTransient,
    KwDeprecated,   // spec 14.2: marks a method as deprecated -> a warning at each call site
    KwPartial,      // spec 8.3: a class declaration split across several declarations/files
    KwDefer, KwUsing, KwSynchronized, KwAsync, KwAwait,
    KwExtern, KwCdecl, KwStdcall, KwFastcall, KwUnknown, KwFreestanding, KwNaked,
    KwVolatile, KwCascade, KwLazy, KwExternal, KwDelegate,
    KwLambda, KwFunction, KwMethodref,
    KwTypealias, KwNewtype, KwAnnotation,
    KwLabel, KwComefrom, KwGoto, KwAbstainfrom, KwReinstate, KwUnimport, KwReimport,
    KwExpecting, KwOnFailure, KwYield,
    AsmBlock,  // inline assembly (spec issue 1): lexeme is arch + '\x1f' + raw body
    KwTry, KwCatch, KwFinally, KwThrow, KwThrows,

    // Keywords -- compile-time / literal suffixes (0.2 Fase C)
    KwComptime, KwLiteral, KwImport, KwFixed,
    // (get / set / init are soft keywords -- not reserved; see parser)

    // Keywords -- control flow
    KwIf, KwElse, KwWhile, KwDo, KwFor, KwForeach,
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
    At,                   // @  -- built-in annotation prefix (spec 14.1): @Test
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

}  // namespace polaron
