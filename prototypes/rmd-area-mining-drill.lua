require("constants")

if not mods["aai-industry"] then return end
if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then return end

local BASE_GRAPHICS                         = "__base__/graphics/"
local ENTITY_GRAPHICS                       = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS                        = ENTITY_GRAPHICS .. "electric-mining-drill/"
local AAI_INDUSTRY_ASSETS                   = "__aai-industry__/graphics/entity/area-mining-drill/"

local TO_COPY                               = "area-mining-drill"
local NAME                                  = "rmd-" .. TO_COPY

local mining_drill                          = data.raw["mining-drill"][TO_COPY]

local rmd_area_mining_drill_displayer       =
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
            width = 6,
            height = 6,
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
    integration_patch                  = data.raw["mining-drill"]["area-mining-drill"].integration_patch,
    picture                            = {
        north = {
            layers = {
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-N.png",
                    width = 194,
                    height = 242,
                    shift = util.by_pixel(0, -12),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-N-output.png",
                    width = 72,
                    height = 66,
                    shift = util.by_pixel(-1, -44),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-N-shadow.png",
                    width = 274,
                    height = 206,
                    draw_as_shadow = true,
                    shift = util.by_pixel(19, -3),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill.png",
                    width = 194,
                    height = 154,
                    shift = util.by_pixel(0, -12),
                    scale = 0.75,
                },
            },
        },
        east = {
            layers = {
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-E.png",
                    width = 194,
                    height = 94,
                    shift = util.by_pixel(0, -33),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-E-output.png",
                    width = 50,
                    height = 56,
                    shift = util.by_pixel(30, -11),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-E-shadow.png",
                    width = 276,
                    height = 170,
                    draw_as_shadow = true,
                    shift = util.by_pixel(20, 6),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-horizontal.png",
                    width = 154,
                    height = 194,
                    shift = util.by_pixel(0, -12),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-E-front.png",
                    width = 208,
                    height = 186,
                    shift = util.by_pixel(3, 2),
                    scale = 0.75,
                },
            },
        },
        south = {
            layers = {
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-S.png",
                    width = 194,
                    height = 240,
                    shift = util.by_pixel(0, -7),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-S-shadow.png",
                    width = 274,
                    height = 204,
                    draw_as_shadow = true,
                    shift = util.by_pixel(19, 2),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-S-output.png",
                    width = 82,
                    height = 56,
                    shift = util.by_pixel(-1, 34),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill.png",
                    width = 194,
                    height = 154,
                    shift = util.by_pixel(0, -12),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-S-front.png",
                    width = 172,
                    height = 42,
                    shift = util.by_pixel(0, 13),
                    scale = 0.75,
                },
            },
        },
        west = {
            layers = {
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-W.png",
                    width = 194,
                    height = 94,
                    shift = util.by_pixel(0, -33),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-W-output.png",
                    width = 50,
                    height = 56,
                    shift = util.by_pixel(-31, -12),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-W-shadow.png",
                    width = 282,
                    height = 170,
                    draw_as_shadow = true,
                    shift = util.by_pixel(15, 6),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-horizontal.png",
                    width = 154,
                    height = 194,
                    shift = util.by_pixel(0, -12),
                    scale = 0.75,
                },
                {
                    priority = "high",
                    filename = AAI_INDUSTRY_ASSETS .. "area-mining-drill-W-front.png",
                    width = 210,
                    height = 190,
                    shift = util.by_pixel(-4, 1),
                    scale = 0.75,
                },
            },
        },
    },
}

local rmd_area_mining_drill_entity          = table.deepcopy(data.raw["mining-drill"][TO_COPY])
rmd_area_mining_drill_entity.name           = NAME
rmd_area_mining_drill_entity.placeable_by   = { item = NAME, count = 1 }
rmd_area_mining_drill_entity.minable        = { mining_time = 0.5, result = NAME }
rmd_area_mining_drill_entity.localised_name = { "", { "item-name." .. NAME } }
rmd_area_mining_drill_entity.icons          =
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

local rmd_area_mining_drill_item            = table.deepcopy(data.raw["item"][TO_COPY])
rmd_area_mining_drill_item.name             = NAME
rmd_area_mining_drill_item.place_result     = NAME .. "-displayer"
rmd_area_mining_drill_item.flags            = { "primary-place-result" }
rmd_area_mining_drill_item.localised_name   = { "", { "item-name." .. NAME } }
rmd_area_mining_drill_item.icons            =
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

local rmd_area_mining_drill_recipe          = table.deepcopy(data.raw["recipe"][TO_COPY])
rmd_area_mining_drill_recipe.name           = NAME
rmd_area_mining_drill_recipe.results        = { { type = "item", name = NAME, amount = 1 } }

if mods["space-age"] then
    rmd_area_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_area_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

data.extend
({
    rmd_area_mining_drill_displayer,
    rmd_area_mining_drill_entity,
    rmd_area_mining_drill_item,
    rmd_area_mining_drill_recipe
})

local technology = data.raw["technology"][TO_COPY]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
