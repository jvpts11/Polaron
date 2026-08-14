# The OPEN world, end to end: Polaron exports, C++ calls in. Invoked via `cmake -P`.
#
# Every other end-to-end test in this suite runs Polaron calling Polaron. This one compiles a Polaron
# program that exports `unknown <world>` methods, generates the C header for them with
# `polc --emit-c-header`, compiles a C++ caller against that header, links the two, and checks the
# answers. If the type mapping in the header ever disagrees with what codegen emits, the failure is a
# WRONG NUMBER here rather than a silent corruption in somebody's program.
#
# Required -D args: POLC, CLANG, POL, CALLER, EXPECTED, WORKDIR.
string(MD5 _tag "${POL}|${CALLER}")
set(polb "${WORKDIR}/cexp_${_tag}.polb")
set(bc "${WORKDIR}/cexp_${_tag}.bc")
set(hdrdir "${WORKDIR}/cexp_${_tag}_inc")
set(exe "${WORKDIR}/cexp_${_tag}.exe")
file(MAKE_DIRECTORY "${hdrdir}")

get_filename_component(_polstem "${POL}" NAME_WE)
set(hdr "${hdrdir}/${_polstem}.h")

# BUILT AS A LIBRARY, which is the shape the open world actually takes: someone else's program owns
# `main` and links our code in. Building it as a program instead gives two `main`s and a link error --
# which is the first thing that went wrong here, and is a fair summary of the difference between the
# two worlds.
execute_process(COMMAND "${POLC}" --lib "${POL}" "--emit-c-header=${hdr}" -o "${polb}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib failed (exit ${rc}) on ${POL}")
endif()
if(NOT EXISTS "${hdr}")
    message(FATAL_ERROR "polc wrote no C header to ${hdr}")
endif()

execute_process(COMMAND "${POLC}" --extract-code "${polb}" -o "${bc}"
                RESULT_VARIABLE rc OUTPUT_QUIET ERROR_QUIET)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --extract-code failed (exit ${rc})")
endif()

# The runtime comes along because a Polaron program's guards and String machinery live there, even
# when the exported methods themselves are pure arithmetic.
set(_rt "${CMAKE_CURRENT_LIST_DIR}/../runtime/polaron_rt.cpp")
foreach(_ext ".obj" ".o")
    if(EXISTS "${WORKDIR}/polaron_rt_clang${_ext}")
        set(_rt "${WORKDIR}/polaron_rt_clang${_ext}")
        break()
    endif()
endforeach()
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions)
else()
    set(_platlibs -lpthread -ldl -lm -lstdc++)
endif()

execute_process(COMMAND "${CLANG}" -Wno-override-module -I "${hdrdir}"
                        "${CALLER}" "${bc}" "${_rt}" -o "${exe}" ${_platlibs}
                RESULT_VARIABLE rc OUTPUT_VARIABLE cout ERROR_VARIABLE cerr)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "linking the C++ caller against Polaron failed (exit ${rc})\n${cout}\n${cerr}")
endif()

execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "the C++ caller got wrong answers (exit ${rc})\n  stdout: [${out}]\n  stderr: [${err}]")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()
message(STATUS "OK: C++ called into Polaron -- ${out}")
