require("constants")

local BASE_GRAPHICS              = "__base__/graphics/"
local ICONS                      = BASE_GRAPHICS .. "icons/"
local ENTITY_GRAPHICS            = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS             = ENTITY_GRAPHICS .. "pumpjack/"

local mining_drill               = data.raw["mining-drill"]["pumpjack"]

local rmd_mining_drill_displayer = {
    type                               = "simple-entity-with-owner",
    name                               = "rmd-pumpjack-displayer",
    localised_name                     = { "", { "item-name.rmd-pumpjack" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = "rmd-pumpjack", count = 1 },
    minable                            = { mining_time = 0.5, result = "rmd-pumpjack" },
    icon                               = ICONS .. "pumpjack.png",
    icon_size                          = 64,
    radius_visualisation_specification =
    {
        sprite = {
            filename = DRILL_GRAPHICS .. "pumpjack-radius-visualization.png",
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
    picture                            =
    {
        east =
        {
            layers =
            {
                {
                    filename = MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-E.png",
                    height = 273,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = { -0.0703125, -0.1484375 },
                    width = 261
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015625 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = util.by_pixel(63.5, -33.5),
                    width = 128
                },
            }
        },
        north =
        {
            layers =
            {
                {
                    filename = MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-N.png",
                    height = 273,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = { -0.0703125, -0.1484375 },
                    width = 261
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015625 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
            }
        },
        south =
        {
            layers =
            {
                {
                    filename = MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-S.png",
                    height = 273,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = { 0.1203125, -0.1884375 },
                    width = 261
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015825 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = util.by_pixel(-30, 63),
                    width = 128
                },
            }
        },
        west =
        {
            layers =
            {
                {
                    filename = MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-W.png",
                    height = 273,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = { -0.0703125, -0.1484375 },
                    width = 261
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015625 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = "__base__/graphics/entity/pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
                {
                    filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
                    height = 128,
                    priority = "extra-high",
                    scale = 0.5,
                    shift = util.by_pixel(-63, 32.5),
                    width = 128
                },
            }
        }
    }
}


local rmd_mining_drill_entity          = table.deepcopy(mining_drill)
rmd_mining_drill_entity.name           = "rmd-pumpjack"
rmd_mining_drill_entity.flags          = { "placeable-neutral", "placeable-player", "player-creation", "no-copy-paste" }
rmd_mining_drill_entity.placeable_by   = { item = "rmd-pumpjack", count = 1 }
rmd_mining_drill_entity.minable        = { mining_time = 0.5, result = "rmd-pumpjack" }
rmd_mining_drill_entity.localised_name = { "", { "item-name.rmd-pumpjack" } }

local rmd_mining_drill_item            = table.deepcopy(data.raw["item"]["pumpjack"])
rmd_mining_drill_item.name             = "rmd-pumpjack"
rmd_mining_drill_item.place_result     = "rmd-pumpjack-displayer"
rmd_mining_drill_item.flags            = { "primary-place-result" }
rmd_mining_drill_item.localised_name   = { "", { "item-name.rmd-pumpjack" } }
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

local rmd_mining_drill_recipe          = table.deepcopy(data.raw["recipe"]["pumpjack"])
rmd_mining_drill_recipe.name           = "rmd-pumpjack"
rmd_mining_drill_recipe.results        = { { type = "item", name = "rmd-pumpjack", amount = 1 } }

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

if mods["space-age"] and not IGNORE then
    rmd_mining_drill_displayer.surface_conditions = { { min = 1, property = "gravity" } }
end

local technology = data.raw["technology"]["oil-gathering"]
local effect =
{
    recipe = "rmd-pumpjack",
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
