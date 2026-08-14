# Ask polc for the foreign libraries a program declares and assert the exact list, via `cmake -P`.
#
# This is the channel the build itself uses -- `polaron build` writes the same file next to the .ll and
# reads it back to build the link line -- so the test exercises the real mechanism rather than a
# stdout rendering of it. The list is asserted WHOLE, not by needle: order and deduplication are the
# properties that matter here, and a substring check would pass on either being wrong.
#
# Required -D args: POLC, INPUT, EXPECTED (semicolon-separated names), WORKDIR.
# Optional: LIB -- a .pol compiled to a bundle first and given to INPUT with `--use`, which is how the
# cross-bundle case is asked: the consumer names no library at all and must still learn about the one
# its dependency's class declares.
string(MD5 _tag "${INPUT}|${EXPECTED}")
set(libsFile "${WORKDIR}/foreign_${_tag}.libs")
file(REMOVE "${libsFile}")

set(_useArgs)
if(LIB)
    set(polb "${WORKDIR}/foreign_${_tag}.polb")
    execute_process(COMMAND "${POLC}" --lib "${LIB}" -o "${polb}" RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "polc --lib failed (exit ${rc}) on ${LIB}")
    endif()
    set(_useArgs --use "${polb}")
endif()

execute_process(COMMAND "${POLC}" --check "${INPUT}" ${_useArgs} "--emit-foreign-libs=${libsFile}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --check failed (exit ${rc}) on ${INPUT}")
endif()
if(NOT EXISTS "${libsFile}")
    message(FATAL_ERROR "polc reported success but wrote no library list to ${libsFile}")
endif()

file(STRINGS "${libsFile}" _got)
if(NOT "${_got}" STREQUAL "${EXPECTED}")
    message(FATAL_ERROR "declared foreign libraries differ\n  expected: ${EXPECTED}\n  got:      ${_got}\n  input:    ${INPUT}")
endif()
message(STATUS "OK: foreign libraries are ${EXPECTED}")
