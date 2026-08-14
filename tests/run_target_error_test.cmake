# Assert that compiling for a target REFUSES a feature that target does not have, via `cmake -P`.
#
# The port's whole agreement is that an old or small machine may be missing something and the compiler
# says which (docs/design/porting-architectures.md). A refusal is therefore a FEATURE, and needs a test
# shaped like one: compile for the target, expect a non-zero exit, and expect the reason in the text.
#
# Matching the sentence and not just "it failed" is the point -- a compiler that refuses for an
# unrelated reason would pass a test that only checked the exit code.
#
# Required -D args: POLC, INPUT, TARGET_TRIPLE, EXPECT_ERROR, WORKDIR.
string(MD5 _tag "${INPUT}|${TARGET_TRIPLE}")
set(ll "${WORKDIR}/tgterr_${_tag}.ll")

execute_process(COMMAND "${POLC}" "${INPUT}" "--target=${TARGET_TRIPLE}" -o "${ll}"
                RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(rc EQUAL 0)
    message(FATAL_ERROR "polc ACCEPTED ${INPUT} for ${TARGET_TRIPLE}; it should have refused with:\n  ${EXPECT_ERROR}")
endif()
set(_all "${out}${err}")
string(FIND "${_all}" "${EXPECT_ERROR}" _found)
if(_found EQUAL -1)
    message(FATAL_ERROR "polc refused, but not for the expected reason\n  wanted: ${EXPECT_ERROR}\n  got:    ${_all}")
endif()
message(STATUS "OK: ${TARGET_TRIPLE} refuses it, with the reason")
