local World = {}

World.sprite = require("lib.sprite")
World.playerFactory = require("scripts.player")

World.sprites = {}


--- Constructor
function World:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end

function World:Load()
    self.player = self.playerFactory:New()
    self.player:Load()
    print(self.player.Data.LatestSave)
end

function World:AddSprite(name, image, zindex)
    table.insert(self.sprites, self.sprite:New(image, zindex, name))
    local item = self.sprites[#self.sprites]
    table.sort(self.sprites, function(val1, val2) return val1.Z < val2.Z end)

    return item
end

function World:Update(dt)
    for key, value in pairs(self.sprites) do
        value:Update(dt)
    end
end

function World:Draw()
    for key, value in pairs(self.sprites) do
        value:Draw()
    end
end

return World
