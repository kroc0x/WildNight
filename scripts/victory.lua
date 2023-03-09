local victory = {}

local function get_mode_str(player)
    local is_hard = settings.startup["wn-hard"].value
    local has_poison = settings.startup["wn-poison"].value
    local has_inferno= settings.startup["wn-inferno"].value
    local has_nuclear = settings.startup["wn-nuclear"].value

    local mode_str = "Hard"
    if not is_hard then
        mode_str = ""
    end

    local biter_str = ""
    if has_poison then
        biter_str = biter_str .. " Poison"
    end
    if has_inferno then
        biter_str = biter_str .. " Inferno"
    end
    if has_nuclear then
        biter_str = biter_str .. " Nuclear"
    end

    local final_str = mode_str .. biter_str

    return final_str
end

local function get_kill_infos(player)
    local kill_counts = {}
    local prototypes = game.get_filtered_entity_prototypes({ { filter = "type", type = "unit" } })
    for k, v in pairs(prototypes) do
        local count = player.force.kill_count_statistics.get_input_count(k)
        if count > 0 then
            kill_counts[k] = { count = count, localised_name = v.localised_name, order = v.order }
        end
    end
    prototypes = game.get_filtered_entity_prototypes({ { filter = "type", type = "unit-spawner" } })
    for k, v in pairs(prototypes) do
        local count = player.force.kill_count_statistics.get_input_count(k)
        if count > 0 then
            kill_counts[k] = { count = count, localised_name = v.localised_name, order = v.order }
        end
    end
    prototypes = game.get_filtered_entity_prototypes({ { filter = "type", type = "turret" } })
    for k, v in pairs(prototypes) do
        local count = player.force.kill_count_statistics.get_input_count(k)
        if count > 0 then
            kill_counts[k] = { count = count, localised_name = v.localised_name, order = v.order }
        end
    end
    table.sort(kill_counts, function(left, right)
        return left.order < right.order
    end)
    return kill_counts
end

local function get_kill_count(player)
    local infos = get_kill_infos(player);
    local total = 0
    local total_points = 0
    for name, info in pairs(infos) do
        if info.count > 0 then
            total = total + info.count
        end
    end
    return total
end

-- check victory if rocket launched 
function victory.on_rocket_launched(event)
    for playerIndex, player in pairs(game.players) do
        if player.force == event.rocket_silo.force then
            player.play_sound{path="utility/game_won", volume_modifier=1}
            game.set_game_state({ game_finished=true, player_won=true, can_continue=true, victorious_force=player.force })
            victory.show_victory_gui(player)
        else
            player.play_sound{path="utility/game_lost", volume_modifier=1}
            game.set_game_state({ game_finished=true, player_won=true, can_continue=true, victorious_force=player.force })
            victory.show_failure_gui(player)
        end
    end
end


function victory.show_victory_gui(player)
    if player.gui.top.wn_gui.victory_frame then
        player.gui.top.wn_gui.victory_frame.destroy()
    end
    local flow = player.gui.top.wn_gui.add{type="flow", name="victory_frame", direction="vertical"}
    flow.style.padding = {1, 6, 1, 6}
    local label = flow.add{type="label", caption="Victory"}
    label.style.font_color = {r=0.28, g=0.96, b=0.22}
    local night_caption = string.format("Night: %d", global.night.count)
    flow.add{type="label", caption=night_caption}
    local kill_count = get_kill_count(player)
    local kill_caption = string.format("Kills: %d", kill_count)
    flow.add{type="label", caption=kill_caption}
    flow.add{type="label", caption=get_mode_str(player)}
end

function victory.show_failure_gui(player)
    if player.gui.top.wn_gui.failure_frame then
        player.gui.top.wn_gui.failure_frame.destroy()
    end
    local flow = player.gui.top.wn_gui.add{type="flow", name="failure_frame", direction="vertical"}
    flow.style.padding = {1, 6, 1, 6}
    local label = flow.add{type="label", caption="Failed"}
    label.style.font_color = {r=0.98, g=0.26, b=0.22}
    local night_caption = string.format("Night: %d", global.night.count)
    flow.add{type="label", caption=night_caption}
    local kill_count = get_kill_count(player)
    local kill_caption = string.format("Kills: %d", kill_count)
    flow.add{type="label", caption=kill_caption}
    flow.add{type="label", caption=get_mode_str(player)}
end



return victory
