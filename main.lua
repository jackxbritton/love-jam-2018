function love.load()
end

function love.update(dt)
end

function love.draw()
    w, h = love.graphics.getDimensions()
    love.graphics.printf("Hello World!", w/2, h/2, 0, "center")
end
