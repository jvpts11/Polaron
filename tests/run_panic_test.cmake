# End-to-end "must panic" test driver, invoked via `cmake -P`.
#
# Compiles an .ldp3 to a native .exe and runs it, asserting the program TERMINATES WITH A CLEAN PANIC:
# a non-zero exit and a needle in stderr (e.g. "array index out of bounds"). This is the counterpart of
# run_exe_test.cmake, which requires a zero exit -- here a zero exit is the failure. It exists so the
# no-UB guards (bounds checks, null-deref traps, double-free guards) can be tested as first-class: a
# guard that silently corrupts memory instead of panicking is exactly the bug we are guarding against.
#
# Required -D args: LDP3C, CLANG, INPUT, PANIC (stderr needle), WORKDIR

string(MD5 _tag "${INPUT}|${PANIC}")
set(ll "${WORKDIR}/panic_${_tag}.ll")
set(exe "${WORKDIR}/panic_${_tag}.exe")

execute_process(COMMAND "${LDP3C}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c failed (exit ${rc})")
endif()

get_filename_component(_clangdir "${CLANG}" DIRECTORY)
get_filename_component(_llvmroot "${_clangdir}" DIRECTORY)
file(GLOB _builtins
    "${_llvmroot}/lib/clang/*/lib/windows/clang_rt.builtins-x86_64.lib"
    "$ENV{ProgramFiles}/LLVM/lib/clang/*/lib/windows/clang_rt.builtins-x86_64.lib")
set(_builtinslib "")
if(_builtins)
    list(GET _builtins 0 _builtinslib)
endif()
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions ${_builtinslib})
else()
    set(_platlibs -lpthread -ldl -lm -lstdc++)
endif()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}"
    "${CMAKE_CURRENT_LIST_DIR}/../runtime/ldp3_rt.cpp" -o "${exe}"
    ${_platlibs} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
message(STATUS "exit: ${rc}  stderr: ${err}")

# A clean exit means the guard did NOT fire -- the program read/wrote out of bounds silently. That is
# the failure this test is here to catch.
if(rc EQUAL 0)
    message(FATAL_ERROR "expected a panic, but the program exited cleanly (out: [${out}])")
endif()

if(DEFINED PANIC)
    string(FIND "${err}" "${PANIC}" _found)
    if(_found EQUAL -1)
        message(FATAL_ERROR "panicked, but stderr missing expected text:\n  got:      [${err}]\n  needle:   [${PANIC}]")
    endif()
endif()

message(STATUS "OK: panicked as expected")
