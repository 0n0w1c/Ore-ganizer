require("constants")

local BASE_GRAPHICS                               = "__base__/graphics/"
local ENTITY_GRAPHICS                             = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS                              = ENTITY_GRAPHICS .. "electric-mining-drill/"

local TO_COPY                                     = "electric-mining-drill"
local NAME                                        = "rmd-" .. TO_COPY

local mining_drill                                = data.raw["mining-drill"][TO_COPY]
local radius                                      = get_effective_mining_radius(mining_drill)

local rmd_mining_drill_displayer                  =
{
    type                               = "simple-entity-with-owner",
    name                               = NAME .. "-displayer",
    localised_name                     = { "", { "item-name." .. NAME .. "-displayer" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = NAME, count = 1 },
    minable                            = { mining_time = 0.5, result = NAME },
    icons                              =
    {
        {
            icon = STONE_ICON
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
            filename = DRILL_GRAPHICS .. "electric-mining-drill-radius-visualization.png",
            width = 12,
            height = 12,
            shift = { 0, 0 },
        },
        distance = radius
    },
    flags                              = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable" },
    max_health                         = mining_drill.max_health,
    collision_box                      = mining_drill.collision_box,
    selection_box                      = mining_drill.selection_box,
    collision_mask                     = COLLISION_MASK,
    hidden_in_factoriopedia            = true,
    factoriopedia_alternative          = NAME,
    integration_patch                  =
    {
        east =
        {
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
        north =
        {
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
        south =
        {
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
        west =
        {
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

local rmd_mining_drill_entity                     = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_mining_drill_entity.name                      = NAME
rmd_mining_drill_entity.placeable_by              = { item = NAME, count = 1 }
rmd_mining_drill_entity.resource_searching_radius = radius
rmd_mining_drill_entity.minable                   = { mining_time = 0.5, result = NAME }
rmd_mining_drill_entity.localised_name            = { "", { "item-name." .. NAME } }
rmd_mining_drill_entity.icons                     =
{
    {
        icon = STONE_ICON
    },
    {
        icon = mining_drill.icon,
        icon_size = mining_drill.icon_size,
        shift = { -8, -8 }
    }
}

local rmd_mining_drill_item                       = table.deepcopy(data.raw["item"][TO_COPY])
rmd_mining_drill_item.name                        = NAME
rmd_mining_drill_item.place_result                = NAME .. "-displayer"
rmd_mining_drill_item.flags                       = { "primary-place-result" }
rmd_mining_drill_item.localised_name              = { "", { "item-name." .. NAME } }
rmd_mining_drill_item.icons                       =
{
    {
        icon = STONE_ICON
    },
    {
        icon = mining_drill.icon,
        icon_size = mining_drill.icon_size,
        shift = { -8, -8 }
    }
}

local rmd_mining_drill_recipe                     = table.deepcopy(data.raw["recipe"][TO_COPY])
rmd_mining_drill_recipe.name                      = NAME
rmd_mining_drill_recipe.results                   = { { type = "item", name = NAME, amount = 1 } }

if mods["space-age"] then
    rmd_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

if mods["IR3_Assets_mining_drills"] then
    rmd_mining_drill_displayer.lower_pictures    = mining_drill.graphics_set.working_visualisations[1].animation
    rmd_mining_drill_displayer.integration_patch = nil
    rmd_mining_drill_displayer.picture           =
    {
        north = { layers = mining_drill.graphics_set.working_visualisations[2].north_animation.layers },
        east = { layers = mining_drill.graphics_set.working_visualisations[2].east_animation.layers },
        south = { layers = mining_drill.graphics_set.working_visualisations[2].south_animation.layers },
        west = { layers = mining_drill.graphics_set.working_visualisations[2].west_animation.layers },
    }
end

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

local technology = data.raw["technology"][TO_COPY]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
