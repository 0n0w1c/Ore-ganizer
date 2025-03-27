require("constants")

local rmd_sprite =
{
  type = "sprite",
  name = "rmd-disabled",
  filename = MOD_PATH .. "/graphics/icons/rmd-disabled-x64.png",
  width = 64,
  height = 64,
  priority = "high"
}

local rmd_shortcut =
{
  type = "shortcut",
  name = "rmd-toggle-button",
  action = "lua",
  icon = MOD_PATH .. "/graphics/icons/rmd-toggle-x32.png",
  icon_size = 32,
  small_icon = MOD_PATH .. "/graphics/icons/rmd-toggle-x24.png",
  small_icon_size = 24,
  associated_control_input = "give-rmd-toggle-button",
  style = "default",
  toggleable = true,
  order = "f[toggle-button]"
}

data.extend({ rmd_sprite, rmd_shortcut })

require("prototypes/rmd-electric-mining-drill")
require("prototypes/rmd-big-mining-drill")
require("prototypes/rmd-pumpjack")
