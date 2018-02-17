local Tile = require("tile")

local Level = Object:extend()
function Level:new(w, h)
    self.w = w
    self.h = h
    self.map = {}
    for x = 0, w-1 do
        self.map[x] = {}
        for y = 0, h-1 do
            self.map[x][y] = Tile()
        end
    end
end

function Level:draw()
    local w, h = love.graphics.getDimensions()
    local dx, dy = w / level.w, h / level.h
    for x = 0, level.w-1 do
        for y = 0, level.h-1 do
            love.graphics.setColor(255, 0, 0) -- TODO Texture or whatever.
            love.graphics.rectangle("fill", x*dx, y*dy, (x+1)*dx, (y+1)*dy)
        end
    end
    -- TODO Get rid of border.
    for x = 0, level.w-1 do
        for y = 0, level.h-1 do
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("line", x*dx, y*dy, (x+1)*dx, (y+1)*dy)
        end
    end
end

return Level
