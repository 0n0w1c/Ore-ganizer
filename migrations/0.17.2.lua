local FLUID_RESOURCE_BY_DRILL = {
    ["rmd-pumpjack"] = true,
    ["rmd-bob-water-miner"] = true,
    ["rmd-oil_rig"] = true,
    ["rmd-steel-derrick"] = true
}

local function get_mining_area(entity)
    local radius = entity.prototype.mining_drill_radius or 0.99
    local position = entity.position

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

for _, surface in pairs(game.surfaces) do
    local drills = surface.find_entities_filtered {
        type = "mining-drill"
    }

    for _, drill in pairs(drills) do
        if drill.valid and FLUID_RESOURCE_BY_DRILL[drill.name] then
            local area = get_mining_area(drill)

            local resources = surface.find_entities_filtered {
                area = area,
                type = "resource"
            }

            for _, resource in pairs(resources) do
                if resource.valid
                    and resource.prototype.infinite_resource
                    and resource.initial_amount == nil
                    and resource.amount
                    and resource.amount > 0 then
                    resource.initial_amount = resource.amount
                end
            end

            drill.update_connections()
        end
    end
end
