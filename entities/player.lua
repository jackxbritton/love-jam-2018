local Player = require("turnentity"):extend()


function Player:new(level)
    Player.super.new(self, level)

    self.x, self.y = 0, 0
end

function Player:doAction(action)
    local elapsedTime = Player.super.doAction(self, action)

    -- Reset action points as we can assume our action consumes all avaliable
    self.actionPoints = 0

    if (action.action == "Move") then
        self:moveDelta(unpack(action.direction))
    end

    return elapsedTime
end

return Player
