local AssetManager = {}

AssetManager.container = {}

--- Constructor
function AssetManager:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end

function AssetManager:Load(name, object)
    self.container[name] = object
end

function AssetManager:Get(name)
    return self.container[name]
end

function AssetManager:Unload()
    for index, value in pairs(self.container) do
        self.container[index] = nil
    end
end
return AssetManager