# Ravenous Options

A library of functions for WoW Addons that allows easily creating Settings panels.

## How it works

This library assumes you have attached certain pieces of data to the namespace of your Addon, specifically:

1. `ns.prefix`: a string that is prefixed to your saved variables to avoid clashing with other Addons’ saved variables, e.g. `MYADDON_`
2. `ns.version`: a string that is the version number of your Addon (used when denoting options as “new”)
3. `ns.data.defaults`: a table of key/value pairs, where the keys are your Addon’s variables and the values are those variables’ default values

Further, it also requires a global table variable to save your variables under, which you should have marked under `SavedVariables` in your TOC file.

Use it like so:

```lua
ns.prefix = "MYADDON_"
ns.version = "1.2.3"
ns.data.defaults = {
    myCheckbox = false,
    myDropdown = 2,
}

local settings = {
    [1] = {
        title = "Title #1",
        options = {
            [1] = {
                key = "myCheckbox",
                name = "Example Checkbox",
                tooltip = "Tick this checkbox to see what happens",
            },
            [2] = {
                key = "myDropdown",
                name = "Example Dropdown",
                tooltip = "Make a selection to see what happens",
                choices = {
                    [1] = "Yes",
                    [2] = "No",
                },
            },
        },
    },
}

ns:CreateSettingsPanel(MYADDON_options, settings)
```
