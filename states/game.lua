local GameState = Object:extend()

local Camera = require("lib.hump.camera")
local shash  = require("lib.shash")

local Player  = require("entities.player")
local Enemy   = require("entities.enemy")
local TurnEntity   = require("turnentity")
local Level   = require("level")
local Group   = require("group")
local Actions = require("actions")
local Weapon  = require("weapon")
local Enemies = require("data.enemies")


function GameState:new()
    self.level = Level()
    self.level:generate(50,50)
    -- self.level:loadFromFile("assets/maps/level.txt")

    self.entityTracker = shash.new(1)
    self.entities = Group()
    self.player = Player(self.level)
    self.camera = Camera(0,0, 1)

    self:addEntity(self.player)

    local room = self.level:getRandomRoom()
    self.player:moveTo(room:middle())

    for i=1, 10 do
        self:createEnemy("bacteria")
    end

    self.level:checkFOV(self.player.x, self.player.y)
end

function GameState:addEntity(ent)
    ent.gameState = self
    ent.entityTracker = self.entityTracker
    self.entities:add(ent)
end

function GameState:createEnemy(enemyname, x, y)
    if x == nil then
        -- Get position if not provided
        local room = self.level:getRandomRoom()
        x = room.x + love.math.random(0, room.width)
        y = room.y + love.math.random(0, room.height)

        -- TODO: Verify that no entity exists here already, if so retry
    end

    local template = Enemies[enemyname]

    local enemy = Enemy(self.level)
    self:addEntity(enemy)

    local weapon = Weapon()
    weapon.name = template.weapon.name
    weapon.damage = template.weapon.damage

    enemy.speed = template.speed
    enemy.armor = template.armor
    enemy.weapon = weapon

    enemy:moveTo(x, y)
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

    self.level:checkFOV(self.player.x, self.player.y)
end

return GameState
