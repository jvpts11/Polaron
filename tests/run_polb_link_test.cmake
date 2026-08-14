# End-to-end cross-bundle static-linking test driver, invoked via `cmake -P`.
#
# Compiles a library to a .polb, extracts its CODE bitcode, compiles a consumer that imports it
# (`--use`), links the consumer .ll with the bundle's bitcode via clang, runs the result, and matches
# stdout against EXPECTED.
#
# Required -D args: POLC, CLANG, LIB, APP, EXPECTED, WORKDIR

# EVERY OUTPUT BELOW IS NAMED AFTER THE TEST'S OWN LIBRARY, and that is not tidiness.
#
# These paths used to be fixed (`e2e_link.polb`, `e2e_link_app.exe`) in one shared WORKDIR, while SIX
# tests share this harness. Under `ctest -j 12` they overwrite each other's bundles and executables,
# and the result is a test that fails once in a while for no reason anybody can reproduce -- measured
# twice in one evening, each time costing an investigation that ended in "passes in isolation".
# A false failure is not free: it trains you to re-run instead of to look, which is exactly how a real
# one gets waved through.
get_filename_component(TESTTAG "${LIB}" NAME_WE)
set(polb "${WORKDIR}/${TESTTAG}_link.polb")
set(bc "${WORKDIR}/${TESTTAG}_link.bc")
set(ll "${WORKDIR}/${TESTTAG}_link_app.ll")
set(exe "${WORKDIR}/${TESTTAG}_link_app.exe")

execute_process(COMMAND "${POLC}" --lib "${LIB}" -o "${polb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib failed (exit ${rc})")
endif()

execute_process(COMMAND "${POLC}" --extract-code "${polb}" -o "${bc}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --extract-code failed (exit ${rc})")
endif()

execute_process(COMMAND "${POLC}" "${APP}" --use "${polb}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc (consumer) failed (exit ${rc})")
endif()

# Platform link libraries: Windows needs legacy_stdio_definitions for the bare printf/scanf symbols;
# POSIX gets the runtime's own needs (pthreads/dl/libm). See run_exe_test.cmake for the rationale.
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions)
else()
    set(_platlibs -lpthread -ldl -lm -lstdc++)  # -lstdc++: Itanium EH runtime for exceptions
endif()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${bc}"
    "${CMAKE_CURRENT_LIST_DIR}/../runtime/polaron_rt.cpp" -o "${exe}"
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
