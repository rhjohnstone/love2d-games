local survival = {}
local correct = {"p", "o", "l", "o"}
local end_radius = 0.7
local start_radius = 90
local radius_scale = 0.8
local time_available = 10
local diff = (start_radius - end_radius) / time_available

function survival.load()
    survival.current_index = 1
    survival.num_mistakes = 0
    survival.finished = false
    survival.radius = start_radius
    survival.countdown = 3
    survival.countdown_time = 0
    survival.num_polo = 0
    survival.time_taken = 0
end

function survival.keypressed(key)
    if key == "r" then
        survival.load()
    elseif (survival.countdown == 0) and (not survival.finished) then
        local is_correct = key == correct[survival.current_index]
        if not is_correct then
            survival.finished = true
        elseif survival.current_index == 4 then
            survival.num_polo = survival.num_polo + 1
            survival.current_index = 1
            survival.radius = survival.radius * radius_scale
            if (survival.radius <= end_radius) or (survival.radius >= start_radius) then
                radius_scale = 1 / radius_scale
            end
        else
            survival.current_index = survival.current_index + 1
        end
    end
end

function survival.update(dt)
    if survival.countdown > 0 then
        survival.countdown_time = survival.countdown_time + dt
        if survival.countdown_time >= 1 then
            survival.countdown = survival.countdown - 1
            survival.countdown_time = 0
        end
    elseif not survival.finished then
        survival.time_taken  = survival.time_taken + dt
    end
end

function survival.draw()
    local font = love.graphics.newFont(36)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press R to retry", 50, 500)
    if not survival.finished then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Type POLO as carefully as you can", 50, 50)
        local font = love.graphics.newFont(108)
        love.graphics.setFont(font)
        if survival.countdown > 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf(survival.countdown, 400, 250, 300, "center")
        else
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("GO!", 400, 250, 300, "center")
        end
    else
        love.graphics.setColor(1, 1, 1)
        local s1
        if survival.num_polo == 1  then
            s1 = ""
        else
            s1 = "s"
        end  
        love.graphics.print("Typed "..survival.num_polo.." POLO"..s1, 50, 50)
        local tt = string.format("%.3f", survival.time_taken)
        love.graphics.print("in "..tt.." s", 50, 100)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 200, 300, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 200, 300, survival.radius)
end

return survival
