// LDP3 minimal runtime.
// Graph-identity tables for persistent serialization: dedup shared objects (DAGs) and break
// cycles. The compiler emits calls to these from __ldp3_ser_* / __ldp3_deser_*.
#include <stddef.h>

#define LDP3_GRAPH_CAP 4096

static void* ldp3_seen[LDP3_GRAPH_CAP];  // save side: objects in first-seen order
static int   ldp3_seen_n = 0;
static void* ldp3_made[LDP3_GRAPH_CAP];  // load side: objects by id (same order)
static int   ldp3_made_n = 0;

// Cleared at the start of each save and each load.
void __ldp3_graph_reset(void) {
    ldp3_seen_n = 0;
    ldp3_made_n = 0;
}

// Save side: if x was already serialized, return its id (>= 0). Otherwise record it (so a later
// reference -- including a cycle back to x -- finds it) and return -(id)-1 to signal "new".
int __ldp3_intern(void* x) {
    for (int i = 0; i < ldp3_seen_n; i++) {
        if (ldp3_seen[i] == x) return i;
    }
    int id = ldp3_seen_n++;
    ldp3_seen[id] = x;
    return -id - 1;
}

// Load side: objects are registered in first-seen order, matching the save side's ids.
void  __ldp3_made_add(void* obj) { ldp3_made[ldp3_made_n++] = obj; }
void* __ldp3_made_at(int id)     { return ldp3_made[id]; }

// The persistent store lives next to the executable (spec 18), not in the cwd. Builds
// "<exe directory>\<name>" into a static buffer. kernel32's GetModuleFileNameA is declared
// here to avoid pulling in the whole <windows.h>.
unsigned long __stdcall GetModuleFileNameA(void* hModule, char* buf, unsigned long size);
char* __ldp3_store_path(const char* name) {
    static char buf[1024];
    unsigned long n = GetModuleFileNameA((void*)0, buf, (unsigned long)sizeof(buf));
    while (n > 0 && buf[n - 1] != '\\' && buf[n - 1] != '/') n--;  // strip the exe filename
    for (int i = 0; name[i] != 0 && n < (unsigned long)sizeof(buf) - 1; i++) buf[n++] = name[i];
    buf[n] = 0;
    return buf;
}

// OS threads (spec 20.1 Thread). kernel32 declared by hand to avoid <windows.h>. A function value
// is a pointer to a closure {code, env}; the trampoline loads code/env and calls code(env), which
// is exactly how a function<void> is invoked (env is the first argument, null if no captures).
void* __stdcall CreateThread(void* attrs, unsigned long long stack, void* start, void* param,
                             unsigned long flags, void* idOut);
unsigned long __stdcall WaitForSingleObject(void* handle, unsigned long ms);
int __stdcall CloseHandle(void* handle);

static unsigned long __stdcall __ldp3_thread_trampoline(void* closure) {
    void** c = (void**)closure;
    void (*code)(void*) = (void (*)(void*))c[0];
    code(c[1]);
    return 0;
}

// Start a thread running the given function<void> closure; returns the OS handle as an integer.
long long __ldp3_thread_spawn(void* closure) {
    void* h = CreateThread((void*)0, 0, (void*)__ldp3_thread_trampoline, closure, 0, (void*)0);
    return (long long)h;
}

// Wait for the thread to finish, then release the handle.
void __ldp3_thread_join(long long handle) {
    void* h = (void*)handle;
    WaitForSingleObject(h, 0xFFFFFFFF);  // INFINITE
    CloseHandle(h);
}
