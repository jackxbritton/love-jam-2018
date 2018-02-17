local Player = require("turnentity"):extend()


function Player:new()
    Player.super.new(self, 0,0, 20,20)

    self.mapX, self.mapY = 0,0
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

function Player:moveDelta(dx, dy)
    local nx = self.mapX + dx
    local ny = self.mapY + dy

    self:moveTo(nx, ny)
end

function Player:moveTo(nx, ny)
    self.mapX = nx
    self.mapY = ny

    self.x = nx * 20
    self.y = ny * 20
end

function Player:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


return Player
