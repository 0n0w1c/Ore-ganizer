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

function copy_displayer_picture_from_animation(mining_drill)
    if not (mining_drill and mining_drill.graphics_set and mining_drill.graphics_set.animation) then return nil end

    local picture = table.deepcopy(mining_drill.graphics_set.animation)

    local function add_directional_overlay(overlays)
        if not (picture and overlays) then return end

        for _, direction in ipairs({ "north", "east", "south", "west" }) do
            local dir_picture = picture[direction]
            local overlay = overlays[direction]

            if dir_picture and overlay then
                if not dir_picture.layers then
                    dir_picture.layers = { dir_picture }
                end

                local copied_overlay = table.deepcopy(overlay)
                if copied_overlay.layers then
                    for _, layer in ipairs(copied_overlay.layers) do
                        table.insert(dir_picture.layers, layer)
                    end
                else
                    table.insert(dir_picture.layers, copied_overlay)
                end
            end
        end
    end

    add_directional_overlay(mining_drill.pipe_pictures)
    add_directional_overlay(mining_drill.pipe_covers)

    return picture
end

function copy_displayer_picture_from_picture_field(mining_drill)
    if not (mining_drill and mining_drill.picture) then return nil end

    return table.deepcopy(mining_drill.picture)
end

function copy_displayer_picture_from_base_picture(mining_drill)
    if not (mining_drill and mining_drill.base_picture) then return nil end

    return table.deepcopy(mining_drill.base_picture)
end

function copy_displayer_integration_patch(mining_drill)
    if not (mining_drill and mining_drill.integration_patch) then return nil end

    return table.deepcopy(mining_drill.integration_patch)
end

local function normalize_sprite_layers(sprite)
    if not sprite then return {} end

    if sprite.layers then
        return table.deepcopy(sprite.layers)
    end

    if sprite.sheets then
        return table.deepcopy(sprite.sheets)
    end

    return { table.deepcopy(sprite) }
end

local function make_static_picture_layer(layer)
    if not layer then return nil end

    local copied_layer = table.deepcopy(layer)

    copied_layer.animation_speed = nil
    copied_layer.frame_count = nil
    copied_layer.frame_sequence = nil
    copied_layer.line_length = nil
    copied_layer.repeat_count = nil
    copied_layer.run_mode = nil
    copied_layer.lines_per_file = nil
    copied_layer.slice = nil
    copied_layer.variation_count = nil
    copied_layer.dice = nil
    copied_layer.dice_x = nil
    copied_layer.dice_y = nil

    return copied_layer
end

local function append_filtered_layers(target_layers, source, opts)
    if not (target_layers and source) then return end

    opts = opts or {}

    for _, layer in ipairs(normalize_sprite_layers(source)) do
        local filename = layer.filename or ""
        local is_shadow = layer.draw_as_shadow
        local is_mask = filename:find("mask", 1, true) ~= nil

        if (not opts.exclude_shadows or not is_shadow)
            and (not opts.exclude_masks or not is_mask)
            and (not opts.only_shadows or is_shadow)
        then
            table.insert(target_layers, layer)
        end
    end
end

local function append_filtered_static_layers(target_layers, source, opts)
    if not (target_layers and source) then return end

    opts = opts or {}

    for _, layer in ipairs(normalize_sprite_layers(source)) do
        local filename = layer.filename or ""
        local is_shadow = layer.draw_as_shadow
        local is_mask = filename:find("mask", 1, true) ~= nil

        if (not opts.exclude_shadows or not is_shadow)
            and (not opts.exclude_masks or not is_mask)
            and (not opts.only_shadows or is_shadow)
        then
            table.insert(target_layers, make_static_picture_layer(layer))
        end
    end
end

local PUMPJACK_PIPE_COVER_SHIFT = {
    east = util.by_pixel(63.5, -33.5),
    south = util.by_pixel(-30, 63),
    west = util.by_pixel(-63, 32.5)
}

local function append_pumpjack_pipe_cover_layers(target_layers, pipe_covers, direction)
    local shift = PUMPJACK_PIPE_COVER_SHIFT[direction]
    if not (target_layers and pipe_covers and pipe_covers[direction] and shift) then return end

    for _, layer in ipairs(normalize_sprite_layers(pipe_covers[direction])) do
        local copied_layer = make_static_picture_layer(layer)
        copied_layer.shift = shift
        table.insert(target_layers, copied_layer)
    end
end


function make_pumpjack_displayer_picture(mining_drill, custom_base_by_direction, custom_shift_by_direction)
    if not (mining_drill and mining_drill.base_picture) then return nil end

    custom_base_by_direction = custom_base_by_direction or {}
    custom_shift_by_direction = custom_shift_by_direction or {}

    local picture = {}
    local base_layers = normalize_sprite_layers(mining_drill.base_picture)
    local horsehead_animation = mining_drill.graphics_set
        and mining_drill.graphics_set.animation
        and mining_drill.graphics_set.animation.north
    local output_fluid_box = mining_drill.output_fluid_box
    local pipe_covers = output_fluid_box and output_fluid_box.pipe_covers
    local directions = { "north", "east", "south", "west" }

    for index, direction in ipairs(directions) do
        local direction_layers = {}

        for index, base_layer in ipairs(base_layers) do
            local copied_base_layer = make_static_picture_layer(base_layer)
            if index == 1 and custom_base_by_direction[direction] then
                copied_base_layer.filename = custom_base_by_direction[direction]
                if custom_shift_by_direction[direction] then
                    copied_base_layer.shift = custom_shift_by_direction[direction]
                end
            end
            table.insert(direction_layers, copied_base_layer)
        end

        append_filtered_static_layers(direction_layers, horsehead_animation)
        append_pumpjack_pipe_cover_layers(direction_layers, pipe_covers, direction)

        picture[direction] = { layers = direction_layers }
    end

    return picture
end

function make_bob_area_mining_drill_displayer_picture(mining_drill)
    if not (
            mining_drill
            and mining_drill.graphics_set
            and mining_drill.graphics_set.animation
            and mining_drill.graphics_set.working_visualisations
        ) then
        return nil
    end

    local animation = mining_drill.graphics_set.animation
    local working_visualisations = mining_drill.graphics_set.working_visualisations
    local picture = {}

    for _, direction in ipairs({ "north", "east", "south", "west" }) do
        local direction_layers = {}
        local base_animation = animation[direction]

        if not base_animation then return nil end

        append_filtered_layers(direction_layers, base_animation, { exclude_shadows = true, exclude_masks = true })

        if direction == "north" then
            append_filtered_layers(direction_layers,
                working_visualisations[3] and working_visualisations[3].north_animation,
                { exclude_shadows = true, exclude_masks = true })
        elseif direction == "east" then
            append_filtered_layers(direction_layers,
                working_visualisations[7] and working_visualisations[7].east_animation,
                { exclude_shadows = true, exclude_masks = true })
            append_filtered_layers(direction_layers,
                working_visualisations[3] and working_visualisations[3].east_animation,
                { exclude_shadows = true, exclude_masks = true })
            append_filtered_layers(direction_layers,
                working_visualisations[6] and working_visualisations[6].east_animation,
                { exclude_shadows = true, exclude_masks = true })
        elseif direction == "south" then
            append_filtered_layers(direction_layers,
                working_visualisations[7] and working_visualisations[7].south_animation,
                { exclude_shadows = true, exclude_masks = true })
            append_filtered_layers(direction_layers,
                working_visualisations[3] and working_visualisations[3].south_animation,
                { exclude_shadows = true, exclude_masks = true })
        elseif direction == "west" then
            append_filtered_layers(direction_layers,
                working_visualisations[7] and working_visualisations[7].west_animation,
                { exclude_shadows = true, exclude_masks = true })
            append_filtered_layers(direction_layers,
                working_visualisations[3] and working_visualisations[3].west_animation,
                { exclude_shadows = true, exclude_masks = true })
            append_filtered_layers(direction_layers,
                working_visualisations[6] and working_visualisations[6].west_animation,
                { exclude_shadows = true, exclude_masks = true })
        end

        append_filtered_layers(direction_layers, base_animation, { exclude_masks = true, only_shadows = true })

        picture[direction] = { layers = direction_layers }
    end

    return picture
end

function make_kr_mining_drill_displayer_picture(mining_drill)
    if not (
            mining_drill
            and mining_drill.graphics_set
            and mining_drill.graphics_set.animation
            and mining_drill.graphics_set.working_visualisations
        ) then
        return nil
    end

    local animation = mining_drill.graphics_set.animation
    local working_visualisations = mining_drill.graphics_set.working_visualisations
    local picture = {}

    for _, direction in ipairs({ "north", "east", "south", "west" }) do
        local direction_layers = {}
        local base_animation = animation[direction]

        if not base_animation then return nil end

        append_filtered_static_layers(direction_layers, base_animation)

        append_filtered_static_layers(
            direction_layers,
            working_visualisations[3] and working_visualisations[3][direction .. "_animation"],
            { exclude_shadows = true }
        )

        append_filtered_static_layers(
            direction_layers,
            working_visualisations[6] and working_visualisations[6][direction .. "_animation"],
            { exclude_shadows = true }
        )

        picture[direction] = { layers = direction_layers }
    end

    return picture
end

function make_animated_mining_drill_displayer_picture(mining_drill)
    if not (
            mining_drill
            and mining_drill.graphics_set
            and mining_drill.graphics_set.animation
        ) then
        return nil
    end

    local animation = mining_drill.graphics_set.animation
    local working_visualisations = mining_drill.graphics_set.working_visualisations or {}
    local picture = {}

    local function should_include_visual(visual)
        if not visual or visual.mining_drill_scorch_mark then return false end
        if visual.light then return false end

        local apply_tint = visual.apply_tint
        if apply_tint == "status"
            or apply_tint == "resource-color"
            or apply_tint == "input-fluid-base-color"
            or apply_tint == "input-fluid-flow-color"
        then
            return false
        end

        return true
    end

    local function append_directional_visual_layers(target_layers, visual, direction)
        if not (target_layers and visual and direction) then return end

        local directional_animation = visual[direction .. "_animation"] or visual.animation
        if not directional_animation then return end

        for _, layer in ipairs(normalize_sprite_layers(directional_animation)) do
            local filename = layer.filename or ""

            if not layer.draw_as_shadow
                and filename:find("mask", 1, true) == nil
                and filename:find("-wet-", 1, true) == nil
            then
                table.insert(target_layers, make_static_picture_layer(layer))
            end
        end
    end

    for _, direction in ipairs({ "north", "east", "south", "west" }) do
        local direction_layers = {}
        local base_animation = animation[direction]

        if not base_animation then return nil end

        append_filtered_static_layers(direction_layers, base_animation)

        for _, visual in ipairs(working_visualisations) do
            if should_include_visual(visual) then
                append_directional_visual_layers(direction_layers, visual, direction)
            end
        end

        picture[direction] = { layers = direction_layers }
    end

    return picture
end

function make_displayer_picture_from_working_visualisations(working_visualisations, index)
    if not working_visualisations then return nil end

    local visual = working_visualisations[index or 2]
    if not visual then return nil end

    local picture = {}

    for _, direction in ipairs({ "north", "east", "south", "west" }) do
        local animation = visual[direction .. "_animation"]
        if not animation then return nil end

        local copied_animation = table.deepcopy(animation)
        picture[direction] = copied_animation.layers and { layers = copied_animation.layers } or
            { layers = { copied_animation } }
    end

    return picture
end

function copy_ir3_displayer_graphics(mining_drill)
    if not (
            mods["IR3_Assets_mining_drills"]
            and mining_drill
            and mining_drill.graphics_set
            and mining_drill.graphics_set.working_visualisations
        ) then
        return nil
    end

    local working_visualisations = mining_drill.graphics_set.working_visualisations
    local picture = make_displayer_picture_from_working_visualisations(working_visualisations, 2)
    if not picture then return nil end

    return {
        lower_pictures = working_visualisations[1] and table.deepcopy(working_visualisations[1].animation) or nil,
        integration_patch = nil,
        picture = picture
    }
end

function add_layers_to_directional_picture(picture, layers_by_direction, index)
    if not (picture and layers_by_direction) then return end

    for direction, layer in pairs(layers_by_direction) do
        local dir_picture = picture[direction]
        if dir_picture then
            if not dir_picture.layers then
                dir_picture.layers = { dir_picture }
            end

            local copied_layer = table.deepcopy(layer)
            if index then
                table.insert(dir_picture.layers, index, copied_layer)
            else
                table.insert(dir_picture.layers, copied_layer)
            end
        end
    end
end
