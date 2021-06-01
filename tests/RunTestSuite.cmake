if(NOT TEST_SUITE)
    message(FATAL_ERROR "run_test: missing TEST_SUITE parameter")
endif()
if(NOT BUILD_DIRECTORY)
    message(FATAL_ERROR "run_test: missing BUILD_DIRECTORY parameter")
endif()

execute_process(COMMAND ${CMAKE_COMMAND} -S ${TEST_SUITE} -B ${BUILD_DIRECTORY}/${TEST_SUITE}
    RESULT_VARIABLE setup_test_suite)
if(setup_test_suite)
    message(FATAL_ERROR "run_test: setting up test suite failed")
endif()
