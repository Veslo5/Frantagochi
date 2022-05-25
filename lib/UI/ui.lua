local ui = {}

ui.buttonFactory = require("lib.UI.button")

ui.container = {}

function ui:AddButton(name, x, y, width, height, text)
    self.container[name] = self.buttonFactory:New(x, y, width, height, text)
end

function ui:RemoveButton(name)
    self.container[name] = nil
end

function ui:Update(mx, my)
    for key, value in pairs(self.container) do
        value:Update(mx, my)
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
        value:Pressed()
    end
end

function ui:Mousereleased(x, y, button, istouch, presses)
    for key, value in pairs(self.container) do
        value:Released()
    end
end

return ui
