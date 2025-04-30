require("constants")

if mods["space-age"] then
    local aquilo = data.raw["planet"] and data.raw["planet"]["aquilo"]
    if aquilo and aquilo.map_gen_settings then
        aquilo.map_gen_settings.autoplace_settings.entity.settings["rmd-aquilo-islands"] = {}
        aquilo.map_gen_settings.autoplace_controls =
        {
            aquilo_crude_oil = {},
            fluorine_vent = {},
            lithium_brine = {},
            rmd_aquilo_islands = {}
        }
    end

    data.raw["noise-expression"]["aquilo_island_peaks"] =
    {
        type = "noise-expression",
        name = "aquilo_island_peaks",
        expression =
        "max(1.7 * (0.3 + aquilo_starting_island), 1.5 * (0.5 + max(aquilo_starting_crude_oil, aquilo_crude_oil_spots, aquilo_starting_lithium_brine, aquilo_lithium_brine_spots, aquilo_starting_flourine_vent, aquilo_flourine_vent_spots, aquilo_starting_rmd_aquilo_islands_spots, aquilo_rmd_aquilo_islands_spots)))"
    }
end

local disabled_controls = {}

for name, control in pairs(data.raw["autoplace-control"]) do
    if control.category == "resource" then
        if name ~= "rmd_aquilo_islands" then
            disabled_controls[name] =
            {
                frequency = 0,
                size = 0,
                richness = 0
            }
        end
    end
end

data.raw["map-gen-presets"]["default"]["rmd-resource-free"] =
{
    order = "z",
    basic_settings = {
        starting_area = 1.0,
        property_expression_names = { water = 1.0 },
        autoplace_controls = disabled_controls,
    }
}

if mods["bobmining"] then
    local items = data.raw["item"]
    items["rmd-electric-mining-drill"].icons =
    {
        {
            icon = STONE_ICON
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
                icon = STONE_ICON
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
            icon = STONE_ICON
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
            icon = STONE_ICON
        },
        {
            icon = items["electric-mining-drill"].icon,
            icon_size = items["electric-mining-drill"].icon_size,
            shift = { -8, -8 }
        }
    }
end

local function resolve_upgrade_target(base_name)
    local base = data.raw["mining-drill"][base_name]

    if base and base.next_upgrade then
        local upgrade_name = base.next_upgrade
        local upgrade = upgrade_name and data.raw["mining-drill"][upgrade_name]

        if upgrade and not data.raw["item"][upgrade_name].hidden then
            return upgrade_name
        end
    end

    return base.name
end

local mining_drills = data.raw["mining-drill"]

if mining_drills["pumpjack"] and not mining_drills["pumpjack"].hidden then
    mining_drills["rmd-pumpjack"].next_upgrade = resolve_upgrade_target("pumpjack")
    mining_drills["rmd-pumpjack"].fast_replaceable_group =
        mining_drills["pumpjack"].fast_replaceable_group
end

if mining_drills["burner-mining-drill"] and not mining_drills["burner-mining-drill"].hidden then
    mining_drills["rmd-burner-mining-drill"].next_upgrade = resolve_upgrade_target("burner-mining-drill")
    mining_drills["rmd-burner-mining-drill"].fast_replaceable_group =
        mining_drills["burner-mining-drill"].fast_replaceable_group
end

if mining_drills["electric-mining-drill"] and not mining_drills["electric-mining-drill"].hidden then
    mining_drills["rmd-electric-mining-drill"].next_upgrade = resolve_upgrade_target("electric-mining-drill")
    mining_drills["rmd-electric-mining-drill"].fast_replaceable_group =
        mining_drills["electric-mining-drill"].fast_replaceable_group
end

if mods["space-age"] and mining_drills["big-mining-drill"] and not mining_drills["big-mining-drill"].hidden then
    mining_drills["rmd-big-mining-drill"].next_upgrade = resolve_upgrade_target("big-mining-drill")
    mining_drills["rmd-big-mining-drill"].fast_replaceable_group =
        mining_drills["electric-big-drill"].fast_replaceable_group
end

if mods["bobmining"] and mining_drills["bob-water-miner-1"] and not mining_drills["bob-water-miner-1"].hidden then
    mining_drills["rmd-bob-water-miner"].next_upgrade = resolve_upgrade_target("bob-water-miner-1")
    mining_drills["rmd-bob-water-miner"].fast_replaceable_group =
        mining_drills["bob-water-miner-1"].fast_replaceable_group
end
