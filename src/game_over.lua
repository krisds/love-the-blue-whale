game_over = {}

local initialized = false
local big_font = nil
local small_font = nil
local wait_for_input = 3
local blue_heart = nil
local pinky_heart = nil
local blue = nil
local pinky = nil

local score = 0

local function initialize()
    -- https://www.dafont.com/pecita.font
    big_font = love.graphics.newFont("assets/Pecita.otf", 48)
    small_font = love.graphics.newFont("assets/Pecita.otf", 24)
    
    blue_heart = make_a_sprite("assets/heart.blue.png", 0.5, 0.9)
    pinky_heart = make_a_sprite("assets/heart.pinky.png", 0.5, 0.9)
    
    local blue_swim_animation = make_an_animation({
        make_a_sprite("assets/whale.swim.1.png", 0.5, 0.4),
        make_a_sprite("assets/whale.swim.2.png", 0.5, 0.4)
        }, 4)
        
    local blue_hurt_sprite = make_a_sprite("assets/whale.hurt.png", 0.5, 0.4)
    
    blue = make_state_based_animation()
    blue.define('swimming', blue_swim_animation)
    blue.define('hurt', blue_hurt_sprite, 1, 'hurt')
    blue.play('swimming')
    
    local pinky_swim_animation = make_an_animation({
        make_a_sprite("assets/pinky.swim.1.png", 0.5, 0.4),
        make_a_sprite("assets/pinky.swim.2.png", 0.5, 0.4)
        }, 4)
        
    local pinky_hurt_sprite = make_a_sprite("assets/pinky.hurt.png", 0.5, 0.4)
    
    pinky = make_state_based_animation()
    pinky.define('swimming', pinky_swim_animation)
    pinky.define('hurt', pinky_hurt_sprite, 1, 'hurt')
    pinky.play('swimming')
    
    initialized = true
end
    
game_over['start'] = function()
    if not initialized then initialize() end
    wait_for_input = 3
    
    if blue_hearts < 0 then
        blue_hearts = 0
        blue.play("hurt")
    else
        blue.play("swimming")
    end
    
    if pinky_hearts < 0 then
        pinky_hearts = 0 
        pinky.play("hurt")
    else
        pinky.play("swimming")
    end
    
    score = hearts_collected * 100 + blue_hearts + pinky_hearts
end

game_over['update'] = function(dt)
    if wait_for_input > 0 then
        wait_for_input = wait_for_input - dt
    elseif love.keyboard.isDown("space") then
        go_to(title_screen)
    end

    blue.update(dt)
    pinky.update(dt)
end

game_over['draw'] = function()
    love.graphics.setBackgroundColor(254/255, 249/255, 240/255)

    love.graphics.setColor(255/255, 255/255, 255/255)

    blue.draw(WIDTH/2 - 40, HEIGHT/2 - 10, 1)
    pinky.draw(WIDTH/2 + 40, HEIGHT/2 - 10, -1)

    blue_heart.draw(WIDTH/2 - 120, HEIGHT/2, 1)
    pinky_heart.draw(WIDTH/2 + 100, HEIGHT/2, 1)

    love.graphics.setColor(65/255, 45/255, 78/255)

    love.graphics.setFont(big_font)
    love.graphics.print("Game over", WIDTH/2 - 120, HEIGHT/2 - 120)

    love.graphics.setFont(small_font)
    love.graphics.print("You scored " .. score .. " points !", WIDTH/2 - 120, HEIGHT/2 - 70)
    love.graphics.print(blue_hearts, WIDTH/2 - 112, HEIGHT/2 - 10)
    love.graphics.print(pinky_hearts, WIDTH/2 + 110, HEIGHT/2 - 10)

    if wait_for_input <= 0 then
        love.graphics.setFont(small_font)
        love.graphics.print('SPACEBAR to return to title screen', WIDTH/2 - 175, HEIGHT/2 + 50)
    end
end
