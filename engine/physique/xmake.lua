add_requires("joltphysics")

target("physique")
    set_kind("phony")
    set_languages("cxx20")
    add_packages("joltphysics")
