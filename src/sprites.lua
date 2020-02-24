
function make_a_sprite(path, ox_pct, oy_pct)
    ox_pct = ox_pct or 0.5
    oy_pct = oy_pct or 0.5

    local image = love.graphics.newImage(path)
    
    local w = image:getWidth()
    local h = image:getHeight()

    local ox = w * ox_pct
    local oy = h * oy_pct
    
    local sprite = {
        ['update'] = function(dt)
        end,
        
        ['draw'] = function(x, y, dir)
            dir = dir or 1
            love.graphics.draw(image, x, y, 0, dir, 1, ox, oy)
        end
    }
    
    return sprite
end

function make_an_animation(sprites, fps)
    local spf = 1/fps
    local timeout = spf
    local index = 1
    
    local animation = {
        ['update'] = function(dt)
            timeout = timeout - dt
            if timeout <= 0 then
                timeout = spf
                index = index + 1
                if (index > #sprites) then index = 1 end
            end
        end,
        
        ['draw'] = function(x, y, dir)
            sprites[index].draw(x, y, dir)
        end
    }
    
    return animation
end

function make_state_based_animation()
    local state = nil
    local animations = {}
    local timeout = 0
    
    local animation = {
        ['define'] = function(name, sprite, time, next)
            animations[name] = {
                ['sprite'] = sprite,
                ['time'] = time or -1,
                ['next'] = next or name
            }
            end,
        
        ['play'] = function(name)
            state = name
            timeout = animations[state].time
        end,
        
        ['update'] = function(dt)
            animations[state].sprite.update(dt)
            
            if (animations[state].time > 0) then
                timeout = timeout - dt
                if timeout <= 0 then
                    state = animations[state].next
                end
            end
        end,
        
        ['draw'] = function(x, y, dir)
            animations[state].sprite.draw(x, y, dir)
        end
    }
    
    return animation
end