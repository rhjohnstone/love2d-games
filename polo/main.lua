function love.load()
    radius = 90
    countdown_time = 0
    time_taken = 0
    finished = false
    countdown = 3
    current_polo = {"", "", "", ""}
    num_polo = 0
end

function love.keypressed(key)
    if key == "r" then
        love.load()
    elseif (countdown == 0) and (not finished) then
        for i = 1, 3, 1 do
            current_polo[i] =  current_polo[i + 1]
        end
        current_polo[4] = key
    end
end

function love.draw()
    local font = love.graphics.newFont(36)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press R to retry", 50, 500)
    if not finished then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Type POLO as fast as you can", 50, 50)
        local font = love.graphics.newFont(108)
        love.graphics.setFont(font)
        if countdown > 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf(countdown, 400, 250, 300, "center")
        else
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("GO!", 400, 250, 300, "center")
        end
    else
        love.graphics.setColor(1, 1, 1)
        local tt = tonumber(string.format("%.3f", time_taken))
        love.graphics.print("Finished in "..tt.." s", 50, 50)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 200, 300, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 200, 300, radius)
end

function love.update(dt)
    if countdown > 0 then
        countdown_time = countdown_time + dt
        if countdown_time >= 1 then
            countdown = countdown - 1
            countdown_time = 0
        end
    elseif not finished then
        time_taken = time_taken + dt
        if table.concat(current_polo) == "polo" then
            radius = radius * 0.8
            if radius <= 0.7 then
                finished = true
            else
                current_polo = {"", "", "", ""}
            end
        end
    end
end

