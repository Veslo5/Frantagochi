local IsoGrid = {}

IsoGrid.Width = 10
IsoGrid.Height = 10
IsoGrid.TileWidth = 64
IsoGrid.TileHeight = 32
IsoGrid.MapWidth = 640
IsoGrid.MapHeight = 320

--- Constructor
function IsoGrid:New(mapWidth, mapHeight, tileWidth, tileHeight)
    local newInstance = {}
    setmetatable(newInstance, self)
    self.__index = self

    newInstance.MapWidth = mapWidth
    newInstance.MapHeight = mapHeight
    newInstance.TileWidth = tileWidth
    newInstance.TileHeight = tileHeight

    return newInstance
end

function IsoGrid:TileWorldPosition(x, y, heightTileOffset)
    heightTileOffset = heightTileOffset or 0
    --  screen.x = (map.x - map.y) * TILE_WIDTH_HALF;
    --  screen.y = (map.x + map.y) * TILE_HEIGHT_HALF;


    local gridx = (x - y) * self.TileWidth / 2
    local gridy = (x + y) * self.TileHeight / 2

    print(gridx,gridy)
    gridx = gridx + (self.MapWidth / 2) - self.TileHeight / 2
    gridy = gridy - self.TileHeight * heightTileOffset
    return gridx, gridy

end

return IsoGrid
