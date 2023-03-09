local clock = {}


function clock.init_gui(player)
    local flow = player.gui.top.add{type="flow", name="wn_gui", direction="vertical"}
    local frame = flow.add{type="frame", name="wn_clock", direction="horizontal"}
    frame.style.padding = {1, 6, 1, 6}
    local label = frame.add{type="label", name="wn_clock_label"}
    label.style.font = "default-bold"
end

function clock.update_timer(player)
    local base = math.floor(game.tick/60)
    local seconds = math.floor(base) % 60
    local minutes = math.floor(base/60) % 60
    local hours = math.floor(base/3600)

    local caption = string.format("%02d:%02d", minutes, seconds)
    if hours > 0 then
        caption = string.format("%d:%s", hours, caption)
    end
    local label = player.gui.top["wn_gui"]["wn_clock"]["wn_clock_label"]
    label.caption = caption
end


return clock
