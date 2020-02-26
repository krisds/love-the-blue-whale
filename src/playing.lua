playing = {}

local initialized = false
local font = nil


local whale = nil
local blue_animation = nil
local pinky = nil
local pinky_animation = nil
local whales = {}

local blue_heart_sprite = nil
local pinky_heart_sprite = nil
local boat_sprite = nil
local submarine_animation = nil
local plane_sprite = nil

local level = 0
local give_timeout = 0
local hearts = {}
local boats = {}
local submarines = {}
local planes = {}
local particles = {}

function target_number_of_boats()
    return math.floor((level+1)/3)
end

function add_a_boat()
    local dir = random_direction()
    local acceleration = dir * math.random(0.015, 0.025)
    
    local x = -50
    if dir < 0 then x = WIDTH + 50 end

    local boat = make_a_thing(
        boat_sprite,
        x, HEIGHT,
        54/2, dir * 0.02
    )

    boat.direction = dir
    boat.steer = function(thing, dt)
        if thing.in_the_water() then
            thing.vx = thing.vx + acceleration
        end
    end
    boat.world_interaction = floating
    
    boats[#boats+1] = boat
end

function spawn_boats()
    if #boats < target_number_of_boats() then 
        add_a_boat()
    end
    
    shedule(2.5, spawn_boats)
end


function bob()
    local x = 0
    local y = 0
    local step_x = 0
    local step_y = 0
    return function(thing)
        if step_x == 0 then
            x = thing.x
            y = thing.y
            
            step_x = math.random(0, STEPS/2)
            step_y = step_x + 67
        end
        
        thing.x = x + SIN[step_x] * 10
        thing.y = y + SIN[step_y] * 30

        step_x = (step_x + 14) % STEPS
        step_y = (step_y + 20) % STEPS
    end
end

function target_number_of_hearts()
    return 2 + math.floor(level/3)
end

function add_a_heart()
    local heart = make_a_thing(
        blue_heart_sprite,
        math.random(100,WIDTH-100),
        math.min(OCEAN_LEVEL + math.random(16 + 2 * level, 40 + 5 * level), HEIGHT - 30),
        16/2
    )
    
    heart.steer = bob()
    
    hearts[#hearts + 1] = heart
end

function spawn_hearts()
    if #hearts < target_number_of_hearts() then
        add_a_heart()
    end
    
    shedule(0.5, spawn_hearts)
end


function target_number_of_submarines()
    if level < 6 then return 0 end
    if level < 12 then return 1 end
    return 2
end

function add_a_submarine()
    local dir = random_direction()
    local speed = dir * math.random(0.8, 1.4)
    
    local x = -50
    if dir < 0 then x = WIDTH + 50 end

    local submarine = make_a_thing(
        submarine_animation,
        x,
        OCEAN_LEVEL - math.random(50, 150),
        48/2
    )
    
    submarine.direction = dir
    submarine.steer = function(sub, dt)
        sub.x = sub.x + speed
    end
    
    submarines[#submarines+1] = submarine
end

function spawn_submarines()
    if #submarines < target_number_of_submarines() then
        add_a_submarine()
    end
    
    shedule(5, spawn_submarines)
end


function target_number_of_planes()
    if level < 10 then return 0 end
    if level < 20 then return 1 end
    return 2
end

function add_a_plane()
    local dir = random_direction()
    local x = -50
    if dir < 0 then x = WIDTH + 50 end

    local plane = make_a_thing(
        plane_sprite,
        x,
        math.random(HEIGHT-30, OCEAN_LEVEL+50),
        48/2
    )
    
    plane.direction = dir
    plane.steer = function(plane, dt)
        plane.x = plane.x + dir * 4
        -- TODO Up and down a bit ?
    end
    
    planes[#planes+1] = plane
end

function spawn_planes()
    if #planes < target_number_of_planes() then
        add_a_plane()
    end
    
    shedule(20, spawn_planes)
end


function target_number_of_waves()
    if level < 2 then return 0 end
    if level < 4 then return 1 end
    if level < 8 then return 2 end
    if level < 16 then return 3 end
    if level < 32 then return 4 end
    return 5
end

function add_a_wave()
    local dir = -1
    if #waves % 2 == 1 then dir = 1 end

    local amplitude = 4 + #waves * 2
    local speed = 8 + #waves * 2

    waves[#waves+1] = make_a_wave(amplitude, speed,  dir)
end

function spawn_waves()
    if #waves < target_number_of_waves() then
        add_a_wave()
    end
    
    shedule(10, spawn_waves)
end

function add_pinky()
    if not pinky then
        pinky = make_a_thing(pinky_animation, WIDTH * 1/4, OCEAN_LEVEL/2, 48/2)
        pinky.steer = function(pinky, dt)
            pinky.x = pinky.x + 1.1
            -- TODO Up and down a bit
        end
    end
    
    pinky.x = -50
    whales[#whales+1] = pinky
end

function spawn_pinky()
    if #whales == 0 then add_pinky() end
    
    shedule(30, spawn_pinky)
end


local function initialize()
    -- https://www.dafont.com/pecita.font
    font = love.graphics.newFont("assets/Pecita.otf", 24)
    
    local blue_swim_animation = make_an_animation({
        make_a_sprite("assets/whale.swim.1.png", 0.5, 0.4),
        make_a_sprite("assets/whale.swim.2.png", 0.5, 0.4)
        }, 4)
        
    local blue_hurt_sprite = make_a_sprite("assets/whale.hurt.png", 0.5, 0.4)
    
    blue_animation = make_state_based_animation()
    blue_animation.define('swimming', blue_swim_animation)
    blue_animation.define('hurt', blue_hurt_sprite, 1, 'swimming')
    blue_animation.play('swimming')
    
    local pinky_swim_animation = make_an_animation({
        make_a_sprite("assets/pinky.swim.1.png", 0.5, 0.4),
        make_a_sprite("assets/pinky.swim.2.png", 0.5, 0.4)
        }, 4)

    local pinky_hurt_sprite = make_a_sprite("assets/pinky.hurt.png", 0.5, 0.4)

    pinky_animation = make_state_based_animation()
    pinky_animation.define('swimming', pinky_swim_animation)
    pinky_animation.define('hurt', pinky_hurt_sprite, 1, 'swimming')
    pinky_animation.play('swimming')

    blue_heart_sprite = make_a_sprite("assets/heart.blue.png", 0.5, 0.9)
    pinky_heart_sprite = make_a_sprite("assets/heart.pinky.png", 0.5, 0.9)
    boat_sprite = make_a_sprite("assets/boat.png", 0.6, 0.6)
    plane_sprite = make_a_sprite("assets/plane.png", 0.7, 0.5)
    
    submarine_animation = make_an_animation({
        make_a_sprite("assets/submarine.1.png", 0.5, 0.6),
        make_a_sprite("assets/submarine.2.png", 0.5, 0.6)
    }, 8)
    
    initialized = true
end
    
playing['start'] = function()
    if not initialized then initialize() end
    
    level = 0
    hearts_collected = 0
    blue_hearts = 0
    pinky_hearts = 0
    give_timeout = 0
    hearts = {}
    boats = {}
    submarines = {}
    planes = {}
    particles = {}
    
    -- First the ocean/waves
    shedule(0.5, spawn_waves)

    -- Then its inhabitants.
    whale = make_a_thing(blue_animation, WIDTH * 1/2, OCEAN_LEVEL - 10, 48/2)
    whale.world_interaction = floating

    shedule(1, spawn_pinky)
    
    -- Initial hearts to be gotten.
    for i = 1,2 do add_a_heart() end
    -- Then make sure we keep 'em coming.
    shedule(0.5, spawn_hearts)

    -- Get traffic going...
    shedule(1, spawn_boats)
    shedule(10, spawn_submarines)
    shedule(10, spawn_planes)
end

local pauzed = false
-- function love.keypressed( key, scancode, isrepeat )
--     if key == "space" then pauzed = not pauzed end
-- end

playing['update'] = function(dt)
    if pauzed then return end
    
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        whale.direction = 1
        whale.accelerate(0.03, 0)
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        whale.direction = -1
        whale.accelerate(-0.03, 0)
    end
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        whale.accelerate(0, 0.1)
    end
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        whale.accelerate(0, -0.1)
    end

    update_sheduler(dt)
    update_waves(dt)
    update_things(boats, dt)
    update_things(submarines, dt)
    update_things(planes, dt)
    update_things(hearts, dt)
    update_things(whales, dt)
    update_things(particles, dt)

    whale.update(dt)
    whale.limit(10, WIDTH - 10)
    
    if give_timeout > 0 then give_timeout = give_timeout - dt end
    
    on_collisions(whale, hearts, function(_, heart)
        heart.delete()
        blue_hearts = blue_hearts + 1
        hearts_collected = hearts_collected + 1
        if not plop_sound:isPlaying() then plop_sound:play() end
    end)

    on_collisions(whale, boats, function(_, boat)
        boat.delete()
        blue_hearts = blue_hearts - 1
        blue_animation.play('hurt')
        if not hit_sound:isPlaying() then hit_sound:play() end
    end)

    on_collisions(whale, submarines, function(_, sub)
        sub.delete()
        blue_hearts = blue_hearts - 2
        blue_animation.play('hurt')
        if not hit_sound:isPlaying() then hit_sound:play() end
    end)
    
    on_collisions(whale, planes, function(_, plane)
        plane.delete()
        blue_hearts = blue_hearts - 3
        blue_animation.play('hurt')
        if not hit_sound:isPlaying() then hit_sound:play() end
    end)
    
    on_collisions(whale, whales, function(_, pinky)
        if give_timeout <= 0 and blue_hearts > 0 then
            pinky_hearts = pinky_hearts + 1
            blue_hearts = blue_hearts - 1
            give_timeout = 0.5
            particles[#particles + 1] = make_a_particle(pinky_heart_sprite, whale.x, whale.y)
            if not plop2_sound:isPlaying() then plop2_sound:play() end
        end
    end)

    if pinky ~= null and pinky.x > 50 and pinky.x < WIDTH - 50 then
        on_collisions(pinky, submarines, function(_, sub)
            sub.delete()
            pinky_hearts = pinky_hearts - 2
            pinky_animation.play('hurt')
            if not hit_sound:isPlaying() then hit_sound:play() end
        end)
    end
    
    level = math.max(level, 1 + math.floor((blue_hearts + pinky_hearts)/3))
    
    if blue_hearts < 0 or pinky_hearts < 0 then
        -- blue_hearts = 0
        clear_sheduler()
        go_to(game_over)
    end
end

playing['draw'] = function()
    love.graphics.setFont(font)
    love.graphics.setBackgroundColor(254/255, 249/255, 240/255)

    love.graphics.setColor(174/255, 232/255, 251/255, 100/255)
    for x = 0, WIDTH do
        local h1 = ocean_level(x, 1)
        love.graphics.rectangle("fill", x, HEIGHT - h1, 1, h1 )
    end

    love.graphics.setColor(255/255, 255/255, 255/255)
    draw_things(boats)
    
    for x = 0, WIDTH do
        local h = ocean_level(x)
        love.graphics.setColor(174/255, 232/255, 251/255, 200/255)
        love.graphics.rectangle("fill", x, HEIGHT - h, 1, h)
        love.graphics.setColor(170/255, 230/255, 255/255, 255/255)
        love.graphics.rectangle("fill", x, HEIGHT - h * DEEP_OCEAN, 1, h * DEEP_OCEAN)
    end

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    draw_things(submarines)
    draw_things(hearts)
    draw_things(planes)
    draw_things(whales)
    whale.draw()
    draw_things(particles)
    
    love.graphics.setColor(65/255, 45/255, 78/255)
    love.graphics.print(blue_hearts, 42, 20)
    love.graphics.print(pinky_hearts, 42, 45)
    -- love.graphics.print('@' .. level, WIDTH - 42, 20)

    love.graphics.setColor(255/255, 255/255, 255/255)
    blue_heart_sprite.draw(30, 36)
    pinky_heart_sprite.draw(30, 60)
end
