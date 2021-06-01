project(OmnetppCmakeTests)
cmake_minimum_required(VERSION 3.13)
enable_testing()

add_test(NAME FindOMNeT++
    COMMAND ${CMAKE_COMMAND}
    -DBUILD_DIRECTORY=${PROJECT_BINARY_DIR}
    -DTEST_SUITE=find-omnetpp
    -P RunTestSuite.cmake
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
