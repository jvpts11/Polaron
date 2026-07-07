# End-to-end cross-bundle static-linking test driver, invoked via `cmake -P`.
#
# Compiles a library to a .ldb, extracts its CODE bitcode, compiles a consumer that imports it
# (`--use`), links the consumer .ll with the bundle's bitcode via clang, runs the result, and matches
# stdout against EXPECTED.
#
# Required -D args: LDP3C, CLANG, LIB, APP, EXPECTED, WORKDIR

set(ldb "${WORKDIR}/e2e_link.ldb")
set(bc "${WORKDIR}/e2e_link.bc")
set(ll "${WORKDIR}/e2e_link_app.ll")
set(exe "${WORKDIR}/e2e_link_app.exe")

execute_process(COMMAND "${LDP3C}" --lib "${LIB}" -o "${ldb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --lib failed (exit ${rc})")
endif()

execute_process(COMMAND "${LDP3C}" --extract-code "${ldb}" -o "${bc}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --extract-code failed (exit ${rc})")
endif()

execute_process(COMMAND "${LDP3C}" "${APP}" --use "${ldb}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c (consumer) failed (exit ${rc})")
endif()

# Platform link libraries: Windows needs legacy_stdio_definitions for the bare printf/scanf symbols;
# POSIX gets the runtime's own needs (pthreads/dl/libm). See run_exe_test.cmake for the rationale.
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions)
else()
    set(_platlibs -lpthread -ldl -lm)
endif()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${bc}"
    "${CMAKE_CURRENT_LIST_DIR}/../runtime/ldp3_rt.cpp" -o "${exe}"
    ${_platlibs} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc}")
endif()

string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

message(STATUS "OK: ${out}")
