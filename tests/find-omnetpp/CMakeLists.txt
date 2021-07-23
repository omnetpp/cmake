project(FindOmnetppTest)
cmake_minimum_required(VERSION 3.13)
include(${PROJECT_SOURCE_DIR}/../TestSuiteHelpers.cmake)
set(CMAKE_MODULE_PATH ${OMNETPP_CMAKE_ROOT})

find_package(OmnetPP REQUIRED)

require_envvar(EXPECTED_OMNETPP_ROOT EXPECTED_OMNETPP_VERSION)
expect_strequal($ENV{EXPECTED_OMNETPP_ROOT} OMNETPP_ROOT)
expect_strequal($ENV{EXPECTED_OMNETPP_VERSION} OMNETPP_VERSION)

expect_target(OmnetPP::cmdenv)
expect_target(OmnetPP::common)
expect_target(OmnetPP::envir)
expect_target(OmnetPP::eventlog)
expect_target(OmnetPP::header)
expect_target(OmnetPP::layout)
expect_target(OmnetPP::main)
expect_target(OmnetPP::nedxml)
expect_target(OmnetPP::scave)
expect_target(OmnetPP::sim)
expect_target(OmnetPP::tkenv)

get_property(opp_include_dirs TARGET OmnetPP::header PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
set(opp_include_dirs_expected $ENV{EXPECTED_OMNETPP_ROOT}/include)
if(NOT opp_include_dirs STREQUAL opp_include_dirs_expected)
    message(FATAL_ERROR "OMNeT++ include directory is incorrect:
        expected: ${opp_include_dirs_expected}
        actual: ${opp_include_dirs}")
endif()
