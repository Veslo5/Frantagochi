local Camera = {}

Camera.X = 0
Camera.Y = 0
Camera.Zoom = 0
Camera.Rotation = 0
Camera.WindowResX = nil
Camera.WindowResY = nil
Camera.VirtualX = 0
Camera.VirtualY = 0
Camera.VirtualZoomX = 1
Camera.VirtualZoomY = 1
Camera.VirtualResX = 0
Camera.VirtualResY = 0

Camera.MouseWorldX = 0
Camera.MouseWorldY = 0

-- Render scale in percent!
Camera.RenderScale = 100
-- Scale or Fill
-- Scale is static and defined by renderScale
-- Fill is dynamic and creating zoom in or our by current resolution
Camera.RenderMode = "Scale"

--- Constructor
function Camera:New(renderScale, renderMode, virtualResWidth, virtualResHeight)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.RenderScale = renderScale or 100
    newInstance.RenderMode = renderMode or "Scale"
    newInstance.VirtualResX = virtualResWidth or 0
    newInstance.VirtualResY = virtualResHeight or 0

    newInstance:_calculateVirtualZoom(newInstance.RenderScaling)

    return newInstance
end

--- Reset the camera into defaults
function Camera:Reset()
    self.X = 0
    self.Y = 0
    self.Zoom = 0
    self.Rotation = 0
    self.WindowResX = nil
    self.WindowResY = nil
    self.VirtualX = 0
    self.VirtualY = 0
    self.VirtualZoomX = 1
    self.VirtualZoomY = 1
    self.VirtualResX = 0
    self.VirtualResY = 0

    -- Render scale in percent!
    self.RenderScale = 100
end

--- BEGIN DRAWIN OF CAMERA
function Camera:BeginDraw()
    love.graphics.push()
    love.graphics.rotate(-self.Rotation)
    love.graphics.scale(self.VirtualZoomX + self.Zoom, self.VirtualZoomY + self.Zoom)
    love.graphics.translate(-self.VirtualX, -self.VirtualY)

    local mx, my = love.mouse.getPosition()
    self.MouseWorldX, self.MouseWorldY = self:ScreenToWorld(mx, my)

end

--- END DRAWING OF CAMERA
function Camera:EndDraw()
    love.graphics.pop()
end

--- Rotate the camera
function Camera:Rotate(dr)
    self.Rotation = self.Rotation + dr
end

--- Zooms the camera
function Camera:SetZoom(size, center)
    self.Zoom = size or self.Zoom

    if (center or false) then
        local virtualZoomX, virtualZoomY = self:_getVirtualZoom()
        self.VirtualX = self.X - (self.WindowResX / 2) / virtualZoomX
        self.VirtualY = self.Y - (self.WindowResY / 2) / virtualZoomY
    end

end

--- Set position of camera
function Camera:SetPosition(x, y, center)
    self.X = x or self.X
    self.Y = y or self.Y

    if (center or false) then
        local virtualZoomX, virtualZoomY = self:_getVirtualZoom()
        self.VirtualX = self.X - (self.WindowResX / 2) / virtualZoomX
        self.VirtualY = self.Y - (self.WindowResY / 2) / virtualZoomY
    else
        self.VirtualX = self.X
        self.VirtualY = self.Y
    end

end

function Camera:ScreenToWorld(mouseX, mouseY)
    return love.graphics.inverseTransformPoint(mouseX, mouseY)
end

function Camera:WorldToScreen(screenX, screenY)
    return love.graphics.transformPoint(screenX, screenY)
end

function Camera:SetRenderScale(renderPercent)
    self.RenderScale = renderPercent
    self:_calculateVirtualZoom()
end

function Camera:Resize(width, height)
    self:_calculateVirtualZoom(self.RenderScale)

    --TODO: vyřešit align kamery po resizu. S tím se pravděpodobně sveze i origin kamery (potom zanikne parametr center z funkcí)
end

function Camera:_calculateVirtualZoom(renderScale)
    local width, height = love.graphics.getDimensions()

    self.WindowResX = width
    self.WindowResY = height

    if (self.RenderMode == "Scale") then
        self.VirtualResX = (self.WindowResX / 100) * self.RenderScale
        self.VirtualResY = (self.WindowResY / 100) * self.RenderScale
    end

    self.VirtualZoomX = width / self.VirtualResX
    self.VirtualZoomY = height / self.VirtualResY

end

function Camera:_getVirtualZoom()
    return self.VirtualZoomX + self.Zoom, self.VirtualZoomY + self.Zoom
end

return Camera
