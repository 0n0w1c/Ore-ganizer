require("constants")

local disabled_controls = {}

for name, control in pairs(data.raw["autoplace-control"]) do
    if control.category == "resource" then
        disabled_controls[name] =
        {
            frequency = 0,
            size = 0,
            richness = 0
        }
    end
end

data.raw["map-gen-presets"]["default"]["rmd-resource-free"] =
{
    order = "z",
    basic_settings =
    {
        starting_area = 1.0,
        property_expression_names = { water = 1.0 },
        autoplace_controls = disabled_controls
    }
}

if mods["bobmining"] then
    local items = data.raw["item"]

    items["rmd-electric-mining-drill"].icons =
    {
        {
            icon = items["stone"].icon,
        },
        {
            icon = items["electric-mining-drill"].icon,
            icon_size = items["electric-mining-drill"].icon_size,
            shift = { -8, -8 }
        }
    }

    if items["bob-water-miner-1"] then
        items["rmd-bob-water-miner"].icons =
        {
            {
                icon = items["stone"].icon,
            },
            {
                icon = items["bob-water-miner-1"].icon,
                icon_size = items["bob-water-miner-1"].icon_size,
                shift = { -8, -8 }
            }
        }
    end

    local mining_drill = data.raw["mining-drill"]["rmd-electric-mining-drill"]
    mining_drill.icons =
    {
        {
            icon = items["stone"].icon,
        },
        {
            icon = items["electric-mining-drill"].icon,
            icon_size = items["electric-mining-drill"].icon_size,
            shift = { -8, -8 }
        }
    }

    local simple_entity = data.raw["simple-entity-with-owner"]["rmd-electric-mining-drill-displayer"]
    simple_entity.icons =
    {
        {
            icon = items["stone"].icon,
        },
        {
            icon = items["electric-mining-drill"].icon,
            icon_size = items["electric-mining-drill"].icon_size,
            shift = { -8, -8 }
        }
    }
end

local mining_drills = data.raw["mining-drill"]
local mining_drill

mining_drill = mining_drills["electric-mining-drill"]
if mining_drill then
    mining_drills["rmd-electric-mining-drill"].next_upgrade = mining_drill.next_upgrade or mining_drill.name
end

mining_drill = mining_drills["pumpjack"]
if mining_drill then
    mining_drills["rmd-pumpjack"].next_upgrade = mining_drill.next_upgrade or mining_drill.name
end

mining_drill = mining_drills["big-mining-drill"]
if mods["space-age"] and mining_drill then
    mining_drills["rmd-big-mining-drill"].next_upgrade = mining_drill.next_upgrade or mining_drill.name
end

mining_drill = mining_drills["bob-water-miner-1"]
if mods["bobmining"] and mining_drill then
    mining_drills["rmd-bob-water-miner"].next_upgrade = mining_drill.next_upgrade or mining_drill.name
end
