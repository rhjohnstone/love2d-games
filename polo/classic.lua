local classic = {}
local correct = {"p", "o", "l", "o"}
local end_radius = 0.7
local radius_scale = 0.8

function classic.load()
    classic.current_index = 1
    classic.num_mistakes = 0
    classic.finished = false
    classic.radius = 90
    classic.countdown = 3
    classic.countdown_time = 0
    classic.time_taken = 0
end

function classic.keypressed(key)
    if key == "r" then
        classic.load()
    elseif not classic.finished then
        local is_correct = key == correct[classic.current_index]
        if not is_correct then
            classic.num_mistakes = classic.num_mistakes + 1
            if key == "p" then
                classic.current_index = 2
            else
                classic.current_index = 1
            end
        elseif classic.current_index == 4 then
            classic.current_index = 1
            classic.radius = classic.radius * radius_scale
            if classic.radius <= end_radius then
                classic.finished = true
            end
        else
            classic.current_index = classic.current_index + 1
        end
    end
end

function classic.update(dt)
    if classic.countdown > 0 then
        classic.countdown_time = classic.countdown_time + dt
        if classic.countdown_time >= 1 then
            classic.countdown = classic.countdown - 1
            classic.countdown_time = 0
        end
    elseif not classic.finished then
        classic.time_taken = classic.time_taken + dt
    end
end

function classic.draw()
    local font = love.graphics.newFont(36)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press R to retry", 50, 500)
    if not classic.finished then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Type POLO as fast as you can", 50, 50)
        local font = love.graphics.newFont(108)
        love.graphics.setFont(font)
        if classic.countdown > 0 then
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf(classic.countdown, 400, 250, 300, "center")
        else
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("GO!", 400, 250, 300, "center")
        end
    else
        love.graphics.setColor(1, 1, 1)
        local tt = string.format("%.3f", classic.time_taken)    
        love.graphics.print("Finished in "..tt.." s", 50, 50)
        local s
        if classic.num_mistakes == 1  then
            s = ""
        else
            s = "s"
        end  
        love.graphics.print("with "..classic.num_mistakes.." mistake"..s, 50, 100)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 200, 300, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 200, 300, classic.radius)
end

return classic
