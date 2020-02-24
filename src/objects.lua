local function NOP() end

function floating(thing, dt)
    local h = ocean_level(thing.px)
    if thing.y < h + 10 then
        -- In the water
        if thing.y > h * DEEP_OCEAN then
            -- Shallows
            thing.vx = thing.vx + 0.01 * ocean_slope(thing.px)
            thing.vx = thing.vx * 0.95  -- Dampen
        else
            -- In deep
            thing.vx = thing.vx * 0.98  -- Dampen
        end

        thing.vy = thing.vy + 0.06
        thing.vy = thing.vy * 0.95  -- Dampen

    elseif thing.y >= h + 10 then
        -- In the air
        thing.vy = thing.vy - 0.05

        thing.vx = thing.vx * 0.99  -- Dampen
    end
end

function make_a_thing(sprite, x, y, r)

    local thing = {}
    thing['x'] = x
    thing['y'] = y
    thing['px'] = math.floor(x)
    thing['py'] = math.floor(y)
    thing['vx'] = 0
    thing['vy'] = 0
    thing['direction'] = dir
    
    thing['deleted'] = false
    thing['on_remove'] = NOP

    thing['steer'] = NOP
    thing['world_interaction'] = NOP
    
    thing['accelerate'] = function(dx, dy)
        thing.vx = thing.vx + dx

        local h = ocean_level(thing.px)
        if dy ~= 0 and thing.in_the_water() then
            thing.vy = thing.vy + dy
        end
    end
    
    thing['in_the_water'] = function()
        return thing.y < ocean_level(thing.px) + 10
    end
    
    thing['update'] = function(dt)
        if thing.deleted then return end
        thing.steer(thing, dt)
        thing.world_interaction(thing, dt)

        thing.x = thing.x + thing.vx
        thing.y = thing.y + thing.vy

        if thing.y < 10          then thing.y = 10          end
        if thing.y > HEIGHT - 10 then thing.y = HEIGHT - 10 end

        thing.px = math.floor(thing.x)
        thing.py = math.floor(thing.y)

        sprite.update(dt)
    end
        
    thing['limit'] = function(left, right)
        if thing.x < left   then thing.x = left   end
        if thing.x > right  then thing.x = right  end
        
        thing.px = math.floor(thing.x)
    end
        
    thing['removed'] = function() thing.on_remove() end
    thing['collider'] = function() return thing.x, thing.y, r end
    thing['delete'] = function() thing.deleted = true end
        
    thing['draw'] = function() sprite.draw(thing.px, HEIGHT - thing.py, thing.direction) end
    
    return thing
end

function make_a_particle(sprite, x, y)
    local timer = 2
    local dx = math.random(-5, 5)
    local dy = math.random(10, 20)

    local thing = {}

    thing['x'] = x
    thing['y'] = y
    thing['deleted'] = false
    thing['removed'] = NOP

    thing['update'] = function(dt)
        thing.x = thing.x + dx*dt
        thing.y = thing.y + dy*dt
        timer = timer - dt
        if timer <= 0 then thing.deleted = true end
    end

    thing['draw'] = function() sprite.draw(thing.x, HEIGHT - thing.y, 1) end
    
    return thing
end

function update_things(things, dt)
    for i = 1, #things do things[i].update(dt) end
    for i = #things, 1, -1 do
        local thingy = things[i]
        if thingy.deleted or thingy.x < -100 or thingy.x > WIDTH + 100 then
            table.remove(things, i)
            thingy.removed()
        end
    end
end

function draw_things(things)
    for i = 1, #things do things[i].draw() end
end

local function distance(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function on_collisions(src, things, handle_collision_fn)
    local src_x, src_y, src_r = src.collider()
    for i = 1, #things do
        local thingy = things[i]
        local thing_x, thing_y, thing_r = thingy.collider()
        local d = distance(src_x, src_y, thing_x, thing_y)
        if d < (src_r + thing_r) then handle_collision_fn(src, thingy) end
    end
end
