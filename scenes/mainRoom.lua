local mainRoom = {}

Global:require("lib.anim8")

mainRoom.input = Global:require("lib.bindMe")
mainRoom.isoGrid = Global:require("lib.isoGrid")
mainRoom.touch = Global:require("lib.touch")
mainRoom.ui = Global:require("lib.UI.ui")

mainRoom.assetManagerFactory = Global:require("lib.assetManager")
mainRoom.cameraFactory = Global:require("lib.camera")
mainRoom.worldFactory = Global:require("scripts.world")


function mainRoom.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    mainRoom.ui:Load("resources/fonts/Kaph-Regular.ttf")

    mainRoom.roomWorld = mainRoom.worldFactory:New()
    mainRoom.roomWorld:Load()

    mainRoom:bindKeys()
    mainRoom.assetList = mainRoom.assetManagerFactory:New()
    
    mainRoom.assetList:Load("map", love.graphics.newImage("resources/maps/Frant.png"))
    mainRoom.assetList:Load("mapg", love.graphics.newImage("resources/maps/ground.png"))
    mainRoom.assetList:Load("frantaAnim", love.graphics.newImage("resources/maps/Franta_write1.png"))
    mainRoom.assetList:Load("monitorAnim", love.graphics.newImage("resources/maps/monitor_write1.png"))
    mainRoom.assetList:Load("uiTest", love.graphics.newImage("resources/ui/UI-1.png"))
    
    mainRoom.roomGrid = mainRoom.isoGrid:New(mainRoom.assetList:Get("map"):getWidth(), mainRoom.assetList:Get("map"):getHeight(), 64, 32)
    
    mainRoom.ui:AddButton("Test", 0, 0, 80, 80, mainRoom.assetList:Get("uiTest"), "TEST"):Align("top", "right", -5, 100)
    mainRoom.ui:AddText("Text", 0, 0, "poiajyfajpifjsapjfpajfs"):Align("center", "left")
    mainRoom.ui:AddScrollText("TESTSCROLL", 200, 0, 1000, 40, mainRoom.assetList:Get("uiTest"))
    
    mainRoom:createCameras()

    local monitorPosX, monitorPosY = mainRoom.roomGrid:TileWorldPosition(10, 12)
    local frantaPosX, frantaPosY = mainRoom.roomGrid:TileWorldPosition(11, 13, 1)
    mainRoom.roomWorld:AddSprite("monitor_animated", mainRoom.assetList:Get("monitorAnim"), 2):Animate(64, 32, 0.4, "1-5", 1):SetPosition(monitorPosX + 20, monitorPosY)
    mainRoom.roomWorld:AddSprite("idle_programming", mainRoom.assetList:Get("frantaAnim"), 1):Animate(64, 64, 0.1, "1-4", 1):SetPosition(frantaPosX, frantaPosY)
    mainRoom.roomWorld:AddSprite("map_background", mainRoom.assetList:Get("map"), 0):SetPosition(0, 0);    


end

function mainRoom.update(dt)

    -- room and world update
    mainRoom.roomWorld:Update(dt)

    -- touch update
    mainRoom.touch:Update()
    local touchPosX, touchPosY = mainRoom.touch:GetCurrentPos()
    mainRoom.gameplayCamera:SetPosition(mainRoom.gameplayCamera.X + touchPosX / 10, mainRoom.gameplayCamera.Y + touchPosY / 10, true)

    -- keyboard handling
    mainRoom.handleInput(mainRoom, dt)

    -- ui update
    mainRoom.ui:Update(mainRoom.uiCamera.MouseWorldX, mainRoom.uiCamera.MouseWorldY, dt)

end

function mainRoom.draw()
    love.graphics.setBackgroundColor(0.047, 0.490, 0.913, 1)

    mainRoom.gameplayCamera:BeginDraw()
    -- Gameplay rendering

    mainRoom.roomWorld:Draw()

    mainRoom.gameplayCamera.EndDraw()

    local mouseX, mouseY = love.mouse.getPosition()

    mainRoom.uiCamera:BeginDraw()
    -- UI rendering
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(mouseX, 0, 0)
    love.graphics.print(mouseY, 0, 10)

    love.graphics.print("G-Camera", 0, 20)

    love.graphics.print(mainRoom.gameplayCamera.MouseWorldX, 0, 30)
    love.graphics.print(mainRoom.gameplayCamera.MouseWorldY, 0, 40)

    love.graphics.print("UI-Camera", 0, 50)

    love.graphics.print(mainRoom.uiCamera.MouseWorldX, 0, 60)
    love.graphics.print(mainRoom.uiCamera.MouseWorldY, 0, 70)

    mainRoom.ui:Draw()
    mainRoom.uiCamera:EndDraw()

end

function mainRoom:createCameras()
    mainRoom.gameplayCamera = Global:AddGlobal("GAMEPLAY_CAMERA", mainRoom.cameraFactory:New())
    mainRoom.uiCamera = Global:AddGlobal("MENU_CAMERA", mainRoom.cameraFactory:New(100, "Fill", 1366, 768))

    mainRoom.gameplayCamera:SetPosition(mainRoom.assetList:Get("map"):getWidth() / 2, mainRoom.assetList:Get("map"):getHeight() / 2, true)
end

function mainRoom:handleInput(dt)
    if (mainRoom.ui:IsDown("Test")) then
        Scene.Load("exampleRoom");
    end

    if (mainRoom.input:IsActionPressed("EXIT")) then
        love.event.quit()
    end

    if (mainRoom.input:IsActionDown("ZOOMIN")) then
        mainRoom.gameplayCamera:SetZoom(mainRoom.gameplayCamera.Zoom + dt, true)
    end

    if (mainRoom.input:IsActionDown("ZOOMOUT")) then
        mainRoom.gameplayCamera:SetZoom(mainRoom.gameplayCamera.Zoom - dt, true)
    end

    if (mainRoom.input:IsActionPressed("RESET")) then
        mainRoom.gameplayCamera:SetPosition(0, 0, true)
    end
end

function mainRoom:bindKeys()
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
function mainRoom.keypressed(key, scancode, isrepeat)
    mainRoom.input:KeyPressed(key, scancode, isrepeat)
end

function mainRoom.keyreleased(key, scancode)
    mainRoom.input:KeyRelease(key, scancode)
end

function mainRoom.mousepressed(x, y, button, istouch, presses)
    mainRoom.input:MousePressed(x, y, button, istouch, presses)
    mainRoom.touch:Start()
    mainRoom.ui:Mousepressed(x, y, button, istouch, presses)
end

function mainRoom.mousereleased(x, y, button, istouch, presses)
    mainRoom.input:MouseReleased(x, y, button, istouch, presses)
    mainRoom.touch:End()
    mainRoom.ui:Mousereleased(x, y, button, istouch, presses)

end

function mainRoom.resize(width, height)
    mainRoom.gameplayCamera:Resize(width, height)
    mainRoom.uiCamera:Resize(width, height)
    mainRoom.ui:Resize(width, height)
end

function mainRoom.unload()
    mainRoom.assetList:Unload()
    mainRoom.roomWorld:Unload()
end

return mainRoom
