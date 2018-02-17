local Object = require("lib.classic")

local Tile = Object:extend()

function Tile:new(solid, quad)
    self.solid = solid
    self.quad = quad
end

return Tile
