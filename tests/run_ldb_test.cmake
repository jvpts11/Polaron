# End-to-end .ldb bundle test driver, invoked via `cmake -P`.
#
# Compiles a library .ldp3 to a .ldb (+ .ldh) with `ldp3c --lib`, checks both files were written,
# then runs `--dump-ldb` and matches its output against CONTAINS.
#
# Required -D args: LDP3C, INPUT, CONTAINS, WORKDIR

set(ldb "${WORKDIR}/e2e_bundle.ldb")
set(ldh "${WORKDIR}/e2e_bundle.ldh")

execute_process(COMMAND "${LDP3C}" --lib "${INPUT}" -o "${ldb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --lib failed (exit ${rc})")
endif()
if(NOT EXISTS "${ldb}")
    message(FATAL_ERROR "no .ldb was written at ${ldb}")
endif()
if(NOT EXISTS "${ldh}")
    message(FATAL_ERROR "no .ldh was written at ${ldh}")
endif()

execute_process(COMMAND "${LDP3C}" --dump-ldb "${ldb}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --dump-ldb failed (exit ${rc})")
endif()

string(FIND "${out}" "${CONTAINS}" found)
if(found EQUAL -1)
    message(FATAL_ERROR "dump missing expected text:\n  got:    [${out}]\n  needle: [${CONTAINS}]")
endif()

message(STATUS "OK: bundle dump contains [${CONTAINS}]")
