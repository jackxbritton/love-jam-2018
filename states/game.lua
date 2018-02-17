local GameState = Object:extend()

local Player = require("entities.player")
local Level  = require("level")
local Group  = require("group")


function GameState:new()
    self.level = Level(4, 4)
    self.group = Group()
    self.player = Player()

    self.group:add(self.player)
end

function GameState:keypressed(key, scancode, isrepeat)
    if key == "up" then
        self.player:moveDelta(0, -1)
    elseif key == "down" then
        self.player:moveDelta(0, 1)
    elseif key == "left" then
        self.player:moveDelta(-1, 0)
    elseif key == "right" then
        self.player:moveDelta(1, 0)
    end
end

function GameState:update(dt)
    self.group:update(dt)
end

function GameState:draw()
    self.level:draw()
    self.group:draw()
end


return GameState
