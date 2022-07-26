local World = {}

World.tweenFactory = Global:require("lib.tween")
World.json = Global:require("lib.json")

World.sprite = require("lib.sprite")
World.playerFactory = require("scripts.player")

World.objects = {}


--- Constructor
function World:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end

function World:Load()

    local worldJSON = love.filesystem.read("data/world.json")
    local worldData = self.json.decode(worldJSON)

    for index, value in ipairs(worldData.World) do
        local obj = self:AddObject(value.Name, CurrentScene.assetList:Get(value.Asset), value.ZIndex)

        if value.Animation ~= nil then
            obj:Animate(value.Animation.GridWidth, value.Animation.GridHeight, value.Animation.Speed,
                value.Animation.Frames, value.Animation.Row)
        end

        if value.GridPosition ~= nil then
            obj:SetGridPosition(value.GridPosition.GridPositionX, value.GridPosition.GridPositionY,
                value.GridPosition.HeightTileOffset, value.GridPosition.WorldPosXOffset,
                value.GridPosition.WorldPosYOffset)
        else
            obj:SetPosition(value.WorldPositionX, value.WorldPositionY)
        end

        obj:SetVisibility(value.Visible)
    end


    self.player = self.playerFactory:New()
    self.player:Load()
end

function World:AddObject(name, image, zindex)
    table.insert(self.objects, self.sprite:New(image, zindex, name))
    local item = self.objects[#self.objects]
    table.sort(self.objects, function(val1, val2) return val1.Z < val2.Z end)

    return item
end

function World:GetObject(name)
    for index, value in ipairs(self.objects) do
        if value.Name == name then
            return value
        end
    end
end

function World:AddTween(object, duration, target, easing)    
    local control = self:_resolveObjectParameter(object)

    local tween = World.tweenFactory.new(duration, control, target, easing)
    control.Tween = tween
    return control
end

function World:StartTween(object)
    local control = self:_resolveObjectParameter(object)
    control.StartTween = true
end

function World:StopTween(object)
    local control = self:_resolveObjectParameter(object)
    control.StartTween = false
end

function World:Update(dt)
    for key, value in ipairs(self.objects) do
        value:Update(dt)
    end
    self.player:Update(dt)
end

function World:Draw()
    for key, value in ipairs(self.objects) do        
        value:Draw()
    end
end

function World:Remove(name)

    local indexToRemove = nil
    for index, value in ipairs(self.objects) do
        if value.Name == name then
            indexToRemove = index
        end
    end
    
    table.remove(self.objects, indexToRemove)
end

function World:Unload()
    for i = 1, #self.objects, 1 do
        self.objects[i] = nil
    end
end

function World:_resolveObjectParameter(object)
    local control = nil
    if type(object) == "string" then
        control = self:GetObject(object)
    else
        control = object

    end
    return control
end

return World
