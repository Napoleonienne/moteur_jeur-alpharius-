cmake_minimum_required(VERSION 3.28)
project(LOG VERSION 0.1 LANGUAGES CXX C)


find_package(spdlog CONFIG REQUIRED)
#sudo apt install libspdlog-dev
file(GLOB_RECURSE PROJECT_SOURCES
    "${CMAKE_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*.c"
)

 
${PROJECT_SOURCES}
)
<<<<<<< HEAD
include(FetchContent)
FetchContent_Declare(
  spdlog
  GIT_REPOSITORY https://github.com/gabime/spdlog.git

)
FetchContent_MakeAvailable(spdlog)
=======

include_directories(${PROJECT_NAME}
 private

"${CMAKE_SOURCE_DIR}/include"
)
>>>>>>> fa97dccd4c47d7bdeba52420646b6b0a28678242
