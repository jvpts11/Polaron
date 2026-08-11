// LDP3 region core (spec 17) -- THE ONE implementation of flavored regions, compiled twice.
//
// Hosted: runtime/ldp3_rt.cpp includes this and backs it with the pooled allocator.
// Bare metal: `ldp3 build` writes this file next to the object it generates and includes it from a
// shim that backs it with static pools (see the freestanding branch of src/driver/build.cpp).
//
// It is ONE file on purpose. The alternative -- a hosted copy and a bare-metal copy of the same 250
// lines of allocator -- is two allocators that agree today and diverge on the first fix applied to
// only one of them, and an allocator that disagrees with itself corrupts memory rather than failing.
// Everything that genuinely differs between the two worlds is supplied by the includer; nothing else
// is allowed to differ, which is why the layout constants live here and not in either includer.
//
// Include it once for the declarations, and once more with LDP3_REGION_CORE_IMPL defined for the
// bodies (a single include with IMPL defined gets both).
//
// C++ ON BOTH SIDES, which it was not until now: the hosted runtime compiled it as C++ (it is
// included from a .cpp) while `ldp3 build` compiled the very same text as C, so the one file the
// language cannot afford to have two of was read by two different languages. It is C++ now -- and
// only C++ -- so the two compilations differ in their backing and in nothing else.

#ifndef LDP3_REGION_CORE_HPP
#define LDP3_REGION_CORE_HPP

// HOW THESE NAMES REACH THE LINKER.
//
// Codegen emits calls to `__ldp3_region_init` -- that exact spelling -- so a definition here must
// carry that exact symbol, and C++ would otherwise mangle it. An asm label says the name and nothing
// else: unlike a linkage specification it does not also drag in C's rules for the declaration it sits
// on. The hosted runtime includes this file inside its own linkage block and defines this to nothing;
// the bare-metal shim, compiled by clang, defines it to the label.
#ifndef LDP3_ABI
#define LDP3_ABI(name)
#endif

// Terminates the program with a message. Hosted: prints and exits. Bare metal: the weak `cli; hlt`
// stub the driver assembles, which a kernel may override to say something first. The hosted runtime
// has already defined it (with its export attribute) by the time it includes this, and re-declaring it
// plainly there would contradict that attribute -- so it declares LDP3_PANIC_DECLARED instead.
#ifndef LDP3_PANIC_DECLARED
void __ldp3_panic(const char* msg) LDP3_ABI(__ldp3_panic);
#endif

constexpr unsigned long long LDP3_RMAGIC = 0x4C4450335247314EULL;  // a live slot inside a `pool`/`fixedslot`/`stack`/`ring` region
constexpr unsigned long long LDP3_RFREED = 0x4C4450335246524EULL;  // a region slot sitting on its region's free-list (double-free guard)
constexpr unsigned long long LDP3_POOL_MAX = 512;                  // requests above this size are the "large" class
constexpr unsigned LDP3_NCLASSES = 32;                             // size classes 16,32,...,512 (step 16)
// A flavored region (pool/fixedslot/ring/stack, any growable region, or a field region -- see the
// destructor registry below) begins with an Ldp3RegionDesc; its object data starts LDP3_REGION_HDR
// bytes in. A fixed 16-aligned constant so the compiler and the runtime agree on the data offset
// without the compiler needing sizeof(Ldp3RegionDesc). The static_assert below pins it.
constexpr unsigned long long LDP3_REGION_HDR = 448;

// An object's destructor as the core stores it. The ABI hands these across as `void*` -- that is what
// codegen emits -- so the conversion happens once, at the boundary, instead of at every call site.
using Ldp3Dtor = void (*)(void*);

struct Ldp3Hdr {
    unsigned long long magic;
    unsigned int cls;
    unsigned int pad;
};
struct Ldp3FreeNode {
    Ldp3FreeNode* next;
};
// One entry of a region's destructor registry: what to destruct, and with what.
struct Ldp3TrackEntry {
    void* ptr;
    Ldp3Dtor dtor;
};

// A flavored region's block starts with this descriptor. The first three fields deliberately mirror
// the lean bump header ([used][cap][dataBase] at 0/8/16) so the inline bump cursor the compiler emits
// -- and __ldp3_region_release -- read them the same way for every flavor.
//
// pool/fixedslot/stack allocate a slot per object: [16-byte Ldp3Hdr][payload], the payload 16-aligned.
// pool/fixedslot: a freed slot goes on freelists[class]; a later same-class allocation pops it
// (pointers never move). stack: pure bump (no free-list) plus mark/rollback. bump: no runtime call at
// all -- the compiler bumps `used` in a register and the data carries no per-slot header, which is what
// makes it cost exactly what a hand-written arena costs. Slots carry LDP3_RMAGIC (distinct from the
// heap's LDP3_MAGIC) so a mistaken plain `delete`/`free` traps instead of splicing a region-interior
// pointer onto the global heap free-list (no exploitable UB).
struct Ldp3RegionDesc {
    unsigned long long used;      // +0  bump cursor over the data area, in bytes (mirrors lean header)
    unsigned long long cap;       // +8  data-area capacity in bytes (mirrors lean header)
    void*              dataBase;  // +16 = (char*)block + LDP3_REGION_HDR (mirrors lean header)
    unsigned long long flavor;    // +24 0=bump, 1=pool, 2=stack, 3=fixedslot, 4=ring
    unsigned long long entrySize; // +32 fixedslot/ring slot payload size (0 for a general pool)
    unsigned long long ringHead;  // +40 ring: index of the oldest entry
    unsigned long long ringCount; // +48 ring: number of live entries
    unsigned long long ringCap;   // +56 ring: capacity in entries
    // Destructor registry: objects with destructors, in allocation order (== address order, since both
    // stack and bump bump upward). Rollback/teardown walk it newest-first. Off the arena, so a region's
    // declared capacity is entirely the user's; only objects that HAVE a destructor are ever recorded.
    // ONE array of pairs rather than two parallel arrays: half the growth steps, and a teardown walk
    // that touches each cache line once.
    Ldp3TrackEntry*    track;     // +64
    unsigned long long trackCount;// +72
    unsigned long long trackCap;  // +80
    unsigned long long trackPad_; // +88 (reserved; keeps the following offsets where they were)
    Ldp3Dtor           ringDtor;  // +96 ring: the single element type's destructor (all entries share it)
    // growable region (spec 17): blocks chain on overflow. `growNext` links each block to the next;
    // `growTail` (head only) is the current bump block; `growable` is the flag. A shared free-list on the
    // head serves pool/fixedslot reuse across the whole chain. `release` frees the chain.
    Ldp3RegionDesc*    growNext;  // +104 next block in the chain (null = last)
    Ldp3RegionDesc*    growTail;  // +112 head only: the block currently being bumped
    unsigned long long growable;  // +120 1 = chain a new block on overflow instead of trapping
    Ldp3FreeNode*      freelists[LDP3_NCLASSES + 1];  // +128 per size class; [LDP3_NCLASSES] = large (>512)
};
// The compiler hardcodes LDP3_REGION_HDR as the data offset; keep the struct within it.
static_assert(sizeof(Ldp3RegionDesc) <= LDP3_REGION_HDR,
              "Ldp3RegionDesc outgrew LDP3_REGION_HDR, the data offset the compiler hardcodes");

void  __ldp3_region_init(void* block, unsigned long long flavor, unsigned long long cap,
                         unsigned long long growable) LDP3_ABI(__ldp3_region_init);
void* __ldp3_region_new(void* block, unsigned long long size) LDP3_ABI(__ldp3_region_new);
void  __ldp3_region_free(void* block, void* ptr, unsigned long long size) LDP3_ABI(__ldp3_region_free);
void  __ldp3_region_free_chain(void* block) LDP3_ABI(__ldp3_region_free_chain);
void  __ldp3_region_track(void* block, void* ptr, void* dtor) LDP3_ABI(__ldp3_region_track);
void  __ldp3_region_untrack(void* block, void* ptr) LDP3_ABI(__ldp3_region_untrack);
void  __ldp3_region_rollback(void* block, unsigned long long mark) LDP3_ABI(__ldp3_region_rollback);
void  __ldp3_region_teardown(void* block) LDP3_ABI(__ldp3_region_teardown);
void  __ldp3_ring_set_dtor(void* block, void* dtor) LDP3_ABI(__ldp3_ring_set_dtor);
void* __ldp3_ring_new(void* block, unsigned long long size) LDP3_ABI(__ldp3_ring_new);
void  __ldp3_ring_teardown(void* block) LDP3_ABI(__ldp3_ring_teardown);

// ---- region snapshots (spec 32.2) ----
//
// A snapshot is a COPY, not a mark. A mark would be eight bytes and would restore a `stack` or `bump`
// region perfectly -- but it says nothing about a `pool`, where freed slots return to free-lists and
// the cursor stops describing the state. Snapshots are meant to work with any region, so they carry
// the bytes, and that is why they need somewhere to live and have to be released by hand.
//
// The layout is this header followed by `used` bytes of the region's data area, contiguous, so the
// caller owns and places ONE block.
struct Ldp3SnapshotHead {
    unsigned long long magic;
    unsigned long long used;
    unsigned long long trackCount;
    unsigned long long ringHead;
    unsigned long long ringCount;
    unsigned long long entrySize;
    Ldp3FreeNode*      freelists[LDP3_NCLASSES + 1];
};
constexpr unsigned long long LDP3_SNAPMAGIC = 0x4C445033534E4150ULL;  // "LDP3SNAP"

unsigned long long __ldp3_region_snapshot_size(void* block) LDP3_ABI(__ldp3_region_snapshot_size);
void __ldp3_region_snapshot(void* block, void* into,
                            unsigned long long room) LDP3_ABI(__ldp3_region_snapshot);
void __ldp3_region_restore(void* block, const void* from) LDP3_ABI(__ldp3_region_restore);
// The payload size of a region slot, read from its own header -- what `snapshot region W into k` has
// to pass as `room`, since k's block was sized when k was declared and the region may have grown.
unsigned long long __ldp3_region_slot_size(void* ptr) LDP3_ABI(__ldp3_region_slot_size);

#endif  // LDP3_REGION_CORE_HPP

#ifdef LDP3_REGION_CORE_IMPL
#undef LDP3_REGION_CORE_IMPL

// THE BACKING, as a class the includer names in LDP3_REGION_BACKEND. It holds everything that
// genuinely differs between a hosted program and a kernel, and nothing else does.
//
// It was six function-like macros. A class says the same thing with types on it and turns a missing
// piece into an error that names the method instead of a token that quietly expands to nothing. The
// methods are static and defined in the including translation unit, so an optimizing build folds them
// in exactly as the macros were folded in -- but a build with NO optimization does not, and the
// bare-metal side is one of those, so it says `always_inline` on the ones that were empty. Shape:
//
//   class TheBacking {
//     public:
//       static void* blockAlloc(unsigned long long bytes);  // block storage for a grown chain link
//       static void  blockFree(void* p);                    // give a chain link back
//       static void* metaAlloc(void* p, unsigned long long oldBytes, unsigned long long newBytes);
//       static void  metaFree(void* p, unsigned long long bytes);
//       static void  profileAlloc();                        // allocation-profiler hooks; empty
//       static void  profileFree();                         // where there is no profiler
//   };
//
// blockAlloc/metaAlloc return null when they cannot satisfy the request; metaAlloc's `p` may be null.
#ifndef LDP3_REGION_BACKEND
#error "ldp3_region_core.hpp: define LDP3_REGION_BACKEND to the backing class before including with LDP3_REGION_CORE_IMPL"
#endif
using Ldp3Backend = LDP3_REGION_BACKEND;

// Payload size class for a region slot: 0..LDP3_NCLASSES-1 for <=512 (step 16), LDP3_NCLASSES for large.
static unsigned ldp3_region_class(unsigned long long payload) {
    if (payload <= LDP3_POOL_MAX) return static_cast<unsigned>((payload + 15) / 16) - 1;
    return LDP3_NCLASSES;  // large: reused only on exact-size match
}

// Initialize a freshly acquired flavored region block (called by codegen right after acquire).
void __ldp3_region_init(void* block, unsigned long long flavor, unsigned long long cap,
                        unsigned long long growable) {
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    d->used = 0;
    d->cap = cap;
    d->dataBase = static_cast<char*>(block) + LDP3_REGION_HDR;
    d->flavor = flavor;
    d->entrySize = 0;
    d->ringHead = 0;
    d->ringCount = 0;
    d->ringCap = 0;
    d->track = nullptr;
    d->trackCount = 0;
    d->trackCap = 0;
    d->trackPad_ = 0;
    d->ringDtor = nullptr;
    d->growNext = nullptr;
    d->growTail = d;  // the head is its own initial bump block
    d->growable = growable;
    for (unsigned i = 0; i <= LDP3_NCLASSES; i++) d->freelists[i] = nullptr;
}

// Allocate `size` bytes of object storage from a pool/fixedslot/stack region. Pops a same-class free
// slot when available, otherwise bumps a fresh one; traps (no UB) when a fixed region is full.
void* __ldp3_region_new(void* block, unsigned long long size) {
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    unsigned long long payload = (size + 15) & ~15ULL;  // 16-align
    if (payload == 0) payload = 16;
    unsigned cls = ldp3_region_class(payload);
    // Only pool/fixedslot reuse a free-list (shared on the head across all growable blocks). bump/stack
    // always bump: bump frees together on release; stack reclaims LIFO via mark/rollback.
    if (d->flavor == 1 || d->flavor == 3) {
        if (cls < LDP3_NCLASSES) {
            Ldp3FreeNode* n = d->freelists[cls];
            if (n != nullptr) {  // reuse: the [16-byte header][payload] is still just before the node
                d->freelists[cls] = n->next;
                reinterpret_cast<Ldp3Hdr*>(reinterpret_cast<char*>(n) - 16)->magic = LDP3_RMAGIC;  // live again
                // Region slots are sub-allocations inside a block that the profiler already counts; the
                // block is freed en masse on release, so per-slot live accounting would over-report.
                Ldp3Backend::profileAlloc();
                return n;
            }
        } else {
            // large: first-fit exact-size match on the large list (homogeneous churn hits the head first)
            Ldp3FreeNode** pp = &d->freelists[LDP3_NCLASSES];
            while (*pp != nullptr) {
                Ldp3Hdr* h = reinterpret_cast<Ldp3Hdr*>(reinterpret_cast<char*>(*pp) - 16);
                if (h->pad == static_cast<unsigned>(payload)) {
                    Ldp3FreeNode* n = *pp;
                    *pp = n->next;
                    h->magic = LDP3_RMAGIC;
                    Ldp3Backend::profileAlloc();
                    return n;
                }
                pp = &(*pp)->next;
            }
        }
    }
    unsigned long long slotBytes = 16 + payload;
    // Bump in the current tail block. A growable region chains a new block on overflow instead of trapping;
    // a fixed region traps (no UB). The shared free-list above means steady-state churn never grows.
    Ldp3RegionDesc* tail = d->growable ? d->growTail : d;
    if (tail->used + slotBytes > tail->cap) {
        if (!d->growable)
            __ldp3_panic("region out of memory: this fixed region is full -- give itself.allocate a bigger size, delete/extract objects to reclaim slots, or make it a `growable` region");
        unsigned long long newcap = tail->cap;          // grow by at least the previous block's size
        if (newcap < slotBytes) newcap = slotBytes;
        void* nb = Ldp3Backend::blockAlloc(LDP3_REGION_HDR + newcap);
        if (nb == nullptr) __ldp3_panic("out of memory growing a region");
        __ldp3_region_init(nb, d->flavor, newcap, 1);
        Ldp3RegionDesc* grown = static_cast<Ldp3RegionDesc*>(nb);
        tail->growNext = grown;
        d->growTail = grown;
        tail = grown;
    }
    char* slot = static_cast<char*>(tail->dataBase) + tail->used;
    tail->used += slotBytes;
    Ldp3Hdr* h = reinterpret_cast<Ldp3Hdr*>(slot);
    h->magic = LDP3_RMAGIC;
    h->cls = cls;
    h->pad = static_cast<unsigned>(payload);
    Ldp3Backend::profileAlloc();  // block-level bytes already counted at acquire
    return slot + 16;
}

// Drop `ptr` from a region's destructor registry, so a later rollback/teardown never destructs an
// object that has already been destructed by hand. Shifting keeps the registry in allocation order,
// which is what lets rollback stop at the first entry older than its mark.
void __ldp3_region_untrack(void* block, void* ptr) {
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    for (unsigned long long i = d->trackCount; i > 0; --i) {
        if (d->track[i - 1].ptr != ptr) continue;
        for (unsigned long long j = i - 1; j + 1 < d->trackCount; ++j) d->track[j] = d->track[j + 1];
        d->trackCount--;
        return;
    }
}

// Return an object's slot to its pool/fixedslot region's free-list. Traps on a double free or on a
// pointer that is not a live region slot, rather than corrupting the list (no UB). The size is unused
// (the slot header remembers its class) but kept in the ABI for symmetry and future validation, which
// is why the parameter is unnamed here.
void __ldp3_region_free(void* block, void* ptr, unsigned long long) {
    if (ptr == nullptr) return;
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    Ldp3Hdr* h = reinterpret_cast<Ldp3Hdr*>(static_cast<char*>(ptr) - 16);
    if (h->magic == LDP3_RFREED) __ldp3_panic("double free of a region object (it was already deleted or extracted)");
    if (h->magic != LDP3_RMAGIC) __ldp3_panic("region free of a pointer that this region did not allocate");
    unsigned cls = h->cls;
    Ldp3Backend::profileFree();  // per-slot live is not tracked (see region_new)
    h->magic = LDP3_RFREED;
    // Whatever the flavor: this object has just been destructed by hand, so the registry must forget it
    // or teardown would destruct it again. A no-op when it was never tracked (no destructor).
    __ldp3_region_untrack(block, ptr);
    if (d->flavor == 2) {  // stack: no free-list; reclaim LIFO if this was the top slot.
        unsigned long long slotBytes = 16 + static_cast<unsigned long long>(h->pad);
        if (reinterpret_cast<char*>(h) + slotBytes == static_cast<char*>(d->dataBase) + d->used)
            d->used -= slotBytes;  // top: reclaim
        return;
    }
    Ldp3FreeNode* n = static_cast<Ldp3FreeNode*>(ptr);
    unsigned idx = (cls < LDP3_NCLASSES) ? cls : LDP3_NCLASSES;
    n->next = d->freelists[idx];
    d->freelists[idx] = n;
}

// Free every block of a (possibly growable) region chain. Called by codegen on release/scope exit of a
// growable region, after its objects' destructors have run. A non-growable region has a null growNext, so
// this frees just its one block (equivalent to release without the block cache).
void __ldp3_region_free_chain(void* block) {
    Ldp3RegionDesc* b = static_cast<Ldp3RegionDesc*>(block);
    while (b != nullptr) {
        Ldp3RegionDesc* next = b->growNext;
        Ldp3Backend::blockFree(b);
        b = next;
    }
}

// Record a region object that has a destructor, so rollback/teardown can run it (newest first).
//
// This is what makes a region's destructors correct rather than merely lexical. The compiler can only
// see the objects created in the block that releases the region; a tree built across method calls, or
// anything put into a FIELD region by some other method, is invisible to it. The registry is the answer
// and it is why regions can hold objects at all. Only objects that HAVE a destructor reach here, so a
// region of plain data (the case where a region must match a hand-written arena instruction for
// instruction) never allocates a registry and never calls this.
void __ldp3_region_track(void* block, void* ptr, void* dtor) {
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    if (d->trackCount == d->trackCap) {
        unsigned long long ncap = d->trackCap == 0 ? 16 : d->trackCap * 2;
        Ldp3TrackEntry* nt = static_cast<Ldp3TrackEntry*>(Ldp3Backend::metaAlloc(
            d->track, d->trackCap * sizeof(Ldp3TrackEntry), ncap * sizeof(Ldp3TrackEntry)));
        if (nt == nullptr) __ldp3_panic("out of memory tracking a region object's destructor");
        d->track = nt;
        d->trackCap = ncap;
    }
    d->track[d->trackCount].ptr = ptr;
    d->track[d->trackCount].dtor = reinterpret_cast<Ldp3Dtor>(dtor);
    d->trackCount++;
}

// Roll a stack region back to a mark: run destructors newest-first for every tracked object allocated at
// or after `mark` (byte offset into the data area), then reset the cursor. `mark == 0` destructs all (used
// by release). Objects without destructors are not tracked; the cursor reset reclaims their memory anyway.
void __ldp3_region_rollback(void* block, unsigned long long mark) {
    if (block == nullptr) return;  // an unallocated / already-released region
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    char* threshold = static_cast<char*>(d->dataBase) + mark;  // slots at or after this are being rolled back
    while (d->trackCount > 0) {
        void* ptr = d->track[d->trackCount - 1].ptr;
        char* slot = static_cast<char*>(ptr) - 16;
        if (slot < threshold) break;  // older than the mark: keep it (registry is in alloc order)
        Ldp3Hdr* h = reinterpret_cast<Ldp3Hdr*>(slot);
        d->trackCount--;
        if (h->magic == LDP3_RMAGIC) {  // still live (not already deleted): destruct it once
            h->magic = LDP3_RFREED;
            d->track[d->trackCount].dtor(ptr);
        }
    }
    d->used = mark;
}

// Tear a region down before its block is freed: run every remaining destructor, newest-first, and give
// the registry arrays back. Codegen calls this right before __ldp3_region_release for any region that
// can hold destructible objects.
//
// A stack region goes through rollback, which reads each slot's LDP3_RMAGIC to skip what an explicit
// `delete ... from region` already destructed. A BUMP region has no per-slot header to read -- the
// absence of one is precisely what keeps its allocation as cheap as a hand-written arena's -- so its
// liveness IS the registry: an explicit delete untracks, and nothing else can remove an entry.
void __ldp3_region_teardown(void* block) {
    if (block == nullptr) return;  // an unallocated / already-released region (explicit release nulled it)
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    if (d->flavor == 2) {
        __ldp3_region_rollback(block, 0);  // destruct everything still live
    } else {
        while (d->trackCount > 0) {
            d->trackCount--;
            d->track[d->trackCount].dtor(d->track[d->trackCount].ptr);
        }
    }
    Ldp3Backend::metaFree(d->track, d->trackCap * sizeof(Ldp3TrackEntry));
    d->track = nullptr;
    d->trackCap = 0;
}

// ---- ring flavor (spec 17): a fixed-capacity circular buffer of one element type ----
// All entries share a single element type, so the region stores its one destructor. Set once, at the ring
// region's declaration, from its `.accepts({T})` type (null when that type has no destructor).
void __ldp3_ring_set_dtor(void* block, void* dtor) {
    if (block == nullptr) return;
    static_cast<Ldp3RegionDesc*>(block)->ringDtor = reinterpret_cast<Ldp3Dtor>(dtor);
}

// Allocate the next ring slot. Slots are fixed-size ([16-byte header][payload]); when the ring is full a
// new allocation overwrites the oldest entry -- its destructor runs first (no leak), then the memory is
// reused in place. Returns the slot payload (the caller's constructor writes it).
void* __ldp3_ring_new(void* block, unsigned long long size) {
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    if (d->entrySize == 0) {  // first allocation fixes the entry size and capacity in entries
        unsigned long long payload = (size + 15) & ~15ULL;
        if (payload == 0) payload = 16;
        d->entrySize = 16 + payload;
        d->ringCap = d->cap / d->entrySize;
        if (d->ringCap == 0)
            __ldp3_panic("ring region is too small to hold even one entry -- give itself.allocate a bigger size");
    }
    unsigned long long widx = (d->ringHead + d->ringCount) % d->ringCap;
    char* slot = static_cast<char*>(d->dataBase) + widx * d->entrySize;
    if (d->ringCount < d->ringCap) {
        d->ringCount++;
        Ldp3Backend::profileAlloc();  // per-slot live not tracked (see region_new)
    } else {  // full: evict the oldest (this same slot), running its destructor before reuse
        Ldp3Hdr* oh = reinterpret_cast<Ldp3Hdr*>(slot);
        if (d->ringDtor != nullptr && oh->magic == LDP3_RMAGIC) {
            oh->magic = LDP3_RFREED;
            d->ringDtor(slot + 16);
        }
        d->ringHead = (d->ringHead + 1) % d->ringCap;
        Ldp3Backend::profileAlloc();
    }
    unsigned long long payload = d->entrySize - 16;
    Ldp3Hdr* h = reinterpret_cast<Ldp3Hdr*>(slot);
    h->magic = LDP3_RMAGIC;
    h->cls = ldp3_region_class(payload);
    h->pad = static_cast<unsigned>(payload);
    return slot + 16;
}

// Destruct a ring region's live entries (oldest to newest) before its block is freed.
void __ldp3_ring_teardown(void* block) {
    if (block == nullptr) return;
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    if (d->ringDtor == nullptr || d->ringCap == 0) return;  // no destructor / never used
    for (unsigned long long i = 0; i < d->ringCount; i++) {
        unsigned long long idx = (d->ringHead + i) % d->ringCap;
        char* slot = static_cast<char*>(d->dataBase) + idx * d->entrySize;
        Ldp3Hdr* h = reinterpret_cast<Ldp3Hdr*>(slot);
        if (h->magic == LDP3_RMAGIC) {
            h->magic = LDP3_RFREED;
            d->ringDtor(slot + 16);
        }
    }
    d->ringCount = 0;
}

// ---- region snapshots (spec 32.2) ----

// How many bytes the caller must give __ldp3_region_snapshot. Asked before the capture so the caller
// can place the snapshot in a region of its own -- the storage is the caller's, always, which is what
// makes a snapshot something the ownership tree can see rather than something beside it.
unsigned long long __ldp3_region_slot_size(void* ptr) {
    if (ptr == nullptr) return 0;
    const Ldp3Hdr* h = reinterpret_cast<const Ldp3Hdr*>(static_cast<const char*>(ptr) - 16);
    // A plain (bump) region has no per-slot header at all -- that absence is exactly what makes its
    // allocation cost what a hand-written arena costs. So a snapshot placed in one has nothing to read
    // here, and reading it anyway is sixteen bytes of whatever preceded it. Say so instead.
    if (h->magic != LDP3_RMAGIC && h->magic != LDP3_RFREED)
        __ldp3_panic("this snapshot is not in a region that can hold one: a plain (bump) region has no "
                     "per-slot header. Place snapshots in a `pool`, `fixedslot` or `stack` region.");
    return h->pad;
}

unsigned long long __ldp3_region_snapshot_size(void* block) {
    if (block == nullptr) return 0;
    const Ldp3RegionDesc* d = static_cast<const Ldp3RegionDesc*>(block);
    return sizeof(Ldp3SnapshotHead) + d->used;
}

// `room` is how many bytes `into` actually holds. It is not decoration: re-capturing into a snapshot
// taken earlier (`snapshot region w into k`) reuses k's block, and the region may have grown since --
// so the one operation whose job is to make a faithful copy would be the one writing past the end.
void __ldp3_region_snapshot(void* block, void* into, unsigned long long room) {
    if (block == nullptr || into == nullptr) return;
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    if (room < sizeof(Ldp3SnapshotHead) + d->used)
        __ldp3_panic("this snapshot does not fit: the region holds more than it did when the snapshot "
                     "it is being written into was taken");
    // A grown region is a CHAIN, and the blocks after the head were acquired after this snapshot would
    // have been taken. Restoring would have to free them, which means owning them, which is a second
    // question this does not answer. Refused with the reason rather than half-captured.
    if (d->growable || d->growNext != nullptr)
        __ldp3_panic("cannot snapshot a growable region: it is a chain of blocks, and a restore would "
                     "have to decide what happens to the blocks acquired after the snapshot");
    Ldp3SnapshotHead* h = static_cast<Ldp3SnapshotHead*>(into);
    h->magic = LDP3_SNAPMAGIC;
    h->used = d->used;
    h->trackCount = d->trackCount;
    h->ringHead = d->ringHead;
    h->ringCount = d->ringCount;
    h->entrySize = d->entrySize;
    for (unsigned i = 0; i <= LDP3_NCLASSES; i++) h->freelists[i] = d->freelists[i];
    const char* src = static_cast<const char*>(d->dataBase);
    char* dst = reinterpret_cast<char*>(h) + sizeof(Ldp3SnapshotHead);
    for (unsigned long long i = 0; i < d->used; ++i) dst[i] = src[i];
}

// Put a region back the way the snapshot found it.
//
// THE DESTRUCTORS RUN FIRST, and that is the whole difference between this and a memcpy. Copying the
// old bytes back over a newer object does not merely lose it -- it leaves a pointer to that object
// aiming at an address that now holds OLD CONTENT CARRYING A LIVE STAMP, so the double-delete guard
// stays quiet and the program goes on holding what looks like a valid object and is a different one.
// That is worse than a dangling pointer, and it is the exact bug class this language exists to remove.
void __ldp3_region_restore(void* block, const void* from) {
    if (block == nullptr || from == nullptr) return;
    Ldp3RegionDesc* d = static_cast<Ldp3RegionDesc*>(block);
    const Ldp3SnapshotHead* h = static_cast<const Ldp3SnapshotHead*>(from);
    if (h->magic != LDP3_SNAPMAGIC)
        __ldp3_panic("restore of something that is not a region snapshot");
    if (h->used > d->cap)
        __ldp3_panic("restoring a snapshot into a region smaller than the one it was taken from");
    // An object destructed BY HAND since the snapshot was untracked, and untracking SHIFTS the
    // registry -- so the entries no longer line up with the ones the snapshot counted, and restoring
    // the old count would name objects that are not there. Trap rather than resurrect a wrong entry.
    if (d->trackCount < h->trackCount)
        __ldp3_panic("a region object was deleted by hand after this snapshot was taken; restoring it "
                     "would revive a destructor entry that no longer matches the object it names");

    // 1) Destructors, newest first, for everything allocated since the snapshot. A `stack` region goes
    //    through rollback, which reads each slot's stamp and so skips what an explicit delete already
    //    destructed; every other flavor keeps its liveness in the registry alone -- the same split
    //    __ldp3_region_teardown makes, for the same reason.
    if (d->flavor == 2) {
        __ldp3_region_rollback(block, h->used);
    } else {
        while (d->trackCount > h->trackCount) {
            d->trackCount--;
            d->track[d->trackCount].dtor(d->track[d->trackCount].ptr);
        }
    }

    // 2) The bytes.
    char* dst = static_cast<char*>(d->dataBase);
    const char* src = reinterpret_cast<const char*>(h) + sizeof(Ldp3SnapshotHead);
    for (unsigned long long i = 0; i < h->used; ++i) dst[i] = src[i];

    // 3) The descriptor's VALUE fields only. `track`, `trackCap`, `dataBase`, `growNext` and `growTail`
    //    are addresses that may have moved since the capture -- the registry array in particular grows
    //    by reallocating -- and writing a stale one back would point the region at freed metadata.
    d->used = h->used;
    d->trackCount = h->trackCount;
    d->ringHead = h->ringHead;
    d->ringCount = h->ringCount;
    d->entrySize = h->entrySize;
    for (unsigned i = 0; i <= LDP3_NCLASSES; i++) d->freelists[i] = h->freelists[i];
}

#endif  // LDP3_REGION_CORE_IMPL
