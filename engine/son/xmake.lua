set_languages("c23", "cxx26")

add_requires("openal-soft")
add_requires("libsndfile")
target("son")
    add_packages("openal-soft")
    add_files("src/chargement.cpp")
    add_includedirs("inc")
    set_kind("phony")
    add_packages("libsndfile")
    add_packages("openal-soft" )
    

    set_languages("cxx20")
    
