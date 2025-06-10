require("constants")

local rmd_shortcut =
{
    type                     = "shortcut",
    name                     = "rmd-push-button",
    action                   = "lua",
    icon                     = MOD_PATH .. "/graphics/icons/rmd-push-button-x64.png",
    icon_size                = 64,
    small_icon               = MOD_PATH .. "/graphics/icons/rmd-push-button-x64.png",
    small_icon_size          = 64,
    associated_control_input = "rmd-toggle-resource-selector",
    style                    = "default",
    order                    = "z[rmd-shortcut]"
}

local rmd_keybind =
{
    type = "custom-input",
    name = "rmd-toggle-resource-selector",
    key_sequence = "CONTROL + R",
    consuming = "none"
}

data.extend({ rmd_shortcut, rmd_keybind })

require("prototypes/rmd-burner-mining-drill")
require("prototypes/rmd-electric-mining-drill")
require("prototypes/rmd-bob-area-mining-drills")
require("prototypes/rmd-kr-electric-mining-drill-mk2")
require("prototypes/rmd-area-mining-drill")
require("prototypes/rmd-big-mining-drill")
require("prototypes/rmd-pumpjack")
require("prototypes/rmd-bob-water-miner")
require("prototypes/rmd-oil_rig")
require("prototypes/rmd-aquilo-islands")
