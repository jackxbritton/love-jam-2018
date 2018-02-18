local Weapon = Object:extend()

function Weapon:new()
    self.name = "Weapon"
    self.damage = 0
end

function Weapon:__tostring()
    return string.format("Weapon(name=%s, damage=%d)", self.name, self.damage)
end

return Weapon
