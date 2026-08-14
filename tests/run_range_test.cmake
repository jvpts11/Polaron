# Version-range resolution test, invoked via `cmake -P`.
#
# Builds a local git repo with several semver tags, then `polaron plug <repo>@^1.0.0` and checks the highest
# 1.x tag (v1.3.5, not v2.0.0) was the one cloned. Hermetic; no network.
#
# Required -D args: POLARON, WORKDIR

set(fix "${WORKDIR}/range_fix/mathlib")
set(app "${WORKDIR}/range_app")
file(REMOVE_RECURSE "${fix}" "${app}")
file(MAKE_DIRECTORY "${fix}/src")

file(WRITE "${fix}/polaron.toml"
"[polaron_project]\n[program]\nname = \"mathlib\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.pol\"\n")
set(libbody
"program MathLib;\npublic bundle mathlib {\n    public namespace math {\n        public class Calc {\n            public static method square(int x) returns int { return x * x; }\n        }\n    }\n}\n")
file(WRITE "${fix}/src/lib.pol" "${libbody}")

execute_process(COMMAND git init -q WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git init failed")
endif()

# A commit + tag for each version. Each tag sits on its own commit.
foreach(ver 1.0.0 1.2.0 1.3.5 2.0.0)
    file(APPEND "${fix}/src/lib.pol" "// version ${ver}\n")
    execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -a -m "v${ver}"
        WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        # the first commit needs `add` since the file is untracked
        execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron add -A WORKING_DIRECTORY "${fix}")
        execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -m "v${ver}"
            WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
        if(NOT rc EQUAL 0)
            message(FATAL_ERROR "git commit for v${ver} failed")
        endif()
    endif()
    execute_process(COMMAND git tag "v${ver}" WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "git tag v${ver} failed")
    endif()
endforeach()

file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nlanguage_version = \"1.0\"\nentry = \"src/main.pol\"\n\n[dependencies]\n")
file(WRITE "${app}/src/main.pol"
"import System.IO.Console;\nprogram Consumer;\npublic bundle main { public namespace app { public class Main { public static method main(string[] args) returns void { System.IO.Console.println(\"ok\"); return; } } } }\n")

execute_process(COMMAND "${POLARON}" plug "${fix}@^1.0.0"
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug ^1.0.0: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "plug failed (exit ${rc}): ${err}")
endif()

execute_process(COMMAND git -C "${app}/packages/mathlib" describe --tags --exact-match HEAD
    OUTPUT_VARIABLE tag RESULT_VARIABLE rc OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "resolved tag: ${tag}")
if(NOT tag STREQUAL "v1.3.5")
    message(FATAL_ERROR "expected ^1.0.0 to resolve to v1.3.5, got '${tag}'")
endif()

message(STATUS "OK: version range")
