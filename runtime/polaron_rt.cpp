// Polaron minimal runtime: thread support (spec 20.1), defined-behaviour panic, and the
// physical code unload/reload behind unimport/reimport (spec 30). Linked into every exe.
// Portable across Windows and Linux: OS-specific pieces live behind _WIN32, and the concurrency
// and socket code is single-source over a small POSIX shim that spells the Win32 primitive names.

#ifdef _WIN32
#ifndef _CRT_SECURE_NO_WARNINGS
#define _CRT_SECURE_NO_WARNINGS  // fopen/remove etc. are used deliberately (File I/O, spec 34.4)
#endif
#define _CRT_RAND_S              // enables rand_s (cryptographically secure RNG, spec 34)
#define WIN32_LEAN_AND_MEAN
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0A00        // Windows 10 -- required to declare the ConPTY API (the pty terminal)
#endif
#ifndef NTDDI_VERSION
#define NTDDI_VERSION 0x0A000006   // NTDDI_WIN10_RS5 -- CreatePseudoConsole/HPCON need RS5 or later
#endif
#include <winsock2.h>   // must precede <windows.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <io.h>         // _dup/_dup2/_close: the stdout diversion behind Test.captureOutput
#pragma comment(lib, "ws2_32.lib")
#else
#include <arpa/inet.h>
#include <dirent.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <poll.h>          // poll: bounded IPC reads, so a dead peer cannot hang the program
#include <pthread.h>
#include <sched.h>
#include <signal.h>        // kill/SIGTERM (subprocess teardown)
#include <sys/ioctl.h>     // FIONREAD (non-blocking subprocess readability check)
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/file.h>      // flock: keeping two programs off one file
#include <sys/statvfs.h>   // statvfs: free/total bytes on the volume holding a path
#include <sys/time.h>      // utimes: set a file's modification time to now (`touch`)
#include <sys/types.h>
#include <sys/un.h>        // AF_UNIX (cross-program IPC transport, spec 2.8)
#include <sys/wait.h>      // waitpid (subprocess liveness/teardown)
#include <time.h>
#include <unistd.h>
// PER-SYSTEM, not per-Unix. These three questions -- where is my executable, give me random bytes,
// what is my load address -- have a different answer on every one of them, and the Linux answer
// compiles silently elsewhere while doing nothing (`/proc/self/exe` on a FreeBSD without procfs
// returns empty, and nothing reports it).
#if defined(__APPLE__)
#include <mach-o/dyld.h>     // _NSGetExecutablePath
#include <stdlib.h>          // arc4random_buf
#else
// ELF is shared by Linux and FreeBSD; macOS is Mach-O and has neither header nor `dl_iterate_phdr`.
#include <elf.h>             // ElfW, Elf*_Ehdr/Phdr (reimport reads the on-disk ELF)
#include <link.h>            // dl_iterate_phdr (reimport's module base)
#endif
#if defined(__FreeBSD__)
#include <stdlib.h>          // arc4random_buf
#include <sys/sysctl.h>      // KERN_PROC_PATHNAME
#elif !defined(__APPLE__)
#include <sys/random.h>      // getrandom -- a Linux header
#endif
#endif
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <string>   // building the OS answers below; the buffer handed to Polaron is __polaron_malloc'd
#include <vector>
#ifdef _WIN32
#include <intrin.h>  // _InterlockedExchangeAdd64 for the allocation profiler's lock-free counters
#endif

#ifndef _WIN32
// POSIX shim spelling the Win32 primitives the concurrency/socket code below uses, so that code
// stays single-source. Only what the runtime actually calls; not a general compatibility layer.
//
// `using` and not `typedef`, `constexpr` and not `#define`: a typedef is C, and a macro is worse than
// C -- it has no type, no scope, and it rewrites any later use of the name whether that use meant it
// or not. `closesocket` stays a macro because it renames a FUNCTION, and giving it a name of its own
// would need a wrapper whose only content is the call.
using CRITICAL_SECTION = pthread_mutex_t;
using CONDITION_VARIABLE = pthread_cond_t;
using SOCKET = int;
using BOOL = int;
constexpr int TRUE = 1;
constexpr SOCKET INVALID_SOCKET = -1;
constexpr unsigned INFINITE = 0xFFFFFFFFu;
#define closesocket close
static void InitializeCriticalSection(CRITICAL_SECTION* m) { pthread_mutex_init(m, nullptr); }
static void EnterCriticalSection(CRITICAL_SECTION* m) { pthread_mutex_lock(m); }
static void LeaveCriticalSection(CRITICAL_SECTION* m) { pthread_mutex_unlock(m); }
static void InitializeConditionVariable(CONDITION_VARIABLE* c) { pthread_cond_init(c, nullptr); }
static void SleepConditionVariableCS(CONDITION_VARIABLE* c, CRITICAL_SECTION* m, unsigned) {
    pthread_cond_wait(c, m);
}
static void WakeConditionVariable(CONDITION_VARIABLE* c) { pthread_cond_signal(c); }
static void WakeAllConditionVariable(CONDITION_VARIABLE* c) { pthread_cond_broadcast(c); }
#endif

// The IR calls these by their plain C names. Keep C linkage even when this file is compiled as part
// of a C++ link (e.g. alongside the dynamic-bundle loader), so the names are not mangled.
//
// POLARON_RT_API exports the symbols a dynamically-loaded bundle must reach BACK into the host for. A
// bundle is compiled to a shared library at load time, and its allocations have to come from the SAME
// heap as the host's -- one heap and one `__polaron_check_live` registry, or an object allocated on one
// side and freed on the other corrupts both and the double-free trap stops seeing half the program.
//
// On POSIX the host is linked -rdynamic and the .so resolves against it; Windows has no equivalent, so
// the host exports and the bundle imports. THIS COSTS THE HOST NOTHING: `dllexport` on a definition does
// not make the defining module's own calls indirect, so every direct call in the program stays direct.
// The single added indirection (through the import table) is inside the bundle, which has already paid
// for a LoadLibrary to exist at all.
#if defined(_WIN32)
#define POLARON_RT_API __declspec(dllexport)
#else
#define POLARON_RT_API __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif

// `polc --verify-stack` calls this when a method returns on a different stack pointer than the one it
// was entered on. It REPORTS AND RETURNS rather than terminating, and that is deliberate: the fault it
// was built for happens roughly one run in twenty, and every attempt to stop the machine at it changed
// the timing enough to hide it. Leaving the run intact means the next thing that goes wrong is still
// observable and the two can be lined up.
//
// Defined here as well as in the freestanding runtime (`src/driver/build.cpp`), because a flag that
// fails to LINK anywhere but bare metal is a flag nobody can try the day they need it.
POLARON_RT_API void __polaron_stack_mismatch(const char* method) {
    fprintf(stderr, "Polaron STACK MISMATCH in %s\n", method);
}

// Defined-behaviour panic: Polaron never invokes UB. When a check fails (division by zero,
// out-of-bounds, etc.) the program terminates deterministically with a message instead of
// continuing into undefined territory.
POLARON_RT_API void __polaron_panic(const char* msg) {
    fprintf(stderr, "Polaron panic: %s\n", msg);
#ifdef _WIN32
    if (getenv("POLARON_BT") !=
        nullptr) {  // diagnostic: print the call stack RVAs so a -g build can be symbolized
        void* frames[32];
        unsigned short n = RtlCaptureStackBackTrace(0, 32, frames, nullptr);
        char* base = reinterpret_cast<char*>(GetModuleHandleA(nullptr));
        for (unsigned short k = 0; k < n; k++) {
            std::fprintf(stderr, "[bt] rva 0x%llx\n",
                         static_cast<unsigned long long>(static_cast<char*>(frames[k]) - base));
        }
    }
#endif
    fflush(stderr);
    exit(70);
}

// Pooled allocator for Polaron objects/arrays/strings. The Windows system malloc is slow for the
// allocate-many-small-and-free-them pattern (trees, temporaries); a per-thread segregated free-list
// makes new/delete of small blocks O(1) with no lock, closing the gap to hand-tuned allocators.
//
// Layout: [16-byte header][payload]. The header carries a 64-bit magic so __polaron_free / __polaron_realloc
// can tell a pool block from any foreign (libc) pointer that reaches them -- foreign pointers (e.g. a
// calloc'd persistent slot) are forwarded to libc, so mixing is always safe. Large requests bypass the
// pool. Thread-local free-lists need no lock; a block freed on any thread is simply reused there.
// (The four constants that describe a heap block moved into polaron_alloc_core.hpp, with the
// allocator that stamps them: a target compiling that core needs them and had no way to get them from
// here. They became `constexpr` on the way, matching the region core's own two.)

// A CONTRACT THAT FAILED, REPORTED THE WAY AN ERROR SHOULD BE.
//
// On stderr, like the panics, because it is a fatal diagnostic and not program output -- on stdout
// it lands in the middle of whatever the program was printing and disappears into a redirect.
//
// The values arrive as arguments rather than baked into a format string. Composing `%lld` into the
// message in the compiler would put a format specifier inside a string the programmer's own clause
// text is pasted into, and a clause containing a stray `%` would then be read as a directive -- the
// same injection the compiler already refuses for literals passed to printf.
// ONE SHAPE FOR EVERY WAY A RUN CAN STOP.
//
// A contract that failed, an index off the end, a divide by zero: they are the same event from the
// programmer's side -- the run stopped for a reason it now has to be told. So they print the same
// way, and there is one function that does it rather than a message style per guard.
//
// The two numbers are the part that matters most and the part every one of these used to omit. They
// arrive as arguments with their own labels rather than composed into a format string: the headline
// carries the programmer's own clause or expression text, and a stray `%` in that text would be read
// as a directive -- the same injection the compiler already refuses for literals handed to printf.
// A null label means this failure has no numbers to show.
POLARON_RT_API void __polaron_fail(const char* headline, const char* aLabel, long long a,
                             const char* bLabel, long long b, int code) {
    fputs(headline, stderr);
    if (aLabel != nullptr && bLabel != nullptr) {
        fprintf(stderr, "   |  %s = %lld, %s = %lld\n", aLabel, a, bLabel, b);
    }
    fflush(stderr);
    exit(code);
}

// The region layout and the size-class scheme it shares with the heap pool. THE one definition: the
// same header is compiled bare-metal by `polaron build`, so a hosted program and a kernel cannot end up
// disagreeing about where a region's data starts. __polaron_panic is already defined above, so the
// header's declaration of it (which bare metal needs) would clash with its dllexport -- suppress it.
#define POLARON_PANIC_DECLARED
#include "polaron_region_core.hpp"
// The heap block's constants only -- the allocator itself comes further down, once the backend it
// calls exists. See the note at the top of that header for why it is included twice.
#include "polaron_alloc_core.hpp"

// -------- allocation profiler (env POLARON_MEMPROF=1) â€” diagnostic only, one branch when off --------
// Logical live-bytes: incremented on __polaron_malloc, decremented on __polaron_free. Pool blocks never
// return to libc (they recycle on a free-list), so RSS follows the *net* live bytes: if this climbs,
// the program is leaking. A size-class histogram of the still-live set at exit says whether the leak
// is many small blocks (Strings/objects/spans, pool classes) or a few big buffers (large bucket).
// Kept STL-free (plain longs + a lock-free add) so it compiles with the bundled clang toolchain.
// Compiled out of the production runtime for ZERO overhead: without -DPOLARON_PROFILING the gate is a
// compile-time `false`, so every `if (g_prof_on)` / `if (g_memsite_on)` hot-path branch dead-eliminates
// at -O2 (the counters/helpers below stay defined but unreachable). Build the runtime with
// -DPOLARON_PROFILING to enable POLARON_MEMPROF / POLARON_MEMSITE.
#ifdef POLARON_PROFILING
static bool g_prof_on = false;
#else
#define g_prof_on false
#endif
static long long g_prof_live_bytes = 0;
static long long g_prof_live_count = 0;
static long long g_prof_total_alloc = 0;
static long long g_prof_total_free = 0;
static long long g_prof_class_live[33];  // 0..31 = pool classes; 32 = large (>512 B)

// -------- always-on live-block accounting (Test.assertNoLeaks, spec 32.11) --------
// Deliberately NOT the profiler counters above: those are interlocked and compiled out of the
// production runtime, while an assertion a test can write must work in every build. thread_local and
// non-atomic, matching the thread_local pool free-lists it accounts for -- two ordinary increments,
// no bus lock -- so it measures the CALLING THREAD's net allocation, which is what a single-threaded
// test wants and is the documented limit of the assertion.
// (`g_live_bytes` / `g_live_count` and the two readers now live in polaron_alloc_core.hpp, with the
// allocator that maintains them. Same storage class, same meaning.)

static inline void prof_add(long long* p, long long d) {
#ifdef _WIN32
    _InterlockedExchangeAdd64((volatile long long*)p, d);
#else
    __atomic_fetch_add(p, d, __ATOMIC_RELAXED);
#endif
}

// -------- leak-by-site attribution (env POLARON_MEMSITE=1) --------
// Heavier than the size histogram: captures a short backtrace per POOL alloc, aggregates the live count
// per call-site, and dumps the top leaking sites at exit as RVAs -- symbolize against a -g build with
// `llvm-dwarfdump --lookup=<imageBase+rva>`. Pool blocks only (their pad word is free; large blocks use
// pad for size). Single-threaded assumption for the site table (diagnostic use). Windows only.
#ifdef _WIN32
#define POLARON_NSITES 16384u
#define POLARON_NFR 5
struct PolaronSite { void* fr[POLARON_NFR]; long long live; long long total; };
static PolaronSite g_sites[POLARON_NSITES];
#ifdef POLARON_PROFILING
static bool g_memsite_on = false;
#else
#define g_memsite_on false
#endif

static int site_index(void* const* fr) {
    unsigned long long h = 1469598103934665603ULL;
    for (int k = 0; k < POLARON_NFR; k++) { h ^= reinterpret_cast<unsigned long long>(fr[k]); h *= 1099511628211ULL; }
    unsigned idx = static_cast<unsigned>(h) & (POLARON_NSITES - 1);
    for (unsigned probe = 0; probe < POLARON_NSITES; probe++) {
        unsigned i = (idx + probe) & (POLARON_NSITES - 1);
        if (g_sites[i].fr[0] == nullptr) {
            for (int k = 0; k < POLARON_NFR; k++) {
                g_sites[i].fr[k] = fr[k];
            }
            return static_cast<int>(i);
        }
        int same = 1;
        for (int k = 0; k < POLARON_NFR; k++) {
            if (g_sites[i].fr[k] != fr[k]) {
                same = 0;
                break;
            }
        }
        if (same) {
            return static_cast<int>(i);
        }
    }
    return 0;  // table full: dump into bucket 0
}
static void memsite_record(PolaronHdr* hdr) {
    static int clsFilter = -2;  // -2 = unread, -1 = all classes, >=0 = only that pool class
    if (clsFilter == -2) { const char* c = getenv("POLARON_MEMSITE_CLS"); clsFilter = c ? atoi(c) : -1; }
    if (clsFilter >= 0 && static_cast<int>(hdr->cls) != clsFilter) {
        return;  // e.g. POLARON_MEMSITE_CLS=1 -> 32 B Strings
    }
    void* fr[POLARON_NFR + 2];
    unsigned short n =
        RtlCaptureStackBackTrace(2, POLARON_NFR + 2, fr, nullptr);  // skip malloc + its wrapper
    void* key[POLARON_NFR];
    for (int k = 0; k < POLARON_NFR; k++) {
        key[k] = k < n ? fr[k] : nullptr;
    }
    int si = site_index(key);
    hdr->pad = static_cast<unsigned>(si);
    g_sites[si].live++;
    g_sites[si].total++;
}
static void memsite_release(PolaronHdr* hdr) {
    unsigned si = hdr->pad;
    if (si < POLARON_NSITES) {
        g_sites[si].live--;
    }
}
static void memsite_dump() {
    if (!g_memsite_on) {
        return;
    }
    char* base = reinterpret_cast<char*>(GetModuleHandleA(nullptr));
    fprintf(stderr, "[memsite] top leaking call-sites (live count, RVAs to symbolize):\n");
    for (int rank = 0; rank < 30; rank++) {
        long long best = 0; int bi = -1;
        for (unsigned i = 0; i < POLARON_NSITES; i++) {
            if (g_sites[i].live > best) { best = g_sites[i].live; bi = static_cast<int>(i); }
        }
        if (bi < 0) {
            break;
        }
        fprintf(stderr, "  live=%lld total=%lld  rva", best, g_sites[bi].total);
        for (int k = 0; k < POLARON_NFR; k++) {
            std::fprintf(stderr, " 0x%llx",
                         static_cast<unsigned long long>(static_cast<char*>(g_sites[bi].fr[k]) - base));
        }
        fprintf(stderr, "\n");
        g_sites[bi].live = -1;  // mark ranked so the next scan skips it
    }
    fflush(stderr);
}
#endif

static void __polaron_memprof_dump() {
    if (!g_prof_on) {
        return;
    }
    fprintf(stderr, "[memprof] FINAL live=%.1f MB count=%lld  totalAlloc=%lld totalFree=%lld\n",
            g_prof_live_bytes / 1048576.0, g_prof_live_count, g_prof_total_alloc, g_prof_total_free);
    for (int c = 0; c <= 32; c++) {
        long long n = g_prof_class_live[c];
        if (n <= 0) {
            continue;
        }
        if (c < 32) {
            fprintf(stderr, "  pool class %2d (<=%4d B): %lld live\n", c, (c + 1) * 16, n);
        } else {
            fprintf(stderr, "  large  (>512 B):        %lld live\n", n);
        }
    }
    fflush(stderr);
}

#ifdef POLARON_PROFILING
struct PolaronProfInit {
    PolaronProfInit() {
        const char* e = getenv("POLARON_MEMPROF");
        g_prof_on = (e != nullptr && e[0] != '\0' && e[0] != '0');
        if (g_prof_on) atexit(__polaron_memprof_dump);
#ifdef _WIN32
        const char* ms = getenv("POLARON_MEMSITE");
        g_memsite_on = (ms != nullptr && ms[0] != '\0' && ms[0] != '0');
        if (g_memsite_on) atexit(memsite_dump);
#endif
    }
};
static PolaronProfInit g_polaron_prof_init;
#endif

// ---- The heap: the shared core, backed by libc here ----
//
// The allocator itself is in polaron_alloc_core.hpp because NOTHING in it is about an operating
// system -- size classes, free lists, a bump slab and a sixteen-byte header are arithmetic. Only the
// block underneath is, and that is this class. The same header is compiled by `polaron build` over a
// static pool, so a WebAssembly module and a kernel get the same heap this program does, from the same
// source, instead of having none at all.
class PolaronHostedAllocBacking {
  public:
    static void* blockAlloc(unsigned long long bytes) {
        return std::malloc(static_cast<size_t>(bytes));
    }
    static void blockFree(void* p) { std::free(p); }
    // Hosted, a pointer the runtime did not hand out can still be a genuine libc block from an FFI
    // call, and libc knows what to do with it. A static pool does not, and says so by answering false.
    static bool forwardsForeign() { return true; }
    static void profileAlloc(PolaronHdr* h, unsigned long long bytes, unsigned cls) {
        if (g_prof_on) {
            prof_add(&g_prof_live_count, 1);
            prof_add(&g_prof_total_alloc, 1);
            prof_add(&g_prof_live_bytes, static_cast<long long>(bytes));
            prof_add(&g_prof_class_live[cls == POLARON_LARGE ? 32 : cls], 1);
        }
#ifdef _WIN32
        // Leak-by-site attribution: POOL blocks only. A large block uses its `pad` word for the size,
        // which is where a pool block stores the backtrace slot.
        if (g_memsite_on && cls != POLARON_LARGE) {
            memsite_record(h);
        }
#else
        (void)h;
#endif
    }
    static void profileFree(PolaronHdr* h, unsigned long long bytes, unsigned cls) {
        if (g_prof_on) {
            prof_add(&g_prof_live_count, -1);
            prof_add(&g_prof_total_free, 1);
            prof_add(&g_prof_live_bytes, -static_cast<long long>(bytes));
            prof_add(&g_prof_class_live[cls == POLARON_LARGE ? 32 : cls], -1);
        }
#ifdef _WIN32
        if (g_memsite_on && cls != POLARON_LARGE) {
            memsite_release(h);
        }
#else
        (void)h;
#endif
    }
    // One diagnostic line, on stderr like the panics: it is a fatal diagnostic and not program output,
    // and on stdout it lands in the middle of whatever the program was printing.
    static void report(const char* line) {
        std::fprintf(stderr, "Polaron: %s\n", line);
        std::fflush(stderr);
    }
};
#define POLARON_ALLOC_BACKEND PolaronHostedAllocBacking
#define POLARON_ALLOC_TLS thread_local
#define POLARON_ALLOC_API POLARON_RT_API
#define POLARON_ALLOC_CORE_IMPL
#include "polaron_alloc_core.hpp"

// The same defined, reported end for the two hosted allocators the core does not cover: `realloc`'s
// growth of a large block, and the region-class arena's commit. Says the size, which is the one fact
// worth having and the one a bare `std::bad_alloc` never carries.
static void __polaron_oom(size_t want) {
    char msg[256];
    std::snprintf(msg, sizeof msg,
                  "out of memory: could not allocate %.1f MB. The program asked for more than this "
                  "machine would give it -- allocate less at once, free what is finished with, or run "
                  "fewer of whatever is holding memory in parallel",
                  static_cast<double>(want) / 1048576.0);
    __polaron_panic(msg);
}

// (__polaron_malloc / __polaron_free / __polaron_check_live now come from polaron_alloc_core.hpp,
//  included just above with the libc backing. They moved because nothing in them was about an
//  operating system, and every target without a libc had no heap at all as a result.)

// ---- A CONTIGUOUS, COMMIT-ON-DEMAND ARENA: what a 32-bit object pointer requires ----
//
// A region class's arena is the one place a `A*` can be a 32-bit offset instead of a 64-bit pointer,
// because every A lives in that one region (see docs/design/region-classes.md). An offset is only
// total if there is ONE base to offset from -- and a `growable` region chains blocks (`growNext`), so
// two objects can sit at the same offset in different links. Chaining and narrow pointers are
// mutually exclusive.
//
// The way out is not to cap the arena but to RESERVE address space and commit it as it is used, which
// keeps "never traps, never moves" while there is only ever one base. Measured on this machine, and
// this is why malloc cannot do the job:
//
//     malloc(256 MiB)             -> private commit +257 MiB, immediately
//     VirtualAlloc(MEM_RESERVE)   -> private commit +0
//
// A reservation costs page-table bookkeeping and nothing else, so the arena can be declared far larger
// than any program will use. What is charged is what is touched.
#ifdef _WIN32
static void* polaronArenaReserve(unsigned long long bytes) {
    return VirtualAlloc(nullptr, static_cast<SIZE_T>(bytes), MEM_RESERVE, PAGE_READWRITE);
}
static bool polaronArenaCommit(void* base, unsigned long long bytes) {
    return VirtualAlloc(base, static_cast<SIZE_T>(bytes), MEM_COMMIT, PAGE_READWRITE) != nullptr;
}
static void polaronArenaRelease(void* base, unsigned long long) {
    VirtualFree(base, 0, MEM_RELEASE);
}
#else
static void* polaronArenaReserve(unsigned long long bytes) {
    // PROT_NONE says "address space, not memory": no backing is charged until mprotect makes a range
    // writable. MAP_NORESERVE additionally opts out of commit accounting -- a Linux extension rather
    // than portable POSIX, which is honest about what this branch is: the runtime already reads
    // /proc/self/exe in two places, so the non-Windows side is Linux and not a generic Unix. Guarded
    // anyway, so the day a third platform arrives it fails to run rather than failing to compile.
#ifdef MAP_NORESERVE
    constexpr int kReserveFlags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
#else
    constexpr int kReserveFlags = MAP_PRIVATE | MAP_ANONYMOUS;
#endif
    void* p = ::mmap(nullptr, static_cast<size_t>(bytes), PROT_NONE, kReserveFlags, -1, 0);
    return p == MAP_FAILED ? nullptr : p;
}
static bool polaronArenaCommit(void* base, unsigned long long bytes) {
    return ::mprotect(base, static_cast<size_t>(bytes), PROT_READ | PROT_WRITE) == 0;
}
static void polaronArenaRelease(void* base, unsigned long long bytes) {
    ::munmap(base, static_cast<size_t>(bytes));
}
#endif

// How much address space one region class reserves. 1 GiB is chosen against the 32-bit offset it
// exists to make possible: the offset is unsigned, so 4 GiB is the ceiling the representation allows,
// and a quarter of it leaves room to raise this without the representation changing meaning.
static const unsigned long long kPolaronArenaReserve = 1ull << 30;
// Committed in chunks rather than per allocation -- a commit is a kernel call, a bump is three
// instructions, and paying the former per object would undo the reason regions exist.
static const unsigned long long kPolaronArenaChunk = 1ull << 20;

// One region class's arena. `committed` is what may be written; `base` never moves, which is the whole
// point -- an object's address is `base + offset` for the life of the program.
struct PolaronArena {
    char*              base = nullptr;
    unsigned long long committed = 0;
    unsigned long long used = 0;
};

POLARON_RT_API void* __polaron_arena_reserve() {
    PolaronArena* a = static_cast<PolaronArena*>(__polaron_malloc(sizeof(PolaronArena)));
    a->base = static_cast<char*>(polaronArenaReserve(kPolaronArenaReserve));
    if (a->base == nullptr) {
        __polaron_panic("cannot reserve address space for a region class's arena");
    }
    a->committed = 0;
    // OFFSET ZERO IS NEVER HANDED OUT, so that a narrow pointer can spell null the way every other
    // pointer does. Losing the first 16 bytes of a gigabyte is the cheapest possible way to buy it.
    a->used = 16;
    return a;
}

// Bump `bytes` out of the arena, committing more address space when the cursor runs past what is
// committed. Returns the OFFSET from the base, not a pointer: the offset is the value the compiler
// stores in a narrow `A*`, and returning it here keeps the two sides from disagreeing about where
// zero is.
POLARON_RT_API unsigned long long __polaron_arena_alloc(void* arena, unsigned long long bytes) {
    PolaronArena* a = static_cast<PolaronArena*>(arena);
    const unsigned long long off = (a->used + 15ull) & ~15ull;   // 16-byte aligned, as the heap is
    const unsigned long long end = off + bytes;
    if (end > a->committed) {
        unsigned long long want = (end + kPolaronArenaChunk - 1) & ~(kPolaronArenaChunk - 1);
        if (want > kPolaronArenaReserve) {
            __polaron_panic("region class arena exhausted: its reservation is 1 GiB, which is also the "
                            "range a 32-bit object pointer can address -- hold fewer instances alive, "
                            "or delete what is finished with");
        }
        if (!polaronArenaCommit(a->base, want)) {
            __polaron_oom(static_cast<size_t>(want - a->committed));
        }
        a->committed = want;
    }
    a->used = end;
    return off;
}

POLARON_RT_API void* __polaron_arena_base(void* arena) {
    return static_cast<PolaronArena*>(arena)->base;
}

POLARON_RT_API void __polaron_arena_free(void* arena) {
    PolaronArena* a = static_cast<PolaronArena*>(arena);
    if (a == nullptr) {
        return;
    }
    if (a->base != nullptr) {
        polaronArenaRelease(a->base, kPolaronArenaReserve);
    }
    a->base = nullptr;
    a->committed = 0;
    a->used = 16;
    __polaron_free(a);
}

// Region backing-memory cache (hosted). A region's data block is often multi-megabyte, which libc
// serves with mmap and reclaims with munmap -- plus the kernel zero-fills every page on first touch.
// A hot `allocate ... release` loop (Polaron's arena idiom) pays that OS round-trip every iteration, which
// dominates while the bump allocation itself is nearly free. Releasing a region keeps its block for the
// next same-size allocate on this thread, turning the round-trip into an O(1) pointer swap. Thread-local
// so it needs no lock (the LARGE blocks it caches are plain libc allocations, safe on any thread), and
// bounded so it never hoards memory.
#define POLARON_REGION_CACHE 8
struct PolaronRegionSlot {
    void* ptr;
    unsigned long long total;
};
static thread_local PolaronRegionSlot g_polaron_region_cache[POLARON_REGION_CACHE];
static thread_local int g_polaron_region_n;

void* __polaron_region_acquire(unsigned long long total) {
    for (int i = 0; i < g_polaron_region_n; i++) {
        if (g_polaron_region_cache[i].total == total) {  // reuse a released block of exactly this size
            void* p = g_polaron_region_cache[i].ptr;
            g_polaron_region_cache[i] = g_polaron_region_cache[--g_polaron_region_n];
            return p;
        }
    }
    return __polaron_malloc(static_cast<size_t>(total));
}

void __polaron_region_release(void* block) {
    if (block == nullptr) {
        return;  // an unallocated (empty-state) or already-released region
    }
    // The header is [i64 used][i64 cap][ptr dataBase]. An owned region bump-allocates its data just past
    // the 24-byte header (dataBase == block+24); an `at`-address region's data lives at a fixed external
    // address, so only its tiny header is ours -- never cache it (its cap is the external size, not the
    // block size), just free the header.
    unsigned long long cap = *reinterpret_cast<unsigned long long*>((static_cast<char*>(block) + 8));
    void* dbase = *reinterpret_cast<void**>((static_cast<char*>(block) + 16));
    if (dbase != static_cast<void*>((static_cast<char*>(block) + 24))) {
        __polaron_free(block);
        return;
    }
    if (g_polaron_region_n < POLARON_REGION_CACHE) {
        g_polaron_region_cache[g_polaron_region_n].ptr = block;
        g_polaron_region_cache[g_polaron_region_n].total = cap + 24;
        g_polaron_region_n++;
        return;
    }
    __polaron_free(block);
}

// ---- Flavored regions (spec 17): the shared core, backed by this runtime's allocator ----
// The implementation lives in polaron_region_core.hpp because `polaron build` compiles that same file for
// bare metal. Only the backing differs, and it differs here, in this one class. Including it in THIS
// translation unit (rather than linking a separate object) keeps every call site visible to the
// optimizer exactly as it was when these bodies sat inline in this file.
class PolaronHostedRegionBacking {
  public:
    static void* blockAlloc(unsigned long long bytes) {
        return __polaron_malloc(static_cast<size_t>(bytes));
    }
    static void blockFree(void* p) { __polaron_free(p); }
    // The registry arrays are small metadata that must not come out of the region itself, and libc's
    // realloc already grows them in place when it can -- so the old size is not needed here.
    static void* metaAlloc(void* p, unsigned long long, unsigned long long newBytes) {
        return std::realloc(p, static_cast<size_t>(newBytes));
    }
    static void metaFree(void* p, unsigned long long) { std::free(p); }
    static void profileAlloc() {
        if (g_prof_on) {
            prof_add(&g_prof_total_alloc, 1);
        }
    }
    static void profileFree() {
        if (g_prof_on) {
            prof_add(&g_prof_total_free, 1);
        }
    }
};
#define POLARON_REGION_BACKEND PolaronHostedRegionBacking
#define POLARON_REGION_CORE_IMPL
#include "polaron_region_core.hpp"

POLARON_RT_API void* __polaron_realloc(void* ptr, size_t size) {
    if (ptr == nullptr) {
        return __polaron_malloc(size);
    }
    PolaronHdr* h = reinterpret_cast<PolaronHdr*>((static_cast<char*>(ptr) - 16));
    if (h->magic != POLARON_MAGIC) {
        return std::realloc(ptr, size);  // foreign pointer
    }
    if (h->cls == POLARON_LARGE) {
        long long oldsz = static_cast<long long>(h->pad);
        char* np = static_cast<char*>(std::realloc(h, size + 16));
        if (np == nullptr) {
            __polaron_oom(size);
        }
        (reinterpret_cast<PolaronHdr*>(np))->magic = POLARON_MAGIC;
        (reinterpret_cast<PolaronHdr*>(np))->cls = POLARON_LARGE;
        (reinterpret_cast<PolaronHdr*>(np))->pad = static_cast<unsigned>(size);
        if (g_prof_on) { prof_add(&g_prof_live_bytes, static_cast<long long>(size) - oldsz); }
        return np + 16;
    }
    size_t oldsz = static_cast<size_t>((h->cls + 1)) * 16;
    if (size <= oldsz) {
        return ptr;  // still fits the current class
    }
    void* np = __polaron_malloc(size);  // panics on exhaustion; never nullptr
    memcpy(np, ptr, oldsz);
    __polaron_free(ptr);
    return np;
}

// Formats a Decimal (spec 34) into buf and returns its length. The compiler precomputes the sign, the
// integer part and the 18-digit fraction via 128-bit division, so this only assembles them (no 128-bit
// math -- MSVC has no __int128) and trims trailing zeros from the fraction for a clean "1.8" over
// "1.800000000000000000". buf must hold at least 64 bytes.
long long __polaron_decimal_str(int neg, long long intPart, unsigned long long frac, char* buf) {
    char frac18[18];
    for (int i = 17; i >= 0; --i) { frac18[i] = static_cast<char>(('0' + static_cast<int>((frac % 10)))); frac /= 10; }
    int flen = 18;
    while (flen > 0 && frac18[flen - 1] == '0') {
        --flen;  // trim trailing zeros
    }
    char* p = buf;
    if (neg) {
        *p++ = '-';
    }
    char tmp[24];
    int ti = 0;
    if (intPart == 0) {
        tmp[ti++] = '0';
    } else {
        long long x = intPart;
        while (x > 0) { tmp[ti++] = static_cast<char>(('0' + static_cast<int>((x % 10)))); x /= 10; }
    }
    while (ti > 0) {
        *p++ = tmp[--ti];
    }
    if (flen > 0) {
        *p++ = '.';
        for (int i = 0; i < flen; ++i) {
            *p++ = frac18[i];
        }
    }
    return static_cast<long long>((p - buf));
}

// Index-keyed persistent registry (spec 18.5): the in-process store behind `arr[i] = new T()`
// reattach. Each (key, index) pair maps to one zeroed persistent block that survives delete within a
// run, so the same slot returns the same block and its persistent fields reattach across delete +
// recreate. `key` is a static string constant emitted by the compiler (lives for the whole run).
// Open-addressing hash table over (key, index) -> block. The old singly-linked list walked every node
// with a strcmp per lookup, so creating N persistent slots (arr[i] = new T() for i in 0..N) was O(N^2)
// -- 20k slots took ~1.2s. Hashing makes each lookup O(1) amortized.
struct PolaronPSlot {
    const char* key;  // nullptr = empty slot
    long long index;
    void* block;
    // Keyed persistents (docs/design/persistent-keys.md): the identity as SERIALISED BYTES, owned by the
    // registry. Bytes rather than the key object because the registry outlives the object that supplied
    // it -- a stored pointer would dangle, and a stored copy would still dangle through its own pointer
    // fields, since a Polaron copy is one level deep. A null here means the older (array-slot) form,
    // which matches on `index` instead.
    unsigned char* keyBytes;
    long long keyLen;
};
static PolaronPSlot* g_polaron_pslots = nullptr;
static long long g_polaron_pslots_cap = 0;    // power of two, or 0 before first insert
static long long g_polaron_pslots_count = 0;

static unsigned long long __polaron_pslot_hash(const char* key, long long index) {
    unsigned long long h = 1469598103934665603ULL;  // FNV-1a over the key string, then the index
    for (const char* p = key; *p != '\0'; ++p) {
        h ^= static_cast<unsigned long long>(static_cast<unsigned char>(*p));
        h *= 1099511628211ULL;
    }
    h ^= static_cast<unsigned long long>(index);
    h *= 1099511628211ULL;
    return h;
}
static void __polaron_pslots_grow(void) {
    long long oldCap = g_polaron_pslots_cap;
    PolaronPSlot* old = g_polaron_pslots;
    long long newCap = oldCap ? oldCap * 2 : 64;
    PolaronPSlot* ns = static_cast<PolaronPSlot*>(std::calloc(static_cast<size_t>(newCap), sizeof(PolaronPSlot)));
    if (ns == nullptr) {
        __polaron_panic("out of memory in persistent registry");
    }
    long long mask = newCap - 1;
    for (long long i = 0; i < oldCap; ++i) {
        if (old[i].key == nullptr) {
            continue;
        }
        long long j = static_cast<long long>((__polaron_pslot_hash(old[i].key, old[i].index) & static_cast<unsigned long long>(mask)));
        while (ns[j].key != nullptr) {
            j = (j + 1) & mask;
        }
        ns[j] = old[i];
    }
    std::free(old);
    g_polaron_pslots = ns;
    g_polaron_pslots_cap = newCap;
}
void* __polaron_persist_slot(const char* key, long long index, long long size) {
    if (g_polaron_pslots_cap == 0 || g_polaron_pslots_count * 4 >= g_polaron_pslots_cap * 3) {
        __polaron_pslots_grow();  // keep load factor under 0.75
    }
    long long mask = g_polaron_pslots_cap - 1;
    long long j = static_cast<long long>((__polaron_pslot_hash(key, index) & static_cast<unsigned long long>(mask)));
    while (g_polaron_pslots[j].key != nullptr) {
        // key is a per-array static constant, so the pointer usually matches; strcmp is the fallback.
        if (g_polaron_pslots[j].index == index &&
            (g_polaron_pslots[j].key == key || strcmp(g_polaron_pslots[j].key, key) == 0)) {
            return g_polaron_pslots[j].block;
        }
        j = (j + 1) & mask;
    }
    void* block = std::calloc(1, static_cast<size_t>(size));
    g_polaron_pslots[j].key = key;
    g_polaron_pslots[j].index = index;
    g_polaron_pslots[j].block = block;
    g_polaron_pslots[j].keyBytes = nullptr;
    g_polaron_pslots[j].keyLen = 0;
    ++g_polaron_pslots_count;
    return block;
}

// -- Keyed persistents ------------------------------------------------------------------------------
// The block for one IDENTITY rather than one source location: `keyBytes` is the declaring class's key
// fields serialised in declaration order (docs/design/persistent-keys.md). The hash picks the bucket;
// the BYTES decide the match, so two identities that collide never merge -- silently sharing state on a
// hash collision would be the exact failure this design exists to avoid, in a feature about state.
static unsigned long long __polaron_pkey_hash(const char* cls, const unsigned char* kb, long long n) {
    unsigned long long h = 1469598103934665603ULL;
    for (const char* p = cls; *p != '\0'; ++p) { h ^= static_cast<unsigned char>(*p); h *= 1099511628211ULL; }
    for (long long i = 0; i < n; ++i) { h ^= kb[i]; h *= 1099511628211ULL; }
    return h;
}
static int __polaron_pslot_matches(const PolaronPSlot* s, const char* cls, const unsigned char* kb, long long n) {
    if (s->keyBytes == nullptr || s->keyLen != n) {
        return 0;
    }
    if (!(s->key == cls || strcmp(s->key, cls) == 0)) {
        return 0;  // two classes may share key bytes
    }
    return memcmp(s->keyBytes, kb, static_cast<size_t>(n)) == 0;
}
void* __polaron_persist_slot_keyed(const char* cls, const unsigned char* keyBytes, long long keyLen,
                                long long size, const void* initial) {
    if (g_polaron_pslots_cap == 0 || g_polaron_pslots_count * 4 >= g_polaron_pslots_cap * 3) {
        __polaron_pslots_grow();
    }
    long long mask = g_polaron_pslots_cap - 1;
    long long j = static_cast<long long>((__polaron_pkey_hash(cls, keyBytes, keyLen) & static_cast<unsigned long long>(mask)));
    while (g_polaron_pslots[j].key != nullptr) {
        if (__polaron_pslot_matches(&g_polaron_pslots[j], cls, keyBytes, keyLen)) {
            return g_polaron_pslots[j].block;
        }
        j = (j + 1) & mask;
    }
    // The registry OWNS its copy of the key: the object that supplied it may be gone before the next
    // lookup, and the caller's buffer is a temporary.
    unsigned char* owned = static_cast<unsigned char*>(std::malloc(static_cast<size_t>((keyLen > 0 ? keyLen : 1))));
    if (owned == nullptr) {
        __polaron_panic("out of memory in persistent registry");
    }
    memcpy(owned, keyBytes, static_cast<size_t>(keyLen));
    // A FIRST attach starts from what the constructor wrote; a reattach never reaches here and keeps what
    // it accumulated. That is what makes "write it in the constructor" mean initial values.
    void* block = std::calloc(1, static_cast<size_t>(size));
    if (initial != nullptr && block != nullptr) {
        memcpy(block, initial, static_cast<size_t>(size));
    }
    g_polaron_pslots[j].key = cls;
    g_polaron_pslots[j].index = 0;
    g_polaron_pslots[j].block = block;
    g_polaron_pslots[j].keyBytes = owned;
    g_polaron_pslots[j].keyLen = keyLen;
    ++g_polaron_pslots_count;
    return block;
}
// `release s.hits;` -- discard what THIS identity accumulated. The block is zeroed rather than freed, so
// a later reattach starts from zero exactly as the first attach did; the entry itself stays, because a
// stable address across reattach is what a named persistent is for.
void __polaron_persist_release_keyed(const char* cls, const unsigned char* keyBytes, long long keyLen,
                                  long long size) {
    if (g_polaron_pslots_cap == 0) {
        return;
    }
    long long mask = g_polaron_pslots_cap - 1;
    long long j = static_cast<long long>((__polaron_pkey_hash(cls, keyBytes, keyLen) & static_cast<unsigned long long>(mask)));
    while (g_polaron_pslots[j].key != nullptr) {
        if (__polaron_pslot_matches(&g_polaron_pslots[j], cls, keyBytes, keyLen)) {
            memset(g_polaron_pslots[j].block, 0, static_cast<size_t>(size));
            return;
        }
        j = (j + 1) & mask;
    }
}
// `release Session.hits all;` -- every identity the field ever had. Without this a program could only
// release the identities it still happened to be holding, which is a leak with extra steps.
//
// ONE field, given as its byte offset and width in the block -- not the whole block. Zeroing everything
// would make `release C.a all` silently discard `C.b` and `C.c` too, which is the same defect the narrow
// form had: a statement that names a field and then wipes its siblings.
void __polaron_persist_release_all(const char* cls, long long off, long long width) {
    for (long long i = 0; i < g_polaron_pslots_cap; ++i) {
        PolaronPSlot* s = &g_polaron_pslots[i];
        if (s->key == nullptr || s->keyBytes == nullptr) {
            continue;
        }
        if (s->key == cls || strcmp(s->key, cls) == 0) {
            memset(static_cast<unsigned char*>(s->block) + off, 0, static_cast<size_t>(width));
        }
    }
}

// Pointer visited-set for `cascade` cycle detection (spec 37.1, rule 2). A small open-
// addressing hash set over object addresses: add() returns 1 the first time a pointer is
// seen and 0 afterwards, so a cascade walk skips objects it already processed (and so never
// loops on a cyclic object graph).
struct polaron_ptrset {
    void** slots;     // hash table; nullptr slot = empty
    long long cap;    // power of two, or 0 before first insert
    long long count;
};

static void __polaron_ptrset_grow(polaron_ptrset* s) {
    long long oldCap = s->cap;
    void** old = s->slots;
    long long newCap = oldCap ? oldCap * 2 : 64;
    void** ns = static_cast<void**>(std::calloc(static_cast<size_t>(newCap), sizeof(void*)));
    if (ns == nullptr) {
        __polaron_panic("out of memory in cascade visited-set");
    }
    long long mask = newCap - 1;
    for (long long i = 0; i < oldCap; i++) {
        if (old[i] != nullptr) {
            unsigned long long h = static_cast<unsigned long long>(reinterpret_cast<std::uintptr_t>(old[i])) * 1099511628211ULL;
            long long idx = static_cast<long long>((h & static_cast<unsigned long long>(mask)));
            while (ns[idx] != nullptr) {
                idx = (idx + 1) & mask;
            }
            ns[idx] = old[i];
        }
    }
    s->slots = ns;
    s->cap = newCap;
    std::free(old);
}

polaron_ptrset* __polaron_ptrset_new(void) {
    polaron_ptrset* s = static_cast<polaron_ptrset*>(std::malloc(sizeof(polaron_ptrset)));
    if (s == nullptr) {
        __polaron_panic("out of memory in cascade visited-set");
    }
    s->slots = nullptr;
    s->cap = 0;
    s->count = 0;
    return s;
}

void __polaron_ptrset_free(polaron_ptrset* s) {
    if (s == nullptr) {
        return;
    }
    std::free(s->slots);
    std::free(s);
}

// Returns 1 if `p` was newly added, 0 if already present. A nullptr set or pointer counts as seen.
int __polaron_ptrset_add(polaron_ptrset* s, void* p) {
    if (s == nullptr || p == nullptr) {
        return 0;
    }
    if ((s->count + 1) * 4 >= s->cap * 3) {
        __polaron_ptrset_grow(s);
    }
    unsigned long long h = static_cast<unsigned long long>(reinterpret_cast<std::uintptr_t>(p)) * 1099511628211ULL;
    long long mask = s->cap - 1;
    long long idx = static_cast<long long>((h & static_cast<unsigned long long>(mask)));
    while (s->slots[idx] != nullptr) {
        if (s->slots[idx] == p) {
            return 0;  // already visited
        }
        idx = (idx + 1) & mask;
    }
    s->slots[idx] = p;
    s->count++;
    return 1;
}

// Pointer-to-pointer map for `cascade clone` (spec 37.1): maps each original object to its clone
// so a shared or cyclic owned graph is cloned once and the clone preserves the same sharing.
struct polaron_ptrmap {
    void** keys;   // hash table; nullptr key = empty
    void** vals;
    long long cap;
    long long count;
};

static void __polaron_ptrmap_grow(polaron_ptrmap* m) {
    long long oldCap = m->cap;
    void** ok = m->keys;
    void** ov = m->vals;
    long long newCap = oldCap ? oldCap * 2 : 64;
    void** nk = static_cast<void**>(std::calloc(static_cast<size_t>(newCap), sizeof(void*)));
    void** nv = static_cast<void**>(std::calloc(static_cast<size_t>(newCap), sizeof(void*)));
    if (nk == nullptr || nv == nullptr) {
        __polaron_panic("out of memory in cascade clone map");
    }
    long long mask = newCap - 1;
    for (long long i = 0; i < oldCap; i++) {
        if (ok[i] != nullptr) {
            unsigned long long h = static_cast<unsigned long long>(reinterpret_cast<std::uintptr_t>(ok[i])) * 1099511628211ULL;
            long long idx = static_cast<long long>((h & static_cast<unsigned long long>(mask)));
            while (nk[idx] != nullptr) {
                idx = (idx + 1) & mask;
            }
            nk[idx] = ok[i];
            nv[idx] = ov[i];
        }
    }
    m->keys = nk;
    m->vals = nv;
    m->cap = newCap;
    std::free(ok);
    std::free(ov);
}

polaron_ptrmap* __polaron_ptrmap_new(void) {
    polaron_ptrmap* m = static_cast<polaron_ptrmap*>(std::malloc(sizeof(polaron_ptrmap)));
    if (m == nullptr) {
        __polaron_panic("out of memory in cascade clone map");
    }
    m->keys = nullptr;
    m->vals = nullptr;
    m->cap = 0;
    m->count = 0;
    return m;
}

void __polaron_ptrmap_free(polaron_ptrmap* m) {
    if (m == nullptr) {
        return;
    }
    std::free(m->keys);
    std::free(m->vals);
    std::free(m);
}

void* __polaron_ptrmap_get(polaron_ptrmap* m, void* key) {
    if (m == nullptr || key == nullptr || m->cap == 0) {
        return nullptr;
    }
    unsigned long long h = static_cast<unsigned long long>(reinterpret_cast<std::uintptr_t>(key)) * 1099511628211ULL;
    long long mask = m->cap - 1;
    long long idx = static_cast<long long>((h & static_cast<unsigned long long>(mask)));
    while (m->keys[idx] != nullptr) {
        if (m->keys[idx] == key) {
            return m->vals[idx];
        }
        idx = (idx + 1) & mask;
    }
    return nullptr;
}

void __polaron_ptrmap_put(polaron_ptrmap* m, void* key, void* val) {
    if (m == nullptr || key == nullptr) {
        return;
    }
    if ((m->count + 1) * 4 >= m->cap * 3) {
        __polaron_ptrmap_grow(m);
    }
    unsigned long long h = static_cast<unsigned long long>(reinterpret_cast<std::uintptr_t>(key)) * 1099511628211ULL;
    long long mask = m->cap - 1;
    long long idx = static_cast<long long>((h & static_cast<unsigned long long>(mask)));
    while (m->keys[idx] != nullptr) {
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
static DWORD WINAPI __polaron_thread_trampoline(LPVOID closure) {
    void** c = static_cast<void**>(closure);
    void (*code)(void*) = (void (*)(void*))c[0];
    code(c[1]);
    return 0;
}

long long __polaron_thread_spawn(void* closure) {
    HANDLE h = CreateThread(nullptr, 0, __polaron_thread_trampoline, closure, 0, nullptr);
    return reinterpret_cast<long long>(h);
}

void __polaron_thread_join(long long handle) {
    WaitForSingleObject(reinterpret_cast<HANDLE>(handle), INFINITE);
    CloseHandle(reinterpret_cast<HANDLE>(handle));
}
#else
static void* __polaron_thread_trampoline(void* closure) {
    void** c = static_cast<void**>(closure);
    void (*code)(void*) = (void (*)(void*))c[0];
    code(c[1]);
    return nullptr;
}

// The handle is a heap pthread_t (opaque and possibly wider than a register on some libcs).
long long __polaron_thread_spawn(void* closure) {
    pthread_t* t = static_cast<pthread_t*>(std::malloc(sizeof(pthread_t)));
    if (t == nullptr || pthread_create(t, nullptr, __polaron_thread_trampoline, closure) != 0) {
        std::free(t);
        return 0;
    }
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(t));
}

void __polaron_thread_join(long long handle) {
    pthread_t* t = reinterpret_cast<pthread_t*>(handle);
    if (t == nullptr) return;
    pthread_join(*t, nullptr);
    std::free(t);
}
#endif

// Mutex (spec 20.5): a heap CRITICAL_SECTION whose pointer the Mutex<T> object stores as an
// int64. create/acquire/release back the `synchronized` statement.
long long __polaron_lock_create(void) {
    CRITICAL_SECTION* cs = static_cast<CRITICAL_SECTION*>(std::malloc(sizeof(CRITICAL_SECTION)));
    if (cs != nullptr) {
        InitializeCriticalSection(cs);
    }
    return reinterpret_cast<long long>(cs);
}
void __polaron_lock_acquire(long long h) {
    if (h != 0) {
        EnterCriticalSection(reinterpret_cast<CRITICAL_SECTION*>(h));
    }
}
void __polaron_lock_release(long long h) {
    if (h != 0) {
        LeaveCriticalSection(reinterpret_cast<CRITICAL_SECTION*>(h));
    }
}

// Process-wide mutex guarding `lazy` initialization (spec 37.3: lazy is thread-safe by default).
// A double-checked guard in the generated code takes this lock only on the first initialization,
// so concurrent first-accesses initialize a lazy value exactly once.
#ifdef _WIN32
static CRITICAL_SECTION __polaron_lazy_cs;
static INIT_ONCE __polaron_lazy_once = INIT_ONCE_STATIC_INIT;
static BOOL CALLBACK __polaron_lazy_init_cb(PINIT_ONCE o, PVOID p, PVOID* c) {
    static_cast<void>(o);
    static_cast<void>(p);
    static_cast<void>(c);
    InitializeCriticalSection(&__polaron_lazy_cs);
    return TRUE;
}
void __polaron_lazy_lock(void) {
    InitOnceExecuteOnce(&__polaron_lazy_once, __polaron_lazy_init_cb, nullptr, nullptr);
    EnterCriticalSection(&__polaron_lazy_cs);
}
void __polaron_lazy_unlock(void) { LeaveCriticalSection(&__polaron_lazy_cs); }
#else
static pthread_mutex_t __polaron_lazy_cs = PTHREAD_MUTEX_INITIALIZER;  // static init: no once dance
void __polaron_lazy_lock(void) { pthread_mutex_lock(&__polaron_lazy_cs); }
void __polaron_lazy_unlock(void) { pthread_mutex_unlock(&__polaron_lazy_cs); }
#endif

// ---- async/await: tasks + worker pool (spec 20.2) -----------------------------------------
// A task is the handle to an async computation. `resume`/`state` are the state machine to run;
// A task's continuations: every awaiter suspended on it. A LIST, not one slot -- several async methods
// may await the same task, and each must be resumed when it completes (a single slot let the last
// awaiter clobber the others, so all but one deadlocked).
using polaron_resume_fn = void (*)(void* state);
struct polaron_waiter {
    polaron_resume_fn fn;
    void* state;
    polaron_waiter* next;
};
struct polaron_task {
    volatile long done;
    long long result;
    polaron_waiter* waiters;  // continuations to schedule on completion (LIFO; order among them is free)
    long long error;       // an exception carrier (object ptr) if the async body threw; 0 otherwise
};

// Ready queue of (resume, state) pairs run by a fixed pool of worker threads.
struct polaron_work { polaron_resume_fn fn; void* state; };
#define POLARON_QCAP 65536
static polaron_work g_queue[POLARON_QCAP];
static long g_qhead = 0, g_qtail = 0;
static CRITICAL_SECTION g_qlock;
static CONDITION_VARIABLE g_qcond;   // signalled when work is enqueued
static CONDITION_VARIABLE g_donecond;  // signalled when any task completes (for __polaron_task_wait)
static int g_pool_started = 0;

static void __polaron_worker_body(void) {
    for (;;) {
        EnterCriticalSection(&g_qlock);
        while (g_qhead == g_qtail) {
            SleepConditionVariableCS(&g_qcond, &g_qlock, INFINITE);
        }
        polaron_work w = g_queue[g_qhead];
        g_qhead = (g_qhead + 1) % POLARON_QCAP;
        LeaveCriticalSection(&g_qlock);
        w.fn(w.state);  // resume the state machine; it may complete or re-suspend the task
    }
}

#ifdef _WIN32
static DWORD WINAPI __polaron_worker(LPVOID unused) {
    static_cast<void>(unused);
    __polaron_worker_body();
    return 0;
}
static int __polaron_cpu_count(void) {
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    return static_cast<int>(si.dwNumberOfProcessors);
}
static void __polaron_spawn_worker(void) {
    CloseHandle(CreateThread(nullptr, 0, __polaron_worker, nullptr, 0, nullptr));
}
#else
static void* __polaron_worker(void* unused) {
    static_cast<void>(unused);
    __polaron_worker_body();
    return nullptr;
}
static int __polaron_cpu_count() { return static_cast<int>(sysconf(_SC_NPROCESSORS_ONLN)); }
static void __polaron_spawn_worker(void) {
    pthread_t t;
    if (pthread_create(&t, nullptr, __polaron_worker, nullptr) == 0) pthread_detach(t);
}
#endif

static void __polaron_pool_start(void) {
    if (g_pool_started) {
        return;
    }
    g_pool_started = 1;
    InitializeCriticalSection(&g_qlock);
    InitializeConditionVariable(&g_qcond);
    InitializeConditionVariable(&g_donecond);
    int n = __polaron_cpu_count();
    if (n < 2) {
        n = 2;
    }
    if (n > 16) {
        n = 16;
    }
    for (int i = 0; i < n; i++) {
        __polaron_spawn_worker();
    }
}

void __polaron_schedule(polaron_resume_fn fn, void* state) {
    __polaron_pool_start();
    EnterCriticalSection(&g_qlock);
    g_queue[g_qtail] = polaron_work{fn, state};  // C++ braced temporary (not a C compound literal)
    g_qtail = (g_qtail + 1) % POLARON_QCAP;
    LeaveCriticalSection(&g_qlock);
    WakeConditionVariable(&g_qcond);
}

long long __polaron_task_new(void) {
    polaron_task* t = static_cast<polaron_task*>(std::calloc(1, sizeof(polaron_task)));
    return reinterpret_cast<long long>(t);
}

// Detach the waiter list under the lock, then (outside it) schedule and free every continuation.
// Shared by the value and error completion paths, so all awaiters are resumed exactly once.
static void __polaron_task_wake(polaron_task* t) {
    EnterCriticalSection(&g_qlock);
    t->done = 1;
    polaron_waiter* w = t->waiters;
    t->waiters = nullptr;
    LeaveCriticalSection(&g_qlock);
    while (w != nullptr) {
        polaron_waiter* next = w->next;
        __polaron_schedule(w->fn, w->state);
        std::free(w);
        w = next;
    }
    WakeAllConditionVariable(&g_donecond);
}

// Called by an async body when it produces its value: record the result, mark done, and
// schedule every continuation (each task that awaited this one).
void __polaron_task_complete(long long handle, long long value) {
    polaron_task* t = reinterpret_cast<polaron_task*>(handle);
    if (t == nullptr) {
        return;
    }
    t->result = value;
    __polaron_task_wake(t);
}

long long __polaron_task_result(long long handle) {
    polaron_task* t = reinterpret_cast<polaron_task*>(handle);
    return t != nullptr ? t->result : 0;
}

// Called when an async body throws instead of producing a value: record the exception carrier, mark
// done, and schedule the waiter -- which will re-throw it (spec 21: the exception surfaces at the await).
void __polaron_task_complete_error(long long handle, long long carrier) {
    polaron_task* t = reinterpret_cast<polaron_task*>(handle);
    if (t == nullptr) {
        return;
    }
    t->error = carrier;
    __polaron_task_wake(t);
}

// The exception carrier a completed task failed with, or 0 if it produced a value normally.
long long __polaron_task_error(long long handle) {
    polaron_task* t = reinterpret_cast<polaron_task*>(handle);
    return t != nullptr ? t->error : 0;
}

// await from inside an async state machine: if the awaited task is already done, return 0 so
// the caller falls through and reads the result; otherwise register the caller's continuation
// and return 1 so the caller suspends (returns from its resume function).
int __polaron_await(long long awaited, polaron_resume_fn resume, void* state) {
    polaron_task* a = reinterpret_cast<polaron_task*>(awaited);
    if (a == nullptr) {
        return 0;
    }
    if (a->done) {
        return 0;  // synchronous fast path: a done task never un-dones, so skip the lock
    }
    polaron_waiter* w = static_cast<polaron_waiter*>(std::malloc(sizeof(polaron_waiter)));
    if (w == nullptr) {
        return 0;  // out of memory: fall through and read the (possibly not-yet-ready) result
    }
    w->fn = resume;
    w->state = state;
    EnterCriticalSection(&g_qlock);
    if (a->done) { LeaveCriticalSection(&g_qlock); std::free(w); return 0; }
    w->next = a->waiters;  // push onto the waiter list (several awaiters may suspend on one task)
    a->waiters = w;
    LeaveCriticalSection(&g_qlock);
    return 1;
}

// ---- Channels: bounded blocking queue (spec 20.3) -----------------------------------------
// send blocks while full, receive blocks while empty; values are passed as 64-bit slots (an
// int or a pointer). One lock plus a not-full / not-empty condition variable.
struct polaron_chan {
    long long* buf;
    long long cap, count, head, tail;
    CRITICAL_SECTION lock;
    CONDITION_VARIABLE notFull, notEmpty;
};

long long __polaron_chan_new(long long cap) {
    if (cap < 1) {
        cap = 1;
    }
    polaron_chan* c = static_cast<polaron_chan*>(std::malloc(sizeof(polaron_chan)));
    if (c == nullptr) {
        return 0;
    }
    c->buf = static_cast<long long*>(std::malloc(sizeof(long long) * static_cast<std::size_t>(cap)));
    c->cap = cap;
    c->count = 0;
    c->head = 0;
    c->tail = 0;
    InitializeCriticalSection(&c->lock);
    InitializeConditionVariable(&c->notFull);
    InitializeConditionVariable(&c->notEmpty);
    return reinterpret_cast<long long>(c);
}

void __polaron_chan_send(long long handle, long long value) {
    polaron_chan* c = reinterpret_cast<polaron_chan*>(handle);
    if (c == nullptr) {
        return;
    }
    EnterCriticalSection(&c->lock);
    while (c->count == c->cap) {
        SleepConditionVariableCS(&c->notFull, &c->lock, INFINITE);
    }
    c->buf[c->tail] = value;
    c->tail = (c->tail + 1) % c->cap;
    c->count++;
    LeaveCriticalSection(&c->lock);
    WakeConditionVariable(&c->notEmpty);
}

long long __polaron_chan_receive(long long handle) {
    polaron_chan* c = reinterpret_cast<polaron_chan*>(handle);
    if (c == nullptr) {
        return 0;
    }
    EnterCriticalSection(&c->lock);
    while (c->count == 0) {
        SleepConditionVariableCS(&c->notEmpty, &c->lock, INFINITE);
    }
    long long v = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->count--;
    LeaveCriticalSection(&c->lock);
    WakeConditionVariable(&c->notFull);
    return v;
}

// Non-blocking receive for Channel.select (spec 20.4): if a value is ready, store it in *out and
// return 1; otherwise return 0 immediately.
int __polaron_chan_try_receive(long long handle, long long* out) {
    polaron_chan* c = reinterpret_cast<polaron_chan*>(handle);
    if (c == nullptr) {
        return 0;
    }
    EnterCriticalSection(&c->lock);
    if (c->count == 0) { LeaveCriticalSection(&c->lock); return 0; }
    *out = c->buf[c->head];
    c->head = (c->head + 1) % c->cap;
    c->count--;
    LeaveCriticalSection(&c->lock);
    WakeConditionVariable(&c->notFull);
    return 1;
}

// THE SAME COUNT, TO A PROGRAM (spec 20), behind System.Os.Machine.threads().
//
// The async pool above has always asked the machine how many threads it will run at once. A program
// written in the language could not, which left every worker pool anybody writes holding a number
// somebody guessed -- right on the desk it was written at, leaving three quarters of a big machine
// idle, and oversubscribing a small one into being slower than one thread. Never less than one:
// a program is going to divide by it.
extern "C" int __polaron_machine_threads(void) {
    const int n = __polaron_cpu_count();
    return n > 0 ? n : 1;
}

#ifdef _WIN32
long long __polaron_now_ms(void) { return (long long)GetTickCount64(); }
void __polaron_yield(void) { Sleep(0); }  // hand off the rest of the time slice while polling

// GIVE UP THE REST OF THIS THREAD'S TURN (spec 20), behind System.Concurrency.Thread.yieldNow().
//
// The missing half of every spin-wait. A thread that spins on an atomic and never yields is fast
// while there is a free core for it and catastrophic the moment there is not: it holds a core that
// the thread it is waiting for needs, and the operating system has to preempt it to make progress.
// Measured in a game whose crew was opened with one hand per hardware thread -- the frame went from
// 15 to 102 microseconds an animal, seven times WORSE than one thread, because the renderer and the
// worker it was waiting on were fighting spinners for the machine.
//
// SwitchToThread AND NOT Sleep(0), which is what `__polaron_yield` above uses: Sleep(0) yields only
// to threads of EQUAL priority, and the case that deadlocks a spin under oversubscription is
// precisely the lower-priority one. The two are deliberately different calls with different names;
// the one above is for polling a handle, this one is for a program that is spinning on purpose.
void __polaron_thread_yield(void) { SwitchToThread(); }

// ---- Time (spec 34): monotonic + wall-clock + sleep. ----
// High-resolution monotonic nanoseconds (QueryPerformanceCounter). Split the math to avoid overflow.
long long __polaron_now_ns(void) {
    LARGE_INTEGER freq, c;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&c);
    long long f = freq.QuadPart;
    if (f == 0) {
        return 0;
    }
    return (c.QuadPart / f) * 1000000000LL + ((c.QuadPart % f) * 1000000000LL) / f;
}
// Wall-clock milliseconds since the Unix epoch (1970-01-01).
long long __polaron_unix_ms(void) {
    FILETIME ft;
    GetSystemTimeAsFileTime(&ft);
    unsigned long long t = (static_cast<unsigned long long>(ft.dwHighDateTime) << 32) | ft.dwLowDateTime;
    return static_cast<long long>(((t - 116444736000000000ULL) / 10000ULL));  // 100-ns since 1601 -> ms since 1970
}
void __polaron_sleep(long long ms) { Sleep(static_cast<DWORD>(ms)); }
#else
void __polaron_yield(void) { sched_yield(); }

// The same, for a program that is spinning on purpose. On POSIX there is one call and both names
// reach it; on Windows they are deliberately different -- see the note beside the other one.
void __polaron_thread_yield(void) { sched_yield(); }

// ---- Time (spec 34): monotonic + wall-clock + sleep, over clock_gettime (POSIX everywhere). ----
long long __polaron_now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return static_cast<long long>(ts.tv_sec) * 1000000000LL + ts.tv_nsec;
}
long long __polaron_now_ms(void) { return __polaron_now_ns() / 1000000LL; }
long long __polaron_unix_ms(void) {
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    return static_cast<long long>(ts.tv_sec) * 1000LL + ts.tv_nsec / 1000000LL;
}

void __polaron_sleep(long long ms) {
    struct timespec ts;
    ts.tv_sec = static_cast<time_t>((ms / 1000));
    ts.tv_nsec = static_cast<long>(((ms % 1000) * 1000000LL));
    nanosleep(&ts, nullptr);
}
#endif

// `defer within <duration>` (spec 32.10): the cleanup ran past its budget. The spec allows an exception or
// an alert; Polaron alerts -- a soft-real-time cleanup must still finish, and killing the scope exit (which
// may itself be an unwind) would be worse than the overrun it reports.
void __polaron_defer_overrun(long long budget_ms, long long took_ms) {
    fprintf(stderr, "polaron: defer overran its budget: took %lldms, budget %lldms\n", took_ms, budget_ms);
    fflush(stderr);
}

// ---- Networking (spec 34): minimal TCP client. The BSD socket API is the same on both OSes
// (via the shim's SOCKET/closesocket); only winsock's startup call is Windows-specific. ----
#ifdef _WIN32
static int g_net_inited = 0;
static void polaron_net_init(void) {
    if (!g_net_inited) { WSADATA w; WSAStartup(MAKEWORD(2, 2), &w); g_net_inited = 1; }
}
#else
static void polaron_net_init(void) {}  // POSIX sockets need no process-wide startup
#endif
long long __polaron_tcp_connect(const char* host, int port) {
    polaron_net_init();
    struct addrinfo hints;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    char ports[16];
    sprintf(ports, "%d", port);
    struct addrinfo* res = nullptr;
    if (getaddrinfo(host, ports, &hints, &res) != 0 || res == nullptr) {
        return -1;
    }
    SOCKET s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    if (s == INVALID_SOCKET) { freeaddrinfo(res); return -1; }
    if (connect(s, res->ai_addr, static_cast<int>(res->ai_addrlen)) != 0) {
        closesocket(s);
        freeaddrinfo(res);
        return -1;
    }
    freeaddrinfo(res);
    return static_cast<long long>(s);
}
long long __polaron_tcp_send(long long sock, const char* data, long long len) {
    return static_cast<long long>(send(static_cast<SOCKET>(sock), data, static_cast<int>(len), 0));
}
long long __polaron_tcp_recv(long long sock, char* buf, long long cap) {
    return static_cast<long long>(recv(static_cast<SOCKET>(sock), buf, static_cast<int>(cap), 0));
}
void __polaron_tcp_close(long long sock) { closesocket(static_cast<SOCKET>(sock)); }
// Server side (spec 34): bind + listen on a port, returning a listening socket (-1 on failure).
long long __polaron_tcp_listen(int port) {
    polaron_net_init();
    SOCKET s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (s == INVALID_SOCKET) {
        return -1;
    }
    BOOL yes = TRUE;
    setsockopt(s, SOL_SOCKET, SO_REUSEADDR, reinterpret_cast<const char*>(&yes), sizeof yes);
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons((unsigned short)port);
    if (bind(s, (struct sockaddr*)&addr, sizeof addr) != 0 || listen(s, SOMAXCONN) != 0) {
        closesocket(s);
        return -1;
    }
    return static_cast<long long>(s);
}
// Accepts the next incoming connection, returning a socket for it (-1 on failure). Blocks.
long long __polaron_tcp_accept(long long server) {
    SOCKET c = accept(static_cast<SOCKET>(server), nullptr, nullptr);
    return c == INVALID_SOCKET ? -1 : static_cast<long long>(c);
}

// ---- UDP datagrams (spec 34): connectionless send/receive over winsock. Open a socket (port 0 for an
// ephemeral client port, or a fixed port to receive on); sendto resolves the destination; recvfrom
// records the sender in globals readable via peer_host/peer_port for the request/reply pattern. ----
static char g_udp_peer_host[64] = {0};
static int g_udp_peer_port = 0;
long long __polaron_udp_open(int port) {
    polaron_net_init();
    SOCKET s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (s == INVALID_SOCKET) {
        return -1;
    }
    if (port != 0) {
        struct sockaddr_in a;
        memset(&a, 0, sizeof a);
        a.sin_family = AF_INET;
        a.sin_addr.s_addr = INADDR_ANY;
        a.sin_port = htons((unsigned short)port);
        if (bind(s, (struct sockaddr*)&a, sizeof a) != 0) { closesocket(s); return -1; }
    }
    return static_cast<long long>(s);
}
long long __polaron_udp_sendto(long long sock, const char* host, int port, const char* data, long long len) {
    struct addrinfo hints, *res = nullptr;
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_DGRAM;
    char ports[16];
    sprintf(ports, "%d", port);
    if (getaddrinfo(host, ports, &hints, &res) != 0 || res == nullptr) {
        return -1;
    }
    int n = sendto(static_cast<SOCKET>(sock), data, static_cast<int>(len), 0, res->ai_addr, static_cast<int>(res->ai_addrlen));
    freeaddrinfo(res);
    return static_cast<long long>(n);
}
long long __polaron_udp_recvfrom(long long sock, char* buf, long long cap) {
    struct sockaddr_in a;
#ifdef _WIN32
    int alen = static_cast<int>(sizeof a);
#else
    socklen_t alen = static_cast<socklen_t>(sizeof a);
#endif
    memset(&a, 0, sizeof a);
    int n = recvfrom(static_cast<SOCKET>(sock), buf, static_cast<int>(cap), 0, (struct sockaddr*)&a, &alen);
    if (n >= 0) {
        inet_ntop(AF_INET, &a.sin_addr, g_udp_peer_host, sizeof g_udp_peer_host);
        g_udp_peer_port = ntohs(a.sin_port);
    }
    return static_cast<long long>(n);
}
const char* __polaron_udp_peer_host(void) { return g_udp_peer_host; }
int __polaron_udp_peer_port(void) { return g_udp_peer_port; }
void __polaron_udp_close(long long sock) { closesocket(static_cast<SOCKET>(sock)); }

// ---- Cross-program IPC transport (spec 2.8). The program's NAME is its address: a named pipe
// \\.\pipe\polaron.<Name> on Windows, a Unix domain socket /tmp/polaron-<Name>.sock (mode 0600) on POSIX.
// So Program.connect("GameEngine") needs no registry, no port and no discovery -- and nothing is ever
// exposed on the network. Both ends of a connection are symmetric: either side may send a frame.
//
// A handle is a malloc'd PolaronPipe so the same close() works for a listener and for a connection.
// Every frame is length-prefixed ([u32 length][payload]); send/recv deal in whole frames, so the
// Polaron side never has to reassemble a stream. ----
struct PolaronPipe {
    int isServer;
    char name[256];
#ifdef _WIN32
    HANDLE h;
#else
    int fd;
#endif
};

static void polaron_ipc_path(const char* name, char* out, size_t cap) {
#ifdef _WIN32
    snprintf(out, cap, "\\\\.\\pipe\\polaron.%s", name);
#else
    snprintf(out, cap, "/tmp/polaron-%s.sock", name);
#endif
}

// POLARON_IPC_TRACE=1: one unbuffered line per IPC primitive, to stderr. A hang in a two-process protocol
// cannot be found from stdout, because stdout to a pipe is block-buffered and a process that never exits
// never flushes it -- so the last thing the program did is exactly the thing you cannot see. stderr is
// unbuffered, which makes the last line printed the place it stopped.
static void polaron_ipc_trace(const char* what, long long n) {
    static int on = -1;
    if (on < 0) {
        on = getenv("POLARON_IPC_TRACE") != nullptr ? 1 : 0;
    }
    if (on == 0) {
        return;
    }
#ifdef _WIN32
    fprintf(stderr, "[ipc pid=%lu] %s %lld\n", (unsigned long)GetCurrentProcessId(), what, n);
#else
    std::fprintf(stderr, "[ipc pid=%ld] %s %lld\n", static_cast<long>(getpid()), what, n);
#endif
    fflush(stderr);
}

static void polaron_ipc_trace_bytes(const char* what, const char* p, long long n);

long long __polaron_ipc_listen(const char* name) {
    PolaronPipe* p = static_cast<PolaronPipe*>(std::calloc(1, sizeof(PolaronPipe)));
    if (p == nullptr) {
        return -1;
    }
    p->isServer = 1;
    snprintf(p->name, sizeof(p->name), "%s", name);
#ifdef _WIN32
    p->h = INVALID_HANDLE_VALUE;  // an instance is created per accept()
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(p));
#else
    char path[512];
    polaron_ipc_path(name, path, sizeof(path));
    unlink(path);  // a stale socket file from a crashed run would make bind() fail
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) { std::free(p); return -1; }
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path);
    if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) != 0 || listen(fd, 16) != 0) {
        close(fd);
        std::free(p);
        return -1;
    }
    chmod(path, 0600);  // only this user may talk to the program
    p->fd = fd;
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(p));
#endif
}

long long __polaron_ipc_accept(long long srv) {
    polaron_ipc_trace("accept.enter", srv);
    PolaronPipe* s = reinterpret_cast<PolaronPipe*>(static_cast<std::intptr_t>(srv));
    if (s == nullptr || !s->isServer) {
        return -1;
    }
    PolaronPipe* c = static_cast<PolaronPipe*>(std::calloc(1, sizeof(PolaronPipe)));
    if (c == nullptr) {
        return -1;
    }
#ifdef _WIN32
    char path[512];
    polaron_ipc_path(s->name, path, sizeof(path));
    HANDLE h = CreateNamedPipeA(path, PIPE_ACCESS_DUPLEX, PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
                                PIPE_UNLIMITED_INSTANCES, 65536, 65536, 0, nullptr);
    if (h == INVALID_HANDLE_VALUE) { std::free(c); return -1; }
    if (!ConnectNamedPipe(h, nullptr) && GetLastError() != ERROR_PIPE_CONNECTED) {
        CloseHandle(h);
        std::free(c);
        return -1;
    }
    c->h = h;
#else
    int fd = accept(s->fd, nullptr, nullptr);
    if (fd < 0) { std::free(c); return -1; }
    c->fd = fd;
#endif
    polaron_ipc_trace("accept.got", static_cast<long long>(reinterpret_cast<std::intptr_t>(c)));
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(c));
}

long long __polaron_ipc_connect(const char* name) {
    polaron_ipc_trace("connect.enter", 0);
    char path[512];
    polaron_ipc_path(name, path, sizeof(path));
    PolaronPipe* c = static_cast<PolaronPipe*>(std::calloc(1, sizeof(PolaronPipe)));
    if (c == nullptr) {
        return -1;
    }
    snprintf(c->name, sizeof(c->name), "%s", name);
#ifdef _WIN32
    for (int attempt = 0; attempt < 50; ++attempt) {  // the server may be between accept() calls
        HANDLE h = CreateFileA(path, GENERIC_READ | GENERIC_WRITE, 0, nullptr, OPEN_EXISTING, 0, nullptr);
        if (h != INVALID_HANDLE_VALUE) {
            c->h = h;
            polaron_ipc_trace("connect.ok", static_cast<long long>(reinterpret_cast<std::intptr_t>(c)));
            return static_cast<long long>(reinterpret_cast<std::intptr_t>(c));
        }
        if (GetLastError() != ERROR_PIPE_BUSY && GetLastError() != ERROR_FILE_NOT_FOUND) {
            break;
        }
        Sleep(20);
    }
    std::free(c);
    return -1;
#else
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) { std::free(c); return -1; }
    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path);
    for (int attempt = 0; attempt < 50; ++attempt) {
        if (connect(fd, (struct sockaddr*)&addr, sizeof(addr)) == 0) {
            c->fd = fd;
            return static_cast<long long>(reinterpret_cast<std::intptr_t>(c));
        }
        __polaron_sleep(20);
    }
    close(fd);
    std::free(c);
    return -1;
#endif
}

static int polaron_ipc_write_all(PolaronPipe* c, const char* data, long long len) {
    polaron_ipc_trace("write.enter", len);
    long long done = 0;
    while (done < len) {
#ifdef _WIN32
        DWORD n = 0;
        if (!WriteFile(c->h, data + done, static_cast<DWORD>((len - done)), &n, nullptr) || n == 0) {
            return 0;
        }
#else
        long n = write(c->fd, data + done, static_cast<size_t>((len - done)));
        if (n <= 0) return 0;
#endif
        done += static_cast<long long>(n);
    }
    polaron_ipc_trace("write.done", done);
    polaron_ipc_trace_bytes("write.body", data, len);
    return 1;
}

// Dump a frame's leading bytes. The frame KIND is the first payload byte (kReplyOk=10, kReplyError=11),
// which is the difference between "the call worked" and "the far side refused" -- and the only way to
// tell them apart from outside the program.
static void polaron_ipc_trace_bytes(const char* what, const char* p, long long n) {
    static int on = -1;
    if (on < 0) {
        on = getenv("POLARON_IPC_TRACE") != nullptr ? 1 : 0;
    }
    if (on == 0 || n <= 0) {
        return;
    }
    const long long show = n < 40 ? n : 40;
    fprintf(stderr, "    %s [", what);
    for (long long i = 0; i < show; ++i) {
        const unsigned char ch = static_cast<unsigned char>(p[i]);
        fputc(ch >= 32 && ch < 127 ? ch : '.', stderr);
    }
    std::fprintf(stderr, "]  first=%u\n", static_cast<unsigned>(static_cast<unsigned char>(p[0])));
    fflush(stderr);
}

// How long one IPC read waits for its peer, in milliseconds. A blocking read with no deadline means a
// peer that died -- or one that is merely wedged -- hangs this program forever, with no error to report
// and nothing to diagnose. That is not a failure mode a language can ship: the far side of an IPC is
// another process, and another process can always stop answering.
//
// Long enough that a slow reply is not mistaken for a dead peer, short enough that a dead one is noticed
// while somebody is still watching. The caller already treats a failed read as a failed exchange and
// raises IpcError, so a timeout arrives as an exception rather than as a silent wrong answer.
#define POLARON_IPC_READ_TIMEOUT_MS 10000

static int polaron_ipc_read_all(PolaronPipe* c, char* buf, long long len) {
    polaron_ipc_trace("read.enter", len);
    long long done = 0;
    const long long deadline = __polaron_now_ms() + POLARON_IPC_READ_TIMEOUT_MS;
    while (done < len) {
#ifdef _WIN32
        // A named-pipe read cannot carry a deadline, so peek until something is there. Peeking does not
        // consume, so the ReadFile below always has data waiting and returns immediately.
        DWORD avail = 0;
        while (1) {
            if (!PeekNamedPipe(c->h, nullptr, 0, nullptr, &avail, nullptr)) {
                return 0;  // peer gone / pipe broken
            }
            if (avail > 0) {
                break;
            }
            if (__polaron_now_ms() >= deadline) {
                return 0;  // stopped answering
            }
            Sleep(1);
        }
        DWORD n = 0;
        if (!ReadFile(c->h, buf + done, static_cast<DWORD>((len - done)), &n, nullptr) || n == 0) {
            return 0;
        }
#else
        struct pollfd pfd;
        pfd.fd = c->fd;
        pfd.events = POLLIN;
        const long long left = deadline - __polaron_now_ms();
        if (left <= 0) return 0;
        const int pr = poll(&pfd, 1, static_cast<int>(left));
        if (pr <= 0) return 0;   // timed out, or the peer is gone
        long n = read(c->fd, buf + done, static_cast<size_t>((len - done)));
        if (n <= 0) return 0;
#endif
        done += static_cast<long long>(n);
    }
    polaron_ipc_trace_bytes("read.body", buf, len);
    return 1;
}

// Sends one whole frame. Returns the number of payload bytes written, or -1 if the peer is gone.
long long __polaron_ipc_send(long long conn, const char* data, long long len) {
    PolaronPipe* c = reinterpret_cast<PolaronPipe*>(static_cast<std::intptr_t>(conn));
    if (c == nullptr || c->isServer || len < 0) {
        return -1;
    }
    unsigned char hdr[4];
    unsigned int n = static_cast<unsigned int>(len);
    hdr[0] = static_cast<unsigned char>((n & 0xFF));
    hdr[1] = static_cast<unsigned char>(((n >> 8) & 0xFF));
    hdr[2] = static_cast<unsigned char>(((n >> 16) & 0xFF));
    hdr[3] = static_cast<unsigned char>(((n >> 24) & 0xFF));
    if (!polaron_ipc_write_all(c, reinterpret_cast<const char*>(hdr), 4)) {
        return -1;
    }
    if (len > 0 && !polaron_ipc_write_all(c, data, len)) {
        return -1;
    }
    return len;
}

// Receives one whole frame. Returns a malloc'd NUL-terminated buffer (*outLen = its length); an empty
// buffer with *outLen == 0 means the peer closed the connection.
char* __polaron_ipc_recv(long long conn, long long* outLen) {
    PolaronPipe* c = reinterpret_cast<PolaronPipe*>(static_cast<std::intptr_t>(conn));
    *outLen = 0;
    if (c == nullptr || c->isServer) {
        char* e = static_cast<char*>(__polaron_malloc(1));
        e[0] = 0;
        return e;
    }
    unsigned char hdr[4];
    if (!polaron_ipc_read_all(c, reinterpret_cast<char*>(hdr), 4)) { char* e = static_cast<char*>(__polaron_malloc(1)); e[0] = 0; return e; }
    unsigned int n = static_cast<unsigned int>(hdr[0]) | (static_cast<unsigned int>(hdr[1]) << 8) |
                     (static_cast<unsigned int>(hdr[2]) << 16) | (static_cast<unsigned int>(hdr[3]) << 24);
    char* buf = static_cast<char*>(__polaron_malloc(static_cast<size_t>(n) + 1));
    if (buf == nullptr) {
        char* e = static_cast<char*>(__polaron_malloc(1));
        e[0] = 0;
        return e;
    }
    if (n > 0 && !polaron_ipc_read_all(c, buf, static_cast<long long>(n))) {
        __polaron_free(buf);
        char* e = static_cast<char*>(__polaron_malloc(1));
        e[0] = 0;
        return e;
    }
    buf[n] = 0;
    *outLen = static_cast<long long>(n);
    return buf;
}

void __polaron_ipc_close(long long h) {
    PolaronPipe* p = reinterpret_cast<PolaronPipe*>(static_cast<std::intptr_t>(h));
    if (p == nullptr) {
        return;
    }
#ifdef _WIN32
    if (p->h != INVALID_HANDLE_VALUE && p->h != nullptr) {
        if (!p->isServer) {
            FlushFileBuffers(p->h);
        }
        CloseHandle(p->h);
    }
#else
    if (p->isServer) {
        char path[512];
        polaron_ipc_path(p->name, path, sizeof(path));
        close(p->fd);
        unlink(path);
    } else {
        close(p->fd);
    }
#endif
    std::free(p);
}

// ---- Subprocess (spec 34): run a command line through the shell, capturing its stdout and exit
// code. Returns a malloc'd NUL-terminated buffer of the captured output; *outLen is its length and
// *outExit the process exit code (-1 if the process could not be started). ----
#ifndef _WIN32
#define _popen popen    // the POSIX spelling of the same pipe-to-shell primitive
#define _pclose pclose
#endif
char* __polaron_process_run(const char* cmd, long long* outLen, int* outExit) {
    FILE* p = _popen(cmd, "r");
    if (p == nullptr) {
        *outLen = 0;
        *outExit = -1;
        char* e = static_cast<char*>(__polaron_malloc(1));
        e[0] = 0;
        return e;
    }
    size_t cap = 4096, len = 0;
    char* buf = static_cast<char*>(__polaron_malloc(cap));
    char chunk[4096];
    size_t n;
    while ((n = fread(chunk, 1, sizeof(chunk), p)) > 0) {
        if (len + n + 1 > cap) {
            while (len + n + 1 > cap) {
                cap *= 2;
            }
            buf = static_cast<char*>(__polaron_realloc(buf, cap));
        }
        memcpy(buf + len, chunk, n);
        len += n;
    }
    buf[len] = 0;
    *outExit = _pclose(p);
    *outLen = static_cast<long long>(len);
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

// ---- STARTING A PROGRAM WITHOUT A SHELL (spec 34). ----
//
// Everything above takes a COMMAND LINE: one string, handed to `cmd.exe` or `/bin/sh`. That makes
// every argument shell syntax. A path with a space becomes two arguments; a filename holding `&` or
// `|` or `$(...)` becomes a second command, and it runs. There is no amount of care at the call site
// that fixes it, because the call site is where the string is built.
//
// So the primitive below takes an ARGUMENT VECTOR: the program and its arguments as separate values,
// crossing as one NUL-separated blob with a count. Nothing in an argument can be read as syntax,
// because no shell ever sees it.
//
// POSIX gets this exactly: `execvp` takes the vector as it stands. WINDOWS HAS NO SUCH CALL --
// `CreateProcess` takes a command line and the CHILD parses it -- so the vector has to be encoded
// into one, by the rules the C runtime's parser actually uses. That encoding is below and it is not
// optional: getting it wrong is the same defect through a different door. What is avoided either way
// is `cmd.exe`, and with it `&`, `|`, `>`, `^` and `%VAR%` expansion.

// C++ linkage, because these are the file's own helpers rather than part of the runtime's C
// interface -- and a C-linkage function may not return a std::vector, which is how the compiler
// pointed out that the surrounding block is `extern "C"`.
extern "C++" {

// One argument, quoted for the MSVCRT command-line parser (the algorithm Microsoft documents for
// CommandLineToArgvW). Quotes are added only when needed, so an ordinary command line still reads
// like one in a process listing.
static void appendWindowsArg(std::string& out, const char* arg) {
    const bool needsQuotes = arg[0] == 0 || strpbrk(arg, " \t\n\v\"") != nullptr;
    if (!needsQuotes) {
        out += arg;
        return;
    }
    out += '"';
    for (const char* p = arg;; ++p) {
        std::size_t backslashes = 0;
        while (*p == '\\') {
            ++p;
            ++backslashes;
        }
        if (*p == 0) {
            // Backslashes before the CLOSING quote are doubled, so they stay backslashes rather than
            // escaping the quote that ends the argument.
            out.append(backslashes * 2, '\\');
            break;
        }
        if (*p == '"') {
            out.append(backslashes * 2 + 1, '\\');   // ...and the one that escapes this quote
            out += '"';
        } else {
            out.append(backslashes, '\\');
            out += *p;
        }
    }
    out += '"';
}

// The NUL-separated blob as a vector of pointers into it. The blob is not modified and the pointers
// are valid for as long as it is.
static std::vector<const char*> splitBlob(const char* blob, long long len, int count) {
    std::vector<const char*> out;
    if (blob == nullptr || count <= 0) {
        return out;
    }
    long long at = 0;
    for (int i = 0; i < count && at <= len; ++i) {
        out.push_back(blob + at);
        while (at < len && blob[at] != 0) {
            ++at;
        }
        ++at;   // past the separator
    }
    return out;
}

}  // extern "C++"

#ifdef _WIN32
// mergeErr: give the child's stderr the same pipe as its stdout, so ONE stream carries everything the
// child says. A compiler prints its diagnostics on stderr, and a caller that only reads stdout would call
// a failing build silent. It is not the default: a child speaking a framed protocol (DAP) would have its
// stream corrupted by stray log lines, which is exactly the bug this flag lets each caller decide about.
long long __polaron_subproc_spawn_ex(const char* cmdline, long long mergeErr, long long showWindow) {
    SECURITY_ATTRIBUTES sa;
    sa.nLength = sizeof(sa);
    sa.bInheritHandle = TRUE;
    sa.lpSecurityDescriptor = nullptr;
    HANDLE inRd = nullptr, inWr = nullptr, outRd = nullptr, outWr = nullptr;
    if (!CreatePipe(&inRd, &inWr, &sa, 0)) {
        return 0;
    }
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
    // Windowless by default: a background tool (git, the LSP, the checker) has its stdio piped to us and
    // never needs a console -- without CREATE_NO_WINDOW a console flashes on every spawn (e.g. a git diff on
    // each file open). showWindow lets the caller opt into a visible console for an interactive child.
    DWORD creationFlags = showWindow != 0 ? 0 : CREATE_NO_WINDOW;
    BOOL ok = CreateProcessA(nullptr, mutableCmd, nullptr, nullptr, TRUE, creationFlags, nullptr, nullptr,
                             &si, &pi);
    std::free(mutableCmd);
    CloseHandle(inRd);   // the child owns these now
    CloseHandle(outWr);
    if (!ok) { CloseHandle(inWr); CloseHandle(outRd); return 0; }
    CloseHandle(pi.hThread);
    LdpSubproc* s = static_cast<LdpSubproc*>(std::malloc(sizeof(LdpSubproc)));
    s->proc = pi.hProcess;
    s->hIn = inWr;
    s->hOut = outRd;
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(s));
}

long long __polaron_subproc_spawn(const char* cmdline) {
    return __polaron_subproc_spawn_ex(cmdline, 0, 0);
}

// The argument-vector spawn. Same handle as above, so read/write/alive/close all work unchanged --
// what changes is that nothing here is parsed by a shell.
//
// `cwd` empty means "inherit ours". `envBlob` holds `NAME=VALUE` entries, NUL-separated; when
// `envCount` is 0 the child inherits our environment, which is what nearly every caller wants.
long long __polaron_subproc_spawn_argv(const char* argvBlob, long long argvLen, long long argc,
                                       const char* cwd, const char* envBlob, long long envLen,
                                       long long envCount, long long mergeErr,
                                       long long showWindow) {
    std::vector<const char*> args = splitBlob(argvBlob, argvLen, static_cast<int>(argc));
    if (args.empty()) {
        return 0;
    }
    std::string cmdline;
    for (std::size_t i = 0; i < args.size(); ++i) {
        if (i > 0) {
            cmdline += ' ';
        }
        appendWindowsArg(cmdline, args[i]);
    }
    // A doubly-NUL-terminated block, which is the shape CreateProcess wants.
    std::string envBlock;
    if (envCount > 0) {
        std::vector<const char*> entries = splitBlob(envBlob, envLen, static_cast<int>(envCount));
        for (const char* e : entries) {
            envBlock.append(e);
            envBlock.push_back('\0');
        }
        envBlock.push_back('\0');
    }

    SECURITY_ATTRIBUTES sa;
    sa.nLength = sizeof(sa);
    sa.bInheritHandle = TRUE;
    sa.lpSecurityDescriptor = nullptr;
    HANDLE inRd = nullptr, inWr = nullptr, outRd = nullptr, outWr = nullptr;
    if (!CreatePipe(&inRd, &inWr, &sa, 0)) {
        return 0;
    }
    if (!CreatePipe(&outRd, &outWr, &sa, 0)) { CloseHandle(inRd); CloseHandle(inWr); return 0; }
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
    std::vector<char> mutableCmd(cmdline.begin(), cmdline.end());
    mutableCmd.push_back('\0');   // CreateProcessA may write into the command line
    const DWORD creationFlags = showWindow != 0 ? 0 : CREATE_NO_WINDOW;
    // The block is passed as LPVOID, so it must be writable storage rather than the string's own.
    std::vector<char> envBytes(envBlock.begin(), envBlock.end());
    BOOL ok = CreateProcessA(nullptr, mutableCmd.data(), nullptr, nullptr, TRUE, creationFlags,
                             envBytes.empty() ? nullptr : static_cast<LPVOID>(envBytes.data()),
                             (cwd != nullptr && cwd[0] != 0) ? cwd : nullptr, &si, &pi);
    CloseHandle(inRd);
    CloseHandle(outWr);
    if (!ok) { CloseHandle(inWr); CloseHandle(outRd); return 0; }
    CloseHandle(pi.hThread);
    LdpSubproc* s = static_cast<LdpSubproc*>(std::malloc(sizeof(LdpSubproc)));
    s->proc = pi.hProcess;
    s->hIn = inWr;
    s->hOut = outRd;
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(s));
}

// Wait for the child to finish and answer its exit code; -1 when it cannot be determined. Separate
// from `close`, which discards the code AND terminates a child still running -- fine for a tool the
// parent is done with, useless for asking whether the thing worked.
long long __polaron_subproc_wait(long long h) {
    if (h == 0) {
        return -1;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    WaitForSingleObject(s->proc, INFINITE);
    DWORD code = 0;
    if (!GetExitCodeProcess(s->proc, &code)) {
        return -1;
    }
    return static_cast<long long>(static_cast<int>(code));
}

// ...and the same with a DEADLINE, answering -2 when the time runs out with the child still running.
//
// Without this, a parent that waits is a parent that a hung child hangs. That is not a rare case: it
// is what a tool that prompts for input does when nobody is there to type, and what a program stuck
// in a retry loop does forever. A build, a test runner and a language server all need to be able to
// give up -- and the ONLY reason -2 is a separate answer from -1 is that "it is still going" and "I
// could not find out" call for different things: one waits longer or kills, the other reports.
long long __polaron_subproc_wait_for(long long h, long long millis) {
    if (h == 0) {
        return -1;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    const DWORD r = WaitForSingleObject(s->proc, static_cast<DWORD>(millis < 0 ? 0 : millis));
    if (r == WAIT_TIMEOUT) {
        return -2;
    }
    if (r != WAIT_OBJECT_0) {
        return -1;
    }
    DWORD code = 0;
    if (!GetExitCodeProcess(s->proc, &code)) {
        return -1;
    }
    return static_cast<long long>(static_cast<int>(code));
}

long long __polaron_subproc_write(long long h, const char* data, long long len) {
    if (h == 0) {
        return -1;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    DWORD written = 0;
    if (!WriteFile(s->hIn, data, static_cast<DWORD>(len), &written, nullptr)) {
        return -1;
    }
    return static_cast<long long>(written);
}

char* __polaron_subproc_read(long long h, long long* outLen) {
    *outLen = 0;
    if (h == 0) { char* e = static_cast<char*>(__polaron_malloc(1)); e[0] = 0; return e; }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    DWORD n = 0;
    char* buf = static_cast<char*>(__polaron_malloc(4097));
    if (!ReadFile(s->hOut, buf, 4096, &n, nullptr) || n == 0) {
        buf[0] = 0;
        return buf;
    }  // EOF/broken pipe
    buf[n] = 0;
    *outLen = static_cast<long long>(n);
    return buf;
}

int __polaron_subproc_alive(long long h) {
    if (h == 0) {
        return 0;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    return WaitForSingleObject(s->proc, 0) == WAIT_TIMEOUT ? 1 : 0;
}

// True when the child has bytes buffered to read right now (so read() returns data without blocking).
// EOF/broken pipe reads as 0 -- callers detect end-of-session via alive()/the adapter's terminated event,
// so a `while (can_read()) read()` pump terminates naturally instead of spinning on empty EOF reads.
int __polaron_subproc_can_read(long long h) {
    if (h == 0) {
        return 0;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    DWORD avail = 0;
    if (!PeekNamedPipe(s->hOut, nullptr, 0, nullptr, &avail, nullptr)) {
        return 0;  // closed/broken -> nothing to read
    }
    return avail > 0 ? 1 : 0;
}

// Close only the child's stdin (send it EOF) without killing it -- lets a well-behaved child (lldb-dap,
// sort, cat) finish and exit on its own. Idempotent: the handle is nulled so close() won't double-close.
void __polaron_subproc_close_stdin(long long h) {
    if (h == 0) {
        return;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    if (s->hIn != nullptr) {
        CloseHandle(s->hIn);
        s->hIn = nullptr;
    }
}

void __polaron_subproc_close(long long h) {
    if (h == 0) {
        return;
    }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    if (s->hIn != nullptr) {
        CloseHandle(s->hIn);
    }
    CloseHandle(s->hOut);
    if (WaitForSingleObject(s->proc, 0) == WAIT_TIMEOUT) {
        TerminateProcess(s->proc, 0);
    }
    CloseHandle(s->proc);
    std::free(s);
}
#else
long long __polaron_subproc_spawn_ex(const char* cmdline, long long mergeErr, long long showWindow) {
    static_cast<void>(showWindow);  // no console-window concept on POSIX; the flag is a Windows affordance
    int inPipe[2], outPipe[2];  // inPipe: parent writes [1] -> child reads [0]; outPipe: child writes [1] -> parent reads [0]
    if (pipe(inPipe) != 0) return 0;
    if (pipe(outPipe) != 0) { close(inPipe[0]); close(inPipe[1]); return 0; }
    pid_t pid = fork();
    if (pid < 0) { close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]); return 0; }
    if (pid == 0) {
        setpgid(0, 0);  // own process group: close() signals the whole spawned subtree. /bin/sh -c
                        // may fork the program rather than exec into it, so killing only s->pid would
                        // orphan a long-lived child (e.g. an IPC engine) that then holds inherited pipes.
        dup2(inPipe[0], 0);
        dup2(outPipe[1], 1);
        if (mergeErr != 0) dup2(outPipe[1], 2);
        close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]);
        execl("/bin/sh", "sh", "-c", cmdline, static_cast<char*>(nullptr));
        _exit(127);
    }
    static_cast<void>(setpgid(pid, pid));  // race-free with the child's own setpgid; whichever runs first wins, and a
                              // late call after the child exec'd fails harmlessly (EACCES), which is fine.
    close(inPipe[0]);
    close(outPipe[1]);
    LdpSubproc* s = static_cast<LdpSubproc*>(std::malloc(sizeof(LdpSubproc)));
    s->pid = pid;
    s->fdIn = inPipe[1];
    s->fdOut = outPipe[0];
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(s));
}

long long __polaron_subproc_spawn(const char* cmdline) {
    return __polaron_subproc_spawn_ex(cmdline, 0, 0);
}

// The argument-vector spawn: `execvp` takes the vector as it stands, so no shell is involved and
// nothing in an argument can be read as syntax. See the note above the Windows half, where the same
// guarantee costs an encoding.
long long __polaron_subproc_spawn_argv(const char* argvBlob, long long argvLen, long long argc,
                                       const char* cwd, const char* envBlob, long long envLen,
                                       long long envCount, long long mergeErr,
                                       long long showWindow) {
    static_cast<void>(showWindow);   // a Windows affordance; POSIX has no console-window concept
    std::vector<const char*> args = splitBlob(argvBlob, argvLen, static_cast<int>(argc));
    if (args.empty()) {
        return 0;
    }
    std::vector<char*> argv;
    for (const char* a : args) {
        argv.push_back(const_cast<char*>(a));
    }
    argv.push_back(nullptr);
    std::vector<const char*> envEntries = splitBlob(envBlob, envLen, static_cast<int>(envCount));
    std::vector<char*> envp;
    for (const char* e : envEntries) {
        envp.push_back(const_cast<char*>(e));
    }
    envp.push_back(nullptr);

    int inPipe[2], outPipe[2], errPipe[2];
    if (pipe(inPipe) != 0) return 0;
    if (pipe(outPipe) != 0) { close(inPipe[0]); close(inPipe[1]); return 0; }
    // A THIRD PIPE THAT CARRIES ONLY A FAILURE. On Windows a program that is not there makes
    // CreateProcess fail, so the spawn answers 0 and the caller is told. On POSIX the fork succeeds
    // and only the CHILD discovers there is nothing to exec -- it exits 127, which is also a code a
    // real program may return, so "not found" and "ran and failed" become the same answer.
    //
    // The close-on-exec trick removes the guess: the child writes its errno here if exec fails, and
    // a successful exec closes the descriptor silently. The parent's read therefore returns bytes
    // (it failed, and why) or zero (it worked) -- and blocks until one of the two is known, which is
    // also the synchronisation that makes the answer trustworthy.
    if (pipe(errPipe) != 0) {
        close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]);
        return 0;
    }
    fcntl(errPipe[1], F_SETFD, FD_CLOEXEC);
    pid_t pid = fork();
    if (pid < 0) {
        close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]);
        close(errPipe[0]); close(errPipe[1]);
        return 0;
    }
    if (pid == 0) {
        setpgid(0, 0);   // own group, so close() reaches the whole subtree
        close(errPipe[0]);
        dup2(inPipe[0], 0);
        dup2(outPipe[1], 1);
        if (mergeErr != 0) dup2(outPipe[1], 2);
        close(inPipe[0]); close(inPipe[1]); close(outPipe[0]); close(outPipe[1]);
        int failure = 0;
        if (cwd != nullptr && cwd[0] != 0 && chdir(cwd) != 0) {
            failure = errno;   // the directory was the caller's instruction; running elsewhere is not it
        }
        if (failure == 0) {
            if (envCount > 0) {
                // `environ` rather than execvpe, which is a GNU extension that macOS and FreeBSD do
                // not have -- and the failure would be a link error on the platform nobody built on.
                // The child is single-threaded and about to exec, so replacing it here is safe.
                extern char** environ;
                environ = envp.data();
            }
            execvp(argv[0], argv.data());
            failure = errno;   // exec only returns on failure
        }
        const ssize_t wrote = write(errPipe[1], &failure, sizeof failure);
        static_cast<void>(wrote);
        _exit(127);   // the shell's "not found", kept for parity with what a shell would have said
    }
    static_cast<void>(setpgid(pid, pid));
    close(inPipe[0]);
    close(outPipe[1]);
    close(errPipe[1]);   // the child holds the only writing end now
    int childFailure = 0;
    const ssize_t got = read(errPipe[0], &childFailure, sizeof childFailure);
    close(errPipe[0]);
    if (got > 0) {
        int status = 0;
        waitpid(pid, &status, 0);   // it is already exiting; reap it rather than leave a zombie
        close(inPipe[1]);
        close(outPipe[0]);
        return 0;
    }
    LdpSubproc* s = static_cast<LdpSubproc*>(std::malloc(sizeof(LdpSubproc)));
    s->pid = pid;
    s->fdIn = inPipe[1];
    s->fdOut = outPipe[0];
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(s));
}

// Wait and answer the exit code; -1 when it cannot be determined, and 128+N for a child killed by
// signal N -- the convention every shell already reports, so a caller reading the number gets the
// same answer it would from the command line.
long long __polaron_subproc_wait(long long h) {
    if (h == 0) return -1;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    int status = 0;
    if (waitpid(s->pid, &status, 0) < 0) return -1;
    if (WIFEXITED(status)) return static_cast<long long>(WEXITSTATUS(status));
    if (WIFSIGNALED(status)) return static_cast<long long>(128 + WTERMSIG(status));
    return -1;
}

// ...with a deadline; -2 when it runs out with the child still going. See the Windows half for why
// that is a distinct answer from -1.
//
// Polled rather than signalled: `waitpid` has no timeout, and the alternatives (SIGCHLD with
// sigtimedwait, or pidfd on new Linux only) each take over signal handling or a facility the other
// systems do not have -- for a wait that is measured in whole seconds, a millisecond poll costs
// nothing anybody can observe and works identically everywhere.
long long __polaron_subproc_wait_for(long long h, long long millis) {
    if (h == 0) return -1;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    long long left = millis < 0 ? 0 : millis;
    for (;;) {
        int status = 0;
        const pid_t r = waitpid(s->pid, &status, WNOHANG);
        if (r < 0) return -1;
        if (r > 0) {
            if (WIFEXITED(status)) return static_cast<long long>(WEXITSTATUS(status));
            if (WIFSIGNALED(status)) return static_cast<long long>(128 + WTERMSIG(status));
            return -1;
        }
        if (left <= 0) return -2;
        struct timespec ts;
        ts.tv_sec = 0;
        ts.tv_nsec = 1000000L;   // one millisecond
        nanosleep(&ts, nullptr);
        left = left - 1;
    }
}

long long __polaron_subproc_write(long long h, const char* data, long long len) {
    if (h == 0) return -1;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    ssize_t w = write(s->fdIn, data, static_cast<size_t>(len));
    return static_cast<long long>(w);
}

char* __polaron_subproc_read(long long h, long long* outLen) {
    *outLen = 0;
    if (h == 0) { char* e = static_cast<char*>(__polaron_malloc(1)); e[0] = 0; return e; }
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    char* buf = static_cast<char*>(__polaron_malloc(4097));
    ssize_t n = read(s->fdOut, buf, 4096);
    if (n <= 0) { buf[0] = 0; return buf; }
    buf[n] = 0;
    *outLen = static_cast<long long>(n);
    return buf;
}

int __polaron_subproc_alive(long long h) {
    if (h == 0) return 0;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    int status;
    pid_t r = waitpid(s->pid, &status, WNOHANG);
    return r == 0 ? 1 : 0;
}

int __polaron_subproc_can_read(long long h) {
    if (h == 0) return 0;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    int n = 0;
    if (ioctl(s->fdOut, FIONREAD, &n) < 0) return 0;  // FIONREAD is 0 at EOF, matching the Windows path
    return n > 0 ? 1 : 0;
}

void __polaron_subproc_close_stdin(long long h) {
    if (h == 0) return;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    if (s->fdIn >= 0) { close(s->fdIn); s->fdIn = -1; }
}

void __polaron_subproc_close(long long h) {
    if (h == 0) return;
    LdpSubproc* s = reinterpret_cast<LdpSubproc*>(static_cast<std::intptr_t>(h));
    if (s->fdIn >= 0) close(s->fdIn);
    close(s->fdOut);
    int status;
    // Signal the whole process group (the /bin/sh wrapper AND the program it launched); killing only
    // s->pid can leave a spawned server (e.g. an IPC engine) orphaned and holding pipes it inherited,
    // which would keep a capturing parent (a build tool reading our output) blocked until it times out.
    if (waitpid(s->pid, &status, WNOHANG) == 0) { kill(-s->pid, SIGTERM); waitpid(s->pid, &status, 0); }
    std::free(s);
}
#endif

// ---- Pseudo-console for the integrated terminal (spec 34): the child runs attached to a real console
// (ConPTY on Windows), so it emits the ANSI colour/cursor sequences an IDE terminal parses, rather than
// the plain line pipe a normal subprocess gets. The handle is an opaque pointer returned as an i64. ----
#ifdef _WIN32
struct LdpPty {
    HPCON hpc;
    HANDLE proc;
    HANDLE toChild;    // our write end -> the child's input
    HANDLE fromChild;  // our read end  <- the child's output
    HANDLE ptyIn;      // the pseudoconsole's input read end -- kept open for the console's lifetime
    HANDLE ptyOut;     // the pseudoconsole's output write end -- ditto (closing it early stops output)
};
extern "C" long long __polaron_conpty_spawn(const char* cmdline, int cols, int rows) {
    HANDLE inRead = nullptr, inWrite = nullptr, outRead = nullptr, outWrite = nullptr;
    if (!CreatePipe(&inRead, &inWrite, nullptr, 0)) {
        return 0;
    }
    if (!CreatePipe(&outRead, &outWrite, nullptr, 0)) {
        CloseHandle(inRead); CloseHandle(inWrite);
        return 0;
    }
    COORD size;
    size.X = static_cast<SHORT>((cols > 0 ? cols : 80));
    size.Y = static_cast<SHORT>((rows > 0 ? rows : 25));
    HPCON hpc = nullptr;
    HRESULT hr = CreatePseudoConsole(size, inRead, outWrite, 0, &hpc);
    if (FAILED(hr)) {
        CloseHandle(inRead); CloseHandle(outWrite);
        CloseHandle(inWrite); CloseHandle(outRead);
        return 0;
    }
    // Keep inRead/outWrite open: the pseudoconsole writes the child's rendered output to outWrite for the
    // console's whole lifetime, so closing it here would cut the output off after the initial bytes.
    STARTUPINFOEXA si;
    ZeroMemory(&si, sizeof(si));
    si.StartupInfo.cb = sizeof(si);
    SIZE_T bytes = 0;
    InitializeProcThreadAttributeList(nullptr, 1, 0, &bytes);
    si.lpAttributeList = static_cast<LPPROC_THREAD_ATTRIBUTE_LIST>(std::malloc(bytes));
    if (si.lpAttributeList == nullptr ||
        !InitializeProcThreadAttributeList(si.lpAttributeList, 1, 0, &bytes) ||
        !UpdateProcThreadAttribute(si.lpAttributeList, 0, PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE, hpc,
                                   sizeof(hpc), nullptr, nullptr)) {
        if (si.lpAttributeList) {
            std::free(si.lpAttributeList);
        }
        ClosePseudoConsole(hpc);
        CloseHandle(inRead); CloseHandle(outWrite);
        CloseHandle(inWrite); CloseHandle(outRead);
        return 0;
    }
    PROCESS_INFORMATION pi;
    ZeroMemory(&pi, sizeof(pi));
    char* mut = _strdup(cmdline);
    BOOL ok = CreateProcessA(nullptr, mut, nullptr, nullptr, FALSE, EXTENDED_STARTUPINFO_PRESENT, nullptr,
                             nullptr, &si.StartupInfo, &pi);
    std::free(mut);
    DeleteProcThreadAttributeList(si.lpAttributeList);
    std::free(si.lpAttributeList);
    if (!ok) {
        ClosePseudoConsole(hpc);
        CloseHandle(inRead); CloseHandle(outWrite);
        CloseHandle(inWrite); CloseHandle(outRead);
        return 0;
    }
    CloseHandle(pi.hThread);
    LdpPty* p = static_cast<LdpPty*>(std::malloc(sizeof(LdpPty)));
    p->hpc = hpc;
    p->proc = pi.hProcess;
    p->toChild = inWrite;
    p->fromChild = outRead;
    p->ptyIn = inRead;
    p->ptyOut = outWrite;
    return static_cast<long long>(reinterpret_cast<std::intptr_t>(p));
}
extern "C" long long __polaron_conpty_write(long long h, const char* data, long long len) {
    if (h == 0) {
        return -1;
    }
    LdpPty* p = reinterpret_cast<LdpPty*>(static_cast<std::intptr_t>(h));
    DWORD written = 0;
    if (!WriteFile(p->toChild, data, static_cast<DWORD>(len), &written, nullptr)) {
        return -1;
    }
    return static_cast<long long>(written);
}
extern "C" char* __polaron_conpty_read(long long h, long long* outLen) {
    *outLen = 0;
    if (h == 0) { char* e = static_cast<char*>(__polaron_malloc(1)); e[0] = 0; return e; }
    LdpPty* p = reinterpret_cast<LdpPty*>(static_cast<std::intptr_t>(h));
    DWORD n = 0;
    char* buf = static_cast<char*>(__polaron_malloc(8193));
    if (!ReadFile(p->fromChild, buf, 8192, &n, nullptr) || n == 0) {
        buf[0] = 0;
        return buf;
    }
    buf[n] = 0;
    *outLen = static_cast<long long>(n);
    return buf;
}
extern "C" int __polaron_conpty_can_read(long long h) {
    if (h == 0) {
        return 0;
    }
    LdpPty* p = reinterpret_cast<LdpPty*>(static_cast<std::intptr_t>(h));
    DWORD avail = 0;
    if (!PeekNamedPipe(p->fromChild, nullptr, 0, nullptr, &avail, nullptr)) {
        return 0;
    }
    return avail > 0 ? 1 : 0;
}
extern "C" int __polaron_conpty_alive(long long h) {
    if (h == 0) {
        return 0;
    }
    LdpPty* p = reinterpret_cast<LdpPty*>(static_cast<std::intptr_t>(h));
    return WaitForSingleObject(p->proc, 0) == WAIT_TIMEOUT ? 1 : 0;
}
extern "C" void __polaron_conpty_resize(long long h, int cols, int rows) {
    if (h == 0) {
        return;
    }
    LdpPty* p = reinterpret_cast<LdpPty*>(static_cast<std::intptr_t>(h));
    COORD size;
    size.X = static_cast<SHORT>((cols > 0 ? cols : 80));
    size.Y = static_cast<SHORT>((rows > 0 ? rows : 25));
    ResizePseudoConsole(p->hpc, size);
}
extern "C" void __polaron_conpty_close(long long h) {
    if (h == 0) {
        return;
    }
    LdpPty* p = reinterpret_cast<LdpPty*>(static_cast<std::intptr_t>(h));
    ClosePseudoConsole(p->hpc);   // documented order: close the pseudoconsole first, then the pipes
    if (p->toChild) {
        CloseHandle(p->toChild);
    }
    if (p->fromChild) {
        CloseHandle(p->fromChild);
    }
    if (p->ptyIn) {
        CloseHandle(p->ptyIn);
    }
    if (p->ptyOut) {
        CloseHandle(p->ptyOut);
    }
    if (WaitForSingleObject(p->proc, 0) == WAIT_TIMEOUT) {
        TerminateProcess(p->proc, 0);
    }
    CloseHandle(p->proc);
    std::free(p);
}
#else
// POSIX: the pty terminal is a Windows-only feature in Forge today. Stub the builtins so the single-source
// runtime still links on Linux without pulling in libutil (forkpty). A real pty here is a later slice.
extern "C" long long __polaron_conpty_spawn(const char* cmdline, int cols, int rows) {
    static_cast<void>(cmdline); static_cast<void>(cols); static_cast<void>(rows); return 0;
}
extern "C" long long __polaron_conpty_write(long long h, const char* data, long long len) {
    static_cast<void>(h); static_cast<void>(data); static_cast<void>(len); return -1;
}
extern "C" char* __polaron_conpty_read(long long h, long long* outLen) {
    static_cast<void>(h); *outLen = 0; char* e = static_cast<char*>(__polaron_malloc(1)); e[0] = 0; return e;
}
extern "C" int __polaron_conpty_can_read(long long h) { static_cast<void>(h); return 0; }
extern "C" int __polaron_conpty_alive(long long h) { static_cast<void>(h); return 0; }
extern "C" void __polaron_conpty_resize(long long h, int cols, int rows) { static_cast<void>(h); static_cast<void>(cols); static_cast<void>(rows); }
extern "C" void __polaron_conpty_close(long long h) { static_cast<void>(h); }
#endif

// ---- Local time zone (spec 34): the system's current UTC offset in seconds (east positive), including
// any active daylight-saving adjustment. Windows' Bias is UTC = local + Bias (minutes), so the offset is
// its negation. ----
#ifdef _WIN32
int __polaron_local_utc_offset_seconds(void) {
    TIME_ZONE_INFORMATION tz;
    DWORD r = GetTimeZoneInformation(&tz);
    long bias = tz.Bias;
    if (r == TIME_ZONE_ID_DAYLIGHT) {
        bias += tz.DaylightBias;
    } else if (r == TIME_ZONE_ID_STANDARD) {
        bias += tz.StandardBias;
    }
    return static_cast<int>((-bias * 60));
}
#else
// tm_gmtoff carries the effective offset (DST included); glibc, musl and the BSDs all provide it.
int __polaron_local_utc_offset_seconds(void) {
    time_t now = time(nullptr);
    struct tm lt;
    localtime_r(&now, &lt);
    return static_cast<int>(lt.tm_gmtoff);
}
#endif

// ---- Cryptographically secure randomness (spec 34): 64 bits from the OS CSPRNG. ----
#ifdef _WIN32
long long __polaron_secure_random(void) {  // rand_s -> RtlGenRandom
    unsigned int hi = 0, lo = 0;
    rand_s(&hi);
    rand_s(&lo);
    return (static_cast<long long>(static_cast<unsigned long long>(hi)) << 32) | static_cast<long long>(lo);
}
#else
long long __polaron_secure_random(void) {
    unsigned long long v = 0;
#if defined(__APPLE__) || defined(__FreeBSD__)
    // `arc4random_buf` is the BSD spelling and it cannot fail -- no fallback path to get wrong, and no
    // `<sys/random.h>`, which is a Linux header these systems do not have.
    ::arc4random_buf(&v, sizeof v);
#else
    if (getrandom(&v, sizeof v, 0) != static_cast<ssize_t>(sizeof v)) {
        int fd = open("/dev/urandom", O_RDONLY);   // getrandom(2) with /dev/urandom as the fallback
        if (fd >= 0) {
            ssize_t r = read(fd, &v, sizeof v);
            static_cast<void>(r);
            close(fd);
        }
    }
#endif
    return static_cast<long long>(v);
}
#endif

// ---- Environment variables (spec 34). ----

// A std::string handed over to a Polaron String: allocated where a String expects, NUL-terminated so
// the C side can also read it, and length reported separately so an embedded NUL survives the trip.
// Written once because the alternative -- each answer growing its own buffer by hand -- is how two of
// them came to use the wrong allocator.
static char* polaronStrOut(const std::string& s, long long* outLen) {
    char* buf = static_cast<char*>(__polaron_malloc(s.size() + 1));
    if (buf == nullptr) {
        *outLen = 0;
        return buf;
    }
    memcpy(buf, s.data(), s.size());
    buf[s.size()] = 0;
    *outLen = static_cast<long long>(s.size());
    return buf;
}

char* __polaron_env_get(const char* name, long long* outLen) {
    const char* v = getenv(name);
    if (v == nullptr) {
        *outLen = 0;
        char* e = static_cast<char*>(__polaron_malloc(1));
        e[0] = 0;
        return e;
    }
    size_t n = strlen(v);
    char* buf = static_cast<char*>(__polaron_malloc(n + 1));
    memcpy(buf, v, n + 1);
    *outLen = static_cast<long long>(n);
    return buf;
}
int __polaron_env_set(const char* name, const char* value) {
#ifdef _WIN32
    return _putenv_s(name, value) == 0 ? 1 : 0;
#else
    return setenv(name, value, 1) == 0 ? 1 : 0;
#endif
}
// ABSENT IS NOT EMPTY, and until this existed the two were the same value: `env_get` answers "" for a
// variable that is not set AND for one set to "", so a program could not tell a missing configuration
// from a deliberately blank one. Nothing fails; the program runs with a default it was never told to
// use. The same shape as reading a file that is not there and getting "" back -- and the reason the
// library above this now answers with an Option.
int __polaron_env_has(const char* name) { return getenv(name) != nullptr ? 1 : 0; }
int __polaron_env_unset(const char* name) {
#ifdef _WIN32
    return _putenv_s(name, "") == 0 ? 1 : 0;   // the Windows spelling of "remove": set it to nothing
#else
    return unsetenv(name) == 0 ? 1 : 0;
#endif
}
// The whole environment, one `NAME=VALUE` per line. What a program needs to pass its own environment
// on to a child, or to print what it was actually given rather than what it thinks it was.
char* __polaron_env_all(long long* outLen) {
    std::string all;
    // `_environ` and not GetEnvironmentStrings: the CRT's copy is the one `getenv` and `_putenv_s`
    // read and write, so a variable this program just set is in it. The Win32 block is the process
    // environment, which the CRT does not write back to -- so `set` then `all` would not agree.
    // It is also the same shape as POSIX's `environ`, which needs no freeing.
#ifdef _WIN32
    char** env = _environ;
#else
    extern char** environ;
    char** env = environ;
#endif
    for (char** e = env; e != nullptr && *e != nullptr; ++e) {
        all.append(*e);
        all.push_back('\n');
    }
    return polaronStrOut(all, outLen);
}

// ---- WHERE THE PROGRAM IS, AND WHAT IT IS RUNNING ON (spec 34). ----
//
// A program that cannot ask where it is has to be told, which means every one of them grows a
// configuration file whose first entry is a path somebody typed. These are the questions an operating
// system already knows the answer to.

// The working directory. Empty on failure rather than a partial path, by the rule the executable path
// follows: half an answer is worse than none, because it looks like an answer.
char* __polaron_cwd(long long* outLen) {
#ifdef _WIN32
    DWORD n = GetCurrentDirectoryA(0, nullptr);   // asked for the size first: paths exceed MAX_PATH
    if (n == 0) {
        return polaronStrOut(std::string(), outLen);
    }
    std::string s(n, '\0');
    DWORD got = GetCurrentDirectoryA(n, &s[0]);
    s.resize(got);
    return polaronStrOut(s, outLen);
#else
    std::string s(4096, '\0');
    if (getcwd(&s[0], s.size()) == nullptr) {
        return polaronStrOut(std::string(), outLen);
    }
    s.resize(strlen(s.c_str()));
    return polaronStrOut(s, outLen);
#endif
}
int __polaron_chdir(const char* path) {
#ifdef _WIN32
    return SetCurrentDirectoryA(path) ? 1 : 0;
#else
    return chdir(path) == 0 ? 1 : 0;
#endif
}
// The directory for scratch files. Every platform names it differently and every program that guesses
// gets it wrong somewhere: /tmp does not exist on Windows and TEMP is not set on a POSIX daemon.
char* __polaron_temp_dir(long long* outLen) {
#ifdef _WIN32
    char buf[MAX_PATH + 1];
    DWORD n = GetTempPathA(sizeof(buf), buf);
    std::string s(buf, n);
    while (!s.empty() && (s.back() == '\\' || s.back() == '/')) {   // no trailing separator, so join works
        s.pop_back();
    }
    return polaronStrOut(s, outLen);
#else
    const char* t = getenv("TMPDIR");
    return polaronStrOut(std::string(t != nullptr && t[0] != 0 ? t : "/tmp"), outLen);
#endif
}
char* __polaron_home_dir(long long* outLen) {
#ifdef _WIN32
    const char* p = getenv("USERPROFILE");
    if (p != nullptr && p[0] != 0) {
        return polaronStrOut(std::string(p), outLen);
    }
    const char* drive = getenv("HOMEDRIVE");
    const char* rest = getenv("HOMEPATH");
    if (drive != nullptr && rest != nullptr) {
        return polaronStrOut(std::string(drive) + rest, outLen);
    }
    return polaronStrOut(std::string(), outLen);
#else
    const char* h = getenv("HOME");
    return polaronStrOut(std::string(h != nullptr ? h : ""), outLen);
#endif
}
char* __polaron_hostname(long long* outLen) {
#ifdef _WIN32
    char buf[256];
    DWORD n = sizeof(buf);
    if (!GetComputerNameA(buf, &n)) {
        return polaronStrOut(std::string(), outLen);
    }
    return polaronStrOut(std::string(buf, n), outLen);
#else
    char buf[256];
    if (gethostname(buf, sizeof(buf)) != 0) {
        return polaronStrOut(std::string(), outLen);
    }
    buf[sizeof(buf) - 1] = 0;
    return polaronStrOut(std::string(buf), outLen);
#endif
}
char* __polaron_username(long long* outLen) {
#ifdef _WIN32
    // USERNAME and not GetUserNameA: that one lives in advapi32, and linking it would put advapi32
    // on the link line of EVERY Polaron program for a question most of them never ask. The variable
    // is set by the same login that GetUserNameA would report, and reading it costs nothing.
    const char* u = getenv("USERNAME");
    return polaronStrOut(std::string(u != nullptr ? u : ""), outLen);
#else
    const char* u = getenv("USER");
    if (u == nullptr || u[0] == 0) {
        u = getenv("LOGNAME");
    }
    return polaronStrOut(std::string(u != nullptr ? u : ""), outLen);
#endif
}
// The family name, not the version: "windows", "linux", "macos", "freebsd". A program branching on
// this wants to know which shape the world has, and a version string invites parsing that will be
// wrong on the next release.
char* __polaron_os_name(long long* outLen) {
#if defined(_WIN32)
    return polaronStrOut(std::string("windows"), outLen);
#elif defined(__APPLE__)
    return polaronStrOut(std::string("macos"), outLen);
#elif defined(__FreeBSD__)
    return polaronStrOut(std::string("freebsd"), outLen);
#elif defined(__linux__)
    return polaronStrOut(std::string("linux"), outLen);
#else
    return polaronStrOut(std::string("unknown"), outLen);
#endif
}
long long __polaron_pid(void) {
#ifdef _WIN32
    return static_cast<long long>(GetCurrentProcessId());
#else
    return static_cast<long long>(getpid());
#endif
}
// Physical memory, in bytes; -1 when the system will not say. A program sizing a cache against it must
// be able to tell "the machine has none" from "I could not find out".
long long __polaron_machine_memory(void) {
#ifdef _WIN32
    MEMORYSTATUSEX ms;
    ms.dwLength = sizeof(ms);
    if (!GlobalMemoryStatusEx(&ms)) {
        return -1;
    }
    return static_cast<long long>(ms.ullTotalPhys);
#elif defined(_SC_PHYS_PAGES) && defined(_SC_PAGESIZE)
    const long pages = sysconf(_SC_PHYS_PAGES);
    const long ps = sysconf(_SC_PAGESIZE);
    if (pages < 0 || ps < 0) {
        return -1;
    }
    return static_cast<long long>(pages) * static_cast<long long>(ps);
#else
    return -1;
#endif
}
// HOW MUCH MEMORY IS FREE RIGHT NOW, which is a different question from how much the machine has --
// and it is the one a program sizing a cache, a buffer pool or a batch actually needs. Sizing
// against TOTAL is how a program that behaves on an idle machine takes the whole box down on a busy
// one. -1 when the system will not say.
long long __polaron_machine_available_memory(void) {
#ifdef _WIN32
    MEMORYSTATUSEX ms;
    ms.dwLength = sizeof(ms);
    if (!GlobalMemoryStatusEx(&ms)) {
        return -1;
    }
    return static_cast<long long>(ms.ullAvailPhys);
#elif defined(_SC_AVPHYS_PAGES) && defined(_SC_PAGESIZE)
    const long pages = sysconf(_SC_AVPHYS_PAGES);
    const long ps = sysconf(_SC_PAGESIZE);
    if (pages < 0 || ps < 0) {
        return -1;
    }
    return static_cast<long long>(pages) * static_cast<long long>(ps);
#else
    return -1;
#endif
}

// How long this machine has been up, in seconds; -1 when it cannot be determined. What a monitor
// reports, and what a program comparing its own age against the machine's uses to tell "restarted
// with the box" from "restarted on its own".
long long __polaron_uptime(void) {
#ifdef _WIN32
    return static_cast<long long>(GetTickCount64() / 1000ULL);
#elif defined(CLOCK_BOOTTIME)
    struct timespec ts;
    if (clock_gettime(CLOCK_BOOTTIME, &ts) != 0) {
        return -1;
    }
    return static_cast<long long>(ts.tv_sec);
#elif defined(CLOCK_MONOTONIC)
    // Not identical -- CLOCK_MONOTONIC does not count time spent suspended on the systems that
    // separate the two -- and it is the closest thing the rest of them have.
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) {
        return -1;
    }
    return static_cast<long long>(ts.tv_sec);
#else
    return -1;
#endif
}

long long __polaron_page_size(void) {
#ifdef _WIN32
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    return static_cast<long long>(si.dwPageSize);
#else
    const long ps = sysconf(_SC_PAGESIZE);
    return ps < 0 ? -1 : static_cast<long long>(ps);
#endif
}
// Free and total bytes on the volume holding `path`; -1 when it cannot be determined. Free rather
// than "available to this user" is deliberate on POSIX -- `f_bavail` is what a non-root program can
// actually use, and reporting the larger `f_bfree` would promise space a write cannot have.
long long __polaron_disk_free(const char* path) {
#ifdef _WIN32
    ULARGE_INTEGER avail, total, free_;
    if (!GetDiskFreeSpaceExA(path, &avail, &total, &free_)) {
        return -1;
    }
    return static_cast<long long>(avail.QuadPart);
#else
    struct statvfs st;
    if (statvfs(path, &st) != 0) {
        return -1;
    }
    return static_cast<long long>(st.f_bavail) * static_cast<long long>(st.f_frsize);
#endif
}
long long __polaron_disk_total(const char* path) {
#ifdef _WIN32
    ULARGE_INTEGER avail, total, free_;
    if (!GetDiskFreeSpaceExA(path, &avail, &total, &free_)) {
        return -1;
    }
    return static_cast<long long>(total.QuadPart);
#else
    struct statvfs st;
    if (statvfs(path, &st) != 0) {
        return -1;
    }
    return static_cast<long long>(st.f_blocks) * static_cast<long long>(st.f_frsize);
#endif
}
// A path with every `.`, `..` and relative prefix resolved, as the operating system resolves it.
// Empty when the path cannot be resolved -- which on POSIX includes "it does not exist", because
// realpath refuses to guess about a component it cannot see.
char* __polaron_path_absolute(const char* path, long long* outLen) {
#ifdef _WIN32
    DWORD n = GetFullPathNameA(path, 0, nullptr, nullptr);
    if (n == 0) {
        return polaronStrOut(std::string(), outLen);
    }
    std::string s(n, '\0');
    DWORD got = GetFullPathNameA(path, n, &s[0], nullptr);
    s.resize(got);
    return polaronStrOut(s, outLen);
#else
    char* r = realpath(path, nullptr);
    if (r == nullptr) {
        return polaronStrOut(std::string(), outLen);
    }
    std::string s(r);
    std::free(r);   // realpath's own block, freed with its own allocator
    return polaronStrOut(s, outLen);
#endif
}
// The running program's own path (spec 34): Windows via GetModuleFileNameA, POSIX via
// /proc/self/exe. Returns a heap NUL-terminated string; empty on failure or truncation rather
// than a half-formed path a caller might trust.
char* __polaron_executable_path(void) {
#ifdef _WIN32
    DWORD cap = 4096;
    char* buf = static_cast<char*>(__polaron_malloc(cap));
    if (buf == nullptr) {
        char* e = static_cast<char*>(__polaron_malloc(1));
        if (e) {
            e[0] = 0;
        }
        return e;
    }
    DWORD n = GetModuleFileNameA(nullptr, buf, cap);
    if (n == 0 || n >= cap) { buf[0] = 0; } else { buf[n] = 0; }
    return buf;
#else
    // `/proc/self/exe` IS NOT UNIX, IT IS LINUX. FreeBSD does not mount /proc by default and macOS has
    // no procfs at all -- and the failure is silent: the readlink fails, the path comes back empty,
    // and whatever wanted to know where the program lives quietly gets nothing. FreeBSD compiled this
    // file without a murmur and would have behaved that way, which is exactly the kind of hole a
    // second operating system exists to find.
    size_t cap = 4096;
    // __polaron_malloc, as in the Windows branch above: the caller wraps this in a String, and a
    // String frees through __polaron_free, which reads a header this block would not have.
    char* buf = static_cast<char*>(__polaron_malloc(cap));
    if (buf == nullptr) { char* e = static_cast<char*>(__polaron_malloc(1)); if (e) e[0] = 0; return e; }
#if defined(__APPLE__)
    // Mach-O: the loader knows, and answers with the required size if the buffer is too small.
    std::uint32_t sz = static_cast<std::uint32_t>(cap);
    if (_NSGetExecutablePath(buf, &sz) != 0) { buf[0] = 0; }
#elif defined(__FreeBSD__)
    // The kernel knows the path of a process's image; `-1` means "this process".
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PATHNAME, -1};
    size_t len = cap;
    if (::sysctl(mib, 4, buf, &len, nullptr, 0) != 0) { buf[0] = 0; }
#else
    ssize_t n = readlink("/proc/self/exe", buf, cap - 1);
    if (n < 0) { buf[0] = 0; } else { buf[static_cast<size_t>(n)] = 0; }
#endif
    return buf;
#endif
}

// ---- File I/O (spec 34.4): whole-file read/write. ----

// A stdio handle with an owner.
//
// Every open below used to be paired with a hand-written `fclose` on each way out, and the ELF reader
// further down has THREE ways out. A destructor states once what each of those repeated, and cannot be
// forgotten on a path somebody adds later. Non-copyable, movable: two owners closing one handle is the
// bug this class exists to make unwritable.
class StdioFile {
public:
    StdioFile() = default;
    StdioFile(const char* path, const char* mode) : f_(std::fopen(path, mode)) {}
    ~StdioFile() { close(); }
    StdioFile(const StdioFile&) = delete;
    StdioFile& operator=(const StdioFile&) = delete;
    StdioFile(StdioFile&& other) noexcept : f_(other.f_) { other.f_ = nullptr; }
    StdioFile& operator=(StdioFile&& other) noexcept {
        if (this != &other) {
            close();
            f_ = other.f_;
            other.f_ = nullptr;
        }
        return *this;
    }

    bool isOpen() const { return f_ != nullptr; }
    std::FILE* get() const { return f_; }
    void close() {
        if (f_ != nullptr) {
            std::fclose(f_);
            f_ = nullptr;
        }
    }

private:
    std::FILE* f_ = nullptr;
};

char* __polaron_file_read_all(const char* path, long long* outLen) {
    StdioFile file(path, "rb");
    if (!file.isOpen()) {
        *outLen = 0;
        char* e = static_cast<char*>(__polaron_malloc(1));
        e[0] = 0;
        return e;
    }
    std::fseek(file.get(), 0, SEEK_END);
    long size = std::ftell(file.get());
    if (size < 0) {
        size = 0;
    }
    std::fseek(file.get(), 0, SEEK_SET);
    char* buf = static_cast<char*>(__polaron_malloc(static_cast<size_t>(size) + 1));
    const size_t n = std::fread(buf, 1, static_cast<size_t>(size), file.get());
    buf[n] = 0;
    *outLen = static_cast<long long>(n);
    return buf;
}
int __polaron_file_write_all(const char* path, const char* data, long long len, int append) {
    StdioFile file(path, append ? "ab" : "wb");
    if (!file.isOpen()) {
        return 0;
    }
    const size_t n = std::fwrite(data, 1, static_cast<size_t>(len), file.get());
    return n == static_cast<size_t>(len) ? 1 : 0;
}
// EXISTS MEANS "SOMETHING IS AT THIS PATH", not "a file I can open for reading". This used to be
// `fopen(path, "rb")`, which answers NO for a directory that is plainly there -- and that lie hid a
// second bug behind it: `deleteRecursively` checked its own work by asking whether the directory still
// existed, was told no, and reported success while the tree was untouched. Two defects agreeing.
//
// It also said no for a file that exists but cannot be opened (permissions, an exclusive lock), which
// is a different question wearing the same name.
int __polaron_file_exists(const char* path) {
#ifdef _WIN32
    return GetFileAttributesA(path) != INVALID_FILE_ATTRIBUTES ? 1 : 0;
#else
    struct stat st;
    return stat(path, &st) == 0 ? 1 : 0;
#endif
}
int __polaron_file_delete(const char* path) { return remove(path) == 0 ? 1 : 0; }

// ---- OPEN FILES. ----
//
// Everything above reads or writes a WHOLE file, which is the only shape the language had: a program
// that wanted the first line of a log had to bring the log into memory, and one that wanted to append
// a record re-read and rewrote the file. Neither is a limitation of the platform -- it is that no
// handle ever crossed into Polaron.
//
// The handle is an opaque `long` (the FILE* as an integer), for the same reason the subprocess handle
// is: the language has no type for a foreign pointer that it should be storing in a field, and an
// integer that is only ever handed back to this runtime cannot be dereferenced by accident.
//
// Modes are the C ones, and deliberately so -- "rb"/"wb"/"ab"/"r+b" name themselves, and inventing an
// enum here would mean maintaining a translation table whose only content is those four strings.
// REPLACING A FILE WITHOUT EVER HAVING HALF OF IT ON DISK.
//
// `write` truncates and then fills. A crash, a full disk or a kill between those two leaves the file
// EMPTY or half-written -- and it is the caller's save file, config or index that is gone. The fix is
// as old as filesystems: write a temporary beside it and RENAME, because a rename either happened or
// did not. Every editor and database does this; almost no program that writes a config does.
//
// POSIX `rename` gives that within a filesystem. Windows needs to be asked for it: MoveFileExA with
// REPLACE_EXISTING, and WRITE_THROUGH so the change is on the disk rather than in a cache when the
// call returns.
int __polaron_file_replace(const char* from, const char* to) {
#ifdef _WIN32
    return MoveFileExA(from, to, MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH) ? 1 : 0;
#else
    return rename(from, to) == 0 ? 1 : 0;
#endif
}

// KEEPING TWO PROGRAMS OFF ONE FILE.
//
// A lock on an open file, held until it is unlocked or the file is closed -- and released by the
// operating system if the process dies, which is what makes it safe where a lock FILE is not: a
// crashed program leaves a stale lock file behind forever, and every program that has ever used one
// has grown a "is this lock stale?" guess that is sometimes wrong.
//
// `wait` chooses between blocking until it is free and answering 0 immediately. Both are wanted:
// a build waits, a "am I already running?" check must not.
int __polaron_file_lock(long long h, int exclusive, int wait) {
    if (h == 0) {
        return 0;
    }
    std::FILE* f = reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h));
#ifdef _WIN32
    HANDLE handle = reinterpret_cast<HANDLE>(_get_osfhandle(_fileno(f)));
    if (handle == INVALID_HANDLE_VALUE) {
        return 0;
    }
    DWORD flags = 0;
    if (exclusive != 0) { flags |= LOCKFILE_EXCLUSIVE_LOCK; }
    if (wait == 0) { flags |= LOCKFILE_FAIL_IMMEDIATELY; }
    OVERLAPPED ov;
    memset(&ov, 0, sizeof(ov));
    // The whole file, however long it becomes: a range that covers every possible offset.
    return LockFileEx(handle, flags, 0, 0xFFFFFFFF, 0xFFFFFFFF, &ov) ? 1 : 0;
#else
    int op = exclusive != 0 ? LOCK_EX : LOCK_SH;
    if (wait == 0) { op |= LOCK_NB; }
    return flock(fileno(f), op) == 0 ? 1 : 0;
#endif
}

int __polaron_file_unlock(long long h) {
    if (h == 0) {
        return 0;
    }
    std::FILE* f = reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h));
#ifdef _WIN32
    HANDLE handle = reinterpret_cast<HANDLE>(_get_osfhandle(_fileno(f)));
    if (handle == INVALID_HANDLE_VALUE) {
        return 0;
    }
    OVERLAPPED ov;
    memset(&ov, 0, sizeof(ov));
    return UnlockFileEx(handle, 0, 0xFFFFFFFF, 0xFFFFFFFF, &ov) ? 1 : 0;
#else
    return flock(fileno(f), LOCK_UN) == 0 ? 1 : 0;
#endif
}

// WHICH INSTRUCTION SET THIS IS -- a different question from which operating system, and one a
// program branching on SIMD width, calling convention or a downloaded binary's name has to ask.
char* __polaron_cpu_arch(long long* outLen) {
#if defined(__x86_64__) || defined(_M_X64)
    return polaronStrOut(std::string("x86_64"), outLen);
#elif defined(__aarch64__) || defined(_M_ARM64)
    return polaronStrOut(std::string("arm64"), outLen);
#elif defined(__i386__) || defined(_M_IX86)
    return polaronStrOut(std::string("x86"), outLen);
#elif defined(__arm__) || defined(_M_ARM)
    return polaronStrOut(std::string("arm"), outLen);
#elif defined(__riscv) && __riscv_xlen == 64
    return polaronStrOut(std::string("riscv64"), outLen);
#elif defined(__wasm__)
    return polaronStrOut(std::string("wasm"), outLen);
#else
    return polaronStrOut(std::string("unknown"), outLen);
#endif
}

long long __polaron_fopen(const char* path, const char* mode) {
    std::FILE* f = std::fopen(path, mode);
    return f == nullptr ? 0 : static_cast<long long>(reinterpret_cast<std::uintptr_t>(f));
}
// Bytes actually read, which is short at end-of-file and 0 there -- the caller's loop condition.
long long __polaron_fread(long long h, char* buf, long long n) {
    if (h == 0) { return 0; }
    std::FILE* f = reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h));
    return static_cast<long long>(std::fread(buf, 1, static_cast<size_t>(n), f));
}
long long __polaron_fwrite(long long h, const char* buf, long long n) {
    if (h == 0) { return 0; }
    std::FILE* f = reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h));
    return static_cast<long long>(std::fwrite(buf, 1, static_cast<size_t>(n), f));
}
// `whence`: 0 from the start, 1 from here, 2 from the end -- SEEK_SET/CUR/END, passed as numbers
// because the constants are not the same integers on every platform and the language must not depend
// on which ones this one uses.
int __polaron_fseek(long long h, long long off, int whence) {
    if (h == 0) { return 0; }
    std::FILE* f = reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h));
    const int w = whence == 1 ? SEEK_CUR : (whence == 2 ? SEEK_END : SEEK_SET);
#ifdef _WIN32
    return _fseeki64(f, off, w) == 0 ? 1 : 0;
#else
    return fseeko(f, static_cast<off_t>(off), w) == 0 ? 1 : 0;
#endif
}
long long __polaron_ftell(long long h) {
    if (h == 0) { return -1; }
    std::FILE* f = reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h));
#ifdef _WIN32
    return _ftelli64(f);
#else
    return static_cast<long long>(ftello(f));
#endif
}
int __polaron_fflush(long long h) {
    if (h == 0) { return 0; }
    return std::fflush(reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h))) == 0 ? 1 : 0;
}
int __polaron_fclose(long long h) {
    if (h == 0) { return 0; }
    return std::fclose(reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h))) == 0 ? 1 : 0;
}
// End-of-file is only true AFTER a read came up short -- C's rule, kept rather than smoothed, because
// smoothing it means a peek, and a peek on a pipe blocks.
int __polaron_feof(long long h) {
    if (h == 0) { return 1; }
    return std::feof(reinterpret_cast<std::FILE*>(static_cast<std::uintptr_t>(h))) != 0 ? 1 : 0;
}

// A DIRECTORY IS NOT DELETED BY `remove`. On Windows it takes RemoveDirectory and nothing else, so
// `File.remove` on a directory returned 0 and the caller had no other call to reach for. Kept as its
// own primitive rather than folded into file_delete: one syscall per runtime entry point, with the
// library deciding which to use from `isDir` -- the layer that can afford the question.
// The directory must be empty; emptying it is the caller's walk.
int __polaron_rmdir(const char* path) {
#ifdef _WIN32
    return RemoveDirectoryA(path) != 0 ? 1 : 0;
#else
    return rmdir(path) == 0 ? 1 : 0;
#endif
}

// Last modification, in seconds since the epoch; -1 when the path is not there. Seconds because that
// is the resolution every filesystem this runs on agrees about -- finer units differ per platform and
// per filesystem, and a build tool comparing two of them wants one unit that never lies.
long long __polaron_file_mtime(const char* path) {
#ifdef _WIN32
    WIN32_FILE_ATTRIBUTE_DATA d;
    if (!GetFileAttributesExA(path, GetFileExInfoStandard, &d)) {
        return -1;
    }
    // FILETIME is 100ns ticks since 1601; the constant is the seconds between 1601 and 1970.
    unsigned long long t = (static_cast<unsigned long long>(d.ftLastWriteTime.dwHighDateTime) << 32) |
                           d.ftLastWriteTime.dwLowDateTime;
    return static_cast<long long>(t / 10000000ULL) - 11644473600LL;
#else
    struct stat st;
    if (stat(path, &st) != 0) {
        return -1;
    }
    return static_cast<long long>(st.st_mtime);
#endif
}

// WHEN IT WAS MADE -- and -1 when the filesystem does not record that, which is the whole reason
// this is a separate function rather than a third field on the one above.
//
// `st_ctime` IS NOT THE CREATION TIME. It is the inode's status-change time, and it moves when
// permissions change or a link is added. Every library that answered "created" with it is wrong on
// Linux in a way nothing reports: a file that was chmod'd yesterday claims to have been made
// yesterday. So the honest answers are the three below -- Windows records it, macOS and FreeBSD keep
// `st_birthtime`, and Linux has it only through `statx` on a filesystem that stores it -- and -1
// where it genuinely is not known. A caller can then say "unknown" instead of printing a date that
// means something else.
long long __polaron_file_ctime(const char* path) {
#ifdef _WIN32
    WIN32_FILE_ATTRIBUTE_DATA d;
    if (!GetFileAttributesExA(path, GetFileExInfoStandard, &d)) {
        return -1;
    }
    unsigned long long t = (static_cast<unsigned long long>(d.ftCreationTime.dwHighDateTime) << 32) |
                           d.ftCreationTime.dwLowDateTime;
    return static_cast<long long>(t / 10000000ULL) - 11644473600LL;
#elif defined(__APPLE__) || defined(__FreeBSD__)
    struct stat st;
    if (stat(path, &st) != 0) {
        return -1;
    }
#if defined(__APPLE__)
    return static_cast<long long>(st.st_birthtimespec.tv_sec);
#else
    return static_cast<long long>(st.st_birthtim.tv_sec);
#endif
#elif defined(STATX_BTIME)
    struct statx sx;
    if (statx(AT_FDCWD, path, 0, STATX_BTIME, &sx) != 0 || (sx.stx_mask & STATX_BTIME) == 0) {
        return -1;   // the kernel has statx but this filesystem does not store a birth time
    }
    return static_cast<long long>(sx.stx_btime.tv_sec);
#else
    static_cast<void>(path);
    return -1;
#endif
}

long long __polaron_file_atime(const char* path) {
#ifdef _WIN32
    WIN32_FILE_ATTRIBUTE_DATA d;
    if (!GetFileAttributesExA(path, GetFileExInfoStandard, &d)) {
        return -1;
    }
    unsigned long long t = (static_cast<unsigned long long>(d.ftLastAccessTime.dwHighDateTime) << 32) |
                           d.ftLastAccessTime.dwLowDateTime;
    return static_cast<long long>(t / 10000000ULL) - 11644473600LL;
#else
    struct stat st;
    if (stat(path, &st) != 0) {
        return -1;
    }
    return static_cast<long long>(st.st_atime);
#endif
}

// Whether a write would be refused, and the switch for it. Windows has a read-only ATTRIBUTE; POSIX
// has permission bits, so "read-only" there means the owner's write bit is off -- close enough to the
// same question that one call is better than making every caller ask it twice, and different enough
// to be worth saying so here.
int __polaron_file_readonly(const char* path) {
#ifdef _WIN32
    DWORD a = GetFileAttributesA(path);
    if (a == INVALID_FILE_ATTRIBUTES) {
        return -1;
    }
    return (a & FILE_ATTRIBUTE_READONLY) != 0 ? 1 : 0;
#else
    struct stat st;
    if (stat(path, &st) != 0) {
        return -1;
    }
    return (st.st_mode & S_IWUSR) == 0 ? 1 : 0;
#endif
}

int __polaron_file_set_readonly(const char* path, int value) {
#ifdef _WIN32
    DWORD a = GetFileAttributesA(path);
    if (a == INVALID_FILE_ATTRIBUTES) {
        return 0;
    }
    a = value != 0 ? (a | FILE_ATTRIBUTE_READONLY) : (a & ~FILE_ATTRIBUTE_READONLY);
    return SetFileAttributesA(path, a) ? 1 : 0;
#else
    struct stat st;
    if (stat(path, &st) != 0) {
        return 0;
    }
    mode_t m = value != 0 ? (st.st_mode & ~static_cast<mode_t>(S_IWUSR | S_IWGRP | S_IWOTH))
                          : (st.st_mode | S_IWUSR);
    return chmod(path, m) == 0 ? 1 : 0;
#endif
}

// ---- LINKS. One name for a file that is somewhere else. ----
//
// A symbolic link is a path stored in place of a file, and everything that follows from that is why
// it needs its own calls: `exists` follows it, so a link pointing at nothing reports "not there"
// while the link itself is plainly sitting in the directory; and `mtime` reports the TARGET's, so a
// build that compares timestamps compares the wrong file.
//
// WINDOWS MAY REFUSE. Creating one needs SeCreateSymbolicLinkPrivilege, which an ordinary account
// does not have unless Developer Mode is on -- so the answer is reported rather than assumed, and
// `FLAG_ALLOW_UNPRIVILEGED_SYMLINK_CREATE` is passed for the case where it is.
int __polaron_symlink(const char* target, const char* linkPath, int isDir) {
#ifdef _WIN32
    DWORD flags = isDir != 0 ? SYMBOLIC_LINK_FLAG_DIRECTORY : 0;
#ifdef SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE
    flags |= SYMBOLIC_LINK_FLAG_ALLOW_UNPRIVILEGED_CREATE;
#endif
    return CreateSymbolicLinkA(linkPath, target, flags) ? 1 : 0;
#else
    static_cast<void>(isDir);   // POSIX links do not distinguish; the target decides
    return symlink(target, linkPath) == 0 ? 1 : 0;
#endif
}

// A second NAME for the same file -- not a path stored in place of one. Deleting either leaves the
// data reachable through the other, which is the difference a caller is choosing between.
int __polaron_hardlink(const char* target, const char* linkPath) {
#ifdef _WIN32
    return CreateHardLinkA(linkPath, target, nullptr) ? 1 : 0;
#else
    return link(target, linkPath) == 0 ? 1 : 0;
#endif
}

// Is this path itself a link -- asked WITHOUT following it, which is the only way the question can
// be answered. `stat` follows, so it reports on the target and says nothing about the name.
int __polaron_is_symlink(const char* path) {
#ifdef _WIN32
    DWORD a = GetFileAttributesA(path);
    if (a == INVALID_FILE_ATTRIBUTES) {
        return 0;
    }
    return (a & FILE_ATTRIBUTE_REPARSE_POINT) != 0 ? 1 : 0;
#else
    struct stat st;
    if (lstat(path, &st) != 0) {
        return 0;
    }
    return S_ISLNK(st.st_mode) ? 1 : 0;
#endif
}

// What the link points AT, as stored -- which may be relative, and may name nothing at all. Empty
// when the path is not a link or cannot be read.
char* __polaron_readlink(const char* path, long long* outLen) {
#ifdef _WIN32
    // The final path, which is what Windows can answer: opening with FILE_FLAG_BACKUP_SEMANTICS lets
    // this work for a directory link as well as a file one.
    HANDLE h = CreateFileA(path, 0, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr,
                           OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, nullptr);
    if (h == INVALID_HANDLE_VALUE) {
        return polaronStrOut(std::string(), outLen);
    }
    DWORD n = GetFinalPathNameByHandleA(h, nullptr, 0, FILE_NAME_NORMALIZED);
    if (n == 0) {
        CloseHandle(h);
        return polaronStrOut(std::string(), outLen);
    }
    std::string s(n, '\0');
    DWORD got = GetFinalPathNameByHandleA(h, &s[0], n, FILE_NAME_NORMALIZED);
    CloseHandle(h);
    s.resize(got);
    // The `\\?\` prefix is an extended-length marker, not part of the path anybody wants to read.
    if (s.rfind("\\\\?\\", 0) == 0) {
        s = s.substr(4);
    }
    return polaronStrOut(s, outLen);
#else
    std::string s(4096, '\0');
    const ssize_t n = readlink(path, &s[0], s.size());
    if (n < 0) {
        return polaronStrOut(std::string(), outLen);
    }
    s.resize(static_cast<size_t>(n));
    return polaronStrOut(s, outLen);
#endif
}

// Set a file's modification time to now, creating it empty if it is not there -- `touch`. What a
// build tool does to say "this is current" without rewriting the contents.
int __polaron_file_touch(const char* path) {
#ifdef _WIN32
    HANDLE h = CreateFileA(path, FILE_WRITE_ATTRIBUTES, FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr,
                           OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (h == INVALID_HANDLE_VALUE) {
        return 0;
    }
    SYSTEMTIME st;
    GetSystemTime(&st);
    FILETIME ft;
    SystemTimeToFileTime(&st, &ft);
    const BOOL ok = SetFileTime(h, nullptr, nullptr, &ft);
    CloseHandle(h);
    return ok ? 1 : 0;
#else
    int fd = open(path, O_WRONLY | O_CREAT, 0666);
    if (fd < 0) {
        return 0;
    }
    close(fd);
    return utimes(path, nullptr) == 0 ? 1 : 0;
#endif
}

// ---- Directory / filesystem metadata (spec 34.4). ----
// The directory's entries as a NUL-terminated, newline-separated string ("" if not a directory or
// empty). *outLen is the byte length. "." and ".." are skipped.
#ifdef _WIN32
char* __polaron_dir_list(const char* path, long long* outLen) {
    char pattern[MAX_PATH];
    snprintf(pattern, sizeof(pattern), "%s\\*", path);
    WIN32_FIND_DATAA fd;
    HANDLE h = FindFirstFileA(pattern, &fd);
    size_t cap = 256, len = 0;
    // __polaron_malloc AND NOT std::malloc: this block becomes a Polaron String, and a String frees
    // its bytes through __polaron_free, which reads the sixteen-byte header in FRONT of the payload.
    // In front of a libc block those bytes belong to somebody else -- very often the tail of a freed
    // Polaron block, stamped POLARON_FREED, so the double-free guard fires on a program that has not
    // double freed anything. This was found once already, in File.readAll, and fixed there; listDir
    // was the same call one function over and was left behind.
    char* buf = static_cast<char*>(__polaron_malloc(cap));
    if (h != INVALID_HANDLE_VALUE) {
        do {
            if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0) {
                continue;
            }
            size_t nl = strlen(fd.cFileName);
            if (len + nl + 2 > cap) {
                while (len + nl + 2 > cap) {
                    cap *= 2;
                }
                buf = static_cast<char*>(__polaron_realloc(buf, cap));
            }
            memcpy(buf + len, fd.cFileName, nl);
            len += nl;
            buf[len++] = '\n';
        } while (FindNextFileA(h, &fd));
        FindClose(h);
    }
    buf[len] = 0;
    *outLen = static_cast<long long>(len);
    return buf;
}
int __polaron_mkdir(const char* path) { return CreateDirectoryA(path, nullptr) ? 1 : 0; }
int __polaron_rename(const char* from, const char* to) { return MoveFileA(from, to) ? 1 : 0; }
int __polaron_is_dir(const char* path) {
    DWORD a = GetFileAttributesA(path);
    return (a != INVALID_FILE_ATTRIBUTES && (a & FILE_ATTRIBUTE_DIRECTORY)) ? 1 : 0;
}
long long __polaron_file_size(const char* path) {
    WIN32_FILE_ATTRIBUTE_DATA d;
    if (!GetFileAttributesExA(path, GetFileExInfoStandard, &d)) {
        return -1;
    }
    return (static_cast<long long>(d.nFileSizeHigh) << 32) | static_cast<long long>(d.nFileSizeLow);
}
#else
char* __polaron_dir_list(const char* path, long long* outLen) {
    DIR* d = opendir(path);
    size_t cap = 256, len = 0;
    char* buf = static_cast<char*>(__polaron_malloc(cap));   // see the Windows branch: this becomes a String
    if (d != nullptr) {
        struct dirent* e;
        while ((e = readdir(d)) != nullptr) {
            if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
            size_t nl = strlen(e->d_name);
            if (len + nl + 2 > cap) { while (len + nl + 2 > cap) cap *= 2; buf = static_cast<char*>(__polaron_realloc(buf, cap)); }
            memcpy(buf + len, e->d_name, nl);
            len += nl;
            buf[len++] = '\n';
        }
        closedir(d);
    }
    buf[len] = 0;
    *outLen = static_cast<long long>(len);
    return buf;
}
int __polaron_mkdir(const char* path) { return mkdir(path, 0777) == 0 ? 1 : 0; }
int __polaron_rename(const char* from, const char* to) { return rename(from, to) == 0 ? 1 : 0; }
int __polaron_is_dir(const char* path) {
    struct stat st;
    return (stat(path, &st) == 0 && S_ISDIR(st.st_mode)) ? 1 : 0;
}
long long __polaron_file_size(const char* path) {
    struct stat st;
    if (stat(path, &st) != 0) return -1;
    return static_cast<long long>(st.st_size);
}
#endif

// Decimal text of `v` into `buf` (no NUL needed), returns the length. For float.toString() and
// double.toString(). %g is the same format string interpolation already uses for a float, so
// `$"{x}"` and `x.toString()` never disagree about how a number looks.
long long __polaron_ftoa(double v, char* buf) {
    int n = snprintf(buf, 32, "%g", v);
    if (n < 0) { n = 0; }
    if (n > 31) { n = 31; }
    return static_cast<long long>(n);
}

// Decimal text of `n` into `buf` (signed, no NUL needed), returns the digit count. For int.toString().
long long __polaron_itoa(long long n, char* buf) {
    char tmp[24];
    int i = 0;
    int neg = (n < 0);
    unsigned long long u = neg ? static_cast<unsigned long long>((-(n + 1))) + 1ULL : static_cast<unsigned long long>(n);
    if (u == 0) { tmp[i++] = '0'; }
    while (u > 0) { tmp[i++] = static_cast<char>(('0' + (u % 10))); u /= 10; }
    long long len = 0;
    if (neg) { buf[len++] = '-'; }
    while (i > 0) { buf[len++] = tmp[--i]; }
    buf[len] = 0;
    return len;
}

// ---- String methods (spec 34.5): search + transforms over byte buffers. ----
long long __polaron_str_index(const char* h, long long hl, const char* n, long long nl) {
    if (nl == 0) {
        return 0;
    }
    if (nl > hl) {
        return -1;
    }
    for (long long i = 0; i + nl <= hl; i++) {
        long long j = 0;
        while (j < nl && h[i + j] == n[j]) {
            j++;
        }
        if (j == nl) {
            return i;
        }
    }
    return -1;
}
int __polaron_str_ends(const char* h, long long hl, const char* n, long long nl) {
    if (nl > hl) {
        return 0;
    }
    return memcmp(h + (hl - nl), n, static_cast<size_t>(nl)) == 0 ? 1 : 0;
}
char* __polaron_str_upper(const char* d, long long len) {
    char* b = static_cast<char*>(__polaron_malloc(static_cast<size_t>(len) + 1));   // __polaron_malloc so String RAII can __polaron_free it
    for (long long i = 0; i < len; i++) { char c = d[i]; b[i] = (c >= 'a' && c <= 'z') ? static_cast<char>((c - 32)) : c; }
    b[len] = 0;
    return b;
}
char* __polaron_str_lower(const char* d, long long len) {
    char* b = static_cast<char*>(__polaron_malloc(static_cast<size_t>(len) + 1));
    for (long long i = 0; i < len; i++) { char c = d[i]; b[i] = (c >= 'A' && c <= 'Z') ? static_cast<char>((c + 32)) : c; }
    b[len] = 0;
    return b;
}
char* __polaron_str_trim(const char* d, long long len, long long* outLen) {
    long long s = 0, e = len;
    while (s < e && (d[s] == ' ' || d[s] == '\t' || d[s] == '\n' || d[s] == '\r')) {
        s++;
    }
    while (e > s && (d[e - 1] == ' ' || d[e - 1] == '\t' || d[e - 1] == '\n' || d[e - 1] == '\r')) {
        e--;
    }
    long long n = e - s;
    char* b = static_cast<char*>(__polaron_malloc(static_cast<size_t>(n) + 1));
    memcpy(b, d + s, static_cast<size_t>(n));
    b[n] = 0;
    *outLen = n;
    return b;
}
char* __polaron_str_repeat(const char* d, long long len, long long count, long long* outLen) {
    if (count < 0) {
        count = 0;
    }
    long long n = len * count;
    char* b = static_cast<char*>(__polaron_malloc(static_cast<size_t>(n) + 1));
    for (long long k = 0; k < count; k++) {
        memcpy(b + k * len, d, static_cast<size_t>(len));
    }
    b[n] = 0;
    *outLen = n;
    return b;
}
// (The scope-based String RAII pair -- `__polaron_str_copy` / `__polaron_str_free` -- moved into
//  polaron_alloc_core.hpp beside the allocator they are built on. They are emitted by codegen at every
//  store to a String field or element, so a target without them cannot hold a String at all; that is
//  what kept a WebAssembly program from linking once the heap itself was already shared. `PolaronStr`
//  is declared there too, once, instead of inside each function that reads it.)

// Content equality of two String objects, length-aware (the data buffer need not be NUL-terminated,
// so this is correct where strcmp is not). Returns 1 if equal, 0 otherwise. Null-safe: two nulls are
// equal; null vs non-null is not. Backs the `==`/`!=` operators on String/string (spec 4).
int __polaron_str_eq(void* a, void* b) {
    if (a == b) {
        return 1;
    }
    if (a == nullptr || b == nullptr) {
        return 0;
    }
    struct PolaronStr { long long len; char* data; long long hash; };
    PolaronStr* x = static_cast<PolaronStr*>(a);
    PolaronStr* y = static_cast<PolaronStr*>(b);
    if (x->len != y->len) {
        return 0;
    }
    return memcmp(x->data, y->data, static_cast<size_t>(x->len)) == 0 ? 1 : 0;
}

// FNV-1a hash of `len` bytes, for Hashable<String> (collections).
long long __polaron_str_hash(const char* data, long long len) {
    unsigned long long h = 1469598103934665603ULL;  // FNV offset basis
    for (long long i = 0; i < len; i++) {
        h ^= static_cast<unsigned char>(data[i]);
        h *= 1099511628211ULL;  // FNV prime
    }
    return static_cast<long long>(h);
}

// Cached String hash. A String object is laid out { i64 length, char* data, i64 hash } by the codegen;
// the trailing hash is a lazily-filled FNV-1a of the bytes (0 = not computed). Since a String is
// immutable, it is hashed at most once -- the hot path (HashMap<String,...>) then just reads the field.
// A genuine hash of 0 is stored as 1 so a populated cache always reads non-zero.
long long __polaron_str_hash_obj(void* obj) {
    struct PolaronStr { long long len; char* data; long long hash; };
    PolaronStr* s = static_cast<PolaronStr*>(obj);
    if (s->hash != 0) {
        return s->hash;
    }
    long long h = __polaron_str_hash(s->data, s->len);
    if (h == 0) {
        h = 1;
    }
    s->hash = h;
    return h;
}

// await from non-async code (e.g. main): block the calling thread until the task completes.
long long __polaron_task_wait(long long handle) {
    polaron_task* t = reinterpret_cast<polaron_task*>(handle);
    if (t == nullptr) {
        return 0;
    }
    __polaron_pool_start();
    EnterCriticalSection(&g_qlock);
    while (!t->done) {
        SleepConditionVariableCS(&g_donecond, &g_qlock, INFINITE);
    }
    LeaveCriticalSection(&g_qlock);
    return t->result;
}

// The overwrite/restore length for a function: bounded by the next function's address in
// the program-wide table, so a neighbour is never touched. Capped for safety.
static size_t __polaron_fn_len(void* fn, void** table, long long count) {
    unsigned long long base = reinterpret_cast<unsigned long long>(fn), next = 0;
    for (long long i = 0; i < count; i++) {
        unsigned long long a = reinterpret_cast<unsigned long long>(table[i]);
        if (a > base && (next == 0 || a < next)) {
            next = a;
        }
    }
    unsigned long long len = next ? (next - base) : 64;
    return static_cast<size_t>((len > 4096 ? 4096 : len));
}

// Make a function's code writable+executable. mprotect needs page-aligned bounds, so the POSIX
// side rounds the range out to page boundaries.
static int __polaron_code_unprotect(void* fn, size_t len) {
#ifdef _WIN32
    DWORD old;
    return VirtualProtect(fn, len, PAGE_EXECUTE_READWRITE, &old) ? 1 : 0;
#else
    long page = sysconf(_SC_PAGESIZE);
    if (page <= 0) page = 4096;
    uintptr_t start = reinterpret_cast<uintptr_t>(fn) & ~(static_cast<uintptr_t>(page) - 1);
    uintptr_t end = (reinterpret_cast<uintptr_t>(fn) + len + static_cast<uintptr_t>(page) - 1) & ~(static_cast<uintptr_t>(page) - 1);
    return mprotect(reinterpret_cast<void*>(start), end - start, PROT_READ | PROT_WRITE | PROT_EXEC) == 0 ? 1 : 0;
#endif
}
static void __polaron_code_flush(void* fn, size_t len) {
#ifdef _WIN32
    FlushInstructionCache(GetCurrentProcess(), fn, len);
#else
    __builtin___clear_cache(static_cast<char*>(fn), static_cast<char*>(fn) + len);  // no-op on x86, required on ARM
#endif
}

// Physical code unload (spec 30 "unloading agressivo"): overwrite a function's machine code
// in RAM with int3 (0xCC), so the instructions are physically ripped from memory.
void __polaron_unload_fn(void* fn, void** table, long long count) {
    if (fn == nullptr) {
        return;
    }
    size_t len = __polaron_fn_len(fn, table, count);
    if (__polaron_code_unprotect(fn, len)) {
        memset(fn, 0xCC, len);
        __polaron_code_flush(fn, len);
    }
}

// Physical code reload for reimport (spec 30.3 "recarrega do disco"): read the function's
// original bytes from the program's own executable on disk (the image file still holds them) and
// write them back over the int3-overwritten RAM. x64 code is RIP-relative, so the .text
// bytes are position-independent within the module and need no relocation fix-up.
#ifdef _WIN32
void __polaron_reload_fn(void* fn, void** table, long long count) {
    if (fn == nullptr) {
        return;
    }
    size_t len = __polaron_fn_len(fn, table, count);
    unsigned char* mbase = reinterpret_cast<unsigned char*>(GetModuleHandleW(nullptr));
    DWORD rva = static_cast<DWORD>((static_cast<unsigned char*>(fn) - mbase));
    IMAGE_DOS_HEADER* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(mbase);
    IMAGE_NT_HEADERS* nt = reinterpret_cast<IMAGE_NT_HEADERS*>((mbase + dos->e_lfanew));
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
    if (!found) {
        return;
    }
    wchar_t path[MAX_PATH];
    if (GetModuleFileNameW(nullptr, path, MAX_PATH) == 0) {
        return;
    }
    HANDLE h = CreateFileW(path, GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, 0, nullptr);
    if (h == INVALID_HANDLE_VALUE) {
        return;
    }
    unsigned char* buf = static_cast<unsigned char*>(std::malloc(len));
    LARGE_INTEGER off;
    off.QuadPart = fileOff;
    DWORD got = 0;
    if (buf != nullptr && SetFilePointerEx(h, off, nullptr, FILE_BEGIN)) {
        ReadFile(h, buf, static_cast<DWORD>(len), &got, nullptr);
    }
    CloseHandle(h);
    if (buf != nullptr && got > 0 && __polaron_code_unprotect(fn, len)) {
        memcpy(fn, buf, got);
        __polaron_code_flush(fn, len);
    }
    std::free(buf);
}
#else
// ELF mirror of the PE logic: the main module's load base comes from dl_iterate_phdr (the first
// visited module -- the executable, PIE included), the vaddr->file-offset mapping from its PT_LOAD
// program headers, and the bytes from /proc/self/exe.
static int __polaron_main_base_cb(struct dl_phdr_info* info, size_t, void* out) {
    *static_cast<uintptr_t*>(out) = static_cast<uintptr_t>(info->dlpi_addr);
    return 1;  // stop after the first entry (the main executable)
}
void __polaron_reload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    size_t len = __polaron_fn_len(fn, table, count);
    uintptr_t base = 0;
    dl_iterate_phdr(__polaron_main_base_cb, &base);
    uintptr_t vaddr = reinterpret_cast<uintptr_t>(fn) - base;  // the link-time virtual address of the function
    // Three ways out of this method used to carry their own `fclose`, and the buffer its own `free`.
    // The handle and the buffer now own themselves, so a fourth way out added later cannot leak.
    //
    // Through `__polaron_executable_path` rather than `/proc/self/exe` spelled here: FreeBSD does not
    // mount procfs by default, so the literal path opens nothing and `reimport` silently does not
    // reload -- a feature that fails by doing nothing is the worst way for one to fail.
    char* selfPath = __polaron_executable_path();
    StdioFile exe(selfPath != nullptr && selfPath[0] != 0 ? selfPath : "/proc/self/exe", "rb");
    std::free(selfPath);
    if (!exe.isOpen()) {
        return;
    }
    ElfW(Ehdr) eh;
    if (std::fread(&eh, 1, sizeof eh, exe.get()) != sizeof eh) {
        return;
    }
    long long fileOff = -1;
    for (int i = 0; i < eh.e_phnum; i++) {
        ElfW(Phdr) ph;
        const long entry = static_cast<long>(eh.e_phoff + static_cast<unsigned long long>(i) * eh.e_phentsize);
        if (std::fseek(exe.get(), entry, SEEK_SET) != 0) {
            break;
        }
        if (std::fread(&ph, 1, sizeof ph, exe.get()) != sizeof ph) {
            break;
        }
        if (ph.p_type == PT_LOAD && vaddr >= ph.p_vaddr && vaddr < ph.p_vaddr + ph.p_filesz) {
            fileOff = static_cast<long long>(vaddr - ph.p_vaddr + ph.p_offset);
            break;
        }
    }
    if (fileOff < 0) {
        return;
    }
    std::vector<unsigned char> buf(len);
    size_t got = 0;
    if (std::fseek(exe.get(), static_cast<long>(fileOff), SEEK_SET) == 0) {
        got = std::fread(buf.data(), 1, len, exe.get());
    }
    if (got > 0 && __polaron_code_unprotect(fn, len)) {
        std::memcpy(fn, buf.data(), got);
        __polaron_code_flush(fn, len);
    }
}
#endif

// A foreign function in the object-oriented-C idiom: the object comes FIRST, as `self`. This is what a
// non-static `extern` models -- and it is the same shape as a C++ member function's hidden `this`,
// which is why `cppdecl` needs the receiver even without a mangler. Used by the FFI tests.
int polaron_counter_add(void* self, int by) {
    int* count = static_cast<int*>(self);
    *count += by;
    return *count;
}

// FFI by-value struct test helpers (spec 26): a small POD struct passed and returned by value,
// matching the layout of a Polaron `struct Point { int x; int y; }`.
struct PolaronPoint { int x; int y; };
int polaron_point_sum(struct PolaronPoint p) { return p.x + p.y; }
struct PolaronPoint polaron_point_scale(struct PolaronPoint p, int k) {
    struct PolaronPoint r;
    r.x = p.x * k;
    r.y = p.y * k;
    return r;
}

// Reads one line from stdin into a freshly allocated, null-terminated buffer (the trailing newline is
// stripped). The byte length is returned through out_len. The general Console.read() input primitive:
// it returns a String, which the program parses (e.g. toInt) for other types.
char* polaron_read_line(int64_t* out_len) {
    size_t cap = 128, len = 0;
    char* buf = static_cast<char*>(std::malloc(cap));
    int c;
    while ((c = getchar()) != EOF && c != '\n') {
        if (len + 1 >= cap) { cap *= 2; buf = static_cast<char*>(std::realloc(buf, cap)); }
        buf[len++] = static_cast<char>(c);
    }
    buf[len] = '\0';
    if (out_len) {
        *out_len = static_cast<int64_t>(len);
    }
    return buf;
}

// FFI callback test helper (spec 26): a C function that takes a raw function pointer and calls it.
int polaron_apply_cb(int (*f)(int), int x) { return f(x); }

// ---- `--test` runner support (spec 32.11) ----
// The runner itself is synthesized as LLVM IR by codegen, but its argument policy and report
// formatting live here: they are ordinary string handling, and open-coding them in IR would make
// every later change (a new flag, a new output format) an exercise in basic-block plumbing.
// Verdicts are 0 = pass, 1 = fail, 2 = skip.
//
// Default output is DETERMINISTIC on purpose -- a test report is diffed, pasted into a review, and
// compared against a golden file, so durations are opt-in behind --timing rather than on by default.
// The file stdout is diverted into while a test's output is captured. Its name is
// ".pol-capture-<pid>": the Polaron side (Test.captureOutput) reads it back with the ordinary File
// builtin rather than needing a way to receive a C string, so the two sides have to agree on the
// name -- and they agree on the RULE, not on a constant, so two test binaries running in the same
// directory do not clobber each other's capture.
static int polaron_capture_id(void) {
#ifdef _WIN32
    return static_cast<int>(GetCurrentProcessId());
#else
    return static_cast<int>(getpid());
#endif
}
POLARON_RT_API int __polaron_capture_id(void) { return polaron_capture_id(); }

static const char* polaron_capture_path(void) {
    static char path[64];
    if (path[0] == 0) {
        snprintf(path, sizeof path, ".pol-capture-%d", polaron_capture_id());
    }
    return path;
}
#define POLARON_CAPTURE_PATH polaron_capture_path()

static const char* g_test_filter = nullptr;
static const char* g_test_tag = nullptr;    // --tag: only tests carrying it
static const char* g_test_extag = nullptr;  // --exclude-tag: everything but those
static int g_test_list_only = 0;
static int g_test_timing = 0;
static int g_test_json = 0;
static int g_test_failfast = 0;
static int g_test_bench = 0;               // --bench: run [Benchmark] methods too
static int g_test_update_golden = 0;
static int g_test_pass = 0;
static int g_test_fail = 0;
static int g_test_skip = 0;
static int g_test_xfail = 0;               // expected failures that did fail (counted as passes)
static long long g_test_ns = 0;
static const char* g_test_current = nullptr;  // the test being run, for the failure header
static int g_test_header_done = 0;         // its "FAIL <name>" header has already been printed
static int g_test_expect_fail = 0;         // the running test is [ExpectedToFail]
static int g_test_json_first = 1;          // no record emitted yet, so no separating comma

// ---- stdout capture ----
// Used twice over: by Test.captureOutput, and by --format=json, where a test's own printing would
// otherwise land in the middle of the JSON and corrupt it. A small save stack so the two can nest.
static int g_cap_saved[4];
static FILE* g_cap_file[4];
static int g_cap_depth = 0;

static void polaron_capture_push(void) {
    if (g_cap_depth >= 4) {
        return;
    }
    fflush(stdout);
#ifdef _WIN32
    g_cap_saved[g_cap_depth] = _dup(_fileno(stdout));
#else
    g_cap_saved[g_cap_depth] = dup(fileno(stdout));
#endif
    FILE* f = fopen(POLARON_CAPTURE_PATH, "w+");
    if (f == nullptr) {
        g_cap_saved[g_cap_depth] = -1;
        g_cap_file[g_cap_depth] = nullptr;
        g_cap_depth++;
        return;
    }
    g_cap_file[g_cap_depth] = f;
#ifdef _WIN32
    _dup2(_fileno(f), _fileno(stdout));
#else
    dup2(fileno(f), fileno(stdout));
#endif
    g_cap_depth++;
}

// Restores stdout and returns the captured bytes in `buf` (caller-owned, NUL-terminated) or 0.
static char* polaron_capture_pop(void) {
    if (g_cap_depth <= 0) {
        return nullptr;
    }
    g_cap_depth--;
    fflush(stdout);
    const int saved = g_cap_saved[g_cap_depth];
    FILE* f = g_cap_file[g_cap_depth];
    if (saved >= 0) {
#ifdef _WIN32
        _dup2(saved, _fileno(stdout));
        _close(saved);
#else
        dup2(saved, fileno(stdout));
        close(saved);
#endif
    }
    if (f == nullptr) {
        return nullptr;
    }
    fseek(f, 0, SEEK_END);
    long n = ftell(f);
    if (n < 0) {
        n = 0;
    }
    fseek(f, 0, SEEK_SET);
    char* buf = static_cast<char*>(std::malloc(static_cast<size_t>(n) + 1));
    if (buf == nullptr) {
        fclose(f);
        return nullptr;
    }
    size_t got = fread(buf, 1, static_cast<size_t>(n), f);
    buf[got] = 0;
    fclose(f);
    return buf;
}

// Test.captureOutput brackets its action with these; it then reads POLARON_CAPTURE_PATH itself, which
// pop() has already flushed and closed.
POLARON_RT_API void __polaron_capture_begin(void) { polaron_capture_push(); }
POLARON_RT_API void __polaron_capture_end(void) { std::free(polaron_capture_pop()); }
// Whether `--update-golden` was passed, so Test.assertMatchesGolden rewrites instead of comparing.
POLARON_RT_API int __polaron_test_update_golden(void) { return g_test_update_golden; }

static void polaron_json_string(const char* s) {
    putchar('"');
    for (const char* p = s != nullptr ? s : ""; *p != 0; p++) {
        const unsigned char c = static_cast<unsigned char>(*p);
        if (c == '"' || c == '\\') { putchar('\\'); putchar(static_cast<char>(c));
        } else if (c == '\n') {
            fputs("\\n", stdout);
        } else if (c == '\r') {
            fputs("\\r", stdout);
        } else if (c == '\t') {
            fputs("\\t", stdout);
        } else if (c < 0x20) {
            printf("\\u%04x", c);
        } else {
            putchar(static_cast<char>(c));
        }
    }
    putchar('"');
}

// Parses the runner's own command line. Unknown arguments are ignored: a project may pass its
// program's flags through `polaron test` and they are none of the runner's business.
POLARON_RT_API void __polaron_test_begin(int argc, char** argv) {
    for (int i = 1; i < argc; i++) {
        const char* a = argv[i];
        if (strcmp(a, "--list") == 0) {
            g_test_list_only = 1;
        } else if (strcmp(a, "--timing") == 0) {
            g_test_timing = 1;
        } else if (strcmp(a, "--fail-fast") == 0) {
            g_test_failfast = 1;
        } else if (strcmp(a, "--bench") == 0) {
            g_test_bench = 1;
        } else if (strcmp(a, "--update-golden") == 0) {
            g_test_update_golden = 1;
        } else if (strcmp(a, "--format=json") == 0) {
            g_test_json = 1;
        } else if (strcmp(a, "--format") == 0 && i + 1 < argc && strcmp(argv[i + 1], "json") == 0) {
            g_test_json = 1;
            i++;
        } else if (strcmp(a, "--filter") == 0 && i + 1 < argc) {
            g_test_filter = argv[++i];
        } else if (strncmp(a, "--filter=", 9) == 0) {
            g_test_filter = a + 9;
        } else if (strcmp(a, "--tag") == 0 && i + 1 < argc) {
            g_test_tag = argv[++i];
        } else if (strncmp(a, "--tag=", 6) == 0) {
            g_test_tag = a + 6;
        } else if (strcmp(a, "--exclude-tag") == 0 && i + 1 < argc) {
            g_test_extag = argv[++i];
        } else if (strncmp(a, "--exclude-tag=", 14) == 0) {
            g_test_extag = a + 14;
        }
    }
    if (g_test_json && !g_test_list_only) {
        fputs("{\"tests\":[", stdout);
    }
}

// `tags` is the comma-joined list of a test's [Tag] names ("" when it carries none). Matched as whole
// entries, so --tag=slow does not also select "slower".
static int polaron_has_tag(const char* tags, const char* want) {
    if (tags == nullptr || want == nullptr || *want == 0) {
        return 0;
    }
    const size_t n = strlen(want);
    for (const char* p = tags; *p != 0;) {
        const char* e = strchr(p, ',');
        const size_t len = e != nullptr ? static_cast<size_t>((e - p)) : strlen(p);
        if (len == n && strncmp(p, want, n) == 0) {
            return 1;
        }
        if (e == nullptr) {
            break;
        }
        p = e + 1;
    }
    return 0;
}

// Whether this test should run. Under --list it prints the name and answers no, so the runner needs
// only ONE code path: nothing runs, and a class's [BeforeAll] fixture is never paid for -- which is
// the whole point of listing. Under --fail-fast it answers no once something has failed, which stops
// the run without the emitted code needing an early exit.
// Whether the run has been called off. Asked immediately BEFORE each test, because selection is
// decided for a whole class up front (to know whether its [BeforeAll] fixture is needed at all) and
// at that point nothing has failed yet. [AfterAll] still runs, so an abort does not leak the fixture.
POLARON_RT_API int __polaron_test_aborted(void) { return g_test_failfast && g_test_fail > 0; }

POLARON_RT_API int __polaron_test_should_run(const char* name, const char* tags) {
    if (g_test_filter != nullptr && strstr(name, g_test_filter) == nullptr) {
        return 0;
    }
    if (g_test_tag != nullptr && !polaron_has_tag(tags, g_test_tag)) {
        return 0;
    }
    if (g_test_extag != nullptr && polaron_has_tag(tags, g_test_extag)) {
        return 0;
    }
    if (g_test_list_only) {
        printf("%s%s%s\n", name, (tags != nullptr && *tags != 0) ? "  #" : "",
               (tags != nullptr && *tags != 0) ? tags : "");
        return 0;
    }
    return 1;
}

// "Class.method[3]" for one row of a [Cases] test. A static buffer: the name is consumed immediately,
// by the very next start/record call.
POLARON_RT_API const char* __polaron_test_case_name(const char* base, long long index) {
    static char buf[512];
    snprintf(buf, sizeof buf, "%s[%lld]", base != nullptr ? base : "", index);
    return buf;
}

// Called just before a test runs. Names it, so the first failing assertion inside it can print the
// "FAIL <name>" header ITSELF -- otherwise every detail line lands above the verdict it belongs to,
// and the report reads backwards. Under --format=json it also diverts the test's own printing, which
// would otherwise land in the middle of the JSON.
POLARON_RT_API void __polaron_test_start(const char* name, int expectFail) {
    g_test_current = name;
    g_test_header_done = 0;
    g_test_expect_fail = expectFail;
    if (g_test_json) {
        polaron_capture_push();
    }
}

// Called by Test.mark() before it prints a failure detail: emits the header once per test. An
// [ExpectedToFail] test is headed XFAIL, because its failure is the expected outcome and calling it
// FAIL here and XFAIL two lines later reads as a contradiction.
POLARON_RT_API void __polaron_test_detail(void) {
    if (g_test_header_done) {
        return;
    }
    g_test_header_done = 1;
    if (!g_test_json) {
        printf("%s %s\n", g_test_expect_fail ? "XFAIL" : "FAIL",
               g_test_current != nullptr ? g_test_current : "");
    }
}

// Reported after every repeat of a [Repeat] test that failed, so "it fails 3 times in 100" is visible
// rather than just "it failed".
POLARON_RT_API void __polaron_test_repeat_failed(long long iteration) {
    if (!g_test_json) {
        printf("  failed on repeat %lld\n", iteration);
    }
}

// verdict: 0 pass, 1 fail, 2 skip, 3 expected failure (counts as a pass), 4 expected to fail but
// passed (counts as a failure -- the bug got fixed and the annotation is now a lie).
// budgetNs > 0 turns a pass that overran a [MaxTime] budget into a failure.
POLARON_RT_API void __polaron_test_record(const char* name, int verdict, long long ns, const char* why,
                                    long long budgetNs) {
    g_test_ns += ns;
    const int headed = g_test_header_done;
    g_test_header_done = 0;
    char* captured = g_test_json ? polaron_capture_pop() : nullptr;
    int over = 0;
    if (budgetNs > 0 && ns > budgetNs && (verdict == 0 || verdict == 3)) { verdict = 1; over = 1; }

    const char* tag = verdict == 2   ? "SKIP"
                      : verdict == 3 ? "XFAIL"
                      : verdict == 4 ? "FAIL"
                      : verdict == 1 ? "FAIL"
                                     : "PASS";
    if (verdict == 2) {
        g_test_skip++;
    } else if (verdict == 3) {
        g_test_xfail++;
        g_test_pass++;
    } else if (verdict == 1 || verdict == 4) {
        g_test_fail++;
    } else {
        g_test_pass++;
    }

    if (g_test_json) {
        if (!g_test_json_first) {
            putchar(',');
        }
        g_test_json_first = 0;
        fputs("{\"name\":", stdout);
        polaron_json_string(name);
        printf(",\"status\":\"%s\",\"ns\":%lld", tag, ns);
        if (verdict == 2) { fputs(",\"reason\":", stdout); polaron_json_string(why); }
        if (verdict == 4) {
            fputs(",\"reason\":\"expected to fail but passed\"", stdout);
        }
        if (over) {
            printf(",\"reason\":\"over budget: %.1f ms of %.1f ms\"", static_cast<double>(ns) / 1e6,
                   static_cast<double>(budgetNs) / 1e6);
        }
        if (captured != nullptr && *captured != 0) {
            fputs(",\"output\":", stdout);
            polaron_json_string(captured);
        }
        putchar('}');
        std::free(captured);
        return;
    }
    std::free(captured);

    if (verdict == 2) {
        printf("SKIP %s -- %s\n", name, (why != nullptr && *why != 0) ? why : "no reason given");
        return;
    }
    if (verdict == 4) {
        printf("FAIL %s -- expected to fail but passed; the annotation is now a lie\n", name);
        return;
    }
    if (over) {
        printf("  over budget: took %.1f ms of %.1f ms\n", static_cast<double>(ns) / 1e6, static_cast<double>(budgetNs) / 1e6);
    }
    if ((verdict == 1 || verdict == 3 || over) && headed) {
        if (g_test_timing) {
            printf("  (%.1f ms)\n", static_cast<double>(ns) / 1000000.0);
        }
        return;
    }
    if (g_test_timing) {
        printf("%s %s (%.1f ms)\n", tag, name, static_cast<double>(ns) / 1000000.0);
    } else {
        printf("%s %s\n", tag, name);
    }
}

// ---- benchmarks ([Benchmark], run only under --bench) ----
static int g_bench_count = 0;

POLARON_RT_API int __polaron_bench_should_run(const char* name) {
    if (!g_test_bench) {
        return 0;
    }
    if (g_test_filter != nullptr && strstr(name, g_test_filter) == nullptr) {
        return 0;
    }
    if (g_test_list_only) { printf("%s  (benchmark)\n", name); return 0; }
    return 1;
}

POLARON_RT_API void __polaron_bench_record(const char* name, long long totalNs, long long iterations) {
    g_bench_count++;
    const double per = iterations > 0 ? static_cast<double>(totalNs) / static_cast<double>(iterations) : 0.0;
    if (g_test_json) {
        if (!g_test_json_first) {
            putchar(',');
        }
        g_test_json_first = 0;
        fputs("{\"name\":", stdout);
        polaron_json_string(name);
        printf(",\"status\":\"BENCH\",\"iterations\":%lld,\"nsPerOp\":%.1f}", iterations, per);
        return;
    }
    printf("BENCH %s  %.1f ns/op  (%lld iterations)\n", name, per, iterations);
}

// Prints the summary and returns the process exit code: non-zero if anything failed.
POLARON_RT_API int __polaron_test_summary(void) {
    if (g_test_list_only) {
        return 0;
    }
    if (g_test_json) {
        printf("],\"summary\":{\"passed\":%d,\"failed\":%d,\"skipped\":%d,\"expectedFailures\":%d,"
               "\"benchmarks\":%d,\"ns\":%lld}}\n",
               g_test_pass, g_test_fail, g_test_skip, g_test_xfail, g_bench_count, g_test_ns);
        return g_test_fail != 0 ? 1 : 0;
    }
    printf("tests: %d passed, %d failed, %d skipped", g_test_pass, g_test_fail, g_test_skip);
    if (g_test_xfail > 0) {
        printf(", %d expected to fail", g_test_xfail);
    }
    if (g_test_timing) {
        printf(" in %.1f ms", static_cast<double>(g_test_ns) / 1000000.0);
    }
    putchar('\n');
    remove(POLARON_CAPTURE_PATH);
    return g_test_fail != 0 ? 1 : 0;
}

// The C string inside a Polaron String, for the few places a runtime helper takes one (the skip
// reason). Null-safe: an unset String reads as empty rather than crashing the report.
POLARON_RT_API const char* __polaron_str_cstr(void* s) {
    struct PolaronStr { long long len; char* data; long long hash; };
    if (s == nullptr) {
        return "";
    }
    const char* d = (static_cast<PolaronStr*>(s))->data;
    return d != nullptr ? d : "";
}

#ifdef __cplusplus
}  // extern "C"
#endif


