local Player = {}

Player.datelib = Global:require("lib.date")
Player.json = Global:require("lib.json")



Player.Data = {
    EventQueue = {},
    ProgressStats = {},
    CurrentAnimation = "",

    LatestSave = nil,
}

--- Constructor
function Player:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end

function Player:AddEvent(event)
    table.insert(self.Data.EventQueue,event)
end

function Player:AddProgressStat(name, stat)
    self.Data.ProgressStats[name] = stat
end

function Player:Load()
    self.date = self.datelib(false)
    self.Data.LatestSave = self.date:fmt("${iso}")
end

function Player:Save()
local success, message = love.filesystem.write( "data.json", self.json.encode(self.Data))
    
end

return Player
