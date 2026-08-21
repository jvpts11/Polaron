# THE NUMBER THAT DECIDES WHETHER THE TRUSTED PATH CAN BE TURNED OFF.
#
# Every sample is compiled BOTH ways, linked, run, and the outputs compared. The answer is a count,
# and the count is ratcheted: it may only go UP.
#
# This exists because "the PIR path works" is not a claim anybody can check, and because the first
# time it was measured the answer was 7 of 54 -- which settled the question of whether to flip the
# default far better than any amount of reasoning about it would have. A migration is finished when
# this number is the sample count, and not before.
#
# Required: POLC, CLANG, SAMPLES (the directory), WORKDIR, RT, EXPECT_SAME.
file(GLOB samples "${SAMPLES}/*.pol")
list(SORT samples)
# EVERY Nth, NOT THE FIRST N. This took the head of a sorted list, so the whole ratchet measured
# fifty-four files beginning with `a` and `b` -- and it read 31 of 47 there while a sample spread
# across the same corpus read 19 of 67. Closing whatever the head happened to exercise is not the
# same as closing the lowering, and the number was quietly reporting the first as if it were the
# second. The stride costs exactly the same to run and cannot be over-fitted by alphabet.
list(LENGTH samples total)
math(EXPR stride "(${total} + ${LIMIT} - 1) / ${LIMIT}")
if(stride LESS 1)
    set(stride 1)
endif()
set(picked "")
set(at 0)
foreach(f ${samples})
    math(EXPR pick "${at} % ${stride}")
    if(pick EQUAL 0)
        list(APPEND picked "${f}")
    endif()
    math(EXPR at "${at} + 1")
endforeach()
set(samples ${picked})
message(STATUS "pir batch: ${LIMIT} of ${total} samples, every ${stride}th")

if(NOT RT OR NOT EXISTS "${RT}")
    foreach(ext ".obj" ".o")
        if(EXISTS "${WORKDIR}/polaron_rt_clang${ext}")
            set(RT "${WORKDIR}/polaron_rt_clang${ext}")
            break()
        endif()
    endforeach()
endif()

set(same 0)
set(differ 0)
set(broke 0)
set(crashed "")
foreach(f ${samples})
    get_filename_component(tag "${f}" NAME_WE)
    set(ll "${WORKDIR}/batch_${tag}.ll")
    set(exe "${WORKDIR}/batch_${tag}.exe")

    # The trusted path first. A sample it cannot build or run is not a comparison.
    # ASKED FOR BY NAME, not by leaving the switch alone. The PIR backend is the DEFAULT now, so an
    # unset variable selects it -- and this arm would then compile the PIR path, compare it with
    # itself, and report agreement on every sample in the corpus. That exact failure has already
    # happened here once, silently, for twenty-two samples.
    set(ENV{POLARON_VIA_PIR} "0")
    execute_process(COMMAND "${POLC}" "${f}" -o "${ll}" RESULT_VARIABLE rc ERROR_QUIET)
    if(NOT rc EQUAL 0)
        continue()
    endif()
    execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${RT}"
                    -llegacy_stdio_definitions -o "${exe}" RESULT_VARIABLE rc ERROR_QUIET)
    if(NOT rc EQUAL 0)
        continue()
    endif()
    # A HANGING SAMPLE IS A DIFFERENCE, not a reason to stop measuring. Without a timeout one
    # program that loops forever takes the whole ratchet with it: the run went from ninety seconds
    # to unbounded and reported nothing at all, which is strictly less information than "this one
    # differs". Ten seconds is far more than any sample here needs.
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE oldOut ERROR_QUIET RESULT_VARIABLE rc
                    TIMEOUT 10)

    set(ENV{POLARON_VIA_PIR} "1")
    execute_process(COMMAND "${POLC}" "${f}" -o "${ll}" RESULT_VARIABLE rc ERROR_QUIET)
    if(NOT rc EQUAL 0)
        # A CRASH IS NOT A DIFFERENCE. It is named separately and fails the test outright: a
        # compiler that dies tells the person compiling nothing at all.
        if(rc GREATER 100)
            list(APPEND crashed "${tag}")
        endif()
        math(EXPR broke "${broke} + 1")
        continue()
    endif()
    execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${RT}"
                    -llegacy_stdio_definitions -o "${exe}" RESULT_VARIABLE rc ERROR_QUIET)
    if(NOT rc EQUAL 0)
        math(EXPR broke "${broke} + 1")
        continue()
    endif()
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE pirOut ERROR_QUIET RESULT_VARIABLE rc
                    TIMEOUT 10)
    if(rc STREQUAL "Process terminated due to timeout")
        # Named, because "it hangs" and "it prints the wrong thing" are different bugs and the
        # count alone cannot tell them apart.
        message(STATUS "pir batch: ${tag} HANGS through PIR")
    endif()

    if(oldOut STREQUAL pirOut)
        math(EXPR same "${same} + 1")
        list(APPEND sameList "${tag}")
    else()
        math(EXPR differ "${differ} + 1")
    endif()
endforeach()

message(STATUS "pir batch: ${same} agree, ${differ} differ, ${broke} do not build")
# THE NAMES, not only the count. A ratchet that says "fourteen, and it was fifteen" cannot say
# WHICH one stopped agreeing, and finding that out by hand costs a full re-run of the whole batch
# against a list written down somewhere else. The set is the measurement; the number is a summary
# of it.
message(STATUS "pir batch: agreeing -- ${sameList}")
if(crashed)
    message(FATAL_ERROR "polc CRASHED with POLARON_VIA_PIR=1 on: ${crashed}")
endif()
if(same LESS EXPECT_SAME)
    message(FATAL_ERROR
            "the PIR path agrees on ${same} samples and the ratchet is set at ${EXPECT_SAME}. "
            "Something that used to produce the same output no longer does.")
endif()
if(same GREATER EXPECT_SAME)
    message(STATUS "pir batch: the ratchet at ${EXPECT_SAME} can be raised to ${same}")
endif()
