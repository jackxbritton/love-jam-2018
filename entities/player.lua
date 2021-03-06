local Player = require("actorentity"):extend()
local Weapon = require("weapon")

Gamestate = require("lib.hump.gamestate")

function Player:new(level)
    Player.super.new(self, level)

    self.weapon = Weapon()
    self.weapon.damage = 40
end

function Player:doAction(action)
    local elapsedTime = Player.super.doAction(self, action)

    -- Reset action points as we can assume our action consumes all avaliable
    self.actionPoints = 0

    return elapsedTime
end

function Player:onDeath()
    Gamestate.switch(require("states.menu"))
end

function Player:__tostring()
    return string.format("Player(%d, %d)", self.x, self.y)
end

return Player
