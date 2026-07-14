# Cross-program IPC end-to-end (spec 2.8), invoked via `cmake -P`.
#
# Two programs. The engine is compiled twice: as an executable (it serves) and as a bundle, whose .ldh
# is what the client type-checks against (--use-remote) -- the client never links a line of its code.
# The client is then run with the engine's path: it starts it, connects to it BY NAME over the named
# pipe / unix socket, creates an object in it, calls methods on it, and exercises the capability policy.
#
# Required -D args: LDP3C, CLANG, SERVER, CLIENT, EXPECTED, WORKDIR

set(rt "${CMAKE_CURRENT_LIST_DIR}/../runtime/ldp3_rt.cpp")
set(engine_ll "${WORKDIR}/ipc_engine.ll")
set(engine_exe "${WORKDIR}/ipc_engine.exe")
set(engine_ldb "${WORKDIR}/ipc_engine.ldb")
set(client_ll "${WORKDIR}/ipc_client.ll")
set(client_exe "${WORKDIR}/ipc_client.exe")

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

function(run_or_die)
    execute_process(COMMAND ${ARGV} RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "command failed (exit ${rc}):\n  ${ARGV}\n${out}${err}")
    endif()
endfunction()

# The engine: an executable that serves, and a bundle the client compiles against.
run_or_die("${LDP3C}" "${SERVER}" -o "${engine_ll}")
run_or_die("${CLANG}" -Wno-override-module "${engine_ll}" "${rt}" -o "${engine_exe}" ${_platlibs})
run_or_die("${LDP3C}" --lib "${SERVER}" -o "${engine_ldb}")

# The client: it knows the engine's types from that bundle's header, and nothing else about it.
run_or_die("${LDP3C}" "${CLIENT}" --use-remote "${engine_ldb}" -o "${client_ll}")
run_or_die("${CLANG}" -Wno-override-module "${client_ll}" "${rt}" -o "${client_exe}" ${_platlibs})

execute_process(COMMAND "${client_exe}" "${engine_exe}"
    TIMEOUT 60 OUTPUT_VARIABLE out ERROR_VARIABLE err RESULT_VARIABLE rc)
if(NOT err STREQUAL "")
    message(STATUS "stderr: ${err}")
endif()
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "the client exited with ${rc}:\n${out}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()
message(STATUS "OK: ${out}")
