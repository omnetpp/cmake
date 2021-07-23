cmake_minimum_required(VERSION 3.13)

if(NOT TEST_SUITE)
    message(FATAL_ERROR "run_test: missing TEST_SUITE parameter")
endif()
if(NOT BUILD_DIRECTORY)
    message(FATAL_ERROR "run_test: missing BUILD_DIRECTORY parameter")
endif()

set(TEST_SUITE_BINARY_DIR ${BUILD_DIRECTORY}/${TEST_SUITE})
execute_process(COMMAND ${CMAKE_COMMAND} -S ${TEST_SUITE} -B ${TEST_SUITE_BINARY_DIR}
    RESULT_VARIABLE setup_test_suite)
if(setup_test_suite)
    message(FATAL_ERROR "run_test: setting up test suite failed")
elseif(EXISTS "${TEST_SUITE}/post-tests.cmake")
    include(TestSuiteHelpers.cmake)
    include(${TEST_SUITE}/post-tests.cmake)
endif()
