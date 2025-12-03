require("constants")

local BASE_GRAPHICS                    = "__base__/graphics/"
local ENTITY_GRAPHICS                  = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS                   = ENTITY_GRAPHICS .. "electric-mining-drill/"

local TO_COPY                          = "steam-mining-drill"
local NAME                             = "rmd-" .. TO_COPY

local mining_drill                     = data.raw["mining-drill"][TO_COPY]
local radius                           = get_effective_mining_radius(mining_drill)

local rmd_mining_drill_displayer       =
{
    type                               = "simple-entity-with-owner",
    name                               = NAME .. "-displayer",
    localised_name                     = { "", { "item-name." .. NAME .. "-displayer" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = NAME, count = 1 },
    minable                            = { mining_time = 0.5, result = NAME },
    flags                              = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable" },
    max_health                         = mining_drill.max_health,
    collision_box                      = mining_drill.collision_box,
    selection_box                      = mining_drill.selection_box,
    collision_mask                     = COLLISION_MASK,
    hidden_in_factoriopedia            = true,
    factoriopedia_alternative          = NAME,
    picture                            = mining_drill.graphics_set.animation,
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
    icons                              = {
        {
            icon = STONE_ICON
        },
        {
            icon = "__IndustrialRevolution3Assets1__/graphics/icons/64/burner-mining-drill.png",
            shift = { -8, -8 },
            icon_size = 64
        },
        {
            icon = "__IndustrialRevolution3Assets1__/graphics/icons/64/steam.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -16, 8.5 }
        }
    }
}

local rmd_mining_drill_entity          = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_mining_drill_entity.name           = NAME
rmd_mining_drill_entity.placeable_by   = { item = NAME, count = 1 }
rmd_mining_drill_entity.minable        = { mining_time = 0.5, result = NAME }
rmd_mining_drill_entity.localised_name = { "", { "item-name." .. NAME } }
rmd_mining_drill_entity.icon           = data.raw["item"]["stone"].icon
rmd_mining_drill_entity.next_upgrade   = TO_COPY
rmd_mining_drill_entity.icons          = {
    {
        icon = STONE_ICON
    },
    {
        icon = "__IndustrialRevolution3Assets1__/graphics/icons/64/burner-mining-drill.png",
        shift = { -8, -8 },
        icon_size = 64
    },
    {
        icon = "__IndustrialRevolution3Assets1__/graphics/icons/64/steam.png",
        icon_size = 64,
        scale = 0.25,
        shift = { -16, 8.5 }
    }
}

local rmd_mining_drill_item            = table.deepcopy(data.raw["item"][TO_COPY])
rmd_mining_drill_item.name             = NAME
rmd_mining_drill_item.place_result     = NAME .. "-displayer"
rmd_mining_drill_item.flags            = { "primary-place-result" }
rmd_mining_drill_item.localised_name   = { "", { "item-name." .. NAME } }
rmd_mining_drill_item.order            = rmd_mining_drill_item.order .. "z"

rmd_mining_drill_item.icons            = {
    {
        icon = STONE_ICON
    },
    {
        icon = "__IndustrialRevolution3Assets1__/graphics/icons/64/burner-mining-drill.png",
        shift = { -8, -8 },
        icon_size = 64
    },
    {
        icon = "__IndustrialRevolution3Assets1__/graphics/icons/64/steam.png",
        icon_size = 64,
        scale = 0.25,
        shift = { -16, 8.5 }
    }
}

local rmd_mining_drill_recipe          = table.deepcopy(data.raw["recipe"][TO_COPY])
rmd_mining_drill_recipe.name           = NAME
rmd_mining_drill_recipe.results        = { { type = "item", name = NAME, amount = 1 } }
rmd_mining_drill_recipe.enabled        = false

if mods["space-age"] then
    rmd_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

if mods["IR3_Assets_steamworks"] then
    local base_vis     = mining_drill.graphics_set.working_visualisations[2]

    local north_layers = table.deepcopy(base_vis.north_animation.layers)
    local east_layers  = table.deepcopy(base_vis.east_animation.layers)
    local south_layers = table.deepcopy(base_vis.south_animation.layers)
    local west_layers  = table.deepcopy(base_vis.west_animation.layers)

    if not (north_layers and east_layers and south_layers and west_layers) then return end

    table.insert(north_layers, 1,
        {
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/copper-drill-underlay-rail.png",
            priority = "high",
            width = 384,
            height = 384,
            line_length = 1,
            scale = 0.5,
            shift = { 0, 0 }
        }
    )

    table.insert(north_layers, 2,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 80,
            priority = "high",
            scale = 0.5,
            shift = { -1.75, 0 },
            width = 160,
            x = 0,
            y = 152
        }
    )

    table.insert(north_layers, 3,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-ce.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { 2, 0 },
            width = 180
        }
    )

    table.insert(north_layers, 4,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 80,
            priority = "high",
            scale = 0.5,
            shift = { 1.75, 0 },
            width = 160,
            x = 224,
            y = 152
        }
    )

    table.insert(north_layers, 5,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-cw.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { -2, 0 },
            width = 180
        }
    )

    table.insert(east_layers, 1,
        {
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/copper-drill-underlay-rail.png",
            priority = "high",
            width = 384,
            height = 384,
            line_length = 1,
            scale = 0.5,
            shift = { 0, 0 }
        }
    )

    table.insert(east_layers, 2,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 120,
            priority = "high",
            scale = 0.5,
            shift = { 0.3125, 2 },
            width = 120,
            x = 152,
            y = 264
        }
    )


    table.insert(east_layers, 3,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-cn.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { 0, -2 },
            width = 180,
        }
    )

    table.insert(east_layers, 4,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 120,
            priority = "high",
            scale = 0.5,
            shift = { 0.3125, -2 },
            width = 120,
            x = 152,
            y = 0
        }
    )

    table.insert(east_layers, 5,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-cs.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { 0, 1.92 },
            width = 180,
        }
    )

    table.insert(south_layers, 1,
        {
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/copper-drill-underlay-rail.png",
            priority = "high",
            width = 384,
            height = 384,
            line_length = 1,
            scale = 0.5,
            shift = { 0, 0 }
        }
    )

    table.insert(south_layers, 2,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 80,
            priority = "high",
            scale = 0.5,
            shift = { -1.75, 0 },
            width = 160,
            x = 0,
            y = 152
        }
    )

    table.insert(south_layers, 3,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-ce.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { 2, 0 },
            width = 180
        }
    )

    table.insert(south_layers, 4,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 80,
            priority = "high",
            scale = 0.5,
            shift = { 1.75, 0 },
            width = 160,
            x = 224,
            y = 152
        }
    )

    table.insert(south_layers, 5,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-cw.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { -2, 0 },
            width = 180
        }
    )

    table.insert(west_layers, 1,
        {
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/copper-drill-underlay-rail.png",
            priority = "high",
            width = 384,
            height = 384,
            line_length = 1,
            scale = 0.5,
            shift = { 0, 0 }
        }
    )

    table.insert(west_layers, 2,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 120,
            priority = "high",
            scale = 0.5,
            shift = { 0.3125, 2 },
            width = 120,
            x = 152,
            y = 264
        }
    )


    table.insert(west_layers, 3,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-cn.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { 0, -2 },
            width = 180,
        }
    )

    table.insert(west_layers, 4,
        {
            draw_as_glow = false,
            draw_as_light = false,
            draw_as_shadow = false,
            filename =
            "__IndustrialRevolution3Assets4__/graphics/entities/machines/drills/steam-drill-connectors-base.png",
            height = 120,
            priority = "high",
            scale = 0.5,
            shift = { 0.3125, -2 },
            width = 120,
            x = 152,
            y = 0
        }
    )

    table.insert(west_layers, 5,
        {
            filename = "__IndustrialRevolution3Assets2__/graphics/entities/pipes/pipe-steam-cs.png",
            height = 120,
            priority = "extra-high",
            scale = 0.5,
            shift = { 0, 1.92 },
            width = 180,
        }
    )

    rmd_mining_drill_displayer.picture = {
        north = { layers = north_layers },
        east  = { layers = east_layers },
        south = { layers = south_layers },
        west  = { layers = west_layers },
    }
end

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

local technology = data.raw["technology"]["steam-automation"]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
