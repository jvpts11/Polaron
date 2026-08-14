# Two INDEPENDENTLY built bundles linked into one program, invoked via `cmake -P`.
#
# Distinct from run_polb_link_test.cmake in the one way that matters: that harness builds a single
# library, so the consumer's slot numbering trivially agrees with it. Here two libraries are compiled
# without ever seeing each other, so each numbers its own world from 0 and they disagree by
# construction -- which is the case the compiler used to refuse outright.
#
# The flow is the driver's (src/driver/build.cpp), spelled out:
#   1. compile each library alone            -> each bakes vtables in its own numbering
#   2. compile the program seeing both       -> --emit-vtable-slots writes the merged, authoritative one
#   3. extract each library's code           -> --remap-slots permutes its tables into that numbering
#   4. link and run
#
# Step 3 is the whole test. Skipping it links fine and calls the wrong slots, so the assertion has to be
# on the OUTPUT, never on the exit code.
#
# Required -D args: POLC, CLANG, LIBA, LIBB, APP, EXPECTED, WORKDIR

get_filename_component(TAGA "${LIBA}" NAME_WE)
get_filename_component(TAGB "${LIBB}" NAME_WE)
get_filename_component(TAGAPP "${APP}" NAME_WE)
set(polba "${WORKDIR}/${TAGA}.polb")
set(polbb "${WORKDIR}/${TAGB}.polb")
set(bca "${WORKDIR}/${TAGA}.bc")
set(bcb "${WORKDIR}/${TAGB}.bc")
set(ll "${WORKDIR}/${TAGAPP}.ll")
set(slots "${WORKDIR}/${TAGAPP}.slots")
set(exe "${WORKDIR}/${TAGAPP}.exe")

# 1) Each library alone. Two separate invocations, sharing nothing -- not even a slot map.
execute_process(COMMAND "${POLC}" --lib "${LIBA}" -o "${polba}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib on '${LIBA}' failed (exit ${rc})")
endif()
execute_process(COMMAND "${POLC}" --lib "${LIBB}" -o "${polbb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib on '${LIBB}' failed (exit ${rc})")
endif()

# 2) The program, which is the only compile that sees both. Its numbering is the authority.
execute_process(COMMAND "${POLC}" "${APP}" --use "${polba}" --use "${polbb}" -o "${ll}"
    "--emit-vtable-slots=${slots}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc (consumer, two bundles) failed (exit ${rc})")
endif()
if(NOT EXISTS "${slots}")
    message(FATAL_ERROR "--emit-vtable-slots wrote nothing")
endif()

# 3) Extract each library's code, renumbered into the program's layout.
execute_process(COMMAND "${POLC}" --extract-code "${polba}" -o "${bca}"
    "--remap-slots=${slots}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --extract-code on '${polba}' failed (exit ${rc})")
endif()
execute_process(COMMAND "${POLC}" --extract-code "${polbb}" -o "${bcb}"
    "--remap-slots=${slots}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --extract-code on '${polbb}' failed (exit ${rc})")
endif()

# 4) Link and run. See run_exe_test.cmake for the platform link libraries.
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions)
else()
    set(_platlibs -lpthread -ldl -lm -lstdc++)
endif()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${bca}" "${bcb}"
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
    message(FATAL_ERROR "output mismatch (a wrong permutation calls the wrong slot):\n"
        "  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

message(STATUS "OK: ${out}")
