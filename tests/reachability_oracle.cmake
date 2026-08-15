# THE ORACLE FOR REACHABILITY-DRIVEN EMISSION.
#
# `emitFunctions` produces a body for every method in the program, including all ~320 classes of the
# standard library, and `GlobalDCE` then deletes what nothing reaches: measured on hello_world, 323
# classes are emitted and TWO functions survive. Emitting only what is reachable removes that waste --
# and the risk of it is a missed edge, which is a symbol that is not there.
#
# That risk is testable, because the answer already exists: LLVM's GlobalDCE computes the true
# reachable set on the IR. So this compiles one program twice -- with the pass off and with it on --
# and requires the two FINAL modules to name exactly the same functions. Not a subset: the same set.
# DCE runs in both builds, so an over-approximating pass still lands on the identical result, and a
# pass that misses something lands on a smaller one.
#
# Required -D args: POLC, INPUT, WORKDIR. Optional: EXTRA (extra polc flags, e.g. --target=...).

get_filename_component(_tag "${INPUT}" NAME_WE)
set(_off "${WORKDIR}/reach_${_tag}_off.ll")
set(_on  "${WORKDIR}/reach_${_tag}_on.ll")

if(NOT DEFINED EXTRA)
    set(EXTRA "")
endif()

execute_process(COMMAND "${CMAKE_COMMAND}" -E env POLARON_NO_REACHABILITY=1
                        "${POLC}" ${EXTRA} "${INPUT}" -o "${_off}" RESULT_VARIABLE _rc1
                OUTPUT_QUIET ERROR_VARIABLE _err1)
if(NOT _rc1 EQUAL 0)
    message(FATAL_ERROR "polc failed with reachability OFF (exit ${_rc1}):\n${_err1}")
endif()

execute_process(COMMAND "${POLC}" ${EXTRA} "${INPUT}" -o "${_on}" RESULT_VARIABLE _rc2
                OUTPUT_QUIET ERROR_VARIABLE _err2)
if(NOT _rc2 EQUAL 0)
    message(FATAL_ERROR "polc failed with reachability ON (exit ${_rc2}):\n${_err2}")
endif()

# Every NAMED symbol the module defines -- functions and globals both, because a vtable is a global
# and a vtable is what caught the first hole: emitting one for a class whose bodies were skipped asks
# the linker for symbols that do not exist (`undefined symbol: IpcError.message, referenced by
# .rdata`). Comparing only functions would have missed it.
#
# COMPILER-NUMBERED names are excluded, and that is not a loophole: `@.str.8556`, `@__polaron_lambda_5`
# and `@__polaron_closure.3285` are counters over what has been emitted so far, so emitting less
# renumbers them all while naming exactly the same things. Their COUNT is compared instead, which is
# the part that carries meaning.
function(_named_symbols path out count)
    file(STRINGS "${path}" _lines REGEX "^(define|@)")
    set(_syms "")
    set(_n 0)
    foreach(_l IN LISTS _lines)
        set(_name "")
        if(_l MATCHES "^define[^@]*@([A-Za-z0-9_.$\"]+)\\(")
            set(_name "${CMAKE_MATCH_1}")
        elseif(_l MATCHES "^(@[A-Za-z0-9_.$\"]+) =")
            set(_name "${CMAKE_MATCH_1}")
        endif()
        if(_name STREQUAL "")
            continue()
        endif()
        # WITH OR WITHOUT THE NUMBER. LLVM gives the FIRST global of a name the bare form and numbers
        # the rest, so `@.cl` and `@.cl.59` are the same kind of thing and which one exists depends on
        # what else was emitted: measured here as 60 numbered + 0 bare against 59 + 1 bare, the same
        # sixty constants. Treating the bare form as a NAMED symbol reported that as a difference,
        # which it is not. A real global never begins with `@.` -- those are the compiler's own.
        if(_name MATCHES "^@?\\.[A-Za-z]+(\\.[0-9]+)?$" OR
           _name MATCHES "^@?__polaron_(lambda|closure)[._][0-9]+$")
            math(EXPR _n "${_n} + 1")
        else()
            list(APPEND _syms "${_name}")
        endif()
    endforeach()
    list(SORT _syms)
    set(${out} "${_syms}" PARENT_SCOPE)
    set(${count} "${_n}" PARENT_SCOPE)
endfunction()

_named_symbols("${_off}" _symsOff _nOff)
_named_symbols("${_on}" _symsOn _nOn)

if(NOT _nOff EQUAL _nOn)
    message(FATAL_ERROR
        "reachability changed how many compiler-numbered globals there are: ${_nOff} -> ${_nOn}.\n"
        "  Their names carry no meaning, but their COUNT does -- one fewer is one that went missing.")
endif()

if(NOT "${_symsOff}" STREQUAL "${_symsOn}")
    # Say WHICH ones differ, in both directions: one missing is a hole in the roots, one extra is the
    # pass keeping something DCE would have dropped (harmless, but worth knowing).
    set(_missing "")
    foreach(_s IN LISTS _symsOff)
        if(NOT "${_s}" IN_LIST _symsOn)
            list(APPEND _missing "${_s}")
        endif()
    endforeach()
    set(_extra "")
    foreach(_s IN LISTS _symsOn)
        if(NOT "${_s}" IN_LIST _symsOff)
            list(APPEND _extra "${_s}")
        endif()
    endforeach()
    message(FATAL_ERROR
        "reachability changed the program.\n"
        "  MISSING with the pass on (a hole in the roots): ${_missing}\n"
        "  EXTRA with the pass on (kept something DCE dropped): ${_extra}")
endif()
