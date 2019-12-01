##
# Macro for setting common paths
#
macro(set_paths)
    set(CMAKE_PATH    ${CMAKE_CURRENT_LIST_DIR})
    set(MCUENV_PATH   ${CMAKE_CURRENT_LIST_DIR}/..)
    set(UNITY_PATH    ${MCUENV_PATH}/test_framework/unity)
    set(CMOCK_PATH    ${MCUENV_PATH}/test_framework/cmock)
    set(STARTUP_PATH  ${MCUENV_PATH}/startup)
    set(CMSIS_PATH    ${MCUENV_PATH}/cmsis)
    set(STM32DRV_PATH ${MCUENV_PATH}/../stm32drv)
    set(MCULIB_PATH   ${MCUENV_PATH}/../mculib)
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
# stm32drv library setup
#
function(add_stm32drv EXECUTABLE_NAME)
    file(GLOB LIB_SOURCES ${STM32DRV_PATH}/drv/src/*.c)

    add_library(stm32drv STATIC)

    target_sources(stm32drv PRIVATE
        ${LIB_SOURCES}
    )

    target_include_directories(stm32drv PUBLIC
        ${STM32DRV_PATH}/hal
        ${STM32DRV_PATH}/drv/inc
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
