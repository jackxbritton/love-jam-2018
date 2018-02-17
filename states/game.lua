local GameState = Object:extend()

local Player  = require("entities.player")
local Level   = require("level")
local Group   = require("group")
local Actions = require("actions")


function GameState:new()
    local w,h = 16,9
    self.level = Level(w, h)
    self.entities = Group()
    self.player = Player(w, h)

    self.entities:add(self.player)
end

function GameState:keypressed(key, scancode, isrepeat)

    local actions = {
        ["up"]    = Actions.Move( 0,-1),
        ["down"]  = Actions.Move( 0, 1),
        ["left"]  = Actions.Move(-1, 0),
        ["right"] = Actions.Move( 1, 0)
    }

    if actions[key] ~= nil then
        self:doTurn(actions[key])
    end
end

function GameState:update(dt)
    self.entities:update(dt)
end

function GameState:draw()
    self.level:draw()
    self.entities:draw()
end

function GameState:doTurn(action)
    -- Get a list of turn taking entities (excluding our player)
    local ents = self.entities:filter(function(e)
        return e:is(TurnEntity) and e ~= self.player
    end)

    -- Player does a turn:
    local elapsedTime = self.player:doAction(action)

    -- Everyone else does a turn:
    for _, e in ipairs(ents) do
        ent:startTurn(elapsedTime)
        ent:doTurn()
    end
end

return GameState
