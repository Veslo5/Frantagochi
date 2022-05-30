local scenesFolder = "scenes"

-- Scene is Global object
Scene = {}
local mt =

setmetatable(Scene, { __index = function(t, k)
    if CurrentScene and type(CurrentScene[k]) == "function" then
        return CurrentScene[k]
    end
    return function() end
end })

function Scene.Load(name)
    if CurrentScene then

        local stats = love.graphics.getStats()
        print("before drawcalls: " .. stats.drawcalls)
        print("before canvasswitches: " .. stats.canvasswitches)
        print("before texturememory: " .. stats.texturememory)
        print("before images: " .. stats.images)
        print("before canvases: " .. stats.canvases)
        print("before fonts: " .. stats.fonts)

        Scene.unload()
    end
    local chunk = love.filesystem.load(scenesFolder .. "/" .. name .. ".lua")
    if not chunk then error("Attempt to load scene \"" .. name .. "\", but it was not found in \"" .. scenesFolder .. "\" folder.", 2) end
    CurrentScene = chunk()

    print("collected memory before gc:" .. collectgarbage("count"))
    collectgarbage("collect") -- collect all the garbage from unload
    print("collected memory after gc:" .. collectgarbage("count"))

    local stats = love.graphics.getStats()
    print("after drawcalls: " .. stats.drawcalls)
    print("after canvasswitches: " .. stats.canvasswitches)
    print("after texturememory: " .. stats.texturememory)
    print("after images: " .. stats.images)
    print("after canvases: " .. stats.canvases)
    print("after fonts: " .. stats.fonts)

    Scene.load()
end
