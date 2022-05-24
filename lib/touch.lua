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
        local mx,my = love.mouse.getPosition()
    
        self.EndPosX = mx
        self.EndPosY = my        
    end
end

function Touch:End()
    local mx,my = love.mouse.getPosition()
    
    self.EndPosX = mx
    self.EndPosY = my

    Touch.IsTouching = false
end

function Touch:GetCurrentPos()
    if self.IsTouching then
        return (self.StartPosX - self.EndPosX), (self.StartPosY - self.EndPosY)        
        else
            return 0,0
    end
end

return Touch