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
    local rect = self:getScreenRect()

    -- Hot pink is the best for temp graphics
    love.graphics.setColor(200,200,200)
    love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
end

-- Couldn't figure out a better name. Get the rect representing the pixels that
--   this entity takes up. Useful for drawing operations. Note that this is before
--   any camera transformation operations
function LevelEntity:getScreenRect()
    return Rect(
        self.x * self.level.tileWidth,
        self.y * self.level.tileHeight,
        self.width * self.level.tileWidth,
        self.height * self.level.tileHeight
    )
end

return LevelEntity
