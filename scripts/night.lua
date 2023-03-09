local night = {}

function night.init()
    global.night = {}
    global.night.dusk = 0.2
    global.night.evening = 0.4
    global.night.morning = 0.6
    global.night.dawn = 0.8
    global.night.count = 1
    global.night.is_new_night = false
    global.night.is_new_day = false
    global.night.is_night = false
end


function night.check_day_coming(player)
    local surface = player.surface
    local daytime = surface.daytime
    if daytime > global.night.dawn and daytime < 1.0 then
        if not global.night.is_new_day then
            global.night.is_new_day = true
            global.night.is_night = false
            return true
        end
    else
        if global.night.is_new_day then
            global.night.is_new_day = false
        end
    end

    return false

end
function night.check_night_coming(player)
    -- check if night is coming
    local surface = player.surface
    local daytime = surface.daytime
    local day_length_ticks = surface.ticks_per_day


    global.night.count = math.floor(game.tick / day_length_ticks) + 1
    if daytime < global.night.dawn and daytime > global.night.dusk then
        if not global.night.is_new_night then
            global.night.is_new_night = true
            global.night.is_night = true
            global.ai.have_send_squad_this_night = false
            if global.ai.hard then
                global.ai.night_squad_send_max = math.floor(global.night.count / 3)
            else
                global.ai.night_squad_send_max = math.floor(global.night.count / 5)
            end
            global.ai.night_squad_send = 0


            if not player.gui.top.wn_gui.wn_night_coming then
                local label = player.gui.top.wn_gui.add({type = "label", name = "wn_night_coming", caption = "Night %s"})

                if global.ai.is_peacemode then
                    label.style.font_color = {r=0.6, g=0.8, b=0.6}
                else
                    label.style.font_color = {r=0.8, g=0.2, b=0.2}
                end

                label.style.font = "default-large-bold"
                label.style.padding = {1, 6, 1, 6}
                label.caption = string.format(label.caption, global.night.count)
                return global.night.count
            end
        end
    else
        if global.night.is_new_night then
            global.night.is_new_night = false
            if player.gui.top.wn_gui.wn_night_coming then
                player.gui.top.wn_gui.wn_night_coming.destroy()
            end
        end
    end
    return false
end


function night.setsettings()
	
	-- defaults: 25,000 ticks per day, dusk 0.25, evening 0.45, morning 0.55, dawn 0.75
	-- cycle_ticks is no longer default - we track each surface's original day length and multiply off that.
	-- May make it an option later.
	-- local cycle_ticks = math.floor(25000 * settings.global["Clockwork-cycle-length"].value)
	local cycle_multi = 2
	local ignore_always_day = true
	local ignore_frozen = false
	local dusk = global.night.dusk
	local evening = global.night.evening
	local morning = global.night.morning
	local dawn = global.night.dawn
    local dark_parts = 40.0
	local warning = false
    local multi_surface = false
	-- safety checks
	if dawn <= dusk then
		dawn = dusk + 0.005
		warning = true
	end
	if morning >= dawn then
		morning = dawn - 0.005
		warning = true
	end
	if evening >= morning then
		evening = morning - 0.005
		warning = true
	end
	if dusk >= evening then
		dusk = evening - 0.005
		warning = true
	end
	if warning then
		game.print("WARNING: Invalid day/night settings detected. Values have been internally corrected.")
	end
	
	global.night.midnight = (evening + morning) / 2
	
	for index, surface in pairs(game.surfaces) do
		
		local original_ticks = 25000
		-- game.print(index)
		-- validation
		if not surface.valid
			-- Always applies to Nauvis. Unless Nauvis becomes invalid, somehow.
			or (surface.index > 1) and ((surface.always_day and ignore_always_day) or (surface.freeze_daytime and ignore_frozen))
		then 
		else
			surface.ticks_per_day = math.floor(original_ticks * cycle_multi)
			
			-- RIP min brightness.
			-- surface.min_brightness = settings.global["Clockwork-minbrightness"].value
			
			-- brightness: 0.15.
			local dark_percent = dark_parts / 100.0
			surface.brightness_visual_weights = { 1 / 0.85 * dark_percent, 1 / 0.85 * dark_percent, 1 / 0.85 * dark_percent } 
			
			
			local retry
			local cnt = 0
			repeat 
				retry = false
				
				-- Checks that values are within range in the same order as:
				-- dusk 0.25, evening 0.45, morning 0.55, dawn 0.75
				-- second round of checks are necessary as the game will crash if, for example, dawn is less than
				-- surface.morning, even though the 'morning' we want to apply after is valid.
				
				if dawn <= surface.morning then
					retry = true
				else
					surface.dawn = dawn
				end
				
				if morning >= surface.dawn or morning <= surface.evening then
					retry = true
				else
					surface.morning = morning
				end
				
				if evening >= surface.morning or evening <= surface.dusk then
					retry = true
				else
					surface.evening = evening
				end
				
				if dusk >= surface.evening then
					retry = true
				else
					surface.dusk = dusk
				end
				
				cnt = cnt + 1
				if cnt > 4 then
					break
				end
			until retry == false
			--game.print("dusk: " .. surface.dusk .. " evening: " .. surface.evening .. " morning: " .. surface.morning ..
			--	" dawn: " .. surface.dawn)
		end
		
		if multi_surface == false then
			break
		end
	end
	

end


return night
