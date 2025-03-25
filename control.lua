require("constants")

local mod_gui = require("mod-gui")

local AMOUNT = settings.startup["rmd-resource-amount"].value
local IGNORE = settings.startup["rmd-resource-ignore"].value

local TILES_TO_EXCLUDE =
{
    ["ammoniacal-ocean"] = true,
    ["ammoniacal-ocean-2"] = true,
    ["brash-ice"] = true,
    ["deepwater"] = true,
    ["deepwater-green"] = true,
    ["gleba-deep-lake"] = true,
    ["lava"] = true,
    ["lava-hot"] = true,
    ["oil-ocean-deep"] = true,
    ["oil-ocean-shallow"] = true,
    ["water"] = true,
    ["water-green"] = true,
    ["water-mud"] = true,
    ["water-shallow"] = true,
    ["water-wube"] = true,
    ["wetland-blue-slime"] = true,
    ["wetland-dead-skin"] = true,
    ["wetland-green-slime"] = true,
    ["wetland-jellynut"] = true,
    ["wetland-light-dead-skin"] = true,
    ["wetland-light-green-slime"] = true,
    ["wetland-pink-tentacle"] = true,
    ["wetland-red-tentacle"] = true,
    ["wetland-yumako"] = true,
    ["space-platform-foundation"] = true,
    ["foundation"] = true
}

--[[
FOUNDATION_TILES = {
    ["landfill"] = true,
    ["space-platform-foundation"] = true,
    ["foundation"] = true,
    ["artificial-yumako-soil"] = true,
    ["overgrowth-yumako-soil"] = true,
    ["artificial-jellynut-soil"] = true,
    ["overgrowth-jellynut-soil"] = true,
    ["ice-platform"] = true
}
]]

local function get_mining_area(entity)
    if not (entity and entity.valid) then return {} end

    local position = entity.position
    local entity_name = entity.name

    local prototype_name = entity_name
    if string.sub(entity_name, 1, 25) == "rmd-electric-mining-drill" then
        prototype_name = "electric-mining-drill"
    elseif string.sub(entity_name, 1, 20) == "rmd-big-mining-drill" then
        prototype_name = "big-mining-drill"
    elseif string.sub(entity_name, 1, 12) == "rmd-pumpjack" then
        prototype_name = "pumpjack"
    end

    local prototype = prototypes.get_entity_filtered { { filter = "type", type = "mining-drill" } }
    local radius = prototype[prototype_name].mining_drill_radius or 1

    return {
        left_top = {
            x = math.floor(position.x - radius),
            y = math.floor(position.y - radius)
        },
        right_bottom = {
            x = math.ceil(position.x + radius),
            y = math.ceil(position.y + radius)
        }
    }
end

local function place_resources(surface, area, resource_name)
    local resource_prototypes = prototypes.get_entity_filtered {
        { filter = "name", name = resource_name }
    }
    local prototype = resource_prototypes[resource_name]

    if not prototype or prototype.type ~= "resource" then return end

    local is_fluid = prototype.resource_category == "basic-fluid"

    for x = area.left_top.x, area.right_bottom.x - 1 do
        for y = area.left_top.y, area.right_bottom.y - 1 do
            local position = { x = x, y = y }

            local tile = surface.get_tile(x, y)
            if TILES_TO_EXCLUDE[tile.name] then goto continue end

            local cliffs = surface.find_entities_filtered {
                area = { { x, y }, { x + 1, y + 1 } },
                type = "cliff"
            }
            if #cliffs > 0 then goto continue end

            local resource_amount = is_fluid and (AMOUNT * FLUID_MULTIPLIER) or AMOUNT

            surface.create_entity({
                name = resource_name,
                amount = resource_amount,
                position = position
            })

            ::continue::
        end
    end
end

local function remove_resources(surface, area)
    for x = area.left_top.x, area.right_bottom.x - 1 do
        for y = area.left_top.y, area.right_bottom.y - 1 do
            local resources = surface.find_entities_filtered { area = { { x, y }, { x + 1, y + 1 } }, type = "resource" }

            for _, resource in pairs(resources) do
                if resource.valid then
                    resource.destroy()
                end
            end
        end
    end
end

local function return_item_to_player(player, item_name)
    local stack = player.cursor_stack

    if stack and stack.valid then
        if stack.valid_for_read and (
                stack.is_blueprint or
                stack.is_blueprint_book or
                stack.is_deconstruction_item or
                stack.is_upgrade_item
            ) then
            player.insert({ name = item_name, count = 1 })
            return
        end

        if stack.valid_for_read and stack.name == item_name then
            stack.count = stack.count + 1
        else
            stack.set_stack({ name = item_name, count = 1 })
        end
    else
        player.insert({ name = item_name, count = 1 })
    end
end

local function on_entity_built(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    local player = event.player_index and game.get_player(event.player_index)
        or (entity.last_user and entity.last_user.valid and entity.last_user.is_player() and entity.last_user)

    if not player or not storage.players[player.index] then return end

    local resource_name = storage.players[player.index].selected_resource
    if resource_name == DISABLED then return end

    local resource_prototypes = prototypes.get_entity_filtered {
        { filter = "name", name = resource_name }
    }
    local resource_prototype = resource_prototypes[resource_name]

    if not resource_prototype or resource_prototype.type ~= "resource" then return end

    local is_fluid_resource = (resource_prototype.resource_category == "basic-fluid")

    local entity_name = entity.name
    local surface = entity.surface
    local force = entity.force
    local position = entity.position
    local direction = entity.direction

    local is_displayer = string.find(entity_name, "^rmd%-.+%-displayer$")
    if not is_displayer then return end

    local real_entity_name = string.gsub(entity_name, "-displayer$", "")
    local is_pumpjack = entity_name == "rmd-pumpjack-displayer"
    local is_drill = (entity_name == "rmd-electric-mining-drill-displayer" or entity_name == "rmd-big-mining-drill-displayer")

    if is_pumpjack and not is_fluid_resource then
        entity.destroy()
        return_item_to_player(player, "rmd-pumpjack")
        return
    end

    if is_drill then
        local resource_category = resource_prototype.resource_category
        local item_name = (entity_name == "rmd-big-mining-drill-displayer")
            and "rmd-big-mining-drill"
            or "rmd-electric-mining-drill"

        if is_fluid_resource or (entity_name == "rmd-electric-mining-drill-displayer" and resource_category == "hard-solid") then
            entity.destroy()
            return_item_to_player(player, item_name)
            return
        end
    end

    local resource_area = get_mining_area(entity)

    entity.destroy()

    remove_resources(surface, resource_area)
    place_resources(surface, resource_area, resource_name)

    surface.create_entity {
        name = real_entity_name,
        force = force,
        position = position,
        direction = direction,
        create_build_effect_smoke = true
    }
end

local function on_entity_mined(event)
    local entity = event.entity
    if not (entity and entity.valid) then return end

    if entity.name == "rmd-electric-mining-drill" or entity.name == "rmd-big-mining-drill" or entity.name == "rmd-pumpjack" then
        local surface = entity.surface
        local resource_area = get_mining_area(entity)

        remove_resources(surface, resource_area)
    end
end

local function get_or_create_player_data(player_index)
    storage.players = storage.players or {}

    if not storage.players[player_index] then
        storage.players[player_index] =
        {
            selected_resource = DISABLED,
            button_on = true
        }
    end

    return storage.players[player_index]
end

local function update_button(player_index)
    local player = game.get_player(player_index)
    if not (player and player.valid) then return end

    local player_data = get_or_create_player_data(player_index)
    local button_flow = mod_gui.get_button_flow(player)

    local sprite_path = "entity/" .. player_data.selected_resource
    local localized_item_name = (player_data.selected_resource == DISABLED) and
        { "gui.rmd-blueprint-mode" } or { "entity-name." .. player_data.selected_resource }

    local tool_tip = {
        "",
        localized_item_name,
        "\n",
        { "tool-tip.rmd-tool-tip" },
        "\n",
        { "tool-tip.rmd-clear-hint" }
    }

    if player_data.selected_resource == DISABLED or not helpers.is_valid_sprite_path(sprite_path) then
        sprite_path = "rmd-blueprint-mode"
        player_data.selected_resource = DISABLED
    end

    local existing = button_flow[THIS_MOD]

    if player_data.button_on then
        if not existing then
            button_flow.add {
                type = "sprite-button",
                name = THIS_MOD,
                sprite = sprite_path,
                tooltip = tool_tip,
                style = mod_gui.button_style
            }
        else
            existing.sprite = sprite_path
            existing.tooltip = tool_tip
        end
    elseif existing then
        existing.destroy()
    end

    player.set_shortcut_toggled("rmd-toggle-button", storage.players[player_index].button_on)
end

local function show_resource_selector_gui(player)
    if player.gui.screen.resource_selector_frame then
        player.gui.screen.resource_selector_frame.destroy()
    end

    local surface = player.surface
    local map_gen_settings = surface.map_gen_settings

    local items = { DISABLED }

    local resource_prototypes = prototypes.get_entity_filtered { { filter = "type", type = "resource" } }

    for name, prototype in pairs(resource_prototypes) do
        if IGNORE or map_gen_settings.autoplace_settings.entity.settings[name] then
            table.insert(items, name)
        end
    end

    local selected = storage.players[player.index].selected_resource

    local frame = player.gui.screen.add {
        type = "frame",
        name = "resource_selector_frame",
        direction = "vertical",
    }

    frame.auto_center = true

    local titlebar_flow = frame.add {
        type = "flow",
        direction = "horizontal",
    }
    titlebar_flow.style.horizontal_spacing = 6

    titlebar_flow.add {
        type = "label",
        caption = { "gui.rmd-resource-selector" },
        ignored_by_interaction = true,
        style = "frame_title",
    }

    local draggable_space = titlebar_flow.add {
        type = "empty-widget",
        name = "resource_selector_draggable_space",
        style = "draggable_space_header",
        ignored_by_interaction = false,
    }
    draggable_space.style.height = 24
    draggable_space.style.horizontally_stretchable = true
    draggable_space.drag_target = frame

    local close_button = titlebar_flow.add {
        type = "sprite-button",
        name = "resource_selector_close_button",
        sprite = "utility/close",
        style = "close_button",
        mouse_button_filter = { "left" }
    }

    close_button.style.height = 24
    close_button.style.width = 24

    local inner_frame = frame.add {
        type = "frame",
        name = "inner_frame",
        direction = "vertical",
        style = "inside_shallow_frame",
    }

    local scroll_pane = inner_frame.add {
        type = "scroll-pane",
        name = "resource_scroll_pane",
        horizontal_scroll_policy = "never",
        vertical_scroll_policy = "auto",
    }
    scroll_pane.style.maximal_height = 300
    scroll_pane.style.minimal_width = 400
    scroll_pane.style.padding = 4

    local grid = scroll_pane.add {
        type = "table",
        name = "resource_selector_grid",
        column_count = 10,
        style = "table",
    }

    for _, item_name in pairs(items) do
        if item_name ~= DISABLED then
            local style = "slot_sized_button"
            if item_name == selected then
                style = "slot_sized_button_pressed"
            end

            local button = grid.add {
                type = "choose-elem-button",
                name = "resource_selector_button_" .. item_name,
                elem_type = "entity",
                entity = item_name,
                style = style,
            }

            button.locked = true
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

local function on_lua_shortcut(event)
    if (not event) or (not event.prototype_name) or (event.prototype_name ~= "rmd-toggle-button") then return end

    local player = game.get_player(event.player_index)
    if not player then return end

    storage.players[player.index].button_on = not storage.players[player.index].button_on

    if not storage.players[player.index].button_on then
        storage.players[player.index].selected_resource = DISABLED
    end

    update_button(player.index)
end

local function on_gui_click(event)
    if event and event.element and event.element.valid then
        local player = game.get_player(event.player_index)
        if not (player and player.valid) then return end

        local player_data = get_or_create_player_data(player.index)

        if event.element.name == THIS_MOD then
            if event.button == defines.mouse_button_type.left then
                if player.gui.screen.resource_selector_frame then
                    close_resource_selector_gui(player)
                else
                    show_resource_selector_gui(player)
                end
            elseif event.button == defines.mouse_button_type.right then
                player_data.selected_resource = DISABLED
                close_resource_selector_gui(player)
            end
            update_button(player.index)
        elseif event.element.name == "resource_selector_close_button" then
            close_resource_selector_gui(player)
        elseif event.element.name:match("^resource_selector_button_") then
            local selected_resource_name = event.element.name:sub(("resource_selector_button_"):len() + 1)
            player_data.selected_resource = selected_resource_name
            close_resource_selector_gui(player)
            update_button(player.index)
        end
    end
end

local function player_created(event)
    local player_index = event.player_index

    get_or_create_player_data(player_index)
    update_button(player_index)
end

local function player_changed_surface(event)
    local player_index = event.player_index

    local player_data = get_or_create_player_data(player_index)
    if not player_data then return end

    player_data.selected_resource = DISABLED
    update_button(player_index)
end

local function register_event_handlers()
    script.on_event(defines.events.on_player_created, player_created)
    script.on_event(defines.events.on_player_changed_surface, player_changed_surface)

    script.on_event(defines.events.on_gui_click, on_gui_click)
    script.on_event(defines.events.on_gui_closed, on_gui_closed)
    script.on_event(defines.events.on_lua_shortcut, on_lua_shortcut)

    script.on_event(defines.events.on_built_entity, on_entity_built)
    script.on_event(defines.events.on_robot_built_entity, on_entity_built)
    script.on_event(defines.events.on_entity_cloned, on_entity_built)
    script.on_event(defines.events.script_raised_revive, on_entity_built)

    script.on_event(defines.events.on_player_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_robot_mined_entity, on_entity_mined)
    script.on_event(defines.events.on_entity_died, on_entity_mined)
    script.on_event(defines.events.script_raised_destroy, on_entity_mined)
end

script.on_init(function()
    if not storage.players then
        storage.players = {}
    end

    register_event_handlers()
end)

script.on_load(function()
    register_event_handlers()
end)

script.on_configuration_changed(function()
    for _, player in pairs(game.players) do
        get_or_create_player_data(player.index)
        update_button(player.index)
    end
    register_event_handlers()
end)
