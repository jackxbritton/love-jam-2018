local Entity = Rect:extend()

function Entity:new(x, y, w, h)
    Entity.super.new(self, x, y, w, h)
    self.dead = false
end

function Entity:update(dt)
end

function Entity:draw()
end

function Entity:onAdd()
end

function Entity:onRemove()
end

function Entity:__tostring()
    return string.format("Entity(%d, %d, %d, %d)", self.x, self.y, self.width, self.height)
end

return Entity
