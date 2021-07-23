project(OmnetppCmakeTests)
cmake_minimum_required(VERSION 3.13)
enable_testing()

macro(add_opp_test_suite test_suite name)
    add_test(NAME ${name}
        COMMAND ${CMAKE_COMMAND}
        -DBUILD_DIRECTORY=${PROJECT_BINARY_DIR}
        -DTEST_SUITE=${test_suite}
        -P RunTestSuite.cmake
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
endmacro()

add_opp_test_suite(find-omnetpp FindOMNeT++)
add_opp_test_suite(omnetpp-helpers CheckHelpers)

