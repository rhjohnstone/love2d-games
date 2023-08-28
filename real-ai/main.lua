function love.load(arg)
    mouse_pressed = false
    num_presses = 0
    human_score = 0
    ai_score = 0
    local font = love.graphics.newFont(22)
    love.graphics.setFont(font)
end


function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 500, 200, 2 * 100, 100)
    love.graphics.line(500 + 100, 200, 500 + 100, 200 + 100)
    love.graphics.line(500, 250, 500 + 2 * 100, 250)
    love.graphics.printf("HUMAN", 500, 212, 100, "center")
    love.graphics.printf(human_score, 500, 262, 100, "center")
    love.graphics.printf("AI", 600, 212, 100, "center")
    love.graphics.printf(ai_score, 600, 262, 100, "center")
    for col = 1, 3, 1
    do
        for row = 1, 3, 1
        do
            love.graphics.rectangle("line", col*100, row*100, 100, 100)
        end
    end
    love.graphics.print("Press R to restart", 50, 500)
    if mouse_pressed then
        love.graphics.setColor(r, g, b)
        love.graphics.circle("line", guessed_x, guessed_y, 40)
    end
end


function click2center(mouse_x, mouse_y)
    local center_x = (math.floor(mouse_x / 100) + 0.5) * 100
    local center_y = (math.floor(mouse_y / 100) + 0.5) * 100
    return center_x, center_y
end


function click_in_play_area(x, y)
    return (100 <= x) and (x <= 400) and (100 <= y) and (y <= 400)
end


function love.mousepressed(x, y)
    mouse_pressed = click_in_play_area(x, y)
    if mouse_pressed then
        local center_x, center_y = click2center(x, y)
        if math.random() < prob_cheat(num_presses) then
            guessed_x, guessed_y = cheat(center_x, center_y)
        else
            guessed_x, guessed_y = guess()
        end
        num_presses = num_presses + 1
        if (guessed_x == center_x) and (guessed_y == center_y) then
            r, g, b = 0, 1, 0
            ai_score = ai_score + 1
        else
            r, g, b = 1, 0, 0
            human_score = human_score + 1
        end
    end
end


function love.keypressed(key)
    if key == "r" then
        love.load()
    end
end


function cheat(center_x, center_y)
    return center_x, center_y
end


function guess()
    local guessed_box = math.random(9)
    local i = math.ceil(guessed_box / 3)
    local j = (guessed_box - 1) % 3 + 1
    local guessed_x = 100 * j + 50
    local guessed_y = 100 * i + 50
    return guessed_x, guessed_y
end


function prob_cheat(num_presses)
    local t = math.floor(num_presses / 5)
    return 0.8 / (1 + math.exp(-(t - 5) / 3))
end
