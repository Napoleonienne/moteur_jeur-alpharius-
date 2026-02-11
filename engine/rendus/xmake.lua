add_requires("imgui")

target("rendus")
    set_kind("phony")
    set_languages("cxx20")
    add_packages("imgui")

    includes("vulkan")
