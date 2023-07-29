function love.load()
    radius = 90
    countdown_time = 0
    time_taken = 0
    finished = false
    countdown = 3
    num_mistakes = 0
    correct = {"p", "o", "l", "o"}
    current_index = 1
end

function love.keypressed(key)
    if key == "r" then
        love.load()
    elseif (countdown == 0) and (not finished) then
        local is_correct = key == correct[current_index]
        if not is_correct then
            num_mistakes = num_mistakes + 1
            if key == "p" then
                current_index = 2
            else
                current_index = 1
            end
        elseif current_index == 4 then
            current_index = 1
            radius = radius * 0.8
            if radius <= 0.7 then
                finished = true
            end
        else
            current_index = current_index + 1
        end
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
        local s
        if num_mistakes == 1  then
            s = ""
        else
            s = "s"
        end  
        love.graphics.print("with "..num_mistakes.." mistake"..s, 50, 100)
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
    end
end
