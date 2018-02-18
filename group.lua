local Entity = require("entity")

local Group = Entity:extend()

function Group:new()
    Group.super.new(self)
    self.members = {}
end

function Group:add(e, idx)
    assert(e and e:is(Entity), "bad entity")
    if idx then
        table.insert(self.members, idx, e)
    else
        table.insert(self.members, e)
    end

    e.parent = self

    e:onAdd()
end


function Group:remove(e)
    e:onRemove()
    table.remove(self.members, lume.find(self.members, e))
end

function Group:filter(predicate)
    local ents = {}
    for _, ent in ipairs(self.members) do
        if predicate(ent) then
            table.insert(ents, ent)
        end
    end

    return ents
end

function Group:update(dt)
    -- Update
    for i = #self.members, 1, -1 do
        local e = self.members[i]
        e:update(dt)
    end

    -- Purge dead
    for i = #self.members, 1, -1 do
        local e = self.members[i]
        if e.dead then self:remove(e) end
    end
end

function Group:draw()
    lume.each(self.members, "draw")
end

return Group
