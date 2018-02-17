local Player = Entity:extend()


function Player:new()
    Player.super.new(self, 0,0, 20,20)

    self.mapX, self.mapY = 0,0
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
