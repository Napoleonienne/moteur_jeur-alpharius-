cmake_minimum_required(VERSION 3.28)
project(son VERSION 0.1 LANGUAGES CXX C)

file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)


add_executable(${PROJECT_NAME} 
    ${PROJECT_SOURCES}
)

set(FMOD ${CMAKE_SOURCE_DIR}/fmodstudioapi20309linux)
set(FMOD_CORE ${CMAKE_SOURCE_DIR}/api/core)
target_include_directories(${PROJECT_NAME} PRIVATE

    ${FMOD_CORE}/inc
    ${CMAKE_SOURCE_DIR}/include
)
target_link_libraries(${PROJECT_NAME} PRIVATE

    ${FMOD_CORE}/lib/x86_64/libfmod.so.14

)