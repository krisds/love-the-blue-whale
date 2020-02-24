
local sheduled_functions = {}

function shedule(time, fn)
    sheduled_functions[#sheduled_functions + 1] = { time, fn }
end

function update_sheduler(dt)
    for i = 1, #sheduled_functions do
        sheduled = sheduled_functions[i]
        sheduled[1] = sheduled[1] - dt
        if sheduled[1] <= 0 then
            sheduled[2]()
        end
    end
    
    for i = #sheduled_functions, 1, -1 do
        if sheduled_functions[i][1] <= 0 then
            table.remove(sheduled_functions, i)
        end
    end
end

function clear_sheduler()
    sheduled_functions = {}
end