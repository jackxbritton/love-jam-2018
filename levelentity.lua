local LevelEntity = Entity:extend()

function LevelEntity:new(level)
    LevelEntity.super.new(self, 0, 0, 1, 1)

    self.level = level
end

function LevelEntity:moveDelta(dx, dy)
    self:moveTo(self.x + dx, self.y + dy)
end

function LevelEntity:moveTo(x, y)
    self.x = x
    self.y = y
end

function LevelEntity:draw()
    local x, y = self.x * self.level.tileWidth, self.y * self.level.tileHeight
    local w, h = self.width * self.level.tileWidth, self.height * self.level.tileHeight

    -- Hot pink is the best for temp graphics
    love.graphics.setColor(200,200,200)
    love.graphics.rectangle("fill", x, y, w, h)
end

return LevelEntity
