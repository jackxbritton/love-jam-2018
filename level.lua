local Object = require("lib.classic")
local Tile = require("tile")

local Level = Object:extend()

function Level:new(w, h)
    self.w = w
    self.h = h

    -- Sprite batch.
    self.image = love.graphics.newImage("assets/programmer-art.png")
    self.spriteBatch = love.graphics.newSpriteBatch(self.image, w*h)

    self.map = {}
    for x = 0, w-1 do
        self.map[x] = {}
        for y = 0, h-1 do
            local quad = love.graphics.newQuad(0, 0, 8, 8, 64, 64)
            self.map[x][y] = Tile(quad)
        end
    end

end

function Level:draw()
    love.graphics.setColor(255,255,255)
    local w, h = love.graphics.getDimensions()
    local dx, dy = w / self.w, h / self.h

    self.spriteBatch:clear()
    for x = 0, self.w-1 do
        for y = 0, self.h-1 do
            self.spriteBatch:add(self.map[x][y].quad, x*dx, y*dy, (x+1)*dx, (y+1)*dy)
        end
    end

    love.graphics.draw(self.spriteBatch)
end

return Level
