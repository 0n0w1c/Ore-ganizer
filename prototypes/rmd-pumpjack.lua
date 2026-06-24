if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then return end

require("constants")

local BASE_GRAPHICS   = "__base__/graphics/"
local ENTITY_GRAPHICS = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS  = ENTITY_GRAPHICS .. "pumpjack/"

local TO_COPY         = "pumpjack"
local NAME            = "rmd-" .. TO_COPY

local mining_drill    = data.raw["mining-drill"][TO_COPY]
if not mining_drill then return end

local display_graphics_set = table.deepcopy(mining_drill.graphics_set)
local flipped_display_graphics_set = table.deepcopy(mining_drill.graphics_set_flipped)

local function make_displayer_fluid_boxes(pumpjack)
    if not (pumpjack and pumpjack.output_fluid_box) then return nil end

    local fluid_box = table.deepcopy(pumpjack.output_fluid_box)
    fluid_box.production_type = fluid_box.production_type or "output"

    return { fluid_box }
end

local displayer_fluid_boxes            = make_displayer_fluid_boxes(mining_drill)

local icons                            = make_rmd_icons(mining_drill, { -8, -8 })

local recycler_prototype               = data.raw["furnace"] and data.raw["furnace"]["recycler"]

local rmd_mining_drill_displayer       =
{
    type                               = "furnace",
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

    crafting_categories                = recycler_prototype and table.deepcopy(recycler_prototype.crafting_categories) or
        { "smelting" },
    crafting_speed                     = 1,
    source_inventory_size              = recycler_prototype and recycler_prototype.source_inventory_size or 1,
    result_inventory_size              = recycler_prototype and recycler_prototype.result_inventory_size or 1,
    fluid_boxes                        = displayer_fluid_boxes,
    energy_usage                       = "1W",
    energy_source                      =
    {
        type = "electric",
        usage_priority = "secondary-input",
        drain = "0W"
    },
    allowed_effects                    = {},

    vector_to_place_result             = recycler_prototype and table.deepcopy(recycler_prototype.vector_to_place_result) or
        { -0.35, -2.3 },
    use_mirroring                      = recycler_prototype and recycler_prototype.use_mirroring or true,
    migrate_horizontal_mirroring       = mining_drill.migrate_horizontal_mirroring,

    graphics_set                       = display_graphics_set,
    graphics_set_flipped               = flipped_display_graphics_set
        or display_graphics_set
}

local rmd_mining_drill_entity          = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_mining_drill_entity.name           = NAME
rmd_mining_drill_entity.placeable_by   = { item = NAME, count = 1 }
rmd_mining_drill_entity.minable        = { mining_time = 0.5, result = NAME }
rmd_mining_drill_entity.localised_name = { "", { "item-name." .. NAME } }
rmd_mining_drill_entity.icon           = BROKEN_ICON
rmd_mining_drill_entity.icon_size      = 64
rmd_mining_drill_entity.icons          = icons

local rmd_mining_drill_item            = table.deepcopy(data.raw["item"][TO_COPY])
if not rmd_mining_drill_item or rmd_mining_drill_item.hidden then return end

rmd_mining_drill_item.name           = NAME
rmd_mining_drill_item.place_result   = NAME .. "-displayer"
rmd_mining_drill_item.flags          = { "primary-place-result" }
rmd_mining_drill_item.localised_name = { "", { "item-name." .. NAME } }
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
