local ControlBaseHelper = {}

function ControlBaseHelper._align(object, verticalAlign, horizontalAlign, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 0

    local screenWidth, screenHeight = love.graphics.getDimensions()
    if verticalAlign ~= nil then
        if (verticalAlign == "top") then
            object.Y = 0 + offsetY
        elseif (verticalAlign == "center") then
            object.Y = (screenHeight / 2) - (object.Height / 2) + offsetY
        elseif (verticalAlign == "bottom") then
            object.Y = screenHeight - object.Height + offsetY
        end
    end

    if verticalAlign ~= nil then
        if (horizontalAlign == "left") then
            object.X = 0 + offsetX
        elseif (horizontalAlign == "center") then
            object.X = (screenWidth / 2) - (object.Width / 2) + offsetX
        elseif (horizontalAlign == "right") then
            object.X = screenWidth - object.Width + offsetX
        end
    end
end

function ControlBaseHelper._handleAnimationTween(object, dt)
    if object.InEnded == false then
        for index, value in ipairs(object.InAnimations) do
            object.AnimationCompleted = value:update(dt)
        end

        if object.AnimationCompleted == true then
            object.InEnded = true

            object.AnimationCompleted = false
        end

    else

        for index, value in ipairs(object.OutAnimations) do
            object.AnimationCompleted = value:update(dt)
        end

        if object.AnimationCompleted == true then
            for index, value in ipairs(object.OutAnimations) do
                object.AnimationCompleted = value:update(dt)
            end

            object.AnimationCompleted = false

            if object.AnimationRepeat == false then
                object.StartAnim = false
            else
                object.InEnded = false
                ControlBaseHelper._resetTweens(object)
            end
        end
    end
end

function ControlBaseHelper._handleMouseCoords(object, mx, my)
    if (object.LastFrameDown == false and object.IsDown) then
        object.IsDown = false
        object.LastFrameDown = true
    end

    if mx >= object.X and mx <= object.X + object.Width then
        if my >= object.Y and my < object.Y + object.Height then
            object.IsHovered = true
            return
        end
    end
    object.IsHovered = false
end

function ControlBaseHelper._resetTweens(object)
    for index, value in ipairs(object.OutAnimations) do
        value:reset()
    end

    for index, value in ipairs(object.InAnimations) do
        value:reset()
    end
end

return ControlBaseHelper
