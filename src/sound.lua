ocean_waves_sound = nil
plop_sound = nil
plop2_sound = nil
hit_sound = nil

function initialize_sounds()
    -- Calm Sea Waves Sound, by alexander · September 20, 2014
    -- http://www.orangefreesounds.com/calm-sea-waves-sound/
    ocean_waves_sound = love.audio.newSource("assets/Calm-sea-waves.mp3", "stream")
    ocean_waves_sound:setLooping(true)
    ocean_waves_sound:setVolume(0.2)
    
    -- Cartoon, pop or plop. Version 1
    -- https://www.zapsplat.com/music/cartoon-pop-or-plop-version-1/
    plop_sound = love.audio.newSource("assets/zapsplat_cartoon_pop_001_46047.mp3", "stream")
    plop_sound:setLooping(false)
    plop_sound:setVolume(1)
    
    -- Cartoon, pop or plop. Version 2
    -- https://www.zapsplat.com/music/cartoon-pop-or-plop-version-2/
    plop2_sound = love.audio.newSource("assets/zapsplat_cartoon_pop_002_46048.mp3", "stream")
    plop2_sound:setLooping(false)
    plop2_sound:setVolume(1)
    
    -- Fist punch water splash
    -- https://www.zapsplat.com/music/fist-punch-water-splash/
    hit_sound = love.audio.newSource("assets/water_splash_fist_punch.mp3", "stream")
    hit_sound:setLooping(false)
    hit_sound:setVolume(1)
end
