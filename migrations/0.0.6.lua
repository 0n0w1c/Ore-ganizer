local mod_gui = require("mod-gui")

for _, player in pairs(game.players) do
    local flow = mod_gui.get_button_flow(player)

    if flow then flow.destroy() end
end
