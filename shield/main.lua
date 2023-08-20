function love.load()

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, false)
    world:setCallbacks(beginContact)

    thickness = 100
    ball_radius = 20
    shield_radius = 30
    need_to_remove_shield = false

    enemy_speed = 1
    enemy_follows = true
    cooldown = 2
    
    ball = {}
    ball.shield = false
    ball.body = love.physics.newBody(world, 650/4, 650/4, "dynamic")
    update_ball(ball, ball_radius)

    enemy = {}
    enemy.body = love.physics.newBody(world, 3*650/4, 3*650/4, "dynamic")
    update_ball(enemy, ball_radius)
    set_enemy_velocity()

    borders = {}
    borders.ground = {}
    borders.ground.body = love.physics.newBody(world, 650/2, 650)
    borders.left_wall = {}
    borders.left_wall.body = love.physics.newBody(world, 0, 650/2)
    borders.right_wall = {}
    borders.right_wall.body = love.physics.newBody(world, 650, 650/2)
    borders.ceiling = {}
    borders.ceiling.body = love.physics.newBody(world, 650/2, 0)
    make_shapes_and_fixtures(borders, thickness)

    love.graphics.setBackgroundColor(55/255, 126/255, 184/255)
    love.window.setMode(650, 650)
    love.window.setTitle("Shield Test")
end

function make_shapes_and_fixtures(borders, thickness)
    borders.ground.shape = love.physics.newRectangleShape(650, thickness)
    borders.ground.fixture = love.physics.newFixture(borders.ground.body, borders.ground.shape)
    borders.left_wall.shape = love.physics.newRectangleShape(thickness, 650)
    borders.left_wall.fixture = love.physics.newFixture(borders.left_wall.body, borders.left_wall.shape)
    borders.right_wall.shape = love.physics.newRectangleShape(thickness, 650)
    borders.right_wall.fixture = love.physics.newFixture(borders.right_wall.body, borders.right_wall.shape)
    borders.ceiling.shape = love.physics.newRectangleShape(650, thickness)
    borders.ceiling.fixture = love.physics.newFixture(borders.ceiling.body, borders.ceiling.shape)
end

function draw_polygon(object)
    love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
end

function love.draw()
    love.graphics.setColor(152/255, 78/255, 163/255)
    for k, object in pairs(borders) do
        draw_polygon(object)
    end

    local x_ball, y_ball = ball.body:getPosition()
    love.graphics.setColor(255/255, 127/255, 0/255)
    love.graphics.circle("fill", x_ball, y_ball, ball_radius)
    if ball.shield then
        local width = love.graphics.getLineWidth()
        love.graphics.setColor(228/255, 26/255, 28/255)
        love.graphics.setLineWidth(2*shield_health*width)
        love.graphics.circle("line", x_ball, y_ball, shield_radius)
        love.graphics.setLineWidth(width)
    end
    local x_enemy, y_enemy = enemy.body:getPosition()
    love.graphics.setColor(77/255, 175/255, 74/255)
    love.graphics.circle("fill", x_enemy, y_enemy, ball_radius)
end

function update_ball(object, radius)
    object.shape = love.physics.newCircleShape(radius)
    if object.fixture ~= nil then
        object.fixture:destroy()
    end
    object.fixture = love.physics.newFixture(object.body, object.shape, 1)
    object.fixture:setRestitution(0.9)
end

function love.keypressed(key)
    if key == "s" then
        ball.shield = true
        shield_health = 3
        update_ball(ball, shield_radius)
    end
end

function love.update(dt)
    world:update(dt)
    if need_to_remove_shield then
        ball.shield = false
        update_ball(ball, ball_radius)
        need_to_remove_shield = false
    end
    if enemy_follows then
        set_enemy_velocity()
    elseif cooldown > 0 then
        cooldown = cooldown - dt
    else
        enemy_follows = true
        cooldown = 2
    end

    local value =  400
    if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
        ball.body:applyForce(value, 0)
    elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
        ball.body:applyForce(-value, 0)
    elseif love.keyboard.isDown("up") then --press the left arrow key to push the ball to the left
        ball.body:applyForce(0, -value)
    elseif love.keyboard.isDown("down") then --press the left arrow key to push the ball to the left
        ball.body:applyForce(0, value)
    end
end

function beginContact(a, b)
    if ((a == ball.fixture) and (b == enemy.fixture)) or ((a == enemy.fixture) and (b == ball.fixture)) then
        enemy_follows = false
        if ball.shield then
            shield_health = shield_health - 1
            if shield_health == 0 then
                need_to_remove_shield = true
            end
        end
    end
end

function set_enemy_velocity()
    local x_ball, y_ball = ball.body:getPosition()
    local x_enemy, y_enemy = enemy.body:getPosition()

    local x_diff = x_ball - x_enemy
    local y_diff = y_ball - y_enemy

    local diff = math.sqrt(x_diff^2 + y_diff^2)

    local x_speed = enemy_speed * x_diff
    local y_speed = enemy_speed * y_diff
    enemy.body:setLinearVelocity(x_speed, y_speed)
end

-- Can we block the enemy's vision so it doesn't know where we are?
-- e.g. if there is a wall in the middle of the map, we hide behind it, it stops chasing
