// LDP3 minimal runtime: thread support (spec 20.1), defined-behaviour panic, and the
// physical code unload/reload behind unimport/reimport (spec 30). Linked into every exe.

#define _CRT_SECURE_NO_WARNINGS  // fopen/remove etc. are used deliberately (File I/O, spec 34.4)
#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>   // must precede <windows.h>
#include <ws2tcpip.h>
#include <windows.h>
#pragma comment(lib, "ws2_32.lib")
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Defined-behaviour panic: LDP3 never invokes UB. When a check fails (division by zero,
// out-of-bounds, etc.) the program terminates deterministically with a message instead of
// continuing into undefined territory.
void __ldp3_panic(const char* msg) {
    fprintf(stderr, "LDP3 panic: %s\n", msg);
    fflush(stderr);
    exit(70);
}

// OS threads (spec 20.1 Thread). A function value is a pointer to a closure {code, env};
// the trampoline loads code/env and calls code(env) (env is the first argument).
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

// ---- async/await: tasks + worker pool (spec 20.2) -----------------------------------------
// A task is the handle to an async computation. `resume`/`state` are the state machine to run;
// `waiter_*` is the continuation scheduled when this task completes (set by __ldp3_await).
typedef void (*ldp3_resume_fn)(void* state);
typedef struct ldp3_task {
    volatile long done;
    long long result;
    ldp3_resume_fn waiter_fn;
    void* waiter_state;
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

static DWORD WINAPI __ldp3_worker(LPVOID unused) {
    (void)unused;
    for (;;) {
        EnterCriticalSection(&g_qlock);
        while (g_qhead == g_qtail) SleepConditionVariableCS(&g_qcond, &g_qlock, INFINITE);
        ldp3_work w = g_queue[g_qhead];
        g_qhead = (g_qhead + 1) % LDP3_QCAP;
        LeaveCriticalSection(&g_qlock);
        w.fn(w.state);  // resume the state machine; it may complete or re-suspend the task
    }
}

static void __ldp3_pool_start(void) {
    if (g_pool_started) return;
    g_pool_started = 1;
    InitializeCriticalSection(&g_qlock);
    InitializeConditionVariable(&g_qcond);
    InitializeConditionVariable(&g_donecond);
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    int n = (int)si.dwNumberOfProcessors;
    if (n < 2) n = 2;
    if (n > 16) n = 16;
    for (int i = 0; i < n; i++) CloseHandle(CreateThread(NULL, 0, __ldp3_worker, NULL, 0, NULL));
}

void __ldp3_schedule(ldp3_resume_fn fn, void* state) {
    __ldp3_pool_start();
    EnterCriticalSection(&g_qlock);
    g_queue[g_qtail] = (ldp3_work){fn, state};
    g_qtail = (g_qtail + 1) % LDP3_QCAP;
    LeaveCriticalSection(&g_qlock);
    WakeConditionVariable(&g_qcond);
}

long long __ldp3_task_new(void) {
    ldp3_task* t = (ldp3_task*)calloc(1, sizeof(ldp3_task));
    return (long long)t;
}

// Called by an async body when it produces its value: record the result, mark done, and
// schedule the continuation (the task that awaited this one), if any.
void __ldp3_task_complete(long long handle, long long value) {
    ldp3_task* t = (ldp3_task*)handle;
    if (t == NULL) return;
    t->result = value;
    EnterCriticalSection(&g_qlock);
    t->done = 1;
    ldp3_resume_fn wf = t->waiter_fn;
    void* ws = t->waiter_state;
    LeaveCriticalSection(&g_qlock);
    if (wf != NULL) __ldp3_schedule(wf, ws);
    WakeAllConditionVariable(&g_donecond);
}

long long __ldp3_task_result(long long handle) {
    ldp3_task* t = (ldp3_task*)handle;
    return t != NULL ? t->result : 0;
}

// await from inside an async state machine: if the awaited task is already done, return 0 so
// the caller falls through and reads the result; otherwise register the caller's continuation
// and return 1 so the caller suspends (returns from its resume function).
int __ldp3_await(long long awaited, ldp3_resume_fn resume, void* state) {
    ldp3_task* a = (ldp3_task*)awaited;
    if (a == NULL) return 0;
    EnterCriticalSection(&g_qlock);
    if (a->done) { LeaveCriticalSection(&g_qlock); return 0; }
    a->waiter_fn = resume;
    a->waiter_state = state;
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

// ---- Networking (spec 34): minimal TCP client over winsock. ----
static int g_net_inited = 0;
static void ldp3_net_init(void) {
    if (!g_net_inited) { WSADATA w; WSAStartup(MAKEWORD(2, 2), &w); g_net_inited = 1; }
}
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
static SIZE_T __ldp3_fn_len(void* fn, void** table, long long count) {
    unsigned long long base = (unsigned long long)fn, next = 0;
    for (long long i = 0; i < count; i++) {
        unsigned long long a = (unsigned long long)table[i];
        if (a > base && (next == 0 || a < next)) next = a;
    }
    unsigned long long len = next ? (next - base) : 64;
    return (SIZE_T)(len > 4096 ? 4096 : len);
}

// Physical code unload (spec 30 "unloading agressivo"): overwrite a function's machine code
// in RAM with int3 (0xCC), so the instructions are physically ripped from memory.
void __ldp3_unload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    SIZE_T len = __ldp3_fn_len(fn, table, count);
    DWORD old;
    if (VirtualProtect(fn, len, PAGE_EXECUTE_READWRITE, &old)) {
        memset(fn, 0xCC, len);
        FlushInstructionCache(GetCurrentProcess(), fn, len);
    }
}

// Physical code reload for reimport (spec 30.3 "recarrega do disco"): read the function's
// original bytes from the program's own .exe on disk (the image file still holds them) and
// write them back over the int3-overwritten RAM. x64 code is RIP-relative, so the .text
// bytes are position-independent within the module and need no relocation fix-up.
void __ldp3_reload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    SIZE_T len = __ldp3_fn_len(fn, table, count);
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
    DWORD old;
    if (buf != NULL && got > 0 && VirtualProtect(fn, len, PAGE_EXECUTE_READWRITE, &old)) {
        memcpy(fn, buf, got);
        FlushInstructionCache(GetCurrentProcess(), fn, len);
    }
    free(buf);
}
