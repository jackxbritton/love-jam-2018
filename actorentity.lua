local ActorEntity = require("turnentity"):extend()

function ActorEntity:new(...)
    ActorEntity.super.new(self, ...)

    self.maxHealth = 100
    self.health = self.maxHealth
    self.armor = 0.0
    self.weapon = nil
end

function ActorEntity:takeDamage(damage)
    local scaling = 1 + self.armor
    self.health = (self.health * scaling - damage) / scaling

    if self.health <= 0 then
        self.dead = true
        self:onDeath()
    end
end

function ActorEntity:heal(amount)
    self.health = math.min(self.maxHealth, self.health + amount)
end

function ActorEntity:canAttack(target)
    -- This will help enemies not attack other enemies, and the like
    if self.weapon == nil then
        return false
    end

    return true
end

function ActorEntity:attack(target)
    if not self:canAttack(target) then
        return false
    end

    local damage = self.weapon.damage
    target:takeDamage(damage)

    return true
end

function ActorEntity:onDeath()
end

return ActorEntity
