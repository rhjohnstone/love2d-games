--stats = require("stats")

function love.load()
	window_width = 600
	window_height = 800
	love.window.setMode(window_width, window_height)
	love.window.setTitle("Circle")
	centre = {x=window_width/2, y=window_height/2}
	mouse_path = {}
	context = "menu"
	collided = false
	angles_ok = false
	end_ok = false
	angle = 0
	radius = 100
	alpha = 1
	start_radius = 10
	title = {x=centre.x, y=centre.y, r=100}
	succeeded = false
	font_size = title.r / 2
	font = love.graphics.newFont(font_size)
	height = font:getHeight()
	love.graphics.setFont(font)
	drawing = true
end

function mouse_in_circle(circle)
	local x, y = love.mouse.getPosition()
	return (x - circle.x)^2 + (circle.y - y)^2 <= circle.r^2
end


function draw_circle(circle)
	love.graphics.circle("fill", circle.x, circle.y, circle.r)
end
	

function love.draw()

	
	love.graphics.setColor(1, 1, 1)
	draw_circle(title)
	
	local text = "CIRCLE"
	local width = font:getWidth(text)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(text, title.x - width/2, title.y - height/2)
	
	local text = "COMING SOON"
	local width = font:getWidth(text)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("COMING SOON", title.x - width/2, title.y + 100 + height/2)
	
	if drawing then
		local r, g, b = 1, 1, 1
		if love.mouse.isDown(1) then
			r, g, b = 1, 1, 1
		elseif succeeded then
			r, g, b = 0, 1, 0
		else
			r, g, b = 1, 0, 0
		end
		love.graphics.setColor(r, g, b, alpha)
		if alpha > 0 then
			if start ~= nil then
				draw_circle(start)
			end
			if #mouse_path >= 4 then
				love.graphics.setLineWidth(2)
				love.graphics.line(mouse_path)
			end
		end
	end
end

function love.mousepressed()
	end_ok = false
	evaluated = false
	mouse_path = {}
	collided = false
	local x, y = love.mouse.getPosition()
	start = {x=x, y=y, r=start_radius}
	x_prev = x - centre.x
	y_prev = centre.y - y
	angle_sum = 0
end

function love.mousereleased()
	succeeded = mouse_in_circle(start) and (not collided) and (math.abs(angle_sum) > 2*math.pi - 0.05)
end


function love.update(dt)
	if love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition()
		table.insert(mouse_path, x)
		table.insert(mouse_path, y)
		collided = collided or mouse_in_circle(title)
		alpha = 1
		
		x = x - centre.x
		y = centre.y - y
		
		local diff = math.atan((y * x_prev - x * y_prev) / (x * x_prev + y * y_prev))
		angle_sum = angle_sum + diff
		x_prev = x
		y_prev = y
	elseif not succeeded then
		alpha = math.max(0, alpha - dt/2)
	else
		alpha = math.max(0, alpha - dt/2)
		if alpha == 0 then
			title.r = title.r + 50*dt
		end
		--drawing = false
	end
end

-- function find_centre(mouse_path)
	-- local x_mean = 0
	-- local y_mean = 0
	-- local num_points = #mouse_path
	-- for i = 1, num_points, 2 do
		-- local x = mouse_path[i]
		-- local y = mouse_path[i + 1]
		-- x_mean = x_mean + x
		-- y_mean = y_mean + y
	-- end
	-- x_mean = x_mean / (num_points / 2)
	-- y_mean = y_mean / (num_points / 2)
	-- return x_mean, y_mean
-- end

-- function normalize(x)
	-- local mean = stats.mean(x)
	-- local result = {}
	-- for i, v in ipairs(x) do
		-- result[i] = v / mean
	-- end
	-- return result
-- end

-- function score(std)
	-- return 100 * (1 - std)
-- end

-- function evaluate_circle(mouse_path)
	-- local x_centre, y_centre = find_centre(mouse_path)
	-- local num_points = #mouse_path
	-- local rs = {}
	-- for i = 1, num_points, 2 do
		-- local x = mouse_path[i]
		-- local y = mouse_path[i + 1]
		-- local r = ((x - x_centre)^2 + (y - y_centre)^2)^.5
		-- table.insert(rs, r)
	-- end
	-- r_mean = stats.mean(rs)
	-- approx_points = 5.657 * r_mean
	-- r_points = #rs
	-- local std = stats.std(normalize(rs))
	-- return score(std)
-- end
