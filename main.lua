-- Set up globals
Object = require("lib.classic")
lume   = require("lib.lume")
coil   = require("lib.coil")
flux   = require("lib.flux")
Media  = require("lib.mediamanager")
Rect   = require("lib.rectangle")
Level = require("level")

-- Watch out for globals
require("lib.globalwatch")

-- Game stuff.

local level = Level(4, 4)

function love.load()
end

function love.update(dt)
    -- TODO
end

function love.draw()

    level:draw()

    local w, h = love.graphics.getDimensions()
    love.graphics.printf("Hello World!", w/2, h/2, 0, "center")

end
