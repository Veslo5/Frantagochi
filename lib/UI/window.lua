local Window = {}

Window.Name = ""
Window.X = 0
Window.Y = 0
Window.Width = 100
Window.Height = 30
Window.Image = nil
Window.Z = 0
Window.Opacity = 1
Window.Controls = {}

Window.AnimationCompleted = true
Window.StartAnim = false
Window.InEnded = false
Window.InAnimations = {}
Window.OutAnimations = {}

--- Constructor
function Window:New(name, x, y, width, height, zindex, background)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Name = name
    newInstance.X = x
    newInstance.Y = y
    newInstance.Width = width
    newInstance.Height = height
    newInstance.Image = background
    newInstance.Z = zindex or 0

    return newInstance
end

function Window:AddControl(name, control)
    self.Controls[name] = control

    control.X = self.X + control.X
    control.Y = self.Y + control.Y
end

function Window:SetPosition(x, y)
    self.X = x
    self.Y = y

    for key, control in pairs(self.Controls) do
        control.X = self.X + control.X
        control.Y = self.Y + control.Y
    end

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


function Window:Update(mx,my, dt)
    if self.StartAnim then
        self:_handleAnimationTween(dt)
    end
end


function Window:Draw()
    love.graphics.setColor(1, 1, 1, self.Opacity)
    love.graphics.rectangle("line", self.X, self.Y, self.Width, self.Height)
    love.graphics.draw(self.Image, self.X, self.Y, nil, self.Width / self.Image:getWidth(), self.Height / self.Image:getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    for key, value in pairs(self.Controls) do
        value:Draw()
    end

end

function Window:_handleAnimationTween(dt)

    if self.InEnded == false then
        for index, value in ipairs(self.InAnimations) do
            self.AnimationCompleted = value:update(dt)
        end

        if self.AnimationCompleted == true then
            self.InEnded = true
            self.AnimationCompleted = false
        end

    else
        for index, value in ipairs(self.OutAnimations) do
            self.AnimationCompleted = value:update(dt)
        end

        if self.AnimationCompleted == true then
            self.StartAnim = false
            self.AnimationCompleted = false
        end
    end
end

return Window
