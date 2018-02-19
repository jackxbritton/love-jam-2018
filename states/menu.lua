local MenuState = Object:extend()

Gamestate = require("lib.hump.gamestate")
local GameState = require("states.game")

local items = {
    { text = "Play", func = function()
        Gamestate.switch(GameState())
    end },
    { text = "Quit", func = function()
        love.event.quit()
    end }
}

local selected = 1

local bigFont   = love.graphics.newFont(32)
local smallFont = love.graphics.newFont(12)

function MenuState:new()
end

function MenuState:keypressed(key, scancode, isrepeat)
    if key == "up" then
        selected = selected - 1
        if selected == 0 then
            selected = 1
        end
    elseif key == "down" then
        selected = selected + 1
        if selected == #items+1 then
            selected = #items
        end
    elseif key == "return" then
        items[selected].func()
    end
end

function MenuState:update(dt)
end

function MenuState:draw()
    local w,h = love.graphics.getDimensions()
    love.graphics.setFont(bigFont)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("GAME", w/2, h/2, 0, "center")
    love.graphics.setFont(smallFont)
    for i = 1, #items do
        local item = items[i]
        if i == selected then
            love.graphics.setColor(255, 0, 0)
        else
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.printf(item.text, w/2, 40 + 20*i+h/2, 0, "center")
    end
end

function MenuState:doTurn(action)
    -- Get a list of turn taking entities (excluding our player)
    local ents = self.entities:filter(function(e)
        return e:is(TurnEntity) and e ~= self.player
    end)

    -- Player does a turn:
    local elapsedTime = self.player:doAction(action)

    -- Everyone else does a turn:
    for _, ent in ipairs(ents) do
        ent:startTurn(elapsedTime)
        ent:doTurn()
    end

    self.level:checkFOV(self.player.x, self.player.y)
end

return MenuState
