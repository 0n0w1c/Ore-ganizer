require("constants")
require("utilities")

local recycling = {}
if mods["quality"] then recycling = require("__quality__/prototypes/recycling") end

require("prototypes/rmd-burner-mining-drill")
require("prototypes/rmd-electric-mining-drill")
require("prototypes/rmd-big-mining-drill")

local recipes = data.raw["recipe"]

if settings.startup["rmd-slow-miner"] and settings.startup["rmd-slow-miner"].value then
    local recipe = recipes["rmd-slow-electric-mining-drill"]
    if recipe then
        recipe.ingredients = scale_ingredients(recipes["electric-mining-drill"].ingredients, 2 / 3)
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end
end

if settings.startup["rmd-hide-recipes"] and settings.startup["rmd-hide-recipes"].value then
    if not mods["bobmining"] then
        for _, recipe in pairs(recipes) do
            if recipe.name:sub(1, 4) == "rmd-" then
                local base_name = recipe.name:sub(5)
                local base_recipe = recipes[base_name]
                if base_recipe then
                    base_recipe.hidden = true
                end
            end
        end
    end
end

if mods["space-age"] and not mods["EverythingOnNauvis"] then
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

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    EXCLUDED_CONTROLS["crude-oil"] = true
    EXCLUDED_CONTROLS["kr-imersite"] = true
    EXCLUDED_CONTROLS["kr-mineral-water"] = true
end

if mods["EverythingOnNauvis"] then
    EXCLUDED_CONTROLS["ammonia_ocean"] = true
    EXCLUDED_CONTROLS["vulcanus_volcanism"] = true
end

if mods["Spaghetorio"] then
    EXCLUDED_CONTROLS["sp-core-rift"] = true
    EXCLUDED_CONTROLS["sp-blunagium"] = true
    EXCLUDED_CONTROLS["sp-grobgnum"] = true
    EXCLUDED_CONTROLS["sp-imersite"] = true
    EXCLUDED_CONTROLS["sp-rukite"] = true
    EXCLUDED_CONTROLS["sp-yemnuth"] = true
    EXCLUDED_CONTROLS["sp-algae"] = true
    EXCLUDED_CONTROLS["sp-wheat"] = true
    EXCLUDED_CONTROLS["sp-honeycomb-fungus"] = true
end

local disabled_controls = {}

for name, control in pairs(data.raw["autoplace-control"]) do
    if control.category == "resource" then
        if not EXCLUDED_CONTROLS[name] then
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
    basic_settings =
    {
        autoplace_controls = disabled_controls,
    }
}

local items = data.raw["item"]
items["rmd-electric-mining-drill"].icons =
{
    {
        icon = STONE_ICON,
        icon_size = 64
    },
    {
        icon = items["electric-mining-drill"].icon,
        icon_size = items["electric-mining-drill"].icon_size,
        shift = { -8, -8 }
    }
}

if mods["space-age"] and recipes["rmd-big-mining-drill"] then
    replace_ingredient(recipes["rmd-big-mining-drill"], "electric-mining-drill", "rmd-electric-mining-drill")
    if mods["quality"] then recycling.generate_recycling_recipe(recipes["rmd-big-mining-drill"]) end

    if recipes["rmd-big-mining-drill-recycling"] then
        recipes["rmd-big-mining-drill-recycling"].results = table.deepcopy(recipes["big-mining-drill-recycling"].results)
    end
end

if mods["bobmining"] then
    local recipe = recipes["rmd-bob-area-mining-drill-1"]
    if recipe then
        replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-bob-area-mining-drill-1-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end

    recipe = recipes["rmd-bob-area-mining-drill-2"]
    if recipe then
        replace_ingredient(recipe, "bob-area-mining-drill-1", "rmd-bob-area-mining-drill-1")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-bob-area-mining-drill-2-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-1", "rmd-bob-area-mining-drill-1") end

    recipe = recipes["rmd-bob-area-mining-drill-3"]
    if recipe then
        replace_ingredient(recipe, "bob-area-mining-drill-2", "rmd-bob-area-mining-drill-2")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-bob-area-mining-drill-3-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-2", "rmd-bob-area-mining-drill-2") end

    recipe = recipes["rmd-bob-area-mining-drill-4"]
    if recipe then
        replace_ingredient(recipe, "bob-area-mining-drill-3", "rmd-bob-area-mining-drill-3")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-bob-area-mining-drill-4-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-3", "rmd-bob-area-mining-drill-3") end
end

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    local recipe = recipes["rmd-electric-mining-drill"]
    recipe.ingredients = table.deepcopy(recipes["electric-mining-drill"].ingredients)
    if mods["quality"] then recycling.generate_recycling_recipe(recipe) end

    recipe = recipes["rmd-kr-electric-mining-drill-mk2"]
    if recipe then
        replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-kr-electric-mining-drill-mk2-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end

    recipe = recipes["rmd-kr-electric-mining-drill-mk3"]
    if recipe then
        replace_ingredient(recipe, "kr-electric-mining-drill-mk2", "rmd-kr-electric-mining-drill-mk2")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-kr-electric-mining-drill-mk2-recycling"]
    if recipe then replace_result(recipe, "kr-electric-mining-drill-mk2", "rmd-kr-electric-mining-drill-mk2") end

    recipe = recipes["rmd-big-mining-drill"]
    if recipe then
        replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipe) end
    end

    recipe = recipes["rmd-big-mining-drill-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end
end

if mods["aai-industry"] then
    local burner_drill = recipes["rmd-burner-mining-drill"]
    local technology   = data.raw["technology"]["burner-mechanics"]

    if technology and burner_drill then
        burner_drill.enabled = false
        technology.effects   = technology.effects or {}
        table.insert(technology.effects, { type = "unlock-recipe", recipe = burner_drill.name })
    end

    if settings.startup["rmd-slow-miner"].value then
        replace_ingredient(recipes["rmd-slow-electric-mining-drill"], "burner-mining-drill", "rmd-burner-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipes["rmd-slow-electric-mining-drill"]) end
    end

    replace_ingredient(recipes["rmd-electric-mining-drill"], "burner-mining-drill", "rmd-burner-mining-drill")
    if mods["quality"] then recycling.generate_recycling_recipe(recipes["rmd-electric-mining-drill"]) end

    if recipes["rmd-area-mining-drill"] then
        replace_ingredient(recipes["rmd-area-mining-drill"], "electric-mining-drill", "rmd-electric-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipes["rmd-area-mining-drill"]) end
    end
end

if mods["water-pumpjack"] and mods["space-age"] then
    local entity = data.raw["offshore-pump"]["water-pumpjack"]
    if entity then
        entity.surface_conditions = { { min = 0.1, property = "gravity" } }
    end
end

if mods["bobmining"] then
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

local mining_drills = data.raw["mining-drill"]

if not mods["Krastorio2"] and not mods["Krastorio2-spaced-out"] then
    if mining_drills["pumpjack"] and not mining_drills["pumpjack"].hidden then
        mining_drills["rmd-pumpjack"].next_upgrade = resolve_upgrade_target("pumpjack")
        mining_drills["rmd-pumpjack"].fast_replaceable_group =
            mining_drills["pumpjack"].fast_replaceable_group
    end
end

local next = resolve_upgrade_target("burner-mining-drill")

if next then
    local upgrade = mining_drills[next]
    local rmd     = mining_drills["rmd-burner-mining-drill"]

    if upgrade and not upgrade.hidden and rmd then
        if boxes_equal(rmd.collision_box, upgrade.collision_box) then
            rmd.next_upgrade = next
            rmd.fast_replaceable_group = upgrade.fast_replaceable_group
        end
    end
end

next = resolve_upgrade_target("electric-mining-drill")

if next then
    local upgrade = mining_drills[next]
    local rmd     = mining_drills["rmd-electric-mining-drill"]

    if upgrade and not upgrade.hidden and rmd then
        if boxes_equal(rmd.collision_box, upgrade.collision_box) then
            rmd.next_upgrade = next
            rmd.fast_replaceable_group = upgrade.fast_replaceable_group
        end
    end
end

if mods["space-age"] then
    next = resolve_upgrade_target("big-mining-drill")

    if next then
        local upgrade = mining_drills[next]
        local rmd     = mining_drills["rmd-big-mining-drill"]

        if upgrade and not upgrade.hidden and rmd then
            if boxes_equal(rmd.collision_box, upgrade.collision_box) then
                rmd.next_upgrade = next
                rmd.fast_replaceable_group = upgrade.fast_replaceable_group
            end
        end
    end
end

if mods["bobmining"] and mining_drills["bob-water-miner-1"] and not mining_drills["bob-water-miner-1"].hidden then
    mining_drills["rmd-bob-water-miner"].next_upgrade = resolve_upgrade_target("bob-water-miner-1")
    mining_drills["rmd-bob-water-miner"].fast_replaceable_group =
        mining_drills["bob-water-miner-1"].fast_replaceable_group
end

if mods["OmegaDrill"] then
    if recipes["omega-drill"] then
        replace_ingredient(recipes["rmd-omega-drill"], "electric-mining-drill", "rmd-electric-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipes["rmd-omega-drill"]) end
    end

    if recipes["tomega-drill"] then
        items["tomega-drill"].order = "a[items]-b[tomega-drill]"

        replace_ingredient(recipes["rmd-tomega-drill"], "omega-drill", "rmd-omega-drill")
        replace_ingredient(recipes["rmd-tomega-drill"], "big-mining-drill", "rmd-big-mining-drill")
        if mods["quality"] then recycling.generate_recycling_recipe(recipes["rmd-tomega-drill"]) end
    end
end

if settings.startup["rmd-trim-mining-area"].value == true then
    for _, mining_drill in pairs(mining_drills) do
        if items["rmd-" .. mining_drill.name] then
            mining_drill.resource_searching_radius = get_effective_mining_radius(mining_drill)
        end
    end
end
