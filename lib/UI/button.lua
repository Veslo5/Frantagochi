local Button = {}

Button.Text = ""
Button.X = 0
Button.Y = 0
Button.Width = 100
Button.Height = 30
Button.Image = nil
Button.Enabled = true
Button.IsHovered = false

Button.IsDown = false
Button.LastFrameDown = false

--- Constructor
function Button:New(x, y, width, height, text)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.X = x
    newInstance.Y = y
    newInstance.Width = width
    newInstance.Height = height
    newInstance.Text = text

    return newInstance
end

function Button:Enable()
    self.Enabled = true
end

function Button:Disable()
    self.Enabled = false
end

function Button:Draw()
    if (self.Enabled) then
        love.graphics.setColor(0.368, 0.368, 0.368, 0.8)
        love.graphics.rectangle("fill", self.X, self.Y, self.Width, self.Height)

        love.graphics.setColor(0.858, 0.435, 0, 1)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.X, self.Y, self.Width, self.Height)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(self.Text, self.X, self.Y)
    end
end

function Button:Update(mx, my)
    if (self.Enabled) then
        if mx >= self.X and mx <= self.X + self.Width then
            if my >= self.Y and my < self.Y + self.Height then
                self.IsHovered = true
                return
            end
        end
        self.IsHovered = false
    end
end

function Button:Pressed()
    if (self.IsHovered and self.Enabled) then
        if (self.LastFrameDown) then
            self.IsDown = true
        else
            self.IsDown = true
            self.LastFrameDown = true
        end
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