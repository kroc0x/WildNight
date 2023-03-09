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

    if settings.startup["wn-hard"].value == true then
        global.ai.hard = true
    else
        global.ai.hard = false
    end
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
        
        if daytime < global.night.evening and daytime > global.night.dusk +0.05 then
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
        if game.tick > 60*60*45 then
            global.ai.is_peacemode = false
        end
    end

end


function ai.send_squad(player)
    local night = global.night.count
    local size = 1
    if night == 1 then
        size = 1
        if global.ai.hard then
            size = 2
        end
    elseif night == 2 then
        size = math.random(3, 5)
        if global.ai.hard then
            size = size + 5
        end
    elseif night == 3 then
        size = math.random(15, 25)
        if global.ai.hard then
            size = size + 10
        end
    elseif night == 4 then
        size = math.random(45, 55)
        if global.ai.hard then
            size = size + 15
        end
    else
        size = global.ai.max_squad_size
    end

    -- increase point every night
    if global.ai.hard then
        global.ai.points = global.ai.points +  100*night
    else
        global.ai.points = global.ai.points +  200*night
    end

    remote.call("rampantFixed", "setAI_points_ExtCtrl", {surfaceIndex = player.surface.index, points = global.ai.points })

    local should_recover_state = false
    if global.ai.state ~= 4 then
        should_recover_state = true
        remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = 4})
    end

    local squad = remote.call("rampantFixed", "createSquad_ExtCtrl", {surfaceIndex = player.surface.index, size = size, ignoreSquadLimit = true})
    if squad then
        local squad_size = #(squad.members)
        player.print(squad_size .. " biters is coming from [gps=" .. squad.position.x .. "," .. squad.position.y .."] ")
        squad.set_command({type=defines.command.attack_area, destination={player.position.x, player.position.y}, radius=50, distraction=defines.distraction.by_enemy})
    else
        player.print("No biters coming currently")
    end

    if night <= 3 and should_recover_state then
        local result = remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = 1})
    end
end

function ai.increase_squad_size()
    if global.ai.hard then
        global.ai.max_squad_size = 12 + global.night.count * 4
        if global.ai.max_squad_size > 150 then
            global.ai.max_squad_size = 150
        end
    else
        global.ai.max_squad_size = 8 + global.night.count * 3
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
