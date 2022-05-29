local Window = {}


Window.X = 0
Window.Y = 0
Window.Width = 100
Window.Height = 30
Window.Image = nil
Window.Controls = {}

--- Constructor
function Window:New(x, y, width, height, background)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.X = x
    newInstance.Y = y
    newInstance.Width = width
    newInstance.Height = height
    self.Image = background

    return newInstance
end

function Window:AddControl(name, control)
    self.Controls[name] = control
end

function Window:Align(verticalAlign, horizontalAlign, offsetX, offsetY)
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

function Window:Draw()
    love.graphics.rectangle("line", self.X, self.Y, self.Width, self.Height)
    love.graphics.draw(self.Image, self.X, self.Y, nil, self.Width / self.Image:getWidth(), self.Height / self.Image:getHeight())

    for key, value in pairs(self.Controls) do
        value:Draw()
    end
end

return Window
