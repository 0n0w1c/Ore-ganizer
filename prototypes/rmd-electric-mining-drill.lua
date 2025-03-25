local BASE_GRAPHICS                    = "__base__/graphics/"
local ICONS                            = BASE_GRAPHICS .. "icons/"
local ENTITY_GRAPHICS                  = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS                   = ENTITY_GRAPHICS .. "electric-mining-drill/"

local mining_drill                     = data.raw["mining-drill"]["electric-mining-drill"]

local rmd_mining_drill_displayer       = {
    type                               = "simple-entity-with-owner",
    name                               = "rmd-electric-mining-drill-displayer",
    localised_name                     = { "", { "item-name.rmd-mining-drill" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = "rmd-electric-mining-drill", count = 1 },
    minable                            = { mining_time = 0.5, result = "rmd-electric-mining-drill" },
    icon                               = ICONS .. "electric-mining-drill.png",
    icon_size                          = 64,
    radius_visualisation_specification =
    {
        sprite = {
            filename = DRILL_GRAPHICS .. "electric-mining-drill-radius-visualization.png",
            width = 12,
            height = 12,
            shift = { 0, 0 },
        },
        distance = mining_drill.resource_searching_radius
    },
    flags                              = { "placeable-neutral", "placeable-player", "player-creation" },
    max_health                         = mining_drill.max_health,
    collision_box                      = mining_drill.collision_box,
    selection_box                      = mining_drill.selection_box,
    collision_mask                     = { layers = { item = true, meltable = true, object = true, player = true, water_tile = true, is_object = true } },
    hidden_in_factoriopedia            = true,
    integration_patch                  =
    {
        east = {
            filename = DRILL_GRAPHICS .. "electric-mining-drill-E-integration.png",
            height = 214,
            priority = "high",
            scale = 0.5,
            shift = {
                0.09375,
                0.0625
            },
            width = 236
        },
        north = {
            filename = DRILL_GRAPHICS .. "electric-mining-drill-N-integration.png",
            height = 218,
            priority = "high",
            scale = 0.5,
            shift = {
                -0.03125,
                0.03125
            },
            width = 216
        },
        south = {
            filename = DRILL_GRAPHICS .. "electric-mining-drill-S-integration.png",
            height = 230,
            priority = "high",
            scale = 0.5,
            shift = {
                0,
                0.09375
            },
            width = 214
        },
        west = {
            filename = DRILL_GRAPHICS .. "electric-mining-drill-W-integration.png",
            height = 214,
            priority = "high",
            scale = 0.5,
            shift = {
                -0.125,
                0.03125
            },
            width = 234
        }
    },
    picture                            =
    {
        east =
        {
            layers =
            {
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-E.png",
                    width = 192,
                    height = 188,
                    shift = util.by_pixel(0, -4),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-E-output.png",
                    width = 50,
                    height = 74,
                    shift = util.by_pixel(30, -8),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-E-front.png",
                    width = 136,
                    height = 148,
                    shift = util.by_pixel(21, 10),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-horizontal.png",
                    width = 80,
                    height = 160,
                    shift = util.by_pixel(2, -12),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-horizontal-front.png",
                    width = 66,
                    height = 154,
                    shift = util.by_pixel(-3, 3),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-E-shadow.png",
                    width = 222,
                    height = 182,
                    draw_as_shadow = true,
                    shift = util.by_pixel(10, 2),
                    scale = 0.5
                }
            }
        },
        north =
        {
            layers =
            {
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-N.png",
                    width = 190,
                    height = 208,
                    shift = util.by_pixel(0, -4),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-N-output.png",
                    width = 60,
                    height = 66,
                    shift = util.by_pixel(-3, -44),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill.png",
                    width = 162,
                    height = 156,
                    shift = util.by_pixel(1, -11),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-N-shadow.png",
                    width = 212,
                    height = 204,
                    draw_as_shadow = true,
                    shift = util.by_pixel(6, -3),
                    scale = 0.5
                }
            }
        },
        south =
        {
            layers =
            {
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-S.png",
                    width = 184,
                    height = 192,
                    shift = util.by_pixel(0, -1),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-S-output.png",
                    width = 84,
                    height = 56,
                    shift = util.by_pixel(-1, 34),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-S-front.png",
                    width = 190,
                    height = 104,
                    shift = util.by_pixel(0, 27),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill.png",
                    width = 162,
                    height = 156,
                    shift = util.by_pixel(1, -11),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-S-shadow.png",
                    width = 212,
                    height = 204,
                    draw_as_shadow = true,
                    shift = util.by_pixel(6, 2),
                    scale = 0.5
                }
            }
        },
        west =
        {
            layers =
            {
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-W.png",
                    width = 192,
                    height = 188,
                    shift = util.by_pixel(0, -4),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-W-output.png",
                    width = 50,
                    height = 60,
                    shift = util.by_pixel(-31, -13),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-W-front.png",
                    width = 134,
                    height = 140,
                    shift = util.by_pixel(-22, 12),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-horizontal.png",
                    width = 80,
                    height = 160,
                    shift = util.by_pixel(2, -12),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-horizontal-front.png",
                    width = 66,
                    height = 154,
                    shift = util.by_pixel(-3, 3),
                    scale = 0.5
                },
                {
                    priority = "high",
                    filename = DRILL_GRAPHICS .. "electric-mining-drill-W-shadow.png",
                    width = 200,
                    height = 182,
                    draw_as_shadow = true,
                    shift = util.by_pixel(-5, 2),
                    scale = 0.5
                }
            }
        }
    }
}

local rmd_mining_drill_entity          = table.deepcopy(mining_drill)
rmd_mining_drill_entity.name           = "rmd-electric-mining-drill"
rmd_mining_drill_entity.flags          = { "placeable-neutral", "placeable-player", "player-creation", "no-copy-paste" }
rmd_mining_drill_entity.placeable_by   = { item = "rmd-electric-mining-drill", count = 1 }
rmd_mining_drill_entity.minable        = { mining_time = 0.5, result = "rmd-electric-mining-drill" }
rmd_mining_drill_entity.localised_name = { "", { "item-name.rmd-mining-drill" } }

local rmd_mining_drill_item            = table.deepcopy(data.raw["item"]["electric-mining-drill"])
rmd_mining_drill_item.name             = "rmd-electric-mining-drill"
rmd_mining_drill_item.place_result     = "rmd-electric-mining-drill-displayer"
rmd_mining_drill_item.flags            = { "primary-place-result" }
rmd_mining_drill_item.localised_name   = { "", { "item-name.rmd-mining-drill" } }
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

local rmd_mining_drill_recipe          = table.deepcopy(data.raw["recipe"]["electric-mining-drill"])
rmd_mining_drill_recipe.name           = "rmd-electric-mining-drill"
rmd_mining_drill_recipe.results        = { { type = "item", name = "rmd-electric-mining-drill", amount = 1 } }

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

local technology = data.raw["technology"]["electric-mining-drill"]
local effect =
{
    recipe = "rmd-electric-mining-drill",
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
