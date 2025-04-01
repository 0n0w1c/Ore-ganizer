require("constants")

if not mods["space-age"] then return end

local BASE_GRAPHICS                    = "__space-age__/graphics/"
local ENTITY_GRAPHICS                  = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS                   = ENTITY_GRAPHICS .. "big-mining-drill/"

local TO_COPY                          = "big-mining-drill"
local NAME                             = "rmd-" .. TO_COPY

local mining_drill                     = data.raw["mining-drill"][TO_COPY]

local rmd_mining_drill_displayer       =
{
    type                               = "simple-entity-with-owner",
    name                               = NAME .. "-displayer",
    localised_name                     = { "", { "item-name." .. NAME .. "-displayer" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = NAME, count = 1 },
    minable                            = { mining_time = 0.5, result = NAME },
    hidden                             = true,
    icons                              =
    {
        {
            icon = data.raw["item"]["stone"].icon,
        },
        {
            icon = mining_drill.icon,
            icon_size = mining_drill.icon_size,
            shift = { -8, -8 }
        }
    },
    radius_visualisation_specification =
    {
        sprite =
        {
            filename = DRILL_GRAPHICS .. "big-mining-drill-radius-visualization.png",
            width = 12,
            height = 12,
            shift = { 0, 0 },
        },
        distance = mining_drill.resource_searching_radius
    },
    flags                              = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable" },
    max_health                         = mining_drill.max_health,
    collision_box                      = mining_drill.collision_box,
    selection_box                      = mining_drill.selection_box,
    collision_mask                     = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
    hidden_in_factoriopedia            = true,
    factoriopedia_alternative          = NAME,
    integration_patch                  =
    {
        east =
        {
            filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-integration.png",
            height = 376,
            line_length = 1,
            priority = "high",
            scale = 0.5,
            shift = { 0.109375, -0.09375 },
            width = 382
        },
        north =
        {
            filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-integration.png",
            height = 384,
            line_length = 1,
            priority = "high",
            scale = 0.5,
            shift = { 0, -0.234375 },
            width = 372
        },
        south =
        {
            filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-integration.png",
            height = 368,
            line_length = 1,
            priority = "high",
            scale = 0.5,
            shift = { 0, 0.1875 },
            width = 370
        },
        west =
        {
            filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-integration.png",
            height = 376,
            line_length = 1,
            priority = "high",
            scale = 0.5,
            shift = { -0.109375, -0.09375 },
            width = 382
        }
    },
    picture                            =
    {
        east =
        {
            layers =
            {
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-still.png",
                    height = 326,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.125 },
                    width = 318
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-still-reel.png",
                    height = 38,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.015625, 1.3125 },
                    width = 284
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-wheels.png",
                    height = 296,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.40625, -0.09375 },
                    width = 208
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-output.png",
                    height = 110,
                    priority = "high",
                    scale = 0.5,
                    shift = { 2.046875, -0.078125 },
                    width = 84
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill.png",
                    height = 226,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.734375 },
                    width = 168
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill-shadow.png",
                    height = 120,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.6875, 0.09375 },
                    width = 272,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-support.png",
                    height = 306,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5, -0.625 },
                    width = 208
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-support-shadow.png",
                    height = 288,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.84375, 0.046875 },
                    width = 248,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-still-front.png",
                    height = 352,
                    priority = "high",
                    scale = 0.5,
                    shift = { 1, -0.328125 },
                    width = 188
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-top-nozzle.png",
                    height = 68,
                    priority = "high",
                    scale = 0.5,
                    shift = { 1.203125, -2.109375 },
                    width = 118
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-top.png",
                    height = 160,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.265625, -1.75 },
                    width = 212
                },
                {
                    filename = DRILL_GRAPHICS .. "East/big-mining-drill-E-top-shadow.png",
                    height = 104,
                    priority = "high",
                    scale = 0.5,
                    shift = { 2.375, 0.28125 },
                    width = 250,
                    draw_as_shadow = true
                }
            }
        },
        north =
        {
            layers =
            {
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-still.png",
                    height = 324,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.375 },
                    width = 324
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-wheels.png",
                    height = 150,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.34375 },
                    width = 298
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-output.png",
                    height = 88,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.0625, -2.078125 },
                    width = 128
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill.png",
                    height = 226,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.734375 },
                    width = 168
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill-shadow.png",
                    height = 120,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.6875, 0.09375 },
                    width = 272,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-support.png",
                    height = 190,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.015625, -0.65625 },
                    width = 290
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-support-shadow.png",
                    height = 138,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.6875, -0.171875 },
                    width = 380,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-still-front.png",
                    height = 302,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, 0.015625 },
                    width = 320
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-top-nozzle.png",
                    height = 142,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.5625, -2.296875 },
                    width = 40
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-top.png",
                    height = 176,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.03125, -1.921875 },
                    width = 150
                },
                {
                    filename = DRILL_GRAPHICS .. "North/big-mining-drill-N-top-shadow.png",
                    height = 138,
                    priority = "high",
                    scale = 0.5,
                    shift = { 2.25, 0.046875 },
                    width = 216,
                    draw_as_shadow = true
                }
            }
        },
        south =
        {
            layers =
            {
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-still.png",
                    height = 294,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.15625 },
                    width = 324
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-wheels.png",
                    height = 150,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, 0.25 },
                    width = 300
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-output.png",
                    height = 78,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.03125, 2.03125 },
                    width = 134
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill.png",
                    height = 226,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.734375 },
                    width = 168
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill-shadow.png",
                    height = 120,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.6875, 0.09375 },
                    width = 272,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-support.png",
                    height = 190,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.640625 },
                    width = 294
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-support-shadow.png",
                    height = 138,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.6875, -0.171875 },
                    width = 380,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-still-front.png",
                    height = 176,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, 0.96875 },
                    width = 322
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-top-nozzle.png",
                    height = 192,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.578125, -1.171875 },
                    width = 40
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-top.png",
                    height = 174,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.03125, -1.640625 },
                    width = 152
                },
                {
                    filename = DRILL_GRAPHICS .. "South/big-mining-drill-S-top-shadow.png",
                    height = 140,
                    priority = "high",
                    scale = 0.5,
                    shift = { 2.109375, 0.46875 },
                    width = 206,
                    draw_as_shadow = true
                }
            }
        },
        west =
        {
            layers =
            {
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-still.png",
                    height = 326,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.125 },
                    width = 318
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-still-reel.png",
                    height = 40,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.015625, 1.296875 },
                    width = 284
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-wheels.png",
                    height = 296,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.40625, -0.09375 },
                    width = 208
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-output.png",
                    height = 108,
                    priority = "high",
                    scale = 0.5,
                    shift = { -2.046875, -0.078125 },
                    width = 86
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill.png",
                    height = 226,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0, -0.734375 },
                    width = 168
                },
                {
                    filename = DRILL_GRAPHICS .. "big-mining-drill-drill-shadow.png",
                    height = 120,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.6875, 0.09375 },
                    width = 272,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-support.png",
                    height = 306,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.328125, -0.625 },
                    width = 186
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-support-shadow.png",
                    height = 288,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.53125, 0.046875 },
                    width = 312,
                    draw_as_shadow = true
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-still-front.png",
                    height = 352,
                    priority = "high",
                    scale = 0.5,
                    shift = { -1, -0.328125 },
                    width = 188
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-top-nozzle.png",
                    height = 68,
                    priority = "high",
                    scale = 0.5,
                    shift = { -1.1875, -2.109375 },
                    width = 118
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-top.png",
                    height = 158,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.265625, -1.75 },
                    width = 214
                },
                {
                    filename = DRILL_GRAPHICS .. "West/big-mining-drill-W-top-shadow.png",
                    height = 106,
                    priority = "high",
                    scale = 0.5,
                    shift = { 2.0625, 0.28125 },
                    width = 238,
                    draw_as_shadow = true
                }
            }
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

local technology = data.raw["technology"][TO_COPY]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
