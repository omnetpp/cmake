cmake_minimum_required(VERSION 3.1)

include(CMakeParseArguments)

# generate sources for messages via opp_msgc
macro(generate_opp_message _msg_target)
    cmake_parse_arguments(_gen_opp_msg "" "" "MESSAGE_FILES" ${ARGN})
    if(_gen_opp_msg_UNPARSED_ARGUMENTS)
        message(SEND_ERROR "generate_opp_message called with invalid arguments: ${_gen_opp_msg_UNPARSED_ARGUMENTS}")
    endif()

    foreach(_msg_input IN ${_gen_opp_msg_MESSAGES_FILES})
        get_filename_component(_msg_name "${_msg_input}" NAME_WE)
        get_filename_component(_msg_dir "${_msg_input}" DIRECTORY)
        # From OMNet+ 6 opp_msgc is replaced by opp_msgtool
        # The tool uses the same syntax, but only outputs files in their source directory
        set(_msg_output_root ${PROJECT_SOURCE_DIR})
        # Gather the relative path from the source directory to the message input
        file(RELATIVE_PATH _msg_prefix ${_msg_output_root} ${CMAKE_CURRENT_SOURCE_DIR}/${_msg_dir})

        set(_msg_output_directory "${_msg_output_root}/${_msg_prefix}")
        set(_msg_output_source "${_msg_output_directory}/${_msg_name}_m.cc")
        set(_msg_output_header "${_msg_output_directory}/${_msg_name}_m.h")

        add_custom_command(OUTPUT "${_msg_output_source}" "${_msg_output_header}"
            COMMAND ${OMNETPP_MSGC}
            ARGS -s _m.cc ${CMAKE_CURRENT_SOURCE_DIR}/${_msg_input}
            DEPENDS ${_msg_input} ${OMNETPP_MSGC}
            COMMENT "Generating ${_msg_prefix}/${_msg_name}"
            VERBATIM)

        target_sources(${_msg_target} PRIVATE "${_msg_output_source}" "${_msg_output_header}")
        target_include_directories(${_msg_target} PUBLIC ${_msg_dir})
        message("")
    endforeach()
endmacro()

macro(clean_opp_messages)
    execute_process(COMMAND "${OMNETPP_MSGC}" ERROR_VARIABLE _output OUTPUT_VARIABLE _output)
    string(REGEX MATCH "Version: [0-9\.]+[a-z0-9]+, build: [^ ,]+" _opp_msgc_identifier "${_output}")
    if (NOT "${_opp_msgc_identifier}" STREQUAL "${OMNETPP_MSGC_IDENTIFIER}")
        file(REMOVE_RECURSE ${PROJECT_BINARY_DIR}/opp_messages)
    endif()
    set(OMNETPP_MSGC_IDENTIFIER ${_opp_msgc_identifier} CACHE INTERNAL "identification of OMNeT++ message compiler" FORCE)
endmacro()
variable_watch(OMNETPP_MSGC clean_opp_messages)
