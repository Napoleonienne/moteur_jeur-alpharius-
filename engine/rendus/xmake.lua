

add_rules("mode.debug", "mode.release")
add_requires("glm 1.0.3")
add_requires("spdlog 1.17.0")





add_defines("ROOT")
target("vulkan_test")
    set_kind("binary")

    

    add_defines("GLM_ENABLE_EXPERIMENTAL")
    -- Find and link Vulkan (required)
    add_packages("vulkansdk","spdlog")
    on_load(function (target)
        import("lib.detect.find_package")
        local vulkan = find_package("vulkansdk") or find_package("vulkan")
        if not vulkan then
            raise("Vulkan SDK not found! Please install LunarG Vulkan SDK and set VULKAN_SDK environment variable.")
        end
        if vulkan.includedirs then
            target:add("includedirs", vulkan.includedirs)
        end
        if vulkan.linkdirs then
            target:add("linkdirs", vulkan.linkdirs)
        end
        if vulkan.links then
            target:add("links", vulkan.links)
        end

        -- Find GLFW3 (optional)
        local glfw = find_package("glfw3") or find_package("glfw")
        if glfw then
            if glfw.includedirs then
                target:add("includedirs", glfw.includedirs)
            end
            if glfw.linkdirs then
                target:add("linkdirs", glfw.linkdirs)
            end
            if glfw.links then
                target:add("links", glfw.links)
            end
            target:add("defines", "USE_GLFW")
            print("GLFW3 found: YES")
        else
            print("GLFW3 found: NO (optional)")
        end
    end)
    add_packages("glm")

