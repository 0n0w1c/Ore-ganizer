local hidden = false
if mods["bobmining"] then hidden = true end

data:extend({
    {
        type = "bool-setting",
        name = "rmd-hide-recipes",
        setting_type = "startup",
        default_value = false,
        order = "a",
        hidden = hidden
    }
})
