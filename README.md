# Ravenous Options

A library of functions for WoW Addons that allows easily creating Settings panels.

## How it works

This library assumes you have attached certain pieces of data to the namespace of your Addon, specifically:

1. `optionsTable`: a table (listed under `SavedVariables` or `SavedVariablesPerCharacter`) under which settings choices are saved
2. `defaults`: a table of key/value pairs, where the keys are your Addon’s variables and the values are those variables’ default values
3. `sections`: a table of structured data for each section and option for your Addon’s settings
4. `name`: a string representing your Addon's name/title
5. `prefix`: a string that is prefixed to your saved variables to avoid clashing with other Addons’ saved variables, e.g. `MYADDON_`
6. `version`: a string that is the version number of your Addon (optional; used for denoting options as “new”)

Further, it also requires a global table variable to save your variables under, which you should have marked under `SavedVariables` in your TOC file.

Use it like so:

```lua
local defaults = {
    myCheckbox = false,
    myDropdown = 2,
}
local sections = {
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
local name = "My Addon"
local prefix = "MYADDON_"
local version = "1.2.3"

ns:CreateSettingsPanel(MYADDON_options, defaults, sections, name, prefix, version)
```
