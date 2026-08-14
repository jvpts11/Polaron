# End-to-end .polb bundle test driver, invoked via `cmake -P`.
#
# Compiles a library .pol to a .polb (+ .polh) with `polc --lib`, checks both files were written,
# then runs `--dump-polb` and matches its output against CONTAINS.
#
# Required -D args: POLC, INPUT, CONTAINS, WORKDIR

set(polb "${WORKDIR}/e2e_bundle.polb")
set(polh "${WORKDIR}/e2e_bundle.polh")

execute_process(COMMAND "${POLC}" --lib "${INPUT}" -o "${polb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib failed (exit ${rc})")
endif()
if(NOT EXISTS "${polb}")
    message(FATAL_ERROR "no .polb was written at ${polb}")
endif()
if(NOT EXISTS "${polh}")
    message(FATAL_ERROR "no .polh was written at ${polh}")
endif()

execute_process(COMMAND "${POLC}" --dump-polb "${polb}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --dump-polb failed (exit ${rc})")
endif()

string(FIND "${out}" "${CONTAINS}" found)
if(found EQUAL -1)
    message(FATAL_ERROR "dump missing expected text:\n  got:    [${out}]\n  needle: [${CONTAINS}]")
endif()

message(STATUS "OK: bundle dump contains [${CONTAINS}]")
