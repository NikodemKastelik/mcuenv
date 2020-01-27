include(${CMAKE_CURRENT_LIST_DIR}/boilerplate_common.cmake)

set_paths()

##
# Prepare compiler flags
#
list(APPEND C_FLAGS "-Wall")

##
# Prepare define flags
#
include(${CMAKE_PATH}/device/${TARGET}.cmake)

list(APPEND C_DEFINES ${MCU_SERIES})
list(APPEND C_DEFINES ${MCU_TYPE})
list(APPEND C_DEFINES "__MOCK_HAL")

##
# Create output target
#
add_executable(app)
set_target_properties(app PROPERTIES
    OUTPUT_NAME app
    SUFFIX .elf
)

target_sources(app PRIVATE
    ${APP_SOURCES}
)

target_include_directories(app PRIVATE
    ${STM32DRV_PATH}/drv/src
    ${STM32DRV_PATH}/drv/inc
    ${STM32DRV_PATH}/hal
)

target_compile_definitions(app PRIVATE ${C_DEFINES})
target_compile_options(app PUBLIC ${C_FLAGS})

add_unity_test_runner(app)

add_stm32drv_mock(app "${STM32DRV_CONFIG_DIR}")

add_cmsis_mock(stm32drv_mock)

add_cmock(stm32drv_mock)

add_unity(cmock)

