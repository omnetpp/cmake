`omnetpp-cmake` — CMake + OMNet++ = ❤
======================================

*This repository is a work-in-progress, and may never be fully be realised. It is substantially more likely that your use-case will not work out of the box, nor even after fiddling with the box. However, please do fiddle, and please help me improve it.*

CMake Modules for building OMNet++ projects and integrating with you CMake supporting editor.

These CMake modules were originally develeoped against **OMNet+ 5.X**, but should also work with **OMNet++ 6.0** and beyond.

Please help me make this better!

Usage
-----

The following is *one* of many other ways to do it.

1.	Add the repository as a *`git` submodule* to your repository in `cmake`.<sup id="a1">[1](#f1)</sup>

    ```sh
    git submodule add https://github.com/thor/omnetpp-cmake.git cmake
    ```

    ⚠ **Note:** If you have other CMake modules it is recommended that you replace `cmake` with `cmake/omnet` and so forth here and in the following steps.

2.  Update and/or initialise the submodule.<sup id="a2">[1](#f2)</sup>

    ```sh
    git submodule update --init --recursive
    ```

3.  Create a minimal `CMakeLists.txt` in the root repository folder.


    ```cmake
    project(YourProject)

    # It is recommended to increase the minimum version to your current
    cmake_minimum_required(VERSION 3.1)

    # Change "cmake" if you put the submodule in a different directory
    set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

    find_package(OmnetPP 6.0 REQUIRED)

    # Import the required CMake module
    include(OMNet)
    ```

4.  Update your `CMakeLists.txt` with your OMNet++ project details

    ```cmake
    # Uncomment the following if you have external dependencies like INET
    #find_path(INET_DIRNAMESsrc/inet/package.nedDOC "INET root directory")

    #import_opp_target(inet${INET_DIR}/src/Makefile)

    # Define your library/simulation sources
    set(SOURCES
        src/a.cc
        src/b.cc)

    add_library(project_library SHARED ${SOURCES})

    # Define your messages as well
    set(MESSAGE_SOURCES
        messages/a.msg
        messages/b.msg)

    generate_opp_message(${MESSAGE_SOURCES}
        TARGET project_library)

    # You will need to tweak and add the additional properties for your project
    set_target_properties(project_library PROPERTIES
        OUTPUT_NAME my_project_sim
        NED_FOLDERS src)

    # Link the libraries you need for your project; add "inet" if necessary
    target_link_libraries(project_library opp_interface)

    # This creates an OMNet++ CMake run for you
    add_opp_run(project_name 
        CONFIG omnetpp.ini 
        DEPENDENCY project_library)
    ```


### Macros Available

- `generate_opp_message`(`<file1>` ... *`TARGET`* `<target1> ...`)  
  Generates and links a message file to a given target.

- `import_opp_target`(`<opp_makemake_target>` `<Makefile>` [ `<cmake_target_file>` ])  
  Imports a target from a Makefile created by opp_makemake.  
  ⚠ **Note:** The target must have the same name as in the `Makefile`!

- `add_opp_build_target`(`<name>`)  
  Adds a build target with a given name.

- `add_opp_run`(`<name>` [ *`CONFIG`* `<file>` | *`WORKING_DIRECTORY`* `<dir>` | *`NED_FOLDERS`* `<dir1> ...` ] *`DEPENDENCY`* `<target>` )  
  Adds a build target with a given name based on the given dependency.

- `add_opp_test`(`<name>` [*`CONFIG`* `<file>` | *`RUN`* `<entry>` | *`SIMTIME_LIMIT`* `<limit>` | *`SUFFIX`* `<name>`])
  Adds a test target with a given name.

### Interfaces and Library Targets Available

- `opp_interface`

- `opp_cmdenv`
- `opp_common`
- `opp_envir`
- `opp_eventlog`
- `opp_layout`
- `opp_main`
- `opp_nedxml`
- `opp_scave`
- `opp_sim`
- `opp_qtenv`
- `opp_qtenv-osg`


Motivation & Background
-----------------------

For the full motivation and background please [see Raphael Riebl's presentation at the 2015 OMNet++ Summit][summit-presentation].

Some benefits include:

* CMake's wide usage for C/C++ projects
- Convenient user interfaces available for configuring builds
- Solid dependency handling, both *internal* and *external*
- More accessible syntax compared to Makefiles

*My* motivation for forking this into a dedicated repository is primarily:

* Limit my build approach to one interface rather than the default two with OMNet++
* Allow me to integrate it with ease into other editors than Eclipse such as JetBrains CLion
* Try to make it work for OMNet++ 6.0 preview release

Caveats
-------

There have been some changes which I don't trust (namely all of my own changes).
These are primarily changes to make the proof-of-concept employed in Artery also work with OMNet++ 6.0.
However, there are also some minor oddities and questions, uncertainties and the likes of which.

- [ ] `opp_cmake.py` will not take a lot of automatic definitions into account when importing a project
- [ ] `clean_opp_messages()` is unavailable as message files are no longer gathered in a single folder for buliding
- [ ] `add_opp_run` doesn't seem to utilise the parameter `NED_FOLDERS`

Licensing
---------

The original CMake modules are taken and modified from [the OMNet++ V2X simulation framework in `riebl/artery`][artery], which is for the most part licensed as GPL-2.0. However, there are no license headings in the CMake modules whereas the source files *do*. Thus...

- [ ] Clarify license of CMake modules from `riebl/artery`

References
----------

- [Source repository `riebl/artery`][artery]
- [Presentation at 2015 OMNet++ Summit][summit-presentation]


[artery]: https://github.com/riebl/artery
[artery_checkout]: https://github.com/riebl/artery/tree/a4e013af70d2b5c3223492a518afb57fb92a7a8d/cmake
[summit-presentation]: https://summit.omnetpp.org/archive/2015/assets/pdf/OMNET-2015-17-Slides.pdf

---

<b id="f1">1</b>: You could also just download the files and put them where you'd like, or if you want to help contribute, *fork it* and add that repository as a submodule! [↩](#a1)

<b id="f2">2</b>: You may exchange the paths as you wish, but make sure to update them later on too. [↩](#a2)