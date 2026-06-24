// LDP3 minimal runtime: thread support (spec 20.1), defined-behaviour panic, and the
// physical code unload/reload behind unimport/reimport (spec 30). Linked into every exe.

#include <windows.h>
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
