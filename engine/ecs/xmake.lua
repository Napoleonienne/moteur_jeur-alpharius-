add_requires("entt")

target("ecs")
    set_kind("static")
    set_languages("cxx20")
    add_files("src/*.cpp")
    add_packages("entt")
    add_includedirs("include", {public = true})
