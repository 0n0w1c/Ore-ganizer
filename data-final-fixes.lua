require("constants")

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

if mining_drills["electric-mining-drill"].next_upgrade then
    mining_drills["rmd-electric-mining-drill"].next_upgrade = mining_drills["electric-mining-drill"].next_upgrade
else
    mining_drills["rmd-electric-mining-drill"].next_upgrade = mining_drills["electric-mining-drill"].name
end

if mining_drills["pumpjack"].next_upgrade then
    mining_drills["rmd-pumpjack"].next_upgrade = mining_drills["pumpjack"].next_upgrade
else
    mining_drills["rmd-pumpjack"].next_upgrade = mining_drills["pumpjack"].name
end

if mods["bobmining"] then
    if mining_drills["bob-water-miner-1"] and mining_drills["bob-water-miner-1"].next_upgrade then
        mining_drills["rmd-bob-water-miner"].next_upgrade = mining_drills["bob-water-miner-1"].next_upgrade
    else
        mining_drills["rmd-bob-water-miner"].next_upgrade = mining_drills["bob-water-miner-1"].name
    end
end

if mods["space-age"] then
    if mining_drills["big-mining-drill"].next_upgrade then
        mining_drills["rmd-big-mining-drill"].next_upgrade = mining_drills["big-mining-drill"].next_upgrade
    else
        mining_drills["rmd-big-mining-drill"].next_upgrade = mining_drills["big-mining-drill"].name
    end
end
