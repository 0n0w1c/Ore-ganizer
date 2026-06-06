if not mods["space-age"] or mods["EverythingOnNauvis"] then return end

data:extend({
    {
        type = "noise-expression",
        name = "rmd_aquilo_resource_island_fallback_factor",
        expression =
        "1 - min(1, max(control:aquilo_crude_oil:size, control:fluorine_vent:size, control:lithium_brine:size))",
    },
    {
        type = "noise-expression",
        name = "aquilo_starting_rmd_aquilo_crude_oil_island_spots",
        expression =
        "starting_spot_at_angle{angle = aquilo_angle, distance = 40, radius = aquilo_spot_size * 0.8, x_distortion = 0, y_distortion = 0}",
    },
    {
        type = "noise-expression",
        name = "aquilo_starting_rmd_aquilo_lithium_brine_island_spots",
        expression =
        "starting_spot_at_angle{angle = aquilo_angle + 120, distance = 80, radius = aquilo_spot_size * 0.6, x_distortion = 0, y_distortion = 0}",
    },
    {
        type = "noise-expression",
        name = "aquilo_starting_rmd_aquilo_fluorine_vent_island_spots",
        expression =
        "starting_spot_at_angle{angle = aquilo_angle + 240, distance = 160, radius = aquilo_spot_size * 0.6, x_distortion = 0, y_distortion = 0}",
    },
    {
        type = "noise-expression",
        name = "aquilo_rmd_aquilo_crude_oil_island_spots",
        expression =
        "aquilo_spot_noise{seed = 567,count = 4,skip_offset = 0,region_size = 1000,density = 1,radius = aquilo_spot_size,favorability = 1}",
    },
    {
        type = "noise-expression",
        name = "aquilo_rmd_aquilo_lithium_brine_island_spots",
        expression =
        "aquilo_spot_noise{seed = 567,count = 3,skip_offset = 1,region_size = 1000,density = 1,radius = aquilo_spot_size * 1.2,favorability = 1}",
    },
    {
        type = "noise-expression",
        name = "aquilo_rmd_aquilo_fluorine_vent_island_spots",
        expression =
        "aquilo_spot_noise{seed = 567,count = 2,skip_offset = 2,region_size = 1000,density = 1,radius = aquilo_spot_size * 1.5,favorability = 1}",
    },
    {
        type = "noise-expression",
        name = "rmd_aquilo_island_fallback_peaks",
        expression =
            "(-1000000 * (1 - rmd_aquilo_resource_island_fallback_factor)) + " ..
            "(rmd_aquilo_resource_island_fallback_factor * " ..
            "1.5 * (0.5 + max(" ..
            "aquilo_starting_rmd_aquilo_crude_oil_island_spots, " ..
            "aquilo_rmd_aquilo_crude_oil_island_spots, " ..
            "aquilo_starting_rmd_aquilo_lithium_brine_island_spots, " ..
            "aquilo_rmd_aquilo_lithium_brine_island_spots, " ..
            "aquilo_starting_rmd_aquilo_fluorine_vent_island_spots, " ..
            "aquilo_rmd_aquilo_fluorine_vent_island_spots)))",
    }
})
