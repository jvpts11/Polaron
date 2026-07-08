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
#include <sys/mman.h>
#include <sys/random.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

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
#define LDP3_POOL_MAX 512u                 // requests above this go straight to libc malloc
#define LDP3_NCLASSES 32                   // size classes 16,32,...,512 (step 16)
#define LDP3_SLAB (1u << 20)               // 1 MiB slabs, bump-allocated then recycled via free-list
#define LDP3_LARGE 0xFFFFFFFFu

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

void* __ldp3_malloc(size_t size) {
    if (size == 0) size = 1;
    if (size > LDP3_POOL_MAX) {  // large: a plain libc block tagged so free/realloc recognise it
        char* p = (char*)malloc(size + 16);
        if (p == NULL) return NULL;
        ((Ldp3Hdr*)p)->magic = LDP3_MAGIC;
        ((Ldp3Hdr*)p)->cls = LDP3_LARGE;
        return p + 16;
    }
    unsigned cls = (unsigned)((size + 15) / 16) - 1;  // 0..31
    Ldp3FreeNode* n = g_ldp3_free[cls];
    if (n != NULL) {  // reuse: the header (magic + class) is still intact just before the node
        g_ldp3_free[cls] = n->next;
        ((Ldp3Hdr*)((char*)n - 16))->magic = LDP3_MAGIC;  // live again: clear the freed stamp
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
    if (h->magic != LDP3_MAGIC) {  // foreign pointer (libc) -- forward
        free(ptr);
        return;
    }
    if (h->cls == LDP3_LARGE) {
        h->magic = LDP3_FREED;  // large blocks go back to libc; stamp guards a same-run double free
        free(h);
        return;
    }
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
    if (h->magic == LDP3_FREED) __ldp3_panic("use of a freed object (double delete)");
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

void* __ldp3_realloc(void* ptr, size_t size) {
    if (ptr == NULL) return __ldp3_malloc(size);
    Ldp3Hdr* h = (Ldp3Hdr*)((char*)ptr - 16);
    if (h->magic != LDP3_MAGIC) return realloc(ptr, size);  // foreign pointer
    if (h->cls == LDP3_LARGE) {
        char* np = (char*)realloc(h, size + 16);
        if (np == NULL) return NULL;
        ((Ldp3Hdr*)np)->magic = LDP3_MAGIC;
        ((Ldp3Hdr*)np)->cls = LDP3_LARGE;
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
    char* b = (char*)malloc((size_t)len + 1);
    for (long long i = 0; i < len; i++) { char c = d[i]; b[i] = (c >= 'a' && c <= 'z') ? (char)(c - 32) : c; }
    b[len] = 0;
    return b;
}
char* __ldp3_str_lower(const char* d, long long len) {
    char* b = (char*)malloc((size_t)len + 1);
    for (long long i = 0; i < len; i++) { char c = d[i]; b[i] = (c >= 'A' && c <= 'Z') ? (char)(c + 32) : c; }
    b[len] = 0;
    return b;
}
char* __ldp3_str_trim(const char* d, long long len, long long* outLen) {
    long long s = 0, e = len;
    while (s < e && (d[s] == ' ' || d[s] == '\t' || d[s] == '\n' || d[s] == '\r')) s++;
    while (e > s && (d[e - 1] == ' ' || d[e - 1] == '\t' || d[e - 1] == '\n' || d[e - 1] == '\r')) e--;
    long long n = e - s;
    char* b = (char*)malloc((size_t)n + 1);
    memcpy(b, d + s, (size_t)n);
    b[n] = 0;
    *outLen = n;
    return b;
}
char* __ldp3_str_repeat(const char* d, long long len, long long count, long long* outLen) {
    if (count < 0) count = 0;
    long long n = len * count;
    char* b = (char*)malloc((size_t)n + 1);
    for (long long k = 0; k < count; k++) memcpy(b + k * len, d, (size_t)len);
    b[n] = 0;
    *outLen = n;
    return b;
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
