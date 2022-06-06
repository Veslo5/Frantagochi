local Text = {}

Text.ControlBaseHelper = require("lib.UI.controlBaseHelper")

Text.Name = ""
Text.Text = ""
Text.X = 0
Text.Y = 0
Text.Width = 100
Text.Height = 30
Text.VerticalAlign = "top"
Text.HorizontalAlign = "left"
Text.Font = nil
Text.Z = 0
Text.Opacity = 1

Text.AnimationRepeat = true
Text.AnimationCompleted = true
Text.StartAnim = false
Text.InEnded = false
Text.InAnimations = {}
Text.OutAnimations = {}

--- Constructor
function Text:New(name, x, y, text, zIndex, font)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Name = name
    newInstance.X = x
    newInstance.Y = y
    newInstance.Text = text
    newInstance.Font = font
    newInstance.Width = newInstance.Font:getWidth(newInstance.Text)
    newInstance.Height = newInstance.Font:getHeight(newInstance.Text)
    newInstance.Z = zIndex or 0

    return newInstance
end

function Text:Align(verticalAlign, horizontalAlign, offsetX, offsetY)
    self.ControlBaseHelper._align(self, verticalAlign, horizontalAlign, offsetX, offsetY)

end

function Text:Update(mx, my, dt)
    if self.StartAnim then
        self.ControlBaseHelper._handleAnimationTween(self, dt)
    end
end

function Text:Draw()
    love.graphics.setColor(1, 1, 1, self.Opacity)
    love.graphics.print(self.Text, self.Font, self.X, self.Y)
    love.graphics.setColor(1, 1, 1, 1)
end

return Text
