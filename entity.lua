local Entity = Rect:extend()

function Entity:new(x, y, w, h)
    Entity.super.new(self, x, y, w, h)
    self.dead = false
end

function Entity:update(dt)

end

function Entity:draw()

end

return Entity
