local Player = require("actorentity"):extend()


function Player:new(level)
    Player.super.new(self, level)

    self.x, self.y = 3, 8
end

function Player:doAction(action)
    local elapsedTime = Player.super.doAction(self, action)

    -- Reset action points as we can assume our action consumes all avaliable
    self.actionPoints = 0

    return elapsedTime
end

function Player:__tostring()
    return string.format("Player(%d, %d)", self.x, self.y)
end

return Player
