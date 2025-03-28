local mod_gui = require("mod-gui")

for _, player in pairs(game.players) do
    local flow = mod_gui.get_button_flow(player)
    if flow and flow.valid then
        flow.destroy()
    end

    for _, root in pairs({ player.gui.top, player.gui.left }) do
        local leftover = root.mod_gui_top_frame
        if leftover and leftover.valid then
            leftover.destroy()
        end
    end
end
