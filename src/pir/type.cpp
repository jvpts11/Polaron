#include "pir/type.h"

#include <stdexcept>

namespace polaron::pir {

namespace {

// The interning key. It must distinguish exactly what `Type` identity distinguishes and nothing
// more: two structs with the same fields and different FIELD NAMES are the same type (names are for
// printing), two `newtype`s with the same shape and different names are not.
std::string keyOf(const Type& t) {
    std::string k;
    k += std::to_string(static_cast<int>(t.kind));
    k += ':';
    k += std::to_string(t.bits);
    k += ':';
    k += std::to_string(reinterpret_cast<uintptr_t>(t.element));
    k += ':';
    k += std::to_string(t.extent);
    k += ':';
    k += std::to_string(static_cast<int>(t.storage));
    k += ':';
    // A nominal type is keyed by its NAME as well, which is what makes a `newtype` distinct from the
    // thing it is over. A structural type ignores the name entirely.
    if (t.nominal) {
        k += t.name;
    }
    k += ':';
    for (const Field& f : t.fields) {
        k += std::to_string(reinterpret_cast<uintptr_t>(f.type));
        k += f.hasOffset ? ('@' + std::to_string(f.offset)) : std::string();
        if (f.bitWidth != 0) {
            k += '#' + std::to_string(f.bitOffset) + '/' + std::to_string(f.bitWidth);
        }
        if (f.weak) {
            k += '~';
        }
        k += ',';
    }
    return k;
}

}  // namespace

TypeTable::TypeTable() {
    Type v;
    v.kind = TypeKind::Void;
    void_ = intern(std::move(v));

    Type b;
    b.kind = TypeKind::Bool;
    b.facts.size = 1;
    b.facts.align = 1;
    b.facts.isValue = true;
    bool_ = intern(std::move(b));

    Type p;
    p.kind = TypeKind::Ptr;
    p.facts.size = 8;
    p.facts.align = 8;
    ptr_ = intern(std::move(p));

    Type r;
    r.kind = TypeKind::Region;
    r.facts.size = 8;
    r.facts.align = 8;
    region_ = intern(std::move(r));
}

const Type* TypeTable::intern(Type&& candidate) {
    const std::string key = keyOf(candidate);
    auto it = byKey_.find(key);
    if (it != byKey_.end()) {
        return it->second;
    }
    owned_.push_back(std::make_unique<Type>(std::move(candidate)));
    const Type* made = owned_.back().get();
    byKey_.emplace(key, made);
    return made;
}

const Type* TypeTable::intType(uint32_t bits) {
    Type t;
    t.kind = TypeKind::Int;
    t.bits = bits;
    t.facts.size = (bits + 7) / 8;
    t.facts.align = static_cast<uint32_t>(t.facts.size);
    t.facts.isValue = true;
    return intern(std::move(t));
}

const Type* TypeTable::floatType(uint32_t bits) {
    Type t;
    t.kind = TypeKind::Float;
    t.bits = bits;
    t.facts.size = (bits + 7) / 8;
    t.facts.align = static_cast<uint32_t>(t.facts.size);
    t.facts.isValue = true;
    return intern(std::move(t));
}

const Type* TypeTable::addrType(uint32_t bits) {
    Type t;
    t.kind = TypeKind::Addr;
    t.bits = bits;
    t.facts.size = (bits + 7) / 8;
    t.facts.align = static_cast<uint32_t>(t.facts.size);
    t.facts.isValue = true;
    return intern(std::move(t));
}

const Type* TypeTable::arrayType(const Type* element, uint64_t extent, ArrayStorage storage) {
    Type t;
    t.kind = TypeKind::Array;
    t.element = element;
    t.extent = extent;
    t.storage = storage;
    if (storage == ArrayStorage::Inline && element != nullptr) {
        // IN PLACE, so its size is the elements and nothing else: no header, no pointer. That is the
        // whole difference from the heap form, and it is why the two are different types.
        t.facts.size = element->facts.size * extent;
        t.facts.align = element->facts.align;
        t.facts.isValue = true;
        t.facts.owns = element->facts.owns;
    } else {
        t.facts.size = 8;
        t.facts.align = 8;
        t.facts.owns = true;   // a heap array is released by `delete`
    }
    return intern(std::move(t));
}

const Type* TypeTable::sliceType(const Type* element) {
    Type t;
    t.kind = TypeKind::Slice;
    t.element = element;
    // EIGHT, because that is what a `T[]` OCCUPIES in this ABI: one pointer to a heap block whose
    // first eight bytes are the length. It said sixteen -- "ptr + length", describing a fat pointer
    // this implementation does not use; the backend maps a slice to a plain `ptr` and the trusted
    // path does the same. Nothing noticed until an array OF arrays needed the stride: the literal
    // wrote its elements eight bytes apart and every read stepped sixteen, so `m[1]` addressed past
    // the end of its own allocation. A size is what everyone else steps by; describing a different
    // representation here is not a stale comment, it is everyone else's arithmetic made wrong.
    t.facts.size = 8;
    t.facts.align = 8;
    // IT OWNS. A `T[]` is heap storage with a length header, and `delete` releases it -- which is
    // exactly what `owns` means and what verifier rule 10 checks a `drop` against. Leaving it false
    // made every `delete` of an array in the standard library a rule-10 failure, correctly.
    t.facts.owns = true;
    return intern(std::move(t));
}

const Type* TypeTable::vectorType(const Type* element, uint64_t lanes) {
    Type t;
    t.kind = TypeKind::Vector;
    t.element = element;
    t.extent = lanes;
    // THE LANES AND NOTHING ELSE. A vector is its elements side by side in one register: no header,
    // no pointer, nothing to release. Its alignment is its whole width, which is what lets a load
    // of one be a single aligned move rather than N scalar loads.
    if (element != nullptr) {
        t.facts.size = element->facts.size * lanes;
        t.facts.align = static_cast<uint32_t>(t.facts.size);
        t.facts.isValue = true;
    }
    return intern(std::move(t));
}

const Type* TypeTable::structType(std::string name, std::vector<Field> fields, bool nominal) {
    Type t;
    t.kind = TypeKind::Struct;
    t.name = std::move(name);
    t.fields = std::move(fields);
    t.nominal = nominal;
    // `owns` is inherited: a struct whose field owns something owns something. The rest of the facts
    // are decided by the lowering, which knows whether the class had a destructor and whether it was
    // declared `unique`; `setFacts` overwrites them.
    for (const Field& f : t.fields) {
        if (f.type != nullptr && f.type->facts.owns && !f.weak) {
            t.facts.owns = true;
        }
    }
    const std::string named = t.name;
    const Type* interned = intern(std::move(t));
    // INDEXED BY NAME so a pointer can be asked what it points at -- see `structNamed`. An entry
    // that already has fields is never replaced by one without: a class is mentioned before it is
    // declared, and the empty placeholder must not overwrite the completed answer if the two ever
    // arrive out of order.
    if (!named.empty()) {
        const auto seen = structsByName_.find(named);
        const bool worseThanSeen = seen != structsByName_.end() &&
                                   !seen->second->fields.empty() && interned->fields.empty();
        if (!worseThanSeen) {
            structsByName_[named] = interned;
        }
    }
    return interned;
}

const Type* TypeTable::structNamed(const std::string& name) const {
    const auto it = structsByName_.find(name);
    return it == structsByName_.end() ? nullptr : it->second;
}

const Type* TypeTable::variantType(std::string name, std::vector<Field> cases) {
    Type t;
    t.kind = TypeKind::Variant;
    t.name = std::move(name);
    t.fields = std::move(cases);
    t.nominal = true;   // two variants with the same cases and different names are different types
    for (const Field& f : t.fields) {
        if (f.type != nullptr && f.type->facts.owns) {
            t.facts.owns = true;
        }
    }
    return intern(std::move(t));
}

const Type* TypeTable::fnType(const Type* ret, std::vector<Field> params) {
    Type t;
    t.kind = TypeKind::Fn;
    t.element = ret;
    t.fields = std::move(params);
    t.facts.size = 8;
    t.facts.align = 8;
    return intern(std::move(t));
}

const Type* TypeTable::closureType(const Type* fn, const Type* captures) {
    Type t;
    t.kind = TypeKind::Closure;
    t.element = fn;
    Field cap;
    cap.type = captures;
    cap.name = "captures";
    t.fields.push_back(cap);
    t.facts.size = 8 + (captures != nullptr ? captures->facts.size : 0);
    t.facts.align = 8;
    t.facts.owns = captures != nullptr && captures->facts.owns;
    return intern(std::move(t));
}

const Type* TypeTable::newType(std::string name, const Type* over) {
    // A DISTINCT ENTRY OVER THE SAME SHAPE. The facts are inherited -- a `newtype` over an `int` is
    // the same size and is still a value -- but the identity is not, and identity is the point:
    // `keyOf` folds the name in for a nominal type, so two newtypes over `i32` never intern together
    // and never compare equal.
    Type t;
    t.kind = over->kind;
    t.bits = over->bits;
    t.element = over->element;
    t.extent = over->extent;
    t.storage = over->storage;
    t.fields = over->fields;
    t.facts = over->facts;
    t.name = std::move(name);
    t.nominal = true;
    return intern(std::move(t));
}

void TypeTable::completeStruct(const Type* placeholder, std::vector<Field> fields) {
    for (const std::unique_ptr<Type>& owned : owned_) {
        if (owned.get() != placeholder) {
            continue;
        }
        // The old key stops describing this entry the moment its fields change, so it goes; the new
        // one is registered only if nothing already answers to it, since an identical struct
        // interned earlier is a legitimate other entry and keeps its place in the table.
        byKey_.erase(keyOf(*owned));
        owned->fields = std::move(fields);
        for (const Field& f : owned->fields) {
            if (f.type != nullptr && f.type->facts.owns && !f.weak) {
                owned->facts.owns = true;
            }
        }
        byKey_.emplace(keyOf(*owned), owned.get());
        return;
    }
    throw std::logic_error("pir::TypeTable::completeStruct on a type this table does not own");
}

void TypeTable::setFacts(const Type* type, const TypeFacts& facts) {
    // The table owns every type it hands out, so this const_cast is over storage this object holds.
    // It is a write to a table entry, not to somebody else's memory.
    for (const std::unique_ptr<Type>& owned : owned_) {
        if (owned.get() == type) {
            owned->facts = facts;
            return;
        }
    }
    throw std::logic_error("pir::TypeTable::setFacts on a type this table does not own");
}

void TypeTable::setPacked(const Type* type, bool packed) {
    for (const std::unique_ptr<Type>& owned : owned_) {
        if (owned.get() == type) {
            owned->packed = packed;
            return;
        }
    }
    throw std::logic_error("pir::TypeTable::setPacked on a type this table does not own");
}

std::string TypeTable::spell(const Type* type) {
    if (type == nullptr) {
        return "<null>";
    }
    if (type->nominal && !type->name.empty()) {
        return "%" + type->name;
    }
    switch (type->kind) {
        case TypeKind::Void:
            return "void";
        case TypeKind::Bool:
            return "bool";
        case TypeKind::Ptr:
            return "ptr";
        case TypeKind::Region:
            return "region";
        case TypeKind::Int:
            return "i" + std::to_string(type->bits);
        case TypeKind::Float:
            return "f" + std::to_string(type->bits);
        case TypeKind::Addr:
            return "addr" + std::to_string(type->bits);
        case TypeKind::Slice:
            return "slice<" + spell(type->element) + ">";
        case TypeKind::Vector:
            return "<" + std::to_string(type->extent) + " x " + spell(type->element) + ">";
        case TypeKind::Array: {
            const char* disc = type->storage == ArrayStorage::Inline ? " inline" : " heap";
            return "[" + std::to_string(type->extent) + " x " + spell(type->element) + disc + "]";
        }
        case TypeKind::Struct: {
            std::string s = "{";
            for (size_t i = 0; i < type->fields.size(); ++i) {
                if (i != 0) {
                    s += ", ";
                }
                s += spell(type->fields[i].type);
                if (type->fields[i].weak) {
                    s += " weak";
                }
            }
            return s + "}";
        }
        case TypeKind::Variant: {
            std::string s = "<";
            for (size_t i = 0; i < type->fields.size(); ++i) {
                if (i != 0) {
                    s += "|";
                }
                s += spell(type->fields[i].type);
            }
            return s + ">";
        }
        case TypeKind::Fn: {
            std::string s = "fn(";
            for (size_t i = 0; i < type->fields.size(); ++i) {
                if (i != 0) {
                    s += ", ";
                }
                s += spell(type->fields[i].type);
            }
            return s + ") -> " + spell(type->element);
        }
        case TypeKind::Closure:
            return "closure<" + spell(type->element) + ">";
    }
    return "<?>";
}

}  // namespace polaron::pir
