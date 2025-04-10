require("constants")

local rmd_shortcut =
{
    type = "shortcut",
    name = "rmd-push-button",
    action = "lua",
    icon = MOD_PATH .. "/graphics/icons/rmd-push-button-x32.png",
    icon_size = 32,
    small_icon = MOD_PATH .. "/graphics/icons/rmd-push-button-x24.png",
    small_icon_size = 24,
    associated_control_input = "give-rmd-push-button",
    style = "default",
    order = "z[rmd-shortcut]"
}

data.extend({ rmd_shortcut })

require("prototypes/rmd-burner-mining-drill")
require("prototypes/rmd-electric-mining-drill")
require("prototypes/rmd-big-mining-drill")
require("prototypes/rmd-pumpjack")
require("prototypes/rmd-bob-water-miner")
require("prototypes/rmd-oil_rig")
