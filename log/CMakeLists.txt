cmake_minimum_required(VERSION 3.28)
project(LOG VERSION 0.1 LANGUAGES CXX C)


file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)

 
${PROJECT_SOURCES}
)
include(FetchContent)
FetchContent_Declare(
  spdlog
  GIT_REPOSITORY https://github.com/gabime/spdlog.git

)
FetchContent_MakeAvailable(spdlog)