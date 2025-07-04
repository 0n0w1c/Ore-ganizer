local hidden = false
if mods["bobmining"] then hidden = true end

data:extend({
    {
        type = "bool-setting",
        name = "rmd-slow-miner",
        setting_type = "startup",
        default_value = false,
        order = "a"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-blueprint-resources",
        setting_type = "startup",
        default_value = false,
        order = "b"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-trim-mining-area",
        setting_type = "startup",
        default_value = false,
        order = "c"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-hide-recipes",
        setting_type = "startup",
        default_value = false,
        order = "d",
        hidden = hidden
    }
})
