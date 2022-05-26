local ScrollText = {}
ScrollText.X = 0
ScrollText.Y = 0
ScrollText.Width = 500
ScrollText.Height = 30
ScrollText.Image = nil
ScrollText.Font = nil
ScrollText.Enabled = true

ScrollText.TextContainer = {}
ScrollText.CurrentText = ""
ScrollText.TextPosX = 0
ScrollText.TextWidth = 0

--- Constructor
function ScrollText:New(x, y, width, height, image, font)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.X = x
    newInstance.Y = y
    newInstance.Width = width
    newInstance.Height = height
    newInstance.Image = image
    newInstance.Font = font

    newInstance.TextPosX = newInstance.X + newInstance.Width

    table.insert(newInstance.TextContainer, "Víte že, z Frantova evoluce probíhala ve třech krocích? Franta->František->Frantarián.")
    table.insert(newInstance.TextContainer, "Dnes je super den na čvaňháka.")
    table.insert(newInstance.TextContainer, "Tak černě bych to zas neviděl - M. L. King.")
    table.insert(newInstance.TextContainer, "To jsou nervy tyvole.")
    table.insert(newInstance.TextContainer, "Dneska né.")

    newInstance.CurrentText = newInstance.TextContainer[love.math.random(1, #newInstance.TextContainer)]

    return newInstance
end

function ScrollText:Update(mx, my, dt)
    self.TextPosX = self.TextPosX - dt * 100
    if (self.TextPosX + self.TextWidth <= self.X) then
        self.TextPosX = self.X + self.Width
        self.CurrentText = self.TextContainer[love.math.random(1, #self.TextContainer)]
    end
end

function ScrollText:Draw()
    love.graphics.draw(self.Image, self.X, self.Y, nil, self.Width / self.Image:getWidth(), self.Height / self.Image:getHeight())

    local textHeight = self.Font:getHeight(self.CurrentText)
    self.TextWidth = self.Font:getWidth(self.CurrentText)

    --TODO: optimize - transform only when screen is resized
    local wx, wy = love.graphics.transformPoint(self.X, self.Y)
    local ww, wh = love.graphics.transformPoint(self.Width, self.Height)
    
    love.graphics.setScissor(wx, wy, ww, wh)
    love.graphics.print(self.CurrentText, self.Font, self.TextPosX, (self.Y + self.Height / 2) - textHeight / 2)
    love.graphics.setScissor()

end

return ScrollText
