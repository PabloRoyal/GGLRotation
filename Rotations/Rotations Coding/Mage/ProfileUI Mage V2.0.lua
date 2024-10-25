local _G, select, setmetatable                        = _G, select, setmetatable

local TMW                                             = _G.TMW 

local A                                             = _G.Action

local CONST                                            = A.Const
local toNum                                         = A.toNum
local Print                                            = A.Print
local GetSpellInfo                                    = A.GetSpellInfo
local GetToggle                                        = A.GetToggle
local GetLatency                                    = A.GetLatency
local InterruptIsValid                                = A.InterruptIsValid
local Unit                                            = A.Unit 

local ACTION_CONST_MAGE_FROST                        = CONST.MAGE_FROST
local ACTION_CONST_MAGE_FIRE                        = CONST.MAGE_FIRE
local ACTION_CONST_MAGE_ARCANE                        = CONST.MAGE_ARCANE

local S                                                = {
    FireElemental                                        = (GetSpellInfo(198067)),
    EarthElemental                                        = (GetSpellInfo(198103)),
    FeralSpirits                                        = (GetSpellInfo(51533)),
    Ascendance                                        = (GetSpellInfo(114051)),
    Bloodlust                                        = (GetSpellInfo(2825)),
    HealingSurge                                        = (GetSpellInfo(8004)),
    HealingTotem                                        = (GetSpellInfo(5394)),
    StunTotem                                        = (GetSpellInfo(192058)),
    AstralShift                                        = (GetSpellInfo(108271)),
    Stormkeeper                                        = (GetSpellInfo(191634)),
    
}

local L                                             = {}
L.AUTO                                                = {
    enUS = "Auto",
    ruRU = "Авто ",
}
L.OFF                                                = {
    enUS = "Off",
    ruRU = "Выкл.",
}
L.PVP                                                 = {
    ANY = "PvP",
}
L.MOUSEOVER                                            = {
    enUS = "Use\n@mouseover", 
    ruRU = "Использовать\n@mouseover", 
}
L.MOUSEOVERTT                                        = {
    enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing\n\nRight click: Create macro", 
    ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг\n\nПравая кнопка мышки: Создать макрос", 
}
L.AOE                                                = {
    enUS = "Use\nAoE", 
    ruRU = "Использовать\nAoE", 
}
L.AOETT                                                = {
    enUS = "Enable multiunits rotation\n\nRight click: Create macro", 
    ruRU = "Включает ротацию для нескольких целей\n\nПравая кнопка мышки: Создать макрос", 
}
L.CDS                                            = {
    enUS = "Cooldowns",
    ruRU = "Своя Оборона",
}
L.Totems                                            = {
    enUS = "Totems",
}
L.selfDefence                                            = {
    enUS = "Self Defence",
}
L.stackManagement                                            = {
    enUS = "stack Management",
}
L.ROTATION                                            = {
    enUS = "Rotation",
    ruRU = "Ротация",
}
L.CATCHINVISIBLE                                    = {
    enUS = "Catch Invisible (arena)",
    ruRU = "Поймать Невидимок (арена)",
}
L.CATCHINVISIBLETT                                    = {
    enUS = "Cast when combat around has been begin and enemy team still has unit in invisible\nDoesn't work if you're mounted or in combat!\n\nRight click: Create macro",
    ruRU = "Применять когда бой поблизости начат и команда противника до сих пор имеет юнита в невидимости\nНе работает, когда вы на транспорте или в бою!\n\nПравая кнопка мышки: Создать макрос",
}
L.Ascendance                                        = {
    enUS = S.Ascendance .. "\nUse on bosses only\n",
}
L.HealingSurge = {
    enUS = S.HealingSurge .. "\nHealth Percent (Self)",
    ruRU = S.HealingSurge .. "\nЗдоровье Процент (Свое)",
}
L.HealingTotem = {
    enUS = S.HealingTotem .. "\nHealth Percent (Self)",
    ruRU = S.HealingTotem .. "\nЗдоровье Процент (Свое)",
}
L.StunTotem = {
    enUS = S.StunTotem .. "\nuse on x enemies",
}
L.StunTotemSlider = {
    enUS = S.StunTotem .. "\nuse on x enemies slider",
}
L.AstralShift = {
    enUS = S.AstralShift .. "\nHealth Percent (Self)",
    ruRU = S.AstralShift .. "\nЗдоровье Процент (Свое)",
}
L.TRINKETDEFENSIVE                                    = {
    enUS = "Protection Trinkets\nHealth Percent (Self)",
    ruRU = "Аксессуары Защиты\nЗдоровье Процент (Свое)",
}
L.EarthElemental                                            = {
    enUS = S.EarthElemental .. "\nUse on bosses only\n",
}
L.FireElemental                                            = {
    enUS = S.FireElemental .. "\nUse on bosses only\n",
}
L.Stormkeeper                                            = {
    enUS = S.Stormkeeper .. "\nUse on bosses only\n",
}
L.FeralSpirits                                            = {
    enUS = S.FeralSpirits .. "\nUse on bosses only\n",
}
L.Bloodlust                                            = {
    enUS = S.Bloodlust .. "\nUse on bosses only\n",
}

local SliderMarginOptions = { margin = { top = 10 } }
local LayoutConfigOptions = { gutter = 4, padding = { left = 5, right = 5 } }
A.Data.ProfileEnabled[A.CurrentProfile]             = true
A.Data.ProfileUI = {    
    DateTime = "21.10.2024",
    [2] = {
        [ACTION_CONST_MAGE_FROST] = {             
            LayoutOptions = LayoutConfigOptions,
            {
                -- Mouseover Checkbox
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER, 
                    TT = L.MOUSEOVERTT, 
                    M = {},
                },
                -- AoE Checkbox
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {},
                },
                -- Alter Time Checkbox
                {
                    E = "Checkbox", 
                    DB = "AlterTime",
                    DBV = true,
                    L = { 
                        enUS = "Use Alter Time", 
                        ruRU = "Использовать Alter Time", 
                        frFR = "Utiliser Alter Time", 
                    },
                    TT = { 
                        enUS = "Enable or disable the use of Alter Time based on your conditions.", 
                        ruRU = "Включить или отключить использование Alter Time в зависимости от ваших условий.", 
                        frFR = "Activer ou désactiver l'utilisation de Alter Time en fonction de vos conditions.", 
                    },
                    M = {},
                },
                -- KalyzInterrupts Checkbox
                {
                    E = "Checkbox", 
                    DB = "KalyzInterrupts",
                    DBV = true,
                    L = { 
                        enUS = "Use KalyzInterrupts", 
                        ruRU = "Использовать KalyzInterrupts", 
                        frFR = "Utiliser KalyzInterrupts", 
                    },
                    TT = { 
                        enUS = "Enable or disable the KalyzInterrupts logic for interruptions.", 
                        ruRU = "Включить или отключить логику KalyzInterrupts для прерываний.", 
                        frFR = "Activer ou désactiver la logique KalyzInterrupts pour les interruptions.", 
                    },
                    M = {},
                },
                -- Healthstone Slider
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Healthstone",
                    DBV = 40,
                    ONOFF = true,
                    L = { 
                        enUS = "Use Healthstone", 
                        ruRU = "Использовать Камень здоровья", 
                        frFR = "Utiliser Pierre de soins", 
                    }, 
                    TT = { 
                        enUS = "Set the HP percentage to use Healthstone.", 
                        ruRU = "Установите процент здоровья для использования Камня здоровья.", 
                        frFR = "Définir le pourcentage de PV pour utiliser Pierre de soins.", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_MAGE_ARCANE] = {             
            LayoutOptions = LayoutConfigOptions,
            {
                -- Mouseover Checkbox
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER, 
                    TT = L.MOUSEOVERTT, 
                    M = {},
                },
                -- AoE Checkbox
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {},
                },
                -- KalyzInterrupts Checkbox
                {
                    E = "Checkbox", 
                    DB = "KalyzInterrupts",
                    DBV = true,
                    L = { 
                        enUS = "Use KalyzInterrupts", 
                        ruRU = "Использовать KalyzInterrupts", 
                        frFR = "Utiliser KalyzInterrupts", 
                    },
                    TT = { 
                        enUS = "Enable or disable the KalyzInterrupts logic for interruptions.", 
                        ruRU = "Включить или отключить логику KalyzInterrupts для прерываний.", 
                        frFR = "Activer ou désactiver la logique KalyzInterrupts pour les interruptions.", 
                    },
                    M = {},
                },
                -- Burst Checkbox
                {
                    E = "Checkbox", 
                    DB = "BurstOnCooldown",
                    DBV = false,
                    L = { 
                        enUS = "Burst on Cooldown", 
                        ruRU = "Burst при восстановлении", 
                        frFR = "Burst dès que disponible", 
                    },
                    TT = { 
                        enUS = "Use burst abilities as soon as they are available", 
                        ruRU = "Использовать способности burst, как только они становятся доступны", 
                        frFR = "Utiliser les capacités de burst dès qu'elles sont disponibles", 
                    },
                    M = {},
                },
                -- Evocation Slider
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "EvocationMana",
                    DBV = 20,
                    ONOFF = true,
                    L = { 
                        enUS = "Evocation Mana %", 
                        ruRU = "Прилив сил Мана %", 
                        frFR = "Évocation Mana %", 
                    }, 
                    TT = { 
                        enUS = "Set the Mana percentage to use Evocation.", 
                        ruRU = "Установите процент маны для использования Прилива сил.", 
                        frFR = "Définir le pourcentage de mana pour utiliser Évocation.", 
                    }, 
                    M = {},
                },
                -- Arcane Barrage Slider
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ArcaneBarrageMana",
                    DBV = 10,
                    ONOFF = true,
                    L = { 
                        enUS = "Arcane Barrage Mana %", 
                        ruRU = "Чародейский обстрел Мана %", 
                        frFR = "Barrage des Arcanes Mana %", 
                    }, 
                    TT = { 
                        enUS = "Set the Mana percentage to use Arcane Barrage as a filler.", 
                        ruRU = "Установите процент маны для использования Чародейского обстрела как филлера.", 
                        frFR = "Définir le pourcentage de mana pour utiliser Barrage des Arcanes comme bouche-trou.", 
                    }, 
                    M = {},
                },
            },
        },
        -- Fire mage section remains unchanged
        [ACTION_CONST_MAGE_FIRE] = {             
            LayoutOptions = LayoutConfigOptions,
            {
                -- Mouseover Checkbox
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = L.MOUSEOVER, 
                    TT = L.MOUSEOVERTT, 
                    M = {},
                },
                -- AoE Checkbox
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = L.AOE,
                    TT = L.AOETT,
                    M = {},
                },
            },
        },
    }
}