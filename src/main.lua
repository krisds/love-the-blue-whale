require("constants")
require("util")
require("sheduler")
require("sprites")
require("ocean")
require("objects")
require("sound")

-- Game states :
require("title_screen")
require("playing")
require("game_over")

local state = nil

hearts_collected = 0
hearts_given = 0


function go_to(new_state)
    state = new_state
    state.start()
end

function love.load()
    love.window.setTitle(TITLE .. " - LÖVE Jam 2020")
    love.window.setIcon(love.image.newImageData("assets/whale.swim.1.png"))
    love.window.setMode(WIDTH, HEIGHT, {resizable=false, vsync=true})
    
    initialize_sounds()
    
    go_to(title_screen)
    ocean_waves_sound:play()
end

function love.update(dt)
    state.update(dt)
end

function love.draw()
    state.draw()
end
