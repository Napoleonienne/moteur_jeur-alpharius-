cmake_minimum_required(VERSION 3.28)
project(moteur_jeur-alpharius VERSION 0.1.0 LANGUAGES C CXX)


add_executable(${PROJECT_NAME}
    ${CMAKE_SOURCE_DIR}/app/main.cpp
)


set(FMO_LIB ${CMAKE_SOURCE_DIR}/fmodstudioapi20309linux)
set(FMO_HEADER ${FMO_LIB}/api/core)

target_link_libraries(${PROJECT_NAME} PRIVATE 
    ${CMAKE_SOURCE_DIR}/api/core/inc



)