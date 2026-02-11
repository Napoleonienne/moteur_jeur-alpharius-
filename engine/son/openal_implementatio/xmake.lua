target("son_openal")
    set_kind("binary")
    set_languages("cxx20")
    add_files("src/*.cpp", "src/*.c")

    -- OpenAL
    includes("openal1")
