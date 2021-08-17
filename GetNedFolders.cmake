#[==[.rst:
GetNedFolders
-------------

*This documentation is still a stub!*
#]==]

function(_get_ned_folders_plumbing _target _property _base_dir _output)
    set(_folders "")
    get_target_property(_target_type ${_target} TYPE)
    if(NOT ${_target_type} STREQUAL "INTERFACE_LIBRARY")
        get_target_property(_target_ned_folders ${_target} ${_property})
        if(_target_ned_folders)
            list(APPEND _folders ${_target_ned_folders})
        endif()
    endif()

    get_target_property(_target_dependencies ${_target} INTERFACE_LINK_LIBRARIES)
    if(_target_dependencies)
        foreach(_target_dependency IN LISTS _target_dependencies)
            if(TARGET ${_target_dependency})
                _get_ned_folders_plumbing(${_target_dependency} ${_property} ${_base_dir} _folders_dependency)
                list(APPEND _folders ${_folders_dependency})
            endif()
        endforeach()
    endif()

    list(REMOVE_DUPLICATES _folders)
    set(_folders_abs "")
    foreach(_folder IN LISTS _folders)
        get_filename_component(_folder_abs ${_folder} ABSOLUTE BASE_DIR ${_base_dir})
        list(APPEND _folders_abs ${_folder_abs})
    endforeach()
    set(${_output} ${_folders_abs} PARENT_SCOPE)
endfunction()

#[==[.rst:
.. cmake:command:: get_ned_folders
#]==]
function(get_ned_folders _target _output)
    _get_ned_folders_plumbing(${_target} NED_FOLDERS ${CMAKE_CURRENT_SOURCE_DIR} _folders)
    set(${_output} ${_folders} PARENT_SCOPE)
endfunction()

#[==[.rst:
.. cmake:command:: get_install_ned_folders
#]==]
function(get_install_ned_folders _target _output)
    _get_ned_folders_plumbing(${_target} INSTALL_NED_FOLDERS ${CMAKE_INSTALL_PREFIX} _folders)
    set(${_output} ${_folders} PARENT_SCOPE)
endfunction()
