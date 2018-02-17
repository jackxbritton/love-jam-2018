local Enemy = require("turnentity"):extend()
local Actions = require("actions")

function Enemy:new(level)
    Enemy.super.new(self, level)

    self.x, self.y = 3, 2
end

function Enemy:doTurn()
    while self.actionPoints >= 0 do
        local player = self.gamestate.player
        local path = self.level:getPath(self.x, self.y, player.x, player.y)
        local next = path[2]
        if next then
            local dx,dy = next.x - self.x, next.y - self.y
            local action = Actions.Move(dx, dy)

            -- Double check that we can do the action
            if not self:canDoAction(action) then break end

            -- Do the action
            self:doAction(action)
        else
            break
        end
    end
end

return Enemy
