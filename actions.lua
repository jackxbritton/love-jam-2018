-- Base Action class
local Action = Object:extend()
function Action:new(action, cost)
    self.action = action
    self.cost = cost
end

function Action:__tostring()
    return string.format("%s(cost = %d)", self.action, self.cost)
end

-- Movement action, represents moving 1 tile
local Move = Action:extend()
function Move:new(dx, dy)
    Move.super.new(self, "Move", 100)
    self.direction = {dx, dy}
end

return {
    Action = Action,
    Move = Move
}
