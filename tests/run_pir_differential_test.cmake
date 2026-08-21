# Stage 3's ORACLE: the two paths, compared.
#
# The stage is "flip the default, keep the old path", and the thing that decides when that is safe
# is not an opinion -- it is this. The same program is compiled twice, once through the direct
# AST->LLVM path and once with POLARON_VIA_PIR=1, and the two are required to agree about what the
# module CONTAINS: the same functions, by name.
#
# It is the same method the reachability work used against LLVM's `GlobalDCE` -- take the existing,
# trusted answer as the truth the new one has to match. Where they differ, the OLD path is right
# until proven otherwise.
#
# What this does NOT yet check is the emitted bodies. The lowering still has gaps (it counts them),
# so requiring identical IR today would fail for reasons that are already known and already listed.
# Names first: a function the PIR path never emitted is the failure that must not be discovered
# after the default is flipped.
#
# ASKED FOR BY NAME. The PIR backend IS the default now, so running polc with the variable alone
# would build the PIR path for this arm too, compare it with itself, and pass on every program --
# which is precisely the failure this test exists to catch, wearing the test's own clothes.
set(ENV{POLARON_VIA_PIR} "0")
execute_process(COMMAND "${POLC}" "${INPUT}" -o "${OUT_OLD}"
                ERROR_VARIABLE oldErr RESULT_VARIABLE oldRc)
if(NOT oldRc EQUAL 0)
    message(FATAL_ERROR "the old path failed:\n${oldErr}")
endif()

set(ENV{POLARON_VIA_PIR} "1")
execute_process(COMMAND "${POLC}" "${INPUT}" --emit-pir=${OUT_PIR} -o "${OUT_NEW}"
                ERROR_VARIABLE newErr RESULT_VARIABLE newRc)
if(NOT newRc EQUAL 0)
    message(FATAL_ERROR "the PIR path failed:\n${newErr}")
endif()

file(READ "${OUT_OLD}" oldIr)
file(READ "${OUT_PIR}" pirText)

# Every function the old path DEFINED must exist in the PIR module. A definition that vanished is
# the failure this test exists for.
string(REGEX MATCHALL "\ndefine[^@]*@\"?[A-Za-z0-9_$.~]+" oldDefs "${oldIr}")
set(missing "")
foreach(d ${oldDefs})
    string(REGEX REPLACE ".*@\"?" "" name "${d}")
    # The runtime's own entry points and LLVM intrinsics are not Polaron methods and have no PIR.
    if(NOT name MATCHES "^(main|llvm|__polaron|memcpy|memset|memmove)")
        # A LITERAL SEARCH, not a regex. A Polaron key contains `.` and `$`, which are regex
        # metacharacters -- `fn @Noisy.Noisy(` is not a pattern CMake can even compile, and the
        # first run of this test failed on that rather than on anything about the compiler.
        string(FIND "${pirText}" "fn @${name}(" at)
        if(at EQUAL -1)
            list(APPEND missing "${name}")
        endif()
    endif()
endforeach()

list(LENGTH oldDefs total)
list(LENGTH missing gone)
message(STATUS "pir differential: ${total} definitions in the old path, ${gone} absent from PIR")

# A RATCHET, not a pass/fail line drawn where the work happens to be today.
#
# The migration is incremental by design (§14), so "no definition may be missing" would be red for
# every commit until the last one -- a test that is always red is a test nobody reads. `ALLOWED` is
# the number that is missing right now; the test fails if it GROWS. What is left is mostly what the
# front end SYNTHESISES rather than what a program declares: an implicit constructor, a class-load
# hook. Each one that gets lowered is a number to lower here, and the number can only go down.
if(gone GREATER ALLOWED)
    list(LENGTH missing n)
    if(n GREATER 10)
        list(SUBLIST missing 0 10 missing)
    endif()
    message(FATAL_ERROR
            "the PIR path is missing ${gone} of ${total} definitions, and the ratchet is set at "
            "${ALLOWED}. Newly absent, e.g.:\n${missing}")
endif()
if(gone LESS ALLOWED)
    message(STATUS "pir differential: the ratchet at ${ALLOWED} can be lowered to ${gone}")
endif()
