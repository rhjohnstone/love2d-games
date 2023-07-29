local game_state = "menu"
local menu_options = {"Classic", "Survival", "Time trial"}
local selected_menu_item = 1

function love.load()
    window_width, window_height = love.graphics.getDimensions()
end

function draw_menu()
    local menu_font = love.graphics.setNewFont(30)
    local menu_font_height = menu_font:getHeight()

    local horizontal_center = window_width / 2
    local vertical_center = window_height / 2
    local start_y = vertical_center - (menu_font_height * (#menu_options / 2))
  
    -- draw guides to help check if menu items are centered, can remove later
    -- love.graphics.setColor(1, 1, 1, 0.1)
    -- love.graphics.line(horizontal_center, 0, horizontal_center, window_height)
    -- love.graphics.line(0, vertical_center, window_width, vertical_center)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Polo", 0, 150, window_width, 'center')

    for i = 1, #menu_options do
        if i == selected_menu_item then
            love.graphics.setColor(1, 1, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.printf(menu_options[i], 0, start_y + menu_font_height * (i-1), window_width, 'center')
    end
end

function classic_load()
    radius = 90
    countdown_time = 0
    time_taken = 0
    finished = false
    countdown = 3
    num_mistakes = 0
    correct = {"p", "o", "l", "o"}
    current_index = 1
end

function time_trial_load()
    time_trial_time = 10
    start_radius = 90
    end_radius = 0.7
    diff = (start_radius - end_radius) / time_trial_time
    finished = false
    countdown = 3
    countdown_time = 0
    time_taken = 0
end

function menu_keypressed(key)
    if key == 'up' then
        selected_menu_item = selected_menu_item - 1
        if selected_menu_item < 1 then
            selected_menu_item = #menu_options
        end
    elseif key == 'down' then
        selected_menu_item = selected_menu_item + 1
        if selected_menu_item > #menu_options then
            selected_menu_item = 1
        end
    elseif key == 'return' or key == 'kpenter' then
        game_state = menu_options[selected_menu_item]
        if game_state == "Classic" then
            classic_load()
        elseif game_state == "Time trial" then
            time_trial_load()
        end
    end
end

function classic_keypressed(key)
    if key == "r" then
        classic_load()
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

function love.keypressed(key)
    if key == "m" then
        game_state = "menu"
    elseif game_state  == "menu" then
        menu_keypressed(key)
    elseif game_state  == "Classic" then
        classic_keypressed(key)
    end
end

function love.draw()
    if game_state == "menu" then
        draw_menu(menu_options, selected_menu_item, menu_font_height, window_width)
    elseif game_state == "Classic" then
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
            local tt = string.format("%.3f", time_taken)    
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
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Coming soon...", 50, 100)
        love.graphics.print("Press M for main menu.", 50, 500)
    end
end

function classic_update(dt)
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

function time_trial_update(dt)
    if countdown > 0 then
        countdown_time = countdown_time + dt
        if countdown_time >= 1 then
            countdown = countdown - 1
            countdown_time = 0
        end
    elseif not finished then
        time_taken = time_taken + dt
        radius = start_radius - diff * time_taken
        if radius <= end_radius then
            finished = true
        end
    end
end

function love.update(dt)
    if game_state == "Classic" then
        classic_update(dt)
    elseif game_state == "Time trial" then
        time_trial_update(dt)
    end
end
