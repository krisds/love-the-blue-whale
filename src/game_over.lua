game_over = {}

local initialized = false
local big_font = nil
local small_font = nil
local wait_for_input = 3
local blue_heart = nil
local pinky_heart = nil

local function initialize()
    -- https://www.dafont.com/pecita.font
    big_font = love.graphics.newFont("assets/Pecita.otf", 48)
    small_font = love.graphics.newFont("assets/Pecita.otf", 24)
    
    blue_heart = make_a_sprite("assets/heart.blue.png", 0.5, 0.9)
    pinky_heart = make_a_sprite("assets/heart.pinky.png", 0.5, 0.9)
    
    initialized = true
end
    
game_over['start'] = function()
    if not initialized then initialize() end
    wait_for_input = 3
end

game_over['update'] = function(dt)
    if wait_for_input > 0 then
        wait_for_input = wait_for_input - dt
    elseif love.keyboard.isDown("space") then
        go_to(title_screen)
    end
end

game_over['draw'] = function()
    love.graphics.setBackgroundColor(254/255, 249/255, 240/255)

    love.graphics.setColor(255/255, 255/255, 255/255)
    blue_heart.draw(WIDTH/2 - 40, HEIGHT/2 - 10, 1)
    pinky_heart.draw(WIDTH/2 + 40, HEIGHT/2 - 10, 1)

    love.graphics.setColor(65/255, 45/255, 78/255)

    love.graphics.setFont(big_font)
    love.graphics.print("Game Over", WIDTH/2 - 120, HEIGHT/2 - 100)

    love.graphics.setFont(small_font)
    love.graphics.print(hearts_collected, WIDTH/2 - 32, HEIGHT/2 - 20)
    love.graphics.print(hearts_given, WIDTH/2 + 50, HEIGHT/2 - 20)

    if wait_for_input <= 0 then
        love.graphics.setFont(small_font)
        love.graphics.print('SPACEBAR to return to title screen', WIDTH/2 - 170, HEIGHT/2 + 50)
    end
end
