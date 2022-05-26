local Text = {}

Text.Text = ""
Text.X = 0
Text.Y = 0
Text.Width = 100
Text.Height = 30
Text.VerticalAlign = "top"
Text.HorizontalAlign = "left"
Text.Font = nil

--- Constructor
function Text:New(x, y, text, font)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.X = x
    newInstance.Y = y
    newInstance.Text = text    
    newInstance.Font = font
    newInstance.Width = newInstance.Font:getWidth(newInstance.Text)
    newInstance.Height = newInstance.Font:getHeight(newInstance.Text)

    return newInstance
end

function Text:Align(verticalAlign, horizontalAlign, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0

    local screenWidth, screenHeight = love.graphics.getDimensions()
    if verticalAlign ~= nil then
        if (verticalAlign == "top") then
            self.Y = 0 + offsetY
        elseif (verticalAlign == "center") then
            self.Y = (screenHeight / 2) - (self.Height / 2) + offsetY
        elseif (verticalAlign == "bottom") then
            self.Y = screenHeight - self.Height + offsetY
        end
    end

    if verticalAlign ~= nil then
        if (horizontalAlign == "left") then
            self.X = 0 + offsetX
        elseif (horizontalAlign == "center") then
            self.X = (screenWidth / 2) - (self.Width / 2) + offsetX
        elseif (horizontalAlign == "right") then
            self.X = screenWidth - self.Width + offsetX
        end
    end

end

function Text:Draw()    
        love.graphics.print(self.Text, self.Font, self.X, self.Y)    
end

return Text
