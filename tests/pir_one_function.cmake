# ONE FUNCTION OUT OF A PIR MODULE, for a test whose claim is about one function.
#
# A module holds the whole prelude and then the program, so a search for `[heap]` or `vtable.load`
# over the file answers a question nobody asked: whether ANY function anywhere has one. The tests
# that need this are the ones where two methods in the SAME program must be decided differently --
# §11.5's `contained` moves to the frame and `handedBack` must not -- and a whole-file search finds
# the second and reports it as the first.
#
# Included rather than duplicated because it is used by both `run_pass_matters_test` and
# `run_pir_contains_test`, and two copies of a slicing rule is two things to get out of step.

# Slice `text` down to the body of `fn @<name>`, leaving it in `outVar`. A name that is not there is
# an error and not an empty string: a test asserting a needle is ABSENT would otherwise pass because
# the function it names was renamed, which is the failure mode this whole file exists to avoid.
function(_narrow text name where outVar)
    string(FIND "${text}" "fn @${name}(" _at)
    if(_at EQUAL -1)
        message(FATAL_ERROR "no function `${name}` in the emitted PIR\n  pir: ${where}")
    endif()
    string(SUBSTRING "${text}" ${_at} -1 _rest)
    # The next function's header ends this one. Two spaces then `fn @` is how the printer indents a
    # function inside a module, so it cannot match anything inside a body.
    string(SUBSTRING "${_rest}" 1 -1 _after)
    string(FIND "${_after}" "\n  fn @" _end)
    if(NOT _end EQUAL -1)
        math(EXPR _end "${_end} + 1")
        string(SUBSTRING "${_rest}" 0 ${_end} _rest)
    endif()
    set(${outVar} "${_rest}" PARENT_SCOPE)
endfunction()
