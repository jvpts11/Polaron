# `ldp3 fmt` end-to-end, invoked via `cmake -P`.
#
# Formats a deliberately messy project, checks the whitespace was normalized, that a second run is a no-op
# (idempotent), and that the reformatted program still builds and runs with the same output (fmt never
# changes meaning).
#
# Required -D args: LDP3, WORKDIR

set(app "${WORKDIR}/fmt_app")
file(REMOVE_RECURSE "${app}")
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"app\"\nlanguage_version = \"1.0\"\nentry = \"src/main.ldp3\"\n")
# Bad indentation and cramped spacing on purpose.
file(WRITE "${app}/src/main.ldp3"
"import System.IO.Console;\nprogram App;\npublic bundle main{\npublic namespace app{\npublic class Main{\npublic static method main(string[] args)returns void{\nint x=6*7;\nSystem.IO.Console.printf(\"Resultado: %d\\n\",x);\nreturn;\n}\n}\n}\n}\n")

execute_process(COMMAND "${LDP3}" fmt WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out)
message(STATUS "fmt: ${out}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3 fmt failed (exit ${rc})")
endif()

file(READ "${app}/src/main.ldp3" f1)
if(NOT f1 MATCHES "int x = 6")
    message(FATAL_ERROR "fmt did not space around '=':\n${f1}")
endif()
if(NOT f1 MATCHES "args\\) returns void")
    message(FATAL_ERROR "fmt did not space a keyword after ')':\n${f1}")
endif()
if(NOT f1 MATCHES "\n        public class Main")
    message(FATAL_ERROR "fmt did not indent nested declarations:\n${f1}")
endif()

# Idempotent: a second format leaves the file identical.
execute_process(COMMAND "${LDP3}" fmt WORKING_DIRECTORY "${app}")
file(READ "${app}/src/main.ldp3" f2)
if(NOT f1 STREQUAL f2)
    message(FATAL_ERROR "fmt is not idempotent")
endif()

# The reformatted program still compiles and runs with the same output.
execute_process(COMMAND "${LDP3}" run WORKING_DIRECTORY "${app}" OUTPUT_VARIABLE runout RESULT_VARIABLE rrc)
string(REGEX REPLACE "[ \t\r\n]+" " " runout "${runout}")
if(NOT runout MATCHES "Resultado: 42")
    message(FATAL_ERROR "reformatted program did not run correctly: [${runout}]")
endif()

message(STATUS "OK: ldp3 fmt")
