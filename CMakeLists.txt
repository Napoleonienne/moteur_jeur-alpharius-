cmake_minimum_required(VERSION 3.28)
project(moteur_jeur-alpharius VERSION 0.1.0 LANGUAGES C CXX)


add_executable(${PROJECT_NAME}
    ${CMAKE_SOURCE_DIR}/app/main.cpp
)