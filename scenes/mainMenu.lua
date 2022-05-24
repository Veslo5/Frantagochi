local mainMenu = {}

mainMenu.input = Global:require("lib.bindMe")
mainMenu.camera = Global:require("lib.camera")
mainMenu.button = Global:require("lib.UI.button")
mainMenu.isoGrid = Global:require("lib.isoGrid")
mainMenu.touch = Global:require("lib.touch")


function mainMenu.load()
    mainMenu:bindKeys()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    mainMenu.gameplayCamera = Global:AddGlobal("GAMEPLAY_CAMERA", mainMenu.camera:New(1366, 768))
    mainMenu.uiCamera = Global:AddGlobal("MENU_CAMERA", mainMenu.camera:New(800, 600))
    mainMenu.exitButton = Global:AddGlobal("EXIT_BUTTON", mainMenu.button:New(0, 0, 100, 30, "Test"))
    mainMenu.roomGrid = mainMenu.isoGrid:New()

    mainMenu.gameplayCamera:SetPosition(0, 0, true)

    mainMenu.map = love.graphics.newImage("resources/maps/Frant.png")
    mainMenu.mapg = love.graphics.newImage("resources/maps/ground.png")
    mainMenu.franta = love.graphics.newImage("resources/maps/franta.png")
end

function mainMenu.update(dt)

    mainMenu.touch:Update()

    local touchPosX, touchPosY = mainMenu.touch:GetCurrentPos()    
    mainMenu.gameplayCamera:SetPosition(mainMenu.gameplayCamera.X + touchPosX / 10, mainMenu.gameplayCamera.Y + touchPosY / 10, true)

    if (mainMenu.input:IsActionPressed("EXIT")) then
        love.event.quit()
    end


    if (mainMenu.input:IsActionDown("ZOOMIN")) then
        mainMenu.gameplayCamera:SetZoom(mainMenu.gameplayCamera.Zoom + dt, true)
    end

    if (mainMenu.input:IsActionDown("ZOOMOUT")) then
        mainMenu.gameplayCamera:SetZoom(mainMenu.gameplayCamera.Zoom - dt, true)
    end

    if (mainMenu.input:IsActionPressed("RESET")) then
        mainMenu.gameplayCamera:SetPosition(0, 0, true)
    end
end

function mainMenu.draw()
    local mouseX, mouseY = love.mouse.getPosition()


    love.graphics.setBackgroundColor(0, 0, 0, 1)


    mainMenu.gameplayCamera:BeginDraw()
    -- Gameplay rendering


    local localPosX, localPosY = mainMenu.roomGrid:TileWorldPosition(3,3)
    love.graphics.draw(mainMenu.map, 0, 0)
  --  love.graphics.draw(mainMenu.mapg, localPosX, localPosY)
    love.graphics.draw(mainMenu.franta, localPosX, localPosY)


    love.graphics.rectangle("fill", 0, 0, 5, 5)

    mainMenu.gameplayCamera.EndDraw()

    mainMenu.uiCamera:BeginDraw()
    -- UI rendering
    -- mainMenu.exitButton:Draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(mouseX, 0, 0)
    love.graphics.print(mouseY, 0, 10)

    mainMenu.uiCamera:EndDraw()

end

function mainMenu:bindKeys()
    -- adding these actions to global table
    local left_action = Global:AddGlobal("LEFT_ACTION", "LEFT")
    local down_action = Global:AddGlobal("DOWN_ACTION", "DOWN")
    local right_action = Global:AddGlobal("RIGHT_ACTION", "RIGHT")
    local up_action = Global:AddGlobal("UP_ACTION", "UP")


    self.input:Bind(up_action, "w", "up")
    self.input:Bind(down_action, "s", "down")
    self.input:Bind(left_action, "a", "left")
    self.input:Bind(right_action, "d", "right")

    self.input:Bind("EXIT", "escape")
    self.input:Bind("ZOOMIN", "q")
    self.input:Bind("ZOOMOUT", "e")
    self.input:Bind("RESET", "r")
end

--#####CALLBACKS######
function mainMenu.keypressed(key, scancode, isrepeat)
    mainMenu.input:KeyPressed(key, scancode, isrepeat)
end

function mainMenu.keyreleased(key, scancode)
    mainMenu.input:KeyRelease(key, scancode)
end

function mainMenu.mousepressed(x, y, button, istouch, presses)
    mainMenu.input:MousePressed(x, y, button, istouch, presses)
    mainMenu.touch:Start()    
end

function mainMenu.mousereleased(x, y, button, istouch, presses)
    mainMenu.input:MouseReleased(x, y, button, istouch, presses)
    mainMenu.touch:End()
end

function mainMenu.resize(x, y)
    mainMenu.gameplayCamera:Resize()
    mainMenu.uiCamera:Resize()
end

function mainMenu.unload()

end

return mainMenu
