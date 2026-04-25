if not (mods["cargo-ships"] and settings.startup["offshore_oil_enabled"].value == true) then return end

require("constants")
require("utilities")

local BASE_GRAPHICS   = "__base__/graphics/"
local ENTITY_GRAPHICS = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS  = ENTITY_GRAPHICS .. "electric-mining-drill/"

local TO_COPY         = "oil_rig"
local NAME            = "rmd-" .. TO_COPY

local mining_drill    = data.raw["mining-drill"][TO_COPY]
if not mining_drill then return end

local icons = nil
if mining_drill.icons[1].icon then
    icons =
    {
        {
            icon = STONE_ICON
        },
        {
            icon = mining_drill.icons[1].icon,
            icon_size = mining_drill.icon_size,
            shift = { -8, -8 }
        }
    }
end

local rmd_mining_drill_displayer       =
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
            filename = DRILL_GRAPHICS .. "electric-mining-drill-radius-visualization.png",
            width = 12,
            height = 12
        },
        distance = mining_drill.resource_searching_radius
    },
    flags                              = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable", "not-rotatable" },
    max_health                         = mining_drill.max_health,
    collision_box                      = mining_drill.collision_box,
    selection_box                      = mining_drill.selection_box,
    collision_mask                     = { layers = { meltable = true, object = true, train = true } },
    hidden_in_factoriopedia            = true,
    factoriopedia_alternative          = TO_COPY,
    picture                            = make_oil_rig_displayer_picture(mining_drill)
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

if data.raw["recipe"]["rmd-pumpjack"] then
    replace_ingredient(rmd_mining_drill_recipe, "pumpjack", "rmd-pumpjack")
end

if mods["space-age"] then
    rmd_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

local technology = data.raw["technology"]["deep_sea_oil_extraction"]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
