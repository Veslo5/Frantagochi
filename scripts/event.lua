local Event = {}
Event.Animation = ""
Event.Description = ""
Event.Duration = 60
Event.Progress = 0
Event.InStarted = false
Event.InAnimation = nil

Event.OutStarted = false
Event.OutAnimation = nil

--- Constructor
function Event:New(object, description, duration, inAnimation, outAnimation, additionalWorldInteractions)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.WorldObject = object
    newInstance.Description = description
    newInstance.Duration = duration
    newInstance.InAnimation = inAnimation
    newInstance.OutAnimation = outAnimation
    newInstance.AdditionalWorldInteractions = additionalWorldInteractions
    
    return newInstance
end



return Event