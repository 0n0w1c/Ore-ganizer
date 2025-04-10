require("constants")

local TO_COPY                          = "burner-mining-drill"
local NAME                             = "rmd-" .. TO_COPY

local mining_drill                     = data.raw["mining-drill"][TO_COPY]

local rmd_mining_drill_displayer       =
{
    type                      = "simple-entity-with-owner",
    name                      = NAME .. "-displayer",
    localised_name            = { "", { "item-name." .. NAME .. "-displayer" } },
    localised_description     = mining_drill.localised_description,
    placeable_by              = { item = NAME, count = 1 },
    minable                   = { mining_time = 0.5, result = NAME },
    flags                     = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable" },
    max_health                = mining_drill.max_health,
    collision_box             = mining_drill.collision_box,
    selection_box             = mining_drill.selection_box,
    collision_mask            = COLLISION_MASK,
    hidden_in_factoriopedia   = true,
    factoriopedia_alternative = NAME,
    picture                   = mining_drill.graphics_set.animation,
    icons                     =
    {
        {
            icon = data.raw["item"]["stone"].icon,
        },
        {
            icon = mining_drill.icon,
            icon_size = mining_drill.icon_size,
            shift = { -8, -8 }
        }
    }
}

local rmd_mining_drill_entity          = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_mining_drill_entity.name           = NAME
rmd_mining_drill_entity.placeable_by   = { item = NAME, count = 1 }
rmd_mining_drill_entity.minable        = { mining_time = 0.5, result = NAME }
rmd_mining_drill_entity.localised_name = { "", { "item-name." .. NAME } }
rmd_mining_drill_entity.icons          =
{
    {
        icon = data.raw["item"]["stone"].icon,
    },
    {
        icon = mining_drill.icon,
        icon_size = mining_drill.icon_size,
        shift = { -8, -8 }
    }
}

local rmd_mining_drill_item            = table.deepcopy(data.raw["item"][TO_COPY])
rmd_mining_drill_item.name             = NAME
rmd_mining_drill_item.place_result     = NAME .. "-displayer"
rmd_mining_drill_item.flags            = { "primary-place-result" }
rmd_mining_drill_item.localised_name   = { "", { "item-name." .. NAME } }
rmd_mining_drill_item.icons            =
{
    {
        icon = data.raw["item"]["stone"].icon,
    },
    {
        icon = mining_drill.icon,
        icon_size = mining_drill.icon_size,
        shift = { -8, -8 }
    }
}

local rmd_mining_drill_recipe          = table.deepcopy(data.raw["recipe"][TO_COPY])
rmd_mining_drill_recipe.name           = NAME
rmd_mining_drill_recipe.results        = { { type = "item", name = NAME, amount = 1 } }

if mods["space-age"] then
    rmd_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })
