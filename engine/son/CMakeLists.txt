cmake_minimum_required(VERSION 3.28)
project(son VERSION 0.1 LANGUAGES CXX C)


add_subdirectory(${CMAKE_SOURCE_DIR}/openal1)

add_executable(${PROJECT_NAME} 
${CMAKE_SOURCE_DIR}/main.cpp
)