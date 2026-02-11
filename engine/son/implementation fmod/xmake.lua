target("son_impl_fmod")
    set_kind("binary")
    set_languages("cxx20")
    add_files("src/*.cpp", "src/*.c")

    -- FMOD
    local fmod_root = path.join(os.scriptdir(), "fmodstudioapi20309linux")
    local fmod_core = path.join(fmod_root, "api/core")
    add_includedirs(path.join(fmod_core, "inc"))
    add_includedirs("include")
    add_linkdirs(path.join(fmod_core, "lib/x86_64"))
    add_links("fmod")
