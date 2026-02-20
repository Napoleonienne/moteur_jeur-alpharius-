add_requires("openal-soft")
target("son")
    add_packages("openal-soft")
    set_kind("phony")
    add_packages("openal-soft" )
    set_languages("cxx20")
    
