require("constants")
require("utilities")

if not settings.startup["rmd-slow-miner"].value then return end

local BASE_GRAPHICS   = "__base__/graphics/"
local ENTITY_GRAPHICS = BASE_GRAPHICS .. "entity/"
local DRILL_GRAPHICS  = ENTITY_GRAPHICS .. "electric-mining-drill/"

local TO_COPY         = "electric-mining-drill"
local NAME            = "rmd-slow-electric-mining-drill"

local mining_drill    = data.raw["mining-drill"][TO_COPY]
if not mining_drill then return end

local icons = nil
if mining_drill.icon then
    icons =
    {
        {
            icon = STONE_ICON
        },
        {
            icon = mining_drill.icon,
            icon_size = mining_drill.icon_size,
            shift = { -8, -8 }
        }
    }
end

local rmd_mining_drill_displayer =
{
    type                               = "simple-entity-with-owner",
    name                               = NAME .. "-displayer",
    localised_name                     = { "", { "item-name." .. NAME .. "-displayer" } },
    localised_description              = mining_drill.localised_description,
    placeable_by                       = { item = NAME, count = 1 },
    minable                            = { mining_time = 0.5, result = NAME },
    icon                               = BROKEN_ICON,
    icon_size                          = 64,
    icons                              = icons,
    radius_visualisation_specification =
    {
        sprite =
        {
            filename = DRILL_GRAPHICS .. "electric-mining-drill-radius-visualization.png",
            width = 12,
            height = 12,
            shift = { 0, 0 },
        },
        distance = 1
    },
    flags                              = { "placeable-neutral", "placeable-player", "player-creation", "not-upgradable" },
    max_health                         = mining_drill.max_health,
    collision_box                      = { { -0.7, -0.7 }, { 0.7, 0.7 } },
    selection_box                      = { { -1, -1 }, { 1, 1 } },
    collision_mask                     = COLLISION_MASK,
    hidden_in_factoriopedia            = true,
    factoriopedia_alternative          = NAME,
    integration_patch                  = copy_displayer_integration_patch(mining_drill),
    picture                            = make_animated_mining_drill_displayer_picture(mining_drill)
}

local SCALE_FACTOR               = 2 / 3

local function rescale_direction_table(dir_table, factor)
    local function rescale_layer(layer, factor)
        if layer.scale then
            layer.scale = layer.scale * factor
        else
            layer.scale = factor
        end
        if layer.shift then
            layer.shift[1] = layer.shift[1] * factor
            layer.shift[2] = layer.shift[2] * factor
        end
    end

    for _, dir in pairs({ "north", "east", "south", "west" }) do
        local dir_data = dir_table[dir]
        if dir_data then
            if dir_data.layers then
                for _, layer in ipairs(dir_data.layers) do
                    rescale_layer(layer, factor)
                end
            else
                rescale_layer(dir_data, factor)
            end
        end
    end
end

rescale_direction_table(rmd_mining_drill_displayer.integration_patch, SCALE_FACTOR)
rescale_direction_table(rmd_mining_drill_displayer.picture, SCALE_FACTOR)

local rmd_mining_drill_entity                     = table.deepcopy(mining_drill)

rmd_mining_drill_entity.name                      = NAME
rmd_mining_drill_entity.localised_name            = { "item-name.rmd-slow-electric-mining-drill" }
rmd_mining_drill_entity.placeable_by              = { item = NAME, count = 1 }
rmd_mining_drill_entity.minable.result            = "rmd-slow-electric-mining-drill"
rmd_mining_drill_entity.mining_speed              = 0.25
rmd_mining_drill_entity.energy_usage              = scale_energy_usage(mining_drill.energy_usage, SCALE_FACTOR)
rmd_mining_drill_entity.resource_searching_radius = 0.99
rmd_mining_drill_entity.module_slots              = 2
rmd_mining_drill_entity.vector_to_place_result    = { -0.5, -1.3 }
rmd_mining_drill_entity.resource_categories       = { "basic-solid" }
rmd_mining_drill_entity.wet_mining_graphics_set   = nil
rmd_mining_drill_entity.input_fluid_box           = nil
rmd_mining_drill_entity.next_upgrade              = nil
rmd_mining_drill_entity.collision_box             = { { -0.7, -0.7 }, { 0.7, 0.7 } }
rmd_mining_drill_entity.selection_box             = { { -1, -1 }, { 1, 1 } }
rmd_mining_drill_entity.icon                      = BROKEN_ICON
rmd_mining_drill_entity.icon_size                 = 64
rmd_mining_drill_entity.icons                     = icons

local function rescale_drill_entity(entity, factor)
    local function rescale_layer(layer)
        if layer.scale then
            layer.scale = layer.scale * factor
        else
            layer.scale = factor
        end
        if layer.shift then
            layer.shift[1] = layer.shift[1] * factor
            layer.shift[2] = layer.shift[2] * factor
        end
    end

    local function rescale_integration_patch(patch, factor)
        if not patch then return end
        for _, dir in pairs({ "north", "east", "south", "west" }) do
            local p = patch[dir]
            if p then
                if p.scale then
                    p.scale = p.scale * factor
                else
                    p.scale = factor
                end
                if p.shift then
                    p.shift[1] = p.shift[1] * factor
                    p.shift[2] = p.shift[2] * factor
                end
            end
        end
    end

    local function rescale_animation_table(anim)
        if not anim then return end
        for _, dir in pairs({ "north", "east", "south", "west" }) do
            local dir_anim = anim[dir]
            if dir_anim then
                if dir_anim.layers then
                    for _, layer in ipairs(dir_anim.layers) do
                        rescale_layer(layer)
                    end
                else
                    rescale_layer(dir_anim)
                end
            end
        end
    end

    local function rescale_working_visualisations(visuals)
        if not visuals then return end
        for _, vis in ipairs(visuals) do
            for _, key in ipairs({ "animation", "north_animation", "east_animation", "south_animation", "west_animation" }) do
                local anim = vis[key]
                if anim then
                    if anim.layers then
                        for _, layer in ipairs(anim.layers) do
                            rescale_layer(layer)
                        end
                    else
                        rescale_layer(anim)
                    end
                end
            end

            for _, key in ipairs({ "north_position", "east_position", "south_position", "west_position" }) do
                local pos = vis[key]
                if pos then
                    pos[1] = pos[1] * factor
                    pos[2] = pos[2] * factor
                end
            end
        end
    end

    local function rescale_circuit_connectors(connectors, factor)
        local function scale_offset(pos)
            if pos then
                if pos.x and pos.y then
                    pos.x = pos.x * factor
                    pos.y = pos.y * factor
                elseif pos[1] and pos[2] then
                    pos[1] = pos[1] * factor
                    pos[2] = pos[2] * factor
                end
            end
        end

        for _, conn in ipairs(connectors) do
            for _, key in ipairs({ "blue_led_light_offset", "red_green_led_light_offset" }) do
                scale_offset(conn.sprites[key])
            end
            for _, point_type in pairs({ "wire", "shadow" }) do
                for _, color in pairs({ "red", "green" }) do
                    scale_offset(conn.points[point_type][color])
                end
            end
            for _, sprite in pairs(conn.sprites) do
                if sprite.shift then
                    sprite.shift[1] = sprite.shift[1] * factor
                    sprite.shift[2] = sprite.shift[2] * factor
                end
            end
        end
    end

    if entity.graphics_set then
        rescale_animation_table(entity.graphics_set.animation)
        rescale_integration_patch(entity.integration_patch, factor)
        rescale_working_visualisations(entity.graphics_set.working_visualisations)
        rescale_circuit_connectors(entity.circuit_connector, factor)
    end
end

rescale_drill_entity(rmd_mining_drill_entity, SCALE_FACTOR)

local rmd_mining_drill_item = table.deepcopy(data.raw["item"][TO_COPY])
if not rmd_mining_drill_item or rmd_mining_drill_item.hidden then return end

rmd_mining_drill_item.name           = NAME
rmd_mining_drill_item.place_result   = NAME .. "-displayer"
rmd_mining_drill_item.flags          = { "primary-place-result" }
rmd_mining_drill_item.localised_name = { "", { "item-name." .. NAME } }
rmd_mining_drill_item.order          = "a[items]-a[slow-electric-mining-drill]"
rmd_mining_drill_item.icon           = BROKEN_ICON
rmd_mining_drill_item.icon_size      = 64
rmd_mining_drill_item.icons          = icons

local rmd_mining_drill_recipe        = table.deepcopy(data.raw["recipe"][TO_COPY])
if not rmd_mining_drill_recipe or rmd_mining_drill_recipe.hidden then return end

rmd_mining_drill_recipe.name    = NAME
rmd_mining_drill_recipe.results = { { type = "item", name = NAME, amount = 1 } }

if mods["space-age"] then
    rmd_mining_drill_displayer.surface_conditions = { { min = 0.1, property = "gravity" } }
    rmd_mining_drill_entity.surface_conditions = { { min = 0.1, property = "gravity" } }
end

data.extend({ rmd_mining_drill_displayer, rmd_mining_drill_entity, rmd_mining_drill_item, rmd_mining_drill_recipe })

local technology = data.raw["technology"]["electric-mining-drill"]
local effect =
{
    recipe = NAME,
    type = "unlock-recipe"
}

table.insert(technology.effects, effect)
