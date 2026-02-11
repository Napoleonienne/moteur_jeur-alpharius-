target("son_fmod")
    set_kind("binary")
    set_languages("cxx20")
    add_files("src/*.cpp", "src/*.c")

    -- FMOD
    local fmod_root = path.join(os.scriptdir(), "fmodstudioapi20309linux")
    local fmod_core = path.join(fmod_root, "api/core")
    local fmod_studio = path.join(fmod_root, "api/studio")
    add_includedirs(path.join(fmod_core, "inc"), path.join(fmod_studio, "inc"))
    add_linkdirs(path.join(fmod_core, "lib"), path.join(fmod_studio, "lib"))
