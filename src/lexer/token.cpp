#include "lexer/token.h"

namespace ldp3 {

std::string_view tokenKindName(TokenKind kind) {
    switch (kind) {
        case TokenKind::EndOfFile:    return "EndOfFile";
        case TokenKind::Unknown:      return "Unknown";

        case TokenKind::Identifier:   return "Identifier";
        case TokenKind::IntLiteral:   return "IntLiteral";
        case TokenKind::FloatLiteral: return "FloatLiteral";
        case TokenKind::CharLiteral:  return "CharLiteral";
        case TokenKind::StringLiteral:return "StringLiteral";
        case TokenKind::BytesLiteral: return "BytesLiteral";
        case TokenKind::InterpString: return "InterpString";

        case TokenKind::KwProgram:     return "KwProgram";
        case TokenKind::KwBundle:      return "KwBundle";
        case TokenKind::KwNamespace:   return "KwNamespace";
        case TokenKind::KwClass:       return "KwClass";
        case TokenKind::KwInterface:   return "KwInterface";
        case TokenKind::KwStruct:      return "KwStruct";
        case TokenKind::KwRecord:      return "KwRecord";
        case TokenKind::KwUnion:       return "KwUnion";
        case TokenKind::KwEnum:        return "KwEnum";
        case TokenKind::KwCatalog:     return "KwCatalog";
        case TokenKind::KwByCatalog:   return "KwByCatalog";
        case TokenKind::KwMethod:      return "KwMethod";
        case TokenKind::KwConstructor: return "KwConstructor";
        case TokenKind::KwDestructor:  return "KwDestructor";
        case TokenKind::KwOperator:    return "KwOperator";
        case TokenKind::KwReturns:     return "KwReturns";
        case TokenKind::KwReturn:      return "KwReturn";

        case TokenKind::KwPublic:    return "KwPublic";
        case TokenKind::KwPrivate:   return "KwPrivate";
        case TokenKind::KwProtected: return "KwProtected";
        case TokenKind::KwInternal:  return "KwInternal";
        case TokenKind::KwStatic:    return "KwStatic";
        case TokenKind::KwAbstract:  return "KwAbstract";
        case TokenKind::KwFinal:     return "KwFinal";
        case TokenKind::KwOverride:  return "KwOverride";
        case TokenKind::KwMutable:   return "KwMutable";

        case TokenKind::KwExtends:    return "KwExtends";
        case TokenKind::KwImplements: return "KwImplements";
        case TokenKind::KwSealed:     return "KwSealed";
        case TokenKind::KwPermits:    return "KwPermits";
        case TokenKind::KwThis:       return "KwThis";
        case TokenKind::KwSuper:      return "KwSuper";
        case TokenKind::KwVar:        return "KwVar";
        case TokenKind::KwNew:        return "KwNew";
        case TokenKind::KwDelete:     return "KwDelete";
        case TokenKind::KwOn:         return "KwOn";
        case TokenKind::KwIn:         return "KwIn";
        case TokenKind::KwIs:         return "KwIs";
        case TokenKind::KwAs:         return "KwAs";
        case TokenKind::KwCast:       return "KwCast";
        case TokenKind::KwNull:       return "KwNull";

        case TokenKind::KwMove:          return "KwMove";
        case TokenKind::KwMovable:       return "KwMovable";
        case TokenKind::KwUnique:        return "KwUnique";
        case TokenKind::KwWeak:          return "KwWeak";
        case TokenKind::KwPartitionable: return "KwPartitionable";
        case TokenKind::KwRegion:        return "KwRegion";
        case TokenKind::KwOf:            return "KwOf";
        case TokenKind::KwAccepts:       return "KwAccepts";
        case TokenKind::KwRejects:       return "KwRejects";
        case TokenKind::KwDefer:         return "KwDefer";
        case TokenKind::KwUsing:         return "KwUsing";
        case TokenKind::KwSynchronized:  return "KwSynchronized";
        case TokenKind::KwAsync:         return "KwAsync";
        case TokenKind::KwAwait:         return "KwAwait";
        case TokenKind::KwExtern:        return "KwExtern";
        case TokenKind::KwCdecl:         return "KwCdecl";
        case TokenKind::KwStdcall:       return "KwStdcall";
        case TokenKind::KwFastcall:      return "KwFastcall";
        case TokenKind::KwUnknown:       return "KwUnknown";
        case TokenKind::KwFreestanding:  return "KwFreestanding";
        case TokenKind::KwNaked:         return "KwNaked";
        case TokenKind::KwItself:        return "KwItself";
        case TokenKind::KwRelease:       return "KwRelease";
        case TokenKind::KwComptime:      return "KwComptime";
        case TokenKind::KwLiteral:       return "KwLiteral";
        case TokenKind::KwImport:        return "KwImport";
        case TokenKind::KwFixed:         return "KwFixed";
        case TokenKind::KwVolatile:      return "KwVolatile";
        case TokenKind::KwCascade:       return "KwCascade";
        case TokenKind::KwLazy:          return "KwLazy";
        case TokenKind::KwExternal:      return "KwExternal";
        case TokenKind::KwGoto:          return "KwGoto";
        case TokenKind::KwAbstainfrom:   return "KwAbstainfrom";
        case TokenKind::KwReinstate:     return "KwReinstate";
        case TokenKind::KwUnimport:      return "KwUnimport";
        case TokenKind::KwReimport:      return "KwReimport";
        case TokenKind::KwExpecting:     return "KwExpecting";
        case TokenKind::KwOnFailure:     return "KwOnFailure";
        case TokenKind::KwYield:         return "KwYield";
        case TokenKind::AsmBlock:        return "AsmBlock";

        case TokenKind::KwIf:       return "KwIf";
        case TokenKind::KwElse:     return "KwElse";
        case TokenKind::KwWhile:    return "KwWhile";
        case TokenKind::KwDo:       return "KwDo";
        case TokenKind::KwFor:      return "KwFor";
        case TokenKind::KwSwitch:   return "KwSwitch";
        case TokenKind::KwMatch:    return "KwMatch";
        case TokenKind::KwCase:     return "KwCase";
        case TokenKind::KwDefault:  return "KwDefault";
        case TokenKind::KwBreak:    return "KwBreak";
        case TokenKind::KwContinue: return "KwContinue";
        case TokenKind::KwStep:     return "KwStep";
        case TokenKind::KwIndex:    return "KwIndex";

        case TokenKind::KwVoid:        return "KwVoid";
        case TokenKind::KwBoolean:     return "KwBoolean";
        case TokenKind::KwChar:        return "KwChar";
        case TokenKind::KwString:      return "KwString";
        case TokenKind::KwStringClass: return "KwStringClass";
        case TokenKind::KwInt:    return "KwInt";
        case TokenKind::KwInt8:   return "KwInt8";
        case TokenKind::KwInt16:  return "KwInt16";
        case TokenKind::KwInt32:  return "KwInt32";
        case TokenKind::KwInt64:  return "KwInt64";
        case TokenKind::KwUint8:  return "KwUint8";
        case TokenKind::KwUint16: return "KwUint16";
        case TokenKind::KwUint32: return "KwUint32";
        case TokenKind::KwUint64: return "KwUint64";
        case TokenKind::KwShort:  return "KwShort";
        case TokenKind::KwLong:   return "KwLong";
        case TokenKind::KwByte:   return "KwByte";
        case TokenKind::KwFloat:   return "KwFloat";
        case TokenKind::KwDouble:  return "KwDouble";
        case TokenKind::KwFloat32: return "KwFloat32";
        case TokenKind::KwFloat64: return "KwFloat64";
        case TokenKind::KwTrue:  return "KwTrue";
        case TokenKind::KwFalse: return "KwFalse";

        case TokenKind::LParen:    return "LParen";
        case TokenKind::RParen:    return "RParen";
        case TokenKind::LBrace:    return "LBrace";
        case TokenKind::RBrace:    return "RBrace";
        case TokenKind::LBracket:  return "LBracket";
        case TokenKind::RBracket:  return "RBracket";
        case TokenKind::Semicolon: return "Semicolon";
        case TokenKind::Comma:     return "Comma";
        case TokenKind::Dot:       return "Dot";
        case TokenKind::DotDot:    return "DotDot";
        case TokenKind::DotDotEq:  return "DotDotEq";
        case TokenKind::Colon:     return "Colon";
        case TokenKind::Question:  return "Question";

        case TokenKind::Plus:       return "Plus";
        case TokenKind::Minus:      return "Minus";
        case TokenKind::Star:       return "Star";
        case TokenKind::Slash:      return "Slash";
        case TokenKind::Percent:    return "Percent";
        case TokenKind::PlusPlus:   return "PlusPlus";
        case TokenKind::MinusMinus: return "MinusMinus";
        case TokenKind::Arrow:      return "Arrow";

        case TokenKind::Assign:    return "Assign";
        case TokenKind::PlusEq:    return "PlusEq";
        case TokenKind::MinusEq:   return "MinusEq";
        case TokenKind::StarEq:    return "StarEq";
        case TokenKind::SlashEq:   return "SlashEq";
        case TokenKind::PercentEq: return "PercentEq";
        case TokenKind::AmpEq:     return "AmpEq";
        case TokenKind::PipeEq:    return "PipeEq";
        case TokenKind::CaretEq:   return "CaretEq";
        case TokenKind::ShlEq:     return "ShlEq";
        case TokenKind::ShrEq:     return "ShrEq";

        case TokenKind::EqEq:   return "EqEq";
        case TokenKind::BangEq: return "BangEq";
        case TokenKind::Lt:     return "Lt";
        case TokenKind::Gt:     return "Gt";
        case TokenKind::LtEq:   return "LtEq";
        case TokenKind::GtEq:   return "GtEq";

        case TokenKind::AmpAmp:   return "AmpAmp";
        case TokenKind::PipePipe: return "PipePipe";
        case TokenKind::Bang:     return "Bang";

        case TokenKind::Amp:   return "Amp";
        case TokenKind::Pipe:  return "Pipe";
        case TokenKind::Caret: return "Caret";
        case TokenKind::Tilde: return "Tilde";
        case TokenKind::Shl:   return "Shl";
        case TokenKind::Shr:   return "Shr";
    }
    return "?";
}

}  // namespace ldp3
