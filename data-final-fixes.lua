require("constants")

local recipes = data.raw["recipe"]

local function scale_ingredients(ingredients, factor)
    local min_amount = 1
    local scaled = {}
    for _, ingredient in ipairs(ingredients) do
        local name, amount, type

        if ingredient.name then
            name = ingredient.name
            amount = ingredient.amount
            type = ingredient.type
        end

        if name and amount then
            local scaled_amount = math.max(min_amount, math.ceil(amount * factor))
            table.insert(scaled, { type = type, name = name, amount = scaled_amount })
        end
    end
    return scaled
end

local function scale_energy_usage(energy_usage, factor)
    local value, unit = energy_usage:match("^(%d+%.?%d*)(%a+)$")
    if not value or not unit then return "0kW" end

    local scaled_value = tonumber(value) * factor
    return ("%g%s"):format(scaled_value, unit)
end

if settings.startup["rmd-slow-miner"].value then
    local recipe = recipes["rmd-slow-electric-mining-drill"]
    if recipe then
        recipe.ingredients = scale_ingredients(recipe.ingredients, 2 / 3)
    end

    local electric_drill = data.raw["mining-drill"]["electric-mining-drill"]
    local mining_drill = data.raw["mining-drill"]["rmd-slow-electric-mining-drill"]
    if mining_drill then
        mining_drill.energy_usage = scale_energy_usage(electric_drill.energy_usage, 1 / 2)
    end
end

if not mods["bobmining"] then
    if settings.startup["rmd-hide-recipes"] and settings.startup["rmd-hide-recipes"].value then
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

local function replace_ingredient(recipe, from, to)
    if not (recipe and recipe.ingredients) then return end

    for index, ingredient in ipairs(recipe.ingredients) do
        local name   = ingredient.name or ingredient[1]
        local amount = ingredient.amount or ingredient[2]

        if name == from then
            recipe.ingredients[index] = { type = "item", name = to, amount = amount }
        end
    end
end

local function replace_result(recipe, from, to)
    if not recipe then return end

    if recipe.results then
        for index, results in ipairs(recipe.results) do
            local name                 = results.name
            local amount               = results.amount
            local probability          = results.probability
            local extra_count_fraction = results.extra_count_fraction

            if name == from then
                recipe.results[index] = {
                    type = "item",
                    name = to,
                    amount = amount,
                    probability = probability,
                    extra_count_fraction = extra_count_fraction
                }
            end
        end
    elseif recipe.result and recipe.result == from then
        recipe.result = to
    end
end

if mods["space-age"] and recipes["rmd-big-mining-drill"] then
    replace_ingredient(recipes["rmd-big-mining-drill"],
        "electric-mining-drill", "rmd-electric-mining-drill")

    if recipes["rmd-big-mining-drill-recycling"] then
        recipes["rmd-big-mining-drill-recycling"].results =
            table.deepcopy(recipes["big-mining-drill-recycling"].results)

        replace_result(recipes["rmd-big-mining-drill-recycling"],
            "electric-mining-drill", "rmd-electric-mining-drill")
    end
end

if mods["bobmining"] then
    local recipe = recipes["rmd-bob-area-mining-drill-1"]
    if recipe then replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end

    recipe = recipes["rmd-bob-area-mining-drill-1-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end

    recipe = recipes["rmd-bob-area-mining-drill-2"]
    if recipe then replace_ingredient(recipe, "bob-area-mining-drill-1", "rmd-bob-area-mining-drill-1") end

    recipe = recipes["rmd-bob-area-mining-drill-2-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-1", "rmd-bob-area-mining-drill-1") end

    recipe = recipes["rmd-bob-area-mining-drill-3"]
    if recipe then replace_ingredient(recipe, "bob-area-mining-drill-2", "rmd-bob-area-mining-drill-2") end

    recipe = recipes["rmd-bob-area-mining-drill-3-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-2", "rmd-bob-area-mining-drill-2") end

    recipe = recipes["rmd-bob-area-mining-drill-4"]
    if recipe then replace_ingredient(recipe, "bob-area-mining-drill-3", "rmd-bob-area-mining-drill-3") end

    recipe = recipes["rmd-bob-area-mining-drill-4-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-3", "rmd-bob-area-mining-drill-3") end
end

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    local recipe = recipes["rmd-electric-mining-drill"]
    recipe.ingredients = table.deepcopy(recipes["electric-mining-drill"].ingredients)
    if mods["quality"] then
        local recycling = require("__quality__/prototypes/recycling")

        recycling.generate_recycling_recipe(recipe)
        recipe.auto_recycle = nil
    end

    if recipes["rmd-kr-electric-mining-drill-mk2"] then
        replace_ingredient(data.raw.recipe["rmd-kr-electric-mining-drill-mk2"],
            "electric-mining-drill", "rmd-electric-mining-drill")
    end
    if recipes["rmd-kr-electric-mining-drill-mk2-recycling"] then
        replace_result(data.raw.recipe["rmd-kr-electric-mining-drill-mk2-recycling"],
            "electric-mining-drill", "rmd-electric-mining-drill")
    end
    if recipes["rmd-kr-electric-mining-drill-mk3"] then
        replace_ingredient(data.raw.recipe["rmd-kr-electric-mining-drill-mk3"],
            "kr-electric-mining-drill-mk2", "rmd-kr-electric-mining-drill-mk2")
    end
    if recipes["rmd-kr-electric-mining-drill-mk2-recycling"] then
        replace_result(data.raw.recipe["rmd-kr-electric-mining-drill-mk2-recycling"],
            "kr-electric-mining-drill-mk2", "rmd-kr-electric-mining-drill-mk2")
    end
    if recipes["rmd-big-mining-drill"] then
        replace_ingredient(data.raw.recipe["rmd-big-mining-drill"],
            "electric-mining-drill", "rmd-electric-mining-drill")
    end
    if recipes["rmd-big-mining-drill-recycling"] then
        replace_result(data.raw.recipe["rmd-big-mining-drill-recycling"],
            "electric-mining-drill", "rmd-electric-mining-drill")
    end
end

if mods["aai-industry"] then
    local burner_drill = recipes["rmd-burner-mining-drill"]
    local technology   = data.raw["technology"]["burner-mechanics"]

    if technology and burner_drill then
        burner_drill.enabled = false
        technology.effects   = technology.effects or {}
        table.insert(technology.effects, { type = "unlock-recipe", recipe = burner_drill.name })
    end

    replace_ingredient(recipes["rmd-electric-mining-drill"],
        "burner-mining-drill", "rmd-burner-mining-drill")

    replace_ingredient(recipes["rmd-area-mining-drill"],
        "electric-mining-drill", "rmd-electric-mining-drill")

    if recipes["rmd-area-mining-drill-recycling"] then
        replace_result(recipes["rmd-area-mining-drill-recycling"],
            "electric-mining-drill", "rmd-electric-mining-drill")
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

if not mods["Krastorio2"] and not mods["Krastorio2-spaced-out"] then
    if mining_drills["pumpjack"] and not mining_drills["pumpjack"].hidden then
        mining_drills["rmd-pumpjack"].next_upgrade = resolve_upgrade_target("pumpjack")
        mining_drills["rmd-pumpjack"].fast_replaceable_group =
            mining_drills["pumpjack"].fast_replaceable_group
    end
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
        mining_drills["big-mining-drill"].fast_replaceable_group
end

if mods["bobmining"] and mining_drills["bob-water-miner-1"] and not mining_drills["bob-water-miner-1"].hidden then
    mining_drills["rmd-bob-water-miner"].next_upgrade = resolve_upgrade_target("bob-water-miner-1")
    mining_drills["rmd-bob-water-miner"].fast_replaceable_group =
        mining_drills["bob-water-miner-1"].fast_replaceable_group
end

if mods["OmegaDrill"] then
    if recipes["omega-drill"] then
        replace_ingredient(recipes["rmd-omega-drill"],
            "electric-mining-drill", "rmd-electric-mining-drill")

        if recipes["rmd-omega-drill-recycling"] then
            replace_result(recipes["rmd-omega-drill-recycling"],
                "electric-mining-drill", "rmd-electric-mining-drill")
        end
    end

    if recipes["tomega-drill"] then
        items["tomega-drill"].order = "a[items]-b[tomega-drill]"

        replace_ingredient(recipes["rmd-tomega-drill"],
            "omega-drill", "rmd-omega-drill")

        replace_ingredient(recipes["rmd-tomega-drill"],
            "big-mining-drill", "rmd-big-mining-drill")

        if recipes["rmd-tomega-drill-recycling"] then
            replace_result(recipes["rmd-tomega-drill-recycling"],
                "omega-drill", "rmd-omega-drill")
        end

        if recipes["rmd-tomega-drill-recycling"] then
            replace_result(recipes["rmd-tomega-drill-recycling"],
                "big-mining-drill", "rmd-big-mining-drill")
        end
    end
end
