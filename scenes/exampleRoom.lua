local exampleRoom = {}

exampleRoom.input = Global:GetGlobal("lib.bindMe")
exampleRoom.gameplayCamera = Global:GetGlobal("GAMEPLAY_CAMERA")
exampleRoom.uiCamera = Global:GetGlobal("MENU_CAMERA")

function exampleRoom.load()
end

function exampleRoom.update(dt)
    if (exampleRoom.input:IsActionPressed("EXIT")) then
        love.event.quit()
    end
end

function exampleRoom.draw()

    love.graphics.setBackgroundColor(0,0,0,1)
    exampleRoom.gameplayCamera:BeginDraw()
    -- Gameplay rendering

    exampleRoom.gameplayCamera.EndDraw()

    exampleRoom.uiCamera:BeginDraw()
    -- UI rendering
    love.graphics.print("test from second scene", 0, 0)
    exampleRoom.uiCamera:EndDraw()
end

--#####CALLBACKS######
function exampleRoom.keypressed(key, scancode, isrepeat)
    exampleRoom.input:KeyPressed(key, scancode, isrepeat)

end

function exampleRoom.keyreleased(key, scancode)
    exampleRoom.input:KeyRelease(key, scancode)

end

function exampleRoom.mousepressed(x, y, button, istouch, presses)
    exampleRoom.input:MousePressed(x, y, button, istouch, presses)

end

function exampleRoom.mousereleased(x, y, button, istouch, presses)
    exampleRoom.input:MouseReleased(x, y, button, istouch, presses)


end

function exampleRoom.resize(width, height)

end

function exampleRoom.unload()

end

return exampleRoom
