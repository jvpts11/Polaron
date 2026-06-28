# End-to-end multi-bundle vtable-conflict test driver, invoked via `cmake -P`.
#
# Builds two bundles whose vtable slot layouts collide, then compiles a consumer that depends on both.
# Linking them is unsound, so ldp3c must reject it with a message matching CONTAINS.
#
# Required -D args: LDP3C, LIB, LIB2, APP, CONTAINS, WORKDIR

set(ldb1 "${WORKDIR}/e2e_conflict1.ldb")
set(ldb2 "${WORKDIR}/e2e_conflict2.ldb")
set(ll "${WORKDIR}/e2e_conflict.ll")

execute_process(COMMAND "${LDP3C}" --lib "${LIB}" -o "${ldb1}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --lib (LIB) failed (exit ${rc})")
endif()
execute_process(COMMAND "${LDP3C}" --lib "${LIB2}" -o "${ldb2}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --lib (LIB2) failed (exit ${rc})")
endif()

execute_process(COMMAND "${LDP3C}" "${APP}" --use "${ldb1}" --use "${ldb2}" -o "${ll}"
    RESULT_VARIABLE rc ERROR_VARIABLE err)
if(rc EQUAL 0)
    message(FATAL_ERROR "expected a conflict error, but compilation succeeded")
endif()
string(FIND "${err}" "${CONTAINS}" found)
if(found EQUAL -1)
    message(FATAL_ERROR "wrong error:\n  got:    [${err}]\n  needle: [${CONTAINS}]")
endif()

message(STATUS "OK: rejected conflicting bundles")
