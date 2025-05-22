if not mods["space-age"] or mods["EverythingOnNauvis"] then return end

local util = require("util")

data.extend({
    {
        type = "fluid",
        name = "rmd-aquilo-islands",
        default_temperature = 25,
        max_temperature = 25,
        base_color = { r = 1, g = 1, b = 1 },
        flow_color = { r = 1, g = 1, b = 1 },
        icon = MOD_PATH .. "/graphics/icons/rmd-transparent-x64.png",
        icon_size = 64,
        hidden = true,
        auto_barrel = false,
        auto_recycle = false,
        order = "z[fluid]-z[rmd-aquilo-islands]"
    }
})

data.extend({
    {
        type = "autoplace-control",
        name = "rmd_aquilo_islands",
        localised_name = { "autoplace-control-name.rmd_aquilo_islands" },
        localised_description = { "autoplace-control-description.rmd_aquilo_islands" },
        category = "resource",
        order = "z[rmd-aquilo-islands]"
    }
})

data.extend({
    {
        type = "noise-expression",
        name = "aquilo_starting_rmd_aquilo_islands_spots",
        expression =
        "starting_spot_at_angle{angle = aquilo_angle + 90, distance = 20, radius = aquilo_spot_size * 0.6, x_distortion = 0, y_distortion = 0}",
    },
    {
        type = "noise-expression",
        name = "aquilo_rmd_aquilo_islands_spots",
        expression =
        "aquilo_spot_noise{seed = 568,count = 3,skip_offset = 1,region_size = 600 + 400 / control:rmd_aquilo_islands:frequency,density = 1,radius = aquilo_spot_size * 1.2 * sqrt(control:rmd_aquilo_islands:size),favorability = 1}",
    },
    {
        type = "noise-expression",
        name = "rmd_aquilo_islands_probability",
        expression = "aquilo_rmd_aquilo_islands_spots * 0.01"
    },
    {
        type = "noise-expression",
        name = "rmd_aquilo_islands_richness",
        expression = "200000"
    }
})

local aquilo_islands = util.table.deepcopy(data.raw["resource"]["fluorine-vent"])

aquilo_islands.name = "rmd-aquilo-islands"
aquilo_islands.icon = MOD_PATH .. "/graphics/icons/rmd-transparent-x64.png"
aquilo_islands.icon_size = 64
aquilo_islands.hidden = true
aquilo_islands.map_color = { r = 0.5, g = 0.5, b = 0.5, a = 0 }
aquilo_islands.stateless_visualisation = nil
aquilo_islands.autoplace = {
    control = "rmd_aquilo_islands",
    probability_expression = "rmd_aquilo_islands_probability",
    richness_expression = "rmd_aquilo_islands_richness"
}
aquilo_islands.stages = {
    sheet = {
        filename = MOD_PATH .. "/graphics/icons/rmd-transparent-x64.png",
        width = 64,
        height = 64,
        frame_count = 1,
        variation_count = 1,
        priority = "extra-high"
    }
}
aquilo_islands.stage_counts = { 0 }
aquilo_islands.minable = {
    mining_time = 1,
    results = {
        {
            type = "fluid",
            name = "rmd-aquilo-islands",
            amount_min = 1,
            amount_max = 1,
            probability = 1
        }
    }
}

data:extend({ aquilo_islands })
