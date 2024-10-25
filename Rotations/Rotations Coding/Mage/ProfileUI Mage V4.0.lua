local _G = _G
local Action = _G.Action
local CONST = Action.Const
local ACTION_CONST_MAGE_ARCANE = CONST.MAGE_ARCANE
local Player = Action.Player 
local Listener = Action.Listener
local Create = Action.Create
local GetToggle = Action.GetToggle
local TMW = _G.TMW
local GetSpellTexture = TMW.GetSpellTexture
local _G, select, setmetatable = _G, select, setmetatable
local TMW = _G.TMW
local A = _G.Action
local StdUi = A.StdUi
local Factory = StdUi.Factory
local GameLocale = A.FormatGameLocale(_G.GetLocale())

-- Language Support
local L = setmetatable({
    ruRU = {
        KalyzInterruptName = "Kalyz Interrupts",
    },
    enUS = {
        KalyzInterruptName = "Kalyz Interrupts",
    },
}, { __index = function(t) return t.enUS end })

-- Interrupt UI Category Registration
TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
    Category.options[#Category.options + 1] = { 
        text = L[GameLocale].KalyzInterruptName, 
        value = "KalyzInterrupts" 
    }
    Category:SetOptions(Category.options)
end)

-- Kalyz Interrupt List
Factory[4].KalyzInterrupts = StdUi:tGenerateMinMax({
    [GameLocale] = {
        ISINTERRUPT = true,
        -- Freehold
        [450597] = {useKick = false, useCC = true, useRacial = false},
        [462802] = {useKick = true, useCC = true, useRacial = false},
        -- Add all other interrupts from the list...
        -- [Rest of the interrupts list]
    },
}, 16, 25, math.random(40, 47), true)

Action.Profile = {}

-- Toggle Definitions
local AoE = {
    E                 = "Checkbox",
    DB                = "AoE",
    DBV               = true,
    L                 = { 
        enUS = "AoE",
        ruRU = "AoE",
    },
    TT                = { 
        enUS = "Enable AoE rotation\n\nRight click: Create macro",
        ruRU = "Включает AoE ротацию\n\nПравая кнопка мышки: Создать макрос",
    },
    M                 = {},
}

local AutoBuff = {
    E                 = "Checkbox",
    DB                = "AutoBuff",
    DBV               = true,
    L                 = { ANY = "Auto Buff" },
    TT                = { ANY = "Automatically maintain Arcane Intellect\n\nRight click: Create macro" },
    M                 = {},
}

local UseCooldowns = {
    E                 = "Checkbox",
    DB                = "UseCooldowns",
    DBV               = true,
    L                 = { ANY = "Use Cooldowns" },
    TT                = { ANY = "Enable/Disable cooldown usage" },
    M                 = {},
}

-- Defensive Settings
local DefensiveHeader = {
    {
        E = "Header",
        L = { ANY = "Defensive Settings" },
    },
}

local IceBlockHP = {
    E                = "Slider",
    MIN             = -1,
    MAX             = 100,
    DB              = "IceBlockHP",
    DBV             = 20,
    ONOFF           = true,
    L               = { ANY = "Ice Block HP %" },
    TT              = { ANY = "HP % to use Ice Block at (-1 to disable)" },
    M               = {},
}

local IceBarrierHP = {
    E                = "Slider",
    MIN             = -1,
    MAX             = 100,
    DB              = "IceBarrierHP",
    DBV             = 85,
    ONOFF           = true,
    L               = { ANY = "Ice Barrier HP %" },
    TT              = { ANY = "HP % to use Ice Barrier at (-1 to disable)" },
    M               = {},
}

local AlterTimeHP = {
    E                = "Slider",
    MIN             = -1,
    MAX             = 100,
    DB              = "AlterTimeHP",
    DBV             = 40,
    ONOFF           = true,
    L               = { ANY = "Alter Time HP %" },
    TT              = { ANY = "HP % to use Alter Time at (-1 to disable)" },
    M               = {},
}

-- Offensive Settings
local OffensiveHeader = {
    {
        E = "Header",
        L = { ANY = "Offensive Settings" },
    },
}

local MinMana = {
    E                = "Slider",
    MIN             = 0,
    MAX             = 100,
    DB              = "MinMana",
    DBV             = 30,
    ONOFF           = true,
    L               = { ANY = "Minimum Mana %" },
    TT              = { ANY = "Minimum mana % to continue rotation" },
    M               = {},
}

local TouchOfTheMagiUsage = {
    E = "Dropdown",
    DB = "TouchOfTheMagiUsage",
    DBV = 1,
    L = { ANY = "Touch of the Magi Usage" },
    TT = { ANY = "When to use Touch of the Magi" },
    M = {},
    OT = {
        { text = "On Cooldown", value = 1 },
        { text = "With Arcane Surge", value = 2 },
        { text = "Conservative", value = 3 },
    },
}

local InterruptConfig = {
    {
        E = "Header",
        L = { ANY = "Interrupt Settings" },
    },
    {
        E = "Checkbox",
        DB = "UseInterrupts",
        DBV = true,
        L = { ANY = "Use Interrupts" },
        TT = { ANY = "Enable/Disable all interrupts" },
        M = {},
    },
    {
        E = "Checkbox",
        DB = "KalyzInterrupts",
        DBV = true,
        L = { ANY = "Use Kalyz Interrupts" },
        TT = { ANY = "Use Kalyz's dungeon interrupt priorities" },
        M = {},
    },
}
-- Interrupt Settings
local InterruptHeader = {
    {
        E = "Header",
        L = { ANY = "Interrupt Settings" },
    },
}

local UseInterrupts = {
    E                 = "Checkbox",
    DB                = "UseInterrupts",
    DBV               = true,
    L                 = { ANY = "Use Interrupts" },
    TT                = { ANY = "Enable/Disable interrupt usage" },
    M                 = {},
}

local InterruptWithCC = {
    E                 = "Checkbox",
    DB                = "InterruptWithCC",
    DBV               = false,
    L                 = { ANY = "Use CC as Interrupt" },
    TT                = { ANY = "Use Dragon's Breath as interrupt" },
    M                 = {},
}

-- Utility Settings
local UtilityHeader = {
    {
        E = "Header",
        L = { ANY = "Utility Settings" },
    },
}

local AutoTarget = {
    E                 = "Checkbox",
    DB                = "AutoTarget",
    DBV               = false,
    L                 = { ANY = "Auto Target" },
    TT                = { ANY = "Automatically target nearest enemy" },
    M                 = {},
}

-- Profile Configuration
Action.Data.ProfileEnabled[Action.CurrentProfile] = true
Action.Data.ProfileUI = {
    DateTime = "v1.0 (2024.03.24)",
    -- Category 2 (Rotations)
    [2] = {
        [ACTION_CONST_MAGE_ARCANE] = {
            -- Row 1
            {
                AoE,
                AutoBuff,
                UseCooldowns,
            },
            -- Defensive Settings
            DefensiveHeader,
            {
                IceBlockHP,
                IceBarrierHP,
                AlterTimeHP,
            },
            -- Offensive Settings
            OffensiveHeader,
            {
                MinMana,
                TouchOfTheMagiUsage,
            },
            -- Interrupt Settings
            InterruptHeader,
            {
                UseInterrupts,
                InterruptWithCC,
            },
            -- Utility Settings
            UtilityHeader,
            {
                AutoTarget,
            },
        },
    },
}

-- Kalyz Interrupt Integration
TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
    local L = {
        ruRU = { KalyzInterruptName = "Kalyz Прерывания" },
        enUS = { KalyzInterruptName = "Kalyz Interrupts" },
    }
    
    Category.options[#Category.options + 1] = { 
        text = L[GameLocale].KalyzInterruptName, 
        value = "KalyzInterrupts" 
    }
    Category:SetOptions(Category.options)
end)