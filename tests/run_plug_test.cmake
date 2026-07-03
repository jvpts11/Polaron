# Hermetic plug/unplug test, invoked via `cmake -P`.
#
# Builds a LOCAL git repo holding a minimal LDP3 library (tagged v1.0.0), then, from a consumer project,
# runs `ldp3 plug <local-repo>@v1.0.0` and checks the dependency was cloned, compiled to a .ldb, and
# recorded in the manifest -- then `ldp3 unplug` removes it. No network involved.
#
# Required -D args: LDP3, WORKDIR

set(fix "${WORKDIR}/plug_fixtures/mathlib")
set(app "${WORKDIR}/plug_app")
file(REMOVE_RECURSE "${fix}" "${app}")
file(MAKE_DIRECTORY "${fix}/src")

file(WRITE "${fix}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"mathlib\"\nversion = \"1.0.0\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.ldp3\"\n")
file(WRITE "${fix}/src/lib.ldp3"
"program MathLib;\npublic bundle mathlib {\n    public namespace math {\n        public class Calc {\n            public static method square(int x) returns int {\n                return x * x;\n            }\n        }\n    }\n}\n")

execute_process(COMMAND git init -q WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git init failed (exit ${rc})")
endif()
execute_process(COMMAND git -c user.name=ci -c user.email=ci@ldp3 add -A WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
execute_process(COMMAND git -c user.name=ci -c user.email=ci@ldp3 commit -q -m init WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git commit failed (exit ${rc})")
endif()
execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git tag failed (exit ${rc})")
endif()

file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"consumer\"\nversion = \"0.1.0\"\nlanguage_version = \"1.0\"\nentry = \"src/main.ldp3\"\n\n[dependencies]\n")
file(WRITE "${app}/src/main.ldp3"
"import System.IO.Console;\nprogram Consumer;\npublic bundle main { public namespace app { public class Main { public static method main(string[] args) returns void { System.IO.Console.println(\"ok\"); return; } } } }\n")

execute_process(COMMAND "${LDP3}" plug "${fix}@v1.0.0"
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3 plug failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${app}/packages/mathlib/mathlib.ldb")
    message(FATAL_ERROR "expected packages/mathlib/mathlib.ldb was not created")
endif()
file(READ "${app}/ldp3.toml" mf)
if(NOT mf MATCHES "mathlib")
    message(FATAL_ERROR "manifest did not record the dependency:\n${mf}")
endif()

execute_process(COMMAND "${LDP3}" unplug mathlib WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc)
if(EXISTS "${app}/packages/mathlib")
    message(FATAL_ERROR "unplug did not remove the package directory")
endif()

message(STATUS "OK: plug/unplug")
