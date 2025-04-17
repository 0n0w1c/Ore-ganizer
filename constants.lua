MOD_NAME = "ore-ganizer"
MOD_PATH = "__" .. MOD_NAME .. "__"

DISABLED = "disabled"
FLUID_MULTIPLIER = 200

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

FLUID_MINING_TECHONOLOGIES =
{
    "fluid-mining",
    "uranium-mining"
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
