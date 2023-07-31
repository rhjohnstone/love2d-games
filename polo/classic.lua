local hiscore_api = require "hiscores"
local utf8 = require("utf8")

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
    classic.checked_hiscore = false
    classic.got_hiscore = false
    classic.posted_hiscore = false
    classic.hiscore_input_lock = false
    classic.playername = ""
    classic.view_hiscores = false
    classic.hiscore_table = {}
end

function classic.textinput(t)
    if classic.hiscore_input_lock then
        classic.playername = classic.playername .. t
    end
end

function classic.keypressed(key)

    if key == "r" then
        if not (classic.hiscore_input_lock) then
            classic.load()
        end
    elseif (classic.countdown == 0) and (not classic.finished) then
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
    elseif classic.hiscore_input_lock then
        love.keyboard.setKeyRepeat(true)
        if key == "backspace" then
            -- get the byte offset to the last UTF-8 character in the string.
            local byteoffset = utf8.offset(classic.playername, -1)
    
            if byteoffset then
                -- remove the last UTF-8 character.
                -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
                classic.playername = string.sub(classic.playername, 1, byteoffset - 1)
            end
        end
        if key == "return" then
            classic.post_hiscore()
            love.keyboard.setKeyRepeat(false)
            classic.hiscore_input_lock = false
            classic.posted_hiscore = true
        end
    elseif (classic.posted_hiscore) and (not classic.view_hiscores) then
        if key == "return" then
            classic.view_hiscores = true
            classic.hiscore_table = hiscore_api.get_hiscores(5)
        end
    end
end

function classic.post_hiscore()
    hiscore_api.post_hiscore(classic.playername,classic.time_taken,classic.num_mistakes,'classic')
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
    elseif (classic.got_hiscore) and not (classic.posted_hiscore) then
        classic.hiscore_input_lock = true
    elseif (classic.finished) and not (classic.checked_hiscore) then
        classic.got_hiscore = hiscore_api.check_hiscore(classic.time_taken,'classic')
        classic.checked_hiscore = true
    end
end

function classic.draw()
    local font = love.graphics.newFont(36)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1)
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
        if classic.hiscore_input_lock then
            love.graphics.print("You got a hiscore!", 350, 200)
            love.graphics.print("Enter name: "..classic.playername, 350, 300)
        elseif classic.posted_hiscore then
            if not classic.view_hiscores then
                love.graphics.print("You got a hiscore!", 350, 200)
                love.graphics.print("Highscore submitted!", 350, 300)
                love.graphics.print("Return: view hiscores", 350, 400)
            else
                local col_a_x = 350
                local col_b_x = 500
                local basey = 200
                local spacing = 50
                local count = 0
                for k,v in pairs(classic.hiscore_table['score']) do 
                    love.graphics.print(classic.hiscore_table['name'][k],col_a_x,basey+count*spacing)
                    love.graphics.print(string.sub(v,0,5).." s",col_b_x,basey+count*spacing)
                    count = count+1
                end
            end
        end
        love.graphics.print("with "..classic.num_mistakes.." mistake"..s, 50, 100)

    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 200, 300, 100)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", 200, 300, classic.radius)
end

return classic
