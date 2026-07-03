# `ldp3 doc` end-to-end, invoked via `cmake -P`.
#
# Builds a project whose entry has a public class documented with /// comments, runs `ldp3 doc`, and checks
# the generated HTML page exists and carries the doc text and the API signatures. No clang needed (docs are
# parse-only).
#
# Required -D args: LDP3, WORKDIR

set(app "${WORKDIR}/doc_app")
file(REMOVE_RECURSE "${app}")
file(MAKE_DIRECTORY "${app}/src")
file(WRITE "${app}/ldp3.toml"
"[ldp3_project]\n[program]\nname = \"widgets\"\nlanguage_version = \"1.0\"\nentry = \"src/main.ldp3\"\n")
file(WRITE "${app}/src/main.ldp3"
"program Widgets;\npublic bundle main {\n    public namespace ui {\n        /// A clickable widget.\n        public class Button {\n            /// The visible caption.\n            public String caption;\n            /// Renders the button and returns its width.\n            public method render(int scale) returns int { return scale; }\n        }\n    }\n}\n")

execute_process(COMMAND "${LDP3}" doc
    WORKING_DIRECTORY "${app}" RESULT_VARIABLE rc OUTPUT_VARIABLE out ERROR_VARIABLE err)
message(STATUS "doc: ${out}${err}")
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3 doc failed (exit ${rc}): ${err}")
endif()
if(NOT EXISTS "${app}/build-output/widgets-doc.html")
    message(FATAL_ERROR "ldp3 doc did not write the HTML page")
endif()

file(READ "${app}/build-output/widgets-doc.html" html)
foreach(needle "A clickable widget" "The visible caption" "Renders the button" "class Button" "method render" "returns int")
    if(NOT html MATCHES "${needle}")
        message(FATAL_ERROR "doc HTML is missing '${needle}'")
    endif()
endforeach()

message(STATUS "OK: ldp3 doc")
