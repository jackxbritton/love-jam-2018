local MenuState = Object:extend()

Gamestate = require("lib.hump.gamestate")
local GameState = require("states.game")

function MenuState:new()
    self.items = {
        { text = "Play", func = function()
            Gamestate.switch(GameState())
        end },
        { text = "Quit", func = function()
            love.event.quit()
        end }
    }
    self.selected = 1
end

function MenuState:keypressed(key, scancode, isrepeat)
    if key == "up" then
        self.selected = self.selected - 1
        if self.selected == 0 then
            self.selected = 1
        end
    elseif key == "down" then
        self.selected = self.selected + 1
        if self.selected == #self.items+1 then
            self.selected = #self.items
        end
    elseif key == "return" then
        self.items[self.selected].func()
    end
end

function MenuState:update(dt)
end

function MenuState:draw()
    local w,h = love.graphics.getDimensions()
    for i = 1, #self.items do
        local item = self.items[i]
        if i == self.selected then
            love.graphics.setColor(255, 0, 0)
        else
            love.graphics.setColor(255, 255, 255)
        end
        love.graphics.printf(item.text, w/2, 40*(i-1)+h/2, 0, "center")
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
