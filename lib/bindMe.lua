--- A dead simple input handling module by Vessyk
-- @module BindMe
local BindMe = {}

BindMe.actionHolder = {}
BindMe.pressedKeys = {}
BindMe.firstPressedKeys = {}

--- Bind action into system
-- @param actionName binded action name
function BindMe:Bind(actionName, ...)
    local args = { ... }
    if (self.actionHolder[actionName] == nil) then
        self.actionHolder[actionName] = args
    end
end

--- Check if action is down
-- @param actionName name of binded action
function BindMe:IsActionDown(actionName)
    -- if (self.actionHolder == nil) then
    --     return false
    -- end

    -- looping through current pressed keys and actions
    for actionKey, actionValue in pairs(self.actionHolder[actionName]) do
        for pressedKey, pressedKeyValue in pairs(self.pressedKeys) do
            if (actionValue == pressedKeyValue) then
                return true
            end
        end
    end

    return false
end

--- Check if action was pressed once
-- @param actionName name of binded action
function BindMe:IsActionPressed(actionName)
    -- if (self.actionHolder == nil) then
    --     return false
    -- end

    -- looping through current pressed keys and actions

    for actionKey, actionValue in pairs(self.actionHolder[actionName]) do
        for pressedKey, pressedKeyValue in pairs(self.firstPressedKeys) do
            if (actionValue == pressedKey) then
                -- just marking it as already checked
                if (pressedKeyValue == true) then
                    self.firstPressedKeys[pressedKey] = false
                    return true
                end
            end
        end
    end


    return false
end

--- Check if action is up
-- @param actionName name of binded action
function BindMe:IsActionUp(actionName)
    if (not self:IsActionDown(actionName)) then
        return true
    end
    return false
end

--- KeyPressed callback from LOVE
-- @param key
-- @param scancode
-- @param isrepeat
function BindMe:KeyPressed(key, scancode, isrepeat)
    self.pressedKeys[key] = key
    self.firstPressedKeys[key] = true
end

--- KeyRelease callback from LOVE
-- @param key
-- @param scancode
function BindMe:KeyRelease(key, scancode)
    self.pressedKeys[key] = nil
    self.firstPressedKeys[key] = nil
end

--- MousePressed callback from LOVE
-- @param x not used
-- @param y not used
-- @param button which button pressed
-- @param istouch
-- @param presses
function BindMe:MousePressed(x, y, button, istouch, presses)
    local mouseButton = "mouse" .. button
    self.pressedKeys[mouseButton] = mouseButton
    self.firstPressedKeys[mouseButton] = true    
end

--- MouseReleased callback from LOVE
-- @param x not used
-- @param y not used
-- @param button which button pressed
-- @param istouch
-- @param presses
function BindMe:MouseReleased(x, y, button, istouch, presses)
    local mouseButton = "mouse" .. button
    self.pressedKeys[mouseButton] = nil
    self.firstPressedKeys[mouseButton] = nil;
end

return BindMe
