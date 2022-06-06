local Button = {}

Button.ControlBaseHelper = require("lib.UI.controlBaseHelper")

Button.Name = ""
Button.Text = ""
Button.X = 0
Button.Y = 0
Button.Width = 100
Button.Height = 30
Button.VerticalAlign = "top"
Button.HorizontalAlign = "left"
Button.Image = nil
Button.Font = nil
Button.Enabled = true
Button.IsHovered = false;
Button.Z = 0
Button.Opacity = 1

Button.AnimationRepeat = true
Button.AnimationCompleted = true
Button.StartAnim = false
Button.InEnded = false
Button.InAnimations = {}
Button.OutAnimations = {}

Button.IsDown = false
Button.LastFrameDown = false

--- Constructor
function Button:New(name, x, y, width, height, text, zIndex, image, font)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.Name = name
    newInstance.X = x
    newInstance.Y = y
    newInstance.Width = width
    newInstance.Height = height
    newInstance.Text = text
    newInstance.Image = image
    newInstance.Font = font
    newInstance.Z = zIndex or 0

    return newInstance
end

function Button:Enable()
    self.Enabled = true
end

function Button:Disable()
    self.Enabled = false
end

function Button:Align(verticalAlign, horizontalAlign, offsetX, offsetY)
    self.ControlBaseHelper._align(self, verticalAlign, horizontalAlign, offsetX, offsetY)
    return self
end

function Button:Update(mx, my, dt)
    if (self.Enabled) then
        self.ControlBaseHelper._handleMouseCoords(self, mx, my)
    end

    if self.StartAnim then
        self.ControlBaseHelper._handleAnimationTween(self, dt)
    end

end

function Button:Draw()
    if (self.Enabled) then
        -- love.graphics.setColor(0.368, 0.368, 0.368, 0.8)
        -- love.graphics.rectangle("fill", self.X, self.Y, self.Width, self.Height)

        -- love.graphics.setColor(0.858, 0.435, 0, 1)
        -- love.graphics.setLineWidth(3)
        -- love.graphics.rectangle("line", self.X, self.Y, self.Width, self.Height)

        love.graphics.setColor(1, 1, 1, self.Opacity)
        love.graphics.draw(self.Image, self.X, self.Y, nil, self.Width / self.Image:getWidth(), self.Height / self.Image:getHeight())

        local texteWidth = self.Font:getWidth(self.Text)
        local texteHeight = self.Font:getHeight(self.Text)
        love.graphics.print(self.Text, self.Font, (self.X + self.Width / 2) - texteWidth / 2, (self.Y + self.Height / 2) - texteHeight / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Button:Pressed()        
    if (self.IsHovered and self.Enabled) then
        self.IsDown = true
        self.LastFrameDown = false
    end
end

function Button:Released()
    self.IsDown = false
    self.LastFrameDown = false
end

function Button:_getCenter()
    return self.Width / 2, self.Height / 2
end

return Button
