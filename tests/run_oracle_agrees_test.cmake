# TWO ANSWERS TO ONE QUESTION, AND THEY MUST AGREE.
#
# `polc` computes some facts twice, deliberately, by routes that share nothing: reachability against
# LLVM's `GlobalDCE` (§11.9), and now which parameters a method keeps -- the region binder's
# `escapesToReceiver`, read off the AST by pattern, against §11.5's summary, computed from the
# instructions. When one of those pairs disagrees, `polc` says so on stderr, and this asserts it does
# not for the given program.
#
# A TEST WHOSE PASSING CONDITION IS SILENCE is a weak test on its own, and worth being honest about:
# it cannot be made to fail except by a compiler defect, so it proves nothing about the day it was
# written. What it is for is the day AFTER -- a change to either side of the pair that makes them
# disagree stops being a thing somebody has to notice by reading, on the programs the suite already
# compiles. That is the whole value of computing something twice, and it is worth nothing unless
# something is watching the comparison.
#
# Run over a program chosen for having a lot of the shape in question, rather than over a minimal
# one: an oracle looks at real traffic or it looks at nothing.
#
# Required -D args: POLC, INPUT, MARKER (the prefix `polc` prints a disagreement under), WORKDIR.
# Optional: POLARONFLAGS (semicolon-separated).
string(MD5 _tag "${INPUT}|oracle|${MARKER}")
set(ll "${WORKDIR}/oracle_${_tag}.ll")

separate_arguments(_extra UNIX_COMMAND "${POLARONFLAGS}")
execute_process(COMMAND "${POLC}" ${_extra} "${INPUT}" -o "${ll}"
                RESULT_VARIABLE rc ERROR_VARIABLE err OUTPUT_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc failed (exit ${rc}) on ${INPUT}\n${err}")
endif()

string(FIND "${err}" "${MARKER}" _found)
if(NOT _found EQUAL -1)
    # The whole of stderr, not the matching line: a disagreement is a compiler defect and the reader
    # is about to go looking for which half is wrong, so everything the compile said is context.
    message(FATAL_ERROR
        "the two answers disagree -- `${MARKER}` appeared\n  input: ${INPUT}\n\n${err}")
endif()
message(STATUS "OK: no `${MARKER}` -- the two answers agree on ${INPUT}")
