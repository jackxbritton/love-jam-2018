local Actions = require("actions")

local TurnEntity = require("levelentity"):extend()

function TurnEntity:new(...)
    TurnEntity.super.new(self, ...)

    self.actionPoints = 0
    self.speed = 100
end

function TurnEntity:startTurn(elapsedTime)
    self.actionPoints = self.actionPoints + elapsedTime * self.speed / 100
end

function TurnEntity:canDoAction(action)
    return self.actionPoints >= action.cost
end

function TurnEntity:doAction(action)
    while true do
        local result = action:execute(self)
        if result == true then
            self.actionPoints = self.actionPoints - action.cost

            -- Return the elapsedTime of the action
            return action.cost * 100 / self.speed
        elseif result == false or result == nil then
            return 0
        elseif result:is(Actions.Action) then
            action = result
        else
            error("Unknown action:execute return type: " .. tostring(result))
        end
    end
end

function TurnEntity:doTurn()
    -- Typically AI would happen here.
    --  AI would look like something that chooses an action to do until
    --  actionPoints is 0
end


return TurnEntity
