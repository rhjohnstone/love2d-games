function love.load()
    radius = 90
    countdown_time = 0
    time_taken = 0
    finished = false
    countdown = 3
    current_polo = {"", "", "", ""}
    all_keys = {}
end

function love.keypressed(key)
    if key == "r" then
        love.load()
    elseif (countdown == 0) and (not finished) then
        table.insert(all_keys, key)
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
        local full_string = table.concat(all_keys)
        local num_mistakes = count_mistakes(full_string)
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
        if table.concat(current_polo) == "polo" then
            radius = radius * 0.8
            if radius <= 0.7 then
                finished = true
                -- TODO: count_mistakes()
            else
                current_polo = {"", "", "", ""}
            end
        end
    end
end


function count_mistakes(s, current_count)
    current_count = current_count or 0
    if s:len() == 0 then
        return current_count
    else
        for i = 1, #s do
            local c = s:sub(i, i)
            if c ~= "p" then
                current_count = current_count + 1
            elseif s:sub(i+1, i+1) ~= "o" then
                local remainder = s:sub(i+1)
                current_count = current_count + 1
                return count_mistakes(remainder, current_count)
            elseif s:sub(i+2, i+2) ~= "l" then
                local remainder = s:sub(i+2)
                current_count = current_count + 1
                return count_mistakes(remainder, current_count)
            elseif s:sub(i+3, i+3) ~= "o" then
                local remainder = s:sub(i+3)
                current_count = current_count + 1
                return count_mistakes(remainder, current_count)
            else
                local remainder = s:sub(i+4)
                return count_mistakes(remainder, current_count)
            end
        end
        return current_count
    end
end
