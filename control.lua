local easy_pickup = require("scripts.easy_pickup")
local clock = require("scripts.clock")
local night = require("scripts.night")
local ai_test = require("scripts.ai_test")
local ai = require("scripts.ai")
local victory = require("scripts.victory")



script.on_init(function(event)
    ai.init()
    night.init()
    easy_pickup.init()
end)
script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  clock.init_gui(player)
  night.setsettings()
  ai_test.init_gui(player)
end)
script.on_nth_tick(60, function()
  for _, player in pairs(game.players) do
    clock.update_timer(player)
  end
end)

script.on_nth_tick(60*15, function()
  for _, player in pairs(game.players) do
    local new_night_count = night.check_night_coming(player)
    ai.update_state(player)
    ai_test.update_gui(player)
    ai.check_night_ai(player)
    if new_night_count then
        ai.increase_squad_size()
    end
    local is_new_day = night.check_day_coming(player)
    if is_new_day then
        if global.ai.hard then
            remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = player.surface.index, state = 5})
        end
    end
  end
end)

script.on_nth_tick(60*60*5, function()
  for _, player in pairs(game.players) do
      if ai.is_slaughtmode then
          ai.send_squad(player)
      end
  end
end)


-- IN ROCKET MODE,
-- player first in lobby surfcae
-- then in nauvis surface
script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.players[event.player_index]
    if player.surface.name == "lobby" then
        player.game_view_settings.show_research_info = false
        easy_pickup.init_gui(player)
    elseif player.surface.name == "nauvis" then
        if player.gui.screen.wn_easy_pickup_button then
            player.gui.screen.wn_easy_pickup_button.destroy()
            global.easy_pickup.has_picked = true
        end
    end
end)
script.on_event(defines.events.on_gui_click, function(event)
    ai_test.on_gui_click(event)
    easy_pickup.on_gui_click(event)
end)

script.on_event(defines.events.on_built_entity, function(event)
    local player = game.players[event.player_index]
    if event.created_entity.name == 'rocket-silo' then
        ai.set_onslaught_mode(player)
        ai.send_squad(player)
    end
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
    if event.created_entity.name == 'rocket-silo' then
        local player = event.created_entity.last_user
        ai.set_onslaught_mode(player)
        ai.send_squad(player)
    end
end)

script.on_event(defines.events.on_rocket_launched, function(event)
    victory.on_rocket_launched(event)
end)

commands.add_command("wn_debug", nil, function(command)
    local player = game.players[command.player_index]
    if player.admin then
        if command.parameter == '0' then
            ai_test.hide_gui(player)
        else
            ai_test.show_gui(player)
        end
    else
        player.print({ "cant-run-command-not-admin"})
    end
end)

