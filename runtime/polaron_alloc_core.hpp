// NO `#pragma once`, deliberately. This header is included TWICE by the hosted runtime: once early for
// the constants that describe a heap block, which the profiler hooks need, and once later with
// POLARON_ALLOC_CORE_IMPL to emit the allocator itself -- which cannot come first, because it calls a
// backend the file below it defines. Each half carries its own guard instead.
//
// THE HEAP, ONCE, FOR EVERY TARGET.
//
// `__polaron_malloc` / `__polaron_free` were written against libc and lived only in the hosted runtime,
// so any target without a C library had no heap at all. That is what made WebAssembly a patch rather
// than a port: a module could compute, but `on heap`, a `String`, or anything the prelude allocates
// needed symbols nothing supplied -- and the same hole was under every other architecture, hidden only
// because pico happened to write its own allocator and nobody else had tried.
//
// Nothing in the allocator below is about an operating system. Size classes, free lists, a bump slab,
// the sixteen-byte header and the double-free stamp are arithmetic. The ONLY thing it needs from
// underneath is a block of bytes, so that is the only thing a backend supplies:
//
//     class MyBacking {
//       public:
//         static void* blockAlloc(unsigned long long bytes);   // nullptr on failure
//         static void  blockFree(void* p);                     // may be a no-op (static pools)
//         static bool  forwardsForeign();                      // is blockFree safe for a foreign pointer?
//         static void  profileAlloc(PolaronHdr* h, unsigned long long bytes, unsigned cls);
//         static void  profileFree(PolaronHdr* h, unsigned long long bytes, unsigned cls);
//         static void  report(const char* line);               // one diagnostic line, or nothing
//     };
//     #define POLARON_ALLOC_BACKEND MyBacking
//     #define POLARON_ALLOC_CORE_IMPL
//     #include "polaron_alloc_core.hpp"
//
// The header pointer is handed to the profile hooks and not just the size, because the hosted
// runtime's leak-by-site attribution keys on the BLOCK: it stores a short backtrace in the header's
// spare word. A hook that saw only a size could not do it, and dropping a diagnostic to tidy an
// interface is how tools quietly stop existing.
//
// One definition, so a hosted program and a kernel cannot end up disagreeing about what a heap block
// looks like -- the same argument the region core makes about itself.
//
// It requires nothing before it now. `PolaronHdr`, the magics and the size classes used to come from
// `polaron_region_core.hpp`, which had to be included first; that header is gone (the region core is
// Polaron), and those declarations are below. The heap and the regions still share the header layout
// deliberately, so a block freed through the wrong door is DIAGNOSED rather than silently corrupting
// the other allocator -- what changed is which file says what it is.

// What a heap block IS. Its own guard, because a shim that only needs to RECOGNISE one -- to forward
// it, or to refuse it -- must be able to without pulling in the allocator.
//
// `constexpr`, not `#define`, matching the region core's own constants: a macro has no type, no scope,
// and rewrites any later use of the name whether that use meant it or not.
#ifndef POLARON_ALLOC_CORE_CONSTANTS
#define POLARON_ALLOC_CORE_CONSTANTS

/* HOW `__polaron_panic` REACHES THE LINKER, which this file needs and used to be handed.
 *
 * The allocator traps by calling it -- a double free, a foreign pointer with nowhere to go -- and the
 * declaration came from `polaron_region_core.hpp`, which everyone included first. That header is gone
 * (the region core is Polaron now), so the declaration lives with the code that calls it.
 *
 * An asm label says the name and nothing else: unlike a linkage specification it does not also drag
 * in C's rules for the declaration it sits on. The bare-metal shim defines POLARON_ABI to the label;
 * the hosted runtime has already defined `__polaron_panic` with its export attribute by the time it
 * gets here, and re-declaring it plainly would contradict that -- so it defines
 * POLARON_PANIC_DECLARED instead. */
#ifndef POLARON_ABI
#define POLARON_ABI(name)
#endif
#ifndef POLARON_PANIC_DECLARED
void __polaron_panic(const char* msg) POLARON_ABI(__polaron_panic);
#endif

inline constexpr unsigned long long POLARON_MAGIC = 0x4C44503341313142ULL;  // collision with foreign data ~2^-64
inline constexpr unsigned long long POLARON_FREED = 0x4C44503346524545ULL;  // stamped while the block sits freed
inline constexpr unsigned long long POLARON_SLAB = 1ull << 20;              // 1 MiB, bumped then recycled
inline constexpr unsigned POLARON_LARGE = 0xFFFFFFFFu;                      // the class of a block with its own allocation

/* AND WHAT A REGION SLOT IS, which this file needs in order to REFUSE one.

   These two used to come from `polaron_region_core.hpp`, included ahead of this file by everyone who
   included this file. That header is gone: the region core is `runtime/polaron_region_core.pol` now,
   and Polaron cannot be included into C++. So the numbers are written down in two languages -- here,
   and as `RegionCore.Live` / `RegionCore.Freed` -- and THEY MUST AGREE. If they drift, a plain
   `delete` of a region object stops being diagnosed and splices a region-interior pointer onto the
   heap's free-list, which is the one thing the stamps exist to prevent.

   Not a duplication the port invented so much as one it made visible: `POLARON_REGION_HDR` has always
   been written twice, in the runtime and as `kFlavouredRegionHeader` in the lowering, for the same
   reason -- the compiler is not the runtime. What keeps these honest is a test that deletes a region
   object the wrong way and requires the trap. */
inline constexpr unsigned long long POLARON_RMAGIC = 0x4C4450335247314EULL;  // == RegionCore.Live
inline constexpr unsigned long long POLARON_RFREED = 0x4C4450335246524EULL;  // == RegionCore.Freed

/* THE SIZE CLASSES AND THE TWO SHAPES, which moved here from the same place and belong here.

   They were declared by the region core because it was included first, and they read as the region's
   -- but the heap's own free-lists are indexed by these classes and its own blocks carry this header.
   `POLARON_POOL_MAX` is the largest request a class covers, and above it a block gets its own
   allocation; `POLARON_NCLASSES` is how many classes that is, 16 bytes apart. The Polaron region core
   states the same three numbers for its own slots, and for the same reason as the stamps above: the
   two allocators share a header layout so that a block freed through the wrong door is DIAGNOSED. */
inline constexpr unsigned long long POLARON_POOL_MAX = 512;   // above this, a block of its own
inline constexpr unsigned POLARON_NCLASSES = 32;              // 16, 32, ... 512

// The sixteen bytes before every block's payload, heap and region alike.
struct PolaronHdr {
    unsigned long long magic;
    unsigned int cls;
    unsigned int pad;
};
// A dead block's payload, reused as the link of the free-list it sits on.
struct PolaronFreeNode {
    PolaronFreeNode* next;
};
#endif

#ifdef POLARON_ALLOC_CORE_IMPL

#ifndef POLARON_ALLOC_BACKEND
#error "polaron_alloc_core.hpp: define POLARON_ALLOC_BACKEND before including with POLARON_ALLOC_CORE_IMPL"
#endif

// Per-thread, so the common path takes no lock. A freed block returns to the thread that freed it;
// that is a waste rather than a bug when one thread allocates and another frees, and it is the same
// trade the region allocator's measurements settled on.
static POLARON_ALLOC_TLS PolaronFreeNode* g_polaron_free[POLARON_NCLASSES];
static POLARON_ALLOC_TLS char* g_polaron_slab_cur;
static POLARON_ALLOC_TLS char* g_polaron_slab_end;

// Live-block accounting. Always on: `Test.assertNoLeaks` reads it, and one add on a path that already
// touches the header costs nothing measurable.
static POLARON_ALLOC_TLS long long g_live_bytes;
static POLARON_ALLOC_TLS long long g_live_count;

// ...AND THE SAME COUNT BROKEN DOWN BY SIZE CLASS, which is what turns a leak hunt into a reading.
//
// `bytes=976 count=41` says a program held 41 blocks and nothing about WHAT they were, so every
// investigation of a differing total began by compiling both paths and reading IR function by
// function. A block of 24 bytes is a `String` object and almost nothing else; 16 is a two-field
// object; the size names the shape. One array of 33 counters, incremented where the total already
// is, and the answer is in the report instead of in an afternoon.
static POLARON_ALLOC_TLS long long g_live_class[POLARON_NCLASSES + 1];

// Out of memory stops the program HERE, saying what it was asked for.
//
// Returning nullptr instead sent the null straight back to codegen, which zero-fills a fresh array and
// stores a field without ever looking at it, so the failure surfaced as an access violation at address
// zero somewhere unrelated -- the classic C answer, and exactly the undefined behaviour this language
// does not accept. An allocation that cannot be served is a defined, reported end.
static void polaronAllocOom(unsigned long long want) {
    POLARON_ALLOC_BACKEND::report("out of memory: the program asked for more than this machine would "
                                  "give it -- allocate less at once, free what is finished with, or "
                                  "run fewer of whatever is holding memory in parallel");
    (void)want;
    __polaron_panic("out of memory");
}

POLARON_ALLOC_API void* __polaron_malloc(unsigned long long size) {
    if (size == 0) {
        size = 1;
    }
    if (size > POLARON_POOL_MAX) {  // large: its own block, tagged so free/realloc recognise it
        char* p = static_cast<char*>(POLARON_ALLOC_BACKEND::blockAlloc(size + 16));
        if (p == nullptr) {
            polaronAllocOom(size);
        }
        PolaronHdr* h = reinterpret_cast<PolaronHdr*>(p);
        h->magic = POLARON_MAGIC;
        h->cls = POLARON_LARGE;
        h->pad = static_cast<unsigned>(size);   // the size, for the free path's accounting
        g_live_bytes += static_cast<long long>(size);
        g_live_count++;
        g_live_class[POLARON_NCLASSES]++;   // the "larger than any class" bucket
        POLARON_ALLOC_BACKEND::profileAlloc(h, size, POLARON_LARGE);
        return p + 16;
    }
    const unsigned cls = static_cast<unsigned>((size + 15) / 16) - 1;   // 0..31
    if (PolaronFreeNode* n = g_polaron_free[cls]; n != nullptr) {
        // Reuse: the header (magic + class) is still intact just before the node.
        g_polaron_free[cls] = n->next;
        reinterpret_cast<PolaronHdr*>(reinterpret_cast<char*>(n) - 16)->magic = POLARON_MAGIC;
        g_live_bytes += static_cast<long long>(cls + 1) * 16;
        g_live_count++;
        g_live_class[cls]++;
        POLARON_ALLOC_BACKEND::profileAlloc(reinterpret_cast<PolaronHdr*>(reinterpret_cast<char*>(n) - 16), static_cast<unsigned long long>(cls + 1) * 16, cls);
        return static_cast<void*>(n);
    }
    const unsigned long long need = 16 + static_cast<unsigned long long>(cls + 1) * 16;
    if (g_polaron_slab_cur == nullptr || g_polaron_slab_cur + need > g_polaron_slab_end) {
        char* s = static_cast<char*>(POLARON_ALLOC_BACKEND::blockAlloc(POLARON_SLAB));
        if (s == nullptr) {
            polaronAllocOom(POLARON_SLAB);
        }
        g_polaron_slab_cur = s;
        g_polaron_slab_end = s + POLARON_SLAB;
    }
    char* p = g_polaron_slab_cur;
    g_polaron_slab_cur += need;
    PolaronHdr* h = reinterpret_cast<PolaronHdr*>(p);
    h->magic = POLARON_MAGIC;
    h->cls = cls;
    g_live_bytes += static_cast<long long>(cls + 1) * 16;
    g_live_count++;
    g_live_class[cls]++;
    POLARON_ALLOC_BACKEND::profileAlloc(h, static_cast<unsigned long long>(cls + 1) * 16, cls);
    return p + 16;
}

POLARON_ALLOC_API void __polaron_free(void* ptr) {
    if (ptr == nullptr) {
        return;
    }
    // EVERY POINTER THAT REACHES HERE MUST HAVE COME FROM __polaron_malloc.
    //
    // Reading the header means reading the sixteen bytes BEFORE the payload, and if the block was not
    // ours those sixteen bytes belong to somebody else -- so the read is out of bounds and the value is
    // whatever happened to be there. Not a theoretical worry: the runtime's own File.readAll returned a
    // plain libc block, every String built from a file was freed through here, and the bytes in front
    // of a libc block are very often the tail of a Polaron block that has been freed -- stamped,
    // precisely, POLARON_FREED. The double-free guard therefore fired on programs that had not double
    // freed anything.
    PolaronHdr* h = reinterpret_cast<PolaronHdr*>(static_cast<char*>(ptr) - 16);
    if (h->magic == POLARON_FREED) {
        // SAY WHAT WAS IN IT. "double free of a heap block" is true and almost useless. Freeing does
        // not scrub the payload -- only the first eight bytes become the free-list link -- so whatever
        // the block held is still legible, and for the commonest case by far, a String, that is its
        // text, which usually names the site outright.
        char peek[72];
        const unsigned char* body = static_cast<const unsigned char*>(ptr);
        int n = 0;
        while (n < 64 && body[n] != 0) {
            const unsigned char c = body[n];
            peek[n] = (c >= 32 && c < 127) ? static_cast<char>(c) : '.';
            n++;
        }
        peek[n] = '\0';
        if (n > 8) {
            POLARON_ALLOC_BACKEND::report(peek + 8);
        }
        __polaron_panic("double free of a heap block");
    }
    // A pool/fixedslot region slot carries POLARON_RMAGIC/RFREED. It lives INSIDE a region block, so
    // pushing it onto the global free-list would corrupt the heap. Trap with the fix in the message.
    if (h->magic == POLARON_RMAGIC || h->magic == POLARON_RFREED) {
        __polaron_panic("delete of a region object: use `delete X from region R` "
                        "(or `extract X from region R`), not a plain delete");
    }
    if (h->magic != POLARON_MAGIC) {
        // A foreign pointer, from an FFI call. Only a backend with a real allocator underneath can
        // take it back; a static pool has nowhere to put it and must not pretend otherwise.
        if (POLARON_ALLOC_BACKEND::forwardsForeign()) {
            POLARON_ALLOC_BACKEND::blockFree(ptr);
        }
        return;
    }
    if (h->cls == POLARON_LARGE) {
        h->magic = POLARON_FREED;   // stamped before release: guards a same-run double free
        g_live_bytes -= static_cast<long long>(h->pad);
        g_live_count--;
        g_live_class[POLARON_NCLASSES]--;
        POLARON_ALLOC_BACKEND::profileFree(h, h->pad, POLARON_LARGE);
        POLARON_ALLOC_BACKEND::blockFree(h);
        return;
    }
    g_live_bytes -= static_cast<long long>(h->cls + 1) * 16;
    g_live_count--;
    g_live_class[h->cls]--;
    POLARON_ALLOC_BACKEND::profileFree(h, static_cast<unsigned long long>(h->cls + 1) * 16, h->cls);
    h->magic = POLARON_FREED;   // __polaron_malloc clears it on reuse
    PolaronFreeNode* n = static_cast<PolaronFreeNode*>(ptr);   // the payload becomes the list node
    n->next = g_polaron_free[h->cls];
    g_polaron_free[h->cls] = n;
}

// Called at the start of `delete obj`: a pooled object's field 0 is its vtable slot, but once freed
// that word holds the free-list link, so looking up the destructor through it would call through
// garbage. A live pool block carries POLARON_MAGIC; a foreign/stack pointer carries neither stamp and
// is left alone.
POLARON_ALLOC_API void __polaron_check_live(void* ptr) {
    if (ptr == nullptr) {
        return;
    }
    PolaronHdr* h = reinterpret_cast<PolaronHdr*>(static_cast<char*>(ptr) - 16);
    if (h->magic == POLARON_FREED || h->magic == POLARON_RFREED) {
        __polaron_panic("use of a freed object (double delete)");
    }
}

POLARON_ALLOC_API long long __polaron_live_bytes() { return g_live_bytes; }
POLARON_ALLOC_API long long __polaron_live_count() { return g_live_count; }

// How many blocks of one size class are live. Class `k` is `(k + 1) * 16` bytes; class
// `POLARON_NCLASSES` is everything bigger than the classes cover. Out of range answers zero, so a
// caller can walk past the end without knowing where it is.
POLARON_ALLOC_API long long __polaron_live_class(int cls) {
    return (cls < 0 || cls > static_cast<int>(POLARON_NCLASSES)) ? 0 : g_live_class[cls];
}

// ---- The owned String, which is the heap's most frequent customer and needs nothing else ----
//
// A String field or element OWNS its buffer: storing one copies, and overwriting one frees the
// previous. That is what makes `this.field = producer()` not leak, and it is why these two are emitted
// by codegen at every such store -- so a target without them cannot hold a String at all, which is
// what kept a non-freestanding WebAssembly program from linking after the allocator was already
// shared. They are `__polaron_malloc` plus a copy: no operating system anywhere in them.
//
// PolaronStr is declared ONCE here. It was written out again inside each of the runtime's String
// functions -- five copies of a layout that codegen also has to agree with, which is a disagreement
// waiting for the day somebody adds a field.
struct PolaronStr {
    long long len;
    char* data;
    long long hash;   // 0 = not computed yet
};

POLARON_ALLOC_API void* __polaron_str_copy(void* src) {
    if (src == nullptr) {
        return nullptr;
    }
    PolaronStr* s = static_cast<PolaronStr*>(src);
    PolaronStr* out = static_cast<PolaronStr*>(__polaron_malloc(sizeof(PolaronStr)));
    char* buf = static_cast<char*>(__polaron_malloc(static_cast<unsigned long long>(s->len) + 1));
    for (long long i = 0; i < s->len; ++i) {   // not memcpy: a freestanding target may not have one yet
        buf[i] = s->data[i];
    }
    buf[s->len] = 0;
    out->len = s->len;
    out->data = buf;
    out->hash = 0;
    return out;
}

POLARON_ALLOC_API void __polaron_str_free(void* src) {
    if (src == nullptr) {
        return;
    }
    PolaronStr* s = static_cast<PolaronStr*>(src);
    __polaron_free(s->data);
    __polaron_free(s);
}

#endif  // POLARON_ALLOC_CORE_IMPL
