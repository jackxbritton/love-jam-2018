local Enemy = require("actorentity"):extend()
local Actions = require("actions")

function Enemy:new(level)
    Enemy.super.new(self, level)

    self.x, self.y = 3, 2
    self.speed = 70
end

function Enemy:doTurn()
    while self.actionPoints >= 0 do
        local player = self.gameState.player
        local path = self.level:getPath(self.x, self.y, player.x, player.y)
        local next = path[2]
        if next then
            local dx,dy = next.x - self.x, next.y - self.y
            local action = Actions.Move(dx, dy)

            -- Double check that we can do the action
            if not self:canDoAction(action) then break end

            -- Do the action
            local elapsedTime = self:doAction(action)

            if elapsedTime <= 0 then -- Prevent infinite loop
                return
            end
        else
            break
        end
    end
end

function Enemy:__tostring()
    return string.format("Enemy(%d, %d)", self.x, self.y)
end

return Enemy
