local Player = {}

Player.datelib = Global:require("lib.date")
Player.json = Global:require("lib.json")
Player.timerFactory = Global:require("lib.timer")
Player.eventFactory = require("scripts.event")
Player.timer = nil
Player.loadedEvents = nil

Player.Data = {
    EventQueue = {},
    ProgressStats = {},    

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
        self:LoadEvents()

    end
    
    self.timer:Every("eventChecker", math.huge, 1, self.CheckEvents, self)

end

function Player:LoadEvents()
    local eventJson = love.filesystem.read("data/events.json")
    self.loadedEvents = self.json.decode(eventJson)

    for i = 1, 5, 1 do        
        self:AddEvent(self:GenerateEvent())
    end

end

function Player:GenerateEvent()
    local currentEventIndex = love.math.random(1, #self.loadedEvents.Events)    
    local currentEvent = self.loadedEvents.Events[currentEventIndex]
    return self.eventFactory:New(currentEvent.Animation, currentEvent.Description, currentEvent.Duration)
end

function Player:CheckEvents()


    if self.Data.EventQueue[1] then
        CurrentScene.ui:GetControl("Event1").Text = self.Data.EventQueue[1].Description .. " Progress: " .. tostring(self.Data.EventQueue[1].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[1].Duration)
    end
    if self.Data.EventQueue[2] then
        CurrentScene.ui:GetControl("Event2").Text = self.Data.EventQueue[2].Description .. " Progress: " .. tostring(self.Data.EventQueue[2].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[2].Duration)
    end
    if self.Data.EventQueue[3] then
        CurrentScene.ui:GetControl("Event3").Text = self.Data.EventQueue[3].Description .. " Progress: " .. tostring(self.Data.EventQueue[3].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[3].Duration)
    end
    if self.Data.EventQueue[4] then
        CurrentScene.ui:GetControl("Event4").Text = self.Data.EventQueue[4].Description .. " Progress: " .. tostring(self.Data.EventQueue[4].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[4].Duration)
    end
    if self.Data.EventQueue[5] then
        CurrentScene.ui:GetControl("Event5").Text = self.Data.EventQueue[5].Description .. " Progress: " .. tostring(self.Data.EventQueue[5].Progress) .. " Duration: " .. tostring(self.Data.EventQueue[5].Duration)
    end

    if (self.Data.EventQueue[1].Progress >= self.Data.EventQueue[1].Duration) then
        CurrentScene.roomWorld:GetSprite(self.Data.EventQueue[1].Animation):SetVisibility(false)        
        table.remove(self.Data.EventQueue, 1)                
        self:AddEvent(self:GenerateEvent())
        CurrentScene.roomWorld:GetSprite(self.Data.EventQueue[1].Animation):SetVisibility(true)        
    else
        self.Data.EventQueue[1].Progress = self.Data.EventQueue[1].Progress + 1
    end

end

function Player:Save()
    self.date = self.datelib(false)
    self.Data.LatestSave = self.date:fmt("${iso}")
    local success, message = love.filesystem.write("data.json", self.json.encode(self.Data))

end

return Player
