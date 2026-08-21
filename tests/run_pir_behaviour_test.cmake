# Stage 3's real oracle: the two paths COMPILE, LINK, RUN, and print the same thing.
#
# Comparing names was the first approximation and it could only ever say that a function exists. This
# says the program DOES the same thing -- which is the only claim that justifies turning the trusted
# path off, and it is the claim the design named: "compile all samples both ways and require the
# programs to print the same output".
#
# Required: POLC, CLANG, INPUT, WORKDIR, RT (the clang-built runtime object).
get_filename_component(tag "${INPUT}" NAME_WE)

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

function(build_and_run mode outVar)
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
    execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "[${mode}] the program exited ${rc}")
    endif()
    set(${outVar} "${out}" PARENT_SCOPE)
endfunction()

build_and_run("old" oldOut)
build_and_run("pir" pirOut)

if(NOT oldOut STREQUAL pirOut)
    message(FATAL_ERROR
            "the two paths disagree about what the program does.\n"
            "trusted path printed:\n${oldOut}\n"
            "PIR path printed:\n${pirOut}")
endif()
message(STATUS "pir behaviour: both paths printed the same output")
