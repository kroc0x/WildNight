local ai = {}

------------- 
-- init ai basic state with attack waveszie
-- peacetime is 3 night cycles, a.k.a 3*50000 ticks = 150000 / 60 /60 = 41.66 min
-- then it will be 45 min
--
-- first attack is a small squad with 3-5 units at first night
-- after peactime is over, squad size is increased each night

-- after player built rocket silo, the ai will turn to onslaughting mode
-- and will send a squad to attack player every 5 min

function ai.init()
    global.ai = {}
    global.ai.state = 0
    global.ai.state_english = 'None'
    global.ai.points = 0
    global.ai.max_squad_size = 10
    global.ai.is_peacemode = true
    global.ai.is_slaughtmode = false

    global.ai.have_send_squad_this_night = true
    global.ai.night_squad_send = 0
    global.ai.night_squad_send_max = 0

    global.ai.hard = false
    global.ai.poison = false
    global.ai.nuclear= false
    global.ai.inferno = false
    global.ai.hp_x3 = false
    global.ai.mode = ""
    global.ai.mode_str = ""
end
function ai.update_state(player)
    local result = remote.call("rampantFixed", "getAI_state", {surfaceIndex = player.surface.index})
    if result then
        global.ai.state = result.state
        global.ai.state_english = result.stateEnglish
    end
    local result = remote.call("rampantFixed", "getAI_points", {surfaceIndex = player.surface.index})
    if result then
        global.ai.points = result
    end

end

function ai.check_night_ai(player)
    if not global.ai.have_send_squad_this_night then
        local surface = player.surface
        local daytime = surface.daytime
        
        if daytime < global.night.morning and daytime > global.night.dusk +0.03 then
            if global.ai.night_squad_send < global.ai.night_squad_send_max then
                ai.send_squad(player)
                global.ai.night_squad_send = global.ai.night_squad_send + 1
            end
            if global.ai.night_squad_send == global.ai.night_squad_send_max then
                global.ai.have_send_squad_this_night = true
            end
        end
    end
    if global.ai.is_peacemode then
        if game.tick > 60*60*40 then
            global.ai.is_peacemode = false
        end
    end
end


function ai.send_squad(player)
    local night = global.night.count
    local size = 1
    if night == 1 then
        size = 1
        global.ai.points = global.ai.points + 100
        if global.ai.hard then
            size = 2
        end
    elseif night == 2 then
        size = math.random(3, 5)
        global.ai.points = global.ai.points + 100
        if global.ai.hard then
            size = size + 3
        end
    elseif night == 3 then
        size = math.random(10, 15)
        global.ai.points = global.ai.points + 100
        if global.ai.hard then
            size = size + 10
        end
    else
        size = global.ai.max_squad_size
        local points_per_wave = 200
        if global.ai.hard then
            points_per_wave = 150 * night
            if points_per_wave > 1000 then
                points_per_wave = 1000
            end
        else
            points_per_wave = 100 * night
            if points_per_wave > 750 then
                points_per_wave = 750
            end
        end

        global.ai.points = global.ai.points + points_per_wave
    end

    -- increase point every night

    remote.call("rampantFixed", "setAI_points_ExtCtrl", {surfaceIndex = player.surface.index, points = global.ai.points })

    -- local should_recover_state = false

    -- if global.ai.is_peacemode then
    --     should_recover_state = true
    -- end


--     -- check nearby first, then raiding
--     remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = 2})
--     local squad = remote.call("rampantFixed", "createSquad_ExtCtrl", {surfaceIndex = player.surface.index, size = size, ignoreSquadLimit = true})
--     if squad then
--         local squad_size = #(squad.members)
--         player.print(squad_size .. " biters is coming from [gps=" .. squad.position.x .. "," .. squad.position.y .."] ")
--         squad.set_command({type=defines.command.attack_area, destination={player.position.x, player.position.y}, radius=50, distraction=defines.distraction.by_enemy})
--     else
        remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = 4})
        local squad = remote.call("rampantFixed", "createSquad_ExtCtrl", {surfaceIndex = player.surface.index, size = size, ignoreSquadLimit = true})
        if squad then
            local squad_size = #(squad.members)
            player.print(squad_size .. " biters is coming from [gps=" .. squad.position.x .. "," .. squad.position.y .."] ")
            squad.set_command({type=defines.command.attack_area, destination={player.position.x, player.position.y}, radius=50, distraction=defines.distraction.by_enemy})
        else
            player.print("Seems no biter is coming")
        end
    -- end

    if global.ai.is_peacemode then
        local result = remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = 1})
    end

end

function ai.increase_squad_size()
    if global.ai.hard then
        global.ai.max_squad_size = 15 + global.night.count * 4
        if global.ai.max_squad_size > 150 then
            global.ai.max_squad_size = 150
        end
    else
        global.ai.max_squad_size = 10 + global.night.count * 2
        if global.ai.max_squad_size > 100 then
            global.ai.max_squad_size = 100
        end
    end

    local result = remote.call("rampantFixed", "setWaveMaxSize_ExtCtrl", {attackWaveMaxSize = global.ai.max_squad_size})
end

function ai.set_onslaught_mode(player)
    is_slaughtmode = true
end

return ai
