local Event = {}
Event.Animation = ""
Event.Description = ""
Event.Duration = 60
Event.Progress = 0
Event.InAnimation = nil
Event.OutAnimation = nil

--- Constructor
function Event:New(animation, description, duration, inAnimation, outAnimation, additionalWorldInteractions)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Animation = animation
    newInstance.Description = description
    newInstance.Duration = duration
    newInstance.InAnimation = inAnimation
    newInstance.OutAnimation = outAnimation
    newInstance.AdditionalWorldInteractions = additionalWorldInteractions
    
    return newInstance
end



return Event