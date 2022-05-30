local Player = {}

Player.datelib = Global:require("lib.date")
Player.json = Global:require("lib.json")
Player.timerFactory = Global:require("lib.timer")
Player.eventFactory = require("scripts.event")
Player.timer = nil

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
    newInstance.timer = self.timerFactory:New()

    return newInstance
end

function Player:AddEvent(event)
    table.insert(self.Data.EventQueue, event)
end

function Player:AddProgressStat(name, stat)
    self.Data.ProgressStats[name] = stat
end

function Player:Update(dt)
    self.timer:Update(dt)
end

function Player:Load()
    local info = love.filesystem.getInfo("data.json", "file")
    info = false -- dev mode :)
    if (info) then
        --loading
    else
        -- first start
        self:AddEvent(self.eventFactory:New("idle_programming", "Event 1", 30))
        self:AddEvent(self.eventFactory:New("idle_programming", "Event 2", 30))
        self:AddEvent(self.eventFactory:New("idle_programming", "Event 3", 30))
        self:AddEvent(self.eventFactory:New("idle_programming", "Event 4", 30))
        self:AddEvent(self.eventFactory:New("idle_programming", "Event 5", 30))

    end


    self.date = self.datelib(false)
    self.Data.LatestSave = self.date:fmt("${iso}")
    self.timer:Every("eventChecker", math.huge, 1, self.CheckEvents, self)

end

function Player:CheckEvents()

    CurrentScene.ui:GetControl("Event1").Text = self.Data.EventQueue[1].Description .. " Progress: " .. tostring(self.Data.EventQueue[1].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[1].Duration) 
    CurrentScene.ui:GetControl("Event2").Text = self.Data.EventQueue[2].Description .. " Progress: " .. tostring(self.Data.EventQueue[2].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[2].Duration)
    CurrentScene.ui:GetControl("Event3").Text = self.Data.EventQueue[3].Description .. " Progress: " .. tostring(self.Data.EventQueue[3].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[3].Duration)
    CurrentScene.ui:GetControl("Event4").Text = self.Data.EventQueue[4].Description .. " Progress: " .. tostring(self.Data.EventQueue[4].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[4].Duration)
    CurrentScene.ui:GetControl("Event5").Text = self.Data.EventQueue[5].Description .. " Progress: " .. tostring(self.Data.EventQueue[5].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[5].Duration)

    self.Data.EventQueue[1].Progress = self.Data.EventQueue[1].Progress + 1
end

function Player:Save()
    local success, message = love.filesystem.write("data.json", self.json.encode(self.Data))

end

return Player
