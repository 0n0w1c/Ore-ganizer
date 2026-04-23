local hidden = false
if mods["bobmining"] then hidden = true end

data:extend({
    {
        type = "int-setting",
        name = "rmd-resource-amount-ttl",
        setting_type = "startup",
        default_value = 5,
        minimum_value = 0,
        maximum_value = 60,
        order = "a"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-slow-miner",
        setting_type = "startup",
        default_value = false,
        order = "b"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-blueprint-resources",
        setting_type = "startup",
        default_value = false,
        order = "c"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-trim-mining-area",
        setting_type = "startup",
        default_value = false,
        order = "d"
    }
})

data:extend({
    {
        type = "bool-setting",
        name = "rmd-hide-recipes",
        setting_type = "startup",
        default_value = false,
        order = "e",
        hidden = hidden
    }
})
