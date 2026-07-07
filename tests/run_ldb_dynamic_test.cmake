# End-to-end dynamic .ldb loading test driver, invoked via `cmake -P`.
#
# Compiles a library to a .ldb, compiles a consumer that loads it at runtime (`--use-dynamic`), links
# the consumer with the C++ runtime loader and the .ldb container, then runs it. On first run the
# loader AOT-compiles the bundle's bitcode to a DLL with clang and resolves the call; the output must
# match EXPECTED.
#
# Required -D args: LDP3C, CLANG, LIB, APP, EXPECTED, WORKDIR

get_filename_component(CLANG_DIR "${CLANG}" DIRECTORY)
if(CMAKE_HOST_WIN32)
    set(CLANGPP "${CLANG_DIR}/clang++.exe")
    # Compiling the C++ runtime against the MSVC STL needs a recent clang; the official LLVM install is
    # usually newer than a bundled one. Prefer it for both the link and the loader's runtime clang.
    if(EXISTS "C:/Program Files/LLVM/bin/clang++.exe")
        set(CLANGPP "C:/Program Files/LLVM/bin/clang++.exe")
        set(CLANG_DIR "C:/Program Files/LLVM/bin")
    endif()
else()
    set(CLANGPP "${CLANG_DIR}/clang++")
endif()
set(ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
set(ldb "${WORKDIR}/e2e_dyn.ldb")
set(ll "${WORKDIR}/e2e_dyn_app.ll")
set(exe "${WORKDIR}/e2e_dyn_app.exe")

execute_process(COMMAND "${LDP3C}" --lib "${LIB}" -o "${ldb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c --lib failed (exit ${rc})")
endif()

execute_process(COMMAND "${LDP3C}" "${APP}" --use-dynamic "${ldb}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3c (consumer) failed (exit ${rc})")
endif()

# Link the consumer with the C++ runtime loader and the .ldb container library. On POSIX the app must be
# linked -rdynamic so the bundle .so, loaded with dlopen, resolves the runtime's __ldp3_* symbols back
# against the host program.
if(CMAKE_HOST_WIN32)
    set(_platlink -llegacy_stdio_definitions)
else()
    set(_platlink -rdynamic -lpthread -ldl -lm)
endif()
execute_process(COMMAND "${CLANGPP}" -std=c++20 -Wno-override-module -Wno-deprecated "${ll}"
    "${ROOT}/runtime/ldp3_rt.cpp" "${ROOT}/runtime/ldp3_bundle.cpp" "${ROOT}/src/bundle/ldb.cpp"
    -I "${ROOT}/src" -o "${exe}" ${_platlink} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "clang++ link failed (exit ${rc})")
endif()

# The loader shells out to clang to build the bundle image on first run, so clang must be on PATH.
if(CMAKE_HOST_WIN32)
    set(ENV{PATH} "${CLANG_DIR};$ENV{PATH}")
else()
    set(ENV{PATH} "${CLANG_DIR}:$ENV{PATH}")
endif()
execute_process(COMMAND "${exe}" OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "program exited with ${rc}\n  output: [${out}]")
endif()

string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
string(STRIP "${out}" out)
if(NOT out STREQUAL EXPECTED)
    message(FATAL_ERROR "output mismatch:\n  got:      [${out}]\n  expected: [${EXPECTED}]")
endif()

message(STATUS "OK: ${out}")
