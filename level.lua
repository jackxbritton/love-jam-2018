local ROT = require("lib.rotLove.rot")
local Tile = require("tile")

local Level = Object:extend()

local n = 16
Level.tiles = {
    ["empty"] = Tile(false, love.graphics.newQuad(0,   0, n, n, 64, 64)),
    ["spike"] = Tile(true,  love.graphics.newQuad(2*n, n, n, n, 64, 64)),
    ["door"]  = Tile(false, love.graphics.newQuad(n,   0, n, n, 64, 64))
}

function Level:new()
    self.tileWidth = n
    self.tileHeight = n

    self.image = Media:getImage("programmer-art.png")
    self.seenTiles = {}
    self.visibleTiles = {}
end

function Level:getTile(x, y)
    -- We use 0 based locations, correct the index
    local x, y = x + 1, y + 1

    local mapx = self.map[x]
    if mapx ~= nil then
        return mapx[y]
    end
end

function Level:isPassable(x, y)
    local tile = self:getTile(x, y)
    return tile ~= nil and not tile.solid
end

function Level:getPath(startx, starty, endx, endy)
    -- We could possibly cache the pathFinder if we need to get more performance.
    local pathFinder = ROT.Path.AStar(endx, endy, function(x, y)
        return self:isPassable(x,y)
    end, { topology = 4 })

    local path = {}

    pathFinder:compute(startx, starty, function(x, y)
        table.insert(path, {x=x, y=y})
    end)

    return path
end

function Level:loadFromFile(file)
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

    self.rooms = {Rect(0, 0, self.mapWidth, self.mapHeight)}
end

function Level:generate(w, h)
    self.mapWidth = w
    self.mapHeight = h
    self.map = {}

    for x = 1, w do
        self.map[x] = {}

        for y = 1, h do
            self.map[x][y] = Level.tiles["empty"]
        end
    end

    local digger = ROT.Map.Digger(w, h)
    digger:create(function(x, y, val)
        local tile = Level.tiles["empty"]
        if val == 1 then
            tile = Level.tiles["spike"]
        end

        self.map[x][y] = tile
    end)

    for _, door in ipairs(digger:getDoors()) do
        if not (door.x <= 0 or door.y <= 0 or door.x > self.mapWidth or door.y > self.mapHeight) then
            self.map[door.x][door.y] = Level.tiles["door"]
        end
    end

    self.rooms = {}
    for _, room in ipairs(digger:getRooms()) do
        local x, y = room:getLeft(), room:getTop()
        local w, h = room:getRight() - x, room:getBottom() - y
        table.insert(self.rooms, Rect(x, y, w, h))
    end
end

function Level:getRandomRoom()
    return lume.randomchoice(self.rooms)
end

function Level:checkFOV(x, y)
    -- If we have any animated tiles, put animation here

    -- Calculate our PoV
    self.visibleTiles = {}
    local fov = ROT.FOV.Precise(function(fov, x, y) return self:isPassable(x, y) end)
    fov:compute(x,y, 10, function(x, y, r, visiblity)
        local key = string.format("%d,%d",x+1,y+1)
        self.seenTiles[key] = true
        self.visibleTiles[key] = r/10
    end)

end

function Level:isSeen(x, y)
    x, y = math.floor(x), math.floor(y)
    local key = string.format("%d,%d",x+1,y+1)
    return self.seenTiles[key]
end

function Level:isVisible(x, y)
    x, y = math.floor(x), math.floor(y)
    local key = string.format("%d,%d",x+1,y+1)
    return self.visibleTiles[key] ~= nil
end

function Level:draw()
    for x = 0, self.mapWidth-1 do
        for y = 0, self.mapHeight-1 do
            local key = string.format("%d,%d",x+1,y+1)
            if self.seenTiles[key] then
                love.graphics.setColor(100,100,100)

                if self.visibleTiles[key] ~= nil then
                    local l = math.pow(1 - self.visibleTiles[key], 2) * 100 + 155
                    love.graphics.setColor(l,l,l)
                end

                local sx, sy = x * self.tileWidth, y * self.tileHeight
                love.graphics.draw(self.image, self.map[x+1][y+1].quad, sx, sy)
            end
        end
    end
end

return Level
