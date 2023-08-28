function love.load(arg)
    num_boxes = 2
    box_size = 100
    mouse_pressed = false
    num_presses = 0
    human_score = 0
    ai_score = 0
    counts = {}
    for prev = 1, 4, 1 do
        local temp =  {}
        for curr = 1, 4, 1 do
            temp[curr] = 0
        end
        counts[prev] = temp
    end
    previous_box = 1
    local font = love.graphics.newFont(22)
    love.graphics.setFont(font)
end

function guess_box(curr_counts)
    local total = 0
    local cumsums = {}
    for box = 1, 4, 1 do
        total = total + curr_counts[box]
        cumsums[box] = total
    end
    if total > 0 then
        local r = math.random()
        for box = 1, 4, 1 do
            if r < cumsums[box] / total then
                return box
            end
        end
    else
        return math.random(1, 4)
    end
end

function choose_most_likely_box(curr_counts)
    local max_count = -1
    local best_box = 1
    for box, count in pairs(curr_counts) do
        if count > max_count then
            best_box = box
            max_count = count
        end
    end
    return best_box
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 500, 200, 2 * box_size, box_size)
    love.graphics.line(500 + box_size, 200, 500 + box_size, 200 + box_size)
    love.graphics.line(500, 250, 500 + 2 * box_size, 250)
    love.graphics.printf("HUMAN", 500, 212, 100, "center")
    love.graphics.printf(human_score, 500, 262, 100, "center")
    love.graphics.printf("AI", 600, 212, 100, "center")
    love.graphics.printf(ai_score, 600, 262, 100, "center")
    -- local text = "  HUMAN  |  AI\n----------------------\n          "..human_score.."    |  "..ai_score
    -- love.graphics.print(text, 420, 100)
    for col = 1, num_boxes, 1
    do
        for row = 1, num_boxes, 1
        do
            love.graphics.rectangle("line", col*box_size, row*box_size, box_size, box_size)
        end
    end
    if mouse_pressed then
        love.graphics.setColor(r, g, b)
        love.graphics.circle("line", box_x, box_y, 40)
    end
end

function love.mousepressed(x, y)
    true_box_x, true_box_y = find_box(x, y)
    if (100 <= true_box_x) and (true_box_x <= 300) and (100 <= true_box_y) and (true_box_y <= 300) then
        local pressed_box_i = (true_box_x - 50) / 100
        local pressed_box_j = (true_box_y - 50) / 100
        local pressed_box = num_boxes * (pressed_box_j - 1) + pressed_box_i
        mouse_pressed = true

        local temp = counts[previous_box]
        -- local guessed_box = choose_most_likely_box(temp)
        local guessed_box = guess_box(temp)
        local guessed_box_i = math.ceil(guessed_box / 2)
        local guessed_box_j = (guessed_box - 1) % 2 + 1
        box_x = guessed_box_j * 100 + 50
        box_y = guessed_box_i * 100 + 50
        if guessed_box == pressed_box then
            r, g, b = 0, 1, 0
            ai_score = ai_score + 1
        else
            r, g, b = 1, 0, 0
            human_score = human_score + 1
        end
        temp[pressed_box] = temp[pressed_box] + 1
        previous_box = pressed_box
    else
        mouse_pressed = false
    end
end

function find_box(mouse_x, mouse_y)
    box_x = (math.floor(mouse_x / box_size) + 0.5) * box_size
    box_y = (math.floor(mouse_y / box_size) + 0.5) * box_size
    return box_x, box_y
end
