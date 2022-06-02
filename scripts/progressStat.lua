local ProgressStat = {}
ProgressStat.Maximum = 100
ProgressStat.Minimum = 0
ProgressStat.Current = 50
ProgressStat.Description = ""

--- Constructor
function ProgressStat:New(maximum, minimum, description)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Maximum = maximum
    newInstance.Minimum = minimum
    newInstance.Description = description
    return newInstance
end

function ProgressStat:Increase(amount)
    ProgressStat.Current = ProgressStat.Current + amount
end

function ProgressStat:Decrease(amount)
    ProgressStat.Current = ProgressStat.Current - amount
end

return ProgressStat