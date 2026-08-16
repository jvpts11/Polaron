# EVERY DIAGNOSTIC CARRIES A CODE, or the reader gets a bare line and nothing else.
#
# A code is not decoration: it is what attaches the `why` / `fix` / `prevent` prose and what
# `polc --explain` looks up. Without one the compiler prints a sentence and stops there, which is the
# difference between a diagnostic that teaches and a diagnostic that merely refuses.
#
# WHY THIS HAS TO BE A TEST. Codes are attached by matching text in the message (see catalog.cpp), so
# rewording a message silently drops its code -- the diagnostic still prints, still looks fine, and
# has quietly lost half of itself. Nothing else in the build would notice. Measured before this
# guard existed: 45 of 111 diagnostics across the error corpus had no code at all.
#
# THE CORPUS MAINTAINS ITSELF. Rather than a list that drifts, this reads the suite's own
# CMakeLists.txt for every program registered as `polc --check .../samples/X.pol` -- which is exactly
# the set of programs the suite already asserts are errors. A new negative test joins the guard by
# existing.

file(READ "${DIR}/CMakeLists.txt" _tests_src)
string(REGEX MATCHALL "samples/[A-Za-z0-9_.]+\\.pol" _hits "${_tests_src}")
list(REMOVE_DUPLICATES _hits)

set(_bare "")
set(_checked 0)
set(_coded 0)
foreach(_rel IN LISTS _hits)
    set(_file "${DIR}/${_rel}")
    if(NOT EXISTS "${_file}")
        continue()
    endif()
    execute_process(COMMAND "${POLC}" --check "${_file}"
                    OUTPUT_VARIABLE _out ERROR_VARIABLE _err RESULT_VARIABLE _rc)
    set(_all "${_out}${_err}")
    string(REPLACE "\n" ";" _lines "${_all}")
    foreach(_line IN LISTS _lines)
        # A diagnostic line is "file:line:col: error: ..." or "... error[Polaron-NNNN]: ...".
        #
        # WARNINGS COUNT TOO, and they were the worse half: 1309 of them across this corpus with
        # exactly one code between them. A warning needs its `why` MORE than an error does -- an
        # error at least stops you, while a warning is only worth printing if the reader can tell
        # from it whether it applies to them.
        if(_line MATCHES "(error|warning)\\[Polaron-")
            math(EXPR _coded "${_coded}+1")
            math(EXPR _checked "${_checked}+1")
        elseif(_line MATCHES ": (error|warning): ")
            math(EXPR _checked "${_checked}+1")
            list(APPEND _bare "${_rel}: ${_line}")
        endif()
    endforeach()
endforeach()
list(REMOVE_DUPLICATES _bare)

message(STATUS "diagnostics with a code: ${_coded} of ${_checked}")

if(_bare)
    list(LENGTH _bare _n)
    message("")
    message("${_n} diagnostic(s) printed with no code, so they carry no why/fix/prevent and")
    message("`polc --explain` has nothing to say about them:")
    message("")
    foreach(_b IN LISTS _bare)
        message("  ${_b}")
    endforeach()
    message("")
    message("Add a rule to kRules in src/diag/catalog.cpp mapping some stable phrase of the message")
    message("to a Code, and a catalog Entry for that Code if it has none yet. If the message was")
    message("reworded, the old rule's needle no longer matches -- update the needle rather than")
    message("restoring the wording.")
    message(FATAL_ERROR "uncoded diagnostics")
endif()
