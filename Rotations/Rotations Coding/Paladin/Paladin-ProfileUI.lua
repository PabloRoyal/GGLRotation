local Action = _G.Action

local A                = Action

local CONST                                                              = Action.Const

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {
    DateTime = "v1.5.0 (24 April 2024)",
    [2] = {
        [ACTION_CONST_PALADIN_PROTECTION] = {
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Self Defensive ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WoGFreePlayer",
                    DBV = 90,
                    ONLYOFF = true,
                    L = {
                        ANY = "Free Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection1",
                    DBV = 45,
                    ONLYOFF = true,
                    L = {
                        ANY = "Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection2",
                    DBV = 60,
                    ONLYOFF = true,
                    L = {
                        ANY = "Ardent Defender (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Ardent Defendern"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection3",
                    DBV = 40,
                    ONLYOFF = true,
                    L = {
                        ANY = "Guardians of Ancient Kings (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Guardians of Ancient Kings"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection4",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Divine Shield (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Divine Shield"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "SelfProtection5",
                    DBV = 20,
                    ONLYOFF = true,
                    L = {
                        ANY = "Lay on Hands (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Lay on Hands"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Defensive Trinkets ] ===", },},},
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TrinketSlider1",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Trinket 1 (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Trinket 1"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "TrinketSlider2",
                    DBV = -1,
                    ONLYOFF = true,
                    L = {
                        ANY = "Trinket 2 (%)"
                    },
                    TT = {
                        ANY = "Player HP % to use Trinket 21"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Advanced Settings ] ===", },},},
            {
                {
                    E = "Checkbox",
                    DB = "AoE",
                    DBV = true,
                    L = {
                        enUS = "Use AoE",
                    },
                    TT = {
                        enUS = "Enable multiunits actions",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AutoInterrupt",
                    DBV = true,
                    L = { 
                        ANY = "Switch Targets Interrupt",
                    }, 
                    TT = { 
                        ANY = "Automatically switches targets to interrupt.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox1",
                    DBV = false,
                    L = { 
                        enUS = "Force Consecration",
                    },
                    TT = {
                        enUS = "If enabled, we will force Consecration if not active",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "Checkbox2",
                    DBV = false,
                    L = { 
                        enUS = "Movement Check",
                    },
                    TT = {
                        enUS = "If enbaled, we will use Consecration only while standing",
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Dropdown",
                    H = 20,
                    OT = {
                        { text = "Ardent Defender", value = 1 }, 
                        { text = "Guardian of Ancient Kings", value = 2 },
                        { text = "Avenging Wrath", value = 3 },
                    },
                    MULT = true,
                    DB = "defensiveSelect",
                    DBV = {
                        [1] = true,
                        [2] = false,
                        [3] = false,
                    },
                    L = {
                        ANY = "Defensive Reactions",
                    },
                    TT = {
                        ANY = "Select what spells to be used when reacting to incoming damage in dungeons.",
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {{E = "Header", L = { ANY = "=== [ Group Healing ] ===", },},},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "FreeWoGTeamDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Free WoG Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Free Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "WoGTeamDropdown",
                    DBV = "All",
                    L = {
                        ANY = "Regular WoG Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Regular Word of Glory"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "FreeWoGTeam",
                    DBV = 85,
                    ONLYOFF = true,
                    L = {
                        ANY = "Free Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Free Word of Glory"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "WoGTeam",
                    DBV = 35,
                    ONLYOFF = true,
                    L = {
                        ANY = "Regular Word of Glory (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Regular Word of Glory"
                    },
                    M = {},
                },
            },
            {{ E = "LayoutSpace", },},
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "BoSTeamDropdown",
                    DBV = "Healer",
                    L = {
                        ANY = "Blessing of Sacrifice Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Blessing of Sacrifice"
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "All", value = "All" },
                        { text = "Healer",   value = "Healer" },
                        { text = "Off", value = "Off" },
                    },
                    DB = "BoPTeamDropdown",
                    DBV = "Healer",
                    L = {
                        ANY = "Blessing of Protection Menu",
                    },
                    TT = {
                        enUS = "Choose, on which units the rotation should use Blessing of Protection"
                    },
                    M = {},
                },
            },
            {
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BoSTeam",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blessing of Sacrifice (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Blessing of Sacrifice"
                    },
                    M = {},
                },
                {
                    E = "Slider",
                    MIN = -1,
                    MAX = 100,
                    DB = "BoPTeam",
                    DBV = 65,
                    ONLYOFF = true,
                    L = {
                        ANY = "Blessing of Protection (%)"
                    },
                    TT = {
                        ANY = "Unit HP % to use Blessing of Protection"
                    },
                    M = {},
                },
            },
        },
    },
} 

