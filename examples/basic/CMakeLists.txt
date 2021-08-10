# This is a basic example of an OMNeT++ project using CMake.
# Compared to more advanced projects, this example depends only on OMNeT++ itself.

project(BasicOppProject)
cmake_minimum_required(VERSION 3.13)

# Tell CMake where it can the omnetpp-cmake sources
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../..)

# Find an OMNeT++ installation on your system.
# The found libraries and headers are available as OmnetPP::* targets.
find_package(OmnetPP REQUIRED)
# Alternatively, you can also explicitly request a particular OMNeT++ version:
# find_package(OmnetPP 5.6 REQUIRED)

# OMNeT++ projects are usually built as shared objects (dynamic libraries),
# which are loaded and executed by opp_run or opp_run_debug later on (see add_opp_run below).
add_library(basic_example SHARED src/TicToc.cc)

# Define where to look for *.ned files when using your simulation model
set_target_properties(basic_example PROPERTIES NED_FOLDERS src)

# Our library depends on the OMNeT++ libraries
target_link_libraries(basic_example PUBLIC OmnetPP::sim)

# Generate source code from an OMNeT++ message:
# Build the generated sources along with your TARGET.
include(GenerateOppMessage)
generate_opp_message(src/Tone.msg TARGET basic_example)

# Add targets to run and debug your project:
# - run_basic runs your model with opp_run (always available)
# - debug_basic runs your model with opp_run_dbg and your GDB debugger
#   (only available when CMAKE_BUILD_TYPE is set to "Debug")
#
# add_opp_run uses the omnetpp.ini configuration found in the WORKING_DIRECTORY.
# All relative file references in your omnetpp.ini are relative to this WORKING_DIRECTORY then.
# DEPENDENCY tells CMake which libraries have to be loaded by opp_run. If a given DEPENDENCY
# depends on another project (e.g. INET), these additional dependencies are added for you.
#
# add_opp_run knows where to find your library and also appends the NED paths automatically.
include(AddOppRun)
add_opp_run(basic DEPENDENCY basic_example WORKING_DIRECTORY run)

# Bonus: test cases for your simulation model
#
# You can also use simulation configurations as "smoke tests", e.g. run the "Reverse" configuration for 20s.
# The remaining run parameters (i.e. which omnetpp.ini and which library to use) are borrowed from
# add_opp_run(basic ...).
# You can run the tests via `make test` or invoking `ctest` in your build directory.
enable_testing()
add_opp_test(basic CONFIG Reverse SIMTIME_LIMIT 20s SUFFIX reversed)
