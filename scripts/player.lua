local Player = {}

Player.datelib = Global:require("lib.date")
Player.json = Global:require("lib.json")
Player.timerFactory = Global:require("lib.timer")

Player.eventFactory = require("scripts.event")
Player.progressStatFactory = require("scripts.progressStat")

Player.timer = nil
Player.loadedEvents = nil

Player.currentAnimObject = nil

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
        self:LoadProgressStats()

    end

    self.timer:Every("eventChecker", math.huge, 1, self.CheckEvents, self)

end

function Player:LoadProgressStats()
    self:AddProgressStat("Hlad", self.progressStatFactory:New(100, 0, "Hlad"))
    self:AddProgressStat("Stres", self.progressStatFactory:New(100, 0, "Stres"))
    self:AddProgressStat("Hygiena", self.progressStatFactory:New(100, 0, "Hygiena"))
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
    return self.eventFactory:New(currentEvent.WorldObject, currentEvent.Description, currentEvent.Duration, currentEvent.InAnimation, currentEvent.OutAnimation, currentEvent.AdditionalWorldInteractions)
end

function Player:CheckEvents()

    local window = CurrentScene.ui:GetControl("TESTWIN")


    local stat1 = self.Data.ProgressStats["Hlad"]
    local stat2 = self.Data.ProgressStats["Stres"]
    local stat3 = self.Data.ProgressStats["Hygiena"]

    if stat1 then
        window:GetControl("Stat1").Text = stat1.Description .. " Current: " .. tostring(stat1.Current) .. " Max: " .. tostring(stat1.Maximum)
    end
    if stat2 then
        window:GetControl("Stat2").Text = stat2.Description .. " Current: " .. tostring(stat2.Current) .. " Max: " .. tostring(stat2.Maximum)
    end
    if stat3 then
        window:GetControl("Stat3").Text = stat3.Description .. " Current: " .. tostring(stat3.Current) .. " Max: " .. tostring(stat3.Maximum)
    end

    local event1 = self.Data.EventQueue[1]
    local event2 = self.Data.EventQueue[2]
    local event3 = self.Data.EventQueue[3]
    local event4 = self.Data.EventQueue[4]
    local event5 = self.Data.EventQueue[5]
    if event1 then
        CurrentScene.ui:GetControl("Event1").Text = event1.Description .. " Progress: " .. tostring(event1.Progress) .. " Duration: " .. tostring(event1.Duration)
    end
    if event2 then
        CurrentScene.ui:GetControl("Event2").Text = event2.Description .. " Progress: " .. tostring(event2.Progress) .. " Duration: " .. tostring(event2.Duration)
    end
    if event3 then
        CurrentScene.ui:GetControl("Event3").Text = event3.Description .. " Progress: " .. tostring(event3.Progress) .. " Duration: " .. tostring(event3.Duration)
    end
    if event4 then
        CurrentScene.ui:GetControl("Event4").Text = event4.Description .. " Progress: " .. tostring(event4.Progress) .. " Duration: " .. tostring(event4.Duration)
    end
    if event5 then
        CurrentScene.ui:GetControl("Event5").Text = event5.Description .. " Progress: " .. tostring(event5.Progress) .. " Duration: " .. tostring(event5.Duration)
    end

    if (event1.Progress >= event1.Duration) then

        if(event1.OutStarted == false) then
            event1.OutStarted = true

            local currentObj = CurrentScene.roomWorld:GetObject(event1.WorldObject):SetVisibility(false)            
            self.currentAnimObject = CurrentScene.roomWorld:AddObject(currentObj.Name .. "_EventOut", CurrentScene.assetList:Get(event1.OutAnimation.AnimationAsset), 999)

            if(event1.OutAnimation.UseStartingCurrentWorldPosition == true) then 
                self.currentAnimObject:SetPosition(currentObj.X, currentObj.Y)
            else
                self.currentAnimObject:SetGridPosition(event1.OutAnimation.StartingGridPosX, event1.OutAnimation.StartingGridPosY,
                event1.OutAnimation.HeightTileOffset, event1.OutAnimation.StratingGridXWorldOffset,
                event1.OutAnimation.StratingGridYWorldOffset)
            end
            
            if event1.OutAnimation.Animate then
                --TODO: create animation
            end

            CurrentScene.roomWorld:AddTween(self.currentAnimObject,event1.OutAnimation.Duration,event1.OutAnimation.ObjectProps, "linear")
            CurrentScene.roomWorld:StartTween(self.currentAnimObject)
        end

        if self.currentAnimObject.TweenEnded then
            
            CurrentScene.roomWorld:Remove(self.currentAnimObject.Name)
            self.currentAnimObject = nil

            table.remove(self.Data.EventQueue, 1)
            self:AddEvent(self:GenerateEvent())
            
            local newLatestEvent = self.Data.EventQueue[1]
            CurrentScene.roomWorld:GetObject(newLatestEvent.WorldObject):SetVisibility(true)
        end
    else
        event1.Progress = event1.Progress + 1
    end

end

function Player:Save()
    self.date = self.datelib(false)
    self.Data.LatestSave = self.date:fmt("${iso}")
    local success, message = love.filesystem.write("data.json", self.json.encode(self.Data))

end

return Player
