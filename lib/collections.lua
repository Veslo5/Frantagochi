local collections = {}
collections.container = {}


--- Constructor
function collections:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end

function collections:Add(name, object)
    self.container[name] = object
end

function collections:Get(name)
    return self.container[name]
end

function collections:Clear()
    for index, value in pairs(self.container) do
        self.container[index] = nil
    end
end

return collections
