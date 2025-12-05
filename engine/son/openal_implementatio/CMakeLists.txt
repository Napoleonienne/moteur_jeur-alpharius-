cmake_minimum_required(VERSION 3.28)

project(son VERSION 0.1 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)
# OpenAL
add_subdirectory(${CMAKE_SOURCE_DIR}/openal1)
add_executable(${PROJECT_NAME}
    ${PROJECT_SOURCES}
)

