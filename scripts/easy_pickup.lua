local easy_pickup = {}
-- check if current surface is lobby surface
-- if it's lobby, then init a gui button
-- with button clicked, player will change current gold in inventory to 
-- preset items (10000 gold -> ...)
-- and then player will be teleported to launchpad_area in lobby

function easy_pickup.init()
    -- init a gui button
    
    global.easy_pickup = {}
    global.easy_pickup.has_picked = false

end

function easy_pickup.init_gui(player)
    if not global.easy_pickup.has_picked and player.surface.name == "lobby" then
        local button = player.gui.screen.add({type = "button", name = "wn_easy_pickup_button", caption = "Pickup Presets"})
        button.style.font_color = {r=0.20, g=0.96, b=0.18}
        button.style.font = "default-bold"
        button.style.minimal_height = 30
        button.style.minimal_width = 140
    end
end

function easy_pickup.on_gui_click(event)
    -- if player clicked the button
    if event.element.name == "wn_easy_pickup_button" then
        local player = game.players[event.player_index]
        easy_pickup.easy_pickup(player)
    end
end

function easy_pickup.easy_pickup(player)

    -- change gold to preset items
    local gold = player.get_item_count("coin")
    -- check has 10000 gold
    if gold == 10000 then
        player.remove_item({name = "coin", count = 10000})
        player.remove_item({name = "piercing-rounds-magazine", count = 100})
        player.remove_item({name = "solar-panel-equipment", count = 7})
        player.remove_item({name = "battery-equipment", count = 3})
        player.insert({name = "steel-chest", count = 30})
        player.insert({name = "transport-belt", count = 150})
        player.insert({name = "kr-loader", count = 50})
        player.insert({name = "inserter", count = 50})
        player.insert({name = "medium-electric-pole", count = 50})
        player.insert({name = "solar-panel", count = 40})
        player.insert({name = "accumulator", count = 40})
        player.insert({name = "electric-mining-drill", count = 20})
        player.insert({name = "steel-furnace", count = 20})
        player.insert({name = "assembling-machine-2", count = 20})
        
        player.insert({name = "effectivity-module", count = 30})
        player.insert({name = "heavy-oil-barrel", count = 30})
        player.insert({name = "gun-turret", count = 10})
        player.insert({name = "rifle-magazine", count = 200})
        player.insert({name = "defender-capsule", count = 10})
        player.insert({name = "small-lamp", count = 5})
        player.insert({name = "dt-fuel", count = 1})
        player.insert({name = "cliff-explosives", count = 5})

        player.set_quick_bar_slot(1, 'steel-chest')
        player.set_quick_bar_slot(2, 'transport-belt')
        player.set_quick_bar_slot(3, 'inserter')
        player.set_quick_bar_slot(4, 'medium-electric-pole')
        player.set_quick_bar_slot(5, 'kr-loader')

        player.set_quick_bar_slot(8, 'rifle-magazine')
        player.set_quick_bar_slot(9, 'gun-turret')
        player.set_quick_bar_slot(10, 'defender-capsule')

        player.set_quick_bar_slot(11, 'coal')
        player.set_quick_bar_slot(12, 'iron-plate')
        player.set_quick_bar_slot(13, 'copper-plate')

        player.set_quick_bar_slot(19, 'small-lamp')
        player.set_quick_bar_slot(20, 'stone-wall')
    else
        game.print("Not enough gold! (10000 gold required)")
        return
    end


    game.print("Teleport to launchpad... ")
    player.teleport({x = 0, y = 35}, "lobby")

    -- destroy gui
    -- NOTE: should be placed at end of gui event
    if player.gui.screen.wn_easy_pickup_button then
        player.gui.screen.wn_easy_pickup_button.destroy()
        global.easy_pickup.has_picked = true
    end

end

return easy_pickup
