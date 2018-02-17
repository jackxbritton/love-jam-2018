-- Set up globals
Object = require("lib.classic")
lume = require("lib.lume")
coil = require("lib.coil")
flux = require("lib.flux")
Media = require("lib.mediamanager")
Rect = require("lib.rectangle")

-- Watch out for globals
require("lib.globalwatch")

function love.load()
end

function love.update(dt)
end

function love.draw()
    w, h = love.graphics.getDimensions()
    love.graphics.printf("Hello World!", w/2, h/2, 0, "center")
end
