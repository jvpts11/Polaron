# THE SHAPE OF ONE FUNCTION, WRITTEN DOWN.
#
# The shape gate compares two back ends and says whether they agree. Wave 2 removes the second one,
# and with it the only thing that has ever noticed a change in what the compiler emits. This is what
# replaces it: a small number of functions whose IR is recorded, so that a change in any of them is
# a diff a reader can look at rather than a number nobody can act on.
#
# NOT THE WHOLE MODULE. A golden file over an entire program is a wall that gets regenerated on sight
# -- the useful gate is a FUNCTION whose exact shape is the point of some rule, held small enough
# that a diff is readable. What is chosen is listed at the registration site, one line of reasoning
# each.
#
# Set POLARON_BLESS_GOLDEN=1 in the environment to write the current output over the recording. That
# is the only way to update one, and it is deliberately a thing you have to decide to do.
#
# Required: POLC, INPUT, FUNCTION (the LLVM symbol), GOLDEN (the recorded file), WORKDIR.
# Optional: POLARONFLAGS.
get_filename_component(tag "${INPUT}" NAME_WE)
set(ll "${WORKDIR}/golden_${tag}.ll")

# THE RECORDED SHAPE IS THE RULE, AND THE HOST IS NOT PART OF IT. Compiled for whatever machine
# happens to run the suite, the same function reads differently -- and the arm64 runner the CI adds
# would rewrite every recording. The target is pinned to the one the recordings were made for, so a
# Linux or an arm64 run compares like with like.
separate_arguments(_pf UNIX_COMMAND "${POLARONFLAGS}")
execute_process(COMMAND "${POLC}" ${_pf} --target=x86_64-pc-windows-msvc "${INPUT}" -o "${ll}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}")
endif()

# One function, from its `define` line to the closing brace at column zero. Walked line by line
# rather than matched whole: CMake's regex engine has no lazy quantifier, so a pattern spanning the
# body would run to the LAST closing brace in the module.
file(STRINGS "${ll}" lines)
set(body "")
set(inside FALSE)
foreach(line IN LISTS lines)
    if(NOT inside)
        if(line MATCHES "^define .*@\"?${FUNCTION}\"?\\(")
            set(inside TRUE)
        else()
            continue()
        endif()
    endif()
    # Value numbers move whenever anything before them changes, and a recording that fails on
    # renumbering is one nobody reads. What is compared is the SHAPE: which instructions are
    # emitted, in what order, with what operands named structurally.
    string(REGEX REPLACE "%[0-9]+" "%_" line "${line}")
    string(REGEX REPLACE "[ \t]+" " " line "${line}")
    # LLVM'S OWN SPELLING IS NOT THIS COMPILER'S DECISION. LLVM 19 gave `getelementptr` a `nuw` flag
    # and its printer emits `inbounds nuw` where 18 printed `inbounds`, so recordings made against 18
    # failed against 21 on every struct field access -- a difference in the library's text, not in
    # what this compiler chose to emit. Folded to the one spelling both print, so a recording
    # outlives an LLVM upgrade instead of being re-blessed by whoever upgrades first.
    string(REPLACE "getelementptr inbounds nuw " "getelementptr inbounds " line "${line}")
    set(body "${body}${line}\n")
    if(line STREQUAL "}")
        break()
    endif()
endforeach()
if(NOT inside)
    message(FATAL_ERROR "no function '${FUNCTION}' in the emitted module -- was it renamed, or "
                        "dropped as unreachable?")
endif()

if(DEFINED ENV{POLARON_BLESS_GOLDEN})
    file(WRITE "${GOLDEN}" "${body}")
    message(STATUS "golden: rewrote ${GOLDEN}")
    return()
endif()

if(NOT EXISTS "${GOLDEN}")
    message(FATAL_ERROR "no recording at ${GOLDEN}. Run once with POLARON_BLESS_GOLDEN=1 to make "
                        "one, and READ it before committing it.")
endif()
file(READ "${GOLDEN}" want)
if(NOT body STREQUAL want)
    message(FATAL_ERROR
            "the emitted shape of '${FUNCTION}' changed.\n"
            "--- recorded ---\n${want}\n"
            "--- emitted ---\n${body}\n"
            "If the change is intended, read both, then re-record with POLARON_BLESS_GOLDEN=1.")
endif()
