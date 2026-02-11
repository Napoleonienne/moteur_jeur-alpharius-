add_requires("spdlog")

target("log")
    set_kind("static")
    set_languages("cxx20")
    add_files("src/log.cpp")
    add_includedirs("include", {public = true})
    add_packages("spdlog", {public = true})

target("log_test")
    set_kind("binary")
    set_languages("cxx20")
    add_files("src/main.cpp")
    add_deps("log")
