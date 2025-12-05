cmake_minimum_required(VERSION 3.28)
project(son VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)


# FMOD
set(FMOD_ROOT ${CMAKE_SOURCE_DIR}/fmodstudioapi20309linux)
set(FMOD_CORE ${FMOD_ROOT}/api/core)
set(FMOD_STUDIO ${FMOD_ROOT}/api/studio)

add_executable(${PROJECT_NAME}
    ${PROJECT_SOURCES}
)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${FMOD_CORE}/inc
    ${FMOD_STUDIO}/inc
)

target_link_directories(${PROJECT_NAME} PRIVATE
    ${FMOD_CORE}/lib
    ${FMOD_STUDIO}/lib
)

