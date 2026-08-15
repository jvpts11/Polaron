# End-to-end dynamic .polb loading test driver, invoked via `cmake -P`.
#
# Compiles a library to a .polb, compiles a consumer that loads it at runtime (`--use-dynamic`), links
# the consumer with the C++ runtime loader and the .polb container, then runs it. On first run the
# loader AOT-compiles the bundle's bitcode to a DLL with clang and resolves the call; the output must
# match EXPECTED.
#
# Required -D args: POLC, CLANG, LIB, APP, EXPECTED, WORKDIR

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
# EVERY OUTPUT BELOW IS NAMED AFTER THE TEST'S OWN LIBRARY, and that is not tidiness.
#
# These paths used to be fixed (`e2e_link.polb`, `e2e_link_app.exe`) in one shared WORKDIR, while SIX
# tests share this harness. Under `ctest -j 12` they overwrite each other's bundles and executables,
# and the result is a test that fails once in a while for no reason anybody can reproduce -- measured
# twice in one evening, each time costing an investigation that ended in "passes in isolation".
# A false failure is not free: it trains you to re-run instead of to look, which is exactly how a real
# one gets waved through.
get_filename_component(TESTTAG "${LIB}" NAME_WE)
get_filename_component(_apptag "${APP}" NAME_WE)   # two tests may share a library, see the link harness
set(TESTTAG "${TESTTAG}_${_apptag}")
set(polb "${WORKDIR}/${TESTTAG}_dyn.polb")
set(ll "${WORKDIR}/${TESTTAG}_dyn_app.ll")
set(exe "${WORKDIR}/${TESTTAG}_dyn_app.exe")

execute_process(COMMAND "${POLC}" --lib "${LIB}" -o "${polb}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc --lib failed (exit ${rc})")
endif()

execute_process(COMMAND "${POLC}" "${APP}" --use-dynamic "${polb}" -o "${ll}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polc (consumer) failed (exit ${rc})")
endif()

# Link the consumer with the C++ runtime loader and the .polb container library. On POSIX the app must be
# linked -rdynamic so the bundle .so, loaded with dlopen, resolves the runtime's __polaron_* symbols back
# against the host program.
if(CMAKE_HOST_WIN32)
    set(_platlink -llegacy_stdio_definitions)
else()
    set(_platlink -rdynamic -lpthread -ldl -lm)
endif()
execute_process(COMMAND "${CLANGPP}" -std=c++20 -Wno-override-module -Wno-deprecated "${ll}"
    "${ROOT}/runtime/polaron_rt.cpp" "${ROOT}/runtime/polaron_bundle.cpp" "${ROOT}/src/bundle/polb.cpp"
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
