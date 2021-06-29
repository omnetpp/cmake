include(CMakeParseArguments)

# Options:
# - MSG4: Call message compiler with --msg4
# 
# One Value Arguments:
# - TARGET: Optional name of the target to call target_sources and target_include_directories to add compiled sources
# - OUTPUT_ROOT: Optional root-directory where the files will be generated. Default: ${PROJECT_BINARY_DIR}/opp_messages
# - DIRECTORY: Optional relative path for the output-directory (Appended to OUTPUT_ROOT). 
#   Defaults to the relative path of the message file in respect to ${PROJECT_SOURCE_DIR}/src
# - GEN_SOURCES: Optional name of the variable to populate with sources to be compiled
# - GEN_INCLUDE_DIR: Optional name of the variable to populate with the include directory
#
# Mutli Value Arguments:
# - ADDITIONAL_NED_PATHS: Optional paths to be added as search/include directories when calling the message compiler (-I Arguments)

# generate sources for messages via opp_msgc
function(generate_opp_message msg_input)
    set(options_args MSG4)
    set(single_args TARGET DIRECTORY OUTPUT_ROOT GEN_SOURCES GEN_INCLUDE_DIR DLL_SYMBOL)
    set(multi_args ADDITIONAL_NED_PATHS)

    cmake_parse_arguments(args "${options_args}" "${single_args}" "${multi_args}" ${ARGN})

    if(args_UNPARSED_ARGUMENTS)
        message(SEND_ERROR "generate_opp_message called with invalid arguments: ${args_UNPARSED_ARGUMENTS}")
    endif()

    if(args_OUTPUT_ROOT)
        set(msg_output_root ${args_OUTPUT_ROOT})
    else()
        set(msg_output_root ${PROJECT_BINARY_DIR}/opp_messages)
    endif()

    get_filename_component(msg_full_name "${msg_input}" NAME)
    get_filename_component(msg_name "${msg_input}" NAME_WE)
    get_filename_component(msg_dir "${msg_input}" DIRECTORY)

    if(args_DIRECTORY)
        set(msg_prefix "${args_DIRECTORY}")
    else()
        file(RELATIVE_PATH msg_prefix ${PROJECT_SOURCE_DIR}/src ${CMAKE_CURRENT_SOURCE_DIR}/${msg_dir})
    endif()

    set(msg_output_dir "${msg_output_root}/${msg_prefix}")
    set(msg_output_source "${msg_output_dir}/${msg_name}_m.cc")
    set(msg_output_header "${msg_output_dir}/${msg_name}_m.h")

    # Prepare arguments for command
    list(APPEND _args "-s" "_m.cc")

    foreach(include_dir IN LISTS args_ADDITIONAL_NED_PATHS)
        list(APPEND _args "-I" ${include_dir})
    endforeach()

    # Handle message version
    if(args_MSG4)
        list(APPEND _args "--msg4")
    endif()

    # Handle DLL-Export
    if(WIN32 OR MSVC AND ${OMNETPP_VERSION} VERSION_GREATER_EQUAL 6)
        if(args_DLL_SYMBOL)
            list(APPEND _args "-P ${args_DLL_SYMBOL}")
        endif()
    endif()

    # Create the output directory
    file(MAKE_DIRECTORY ${msg_output_dir})

    # Copy the msg file to the output directory (since the -h otion is gone in version 6)
    set(msg_input_process "${msg_output_dir}/${msg_full_name}")

    add_custom_command(OUTPUT ${msg_input_process}
        COMMAND ${CMAKE_COMMAND} -E copy ${msg_input} ${msg_input_process}
        COMMENT "Copying ${msg_full_name} to output directory"
        DEPENDS ${msg_input}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        VERBATIM
    )
    list(APPEND _args ${msg_input_process})

    add_custom_command(OUTPUT "${msg_output_source}" "${msg_output_header}"
        COMMAND ${OMNETPP_MSGC} ARGS ${_args}
        COMMAND_EXPAND_LISTS
        COMMENT "Generating ${msg_prefix}/${msg_name}"
        DEPENDS ${OMNETPP_MSGC} ${msg_input_process}
        WORKING_DIRECTORY ${msg_output_dir}
        VERBATIM
    )

    if (args_TARGET)
        target_sources(${args_TARGET} PRIVATE "${msg_output_source}" "${msg_output_header}")
        target_include_directories(${args_TARGET} PUBLIC ${msg_output_root})
    endif()

    if(args_GEN_SOURCES)
        set(${args_GEN_SOURCES} "${msg_output_source}" "${msg_output_header}" PARENT_SCOPE)
    endif()

    if(args_GEN_INCLUDE_DIR)
        set(${args_GEN_INCLUDE_DIR} ${msg_output_root} PARENT_SCOPE)
    endif()
endfunction()
