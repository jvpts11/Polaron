# Hermetic plug/unplug test, invoked via `cmake -P`.
#
# Builds a LOCAL git repo holding a minimal Polaron library (tagged v1.0.0), then, from a consumer project,
# runs `polaron plug <local-repo>@v1.0.0` and checks the dependency was cloned, compiled to a .polb, and
# recorded in the manifest -- then `polaron unplug` removes it. No network involved.
#
# Required -D args: POLARON, WORKDIR

set(fix "${WORKDIR}/plug_fixtures/mathlib")
set(app "${WORKDIR}/plug_app")
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
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron add -A WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
execute_process(COMMAND git -c user.name=ci -c user.email=ci@polaron commit -q -m init WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git commit failed (exit ${rc})")
endif()
execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git tag failed (exit ${rc})")
endif()

file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/polaron.toml"
"[polaron_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/main.pol\"\n\n[dependencies]\n")
file(WRITE "${app}/src/main.pol"
"import System.IO.Console;\nprogram Consumer;\npublic bundle main { public namespace app { public class Main { public static method main(string[] args) returns void { System.IO.Console.println(\"ok\"); return; } } } }\n")

execute_process(COMMAND "${POLARON}" plug "${fix}@v1.0.0"
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "polaron plug failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${app}/packages/mathlib/mathlib.polb")
    message(FATAL_ERROR "expected packages/mathlib/mathlib.polb was not created")
endif()
file(READ "${app}/polaron.toml" mf)
if(NOT mf MATCHES "mathlib")
    message(FATAL_ERROR "manifest did not record the dependency:\n${mf}")
endif()

execute_process(COMMAND "${POLARON}" unplug mathlib WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc)
if(EXISTS "${app}/packages/mathlib")
    message(FATAL_ERROR "unplug did not remove the package directory")
endif()

message(STATUS "OK: plug/unplug")
