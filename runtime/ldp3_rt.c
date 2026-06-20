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
