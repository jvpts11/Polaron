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
    // ---- What a file records about itself. `__fileCreated` answers -1 where the filesystem does
    // not store a birth time, which is most Linux ones: `st_ctime` is the STATUS-CHANGE time and
    // returning it would report a chmod as a creation.
    {"System.IO.__fileCreated",   "__polaron_file_ctime",    'l', true},
    {"System.IO.__fileAccessed",  "__polaron_file_atime",    'l', true},
    {"System.IO.__fileReadOnly",  "__polaron_file_readonly", 'i', true},
    {"System.IO.__fileTouch",     "__polaron_file_touch",    'i', true},
    // ---- Links. `__isLink` asks WITHOUT following, which is the only way the question can be
    // answered: `exists` follows, so a link pointing at nothing reports "not there".
    {"System.IO.__isLink",        "__polaron_is_symlink",    'i', true},
    {"System.IO.__readLink",      "__polaron_readlink",      's', true},
};

// The two-argument ones, which do not fit the shape above: (String, String) or (String, int).
struct SysIntrinsic2 {
    const char* name;
    const char* symbol;
    char result;          // 'i' int | 's' String
    bool secondIsInt;     // true: (String, int); false: (String, String)
    int trailing;         // -1: none. Otherwise a constant int appended as a third argument.
};

inline constexpr SysIntrinsic2 kSysIntrinsics2[] = {
    {"System.IO.__setReadOnly",  "__polaron_file_set_readonly", 'i', true,  -1},
    // (target, linkPath) for all three: the thing pointed at comes first, as it does in `ln`. The
    // two symlink spellings differ only in the flag Windows needs -- it has to be told at creation
    // whether the link names a directory, because it cannot look at a target that is not there yet.
    {"System.IO.__hardLink",     "__polaron_hardlink",          'i', false, -1},
    {"System.IO.__symLink",      "__polaron_symlink",           'i', false, 0},
    {"System.IO.__symLinkDir",   "__polaron_symlink",           'i', false, 1},
};

inline const SysIntrinsic2* findSysIntrinsic2(const std::string& name) {
    for (const SysIntrinsic2& e : kSysIntrinsics2) {
        if (name == e.name) {
            return &e;
        }
    }
    return nullptr;
}
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
