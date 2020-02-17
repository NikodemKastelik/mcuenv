include(${CMAKE_CURRENT_LIST_DIR}/boilerplate_common.cmake)

set_paths()

##
# Setup compiler options
#
set(CMAKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_OBJCOPY    arm-none-eabi-objcopy)

set(CMAKE_EXE_LINKER_FLAGS "--specs=nosys.specs" CACHE INTERNAL "")

##
# Generate linker script
#
include(${CMAKE_PATH}/device/${TARGET}.cmake)
configure_file(${CMAKE_PATH}/linker_script_template.cmake
               linker_script.ld)

##
# Prepare define flags
#
list(APPEND C_DEFINES ${MCU_SERIES})
list(APPEND C_DEFINES ${MCU_TYPE})

##
# Prepare compiler flags
#
list(APPEND C_FLAGS "-mcpu=${MCU_CPU}")
list(APPEND C_FLAGS "-mthumb")
list(APPEND C_FLAGS "-O3")
list(APPEND C_FLAGS "-g")
list(APPEND C_FLAGS "-ffunction-sections")
list(APPEND C_FLAGS "-fdata-sections")
list(APPEND C_FLAGS "-fomit-frame-pointer")

##
# Prepare linker flags
#
list(APPEND LINKER_FLAGS "-mcpu=${MCU_CPU}")
list(APPEND LINKER_FLAGS "-mthumb")
list(APPEND LINKER_FLAGS "-nostartfiles")
list(APPEND LINKER_FLAGS "-Tlinker_script.ld")
list(APPEND LINKER_FLAGS "--specs=nano.specs")
list(APPEND LINKER_FLAGS "-Wl,--gc-sections")

##
# Create output target
#
set(EXECUTABLE_NAME app)

add_executable(${EXECUTABLE_NAME})
set_target_properties(${EXECUTABLE_NAME} PROPERTIES
    OUTPUT_NAME ${EXECUTABLE_NAME}
    SUFFIX .elf
)

target_sources(${EXECUTABLE_NAME} PRIVATE
    ${APP_SOURCES}
    ${STARTUP_PATH}/${STARTUP_FILE}
)
target_compile_definitions(${EXECUTABLE_NAME} PRIVATE ${C_DEFINES})
target_compile_options(${EXECUTABLE_NAME} PUBLIC ${C_FLAGS})
target_link_options(${EXECUTABLE_NAME} PRIVATE ${LINKER_FLAGS})

##
# Add stm32drv library.
#
add_stm32drv(${EXECUTABLE_NAME} "${STM32DRV_CONFIG_DIR}")

##
# Add CMSIS library to the stm32drv library
#
add_cmsis(stm32drv)

##
# Add mculib library
#
add_mculib(${EXECUTABLE_NAME})

##
# Generate final .hex
#
add_hex(${EXECUTABLE_NAME})
