-- function love.draw()
--     love.graphics.setColor(1, 1, 1)
--     love.graphics.rectangle("line", 100, 200, 100, 100)
--     love.graphics.rectangle("line", 150, 150, 80, 80)
--     love.graphics.line(100, 200, 150, 150)
--     love.graphics.line(200, 200, 230, 150)
--     love.graphics.line(100, 300, 150, 230)
--     love.graphics.line(200, 300, 230, 230)
-- end

function create_point(x, y, z)
    local radius = math.sqrt(3 * 0.5^2)
    return {x=(x-0.5)/radius, y=(y-0.5)/radius, z=(z-0.5)/radius}
end

function cart2polar(x, y, z)
    local phi = math.acos(x / math.sqrt(x^2 + y^2))
    local theta = math.acos(z)
    return phi, theta
end

function rotate(x, y, z, alpha, beta, gamma)
    local cA = math.cos(alpha)
    local sA = math.sin(alpha)
    local cB = math.cos(beta)
    local sB = math.sin(beta)
    local cC = math.cos(gamma)
    local sC = math.sin(gamma)
    local new_x = cB*cC*x + (sA*sB*cC-cA*sC)*y + (cA*sB*cC+sA*sC)*z
    local new_y = cB*sC*x + (sA*sB*sC+cA*cC)*y + (cA*sB*sC-sA*cC)*z
    local new_z = -sB*x + sA*cB*y + cA*cB*z
    return {x=new_x, y=new_y, z=new_z}
end

function love.load(arg)

    offset = 200
    y_offset = 0.2

    alpha = 0
    beta = 0
    gamma = 0

    mouse_pressed = false

    points = {}
    points[1] = create_point(0, 0, 1)
    points[2] = create_point(0, 1, 1)
    points[3] = create_point(1, 1, 1)
    points[4] = create_point(1, 0, 1)
    points[5] = create_point(0, 0, 0)
    points[6] = create_point(0, 1, 0)
    points[7] = create_point(1, 1, 0)
    points[8] = create_point(1, 0, 0)

    edges = {
        {1, 2}, {2, 3}, {3, 4}, {4, 1},
        {5, 6}, {6, 7}, {7, 8}, {8, 5},
        {1, 5}, {2, 6}, {3, 7}, {4, 8},
    }
end

function love.draw()
    if mouse_pressed then
        alpha = alpha + 0.01
    end
    for k, edge in pairs(edges) do

        local source = edge[1]
        local destn = edge[2]

        local p1 = points[source]
        local rotated_xyz1 = rotate(p1["x"], p1["y"], p1["z"], alpha, beta, gamma)
        local y1 = rotated_xyz1["y"]
        local x1 = rotated_xyz1["x"] * (1 - y_offset*y1)
        local z1 = rotated_xyz1["z"] * (1 - y_offset*y1)

        local p2 = points[destn]
        local rotated_xyz2 = rotate(p2["x"], p2["y"], p2["z"], alpha, beta, gamma)
        local y2 = rotated_xyz2["y"]
        local x2 = rotated_xyz2["x"] * (1 - y_offset*y2)
        local z2 = rotated_xyz2["z"] * (1 - y_offset*y2)

        if (destn <= 4) and ((destn - source) % 4 == 1) then
            love.graphics.setColor(0, 1, 0)
        elseif (5 <= destn) and ((destn - source) % 4 == 1) then
            love.graphics.setColor(0, 0, 1)
        else
            love.graphics.setColor(1, 0, 0)
        end

        local x1_draw = offset + 100 * x1
        local z1_draw = offset + 100 * z1
        local x2_draw = offset + 100 * x2
        local z2_draw = offset + 100 * z2
        love.graphics.line(x1_draw, z1_draw, x2_draw, z2_draw)
    end
end

function love.mousepressed()
    mouse_pressed = true
end

function love.mousereleased()
    mouse_pressed = false
end