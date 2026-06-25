local target_entity_names = {
    "rmd-steam-mining-drill",
}

local function existing_entity_names(names)
    local result = {}
    for _, name in pairs(names) do
        if prototypes.entity[name] then
            table.insert(result, name)
        end
    end
    return result
end

local function quality_name(entity)
    local ok, quality = pcall(function() return entity.quality end)
    if ok and quality then return quality.name end
    return nil
end

local function last_user_index(entity)
    local ok, user = pcall(function() return entity.last_user end)
    if ok and user and user.valid then return user.index end
    return nil
end

local function rounded_position_key(position)
    return string.format("%.2f,%.2f", position.x, position.y)
end

local function spec_key(spec)
    local force = spec.force and spec.force.name or ""
    return spec.surface.name .. "|" .. spec.name .. "|" .. force .. "|" .. rounded_position_key(spec.position)
end

local function capture_spec(entity)
    return {
        name = entity.name,
        surface = entity.surface,
        position = { x = entity.position.x, y = entity.position.y },
        direction = entity.direction,
        force = entity.force,
        quality = quality_name(entity),
        player = last_user_index(entity),
    }
end

local function destroy_entity(entity)
    if entity and entity.valid then
        pcall(function()
            entity.destroy { raise_destroy = false }
        end)
    end
end

local function create_entity(spec)
    local params = {
        name = spec.name,
        position = spec.position,
        direction = spec.direction,
        force = spec.force,
        quality = spec.quality,
        player = spec.player,
        raise_built = false,
        create_build_effect_smoke = false,
        spawn_decorations = false,
        move_stuck_players = true,
    }

    pcall(function()
        return spec.surface.create_entity(params)
    end)
end

local names = existing_entity_names(target_entity_names)
if #names == 0 then return end

for _, surface in pairs(game.surfaces) do
    local specs_by_key = {}
    local entities = surface.find_entities_filtered { name = names }

    for _, entity in pairs(entities) do
        if entity and entity.valid then
            local spec = capture_spec(entity)
            local key = spec_key(spec)
            if not specs_by_key[key] then
                specs_by_key[key] = spec
            end
        end
    end

    for _, entity in pairs(entities) do
        destroy_entity(entity)
    end

    for _, spec in pairs(specs_by_key) do
        create_entity(spec)
    end
end
