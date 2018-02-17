local Object = require("lib.classic")
local Tile = require("tile")

local Level = Object:extend()

local n = 16
Level.tiles = {
    ["empty"] = Tile(false, love.graphics.newQuad(0, 0, n, n, 64, 64)),
    ["spike"] = Tile(true, love.graphics.newQuad(2*n, n, n, n, 64, 64))
}

function Level:new(file)
    self.tileWidth = n
    self.tileHeight = n
    local chars_to_tiles = {
        ["-"] = Level.tiles["empty"],
        ["^"] = Level.tiles["spike"]
    }

    local f = io.open(file, "rb")
    local s = f:read("*all")
    s = s:gsub("[ \t\r]", "") -- Eliminate whitespace (and carriage returns).

    self.mapWidth = s:find("\n") - 1 -- Use the first \n to find the map width.

    self.map = {}
    for x = 1,self.mapWidth do
        self.map[x] = {}
    end

    local x = 1
    self.mapHeight = 0

    for i = 1,s:len() do
        local c = s:sub(i,i)
        if c == "\n" then
            -- It's a new row.
            x = 1
            self.mapHeight = self.mapHeight + 1
        else
            if (chars_to_tiles[c] == nil) then
                print("error loading level")
            end
            self.map[x][self.mapHeight+1] = chars_to_tiles[c]
            x = x + 1
        end
    end

    -- Sprite batch.
    self.image = Media:getImage("programmer-art.png")
    self.spriteBatch = love.graphics.newSpriteBatch(self.image, self.mapWidth * self.mapHeight)
end

function Level:getTile(x, y)
    -- We use 0 based locations, correct the index
    local x, y = x + 1, y + 1
    
    local mapx = self.map[x]
    if mapx ~= nil then
        return mapx[y]
    end
end

function Level:draw()
    love.graphics.setColor(255,255,255)

    self.spriteBatch:clear()
    for x = 0, self.mapWidth-1 do
        for y = 0, self.mapHeight-1 do
            local sx, sy = x * self.tileWidth, y * self.tileHeight
            self.spriteBatch:add(self.map[x+1][y+1].quad, sx, sy, 0, self.tileWidth, self.tileHeight)
        end
    end

    love.graphics.draw(self.spriteBatch)
end

return Level
