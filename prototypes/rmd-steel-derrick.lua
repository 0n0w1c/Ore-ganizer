if not (mods["IR3_Assets_mining_drills"] and data.raw["mining-drill"]["steel-derrick"]) then return end

require("constants")

local BASE_GRAPHICS   = "__base__/graphics/"
local ENTITY_GRAPHICS = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS  = ENTITY_GRAPHICS .. "pumpjack/"

local TO_COPY         = "steel-derrick"
local NAME            = "rmd-" .. TO_COPY

local mining_drill    = data.raw["mining-drill"][TO_COPY]
if not mining_drill then return end

local icons = nil
if mining_drill.icon then
    icons =
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
end

local pipe_covers       = {
    north = {
        layers = {
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-iron-cn.png",   height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { 0, -1 } },
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-shadow-cn.png", height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { 0, -1 }, draw_as_shadow = true }
        }
    },

    east = {
        layers = {
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-iron-ce.png",   height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { 1, 0 } },
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-shadow-ce.png", height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { 1, 0 }, draw_as_shadow = true }
        }
    },

    south = {
        layers = {
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-iron-cs.png",   height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { 0, 1 } },
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-shadow-cs.png", height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { 0, 1 }, draw_as_shadow = true }
        }
    },

    west = {
        layers = {
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-iron-cw.png",   height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { -1, 0 } },
            { filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-shadow-cw.png", height = 120, priority = "extra-high", scale = 0.5, width = 180, shift = { -1, 0 }, draw_as_shadow = true }
        }
    }
}

local display_animation = copy_displayer_picture_from_animation(mining_drill)
add_layers_to_directional_picture(display_animation, pipe_covers)

local rmd_mining_drill_displayer                       =
{
    type                               = "simple-entity-with-owner",
    name                               = NAME .. "-displayer",
    localised_name                     = { "", { "item-name." .. NAME .. "-displayer" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = NAME, count = 1 },
    minable                            = { mining_time = 0.5, result = NAME },
    icon                               = BROKEN_ICON,
    icon_size                          = 64,
    icons                              = icons,
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
    flags                              = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable" },
    max_health                         = mining_drill.max_health,
    collision_box                      = mining_drill.collision_box,
    selection_box                      = mining_drill.selection_box,
    collision_mask                     = COLLISION_MASK,
    hidden_in_factoriopedia            = true,
    factoriopedia_alternative          = NAME,
    drawing_box_vertical_extension     = 1,
    picture                            = display_animation
}

local rmd_mining_drill_entity                          = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_mining_drill_entity.name                           = NAME
rmd_mining_drill_entity.placeable_by                   = { item = NAME, count = 1 }
rmd_mining_drill_entity.minable                        = { mining_time = 0.5, result = NAME }
rmd_mining_drill_entity.localised_name                 = { "", { "item-name." .. NAME } }
rmd_mining_drill_entity.drawing_box_vertical_extension = 1
rmd_mining_drill_entity.icon                           = BROKEN_ICON
rmd_mining_drill_entity.icon_size                      = 64
rmd_mining_drill_entity.icons                          = icons

local rmd_mining_drill_item                            = table.deepcopy(data.raw["item"][TO_COPY])
if not rmd_mining_drill_item or rmd_mining_drill_item.hidden then return end

rmd_mining_drill_item.name           = NAME
rmd_mining_drill_item.place_result   = NAME .. "-displayer"
rmd_mining_drill_item.flags          = { "primary-place-result" }
rmd_mining_drill_item.localised_name = { "", { "item-name." .. NAME } }
rmd_mining_drill_item.order          = rmd_mining_drill_item.order .. "z"
rmd_mining_drill_item.icon           = BROKEN_ICON
rmd_mining_drill_item.icon_size      = 64
rmd_mining_drill_item.icons          = icons

local rmd_mining_drill_recipe        = table.deepcopy(data.raw["recipe"][TO_COPY])
if not rmd_mining_drill_recipe or rmd_mining_drill_recipe.hidden then return end

rmd_mining_drill_recipe.name    = NAME
rmd_mining_drill_recipe.results = { { type = "item", name = NAME, amount = 1 } }

if mods["space-age"] then
    rmd_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

local technology = data.raw["technology"]["oil-gathering"]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
