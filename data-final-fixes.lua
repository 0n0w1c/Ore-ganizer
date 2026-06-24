require("constants")
require("utilities")

require("prototypes/rmd-burner-mining-drill")
require("prototypes/rmd-electric-mining-drill")
require("prototypes/rmd-big-mining-drill")

if mods["IR3_Assets_mining_drills"] and data.raw["mining-drill"]["steel-derrick"] then
    require("prototypes/rmd-steel-derrick")
end

local recycling = nil
if mods["recycler"] then
    recycling = require("__recycler__.recycling")
end

local function generate_recycling_recipe(recipe)
    if recycling and recipe then
        recycling.generate_recycling_recipe(recipe)
    end
end

local recipes = data.raw["recipe"]
local excluded_controls = {}

generate_recycling_recipe(recipes["rmd-burner-mining-drill"])
generate_recycling_recipe(recipes["rmd-electric-mining-drill"])

local recipe = recipes["rmd-steel-derrick"]
if recipe then
    generate_recycling_recipe(recipe)
end

if mods["space-age"] then
    generate_recycling_recipe(recipes["big-mining-drill"])

    local recipe = table.deepcopy(recipes["big-mining-drill-recycling"])
    if recipe then
        recipe.name           = "rmd-big-mining-drill-recycling"
        recipe.localised_name = { "", { "recipe-name." .. recipe.name } }

        replace_ingredient(recipe, "big-mining-drill", "rmd-big-mining-drill")
        replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill")

        data:extend({ recipe })
    end
end

if settings.startup["rmd-slow-miner"] and settings.startup["rmd-slow-miner"].value then
    local recipe = recipes["rmd-slow-electric-mining-drill"]
    if recipe then
        recipe.ingredients = scale_ingredients(recipes["electric-mining-drill"].ingredients, 2 / 3)
        generate_recycling_recipe(recipe)
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
    local original_aquilo_island_peaks = data.raw["noise-expression"] and
        data.raw["noise-expression"]["aquilo_island_peaks"]
    local original_expression = original_aquilo_island_peaks and original_aquilo_island_peaks.expression or
        "1.7 * (0.3 + aquilo_starting_island)"

    data.raw["noise-expression"]["aquilo_island_peaks"] =
    {
        type = "noise-expression",
        name = "aquilo_island_peaks",
        expression = "max((" .. original_expression .. "), rmd_aquilo_island_fallback_peaks)"
    }
end

if mods["EverythingOnNauvis"] then
    excluded_controls["ammonia_ocean"] = true
    excluded_controls["vulcanus_volcanism"] = true
end

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    excluded_controls["crude-oil"] = true
    excluded_controls["kr-imersite"] = true
    excluded_controls["kr-mineral-water"] = true
end


if mods["Spaghetorio"] then
    excluded_controls["sp-core-rift"] = true
    excluded_controls["sp-blunagium"] = true
    excluded_controls["sp-grobgnum"] = true
    excluded_controls["sp-imersite"] = true
    excluded_controls["sp-rukite"] = true
    excluded_controls["sp-yemnuth"] = true
    excluded_controls["sp-algae"] = true
    excluded_controls["sp-wheat"] = true
    excluded_controls["sp-honeycomb-fungus"] = true
end

local disabled_controls = {}

for name, control in pairs(data.raw["autoplace-control"]) do
    if control.category == "resource" then
        if not excluded_controls[name] then
            disabled_controls[name] = { size = 0 }
        end
    end
end

data.raw["map-gen-presets"] = data.raw["map-gen-presets"] or {}
data.raw["map-gen-presets"]["default"] = data.raw["map-gen-presets"]["default"] or {}

data.raw["map-gen-presets"]["default"]["rmd-resource-free"] =
{
    order = "z",
    basic_settings =
    {
        autoplace_controls = disabled_controls,
    }
}

local items = data.raw["item"]
if items["rmd-electric-mining-drill"] then
    apply_rmd_icons(items["rmd-electric-mining-drill"], items["electric-mining-drill"], { -8, -8 })
end

if mods["space-age"] and recipes["rmd-big-mining-drill"] then
    replace_ingredient(recipes["rmd-big-mining-drill"], "electric-mining-drill", "rmd-electric-mining-drill")
    generate_recycling_recipe(recipes["rmd-big-mining-drill"])
end

if mods["bobmining"] then
    local recipe = recipes["rmd-bob-area-mining-drill-1"]
    if recipe then
        replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-bob-area-mining-drill-1-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end

    recipe = recipes["rmd-bob-area-mining-drill-2"]
    if recipe then
        replace_ingredient(recipe, "bob-area-mining-drill-1", "rmd-bob-area-mining-drill-1")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-bob-area-mining-drill-2-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-1", "rmd-bob-area-mining-drill-1") end

    recipe = recipes["rmd-bob-area-mining-drill-3"]
    if recipe then
        replace_ingredient(recipe, "bob-area-mining-drill-2", "rmd-bob-area-mining-drill-2")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-bob-area-mining-drill-3-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-2", "rmd-bob-area-mining-drill-2") end

    recipe = recipes["rmd-bob-area-mining-drill-4"]
    if recipe then
        replace_ingredient(recipe, "bob-area-mining-drill-3", "rmd-bob-area-mining-drill-3")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-bob-area-mining-drill-4-recycling"]
    if recipe then replace_result(recipe, "bob-area-mining-drill-3", "rmd-bob-area-mining-drill-3") end
end

if mods["Krastorio2"] or mods["Krastorio2-spaced-out"] then
    local recipe = recipes["rmd-electric-mining-drill"]
    recipe.ingredients = table.deepcopy(recipes["electric-mining-drill"].ingredients)
    generate_recycling_recipe(recipe)

    recipe = recipes["rmd-kr-electric-mining-drill-mk2"]
    if recipe then
        replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-kr-electric-mining-drill-mk2-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end

    recipe = recipes["rmd-kr-electric-mining-drill-mk3"]
    if recipe then
        replace_ingredient(recipe, "kr-electric-mining-drill-mk2", "rmd-kr-electric-mining-drill-mk2")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-kr-electric-mining-drill-mk2-recycling"]
    if recipe then replace_result(recipe, "kr-electric-mining-drill-mk2", "rmd-kr-electric-mining-drill-mk2") end

    recipe = recipes["rmd-big-mining-drill"]
    if recipe then
        replace_ingredient(recipe, "electric-mining-drill", "rmd-electric-mining-drill")
        generate_recycling_recipe(recipe)
    end

    recipe = recipes["rmd-big-mining-drill-recycling"]
    if recipe then replace_result(recipe, "electric-mining-drill", "rmd-electric-mining-drill") end
end

if mods["upgrade_requires_previous_tier"] then
    if settings.startup["rmd-slow-miner"].value then
        replace_ingredient(recipes["rmd-slow-electric-mining-drill"], "burner-mining-drill", "rmd-burner-mining-drill")
        generate_recycling_recipe(recipes["rmd-slow-electric-mining-drill"])
    end

    replace_ingredient(recipes["rmd-electric-mining-drill"], "burner-mining-drill", "rmd-burner-mining-drill")
    generate_recycling_recipe(recipes["rmd-electric-mining-drill"])
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
        generate_recycling_recipe(recipes["rmd-slow-electric-mining-drill"])
    end

    replace_ingredient(recipes["rmd-electric-mining-drill"], "burner-mining-drill", "rmd-burner-mining-drill")
    generate_recycling_recipe(recipes["rmd-electric-mining-drill"])

    if recipes["rmd-area-mining-drill"] then
        replace_ingredient(recipes["rmd-area-mining-drill"], "electric-mining-drill", "rmd-electric-mining-drill")
        generate_recycling_recipe(recipes["rmd-area-mining-drill"])
    end
end


if mods["space-exploration"] then
    local area_drill = data.raw["mining-drill"]["rmd-area-mining-drill"]
    if area_drill then
        area_drill.resource_categories = area_drill.resource_categories or {}
        local has_hard_resource = false
        for _, category in pairs(area_drill.resource_categories) do
            if category == "hard-resource" then
                has_hard_resource = true
                break
            end
        end
        if not has_hard_resource then
            table.insert(area_drill.resource_categories, "hard-resource")
        end
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
        apply_rmd_icons(items["rmd-bob-water-miner"], items["bob-water-miner-1"], { -8, -8 })
    end

    local mining_drill = data.raw["mining-drill"]["rmd-electric-mining-drill"]
    if mining_drill then
        apply_rmd_icons(mining_drill, items["electric-mining-drill"], { -8, -8 })
    end

    local simple_entity = data.raw["simple-entity-with-owner"]["rmd-electric-mining-drill-displayer"]
    if simple_entity then
        apply_rmd_icons(simple_entity, items["electric-mining-drill"], { -8, -8 })
    end
end

local mining_drills = data.raw["mining-drill"]

for _, mining_drill in pairs(mining_drills) do
    local next_upgrade_name = mining_drill.next_upgrade
    local next_upgrade = next_upgrade_name and mining_drills[next_upgrade_name]

    if next_upgrade and not boxes_equal(mining_drill.collision_box, next_upgrade.collision_box) then
        mining_drill.next_upgrade = nil
    end
end

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

if mods["IR3_Assets_steamworks"] and mining_drills["steam-mining-drill"] then
    next = resolve_upgrade_target("steam-mining-drill")

    if next then
        local upgrade = mining_drills[next]
        local rmd     = mining_drills["rmd-steam-mining-drill"]

        if upgrade and not upgrade.hidden and rmd then
            if boxes_equal(rmd.collision_box, upgrade.collision_box) then
                rmd.next_upgrade = next
                rmd.fast_replaceable_group = upgrade.fast_replaceable_group
            end
        end
    end
end

if mods["IR3_Assets_mining_drills"] and mining_drills["steel-derrick"] then
    next = resolve_upgrade_target("steel-derrick")

    if next then
        local upgrade = mining_drills[next]
        local rmd     = mining_drills["rmd-steel-derrick"]

        if upgrade and not upgrade.hidden and rmd then
            if boxes_equal(rmd.collision_box, upgrade.collision_box) then
                rmd.next_upgrade = next
                rmd.fast_replaceable_group = upgrade.fast_replaceable_group
            end
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
    next = resolve_upgrade_target("bob-water-miner-1")

    if next then
        local upgrade = mining_drills[next]
        local rmd     = mining_drills["rmd-bob-water-miner"]

        if upgrade and not upgrade.hidden and rmd then
            if boxes_equal(rmd.collision_box, upgrade.collision_box) then
                rmd.next_upgrade = next
                rmd.fast_replaceable_group = upgrade.fast_replaceable_group
            end
        end
    end
end

if mods["OmegaDrill"] then
    if recipes["omega-drill"] then
        replace_ingredient(recipes["rmd-omega-drill"], "electric-mining-drill", "rmd-electric-mining-drill")
        generate_recycling_recipe(recipes["rmd-omega-drill"])
    end

    if recipes["tomega-drill"] then
        items["tomega-drill"].order = "a[items]-b[tomega-drill]"

        replace_ingredient(recipes["rmd-tomega-drill"], "omega-drill", "rmd-omega-drill")
        replace_ingredient(recipes["rmd-tomega-drill"], "big-mining-drill", "rmd-big-mining-drill")
        generate_recycling_recipe(recipes["rmd-tomega-drill"])
    end
end

if settings.startup["rmd-trim-mining-area"].value == true then
    for _, mining_drill in pairs(mining_drills) do
        if items["rmd-" .. mining_drill.name] then
            mining_drill.resource_searching_radius = get_effective_mining_radius(mining_drill)
        end
    end
end

local function add_flag_once(prototype, flag)
    prototype.flags = prototype.flags or {}

    for _, existing_flag in pairs(prototype.flags) do
        if existing_flag == flag then return end
    end

    table.insert(prototype.flags, flag)
end

for _, mining_drill in pairs(mining_drills) do
    if mining_drill.name:sub(1, 4) == "rmd-" and not mining_drill.name:match("%-displayer$") then
        add_flag_once(mining_drill, "get-by-unit-number")
    end
end

local function normalize_emissions_per_minute(energy_source)
    if not energy_source then return end

    local emissions = energy_source.emissions_per_minute
    if type(emissions) == "number" then
        energy_source.emissions_per_minute = { pollution = emissions }
    end
end

for _, mining_drill in pairs(mining_drills) do
    if mining_drill.name and mining_drill.name:sub(1, 4) == "rmd-" then
        normalize_emissions_per_minute(mining_drill.energy_source)
    end
end
