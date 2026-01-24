cmake_minimum_required(VERSION 3.28)
project(LOG VERSION 0.1 LANGUAGES CXX C)

find_package(spdlog CONFIG REQUIRED)
#sudo apt install libspdlog-dev


target_include_directories(${PROJECT_NAME}
    PRIVATE
    "${CMAKE_SOURCE_DIR}/include"
    spdlog::spdlog
    ²
)


file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)

 
add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})

