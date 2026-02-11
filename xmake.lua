set_project("moteur_jeur-alpharius")
set_version("0.1.0")
set_languages("c17", "cxx20")

set_toolchains("clang")
add_cxflags("-flto=thin")
add_ldflags("-flto=thin", "-fuse-ld=mold")

add_rules("mode.debug", "mode.release")

includes("engine/son")
includes("log")

target("moteur_jeur-alpharius")
    set_kind("binary")
    add_files("app/main.cpp")
    add_includedirs("include")
