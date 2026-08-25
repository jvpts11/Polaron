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
    # A SAMPLE THAT READS gets what it reads, when the corpus has it.
    #
    # `tic_tac_toe` asks for a move and loops until the game ends. Run with no stdin, `readInt`
    # fails at EOF, the loop never terminates, and the ten-second timeout cuts it at wherever each
    # binary happened to be -- so the comparison measured the CLOCK. It reported the two backends
    # disagreeing on a sample whose 37 lines are identical when the moves are supplied, and it did
    # so for the first time on a commit that changed nothing but an allocation. A differential that
    # a speed change can flip is not measuring what it claims to.
    set(feed "")
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/samples/${tag}.in")
        set(feed INPUT_FILE "${CMAKE_CURRENT_LIST_DIR}/samples/${tag}.in")
    endif()
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE oldOut ERROR_QUIET RESULT_VARIABLE rc
                    ${feed} TIMEOUT 10)

    set(ENV{POLARON_VIA_PIR} "1")
    execute_process(COMMAND "${POLC}" "${f}" -o "${ll}" RESULT_VARIABLE rc ERROR_QUIET)
    if(NOT rc EQUAL 0)
        # A CRASH IS NOT A DIFFERENCE. It is named separately and fails the test outright: a
        # compiler that dies tells the person compiling nothing at all.
        if(rc GREATER 100)
            list(APPEND crashed "${tag}")
        endif()
        math(EXPR broke "${broke} + 1")
        list(APPEND brokeList "${tag}(polc)")
        continue()
    endif()
    execute_process(COMMAND "${CLANG}" -Wno-override-module "${ll}" "${RT}"
                    -llegacy_stdio_definitions -o "${exe}" RESULT_VARIABLE rc ERROR_QUIET)
    if(NOT rc EQUAL 0)
        math(EXPR broke "${broke} + 1")
        list(APPEND brokeList "${tag}(link)")
        continue()
    endif()
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE pirOut ERROR_QUIET RESULT_VARIABLE rc
                    ${feed} TIMEOUT 10)
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
        # NAMED, for the same reason the agreeing ones are: a count that says "one differs" sends
        # somebody through the whole corpus by hand to find which. This list is what the failure
        # below prints, and it is the difference between a re-run and a fix.
        list(APPEND differList "${tag}")
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
# A DISAGREEMENT FAILS ON ITS OWN, and until now it did not.
#
# The only check here was the COUNT, and the count catches a disagreement only while the corpus
# holds still: a sample that stops agreeing lowers `same` by one, which trips the ratchet. But the
# picked set is `every Nth of the whole directory`, so ADDING samples re-picks it and moves the
# count for a reason that has nothing to do with the backends -- the header of this file already
# records that happening once, when the number fell from 31 to 13 on a change to the stride alone.
#
# Two causes, one number, and the message underneath asserted the wrong one of them: "something that
# used to produce the same output no longer does" is a claim the count cannot make. So the thing the
# test is named for is now tested directly, and it is corpus-independent: if two backends print
# different things for the same program, that is the failure, whatever the count says.
if(differ GREATER 0)
    message(FATAL_ERROR
            "the two backends print different things for ${differ} sample(s): ${differList}. "
            "The trusted path is right until proven otherwise -- see docs/design/polaron-ir.md.")
endif()
if(broke GREATER 0)
    message(FATAL_ERROR
            "${broke} sample(s) do not build through PIR: ${brokeList}. "
            "A comparison whose two sides cannot both be built is not a comparison.")
endif()
if(same LESS EXPECT_SAME)
    message(FATAL_ERROR
            "the PIR path agrees on ${same} samples and the ratchet is set at ${EXPECT_SAME}, and "
            "nothing differs or fails to build -- so the picked set has changed rather than the "
            "lowering. `every Nth of the directory` re-picks whenever a sample is added. Set the "
            "ratchet to ${same} in tests/CMakeLists.txt, and say in the same change what was added.")
endif()
if(same GREATER EXPECT_SAME)
    message(STATUS "pir batch: the ratchet at ${EXPECT_SAME} can be raised to ${same}")
endif()
