# `ldp3 plug` (no args) + lockfile test, invoked via `cmake -P`.
#
# Simulates a freshly cloned project: the manifest already declares a dependency but packages/ is absent.
# `ldp3 plug` installs it and writes ldp3.lock; removing packages/ and running again reproduces the install
# from the lock. Hermetic; no network.
#
# Required -D args: LDP3, WORKDIR

set(fix "${WORKDIR}/plugall_fix/mathlib")
set(app "${WORKDIR}/plugall_app")
file(REMOVE_RECURSE "${WORKDIR}/plugall_fix" "${app}")
file(MAKE_DIRECTORY "${fix}/src")

file(WRITE "${fix}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"mathlib\"\nlanguage_version = \"1.0\"\nentry = \"src/lib.ldp3\"\n")
file(WRITE "${fix}/src/lib.ldp3"
"program MathLib;\npublic bundle mathlib {\n    public namespace math {\n        public class Calc {\n            public static method square(int x) returns int { return x * x; }\n        }\n    }\n}\n")
execute_process(COMMAND git init -q WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git init failed")
endif()
execute_process(COMMAND git -c user.name=ci -c user.email=ci@ldp3 add -A WORKING_DIRECTORY "${fix}")
execute_process(COMMAND git -c user.name=ci -c user.email=ci@ldp3 commit -q -m init WORKING_DIRECTORY "${fix}" RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "git commit failed")
endif()
execute_process(COMMAND git tag v1.0.0 WORKING_DIRECTORY "${fix}")

# Consumer whose manifest already declares the dependency (as if just cloned), with no packages/.
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"consumer\"\nlanguage_version = \"1.0\"\nentry = \"src/main.ldp3\"\n\n[dependencies]\nmathlib = \"${fix}@v1.0.0\"\n")
file(WRITE "${app}/src/main.ldp3"
"import System.IO.Console;\nprogram Consumer;\npublic bundle main { public namespace app { public class Main { public static method main(string[] args) returns void { System.IO.Console.println(\"ok\"); return; } } } }\n")

# `ldp3 plug` with no package installs everything declared and writes the lock.
execute_process(COMMAND "${LDP3}" plug
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "plug (all): ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "plug (all) failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${app}/packages/mathlib/mathlib.ldb")
    message(FATAL_ERROR "plug (all) did not install the dependency")
endif()
if(NOT EXISTS "${app}/ldp3.lock")
    message(FATAL_ERROR "plug (all) did not write ldp3.lock")
endif()
file(READ "${app}/ldp3.lock" lock)
if(NOT lock MATCHES "mathlib")
    message(FATAL_ERROR "lockfile did not record the dependency:\n${lock}")
endif()

# Remove packages/ and reproduce the install from the lock.
file(REMOVE_RECURSE "${app}/packages")
execute_process(COMMAND "${LDP3}" plug
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "reproducing from lock failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${app}/packages/mathlib/mathlib.ldb")
    message(FATAL_ERROR "reproducing from lock did not reinstall the dependency")
endif()

message(STATUS "OK: plug-all + lockfile")
