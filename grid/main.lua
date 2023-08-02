local cell_size = 32
local speed = 10

function cell2pixels(i, j)
    local x = j * cell_size
    local y = i * cell_size
    return x, y
end

function love.load()
    local i, j, x, y
    i, j = 8, 8
    x, y = cell2pixels(i, j)
	player = {i=i, j=j, x=x, y=y}
    i, j = 8, 10
    x, y = cell2pixels(i, j)
	block = {i=i, j=j, x=x, y=y}
	map = {
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
		{ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
		{ 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
		{ 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1 },
		{ 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
		{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
	}
    for i, row in ipairs(map) do
        for j, v in ipairs(row) do
            if v == 1 then
                row[j] = "wall"
            elseif (player.i == i) and (player.j == j) then
                row[j] = "player"
            elseif (block.i == i) and (block.j == j) then
                row[j] = "block"
            else
                row[j] = false
            end
        end
    end
end

function move(object, dt)
    local x, y = cell2pixels(object.i, object.j)
    local scale = speed * dt
	object.x = object.x - ((object.x - x) * scale)
	object.y = object.y - ((object.y - y) * scale)
end

function love.update(dt)
    move(player, dt)
    move(block, dt)
end

function love.draw()
    for i, row in ipairs(map) do
        for j, v in ipairs(row) do
            if v == "wall" then
                love.graphics.setColor(1, 1, 1)
                local x, y = cell2pixels(i, j)
                love.graphics.rectangle("line", x, y, cell_size, cell_size)
            elseif v == "player" then
                love.graphics.setColor(0, 1, 0)
                love.graphics.rectangle("fill", player.x, player.y, cell_size, cell_size)
            elseif v == "block" then
                love.graphics.setColor(0, 0, 1)
                love.graphics.rectangle("fill", block.x, block.y, cell_size, cell_size)
            end
        end
	end
end

function love.keypressed(key)
    local i, j = player.i, player.j
	if key == "up" then
        local above = map[i - 1][j]
        if not above then
            player.i = i - 1
            map[i][j] = false
            map[i-1][j] = "player"
        elseif (above == "block") and (not map[i-2][j]) then
            player.i = i - 1
            map[i][j] = false
            map[i-1][j] = "player"
            block.i = block.i - 1
            map[i-2][j] = "block"
        end
    elseif key == "down" then
        local below = map[i + 1][j]
        if not below then
            player.i = i + 1
            map[i][j] = false
            map[i+1][j] = "player"
        elseif (below == "block") and (not map[i+2][j]) then
            player.i = i + 1
            map[i][j] = false
            map[i+1][j] = "player"
            block.i = block.i + 1
            map[i+2][j] = "block"
        end
    elseif key == "left" then
        local left = map[i][j-1]
        if not left then
            player.j = j - 1
            map[i][j] = false
            map[i][j-1] = "player"
        elseif (left == "block") and (not map[i][j-2]) then
            player.j = j - 1
            map[i][j] = false
            map[i][j-1] = "player"
            block.j = block.j - 1
            map[i][j-2] = "block"
        end
    elseif key == "right" then
        local right = map[i][j+1]
        if not right then
            player.j = j + 1
            map[i][j] = false
            map[i][j+1] = "player"
        elseif (right == "block") and (not map[i][j+2]) then
            player.j = j + 1
            map[i][j] = false
            map[i][j+1] = "player"
            block.j = block.j + 1
            map[i][j+2] = "block"
        end
    end
end
