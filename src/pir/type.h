#pragma once

#include <cstdint>
#include <memory>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

// PIR types, and the table that interns them.
//
// See docs/design/polaron-ir.md §3. Two things make this different from a plain shape table:
//
//   1. A TYPE ENTRY IS A SHAPE PLUS FIVE FACTS -- size, align, isValue, owns, isMovable, isUnique.
//      The compiler already holds all of them (they are exactly what `T.sizeof()`, `T.owns()`,
//      `T.isValue()`, `T.isMovable()` and `T.isUnique()` answer at compile time), and the PIR passes
//      want the same answers: escape analysis asks `isValue`, destructor insertion asks `owns`, alias
//      analysis asks `isUnique`. Holding the shape and re-deriving the facts is the same mistake
//      `typeName` was -- two askers, one answer, derived twice.
//
//   2. AN ARRAY CARRIES ITS STORAGE DISCIPLINE. `int[16]` and `int[]` are not the same type with a
//      different length: one lives in place with no header and dies with its owner, the other is a
//      header plus a pointer released by `delete`. Conflating them is a double-free or a leak
//      depending on the direction, so the discipline is IN the type rather than inferred from use.
//
// Types are INTERNED: one canonical pointer per structural key, so `a == b` is pointer equality and a
// type can be a map key. The table owns them; a `const Type*` is a borrowed handle valid as long as
// the table is.
namespace polaron::pir {

enum class TypeKind : uint8_t {
    Void,
    Int,        // int<N>, N in 8/16/32/64/128 -- signedness is on the OPERATION, not here
    Float,      // float<N>, N in 16/32/64/128
    Bool,
    Ptr,        // opaque, as in LLVM 17+
    Addr,       // a machine address; `byte`/`short`/`half`/full per `bits`
    Struct,     // classes, records, value structs, tuples
    Array,      // array<T, n, storage> -- see ArrayStorage
    Slice,      // ptr + length: the `T[]` view form
    Fn,
    Region,
    Variant,    // catalog, enum-with-data, union, the value form of Option/Result
    Closure,    // fn + captures
    // `vec2`/`vec3`/`vec4`, and the rows a `mat4` is built from: N LANES OF ONE SCALAR, operated on
    // at once.
    //
    // A KIND OF ITS OWN, and not a struct of N floats -- the difference is what everything
    // downstream is then able to say. A struct makes every reader RECONSTRUCT the intent: the
    // backend would have to recognise four adjacent `float` fields and infer that they are lanes,
    // and the §11 passes could say nothing about an operation being element-wise, because from a
    // struct there are no lanes to see. With the lane count on the type entry, `<4 x float>` is a
    // translation rather than a guess, and vectorising becomes reading a field rather than matching
    // a pattern. `element` is the scalar; `extent` is the lane count.
    Vector,
};

// The difference between `int[16]` and `int[]`, made part of the type. See §3.2.
enum class ArrayStorage : uint8_t {
    Inline,   // the elements, in place. No header, no pointer, nothing to release
    Heap,     // a length header, reached through a pointer, released by `delete`
};

// One field of a struct. `offset` is present exactly when the type came from a `layout` -- absent
// means the backend chooses. `bitWidth` non-zero makes it a bitfield, so the shift-and-mask is
// generated rather than open-coded by the front end.
struct Field {
    const struct Type* type = nullptr;
    std::string name;                 // for printing and for diagnostics; not part of identity
    bool hasOffset = false;
    uint64_t offset = 0;
    uint32_t bitOffset = 0;
    uint32_t bitWidth = 0;            // 0 = not a bitfield
    bool weak = false;                // a non-owning edge: what lets the binder form a forest
    // A BOUNDARY THIS FIELD MUST START ON, asked for rather than required -- written by a layout's
    // resolver as `itself.align(f, 64 bytes)` or `itself.isolate(f)`. 0 means the type's own
    // alignment decides, which is every field nobody said anything about.
    //
    // A separate number from the type's alignment because it is a different claim. The type's says
    // what the machine needs in order to load the value; this says what the AUTHOR needs of where
    // the value sits -- two counters that must not share a cache line, a register block that has to
    // begin on a page. The layout must concede `padding` before a resolver may write one, since
    // putting a field at 64 when its type wants 8 inserts up to 56 bytes nothing asked for.
    uint32_t alignOverride = 0;

    bool sameShape(const Field& o) const {
        return type == o.type && hasOffset == o.hasOffset && offset == o.offset &&
               bitOffset == o.bitOffset && bitWidth == o.bitWidth && weak == o.weak &&
               alignOverride == o.alignOverride;
    }
};

// The five facts of §3.3, decided once when the entry is made.
struct TypeFacts {
    uint64_t size = 0;
    uint32_t align = 1;
    bool isValue = false;     // copied, not pointed at
    bool owns = false;        // destroying one does work
    bool isMovable = true;    // may be `move`d
    bool isUnique = false;    // at most one live reference
};

struct Type {
    TypeKind kind = TypeKind::Void;
    uint32_t bits = 0;                     // Int/Float/Addr
    const Type* element = nullptr;         // Array/Slice/Ptr-to (element), Fn return, Closure fn
    uint64_t extent = 0;                   // Array
    ArrayStorage storage = ArrayStorage::Heap;
    std::vector<Field> fields;             // Struct, Variant cases, Fn params, Closure captures
    std::string name;                      // nominal name: a class, a record, a `newtype`
    bool nominal = false;                  // a `newtype` is a DISTINCT entry over the same shape
    // NO PADDING BETWEEN FIELDS. A `layout` class states an exact arrangement of bytes -- it is how
    // a program describes a hardware register block or a wire format -- so the compiler may not
    // insert alignment holes into it. Without this a `layout` measured sixteen bytes where the
    // declaration says twelve, and every offset past the first was somewhere else.
    bool packed = false;
    TypeFacts facts;

    bool isInteger() const { return kind == TypeKind::Int; }
    bool isPointerLike() const { return kind == TypeKind::Ptr || kind == TypeKind::Slice; }
    bool isAggregate() const { return kind == TypeKind::Struct || kind == TypeKind::Array; }
};

// Interns types by structural key. A `newtype` interns by NAME as well, because two entries with the
// same shape and different names must never be the same pointer -- that is the whole of what
// `newtype` buys, and pointer equality is how every pass will ask.
class TypeTable {
public:
    TypeTable();

    const Type* voidType() const { return void_; }
    const Type* boolType() const { return bool_; }
    const Type* ptrType() const { return ptr_; }
    const Type* regionType() const { return region_; }

    const Type* intType(uint32_t bits);
    const Type* floatType(uint32_t bits);
    const Type* addrType(uint32_t bits);
    const Type* arrayType(const Type* element, uint64_t extent, ArrayStorage storage);
    const Type* sliceType(const Type* element);
    // N lanes of `element`, held in one register. Interned like everything else, so `vec4` is one
    // pointer and two `vec4`s compare equal by identity.
    const Type* vectorType(const Type* element, uint64_t lanes);
    const Type* structType(std::string name, std::vector<Field> fields, bool nominal);
    const Type* variantType(std::string name, std::vector<Field> cases);
    const Type* fnType(const Type* ret, std::vector<Field> params);
    const Type* closureType(const Type* fn, const Type* captures);

    // A `newtype`: a distinct nominal entry over `over`, sharing its shape and its facts but never
    // its identity.
    const Type* newType(std::string name, const Type* over);

    // Set the five facts on a type this table owns. Called by the lowering as it learns them; the
    // verifier refuses a module whose aggregate types have no size.
    void setFacts(const Type* type, const TypeFacts& facts);

    // Mark a struct as laid out with no padding. Separate from `structType` because packing is a
    // property of the DECLARATION, not of the shape: two structs with identical fields, one
    // `layout` and one not, are the same entry until this says otherwise.
    void setPacked(const Type* type, bool packed);

    // FILL IN A NAME THAT WAS USED BEFORE IT WAS DECLARED, in place.
    //
    // A class can be mentioned before its declaration is walked -- as a return type, a field, a
    // parameter -- and the lowering interns an empty nominal struct so the mention has something to
    // point at. When the declaration arrives, interning a SECOND entry with the real fields leaves
    // every earlier mention pointing at the empty one: two different `Type*` for one name, and
    // nothing afterwards can tell they were meant to be the same. `ByteSize.kilobytes` returned the
    // empty one, so `8 kilobytes` had no `bytes` field to read and every region was asked for
    // `undef` bytes.
    //
    // Completing the placeholder keeps ONE identity for the name, which is what a nominal type is.
    // The entry is re-keyed, because the fields are part of the interning key.
    void completeStruct(const Type* placeholder, std::vector<Field> fields);

    // THE STRUCT INTERNED UNDER THIS NAME, or null if there is none.
    //
    // A pointer parameter cannot answer what it points AT. There is one opaque `ptr` entry in the
    // table -- that is what an LLVM pointer is now -- and it carries no element, so everything the
    // language knows about the class on the other end of it (its size, its alignment, whether it
    // was declared `unique`) is unreachable from the signature alone. The parameter's WRITTEN type
    // name is the way back to it, and this is the lookup that closes the loop: §12's `noalias` and
    // `dereferenceable` rows both read `ptr`'s own facts, which are the facts of no class at all,
    // and so both were structurally incapable of firing.
    //
    // `completeStruct` keeps one identity per name, so this map has one answer per name too.
    const Type* structNamed(const std::string& name) const;

    // EVERY NAMED STRUCT, IN A FIXED ORDER, so the text form can declare them.
    //
    // The printer needs this and could not have it: a nominal struct is spelled `%Mixer` at every
    // USE, and the fields live only in the table. Without a declaration to print, a module said
    // `gep ... of %Mixer imm 1` and gave the reader no way to know what `%Mixer` has in it -- so
    // reading a module back produced one with the right instructions over empty structs, and the
    // first `gep` past field zero walked off the end of a type with no fields.
    //
    // SORTED, and not because anything reads it in order. `print` must be a function of the module
    // and nothing else, or the round trip compares two texts that differ by hash iteration and the
    // failure looks like corruption. `structsByName_` is unordered; this is the seam where that
    // stops being visible.
    std::vector<std::pair<std::string, const Type*>> namedStructs() const;

    // EVERY AGGREGATE THE TABLE OWNS, in the order it interned them.
    //
    // A struct's size is measured when its class is DECLARED, out of the sizes its fields have at
    // that moment -- so a record whose field is a record declared LATER measures that field as
    // zero. One file gets away with it because the declarations happen to be in dependency order;
    // two do not, and the answer was `Named(String name, Held value)` measured at eight bytes with
    // a perfectly correct `%class.Named = { ptr, %class.Held }` beside it. Every array of one then
    // allocated a third of what it needed, and element 1's first field landed on element 0's
    // second -- so reading `many[0].value` gave `many[1].name`, silently and plausibly.
    //
    // This is what lets the lowering measure them all again once every declaration is in, and keep
    // measuring until nothing moves. See `settleAggregateSizes`.
    std::vector<const Type*> aggregates() const;

    // ...AND THE INLINE ARRAYS, whose size was multiplied out from their element at the moment they
    // were interned. An element that grows afterwards leaves that product stale, which is the same
    // wrong stride reached by another route.
    void refreshInlineArrays();

    // A stable, round-trippable spelling: `i32`, `f64`, `ptr`, `addr32`, `[16 x i32 inline]`,
    // `{i32, ptr}`, `%Point`, `<Pace|i32>`.
    static std::string spell(const Type* type);

private:
    const Type* intern(Type&& candidate);

    std::vector<std::unique_ptr<Type>> owned_;
    std::unordered_map<std::string, const Type*> byKey_;
    std::unordered_map<std::string, const Type*> structsByName_;
    const Type* void_ = nullptr;
    const Type* bool_ = nullptr;
    const Type* ptr_ = nullptr;
    const Type* region_ = nullptr;
};

}  // namespace polaron::pir
