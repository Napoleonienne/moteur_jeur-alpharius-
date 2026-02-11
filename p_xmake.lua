-- Configuration avancée pour le build complet (equivalent de l'ancien p.txt)
-- À intégrer dans le xmake.lua principal quand le projet sera complet.

set_languages("cxx23")

set_toolchains("clang")
add_cxflags("-flto=thin")
add_ldflags("-flto=thin", "-fuse-ld=mold")

add_rules("mode.debug", "mode.release")

if is_mode("release") then
    set_optimize("aggressive")     -- -O3
    add_cxflags("-march=native")
end

local imgui_dir = path.join(os.projectdir(), "externe/imgui")
local physx_dir = path.join(os.projectdir(), "externe/physique")
local physx_source = path.join(physx_dir, "physx/bin/linux.x86_64/debug")

add_requires("glm", "glfw")

target("moteur_jeur-alpharius")
    set_kind("binary")

    add_files("src/*/*.cpp", "src/*/*.c", "src/*.cpp", "src/*.c")

    -- ImGui sources
    add_files(
        path.join(imgui_dir, "imgui.cpp"),
        path.join(imgui_dir, "imgui_draw.cpp"),
        path.join(imgui_dir, "imgui_tables.cpp"),
        path.join(imgui_dir, "imgui_widgets.cpp"),
        path.join(imgui_dir, "imgui_demo.cpp"),
        path.join(imgui_dir, "backends/imgui_impl_glfw.cpp"),
        path.join(imgui_dir, "backends/imgui_impl_vulkan.cpp")
    )

    add_includedirs(
        "dependance/",
        "dependance/vulkan",
        "externe",
        imgui_dir,
        path.join(imgui_dir, "backends"),
        path.join(physx_dir, "physx/include"),
        path.join(physx_dir, "pxshared/include")
    )

    add_packages("glm", "glfw")

    -- PyBind11 & spdlog submodules
    includes("externe/pybind")
    includes("externe/spdlog")

    if is_plat("linux") then
        add_syslinks("X11", "Xrandr", "Xi", "Xxf86vm", "Xcursor", "pthread", "dl", "m")
    elseif is_plat("macosx") then
        add_frameworks("Cocoa", "IOKit", "CoreVideo")
    end

    -- PhysX static libraries
    add_links(
        path.join(physx_source, "libPhysX_static_64.a"),
        path.join(physx_source, "libPhysXCommon_static_64.a"),
        path.join(physx_source, "libPhysXFoundation_static_64.a"),
        path.join(physx_source, "libPhysXCooking_static_64.a"),
        path.join(physx_source, "libPhysXExtensions_static_64.a"),
        path.join(physx_source, "libPhysXPvdSDK_static_64.a"),
        path.join(physx_source, "libPhysXCharacterKinematic_static_64.a")
    )
