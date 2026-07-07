# End-to-end codegen test driver, invoked via `cmake -P`.
#
# Compiles an .ldp3 to a native .exe (ldp3c -> .ll, then clang -> .exe), runs
# it, and checks stdout against EXPECTED.
#
# Required -D args: LDP3C, CLANG, INPUT, EXPECTED, WORKDIR

# OPT is optional: an ldp3c optimization flag (e.g. -O3) to exercise the in-process pipeline.
if(NOT DEFINED OPT)
    set(OPT "")
endif()

# Unique intermediate file names per test configuration so the suite is safe to run in parallel
# (ctest -j): every test used to share e2e_out.ll/.exe in WORKDIR and clobber each other's files.
string(MD5 _tag "${INPUT}|${INPUT2}|${OPT}")
set(ll "${WORKDIR}/e2e_${_tag}.ll")
set(exe "${WORKDIR}/e2e_${_tag}.exe")

# INPUT2 is optional: a program may span multiple .ldp3 files.
if(DEFINED INPUT2)
    execute_process(COMMAND "${LDP3C}" ${OPT} "${INPUT}" "${INPUT2}" -o "${ll}" RESULT_VARIABLE rc)
else()
    execute_process(COMMAND "${LDP3C}" ${OPT} "${INPUT}" -o "${ll}" RESULT_VARIABLE rc)
endif()
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c failed (exit ${rc})")
endif()

# The compiler-rt builtins library (next to clang) provides 128-bit integer division (__divti3 etc.)
# that the Decimal primitive needs; lld-link does not pull it in automatically. Harmless for programs
# that do not use it.
get_filename_component(_clangdir "${CLANG}" DIRECTORY)
get_filename_component(_llvmroot "${_clangdir}" DIRECTORY)
# The vcpkg clang ships no compiler-rt, so also look in a standalone LLVM install. The .lib is static,
# so it links with any clang.
file(GLOB _builtins
    "${_llvmroot}/lib/clang/*/lib/windows/clang_rt.builtins-x86_64.lib"
    "$ENV{ProgramFiles}/LLVM/lib/clang/*/lib/windows/clang_rt.builtins-x86_64.lib")
set(_builtinslib "")
if(_builtins)
    list(GET _builtins 0 _builtinslib)
endif()

# Platform link libraries. On Windows, legacy_stdio_definitions.lib resolves the bare printf/scanf symbols
# (UCRT defines them inline in the headers, which our emitted IR doesn't use), and the compiler-rt builtins
# lib supplies 128-bit division; Winsock is pulled in by a pragma in the runtime. On POSIX, printf/sockets
# live in libc and clang links its own builtins, so we only add the runtime's own needs: pthreads for the
# Thread/async layer, dl for reimport's dl_iterate_phdr, and libm for the math builtins.
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions ${_builtinslib})
else()
    set(_platlibs -lpthread -ldl -lm)
endif()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}"
    "${CMAKE_CURRENT_LIST_DIR}/../runtime/ldp3_rt.cpp" -o "${exe}"
    ${_platlibs} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

if(DEFINED RUNARGS)
    # RUNARGS is optional: command-line arguments to pass to the program (for testing main's args).
    separate_arguments(_runargs UNIX_COMMAND "${RUNARGS}")
    execute_process(COMMAND "${exe}" ${_runargs} OUTPUT_VARIABLE out RESULT_VARIABLE rc)
elseif(DEFINED INPUT_FILE)
    execute_process(COMMAND "${exe}" INPUT_FILE "${INPUT_FILE}"
        OUTPUT_VARIABLE out RESULT_VARIABLE rc)
else()
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
endif()
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc}")
endif()

# Collapse all runs of whitespace (incl. Windows CRLF and internal newlines)
# to single spaces so multi-line output can be matched with a one-line EXPECTED.
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(DEFINED CONTAINS)
    # Substring match -- for large/variable output where exact match is brittle.
    string(FIND "${out}" "${CONTAINS}" found)
    if(found EQUAL -1)
        message(FATAL_ERROR "output missing expected text:\n  got:      [${out}]\n  needle:   [${CONTAINS}]")
    endif()
elseif(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

message(STATUS "OK: ${out}")
