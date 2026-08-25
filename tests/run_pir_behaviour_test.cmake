# Stage 3's real oracle: the two paths COMPILE, LINK, RUN, and print the same thing.
#
# Comparing names was the first approximation and it could only ever say that a function exists. This
# says the program DOES the same thing -- which is the only claim that justifies turning the trusted
# path off, and it is the claim the design named: "compile all samples both ways and require the
# programs to print the same output".
#
# AND WHAT IT DOES TO MEMORY, which printing cannot show.
#
# Comparing stdout is the strongest single piece of evidence there is, and it has now missed FIVE
# memory defects for one reason: a leak, a per-iteration allocation, a value type put on the heap, an
# array strided wrongly and a String field that lost its owner all print exactly what a correct
# program prints. `POLARON_LIVE=1` makes the runtime print the live-block total at exit, and the two
# arms must agree about that too.
#
# Required: POLC, CLANG, INPUT, WORKDIR, RT (the clang-built runtime object).
# Optional: LIVE_KNOWN -- see the waiver at the bottom.
get_filename_component(tag "${INPUT}" NAME_WE)
if(NOT DEFINED LIVE_KNOWN)
    set(LIVE_KNOWN "")
endif()

# The clang-built runtime object, found rather than passed in: the CMake variable that names it is
# defined further down the test list than this test is registered, so it arrived empty and the link
# failed on `__polaron_malloc` -- which reads as a compiler bug and is not one.
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

function(build_and_run mode outVar liveVar)
    set(ll "${WORKDIR}/beh_${tag}_${mode}.ll")
    set(exe "${WORKDIR}/beh_${tag}_${mode}.exe")
    # BOTH ARMS NAME WHAT THEY WANT. The PIR backend is the default, so leaving the switch alone
    # would make the "trusted" arm compile the PIR path and compare it with itself.
    if(mode STREQUAL "pir")
        set(ENV{POLARON_VIA_PIR} "1")
    else()
        set(ENV{POLARON_VIA_PIR} "0")
    endif()
    execute_process(COMMAND "${POLC}" "${INPUT}" -o "${ll}" RESULT_VARIABLE rc ERROR_VARIABLE err)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "[${mode}] polc failed:\n${err}")
    endif()
    execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${RT}"
                    -llegacy_stdio_definitions -o "${exe}" RESULT_VARIABLE rc ERROR_VARIABLE err)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "[${mode}] link failed:\n${err}")
    endif()
    # The live total goes to stderr, so stdout stays exactly what the program printed and the
    # comparison above is unaffected by asking for it.
    set(ENV{POLARON_LIVE} "1")
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out ERROR_VARIABLE errOut RESULT_VARIABLE rc)
    unset(ENV{POLARON_LIVE})
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "[${mode}] the program exited ${rc}")
    endif()
    set(live "")
    if(errOut MATCHES "\\[live\\] bytes=([0-9-]+) count=([0-9-]+)")
        set(live "${CMAKE_MATCH_1}/${CMAKE_MATCH_2}")
    endif()
    set(${outVar} "${out}" PARENT_SCOPE)
    set(${liveVar} "${live}" PARENT_SCOPE)
endfunction()

build_and_run("old" oldOut oldLive)
build_and_run("pir" pirOut pirLive)

if(NOT oldOut STREQUAL pirOut)
    message(FATAL_ERROR
            "the two paths disagree about what the program does.\n"
            "trusted path printed:\n${oldOut}\n"
            "PIR path printed:\n${pirOut}")
endif()
message(STATUS "pir behaviour: both paths printed the same output")

# The runtime must have answered. A silent miss here would turn the whole memory half of this oracle
# into a check that passes because it never ran -- which is the failure this file exists to stop.
if(oldLive STREQUAL "" OR pirLive STREQUAL "")
    message(FATAL_ERROR
            "POLARON_LIVE produced no report (trusted='${oldLive}' pir='${pirLive}'). The runtime "
            "object linked here is older than the reporter, or the reporter stopped being emitted.")
endif()

set(seen "${oldLive}|${pirLive}")

if(oldLive STREQUAL pirLive)
    message(STATUS "pir behaviour: both paths left ${oldLive} bytes/blocks live at exit")
    if(NOT LIVE_KNOWN STREQUAL "")
        message(STATUS
                "pir behaviour: the two agree now -- LIVE_KNOWN=\"${LIVE_KNOWN}\" is stale and "
                "should be removed from this test's registration")
    endif()
elseif(seen STREQUAL LIVE_KNOWN)
    # A WAIVER THAT PINS BOTH SIDES, not an allowance that tolerates a range.
    #
    # One KNOWN defect makes the two arms differ on every program in the corpus: PIR does not
    # implement String field ownership (tests/pir_shape_baseline.md, D1), so the trusted path exits
    # holding two copied Strings that PIR never made. A test that is red everywhere is a test nobody
    # reads -- and an allowance with slack in it would swallow the NEXT defect too.
    #
    # So the waiver is the exact pair, and any movement in either number fails. When Wave 1 fixes
    # D1 the two become equal, the branch above fires and says the waiver is stale.
    message(STATUS
            "pir behaviour: live totals differ as known (trusted=${oldLive} pir=${pirLive}) -- "
            "String field ownership, tests/pir_shape_baseline.md D1")
else()
    message(FATAL_ERROR
            "the two paths disagree about MEMORY, while printing the same thing.\n"
            "trusted path left: ${oldLive} bytes/blocks live at exit\n"
            "PIR path left:     ${pirLive}\n"
            "known for this test: \"${LIVE_KNOWN}\" (empty means none is expected)\n"
            "This is the class of defect stdout cannot see; see tests/pir_shape_baseline.md.")
endif()
