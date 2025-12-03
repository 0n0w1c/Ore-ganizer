MOD_NAME = "ore-ganizer"
MOD_PATH = "__" .. MOD_NAME .. "__"

STONE_ICON = "__base__/graphics/icons/stone.png"

DISABLED = "disabled"
FLUID_MULTIPLIER = 200

EXCLUDED_CONTROLS =
{
    ["rmd_aquilo_islands"] = true
}

COLLISION_MASK =
{
    layers =
    {
        item = true,
        object = true,
        player = true,
        water_tile = true,
        meltable = true,
        is_object = true
    }
}

DISPLAYER_DRILL_NAMES = {
    ["rmd-burner-mining-drill-displayer"]          = true,
    ["rmd-electric-mining-drill-displayer"]        = true,
    ["rmd-slow-electric-mining-drill-displayer"]   = true,
    ["rmd-big-mining-drill-displayer"]             = true,
    ["rmd-area-mining-drill-displayer"]            = true,
    ["rmd-bob-area-mining-drill-1-displayer"]      = true,
    ["rmd-bob-area-mining-drill-2-displayer"]      = true,
    ["rmd-bob-area-mining-drill-3-displayer"]      = true,
    ["rmd-bob-area-mining-drill-4-displayer"]      = true,
    ["rmd-kr-electric-mining-drill-mk2-displayer"] = true,
    ["rmd-kr-electric-mining-drill-mk3-displayer"] = true,
    ["rmd-omega-drill-displayer"]                  = true,
    ["rmd-tomega-drill-displayer"]                 = true,
    ["rmd-steam-mining-drill-displayer"]           = true,
}

RMD_ENTITY_NAMES =
{
    ["rmd-burner-mining-drill"]          = true,
    ["rmd-electric-mining-drill"]        = true,
    ["rmd-slow-electric-mining-drill"]   = true,
    ["rmd-big-mining-drill"]             = true,
    ["rmd-bob-area-mining-drill-1"]      = true,
    ["rmd-bob-area-mining-drill-2"]      = true,
    ["rmd-bob-area-mining-drill-3"]      = true,
    ["rmd-bob-area-mining-drill-4"]      = true,
    ["rmd-area-mining-drill"]            = true,
    ["rmd-kr-electric-mining-drill-mk2"] = true,
    ["rmd-kr-electric-mining-drill-mk3"] = true,
    ["rmd-omega-drill"]                  = true,
    ["rmd-tomega-drill"]                 = true,
    ["rmd-pumpjack"]                     = true,
    ["rmd-bob-water-miner"]              = true,
    ["rmd-steel-derrick"]                = true,
    ["rmd-steam-mining-drill"]           = true,
}

CATEGORIES =
{
    ["basic-fluid"] = true,
    ["offshore-fluid"] = true,
    ["basic-solid"] = true,
    ["hard-solid"] = true,
    ["water"] = true,
    ["gas"] = true
}

-- Technology required to mine a resource that needs fluid
-- Extend this table when adding new modded ores.
FLUID_MINING_TECH_BY_RESOURCE = {
    ["uranium-ore"] = "uranium-mining", -- vanilla
    ["titanium-ore"] = "fluid-mining",  -- bztitanium
    -- Add more here:
    -- ["thorium-ore"] = "thorium-fluid-mining",
}

FLUID_MINING_TECHONOLOGIES =
{
    ["bztitanium"] = "fluid-mining",
    ["base"] = "uranium-mining"
}

WATER_TILES =
{
    ["ammoniacal-ocean"] = true,
    ["ammoniacal-ocean-2"] = true,
    ["deepwater"] = true,
    ["deepwater-green"] = true,
    ["water"] = true,
    ["water-green"] = true
}

TILES_TO_EXCLUDE =
{
    ["ammoniacal-ocean"] = true,
    ["ammoniacal-ocean-2"] = true,
    ["brash-ice"] = true,
    ["deepwater"] = true,
    ["deepwater-green"] = true,
    ["gleba-deep-lake"] = true,
    ["ice-platform"] = true,
    ["ice-rough"] = true,
    ["ice-smooth"] = true,
    ["lava"] = true,
    ["lava-hot"] = true,
    ["oil-ocean-deep"] = true,
    ["oil-ocean-shallow"] = true,
    ["water"] = true,
    ["water-green"] = true,
    ["water-mud"] = true,
    ["water-shallow"] = true,
    ["water-wube"] = true,
    ["wetland-blue-slime"] = true,
    ["wetland-dead-skin"] = true,
    ["wetland-green-slime"] = true,
    ["wetland-jellynut"] = true,
    ["wetland-light-dead-skin"] = true,
    ["wetland-light-green-slime"] = true,
    ["wetland-pink-tentacle"] = true,
    ["wetland-red-tentacle"] = true,
    ["wetland-yumako"] = true,
    ["space-platform-foundation"] = true
}

--[[
FOUNDATION_TILES = {
    ["landfill"] = true,
    ["space-platform-foundation"] = true,
    ["foundation"] = true,
    ["artificial-yumako-soil"] = true,
    ["overgrowth-yumako-soil"] = true,
    ["artificial-jellynut-soil"] = true,
    ["overgrowth-jellynut-soil"] = true,
    ["ice-platform"] = true
}
]]
