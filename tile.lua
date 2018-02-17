local Object = require("lib.classic")

local Tile = Object:extend()

function Tile:new(quad)
    self.quad = quad;
end

return Tile
