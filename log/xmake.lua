add_requires("spdlog")

target("log")
    set_kind("binary")
    set_languages("cxx20")
    add_files("src/*.cpp", "src/*.c")
    add_includedirs("include")
    add_packages("spdlog")
