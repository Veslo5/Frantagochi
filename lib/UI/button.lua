local Button = {}

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

Button.IsDown = false
Button.LastFrameDown = false

--- Constructor
function Button:New(x, y, width, height, text, image, font)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.X = x
    newInstance.Y = y
    newInstance.Width = width
    newInstance.Height = height
    newInstance.Text = text
    newInstance.Image = image
    newInstance.Font = font

    return newInstance
end

function Button:Enable()
    self.Enabled = true
end

function Button:Disable()
    self.Enabled = false
end

function Button:Align(verticalAlign, horizontalAlign, offsetX, offsetY)
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

function Button:Draw()
    if (self.Enabled) then
        -- love.graphics.setColor(0.368, 0.368, 0.368, 0.8)
        -- love.graphics.rectangle("fill", self.X, self.Y, self.Width, self.Height)

        -- love.graphics.setColor(0.858, 0.435, 0, 1)
        -- love.graphics.setLineWidth(3)
        -- love.graphics.rectangle("line", self.X, self.Y, self.Width, self.Height)

        love.graphics.draw(self.Image, self.X, self.Y, nil, self.Width / self.Image:getWidth(), self.Height / self.Image:getHeight())

        local texteWidth = self.Font:getWidth(self.Text)
        local texteHeight = self.Font:getHeight(self.Text)
        love.graphics.print(self.Text, self.Font, (self.X + self.Width / 2) - texteWidth / 2, (self.Y + self.Height / 2) - texteHeight / 2)
    end
end

function Button:Update(mx, my)
    if (self.Enabled) then

        if (self.LastFrameDown == false and self.IsDown) then
            self.IsDown = false
            self.LastFrameDown = true
        end

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
