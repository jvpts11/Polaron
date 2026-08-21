#include "pir/module.h"

#include <unordered_map>

namespace polaron::pir {

namespace {

// ONE TABLE, read both ways. The printer spells an opcode from it and the parser reads one back
// through it, so a name can never drift between the two -- which is the round-trip property the
// whole text form is tested on.
struct OpRow {
    Op op;
    const char* name;
    bool terminator;
    bool produces;
};

// clang-format off
constexpr OpRow kOps[] = {
    {Op::ConstInt,        "const.int",         false, true},
    {Op::ConstFloat,      "const.float",       false, true},
    {Op::ConstBool,       "const.bool",        false, true},
    {Op::ConstNull,       "const.null",        false, true},
    {Op::ConstAddr,       "const.addr",        false, true},
    {Op::ConstStr,        "const.str",         false, true},
    {Op::ConstFn,         "const.fn",          false, true},
    {Op::Undef,           "undef",             false, true},

    {Op::AddWrap,         "add.wrap",          false, true},
    {Op::AddChecked,      "add.checked",       false, true},
    {Op::AddSaturate,     "add.saturate",      false, true},
    {Op::SubWrap,         "sub.wrap",          false, true},
    {Op::SubChecked,      "sub.checked",       false, true},
    {Op::SubSaturate,     "sub.saturate",      false, true},
    {Op::MulWrap,         "mul.wrap",          false, true},
    {Op::MulChecked,      "mul.checked",       false, true},
    {Op::MulSaturate,     "mul.saturate",      false, true},
    {Op::ShlWrap,         "shl.wrap",          false, true},
    {Op::ShlChecked,      "shl.checked",       false, true},
    {Op::ShlSaturate,     "shl.saturate",      false, true},
    {Op::DivChecked,      "div.checked",       false, true},
    {Op::DivTrap,         "div.trap",          false, true},
    {Op::RemChecked,      "rem.checked",       false, true},
    {Op::RemTrap,         "rem.trap",          false, true},
    {Op::NegWrap,         "neg.wrap",          false, true},
    {Op::NegChecked,      "neg.checked",       false, true},
    {Op::NegSaturate,     "neg.saturate",      false, true},
    {Op::And,             "and",               false, true},
    {Op::Or,              "or",                false, true},
    {Op::Xor,             "xor",               false, true},
    {Op::Not,             "not",               false, true},
    {Op::ShrL,            "shr.l",             false, true},
    {Op::ShrA,            "shr.a",             false, true},
    {Op::FAdd,            "fadd",              false, true},
    {Op::FSub,            "fsub",              false, true},
    {Op::FMul,            "fmul",              false, true},
    {Op::FDiv,            "fdiv",              false, true},
    {Op::FRem,            "frem",              false, true},
    {Op::FNeg,            "fneg",              false, true},

    {Op::CmpEq,           "cmp.eq",            false, true},
    {Op::CmpNe,           "cmp.ne",            false, true},
    {Op::CmpLtS,          "cmp.s.lt",          false, true},
    {Op::CmpLeS,          "cmp.s.le",          false, true},
    {Op::CmpGtS,          "cmp.s.gt",          false, true},
    {Op::CmpGeS,          "cmp.s.ge",          false, true},
    {Op::CmpLtU,          "cmp.u.lt",          false, true},
    {Op::CmpLeU,          "cmp.u.le",          false, true},
    {Op::CmpGtU,          "cmp.u.gt",          false, true},
    {Op::CmpGeU,          "cmp.u.ge",          false, true},
    {Op::CmpLtF,          "cmp.f.lt",          false, true},
    {Op::CmpLeF,          "cmp.f.le",          false, true},
    {Op::CmpGtF,          "cmp.f.gt",          false, true},
    {Op::CmpGeF,          "cmp.f.ge",          false, true},
    {Op::Trunc,           "trunc",             false, true},
    {Op::ExtendS,         "extend.s",          false, true},
    {Op::ExtendU,         "extend.u",          false, true},
    {Op::FpTrunc,         "fp.trunc",          false, true},
    {Op::FpExtend,        "fp.extend",         false, true},
    {Op::FpToIntSaturate, "fp.to.int.saturate",false, true},
    {Op::FpToIntWrap,     "fp.to.int.wrap",    false, true},
    {Op::IntToFp,         "int.to.fp",         false, true},
    {Op::Bitcast,         "bitcast",           false, true},
    {Op::SizeOf,          "sizeof",            false, true},
    {Op::PtrToAddr,       "ptr.to.addr",       false, true},
    {Op::AddrToPtr,       "addr.to.ptr",       false, true},
    {Op::AddrNarrow,      "addr.narrow",       false, true},
    {Op::AddrWiden,       "addr.widen",        false, true},

    {Op::Alloca,          "alloca",            false, true},
    {Op::Load,            "load",              false, true},
    {Op::Store,           "store",             false, false},
    {Op::Gep,             "gep",               false, true},
    {Op::MemCopy,         "memcpy",            false, false},
    {Op::MemSet,          "memset",            false, false},
    {Op::MemMove,         "memmove",           false, false},

    {Op::Extract,         "extract",           false, true},
    {Op::Insert,          "insert",            false, true},
    {Op::VecBuild,        "vec.build",         false, true},
    {Op::VecExtract,      "vec.extract",       false, true},
    {Op::VecInsert,       "vec.insert",        false, true},
    {Op::Select,          "select",            false, true},

    {Op::RegionCreate,    "region.create",     false, true},
    {Op::RegionAlloc,     "region.alloc",      false, true},
    {Op::RegionRelease,   "region.release",    false, false},
    {Op::RegionAccepts,   "region.accepts",    false, true},
    {Op::RegionMark,      "region.mark",       false, true},
    {Op::RegionRestore,   "region.restore",    false, false},
    {Op::RegionExtract,   "region.extract",    false, true},
    {Op::RegionDepth,     "region.depth",      false, true},
    {Op::RegionValidate,  "region.validate",   false, true},
    {Op::RegionClone,     "region.clone",      false, true},

    {Op::Move,            "move",              false, true},
    {Op::CopyDeep,        "copy.deep",         false, true},
    {Op::Drop,            "drop",              false, false},
    {Op::DropCascade,     "drop.cascade",      false, false},
    {Op::Forget,          "forget",            false, false},

    {Op::Call,            "call",              false, true},
    {Op::CallIndirect,    "call.indirect",     false, true},
    {Op::CallUnwind,      "call.unwind",       true,  true},
    {Op::VtableLoad,      "vtable.load",       false, true},
    {Op::IfaceLoad,       "iface.load",        false, true},
    {Op::ClosureMake,     "closure.make",      false, true},
    {Op::ClosureCall,     "closure.call",      false, true},

    {Op::Br,              "br",                true,  false},
    {Op::BrCond,          "br.cond",           true,  false},
    {Op::Switch,          "switch",            true,  false},
    {Op::Ret,             "ret",               true,  false},
    {Op::Unreachable,     "unreachable",       true,  false},

    {Op::Landing,         "landing",           false, true},
    {Op::Resume,          "resume",            true,  false},
    {Op::CleanupEnd,      "cleanup.end",       false, false},
    // A TERMINATOR: control does not come back from a throw, which is what makes everything after
    // it dead and is exactly why it must not be an ordinary call.
    {Op::Raise,           "raise",             true,  false},

    {Op::GuardBounds,     "guard.bounds",      false, false},
    {Op::GuardNull,       "guard.null",        false, false},
    {Op::GuardDivisor,    "guard.divisor",     false, false},
    {Op::GuardCast,       "guard.cast",        false, false},
    {Op::GuardContract,   "guard.contract",    false, false},
    {Op::FactRequires,    "fact.requires",     false, false},
    {Op::FactEnsures,     "fact.ensures",      false, false},
    {Op::FactInvariant,   "fact.invariant",    false, false},
    {Op::FactRange,       "fact.range",        false, false},

    {Op::VariantMake,     "variant.make",      false, true},
    {Op::VariantTag,      "variant.tag",       false, true},
    {Op::VariantPayload,  "variant.payload",   false, true},

    {Op::Suspend,         "suspend",           true,  true},
    {Op::LockAcquire,     "lock.acquire",      false, false},
    {Op::LockRelease,     "lock.release",      false, false},
    {Op::AtomicLoad,      "atomic.load",       false, true},
    {Op::AtomicStore,     "atomic.store",      false, false},
    {Op::AtomicRmw,       "atomic.rmw",        false, true},
    {Op::AtomicCmpXchg,   "atomic.cmpxchg",    false, true},
    {Op::Fence,           "fence",             false, false},

    {Op::Asm,             "asm",               false, true},
    {Op::ItselfAlloc,     "itself.alloc",      false, true},
    {Op::LazyGet,         "lazy.get",          false, true},
};
// clang-format on

const OpRow* rowOf(Op op) {
    for (const OpRow& r : kOps) {
        if (r.op == op) {
            return &r;
        }
    }
    return nullptr;
}

}  // namespace

const char* spell(Op op) {
    const OpRow* r = rowOf(op);
    return r != nullptr ? r->name : "<?>";
}

bool opFromName(const std::string& name, Op* out) {
    for (const OpRow& r : kOps) {
        if (name == r.name) {
            *out = r.op;
            return true;
        }
    }
    return false;
}

bool isTerminator(Op op) {
    const OpRow* r = rowOf(op);
    return r != nullptr && r->terminator;
}

bool producesValue(Op op) {
    const OpRow* r = rowOf(op);
    return r != nullptr && r->produces;
}

const char* spell(Linkage v) {
    switch (v) {
        case Linkage::Public:   return "public";
        case Linkage::Internal: return "internal";
        case Linkage::Private:  return "private";
        case Linkage::External: return "external";
    }
    return "?";
}

const char* spell(Conv v) {
    switch (v) {
        case Conv::Polaron:   return "polaron";
        case Conv::Cdecl:     return "cdecl";
        case Conv::Stdcall:   return "stdcall";
        case Conv::Fastcall:  return "fastcall";
        case Conv::Cppdecl:   return "cppdecl";
        case Conv::Rustdecl:  return "rustdecl";
        case Conv::Zigdecl:   return "zigdecl";
        case Conv::Syscall:   return "syscall";
        case Conv::Interrupt: return "interrupt";
        case Conv::Naked:     return "naked";
        case Conv::Unknown:   return "unknown";
    }
    return "?";
}

const char* spell(FnKind v) {
    switch (v) {
        case FnKind::Method:      return "method";
        case FnKind::Constructor: return "constructor";
        case FnKind::Destructor:  return "destructor";
        case FnKind::Operator:    return "operator";
        case FnKind::Procedure:   return "procedure";
        case FnKind::Interrupt:   return "interrupt";
    }
    return "?";
}

const char* spell(Affinity v) {
    switch (v) {
        case Affinity::None: return "none";
        case Affinity::Hot:  return "hot";
        case Affinity::Cold: return "cold";
    }
    return "?";
}

const char* spell(Unwind v) {
    switch (v) {
        case Unwind::Never: return "never";
        case Unwind::May:   return "may";
    }
    return "?";
}

const char* spell(Storage v) {
    switch (v) {
        case Storage::Static:      return "static";
        case Storage::Persistent:  return "persistent";
        case Storage::Eternal:     return "eternal";
        case Storage::Transient:   return "transient";
        case Storage::ThreadLocal: return "threadlocal";
    }
    return "?";
}

ValueId Function::addValue(const Type* type, ValueOrigin origin, BlockId block, uint32_t index,
                           std::string name) {
    ValueDef def;
    def.type = type;
    def.origin = origin;
    def.block = block;
    def.indexInBlock = index;
    def.name = std::move(name);
    values.push_back(std::move(def));
    return static_cast<ValueId>(values.size() - 1);
}

BlockId Function::addBlock(std::string label) {
    Block b;
    b.id = static_cast<BlockId>(blocks.size());
    b.label = std::move(label);
    blocks.push_back(std::move(b));
    return blocks.back().id;
}

Block* Function::block(BlockId id) {
    return id < blocks.size() ? &blocks[id] : nullptr;
}

const Block* Function::block(BlockId id) const {
    return id < blocks.size() ? &blocks[id] : nullptr;
}

const ValueDef* Function::value(ValueId id) const {
    return id < values.size() ? &values[id] : nullptr;
}

Function* Module::addFunction(std::string key, const Type* signature) {
    auto fn = std::make_unique<Function>();
    fn->key = std::move(key);
    fn->signature = signature;
    functions.push_back(std::move(fn));
    return functions.back().get();
}

Function* Module::find(const std::string& key) {
    for (const std::unique_ptr<Function>& f : functions) {
        if (f->key == key) {
            return f.get();
        }
    }
    return nullptr;
}

const Function* Module::find(const std::string& key) const {
    for (const std::unique_ptr<Function>& f : functions) {
        if (f->key == key) {
            return f.get();
        }
    }
    return nullptr;
}

}  // namespace polaron::pir
