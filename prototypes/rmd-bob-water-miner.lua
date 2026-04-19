require("constants")

if not mods["bobmining"] then return end

local BASE_GRAPHICS   = "__base__/graphics/"
local ENTITY_GRAPHICS = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS  = ENTITY_GRAPHICS .. "pumpjack/"

local TO_COPY         = "bob-water-miner-1"
local NAME            = string.sub("rmd-" .. TO_COPY, 1, -3)

if not data.raw["mining-drill"][TO_COPY] then return end
--if not (data.raw["resource"]["bob-ground-water"] or data.raw["resource"]["bob-lithia-water"]) then return end

local mining_drill = data.raw["mining-drill"][TO_COPY]
if not mining_drill then return end

local display_picture = copy_displayer_picture_from_picture_field(mining_drill)

local function replace_base_layer(direction, filename, shift)
    local directional_picture = display_picture and display_picture[direction]
    local layers = directional_picture and directional_picture.layers
    local base_layer = layers and layers[1]
    if not base_layer then return end

    base_layer.filename = filename
    if shift then
        base_layer.shift = shift
    end
end

replace_base_layer("east", MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-E.png")
replace_base_layer("north", MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-N.png")
replace_base_layer("south", MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-S.png", { 0.1203125, -0.1884375 })
replace_base_layer("west", MOD_PATH .. "/graphics/entity/pumpjack/rmd-pumpjack-base-W.png")

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
    picture                            = display_picture
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

local technology = data.raw["technology"]["bob-water-miner-1"]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
