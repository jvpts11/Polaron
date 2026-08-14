# End-to-end codegen test driver, invoked via `cmake -P`.
#
# Compiles an .pol to a native .exe (polc -> .ll, then clang -> .exe), runs
# it, and checks stdout against EXPECTED.
#
# Required -D args: POLC, CLANG, INPUT, EXPECTED, WORKDIR

# OPT is optional: an polc optimization flag (e.g. -O3) to exercise the in-process pipeline.
if(NOT DEFINED OPT)
    set(OPT "")
endif()

# Unique intermediate file names per test configuration so the suite is safe to run in parallel
# (ctest -j): every test used to share e2e_out.ll/.exe in WORKDIR and clobber each other's files.
# RUNARGS and INPUT_FILE are part of the identity too: several tests may run the SAME sample with
# different arguments (the test runner's --filter / --list, for instance), and leaving them out put
# those tests back on a shared .exe path, where one ran while another was still linking it.
string(MD5 _tag "${INPUT}|${INPUT2}|${OPT}|${RUNARGS}|${INPUT_FILE}")
set(ll "${WORKDIR}/e2e_${_tag}.ll")
set(exe "${WORKDIR}/e2e_${_tag}.exe")

# INPUT2 is optional: a program may span multiple .pol files.
if(DEFINED INPUT2)
    execute_process(COMMAND "${POLC}" ${OPT} "${INPUT}" "${INPUT2}" -o "${ll}" RESULT_VARIABLE rc)
else()
    execute_process(COMMAND "${POLC}" ${OPT} "${INPUT}" -o "${ll}" RESULT_VARIABLE rc)
endif()
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc})")
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
    # -lstdc++ supplies the Itanium EH runtime (__cxa_*, __gxx_personality_v0, _ZTIPv) that exceptions
    # lower to; _Unwind_* comes from libgcc, which clang links by default.
    set(_platlibs -lpthread -ldl -lm -lstdc++)
endif()
# RTOBJ is the runtime, compiled ONCE by the build (see tests/CMakeLists.txt). Passing the .cpp here
# made every test rebuild it -- 1.63 s each, about half the suite's wall-clock, to produce an object
# byte-identical to the one already sitting in the build directory. The source path stays as a
# fallback so this script still works when invoked by hand without RTOBJ.
# Found through WORKDIR, which every test already passes, so none of the ~500 add_test calls had to
# grow an argument. Falls back to the source when the object is absent, so invoking this script by
# hand still works.
set(_rt "${CMAKE_CURRENT_LIST_DIR}/../runtime/polaron_rt.cpp")
foreach(_ext ".obj" ".o")
    if(EXISTS "${WORKDIR}/polaron_rt_clang${_ext}")
        set(_rt "${WORKDIR}/polaron_rt_clang${_ext}")
        break()
    endif()
endforeach()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${_rt}" -o "${exe}"
    ${_platlibs} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

if(DEFINED RUNARGS)
    # RUNARGS is optional: command-line arguments to pass to the program (for testing main's args).
    separate_arguments(_runargs UNIX_COMMAND "${RUNARGS}")
    execute_process(COMMAND "${exe}" ${_runargs}
        OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
elseif(DEFINED INPUT_FILE)
    execute_process(COMMAND "${exe}" INPUT_FILE "${INPUT_FILE}"
        OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
else()
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
endif()
if(NOT err STREQUAL "")
    message(STATUS "stderr: ${err}")   # keep panics/alerts visible in the test log
endif()
# EXPECT_EXIT is optional: the code the program MUST exit with. For a guard that is supposed to fire
# -- a contract, a bounds check, a refused region release -- success is a non-zero exit with the right
# message, and without this the harness could only test guards that never trip. It is also what tells
# a program that FAILED ON PURPOSE (`System.Os.Exit`) apart from one that crashed, which is the only
# thing that makes an exit code testable at all.
#
# (Two names were invented for this on two machines the same week -- `EXPECTCODE` and `EXPECT_EXIT`.
# This one won because it prints the program's output when the code is wrong, and a harness that
# says "expected 3, got 1" without showing what the program said sends the reader back to run it by
# hand.)
if(DEFINED EXPECT_EXIT)
    if(NOT rc EQUAL EXPECT_EXIT)
        message(FATAL_ERROR "program exited with ${rc}, expected ${EXPECT_EXIT}\n  stdout: [${out}]\n  stderr: [${err}]")
    endif()
elseif(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc}")
endif()

# ERRCONTAINS is optional: text the program must have written to stderr (runtime alerts, e.g. the
# overrun report of `defer within`, which is a diagnostic and deliberately not part of stdout).
if(DEFINED ERRCONTAINS)
    string(FIND "${err}" "${ERRCONTAINS}" _efound)
    if(_efound EQUAL -1)
        message(FATAL_ERROR "stderr missing expected text:
  got:      [${err}]
  needle:   [${ERRCONTAINS}]")
    endif()
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
