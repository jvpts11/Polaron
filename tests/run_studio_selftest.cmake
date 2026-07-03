# ldp3-studio shell smoke test, invoked via `cmake -P`.
#
# Renders one frame of the app shell (`--selftest`, non-interactive) and checks it contains the brand, the
# navigation rail sections and the keybar -- i.e. the TUI builds, FTXUI renders, and the shell is laid out.
#
# Required -D args: STUDIO

execute_process(COMMAND "${STUDIO}" --selftest OUTPUT_VARIABLE out RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest exited ${rc}")
endif()
foreach(needle "ldp3 studio" "Projects" "MANAGE" "SYSTEM" "navigate" "ALL PROJECTS" "tic_tac_toe")
    if(NOT out MATCHES "${needle}")
        message(FATAL_ERROR "shell frame is missing '${needle}'")
    endif()
endforeach()

# The project-detail screen: actions, dependencies and the console with the last action's output.
execute_process(COMMAND "${STUDIO}" --selftest-detail OUTPUT_VARIABLE detail RESULT_VARIABLE drc)
if(NOT drc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-detail exited ${drc}")
endif()
foreach(needle "ACTIONS" "CONSOLE" "ldp3 test" "PASS" "tests: 7 passed" "run action")
    if(NOT detail MATCHES "${needle}")
        message(FATAL_ERROR "detail frame is missing '${needle}'")
    endif()
endforeach()

message(STATUS "OK: ldp3-studio shell + detail")
