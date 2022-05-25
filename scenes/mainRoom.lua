local mainRoom = {}

mainRoom.input = Global:require("lib.bindMe")
mainRoom.camera = Global:require("lib.camera")
mainRoom.isoGrid = Global:require("lib.isoGrid")
mainRoom.touch = Global:require("lib.touch")
mainRoom.animation = Global:require("lib.anim8")
mainRoom.collections = Global:require("lib.collections")
mainRoom.ui = Global:require("lib.UI.ui")


function mainRoom.load()
    mainRoom:bindKeys()
    mainRoom:createCameras()

    mainRoom.ui:AddButton("Test", 150, 150, 60, 30, "blah")
    mainRoom.roomGrid = mainRoom.isoGrid:New()
    mainRoom.imageList = mainRoom.collections:New()

    mainRoom.imageList:Add("map", love.graphics.newImage("resources/maps/Frant.png"))
    mainRoom.imageList:Add("mapg", love.graphics.newImage("resources/maps/ground.png"))
    mainRoom.imageList:Add("frantaAnim", love.graphics.newImage("resources/maps/Franta_write1.png"))

    local animgrid = mainRoom.animation.newGrid(64, 64, mainRoom.imageList:Get("frantaAnim"):getWidth(), mainRoom.imageList:Get("frantaAnim"):getHeight())
    mainRoom.frantaAnimReal = mainRoom.animation.newAnimation(animgrid("1-4", 1), 0.1)
end

function mainRoom.update(dt)

    mainRoom.frantaAnimReal:update(dt)
    mainRoom.touch:Update()
    mainRoom.ui:Update(mainRoom.uiCamera.MouseWorldX, mainRoom.uiCamera.MouseWorldY)

    local touchPosX, touchPosY = mainRoom.touch:GetCurrentPos()
    mainRoom.gameplayCamera:SetPosition(mainRoom.gameplayCamera.X + touchPosX / 10, mainRoom.gameplayCamera.Y + touchPosY / 10, true)


    if (mainRoom.ui:IsDown("Test")) then
        print("test")
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

function mainRoom.draw()
    local mouseX, mouseY = love.mouse.getPosition()


    love.graphics.setBackgroundColor(0, 0, 0, 1)


    mainRoom.gameplayCamera:BeginDraw()
    -- Gameplay rendering
    love.graphics.draw(mainRoom.imageList:Get("map"), 0, 0)

    local localPosX, localPosY = mainRoom.roomGrid:TileWorldPosition(6, 6)
    mainRoom.frantaAnimReal:draw(mainRoom.imageList:Get("frantaAnim"), localPosX, localPosY)

    mainRoom.gameplayCamera.EndDraw()

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
    love.graphics.setDefaultFilter("nearest", "nearest", 0)

    mainRoom.gameplayCamera = Global:AddGlobal("GAMEPLAY_CAMERA", mainRoom.camera:New())
    mainRoom.uiCamera = Global:AddGlobal("MENU_CAMERA", mainRoom.camera:New(100))

    mainRoom.gameplayCamera:SetPosition(0, 0, true)
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

function mainRoom.resize(x, y)
    mainRoom.gameplayCamera:Resize()
    mainRoom.uiCamera:Resize()
end

function mainRoom.unload()

end

return mainRoom
