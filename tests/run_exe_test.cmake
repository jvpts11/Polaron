# End-to-end codegen test driver, invoked via `cmake -P`.
#
# Compiles an .ldp3 to a native .exe (ldp3c -> .ll, then clang -> .exe), runs
# it, and checks stdout against EXPECTED.
#
# Required -D args: LDP3C, CLANG, INPUT, EXPECTED, WORKDIR

set(ll "${WORKDIR}/e2e_out.ll")
set(exe "${WORKDIR}/e2e_out.exe")

execute_process(COMMAND "${LDP3C}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c failed (exit ${rc})")
endif()

execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" -o "${exe}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc}")
endif()

string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

message(STATUS "OK: ${out}")
