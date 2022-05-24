local IsoGrid = {}

IsoGrid.Width = 10
IsoGrid.Height = 10
IsoGrid.TileWidth = 64
IsoGrid.TileHeight = 32
IsoGrid.MapWidth = 640
IsoGrid.MapHeight = 320

--- Constructor
function IsoGrid:New()
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    return newInstance
end

function IsoGrid:TileWorldPosition(x, y)
    --  screen.x = (map.x - map.y) * TILE_WIDTH_HALF;
    --  screen.y = (map.x + map.y) * TILE_HEIGHT_HALF;

    local gridx = (x - y) * self.TileWidth / 2
    local gridy = (x + y) * self.TileHeight / 2

    gridx = gridx + (640 / 2) - 32 
    return gridx, gridy

end

return IsoGrid
