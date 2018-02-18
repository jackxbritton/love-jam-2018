local GameState = Object:extend()

local Camera = require("lib.hump.camera")

local Player  = require("entities.player")
local Enemy   = require("entities.enemy")
local TurnEntity   = require("turnentity")
local Level   = require("level")
local Group   = require("group")
local Actions = require("actions")


function GameState:new()
    self.level = Level()
    self.level:generate(50,50)
    -- self.level:loadFromFile("assets/maps/level.txt")

    self.entities = Group()
    self.player = Player(self.level)
    self.camera = Camera(0,0, 1)

    local room = self.level:getRandomRoom()
    self.player:moveTo(room:middle())

    local enemy = Enemy(self.level)
    local room = self.level:getRandomRoom()
    enemy:moveTo(room:middle())

    self:addEntity(self.player)
    self:addEntity(enemy)
end

function GameState:addEntity(ent)
    ent.gamestate = self
    self.entities:add(ent)
end

function GameState:keypressed(key, scancode, isrepeat)

    local actions = {
        ["up"]    = Actions.Move( 0,-1),
        ["down"]  = Actions.Move( 0, 1),
        ["left"]  = Actions.Move(-1, 0),
        ["right"] = Actions.Move( 1, 0),
        ["space"] = Actions.Move( 0, 0)
    }

    if actions[key] ~= nil then
        self:doTurn(actions[key])
    end
end

function GameState:update(dt)
    local playerRect = self.player:getScreenRect()
    self.camera:lookAt(playerRect:middle())

    self.entities:update(dt)
end

function GameState:draw()
    self.camera:attach()
    self.level:draw()
    self.entities:draw()
    self.camera:detach()
end

function GameState:doTurn(action)
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
end

return GameState
