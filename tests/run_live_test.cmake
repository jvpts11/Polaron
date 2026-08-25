# WHAT A PROGRAM STILL HOLDS WHEN IT ENDS, against a recorded number.
#
# THIS IS THE HALF OF THE INSTRUMENT THAT SURVIVES THE DELETION.
#
# `run_pir_behaviour_test` compares the two back ends: it can say they disagree, and it stops saying
# anything the moment one of them is gone. Worse, it was never able to say the other thing at all --
# PIR was built against the trusted path, so a defect in BOTH never diverges and never appeared. Five
# memory defects reached the census that way; three of the four found afterwards were wrong answers
# rather than divergences.
#
# An absolute check has no such blind spot. `bytes=N count=M` is a fact about the program, held
# against a number written down here by somebody who looked. When it moves, either the program
# changed or a defect landed, and the diff says which.
#
# Required: POLC, CLANG, INPUT, WORKDIR, EXPECT_LIVE ("bytes/count", e.g. "112/5").
# Optional: RT (the clang-built runtime object), RUNARGS, EXPECT_OUT (substring of stdout).
get_filename_component(tag "${INPUT}" NAME_WE)

if(NOT RT OR NOT EXISTS "${RT}")
    foreach(ext ".obj" ".o")
        if(EXISTS "${WORKDIR}/polaron_rt_clang${ext}")
            set(RT "${WORKDIR}/polaron_rt_clang${ext}")
            break()
        endif()
    endforeach()
endif()
if(NOT EXISTS "${RT}")
    message(FATAL_ERROR "the clang-built runtime object is missing; looked in ${WORKDIR}")
endif()

set(ll "${WORKDIR}/live_${tag}.ll")
set(exe "${WORKDIR}/live_${tag}.exe")

execute_process(COMMAND "${POLC}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()
execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${RT}"
                -llegacy_stdio_definitions -o "${exe}" RESULT_VARIABLE rc ERROR_VARIABLE lk)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang link failed (exit ${rc})\n${lk}")
endif()

separate_arguments(_args UNIX_COMMAND "${RUNARGS}")
set(ENV{POLARON_LIVE} "1")
execute_process(COMMAND "${exe}" ${_args}
                OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc TIMEOUT 60)
unset(ENV{POLARON_LIVE})
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc}\n  stdout: [${out}]\n  stderr: [${err}]")
endif()

# The reporter writes to stderr, deliberately: it is a diagnostic and not part of what the program
# says. A sample whose own output matters says so with EXPECT_OUT.
if(NOT err MATCHES "\\[live\\] bytes=([0-9]+) count=([0-9]+)")
    message(FATAL_ERROR "no live report -- was the runtime built with the reporter?\n  stderr: [${err}]")
endif()
set(got "${CMAKE_MATCH_1}/${CMAKE_MATCH_2}")
if(NOT got STREQUAL EXPECT_LIVE)
    message(FATAL_ERROR
            "live blocks at exit changed.\n"
            "  expected: ${EXPECT_LIVE}\n"
            "  got:      ${got}\n"
            "\n"
            "This number is what the program still holds when it ends. It moving means the program\n"
            "allocates or releases differently than when the expectation was recorded -- a leak, a\n"
            "release that stopped happening, or a deliberate change nobody updated this line for.\n"
            "Run with POLARON_LIVE=2 for the breakdown by size class: a 24-byte block is a String\n"
            "object and almost nothing else, so the histogram usually names it.")
endif()

if(DEFINED EXPECT_OUT)
    string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
    string(STRIP "${out}" out)
    string(FIND "${out}" "${EXPECT_OUT}" found)
    if(found EQUAL -1)
        message(FATAL_ERROR "output missing expected text:\n  got:    [${out}]\n  needle: [${EXPECT_OUT}]")
    endif()
endif()
