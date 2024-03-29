local Sprite = {}
Sprite.Name = ""
Sprite.X = 0
Sprite.Y = 0
Sprite.Image = nil
Sprite.Static = true
Sprite.AnimGrid = nil
Sprite.Animation = nil
Sprite.Z = 0
Sprite.Visible = true

Sprite.TweenEnded = false
Sprite.Tween = nil
Sprite.StartTween = false


--- Constructor
function Sprite:New(image, zindex, name)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Image = image
    newInstance.Z = zindex
    newInstance.Name = name or ""

    return newInstance
end

function Sprite:SetGridPosition(x, y, heightTileOffset, worldPosOffsetX, worldPosOffsetY)
    -- TODO: roomGrid should not be referenced from core code!!
    local worldPosX, worldPosY = CurrentScene.roomGrid:TileWorldPosition(x, y, heightTileOffset)
    worldPosX = worldPosX + (worldPosOffsetX or 0)
    worldPosY = worldPosY + (worldPosOffsetY or 0)

    self:SetPosition(worldPosX, worldPosY)
    return self
end

function Sprite:SetPosition(x, y)
    self.X = x
    self.Y = y
    return self
end

function Sprite:SetVisibility(visible)
    self.Visible = visible
    return self
end

function Sprite:Animate(gridWidth, gridHeight, animSpeed, frames, row)
    local animation = Global:GetGlobal("lib.anim8")
    self.AnimGrid = animation.newGrid(gridWidth, gridHeight, self.Image:getWidth(), self.Image:getHeight())
    self.Animation = animation.newAnimation(self.AnimGrid(frames, row), animSpeed)
    self.Static = false
    return self
end

function Sprite:Update(dt)
    if self.Static == false and self.Visible == true then
        self.Animation:update(dt)
    end

    if self.StartTween == true then
        self.TweenEnded = self.Tween:update(dt)
    end

end

function Sprite:Draw()
    if self.Visible == true then
        if self.Static == false then
            --love.graphics.rectangle("line", self.X, self.Y, self.Image:getWidth(), self.Image:getHeight())
            self.Animation:draw(self.Image, self.X, self.Y)
        else
            --love.graphics.rectangle("line", self.X, self.Y, self.Image:getWidth(), self.Image:getHeight())
            love.graphics.draw(self.Image, self.X, self.Y)
        end
    end
end

return Sprite
