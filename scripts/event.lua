local Event = {}
Event.Animation = ""
Event.Description = ""
Event.Duration = 60
Event.Progress = 0

--- Constructor
function Event:New(animation, description, duration)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Animation = animation
    newInstance.Description = description
    newInstance.Duration = duration
    return newInstance
end



return Event