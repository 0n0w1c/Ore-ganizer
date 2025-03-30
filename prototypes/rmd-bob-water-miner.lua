if not mods["bobmining"] then return end

require("constants")

local BASE_GRAPHICS   = "__base__/graphics/"
local ICONS           = BASE_GRAPHICS .. "icons/"
local ENTITY_GRAPHICS = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS  = ENTITY_GRAPHICS .. "pumpjack/"

local TO_COPY         = "bob-water-miner-1"
local NAME            = string.sub("rmd-" .. TO_COPY, 1, -3)

if not data.raw["mining-drill"][TO_COPY] then return end

local mining_drill                     = data.raw["mining-drill"][TO_COPY]

local rmd_mining_drill_displayer       =
{
    type                               = "simple-entity-with-owner",
    name                               = NAME .. "-displayer",
    localised_name                     = { "", { "item-name." .. NAME } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = NAME, count = 1 },
    minable                            = { mining_time = 0.5, result = NAME },
    icon                               = mining_drill.icon,
    icon_size                          = mining_drill.icon_size,
    radius_visualisation_specification =
    {
        sprite =
        {
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
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015625 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pipe-covers/pipe-cover-east.png",
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
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015625 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead-shadow.png",
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
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015825 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pipe-covers/pipe-cover-south.png",
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
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-base-shadow.png",
                    height = 220,
                    scale = 0.5,
                    shift = { 0.1875, 0.015625 },
                    width = 220,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead.png",
                    height = 202,
                    priority = "high",
                    scale = 0.5,
                    shift = { -0.125, -0.75 },
                    width = 206
                },
                {
                    filename = ENTITY_GRAPHICS .. "pumpjack/pumpjack-horsehead-shadow.png",
                    height = 82,
                    priority = "high",
                    scale = 0.5,
                    shift = { 0.5546875, 0.453125 },
                    width = 309,
                    draw_as_shadow = true
                },
                {
                    filename = ENTITY_GRAPHICS .. "pipe-covers/pipe-cover-west.png",
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

local rmd_mining_drill_entity          = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_mining_drill_entity.name           = NAME
rmd_mining_drill_entity.flags          = { "placeable-neutral", "placeable-player", "player-creation" }
rmd_mining_drill_entity.placeable_by   = { item = NAME, count = 1 }
rmd_mining_drill_entity.minable        = { mining_time = 0.5, result = NAME }
rmd_mining_drill_entity.localised_name = { "", { "item-name." .. NAME } }

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

local technology = data.raw["technology"]["bob-water-miner-1"]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
