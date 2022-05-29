local ui = {}

ui.buttonFactory = require("lib.UI.button")
ui.scrollTextFactory = require("lib.UI.scrollText")
ui.textFactory = require("lib.UI.text")
ui.windowFactory = require("lib.UI.window")

ui.container = {}
ui.font = nil

function ui:Load(fontPath)
    self.font = love.graphics.newFont(fontPath, 20)
end

function ui:AddText(name, x, y, text)
    self.container[name] = self.textFactory:New(x, y, text, self.font)
    return self.container[name]
end

function ui:AddButton(name, x, y, width, height, image, text)
    self.container[name] = self.buttonFactory:New(x, y, width, height, text, image, self.font)
    return self.container[name]
end

function ui:AddScrollText(name, x, y, width, height, image)
    self.container[name] = self.scrollTextFactory:New(x, y, width, height, image, self.font)
    return self.container[name]
end

function ui:AddWindow(name, x, y, width, height, image)
    self.container[name] = self.windowFactory:New(x, y, width, height, image)
    return self.container[name]
end

function ui:GetControl(name)
    return self.container[name]
end

function ui:Remove(name)
    self.container[name] = nil
end

function ui:Update(mx, my, dt)
    for key, value in pairs(self.container) do
        if (type(value.Update) == "function") then
        value:Update(mx, my, dt)
        end
    end
end

function ui:IsDown(name)
    return self.container[name].IsDown
end

function ui:Draw()
    for key, value in pairs(self.container) do
        value:Draw()
    end
end

function ui:Mousepressed(x, y, button, istouch, presses)
    for key, value in pairs(self.container) do
        if (type(value.Pressed) == "function") then
            value:Pressed()
        end
    end
end

function ui:Mousereleased(x, y, button, istouch, presses)
    for key, value in pairs(self.container) do
        if (type(value.Released) == "function") then
            value:Released()
        end
    end
end

function ui:Resize(width, heigth)
    for key, value in pairs(self.container) do
        if (type(value.Resize) == "function") then
            value:Resize(width, heigth)
        end
    end
end

return ui
