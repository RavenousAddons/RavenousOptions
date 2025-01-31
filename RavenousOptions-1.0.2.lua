local ADDON_NAME, ns = ...

local gameVersion = GetBuildInfo()

-- Creates a settings panel checkbox
local function CreateCheckBox(optionsTable, prefix, version, defaults, category, option)
    local setting = Settings.RegisterAddOnSetting(category, prefix .. option.key, prefix .. option.key, optionsTable, type(defaults[option.key]), option.name, defaults[option.key])
    setting.owner = ADDON_NAME
    Settings.CreateCheckbox(category, setting, option.tooltip)
    if option.callback then
        Settings.SetOnValueChangedCallback(prefix .. option.key, option.callback)
    end
    if option.new == version then
        if not NewSettings[gameVersion] then
            NewSettings[gameVersion] = {}
        end
        table.insert(NewSettings[gameVersion], prefix .. option.key)
    end
end

-- Creates a settings panel dropdown
local function CreateDropDown(optionsTable, prefix, version, defaults, category, option)
    local setting = Settings.RegisterAddOnSetting(category, prefix .. option.key, prefix .. option.key, optionsTable, type(defaults[option.key]), option.name, defaults[option.key])
    setting.owner = ADDON_NAME
    local fn = function()
        local container = Settings.CreateControlTextContainer()
        if type(option.choices) == "function" then
            option.choices(container)
        else
            for i, choice in pairs(option.choices) do
                container:Add(i, choice)
            end
        end
        return container:GetData()
    end
    Settings.CreateDropdown(category, setting, fn, option.tooltip)
    if option.callback then
        Settings.SetOnValueChangedCallback(prefix .. option.key, option.callback)
    end
    if option.new == version then
        if not NewSettings[gameVersion] then
            NewSettings[gameVersion] = {}
        end
        table.insert(NewSettings[gameVersion], prefix .. option.key)
    end
end

-- Creates a settings panel section
local function CreateSection(optionsTable, prefix, version, defaults, category, layout, title, options)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(title))
    for index = 1, #options do
        local option = options[index]
        if option.condition == nil or option.condition() then
            if option.choices then
                CreateDropDown(optionsTable, prefix, version, defaults, category, option)
            else
                CreateCheckBox(optionsTable, prefix, version, defaults, category, option)
            end
        end
    end
end

-- Creates a settings panel
function ns:CreateSettingsPanel(optionsTable, defaults, sections, name, prefix, version)
    local category, layout = Settings.RegisterVerticalLayoutCategory(name)
    Settings.RegisterAddOnCategory(category)

    for index = 1, #sections do
        local section = sections[index]
        if section.condition == nil or section.condition() then
            CreateSection(optionsTable, prefix, version, defaults, category, layout, section.title, section.options)
        end
    end

    ns.Settings = category
end

--- Opens the Addon settings menu and plays a sound
function ns:OpenSettings()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    Settings.OpenToCategory(ns.Settings:GetID())
end
