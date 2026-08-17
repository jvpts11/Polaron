# Compile and RUN every program in examples/, via `cmake -P`.
#
# An example that does not compile is worse than no example: it is a lie told to somebody learning the
# language, in the one place they are most likely to trust. The seven that were here before tonight had
# never been built by anything -- they were text.
#
# So all of them are built and executed, and each one's first line of output is compared against the
# `// Prints:` block in its own header. That block is what a reader believes; this is what makes it true.
#
# Required -D args: POLARON, EXAMPLES (the directory), WORKDIR

file(GLOB examples "${EXAMPLES}/*.pol")
list(SORT examples)
if(NOT examples)
    message(FATAL_ERROR "no examples found in ${EXAMPLES}")
endif()

set(failed "")
foreach(ex IN LISTS examples)
    get_filename_component(name "${ex}" NAME_WE)
    # `polaron run` on a loose file builds it and runs it. WORKDIR keeps the build output out of the
    # source tree, and out of the way of a parallel ctest.
    execute_process(COMMAND "${POLARON}" run "${ex}"
        WORKING_DIRECTORY "${WORKDIR}"
        RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err TIMEOUT 300)
    if(NOT rc EQUAL 0)
        string(REPLACE "\n" "\n    " indented "${err}")
        list(APPEND failed "${name}: exit ${rc}\n    ${indented}")
        continue()
    endif()

    # The example's own promise: the first line after `// Prints:` must be the first line it prints.
    file(READ "${ex}" source)
    if(source MATCHES "// Prints:[ \t]*\n//[ \t]+([^\n]+)\n")
        set(promised "${CMAKE_MATCH_1}")
        string(STRIP "${promised}" promised)
        string(REGEX REPLACE "\r" "" out "${out}")
        string(REGEX MATCH "^[^\n]*" firstLine "${out}")
        string(STRIP "${firstLine}" firstLine)
        if(NOT firstLine STREQUAL promised)
            list(APPEND failed
                 "${name}: says it prints\n      [${promised}]\n    and printed\n      [${firstLine}]")
        endif()
    endif()
endforeach()

list(LENGTH examples total)
if(failed)
    string(REPLACE ";" "\n  " report "${failed}")
    message(FATAL_ERROR "of ${total} examples, these did not hold up:\n  ${report}")
endif()
message(STATUS "OK: ${total} examples compiled, ran, and printed what they promise")
