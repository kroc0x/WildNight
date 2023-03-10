local ai_test = {}


function ai_test.init_gui(player)
    local flow
    if not player.gui.top.wn_gui then
        flow = player.gui.top.add{type="flow", name="wn_gui", direction="vertical"}
    else
        flow = player.gui.top.wn_gui
    end
    local frame = flow.add{type="frame", name="wn_ai_test", direction="horizontal"}
    frame.style.padding = {1, 6, 1, 6}
    local btn_state = frame.add{type="button", name="wn_ai_test_toggle_state", caption="State"}
    local lb_state = frame.add{type="label", name="wn_ai_test_state"}
    local lb_points = frame.add{type="label", name="wn_ai_test_points"}
    local ipt_size = frame.add{type="textfield", name="wn_ai_test_size", text="5"}
    ipt_size.style.width = 50
    local btn_squad= frame.add{type="button", name="wn_ai_test_squad", caption="Create Squad"}
    local btn_show = frame.add{type="button", name="wn_ai_test_show_group", caption="Show Group"}
    local btn_attack = frame.add{type="button", name="wn_ai_test_attack", caption="Attack"}
    local btn_fac = frame.add{type="button", name="wn_ai_test_faction", caption="Factions"}
    local btn_set_fac = frame.add{type="button", name="wn_ai_test_set_faction", caption="Set Factions"}
    -- hide
    local ipt_points = frame.add{type="textfield", name="wn_ai_test_ipt_points", text="1000"}
    ipt_points.style.width = 80
    local btn_set_fac = frame.add{type="button", name="wn_ai_test_set_points", caption="Set Points"}

    ai_test.hide_gui(player)

end

function ai_test.show_gui(player)
    local frame = player.gui.top.wn_gui.wn_ai_test
    frame.visible = true
    frame.wn_ai_test_toggle_state.visible = true
    frame.wn_ai_test_state.visible = true
    frame.wn_ai_test_points.visible = true
    frame.wn_ai_test_size.visible = true
    frame.wn_ai_test_squad.visible = true
    frame.wn_ai_test_show_group.visible = true
    frame.wn_ai_test_attack.visible = true
    frame.wn_ai_test_faction.visible = true
    frame.wn_ai_test_set_faction.visible = true
    frame.wn_ai_test_ipt_points.visible = true
    frame.wn_ai_test_set_points.visible = true
end
function ai_test.hide_gui(player)
    local frame = player.gui.top.wn_gui.wn_ai_test
    frame.visible = false
    frame.wn_ai_test_toggle_state.visible = false
    frame.wn_ai_test_state.visible = false
    frame.wn_ai_test_points.visible = false
    frame.wn_ai_test_size.visible = false
    frame.wn_ai_test_squad.visible = false
    frame.wn_ai_test_show_group.visible = false
    frame.wn_ai_test_attack.visible = false
    frame.wn_ai_test_faction.visible = false
    frame.wn_ai_test_set_faction.visible = false
    frame.wn_ai_test_ipt_points.visible = false
    frame.wn_ai_test_set_points.visible = false
end

function ai_test.update_gui(player)
    
    local label = player.gui.top.wn_gui.wn_ai_test.wn_ai_test_state
    label.caption = "State: " .. global.ai.state
    label = player.gui.top.wn_gui.wn_ai_test.wn_ai_test_points
    label.caption = "Points: " .. math.floor(global.ai.points)
    local ipt = player.gui.top.wn_gui.wn_ai_test.wn_ai_test_size
    ipt.text = string.format("%d", global.ai.max_squad_size)

end

function ai_test.on_gui_click(event)
    local player = game.players[event.player_index]
    local element = event.element
    if element.name == 'wn_ai_test_toggle_state' then
        -- set state in [1,2,4,5,6,7]
        local state = global.ai.state + 1
        if state > 7 then
            state = 1
        elseif state == 3 then
            state = 4
        end
		local result = remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = state})
        if result then
			player.print("AI_state: ".. result.state .. "("..result.stateEnglish..")" )
            global.ai.state = result.state
            global.ai.state_english = result.stateEnglish
            local label = player.gui.top.wn_gui.wn_ai_test.wn_ai_test_state
            label.caption = "State: " .. global.ai.state
		else
			game.print("non-rampant surface or invalid state. Use /printValidAI_StateList")
            local result = remote.call("rampantFixed", "getValidAI_StateList")
            for state, stateEnglish in pairs(result) do
                game.print(""..state.." = ".. stateEnglish)
            end
            
        end
        
    elseif element.name == "wn_ai_test_squad" then

        local size = tonumber(player.gui.top.wn_gui.wn_ai_test.wn_ai_test_size.text)
        if size then
            local result = remote.call("rampantFixed", "createSquad_ExtCtrl", {surfaceIndex = player.surface.index, size = size, ignoreSquadLimit = true})
            if result then
                player.print("squad created at [gps=" .. result.position.x .. "," .. result.position.y .."]")
            else
                player.print("Cant create squad")
            end
        end
    elseif element.name == "wn_ai_test_attack" then
		local groups = remote.call("rampantFixed", "getRampantAttackGroups") 
		for index, group in pairs(groups) do
            group.set_command({type=defines.command.attack_area, destination={player.position.x, player.position.y}, radius=50, distraction=defines.distraction.by_enemy})
            local size = #(group.members)
            player.print("group "..index..", [gps=" .. group.position.x .. "," .. group.position.y .."]".. " is coming to attack player. with size "..size..".")
        end
    elseif element.name == "wn_ai_test_show_group" then

		local groups = remote.call("rampantFixed", "getRampantAttackGroups") 
		for index, group in pairs(groups) do
			if group.surface == player.surface then	-- lets ping only same surface groups
                local group_size = #(group.members)
				player.print("group "..index..", [gps=" .. group.position.x .. "," .. group.position.y .."]" .. group_size)
			else
				player.print("group "..index..", x/y = " .. group.position.x .. "/" .. group.position.y ..", ".. group_size)
			end	
		end
    elseif element.name == "wn_ai_test_faction" then
		local factions = remote.call("rampantFixed", "getFactions") 
		for faction, tiers in pairs(factions) do
			game.print(faction..", tiers:"..tiers.tierMin.."-"..tiers.tierMax)
		end
    elseif element.name == "wn_ai_test_set_points" then
        local size = tonumber(player.gui.top.wn_gui.wn_ai_test.wn_ai_test_ipt_points.text)
        if size then
            local result = remote.call("rampantFixed", "setAI_points_ExtCtrl", {surfaceIndex = player.surface.index, points = size})
            if result then
                game.print("AI_points: ".. result )
            else
                game.print("non-rampant surface")
            end
        else
            game.print("no size")
        end
    elseif element.name == "wn_ai_test_set_faction" then
		local parameters = {}
		parameters.surfaceIndex = player.surface.index
		parameters.position = player.position
        
		local base = remote.call("rampantFixed", "getBaseByPosition", parameters)
		if not base then
			game.print("no base at player position!")
			return
		end
        
		parameters = {id = base.id, factions = {}}
		parameters.factions['nuclear'] = 1				-- 100% of specified faction
		local result = remote.call("rampantFixed", "setBaseFactions_ExtCtrl", parameters)		
		if not result then
			game.print("external control isn't allowed")	-- impossible in this algorithm, because allowExternalControl checked
		elseif result == 1 then
			game.print("success")
		elseif result == -1 then
			game.print("wrong parameters")					-- impossible in this algorithm, because base and factions checked
		elseif result == -2 then
			game.print("sum of rates is not equals 1")		 	-- impossible in this algorithm, because "parameters.factions[command.parameter] = 1"
		end
    end
end


return ai_test
