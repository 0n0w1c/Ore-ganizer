local hidden = false
if mods["bobmining"] or mods["bobores"] then hidden = true end

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
