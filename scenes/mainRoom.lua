local mainRoom = {}

Global:require("lib.anim8")

mainRoom.input = Global:require("lib.bindMe")
mainRoom.isoGrid = Global:require("lib.isoGrid")
mainRoom.touch = Global:require("lib.touch")
mainRoom.ui = Global:require("lib.UI.ui")

mainRoom.assetManagerFactory = Global:require("lib.assetManager")
mainRoom.cameraFactory = Global:require("lib.camera")
mainRoom.worldFactory = Global:require("scripts.world")

mainRoom.leftBar = require("scripts.ui.leftBar")


function mainRoom.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    mainRoom.ui:Load("resources/fonts/Kaph-Regular.ttf")

    mainRoom:loadAssets()
    mainRoom.roomGrid = mainRoom.isoGrid:New(mainRoom.assetList:Get("map"):getWidth(),
        mainRoom.assetList:Get("map"):getHeight(), 64, 32)

    mainRoom.roomWorld = mainRoom.worldFactory:New()
    mainRoom.roomWorld:Load()

    mainRoom:bindKeys()
    mainRoom:buildUI()

    mainRoom:createCameras()

    -- mainRoom.roomWorld:AddObject("monitor_animated", mainRoom.assetList:Get("monitorAnim"), 2):Animate(64, 32, 0.4, "1-5", 1):SetGridPosition(10, 12, 0, 20, 0)
    -- mainRoom.roomWorld:AddObject("idle_programming", mainRoom.assetList:Get("frantaAnim"), 1):Animate(64, 64, 0.1, "1-4", 1):SetGridPosition(11, 13, 1):SetVisibility(false)
    -- mainRoom.roomWorld:AddObject("idle_sitting", mainRoom.assetList:Get("frantaAnimSit"), 1):Animate(64, 64, 0.1, "1-4", 1):SetGridPosition(4, 12):SetVisibility(false)
    -- mainRoom.roomWorld:AddObject("map_background", mainRoom.assetList:Get("map"), 0):SetPosition(0, 0)
end

function mainRoom.update(dt)

    -- room and world update
    mainRoom.roomWorld:Update(dt)

    -- touch update
    mainRoom.touch:Update()
    local touchPosX, touchPosY = mainRoom.touch:GetCurrentPos()
    mainRoom.gameplayCamera:SetPosition(mainRoom.gameplayCamera.X + touchPosX / 10,
        mainRoom.gameplayCamera.Y + touchPosY / 10, true)

    -- keyboard handling
    mainRoom.handleInput(mainRoom, dt)


    if mainRoom.ui:IsDown("EXPAND") then
        mainRoom.leftBar:ChangeState()
    end
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
    mainRoom.ui:Draw()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(mouseX, 20, 20)
    love.graphics.print(mouseY, 20, 30)

    love.graphics.print("G-Camera", 20, 50)        

    love.graphics.print(mainRoom.gameplayCamera.MouseWorldX, 20, 60)
    love.graphics.print(mainRoom.gameplayCamera.MouseWorldY, 20, 70)    

    love.graphics.print("UI-Camera", 20, 90)

    love.graphics.print(mainRoom.uiCamera.MouseWorldX, 20, 100)
    love.graphics.print(mainRoom.uiCamera.MouseWorldY, 20, 110)

    love.graphics.print(love.timer.getFPS(), 20, 130)

    love.graphics.print("World object count: " .. #mainRoom.roomWorld.objects, 20, 150)
    love.graphics.print("UI object count: " .. #mainRoom.ui.container, 20, 160)


    local stats = love.graphics.getStats()
    love.graphics.print("Drawcalls: " .. stats.drawcalls, 20, 180)
    love.graphics.print("Canvasswitches: " .. stats.canvasswitches, 20, 190)
    love.graphics.print("Texturememory: " .. stats.texturememory / 1000000 .. "MB", 20, 200)
    love.graphics.print("Images: " .. stats.images, 20, 210)
    love.graphics.print("Canvases: " .. stats.canvases, 20, 220)
    love.graphics.print("Fonts: " .. stats.fonts, 20, 230)


    mainRoom.uiCamera:EndDraw()

end

function mainRoom.loadAssets()
    mainRoom.assetList = mainRoom.assetManagerFactory:New()

    mainRoom.assetList:Load("map", love.graphics.newImage("resources/maps/Frant.png"))
    mainRoom.assetList:Load("mapg", love.graphics.newImage("resources/maps/ground.png"))
    mainRoom.assetList:Load("frantaAnim", love.graphics.newImage("resources/maps/Franta_write1.png"))
    mainRoom.assetList:Load("monitorAnim", love.graphics.newImage("resources/maps/monitor_write1.png"))
    mainRoom.assetList:Load("frantaAnimSit", love.graphics.newImage("resources/maps/Franta_sit.png"))
    mainRoom.assetList:Load("uiTest", love.graphics.newImage("resources/ui/UI-1.png"))
    mainRoom.assetList:Load("uiTest2", love.graphics.newImage("resources/ui/UI-3.png"))
    mainRoom.assetList:Load("drink", love.graphics.newImage("resources/maps/drink.png"))
    mainRoom.assetList:Load("cigs", love.graphics.newImage("resources/maps/cigs.png"))
    mainRoom.assetList:Load("blank", love.graphics.newImage("resources/maps/blank.png"))
end

function mainRoom:buildUI()
    local button = mainRoom.ui:AddButton("Drink", 0, 0, 80, 80, mainRoom.assetList:Get("uiTest2"), "", 1,
        mainRoom.assetList:Get("drink")):Align("top", "right", -5, 100)
    mainRoom.ui:AddButton("Cigs", 0, 0, 80, 80, mainRoom.assetList:Get("uiTest2"), "", 1, mainRoom.assetList:Get("cigs"))
        :Align("top", "right", -5, 190)


    -- mainRoom.ui:AddInAnimation(2, button, { Height = 90, Width = 90 }, "linear")
    -- mainRoom.ui:AddOutAnimation(2, button, { Height = 80, Width = 80 }, "linear")
    -- mainRoom.ui:StartAnimation(button)


    -- mainRoom.ui:AddText("Stat1", 0, 0, ""):Align("center", "left", 20, -70)
    -- mainRoom.ui:AddText("Stat2", 0, 0, ""):Align("center", "left", 20, -50)
    -- mainRoom.ui:AddText("Stat3", 0, 0, ""):Align("center", "left", 20, -30)

    mainRoom.ui:AddText("Event1", 0, 0, ""):Align("top", "center", -200, 50)
    mainRoom.ui:AddText("Event2", 0, 0, ""):Align("top", "center", -200, 70)
    mainRoom.ui:AddText("Event3", 0, 0, ""):Align("top", "center", -200, 90)
    mainRoom.ui:AddText("Event4", 0, 0, ""):Align("top", "center", -200, 110)
    mainRoom.ui:AddText("Event5", 0, 0, ""):Align("top", "center", -200, 130)

    mainRoom.ui:AddScrollText("TESTSCROLL", 200, 0, 1000, 40, mainRoom.assetList:Get("uiTest"))


    local uiwindow = mainRoom.ui:AddWindow("TESTWIN", -300, 300, 400, 400, mainRoom.assetList:Get("uiTest"), 1)
    uiwindow:AddControl("Stat1", mainRoom.ui:NewText("Stat1", 0, 90, "IAM INSIDEWINDOW"))
    uiwindow:AddControl("Stat2", mainRoom.ui:NewText("Stat2", 0, 120, "IAM INSIDEWINDOW"))
    uiwindow:AddControl("Stat3", mainRoom.ui:NewText("Stat3", 0, 150, "IAM INSIDEWINDOW"))

    local expandButton = mainRoom.ui:AddButton("EXPAND", 60, 260, 80, 80, mainRoom.assetList:Get("uiTest"), ">>", 2)

    mainRoom.leftBar:AddWindow(uiwindow)
    mainRoom.leftBar:AddButton(expandButton)
end

function mainRoom:createCameras()
    mainRoom.gameplayCamera = Global:AddGlobal("GAMEPLAY_CAMERA", mainRoom.cameraFactory:New())
    mainRoom.uiCamera = Global:AddGlobal("MENU_CAMERA", mainRoom.cameraFactory:New(100, "Fill", 1366, 768))

    mainRoom.gameplayCamera:SetPosition(mainRoom.assetList:Get("map"):getWidth() / 2,
        mainRoom.assetList:Get("map"):getHeight() / 2, true)
end

function mainRoom:handleInput(dt)
    -- if (mainRoom.ui:IsDown("Test")) then
    -- end

    if (mainRoom.input:IsActionPressed("EXIT")) then
        love.event.quit()
    end

    if (mainRoom.input:IsActionDown("ZOOMIN")) then
        mainRoom.gameplayCamera:SetZoom(mainRoom.gameplayCamera.Zoom + 0.05, true)
    end

    if (mainRoom.input:IsActionDown("ZOOMOUT")) then
        mainRoom.gameplayCamera:SetZoom(mainRoom.gameplayCamera.Zoom - 0.05, true)
    end

    if (mainRoom.input:IsActionPressed("RESET")) then
        Scene.Load("exampleRoom")

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
