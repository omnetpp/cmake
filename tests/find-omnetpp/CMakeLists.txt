project(FindOmnetppTest)
cmake_minimum_required(VERSION 3.13)
include(${PROJECT_SOURCE_DIR}/../TestSuiteHelpers.cmake)
set(CMAKE_MODULE_PATH ${OMNETPP_CMAKE_ROOT})

find_package(OmnetPP REQUIRED)

require_envvar(EXPECTED_OMNETPP_ROOT EXPECTED_OMNETPP_VERSION)
expect_strequal($ENV{EXPECTED_OMNETPP_ROOT} OMNETPP_ROOT)
expect_strequal($ENV{EXPECTED_OMNETPP_VERSION} OMNETPP_VERSION)
