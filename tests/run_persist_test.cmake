# Cross-run persistence test, invoked via `cmake -P`.
#
# Compiles an .ldp3 to a native .exe, removes any prior store, then runs the exe
# TWICE from WORKDIR and checks the SECOND run's stdout against EXPECTED -- proving
# a `static persistent` value survived across process runs (via the disk store).
#
# Required -D args: LDP3C, CLANG, INPUT, EXPECTED, WORKDIR, STORE (store filename)

set(ll "${WORKDIR}/persist_out.ll")
set(exe "${WORKDIR}/persist_out.exe")

execute_process(COMMAND "${LDP3C}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c failed (exit ${rc})")
endif()
# Link the minimal LDP3 runtime (graph-identity tables for persistent serialization).
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}"
    "${CMAKE_CURRENT_LIST_DIR}/../runtime/ldp3_rt.c" -o "${exe}"
    -llegacy_stdio_definitions RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

# Start from a clean store so the test is deterministic.
file(REMOVE "${WORKDIR}/${STORE}")

# Run 1: creates the store. Run 2: must read the persisted value.
execute_process(COMMAND "${exe}" WORKING_DIRECTORY "${WORKDIR}"
    OUTPUT_VARIABLE out1 RESULT_VARIABLE rc1)
if(NOT rc1 EQUAL 0)
    message(FATAL_ERROR "run 1 exited with ${rc1}")
endif()
execute_process(COMMAND "${exe}" WORKING_DIRECTORY "${WORKDIR}"
    OUTPUT_VARIABLE out RESULT_VARIABLE rc2)
if(NOT rc2 EQUAL 0)
    message(FATAL_ERROR "run 2 exited with ${rc2}")
endif()

string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "run 2 output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

string(REGEX REPLACE "[ \t\r\n]+" " " out1 "${out1}")
string(STRIP "${out1}" out1)
message(STATUS "OK (cross-run): run1=[${out1}] run2=[${out}]")
