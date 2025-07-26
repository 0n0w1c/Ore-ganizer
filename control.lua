require("constants")

local BLUEPRINT_RESOURCES = settings.startup["rmd-blueprint-resources"].value == true

local function find_excluded_tile_under_entity(entity)
    if not (entity and entity.valid) then return nil end

    local surface = entity.surface
    if not surface then return nil end

    local box = entity.selection_box
    local left_top = { x = math.floor(box.left_top.x), y = math.floor(box.left_top.y) }
    local right_bottom = { x = math.ceil(box.right_bottom.x), y = math.ceil(box.right_bottom.y) }

    for x = left_top.x, right_bottom.x - 1 do
        for y = left_top.y, right_bottom.y - 1 do
            local tile = surface.get_tile(x, y)
            if TILES_TO_EXCLUDE[tile.name] then
                return tile.name
            end
        end
    end

    return nil
end

local function get_mining_area(entity)
    local position = entity.position
    local entity_name = entity.name

    local prototype_name = entity_name:gsub("%-displayer$", "")
    if prototype_name == "" or prototypes.entity[prototype_name].type ~= "mining-drill" then
        return { left_top = { x = -1, y = -1 }, right_bottom = { x = 1, y = 1 } }
    end

    radius = prototypes.entity[prototype_name].get_mining_drill_radius() or 0.99

    return {
        left_top = {
            x = position.x - radius,
            y = position.y - radius
        },
        right_bottom = {
            x = position.x + radius,
            y = position.y + radius
        }
    }
end

local function is_fluid_category_supported(fluid_category)
    if fluid_category == "basic-fluid" or fluid_category == "water" or fluid_category == "offshore-fluid" then
        return true
    end

    return false
end

local function place_resources(surface, area, resource_name, player_index)
    local resource_prototypes = prototypes.get_entity_filtered({ { filter = "name", name = resource_name } })
    local prototype = resource_prototypes[resource_name]

    if not prototype or prototype.type ~= "resource" then return end

    local is_fluid = is_fluid_category_supported(prototype.resource_category)
    for x = area.left_top.x, area.right_bottom.x do
        for y = area.left_top.y, area.right_bottom.y do
            local position = { x = x, y = y }

            local tile = surface.get_tile(x, y)
            if TILES_TO_EXCLUDE[tile.name] and resource_name ~= "offshore-oil" then goto continue end

            if resource_name == "offshore-oil" and not WATER_TILES[tile.name] then goto continue end

            local cliffs = surface.find_entities_filtered
                {
                    area = { { x, y }, { x + 1, y + 1 } },
                    type = "cliff"
                }
            if #cliffs > 0 then goto continue end

            local amount = storage.players[player_index].resource_amount or 5000
            local multiplier = resource_name == "offshore-oil" and FLUID_MULTIPLIER * 4 or FLUID_MULTIPLIER
            local resource_amount = is_fluid and (amount * multiplier) or amount

            surface.create_entity
            ({
                name = resource_name,
                amount = resource_amount,
                position = position
            })

            ::continue::
        end
    end
end

local function spot_resources(surface, position, resource_name, player_index)
    local player = game.get_player(player_index)
    if not player then return end

    local resource_prototypes = prototypes.get_entity_filtered({ { filter = "name", name = resource_name } })
    local prototype = resource_prototypes[resource_name]

    if not prototype or prototype.type ~= "resource" then return end

    local is_fluid = is_fluid_category_supported(prototype.resource_category)

    local amount = storage.players[player_index].resource_amount or 5000
    local multiplier = resource_name == "offshore-oil" and FLUID_MULTIPLIER * 4 or FLUID_MULTIPLIER
    local resource_amount = is_fluid and (amount * multiplier) or amount

    surface.create_entity
    ({
        name = resource_name,
        amount = resource_amount,
        position = position
    })
end

local function remove_resources(surface, area)
    for x = area.left_top.x, area.right_bottom.x do
        for y = area.left_top.y, area.right_bottom.y do
            local resources = surface.find_entities_filtered({ area = { { x, y }, { x + 1, y + 1 } }, type = "resource" })

            for _, resource in pairs(resources) do
                if resource.valid then
                    resource.destroy()
                end
            end
        end
    end
end

local function return_item_to_player(player, item_name, quality)
    local stack = player.cursor_stack

    if stack and stack.valid then
        if stack.valid_for_read and (
                stack.is_blueprint or
                stack.is_blueprint_book or
                stack.is_deconstruction_item or
                stack.is_upgrade_item
            ) then
            player.insert({ name = item_name, count = 1, quality = quality })
            return
        end

        if not stack.valid_for_read then
            stack.set_stack({ name = item_name, count = 1, quality = quality })
            return
        end

        if stack.name == item_name and stack.quality == quality then
            stack.count = stack.count + 1
            return
        end

        player.insert({ name = item_name, count = 1, quality = quality })
        return
    end

    player.insert({ name = item_name, count = 1, quality = quality })
end

local function is_fluid_mining_researched(force)
    local technology = FLUID_MINING_TECHONOLOGIES["base"]

    if script.active_mods["bztitanium"] then
        technology = FLUID_MINING_TECHONOLOGIES["bztitanium"]
    elseif script.active_mods["Spaghetorio"] then
        return true
    end

    local researched = force.technologies[technology].researched

    return researched
end

local function is_displayer_drill(entity_name)
    return DISPLAYER_DRILL_NAMES[entity_name] == true
end

local function is_pumpjack_fluid(category)
    if script.active_mods["bobores"] and not script.active_mods["bobmining"] then
        if category == "basic-fluid" or category == "water" then return true end
    else
        if category == "basic-fluid" then return true end
    end
    return false
end

local function is_water_miner_fluid(category)
    if category == "water" then return true end
    return false
end

local function is_oil_rig_fluid(category)
    if category == "offshore-fluid" then return true end
    return false
end

local function on_water(entity)
    if not (entity and entity.valid) then return false end

    local surface = entity.surface
    local area = entity.selection_box
    local tiles = surface.find_tiles_filtered({ area = area })

    for _, tile in pairs(tiles) do
        if not WATER_TILES[tile.name] then
            return false
        end
    end

    return true
end

local function destroy_offshore_oil(entity)
    if not entity and entity.valid then return end

    local area = entity.selection_box
    local found = false

    surface = entity.surface

    for x = area.left_top.x, area.right_bottom.x - 1 do
        for y = area.left_top.y, area.right_bottom.y - 1 do
            local resources = surface.find_entities_filtered({ area = { { x, y }, { x + 1, y + 1 } }, type = "resource" })

            for _, resource in pairs(resources) do
                if resource.valid and resource.name == "offshore-oil" then
                    resource.destroy()
                    found = true
                end
            end
        end
    end

    return found
end

local function get_or_create_player_data(player_index)
    storage.players = storage.players or {}
    local player_data = storage.players[player_index] or {}

    player_data.ignore_planetary_restrictions = player_data.ignore_planetary_restrictions or false
    player_data.resource_amount = player_data.resource_amount or 5000
    player_data.selected_resource = player_data.selected_resource or DISABLED

    storage.players[player_index] = player_data
    return player_data
end

local function destroy_and_return(player, entity, item_name, quality, message)
    player.create_local_flying_text({ text = { message, entity.localised_name }, create_at_cursor = true })
    entity.destroy()
    return_item_to_player(player, item_name, quality)
end

local function validate_or_destroy(player, entity, item_name, quality, message_key, condition)
    if condition then
        destroy_and_return(player, entity, item_name, quality, message_key)
        return true
    end
    return false
end

function drill_and_resource_compatible(mining_drill, resource_category)
    if not resource_category or not mining_drill then return false end

    local drill_name = mining_drill.name:gsub("%-displayer$", "")
    local mining_drill_categories = prototypes.entity[drill_name].resource_categories

    if mining_drill_categories and mining_drill_categories[resource_category] then return true end

    return false
end

local function validate_resource_checks(player, entity, entity_name, resource_name, item_name, quality)
    local force = entity.force

    local resource_prototypes = prototypes.get_entity_filtered({ { filter = "name", name = resource_name } })
    local resource_prototype = resource_prototypes[resource_name]

    local is_fluid_resource = is_fluid_category_supported(resource_prototype.resource_category)
    local pumpjack_fluid = is_pumpjack_fluid(resource_prototype.resource_category)
    local water_miner_fluid = is_water_miner_fluid(resource_prototype.resource_category)
    local oil_rig_fluid = is_oil_rig_fluid(resource_prototype.resource_category)
    local is_pumpjack = entity_name == "rmd-pumpjack-displayer"
    local is_water_miner = entity_name == "rmd-bob-water-miner-displayer"
    local is_oil_rig = entity_name == "rmd-oil_rig-displayer"
    local is_drill = is_displayer_drill(entity_name)

    if is_drill then
        local resource_category = resource_prototype.resource_category
        local is_minable = resource_category == "basic-solid" or resource_category == "hard-solid"
        local is_required_fluid = resource_prototype.mineable_properties.required_fluid ~= nil
        local is_researched = is_fluid_mining_researched(force)

        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", is_required_fluid and not is_researched) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", not drill_and_resource_compatible(entity, resource_category)) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", not is_minable) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", is_fluid_resource) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", (entity_name == "rmd-burner-mining-drill-displayer" or entity_name == "rmd-slow-electric-mining-drill-displayer") and is_required_fluid) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection",
                (entity_name == "rmd-electric-mining-drill-displayer" or entity_name == "rmd-burner-mining-drill-displayer") and resource_category == "hard-solid") then
            return false
        end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-research-required",
                (is_required_fluid and not is_researched) and resource_name ~= "kr-rare-metal-ore") then
            return false
        end
    else
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", is_pumpjack and not pumpjack_fluid) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", is_water_miner and not water_miner_fluid) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection", is_oil_rig and not oil_rig_fluid) then return false end
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-not-on-land", is_oil_rig and not on_water(entity)) then return false end
    end

    return true
end

local function on_built_entity(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    local player = event.player_index and game.get_player(event.player_index)
        or (entity.last_user and entity.last_user.valid and entity.last_user.is_player() and entity.last_user)
    if not player then return end

    local entity_name = entity.name
    local is_displayer = string.find(entity_name, "^rmd%-.+%-displayer$")
    if not (is_displayer or string.sub(entity_name, 1, 4) == "rmd-") then return end

    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction
    local quality = entity.quality

    get_or_create_player_data(player.index)

    local item_name = string.gsub(entity_name, "-displayer$", "")

    local resource_name
    if event.tags and event.tags.selected_resource then
        resource_name = event.tags.selected_resource
    elseif player then
        resource_name = storage.players[player.index].selected_resource
    end

    local prototype = prototypes.entity[resource_name]
    if not (prototype and prototype.type == "resource") then
        resource_name = DISABLED
    end

    if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-no-resource", resource_name == DISABLED) then return end

    if entity.surface.planet then
        if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-no-resource", resource_name == DISABLED) then return end
        if resource_name == "offshore-oil" and destroy_offshore_oil(entity) then
            return destroy_and_return(player, entity, item_name, quality, "rmd-message.rmd-offshore-oil-removed")
        end
    else
        if not (script.active_mods["Subsurface"] and string.find(surface.name, "_subsurface_")) then
            entity.destroy({ raise_destroy = true })
            surface.create_entity({
                name = item_name,
                force = force,
                position = position,
                direction = direction,
                create_build_effect_smoke = true,
                quality = quality,
                raise_built = true
            })
            return
        end
    end

    local resource_prototypes = prototypes.get_entity_filtered({ { filter = "name", name = resource_name } })
    local resource_prototype = resource_prototypes[resource_name]
    if validate_or_destroy(player, entity, item_name, quality, "rmd-message.rmd-error-invalid-selection",
            not resource_prototype or resource_prototype.type ~= "resource") then
        return
    end

    if not validate_resource_checks(player, entity, entity_name, resource_name, item_name, quality) then return end

    local is_oil_rig = string.find(entity_name, "rmd%-oil%-rig") ~= nil
    local excluded_tile = find_excluded_tile_under_entity(entity)
    if excluded_tile and not is_oil_rig then
        player.create_local_flying_text({
            text = { "", { "rmd-message.rmd-error-tiles-not-allowed" }, " ", excluded_tile },
            create_at_cursor = true
        })
        entity.destroy()
        return_item_to_player(player, item_name, quality)
        return
    end

    local resource_area = get_mining_area(entity)

    if is_displayer then
        entity.destroy({ raise_destroy = true })
    end

    remove_resources(surface, resource_area)
    place_resources(surface, resource_area, resource_name, player.index)

    if item_name == "rmd-oil_rig" then item_name = "oil_rig" end

    if is_displayer then
        surface.create_entity({
            name = item_name,
            force = force,
            position = position,
            direction = direction,
            create_build_effect_smoke = true,
            quality = quality,
            raise_built = true
        })
    end

    if entity.valid then
        entity.update_connections()
    end
end

local function on_mined_entity(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if not RMD_ENTITY_NAMES[entity.name] then return end
    if entity.to_be_upgraded() then return end

    if event.player_index then
        local player = game.get_player(event.player_index)
        if player and player.valid then
            local cursor = player.cursor_stack
            if cursor and cursor.valid_for_read then
                local place_result = cursor.prototype and cursor.prototype.place_result
                if place_result and place_result.type == "mining-drill" then
                    return
                end
            end
        end
    end

    local surface = entity.surface
    local resource_area = get_mining_area(entity)
    remove_resources(surface, resource_area)
end

local function show_resource_selector_gui(player)
    if player.gui.screen.resource_selector_frame then
        player.gui.screen.resource_selector_frame.destroy()
    end

    get_or_create_player_data(player.index)

    local surface = player.surface
    local map_gen_settings = surface.map_gen_settings

    local items = { DISABLED }

    local resource_prototypes = prototypes.get_entity_filtered({ { filter = "type", type = "resource" } })

    for name, prototype in pairs(resource_prototypes) do
        local autoplace_settings = map_gen_settings and map_gen_settings.autoplace_settings

        local allow = false

        if not surface.planet then
            allow = true
        elseif surface.planet.name == "nauvis-factory-floor" then
            allow = true
        end

        local player_settings = storage.players and storage.players[player.index]

        if player_settings and player_settings.ignore_planetary_restrictions == true and prototypes.autoplace_control[name] then
            allow = true
        elseif autoplace_settings and autoplace_settings.entity and autoplace_settings.entity.settings and autoplace_settings.entity.settings[name] then
            allow = true
        end

        if name == "kr-mineral-water" then
            allow = false
        end

        if allow and not prototype.hidden then
            table.insert(items, name)
        end
    end

    local selected = storage.players[player.index].selected_resource

    local frame = player.gui.screen.add
        {
            type = "frame",
            name = "resource_selector_frame",
            direction = "vertical",
        }

    frame.auto_center = true

    local titlebar_flow = frame.add
        {
            type = "flow",
            direction = "horizontal",
        }
    titlebar_flow.style.horizontal_spacing = 6

    titlebar_flow.add
    {
        type = "label",
        caption = { "gui.rmd-resource-selector" },
        ignored_by_interaction = true,
        style = "frame_title",
    }

    local draggable_space = titlebar_flow.add
        {
            type = "empty-widget",
            name = "resource_selector_draggable_space",
            style = "draggable_space_header",
            ignored_by_interaction = false,
        }
    draggable_space.style.height = 24
    draggable_space.style.horizontally_stretchable = true
    draggable_space.drag_target = frame

    local close_button = titlebar_flow.add
        {
            type = "sprite-button",
            name = "resource_selector_close_button",
            sprite = "utility/close",
            style = "close_button",
            mouse_button_filter = { "left" }
        }

    close_button.style.height = 24
    close_button.style.width = 24

    local inner_frame = frame.add
        {
            type = "frame",
            name = "inner_frame",
            direction = "vertical",
            style = "inside_shallow_frame",
        }

    local settings_flow = inner_frame.add {
        type = "flow",
        name = "rmd_settings_flow",
        direction = "horizontal",
    }
    settings_flow.style.vertical_align = "center"

    settings_flow.add {
        type = "checkbox",
        name = "rmd_ignore_planetary_restrictions_checkbox",
        state = storage.players[player.index].ignore_planetary_restrictions or false,
        caption = { "gui.rmd-ignore-planetary-restrictions" },
        tooltip = { "gui.rmd-ignore-planetary-restrictions-tooltip" }
    }.style.left_margin = 6

    settings_flow.add {
        type = "empty-widget",
        style = "draggable_space_header",
        ignored_by_interaction = true
    }.style.horizontally_stretchable = true

    settings_flow.add {
        type = "label",
        caption = { "gui.rmd-resource-amount" },
        style = "label"
    }

    settings_flow.add {
        type = "textfield",
        name = "rmd_resource_amount_field",
        text = tostring(storage.players[player.index].resource_amount or "5000"),
        numeric = true,
        tooltip = { "gui.rmd-resource-amount-tooltip" },
        style = "short_number_textfield"
    }.style.right_margin = 4

    local scroll_pane = inner_frame.add
        {
            type = "scroll-pane",
            name = "resource_scroll_pane",
            horizontal_scroll_policy = "never",
            vertical_scroll_policy = "auto",
        }
    scroll_pane.style = "scroll_pane"
    scroll_pane.style.maximal_height = 300
    scroll_pane.style.minimal_width = 400
    scroll_pane.style.padding = 4

    local grid = scroll_pane.add
        {
            type = "table",
            name = "resource_selector_grid",
            column_count = 10,
            style = "table",
        }

    for _, item_name in pairs(items) do
        if item_name ~= DISABLED then
            local prototype = prototypes.entity[item_name]
            if prototype and prototype.type == "resource" then
                local category = prototype.resource_category
                if CATEGORIES[category] then
                    local style = (item_name == selected) and "slot_sized_button_pressed" or "slot_button"

                    local button = grid.add
                        {
                            type = "choose-elem-button",
                            name = "resource_selector_button_" .. item_name,
                            elem_type = "entity",
                            entity = item_name,
                            style = style,
                        }

                    button.locked = true
                end
            end
        end
    end

    player.opened = frame
    return frame
end

local function close_resource_selector_gui(player)
    if player.gui.screen.resource_selector_frame then
        player.gui.screen.resource_selector_frame.destroy()
        player.opened = nil
    end
end

local function on_gui_closed(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if player.gui.screen.resource_selector_frame then
        close_resource_selector_gui(player)
    end
end

local function toggle_resource_selector_gui(player)
    if player.gui.screen.resource_selector_frame then
        close_resource_selector_gui(player)
    else
        show_resource_selector_gui(player)
    end
end

local function on_lua_shortcut(event)
    if not event or event.prototype_name ~= "rmd-push-button" then return end
    local player = game.get_player(event.player_index)
    if not player then return end
    toggle_resource_selector_gui(player)
end

local function on_gui_click(event)
    if not (event and event.element and event.element.valid) then return end

    local player = game.get_player(event.player_index)
    if not (player and player.valid) then return end

    local player_data = get_or_create_player_data(player.index)
    local element_name = event.element.name

    if element_name == "resource_selector_close_button" then
        close_resource_selector_gui(player)
    elseif element_name:match("^resource_selector_button_") then
        local selected_resource_name = element_name:sub(("resource_selector_button_"):len() + 1)
        player_data.selected_resource = selected_resource_name
        close_resource_selector_gui(player)
    end
end

local function on_player_changed_surface(event)
    local player_index = event.player_index
    local player = game.get_player(player_index)

    close_resource_selector_gui(player)

    local player_data = get_or_create_player_data(player_index)
    if not player_data then return end

    player_data.selected_resource = DISABLED
end

local function tag_resource(entity, surface)
    local resource = surface.find_entities_filtered {
        area =
        {
            { entity.position.x - 0.49, entity.position.y - 0.49 },
            { entity.position.x + 0.49, entity.position.y + 0.49 }
        },
        type = "resource"
    }

    if resource and resource[1] then
        entity.tags = entity.tags or {}
        entity.tags.selected_resource = resource[1].name
    end
end

local function tag_entities(entities, copy_and_paste, surface)
    local modified = false
    for _, entity in pairs(entities) do
        if string.sub(entity.name, 1, 4) == "rmd-" then
            modified = true
            if BLUEPRINT_RESOURCES or copy_and_paste then
                tag_resource(entity, surface)
            end
        end
    end
    return modified
end


local function on_player_setup_blueprint(event)
    local player = game.get_player(event.player_index)
    if not (player and player.valid) then return end

    local surface = player.surface
    local stack = player.blueprint_to_setup
    local copy_and_paste = false

    if not (stack and stack.valid_for_read) then
        stack = player.cursor_stack
        if not (stack and stack.valid_for_read and stack.is_blueprint) then
            return
        end
        copy_and_paste = true
    end

    local entities = stack.get_blueprint_entities()
    if not entities then return end

    if tag_entities(entities, copy_and_paste, surface) then
        stack.set_blueprint_entities(entities)
    end
end

local function on_gui_check_state_changed(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local element = event.element

    if element.name == "rmd_ignore_planetary_restrictions_checkbox" then
        storage.players[player.index].ignore_planetary_restrictions = element.state
        storage.players[player.index].selected_resource = DISABLED
        show_resource_selector_gui(player)
    end
end

local function on_gui_text_changed(event)
    local element = event.element
    local player = game.get_player(event.player_index)
    if not (player and element and element.valid) then return end

    if element.name == "rmd_resource_amount_field" then
        local num = tonumber(element.text)

        if num and math.floor(num) == num and num > 0 and num <= 100000 then
            storage.players[player.index].resource_amount = num
            element.style.font_color = nil
            element.style = "short_number_textfield"
        else
            element.style.font_color = { r = 0.8, g = 0, b = 0, a = 0.5 }
        end
    end
end

local function on_cutscene_cancelled(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid or not player.character then return end
    player.character.insert { name = "rmd-burner-mining-drill", count = 1 }
end

local function remove_aquilo_island_resources(surface, area)
    if prototypes.entity["rmd-aquilo-islands"] then
        local resources = surface.find_entities_filtered { name = "rmd-aquilo-islands", type = "resource", area = area }
        for _, resource in ipairs(resources) do
            if resource.valid then resource.destroy() end
        end
    end
end

local function on_surface_created(event)
    local surface = game.surfaces[event.surface_index]
    if surface.name == "aquilo" then
        remove_aquilo_island_resources(surface)
    end
end

local function on_chunk_generated(event)
    local surface = event.surface
    if surface.name == "aquilo" then
        remove_aquilo_island_resources(surface, event.area)
    end
end

local function on_player_cursor_stack_changed(event)
    local player = game.get_player(event.player_index)
    if not player or not player.valid then return end

    local cursor = player.cursor_stack
    if not (cursor and cursor.valid_for_read) then return end

    if cursor.is_selection_tool then
        if cursor.is_blueprint then
            local entities = cursor.get_blueprint_entities()
            if not entities then return end

            if tag_entities(entities, false, player.surface) then
                cursor.set_blueprint_entities(entities)
            end
        elseif cursor.is_blueprint_setup then
            if cursor.is_blueprint then
                local entities = cursor.get_blueprint_entities()
                if not entities then return end

                if tag_entities(entities, false, player.surface) then
                    cursor.set_blueprint_entities(entities)
                end
            end
        end
    end
end

local function on_toggle_resource_selector(event)
    local player = game.get_player(event.player_index)
    if not player then return end
    toggle_resource_selector_gui(player)
end

local function get_swapped_drill_name(name)
    if name:sub(1, 4) == "rmd-" then
        return name:sub(5)
    else
        return "rmd-" .. name
    end
end

local function on_toggle_cursor_drill(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    local cursor = player.cursor_stack
    if not (cursor and cursor.valid_for_read) then return end

    local current_name = cursor.name
    local swapped_name = get_swapped_drill_name(current_name)

    local prototype = prototypes.entity[swapped_name]
    if not (prototype and prototype.type == "mining-drill") then return end

    cursor.set_stack({ name = swapped_name, count = cursor.count })
    player.play_sound { path = "utility/inventory_move" }
end

local function get_entity_map_position(event, blueprint_entity, blueprint_entities)
    local direction = event.direction or defines.direction.north
    local event_position =
    {
        x = math.floor(event.position.x) + 0.5, y = math.floor(event.position.y) + 0.5
    }

    local min_x, min_y = math.huge, math.huge
    local max_x, max_y = -math.huge, -math.huge

    for _, entity in pairs(blueprint_entities) do
        local proto   = prototypes.entity[entity.name]
        local sel_box = proto.selection_box

        local cx, cy  = entity.position.x, entity.position.y
        local left    = cx + sel_box.left_top.x
        local top     = cy + sel_box.left_top.y
        local right   = cx + sel_box.right_bottom.x
        local bottom  = cy + sel_box.right_bottom.y

        min_x         = math.min(min_x, left)
        min_y         = math.min(min_y, top)
        max_x         = math.max(max_x, right)
        max_y         = math.max(max_y, bottom)
    end

    local blueprint_center     = {
        x = (min_x + max_x) / 2,
        y = (min_y + max_y) / 2
    }

    local anchor_x             = event_position.x
    local anchor_y             = event_position.y

    local rel_x                = blueprint_entity.position.x - blueprint_center.x
    local rel_y                = blueprint_entity.position.y - blueprint_center.y

    local rotated_x, rotated_y = rel_x, rel_y
    if direction == defines.direction.east then
        rotated_x, rotated_y = -rel_y, rel_x
    elseif direction == defines.direction.south then
        rotated_x, rotated_y = -rel_x, -rel_y
    elseif direction == defines.direction.west then
        rotated_x, rotated_y = rel_y, -rel_x
    end

    return
    {
        x = anchor_x + rotated_x,
        y = anchor_y + rotated_y
    }
end

local function blueprint_validate_resource_checks(player, entity, resource_name, item_name, quality)
    local force = player.force
    local entity_name = entity.name

    local resource_prototypes = prototypes.get_entity_filtered({ { filter = "name", name = resource_name } })
    local resource_prototype = resource_prototypes[resource_name]

    local is_fluid_resource = is_fluid_category_supported(resource_prototype.resource_category)
    local pumpjack_fluid = is_pumpjack_fluid(resource_prototype.resource_category)
    local water_miner_fluid = is_water_miner_fluid(resource_prototype.resource_category)
    local oil_rig_fluid = is_oil_rig_fluid(resource_prototype.resource_category)
    local is_pumpjack = entity_name == "rmd-pumpjack"
    local is_water_miner = entity_name == "rmd-bob-water-miner"
    local is_oil_rig = entity_name == "rmd-oil-rig"
    local is_rmd_entity = RMD_ENTITY_NAMES[entity_name] == true
    local is_drill = is_rmd_entity and (string.find(entity_name, "drill") ~= nil)

    if is_drill then
        local resource_category = resource_prototype.resource_category
        local is_minable = resource_category == "basic-solid" or resource_category == "hard-solid"
        local is_required_fluid = resource_prototype.mineable_properties.required_fluid ~= nil
        local is_researched = is_fluid_mining_researched(force)

        if is_required_fluid and not is_researched then return false end
        if not drill_and_resource_compatible(entity, resource_category) then return false end
        if not is_minable then return false end
        if is_fluid_resource then return false end
        if (entity_name == "rmd-burner-mining-drill" or entity_name == "rmd-slow-electric-mining-drill") and is_required_fluid then return false end
        if (entity_name == "rmd-electric-mining-drill" or entity_name == "rmd-burner-mining-drill") and resource_category == "hard-solid" then return false end
        if (is_required_fluid and not is_researched) and resource_name ~= "kr-rare-metal-ore" then return false end
    else
        if is_pumpjack and not pumpjack_fluid then return false end
        if is_water_miner and not water_miner_fluid then return false end
        if is_oil_rig and not oil_rig_fluid then return false end
        if is_oil_rig and not on_water(entity) then return false end
    end

    return true
end

local function get_logistic_drill_count(player, drill_names)
    if not (player and player.valid and player.character and player.character.valid) then return 0 end

    local surface = player.surface
    local position = player.character.position
    local force = player.force

    local network = surface.find_logistic_network_by_position(position, force)
    if not network then
        return 0
    end

    local total = 0
    for _, name in pairs(drill_names) do
        total = total + (network.get_item_count(name) or 0)
    end

    return total
end

local function player_has_sufficient_drills(player, blueprint_entities)
    local needed_counts = {}

    for _, entity in pairs(blueprint_entities) do
        if string.sub(entity.name, 1, 4) == "rmd-" then
            local item_name = entity.name
            if string.sub(item_name, -10) == "-displayer" then
                item_name = string.sub(item_name, 1, #item_name - 10)
            end
            needed_counts[item_name] = (needed_counts[item_name] or 0) + 1
        end
    end

    if next(needed_counts) == nil then
        return true
    end

    for item_name, needed in pairs(needed_counts) do
        local inventory_count = player.get_item_count(item_name)
        local logistic_count = get_logistic_drill_count(player, { item_name })
        local total_available = inventory_count + logistic_count

        if total_available < needed then
            player.create_local_flying_text
            {
                text =
                {
                    "",
                    { "rmd-message.rmd-error-not-enough-drills" },
                    " (", total_available, "/", needed, ") [item=", item_name, "]"
                },
                create_at_cursor = true
            }
            return false
        end
    end

    return true
end

local function on_pre_build(event)
    local player = game.players[event.player_index]
    local surface = player.surface
    local cursor = player.cursor_stack

    if not (cursor and cursor.valid_for_read) then return end
    if not cursor.is_blueprint then return end
    if not cursor.is_blueprint_setup() then return end

    local entities = cursor.get_blueprint_entities()
    if not entities then return end

    if not player_has_sufficient_drills(player, entities) then
        return
    end

    for _, entity in pairs(entities) do
        if string.sub(entity.name, 1, 4) == "rmd-" then
            local resource_name
            if entity.tags and entity.tags.selected_resource then
                resource_name = tostring(entity.tags.selected_resource)
            elseif storage.players[player.index].selected_resource ~= DISABLED then
                resource_name = storage.players[player.index].selected_resource
            else
                player.create_local_flying_text
                {
                    text = { "", { "rmd-message.rmd-error-no-resource" } },
                    create_at_cursor = true
                }
                return
            end

            if blueprint_validate_resource_checks(player, entity, resource_name, entity.name, entity.quality) then
                local entity_map_position = get_entity_map_position(event, entity, entities)
                spot_resources(surface, entity_map_position, resource_name, event.player_index)
            else
                player.create_local_flying_text
                {
                    text = { "", { "rmd-message.rmd-error-invalid-selection" } },
                    create_at_cursor = true
                }
            end
        end
    end
end

local function on_player_pipette(event)
    local player = game.players[event.player_index]
    local cursor = player.cursor_stack
    local selected = player.selected

    if not (cursor and cursor.valid_for_read) then return end
    if not (selected and selected.valid) then return end
    if selected.type == "resource" then
        local player_data = get_or_create_player_data(player.index)
        player_data.selected_resource = selected.name

        local rmd_mining_drill = "rmd-" .. cursor.name
        if prototypes.item[rmd_mining_drill] then
            local count = player.get_item_count(rmd_mining_drill)
            if count > 0 then
                local stack_size = prototypes.item[rmd_mining_drill].stack_size
                local place_count = math.min(count, stack_size)

                local original_name = cursor.name
                local original_count = cursor.count

                cursor.clear()

                player.insert {
                    name = original_name,
                    count = original_count
                }

                local removed = player.remove_item {
                    name = rmd_mining_drill,
                    count = place_count
                }
                cursor.set_stack {
                    name = rmd_mining_drill,
                    count = removed
                }
            end
        end
    end
end

local function undo_spot_resources(surface, position, player_index)
    local player = game.get_player(player_index)
    if not player then return end

    local area =
    {
        { position.x - 1, position.y - 1 },
        { position.x + 1, position.y + 1 }
    }

    local resources = surface.find_entities_filtered { area = area, type = "resource" }

    for _, resource in ipairs(resources) do
        if resource.valid then
            resource.destroy()
        end
    end
end

local function on_undo_applied(event)
    local player_index = event.player_index
    local player = game.get_player(player_index)
    if not player then return end

    local cursor = player.cursor_stack
    if cursor and cursor.valid_for_read then
        if cursor.is_blueprint then
            local drills_found = false
            local entities = cursor.get_blueprint_entities()
            if entities then
                for _, entity in pairs(entities) do
                    if string.sub(entity.name, 1, 4) == "rmd-" then
                        drills_found = true
                        break
                    end
                end
            end
            if drills_found == true then
                for _, action in pairs(event.actions) do
                    undo_spot_resources(player.surface, action.target.position, event.player_index)
                end
            end
        end
    end
end

local function register_event_handlers()
    script.on_event(defines.events.on_chunk_generated, on_chunk_generated)
    script.on_event(defines.events.on_surface_created, on_surface_created)

    script.on_event(defines.events.on_cutscene_cancelled, on_cutscene_cancelled)
    script.on_event(defines.events.on_player_changed_surface, on_player_changed_surface)
    script.on_event(defines.events.on_player_setup_blueprint, on_player_setup_blueprint)
    script.on_event(defines.events.on_player_cursor_stack_changed, on_player_cursor_stack_changed)

    script.on_event(defines.events.on_gui_click, on_gui_click)
    script.on_event(defines.events.on_gui_checked_state_changed, on_gui_check_state_changed)
    script.on_event(defines.events.on_gui_text_changed, on_gui_text_changed)
    script.on_event(defines.events.on_gui_closed, on_gui_closed)
    script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
    script.on_event(defines.events.on_player_pipette, on_player_pipette)

    script.on_event(defines.events.on_pre_build, on_pre_build)
    script.on_event(defines.events.on_built_entity, on_built_entity)
    script.on_event(defines.events.on_robot_built_entity, on_built_entity)
    script.on_event(defines.events.on_entity_cloned, on_built_entity)
    script.on_event(defines.events.script_raised_revive, on_built_entity)

    script.on_event(defines.events.on_player_mined_entity, on_mined_entity)
    script.on_event(defines.events.on_robot_mined_entity, on_mined_entity)
    script.on_event(defines.events.on_entity_died, on_mined_entity)
    script.on_event(defines.events.script_raised_destroy, on_mined_entity)

    script.on_event(defines.events.on_undo_applied, on_undo_applied)
    script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)
    script.on_event("rmd-toggle-resource-selector", on_toggle_resource_selector)
    script.on_event("rmd-toggle-cursor-drill", on_toggle_cursor_drill)
end

script.on_init(function()
    storage.players = {}
    register_event_handlers()
end)

script.on_load(function()
    register_event_handlers()
end)

script.on_configuration_changed(function()
    for _, player in pairs(game.players) do
        get_or_create_player_data(player.index)
    end
    register_event_handlers()
end)
