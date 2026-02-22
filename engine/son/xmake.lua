add_requires("openal-soft")
target("son")
    add_packages("openal-soft")
    set_kind("phony")
    set_languages("cxx20")
    
