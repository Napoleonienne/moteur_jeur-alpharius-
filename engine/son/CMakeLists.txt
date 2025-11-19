cmake_minimum_required(VERSION 3.28)
project(son VERSION 0.1 LANGUAGES CXX C)

file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)

add_subdirectory(${CMAKE_SOURCE_DIR}/openal1)

add_executable(${PROJECT_NAME} 
${CMAKE_SOURCE_DIR}/main.cpp
)

set(FMOD ${CMAKE_SOURCE_DIR}/fmodstudioapi20309linux)
set(FMOD_core ${CMAKE_SOURCE_DIR}/api/core)
target_include_directories(${PROJECT_NAME} PRIVATE

    ${FMOD_core}/inc
)
target_link_libraries(${PROJECT_NAME} PRIVATE


)