local Enemy = require("turnentity"):extend()
local Actions = require("actions")

function Enemy:new(level)
    Enemy.super.new(self, level)

    self.x, self.y = 3, 0
end

function Enemy:doTurn()
    while self.actionPoints >= 0 do
        local action = Actions.Move(0, 1)
        -- Double check that we can do the action
        if not self:canDoAction(action) then break end

        -- Do the action
        self:doAction(action)
    end
end

return Enemy
