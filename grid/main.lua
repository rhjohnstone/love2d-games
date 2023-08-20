local cell_size = 32
local num_cells = 10
local speed = 10


function build_empty_map()
    local map = {}
    for i = 1, num_cells do
        local row = {}
        for j = 1, num_cells do
            row[j] = false
        end
        map[i] = row
    end
    return map
end

function cell2pixels(i, j)
    local x = j * cell_size
    local y = i * cell_size
    return x, y
end

function new_block(i, j, r, g, b)
    local block = {}
    block.i, block.j = i, j
    block.x, block.y = cell2pixels(i, j)
    block.r, block.g, block.b = r, g, b
    return block
end

function random_block()
    local i = math.random(num_cells)
    local j = math.random(num_cells)
    while map[i][j] do
        i = math.random(num_cells)
        j = math.random(num_cells)
    end
    local r = math.random()
    local g = math.random() / 2
    local b = math.random()
    local block = new_block(i, j, r, g, b)
    map[i][j] = block
    return block
end

function index_ok(i, j)
    return (1 <= i) and (i <= num_cells) and (1 <= j) and (j <= num_cells)
end

index_steps = {up={i=-1, j=0}, down={i=1, j=0}, left={i=0, j=-1}, right={i=0, j=1}}

function love.keypressed(key)
    local steps = index_steps[key]
    if steps ~= nil then
        local i_step, j_step = steps.i, steps.j
        local i, j = player.i, player.j
        local blocks_to_move = {}
        local can_move = false
        local ii = i + i_step
        local jj = j + j_step
        while index_ok(ii, jj) do
            local block = map[ii][jj]
            if block then
                table.insert(blocks_to_move, block)
            else
                can_move = true
                break
            end
            ii = ii + i_step
            jj = jj + j_step
        end
        if can_move then
            map[i][j] = false
            player.i = i + i_step
            player.j = j + j_step
            map[player.i][player.j] = player
            for i, block in ipairs(blocks_to_move) do
                block.i = block.i + i_step
                block.j = block.j + j_step
                map[block.i][block.j] = block
            end
        end
    end
end



function love.load()
    math.randomseed(os.time())
    map = build_empty_map()

    local i, j = 8, 8
    player = new_block(i, j, 0, 1, 0)
    map[i][j] = player

    blocks = {}
    while #blocks < 4 do
        local block = random_block()
        table.insert(blocks, block)
    end
    -- local i, j, x, y
    -- i, j = 8, 8
    -- x, y = cell2pixels(i, j)
	-- player = {i=i, j=j, x=x, y=y}
    -- i, j = 8, 10
    -- x, y = cell2pixels(i, j)
	-- block = {i=i, j=j, x=x, y=y}

    -- -- From the tutorial: https://love2d.org/wiki/Tutorial:Gridlocked_Player
	-- map = {
	-- 	{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
	-- 	{ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
	-- 	{ 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
	-- 	{ 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1 },
	-- 	{ 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	-- 	{ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	-- 	{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
	-- }

    -- -- I convert it into my format
    -- for i, row in ipairs(map) do
    --     for j, v in ipairs(row) do
    --         if v == 1 then
    --             row[j] = "wall"
    --         elseif (player.i == i) and (player.j == j) then
    --             row[j] = player
    --         elseif (block.i == i) and (block.j == j) then
    --             row[j] = block
    --         else
    --             row[j] = false
    --         end
    --     end
    -- end
end

function move(object, dt)
    local x, y = cell2pixels(object.i, object.j)
    local scale = speed * dt
	object.x = object.x - ((object.x - x) * scale)
	object.y = object.y - ((object.y - y) * scale)
end

function love.update(dt)
    move(player, dt)
    for i, block in ipairs(blocks) do
        move(block, dt)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    for i = 1, num_cells do
        for j = 1, num_cells do
            local x, y = cell2pixels(i, j)
            love.graphics.rectangle("line", x, y, cell_size, cell_size)
        end
    end
    love.graphics.setColor(player.r, player.g, player.b)
    love.graphics.rectangle("fill", player.x, player.y, cell_size, cell_size)
    for i, block in ipairs(blocks) do
        love.graphics.setColor(block.r, block.g, block.b)
        love.graphics.rectangle("fill", block.x, block.y, cell_size, cell_size)
    end
end


-- function love.keypressed(key)
--     local i, j = player.i, player.j
--     if (key ==  "up") then
--         move_vertically("up")
--     elseif  (key == "down") then
--         move_vertically("down")
    
-- 	-- if (key == "up") and (i > 1) then
--     --     local above = map[i - 1][j]
--     --     if not above then
--     --         player.i = i - 1
--     --         map[i][j] = false
--     --         map[i-1][j] = player
--     --     elseif (above == block) and (not map[i-2][j]) then
--     --         player.i = i - 1
--     --         map[i][j] = false
--     --         map[i-1][j] = player
--     --         block.i = block.i - 1
--     --         map[i-2][j] = block
--     --     end
--     -- elseif (key == "down") and (i < num_cells) then
--     --     local below = map[i + 1][j]
--     --     if not below then
--     --         player.i = i + 1
--     --         map[i][j] = false
--     --         map[i+1][j] = player
--     --     elseif (below == block) and (not map[i+2][j]) then
--     --         player.i = i + 1
--     --         map[i][j] = false
--     --         map[i+1][j] = player
--     --         block.i = block.i + 1
--     --         map[i+2][j] = block
--     --     end
--     elseif (key == "left") and (j > 1) then
--         local left = map[i][j-1]
--         if not left then
--             player.j = j - 1
--             map[i][j] = false
--             map[i][j-1] = player
--         elseif (left == block) and (not map[i][j-2]) then
--             player.j = j - 1
--             map[i][j] = false
--             map[i][j-1] = player
--             block.j = block.j - 1
--             map[i][j-2] = block
--         end
--     elseif (key == "right") and (j < num_cells) then
--         local right = map[i][j+1]
--         if not right then
--             player.j = j + 1
--             map[i][j] = false
--             map[i][j+1] = player
--         elseif (right == block) and (not map[i][j+2]) then
--             player.j = j + 1
--             map[i][j] = false
--             map[i][j+1] = player
--             block.j = block.j + 1
--             map[i][j+2] = block
--         end
--     end
-- end
