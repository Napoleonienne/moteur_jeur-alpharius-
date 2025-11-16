cmake_minimum_required(VERSION 3.28)
project(moteur_jeur-alpharius VERSION 0.1.0 LANGUAGES C CXX)


set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -march=native")
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(IMGUI_DIR ${CMAKE_SOURCE_DIR}/externe/imgui)
set(PHYSX_DIR ${CMAKE_SOURCE_DIR}/externe/physique)
set(PHYSX_SOURCE ${PHYSX_DIR}/physx/bin/linux.x86_64/debug)


find_package(OpenGL REQUIRED)
find_package(glm REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_search_module(GLFW REQUIRED glfw3)
if(NOT GLFW_FOUND)
    message(FATAL_ERROR "GLFW not found. Installez libglfw3-dev et réessayez.")
endif()

file(GLOB_RECURSE PROJECT_SOURCES 
    "${CMAKE_SOURCE_DIR}/src/*/*.cpp"
    "${CMAKE_SOURCE_DIR}/src/*/*.c"
    "${CMAKE_SOURCE_DIR}/src/*.cpp" 
    "${CMAKE_SOURCE_DIR}/src/*.c"
)

set(IMGUI_SOURCES
    ${IMGUI_DIR}/imgui.cpp
    ${IMGUI_DIR}/imgui_draw.cpp
    ${IMGUI_DIR}/imgui_tables.cpp
    ${IMGUI_DIR}/imgui_widgets.cpp
    ${IMGUI_DIR}/imgui_demo.cpp
    ${IMGUI_DIR}/backends/imgui_impl_glfw.cpp
    ${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
)



add_executable(${PROJECT_NAME}
    ${PROJECT_SOURCES}
    ${IMGUI_SOURCES}
)

target_compile_definitions(${PROJECT_NAME} PRIVATE IMGUI_IMPL_OPENGL_LOADER_GLAD)


target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_SOURCE_DIR}/dependance/
        ${CMAKE_SOURCE_DIR}/dependance/opengl
        ${CMAKE_SOURCE_DIR}/dependance/vulkan
        ${CMAKE_SOURCE_DIR}/externe
        ${IMGUI_DIR}
        ${IMGUI_DIR}/backends
        ${GLFW_INCLUDE_DIRS}
        ${PHYSX_DIR}/physx/include
        ${PHYSX_DIR}/pxshared/include
)




if(WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE 
    OpenGL::GL 
    glfw 
    glm::glm
    
    ${PHYSX_SOURCE}/libPhysX_static_64.a
        ${PHYSX_SOURCE}/libPhysXCommon_static_64.a
        ${PHYSX_SOURCE}/libPhysXFoundation_static_64.a
        ${PHYSX_SOURCE}/libPhysXCooking_static_64.a
        ${PHYSX_SOURCE}/libPhysXExtensions_static_64.a
        ${PHYSX_SOURCE}/libPhysXPvdSDK_static_64.a
        ${PHYSX_SOURCE}/libPhysXCharacterKinematic_static_64.a
    )
elseif(APPLE)
    find_library(COCOA Cocoa)
    find_library(IOKIT IOKit)
    find_library(COREVIDEO CoreVideo)
    target_link_libraries(${PROJECT_NAME} PRIVATE 
    OpenGL::GL 
    glfw 
    glm::glm 
    ${COCOA} 
    ${IOKIT} 
    ${COREVIDEO}
    
    ${PHYSX_SOURCE}/libPhysX_static_64.a
        ${PHYSX_SOURCE}/libPhysXCommon_static_64.a
        ${PHYSX_SOURCE}/libPhysXFoundation_static_64.a
        ${PHYSX_SOURCE}/libPhysXCooking_static_64.a
        ${PHYSX_SOURCE}/libPhysXExtensions_static_64.a
        ${PHYSX_SOURCE}/libPhysXPvdSDK_static_64.a
        ${PHYSX_SOURCE}/libPhysXCharacterKinematic_static_64.a
    )
else() # Linux
    target_link_libraries(${PROJECT_NAME} PRIVATE
        OpenGL::GL
        glfw
        glm::glm
        X11
        Xrandr
        Xi
        Xxf86vm
        Xcursor
        pthread
        dl
        m

        ${PHYSX_SOURCE}/libPhysX_static_64.a
        ${PHYSX_SOURCE}/libPhysXCommon_static_64.a
        ${PHYSX_SOURCE}/libPhysXFoundation_static_64.a
        ${PHYSX_SOURCE}/libPhysXCooking_static_64.a
        ${PHYSX_SOURCE}/libPhysXExtensions_static_64.a
        ${PHYSX_SOURCE}/libPhysXPvdSDK_static_64.a
        ${PHYSX_SOURCE}/libPhysXCharacterKinematic_static_64.a
    )
endif()
