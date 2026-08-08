// LDP3 region core (spec 17) -- THE ONE implementation of flavored regions, compiled twice.
//
// Hosted: runtime/ldp3_rt.cpp includes this and backs it with the pooled allocator.
// Bare metal: `ldp3 build` writes this file next to the object it generates and includes it from a
// shim that backs it with static pools (see the freestanding branch of src/driver/build.cpp).
//
// It is ONE file on purpose. The alternative -- a hosted copy and a bare-metal copy of the same 250
// lines of allocator -- is two allocators that agree today and diverge on the first fix applied to
// only one of them, and an allocator that disagrees with itself corrupts memory rather than failing.
// Everything that genuinely differs between the two worlds is a macro the includer defines; nothing
// else is allowed to differ, which is why the layout constants live here and not in either includer.
//
// Include it once for the declarations, and once more with LDP3_REGION_CORE_IMPL defined for the
// bodies (a single include with IMPL defined gets both).

#ifndef LDP3_REGION_CORE_H
#define LDP3_REGION_CORE_H

#ifndef NULL
#define NULL ((void*)0)
#endif

// Terminates the program with a message. Hosted: prints and exits. Bare metal: the weak `cli; hlt`
// stub the driver assembles, which a kernel may override to say something first. The hosted runtime
// has already defined it (with its export attribute) by the time it includes this, and re-declaring it
// plainly there would contradict that attribute -- so it declares LDP3_PANIC_DECLARED instead.
#ifndef LDP3_PANIC_DECLARED
void __ldp3_panic(const char* msg);
#endif

#define LDP3_RMAGIC 0x4C4450335247314EULL  // a live slot inside a `pool`/`fixedslot`/`stack`/`ring` region
#define LDP3_RFREED 0x4C4450335246524EULL  // a region slot sitting on its region's free-list (double-free guard)
#define LDP3_POOL_MAX 512u                 // requests above this size are the "large" class
#define LDP3_NCLASSES 32                   // size classes 16,32,...,512 (step 16)
// A flavored region (pool/fixedslot/ring/stack, any growable region, or a field region -- see the
// destructor registry below) begins with an Ldp3RegionDesc; its object data starts LDP3_REGION_HDR
// bytes in. A fixed 16-aligned constant so the compiler and the runtime agree on the data offset
// without the compiler needing sizeof(Ldp3RegionDesc). Ldp3RegionDescFits below pins it.
#define LDP3_REGION_HDR 448u

typedef struct Ldp3Hdr {
    unsigned long long magic;
    unsigned int cls;
    unsigned int pad;
} Ldp3Hdr;
typedef struct Ldp3FreeNode {
    struct Ldp3FreeNode* next;
} Ldp3FreeNode;
// One entry of a region's destructor registry: what to destruct, and with what.
typedef struct Ldp3TrackEntry {
    void* ptr;
    void* dtor;  // void(*)(void*)
} Ldp3TrackEntry;

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
typedef struct Ldp3RegionDesc {
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
    void*              ringDtor;  // +96 ring: the single element type's destructor (all entries share it)
    // growable region (spec 17): blocks chain on overflow. `growNext` links each block to the next;
    // `growTail` (head only) is the current bump block; `growable` is the flag. A shared free-list on the
    // head serves pool/fixedslot reuse across the whole chain. `release` frees the chain.
    struct Ldp3RegionDesc* growNext;  // +104 next block in the chain (null = last)
    struct Ldp3RegionDesc* growTail;  // +112 head only: the block currently being bumped
    unsigned long long growable;      // +120 1 = chain a new block on overflow instead of trapping
    Ldp3FreeNode*      freelists[LDP3_NCLASSES + 1];  // +128 per size class; [LDP3_NCLASSES] = large (>512)
} Ldp3RegionDesc;
// The compiler hardcodes LDP3_REGION_HDR as the data offset; keep the struct within it.
typedef char Ldp3RegionDescFits[(sizeof(Ldp3RegionDesc) <= LDP3_REGION_HDR) ? 1 : -1];

void  __ldp3_region_init(void* block, unsigned long long flavor, unsigned long long cap,
                         unsigned long long growable);
void* __ldp3_region_new(void* block, unsigned long long size);
void  __ldp3_region_free(void* block, void* ptr, unsigned long long size);
void  __ldp3_region_free_chain(void* block);
void  __ldp3_region_track(void* block, void* ptr, void* dtor);
void  __ldp3_region_untrack(void* block, void* ptr);
void  __ldp3_region_rollback(void* block, unsigned long long mark);
void  __ldp3_region_teardown(void* block);
void  __ldp3_ring_set_dtor(void* block, void* dtor);
void* __ldp3_ring_new(void* block, unsigned long long size);
void  __ldp3_ring_teardown(void* block);

#endif  // LDP3_REGION_CORE_H

#ifdef LDP3_REGION_CORE_IMPL
#undef LDP3_REGION_CORE_IMPL

// The includer must supply all six. No defaults on purpose: a missing backend should be a compile
// error naming the macro, not a silent fallback to the wrong allocator.
//   LDP3_RGN_BLOCK_ALLOC(bytes)              -> void*, or null; block storage for a grown chain link
//   LDP3_RGN_BLOCK_FREE(p)                   give a chain link back
//   LDP3_RGN_META_ALLOC(p, oldBytes, newBytes) -> void*, or null; grow a registry array (p may be null)
//   LDP3_RGN_META_FREE(p, bytes)             give a registry array back
//   LDP3_RGN_PROF_ALLOC() / LDP3_RGN_PROF_FREE()  allocation-profiler hooks (empty where there is none)
#if !defined(LDP3_RGN_BLOCK_ALLOC) || !defined(LDP3_RGN_BLOCK_FREE) || \
    !defined(LDP3_RGN_META_ALLOC) || !defined(LDP3_RGN_META_FREE) || \
    !defined(LDP3_RGN_PROF_ALLOC) || !defined(LDP3_RGN_PROF_FREE)
#error "ldp3_region_core.h: define the LDP3_RGN_* backend macros before including with LDP3_REGION_CORE_IMPL"
#endif

// Payload size class for a region slot: 0..LDP3_NCLASSES-1 for <=512 (step 16), LDP3_NCLASSES for large.
static unsigned ldp3_region_class(unsigned long long payload) {
    if (payload <= LDP3_POOL_MAX) return (unsigned)((payload + 15) / 16) - 1;
    return LDP3_NCLASSES;  // large: reused only on exact-size match
}

// Initialize a freshly acquired flavored region block (called by codegen right after acquire).
void __ldp3_region_init(void* block, unsigned long long flavor, unsigned long long cap,
                        unsigned long long growable) {
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    d->used = 0;
    d->cap = cap;
    d->dataBase = (char*)block + LDP3_REGION_HDR;
    d->flavor = flavor;
    d->entrySize = 0;
    d->ringHead = 0;
    d->ringCount = 0;
    d->ringCap = 0;
    d->track = NULL;
    d->trackCount = 0;
    d->trackCap = 0;
    d->trackPad_ = 0;
    d->ringDtor = NULL;
    d->growNext = NULL;
    d->growTail = d;  // the head is its own initial bump block
    d->growable = growable;
    for (int i = 0; i <= LDP3_NCLASSES; i++) d->freelists[i] = NULL;
}

// Allocate `size` bytes of object storage from a pool/fixedslot/stack region. Pops a same-class free
// slot when available, otherwise bumps a fresh one; traps (no UB) when a fixed region is full.
void* __ldp3_region_new(void* block, unsigned long long size) {
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    unsigned long long payload = (size + 15) & ~15ULL;  // 16-align
    if (payload == 0) payload = 16;
    unsigned cls = ldp3_region_class(payload);
    // Only pool/fixedslot reuse a free-list (shared on the head across all growable blocks). bump/stack
    // always bump: bump frees together on release; stack reclaims LIFO via mark/rollback.
    if (d->flavor == 1 || d->flavor == 3) {
        if (cls < LDP3_NCLASSES) {
            Ldp3FreeNode* n = d->freelists[cls];
            if (n != NULL) {  // reuse: the [16-byte header][payload] is still just before the node
                d->freelists[cls] = n->next;
                ((Ldp3Hdr*)((char*)n - 16))->magic = LDP3_RMAGIC;  // live again
                // Region slots are sub-allocations inside a block that the profiler already counts; the
                // block is freed en masse on release, so per-slot live accounting would over-report.
                LDP3_RGN_PROF_ALLOC();
                return (void*)n;
            }
        } else {
            // large: first-fit exact-size match on the large list (homogeneous churn hits the head first)
            Ldp3FreeNode** pp = &d->freelists[LDP3_NCLASSES];
            while (*pp != NULL) {
                Ldp3Hdr* h = (Ldp3Hdr*)((char*)(*pp) - 16);
                if (h->pad == (unsigned)payload) {
                    Ldp3FreeNode* n = *pp;
                    *pp = n->next;
                    h->magic = LDP3_RMAGIC;
                    LDP3_RGN_PROF_ALLOC();
                    return (void*)n;
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
        void* nb = LDP3_RGN_BLOCK_ALLOC(LDP3_REGION_HDR + newcap);
        if (nb == NULL) __ldp3_panic("out of memory growing a region");
        __ldp3_region_init(nb, d->flavor, newcap, 1);
        tail->growNext = (Ldp3RegionDesc*)nb;
        d->growTail = (Ldp3RegionDesc*)nb;
        tail = (Ldp3RegionDesc*)nb;
    }
    char* slot = (char*)tail->dataBase + tail->used;
    tail->used += slotBytes;
    Ldp3Hdr* h = (Ldp3Hdr*)slot;
    h->magic = LDP3_RMAGIC;
    h->cls = cls;
    h->pad = (unsigned)payload;
    LDP3_RGN_PROF_ALLOC();  // block-level bytes already counted at acquire
    return slot + 16;
}

// Drop `ptr` from a region's destructor registry, so a later rollback/teardown never destructs an
// object that has already been destructed by hand. Shifting keeps the registry in allocation order,
// which is what lets rollback stop at the first entry older than its mark.
void __ldp3_region_untrack(void* block, void* ptr) {
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    for (unsigned long long i = d->trackCount; i > 0; --i) {
        if (d->track[i - 1].ptr != ptr) continue;
        for (unsigned long long j = i - 1; j + 1 < d->trackCount; ++j) d->track[j] = d->track[j + 1];
        d->trackCount--;
        return;
    }
}

// Return an object's slot to its pool/fixedslot region's free-list. Traps on a double free or on a
// pointer that is not a live region slot, rather than corrupting the list (no UB). `size` is unused (the
// slot header remembers its class) but kept in the ABI for symmetry and future validation.
void __ldp3_region_free(void* block, void* ptr, unsigned long long size) {
    (void)size;
    if (ptr == NULL) return;
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
    if (h->magic == LDP3_RFREED) __ldp3_panic("double free of a region object (it was already deleted or extracted)");
    if (h->magic != LDP3_RMAGIC) __ldp3_panic("region free of a pointer that this region did not allocate");
    unsigned cls = h->cls;
    LDP3_RGN_PROF_FREE();  // per-slot live is not tracked (see region_new)
    h->magic = LDP3_RFREED;
    // Whatever the flavor: this object has just been destructed by hand, so the registry must forget it
    // or teardown would destruct it again. A no-op when it was never tracked (no destructor).
    __ldp3_region_untrack(block, ptr);
    if (d->flavor == 2) {  // stack: no free-list; reclaim LIFO if this was the top slot.
        unsigned long long slotBytes = 16 + (unsigned long long)h->pad;
        if ((char*)h + slotBytes == (char*)d->dataBase + d->used) d->used -= slotBytes;  // top: reclaim
        return;
    }
    Ldp3FreeNode* n = (Ldp3FreeNode*)ptr;
    unsigned idx = (cls < LDP3_NCLASSES) ? cls : LDP3_NCLASSES;
    n->next = d->freelists[idx];
    d->freelists[idx] = n;
}

// Free every block of a (possibly growable) region chain. Called by codegen on release/scope exit of a
// growable region, after its objects' destructors have run. A non-growable region has a null growNext, so
// this frees just its one block (equivalent to release without the block cache).
void __ldp3_region_free_chain(void* block) {
    Ldp3RegionDesc* b = (Ldp3RegionDesc*)block;
    while (b != NULL) {
        Ldp3RegionDesc* next = b->growNext;
        LDP3_RGN_BLOCK_FREE(b);
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
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    if (d->trackCount == d->trackCap) {
        unsigned long long ncap = d->trackCap == 0 ? 16 : d->trackCap * 2;
        Ldp3TrackEntry* nt = (Ldp3TrackEntry*)LDP3_RGN_META_ALLOC(
            d->track, d->trackCap * sizeof(Ldp3TrackEntry), ncap * sizeof(Ldp3TrackEntry));
        if (nt == NULL) __ldp3_panic("out of memory tracking a region object's destructor");
        d->track = nt;
        d->trackCap = ncap;
    }
    d->track[d->trackCount].ptr = ptr;
    d->track[d->trackCount].dtor = dtor;
    d->trackCount++;
}

// Roll a stack region back to a mark: run destructors newest-first for every tracked object allocated at
// or after `mark` (byte offset into the data area), then reset the cursor. `mark == 0` destructs all (used
// by release). Objects without destructors are not tracked; the cursor reset reclaims their memory anyway.
void __ldp3_region_rollback(void* block, unsigned long long mark) {
    if (block == NULL) return;  // an unallocated / already-released region
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    char* threshold = (char*)d->dataBase + mark;  // slots at or after this are being rolled back
    while (d->trackCount > 0) {
        void* ptr = d->track[d->trackCount - 1].ptr;
        if ((char*)ptr - 16 < threshold) break;  // older than the mark: keep it (registry is in alloc order)
        Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
        d->trackCount--;
        if (h->magic == LDP3_RMAGIC) {  // still live (not already deleted): destruct it once
            h->magic = LDP3_RFREED;
            ((void (*)(void*))d->track[d->trackCount].dtor)(ptr);
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
    if (block == NULL) return;  // an unallocated / already-released region (explicit release nulled it)
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    if (d->flavor == 2) {
        __ldp3_region_rollback(block, 0);  // destruct everything still live
    } else {
        while (d->trackCount > 0) {
            d->trackCount--;
            ((void (*)(void*))d->track[d->trackCount].dtor)(d->track[d->trackCount].ptr);
        }
    }
    LDP3_RGN_META_FREE(d->track, d->trackCap * sizeof(Ldp3TrackEntry));
    d->track = NULL;
    d->trackCap = 0;
}

// ---- ring flavor (spec 17): a fixed-capacity circular buffer of one element type ----
// All entries share a single element type, so the region stores its one destructor. Set once, at the ring
// region's declaration, from its `.accepts({T})` type (null when that type has no destructor).
void __ldp3_ring_set_dtor(void* block, void* dtor) {
    if (block == NULL) return;
    ((Ldp3RegionDesc*)block)->ringDtor = dtor;
}

// Allocate the next ring slot. Slots are fixed-size ([16-byte header][payload]); when the ring is full a
// new allocation overwrites the oldest entry -- its destructor runs first (no leak), then the memory is
// reused in place. Returns the slot payload (the caller's constructor writes it).
void* __ldp3_ring_new(void* block, unsigned long long size) {
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    if (d->entrySize == 0) {  // first allocation fixes the entry size and capacity in entries
        unsigned long long payload = (size + 15) & ~15ULL;
        if (payload == 0) payload = 16;
        d->entrySize = 16 + payload;
        d->ringCap = d->cap / d->entrySize;
        if (d->ringCap == 0)
            __ldp3_panic("ring region is too small to hold even one entry -- give itself.allocate a bigger size");
    }
    unsigned long long widx = (d->ringHead + d->ringCount) % d->ringCap;
    char* slot = (char*)d->dataBase + widx * d->entrySize;
    if (d->ringCount < d->ringCap) {
        d->ringCount++;
        LDP3_RGN_PROF_ALLOC();  // per-slot live not tracked (see region_new)
    } else {  // full: evict the oldest (this same slot), running its destructor before reuse
        Ldp3Hdr* oh = (Ldp3Hdr*)slot;
        if (d->ringDtor != NULL && oh->magic == LDP3_RMAGIC) {
            oh->magic = LDP3_RFREED;
            ((void (*)(void*))d->ringDtor)(slot + 16);
        }
        d->ringHead = (d->ringHead + 1) % d->ringCap;
        LDP3_RGN_PROF_ALLOC();
    }
    unsigned long long payload = d->entrySize - 16;
    Ldp3Hdr* h = (Ldp3Hdr*)slot;
    h->magic = LDP3_RMAGIC;
    h->cls = ldp3_region_class(payload);
    h->pad = (unsigned)payload;
    return slot + 16;
}

// Destruct a ring region's live entries (oldest to newest) before its block is freed.
void __ldp3_ring_teardown(void* block) {
    if (block == NULL) return;
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    if (d->ringDtor == NULL || d->ringCap == 0) return;  // no destructor / never used
    for (unsigned long long i = 0; i < d->ringCount; i++) {
        unsigned long long idx = (d->ringHead + i) % d->ringCap;
        char* slot = (char*)d->dataBase + idx * d->entrySize;
        Ldp3Hdr* h = (Ldp3Hdr*)slot;
        if (h->magic == LDP3_RMAGIC) {
            h->magic = LDP3_RFREED;
            ((void (*)(void*))d->ringDtor)(slot + 16);
        }
    }
    d->ringCount = 0;
}

#endif  // LDP3_REGION_CORE_IMPL
