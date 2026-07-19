// LDP3 minimal runtime: thread support (spec 20.1), defined-behaviour panic, and the
// physical code unload/reload behind unimport/reimport (spec 30). Linked into every exe.
// Portable across Windows and Linux: OS-specific pieces live behind _WIN32, and the concurrency
// and socket code is single-source over a small POSIX shim that spells the Win32 primitive names.

#ifdef _WIN32
#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS  // fopen/remove etc. are used deliberately (File I/O, spec 34.4)
#endif
#define _CRT_RAND_S              // enables rand_s (cryptographically secure RNG, spec 34)
#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>   // must precede <windows.h>
#include <ws2tcpip.h>
#include <windows.h>
#pragma comment(lib, "ws2_32.lib")
#else
#include <arpa/inet.h>
#include <dirent.h>
#include <elf.h>           // ElfW, Elf*_Ehdr/Phdr (reimport reads the on-disk ELF)
#include <fcntl.h>
#include <link.h>          // dl_iterate_phdr (reimport's module base)
#include <netdb.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>        // kill/SIGTERM (subprocess teardown)
#include <sys/ioctl.h>     // FIONREAD (non-blocking subprocess readability check)
#include <sys/mman.h>
#include <sys/random.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/un.h>        // AF_UNIX (cross-program IPC transport, spec 2.8)
#include <sys/wait.h>      // waitpid (subprocess liveness/teardown)
#include <time.h>
#include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#ifdef _WIN32
#include <intrin.h>  // _InterlockedExchangeAdd64 for the allocation profiler's lock-free counters
#endif

#ifndef _WIN32
// POSIX shim spelling the Win32 primitives the concurrency/socket code below uses, so that code
// stays single-source. Only what the runtime actually calls; not a general compatibility layer.
typedef pthread_mutex_t CRITICAL_SECTION;
typedef pthread_cond_t CONDITION_VARIABLE;
typedef int SOCKET;
typedef int BOOL;
#define TRUE 1
#define INVALID_SOCKET (-1)
#define INFINITE 0xFFFFFFFFu
#define closesocket close
static void InitializeCriticalSection(CRITICAL_SECTION* m) { pthread_mutex_init(m, NULL); }
static void EnterCriticalSection(CRITICAL_SECTION* m) { pthread_mutex_lock(m); }
static void LeaveCriticalSection(CRITICAL_SECTION* m) { pthread_mutex_unlock(m); }
static void InitializeConditionVariable(CONDITION_VARIABLE* c) { pthread_cond_init(c, NULL); }
static void SleepConditionVariableCS(CONDITION_VARIABLE* c, CRITICAL_SECTION* m, unsigned) {
    pthread_cond_wait(c, m);
}
static void WakeConditionVariable(CONDITION_VARIABLE* c) { pthread_cond_signal(c); }
static void WakeAllConditionVariable(CONDITION_VARIABLE* c) { pthread_cond_broadcast(c); }
#endif

// The IR calls these by their plain C names. Keep C linkage even when this file is compiled as part
// of a C++ link (e.g. alongside the dynamic-bundle loader), so the names are not mangled.
#ifdef __cplusplus
extern "C" {
#endif

// Defined-behaviour panic: LDP3 never invokes UB. When a check fails (division by zero,
// out-of-bounds, etc.) the program terminates deterministically with a message instead of
// continuing into undefined territory.
void __ldp3_panic(const char* msg) {
    fprintf(stderr, "LDP3 panic: %s\n", msg);
#ifdef _WIN32
    if (getenv("LDP3_BT") != NULL) {  // diagnostic: print the call stack RVAs so a -g build can be symbolized
        void* frames[32];
        unsigned short n = RtlCaptureStackBackTrace(0, 32, frames, NULL);
        char* base = (char*)GetModuleHandleA(NULL);
        for (unsigned short k = 0; k < n; k++)
            fprintf(stderr, "[bt] rva 0x%llx\n", (unsigned long long)((char*)frames[k] - base));
    }
#endif
    fflush(stderr);
    exit(70);
}

// Pooled allocator for LDP3 objects/arrays/strings. The Windows system malloc is slow for the
// allocate-many-small-and-free-them pattern (trees, temporaries); a per-thread segregated free-list
// makes new/delete of small blocks O(1) with no lock, closing the gap to hand-tuned allocators.
//
// Layout: [16-byte header][payload]. The header carries a 64-bit magic so __ldp3_free / __ldp3_realloc
// can tell a pool block from any foreign (libc) pointer that reaches them -- foreign pointers (e.g. a
// calloc'd persistent slot) are forwarded to libc, so mixing is always safe. Large requests bypass the
// pool. Thread-local free-lists need no lock; a block freed on any thread is simply reused there.
#define LDP3_MAGIC 0x4C44503341313142ULL  // arbitrary 64-bit tag; collision with libc data ~2^-64
#define LDP3_FREED 0x4C44503346524545ULL  // stamped into a pool block's header while it sits freed
#define LDP3_RMAGIC 0x4C4450335247314EULL // a live slot inside a `pool`/`fixedslot` region (spec 17 flavors)
#define LDP3_RFREED 0x4C4450335246524EULL // a region slot sitting on its region's free-list (double-free guard)
#define LDP3_POOL_MAX 512u                 // requests above this go straight to libc malloc
#define LDP3_NCLASSES 32                   // size classes 16,32,...,512 (step 16)
#define LDP3_SLAB (1u << 20)               // 1 MiB slabs, bump-allocated then recycled via free-list
#define LDP3_LARGE 0xFFFFFFFFu
// A flavored region (pool/fixedslot/ring/stack, or any growable region) block begins with an
// Ldp3RegionDesc header; its object data starts LDP3_REGION_HDR bytes in. Kept a fixed 16-aligned constant
// so the compiler and the runtime agree on the data offset without the compiler needing
// sizeof(Ldp3RegionDesc). A static_assert below pins it (with headroom for future fields).
#define LDP3_REGION_HDR 448u

typedef struct Ldp3Hdr {
    unsigned long long magic;
    unsigned int cls;
    unsigned int pad;
} Ldp3Hdr;
typedef struct Ldp3FreeNode {
    struct Ldp3FreeNode* next;
} Ldp3FreeNode;

static thread_local Ldp3FreeNode* g_ldp3_free[LDP3_NCLASSES];
static thread_local char* g_ldp3_slab_cur;
static thread_local char* g_ldp3_slab_end;

// -------- allocation profiler (env LDP3_MEMPROF=1) — diagnostic only, one branch when off --------
// Logical live-bytes: incremented on __ldp3_malloc, decremented on __ldp3_free. Pool blocks never
// return to libc (they recycle on a free-list), so RSS follows the *net* live bytes: if this climbs,
// the program is leaking. A size-class histogram of the still-live set at exit says whether the leak
// is many small blocks (Strings/objects/spans, pool classes) or a few big buffers (large bucket).
// Kept STL-free (plain longs + a lock-free add) so it compiles with the bundled clang toolchain.
// Compiled out of the production runtime for ZERO overhead: without -DLDP3_PROFILING the gate is a
// compile-time `false`, so every `if (g_prof_on)` / `if (g_memsite_on)` hot-path branch dead-eliminates
// at -O2 (the counters/helpers below stay defined but unreachable). Build the runtime with
// -DLDP3_PROFILING to enable LDP3_MEMPROF / LDP3_MEMSITE.
#ifdef LDP3_PROFILING
static bool g_prof_on = false;
#else
#define g_prof_on false
#endif
static long long g_prof_live_bytes = 0;
static long long g_prof_live_count = 0;
static long long g_prof_total_alloc = 0;
static long long g_prof_total_free = 0;
static long long g_prof_class_live[33];  // 0..31 = pool classes; 32 = large (>512 B)

static inline void prof_add(long long* p, long long d) {
#ifdef _WIN32
    _InterlockedExchangeAdd64((volatile long long*)p, d);
#else
    __atomic_fetch_add(p, d, __ATOMIC_RELAXED);
#endif
}

// -------- leak-by-site attribution (env LDP3_MEMSITE=1) --------
// Heavier than the size histogram: captures a short backtrace per POOL alloc, aggregates the live count
// per call-site, and dumps the top leaking sites at exit as RVAs -- symbolize against a -g build with
// `llvm-dwarfdump --lookup=<imageBase+rva>`. Pool blocks only (their pad word is free; large blocks use
// pad for size). Single-threaded assumption for the site table (diagnostic use). Windows only.
#ifdef _WIN32
#define LDP3_NSITES 16384u
#define LDP3_NFR 5
struct Ldp3Site { void* fr[LDP3_NFR]; long long live; long long total; };
static Ldp3Site g_sites[LDP3_NSITES];
#ifdef LDP3_PROFILING
static bool g_memsite_on = false;
#else
#define g_memsite_on false
#endif

static int site_index(void* const* fr) {
    unsigned long long h = 1469598103934665603ULL;
    for (int k = 0; k < LDP3_NFR; k++) { h ^= (unsigned long long)fr[k]; h *= 1099511628211ULL; }
    unsigned idx = (unsigned)h & (LDP3_NSITES - 1);
    for (unsigned probe = 0; probe < LDP3_NSITES; probe++) {
        unsigned i = (idx + probe) & (LDP3_NSITES - 1);
        if (g_sites[i].fr[0] == 0) { for (int k = 0; k < LDP3_NFR; k++) g_sites[i].fr[k] = fr[k]; return (int)i; }
        int same = 1;
        for (int k = 0; k < LDP3_NFR; k++) if (g_sites[i].fr[k] != fr[k]) { same = 0; break; }
        if (same) return (int)i;
    }
    return 0;  // table full: dump into bucket 0
}
static void memsite_record(Ldp3Hdr* hdr) {
    static int clsFilter = -2;  // -2 = unread, -1 = all classes, >=0 = only that pool class
    if (clsFilter == -2) { const char* c = getenv("LDP3_MEMSITE_CLS"); clsFilter = c ? atoi(c) : -1; }
    if (clsFilter >= 0 && (int)hdr->cls != clsFilter) return;  // e.g. LDP3_MEMSITE_CLS=1 -> 32 B Strings
    void* fr[LDP3_NFR + 2];
    unsigned short n = RtlCaptureStackBackTrace(2, LDP3_NFR + 2, fr, NULL);  // skip malloc + its wrapper
    void* key[LDP3_NFR];
    for (int k = 0; k < LDP3_NFR; k++) key[k] = k < n ? fr[k] : 0;
    int si = site_index(key);
    hdr->pad = (unsigned)si;
    g_sites[si].live++;
    g_sites[si].total++;
}
static void memsite_release(Ldp3Hdr* hdr) {
    unsigned si = hdr->pad;
    if (si < LDP3_NSITES) g_sites[si].live--;
}
static void memsite_dump() {
    if (!g_memsite_on) return;
    char* base = (char*)GetModuleHandleA(NULL);
    fprintf(stderr, "[memsite] top leaking call-sites (live count, RVAs to symbolize):\n");
    for (int rank = 0; rank < 30; rank++) {
        long long best = 0; int bi = -1;
        for (unsigned i = 0; i < LDP3_NSITES; i++)
            if (g_sites[i].live > best) { best = g_sites[i].live; bi = (int)i; }
        if (bi < 0) break;
        fprintf(stderr, "  live=%lld total=%lld  rva", best, g_sites[bi].total);
        for (int k = 0; k < LDP3_NFR; k++)
            fprintf(stderr, " 0x%llx", (unsigned long long)((char*)g_sites[bi].fr[k] - base));
        fprintf(stderr, "\n");
        g_sites[bi].live = -1;  // mark ranked so the next scan skips it
    }
    fflush(stderr);
}
#endif

static void __ldp3_memprof_dump() {
    if (!g_prof_on) return;
    fprintf(stderr, "[memprof] FINAL live=%.1f MB count=%lld  totalAlloc=%lld totalFree=%lld\n",
            g_prof_live_bytes / 1048576.0, g_prof_live_count, g_prof_total_alloc, g_prof_total_free);
    for (int c = 0; c <= 32; c++) {
        long long n = g_prof_class_live[c];
        if (n <= 0) continue;
        if (c < 32) fprintf(stderr, "  pool class %2d (<=%4d B): %lld live\n", c, (c + 1) * 16, n);
        else        fprintf(stderr, "  large  (>512 B):        %lld live\n", n);
    }
    fflush(stderr);
}

#ifdef LDP3_PROFILING
struct Ldp3ProfInit {
    Ldp3ProfInit() {
        const char* e = getenv("LDP3_MEMPROF");
        g_prof_on = (e != NULL && e[0] != '\0' && e[0] != '0');
        if (g_prof_on) atexit(__ldp3_memprof_dump);
#ifdef _WIN32
        const char* ms = getenv("LDP3_MEMSITE");
        g_memsite_on = (ms != NULL && ms[0] != '\0' && ms[0] != '0');
        if (g_memsite_on) atexit(memsite_dump);
#endif
    }
};
static Ldp3ProfInit g_ldp3_prof_init;
#endif

void* __ldp3_malloc(size_t size) {
    if (size == 0) size = 1;
    if (size > LDP3_POOL_MAX) {  // large: a plain libc block tagged so free/realloc recognise it
        char* p = (char*)malloc(size + 16);
        if (p == NULL) return NULL;
        ((Ldp3Hdr*)p)->magic = LDP3_MAGIC;
        ((Ldp3Hdr*)p)->cls = LDP3_LARGE;
        ((Ldp3Hdr*)p)->pad = (unsigned)size;  // remember size for the profiler's free accounting
        if (g_prof_on) { prof_add(&g_prof_live_count, 1); prof_add(&g_prof_total_alloc, 1); prof_add(&g_prof_live_bytes, (long long)size); prof_add(&g_prof_class_live[32], 1); }
        return p + 16;
    }
    unsigned cls = (unsigned)((size + 15) / 16) - 1;  // 0..31
    Ldp3FreeNode* n = g_ldp3_free[cls];
    if (n != NULL) {  // reuse: the header (magic + class) is still intact just before the node
        g_ldp3_free[cls] = n->next;
        ((Ldp3Hdr*)((char*)n - 16))->magic = LDP3_MAGIC;  // live again: clear the freed stamp
        if (g_prof_on) { prof_add(&g_prof_live_count, 1); prof_add(&g_prof_total_alloc, 1); prof_add(&g_prof_live_bytes, (long long)(cls + 1) * 16); prof_add(&g_prof_class_live[cls], 1); }
#ifdef _WIN32
        if (g_memsite_on) memsite_record((Ldp3Hdr*)((char*)n - 16));
#endif
        return (void*)n;
    }
    size_t need = 16 + (size_t)(cls + 1) * 16;
    if (g_ldp3_slab_cur == NULL || g_ldp3_slab_cur + need > g_ldp3_slab_end) {
        char* s = (char*)malloc(LDP3_SLAB);
        if (s == NULL) return NULL;
        g_ldp3_slab_cur = s;
        g_ldp3_slab_end = s + LDP3_SLAB;
    }
    char* p = g_ldp3_slab_cur;
    g_ldp3_slab_cur += need;
    ((Ldp3Hdr*)p)->magic = LDP3_MAGIC;
    ((Ldp3Hdr*)p)->cls = cls;
    if (g_prof_on) { prof_add(&g_prof_live_count, 1); prof_add(&g_prof_total_alloc, 1); prof_add(&g_prof_live_bytes, (long long)(cls + 1) * 16); prof_add(&g_prof_class_live[cls], 1); }
#ifdef _WIN32
    if (g_memsite_on) memsite_record((Ldp3Hdr*)p);
#endif
    return p + 16;
}

void __ldp3_free(void* ptr) {
    if (ptr == NULL) return;
    Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
    // Freeing a pool block that is already on the free-list would splice it in twice and cycle the list,
    // silently handing the same address out to two later allocations. A live block always carries
    // LDP3_MAGIC, so a header already stamped LDP3_FREED means a double free -- stop deterministically
    // rather than corrupt the heap (no UB). One compare on the free path; perf is unchanged.
    if (h->magic == LDP3_FREED) __ldp3_panic("double free of a heap block");
    // A pool/fixedslot region slot carries LDP3_RMAGIC/RFREED. It lives INSIDE a region block, so pushing
    // it onto the global free-list (or handing it to libc free) would corrupt the heap. Trap with a fix.
    if (h->magic == LDP3_RMAGIC || h->magic == LDP3_RFREED)
        __ldp3_panic("delete of a region object: use `delete X from region R` (or `extract X from region R`), not a plain delete");
    if (h->magic != LDP3_MAGIC) {  // foreign pointer (libc) -- forward
        free(ptr);
        return;
    }
    if (h->cls == LDP3_LARGE) {
        h->magic = LDP3_FREED;  // large blocks go back to libc; stamp guards a same-run double free
        if (g_prof_on) { prof_add(&g_prof_live_count, -1); prof_add(&g_prof_total_free, 1); prof_add(&g_prof_live_bytes, -(long long)h->pad); prof_add(&g_prof_class_live[32], -1); }
        free(h);
        return;
    }
    if (g_prof_on) { prof_add(&g_prof_live_count, -1); prof_add(&g_prof_total_free, 1); prof_add(&g_prof_live_bytes, -(long long)(h->cls + 1) * 16); prof_add(&g_prof_class_live[h->cls], -1); }
#ifdef _WIN32
    if (g_memsite_on) memsite_release(h);
#endif
    h->magic = LDP3_FREED;                  // mark freed; __ldp3_malloc clears it on reuse
    Ldp3FreeNode* n = (Ldp3FreeNode*)ptr;   // recycle the payload as the free-list node
    n->next = g_ldp3_free[h->cls];
    g_ldp3_free[h->cls] = n;
}

// Called at the start of `delete obj`: a pooled object's field 0 is its vtable slot, but once freed that
// word holds the free-list link, so looking up the destructor through it would call through garbage. If
// the block is already freed, stop deterministically instead (no UB). A live pool block carries
// LDP3_MAGIC; a foreign/stack pointer carries neither stamp and is left alone.
void __ldp3_check_live(void* ptr) {
    if (ptr == NULL) return;
    Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
    if (h->magic == LDP3_FREED || h->magic == LDP3_RFREED)
        __ldp3_panic("use of a freed object (double delete)");
}

// Region backing-memory cache (hosted). A region's data block is often multi-megabyte, which libc
// serves with mmap and reclaims with munmap -- plus the kernel zero-fills every page on first touch.
// A hot `allocate ... release` loop (LDP3's arena idiom) pays that OS round-trip every iteration, which
// dominates while the bump allocation itself is nearly free. Releasing a region keeps its block for the
// next same-size allocate on this thread, turning the round-trip into an O(1) pointer swap. Thread-local
// so it needs no lock (the LARGE blocks it caches are plain libc allocations, safe on any thread), and
// bounded so it never hoards memory.
#define LDP3_REGION_CACHE 8
typedef struct {
    void* ptr;
    unsigned long long total;
} Ldp3RegionSlot;
static thread_local Ldp3RegionSlot g_ldp3_region_cache[LDP3_REGION_CACHE];
static thread_local int g_ldp3_region_n;

void* __ldp3_region_acquire(unsigned long long total) {
    for (int i = 0; i < g_ldp3_region_n; i++) {
        if (g_ldp3_region_cache[i].total == total) {  // reuse a released block of exactly this size
            void* p = g_ldp3_region_cache[i].ptr;
            g_ldp3_region_cache[i] = g_ldp3_region_cache[--g_ldp3_region_n];
            return p;
        }
    }
    return __ldp3_malloc((size_t)total);
}

void __ldp3_region_release(void* block) {
    if (block == NULL) return;  // an unallocated (empty-state) or already-released region
    // The header is [i64 used][i64 cap][ptr dataBase]. An owned region bump-allocates its data just past
    // the 24-byte header (dataBase == block+24); an `at`-address region's data lives at a fixed external
    // address, so only its tiny header is ours -- never cache it (its cap is the external size, not the
    // block size), just free the header.
    unsigned long long cap = *(unsigned long long*)((char*)block + 8);
    void* dbase = *(void**)((char*)block + 16);
    if (dbase != (void*)((char*)block + 24)) {
        __ldp3_free(block);
        return;
    }
    if (g_ldp3_region_n < LDP3_REGION_CACHE) {
        g_ldp3_region_cache[g_ldp3_region_n].ptr = block;
        g_ldp3_region_cache[g_ldp3_region_n].total = cap + 24;
        g_ldp3_region_n++;
        return;
    }
    __ldp3_free(block);
}

// ---- Flavored regions (spec 17, flavors expansion): pool / fixedslot / stack (ring later) ----
// A flavored region's block starts with this descriptor and its object data follows LDP3_REGION_HDR bytes
// in. The first three fields deliberately mirror the lean bump header ([used][cap][dataBase] at 0/8/16) so
// __ldp3_region_release reads cap/dataBase the same way for every flavor (a flavored dataBase != block+24,
// so release just frees the whole block -- correct, since the block is one __ldp3_malloc allocation).
//
// pool/fixedslot/stack allocate a slot per object: [16-byte Ldp3Hdr][payload], the payload 16-aligned.
// pool/fixedslot: a freed slot goes on freelists[class]; a later same-class allocation pops it (pointers
// never move). stack: pure bump (no free-list) plus mark/rollback; objects with destructors are recorded
// in a runtime registry so rollback/release can run them newest-first. Slots carry LDP3_RMAGIC (distinct
// from heap LDP3_MAGIC) so a mistaken plain `delete`/`free` traps instead of splicing a region-interior
// pointer onto the global heap free-list (no exploitable UB).
typedef struct Ldp3RegionDesc {
    unsigned long long used;      // +0  bump cursor over the data area, in bytes (mirrors lean header)
    unsigned long long cap;       // +8  data-area capacity in bytes (mirrors lean header)
    void*              dataBase;  // +16 = (char*)block + LDP3_REGION_HDR (mirrors lean header)
    unsigned long long flavor;    // +24 1=pool, 2=stack, 3=fixedslot, 4=ring (bump never uses this desc)
    unsigned long long entrySize; // +32 fixedslot/ring slot payload size (0 for a general pool)
    unsigned long long ringHead;  // +40 ring: index of the oldest entry (later wave)
    unsigned long long ringCount; // +48 ring: number of live entries (later wave)
    unsigned long long ringCap;   // +56 ring: capacity in entries (later wave)
    // stack registry: objects with destructors, in allocation order (== address order, since stack bumps).
    // rollback/release walk it newest-first. Backed by libc malloc/realloc (small metadata, off the arena).
    void**             trackPtr;  // +64 live object payload pointers
    void**             trackDtor; // +72 parallel destructor function pointers (void(*)(void*))
    unsigned long long trackCount;// +80
    unsigned long long trackCap;  // +88
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

// Payload size class for a region slot: 0..LDP3_NCLASSES-1 for <=512 (step 16), LDP3_NCLASSES for large.
static inline unsigned ldp3_region_class(unsigned long long payload) {
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
    d->trackPtr = NULL;
    d->trackDtor = NULL;
    d->trackCount = 0;
    d->trackCap = 0;
    d->ringDtor = NULL;
    d->growNext = NULL;
    d->growTail = d;  // the head is its own initial bump block
    d->growable = growable;
    for (int i = 0; i <= LDP3_NCLASSES; i++) d->freelists[i] = NULL;
}

// Allocate `size` bytes of object storage from a pool/fixedslot region. Pops a same-class free slot when
// available, otherwise bumps a fresh one; traps (no UB) when the fixed region is full.
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
                if (g_prof_on) prof_add(&g_prof_total_alloc, 1);
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
                    if (g_prof_on) prof_add(&g_prof_total_alloc, 1);
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
        void* nb = __ldp3_malloc((size_t)(LDP3_REGION_HDR + newcap));
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
    if (g_prof_on) prof_add(&g_prof_total_alloc, 1);  // block-level bytes already counted at acquire
    return slot + 16;
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
    if (g_prof_on) prof_add(&g_prof_total_free, 1);  // per-slot live is not tracked (see region_new)
    h->magic = LDP3_RFREED;
    if (d->flavor == 2) {  // stack: no free-list. Untrack, and reclaim LIFO if this was the top slot.
        for (unsigned long long i = d->trackCount; i > 0; --i) {
            if (d->trackPtr[i - 1] == ptr) {  // drop it so rollback/release never re-destructs it
                for (unsigned long long j = i - 1; j + 1 < d->trackCount; ++j) {
                    d->trackPtr[j] = d->trackPtr[j + 1];
                    d->trackDtor[j] = d->trackDtor[j + 1];
                }
                d->trackCount--;
                break;
            }
        }
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
        __ldp3_free(b);
        b = next;
    }
}

// Record a stack-region object that has a destructor, so mark/rollback and release can run it (newest
// first). Only objects with destructors are tracked; the registry lives off the arena (libc malloc).
void __ldp3_region_track(void* block, void* ptr, void* dtor) {
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    if (d->trackCount == d->trackCap) {
        unsigned long long ncap = d->trackCap == 0 ? 16 : d->trackCap * 2;
        d->trackPtr = (void**)realloc(d->trackPtr, ncap * sizeof(void*));
        d->trackDtor = (void**)realloc(d->trackDtor, ncap * sizeof(void*));
        if (d->trackPtr == NULL || d->trackDtor == NULL) __ldp3_panic("out of memory tracking a stack region object");
        d->trackCap = ncap;
    }
    d->trackPtr[d->trackCount] = ptr;
    d->trackDtor[d->trackCount] = dtor;
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
        void* ptr = d->trackPtr[d->trackCount - 1];
        if ((char*)ptr - 16 < threshold) break;  // older than the mark: keep it (registry is in alloc order)
        Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
        d->trackCount--;
        if (h->magic == LDP3_RMAGIC) {  // still live (not already deleted): destruct it once
            h->magic = LDP3_RFREED;
            ((void (*)(void*))d->trackDtor[d->trackCount])(ptr);
        }
    }
    d->used = mark;
}

// Tear a stack region down before its block is freed: run all remaining destructors and free the
// off-arena registry arrays. Codegen calls this for a stack region right before __ldp3_region_release.
void __ldp3_region_teardown(void* block) {
    if (block == NULL) return;  // an unallocated / already-released region (explicit release nulled it)
    Ldp3RegionDesc* d = (Ldp3RegionDesc*)block;
    __ldp3_region_rollback(block, 0);  // destruct everything still live
    free(d->trackPtr);
    free(d->trackDtor);
    d->trackPtr = NULL;
    d->trackDtor = NULL;
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
        if (g_prof_on) prof_add(&g_prof_total_alloc, 1);  // per-slot live not tracked (see region_new)
    } else {  // full: evict the oldest (this same slot), running its destructor before reuse
        Ldp3Hdr* oh = (Ldp3Hdr*)slot;
        if (d->ringDtor != NULL && oh->magic == LDP3_RMAGIC) {
            oh->magic = LDP3_RFREED;
            ((void (*)(void*))d->ringDtor)(slot + 16);
        }
        d->ringHead = (d->ringHead + 1) % d->ringCap;
        if (g_prof_on) { prof_add(&g_prof_total_alloc, 1); }
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

void* __ldp3_realloc(void* ptr, size_t size) {
    if (ptr == NULL) return __ldp3_malloc(size);
    Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
    if (h->magic != LDP3_MAGIC) return realloc(ptr, size);  // foreign pointer
    if (h->cls == LDP3_LARGE) {
        long long oldsz = (long long)h->pad;
        char* np = (char*)realloc(h, size + 16);
        if (np == NULL) return NULL;
        ((Ldp3Hdr*)np)->magic = LDP3_MAGIC;
        ((Ldp3Hdr*)np)->cls = LDP3_LARGE;
        ((Ldp3Hdr*)np)->pad = (unsigned)size;
        if (g_prof_on) { prof_add(&g_prof_live_bytes, (long long)size - oldsz); }
        return np + 16;
    }
    size_t oldsz = (size_t)(h->cls + 1) * 16;
    if (size <= oldsz) return ptr;  // still fits the current class
    void* np = __ldp3_malloc(size);
    if (np == NULL) return NULL;
    memcpy(np, ptr, oldsz);
    __ldp3_free(ptr);
    return np;
}

// Formats a Decimal (spec 34) into buf and returns its length. The compiler precomputes the sign, the
// integer part and the 18-digit fraction via 128-bit division, so this only assembles them (no 128-bit
// math -- MSVC has no __int128) and trims trailing zeros from the fraction for a clean "1.8" over
// "1.800000000000000000". buf must hold at least 64 bytes.
long long __ldp3_decimal_str(int neg, long long intPart, unsigned long long frac, char* buf) {
    char frac18[18];
    for (int i = 17; i >= 0; --i) { frac18[i] = (char)('0' + (int)(frac % 10)); frac /= 10; }
    int flen = 18;
    while (flen > 0 && frac18[flen - 1] == '0') --flen;  // trim trailing zeros
    char* p = buf;
    if (neg) *p++ = '-';
    char tmp[24];
    int ti = 0;
    if (intPart == 0) {
        tmp[ti++] = '0';
    } else {
        long long x = intPart;
        while (x > 0) { tmp[ti++] = (char)('0' + (int)(x % 10)); x /= 10; }
    }
    while (ti > 0) *p++ = tmp[--ti];
    if (flen > 0) {
        *p++ = '.';
        for (int i = 0; i < flen; ++i) *p++ = frac18[i];
    }
    return (long long)(p - buf);
}

// Index-keyed persistent registry (spec 18.5): the in-process store behind `arr[i] = new T()`
// reattach. Each (key, index) pair maps to one zeroed persistent block that survives delete within a
// run, so the same slot returns the same block and its persistent fields reattach across delete +
// recreate. `key` is a static string constant emitted by the compiler (lives for the whole run).
// Open-addressing hash table over (key, index) -> block. The old singly-linked list walked every node
// with a strcmp per lookup, so creating N persistent slots (arr[i] = new T() for i in 0..N) was O(N^2)
// -- 20k slots took ~1.2s. Hashing makes each lookup O(1) amortized.
typedef struct {
    const char* key;  // NULL = empty slot
    long long index;
    void* block;
} Ldp3PSlot;
static Ldp3PSlot* g_ldp3_pslots = NULL;
static long long g_ldp3_pslots_cap = 0;    // power of two, or 0 before first insert
static long long g_ldp3_pslots_count = 0;

static unsigned long long __ldp3_pslot_hash(const char* key, long long index) {
    unsigned long long h = 1469598103934665603ULL;  // FNV-1a over the key string, then the index
    for (const char* p = key; *p != '\0'; ++p) {
        h ^= (unsigned long long)(unsigned char)*p;
        h *= 1099511628211ULL;
    }
    h ^= (unsigned long long)index;
    h *= 1099511628211ULL;
    return h;
}
static void __ldp3_pslots_grow(void) {
    long long oldCap = g_ldp3_pslots_cap;
    Ldp3PSlot* old = g_ldp3_pslots;
    long long newCap = oldCap ? oldCap * 2 : 64;
    Ldp3PSlot* ns = (Ldp3PSlot*)calloc((size_t)newCap, sizeof(Ldp3PSlot));
    if (ns == NULL) __ldp3_panic("out of memory in persistent registry");
    long long mask = newCap - 1;
    for (long long i = 0; i < oldCap; ++i) {
        if (old[i].key == NULL) continue;
        long long j = (long long)(__ldp3_pslot_hash(old[i].key, old[i].index) & (unsigned long long)mask);
        while (ns[j].key != NULL) j = (j + 1) & mask;
        ns[j] = old[i];
    }
    free(old);
    g_ldp3_pslots = ns;
    g_ldp3_pslots_cap = newCap;
}
void* __ldp3_persist_slot(const char* key, long long index, long long size) {
    if (g_ldp3_pslots_cap == 0 || g_ldp3_pslots_count * 4 >= g_ldp3_pslots_cap * 3)
        __ldp3_pslots_grow();  // keep load factor under 0.75
    long long mask = g_ldp3_pslots_cap - 1;
    long long j = (long long)(__ldp3_pslot_hash(key, index) & (unsigned long long)mask);
    while (g_ldp3_pslots[j].key != NULL) {
        // key is a per-array static constant, so the pointer usually matches; strcmp is the fallback.
        if (g_ldp3_pslots[j].index == index &&
            (g_ldp3_pslots[j].key == key || strcmp(g_ldp3_pslots[j].key, key) == 0))
            return g_ldp3_pslots[j].block;
        j = (j + 1) & mask;
    }
    void* block = calloc(1, (size_t)size);
    g_ldp3_pslots[j].key = key;
    g_ldp3_pslots[j].index = index;
    g_ldp3_pslots[j].block = block;
    ++g_ldp3_pslots_count;
    return block;
}

// Pointer visited-set for `cascade` cycle detection (spec 37.1, rule 2). A small open-
// addressing hash set over object addresses: add() returns 1 the first time a pointer is
// seen and 0 afterwards, so a cascade walk skips objects it already processed (and so never
// loops on a cyclic object graph).
typedef struct ldp3_ptrset {
    void** slots;     // hash table; NULL slot = empty
    long long cap;    // power of two, or 0 before first insert
    long long count;
} ldp3_ptrset;

static void __ldp3_ptrset_grow(ldp3_ptrset* s) {
    long long oldCap = s->cap;
    void** old = s->slots;
    long long newCap = oldCap ? oldCap * 2 : 64;
    void** ns = (void**)calloc((size_t)newCap, sizeof(void*));
    if (ns == NULL) __ldp3_panic("out of memory in cascade visited-set");
    long long mask = newCap - 1;
    for (long long i = 0; i < oldCap; i++) {
        if (old[i] != NULL) {
            unsigned long long h = (unsigned long long)(uintptr_t)old[i] * 1099511628211ULL;
            long long idx = (long long)(h & (unsigned long long)mask);
            while (ns[idx] != NULL) idx = (idx + 1) & mask;
            ns[idx] = old[i];
        }
    }
    s->slots = ns;
    s->cap = newCap;
    free(old);
}

ldp3_ptrset* __ldp3_ptrset_new(void) {
    ldp3_ptrset* s = (ldp3_ptrset*)malloc(sizeof(ldp3_ptrset));
    if (s == NULL) __ldp3_panic("out of memory in cascade visited-set");
    s->slots = NULL;
    s->cap = 0;
    s->count = 0;
    return s;
}

void __ldp3_ptrset_free(ldp3_ptrset* s) {
    if (s == NULL) return;
    free(s->slots);
    free(s);
}

// Returns 1 if `p` was newly added, 0 if already present. A NULL set or pointer counts as seen.
int __ldp3_ptrset_add(ldp3_ptrset* s, void* p) {
    if (s == NULL || p == NULL) return 0;
    if ((s->count + 1) * 4 >= s->cap * 3) __ldp3_ptrset_grow(s);
    unsigned long long h = (unsigned long long)(uintptr_t)p * 1099511628211ULL;
    long long mask = s->cap - 1;
    long long idx = (long long)(h & (unsigned long long)mask);
    while (s->slots[idx] != NULL) {
        if (s->slots[idx] == p) return 0;  // already visited
        idx = (idx + 1) & mask;
    }
    s->slots[idx] = p;
    s->count++;
    return 1;
}

// Pointer-to-pointer map for `cascade clone` (spec 37.1): maps each original object to its clone
// so a shared or cyclic owned graph is cloned once and the clone preserves the same sharing.
typedef struct ldp3_ptrmap {
    void** keys;   // hash table; NULL key = empty
    void** vals;
    long long cap;
    long long count;
} ldp3_ptrmap;

static void __ldp3_ptrmap_grow(ldp3_ptrmap* m) {
    long long oldCap = m->cap;
    void** ok = m->keys;
    void** ov = m->vals;
    long long newCap = oldCap ? oldCap * 2 : 64;
    void** nk = (void**)calloc((size_t)newCap, sizeof(void*));
    void** nv = (void**)calloc((size_t)newCap, sizeof(void*));
    if (nk == NULL || nv == NULL) __ldp3_panic("out of memory in cascade clone map");
    long long mask = newCap - 1;
    for (long long i = 0; i < oldCap; i++) {
        if (ok[i] != NULL) {
            unsigned long long h = (unsigned long long)(uintptr_t)ok[i] * 1099511628211ULL;
            long long idx = (long long)(h & (unsigned long long)mask);
            while (nk[idx] != NULL) idx = (idx + 1) & mask;
            nk[idx] = ok[i];
            nv[idx] = ov[i];
        }
    }
    m->keys = nk;
    m->vals = nv;
    m->cap = newCap;
    free(ok);
    free(ov);
}

ldp3_ptrmap* __ldp3_ptrmap_new(void) {
    ldp3_ptrmap* m = (ldp3_ptrmap*)malloc(sizeof(ldp3_ptrmap));
    if (m == NULL) __ldp3_panic("out of memory in cascade clone map");
    m->keys = NULL;
    m->vals = NULL;
    m->cap = 0;
    m->count = 0;
    return m;
}

void __ldp3_ptrmap_free(ldp3_ptrmap* m) {
    if (m == NULL) return;
    free(m->keys);
    free(m->vals);
    free(m);
}

void* __ldp3_ptrmap_get(ldp3_ptrmap* m, void* key) {
    if (m == NULL || key == NULL || m->cap == 0) return NULL;
    unsigned long long h = (unsigned long long)(uintptr_t)key * 1099511628211ULL;
    long long mask = m->cap - 1;
    long long idx = (long long)(h & (unsigned long long)mask);
    while (m->keys[idx] != NULL) {
        if (m->keys[idx] == key) return m->vals[idx];
        idx = (idx + 1) & mask;
    }
    return NULL;
}

void __ldp3_ptrmap_put(ldp3_ptrmap* m, void* key, void* val) {
    if (m == NULL || key == NULL) return;
    if ((m->count + 1) * 4 >= m->cap * 3) __ldp3_ptrmap_grow(m);
    unsigned long long h = (unsigned long long)(uintptr_t)key * 1099511628211ULL;
    long long mask = m->cap - 1;
    long long idx = (long long)(h & (unsigned long long)mask);
    while (m->keys[idx] != NULL) {
        if (m->keys[idx] == key) { m->vals[idx] = val; return; }
        idx = (idx + 1) & mask;
    }
    m->keys[idx] = key;
    m->vals[idx] = val;
    m->count++;
}

// OS threads (spec 20.1 Thread). A function value is a pointer to a closure {code, env};
// the trampoline loads code/env and calls code(env) (env is the first argument).
#ifdef _WIN32
static DWORD WINAPI __ldp3_thread_trampoline(LPVOID closure) {
    void** c = (void**)closure;
    void (*code)(void*) = (void (*)(void*))c[0];
    code(c[1]);
    return 0;
}

long long __ldp3_thread_spawn(void* closure) {
    HANDLE h = CreateThread(NULL, 0, __ldp3_thread_trampoline, closure, 0, NULL);
    return (long long)h;
}

void __ldp3_thread_join(long long handle) {
    WaitForSingleObject((HANDLE)handle, INFINITE);
    CloseHandle((HANDLE)handle);
}
#else
static void* __ldp3_thread_trampoline(void* closure) {
    void** c = (void**)closure;
    void (*code)(void*) = (void (*)(void*))c[0];
    code(c[1]);
    return NULL;
}

// The handle is a heap pthread_t (opaque and possibly wider than a register on some libcs).
long long __ldp3_thread_spawn(void* closure) {
    pthread_t* t = (pthread_t*)malloc(sizeof(pthread_t));
    if (t == NULL || pthread_create(t, NULL, __ldp3_thread_trampoline, closure) != 0) {
        free(t);
        return 0;
    }
    return (long long)t;
}

void __ldp3_thread_join(long long handle) {
    pthread_t* t = (pthread_t*)handle;
    if (t == NULL) return;
    pthread_join(*t, NULL);
    free(t);
}
#endif

// Mutex (spec 20.5): a heap CRITICAL_SECTION whose pointer the Mutex<T> object stores as an
// int64. create/acquire/release back the `synchronized` statement.
long long __ldp3_lock_create(void) {
    CRITICAL_SECTION* cs = (CRITICAL_SECTION*)malloc(sizeof(CRITICAL_SECTION));
    if (cs != NULL) InitializeCriticalSection(cs);
    return (long long)cs;
}
void __ldp3_lock_acquire(long long h) {
    if (h != 0) EnterCriticalSection((CRITICAL_SECTION*)h);
}
void __ldp3_lock_release(long long h) {
    if (h != 0) LeaveCriticalSection((CRITICAL_SECTION*)h);
}

// Process-wide mutex guarding `lazy` initialization (spec 37.3: lazy is thread-safe by default).
// A double-checked guard in the generated code takes this lock only on the first initialization,
// so concurrent first-accesses initialize a lazy value exactly once.
#ifdef _WIN32
static CRITICAL_SECTION __ldp3_lazy_cs;
static INIT_ONCE __ldp3_lazy_once = INIT_ONCE_STATIC_INIT;
static BOOL CALLBACK __ldp3_lazy_init_cb(PINIT_ONCE o, PVOID p, PVOID* c) {
    (void)o;
    (void)p;
    (void)c;
    InitializeCriticalSection(&__ldp3_lazy_cs);
    return TRUE;
}
void __ldp3_lazy_lock(void) {
    InitOnceExecuteOnce(&__ldp3_lazy_once, __ldp3_lazy_init_cb, NULL, NULL);
    EnterCriticalSection(&__ldp3_lazy_cs);
}
void __ldp3_lazy_unlock(void) { LeaveCriticalSection(&__ldp3_lazy_cs); }
#else
static pthread_mutex_t __ldp3_lazy_cs = PTHREAD_MUTEX_INITIALIZER;  // static init: no once dance
void __ldp3_lazy_lock(void) { pthread_mutex_lock(&__ldp3_lazy_cs); }
void __ldp3_lazy_unlock(void) { pthread_mutex_unlock(&__ldp3_lazy_cs); }
#endif

// ---- async/await: tasks + worker pool (spec 20.2) -----------------------------------------
// A task is the handle to an async computation. `resume`/`state` are the state machine to run;
// A task's continuations: every awaiter suspended on it. A LIST, not one slot -- several async methods
// may await the same task, and each must be resumed when it completes (a single slot let the last
// awaiter clobber the others, so all but one deadlocked).
typedef void (*ldp3_resume_fn)(void* state);
typedef struct ldp3_waiter {
    ldp3_resume_fn fn;
    void* state;
    struct ldp3_waiter* next;
} ldp3_waiter;
typedef struct ldp3_task {
    volatile long done;
    long long result;
    ldp3_waiter* waiters;  // continuations to schedule on completion (LIFO; order among them is free)
    long long error;       // an exception carrier (object ptr) if the async body threw; 0 otherwise
} ldp3_task;

// Ready queue of (resume, state) pairs run by a fixed pool of worker threads.
typedef struct { ldp3_resume_fn fn; void* state; } ldp3_work;
#define LDP3_QCAP 65536
static ldp3_work g_queue[LDP3_QCAP];
static long g_qhead = 0, g_qtail = 0;
static CRITICAL_SECTION g_qlock;
static CONDITION_VARIABLE g_qcond;   // signalled when work is enqueued
static CONDITION_VARIABLE g_donecond;  // signalled when any task completes (for __ldp3_task_wait)
static int g_pool_started = 0;

static void __ldp3_worker_body(void) {
    for (;;) {
        EnterCriticalSection(&g_qlock);
        while (g_qhead == g_qtail) SleepConditionVariableCS(&g_qcond, &g_qlock, INFINITE);
        ldp3_work w = g_queue[g_qhead];
        g_qhead = (g_qhead + 1) % LDP3_QCAP;
        LeaveCriticalSection(&g_qlock);
        w.fn(w.state);  // resume the state machine; it may complete or re-suspend the task
    }
}

#ifdef _WIN32
static DWORD WINAPI __ldp3_worker(LPVOID unused) {
    (void)unused;
    __ldp3_worker_body();
    return 0;
}
static int __ldp3_cpu_count(void) {
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    return (int)si.dwNumberOfProcessors;
}
static void __ldp3_spawn_worker(void) { CloseHandle(CreateThread(NULL, 0, __ldp3_worker, NULL, 0, NULL)); }
#else
static void* __ldp3_worker(void* unused) {
    (void)unused;
    __ldp3_worker_body();
    return NULL;
}
static int __ldp3_cpu_count(void) { return (int)sysconf(_SC_NPROCESSORS_ONLN); }
static void __ldp3_spawn_worker(void) {
    pthread_t t;
    if (pthread_create(&t, NULL, __ldp3_worker, NULL) == 0) pthread_detach(t);
}
#endif

static void __ldp3_pool_start(void) {
    if (g_pool_started) return;
    g_pool_started = 1;
    InitializeCriticalSection(&g_qlock);
    InitializeConditionVariable(&g_qcond);
    InitializeConditionVariable(&g_donecond);
    int n = __ldp3_cpu_count();
    if (n < 2) n = 2;
    if (n > 16) n = 16;
    for (int i = 0; i < n; i++) __ldp3_spawn_worker();
}

void __ldp3_schedule(ldp3_resume_fn fn, void* state) {
    __ldp3_pool_start();
    EnterCriticalSection(&g_qlock);
    g_queue[g_qtail] = ldp3_work{fn, state};  // C++ braced temporary (not a C compound literal)
    g_qtail = (g_qtail + 1) % LDP3_QCAP;
    LeaveCriticalSection(&g_qlock);
    WakeConditionVariable(&g_qcond);
}

long long __ldp3_task_new(void) {
    ldp3_task* t = (ldp3_task*)calloc(1, sizeof(ldp3_task));
    return (long long)t;
}

// Detach the waiter list under the lock, then (outside it) schedule and free every continuation.
// Shared by the value and error completion paths, so all awaiters are resumed exactly once.
static void __ldp3_task_wake(ldp3_task* t) {
    EnterCriticalSection(&g_qlock);
    t->done = 1;
    ldp3_waiter* w = t->waiters;
    t->waiters = NULL;
    LeaveCriticalSection(&g_qlock);
    while (w != NULL) {
        ldp3_waiter* next = w->next;
        __ldp3_schedule(w->fn, w->state);
        free(w);
        w = next;
    }
    WakeAllConditionVariable(&g_donecond);
}

// Called by an async body when it produces its value: record the result, mark done, and
// schedule every continuation (each task that awaited this one).
void __ldp3_task_complete(long long handle, long long value) {
    ldp3_task* t = (ldp3_task*)handle;
    if (t == NULL) return;
    t->result = value;
    __ldp3_task_wake(t);
}

long long __ldp3_task_result(long long handle) {
    ldp3_task* t = (ldp3_task*)handle;
    return t != NULL ? t->result : 0;
}

// Called when an async body throws instead of producing a value: record the exception carrier, mark
// done, and schedule the waiter -- which will re-throw it (spec 21: the exception surfaces at the await).
void __ldp3_task_complete_error(long long handle, long long carrier) {
    ldp3_task* t = (ldp3_task*)handle;
    if (t == NULL) return;
    t->error = carrier;
    __ldp3_task_wake(t);
}

// The exception carrier a completed task failed with, or 0 if it produced a value normally.
long long __ldp3_task_error(long long handle) {
    ldp3_task* t = (ldp3_task*)handle;
    return t != NULL ? t->error : 0;
}

// await from inside an async state machine: if the awaited task is already done, return 0 so
// the caller falls through and reads the result; otherwise register the caller's continuation
// and return 1 so the caller suspends (returns from its resume function).
int __ldp3_await(long long awaited, ldp3_resume_fn resume, void* state) {
    ldp3_task* a = (ldp3_task*)awaited;
    if (a == NULL) return 0;
    if (a->done) return 0;  // synchronous fast path: a done task never un-dones, so skip the lock
    ldp3_waiter* w = (ldp3_waiter*)malloc(sizeof(ldp3_waiter));
    if (w == NULL) return 0;  // out of memory: fall through and read the (possibly not-yet-ready) result
    w->fn = resume;
    w->state = state;
    EnterCriticalSection(&g_qlock);
    if (a->done) { LeaveCriticalSection(&g_qlock); free(w); return 0; }
    w->next = a->waiters;  // push onto the waiter list (several awaiters may suspend on one task)
    a->waiters = w;
    LeaveCriticalSection(&g_qlock);
    return 1;
}

// ---- Channels: bounded blocking queue (spec 20.3) -----------------------------------------
// send blocks while full, receive blocks while empty; values are passed as 64-bit slots (an
// int or a pointer). One lock plus a not-full / not-empty condition variable.
typedef struct {
    long long* buf;
    long long cap, count, head, tail;
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE notFull, notEmpty;
} ldp3_chan;

long long __ldp3_chan_new(long long cap) {
    if (cap < 1) cap = 1;
    ldp3_chan* c = (ldp3_chan*)malloc(sizeof(ldp3_chan));
    if (c == NULL) return 0;
    c->buf = (long long*)malloc(sizeof(long long) * (size_t)cap);
    c->cap = cap;
    c->count = 0;
    c->head = 0;
    c->tail = 0;
    InitializeCriticalSection(&c->lock);
    InitializeConditionVariable(&c->notFull);
    InitializeConditionVariable(&c->notEmpty);
    return (long long)c;
}

void __ldp3_chan_send(long long handle, long long value) {
    ldp3_chan* c = (ldp3_chan*)handle;
    if (c == NULL) return;
    EnterCriticalSection(&c->lock);
    while (c->count == c->cap) SleepConditionVariableCS(&c->notFull, &c->lock, INFINITE);
    c->buf[c->tail] = value;
    c->tail = (c->tail + 1) % c->cap;
    c->count++;
    LeaveCriticalSection(&c->lock);
    WakeConditionVariable(&c->notEmpty);
}

long long __ldp3_chan_receive(long long handle) {
    ldp3_chan* c = (ldp3_chan*)handle;
    if (c == NULL) return 0;
    EnterCriticalSection(&c->lock);
    while (c->count == 0) SleepConditionVariableCS(&c->notEmpty, &c->lock, INFINITE);
    long long v = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->count--;
    LeaveCriticalSection(&c->lock);
    WakeConditionVariable(&c->notFull);
    return v;
}

// Non-blocking receive for Channel.select (spec 20.4): if a value is ready, store it in *out and
// return 1; otherwise return 0 immediately.
int __ldp3_chan_try_receive(long long handle, long long* out) {
    ldp3_chan* c = (ldp3_chan*)handle;
    if (c == NULL) return 0;
    EnterCriticalSection(&c->lock);
    if (c->count == 0) { LeaveCriticalSection(&c->lock); return 0; }
    *out = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->count--;
    LeaveCriticalSection(&c->lock);
    WakeConditionVariable(&c->notFull);
    return 1;
}

#ifdef _WIN32
long long __ldp3_now_ms(void) { return (long long)GetTickCount64(); }
void __ldp3_yield(void) { Sleep(0); }  // hand off the rest of the time slice while polling

// ---- Time (spec 34): monotonic + wall-clock + sleep. ----
// High-resolution monotonic nanoseconds (QueryPerformanceCounter). Split the math to avoid overflow.
long long __ldp3_now_ns(void) {
    LARGE_INTEGER freq, c;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&c);
    long long f = freq.QuadPart;
    if (f == 0) return 0;
    return (c.QuadPart / f) * 1000000000LL + ((c.QuadPart % f) * 1000000000LL) / f;
}
// Wall-clock milliseconds since the Unix epoch (1970-01-01).
long long __ldp3_unix_ms(void) {
    FILETIME ft;
    GetSystemTimeAsFileTime(&ft);
    unsigned long long t = ((unsigned long long)ft.dwHighDateTime << 32) | ft.dwLowDateTime;
    return (long long)((t - 116444736000000000ULL) / 10000ULL);  // 100-ns since 1601 -> ms since 1970
}
void __ldp3_sleep(long long ms) { Sleep((DWORD)ms); }
#else
void __ldp3_yield(void) { sched_yield(); }

// ---- Time (spec 34): monotonic + wall-clock + sleep, over clock_gettime (POSIX everywhere). ----
long long __ldp3_now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (long long)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}
long long __ldp3_now_ms(void) { return __ldp3_now_ns() / 1000000LL; }
long long __ldp3_unix_ms(void) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    return (long long)ts.tv_sec * 1000LL + ts.tv_nsec / 1000000LL;
}

void __ldp3_sleep(long long ms) {
    struct timespec ts;
    ts.tv_sec = (time_t)(ms / 1000);
    ts.tv_nsec = (long)((ms % 1000) * 1000000LL);
    nanosleep(&ts, NULL);
}
#endif

// `defer within <duration>` (spec 32.10): the cleanup ran past its budget. The spec allows an exception or
// an alert; LDP3 alerts -- a soft-real-time cleanup must still finish, and killing the scope exit (which
// may itself be an unwind) would be worse than the overrun it reports.
void __ldp3_defer_overrun(long long budget_ms, long long took_ms) {
    fprintf(stderr, "ldp3: defer overran its budget: took %lldms, budget %lldms\n", took_ms, budget_ms);
    fflush(stderr);
}

// ---- Networking (spec 34): minimal TCP client. The BSD socket API is the same on both OSes
// (via the shim's SOCKET/closesocket); only winsock's startup call is Windows-specific. ----
#ifdef _WIN32
static int g_net_inited = 0;
static void ldp3_net_init(void) {
    if (!g_net_inited) { WSADATA w; WSAStartup(MAKEWORD(2, 2), &w); g_net_inited = 1; }
}
#else
static void ldp3_net_init(void) {}  // POSIX sockets need no process-wide startup
#endif
long long __ldp3_tcp_connect(const char* host, int port) {
    ldp3_net_init();
    struct addrinfo hints;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    char ports[16];
    sprintf(ports, "%d", port);
    struct addrinfo* res = NULL;
    if (getaddrinfo(host, ports, &hints, &res) != 0 || res == NULL) return -1;
    SOCKET s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (s == INVALID_SOCKET) { freeaddrinfo(res); return -1; }
    if (connect(s, res->ai_addr, (int)res->ai_addrlen) != 0) {
        closesocket(s);
        freeaddrinfo(res);
        return -1;
    }
    freeaddrinfo(res);
    return (long long)s;
}
long long __ldp3_tcp_send(long long sock, const char* data, long long len) {
    return (long long)send((SOCKET)sock, data, (int)len, 0);
}
long long __ldp3_tcp_recv(long long sock, char* buf, long long cap) {
    return (long long)recv((SOCKET)sock, buf, (int)cap, 0);
}
void __ldp3_tcp_close(long long sock) { closesocket((SOCKET)sock); }
// Server side (spec 34): bind + listen on a port, returning a listening socket (-1 on failure).
long long __ldp3_tcp_listen(int port) {
    ldp3_net_init();
    SOCKET s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (s == INVALID_SOCKET) return -1;
    BOOL yes = TRUE;
    setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (const char*)&yes, sizeof yes);
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons((unsigned short)port);
    if (bind(s, (struct sockaddr*)&addr, sizeof addr) != 0 || listen(s, SOMAXCONN) != 0) {
        closesocket(s);
        return -1;
    }
    return (long long)s;
}
// Accepts the next incoming connection, returning a socket for it (-1 on failure). Blocks.
long long __ldp3_tcp_accept(long long server) {
    SOCKET c = accept((SOCKET)server, NULL, NULL);
    return c == INVALID_SOCKET ? -1 : (long long)c;
}

// ---- UDP datagrams (spec 34): connectionless send/receive over winsock. Open a socket (port 0 for an
// ephemeral client port, or a fixed port to receive on); sendto resolves the destination; recvfrom
// records the sender in globals readable via peer_host/peer_port for the request/reply pattern. ----
static char g_udp_peer_host[64] = {0};
static int g_udp_peer_port = 0;
long long __ldp3_udp_open(int port) {
    ldp3_net_init();
    SOCKET s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (s == INVALID_SOCKET) return -1;
    if (port != 0) {
        struct sockaddr_in a;
        memset(&a, 0, sizeof a);
        a.sin_family = AF_INET;
        a.sin_addr.s_addr = INADDR_ANY;
        a.sin_port = htons((unsigned short)port);
        if (bind(s, (struct sockaddr*)&a, sizeof a) != 0) { closesocket(s); return -1; }
    }
    return (long long)s;
}
long long __ldp3_udp_sendto(long long sock, const char* host, int port, const char* data, long long len) {
    struct addrinfo hints, *res = NULL;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_DGRAM;
    char ports[16];
    sprintf(ports, "%d", port);
    if (getaddrinfo(host, ports, &hints, &res) != 0 || res == NULL) return -1;
    int n = sendto((SOCKET)sock, data, (int)len, 0, res->ai_addr, (int)res->ai_addrlen);
    freeaddrinfo(res);
    return (long long)n;
}
long long __ldp3_udp_recvfrom(long long sock, char* buf, long long cap) {
    struct sockaddr_in a;
#ifdef _WIN32
    int alen = (int)sizeof a;
#else
    socklen_t alen = (socklen_t)sizeof a;
#endif
    memset(&a, 0, sizeof a);
    int n = recvfrom((SOCKET)sock, buf, (int)cap, 0, (struct sockaddr*)&a, &alen);
    if (n >= 0) {
        inet_ntop(AF_INET, &a.sin_addr, g_udp_peer_host, sizeof g_udp_peer_host);
        g_udp_peer_port = ntohs(a.sin_port);
    }
    return (long long)n;
}
const char* __ldp3_udp_peer_host(void) { return g_udp_peer_host; }
int __ldp3_udp_peer_port(void) { return g_udp_peer_port; }
void __ldp3_udp_close(long long sock) { closesocket((SOCKET)sock); }

// ---- Cross-program IPC transport (spec 2.8). The program's NAME is its address: a named pipe
// \\.\pipe\ldp3.<Name> on Windows, a Unix domain socket /tmp/ldp3-<Name>.sock (mode 0600) on POSIX.
// So Program.connect("GameEngine") needs no registry, no port and no discovery -- and nothing is ever
// exposed on the network. Both ends of a connection are symmetric: either side may send a frame.
//
// A handle is a malloc'd Ldp3Pipe so the same close() works for a listener and for a connection.
// Every frame is length-prefixed ([u32 length][payload]); send/recv deal in whole frames, so the
// LDP3 side never has to reassemble a stream. ----
typedef struct Ldp3Pipe {
    int isServer;
    char name[256];
#ifdef _WIN32
    HANDLE h;
#else
    int fd;
#endif
} Ldp3Pipe;

static void ldp3_ipc_path(const char* name, char* out, size_t cap) {
#ifdef _WIN32
    snprintf(out, cap, "\\\\.\\pipe\\ldp3.%s", name);
#else
    snprintf(out, cap, "/tmp/ldp3-%s.sock", name);
#endif
}

long long __ldp3_ipc_listen(const char* name) {
    Ldp3Pipe* p = (Ldp3Pipe*)calloc(1, sizeof(Ldp3Pipe));
    if (p == NULL) return -1;
    p->isServer = 1;
    snprintf(p->name, sizeof(p->name), "%s", name);
#ifdef _WIN32
    p->h = INVALID_HANDLE_VALUE;  // an instance is created per accept()
    return (long long)(intptr_t)p;
#else
    char path[512];
    ldp3_ipc_path(name, path, sizeof(path));
    unlink(path);  // a stale socket file from a crashed run would make bind() fail
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) { free(p); return -1; }
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path);
    if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) != 0 || listen(fd, 16) != 0) {
        close(fd);
        free(p);
        return -1;
    }
    chmod(path, 0600);  // only this user may talk to the program
    p->fd = fd;
    return (long long)(intptr_t)p;
#endif
}

long long __ldp3_ipc_accept(long long srv) {
    Ldp3Pipe* s = (Ldp3Pipe*)(intptr_t)srv;
    if (s == NULL || !s->isServer) return -1;
    Ldp3Pipe* c = (Ldp3Pipe*)calloc(1, sizeof(Ldp3Pipe));
    if (c == NULL) return -1;
#ifdef _WIN32
    char path[512];
    ldp3_ipc_path(s->name, path, sizeof(path));
    HANDLE h = CreateNamedPipeA(path, PIPE_ACCESS_DUPLEX,
                                PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
                                PIPE_UNLIMITED_INSTANCES, 65536, 65536, 0, NULL);
    if (h == INVALID_HANDLE_VALUE) { free(c); return -1; }
    if (!ConnectNamedPipe(h, NULL) && GetLastError() != ERROR_PIPE_CONNECTED) {
        CloseHandle(h);
        free(c);
        return -1;
    }
    c->h = h;
#else
    int fd = accept(s->fd, NULL, NULL);
    if (fd < 0) { free(c); return -1; }
    c->fd = fd;
#endif
    return (long long)(intptr_t)c;
}

long long __ldp3_ipc_connect(const char* name) {
    char path[512];
    ldp3_ipc_path(name, path, sizeof(path));
    Ldp3Pipe* c = (Ldp3Pipe*)calloc(1, sizeof(Ldp3Pipe));
    if (c == NULL) return -1;
    snprintf(c->name, sizeof(c->name), "%s", name);
#ifdef _WIN32
    for (int attempt = 0; attempt < 50; ++attempt) {  // the server may be between accept() calls
        HANDLE h = CreateFileA(path, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
        if (h != INVALID_HANDLE_VALUE) {
            c->h = h;
            return (long long)(intptr_t)c;
        }
        if (GetLastError() != ERROR_PIPE_BUSY && GetLastError() != ERROR_FILE_NOT_FOUND) break;
        Sleep(20);
    }
    free(c);
    return -1;
#else
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) { free(c); return -1; }
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path);
    for (int attempt = 0; attempt < 50; ++attempt) {
        if (connect(fd, (struct sockaddr*)&addr, sizeof(addr)) == 0) {
            c->fd = fd;
            return (long long)(intptr_t)c;
        }
        __ldp3_sleep(20);
    }
    close(fd);
    free(c);
    return -1;
#endif
}

static int ldp3_ipc_write_all(Ldp3Pipe* c, const char* data, long long len) {
    long long done = 0;
    while (done < len) {
#ifdef _WIN32
        DWORD n = 0;
        if (!WriteFile(c->h, data + done, (DWORD)(len - done), &n, NULL) || n == 0) return 0;
#else
        long n = write(c->fd, data + done, (size_t)(len - done));
        if (n <= 0) return 0;
#endif
        done += (long long)n;
    }
    return 1;
}

static int ldp3_ipc_read_all(Ldp3Pipe* c, char* buf, long long len) {
    long long done = 0;
    while (done < len) {
#ifdef _WIN32
        DWORD n = 0;
        if (!ReadFile(c->h, buf + done, (DWORD)(len - done), &n, NULL) || n == 0) return 0;
#else
        long n = read(c->fd, buf + done, (size_t)(len - done));
        if (n <= 0) return 0;
#endif
        done += (long long)n;
    }
    return 1;
}

// Sends one whole frame. Returns the number of payload bytes written, or -1 if the peer is gone.
long long __ldp3_ipc_send(long long conn, const char* data, long long len) {
    Ldp3Pipe* c = (Ldp3Pipe*)(intptr_t)conn;
    if (c == NULL || c->isServer || len < 0) return -1;
    unsigned char hdr[4];
    unsigned int n = (unsigned int)len;
    hdr[0] = (unsigned char)(n & 0xFF);
    hdr[1] = (unsigned char)((n >> 8) & 0xFF);
    hdr[2] = (unsigned char)((n >> 16) & 0xFF);
    hdr[3] = (unsigned char)((n >> 24) & 0xFF);
    if (!ldp3_ipc_write_all(c, (const char*)hdr, 4)) return -1;
    if (len > 0 && !ldp3_ipc_write_all(c, data, len)) return -1;
    return len;
}

// Receives one whole frame. Returns a malloc'd NUL-terminated buffer (*outLen = its length); an empty
// buffer with *outLen == 0 means the peer closed the connection.
char* __ldp3_ipc_recv(long long conn, long long* outLen) {
    Ldp3Pipe* c = (Ldp3Pipe*)(intptr_t)conn;
    *outLen = 0;
    if (c == NULL || c->isServer) { char* e = (char*)malloc(1); e[0] = 0; return e; }
    unsigned char hdr[4];
    if (!ldp3_ipc_read_all(c, (char*)hdr, 4)) { char* e = (char*)malloc(1); e[0] = 0; return e; }
    unsigned int n = (unsigned int)hdr[0] | ((unsigned int)hdr[1] << 8) |
                     ((unsigned int)hdr[2] << 16) | ((unsigned int)hdr[3] << 24);
    char* buf = (char*)malloc((size_t)n + 1);
    if (buf == NULL) { char* e = (char*)malloc(1); e[0] = 0; return e; }
    if (n > 0 && !ldp3_ipc_read_all(c, buf, (long long)n)) {
        free(buf);
        char* e = (char*)malloc(1);
        e[0] = 0;
        return e;
    }
    buf[n] = 0;
    *outLen = (long long)n;
    return buf;
}

void __ldp3_ipc_close(long long h) {
    Ldp3Pipe* p = (Ldp3Pipe*)(intptr_t)h;
    if (p == NULL) return;
#ifdef _WIN32
    if (p->h != INVALID_HANDLE_VALUE && p->h != NULL) {
        if (!p->isServer) FlushFileBuffers(p->h);
        CloseHandle(p->h);
    }
#else
    if (p->isServer) {
        char path[512];
        ldp3_ipc_path(p->name, path, sizeof(path));
        close(p->fd);
        unlink(path);
    } else {
        close(p->fd);
    }
#endif
    free(p);
}

// ---- Subprocess (spec 34): run a command line through the shell, capturing its stdout and exit
// code. Returns a malloc'd NUL-terminated buffer of the captured output; *outLen is its length and
// *outExit the process exit code (-1 if the process could not be started). ----
#ifndef _WIN32
#define _popen popen    // the POSIX spelling of the same pipe-to-shell primitive
#define _pclose pclose
#endif
char* __ldp3_process_run(const char* cmd, long long* outLen, int* outExit) {
    FILE* p = _popen(cmd, "r");
    if (p == NULL) { *outLen = 0; *outExit = -1; char* e = (char*)malloc(1); e[0] = 0; return e; }
    size_t cap = 4096, len = 0;
    char* buf = (char*)malloc(cap);
    char chunk[4096];
    size_t n;
    while ((n = fread(chunk, 1, sizeof(chunk), p)) > 0) {
        if (len + n + 1 > cap) {
            while (len + n + 1 > cap) cap *= 2;
            buf = (char*)realloc(buf, cap);
        }
        memcpy(buf + len, chunk, n);
        len += n;
    }
    buf[len] = 0;
    *outExit = _pclose(p);
    *outLen = (long long)len;
    return buf;
}

// ---- Persistent subprocess (debugger/LSP support): spawn a child with pipes on its stdin/stdout, then
// exchange bytes over its lifetime (unlike Process.run, which is one-shot and captures stdout to EOF).
// The handle returned is a heap pointer cast to i64; 0 means the spawn failed. Callers own it until close.
// ----
struct LdpSubproc {
#ifdef _WIN32
    HANDLE proc;   // child process
    HANDLE hIn;    // our write end -> child's stdin
    HANDLE hOut;   // our read end  <- child's stdout
#else
    pid_t pid;
    int fdIn;      // our write end -> child's stdin
    int fdOut;     // our read end  <- child's stdout
#endif
};

#ifdef _WIN32
// mergeErr: give the child's stderr the same pipe as its stdout, so ONE stream carries everything the
// child says. A compiler prints its diagnostics on stderr, and a caller that only reads stdout would call
// a failing build silent. It is not the default: a child speaking a framed protocol (DAP) would have its
// stream corrupted by stray log lines, which is exactly the bug this flag lets each caller decide about.
long long __ldp3_subproc_spawn_ex(const char* cmdline, long long mergeErr) {
    SECURITY_ATTRIBUTES sa;
    sa.nLength = sizeof(sa);
    sa.bInheritHandle = TRUE;
    sa.lpSecurityDescriptor = NULL;
    HANDLE inRd = NULL, inWr = NULL, outRd = NULL, outWr = NULL;
    if (!CreatePipe(&inRd, &inWr, &sa, 0)) return 0;
    if (!CreatePipe(&outRd, &outWr, &sa, 0)) { CloseHandle(inRd); CloseHandle(inWr); return 0; }
    // Our own ends must not be inherited by the child (else they never signal EOF).
    SetHandleInformation(inWr, HANDLE_FLAG_INHERIT, 0);
    SetHandleInformation(outRd, HANDLE_FLAG_INHERIT, 0);
    STARTUPINFOA si;
    memset(&si, 0, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdInput = inRd;
    si.hStdOutput = outWr;
    si.hStdError = mergeErr != 0 ? outWr : GetStdHandle(STD_ERROR_HANDLE);
    PROCESS_INFORMATION pi;
    memset(&pi, 0, sizeof(pi));
    char* mutableCmd = _strdup(cmdline);  // CreateProcessA may modify the command line in place
    BOOL ok = CreateProcessA(NULL, mutableCmd, NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi);
    free(mutableCmd);
    CloseHandle(inRd);   // the child owns these now
    CloseHandle(outWr);
    if (!ok) { CloseHandle(inWr); CloseHandle(outRd); return 0; }
    CloseHandle(pi.hThread);
    LdpSubproc* s = (LdpSubproc*)malloc(sizeof(LdpSubproc));
    s->proc = pi.hProcess;
    s->hIn = inWr;
    s->hOut = outRd;
    return (long long)(intptr_t)s;
}

long long __ldp3_subproc_spawn(const char* cmdline) {
    return __ldp3_subproc_spawn_ex(cmdline, 0);
}

long long __ldp3_subproc_write(long long h, const char* data, long long len) {
    if (h == 0) return -1;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    DWORD written = 0;
    if (!WriteFile(s->hIn, data, (DWORD)len, &written, NULL)) return -1;
    return (long long)written;
}

char* __ldp3_subproc_read(long long h, long long* outLen) {
    *outLen = 0;
    if (h == 0) { char* e = (char*)malloc(1); e[0] = 0; return e; }
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    DWORD n = 0;
    char* buf = (char*)malloc(4097);
    if (!ReadFile(s->hOut, buf, 4096, &n, NULL) || n == 0) { buf[0] = 0; return buf; }  // EOF/broken pipe
    buf[n] = 0;
    *outLen = (long long)n;
    return buf;
}

int __ldp3_subproc_alive(long long h) {
    if (h == 0) return 0;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    return WaitForSingleObject(s->proc, 0) == WAIT_TIMEOUT ? 1 : 0;
}

// True when the child has bytes buffered to read right now (so read() returns data without blocking).
// EOF/broken pipe reads as 0 -- callers detect end-of-session via alive()/the adapter's terminated event,
// so a `while (can_read()) read()` pump terminates naturally instead of spinning on empty EOF reads.
int __ldp3_subproc_can_read(long long h) {
    if (h == 0) return 0;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    DWORD avail = 0;
    if (!PeekNamedPipe(s->hOut, NULL, 0, NULL, &avail, NULL)) return 0;  // closed/broken -> nothing to read
    return avail > 0 ? 1 : 0;
}

// Close only the child's stdin (send it EOF) without killing it -- lets a well-behaved child (lldb-dap,
// sort, cat) finish and exit on its own. Idempotent: the handle is nulled so close() won't double-close.
void __ldp3_subproc_close_stdin(long long h) {
    if (h == 0) return;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    if (s->hIn != NULL) { CloseHandle(s->hIn); s->hIn = NULL; }
}

void __ldp3_subproc_close(long long h) {
    if (h == 0) return;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    if (s->hIn != NULL) CloseHandle(s->hIn);
    CloseHandle(s->hOut);
    if (WaitForSingleObject(s->proc, 0) == WAIT_TIMEOUT) TerminateProcess(s->proc, 0);
    CloseHandle(s->proc);
    free(s);
}
#else
long long __ldp3_subproc_spawn_ex(const char* cmdline, long long mergeErr) {
    int inPipe[2], outPipe[2];  // inPipe: parent writes [1] -> child reads [0]; outPipe: child writes [1] -> parent reads [0]
    if (pipe(inPipe) != 0) return 0;
    if (pipe(outPipe) != 0) { close(inPipe[0]); close(inPipe[1]); return 0; }
    pid_t pid = fork();
    if (pid < 0) { close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]); return 0; }
    if (pid == 0) {
        dup2(inPipe[0], 0);
        dup2(outPipe[1], 1);
        if (mergeErr != 0) dup2(outPipe[1], 2);
        close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]);
        execl("/bin/sh", "sh", "-c", cmdline, (char*)NULL);
        _exit(127);
    }
    close(inPipe[0]);
    close(outPipe[1]);
    LdpSubproc* s = (LdpSubproc*)malloc(sizeof(LdpSubproc));
    s->pid = pid;
    s->fdIn = inPipe[1];
    s->fdOut = outPipe[0];
    return (long long)(intptr_t)s;
}

long long __ldp3_subproc_spawn(const char* cmdline) {
    return __ldp3_subproc_spawn_ex(cmdline, 0);
}

long long __ldp3_subproc_write(long long h, const char* data, long long len) {
    if (h == 0) return -1;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    ssize_t w = write(s->fdIn, data, (size_t)len);
    return (long long)w;
}

char* __ldp3_subproc_read(long long h, long long* outLen) {
    *outLen = 0;
    if (h == 0) { char* e = (char*)malloc(1); e[0] = 0; return e; }
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    char* buf = (char*)malloc(4097);
    ssize_t n = read(s->fdOut, buf, 4096);
    if (n <= 0) { buf[0] = 0; return buf; }
    buf[n] = 0;
    *outLen = (long long)n;
    return buf;
}

int __ldp3_subproc_alive(long long h) {
    if (h == 0) return 0;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    int status;
    pid_t r = waitpid(s->pid, &status, WNOHANG);
    return r == 0 ? 1 : 0;
}

int __ldp3_subproc_can_read(long long h) {
    if (h == 0) return 0;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    int n = 0;
    if (ioctl(s->fdOut, FIONREAD, &n) < 0) return 0;  // FIONREAD is 0 at EOF, matching the Windows path
    return n > 0 ? 1 : 0;
}

void __ldp3_subproc_close_stdin(long long h) {
    if (h == 0) return;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    if (s->fdIn >= 0) { close(s->fdIn); s->fdIn = -1; }
}

void __ldp3_subproc_close(long long h) {
    if (h == 0) return;
    LdpSubproc* s = (LdpSubproc*)(intptr_t)h;
    if (s->fdIn >= 0) close(s->fdIn);
    close(s->fdOut);
    int status;
    if (waitpid(s->pid, &status, WNOHANG) == 0) { kill(s->pid, SIGTERM); waitpid(s->pid, &status, 0); }
    free(s);
}
#endif

// ---- Local time zone (spec 34): the system's current UTC offset in seconds (east positive), including
// any active daylight-saving adjustment. Windows' Bias is UTC = local + Bias (minutes), so the offset is
// its negation. ----
#ifdef _WIN32
int __ldp3_local_utc_offset_seconds(void) {
    TIME_ZONE_INFORMATION tz;
    DWORD r = GetTimeZoneInformation(&tz);
    long bias = tz.Bias;
    if (r == TIME_ZONE_ID_DAYLIGHT) bias += tz.DaylightBias;
    else if (r == TIME_ZONE_ID_STANDARD) bias += tz.StandardBias;
    return (int)(-bias * 60);
}
#else
// tm_gmtoff carries the effective offset (DST included); glibc, musl and the BSDs all provide it.
int __ldp3_local_utc_offset_seconds(void) {
    time_t now = time(NULL);
    struct tm lt;
    localtime_r(&now, &lt);
    return (int)lt.tm_gmtoff;
}
#endif

// ---- Cryptographically secure randomness (spec 34): 64 bits from the OS CSPRNG. ----
#ifdef _WIN32
long long __ldp3_secure_random(void) {  // rand_s -> RtlGenRandom
    unsigned int hi = 0, lo = 0;
    rand_s(&hi);
    rand_s(&lo);
    return ((long long)(unsigned long long)hi << 32) | (long long)lo;
}
#else
long long __ldp3_secure_random(void) {  // getrandom(2), with /dev/urandom as the fallback
    unsigned long long v = 0;
    if (getrandom(&v, sizeof v, 0) != (ssize_t)sizeof v) {
        int fd = open("/dev/urandom", O_RDONLY);
        if (fd >= 0) {
            ssize_t r = read(fd, &v, sizeof v);
            (void)r;
            close(fd);
        }
    }
    return (long long)v;
}
#endif

// ---- Environment variables (spec 34). ----
char* __ldp3_env_get(const char* name, long long* outLen) {
    const char* v = getenv(name);
    if (v == NULL) { *outLen = 0; char* e = (char*)malloc(1); e[0] = 0; return e; }
    size_t n = strlen(v);
    char* buf = (char*)malloc(n + 1);
    memcpy(buf, v, n + 1);
    *outLen = (long long)n;
    return buf;
}
int __ldp3_env_set(const char* name, const char* value) {
#ifdef _WIN32
    return _putenv_s(name, value) == 0 ? 1 : 0;
#else
    return setenv(name, value, 1) == 0 ? 1 : 0;
#endif
}
// The running program's own path (spec 34): Windows via GetModuleFileNameA, POSIX via
// /proc/self/exe. Returns a heap NUL-terminated string; empty on failure or truncation rather
// than a half-formed path a caller might trust.
char* __ldp3_executable_path(void) {
#ifdef _WIN32
    DWORD cap = 4096;
    char* buf = (char*)malloc(cap);
    if (buf == NULL) { char* e = (char*)malloc(1); if (e) e[0] = 0; return e; }
    DWORD n = GetModuleFileNameA(NULL, buf, cap);
    if (n == 0 || n >= cap) { buf[0] = 0; } else { buf[n] = 0; }
    return buf;
#else
    size_t cap = 4096;
    char* buf = (char*)malloc(cap);
    if (buf == NULL) { char* e = (char*)malloc(1); if (e) e[0] = 0; return e; }
    ssize_t n = readlink("/proc/self/exe", buf, cap - 1);
    if (n < 0) { buf[0] = 0; } else { buf[(size_t)n] = 0; }
    return buf;
#endif
}

// ---- File I/O (spec 34.4): whole-file read/write over C stdio. ----
char* __ldp3_file_read_all(const char* path, long long* outLen) {
    FILE* f = fopen(path, "rb");
    if (f == NULL) { *outLen = 0; char* e = (char*)malloc(1); e[0] = 0; return e; }
    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    if (size < 0) size = 0;
    fseek(f, 0, SEEK_SET);
    char* buf = (char*)malloc((size_t)size + 1);
    size_t n = fread(buf, 1, (size_t)size, f);
    fclose(f);
    buf[n] = 0;
    *outLen = (long long)n;
    return buf;
}
int __ldp3_file_write_all(const char* path, const char* data, long long len, int append) {
    FILE* f = fopen(path, append ? "ab" : "wb");
    if (f == NULL) return 0;
    size_t n = fwrite(data, 1, (size_t)len, f);
    fclose(f);
    return n == (size_t)len ? 1 : 0;
}
int __ldp3_file_exists(const char* path) {
    FILE* f = fopen(path, "rb");
    if (f != NULL) { fclose(f); return 1; }
    return 0;
}
int __ldp3_file_delete(const char* path) { return remove(path) == 0 ? 1 : 0; }

// ---- Directory / filesystem metadata (spec 34.4). ----
// The directory's entries as a NUL-terminated, newline-separated string ("" if not a directory or
// empty). *outLen is the byte length. "." and ".." are skipped.
#ifdef _WIN32
char* __ldp3_dir_list(const char* path, long long* outLen) {
    char pattern[MAX_PATH];
    snprintf(pattern, sizeof(pattern), "%s\\*", path);
    WIN32_FIND_DATAA fd;
    HANDLE h = FindFirstFileA(pattern, &fd);
    size_t cap = 256, len = 0;
    char* buf = (char*)malloc(cap);
    if (h != INVALID_HANDLE_VALUE) {
        do {
            if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0) continue;
            size_t nl = strlen(fd.cFileName);
            if (len + nl + 2 > cap) { while (len + nl + 2 > cap) cap *= 2; buf = (char*)realloc(buf, cap); }
            memcpy(buf + len, fd.cFileName, nl);
            len += nl;
            buf[len++] = '\n';
        } while (FindNextFileA(h, &fd));
        FindClose(h);
    }
    buf[len] = 0;
    *outLen = (long long)len;
    return buf;
}
int __ldp3_mkdir(const char* path) { return CreateDirectoryA(path, NULL) ? 1 : 0; }
int __ldp3_rename(const char* from, const char* to) { return MoveFileA(from, to) ? 1 : 0; }
int __ldp3_is_dir(const char* path) {
    DWORD a = GetFileAttributesA(path);
    return (a != INVALID_FILE_ATTRIBUTES && (a & FILE_ATTRIBUTE_DIRECTORY)) ? 1 : 0;
}
long long __ldp3_file_size(const char* path) {
    WIN32_FILE_ATTRIBUTE_DATA d;
    if (!GetFileAttributesExA(path, GetFileExInfoStandard, &d)) return -1;
    return ((long long)d.nFileSizeHigh << 32) | (long long)d.nFileSizeLow;
}
#else
char* __ldp3_dir_list(const char* path, long long* outLen) {
    DIR* d = opendir(path);
    size_t cap = 256, len = 0;
    char* buf = (char*)malloc(cap);
    if (d != NULL) {
        struct dirent* e;
        while ((e = readdir(d)) != NULL) {
            if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
            size_t nl = strlen(e->d_name);
            if (len + nl + 2 > cap) { while (len + nl + 2 > cap) cap *= 2; buf = (char*)realloc(buf, cap); }
            memcpy(buf + len, e->d_name, nl);
            len += nl;
            buf[len++] = '\n';
        }
        closedir(d);
    }
    buf[len] = 0;
    *outLen = (long long)len;
    return buf;
}
int __ldp3_mkdir(const char* path) { return mkdir(path, 0777) == 0 ? 1 : 0; }
int __ldp3_rename(const char* from, const char* to) { return rename(from, to) == 0 ? 1 : 0; }
int __ldp3_is_dir(const char* path) {
    struct stat st;
    return (stat(path, &st) == 0 && S_ISDIR(st.st_mode)) ? 1 : 0;
}
long long __ldp3_file_size(const char* path) {
    struct stat st;
    if (stat(path, &st) != 0) return -1;
    return (long long)st.st_size;
}
#endif

// Decimal text of `n` into `buf` (signed, no NUL needed), returns the digit count. For int.toString().
long long __ldp3_itoa(long long n, char* buf) {
    char tmp[24];
    int i = 0;
    int neg = (n < 0);
    unsigned long long u = neg ? (unsigned long long)(-(n + 1)) + 1ULL : (unsigned long long)n;
    if (u == 0) { tmp[i++] = '0'; }
    while (u > 0) { tmp[i++] = (char)('0' + (u % 10)); u /= 10; }
    long long len = 0;
    if (neg) { buf[len++] = '-'; }
    while (i > 0) { buf[len++] = tmp[--i]; }
    buf[len] = 0;
    return len;
}

// ---- String methods (spec 34.5): search + transforms over byte buffers. ----
long long __ldp3_str_index(const char* h, long long hl, const char* n, long long nl) {
    if (nl == 0) return 0;
    if (nl > hl) return -1;
    for (long long i = 0; i + nl <= hl; i++) {
        long long j = 0;
        while (j < nl && h[i + j] == n[j]) j++;
        if (j == nl) return i;
    }
    return -1;
}
int __ldp3_str_ends(const char* h, long long hl, const char* n, long long nl) {
    if (nl > hl) return 0;
    return memcmp(h + (hl - nl), n, (size_t)nl) == 0 ? 1 : 0;
}
char* __ldp3_str_upper(const char* d, long long len) {
    char* b = (char*)__ldp3_malloc((size_t)len + 1);   // __ldp3_malloc so String RAII can __ldp3_free it
    for (long long i = 0; i < len; i++) { char c = d[i]; b[i] = (c >= 'a' && c <= 'z') ? (char)(c - 32) : c; }
    b[len] = 0;
    return b;
}
char* __ldp3_str_lower(const char* d, long long len) {
    char* b = (char*)__ldp3_malloc((size_t)len + 1);
    for (long long i = 0; i < len; i++) { char c = d[i]; b[i] = (c >= 'A' && c <= 'Z') ? (char)(c + 32) : c; }
    b[len] = 0;
    return b;
}
char* __ldp3_str_trim(const char* d, long long len, long long* outLen) {
    long long s = 0, e = len;
    while (s < e && (d[s] == ' ' || d[s] == '\t' || d[s] == '\n' || d[s] == '\r')) s++;
    while (e > s && (d[e - 1] == ' ' || d[e - 1] == '\t' || d[e - 1] == '\n' || d[e - 1] == '\r')) e--;
    long long n = e - s;
    char* b = (char*)__ldp3_malloc((size_t)n + 1);
    memcpy(b, d + s, (size_t)n);
    b[n] = 0;
    *outLen = n;
    return b;
}
char* __ldp3_str_repeat(const char* d, long long len, long long count, long long* outLen) {
    if (count < 0) count = 0;
    long long n = len * count;
    char* b = (char*)__ldp3_malloc((size_t)n + 1);
    for (long long k = 0; k < count; k++) memcpy(b + k * len, d, (size_t)len);
    b[n] = 0;
    *outLen = n;
    return b;
}
// Scope-based String RAII helpers. String is laid out { i64 len, char* data, i64 hash }; struct and data
// buffer are both __ldp3_malloc'd. copy makes a fully-owned duplicate; free releases buffer then struct.
// Single runtime calls (not inlined IR) so codegen never has to split a basic block to null-check.
void* __ldp3_str_copy(void* src) {
    if (src == 0) return 0;
    struct Ldp3Str { long long len; char* data; long long hash; };
    Ldp3Str* s = (Ldp3Str*)src;
    Ldp3Str* out = (Ldp3Str*)__ldp3_malloc(sizeof(Ldp3Str));
    char* buf = (char*)__ldp3_malloc((size_t)s->len + 1);
    memcpy(buf, s->data, (size_t)s->len);
    buf[s->len] = 0;
    out->len = s->len; out->data = buf; out->hash = 0;
    return out;
}
void __ldp3_str_free(void* src) {
    if (src == 0) return;
    struct Ldp3Str { long long len; char* data; long long hash; };
    Ldp3Str* s = (Ldp3Str*)src;
    __ldp3_free(s->data);
    __ldp3_free(s);
}

// FNV-1a hash of `len` bytes, for Hashable<String> (collections).
long long __ldp3_str_hash(const char* data, long long len) {
    unsigned long long h = 1469598103934665603ULL;  // FNV offset basis
    for (long long i = 0; i < len; i++) {
        h ^= (unsigned char)data[i];
        h *= 1099511628211ULL;  // FNV prime
    }
    return (long long)h;
}

// Cached String hash. A String object is laid out { i64 length, char* data, i64 hash } by the codegen;
// the trailing hash is a lazily-filled FNV-1a of the bytes (0 = not computed). Since a String is
// immutable, it is hashed at most once -- the hot path (HashMap<String,...>) then just reads the field.
// A genuine hash of 0 is stored as 1 so a populated cache always reads non-zero.
long long __ldp3_str_hash_obj(void* obj) {
    struct Ldp3Str { long long len; char* data; long long hash; };
    Ldp3Str* s = (Ldp3Str*)obj;
    if (s->hash != 0) return s->hash;
    long long h = __ldp3_str_hash(s->data, s->len);
    if (h == 0) h = 1;
    s->hash = h;
    return h;
}

// await from non-async code (e.g. main): block the calling thread until the task completes.
long long __ldp3_task_wait(long long handle) {
    ldp3_task* t = (ldp3_task*)handle;
    if (t == NULL) return 0;
    __ldp3_pool_start();
    EnterCriticalSection(&g_qlock);
    while (!t->done) SleepConditionVariableCS(&g_donecond, &g_qlock, INFINITE);
    LeaveCriticalSection(&g_qlock);
    return t->result;
}

// The overwrite/restore length for a function: bounded by the next function's address in
// the program-wide table, so a neighbour is never touched. Capped for safety.
static size_t __ldp3_fn_len(void* fn, void** table, long long count) {
    unsigned long long base = (unsigned long long)fn, next = 0;
    for (long long i = 0; i < count; i++) {
        unsigned long long a = (unsigned long long)table[i];
        if (a > base && (next == 0 || a < next)) next = a;
    }
    unsigned long long len = next ? (next - base) : 64;
    return (size_t)(len > 4096 ? 4096 : len);
}

// Make a function's code writable+executable. mprotect needs page-aligned bounds, so the POSIX
// side rounds the range out to page boundaries.
static int __ldp3_code_unprotect(void* fn, size_t len) {
#ifdef _WIN32
    DWORD old;
    return VirtualProtect(fn, len, PAGE_EXECUTE_READWRITE, &old) ? 1 : 0;
#else
    long page = sysconf(_SC_PAGESIZE);
    if (page <= 0) page = 4096;
    uintptr_t start = (uintptr_t)fn & ~((uintptr_t)page - 1);
    uintptr_t end = ((uintptr_t)fn + len + (uintptr_t)page - 1) & ~((uintptr_t)page - 1);
    return mprotect((void*)start, end - start, PROT_READ | PROT_WRITE | PROT_EXEC) == 0 ? 1 : 0;
#endif
}
static void __ldp3_code_flush(void* fn, size_t len) {
#ifdef _WIN32
    FlushInstructionCache(GetCurrentProcess(), fn, len);
#else
    __builtin___clear_cache((char*)fn, (char*)fn + len);  // no-op on x86, required on ARM
#endif
}

// Physical code unload (spec 30 "unloading agressivo"): overwrite a function's machine code
// in RAM with int3 (0xCC), so the instructions are physically ripped from memory.
void __ldp3_unload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    size_t len = __ldp3_fn_len(fn, table, count);
    if (__ldp3_code_unprotect(fn, len)) {
        memset(fn, 0xCC, len);
        __ldp3_code_flush(fn, len);
    }
}

// Physical code reload for reimport (spec 30.3 "recarrega do disco"): read the function's
// original bytes from the program's own executable on disk (the image file still holds them) and
// write them back over the int3-overwritten RAM. x64 code is RIP-relative, so the .text
// bytes are position-independent within the module and need no relocation fix-up.
#ifdef _WIN32
void __ldp3_reload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    size_t len = __ldp3_fn_len(fn, table, count);
    unsigned char* mbase = (unsigned char*)GetModuleHandleW(NULL);
    DWORD rva = (DWORD)((unsigned char*)fn - mbase);
    IMAGE_DOS_HEADER* dos = (IMAGE_DOS_HEADER*)mbase;
    IMAGE_NT_HEADERS* nt = (IMAGE_NT_HEADERS*)(mbase + dos->e_lfanew);
    IMAGE_SECTION_HEADER* sec = IMAGE_FIRST_SECTION(nt);
    DWORD fileOff = 0;
    int found = 0;
    for (int i = 0; i < nt->FileHeader.NumberOfSections; i++) {
        if (rva >= sec[i].VirtualAddress && rva < sec[i].VirtualAddress + sec[i].Misc.VirtualSize) {
            fileOff = rva - sec[i].VirtualAddress + sec[i].PointerToRawData;
            found = 1;
            break;
        }
    }
    if (!found) return;
    wchar_t path[MAX_PATH];
    if (GetModuleFileNameW(NULL, path, MAX_PATH) == 0) return;
    HANDLE h = CreateFileW(path, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (h == INVALID_HANDLE_VALUE) return;
    unsigned char* buf = (unsigned char*)malloc(len);
    LARGE_INTEGER off;
    off.QuadPart = fileOff;
    DWORD got = 0;
    if (buf != NULL && SetFilePointerEx(h, off, NULL, FILE_BEGIN))
        ReadFile(h, buf, (DWORD)len, &got, NULL);
    CloseHandle(h);
    if (buf != NULL && got > 0 && __ldp3_code_unprotect(fn, len)) {
        memcpy(fn, buf, got);
        __ldp3_code_flush(fn, len);
    }
    free(buf);
}
#else
// ELF mirror of the PE logic: the main module's load base comes from dl_iterate_phdr (the first
// visited module -- the executable, PIE included), the vaddr->file-offset mapping from its PT_LOAD
// program headers, and the bytes from /proc/self/exe.
static int __ldp3_main_base_cb(struct dl_phdr_info* info, size_t, void* out) {
    *(uintptr_t*)out = (uintptr_t)info->dlpi_addr;
    return 1;  // stop after the first entry (the main executable)
}
void __ldp3_reload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    size_t len = __ldp3_fn_len(fn, table, count);
    uintptr_t base = 0;
    dl_iterate_phdr(__ldp3_main_base_cb, &base);
    uintptr_t vaddr = (uintptr_t)fn - base;  // the link-time virtual address of the function
    FILE* f = fopen("/proc/self/exe", "rb");
    if (f == NULL) return;
    ElfW(Ehdr) eh;
    if (fread(&eh, 1, sizeof eh, f) != sizeof eh) { fclose(f); return; }
    long long fileOff = -1;
    for (int i = 0; i < eh.e_phnum; i++) {
        ElfW(Phdr) ph;
        if (fseek(f, (long)(eh.e_phoff + (unsigned long long)i * eh.e_phentsize), SEEK_SET) != 0) break;
        if (fread(&ph, 1, sizeof ph, f) != sizeof ph) break;
        if (ph.p_type == PT_LOAD && vaddr >= ph.p_vaddr && vaddr < ph.p_vaddr + ph.p_filesz) {
            fileOff = (long long)(vaddr - ph.p_vaddr + ph.p_offset);
            break;
        }
    }
    if (fileOff < 0) { fclose(f); return; }
    unsigned char* buf = (unsigned char*)malloc(len);
    size_t got = 0;
    if (buf != NULL && fseek(f, (long)fileOff, SEEK_SET) == 0) got = fread(buf, 1, len, f);
    fclose(f);
    if (buf != NULL && got > 0 && __ldp3_code_unprotect(fn, len)) {
        memcpy(fn, buf, got);
        __ldp3_code_flush(fn, len);
    }
    free(buf);
}
#endif

// FFI by-value struct test helpers (spec 26): a small POD struct passed and returned by value,
// matching the layout of an LDP3 `struct Point { int x; int y; }`.
struct Ldp3Point { int x; int y; };
int ldp3_point_sum(struct Ldp3Point p) { return p.x + p.y; }
struct Ldp3Point ldp3_point_scale(struct Ldp3Point p, int k) {
    struct Ldp3Point r;
    r.x = p.x * k;
    r.y = p.y * k;
    return r;
}

// Reads one line from stdin into a freshly allocated, null-terminated buffer (the trailing newline is
// stripped). The byte length is returned through out_len. The general Console.read() input primitive:
// it returns a String, which the program parses (e.g. toInt) for other types.
char* ldp3_read_line(int64_t* out_len) {
    size_t cap = 128, len = 0;
    char* buf = (char*)malloc(cap);
    int c;
    while ((c = getchar()) != EOF && c != '\n') {
        if (len + 1 >= cap) { cap *= 2; buf = (char*)realloc(buf, cap); }
        buf[len++] = (char)c;
    }
    buf[len] = '\0';
    if (out_len) *out_len = (int64_t)len;
    return buf;
}

// FFI callback test helper (spec 26): a C function that takes a raw function pointer and calls it.
int ldp3_apply_cb(int (*f)(int), int x) { return f(x); }

#ifdef __cplusplus
}  // extern "C"
#endif
