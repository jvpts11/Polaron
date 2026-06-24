// LDP3 minimal runtime: OS thread support for the Thread builtin (spec 20.1). Linked into every
// executable, because the prelude's System.Concurrency.Thread always emits calls to __ldp3_thread_*.

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

// Physical code unload (spec 30 "unloading agressivo"): overwrite a function's machine
// code in RAM with int3 (0xCC) traps, so the instructions are physically removed/ripped
// from memory. `table`/`count` are all the program's function addresses; the overwrite
// length is bounded by the next function so a neighbor is never clobbered (capped).
int __stdcall VirtualProtect(void* addr, unsigned long long size, unsigned long newProt,
                             unsigned long* oldProt);
int __stdcall FlushInstructionCache(void* proc, const void* base, unsigned long long size);
void* __stdcall GetCurrentProcess(void);

void __ldp3_unload_fn(void* fn, void** table, long long count) {
    if (fn == 0) return;
    unsigned long long base = (unsigned long long)fn;
    unsigned long long next = 0;  // smallest function address strictly greater than fn
    for (long long i = 0; i < count; i++) {
        unsigned long long a = (unsigned long long)table[i];
        if (a > base && (next == 0 || a < next)) next = a;
    }
    unsigned long long len = next ? (next - base) : 64;
    if (len > 4096) len = 4096;  // cap the blast radius
    unsigned long old;
    if (VirtualProtect(fn, len, 0x40 /*PAGE_EXECUTE_READWRITE*/, &old)) {
        unsigned char* p = (unsigned char*)fn;
        for (unsigned long long i = 0; i < len; i++) p[i] = 0xCC;  // int3
        FlushInstructionCache(GetCurrentProcess(), fn, len);
    }
}
