local Touch = {}
Touch.StartPosX = 0
Touch.StartPosY = 0
Touch.EndPosX = 0
Touch.EndPosY = 0
Touch.IsTouching = false
Touch.LatestPosX = 0
Touch.LatestPosY = 0


function Touch:Start()
    local mx, my = love.mouse.getPosition()
    self.StartPosX = mx
    self.StartPosY = my
    self.IsTouching = true
end

function Touch:Update()

    if self.IsTouching then
        local mx, my = love.mouse.getPosition()

        self.EndPosX = mx
        self.EndPosY = my
    end
end

function Touch:End()
    local mx, my = love.mouse.getPosition()

    self.EndPosX = mx
    self.EndPosY = my

    Touch.IsTouching = false
end

function Touch:GetCurrentPos()
    if self.IsTouching then
        local latestPosX = self.StartPosX - self.EndPosX
        local latestPosY = self.StartPosY - self.EndPosY

        if latestPosX == self.LatestPosX and latestPosY == self.LatestPosY then     
            local mx, my = love.mouse.getPosition()
            self.StartPosX = mx
            self.StartPosY = my       
            return 0, 0
        else
            self.LatestPosX = latestPosX
            self.LatestPosY = latestPosY

            return self.LatestPosX, self.LatestPosY
        end
    else
        return 0, 0
    end
end

return Touch
