-- Set up globals
Object    = require("lib.classic")
lume      = require("lib.lume")
coil      = require("lib.coil")
flux      = require("lib.flux")
Media     = require("lib.mediamanager")
Rect      = require("lib.rectangle")
Gamestate = require("lib.hump.gamestate")

Entity = require("entity")

-- Install cheats
require("lib.autobatch")

-- Watch out for globals
require("lib.globalwatch")

-- Game stuff.

local MenuState = require("states.menu")

function love.load()
    -- Magic the love.* events to call our gamestates
    Gamestate.registerEvents()
    Gamestate.switch(MenuState())

    -- Prevent tendonitis
    love.keyboard.setKeyRepeat(true)
end
