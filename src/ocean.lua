waves = {}

OCEAN_LEVEL = HEIGHT * 3/7
DEEP_OCEAN = 7/10
local OCEAN_PADDING = 20

local LEFT = -OCEAN_PADDING
local RIGHT = WIDTH + OCEAN_PADDING

function make_a_wave(amplitude, speed, dir)

    local step = 0
    local height = {}

    for x = LEFT, RIGHT do height[x] = 0 end

    local wave = {
        ['step'] = function(dt)
            if dir == 1 then
                for x = RIGHT, LEFT+1, -1 do
                    height[x] = (height[x] + height[x - 1]) / 2
                end
    
                height[LEFT] = SIN[step] * amplitude
                
            else
                for x = LEFT, RIGHT - 1, 1 do
                    height[x] = (height[x] + height[x + 1]) / 2
                end
    
                height[RIGHT] = SIN[step] * amplitude
            end
            step = (step + speed) % STEPS
        end,
            
        ['slope'] = function(x)
            return height[x - 2] - height[x + 2]
        end,
        
        ['height'] = function(x)
            return height[x]
        end
    }
    
    return wave
end

function update_waves(dt)
    for i = 1, #waves do
        waves[i].step(dt)
    end
end

function ocean_level(x, n)
    if x < LEFT then x = LEFT elseif x > RIGHT then x = RIGHT end
    n = n or 0
    
    local h = OCEAN_LEVEL
    for i = 1, (#waves - n) do
        h = h + waves[i].height(x)
    end
    return h
end

function ocean_slope(x)
    return ocean_level(x - 2) - ocean_level(x+2)
end


