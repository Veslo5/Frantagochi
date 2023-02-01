local Slice = {}

Slice.texture = nil 
Slice.padding = nil

Slice.sourceQuads = {}

function Slice:New(texture, leftPadding, rightPadding, topPadding, bottomPadding)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.texture = texture
    newInstance.padding = {leftPadding = leftPadding, rightPadding = rightPadding, topPadding = topPadding, bottomPadding = bottomPadding}
    newInstance.sourceQuads = newInstance:_slice()
    return newInstance
end

function Slice:_slice(x,y,w,h)
    local x = x or 0
    local y = y or 0
    local w = w or self.texture:getWidth()
    local h = h or self.texture:getHeight()
    local middleWidth = w - self.padding.leftPadding - self.padding.rightPadding
    local middleHeight = h - self.padding.topPadding - self.padding.bottomPadding
    local bottomY = y + h - self.padding.bottomPadding
    local rightX = x + w - self.padding.rightPadding
    local leftX = x + self.padding.leftPadding
    local topY = y + self.padding.topPadding

    local quadTable = {}
    table.insert(quadTable, love.graphics.newQuad(x,      y,        self.padding.leftPadding,  self.padding.topPadding,    self.texture))
    table.insert(quadTable, love.graphics.newQuad(leftX,  y,        middleWidth,               self.padding.topPadding,    self.texture))
    table.insert(quadTable, love.graphics.newQuad(rightX, y,        self.padding.rightPadding, self.padding.topPadding,    self.texture))
    table.insert(quadTable, love.graphics.newQuad(x,      topY,     self.padding.leftPadding,  middleHeight,               self.texture))
    table.insert(quadTable, love.graphics.newQuad(leftX,  topY,     middleWidth,               middleHeight,               self.texture))
    table.insert(quadTable, love.graphics.newQuad(rightX, topY,     self.padding.rightPadding, middleHeight,               self.texture))
    table.insert(quadTable, love.graphics.newQuad(x,      bottomY,  self.padding.leftPadding,  self.padding.bottomPadding, self.texture))
    table.insert(quadTable, love.graphics.newQuad(leftX,  bottomY,  middleWidth,               self.padding.bottomPadding, self.texture))
    table.insert(quadTable, love.graphics.newQuad(rightX, bottomY,  self.padding.rightPadding, self.padding.bottomPadding, self.texture))

    return quadTable
end

function Slice:Draw(x,y,sx,sy)
    love.graphics.draw(self.texture, self.sourceQuads[2], x, y, 0, sx, sy)
    -- for index, value in ipairs(self.sourceQuads) do
    -- end
end


return Slice