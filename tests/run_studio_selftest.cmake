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
foreach(needle "ldp3 studio" "Projetos" "GERENCIAR" "SISTEMA" "navegar" "Bem-vindo")
    if(NOT out MATCHES "${needle}")
        message(FATAL_ERROR "shell frame is missing '${needle}'")
    endif()
endforeach()
message(STATUS "OK: ldp3-studio shell")
