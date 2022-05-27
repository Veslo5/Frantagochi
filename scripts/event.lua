local Event = {}
Event.Description = ""
Event.MaxProgress = 100
Event.CurrentProgress = 0

--- Constructor
function Event:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end



return Event