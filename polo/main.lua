local game_state = "menu"
local menu_options = {"Classic", "Survival", "Time trial"}
local selected_menu_item = 1

local classic = require("classic")
local survival = require("survival")
local time_trial = require("time_trial")
local game_modes = {["Classic"]=classic, ["Survival"]=survival, ["Time trial"]=time_trial}

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

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Polo", 0, 150, window_width, 'center')

    for i = 1, #menu_options do
        if i == selected_menu_item then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.printf(menu_options[i], 0, start_y + menu_font_height * (i-1), window_width, 'center')
    end
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
    elseif (key == 'return') or (key == 'kpenter') then
        game_state = menu_options[selected_menu_item]
        game_modes[game_state].load()
    end
end

function love.keypressed(key)
    if key == "m" then
        game_state = "menu"
    elseif game_state  == "menu" then
        menu_keypressed(key)
    else
        game_modes[game_state].keypressed(key)
    end
end

function love.draw()
    if game_state == "menu" then
        draw_menu(menu_options, selected_menu_item, menu_font_height, window_width)
    else
        local font = love.graphics.newFont(36)
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Press R to retry, M for main menu", 50, 500)
        game_modes[game_state].draw()
        -- local font = love.graphics.newFont(36)
        -- love.graphics.setFont(font)
        -- love.graphics.setColor(1, 1, 1)
        --love.graphics.print("Coming soon...", 50, 100)
        --love.graphics.print("Press M for main menu.", 50, 550)
    end
end

function love.update(dt)
    if game_state ~= "menu" then
        game_modes[game_state].update(dt)
    end
end
