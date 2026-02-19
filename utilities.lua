function replace_ingredient(recipe, from, to)
    if not (recipe and recipe.ingredients) then return end

    for index, ingredient in ipairs(recipe.ingredients) do
        local name   = ingredient.name or ingredient[1]
        local amount = ingredient.amount or ingredient[2]

        if name == from then
            recipe.ingredients[index] = { type = "item", name = to, amount = amount }
        end
    end
end

function replace_result(recipe, from, to)
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

function boxes_equal(a, b)
    if not (a and b and a[1] and a[2] and b[1] and b[2]) then return false end

    return a[1][1] == b[1][1]
        and a[1][2] == b[1][2]
        and a[2][1] == b[2][1]
        and a[2][2] == b[2][2]
end

function resolve_upgrade_target(base_name)
    local base = data.raw["mining-drill"][base_name]

    if base and base.next_upgrade then
        local upgrade_name = base.next_upgrade
        local upgrade = upgrade_name and data.raw["mining-drill"][upgrade_name]

        if upgrade and not data.raw["item"][upgrade_name].hidden then
            return upgrade_name
        end
    end

    if settings.startup["rmd-hide-recipes"] and settings.startup["rmd-hide-recipes"].value then
        return nil
    end

    return base.name
end

function scale_ingredients(ingredients, factor)
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

function scale_energy_usage(energy_usage, factor)
    local value, unit = energy_usage:match("^(%d+%.?%d*)(%a+)$")
    if not value or not unit then return "0kW" end

    local scaled_value = tonumber(value) * factor
    return ("%g%s"):format(scaled_value, unit)
end
