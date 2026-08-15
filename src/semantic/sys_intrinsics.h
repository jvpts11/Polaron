#pragma once

// THE QUESTIONS AN OPERATING SYSTEM ALREADY KNOWS THE ANSWER TO.
//
// Where am I running, who am I, what machine is this, how much room is left. A program that cannot
// ask grows a configuration file whose first entry is a path somebody typed at their own desk -- and
// that path is wrong on the next machine, silently, because a missing directory reads the same as an
// empty one.
//
// ONE TABLE, READ BY BOTH SIDES. The analyzer needs each intrinsic's arity and result type; the
// codegen needs its runtime symbol and how to build the call. Those are the same fifteen facts, and
// keeping them in two hand-written lists is how the fifteenth ends up calling the fourteenth's
// symbol. The table lives here rather than in codegen because the dependency runs that way: codegen
// includes semantic and never the reverse.
//
// The names are `System.OS.__something` -- the shape `__machineThreads` already uses. They are not
// meant to be written in a program: the standard library's `Environment`, `Workspace` and `Machine`
// are, and each is a class whose body is one call to one of these.

#include <cstddef>
#include <string>

namespace polaron {
namespace sysint {

// What the intrinsic answers with, and what it takes. Result `s` is a String (the runtime returns a
// heap buffer plus a length, which becomes an owned String); `l` is a long; `i` is an int, which the
// library above reads as a boolean where the runtime answers 1/0.
struct SysIntrinsic {
    const char* name;      // the `System.OS.__x` spelling
    const char* symbol;    // the runtime function it lowers to
    char result;           // 's' String | 'l' long | 'i' int
    bool takesPath;        // true: one String argument; false: none
};

// clang-format off
inline constexpr SysIntrinsic kSysIntrinsics[] = {
    // ---- The environment. ABSENT IS NOT EMPTY: `env_get` cannot tell a variable that is unset from
    // one set to "", which is why `__envHas` exists and why the library answers with an Option.
    {"System.OS.__envHas",        "__polaron_env_has",       'i', true},
    {"System.OS.__envUnset",      "__polaron_env_unset",     'i', true},
    {"System.OS.__envAll",        "__polaron_env_all",       's', false},
    // ---- Where the program is.
    {"System.OS.__cwd",           "__polaron_cwd",           's', false},
    {"System.OS.__chdir",         "__polaron_chdir",         'i', true},
    {"System.OS.__tempDir",       "__polaron_temp_dir",      's', false},
    {"System.OS.__homeDir",       "__polaron_home_dir",      's', false},
    {"System.OS.__pathAbsolute",  "__polaron_path_absolute", 's', true},
    // ---- What it is running on.
    {"System.OS.__hostname",      "__polaron_hostname",      's', false},
    {"System.OS.__username",      "__polaron_username",      's', false},
    {"System.OS.__osName",        "__polaron_os_name",       's', false},
    {"System.OS.__pid",           "__polaron_pid",           'l', false},
    {"System.OS.__machineMemory", "__polaron_machine_memory",'l', false},
    {"System.OS.__pageSize",      "__polaron_page_size",     'l', false},
    // ---- How much room is left, on the volume holding a given path.
    {"System.OS.__diskFree",      "__polaron_disk_free",     'l', true},
    {"System.OS.__diskTotal",     "__polaron_disk_total",    'l', true},
};
// clang-format on

// The entry for a fully-qualified call name, or null when it is not one of these.
inline const SysIntrinsic* findSysIntrinsic(const std::string& name) {
    for (const SysIntrinsic& e : kSysIntrinsics) {
        if (name == e.name) {
            return &e;
        }
    }
    return nullptr;
}

// The Polaron type an intrinsic yields, for the analyzer.
inline const char* sysIntrinsicType(const SysIntrinsic& e) {
    return e.result == 's' ? "String" : (e.result == 'l' ? "long" : "int");
}

}  // namespace sysint
}  // namespace polaron
