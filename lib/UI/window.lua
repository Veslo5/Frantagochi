local Window = {}

Window.ControlBaseHelper = require("lib.UI.controlBaseHelper")

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

function Window:GetControl(name)
    return self.Controls[name]
end

function Window:SetPosition(x, y)
    self.X = x
    self.Y = y

    for key, control in pairs(self.Controls) do
        control.X = self.X + control.X
        control.Y = self.Y + control.Y
    end

end

function Window:IsDown(name)
    return self.Controls[name].IsDown
end

function Window:Align(verticalAlign, horizontalAlign, offsetX, offsetY)
    self.ControlBaseHelper._align(self, verticalAlign, horizontalAlign, offsetX, offsetY)
end

function Window:Update(mx, my, dt)
    for key, value in pairs(self.Controls) do        
        value:Update(mx, my, dt)
    end

    if self.StartAnim then
        self.ControlBaseHelper._handleAnimationTween(self, dt)
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

function Window:Pressed(x, y, button, istouch, presses)
    for key, value in pairs(self.Controls) do
        if (type(value.Pressed) == "function") then
            value:Pressed(x, y, button, istouch, presses)
        end
    end
end

function Window:Released(x, y, button, istouch, presses)
    for key, value in pairs(self.Controls) do
        if (type(value.Released) == "function") then
            value:Released(x, y, button, istouch, presses)
        end
    end
end

return Window
