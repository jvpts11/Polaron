# THE STANDARD LIBRARY'S OWN ADVICE, COUNTED AND HELD.
#
# The advice is hidden from someone compiling their own program, because they cannot act on a warning
# about code they did not write. That is right for the reader and wrong for the library: it left the
# one code base every program links against as the only one nothing was cbserving. A warning that
# fires in the prelude is not noise to be filtered -- it is work, and this is what makes it work
# somebody has to do rather than work somebody may notice. (The library was the only code base
# nothing was watching, which is the opposite of what the library deserves.)
#
# A ratchet rather than a target. Each code has a number here, and the number may go DOWN freely; it
# may never go up. So a rule can be added with the prelude as it stands, the count becomes the debt
# the rule found, and no change may add to it. When a count falls, the test says so and asks for the
# number to be lowered, which is how the debt stops being able to come back.
#
# Required -D args: POLC, INPUT, BASELINE, WORKDIR

execute_process(COMMAND "${POLC}" --check "${INPUT}" --lint-prelude
                OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
set(all "${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}\n${all}")
endif()

# Only the prelude's own lines: a diagnostic about the sample itself is somebody else's test.
string(REPLACE "\n" ";" lines "${all}")
set(seen "")
foreach(line IN LISTS lines)
    if(NOT line MATCHES "<prelude")
        continue()
    endif()
    if(line MATCHES "warning\\[(Polaron-[0-9A-F]+)\\]")
        list(APPEND seen "${CMAKE_MATCH_1}")
    endif()
endforeach()

file(STRINGS "${BASELINE}" baselineLines)
set(failed "")
set(loosened "")
foreach(row IN LISTS baselineLines)
    if(row MATCHES "^#" OR row STREQUAL "")
        continue()
    endif()
    string(REGEX MATCH "^([^ ]+) +([0-9]+)$" ok "${row}")
    if(NOT ok)
        message(FATAL_ERROR "the baseline has a line that is not `<code> <count>`: ${row}")
    endif()
    set(code "${CMAKE_MATCH_1}")
    set(allowed "${CMAKE_MATCH_2}")
    set(n 0)
    foreach(s IN LISTS seen)
        if(s STREQUAL code)
            math(EXPR n "${n} + 1")
        endif()
    endforeach()
    if(n GREATER allowed)
        list(APPEND failed "  ${code}: ${n} now, ${allowed} allowed (+${n})")
    elseif(n LESS allowed)
        list(APPEND loosened "  ${code}: ${n} now, baseline says ${allowed}")
    endif()
endforeach()

if(failed)
    string(REPLACE ";" "\n" report "${failed}")
    message(FATAL_ERROR
        "the standard library earned more advice than its baseline allows:\n${report}\n\n"
        "  This is not a reason to soften the rule. A warning in the prelude is a place the library\n"
        "  does not follow the language it defines, and every program links against it.\n"
        "  Fix the code, or -- if the shape is deliberate -- write the `[Allow(code:, why:)]` where\n"
        "  the reason belongs. Raising the baseline is not one of the three options.\n"
        "  The baseline is ${BASELINE}")
endif()
if(loosened)
    string(REPLACE ";" "\n" report "${loosened}")
    message(FATAL_ERROR
        "the standard library now earns LESS advice than its baseline allows:\n${report}\n\n"
        "  Lower the numbers in ${BASELINE} to what they are now. A ratchet that is not tightened\n"
        "  after a fix lets the same debt come back without anybody noticing.")
endif()
message(STATUS "prelude advice is within its baseline")
