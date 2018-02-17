-- Set up globals
Object = require("lib.classic")
lume   = require("lib.lume")
coil   = require("lib.coil")
flux   = require("lib.flux")
Media  = require("lib.mediamanager")
Rect   = require("lib.rectangle")

Entity = require("entity")
Level  = require("level")
Group  = require("group")

-- Watch out for globals
require("lib.globalwatch")

-- Game stuff.

local level = Level(4, 4)
local group = Group()
local player = require("entities.player")()


function love.load()
    group:add(player)
end

function love.update(dt)
    -- TODO
    group:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "up" then
        player:moveDelta(0, -1)
    elseif key == "down" then
        player:moveDelta(0, 1)
    elseif key == "left" then
        player:moveDelta(-1, 0)
    elseif key == "right" then
        player:moveDelta(1, 0)
    end
end

function love.draw()
    level:draw()
    group:draw()

end
