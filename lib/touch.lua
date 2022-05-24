local Touch = {}
Touch.StartPosX = 0
Touch.StartPosY = 0
Touch.EndPosX = 0
Touch.EndPosY = 0
Touch.IsTouching = false

function Touch:Start()
    local mx,my = love.mouse.getPosition()
    self.StartPosX = mx
    self.StartPosY = my
    Touch.IsTouching = true
end

function Touch:Update()
    
    if self.IsTouching then
        self:End()            
    end
end

function Touch:End()
    local mx,my = love.mouse.getPosition()
    
    self.EndPosX = mx
    self.EndPosY = my

    Touch.IsTouching = false
end

function Touch:GetCurrentPos()
    return (self.StartPosX - self.EndPosX)* -1, (self.StartPosY - self.EndPosY) * -1
end

return Touch