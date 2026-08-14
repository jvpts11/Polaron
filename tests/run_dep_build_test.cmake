# End-to-end dependency build test, invoked via `cmake -P`.
#
# Builds a local git repo holding a minimal Polaron library (Calc.square), plugs it into a consumer whose code
# imports and calls it, then `polaron run` builds (compiling with --use, linking the extracted bitcode) and
# executes -- expecting "square = 49". Hermetic; no network.
#
# Required -D args: POLARON, WORKDIR

set(fix "${WORKDIR}/depbuild_fixtures/mathlib")
set(app "${WORKDIR}/depbuild_app")
file(REMOVE_RECURSE "${fix}" "${app}")
file(MAKE_DIRECTORY "${fix}/src")

file(WRITE "${fix}/polaron.toml"
"[polaron_project]\n[program]\nname = \"mathlib\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.pol\"\n")
file(WRITE "${fix}/src/lib.pol"
"program MathLib;\npublic bundle mathlib {\n    public namespace math {\n        public class Calc {\n            public static method square(int x) returns int {\n                return x * x;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND git init -q WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git init failed (exit ${rc})")
endif()
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron add -A WORKING_DIRECTORY "${fix}")
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -m init WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git commit failed (exit ${rc})")
endif()
execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${fix}")

file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/main.pol\"\n\n[dependencies]\n")
file(WRITE "${app}/src/main.pol"
"import System.IO.Console;\nimport mathlib.math.Calc;\nprogram Consumer;\npublic bundle main {\n    public namespace app {\n        public class Main {\n            public static method main(string[] args) returns void {\n                int r = Calc.square(7);\n                System.IO.Console.printf(\"square = %d\\n\", r);\n                return;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND "${POLARON}" plug "${fix}@v1.0.0"
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron plug failed (exit ${rc}): ${err}")
endif()

execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "run: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron run failed (exit ${rc}): ${err}")
endif()
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "square = 49")
    message(FATAL_ERROR "expected 'square = 49' in output, got: [${out}]")
endif()

message(STATUS "OK: dependency build")
