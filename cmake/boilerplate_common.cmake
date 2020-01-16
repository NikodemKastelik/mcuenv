##
# Macro for setting common paths
#
macro(set_paths)
    set(CMAKE_PATH         ${CMAKE_CURRENT_LIST_DIR})
    set(MCUENV_PATH        ${CMAKE_CURRENT_LIST_DIR}/..)
    set(UNITY_PATH         ${MCUENV_PATH}/test_framework/unity)
    set(CMOCK_PATH         ${MCUENV_PATH}/test_framework/cmock)
    set(STARTUP_PATH       ${MCUENV_PATH}/startup)
    set(CMSIS_PATH         ${MCUENV_PATH}/cmsis)
    set(CMSIS_MOCK_PATH    ${MCUENV_PATH}/test_framework/cmsis_mock)
    set(STM32DRV_PATH      ${MCUENV_PATH}/../stm32drv)
    set(MCULIB_PATH        ${MCUENV_PATH}/../mculib)
    set(STM32DRV-TEST_PATH ${MCUENV_PATH}/../stm32drv-test)
endmacro()

##
# Unity library setup
#
function(add_unity EXECUTABLE_NAME)
    add_library(unity STATIC)

    target_sources(unity PRIVATE
        ${UNITY_PATH}/src/unity.c
    )

    target_include_directories(unity PUBLIC
        ${UNITY_PATH}/src
    )

    target_link_libraries(${EXECUTABLE_NAME} unity)
endfunction()

##
# CMock library setup
#
function(add_cmock EXECUTABLE_NAME)
    add_library(cmock STATIC)

    target_sources(cmock PRIVATE
        ${CMOCK_PATH}/src/cmock.c
    )

    target_include_directories(cmock PUBLIC
        ${CMOCK_PATH}/src
    )

    target_link_libraries(${EXECUTABLE_NAME} cmock)
endfunction()

##
# Function for verifying provided path to stm32drv configuration file
#
function(stm32drv_config_dir_verify STM32DRV_CONFIG_DIR)
    if("${STM32DRV_CONFIG_DIR}" STREQUAL "")
        message(FATAL_ERROR "\nDirectory of \"stm32drv_config.h\" file "
                            "was not specified.\n"
                            "Specify the directory by setting "
                            "the STM32DRV_CONFIG_DIR variable.\n")
    endif()
endfunction()

##
# stm32drv library setup
#
function(add_stm32drv EXECUTABLE_NAME STM32DRV_CONFIG_DIR)
    stm32drv_config_dir_verify("${STM32DRV_CONFIG_DIR}")

    file(GLOB LIB_SOURCES ${STM32DRV_PATH}/drv/src/*.c)

    add_library(stm32drv STATIC)

    target_sources(stm32drv PRIVATE
        ${LIB_SOURCES}
    )

    target_include_directories(stm32drv PUBLIC
        ${STM32DRV_PATH}/hal
        ${STM32DRV_PATH}/drv/inc
        ${STM32DRV_CONFIG_DIR}
    )

    target_compile_definitions(stm32drv PRIVATE
        ${MCU_SERIES}
        ${MCU_TYPE}
    )

    target_link_libraries(${EXECUTABLE_NAME} stm32drv)
endfunction()

##
# mculib library setup
#
function(add_mculib EXECUTABLE_NAME)
    file(GLOB LIB_SOURCES ${MCULIB_PATH}/src/*.c)

    add_library(mculib STATIC)

    target_sources(mculib PRIVATE
        ${LIB_SOURCES}
    )

    target_include_directories(mculib PUBLIC
        ${MCULIB_PATH}/inc
    )

    target_link_libraries(${EXECUTABLE_NAME} mculib)
endfunction()

##
# cmsis library setup
#
function(add_cmsis EXECUTABLE_NAME)
    add_library(cmsis INTERFACE)

    target_include_directories(cmsis INTERFACE
        ${CMSIS_PATH}/core
        ${CMSIS_PATH}/device
    )

    target_link_libraries(${EXECUTABLE_NAME} cmsis)
endfunction()

##
# cmsis mock library setup
#
function(add_cmsis_mock EXECUTABLE_NAME)
    add_library(cmsis_mock INTERFACE)

    target_include_directories(cmsis_mock INTERFACE
        ${CMSIS_MOCK_PATH}
        ${CMSIS_PATH}/device
    )

    target_link_libraries(${EXECUTABLE_NAME} cmsis_mock)
endfunction()

##
# stm32drv mock setup
#
function(add_stm32drv_mock EXECUTABLE_NAME STM32DRV_CONFIG_DIR)
    stm32drv_config_dir_verify("${STM32DRV_CONFIG_DIR}")

    file(GLOB MOCK_SOURCES ${STM32DRV-TEST_PATH}/mocks/*.c)

    add_library(stm32drv_mock STATIC)

    target_sources(stm32drv_mock PRIVATE
        ${MOCK_SOURCES}
    )

    target_include_directories(stm32drv_mock
        PUBLIC
            ${STM32DRV-TEST_PATH}/mocks
            ${STM32DRV_CONFIG_DIR}
        PRIVATE
            ${STM32DRV_PATH}/hal
    )

    target_compile_definitions(stm32drv_mock PRIVATE
        ${MCU_SERIES}
        ${MCU_TYPE}
        "__MOCK_HAL"
        "__STATIC_INLINE="
    )

    target_link_libraries(${EXECUTABLE_NAME} stm32drv_mock)
endfunction()

##
# Add hex generation
#
function(add_hex EXECUTABLE_NAME)
    add_custom_target(generate-hex
        ALL
        COMMAND ${CMAKE_OBJCOPY} -O ihex ${EXECUTABLE_NAME}.elf ${EXECUTABLE_NAME}.hex
        COMMENT "Generate hex..."
    )
    add_dependencies(generate-hex ${EXECUTABLE_NAME})
endfunction()
