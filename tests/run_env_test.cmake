# Environments end-to-end test, invoked via `cmake -P`.
#
# Redirects ~/.pol to a throwaway POLARON_HOME so nothing touches the real home. Creates a named environment,
# plugs a local library into it (plug -e), builds+runs a consumer that declares the environment and calls
# the library (square = 49), then lists and removes the environment. Hermetic; no network.
#
# Required -D args: POLARON, WORKDIR

set(home "${WORKDIR}/env_home")
set(fix "${WORKDIR}/env_fixtures/mathlib")
set(app "${WORKDIR}/env_app")
set(ENV{POLARON_HOME} "${home}")
file(REMOVE_RECURSE "${home}" "${fix}" "${app}")

# --- env new ---
execute_process(COMMAND "${POLARON}" env new gamedev RESULT_VARIABLE rc OUTPUT_VARIABLE out)
message(STATUS "env new: ${out}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "env new failed (exit ${rc})")
endif()
if(NOT EXISTS "${home}/environments/gamedev/packages")
    message(FATAL_ERROR "env new did not create the environment directory")
endif()

# --- fixture library repo ---
file(MAKE_DIRECTORY "${fix}/src")
file(WRITE "${fix}/polaron.toml"
"[polaron_project]\n[program]\nname = \"mathlib\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.pol\"\n")
file(WRITE "${fix}/src/lib.pol"
"program MathLib;\npublic bundle mathlib {\n    public namespace math {\n        public class Calc {\n            public static method square(int x) returns int {\n                return x * x;\n            }\n        }\n    }\n}\n")
execute_process(COMMAND git init -q WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git init failed")
endif()
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron add -A WORKING_DIRECTORY "${fix}")
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -m init WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git commit failed")
endif()
execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${fix}")

# --- consumer project that declares the environment ---
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/main.pol\"\n\n[dependencies]\n\n[build]\nenvironment = \"gamedev\"\n")
file(WRITE "${app}/src/main.pol"
"import System.IO.Console;\nimport mathlib.math.Calc;\nprogram Consumer;\npublic bundle main {\n    public namespace app {\n        public class Main {\n            public static method main(string[] args) returns void {\n                int r = Calc.square(7);\n                System.IO.Console.printf(\"square = %d\\n\", r);\n                return;\n            }\n        }\n    }\n}\n")

# --- plug the library into the environment ---
execute_process(COMMAND "${POLARON}" plug "${fix}@v1.0.0" -e
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug -e: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "plug -e failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${home}/environments/gamedev/packages/mathlib/mathlib.polb")
    message(FATAL_ERROR "plug -e did not install into the environment")
endif()

# --- build+run the consumer against the environment dependency ---
execute_process(COMMAND "${POLARON}" run
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "run: ${out}${err}")
string(REGEX REPLACE "[ \t\r\n]+" " " out "${out}")
if(NOT out MATCHES "square = 49")
    message(FATAL_ERROR "expected 'square = 49', got: [${out}] err: [${err}]")
endif()

# --- env list / env remove ---
execute_process(COMMAND "${POLARON}" env list OUTPUT_VARIABLE out)
if(NOT out MATCHES "gamedev")
    message(FATAL_ERROR "env list did not show gamedev: [${out}]")
endif()
execute_process(COMMAND "${POLARON}" env remove gamedev)
if(EXISTS "${home}/environments/gamedev")
    message(FATAL_ERROR "env remove did not delete the environment")
endif()

message(STATUS "OK: environments")
