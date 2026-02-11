target("son_impl_openal")
    set_kind("binary")
    set_languages("cxx20")
    add_files("src/*.cpp", "src/*.c")

    -- OpenAL
    includes("openal1")

    -- FMOD
    local fmod_root = path.join(os.scriptdir(), "fmodstudioapi20309linux")
    local fmod_core = path.join(fmod_root, "api/core")
    add_includedirs(path.join(fmod_core, "inc"))
    add_includedirs("include")
    add_linkdirs(path.join(fmod_core, "lib"))
    add_links("fmod", "fmodL")
