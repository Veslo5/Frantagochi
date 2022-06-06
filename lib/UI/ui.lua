local ui = {}

ui.tweenFactory = Global:require("lib.tween")

ui.buttonFactory = require("lib.UI.button")
ui.scrollTextFactory = require("lib.UI.scrollText")
ui.textFactory = require("lib.UI.text")
ui.windowFactory = require("lib.UI.window")

ui.container = {}
ui.font = nil

function ui:Load(fontPath)
    self.font = love.graphics.newFont(fontPath, 20)
end

function ui:AddText(name, x, y, text, zindex)
    local newText = self.textFactory:New(name, x, y, text, zindex, self.font)
    table.insert(self.container, newText)
    table.sort(self.container, function(val1, val2) return val1.Z < val2.Z end)
    return newText
end

function ui:AddButton(name, x, y, width, height, image, text, zindex)
    local newbutton = self.buttonFactory:New(name, x, y, width, height, text, zindex, image, self.font)
    table.insert(self.container, newbutton)
    table.sort(self.container, function(val1, val2) return val1.Z < val2.Z end)
    return newbutton
end

function ui:AddScrollText(name, x, y, width, height, image, zindex)
    local newScrollText = self.scrollTextFactory:New(name, x, y, width, height, zindex, image, self.font)
    table.insert(self.container, newScrollText)
    table.sort(self.container, function(val1, val2) return val1.Z < val2.Z end)
    return newScrollText
end

function ui:AddWindow(name, x, y, width, height, image, zindex)
    local newWindow = self.windowFactory:New(name, x, y, width, height, zindex, image)
    table.insert(self.container, newWindow)
    table.sort(self.container, function(val1, val2) return val1.Z < val2.Z end)
    return newWindow
end

function ui:NewText(name, x, y, text, zindex)
    return self.textFactory:New(name, x, y, text, zindex, self.font)
end

function ui:NewButton(name, x, y, width, height, image, text, zindex)
    return self.buttonFactory:New(name, x, y, width, height, text, zindex, image, self.font)
end

function ui:NewScrollText(name, x, y, width, height, image)
    return self.scrollTextFactory:New(name, x, y, width, height, image)
end

function ui:AddInAnimation(duration, control, target, easing)        
    local tween = ui.tweenFactory.new(duration, control, target, easing)
    table.insert(control.InAnimations, tween)
    return control
end

function ui:AddOutAnimation(duration, control, target, easing)
    local tween = ui.tweenFactory.new(duration, control, target, easing)
    table.insert(control.OutAnimations, tween)
    return control
end

function ui:StartAnimation(control)
    control.StartAnim = true
    return control
end

function ui:GetControl(name)
    for index, control in ipairs(self.container) do
        if control.Name == name then
            return control
        end
    end

    return nil
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
            value:Pressed(x,y,button,istouch, presses)
        end
    end
end

function ui:Mousereleased(x, y, button, istouch, presses)
    for key, value in pairs(self.container) do
        if (type(value.Released) == "function") then
            value:Released(x, y, button, istouch, presses)
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
