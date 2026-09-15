execute_process(COMMAND "${POLC}" --check "${SAMPLES}/borrow_call_argument_ok.pol" --noVerbose
    RESULT_VARIABLE valid_result OUTPUT_VARIABLE valid_out ERROR_VARIABLE valid_err)
if(NOT valid_result EQUAL 0)
    message(FATAL_ERROR "Valid consuming call rejected: ${valid_out}${valid_err}")
endif()
execute_process(COMMAND "${POLC}" --check "${SAMPLES}/borrow_call_argument_bad.pol" --noVerbose
    RESULT_VARIABLE invalid_result OUTPUT_VARIABLE invalid_out ERROR_VARIABLE invalid_err)
if(invalid_result EQUAL 0 OR NOT "${invalid_out}${invalid_err}" MATCHES "Polaron-1724")
    message(FATAL_ERROR "Use after consuming call was not diagnosed: ${invalid_out}${invalid_err}")
endif()
