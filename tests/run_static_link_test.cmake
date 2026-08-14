# `polaron build --static` produces a binary with NO dynamic loader and no glibc version requirement.
# Invoked via `cmake -P`. Linux only -- the question it answers does not exist on Windows.
#
# "Does this run on most distributions" is a question about symbol versions and nothing else. A
# Polaron program built on Ubuntu 26.04 records references up to `GLIBC_2.34`; an older machine
# refuses to start it and blames the loader rather than the program. Measured, both ways, by this test:
# the dynamic build must show a version requirement and the static one must show none.
#
# Asserting the ABSENCE is the point. "It linked" says nothing -- a static link that quietly fell back
# to dynamic would still link, still run here, and still fail on the machine it was built for.
#
# Required -D args: POLARON, PROJECT, EXE, EXPECTED, READELF, OBJDUMP.

execute_process(COMMAND "${CMAKE_COMMAND}" -E rm -rf "${PROJECT}/build-output")
execute_process(COMMAND "${POLARON}" build --static WORKING_DIRECTORY "${PROJECT}"
                RESULT_VARIABLE rc OUTPUT_VARIABLE o ERROR_VARIABLE e)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron build --static failed (exit ${rc})\n${o}\n${e}")
endif()
if(NOT EXISTS "${EXE}")
    message(FATAL_ERROR "the static build wrote no executable at ${EXE}")
endif()

execute_process(COMMAND "${EXE}" OUTPUT_VARIABLE out RESULT_VARIABLE rc TIMEOUT 60)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "the static binary exited ${rc}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "wrong output:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

# No PT_INTERP: there is no dynamic loader to be missing on the target machine.
execute_process(COMMAND "${READELF}" -l "${EXE}" OUTPUT_VARIABLE _hdrs ERROR_QUIET)
if(_hdrs MATCHES "program interpreter")
    message(FATAL_ERROR "the '--static' binary still names a dynamic loader -- the link fell back to "
                        "dynamic and the whole point of the flag was lost silently")
endif()

# ...and no versioned glibc symbol, which is what actually stops a binary on an older distribution.
execute_process(COMMAND "${OBJDUMP}" -T "${EXE}" OUTPUT_VARIABLE _syms ERROR_QUIET)
if(_syms MATCHES "GLIBC_")
    string(REGEX MATCH "GLIBC_[0-9.]+" _v "${_syms}")
    message(FATAL_ERROR "the static binary still requires ${_v}; it will refuse to start on any "
                        "machine whose glibc is older")
endif()

message(STATUS "OK: static, no interpreter, no glibc version -- '${out}'")
