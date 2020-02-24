title_screen = {}

local initialized = false
local big_font = nil
local small_font = nil
local wait_for_input = 3

local blue = nil
local pinky = nil

local keys_wasd = nil
local keys_arrows = nil

local function initialize()
    -- https://www.dafont.com/pecita.font
    big_font = love.graphics.newFont("assets/Pecita.otf", 48)
    small_font = love.graphics.newFont("assets/Pecita.otf", 24)
    
    blue = make_an_animation({
        make_a_sprite("assets/whale.swim.1.png", 0.5, 0.4),
        make_a_sprite("assets/whale.swim.2.png", 0.5, 0.4)
    }, 4)
    
    pinky = make_an_animation({
        make_a_sprite("assets/pinky.swim.2.png", 0.5, 0.4),
        make_a_sprite("assets/pinky.swim.1.png", 0.5, 0.4)
    }, 4)
    
    keys_wasd = make_a_sprite("assets/keys.wasd.png", 0.5, 0.5)
    keys_arrows = make_a_sprite("assets/keys.arrows.png", 0.5, 0.5)
    
    initialized = true
end
    
title_screen['start'] = function()
    if not initialized then
        initialize()
        wait_for_input = 0
    else
        wait_for_input = 3
    end
end

title_screen['update'] = function(dt)
    if wait_for_input > 0 then
        wait_for_input = wait_for_input - dt
    elseif love.keyboard.isDown("space") then
        go_to(playing)
    end
    
    blue.update(dt)
    pinky.update(dt)
end

title_screen['draw'] = function()
    love.graphics.setBackgroundColor(254/255, 249/255, 240/255)

    love.graphics.setColor(255/255, 255/255, 255/255)
    blue.draw(WIDTH/2 - 40, HEIGHT/2 - 10, 1)
    pinky.draw(WIDTH/2 + 40, HEIGHT/2 - 10, -1)

    keys_wasd.draw(WIDTH/2 - 75, HEIGHT*2/3 + 50, 1)
    keys_arrows.draw(WIDTH/2 + 75, HEIGHT*2/3 + 50, 1)

    love.graphics.setColor(65/255, 45/255, 78/255)

    love.graphics.setFont(big_font)
    love.graphics.print(TITLE, WIDTH/2 - 200, HEIGHT/2 - 100)

    love.graphics.setFont(small_font)
    love.graphics.print('or', WIDTH/2 - 10, HEIGHT*2/3 + 40)
    
    if wait_for_input <= 0 then
        love.graphics.print('SPACEBAR to start playing', WIDTH/2 - 140, HEIGHT/2 + 50)
    end
end
