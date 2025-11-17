cmake_minimum_required(VERSION 3.28)
project(LOG VERSION 0.1 LANGUAGES CXX C)


file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)

add_executable(${PROJECT_NAME}
${PROJECT_SOURCES}
)
add_subdirectory(/home/guy/Bureau/moteur_jeur-alpharius-/externe/spdlog)