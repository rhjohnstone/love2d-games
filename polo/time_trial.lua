local time_trial = {}
local correct = {"p", "o", "l", "o"}
local end_radius = 0.7
local start_radius = 90
local radius_scale = 0.8
local time_available = 10
local diff = (start_radius - end_radius) / time_available

function time_trial.load()
    time_trial.current_index = 1
    time_trial.num_mistakes = 0
    time_trial.finished = false
    time_trial.radius = start_radius
    time_trial.countdown = 3
    time_trial.countdown_time = 0
    time_trial.num_polo = 0
end

function time_trial.keypressed(key)
    if key == "r" then
        time_trial.load()
    elseif (time_trial.countdown == 0) and (not time_trial.finished) then
        local is_correct = key == correct[time_trial.current_index]
        if not is_correct then
            time_trial.num_mistakes = time_trial.num_mistakes + 1
            if key == "p" then
                time_trial.current_index = 2
            else
                time_trial.current_index = 1
            end
        elseif time_trial.current_index == 4 then
            time_trial.num_polo = time_trial.num_polo + 1
            time_trial.current_index = 1
        else
            time_trial.current_index = time_trial.current_index + 1
        end
    end
end

function time_trial.update(dt)
    if time_trial.countdown > 0 then
        time_trial.countdown_time = time_trial.countdown_time + dt
        if time_trial.countdown_time >= 1 then
            time_trial.countdown = time_trial.countdown - 1
            time_trial.countdown_time = 0
        end
    elseif not time_trial.finished then
        time_trial.radius = time_trial.radius - diff * dt
        if time_trial.radius <= end_radius then
            time_trial.finished = true
        end
    end
end

function time_trial.draw()
    local font = love.graphics.newFont(36)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    if not time_trial.finished then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Type POLO as fast as you can", 50, 50)
        local font = love.graphics.newFont(108)
        love.graphics.setFont(font)
        if time_trial.countdown > 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf(time_trial.countdown, 400, 250, 300, "center")
        else
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("GO!", 400, 250, 300, "center")
        end
    else
        love.graphics.setColor(1, 1, 1)
        local s1
        if time_trial.num_polo == 1  then
            s1 = ""
        else
            s1 = "s"
        end  
        love.graphics.print("Typed "..time_trial.num_polo.." POLO"..s1, 50, 50)
        local s2
        if time_trial.num_mistakes == 1  then
            s2 = ""
        else
            s2 = "s"
        end
        love.graphics.print("with "..time_trial.num_mistakes.." mistake"..s2, 50, 100)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 200, 300, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 200, 300, time_trial.radius)
end

return time_trial
