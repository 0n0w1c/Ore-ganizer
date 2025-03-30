if mods["bobmining"] then
    local items                              = data.raw["item"]
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
end

local mining_drills = data.raw["mining-drill"]

mining_drills["rmd-electric-mining-drill"].next_upgrade = mining_drills["electric-mining-drill"].next_upgrade
mining_drills["rmd-pumpjack"].next_upgrade = mining_drills["pumpjack"].next_upgrade

if mods["space-age"] then
    mining_drills["rmd-big-mining-drill"].next_upgrade = mining_drills["big-mining-drill"].next_upgrade
end
