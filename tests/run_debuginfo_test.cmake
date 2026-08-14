# Debug-info (`polc -g`) test driver, invoked via `cmake -P`.
#
# Compiles an .pol with -g, asserts the emitted .ll carries the DWARF metadata a native debugger needs
# (compile unit, per-function subprograms, per-statement line locations, and local/parameter variables),
# then links and runs it to confirm -g codegen stays correct. Line-level breakpoints + variable inspection
# are separately proven with lldb; this keeps the metadata a permanent, dependency-light regression check.
#
# Required -D args: POLC, CLANG, INPUT, EXPECTED, WORKDIR

string(MD5 _tag "${INPUT}|dbg")
set(ll "${WORKDIR}/dbg_${_tag}.ll")
set(exe "${WORKDIR}/dbg_${_tag}.exe")

execute_process(COMMAND "${POLC}" -g "${INPUT}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc -g failed (exit ${rc})")
endif()

file(READ "${ll}" _ir)
foreach(_needle "!DICompileUnit" "!DISubprogram" "!DILocation" "!DILocalVariable"
                "\"Debug Info Version\"" "\"Dwarf Version\"" "!llvm.dbg.cu")
    string(FIND "${_ir}" "${_needle}" _at)
    if(_at EQUAL -1)
        message(FATAL_ERROR "debug metadata missing from .ll: ${_needle}")
    endif()
endforeach()

# The emitted program must still be correct when built with debug info.
get_filename_component(_clangdir "${CLANG}" DIRECTORY)
get_filename_component(_llvmroot "${_clangdir}" DIRECTORY)
file(GLOB _builtins
    "${_llvmroot}/lib/clang/*/lib/windows/clang_rt.builtins-x86_64.lib"
    "$ENV{ProgramFiles}/LLVM/lib/clang/*/lib/windows/clang_rt.builtins-x86_64.lib")
set(_builtinslib "")
if(_builtins)
    list(GET _builtins 0 _builtinslib)
endif()
if(CMAKE_HOST_WIN32)
    set(_platlibs -llegacy_stdio_definitions ${_builtinslib})
else()
    set(_platlibs -lpthread -ldl -lm -lstdc++)
endif()
execute_process(COMMAND "${CLANG}" -g -Wno-override-module "${ll}"
    "${CMAKE_CURRENT_LIST_DIR}/../runtime/polaron_rt.cpp" -o "${exe}"
    ${_platlibs} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang -g link failed (exit ${rc})")
endif()

execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program (built with -g) exited with ${rc}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch under -g:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

message(STATUS "OK (debug info + correct under -g): ${out}")
