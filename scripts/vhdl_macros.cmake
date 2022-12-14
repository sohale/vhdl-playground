# VHDL Continous Integration Example
# Copyright (C) 2017  Mario Barbareschi
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# from: https://github.com/mariobarbareschi/vhdl_ci/blob/master/CMakeLists.txt

set(GHDL_COMPILER_ENV_VAR ghdl)
set(GHDL_COMPILER ghdl)
if(VCD_VIEWER)
	set(VCD_VIEWER_COMMAND ${VCD_VIEWER})
else()
	set(VCD_VIEWER_COMMAND gtkwave)
	message(STATUS "VCD_VIEWER variable is not set. By default, gtkWave will be invoked")
endif()


# CMAKE macro for add_vhdl_source macro
# add_vhdl_source(<file> <entity_tag>) | add <file> with the symbolic name <entity_tag> into the library *work*|
macro (add_vhdl_source)
    file (RELATIVE_PATH _path "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src_n ${ARGV0})
        if (_path)
           set(FILE_SRC "${_path}/${_src_n}")
        else()
           set(FILE_SRC "${_src_n}")
        endif()
        message(STATUS "Found VHDL Source: ${FILE_SRC}")
        add_custom_target("${ARGV1}" COMMAND ${GHDL_COMPILER} -a  -v "${CMAKE_SOURCE_DIR}/${FILE_SRC}" WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
        list (APPEND VHDL_MODULE "${ARGV1}")
    endforeach()
        set (VHDL_MODULE ${VHDL_MODULE}  CACHE INTERNAL "" FORCE)
endmacro()

# CMAKE macro for add_vhdl_library macro
# add_vhdl_library(<file> <library_name> <entity_tag>) | add <file> with the symbolic name <entity_tag> into the library <library_name> |
# ARGV0 ARGV1 ARGV2 := <file> <library_name> <entity_tag>
macro (add_vhdl_library)
 file (RELATIVE_PATH _path "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src_n ${ARGV0})
        if (_path)
           set(FILE_SRC "${_path}/${_src_n}")
        else()
           set(FILE_SRC "${_src_n}")
        endif()
        message(STATUS "Found VHDL Source: ${FILE_SRC}")
        add_custom_target("${ARGV2}" COMMAND ${GHDL_COMPILER} -a -v --work=${ARGV1} "${CMAKE_SOURCE_DIR}/${FILE_SRC}" WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
        list (APPEND VHDL_MODULE "${ARGV2}")
    endforeach()
        set (VHDL_MODULE ${VHDL_MODULE}  CACHE INTERNAL "" FORCE)
endmacro()

# CMAKE macro for add_testbench_source macro
# add_testbench_source(<file> <test_tag>) | add testbench <file> with the symbolic name <test_tag> |
macro (add_testbench_source)
    file (RELATIVE_PATH _path "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGV0})
        if (_path)
            set(FILE_SRC "${_path}/${_src}")
        else()
            set(FILE_SRC "${_src}")
        endif()

        string(REGEX REPLACE ".vhd" "" TEST_NAME "${FILE_SRC}")
        string(REGEX REPLACE "/" "." TEST_NAME "${TEST_NAME}")
        set(TRACE_PATH "${CMAKE_BINARY_DIR}/trace")
        file(MAKE_DIRECTORY ${TRACE_PATH})
        set(TRACE_VCD_PATH "${TRACE_PATH}/${TEST_NAME}.vcd")
        set(TRACE_FST_PATH "${TRACE_PATH}/${TEST_NAME}.fst")

        add_custom_target("${ARGV1}" COMMAND ${GHDL_COMPILER} -a -v "${CMAKE_SOURCE_DIR}/${FILE_SRC}" &&
                                                 ${GHDL_COMPILER} -e -v "${ARGV1}" WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
        add_custom_target("${TEST_NAME}" COMMAND ${GHDL_COMPILER} -r -v ${ARGV1}  --stop-time=1000ns --vcd=${TRACE_VCD_PATH} --fst=${TRACE_FST_PATH} WORKING_DIRECTORY ${CMAKE_BINARY_DIR} DEPENDS "${ARGV1}")

	add_custom_target("sim_${ARGV1}" COMMAND ${VCD_VIEWER_COMMAND} ${TRACE_VCD_PATH} WORKING_DIRECTORY ${CMAKE_BINARY_DIR} DEPENDS "${TEST_NAME}")

        add_test(NAME "${ARGV1}" COMMAND ${GHDL_COMPILER}  -r -v "${ARGV1}" --assert-level=error WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
        list (APPEND VHDL_TEST_MODULE "${ARGV1}")

        add_dependencies(runtest "${ARGV1}")

        message(STATUS "Adding VHDL Test: ${FILE_SRC}")
    endforeach()
    set (VHDL_TEST_MODULE ${VHDL_TEST_MODULE}  CACHE INTERNAL "" FORCE)
endmacro()
