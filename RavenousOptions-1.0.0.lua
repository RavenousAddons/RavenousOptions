local ADDON_NAME, ns = ...


local gameVersion = GetBuildInfo()


--- Opens the Addon settings menu and plays a sound
function ns:OpenSettings()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    Settings.OpenToCategory(ns.Settings:GetID())
end

-- Creates a settings panel checkbox
local function CreateCheckBox(optionsTable, category, option)
    local setting = Settings.RegisterAddOnSetting(category, ns.prefix .. option.key, ns.prefix .. option.key, optionsTable, type(ns.data.defaults[option.key]), option.name, ns.data.defaults[option.key])
    setting.owner = ADDON_NAME
    Settings.CreateCheckbox(category, setting, option.tooltip)
    if option.callback then
        Settings.SetOnValueChangedCallback(ns.prefix .. option.key, option.callback)
    end
    if option.new == ns.version then
        if not NewSettings[gameVersion] then
            NewSettings[gameVersion] = {}
        end
        table.insert(NewSettings[gameVersion], ns.prefix .. option.key)
    end
end

-- Creates a settings panel dropdown
local function CreateDropDown(optionsTable, category, option)
    local setting = Settings.RegisterAddOnSetting(category, ns.prefix .. option.key, ns.prefix .. option.key, optionsTable, type(ns.data.defaults[option.key]), option.name, ns.data.defaults[option.key])
    setting.owner = ADDON_NAME
    local fn = function()
        local container = Settings.CreateControlTextContainer()
        for i, choice in pairs(option.choices) do
            container:Add(i, choice)
        end
        return container:GetData()
    end
    Settings.CreateDropdown(category, setting, fn, option.tooltip)
    if option.callback then
        Settings.SetOnValueChangedCallback(ns.prefix .. option.key, option.callback)
    end
    if option.new == ns.version then
        if not NewSettings[gameVersion] then
            NewSettings[gameVersion] = {}
        end
        table.insert(NewSettings[gameVersion], ns.prefix .. option.key)
    end
end

-- Creates a settings panel section
local function CreateSection(optionsTable, category, layout, title, options)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(title))
    for index = 1, #options do
        local option = options[index]
        if option.condition == nil or option.condition() then
            if option.choices then
                CreateDropDown(optionsTable, category, option)
            else
                CreateCheckBox(optionsTable, category, option)
            end
        end
    end
end

-- Creates a settings panel
function ns:CreateSettingsPanel(optionsTable, sections)
    local category, layout = Settings.RegisterVerticalLayoutCategory(ns.name)
    Settings.RegisterAddOnCategory(category)

    for index = 1, #sections do
        local section = sections[index]
        if section.condition == nil or section.condition() then
            CreateSection(optionsTable, category, layout, section.title, section.options)
        end
    end

    ns.Settings = category
end
