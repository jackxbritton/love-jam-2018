local Player = require("turnentity"):extend()


function Player:new(mapW, mapH)
    Player.super.new(self, 0,0, 1,1)

    self.x,self.y = 0,0
    self.mapW,self.mapH = mapW,mapH
end

function Player:doAction(action)
    local elapsedTime = Player.super.doAction(self, action)

    -- Reset action points as we can assume our action consumes all avaliable
    self.actionPoints = 0

    if (action.action == "Move") then
        self:moveDelta(unpack(action.direction))
    end

    return elapsedTime
end

function Player:moveDelta(dx, dy)
    self:moveTo(self.x + dx, self.y + dy)
end

function Player:moveTo(x, y)
    self.x = x
    self.y = y
end

function Player:draw()

    local w, h = love.graphics.getDimensions()
    local dx, dy = w / self.mapW, h / self.mapH

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x*dx, self.y*dy, self.width*dx, self.height*dy)

end


return Player
