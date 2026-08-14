# Transitive dependency test, invoked via `cmake -P`.
#
# ylib is a leaf library; xlib depends on ylib and calls it; a consumer depends on xlib. Plugging xlib must
# transitively clone+compile ylib, and building the consumer must link the whole closure. Expects
# "result = 42" (XCalc.combine(6) = 6*6 + 6). Hermetic; no network.
#
# Required -D args: POLARON, WORKDIR

set(yrepo "${WORKDIR}/trans_fix/ylib")
set(xrepo "${WORKDIR}/trans_fix/xlib")
set(app "${WORKDIR}/trans_app")
file(REMOVE_RECURSE "${WORKDIR}/trans_fix" "${app}")

function(git_repo dir)
    execute_process(COMMAND git init -q WORKING_DIRECTORY "${dir}" RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "git init failed in ${dir}")
    endif()
    execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron add -A WORKING_DIRECTORY "${dir}")
    execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -m init WORKING_DIRECTORY "${dir}" RESULT_VARIABLE rc)
    if(NOT rc EQUAL 0)
        message(FATAL_ERROR "git commit failed in ${dir}")
    endif()
    execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${dir}")
endfunction()

# --- ylib (leaf) ---
file(MAKE_DIRECTORY "${yrepo}/src")
file(WRITE "${yrepo}/polaron.toml"
"[polaron_project]\n[program]\nname = \"ylib\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.pol\"\n")
file(WRITE "${yrepo}/src/lib.pol"
"program YLib;\npublic bundle ylib {\n    public namespace y {\n        public class YCalc {\n            public static method square(int x) returns int { return x * x; }\n        }\n    }\n}\n")
git_repo("${yrepo}")

# --- xlib (depends on ylib) ---
file(MAKE_DIRECTORY "${xrepo}/src")
file(WRITE "${xrepo}/polaron.toml"
"[polaron_project]\n[program]\nname = \"xlib\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.pol\"\n\n[dependencies]\nylib = \"${yrepo}@v1.0.0\"\n")
file(WRITE "${xrepo}/src/lib.pol"
"import ylib.y.YCalc;\nprogram XLib;\npublic bundle xlib {\n    public namespace x {\n        public class XCalc {\n            public static method combine(int n) returns int { return YCalc.square(n) + n; }\n        }\n    }\n}\n")
git_repo("${xrepo}")

# --- consumer (depends on xlib) ---
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nlanguage_version = \"1.0\"\nentry = \"src/main.pol\"\n\n[dependencies]\n")
file(WRITE "${app}/src/main.pol"
"import System.IO.Console;\nimport xlib.x.XCalc;\nprogram Consumer;\npublic bundle main {\n    public namespace app {\n        public class Main {\n            public static method main(string[] args) returns void {\n                int r = XCalc.combine(6);\n                System.IO.Console.printf(\"result = %d\\n\", r);\n                return;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND "${POLARON}" plug "${xrepo}@v1.0.0"
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug xlib: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "plug failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${app}/packages/xlib/xlib.polb")
    message(FATAL_ERROR "xlib was not installed")
endif()
if(NOT EXISTS "${app}/packages/ylib/ylib.polb")
    message(FATAL_ERROR "transitive dependency ylib was not installed")
endif()

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "run: ${out}${err}")
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "result = 42")
    message(FATAL_ERROR "expected 'result = 42', got: [${out}] err: [${err}]")
endif()

message(STATUS "OK: transitive dependencies")
