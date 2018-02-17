local GameState = Object:extend()

local Player  = require("entities.player")
local Level   = require("level")
local Group   = require("group")
local Actions = require("actions")


function GameState:new()
    self.level = Level(4, 4)
    self.entities = Group()
    self.player = Player()

    self.entities:add(self.player)
end

function GameState:keypressed(key, scancode, isrepeat)
    local action = nil

    if key == "up" then
        action = Actions.Move(0, -1)
    elseif key == "down" then
        action = Actions.Move(0, 1)
    elseif key == "left" then
        action = Actions.Move(-1, 0)
    elseif key == "right" then
        action = Actions.Move(1, 0)
    end

    if action ~= nil then
        self:doTurn(action)
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
