set_project("moteur_jeur-alpharius")
set_version("0.1.0")
set_languages("c23", "cxx26")



set_toolchains("clang")
add_cxflags("-flto=thin")
add_ldflags("-flto=thin", "-fuse-ld=mold")



add_rules("mode.debug", "mode.release")

includes("engine/son")
includes("engine/rendus")
includes("engine/physique")
includes("engine/lscrupt")
includes("engine/multi")
includes("engine/ecs")
includes("engine/log")
set_policy("build.ccache", true)



target("moteur_jeur-alpharius")

    set_kind("binary")
    add_files("app/main.cpp")
    add_deps("ecs")
    add_deps("log")
    add_deps("son")
    add_deps("rendus")
    add_deps("physique")
    add_deps("lscrupt")
    add_deps("multi")

    
    
