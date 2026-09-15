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
    // `surveyed`: this method's lifetime summary is stated by its author, not derived from its
    // body. See the region-binder chapter -- it is the one escape the analysis has, and it pays
    // for itself at the boundary rather than at the body.
    KwSurveyed,

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
    // `dynamic` (docs/design/dynamic.md) -- the universal prefix for *decided at run time*. On a
    // class it means the instance carries its type: a vtable pointer, eight bytes on every instance,
    // and membership of the `Object` root. Without it a class IS its fields, which is what AP-02 is
    // about: `class Tag`, which nothing extends and nothing overrides, was eight bytes wide because
    // nobody had written anything.
    KwDynamic,
    // `shareable` (docs/design/ownership.md §13a, §14, §20.4) -- this type is safe to reach from
    // several threads at once. A MODIFIER and not a marker interface: it names no methods, it
    // dispatches nothing, and under `dynamic` `implements Shared` would buy an eight-byte header
    // and an indirection for a property that generates no calls -- the exact cost AP-02 is about,
    // arriving through a word chosen for convenience.
    //
    // It is CHECKED, not trusted: legal when every mutable field is `atomic<T>` or itself
    // shareable, or when the type is entirely immutable. A bare permission would be a one-word hole
    // in the no-UB principle, and handing that back is handing AP-33 back after winning it.
    KwShareable,
    // `reentrant` (docs/design/reentrant.md) -- THIS MAY BE ENTERED AGAIN WHILE AN EARLIER ENTRY IS
    // STILL RUNNING. A member modifier, and the wide property `interrupt` was a special case of:
    // the handler's bespoke list of prohibitions -- must not allocate, must not free -- collapses
    // into one property with one checker, and a method that is NOT a handler but must be equally
    // careful (a scheduler entry, a page-fault path, a destructor during teardown) gains a way to
    // say so, which it had not.
    KwReentrant,
    KwRegion, KwOf, KwAccepts, KwRejects,
    KwItself, KwRelease,
    KwPersistent, KwEternal, KwTransient,
    KwDeprecated,   // spec 14.2: marks a method as deprecated -> a warning at each call site
    KwPartial,      // spec 8.3: a class declaration split across several declarations/files
    KwDefer, KwUsing, KwSynchronized, KwAsync, KwAwait,
    KwExtern, KwCdecl, KwStdcall, KwFastcall, KwUnknown, KwFreestanding, KwNaked,
    KwVolatile, KwCascade, KwLazy, KwExternal, KwDelegate,
    KwMethodref,
    // `readonly` on a method (B.1/D.6): it writes nothing -- no field of its own, no field of
    // anything it was handed, no static, no output. Declared, and checked.
    KwReadonly,
    // `cold` on a method (B.3): this path is rarely taken. Moves the body off the hot line and stops
    // it being inlined into one. There is no `hot`, on purpose: hot is the default, so the word
    // would carry no fact. (The same word also tags an `affinity cold { }` field group.)
    KwCold,
    // `mustuse` (B.2) on a type or a method: the answer is the point, so throwing it away is a
    // mistake worth a word. `discard e;` is the valve -- deliberate, and visible at the line.
    KwMustuse, KwDiscard,
    // THE THIRD KIND OF MEMBER, beside `method` (an instance's behaviour) and `procedure` (a
    // relation's): PORTABLE behaviour -- something handed to whoever knows WHEN to run it, which is
    // what a lambda was for, said with a subject and a name.
    //
    // `carries` is the capture list, DECLARED, so that nothing is closed over implicitly: what a
    // command holds is its declaration, and the region binder reads that list instead of discovering
    // one. Both are HARD: the word is the member kind, and a member kind that a program could also
    // use as a variable name is a word the reader has to disambiguate every time.
    KwCommand, KwCarries,
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
