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
    local ww,wh = love.graphics.getDimensions()

    local x, y = self.x * ww/self.level.w, self.y * wh/self.level.h
    local w, h = self.width * ww/self.level.w, self.height * wh/self.level.h

    -- Hot pink is the best for temp graphics
    love.graphics.setColor(255,105,180)
    love.graphics.rectangle("fill", x, y, w, h)
end

return LevelEntity
