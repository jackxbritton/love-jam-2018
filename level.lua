local Object = require("lib.classic")
local Tile = require("tile")

local Level = Object:extend()

local n = 16
Level.tiles = {
    ["empty"] = Tile(love.graphics.newQuad(0, 0, n, n, 64, 64)),
    ["spike"] = Tile(love.graphics.newQuad(2*n, n, n, n, 64, 64))
}

function Level:new(file)

    local chars_to_tiles = {
        ["-"] = Level.tiles["empty"],
        ["^"] = Level.tiles["spike"]
    }

    local f = io.open(file, "rb")
    local s = f:read("*all")
    s = s:gsub("[ \t\r]", "") -- Eliminate whitespace (and carriage returns).

    self.w = s:find("\n") - 1 -- Use the first \n to find the map width.

    self.map = {}
    for x = 1,self.w do
        self.map[x] = {}
    end

    local x = 1
    self.h = 0

    for i = 1,s:len() do
        local c = s:sub(i,i)
        if c == "\n" then
            -- It's a new row.
            x = 1
            self.h = self.h + 1
        else
            if (chars_to_tiles[c] == nil) then
                print("error loading level")
            end
            self.map[x][self.h+1] = chars_to_tiles[c]
            x = x + 1
        end
    end

    -- Sprite batch.
    self.image = Media:getImage("programmer-art.png")
    self.spriteBatch = love.graphics.newSpriteBatch(self.image, self.w*self.h)

end

function Level:draw()
    love.graphics.setColor(255,255,255)
    local w, h = love.graphics.getDimensions()
    local dx, dy = w / self.w, h / self.h

    self.spriteBatch:clear()
    for x = 0, self.w-1 do
        for y = 0, self.h-1 do
            self.spriteBatch:add(self.map[x+1][y+1].quad, x*dx, y*dy, 0, dx, dy)
        end
    end

    love.graphics.draw(self.spriteBatch)
end

return Level
