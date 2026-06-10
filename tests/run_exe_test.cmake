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

# legacy_stdio_definitions.lib resolves the bare printf/scanf symbols (UCRT
# defines them inline in the headers, which our emitted IR doesn't use).
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" -o "${exe}"
    -llegacy_stdio_definitions RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})")
endif()

if(DEFINED INPUT_FILE)
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
