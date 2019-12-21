include(${CMAKE_CURRENT_LIST_DIR}/boilerplate_common.cmake)

set_paths()

##
# Prepare compiler flags
#
list(APPEND C_FLAGS "-Wall")

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
    ${MCULIB_PATH}/src
    ${MCULIB_PATH}/inc
)

target_compile_options(app PUBLIC ${C_FLAGS})

add_unity(app)
