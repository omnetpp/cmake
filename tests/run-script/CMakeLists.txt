project(RunScriptTest)
cmake_minimum_required(VERSION 3.13)
include(${PROJECT_SOURCE_DIR}/../TestSuiteHelpers.cmake)
set(CMAKE_MODULE_PATH ${OMNETPP_CMAKE_ROOT})

# prepare dummy library and its dependencies
add_library(foo SHARED foo.cpp)
set_property(TARGET foo PROPERTY NED_FOLDERS "/foo/ned1;/foo/ned2")
add_library(bar SHARED bar.cpp)
set_property(TARGET bar PROPERTY NED_FOLDERS "/bar/ned")
set_property(TARGET bar PROPERTY OMNETPP_LIBRARY ON)

add_library(dummy SHARED dummy.cpp)
target_link_libraries(dummy foo bar)

# generate actual run script
find_package(OmnetPP REQUIRED)
include(AddOppRun)
generate_run_script(TARGET dummy FILE ${PROJECT_BINARY_DIR}/run.sh)

# generated run script is checked by post-tests
