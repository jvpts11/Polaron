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

# The Environments screen: the environment list, the selected environment's libraries and its projects.
execute_process(COMMAND "${STUDIO}" --selftest-env OUTPUT_VARIABLE env RESULT_VARIABLE erc)
if(NOT erc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-env exited ${erc}")
endif()
foreach(needle "ENVIRONMENTS" "gamedev" "LIBRARIES" "vec_simd" "USED BY" "new env")
    if(NOT env MATCHES "${needle}")
        message(FATAL_ERROR "environments frame is missing '${needle}'")
    endif()
endforeach()

# The new-project modal: name and environment fields.
execute_process(COMMAND "${STUDIO}" --selftest-new OUTPUT_VARIABLE modal RESULT_VARIABLE mrc)
if(NOT mrc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-new exited ${mrc}")
endif()
foreach(needle "New LDP3 project" "NAME" "pool_balls_3d" "ENVIRONMENT" "gamedev" "create")
    if(NOT modal MATCHES "${needle}")
        message(FATAL_ERROR "new-project modal is missing '${needle}'")
    endif()
endforeach()

# The background scan indicator.
execute_process(COMMAND "${STUDIO}" --selftest-scan OUTPUT_VARIABLE scan RESULT_VARIABLE src)
if(NOT src EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-scan exited ${src}")
endif()
if(NOT scan MATCHES "scanning")
    message(FATAL_ERROR "scan frame is missing the scanning indicator")
endif()

# The new-environment modal.
execute_process(COMMAND "${STUDIO}" --selftest-newenv OUTPUT_VARIABLE newenv RESULT_VARIABLE nerc)
if(NOT nerc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-newenv exited ${nerc}")
endif()
foreach(needle "New environment" "NAME" "create")
    if(NOT newenv MATCHES "${needle}")
        message(FATAL_ERROR "new-environment modal is missing '${needle}'")
    endif()
endforeach()

# The Libraries inventory: libraries, versions and where each is used.
execute_process(COMMAND "${STUDIO}" --selftest-lib OUTPUT_VARIABLE lib RESULT_VARIABLE lrc)
if(NOT lrc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-lib exited ${lrc}")
endif()
foreach(needle "LIBRARIES" "vec_simd" "USED BY PROJECTS" "gamedev")
    if(NOT lib MATCHES "${needle}")
        message(FATAL_ERROR "libraries frame is missing '${needle}'")
    endif()
endforeach()

# The Toolchain screen: tool paths and the default target.
execute_process(COMMAND "${STUDIO}" --selftest-tool OUTPUT_VARIABLE tool RESULT_VARIABLE trc)
if(NOT trc EQUAL 0)
    message(FATAL_ERROR "ldp3-studio --selftest-tool exited ${trc}")
endif()
foreach(needle "TOOLCHAIN" "COMPILER" "ldp3c" "clang" "x86_64-windows")
    if(NOT tool MATCHES "${needle}")
        message(FATAL_ERROR "toolchain frame is missing '${needle}'")
    endif()
endforeach()

message(STATUS "OK: ldp3-studio all screens")
