-- Base Action class
local Action = Object:extend()
function Action:new(action, cost)
    self.action = action
    self.cost = cost
    self.alternative = nil
end

function Action:execute(ent)
    -- Stub
end

function Action:__tostring()
    return string.format("%s(cost = %d)", self.action, self.cost)
end

-- Attack action, attack another entity
local Attack = Action:extend()
function Attack:new(target)
    Attack.super.new(self, "Attack", 100)
    self.target = target
end

function Attack:execute(ent)
    -- Stub for now
    ent:attack(self.target)
    return true
end

-- Rest action that just waits for 100 action points
local Rest = Action:extend()
function Rest:new()
    Rest.super.new(self, "Rest", 100)
end

function Rest:execute(ent)
    return true
end

-- Movement action, represents moving 1 tile
local Move = Action:extend()
function Move:new(dx, dy)
    Move.super.new(self, "Move", 100)
    self.direction = {dx, dy}
end

function Move:execute(ent)
    -- Requiring ActorEntity in here to prevent a require-loop
    local ActorEntity = require("actorentity")

    if (self.direction[1] == 0 and self.direction[2] == 0) then
        return Rest()
    end

    if ent:moveDelta(unpack(self.direction)) then
        return true
    else
        -- Moving failed, lets check and see why.
        local nx, ny = ent.x + self.direction[1], ent.y + self.direction[2]

        -- Check for if we can attack anyone
        if ent:is(ActorEntity) then
            local ents = ent:getEntitiesAt(nx, ny)
            for _, otherent in ipairs(ents) do
                if otherent:is(ActorEntity) and ent:canAttack(otherent) then
                    return Attack(otherent)
                end
            end
        end

        -- Nothing else to do, just fail this action.
        return false
    end
end

return {
    Action = Action,
    Attack = Attack,
    Move = Move,
    Rest = Rest
}
